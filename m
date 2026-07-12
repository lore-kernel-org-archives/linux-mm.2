Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEF96C43458
	for <linux-mm@archiver.kernel.org>; Sun, 12 Jul 2026 21:44:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E1C26B0005; Sun, 12 Jul 2026 17:44:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66B476B0088; Sun, 12 Jul 2026 17:44:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50E676B008A; Sun, 12 Jul 2026 17:44:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0B8916B0005
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 17:43:59 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 67007C239D
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 21:43:59 +0000 (UTC)
X-FDA: 84981452598.29.0A83CB0
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf28.hostedemail.com (Postfix) with ESMTP id 8A9BBC0004
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 21:43:57 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=aifhjWPS;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of leobras.c@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=leobras.c@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783892637;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HCxD8V4rPJmnTk5Z484eCKRQlIsY0VOuU0QQtm5539w=;
	b=5IS8HdYJ8sJy+QFov05/+R5mAsv3CuSvPBemRaV7Nk+1QXcIrpn91TLldryiPTa0YUF6cO
	wBz34uBRvhLsBglCgkoz9VymHxjUoo3mZTYBWD2VTFUHHoQ1aFaQGblXB5XDtAtpp3SBnM
	eCYikDpCkQ0MvGlceMLxfYDRwJ0okUc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=aifhjWPS;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of leobras.c@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=leobras.c@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783892637;
	b=isRB0NygULhDTnC5ZKGcKA8g/a5uWkg6XyJ8j8CQLQhrnGTiazgRMNDY+AXj1hbUBSMbaI
	PUtgE486K8b9nOt7pJ2dtM9kdKa7yQy7WnFG/axCY7MMaJvBwtvYXxCVu/yAfZOXXNW7Hj
	rISBm0m3r2U1wAlOdd6/k8Y0odShwrg=
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4921eed3fa2so23092905e9.0
        for <linux-mm@kvack.org>; Sun, 12 Jul 2026 14:43:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783892636; x=1784497436; darn=kvack.org;
        h=content-transfer-encoding:content-disposition:content-type
         :mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=HCxD8V4rPJmnTk5Z484eCKRQlIsY0VOuU0QQtm5539w=;
        b=aifhjWPSw7KK+FHYHFE6OYtqp9kwFufUZePI7b0JpWWP31JixKuY/oiabj0uWwSUuC
         z5x3UpggE75zmpUy91zq4RyqH37YoUvZFiLQtYpZcKoWd/cB84BT8i4XOXuJ/+eNj0Ft
         3kraSdl5F0s2vBwQ1WDyNCLrTrV3ZgzP4GHzgC/dYz3jxBYZfLRH+zUM15sSI/VUbUQ1
         4r387GYHzFZ3t8cyjpT9IIo4kLgY1u2OR0WlNsy535bdCs/flx7MYATez09yLKPKp+oa
         khlkAYDtAT3+qgIr9Pq/yvSN/254qx2QA/HqMGJ7uwIgmAUeg4syweZsRftAtKXViV/6
         biKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783892636; x=1784497436;
        h=content-transfer-encoding:content-disposition:content-type
         :mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=HCxD8V4rPJmnTk5Z484eCKRQlIsY0VOuU0QQtm5539w=;
        b=C7mJGmi8ZQ1e9GzSJqBOqhU/CMuIcYo42v5JkrOf58pJy9X3gaqYdVO5vCT5Q7MsNC
         EyFiVxpTrBsF6cJF4VaDQ1knLP4l9es7ENw/1RNlWbeaAPLgHbHaYrAbiYVwuGKx8kU0
         4VTvzErChQxj1INp0i1QXOrYNvoo5L6VGyQBKtELVgVwVmgoVwEgW75xddaYgFrl2euF
         v3yFGYSsPHPifPt/d63lgJufWFJvjF97TG044PnThToBIxG2xImWOZLEyAnoa7DDtbiR
         sHsdOOxmSNRKPF04x0pEc6U0Lq9pE9HT/mUwoMVGJz38SPRdSnI9UK6roH1wI2n5IW2c
         +VPg==
X-Forwarded-Encrypted: i=1; AHgh+RqSJZ5FdafoUHdJkYo5KPcAWgZx56G2oCNCV3IAT7vPBYrfZmV4D+DbCwbTQbxduthkDnRL+BKAcw==@kvack.org
X-Gm-Message-State: AOJu0YyQSwQzHBjzFbZ7CCMURSkDwu/SO6lDBMAGOlB0t5iH59w6Ov56
	3k8Dgxj5NR0DwenuFoZO6ZqBvDSDSOb8qRGvu7Nr3wd9zh+AfpsFOfBL
X-Gm-Gg: AfdE7cmQ9lVnMqqhUG2dsp38GRJnnW+5vz6OnWk1NwDljsUTdeuOBfLFosM73zfVUd6
	wf/UZCMNMJM6fgaJPceYc76FCKKqZuD6zw67GzD4ObpT/t0vSan0JM6sxSZTd3g5bLUvVubcelx
	hKekm9yyQ+fUwROqsuiGPULOqL5YFVgJIN50BCvPGU8dLaT32Bgx2JFaMeY4FyQNZ+wNxSKKyB1
	3yAOX3DhBlAKGLzU177f2AXf6eda7yvcXOG9HK1c7gwAkKC8aKsmAEwcIU6O2Ov81zYWxv6kS1w
	LgrNO2SCC04XegbFELwoFxcfikwURIJbDzuMvKkjFmxTMgg2j4BmSrA68Seg8WbTc+1rrFaXNmb
	xad0wEsnhvMi5V/m/COYelZ3t1qwAEgmFqizXAy1UigQDCjLYsvzadGXkgKocWRt7ebav5g2Eab
	T4LME20nsafk8jM1lPQxU0RA==
X-Received: by 2002:a05:600c:4691:b0:493:f764:1f69 with SMTP id 5b1f17b1804b1-493f87d5d44mr61691195e9.8.1783892635821;
        Sun, 12 Jul 2026 14:43:55 -0700 (PDT)
Received: from WindFlash.powerhub ([2a0a:ef40:f61:3b01:d08a:833b:756:8fce])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493ffd304d8sm42196365e9.0.2026.07.12.14.43.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2026 14:43:55 -0700 (PDT)
From: Leonardo Bras <leobras.c@gmail.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Leonardo Bras <leobras.c@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	Waiman Long <longman@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Harry Yoo <harry@kernel.org>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Randy Dunlap <rdunlap@infradead.org>,
	Feng Tang <feng.tang@linux.alibaba.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Kees Cook <kees@kernel.org>,
	Marco Elver <elver@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Li RongQing <lirongqing@baidu.com>,
	Eric Biggers <ebiggers@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nsc@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Thomas =?iso-8859-1?Q?Wei=DFschuh?= <thomas.weissschuh@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Douglas Anderson <dianders@chromium.org>,
	Gary Guo <gary@garyguo.net>,
	Christian Brauner <brauner@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Coiby Xu <coxu@redhat.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-rt-devel@lists.linux.dev,
	Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH v4 3/4] swap: apply new pw_queue_on() interface
Date: Sun, 12 Jul 2026 18:43:48 -0300
Message-ID: <alQKlBaKIOAxMzc2@WindFlash>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260520150736.HZnlFkv7@linutronix.de>
References: <20260519012754.240804-1-leobras.c@gmail.com> <20260519012754.240804-4-leobras.c@gmail.com> <20260520150736.HZnlFkv7@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8A9BBC0004
X-Stat-Signature: 6iphmnz8ne5sbodwew6rfdptewk57ym3
X-Rspam-User: 
X-HE-Tag: 1783892637-147725
X-HE-Meta: U2FsdGVkX19BY/53sHtNm7xKgS/CgiZtGVvE1Pmyn6Uz7nCihYn3Y38TNeOsH2cLA6Od0E41Uyo3il5W1UAF/BCt76ntFAM9Xj+h0WhjSgtZRjhvTRljprowdT7cei3meT/S6gGuOFfAyWTg7sb/SJr0tszSYnq7XTah8Tx6a4GMs/552W8Ajttb9skreQhd7rMD6wYxTjnRj6Hel2pyrCAtSZ1nl5jAlbuzWZnOAsITUkl4/27bSRvpb/Zkp6eooYu4hPZXCzoSOqyKhaNhDKYurdu7DUSsw/2azifES+Qz00oFtD7b5C2wOwdMzmy9S3z+sOWAfpLjwKWJNDQ3tjnI4IWST04FqAzZGv+/9sfkdLqDMphOiX6kX/pU6QWy3nbaDPtVh1XFetuIuyOiku6GoiNTLPbVUnBrMUN76GwiP8SxuzXzoOspsxYFTTbT6k9EYnq2Vuoqx2JQelt70AZXhBx+IutIjrYhApcQvqJ5YK5e3xwzjbU3wjGGzf8orNWMpjh3ibK2G3nVFtMHtjVOZResCJXCB4QPc4g1MmPzycFiBv0vIxS5cVO6dXmh5uNSrZltdOLkr9rH1SXYn1WhV+jfbSOrfH8/5BTU6wK1R9nV//0XRY4YG822fSFlwfwpGHdfEVnfhJdQfcv/MRXgB7JYOndGheyLg+w9Mr8FBsvSVzzQQoyrr+x6I0okQR3eDbyUkyvsnWI2wSsApcA6qG7AjmLYw6ZRek2Wsu4un7vFnPJN7vPQT7VYW5fNpHp2qHHKZ13rzPXjjKBazVJ3ArWGgJo/ViI3Dp5z/LTlINJdg4GCi6OM64D39gHGtu3v/+/vL4lprHHQMbbpui5zo07fr9fls9DDyIqRnZSei3oXeI9N47aofM86G4F4GlgyrhjLAsaDNrlgWVn05ZyCs1fb3j6TEoIfUvI4e3rzIn3n4tCt5Wq1h6sbMan1WUyoo4LRpr5qX0CHn8l
 I7bZ8dAI
 pV6cyMZ0EjX4nSsay+aBCFTh0yi1FZHIy/dfleAnvyoJVm3mB0F89QTYnULgQVHgt01yqLo+IVKVMEni0OFwD42bW5WL2reTSxc28zCtQ+q5VHEWB/I2voJ4YGRrVIaGdbK8WL+uH6Sd/78LPwsDyBh85G7LMEAG1Wcw2zG7dAwzXnh8rEs5dI1MxI4fDutd6qzx8R/Oxt1DrtFCPLmEGb6f4Sd/MwUz3fva55eEzpm9pYDIjawoOdNcB72NiZsBy4kSD7pwmuTtKGmz1cbh4Bg/UlqNKNv4jQr31etvxa+aeTmytlvBtrkE8xwUHi9VxHPPnCMAP7tNopuln73iN7Nwuhhljc4/seQCOjBmYURn4UhAjQSoY/pOOVktnG5wbqGkry6s8s6rsmg02DnmvZvm0swTJbvAHuPhDonPskeHfW1WNDtm1cYqvJ2IlCumC4JnNQZQBi8iXI7Rym5Id6Qf35rMIHnyufBEAZXlcUnwQBFB8ViJlvrEHdMgF9mOHEUqdqzoh76Lk038dxYa26PM4O4pfulBe8RRHJQ57Whgi23fYGTpd33xKfAaF3W3ClZAYIm/SybIRGaHEz5yfNveAIOr9s4JHUInz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 20, 2026 at 05:07:36PM +0200, Sebastian Andrzej Siewior wrote:
> On 2026-05-18 22:27:49 [-0300], Leonardo Bras wrote:
> 
> after digesting the slub patch,
> 
> > @@ -882,38 +879,38 @@ static inline void __lru_add_drain_all(bool force_all_cpus)
> >  	 * If the paired barrier is done at any later step, e.g. after the
> >  	 * loop, CPU #x will just exit at (C) and miss flushing out all of its
> >  	 * added pages.
> >  	 */
> >  	WRITE_ONCE(lru_drain_gen, lru_drain_gen + 1);
> >  	smp_mb();
> >  
> >  	cpumask_clear(&has_mm_work);
> >  	cpumask_clear(&has_bh_work);
> >  	for_each_online_cpu(cpu) {
> > -		struct work_struct *mm_work = &per_cpu(lru_add_drain_work, cpu);
> > +		struct pw_struct *mm_pw = &per_cpu(lru_add_drain_pw, cpu);
> >  		struct work_struct *bh_work = &per_cpu(bh_add_drain_work, cpu);
> >  
> >  		if (cpu_needs_mm_drain(cpu)) {
> > -			INIT_WORK(mm_work, lru_add_drain_per_cpu);
> > -			queue_work_on(cpu, mm_percpu_wq, mm_work);
> > +			INIT_PW(mm_pw, lru_add_drain_per_cpu, cpu);
> > +			pw_queue_on(cpu, mm_percpu_wq, mm_pw);
> >  			__cpumask_set_cpu(cpu, &has_mm_work);
> >  		}
> >  
> >  		if (cpu_needs_bh_drain(cpu)) {
> >  			INIT_WORK(bh_work, bh_add_drain_per_cpu);
> >  			queue_work_on(cpu, mm_percpu_wq, bh_work);
> >  			__cpumask_set_cpu(cpu, &has_bh_work);
> >  		}
> >  	}
> >  
> >  	for_each_cpu(cpu, &has_mm_work)
> > -		flush_work(&per_cpu(lru_add_drain_work, cpu));
> > +		pw_flush(&per_cpu(lru_add_drain_pw, cpu));
> >  
> >  	for_each_cpu(cpu, &has_bh_work)
> >  		flush_work(&per_cpu(bh_add_drain_work, cpu));
> 
> Why do we have two iterations here? Is it just a proof of concept that
> is not complete yet? I am curious why it is okay/needed to "remove" the
> one workqueue but not the other. Maybe the other does not bother as much
> as the other does.

Argh, sorry about the above :/

Slub was converted on a previous patchset version, and rebasing worked 
fine. I should have properly checked if any other mechanism was added in 
the file, but ended up just checking the one that was already converted.

> 
> But essentially we can't use a spin_lock_t here because due to the
> hotpath nature of the code it will kill performance. 

Correct

> So instead we do it
> anyway but behind a switch so that only those suffer from this that do
> not want to suffer from workqueue interruption on a NOHZ full system,
> right?

Yes, one can choose to pay the price to use spinlocks here and have less 
workqueue interruptions, if !CONFIG_PREEMPT_RT

In case of CONFIG_PREEMPT_RT, we have the local_lock() already becoming a 
rt_spinlock(), so it already pays the price to hold the lock. So it should 
be basically free on this scenario, and save time by doing the operation 
remotelly instead of scheduling it.
 
> 
> I thought that this improved since commit
>   ff042f4a9b050 ("mm: lru_cache_disable: replace work queue synchronization with synchronize_rcu")
> 
> Did it get worse or was it not entirely gone?
> 

I worked in this patchset majorly after that commit date, and it was still 
an issue up to last time Marcelo tested. Not sure of the impact of above 
commit, but I suppose it may have brought some improvements without fully 
fixing it.

Thanks!
Leo

