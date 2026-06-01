Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4383FCD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 13:47:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72FD36B03A9; Mon,  1 Jun 2026 09:47:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 707836B03AB; Mon,  1 Jun 2026 09:47:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 644076B03AC; Mon,  1 Jun 2026 09:47:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4C74F6B03A9
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 09:47:07 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 00A301C1F0C
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 13:47:06 +0000 (UTC)
X-FDA: 84831470052.22.D461783
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 69BEF40011
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 13:47:05 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a2kJyXI1;
	spf=pass (imf04.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780321625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VXhPQdQbmoYxAcV9f2JludgA6q/58FaJSUv8UfHFRl4=;
	b=mOxZ/Upf3jnBsuTywWfdzrietb9agNMzL54Di+9HP9f3bamOrxrzX4PTpmCvBzZ5y2ZCPn
	NF+qQ5BHEXpCUreOyzlcQZGRRITA2qIlIud48FjlnD+ODXFq5NB2x3MCnr6zD6SzxmCgLs
	v5YpGai5SpjVHO/z+9mqoZYzq+yxLsg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780321625; a=rsa-sha256;
	cv=none;
	b=vLaudniW6i71ghz5o9d08hoY52BQnDSzHakDd3139oB0MiOrfmHDHwyg+Dik0KSrcvujs6
	IGuY3C8SaKvi0X93f3aH6g3GyZ7tQX4SZsWgbx+/EmL2zFH4lFcdX90paPwkxpg0Ddeyrt
	oc53yJXTccnz1eZJ9dWVRPuJJ2mZVBo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a2kJyXI1;
	spf=pass (imf04.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D78FE601D9;
	Mon,  1 Jun 2026 13:47:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 258691F0089C;
	Mon,  1 Jun 2026 13:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780321624;
	bh=VXhPQdQbmoYxAcV9f2JludgA6q/58FaJSUv8UfHFRl4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=a2kJyXI1gAxua3NhkBOff+AUkJjnhgPLShZ/88+99yp64tJHwtjd8quIORXIi5PyB
	 9mSyIIlLImIB6U+wbfQ5aRikM5IkO3VFL/iSK3uMhUbF9EyEfx4Q2OUeoZws4yMFAk
	 BUuX79fXFgvZqgbNRe8KiMU8rStJ8qX5nPjCL+LBljsZbLcgxNDmqZcwJ4HMCqWEXk
	 s4zxvlfmuIOlvB00hxcodPp2ocg6vU2DviYmGIO6wCapBTaPWH2qw9K5Z8GKBF/yjy
	 gQUnBroinBXDdp4ReRa3TRZuAzEMSLTOCtRS57xC7ywiutabcheiqjjY8i1oPJN5MF
	 h95wh8sINQUjg==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: linux-kselftest@vger.kernel.org,  rppt@kernel.org,  shuah@kernel.org,
  akpm@linux-foundation.org,  linux-mm@kvack.org,
  skhan@linuxfoundation.org,  linux-doc@vger.kernel.org,
  linux-kernel@vger.kernel.org,  corbet@lwn.net,  dmatlack@google.com,
  kexec@lists.infradead.org,  pratyush@kernel.org,  skhawaja@google.com,
  graf@amazon.com
Subject: Re: [PATCH v4 08/13] liveupdate: defer session block allocation and
 PA setting
In-Reply-To: <20260530221938.115978-9-pasha.tatashin@soleen.com> (Pasha
	Tatashin's message of "Sat, 30 May 2026 22:19:33 +0000")
References: <20260530221938.115978-1-pasha.tatashin@soleen.com>
	<20260530221938.115978-9-pasha.tatashin@soleen.com>
Date: Mon, 01 Jun 2026 15:47:00 +0200
Message-ID: <2vxzmrxefk4r.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam11
X-Stat-Signature: 6sn65cstmp3uumd3josj3d9sstoa55yz
X-Rspamd-Queue-Id: 69BEF40011
X-Rspam-User: 
X-HE-Tag: 1780321625-853850
X-HE-Meta: U2FsdGVkX1//bPf+wypyzFrat3UNaIfPYbp8KgdCsaaML/82nleskIxl6hIbwSTpc3WPCCAIsLk/Cyi1LnaoUYVdkzqJ5ZGCDr9f/62P63nHDP8Xl9RLBIoE2LGrEAUVccMI3BKMZNCMhO2o9WhbkP2LNyNHx3aumdFNJZXmdUlgaTjK8fIhOAsNavNmPTTMVgWeOyfG2levx61ZmaeRBX5PwRmfoPoxGv7RE4oqnIhlX2IulRGPyBTlzdIaMhEU6w0JvsOzuyj3vYJq2qZ/AfOG6yt8hPX/do6KOdS1QLqO98+3R9GI24oswditoDnwWsGUZDo8ZPZx7+JWv49ngFVeIWS4MkBnUOr2etM0EFl12Hp1T8IpTROxzp8i43pyKMBX+c5Nk2Mj2qfflqdQicNLNFz7OHiAPCYWyOY0uQhwjDT5a/axVHDTOHL49k5hxWUa1A+2/FyiGD9qOexGMnJJCPAT2hOYtLZLXGhVbk4PNFAumIE5X5eQXjxjqmdHZeV0X/2W/PiT7Q6+a42wbTLzi8M0vrdrplRQbNC/7bCLmpWXfLJxPQ1xNu1PU/lAP7bXItp8kji0ZWbrWZomJv2NJ0G2XjI/I+S6dCgMgUhcjYd26M0myOmg9Y5Sf9Ieyv70j3U+MuGfeC2YscfEdNnvXORsrh8LO/ZoL1r1a5rsOuvy1NhUz9+htZYJtDDABKQDqC5rqZg0Qs2x8CZRRq+Sx7OciSC2XgpmnNAdO6Lg2iOMCrWrVI3GYlgPXVhKgHuJRO+06VTrP7kmpQK5yZyqcCHolPBV0zSq1uwoTJuDmWTmnSro/jltKTFr7YJwPpqJmxng09KMPgSqd740X4jkLwJYcZ2p9udtcqKmt0c1oJfNlsakvfcqugbnMlER6da5RyubhDmithiKPbAZO+ZD6oUQ/lveUultr1prjhsj20HzSwxDH+ajRw8rd5kxEjCIcpaTRqIfD6RQ13r
 j/F56g1+
 iDgv0na9GhznZNG6tDleT8v+WYcM2pc1MBFARbEo0n8tpjikqMrlid1nmP1W16wFhbvqRaHHrSl2Z6lO/A4WIucAUQnpKOassK7C3/jqmEvH4uwt+mbk3YFljj2W1O63mtfEWFyIBIGivM66YpccCmmz/miDzcKWPajgrICcvSiXdw6YUXIY/cpSdCr5/wLZw/wiHjil7PcU56i8HitVs7JAGuoW/sPvDqsuQRhb2pTt0mngFk/wd6PVnSY7TBiA2a9mf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, May 30 2026, Pasha Tatashin wrote:

> Currently, luo_session_setup_outgoing() allocates the session block and
> sets its physical address in the header immediately. With upcoming
> dynamic block-based session management, this makes the first block
> different from the rest. Move the allocation to where it is first needed.
>
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>

Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

