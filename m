Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DA5E606A325
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 13:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=OtI71pgS
Received: by kanga.kvack.org (Postfix)
	id 5C9C36B062A; Thu, 19 Nov 2026 08:34:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A1946B064C; Thu, 19 Nov 2026 08:34:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48FD66B062C; Thu, 19 Nov 2026 08:34:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 267DA6B064C
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 08:34:39 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B03EB40AB2
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 13:34:38 +0000 (UTC)
X-FDA: 85451963436.16.F87B22A
Received: from mta1.migadu.com (out-200.mta1.migadu.com [95.215.58.200])
	by imf28.hostedemail.com (Postfix) with ESMTP id F1886C000C
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 13:34:34 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OtI71pgS;
	spf=pass (imf28.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.200 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795095277;
	b=xNYY33rUO8HVfyY3XCYtObZEfp2lqaaWkmM0+w2EU7lCiA2X/x4gPBKEI1HZgLujoKsRYz
	hlkQz0Wz3pXoPl9WHFJ8CjsTSMp2V64h1bB6U4aa9JLoYKwMoAtSwNtbmhI3DMnd1IciVk
	4Q9RIlpppC6+dg77/kjs+E09CwwYKrg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795095276;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kbe/Wkq4rYrYN6MBYuFpuRQJ/7anrRHrUP2tno+KG7w=;
	b=ht5ZTL8A9kRMLb6C6PpoDC7XYDtNwsWLxyFtBRGXDdvYpScbHKVnWGM+dGDHNLzcn3L7Em
	d8wUysuEqDW4wxfdj6mN6RbZa2Nb3Nx8/PX9cSjjUs/mb8mJsUTcmhBTmOqXdV2UEIB8t0
	pua3HsS918EtvP2a1N7th9dK1vCUqjE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OtI71pgS;
	spf=pass (imf28.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.200 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=7aMmjfpfnJwpxpDpoLMqNeUVHrm4vinac7NGKcQYtyE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795095271; v=1; x=1795700071;
 b=OtI71pgSWNdYojCDMvf8TQCNArpg2mZCM9lgVO4JXCyzSwK/za+CPUthcjpH67yg1KlKvx+w
 C5djU9lXJs5Ksn8sVuRHpRcelESf6ngzOmAs/7LYCcQZ37dI8/uFIIaCQrnPkUkTIfgpojp9RgY
 L7uWkiFLUxKCcAFGgu968nF4=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id fb9fb7e65a471db4;
	Thu, 19 Nov 2026 13:34:31 +0000
X-Mizu-Trace-ID: fb9fb7e65a471db4
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH v2] mm/memfd: drop redundant hugetlb allocation mask
 narrowing
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261119-for-memfd-v2-1-59f2d8c9752d@kylinos.cn>
Date: Thu, 19 Nov 2026 21:34:11 +0800
Cc: Hugh Dickins <hughd@google.com>,
 David Hildenbrand <david@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Oscar Salvador <osalvador@suse.de>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 Hongfu Li <lihongfu@kylinos.cn>
Content-Transfer-Encoding: 7bit
Message-Id: <E8842E0E-E559-421C-BFC8-1B91BD416EBD@linux.dev>
References: <20261119-for-memfd-v2-1-59f2d8c9752d@kylinos.cn>
To: Hongfu Li <hongfu.li@linux.dev>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: F1886C000C
X-Rspam-User:
X-Stat-Signature: kh6ig7qjo75atwocqye4nkcxzwfm3chz
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795095274-863415
X-HE-Meta: U2FsdGVkX1+mU3E6UXBDhxtvpKOfP50pYy0Fd6wEK2JWVVwvDJAMEuxAwKIVRQtnM4K6JCUtoOtiffJGskRzpj0B8JBjeVCqL/THtWB16MkyYt1LkNRuw6qqPXG7riDzlLHxk0A96BXDi1hRbv5MBs0cp9nUzIhlFOOyeSXKbCaODmceRHsxcgyLUakuRSzaD+7IXNkDyj8Mqw8rUttj9V2CPFOX8DmLEX6ioFLrHQhrvxy61rBtbsjO4SUmLnY1eCq1B9b/YKggaZwzl9LNqzSW9ahtL18IAmlpzpyHCEEbe44nxlO7uXvz4y7eaeR27KfqKkAS/qh2Qshn9ieqozjiIRu5+UWo/34V5Wvxq3e0WPthfxNZy+p4dhp97/44VX/eyZJsHldXynn2Y7yJeTIv8Bsv3evHsC4mczAL5f4G/GOLulXUCkfazz17oCnuoHXh/hONyXxJhcsrSJZre76+HGzB5jlBvtOpXDHmVmaelZOWje0wbUVEe2Nrj8KWZziefD5sR8wNUXPvRoiTN1yCKngKcAPLWBU4rm2g0jMt4cuFmGHHANUp9d0hZ+0lcpOIkl+Ferud8BUQMFZCePLcINHkkIfDmR42nKZNdKTHRhiD5Io3BeKyJy7U/BndcthcI8veiEula+uQ4B00SbnBwhlkOnhFDf0+DOuzHAVgkya3l7/pbNx49qT1QsJYHlXV+75JuWvHoO3jzYezuifw3J2eY0iWVV0DEbyG4PIMAL/LFmD/kErCBiUZ2Mg43BYZfoDfdBxWMZmBZfAohDUlZJStO0q5KTElo7iTEjWGXMcFPa+Bfg/BkyOFkOfb1vOKVS1mbQ+mRD3AoJUiMg9Hb8JJbJ4LycAdhmo7y3LRSAnOdNez2LUL9EUMLfM5vfb7VhnuDFPV5YnYSBPw9HP0RAlo+0SEhK+ioQFjTiNjxP6+dZZmbvL4sxy8LjNZQ1t0jP4EgRPDr4Aou5D
 iWe+vV20
 C8MKBQoaMePBm4aUhoTepMOyFJiWOmYfv93HAC+F21+GHMLwyNTQzls6eNXQ0HiKqSoacltGXjHUVBeA+8etkn3GJwmCv1gjhZu7eU9JRLqDPG4Zar55wikNOjMmyrpYlMFdPYEW9Ufgfc7e+jh3csLBbnIJHfiDLxv8WawAgog4tXDOV14nsRcEV449bPplsQ9rBHS/H26GCaCh9APnwr8PmyMwPwUhLbpsDzE2r1c69pTWd0qgROyiFYNd/bQYDHINE0Mh6S8dmVR3iFzDfW26UO16uBKhkyxHXts8VSbr6qzYirj34cARvSH9inK4L2N91eesB9Wwa8Wop9osuWqRlQ64gH8LlNTuOoS4ckaIdAzkjET9FxrSEj5fPjxCtydLBRXlzZvsZynvW9iqii5hnS/TNNzGAotZfJegZTaQ2UA/KG52aOduKBk/9wfm1zzYMCjOFAdYB7uDBtPPNAJmdXw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 19, 2026, at 17:49, Hongfu Li <hongfu.li@linux.dev> wrote:
> 
> From: Hongfu Li <lihongfu@kylinos.cn>
> 
> memfd_alloc_folio() derives its allocation mask from htlb_alloc_mask()
> and then clears __GFP_HIGHMEM and __GFP_MOVABLE. This mask handling was
> introduced by commit 89c1905d9c14 ("mm/gup: introduce memfd_pin_folios()
> for pinning memfd folios"), when the fallback path in
> alloc_hugetlb_folio_nodemask() could still call
> alloc_migrate_hugetlb_folio() and reach the buddy allocator, so the mask
> decided the zone and migratetype of freshly allocated pages.
> 
> Since commit 26a8ea80929c ("mm/hugetlb: fix memfd_pin_folios
> resv_huge_pages leak"), this call site uses alloc_hugetlb_folio_reserve(),
> which only dequeues folios from the existing hugetlb pool and never falls
> back to the buddy allocator. The mask therefore no longer decides where
> any page comes from.
> 
> Long-term pinning safety no longer depends on the mask either:
> memfd_pin_folios() obtains its folios (dequeued from the pool, or freshly
> allocated) under memalloc_pin_save(), so PF_MEMALLOC_PIN makes
> dequeue_hugetlb_folio_node_exact() skip any folio that fails
> folio_is_longterm_pinnable(), and current_gfp_context() already clears
> __GFP_MOVABLE from any page allocator request made under PF_MEMALLOC_PIN.
> 
> Clearing __GFP_HIGHMEM was a lowmem constraint for these folios, which
> were meant to be accessed by a DMA driver. It is not required any more:
> the users of memfd_pin_folios() work on pages and scatterlists, which
> support highmem, as does the shmem path with its default
> GFP_HIGHUSER_MOVABLE mask.
> 
> Drop the narrowing, which has had no effect since 26a8ea80929c.
> 
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>

Acked-by: Muchun Song (ByteDance) <muchun.song@linux.dev>



