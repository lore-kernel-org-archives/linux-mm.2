Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C32FFCCF9E3
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 16:43:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C7748E00D7; Fri, 24 Oct 2025 12:43:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29FA38E00C9; Fri, 24 Oct 2025 12:43:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B5308E00D7; Fri, 24 Oct 2025 12:43:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0A5348E00C9
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 12:43:25 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C283A140ECF
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 16:43:24 +0000 (UTC)
X-FDA: 84033578328.22.BDC5F33
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2C05040006
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 16:43:23 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XMTdi6wi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761324203;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wnm9HAm9Yq+THRRRr6dT3HSSsIo5cfR2FkdkZQ5RQXM=;
	b=R6M1lbBGGIlGduA6ov2FNGf01PiCKF04OWH9sTg5HFElOZqomVWFkecGVIgzEzZQDILqz0
	xS0qz8TZQK8rIcVnQhGcmIyp7Kb6wLCeSV2bKn3H46bdsMyu9c0wnyoCvlq7AHybybtFQE
	VBGkKNjGOzOlxItx6f83n10t2h6ku6Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761324203; a=rsa-sha256;
	cv=none;
	b=fmOW9CEV181NbbrOti8S/TYFnCPtGZhWRrxjCKDYhFWlx7PuRPk9k/+D9+djOr501GVlj3
	kspQaoPeK+UJ873kkH+0SpwIv1LqU1olWeb++qul/OZlWNFl3HokYcG7jEN3G5D6zmT1lP
	h92KJOLiT7UUKGLdW0YvTdaBmkqunTY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XMTdi6wi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 748586027C;
	Fri, 24 Oct 2025 16:43:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2C9AC4CEF1;
	Fri, 24 Oct 2025 16:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761324202;
	bh=YnthGUIKXztXO+a34kp8fF8ri6TxQZg51paSG28MCk8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=XMTdi6wimkywjFXY9hXcH5M2b/fBrCVF+7EhsdWkYDZ4qHMm1InoFTJtN2pDQetlo
	 bNMzE8oQun7FpMpNCi1rBv6ws+/XV92fV8QrAJ8osvZoY2KBLXqpjqWJ3bG+ZVfO//
	 E3O45AsxayedOGiBT4m5F19QjliZm26HRef1ekUTgVBWEfd9FBaducwx9Szxd5MVmr
	 X0A/dQ7nZMK1TXUUsMyAQySumS0yMuZeXV3H++2j//MnTc9YgnxbVMYqPOl/8bmRcQ
	 kZMCr17yt8i+zrf1P4160HG6IAW9Ve/0zWziU2z4WSrHcV/3Q5TBpIPlC6pwHP/toF
	 yJoCGOCHFh1JA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org,  brauner@kernel.org,  corbet@lwn.net,
  graf@amazon.com,  jgg@ziepe.ca,  linux-kernel@vger.kernel.org,
  linux-kselftest@vger.kernel.org,  linux-mm@kvack.org,
  masahiroy@kernel.org,  ojeda@kernel.org,  pratyush@kernel.org,
  rdunlap@infradead.org,  rppt@kernel.org,  tj@kernel.org
Subject: Re: [PATCH v8 3/8] kho: drop notifiers
In-Reply-To: <20251024161002.747372-4-pasha.tatashin@soleen.com> (Pasha
	Tatashin's message of "Fri, 24 Oct 2025 12:09:57 -0400")
References: <20251024161002.747372-1-pasha.tatashin@soleen.com>
	<20251024161002.747372-4-pasha.tatashin@soleen.com>
Date: Fri, 24 Oct 2025 18:43:18 +0200
Message-ID: <mafs07bwkdzdl.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam01
X-Stat-Signature: pjb5i6m5s636jr6tforjaodquq53u8ya
X-Rspam-User: 
X-Rspamd-Queue-Id: 2C05040006
X-HE-Tag: 1761324203-748385
X-HE-Meta: U2FsdGVkX18RmMPu2xRJzwS7exhYmanumXV3H3dUcGUGnfATog5IYC57L3T8IvXIPWB44e5mz+lD6haqf6ZcPiAcBza6uRYMMo4+n+o+JEz+/5sIdswxJZTjgara6GbLBWygH9ls21uV9tW9BXlnPYqHdUyIR1PM/wsK5Zoe8E0PQTHaBMziFHtga5d+UnfZ9+Ouw38B/R7q85v6NH8NbMApjzWzbA+IuK9AsS4aHfeY98w5J2xbptDAcAC9boVTzEBxzB6RVQlprDnPacmbmik9jLDV/HeIbxI3/OqR+rhiwJcx/YDh7UQjQQoia3oq1+Vox/O56fxE0QZoXl0zX4m/BiEaIhuyazehECuuNTXSaGv59+4b7MRWUBgMZswTeh/OyEYWXM3ON3TkMybc433SjUqDO100SV7glLXp98zjr8LxBnO8TxhLZF4FML3hLEiNy5FywxcjKxbTmCuFb387iknonjGPa5G0NqYgQU8aShorCBrPpuMLFhWQ9qMxN+BdzdUWx5lEXXF3Ey3YaaDWiaGphYM9OQgeHmEGghxPbjBfZKVVXNrMvvmeBhXmLOOGhZNHCpEl9t9vxLvabvx1GZbvBwjrwMs5BVkCice9efF20quWL01SfykPa6gyBahUoaHPjtrhE7prNzogw3KkvekaHKc0C9Z9GV3CWUhI5VErRqVp7TebTexr7kGqIvlXXnukI92I4PvsER5whVxbHH3I9hnTI4tSe8wk2aqrmsODKg1dao6LtviRcHqseTXIp8+SiNnTuH4VGFTnyF78/L4poWaQEdE2VLu6bNeZRdmxXeMknRqE1KO2UcCzODe5CKeILRu5Uq5nkDnSY35hKAMYS0/PFbvaiYjUcuXvROGXaXzBSmbrkw+Jrxa//E4CNNWiQYVh8536NV6p3pFpNGwQBxbM1ex4xWAYbEgcWg6zp9TxawwP7iQzxhJhDHkI6KPwF+deedAPsoM
 cUmwsilk
 g/VoT7m8BVEPhA8tpIvU9N/tiLnuSxqQu0AXuYI8cCSdM4rgFn36ea3kNoDjjSF7eY7I+LsKzHniSrfaUvYxp5MasIR4FTHM3MrzYop+HRmXH1BkYZtueCmuvUFQn2xbPXTWFxz4WlNgIUPasFQLCn5AoQQmRZJWq0JV8wQELsHVBGukkkwe96GDS1Rlf9OwOF9HaINY3mEhW6HGyuCAZklcofw2p4F3X0IQJZeA7Mq1edIf/xQIgv2dtVP1HxgIZLT+V
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 24 2025, Pasha Tatashin wrote:

> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
>
> The KHO framework uses a notifier chain as the mechanism for clients to
> participate in the finalization process. While this works for a single,
> central state machine, it is too restrictive for kernel-internal
> components like pstore/reserve_mem or IMA. These components need a
> simpler, direct way to register their state for preservation (e.g.,
> during their initcall) without being part of a complex,
> shutdown-time notifier sequence. The notifier model forces all
> participants into a single finalization flow and makes direct
> preservation from an arbitrary context difficult.
> This patch refactors the client participation model by removing the
> notifier chain and introducing a direct API for managing FDT subtrees.
>
> The core kho_finalize() and kho_abort() state machine remains, but
> clients now register their data with KHO beforehand.
>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Co-developed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

