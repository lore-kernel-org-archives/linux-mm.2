Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BD1EC44500
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 15:14:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED8C96B009E; Sun,  5 Jul 2026 11:14:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E62566B009F; Sun,  5 Jul 2026 11:14:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2A7F6B00A0; Sun,  5 Jul 2026 11:14:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 93FFB6B009E
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 11:14:53 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E9C8989053
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 15:14:52 +0000 (UTC)
X-FDA: 84955070424.07.B8690B0
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7318F40005
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 15:14:50 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=aELJ83Jd;
	spf=pass (imf12.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783264491;
	b=r5kaNVdyjDPrOrhHTZ+B09xqC8y09lrwh4AwRQbw144AeT+6om643UMo3bpa694z7tPEFt
	a0aRS+T90qlbxzsQQ/7mNWYzVqn5fIKgmbfvuOa1NgEnJ83hB+3dyYOwOr9nQxip+r6lXh
	IIzy2VNSQGrHW9TYTiOrm0SLLbpabxQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=aELJ83Jd;
	spf=pass (imf12.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783264491;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xVGyenC0SFTxaahRR3YV9EMNLnHoYhbouZ6rWoZdi/o=;
	b=T0cbiBU8LIKJV/EAp6b4T4d/Sw2JHA/XFpfZhdx61AVWDwkukNtSGHLfQRa4l2z2AMaWE/
	zHdukTJzLqOzqK8rcQTHCmODa0ldhPL6bHXQw0T8Dxszj3Uf/09WTX/sbGv1y2n01Vleb4
	c7dXf4B/W2a0gIW2rN2qQdDyVLf8C+4=
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 787C540E0163;
	Sun,  5 Jul 2026 15:14:46 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id GHw9jlYOBmpj; Sun,  5 Jul 2026 15:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1783264474; bh=xVGyenC0SFTxaahRR3YV9EMNLnHoYhbouZ6rWoZdi/o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aELJ83Jd115SE497B2UiygLqfAClT8mpMnMFlXSttmta3//gs95Un85B/NXASrDIP
	 1NycsdFSD8Bg8OBK+vwykWBIHSrYXEqhvAr4hdfURYPjz4+r+agfJ6i8f4PmylnCUA
	 leCpEVGpt5iIBOzJK/+EgmboDVAWFbqewwRnCnnpIAhNekKUxcw6k6OUa5HHKHRN/M
	 79m0LJERxxC8kgIpMLvBnFhoWKZ/JUPDkefJonwAbSFL2j9qU9Nrb2M2mDmnLPED18
	 QQYNE9MO5GWWo11WjEyPKqLi7yisWKc0F9CAw5dATLv7CjGRy/JrSGmXk3TYwZaUms
	 geB1dZpKhBTV8n9bXktERsXdjcORAWtb6GtRSrlEAplfL5tnTe91dfe5Plpnjt4eHZ
	 s/2RCoS89ztFRULElvHotLsEp+61PwxdPEWg4MOGm4MiFEG6bu6KlFgjxCwaNcgeLl
	 PieynOZqAki8db3hMnGeJzWM94Ec4r7QIlK8r5bvoNBjKG0/O79NYisy5Y+Z+Yhual
	 iElPuVi5v9oJb/EsryKZkNisIYZw6Zl4OqdpeUpqoZNblwgHdd8HnD99kFZM8YWB4v
	 JPZKv5nbOn4PNewgAGhuv1PI5ukG+RFDuXQ5TChtPdNtPx0j7GLTrkKWQZRX6hWAEg
	 KPVD0NQmI3fZAur7nKfmpqy4=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 8382540E014C;
	Sun,  5 Jul 2026 15:13:57 +0000 (UTC)
Date: Sun, 5 Jul 2026 08:13:54 -0700
From: Borislav Petkov <bp@alien8.de>
To: shijujose2008@gmail.com
Cc: rafael@kernel.org, akpm@linux-foundation.org, rppt@kernel.org,
	dferguson@amperecomputing.com, linux-edac@vger.kernel.org,
	linux-acpi@vger.kernel.org, linux-mm@kvack.org,
	linux-doc@vger.kernel.org, tony.luck@intel.com, lenb@kernel.org,
	leo.duran@amd.com, Yazen.Ghannam@amd.com, mchehab@kernel.org,
	jic23@kernel.org, linuxarm@huawei.com, rientjes@google.com,
	jiaqiyan@google.com, Jon.Grimm@amd.com, dave.hansen@linux.intel.com,
	naoya.horiguchi@nec.com, james.morse@arm.com, jthoughton@google.com,
	somasundaram.a@hpe.com, erdemaktas@google.com, pgonda@google.com,
	duenwen@google.com, gthelen@google.com,
	wschwartz@amperecomputing.com, wbs@os.amperecomputing.com,
	nifan.cxl@gmail.com, tanxiaofei@huawei.com,
	prime.zeng@hisilicon.com, roberto.sassu@huawei.com,
	kangkang.shen@futurewei.com, wanghuiqiang@huawei.com
Subject: Re: [PATCH v20 0/2] ACPI: Add support for ACPI RAS2 feature table
Message-ID: <20260705151354.GBakp0snJ4OKmlUFiI@fat_crate.local>
References: <20260704220745.110773-1-shijujose2008@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260704220745.110773-1-shijujose2008@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7318F40005
X-Stat-Signature: jaiygqmme963sjsmfd7k1etpgkffp6ih
X-HE-Tag: 1783264490-851581
X-HE-Meta: U2FsdGVkX19JwAeo0lO8tUavpBuzmgU/BxXwSPkn32LnsNJ/GtrgiZKX2cajH7poyod/geW2Q9JHMqffEgjrLNLdhsOQ2l5ndwHw9OpGrwe2dKEbygF44OGkeF2r/mY7KtMJ6vhmXC5Gu2nCd5wrCCJRirAqsyzWgkwm9M6T7IEF8Zp/TtRbdHL2KP2O07wOn4cnROfRzoy53cJna6Rx5kE+X/UgY9qq3E+dfZjydbR+Ysaq2/CdZt/D+r61kxzczkBJ/y4IFDbpv1Yrn4fbAibG84kp2QFO3yfTLlBNL1Nws8OYTzMLlvvFfLQEKOY0EG331voJmlyeZ+p3LuzZyL4swePGFNBZpoObjgkycKGcy8bBtnB81fldRg0cs0FyXa2+hwW60raxTQHdV/EvtHOHJgkPp0yFFlsPcloKS4M5UsR8girm5nkL60hwhlgPWTlHTu+5X5t2KIQJWp06zKBCLLffnjI0Rw774JuXp7p1K8pm6GkXkkuneNGVWKfPma/ZZ4d4mZ2TU0ZQFAdeguvbK7gERyGhRneJ+qim9GAt5LsOHCs4Qpq7R4+lfc+wCWdhrjW4JHsMZfNBTx7UzpvCEPmc2dx2o2oM7oSp6nx2y1K6jk1r62MXcnpZTOI6XexATZefjev3Lf5VwSWBdnTbEpg4p9TxnEuQmAJhkJ3aX7JkHwbAprwLA4enjwOJIsoiWmes5QGVLbML3uoP215JGPgezmrNnJU/2PwYGUO7CzKck91pPBs7PsebhCd9TmmEcYLUWlthCilsVEDm7zOtKhMsTXFdt3kzoVSOxnDlPw01KQlkMVvPwk/ILZlcdQ/ivaEhyb1YsVTlXtvVOLWyf7XeAskorGngnktUek/VAthU7aLzDMa9MtM1BtsacBHUmKIqsc9K/5xgpiIl2a5s6sZuZOyXV6ReDe3HuZwgXpllKVIKwRBTgCACBKdnhciVexLu5DyqqZb9wHL
 N/Aa4JdE
 b490fhNRCPn5rEH8W2OdTglPLz6/NBAPtgxdqStXwr53VRegd0e//KUhzXt7O/i1tWfEraOQTRtFlBm34ZUe2CPEPWro7Jv6g27eKOuv7ZSvIJqELQO2SeGVMipNC/l0XIGj/h4cusHcHRMBE0Mh2uhYBeUQkQVyMyyf1HYsB1KobnaoqO34Re6iDvfX5dRagh3CGxcVCkmTqlBQd9Gzhd/F2xwMzPEFdcQBhQj5HH6VjaeKjtsPRJZfuoahQiybgq/TaLy8Jlo0eOPpk0mBN5fcrNqdgMVbANYB1UicoTBVDwYOI9bD3LB9CtF50XsRMb6gaOJHyV9SFHqQ0Ejs9k3wCdiSgcmspis9rw4dqAhC9TYG1qtKu2HGIEkM6X/fBMOv7OF/m1SDAB+ZcsbPRgJZ8PRfb96dewxGI44ird15ldffYZaPqkoF+hrtU6N1lwfoEOBXSWp1+5DGRKNuLpq3SAWmxAkOPlgXwFeX8/n3VFFpMipbFSSebvGJeRXgurQQL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jul 04, 2026 at 11:07:43PM +0100, shijujose2008@gmail.com wrote:
> Changes
> =======
> v19 -> v20:
> 1. Added possible fixes for gemini AI reported issues shared by Borislav. Thanks.
>    https://sashiko.dev/#/patchset/20260408172850.183-1-shiju.jose%40huawei.com
>    Unfortunately could not get a local sashiko review setup to verify the fixes
>    before posting patches.

Yeah, there are new issues now against this set:

https://sashiko.dev/#/patchset/20260704220745.110773-1-shijujose2008%40gmail.com

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

