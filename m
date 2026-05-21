Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF1F2CD5BB0
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 09:55:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04D346B0088; Thu, 21 May 2026 05:55:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F19456B008A; Thu, 21 May 2026 05:55:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBAA46B008C; Thu, 21 May 2026 05:55:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C5DD76B0088
	for <linux-mm@kvack.org>; Thu, 21 May 2026 05:55:41 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 735AF1205D4
	for <linux-mm@kvack.org>; Thu, 21 May 2026 09:55:41 +0000 (UTC)
X-FDA: 84790970082.21.80B9753
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf23.hostedemail.com (Postfix) with ESMTP id 7D28D14000A
	for <linux-mm@kvack.org>; Thu, 21 May 2026 09:55:39 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=JCoLrjDL;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of tabba@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=tabba@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779357339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e7M9NhGknWQDqckmSxYqMS5E/3kqK8iG7U98plSW4NU=;
	b=z/GuRlQTSewbtCHRyeN8yF7S6cCySKBIBNLZ1QCTSVNGKkSeXniBRVhUdLiS/4G7Z4h4A2
	v0EGcaxApm7sIuSYi7H/jiF/nImdbRhFjYMbLsIqMROwxjNy486C/AW7duvPbJKla7dsq+
	RMPqXUnQUu/1YMz2X+70vhEE9nJ0VgA=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779357339; a=rsa-sha256;
	cv=pass;
	b=wLheTBardEc2PhO8lr9KX6kgcL2+6l6mosuJyKiM52CT3KaraxrfOqISwWQBgOwRWPQ1lY
	rfYgvNcW6UnEteI+H67PNPhwD5J7F1JjyjjAmLl49vUXIN1j5UDfEcOleaSPxekS6t55O1
	tNyZM/wj4YpIYieyKGep0tKqeNZAosU=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=JCoLrjDL;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of tabba@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=tabba@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-50e61648f10so14341cf.1
        for <linux-mm@kvack.org>; Thu, 21 May 2026 02:55:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779357338; cv=none;
        d=google.com; s=arc-20240605;
        b=lJU/ZTgYeDxTLEyQ6Ctl7nTIBJ8ms/PzUhsaYDo5w5Ymd5++gFzz3FXrD56Jbhdidq
         5OSZHqg4QUXRMBTL7DTQV3SmgXrztctnUrlnrvWHz2VVghvAqPJeRPiQhUnSU+5AUSfM
         4Lh+RzK0BXuvvXPvcPlAXRLn5vGgfmR8kEo3giOB55o9QAckX7ivj6SE/fNQ2/3WiYPE
         t6e5wdIx6ui9LUSPfMpkedRPCpX4HEqxvlgsTtieFXebqdKwNoUBCqDYvgiFe/9Ksfku
         9d1bwrqZaWxtoZLBgaSYwfL+NL4l0/4/qt9TLG0LzChMsZkOmFcNg6XJ9rZKCJe9rgC+
         FRBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=e7M9NhGknWQDqckmSxYqMS5E/3kqK8iG7U98plSW4NU=;
        fh=rTAWCloaYtAfGYZYngP5WdqaRcrzkHh4TlLeYSA4Fow=;
        b=S6KrwWVr9i5ztQG8PKa6rwNl6K2s1ur1HMae1sS6+EgCDlpzXwK0u05JCfUbH4jXo+
         YZfQpfqX0zo4n8Yfky6UhCnmc5Yfs/0HxOqDDz95feZfTgLW4QZnahjrwEdbA+d6Dw51
         082zgBwhwN4Q7nkc/mzKhVh+qzzWvSMywqqPnpt7jgWtLjU6sHt0qFuleDsE5fMJmtvk
         zYVBE9VUon1+vr14rFiVF8X2Etd4t3n18TrNvXBUyKqYCwUp8pf1L5lzVFxd8rFlZPg7
         Ywlg4a4/un37FektuOUlek+1xqw4pq2K8Rc0/ZbPOCEgdJC+C/3WWGYm9YvHaN1FzMQZ
         7g8w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779357338; x=1779962138; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=e7M9NhGknWQDqckmSxYqMS5E/3kqK8iG7U98plSW4NU=;
        b=JCoLrjDLBsXiggh/2o80aH6SeafiM/Ns0wDWz4Gpf2TAqO5q3Pj0ISOEd//7NTWiNk
         02mrR4qz8k96hd2XPMqmv3pSTcqm9fC4dxI486JiELRam5bv9edJ0U+hWVJQ9H4iZ+Lb
         QShTk/Wg05zPoD9o2g7zQKqcOO9/6MJ4ndrbOxHlXmi558X1resxORbbVl87DWeMTK8Z
         9rMlYgKWZIADIg54yTqMd/A7xlMiN1WuG4rij58mguAOCmiytf3AR+1MLTnUQPPAL6R8
         OZ1jbNrooCf2HEvukhcgwYqFlUv0Fjt6XnrPf2kPow9q46cJRBKJx5Q1LOCCPKm497/e
         hbKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779357338; x=1779962138;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e7M9NhGknWQDqckmSxYqMS5E/3kqK8iG7U98plSW4NU=;
        b=hM1Cqmn7/Wkm4aAFdTG0+TnovkqwtbfGGy9ixShHNjjYVVsHqbOGgKcU37mN6mehqN
         r5UqUdcVHzvgiUAHIiP9WtqcPqMTjBOMfl3vcvYu13Q6DKlWThSD16oMJvUunbI5/jA/
         x2WP8rnCudK17M6EtN/WAfgjsOBwK1xXmdd3iMDvXIVQlRbuyQObsg6qYdyhJjUqVIW9
         aWFzhy6XfMYpITiSzgXF3j1PtGAuqIMS86E0YTh2vdxPpxOVPRIlLje8Nt+G7bFVjlhs
         XeY9w0dzNluAXn56h05SI3fdyt2J/J5geqD6yfP02TywWv4ePKQAPUBMCGNHXumbNbAQ
         ejWA==
X-Forwarded-Encrypted: i=1; AFNElJ8Uf5BUzQAw8NOW306ibhGBTUXCsU6b0AwgjGSgvRtLX8tkuiCNaFHRclRyHX0Q4DLtsOy5UiNLVg==@kvack.org
X-Gm-Message-State: AOJu0YwufReULD3wgP2TiltNtKA4iv7LKWkCPzJdf1m51rxbEst600Vo
	vUyYy0c3QUSmnfDeuDhw5TyTjJZJXdgwaDrPsYzzPZcKxqqXTXq8hzOz/Z+/g20U1He7jQFM2u+
	Qm8VVdfrZe+D2XApXeOEJA3T2B6slI/vHUihAqgk4
X-Gm-Gg: Acq92OGJwb4+0gAQL4jm6/sJYCVSDcHcj1Gq2LAIyt+6lgzofeqX7AJs0oIEJzxaZcD
	Giy4RN2AgUf/+LaTchytF5EK1Dkq2E3R4R3YJCWWqQCmCPIy0yrD8nzExjJedPxVdrF+CtQd/oP
	CJcQ1rnd8e9Qfe9TkYoReKjiKHNuQd/9HbtSow/hp3BRb5zJd1OsE8aQ2a1igHtxjiC42xsxoj9
	h4DEqpKpExBeTbIU1FAMDMpcYSH6WqJctSMEvbNvi2huWK9uXXX7utBuz5zU2QSKfF7xNZ7C4Lx
	Yj0tSjaJw3JSZGSKzYA=
X-Received: by 2002:a05:622a:8c09:b0:50e:41f3:6467 with SMTP id
 d75a77b69052e-516c545d431mr6709461cf.12.1779357337839; Thu, 21 May 2026
 02:55:37 -0700 (PDT)
MIME-Version: 1.0
References: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com> <20260507-gmem-inplace-conversion-v6-21-91ab5a8b19a4@google.com>
In-Reply-To: <20260507-gmem-inplace-conversion-v6-21-91ab5a8b19a4@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 21 May 2026 10:55:00 +0100
X-Gm-Features: AVHnY4LC3YVKsMDpMvqn3oyglyq0u9QSInerrEQ0lx4kHSFYhrJCi8Ex_c6F6eo
Message-ID: <CA+EHjTwrygfMrZZSw4y7-ry8fidW2x0C7iuF2Q=dnPNHUmNtUg@mail.gmail.com>
Subject: Re: [PATCH v6 21/43] KVM: SEV: Make 'uaddr' parameter optional for KVM_SEV_SNP_LAUNCH_UPDATE
To: ackerleytng@google.com
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	ira.weiny@intel.com, jmattson@google.com, jthoughton@google.com, 
	michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	shivankg@amd.com, steven.price@arm.com, willy@infradead.org, 
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
	Kiryl Shutsemau <kas@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7D28D14000A
X-Stat-Signature: rxnyp4z7yz8pprczygx6ap8jpj518xnt
X-Rspam-User: 
X-HE-Tag: 1779357339-80693
X-HE-Meta: U2FsdGVkX18x7RcF5I/OooKj3SChCc0CasFZmHl1W5a1SVkhcK0vDuan7Ird/6RrYpebghKrO+IU5cySM8INujcWzo5wKgrcM9nRvOJS8Y6dtyuyP2or1Lg3tRjUzZRDie0I9+Z2StArWvFN5DYlwD0wuAw25KNe/t1fMiWES8Nj2nDXGJGgbStQmqebJspuHx0y+SCRm2YpkewxgB4HsehpfQj83UqT7nYoLRky+2z1mWoupyyMVspKtq28XUDPD4OQBe/dYoUhfgT2sh+sowLKkv0PHom49MZiECSnYfYvITJ4lmTaiPlHjx0nloNJhrJ+zIWC8nDjOVHuVxhe9aP+1fQQdUBwF3FwJHbPzO/tEwxFAMfbZm5Eme4RRvMWtw4vz4G9+4WqgiQCWVYyt1VtrSgwa+SZzKZPHfa4Bq0A8Y5Py6p/akwYzkFnPcC5Qh1xTKnsT30amIS2v1AE3Eibuk7YfoGttJflmGZRRunTFo1HwPiZECQYISGspWDqBNOmXLtkbdjhJZKIju3yxAGhpz4oHdGxAon0K3q3NoushyQWQK90H8I1KXoBYBASythoENPlwoW3vzz0vGelu3ziRDiknLSlL3ya2OdAYPHNDTylEa3vc2wHMp1uVPClQ3macFXU1SVU0FN5wvJThvtK90EIbINssvx7mkhOHZdo9iZxa86KuLpQ/SYUmg6O4Pyxi93hCiFsDS6ME7dNKV6XBPgXVC/Z6XC+E4PmDW5RTJXBEyo6mzRuwQfW2yB8PLRKe72MHhmhJuBQzSZ11EcwKjVzY/XxCM9Gu3OOLtH+20ZYsXwPXe4owWeI8JMSLlh5BSvi0/YkQOkH5c70KhbLOKUuLEVwvbZAiSDg4w/Qf6etL1+roj/xcwJaU7aauAP/ZOLagaOusg1iNT57SDQXpCCBSSH4/zrDDtpdjzJz4CspTsDoIAVY03HrfOxuATJiRFUSu9F+FjyH5N7
 54h1C2lk
 Kq4XAHHocIrdnlPPUEB+bTzqtC66245ufXauczBka2sbe/nwAJ59ESJsKYYxgLWMRwh4jrbjaXbQTRLh9YwEvfhgaDKrzAWpNbX82H/srvq3OHHzRuoXamKkBKL3E9cY2D2UudwCmAARFnnCASDBTC5rpFq7P2x5oHtE6N5u4HcIClD23I6sZQwfeo40mFxHTdSUTuyWm4PLMVxTf/UOlmly+srsdOX/RLlO5D3kQWRCpiYkOh8L7rmOQzl04e8yUh5ydNdER2DajFDuZPQhccXV7qjZY19aLmdeluWqZrj+lLrKnh6r9sO4CZUY/adBNwcRy46hZG4mNhZszHRn4wm5tDnPJmaGjBDKLfXkS5VV9RURsgaVC7mowPAV75JErDeTRaBUCA1B7Jaxesuv9wJMv0/vPUivBVgXk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Thu, 7 May 2026 at 21:22, Ackerley Tng via B4 Relay
<devnull+ackerleytng.google.com@kernel.org> wrote:
>
> From: Michael Roth <michael.roth@amd.com>
>
> For vm_memory_attributes=1, in-place conversion/population is not
> supported, so the initial contents necessarily must need to come
> from a separate src address, which is enforced by the current
> implementation. However, for vm_memory_attributes=0, it is possible for
> guest memory to be initialized directly from userspace by mmap()'ing the
> guest_memfd and writing to it while the corresponding GPA ranges are in
> a 'shared' state before converting them to the 'private' state expected
> by KVM_SEV_SNP_LAUNCH_UPDATE.
>
> Update the handling/documentation for KVM_SEV_SNP_LAUNCH_UPDATE to allow
> for 'uaddr' to be set to NULL when vm_memory_attributes=0, which
> SNP_LAUNCH_UPDATE will then use to determine when it should/shouldn't
> copy in data from a separate memory location. Continue to enforce
> non-NULL for the original vm_memory_attributes=1 case.
>
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> [Added src_page check in error handling path when the firmware command fails]
> [Dropped ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES]
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>

I'm not very familiar with the SEV-SNP populate flows, but it looks
like Sashiko is on to something:
https://sashiko.dev/#/patchset/20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4%40google.com?part=21

- a potential read-only page overwrite, because src_page is acquired
via get_user_pages_fast() without the FOLL_WRITE flag, but is then
overwritten via memcpy
- an ordering violation with the kunmap_local() calls

These predate this patch series and are just being touched by the
'src_page' addition, but if Sashiko's right, these should probably be
fixed sooner rather than later.

Cheers,
/fuad



> ---
>  Documentation/virt/kvm/x86/amd-memory-encryption.rst | 15 +++++++++++----
>  arch/x86/kvm/svm/sev.c                               | 18 +++++++++++++-----
>  virt/kvm/kvm_main.c                                  |  1 +
>  3 files changed, 25 insertions(+), 9 deletions(-)
>
> diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> index b2395dd4769de..43085f65b2d85 100644
> --- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> +++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> @@ -503,7 +503,8 @@ secrets.
>
>  It is required that the GPA ranges initialized by this command have had the
>  KVM_MEMORY_ATTRIBUTE_PRIVATE attribute set in advance. See the documentation
> -for KVM_SET_MEMORY_ATTRIBUTES for more details on this aspect.
> +for KVM_SET_MEMORY_ATTRIBUTES/KVM_SET_MEMORY_ATTRIBUTES2 for more details on
> +this aspect.
>
>  Upon success, this command is not guaranteed to have processed the entire
>  range requested. Instead, the ``gfn_start``, ``uaddr``, and ``len`` fields of
> @@ -511,9 +512,15 @@ range requested. Instead, the ``gfn_start``, ``uaddr``, and ``len`` fields of
>  remaining range that has yet to be processed. The caller should continue
>  calling this command until those fields indicate the entire range has been
>  processed, e.g. ``len`` is 0, ``gfn_start`` is equal to the last GFN in the
> -range plus 1, and ``uaddr`` is the last byte of the userspace-provided source
> -buffer address plus 1. In the case where ``type`` is KVM_SEV_SNP_PAGE_TYPE_ZERO,
> -``uaddr`` will be ignored completely.
> +range plus 1, and ``uaddr`` (if specified) is the last byte of the
> +userspace-provided source buffer address plus 1.
> +
> +In the case where ``type`` is KVM_SEV_SNP_PAGE_TYPE_ZERO, ``uaddr`` will be
> +ignored completely. Otherwise, ``uaddr`` is required if
> +kvm.vm_memory_attributes=1 and optional if kvm.vm_memory_attributes=0, since
> +in the latter case guest memory can be initialized directly from userspace
> +prior to converting it to private and passing the GPA range on to this
> +interface.
>
>  Parameters (in): struct  kvm_sev_snp_launch_update
>
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index c2126b3c30724..bf10d24907a00 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2343,7 +2343,15 @@ static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
>         int level;
>         int ret;
>
> -       if (WARN_ON_ONCE(sev_populate_args->type != KVM_SEV_SNP_PAGE_TYPE_ZERO && !src_page))
> +       /*
> +        * For vm_memory_attributes=1, in-place conversion/population is not
> +        * supported, so the initial contents necessarily need to come from a
> +        * separate src address. For vm_memory_attributes=0, this isn't
> +        * necessarily the case, since the pages may have been populated
> +        * directly from userspace before calling KVM_SEV_SNP_LAUNCH_UPDATE.
> +        */
> +       if (vm_memory_attributes &&
> +           sev_populate_args->type != KVM_SEV_SNP_PAGE_TYPE_ZERO && !src_page)
>                 return -EINVAL;
>
>         ret = snp_lookup_rmpentry((u64)pfn, &assigned, &level);
> @@ -2390,7 +2398,7 @@ static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
>          */
>         if (ret && !snp_page_reclaim(kvm, pfn) &&
>             sev_populate_args->type == KVM_SEV_SNP_PAGE_TYPE_CPUID &&
> -           sev_populate_args->fw_error == SEV_RET_INVALID_PARAM) {
> +           sev_populate_args->fw_error == SEV_RET_INVALID_PARAM && src_page) {
>                 void *src_vaddr = kmap_local_page(src_page);
>                 void *dst_vaddr = kmap_local_pfn(pfn);
>
> @@ -2422,8 +2430,8 @@ static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
>         if (copy_from_user(&params, u64_to_user_ptr(argp->data), sizeof(params)))
>                 return -EFAULT;
>
> -       pr_debug("%s: GFN start 0x%llx length 0x%llx type %d flags %d\n", __func__,
> -                params.gfn_start, params.len, params.type, params.flags);
> +       pr_debug("%s: GFN start 0x%llx length 0x%llx type %d flags %d src %llx\n", __func__,
> +                params.gfn_start, params.len, params.type, params.flags, params.uaddr);
>
>         if (!params.len || !PAGE_ALIGNED(params.len) || params.flags ||
>             (params.type != KVM_SEV_SNP_PAGE_TYPE_NORMAL &&
> @@ -2479,7 +2487,7 @@ static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
>
>         params.gfn_start += count;
>         params.len -= count * PAGE_SIZE;
> -       if (params.type != KVM_SEV_SNP_PAGE_TYPE_ZERO)
> +       if (src && params.type != KVM_SEV_SNP_PAGE_TYPE_ZERO)
>                 params.uaddr += count * PAGE_SIZE;
>
>         if (copy_to_user(u64_to_user_ptr(argp->data), &params, sizeof(params)))
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index ba195bb239aaa..3bf212fd99193 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -105,6 +105,7 @@ module_param(allow_unsafe_mappings, bool, 0444);
>  #ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
>  bool vm_memory_attributes = true;
>  module_param(vm_memory_attributes, bool, 0444);
> +EXPORT_SYMBOL_FOR_KVM_INTERNAL(vm_memory_attributes);
>  #endif
>  DEFINE_STATIC_CALL_RET0(__kvm_get_memory_attributes, kvm_get_memory_attributes_t);
>  EXPORT_SYMBOL_FOR_KVM_INTERNAL(STATIC_CALL_KEY(__kvm_get_memory_attributes));
>
> --
> 2.54.0.563.g4f69b47b94-goog
>
>

