Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2E86F531DB
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 22:20:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 288A86B0093; Mon, 13 Apr 2026 18:20:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2600F6B0095; Mon, 13 Apr 2026 18:20:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14E846B0096; Mon, 13 Apr 2026 18:20:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 02A906B0093
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 18:20:44 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C170C16034D
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 22:20:43 +0000 (UTC)
X-FDA: 84654953166.10.275DDA0
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9F84840007
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 22:20:41 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Gfgexhq8;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776118841;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0GtrcgyRY8dcn3VLzUDN93WtruBuz/B9n6Ctjtr0M2A=;
	b=pctUcmmxC+YYeuyAfpA2J86CqzPVPEu1DNOI0wdc6QceGyuUvXShwzMtc7M792aDJ/I4Ga
	PCgaXR6R9pzx9pQLdUy1SOOkDn61h+JFzNa4w9gLau1wBi57mDYzJWfBnfnw0vUggWnkjR
	g5e7gb//Cjnpx+zRIgYyoWPs59JjfOg=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776118841; a=rsa-sha256;
	cv=pass;
	b=6EgWP6EZsfS6jIo2wpBm5WtsoOROXWQfTEcZYVS4sdLwjM4gnA8Mm0aS8ZGePe3d/b9m7i
	tFRq1U7QKKCUl24BWNnFfCciVV/fKwAIzgYPO5OZb0hNLTY52fmvrp2XNLFasjoF0LkY+o
	grkD4gRA67qhTdOUPqXZti+u62fY8p4=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Gfgexhq8;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-43cfd832155so3368341f8f.1
        for <linux-mm@kvack.org>; Mon, 13 Apr 2026 15:20:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776118840; cv=none;
        d=google.com; s=arc-20240605;
        b=eM5Z0UMTEi3o3707TXfy5rYd/DaQYIOg7EBcijYM7VR074Tl2W4mFwACKT6gwTSbSt
         RKQWRQarUAMXHRtHPPV4P2kWarvBCpzT//MEtgPkZmcjN+VPfVc8g22udlSv6HiO9XM5
         aJkK+rkrrqvfPhjVkQa+5lSYLLxODm/cOOa35usT546aTEr9QPrtVD7pUwFKtT5zAvhM
         9Mqi09jUPu8BATfVPPwzHwDBInxCIW99SGqzjJkallsNH4MTQva832VXA+4IzSnim1jZ
         OGE4E+RoBLbcwOWVLbImw6f6n0ui+7nR+jTA3ULD2mIG9UhVKSA86HXkh1T20zNDVSKw
         6sSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0GtrcgyRY8dcn3VLzUDN93WtruBuz/B9n6Ctjtr0M2A=;
        fh=HHUUzLlsvNZfAw4nmwSqT33Zc87pJOIHOsBnXgZswvY=;
        b=Ta/DwT5UkI7URSnri9NbY+9voH3sH/VAMJ/C1QBISlvNPkjeFA0A/ihza9w2cy+r51
         caXzg7XDHX3dooVM5tU8Z23LC237+pZvCriza1DehL+5ooucY59RlMCk8HFkvTIdsY4C
         0vqvDDPYVj5XtTRdYyRNUD1vszG/Uk2KfOxnMCitp8Jf3E2h/JNjKs1k4fc0mL0iUYPM
         oOKoNt8mQwYxx9Rk3NZ2C+2z4Zhzw3BeaxQCbCDNZAmRfrdpKKDGdZyCPzggZcPBxjyE
         XqpNfbfCjq8T9J5RkZ4V3EqpKOZh3WcIo9Cx1yAUb/f42huthHluv4Sif8Gnlttbsaw2
         5FHg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776118840; x=1776723640; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0GtrcgyRY8dcn3VLzUDN93WtruBuz/B9n6Ctjtr0M2A=;
        b=Gfgexhq8zH3XE2C/yWSjhupgt+IPmcRKVA7t2PhjPyGcmonCTqtgNRKTBOcLm9YEuD
         HaQw1C3P5rUz9H71DD8bYIGztaGsb7/+klJ0dIqV4OOthGYxRSLUbbugor/R34zXtPKG
         gkmy0AJz4jK7/2gVvBoysjQyyhpBFOE87+HsTmhbK5zh4pJXIJMNjGlZ/x65qR/yAxtF
         +fDn20PwiH9W58p7H7XemohStJu7TrRDoMebqI9ccKt6LWu89YKwWINPL60h5qEx0S4B
         CeKPVf4KfdPv3jqZBDAgUZ6zzkWeTWI7acSGZioSh/WwCKwKh9RTSD24c8WQ8NiWr3FA
         vUvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776118840; x=1776723640;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0GtrcgyRY8dcn3VLzUDN93WtruBuz/B9n6Ctjtr0M2A=;
        b=UDNwdNiDR7YNzkr02MHjqQvjAApFerls1OQvHrly+5nIdCMWbsDd4cn+PZlEWbtCna
         V/cQRR00OZ8aUNAX6gVbWkdq+rToEUDE1fxXHTxzwaEe5VpSqjxx9vtoci2BG3glM3C0
         YH7BKSyJVa8PhOTD9oHHHzuQvNWJaaTZNntS0RKDnHlc0LKGbLFyhWU9GUIY3pX5KUar
         Pu2zCSs+8TL8vhFjPpf0lElystpFAXNKUS56SMXEdM+XKb2fHYTiWD0HM5lFzV/R50o3
         lrsppMedHDRj8o2MveJi3aR5sbCHK0mG6JIZm4vF7EhWw+PZy4dEhGrWGumr8Pf68PT7
         7fuQ==
X-Forwarded-Encrypted: i=1; AFNElJ9EAIXfSj3SSiMQ6DuhiRWxkuFZXHbOn5qjgwpoUmQSXcgL3KrerONJgunqbK19/X4I6UUCgJ712A==@kvack.org
X-Gm-Message-State: AOJu0Yxtvx84NjmB1UgcwZO7n3RkUeOp9m757VZXhK3DVq+ozfvhT3m9
	R3c6O5bMJG1L8lDmnRZgUMi43y1JB+JN6xojPt/8rE3uq8o3Dgb2VB1Pkmj+m2hLHb9GQmxx2QM
	vihGpdT+lAiFJtang8ebjpJd/8r+Ybe0=
X-Gm-Gg: AeBDiesRig8R6TlvwHAv1CG6bRcjSymxKr0ctjFIjV7zAkKqgaEYwK0WGyguz1philL
	xvzcGdfGZaX2hB6vQOHjh9qeS6xvMZCv5xuMon9Szc7pJL6iqLmdSUNp5ELC6M9SNO5dIWRoIGi
	+cCQG6j3WwC/2BS1hFN5rxU7G7SHL7CioB7kHjxKd5KxgAZbO6ZPXt3AkoB9wWPJmQSRyzCkc4J
	BHYn9cjpSF9E/JybRRAwVeal8ZNLXTbB3I8d8pWW997c0L7cnuawiLu6pQMqwTZVRFO086ybdgq
	4l7lQxJjBgUadQYNviM2bKfD6xyrR4q43TMH9NlO
X-Received: by 2002:a05:6000:220b:b0:43c:fdd:ea96 with SMTP id
 ffacd0b85a97d-43d642b6e75mr20785387f8f.26.1776118839833; Mon, 13 Apr 2026
 15:20:39 -0700 (PDT)
MIME-Version: 1.0
References: <20260413-kasan-v1-0-1a5831230821@bootlin.com> <20260413-kasan-v1-8-1a5831230821@bootlin.com>
In-Reply-To: <20260413-kasan-v1-8-1a5831230821@bootlin.com>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Tue, 14 Apr 2026 00:20:28 +0200
X-Gm-Features: AQROBzC46tJ1Vulp-Ruy1LR_qNHLJczc_Mec_FX1XvbzAbvB4RmfM9pOdtpD_VM
Message-ID: <CA+fCnZekgcEgsZnRrOB=+HoG=neRg=oLTt2jStyrPJ6mYf2ctQ@mail.gmail.com>
Subject: Re: [PATCH RFC bpf-next 8/8] selftests/bpf: add tests to validate
 KASAN on JIT programs
To: =?UTF-8?Q?Alexis_Lothor=C3=A9_=28eBPF_Foundation=29?= <alexis.lothore@bootlin.com>
Cc: Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <martin.lau@linux.dev>, 
	Eduard Zingerman <eddyz87@gmail.com>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, Song Liu <song@kernel.org>, 
	Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>, 
	John Fastabend <john.fastabend@gmail.com>, "David S. Miller" <davem@davemloft.net>, 
	David Ahern <dsahern@kernel.org>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>, 
	Maxime Coquelin <mcoquelin.stm32@gmail.com>, Alexandre Torgue <alexandre.torgue@foss.st.com>, 
	Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, ebpf@linuxfoundation.org, 
	Bastien Curutchet <bastien.curutchet@bootlin.com>, 
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>, Xu Kuohai <xukuohai@huawei.com>, bpf@vger.kernel.org, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com, 
	linux-arm-kernel@lists.infradead.org, kasan-dev@googlegroups.com, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 9F84840007
X-Stat-Signature: 798kueqhm4jeh96w1g1pt4zbxh3rcaon
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1776118841-538434
X-HE-Meta: U2FsdGVkX1+gH/ohWYV63G/BPGND1PaGfGBoenlnI5eqpSriBShCFa2GBhBL+rjBW9wdPm66npSNwLdoGJZcPHeiJKW5qDSvoIuioAuszW7ar3xrCXw8xTKqK9CUMcr25kSdXPCgqCs44dSwIr38FjPtIYaxBPC35ofWbteeXz/FSS/UTYDYjc8LzgvtGCax4xQ4PHjSh7s5xC6phGK4oMjt4kXTxqo4KZBwlnggA4kwTyCVUt/eaQpvgQPURxESpy1Jrgr2B8YQns2cCViYdQTr8O7HqZTtLFDK4rFBG+Xz0tJx3nfGS2cJ2JW0wFzoXV7nQZ1ARyhDRzLWxUmtWd1kNDPvIRwdJbU079UkPJNQInSmoVfFT9j6zXAcxAEM6TAr6pJ2ZgJSAGqBmEwXZV75Wxx17y6VPMDCq5u6T9wnU4O92c0i8UBeW0nl3VB+7S/+1bBIHx5FQyXUpdIyQbWrkVKaOlW0P72NQWiFgIIpJaphLsOzEzcFMwofxsQHnxOjTHrDOtY/ZixK8hpWlqMnA2B+DfyJD4IJtJAE99Iexrw14nuKLPlWUg/KP7gsSw884Mcjik2W7TqqDKZCQ4mMz/TmimSycMSwu/buB9kujzMezHe15Qk4mBH5IAGxtMUqpEyIJ21FmkTqsyOJAW6cJZPM0W10FMVCoZPWrKZUkfhPm+YGgr8uVKVJoa8v74isNu6BWsY5Q5L3mVAcTqAZCWiLepm0jdLpP0xtFCXQbzyteHwQMCcgn4xUJiXqpBUPZQIfAO6IdL+8eAlqupq7/YGSUvMIVx5tV4x9dYvtGvNwvJGB70TSLbU4yoEYD0YVjmQyH0icLUNrRTlsZNm1IwxmLIYwghProxeUwQQOVknpw7GPedgLZTrsb5j1924Vdzq4CRMwBL07p04DRXDwbwrFXE/7e3IIREaHq2kbksZIBIzx1Xm4KuEXnR7tryjbFqed3GELGoM0HvM
 tKarRIPD
 Oc4fnCoxIvMVPpLSaGV4UBGoICWO50UzMrxNa7INmYrMI80g2KHLmWF1A1v2CbrTbz5Zy2xzqgGSXK2bro7OmXNOTLvSn2R5C7Ko+vS5ZCBjb7P8rH0+dnHaaezncr51lbSAVlSoLBHrs4Y9eJVSHUh4EJbWZf3Naun96KNFgiD4eCZJ/TOK6pOgELuPWxAd8wgUW3Eit7yw3JrgWe2r7/ZHQGK1g+oBB/FG29WWGiFROCZVjNF0VLKby65z2Ek3nHnHGQq8+uGy5gLsdAZGzGFDMVn55fo2RRiEcX2IMkpnhSLQdErjwb8LMl4b9xv658sYm3GqxpOUD/kX5PbazVGPzbfe83NMNNtWLfb5o7pqSJ43K85MRqrTWwJU/3t3RbE+5patKshATQMF0vOvkF9NE0H7BXB1Bti4gJcPzmQ1zxUCRFCNPUvnCP2e+xKDpjwThoN2RzX9sTe7utCVCWtWsK2b1ZzQAFs6FOo8MNQ4pZ6zsspYFJ8F/oBTKILFHJVdpoycQZKSxN05P40FqAlz2Zw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 13, 2026 at 8:29=E2=80=AFPM Alexis Lothor=C3=A9 (eBPF Foundatio=
n)
<alexis.lothore@bootlin.com> wrote:
>
> Add a basic KASAN test runner that loads and test-run programs that can
> trigger memory management bugs. The test captures kernel logs and ensure
> that the expected KASAN splat is emitted by searching for the
> corresponding first lines in the report.
>
> This version implements two faulty programs triggering either a
> user-after-free, or an out-of-bounds memory usage. The bugs are
> triggered thanks to some dedicated kfuncs in bpf_testmod.c, but two
> different techniques are used, as some cases can be quite hard to
> trigger in a pure "black box" approach:
> - for reads, we can make the used kfuncs return some faulty pointers
>   that ebpf programs will manipulate, they will generate legitimate
>   kasan reports as a consequence
> - applying the same trick for faulty writes is harder, as ebpf programs
>   can't write kernel data freely. So ebpf programs can call another
>   specific testing kfunc that will alter the shadow memory matching the
>   passed memory (eg: a map). When the program will try to write to the
>   corresponding memory, it will trigger a report as well.
>
> Signed-off-by: Alexis Lothor=C3=A9 (eBPF Foundation) <alexis.lothore@boot=
lin.com>
> ---
> The way of bringing kasan_poison into bpf_testmod is definitely not
> ideal.  But I would like to validate the testing approach (triggering
> real faulty accesses, which is hard on some cases, VS manually poisoning
> BPF-manipulated memory) before eventually making clean bridges between
> KASAN APIs and bpf_testmod.c, if the latter approach is the valid one.

Would it make sense to put these tests into KASAN KUnit tests in
mm/kasan/kasan_test_c.c? I assume there is a kernel API to JIT BPF
programs from the kernel itself?

There, you can just call kasan_poison(), some tests already do this.
And you can also extend the KASAN KUnit test framework to find out
whether the bad access is a read or write, if you want to check this.



> ---
>  tools/testing/selftests/bpf/prog_tests/kasan.c     | 165 +++++++++++++++=
++++++
>  tools/testing/selftests/bpf/progs/kasan.c          | 146 +++++++++++++++=
+++
>  .../testing/selftests/bpf/test_kmods/bpf_testmod.c |  79 ++++++++++
>  3 files changed, 390 insertions(+)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/kasan.c b/tools/testi=
ng/selftests/bpf/prog_tests/kasan.c
> new file mode 100644
> index 000000000000..fd628aaa8005
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/kasan.c
> @@ -0,0 +1,165 @@
> +// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
> +#include <bpf/bpf.h>
> +#include <fcntl.h>
> +#include <linux/if_ether.h>
> +#include <sys/klog.h>
> +#include <test_progs.h>
> +#include <unpriv_helpers.h>
> +#include "kasan.skel.h"
> +
> +#define SUBTEST_NAME_MAX_LEN   64
> +#define SYSLOG_ACTION_READ_ALL 3
> +#define SYSLOG_ACTION_CLEAR    5
> +
> +#define MAX_LOG_SIZE           (8*1024)
> +#define READ_CHUNK_SIZE                128
> +
> +#define KASAN_PATTERN_SLAB_UAF "BUG: KASAN: slab-use-after-free in bpf_p=
rog_"
> +#define KASAN_PATTERN_GLOBAL_OOB "BUG: KASAN: global-out-of-bounds in bp=
f_prog_"
> +
> +static char klog_buffer[MAX_LOG_SIZE];
> +
> +static int read_kernel_logs(char *buf, size_t max_len)
> +{
> +       return klogctl(SYSLOG_ACTION_READ_ALL, buf, max_len);
> +}
> +
> +static int clear_kernel_logs(void)
> +{
> +       return klogctl(SYSLOG_ACTION_CLEAR, NULL, 0);
> +}
> +
> +static int kernel_logs_have_matching_kasan_report(char *buf, char *patte=
rn,
> +                                                 bool is_write, int size=
)
> +{
> +       char *access_desc_start, *access_desc_end, *tmp;
> +       char access_log[READ_CHUNK_SIZE];
> +       char *kasan_report_start;
> +       int hsize, nsize;
> +       /* Searched kasan report is valid if
> +        * - it contains the expected kasan pattern
> +        * - the next line is the description of the faulty access
> +        * - faulty access properties match the tested type and size
> +        */
> +       kasan_report_start =3D strstr(buf, pattern);
> +
> +       if (!kasan_report_start)
> +               return 1;
> +
> +       /* Find next line */
> +       access_desc_start =3D strchr(kasan_report_start, '\n');
> +       if (!access_desc_start)
> +               return 1;
> +       access_desc_start++;
> +
> +       access_desc_end =3D strchr(access_desc_start, '\n');
> +       if (!access_desc_end)
> +               return 1;
> +
> +       nsize =3D snprintf(access_log, READ_CHUNK_SIZE, "%s of size %d at=
 addr",
> +                is_write ? "Write" : "Read", size);
> +
> +       hsize =3D access_desc_end - access_desc_start;
> +       tmp =3D memmem(access_desc_start, hsize, access_log, nsize);
> +
> +       if (!tmp)
> +               return 1;
> +
> +       return 0;
> +}
> +
> +struct test_spec {
> +       char *prog_name;
> +       char *expected_report_pattern;
> +};
> +
> +static struct test_spec tests[] =3D {
> +       {
> +               .prog_name =3D "bpf_kasan_uaf",
> +               .expected_report_pattern =3D KASAN_PATTERN_SLAB_UAF
> +       },
> +       {
> +               .prog_name =3D "bpf_kasan_oob",
> +               .expected_report_pattern =3D KASAN_PATTERN_GLOBAL_OOB
> +       }
> +};
> +
> +static void run_test_with_type_and_size(struct kasan *skel,
> +                                       struct test_spec *test, bool is_w=
rite,
> +                                       int access_size)
> +{
> +       char subtest_name[SUBTEST_NAME_MAX_LEN];
> +       struct bpf_program *prog;
> +       uint8_t buf[ETH_HLEN];
> +       int ret;
> +
> +       prog =3D bpf_object__find_program_by_name(skel->obj, test->prog_n=
ame);
> +       if (!ASSERT_OK_PTR(prog, "find test prog"))
> +               return;
> +
> +       snprintf(subtest_name, SUBTEST_NAME_MAX_LEN, "%s_%s_%d",
> +                test->prog_name, is_write ? "write" : "read", access_siz=
e);
> +
> +       if (!test__start_subtest(subtest_name))
> +               return;
> +
> +       ret =3D clear_kernel_logs();
> +       if (!ASSERT_OK(ret, "reset log buffer"))
> +               return;
> +
> +       LIBBPF_OPTS(bpf_test_run_opts, topts);
> +       topts.sz =3D sizeof(struct bpf_test_run_opts);
> +       topts.data_size_in =3D ETH_HLEN;
> +       topts.data_in =3D buf;
> +       skel->bss->is_write =3D is_write;
> +       skel->bss->access_size =3D access_size;
> +       ret =3D bpf_prog_test_run_opts(bpf_program__fd(prog), &topts);
> +       if (!ASSERT_OK(ret, "run prog"))
> +               return;
> +
> +       ret =3D read_kernel_logs(klog_buffer, MAX_LOG_SIZE);
> +       if (ASSERT_GE(ret, 0, "read kernel logs"))
> +               ASSERT_OK(kernel_logs_have_matching_kasan_report(
> +                                 klog_buffer, test->expected_report_patt=
ern,
> +                                 is_write, access_size),
> +                         test->prog_name);
> +}
> +
> +static void run_test_with_type(struct kasan *skel, struct test_spec *tes=
t,
> +                              bool is_write)
> +{
> +       run_test_with_type_and_size(skel, test, is_write, 1);
> +       run_test_with_type_and_size(skel, test, is_write, 2);
> +       run_test_with_type_and_size(skel, test, is_write, 4);
> +       run_test_with_type_and_size(skel, test, is_write, 8);
> +}
> +
> +static void run_test(struct kasan *skel, struct test_spec *test)
> +{
> +       run_test_with_type(skel, test, false);
> +       run_test_with_type(skel, test, true);
> +}
> +
> +void test_kasan(void)
> +{
> +       struct test_spec *test;
> +       struct kasan *skel;
> +       int i;
> +
> +       if (!is_jit_enabled() || !get_kasan_jit_enabled()) {
> +               test__skip();
> +               return;
> +       }
> +
> +       skel =3D kasan__open_and_load();
> +       if (!ASSERT_OK_PTR(skel, "open and load prog"))
> +               return;
> +
> +       for (i =3D 0; i < ARRAY_SIZE(tests); i++) {
> +               test =3D &tests[i];
> +
> +               run_test(skel, test);
> +       }
> +
> +       kasan__destroy(skel);
> +}
> diff --git a/tools/testing/selftests/bpf/progs/kasan.c b/tools/testing/se=
lftests/bpf/progs/kasan.c
> new file mode 100644
> index 000000000000..f713c9b7c9ce
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/kasan.c
> @@ -0,0 +1,146 @@
> +// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
> +
> +#include <linux/bpf.h>
> +#include <bpf/bpf_helpers.h>
> +#include <bpf/bpf_tracing.h>
> +
> +#define KASAN_SLAB_FREE 0xFB
> +#define KASAN_GLOBAL_REDZONE 0xF9
> +
> +extern __u8 *bpf_kfunc_kasan_uaf_1(void) __ksym;
> +extern __u16 *bpf_kfunc_kasan_uaf_2(void) __ksym;
> +extern __u32 *bpf_kfunc_kasan_uaf_4(void) __ksym;
> +extern __u64 *bpf_kfunc_kasan_uaf_8(void) __ksym;
> +extern __u8 *bpf_kfunc_kasan_oob_1(void) __ksym;
> +extern __u16 *bpf_kfunc_kasan_oob_2(void) __ksym;
> +extern __u32 *bpf_kfunc_kasan_oob_4(void) __ksym;
> +extern __u64 *bpf_kfunc_kasan_oob_8(void) __ksym;
> +extern void bpf_kfunc_kasan_poison(void *mem, __u32 mem__sz, __u8 byte) =
__ksym;
> +
> +int access_size;
> +int is_write;
> +
> +struct kasan_write_val {
> +       __u8 data_1;
> +       __u16 data_2;
> +       __u32 data_4;
> +       __u64 data_8;
> +};
> +
> +struct {
> +       __uint(type, BPF_MAP_TYPE_ARRAY);
> +       __uint(max_entries, 1);
> +       __type(key, __u32);
> +       __type(value, struct kasan_write_val);
> +} test_map SEC(".maps");
> +
> +static void bpf_kasan_faulty_write(int size, __u8 poison_byte)
> +{
> +       struct kasan_write_val *val;
> +       __u32 key =3D 0;
> +
> +       val =3D bpf_map_lookup_elem(&test_map, &key);
> +       if (!val)
> +               return;
> +
> +       bpf_kfunc_kasan_poison(val, sizeof(struct kasan_write_val),
> +                              poison_byte);
> +       switch (size) {
> +       case 1:
> +               val->data_1 =3D 0xAA;
> +               break;
> +       case 2:
> +               val->data_2 =3D 0xAA;
> +               break;
> +       case 4:
> +               val->data_4 =3D 0xAA;
> +               break;
> +       case 8:
> +               val->data_8 =3D 0xAA;
> +               break;
> +       }
> +       bpf_kfunc_kasan_poison(val, sizeof(struct kasan_write_val), 0x00)=
;
> +}
> +
> +
> +static int bpf_kasan_uaf_read(int size)
> +{
> +       __u8 *result_1;
> +       __u16 *result_2;
> +       __u32 *result_4;
> +       __u64 *result_8;
> +       int ret =3D 0;
> +
> +       switch (size) {
> +       case 1:
> +               result_1 =3D bpf_kfunc_kasan_uaf_1();
> +               ret =3D result_1[0] ? 1 : 0;
> +               break;
> +       case 2:
> +               result_2 =3D bpf_kfunc_kasan_uaf_2();
> +               ret =3D result_2[0] ? 1 : 0;
> +               break;
> +       case 4:
> +               result_4 =3D bpf_kfunc_kasan_uaf_4();
> +               ret =3D result_4[0] ? 1 : 0;
> +               break;
> +       case 8:
> +               result_8 =3D bpf_kfunc_kasan_uaf_8();
> +               ret =3D result_8[0] ? 1 : 0;
> +               break;
> +       }
> +       return ret;
> +}
> +
> +SEC("tcx/ingress")
> +int bpf_kasan_uaf(struct __sk_buff *skb)
> +{
> +       if (is_write) {
> +               bpf_kasan_faulty_write(access_size, KASAN_SLAB_FREE);
> +               return 0;
> +       }
> +
> +       return bpf_kasan_uaf_read(access_size);
> +}
> +
> +static int bpf_kasan_oob_read(int size)
> +{
> +       __u8 *result_1;
> +       __u16 *result_2;
> +       __u32 *result_4;
> +       __u64 *result_8;
> +       int ret =3D 0;
> +
> +       switch (size) {
> +       case 1:
> +               result_1 =3D bpf_kfunc_kasan_oob_1();
> +               ret =3D result_1[0] ? 1 : 0;
> +               break;
> +       case 2:
> +               result_2 =3D bpf_kfunc_kasan_oob_2();
> +               ret =3D result_2[0] ? 1 : 0;
> +               break;
> +       case 4:
> +               result_4 =3D bpf_kfunc_kasan_oob_4();
> +               ret =3D result_4[0] ? 1 : 0;
> +               break;
> +       case 8:
> +               result_8 =3D bpf_kfunc_kasan_oob_8();
> +               ret =3D result_8[0] ? 1 : 0;
> +               break;
> +       }
> +       return ret;
> +}
> +
> +SEC("tcx/ingress")
> +int bpf_kasan_oob(struct __sk_buff *skb)
> +{
> +       if (is_write) {
> +               bpf_kasan_faulty_write(access_size, KASAN_GLOBAL_REDZONE)=
;
> +               return 0;
> +       }
> +
> +       return bpf_kasan_oob_read(access_size);
> +}
> +
> +char LICENSE[] SEC("license") =3D "GPL";
> diff --git a/tools/testing/selftests/bpf/test_kmods/bpf_testmod.c b/tools=
/testing/selftests/bpf/test_kmods/bpf_testmod.c
> index d876314a4d67..01554bcbbbb0 100644
> --- a/tools/testing/selftests/bpf/test_kmods/bpf_testmod.c
> +++ b/tools/testing/selftests/bpf/test_kmods/bpf_testmod.c
> @@ -271,6 +271,76 @@ __bpf_kfunc void bpf_kfunc_put_default_trusted_ptr_t=
est(struct prog_test_member
>          */
>  }
>
> +static void *kasan_uaf(void)
> +{
> +       void *p =3D kmalloc(64, GFP_ATOMIC);
> +
> +       if (!p)
> +               return NULL;
> +       memset(p, 0xAA, 64);
> +       kfree(p);
> +
> +       return p;
> +}
> +
> +#ifdef CONFIG_KASAN_GENERIC
> +extern void kasan_poison(const void *addr, size_t size, u8 value, bool i=
nit);
> +
> +__bpf_kfunc void bpf_kfunc_kasan_poison(void *mem, u32 mem__sz, u8 byte)
> +{
> +       kasan_poison(mem, mem__sz, byte, false);
> +}
> +#else
> +__bpf_kfunc void bpf_kfunc_kasan_poison(void *mem, u32 mem__sz, u8 byte)=
 { }
> +#endif
> +
> +__bpf_kfunc u8 *bpf_kfunc_kasan_uaf_1(void)
> +{
> +       return kasan_uaf();
> +}
> +
> +__bpf_kfunc u16 *bpf_kfunc_kasan_uaf_2(void)
> +{
> +       return kasan_uaf();
> +}
> +
> +__bpf_kfunc u32 *bpf_kfunc_kasan_uaf_4(void)
> +{
> +       return kasan_uaf();
> +}
> +
> +__bpf_kfunc u64 *bpf_kfunc_kasan_uaf_8(void)
> +{
> +       return kasan_uaf();
> +}
> +
> +static u8 test_oob_buffer[64];
> +
> +static void *bpf_kfunc_kasan_oob(void)
> +{
> +       return test_oob_buffer+64;
> +}
> +
> +__bpf_kfunc u8 *bpf_kfunc_kasan_oob_1(void)
> +{
> +       return bpf_kfunc_kasan_oob();
> +}
> +
> +__bpf_kfunc u16 *bpf_kfunc_kasan_oob_2(void)
> +{
> +       return bpf_kfunc_kasan_oob();
> +}
> +
> +__bpf_kfunc u32 *bpf_kfunc_kasan_oob_4(void)
> +{
> +       return bpf_kfunc_kasan_oob();
> +}
> +
> +__bpf_kfunc u64 *bpf_kfunc_kasan_oob_8(void)
> +{
> +       return bpf_kfunc_kasan_oob();
> +}
> +
>  __bpf_kfunc struct bpf_testmod_ctx *
>  bpf_testmod_ctx_create(int *err)
>  {
> @@ -740,6 +810,15 @@ BTF_ID_FLAGS(func, bpf_testmod_ops3_call_test_1)
>  BTF_ID_FLAGS(func, bpf_testmod_ops3_call_test_2)
>  BTF_ID_FLAGS(func, bpf_kfunc_get_default_trusted_ptr_test);
>  BTF_ID_FLAGS(func, bpf_kfunc_put_default_trusted_ptr_test);
> +BTF_ID_FLAGS(func, bpf_kfunc_kasan_poison)
> +BTF_ID_FLAGS(func, bpf_kfunc_kasan_uaf_1)
> +BTF_ID_FLAGS(func, bpf_kfunc_kasan_uaf_2)
> +BTF_ID_FLAGS(func, bpf_kfunc_kasan_uaf_4)
> +BTF_ID_FLAGS(func, bpf_kfunc_kasan_uaf_8)
> +BTF_ID_FLAGS(func, bpf_kfunc_kasan_oob_1)
> +BTF_ID_FLAGS(func, bpf_kfunc_kasan_oob_2)
> +BTF_ID_FLAGS(func, bpf_kfunc_kasan_oob_4)
> +BTF_ID_FLAGS(func, bpf_kfunc_kasan_oob_8)
>  BTF_KFUNCS_END(bpf_testmod_common_kfunc_ids)
>
>  BTF_ID_LIST(bpf_testmod_dtor_ids)
>
> --
> 2.53.0
>

