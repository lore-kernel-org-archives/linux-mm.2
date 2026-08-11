Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1665C5B572
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 14:53:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD5D86B007B; Tue, 11 Aug 2026 10:53:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAE396B0096; Tue, 11 Aug 2026 10:53:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC39A6B0098; Tue, 11 Aug 2026 10:53:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 84CEA6B007B
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 10:53:53 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F15C01403B2
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 14:53:51 +0000 (UTC)
X-FDA: 85089283062.26.95934C7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 27D0D4000D
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 14:53:49 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j3DwOWGH;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786460030;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WOQ+ZDQlG4AKI3By2UcE7AwtPip92RrNEzmk3JDxMwM=;
	b=a+3oYiPJZoS3+82zqM3UBCUhwUK6neCD/7toN1OE3ps4vgs81t1FSNFuArHbZ9J9/T/ZoK
	yGcIk6l/nteQAsg6CNiTK45/E11Gx5SYjC1mPZHQTzxkQkfGv1Z7RjyMgAGFlaq9H7zSgq
	WGk9EIUZZViNkHTY6nP4MAOjtgvQ5RA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786460030;
	b=0ySKMDO8quYCOD9vyF4KOUEPYeDbTV0TMnV/20m6bX+S/qFI5iu5Vp4V33yaw3+3K6N3dE
	PL55HZhjR5n8VSWTYWu6baV1SMer/s2/4bc4nQEIFd0xA1QvMps3mMh7YRrECPPTT2OS2P
	F+0R9xVLuupdXmhji3rouQNt5Xx46+w=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j3DwOWGH;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A31FB600AD;
	Tue, 11 Aug 2026 14:53:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B98A11F000E9;
	Tue, 11 Aug 2026 14:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786460029;
	bh=WOQ+ZDQlG4AKI3By2UcE7AwtPip92RrNEzmk3JDxMwM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=j3DwOWGHCbOKunQHJX9r6q/6jhfbcqkJhlWMr/zGpsEPrq66tNBjEzQaeuRwDlthg
	 zD04p9EopxztJHrvTQ23GYueVSUFDCeZyhEbiFlGHXE+VRYjRZnPY+CjjclZzkAmP9
	 MbOXmCeYZ3UChssgOyaWxM9l2/RyEo8OkbysfDh+s5Z9ZZGCxBItU02jXgvIwq7+Oj
	 aM6DO4Z8SXKbFoeoSnCjgLhrmJyLTZ29uFWM2dUp4RPZ10w/zTMJyD6JJ0TXNPbJAT
	 LkIf8najK5XDF/2oopUi1aCnog8hbMD98ceHFdh2wUDho1gbXCohI3NHc+S5eFCK5C
	 CqeoL69fKEKrg==
Message-ID: <70c578dc-769f-465f-a146-4a4695f747c1@kernel.org>
Date: Tue, 11 Aug 2026 16:53:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] mm/secretmem: zeroize secret pages before kdump
To: =?UTF-8?Q?Jan_Sebastian_G=C3=B6tte?= <linux@jaseg.de>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
 kexec@lists.infradead.org, keyrings@vger.kernel.org, linux-mm@kvack.org,
 linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org
References: <20260731162739.158320-1-linux@jaseg.de>
 <20260731162739.158320-4-linux@jaseg.de>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260731162739.158320-4-linux@jaseg.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 27D0D4000D
X-Stat-Signature: gzcax6b76dposj6ir3gtidh6ibm8q8tx
X-Rspam-User: 
X-HE-Tag: 1786460029-328285
X-HE-Meta: U2FsdGVkX197gZZzuNba9Oedb7P8gqMHK4qTdxjefu5USMmBirrAPSxp8D30OND3H84RjK+Gea2G7MUSSHRNKb2FzplnhlQHZ8UN6TCJSE7+HZ3w77c7RoOktBea9MPnhI+HndLmH0GQtWsnYWT1BMGXTiFVXa3G/3UdbBKx8BQ/bBbLzmNp00hvDEyznpYxz8szgsorhYuPH4fl6BuJkdeoXuxjRzMw0nAjf5b8kWmTycG8fyWuW/iGmdJ7PEMqwx4c28FotXkrWJIvmpvkZVxaZ2og+l9JwywEjq/jD6Q7kwiX4faHufz0JU/FKP3SY2cNpbJc1gkG+WrwzD0ebNQfnniADP6FHsmAwXiKOUXCBKPyIbxqkaKkc/QxF6aEbMCKqO+vUd60S5rrsyTkKSp1SroXbikJ4bPxLveZNsk92WrPsj98I/ooDwAoNQHkMrtDu4i3xcjZJU3yJ6vtdiiVM4pJMl29BLRY9h0yZ6IgvNde4l7AcTdP/GgYsSo08tuyBMFhoFjTqangIoMS8DayVZQGw24b2zwinN+B7IoCpRjfQ0gtFfc0LJ6qkvBaVvK7wctdHboJOwBIItNxLfNbvYJfIY9IwbCwfFVhYlrg9nVyMiVxM3wE6jCjBZ8xjcCStWTeBECD85VWJtmPk4rDkMWi+cfu59vtS5PY5ymmT35U72yhFChWiRly+ZclEW06YuDJRT8JbcPABp+ycPjz+h9jUHLzbFGsL4LE+ynOP4nP8B7zmrNcJx9qmfgbA3uDrYGc+SCyuQlUM/LKRubid9MpBjCKhiXHlBFEk+4Sx8FV/GaeaXirCoQH7SA05PsDxJPEM/is7mMzpBKI9k2bmDOvn6TnVl9uyJVpJf0yQcHEDhJ9DbKTZGtlyF6AICb7pNYxH2BaYKkBdNLAVY5R3+ewZKu9EgDQ3HZWPLGkH4VuFR2yqcbWPSL65adxaXOQqW88abRN2ic3qv5
 oqehpTry
 sjMrVxj81hGivwSWiZplt07bye+z0NAeND87CLXtjUSe2NrdD3zwPZKFAW3KPd0AqJvCx5Qc6jPWbwmL/nwb7OEytHo+HaGYWxATGdApZQzosvO/x3OAj77fRejoVLgtZ8Ngl1zy+kcJjQmuORQn2TMlE88JhOJMwXlB6tbGSGhHVLEpNf9vjNaC2QGPp0wqBqCXfNCEgeUvJQSHspFO5CPwHsa+r4EMiGLwnacUdKRAqbhipW59R9F2j4PO2NoVbtFHUggFnoRPP/CxrbvgzjvxOEw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/31/26 18:27, Jan Sebastian Götte wrote:
> Register a CRASH_ZEROIZE notifier that wipes secretmem folios. As a
> result, when CONFIG_CRASH_ZEROIZE is set, secretmem areas will be
> cleared before the kdump kernel is kexec'ed.
> 
> Zeroization runs after the other CPUs have been stopped, so the page
> cache cannot be mutated concurrently and the xarray may be walked
> without taking the i_pages lock. This is a best effort, defense in depth
> measure. s_inode_list_lock is taken with trylock only. If a CPU was
> stopped mid-modification the list may be inconsistent, and this late
> into the panic path, there's nothing we can do about it.
> 
> Signed-off-by: Jan Sebastian Götte <linux@jaseg.de>

Are you actually using secretmem in your use case? I heard some rumors that
secretmem isn't used all that much in practice :)

-- 
Cheers,

David

