Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC01DC44507
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 02:14:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98B5F6B0088; Wed, 15 Jul 2026 22:13:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 962886B008A; Wed, 15 Jul 2026 22:13:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A3B86B0093; Wed, 15 Jul 2026 22:13:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 62D4F6B0088
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 22:13:59 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CC8171C0163
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 02:13:58 +0000 (UTC)
X-FDA: 84993019356.09.42E81AD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 20A6A140009
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 02:13:57 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EBjsBetT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784168037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g5F3u5HpCIVAKXXlu6lQyVffkwzqzhRodbunphDG+08=;
	b=TIEoY2CrJzKwE3/8z1MCvdZFQ+EbRtFL0TbUqZB2wNN7Z48u6Pp6vg2xu3+U4++GILN0FX
	Dw9zjcXyBUkY1U6QC8EDMaua6NYbvDznY0G30VnT1wlkEkyu1NSmznuoZpb58MTXyW5n88
	dfGQIgJDYAPyvqBFSWKhqpm/IeRbDzo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EBjsBetT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784168037;
	b=fJjdgcRnNRNjIT0jVX4Rs1vS9Srv4uA79sq4JhtGUbtT7/YeFIzI/d9yjo0ADtDNUEu0fg
	uUgXdKSeiBoP3nuD7qAPh4HmVw+f3RSlBOCodObEOH1ToCQYZB2vSv5j2794vdv3KzRDh6
	xSWOi6mp5MuWEZGZu8gqEz3WEBekx/g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 90DA260054;
	Thu, 16 Jul 2026 02:13:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFC3E1F000E9;
	Thu, 16 Jul 2026 02:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784168036;
	bh=g5F3u5HpCIVAKXXlu6lQyVffkwzqzhRodbunphDG+08=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=EBjsBetTSLJ/PVXVrqcQdqnyDxxVDV0X2i7wsl6PjjO7XwAqHXbYMpkxNNCLqM3Ag
	 Q7w8Gn4ODpy4hriDiT62lcx4Y99bE45MLrMFL4r2C7pyBxtEKWDVFhMbMABBPohN6x
	 A2KNevJdgn3xL3cHRiXO2U1YEbfY1VR8wr0VV8ejaH+AnymlWRJ2u5Z5+KHf9FqkeW
	 npmW+d2THetZb3DtPP4Kj7716QEjvgDOgqcbSpma/8XdRe/ZGz/9kAvwxx4QlQ6Nqd
	 75tFh5B6g0eWy6tbgLp4JBH6TSPkajTMH2Rdqzvalp8eACMSLnssTJOlfo3iNK5WGP
	 G8xcyb/3fqcGQ==
Message-ID: <7700e867-9fec-48d0-b9b4-d48632fc4808@kernel.org>
Date: Thu, 16 Jul 2026 11:13:46 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/page_alloc: don't spin_trylock() in NMI on UP
To: Brendan Jackman <jackmanb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 Alexei Starovoitov <ast@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 sashiko-bot@kernel.org
References: <20260715-alloc-nolock-fixes-v1-0-fadc49952dda@google.com>
 <20260715-alloc-nolock-fixes-v1-1-fadc49952dda@google.com>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260715-alloc-nolock-fixes-v1-1-fadc49952dda@google.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------Ii0HwgF0oUWLgy0EetAZXxlL"
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 20A6A140009
X-Stat-Signature: wrmiuki5gkbzps168h7feawr48wefy7m
X-Rspam-User: 
X-HE-Tag: 1784168037-182522
X-HE-Meta: U2FsdGVkX19yYUROkXQjEdOFd5eBrAC4dbQreZ9fY9grCTdBsa/L3c9Ffl6xca4BDlb/X0aBIcWGz8+fRAsZ7Tm4heqZKt6t0D795bb4WXel/tGaTVZ6oR6brmijUscfSbVwqOIDMIxpcUWngLscQ95Sl9p+3AZprTB0pEqG4yyYJ83PW+9knj/YUavCNLQe3Oy4EKFew2t1KXKAkk9vB7u9qO585V3RVoYxptlrrymS+lLgU3al8csX7inlSzly5MfcZhhQDPhf1qpkmAh6Y+ErEKbTFSONuo1BHj6xtBQ+F5OVAaYZXL4OJWQbVKqxwRKXoFuvPW1DFO2RD5aKKDB5dwlgzviSjBfJrF3JHG2Uaz3HFmiH1txBLClVc3aK03ARa4y2VyWR8Pv2tlM6OuTrbtkqGIVDBHP2KFQnuMmfwzVF1A+zEqKgsWzB+8rFvabRhHMom6r3v0yYO/kEoVQp3cipg/MX+2ubse+FeGdamNvZckNX85HT89tiDz6KstZb9dyrR5HIJNwhlkntxW9OddK1BC4h9qnUfN8Z50bWK1iAT8xqTKiCGP5MEUbWMJ+QoEMJj2p9xEwzOaPRRbgV0SVNwuZ9D0Ny57cndkHT9uEN4911GYIc5ycziY1pXb2ldOJBFYqi8sITNKpeWdD140ifVOx4PzaTC6AMGDyd34pNwuGpQQ2l3vrDqsZo3OEwCW/kmEct8t4tYcUSsrgepWJJmjhCESohkku8jeM2pp0ZOVXEnezyfu7zX4AuRIWpJ1MIs5ydNgqDZ3aWcGHChQLeJHCNVoTHr/7doOACZl1l00AjpwyzSkmBS910bINdfHWGf6D4Z9O0n+d/FDsnkCxUPDXF1+BpfDNczKDsdrlDGAUQe2clP43RmBsbZwaOo7qOH5vqa4lhU4psvjMz/69CuDkFA+Jq/LCg+uReBaFOpO7jAuB++TchY07460uQtvTho0dgrCeG0+T
 KR9UdEyI
 N9Y9kgQontJyGdwFuHlDiTON+SqZMqFcrI1APtQpW6ta4uZlSlGQSm3HH2E4Fgdq5lIVX5WH4Q4mvKiFx4dbzLPjzChnfmKzU03B8u6pEMy6bXjPMjDT1K+tOzlv14pER0Q9/QdEiTqmk5Uyp93qsc2Y9oNJoUCkgViWRvt53ZJsm/g3s39icC9N7PyK6L4W7EArIFvRklSiNm7mzw5xI1vOqWZnfSSW4waACAOKcG5o3vFdhGJYZKx6Re47w3zM+CS8/6M9oLV0117iin9jrZY9q6cbGA43oJFsXDMzJ87+nA9j9c9JX5+ZCuvUgV0ElGb0wYCrgCqJJgNFcwkl7CCYXixMst4BTgcIx+jeL6BVv+jcdc/QEl05G2oRqnEXij1ZGBiEtp/MxN0FS1jugldUaCNaW6u04yQY1cV7TccwtAWz9YlA3qGcIZJ/a4c8XZulVOqU/Z2uuUKxcew9aToHNROgAeBuNoOUEsyWdLGuTTYLpffub45bUvfGOGHXM4346yqFMOOLk7qLtBYm0HhJymrwOHUo94RY3gWCNLoyye2vi5z+0nKqpkMJWwSavkpNMR9MZ1KWdtkNfag7BczRDhSINlBEZd+oM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------Ii0HwgF0oUWLgy0EetAZXxlL
Content-Type: multipart/mixed; boundary="------------RMnVot6AwRKrwAyyoZv71EnF";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: Brendan Jackman <jackmanb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 Alexei Starovoitov <ast@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 sashiko-bot@kernel.org
Message-ID: <7700e867-9fec-48d0-b9b4-d48632fc4808@kernel.org>
Subject: Re: [PATCH 1/2] mm/page_alloc: don't spin_trylock() in NMI on UP
References: <20260715-alloc-nolock-fixes-v1-0-fadc49952dda@google.com>
 <20260715-alloc-nolock-fixes-v1-1-fadc49952dda@google.com>
In-Reply-To: <20260715-alloc-nolock-fixes-v1-1-fadc49952dda@google.com>

--------------RMnVot6AwRKrwAyyoZv71EnF
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 7/15/26 6:03 PM, Brendan Jackman wrote:
> As noted in can_spin_trylock(), using this is unsafe in this context.
> commit 620b46ed6ae17 ("mm/page_alloc: return NULL early from
> alloc_frozen_pages_nolock() in NMI on UP") fixed this on the alloc side=

> but missed the free side.
>=20
> Impact: If BPF programs using these features in NMI (probably tracing)
> are present on non-SMP builds this might crash the kernel and is
> probably exploitable by local attackers for privilege escalation.
>=20
> Reported-by: sashiko-bot@kernel.org
> Link: https://sashiko.dev/#/patchset/20260703-alloc-trylock-v5-0-c87b71=
4e19d3%40google.com?part=3D18
> Cc: stable@vger.kernel.org
> Fixes: 8c57b687e8331 ("mm, bpf: Introduce free_pages_nolock()")
> Signed-off-by: Brendan Jackman <jackmanb@google.com>
> ---

Looks good to me, so:
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>

--=20
Cheers,
Harry / Hyeonggon

--------------RMnVot6AwRKrwAyyoZv71EnF--

--------------Ii0HwgF0oUWLgy0EetAZXxlL
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCalg+WwAKCRCGXBN6rc5S
1tMvAPsExCAfy2YFybwbgzOaolJPi/PXxIAOia72JjLQ8MaGFQEA/ZhQrf9a7VOT
eyWvHkU7fjM2Gm70Z4h84mW204PjNA0=
=iCHD
-----END PGP SIGNATURE-----

--------------Ii0HwgF0oUWLgy0EetAZXxlL--

