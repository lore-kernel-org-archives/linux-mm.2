Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC06DE7E36C
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 11:24:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D9C06B008A; Fri,  3 Apr 2026 07:24:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38A0D6B008C; Fri,  3 Apr 2026 07:24:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2797A6B0092; Fri,  3 Apr 2026 07:24:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 16B976B008A
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 07:24:21 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 982E413B53F
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 11:24:20 +0000 (UTC)
X-FDA: 84617011080.23.13CFA3E
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	by imf02.hostedemail.com (Postfix) with ESMTP id B6BE780004
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 11:24:18 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BhCm9CCL;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf02.hostedemail.com: domain of komlomal@gmail.com designates 209.85.167.51 as permitted sender) smtp.mailfrom=komlomal@gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775215458; a=rsa-sha256;
	cv=pass;
	b=J0AJlw5cFJImc0Gd+A7N4G5sohhjk4qFzA4phVIoBaTXWbsbMPPeIu5jBECUFjZ2Tld6SA
	P/7GbNpgI1vLXwZat9wNE0aZyI5RQgP3CdxOqDS/OHLSVV2VPUuMoFLolw7rnAAua2D9yF
	+a6w1KhyWbNtWLaJSwTLZnV3BRgBvqs=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BhCm9CCL;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf02.hostedemail.com: domain of komlomal@gmail.com designates 209.85.167.51 as permitted sender) smtp.mailfrom=komlomal@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775215458;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=umLjIPh2y3/m32zCEtyZ2cjg2jY6XyXKS2zVJEijcNM=;
	b=Z3RC80VlFAxX5LLy9fL3ldSHrVbnDFAtbso2BEzRaq0tAsA27CvEAZKJRHZ00wJclWg4kq
	YLO6ASoPLGLJfc4c7lgiLpZgJd690+360xHCmFwmQNOBp0r9nzIqL3xCMv9xryRtbP737L
	NVszqyJ9TTWGdnw1qkAQplqFfh8m218=
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5a3af1b7549so568839e87.1
        for <linux-mm@kvack.org>; Fri, 03 Apr 2026 04:24:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775215457; cv=none;
        d=google.com; s=arc-20240605;
        b=ewXlIdne8S7x/PcU6+uWI8R+//sKTsnmgMS4HDqQFu6nu2jlwdLIvS54uYs4lOHoOH
         sJGh/CXlR4m2x1qfpVAYDBmxR5K9tKNKrVNHKxgmQ5LHfIjkyz4iIEWhB7E2OYZ7Yv5t
         pFr5VyQO+VASnR9dQGSUlvcNLqyXjYQkNGCsUA7JtOHnH4Wu/3CjEBL9ULirRo3O+3ak
         C5R6xvL1ocwrKq0s2DMhlF96wL1rG2oM2QxkiUxc7XEeO4Gi0ku3x4D7RjVBK7+SUAbR
         aOyAUIzEh40EYP17QLgt1aOgehLDxnj6hq3ke6jfTIbtWFARR6IXeOCTSF+h7DyLoW7m
         RDAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=umLjIPh2y3/m32zCEtyZ2cjg2jY6XyXKS2zVJEijcNM=;
        fh=o/EohVIMWGK2qkmZgmhuJVzvgDBzSQjtxrRcy+o9i2U=;
        b=jmFlTQ5SQIxWJLlHSYAXWsOQ9wqML+KMwtk7eB9Xf6nqwBLDhFTd7OHTW3VfdLxdlK
         XDoXC3E5IcNPGgRpmD7IRMXDYYIkfGI+rYRSLWz+DlPTjMIJyhlbcrQH4Y3qyLQds4DK
         nUlDFIgshbbYhZL4FJHDYYRP1E/KfODx4ukZ+msmOsWmeLPolcG+Mo93wi0HLfaPUshe
         37v2HaedNmaszkhwBVBVryYFKh1OLIs0gzoY1+fW0E1iOA0OhVT4MYbHxUyl/8qhZ/+P
         14j5/EmDAj3np9eBwI/DnR1JRm4lsL4YRn69FHPcvgbz74b/vUhlhoKle32I3AUmELzt
         VbAQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775215457; x=1775820257; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=umLjIPh2y3/m32zCEtyZ2cjg2jY6XyXKS2zVJEijcNM=;
        b=BhCm9CCL+X3d9RthCcg7+Q2vNx5Peyu2DF88WLypFcJLdszjJ46unNSvEIFxVetKge
         RIWFoNjZM72+KGKsUn5WHh61M9byg9tFgvkfmxtd5uWkEipSKA+6WtzvacPyRj9uuSFE
         yR0w/6j0iykNA1SLmF1Jgvvhnt9FT+eqP9vS1fvHWN7t+PzexDXc7tGX2aqL4mPOMfb0
         1EfGCWSszlL4cUwrSQufESCWIoMJRrZ3ucvT13buDMMmAcRYXo+KSkW9h/z2eZKaxs06
         6j93uh/ArKCRO2UsNEYBuYDfPkvv6IvJktWUuxCsikOIq0pvtnOXel7UTuE1cc9eJUfs
         1xIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775215457; x=1775820257;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=umLjIPh2y3/m32zCEtyZ2cjg2jY6XyXKS2zVJEijcNM=;
        b=hDn2XcUdmKO4LHAJRoLmtF+WVUpvc889D8M30r1cdbl1BLtJSA1tTJXgCfVTUXfIvI
         20NON/8//9XE42z+KU086cCKSo5U7IjUlON2NLlsGPs0paARi+sngVT11aGFoqGYoglP
         3b9WKbbnRXEHutUjFcAohNlYigVtvXhCZA+qjMtImHO7S0/Euar/FetP6toI5ee2KNdr
         eBxSSFGEpL0ctS5AHJxc315GWvueqI8U7rJ/zU+9lvq/W7ncerKvZnfE+Ow7OjR39dS0
         3+cDO1W6rIJUHQ2IvlFh0puR1dGOQBNHFr9lcxPM0fILfP0I+qH0qVHRcWi/3SBvqpWn
         0utQ==
X-Gm-Message-State: AOJu0YyVs6oFEsbGpMp4fJDu0gk6mTFR+kVS77wiAaj9eZfEGAM5aT2R
	5Bo0niG9VTWVQU3u72HjiBya61ewz653Z8I1dohammHBdBz2LnCxwtFiY2tbWVQyayfIdjqtdAj
	Q8CSTUOaK8YkRiK6Y8HlIbiRsbqJRPoMDi+WYwoGWqzTZ
X-Gm-Gg: AeBDiesRMecsR8Bd4sa3yVD7A7MuHU6pOyDMiUiGQH1ouFLp3cFRyenttDCLnN5UIMm
	TUuCEXe7CNaUL1Dax8FQMgFnN9p7xdW9m7JWU4NYIMNmIKa5W1Hn7b4zjqSbVwp6tXy9HfADvkw
	1AGkKl7Fn5f7VpyC7M3ZAWml12meqx9UA8Ykv6/5clnP/4IqyUxr/hooDPu7BEzNcbChIxsxbEk
	IY9/sEcg3uM0jxgDxfMuaDbacWOdjYcoSoncUTvQWlH1I7PpMqaXivwBzu9DIN9bMhHWfBGXNyJ
	RTDZw94=
X-Received: by 2002:a05:6512:3da2:b0:5a2:961a:f7c6 with SMTP id
 2adb3069b0e04-5a33758bb66mr745347e87.39.1775215456740; Fri, 03 Apr 2026
 04:24:16 -0700 (PDT)
MIME-Version: 1.0
From: "Denis M. Karpov" <komlomal@gmail.com>
Date: Fri, 3 Apr 2026 14:24:05 +0300
X-Gm-Features: AQROBzACmaMWgICk8NsIfGh0tb7vXMdWkgVTd5i_Co-eVxh4e8ZrIgLeQAlCWVk
Message-ID: <CADtiZd0tWysx5HMCUnOXfSHB7PXAuXg1Mh4eY_hUmH29S=sejg@mail.gmail.com>
Subject: [BUG] userfaultfd: UFFDIO_REGISTER fails on low addresses despite CAP_SYS_RAWIO
To: peterx@redhat.com, akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: twrp1n7ya99rdwqao4jyff3zqe11ocma
X-Rspamd-Queue-Id: B6BE780004
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775215458-991859
X-HE-Meta: U2FsdGVkX1/7s8Dc4UZU4plzlhZcnd1+YeflF6rHcjBcfQs7bVTof8yDHQbRq4QQP+7JSI5gN7vAhSX83mhwtMnhw0OhTNuv4qcBEZfO0++zA8okeDuNASHbY5n2VnENyKCZzE+LMvTaM0ewacSpdB2stB3qZxz8lwd32qaA/XzY0zwMObFkDyLVP3SSRmV0MCKf48uHj1KfHRbc3awMdBmR2OZUHswdO52LAZXLtt1tS5Z/oswQFdl9KLUbFJ2vLeoV7nMPi4h6/bkXPgX4a5obhfGVWe6D2NZulqfigVXBxWRXxZcRjluMVg9UeAnI+7nDywQAsqV5SRSEp4zTU2JNsrkqsi8Hop1Weq7c3pJzUKCOQZC+e5oRfTeoCIRnStOMV+0//1Rij4yKfqRYIFKXKPe75Y4yPq3/6fzSjfdgJ3D01oll/uMsbrQZGAmZasDaZVwpQn2dnQI/FplECpulYKYFgpppj7JxtOfKw4XG0/nOzkn+cv71tGYFOTSqfl10WK8Rec10sT3Z5e6kBP8edjWNGfBCh3XImhS0AKQmB7CcjQDqaT69YzISzE8YdIhu93XLFzdnio8l1xG5rFWTdrTRBfDlDr1Wpjw/WKj4+BMmAZL8B5EpuClYEWo9n7ORN3K0mR+xUuhF0FNFWUs0/978GU4vUodG2pvTi1GxHs04oSmOxBQyOKyTHxuTF7KpsHVUIy0f+Z5Re8tfdMqToxBNHF9SI30RzLXzNUZaK1O7yyikXArdw069R2Cjbd7ftmbZNRZW/WAl+sYljO24IjZVY9MykFjv2eqiSbUMJ29nZdkwHwZSecnmQJW4TcCNKK3O7rP6EmyfOqxheg5iPebKUsaP7caKsreNZyeNGX1dvm8oCFNx/RgSsRyIlAiUqy/oVEIvFzXvdagPK6gnrkKF7sFDvitVcry9NodOncfsLe9UzVMs/FJHhKAvSda9hrbfrG4lOyYxWAM
 eJRDAy3e
 P5nm63xQHWR4rIB8Z5swDNX5Brt3b5NVlVQ6WZXwh46qTWGq1PK0JAJQymfeEeWM46cbPCOW71p/yCpHnxWqSGlVUjiY8V16pkTv8IqMPqmtGTBiAYLFBt/HQ+3i+xzZobF0Kp0dtSMYmNY0rq7NLlp9npphOCod2vCkFtuZ1S6kA0IA41T4Gp+e+aMxhw/3CWmuUSXZOfH8SYoLMa6Ac23Kc5GcxZ9djwA44fiqGPgitphMVLJRgU8skD7Ic/lZzC4u58ilYxO7EvFpy6PXLxsx4JYdbwwGYeJFfe0qw0uE449uSRjz68EIuzcppjVPySKF7kCs13NCI4wPa9waiWnAElPHf4wGKU0xf7anDSPKXQoGIAZda3o/RuVZPtszRbYG/jIr6e3PGw4QjRSCtw92JkNUmabGMuhK/OLeiGndSdfQj2sXP3Umhugkcry9gxgl7SL6SnolO9imcxz5ZKRU6uhyHCRnLdzYIV7CxXBwY4cf0V9B0BdqTsHykGD8nxrXXttjHRF1JnGu+YI9vZRZJPg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,
I am seeing an inconsistency between mmap() and userfaultfd's UFFDIO_REGISTER
logic regarding low memory addresses.
Kernel: 6.12.63+deb13-amd64 (Debian 6.12.63-1)
Description:
As root (or with CAP_SYS_RAWIO), it is possible to mmap() the low-address area
(below mmap_min_addr). However, UFFDIO_REGISTER fails with -EINVAL for these
same ranges. The issue appears to be in fs/userfaultfd.c:validate_range():
    if (start < mmap_min_addr)
        return -EINVAL;

While mmap() uses cap_mmap_addr() to allow privileged access to these areas,
userfaultfd performs a hard check against mmap_min_addr without considering
capabilities. This prevents binary translators/compilers from using UFFD on
valid memory areas mapped by the application.

Reproducer (must be run as root):
#include <stdio.h>
#include <sys/mman.h>
#include <sys/syscall.h>
#include <sys/ioctl.h>
#include <linux/userfaultfd.h>
#include <fcntl.h>
#include <unistd.h>

#define SIZE 0x1000
int main()
{
    void *data = mmap((void*)0x1000, SIZE, PROT_NONE,
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0);
    if ((long)data < 0) {
        perror("map failed");
        return 1;
    }

    int uffd = syscall(__NR_userfaultfd, O_CLOEXEC | O_NONBLOCK);
    if (uffd == -1) {
        perror("syscall");
        return 1;
    }
    struct uffdio_api uffdio_api;
    uffdio_api.api = UFFD_API;
    uffdio_api.features = 0;
    if (ioctl(uffd, UFFDIO_API, &uffdio_api)) {
        perror("UFFDIO_API");
        return 1;
    }
    if (uffdio_api.api != UFFD_API) {
        fprintf(stderr, "UFFDIO_API error\n");
        return 1;
    }

    struct uffdio_register uffdio_register;
    uffdio_register.range.start = (unsigned long)data;
    uffdio_register.range.len = SIZE;
    uffdio_register.mode = UFFDIO_REGISTER_MODE_WP;

    if (ioctl(uffd, UFFDIO_REGISTER, &uffdio_register) == -1) {
        perror("ioctl(UFFDIO_REGISTER)");
        return 1;
    }
    return 0;
}

