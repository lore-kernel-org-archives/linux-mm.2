Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43C7DE6816B
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 12:03:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F7826B0089; Tue, 17 Feb 2026 07:03:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B8E76B008A; Tue, 17 Feb 2026 07:03:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E5156B008C; Tue, 17 Feb 2026 07:03:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2CA826B0089
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 07:03:46 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A8673C0114
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 12:03:45 +0000 (UTC)
X-FDA: 84453814410.10.23655C1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1F6E0180013
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 12:03:43 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U5rhgHvV;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771329824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bg91WDwmMBn7nlvyy0y8F2E7WNno/rtdlWvCXPMXZXQ=;
	b=HzXi/b/4m93YbnpY2RFljUT4lMopHw5ZZib3mNr9Vzr7AtPEym8pyzc2fGE5tIz36xdgqb
	wjxOD4rFR9L1OqbyApdDcJHdOs6/BmaOsltVi6QJZZJzrNavLHkT4KRNDDoqSaCoWaZGrA
	BGetoRZPEHZFv66YYC5UT/mMK/sjqN8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771329824; a=rsa-sha256;
	cv=none;
	b=rqaMV4D8PIBq1q9kVV4HwmyxuAo6xNpAU1nfelCmmPNd8hy/Ksujan0rjTHArksDlpnGrk
	gxZ/npw8VWJPL4jcGYyRayTyQRIr8Sy2v8DQG5+BZ3fvwYbcIre2LX/h6+CidU4/jl/LgM
	fVueFAeg7kgUvxxaaxYUN0s5gTy8ITI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U5rhgHvV;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6A8FD61334;
	Tue, 17 Feb 2026 12:03:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FAFBC4CEF7;
	Tue, 17 Feb 2026 12:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771329823;
	bh=fzN3neEFA+PXd8L13+T1DVvmzIb2m3kw4M+dUTcpoLk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=U5rhgHvVT3q7m+VcF1PQdOMoxiu6QUt51IUUHc/EQf/CMvvXn2K5BxSRW3hLtL5UI
	 xl40VZE+oE9qbztcfhRcA1NckyiibWXeEuBZatDelP9fFc+b0fYfc5ax3KnHSziV3k
	 sbcaUOW2RWGSy9Q2cSyjEY0b9pTrk0eyqNPDd+yC8ILEBArH62kBAplaUDD8lWMMsF
	 hLVtOBhk/j6mon1grTSz79QXRtI6Z9huqhcq5dKJyBmLtv9Z1xDdqd0TofmgBHS855
	 hwghkvFn+dbLA70cwWVQywY0ZKLJhNDt5hjw+im2eJHry28/2kQPEwe0VEd+Mcbn6I
	 owbeL8MLtJ/yQ==
Date: Tue, 17 Feb 2026 14:03:37 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2] liveupdate: luo_file: remember retrieve() status
Message-ID: <aZRZGSLvK4XIIhNk@kernel.org>
References: <20260216132221.987987-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260216132221.987987-1-pratyush@kernel.org>
X-Rspamd-Server: rspam09
X-Stat-Signature: nqsehs63kbz65d1f8g4yno9teqmpux43
X-Rspamd-Queue-Id: 1F6E0180013
X-Rspam-User: 
X-HE-Tag: 1771329823-944637
X-HE-Meta: U2FsdGVkX19r0h9JSLt0XG+Vha3bAF0nkW9aawC1FbFmfbB+EiPMrXdvqU/CqmDh2MuBgXSe8yliG8p9O28/RR/dhIVQNEMdJ98Ai0iwjy4b9Jt4hnYO98uc45QwirCBHzn4aOG84fnVekxOf0f2grrwjoJbJAlivpziPyQb+5uP9UN+3YHX2Lxc7rKwMZwDZrlqmRHuz4YelKa/vQfG6z7uLBXCAsw183uoHE5FWiucW3IhOlpUCW4CxkQTY6nJ8Q3Swl3WCRphgCUYM8K2e9GSdwhX0PS+wBfLJWQYbJHLfp/+rs3TuZ7Y/q2r/ZDCwjv/A8IprlnpJH7V5p/n/osOb8kAthSWgzaaNmT9exccVrGaLncn6JsDTw6tlXSdmhpMWeB90VmfaXEbNyyQ/6fQIhaEv8XQwm9qC94wmq3vVm39fjhv8zXLHyI6nyqRMqmG2D1Vqg5qLcgmd/gVBxGOkv6CzipubpJU/eZFr4KRTKzQmXzbFGn7b5r6tV3VbnXO03NLhb+YsYjjqVLvbdblyJhhb8lS8pSMTOa59ybr5lwMsELSFFWK+XQCF5gp+dExiYFTDeiroOgseiKWTU3p15efs0aohK3zniuPmtqSO7x0SfSzyC416J5Gg33CCTC2gGY2wPG1t/zJNOkS1hsO4Zmw05UVMKnhhY17ZyhezMwBOEwo4dx6xoObvC/xF86HOdvSV6N4RIjJRU/S7UXYejRpuSUFCFkGAiCrVz9ygSoWFaFciQt6weKgZbPJrNCbepknbRiPdHKUHj8yYtLA17Jr5JGhoSRj3YYJr1HpiU7kwHSmlUyNYTNUrxD6WytXtf2jo9VrhZ3dlqXM634KTfXmyDMhrKltRQq6bETnOlI2Dj0ivwfhZwufRk/vfVGrXgPfYhnSLOXy/tFMPTeXGIjQ84qBM90wJ9eVeoJqyseUUTnUj4IWbMXRs16OvDqUmYyG6TOvYa7TaEZ
 61KRzUmY
 8HtoyHKfZtLGT2lyoQcxBagaZj3wre38YCDbM7aMzRjLLOXNOlOq5KXo0/16asuaJuNmPR5k4FrLedJI6j2ZhApL6f6aJnFJHLnacUADGVf6qaihwaAmNYH5FK9+qbBGo0XkGuhquSihiq6GoDfk/00PYy7HA3wbI34HqV46QkPJVrq52ikX8jcgdm5qEZQ2PUUzmbBaNVukzk43phs1n/hgxfhqYiHDyh04qtQhWFo/u9e4Zzbu363o40DnOpsGcFLB8799XdCVEXg6JsF0BoghCGa2pZ0mWAsTv09r82C8rsxAUBujLCt7hDMiuCjRkg9At
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 16, 2026 at 02:22:19PM +0100, Pratyush Yadav wrote:
> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
> 
> LUO keeps track of successful retrieve attempts on a LUO file. It does
> so to avoid multiple retrievals of the same file. Multiple retrievals
> cause problems because once the file is retrieved, the serialized data
> structures are likely freed and the file is likely in a very different
> state from what the code expects.
> 
> The retrieve boolean in struct luo_file keeps track of this, and is
> passed to the finish callback so it knows what work was already done and
> what it has left to do.
> 
> All this works well when retrieve succeeds. When it fails,
> luo_retrieve_file() returns the error immediately, without ever storing
> anywhere that a retrieve was attempted or what its error code was. This
> results in an errored LIVEUPDATE_SESSION_RETRIEVE_FD ioctl to userspace,
> but nothing prevents it from trying this again.
> 
> The retry is problematic for much of the same reasons listed above. The
> file is likely in a very different state than what the retrieve logic
> normally expects, and it might even have freed some serialization data
> structures. Attempting to access them or free them again is going to
> break things.
> 
> For example, if memfd managed to restore 8 of its 10 folios, but fails
> on the 9th, a subsequent retrieve attempt will try to call
> kho_restore_folio() on the first folio again, and that will fail with a
> warning since it is an invalid operation.
> 
> Apart from the retry, finish() also breaks. Since on failure the
> retrieved bool in luo_file is never touched, the finish() call on
> session close will tell the file handler that retrieve was never
> attempted, and it will try to access or free the data structures that
> might not exist, much in the same way as the retry attempt.
> 
> There is no sane way of attempting the retrieve again. Remember the
> error retrieve returned and directly return it on a retry. Also pass
> this status code to finish() so it can make the right decision on the
> work it needs to do.
> 
> This is done by changing the bool to an integer. A value of 0 means
> retrieve was never attempted, a positive value means it succeeded, and a
> negative value means it failed and the error code is the value.
> 
> Fixes: 7c722a7f44e0 ("liveupdate: luo_file: implement file systems callbacks")
> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.

