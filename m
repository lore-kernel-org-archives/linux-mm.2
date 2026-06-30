Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB6FEC43602
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 13:53:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7AFD6B00C2; Tue, 30 Jun 2026 09:52:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A29E16B00C3; Tue, 30 Jun 2026 09:52:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91AE86B00C4; Tue, 30 Jun 2026 09:52:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 675756B00C2
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 09:52:59 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E418A404F0
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 13:52:58 +0000 (UTC)
X-FDA: 84936720036.04.A881CFE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 39F8080012
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 13:52:57 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ltadpJyY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782827577;
	b=DI2PwitVNYDieqnfzsh4ZGWV4ZvFyQS6XV7skEcwyhlJwxpU4LLgZgWK47igF5IewYW7MP
	rL1QltmG7VWSH3zepHHbO+bGyugoEsb1sf4myI5eWwcZOXvdnzPoDhS8yz87IvtMgP4eAN
	DrFXnKmBXdI9C589b9wdrxnaijjuwcw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782827577;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rJ9Rjx2oxCe13upyd34kkQk5EfFLNjaZEIfhLMJe8gA=;
	b=MTd1LVVG2JksR13Dde965tW/yBNCAnLV7SLFsnp7S626j2vktvKLfPIgSQKbHep5sFFlVv
	I4RxeW2NvYGf6cCjAFGpxaNTl0WXQX4Ot91QAKomZKel1uC5FQyYYuTretLyZkqIi3fqCe
	ZXEz2KXZe9QJzP1xdE+51oZ5eC1Z5OE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ltadpJyY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AF858601C1;
	Tue, 30 Jun 2026 13:52:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EEFD1F000E9;
	Tue, 30 Jun 2026 13:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782827576;
	bh=rJ9Rjx2oxCe13upyd34kkQk5EfFLNjaZEIfhLMJe8gA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ltadpJyYu3rwXi5ugStfrcSEp69FAPdq2VEPHGQLdp+7ipYYrNM64wgZZk/nP7E/v
	 E3zu/crrDTc+8seyxMUwHPiBvZBVuEPNL0/UgjaCS6j5EuEtKJi+OEoH/WVZWKEkSm
	 vHqW4uwZirUe2XYDp+UMVQWhyQGS1A/kLpwIK9/SxAsZ92QqPha8wgsTsW9B/dAwqr
	 w4Ta0nxQ5QAvYUNnCizawK4dhMaMs5vbcepg2cSuySREG11W33O+2DAXAZs2R2eEnV
	 st9V2Wbs7ALSqouXeWerL6U9NzKDM9DxyFhHRTGGmD4+G9gdXxqZBRLOdLvmRD7uHc
	 1XbpqjMtKJFaw==
Message-ID: <06739dfc-8a30-4361-a8f6-6e81c99f2ea0@kernel.org>
Date: Tue, 30 Jun 2026 22:52:46 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/16] mm/page_alloc: relax GFP WARN in nolock allocs
To: Brendan Jackman <jackmanb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Mike Rapoport <rppt@kernel.org>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: Gregory Price <gourry@gourry.net>, Alexei Starovoitov <ast@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Hao Ge <hao.ge@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev
References: <20260629-alloc-trylock-v3-0-57bef0eadbc2@google.com>
 <20260629-alloc-trylock-v3-6-57bef0eadbc2@google.com>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260629-alloc-trylock-v3-6-57bef0eadbc2@google.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------65nHck7GCYTvNegZbzJ7HuGa"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 39F8080012
X-Rspam-User: 
X-Stat-Signature: 6pnxhog16b89sg6qrhs5u7rba5orjcmr
X-HE-Tag: 1782827577-429599
X-HE-Meta: U2FsdGVkX19zOmQVV18U/gv2bFSYd/zLkCo1JC+jA3kjBVKISSX/xXpRrA5u1aZAGNhsx/V04GgKRE87SRMhxtXqYMTjyMrx9OwIHJ8P0woLW8lDPyv5VwaqpAdeeqPKEYFXJHMNIcim3vVrLiVdw9cnELj/EcuLFotN4r88bOnx4GYt5Rv0/WK81JH/gLtcs7JSbqvpmcaFwRPi3a99frNBtBzx1Xw4HfLHiOBeLDZ4PN60RvYcJ/5eyh8TGUNwa8JlhF7AX8wbhopkvWj4zPwRLh/btiDIfZRuXQSPUrbKsnsRXc22YcndITIB6sGvR12Aozn4hhs5IgGTHNObGt+l9phQQX4NaebDkt5mQsqku/brbDzEGpJ+F1pkBpvsw58qI3VkaBP9PrR/bHoxTzXc1/YuUoqIyOLt0SNVx5fDGUolTZYzOGRtHcsvvkgrXY/F5eJgacv8SdPM3Zvtyx/WRg6oWO/jbM2Oh7useHqwd1twRdrAi24AOuBUzxNPE0ahA0sH+LfXwKnUxgOzSI/FbmsHBuSUwFfiFM75bwpoNqC1Js0n5lL3Lufm7QrjqBJ8X2aBPCvRpPZp9q4gXU6ZQ+JO+eAQqwqeAeOqJCZnRepy7lH6ZBLCyBJYmWslN5Kj63TELtBVNMM2xKWoH4jxX+two/TtQpe7wbuTLumkKPaD/FHfZJcTbIjIF6HOuezrpFmWVGBms+mveWK3tcdTKuFODXBbfajaWYnJmo58TFj2offQo/IYjqkFQs9m7HCqpOQy1lVZ2d82m+CcqePPc5SC96LhjyZgGMRflyRFVZJRIqaN2KMFTpL/NANIQlB9xo+xpvMJ4V4Nuyd7rMKq/SBHerhmXaonknB8GvzMxjsJgpz+GVx0s/QbwP99+v2jw6rtb6gztWWGQfn1v7ZOfU0i8GJlCfu6SrhpYkS/5nphY2NTciZZAev/twn7r6+ohqJ/JvSQwY3XmT8
 LWzM3zHz
 fReqiV/Y19Y8IkQScZ+wORKH/WzU9esA9+8FYPZSb7OwioYe0IzeZEa3ZK+xzRIG+9CVWUKMQ6aa0HElMWBAZ07FBfrwYYCkEV3a7FOrsXhZVh4Dw9uY0PA2EsrXtuuic6B08UdMQIkN7s7N1Kx14rmi0vLNuG7AFYRcpBDvpbbgYDn76gsLd5Zj5+7gRm1qJ1l3Kixy8RbieEcIjubLZRFRu8jK9VJTcA9HURySNMKQildOVq3GdGNEzPqF+e2brSn2HpFl8cUb75ysACCV1hBxc8umZ0IfTouAbJ50SH3so+u+b6N+9UDWXyYoaL2TVOzg178brfC0+yq1yexHPUBy55Kn/Hs4xUS/ENs9ock00/hIP7q93JORTfobdkGc3F21uJtGJ8fdKzAi5XmW/oKsnVdF7efzlNpkehh2Few8Ndn9hKzxInFXlzVjyZnO/9Vc8Zt2Wp1dk0czf3zx4UlfwRn+Y3d60EqkKrOfQMbRq7ElArFLyKIj4/3lZU8B1FNHd9jSn8TQ4ZWgts1KSLApDdfws51p0U8uDH20V7Tyr/kC++vxvL4vZmUDdIUO17qQMHE/1LR91yVm+4kJIibJetjVn0RBg0nAMUZv33ni2maAdrE4j7a1VD3Oevz2uFhPCUopmIIIVEPi+ok+acygZQgJ8euxPvilaVnI8fg0LwuTKRGUtjXBRWg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------65nHck7GCYTvNegZbzJ7HuGa
Content-Type: multipart/mixed; boundary="------------DCICTPcniII3mGZVq7GuAR9T";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: Brendan Jackman <jackmanb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Mike Rapoport <rppt@kernel.org>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: Gregory Price <gourry@gourry.net>, Alexei Starovoitov <ast@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Hao Ge <hao.ge@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev
Message-ID: <06739dfc-8a30-4361-a8f6-6e81c99f2ea0@kernel.org>
Subject: Re: [PATCH v3 06/16] mm/page_alloc: relax GFP WARN in nolock allocs
References: <20260629-alloc-trylock-v3-0-57bef0eadbc2@google.com>
 <20260629-alloc-trylock-v3-6-57bef0eadbc2@google.com>
In-Reply-To: <20260629-alloc-trylock-v3-6-57bef0eadbc2@google.com>

--------------DCICTPcniII3mGZVq7GuAR9T
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 6/29/26 10:11 PM, Brendan Jackman wrote:
> This WARN forbids setting other flags than __GFP_ACCOUNT but we
> unconditionally set the ones in gfp_nolock so they are certainly fine
> for the caller to set.
>=20
> There are other GFP flags that are almost certainly fine to set here;
> Willy noted GFP_HIGHMEM, GFP_DMA, GFP_MOVABLE and GFP_HARDWALL. But,
> nolock allocation is rather special, so be conservative to try and
> ensure we have a chance to think carefully before nontrivial new
> usecases arise.
>=20
> Suggested-by: Matthew Wilcox <willy@infradead.org>
> Link: https://lore.kernel.org/linux-mm/ajS96fWbG4dzP3u3@casper.infradea=
d.org/
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Brendan Jackman <jackmanb@google.com>
> ---

Acked-by: Harry Yoo (Oracle) <harry@kernel.org>

--=20
Cheers,
Harry / Hyeonggon

--------------DCICTPcniII3mGZVq7GuAR9T--

--------------65nHck7GCYTvNegZbzJ7HuGa
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCakPKLgAKCRCGXBN6rc5S
1sd2AP99B6lM/xRZNKq6HnXzak/9iQUkPa0fEXXgFpsu4yrecQD/XhpasXq5hRP3
/+MYghKl+3c5wsQObsmWJNub2XvDtQM=
=+zJI
-----END PGP SIGNATURE-----

--------------65nHck7GCYTvNegZbzJ7HuGa--

