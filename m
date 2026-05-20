Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1729ECD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 22:04:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DE106B0005; Wed, 20 May 2026 18:04:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08FDD6B0088; Wed, 20 May 2026 18:04:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBFB76B008A; Wed, 20 May 2026 18:04:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DA2466B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 18:04:08 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 72439C1BC2
	for <linux-mm@kvack.org>; Wed, 20 May 2026 22:04:08 +0000 (UTC)
X-FDA: 84789176976.19.9A6D7F7
Received: from mail-vk1-f174.google.com (mail-vk1-f174.google.com [209.85.221.174])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6176940014
	for <linux-mm@kvack.org>; Wed, 20 May 2026 22:04:06 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=vOscxK5Q;
	spf=pass (imf04.hostedemail.com: domain of ackerleytng@google.com designates 209.85.221.174 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779314646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9JThRUESw7nrWZ9dm2cNUbYGQDtPpp53TQuS0A6S/n8=;
	b=6Nlvx31+dXecIE5uvqOqmbhtefzhwLIL30jnBlykPNTTXqbEdyIyRl1BngSBMJeS7KwjsH
	f3E1NIgwYYutF72Z4CrpSxEhpMWtS7uAE4NhLQhVVxpxtroVjJxzNZ1PmdsdYXFbIJOF/A
	OEDkAmlP/NqPRVmKzP6vSvXCMEur09U=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=vOscxK5Q;
	spf=pass (imf04.hostedemail.com: domain of ackerleytng@google.com designates 209.85.221.174 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779314646; a=rsa-sha256;
	cv=pass;
	b=anCrnsSjzHoxIIFDp2wR5yPX9nS9OTAeTtTW4A6c1SOzQh0gpJg/ENIZpflWe875tgIU6b
	wJANni2QiH6Nv69xw4xdEcQOwHeb9fNybR3QSOqkhn3YkM/RV7h/8lWqz4LvAjNzVL3/eC
	CFDkcfLMVcLY4I/gzT/AQDYKfeiJGOU=
Received: by mail-vk1-f174.google.com with SMTP id 71dfb90a1353d-57513733658so1843035e0c.3
        for <linux-mm@kvack.org>; Wed, 20 May 2026 15:04:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779314645; cv=none;
        d=google.com; s=arc-20240605;
        b=XsFWlPm/+Ojs8ujDDRTNZaxDpoA2ilE14Jx7BlY8C4gBh+hpJfuRSnO5t4sWyyV01Y
         56RVhKAahfs6gCncNQrkcZBqZVeUPxYAaKXoDCBCI16MuzCstYeSy79ed2tAkzTEZ89K
         5ErDRRHxGHTMKRZY7t+HjPLzhomPAnessHzxspUob0/9PsUrqs88s/QgoXV7lLY23QUW
         kewYOwaXxle1h+f8ySHz+VJGF7p2wZEyHjaOrtaRXiX7Wun+cZfcCCSM/Hc09RInfPJA
         DEeSsxLwvvN0dJBBjCennNWNC1YgRDevD/DDufp5RM7JXerv8Lgp3NtL0jslktfVE7sY
         n85g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=9JThRUESw7nrWZ9dm2cNUbYGQDtPpp53TQuS0A6S/n8=;
        fh=rf5n3EITkUtrWJCAghn0+seDQH+J3hd02iRwsWwzIH0=;
        b=IQ2o1dzw/k4K89oK3NZqMPclEhyi5jAYsQHcSaCBM0tALiP4/gP2zclhgOgX9dcvDB
         b1asoGcz8wWj8wY9w8jZ2EKAnFVBdI3EprHg+ul/XbCV0XCSmDp8WopFZMUE9xcCygbM
         yIwxfbvbJnTZVYa3VL5l56soE2/n9t9F0jQT71DGFqmz8j1SxQj4JWCe7YJbHkVKT3RH
         6PhJemMz/VNJeXAuor2daEYqZC/D7FxVCnkkm9WTIYzSiymjykbXP8vhN1Npf+EN3SKr
         MbUpb1Kk1yIgbcX1wrChHymwLGWB3At4kVfe2T6JCwxl5Vl1Uaec42Yv4kz5v90fz6iE
         K8vQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779314645; x=1779919445; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=9JThRUESw7nrWZ9dm2cNUbYGQDtPpp53TQuS0A6S/n8=;
        b=vOscxK5QNL0twNAwNzukxT6TU3C7rrx0Sble0D17H238kiwYV2p179p371NkiOVAHt
         P8VboSLIFo6hy5YvCZgCMihHyfyeb7Fue2u171m3r9rvAJKbPKPrz2qT3GvR6+2ukGsN
         Nx0pOkFSejXln6vn+jzzqPJ8iaoxt8R85O+tXqXGCnmqWN/zyoQv/2tqsrvz1PK86JcN
         vDGqqMi0zZo6XxmdAAKpobyahz3Qhe+PArbL2Kzy3C26aE/vCirDGvPRrSIvcn+2OF4B
         ZFxiJND5aSuxMlpOQMzYJj3AU8YHEU0C66gnyG0RaVgRTzsFaYP97tqcEUSzzj00+Skn
         /27w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779314645; x=1779919445;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9JThRUESw7nrWZ9dm2cNUbYGQDtPpp53TQuS0A6S/n8=;
        b=GfX4HIrPyNObUf5gRrBa+V8Sq6BglMnMaYX4HbtP6Ja1uf8HBcFDyWkpyBWgBjw4Ky
         dZ+EAuA691e3YBsnhgkHMRp4D7GekERbUxIYmtEqVvvgpQCW81kLaTjf9FBSVgnnw5wn
         7NcaDdA8OaMBrouIiQjPEED5LGUbfVJX7Y3uUhmbCo9xXiUFcQxYDYsUN+UEb+I3DrEO
         maoAxibiGBH3yELzQ51x9eadO21+pHXabZZfFprYJD9VXo3hpuqKpN6deD/mz7e5sask
         CYnifRsBAYcvISOkwa1xIw0rrKSiSmZRu7Ng1GSMu1dvKqQRTMah7ACnvFZEhrGDTEOv
         zP+g==
X-Forwarded-Encrypted: i=1; AFNElJ8lIBR5CBTR3tM8qfuSm/KOerYuD113Wtq5TQjZng0ED1vmS8omKalTlyCJ/3fZwf9c5fxt8xklBA==@kvack.org
X-Gm-Message-State: AOJu0YyTPNJs82+W5AdyxhZDLrxLmA6wXAsGQk71AI+3FBPKw3p9Ueaj
	LBjuKTNbOtUZtlLPxBQbSVdvoonLn2R+JAkM+f3SPG57k+yocML3aztSzVRpDhvbyfJls63W4N1
	EiqLA4scBvpmR2du9R3JDEaGcPXn/k+wQ0j0eQecN
X-Gm-Gg: Acq92OFodEkf2vXKOBOjts7z8LxgXTlR/9bNo60k5bLQfGjJDEQnHGHH7+880Uc7rqP
	U4i2qeS/GipZ6c6C45CPJSV5AeKaXhJieOpnatx8d2SGcnvwij1VaCSMIIKqVDnKtmxK9xd6W1O
	DciE4jxvpguOURDVk35qJL705Yq0odtKaLtOIbc9Fp3mC5y4emoGDLyfiLArhHB2wiZsDsYWBA6
	Db1mRVcMIBa6+FF4bXm5H2eq1bJqVE9vFn0nzc+dqZrPBI38sF+iPpYko2EGg7Az1VRgi8L3msp
	LQr5TnM7ejsQxhVdKDolvefceVC5aCz7JyXyE66vrh8GqkR7HNZFt4NFFyibmglz2/Z3MGDU/XN
	dwRhD
X-Received: by 2002:a05:6122:c87:b0:575:a6f4:46b4 with SMTP id
 71dfb90a1353d-5842700dc5fmr95996e0c.9.1779314644642; Wed, 20 May 2026
 15:04:04 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 20 May 2026 15:04:03 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 20 May 2026 15:04:03 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20260507-gmem-inplace-conversion-v6-20-91ab5a8b19a4@google.com>
References: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com> <20260507-gmem-inplace-conversion-v6-20-91ab5a8b19a4@google.com>
MIME-Version: 1.0
Date: Wed, 20 May 2026 15:04:03 -0700
X-Gm-Features: AVHnY4Kk5AWPmehPTXT0rrzakigDAOdp5MPH9_MZKvxVyYhTvoPj0_nMCwFjLrY
Message-ID: <CAEvNRgGfWNG_NgC7v70BsZ3CJUu2Nh0KQQBwDdDrcu26=cB92w@mail.gmail.com>
Subject: Re: [PATCH v6 20/43] KVM: guest_memfd: Enable INIT_SHARED on
 guest_memfd for x86 Coco VMs
To: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>, aik@amd.com, 
	andrew.jones@linux.dev, binbin.wu@linux.intel.com, brauner@kernel.org, 
	chao.p.peng@linux.intel.com, david@kernel.org, ira.weiny@intel.com, 
	jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, tabba@google.com, willy@infradead.org, 
	wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
	pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
	liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6176940014
X-Rspam-User: 
X-Stat-Signature: ud7hi5duryh4tsg6eqx6c5ed6gj5gagq
X-HE-Tag: 1779314646-783813
X-HE-Meta: U2FsdGVkX18R9JF0m0jblNuQ4PJrNc4FjLH9QRbH83TLTsUq0pxQD0k7aAHKIJx19xmnhkiTdtMzkGkssjL4GZwHTQPwWcVrwAuSdj2kx8kgngDoL/IEPHLeHHO38P4Dn/Lgy1ghfal7fv+iXVZpqwnGtBBG4SmtF0miGh7lXdnucfzAq6FDAzBVTjp20vkfDVaR6NlodjTh/sql4Ep/afUcybS6+cMmw65mIc/udjaeubHQmIPTbu6Eb9Y7747PgR2ez4eVMjX3/EMpwDIV82EHHtHpzOV9ql+9MXzvjTotrSITk4gzCRmFRL2JFjuK8Jt33TA3OChm2B+BPEk3yLGNUaSVd9P6Zy96NFBNarj3CGR+AIEstLNPUjgqaoykLS3FaoUGLhMPxt7nTwSsOGOKp3fYox50BfM9uuXN7BpBk6CDtvdkNS9EbQ/C/7kBtYd8hjxCQ1t5A+wKGfO1gHvnVwmNyFtv/Oac5QSb3J1dSRotZlSpEo+Cg+JhDXCFQCdFA5UiutbaOGU17nEzrpV5ppXlYYad3o11uK4sFjoi5CIcVWWJfFIJm3PpEv90r8kJHm2tQ8W+5WO9198bmc4B63PMY7ryuQMCiKp2/QattRBiLeJLj0SVXvA3qA2ON5ZVzDVRcJYv82YdqSE/EBfpQG/+ZJ2rZNuY00G3Ltt0gn0Myq/xuKuyM75fo49vXNZhWe7+2f9gyK/WpRb1VFz9//a6RXR/pnpPB495lQjagDd+lZYMWw8GFN/oDisKhkWhcH1yRGBG0NAVFQPdZU2O9Rwiigc2O8oRlGjacZuLjzYYoDcARtXDAc2ecTgF/sHyUBulno6NcAuBjOdcYWnse3OFMzeq1DtROpHKajXETRKAjT67/WVAmEnZtNG6AwvjdC1dncoCSrAUNEy6AheuWqTwET/O4abK5U/HCqf6U7v+gLK4OS9o8+IuxpPUgd1hrC0l7YxOqxxTdj5
 HUd8RpL1
 SWn/3SJu2y5qncKkQWyELtaILr1mmP5i4jyeLqbXMeYOxUX0znpccll3bslLxK5vVxkazSSHdVH1sPGyLOxsWkJBS8RqrTfOEWpz8Zk9qoWzIRzQKOAcYhQCTJs6W77q+7k/z2EtpIwbThBqxnIBVmGLN8lkYe0/scrfuHeT5146l+E5evkM0pAbRWbOOJ11RuhY1ubFGirwq8JW18/6cdumZSUyhP2xLzy/01gGKNPcFZIcEWjIQUzfJ2VK338uuoOa6Y0Wywg3x4gJ8yB+GpkDevVWSvNHFeq9TVdeiQ9ESqNN6BXJ9BWB/0yjMy6liMFxLUNWyQpVSF3eVSLSPs0Tp01mrZN3UMfZngN6uPO2hUGELcl8XsHSgs+3n0iauMaFDsUCRYcitCeNrGKqC8UZig5U0YcncldXKg9Ie2v60SrbCNuI9gOKzwBT2pB4nlgYxr7Tb/VrE1Lnvz0ghBLx0UIjIgvqyUI4rAEfHS5tlaNM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
writes:

> From: Sean Christopherson <seanjc@google.com>
>
> Now that guest_memfd supports tracking private vs. shared within gmem
> itself, allow userspace to specify INIT_SHARED on a guest_memfd instance
> for x86 Confidential Computing (CoCo) VMs, so long as per-VM attributes
> are disabled, i.e. when it's actually possible for a guest_memfd instance
> to contain shared memory.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> ---
>  arch/x86/kvm/x86.c | 11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 1560de1e95be0..6609957ecfea3 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -14172,14 +14172,13 @@ bool kvm_arch_no_poll(struct kvm_vcpu *vcpu)
>  }
>
>  #ifdef CONFIG_KVM_GUEST_MEMFD
> -/*
> - * KVM doesn't yet support initializing guest_memfd memory as shared for VMs
> - * with private memory (the private vs. shared tracking needs to be moved into
> - * guest_memfd).
> - */
>  bool kvm_arch_supports_gmem_init_shared(struct kvm *kvm)
>  {
> -	return !kvm_arch_has_private_mem(kvm);
> +	/*
> +	 * INIT_SHARED isn't supported if the memory attributes are per-VM,
> +	 * in which case guest_memfd can _only_ be used for private memory.
> +	 */
> +	return !vm_memory_attributes || !kvm_arch_has_private_mem(kvm);

Adding a note here from PUCK on 2026-05-20:

Michael pointed out that it's odd that when vm_memory_attributes is
available, guest_memfd still can only be used for private memory.

It is a little odd, but we don't want to investigate the complexities of
supporting it, and Sean says this is working as intended, in line with
deprecating vm_memory_attributes=true.

>  }
>
>  #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_PREPARE
>
> --
> 2.54.0.563.g4f69b47b94-goog

