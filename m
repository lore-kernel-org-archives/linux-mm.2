Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6C3F606A330
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 14:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dkbDgXa9
Received: by kanga.kvack.org (Postfix)
	id D69FB6B05B4; Fri,  6 Nov 2026 09:17:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D41666B05B5; Fri,  6 Nov 2026 09:17:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7EFF6B05B6; Fri,  6 Nov 2026 09:17:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AB6DA6B05B4
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 09:17:34 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3F887C0DA1
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 14:17:34 +0000 (UTC)
X-FDA: 85404897228.29.18FB1EF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7A58314000B
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 14:17:32 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dkbDgXa9;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793974652;
	b=jhTGWaUIJxJujVDjYGEr0IAtuU+VsRaw9nYdgKne0AIKKhvIbTRA4+SHlqKKlWq6uyqQpL
	uqxx214gNqS8G6YbG+U7gKjv5gGVKNKguA3Ix9Oc5aG7DoHpTKjptNUWi2YGG6eJnY8e3f
	5EqUnzG+/dqNHUczMR758pwnnSF53M8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dkbDgXa9;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793974652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C6998j54hMzCksQFziWwL93rZ04Tbfc01l4jxthA7xg=;
	b=uClPnMpQQR0nvERi86VpKLCQiJYHrZuSugIQlPbrB6wHqMBiFb+6I73riUhL7iKiivjXlN
	5vOsq6F9r54gUI/20f/Wbv4WdMDGZCD8OXesKr4RG1FTLj0flVtCNwuY9bXUjbN2mmrx8f
	QjOXPbpJ4LTnXOTvFHz4+I6eWvgC49M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EF535601E3;
	Fri,  6 Nov 2026 14:17:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A25F51F0089F;
	Fri,  6 Nov 2026 14:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793974651;
	bh=C6998j54hMzCksQFziWwL93rZ04Tbfc01l4jxthA7xg=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=dkbDgXa9u3oj+08Vl8kuBq+lpN1QTdOG+sLOcpaAGzlRd4w5evIO7OWT3Ow38XZN5
	 j4yVAXCZOuJ2Todjle2ykecaDL9Q1QzvDw3wcQiB6TxYBDULHGEFsOFIj0vZSXdSth
	 C5AblNYqXlnfe0VXm2AY7wUZ6NBr6wSym04VoSyB3KlzxSjBTeUfXZROojnEkBVlqx
	 F8ykkf8PnlExPRA2G4uGTUHcgglQDXcoz6uPHBc/znhq+9WH9AM2P05bvWGPvvaWNH
	 fZnDWd28yZQNBAg83dLkgy7C+iw5pu/mwLtgehBdmDU4aDZyy1owZ6mGJIwuVtdZ4Q
	 1cqLG39PLKq3Q==
From: David Hildenbrand <david@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Sasha Levin <sashal@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>, David Hildenbrand <david@kernel.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20261105171801.2189772-1-sashal@kernel.org>
References: <20261105171801.2189772-1-sashal@kernel.org>
Subject: Re: [PATCH] selftests/mm: add CONFIG_DEBUG_FS to the config
 fragment
Message-Id: <179397464426.9151.10517393467431591853.b4-ty@b4>
Date: Fri, 06 Nov 2026 15:17:24 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Stat-Signature: f9wsr3gg8yeaz9rix66cwwqx5mapir74
X-Rspamd-Queue-Id: 7A58314000B
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793974652-645117
X-HE-Meta: U2FsdGVkX1/XjMugJmfhv+eRUQBKW1B+rb8Pm0WzZLON1RFwJ6912Jz0CCvK3jsTT6w/XernW8UShmjVKFjm1ZCI91xiKI4e86pZd+aBcgTBqi8ymmI/19gQPYTrWrlvz6GOkOxi7pczBoCyW344LQ54qalxBVfRtHQ/F5MJyCtEqdZJpR9qCwZCVzt8cjd5bJdbbOASQxnunnpWOTUMgmIHlpuZW+KyuobmgkN3WOkmXmUMDynFwksEOPLnh7cQXuWgam05yDTwS6x9ZDtPo64gRFyQMe4dRwJ2VpuEV2s6etj3GLh0fst4/YMqIJ8t8czCmr1Z7tlTKjawoAM5nVM44BQLCmndtFwwNxj1WcrJj2xeAicjU95d/9GrK5fVY5KmeSrzJNhCwiKMbT4tmd0cafbMD8gJu6ruP3hbsf3qNm2jHp1dzajoYtm0c5piS/kbS9QmDd/9/LMe+LwLyQJ34TFgxM6GFQ55wSgt8zPLgXzRawVM16PW4gu7zfPziC11My/eaouc6tTky5RKd7ZCjpBq0z8rvhr+XKOYE445sGKURZwpWrhc3zGNxDQd6x7aYtmmEazwh2gMh4WbqFBCoBqf0u/yKx9SBkCDgO6aixwnhV07p6kOHa5Ly4MpiuJ+lk+Pu2jMx0FjWMmZxSeuw268nlDmvlxl+S5uTRKn2faCMlPKdbd6aeF94Gzp9maK/1s7eBB2HYOULxNCXllnEfPGEvAah8UDQCRkl07n2QqNkBhYGgwpvaGnsxRtHmaS4TAArXWYWaVTx0k+89OruuzhggPvW6GhuaFNs1zF6UR7dJL2V8fvrweky0QvBXYlQxCch7Wsa3gYNug8RpJepkr2jY8+o0hE28xu9lgby5rS6/vxgtdpCpXDQvaC6oYi6e5t0L5i5cfdoneIHHb5fMQhiyoJ5gCq6RjTf5JlEwyOR0kOppo/p7EYZJuEYQtf8whyY7k1/F2OSvA
 lZU+XXmd
 Fj1zcW/hG7WqJXP4vfluwJXfj93VWlsymVUJTTab5elc6PVtkQpUkDBlaUOojPQ3J+BUP5NSYVLQW/b08kGP19DUDvzKPJi6YHd1hal0xrNdisDt2at3+xi23ygu0LtJ7HfiZQztVTPe/S8mfsx9j7k1hpJDo8rFkmB/00+1R5gsZ1OGi7Dfj4nDfNCQ8BtCsM5M7/00ZliKV3/+GP9e2qwSAqahKpjbgbWQw/exctZ0VuRCw492BEmDvE+zERxhJJ+Jx6O6uoqNQ53T8JQKsm2frqBrJGzjYELwH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 05 Nov 2026 12:18:01 -0500, Sasha Levin wrote:
> The split_huge_page and gup tests need debugfs, and CONFIG_GUP_TEST
> depends on it. Add CONFIG_DEBUG_FS=y to the fragment.

Applied, thanks!

tree: mm/core.git
branch: thp-7.5.misc

Applied patches will appear soon in mm-next, followed by linux-next.

Please report any outstanding bugs that were missed during review, so we
can either drop the patch series or decide how to fix it up.

It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
though the patches have already been applied. If possible, patch trailers
will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. Further, this is not a guarantee that the
patches will go upstream. If in doubt, please check the listed branch.

[1/1] selftests/mm: add CONFIG_DEBUG_FS to the config fragment
      https://git.kernel.org/mm/core/c/31ea5515

-- 
Cheers,

David


