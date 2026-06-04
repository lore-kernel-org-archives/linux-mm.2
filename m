Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77311CD6E68
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 05:20:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5473C6B0005; Thu,  4 Jun 2026 01:20:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F82B6B0088; Thu,  4 Jun 2026 01:20:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40DCC6B008A; Thu,  4 Jun 2026 01:20:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 30B7B6B0005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 01:20:00 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8A9F11A0521
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 05:19:59 +0000 (UTC)
X-FDA: 84841078518.17.1B99629
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id ED8391C0006
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 05:19:57 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IdsUA08B;
	spf=pass (imf21.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780550398;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zXipXIgKd+8KQkn/WaaFioKTx6VwCL4kWpBxM2Pbdb4=;
	b=JDcpe0J7zahl73nAc+1a2VLYOLrLyh4sXSZsdroVqvv/nAPxmsIIKdGH1PdpPD7u8dg4T1
	U+dB10kKjaEiRHF2zjWB9UUEpiiOQjjR7+jTbKlkf5lovHyMCEuZPtlvoGkY3KqAm9quSp
	DZU1/1Bi3yM0ZoXKJIPaX6aLMljP8+c=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IdsUA08B;
	spf=pass (imf21.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780550398;
	b=x5CwPHBE1KhVNGgI8FQp0tHQk235eudmu7cZWKYhDrQQVwwS5W1oKAmD+ks9MURKRasZ4a
	Y0pADYEd18JovnZOeqRyzB8BkNJyn91BfXK0/AmugHQlsIsdZVWgq0qr/uePu+b9dfmOZq
	wgy27Ju+/apicgn3NjQNrPJ4V0aZ1Qg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5D83A601DD;
	Thu,  4 Jun 2026 05:19:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DE891F00893;
	Thu,  4 Jun 2026 05:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780550397;
	bh=zXipXIgKd+8KQkn/WaaFioKTx6VwCL4kWpBxM2Pbdb4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=IdsUA08B60viXspX4laPU4RhtoUAglT4tchpnbtoykZ7L+E29e5Fsvj6ToY1eAc4Q
	 uWufd+bXNzcomnTNfoFgkma/R+MsYJE6TU3LtkM6XlhILc5Xhced7r9H6CeiSHcqsi
	 CDzdqyPY7/CGhT03Ra+MZ6785gZFG3R8YschSGGKtpxBMn5cJXnZ++4tw2cPI/muRS
	 ojTr6kpWEhUIdXVn0lCXfiI0niC7bCaZdZBsSJthD+Fi1fP6ufJAUN/4wMx7d2rvjc
	 PxCP6NULO+RpHO0J3LUH89UFTqbYr+/CuXy+Gg7QPXnEGdzMSYiVjfHQmhTdh2V+90
	 YdS+P5Qlr9TdQ==
Message-ID: <ed9e834d-e3a0-40c2-9407-252f7ac7f00b@kernel.org>
Date: Thu, 4 Jun 2026 14:19:30 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/slab: add a node-track-caller variant for kmem
 buckets allocation
To: Pedro Falcato <pfalcato@suse.de>, Vlastimil Babka <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: linux-hardening@vger.kernel.org, linux-mm@kvack.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Simon Horman <horms@kernel.org>,
 Jason Xing <kerneljasonxing@gmail.com>, Kuniyuki Iwashima <kuniyu@google.com>
References: <20260602183122.747759-1-pfalcato@suse.de>
 <20260602183122.747759-2-pfalcato@suse.de>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260602183122.747759-2-pfalcato@suse.de>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------R1qkIECy0a412Zihr25diudF"
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: ED8391C0006
X-Stat-Signature: f4dpuxrsputpbwt8y17u1x55xr89n1kc
X-Rspam-User: 
X-HE-Tag: 1780550397-179165
X-HE-Meta: U2FsdGVkX19556JQKPr6VysBntt0AywwffI7/7zBXRS4etWPgm0GYHurYxKXJjHRhZFCIvMmddcZyZUhZLT4fG9lmUdifR5knwx5Mu+dArh8bE73bFW3F5ohe4QeKuCHA2eeG+NJWCixYGA7h4/3d5c+n3GN+l+oIi1R9StE+CWAJq7a4OBtLkYMga3H/c3ItTAii5/KuDe1T2mp5spc6gDCbFwMa9n+oF0izsqHXAPWhvSDNCfLiWXu47bZv3B64dY4diZCwkO9CpAFvISAf/SA8aIBNONDusdltlj/x2+W4twht1WYEnUl5BZhZ/+lcsfP+6bjNO6STl41F+bwkWDjRqWizMwtKcamTb3z+NrR+hDvrNNYpctnN3HHl1IWjCT8dZ5eJBzXEnLR6/g/Mkxt8s5f+Mwegv9jq+/PVhqSoc6zYLwL/ibRRBjEO7YF8ffAuDXwYlPSh+mZxbW5Tm131P29jzTkQ1bC87cS+2LVlLCcqlUrz9ScAaqLbgrhIwCLe5xufhoejO9saJu0xFJmGNq+7ll1tg1tGQvun7H83bLmr7l/gIpmykzSNFW+q6vaXrQwBxV40kQNqPqlmR4kf6SW6GCExPc21Skz2FhX6QcL7iXrMVfejvWWfbqqeo5YB/SkBAuMQjKUuAHTrv+Uc9DIXKkqRilBp/r46T8y0dqybuENaDDF7yLwgaV4lNZy4CRe7bJI9tqxC4uApwFDcarkwNSDHml2Y/gB9gDnUO1jFc9mhREjxLSyPVD9f9E2MhBJzvjh4IflQbcwRMJcLM0jsvjyiZr6m2jVSaLPcx+FCeb5xX48idHaKRIFz5VQlaA1elBzRhVHmwFKL/xXYk6q2MAWOHQ5Rp0RndOMyRJQcK8mgWsSazt9S41vDBq9nSnR9h1LFY13rq0t3gV01V4FK2sSQxtcFD9hBKmbfL9QnvV5QtFzLyPwhaAQEkXdNdyI49N+CAbOw5G
 pRT7xlJm
 A3W9daTuktKEgv+0FB/m2bolGKZGGG/uAikQM4GhLY7n0Dl6kkVXMb6HndBS+pRDbesLzFtXYX+VX0q7xjJBDxgiI9R2Vvm71Z5s6hMwZvHvwF8Q9EnHzOKtRgCcEd+X/5nFvQhvXAoRWdz+5gMudTlovPxZr+plptToHHBYebg5qYtc4eGVLJxMHg7ayo0B6Sb8R1Q+5JOQ55+a8+AC9OEGuOl4iCzND4ak1Ei64WWg/y3ypuVZI9DD/tqysqlHl211pSmNVoZnPskV4wL7qwL0oNIDNQnTVjGYrDC4dz1xoLGn7adAOT8M6awISiTt4f3zD+JspN1Q6yp8yyozKLaeRIZnhZTVKKT/D36GCH3tb8IbWQrRtalTb0iOgi3lIMBlgazRCCz0eH1bSAM+UV2QfNBaylOiSeHLmNrJFAUuHavnLXQxRA8zmJfZqdeApKSQ1/6IK8I3qn2MMEOLuK/UuQMo1J+Wu5GDYhGE5vF8d+fAYQC56W6i7l9jQpchyp9qdImTymOFEL0C4bSqIHonqW9BZ9fl6zybl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------R1qkIECy0a412Zihr25diudF
Content-Type: multipart/mixed; boundary="------------8aADOAqpLj38nVKRPt8K4gTn";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>, Vlastimil Babka <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: linux-hardening@vger.kernel.org, linux-mm@kvack.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Simon Horman <horms@kernel.org>,
 Jason Xing <kerneljasonxing@gmail.com>, Kuniyuki Iwashima <kuniyu@google.com>
Message-ID: <ed9e834d-e3a0-40c2-9407-252f7ac7f00b@kernel.org>
Subject: Re: [PATCH 1/2] mm/slab: add a node-track-caller variant for kmem
 buckets allocation
References: <20260602183122.747759-1-pfalcato@suse.de>
 <20260602183122.747759-2-pfalcato@suse.de>
In-Reply-To: <20260602183122.747759-2-pfalcato@suse.de>

--------------8aADOAqpLj38nVKRPt8K4gTn
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 6/3/26 3:31 AM, Pedro Falcato wrote:
> This is required by users that want to use kmem buckets, but still
> desire specifying the NUMA node.
>=20
> Signed-off-by: Pedro Falcato <pfalcato@suse.de>
> ---

Acked-by: Harry Yoo (Oracle) <harry@kernel.org>

--=20
Cheers,
Harry / Hyeonggon

--------------8aADOAqpLj38nVKRPt8K4gTn--

--------------R1qkIECy0a412Zihr25diudF
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCaiEK4gAKCRCGXBN6rc5S
1vM6AQCkY4YYTzaxNH/LFE8/hF3kloS36ybDDdJp9a+btRaPqAEA4IOb16AiRT4O
zjOEcyJ4mUNx0EPzF0P4UEotgig/1QE=
=VEOt
-----END PGP SIGNATURE-----

--------------R1qkIECy0a412Zihr25diudF--

