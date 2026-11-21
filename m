Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DE55606A320
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 20:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vMRcCdjv
Received: by kanga.kvack.org (Postfix)
	id 3EF736B00EF; Sat, 21 Nov 2026 15:13:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A0366B05B0; Sat, 21 Nov 2026 15:13:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28F206B05B1; Sat, 21 Nov 2026 15:13:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EE2846B00EF
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 15:13:40 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6AA12C05D6
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 20:13:40 +0000 (UTC)
X-FDA: 85460226600.20.0CD2415
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	by imf22.hostedemail.com (Postfix) with ESMTP id 87B54C0007
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 20:13:38 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=vMRcCdjv;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795292018;
	b=YEDfDdgU9Fw/kNRIQ/xwGWOtqYVcET9wjoktuRK8IweRn6vkt5GFLLOKVvL/ieeFChBt35
	KA80ArBWrJN82BgzSA5USQRhiK+kvnF9Xlt+BdmK1QtB1WF+JzzMsgeC9quCnht0Ra5l86
	6Ah6+fEmM3TLxN3GB7ADWXQJoZfMDW4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795292018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LtZDpCvLJ0VvtED3yvRJczLNhRGhJEw9NB2kLqULBmg=;
	b=Zdu5dglDh7g+5IR20+Beu5HGRqV9fkGZsAZOWiDASfPrfajFJKQw5NawFwaDQo1MWqhoA6
	uk2ZhuMSrXlLf8174cQvnrDcQyWE7zE/9SrAKHJU905IZ2o4sgT63f8ieR/8j0kzp6kSrQ
	RFpLlEGLfmOJS9qAXTWi48V9/PPAZog=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=vMRcCdjv;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-3b3a914e4c8so1096086a91.0
        for <linux-mm@kvack.org>; Sat, 21 Nov 2026 12:13:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795292017; x=1795896817; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=LtZDpCvLJ0VvtED3yvRJczLNhRGhJEw9NB2kLqULBmg=;
        b=vMRcCdjvVHm4HhE6zi4BFI/vjWPe82AdwJpNs3Bzfy9ByZko1ZcnxPUxoAmYG7jXpO
         0jkMfljcEBoCuosCUt4Iv8g2DRiPDiVaeXUhhyoPx3fouVGhB4bARSLOxwNbzxMgO5Qq
         8JiOMaqw0QJ4dJZheV7zdbXgNo4jgQdxBorZBL6fPgNTJn1H6STonZ4Wynvc1KEwXNeO
         jBIbat022Cx6uxLPpkLkyIxE9P5SXaEXxgQMcUy1aVjOqOmTR05GIVVdlbyjDF3qtlp0
         h6SYGMFAAWNIWcQF2HSN9CLRLxq7LeblL+WFGv8zEh/kAA8q2n3NWfvANT1PF7JBpoT3
         gSuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795292017; x=1795896817;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=LtZDpCvLJ0VvtED3yvRJczLNhRGhJEw9NB2kLqULBmg=;
        b=YROTn1m4Oocw+He9+51/18NYjpcUjoLPZqNKYhKH5QxklzfwwXMSGL0qFFIuATRWxq
         9R5U5PDxUooW2zCue2jBFy/LziTnj2Rx6CP3itEWQLgXWxzKGqPoKvxIUrLkGpz0vGxx
         ZLf1FjrNB7gML2z5eMNNErgFavyZBnzzIcu0M7nBGiIbCF8QtgbxiMw3r5Ogecey/aK2
         333rOCnEcDJnlEQ8vjOtzr5TvHoavxrkYBK42PpJvwGAkbAotLOjJq2vuI+X1mkhUW8h
         w2uW5EQz3jf0OJKr7AU8kq4CxBB3tQzxFtJGnLePUtWgC0UMVcsDpX2Cp3EOqx+1YUwC
         68Fw==
X-Forwarded-Encrypted: i=1; AL+hErFcSeR3OWk7+sFR2onyt+/oFXkzAGeKCcTz2ulvyL8BBBsL3p2ub8zEg4VGaZuKHUsAk9S1mGIq/w==@kvack.org
X-Gm-Message-State: APuU4Z8K/AeDd9NvVSJQwXHXo/lOmDpYkBBodVo4cWuXbWdwe/9TPbf9
	W2E2E6jWMFOTFaJYSkGC8hAtSaCEVl0H/mrsyJwqcc/SM+L0d+u9PF0u
X-Gm-Gg: AZFdTZcvXq6t9i8jXqF6vJYO3YkmZqvlcSAlDXdkqkeYJyfd3nQ8HX6Ky+CIdt8yaB/
	zMn8K224VcLAwek/dhPSJcT6Ua6oOThJ8n3d+u+Vl/0N+DAs+e52RWxSk6udG+FHCGr/yljMbDE
	ezoGELqv1xuvfYknoRFlRjB/g/Ujb6ftU8/p/4+OMKRc1+v4T/W1WN0kKP+j1P1wtBXp0+VB/Ts
	4Eyv7o5JXFYkPsRcrC0PwmhcoL1fZYmW8r+EjHH/McSgaUT+/QZ97GeAmCAyNCAgOo9dEZgB1Gf
	OLCE9eq4FU+a0FPf+zRvTeP7x5Wc4nQ5DhwTIyCGT9MuuLE+eCmrKwtV9MvbOdz88XFL3+JMK1T
	ClgABJ2KGF1UqfrjBG8uv5Uq5or4yZP1gyfnYW16pHNP3XvrM5nEsydOk0+eb8NOHlRCGXlRf2z
	l7WEnPFk8B2pFSR4LJMJHk44Rrz1hOJtew06IT+lFU7RnkHNTVoY7yX7HttRvXlTb9z9eCZo1u5
	e35wCV4oKhGT9GZ5Jx8nEwgd6Ddiw00tx8l5p/4S8N3yiAJqpgmTDlOeUuEKsCvSJHT4lVXHGLI
	23jQxwT3EFsyalwib5hiRDkFPDXK2Po/VD2xUxuCxyrGQFSP0az4HGpHh627Doze6o4hNA==
X-Received: by 2002:a17:90b:5346:b0:3b0:9976:c1c6 with SMTP id 98e67ed59e1d1-3b41c9bbe00mr6148779a91.66.1795292017156;
        Sat, 21 Nov 2026 12:13:37 -0800 (PST)
Received: from KASONG-MC4 ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b44b6fc28asm2771809a91.1.2026.11.21.12.13.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Nov 2026 12:13:35 -0800 (PST)
Date: Sun, 22 Nov 2026 04:13:19 +0800
From: Kairui Song <ryncsn@gmail.com>
To: KunWu Chan <kunwu.chan@gmail.com>
Cc: kasong@tencent.com, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, Gregory Price <gourry@gourry.net>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, 
	Hugh Dickins <hughd@google.com>, SJ Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, 
	Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
	Zicheng Wang <wangzicheng@honor.com>, Chen Ridong <chenridong@xiaomi.com>, 
	Tal Zussman <tz2294@columbia.edu>, Xiang Liu <liuxiang.277@bytedance.com>, 
	Ehab Ababneh <ehab.ababneh@intel.com>, Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, 
	Lian Wang <lianux.mm@gmail.com>, Joanne Koong <joannelkoong@gmail.com>, 
	Hui Zhu <hui.zhu@linux.dev>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	damon@lists.linux.dev, linux-doc@vger.kernel.org
Subject: Re: [PATCH v5 17/17] mm/mglru: make folio_test_workingset() work
 based on folio LRU refs
Message-ID: <awFbU_VGf0hotbyR@KASONG-MC4>
References: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com>
 <20261119-mglru-fg-v5-17-9eee2fe97a2d@tencent.com>
 <CAN_Opa9APLNic4cnohrtZ4-HcdoNvSFvnAKiC6nn+C=thbTAAA@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAN_Opa9APLNic4cnohrtZ4-HcdoNvSFvnAKiC6nn+C=thbTAAA@mail.gmail.com>
X-Stat-Signature: ynu4simqw67ipfixfduszr5em5gy6szp
X-Rspam-User:
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 87B54C0007
X-HE-Tag: 1795292018-685336
X-HE-Meta: U2FsdGVkX18ECoUrvBLojklxQi23MSlCgeO8AuR1SFsT2JhAEVbjnQWNYio5PkygNcLxlAxlnaJnx19tP2N4T9H5AgzTszpjeMWk4VmLHTK+zuXTthZHANRrQ9m3NB4JgJjIuhmBYcjfMMYJOlodXcbhNfeP7ofUjqc2Y15INg+5blljQGo244W9qrhnVT+jL+GRAyigGAAjj4dESdv6/tknlZ/HkJs5tncUK1eSsOyz9VDcl+z92O9U8Us3OA/5Uh+xDCDODVYo/jTPT0uQAbxqW7qFUZ2pmZ5Ni3OC5mu9js7msvpALph8huaPkstCWP9yrQ2uPUACxTRr+Jh2vKnN1eJpLpzKvXwIn0pnN3MgNhdbOOxzT1NYB6/7lyDk2R/Ue4RmQ7TjakdeeIgQomImNmn5aI/PuAiMKSeeyheSsfPzT3Q9Q4nWCgWhFg0VQ2kRd4lbxLz9RfPUcRxolqE38iv3oO0JCO76I0iziMd3lRNgYjHTSisw3/uIjcBmyEvWfrM2jP/RWQby1y6httqgXkozVt6OA1drj4xjXGAYDr3RnfNz1NKL2ikrM/fHXbXnzXCiqRFFJAMYTiN+tANk4Uit1H0feiHAdF39W/oNXiJ7EWrGTniQStKxt7Q3H85nSGXDckl5vwYX+1e2PcR6KPYD8t3i4E4lO1WZCGCIMCN+j7neaOBpYaywmxFdYDLMmNjErIqwFF1i8eg7F1xlpN+62JmaxkBYa8Z5QosRf0Kavco71bn93liNgLaVTLPGMLd0Y++mo63k+VjuqRVTM4YzKGvj45RqfeNlo3AOzQFaR9G/y3996dT4nNgCTZD7SXgtfjwVutJ0ZGeaqmSg8fzK03Rq3kugs4ShJA7+sJTXrXMmopeQ3W2FMd8l91J/nxVuEe+PboPxv+Gyw6p1lEeb29tbGOnl+uYrOmbxCMovZMOYHzEjZ2c3Qbkl+XWotf1lbTFrdaDwlWh
 /b5ODhBF
 lyTILFUDJH3/bsfFud8dIMQ6jPxDLPnXpSRquTeUlcF+UH4zMVoMNVhLghwAJobk1fs8HZcuf7FNyUFb/5GjfMoWna+9zTt9Is1YAk2S985Q3zSJOJErbOqTW0MNr+XwltzNHyFSSb6wEuBBRHnTuy/FpEXcDw90kZW0Eu6EHCOsjN0rcccB0j09pYixsqabNbjYQ9DwBhmSR9/rpsXwA73IHurHYr/zhgqXyZxsh1j2M6EhPCzybLMrnSf2+wxEBiGNKx9+c+1iDhHVF26yk8Bcau2r3/OoykXnZqy+KTCtn+Dir7SE4pOrs8f1TqXDdOIqDMqLYiTBt173PEKoH4k6PiI6/5T42JMHhxxdZfnwetrbPwFOeVcgl4Po1rccWx1QKEqC4ChujsX0jsRF6uv61rBo3ECH1LrxsXHYCPUKN3VnWWpcdMI4lUgrOMOZdRYpC+ln1cm4Nz7Xu6klQAzwYKFJVehMSdd5mWtWzsZ4vq2EjrRCiW3MewToSfbC3o0JUDYbJTLsLUAzmpy+Jh4S3aO2LexMp6E7jPNpynxkdjU30O4ohVNA6cHfHOMNAOIJMIsRcAkgK0WVePrf134d43IiCPEELaWYQTgK9XX8doAqkTn/mJ/q5uQd4wuE7BJfY5qFXkc89Q7QKOl9erXtW5Z7ru2UBiVrja3nfqAypAoEl3z6Oh2KR/XwHYAdyyJHEDDH0NZXeQVymjXkUdFo6TZWKbDNuPc0RQH4jwpBTU+7+ArhnD7xw/i04h4acu9GY6L3sSznxsq8rnYKDL+CxZOvejHtj3aX2x2/F+l6vqB2USJSPUrqWiv8y2sdA1qjb+hISJDQrzOkpvJ7jQWtYKOcodJOIcsWI2Uw0NE4OTQ9JNjCVUovZisLCZOWt2aQ6/9pg7q0K6OAllWyZs+Y98A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 20, 2026 at 05:53:36PM +0800, KunWu Chan wrote:
> On Thu, Nov 19, 2026 at 5:04 AM Kairui Song via B4 Relay
> <devnull+kasong.tencent.com@kernel.org> wrote:
> >
> > From: Kairui Song <kasong@tencent.com>
> >
> > folio_test_workingset() currently tests the PG_workingset bit, which
> > is only the second lowest access bit of the folio LRU refs count now.
> > Folios with refs 4 or 5 carry it in the LRU_REFS_MASK field
> > and no longer have PG_workingset set, so the bit test misses them.
> >
> > folio_set_workingset() currently sets the PG_workingset bit with a
> > plain set_bit(), which also over-promotes folios at a higher refs
> > count: e.g. a folio at refs 4 is bumped to refs 6, advancing it
> > toward LRU_REFS_MAX and an earlier generation promotion.
> >
> > Move the test into mm_inline.h as an inline helper based on
> > folio_lru_refs(), checking refs >= LRU_REFS_WORKINGSET.  The set
> > stays a plain PG_workingset bit operation reserved for the
> > classical LRU: under MGLRU the refs count is maintained by
> > folio_inc_lru_refs(), and now triggers a debug WARN when called
> > while MGLRU is fully on (the switching window is exempt, as the
> > classical paths legitimately run alongside MGLRU then).  The one
> > PageWorkingset() user in erofs is converted to the folio helper.
> >
> > Under the classical LRU the refs count is not maintained, so the
> > test is equivalent to the PG_workingset bit test, which is the old
> > behavior.
> >
> > Tested-by: Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---

...

> > +/*
> > + * For the classical LRU only: with MGLRU the PG_workingset bit is
> > + * part of the folio refs count maintained by folio_inc_lru_refs(),
> > + * and a raw set would corrupt it.  The switching window is exempt
> > + * because the classical paths legitimately run alongside MGLRU then.
> > + */
> > +static __always_inline void folio_set_workingset(struct folio *folio)
> > +{
> > +       VM_WARN_ON_ONCE(lru_gen_enabled() && !lru_gen_switching());
> 
> Could shrink_active_list() still hit this WARN after the switch
> to MGLRU completes? It can reschedule after isolating folios and
> reach this setter after lru_switch is cleared.

Hi Kunwu, thanks for the very careful review!

Right I thought a lot about it after your reply, first your concern
is right, thanks! I should just remove and replace this WARN with
something else.

And in theory, we should only call this for isolated folio (for CLRU
it means a folio moving out of active workingset, isolation is always
the first step), so this helper is fine - except, for the MADV cold
case, it will call it on for a on-list folio, and will could skew
the counter and if it raced with switching. Switching is so painful
I hope we can get rid of it soon :/

But, good thing is it's easy to fix, we just need (part of this belong
to another patch, a trimmed diff just for reference):

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index 4f65867446dc..c936d1fadfbd 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -261,8 +262,9 @@ static inline void __folio_set_lru_refs(struct folio *folio, unsigned int refs)
 
 	do {
 		new_flags = old_flags;
-		VM_WARN_ON_ONCE(lru_get_gen_flags(old_flags) != -1);
 		lru_set_refs_flags(&new_flags, refs);
+		if (lru_get_gen_flags(old_flags) != -1)
+			break;
 		if (new_flags == old_flags)
 			break;
 	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
@@ -569,16 +571,16 @@ static inline void folio_clear_lru_refs(struct folio *folio)
  */
 static __always_inline void folio_set_workingset(struct folio *folio)
 {
-	VM_WARN_ON_ONCE(lru_gen_enabled() && !lru_gen_switching());
-	set_bit(PG_workingset, folio_flags(folio, FOLIO_HEAD_PAGE));
+	unsigned long flags;
+
+	flags = set_mask_bits(folio_flags(folio, 0), BIT(PG_workingset),
+			      BIT(PG_workingset));
+	VM_WARN_ON_ONCE(lru_get_gen_flags(flags) != -1);
 }
 
 static __always_inline
diff --git a/mm/madvise.c b/mm/madvise.c
index bbbb729ed647..a73d89a2ecca 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -374,11 +374,12 @@ static void madvise_cold_prep_folio(struct folio *folio)
 	 * as a workingset refault, and the referenced bit always needs to
 	 * be cleared even for inactive folios. For MGLRU, MADV_COLD clears
 	 * refs in folio_deactivate(); MADV_PAGEOUT handles refs after isolation.
 	 */
 	if (!lru_gen_enabled()) {
 		folio_clear_lru_refs(folio);
 		if (folio_test_active(folio))
-			folio_set_workingset(folio);
+			__folio_set_lru_refs(folio, LRU_REFS_WORKINGSET);
 	}
 }

