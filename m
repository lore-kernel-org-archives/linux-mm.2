Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 166DECD98D0
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 19:10:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 746178E0008; Thu, 13 Nov 2025 14:10:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71D788E0002; Thu, 13 Nov 2025 14:10:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65ACF8E0008; Thu, 13 Nov 2025 14:10:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 561468E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 14:10:44 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DC8EA140AB5
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 19:10:43 +0000 (UTC)
X-FDA: 84106525566.28.9AEC75B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 168F0A000F
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 19:10:41 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=R3toaTeL;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763061042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dVLak4XaFtchH8QAE6U9cH84f+blw9BDT98kAUa2+AE=;
	b=cxSImQANqIKO3FS3/s6ky7zZ05Co3quc0kv4fTAo7ArewJ6eE82QlcDv/1Ylnb/QqVWJsa
	bkIfOK6DcMkWvvtsyxCGDa+dMXh7+zGkwXxJ7UV/sDVFV/3SyNbni8vyvUpLUHtaeaKetU
	gSJzYeTylgyIcSdvNqUmJbBptxJZvQI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=R3toaTeL;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763061042; a=rsa-sha256;
	cv=none;
	b=Ejqit7S9T5rgX48JiMaJa8LjZUs1CgOVnT+DpTK+IEcfJoyZyCLvGdhE4rScLLHaAIDi9O
	J08I2/YWSeYXaE00gHYGIA+WOZTEXUU3W5aGH08usyG3sPURh6ci9CkLuEr8PoFphA28gJ
	Sc8VoKvWmmRWlqr24ZLrdjR4vQIaZcs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 19FDA4061F;
	Thu, 13 Nov 2025 19:10:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2347CC4CEF1;
	Thu, 13 Nov 2025 19:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763061040;
	bh=44TFkluQ8NjYkM/UonfvdyIjixH2154CCmS8Jt4lT68=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=R3toaTeLMEp1d+NiFs6A+mAY1QvXx6w8f3DWOLVS/1Maj4RyEyaI5L5hN7YTyPF1r
	 h9/gJnDm459DS/Gtg/XeJaLhWgMeRLqXpKO4Am6wfK3HgR4bQiPeky/lIH+Etx/T2g
	 /AflA7CydDfqNxJv1TsKtJV4AQE/KWXmEUEeXlgPv4q4qa+5pxYXsBGRu8S9RnKhNU
	 A2RqgauhajKhHy6HUToubqfxEOYUdPdK8CwTC2hVKKG5+XtBC5WvBmwudvJyoIL0VM
	 sRQi9XZ8z9NLL1aDBRjzrOW3qboZSkFNBjF/E8SmOAg9BjFBoU8h51AoHQNur3kYlo
	 aYtC+RKaddxSQ==
Message-ID: <0898b3ab-ae9a-49c8-a026-b9dac50e38c9@kernel.org>
Date: Thu, 13 Nov 2025 20:10:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 04/22] perf/events: replace READ_ONCE() with standard
 page table accessors
To: Samuel Holland <samuel.holland@sifive.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
 linux-riscv@lists.infradead.org, Andrew Morton <akpm@linux-foundation.org>,
 linux-mm@kvack.org
Cc: devicetree@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
 linux-kernel@vger.kernel.org, Mike Rapoport <rppt@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Conor Dooley <conor@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Alexandre Ghiti <alex@ghiti.fr>,
 Emil Renner Berthing <kernel@esmil.dk>, Rob Herring <robh+dt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Anshuman Khandual <anshuman.khandual@arm.com>,
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, linux-perf-users@vger.kernel.org
References: <20251113014656.2605447-1-samuel.holland@sifive.com>
 <20251113014656.2605447-5-samuel.holland@sifive.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251113014656.2605447-5-samuel.holland@sifive.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 168F0A000F
X-Stat-Signature: yk939kfjztbfju8zkonnxhs4s8rwb43t
X-Rspam-User: 
X-HE-Tag: 1763061041-930598
X-HE-Meta: U2FsdGVkX1/W/vH5chaVNTBSUI7WMcK8odFYmYUG43J8xZKXw06cKYfOJe3OAv0u/AsYPsCH428P2fuGErbjbNjm0lHIfKah+lNBJRbihn13sCr8iD/fG37N7yqSqkenMh7EYmg+NIV/fqA0CuV8FCMjameGowguPamY6iYQ3YjQlHWuLTGDpdY8RkxZ1mJ8I8qcuEnfcT/yyIEbYFSjO7zV431wwd9fjd8icrYrMqCWhMG+EHOUMhKuD9laT/PMDwI3xjERi7C5MwhpnWX2sEKsxxjaD5e/4up90dXewLxiOoB3Z35SabpJtWoBzYIIwKzPXtuqWiKnZNE1cQZsPWH3E7Rkvnop/gAF/sLRLpKLj7mpIP+PF7Y30qOdC5Mzyt71ZfC/Q8YyGIRbBEzd6gyOtGIwsiHtCDnOYn0N0reSBbJTjJUHCVJGhTpKGwG2oepo6vgJ4PnnK+VER2qCmGqW3IbfSLoJln3WgvFzrvY2k8Tcq3cZvIJaVhaRywSzVCYQrH07j4w0iMS/J9Vy2nMBG+5BAz1NlQPrg/cGsLuBR/mxcwxdxhYFQEnOhz3498gSKT3Q4uqxpG4+65ixDDGmV+Uel3oKXxGjaVrEPoGD2m+uS1fWj3XEpVYnLRV/BlcusMUGdvb2oMg8CL7jn5ewmevqDoXBxcwts37WoVPnXmDyOhm1712xXg6da2HdE2xs0o6yo07KK/n1FVItA5OoM/zGmuO2p2GB/gUT2NkTmT5EgOx+1El7lyrpXrWIQjYVNaMI7/jZxSArc4wffez7y3d5heWesEFigJ6r23p9659A+5/BHBSj6eE0Sql73y0Yl/hrsxAUXkwUm5TwYoLBc6RV80miBtat/cvUZexlbBPda+e31AYci+npAh1RNx7nrGCdC/eV5BHMF5UGBm3hKzihwVS/E9Uwn90hMMvlO2hJ2O/hCTpPsh6Ms045JABJJx/chdws3JNsoNf
 YLnaRlrq
 X1gaELwBsWHQTmWemfVappH9M3I2CQ2XnE/QhBhVcmR5P/3cRAvJUVQ+N4pYqRcoeSjTNjub9AflAbY/z4O5Wz5SsxPKr6M7P1i5x5q9l34EVhZ4LpY23i7euQMRaB8OT/dCOdrIjD8o64pIRZwLWaLK8oSISDSZbKV1Ueb2V8QEKhM0hCiITRwscBXvfmpc65SxqjItV8uXcTW9h1tiPNhbw1NYhyWgjhEX3hRMyR52xI21S8nr9a3GjX6N1T+blVvs8QZowerwiOEHl/a7MTwxPVU1+XhpGFwhjO5tq0zVj4wbT/lmisFJJJornRwJ0t32yyZkeVIR1n8sS1p1co17Y5efH3FDkMqMQc38i0QW1S4J6tOtB4ZU0qDUVAsrYBLwz64h8wqmB8P+Q1SKBNpP+A1Iwdxg4MBzOT61bYZfKILyePOsYanamQ7op+RT7eOqJzskOnb3BnaDOPtFSQvuPGCINyqg8jMUXXNwEowv3yIaWf1ltCd/sO4vdRwpCyzqG9BSWpc0gCH7qZgyigmbb2fE3MIBpsiYsEllt2ZEzXZwrdCl7IAQWcQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 13.11.25 02:45, Samuel Holland wrote:
> From: Anshuman Khandual <anshuman.khandual@arm.com>
> 
> Replace READ_ONCE() with standard page table accessors i.e pxdp_get() which
> anyways default into READ_ONCE() in cases where platform does not override.
> 
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: linux-perf-users@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> Link: https://lore.kernel.org/r/20251006042622.1743675-1-anshuman.khandual@arm.com/
> Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
> ---

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

