Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFA18C982DA
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 13:57:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D70676B00A0; Fri, 18 Sep 2026 09:57:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D20246B00A1; Fri, 18 Sep 2026 09:57:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0EB86B00A2; Fri, 18 Sep 2026 09:57:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9B9626B00A0
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:57:10 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EAFCEA5E0E
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 13:57:09 +0000 (UTC)
X-FDA: 85227034578.09.B324CBF
Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3E9DB140007
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 13:57:08 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=rAzr8wnY;
	spf=pass (imf23.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.204 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789739828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OiMqaqWbazIIJAAiWkvYfZs2lBb8py7IOOpDM416lKg=;
	b=YUkfBpPLk/VgNZ76yvDMa4+fBghf7NwBHY4Pf7LgC6r47mZuFzq6FlT83Mh30RmUvIRDzw
	QixgCCUCStTqwVStdAyTGSFtaTujBXZvpcItimnJnBw2dFXGffEXEiJi61hmthpyY62zwR
	LwTr/i8k+xhtBldW83gAmm09VX8wm8M=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=rAzr8wnY;
	spf=pass (imf23.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.204 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789739828;
	b=AUxTImMtTcJFUqRDAR775dzA22esXLR46gebbsrvCu6jApbuY5SMzLejbMj3CTmb2MtrHS
	R0t9YOkdTyI/vFGi01sBANq4J+r4+z+6g3WGfugEPhQlywxp6jKbW2cN5CCIeGhHvNnxCM
	igawHVKz18h/l/pMYTWwGoKw9ewE3NU=
Received: by mail-qk2-f12.google.com with SMTP id d75a77b69052e-53122c5bbb4so8338601cf.2
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 06:57:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1789739827; x=1790344627; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=OiMqaqWbazIIJAAiWkvYfZs2lBb8py7IOOpDM416lKg=;
        b=rAzr8wnYY0Hew7xLojLQMuq/Kq5MvNksKJkGimw5vmePlRowP63+OV6mVhKPEI012n
         dIesGVB8Io9wSoTaSXHfqCwbv/4xKNJZfLs3g/4jnnAMLrtAb2rhX61wV+hcQu0aLpij
         Vn9O/a1kRtroqfTxDNd8HE1iM+OFDKY4jI+tP9jneESvLIo/DEYrDNipA6Ya3vgdV7n1
         lxNoYtt8gQConPKQPc+ZMwnNjkMB4aM4iUuGWtjJ2m9SQrJNhPSONc5RNtxkDyeClO9+
         001WLqhF9MIzb57wNE6GqoKDCJt0+eBeuObZyvkR0Q+gkk4hw4SVNZEhDRCKE/87x0aQ
         U1VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789739827; x=1790344627;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OiMqaqWbazIIJAAiWkvYfZs2lBb8py7IOOpDM416lKg=;
        b=MuLktjrjfMI9Qv0LGzSqvhM7pike5d39iXsexQwvxdfvvnv21+AGAxwAH3PjJZQLgZ
         1lSlq0kjXydD1iZbycjW1r4wMHJeoRDmQ9HHQ3Vu/Z+1IlU8u2avd+Pj90Ftqg8Agfo/
         ozY1BG5Zxx/J3QnnP0WU1mbKpqOx8V0pvlj3kOXcXxWBJi4o7uDZW0By5wUCj0tjQVAE
         8dusb+nTVMJOvYFlka+9AsmxbypVacIfBvHTQHiEcoFuX3R8UGPf0pJYEDIyyzHA8EpR
         XV3U28yaG0aTs99Blakbqa9vd8tn2EinnVOZYC95ONVhxazcN6w7G/mdWz3hcLK6pl7s
         t/iw==
X-Gm-Message-State: AFuF++kc74C7YrfFEz7EFdwUjdCKkxYTZjD8qvkAxf+GGcApbdJf7753
	0VrGEWjLNoMUnSabEt7lY8AigpOrFDr51WFH44e3MO0qUAlOZfLjVlcYyYTfKmCERig=
X-Gm-Gg: AYBFou21FAPUbbEmgFieQzrMllr3eyAjSwfqaC1zyYxgajoquwRt239BujmI3GN/J2M
	lOu07PT/TTEUZnTR9gGkgvJqefrvuQY4pRLcQmKtqtxoCqgjd72v53RWaCWCjmrvBEBDk1UioFq
	mPHx5GDyAssPfXrfooW9p8m9PCAcSyr6FYMmyo2lsk82zieGGlLxMGKL03LDpXvwrV8vQt4RRoh
	766MmaKLNFZFQNbPr16zBivhgPFjweR2bXJ9/Ym3jvCJocx2/waac2sAVplpT6RO9prAOCqqQ+j
	wW7gIitfbqb6yw7M0eP+5wEJxNl/NamwiIV2q6V7sbnYicISlqScxckoMXgpy27fJhqfBDCHL78
	/TlvC5NYgoJvb1p2Mwj0BxNcBD4/0xtlVjfJUT0iqvpoN0lRSsARizRlxPJyva8e0vrsHoSj91A
	YpkCU8JDidYrPcNRi+1FVGKZ+OT/wW1OW/gu3F2IXugMlmNEgFQta+P4GvS8lIkmkqMO0clNAMp
	BUdIggpp/dtq1Vl92f2qyooe14/WXaGrRBJz/MShHJeAdfRGe3pEhs=
X-Received: by 2002:a05:620a:4415:b0:939:e71c:7740 with SMTP id af79cd13be357-93bdc4e42d6mr349294685a.0.1789739827329;
        Fri, 18 Sep 2026 06:57:07 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93be0e54ff3sm144885585a.9.2026.09.18.06.57.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 06:57:06 -0700 (PDT)
Date: Fri, 18 Sep 2026 09:57:04 -0400
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, mingo@redhat.com, 
	peterz@infradead.org, juri.lelli@redhat.com, vincent.guittot@linaro.org, 
	dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de, 
	vschneid@redhat.com, kprateek.nayak@amd.com, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com, 
	baohua@kernel.org, lance.yang@linux.dev, usama.arif@linux.dev, kas@kernel.org, 
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, jannh@google.com, pfalcato@suse.de, 
	osalvador@suse.de, hannes@cmpxchg.org, raghavendra.kt@amd.com, 
	stable@vger.kernel.org
Subject: Re: [PATCH v2 3/4] sched/numa: scan read-only file mappings in
 tiering mode
Message-ID: <aq1Cwh9hNw4wWEUP@gourry-fedora-PF4VCD3F>
References: <20260911001826.2109390-1-gourry@gourry.net>
 <20260911001826.2109390-4-gourry@gourry.net>
 <0ed3ab3a-80b4-492f-867a-0584441722a9@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0ed3ab3a-80b4-492f-867a-0584441722a9@kernel.org>
X-Rspam-User: 
X-Stat-Signature: ze88tjf436ka15gawbaeeuquxuh5gjmd
X-Rspamd-Queue-Id: 3E9DB140007
X-Rspamd-Server: rspam07
X-HE-Tag: 1789739828-180186
X-HE-Meta: U2FsdGVkX1/zbu8Lz/DNsRYSKufEg5RHELGQdnLry+QGzh9ixmNyV5nXLlJDR06uZ+V3tpjuJkStc+aicE1uzmVPwhn1QAqkmTzmzmBHSuPgfSlakXJ5wC4Jjr9O4TO+n53l1U0+qfN93MLDjF0vgVpa1+d2NNj9lmB3zu/ktD8h51j+yAXls7w4cwYo9M64EId1WTkDCYpxit4898pRHQXK6rM9BWlLzOoREYRFx2B/FSz9xnEXYbmq5/ud0nmJ31ta2V9NUBVbT914T9C9nOG92RkvG2UbC+sC+Xp+hUOAgiXkByNFVc0HDm89fO0GZDtMNy84VzrymhiX5yBmY8roK0OfbkgmdtglM13eHnxpPsO+qvU6rgmz6HGS7eYxB9jgckTBQ1EsB1hVTFfeRQgN3RTVIt7ZA8ENj6nuKohmGyA4qV2zdPvAAbQDctmwzp+AI/V+4ZauCjaim1nu2pE80rnOVB90NR/7uZWGqlDKXBor3AhGccC5l/aFwXmx5+EI4/lrnwjGkV5RLDzOTTy0ZWpAF6Q15H5FUn5OlSfZ8fB5iCzqJplsdEhyVKyYsfnL/PeW3+g0IpkKJG0yOMEyTURcdsdG4Hq7jzxR5shTMUdqouZccjw0yHZqMBdRiKpCm8b1qzQ64bwIQjDZZiNag3YMu22QG4OiBIzFkQLLLzfi4YI1OLLGpcY6gmG027JWWAZrshCqq+VWXrL5YJ9Z3D1OalNjnXEUthJ59BvCpqhtFXDUpEmDvASHvOI0DRFEs097xUEuUFkBN88Tv7hZLWY2obAqc3sOOHDAcC29bDPwm/FLsDYIEs9OG5SeSa+jFokeMXn7syeHQASzhN8meMBR989P5s+6UI0CG6u0IOvYsUb/buHiQgJtnewfz0Xdapqy0io/iJQZ4Bzow1lVvMwY+uXbVVVIkM+Y+EXlZnPOeU/mZBw970BbW1pKnDYiVA32v0RHRvM7/Oz
 HccYF47o
 oo38AwkIMDCfWiYNoNFZ5KCQO7LK0xYNNpa6RVa3fYTwSGynxUeEz8qbfjbV1nF7B+IHzblS0wOcQWvEIFpTzGEHNncZfZjzF2Re6Y907p8eOEGzKwFhKDT4yDCZ7VE4QIJ1lq4d0d5gvIQBn47fjQHZjkWIuLtCbaKag3SDzmsitfJtvAHet1hKYdjvTm+B/PlCuS75YX5mqUC7+UdbZxl8L+IzLdSkzjVAGuoNIBn+ITO+s1RyZN0ooDJWqba6XhteMaR7O6JQp5RUlBIcJZ/eu4z/HNApAACIf/2AWsCx3clVkKeJ2SxiqmG5hHZhnlANgFFGtZRYmhVHYGBcmWUiQml/yoO6rgtSMjL+9jg2bzGLTeWOWmR4edgBbVYZ60qARGpRWZVrmqQzyqZrHo22ZcQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 18, 2026 at 02:58:36PM +0200, David Hildenbrand (Arm) wrote:
> > +/*
> > + * Read-only file-backed mappings are expected to be cache replicated between
> > + * accessor nodes, so they are not worth sampling for placement.  They can
> > + * still strand on the slow tier like anything else.
> > + */
> > +static bool vma_is_ro_file(struct vm_area_struct *vma)
> > +{
> > +	return vma->vm_file && (vma->vm_flags & (VM_READ | VM_WRITE)) == VM_READ;
> 
> 
> MAP_PRIVATE can easily map a read-only file with write permissions. So the
> function name is a bit misleading.
> 
> This smells like a helper that should go next to other vma helpers and have
> clear semantics.
> 

No argument here.  Would like to balance improvement vs backportable
bugfix though.  I broke out the name to try to make it at least a bit
more readable.

> >  		if (!vma->vm_mm ||
> > -		    (vma->vm_file && (vma->vm_flags & (VM_READ|VM_WRITE)) == (VM_READ))) {
> > +		    (vma_is_ro_file(vma) &&
> > +		     !(numab_mode & NUMA_BALANCING_MEMORY_TIERING))) {
> 
> I'd vote for >80c here and but it into a singe line.
> 
> Or just use a magical helper
> 
> const bool tiering = numab_mode & NUMA_BALANCING_MEMORY_TIERING;
> 
> or sth like that.
> 

ack

> >  			trace_sched_skip_vma_numa(mm, vma, NUMAB_SKIP_SHARED_RO);
> >  			continue;
> >  		}
> > @@ -4306,7 +4316,8 @@ static void task_numa_work(struct callback_head *work)
> >  			continue;
> >  		}
> >  
> > -		promo_only = !(numab_mode & NUMA_BALANCING_NORMAL);
> > +		promo_only = !(numab_mode & NUMA_BALANCING_NORMAL) ||
> > +			     vma_is_ro_file(vma);
> 
> As I said, maybe that flag could be voided.
> 

ack.

