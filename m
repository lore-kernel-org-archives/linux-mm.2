Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E595CE8D4F
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 16:32:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E5058E000F; Fri, 14 Nov 2025 11:32:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BC948E0005; Fri, 14 Nov 2025 11:32:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D2348E000F; Fri, 14 Nov 2025 11:32:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6EB1C8E0005
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 11:32:07 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 03525140456
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 16:32:06 +0000 (UTC)
X-FDA: 84109754694.23.AE16F32
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 924352000F
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 16:32:05 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="qCIGg/d2";
	spf=pass (imf03.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763137925;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=041pjVoVlObxguqJXnDZhxQ3I0o1sLrkCwAqRkPqSsM=;
	b=mZAzBMq8hrKnMOjtmLv3TLho0bKwrZkVPWCIufgwSqKLA92adi0h+eZ4Fx2ZW7C1P/KYqf
	0ipIv6Hc2EHygB/GKMKieNq46a8MlVIeQnQ3IzDm22zG9axnI3Fpbev5s0VL6dI9/Ar+kg
	3/zBOQNvqJyXTlGOKwSkal2dqOCMKhU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763137925; a=rsa-sha256;
	cv=none;
	b=qsdNP4fYnZSPduq/b15kNNUsv1jC1LwcVi7tGs5JAHsVb2z9sQnWg7tHwT5d9H0r6vmSd3
	XoP1T7RjzNhVyuhacd1xeaaZNCB2r9D4A1DoOW4HV0uEtyjEfnHCFKIQ2Z0VJhcJ309GaL
	pW4ai2/KMc+2vWfssPCdzuQ1sI6aPgc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="qCIGg/d2";
	spf=pass (imf03.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0AFEA60150;
	Fri, 14 Nov 2025 16:32:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B467C4CEF8;
	Fri, 14 Nov 2025 16:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763137924;
	bh=tvaWCesSZPV5aZlyiiBehWbeYK80FC2R6bxRgb0JBv8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=qCIGg/d2HL42aDcB/Jy4naeEgwsC7p8QScxs+SzfBo8xshO5b0sREvxff35GjiixX
	 G4OEItKvJLztO3DAFZBDxm6nSenW1ZsDeVLHeDmKkeY++3qj4Lr6UsH7jrFdyYqoua
	 u91wQUy8WeigCtehOpi8RkYv20uysrmjxDNlBQ8eB2OYJqw1WSCNYIdHV4ZhINprVD
	 kuwwxUsyP3u9Sp3Et/cKunlR1A4e/3rWao+LqVNt4FkFKmJX7Eh850SY9Ys+18ndCq
	 uGVoMv2oJTSEiT1EpT30n9fXoF0iDd2SwTLhHlPOTBp5Kd11lJ4vQpVBv8Hk4ytYii
	 v36JV88qUa68w==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org,  bhe@redhat.com,  rppt@kernel.org,
  jasonmiu@google.com,  arnd@arndb.de,  coxu@redhat.com,
  dave@vasilevsky.ca,  ebiggers@google.com,  graf@amazon.com,
  kees@kernel.org,  linux-kernel@vger.kernel.org,
  kexec@lists.infradead.org,  linux-mm@kvack.org
Subject: Re: [PATCH v1 01/13] kho: Fix misleading log message in kho_populate()
In-Reply-To: <20251114155358.2884014-2-pasha.tatashin@soleen.com> (Pasha
	Tatashin's message of "Fri, 14 Nov 2025 10:53:46 -0500")
References: <20251114155358.2884014-1-pasha.tatashin@soleen.com>
	<20251114155358.2884014-2-pasha.tatashin@soleen.com>
Date: Fri, 14 Nov 2025 17:32:01 +0100
Message-ID: <mafs0a50o8tj2.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 924352000F
X-Stat-Signature: pnq3uft8txjhzhj6xqsjk6nihezmqjji
X-Rspam-User: 
X-HE-Tag: 1763137925-540592
X-HE-Meta: U2FsdGVkX19P+jKmUeeAepL2MgQQik7ES5cJVdjhfumqFiCpbahH+e82to6jqlmfDOQaCrvfjNkmvNBNL+RF37GBNwGM+bnxgN/Vc2KSADj1y/ynJuwzw3p+G1qXORn8ohXyOHwe1OsP4ch0NTzA7q2Bw7ppVbPafqY0PFzyhqInAmbl6CGekG6Z86tmWRQ9CbhF+g3p+vJSCMgJRIYtU5K7piC2CJ0BP09Kr25lVjs/CZbFtyn83lkI6ifO2aaAFn403lHt2eMDEbJWxtbzX0lu4mnTwzgDotKErjPeftjmaVNcsHIGruwpm2Mtla4lx4W4POTBxrrM9WC0WMhEfnfVcUAGYExl1SeqUIybww36n+/uod9emd/5/4TwVRIU+Bhs1rWGh/tsajXoJQX/1oDBvTb/qg8cbsnIjbmZPqy2JyP7hfHoFqx6cHq9oDaTczUiom2vNnOeB8Juw+GZis3gvLYbiFTdzayYfXF4wsTYx0dgvSO/JlN9f75SPnM0/f4wgVASGNqr+eFxgT7jlFFM//GpGFrlrT5uNdc5p6yxTBSeYADb6RK/h2MuGJZ0vHtEVXcpjQnzVA54lqMDO5l/C9DDjG4Oy1910XWEAiGmmRi+q27M5OFvoaffDKxZJ30FfYUUP5I4xHUzoEG6s7IsQ58oa3q9sAhwb/82MEc7uyVUEWlYZfy7214RTj5NHdt3APu4ZzDEVYjbCV5M4NHZi+NcIRfygjBWWmVWg6+rg7uuptihkMU7r0ZCMoHvcmMUA7h5gvSyc4Ml9HP1/mSPofPhe0hwTbJhZF/e8qC5sRMlTXhmd3ASh4S18uAT/pRnw4ESsIHsEcKuiEqPo2bffTcHaf+cu55YJS11I7isjqIW4Kq1iedaF/iXd7y/cDpsEpeu0jvYZeflLylCyFWuNDN+M1k5ZU2hb2Ufh00gI8dI4PGM1RkCvSADFIDxZHIECoahf6CpmsobUDO
 lNbg+/qf
 DzqAc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 14 2025, Pasha Tatashin wrote:

> The log message in kho_populate() currently states "Will skip init for
> some devices". This implies that Kexec Handover always involves
> skipping device initialization.
>
> However, KHO is a generic mechanism used to preserve kernel memory across
> reboot for various purposes, such as memfd, telemetry, or reserve_mem.
> Skipping device initialization is a specific property of live update
> drivers using KHO, not a property of the mechanism itself.
>
> Remove the misleading suffix to accurately reflect the generic nature of
> KHO discovery.
>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

