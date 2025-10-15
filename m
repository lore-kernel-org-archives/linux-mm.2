Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06CEACCD18E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 13:09:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 479828E0030; Wed, 15 Oct 2025 09:09:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 451988E0020; Wed, 15 Oct 2025 09:09:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 367398E0030; Wed, 15 Oct 2025 09:09:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 231408E0020
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 09:09:38 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C729614016D
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 13:09:37 +0000 (UTC)
X-FDA: 84000380394.12.F580CDC
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf23.hostedemail.com (Postfix) with ESMTP id D30EE14000E
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 13:09:35 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=KypksD7o;
	spf=pass (imf23.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760533776;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q6ORQ/xKAeoGwGCxYDzeUbCbogq7qa00EfyJDwKghp8=;
	b=LWpM7q9QRU4y9DWp0y5LYfdYNBf18x26es+v0JADDuUfmqakVS01AoYc9fsNLUoXpl9ihr
	k7dy8r7yVG1kK+zgit7jfRUrwSl7501KRm8Pe/pQVHdQaMxeE65O+F0+She4mRYeA+Z7L2
	bw6FaBBQfOlC76riFqE0IdUD+hIhZ90=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=KypksD7o;
	spf=pass (imf23.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760533776; a=rsa-sha256;
	cv=none;
	b=HgaBFhW2oHppEAQdtrhKQdCTJGj/I8TRYE3BEGwikIsZDVJvMA2Dkm3GPZGxMP8sGW93f3
	FvgUVR/IKEV4nvWuGbPdJO92LxhlQ2yRyQ1gcZDOXzUipV5YDtQHAZq2dofT8TCKwKf2y4
	uVzZ8mKOE3w5jhQNxstD/n0BVNqibog=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1760533772;
	bh=QaXo/9LbVR+tBaOZHohIKGkjMYP/u3JenqZBxSXMx9g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=KypksD7oZEmujpy6XjotRWQaxryLNjUL1a+0MJUsCZx4+fVJ1efrWNYdoLTnovd33
	 6YohNFTxHYLwUW8ZV0CgwVoT1SSoUNR17WewzGeOx+sEHOesL+fiWvjAzJiUZcoox6
	 8bQceecvY8EPTgrKyLTMBg/jvyz2DqQEEbBkm8zm5auqG/IjGg/GAlDtM2h7fjCCW5
	 zbbK6tEgM2NtoNxob1GoUUvbSgtZG3l6BoTzVmxVnObsjUGtIa/cXzNS01cjxIotTh
	 2N6ilIP2gLhJexoJyMUrGPcR2ZfUYD8PCs66Npr1wBnRsTJFU6G9TjdyXw6FJ0QqEV
	 X+gTn022pgaOw==
Received: from [IPV6:2a01:e0a:5e3:6100:7aed:fe0e:8590:cbaa] (unknown [IPv6:2a01:e0a:5e3:6100:7aed:fe0e:8590:cbaa])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id D472F17E0125;
	Wed, 15 Oct 2025 15:09:31 +0200 (CEST)
Message-ID: <6f1fb1a5-5d6f-4ebf-bf12-3481d360fb7f@collabora.com>
Date: Wed, 15 Oct 2025 15:09:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 07/10] drm/panthor: Introduce huge tmpfs mount point
 option
To: Boris Brezillon <boris.brezillon@collabora.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Tvrtko Ursulin
 <tursulin@ursulin.net>, Rob Herring <robh@kernel.org>,
 Steven Price <steven.price@arm.com>, Liviu Dudau <liviu.dudau@arm.com>,
 Melissa Wen <mwen@igalia.com>, =?UTF-8?Q?Ma=C3=ADra_Canal?=
 <mcanal@igalia.com>, Hugh Dickins <hughd@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Andrew Morton <akpm@linux-foundation.org>, Al Viro
 <viro@zeniv.linux.org.uk>, =?UTF-8?Q?Miko=C5=82aj_Wasiak?=
 <mikolaj.wasiak@intel.com>, Christian Brauner <brauner@kernel.org>,
 Nitin Gote <nitin.r.gote@intel.com>, Andi Shyti
 <andi.shyti@linux.intel.com>, Christopher Healy <healych@amazon.com>,
 linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
 intel-gfx@lists.freedesktop.org, linux-mm@kvack.org, kernel@collabora.com
References: <20251004093054.21388-1-loic.molinari@collabora.com>
 <20251004093054.21388-8-loic.molinari@collabora.com>
 <20251006092856.02fbfd9e@fedora>
Content-Language: fr
From: =?UTF-8?Q?Lo=C3=AFc_Molinari?= <loic.molinari@collabora.com>
Organization: Collabora Ltd
In-Reply-To: <20251006092856.02fbfd9e@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6zcshgwkip3udqfsjm8mthwwk935uc1a
X-Rspamd-Queue-Id: D30EE14000E
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760533775-160816
X-HE-Meta: U2FsdGVkX19p0GfVbdE3w7SOCf92k26d2Sr5tmzaTJHcc4m69vE3KaJ7rGIraV+aqix/HKmJc7n+OvJ/INWhCeULcXu0RK1XbNaZs5MFMy6lhKTUEPYnj6SKIBxn5Uk1cANwUIpM/eJcMkKMDB0flUQ3ugpSTJb93maUyKuO7afglLzRadYS/JQRjhkAc7nZHy647Xcdh55oM0Y2eTknx/F1t9SV+ghEPwb+GITBXx5VbEI0+VN8d9Ml3p/tCE2DVURcZvcbXnnRG7J/VMXTEuZUFmwLpNwO6yNrfH37fjeW3N+06TYAGq4v2EOY2p8cD+y8eclK+EdMOE76J/HO7IsKXwAnA85bH21/FoQehKIiK6WZiyUmFC2s7RP0x1KcQQWXL3qJKn/rnow6KBqZBgufTRqQizwSPX48/ojtzFYsWxHEaVLgwxGLIku26pZ/3DE0nONnjOyXbe2fXKKRsoh4aRe0vRNMWz1jOGiiaBmZSntL5zvZBw32ok5+BgoNaZNi3pvx0I+seXSxIs6JjHuX65LjbA/bZjl7dF51dJD+qWsITE7tmq4KAiHx/gIsUvMjiRNShiRQNWUGvmdyriCvf9OFtOJAnom4666Uq2cfF7mUnknXp6M1SQouxDLNCVatEg9PRaEgwruRw+7g75aIYUUmlNtFYJzjmJl+7hj3DmcvGoCY3Y0giM/Qqo8WoEnjHhKlPiep+HlGVVRkNHXCLO54V4qfXIG0g6kSnKosL5dRddaZBcoJMM6MhJNqidAAdgAuqLFIbMHmyXCQEZhs6YMYwi7L1EMYjGsdCCPoQQsUnf9XncfBnd4DQ5qM+pQpq+MEJR9NUdlMn0TaG5+MNwOs/Lrfaerb6srIAWZ4rrHk/Nc1U/ir+jCBIrKFBSJsU1zK0ynMyTYVcWo6vOkD7Q63g+L+cOswiU53j3pGKIcc2SYs+EmIABff3SCMOXBIocalN8n4xNEciFV
 dr34Bb9P
 sZtbOQPrzw0TzQdNf3PfAEt+A7us7B/SZl4JACGWomx3ysqJkchrUruPXGN+Qx0GDXVkNbiBd5LAWBL+aAIX47lIre/tPFRxK25aPw8w24yg9/2ijFjCL4Mq6bGPBOmCOin56vf6+CEdxXewN+C6tzY1KwID21FEPpm3ZEDUbzvNDL+aLSsayQfiHjosM6tGkOaq1QAwDDOTwgja3/aERKcHb407ih7xMSeSd3AI1ORbNe9oNIV+/HzRP11+WE9+O7jkjqWdhJu4t5I1+mv48sF+kmDxMg6yqnmt87bGRQRlXCIduA1eyHLjmfi79bWdGa+Is2Hjm2U2bLy0kjtE5MVbPV5l9PhJ8Stj/IAbmqwnSUNVM6h06wyFNtkH/5RvjKkxaLPJWDQ7A1M9HnaFkwooC9Fn4JECMxx1U7xBkRfpVTdhjSDy91A0hMbxbsOgUjgQlYJQ+VZ2UvKk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06/10/2025 09:28, Boris Brezillon wrote:
> On Sat,  4 Oct 2025 11:30:50 +0200
> Loïc Molinari <loic.molinari@collabora.com> wrote:
> 
>> diff --git a/drivers/gpu/drm/panthor/panthor_drv.c b/drivers/gpu/drm/panthor/panthor_drv.c
>> index fdbe89ef7f43..a2be3b904ca2 100644
>> --- a/drivers/gpu/drm/panthor/panthor_drv.c
>> +++ b/drivers/gpu/drm/panthor/panthor_drv.c
>> @@ -1623,6 +1624,12 @@ static const struct drm_driver panthor_drm_driver = {
>>   #endif
>>   };
>>   
>> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
>> +bool panthor_transparent_hugepage;
>> +module_param_named(transparent_hugepage, panthor_transparent_hugepage, bool, 0400);
>> +MODULE_PARM_DESC(transparent_hugepage, "Use a dedicated tmpfs mount point with Transparent Hugepage enabled (false = default)");
> 
> nit: I'd go for a slightly shorter name, like [panthor_]enable_thp.

For v4, in order to be consistent with the "transparent_hugepage*" 
kernel parameters, I'd prefer to keep the "panthor.transparent_hugepage" 
(and "panfrost.transparent_hugepage") module parameter name

I could keep the parameter name as is and change the variable name though.

> The patch is
> 
> Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
> 
> regardless.
> 

