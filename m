Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABD30CCF2D3
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 08:06:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AEEE6B016D; Mon, 19 Oct 2026 04:06:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6603F6B016E; Mon, 19 Oct 2026 04:06:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54EF66B016F; Mon, 19 Oct 2026 04:06:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 28E546B016D
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 04:06:05 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8FB40120650
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 08:06:04 +0000 (UTC)
X-FDA: 85338642648.08.B5C2663
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8CB1840003
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 08:06:02 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=eRxeBKcF;
	spf=pass (imf27.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792397162;
	b=CM/Lci+vnZgGxoZcDozrILGa7v1SCC6LxTXL/LexycyQB7NFQkwv1sX6fuQuDeMGsNyLAa
	TXQQjK6hvRcafYbKrpmRaYaNSrvxfsHf8DDquuJJAV905oJQx7XMJJlzJg/kCDZ4GLL/9x
	VB+uLncSTkUw8jIe6yihcaM0GobjCLc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=eRxeBKcF;
	spf=pass (imf27.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792397162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4OS48Qr0CZvLG5JGazX9ZFM2Vl3rE95sPji6iuRYp1w=;
	b=EY21ItXyiRu6fAKasj5GBPLIcRkN5++iUX9Es3nkQ6VntUXDehhbAMCQ9wK/No8HKuEr+Q
	/rWMkr1uCIhbxnBzf5ohXpXJk3QixDayjQ5K7MOQDj18kFlbDOASwzd+aRFZwSENS/qGhj
	BTH0Hd5txZBuFGLhSHGMVCghz6L3cZQ=
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c434376dbebso162434566b.1
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 01:06:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1792397161; x=1793001961; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=4OS48Qr0CZvLG5JGazX9ZFM2Vl3rE95sPji6iuRYp1w=;
        b=eRxeBKcFPBtnG2LZeK9CQS6g55IGScz8yHOMeiT9TZSzsuN/AD9SJztIefNKhcbOHo
         NfSw7PKrKr+NDHnwG+pnYVZOJlWG4DG9IJsvNxZzpsm0WZUznQOaGrSaUK/bDBPMfH8h
         5cUdJwb6EliCv68vc8RJWBi7pBRIZ/Z5ROwJq2JEA/8fZKlOxWkJ8+3/SehFoWDF4QDv
         o1RhtlV15uoRtck5s/cYSDSFMAuMDPlWWuPC5rbE7a5UX0ovX4cR2N7J3HPoQbJvH7ce
         Vg5umzEOqtUgMzHA2AzrO1jilolxcoO4X6k0/J6ymMufNkacnY18woGeRm20iJfhzn0W
         OmSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792397161; x=1793001961;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4OS48Qr0CZvLG5JGazX9ZFM2Vl3rE95sPji6iuRYp1w=;
        b=DwN72FicXp42hDf3YQZj94FTLOp8ltfU+rVmF+wRzWQE1fNgdk7+2SuDNmAJOShKUR
         YggpUZ1TT/8JFuopm1ufJFH6TbhHlR6OZURwMUTsKn6yztbH4F2bIqOlhn+d96UJq8OZ
         B5u6uYnVOM7MAIf9QsJ7PmMDtvcD20oRfBy4PQEHUtKLcvsZfb6mYWsXt88TKLSlMCE7
         AmPcgtSlKxGm3Zo+5tGI0BRrVqx91k9kQjLiWncldfAiYYBWpIzL1Zk8BmTyJUUOVfv5
         7xyGs9WoY1MVGrOUW2RvVjk4Gn4wlyklcKeswCXefGpvlPnTn774tBoL/xvXfDoaLjb2
         g2OQ==
X-Forwarded-Encrypted: i=1; AKwUvBxFAWr3Wm7peHE8jnPrQ+4vdjj1BpxPoTu6ZK8QTwgNfWdhf5HsOUMiR6+C5uSpV5WmOQcoQKJqxg==@kvack.org
X-Gm-Message-State: AFq9FYJgQGGiqRdgRTMncBAdbLr41N8icpFILPYkNQiXVwl5nC7Rdv3S
	qPz/0GkxrbF1oZ55fJbOgU5Su5I4YrPpqZiw/DMkL1nPSo1oqb5funlCLAtgQbBEEtA=
X-Gm-Gg: AYBFou2R7Dv68wedbpMqImA+Aerg8BsDkckusKU9l4BKHaq4Nsa/VkZhXaY9POnbbDY
	U/s/Ws1PX4OhSyDGgKznT7csk0bkUnCO8FDuHADb2tB/UtmQnru9GZyytUm/yMUttfam0pUT6cE
	jf4hoHBDE8mhWZyWMY5UQnm/fW1RXBovSxVN5I3HrOUH/YsEGdCbjFAXD3LwphWDHGi6c8M6ec8
	jKJw0q4z17t3msGMoQ5K7wjqmlbLIOqW5lPgmfh/2G+pF1wsscc02G7el+1jx03cWmn6cwW8k3w
	TGPKmb/5lZgArFKOLhkJ+HdmuiebBcYX1L3EU7XqnMGS903JFbKK2emX3zpnbyaFJuMjCk12dVC
	GAOld+dQ72UGYvkf6vUUO/CMEmbXdz3NVL/hFgT3fCSQl0Zx3b+iyugCbV4X87oHf3lHChZRfCY
	G41jnOG64XfwlylsEWSXCvWO1nTjc9Gl/zE9lgttTxJZvUayKk8frK5M8L/+mK3dafHdZGMpATl
	9NeFLnCVvbfZg==
X-Received: by 2002:a17:907:72cf:b0:c2e:22f7:59c5 with SMTP id a640c23a62f3a-c40206fb12emr782141466b.7.1792397160793;
        Mon, 19 Oct 2026 01:06:00 -0700 (PDT)
Received: from localhost (109-81-30-108.rct.o2.cz. [109.81.30.108])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48dfd5033a2sm21427563f8f.45.2026.10.19.01.06.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 01:06:00 -0700 (PDT)
Date: Mon, 19 Oct 2026 10:05:59 +0200
From: Michal Hocko <mhocko@suse.com>
To: Alexis Bouzigues <BouziguesAlexis@johndeere.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: nommu: set MMF_OOM_SKIP in exit_mmap()
Message-ID: <atXPZ4QB7qoCt3di@tiehlicka>
References: <20261013-fix-nommu-exit-mmap-oom-skip-v1-1-cb957cdbfcc3@JohnDeere.com>
 <as80Rpm-VHhP14aK@tiehlicka>
 <BY3PR05MB82607AF910C023253C48CD26A09D2@BY3PR05MB8260.namprd05.prod.outlook.com>
 <atB63fzpLyfWpzPn@tiehlicka>
 <BY3PR05MB826006B6F1E2D97E247104BFA09B2@BY3PR05MB8260.namprd05.prod.outlook.com>
 <atHKQFi0ckwxLa-P@tiehlicka>
 <BY3PR05MB8260C9F9055EB094183544A9A09A2@BY3PR05MB8260.namprd05.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BY3PR05MB8260C9F9055EB094183544A9A09A2@BY3PR05MB8260.namprd05.prod.outlook.com>
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 8CB1840003
X-Stat-Signature: fhdeuqmjregc9dn8y1dr4shfn5d6a6ut
X-HE-Tag: 1792397162-471695
X-HE-Meta: U2FsdGVkX1/HBdr/7JrwDx+Rt3d+5eMvfdmIdLzOAgtVFvyKTK7TVa4NfQTVj5zvFINK8t86Bwg2BchtxLE5vaL8ozlP0DFz4R78PyIAW3av7/W2S6+70Y9ZRz6RDSinWuRmNmFz790ZSV7Yd/R+j/qNg4678+bgDM7aDHYCr5CQX97psQ+aCj3R1sDMY/db0vXMdU7GmzIqyinnKSz8cAW4LUNYLXOm+Jbq64rPAC7W8PJ/z/tyztJFyoBUa4VAutjyDt0pBjoYoLO5Slb1QcJFkdYOPt466wSUiKN1CTI8ycoR5v42P4CEkelEy6o+xIoedZ/86OxdajwvNwB97kK5IBJKJwFLV+JQMY7WO5IRq8dzRI1HCBFd9V2eAgZnYGKc+3/P8WRDukUzCLoSYyQ9dYFLjzWZi7+tLYWoe/YWrkfqD0Rrqmz4Z8PP3Rk+r9i4W7VkeGY0RyCh7OiW5Xvcl2cMypuMS3xfV4xHOkFFnQXmDSdAt3PuM89i2k+JLnqf2rwKMUThl9a6l48VXU3js3coGx8KLEaPKUDWc68T+yu0DZ57a2UgcOZTwCnLRjEx8R3FWX63PADAP7STjy2SdiNOFy8oxEZvrB7qQovIPk2aL/xnryDUl0Vmvx68pdFplzcI1jjjal0vudBaAiK8br0p4nrn+J0xRtljN2//z6se9H43v7wA+XNtdJpG/GRgSK8nWl7BVSDLllK6Y4qcby0kgo2urMEi6ttx2Eym0jv0sYGmVN0Si75ZeWXW8vb+NCybeYSLiYXaT387yiO6NkKujhnkW6fQ7dtz5Pc6ABg3Ao9sfm2HShTOyeiBULcAwzaMv65BDn/jY11tP1rAe2u9PDuhI1y+HbHmbm3Z0tAH4iii5TyK/htaeRL8vtbu0GJDM4uFfnsROwAzyfQWF4WkCqSR80uR2e1KxcKSAvYZH54xKHSpN1vBHH3LgjfMYqIGfED6ucGQZn6
 Yf0Nuso3
 wSV1OcQMIdYTzagprz0YAUq6vLk8HoW+IUig8WK/vXCfcLNMcjKVjM5v2NqLfVpZJmLdKBHeBJNLwwDYngAvTtzZYkDDiJe2eFjW//IgL9ZqX0guThFN1ZbzTvHTw9bTMPAHZ7SrtH1OThg51xijrC8eQU4iW7DL5Q/aViBngNjdhOmxErQ8cQNr2CeGIXtA0a+AdSQtxenzL9ZM4tpZC5YD+E6ML1VMWNCWBTI5bF7iII+XBdEQYt6W+zJWS1vGvKlCk/cEDVPeK0ZEYcKc9l3e9OL1DPR+xdaFpI+/+Hjcuvu9/AEUp25FMVaEc+H18Vooe2tXRZ9QuLV7asajpF2DAfK/N81akD35DJ6GLnitZqKtsZgXHw0zr0kP/9sEWGWzDDVHrQEUiqgFLvxHqxMXPojG9RuojxqhpJze5UON+6ij4bTszskWN8dTmv52s+U5nT6/141h4sHljsMYZk96YrAtNNrf18F/R90jfhajZuiH516DD96A22qYMTSGjvNihm2P8KC3oyfU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat 17-10-26 04:32:37, Alexis Bouzigues wrote:
> On Fri, Oct 16, 2026 at 08:54:56AM +0200, Michal Hocko wrote:
> > Correct. The question is why killing the child, which has passed
> > exit_mmap stage sucessfully didn't help.
> 
> There needs to be ongoing memory pressure otherwise the
> parent's allocation succeeds and does not hit oom_kill.c or a livelock.
> 
> If there is memory pressure, then the allocation hits out_of_memory() and
> then blocked in the __alloc_pages_slowpath/oom_evaluate_task retry loop.
> 
> > a) a corner case of a valid nommu application or this is
> >    a theoretical problem
> 
> I think it is mainly a correctness fix (see below). I have only hit it
> with benchmarks, including the /init provided earlier from which I obtained
> the backtrace. I encountered this bug initially while running a
> benchmark to test memory reductions.

Make sure you describe this in the changelog. Along with an explanation
why this benchmakr matters or represent any real life scenario.
Especially in the context of how oom situation on nommu is inherently
fragile.

> > b) why this doesn't break otherwise very fragile nommu oom
> >    handling
> 
> It does not break nommu oom handling because it places the flag only in
> exit_mmap() right after the process has called the last delete_vma,
> guaranteeing it has freed all of its private memory.
> 
> This flag is used similarly on mmu (mmap.c) and in previous versions of
> nommu, until the Fixes tag 212925802454 ("mm: oom: let oom_reap_task
> and exit_mmap run concurrently"). It took it away from the shared
> __mmput() and only kept it in the mmu-only path (exit_mmap of
> mm/mmap.c).
> 
>   void exit_mmap(struct mm_struct *mm)
>   {
>           ...
>           unmap_vmas(&tlb, &unmap);
>           mmap_read_unlock(mm);
> 
>           /*
>            * Set MMF_OOM_SKIP to hide this task from the oom killer/reaper
>            * because the memory has been already freed.
>            */
>           mm_flags_set(MMF_OOM_SKIP, mm);
>           ...
> 
> This change places it in the same exit_mmap() of nommu.c.
> 
> The MMF_OOM_SKIP mm flag comes from your commit a while ago
> 862e3073b3ee ("mm, oom: get rid of signal_struct::oom_victims") and had
> the same rationale for nommu to mark the pid's mm to hide the process from
> oom killer:
> 
>     After "oom: keep mm of the killed task available" we can safely detect
>     an oom victim by checking task->signal->oom_mm so we do not need the
>     signal_struct counter anymore so let's get rid of it.
> 
>     This alone wouldn't be sufficient for nommu archs because
>     exit_oom_victim doesn't hide the process from the oom killer anymore.
>     We can, however, mark the mm with a MMF flag in __mmput.  We can reuse
>     MMF_OOM_REAPED and rename it to a more generic MMF_OOM_SKIP.
> 
> Let me know if this answers your questions!

Fair enough. And now I see where the Fixes tag came from. This was a
side effect of that change because oom victims are not hidden anymore.
Would be good to clarify that in the changelog.

Thanks
-- 
Michal Hocko
SUSE Labs

