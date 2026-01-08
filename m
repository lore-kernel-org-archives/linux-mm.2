Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0B04D185FB
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 13:49:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13A616B0088; Thu,  8 Jan 2026 08:49:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E8216B0089; Thu,  8 Jan 2026 08:49:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2C4F6B0092; Thu,  8 Jan 2026 08:49:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E52A96B0088
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 08:49:55 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6D0161A86B5
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 13:49:55 +0000 (UTC)
X-FDA: 84308929950.15.22EB1B5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id B54B48000B
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 13:49:53 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=PlmxKosd;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf30.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767880193; a=rsa-sha256;
	cv=none;
	b=o24hOXb0GxVCZ3t9EiMQiGF0RUG87NHHengb2VG/qW8+sOQ6010GBKwOKWKPiHM2QjKqWI
	XFaAtLwwfq0ZTAQwq4YhZW3w8QFx+SL/W0uHFRiJBEblC9PxAwX8/3C4goHqrnFgPBYpec
	FdxnZ/HdtKgMdLIyvEA4Mee/modDooU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=PlmxKosd;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf30.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767880193;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4+OioS+3EqJiTTbjHePESz6Tj6le+3+V5n7eOy9SNuo=;
	b=7IFn40Wvlu1RTXGE4HRWk+G2P/mLAQB8yCySwZ74vtMGl0LDVx1aN8EPZ1qivY0raYOdIQ
	qRizuqAK0qcwVnjsBaC1sXyAjuFGOu4VoneMIa85IFEoGrqUuhFzmFDX/lDv1xoCToh3xJ
	jks9ISoyX9waN0hk5vDTwM1s2n/Jihc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B18E244397;
	Thu,  8 Jan 2026 13:49:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4562C116C6;
	Thu,  8 Jan 2026 13:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767880192;
	bh=dj9sdbT2lsAp2DCg/kTXsKPF6jUNVjpQUi6zVaIKlmo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PlmxKosdoSD2BMW7CRXjNHaYi6ZPeRcYJOMUl4VZABpXysEoYKX97rQd57D+aj8BY
	 CLvR5h+k6xyV0c9dSFubpPhPjryEVDIIu3PL+Df9bzPxwupJLdXlBjWaIIhE3EC/SS
	 ebKLVPvqVBq7tb1kswBfIOmZclHpjssFR084TgaA=
Date: Thu, 8 Jan 2026 14:49:49 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: stable@vger.kernel.org, Liam.Howlett@oracle.com,
	akpm@linux-foundation.org, baohua@kernel.org,
	baolin.wang@linux.alibaba.com, david@kernel.org, dev.jain@arm.com,
	hughd@google.com, jane.chu@oracle.com, jannh@google.com,
	kas@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com, npache@redhat.com, pfalcato@suse.de,
	ryan.roberts@arm.com, vbabka@suse.cz, ziy@nvidia.com
Subject: Re: [PATCH V2 5.4.y 0/2] Fix bad pmd due to race between
 change_prot_numa() and THP migration
Message-ID: <2026010836-abdomen-drilling-6326@gregkh>
References: <20260107032559.589977-1-harry.yoo@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260107032559.589977-1-harry.yoo@oracle.com>
X-Rspamd-Queue-Id: B54B48000B
X-Rspamd-Server: rspam03
X-Stat-Signature: iyribi9muczf6nwfb1hwjnewo1ha4ziw
X-Rspam-User: 
X-HE-Tag: 1767880193-652189
X-HE-Meta: U2FsdGVkX18Tn7y3Thrx7IeHfoV19aHzxHg6yOtitrUsMW7Gjr4aj5bAdlz2Yz/wLYed01nw1mj914HSxVdVMdqH0ssPYzQV9ZqTfubcSf2bWZj6C7ACq9cE+mh1qJX5FbHD+fRgL8n4YwePGLDJ79Dk7iQI3EMZLh06B9ErHL0vGT/Z6n7ZmC4VTIaleoqfgwDQ75MerO9SlnNF39Bktw8MGMEp+0XBNYgyntTKrywiZXxcXwXnwsDlxOs7V5HipW6k0oZT1Fap8AhxRIEN+3Tj5+QZZ+t8Ca3mKEmeNe4gEodgX9JqRQ0FagsvX2t57ONTT1oRJNfrEaXC/kk3CaMW+w3H9NQidZrL+xbUAXvGGP/BtNP18Lk0uHUfAiNRWvqkALGQ3DiJxQZZC9AozT7hQNF81kuH0a8/TckrwQ4nu9moekXL2A6Jq4sdGhCJmKgY0NyKJZR8m+PMjopvPSViEFRifKhluOecNJ744wvjiwyyluvpEEVKeCIe35IL7lTmxixXIK9woQ5isRFMiMc4m+bvEKoDIJyMYYMnWq7q+aae8t+a75FwmzVQch+vEK4QjgLFUeoPk565muiHBjR35azmBS04OcBrakRh6+6YTkBZPa4/3LmAEewUUkvu87xXVFxlDSwIJOdCnY7N1kCOJmOmN0tfi2K+LCtc1OWaYND8q8xUiwQUtBQ6VgnPkwttrRdKnlv5NYbjDukgUGxV7IrrfxpjHm/mVrhIgvK5nrUciQc0cgPKWzDC/Df+hAkZhfFnQhYTMVqLTi+PyqO9gEu3o+Hsr8VO1Lis/qshC/PPOOfumDePDv3BgOklCkUIt0u1lT+tDj/2FikCm6IUke7JLhsqrKl0pKCkrWuv+b3Q4kYPSXegL0McPHmlSsD8QqAa/fTjUmAXjrNGgPLJFL+YzLyZwZ8s3i2kv7A0Gad+DTUPYNfBI3odqEt7Dj6emYJ5cSNjOL5d+/+
 5rUFt9hH
 3fQjSTzxy4yEDG73xy6JdlqQszarnEtM0KHAme2H7j0Jv/2jaDoQKtEdEPLqy1mDDLJEvL3r5ViAi1YXPRh4pya0yK/3B3pkp39h4Z9GLvj9jfC05Npx3h/M0tFoVz+7c8l/M/mVjUlwf7pM0xpkFOnIwXY6RpGaD6LPfLg97xC/HxrOwUFDVTbOVgCJpG9ZhhdktxRH7ZtHiB9zosWjCTb9g5UaDIQYSDB+vWF2BoigZaC521BiXBgoqaOZG8nYzDYgsXeS1ehcajac1NT7q/i1FBtCB8FUI01O1Ve1ftHKLwIBA4WqNklNQnuU1tR3+5lO/qj86tqD5Vi4RiTDX4/tMZeoniu6mz4Offn720eHh/8LVjltTR1ibT8km5fBSU3XOuBOcv00+bAHNN/6EQY7vo2hae2/IeYnj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 07, 2026 at 12:25:57PM +0900, Harry Yoo wrote:
> V1 -> V2:
>   - Because `pmd_val` variable broke ppc builds due to its name,
>     renamed it to `_pmd`. see [1].
>     [1] https://lore.kernel.org/stable/aS7lPZPYuChOTdXU@hyeyoo
> 
>   - Added David Hildenbrand's Acked-by [2], thanks a lot!
>     [2] https://lore.kernel.org/linux-mm/ac8d7137-3819-4a75-9dd3-fb3d2259ebe4@kernel.org/
> 
> # TL;DR
> 
> previous discussion: https://lore.kernel.org/linux-mm/20250921232709.1608699-1-harry.yoo@oracle.com/

5.4.y is end-of-life, sorry.


