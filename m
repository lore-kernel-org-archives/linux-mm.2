Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85533CDB466
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 08:11:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74CF56B0088; Fri, 19 Jun 2026 04:11:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FDBC6B008A; Fri, 19 Jun 2026 04:11:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5ECAD6B008C; Fri, 19 Jun 2026 04:11:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 39D416B0088
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 04:11:20 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B2A1C4039A
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 08:11:19 +0000 (UTC)
X-FDA: 84895942278.05.EE06F35
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf28.hostedemail.com (Postfix) with ESMTP id C6051C0006
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 08:11:17 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=wGi3FEOB;
	spf=pass (imf28.hostedemail.com: domain of tabba@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781856677;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iM+8nrvlghRqxLR5gEfhNSNnyjY3ZW8GVmgYtfXOYBs=;
	b=5znIRP2JLXYcxWuuo1IRa0uEXzC40c201VqApch5NRnhCC40wU2IBket4cJEjWWtG/VlUo
	FFAWRrCUyyRDnmk6THBem2HmTUxel+2dmkEFj17pc0lmth8i2f4ZQDhYl3fSS58geFXJZD
	icOo2TVl1FwNhZn2drqfEOyyJC4inx8=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781856677;
	b=TK39a3wivDe11nAK+g/zMttKxISsMY3IK7Z6+jHVRmPZC1nGa7T/DsFpojsMnmGhXMVzfR
	uSQW576TpVzRkkFsAySCmATNbXnHH3pVXi2lEdgMo0P0U7RUR99vGlh4VQCC/JNhEbtVPt
	6h5Y9CyZ0Nkhmrg6vmPA+sHjE0DITQk=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=wGi3FEOB;
	spf=pass (imf28.hostedemail.com: domain of tabba@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-51765531803so193921cf.0
        for <linux-mm@kvack.org>; Fri, 19 Jun 2026 01:11:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781856677; cv=none;
        d=google.com; s=arc-20260327;
        b=DiBkbTZ4tRmqO8E/FcgwsilbitemcxRCwmrsc5u+ZZ6YKmIOwS4jo1jiEdstSwdK5E
         +X/7Dc4Fz47Gwd7QtsBgfJxwTjrHIus8Qm2XchdIygbcKYsHkY3QPP077oI7P+X5IMnr
         oZgmCLlfwo2jWMhkcA6x3SHHAwXzou7Txeck/cJ0sho4Drxj37CelcJrUgoVzx+k9LqF
         19jxyvnrlg60fYWy6IrDGWtywxBJ/2LMa1sE14CW+KSBY6Ps5LbMHsLcndLjVMMhly8a
         UJG/fUXKnCn5Bn1Y7w9/Pgguu+mXjwa8Cao3HoqSW/D+mcxQX3ALRuOVLSVZqsvgst9S
         yFqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=iM+8nrvlghRqxLR5gEfhNSNnyjY3ZW8GVmgYtfXOYBs=;
        fh=CMYdznZTy1L0R3x0KbhMl+gLqPO2v7NecSIYm2I77zw=;
        b=okxskh2+PoTqJOwfwuhML67UgiHKABmpqRIeQNuodcclNKCH8zKmqomla5JhnRCk4w
         33wykLdCIdyxLVWdy+w2SCxHi9K0VG4keMwwe9BW5j6XEDLTgBNCIknuTaVEnUD3dSZu
         hjuJIP2aAI+rfNu1eJKegh/T+cvfAqVDo0XaNYgE3QioDNB8GDZgSKDIqs93Ex0we1IW
         GWdm8IwTFFDKPp+ILyyPrN9wZCHIdWzY1m3yzUHSYS5s3UVmmar4L4PgQFMP9uPMuB+h
         T6QTxh1yn+M5v8f07ocR9Lmu12rD6a6noBysXtRtcQODscmYTOvQBkGMJnVCFXOoFObi
         gDZw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781856677; x=1782461477; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iM+8nrvlghRqxLR5gEfhNSNnyjY3ZW8GVmgYtfXOYBs=;
        b=wGi3FEOB2T6MQBWV8MkmrFNMX3fWi3LwQkFTW5IdGJwdrTY25nc/FGMaGoveEfORQ4
         lyVCHg2jMJEj/r141DvBikiXnIgMvd5pLwYVutPVvQDGVG7Ib26jSGkK8NQjfRu78KTL
         Oy7r9ANBeHzmaV/mWX9HYICmyaiSdgwSSHh4f9WR07GDzxEbRZ21YZYL+OlC0YOCFzcJ
         mw0lI/FclhdYXg4wgXgx4CKL+kDtsVxGoY6w7jLgtGXBtdVwuzquggj3CPVluB6rJzFk
         FWLiQQ6TdwzXPqHWqy3xzMjt8scEE/irFFXJmkYXUTxI51tGzITNUGqnW+J/OuFzrbP1
         iQyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781856677; x=1782461477;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=iM+8nrvlghRqxLR5gEfhNSNnyjY3ZW8GVmgYtfXOYBs=;
        b=qapiCxmDBEGOmG3WaytySGGat+NcSeM0CdDWx8h0e8tlTqtWU+p2T4vcayG4LZkroO
         dd21bhWceIRWjAWq62+6xVhaZf9W3QhrodNGcKgTWePxG1BwUIHYjAmvttKKGaUPYd7M
         5L5QpD3z88V8oXyPTdNmfT2ifYUvsHDsVMYyLa6Pn/0V386C/aSmoFQIy1nRLq6R5UHh
         Wizb7grQ2Yi3IBlmCIikPW+4NOBPVy51NLKsT4ZBL3wtdyzg23kPgB6DKamFljRsu34A
         FOpuqW1ceCfmcMqFZnCfxODfszWRCKg1sZrx1+f6APh+IkclJ6L3WKbrJNYNiSUq3TLE
         WfWQ==
X-Forwarded-Encrypted: i=1; AFNElJ/96LUUwlXwWdiG2w7zBLxEhkEsyCZqjiGrHkrwIbCqiPgeOb7APT0bKyMqzErw9Ifk46nWX0dDKQ==@kvack.org
X-Gm-Message-State: AOJu0YxKG14g6y86q7UMbn9zIoD4Nv8MZ7ZAoXIoRvIW8j7VJYaQFsWW
	TRuR2+iZApVyThYoHLXN1jhFdcK8z4f+3dB88unTlj3ZNVfbqdHmUKednlCtKBe4hqpggsxPywE
	PzbjE9LPY05vJmWSgT9Uf0Nw5kihqhophEbyltR8P
X-Gm-Gg: AfdE7cnqEurq7PzIZKIvl+V4krTIXucO1dPELLN378AGcK/TbC5YEr5s/6iS4aAMhHI
	UmwjtFKF9Gq52My0hdASQYqH7Zl9Rt1KIpbBIcnl2P8p1Tqp7YrftRBNzq8QIEnR29rFpTSta4l
	ty05IjqKBgef77FtmWXIhLvtMu04H7Q7Fsmd92XfQ4uUMjkA/oMApCRV5B41XUIr3FxNOiaaJPO
	LspXhOFt+6356ndXjtMZJuXCxqg0PCkm5EGfRjw7x/H5R0muggsWJm6HByp/XLF2B6pw7hdHw==
X-Received: by 2002:a05:622a:191d:b0:517:38aa:c2b3 with SMTP id
 d75a77b69052e-519e48d02b3mr6024501cf.14.1781856676299; Fri, 19 Jun 2026
 01:11:16 -0700 (PDT)
MIME-Version: 1.0
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com> <20260618-gmem-inplace-conversion-v8-4-9d2959357853@google.com>
In-Reply-To: <20260618-gmem-inplace-conversion-v8-4-9d2959357853@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 19 Jun 2026 09:10:39 +0100
X-Gm-Features: AVVi8CdHX5FmAYr_l4a3mgee9sp6dg3wXgxt_dR1E7cWLhRy0b4A0kukfNDJw2g
Message-ID: <CA+EHjTxT9tcPk4HtyPXs1eo0bUQvwf3=G7P8ZTfJhDpXNm=ntg@mail.gmail.com>
Subject: Re: [PATCH v8 04/46] KVM: Decouple kvm_has_arch_private_mem from CONFIG_KVM_VM_MEMORY_ATTRIBUTES
To: ackerleytng@google.com
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, willy@infradead.org, wyihan@google.com, 
	yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org, 
	suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: C6051C0006
X-Stat-Signature: wowwwt5ie38otte6x986xphkcnr3xsqf
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1781856677-34887
X-HE-Meta: U2FsdGVkX19jpKhi3+yULEP5+3m4cLYlYpvfLnwbF8jHAyGlh4QDq+jP8iyHqmfCB/y9UYMWtwRj5LSfNO0OcqtEcnsRSuR4w65XMhE+LVI8I3LMLLtg0J6AOST9/ivL9ZLmPHbZaSejRoMDFqVXIRTYJxwiNVwtZ/Nb8+Z0Iqgtl2mtYEd7f/pddpksC8lN0Z4dUyOY49Ae9lGAvSy1okQ8l3IneIiTcbt4kY+3S4Y0Zu/7aDw5ILrUln6sGeDhEepoObpI5bRLKz6LOpo3wuNeNkFAhUecQOsutfkGLiqsvtWDCaFXHGU4uoHuD7paFGLVILFmmSNMFHIZw6hl8bNgusjrjLvR5BqQqX2YE1RQ+Uz7H/ctWCccukfQ0WFkOLYLWapmIhjuOlYDEaAD0+/8Zxih2+AcCzMusRykLKLogby0+M6BiNa437JvfDtS0UoeADKLap7vYb31COMn72W2cFqkK8lB0le4jvNYbDQA/VwfclVx9rmExHaQo12w6pN/FChDzYlISGDKexT7qjsUpJ1Off0wHPK8xCo2MFGBfqyxsVgdGbhH60sblzUdC7kWVc818t1fNXM5WzqrxD83kUbn6eTeWYDcWPX9xPngM1IAO4frqnOAMSFyC8Zlh6kcicfO9JPanRRhDVNcUiTy/5mJpQcyRnUZKy4P7amDdlzNy7zo2Dg/zYERi77+akZQmWzxNn/F2Iyk755dlUn3Rv3j/io9ZlAFgj7FkucOB+5GxcOYQoCZk+JTPlZOiVv1iySOffpv62JEYcvAbEcNPt7xkigwyZ8VOGQPNBYreDdGOCtPFJNpQGZdeiGiHy0iKaArWTjh+y1sgU0DOJoLH63a11VhjZPGptWEu6kj+5WbV/2IESYP6osmHv2PcEn+fqtCdoqZuOV7E9W3ysmDTQrn8CgIDDDqQxVkdFupLMpT59G3s8kmRTzJZJFk88kA59XCuPCSWkE4Rwj
 bd6ouL0Q
 QNpXdQ9qRg7hgh31OM/Pu3C+lzP5NcvSTYo32GpwdtoRNYcT7dOv+4FR27+BZ8RxcI+OtiSQmFFsGYaaaeQNwAPd2HCenL4VjKMj2Flh8eM5Em3ywK2yO+cb4GyIOSCE0iINyCvYme2v1wc5mk2Qf2IDBo9fICVumVeTzZ/3wRnI6/ukgFZz5Pc+RrWbU1BytfnNb+WLUudL8XBWQ4v7XaWbzlUhtcwYLaY3MRIi9sTetvdwE/wNRBNH1BNIvbF0xF+3u83sTQj8qNdmKA2Na4eqDpmwrKRX4xeaRCKfq62o0QIEQ5P99oRkvS+JmZO0mq7X80MwohXTKIGU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 19 Jun 2026 at 01:31, Ackerley Tng via B4 Relay
<devnull+ackerleytng.google.com@kernel.org> wrote:
>
> From: Sean Christopherson <seanjc@google.com>
>
> When memory attributes become trackable in guest_memfd, the concept of
> having private memory is no longer dependent on
> CONFIG_KVM_VM_MEMORY_ATTRIBUTES.
>
> With this, on x86, kvm_arch_has_private_mem() is defined if some CoCo
> platform support (or the testing CONFIG_KVM_SW_PROTECTED_VM) is compiled
> in.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Co-developed-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad
> ---
>  arch/x86/include/asm/kvm_host.h | 4 +++-
>  include/linux/kvm_host.h        | 2 +-
>  2 files changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 8e8eb8a5e8a6b..1bde67cf6eb0e 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -2394,7 +2394,9 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
>                        int tdp_max_root_level, int tdp_huge_page_level);
>
>
> -#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
> +#if defined(CONFIG_KVM_SW_PROTECTED_VM) ||     \
> +       defined(CONFIG_KVM_INTEL_TDX) ||        \
> +       defined(CONFIG_KVM_AMD_SEV)
>  #define kvm_arch_has_private_mem(kvm) ((kvm)->arch.has_private_mem)
>  #endif
>
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 201d0f2143976..d370e834d619e 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -722,7 +722,7 @@ static inline int kvm_arch_vcpu_memslots_id(struct kvm_vcpu *vcpu)
>  }
>  #endif
>
> -#ifndef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
> +#ifndef kvm_arch_has_private_mem
>  static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
>  {
>         return false;
>
> --
> 2.55.0.rc0.738.g0c8ab3ebcc-goog
>
>

