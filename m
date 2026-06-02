Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E4C3CD6E4A
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 13:01:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 794386B00A3; Tue,  2 Jun 2026 09:01:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 744D86B00BD; Tue,  2 Jun 2026 09:01:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65AC06B00BE; Tue,  2 Jun 2026 09:01:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 564936B00A3
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 09:01:17 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F127E1C0A1B
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 13:01:16 +0000 (UTC)
X-FDA: 84834983352.18.CC6C572
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id F2C48140021
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 13:01:14 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hvLCvWqT;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780405275;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NtalSOOH+yrngjx/V5C9n2EPAtgL3kfaFfzqLx5b1Jg=;
	b=SbmSP193/hiESPhrbtwylywoXe8TJsgLjstCfGEpcETXgB3sy3HUU4HYF0QCyo2CFsMg7K
	JJVEjvt6HMb745eeW76GY4ThLI2ahIPPH8se6Xr6zYeBXjPKVKaSIjhFp6YamIjrluZJTE
	dZEQE9AlX+V+A3tuURLUpx3iqcSzmCQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780405275;
	b=IbMcvCDCL2YBBCl1yoLvYm3spLqYm1rJOz82c36sn1dhtLhbJJR+AR7huL7O2n+j+JnfxH
	iLAnGLaDh2OCIYO1Yn9mbEB45otriayAYaMLYRZ6pmxJCYBsI/55FuytlfZ4CwORZc60Gx
	gzqwRoHHqhbCTJH9FL6+jjVpb9YLjSA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hvLCvWqT;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5A4EC601DE;
	Tue,  2 Jun 2026 13:01:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC79E1F00898;
	Tue,  2 Jun 2026 13:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780405274;
	bh=NtalSOOH+yrngjx/V5C9n2EPAtgL3kfaFfzqLx5b1Jg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=hvLCvWqTMfQTa1phh3iMiAlxznODUEkrvAHnbqK+0MQ4SNeQgg+7/0fIKiihANv1X
	 zuaFeBM4F+JhSzrhXCneHB1VhWCoX2tKt/DHWZ7XtMBQ4zOyuutTO4h2yNa5HFT4om
	 RqYuh7hES24S+2loGIDOO0P0Jrj2rlmP5cStY7zhwJR5fjxYFRPwokVqdRQjBepBiG
	 s60iEilHzx1ZnZZuvNFeT3yvdhzHysk8zKxZOij16oIQ51XgdT+fgoux5Vafv034uc
	 sDhZGUAUdd4fr93n6hqMY7CuOS2C/ITJuB+6YN94W84wirz+lh/PCr2rwny/u3zX08
	 HjbB5t95k6u8w==
Message-ID: <609eb98b-cc13-4f89-b9b8-cb93fe69a884@kernel.org>
Date: Tue, 2 Jun 2026 15:01:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Process (was Re: [PATCH mm-hotfixes-unstable v18 00/14]
 khugepaged: add mTHP) collapse support
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>
Cc: Nico Pache <npache@redhat.com>, akpm@linux-foundation.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, liam@infradead.org,
 mhocko@suse.com, rppt@kernel.org, vbabka@suse.cz, willy@infradead.org
References: <20260522150009.121603-1-npache@redhat.com>
 <CAA1CXcCoDU_pnp0SmMzRi8wPGB1OBjbbokevq2X_03X1vpWtOw@mail.gmail.com>
 <bd622950-62cf-4b57-b3ac-89635f28fa4f@kernel.org>
 <CAA1CXcD373fFfo9YPWRj8mJ_rsnzyCrpn1uk3=k7kU=QuaLOgg@mail.gmail.com>
 <a9f43ab4-e47d-4907-9620-32287e3e9b84@kernel.org> <ahVX1iq_-95vd0PN@lucifer>
 <fa9095cc-69a1-468d-a1fe-718386398b10@kernel.org>
 <b45f9b55-5143-4387-aa98-e077390d542a@kernel.org> <ah2ndruO3RQGtePP@lucifer>
 <506fed6b-8954-40fa-8b5e-c8bd8c0d004b@kernel.org> <ah2uDhs3a0bFcRNG@lucifer>
 <ca37b7ce-76b0-4825-b238-b504dd499d3d@kernel.org>
 <b5b1a7bf-de6a-488a-a011-673c37bd24d1@kernel.org>
 <07334dc3-79ba-407e-96be-21ceb2eec00a@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <07334dc3-79ba-407e-96be-21ceb2eec00a@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: F2C48140021
X-Rspam-User: 
X-Stat-Signature: tpeeq9kr3doscfmz4rmzrw9o6xpmdexj
X-Rspamd-Server: rspam08
X-HE-Tag: 1780405274-78872
X-HE-Meta: U2FsdGVkX1+UFpWthrlbccZxhymfEdIWltrXpA2hbqqZB4RMa/folKWsL1c/SzE7GZavou9kSQN2g/D7eWZdA+/Cbb9GTo677TFtAuqsW5cZItrsRQJaZn+ygPCVzPxOtNYcFs7B00M3i6WcgoyxHPNsnSQ9gDq9ntwx3x5zDorwThH2kblXwQBYbJLmTHcUWmpF2zbRaVmO6kh+ew7ZJ3Ofju7e5o7Q9eUcvaFUw2aIgDleWllqTWUfIrj9s21BsutODNd5CZSF/NS4DuQjhEhMql8B5a1Sfym4NVD3QnBExZmxUH4fUrKPDFvdZJdw37npXB+/ldDSOw7EVqkjWz5FxeiXHaOO+FqKYAUFtc1k+NH5/PxijNr+fNpsyMo80DfcqdAeFd/ktLpO7KHB36SnR/jLe63HknOAN8U92Kz3r39yajA8ttpOBUOYfyIqxT4rPEaHvIGI7OjQG4Vw/xICfQboHeM6Kz0TuFiRnQ/hLmdvVl484i3HKXKdFt5iddXvzBZ2re8gocneYPf1650kT+m1/zZFjxIFFwHMa+I+lsTFTToQPfcqmrBROlT7PSRwe9KZSHwvZ0dixh6BWQiG6li7RkOmFrS1tQXpPUWB+PXveNLQngjHjErZacmCMSHdy+9DCy3PQUtZdSXU1s0zJL3s1BKYw4WsIYp5IiJ+/3VbDTB3KlukALzEnuA2JCAByZc0cz2D78uxyzPB7I+PvtGto3qhkqZNhy12B29iINLTAi8oMJ+7o/y5xKJvSan/T7V5VImIBiRs3PTRZRmVMwXAC5mfRjddUfq25teMyDFGqNPclZft6N6PBcjVL9Yd025QxTpT5sIfqYjxRr/p9cmx5eMFpsNBy71EUvM0n0/y6U0PXH8GTONlNUsiNzO/gyj4hkLqDAH9eLZN1Myd3BccBHUl7mTMZwARqxGEJT02CBzrjGcXuuhSeUZC6o4Sid7MT1UYjfSVvPj
 juh+6vsK
 4msnHqld4WnQ6aV1F5FqKYbJF0FwUt42zdhAAFlFDp32FLfgmXZkPpsjXBGdVAeHCqwkculhf3Msn87B0QxvUYyGmHeJfW99+ynuwegMmT5JkKhXqnsDrYzBBHIt5NQKsKryH+mSo+and2q7hUAToKLazh4rc/64q+seU0Gx8oj08j0HJjYRJiXrZ5r4/CsbeeBdjYHrNQsivI0t8bCaCPejYBrcQn9WXMnb2Rw3rHynNeIDpkratwbLyDUqvg3NrjJSPOIa5sZTnWoPaqWhywB2KxndGXJjhdnw1iIOOO8g2xM5HppwkprAE4g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/2/26 14:55, Vlastimil Babka (SUSE) wrote:
> On 6/2/26 13:31, David Hildenbrand (Arm) wrote:
>>> Yeah, but as we said, we discussed, it's all rather complicated and we should
>>> move incrementally.
>>>
>>
>> Starting to read Documentation/process/maintainer-tip.rst, it's very interesting:
>>
>> “The tip tree is both a direct development tree and and an aggregation tree for
>> several sub-maintainer trees.”
>>
>> “In general, development against the head of the tip tree master branch is fine,
> 
> I don't think we'll be able to use this part as mm-next will be only an
> aggreggation tree and not also a direct development tree.

Take a look at tip.git / master:

https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git/log/

It's basically an aggregation tree.

But what yous end there will just apply to the relevant sub-branches where it
can simply be cherry-picked?

-- 
Cheers,

David

