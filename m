Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 209E1C55174
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 10:05:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BEEA6B0088; Wed,  5 Aug 2026 06:05:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 076DC6B008A; Wed,  5 Aug 2026 06:05:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7CAA6B0093; Wed,  5 Aug 2026 06:05:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B6C946B0088
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 06:05:25 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3F06A4042E
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 10:05:25 +0000 (UTC)
X-FDA: 85066783410.10.62C2ACA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 87DDA1A0002
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 10:05:23 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Jq5Q3685;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785924323;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N+XoGNyWpxU/eY/FyPFqlR/DqODGXul3yoJNnUeWuhE=;
	b=SUmhFbL0JAtVSap/NS05Iid0RLcz06LXjCRaz7WmQcHqBSZ7CiUqaEDZdpeLVEQt5SXcBs
	vRmqbAaifVHXumSw9Ev9qAL5ELGj8/C5cd/dOSW93/asmwvygBls9R9Gf8ixLXi6ovwOMo
	Yyz5B6wb+T7sLJyoHM67yQvzr5wl8Zg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785924323;
	b=s5i573qvBfy7aAuw7qVhJ6vF6eiJFW7itZYL5P7//k/SF1yz7p/hcMHFw0HBNpHicp1jVc
	OV3mD4MvTrXgFVubKkuKxQksH10wYmRtnoX8eTbEqiB0ivq7TP8OIktyB0Kkkbd+zBW6eZ
	/2im48POhvjkXq0ovqS/hczTDbe8C2o=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Jq5Q3685;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 26A0B600AE;
	Wed,  5 Aug 2026 10:05:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 813871F000E9;
	Wed,  5 Aug 2026 10:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785924322;
	bh=N+XoGNyWpxU/eY/FyPFqlR/DqODGXul3yoJNnUeWuhE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Jq5Q3685rsYbHd98SqLdispuOOAbuxQVAV5qRbxrzcHBzXgG7nqb8FzpzT0WIuSKo
	 M6pQRdJXQKtoMiT3xXZ0CyU9udjbFDNEumCVYu9Z2ufAtQeqWlqpYwARYZhPgMGkO1
	 cpkmDQM6zY3iu8C2TesSH62wmXFe9ZGVIr/LLZIxDWjY/B44DslMxJTi3LSWZZwLGd
	 z6QFZg/Fy6XgosId7YuQX1J2KscHahhqpjEkQsOCwxa+CNVZK/V+Ebx7ylMVK/f9QR
	 /way7gBdRtRpIrHpZNM2gd4s31OoGQUPZTfFOqx6uP8UUAx6Eos+1thjlGs4hRJFpZ
	 +YOyMYCS/u0Jw==
Message-ID: <bcc2d2ef-7ee5-4d74-bdfa-6dbaa679971a@kernel.org>
Date: Wed, 5 Aug 2026 12:05:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] mm/Kconfig: make FLATMEM depend on !NUMA
To: Sang-Heon Jeon <ekffu200098@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R. Howlett" <liam@infradead.org>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, Lorenzo Stoakes <ljs@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 Zi Yan <ziy@nvidia.com>
References: <20260804151145.3419768-1-ekffu200098@gmail.com>
 <20260804151145.3419768-2-ekffu200098@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260804151145.3419768-2-ekffu200098@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 87DDA1A0002
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 5yopmcbn8hyipapewwx7o75fbkdrdt1n
X-HE-Tag: 1785924323-169625
X-HE-Meta: U2FsdGVkX1+ElSzRQ0ASRCdZTEt0Y0GVqmpmyN2TG5X/WVwP5rfPkuIxdUGmnOxug4ftkPpkok2PtKqU9sm3Am4cJKmq8mR/CMqNMB69Zkon2KVlg5dgPMandSZg0RoJw3fCC/Vxu+6oP+l88vuQo1y96eykoPBQCPMNTSmdW932i/k5P3SGWT+cXFizE/9WaJVJ0tmLE1j/ipF0V9/wRpSfFRdqGvUmHMbPyVjavar48kM3SB4phjUlkSYFgbeyBNvTHDHUtnjFBR4duWRz5B8SNPhJB7EZ6jdz7SNCpYTFLGvTRRbVFX7AgLeFh1wigtuefdhi/KjPp42keyrBY9e2x1trHDo3IWIdPWAdgEwyeutuux3qoQi4pT+CGMpvtn8dbdZECT/hMA2BTBpm78w66wGWhFFmBwO5zIpxXXaMDp7z2Hmyt1EZiWGDPmC6SrxToielG821R6goAb03syDGY5ysOEklllL9GbtY/wyX2M0D6C07sjBPBL91O/bOxwuhjG/hz+Ca89Pl/yb9S3rOGprZYmx8RUIw7nwARFsuOZ4BZUdSJOe2Ssi3WJy8ZNGHFzVwSLJgw7jE4SDNh38huApCg4wMdl4Tl+Nw2kOvITqbHnPzob238XJ2IsJjOG7hnzv0D3+liSQshKallUUevOpOWH34jirRWwz7DWahl3THs+F4r5y27Ev3ykfZDL5SY5JRjQkEb5M0VyqZhoQIEyvTlMejCYBiC5a6F0NocbuDJdLSboP/tdRHuj6FLKayhYLSyCtMOk+NRm/m6A/GuwBlUhmVYyf9Ck72oCAePqKP0HJ4s5rwFWZuZCa/QcpIVWmX+4zWk9l9vJu1fXHEtWFNQ/IoNU0rDrdluK94HzoFDyPd0roSpgca4d+/It0PSYS4/+1TaEwOQ+EMFxngR5R7w85wxLMPG4Qx/hRYmlby3U2skQyHm0Os9jPbAz/EEsc7786zCBe7eY/
 wKMqWcx0
 +7lCjS53NSFKJmJuTzG96UcyWUy7+Sxr8bHpTcmZ7WKSOnEZDtSTmEz1ek9Kn9RpnKc5/DX7P4bDj6PKZ9jyUsVZ+utYOV1coQ7OnzC4dtZcfj0a7Rp/4FMr8Zq7eDeo3oXvKJulfE35bOqPBnowEyJY6A7YolvAbGN222hP8ETiM2JTmWqACWXQ2M9vsbrDFobCbyx/h2s/zVnyD6ujJc5vdpXVZO+hWu71ME1MLYsxrQfkkN+abHSZG19T5b7/CjyZgwo5pi3Fd0EYQKGuV5jTI4I0j2QvBIrvcwhyDlgvkniF0fiieVjVrxEcDBCYkZ0t2wk94h+q9ByS58yyWF1S+2papW4/4uezskFwtFcbgZP+KdjCE6Bmoug==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/4/26 17:11, Sang-Heon Jeon wrote:
> FLATMEM + NUMA is not supported by any architecture and fails to build.
> The constraint is only implicit in the arch Kconfig files.
> 
> So make it explicit in mm/Kconfig.
> 
> No functional change.
> 
> Suggested-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> ---

Is this survives the compile bots, perfect.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

