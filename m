Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3554BC5DF81
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 09:39:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 408EE6B0095; Thu, 20 Aug 2026 05:39:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BA7D6B009B; Thu, 20 Aug 2026 05:39:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CF996B009D; Thu, 20 Aug 2026 05:39:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0CB516B0095
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 05:39:20 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 86FA61606C5
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 09:39:19 +0000 (UTC)
X-FDA: 85121149638.24.DCC4AE9
Received: from mta0.migadu.com (out-125.mta0.migadu.com [91.218.175.125])
	by imf25.hostedemail.com (Postfix) with ESMTP id 5CF14A0006
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 09:39:17 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OhgkQRHZ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.125 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787218757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7DsDg+FFQHE0daJt3tXS4ugvHiwFdRCRdfz1HqtMZc8=;
	b=WeuZXU/orho7OhgwYr3eCsQF/w0IuC7SslxLZ5AWuHflf6I13F6A8hyaYwTevsKiJePENt
	tahs8SSf5Nux+O7mu8KPh90bfj4kQ8l2TzjwckveDSxlEKOaScqvTc8yKWNqgxcnSa9q0q
	3lAPNwBeFsBM+m2eOm+ZaL68tCQDuVM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OhgkQRHZ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.125 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787218757;
	b=yvwyMNAM5hxNdPXIF7ZGgyRvnf9TVAGXp3CEujK8P7YRoF4x+92nZeU2wwnZWKG2EZ/dzg
	Fh0oCjvxwNJmrAUgqtxGDhL1agtnhA5tUfSRHN2YpoVr219yktkoIHPLH0syl0jeJLjcDM
	8Yy8QkXPBuNUJYQSqCJ/48y4ZyBDFrY=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=7DsDg+FFQHE0daJt3tXS4ugvHiwFdRCRdfz1HqtMZc8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787218755; v=1; x=1787823555;
 b=OhgkQRHZ5pnEcVrPUAcvUR98apJqLVvmPLwtxMZnm9iRWC4bHclyl2VW+vwFZhtVzx5hOXXL
 Ps7fVxkW4Qc0lu3suFu1My6TD2ocRj57G5180Gj8fGarim9Obz1LDnVywJLXvj9NFtpxE0rPrwr
 QqrJi7j1W6LpomBhTDV13SWw=
X-Envelope-To: linux-mm@kvack.org
Received: from smtpclient.apple (2408:8606:1800:501::1:7)
	by mta12.migadu.com with ESMTPS id 093084cf8ca96627;
	Thu, 20 Aug 2026 09:39:15 +0000
X-Mizu-Trace-ID: 093084cf8ca96627
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH 1/1] mm/hugetlb: do not dissolve gigantic pages without
 runtime support
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <206cb1f2-b66c-4b7b-b0ad-14cca9d8e0bd@kernel.org>
Date: Thu, 20 Aug 2026 17:38:58 +0800
Cc: Longlong Xia <xialonglong2025@163.com>,
 osalvador@suse.de,
 akpm@linux-foundation.org,
 mike.kravetz@oracle.com,
 mhocko@suse.com,
 linmiaohe@huawei.com,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 Longlong Xia <xialonglong@kylinos.cn>
Content-Transfer-Encoding: quoted-printable
Message-Id: <F06EC17D-2A3D-43DA-968B-1DD4E1253EF7@linux.dev>
References: <20260817162039.1511838-1-xialonglong2025@163.com>
 <206cb1f2-b66c-4b7b-b0ad-14cca9d8e0bd@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: Apple Mail (2.3864.600.51.1.1)
X-Stat-Signature: b1ibxxwui3rasisetsm4yazc7iaszr4k
X-Rspamd-Queue-Id: 5CF14A0006
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787218757-333004
X-HE-Meta: U2FsdGVkX1/fpBsSoAoxGUKnNOEjDsCc29WbPrfUhasytTaXyRTmNm/YKkHDn3ndVfc348iTsJVwPnoC5kWB/ZjceYsENbJA9gO9dlZ6Iih/Zef2jOMZQCqIZtx9adpJPj1PNi/9t4HC6+Rq5NDhXeX8Ih7Tkifff4YSyaZdJegbtMR2x8Nhg2PsaG+3BP1NP6d+vMVHfW0sXZq/dh8vhTCr6GQt132klM7j6Zh/GqEV09fWuJHzVjxG9ioS4j0LS33q2GHJErAp9SO5UaRSzQmws61ayBTBRxwwzY1Zc4KaCN3j83mtmrW0+VQecZqkZuEg/WWiQU+62l01QVN+kRrV/Lc6+mUKIWdY54mS3hdZWhzS5v5o1XB7aoUHIg3OHkM+hB8TSnpLhIpnY0uiDjjrHTtC3OXatDMq3GcEsa2FGO1C6zk2qdfuzL8CQZ/lPU09I0kOrYYCsYBhtra/M06L+m0EovLbJ/hXQ2CyvwjCI6eKdOvajaQXNHgoeYXGTguJ2SDsrhTejm7rDeZkVthy2N977pgvqHCVKNkNNiu6hdpX6AY8FZ2f7bgyBrUHVACFCZnLnru/yc8yvvXZbLOmQdN1IhX1lBxkqut7Yr9KLn/ZyjnUG5QoyM0HRyOLh+ja10LMHiKrY5Ah6v7MDGnvazxvW8ApAB5ig3CZ7d4qEZ+H0beNp4jfAAgayBWnTqVLF5M+GZArTbB+FV8+GK6unclOR35QpBcn1ylG2WYcr5gRoIUZHcA2SZTTymlTnE8okIlNQk4Gk7ZRgymGgy1aa3fqxKnUulb6I7sOQ+B+SmU8K5hAg+CixpSCJb4WkOiCRhaiql5jsMOtioqcjrR11rJt1NjKwycOrABEZEqJAGi3kSU+aAl2fGVVGd/UA/bZuiIiZiIUfJWzMMIeAy0+ZCwjnI63x7y4bneAMcVwboDVbSbppFWN8Qa9H3ptn0I4hT7cuXr4ecpLXc8
 5jyxTJle
 cmAstkE4OX6ttvXGHKXWKsXcGmLEtzCYNgXloG0fZOKfHv6uzTo7p4nDBDY5lmyW2NnJwiemlYhSBKLhrXa+BiNjy10Xu4ZjszxPf/f2YWrb6Xw13BOrdWbZBrK0ZSCR6lq3pWgXzBGhHUaNq3xAE7+j9SbvC+cNr87bfBWTFgo9naZT+9i11sqMn6PdABXa4mP0ezaiEUhDWSS62zASpQK7NGjb6V4gsztTdeEU07MulyZTaw5SFKWff87fQ7NsprccDR3032GCLOVC+rbZy9y4l+lNW7bjJhbZlcwuOSkBonlNbu4QK3PmdFnSnTUcNpZi0Cc4XMzbcyN+HNr0CmZU8PRA8ZEwvpN2iF345+baCoUvaLLo3uqHnmA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Aug 19, 2026, at 16:52, David Hildenbrand (Arm) <david@kernel.org> =
wrote:
>=20
> On 8/17/26 18:20, Longlong Xia wrote:
>> From: Longlong Xia <xialonglong@kylinos.cn>
>>=20
>> dissolve_free_hugetlb_folio() doesn't check =
hstate_is_gigantic_no_runtime(h)
>> though remove_hugetlb_folio()/update_and_free_hugetlb_folio() =
silently
>> bail for such folios
>=20
> That's odd. Why do they silently skip such folios instead of warning =
that
> something unexpected is happening?
>=20
> This screams for a cleanup unless I am missing something :)

Hi David,

Sashiko actually has a pretty detailed description [1]. So I think it =
deserves a fix.

[1] =
https://sashiko.dev/#/patchset/20260814083027.1419487-1-xialonglong2025@16=
3.com

Muchun,
Thanks.

>=20
> --=20
> Cheers,
>=20
> David


