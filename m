Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CB4DD111A8
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 11:12:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8B306B0010; Mon,  1 Dec 2025 06:12:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D63116B0032; Mon,  1 Dec 2025 06:12:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C795B6B0088; Mon,  1 Dec 2025 06:12:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AD8116B0010
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 06:12:35 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 504238578D
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 11:12:35 +0000 (UTC)
X-FDA: 84170639070.18.DEBC63A
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf04.hostedemail.com (Postfix) with ESMTP id B9CEE40015
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 11:12:32 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=gP9VUsXS;
	spf=pass (imf04.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764587553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0UHKkc3PYHzcTPMCzzBKKTlGyj3Kl2+QZFHne2yPGnY=;
	b=Gw7wpqV9KJLQlAk3DVAcV6K4wJb5RaQW3mXmBXRrNkilC9sr3OUChyZ84eJyGOZ/iAfjKX
	DKPMtGf3vLtwtatmhDvTdrIqvQPVpzQIlX27PwMCIKz4t9G44J3KtkETVNcHQJ6jY2bLkL
	CPezlt4C88taK5qfUU6sR0EyX24nuZE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=gP9VUsXS;
	spf=pass (imf04.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764587553; a=rsa-sha256;
	cv=none;
	b=wkO2u9IxwG+jQAD731iVuhhj9FesBk3zqspDGXe13+pIhB/AzDRP8oSCgOF23WKJbmCWpb
	FGvgDD/f0TyBfyGP52Aj5mrVoTJIU3neshVyLI8QORIdvMvsu+jpt9wf2xhGaAgjDgswBL
	Xoj+5vdAJQr5wHBwLMWbn1RFe6fKj5U=
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 339A340E022E;
	Mon,  1 Dec 2025 11:12:28 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id iOkj0-JSgieD; Mon,  1 Dec 2025 11:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1764587544; bh=0UHKkc3PYHzcTPMCzzBKKTlGyj3Kl2+QZFHne2yPGnY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gP9VUsXSoNCY00dtFmwYA9HsNrANGcswDmKCrRIU9qSspIrUZWELqs7g59To6Gj8E
	 JRE8Ane9jRS0HU2HRw9mD6B3USUo1Rsrq7TcHmVI5jNXQyJlAWZCp5bpd6k3csnN08
	 cghKWIeD8umUKPhZVb4Hzl53eafkD6F5RsSEEj5eDadB8+Ol+xu6dGVjo7rSQKpIK/
	 38GMaxu6wTu4trOwuElHJmaa4AbCiTSjmKqQUpCwm7R5AJe/VFC4oovYZALDTXy4eI
	 rz3AIfBJtNkrq2P7FETAVMdBSWLJWOdV+6ko2zvw52nCs354uHkr8SGB+Ang0LksTK
	 pXvwu1u/kUPHMsAP8WMWLaJGKOwrQbi1M423ZfCEgNtEXgtQNhitqlK1TiwsRziQiN
	 +V3blEKOsmdeqgWlW0g2h1aOnYkmnPxyn94pVGSpu5iclhPRXysalhmDxKawVhfisZ
	 hywMlP2MqmUhQnIxywj1bbTmPLcBL88YaQmmYmMuaOjViVa7crTeFjcRSg80za9PUf
	 XD+Wly45URx1w1qksPtSCa8zxLqWQgdiO5mAlRYWMjEONeewSOOGB4a3M0k0r5Y+Rn
	 hL2as5hcOoxCGgaMfcOqBXZtFHl1tZiV0iFgXNqaDAK+w+Fp0xvEQVYtDgPG8uPmAK
	 8catoz1wBm6cQyMQOWs7AQzw=
Received: from zn.tnic (pd953063a.dip0.t-ipconnect.de [217.83.6.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id 7C54E40E01A5;
	Mon,  1 Dec 2025 11:12:08 +0000 (UTC)
Date: Mon, 1 Dec 2025 12:12:01 +0100
From: Borislav Petkov <bp@alien8.de>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Kiryl Shutsemau <kas@kernel.org>, "Pratik R. Sampat" <prsampat@amd.com>,
	linux-mm@kvack.org, linux-coco@lists.linux.dev,
	linux-efi@vger.kernel.org, x86@kernel.org,
	linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
	dave.hansen@linux.intel.com, ardb@kernel.org,
	akpm@linux-foundation.org, osalvador@suse.de,
	thomas.lendacky@amd.com, michael.roth@amd.com
Subject: Re: [RFC PATCH 2/4] mm: Add support for unaccepted memory hotplug
Message-ID: <20251201111201.GAaS14AX18qeHN20xf@fat_crate.local>
References: <20251125175753.1428857-1-prsampat@amd.com>
 <20251125175753.1428857-3-prsampat@amd.com>
 <66ylzwknm4ftd6utn3nqr63jmhl2ccvcdvyi5fechfnvmfxivu@37pckhjixayh>
 <20251126223127.GIaSd_v7juUkaW4RTA@fat_crate.local>
 <m3l6gcjmbabudtnqwv6w67t7iz2mpmbjyrpnmiq5k2iyargn5d@nyf2zzxx7yme>
 <20251127181233.GBaSiUkaLzwANS_6WT@fat_crate.local>
 <beec5651-5c23-4f5e-a0a3-d1cc01a8490a@kernel.org>
 <20251128113411.GAaSmIs0kSWGhCYkaA@fat_crate.local>
 <47927c25-a317-488a-823f-ac0588f4eee4@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <47927c25-a317-488a-823f-ac0588f4eee4@kernel.org>
X-Rspamd-Queue-Id: B9CEE40015
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: cr9nmec1177xub3j37k67tnprkhrps6m
X-HE-Tag: 1764587552-275646
X-HE-Meta: U2FsdGVkX1+ZKV/xz7OkPLz8cFk/yOQDsjtZl4Usn1OfRKYN1T90HbpBkuhJKLx/YrECAfOVTvft5AAPhHwivr8D1lrZgWFmx6OgSSREqjONObItr5gGVtBzXVHfbNLlXgAb1v5U46z0ZGt/kpJEXOnU8rkljGsBhK1SSLFpvVk57SsChK4vbbKDQmOkZUKVLuIBwl08HI9lcBGuM45NtrY0Z1PxfW2tC3gDQolluCaS2enuYACxFmb1zyEjJAGzk2iQqOQYGT3YTlmr4f98j3A6G6wUk2voawpEXlWp+8gwvTJUkm6Ivb35TJdDyV45qJtfUmuFHTbI0RZlEa/A0No5fJqL2qRvxTnkE8Kd6w8aAarMvNxPXKsdpBBpS+3aJCzzMXCTYhfDYjEYMYadvivQFGiRBHjdCCrF4gzTDyR1MHjHzsQxpncSVXh5Tb5OF+OULDKtNF7bcBbCjXvXwJPva8KnFk5gfPU1/SAnFv/lBjmsbFU4XusNxLDGyDAsG63yN4Jp8Dj4yJvvray9jFrU5KtNTVJzeR6ywelVjmDrr/FjiBIfsuKW3lJWugwzZLUe/jT2QKoHpdJ4MtLXLmeIt3IXH1bHL2V1xuXgn4pI0+Hp/NRP2G46a3832ZxlcvONmOQSfWpA+vNNjwne152D223fWjMczqJosaxdQGMMxOU+iQIDTH43hQaL84L9vUGfJmokNLPCeJkjete4d6Nv5pTpNcoOB4pOJK5FJxA8AIGJvjyhG9ACIkGUQ+v3Vg1GxvZHVdCRBIJeXs9nYupzm6cVgVnF/DauftrgfTKs1F2NaZbi2f1nK3Ts9WVLd5ftCZAcUXbXXZ91NwoNRdL3K31jWI9hqRCtUYNZIU3FAs421vGgWQd+5xLfkqobqTjgD2AggDeeRkamwWr6Pm/HdGkyIupQjmTi0K0hbdSDybRPhYnpszJ+M5HXsqKVn1fuyfmbki1oHzasDIZ
 CsANL+vS
 7OBC09zSpb1wyFQr31R/jd5rvHepsNBgyXO8NnxfJLlK9Sr0Rcj8VWRmFgwyVkIFdLr3BZF3J40L2CfIzydzriTPMWkU1vooeo5WuZOrRt/urNlY+PJQ8Ejft59wnRQHeKo1CUCm29vNOpg/7mZNbAdpSAPf9ncJDTlji7hToCRzbUWjjjJm+ZMo14rlZ8an/Dc98kfFXJo3UFGGii2r4Fc+Ks10evlnze5zaXmqZCJRZRhs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 01, 2025 at 10:18:37AM +0100, David Hildenbrand (Red Hat) wrote:
> Makes sense to me, especially for confidential VMs where we pass such
> kernel-managed data from the old to the new kernel.

It shouldn't matter, right?

I think the question is whether the kernel should agree to the software
contract (/eyeroll) to keep the kernel ABI compatible wrt kexec.

And I don't think we have agreed to that AFAIK.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

