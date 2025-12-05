Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5593CD37492
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 19:55:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC4116B02D5; Fri,  5 Dec 2025 14:55:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A749E6B02D6; Fri,  5 Dec 2025 14:55:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B15C6B02D8; Fri,  5 Dec 2025 14:55:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8B7E06B02D5
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 14:55:14 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5B9391A02E2
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 19:55:14 +0000 (UTC)
X-FDA: 84186471348.05.0B85C41
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id AA6F7100009
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 19:55:12 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=S8qZi7RQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764964512; a=rsa-sha256;
	cv=none;
	b=o+l1BcqZXT1lLyqFx1DbziCeCiK0QWiIJ4qLOLGa6lbziqVfjf7FaEP8cUV/1x4s7IeDPn
	ANGrF9oCWPGWL+ZjnD1YNFFwLvJea2tKMFZByyJzx7S0j+FxFPH2Jpx9GjsaqwIyl8zJif
	UtxZKmAlbdFv14Z9eVU0EVqUQwgIRX8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=S8qZi7RQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764964512;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=caVfqnl6wS9KLL71Ll8UD6uBVUdXQ1j+dbDt6bh9chk=;
	b=hqE4NeNDOirXvDhu5W4eQWuTSdf275nf1mfDu3EulLQHrNQg6+z/D06pNjA5RjdVsSsp06
	jBxprCZR/7NHsqmcPI/UkjMxhfMkhsIsY8mIK15Uyi5tjz9F8Dc8UxzUzHXQ81sjKK7s0u
	bWYkasIRLJWG1GMywQLE4HUjfYbFOsQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B00FC408B4
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 19:55:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7376CC4CEF1;
	Fri,  5 Dec 2025 19:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764964511;
	bh=szrqBFkV65UASaZTapgs6pxmZf/jre4C39Tr9u9FjCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S8qZi7RQeDHav5qK/QGaV9WJKEQQ4gIWQbY+sdvde5Nnv78crrn9K37SIiKpoxxkc
	 nC9v9kj3+XQ5H1lIJBOpnpjux4Pory5Pwz0j/Pi3+luC2znyUh5ipyVZdmmdBA27KL
	 fyYbSCJCTyahw2t5uF7SipEwi4E99XMrHAA3foQl6XQEyGUsR4wZgyXY6zFjbk40Jh
	 GBOf/uc9NmaW/e5d3HOX1JrY+X8pnY9p5aoSB59x2dDo0JuH1q21QW8yaLCMBesar0
	 4FR1ASqNSRycAjdkRo/bLq/IXZZ0Ew1oGK2Hje7Y1C1txmccJVGxHrxDsdLeUb0NgM
	 foNXR4CjJU+ew==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: DAMON Beer/Coffee/Tea chat reminder for the week of 2025-12-06
Date: Fri,  5 Dec 2025 11:55:08 -0800
Message-ID: <20251205195509.76051-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251205193540.75695-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AA6F7100009
X-Stat-Signature: p1k98ubmbqowfihtjouicdj7w3q5srip
X-Rspam-User: 
X-HE-Tag: 1764964512-61526
X-HE-Meta: U2FsdGVkX193e/sys1/y9VBnQIUrNHYL4MtywDsfcwZm1XvXRLczbCu64ZHIRTei2kA1Qi3Pr85GbGvYcoANTeng88aWX3hMbVoj0nAn5m1hRpvEaNmsXu37bBVPO2IPKLjigcMM2RHJf9peZ9eOgyJumzKdyOZxw2rPmCMJ8oY5cubqbx2TAAQKj0450swW7UP9auecQqxIpI8eQ90Is14x7DT+tkEHxeNMS7+dVQZlQzecgqVC/awW6TCI5AtmyoTVoXZphoGq3BqzpYBzChNWa+RYMOeasK4mdrtLTmQgCtzVokquT3cJeofzJW9h6SSjNXKjkenWEWwyAuZ32RB22NwbxSHUgTqt0mEchZxx+JoHZ1Btw+DZrRtzitglqw0zg7AMk2ZKPbJhA4/Txr0Nv5lJ1/QbgMeXzBlNsz4GkmAbBMyi7fivFTa3iPSdcAZNBgzpTKAljtjDSGYR8Q+X6EP3ecOxpPBid+AWSat9wsGeciBs0PX4R6Vx7fNPs54UZSxp1GnFTmTHC+5nx9ygOOjzMVBlzl/glc33cFJqVkTo52kRw+UQhU9QByq9qgcPm3gSVhe119VRv7Q2QhlRGSTV3hdZ/4pw87eW+SIiZthMYKHhzYBy4YEs0SHKihTf+5VF28FyNcNc6ZRAiBG1pTJ0ldC8wWBIYDMCuVtI8a+Y2pq6uTJX5tNeHwOOJ/xTwsdzCDVCUheSW/vNE1z5vqSBdcCSoP3H3VJ5zDIHDgJhoU/7IFX3Xzwxl04WRxAwwegf6mgqtSie8wWrpn2gI+Bq6SAcppBgI8Q0koxNCiCJ1wHvfohN/VnWBaP8sUMlGRTL7ZaZsROvbhWEG8dQbm8E+UBoHMUMqV0D/xmktJ/gFp2JHjCTM4asnIvf669YMiXS03IGbYjP2WePkKp2Axukv9aF03G2dvfvoyYXeUX0LZeyOPkiRrg0YCwn+Gd5HPvTOWbibY4X1qf
 5TYHalQQ
 z7dnz/45nr9p2cTOtmC5xsVbTyPv1U/el5gkVvTbGYy/BFbjbLsod2ypRB3XzVGVH7QJkl5biJR2uJc7A2f76pN4iMP0XlGLNuK7G2zpU8gobbf7i8040duoo5lSl2OQ6po8K5CtY5h1kRgki9jhOgDK9JxOiyt0tOD5upgCs0Dmn1Paewbr7/mzEEwSEkPewkMOHL8D1O6mo1W6RxUqyjps5vSCQUOFEPEUzZMuoxKo8uq7cXjlxWs0IPjZkIH+xkTRQeaJZ8JCIhYkUX/t6htevLdQQPUo3iiy4dLs/2X0+Dl8pO2iZAvj2uV4m7BboYP5xR7wEf7GjuMPejqEbkkNYRN74ps/Yw7uUf0sD5fbmWSGx7AQDww/Ro6Dzh7VrYGxuy0CYUYJSroPlGQ/Wm1oTfE2huYrBo8YvD8F4o2nO7mhmaljC7q5/hK4/rAJkhA/QOu7HGPiGL6KC1BDPViGJZw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  5 Dec 2025 11:35:39 -0800 SeongJae Park <sj@kernel.org> wrote:

> Hello,
> 
> 
> This is yet another reminder of upcoming DAMON Beer/Coffee/Tea chats
> (https://docs.google.com/document/d/1v43Kcj3ly4CYqmAkMaZzLiM2GEnWfgdGbZAH3mi2vpM/edit?usp=sharing)
> for the week of 2025-12-08.
> 
> On the week of 2025-12-08, I will travel Japan for OSSummit Japan and LPC.
> Attending video calls on the usual Pacific time-optimized time slot during the
> week will be challenging for me.  So let's do the chats for the week without
> the pre-booked time slots, but as an unlimited and possibly in-person version.
> That is, let's make it can happen at any time and any place (not only Google
> Meet but also somewhere in Tokyo, Japan) as long as we can.
> 
> If you have any DAMON topic that you want to discuss with me during the week,
> send an email to sj@kernel.org saying you have a topic to discuss, with
> when/where you want to meet.  Then we can further adjust our schedule.  If you
> also attend OSSummit Japan or LPC in person, you are also very welcome to just
> reach out to me in person at any time/place without making appointment.

For a case that you want to use the latter option (just reaching out on the
conference) but wondering when/where of the conference you can capture me. I
will have four sessions on the conferences, so before/after the talk near the
session rooms would be tood times and places.

You can get the time and place of the talks from below.

- OSS JP, 2025-12-08 (Mon): https://sched.co/29FmF
- LPC (specific purpose memory MC), 2025-12-11 (Thu):
  https://lpc.events/event/19/contributions/2066/
- LPC (observability MC), 2025-12-11 (Thu):
  https://lpc.events/event/19/contributions/2059/
- LPC (refereed track), 2025-12-12 (Fri):
  https://lpc.events/event/19/contributions/2075/


Thanks,
SJ

[...]

