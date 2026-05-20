Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E411ECD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 12:06:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 353036B008A; Wed, 20 May 2026 08:06:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32A0B6B008C; Wed, 20 May 2026 08:06:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2670F6B0092; Wed, 20 May 2026 08:06:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 14A336B008A
	for <linux-mm@kvack.org>; Wed, 20 May 2026 08:06:45 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B0CC8C1639
	for <linux-mm@kvack.org>; Wed, 20 May 2026 12:06:44 +0000 (UTC)
X-FDA: 84787671528.26.84DA8EA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1414B18000E
	for <linux-mm@kvack.org>; Wed, 20 May 2026 12:06:42 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fFcYCKel;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779278803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FEX1BkxODpNnhlsHlUI719HbjQ7p80GCzM210aRP2Nw=;
	b=khclEMFSqbUEbPDdH4me0bMe0HcAMS3Shg9BDfjZenHCQ7oT3IKCSJ9nbu88CI9mTFLnEX
	1AitOwrv/kTD8xUhssUNi/qurvQnWUOhDezVFd9ldvPblahndu1nVMSX6zYm1YgIU4fJk6
	D89O1wR6a17kOzptj62x6FvbYtEb9UY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779278803; a=rsa-sha256;
	cv=none;
	b=E/SCkTK8AsXuhwIOKe3C2lOm4B5I2axE87vaVWJ1XU5ROIMesjffTTF5MP7kCFtd9wFzB+
	NqBGPBRYP6Zgb6hF4RvjhO6/g2MPVqyz8PGQ0tjIE7gaIuKyCbhS/8NR1JIWgfRCxiKpPZ
	tlkoGM4ymNdt5mGwV38LAJCLmSojvTE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fFcYCKel;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 852C960120;
	Wed, 20 May 2026 12:06:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAA051F000E9;
	Wed, 20 May 2026 12:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779278802;
	bh=FEX1BkxODpNnhlsHlUI719HbjQ7p80GCzM210aRP2Nw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fFcYCKelCk8HlvwKyFT2PKSTei5qEUxQcrpT75qGxh3/5KW4Pyoo9TkX12ymOERF/
	 QPI+Ld7drAl2UzoOe76RiSSwtb0ABOmfdUhxuV+GznRYsJyxBYKTM6s8AnHhA2d3/4
	 DA+C4DhhdbXoatt89ayA8+uyQBRs8irUdDRy6k4tf7oo2/erDZAW6R59epetEvlfvA
	 R/JW7CBt272D/+XWeSNF4bDwTmylel6eG+tWzFi/DmC3vNxg9iNZ1zVykrn+TPhhqC
	 ohqeP7yf4vWE7fSk18KEjJznXt1BD17S2SQJBjteejZiLXYC0vS2HstTdkH60NHLa8
	 pW6EQ8//YRVcQ==
Date: Wed, 20 May 2026 14:06:38 +0200
From: Frederic Weisbecker <frederic@kernel.org>
To: Leonardo Bras <leobras.c@gmail.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Waiman Long <longman@redhat.com>, Boqun Feun <boqun.feng@gmail.com>
Subject: Re: [PATCH v3 0/4] Introduce QPW for per-cpu operations (v3)
Message-ID: <ag2jzvtAyhrmKj0A@localhost.localdomain>
References: <20260323175544.807534301@redhat.com>
 <agsMqeTRU9MbzdQk@localhost.localdomain>
 <aguigBraeANGjVMd@WindFlash>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aguigBraeANGjVMd@WindFlash>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1414B18000E
X-Stat-Signature: heakg3j1n3rgpikr6ycdfhbf3qf3ub78
X-Rspam-User: 
X-HE-Tag: 1779278802-896691
X-HE-Meta: U2FsdGVkX19MkPJM8NB29xDMvZIpIroQyWNE5Uif28XNKjOufh1qSuWqvkroUH8xkcABLJHfPFHi14xrRdzsuLn3WUtZIAyatiNB+fgIR6j9e60AKPb5JpFc0vDELUjiylBWQrTVGBfbhrMH1E/OUcWCYL5zLPV/Q8ssDXQgF/hy3DTaSDQsFCFVV2x8nWh2kR3eAMIvMkgfSzpe3ZqF+ID1PX542G2oeEFyLcZqlHnTltIyjvSfeaWxx4R5qO0uDC9uMNtkb0rJJXfxhVm5L62TrqO4FvWUiHXF4xAL+Tp6F+42+1T0acqXWESsyEvNWECm8i9f8o4EmpE2mWemJ79UGGD9GmXCt+XJPDUVw8gsbwol4yP1CPSlxZdw6OhOZqC4Kz6SZjgjht/ROk0FNYhQo+wTgGu0RTbO0wqtXChqQKlm9k5Fhz0C4aBUK+dXZQX7mtNBCIabDKuDEWQCNYGdXtrA5zEK8jDFemFT9UcXTOcnmaLV2snO8DZPgH4qKhgUEkcs6xanjTSSLXPti8Ym/8JJ6wbkJnu+Fw/bL8aIg+XdhMuYSP5oX/WLP6yweesv1Zod9yvvsM9tJ8rATHOmDY4xx/Ek1TOH2o6uJsymAPQOeK+rXeGSRkBe2RJatmnOIGz4HT8C9jCFhRM6vgjnLcbGNdp28dxWaRy6js9jhDQV8Qk1rbYfvclwYE3PlU96Ql0OhRV7upw6PynhDnwz6l5Qkm/CishhTOGRfGFRcZysAFLB4ay/zSuor3wFLKJ8XC8D1aZjV7D32jzFRNrqZmWE//tZAbenZq1wMaInM92RK4g7BEGFdOgDaFj2Dyt44UkbMuKvQPZK0Mt1USBjCVSqQIX4Fg6KIYd9kBQkK3GvY8N28xDhgB/ICTSvJJJ/Cn5EVoTOvIHx/I5JNPu9pC8YjEv7ZpPXGTFA+q7FFkqrRjxQpLo41LngkzWL/T7ALmFuP6X5xJab2wM
 nIqlEfMG
 22tyG43pkaf0dWGxF0wTo/bvfkaJ1B1p2bxcXM1WGv/Gor3ljPwbAg6PUiLZ0nRNdcUHclPv//CONFBFrdnKzCnkQ/W2eYYps7hooaXzVqQcJ6wdFBjVLmfsrPzfY6ORzN9Xp/dlGK6U4DAuXpO0YOXP2PYzxgsItXoQigu4nXc10caZuLWXtOIFKMBLEme/63hLVW5Xykd26tmxvkvucOOJxMz4uIdi5IE7+rUnI/qlEaKsw60LIGNFjro7PJRE0I+0JNLN5QDra1ugBQxIUf26y6/fl5rAm/R8QzFD5ywCBW0zsxyB4Nx8SuA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Le Mon, May 18, 2026 at 08:36:32PM -0300, Leonardo Bras a écrit :
> On Mon, May 18, 2026 at 02:57:13PM +0200, Frederic Weisbecker wrote:
> > Hi,
> > 
> > Is there any plan to proceed with this patchset?
> > 
> 
> 
> Hello Frederic,
> 
> Yes, I plan to send a v4 soon.
> (Pushed the changes to my gilab a few hours before receiving your email 
> today :)

Stars aligned ;-)

> I just need to perform some tests and rewrite the cover letter
> 
> Thanks for your interest!
> Leo

Thank you!

-- 
Frederic Weisbecker
SUSE Labs

