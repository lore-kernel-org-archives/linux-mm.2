Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3945FD4662B
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 21:48:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E9F06B0092; Thu, 15 Jan 2026 16:48:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A1416B0095; Thu, 15 Jan 2026 16:48:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A3496B0096; Thu, 15 Jan 2026 16:48:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7B8996B0092
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 16:48:13 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1FDE28BBCD
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 21:48:13 +0000 (UTC)
X-FDA: 84335536866.19.0EEAE60
Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com [209.85.217.51])
	by imf24.hostedemail.com (Postfix) with ESMTP id 33B3D180004
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 21:48:11 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=CY2SyrCC;
	spf=pass (imf24.hostedemail.com: domain of ackerleytng@google.com designates 209.85.217.51 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768513691;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z1tpnpSOuS/Js87YOF2H5fRocDrhGRoFky0mpImVftk=;
	b=ZYpc08pryUesTWEGeS4x4pV5E6G+Lt9WGNOWGmb6x1J6Yveiu6O8f4D+cX1WbCc2bgiySW
	E8UZ0T94QfLwxIwGXS1Fdp9CcUCbusSnIG2gztv1NcH4ixJupV0gTQP9vdSj2k7vJxsEYk
	lOJYwJSS92hQqTiUCfrZREQoezgvOg8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=CY2SyrCC;
	spf=pass (imf24.hostedemail.com: domain of ackerleytng@google.com designates 209.85.217.51 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768513691; a=rsa-sha256;
	cv=none;
	b=YCaxWTQL+DUPjJ61LEQ0V8QaS44+/bPAiXONuQx6uDPufs0kY2dP8BqQUNrXDubkJOxkQk
	QM20RFzV85J8CMr8oysCuz+rpdvAZKMbnFkE1LqiBwUVN6pDbYsoLP8oZp0epYFuqShF8O
	/1OeHaE3s4ybS8qG3oaSi9QP1x0GV3s=
Received: by mail-vs1-f51.google.com with SMTP id ada2fe7eead31-5ef31a77afbso1723989137.0
        for <linux-mm@kvack.org>; Thu, 15 Jan 2026 13:48:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768513690; x=1769118490; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=z1tpnpSOuS/Js87YOF2H5fRocDrhGRoFky0mpImVftk=;
        b=CY2SyrCCBx/0Qnt5srdzdHadRVUTWYjBQdmZ6Jy/Wn9anM81qTezzmkWkhRIIDcEvd
         IWY32NsBr7kVHR3da+JzACWgz3ANLL0PIpUx00+x3kcKXzbr+SwtAZDeEyUUV5o0nLWj
         CgS2Q8oG67nLQ/NZY0TorRYcsLZFqomv45dN8dMmntEAMPVIYvMGeW911a1poZE0qpLD
         6z+1bIDymQ3UcamvN9LipSbiq+2nCpCf4PSYYleWF6Ni7Sc6le3iaYBBJfDg0tfipist
         6jCg1Z33n2PHmU+kKMmitEsixMFLJOC/xu6VHnqK/XL5lw7X3dwyKlE5rjkE3wVY84Rj
         z7YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768513690; x=1769118490;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=z1tpnpSOuS/Js87YOF2H5fRocDrhGRoFky0mpImVftk=;
        b=JgQz4/3V9lVo6//L3EdAAlSB+4P6Vwr3g2q7jUawjjyGNWuPqdvRvnkYomkKFIPs32
         zWkLa30FOVWKnEwMuPpayh7SeRds1Zgfiw2Qrfa1pM0H4PMQZ9vD1hfDfRWrse1TQmsv
         8hia+FfZnFoeWAt4SY9Ub3YvUJtZLmcbrYW6piXAb4WlIZ5Yix6u+Q0OOx+YbeY0VBfo
         9ZxhHMvqswftAjSb5QjMMFLzsoA82RH+OezsccTRjywWj1yC0dRvjxhF9ljdloDlsWPw
         C+iNSAGg7vJynqmu+6EZViSAveIxIy7H8etlL/LV2Us6Lrajsg5auHFYLm0j7pme8ymK
         90Ig==
X-Forwarded-Encrypted: i=1; AJvYcCVfbMzZADgQr37LlKkXANSwkHWybt6/s5R61OPNX3rh5AAGeRnufkHKqWLTtC35BNVDE6dJOQGD3g==@kvack.org
X-Gm-Message-State: AOJu0Yz9Rows//bFKDkJ8LrLpS8mh+QKsA+idqr/+VQDpAavO61gfGBC
	n0KTaS3l/5nkWk9evODsSF99xa/svzXDWa8vtOqLu2U9+zDTM01HH0A2AeWhNO0pPvUcITVJzBz
	Qbg573/XUIAQDC0iLfdKTA4sSiq/O4cUO/ls7TIi6
X-Gm-Gg: AY/fxX6jeLHUfsVJtHoZV50dVAeVUhoaRttvCT1MEKpYCFrFC3pdhXsYShVoTZTfEkN
	w09CD0CGNUMoXuz5QWIRq+cIJYvOwmnsL9Pwn1pLhH1DvKLLQxKnNmfklJitSobNjBcG450y1D1
	eC9e8dV4pNco6hkjW3cTbqGeUWDk1ImZV6o+d9rjsBuW06ZQeNfOmwYI0H7/Lw7SjaI5m2B6H6l
	bZ27r8F5WECq5iZme1bWbEQfnjF+CvQhYV1XCfDPgPrUF7E1GKJG7Kug2JXtZcFQ1zPSUdmQ3PC
	rGpn/beS+LKf6lB0lix1RdEziNSe3uG8TUw+
X-Received: by 2002:a05:6102:f13:b0:5ec:3107:6b71 with SMTP id
 ada2fe7eead31-5f192508297mr1821684137.14.1768513689093; Thu, 15 Jan 2026
 13:48:09 -0800 (PST)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 15 Jan 2026 13:48:08 -0800
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 15 Jan 2026 13:48:08 -0800
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20260114134510.1835-6-kalyazin@amazon.com>
References: <20260114134510.1835-1-kalyazin@amazon.com> <20260114134510.1835-6-kalyazin@amazon.com>
MIME-Version: 1.0
Date: Thu, 15 Jan 2026 13:48:08 -0800
X-Gm-Features: AZwV_QhGkMBioMKFssSOB50hq7Zm3qSZq1aP9Of9c8wem-vUHGjRo2vWaCWRwKU
Message-ID: <CAEvNRgEhcTE70RLiQo2C_XUdF31qSkQ6yHwpUiXPWb6+6mmA0A@mail.gmail.com>
Subject: Re: [PATCH v9 05/13] KVM: x86: define kvm_arch_gmem_supports_no_direct_map()
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
X-Rspamd-Queue-Id: 33B3D180004
X-Stat-Signature: 8js351gi6gskkmz85xijma4syzxr8awa
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768513691-720579
X-HE-Meta: U2FsdGVkX1/Ws0EcTePbH0CP94XDtt5hgwNEJkrSKXILqGaOemVQbexSEld0nCWR1d9DZsLIObQ6RIBHQ5tmADON8gx2RjTsX+F2bBANs2HXkHMB+SgA6TXykxmGR2i1XoGYY01eTb+e+skC8EK1RfxB8SjKIlihW/nYCiCbU3V/Wn5/h3zbCeW5M4xTsjRY2gv+MZqFU5CwZfNGkLSQpPqx4/kEB007OMxXiblGCILcnfANQyH/K/huCDcdrghT1tLf2s0UqfCaG7nOr6z9HcxK6q97UVjvVmAPo+izm7bmqW1QvRe5z3PYaGfPVkkb2qXgfs3TMqZfAfvuFLkw3n4pyj1+GInZfoONKuU+O5ycpkTsSluySfn/+UgXJuGccxKqOk1s5N2B2/Fbn4RSbCDjcMDbWBFm4i49TEbkcodmSTNHwXX+EnZfO5FLCZBZAHcfX0bHwRJokKwZwp5gQednj75luX6yAk/mGx6MSo5avkhxG7rOGXcj3LmDccEY5RFfu9t688aI4J1aUSDj1gEyQkPw0QlKFiCf9pJqtjImKc75Np1kxrntCkNWhHOjUdvNsEbZ1Hvpf4vyGS1VSvk+ozn+jq+0cXu9ERYrUVd5x7Wx8x/BCHLaLViNCjQsUaryZXOM1EgrJv6HbjdcCCWsvwFFlrb8GI6Fn6IdvxCCEj38xw1qnP5M7QS1MGg18dh5Sv/zfdlCDLe/jzoOvm+xHlovkgVJtDi8Mzx++c6gc+PHH1P/JuyY3l3Yu92QUVO0BGY77GNMztuoYxHWhlBkJYIsdNarJu0T8qhsu8Ea+8zV1+Wc1kymHmTXbLxYztxd4nzgUWCC/2THHQGDwRTLYXYibSgllH4NVqHsmj6Y58f5RN7+ZcdXmRkhA+7QXChGPGwCKvFp2Ld7LJAfHiGzhkb4RvSF0tcev3Raoesrgi8EIRlIwRfHAv2DYGM1NuFmOI2W7Ha2bYoim9Y
 ZeQ+stHz
 A0yMNB/IEhNUlroeAcpz52i2zK0QmoOzpasZQupOaCm/VeUpdZp5c6Oq31wxQpm1ioyT77VF6+wOmSlOeOYl51s3iqeYgrH5nuL8k4Id8lxCWuFeQrjWXq5JYdGgt85beZkvgjEXPxxfzozQxU11AVrFutsaElrzBZ4BAE7Rico/XrU8ug+isCisUiXW4RwIUGSc/OuL3EuIDV+PIrPnHHo40Sxcb0lcioeJV55/2xBap4/jcUN6ElFVIirVs4PqgrA7X0Q5QrRi/jl9Zjzjc8qhDrM7htQ7cnBq8X/oqjdMbr/ph37UFOS0oiDDbpyYt5NpMu767cVMERl5Zk0iOncMwyMg+fsTG179Hm8cLyXq5seTF1jAv5T5eg/1exuWs74LYkGY4OIOjt0ntpMSJRCZhPScc/EqI2n3AzCrp17M4wNrGaZYm01eLJQBjzg1mAsDgM1pl/ZMmNTHo6NhHTgLcu/jbglo9b0uvBOWjs8wHyPs=
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
> x86 supports GUEST_MEMFD_FLAG_NO_DIRECT_MAP whenever direct map
> modifications are possible (which is always the case).
>
> Signed-off-by: Patrick Roy <patrick.roy@linux.dev>
> Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 5a3bfa293e8b..68bd29a52f24 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -28,6 +28,7 @@
>  #include <linux/sched/vhost_task.h>
>  #include <linux/call_once.h>
>  #include <linux/atomic.h>
> +#include <linux/set_memory.h>
>
>  #include <asm/apic.h>
>  #include <asm/pvclock-abi.h>
> @@ -2481,4 +2482,12 @@ static inline bool kvm_arch_has_irq_bypass(void)
>  	return enable_device_posted_irqs;
>  }
>
> +#ifdef CONFIG_KVM_GUEST_MEMFD
> +static inline bool kvm_arch_gmem_supports_no_direct_map(void)
> +{
> +	return can_set_direct_map();
> +}
> +#define kvm_arch_gmem_supports_no_direct_map kvm_arch_gmem_supports_no_direct_map
> +#endif /* CONFIG_KVM_GUEST_MEMFD */
> +
>  #endif /* _ASM_X86_KVM_HOST_H */
> --
> 2.50.1

Reviewed-by: Ackerley Tng <ackerleytng@google.com>

