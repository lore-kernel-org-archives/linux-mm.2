Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B591D43354
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 20:41:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9306A6B0005; Thu, 11 Dec 2025 15:41:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B9D66B0006; Thu, 11 Dec 2025 15:41:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A89D6B0007; Thu, 11 Dec 2025 15:41:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 62FB66B0005
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 15:41:28 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 02F845876C
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 20:41:27 +0000 (UTC)
X-FDA: 84208360656.04.9567E4D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 54A8AC000C
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 20:41:26 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=MjjtP+Wg;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765485686; a=rsa-sha256;
	cv=none;
	b=r7ZFznVoyAXXhcDjElP8w5lZHcuB3FOrpADu5GYrLeNpPHsisNeJCZEhra1xyiYxlwMWCX
	lFSbbUUVKpvh3ylcC/Zm96YDBHPwPQ417MROQldK//86npnenhgU/Mp9CXsF1Az3QG8FQ+
	6v6jZjDjsecQVBladvnoSW2CzSdupKo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=MjjtP+Wg;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765485686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3u0TgATSXa4sW3PhBUQ6rILAe88e+XdQQOx8xYIe0JU=;
	b=UgFdatb5tERluedEcUP7cbHBbmGMsexO1trEtUwykq1OEQz9GKD/9o1NxWouP4fVamWBbc
	cUv1hCH0pXCjufboroaGV10TqdpZ7xKHHRgu4Pic9+muONgGuKx/SdGfZd1GaoJRJgu2NW
	4CPBDuFNfskjEkVTmYcKHk9CTxx4YeY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 84723601AE;
	Thu, 11 Dec 2025 20:41:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EAC5C4CEF7;
	Thu, 11 Dec 2025 20:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765485685;
	bh=3u0TgATSXa4sW3PhBUQ6rILAe88e+XdQQOx8xYIe0JU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=MjjtP+WgfE5GEh5og6G/4fIGfTCh1bclvAyRwRRt5skB8bSmrj9oYI0QZIeu3YvXn
	 IEjwxa1l1zHfth/ym+1VIqVq1GAdG6xy3TFSrjAW4Nb5fQQDpoiL5MU22U8PCkerv9
	 6Ahh6qyqK8IdSrJ5k9+HyG7u2TJJ1MrmVvmceN1I=
Date: Thu, 11 Dec 2025 12:41:24 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Uladzislau Rezki <urezki@gmail.com>
Subject: Re: [PATCH] mm/vmalloc: request large order pages from buddy
 allocator
Message-Id: <20251211124124.a0a6786e6ceaede178cc8b30@linux-foundation.org>
In-Reply-To: <d108a8ce-8919-459d-aeca-dfa75cab54e7@arm.com>
References: <20251021194455.33351-2-vishal.moola@gmail.com>
	<66919a28-bc81-49c9-b68f-dd7c73395a0d@arm.com>
	<aTn0FZig5a_DpTJg@fedora>
	<d108a8ce-8919-459d-aeca-dfa75cab54e7@arm.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 54A8AC000C
X-Stat-Signature: sayf1eqcmrnxqef73yfssg4e65gg74cd
X-Rspam-User: 
X-HE-Tag: 1765485686-405673
X-HE-Meta: U2FsdGVkX18htkf7ldsfC29NzYcfZP9tQemParnSkL4F7piQ/V4vhl9UcoiXH0PpHkZSBPRwOKWtGCp/swZp4T6uwfw2Dfnb5Sdo5d83wRv/pHRdXk/9UjytcGKr0yELcluxgSCrNjyP9+o9vK1EVJ+0aaL4V+/D3jSErjhniw62JV7LtOeccwfDKmC/JnWB0hiKdSdFfTYpVMG1cV96LJHex1LOCTDGKnf8u1g9UEE9DQUSr/7CfFcZ+ODvwmhjTdhJIIXrGz7blS1FbjeIuK9E6lgIb2SVw3bN76xm9gshvb9EDi72UJfFIdDKjDl4m9zRg7kYXbGJo2o1j2KoMc8TJGzRS9pDFKQH/6A4PQzNTLVIkzBoJ/4ZqNjHu8vacXxn1tZpvComytsD56SsIOB/StDwqSCJEIt7guvEx3Ol1U9tTrs73iM8j0H14rKeP/F/8jtWdjf2BaAl00tUw2E76X/NAvwEBvcbhyF5+0mmCFf32yf9CRRJQEX3ZvrwSXAIEOHHxwXR9xTJ0c8wvKuyQrLnsNxfJGg8on7+Sil0k1/9vld/Gm5dF06aMBYphyZGgn8aqkL311vaPU913Jhw/0fn/cQ0bAgHA2mtmUzjEh+hWC3WiMCFT9EG9apZqG/Mvp13UMR5zKZhL88/Sg2yNdFXeOR0vSsVY5B/xDceJurPVfaKMzmz5i9QG8tlROERPeYd1vgLQ8XWz8/VTNrfm5uItK9Emt/PRK1DZsFGNVyhDb1zGDdchqtvmurX8bExC+uWuV53KNxAdUcT/bEF2o5JRK9zRr6xogeDwuV+0dUO82o20VTGqSVmw8yIGB7oXvo3gTA1+3U3SBktqSR9cA09rlJhFtI3cGi4gjzX6oHVRiin0LrgU7j1XbRLMpwM6ho6lfAobMK5xPp3zcBYKh20aTDfCLuwpjzDrmIcmVsqLMUh6kvSZh/VP2nKVrtI9rxSNc2//gwTmWo
 5/rFOpXP
 rzgJstfBfLwmdq7lCbCg1KcIp2iwwneSnYbxRS+ncfFUR6j72TENdxfPKjhFGGPD+Aw5zmShPOy+QD6h91A4UHMNtC/wSuXOVdbW2P4Ej/9PM/rNDBZVswO+eKtwRuadwcIRSPYRraaRW6sp0W13PDueQzRO5c4G0/yICtyUSFK4Yn4UAx6filRGami0aPs6omINFC2XQHkmH4ecNo/zNhefkNH5TeUPdYasisBlDc16NLN6QNn8qiKF2tNmIP3RJwys/IYKGWjgFxxUnmS7zCB8IVQrqM2/H43QbxvOqKVR0aLq+BKkD9GT4MBZT/Ybw9R99dDLG1iUwNxxfrQIOH68uuOLQj3U8jhGTrZ4h4Bwe5V9jTizUbfYiEMOhaIXt3T42OV565fv0wA/2NY1gdtSFQg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 11 Dec 2025 15:28:56 +0000 Ryan Roberts <ryan.roberts@arm.com> wrote:

> We are seeing a bunch of other regressions in higher level benchmarks too; but
> haven't yet concluded what's causing those. I'll report back if this patch looks
> connected.

Pretty please, would it be possible to do this testing *before* everything
hits mainline?

: From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
: Subject: mm/vmalloc: request large order pages from buddy allocator
: Date: Tue, 21 Oct 2025 12:44:56 -0700

Thanks.

