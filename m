Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29CB9606A336
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 01:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IvXqZNSe
Received: by kanga.kvack.org (Postfix)
	id 325586B05B1; Fri, 13 Nov 2026 20:18:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D6EE6B05B2; Fri, 13 Nov 2026 20:18:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1ED236B05B3; Fri, 13 Nov 2026 20:18:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ED8F66B05B1
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 20:18:08 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4894EA7BB0
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 01:18:08 +0000 (UTC)
X-FDA: 85431963456.15.C85F490
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id A4A141C0004
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 01:18:06 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IvXqZNSe;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794619086;
	b=LY3Sa12PWkL4XLtdacGmH/QDmJRuSpnOYu9Xpl6n1yoQwVV6+xiu9LyfddRx/nDav5PSQ1
	NK44/kPaWH1Bp7dhEG9HGSX38g8H+cMyDiIk7pdZm5+TwE7ZzkU/9wbz/gjgW8GkozemfM
	/YYSE/bbFtE+85wVnYZlcqv+FyyIJjU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IvXqZNSe;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794619086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KJQaaiL9a5cez/GFapJEhmZC9doVvzp8eiHm2EiP6qo=;
	b=8lMIDNdCLaD/xR72hTkb8g2uIWf+C26foBhqzexwTiOFOYeM2GIiOIW0CMgxnBtLYMqtla
	+7avcBx0uo1biqvFtvi79nPyw/8T/JYoP0VM0M+zIkwpGeVgmFMr4mc7GxiaPNGJcFjvWk
	WPiw4ue9ZZTSyzOhG1SeVk/yLPzCjcs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 36779404E4;
	Sat, 14 Nov 2026 01:18:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D3D01F000C5;
	Sat, 14 Nov 2026 01:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794619085;
	bh=KJQaaiL9a5cez/GFapJEhmZC9doVvzp8eiHm2EiP6qo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IvXqZNSeX8nxjzrACfxp+FnrpSBEvh5OU7CzrSeI+urhNrhd5pX7qzHR6PoJa9I81
	 Mczal/8JRwufxM7lB4260f3N3xGee3FROSb8oNZbYbLWRVlCrz/IpgU0aC0mdUe6/8
	 E49REOp1Gl2JUlH1Hd8mD6K88E3hOZlTwtXbRR4MPoAKNi0S6YVg+96OggAWn6D3TL
	 5lS1zkDf/CeavRnDUSQ+ay9ShCVTA1GDXKyCbg5Th0PtMUWwfZ4D1j/LQuU7BhiT/t
	 Al6uo+V2K2hwO/bGKdv5wRmGYoUaZzMW4GfMWgIn7r9HHShQPhJXNnSY3AIPv7JwhZ
	 LUCzNs4LM0mGg==
From: SJ Park <sj@kernel.org>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH 1/3] mm/page_alloc: drop unused gfp_mask from zone_watermark_fast()
Date: Fri, 13 Nov 2026 17:17:56 -0800
Message-ID: <20261114011757.85670-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261113235238.3595412-2-joshua.hahnjy@gmail.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6gui67bpcuzsk8uaz8fxgb7scjiury7t
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A4A141C0004
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794619086-731883
X-HE-Meta: U2FsdGVkX18IYOYu5TlCJBUFO1J+hH614+VTrWpNkascj6T1Cob/9XZu2I6GdmYBXE5BHujGHDkFH//eZLXrknx5nLbc1gxLQGphRNcuYsttjC1r70SkVwHs7TdOluFTJK5dJghMCezGI03G2ZQbS11RgxZdF+lc5hhXrucG6w9+x9FeLpLiysadXj5aJQ+CmEDDzK1hJib/+B1po3vFKblmXutSSJwanEJ06OfRxYOcMORqHF7t39LaeRenFwAvJMfS07/mzTBhYGJ1dEPD0GeT6lTrmkxgBKuJ73I7OsMvv1E4mExJgaAvIVKJacFbDXfkNhNdt/+aWz/FVhOGWYZReqc3UHhmGVYr5PmzZdeyT1DAHohWcixGZ6wdw4TIulIFZcqNJEvGwQ53P/M5kUGYr0a7mQImny4Yh2S4bqfmLuv8S0L3tWnQHTdB50DOjpTBPqMxqRPFmv0kb8Fu4awYSBqQSQCMMwzcQ0pkigfsrcG+Gy+QRtC9Suk2L/mvFFOaeQl7hpwxEvQQ693SZ0r5w8AN/1xoClKWjFp6+8bVWfktY22O10W5CnX7n12o5kWPCIeA65GVs4sDlf5JGdLMVLb/QhHhtTMfBAN9rq5TFeJ9R34+DMMgafLuw5yBHxdzZgSu2V/Y+5Duy7EY8z7Qx3q5tZvjQJXfgWMtz3BT/aUq5yk4VLgvdnOePjggpnS+AGui4zZ4hB9kTjbyx6ePmPXtU0KUoxmpdhep57/hg8q8YE2h+fnAX/0Q7mDrlhaXyNRCg5Y2ko3ugIzmy/8/GQAQJfNrTtgiOa60vwY7wFWvTr4AXIVYn81kaq4zonQXmIvAQQ+Db88pQxdhXT6zW/jSA9lGzi356RxOk7EcU5jTU27ukSlPueIetTvrEZS+BfChl5AHn1/hSl4FB/N/Y15o4HKlJ7kVobnuSzm9Fn8DJE209qEgZtPUyN8qQAV+S2Jbhe0tNxlNKoc
 SD3BPnDe
 0vQW6efcj1ZgXNpBnDhx45MoyoImn2ToJUS4rouesXy4+X1Ek+cmxVqtxHiPxo8ylHlDUGy8mFfqZ1stun4Udo0B6lvcev09hgCnXf+v/PffvRa1WA4dIJBwP2OJDtozzvjguWdTdvkOaY48ddLtGojEKhd2KoEH+TkOqw3WiBCGPYPAfosKK4aQ0lI6nD5kp2ynRFF4PPTlDciR/tlwSmFIK4wxlVQWr5vSlJp2vGp5mmrkKl0UxFFWW7zt19ID+PDIgCAcvMOwPfqx3eV69rzSpW7AaoD/zTlfJAmy84ZRg9apOUvoB/ME8AT8K3Rso9TvYoXmYtlVxtkhHQJCIV3YoJAfQntBortVQsL4BI/sxNYNXWspsNvb58ohGDmGqygcX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 13 Nov 2026 15:52:34 -0800 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:

> zone_watermark_fast() has not used its gfp_mask argument since commit
> 2973d8229b78 ("mm: discard __GFP_ATOMIC") switched the watermark boost
> check from __GFP_ATOMIC to ALLOC_MIN_RESERVE.
> 
> Remove the argument, no functional changes intended.

Looks clean to me.

> 
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

