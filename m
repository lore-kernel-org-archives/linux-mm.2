Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F00ACD4F54
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 08:26:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00A906B0092; Sat, 23 May 2026 04:26:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F20BE6B0095; Sat, 23 May 2026 04:26:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E370C6B0096; Sat, 23 May 2026 04:26:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D10D26B0092
	for <linux-mm@kvack.org>; Sat, 23 May 2026 04:26:51 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 70348120AF9
	for <linux-mm@kvack.org>; Sat, 23 May 2026 08:26:51 +0000 (UTC)
X-FDA: 84798003822.29.499A8F5
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7F128C0003
	for <linux-mm@kvack.org>; Sat, 23 May 2026 08:26:49 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dZT53pi7;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf28.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779524809;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SIHtSod+ud/i1BaxCd3bU1q+Iaraa0atqJHPQ1kK6FA=;
	b=1RGxdz5PRTKb7x1uFSACzyBcVf5rlY+sNlDYMPsBMNV0EfsddDBdTnnbAFjXah2IMQRDIy
	HN4XraJavPKN7sSm51XayUl5wZuvgBIfMURjJ6S9ltDkunJRjkptmE8dqzsplbbu88EfHV
	rbJvFVTsLfXpWKm02f2jCnmXT5v4kAM=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779524809; a=rsa-sha256;
	cv=pass;
	b=IKpcyxAVA4bJUgBO1XUoddbJKEsWm7jVv91zGE0MHeFoSRKIYOcYcx3VYdQMTeWXvSaTST
	1+z0XYCXSbiz6HWD9PjlBaSUMdLDbYHDKYLmH+YVA8KSm9JSAjMge+RLvmEyNyj2h9NNZ6
	J02eeCiHO7dmB5Ymzr41EUHnlh/NOnc=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dZT53pi7;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf28.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4903997fcb5so25301545e9.2
        for <linux-mm@kvack.org>; Sat, 23 May 2026 01:26:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779524808; cv=none;
        d=google.com; s=arc-20240605;
        b=LZ/Y+zZwe1WFSAQ3B/GWtKeyvMubdf8NJS5NFB68e8loBzUiUz+aJUsYORSqMBntpP
         f2GJP4RO5erDioEuxIPczSgXfmPm3LJLjECsmqis0D4JTtDx+jT3WHS/L4ume1PLDPxZ
         x0YVrI4GdFmUG6HCX6yMadt+8RcwrbxUgHzKhZrbpBGH5Fhd5srCGDLHHu/dvDE+e41H
         UIcSkDfzSQtAZboxZAGtq3ttm5YtEnLW1++hmwZp9Av1OssIN7LXvP1gRj3UWl5N3DlK
         3b4VhCLJNckIBX0vmcuJi6V8C6HKpAcHCId+Pj5bh7Z/XipDnrvB8S4W5AZ45IvSv64Z
         wnHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=SIHtSod+ud/i1BaxCd3bU1q+Iaraa0atqJHPQ1kK6FA=;
        fh=/NprOsIMzKmWOXsTGe/KSoB8xOlGToHbyU8JTSpif6U=;
        b=MhCR+BagRXDp8GNZZJPMLuqE8lCKkFZy3m7BbAENIHeUWVLM/LGqKLSX4qU7mXGxrX
         jAKIAU/6LQLbvuynBkZwQnZGH4mbMLpFL0trCxloEbGg0RbRemtHJbH4QtYE8A1Lv9vz
         nkEOK9PhOZyNkNCWoXo8EbnIw7V6Sg2hxvVgQC3/T946WIELAYTCgoUzHi5DEteF1pyR
         dNO+x1z6W16TJ6i/6gDB3ZLTu5c9CcUechg4gIIChW7usOtYaep5pHWaODWBjNWfyKPB
         3ZHbPs71N8r1FDEw6XLVLBpu0fMQA9NcZvWsVHfk823jPjW4xr8zxOmZJfJIb2Xgy9z2
         seIA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779524808; x=1780129608; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=SIHtSod+ud/i1BaxCd3bU1q+Iaraa0atqJHPQ1kK6FA=;
        b=dZT53pi7NHM24roIW+CQA8kghBHT0L4rjSK4uRaN/NwgAJInXNS5G+0jqM8fcd7aee
         Lo4DOWvb++yGCKCiH6KrveMNJEfgMrW6FW6QT+YbjXbn91L8KjqgMbG1Ue8In9oMLU/8
         SCOk8Al1/TK6sNmqX7Jf23lPrqfO4BPkiIK7PTQo/tTta2NcR02AyLfrR7holl1gxcoo
         pCfW428b5hssNmHKLOuO+TW4f1/gCgR9X2HDzBMLmcCJMk6GTenr6L+6zpVE4/6j/NX0
         KSKrEARC3jAVqS9b5XcbdHdAnIEr9ghYS40lEAOWWv0PxOvAVRm1a/W88iVhOCFmm/m/
         jLfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779524808; x=1780129608;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SIHtSod+ud/i1BaxCd3bU1q+Iaraa0atqJHPQ1kK6FA=;
        b=f/TiHpcXZ/vx0e+WRx59DXNS2t9otqjHfsKLeRIVqhYCjL/Vnl73DgIAMzi6o7DaCr
         4C61T5wULt2lUqEGRwI9B3lC0UMGAVEEb3ZHZOnfqWoqZYTV3rhTZgU1UCgWmiJEALcF
         1KH4/YjoqhEL88MteLMW22EivpOckbDC2vX71MRaU2GOB3CXobyY+7ohf4rIehl4LbX6
         un9jyUysPtfnwKp1fKyy2z8RuU1M37gUiEyTm5w2f90MUdF5f5ZbUsdSCPe1kwNXnaBN
         lS9ISu/DpfUf61gZ67fthU5qUWOSIuCa46aXwnPaadx5mFzfi3hvHJCevKw6IxrVd3hS
         6fHg==
X-Gm-Message-State: AOJu0Yz3NU+PkbxEhxhupJtKUeqBDOBz5ZGj+DPNMTplKNnZdLxsmTsF
	e/UpgMlaojSCJUDgGogC8jY4B7QYD2qaNWjz9u+e1BfbgO/Cfh/RzXAge0aqLjpa3mDQa5khguQ
	5o25hl2tkPOtSbNSZOHDw3jYfXQD66yY=
X-Gm-Gg: Acq92OHjSoxkAhcZlAQJ81QlCPDXsTvRCp0O4IgD3M4uUF0vq2Wu0CTYIdkM2uj7N0p
	N1Xpkb6qGUrXBW3zxCqMQd6ZOYDmGOYvU13+Mv1iv8tfKnid/l31JkotpOTEePN8ojPitAclv+X
	xz8etW+9PCW6SLEZPOII0Ld7ytdoh9aXitEcGd7cL2MZDkOqXnX7hbMo21LQ6bOGH2Wi18veCOq
	XSu0pazCWjDT5rMm1jFYkDsCeWYqUt7kPquroEtaCoiVddo+UbFxcqSJIWiDXpzWqFovSmitDi5
	ucCQs30y
X-Received: by 2002:a05:600c:5488:b0:490:47e0:e13f with SMTP id
 5b1f17b1804b1-49047e0e21bmr83896865e9.3.1779524807627; Sat, 23 May 2026
 01:26:47 -0700 (PDT)
MIME-Version: 1.0
References: <20260522053146.83209-1-jiangwenxiaomi@gmail.com> <20260522110727.fc7dccf90bc8513abd1fdbf1@linux-foundation.org>
In-Reply-To: <20260522110727.fc7dccf90bc8513abd1fdbf1@linux-foundation.org>
From: Wen Jiang <jiangwenxiaomi@gmail.com>
Date: Sat, 23 May 2026 16:26:36 +0800
X-Gm-Features: AVHnY4IuNlS6vXd5l_7DzxfQJADSEXY9onGk8AY8EdDPIdYUeZEc3Hk2NgVH_yg
Message-ID: <CAHKocdErBXQLs0izMaEJg8fLgjPahY0fGR3jfCQ2onS49TWiog@mail.gmail.com>
Subject: Re: [PATCH v3 0/6] mm/vmalloc: Speed up ioremap, vmalloc and vmap
 with contiguous memory
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org, 
	catalin.marinas@arm.com, will@kernel.org, urezki@gmail.com, baohua@kernel.org, 
	Xueyuan.chen21@gmail.com, dev.jain@arm.com, rppt@kernel.org, david@kernel.org, 
	ryan.roberts@arm.com, anshuman.khandual@arm.com, ajd@linux.ibm.com, 
	linux-kernel@vger.kernel.org, jiangwen6@xiaomi.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Stat-Signature: 5gzgmfkz39c8kz9xdaz5engwxom3sjgp
X-Rspamd-Queue-Id: 7F128C0003
X-Rspam-User: 
X-HE-Tag: 1779524809-348383
X-HE-Meta: U2FsdGVkX1+ZlmTEt3k02McoLadCrdjsTTqotugZDxFn3lCVFKml+WWGYIZD5TAt9k0hqn6V4F44RBqOt1xRrfjCYwjg8ERT3UzZe6DTzrwUOjnOpWPLccnWbIUwyweSTTG+yZzy9RV6FPXI4BNXl2V55CcmpzpSJNp5tffP5GdBymKEtSQrwF2iBE79fH+sm2ho743yeSsyQgcgaxf5N92CFJhbFRCdmIrEnN8dpiqQDGdzM6IP0RiLt3LZPwIjPaFJ3D3FaFxWNAe4QFJu3gW3mnlz4dk4w6/tSJ+5auQIo7ADPyYzywfMwiR0B0wYIvbuRJJu33tXp/Kq1w18J4g6RODLgmtKhb2AN+zfTO0MelhFB7emidD2jU+siFWbQyASXbZEIj9t2rrQ5+uOJ36tDOAVvQq2CNVfrJ4jFOGn+OQ0l4ebNMZLZUQsuCudQwaOCRL9XIvbavUR3GLpa7Zh4ca7VqYhAKiuaIefz7IXMRRm/Qozthjkl7ywHVtEHYfRM5Tf3GrkkLzTSgjT/V9d+2F+gtKo0zlaIaW0yRV6rAtkD19HQdPaEU6z4uyytPVmMrMJZ5VE+fpzmOIdy5NYhUSJaeVcrXsXU2dceBt8dyYCqGxDZUUEyt46PKerGmECit6bivuM50jP2KKx84V1Z/DETbttolWFlB5lcAVqIeShvdF3uvBiq+u9Lx12ERF8opioohIVoWf+bg7tDu9e4RsWBHDNPeHAVlb5lSAfyRrrgpsZiiHVOcJ30gxhbL8JyN5O/BHZL7JGfnpUB0yfmZ1uEpPFlBltbIiq+mcibqGX6Ki+xq80lpf1exQUdDU2VFz4UFCC4/TYCTb7ASi21sq9P5QUKNPyEGz4NUTQy4UrUczgXEhqVvcvQK/fX1T9QVPgyhBxL08NFSTDDpW89Xb9emGvRovlTn39HB+pw8vdXeoVgz73VA0dk0pSnUZuTrSjTVDroY08C3c
 zrPyJGVQ
 o6DuQmmG6o6qpOhpmKNWDXIdRrLnGEAPXLnt1EZD4cjoHlNaRqrLyaUA6vNAEmnRPHWSGYRgMGkH8aDiQqVeONWJt68p709rghPqXI3kFIrEhJ7uwWfwMgmvISy6RIF5L0BjBksv/eHwV2CVItmVFIyMiO1GkXE13UVQGvMV3iBBYlK4kAweVueDsVj5ruTTEUUOF5o1rJ4C54lZZU/rQ+bDtRgEu0ZhvnSlHx6mZgzjxoCk7h3dhE1gF1SNCTbWtIzxQNqU/tHzNSgnh5iZY0sW9AW9zEptaHOtbHm5xZCkanY2FSJfGWTYem+Tpu60XKBiDOLUJiQCXGYuVRKI6EDeJQesymwL0AYJYMKkvIh/YZhUT0fa7BZio085tegqsiiIGCAorUXFlXMUju+xb2ucdhBcVS5yNIHnzLNQ78mKgR25in7br4x3XyHSztLo88HfhjOBir13zK6BzEwTPDWGPd+wRUuzhD7J6Eu59BdcdPWm6C5f2UzrjsNCg8CXoRWhEjCR2dMhGdF87JToUqow4JVfFPhQuen+VNgSzSh/T84S+7A2cmVjJ+qffM0sdvV+LGAqTu3kh6D4pCRWGmk1jQWg8JQLZhPLZ/zfcP5/cBQI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 23 May 2026 at 02:07, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Fri, 22 May 2026 13:31:40 +0800 Wen Jiang <jiangwenxiaomi@gmail.com> wrote:
>
> > This patchset accelerates ioremap, vmalloc, and vmap when the memory
> > is physically fully or partially contiguous.
>
> Thanks.  AI review asked a few things and might have found an existing
> 32-bit bug in vmap():
>
>         https://sashiko.dev/#/patchset/20260522053146.83209-1-jiangwenxiaomi@gmail.com

Hi Andrew,

I've gone through the Sashiko findings:

- Patch 5 (arch_vmap_pte_supported_shift on x86): Over-interpretation.
  This targets ARM64 CONT_PTE. x86 falls through with PAGE_SHIFT
  same as before.

- Patch 5 (1 << order overflow at order=31): Over-interpretation.
  Reaching order=31 requires 8TB contiguous in a single vmap()
  not a realistic usage pattern.

- Patch 6 (GFP_KERNEL triggering purge): The purge only triggers
  when vmalloc space is already under pressure, and benefits the
  subsequent PAGE_SIZE fallback as well, not wasted work.

- Patch 6 (32-bit count << PAGE_SHIFT overflow): Pre-existing.
  Will send a separate fix.

- Patch 6 (unconditional alignment without checking contiguity):
  The main vmap() users typically pass contiguous pages
  (e.g. system_heap order 8 -> 4 -> 0).

Thanks,
Wen

