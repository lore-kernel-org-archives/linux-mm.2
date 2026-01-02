Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77894FA3728
	for <linux-mm@archiver.kernel.org>; Fri,  2 Jan 2026 16:18:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78B946B0088; Fri,  2 Jan 2026 11:18:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 739216B0089; Fri,  2 Jan 2026 11:18:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63B616B008A; Fri,  2 Jan 2026 11:18:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5100C6B0088
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 11:18:58 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E379D1A9796
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 16:18:57 +0000 (UTC)
X-FDA: 84287532714.15.03A7E78
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf26.hostedemail.com (Postfix) with ESMTP id DA87014000B
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 16:18:55 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=USQl84XO;
	spf=pass (imf26.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767370736; a=rsa-sha256;
	cv=none;
	b=6R7TtQvp2k2w1/mfjikIRoL0pz+kfM23N11iSTPQsPLUESo042cBvfbkLejhKG9peeBK4k
	gWwEfOyfQDSwMUV1OjVZ8agfbU+tT8ZeJXt3ngHJDLBDYygrIzKlchOLMnyRPumbnrPGU1
	pHSeHW0wMc3mb9uqym6Leh/nTwK1Jr4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=USQl84XO;
	spf=pass (imf26.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767370736;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zeSSjhvJc9NbrcAF6AZdEf+u5YF9OPhTESoyVoM1+Iw=;
	b=ifwZ4Y/QrFUpXalRdhhGsWEr84iAxC9n7CQVrkADG3Oc92/kZ0+apmrO0LuZYblyqNy0On
	uELtnSQLRt7dtEViApy8LSjPeTTrjK3Zk82NMfy/IHeWkvZ66zKWGcp39IWGPALqaY42pw
	HoIjQ7JKlP63VdFM37MOWSYecc6dLfk=
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-64b9dfc146fso148909a12.0
        for <linux-mm@kvack.org>; Fri, 02 Jan 2026 08:18:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1767370734; x=1767975534; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zeSSjhvJc9NbrcAF6AZdEf+u5YF9OPhTESoyVoM1+Iw=;
        b=USQl84XO+nic+a4Ew1tOa65yNTFsviuEEYSj0ufEJ/hf6XMTOKL3NcSj72NTNZSaQs
         Gl3w41XKyFq+Nws97YksjbxL5kW0Ojr4U9+kmZemPHsmDibUuiKRilEdufXji9cp8New
         AuSUinPIKNQJICqgAFpBxHJipcPggqqiu1RSs10HYa0gQBrEY494kWylz2qMU5juWyfq
         5BZLmEEGcVfk2nuUM8DvGbNMxN/fIpz6YOsxP1BHVKjFQKLLrmcX66RN3LltrGor4uTX
         l8Sda86NCTHR/6MjrqnpPyP0X+SOHFmjLYQM2uKe7v8BVsyVidy1DFJDs1QsAOc6DiZE
         dTwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767370734; x=1767975534;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zeSSjhvJc9NbrcAF6AZdEf+u5YF9OPhTESoyVoM1+Iw=;
        b=lN51zCFdvinwUnX2/oSMU6LhRCo0u4CNYhUO0Jos+o+ifimiBP28xGRgnHx2F1gzc7
         4PzS507W4C/Rj4hDNxdQ6zPIrDDAEzZlOfgqA+vyrC1YM3anABmr6UYI5EBNVzq9Ot5e
         XkY8Z3mBlg/52gEIBiSVa4v5zn/pkMnhTZfOKG5uFQ8t8mYwbcLf3phc8MCEPZiW/s/x
         Y2U2QbYC4g/GERQuCurDYuElrfE5uTUHIbKqZ1/CQzrZ7PZJoolcibbAaWc9e8yz4Qh3
         iCwPJ0AOm9XvRBUbvHbQlDJ5jIhd4j/SADCSzKSpY6geuDfFp907rL9RaseG2xtDj0qH
         3CCA==
X-Forwarded-Encrypted: i=1; AJvYcCVkH+NlvLMpUP5n/OHa2ynxkxRC8u1av4xveIDHm0N691HIc8C4IsoXZC5a3i+IdPFX39uFxGbeTw==@kvack.org
X-Gm-Message-State: AOJu0YyYmIQA1t7zZ+8gRrOd6oxgeHidrv8MQz5f+UNF3olR/MtMacYM
	ysJ0PLcwxb7FqUOyabni3i7AQVUf4KanaGQEstdRVT0S3IPevVlXTOhcg5Jgrw219b4oCDp4RhO
	lZO3mKxHTr6zzTNjJ4og8byqp1Z54ZaN4/yX69lG8ng==
X-Gm-Gg: AY/fxX6VZDXObNXfHWRptzx9rzoq90abSRo3hpeg/56uwddo9PlmBcJK9bc272+oqfB
	RN087NSqkEUe7KLRYf0KslrTs4MPPF4v4hRoIkx5sxrabzxx6hTAyJTwnPfp9O5XIP5Bw0m3L4b
	+uKJ0cA75PQy+3/gnTd2ok5lF0EtJaV/eRJZF7LqvtsOswm1fH1PbJrjLg74Wb/Nw9PKBFaJV1x
	iZ5NEM7n+CMqijdgxHLXb/rVi2QAqIzjFgiduo+3pgTFqFb5MEKYsPKJ2rKFYZ3WPEHcBZcCbS8
	gMi0AaeVbGYsv8rb6fR0/BOh5w==
X-Google-Smtp-Source: AGHT+IHtn3UsaIXslAlt12Rz3O0Gv/1EEh0UkZgY/dVxYDUflHpcNxeZ23ykq9/lKqCwP3DVceW2HXyq1NR2iJLFSgc=
X-Received: by 2002:aa7:db44:0:b0:640:93ea:8ff3 with SMTP id
 4fb4d7f45d1cf-64fd4c61696mr161286a12.13.1767370733817; Fri, 02 Jan 2026
 08:18:53 -0800 (PST)
MIME-Version: 1.0
References: <20260102-kho-v2-0-1747b1a3a1d6@debian.org> <20260102-kho-v2-1-1747b1a3a1d6@debian.org>
In-Reply-To: <20260102-kho-v2-1-1747b1a3a1d6@debian.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Fri, 2 Jan 2026 11:18:16 -0500
X-Gm-Features: AQt7F2rxDAXLSMcs3XAyYfXHtg1p8NF7W4L-cxju6b-9ZMk5GeGor7WCGXUdfPY
Message-ID: <CA+CK2bBKJqSEdvNYwVQvgBJZdWjn8vmbHo=L=eYLjcaMN3954Q@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] kexec: history: track previous kernel version
To: Breno Leitao <leitao@debian.org>
Cc: Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, 
	Pratyush Yadav <pratyush@kernel.org>, linux-kernel@vger.kernel.org, 
	kexec@lists.infradead.org, linux-mm@kvack.org, usamaarif642@gmail.com, 
	rmikey@meta.com, clm@fb.com, riel@surriel.com, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: DA87014000B
X-Rspamd-Server: rspam04
X-Stat-Signature: ge1a1htftmpq8maoqkddqww9z7fiwa1k
X-HE-Tag: 1767370735-476350
X-HE-Meta: U2FsdGVkX19iXHndM5dak4XM/ow4O4j98XJHJuCS45rm9tlYbdQVWnf9eDGpo/sBr8TqQd/aXq/G9FZRgpgYocn5x/zhVdMP9Zn45pTF/Yy+qZllJ8/9BkurtGMbIJoOYqjiaHydgocn+I/LygMCG3dsjW2XWuYQVXx/tj8iKkqiBfOG+6PUW7XGPJkaRfka7UTelu4ia9Gzt7ekngPTQXtSjmy7PlSMeeVw4JZ29z6gxq1vqvNQLeV87vD8PxUhcVX/of6n7SpeV3mEzXRIjsXNxVCBRfEmM43SjPw7358OXBdGtKFe72iCSFYXp0gsfLHyjCJSIkSvg6bhCXltFMnr8E8Tn6tf+JvCqBLjncLxcMUTENddhCAuC4Ew+/aqXu13g9ZK4gfJutaAhrx6K88X61cp8dOaUpkzP7JkiCoi8LSq5THT1/atySxkxW6jzGv1czvtHyvCfzk99D+v07x8UxgATsXyklzrDTCg7XRMbUeZ1rvUnItNtlJ76CXL7eCNtFqHra13ykjFVGUHz8Cs6pTfTbSlXYniwKbQHzKqAAw05NtpeJjcrVJu7ByT7fDbaFi6QT92oS6k6RQI4p2x7+my1OrAT1PuuI+KjEYQZWfrzKzzXwIIEInh0QbUQ9ovLRrDYC/+9NZAZOXeZ+sjQK612mUuZpU+Fcqyt21hqYKYVIni2LjQeCF5NZiUytEc982f+nxaNJ2SGKbk070vp4sssesdgL3wTBi1yb5GxMQ6D4biDw4GO8fKv/1Mc8S+3HgXzUXNrafzCrIYNDwsT5BCkP6qo7+le6VXBOhFOHrN1ATYpLpeTXtTHfH0Iq0BBdWDQar7KUpG2keC5sgS8lqhFGZai8ilhFPy9mVzk++EVACtLBhtW3ChwzEr6VWXZWwaT3bHEQW0FftAtTnuNSeKs4sl9KCkyXue+7ury9LEtcCFXQ/mTqrqG5w7lKJg2FYQw5qAnqq6VDU
 q9eElO8S
 Zq4PGynYNrf7fF59ssYm5PYDKNNo/no0d4vX++o97FpSgcC10/ShLr93lf8+byhWEVzDeOcrRvlDRGiS36N7fviQQox4QMIM1kwvIsTgU9H5aL6l+v+PlhldgmH3mPcwwJFg7DVd6nP1ZhqkaA34EXnCWCS7db598C3MyL4IMbiWKZ3h0rOgJvGj+i4U/mbxB0L6GUJJlNu6ZIGb8DP8qyrVQIRWON9dA9cL00rs9SibBnRwU6ASRdEkWqudPlrlkMZrI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 2, 2026 at 9:53=E2=80=AFAM Breno Leitao <leitao@debian.org> wro=
te:
>
> Add CONFIG_KEXEC_HISTORY to store and display the kernel version from
> the previous kexec boot.

I do not think we need a config. Let's just enable this by default, as
I suggested in RFC.

>
> When enabled, the current kernel's release string is saved to the
> "previous-release" property in the KHO device tree before kexec. On
> the next boot, if this property exists, the previous kernel version
> is retrieved and printed during early boot.
>
> This helps diagnose bugs that only manifest when kexecing from
> specific kernel versions, making it easier to correlate crashes with
> the kernel that initiated the kexec.
>
> Disabled by default to avoid overhead for users who don't need this
> information.
>
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---
>  kernel/Kconfig.kexec               | 13 +++++++++++++
>  kernel/liveupdate/kexec_handover.c | 29 +++++++++++++++++++++++++++++
>  2 files changed, 42 insertions(+)
>
> diff --git a/kernel/Kconfig.kexec b/kernel/Kconfig.kexec
> index 15632358bcf7..b770c68a3800 100644
> --- a/kernel/Kconfig.kexec
> +++ b/kernel/Kconfig.kexec
> @@ -94,6 +94,19 @@ config KEXEC_JUMP
>           Jump between original kernel and kexeced kernel and invoke
>           code in physical address mode via KEXEC
>
> +config KEXEC_HISTORY
> +       bool "Track kexec kernel history"
> +       depends on KEXEC_HANDOVER
> +       help
> +         When enabled, the kernel will store its release version in the
> +         KHO FDT before kexec, and the newly booted kernel will read and
> +         print this information during early boot.
> +
> +         This is useful for debugging and auditing to know which kernel
> +         version performed the kexec that booted the current kernel.
> +
> +         If unsure, say N.
> +
>  config CRASH_DUMP
>         bool "kernel crash dumps"
>         default ARCH_DEFAULT_CRASH_DUMP
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec=
_handover.c
> index 73da00aeaa99..06d99627bb3c 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -21,6 +21,7 @@
>  #include <linux/page-isolation.h>
>  #include <linux/unaligned.h>
>  #include <linux/vmalloc.h>
> +#include <linux/utsname.h>
>
>  #include <asm/early_ioremap.h>
>
> @@ -36,6 +37,7 @@
>  #define KHO_FDT_COMPATIBLE "kho-v1"
>  #define PROP_PRESERVED_MEMORY_MAP "preserved-memory-map"
>  #define PROP_SUB_FDT "fdt"
> +#define PROP_PREVIOUS_RELEASE "previous-release"
>
>  #define KHO_PAGE_MAGIC 0x4b484f50U /* ASCII for 'KHOP' */
>
> @@ -1253,6 +1255,9 @@ bool kho_finalized(void)
>  struct kho_in {
>         phys_addr_t fdt_phys;
>         phys_addr_t scratch_phys;
> +#ifdef CONFIG_KEXEC_HISTORY
> +       char previous_release[__NEW_UTS_LEN + 1];
> +#endif
>         struct kho_debugfs dbg;
>  };
>
> @@ -1332,6 +1337,10 @@ static __init int kho_out_fdt_setup(void)
>         err |=3D fdt_property_string(root, "compatible", KHO_FDT_COMPATIB=
LE);
>         err |=3D fdt_property(root, PROP_PRESERVED_MEMORY_MAP, &empty_mem=
_map,
>                             sizeof(empty_mem_map));
> +#ifdef CONFIG_KEXEC_HISTORY
> +       err |=3D fdt_property_string(root, PROP_PREVIOUS_RELEASE,
> +                                  init_uts_ns.name.release);
> +#endif
>         err |=3D fdt_end_node(root);
>         err |=3D fdt_finish(root);
>
> @@ -1455,6 +1464,25 @@ void __init kho_memory_init(void)
>         }
>  }
>
> +#ifdef CONFIG_KEXEC_HISTORY
> +static void __init kho_print_previous_kernel(const void *fdt)
> +{
> +       const char *prev_release;
> +       int len;
> +
> +       prev_release =3D fdt_getprop(fdt, 0, PROP_PREVIOUS_RELEASE, &len)=
;
> +       if (!prev_release || len <=3D 0)
> +               return;
> +
> +       strscpy(kho_in.previous_release, prev_release,
> +               sizeof(kho_in.previous_release));
> +       pr_info("This kernel was kexec'ed from kernel release: %s\n",
> +               kho_in.previous_release);

May be reduce the message slightly:
i.e. "kexec from: %s\n, kho_in.previous_release"

> +}
> +#else
> +static void __init kho_print_previous_kernel(const void *fdt) { }
> +#endif
> +
>  void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
>                          phys_addr_t scratch_phys, u64 scratch_len)
>  {
> @@ -1527,6 +1555,7 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 =
fdt_len,
>         kho_in.scratch_phys =3D scratch_phys;
>         kho_scratch_cnt =3D scratch_cnt;
>         pr_info("found kexec handover data.\n");

This message is not needed if the previous kernel version is always printed=
.

> +       kho_print_previous_kernel(fdt);
>
>  out:
>         if (fdt)
>
> --
> 2.47.3
>

