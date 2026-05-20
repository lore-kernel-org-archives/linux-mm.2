Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A08DDCD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 15:23:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB14B6B00E8; Wed, 20 May 2026 11:23:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E88D86B00EA; Wed, 20 May 2026 11:23:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9E9C6B00EC; Wed, 20 May 2026 11:23:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C957B6B00E8
	for <linux-mm@kvack.org>; Wed, 20 May 2026 11:23:33 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5DAEE1A035B
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:23:33 +0000 (UTC)
X-FDA: 84788167506.20.DA45071
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6F57310000A
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:23:31 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=k4iIGKjF;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of tabba@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=tabba@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779290611;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6WbZMU4miMiF9vdr/q40hrIlWLS/zCvaA9/R/fFQvCg=;
	b=IBKWMMFRyy/WXHf4653VqcUbKa2SXcmEixG7v20hLouPfYoDf2efzW+5D+0QGelw5gm2iv
	czdDOo5yZCeOd231Mw7h3u29z9RxunHa1DAigoigOxMB6om3jnZ/IphUaj2HVSzFsn+Br5
	rkiEPXfsnDrEvFtPAc3zBDk7/INdmb4=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779290611; a=rsa-sha256;
	cv=pass;
	b=f7x9XX8krsUnQNtvO94OqVhFPo5uOjdXt1hMcDDlul5qmXNbUsi2i9NcgDSOSuUbdifqOf
	gXXkS069RMqddEmSW824qW1Kh5FBoynj8y0yqw2B0gsh+141reKzbZ6hbOKW/0nsMJrmpt
	TD/4wQRaaGM7LbRfOrDmd+4ebuhwxSI=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=k4iIGKjF;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of tabba@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=tabba@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-50d864c23bdso23601cf.1
        for <linux-mm@kvack.org>; Wed, 20 May 2026 08:23:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779290610; cv=none;
        d=google.com; s=arc-20240605;
        b=X7tMGlFCZbAQDHYaxzEvUnYW0pym5P6R6XgzFl9M8wi11FvruIziS8IiEQfxr569UB
         WQehw/xFrQvcmxFUZNs5dBnG1qtDWmSTfN1eKwj9cO+LgV67oqwf2qVWlKV0h8KOUgeh
         zqiPhYINLBo03jwCMBY8HNoxo4Od0ZAbhQATqpEzUbnhSKYutmbLK10G8ObISct6JWyB
         aObS9aKgND5KKcSI9UapC+naoWspUGsxuR74ar5jmjoIYYq01KKA3DRTMUSDisU+GR+R
         vhsmXdLdZgO9zoOmlEypRMOxtRyXdI5j6zYXpefmxMcPVIFcgZlHP/v/+uHQuZb/JqZh
         8XGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=6WbZMU4miMiF9vdr/q40hrIlWLS/zCvaA9/R/fFQvCg=;
        fh=1eal3ysakaAYPWLqAmo78XJnp9MyE7vAQNRdzXL55v4=;
        b=VgAdQgBxYu8tWGbRJLljEkLfdfSUD7vJceqmIXpxaJUWkhu/1msBOgqa4LipI8wf6H
         zhdV3Os8QzOxe5N12Z+WsaumqOrymsMSbi4wQECg+vZIpwz8xTFE6ysNk9tofUU/M4vi
         ssfQwNvVbD/Pkh5kuwgLMFQlFKfEpze7eMOSHj/pQ7DSZmeUdiQcxw1TDn0EtXY5/nsF
         dTGg0otyr8fIWoToH371kzpneeSCiQ80UA6tuP1KREu+7glShTytJDBaZ8JVhlr2LgKl
         1Zy4E+yNEui0LaALxh3hqZ1uzsWe4FcEh4MyTP81z/5eIXvIjxez53B/peR/0VNz6vGM
         KlYw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779290610; x=1779895410; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6WbZMU4miMiF9vdr/q40hrIlWLS/zCvaA9/R/fFQvCg=;
        b=k4iIGKjFZ+IjQPKdMTs+rEmV3rDWHpUqvNl242BBHkuc8IG6KnqQMEPPwDuGCorfVr
         sDboZFbwmo/8GyNTNx7IoO2VteqidU8aimMALTRo3yN1rMGWs/43vez4+6vP0eWmGPmO
         Rztez99Ten0sX03+zg7WBqQH4Q2UpLjcENvPaUh/WMYnlZZX7oSP6Np+tvKYLoOW/20s
         73xzUPWbmN4P5TmDeMyVPGb+QxCIseo/xPYaNGgjoWR3khmDzF0DpnR9ByAmUc97z/Th
         46LT/CjRpwUBKwYUXkYHnhJxgu99/D/qGl2gGwnmAJXJlfc2/2/h4+JPu1QdRv0LJM46
         TqSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779290610; x=1779895410;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6WbZMU4miMiF9vdr/q40hrIlWLS/zCvaA9/R/fFQvCg=;
        b=OJv2jsbIiHCNSLrF2rA/25jBNz10NPp/M7CDU4JsHiTzEGbKxrQzgfBFm6FelS9iay
         I5G3iCSNQ3EFi9WllFmzmdBbgcj6JaatYasOjDErW8IR034hS78LEWNSWDsP1812vHQP
         KezZGNTuwJ4dKa1VX5GhzzU4M+vxS2Zl8w5X2/Mvea6CjMY73cuMKDt+LZ+1k9PBTPUg
         hUtClGyGO2uZtzpvYjDYLOkUrPOLqd/DTVlhm0EETU+eshyBdknDfvmzkoQgzh6B+rBj
         +mqensQICCuJMZhHRkvAbtxUtL5YZQ/gJGbYr2WphQYlItUMsQ19g5/1rAVqDU7bTfdd
         ng4w==
X-Forwarded-Encrypted: i=1; AFNElJ+kePTrL3TFPS6w1oMI+nKWCqlkFX9NbquCXTQowB6vdXywdoUHsCLYkIm9eX3HMDTN2Z6JB5dsQg==@kvack.org
X-Gm-Message-State: AOJu0Ywf8+TJz/awW3GMColhcw8WDlsKBfZa149FOwjjvD2PMhch+x+n
	/DCDjB+h9RN79cDCuvsVJE9BaCOn6owxp514Ijsuxt9kbNBH6Z6HSb8c8OjaWv2HBSa+E7oPiIB
	2/ZGCaFY/D8v/qNNIPG5R2WnCY8vGKLN//sh0u2sf
X-Gm-Gg: Acq92OHwv8vtjciChb4T01Yi2A8/hovkcAF43Qtgs06FHwaudd4FVNMuOzush4l4LkF
	eMr+PKWnBzE9OwKJF0q0S4+gomQBfyaeaexcYR22+agVXImlp9+NexqfEgi98NsWBJKYj6Is2P+
	dds1AUc1Pq2J8Eb48TeE+fiyAmfRNUyB07bERgqNZbjQaNkoRK9EQDQR45TcOlxACzpgzSkI5B+
	S/r5ddTCBfps+281iNGytv4GWKktkII5iUVp0j1uMCJRf1Gz96/IPgpKjv1JopAIfNiSGma/f2a
	jl6Ik3NElB1BRyImgeQ=
X-Received: by 2002:a05:622a:900e:b0:50b:8d3c:5bd7 with SMTP id
 d75a77b69052e-5167b669c3fmr40334771cf.9.1779290609929; Wed, 20 May 2026
 08:23:29 -0700 (PDT)
MIME-Version: 1.0
References: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com> <20260507-gmem-inplace-conversion-v6-14-91ab5a8b19a4@google.com>
In-Reply-To: <20260507-gmem-inplace-conversion-v6-14-91ab5a8b19a4@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 20 May 2026 16:22:53 +0100
X-Gm-Features: AVHnY4LJuKw2B0K-Cm-8YOXgihnw0Pgc0Lt4U2X1C7F6RPo0tjkQqSgizt_3rx0
Message-ID: <CA+EHjTzf6Bc_YgSNv0d+Rm=ALuwYuCaS=EPhrjFKDes8=+0QSw@mail.gmail.com>
Subject: Re: [PATCH v6 14/43] KVM: guest_memfd: Advertise KVM_SET_MEMORY_ATTRIBUTES2
 ioctl
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
X-Rspamd-Queue-Id: 6F57310000A
X-Stat-Signature: noh3p4st7dxfizfpqb6tzg81pt9eucub
X-Rspam-User: 
X-HE-Tag: 1779290611-869315
X-HE-Meta: U2FsdGVkX1/rnFYjgUYgeq+FleliDTjDbENTjppDby6QEVD4ea/DVqq9u88/NtpN8tuQH7ilMnRY/CuQtB9Lu736F125ByFxm66zM+EAjZCezVwRosG+3+sJqSEsN2iqKHOwpb1r7xFGB9NCVz5gVrp2P/667CEZCmhJObi/H51ugrbNN63SogrLJIw8HDztngcbdU7cAOkm05zDASpdPUU/G5rSWhKiQSfZ0iWo+nwF/+EI2+dm4Djb23NEhWmADQzCUuT4Y+5ovfgT7wp4cayzgwgNiUJkYK+GBkALaeJphHGrwK0JZE9gA9S828VgGfMg9yWXhPcGM/O9q+CFsRwqqcTHUbMJ/4kD97kcCddDg+9VNeYzZ0uR2Er+bkBzMrFspNbcrQGzPU/JY0YF1pQZwQbslRT60yBNOjjtccV02J9+z0muh46TxsSKCtxXOTZ3nfEE+AZ0nEfNoS5uW3vPVuh3osfHcXuHzQLzFwXY2yiOil+Cv5s9xijxYIfbWcroy81AF6NUD0qxWq/sh5/jEtqkiNEB29cRWQJ44jV3h1pZkWS8cDMsMZQ7p3vzm+W4RXOG3Pf+wJnDKbiTXkGvLeC9IrJrdf/KcPL/1v6WofLk6Y3xTNxJCX3WSfey54pEbxPlPMVH/boFUpIKmV4pRf4ynGkp7KC3KMJRLmHI0rVdI0CwNw01GwrtW7M44bv4nkQ1AlCbyPF6YP2SIxlwZe2IeZtrhD6A1jwqIXV/Nusj+SX0Un2UgBwSTR93waD3BJqMeKo7B/YOBmSXAz8xZkzV4FZvZpfxVZGTMaskMjVKHZYSO8saINIFj+EEL8dn3Xlq96uTZPxMc3s/7VY36UW4EMFbf2R0LGf5iAI/hrtOlcHuKrXTmPOTElA1rnHyX/9WAeldVefLV1sHUBWYabDKrPhDUxD5fSpl4dmR8eA02PAHPF/ANCEea0T2l3FB+eVmhFb3DhAxYig
 Exvs4/cj
 oJrDziXjfIUPlD79ASO9dPbPfnTd/KP9+AvQeEEu3Kj5Pv1BJYq/xYGIUW0IZ6IYYZ5gHB7P+fkR+N542E/jssYTtVgqWjOfKkTmqbkncUjlAPooQw16DZSOj9Mh8kI06Xe19R9VHBt+4tD5TiD8qUVvUJ/ipEBfyuSxWfGJMgWE8DHZ4B6JtQAdthHHBVEhAB/7FCWZNrt+8Y7at7XO8NPSqAkinrMpAFjmoAwEhDCleXjZBSqonVTNyR47CbKsyw69eIsXqib0M6jFPyJL87uiKFMWvAWEEYk21V3OxTomO3O4sRXadY2lmsN8HcZpXC6hQ0M3KCX0XzH7Qlkb/uX7buPJ+ZDFdTuiosS7WN0mkHtZ6PPtPmqzjf1Ewe52ZWK8eYvWhojkeWqXx3FR9c/xKr+wrAWHxlqLRXG3OeAPvMXIizx5VCDEwAA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 7 May 2026 at 21:22, Ackerley Tng via B4 Relay
<devnull+ackerleytng.google.com@kernel.org> wrote:
>
> From: Ackerley Tng <ackerleytng@google.com>
>
> Introduce KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES to advertise the
> availability of the KVM_SET_MEMORY_ATTRIBUTES2 ioctl.
>
> KVM_SET_MEMORY_ATTRIBUTES2 is a guest_memfd-scoped version of the existing
> KVM_SET_MEMORY_ATTRIBUTES VM ioctl. It allows userspace to manage memory
> attributes, such as KVM_MEMORY_ATTRIBUTE_PRIVATE, directly on a guest_memfd
> file descriptor.
>
> This new version uses struct kvm_memory_attributes2, which adds an
> error_offset field to the output. This allows KVM to return the specific
> offset that triggered an error, which is especially useful for handling
> EAGAIN results caused by transient page reference counts during attribute
> conversions.
>
> Update the KVM API documentation to define the new ioctl and its behavior,
> and add the necessary UAPI definitions and capability checks.
>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Suggested-by: Michael Roth <michael.roth@amd.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

> ---
>  Documentation/virt/kvm/api.rst | 78 +++++++++++++++++++++++++++++++++++++++++-
>  include/uapi/linux/kvm.h       |  2 ++
>  virt/kvm/kvm_main.c            |  5 +++
>  3 files changed, 84 insertions(+), 1 deletion(-)
>
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 52bbbb553ce10..55c2701d9ed49 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -117,7 +117,7 @@ description:
>        x86 includes both i386 and x86_64.
>
>    Type:
> -      system, vm, or vcpu.
> +      system, vm, vcpu or guest_memfd.
>
>    Parameters:
>        what parameters are accepted by the ioctl.
> @@ -6361,6 +6361,8 @@ S390:
>  Returns -EINVAL if the VM has the KVM_VM_S390_UCONTROL flag set.
>  Returns -EINVAL if called on a protected VM.
>
> +.. _KVM_SET_MEMORY_ATTRIBUTES:
> +
>  4.141 KVM_SET_MEMORY_ATTRIBUTES
>  -------------------------------
>
> @@ -6553,6 +6555,80 @@ KVM_S390_KEYOP_SSKE
>    Sets the storage key for the guest address ``guest_addr`` to the key
>    specified in ``key``, returning the previous value in ``key``.
>
> +4.145 KVM_SET_MEMORY_ATTRIBUTES2
> +---------------------------------
> +
> +:Capability: KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES
> +:Architectures: all
> +:Type: guest_memfd ioctl
> +:Parameters: struct kvm_memory_attributes2 (in/out)
> +:Returns: 0 on success, <0 on error
> +
> +Errors:
> +
> +  ========== ===============================================================
> +  EINVAL     The specified `offset` or `size` were invalid (e.g. not
> +             page aligned, causes an overflow, or size is zero).
> +  EFAULT     The parameter address was invalid.
> +  EAGAIN     Some page within requested range had unexpected refcounts. The
> +             offset of the page will be returned in `error_offset`.
> +  ENOMEM     Ran out of memory trying to track private/shared state
> +  ========== ===============================================================
> +
> +KVM_SET_MEMORY_ATTRIBUTES2 is an extension to
> +KVM_SET_MEMORY_ATTRIBUTES that supports returning (writing) values to
> +userspace.  The original (pre-extension) fields are shared with
> +KVM_SET_MEMORY_ATTRIBUTES identically.
> +
> +Attribute values are shared with KVM_SET_MEMORY_ATTRIBUTES.
> +
> +::
> +
> +  struct kvm_memory_attributes2 {
> +       /* in */
> +       union {
> +               __u64 address;
> +               __u64 offset;
> +       };
> +       __u64 size;
> +       __u64 attributes;
> +       __u64 flags;
> +       /* out */
> +       __u64 error_offset;
> +       __u64 reserved[11];
> +  };
> +
> +  #define KVM_MEMORY_ATTRIBUTE_PRIVATE           (1ULL << 3)
> +
> +Set attributes for a range of offsets within a guest_memfd to
> +KVM_MEMORY_ATTRIBUTE_PRIVATE to limit the specified guest_memfd backed
> +memory range for guest_use. Even if KVM_CAP_GUEST_MEMFD_MMAP is
> +supported, after a successful call to set
> +KVM_MEMORY_ATTRIBUTE_PRIVATE, the requested range will not be mappable
> +into host userspace and will only be mappable by the guest.
> +
> +To allow the range to be mappable into host userspace again, call
> +KVM_SET_MEMORY_ATTRIBUTES2 on the guest_memfd again with
> +KVM_MEMORY_ATTRIBUTE_PRIVATE unset.
> +
> +KVM does not directly manipulate the memory contents of pages during
> +attribute updates. However, the process of setting these attributes,
> +which includes operations such as unmapping pages from the host or
> +stage-2 page tables, may result in side effects on memory contents
> +that vary across different trusted firmware implementations.
> +
> +If this ioctl returns -EAGAIN, the offset of the page with unexpected
> +refcounts will be returned in `error_offset`. This can occur if there
> +are transient refcounts on the pages, taken by other parts of the
> +kernel.
> +
> +Userspace is expected to figure out how to remove all known refcounts
> +on the shared pages, such as refcounts taken by get_user_pages(), and
> +try the ioctl again. A possible source of these long term refcounts is
> +if the guest_memfd memory was pinned in IOMMU page tables.
> +
> +See also: :ref: `KVM_SET_MEMORY_ATTRIBUTES`.
> +
>  .. _kvm_run:
>
>  5. The kvm_run structure
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 0b55258573d3d..f437fd0f1350c 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -996,6 +996,7 @@ struct kvm_enable_cap {
>  #define KVM_CAP_S390_USER_OPEREXEC 246
>  #define KVM_CAP_S390_KEYOP 247
>  #define KVM_CAP_S390_VSIE_ESAMODE 248
> +#define KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES 249
>
>  struct kvm_irq_routing_irqchip {
>         __u32 irqchip;
> @@ -1648,6 +1649,7 @@ struct kvm_memory_attributes {
>         __u64 flags;
>  };
>
> +/* Available with KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES */
>  #define KVM_SET_MEMORY_ATTRIBUTES2              _IOWR(KVMIO,  0xd2, struct kvm_memory_attributes2)
>
>  struct kvm_memory_attributes2 {
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 4d7bf52b7b717..cec02d68d7039 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4972,6 +4972,11 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
>                 return 1;
>         case KVM_CAP_GUEST_MEMFD_FLAGS:
>                 return kvm_gmem_get_supported_flags(kvm);
> +       case KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES:
> +               if (vm_memory_attributes)
> +                       return 0;
> +
> +               return kvm_supported_mem_attributes(kvm);
>  #endif
>         default:
>                 break;
>
> --
> 2.54.0.563.g4f69b47b94-goog
>
>

