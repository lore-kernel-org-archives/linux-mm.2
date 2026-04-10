Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3316F36BB8
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 06:45:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 595926B0089; Fri, 10 Apr 2026 02:45:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 546256B008A; Fri, 10 Apr 2026 02:45:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45BCA6B008C; Fri, 10 Apr 2026 02:45:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 34D466B0089
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 02:45:55 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DC8DB1A0405
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 06:45:54 +0000 (UTC)
X-FDA: 84641711028.24.CD247CB
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	by imf13.hostedemail.com (Postfix) with ESMTP id 946B32000A
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 06:45:52 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=dUnmciUs;
	spf=pass (imf13.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775803553; a=rsa-sha256;
	cv=none;
	b=k5t8AwoHZCzy8Iz1eGSMPoMbSjTabwAOO8L9QX/ZlP+L0fjODHXOg4YP56xfAN8GNAx8g0
	N3qTl4w1iEp8MMUL+DINByahvrZWOk+l2VeKiTj7S9sTqa3a6QZSIrFInEXoQjzWEwOjkp
	ajYZQrC7z7h9nIt7HiuQVfDgqp9s+jY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775803553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TibnG7J4jN/GdZSu1jz/2Qy9zPFx0kVAbZEcvXJoqig=;
	b=jYO2Bmbs+6en5ir51fagLiW88fks1TfjOr1RuGcOKJoB/9bBjQIEu4NNo95Vc708+rhac3
	UvCI1N0gnhnpTg5y3ExQhmsGE4q8TObWkgXnFMx7hDP3pg6zTfcAKLo3YK8dKkLv6QQ25Z
	b8s0a2X3lEs110VT3u8LPkUqcvhFq7s=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=dUnmciUs;
	spf=pass (imf13.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=TibnG7J4jN/GdZSu1jz/2Qy9zPFx0kVAbZEcvXJoqig=;
	b=dUnmciUsePF8A8UAG6qek1JhgotoL3URhIqHiZ3WkCaYQGWGw6hx+6GvmgiuMdyJqG67Ps1Zc
	RZbiGC+bOG58+GIB8CzahJ81pIAFccoUOybCXD+agtjmqDWfPOkzs8V2mIkVzLwKO/rtXMnoNWL
	6/TCMepdJKt8vzBYTfODHHo=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4fsRwv6m3Dzcb16;
	Fri, 10 Apr 2026 14:39:27 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id B7DC14056A;
	Fri, 10 Apr 2026 14:45:48 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 10 Apr 2026 14:45:48 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 10 Apr 2026 14:45:47 +0800
Subject: Re: [PATCH 2/2] mm/memory-failure: use bool for forcekill state
To: Ye Liu <ye.liu@linux.dev>
CC: Ye Liu <liuye@kylinos.cn>, Naoya Horiguchi <nao.horiguchi@gmail.com>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, Andrew Morton
	<akpm@linux-foundation.org>
References: <20260407020715.2269255-1-ye.liu@linux.dev>
 <20260407020715.2269255-3-ye.liu@linux.dev>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <9d022499-2a77-f8c6-b86d-d9de838fac32@huawei.com>
Date: Fri, 10 Apr 2026 14:45:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20260407020715.2269255-3-ye.liu@linux.dev>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 946B32000A
X-Stat-Signature: qx73mzszqhsh1y4tuwiw5nhfensnxjbk
X-HE-Tag: 1775803552-624803
X-HE-Meta: U2FsdGVkX1+rPfSYwJ7qIiXXAcFHlq3q6G+5c/KePJWFDJqddRassw0GHNrWJjkcyQJzAybk3nXai4WBoeRn/GpA2llJyDwNQDaCdHPmairONgz3Y9B9Nl9cpUWbzfIi9j81SM+bCMNcrvcpX/chhrZEAqB4iRfy6sCCnJEU3WunHr6yu5im75K+wigKsql56Pa1pRdEJ14XikRu+MChmhBGl0I0twydBeUgUNbwMWUmFqxGyUkJodOPlaTIyuak435TfJGjjr61HJ8BonI65fLwpuHXRaIP9dcw4P/XDUA+y7d9qSR5EYkejdrUQHlAUYEXV00x/5DuhOpn6vEKNjggRoKWPXDJ2UWH6GHkL9QP72fttnFOpn9CIiBsGMSap+LDtvbbG5RkhVKKP21Gd4q15T2uiEip/Fk5QoLCt+v8+iN6ein8NCKNrufs1aT1/Up+P5dxaHRjJcDx9HWK/Lavlc9XSrod9B3RS+5lxLXll0JllwrCz0NLIChJ8HWpExvtefFwmdhNzrGB7aSrCyDZLzxIz05jSvbXBTG6pcdl/gJ5LM1WRMrZ/7sXp+JcU+gQWohCH6Y+9eC2gR3eIkZ7WA181j69Om5vtK4bNGd/62GWci5mtSEOmgtcM7VwgwXonlx8C4enSS+JkcPc1ecdvVR35tG98eco4Y3DLBJyxejxOI970v/Bn5WE4i4c3oqFUXXcZR/qFvsDJzzmclOysQcEEKDFG8s7HiJLGFrqe/ks+CjinJ8jbk65/IqAmBTvmf+jOZ7HCiG3xw8yjqZS185zrNOnzETSFVvJlu7mD2TzZyB0HGNZw4razMNrWTJ7EqJY5umo4UqiJsFYDLVjyeqN7ZiOfL3srkHn9IkWBBvwKdnofGVPD2UIjcs6HY9bYcomi3g9Q6y/oD4A7StZXRvvmC42QETArYUBD+DsqdNpYTEJMyfpMaIKZaVzpQPCqcH7A5v23l13xjs
 jEeduWun
 KCqsUzWJxpm0O7THoc/YmwsnnLbMs5GNrHGsonc9Zs6Qa2oHdONcxEsFtDo5tXwf+6xiBLwYenCbcomW5XyARAVUDcu98U2G32axlkX8DuhGbLWpTHzH94YI8ZCwnl4+t+rIB2fBbfjyIIe36fZX7dBhzTDb/QIoElAScaG9QYbR6F8Fdo8wC0qJlvJocX39PsDeIKBOuvETXAeRHC0hWBlMd9tUqmN4GiLf1P/D97qP9dL2B5kZ151MQhmI8et9Hf9ET+QM1kavuvOGQ6481uRT9iPS+XWI9oAvpwNna8tx6DFtOyR0W/QetvUq5DWA6zTViZZpW2EKu1aQAlg1wTBoyl3VaHmrvWGIu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/4/7 10:07, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
> 
> 'forcekill' is used as a boolean flag to control whether
> processes should be forcibly killed. It is only assigned
> from boolean expressions and never used in arithmetic or
> bitmask operations.
> 
> Convert it from int to bool.
> 
> No functional change intended.
> 
> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> ---
>  mm/memory-failure.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index d25adb390c3e..f355642bc2b6 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -459,7 +459,7 @@ void add_to_kill_ksm(struct task_struct *tsk, const struct page *p,
>   * Only do anything when FORCEKILL is set, otherwise just free the
>   * list (this is used for clean pages which do not need killing)
>   */
> -static void kill_procs(struct list_head *to_kill, int forcekill,
> +static void kill_procs(struct list_head *to_kill, bool forcekill,
>  		unsigned long pfn, int flags)
>  {
>  	struct to_kill *tk, *next;
> @@ -1582,7 +1582,7 @@ static bool hwpoison_user_mappings(struct folio *folio, struct page *p,
>  {
>  	LIST_HEAD(tokill);
>  	bool unmap_success;
> -	int forcekill;
> +	bool forcekill;
>  	bool mlocked = folio_test_mlocked(folio);

There is one caller in unmap_and_kill():
	kill_procs(to_kill, flags & MF_MUST_KILL, pfn, flags);

It seems flags & MF_MUST_KILL does not return bool. So maybe we should change it
to clear semantic conversion?

Thanks.
.

