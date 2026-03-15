Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68E23F3026E
	for <linux-mm@archiver.kernel.org>; Sun, 15 Mar 2026 17:37:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4E9A6B009E; Sun, 15 Mar 2026 13:37:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFC496B009F; Sun, 15 Mar 2026 13:37:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDE136B00A0; Sun, 15 Mar 2026 13:37:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BCC416B009E
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 13:37:44 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 513FD1B9352
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 17:37:44 +0000 (UTC)
X-FDA: 84549004848.18.61B48A2
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5289740008
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 17:37:42 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="R3oN/QHm";
	spf=pass (imf17.hostedemail.com: domain of leobras.c@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=leobras.c@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773596262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3yYNk160Sxp9/a10Ag7sfuG1cP+ZxZO0UiKhGgYxHE4=;
	b=MSYrxBCKZ7N29qDtldS9QU0KdsWZq/dIgZ7kb53Ksa/HYmBqlkCr5Dh4iSQbK0v/2r1+zd
	cqd9susxY4ZlRT2Icl3gB7CtsGB302K3ZUqVBnax3dZCLMtzmJjbXOPR6LQbPknBx8LG6x
	mN1Lg8BWDzwc80y0ytYklgnNJqYGODs=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="R3oN/QHm";
	spf=pass (imf17.hostedemail.com: domain of leobras.c@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=leobras.c@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773596262; a=rsa-sha256;
	cv=none;
	b=DsGKJJXKh5uGlnzfgQTSSs/7VMgJOWVFCoCwFwCALYBOK9q+brf3YMYICD3pnGbq0HhS++
	q+KEJ2raqdfUSZ3AtiuyfbkJ3+YWTyI8xa8Kquke2+E+szgHofER1I0z4JYhccpP3x0oXr
	g14n57QsDHEHvD9U71r2Dj1JDfN/80c=
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4852e9ca034so34476315e9.2
        for <linux-mm@kvack.org>; Sun, 15 Mar 2026 10:37:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773596261; x=1774201061; darn=kvack.org;
        h=content-transfer-encoding:content-disposition:mime-version
         :references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=3yYNk160Sxp9/a10Ag7sfuG1cP+ZxZO0UiKhGgYxHE4=;
        b=R3oN/QHmctZbSF4J163QBlov944OJy/pAns3eK9NCwy1rV3Qmj4s+rfHD1Ps6vZ/zi
         T2SN67p/atvn8bVnbZB9Oow6kIIr1NIv20jjz7coLdxR2vOer01VpJ/IjmC04eebCUGY
         wZW+4d+WeI3cEGu1cpzI2UnLGgy1EX73Mf//HgA3A7d8B5vq/2SgniFAK9c/IPNHWnqr
         3AuCeuDKmgclrSa1FIgXJ5uhtDFKYXq2n0eskR9/61htwMHFKINiQ/tDHt2mj4KfCeap
         CnTQAGYycBDBhnDdZWBWIIo7RkAdrIzidEr/1qYITiNDj19Kth2H7SgczRMGV1zTKnis
         yC7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773596261; x=1774201061;
        h=content-transfer-encoding:content-disposition:mime-version
         :references:in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3yYNk160Sxp9/a10Ag7sfuG1cP+ZxZO0UiKhGgYxHE4=;
        b=e2C44W/P4vXDHb4BBgo2VtI88h5dBhLGoUo1gAbZczEu1JS3ooJdH1Igy0YfzLG/dh
         N2o90KIziVWLlTUV57gsclQTgr5cJu0UcqmDpA+D/k/vNysWk/UgmD5au6T82ny2dU4Q
         AK+IhKEVtGXhlPAc5zRAMbBT7PbpBu/CC5MINUqz9U2Z3aiO+EtuKtEZ2KO/v9eAtLCX
         6y2QgqiBY9PbGkxVOP3XRKHOy4XF4i5qTPok0AIQfIa93qQI/HnQm1YgUjBZWYQCJZCq
         GmrRK6EP/gASxPDdtpNviZ/bof/h5gpVkuF3BCO08Wqp3z8/fxI0gQVVlL2lI3iUZzmb
         p6gw==
X-Forwarded-Encrypted: i=1; AJvYcCXwu8mQ53cb0PPQ55T6JyU8cKLysXRmHFdaYZZxFvYIWWjaOqCneK6voTG3Q1dGXQzjzYTUtawRcQ==@kvack.org
X-Gm-Message-State: AOJu0YxjZczGtJ2lNbykOLJZa5GnGhXsGbQ9ep8WzJVVsQZr9yFlthez
	kHTJxSqpghimnWD7B5KbxDcLGYMZXGvdVE8NwXZ4qWrY5ZXPstD+3JPv
X-Gm-Gg: ATEYQzwY/B6POrSFLZvop01Mi0h7kngADays4XxnHTv/zZTWUftf+d08TYPVCMG9GA2
	VB1l1jjXzirjUhLAL/mCTg9/R3JQByg0aC/PBvGZRiLddetwv2l3epPZp//oHOqMn/5cyIgoHHq
	/rhWnrblEJI3M7JyG56smTXSuQJxNlsDyR/b7jJpHYCZEts4LWmgeWhUksFnre3w88QtWIzqUHl
	iMGs+NaIZtdDxKvCBYzhq8RjKqgp0C8CKkjeeuEdOX+qHpUls98j4GpdK+Uny1isX+ZDuQXEbTE
	I0yyTE+8/sM0g7cUs6W1zrClMjBranxOTKAZaswnI5UPbne8NL8kpQZ5sBZQIVYjd9FkOopotiK
	EXZPYomtqV4wAMIdMHN1C401DxOvD7EKHPJwoyiPRUq6GvvEfpd3KYSv/+XL5kOL8j4fWzdZYfn
	WF1NK6hl3Z1x6B7u0yiPpRmcFm7XSnUplNYbA=
X-Received: by 2002:a05:600c:4689:b0:477:9b35:3e49 with SMTP id 5b1f17b1804b1-485566cf80dmr169209065e9.3.1773596259736;
        Sun, 15 Mar 2026 10:37:39 -0700 (PDT)
Received: from WindFlash.powerhub ([2a0a:ef40:1b2a:fa01:9944:6a8c:dc37:eba5])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b3d427457sm10797759f8f.3.2026.03.15.10.37.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Mar 2026 10:37:39 -0700 (PDT)
From: Leonardo Bras <leobras.c@gmail.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Leonardo Bras <leobras.c@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@linux.com>,
	Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Waiman Long <longman@redhat.com>,
	Boqun Feun <boqun.feng@gmail.com>,
	Frederic Weisbecker <frederic@kernel.org>
Subject: Re: [PATCH v2 2/5] Introducing qpw_lock() and per-cpu queue & flush work
Date: Sun, 15 Mar 2026 14:37:29 -0300
Message-ID: <abbuWGMv4D_1ToKl@WindFlash>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <26662caf-de09-4f13-b374-dc7f879b7829@kernel.org>
References: <20260302154945.143996316@redhat.com> <20260302155105.214878062@redhat.com> <26662caf-de09-4f13-b374-dc7f879b7829@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5289740008
X-Rspamd-Server: rspam07
X-Stat-Signature: 13h9cbw4arw668tbb6695t3wm8dn9odz
X-Rspam-User: 
X-HE-Tag: 1773596262-855558
X-HE-Meta: U2FsdGVkX18uhqnqJTJIJnUG4sHDUGJyW1HgpG4MtCXZb5vR18dvhmv0Q8fyb4KG2ZzuQTTN6veCUilNp8unGBt1/QGrlpE0iOeSSxRLpPiq6Pqlzkou8RHFHm53MquZu7ysfcZqQbyblw6VDq5zzNfoVZGQMgG6fLVjcsl3dTT6a5+roosJDBtnaoVOKBasuvH34Id13oDp/60CnpCiaRNgMmAsDCf22mnySIg42yHNXcsvLKqZ9LYxQXm+T9wObJiy6GjDtv8ZwWD90ssqmZeOLt+gHDQkjY5DRjd3KsNvcgUJY0nkJYR0s5Y3dwgkPP1aGfwtEM96IO1jk/+sBwWtNTOeyhRR33/dii4qXJ+M93XCHytOxjbyzzEQlz54UIohT44YrJHQljf+CZs8pltdH5K8/3ySoPqOM+fsjiBYfb6QA65ziwG4jd2JXCWCQ76GEjUfy6FmdpE44/cRu/v53OrtqPcpwdlMsCIzUA98YO1DPJKHBBn/MDsQEr72X4AUH3wYz5f5h8h6uJKfvXCD66srYNxbCdgjLczNHFKbiRIgfS2wLnG4KUGvsswQk7OAMfpFXybioeONgRFsamv0pddAjMO4uMHU3NMoe3FPO9Gnoy1iXvW7bQTaMr15xl12kYRx2e5OqpHVsGWFV6e8T+mN5CSL5kWCb5tpGmX0JkAhELKmAhrnADgjdiMP0X3rKEA+omuO/OJVAUVXbZp51OJXE3qnqtDsahITA5VNKczuaerJ6FHDqbKbU5YWSezr2H9Ty8wKfvldW5LQGCM8SXCj5vdSAXtn312J6hCyTyCtKRIvcdTCA9o8THACYU8msOs196CYVh1s2WKzwQ8SwkwLiI6sQErXPYVzOWGmmhhO4Hv9YAs6j3fvG0Lf1MUGGmwM4GrrQxm+prYVO/ed9HGs13mSP+S5IL2d3Ls/k00MkZVqsJQ4sIrKtApjuEMAXo7x7DdK0OOswhL
 MDygcSRH
 vSQyhdNKA0DKk+6DAglwO1RlzunwOfAZ4gB/nKnTsAyKe8YGvz9LfCWRK3wHRhu/8DrPev/3dAYWCoEuf2PUFWDZto6KB9yFscP77S66SWagAWdpzKvB3XVj9qFXdni3nJbQMO3/oJl3z9XgMrjOVJj4jTzM1dOVM+8AKflA8mf5fpKQgUbHtjG2uWojLuhc9vsIrO94xzfvgr8OsB0FOsaqYKv0nOtwjPaxikmjQDabjlg8M+3KKU05AOSB0vNmIO7DtlaoLavlXg+rgh//c8XZpIeeeTu4PWjlIcEGPP4CRxICuNOgHFQvVcuk8LY6ToRKB33ytgyAPtOMbT59+MswclikqXTi1Mm1AIphi736VWItsT/IfytmiS9BiUWsiUX/7xfHR6LMIFAmtDpqFIVHGiUt/Qj6sFzjfRHYHlUBGyUUBfPyrQQs3OwiWGi6avhLrDXISoVvrerHLf03qO9qnf8JfA1j0athREiBYyUKw49OOKlh+XmrtboxILiHe5KnF27KXQp9cVOv/SzqQfMAMNmL6SkveWg2hEzOLeeunbTuzkenZBNx6XMCypJKwoRihQTt+tKpUJgkI6dOgclRGh+zxvLqZxCMKi4xZ/92MAZmoy4TfYYzy859SyiuScbtX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 11, 2026 at 08:58:05AM +0100, Vlastimil Babka (SUSE) wrote:
> On 3/2/26 16:49, Marcelo Tosatti wrote:
> > Index: linux/Documentation/admin-guide/kernel-parameters.txt
> > ===================================================================
> > --- linux.orig/Documentation/admin-guide/kernel-parameters.txt
> > +++ linux/Documentation/admin-guide/kernel-parameters.txt
> > @@ -2840,6 +2840,16 @@ Kernel parameters
> >  
> >  			The format of <cpu-list> is described above.
> >  
> > +	qpw=		[KNL,SMP] Select a behavior on per-CPU resource sharing
> > +			and remote interference mechanism on a kernel built with
> > +			CONFIG_QPW.
> > +			Format: { "0" | "1" }
> > +			0 - local_lock() + queue_work_on(remote_cpu)
> > +			1 - spin_lock() for both local and remote operations
> > +
> > +			Selecting 1 may be interesting for systems that want
> > +			to avoid interruption & context switches from IPIs.
> Requiring a new boot option is always a nuissance. The cpu isolation is
> AFAIK difficult enough to setup already. Could the default be that qpw will
> auto-enable if there are isolated cpus configured? The option could still be
> useful for overriding that automatic decision to both 0 and 1 for testing
> etc, but not requried for the expected usecase?


I think it's okay, as something like this?
(should work for nohz_full and isolcpus)

######
diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
index 81bc8b329ef17..6c9052c28e3e4 100644
--- a/kernel/sched/isolation.c
+++ b/kernel/sched/isolation.c
@@ -170,20 +170,23 @@ static int __init housekeeping_setup(char *str, unsigned long flags)
                for_each_set_bit(type, &iter_flags, HK_TYPE_MAX)
                        housekeeping_setup_type(type, housekeeping_staging);
        }
 
        if ((flags & HK_FLAG_KERNEL_NOISE) && !(housekeeping.flags & HK_FLAG_KERNEL_NOISE))
                tick_nohz_full_setup(non_housekeeping_mask);
 
        housekeeping.flags |= flags;
        err = 1;
 
+       if (IS_ENABLED(CONFIG_QPW_DEFAULT))
+               qpw_setup("1");
+
 free_housekeeping_staging:
        free_bootmem_cpumask_var(housekeeping_staging);
 free_non_housekeeping_mask:
        free_bootmem_cpumask_var(non_housekeeping_mask);
 
        return err;
 }
######

We would only have to be sure that this runs before cmdline parses qpw=?, 
so user could disable qpw if wanted.

Would that work?

Thanks!
Leo




