Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 316AEC88E72
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 16:14:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2380A6B008C; Thu, 17 Sep 2026 12:14:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E9466B0092; Thu, 17 Sep 2026 12:14:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DA4E6B0096; Thu, 17 Sep 2026 12:14:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DFD6D6B008C
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 12:14:38 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4F5F2A0430
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:14:38 +0000 (UTC)
X-FDA: 85223752236.04.6EFC6DB
Received: from mail-qk2-f42.google.com (mail-qk2-f42.google.com [74.125.230.234])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8AA9E10000B
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:14:36 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ufolOzMW;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.234 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ufolOzMW;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.234 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789661676;
	b=YbJOhhr5lfvFojUIdWLJn4WsBFdR4pyHHJCHzuxmEesFux3YsYwTxjV+ZTARPYePLyr6O3
	O6n6zxZH+d/z2Z4hnCBrEUvcO6X75DKgpNa7O34HnoHlEB8lfHI/7SptwWj0PT1dA19htg
	po2wZElPO0G2o8x+rE4zNyYl9YHPcqE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789661676;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LsJba/wwthkDPTXMKxwEUJe6vAc8xqzF49EUX8rDHcw=;
	b=0vVZ6K/uuieUh//EXefsRLDs8bv9SGKcg77bxswc5Tfnp0iux3UMNxzkHoSdPJlTnjkEmM
	XJmXoYcTo9M+3VYIOCiTuWjNjAVW0e9vJluvXkMUTq7Yocstis2qd1RS9L8cwPvcpPIVHk
	9gTBWIn0CWNap3cXEoxu0Bc2ca2UmNo=
Received: by mail-qk2-f42.google.com with SMTP id d75a77b69052e-5311edbc154so8204271cf.3
        for <linux-mm@kvack.org>; Thu, 17 Sep 2026 09:14:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1789661675; x=1790266475; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=LsJba/wwthkDPTXMKxwEUJe6vAc8xqzF49EUX8rDHcw=;
        b=ufolOzMWxZ2fot26IwkeIF74Yf8TbEwgCjzp4pTtkit1yY//KQN5i6ei+rXC6D/byO
         +GyIvMuUYdnKZPzn6iF+dGnYy7TuggYI6Ynabz3Z4q+zT7O9R+0/v0Qd551/fknK7qU1
         qSNG7LwTtBu2BKbD2WVs0JRj4nebC4VDeixpBB/fTo6MAGHAZZTOkAdQdR9bt3MnOKc2
         rzm2QA6bNXly9j/0sFL07xTsZQXv+IdPU4KXe9Ah5F2QPO7GvJRVylXxharJNw+xoIJW
         DsMiu6CAy2IQ6EKnDqsK5wn+2m3ew+FGlGkk74yIU5Dpv5yWyBxLJnWHwosMaNGaKp3x
         xtkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789661675; x=1790266475;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LsJba/wwthkDPTXMKxwEUJe6vAc8xqzF49EUX8rDHcw=;
        b=Rah84hsiMlqnwK8/wbyqV3WqT7gNPu2qsLNP+nAu4SLI3vZQVK6hX062qm4oSDIpuX
         oqJe51dzZbvbRvvIQ9DPAzcrr6pYhXuJdzWUd5q1CWKMKRLhVmhp8bz+Pjy/m+V54wQi
         FNrd95A3s1UKbST/FYHbm3IQHVVaO0S5ZV64SgZ+j9FiwKSOmcki1uzYY2OpS+uFJO21
         KZxOrhVjecrgnTkt/oXZYDZQYQdbfLX6CSxPqdfoBoqcbxaVQ2JpWWoPI+yUCPuTS2Yu
         +t385v9YIwslRjItfSfJ6yujD6Iipw6gUvm3Q8xm+3xGhNF16HcaA7OlrWLz/PfW8KwF
         Hwnw==
X-Gm-Message-State: AFuF++kowH55Mnh2JhmvPyBoPyQgdbbaqRwXY6mcs+fd1qyC5bnIoIa7
	7AgaUi4kgM0KYr7wy86dilcJ7WFaZcESbQ2hfWbZ75Gpf6VIhOQj5QNQHd5cAb4PJYIDJ3vciiI
	MS/D0
X-Gm-Gg: AYBFou3ZzVPmyJiAnRcD95RQyLi6ucNbFqHp0EkNnVjFiCgE69RKn995+cDdGu80iLW
	JfmJq3GqekAP2wl/z9/1pHJ81VD/po6enJhbQCiAy/DCA+9dvoPgkKj5kCRbTumPwXkIByFuDS4
	eJqtk3dzFmwAIA+c9L3UWOLutTc0XPMblPjwcjm7H7me0mkQ/7a7npUpFBDXW6mGV8PV+aQ3pv1
	jRLTgof86Jd+TG7q0/URHHJmcf9evkETBwPBq1gSoH/xA+5cLIgng7o28iVoDGWWgRXnTKc9f6T
	3819h47LnZk2fIXCP+NB04qJ0vNYYv3fkcGSgapjeV705jROsHfYgzKbK+6Sdg7F5P9t9nctK3p
	6pMB1nvJfYaz6FmCuJMS8LiS49ZJiiyQepDK6zaQH1l2ev4xVIptE0UA1wIcB1OPpAJY/KXnbcJ
	EksMWPgH8hUyKwDWs97VFOMkydgw2Gz6bvgooK+MFZh/JjTgrqW5yBKssCkwAQLqK3IkwEVFr20
	/dmBwoHYqV1iOlP9paV7SUiCw3lvc0mTIzyeGijGX7IsKHQjlj5tKI=
X-Received: by 2002:a05:6214:e87:b0:912:517b:90a with SMTP id 6a1803df08f44-912517b0c9emr19817166d6.41.1789661675506;
        Thu, 17 Sep 2026 09:14:35 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91252c7cb8bsm1199036d6.20.2026.09.17.09.14.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2026 09:14:34 -0700 (PDT)
Date: Thu, 17 Sep 2026 12:14:31 -0400
From: Gregory Price <gourry@gourry.net>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	mingo@redhat.com, juri.lelli@redhat.com, vincent.guittot@linaro.org, 
	dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de, 
	vschneid@redhat.com, kprateek.nayak@amd.com, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com, 
	baohua@kernel.org, lance.yang@linux.dev, usama.arif@linux.dev, kas@kernel.org, 
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, jannh@google.com, pfalcato@suse.de, 
	osalvador@suse.de, hannes@cmpxchg.org, raghavendra.kt@amd.com, 
	stable@vger.kernel.org
Subject: Re: [PATCH v2 1/4] mm: support promotion-only NUMA hinting scans
Message-ID: <aqwRX7Ula6ImRw3c@gourry-fedora-PF4VCD3F>
References: <20260911001826.2109390-1-gourry@gourry.net>
 <20260911001826.2109390-2-gourry@gourry.net>
 <20260917160328.GM4121339@noisy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260917160328.GM4121339@noisy.programming.kicks-ass.net>
X-Rspam-User: 
X-Rspamd-Queue-Id: 8AA9E10000B
X-Stat-Signature: 5bzdzeo713qdzd8sp5jbzno5tmooq97g
X-Rspamd-Server: rspam01
X-HE-Tag: 1789661676-957368
X-HE-Meta: U2FsdGVkX19pKUvDUtXej8s6bmQiImd3U9kvzzNn9YWKi4/rG9rWng9ryqGI8x73gUyTxkV0ZshUB6+SGGsTKuZDKDoIXV6uJ9hjnt5uMrhUGqv3vsMhCjVFzD/+veJ0ShvusGDEWS+l40iwvHN6kqvaXBvgCg6CF+mU8rfK1fjX4X0s2jcxpWh2vqOaUh7AJ1CJsL0otDbM8O3EWaMHvrDyrfRwk2BPdCr69uXSZ0zqjM1oWt5i3hsBbrgCix5tLaRldXhm8NMR2sG7VaQ/xnZ8EuvjujRFP6J6rW6feCHcITIvDrPzgUBcKi3BLpR4EAi/eKBoNO+b9Jbl/GMPUZMbPybC1T4Ct7BXTX8hbREpp0QS5cdXF6CUd8bnRqU48tpO5YAIgrmZSKCGwFjMLCCaSKkWw0mLydlrbW/CFxPeYhIYBrHDft0yBHP0dlUJerRe3QOki2fVL1Yb7ycYEXFdtcufqFAqY4WH6mvwVUoEMofMIPFM8VpbTk06cVTF39D6gI117yi0+ez+DHuH42XDg9ff3jpj5sA8//DZt36xYcX4VZHqDwd7eG//iFInCtKf4TtRT5ecHY4ELmu3VIS7u0ed3r+surWUMqkv9fOVqyWHw2URd5T4xsE+sUpOBjdDYZN/NLiiiOOGEo6YlPX3fuTYwduRLMkL+eFTMuP6YJhnJq72Wu7J33MztqNAcriijs1m7rABzyCPO8aL9mc3P6apTipcfhD8c7GtozRY+SzKR3E4Wig3uwZj+QS4C9B0ac+FRlTI0UlAMy/L6KKGbZDbV/i6y+0bTgt18F+QG1ryEHH8u21FeFOpadi+Ng7I6lqTK4TlHrNfQcJ8VTVhmEO8p8i7kLEY9zy4UyJNMGkRsCDUA/YAhTc0ui7NOeonKLLDDCL5XGCAI5o0S8Ks4h+pYqnFKZkzDSEAmIKQoFOoN23yXtBHGq+GXsAMlvqHmdFe0OoBzNbjuln
 hAdeYTVd
 npy6Iak04dQxHxIb/Rs+RF1XRB5T4IrKYfl9HcuV+PfLlWNGqWtdAajoNDW8yNMvIR6+PHqKhQf/CZhzBy+ewM2J7+rDjN6qusCzwH2gCcis4hNsdxqF6uo8E/XUnnsY2w3KdJYp3Ob4nOBgw3tUkm4FGMKsxZE9BefNIvrtWruhQAuXh0uKsXnXyeFT0uSJAIvdC6ccs6ox9bdowJSN9xwpIwA1EdeDBvGwByB+9/yHfNTSL4vO7fivzyCW6CxXtvgE1NlR9jOBWHv0Q2RxLUM0SPxh3jgSYzZQaCkIWq2vhhBidYyny8WC73XgyBoG3hpH3boldx1KMQBbNpwPTCIflFi+TU1M3dKj/00xZquaVaqFm/78ONlY9soDZ0VuP7ttOyytxF4zWheS0VV7OZtaKrw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 17, 2026 at 06:03:28PM +0200, Peter Zijlstra wrote:
> On Thu, Sep 10, 2026 at 08:18:23PM -0400, Gregory Price wrote:
> 
> > diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> > index 8dff37059faf..81359b414947 100644
> > --- a/kernel/sched/fair.c
> > +++ b/kernel/sched/fair.c
> > @@ -4129,8 +4129,10 @@ static void task_numa_work(struct callback_head *work)
> >  	unsigned long nr_pte_updates = 0;
> >  	long pages, virtpages;
> >  	struct vma_iterator vmi;
> > +	unsigned int numab_mode = READ_ONCE(sysctl_numa_balancing_mode);
> 
> This thing sticks out like a sort thumb, does that want to be on top?
> Typically reverse xmas is preferred and all that.
> 

oi yeah sorry, should have given this a closer style look.

will fix it up.

> >  	bool vma_pids_skipped;
> >  	bool vma_pids_forced = false;
> > +	bool promo_only;
> >  
> >  	WARN_ON_ONCE(p != container_of(work, struct task_struct, numa_work));
> >  
> 
> > --- a/mm/internal.h
> > +++ b/mm/internal.h
> > @@ -1237,11 +1237,12 @@ static inline bool vma_is_single_threaded_private(struct vm_area_struct *vma)
> >  
> >  #ifdef CONFIG_NUMA_BALANCING
> >  bool folio_can_map_prot_numa(struct folio *folio, struct vm_area_struct *vma,
> > -		bool is_private_single_threaded);
> > +		bool is_private_single_threaded, bool promo_only);
> 
> Two bools rather than updating the existing bool to a flags?

every time i've added a flag field someone screeches at me, so I tend
to avoid it now - but i can do that's the preference here.

Otherwise, i tend to follow rule of 3 for generalizing.

~Gregory

