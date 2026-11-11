Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D1D9606A882
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 23:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=UWsOnvsY
Received: by kanga.kvack.org (Postfix)
	id A846E6B05CD; Wed, 11 Nov 2026 18:14:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5BCD6B05CE; Wed, 11 Nov 2026 18:14:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 926DF6B05CF; Wed, 11 Nov 2026 18:14:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 69E2D6B05CD
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:14:29 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F02DF1C3AAE
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:14:28 +0000 (UTC)
X-FDA: 85424394216.30.DF27714
Received: from mail-vs1-f52.google.com (mail-vs1-f52.google.com [209.85.217.52])
	by imf03.hostedemail.com (Postfix) with ESMTP id E1F6B20008
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:14:26 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=UWsOnvsY;
	spf=pass (imf03.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.217.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794438867;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DVdMMVnHovVouauLZSJMD6AHtT5aNNb/DqiljF977ik=;
	b=yYKuUYERTNMQ/mRysoYhd5/zHEzS4tq4DIAjfp9dthwrojJxr11nthyWVd5QvDgi1oKOZd
	8pdN3WPt67U509TAxI6xrDb571ucF1+bhzRCBIFgHwOrV8EYbF4YBgZfGpwLWng65DrF3U
	6hPpR/K0DXsqggTwiuRxLIe8/j6RMrU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794438867;
	b=0+9/DawC8Bgwwxhvwt/+G1Nxc5Vv5z9n3+mmoUetrxLzf8eQFQQPg1wrYHaS7DMYlfUqF5
	FgELAvRun9jB7nC0em7GFmEybnRPMCXkMaPJ4Z4411xwcilK7qDYHtZgtRxZd3TKtNFQ+A
	NzoKEiD2uNqeG9xr4Y+NnV6SxYHkqEc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=UWsOnvsY;
	spf=pass (imf03.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.217.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-vs1-f52.google.com with SMTP id ada2fe7eead31-7d2dc1ac787so1184129137.2
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 15:14:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1794438866; x=1795043666; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=DVdMMVnHovVouauLZSJMD6AHtT5aNNb/DqiljF977ik=;
        b=UWsOnvsYHUFaptdlOdPQIhROTt+iPAnZhlg5j76+xcVZcE/tU+NgRcDH3KfXDOEsuM
         pXZJI77s5YNXVSTxtyZkrCaOlomnbVFA3sOA7oNAOTA5y48IPqHs5QKa9rWOP+J/G1x5
         +0BCkJ6qNHrJmxs6SvQW0uchrtHs/DzVd43DlABM3OmdnAfROsXNxaN87VNIwlUadMgK
         P+AM52XITCeyBUJ/0K3n1fXK/1pE49ecJ/6gLg1jD54R9lVmWu8ljPEso6lgz5cCfbSw
         JQh9Bo95yU01hUNyYZIdyyUPP2INAA6OEfRYXCFtCX4If/r8lZRgxlObLlHo9Y+oCwEv
         34hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794438866; x=1795043666;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DVdMMVnHovVouauLZSJMD6AHtT5aNNb/DqiljF977ik=;
        b=0OH1mm4egVSav8oJZX/14wWStriLz055x8VXtvhakgV7HjTX8AlBuc0Ts5ISoOnXUX
         4AfkkJkvX3Hh+FKW6S7WpjtjhzNKn8iyN/4SLRpr6JwSqMcZ1rySKuDTB5m31VhZYrdQ
         xCA/JTmMcMVaeX1RSAwq/dYy8kKYt2dXZsrmJ2afhl4AKvpCjakImt0z+ZaUUF7CdrrD
         XwyaAz9lDRXNAeze85ypnlbxBJMp8zK5G3I+PKWoWyL/Ma8wCkVhu/jnsZFglzdRRoGI
         lGVQ91GGfdZ2FWy/nxFDKDDAiFxO/4ogpvWUo9cXuowHSx91xnuLif8Xc1YlIu5LXR7a
         5KKw==
X-Forwarded-Encrypted: i=1; AL+hErEUNP9YDnP1myYlhfsVe6j+0NpGH+syMXNIvkx2yd0x/VDI7SbNFgsKLbCmoczA8p/iH+zcHd4dbg==@kvack.org
X-Gm-Message-State: APuU4Z9rB1+6Lk7+PrMdgKHEEXy1C2uoonXaxKCxs97a/xe8nFdShoM7
	dDNv9ThOqeHDC9TVfbO3xIUkhcZS8TT59oZ76fz8w5pBAO2wGm+2vcGiqnlRhhdWZHo=
X-Gm-Gg: AYBFou2juSMzvaW24jJENxf5W1nt6MKZ5WU78blAewjMQCAZSOutsxH4FJiewFwZgdF
	2CDdTLgADZEW3G03KxFm0DLWOl5636/W1xswHHoHfWfkVkh7WoHTb4AgCIZEcOxt2SCDjijrbLe
	/jgXe5rhqv1nIiM8SF0wayAIsVXDhIOwu7MIq7oTtBb2y16hjHAWFLeRkt0y2qIFd5cm9lreEAV
	NTHWB9aekp5L9MEScx3ilN4v/UFLOpr2ktcDYxW7dRrugcLPpu7c5I6sOYRJ+gUUNwICJZOde2I
	HidWpXWDoDuiEX9Oybkjxj9DKSyRmHPBC96uwscaIQ6TXzgbavmMLks0nyWtUFDk1TQ21Qa7uaw
	6DzGZfXSav1FLOVtHaYwfShiQSkGtRUkvHv65Iz6fp5zMTvTjrtrD3gmokL29mntl2HUBFrviyA
	EHYwjxG2GqCLvO5OqCUCGFf07LNCyggtN4JM2NnILtwkzGiEu8/D59vZZasqf2/fL482gRJX/gT
	0PAFeNtx4YNyXzNzpt/S5aH+tIXR9CsobrtJX3ehaJ20184XjyU8CAJP21AnVb+3SFqeprylUAU
	cmaoZadHyr+GTS0RTynbva/XgZQ0D66SU5JPknA9jaF6iHn2VAhHoEfPg5trmhEU8rHXz2cFKCO
	OvsascSYD0EHfC+Rx7E+p8C95K/2IjWJ2CM1meVSG2h3x
X-Received: by 2002:a05:6102:5126:b0:7d2:7377:32db with SMTP id ada2fe7eead31-7d5060a7703mr1403477137.24.1794438865829;
        Wed, 11 Nov 2026 15:14:25 -0800 (PST)
Received: from soleen.c.googlers.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-99c22302403sm4344200241.10.2026.11.11.15.14.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2026 15:14:25 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 2/9] kho: Make bootmem reservations visible to fleet
 monitoring
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Chris Down <chris@chrisdown.name>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, 
 Alexander Graf <graf@amazon.com>, Baoquan He <baoquan.he@linux.dev>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 kexec@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 kernel-team@meta.com
In-Reply-To: <c41c639fc5f453d60a265ba42a233f2ea5b48319.1794383544.git.chris@chrisdown.name>
References: <cover.1794383544.git.chris@chrisdown.name>
 <c41c639fc5f453d60a265ba42a233f2ea5b48319.1794383544.git.chris@chrisdown.name>
Date: Wed, 11 Nov 2026 18:14:22 -0500
Message-Id: <179443886218.2329176.10742245280418377061.b4-review@b4>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5034;
 i=pasha.tatashin@soleen.com; h=from:subject:message-id;
 bh=9scWIMT8bcH1hJE5tzuaZbvTMzuuUTRWsydhjCoHQQ8=;
 b=owEBbQKS/ZANAwAKAbt3KEzbc3reAcsmYgBq9PbPj7WdaeKNG/W4QNGLva9/0FB58zcLhfiDz
 D1uxgEKxc2JAjMEAAEKAB0WIQRBMaqT7LRvGvB/NmK7dyhM23N63gUCavT2zwAKCRC7dyhM23N6
 3lFzEACWzSLOLHD1CYufzDO7hpK/ihqAdc830DtEx9ApghbfTfc1chnrI57/Wp2D9h7buNVVH45
 vnopS5ouz/fz6MCr1CLzZSlDrGgLZR5dCamAyBUTezBztIbRa8TcuC96hhwyPFxjLEdLW+NKjkp
 /qgGjQVOh7kd1VSE0obnNl+tVRoNL6cznEf+LKlobs40aMr6EqkNL654Zl9rdx1w9jor1+dj6nU
 SVEH/8uk2nvb6CFV70dA+aWyqVVWOJ2J6KtdOpTZPFofGAdDfeAhj7vyOPmcRUjvLjs/0rjq6yL
 B1PRB/UrzDRXrEwBO3Tx1t/T2M+v1u5MME0yEVugXvjpvWPFMLdZoGZmv0M42/e9uS6gjD3/9kp
 qwKDfUjqZpnelcj92WBqr5oycg1c9RqKoc+fqMyXJUcrZI1UAvnwEPzku4mXigZPnlq1RVnH66u
 /hCOahaJCjJObbeQzwGGNF/jlZMU1LPHOn8hryQG2VdTv0LdwyGH3wAoFY7dwMotlsBN3fiiaq5
 gLTvD+Ylxp9lmXxm7K1sivMmR5vGkUcohFKJ+kmiBYDPvL5R04L8owhQQiJuZe4i012L1tGFk99
 06tbJ14sWZItiw1bysAP3Gh/qrXB6ycrzrN45vbpceX0VcALyQPyEsYouSwcnWC/IZqDo6Cakcz
 8R+Ei1KWFz4evKA==
X-Developer-Key: i=pasha.tatashin@soleen.com; a=openpgp;
 fpr=CAAAB722DD22A081F0D49F35633A6A993D43B569
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E1F6B20008
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 7tucm9z1dfam8rfar38ucwdi86rcqn59
X-Rspam-User: 
X-HE-Tag: 1794438866-417446
X-HE-Meta: U2FsdGVkX19iN+Qj3bRl86pKFVeIoZyKnrPO+rG2aChzg0UzOHWW/RKNaSluzcd1aDY4KfYyyZN97ByzlFi2dMNv2HrNYUS0y6KqJt9KOX6sjK66vNg7MJngPVTizWvW14krTxvK29mrdZVWKOmKKch7ahHBiOUTMKCk8OQW45T8IfVET0KZQwVBttGy17sDfk88f6DAu4WRfJS+eh1lqA5KfMWPqns2XC0liRRDrtEXdweOFFXySHPxvBvhwHSOnZG7yJ6ZtLSPsdCoManzg1SRZ++joVqhGEnk59ZmKfFffj4UBl/jg1MbDd+KNQJcWh1oUukr9ksnnilV3JMkLGf4jKX0baf2zcRba+3TGyWmALeqcLRMayaU27CcIKKQg+3UpmPJD7+MhqJASxpQy/FpiGtbqDla6YEBgtccgMZ5OZ5ASbjIf01xj5gIdGQ5QYQIKxZI3UXTKCqALC1yXQYbOJmLRZ4hXfb0FHGixejokwH3sjn2OVpuF3aDH6GejIz8o+hQihy+eHWfUHt41HqAJj3w9f4uexMmdPe9ScxViJIZWJMQMOnH1Xa9VWPaagjnLgDjdQ9Y2n1I1OgKNWFmlYHNrLRSTAF8qxMasKgp2LLI2G8o6sxTnVWYTDnvvja6cXdT/ZVfdr/e5dJZysiZz7EaZuXrvgrk0ytHi8j8FtkqKC7iI3m4px6Ii2mvI0Mpc4nJsf/NvDVV0mew0BpSVONb/jbdUD2ZUVxtdrbDANhovGEKCPnbK1y/B9h1gK7aN3MwKk0RsDCSgGj5axpubosHe5x5dujJK/AQCkyB6L/7ZaH93oUj7nOOZHopbraWDYWTpUHwKG3xI5UaQvB9XZAvf01jvm0f1odP+EHMrTq2IzfbRY23KUmp91nIEFiN4MWgtaODicZUurL0qrxbTAfuRg5xfkXu7J76cuU+OGRH0MEMmUnkULbN8cElBYXj2VbJjfMkAEhI9/Y
 ZVfB+oLB
 8oZcAIGT+z7xt7oE02diQHSxkgRlNgbeSjhddoZtfrzFplhAgnXdsBa9MzllMqAqKdoaOQ9DuTsGAgYFAp/yQxZ/a5Rm/HIA3KIzLBR56ncGauv+mPimeSVVkZhUMQwGOlvWwy/ObtGI2HzsTjpfhFUu8gG4ApX5qLO3XnWS/aq0XNrnP8yMOl3dh897bRa5FXhfgASlSNbBHYJGbvFGm2i5yjMLRZrcVFVpID/tPrpHz3Zi5YHgl2QZmHm+Rl/yVeTxP0b5yK+0QnDd5/GM99Hrlv0g+ffALIYJDOBwEoOV/W1n+S0rFwCzKyyg6Mop9YEImJnYzgCVZkizQRY2QAg0hY3UKkZToPwew9Cpd9yw8XYtO+QV7wIpmgA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> We want to use live update at Meta to upgrade hypervisors whose VMs
> can't be migrated away first. But this poses a problem: whether we can

Awesome.

> enable KHO on a class of host depends on how much memory it leaves
> available for unmovable allocations. In an early test, a 64 GiB host
> with hugetlb_cma=6G set aside about 30 GiB of bootmem, which the running
> kernel can only use for movable allocations.
> 
> The reservation varies with the kernel, memory size, NUMA layout and
> command line. Our fleet collector needs the actual size from each host
> so we can decide where to enable KHO and catch a kernel release that
> takes those hosts over their bootmem budget.

HM, that works for cold boot not for live update :-)

> 
> Today the collector would have to sum kho/out/bootmem_len in debugfs,
> which isn't a userspace ABI. In /proc/meminfo, free bootmem contributes
> to CmaFree, but the reservation doesn't contribute to CmaTotal. The cma

Is this a different bug?

> count in /proc/zoneinfo includes bootmem after a cold boot but not after
> a KHO kexec. On an 8 GiB QEMU guest booted with
> kho_bootmem=32M,1536M,512M:
> 
>                 CmaTotal  CmaFree     zoneinfo cma (all zones)
>     cold boot   0 kB      2127872 kB  2129920 kB
>     KHO kexec   0 kB       881336 kB  0 kB
> 
> Even if bootmem becomes a CMA area, CmaTotal will still include other
> areas such as hugetlb CMA, so inferring the bootmem size is still
> error-prone.
> 
> Let's report the total bootmem reservation in bytes at
> /sys/kernel/kexec/kho_bootmem_size.
> 
> Signed-off-by: Chris Down <chris@chrisdown.name>
>
> diff --git a/Documentation/ABI/testing/sysfs-kernel-kexec-kdump b/Documentation/ABI/testing/sysfs-kernel-kexec-kdump
> index f59051b5d96d..80941a7d8a7c 100644
> --- a/Documentation/ABI/testing/sysfs-kernel-kexec-kdump
> +++ b/Documentation/ABI/testing/sysfs-kernel-kexec-kdump
> @@ -59,3 +59,11 @@ Description:	read only
>  		to the crash (kdump) kernel. It lists the start and end physical
>  		addresses of CMA regions assigned for crashkernel use.
>  User:		kdump service
> +
> +What:		/sys/kernel/kexec/kho_bootmem_size

I have some concerns about exposing this as a stable API. What if we get 
rid of bootmem or make it resizable? We only recently renamed it from 
scratch to bootmem, and we have been exploring for way to optimize it.

I would keep this exposed under /sys/kernel/debug/kho/bootmem_size for 
now, and not worry about it being stable.

> +Date:		Nov 2026
> +Contact:	kexec@lists.infradead.org
> +Description:	read only
> +		Total size of the KHO bootmem regions in bytes. Returns 0
> +		when KHO is disabled.
> +User:		system monitoring
> diff --git a/Documentation/admin-guide/mm/kho.rst b/Documentation/admin-guide/mm/kho.rst
> index f9d2cc5999ee..c329d720bf25 100644
> --- a/Documentation/admin-guide/mm/kho.rst
> +++ b/Documentation/admin-guide/mm/kho.rst
> @@ -81,6 +81,15 @@ At scale, correlating crashes to the previous kernel version enables
>  faster root cause analysis when issues only occur in specific kernel
>  transition scenarios.
>  
> +sysfs Interfaces
> +================
> +
> +``/sys/kernel/kexec/kho_bootmem_size``
> +    Total size of the KHO bootmem regions in bytes, or 0 when KHO is
> +    disabled.
> +
> +See Documentation/ABI/testing/sysfs-kernel-kexec-kdump for the sysfs ABI.
> +
>  debugfs Interfaces
>  ==================
>  
> diff --git a/include/linux/kexec_handover.h b/include/linux/kexec_handover.h
> index ef2b188c8ed0..736d51e79fd2 100644
> --- a/include/linux/kexec_handover.h
> +++ b/include/linux/kexec_handover.h
> @@ -40,6 +40,7 @@ void kho_populate(phys_addr_t fdt_phys, u64 fdt_len, phys_addr_t bootmem_phys,
>  		  u64 bootmem_len);
>  
>  bool kho_bootmem_overlap(phys_addr_t phys, size_t size);
> +phys_addr_t kho_bootmem_size(void);
>  
>  static inline enum migratetype kho_bootmem_migratetype(unsigned long pfn,
>  						       enum migratetype mt)
> diff --git a/kernel/kexec_core.c b/kernel/kexec_core.c
> index f4a31565c447..ed105e6351eb 100644
> --- a/kernel/kexec_core.c
> +++ b/kernel/kexec_core.c
> @@ -13,6 +13,7 @@
>  #include <linux/slab.h>
>  #include <linux/fs.h>
>  #include <linux/kexec.h>
> +#include <linux/kexec_handover.h>
>  #include <linux/mutex.h>
>  #include <linux/list.h>
>  #include <linux/liveupdate.h>
> @@ -1324,6 +1325,15 @@ static struct kobj_attribute crash_elfcorehdr_size_attr = __ATTR_RO(crash_elfcor
>  #endif /* CONFIG_CRASH_HOTPLUG */
>  #endif /* CONFIG_CRASH_DUMP */
>  
> +#ifdef CONFIG_KEXEC_HANDOVER
> +static ssize_t kho_bootmem_size_show(struct kobject *kobj,
> +				     struct kobj_attribute *attr, char *buf)
> +{
> +	return sysfs_emit(buf, "%llu\n", (unsigned long long)kho_bootmem_size());
> +}
> +static struct kobj_attribute kho_bootmem_size_attr = __ATTR_RO(kho_bootmem_size);
> +#endif

Keeping it together with the rest of KHO code would be better.

-- 
Pasha


