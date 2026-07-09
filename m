Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC2DDC44501
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 13:25:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 601FA6B0088; Thu,  9 Jul 2026 09:25:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58BFA6B008A; Thu,  9 Jul 2026 09:25:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42C646B008C; Thu,  9 Jul 2026 09:25:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 199E76B0088
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 09:25:02 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A0D161C05E0
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 13:25:01 +0000 (UTC)
X-FDA: 84969308802.24.183F2D2
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf10.hostedemail.com (Postfix) with ESMTP id 85FE1C0007
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 13:24:59 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=BoNcfM5p;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf10.hostedemail.com: domain of petr.pavlu@suse.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=petr.pavlu@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783603499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X+2+l0R7RX9cCzxaoR4qreoVsEJbp9qB9SwPbos71OM=;
	b=SyVxoG/LOOVhTEOLUCS1Y8XAlH0DcNe4wuuJQ0F5iERrZiRM273QJWyQTDbGnFI9Cx7YEX
	fmeTR2osELlpFczp17lWr9t64tcQF2zXR61l2f9RxtXDEPsPPGnKRe6Wn+OVGGMSa1VysS
	RcMqFu5gvKxIBp+dYdOCVFjzYrF8bBI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=BoNcfM5p;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf10.hostedemail.com: domain of petr.pavlu@suse.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=petr.pavlu@suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783603499;
	b=yRxlFnPPicrtvhHy3S8rh5ueDPD18zbtLlNvcQojOJgyuPY7FlmVrMXRTSF5DKFmyBRTVc
	a9i3htf+A54ATWrAaslcllW5LW/dG2jjt62m35DtzB/xTY0r9xPrLwhf8vOXVQd4ya0Nl6
	j21Mh4NN8RsyB4hbbBRACmGnP4MuvYA=
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-475417f010dso849114f8f.2
        for <linux-mm@kvack.org>; Thu, 09 Jul 2026 06:24:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1783603498; x=1784208298; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=X+2+l0R7RX9cCzxaoR4qreoVsEJbp9qB9SwPbos71OM=;
        b=BoNcfM5p/CwmsFoS3rKsc0JjvDfZjt2NafkEMoQ//0ufiP0khzeZJgbF0gv1qL0Fhk
         pTT2T+kllIYbDKAKIX8pwxStbLqE+3iVisrLYV0Bi6K7UmljfPOsbk5cySMzCfNPc3qZ
         aPxzbbwM6Dfw5PNgjpkyXWqtwprnlcRrUmK64VNRefhT1MfQ/9ng9Er1exJmyb29cAQx
         hXFHdW2nvpRSPFN6ZOEYNfeC+FuA+99GKS/LU45jKUOwuP7+s+h8hvRq4C2KjT/hPxwv
         56+k5Drqov1NxwlxJSyiCTtgJKfhI5twwdVxdwYHKNCCHIjrKe41l04fPzmIQUtS+IMY
         v8sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783603498; x=1784208298;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=X+2+l0R7RX9cCzxaoR4qreoVsEJbp9qB9SwPbos71OM=;
        b=Jx7TE4Gx0x8Xqppl0L1yyvSeWmXjGiBQjzSizi5k4ILgmldcbaxMMsOLU2HskKQKus
         WVTvfg42I5zjQQ7o64cCgxtHYaNE3qMDM7PanbZzHK/vYfi9l69tAljBl/nrfRMHO1MA
         j1mzxjoeZli94Gt6MrRcgyPNTMZATfifpbf6aImztzYZjBBaOb1+YlBreZgSRzrpYZOw
         9WAuaku2WNwUJZuPkfdt8XwKXo2S6T/h/ApEpMO/XutmooaD4E176Rnf2TUrDR5bBR33
         BCZpe8+OCRMrarfwOxXKeg+dXuphvlufYsMSVPwrvLpz6IXly4O6qTSBzzcRvguJ51FY
         +8Wg==
X-Forwarded-Encrypted: i=1; AHgh+RoaGK/9OVdDg5W9LqSYk/qhBsgAive/fMkFuwUHXSqNULu52lDUoMrRFd2L+j5SG5Y3ogApmsp3xg==@kvack.org
X-Gm-Message-State: AOJu0YwiNF44OCJt3muqs0SDAZI3rUv5gDeF5lBQy87vLXcBE+p3yFOs
	uCoNaaJ/nEGSL+sxbUGnON38kOhddAsycU86zrHh8SWS1EZOQMPpAlAamAQWoLysrZ8=
X-Gm-Gg: AfdE7ckVWlSvv6+UZ6UyPHH7JnKJ86xxNwX+ggmFc3HBY60A/Uyeh8oTxgyknIqdvVo
	NrdTJSJ1Fm+f42HKJGaXv1GvuuL2grz0KDKM7y6gLuUBDaZlvPO0ecDb6tN8AVXkVVIIuEwGSDN
	K6zKRchL4ICzWYZJ7G52MxOaE/U7mE5oc4VjbVzDbJxlUZb1Vicu/Eqgh9EAG0c6/g0UryAGaRW
	LGQ2CWIdIRlXaXtSqf96UAcpLEhHAl16X5yyWlrP+EzT99EbUaWmVwSLqKN8Z3qMgKnULFLEWtI
	qym3sl3iy3nWNyv35BgeiBUk1HBkd9/jXBiVq2ioLE2zoVkNBQyVYNM9Xx6lpiPyvTi7X2q281e
	+UMcFj1Qn8ZZNFkO0GY7PhsAPl/i2jhZIVx8iKVm6ybJ9gyb9Rvg/cKZudtvS8hweMEWH1+BPi9
	qfalPvB8BY4Oze8IkG6XF3g8HZmGtIpWA8XxXrnAtS+XvE
X-Received: by 2002:a05:6000:2013:b0:46e:624e:3c2f with SMTP id ffacd0b85a97d-47df077b2e6mr7512557f8f.47.1783603497728;
        Thu, 09 Jul 2026 06:24:57 -0700 (PDT)
Received: from [192.168.42.79] (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47aa0a55be4sm47212857f8f.31.2026.07.09.06.24.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jul 2026 06:24:57 -0700 (PDT)
Message-ID: <84ded2aa-397f-465b-b2e5-d2fa31fc807d@suse.com>
Date: Thu, 9 Jul 2026 15:24:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 26/26] meminspect: Add debug kinfo compatible driver
To: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Cc: akpm@linux-foundation.org, anna-maria@linutronix.de, arnd@arndb.de,
 andersson@kernel.org, chrisl@kernel.org, cl@gentwo.org, conor+dt@kernel.org,
 david@kernel.org, dennis@kernel.org, devicetree@vger.kernel.org,
 ehristev@kernel.org, frederic@kernel.org, mingo@redhat.com,
 jstultz@google.com, corbet@lwn.net, juri.lelli@redhat.com,
 kasong@tencent.com, kees@kernel.org, konradybcio@kernel.org,
 krzk+dt@kernel.org, linux-arch@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-remoteproc@vger.kernel.org, mathieu.poirier@linaro.org,
 peterz@infradead.org, pmladek@suse.com, robh@kernel.org,
 saravanak@kernel.org, tj@kernel.org, tglx@kernel.org,
 vincent.guittot@linaro.org, workflows@vger.kernel.org, atomlin@atomlin.com,
 ast@kernel.org, aliceryhl@google.com, linux.amoon@gmail.com,
 ardb@kernel.org, baoquan.he@linux.dev, baohua@kernel.org,
 bsegall@google.com, jackmanb@google.com, leitao@debian.org,
 brauner@kernel.org, coxu@redhat.com, dietmar.eggemann@arm.com,
 dianders@chromium.org, ebiggers@kernel.org, feng.tang@linux.alibaba.com,
 yangfeng@kylinos.cn, gary@garyguo.net, guohanjun@huawei.com, jack@suse.cz,
 wangjinchao600@gmail.com, joel.granados@kernel.org, hannes@cmpxchg.org,
 john.ogness@linutronix.de, jpoimboe@kernel.org, shikemeng@huaweicloud.com,
 kas@kernel.org, kprateek.nayak@amd.com, liam@infradead.org, ljs@kernel.org,
 elver@google.com, mgorman@suse.de, mhocko@suse.com, ojeda@kernel.org,
 rppt@kernel.org, namcao@linutronix.de, nathan@kernel.org, nphamcs@gmail.com,
 n.schier@fritz.com, pasha.tatashin@soleen.com, pnina.feder@mobileye.com,
 rdunlap@infradead.org, rioo.tsukatsukii@gmail.com, senozhatsky@chromium.org,
 skhan@linuxfoundation.org, sboyd@kernel.org, rostedt@goodmis.org,
 surenb@google.com, thomas.weissschuh@linutronix.de, vschneid@redhat.com,
 vbabka@kernel.org, youngjun.park@lge.com, zhengyejian@huaweicloud.com,
 ziy@nvidia.com, Eugen Hristev <eugen.hristev@linaro.org>
References: <20260708-meminspect-v3-v3-0-7aa5a0a74d5c@oss.qualcomm.com>
 <20260708070809.2660886-1-mukesh.ojha@oss.qualcomm.com>
Content-Language: en-US
From: Petr Pavlu <petr.pavlu@suse.com>
In-Reply-To: <20260708070809.2660886-1-mukesh.ojha@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: nsiskm19418cya5d7r6hibjdhmz6itwz
X-Rspamd-Queue-Id: 85FE1C0007
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783603499-873497
X-HE-Meta: U2FsdGVkX1/Rg8WeqsUpwXEcwhKVmcHEiYEqgCv6646Fp7xBVYVjLf9T38fH0vO82ibRj1D/jJcJWOeeRgLZIC0fKl7m9gEukP+k1WbapGoFTOwrTc9oL/WXMuwN/UhbAXnjy5unGysdUKCEF7y2o+xnbRlvGmClkwHq8B6eaxMNN1S3/54LhyGGMpnndcolbf5/CpTVXnKbbS1WUbdUhXmgi1mT8LZhH+rTeb3WDs/RrwsceuPe0LLlTlcQ9u0kbZ2fAAayuqW499kOBw6w2s4Hoq3RAYttOU6D2w5ZarW3bfrGhgJcA/21+4BRCkREI7Sclz65/IyOVbPVX92PV4iylxtlGVu+6isYYieQKXm2qME89qnUXrMRm4BSPQiSMziLFayIYWHxubFrm0/2mWjNruct4XXNdLTbyWLT4oHde53wNlW7DBdhuNJtiMeFzL2gJnW9jpL6WQfbKWtrPHOvWigMTZrCRl6cvRSQbK14HolZEw1MAMntyTaUtMSCfUmWzJSx7izzT8xw/WKxKOraoQwpdK6p6hNDeh/9GHTDq+p2Dq2PKvWNZKScWKZhXuwG/k3UDDrKCg/kPVFbF1EfzlbN4/6A+Mwl7SuhjcecZKAKLhPqJ1j/ETiizzUpVcohh01wA1W6FFixQuSzaKDEZ/5kKeeRF9fgZyLw7o6eKEM65m6bUICCgMyI81oqpsBsFfwYnZHFNLj6sr2q+sCJNSv99WhBora2LTQyiW3zP7PyYvN5zAXepoGKVdHrQIZFFN38wV5N5I1S4i+ToVLMpWe8oNCWVYZnTaSAaKHWPPXsSfKtp9CFxK5o4pBzb+K+HHf3N7IDd3CgX/ZZiUdtTBERQU7V5e2Yo2qiZegGa3m4Ktb2jTydnL3LrMfqDy9geuCL5LfdPIrMjbSEEcDoNkVsinC11Ic0qZrZK9jkTPo+Fiz/0faqXGuvirkbPFbLIAdSiaYpUOZIjNx
 Z2rLixWE
 ME2vceMG7pCVuFIKxGJABAhElOEHuPVzDTQh8Oo39RPzWJEXEVePBjNq/3MECuvKOTNlancGjhid331u4eOv3fHSx6fV6/Yz5mftJ0O0tIc8dhQAynhl5IxHmsO/l6AdwhQgd1hy3qZCRMKRyGjIQK2kY9MOb4xy8WLr+b9b1udU3/GDWWIPvkfAbfhjQQgq1h4MSfMQh8qWWWimIonxkzcukh+V6CKab2W5EMRPdX/OY787Ri5h5TpCtLtpZSBkkKyhGZmj7yYMp6uRLnqHXvd2DZhO4Xrp+63HIWCKFjdQdA3VlEvNSPJ/iow6BCwxAfLZ0HKNtUOuAk6J/cVwO79RBR9Omu/FGM/T1Ovq5x69fmzk87UgXRQprcYz6qj+XkcsNmBv3jzvFmq16Gexk9txSzg9710SEheUUW6HL284DF7gRajZS1WFW0XEhLCC1y5bEokd0ZZw8tpFnaown13bPKStjaeeUVLcSA/f8rFC63pdq6+HwITa+MqtOPU+qDd8IOHHL2t1UjSshdbbE2BJLCbrf8Qjpx/MMAR05iCzjfCBace87bvGLwbTdGKdjXNEQcZUY8zHXWFG7uaadqqlcmL/hs1eZL3EEMTnd/O7iDOCfkH4rqazjVw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/8/26 9:08 AM, Mukesh Ojha wrote:
> From: Eugen Hristev <eugen.hristev@linaro.org>
> 
> With this driver, the registered regions are copied to a shared memory
> zone at register time. The shared memory zone is supplied via OF. This
> driver will select only regions that are of interest, and keep only
> addresses. The format of the list is Kinfo compatible, with devices like
> Google Pixel phone. The firmware is only interested in some symbols'
> addresses.
> 
> Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
> Signed-off-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
> ---
[...]
> diff --git a/kernel/meminspect/kinfo.c b/kernel/meminspect/kinfo.c
> new file mode 100644
> index 000000000000..7451c13bc316
> --- /dev/null
> +++ b/kernel/meminspect/kinfo.c
> @@ -0,0 +1,257 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + *
> + * Copyright 2002 Rusty Russell <rusty@rustcorp.com.au> IBM Corporation
> + * Copyright 2021 Google LLC
> + * Copyright 2025 Linaro Ltd. Eugen Hristev <eugen.hristev@linaro.org>
> + */
> +#include <linux/container_of.h>
> +#include <linux/kallsyms.h>
> +#include <linux/meminspect.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_reserved_mem.h>
> +#include <linux/platform_device.h>
> +#include <linux/utsname.h>
> +
> +#define BUILD_INFO_LEN		256
> +#define DEBUG_KINFO_MAGIC	0xcceeddff
> +
> +/*
> + * Header structure must be byte-packed, since the table is provided to
> + * bootloader.
> + */
> +struct kernel_info {
> +	/* For kallsyms */
> +	u8 enabled_all;
> +	u8 enabled_base_relative;
> +	u8 enabled_absolute_percpu;
> +	u8 enabled_cfi_clang;
> +	u32 num_syms;
> +	u16 name_len;
> +	u16 bit_per_long;
> +	u16 module_name_len;
> +	u16 symbol_len;
> +	u64 _relative_pa;
> +	u64 _text_pa;
> +	u64 _stext_pa;
> +	u64 _etext_pa;
> +	u64 _sinittext_pa;
> +	u64 _einittext_pa;
> +	u64 _end_pa;
> +	u64 _offsets_pa;
> +	u64 _names_pa;
> +	u64 _token_table_pa;
> +	u64 _token_index_pa;
> +	u64 _markers_pa;
> +	u64 _seqs_of_names_pa;
> +
> +	/* For frame pointer */
> +	u32 thread_size;
> +
> +	/* For virt_to_phys */
> +	u64 swapper_pg_dir_pa;
> +
> +	/* For linux banner */
> +	u8 last_uts_release[__NEW_UTS_LEN];
> +
> +	/* For module kallsyms */
> +	u32 enabled_modules_tree_lookup;
> +	u32 mod_mem_offset;
> +	u32 mod_kallsyms_offset;
> +} __packed;

Is this kinfo format documented anywhere? I was only able to find
a reference to the equivalent downstream Android driver [1] in the cover
letter. However, I don't quite understand what it is or what the
associated bootloader component does with this information. In
particular, I'm unclear about the purpose of the following
module-related fields:

module_name_len
enabled_modules_tree_lookup
mod_mem_offset
mod_kallsyms_offset

These appear to be exposed for reading the internals of the module
loader. Be aware that this data is not stable.

[1] https://android.googlesource.com/kernel/common/+/refs/heads/android-mainline/drivers/android/debug_kinfo.c

-- 
Thanks,
Petr

