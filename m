Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1779AEE6428
	for <linux-mm@archiver.kernel.org>; Wed, 31 Dec 2025 16:08:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 392326B0088; Wed, 31 Dec 2025 11:08:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 360696B0089; Wed, 31 Dec 2025 11:08:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 262FE6B008A; Wed, 31 Dec 2025 11:08:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 15CA66B0088
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 11:08:04 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 97D5FBA242
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 16:08:03 +0000 (UTC)
X-FDA: 84280247646.15.10535AB
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf10.hostedemail.com (Postfix) with ESMTP id 092C8C0008
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 16:08:00 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=DDJplSYz;
	spf=pass (imf10.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767197281; a=rsa-sha256;
	cv=none;
	b=SfIlj8Wg4y1uUasng5dsLXaJAJIWVojo/LIbrgZYZBAfVaLTsBHaHAGxOX+yXyQj78p+Q3
	JvjWv8oMk+saHPotueFagWyhm2vOs2EmDzXzgU7kQCRl3dIKDDRVz3QmvJD1P+tx78jcSj
	ZmlMw3spueMOPZBoV1wbIKliL2QdZms=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=DDJplSYz;
	spf=pass (imf10.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767197281;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HWouBMiF1EMh2+jI6GLE3S/Gvu5KjkPQi5L7cekMJZg=;
	b=CEUbxs4EjtRPhfEtA2QwM9ziPH88pJWc1vP4Yx+UHG8o0aLF3CyIyFESmBd5PxJFrlQk5T
	QUyB5UaSysCK05ck1NzzRIpL+3gnnpTip6z9a+apj3fsHAdvSZg+1vcBMgBjylBRKq6OjA
	NPLPEH55XtDb1fFl8Pmc7LYrDSfyt6k=
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id DBD4040E0281;
	Wed, 31 Dec 2025 16:07:56 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id IljZNyQjQjEF; Wed, 31 Dec 2025 16:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1767197270; bh=HWouBMiF1EMh2+jI6GLE3S/Gvu5KjkPQi5L7cekMJZg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DDJplSYzrglhEEbmZ0mRfZaOt3zwvpzuTwYLPVsof6rsoCbpVLSC96nBSs6sJZ53F
	 r4KdoaeGF4/+LewLHoiieG87nkutk8JbgcIJYbdXTwTkXTyFvfxZXuGIleyn9sZcc9
	 BcAs8YbvqWAggpP2XlY7M5l+gQpaX06Ltgg6LIIgvK+aPyjsUBKvkd+7SqenAP5IPW
	 AJWKodYRTVpNPr6bHQ4n75QwNuePw8LzroHCs9KLIWkz67rNuJ1hjGkYC46/VSNutn
	 ZEOBz90ZJbzZIQaiOhPx8p7xfOJUPgeNC8mnv0mXpV4MhUbC8ObjRd7t5iRvOFhRRa
	 ftxIcIDJYrLyaxkZ97E962kB6unDyW3gd9M7b6WyEnmDyF4//KX7HY6iTS0et3P+F3
	 MrxHpd42tAcWAnv7ERLij6+t52a3vzHiCjCgOMAFtHI0kmHp+2slxNsQPhjlzk7jqM
	 uvRewEESpB50jqP0hNOQ6Eh5u0UC+A45J6ciabtIvac6Y+68ksTzztgD5VJW28BOtp
	 89JbFQNRqBGCR2xNJz0DbYOav2IS0By8QBHilsLBzyo1mqrXsaLG41S9IrlB6I9o1h
	 xoSOWpgt36LbBIzAzRaVtQRday/5HW2zr2ygP2DaEHZL6BBd5KiUTYbKvtj5a2HTj5
	 GWhUmofThhIi+lD1MA4yZEy4=
Received: from zn.tnic (pd953023b.dip0.t-ipconnect.de [217.83.2.59])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id E824240E01AD;
	Wed, 31 Dec 2025 16:07:13 +0000 (UTC)
Date: Wed, 31 Dec 2025 17:07:05 +0100
From: Borislav Petkov <bp@alien8.de>
To: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: shiju.jose@huawei.com, rafael@kernel.org, akpm@linux-foundation.org,
	rppt@kernel.org, dferguson@amperecomputing.com,
	linux-edac@vger.kernel.org, linux-acpi@vger.kernel.org,
	linux-mm@kvack.org, linux-doc@vger.kernel.org, tony.luck@intel.com,
	lenb@kernel.org, leo.duran@amd.com, Yazen.Ghannam@amd.com,
	mchehab@kernel.org, linuxarm@huawei.com, rientjes@google.com,
	jiaqiyan@google.com, Jon.Grimm@amd.com, dave.hansen@linux.intel.com,
	naoya.horiguchi@nec.com, james.morse@arm.com, jthoughton@google.com,
	somasundaram.a@hpe.com, erdemaktas@google.com, pgonda@google.com,
	duenwen@google.com, gthelen@google.com,
	wschwartz@amperecomputing.com, wbs@os.amperecomputing.com,
	nifan.cxl@gmail.com, tanxiaofei@huawei.com,
	prime.zeng@hisilicon.com, roberto.sassu@huawei.com,
	kangkang.shen@futurewei.com, wanghuiqiang@huawei.com
Subject: Re: [PATCH v13 1/2] ACPI:RAS2: Add driver for the ACPI RAS2 feature
 table
Message-ID: <20251231160705.GAaVVKKfj5o-s7xLv6@fat_crate.local>
References: <20251121182825.237-1-shiju.jose@huawei.com>
 <20251121182825.237-2-shiju.jose@huawei.com>
 <20251125073627.GLaSVce7hBqGH1a3ni@fat_crate.local>
 <20251208162924.00004a38@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251208162924.00004a38@huawei.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 092C8C0008
X-Rspamd-Server: rspam04
X-Stat-Signature: hqejs8m8nrdd8c181495rqaf75ij757q
X-HE-Tag: 1767197280-106039
X-HE-Meta: U2FsdGVkX1+Ypt7ZGsi1q/UxlV+B5RiYm3xt8iAPiYtWXIVqBajtsJx3GC6v77yAXm9W13KO7rIEMEJl1PiaoU1QVbrTh5tA0jnnrblnlLkdJIDUVUXq6AR9iJF9ABdPk6gfSgwU8DNz1/x4eGSkiR715a26kYIp/MMeJzptl/8xZBooZCyLLCqTMrXAzt1eoVDqTJosV2vTCrgssSt1aUeYhM0kkTLlZ6A4MdHsfDD3egwyadoeXPSWyWetGumLFUVNZ7fhDMLsMb315EgBnANO30v9tQOXjq2+gFyEwUJgZxQaSdeL/Eb+tdXOs9fP3e+y/6EUJbALXMb88g5111BFaiQoNRUUVao1oXxNXoNBBIOb2++VcRujQ5wy/Uosrtf2rh7RSGcWOqkyvRcdRxXRlUtQ0DsUm8BH9Z0hSPIPpsiZuOx+ECdP3X39tatTubayDiOjbaf1l8yhlr7hw8RxIabq9muMWP57Xnam7EQt4bwJBYN+U/h+k5mphEXtYGNhRIcMetRMcUsim1hVxluphztnEjvwijiiCAedWvzbJ5W24I3iRfuLtMGGpxKa3Iu3U+tF1fv8lr09O+iGM8/vaxKsewizD9qN9m3PP0Cs/hWIUEkMulkq/4ntp3U4p8ApGYMDsaauDOmDmJODwcfOBHMhwnR5mDXCmZ+nvDKU3NLRQXtFpH39lTqDbiSyZXrW/XOFJYSX2Nge8EK09oF0A+ZNxx0TW2mTnMtgwVWeRGKMIth/frRS//rDCeUosoZIjTs9cUB4cjVcL8Ta2SDY0gYc4+KgtMBYxm6h3IQ4wtedTPUp+ImD1Q1mNs1Ot5L8Ku2bs2tydn0zlFEAkk78rd7212Vdz+lIDwYPioSXpyveXZDpTmuOCy/S0MFkktFNTYRamsPbvW8M5Qs2qLY/tHKU76/G3Hfz6j5TkkxpBID0p9keE/seKg2qgdjV98ny2Kgc3dyykzr3Kas
 7+2/5MZP
 0UDJvAHOxVbh3zL2SZopxfgAkmOCJzcI1NuLOFz+dBQF/WUw/gpiVqORsoWK4rl3tEk+zI1euoY63HYoMLu54cx9lX+z5YHlQHHr+bFfBcOm5SMFGq5ITCd3dOZcMp4zv+L+4+MPImSZu4SJ2Y0Ms67JuGd1/cXMv46DfF/Aai87hZhvmeqfcUDoP1mAU95/nbXDcnskv0XUG0OxvwhaaIPAwzOMKrUwyelqoRWbAQUYa/OdwBfhYlbXP5WWHfX4Nuw3LeUfZQ4013juYt4MQxooLIEIriiXpblCARKdunuf2ESk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 08, 2025 at 04:29:24PM +0000, Jonathan Cameron wrote:
> No to this suggestion.  Doing so breaks the rules that Linus has laid
> out for use of __free. Constructor and destructor must be next to each
> other. See guidance in cleanup.h.

/me goes and reads...

Ah, ok, makes sense.

Thanks for pointing it out.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

