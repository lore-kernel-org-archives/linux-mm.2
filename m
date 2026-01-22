Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91482D6CFA4
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 20:31:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37D0D6B034D; Thu, 22 Jan 2026 15:30:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FB6E6B034E; Thu, 22 Jan 2026 15:30:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 100896B034F; Thu, 22 Jan 2026 15:30:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E32B36B034D
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 15:30:58 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 74543D4BF3
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 20:30:58 +0000 (UTC)
X-FDA: 84360743796.26.90D45A4
Received: from mail-ua1-f49.google.com (mail-ua1-f49.google.com [209.85.222.49])
	by imf19.hostedemail.com (Postfix) with ESMTP id 719F41A000E
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 20:30:56 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=UpKYwUBw;
	spf=pass (imf19.hostedemail.com: domain of ackerleytng@google.com designates 209.85.222.49 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769113856;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BQj97zlME5zzETPT7vCk6obWp/pKKcD8Mr+mou6nGos=;
	b=ESK4mcrdAi3sCv4PqtlCXnHe/0qxODf7OUxxXzmi8rrxsaV7ercB0wyf0gKyOBRzrR5hU5
	VzLtFl48ZDDadlSKD4jnNH1Plw28LsFPOAXEcwTobafImZmB2Yqwt6l4HrpK5ueF1kWXuw
	MiQJGRrM2bMcSk/ySw9Bmp/Fh0bxdBY=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=UpKYwUBw;
	spf=pass (imf19.hostedemail.com: domain of ackerleytng@google.com designates 209.85.222.49 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769113856; a=rsa-sha256;
	cv=pass;
	b=HN4SKI1ejAm94mywsLd47j7oSBMQTUUh+7DwP0bp/PztLCcneQhmPpBDvcOQRZDSWTjba4
	jmLBFaLP5kOGAbPEY4XsgWORRpS/j65kfWjei1FiKubngpBxuRuSt5ShLouN9OS/3Iv7Pq
	jJrlh2n7vZaSVZaxtRASX+xhOAiiWV4=
Received: by mail-ua1-f49.google.com with SMTP id a1e0cc1a2514c-9413e5ee53eso916049241.0
        for <linux-mm@kvack.org>; Thu, 22 Jan 2026 12:30:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769113855; cv=none;
        d=google.com; s=arc-20240605;
        b=akqMfxSp8QNytErjBCFdd8AU1AW1q4mVV/c+8aVYRXDh5t7y9nswqRwvNvYGnkWcSk
         N9wVexxBQ/pbD2KEefnkAJKsdQSaBIEWwIXT0MkgWXnkbNk7MqvqzoVkjIwc2cOPVc/E
         ry5sfBuwLdbwbFXel074SAZPYOKiJc7nIKOkfHxZBZSJdueiCx3MROiZgA1ntZIiIXp8
         tqdlDWnl2cAzlPAtC9kame6Q+IWsux7D6vk6opu1Dm0IGi5G7wdhUqry940mNHs/jfZv
         O1fJesaSkSIGk3opy5eoKlvsqUk5akNs90g+qiKJyDwvZ/hwFJyh45i24tAB2fMr43h9
         3kaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=BQj97zlME5zzETPT7vCk6obWp/pKKcD8Mr+mou6nGos=;
        fh=YbGswyX2VpF7g9pdsVc+KqDCz7eghsvH8oKg7OHABIo=;
        b=Hq3QqwzJsngBx7alFXT5nF0ynOhthCk2NwEASB5Br935h6gCebkf7KNXmLudR26kwq
         6lLt+SYogPC/6m5GkSiEf3BP4EJVTqAoapbVz8IN1ZxaBRhq/UjLTx9Gd5/8KoUHDbkr
         KH89QapMjBCaD49lDJ+2MlpqMi9sdksS8svuScJO7rtjUUrHFUaCH/2pNW7OrOsG0EH6
         jC0I/nP+SlG/ozyPVMPoJmeMIq+IjUURczi7V3HJuwyH6gHezlVZyOPQ61tiX6hljCmP
         64fCWc3uL1e32HaPviIRw/8ZZJA1jioofNUpiHnAVA51sPoRvM+QxMiaGZ/4ijb0WLAW
         uPng==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769113855; x=1769718655; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=BQj97zlME5zzETPT7vCk6obWp/pKKcD8Mr+mou6nGos=;
        b=UpKYwUBwrorn7rq7soBH/toI/qfFqQX7vQRujR/k4PxNU+9EGBp9wDF0u9Lp1z7NHF
         PDZw//mkmYexORbVbrXxd6oyHKAImvMrNn/UTJlOr6g/ww6wHwmFZ/sDe6WM/2VZrq6D
         MlBCvss+ONOaTEHVkzl0iBzY1HLZg9WjDXuM4TRF/z4TFEC6RcTJ54LzL35MblxS6bj1
         aRgorqtyEImrncX4YfECTUzFEEVzO4essWtre46hJ1aO/f/blU1oxlOdQtSEKF859kXl
         XgNggh3s6hqz7mw6IxmSuHAbK9oAgDy3+BvN+FjSHPc9H3MxRFxYr/gACmlAOf48MO3e
         Ti9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769113855; x=1769718655;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BQj97zlME5zzETPT7vCk6obWp/pKKcD8Mr+mou6nGos=;
        b=mP309/CDUdVfWEsChBanUeNOu5uEmbgtSQ94vyOhTycEUwmPo68iIpqRNhJKi2cXCM
         HsILy6C64A3169WVimhXJ/blxbscJ/3Zq8IQ3Se09JoLnXgI08xWrMdU/sZzCUHhqr3A
         HpZhEHaLWi+aQFZ8FIrFopicoWE+zUGKUroKg+Hio2yA4B813ylXR4q//7rVzW+Q5Jtg
         20Gh+VLkIjJl4BI0/8yaTBtRAWLGe+hnQsj3p2Wod2k5FzlUJ8JMSSbTsdNYZpREZJxd
         UQFCVEfCT8wAyB0Mh8B47p+PL0zDxn6wYQBg0MYmOrQo0xuIbmFu7/Ey3Hs1SCtAkAjY
         PtIw==
X-Forwarded-Encrypted: i=1; AJvYcCWhzKXBwa/6zZWOzEgLZZNNq1TBFOslGrbyaWOEgWg3Hq639LZkp+KVEj2+RDvAUlcgm7uOOeUPzA==@kvack.org
X-Gm-Message-State: AOJu0YwOnhjNmNoKCBCzSJ+kXvGgeaFjzYbtL5qFzje15xOCP75o+u8M
	G8q6WBKNXzSvK7ZMYRtCCBlls2MZialfGOyrWfjfGs30m6pjgk0w3YDv2L4CkRR01OnFJU+P57X
	15rQe5n0Gj7BuzGTBdCC73tHVWEwn+wF/9Gkvsaip
X-Gm-Gg: AZuq6aLVl8ZCoIAV3qeg9DThLGH71CXA1O29Y+oj0tEZNJiWxsbyjAhSzFdxOY8KsXK
	7qzPKL4NFY4o9EMn/ByRwJOdMEzA0sgSbZ+3sHRuZBQNz3ihaC+Um0O5MEj8OsqEln3Uk8Ayb2J
	cMZmCTIBoL01lcbYZBCkeNA9ADrLkCZWMOwmvOsIPZE+ArYOShoqRMbGWH6pfty8F1/vReeWiPU
	aSBS8UFogMeFc3/H/0LiHz/g+q7KXtzqNqo1AnDgieIuzimIC6Odb42QvGf75Ubr+qW3SMVX4zR
	ibwkeZAo8LOPx8MuWVyz2zw1
X-Received: by 2002:a05:6102:d89:b0:5ee:a8c4:18d4 with SMTP id
 ada2fe7eead31-5f54bd0c3f6mr359613137.35.1769113854610; Thu, 22 Jan 2026
 12:30:54 -0800 (PST)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 22 Jan 2026 12:30:53 -0800
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 22 Jan 2026 12:30:53 -0800
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <f2f2a6bd-5cb4-46c9-a0f8-3240670094b5@amazon.com>
References: <20260114134510.1835-1-kalyazin@amazon.com> <20260114134510.1835-8-kalyazin@amazon.com>
 <CAEvNRgEzVhEzr-3GWTsE7GSBsPdvVLq7WFEeLHzcmMe=R9S51w@mail.gmail.com>
 <a2b79af7-e5d1-4668-bff3-606f57d32dfc@amazon.com> <CAEvNRgF46M1jp0+eBu2wQMO7P1afyo00SOkENFwvB2KYX3dnFA@mail.gmail.com>
 <f2f2a6bd-5cb4-46c9-a0f8-3240670094b5@amazon.com>
MIME-Version: 1.0
Date: Thu, 22 Jan 2026 12:30:53 -0800
X-Gm-Features: AZwV_QhoTAbsDcZFNCQXVZ12J6m5MEBpBa-k8I2xwSPIY6AXvlNDgQnkgPrJ79I
Message-ID: <CAEvNRgEd=Uh09dU_P7_vvzRpOyMYd=OKazpkxzr=VLe5HcQhGw@mail.gmail.com>
Subject: Re: [PATCH v9 07/13] KVM: guest_memfd: Add flag to remove from direct map
To: kalyazin@amazon.com, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
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
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 719F41A000E
X-Stat-Signature: 7ep71zje9bputunmk4ami5brih45jeix
X-Rspam-User: 
X-HE-Tag: 1769113856-836629
X-HE-Meta: U2FsdGVkX1/A5+ov1QRwg/KJaHr5gJQ+hzXF5RtmNvDuS6l79ptZ6mGAtJgtEF+B5EiekyrI5ucmV9OmQA06nLaD4D7dhNilQSI3qm9l0VoMfEagTJcJ/vbt41PIXJ9sHzP4mpNbvbziroM7pVCp6LK0ERW62aQgdBLA9b03z3IjuympaT45pw1WwgMC/Q62uzasfVfZB3/vFMPL8/6Ak5B5G9QKTwFmbGhyReucpd+SpOw8qCee7IOl83AWsBziWTpDH7Uf0nBFhBNUA0yzE3gh3T4eQlHBmqUJZic1lhGNUl6UmkQ0xrNqAVRcUuHNwjIWjiynm33YRmyvK/AaVxMEJ+VW0UXsJjm58WMR/vzNn9rwZBt4m17kbODbd10KuB+9eTRZnawHLwP+J5B1C0aC/uoK8B+oWi+vP9QXRoG6RMapKjQWQbC3Wnoc6O42cMM15vGAJ09laXO5qhRwMlrU2iXJjiRp+cguP8coVz1g9Kym6Wlq3KdeJB8JCEmXR/BRTYj8QDDHu/4JqD2mf3w0LwnPWTmfg3MNS3silCFOLrp7t78hmCVKqfg/CA2wRRPIRxoYjlz4bKCRcj0aATjVFpaG5Xf3QyJArX3dBRC6MTM9yOBfBUsdByEZR4tsSQacsdWm+NIG2ulEStyAQmHVSq6X2XQRcXWOPBpTlU5ppuWDNg2f1IMatU0m+VUaQaaLwM+eSffmmF7uaVWHpnijapPtZqui79u8I7GV9nVdhlum+uPTm1Hu1fur4vQYlum3UUS7obfWQrTaS401MIyKdMygqOfLYV+mfeuX8OmOWGzD1DYYO4pC19wG/5nY0W3skSNiYCWVoR1YWwA7LAl5gVku2/qO5OG9qSCRcY+zrNJ1iyP+/tVTAk0ahHjjnpAtHK3MxwJeX/FZSGe7HN1vCym9ZCu7ynIHQXnxY1T62vMtIuc2B8lxhF+Un1vLQcRpIZR74YUzdmzCZUc
 F7xEgb9T
 Jp92lVbBEyS+XO2yuHxcIbtgWafMKPTI4mr+iI45KH32r6n2AB+17eUfXnySkJcTfzBzCY+b9EFQ6AhF60cPvpz2icPAcdqzfdXg+4HjBHZ2JWDS11hQ764EguBaEAamHJCUmQTB2oCtAFP5J8HdFV6sbN5phsWoxHlUxE0PbSpzdlvOOOovKJd9+uvXYTSNOI6zMm1StjJqF8SAZ1NESuAUYoEw3tYj29Wiu5IpFEALkj+BLorW6CWWA3bSy6mhRDWBiGPVicgXs2FYlx7Ml5X3H2C6Gq33KgkLq/O6OrpD7WM0Fs30ahHgMBVx2AijwtVbM2Ks9/v8+EKKOcHmg+qBQ3ehrIBUI98X4QyWJWvO1koh6WHKo83OC3p1xnKa50UvNI2pRO0ZIJ2jwT/C4nk29yqtaWZDmETi0Ix8dLkYCNvkROyaTO7kGtG1AYdlU9B2Lmv62fE9ofNEZ+gFYurZ72f/gZzvPtt3rk/g/Jy6lyI1ccK1ez1EClZiSMJLo5iuHlfqA3JQgc/M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Nikita Kalyazin <kalyazin@amazon.com> writes:

>
> [...snip...]
>
>>>>> @@ -533,6 +580,8 @@ static void kvm_gmem_free_folio(struct folio *folio)
>>>>>         kvm_pfn_t pfn = page_to_pfn(page);
>>>>>         int order = folio_order(folio);
>>>>>
>>>>> +     kvm_gmem_folio_restore_direct_map(folio);
>>>>> +
>>>>
>>>> I can't decide if the kvm_gmem_folio_no_direct_map(folio) should be in
>>>> the caller or within kvm_gmem_folio_restore_direct_map(), since this
>>>> time it's a folio-specific property being checked.
>>>
>>> I'm tempted to keep it similar to the kvm_gmem_folio_zap_direct_map()
>>> case.  How does the fact it's a folio-speicific property change your
>>> reasoning?
>>>
>>
>> This is good too:
>>
>>    if (kvm_gmem_folio_no_direct_map(folio))
>>            kvm_gmem_folio_restore_direct_map(folio)
>
> It turns out we can't do that because folio->mapping is gone by the time
> filemap_free_folio() is called so we can't inspect the flags.  Are you
> ok with only having this check when zapping (but not when restoring)?
> Do you think we should add a comment saying it's conditional here?
>

I thought kvm_gmem_folio_no_direct_map() only reads folio->private,
which I think should still be there at the point of
filemap_free_folio().

>>
>> [...snip...]
>>

