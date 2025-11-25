Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 519FACFD373
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 02:59:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65EDD6B0008; Mon, 24 Nov 2025 21:59:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E8A96B002A; Mon, 24 Nov 2025 21:59:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 525A46B002C; Mon, 24 Nov 2025 21:59:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3E79C6B0008
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 21:59:16 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DFA464F5BC
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 02:59:15 +0000 (UTC)
X-FDA: 84147623070.19.67D90B8
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0530440008
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 02:59:13 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernelci-org.20230601.gappssmtp.com header.s=20230601 header.b=gv02E5yq
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764039554;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Gz181Bmy9MckFO/w7k+mHRg5nxf6kaKRSNnlopoqZnk=;
	b=owmA0bvsl3o1Oa1oRh+YmK+cOw65RLA8WuNcoDLGa9FY4w/lUA2GdfRudCSXESHV4dgCVq
	/UDdnwagoZJIUkbSK1jHaXTY4lxUkR+L5aBkjn2WM9G/laKjE6+gUTpxLzHfjYmSHnby82
	IJlmkguZLoWjW1aDb2WB2ArOPlMdwkU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764039554; a=rsa-sha256;
	cv=none;
	b=cbVfNUKyWXP7iw11IdeLDdT+hL1atZUbrA7VIUqFQmTw4tbPsSTXNlaxiN4Vqg+omJFvrt
	6+lBHixFXztzE35JVz/gGR/F98H712hWqZ+SymcvKb54aNLFPSCZUKzraJcizojYaQLOit
	G7EgBklQoPhc0Fra+5K4GzLjbEuZHiw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernelci-org.20230601.gappssmtp.com header.s=20230601 header.b=gv02E5yq;
	spf=none (imf17.hostedemail.com: domain of bot@kernelci.org has no SPF policy when checking 209.85.215.174) smtp.mailfrom=bot@kernelci.org;
	dmarc=none
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-bdcae553883so1217308a12.0
        for <linux-mm@kvack.org>; Mon, 24 Nov 2025 18:59:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20230601.gappssmtp.com; s=20230601; t=1764039553; x=1764644353; darn=kvack.org;
        h=message-id:date:reply-to:cc:to:from:subject
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gz181Bmy9MckFO/w7k+mHRg5nxf6kaKRSNnlopoqZnk=;
        b=gv02E5yqWHHiK+G1QMGIfSsUud0YkUAi/cTIzfyUE3InfLcJbxyLUjV3GOo7lAEiAQ
         /dUQjzTeW+EqXJ+cBoufohxk83QZBIr4EW2cFetzWCf9+IOPIXiPMLu6Wk9xlPMOA/Ih
         Oo5G0IafCoG+Licd6yZ313CYQs+vfws6wgScJCJdeFXGpiyBKWcIt8QyAJmTxC93OFpC
         EoCiXzOiDWTOwaap3cRv0p1UU3ZhSR4yiQsg4vVrrk9/6SAXfOUeAfdCDmadxHYsf1wS
         qv5q33bs2A3dkSom4n89nOCMiOPOttZZEkGbywYXYN5tNW24ai6K7X2SiERAdZqyk+by
         UKkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764039553; x=1764644353;
        h=message-id:date:reply-to:cc:to:from:subject
         :content-transfer-encoding:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Gz181Bmy9MckFO/w7k+mHRg5nxf6kaKRSNnlopoqZnk=;
        b=YVr2sWTVB0AbWtCVLV+iuUZl6iq2ftwlBTuHOs1bUyGOXU9P456vDTV8MUYvlJlSX7
         p9pAqmp8P1skEoXO02VASJ7DQVNo+UEJDC9lD/Nvgamcdl2Vj4HkbNnsC3eAhGMjBDWC
         RR0gFTgwmrbzgTSVYflcJ6nQeabDA5wc/ZxlQJ90hmTU+3zEdaNMCSRBOFr+HJOaatXk
         puAmxd8fm9r5l5xArwBgiXvlPzzZ8LMpHTLcCIliLTUvbzi+lFCCTHyFdD4O/8JYogkH
         3aEZZUgq1/3/kY3gmTmZEJ+IH0U1mk3UWzW86yerdFvyRXl/XK1SMwqzYnapTWvN+g1y
         Vhrw==
X-Forwarded-Encrypted: i=1; AJvYcCWGJsje+J9bsqTbWwxmQykk5pRqpw/wioD47UxILZL67SrO0TNwytpcoJCcKNU4FO9mAR3O32Wg4A==@kvack.org
X-Gm-Message-State: AOJu0YwuyasXg8OpS17wog8wx8hKm73mQ4NlkKlQGNsybUWPiVXtGdcU
	hhljLDS4P9s587gM26Bzh/M74SGBOVr13TbJTC6vRDeNKQWru1aVg2XcP23Px2UEUjQ=
X-Gm-Gg: ASbGnctLspXTKluebJb+28E/H4+5I0X9hLHWPc5wWxyHgT2K/wPEFGE5c+STu6TFl8P
	yyN0IXd6LDhFaSzqXtLqTUgyacvJnXzDM1hzFWZKYChRk3zjQ0NByMlMZLVA9GTrYMQdfCleBDk
	YoBzlxa8tHheauXomlO2xlqwr+KEViubtvoW9IoTd30PJMJub0yoD38dZ+oEZvnftKEGTQwisN3
	B1bvOczupmiWnlqJWA9ABMcBnG0Ygw7gi71puoPyEEJz4UbS5FZeNgURNi15KmOhGGMHzUWeIB+
	exr9WTOxHyEy8gFF1RzhXDBsfDtwqY3ko6mZHCOSf9Jyeah/9VUWw8N/5s8e/bHleMO+Q+P52F3
	+O/R7rTtTaA+AFOfCZdbibv7RVYcVXy23gBBczhNI75BexEuZBeKeUpD/Rk7wDPT5cuMgpdPIeU
	/FsiNjV/OuKZR7aOU=
X-Google-Smtp-Source: AGHT+IGMeoQJbZkSn4nziJnQZeiFyC7pWhma4wLVeyMy280h8HyuLZZxQTvPG2hx4TENFjejCegRSg==
X-Received: by 2002:a05:7301:a08:b0:2a4:3593:646a with SMTP id 5a478bee46e88-2a7192c03bfmr5741573eec.26.1764039552614;
        Mon, 24 Nov 2025 18:59:12 -0800 (PST)
Received: from f771fd7c9232 ([20.38.40.137])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11c93e5674csm76552932c88.8.2025.11.24.18.59.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Nov 2025 18:59:12 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [REGRESSION] rppt/for-kernelci: (build) call to
 '__compiletime_assert_295'
 declared with 'error' attribute...
From: KernelCI bot <bot@kernelci.org>
To: kernelci-results@groups.io
Cc: gus@collabora.com, rppt@kernel.org, linux-mm@kvack.org
Reply-To: kernelci@lists.linux.dev
Date: Tue, 25 Nov 2025 02:59:11 -0000
Message-ID: <176403955165.358.6256582403213124388@f771fd7c9232>
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 0530440008
X-Stat-Signature: 1hrjgjoqpk1egjfmgqjwqa9c11p4gj8m
X-HE-Tag: 1764039553-445016
X-HE-Meta: U2FsdGVkX18Tj7b1VzosHPw2szic7LrbTRc2OWi5m1J2Md/SEuCdDBMcpuJoH0pxMD5okqhMlOfINyRMdDB5yc5FSe0JP1RecC6BJ0dgGl1B1KtdE0WExwNEsUHy7pICys6gHTWMgK0W9u5Vb1QMwSmvEIQF2EG8Ah4OwYj3AdI/0BDAVi0Nvl/zFiy5/Vqf1xULZNr5E6/0aK2V/VVYNnDyjBhhDdFmuTweOTyWBNGyGC3RH0OWY7W3TvpX9S/JXbQEXxai5FJbE29wDYFVhFWeI2Hnc2J+1j1NevLjk5BFNGaqse12769RAbTi08f8PB8hAMR6ITzCJZoIxe5kbo2ox5i5u6FRQG+irBO7eufmKy5E5qhFtDnSKvYCbxzSKusxgchytoTxzhWES69hInSpxUv6HlMokfT8LnPwj/cFg1Vb/PQo+yFpaHcHgSbB3uY2BGblDJSGjGPVNWKRt3QUB78fEBOLLXdq+XEWQDoTQUEzB5g5XoUv5ZJznv2ESizBtHHpcUsGAEHF2T5gGRnKvxPmusughPGVv4xyhmCt7cWOwPDE7cKRcWrDRz2XjVnNrxTZFXswDHw8pZIM0y31Jprs9HwvXWwgQ4Bsw4CW+f2AWTxqGH1yFf8ZnodEEr7IR9cj0f9Kh5HY0K48Ib9M3c6ffzY5N9KTANdRpT/3efpgz7EesSL4GPQzvX/S3KJKZjhkcDX4slk0H4YfWGWQ1uiA98QusMrA5JcVgi2ljn9mkgCrZk94c0eLJ/rLlaoRWY8dFmEBmLMaSAoIu9OAxNSV4mKpHDMGLZs3DZg12E36Hg/UbyG+MXRrbzXDScjcvbjHdCc//YZ9pVj5Pb6gykk3vVa5P99U1jsFlu6Jd5Zx5QiwiuijVK/ISXMvq1cZGQSxNWfDg2qB/0JLEz0SlfSiYBFCJmxjBda7eufnZdUfbuHMzA8EFldQ6sEVd407QQcMBbNw25o26Fx
 31+PZX/N
 eu+akmqKecqkwmTguf/z5qfXe5MsesU/tIMlE1h/kZ8Vxxzi31pV2X6XQfQNpa7NO+JwjH/yIGE0/bLjc8/GW837uTpf6j5jjSx2jMNLtQmhEjM8KwwqIueSmoxPaJk54Kwtlkx/VLWU8nDZx2dcQMdN1x337xHIDv8zZQJMWTlT4iZwuWXKQJ54Unq1hEfMf6rSMg0VNOEiee2oDSqw3LzvESE9Ee9pha3bGWb1lfiSnEMMw5DOHq03jH9Ak31Y3ACj0cCe55cYuYXHtlfIeR60eBFslU5icxJg2syVZlKx8+hfXiQYlwvYL420iObgQvcOMuJN3mt70IyP/uuyn6YIOBi1d0ypH2jARwGv1r9ndBbpGTr4FWPZavEoyJBZ+aPPTitLg1FP2K28NmlOtEMKVdjjvFE1eoUXIFWuQyXb4WrLwWFKRkomiKn7m3W6Od0A6UvXPXm5OesCzeFhkKsFUSce8cyd6HXGyihzj3CxeptlAsLDNfyqco5xW3ijiLjqCsLzfLx0yjJxVxJSQaA4nK5tWQtVqwhMlnWEWSrtfyy3pAltNDP7WjPI2ce/youey9ogZYAFSjCv9pD5coizHoz9wCtNoaud2f4MucpnBNj1lsAEAraizMS2khUiDdzh2OAwTaP9B6YcHu3HhBAY7+8Pn7WiYG2kpPsQQHtXSDQsGIRDoT4dUwj2WX7A5vGG+P+ger6ySvXnvo5S+y8TUJGS73jZ2KWFp6K/hUZwxJOjj1y1pp5TuHANShx5eceuMO0tY6T7JBg/nUP4ppPPzfk5a7dH8UY7K
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>





Hello,

New build issue found on rppt/for-kernelci:

---
 call to '__compiletime_assert_295' declared with 'error' attribute: BUILD_BUG_ON failed: sizeof(_s) > sizeof(long) in drivers/ata/libahci.o (drivers/ata/libahci.c) [logspec:kbuild,kbuild.compiler.error]
---

- dashboard: https://d.kernelci.org/i/maestro:93960d0b3e4b52513b908bcfe11a9e01571331de
- giturl: https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock.git
- commit HEAD:  7a1b17aedd2aad3a04a211865f048903bd47fedd



Log excerpt:
=====================================================
drivers/ata/libahci.c:1161:9: error: call to '__compiletime_assert_295' declared with 'error' attribute: BUILD_BUG_ON failed: sizeof(_s) > sizeof(long)
 1161 |                 pmp = array_index_nospec(pmp, EM_MAX_SLOTS);
      |                       ^
./include/linux/nospec.h:58:2: note: expanded from macro 'array_index_nospec'
   58 |         BUILD_BUG_ON(sizeof(_s) > sizeof(long));                        \
      |         ^
./include/linux/build_bug.h:50:2: note: expanded from macro 'BUILD_BUG_ON'
   50 |         BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
      |         ^
./include/linux/build_bug.h:39:37: note: expanded from macro 'BUILD_BUG_ON_MSG'
   39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
      |                                     ^
note: (skipping 1 expansions in backtrace; use -fmacro-backtrace-limit=0 to see all)
././include/linux/compiler_types.h:340:2: note: expanded from macro '_compiletime_assert'
  340 |         __compiletime_assert(condition, msg, prefix, suffix)
      |         ^
././include/linux/compiler_types.h:333:4: note: expanded from macro '__compiletime_assert'
  333 |                         prefix ## suffix();                             \
      |                         ^
<scratch space>:171:1: note: expanded from here
  171 | __compiletime_assert_295
      | ^
1 error generated.

=====================================================


# Builds where the incident occurred:

## multi_v7_defconfig on (arm):
- compiler: clang-21
- config: https://files.kernelci.org/kbuild-clang-21-arm-6924fce9f5b8743b1f5fa54c/.config
- dashboard: https://d.kernelci.org/build/maestro:6924fce9f5b8743b1f5fa54c


#kernelci issue maestro:93960d0b3e4b52513b908bcfe11a9e01571331de

Reported-by: kernelci.org bot <bot@kernelci.org>

--
This is an experimental report format. Please send feedback in!
Talk to us at kernelci@lists.linux.dev

Made with love by the KernelCI team - https://kernelci.org

