Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 272FBCCD195
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 04:07:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C4BF8E000A; Wed, 22 Oct 2025 00:07:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39C558E0002; Wed, 22 Oct 2025 00:07:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 300208E000A; Wed, 22 Oct 2025 00:07:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 220348E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 00:07:02 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 67EE75A91A
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 04:07:01 +0000 (UTC)
X-FDA: 84024414642.14.B3757C8
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id A78D3140002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 04:06:59 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf26.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761106019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eDo12jpZfo1MaXqNALR/lKe5SxuZgvzVORvf1Ka/xt4=;
	b=549ABd7Lh19816yY+0AjBqlRncJALqO9jQJq/TJZl10ebO4sIp3DrvTermIRuJN0Auni+0
	uYNkF7Tr+dL/Nn9D9KaXmI6SiFaS+ooF+XcpIVLkQAQ7cBmjMmd5X1NuiUJmhKM9BQUNLG
	M6Q/Sq3g6ewTMKehiR1bLQhZsdObst0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761106019; a=rsa-sha256;
	cv=none;
	b=IAEBAz9sd5bLtDKdntBRWmEr1kcr+YAL96/gVlUeHKbBGzG1BZcuEwYej/kxRJn/Ij+mhr
	XyrxCmgKPxAeeMxRoSislD1U/hbLhBbaCf3qwAvcbFnTihOrPeY3y6yxG+8G0JLnISRyTD
	P6CqeMgRcVI7oyn4cs4lwulDqdSbr4I=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf26.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 02FBB1063;
	Tue, 21 Oct 2025 21:06:51 -0700 (PDT)
Received: from [10.163.68.114] (unknown [10.163.68.114])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8581D3F66E;
	Tue, 21 Oct 2025 21:06:54 -0700 (PDT)
Message-ID: <5ba26eec-9b76-4561-bd8c-8798af7b2c15@arm.com>
Date: Wed, 22 Oct 2025 09:36:51 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new v2] mm/khugepaged: Factor out common logic in
 [scan,alloc]_sleep_millisecs_store()
To: Leon Hwang <leon.hwang@linux.dev>, akpm@linux-foundation.org,
 david@redhat.com, lorenzo.stoakes@oracle.com
Cc: ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 npache@redhat.com, ryan.roberts@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20251021134431.26488-1-leon.hwang@linux.dev>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20251021134431.26488-1-leon.hwang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: A78D3140002
X-Rspamd-Server: rspam02
X-Stat-Signature: tmj4948m1w1hx76d8ypbwoohkbsgmhb6
X-HE-Tag: 1761106019-845489
X-HE-Meta: U2FsdGVkX1/MoMk5k46LmsA7bbG4bH6GBuZzhR77Sc74H7CZQVldLB2dJ4C9u4Vk0hWns0KOkZeYS3+mXS/p496OxqGo4+bhJZcB614m4RQeYpWjdPg4aKfGxFaer8je++mEEe0NFfjXl+IuhCns9+rpE9i00l+NOMS6yW0GDR2vWcyGaxALFL80QnHodeHRZKcUJRG7MpB2L6fMRffbeT05xBih55QqyTZ4yAKyLofflttP31WDDI41+4pJfx0++y4qxPn/sJzsBWxemSwn5Nv5+RHQqf/2Nrdn8CcYcW/0XOAzTf3F6NbGJHwnlBzgEkQpr98Fw49iuSvJJR6vhSR9ny9aHuzq7ef06orrDqdJ0QSl2fVKhec6IoKphc+IBm48GEu3S32oLWtuctB0kD7SWQvNfi4CGOCsZ8hSxXdErhdBjbGVXfoEg194vk67cGBU3pmFLjL9bk1W8o5yEI78VTAM//jpkW6NJxznGayzeV0AxM8YL/e58QKlJbkMGCYNxLP14iPqlmUAEtmd8ayxYpGXzftxapsxJyDe7UEC9BZIEydtKIqNxAbef5gkyQlZOErv3rbP3RRiHeJSmLJE0OdZ08mgfAS1YJ04YgCf7XG4BaTv3+q2q8GxuGCiRddrNHRX7WyuzNV3Hkhr0xBWFyzlsFlahVt+hKeXfkQN9lue9hjRizqW1244v8o3iMTfpk+ZBNVXYz1jQpV2AgQZOUsDJKlSBZTddmEXPeMsT/6s2AF1qklJamb2VU6QjJghMF+Ieplq4ZwGxd7O2+SDZU41SMLCg7IG81BCQFRdh0B9ICB67AvAxuaun/uOem7WX/Jqkhref3sRk8l27QW9pd9F6tOxpAcxtwXEX9MrOQCuDbY4dfcsKEBiXcBELpMmjzfF0AdOtUzZ1psRLQgu58E13wybqenAq2tyRO9FA1SH6qyEuOgLf1/cX5lnHmwSupRroySple0SpdL
 SHjAMeiq
 OnW9pRtrYi2I2PSlC7+/K8005S1eRMMcmUp9ij65NyX4LvawCA5ak2rZ047rDA585lbBz/RqBn98oSFeePn/+2LCUmTVel+ShsYC3i3Pw34C3W3VKcI76I07LFOpMLj8+KsgcynoAu6Cb7Szs4Sp6lcGyV0hR95HLMK3txR8xZZ9ZyxMqIfH+Byduitln5paAGcnBQvD66P6zbRv9ZtcPQJwltkJfYX1oj2iXJKZ1P5Ke3cythl4SvO4RUTMy/Ry5pbr9w3islVhmx4G0j0dTUTsLuEqD85hU0uoLUIf80xRVf0w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 21/10/25 7:14 pm, Leon Hwang wrote:
> Both scan_sleep_millisecs_store() and alloc_sleep_millisecs_store()
> perform the same operations: parse the input value, update their
> respective sleep interval, reset khugepaged_sleep_expire, and wake up
> the khugepaged thread.
>
> Factor out this duplicated logic into a helper function
> __sleep_millisecs_store(), and simplify both store functions.
>
> No functional change intended.
>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Signed-off-by: Leon Hwang <leon.hwang@linux.dev>
> ---
>

Reviewed-by: Dev Jain <dev.jain@arm.com>


