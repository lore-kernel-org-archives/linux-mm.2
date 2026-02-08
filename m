Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B682EF06E1
	for <linux-mm@archiver.kernel.org>; Sun,  8 Feb 2026 18:27:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A7216B0089; Sun,  8 Feb 2026 13:27:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95ABB6B0092; Sun,  8 Feb 2026 13:27:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8870F6B0093; Sun,  8 Feb 2026 13:27:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7BB026B0089
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 13:27:39 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 11232D60C2
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 18:27:39 +0000 (UTC)
X-FDA: 84422122638.13.203C220
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 6A2A0C0013
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 18:27:37 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XWAOIIyB;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770575257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZiusDlZTeoocLZIqk00ovZotLUmwWaMt/gztGdV4JiA=;
	b=kHlMmaxywqkYM99Jk1QJ5AExg/QT2H1QZKM2k5DQd5pDTXsOQYn7SkLw44L1u5Xl/DmY2y
	3Q5hjTaNwuhFhjysmKKZmlCfGROc18mlmLDjoP3Mky8lubbtcMw7owko2QHcmRkA+rDrRK
	JL5RU3DmbAeRNREisnqtJtpmiBdoAAs=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XWAOIIyB;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770575257; a=rsa-sha256;
	cv=none;
	b=uDzCUlkjXpNXbKm+xXKz26eToCyyuyjDZ3vUSLBn9yAkKsN4g/analFcj6xMo7rEMxRzb8
	rjsq0hBjtVLbuAlhDljXbT2E2YQLHmRPquna/b0akSwjH6IxkxOZ4OczEpRmQ9kU+2FhzP
	46fYq8Yg0DrIv2BVfsssiAYmbclxyZM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C72C8600BB;
	Sun,  8 Feb 2026 18:27:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 400F3C4CEF7;
	Sun,  8 Feb 2026 18:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770575256;
	bh=W3IffCLBrBgEf2FYeJ7rhswTjUr6OfyY2Wh/al7U8XI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XWAOIIyBjdG9Vc8ratkZMGToWGpGS/da+eAb3qMLd1bnOCHMIiwdJVYMFEEGWZm/q
	 hAiMMVTUNzllZSc5rUdMmrZKayp2JI3ek7isQt2hiPO2xW760qnyYFsEnPKqkCRLSy
	 bmat2sMb+3QLwuUtZK4IDo4A85NVbws0+iYLAFI6U19HjdA49JDmdFeejpnR1efl5x
	 /+T7HZTx6VYg1VhNShhV8oM8AHaOUKqQztLzSP5psxii5nJuUggsCOlQaVS3RM8an4
	 DSXWCdVhP1vEz4SmE7/Vz17lkpPXjuvsyiuR3wpC46gW4RCadIvavAT9vJHVMSkQVJ
	 2t/caZhI65vyw==
Date: Sun, 8 Feb 2026 20:27:29 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Jordan Richards <jordanrichards@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>, Shuah Khan <shuah@kernel.org>,
	Jason Miu <jasonmiu@google.com>,
	David Matlack <dmatlack@google.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 2/2] selftests/liveupdate: add end to end test
 infrastructure and scripts
Message-ID: <aYjVkb8qOA6yHDA7@kernel.org>
References: <20260205222329.2419035-1-jordanrichards@google.com>
 <20260205222329.2419035-3-jordanrichards@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260205222329.2419035-3-jordanrichards@google.com>
X-Stat-Signature: nbcxno3r5ps3sp5bzddumneaatmmmq43
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6A2A0C0013
X-HE-Tag: 1770575257-455855
X-HE-Meta: U2FsdGVkX19vqD65CiJmLGx1v1SzxfBWI77/NOUuSKsc/j3sT1YRJbk6XlCQo6rYFbari7aISVgMZq9tm5aBPFMpHy3YYOW4bjeqX/9hdXYJrnbkJtZ52y0mT65u8u1pJxZC6sdXhEJmuuWUrSCrJINzYTjrRWoIExbnGMG1ThXNEkzG4Zm0SULya0zIV+eJz+LEG7QQhUrfm6bVkU+VHGtTDEKUqbc8K8GarW+drvscTMbmcRNfhocx0XDHkqgqJM9jX4XWx5xlyy1FUJIDj1E3RU4cJ1QihVyM5ZsReiPZ5GEAf6udPCEg+PipYEjbOrh8+0anNlXuWMC2oXtgVR+jbjjJW+lTgRr6zQrW7BRavTSArBRhnNAiarL8Q33yo+u5+IlDJvNH3kbM4Uv2fIPMiQj4rXVyXpTXJgfFCkpgmIldeyGtFiSRsQjMFBYxqTavBCZE/OxpBJRFpO/QLiuyOc+6cTh6G5LPw1PSKDqGHJJ7us+gqPELNqtDIDmyC+tMnaRlKx6EPrOL9FwrFG8Inm1QqX9Hcx3JKNrd9BXey3Vw+K16ZBkejaaWEKPfJF41fY1eBjHVm55HOvjH4feDNAqXR5bd8oFThb6B3mQRttzXHgicweuykljUV1B77b0ilF9/hnKBGjJ/Zi7gOqdMSUkxBmF498rmdi90g2JM74+7HaIVVqvdEZ9xwg78OUertjlcOnpRJxcEGswNiEwk69jhi8GSSj98gfiV3cpvwuUvys2XgT8fkj4yCeCkaBGfE3px8nEQP5+dpPZTUmLQJAVSIqUkTtOn18D9Ax+cxYMBdsffKJhl65z4s/tCumlPFaTp1QTU/KfG9QSvj4qx4j81kk8pvh2W0lxemTghcLHu9KK54fZfvW67ZKq3qIqj/JtqrR2TUgTvC7gdkltZ+fMPrRSQtC9tOCV37AA1/5pVZxubF4cVODgdDzkcmuc5glkKq+RaiccnP+V
 2XnwmmcM
 vml0/rz++6MeoihiKJVRCpVS+lK1Mkzl3lxN4dD+NyMQnJVBVpnB5/ofgYcGDWYnQ2dK4iHXBisJmX7xXvF5WCVb+XvmxTnCNKyqiUnJwxTUz5JmXBrk5tCrJIuyQTnjqBWQTkTBvHx4KgJUwmwLtbB5yjx1B6idAdoDOstiXSmt7YheGQPWmMIWh34fQ8yWMMsyuQSGWdlOR1BddpmmMbAHnSgRDq/I4VXKJSzzhBKcyIBpKA1G3y3EtGGa09Fdtxrl9MeBv1RZKTTQMOwnYawnXA+t30ksXYUwr9fS/uOhZPkgwKZRdw8Q9vULkTlzDHuS8I6qcQK67nlB5KazDt7T5TxbvgmDpBT/uIPg3gmis+es=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Jordan,

On Thu, Feb 05, 2026 at 10:23:29PM +0000, Jordan Richards wrote:
> From: Pasha Tatashin <pasha.tatashin@soleen.com>
> 
> Add the end to end testing infrastructure required to verify the
> liveupdate feature. This includes a custom init process, a test
> orchestration script, and a batch runner.
> 
> The framework consists of:
> 
> init.c:
> A lightweight init process that manages the kexec lifecycle.
> It mounts necessary filesystems, determines the current execution
> stage (1 or 2) via the kernel command line, and handles the
> kexec_file_load() sequence to transition between kernels.
> 
> luo_test.sh:
> The primary KTAP-compliant test driver. It handles:
> - Kernel configuration merging and building.
> - Cross-compilation detection for x86_64 and arm64.
> - Generation of the initrd containing the test binary and init.
> - QEMU execution with automatic accelerator detection (KVM, HVF,
>  or TCG).
> 
> run.sh:
> A wrapper script to discover and execute all `luo_*.c`
> tests across supported architectures, providing a summary of
> pass/fail/skip results.
> 
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>

I think you also need 
Co-developed-by: Jordan Richards <jordanrichards@google.com>

> Signed-off-by: Jordan Richards <jordanrichards@google.com>

With nolibc fixes Thomas requested:

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.

