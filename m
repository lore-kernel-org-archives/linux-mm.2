Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F261BCD8CB9
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 07:19:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DB956B0005; Thu, 11 Jun 2026 03:19:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B2BB6B0088; Thu, 11 Jun 2026 03:19:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F03A6B008C; Thu, 11 Jun 2026 03:19:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 23AE46B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 03:19:48 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id ACD111204E9
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 07:19:47 +0000 (UTC)
X-FDA: 84866782014.20.3697597
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 15713140011
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 07:19:45 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V8lcB+cy;
	spf=pass (imf26.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781162386;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ztIz45hab0AvLP/gnjehgcjg/V46iqjqRkXzJ26PE+c=;
	b=P+TVcdXLRKUu6M9aokyN+Fsk1MzXBQgSt5KDhbsS7MBPYVTw+kpFqis5O9u9/3mrrKSekg
	LC0UGkY/+GPtKsRPLVqRpCEAJ5SzkaKuHBh9kTgzNTH/1kBwl2Wtl9eVDjgIn6IlFW+UX+
	uSzBYv6fJXve0mkDujXAvcr0T6tJZJc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V8lcB+cy;
	spf=pass (imf26.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781162386;
	b=SlyiIdXZRuQz0jtJ9EVMePWB919soTzTDGivc72FNR91IKuhLmZCk3X+dru91o9VDIX+Nx
	frwN2NR7W6HD5aii87/iZiZ0YZxWBWeBcEevjc8cTQVEwNPJ6BdklOU+Tdq0SX0uGNv7uc
	phiZigOznM49xnhN1+QMOtQywydgpDI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7F9F4600AA;
	Thu, 11 Jun 2026 07:19:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34CD01F00893;
	Thu, 11 Jun 2026 07:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781162385;
	bh=ztIz45hab0AvLP/gnjehgcjg/V46iqjqRkXzJ26PE+c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=V8lcB+cykIyGjOy2dxrUzVV/Q3lA3bzfQKE0EKEaizxsQXtCLMAczPlwLgp7xGqQt
	 u+Tv9KNbobe9s7mJxUh7I484+2aw3LoRmftl+hLQBDqVe9Lcuk7KCvhbIFHDowJaTU
	 5qoD06COfhUXCd3IxkyNNS+lamaR0DJC1PLgzvRDaDCs4U/HKd2UExROWuQ94ik22t
	 dbG6cloH+VyTLbJyHTBOkIpew5Q+MQD9qkDen+aLF+6OpvtJeuCjrdmvOqPChWH2sp
	 FllECbyKhd6qro9ysbxGFJZYXs260Qxg9YO/M385HIqqKf0UuVpdCBmE7TvPRobA2f
	 9gr5N/WB/0Fhg==
Message-ID: <2b5577b0-d81a-4dee-b4e2-acadcf7f7db2@kernel.org>
Date: Thu, 11 Jun 2026 16:19:40 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/5] mm/slub: preserve previous object lifetime
To: Pengpeng Hou <pengpeng@iscas.ac.cn>, Vlastimil Babka <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 liam@infradead.org, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260611063926.38111-1-pengpeng@iscas.ac.cn>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260611063926.38111-1-pengpeng@iscas.ac.cn>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------63UUg0QDpUJ3o0cdIUnrfdpH"
X-Rspamd-Queue-Id: 15713140011
X-Stat-Signature: n5rmkhn5rwtuiue1b1ruwdacpc9nt6e9
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781162385-411965
X-HE-Meta: U2FsdGVkX18O2gCIYLpXXTEux25KGsmNZeyGNOOKDlRsttiEx8qsZETwBl8vx0WSjNNiWmvBRRpc7yOvVTEzsjneD0PzFoCeltxExyZ03ppYXnbdJjza30E8yzHplcaMYPPFQR7JS/auM3VpAtpL8z4Ak1vsz0Vb9uMtjHGldub0fYkIoIaPNHS1kYtWdq4P6evRDepsAX87uPAjhCvFFoXRP/JfVhMdwhRhzOZ+oxwvRUnUTS5dmQaKA5pKMd55XVNHEfaiNfMN8+aFwKH5pPbrj/2MovfL+9yG9BbUkicGj+oKzuWREuvP7nenu4p09K0Dwu59xP2SUIho0a995bgYUpP+tzdSv4JYiIkMViHdnfBZ6VwWXho94oCKqSL4U5mutz5uMzc3ydh1ZdRQPbgC+tqffk/RSPUh0VC+hQKEfdPgUq/dy0xXIHfGHevioqQMcD1Ye8kvcTdN2EWB/QPMmAXfjrgxCGwLLXExtIBiC8YEur+gCczaWTaTSybftc93jmx5Hiw0g6+aeNqzoD86CXzstPJDU55TW8mg0pEHZ+vBu1UaGJfwKKFW2BhalzCl0WYwdXBFQp2INtbc1oZuftF10fhXDh9bod+/1ZYixT7aUT8I6yjHw7qizUxrSyDEX4VI7efG1V2R1TZ1jmBrY5T16VgMgrOKtI8b6JVgTorzxCroiaFfhTJY4yTqPYoYpNymWGla8J+LL19BZSwa4QlPDSg0dkqJc62hn9NG4mTHaD+if98JA+9MHTA+XDkSUiQ8fLJuPrzGl3FXU3inAEizZ9HG0gC5gyofZkaVih2fo7OSAghFjtVENklj5HKXD6VieaplmgoFEvS3Dq2m5tOL7xKwPe4Hv1I8lWKGJnQ2ZrR+MJlH99LiSOhgLmmrsvTV67m/JdHpcLH2bR/QuuAaJlWX1GQRD/P/kJCg2xiJK38le6jVb0UDor0kv5n+vbh5bJfvM1kqsGb
 8BY8Lp3G
 EcbJJAj/X03HTQnoa2nl2uCBpf6wP/w7BRiAH8yayxRqjNjcGJS0Shmjr+OYCPPlWCmB2fi2a4fGmm0xFqcNZWqBu/gyvefyEW0UHWmNh43lJCiErIceHcjwDltWcNcpo63aKauajm/weaEqUM6vcZt3G7GmwKSzRIMoJ8mt4uxW4h9HgG3mAxYa7GZ1h+aB8nZ3fKq81UZCbOuapKx0FnWfe8/+Hoen+J774etc3WHb+EjJrh5ky8AaZaLU/ST9FM7IL2/sUykMTbTdnoXOvAzbj9WF5sPCJCs7u6qO6kItBLmHIPUykq/B8fFIITy0RJpOpgUMBee7MrMTxd1KPfpCo09ewynHCE9owl2ff4HjENxoj4Y9QKiR5dGt+j5wnIoHF2nHPuRAuMRY+yP6MpUVXgiERklGT4WZw7KjYMvzZwUhKc5VwAbAP6vwvwZAtV5pY9ug9M3yvZis=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------63UUg0QDpUJ3o0cdIUnrfdpH
Content-Type: multipart/mixed; boundary="------------RjLOUOXpcNn5GjJVTPq8Q6Ve";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: Pengpeng Hou <pengpeng@iscas.ac.cn>, Vlastimil Babka <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 liam@infradead.org, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <2b5577b0-d81a-4dee-b4e2-acadcf7f7db2@kernel.org>
Subject: Re: [RFC PATCH 0/5] mm/slub: preserve previous object lifetime
References: <20260611063926.38111-1-pengpeng@iscas.ac.cn>
In-Reply-To: <20260611063926.38111-1-pengpeng@iscas.ac.cn>

--------------RjLOUOXpcNn5GjJVTPq8Q6Ve
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Pengpeng,

On 6/11/26 3:39 PM, Pengpeng Hou wrote:
> SLAB_STORE_USER currently stores one allocation track and one free trac=
k
> for an object. This is useful, but it loses part of the previous lifeti=
me
> when the object is reused: the new allocation overwrites the allocation=

> track, and a later stale free can overwrite the free track.

I'm not sure what you meant by "stale free", UAF is accessing object
that are freed. What makes the free "stale"?

In general, I don't think slab_debug=3DUP is the right tool to debug
use-after-frees, because slab will never know _when_ the object was
overwritten. It can only tell that somebody has overwritten freed
objects by checking if the object content is POISON_FREE or POISON_END.

KASAN is a better tool to debug use-after-frees, because it can
tell you which kernel code is accessing memory it shouldn't. (It also
quarantines slab objects to avoid immediately reusing the object for
better coverage).

So I have to ask, "Why not use KASAN instead?" before enhancing
slab_debug (neither is intended for production anyway).

> For free-after-reuse bugs, the report can therefore contain the victim
> allocation and the stale free, while the earlier alloc/free pair that
> explains where the stale pointer came from is no longer available.

Again, I'm confused. I have no idea what "free-after-reuse" means.
Objects cannot be reused until they are not freed, no?

--=20
Cheers,
Harry / Hyeonggon

--------------RjLOUOXpcNn5GjJVTPq8Q6Ve--

--------------63UUg0QDpUJ3o0cdIUnrfdpH
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCaiphjAAKCRCGXBN6rc5S
1gaOAQChyWUETqFeUG2gvr9ZMZ3Il7reXckMo4X8MOCt7Rc7AAD/Qfkcf8YbQo18
ItCpaSmOiByXdnbuV93+suelFfGbgQg=
=kmYS
-----END PGP SIGNATURE-----

--------------63UUg0QDpUJ3o0cdIUnrfdpH--

