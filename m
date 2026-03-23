Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 746EBF483C8
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 16:48:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CD7A6B0005; Mon, 23 Mar 2026 12:48:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 957306B0088; Mon, 23 Mar 2026 12:48:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81EF06B008A; Mon, 23 Mar 2026 12:48:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6BCA06B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 12:48:35 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 207051B9317
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 16:48:35 +0000 (UTC)
X-FDA: 84577911390.24.124503A
Received: from sender-of-o57.zoho.eu (sender-of-o57.zoho.eu [136.143.169.57])
	by imf12.hostedemail.com (Postfix) with ESMTP id E9F504000F
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 16:48:32 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=dLHhCDWd;
	arc=pass ("zohomail.eu:s=zohoarc:i=1");
	spf=pass (imf12.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.57 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774284513;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xuIcoUTBkBsZgUn7ZrvmHbUUe+AYpBylLNG6S3yEuAA=;
	b=aYjrx96rkhruhIAqL5tBCrD1X8XTTVBygCAXKZyFl0W+InXuws95jYyztuq/WFYmVaGqTO
	87bW36nosTnIDPcZZ16+V9M6r/WBe3d05OeAQCeJceW+v/Q/PdqLy5cCEtJe/2DjAhpOv3
	1VFDEvqz+UaZoO9KbBddFbkgnHlCWM0=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774284513; a=rsa-sha256;
	cv=pass;
	b=1yZIZQGEBM4vrWUw8aztH0/JAz4qmaacY68XpS2pvjQjolQpd9gpGu0c0lAF4ua4945dAF
	ZGoT+3s2sQLMUAnDuRDoT2BjhcT4MXREXtnyfdQqglU4cA3BZ0gf+U0t82yPUbmRf8cNYe
	pAnJuvsWley7X+k8eTBl5inMsP0j3As=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=dLHhCDWd;
	arc=pass ("zohomail.eu:s=zohoarc:i=1");
	spf=pass (imf12.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.57 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org
ARC-Seal: i=1; a=rsa-sha256; t=1774284501; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=TUr8chheOvYFMZxGGYScjnN+EsYrP5DvaQA6zT9fmDaScNNQVdiZRK/vBfaUvs9cqNYJbwsQHDAIa51x42XHo0r6/dieyC6FGfhTEl8qJFN5sG5b7GhxdAtNpSLSlfWakHQm6fLDbr54EMmkhhv6wQkiIgzVRVqTWGiVM/eDZz4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1774284501; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=xuIcoUTBkBsZgUn7ZrvmHbUUe+AYpBylLNG6S3yEuAA=; 
	b=H5yDN/olrH2qhebEP05H5BiLoV1FT9l12HySF3PVURXVOYs+TMGUR52/XaBRYndsycr1X2VGGnvg4vWaUSKU3224yGLq8kKgxwm0pbGjszrs/kdiCCXmWJaBGSlER16Sru/n3JzEPyYl9ucv2KNlwt9lPY6epeSop/+5e5eKKm8=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=objecting.org;
	spf=pass  smtp.mailfrom=objecting@objecting.org;
	dmarc=pass header.from=<objecting@objecting.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1774284501;
	s=zmail; d=objecting.org; i=objecting@objecting.org;
	h=Date:Date:From:From:To:To:CC:Subject:Subject:In-Reply-To:References:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To:Cc;
	bh=xuIcoUTBkBsZgUn7ZrvmHbUUe+AYpBylLNG6S3yEuAA=;
	b=dLHhCDWdAnlY4xWHugxDQ+jhBSGVh0FCYNrqVzeP44ASiliqjtgH37/+LzTgyEs5
	Mob/sv7ZB2dCH4YT5ENVMUJ6EUy0MD6vvaHkTV5uQtePuabNnl8ceu1IKdWGL6khBgE
	6m+k7G6RBtRKWLXoMoQeDKNZdTOlPcur0QkN+WoM=
Received: by mx.zoho.eu with SMTPS id 1774284499534665.7592129103313;
	Mon, 23 Mar 2026 17:48:19 +0100 (CET)
Date: Mon, 23 Mar 2026 16:48:19 +0000
From: Josh Law <objecting@objecting.org>
To: SeongJae Park <sj@kernel.org>, Markus Elfring <Markus.Elfring@web.de>
CC: damon@lists.linux.dev, linux-mm@kvack.org,
 Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Subject: =?US-ASCII?Q?Re=3A_=5Bv3_1/3=5D_mm/damon/sysfs=3A_fix_param=5Fctx?=
 =?US-ASCII?Q?_leak_on_damon=5Fsysfs=5Fnew=5Ftest=5Fctx=28=29_failure?=
User-Agent: Thunderbird for Android
In-Reply-To: <20260323152453.81603-1-sj@kernel.org>
References:  <20260323152453.81603-1-sj@kernel.org>
Message-ID: <0E185D9C-311B-47C5-AF28-06F8D1235926@objecting.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-ZohoMailClient: External
X-Rspamd-Server: rspam12
X-Stat-Signature: zofgqpxqpw3w7tcsg6899u8biro9sggq
X-Rspamd-Queue-Id: E9F504000F
X-Rspam-User: 
X-HE-Tag: 1774284512-988460
X-HE-Meta: U2FsdGVkX1/ckfBG2UCfXVp4VqQAQX5A/CiXUaoLh250LckOEUDq4d0N6Zy+j3YpozDIpdUcSiBOGsJtVHWc1yNV2M2hw1S0sX+ug3BL1b4NjnwYy5g2sTmNnaVdd3lTdQkjEgq6r2+/+v8hZ37ckPxYhazMCub6dQnZ395mlBECv+QCdyF9oTVQa9BwZ7Zm4KGyMiVimIkKqwuhTtIpUaaqXcPw3rM2Uictk82NyJDhw5m+aLv75pPpG2oLyrzEi7SRcH+0pMmSR2R5pWwEopBqoG3FL+K1c/CgC3EB5mVPMu3f60xX+KD/YHjt1QZX+BoWKwRXOnhDsAJuy1UPdPcPp0QBYx9LszVxZZHTs5aaoxJoPNXOiCLD9nbgva+RcGaD0GKEKAeB5EVUo7vY4TZD+Jq/TntUUs0CscK/vkfFd8j+5fGBalzJbbmL8CHETZQmcvZ7+hEMVQ7gNHmv89o4o9pWaIkv2lvpr2mkkNaq3qr/yPl/u5hDJfgoa9rcvZhzZtTMmDAPX1yay5SzpSCr8/LvFl2fvStRjJ9mBeQnyBcaYMIDXDa6CNqH8zSt8UIocmINc+sAXRVytQYYAB0xV/So3kStecCl2KIIFrDD+J0EdIlfWcibqVuN2ppq9bGymV7KW4xR38irbTnN7EfZEBXd6trvqkbQFrTNDHlFGd8courMtUPX72jQSy/DhITnVFJfexqGlQ8tPSYr5lbCHl+l4U1fFjcqvbyc6I7em4kDHbV7vrzHI1rIhfti24xXC4U/RYmfTrKbntw4JFbpz2DnKehGnIxSAkGYWC99SeRiVyxvf8HuaHnY/YBu4q+kjgWkxeNKmrblhFKXCM/7wO4lyf5O9joNYlN2lDnmhhUzSaF75EoKhmpcVnehnaTNuWo4uXOhycVyXpb1XHvFoXy4kO1un4N2SZcZ4pKls0bRvlXzrLXqk28OBqNiqquB8y/cqVpvBRu5qQy
 SJALCnqa
 ypghkJsPguXNwas2pa2wrONLBpARMEQc9XM+hvnkxcAR6INGsQgxlS0tVnFMPUBUCVuHsCmLcMDfSuG2ckP02LQ1iJG0GgY8pHse4UOs2lzSH4C0vdpuqPpNaAiL74H264XGxrnVQHlGyNHw4QXCbc+G7Uy6OL7D5BvFe+s7aX2xP0i0wKBmaiJ/s60FUg9vGZDPgPiAw+t6gXaBpsLXjTj9kiAiQjHjZPOmdprFsXZLjILPfT14QhThefTlbTze6YNRQRbngE7/GiLGr0yvhclSRM5n5Su81Qov2l96ScipiO/tuXn4zJ9Ic38o1YOAcKNJ/9eSHUIeYmtBro0oFdAYGow9p4+wab2O+G5EnlIlH8ZH6I7t6VOAEHsWbt1/MlaZzdmXtplaA15FtZpeedukU9EjD00E4AVIFL7vh/CTM06wyI0XNKKlPX+DrkAd6DLUW59UuLoF6myQOg41D6Jr9nHiIqY2MybDBPd6TBP5KYJIeGada8++6bXAEipGFGPI5HtN8HiC0u92EATzZvZrm5g/+LEbv9JQt+8PAXqzpdydegKiL6qOqZC0n2J6xlkya
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 23 March 2026 15:24:52 GMT, SeongJae Park <sj@kernel=2Eorg> wrote:
>On Mon, 23 Mar 2026 09:25:52 +0100 Markus Elfring <Markus=2EElfring@web=
=2Ede> wrote:
>
>> > Markus these patches are already merged
>
>It's still in mm-hotfixes-unstable=2E  We can still make changes if neede=
d=2E
>
>I understand what Markus is suggesting is adding another goto label to ma=
ke
>the flow cleaner=2E  Because this is a hotfix that aims to be also applie=
d to
>stable kernels, I think the change is better to be as simple as possible=
=2E
>Adding another goto label could make it better, but I'm concerned if it w=
ill
>make porting difficult=2E
>
>IMHO, it is better to do that as a followup cleanup, rather than make cha=
nge
>into the hotfix=2E  Let me know if this change is somewhat critical and I=
'm
>missing that=2E
>
>>=20
>> Are there still development interests for the application of a better g=
oto chain?
>
>Sure, if it makes it better, why not? :)
>
>
>Thanks,
>SJ
>
>[=2E=2E=2E]



Also, unconnected to our topic!


I've tried to backport Damon to 4=2E19 (for a personal android thing, and =
failed! Of course)

Can I have a bit of help if that's fine with you? The tree is based on Git=
Hub a bit


V/R


Josh Law

