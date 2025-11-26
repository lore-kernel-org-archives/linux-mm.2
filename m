Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5A84D1039B
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 17:15:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 886B26B0008; Wed, 26 Nov 2025 12:15:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85E446B0098; Wed, 26 Nov 2025 12:15:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79B456B0099; Wed, 26 Nov 2025 12:15:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 690966B0008
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 12:15:22 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1CC85BADC6
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 17:15:22 +0000 (UTC)
X-FDA: 84153409284.30.F5B82BE
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf03.hostedemail.com (Postfix) with ESMTP id DBA4A20017
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 17:15:19 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=hoxz72PF;
	spf=pass (imf03.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.174 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764177320;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lpxmbrt4LkK+rw3qfn3c0/9obbJZWwIG48frfLdIZ+w=;
	b=m1C+KRPpVvVnRXAhZ9ceS9GcbE32F3xA5GlnadnnN/B1t79VGrwK65hys6+6hAqbpjKiWn
	yckEpBv/IxYP+UNMoMfpuUgsRGBEjtwWehB7FUlXZUA5AEaBuOUaCAIyy8mM4tH3t51UL2
	urttqEmkD5f0yPymteXUNjZdWZ6wJ0c=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=hoxz72PF;
	spf=pass (imf03.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.174 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764177320; a=rsa-sha256;
	cv=none;
	b=NeFkzRoScS7z4A0Rjlr3kKR2KzpToCp8HlMjaB8hwY5OgHpQXIHTJD7TGK842c1d115esA
	TmpaixRwFqEELwPU2pXF9TcSRIToXEn1oQp7Qc6BUHpxivy6TEopEHdqdLYU5NY1UQxXR+
	/K6HjTci3wUx8X/CfpXkRCufN7txuOs=
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-4edb6e678ddso563271cf.2
        for <linux-mm@kvack.org>; Wed, 26 Nov 2025 09:15:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1764177319; x=1764782119; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Lpxmbrt4LkK+rw3qfn3c0/9obbJZWwIG48frfLdIZ+w=;
        b=hoxz72PF3QS2eTw7QQRZ3iUsjOms5GG5RMc9i1aoK1RIdTKymbBAkOCm8wBZpThGo+
         GTPP2zRDF/KNUOYvvheOVXMWlWVsU4bTyKAqLUJ5PTBAoqUXR6G3D+/mR7noVAi8phc9
         OL7xYFr1rKI6RHb4EZQexx0ziKQ8N9qr1SWpaaUFIwArVTJU5NvHimvgUuLCUJC6Pj36
         bHxH3d/3KjidtcXKR1sz4z+Kx6bSTilzwQMEBbleWLPxoKb0a1WvS3kmSgVU9GIWeS/k
         4i93l6R3CA+yw/iOMXv5JRBI3B7QoXInzqRdmMh/wsuoq0PcAWbOALUepLpLjdWq+a75
         Do+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764177319; x=1764782119;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Lpxmbrt4LkK+rw3qfn3c0/9obbJZWwIG48frfLdIZ+w=;
        b=khQ9yXl1yw1+D/3Q5PJFNyfGx0B68Tu1b5/XvyMka//EjfenP0PfwrOOJYZ/2jSXT8
         JjLmSynQDmGpRK6j2oZvn5MXE/wlJJmIW/mMwnU3KC4DUXiZOC822vzAcVrzdsqtJ8XX
         9sIkWsPYvH8OpAYGyJGVElOBPwRp2AUeeFwwW7pvCx+t9g4k8GWFCp4YsojQ+PUDQD15
         c4IS1nkPLpge/zhh0sC1cJGEDdnsFWsPmkKEP5j/Eq/iYUs0xo4/MpQVj8uaLF5K/vxo
         Am8+JJa0uGuxZ7XJ8rnQiOH1sNqFNti1y/xe5LbtWzk/ySNhs4egUvLGgpEVgC8qn/zW
         WxqQ==
X-Forwarded-Encrypted: i=1; AJvYcCXnLtg0P/K3B3cevRmFRORbzG9qXGiM97ECAZZWX2A3TbF8+GojgUPZH7x7aTt14+VHtUC/ljBFKA==@kvack.org
X-Gm-Message-State: AOJu0YygL2xLTdo6IkBrTaUX9KlsPkhtopsxEVABMHjQMUGgbd2GCUkZ
	Ze0k6P4jiLU0N6dtfaQShAaXJnGm8x3i0l/qAzWGu6hGfDGan12JqnEEt4zGAUEG51s=
X-Gm-Gg: ASbGnct3bjjtkRbPvgxZCzxFbtQLy+eue+Khow012Fs8lcav422Em8ZvnCMfyJ4acHM
	X5GxZUSQCtKzcDhMfK0bNXn28Zjw7iurMUV1D/EdkPS3J5puBQxhDqgu/No0hYfhXMAIy94woj0
	i7u+IdVNMFDJpliyfi//IgGTlOYSeJZlxu+2SMRruSGT/kQPSkaywlOeaRgIqRmyaHnqSkLBReM
	MvwtHyG/hR7HJQZj4H2kUBrYQwBggsLoiJ/4qjZKhJI8PZbYsGIXnvI3b/cw+Z+CzHTKo6qmwd6
	51nhSx1vlvq2Sgu4a8ycFBs/MiyYM9glIqsT6c2EWvm3ppebKW4s8+f1klSsTJavnylb+e6VUf0
	IVTNsHTua+Q0q/a41/9mDGIN3HU2piD7otvKg3P7O1Hy2KT/ewqlXnsvGLG6SQxwmfwOPI6Evtv
	uEeFbn+/apEw==
X-Google-Smtp-Source: AGHT+IHoA3sAyrb5rSOSbNAy0GUpa+EZOUE6epCLUVEtNZ8+jRubEupGlWruECHL2V437C9dJQpT0A==
X-Received: by 2002:a05:622a:d5:b0:4ee:19ba:d778 with SMTP id d75a77b69052e-4ee58ad46f4mr281257171cf.48.1764177317721;
        Wed, 26 Nov 2025 09:15:17 -0800 (PST)
Received: from localhost ([2603:7000:c01:2716:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8846e445bd4sm147642686d6.10.2025.11.26.09.15.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Nov 2025 09:15:17 -0800 (PST)
Date: Wed, 26 Nov 2025 12:15:13 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Chen Ridong <chenridong@huaweicloud.com>
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, lujialin4@huawei.com,
	chenridong@huawei.com
Subject: Re: [RFC -next] memcg: Optimize creation performance when LRU_GEN is
 enabled
Message-ID: <20251126171513.GC135004@cmpxchg.org>
References: <20251119083722.1365680-1-chenridong@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251119083722.1365680-1-chenridong@huaweicloud.com>
X-Rspamd-Queue-Id: DBA4A20017
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 8kb73ymrr3zgnomqbaz5y8hqopm3j6hr
X-HE-Tag: 1764177319-755737
X-HE-Meta: U2FsdGVkX18G4gUsKqSmfqPnvcXY4sRK/JgagtADVMY1VbZGCEOMSrIyaL28Nj9NSadJ3NYl8BVX8w224qS8YMLVOmNme5XLJuHTUN6FX+uME2w+5NakDu6LLZ9OF2eCVUawPV2k77oIWgkX3nqJXErGo/Fjdwl+R/lkl5GlUsDwmkeM4VKXkBM5ogWQXAa58Eb6M0BBAajImhMuKPCk2UPiuhbbGMU+i7AW+ia9TJhxov6AMiCjX36PhItj2F+iYK5z7Ryihnx7KJyUih1jpE2i3RfCkQnhkN/UQxXoa0bqvWVB067UnVzmPjNwddFFTGZ+hmFmhWZJ5W4MxrJYf1zgV4rSW46z0Onzq3XVC5ubcoiEPu5eKlU2LGln5bxon3j1vuGSv0ILbNVtsglCBKop3Bg1myxl3h7M52OdZmiTbpaLuQ67kekAXa38kN05jEs/RZTTC00CowayjEI6baEoKWjaYwJPBWFHfozWcqWFGl6A+sQfty1zUk2UFeUjnBtQxK8Azz8nrJlHSxyS+Npm5Q2kJAU9StOjuYM2yxuTtpPMWdSLHDMfWZurfLi5wXOOpk3e/Vl+Lz59P+d0yUOKSP5/+NgWgIISz8T60FTAodeovxWSF3MFgcqsVgsuXVZhw37aeFw7cTQVaVehEAYbrJZO60VtMpUf/4jrYXHydhiVWiXUl+18Su8QjjEGp/XHq8M13dY2/PNuyIxv4niLk1j8QyRPitSH2OGAYh7MSIyKUd16hLZ5OV+zO8r++cmbX1VvFHQ4JxczgMb6f0yms6i8JIML3fWtMCpRZi3/7saHIijM3ulYJ0CNM1KHcvxAVybb5zIrFgDE+6is430FlmgScXUeIzRdbRxf9eY0+fOmOUHYAjL+F5l4UrVKn3InIkpO9V3Atn1D8/bvsgzOHWeLOCiOwcKKdzk+E0e42I56asneY6o8JXKFXfVu25QRnJvN808sQZ3Yz5z
 2iE/k9sG
 hbjHLKfjSfy1rorxeXRoeudRrIQbW2o7oJvR+iZSsyKTr2ydVG4tDmSGoHuo7ChxCjkiQIzwsrNQrgkoqgDtBnSeBgIgqOmznln+X5KRjv4oERLEnb4PiUKA+XiRQbfN5QxeYdFoVb/YETweEdL8MF1D91/ejLQlkALBulVljN+QiOPlENKC9CikaYq2KziNDciNaW+WnlqXHKASn5fqDO4NBBpAzqlYmE2F2mmfRJypGUuiVbvHTNGrubJ4V/MmhzG0zi3ZT2qaq0hNus+DS3EhfRekK5ZyBpuv61+Yw7tkr+cEqFpQzGoVvI2Y5DY8Bjgoh2yMY30Ef+wkAnb1i8KtVyQ7cWN5VLIUVqLeHhG7zh5OavHoNS4Esz/liH/r0BH0zSRBS3ME9sMrMJIGEYI9WR0ery6edqu61Sw2AqSrNuf4cm5ihG2C5R5PgSY9utjGYbmTuoCnhPvPFn6IibfR88TZBFTsyGKS6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 19, 2025 at 08:37:22AM +0000, Chen Ridong wrote:
> From: Chen Ridong <chenridong@huawei.com>
> 
> With LRU_GEN=y and LRU_GEN_ENABLED=n, a performance regression occurs
> when creating a large number of memory cgroups (memcgs):
> 
> 	# time mkdir testcg_{1..10000}
> 
> 	real	0m7.167s
> 	user	0m0.037s
> 	sys	0m6.773s
> 
> 	# time mkdir testcg_{1..20000}
> 
> 	real	0m27.158s
> 	user	0m0.079s
> 	sys	0m26.270s
> 
> In contrast, with LRU_GEN=n, creation of the same number of memcgs
> performs better:
> 
> 	# time mkdir testcg_{1..10000}
> 
> 	real	0m3.386s
> 	user	0m0.044s
> 	sys	0m3.009s
> 
> 	# time mkdir testcg_{1..20000}
> 
> 	real	0m6.876s
> 	user	0m0.075s
> 	sys	0m6.121s
> 
> The root cause is that lru_gen node onlining uses hlist_nulls_add_tail_rcu,
> which traverses the entire list to find the tail. This traversal scales
> with the number of memcgs, even when LRU_GEN is runtime-disabled.

Can you please look into removing the memcg LRU instead?

Use mem_cgroup_iter() with a reclaim cookie in shrink_many(), like we
do in shrink_node_memcgs().

The memcg LRU is complicated, and it only works for global reclaim; if
you have a subtree with a memory.max at the top, it'll go through
shrink_node_memcgs() already anyway.

