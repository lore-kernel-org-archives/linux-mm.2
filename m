Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7097ACFD313
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 03:02:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3E596B000C; Sun, 23 Nov 2025 22:02:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EF396B0010; Sun, 23 Nov 2025 22:02:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DDD86B0011; Sun, 23 Nov 2025 22:02:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 77A5F6B000C
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 22:02:47 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D7C8F5701D
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 03:02:44 +0000 (UTC)
X-FDA: 84144003048.19.F12C3E4
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1B8DFC0007
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 03:02:42 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DWUHQ+ym;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763953363;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EThjVRtG3u91ThHtH8s7htB0Qt2hP8NHKg4Z/0u1oC4=;
	b=KbiCiEn7GmfwEvK2xB2d6FOJqYR1WPdYDvRFkcRWXVsW48AEs1ro/Tlhvi3m/3lVTlTFeV
	JrM+o2S4LeO4DzfWX3MRtSBh6VqNXCGDmPKx6bA+vv+1cpRoZAliJ17vGlvjHvyfyExJBw
	E/EWFVI4M1lcwQsn4nKwak+44ov+tvI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763953363; a=rsa-sha256;
	cv=none;
	b=QKecTpPRAkUnIklPa/uL6WFlpdsleBXZW+S4GHy38dV8UjSTj99kHeZifErWkwrwatzr1B
	YH6by+CkzqdOSD4i+igSmfq+ed8LVHmGwTFVb6ZAPmQJiwlovTcQ/hlJp023g2ouDtmxpB
	ALM7wJq7tsmTVaI4ta9v9pZ0QpIxUk8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DWUHQ+ym;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-34361025290so3005407a91.1
        for <linux-mm@kvack.org>; Sun, 23 Nov 2025 19:02:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763953362; x=1764558162; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EThjVRtG3u91ThHtH8s7htB0Qt2hP8NHKg4Z/0u1oC4=;
        b=DWUHQ+ymu8lOPolWrrxFyoTr/p2A8s2U1dupnjhyppvLsqdmB+NnmyyNBJXIHVp89Z
         X5imhgm48nSgs9TGDDwx9lCsnXBUzd6hQow71YwC/yVNFxiTUoPc2iTzxZDpXbN64BKi
         sJjklCbwAe/A3RcfGIM+fVZOMSF5keEDsR1pF8am/ByRC6+cg+esSuer2uj8suNkojmU
         qM+bE8AwMze29x4UX/QxkoWxhFoBQdZs+HYdBVtkEtuqhlFSzcFsByG161TfwPh1at3K
         aDuMt33hP1AwcuvePtDE8AzXC2d+J86YFK5LXKBz6/L5KPeio3VUJE6KjQPM+2pEtI/K
         35eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763953362; x=1764558162;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EThjVRtG3u91ThHtH8s7htB0Qt2hP8NHKg4Z/0u1oC4=;
        b=PslfHCfeXtHKKJC5LH6lQ1npFRr/Oz87QgNEvdCpdqOKZhd3Ml1Uycb9CVQpWlRHbf
         o7QKwCpX7IE5Ih2nQ30eGpMB2vFE7W0bWbJTp37eZ4pa86te2S88RVglBoHg3Aqhag/v
         VDZUWp92bECE9LKRwZ5Ju9F/VwSNJV/E0eX1oXBEFFK8PN7ud9dtHMqCNdEolIplteDr
         /1hUMbey7+ZlB8ylAX+grDFj0Ulte1Ds3M8gwSIeusHhpy8Q6eUJy6bKTa0stgTxxjpT
         Eca8FDkfWbkeeyma5HkqQiraCUiNkUgl6z4ycPy1AO50dMDWtgnlCeIis4Z5OR20ME5v
         6nPQ==
X-Forwarded-Encrypted: i=1; AJvYcCVqYezFHkKpG56H6Dk9ydf3h+pkfFbHkWdThx+SUAnPueICCdvLBPkpOQxa6ZPZ878uzPNU8V9UVA==@kvack.org
X-Gm-Message-State: AOJu0YzKbdxzGnFb92Yn0UU8XVdr8wt0OwgDk0XD0JQo5oV5stWJm5HZ
	SqFziuVIiCmb+u/A27uiea//SH5sGLjbIfNVM96ZlfPQpa+up9ff0N42
X-Gm-Gg: ASbGncsU5KdqfiK0WNCSrspCaNuiggpdkT96unInWWwbXSOLSS8e42nMi0kQe/51Dvk
	ojH7O84wF94LbuPTCODnS/Hc8aZnKe8sTrU89ivo4mCSuS7n2vUHn87fsq6yqNfB5bhvci4pi/i
	Lyiu5yxe/kII6/8/scC7XeIqJkydP34aAuZbC2o6O6KwjvQhG0LhcweHpArPbD9kAWyRsoMyEza
	yCKhlREwy6fvyUOSIjVmLkzXvwyOjBtAOs8F9c5JAUgJEg5CLKmplATo2JadN82i/PoB9l0a66+
	vosdGgsj7ePXVPTx55S8ihKt7QkGkEcsf769XRm3+YYj1dvVC7xjX333IbtG6IEVH3whSGwlEvI
	0kBSoYhsqj8vXrnQxPyh9G0hUGUHJWprwCdPpIxTpEemC/2K9gI273OiXZuITd/v+HOJorcC4/v
	EMWiVsvlvNoFQ=
X-Google-Smtp-Source: AGHT+IEMt538xCkv+fqIIYil9IQfkAkpZOfttXOCrxqxU9ijd4Z/n1H3Gpy/X0jI7VxwtTCqcmNbzA==
X-Received: by 2002:a17:90b:35cc:b0:341:194:5e7d with SMTP id 98e67ed59e1d1-34733f19c00mr11223472a91.24.1763953361678;
        Sun, 23 Nov 2025 19:02:41 -0800 (PST)
Received: from archie.me ([210.87.74.117])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34727d5178esm11869866a91.16.2025.11.23.19.02.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Nov 2025 19:02:40 -0800 (PST)
Received: by archie.me (Postfix, from userid 1000)
	id 8D1794209E72; Mon, 24 Nov 2025 10:02:37 +0700 (WIB)
Date: Mon, 24 Nov 2025 10:02:37 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Eugen Hristev <eugen.hristev@linaro.org>, linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	tglx@linutronix.de, andersson@kernel.org, pmladek@suse.com,
	rdunlap@infradead.org, corbet@lwn.net, david@redhat.com,
	mhocko@suse.com
Cc: tudor.ambarus@linaro.org, mukesh.ojha@oss.qualcomm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-hardening@vger.kernel.org, jonechou@google.com,
	rostedt@goodmis.org, linux-doc@vger.kernel.org,
	devicetree@vger.kernel.org, linux-remoteproc@vger.kernel.org,
	linux-arch@vger.kernel.org, tony.luck@intel.com, kees@kernel.org
Subject: Re: [PATCH 01/26] kernel: Introduce meminspect
Message-ID: <aSPKzcsFixn48edg@archie.me>
References: <20251119154427.1033475-1-eugen.hristev@linaro.org>
 <20251119154427.1033475-2-eugen.hristev@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="jjzv1iO7GRx9l9vd"
Content-Disposition: inline
In-Reply-To: <20251119154427.1033475-2-eugen.hristev@linaro.org>
X-Stat-Signature: s4k33bd5ng6dimoy8cdwjpdcok8zumui
X-Rspam-User: 
X-Rspamd-Queue-Id: 1B8DFC0007
X-Rspamd-Server: rspam10
X-HE-Tag: 1763953362-916091
X-HE-Meta: U2FsdGVkX1/dtJQQ6XHfm8oifPEH+CB+q0r1Ha+BFRTCfqZEC/iJyweeGYbWalGFiK0OZHD2xgYLMv237Vvm3NhK9w4+Zem1cBaNgNdrkVEkeZvgIC/MRKfO0hm5093htG8t/FroN5u2ubyuDhFYg2ik/rdRojUFOma5aeYtJfSsWzomURTeF7P0bcAZFuXqD0028qs2ZFFX6JlFyrO+LGHutDQ7m8J9t8OlGcHdgRm6JVuywKdzXlYdTSw2PA90tDzPyhrCP69zop4SrrLXW980xt0nS2I9o0cz3HpMxoF1i/keBqotzTzEp6meoy6ssOfeYPd+kvNmU74RF/axlnoyG6/YJZgcyRGxepu6mJ7aufnjezLnJgUBHejhbAPOdlE15Om8CW/00q17Ne43vVzQzi/p+pDcIvZkf1Ne2MkEbzWxMsSFAHF8k59ER2tPPDUhvvt+31HmXy6KvJraDR4PKcszy7kcEUL1Eaco3jk00FYg4fcc35IA6wYTmHtdUkzAFz8+vWzKDkBj6ug2USOGH5cAC3QTiwSjqWYMj2vnsGm8aQdlDZAI+I8aPcaKF6GUuDf2mQY9jRyVNOPdd+PjmXssO6vTN69rugTJSwgnA7ygqRB7dnYdryvLUV1iNBiy31zW0FMvF5M3bpi3vvLNNsmg9c9bTvmNL01+M6OzCgab6tCj8yk3G8koMEE8EGKdRHMgqaDe28AVGX1jxPnVxVOWJdA04MR50pGerSl2ABdsLLEWsqdTbH3LOY0PK97bI7A3PSaopWlYD5pwCp6TmW8+Rq3daMhCTxrtCCw8nY2YoVQmQHxXB4FttllH+a+sBORQ++pHwkOqAf3m13yGNnHObb8rlnLpoBx4Hm5RhmYXKYXyJow1WcRaEhZ1DmB7Yr4Ao9pNeVUK3EWLnJgCQ4D/8Rb52631rMVYEeikW+22r2+/OolFjKgG1HYDJjYgtazTSWB6BzcdEv6
 z3SQIYjN
 jnjQnaDKIijPKqD7JEyTULYiMIQXxBOEEDCSjpo5BTzdkXN4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--jjzv1iO7GRx9l9vd
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 19, 2025 at 05:44:02PM +0200, Eugen Hristev wrote:
> diff --git a/Documentation/dev-tools/index.rst b/Documentation/dev-tools/=
index.rst
> index 4b8425e348ab..8ce605de8ee6 100644
> --- a/Documentation/dev-tools/index.rst
> +++ b/Documentation/dev-tools/index.rst
> @@ -38,6 +38,7 @@ Documentation/process/debugging/index.rst
>     gpio-sloppy-logic-analyzer
>     autofdo
>     propeller
> +   meminspect
> =20
> =20
>  .. only::  subproject and html
> diff --git a/Documentation/dev-tools/meminspect.rst b/Documentation/dev-t=
ools/meminspect.rst
> new file mode 100644
> index 000000000000..2a0bd4d6e448
> --- /dev/null
> +++ b/Documentation/dev-tools/meminspect.rst
> @@ -0,0 +1,139 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +meminspect
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +This document provides information about the meminspect feature.
> +
> +Overview
> +=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +meminspect is a mechanism that allows the kernel to register a chunk of
> +memory into a table, to be used at a later time for a specific
> +inspection purpose like debugging, memory dumping or statistics.
> +
> +meminspect allows drivers to traverse the inspection table on demand,
> +or to register a notifier to be called whenever a new entry is being add=
ed
> +or removed.
> +
> +The reasoning for meminspect is also to minimize the required information
> +in case of a kernel problem. For example a traditional debug method invo=
lves
> +dumping the whole kernel memory and then inspecting it. Meminspect allow=
s the
> +users to select which memory is of interest, in order to help this speci=
fic
> +use case in production, where memory and connectivity are limited.
> +
> +Although the kernel has multiple internal mechanisms, meminspect fits
> +a particular model which is not covered by the others.
> +
> +meminspect Internals
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +API
> +---
> +
> +Static memory can be registered at compile time, by instructing the comp=
iler
> +to create a separate section with annotation info.
> +For each such annotated memory (variables usually), a dedicated struct
> +is being created with the required information.
> +To achieve this goal, some basic APIs are available:
> +
> +  MEMINSPECT_ENTRY(idx, sym, sz)
> +is the basic macro that takes an ID, the symbol, and a size.
> +
> +To make it easier, some wrappers are also defined:
> +  MEMINSPECT_SIMPLE_ENTRY(sym)
> +will use the dedicated MEMINSPECT_ID_##sym with a size equal to sizeof(s=
ym)
> +
> +  MEMINSPECT_NAMED_ENTRY(name, sym)
> +will be a simple entry that has an id that cannot be derived from the sy=
m,
> +so a name has to be provided
> +
> +  MEMINSPECT_AREA_ENTRY(sym, sz)
> +this will register sym, but with the size given as sz, useful for e.g.
> +arrays which do not have a fixed size at compile time.
> +
> +For dynamically allocated memory, or for other cases, the following APIs
> +are being defined:
> +  meminspect_register_id_pa(enum meminspect_uid id, phys_addr_t zone,
> +                            size_t size, unsigned int type);
> +which takes the ID and the physical address.
> +Similarly there are variations:
> +  meminspect_register_pa() omits the ID
> +  meminspect_register_id_va() requires the ID but takes a virtual address
> +  meminspect_register_va() omits the ID and requires a virtual address
> +
> +If the ID is not given, the next avialable dynamic ID is allocated.
> +
> +To unregister a dynamic entry, some APIs are being defined:
> +  meminspect_unregister_pa(phys_addr_t zone, size_t size);
> +  meminspect_unregister_id(enum meminspect_uid id);
> +  meminspect_unregister_va(va, size);
> +
> +All of the above have a lock variant that ensures the lock on the table
> +is taken.
> +
> +
> +meminspect drivers
> +------------------
> +
> +Drivers are free to traverse the table by using a dedicated function
> +meminspect_traverse(void *priv, MEMINSPECT_ITERATOR_CB cb)
> +The callback will be called for each entry in the table.
> +
> +Drivers can also register a notifier with
> +  meminspect_notifier_register()
> +and unregister with
> +  meminspect_notifier_unregister()
> +to be called when a new entry is being added or removed.
> +
> +Data structures
> +---------------
> +
> +The regions are being stored in a simple fixed size array. It avoids
> +memory allocation overhead. This is not performance critical nor does
> +allocating a few hundred entries create a memory consumption problem.
> +
> +The static variables registered into meminspect are being annotated into
> +a dedicated .inspect_table memory section. This is then walked by memins=
pect
> +at a later time and each variable is then copied to the whole inspect ta=
ble.
> +
> +meminspect Initialization
> +-------------------------
> +
> +At any time, meminspect will be ready to accept region registration
> +from any part of the kernel. The table does not require any initializati=
on.
> +In case CONFIG_CRASH_DUMP is enabled, meminspect will create an ELF head=
er
> +corresponding to a core dump image, in which each region is added as a
> +program header. In this scenario, the first region is this ELF header, a=
nd
> +the second region is the vmcoreinfo ELF note.
> +By using this mechanism, all the meminspect table, if dumped, can be
> +concatenated to obtain a core image that is loadable with the `crash` to=
ol.
> +
> +meminspect example
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +A simple scenario for meminspect is the following:
> +The kernel registers the linux_banner variable into meminspect with
> +a simple annotation like:
> +
> +  MEMINSPECT_SIMPLE_ENTRY(linux_banner);
> +
> +The meminspect late initcall will parse the compilation time created tab=
le
> +and copy the entry information into the inspection table.
> +At a later point, any interested driver can call the traverse function to
> +find out all entries in the table.
> +A specific driver will then note into a specific table the address of the
> +banner and the size of it.
> +The specific table is then written to a shared memory area that can be
> +read by upper level firmware.
> +When the kernel freezes (hypothetically), the kernel will no longer feed
> +the watchdog. The watchdog will trigger a higher exception level interru=
pt
> +which will be handled by the upper level firmware. This firmware will th=
en
> +read the shared memory table and find an entry with the start and size of
> +the banner. It will then copy it for debugging purpose. The upper level
> +firmware will then be able to provide useful debugging information,
> +like in this example, the banner.
> +
> +As seen here, meminspect facilitates the interaction between the kernel
> +and a specific firmware.

Sphinx reports htmldocs warnings:

Documentation/dev-tools/meminspect.rst:42: WARNING: Block quote ends withou=
t a blank line; unexpected unindent. [docutils]
Documentation/dev-tools/meminspect.rst:46: WARNING: Definition list ends wi=
thout a blank line; unexpected unindent. [docutils]
Documentation/dev-tools/meminspect.rst:49: WARNING: Block quote ends withou=
t a blank line; unexpected unindent. [docutils]
Documentation/dev-tools/meminspect.rst:53: WARNING: Block quote ends withou=
t a blank line; unexpected unindent. [docutils]
Documentation/dev-tools/meminspect.rst:58: ERROR: Unexpected indentation. [=
docutils]
Documentation/dev-tools/meminspect.rst:60: WARNING: Block quote ends withou=
t a blank line; unexpected unindent. [docutils]
Documentation/dev-tools/meminspect.rst:62: ERROR: Unexpected indentation. [=
docutils]
Documentation/dev-tools/meminspect.rst:80: WARNING: Inline emphasis start-s=
tring without end-string. [docutils]
Documentation/dev-tools/meminspect.rst:88: WARNING: Definition list ends wi=
thout a blank line; unexpected unindent. [docutils]

I have to fix them up:

---- >8 ----
diff --git a/Documentation/dev-tools/meminspect.rst b/Documentation/dev-too=
ls/meminspect.rst
index 2a0bd4d6e4481e..d6a221b1169f04 100644
--- a/Documentation/dev-tools/meminspect.rst
+++ b/Documentation/dev-tools/meminspect.rst
@@ -38,37 +38,43 @@ For each such annotated memory (variables usually), a d=
edicated struct
 is being created with the required information.
 To achieve this goal, some basic APIs are available:
=20
-  MEMINSPECT_ENTRY(idx, sym, sz)
-is the basic macro that takes an ID, the symbol, and a size.
+  * MEMINSPECT_ENTRY(idx, sym, sz)
+    is the basic macro that takes an ID, the symbol, and a size.
=20
 To make it easier, some wrappers are also defined:
-  MEMINSPECT_SIMPLE_ENTRY(sym)
-will use the dedicated MEMINSPECT_ID_##sym with a size equal to sizeof(sym)
=20
-  MEMINSPECT_NAMED_ENTRY(name, sym)
-will be a simple entry that has an id that cannot be derived from the sym,
-so a name has to be provided
+  * MEMINSPECT_SIMPLE_ENTRY(sym)
+    will use the dedicated MEMINSPECT_ID_##sym with a size equal to sizeof=
(sym)
=20
-  MEMINSPECT_AREA_ENTRY(sym, sz)
-this will register sym, but with the size given as sz, useful for e.g.
-arrays which do not have a fixed size at compile time.
+  * MEMINSPECT_NAMED_ENTRY(name, sym)
+    will be a simple entry that has an id that cannot be derived from the =
sym,
+    so a name has to be provided
+
+  * MEMINSPECT_AREA_ENTRY(sym, sz)
+    this will register sym, but with the size given as sz, useful for e.g.
+    arrays which do not have a fixed size at compile time.
=20
 For dynamically allocated memory, or for other cases, the following APIs
-are being defined:
+are being defined::
+
   meminspect_register_id_pa(enum meminspect_uid id, phys_addr_t zone,
                             size_t size, unsigned int type);
+
 which takes the ID and the physical address.
+
 Similarly there are variations:
-  meminspect_register_pa() omits the ID
-  meminspect_register_id_va() requires the ID but takes a virtual address
-  meminspect_register_va() omits the ID and requires a virtual address
+
+  * meminspect_register_pa() omits the ID
+  * meminspect_register_id_va() requires the ID but takes a virtual address
+  * meminspect_register_va() omits the ID and requires a virtual address
=20
 If the ID is not given, the next avialable dynamic ID is allocated.
=20
 To unregister a dynamic entry, some APIs are being defined:
-  meminspect_unregister_pa(phys_addr_t zone, size_t size);
-  meminspect_unregister_id(enum meminspect_uid id);
-  meminspect_unregister_va(va, size);
+
+  * meminspect_unregister_pa(phys_addr_t zone, size_t size);
+  * meminspect_unregister_id(enum meminspect_uid id);
+  * meminspect_unregister_va(va, size);
=20
 All of the above have a lock variant that ensures the lock on the table
 is taken.
@@ -77,15 +83,15 @@ is taken.
 meminspect drivers
 ------------------
=20
-Drivers are free to traverse the table by using a dedicated function
-meminspect_traverse(void *priv, MEMINSPECT_ITERATOR_CB cb)
+Drivers are free to traverse the table by using a dedicated function::
+
+  meminspect_traverse(void *priv, MEMINSPECT_ITERATOR_CB cb)
+
 The callback will be called for each entry in the table.
=20
-Drivers can also register a notifier with
-  meminspect_notifier_register()
-and unregister with
-  meminspect_notifier_unregister()
-to be called when a new entry is being added or removed.
+Drivers can also register a notifier with meminspect_notifier_register()
+and unregister with meminspect_notifier_unregister() to be called when a n=
ew
+entry is being added or removed.
=20
 Data structures
 ---------------
@@ -115,7 +121,7 @@ meminspect example
=20
 A simple scenario for meminspect is the following:
 The kernel registers the linux_banner variable into meminspect with
-a simple annotation like:
+a simple annotation like::
=20
   MEMINSPECT_SIMPLE_ENTRY(linux_banner);
=20

Thanks.

--=20
An old man doll... just what I always wanted! - Clara

--jjzv1iO7GRx9l9vd
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCaSPKyAAKCRD2uYlJVVFO
o3X1AQDv/TE1tWTJ8ZXxzegUA8QbZl8nMDxfkacY7FNjZC/xRQD8DSFK9tPqxhS0
Zf7jek/k/PHFmMUwkhTyDVy+lTogUgc=
=cIN1
-----END PGP SIGNATURE-----

--jjzv1iO7GRx9l9vd--

