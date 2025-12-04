Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3954FD1F9D5
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 12:38:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 770BF6B0024; Thu,  4 Dec 2025 07:38:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 721236B0026; Thu,  4 Dec 2025 07:38:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65CFF6B0029; Thu,  4 Dec 2025 07:38:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 577996B0024
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 07:38:21 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DE169C012F
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 12:38:18 +0000 (UTC)
X-FDA: 84181741476.20.F653B0F
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf28.hostedemail.com (Postfix) with ESMTP id B30C9C000B
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 12:38:15 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="INK5L/HF";
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf28.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764851897;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9WMDl+O9DzyplDmfOZSSNkC9lG7nQ5YodxncbmLOYqU=;
	b=Q5cNnqW8I+OXBDzkJVVxrf2+0TLkta9yOjAAJNUSG5myd2auGDkZDscSFpCxsqDowiIsz/
	pRWLRpr6oka4yfywNv9DG0Bx32S6d/oKgzybhI7XzyymT7uE8MgkGtcwxM91e9/Xqabp76
	SxYJXZU/cwJD1TxXBXRA3cDa7cNYyDs=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="INK5L/HF";
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf28.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764851897; a=rsa-sha256;
	cv=none;
	b=j0BP2M3wsYtl5iU3F26+C76GVNXJlGp6j5JffpIq6sPV6GORaAQp15e8uVkl4iCDsGUEdy
	e3vbNYXNclS/TM9qDodrq3OEqmZ8HafYMXBjGRsHBLDSD4YXlA5pq5MnLPj5VdygI3QlS6
	KxogNQEUSCa7UrMVP1htAvX1kKBqjtY=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1764851890; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=9WMDl+O9DzyplDmfOZSSNkC9lG7nQ5YodxncbmLOYqU=;
	b=INK5L/HFMbpSMFwLPyzw4jeQxMAUjgbdOBUjGCkoij9yCUR0NhWq5+tNLDM3Vc2P/pcWY/pP4LZSUClM2rz7ElCswM5pJ+PnykCAiLjap3LF+QrwLRTy325qMYNtR+zBxIJTmh9wJUYlgS9BUgSNf43Hi8MwXY9oaqJcm9WZT+0=
Received: from 30.28.193.34(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0Wu4Jrgm_1764851888 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 04 Dec 2025 20:38:09 +0800
Message-ID: <a0391c46-d7d2-45ca-88e9-de2b7c59263c@linux.alibaba.com>
Date: Thu, 4 Dec 2025 20:38:07 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] [v2] mm: shmem: avoid build warning for CONFIG_SHMEM=n
To: Arnd Bergmann <arnd@kernel.org>, Hugh Dickins <hughd@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Pratyush Yadav <pratyush@kernel.org>,
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Kairui Song <kasong@tencent.com>,
 David Hildenbrand <david@kernel.org>, Christian Brauner
 <brauner@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>,
 Guo Weikang <guoweikang.kernel@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20251204102905.1048000-1-arnd@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20251204102905.1048000-1-arnd@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B30C9C000B
X-Rspamd-Server: rspam11
X-Stat-Signature: 7wsox4hw7bpy4efthcoatfsu5sg1okpy
X-HE-Tag: 1764851895-102169
X-HE-Meta: U2FsdGVkX195t0j++P9B3X+XDALluExX2M/bDd9BMbCgDnsSjdCYFV55DihZac3ExAqPWs2nsl54iKRhZ9gwAyK5l2v41wc/AByT+eWujyjORylyQMvx8RX/WNU3R0MHwlBgBTzkKA1bD4jCA6LZIl28LVfgl+3ibA1sD6eCJGIKgwahnEUkCQNHMIpC6uAercUC2FXB/HhNXTh4/CamzKg02Lwa+kE0b4GLPO2yo8NcMO3+mfAN7X5SLLUERuNAP81H53yXiTuh9T+Wq6DBxDPX/QQm4R8K1JFEeSY4ZPmFrcoz+neyU1TvQ5iWXNMRnmR2/E7bR2RgvH9pmAm+0vyrhPpsffFLp+z13X8E+YWVuNW1fhRu0sdaWTKVq/G/QDuk7QBmyrHAhZk9WlxIGg4g6O56tAqSx+mWf/DSzVy6qLIIyi1K1fyuGYvB4SFPcQGQwSJvhL7U598zZ2PsPnwcyJzSaNThgcpDSHSDSQLYBHQTv0/pvsb5B7BqbfNaFALl/bNuqxOyDFQUdCkaX3VWy0ktKiyXhraZ40rNXbsKF9V70i9CS2YuaeW9f9Lw961y1cOm3P0qTagySa8RpaW9bHbhQvNyy/doE10s/82gWxx/kMdU/SVzt4khARulugILxDVg4ExFmPXQ6meQQZoU9nRPVXopOZdkOt03ukoMLrvtJ0obPdJDyJ9/2WVcvCv2uJlABGRwDk9ed7STo1auMHoUZvDMbLfYNWjfc3dyWFrPiDJtOcHN2aenanJkjrfTTaJVsfh33fSUIDm4DJW1WCPAS/WQhpXP//ZfMLQl3uBI9SyJWRWYh58rm5XoYBkL30wnvQiA7EHu0DjnjlcK507QabkV3gedNCg+xj8306bV4QrohMBx3c9rjyMD0TLxGUoH6CEJ6OXFutia4T21ZLiiilnFJSAnsFE0Zz5myN5i6kerUiOAPt/dA6sOPvybPpbauqNoSNb8T1f
 5ohu4ES5
 A7dBHB9FphdXWial2Pt8biLD+lndGZSYkJWnJhHMtja+av1cCtR+uTMYqacq9aMBCKvwDwPLgfxisJENcph7+Ix/rp03VW9QneFD2UMnKfrtJZ9/3iRcm+8clG97XEhUqqBi/d2KYaqp1LQFRxyihHF5X6mjpyf/yX3KCZAroG10o1DSLmK9tut3DcX4EzgBDtWWzZGFhHHoI4+AhwjqwqTCViWLSSugnuEBdn4VEiRK2wiq49G1hq1PfBSYggilgfUe8bgBvlcL5pORIa6OXQqV16QFqbOXS8kzUMUHhnWliECouKlNaGwMDQ+1BbeAr0DzS4mAlpcZc+tjZeKPl3g0Uh9sknrywk+UXfZBvIFCV23tB7cZPBZeBWDyE89qb5XOUkiQ17y2rog4YUMn8bnT3jA61HG8n9lo4WMx0hx6Xpgzt8eRT9wdKlptBedbokioV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/4 18:28, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The newly added 'flags' variable is unused and causes a warning if
> CONFIG_SHMEM is disabled, since the shmem_acct_size() macro it is passed
> into does nothing:
> 
> mm/shmem.c: In function '__shmem_file_setup':
> mm/shmem.c:5816:23: error: unused variable 'flags' [-Werror=unused-variable]
>   5816 |         unsigned long flags = (vm_flags & VM_NORESERVE) ? SHMEM_F_NORESERVE : 0;
>        |                       ^~~~~
> 
> Replace the two macros with equivalent inline functions tto get the
> argument checking.
> 
> Fixes: 6ff1610ced56 ("mm: shmem: use SHMEM_F_* flags instead of VM_* flags")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> v2: make shmem_unacct_size() inline as well.
> ---

LGTM. Thanks.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

