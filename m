Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18927CE8D60
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 17:34:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 751058E0047; Fri, 14 Nov 2025 12:34:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 701478E0010; Fri, 14 Nov 2025 12:34:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63E758E0047; Fri, 14 Nov 2025 12:34:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 537F28E0010
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 12:34:16 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id ED5AFB98A2
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 17:34:15 +0000 (UTC)
X-FDA: 84109911270.14.A2CC03C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4FB7BC000C
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 17:34:14 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pFcxALcK;
	spf=pass (imf10.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763141654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rfE1ixHW4HLZWlryQ8v4nSzY9wnCBJEHv4p0NufeQ0Q=;
	b=pe/qNoDonDQ26El1U5QLw/iU51mfxs/JycT/3//zkkxaZaEpz1RDxkJBeuSa3qyBrDCGu5
	O/LcFDji23+F8bEeZ1XwD20piALwa+NGcyMWMHlLQjM14IMRZtQfJTaFVLt721C+HkFl9U
	AcHUdTo9nur3smUCw67y2hnKpkYDmwI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pFcxALcK;
	spf=pass (imf10.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763141654; a=rsa-sha256;
	cv=none;
	b=GQvYoIUH4tKk6dPUqIG70kFt7tc7VP8UzwXL19XcQIYQBFxqmLo+vqkSu9ZmBP/ci2f3e0
	YgEpFvO+Ne2lR8YsUMPKqxi4NE47I5q2fwyDNTXkp69MVeuSovoPSyy6U/W4hzjcZCdEN6
	8tQgtxsjVLmXq5vmmUqDpnLsvjgc1fM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 757FC43373;
	Fri, 14 Nov 2025 17:34:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22048C116B1;
	Fri, 14 Nov 2025 17:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763141653;
	bh=sfUecj5LXq8ygB5hZwBv17W6tTJhiXt4mvVHfCkRIYo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=pFcxALcKxbGfPOXU6jl11AI5j70DY3GzkB3VavJQ8ZlP+ZbFdyUw2vNOqThHcLzu/
	 /GPFvJl0xWEhLxkz8YVAOvYkrqK/Rn6YyCse+wrvOL4DujdiBGxmMDpfo6SnAN4wwb
	 etVVvPYOAwkB4w0QvDSsFTPw7Re5IRsadi1m3UhYANYlNtuVSxOM80ku9tGoddJJOh
	 I398yJQxGOzIMpgjO2wvkROaHfZpvJMRGixyeTM4CqdXoLIay3J5s1Gd3qCfke/lcn
	 TRxhlF7eZ1xXJRLlMXYfy21PY0gFifnNLCfFt/1UN8D2auos2yinyUH7wZAUzu9N9H
	 wljpJKETg73Cg==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org,  bhe@redhat.com,  rppt@kernel.org,
  jasonmiu@google.com,  arnd@arndb.de,  coxu@redhat.com,
  dave@vasilevsky.ca,  ebiggers@google.com,  graf@amazon.com,
  kees@kernel.org,  linux-kernel@vger.kernel.org,
  kexec@lists.infradead.org,  linux-mm@kvack.org
Subject: Re: [PATCH v1 12/13] kho: Add Kconfig option to enable KHO by default
In-Reply-To: <20251114155358.2884014-13-pasha.tatashin@soleen.com> (Pasha
	Tatashin's message of "Fri, 14 Nov 2025 10:53:57 -0500")
References: <20251114155358.2884014-1-pasha.tatashin@soleen.com>
	<20251114155358.2884014-13-pasha.tatashin@soleen.com>
Date: Fri, 14 Nov 2025 18:34:09 +0100
Message-ID: <mafs0v7jc5xim.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4FB7BC000C
X-Stat-Signature: 1i16pomr434qd6q69ioi3jgb5uo7t789
X-Rspam-User: 
X-HE-Tag: 1763141654-729249
X-HE-Meta: U2FsdGVkX1+BrV7fopJjzfaq03VCQ2vVTu6u2G9WQvpXaB4KHE1UwRJLZB6tSLwOyJWCQxOz+IWhBKBLFneV3oPusHyd2p/cojvW1TX5M2uSRSz6uwbf3pCGEJ09eO2YpWWUvIzcY+sH9yFVGtSazFcVbJMjsnKd3DeyE1m3En2iACJc3LKrEyNid6ESDsXehN9c6vhjSj95xN1kKNPSbuUMsGRL+rVZHRsEqKJiwW7DY7sVAOkmJraK6QCNosljSjXy+zni3Q5oo71UgCsN89R+tUhYyG43eGfVoafA7NkI7kYW967168GM/ypOF7GhtM5xG6/rRjmX/hIzqJcO+vLyjRSyE2OQwRBQTmo3FIzoIaoAR1oYXns4s9ALmM5rRYxuSU0ZVIf+3ufWV7vojEi0QI8KsV1fw8ycvDmRcPw2DtviwC7SdP6hcBkcJPNA3V1IuqehPzd4n07je6VTexUB6wxUpv7rRcTqa7/mjkHgfzsK7n6l6XtieBikSJM8l6K9evbBtB/II2RRDjuYBGrfwIAGeXQXbgOI1zpFDq01NhE+/YDrZvr2/h4XXbebLfVN+KZVNle64ATNWMYbp+zsKum4mie1ZFu/adBLCC5lM9BUvtu5yb5QUbN1l8jhcuTpvB8VivMtvc/tgVOsM10fQKqvNqxw1rZTjP4dogM8qJiXwzC4NP6+rTteKOhYMiituuYeZqIsVTpzEmvsoWM3DX8ivXGYa/Zs4TQM+CIGHRf2ms/ePnh8ujpbjA6WADExGrmUg0ziJH9BBLIDWbpiTpCr506Od+PerazjutVNKQROJf/gAGR2uJRzH415QWvG9ix8LOorUL3M/Cs8fL/xGGv/bu0IVvxWdssoBVzx0C8CFRXnc1AdT5DbZcD33NCUjv5IVEHUqpc62/2zb+gRGlz2AVh8OxbZxoK73E31itPxicsE22mUu6L/tNFF9FrRbWAgf9SbtJCBofz
 jTqiKBzz
 wDKKHMDkgy184WuiGQN7Jz6aO6O67RkWwhkn5UY01rbwoM3BHQyXjFXFGBbmmmJ1xUy6mPlpl0JhbCgvHoAObdRUKcIvnHJZGzTha4RL61vKOCM2nR1GCkn2NCYB8hfz0AmxpOkV4Aa85bM39rroN+XAOcWEIui3fvZtanl3lXcd6NAM2ULL+ydgF6lCyCHVEELRJspMlOyhZAiUmctQRj0c5tTDP9Gbk+1dQzZy/oCz8kDpSj5ex/388MugdvyNRZkuc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 14 2025, Pasha Tatashin wrote:

> Currently, Kexec Handover must be explicitly enabled via the kernel
> command line parameter `kho=on`.
>
> For workloads that rely on KHO as a foundational requirement (such as
> the upcoming Live Update Orchestrator), requiring an explicit boot
> parameter adds redundant configuration steps.
>
> Introduce CONFIG_KEXEC_HANDOVER_ENABLE_DEFAULT. When selected, KHO
> defaults to enabled. This is equivalent to passing kho=on at boot.
> The behavior can still be disabled at runtime by passing kho=off.
>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

