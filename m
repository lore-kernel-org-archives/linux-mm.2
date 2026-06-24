Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B84FECDB479
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 19:26:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5C246B0088; Wed, 24 Jun 2026 15:26:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE58E6B008A; Wed, 24 Jun 2026 15:26:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9ADF86B008C; Wed, 24 Jun 2026 15:26:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6A7F96B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 15:26:43 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E001FC1E83
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 19:26:42 +0000 (UTC)
X-FDA: 84915788244.08.B75F4FC
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf09.hostedemail.com (Postfix) with ESMTP id F2798140002
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 19:26:40 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="oY1MWY/Z";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf09.hostedemail.com: domain of tabba@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782329201;
	b=BEfAlDWQz0MG/tKUH64uTR6Y/bvQ8MqjFTDxIxIlgSM7mr2G/1Xnk7Qttar8TnhI3hfuM5
	eBNXVsNeuKvukSlEahWZP44Wt8vjCpGjPFfqcsbJ6YzrTQEIFJ4TFHKfp2scjZ1balDLla
	4k0xC7uDujB0qDQHX5MvN2jWP1CDa0Y=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782329201;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YjWrR34fw6nkV452WVsUflbv5W3gEPx2vCWL5i8qEHs=;
	b=wE4czaAvHhCFT6QgmBNfB+d7fKOYEEfnI66qVtEmEjByKyrfRIrUvPRorknngCAw5kg6Ed
	d2D9plF5xjrZVutQcOosODT7oYMKJ8b7WcJCCbmQfs0rsQcF2xi6JccM/SH0S9FjWGA+Hw
	TIgZvLMkv3Bavk+qjGS0E8LQkFeJRv8=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="oY1MWY/Z";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf09.hostedemail.com: domain of tabba@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-5177d1ff061so58461cf.1
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 12:26:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782329200; cv=none;
        d=google.com; s=arc-20260327;
        b=aiyIDKOCPyNLDRFajopoNcS3zcHu1HUYk/Bf81I8sS9/RcRxVpaxSuYVCruE/6XcW+
         +PUtibsoh/TQ+AY2Wqdfwnazyj2JkdFZsca0nPEsnPkOHd7KQZ1p3ruhom7e8sQi1rvu
         e8Cww+z/zYD9lRFl9yep7W4bfGR8OnKV7cek5+0VDddXZab3Qtl+KA43L0Vd+6F7OSpp
         qKnr0cE5+DPjkb48lLsFDNF8TWYcjzVeRWbRFCNI/K0aUZe92DBBOKEqYJZOC7jKaX6O
         MRG1B1ciKXWcrSDXoYzRue7yQpaDAtkXZuenhsTBByuzayK8XVkQ/dyU61Dq9AtUQ0ns
         H9QQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=YjWrR34fw6nkV452WVsUflbv5W3gEPx2vCWL5i8qEHs=;
        fh=1rzaoVBN5V+KE94PxxSf9wxf/+/Pv/o7mlmGfbVqDWM=;
        b=ppgbZkBCiL+JS/vhVq721E8z/PYgFaotWbBviVJGa5FePwyRe6iDDXBSn0o30rz1Hr
         miqb/3cLcWCXeqqdcjHuSM6r0i/xTo9x5XAeA/g5J3BD3Gw5KMOWCGFUMz9/lcbN1onm
         a4WI9U77kxtohwDZQQ0H0Qvvqrq0ANelkbkWvokFb8g7CCsHf+ihUTi7ARFQT6Vgca+e
         R0up7BWpJJwyKkvt71NleTaPw4ndpdPPEprqwKpULGP5oLdj7ftWPxqTNt6+cL1a8FU6
         DAqAJ6aoCCHRqTvI9rnlAoHYHDnjpnL6elSGtBuvXncCUYtqQ6PPaRYAChPkG7DJAbv/
         gvCQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782329200; x=1782934000; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YjWrR34fw6nkV452WVsUflbv5W3gEPx2vCWL5i8qEHs=;
        b=oY1MWY/ZpWH1kt9lty9pE1opSYbT8dqbL67/K0Qn+VgPnJTRKV/QqXGkAD4hKUQ3qy
         AQgi4YZZO2OyPiCkqfvJtUPHvO3Ett4jJ+oVPGGvRnAOLJGZXZ2nLjLsxo4T+tB0nU0c
         33w87oRp9p2Ti1NykEt7RdlPcllElmz1IQIaAD66wBrKlLP9k5U+kduF5ez+cd4RqcmF
         89VrKLreQRNlptAq7XVwVSBtssf9v9bFjIsnwzo2mTb50tEcGOXn8dbE88l1t2y6uXUO
         cpRJMNo/XT8A0BzWF6BKB+bRFxHOIhOgPnXY82ARBHSuSgWfjTaUQFsRQIYNlRoW0S50
         IAfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782329200; x=1782934000;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=YjWrR34fw6nkV452WVsUflbv5W3gEPx2vCWL5i8qEHs=;
        b=GsmDxKQOLqrC3R0DtRsbpOylAzhvtkKxry2yGuw8jJZXqNXNcVrqDmxhanYiJpA7B4
         AdMIec/9+1suQsChwB4b0fu2ZubAkRf4WCNaWopqLRA0dTFi/T2sv+Zy0NY+7ctgAjRM
         u/rdieg6MKhbxI8uzEbl0VKJUcSBY0yvmhRQX+RtfN1MXNQ1/YaSTgtiWL2fJF+UsCet
         UU8c6ZMhMcAKfnUeU5i2VRWFALgh3J6hqD7FS5BgWFzTrN6Zuqh2+Mt0Oy1/y+HxfQcQ
         GpnTHYQt2LFcBfaG7593LG1G18kxfXaM3nuBnanWsFSO9W3iNdvreiwNzhynz9vlmcV8
         Eing==
X-Forwarded-Encrypted: i=1; AFNElJ9OtNhhNAO4ZdCTvJbx34nS7CcGev/MP7/gSjGlT8dApI/RjjOiEIes1InxtQRlicF8h+NkpnDM5w==@kvack.org
X-Gm-Message-State: AOJu0YyohgNLLtGHduwGjPpyvQNzgbvrfrma/RLQjuOBHWWAAl+TM1ws
	anwDHrqq5jVytP+/9IG8CgPUsq6tfx3foy3xdjyOgEupbTMmlywuKD4n8t9NhgZqRbQuspD+2HK
	+uB027kGe72uLyxxuI2/hYFzhL0jODu10jwCs/Zjs
X-Gm-Gg: AfdE7ck/eBWnyItkPMMeyM4kA8kly9Ds6/QR+yoZqnYdD51Z5P3n2MVhzmigZwdKcvb
	GlgV5U+BmyY2w1KMVHkXLAbiCvVZg8Is8oLuF3z+I8HiRx1SBYct4TGuW4sbUOM6atwSHN/qlaf
	3cbyt/E0IM8AZs3pnUyGYHgVy/S4crtS47AOown+OASNdW/w5tF5FymvhnRCAhCguaAEg2jKW9R
	ThjnKmv2nOKE8ty1I1JuAn1MXNLLBb/RphlkCkz/Yu4qS2ADXDIz0uZyvZqwHO/3mBPPcJdtgR1
	l1BMuHU/
X-Received: by 2002:a05:622a:a0b:b0:50e:38f0:ccb2 with SMTP id
 d75a77b69052e-51a6ec5b17emr1608501cf.15.1782329199083; Wed, 24 Jun 2026
 12:26:39 -0700 (PDT)
MIME-Version: 1.0
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com> <20260618-gmem-inplace-conversion-v8-29-9d2959357853@google.com>
In-Reply-To: <20260618-gmem-inplace-conversion-v8-29-9d2959357853@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 24 Jun 2026 20:26:02 +0100
X-Gm-Features: AVVi8CcGG2L_WGfgpW6JtuTQk7CHKKes1x1HHlBx2_zfm1i0mgNuuyxx0bG7ikM
Message-ID: <CA+EHjTw5dJ4HRoN5OxeKaFTgQrstUTVcb6-x3xgWEa-BBk3ZQw@mail.gmail.com>
Subject: Re: [PATCH v8 29/46] KVM: selftests: Add selftests global for guest
 memory attributes capability
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
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: F2798140002
X-Stat-Signature: 3ad5q38ud344rxmjqhtzez4pgdwm9eo4
X-HE-Tag: 1782329200-170450
X-HE-Meta: U2FsdGVkX18frdqg0n1P6wKt4GRTj7+gR0vcbClL9f7w8w4V4xq+6BddR0e93MCtY0635jdhJmfDfUeHU4VZirdhfcSlvLHTADydKL5VP1H2QTcPaVb8gyeIQLqoy4u7fpp+RkRy6LKr4d9Dx9QwCEq0d5AzoOdBxL2eH7iNNcrz12I5DKNfJZMyVpKUfvGy1++IuoOpXLLLs9IY0toena2hcSZNKkpW/H2aNz5DnRpTxFUkLA/kImVkZs9rtTKcnnCvTt4v0e3zZOkl6K2j0PAOm8VP2S/Q4XgkOFKBDq0UHjHwFzRG6oon96L1ZFAXtyr1ClPd7OV3WWbeZHwOwSPI28ZFAcmkIro2M+H3fbSov3T176yxHvgYkhIQRHNkunOP9peqOSXUX7EVbG9douf4ruXXeDXgM5DDTd6CShiCAo3W3qXNuhyO31JDLsEB1wJmNGBljTNeqrIWutWPBSrtyX9wdnw1RMojGuSCIgLU8rEsbFIRSSp1nZd00QzUIBZlPgduEZHmjVozmDagHpZFrFAL4PcVLcETYbkN0WdxCFQeufIFw4EXjpN+qfKz+Cbm38Kr4xCMW6I2DHL7FZZEz6vzOuZ5JgIbFV7zbTSd6mJkhaElgwF2aMPDidNQTMSpzdTlKMANMGWLXwj2Pcr6U5WjFLbwof7Sy0MeiEYAiJ//kH0Xl22cJtI89w+2TW0C+dX9zLg9pMOiXENTRcxFs4zeH/XrzbLlNoWKwt9y18gX6ZegpYiKDXzdHxHl48YFQ1VOrmKGVnvmzwiJycKEsX8XB5bCWiiUIO6vMoLSRfQJIZTLtIpRQigO4j7JuNtl3EwEynRdpXp26DMDs6OK9iniwi9DrftfKMtIOuMm3M162pBLy1PeBvbTVFM6ln8MSEg6OaiSqyCmD7GQ3s6N/Dw/iqg1gDoQUS0sw6T4p3Fepyf8eTH7JsHEtCIiLi2HyMnPm5lWdXfRPTY
 jUvGCZiy
 Cr5QzHOoRw4jix54GMWfgJMinW1RSP7HwFqRC1RvBkqH/8NHrEsdI+E3QxPXvxYuNmUQSniKWZ27OyTlVWcGiG+6hZkAmsFs3br34ZVSu/pvK1Q+QGihLQb0zV7YBLn0ypAc3ei/ddrfC3lJsNuhCJ3irH6a4AhVuIlLsxOpWNajIGio1g6ypSDOSzbbJlglCRGpa8SW4IFWzUd5qGMbDgeGxGx3IWctoVDt1VzFqViB0w0UWiBlqh5PtLfD73Wxxv2ETeCpb9302jx++CS1CqQYb1iSyq6Xeyh/8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 19 Jun 2026 at 01:32, Ackerley Tng via B4 Relay
<devnull+ackerleytng.google.com@kernel.org> wrote:
>
> From: Sean Christopherson <seanjc@google.com>
>
> Add a global variable, kvm_has_gmem_attributes, to make the result of
> checking for KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES available to all tests.
>
> kvm_has_gmem_attributes is true if guest_memfd tracks memory attributes, as
> opposed to VM-level tracking.
>
> This global variable is synced to the guest for testing convenience, to
> avoid introducing subtle bugs when host/guest state is desynced.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

> ---
>  tools/testing/selftests/kvm/include/test_util.h | 2 ++
>  tools/testing/selftests/kvm/lib/kvm_util.c      | 5 +++++
>  2 files changed, 7 insertions(+)
>
> diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
> index a56271c237ae9..51287fac8138a 100644
> --- a/tools/testing/selftests/kvm/include/test_util.h
> +++ b/tools/testing/selftests/kvm/include/test_util.h
> @@ -115,6 +115,8 @@ struct guest_random_state {
>  extern u32 guest_random_seed;
>  extern struct guest_random_state guest_rng;
>
> +extern bool kvm_has_gmem_attributes;
> +
>  struct guest_random_state new_guest_random_state(u32 seed);
>  u32 guest_random_u32(struct guest_random_state *state);
>
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index d5bbc80b2bf1c..b73817f7bc803 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -24,6 +24,8 @@ u32 guest_random_seed;
>  struct guest_random_state guest_rng;
>  static u32 last_guest_seed;
>
> +bool kvm_has_gmem_attributes;
> +
>  static size_t vcpu_mmap_sz(void);
>
>  int __open_path_or_exit(const char *path, int flags, const char *enoent_help)
> @@ -521,6 +523,7 @@ struct kvm_vm *__vm_create(struct vm_shape shape, u32 nr_runnable_vcpus,
>         }
>         guest_rng = new_guest_random_state(guest_random_seed);
>         sync_global_to_guest(vm, guest_rng);
> +       sync_global_to_guest(vm, kvm_has_gmem_attributes);
>
>         kvm_arch_vm_post_create(vm, nr_runnable_vcpus);
>
> @@ -2286,6 +2289,8 @@ void __attribute((constructor)) kvm_selftest_init(void)
>         guest_random_seed = last_guest_seed = random();
>         pr_info("Random seed: 0x%x\n", guest_random_seed);
>
> +       kvm_has_gmem_attributes = kvm_has_cap(KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES);
> +
>         kvm_selftest_arch_init();
>  }
>
>
> --
> 2.55.0.rc0.738.g0c8ab3ebcc-goog
>
>

