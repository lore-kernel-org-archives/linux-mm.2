Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8ECD0CCF9E3
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 23:06:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8809F8E0007; Tue,  4 Nov 2025 18:06:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 857C48E0002; Tue,  4 Nov 2025 18:06:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 794648E0007; Tue,  4 Nov 2025 18:06:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 67F3E8E0002
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 18:06:22 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1968D1A0740
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 23:06:22 +0000 (UTC)
X-FDA: 84074460204.23.814CF29
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 521E516000B
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 23:06:20 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=mPWqKod2;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762297580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qNUF19LMDXrrByrO5M95cnYVbIvPi+reT+UYUN6WekM=;
	b=NgYc/qnZrk9H5s9noiopX9wWh+JO4H+4pffCAnIh2k98g1UQVCLGCC0XRJ+e5AdNebHW8p
	udMvSFSAkzJXW3n20iD6JqUibVEUIgiI6b/v1OPBIO6lRNJNqyT0ljWe3j+KgLTWQD/ILh
	Kp1SSDI8Wr6Vl97Z7tmGMHKhQHhjV1U=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=mPWqKod2;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762297580; a=rsa-sha256;
	cv=none;
	b=aJqcTny6WW4hk1bgB6bEutKhAnR+aFhdLCXqjUeE2+wOZG67tyVpCv05+2utHPVnOsBdvF
	nqhh5/Bij141M5ymmYmqZgp7HFHrVipwhNYR2vDIXa0i9C02p7QvHnE9+z9TdnEb0F7i+m
	BpU3H+gt5sxMXlLEHVdyzNzwwFnnWrU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1E8934369B;
	Tue,  4 Nov 2025 23:06:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C045AC4CEF8;
	Tue,  4 Nov 2025 23:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762297579;
	bh=uLlzqy6Di4edIrRuTOYeMvLFCeJz31ipYGrsi9YXoJY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=mPWqKod2jrlekRtHGXeG3Gnh3TUStcLighZEWMMedLEFdPOG/FqegW5btR7SSCpLJ
	 /nm9vrhmvWxDG/1ipojDnSGoO+sF8EbJgNMwY7sfTWkh9gyjHk/1WMMyf3TXBlxIZV
	 Gloznr7TPUNHasBbkm+Ns/scx6H3uukXsWKlRGg0=
Date: Tue, 4 Nov 2025 15:06:18 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, Hui Zhu <zhuhui@kylinos.cn>
Subject: Re: [PATCH v3 0/2] mm/hugetlb: refactor sysfs/sysctl interfaces
Message-Id: <20251104150618.0606afefb2a9e226aaa6ce77@linux-foundation.org>
In-Reply-To: <cover.1762245157.git.zhuhui@kylinos.cn>
References: <cover.1762245157.git.zhuhui@kylinos.cn>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 521E516000B
X-Stat-Signature: rjh4qneu4xdnghoso9daah737xzmuiyp
X-Rspam-User: 
X-HE-Tag: 1762297580-151387
X-HE-Meta: U2FsdGVkX1+eV7vJQrh10oMPOi3B06Cw1nengf4dXFLGwQaSdKplj8v+J6cwwFzwc3FBonNsRE45rTetE5srRgbrEic5CghQRQlp0ck2cghfFobreRfVC9qh0JmAzA1iyYJmsAM2bURdTLJVJOoVEkOpa3gsrSo4B/ckWGmSvD5Y7V4SOmLnKVo0yl6hlgWq4HHyA8xbsgw7hcY6GowkblhPGSMLcrGwHdW+xygpKvazgpYFod6cu0Wsm3R+Y79UlVEIbJ4gldAKUXQjFf6L57l7M8iwH+G8saL45uxgELCdOpdsXQ6nZVoCSiMcyedylPuigZrvscAVzTCuDRlZ9F2OOVXKw21vQRb3yuqvDJVk8B6arI3U9GlOFMgC15xTSFtMdZB5CtvClhCFR8LGKzo0NWoVYHdFNx1IlzpXlTFMNk4kxtcEVyYI1wpumjGum1fQsbhAWBW/BzD/dq/cvbcngGMpu0JzCeooBIhFTIfsAjR8a+LikpCnqI+F+jK3i20lxqHXDjs1bCANL9hOKT/GCfeclUB3anbx83oyjkX383FHsybBbL6Ydf/JmWoCCBZo8bF4DQvXhv4i3fMzbV5Gzd9S3Aaz6/xYmV980lxB/MHV1fM+/xbiYg+O/s0T2dk7ZBBP0H7iscvZdhYPr/vJ1/ICAsQz94FMXIfWyhv9uF4Hb2gzRm9YbVTScpmi98QZU1Mggxg/xrfYRefrZA9EUFW92MyswZ/ssEh2lQS5RCyH8+8a/duA0snfB5H6C3uykAUvQcYuxQBxxhLtqU4Zc8smWK/CaaRMAdCTP24N7QJaV9cOemcmu7mvX5g/Ufdbz/+LUGeyA3AlgC91CJnikYSS4n7usQcXThhq1C5yeX8/ZpVoMjSbG/NNiXMZyFff1QAkU3mBJp7BTzhkghzUwYR70N50NRmk9cG/5JDyMkbUKQ1HsjQPt9QPmO03qsmZJNketpDU2fAE2kW
 t+8L50Jk
 qqm4pvfTLr9KLVPcGein08P7hWwuEO6OdkLhzIZSt5HgyF6vOHVQ8ZJelXU3vI+OvbkFEbU9jytvr/+/Yyn3bJJAEMrJrSavR4niq7/JgTyUaiLzPkZH8yL0IL1L08W5xHcq+RlPkVPhchTZe5DnwBZaLuuv0scoP1bWmR2RVnHqnGQjvr5b1YUkLKFcpepcSXfkCsn3f8NDu5VMk3gsoX3IZpWKrJsgDHq5sLc2yH2tPBgeaRQOSHUgQ0A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue,  4 Nov 2025 16:37:41 +0800 Hui Zhu <hui.zhu@linux.dev> wrote:

> From: Hui Zhu <zhuhui@kylinos.cn>
> 
> The hugetlb.c file has grown significantly and become difficult to
> maintain. This patch series extracts the sysfs and sysctl interface
> code into separate dedicated files to improve code organization.
> 
> The refactoring includes:
> - Patch 1: Extract sysfs interface into mm/hugetlb_sysfs.c
> - Patch 2: Extract sysctl interface into mm/hugetlb_sysctl.c
> 
> No functional changes are introduced in this series. The code is moved
> as-is, with only minor formatting adjustments for code style
> consistency. This should make future maintenance and enhancements to
> the hugetlb subsystem easier.
> 
> Testing: The patch series has been compile-tested and maintains the
> same functionality as the original code.

Thanks.

>  MAINTAINERS           |   2 +
>  mm/Makefile           |   2 +-
>  mm/hugetlb.c          | 852 +-----------------------------------------
>  mm/hugetlb_internal.h | 113 ++++++
>  mm/hugetlb_sysctl.c   | 133 +++++++
>  mm/hugetlb_sysfs.c    | 629 +++++++++++++++++++++++++++++++
>  6 files changed, 887 insertions(+), 844 deletions(-)
>  create mode 100644 mm/hugetlb_internal.h
>  create mode 100644 mm/hugetlb_sysctl.c
>  create mode 100644 mm/hugetlb_sysfs.c

Seems a reasonable thing to do, although those who work on this code
should have the final call.

This amount of code motion might cause some (easily resolved) merge
issues during the rest of the -rc window - we'll see how it goes.


