Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 274D1C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 20:14:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1D3C6B0088; Wed,  8 Jul 2026 16:14:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA74B6B008A; Wed,  8 Jul 2026 16:14:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B47C46B008C; Wed,  8 Jul 2026 16:14:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 73BC66B0088
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 16:14:48 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BE750402E7
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 20:14:47 +0000 (UTC)
X-FDA: 84966712614.25.EFE1FEF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4656740002
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 20:14:45 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=A0UxfMaa;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf17.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783541685;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n/dH7u+EpgXCIs6Pm5DlLAIaA07OdnJPol506/hGZPc=;
	b=BXNqGAH4nxi9ngd83DC3xzDkq3g3VJWd/pm4vjcFfiO7nynlRrmqIhj/6fKKUV9Fc0JQkr
	WTFCG8y8neLUO+S8ivbvxZbcxLGl+emEzUcRbm5A+LrPHAsT9Mno/pFO/wxbv7B9451Yb4
	RL7ud/AGzMZKxoPhpDl++3f3JHcPbkw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=A0UxfMaa;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf17.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783541685;
	b=wOJXeQ0sASf9c3uNIU7uBRcHItqE/d+pYbuxxNTCisbEdXDXz3jlI9VrkmguWrEEBEGlE/
	pFC8+i93lR55LkjcACgCVG3JGeohb0XTNzc2WwSvn30VV0ntaBLgflOtYk9bLg7HtXG+pv
	RQ6aP7im1Wbgaa78Y0G4kcgU/hzmWfQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783541684;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=n/dH7u+EpgXCIs6Pm5DlLAIaA07OdnJPol506/hGZPc=;
	b=A0UxfMaaTFVVDaj9LtO/hTMT0TTXZfIqsPflYgTqHn/1auw+rpo4oII2kkVOr1G7NVh3nl
	uTHyq6/9sf3Me5m8azJWz765TsgDaarFTaUJSAawGztECTOs7lrAp/wOE9K6hki0CG+/uO
	HzdscPJnK4Rv9IO0PODPHnx7MhBwjqY=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-308-fmCU1yYzM8aPUUel8WJlvA-1; Wed, 08 Jul 2026 16:14:41 -0400
X-MC-Unique: fmCU1yYzM8aPUUel8WJlvA-1
X-Mimecast-MFC-AGG-ID: fmCU1yYzM8aPUUel8WJlvA_1783541680
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-7e9f6f0240eso1303914a34.3
        for <linux-mm@kvack.org>; Wed, 08 Jul 2026 13:14:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783541680; x=1784146480;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=n/dH7u+EpgXCIs6Pm5DlLAIaA07OdnJPol506/hGZPc=;
        b=MTH0hGXVNDHIIDQUFu/Vy6qoRsU6UNV8RCXRME67yX5gZkqBMKaz6iPtQXArzeqm52
         cAzP7080povq+Qasx8FDR3pT7u7Iz4Ilhmxw4LwkQ0Ri29IiCO/1uTL9ngDnIKnkY1kY
         Pg5U28/8c6Ps2Gi5Mo5ZDdUa//+fpSFVzPxb1naNYXqyEyUiu95IkQ5GUMIsKBdbTMTQ
         iVmjumqUZHx5iS2ppS6niOSJN+XlxS1nF/63QkWWc8gp+OEHfv3En3hcHZV1YA63nV4Q
         H+uQCggscfN4XGNqO20mT5utP5z12BibOe0UJE+dNbB1vODtGHmyecT3FsCJj0YWi9fm
         5Meg==
X-Forwarded-Encrypted: i=1; AFNElJ9QnS+3pVYe1UHdyOE+qs+7XCDnlRlrL6hIoIOhX1/+JX/4UVbasjlXCijCPEz2xhGmYwKnA7tiuw==@kvack.org
X-Gm-Message-State: AOJu0YweTDLoY0WINz1ara85m/kT98S7F0m8ZNx8kiOhdcKdf9AYvsN+
	+cKzRC3906vfi7En1SzHYfymUqg4iePzq8Vf9JpxxkkOrsrB2RoS0wJhaMKp/kNC6IoJ8dUMzN+
	IDZXzS0rt3GQRTZTcDGxDYT8TmbCkid74F9clRS8nvHm7W96+WCpX
X-Gm-Gg: AfdE7cnZylurQWMsWu4mLR+Ew3mAU6jCASTILbLW4KfIuBZbUq7/oTXCk0DmJ+FlBuV
	0T47fle3CjA4sbUDms3xXWaYAai3hjYlXnLuo+sa7VqGW7A9He9J0pABWgbLNFj4ZDnsG4PzSLA
	ayOZnDUL2gmV37G15noIAPjN4pX10nJj+EEVQWhFFiJOYdPGQwCgC9eWPWKFRdrOCFFIBtkbRmb
	z6/LNufd+gDn1oi3lwf/n7I7n4kfy5zCj7bUFAbvB7YXAhBvyCfvY2/i4xx0QMMoCd6rXI0vaOu
	ZJ44+xoahyB6I+iyG5KKObriAGUTx8yU1wLeaB8NWi9qYj3jgSvO3hbvJ9PzqvDXvRzNbopfCWs
	Uj6IshXdqaA==
X-Received: by 2002:a05:6830:2589:b0:7e3:d199:3164 with SMTP id 46e09a7af769-7ebcfe7ad5bmr2983139a34.11.1783541680389;
        Wed, 08 Jul 2026 13:14:40 -0700 (PDT)
X-Received: by 2002:a05:6830:2589:b0:7e3:d199:3164 with SMTP id 46e09a7af769-7ebcfe7ad5bmr2983090a34.11.1783541679717;
        Wed, 08 Jul 2026 13:14:39 -0700 (PDT)
Received: from [192.168.8.207] ([45.81.3.233])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7ebcb2631dfsm2528223a34.13.2026.07.08.13.14.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jul 2026 13:14:38 -0700 (PDT)
Message-ID: <9b0fb337-88e5-484c-8618-09ed2274444e@redhat.com>
Date: Wed, 8 Jul 2026 14:16:12 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests: do not override CFLAGS set by the build
 environment
To: Aleksei Oladko <aleksey.oladko@virtuozzo.com>,
 Shuah Khan <shuah@kernel.org>, Kees Cook <kees@kernel.org>,
 Christian Brauner <brauner@kernel.org>, Seth Forshee <sforshee@kernel.org>,
 Tony Luck <tony.luck@intel.com>, Reinette Chatre
 <reinette.chatre@intel.com>, Dave Martin <Dave.Martin@arm.com>,
 James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>,
 Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>, Paul Walmsley
 <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
 Abhinav Saxena <xandfury@gmail.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, raquini@redhat.com
References: <20260306002100.519673-1-aleksey.oladko@virtuozzo.com>
From: Nico Pache <npache@redhat.com>
In-Reply-To: <20260306002100.519673-1-aleksey.oladko@virtuozzo.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Qk3e9hGrIrRs20_OkdNqFrtK15eK6GFNU3C1D5MmD-Y_1783541680
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4656740002
X-Stat-Signature: gbetf9f3wkz4ufpenbnxahqz6wnew5zj
X-Rspam-User: 
X-HE-Tag: 1783541685-277322
X-HE-Meta: U2FsdGVkX1+RBv1j/TCSzdVk4Nm5ZMDrukug5+EN6y2AJp+tkGIL4tNSqI0w9HnHHiWjGKMQuiQFWFr1lXDTKEnK1H/L7uZ7nb1xGkR7TH5f27RKZZfRLNW4UPWBhukQaI+joFMEN6cwqmqLGnDA40TcnEzvWuypWnPIw6xho3jJXhTYQd9dOXT9ITygNLFlKq0zx2lNPYRJ0nNhPqwe6+My37V24Secb3RNLqKMDRzU0I57rv+K4PyjOGa84iCRHiYPZAbV5qdIVfRyvZZnpn+p6Zv8uQlHqPUcz27IKSJfmd43MZQ3LRJg1Ts+4LCJ/kRKvgJDDcpNzKfjMjGVbpeaU0D7LTAmGdK3BIzw5vuBAtb7SYKTjXqhVecFxXb3IivkyLgQicKha0OrlVIYL6gAg3pr/5Y6h5cOOHz8jQ0WJ3E83qtPrujuOKFuA5xXOQ1qaaUT3OnPpIKFaqDBVTxmGiYIBEMAtIkjkLmE/skF4fOM9AZVNh9bwTFsoaZ7E7Gn67ahfN9E4mitKQCV7LYO6g+ldxp/K/90jy2jtOEWZsSw54JSTbFxdTJZwMxrEEQ3VdvI/dfiRxQEjr1mUpXsLJMdwxu6b6jkq080Hyz5bgi8dAJCy9WXc1bQQW2sfqNRRohZ8859/hTEysWJsG6EKzfRpCbGAjH0DkbIZza9galQCPu2SKBEBhvC1kY5a/K9TCc/EKrankm9FNt/UW1WFgDvqbvsKyILnnVwLdUoRL2yjFEjFgofel1QQcsAhgmWzak0I8oT4H0aCK8lbJpy4lOVOKKz/Ruu4u/9XTVummH6bkdYJDOM8/fuwOGVHF/czIWrMCC5mUqtcBJYrqeEJ6aVZU0K/Q8Aec2+MQulNUGLGxdTe7DByi8kYtRlN7d1Aj6VPN3+0rQD5H5v8v/5R/eiXPejSqdhYn13KS+8LvMrlS57MUCycpvt6wo6+ZYc7k7PWb9nXpCxrpz
 s85tNtgy
 oFDAT5YbeaOlzHtcs9GtcRt5WSGMiW7Aaugb1k08kZ/F1xTGA6KA2oow5hUuxg3JtWlpm/hM3lorrISpEqD6FH+aew0orTjERKKyC4cNsxBrFYG4D64+Nieyt+0GWH7IYtYbOxqE7M+el1/EZ09VUbjTWxsE+Gb1LkH5BQGpcXPV4eJcm7ynTHRJaf5etkB+hV2GhTB61XTgOWLpI1kaNQ6OBzzPylue63XEh+E69ET5A1dSpg2Fhh5DstO+B4uoLbCJfhGuCoh3N1Bb+KQGSI/Bl0t5yZI5dc33pUwY5bQQ2t/1wRoYpUFOK746GI0o9JUTgdj1iL6OUTVSGmz1/2H4jO95OLf6OEgI8RzWItlEqeSh1wzrGUZSpkK3uNBYlDKHU6hpwTd2LDtVOgIoXNTVVt8pLg+S3/AU2IUeLqnPv16aZbo1+RapKB+rpj+ZCj65xPXovlHt2SIDvo6YM6M0Q0ocJIrii3Du1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/5/26 5:21 PM, Aleksei Oladko wrote:
> Some kselftests Makefiles assign CFLAGS using 'CFLAGS=...'
> which overrides any CFLAGS provided by the build environment.
> 
> If the environment set flags, overriding CFLAGS may result in
> inconsistent compiler and linker options and cause build failures,
> for example when building PIE binaries:
> 
>   # export CFLAGS="-fPIE"
>   # export LDFLAGS="-pie"
>   # make -C tools/testing/selftests/ TARGETS=mount_setattr
>   make: Entering directory '/build/kernel/tools/testing/selftests'
>   make[1]: Entering directory '/build/kernel/tools/testing/selftests/mount_setattr'
>     CC       mount_setattr_test
>   /usr/bin/ld: warning: -z pack-relative-relocs ignored
>   /usr/bin/ld: /tmp/ccikConN.o: relocation R_X86_64_32 against `.rodata.str1.8' can not be used when making a PIE object; recompile with -fPIE
>   collect2: error: ld returned 1 exit status
>   make[1]: *** [../lib.mk:222: /build/kernel/tools/testing/selftests/mount_setattr/mount_setattr_test] Error 1
> 
> Fix this by appending to CFLAGS using 'CFLAGS+=' instead of
> overriding them.
> 
> The fix is not applied to the Makefiles in x86, riscv, mm, arm64
> and powerpc as they fully define their flags.
> 
> Signed-off-by: Aleksei Oladko <aleksey.oladko@virtuozzo.com>

This is very much needed (I cant confirm for all the cases you changed here but
we are experiencing the same thing internally).

However this does not apply. Can you please do a refresh/RESEND and hopefully
you get more attention on the second round.

Cheers,
-- Nico


> ---
>  tools/testing/selftests/efivarfs/Makefile             | 2 +-
>  tools/testing/selftests/exec/Makefile                 | 2 +-
>  tools/testing/selftests/firmware/Makefile             | 4 ++--
>  tools/testing/selftests/ipc/Makefile                  | 4 ++--
>  tools/testing/selftests/mount/Makefile                | 4 ++--
>  tools/testing/selftests/mount_setattr/Makefile        | 2 +-
>  tools/testing/selftests/move_mount_set_group/Makefile | 2 +-
>  tools/testing/selftests/resctrl/Makefile              | 2 +-
>  tools/testing/selftests/safesetid/Makefile            | 2 +-
>  tools/testing/selftests/signal/Makefile               | 2 +-
>  tools/testing/selftests/timens/Makefile               | 2 +-
>  tools/testing/selftests/tty/Makefile                  | 2 +-
>  tools/testing/selftests/vDSO/Makefile                 | 2 +-
>  13 files changed, 16 insertions(+), 16 deletions(-)
> 
> diff --git a/tools/testing/selftests/efivarfs/Makefile b/tools/testing/selftests/efivarfs/Makefile
> index e3181338ba5e..f6c412059af3 100644
> --- a/tools/testing/selftests/efivarfs/Makefile
> +++ b/tools/testing/selftests/efivarfs/Makefile
> @@ -1,5 +1,5 @@
>  # SPDX-License-Identifier: GPL-2.0-only
> -CFLAGS = -Wall
> +CFLAGS += -Wall
>  
>  TEST_GEN_FILES := open-unlink create-read
>  TEST_PROGS := efivarfs.sh
> diff --git a/tools/testing/selftests/exec/Makefile b/tools/testing/selftests/exec/Makefile
> index 45a3cfc435cf..54cdefb9ccb0 100644
> --- a/tools/testing/selftests/exec/Makefile
> +++ b/tools/testing/selftests/exec/Makefile
> @@ -1,5 +1,5 @@
>  # SPDX-License-Identifier: GPL-2.0
> -CFLAGS = -Wall
> +CFLAGS += -Wall
>  CFLAGS += -Wno-nonnull
>  CFLAGS += $(KHDR_INCLUDES)
>  
> diff --git a/tools/testing/selftests/firmware/Makefile b/tools/testing/selftests/firmware/Makefile
> index 7992969deaa2..dd9acf972cf5 100644
> --- a/tools/testing/selftests/firmware/Makefile
> +++ b/tools/testing/selftests/firmware/Makefile
> @@ -1,7 +1,7 @@
>  # SPDX-License-Identifier: GPL-2.0-only
>  # Makefile for firmware loading selftests
> -CFLAGS = -Wall \
> -         -O2
> +CFLAGS += -Wall \
> +          -O2
>  
>  TEST_PROGS := fw_run_tests.sh
>  TEST_FILES := fw_fallback.sh fw_filesystem.sh fw_upload.sh fw_lib.sh
> diff --git a/tools/testing/selftests/ipc/Makefile b/tools/testing/selftests/ipc/Makefile
> index 50e9c299fc4a..5a5577767a35 100644
> --- a/tools/testing/selftests/ipc/Makefile
> +++ b/tools/testing/selftests/ipc/Makefile
> @@ -3,11 +3,11 @@ uname_M := $(shell uname -m 2>/dev/null || echo not)
>  ARCH ?= $(shell echo $(uname_M) | sed -e s/i.86/i386/)
>  ifeq ($(ARCH),i386)
>          ARCH := x86
> -	CFLAGS := -DCONFIG_X86_32 -D__i386__
> +	CFLAGS += -DCONFIG_X86_32 -D__i386__
>  endif
>  ifeq ($(ARCH),x86_64)
>  	ARCH := x86
> -	CFLAGS := -DCONFIG_X86_64 -D__x86_64__
> +	CFLAGS += -DCONFIG_X86_64 -D__x86_64__
>  endif
>  
>  CFLAGS += $(KHDR_INCLUDES)
> diff --git a/tools/testing/selftests/mount/Makefile b/tools/testing/selftests/mount/Makefile
> index 2d9454841644..38361a896363 100644
> --- a/tools/testing/selftests/mount/Makefile
> +++ b/tools/testing/selftests/mount/Makefile
> @@ -1,7 +1,7 @@
>  # SPDX-License-Identifier: GPL-2.0
>  # Makefile for mount selftests.
> -CFLAGS = -Wall \
> -         -O2
> +CFLAGS += -Wall \
> +          -O2
>  
>  TEST_PROGS := run_unprivileged_remount.sh run_nosymfollow.sh
>  TEST_GEN_FILES := unprivileged-remount-test nosymfollow-test
> diff --git a/tools/testing/selftests/mount_setattr/Makefile b/tools/testing/selftests/mount_setattr/Makefile
> index 4d4f810cdf2c..fbdb8f69b548 100644
> --- a/tools/testing/selftests/mount_setattr/Makefile
> +++ b/tools/testing/selftests/mount_setattr/Makefile
> @@ -1,6 +1,6 @@
>  # SPDX-License-Identifier: GPL-2.0
>  # Makefile for mount selftests.
> -CFLAGS = -g $(KHDR_INCLUDES) -Wall -O2 -pthread
> +CFLAGS += -g $(KHDR_INCLUDES) -Wall -O2 -pthread
>  
>  LOCAL_HDRS += ../filesystems/wrappers.h
>  
> diff --git a/tools/testing/selftests/move_mount_set_group/Makefile b/tools/testing/selftests/move_mount_set_group/Makefile
> index 94235846b6f9..8771a5491ea3 100644
> --- a/tools/testing/selftests/move_mount_set_group/Makefile
> +++ b/tools/testing/selftests/move_mount_set_group/Makefile
> @@ -1,6 +1,6 @@
>  # SPDX-License-Identifier: GPL-2.0
>  # Makefile for mount selftests.
> -CFLAGS = -g $(KHDR_INCLUDES) -Wall -O2
> +CFLAGS += -g $(KHDR_INCLUDES) -Wall -O2
>  
>  TEST_GEN_FILES += move_mount_set_group_test
>  
> diff --git a/tools/testing/selftests/resctrl/Makefile b/tools/testing/selftests/resctrl/Makefile
> index 984534cfbf1b..1d566a91faa7 100644
> --- a/tools/testing/selftests/resctrl/Makefile
> +++ b/tools/testing/selftests/resctrl/Makefile
> @@ -1,6 +1,6 @@
>  # SPDX-License-Identifier: GPL-2.0
>  
> -CFLAGS = -g -Wall -O2 -D_FORTIFY_SOURCE=2
> +CFLAGS += -g -Wall -O2 -D_FORTIFY_SOURCE=2
>  CFLAGS += $(KHDR_INCLUDES)
>  
>  TEST_GEN_PROGS := resctrl_tests
> diff --git a/tools/testing/selftests/safesetid/Makefile b/tools/testing/selftests/safesetid/Makefile
> index e815bbf2d0f4..d3811515d8e3 100644
> --- a/tools/testing/selftests/safesetid/Makefile
> +++ b/tools/testing/selftests/safesetid/Makefile
> @@ -1,6 +1,6 @@
>  # SPDX-License-Identifier: GPL-2.0
>  # Makefile for SafeSetID selftest.
> -CFLAGS = -Wall -O2
> +CFLAGS += -Wall -O2
>  LDLIBS = -lcap
>  
>  TEST_PROGS := safesetid-test.sh
> diff --git a/tools/testing/selftests/signal/Makefile b/tools/testing/selftests/signal/Makefile
> index e0bf7058d19c..6c437f95132d 100644
> --- a/tools/testing/selftests/signal/Makefile
> +++ b/tools/testing/selftests/signal/Makefile
> @@ -1,5 +1,5 @@
>  # SPDX-License-Identifier: GPL-2.0-only
> -CFLAGS = -Wall
> +CFLAGS += -Wall
>  TEST_GEN_PROGS = mangle_uc_sigmask
>  TEST_GEN_PROGS += sas
>  
> diff --git a/tools/testing/selftests/timens/Makefile b/tools/testing/selftests/timens/Makefile
> index f0d51d4d2c87..357077792395 100644
> --- a/tools/testing/selftests/timens/Makefile
> +++ b/tools/testing/selftests/timens/Makefile
> @@ -1,7 +1,7 @@
>  TEST_GEN_PROGS := timens timerfd timer clock_nanosleep procfs exec futex vfork_exec
>  TEST_GEN_PROGS_EXTENDED := gettime_perf
>  
> -CFLAGS := -Wall -Werror -pthread
> +CFLAGS += -Wall -Werror -pthread
>  LDLIBS := -lrt -ldl
>  
>  include ../lib.mk
> diff --git a/tools/testing/selftests/tty/Makefile b/tools/testing/selftests/tty/Makefile
> index 7f6fbe5a0cd5..e9c22dafe5e1 100644
> --- a/tools/testing/selftests/tty/Makefile
> +++ b/tools/testing/selftests/tty/Makefile
> @@ -1,5 +1,5 @@
>  # SPDX-License-Identifier: GPL-2.0
> -CFLAGS = -O2 -Wall
> +CFLAGS += -O2 -Wall
>  TEST_GEN_PROGS := tty_tstamp_update tty_tiocsti_test
>  LDLIBS += -lcap
>  
> diff --git a/tools/testing/selftests/vDSO/Makefile b/tools/testing/selftests/vDSO/Makefile
> index e361aca22a74..1f4628ceb975 100644
> --- a/tools/testing/selftests/vDSO/Makefile
> +++ b/tools/testing/selftests/vDSO/Makefile
> @@ -11,7 +11,7 @@ TEST_GEN_PROGS += vdso_test_correctness
>  TEST_GEN_PROGS += vdso_test_getrandom
>  TEST_GEN_PROGS += vdso_test_chacha
>  
> -CFLAGS := -std=gnu99 -O2 -Wall -Wstrict-prototypes
> +CFLAGS += -std=gnu99 -O2 -Wall -Wstrict-prototypes
>  
>  ifeq ($(CONFIG_X86_32),y)
>  LDLIBS += -lgcc_s


