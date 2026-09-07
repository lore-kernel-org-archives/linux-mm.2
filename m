Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94122C79FA0
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 15:47:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADA786B009E; Mon,  7 Sep 2026 11:47:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8BC26B009F; Mon,  7 Sep 2026 11:47:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 979F16B00A0; Mon,  7 Sep 2026 11:47:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7520B6B009E
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 11:47:21 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 07AACA38D1
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 15:47:21 +0000 (UTC)
X-FDA: 85187395482.07.A6BE3F0
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3994514000C
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 15:47:19 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=AP+fWGW0;
	spf=pass (imf26.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.46 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788796039;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mmDZvfc6UbCMaSCl3e5zbW7Me/bO13UXyky9OUcj+5c=;
	b=7LJXlCRipyrHTVzqhtzJOa4rvdU2QGR5eKIj1U+097Xa9aL9MvMdp17xQxP5xYa2nMtIwQ
	EzSIiN69NEPzDsLyvOlaGNrgg3iKACKb4zik8WktIygp72cB7KLm4vfz2rdBBqeNkpCamg
	Hs8PW+N8d1jH7sdUmRZw8OT8u4kaIqw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788796039;
	b=FYVJ68Q4mJiNrPdBVbj0dvGKcjQfIvYsMWgb2Y47VFEpEx+8RWxCD1DpYnDbjQSVLD9pBn
	bzTB8c2Jrh6S517ADlHBL0bOhng1ySXClzDm4L6XFqqTgGlhlnQmbUJCQ8kozM9ZbG68DN
	GlMstCZ2aiis/NY9G2KWd5z/j+FjqJk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=AP+fWGW0;
	spf=pass (imf26.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.46 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-91034716d1dso58975996d6.2
        for <linux-mm@kvack.org>; Mon, 07 Sep 2026 08:47:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1788796038; x=1789400838; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mmDZvfc6UbCMaSCl3e5zbW7Me/bO13UXyky9OUcj+5c=;
        b=AP+fWGW0JWi3Gcz/VK5zz4zVRLWWTzZixQ3LdzKbfnVy4UB0FJxEi/lcW86su/Gcx4
         +Fr7RrNx3fELRZyqu18MKMs84uOCBLg1KTDeP+6zkDn6ZaptwaMD9b8NzarAWo0Khjpm
         Ln9qd6yQ2rLnOYLy4XJ+aKWH3oqRQGYt1C8NZ/bSpqh0S24irqaYqpyso0foR4/5hZiV
         nylTcil5HLwVpaNKYLFk4W4c7NirofEHBq6NSzh00w1xOsx6HReAh4RvJeFKVuBvHU96
         LO4bjMgukZf8fEJSGltyMd8O4EIRNsNYmTVejtoAt7zHw/pY0VwJbqRaGe6VuEm33hRS
         ehdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788796038; x=1789400838;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mmDZvfc6UbCMaSCl3e5zbW7Me/bO13UXyky9OUcj+5c=;
        b=fTz3QNqb9G3i4lYeJVBpC7RR+4Q03Sgsqtb6thbkc2xUhmaBBdBAqJoZxzbCHXt2o7
         6asS1FdLQtgkEXhNwzblfW3Bnpt6Qt9OMB3yCs2jnl7CFXSaeAHZhHhOJFt3H/+9p/AH
         ldCEeNteWyDTxNVBFCCo7X+oOKLu+05Fb0iyfvv2/qabAgz3VNgDHHUhgQB9saqHXFW9
         8aQt3xhO9YUeJgH6VHycXXr/cXUTe6xAzEeskN8CocSvXQmsmBzCq4Q2zixR2dvKap9E
         Xr6cfKv4s2aYmGvalZWfxN9j42Ri/k1oBQlviKOT3vGOs7dv33910j80F9089znKPLuI
         SXLA==
X-Forwarded-Encrypted: i=1; AKwUvBwws9sGjILDZS1oqwUxGPcceVeutPcPW2fdz6kfKHpmBzK+7NKZHeamDAP8xz/GR1FHb4kwovgUqQ==@kvack.org
X-Gm-Message-State: AFuF++l4s4bTVMdY3Up5B+w7m/83pgUap94JMnNayv73emGZ6mqkbcS8
	FxKAEqP488jpC2qOCZTtxEh9hCWCXQDfdPQ7JH9dUjr3VDoZNfd5IeXy+V7YZU7ZYeQ=
X-Gm-Gg: AYBFou0Vy56q3lp7rpCoM66uPKK8s94gtFstuH3tVGEK1k8/lRykWwYvXbTIClLwr3R
	+P+oQwhMurVC+oaSE1nICrbi5GRP7oM0Kg3rjIQG/7VuxDuu6GKI4KwdwQFEAYqtvHmXxog3JtX
	BtU5boLsdK9I6ynnY8I3Lmloo4gR9NEwLs0+ejkluyZS3ajH5OI8Ow4d+F3RNjHZ6H7Nmca0zrg
	7sKdbgmEsu0JzPeJf75clG/pW87D+JDm/qYvdAr8biFsNQtqWPQ+Rke9K4cBVz5iUchzUcFeQtE
	C+2W2bRe/U/q5Roqc53cSZDvlJVDlHTuefD3LdRRb3umO8awLjtuJDO8rRIkLedaGvx4FasweFG
	WHnfiws5Avs/szMniFMyNe4Rzsh2sE1OCMRFicv44pkitFkuVZ29PNgP24DFx2EibxizsodJpfw
	Vq9SqOs7ydCLAvIJdK5RpD9/M6fjleIWQht+VvQzUxz1GWiw0zxSyc00II3qat+24hwLhHwYXeT
	7DDJOYwuH2C3n0uUuPrB4Cv/jDz6MgdSbaRlsc43LoS
X-Received: by 2002:a05:6214:2b87:b0:910:4861:43ac with SMTP id 6a1803df08f44-910486145aemr202492056d6.5.1788796038419;
        Mon, 07 Sep 2026 08:47:18 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-910406afe48sm94174406d6.43.2026.09.07.08.47.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 08:47:17 -0700 (PDT)
Date: Mon, 7 Sep 2026 11:47:15 -0400
From: Gregory Price <gourry@gourry.net>
To: Ye Liu <ye.liu@linux.dev>
Cc: Tony Luck <tony.luck@intel.com>, 
	Reinette Chatre <reinette.chatre@intel.com>, x86@kernel.org, Christian Brauner <brauner@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, 
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>, "David Hildenbrand (arm)" <david@kernel.org>, 
	Alexey Dobriyan <adobriyan@gmail.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	Oleg Nesterov <oleg@redhat.com>, Ye Liu <liuye@kylinos.cn>, Michal Hocko <mhocko@suse.com>, 
	peterz@infradead.org, paulmck@kernel.org, mingo@redhat.com, rostedt@goodmis.org, 
	jpoimboe@kernel.org, mic@digikod.net, tglx@kernel.org, linmiaohe@huawei.com, 
	nao.horiguchi@gmail.com, rafael@kernel.org, gnoack3000@gmail.com, sj@kernel.org, 
	rientjes@google.com, shakeel.butt@linux.dev, xu.xin16@zte.com.cn, 
	chengming.zhou@linux.dev, will@kernel.org, boqun@kernel.org, frederic@kernel.org, 
	neeraj.upadhyay@kernel.org, joelagnelf@nvidia.com, josh@joshtriplett.org, urezki@gmail.com, 
	juri.lelli@redhat.com, vincent.guittot@linaro.org, paul@paul-moore.com, 
	jmorris@namei.org, serge@hallyn.com, pavel@kernel.org, lance.yang@linux.dev, 
	mhiramat@kernel.org, pmladek@suse.com, longman@redhat.com, 
	mathieu.desnoyers@efficios.com, jiangshanlai@gmail.com, qiang.zhang@linux.dev, 
	dietmar.eggemann@arm.com, bsegall@google.com, mgorman@suse.de, vschneid@redhat.com, 
	kprateek.nayak@amd.com, mark.rutland@arm.com, Dave.Martin@arm.com, james.morse@arm.com, 
	babu.moger@amd.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-pm@vger.kernel.org, rcu@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH v2 6/8] fs: convert process/thread iterators to
 for_each_*_rculock
Message-ID: <ap7cd8OigImcG6eX@gourry-fedora-PF4VCD3F>
References: <20260907081334.1152889-1-ye.liu@linux.dev>
 <20260907081334.1152889-7-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260907081334.1152889-7-ye.liu@linux.dev>
X-Stat-Signature: jxycykn8kdeen789mhym3dm8d837kgwd
X-Rspamd-Queue-Id: 3994514000C
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788796039-514481
X-HE-Meta: U2FsdGVkX1+PuU0uXQLONsF8gmHv5hlIlSbnoT6HWg2Wh1st38OfSdPrPFG6tZ2HueHl2xZBwfGqqM0gNsyn1FSfYp8koze0PmY1qEqdD4Qj0jDHfWU1FjBGZ624y7BLXhphOxTAUvZcMyfFYnl/GHxZhDbmchr2/pQU6J2IibBFxGCBHsboInFj+tnQEUQsLFjgtCDcT5j10jr3lWtb1a4W+QHwSGhenkg5HooNxH88a+xHW6+/1kGAnkfBmjTxau23piRcOOtm668DFkfMXxy+ot6g7xN0C00XZ9vg4sdqVbLcSogBdXaZWFHix4QARs7cTSNL/A+Kc5lD5OpUlMSqZJdBFn3aPi+E6a7dUD75f2tnEsbIYYIyfG1uN+IDiPmoQeoTn/vpuIee3t9bCtVzFwa182+K6Bv09lyGAadVa5En1AdsaKPJafZNX6G0Yp9Mmt7ENJ9n2tyBglbOGNWHuJLo2GUH8RQ68hKPaTmfe1rI+Zq9rEH9QriA0gOe+baXbZOIPiCMkasQapzbJZwAPJnTO3hKPOAtdZC2F28DljbFTVDJn+T5drS15tCSd7Ax3Qw+2ZA/besFF8kuxlrArmQUh1R9Ep29pFJlDJk9jrJ4d1f2u6BBRIKOdtJxRLGgoGj+twoUDFBrat/j9xyMR9EHnpAoKfoyHXwulMyDNnVlWBxdZ9iKT0EZfDbe8EBVocQjYgU5Vu6/iVbnFejzV29e5BKqs3E7RK6wSjOpT21LQ1otvIt/kGPURdmu1LT/wn+Wq68/lHrnl+nIAvh33ZXSAY5sMpfaWHFr3G7lrwQAbAejAvRiqGHfrZ39A96pv49MD5Ro2l/dZ0tjaBq4b1AbKmdONGgznNRMom0iY2wlXpkhvUg0vNpP8WdCPXVMEWtux2AmlucpIlwJVjg9SMhDOsgHNc3jGWVG+Lv4V2qz0elElssDvATvCDJ3yQThvSsAx7UsKjYhxPF
 FQSP3iML
 W4pyh4/stj01+OCneEYSdB3mpvjxaXQSGJRzPgdFDyJOFuwW+9PyikGFTkUCp89n9tLRbGw03HLaT+7THLu91gmpQC4oE+VvyBNNqbvQznqsKUWCIcQLjytbEBifx6v583/Avd0vB4SvYd6txf6loG26uhvNsA/MnvnfKAYTKfcqRl82qF6uqfGKxVCsgYHFE1WNBZHB1T2Z5xi7jhD6u+PZeufgNpI/rLrvEtiShCu8x/6ei/z414Jlg4INCTgZuc4mpPH3/oFfUvQFNNa28X7LR0mI8PDcuoG9nKJjUCzZCxr+VHm7dDzluK0qAPPU+zJpcUc6Z6+yAH8gYqStZxsM9UeFgb3X4HbrwvbZMw+IxB7gnq6yJS2NRFQqkXRCrGB4S18v0+yv9awh9j4SOd7azkmPNUiZ/u5Gt1XOKZCTdTjS22gZa6JB8Bobn3ZVrCHsAbzxbV+gYT3erzZlAwgjWfhAWiWqLcxNThywHympFriuPNzc4sw0OvbAwL7yyhaX1x4LA+VPWCkv3wDfzYs95Xw0zVvJrJ7vsMaVRX3ZshnUQCuW0XSd7ZeC5ZRO9vwlI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 07, 2026 at 04:13:32PM +0800, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
> 
> Replace the manual rcu_read_lock()/rcu_read_unlock() pairs combined
> with for_each_process() and for_each_process_thread() loops in fs/
> with the for_each_*_rculock() macros, which scope the RCU read lock
> to the loop body via scoped_guard(rcu).
> 
> No functional change.
> 
> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> Acked-by: Michal Hocko <mhocko@suse.com>

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>


