Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27ABFD46617
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 20:00:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 754356B00F8; Thu, 15 Jan 2026 15:00:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7024B6B00F9; Thu, 15 Jan 2026 15:00:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B9B46B00FB; Thu, 15 Jan 2026 15:00:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 45F856B00F8
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 15:00:38 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E58F41BBC4
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 20:00:37 +0000 (UTC)
X-FDA: 84335265714.17.EB8A762
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	by imf25.hostedemail.com (Postfix) with ESMTP id A316AA0007
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 20:00:35 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=iV60u5Y3;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf25.hostedemail.com: domain of ackerleytng@google.com designates 209.85.167.54 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768507235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qj8h6BORpJwq1gCbueilyNjyLieLucwDic0ANZ8jZ4g=;
	b=SFwjf5I3ASFdODxuST73Yd+qJv2x5+LjI+kL363TvFZ1Snm4Q9URvSWJ23sH0AelMyMOAY
	UI05vCO1gknsQZs7auTfRMeP/Ce4o07q385Z5zBzlNx3KM98d9nVrdngFTslpvHyRpHSql
	z1z/Xp0XHy+cn2xhEDRypvuJ6K6GLkk=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768507235; a=rsa-sha256;
	cv=pass;
	b=CJv60TZ9/GpiWylpZYgOEB9atDFx7rtkIX1TWYQ/dALFUfsTycKoxjjock0TEnxSVSnWQJ
	SW3RHCEET37uzknnF64F5sNsAnmBEyZ3EjfsMUr3g5qgtNqW/0WB4fuqGnmaFvXVjTdB8z
	yzuU8VUB8nc0TI1ir3NhQbD5aelnEJs=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=iV60u5Y3;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf25.hostedemail.com: domain of ackerleytng@google.com designates 209.85.167.54 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-59b8364e4ccso1569903e87.3
        for <linux-mm@kvack.org>; Thu, 15 Jan 2026 12:00:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768507234; cv=none;
        d=google.com; s=arc-20240605;
        b=ZtdR5A9HYlYfhujgesBQdBzVClPb0cl68s8tM1CItYa1u1NY5VUbac9FaCzPafg44Q
         2qg70FxV5KEN4NEXm7VsrMqsBoVibDcdGIw3MIUsl6KIpX1n1mr5rE34tP4SuT8h+R0/
         /Zk18HaF/VP4z9jZpHXQ3uuYgIRYrJ6FE4gRa/jFvDszr/8Y2iDNSIWHjy88+mXxpetN
         36KPVupxi2GwX7MA+OaKGlhiGNOB7xSp7ug6rkroDVlAAxDQEqBb9Emd5bESWaqaHtul
         /fr59qkZ6zdQeWEKwYo907CU8H05nQuAwcD5chPRv1sxYJm1BjVdjUutEzDcOQtouaAb
         GZDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=qj8h6BORpJwq1gCbueilyNjyLieLucwDic0ANZ8jZ4g=;
        fh=VqlVQL27S78HoZlcfPJhRZSzNCO5zUc7wGdBUnzbKfk=;
        b=lDbQg0zcqN1AnAa9BRcRcy/7OwLBaYRLjVjClsNMz+8ZRe1ZHTBmLYuzms7BjGRm0w
         FCexHkCxMDMadqnNurDFSM6AwYia75gzjmMzf3wVOPN+chliUFxeNc+f1IY1rN63RtiB
         Ss5GKYVR79MO/UwIijrZvmrDDI8rrL7kQOY0RvOIW9pbr5E8TvmDTQKfZ3K9oNfC0Q19
         TgxsiLVWcS1GqiX0WO11ZCSZo59t09R5V7irtSpGNVO1A8lgaK+TVtLB8sNkKc/ZMHel
         +DS3O1BJxAGTKZY5zvWcU79XRsoF4W49r48KRYyvYbgDM2rBsYnGKPP2hH2MSyyWOCIZ
         B0DA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768507234; x=1769112034; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=qj8h6BORpJwq1gCbueilyNjyLieLucwDic0ANZ8jZ4g=;
        b=iV60u5Y3Q1Ot1jQhCcnnD5KBxsBpzBCQSZVlj9bAqZFo0u6wvw860hQc+OIfm+NT8M
         Mpw5KyUejby2xK8Wvh5c0P3OdsttcbuRAau9US1Fs/STGnVRk9Z5jWaOMRjZGdcAo/bP
         IfEYP84RdWu6Gbioefmb8a776Rm3u3yjrXfqZykHY+77ts4Z1EakD1Mm54TcoMfax6om
         qD4NYtXp8OvOYtVc2b/wmbeN7Lldn3GoHGeH3bBc/F9pmTeJUO2WWjv8xFpLne6V2n5x
         LCcfurKwz7D9JzNOJi8kM7yHYtTRqSIb4zr0hH/9p2rchpLJKBUvGrdCEiQpy40pLk9l
         zM2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768507234; x=1769112034;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qj8h6BORpJwq1gCbueilyNjyLieLucwDic0ANZ8jZ4g=;
        b=KL4VgtyPjA/BGteL2ZcSE+G6WkBse+DXIkEZQdl8eH5c2SQOL0ac9/ObvDUq1sMIYx
         yxAjzdUC03o/u5BC4+yGKNrOycCO4lhOlioHO+NByO+hLL9WhuEYKCNchitpUBDC4uJK
         lS2Yh84TakZW2yPFBcVXIMYP5jJZjn1LY4ScKXpGTuwEura2VV2plfoySQr/qJXSZ653
         XKbDfE/3zW06FUQ8BiedjeU1he3OrJR9pF03EWdrigETlPfseJBAHfIwnfdyryp2PLpt
         gwDbyo9ESxqqumoFG+ZIWDqPrptU5HaTCUZc5Nakq2fLD0Q9+Ye5PR2dO26DFQSob0Fl
         9mNQ==
X-Forwarded-Encrypted: i=1; AJvYcCUt7HfnHK/8CUDWM+eg86MxtCvBHMkMy9bjCltU9/nW8WAEPKHh+Hm6gw0+YDYFbPEYrJA5ZO9fXg==@kvack.org
X-Gm-Message-State: AOJu0YxbwYPPm+pRa/R+84YwwFCehpo9XBk86w5X0BHwD/vgZr3j/wUV
	iFTaAlr8Vf3wMXwOHumPBvhyX3q0sWSScDatcRnfxifS7EDIOLFXWl+etKs8cdzWsx52q5NrZ5A
	jCWaMw84Ld/XF0PcXF+LS7CzrVUBuzA+1IE2mGc3z
X-Gm-Gg: AY/fxX64/fEfzmVnQHt1hvqd/zyec2oYiwMqXgq+5uibpR9KbYsSsrlqWkTsEN/gIt1
	KWxSsqSof3eTm6wJ6z3/rjLF2y5iYIJtWug97+We0f5bvyBUV8N5CmdMTDbRMAzXAdKh+yRFC7B
	VUwYxXHLEgozG63c6+n0rlIbSj2nj9sB1X/7HtsJzgvXOn494Khr8Eu0EgaqEFnDX9I+L5naqUJ
	y6igV9a+HamQsDOBI+zTPpahDDn9zF5EFTpt9DjwJ3ZLlsleFEYEOC6hZ11hYSrDc/B9JsaUuLm
	tdCOQTMDeqzOqYuuA5dlVN4NAg==
X-Received: by 2002:ac2:51c8:0:b0:596:9bfa:91a4 with SMTP id
 2adb3069b0e04-59baeec5ba2mr223831e87.2.1768507233115; Thu, 15 Jan 2026
 12:00:33 -0800 (PST)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 15 Jan 2026 12:00:31 -0800
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 15 Jan 2026 12:00:30 -0800
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20260114134510.1835-8-kalyazin@amazon.com>
References: <20260114134510.1835-1-kalyazin@amazon.com> <20260114134510.1835-8-kalyazin@amazon.com>
MIME-Version: 1.0
Date: Thu, 15 Jan 2026 12:00:30 -0800
X-Gm-Features: AZwV_QjBsd3lTOri7HGHELmcazvDzXzFF30pFq7CI4dK0BruDZK-2GmBwhNuHRw
Message-ID: <CAEvNRgEzVhEzr-3GWTsE7GSBsPdvVLq7WFEeLHzcmMe=R9S51w@mail.gmail.com>
Subject: Re: [PATCH v9 07/13] KVM: guest_memfd: Add flag to remove from direct map
To: "Kalyazin, Nikita" <kalyazin@amazon.co.uk>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>, 
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>, "kernel@xen0n.name" <kernel@xen0n.name>, 
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>, 
	"linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>, 
	"loongarch@lists.linux.dev" <loongarch@lists.linux.dev>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>, "corbet@lwn.net" <corbet@lwn.net>, 
	"maz@kernel.org" <maz@kernel.org>, "oupton@kernel.org" <oupton@kernel.org>, 
	"joey.gouly@arm.com" <joey.gouly@arm.com>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, 
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, 
	"will@kernel.org" <will@kernel.org>, "seanjc@google.com" <seanjc@google.com>, 
	"tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>, 
	"hpa@zytor.com" <hpa@zytor.com>, "luto@kernel.org" <luto@kernel.org>, 
	"peterz@infradead.org" <peterz@infradead.org>, "willy@infradead.org" <willy@infradead.org>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "david@kernel.org" <david@kernel.org>, 
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>, 
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "vbabka@suse.cz" <vbabka@suse.cz>, 
	"rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com" <surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>, 
	"ast@kernel.org" <ast@kernel.org>, "daniel@iogearbox.net" <daniel@iogearbox.net>, 
	"andrii@kernel.org" <andrii@kernel.org>, "martin.lau@linux.dev" <martin.lau@linux.dev>, 
	"eddyz87@gmail.com" <eddyz87@gmail.com>, "song@kernel.org" <song@kernel.org>, 
	"yonghong.song@linux.dev" <yonghong.song@linux.dev>, 
	"john.fastabend@gmail.com" <john.fastabend@gmail.com>, "kpsingh@kernel.org" <kpsingh@kernel.org>, 
	"sdf@fomichev.me" <sdf@fomichev.me>, "haoluo@google.com" <haoluo@google.com>, 
	"jolsa@kernel.org" <jolsa@kernel.org>, "jgg@ziepe.ca" <jgg@ziepe.ca>, 
	"jhubbard@nvidia.com" <jhubbard@nvidia.com>, "peterx@redhat.com" <peterx@redhat.com>, 
	"jannh@google.com" <jannh@google.com>, "pfalcato@suse.de" <pfalcato@suse.de>, 
	"shuah@kernel.org" <shuah@kernel.org>, "riel@surriel.com" <riel@surriel.com>, 
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>, "jgross@suse.com" <jgross@suse.com>, 
	"yu-cheng.yu@intel.com" <yu-cheng.yu@intel.com>, "kas@kernel.org" <kas@kernel.org>, 
	"coxu@redhat.com" <coxu@redhat.com>, "kevin.brodsky@arm.com" <kevin.brodsky@arm.com>, 
	"maobibo@loongson.cn" <maobibo@loongson.cn>, "prsampat@amd.com" <prsampat@amd.com>, 
	"mlevitsk@redhat.com" <mlevitsk@redhat.com>, "jmattson@google.com" <jmattson@google.com>, 
	"jthoughton@google.com" <jthoughton@google.com>, "agordeev@linux.ibm.com" <agordeev@linux.ibm.com>, 
	"alex@ghiti.fr" <alex@ghiti.fr>, "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>, 
	"borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>, "chenhuacai@kernel.org" <chenhuacai@kernel.org>, 
	"dev.jain@arm.com" <dev.jain@arm.com>, "gor@linux.ibm.com" <gor@linux.ibm.com>, 
	"hca@linux.ibm.com" <hca@linux.ibm.com>, 
	"Jonathan.Cameron@huawei.com" <Jonathan.Cameron@huawei.com>, "palmer@dabbelt.com" <palmer@dabbelt.com>, 
	"pjw@kernel.org" <pjw@kernel.org>, 
	"shijie@os.amperecomputing.com" <shijie@os.amperecomputing.com>, "svens@linux.ibm.com" <svens@linux.ibm.com>, 
	"thuth@redhat.com" <thuth@redhat.com>, "wyihan@google.com" <wyihan@google.com>, 
	"yang@os.amperecomputing.com" <yang@os.amperecomputing.com>, 
	"vannapurve@google.com" <vannapurve@google.com>, "jackmanb@google.com" <jackmanb@google.com>, 
	"aneesh.kumar@kernel.org" <aneesh.kumar@kernel.org>, "patrick.roy@linux.dev" <patrick.roy@linux.dev>, 
	"Thomson, Jack" <jackabt@amazon.co.uk>, "Itazuri, Takahiro" <itazur@amazon.co.uk>, 
	"Manwaring, Derek" <derekmn@amazon.com>, "Cali, Marco" <xmarcalx@amazon.co.uk>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A316AA0007
X-Rspam-User: 
X-Stat-Signature: inj1x9o1bxznqhr5inf9meq48etpet6w
X-HE-Tag: 1768507235-115415
X-HE-Meta: U2FsdGVkX1+MUeCR8eT64n/sQgFp6pX5DyrCYWGHvlqaq39npUX/ELSOB55UHG0GyMC+MreafYzVfVCG1nhCP+Fy7+FvLfIlM3WBuCij6Ak2WvAv7vJaqv7C8in819aLrQhEr3buzlaKEhy7qLJXJ1yXSJcqZY0OIv4RzE67jrYzbVuor6F/FypxSBumbaEo8QdxflywAQdbBmKLAPhsghjkrReOSG4sIoc9s9X4iMWRJPQJGzyF9ZD4Q6hQFs1MrPRLMGQXJ4R7RJv7/XRuuA1Id+h5FBHbOakmaI7VUPNRkBzTKwgFXW988Loq0xrXDyDJbh1txWhdrXlXwx9fa7IVMPoWpP6o65gS06xgsAFGCDgwnliUxX+m7BE03rk8/ERw2Ty+Jsp9tPJ2vJxdEZ/vn418Gqc3SOw6YfU1dQjLGkTlEzTjxy4077lfGSo3KIBEF3Grp8HEpqh8ym/YPOW60IF/3T7ed+OOv+EZXbNEDkxSfdoqZvFhD47bTSvHTAKreK54O5ZHf8RT6vJxmo/VdNF3qXCTsxo5R/3uWg+N7Oxy6i8Zl/8yK/bmd1bmtcI9i4dZE3eKEElh/cnP77AMbUlga83u3w9NtDAeRpwOHQn1a3sOSOvLF3lHZQXhGMiwco9nwrAYllJ1LgObxVdS/MSDwl5JSAOjtdkMRpLuGzVQNRzuHFdmM2UjQsysZQwxtq/C4IHxqkDsLUGsOqPZIpewHp4fqrzqD5dOKF63MKb69Pb7jqIouG4CmfH5mEhqd897OeLGZ45RQLT8w16SLsGjKV33nPYmAsJF6WlTXbl8s0lUIyVWqGB6tsaW2jb6hAmvWZz7eXvH6M7PKsfo0jxzUkp9aR9rqzVzKnnrqvoTr1gfHsuoflqjDnxQWRQgtks8gBemqEw5Nhhp5EKb7LLWSD0A6zeAAP7FTjEVlwBMcIdheHcHZ965x3siVTeT/adaL57iaXjWb7/
 JeoGakkR
 CfOYySPHijG3T2Hj/hNPLTllZ8YS1Hls/PDUeAs6649m22UUPVdS2p0o+PFU7FyjZtiGBf0NzDHiaLiRXmFNjULo/T5zX3Ss3C/L84FDf82J5wplKby5U2pqPGUSELmk4Kk02W8vtw6mcLIuLk0zl04MnK5XF/4OMQopwb8IEDafsGm1bBZih010f/HFnvdIY/8GQu16A4TcIZbaQaIWV2JTj0M9U1Sa1XW1zMnQQkPWxAlLatmYprQRV+oGHKsHsFGKXYNZTk7X4F5rsk0AkQG5V1W0y1LRM7/LKgx3atXjawWtN7NHDPQh4OyX1+5VglAaTNGpZw5wUoN3W0cfP3NQbe8q3Rif9+WJn7hHjWlxbIDEwP0EEYWW7TAS9H9JTqhrLHKpsOxYMinw5vs23ppNJxfqzV9c6OFC824QMWHAoTEl4Rpd9XEFAodvGVNyZww4v62En5FJkS1iunLBRC6PJ0sqSZOVhXhIKGUgjnpak93QvxvcHmlthjqFFBR6v6EO2jEZZo+82EJ+zw/UgfIioG8wUCVl5ml7V
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Kalyazin, Nikita" <kalyazin@amazon.co.uk> writes:

> From: Patrick Roy <patrick.roy@linux.dev>
>
> Add GUEST_MEMFD_FLAG_NO_DIRECT_MAP flag for KVM_CREATE_GUEST_MEMFD()
> ioctl. When set, guest_memfd folios will be removed from the direct map
> after preparation, with direct map entries only restored when the folios
> are freed.
>
> To ensure these folios do not end up in places where the kernel cannot
> deal with them, set AS_NO_DIRECT_MAP on the guest_memfd's struct
> address_space if GUEST_MEMFD_FLAG_NO_DIRECT_MAP is requested.
>
> Note that this flag causes removal of direct map entries for all
> guest_memfd folios independent of whether they are "shared" or "private"
> (although current guest_memfd only supports either all folios in the
> "shared" state, or all folios in the "private" state if
> GUEST_MEMFD_FLAG_MMAP is not set). The usecase for removing direct map
> entries of also the shared parts of guest_memfd are a special type of
> non-CoCo VM where, host userspace is trusted to have access to all of
> guest memory, but where Spectre-style transient execution attacks
> through the host kernel's direct map should still be mitigated.  In this
> setup, KVM retains access to guest memory via userspace mappings of
> guest_memfd, which are reflected back into KVM's memslots via
> userspace_addr. This is needed for things like MMIO emulation on x86_64
> to work.
>
> Direct map entries are zapped right before guest or userspace mappings
> of gmem folios are set up, e.g. in kvm_gmem_fault_user_mapping() or
> kvm_gmem_get_pfn() [called from the KVM MMU code]. The only place where
> a gmem folio can be allocated without being mapped anywhere is
> kvm_gmem_populate(), where handling potential failures of direct map
> removal is not possible (by the time direct map removal is attempted,
> the folio is already marked as prepared, meaning attempting to re-try
> kvm_gmem_populate() would just result in -EEXIST without fixing up the
> direct map state). These folios are then removed form the direct map
> upon kvm_gmem_get_pfn(), e.g. when they are mapped into the guest later.
>
> Signed-off-by: Patrick Roy <patrick.roy@linux.dev>
> Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>
> ---
>  Documentation/virt/kvm/api.rst | 22 ++++++++------
>  include/linux/kvm_host.h       | 12 ++++++++
>  include/uapi/linux/kvm.h       |  1 +
>  virt/kvm/guest_memfd.c         | 54 ++++++++++++++++++++++++++++++++++
>  4 files changed, 80 insertions(+), 9 deletions(-)
>
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 01a3abef8abb..c5f54f1370c8 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -6440,15 +6440,19 @@ a single guest_memfd file, but the bound ranges must not overlap).
>  The capability KVM_CAP_GUEST_MEMFD_FLAGS enumerates the `flags` that can be
>  specified via KVM_CREATE_GUEST_MEMFD.  Currently defined flags:
>
> -  ============================ ================================================
> -  GUEST_MEMFD_FLAG_MMAP        Enable using mmap() on the guest_memfd file
> -                               descriptor.
> -  GUEST_MEMFD_FLAG_INIT_SHARED Make all memory in the file shared during
> -                               KVM_CREATE_GUEST_MEMFD (memory files created
> -                               without INIT_SHARED will be marked private).
> -                               Shared memory can be faulted into host userspace
> -                               page tables. Private memory cannot.
> -  ============================ ================================================
> +  ============================== ================================================
> +  GUEST_MEMFD_FLAG_MMAP          Enable using mmap() on the guest_memfd file
> +                                 descriptor.
> +  GUEST_MEMFD_FLAG_INIT_SHARED   Make all memory in the file shared during
> +                                 KVM_CREATE_GUEST_MEMFD (memory files created
> +                                 without INIT_SHARED will be marked private).
> +                                 Shared memory can be faulted into host userspace
> +                                 page tables. Private memory cannot.
> +  GUEST_MEMFD_FLAG_NO_DIRECT_MAP The guest_memfd instance will behave similarly
> +                                 to memfd_secret, and unmaps the memory backing

Perhaps the reference to memfd_secret can be dropped to avoid anyone
assuming further similarities between guest_memfd and memfd_secret. This
could just say that "The guest_memfd instance will unmap the memory
backing it from the kernel's address space...".

> +                                 it from the kernel's address space before
> +                                 being passed off to userspace or the guest.
> +  ============================== ================================================
>
>  When the KVM MMU performs a PFN lookup to service a guest fault and the backing
>  guest_memfd has the GUEST_MEMFD_FLAG_MMAP set, then the fault will always be
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 27796a09d29b..d4d5306075bf 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -738,10 +738,22 @@ static inline u64 kvm_gmem_get_supported_flags(struct kvm *kvm)
>  	if (!kvm || kvm_arch_supports_gmem_init_shared(kvm))
>  		flags |= GUEST_MEMFD_FLAG_INIT_SHARED;
>
> +	if (kvm_arch_gmem_supports_no_direct_map())
> +		flags |= GUEST_MEMFD_FLAG_NO_DIRECT_MAP;
> +
>  	return flags;
>  }
>  #endif
>
> +#ifdef CONFIG_KVM_GUEST_MEMFD
> +#ifndef kvm_arch_gmem_supports_no_direct_map
> +static inline bool kvm_arch_gmem_supports_no_direct_map(void)
> +{
> +	return false;
> +}
> +#endif
> +#endif /* CONFIG_KVM_GUEST_MEMFD */
> +
>  #ifndef kvm_arch_has_readonly_mem
>  static inline bool kvm_arch_has_readonly_mem(struct kvm *kvm)
>  {
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index dddb781b0507..60341e1ba1be 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1612,6 +1612,7 @@ struct kvm_memory_attributes {
>  #define KVM_CREATE_GUEST_MEMFD	_IOWR(KVMIO,  0xd4, struct kvm_create_guest_memfd)
>  #define GUEST_MEMFD_FLAG_MMAP		(1ULL << 0)
>  #define GUEST_MEMFD_FLAG_INIT_SHARED	(1ULL << 1)
> +#define GUEST_MEMFD_FLAG_NO_DIRECT_MAP	(1ULL << 2)
>
>  struct kvm_create_guest_memfd {
>  	__u64 size;
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 92e7f8c1f303..43f64c11467a 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -7,6 +7,9 @@
>  #include <linux/mempolicy.h>
>  #include <linux/pseudo_fs.h>
>  #include <linux/pagemap.h>
> +#include <linux/set_memory.h>
> +
> +#include <asm/tlbflush.h>
>
>  #include "kvm_mm.h"
>
> @@ -76,6 +79,43 @@ static int __kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slo
>  	return 0;
>  }
>
> +#define KVM_GMEM_FOLIO_NO_DIRECT_MAP BIT(0)
> +
> +static bool kvm_gmem_folio_no_direct_map(struct folio *folio)
> +{
> +	return ((u64) folio->private) & KVM_GMEM_FOLIO_NO_DIRECT_MAP;

Nit: I think there shouldn't be a space between (u64) and what's being casted.

> +}
> +
> +static int kvm_gmem_folio_zap_direct_map(struct folio *folio)
> +{
> +	u64 gmem_flags = GMEM_I(folio_inode(folio))->flags;
> +	int r = 0;
> +
> +	if (kvm_gmem_folio_no_direct_map(folio) || !(gmem_flags & GUEST_MEMFD_FLAG_NO_DIRECT_MAP))
> +		goto out;
> +
> +	folio->private = (void *)((u64)folio->private | KVM_GMEM_FOLIO_NO_DIRECT_MAP);
> +	r = folio_zap_direct_map(folio);
> +
> +out:
> +	return r;
> +}
> +
> +static void kvm_gmem_folio_restore_direct_map(struct folio *folio)
> +{
> +	/*
> +	 * Direct map restoration cannot fail, as the only error condition
> +	 * for direct map manipulation is failure to allocate page tables
> +	 * when splitting huge pages, but this split would have already
> +	 * happened in folio_zap_direct_map() in kvm_gmem_folio_zap_direct_map().
> +	 * Thus folio_restore_direct_map() here only updates prot bits.
> +	 */

Thanks for this comment :)

> +	if (kvm_gmem_folio_no_direct_map(folio)) {
> +		WARN_ON_ONCE(folio_restore_direct_map(folio));
> +		folio->private = (void *)((u64)folio->private & ~KVM_GMEM_FOLIO_NO_DIRECT_MAP);
> +	}
> +}
> +
>  static inline void kvm_gmem_mark_prepared(struct folio *folio)
>  {
>  	folio_mark_uptodate(folio);
> @@ -398,6 +438,7 @@ static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
>  	struct inode *inode = file_inode(vmf->vma->vm_file);
>  	struct folio *folio;
>  	vm_fault_t ret = VM_FAULT_LOCKED;
> +	int err;
>
>  	if (((loff_t)vmf->pgoff << PAGE_SHIFT) >= i_size_read(inode))
>  		return VM_FAULT_SIGBUS;
> @@ -423,6 +464,12 @@ static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
>  		kvm_gmem_mark_prepared(folio);
>  	}
>
> +	err = kvm_gmem_folio_zap_direct_map(folio);

Perhaps the check for gmem_flags & GUEST_MEMFD_FLAG_NO_DIRECT_MAP should
be done here before making the call to kvm_gmem_folio_zap_direct_map()
to make it more obvious that zapping is conditional.

Perhaps also add a check for kvm_arch_gmem_supports_no_direct_map() so
this call can be completely removed by the compiler if it wasn't
compiled in.

The kvm_gmem_folio_no_direct_map() check should probably remain in
kvm_gmem_folio_zap_direct_map() since that's a "if already zapped, don't
zap again" check.

> +	if (err) {
> +		ret = vmf_error(err);
> +		goto out_folio;
> +	}
> +
>  	vmf->page = folio_file_page(folio, vmf->pgoff);
>
>  out_folio:
> @@ -533,6 +580,8 @@ static void kvm_gmem_free_folio(struct folio *folio)
>  	kvm_pfn_t pfn = page_to_pfn(page);
>  	int order = folio_order(folio);
>
> +	kvm_gmem_folio_restore_direct_map(folio);
> +

I can't decide if the kvm_gmem_folio_no_direct_map(folio) should be in
the caller or within kvm_gmem_folio_restore_direct_map(), since this
time it's a folio-specific property being checked.

Perhaps also add a check for kvm_arch_gmem_supports_no_direct_map() so
this call can be completely removed by the compiler if it wasn't
compiled in. IIUC whether the check is added in the caller or within
kvm_gmem_folio_restore_direct_map() the call can still be elided.

>  	kvm_arch_gmem_invalidate(pfn, pfn + (1ul << order));
>  }
>
> @@ -596,6 +645,9 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
>  	/* Unmovable mappings are supposed to be marked unevictable as well. */
>  	WARN_ON_ONCE(!mapping_unevictable(inode->i_mapping));
>
> +	if (flags & GUEST_MEMFD_FLAG_NO_DIRECT_MAP)
> +		mapping_set_no_direct_map(inode->i_mapping);
> +
>  	GMEM_I(inode)->flags = flags;
>
>  	file = alloc_file_pseudo(inode, kvm_gmem_mnt, name, O_RDWR, &kvm_gmem_fops);
> @@ -807,6 +859,8 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>  	if (!is_prepared)
>  		r = kvm_gmem_prepare_folio(kvm, slot, gfn, folio);
>
> +	kvm_gmem_folio_zap_direct_map(folio);
> +

Is there a reason why errors are not handled when faulting private memory?

>  	folio_unlock(folio);
>
>  	if (!r)
> --
> 2.50.1

