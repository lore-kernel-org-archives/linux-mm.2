Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 683CDD1171A
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 17:14:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85D596B0024; Tue,  2 Dec 2025 12:14:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 834BC6B0027; Tue,  2 Dec 2025 12:14:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7715A6B0028; Tue,  2 Dec 2025 12:14:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 660676B0024
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 12:14:03 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 11D1A13A091
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 17:14:03 +0000 (UTC)
X-FDA: 84175178766.25.DC9F7ED
Received: from mail-106120.protonmail.ch (mail-106120.protonmail.ch [79.135.106.120])
	by imf22.hostedemail.com (Postfix) with ESMTP id 21501C0004
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 17:14:00 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=D0IrwHbz;
	dmarc=pass (policy=quarantine) header.from=pm.me;
	spf=pass (imf22.hostedemail.com: domain of m.wieczorretman@pm.me designates 79.135.106.120 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764695641; a=rsa-sha256;
	cv=none;
	b=JOdgpn7LSZLY2ps8LfzgIcqcEdO0IEFwdYycPOPIzbhkWrZ5tT3C14CCG7BOw0Y3ZxXUzy
	xwpQOvd0W7tC6bbDt0B3Qf7WTbQ4XiwkAR17+EZqb8lMSiH13eg3V0TusJ4R76hPmG8+0A
	1J/yYuKmCkFKYJymRjp8izWtiBocl8A=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=D0IrwHbz;
	dmarc=pass (policy=quarantine) header.from=pm.me;
	spf=pass (imf22.hostedemail.com: domain of m.wieczorretman@pm.me designates 79.135.106.120 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764695641;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9Vp4X2XP9zzZX2mNOr3bIXwE/WvkzEbcvbYHxtX/1nI=;
	b=baR2GCwx84wj9zoioNKM6eMxMaEN2tB2XGGfkQfw1F7WVLMJr7TxubDZf+4PqOv9iacy09
	eUj1Zngs83k4fZ4dphXF0PxwUNVWAXLoXCR9fOULyvrhn0dsWL5qPh+75kQ11pK+SMzPZc
	7Hc2OexHyT/9ZKQPxLCMX0S4TDjolow=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1764695630; x=1764954830;
	bh=9Vp4X2XP9zzZX2mNOr3bIXwE/WvkzEbcvbYHxtX/1nI=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=D0IrwHbzZsjOZbTzAYC43T/GZvItxGoXdjOL6pTFOlqP09SpcI27VoTUqnX2dfE5A
	 am2kS2jQzUAaAmZZ3BDlYlJ4zmHJhfvy4p9QDOQLZUDfx9rAKWY80CKBA6a4Er2ZGI
	 lt23qJHHMEJp0zxWXnjE3HPE2Pit8rMMTb0QajIEgi8PtkbGsueihkI5tz2KONyy1p
	 sgD7YMrNDB9XTxrmluk12jKgYBJS1IjXbdaG30YbT3+M3UxdniMlFiMKmQE50TwRWS
	 bCggYriITXVWIWBjt9DYu4oYFjigFfZhORcI0bQuDwx4+19cFx0M4gRZLimGFCnTMG
	 EB4JL2geKtDKg==
Date: Tue, 02 Dec 2025 17:13:44 +0000
To: Andrew Morton <akpm@linux-foundation.org>
From: =?utf-8?Q?Maciej_Wiecz=C3=B3r-Retman?= <m.wieczorretman@pm.me>
Cc: urezki@gmail.com, elver@google.com, vincenzo.frascino@arm.com, glider@google.com, dvyukov@google.com, ryabinin.a.a@gmail.com, andreyknvl@gmail.com, kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, maciej.wieczor-retman@intel.com, Jiayuan Chen <jiayuan.chen@linux.dev>
Subject: Re: [PATCH v2 0/2] kasan: vmalloc: Fix incorrect tag assignment with multiple vm_structs
Message-ID: <pql2nsktwqkh7olaq7yzh5wtqvnpr6u2mdvtmaqipwwzvomtzo@bilmkfsgxhbo>
In-Reply-To: <20251202083522.1b0349117b9159b891808532@linux-foundation.org>
References: <cover.1764685296.git.m.wieczorretman@pm.me> <20251202083522.1b0349117b9159b891808532@linux-foundation.org>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: 8e7bff291b714af2d585f45dc4652be83736ad4d
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 21501C0004
X-Stat-Signature: kzqowc19az8xssnpe1qdafm1xbxjwfsm
X-Rspam-User: 
X-HE-Tag: 1764695640-853372
X-HE-Meta: U2FsdGVkX19xUr+Dq6KZy/QFl+nKhmIBtAmwwNp8104j1P1BpAypPxcWpJ1iXC/XRkEKTYgYYdlWC3GY+i/Fbv9pm7IMHdSHUPX75UXoEwpfNH8y4T1pOpT/oGXF6XIs7tTOskmuAvGJD4Ca5Z332xdfY24CNEYsM4mXzjcGZ+hHMMWafZZYux7Pi90VE6EK+01QzeqZrNDM+rd/gVI2QM5i9S3cNuWlSvtrrzFY05Kdc4rVYO1PFkkiyUuYY4TzX83n53R/xevJUZD/xZmlc4Ge17Q2Dw52UnU5P4nJNOVzAwtbVK3Tz2Ck5yWtbkZcBKu7VNjRkvjZu0fxuuSDi7VDo82c2uaaXy4fci7oIYqr72ZrFZJbT2iBJ4li35XVciuUlclI9gg++08zXUNP0RnaQTQIi37b6g4i46LfOirCRcFnwiRFCOaF+pK8NsJPbso0Me7cXmTB5auNdHKjhlSSZT5xcRY3TpvDDxCXCAeewQL4N8mtKnLxdTfkxbhIRB+1W4w6+w+8wkjpa9E43iH2LnKR/RMY+qOduHTNnNfNbwCjxarj2OgrnFdA3JvC3OAGD/qj7tKinFxx5dtt/F0+tuLy0Dzk5ll4+2qSCV1rHoB1tKSDVuCWicBn2kXLbg+kDvpNjiH8J+ksrS4ZdWiBlB6nn5SdIjFW3b5IhlcMOnpkQN8KZ1ozptYBxbN7NZKQh1LkXKWxxB1eFCc9P5gRQqKFFGXtaekg5ExQw9j0Pg+e++B9W/81fg6L7BBMCVsYqFFE4sX+Ceuczrl6RCuHj04t552QkN7MeyxWocssdQx67CiORjkO52iMCobrwJc1Ctqym3uZBdCdpSi7Xa7Ahu+G3CoQCDluy++v8pPvyvKXqPitytRdS6/EYBhrqH7kpcyGfYeEeomZl4YO+0zSGYOtI0lpH5Zx6ABgYiGn8zmSHovNtRzvtlhu/20+GMqtdRfYbDLsMHIAgEd
 iE4hCovq
 onGzdMc4sSYLw3T1rtbhMG0aFAe6h/eiVifw/TvNIXbFSU4ccwrigVuiXcalUswZ7JpMqHmn0Wus41y8m/MvY/klbm9fZCoEXKuA+xjpBSBRerDz4VkJznY7yF5d3TS7sEXeDaYwpZF0TppXimavJiRWfc3cuxl9b8yLchk5WQLIeWaep16G7nCEEthuj/VNm/OiuvMVsQqu8K53RsTn8K1rDU8xP2oJZFOEeMX1wVHftT+I9ZP6UGVRoTcrcOM/faUsxA4TeTpPmATJv1bLAxd1Hcjr/vQZE/vUGiqvRucmq6NQNUj/wnMo0w/fd5RWgGiXlSzTLKq2dlNkglWy1gFBfHT811Jag5tdV6slZaJg9x6pI0e8aon8VBfv7GDZ37Kq4jVCbmZXCN9LqLDWUQfUzFA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-12-02 at 08:35:22 -0800, Andrew Morton wrote:
>On Tue, 02 Dec 2025 14:27:56 +0000 Maciej Wieczor-Retman <m.wieczorretman@=
pm.me> wrote:
...
>
>This series overlaps a lot with
>
>https://lkml.kernel.org/r/20251128111516.244497-1-jiayuan.chen@linux.dev
>
>Please discuss!
>

Thanks for pointing it out, I'll test if Jiayuan's version of
__kasan_unpoison_vmalloc fixes the issue I'm seeing.

kind regards
Maciej Wiecz=C3=B3r-Retman


