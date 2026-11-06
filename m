Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90C6A606A333
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 14:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Wk+SZxiM
Received: by kanga.kvack.org (Postfix)
	id BBBE96B05B6; Fri,  6 Nov 2026 09:18:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B93BA6B05BD; Fri,  6 Nov 2026 09:18:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD07F6B05BE; Fri,  6 Nov 2026 09:18:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8AFEC6B05B6
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 09:18:03 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2093D80D65
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 14:18:03 +0000 (UTC)
X-FDA: 85404898446.19.E387146
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7B639C0010
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 14:18:01 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Wk+SZxiM;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793974681;
	b=Anik98gEbC6uONNfaKW4Ta7sWVdKy0EBuyiE36VirZOOOHcVntQrGuruXHV9pyJxFVgnT6
	+yeTYJn/D8mZvtTQkYRGqvwCsD/nKNp9ixYLC3vfWcxMsxEbCdFqoJ1nJOM0QEozmjtwvs
	cmm/7qCGi7JegHoB9m3/OXx6cakMSXQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Wk+SZxiM;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793974681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CKIHf3OuOvVhhpjIT2Z7Y0q/g50O7bhUDTdoEBDp0pM=;
	b=q7uQdVik7pKCvbdIxE1xSlp85A3wknLzWuw0EhHKluCYhHXr7E3deriEuzaF1qYRMg8hAA
	3IhPwOsAk+cKuPURJDz0911eZ/hFPGjicFKmbKPuft03/Inv/MzxuOJ5V7vyOUVDWWkO+d
	jvZIz62V6hacXzsf1kyUN8uK3Gny+vA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 25FEE602D4;
	Fri,  6 Nov 2026 14:18:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 880DA1F0089F;
	Fri,  6 Nov 2026 14:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793974680;
	bh=CKIHf3OuOvVhhpjIT2Z7Y0q/g50O7bhUDTdoEBDp0pM=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=Wk+SZxiMm5gTpWtlAhHjoOQe/HhgStlQ9toblskRjXi8q7qfd6NHBiNw6XchB2NsU
	 0wlsp0v2HXwnkk+X5Tw7V1imz/B/XsJwAR2HOyZxWq8MHX8WfX63KY6OVx2WrJDrUg
	 bJou11opbt4I0rq2CxLnQBFEYk4rTVlVv1Ub0NGpEvsnMkuvTqjlcQF4H94fJaSVIy
	 BjrAKPAD0Md+/eJJK3i1A/S8qr/EpUFNrUO6kQTqPKTFwx4i6iD6KNBP0xWRotz7Ad
	 TE+DyscmrEDjGiKUft4vu5tloisCvjpC1tsGPE2K4UyIIYPpmTkOySzCIaBW6K6oGO
	 ZIfppdults0OA==
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
Message-Id: <179397467526.9397.17872200045070830000.b4-ty@b4>
Date: Fri, 06 Nov 2026 15:17:55 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Stat-Signature: 6oqo68ezo88otfkdt4t1uj4ww6r9jw4k
X-Rspamd-Queue-Id: 7B639C0010
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793974681-377396
X-HE-Meta: U2FsdGVkX18beJLjf4hGRQbpNO8o9Zng2uot8gK1P2CT4AD9SHnh1SWIx08j6PqzyRGzmichVfJ3MgTTMmzk+GDd7UjoE++/qSXHJHViWW8haqYFOT+m8jto4mKzHvRrEA+NWevFAY+D04ITzHkIpVJKecXuk+sD8Q3/SX6yEq/TS+jZijPkOBxTa0aYJCbP/Iu0UQ6Q5v4qW+wGc0bFa9hL0xIW/QeJEHoY0pMJfxBTy/rQXdEIlEmSo5xMjIEufQPBOUPErMM0klwVe6YhhY2dxhNT5y3WlVUgl3vAdH2AqHV634DoWxYwmHuNET46Z68wc3ekhaTysVMGVrhucRK++wRzCU82+QP6stXzzDDm0fCKot0S/b/xosHKrSs9+TdXr3+Ws3oy/S1zPsdnBF3l6jyvCYd4UsGB+riIeJvxIYYPqtWIJSiPij1l6cLbceK/5bmoZEtUGFk/xCaWKw/qpvAWv8WC44OQ9BsuCHEWjvYaMEpeTcyGjFxA8/PEDUaCKJkXAl0j5noLCv8Gn2M65W5B3zR64Zpxdl6+yUnS2X8jXZ1qou1sQOMocXkpwkVESXH6C0o/8WdVtzOl0U1UDPHEj+yLFbdbUndw059JPhwuizmS/cm1LfDQ75qBteXvyJiR4gYTk0apnLf0lr6CNYiZHN58XiIwpXNCaJOdtsMgXMmiE2f2PP/TCr5EqFba9KMe1sRecjrObhqo+AomV7tLNbckB+hY/BEeBFat4gTg+Kkw2/dSGanNKQmkD0D7bpWV2qgeOvUZ6bZ8nNG7iRudKLS8GVZXts8INAmVxfrB00l4utDEHBgSAJ8LId9YeqkDCmyv8+r4F0DXLycrWhGXjy7WAUvv+jWz1HUUCJrQZBKRy4rlP+Gq2AQ9ge4vUAEznm+O8JfYrwytULV70uweQSPOPr2ODvGsYoINFAUAgfOXQ2RjS3eemcj3mKsS97dqyMnWDHBNi3v
 X31t/DBl
 zkMolmPHzHs1tiY+MmdeXKTMj8NqpcdO/lwUd9TMJa/Cu1VpuCEbjC4KFAGAUQnv9Jt/HX7FLRG//gm9R7NILzEKvy9o831iMlK5X9HJbjf/3B8KV+791rloLTWRWI/I/+8+qkK2HNWKfCJRgjHLU6h3ta/9QGmfR8vVJLBJBn/eZm9vG5fhdfG6VYIUVr8KPYqVldv7nu8k6vnLPKwY26oJx3O5Sp23cUv+MkyYzyFffeKoD2iq7SC/LnUBzg03+DrbJhd+g6s4BTepDsR4TrZo719Pd5Eld7sKS
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
branch: core-7.5.misc

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
      https://git.kernel.org/mm/core/c/194b6319

-- 
Cheers,

David


