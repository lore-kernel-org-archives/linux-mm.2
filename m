Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE0B7EB2712
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 20:37:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AE296B0005; Tue, 10 Feb 2026 15:37:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 258246B0089; Tue, 10 Feb 2026 15:37:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15A606B008A; Tue, 10 Feb 2026 15:37:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0695E6B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 15:37:51 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AE94F13B94D
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 20:37:50 +0000 (UTC)
X-FDA: 84429708300.28.B5E9986
Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8DF0BC000B
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 20:37:48 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=mihalicyn.com header.s=mihalicyn header.b=Jbjag+Fl;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf10.hostedemail.com: domain of alexander@mihalicyn.com designates 209.85.128.175 as permitted sender) smtp.mailfrom=alexander@mihalicyn.com;
	dmarc=pass (policy=quarantine) header.from=mihalicyn.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770755868;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qlZ4xyzf/Ip4fodbzXtwn4FA9xAkiKblH6NpEXTYsSQ=;
	b=0I1mURv2IG56tAEZuMmHf/CEaTBvEg/8IlJJt2YrFWExwGOoKCj1lwaQPI1U0/H2FokJoI
	qkXGR7jd3nIdAUPdjs92O0u5SlJb2d9JZhYk5zXIs8SI1lLaS88ZCsk+7GIaOYwfvfhMdM
	7KJUsmteTJfZ5XSDT9qr2KJJjvSkUbk=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770755868; a=rsa-sha256;
	cv=pass;
	b=BAuoP2SEqhtnEr72zwYae5NzW0kASCLUNQotSm44qaWxBB9qsOA33pYKcXsLBnDDAMpaRI
	rN1G/XtHo5PagmxCL3UUZszsGpAnjiQSvNNttkY6mtpFi9CGEKv/tYoWH86bhYYnVerhNi
	NRFa/ujFsX6OiNE29YMWc3OktM95F9E=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=mihalicyn.com header.s=mihalicyn header.b=Jbjag+Fl;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf10.hostedemail.com: domain of alexander@mihalicyn.com designates 209.85.128.175 as permitted sender) smtp.mailfrom=alexander@mihalicyn.com;
	dmarc=pass (policy=quarantine) header.from=mihalicyn.com
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-79495b1aaa7so60787257b3.1
        for <linux-mm@kvack.org>; Tue, 10 Feb 2026 12:37:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770755867; cv=none;
        d=google.com; s=arc-20240605;
        b=T9yC9omNchpY3dojZhlbu1ngBwoGa9DH/Qz0DEa3PuKMeoXizaN/n7aR/d4xiafn4Q
         bq7Ae+NPLpOWekVnqpMNu/rx9o9D1GKl6p1SF/d72CG2G4ANRC1po03189Awb/1TC2Td
         A5TYlm50oPthtSWwVfxEDoIeZmq2Hc6fNOxDoGQoOj+C352NXWbZJNMfML9xPDSnhke6
         tmJnO6sziWdFoXfIOJYBG95vcJwt1/Kmipc29GTUtJEoQ9ukKd8z2LdTncxReCvvmIBx
         hX6jZB2Gq/OM6c8CviI+9pxf822kxHzR8bzbpuf+ILgTGJAhqB8rItAGiuvxuR1T1bKr
         xUQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=qlZ4xyzf/Ip4fodbzXtwn4FA9xAkiKblH6NpEXTYsSQ=;
        fh=KckWG56U4qDwLbk4v+hgXPH6ZHfLb5Pb06EggMvGZso=;
        b=UIBuvhZIY6E4E+Nby/Vl551k82fQzLpin0i/U7uAJ37S47R+uke04eYt6pCnqteu2C
         Ui+d9v+2JedPWkROj214BPeWCHb6C+uxYwXEqhU3PH4BWKPNN0Am/3w9HMV6F2+/3uMX
         eAmupZmfaG48qC5vnymcDX5Nn3p8JNKvVDL5knQuPEdmMAodHelP2A3mGKaZmghQrnU8
         8vT99fJ2bT+cLDq762D2ib+z2mPou9ra3CXOVXeyPryrOeU4lixMZ8qdZ3zDLPa37HVM
         h/0/qSJrxQjT/qP4+UuzvWaHbXyJh/IhDxTHzM8AgJ5iUrz8sWgDnq0EPL099OXEcuaX
         S3Sw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mihalicyn.com; s=mihalicyn; t=1770755867; x=1771360667; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=qlZ4xyzf/Ip4fodbzXtwn4FA9xAkiKblH6NpEXTYsSQ=;
        b=Jbjag+Fl534N+6+PDRCYaHLXl24f0Fnv4wV6JE8cHs1ZlXUn842SSIUW8oy3+zKbeb
         r+KN+FSLkr/ox2cnnsIc7P3gfK+0rYtQ4OmeZLQ5jbIBBQCub6rjeree3HschqZ0oOH1
         XFzkjnZsBvgbPF8DWESNGvBdHkN/UhbuBk6jc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770755867; x=1771360667;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qlZ4xyzf/Ip4fodbzXtwn4FA9xAkiKblH6NpEXTYsSQ=;
        b=NMcl3JrOSz8oEyDiLllGeIOCR1BpiA5i6vFP0VwVyqLzwvQzaSpAmtp3e63kZq1fmo
         wg2BZtm2MyyDqlKErqqD6uYM9MzRU8naAc8/EeIylaztfFmO1l+gdyI1GpTOwyN20y+E
         ehl7Vxsw9EPiiltbBDdgwUbc1UPA7anMAmjgsLj0TZMKJWQ+hYdKRJgMkqu7f8zdjaTb
         ecto3OBRaI7M0KwtYH22LGGDJA57zxR06omatpw0/hWfcZi29YtUnug9rmDZDDlOOLnZ
         VqAh/kPL+/+x+vo+tx25nPuTPo2nr19eIXSzPmTIesYdw49gas9EbmJX3qEc+fWrxKss
         Karg==
X-Forwarded-Encrypted: i=1; AJvYcCXl7YIqPWI4iVi+C0CqJIg55MgL/EmYiSr0khjYECFNC8pRL6LGj1qhJaw6t9VIg65xfuIRO/Ds7A==@kvack.org
X-Gm-Message-State: AOJu0YwKfIhrg+m/FnzVy9UQ3agGIDbVDP0vLX9MLb47doa4yCTGI9XR
	nhhrPSW11LRtrFUJ/F6J3ULbrH4dvdb5XYHdPMke3HQA6P2otbZ3QBtI64AUZ3cum6qJAmpOR1l
	cDh6sZ1H9A5jKe6Styhyo3E0qui/mMiX0eTY975dkRQ==
X-Gm-Gg: AZuq6aJLkyfExykjQ89ue2JPhCbE5Otu7pF7UoJFM8v/ngTNP06VpI2slwnpPZEPRLo
	FnT7VvXH8R4P9ouwhTOtaZZV2Po8Au0yWYKJHwbJLOjSOUGMJSrKVJ7QMaajKDNpFGDMzqkEJ85
	vVRfRAt0Tuo0BPR03Q2nqEMnzCVbcuIR/BGVXADq4z195cdhN5QAYv75YirXlhIYyZ7ZpUiBAjO
	v8AZgcbAcZ1+yacm4NvMvIue3ev8QfnJXbLIVeeoLbcsykRX3kcfPE1aEEytk7CNWsnjT0SakW6
	XgKb1HvgJ/R/7VugwGsMLMvK+e9Hmtid8hcNPJo=
X-Received: by 2002:a05:690c:c50c:b0:794:c679:1d1d with SMTP id
 00721157ae682-7965efaa2camr29027447b3.24.1770755867381; Tue, 10 Feb 2026
 12:37:47 -0800 (PST)
MIME-Version: 1.0
References: <20260209190605.1564597-1-avagin@google.com> <20260209190605.1564597-5-avagin@google.com>
In-Reply-To: <20260209190605.1564597-5-avagin@google.com>
From: Alexander Mikhalitsyn <alexander@mihalicyn.com>
Date: Tue, 10 Feb 2026 21:37:34 +0100
X-Gm-Features: AZwV_Qh72JA-cEZtTCmkRnGPAQAW0gnIwzAXo_f1l64-sLCqrTNi2ouzycVcpIs
Message-ID: <CAJqdLrow_EEda3Gw8Q9E2VF9pWxa7COUu88fZZiP1-=Mk00DqA@mail.gmail.com>
Subject: Re: [PATCH 4/4] selftests/exec: add test for HWCAP inheritance
To: Andrei Vagin <avagin@google.com>
Cc: Kees Cook <kees@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Cyrill Gorcunov <gorcunov@gmail.com>, Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, criu@lists.linux.dev, 
	Chen Ridong <chenridong@huawei.com>, Christian Brauner <brauner@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Eric Biederman <ebiederm@xmission.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Michal Koutny <mkoutny@suse.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 8DF0BC000B
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 6x6n7zwx7ckzhxzkdej5u9iei1g5yqdd
X-HE-Tag: 1770755868-308364
X-HE-Meta: U2FsdGVkX19iT1rVYUH7XQOQoM0LRrms7CHdSGgS106kUqLO1wIIV5KEwIAEJ10UwYVJkL1tz+DRbHeWYS3veEkJ4SdyQVo1rqn//8G2sgm/Ly1ZKETMDYpud/kg+NSwVdFEofDeEbu1zAF6S9ek2TGYlIVRwQx3pmOHn4vA94ONMhIAC2EdI5FUaPaVIUvxUVbpbM0eQ/XJxotbu1DrKyRuPbg9AbcwZvNU0mBbu8jRZgZpjnK90hDps3P91MwO9xsUJQMgXtZn3ZOKWsPaEcE5MO6gkBsUkpa3mV+0oQWZoACGOPEbyJSmcjlwm3Q841mL7xxdculcmxvHlIE9dNHFvm7TFDl66Im8E/BP0Y74KcY7u2fbWmdGvR/Xrvbi9Sqap3x+U2w0VhLKDiABxq5sVRHdMkYOIeShDT5pwn+GqTzHhY2J2W9nkyvrxau+FxUMxyRszWSu/BWkPaqHSR0jHezjMLSeBll7GlTytlgTDKEic2fmxGL7hpXW/QstqUJdtEbKAENhcIBdo67M+dEdBVj6ed2JrvfvRvXZ5JUITfO5drY+gNCh6Wlt4QbiT+2dxAbMY3Xg8oufPIsHa09zmODjcyskeNkvzem8eyWgyaNcH5uAB8mOSidHEZnol2ZRiEw1XbqbqpAvK0ywyMG7Ngpfg5wIsTkgcZTPs0fu7iXh7ydm5I3lx21vnKZ4owt4dq865kfxuMxOMbDRPewVH7eaOz3EflMGhOtVGmuNawdNeIZeF1Oimf+TgCpUVsUQAoTH6mm+kwPTPvqppbXxiPiV7Uk68S20EITFVvVAQMRCsaY6Otq1VW7A7CjOGKp7RiB+qC/C+HVWPX2Ew5RLRX2b4QcQP8pkVqFNqCtKMbS+2WD8fLduGJj4v3YXO78PnbyxQG2Lze54g4Mq6mVMOZnSpzGVU1BggaDt6xYgv6XSOcPU/mlQoqTzX7UL5Yuqdg8w2ITy3sIN55u
 Sqyz46LH
 DC0CFawUbQGdeRej2Ijp5/h3t5eB9drtxu1i7U3HL05Bc9NL5wnN/L6GwlCLxTB7hqgwTq7gUjvyiuX9Er9G932FBN/4k5O7vL8kmux+W/GwowNzWV7orEilSAEh/ttWHcqoTQmc/josoF95vHNS4qvNquFI3APf8KdwC11knn8Kr49k7J2zdLu44sXY7Ql3dgvZvWAV97jQr9bp6I9PZFvbz7BYtqzUJLjfpWFnwBMJDie/jcjtpu2RFUW/ZT1MxFDnA4kBYMN2DrQBan2YsF6sffw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Am Mo., 9. Feb. 2026 um 20:06 Uhr schrieb Andrei Vagin <avagin@google.com>:
>
> Verify that HWCAPs are correctly inherited/preserved across execve() when
> modified via prctl(PR_SET_MM_AUXV).
>
> The test performs the following steps:
> * reads the current AUXV using prctl(PR_GET_AUXV);
> * finds an HWCAP entry and toggles its most significant bit;
> * replaces the AUXV of the current process with the modified one using
>   prctl(PR_SET_MM, PR_SET_MM_AUXV);
> * executes itself to verify that the new program sees the modified HWCAP
>   value.
>
> Signed-off-by: Andrei Vagin <avagin@google.com>

Reviewed-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@futurfusion.io>

> ---
>  tools/testing/selftests/exec/.gitignore      |   1 +
>  tools/testing/selftests/exec/Makefile        |   1 +
>  tools/testing/selftests/exec/hwcap_inherit.c | 105 +++++++++++++++++++
>  3 files changed, 107 insertions(+)
>  create mode 100644 tools/testing/selftests/exec/hwcap_inherit.c
>
> diff --git a/tools/testing/selftests/exec/.gitignore b/tools/testing/selftests/exec/.gitignore
> index 7f3d1ae762ec..2ff245fd0ba6 100644
> --- a/tools/testing/selftests/exec/.gitignore
> +++ b/tools/testing/selftests/exec/.gitignore
> @@ -19,3 +19,4 @@ null-argv
>  xxxxxxxx*
>  pipe
>  S_I*.test
> +hwcap_inherit
> \ No newline at end of file
> diff --git a/tools/testing/selftests/exec/Makefile b/tools/testing/selftests/exec/Makefile
> index 45a3cfc435cf..e73005965e05 100644
> --- a/tools/testing/selftests/exec/Makefile
> +++ b/tools/testing/selftests/exec/Makefile
> @@ -20,6 +20,7 @@ TEST_FILES := Makefile
>  TEST_GEN_PROGS += recursion-depth
>  TEST_GEN_PROGS += null-argv
>  TEST_GEN_PROGS += check-exec
> +TEST_GEN_PROGS += hwcap_inherit
>
>  EXTRA_CLEAN := $(OUTPUT)/subdir.moved $(OUTPUT)/execveat.moved $(OUTPUT)/xxxxx*        \
>                $(OUTPUT)/S_I*.test
> diff --git a/tools/testing/selftests/exec/hwcap_inherit.c b/tools/testing/selftests/exec/hwcap_inherit.c
> new file mode 100644
> index 000000000000..1b43b2dbb1d0
> --- /dev/null
> +++ b/tools/testing/selftests/exec/hwcap_inherit.c
> @@ -0,0 +1,105 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#define _GNU_SOURCE
> +#include <sys/auxv.h>
> +#include <sys/prctl.h>
> +#include <sys/wait.h>
> +#include <linux/prctl.h>
> +#include <unistd.h>
> +#include <stdlib.h>
> +#include <stdio.h>
> +#include <string.h>
> +#include <errno.h>
> +#include <elf.h>
> +#include <linux/auxvec.h>
> +
> +#include "../kselftest.h"
> +
> +static int find_msb(unsigned long v)
> +{
> +       return sizeof(v)*8 - __builtin_clzl(v) - 1;
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +       unsigned long auxv[1024], hwcap, new_hwcap, hwcap_idx;
> +       int size, hwcap_type = 0, hwcap_feature, count, status;
> +       char hwcap_str[32], hwcap_type_str[32];
> +       pid_t pid;
> +
> +       if (argc > 1 && strcmp(argv[1], "verify") == 0) {
> +               unsigned long type = strtoul(argv[2], NULL, 16);
> +               unsigned long expected = strtoul(argv[3], NULL, 16);
> +               unsigned long hwcap = getauxval(type);
> +
> +               if (hwcap != expected) {
> +                       ksft_print_msg("HWCAP mismatch: type %lx, expected %lx, got %lx\n",
> +                                       type, expected, hwcap);
> +                       return 1;
> +               }
> +               ksft_print_msg("HWCAP matched: %lx\n", hwcap);
> +               return 0;
> +       }
> +
> +       ksft_print_header();
> +       ksft_set_plan(1);
> +
> +       size = prctl(PR_GET_AUXV, auxv, sizeof(auxv), 0, 0);
> +       if (size == -1)
> +               ksft_exit_fail_perror("prctl(PR_GET_AUXV)");
> +
> +       count = size / sizeof(unsigned long);
> +
> +       /* Find the "latest" feature and try to mask it out. */
> +       for (int i = 0; i < count - 1; i += 2) {
> +               hwcap = auxv[i + 1];
> +               if (hwcap == 0)
> +                       continue;
> +               switch (auxv[i]) {
> +               case AT_HWCAP4:
> +               case AT_HWCAP3:
> +               case AT_HWCAP2:
> +               case AT_HWCAP:
> +                       hwcap_type = auxv[i];
> +                       hwcap_feature = find_msb(hwcap);
> +                       hwcap_idx = i + 1;
> +                       break;
> +               default:
> +                       continue;
> +               }
> +       }
> +       if (hwcap_type == 0)
> +               ksft_exit_skip("No features found, skipping test\n");
> +       hwcap = auxv[hwcap_idx];
> +       new_hwcap = hwcap ^ (1UL << hwcap_feature);
> +       auxv[hwcap_idx] = new_hwcap;
> +
> +       if (prctl(PR_SET_MM, PR_SET_MM_AUXV, auxv, size, 0) < 0) {
> +               if (errno == EPERM)
> +                       ksft_exit_skip("prctl(PR_SET_MM_AUXV) requires CAP_SYS_RESOURCE\n");
> +               ksft_exit_fail_perror("prctl(PR_SET_MM_AUXV)");
> +       }
> +
> +       pid = fork();
> +       if (pid < 0)
> +               ksft_exit_fail_perror("fork");
> +       if (pid == 0) {
> +               char *new_argv[] = { argv[0], "verify", hwcap_type_str, hwcap_str, NULL };
> +
> +               snprintf(hwcap_str, sizeof(hwcap_str), "%lx", new_hwcap);
> +               snprintf(hwcap_type_str, sizeof(hwcap_type_str), "%x", hwcap_type);
> +
> +               execv(argv[0], new_argv);
> +               perror("execv");
> +               exit(1);
> +       }
> +
> +       if (waitpid(pid, &status, 0) == -1)
> +               ksft_exit_fail_perror("waitpid");
> +       if (status != 0)
> +               ksft_exit_fail_msg("HWCAP inheritance failed (status %d)\n", status);
> +
> +       ksft_test_result_pass("HWCAP inheritance succeeded\n");
> +       ksft_exit_pass();
> +       return 0;
> +}
> --
> 2.53.0.239.g8d8fc8a987-goog
>

