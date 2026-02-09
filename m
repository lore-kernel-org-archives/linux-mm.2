Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F20CBE81BD3
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 15:31:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D3E56B0098; Mon,  9 Feb 2026 10:31:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A4A36B009E; Mon,  9 Feb 2026 10:31:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29D6B6B009F; Mon,  9 Feb 2026 10:31:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1B43D6B0098
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 10:31:26 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E2084139813
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 15:31:25 +0000 (UTC)
X-FDA: 84425307330.05.E7F8323
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id DE134C0018
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 15:31:23 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mZ3eeO11;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770651083;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WvjH4te4K5QrtEX1LrPlb0ORwoSqRJGo6cXSgpf/Q4A=;
	b=N0Wk0HQYEwpIhZpUS6wzvLDY2xpQoJ226qrHsVDCuK98bFuB8918INwH2w1xBW2Cs9TjHb
	mTUGoLd6xMsiPJkxwPZjRrDG0cOXmIq8cYISc4dtbOjwBFz+vkKILmrDLcHvrKAM5MDUmI
	pU65P1sS5eOPWdW5AsO6G02ZA4W2bTQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mZ3eeO11;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770651083; a=rsa-sha256;
	cv=none;
	b=w3G7IVg4KWMXgc2Gybk0y76I8Y1Xye8rTFr9yDEFDGrDvZcwj9DKeQWhquUbTv1rKjmcVn
	mDSI/TKnTgbOKi1f/LMscyad5RIzVUgG4Adc2u1lbk2Lon9Zkxc3oLR1ByqVbwbNvQyNbp
	VdsCqUeZdAsRwzUxSGN3ZansZJAmmO8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 39CA060008;
	Mon,  9 Feb 2026 15:31:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA6D7C116C6;
	Mon,  9 Feb 2026 15:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770651082;
	bh=RxzDyEjlTagEAtrPHYYasNPmARDPY4JPQgRHJpvLkVk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=mZ3eeO11D/oUQS5v/btfeH+KWSUiDv716YAlCn9LG2lty+rSDU7bVaDkiy2gsYbOc
	 tb7t9bCUReDJg0aSKPdg6GDM4sIKmfN3JmSszRhtnEwwYou3j81zWwrsUVmezU6QZG
	 9lVKlgakyr7WUWz+DNZB5R+9i9S3OHB3jUaWsdDowDqUv6/EISKW7HFFbAjnqwEe6d
	 X6oDyTDHUz3gfJpDZJzPwXA+IUFh77CV8pnlEySdq5U8dreLDebPt+iHr6SKMtMcBK
	 yKjq8uYdG03BfvkCR8MGJTmcaCExoQ02SlTgoH98wSKLPMUxTLTm2XyNs2nDcHEpE0
	 QTAqgbBxufOHA==
Message-ID: <9b7afb6a-b709-4b42-a4dc-fa12c2ca624c@kernel.org>
Date: Mon, 9 Feb 2026 16:31:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 5/5] mm: rmap: support batched unmapping for file large
 folios
To: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org,
 catalin.marinas@arm.com, will@kernel.org
Cc: lorenzo.stoakes@oracle.com, ryan.roberts@arm.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, riel@surriel.com, harry.yoo@oracle.com, jannh@google.com,
 willy@infradead.org, baohua@kernel.org, dev.jain@arm.com,
 linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
References: <cover.1770645603.git.baolin.wang@linux.alibaba.com>
 <b53a16f67c93a3fe65e78092069ad135edf00eff.1770645603.git.baolin.wang@linux.alibaba.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <b53a16f67c93a3fe65e78092069ad135edf00eff.1770645603.git.baolin.wang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DE134C0018
X-Stat-Signature: pan5jebfxps816zdx6gn6sur83dcoeob
X-Rspam-User: 
X-HE-Tag: 1770651083-252148
X-HE-Meta: U2FsdGVkX18jgMyhUbaNvY67Gw17Ufk+a1T2YX+vlGMHwz51eL89JNRRxFt/EKUwLhFiHqIf7LZX7LCtuoDi1cjUCktFo+P0eAOoA2L997V8DUuamztzCemC64OBzIzWEwSw1Ws7nxv4YnbsqNhb1AlZFUI5+kYcMXpowe4Fyyi8Ipl3DikmWCWwZNYzazxpTGZY1HhsnTgmYsucnohKRx1BR2uT8cZaCjrBafue35AfYxCL+KMHvwY6bCqilb6xpjTCL9UVUzfzjVJEG7nBwcMiVWtW6RSP9POwwnJD6CafOI8oY3qCGxw9i4zRLFTw2aQT6wzkV7t6YS+4TVOOwzcmBojPcMfDcIKoIpsWxJoKp2jjlG2d2HEWDMku6d+oB+hHJf7FEqi1vlGnm7IfHVwh8oCx0K2gyX5wKLNWVV2n7DamF2GhGwLvL0qljTP2Rp32pRaQhIv3bO5oaVkq8SdoIFVnz6Z1I2CNpPAfLEUBB2bXJSWuukT//Y0hO2hdaopvBL4c9qGm1McZohG+KkqxYkeubJatojYp/F/nAmz4BwW3r62RUhxLa31EaOYN/T0+re12BAdQao9c5Jyv4iERlSw5X235Bt9WnY6Agr7r2Zue/feqw3Gc9ojYdLOMFNoG3ItldtJb6D9POjgI9ewF+E74oeBv7mS48Fu0FjeBzAEKZdGL3vmYKfODgHxsC4fV42No3KcxYL2uamxC8tteTHGNZ9hLqDirAuumGXZT0NEldo163Osw04rjDLe1zQPVoenmPr62mGwyzNwKhz79fD3fYIpSdUqUS0moqlXdpcvs9KOG1e5YSPHOrX4C5C9OqgoeS0mN3It8MlJM3V9ntT5AC90KQcAk1PkBCkloHf17+ah17CgIO+yf7sScDB1rs3/54UVq0BuaTzoee43bJ1BF2OEkoEXdrZIM9FfjIig3BaICaM+5xn1pLD2y7Z7X7VQllarvGwW2f8V
 TdyL2ARh
 7Lw9aB4Wo+6yZdNzL0IcKBDT38oegkhMq4KBp3azgvz0x7XVVTwb0rpU+MEdYM09zWYx8ytwBIE0sHUxw1gRsUrgRe8CyrLOPRtNjPeEIhzMzBquHKna4v9GPSdv/+8E1+XvM2PY+Cm8qrdyAKJBzlYSzqJm6+7pO4hBdZ1A3p+pJsLMINueMYMSJUQGEFKMC8iHE3ygAYnG8d25vx46/lZ398LA1wAEdOJtj95MQ+aO469EXtP5kPiFLj4wOOUvB2kaJde9oSXKSoiWU7a42JXlrMD2OOaPXDH7xnTaM+YbEbeRdd4aHeu5S4FBbR0a1ug81WlbQxa1hsaUfS4WXR9wWvUj3KKiTwwz9KRg346/GBLU9+4OAYIdWs8AALooPXWRwk0WxTmIISvBuoGoCMQ7epCMgW83U+vhU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/9/26 15:07, Baolin Wang wrote:
> Similar to folio_referenced_one(), we can apply batched unmapping for file
> large folios to optimize the performance of file folios reclamation.
> 
> Barry previously implemented batched unmapping for lazyfree anonymous large
> folios[1] and did not further optimize anonymous large folios or file-backed
> large folios at that stage. As for file-backed large folios, the batched
> unmapping support is relatively straightforward, as we only need to clear
> the consecutive (present) PTE entries for file-backed large folios.
> 
> Note that it's not ready to support batched unmapping for uffd case, so
> let's still fallback to per-page unmapping for the uffd case.
> 
> Performance testing:
> Allocate 10G clean file-backed folios by mmap() in a memory cgroup, and try to
> reclaim 8G file-backed folios via the memory.reclaim interface. I can observe
> 75% performance improvement on my Arm64 32-core server (and 50%+ improvement
> on my X86 machine) with this patch.
> 
> W/o patch:
> real    0m1.018s
> user    0m0.000s
> sys     0m1.018s
> 
> W/ patch:
> real	0m0.249s
> user	0m0.000s
> sys	0m0.249s
> 
> [1] https://lore.kernel.org/all/20250214093015.51024-4-21cnbao@gmail.com/T/#u
> Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
> Acked-by: Barry Song <baohua@kernel.org>
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

