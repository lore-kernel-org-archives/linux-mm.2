Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE6EACF58FE
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 21:20:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34C3C6B0093; Wed, 19 Nov 2025 16:20:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D5846B0098; Wed, 19 Nov 2025 16:20:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 176CD6B00A5; Wed, 19 Nov 2025 16:20:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0091C6B0093
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 16:20:42 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9F237C0621
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 21:20:42 +0000 (UTC)
X-FDA: 84128625924.20.3FEA03A
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf04.hostedemail.com (Postfix) with ESMTP id C0C3B40013
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 21:20:40 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=il31cRI7;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of dmatlack@google.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763587240; a=rsa-sha256;
	cv=none;
	b=LKVfiMs4DJFy4Caz7qh3AQIzxqbTPOaO/fp5G+kQ7J9JJmq83/V2uhjaRxvINEeQEmGy0+
	+tKL9VRwlnZkmJnN4dkli9+rScZgUNQyTh/Rzwzge8yOtpNPACMeVp9DBYN5SbIqz05yM+
	8kzLVA9v/FHuT+QamnMjoBRmwWRROAI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=il31cRI7;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of dmatlack@google.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763587240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=flj38gz4L08lc87dayRdAelLk1tJ7Y8JM+kGwy03iE4=;
	b=7lqoP8RbHrf95KDaHaulJeDohQ20+A/zrU/Y1vKgM+ywsbAjQYDs81l4U/UOo6W1t87xYX
	tgknZCxyn6MdqTldhiSji7vMhK3CfHbUV80gXBzvPIQI8s2tG9PSjhs0CKMVkOXzCCxLEO
	VEUNz0oCTVYvZDDy5VXzoC7xdOA0TCQ=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-29516a36affso2797335ad.3
        for <linux-mm@kvack.org>; Wed, 19 Nov 2025 13:20:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763587239; x=1764192039; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=flj38gz4L08lc87dayRdAelLk1tJ7Y8JM+kGwy03iE4=;
        b=il31cRI7ruSg8TmenR2jf7SX20BUqQ1NRSuyWEEzsaw/6SsD+LjN/C0L35FmgKzCyn
         Y8NNgbFYFD/b6XALN9OSzF6MuKTu1h7kw+FQx/IzUUfYWfsEu0YpB+xEtv3RTEJ+Bdug
         X6H1QvVhC3LIt58GYFew8vZAH8vaDUj+Yx6hLVh2y9Ye0RxRxuV1WRilydZ2i5HMfkeq
         mpIV9yAHFRcgGCJfzCw9Wg1XfOSXBBmUs/+yCbSm1ZlVv6cDDvqFmrK76QYCTO+jyrUV
         g9NLpAIC77PoMH6motH+/q/xqNmwvviB/hejWavgsExGjo/RQMb3LuRn7ogxXjYFdm8l
         1AdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763587239; x=1764192039;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=flj38gz4L08lc87dayRdAelLk1tJ7Y8JM+kGwy03iE4=;
        b=DL8em9jKXO9bit0Y+9Kr3T/+Mka++0tJrDK7dp44HxbgLI9UEhVoaruSrhW+U8ex+F
         gy7FtHFVSDx1dCGNmWmTm2ZaNAiUFS1PQVae7tDT0zBKLNiyGiFiWYmJ3eSW/xDFF+Sd
         tEqujma/yJw9YlzrbHHPjGyJ66nK9qJlVLwTAeUwpow/l1O8X5xE7CylVQZlmjE2cmro
         DDMgwlgpyWx4AWQAA47yfxnAQ3k9petSoIXLqpgJOY8miqtPUB1bhzQR6IJorexbnail
         dvaK851Tv2ZYu7SjzXmCDHOdr+rdy07CYGgYuNtIck5F8qIS+UAdFCe8e74OtCv6FJDf
         DDnA==
X-Forwarded-Encrypted: i=1; AJvYcCUxTapXFTPlHv2c9uzT16wPQGI65boph6Wk+4L5gBg81V8WOTP8BKvnU6pote6H4PgCm5ETxBUzYA==@kvack.org
X-Gm-Message-State: AOJu0Yw8wZ/bhOH1qc4wRw3QJhyMnTS968LCDWwZXxr0NvLDSBvqk+qt
	F9kFGQLB/E3DWHgSYOqJkXg+PJL6OP+D8XDpgflMIw5tl9GOlXocqxIHNDQGlsnOyw==
X-Gm-Gg: ASbGncuRdk986d6w6b5YQuFAhu7aSl8NUhSVrWizAVZ6p8tBBBMslVsB3iMVy6D5xgN
	IxVWtr5jEFh2oW7kYLyfu5BMxJKMSa0Gja2oMCWJQyn3JtrHgDiEyrtr2HsR8kC/4FPReeCGtlt
	kmIwpJ2CxM0aECZwjKQhwRrJZZ0AGcEVSMif7L78VQqoGd0rn9PScBY8r3AIFNAzxm+By6YSCp8
	GEWMzacNBGcVB8qpkfM9m7C5Qj4AN6GCD9722bhkuFtpP9rDSxQDsKZhAr6HYGZ9gWItFTw9lfF
	TjoMOC8UjC2sjHV3RqVm0hTqlklw107VV+GhG+mJG3WL6vBTzVZjbx9oX3Q/JfuTaF9iqjvSVof
	4fEMC3W56k7hlpnsZkzKx/7SKX1dPpFUxGdqlHYiZmaxhWbYUak5Jk64QMe5GlDEkouEwXeiGr5
	A02gtQnCarU9HZsMe6V0o8dQ9Kx/lMgzRov/VJ6A391lyB3TDCpRQ3OAddKboAABn9dgmgv+X6G
	w==
X-Google-Smtp-Source: AGHT+IFrxTck/ibRPggmaOfoFEHngZ9j3Wi19/Cn4ktJjoxdrVE4GnzBiziuQnyIS9dFi1fhtFrseg==
X-Received: by 2002:a17:903:11c5:b0:294:fc77:f021 with SMTP id d9443c01a7336-29b5b13a8bbmr9665255ad.49.1763587239033;
        Wed, 19 Nov 2025 13:20:39 -0800 (PST)
Received: from google.com (132.200.185.35.bc.googleusercontent.com. [35.185.200.132])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29b5b13e7e6sm3965405ad.40.2025.11.19.13.20.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Nov 2025 13:20:37 -0800 (PST)
Date: Wed, 19 Nov 2025 21:20:33 +0000
From: David Matlack <dmatlack@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com,
	rppt@kernel.org, rientjes@google.com, corbet@lwn.net,
	rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com,
	kanie@linux.alibaba.com, ojeda@kernel.org, aliceryhl@google.com,
	masahiroy@kernel.org, akpm@linux-foundation.org, tj@kernel.org,
	yoann.congal@smile.fr, mmaurer@google.com, roman.gushchin@linux.dev,
	chenridong@huawei.com, axboe@kernel.dk, mark.rutland@arm.com,
	jannh@google.com, vincent.guittot@linaro.org, hannes@cmpxchg.org,
	dan.j.williams@intel.com, david@redhat.com,
	joel.granados@kernel.org, rostedt@goodmis.org,
	anna.schumaker@oracle.com, song@kernel.org, linux@weissschuh.net,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-mm@kvack.org, gregkh@linuxfoundation.org, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, rafael@kernel.org, dakr@kernel.org,
	bartosz.golaszewski@linaro.org, cw00.choi@samsung.com,
	myungjoo.ham@samsung.com, yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com, ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de,
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com,
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net,
	brauner@kernel.org, linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, saeedm@nvidia.com,
	ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com,
	leonro@nvidia.com, witu@nvidia.com, hughd@google.com,
	skhawaja@google.com, chrisl@kernel.org
Subject: Re: [PATCH v6 18/20] selftests/liveupdate: Add kexec-based selftest
 for session lifecycle
Message-ID: <aR40oVOxZ-dezpy0@google.com>
References: <20251115233409.768044-1-pasha.tatashin@soleen.com>
 <20251115233409.768044-19-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251115233409.768044-19-pasha.tatashin@soleen.com>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C0C3B40013
X-Stat-Signature: qjfore7hyomxqfdafeu69koei19kimaf
X-Rspam-User: 
X-HE-Tag: 1763587240-510037
X-HE-Meta: U2FsdGVkX199jpr/5xbaQN2+FrbFaSSN3mgWOL6s3eZlhE60a2lzPu5cahZJmgrtmJiFyvQRQn1/kg3wU/DI8ya4Q3d2zghe11OUJjjeJLUOmME77DE11Gg1Ds88ZYetd5HCnjt+mT0065S6Iqc3tf5u2PKrnws/VugFKTBUBOhvPdpccTR3JV/60x3PE6yTAyvtp5EbBueOg0Dkal1xBo7Ah9k0jxqTJnNA6mB4uT1UxpalIciPvRUrypHwBYNlGaXnLnPFsGYRv8xFspgb+UtcJvyyt0H5r/4QdaoEBbRlNfjnj85u70hyTZOGAlfOWbvww1mlH30GmZlyDJEJG0PVeLZUayrvc4BLB20ksSv33xrCK/0hKPG3Htkxie8jNjtQLCdvbZju9SiHK8R7vJMCsLRZO1JT2+kfu7YhAaWNyI5H+OGkUBcXnfaQdXSuC/qmXhPvKHSH84Pk9ujrgTzhSHjXrHHaEuBJ+SmUuFdvpiLzazXP9vOXVTElG3Kg3YHO66l4P93hTY2pdBGPhs2V/wAX9s8swwWFF9mvHZuqsY/54LS4AknDiScVxoxbdWdEEQGLWguviaiDjwxuCSt0bnsqur0VK4Rz8D/edCk5p4O19tmIF/VmEKgUPOCbyA8mCqG2e3RV29W+Kg5RAiFcBZWm44viCVRcuCN3lh4MBvyI36t8u6oq5xPAurhcQzztE04cEeXJtS3U27e0aE9Zc/++uE5i1ZsMARZIxXs3Pr97SQ9Hc4agUE5Ymhx+aRFWWcQG7YAIyu7EQPysEoXteBoFVMopNy+2X++KzmFzpMaojW+Sc565KhiQsQm1k+d9T+CVP8GyLL1nv+HBs0rrMSKungTBssVl0FlTycghGpca2G2Ussk6XWjaYRQbaWRwf9Ip1leiT8p3z3Le2p6VOvKq3bUFhPaVzjF0T3MohWu8ZHRnpbLXKC1v4raMiRKtIexCLwDcGep2DpI
 J36A4OTw
 B7VC/Igg7SB8Z7oxd4dc5CHFK7mxy/41aQ1AagHKgo80NcL1qhxW3/zs2WjGnRaqB4BgKUzzIbjx2FzgtAmRJHBJSPPMxcd7w8LOAiVawmH9CjJUuK/5RChTaFpikVatAcXiQHeVZpY9iie819t03e3lwGo52HGh1FBsMNm/ATWoKKulv9N1PeoCdDwfORHSrelIUqJWmjDunHGqZDGlUYiYBYObfqVWhdwDchx/OLxdGk9yMOQWVtUOZ1Jf7I2AedFTA7SQXeGKnWzPSiBFZr7lhThS1xNFPV0E1WDw/d0DYZ5RkRVylzMiN8lJ6Oc8GwlQPLYZx0g/Kh/2u3tObLwueltVHzqAjIAcn2MY8ygD+ApUKgI16DfF7JKNZAscNtRjjNFaC45uTdSo6nW7GRpx0FYbXQSUzgsa4LCrpLBwLvik1nhGfn7KY6A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-11-15 06:34 PM, Pasha Tatashin wrote:

> diff --git a/tools/testing/selftests/liveupdate/do_kexec.sh b/tools/testing/selftests/liveupdate/do_kexec.sh
> new file mode 100755
> index 000000000000..3c7c6cafbef8
> --- /dev/null
> +++ b/tools/testing/selftests/liveupdate/do_kexec.sh
> @@ -0,0 +1,16 @@
> +#!/bin/sh
> +# SPDX-License-Identifier: GPL-2.0
> +set -e
> +
> +# Use $KERNEL and $INITRAMFS to pass custom Kernel and optional initramfs

It'd be nice to use proper command line options for KERNEL and INITRAMFS
instead of relying on environment variables.

e.g.

  ./do_kexec.sh -k <kernel> -i <initramfs>

> +
> +KERNEL="${KERNEL:-/boot/bzImage}"
> +set -- -l -s --reuse-cmdline "$KERNEL"

I've observed --reuse-cmdline causing overload of the kernel command
line when doing repeated kexecs, since it includes the built-in command
line (CONFIG_CMDLINE) which then also gets added by the next kernel
during boot.

Should we have something like this instead?

diff --git a/tools/testing/selftests/liveupdate/do_kexec.sh b/tools/testing/selftests/liveupdate/do_kexec.sh
index 3c7c6cafbef8..2590a870993d 100755
--- a/tools/testing/selftests/liveupdate/do_kexec.sh
+++ b/tools/testing/selftests/liveupdate/do_kexec.sh
@@ -4,8 +4,16 @@ set -e

 # Use $KERNEL and $INITRAMFS to pass custom Kernel and optional initramfs

+# Determine the boot command line we need to pass to the kexec kernel.  Note
+# that the kernel will append to it its builtin command line, so make sure we
+# subtract the builtin command to avoid accumulating kernel parameters and
+# eventually overflowing the command line.
+full_cmdline=$(cat /proc/cmdline)
+builtin_cmdline=$(zcat /proc/config.gz|grep CONFIG_CMDLINE=|cut -f2 -d\")
+cmdline=${full_cmdline/$builtin_cmdline /}
+
 KERNEL="${KERNEL:-/boot/bzImage}"
-set -- -l -s --reuse-cmdline "$KERNEL"
+set -- -l -s --command-line="${cmdline}" "$KERNEL"

 INITRAMFS="${INITRAMFS:-/boot/initramfs}"
 if [ -f "$INITRAMFS" ]; then

> +
> +INITRAMFS="${INITRAMFS:-/boot/initramfs}"
> +if [ -f "$INITRAMFS" ]; then
> +    set -- "$@" --initrd="$INITRAMFS"
> +fi
> +
> +kexec "$@"
> +kexec -e

Consider separating the kexec load into its own script, in case systems have
their own ways of shutting down for kexec.

e.g. a kexec_load.sh script that does everything that do_kexec.sh does execpt
the `kexec -e`. Then do_kexec.sh just calls kexec_load.sh and kexec -e.

