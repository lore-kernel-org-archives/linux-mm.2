Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81E52C4452B
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 18:13:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59BD56B0096; Tue, 21 Jul 2026 14:13:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54C3D6B0098; Tue, 21 Jul 2026 14:13:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48A126B009B; Tue, 21 Jul 2026 14:13:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1CAAB6B0096
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:13:50 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7F565C0267
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 18:13:49 +0000 (UTC)
X-FDA: 85013582178.25.96CD78B
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf23.hostedemail.com (Postfix) with ESMTP id 85E4614000D
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 18:13:47 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=AFG+8oMq;
	spf=pass (imf23.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784657627;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LSfkR1e/dR8kqPxQlWrl73BK+AJy0HI9oL3YLggpuKk=;
	b=jwopdwJSwdjtsa4MzL6AWc0qD9/sxWy/nO4CVWlGsAztyO2e5p1xyq5rAAZS+UQQFKHfCJ
	rsW0m4of2V9FDS6rQaxBQmcb90XOk7UHafzsZeBhNXm8zPFll2cwFpAl58doxBjI7A8BsT
	YoVK9sfvZm60AAm2JhoyO4vTlBpX4f8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=AFG+8oMq;
	spf=pass (imf23.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784657627;
	b=s4O1pYb/Hs5X58rEjGjPKCuV3xCCHpNkUjv1QlQy2gaRZRdH3KoK7JIf3vb1Q3EYzMrdvw
	G7YBe7Dfl92e8XdvUjMGQpnxTdihlhWiDvMHG0Nllva821edEB2olRtX3+Qg7FgfcHIqlH
	f4Y2PK1UwNWnHwsBWZbrh6jj2VqMZBY=
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 04AB040E00C3;
	Tue, 21 Jul 2026 18:13:45 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id WAgM4pQygBNu; Tue, 21 Jul 2026 18:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1784657615; bh=LSfkR1e/dR8kqPxQlWrl73BK+AJy0HI9oL3YLggpuKk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AFG+8oMqJ6CM22RRudRv/nXdW5UuYrbU46fmTTZlALzETNNr9CwP4cZbj+QgQOxkh
	 9hw+oXsWm5DhTcDpNXuGs/YaK9pFU0L9TIXnkESUOmFRlNIcTGyk6+nDFaRzeg1Qmp
	 dzgEU5UiguZUOojfrsjzaGNbEZOZa2HT5ih8y5OM13Pnl0VYhYin8b2Nkpny3l/u2C
	 rktizLJ48mqBMrjD8CFdkklVH8Q3inF4tCYFexQKghkl3miTHh7yAlOZoTNfIJ55id
	 UlpSM6QZM3uOCg63I8/rTdWRN0gwZNPl8Nrnic0062Bx+A8JsZIEQocUyMj3Y4nikl
	 9owLsJzseUxstriow0FasdINPHKxavLfkxW9UsQ6EaXH3XvNMZGsHBzvUfMR0SrgQN
	 SJDtzRl9sZzag3zbCFNbDZJH/qEn8zG2oa/llXQCN6PMmBoF9ru6EQ28SR7baXL/jE
	 MfLjcKh+7rqtWDuo86Rz25IvPKUyjsexNDvlecm56E2jpambnMRwBgPM0iWYUPqZvt
	 cnMGp0GyLIhZNJShDQ4F+iLCCuqIYfJpSBPMxgw0qFnOusN2uaJyCjPdf6jwdpiSbQ
	 ya1WUb+rjROSj2Rc/tDGNBbURH+R5lNWBMyqNlt8aGTp9ehn28FLWJ+ee1oEcq/8gw
	 MH8GvTKPSj6o5/oBONJ9AO3Y=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::2b])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 690BE40E00E6;
	Tue, 21 Jul 2026 18:13:19 +0000 (UTC)
Date: Tue, 21 Jul 2026 11:13:16 -0700
From: Borislav Petkov <bp@alien8.de>
To: Ihor Solodrai <ihor.solodrai@linux.dev>
Cc: Dave Hansen <dave.hansen@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Andrey Konovalov <andreyknvl@gmail.com>, bpf@vger.kernel.org,
	kernel-team@meta.com, kasan-dev@googlegroups.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 0/5] x86/cpu: Refactor identify_cpu()
Message-ID: <20260721181316.GFal-2vGmvOGqbq8mW@fat_crate.local>
References: <20260704002046.3859585-1-ihor.solodrai@linux.dev>
 <7c79eb26-0986-41c8-a5f9-5911a2e71175@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <7c79eb26-0986-41c8-a5f9-5911a2e71175@linux.dev>
X-Rspamd-Queue-Id: 85E4614000D
X-Rspam-User: 
X-Stat-Signature: q35rsswsbxcuhi3zgi9g1tdmy3mph5bh
X-Rspamd-Server: rspam04
X-HE-Tag: 1784657627-552498
X-HE-Meta: U2FsdGVkX18yoiLPffmKfaSmX9DlfTaLK1sVowYUjCi/YOtFtOyCAQYSaKGbokA1za3puXKpn2OKU8Uwq+Ggse2KD3zKaoR/3THBGu3WzO3sZSFyJt7tVlOy8S0EoS5PDhubUe9QvepH+a2OhmGMeV3wxeW0ic1SZ76RCb7HfFXsOjv6BDzQ8ei8DWwKr1NytVyiJp9hbXECXkO2G8ayIN2M2ZBM76iBNPOn5yvENV9uWYvQt9czCHcoCrI+0tHpRz4nKk1/dodkn4hXaYIjsYSMvMUtde+9cDI7I2yk7T0vfGMpvaENnFh4LeKmeEvETKAMUDs+kXWnm/fHXJfmMBccFsEbR4BuEOCEDQuLzXhevZR0cqCr5LSZIHAy9HIGIyFUA4tQyVQXdzT+KG2EgnUR/8tApMML47lRaqrmfsHEMPnnXglH90bIszzn62Foq+UuPjKxQVXFefROjnJmWyu+Ru7cFbk4JABDzuzOE6IxldVfuhznuizNnLwNfJLrP2b9ZuvBd1x3qNhE2iwcsLwQUHfxYT0/UJy2g5Zz1OK1RObfuCOZHLO6GshDoWGC4e40OReUAIqAXq8Urh9flE7Pso8oNgDP9aAV1ySAMyDfACO+3cOTzA/cOKSMp5RUQkuTPihUk4jqJKACZsDNZAgnkysKiIAUOhPuSd9jGuZP5x8Q67X5jxK+9iS29MapO+O8Q4eBRNCbfnMFrt9k/IEiD/8+eoB3+ur2T0X/nk4qSnYWv8cskwIbAdhuvY9qNVFPVGmfuNBQERf2Ecjq/sLNxvAnhVYKBOiKMpFp88SmdUvgNd+OhuxlBdP8A2ovD0hRpfYcWe7+V++ed0bvqvWOqrd/TMChfK8vNDUJMCagvBbnJEGU18QNzCHZ52GClbOqS5ubR2HBFmg6AzAkmFhtKBvN0Si/Ai/C10POAJhmCHJ9drOIeQ7gb421Frs6zlIy8fx+ggYlEHtVCrY
 9jsWJ3VP
 PlMaFplQD8X2jKcQtVkfAXCWZU9e2SOOqmKdwiSiza3ZST3pkZjr/9aTR6f36yVFOdwVXa9oDUxa6ttXBXV/SH5svL12oXQb6tr7V/2gnB3wCegTQjYDEL9C9MmGourfOrT1wtW4idUurDCNp9esGbbIXMZuFyJePBKBNGlJt2I76jRafknLqEVCsjCyPvmL7thWvf7ZQ50hykjp5Odk/2rkUAWtpK/cZ63fkn4/78Z+0HV3N/2biAVDj85XXPP2c7fLF44GNzyCThO5qqS5WDGhqk/4LIPE6WQAcfRYyJfRZbIR6S84G0nDREnLmSSjcWUWehwZTqmfZUJFdL3JRHHRcSz62TLmDGvcuCob+LK5WkCcBJVg2MavKj9ov8PurfpY8HTZtTqUY4NdZnTqdHQlxed082IxqJlsG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 21, 2026 at 10:23:25AM -0700, Ihor Solodrai wrote:
> Bumping the thread as it's been a couple of weeks.

You don't have to - it is on the TODO list.

> Please take a look when you get a chance. Thanks!

There's this thing called fires which need to be handled yesterday and we're
all drowning in them. So yeah, I know, but pls be patient.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

