Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 056BBCDE00D
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 10:43:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E72EF6B00DF; Thu, 25 Jun 2026 06:43:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E241C6B00E0; Thu, 25 Jun 2026 06:43:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3A6B6B00E1; Thu, 25 Jun 2026 06:43:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AD2106B00DF
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 06:43:45 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 339DC1675C0
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 10:43:45 +0000 (UTC)
X-FDA: 84918099210.17.FDF0D70
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 852DF40004
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 10:43:43 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jnsQuBr+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782384223;
	b=cmUDbF1Qf2ra9Np7f0pPBf/1T87wdx/pSfDcv3kZoDu04DZPSFOLW8R526d9rG8E2kZXzi
	e4giADLApnAcCFTQUVQvsyczEST+Df809RHZ3VQPAxXKxNOiVeiNFtU+jUaP46UZC+Rowc
	Rb6Fuq9s9hBeTasiItWj32mc15cGQwE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782384223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fJDvuQiOU7JiXyJC2kg1d3dB5krLdnpqD440e2m3J7M=;
	b=AzcYW88wX0Tif2raXJ+F9WSP7cJ9emvaM01KOJaY5z6A78DpDxh7uklI1HTEeyrvmFh8Yb
	7+6HbF9JApIV6S95cINRP/bLEFACjXBR/jbHbO7+idI8kOVX8Hh1SuQTU9qeL329iuXwrc
	fdrA7clQLRud7xAscS/I50NWeEKvrUA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jnsQuBr+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0D15E600FC;
	Thu, 25 Jun 2026 10:43:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D178F1F000E9;
	Thu, 25 Jun 2026 10:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782384222;
	bh=fJDvuQiOU7JiXyJC2kg1d3dB5krLdnpqD440e2m3J7M=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=jnsQuBr+FAdh41iDC8stOiyep9XSEBAAUZTGvLkfm4ut7GFRat1rnCO7lYWbNsKDO
	 nswSbhoAmx/TlD+Qs/7DWmpA2joVbUm9xpnc18US0MnJUXEfTWbJW8qbbYRzqnnzyD
	 sIXgEQlg7VTvKzVWGAqf2j0xh+yYuwp3NEsZZus2jmUgYzwus9doqhn86aohEjX/dX
	 DIhzhdXGKLDqCrG5WWRJUxlsjregwEDXAZJKWiSQO/itZrtYWAbcS/g2IXg4TtjbxQ
	 5wkVh22fQLFWrn3RLwHuetGqbeMPuHHdc4cXJVruGOvxDIk0V5C8W9q8EH3DIj8npN
	 cUeXfa59mxJmQ==
Message-ID: <ee0645f9-f55f-4747-a2bd-99cb757358b9@kernel.org>
Date: Thu, 25 Jun 2026 12:43:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] mm/mm_init: drop overlap_memmap_init()
To: Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Taku Izumi <izumi.taku@jp.fujitsu.com>, Wei Yang
 <richard.weiyang@gmail.com>, Yuan Liu <yuan1.liu@intel.com>,
 linux-kernel@vger.kernel.org
References: <20260625073941.145014-1-rppt@kernel.org>
 <20260625073941.145014-3-rppt@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260625073941.145014-3-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 852DF40004
X-Rspam-User: 
X-Stat-Signature: m1an1zqnhz39cjcca43dkaxwz3dezo74
X-HE-Tag: 1782384223-742249
X-HE-Meta: U2FsdGVkX18kiouhAWcE2LIcu7s2nzcJsWDonVTPCtoIGpEbNvGgOAIBveEXTN1xd4QXv4eVH0cRP/3wMriSz9xek/iFlkQg+IgFtONFkRViSMJxmx1oj8DBZpJrpgdmHXvtiJy8XJiqze5tUIYyBdqEKELt7jcoXi3jPi20SgBL9fXpLwx5LNUj2CTXj948n8Basf4xxDMcj9F2H0Tyb1arc6AY7Zc48MnI9/YQWo9xsYOrxWGNaBFUBErku0wZb73MDN/+XRJVYWaXE6AlOcpzn65yfqI048yvGcCCl1Ue0qC3eFkoocB9wVBWHHeipke+4oS/mqKArDMbfGLUxlGrBNZzz0lXrnn7CNbNZs1S4lSEiJLzCs1Zr8JxG3bOhsz+EQVxhbLuADi3eHm7TEp1I63FUJuwPU8B4IGv4HNxJrpHJsNkuyEEg3+QM6bu+Kl+dLXLOcal2/2QXYl6LYWTJMdQDSRHKY9e+S4/6QcXwCHIijpDmVykhH30xyP5UBDunMuhK+uv8I7cLTlqVhMyXpQB6vpKAFVl1b2AYzeyTJJCTKaFyUGpDwkYsc2H0lut0YA6myxItIBIUi5JKEjZQ5ReNpa7YPQvXVtcEOKf9lOrZJTm7l+QeNq0UHNK1raexmth25JQylKqLqtRsMuf6lVng2w5tOdOXDeViVoIuYsb1UdL6kKbtI5I/o9EVy7t8NEfgUcSM27x84XBCZw4EvuF7UQXZzZpo2gJ2L4qmqyxpNtXWUFgeRDawt5P1t5PnSowT6Ji4mo1l2bNA+g/foPRK0su17uEc/2/UgbK5ZJHfwd70ni3zPUieuvoSCe5E9iJpH4xqLM7Svy9YypALUiWr1rlKAFY48N87Z7gB4TGvXTX3HqyKs+//lHAGVk8cKZvH2jQ124tA53fGxxTCgqSprk7qC7TqY+0QE9LhGaHamoNANBfs8JJQgAk6AuNT1eLXWGgtjUsh8R
 uOm4qB8y
 sv/EOGmhi3jVHM2TsTWnR14oOu62SeTLY+Aiime7sa3hmKYD2oiGZgIuWjRgwzzQfVRxbuAN35LQ9I2rcmUMSfx87vBh9Sspok8HYOTFsqdu0kvRpvn+BZpyKKP8xBp3BolW/p6uVDu0TnIWvXJ2SeEi2XpAblkhO5b/SnUPRL2MyPI+u1j3nfBz+a069A71kb//ddySk3kat2oLNOwnPp+SGp3pmw2kwFo1SWydjXr4ctpc5+sZWpqAH10/0K/vkMWnWjXynoMmB1gB3jZN0mnFWS0rtpatAHCjfWArytGD6HWi90dsptH3g2aujZ4IOasYIte9UaAk8XKUNsGwkxGgkpsNfFXhBA2J3QFK+R6QImjd4/2kW3VztcWpM9fdQiNf8a/2mH+mAEHzAOR/uDIv13tf9undtQfvhDk7dwRLnVrjxNaGh8DkLbadpt0bHgyvTmQsilbfgARs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/25/26 09:39, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> When ZONE_NORMAL and ZONE_MOVABLE could overlap because kernelcore=mirror
> didn't reduce the span of ZONE_NORMAL, initialization of the memory map had
> to skip overlapping pages during initialization of ZONE_MOVABLE to avoid
> double initialization of the same struct pages.
> 
> Since kernelcore=mirror works now the same way as other variants of
> kernelcore=/movablecore=, and adjusts the span of ZONE_NORMAL, there can't
> be an overlap between ZONE_NORMAL and ZONE_MOVABLE.
> 
> Remove overlap_memmap_init().
> 
> Co-developed-by: Wei Yang <richard.weiyang@gmail.com>
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

