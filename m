Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0FDACD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 11:02:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE9556B008A; Fri, 19 Jun 2026 07:01:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A99CB6B008C; Fri, 19 Jun 2026 07:01:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93CD36B0092; Fri, 19 Jun 2026 07:01:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 70C916B008A
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 07:01:59 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E4B74A0410
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 11:01:58 +0000 (UTC)
X-FDA: 84896372316.02.6B3D4CE
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf10.hostedemail.com (Postfix) with ESMTP id EFA8EC0016
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 11:01:56 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=T5QmitIN;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of tabba@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=tabba@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781866917;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U35NfwEOggAkTfTgF+7yslJDxFAl5ztmZY3G7iS5UTU=;
	b=RmAZmVEous8QGHc4NCRbZLFpYKfgT0TvR0KlDrF1vT/XhmxEY2pybepb0uU8kwtnqRufYn
	5V2TWCnsShIJLeOXnuphwc/X0w8txfOdTwOMMMoWowKRUwc0fpfojMjTTCsolsxs9b1wML
	HL2Lb6usqep1HeVrke5l3b+346jz7eY=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781866917;
	b=IkzULqeu4CZjRimpUcvsNxMrAQaiRJ/BenV/bZPRXnNiCuS0h9bcvmVkiDo25MQymUyE/S
	JkaD4RdFNbRhNx+qoqjdSvtpU+HuMBKnZHolL54E/qf5cFx85s9wCSiIE/C8z6yjdGhZfQ
	gzSEeUUC6dRPt9bXzKZ7MLKZMYedzLo=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=T5QmitIN;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of tabba@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=tabba@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-51765531803so235541cf.0
        for <linux-mm@kvack.org>; Fri, 19 Jun 2026 04:01:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781866916; cv=none;
        d=google.com; s=arc-20260327;
        b=q+FcyML1dF3AwP/YpbIMwF4LHYu7ePLkGemUX3RqZmxiWnerjswPVXPWgdrbauyW8c
         YF74YENWUPm4RVnte0a+E0RPEITwKxWH53Xh174IHU9U1J7+ry2SRqTPL4KqKpX/ZlUy
         tgTY2swr9yqNmi/aJUhJ5AoyNfupkZMEIueSN1kojErh6oPFvQ78J1ng+Vdq0TBiFNE6
         epy8Pn2dafTsfgdLSDE7zHSv1bFPF2cYX+YUl23gyx1+irBs8q77sRsJc5ehE2/Wpeli
         yzmisxQTu2q44Trd24Q3cUeI/0gBw8AOCgzCVxYooR8qTuWqYubF25Ze/qSGRIkioYWM
         x9NA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=U35NfwEOggAkTfTgF+7yslJDxFAl5ztmZY3G7iS5UTU=;
        fh=fjTM5clNFu999KEUyjxJCsx43ycefHF53crXA90BceM=;
        b=QyoMwU3LFnhfLW6cP4vt4mXWtSCpAv/g9WGoJe5WBN0P2P43n+ZD+397gz3qkSXDZ1
         LsGTPQmd50fpG29rv5n9miSglIXTkfjNjYL0bODkuOfwGFEHVrp/zROzhmoU10/V836V
         jiUu64vtMj/1x6l41j0wEOKYJ5bKt9TSZYGXKnY2inpBwZ5c4oqYr7rIxxXtCLMZeU8N
         gEqjC3ftmVCrcL+HzCWjrYt4XZAc+L7MWRxVTcIwk51nxoQXIpoQxcALtnCUWv137YuA
         /5OiBfL/Gu9DKPCajyYd2e+ETs/GHzivV9s5vd7TZi9gXgI3mW43BnxEbT4q+i4Fv64q
         K4xg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781866916; x=1782471716; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=U35NfwEOggAkTfTgF+7yslJDxFAl5ztmZY3G7iS5UTU=;
        b=T5QmitINwsl+v1J6z3HMzkw26xSwkUCc0EGQNl2kDUsBiTAQXh+vdk9kdkJTL3uRr7
         Grf8fOIGMmE5aOwaGT/Vmt8ynoUSq2ZCHT9jZq3uQhfgVEIygtLqZxWvSHEEL6rTv2KC
         Q9cHQAVkt5bNOpi2QNHiY36Sj6yVPcCx8Uf7FUDwXnjam76KQsFQsDHkaIj1Mt96zq/N
         2K8l+hMT0P6USG9hhWo0wbV7Cyyiu6Zgwf3BT1TCFsLyNf8ULxG/KnU7kZFoNZ/Q6rOc
         mLTY6+N1ycziq5s0sKLqtPZ8dVcy07YBtNhKkG/ARMtLMyPs33eCHX9qDAc165wjVEEz
         cd1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781866916; x=1782471716;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=U35NfwEOggAkTfTgF+7yslJDxFAl5ztmZY3G7iS5UTU=;
        b=cPQNem5sybC4UInhXr37By6sjBLHewGH/+rqBvHisdIZhkT8D5JZm4ZahDOqVySb89
         sRnQZeFF0GtG9U7nRSPQGdNKSevZ7nklHWxVg3Sve7cBdtOH2uR0EgBZ4Hzn3kEqUmzc
         QjfsqaQy5iq4jCEErN+YjORK9Got5S7OH5QKyaEwNfUReUkpErGexXDb2lUm8dX1dERU
         E0/bkeqGGYlues+G3J62UwGrAVyoi8dg21a+jUKkO7xAx7fWT2t50KWBnHV1i8+FQS2c
         zlJLENVOWuU/BUgJg1saqhENev6qFx8eJtmJBg7HLMteundGLPDIONdcm6ce4hJNlPs8
         h57w==
X-Forwarded-Encrypted: i=1; AFNElJ/1A81yhECA3ym0FtqSkrLiaRA9JkhClvLqp5CXcjLwElHgJS4jeEKzNAwjxCVqPGd+tuI6LclwpQ==@kvack.org
X-Gm-Message-State: AOJu0Yw0meiK6JHJU+dV/GlWZXZyAtgMMpfLVJG0j7T0GrfHmFfjqjAC
	rUA9Upyj66wRa7pqhxuGZBipW6fGfbMhAsNVh9gn38xRX9A8jF1U7m5VZ1gffeG0gdn28kDMpoA
	68+q5qlHZiyAzJpWrBqR9Ba0MY9D2Q4i3TeUMAlud
X-Gm-Gg: AfdE7cku8CMeTExZvmOPX4cNDzeBxCmgwh8FCalaWRBkTD6PHDXagvrrCU4dYvlS/OB
	XtZdwMLZ3jb6T2jyv6E5go7yDS5zNdgynJZvptH2+jZzSsySdDTukCGFjtjlvo5cpFHMXjGLipv
	cFVez8RuKPmjSPCp56RUx4bCCXEMjf2cFLsQGpbFg7om5QpSjmiGKbs1lAGHviY59SU1NE7AX/q
	uF4PuxfOoFKi5FUx67rhzUle9FvJXXY4EA9etYpV00enNo2BMrnXuDNZwRbU/A6TWdTEedC+g==
X-Received: by 2002:a05:622a:2489:b0:519:56a8:2693 with SMTP id
 d75a77b69052e-519e4a7350amr7631861cf.24.1781866913307; Fri, 19 Jun 2026
 04:01:53 -0700 (PDT)
MIME-Version: 1.0
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com> <20260618-gmem-inplace-conversion-v8-22-9d2959357853@google.com>
In-Reply-To: <20260618-gmem-inplace-conversion-v8-22-9d2959357853@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 19 Jun 2026 12:01:16 +0100
X-Gm-Features: AVVi8CcGOil_aJVBQ43DfPQ1kHXf_SdVHaTxhCHT88DNVFNlliTMrSoTjQT32Xs
Message-ID: <CA+EHjTz3SW50EzxgXm8VysoaM21RReUVG2px_WUYU7zUwjXnpQ@mail.gmail.com>
Subject: Re: [PATCH v8 22/46] KVM: SEV: Make 'uaddr' parameter optional for KVM_SEV_SNP_LAUNCH_UPDATE
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
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: EFA8EC0016
X-Stat-Signature: w4q8uyiiy5quwuspzh8g3rnogt68eaw3
X-HE-Tag: 1781866916-708695
X-HE-Meta: U2FsdGVkX19ZnI5uGies7XFgKCUuP0XI7lQqskOPWWzDKLCJeR6DbWPDfAxjnAP5mn8k692PknwHcqeXYG1+xrSRKzhtFoUcnGkR0d1PmjFMTXza2ootttfblSIAXOc+mQEqIZA7SZhB9ij1EcVxzRhRbe0Z1sZljsmPL9cOUSImm239+Sqs8fTNkYoCgA9dMl0lH0EkMASlkjrGO7g36CsdEVg6gduJ3lIXTdkmfBGZ3c+1Ln6wFW8y2rz/9J02RIp3qeYAFkg+KHMcRRZX0qYf2gwN5aDGI9vmGt9Gj3gl6uHGWg706cwVWVm77EoFRPm9ksS/H4U/ZQY1qB+DvoqrSwGgvyAaVYBZSUBwLsojL/eQRevnjFtwmReljuCcDUo+ZuFxQ3HUsB0zvlaIlf8v3esVY/DPWJUFbPEDjMRsANknfPovE9KyOuo9Y5Uy+JPOl58EBM675kS4dR1Q+uGpkQROZscgdg+sI+WhIfAXYQVIEHj2I6g7fxz2DU7I8y9Onu6/6OSeRbDn1hbDQ3+9/dR515bAm0SjRHm+st11HZ7TNt8STGbvqXORuxotJ+wBvIIY3ANbmm0nudbe5xR/aV2hGZ8kJxQiiLtdhWVKMbls2OJmWth39ACMg+ivUCSdMLolulW+d5u1XQzbpVfaXPbyQNFdcJ/DXZpf8njmKmoWFtmKX5J5w0Uwb922Dz2kT/SN+qr6JQVjyuUR4j+OTgL9T1LOHIr+esfJlVHTBuasxNYp1I3FyaWURKHxX7MBVvANiHE+RaDBGvY1pO7qsyLdXAKI7uvjdcojGMT9NtGmXZPC4VlDUlkhIUJt1p+N0L3YpgEenOCJEr0M5LhBHbTAveIV4pEWuZKzeCR1oadnNVQLShKW1T69gMyh7bndu45uLzssm8wtG5N9qAVWRM7mrLvE0IpazzpvY0f0x72/zocRisrk88Vckllh7VFJ3avWDLk+etG/aU+
 l8VcN9lG
 EKI9uG4VTBjHe662rcMduWubDeefz+zTttouzZnSApWgCzXSPwfTWuoq/CGMfKNX9mXZ2aUzzj8BhW7NFn4zoGvA9j1X6wjI6TducAUf2BoUJptfOeJ6kxCk4yFHJVBHi/S/AJ2BEr/4zdyCsgBVvzqtPcbe9BuL6GQCdjyTfYQRQtc8cRjm4PgJst8owk7aQH1MZkIcggaaQt6bKja7OVDxN672ftO4JHWxZv855QVxYczWxVVATXIB+1LaMA1EbQODfcayLw+DmNeCDVyBsg9ocO/fPHp38PJFXQh1imrSjQjFuGnAB3cOVDNNRFMMVysDZWM0YPerAq2F8wtzUEllR3VNC0FSUENxt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 19 Jun 2026 at 01:31, Ackerley Tng via B4 Relay
<devnull+ackerleytng.google.com@kernel.org> wrote:
>
> From: Michael Roth <michael.roth@amd.com>
>
> Make the source page for populating an SNP guest_memfd instance optional
> if in-place conversion/population is enabled.  If KVM can convert the page
> in-place, then it's possible for guest memory to be initialized directly
> from userspace by mmap()'ing the guest_memfd and writing to it while the
> corresponding GPA ranges are in a 'shared' state, before converting them
> to the 'private' state expected by KVM_SEV_SNP_LAUNCH_UPDATE.
>
> Update the handling/documentation for KVM_SEV_SNP_LAUNCH_UPDATE to allow
> for 'uaddr' to be set to NULL when in-place conversion is enabled, which
> SNP_LAUNCH_UPDATE will then use to determine when it should/shouldn't
> copy in data from a separate memory location. Continue to enforce
> non-NULL when PRIVATE is tracked per-VM, not per-guest_memfd.
>
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> [Added src_page check in error handling path when the firmware command fails]
> [Dropped ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES]
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> [sean: drop explicit vm_memory_attributes references]
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  Documentation/virt/kvm/x86/amd-memory-encryption.rst | 13 +++++++++----
>  arch/x86/kvm/svm/sev.c                               | 16 +++++++++++-----
>  virt/kvm/kvm_main.c                                  |  1 +
>  3 files changed, 21 insertions(+), 9 deletions(-)
>
> diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> index bd04a908a8dbd..29409297f1ef0 100644
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
> @@ -511,9 +512,13 @@ range requested. Instead, the ``gfn_start``, ``uaddr``, and ``len`` fields of
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
> +ignored completely. For all other page types, ``uaddr`` is optional if in-place
> +conversion is enable, i.e. when the destination can also be the source, and is

Typo: "is enable" -> "is enabled".

"when the destination can also be the source" is hard to parse without
context. Maybe: "i.e. when the data has been written directly to
guest_memfd while the range was in the shared state".

Also, how does userspace discover whether in-place conversion is
enabled? A cross-reference to KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES
would help here.

Cheers,
/fuad

> +required if in-place conversion is disabled.
>
>  Parameters (in): struct  kvm_sev_snp_launch_update
>
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 74fb15551e83f..2b7569b6a8609 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2330,7 +2330,13 @@ static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
>         int level;
>         int ret;
>
> -       if (WARN_ON_ONCE(sev_populate_args->type != KVM_SEV_SNP_PAGE_TYPE_ZERO && !src_page))
> +       /*
> +        * A source page is required if in-place conversion isn't enabled, as
> +        * the data needs to come from a separate physical page.  Zero pages
> +        * are exempt as they don't consume a source page.
> +        */
> +       if (!gmem_in_place_conversion &&
> +           sev_populate_args->type != KVM_SEV_SNP_PAGE_TYPE_ZERO && !src_page)
>                 return -EINVAL;
>
>         ret = snp_lookup_rmpentry((u64)pfn, &assigned, &level);
> @@ -2377,7 +2383,7 @@ static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
>          */
>         if (ret && !snp_page_reclaim(kvm, pfn) &&
>             sev_populate_args->type == KVM_SEV_SNP_PAGE_TYPE_CPUID &&
> -           sev_populate_args->fw_error == SEV_RET_INVALID_PARAM) {
> +           sev_populate_args->fw_error == SEV_RET_INVALID_PARAM && src_page) {
>                 void *src_vaddr = kmap_local_page(src_page);
>                 void *dst_vaddr = kmap_local_pfn(pfn);
>
> @@ -2410,8 +2416,8 @@ static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
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
> @@ -2468,7 +2474,7 @@ static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
>
>         params.gfn_start += count;
>         params.len -= count * PAGE_SIZE;
> -       if (params.type != KVM_SEV_SNP_PAGE_TYPE_ZERO)
> +       if (src && params.type != KVM_SEV_SNP_PAGE_TYPE_ZERO)
>                 params.uaddr += count * PAGE_SIZE;
>
>         if (copy_to_user(u64_to_user_ptr(argp->data), &params, sizeof(params)))
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 044486f128c37..dd1d18a1d2f68 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -103,6 +103,7 @@ module_param(allow_unsafe_mappings, bool, 0444);
>
>  #ifdef kvm_arch_has_private_mem
>  bool __ro_after_init gmem_in_place_conversion = false;
> +EXPORT_SYMBOL_FOR_KVM_INTERNAL(gmem_in_place_conversion);
>  #endif
>
>  #define MEMORY_ATTRIBUTES_MATCH(one, two)                              \
>
> --
> 2.55.0.rc0.738.g0c8ab3ebcc-goog
>
>

