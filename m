Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D645606A323
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 20:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=YTuAxPUD
Received: by kanga.kvack.org (Postfix)
	id 1927E6B05B2; Thu, 26 Nov 2026 15:23:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12A9D6B05B3; Thu, 26 Nov 2026 15:23:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0404B6B05B4; Thu, 26 Nov 2026 15:23:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 819966B05B2
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 15:23:26 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 53FD280421
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 20:23:24 +0000 (UTC)
X-FDA: 85478395128.27.CC9203F
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf19.hostedemail.com (Postfix) with ESMTP id 5BF801A000A
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 20:23:22 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=YTuAxPUD;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795724602;
	b=s0wwlSj2kMs6MaEYJ8fresdHgDS0UI2w++26RpW29X/xE8YvI9CKKEnWveCSzyHC5jmnh3
	p0LItUtlfK6QdgIU+01uVHPTZ1RLDXGMJ01DMoBj1mxTdvkA0VR28nnXEgI/ZHFqJ/u7HM
	BVshB0SUxN15xYZteZGvprdD8wtwruo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795724602;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nwNmT3+N2K6C+WQBtWD0mcJtZx8RSgDfIN1Kq5hD7g4=;
	b=wCwPROoOvstbzMW7NZRwaU7WEARyGL4Qiil7cTXkcuZzadAqxG9Z2Jbjm0TYVNN/+CuQjO
	Hu1noJVRu9Y2PzZwfKByx1Te4UOqBQ2Eu45nef0oIs2D7/HZvLe+SEaeJAGmvW5WxZ4TN+
	G30A0bJRa8t32yVsWpDL3D5x8943wbE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=YTuAxPUD;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=azpijr@gmail.com
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-4a358881793so3918245f8f.0
        for <linux-mm@kvack.org>; Thu, 26 Nov 2026 12:23:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795724601; x=1796329401; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nwNmT3+N2K6C+WQBtWD0mcJtZx8RSgDfIN1Kq5hD7g4=;
        b=YTuAxPUD6OgVEgOw9srdBLInSobhNIzYVJgXN/6c+iNX+UydoyVPjnqeO1+XzqAbxy
         s99Z1XeB0Dn80pwRw2JMfZOsxWJsTm3z4RSPVTrzQasPivB9x1CD9krBNeksSr8kIoil
         wSsDzMmbjB27837ggMHQtc27JSHkfiK3mdWgRzTAJnwrdE5XKumczBGEkw5oxP+WIF/x
         5jfleRkhDW/OSVYKlalIsEK/bE5TxLpU/qOOwX7Ewogkp2M5PvFUUMlevNJku8aegHSL
         K+Q5fbUan4+23Np2SUeL0tK3WLRoKD9J5HLIDUQZKrKDrXrtg/YOiyLwOL7dyG53HwCm
         RARg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795724601; x=1796329401;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nwNmT3+N2K6C+WQBtWD0mcJtZx8RSgDfIN1Kq5hD7g4=;
        b=lJg6OrKhOTp30Gd109/j3aoLG8RiYqwI5UkvUdjg3oh3q5H+n1erb3rAOqVB3086N/
         y2Ir5fpRgP7Ggtxep/R36JVU+V8TXRQCzbiahtJbaX24am7JBUpJn5c5xRG5p6mcufdb
         ccJRJZV8IpUgTGimiGaGZOjul9vMGrXh6YsvKVOF01z+tYlNkCIK1gFr6OnLTmOhhWLK
         cN8SN/fJUTiyNxRs8HekeAR0/DPuNhLdF1t9h99t5VnPGs2Gyusj3r9gthW4t/Xx44hm
         xnd5BT63l8b4dRT2M1i4XPVpIx3DnI299+KLHngEFseLwAuEMKEap7yHrHDSlpYZcgyC
         QhBw==
X-Forwarded-Encrypted: i=1; AL+hErEiuJoM4I4lufb8QDz9smtfIRAKo6+Wwp+oX/4w2K/e8qAU2aC8YIxkHYomMzF6n/kIuv2rTyKRiA==@kvack.org
X-Gm-Message-State: APuU4Z9yXPnaZHN3fDMo54H5xFodX6jbTf7h9ghONvCqx9X4L/OxFsF/
	9H/uLHHT9W9nhgBWyD4DDTjA4DqLPrIb2MGvyRyhUPmhhegAUTSTjVKo
X-Gm-Gg: AZFdTZd6kysN4oIvfu8LmjMv1yo/pSJYgZSLGo2L2DUKZneTYdSdJXAsrwq8UwsthX9
	tNZiYcAb1mdu6d2zWKOIiBVSfPsmEWTzXbuTaHwWsz1wCGMqO2gN0XD720Z+ZnkOkdECE3ywkp4
	9u9ZU9C6I4LCcgtfGE2MBYtwTxeEABgRowf9GNvFB+Z7eoiA8f3LPTFOc22omR8bn+SYfRuIvbU
	sw22Us8qpmfEdAiwNyuUOzJ+yO6Ms+csAxQr7PtsnExNmL32kj5qlQSx2GnB9Kle4Qx7xqgz12J
	h9zoPTwL/i4ZdEwLZOPkOmK94gGGp2cMnQtH/0qpTd/2EnS6jgvDDp6maCY43u+ysGIFW9s3haq
	0EH90sQugd2pqS3KC+vcWTauvEYcIbAvLRTHQvU+wiEEzoFgdPB3CaX8esATVV9ILeEipzkYPxZ
	sgy62lTPtKLDKDUdS1mmUM1TzYtS0maZaCYba/KNcLyMmeHp3glqKV651h71b0rS7Eo3GRSudRn
	7BiCOEAe7M8XXWADrPGobKafi07KJBz6hPQFb6IsSaOtanmaGmWvhdHNGcrzTqB2tJmHtayZFfC
	A8mIztmvcxjNninbXp3QJmMbP9VzzU1M6m2dqGD+MHkujA==
X-Received: by 2002:a05:6000:2586:b0:4b7:760c:70db with SMTP id ffacd0b85a97d-4b7760c713cmr19227429f8f.4.1795724600577;
        Thu, 26 Nov 2026 12:23:20 -0800 (PST)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab6bb989eesm43021525f8f.50.2026.11.26.12.23.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Nov 2026 12:23:20 -0800 (PST)
Message-ID: <c5bc383d-fd32-455a-b946-e5f232c7fdf3@gmail.com>
Date: Thu, 26 Nov 2026 21:23:18 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] mm/khugepaged: allocate page tables before locking
 the folio
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Zach O'Keefe <zokeefe@google.com>, Lorenzo Stoakes <ljs@kernel.org>,
 Dev Jain <dev.jain@arm.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Hugh Dickins <hughd@google.com>, Kiryl Shutsemau <kas@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@surriel.com>,
 Song Liu <songliubraving@fb.com>
Cc: "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
References: <20261125100058.15200-1-azpijr@gmail.com>
 <20261125100058.15200-2-azpijr@gmail.com>
 <042ab922-4707-4c96-80a2-83a0378646d1@kernel.org>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <042ab922-4707-4c96-80a2-83a0378646d1@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5BF801A000A
X-Rspam-User:
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: x9y9i8ea6886xdtz1w31feoedbtt3pkp
X-HE-Tag: 1795724602-502670
X-HE-Meta: U2FsdGVkX1+QIzAfy2MCqJNWwHvx7bx3bNFzQQiZOX8MCyVE+3fkzlg4VeV1WpkQnzkN8gw9CtLoejW6qU3Jrv6zo+GJzmMbDGv2AC8B7iuavPZr9Y67IPx4d0NAoNu0kLLNR4kZTPBijTxC5aHba7uji8iJ7C2nd0ykEx1myrm7tlNbZR+vYy2zx66srzMUtdTp4ohz9bCTDoDS45dLZCHcjRNlfwx9d8Pa3S8mVEAyEh3K8Lq50NeSDdM5Z9lCxBkNnuVt1tsD/zBaifA7slXnxfU/Z1YrRr7ZvtuRGrU45ByLOp1N4R3I9m1INdCqES+LlkTOZO2JH6BIlOGP8GS7B0Ycbpa+cLXCjbrsrhCbbW7ke5pfyrpgAZfC4zrFa4PRf54W8GVay8grtykKEBEc1iw0zcGV/X+QVquFOUiqBjrpmGqFWM0Ew2ZSiRGSiFE2vs8ZyWAzufn2DnnHoDfj4OTX1LzOvoNFNmzaA+2VYbl9eAszJ6BS/hTL2kAP1Zcq+RcQ5ZuyZ2diPbp1tOxgFmEFbRH0es6bCgcniWWZrCX2noJ2580o1dZj1JN6qclhOcGukwcf30scotR3szJaIJrDzMADQCpA6n0gXcngLwvdxplsz1+Cfc+jBwutgpKNQrsL6b7KmPrihozWvrpCSjViIICSYPzsLcmf6kCekaTDny0Aa4Vfv2wldmC9pmhSFbWUjgxNGge9L1IiYewhVwIEdoaHu15b9b7Yir8xp6BCqp1rwHBUWD0kIRhptefz+iL6zkWLIPePp1vht3yN1DhaD9C6F/CKM1AKrxj+cNVxOFcuA2EoGO0rka+p2JlXXErZB7Wp7JhdaidG2yfeefNQNcOzFhzZSkwJ4TQdXrvIuGs5IQRdyoRi/eLtdkN1pyERTIQE4ZxNOGw4IaojpuzjrxaSXhJTTqyoNgKRXyT+FAzySEoAntcT04In0YeUfuHwhhDTR8smGUj
 ekxuk6CN
 8F6HHNVFO8BDhOJaCMAgzTmBnoivPv4wDPTDr9gMC5s5V21bvdXaQKlbuJUnDeFk9nPUJ2xYTotzJfpHM3wZY/P4tlRJBLyVd/iihqsig12dhuSUFdu4FWU5RHycmpYByZTPZe+zHQi47SLOu5InYhVxsGOgFSI4ntI3uDY0eZKWtgsQeOERl0o62ic7BlThljUwyDn49C05r5lp039DM+iMT2kzT2RyzrM4AvJcvUX5Q1+WmR76ZM7yekeW7WZq3P2BfvEv31nM0B7g6z9goeNDsoGpBRdU7IpKsRzsRbA6k1N259ti6ZzbGl6TyZc0mblci9vTz2+iljeUTF33wrLMvlhQgbJ+xHALRCkctq0OvMkJVQhmUClwAii3DCIaPZlT8QpmfL9uLiz3LmhsGCa1wBM0ToZS+qP6qZ84JnMEgvlm2vV0bKwQriZglu0a6ghefAs7OZIYlIBtNujtTz6GyMJFqMgccrHsPt2Un5Ysqb+ja2HMK1KjMWaDRAuRBU8sUxKRDC0+OQAiBkzBqTkCSA48xmmP5kXlS+WlyhJIENBJ+0abWPdEUBEN2y0f38wqpG7zIqM4N8b6qCtlzSwt+QgAdQdt0qGYHOytH52eyCd8/zf7+F593Pl5hhF3CkioNy1H2lKDZn0yvdKkXrwWz+QhEUw80WZDtP9Wm3aR/CGhyramOwi+2XnoqbrLc+8yPCheVbcwrzJc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/26/26 5:24 PM, David Hildenbrand (Arm) wrote:
> On 11/25/26 10:59, Jose A. Perez de Azpillaga wrote:
>> try_collapse_pte_mapped_thp() calls set_huge_pmd() with the folio
>> locked. set_huge_pmd() allocates the missing p4d/pud/pmd tables there,
>> and on ppc64 with the hash MMU do_set_pmd() also allocates the page
>> table to deposit.
>>
>> Allocating with __GFP_FS while holding a folio lock can deadlock in
>> reclaim. For example, memcg reclaim on cgroup v1 waits for writeback
>> that may be waiting for the folio lock we hold.
>>
>> Allocate these page tables before locking the folio. The mmap lock
>> keeps the upper levels around, and an unused deposit table is freed
>> after unlocking the folio.
>>
>> Fixes: 34488399fa08 ("mm/madvise: add file and shmem support to MADV_COLLAPSE")
>> Fixes: f8a01513f574 ("mm/khugepaged: do not fail collapse_pte_mapped_thp() on SCAN_PMD_NULL")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
>> ---
>>  mm/khugepaged.c | 79 +++++++++++++++++++++++++++++++++++--------------
>>  1 file changed, 56 insertions(+), 23 deletions(-)
>>
> 
> That's a lot of churn for a corner case (powerpc with hash MMU).
> 
> What about simply running in NOFS context when allcoating that page table?
> 
> Apparently pte_alloc_one() doesn't consume GFP flags ... but we could add NOFS
> around the allocation.
> 
> Any reason you went for this more complicated solution?
> 

no reason, it was just the solution I came up with. I'll rework it with
NOFS then, it's a lot less churn.

-- 
cheers,
jose a. p-a

