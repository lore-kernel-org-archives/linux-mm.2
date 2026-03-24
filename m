Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75DC0F532D4
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 07:06:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AEAE6B009B; Tue, 24 Mar 2026 03:06:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 938696B009E; Tue, 24 Mar 2026 03:06:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 800246B009F; Tue, 24 Mar 2026 03:06:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6BDE56B009B
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 03:06:54 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 383B2E039C
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 07:06:54 +0000 (UTC)
X-FDA: 84580074348.07.46E1D8D
Received: from sender-of-o57.zoho.eu (sender-of-o57.zoho.eu [136.143.169.57])
	by imf02.hostedemail.com (Postfix) with ESMTP id 440AE80012
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 07:06:51 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=EZ+Z4NWc;
	arc=pass ("zohomail.eu:s=zohoarc:i=1");
	spf=pass (imf02.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.57 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774336012; a=rsa-sha256;
	cv=pass;
	b=PLuWZwsuaq5jsug8Q9zHaXywguW6r9ZP04CoiaZEcpNvTaS1PjcWzMsdeMsQSmV33XOwN6
	/ltPSdFhYGpci/OqpevybVhkunDC74k8bE97XjNk9JoOuWBcU5zyZXHCEgsKA9Ind+G2cd
	V7y4zfXFR1vPP9B18X91GK/wO3fvBEg=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774336012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lP8i3Qty/bHUVvaH5kVoGQLcodg/p/1/bywjT4dTNhc=;
	b=K9MEoNXWCz0tom1hwyP1F4AkTbAEC82Ei/ukcf5+Ka9WITUKRQ4RNtf4QTs1XBUIkHnkY5
	RXa0ptHG6rggmT4AEe+OYSRWiWJVxtNEZjoUPQq+SFupfSLprn/yYYijLhTpEq6UWEBvLx
	tfcw+y29tQSRaa4wnocUESEATHRtx+8=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=EZ+Z4NWc;
	arc=pass ("zohomail.eu:s=zohoarc:i=1");
	spf=pass (imf02.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.57 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org
ARC-Seal: i=1; a=rsa-sha256; t=1774335991; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=jP/cJdvUKvWgGl/m66OGGlqy6OEfSYEOQ6MikmzEG60N74+qBkVQL5WCMDbkNUEUeeT6OUnREnz6NIwTWXjToWnV2Be5ig04wmGNyqc23yA1WoXDHlshJ0kJEu7T8nihVRyqnUiAePqS+P2d665GHXPwuUVTAn0prfPqGyITsIM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1774335991; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=lP8i3Qty/bHUVvaH5kVoGQLcodg/p/1/bywjT4dTNhc=; 
	b=QHhZ0F6QgC332Y3owawq5SWJ71rg+kUZ+D4KA3EgvZsRAG0CYkwU3gDmlHKgw55xvAkIp1I0Z/2wyKzdJNY/h7Xmi9wG3Yf+7HOoVuvZeJ+q0fL6as18KiTTrLqCXGBoz51Nz55KxeWX+18aY7o/Ez7CQIZPZr54DS4XtERqMwg=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=objecting.org;
	spf=pass  smtp.mailfrom=objecting@objecting.org;
	dmarc=pass header.from=<objecting@objecting.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1774335991;
	s=zmail; d=objecting.org; i=objecting@objecting.org;
	h=Date:Date:From:From:To:To:CC:Subject:Subject:In-Reply-To:References:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To:Cc;
	bh=lP8i3Qty/bHUVvaH5kVoGQLcodg/p/1/bywjT4dTNhc=;
	b=EZ+Z4NWcp/pKJ7ARgcaqRUM6MeQieW6LmvEcOefoceBW8HKO9RcHPVoC69tlaxMt
	uJxNNJMBRrt29IZuW5itXs3g9+CZGXyGiLfnwk4jz9qt6Wl9Ra5zV3bVczlKxbsGWnJ
	j82sSwkTnUinqup1sT+0dMwIuicEA0jr+M6lxqes=
Received: by mx.zoho.eu with SMTPS id 1774335988821909.6110963179683;
	Tue, 24 Mar 2026 08:06:28 +0100 (CET)
Date: Tue, 24 Mar 2026 07:06:25 +0000
From: Josh Law <objecting@objecting.org>
To: SeongJae Park <sj@kernel.org>
CC: Markus Elfring <Markus.Elfring@web.de>, damon@lists.linux.dev,
 linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: =?US-ASCII?Q?Re=3A_=5Bv3_1/3=5D_mm/damon/sysfs=3A_fix_param=5Fctx?=
 =?US-ASCII?Q?_leak_on_damon=5Fsysfs=5Fnew=5Ftest=5Fctx=28=29_failure?=
User-Agent: Thunderbird for Android
In-Reply-To: <20260324001500.86247-1-sj@kernel.org>
References:  <20260324001500.86247-1-sj@kernel.org>
Message-ID: <A0701CEF-CDF1-4B3E-B25A-C05A32AE822C@objecting.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-ZohoMailClient: External
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 440AE80012
X-Stat-Signature: ak7yiq81ci4qay9h8u3tne3qtmfay5gu
X-HE-Tag: 1774336011-35179
X-HE-Meta: U2FsdGVkX1/NXf6+iftIqlssllOxPvzoV8PYXK85sI97/I4cWsTMp/WUtKdqFKMvjQzo5N4OPR+4sPgMW/FOwrrOaO/XmvvznkgCx3rg2EOOCDg5EvDqiMQuWcs7qGjKmNFhkIiqWVJpSVFaLUKcgwPErRM/PP06B8c0SNedLxPYTIkmCkff4F1LV8JR0CR9NqOQ8Wd/ECYzhlv1c/hPnwgSdZnBf3R7KF2JlC/vRTv750nFM5Ln3+LuBgxeqE5uZ3EKm7laTtepxi9UxX4SHHGDLxsI4FAyePqac1dY36LSrWJNygVC2O0ryLSj42ceGXWE1Dnm8pPfw5/kq7a3Yi9slZwKDsh0xNs4q5dLISDYg8Y3T2mxgthppvvwSjCAgtWEZqExVxoH+OuAbXUIQOxpzcPNVTIturVlsfHekueKVnmIKyanAisq7u4ln6d+u+ERE/TnkG8JOWYRPVM5aQpPfGGTT8mz6qmYhEH0lYziozw+aw88rvEsuWzcJkFOb2tZwdgx5TbEKhIMXH83jY1XAjFXR6S5TuYbHCMD3u0m4zELIDxRqyBGeIN8oLX0cXUxIDWdrRoPHkQD4srCGYETreAHtc28o73SJPM/CTr7sCtTl3Da+VfmuPS5IRCIHqrZ20yM9OAu63QjFPY+Ebnev5b1QhnV3zo0/hqW6pETLKEnK46ytVEW3VitqyaSvRvIySHvCEN1j8BdSCQmueDcbtA1mbCG3AIY/s4MAwGQAEizWrEtxM9YPgGLIPvKdOCbCEnCD4daY/RGyd49THedLdFEt5hYLpemODGWgJCrbwtg4rZmIPO/qmjenXWnLnty0ww3UxOxCowdgrb19u26bcNAlOHNFOJsIenfoAz/vjBGNbY3EHGr/bTiRQsgBZEx6A5XfHy8cVc0u78ASZkwdI5ejofIp3CLVdoSLHmftnkxFw/KDXl7yzDMazxZHgaPBw7qG1MwukQG5oS
 lG7Iud5B
 acZ1QJCUKtTzHi9gCxPej7NsGP1X2WvH9P1jKaHC/oQTZjUVAEW4nx4KJcwhq/CwiAjYR4MnlBOliUAJC8KzAGw8MSU2mIohPkOkURS9LZkAMEHOplvHdjPhunJap4vi8/1Rj1V7IDbYTDo/kzdifABbxRw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 24 March 2026 00:14:59 GMT, SeongJae Park <sj@kernel=2Eorg> wrote:
>On Mon, 23 Mar 2026 16:48:19 +0000 Josh Law <objecting@objecting=2Eorg> w=
rote:
>[=2E=2E=2E]
>> Also, unconnected to our topic!
>>=20
>>=20
>> I've tried to backport Damon to 4=2E19 (for a personal android thing, a=
nd failed! Of course)
>>=20
>> Can I have a bit of help if that's fine with you? The tree is based on =
GitHub a bit
>
>Sure, I will be happy to help as much as I can without burning myself ;)
>
>Seems [1] Alma Linux has backported DAMON on their 4=2E18 kernel=2E  Mayb=
e you can
>try their port first?
>
>Also, what is the oldest kernel that you have to use?  As newer it is, th=
e
>backporting will be easier=2E  When I was in AWS, I backported DAMON of v=
6=2E7 on
>the v5=2E10 based Amazon Linux kernel, and the source is available on Git=
Hub=2E  So
>if you can use 5=2E10 based kernel, using that could also be a good optio=
n=2E
>
>[1] https://oracle=2Egithub=2Eio/kconfigs/?config=3DUTS_RELEASE&config=3D=
DAMON
>
>
>Thanks,
>SJ
>
>[=2E=2E=2E]



well android likes using old kernels for some reasons, especially LTS, so =
4=2E19=2E=2E

V/R


Josh Law

