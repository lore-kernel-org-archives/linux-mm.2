Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FEE6CA0ECD
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 15:48:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 381288E0075; Mon, 11 Aug 2025 11:48:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 358CF8E0060; Mon, 11 Aug 2025 11:48:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26EAB8E0075; Mon, 11 Aug 2025 11:48:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 12DA38E0060
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 11:48:29 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7DAF0C01FB
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 15:48:28 +0000 (UTC)
X-FDA: 83764908696.12.8809F49
Received: from prime.voidband.net (prime.voidband.net [199.247.17.104])
	by imf30.hostedemail.com (Postfix) with ESMTP id B75F780009
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 15:48:26 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=natalenko.name header.s=dkim-20170712 header.b=wL+LGZSW;
	dmarc=pass (policy=reject) header.from=natalenko.name;
	spf=pass (imf30.hostedemail.com: domain of oleksandr@natalenko.name designates 199.247.17.104 as permitted sender) smtp.mailfrom=oleksandr@natalenko.name
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754927307; a=rsa-sha256;
	cv=none;
	b=ugIjD/7xeOxk/Zv8MwHA7pQm36tlFtwJW/mF9NoWhuFQ4xGiWCn+7efIsHw9OaBKFHeCSo
	ETXygYNCzihb3FTnclczhO4M5saPA4bsVDGH2lT9bBFKMSSr03zufnQ5Qv+Ui40xiFrglB
	3JqKA4DvmhzySlCxUtr9v9m9HxPWXGs=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=natalenko.name header.s=dkim-20170712 header.b=wL+LGZSW;
	dmarc=pass (policy=reject) header.from=natalenko.name;
	spf=pass (imf30.hostedemail.com: domain of oleksandr@natalenko.name designates 199.247.17.104 as permitted sender) smtp.mailfrom=oleksandr@natalenko.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754927307;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=1L9wHhKVuXZQmzSOEtmhCm41l8tFu1qnDWrexhilFd8=;
	b=WbbrC9F1wkICvS4qUtzKKWakXOmyffP67Y5THxjqhuMdfEvEzbkh5U/+9ndJ3AJ+GtW2tf
	ZQaYY+CqahjpFHnd1VGQn1SW1SazCdtMfNcBX5hs3AnH9/W+8CVLtxOZe43QhRAEEDpma4
	3GRlM/IbGgpspzSKKgWQeYMulHco5+A=
Received: from spock.localnet (unknown [212.20.115.26])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by prime.voidband.net (Postfix) with ESMTPSA id 986B3635B040;
	Mon, 11 Aug 2025 17:48:22 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=natalenko.name;
	s=dkim-20170712; t=1754927302;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=1L9wHhKVuXZQmzSOEtmhCm41l8tFu1qnDWrexhilFd8=;
	b=wL+LGZSWocUdhgr4uDnJkqv/zrJDjGwZO0DZ5R+3skpojeX9/PCnPdJb8dmZRkEGkhxQwm
	fZlDnWEpL9uNRlPOF54P6RoNCeCYp1wG2BTGWGuhhQwXcg4qbGAtqFYW7khRm9CzynxQm9
	KkqaxakLAtnJyncaLQ2jBvjGKFju27U=
From: Oleksandr Natalenko <oleksandr@natalenko.name>
To: linux-kernel@vger.kernel.org
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 Damien Le Moal <dlemoal@kernel.org>, John Garry <john.g.garry@oracle.com>,
 Christoph Hellwig <hch@lst.de>,
 "Martin K. Petersen" <martin.petersen@oracle.com>, linux-mm@kvack.org,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Shakeel Butt <shakeel.butt@linux.dev>, Qi Zheng <zhengqi.arch@bytedance.com>,
 Michal Hocko <mhocko@kernel.org>, David Hildenbrand <david@redhat.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Andrew Morton <akpm@linux-foundation.org>
Subject:
 [REGRESSION][BISECTED] Unexpected OOM instead of reclaiming inactive file
 pages
Date: Mon, 11 Aug 2025 17:48:08 +0200
Message-ID: <5905724.LvFx2qVVIh@natalenko.name>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3613097.ElGaqSPkdT";
 micalg="pgp-sha512"; protocol="application/pgp-signature"
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: B75F780009
X-Stat-Signature: 9eejp7t9dnww8knkhgm3prdewgpb8ug5
X-HE-Tag: 1754927306-918492
X-HE-Meta: U2FsdGVkX1/VKCUZVpM6Ve98f1UXml/QkOPDqkIJt22ipq3jBEWHNSvqT8jvjP5m+vqeVDHnFeiZiLvDEZjA7+fSwo4LEF/KDJzdtZGKywe/cGCMe/V5BA0orwSO1NHKOB93YfNH7VyV8q1jImuaUDLndOHIL1Ge+ldMe2x/5AuOAIBc3iOergkn2rWsBzw6v6DJ6R9R8Edtm07r9fz2LwQnK/DZxRB2eA32bdP3YSdigUd64/JCV5dPszWO646HUjWl3f+2l5wXP6cYQBZzQn+52+c63lw+/3ymKS2xikKJUUYffKoRcjBuvAcqz7yxazSHqTsQHFLo2eiVrodo7PnF4uzEGqRH8f9if3Akc9sW7Vv6nx4ECxiRdfjIh5axZ/5jtvViZjmZU6rocI2B8IpyAdDLDaLYyfLLCeMFUq3IntR3VQ6s/JMeIBywBp/KiKZdPEJn3OCHvtQ1k+bdR8koTbTNmWR97a/wCTvGKLOFryUwv/qRMpU54LVciDiBvTkNW3fYZ0xJXWwqVOr0GiylX8nR4vpa0BpmJnQAMFLFcTmiED75NJ8woiyCEFpFBfyeyfXLgnspDzlxo5nwIAd2tAG5nJUI4xkdR4iA/MDd7ItnLjqQy5QKFZ3RUw0DrnCqs5tLLeLkWJRiFj9C5kU4E48t14xaIe3aZlgoyHypBw6jRQHXy8FETvV4JNioHJ9/GB5yBmcg3tkaXnGtNhCnLeMEKk3FZCzoLT+87ZvGu+gKBLe0FzYhw1tL9tBY4S6Ie+O3yPpfAXELoY5CsIS47uM3o7posYPEpvvr/a1BOIs3bxkB4V7V8THSt3YxdEk3pMCMJJGZA4zoB4mG0i3C+8VwMxRNr53Z85VQ6tUMsaGgzC3Qfc8jBnRgNeM46pVEMHsQLo5jUcEHiG/2+FWmjp6w3HnSgq18pQN4zu9oW5BghiLeFFYYyKVB6jD8Gg1TJJYxDCYGvrehxaU
 FTFttGcF
 8EGq4fW51xB8p7tviDQx6LWAWQ0PQlSZ6zwhXOklvN7OA8xKsoytovJxnUwSmC3K9n8gzX7Io0t6OWsu9bBZ/ZypN++u/m7IAyJNV3kOO/4ve3vSgVE63L/u+yJJX6tRf1goQkGPtSvyMJi+emumJ3gA4rmDpnuRqZ1vzMTiYENEmRMV2YdziGPGnMboKByO/do4btPVh/FOyoD3UL6GuKrcsgUWqS7RVVaAor0dnX4DzKVwTT6U833TpGn9ih6sdZQnK97gmXy+pXWJ4t9depDUmLopyitM4gHdDo+9n2ibQGRDco+9GT8u7MoVf2E8MYilOELe6CDQtkslicjMrdOEOWXvAU6bdmiG0DJ+YKpRBGnN5ikTx+CkswdLjKugkmdQ/BuWFMCGz69BdBP7nFfZOnRkLzORpu7knaC5MhJiZ4mAB9IvtzPT0kMcLF135sodIbTFTu12LFQkZtB/YXM7mWSXT/Sy9fBWPiousZCvf+UaJIAICAJfqZYU2DeFgAJAIHveRd0M3G7pqEvXeTv5caw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--nextPart3613097.ElGaqSPkdT
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"; protected-headers="v1"
From: Oleksandr Natalenko <oleksandr@natalenko.name>
To: linux-kernel@vger.kernel.org
Date: Mon, 11 Aug 2025 17:48:08 +0200
Message-ID: <5905724.LvFx2qVVIh@natalenko.name>
MIME-Version: 1.0

Hello Damien.

I'm fairly confident that the following commit

459779d04ae8d block: Improve read ahead size for rotational devices

caused a regression in my test bench.

I'm running v6.17-rc1 in a small QEMU VM with virtio-scsi disk. It has got 1 GiB of RAM, so I can saturate it easily causing reclaiming mechanism to kick in.

If MGLRU is enabled:

$ echo 1000 | sudo tee /sys/kernel/mm/lru_gen/min_ttl_ms

then, once page cache builds up, an OOM happens without reclaiming inactive file pages: [1]. Note that inactive_file:506952kB, I'd expect these to be reclaimed instead, like how it happens with v6.16.

If MGLRU is disabled:

$ echo 0 | sudo tee /sys/kernel/mm/lru_gen/min_ttl_ms

then OOM doesn't occur, and things seem to work as usual.

If MGLRU is enabled, and 459779d04ae8d is reverted on top of v6.17-rc1, the OOM doesn't happen either.

Could you please check this?

Thank you.

-- 
Oleksandr Natalenko, MSE

[1]: https://paste.voidband.net/TG5OiZ29.log
--nextPart3613097.ElGaqSPkdT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEZUOOw5ESFLHZZtOKil/iNcg8M0sFAmiaELgACgkQil/iNcg8
M0vbWRAA1sWIe8mVt6d0YmxKVEnYTYmMS1xatrN0wE+v1F22bp2RIiILZ5N1jlYM
s7mU4zQPn+K3KGeskURO7fI+Pkxqhas8UeN4p2GXkDGxSW3/N+eglmgbn0ICCE1w
I+fsBRbF7u5AI1xwUrDl4QDs+3YwW+v5RQbwFTwQYLu1oz9cARZD4tn4P80x7RIl
ct/TtcUvkHWjs0JEKXxfCqDQfEe36dD5TD2hFk5Fo1tIrSQfMojmoJ+gMXPCtXsh
tfPuXFeenpcySoLvu6PS5AayzqPCle4t2WOuVigE5KMhPkpNG22Of7PM4FbueRQa
O4QECIWlzQNs0n5VVrCNlAWC5dCtzGHvV/HI2tOmEGIUjdpU39JmibrQa9OsK3TA
lqMgmD8rgMT4r7TLgM0f4F48q5enU8nfSiuL3PVxeEWDJUlz2cCyb9cFp8u6ybI8
NI9n/1l+G8rV24E4eWuB7+vWMdpcio+/C1xxB0KZS8tdSdB1vQJqFhv4o0TqJshS
PurH9SL9ZoRz9s+JequLlnz5vZCULAHMD8pwcZ9KbjhuohA5BePtDt26IoH+0KoM
ph1zjJobDbwNCLvGi+xXorBKXjytESPDJEyBfQK77T5HeEGiFgzF5OG+Nt/9V085
ReA9mxcKPcpe1VXz4Hl3LHaPBUkg6ATQ9r0m+FTF6WIowpomIG0=
=guvX
-----END PGP SIGNATURE-----

--nextPart3613097.ElGaqSPkdT--




