Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE9B9CFD36E
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 00:59:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9A1D6B0088; Mon, 24 Nov 2025 19:59:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4AC96B008A; Mon, 24 Nov 2025 19:59:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D60E86B008C; Mon, 24 Nov 2025 19:59:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C569F6B0088
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 19:59:15 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0EE65B8DC3
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 00:59:13 +0000 (UTC)
X-FDA: 84147320586.15.18ACEC0
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	by imf16.hostedemail.com (Postfix) with ESMTP id 43451180008
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 00:59:11 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernelci-org.20230601.gappssmtp.com header.s=20230601 header.b=ij4DBA8m
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764032351;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=we018xvjM9doGI0IyR5pf9MGTmer6+vGWKse30i/Aq4=;
	b=nSYTeXxrylpB8LK5/Ubj4KalhlBEKPncNk11zzeDYOEpoI128hASGO8riOyydYxUPN9Qe+
	dGTJ0aI1gGxMbOFE+aSI2dsuTJ4ksSWfbSNdn1vRlhLSDwgcR+g+xSe6DVHVpKFPc1hz5f
	MVTLAFraEu0j+BBWqndOxmpG3LRoqz8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernelci-org.20230601.gappssmtp.com header.s=20230601 header.b=ij4DBA8m;
	spf=none (imf16.hostedemail.com: domain of bot@kernelci.org has no SPF policy when checking 209.85.215.170) smtp.mailfrom=bot@kernelci.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764032351; a=rsa-sha256;
	cv=none;
	b=uBrfr8iY96iddYbsvvpfb8jxmjVV4XMz4cJ4oedeJaPWd23IMCM9ghWrCKuepruyZBFuYl
	Je9O+JCEL+ZON4c+RT3HVo8eJtoUNvA1FTSHqDRu9nuTK3A02g69bgk26Q8HS4ghJsp3sG
	T5pV2pkvDx1fH/XLKfJCdFfNBDhODYM=
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-bde0f62464cso80961a12.2
        for <linux-mm@kvack.org>; Mon, 24 Nov 2025 16:59:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20230601.gappssmtp.com; s=20230601; t=1764032350; x=1764637150; darn=kvack.org;
        h=message-id:date:reply-to:cc:to:from:subject
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=we018xvjM9doGI0IyR5pf9MGTmer6+vGWKse30i/Aq4=;
        b=ij4DBA8mERLIDI4KHa+aovInSGwxmn0885ciFzk7wGGJIoqIjrAJItqAkat5vIXk8N
         XQWy/z/mgHBbBI8MXHQRDeyYJPRlpdS37JQJkpfImsYZ72qGDQdRaspNUFGfOy6yLwJ5
         sxAj6Zq0SXP8C4VTjfOQo2WJn5cUmZxsJVDfhzAFQ0V7lTuxndL5ViZnEy6ypCpJ78lM
         RAJ7PAXWzxRRdwzOcwdGskmE4nGDlHt++ON3qjwjqvZH14CyybDTZKHo30dsxUP4GpMn
         ODBoCV9eNOf8UaSfNE6mcd4inPYxF3gzO7y9DBgANgDeL9VQsuJV+9k4rcQh/XEavAUx
         xkmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764032350; x=1764637150;
        h=message-id:date:reply-to:cc:to:from:subject
         :content-transfer-encoding:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=we018xvjM9doGI0IyR5pf9MGTmer6+vGWKse30i/Aq4=;
        b=D727hRxNfe+kjotYdl28etHRy62jVOh5KP5nz1fjJ28jZvxRIK4zlAieWosDdrjnHN
         UKGI4VIrHZoyAzWqAzoW3g8dvGhgLsZ0WrFIczJWAxYCmNFPW+8W/AeKEfhjFFUHdDkr
         R5kHTTPPOPql3Xq8dxjxOYTJQgTQ04AfCVf/l2Rn4KBvP5fSrh5eVuq3Uokk2kd983OF
         tE0bJO1NhdMWMlxQiVkYQ8HoLru+8xVrTzMXCXKzlGpSaAWy/rTWECR4ciUgTceee/a5
         RPgLr4f8GatzUVN5Jgh58pDwAldZD1ZLwcmsQ1YuldvBiHRPS7HruB+YBjmRdVi4KEv+
         HkjA==
X-Forwarded-Encrypted: i=1; AJvYcCWGGyw3CN2zUt7HgiLRGiAmJ2wIEfsFvaSDSzLJvrWsukEc6731RPWgAWjRuTskagy9WrEXxu3MGA==@kvack.org
X-Gm-Message-State: AOJu0YwT5ZT7IIcWTxWv/3ugxM1Szp0qq7puj1NXBq0r1yBkPnOG9JuJ
	bt0saB+HuMcDudzXAMJNq48uNoKgjRFyRZt2k/EmYUtdyi/T1kxfEr162e0pIKtwOq4jJ3eONfr
	ycZhA5yE=
X-Gm-Gg: ASbGncvIjIUN4cXb3Rv6awZD++GNV3FbP6c5HUJ0mHjGB1jEBGzrg3Apr9ve1hu39G8
	YfzOTepPWJhdivjISc6vIkiM/xiMrIEl2h78OSl45tXJc+MKg+0kaENVCJQXK2qmyyVH8z5gXwa
	A/wq8ettNUh3HSe0S7UfbLz227gAEbkNjcXXWyhG9TCYNPBn99Y8iYepSDu261Nj/tkVTqv1LwE
	jk6Et+brqEwrUynos6Odf5is+fHiGyJyM719443YgxXHr6mQHr6vxA2POXuNLxcswIzhVH38tvc
	ISJ0ZpQZ4fFZUilTvgVo1+7UcJXw5eS5jjqRVXCqqJUDVIqh+nAG0vYm3e0uHaF8KruK/Vqjbry
	roZAIYXqMMsIHjLILDCAo2RmxENxZPqBgfrBvX9MRDTFRI0Nq80uybZ7UEeFpgB+yItX52MVLFy
	AFCyHB
X-Google-Smtp-Source: AGHT+IHVGjN/L8J5cJscFfjYBlyZg4G/S3JiJkfCOzhjQk8PPHFobWgn0AW8Vo0BX7zVG8N0nJYnBw==
X-Received: by 2002:a05:7300:6115:b0:2a4:3594:d54e with SMTP id 5a478bee46e88-2a719d86ae3mr7784862eec.27.1764032349954;
        Mon, 24 Nov 2025 16:59:09 -0800 (PST)
Received: from f771fd7c9232 ([20.38.40.137])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11c93e3e945sm73301277c88.6.2025.11.24.16.59.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Nov 2025 16:59:08 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: 
 =?utf-8?q?=5BREGRESSION=5D_rppt/for-kernelci=3A_=28build=29_in_expansion_of_?=
 =?utf-8?q?macro_=E2=80=98cpu=5Frq=E2=80=99_in_kernel/sched/fair=2Eo_=28kern?=
 =?utf-8?q?el/sche=2E=2E=2E?=
From: KernelCI bot <bot@kernelci.org>
To: kernelci-results@groups.io
Cc: gus@collabora.com, rppt@kernel.org, linux-mm@kvack.org
Reply-To: kernelci@lists.linux.dev
Date: Tue, 25 Nov 2025 00:59:08 -0000
Message-ID: <176403234818.318.468450848595411858@f771fd7c9232>
X-Rspamd-Queue-Id: 43451180008
X-Stat-Signature: rqs5gcqudxq6wu88od7q7sbrcpi83on4
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1764032351-812472
X-HE-Meta: U2FsdGVkX1+ZgCnyJ9lUaljhF5/GN8oSFWYFaAFd3cJIuPF0veu5EOsBBKkxqHAnmTn6v5aeJ9itxm3jd+xgU0qdh5QxlMEiMI9pSeQZOg+BzeFBmuM1TXtsh68yrKpGNzbrFuR0np9NydW+oYifE0yTGm05FgtbEQVVun8Kd44ve6J7m42qtwp9oaaYPKWx2oyCc7ELflUSqyTducH6Pxndp7Rf19FBJl+SsKp8Pao81EUJLmaaG5QQQPqKNAT6OdLNKvlSVTc8C6gv7ZL612qdyP9XS4s5Xa3TKh7DvxHTrMj4oCIJldC2F+rdwwfgL3mNdgmwbezCZ4O7EJxyFhVK6FVpobI9lfadsP6gzF1PKF6f4fx+PZyu90jYuN+hhwBf4pcV65CCSfzZaAL/C+26evLTpFu5O7+crAYrjNp1Cfopi56pGo4CnNX+MSbKTw3EtQqtD2KaL1x2o2/2vLi9VJbp7yC8Z/U5dhq8X289Q2OyT8V+skUNY0sS8WJ+O/EJ40Ef9GTnoCzO1zlMBhBdOlZwopRsEfwMGhPJkQA9qetTTKCRTpbV7BZTfUYU6OXXaVSRFUAWmu2u+JJlPWNZKc/WTA2aXr3OD1SIPLy0CZjoJKBMI5RGfzhuwLjO52dSRUY7Ux84F9y+0dV4EDtQt9+JHBFZEXP59Rol4N0v2L94SrpiWhrqx7th8IKC2xvUYG7Lgfx84qicSinuyvXjclGvPQJSpsyKZjEwxDTnYagUroaQSLyGz9W9OQp2Glz7Zbew+KqK9D3hUqKB6xOS/sVR3BUJ0tMEomdu+57fDjWbp9/rXjVnbKa78tV++VUqKIcxKHxrOICX46SETBGy63sMEx7nbbYYc5k7OmtPy2+zADbYxgWyvKkesAyZPDKkha6VYEYI1vAeKGzfytGm32y3mApDATbgm+NF/G8Zard2osoIdAWuWhLtOmRkkb/sv6WtSmgzkROlvh2
 Yn2XHPjU
 UcLDKegFR+GmAIM23QEd8MQme22djybvQ+2dnIH1dAF4UHAnJdRBC7F+/59E9sawXiOZHMZsu37H/UOHmfD+Nfl0wIj20xLw2Wrgb2L3J+GSgs+JMiMV7GcRxgmsU28box1UAWLT335d+F+qUj3exSyT2vzido/df2oW9sAVeBd/YUY3yu6dTjsbelK8E+fylCEunW2Ge6HUMQZPS7hj69oGjzXg1L5cr6yOWTi9FmGZtKO28ZmrLnkinnSsqizqF1n69zc62r2B/MvrgFT6AbvlUwDJhMM2pqX6kVa8xaAG6hOtdFkgLgPFN4QqE0TR5HeYtjc7sqJBUbBHE/ps8la9syL2QQEGJDmZvxwQ68hqISpJ5njAJrn67XoQL9uuo8qhYVK/V3rCKHGty3aLheimbXappO3qnmUO7D+1gXPQWM53B4qIPgA208Kg3rGliEF1hHK3fq+lOz/Fb/I2Eut7YOBMv2Phvg/iGdzuaeLDPE6BR9cuqE0lxCV2uf5QNXMdllZQSqUuU/us9cZQ44PC6Sd5upFrNZBKfuhDuihFP47XEfXCGCTLyI9AUQjGdX3cfPm/vfzrxBP+TRQ0YdXyysyz+ywEfWf7NkNv43AK3BX6QRJ67YtsabT/aA4oPSbcwjjZCSP+9B1KFkMJNAQrtBTB4IiB9RXGjww0LsSaZ/hUxtQ7aFWxBGX/uES5IaOJU2Wq8ROC2e9v+MRnkrC5BNnlSHLnx1BQIZuR6SSvDaQh7FqLh7a/nECDVH7y7HV3PMq/etwZNJlNzgRl+14NiuaO5maaoD/cxwq/bsIgqeoSKt9LQwUGsBw==
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
 in expansion of macro ‘cpu_rq’ in kernel/sched/fair.o (kernel/sched/fair.c) [logspec:kbuild,kbuild.compiler.note]
---

- dashboard: https://d.kernelci.org/i/maestro:611780ef04e41ebe53568a14b8674b1106ac211e
- giturl: https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock.git
- commit HEAD:  7a1b17aedd2aad3a04a211865f048903bd47fedd



Log excerpt:
=====================================================
kernel/sched/fair.c:6019:34: note: in expansion of macro ‘cpu_rq’
 6019 |         this_eff_load = cpu_load(cpu_rq(this_cpu));
      |                                  ^~~~~~
In file included from ./arch/x86/include/asm/percpu.h:390,
                 from ./arch/x86/include/asm/current.h:6,
                 from ./include/linux/sched.h:12,
                 from ./include/linux/ratelimit.h:6,
                 from ./include/linux/dev_printk.h:16,
                 from ./include/linux/device.h:15,
                 from ./include/linux/energy_model.h:5,
                 from kernel/sched/fair.c:23:
./include/asm-generic/percpu.h: In function ‘select_task_rq_fair’:
./include/asm-generic/percpu.h:19:22: note: while referencing ‘__per_cpu_offset’
   19 | extern unsigned long __per_cpu_offset[NR_CPUS];
      |                      ^~~~~~~~~~~~~~~~
  CC      arch/x86/events/intel/lbr.o
  CC      kernel/dma/direct.o
  CC      arch/x86/events/intel/p4.o
  CC      arch/x86/events/amd/uncore.o
cc1: all warnings being treated as errors

=====================================================


# Builds where the incident occurred:

## x86_64_defconfig+kselftest on (x86_64):
- compiler: gcc-14
- config: https://files.kernelci.org/kbuild-gcc-14-x86-build-only-6924fd13f5b8743b1f5fa56a/.config
- dashboard: https://d.kernelci.org/build/maestro:6924fd13f5b8743b1f5fa56a


#kernelci issue maestro:611780ef04e41ebe53568a14b8674b1106ac211e

Reported-by: kernelci.org bot <bot@kernelci.org>

--
This is an experimental report format. Please send feedback in!
Talk to us at kernelci@lists.linux.dev

Made with love by the KernelCI team - https://kernelci.org

