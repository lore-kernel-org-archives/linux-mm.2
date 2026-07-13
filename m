Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4DDCC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:28:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E51AC6B0118; Mon, 13 Jul 2026 12:28:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E02336B0119; Mon, 13 Jul 2026 12:28:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCA0B6B011A; Mon, 13 Jul 2026 12:28:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A8EDD6B0118
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:28:21 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 340658C607
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 16:28:21 +0000 (UTC)
X-FDA: 84984286002.22.CD73342
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 71E5140010
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 16:28:19 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JGZH6yji;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783960099;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bzru6MD6tMP5Zrs5sR9HSGqg0+r+/7ONX3ynlP+FaEw=;
	b=7ajiN8g8weCqm5aESV02OUOdEcva6kbBX6AyeRJZs3EkXEUATRKzwJvshZ9O8FW9O8V6em
	p31iR1Io7bl8oOCeTNJn6yAvx0IX0AezdDE+Es4xOVlPrVWbczIMJO59IxEuQieufXlbUh
	NfRlNSbZcfE3YWkd/HL3olaukYcNqFk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JGZH6yji;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783960099;
	b=uHii/OmXG/zSqM3veWLNanW9M0uTXO31X7wMu48DaMoSn38DboAqRYPk4Y0KeD/0rOhkBW
	LD8ThazR77jHyRJYzXb6On1v7GmwCEl9MhtM3qNERFUPQCjb8985RqVQNMXMqxhwJej0gj
	pmjdYjlPFvDniUULhJYuRkhZFcyb+kE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7D03A417C2;
	Mon, 13 Jul 2026 16:28:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C61AA1F000E9;
	Mon, 13 Jul 2026 16:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783960098;
	bh=Bzru6MD6tMP5Zrs5sR9HSGqg0+r+/7ONX3ynlP+FaEw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=JGZH6yjiLr8UV0qa+IbknDrUCBr5K3XXUxhsUmjRRleb9MIQxzD0KZZ0kK6qCvwLB
	 g/+YMq6rxwFrLH0O4wCPZqqoOkBTCOOv6/i+PawUBS2vRLTfTfIWQM5gZxXEWDhF0y
	 Xk7JQ3ghv/q4pekTY2PAz1ULG6bF2rXKnm5A3ZDbVSkOUSiO7oGKHHvPfea+mDcbEn
	 IfbxP/1y01/1i+IFnbvG3lDOQxkFw+KDQHMkH1azy3VRCjMNEf/AdfwKQlRJI6Wcme
	 z8FYgnZbFQJQ3n9IXyUBjyHtd2q6D4JdFX/k9+As3n109jNabREf3ofTHjXLkfdM5n
	 tKs11qf1UugcA==
Message-ID: <34af7126-0a19-4da7-a3dc-4e6e0ae01ca7@kernel.org>
Date: Tue, 14 Jul 2026 01:28:09 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH slab/for-next-fixes v3 3/4] lib/alloc_tag: introduce
 mem_alloc_profiling_permanently_disabled()
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 "Liam R. Howlett" <liam@infradead.org>, Hao Ge <hao.ge@linux.dev>,
 Kees Cook <kees@kernel.org>, Pedro Falcato <pfalcato@suse.de>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Danielle Constantino <dcostantino@meta.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260713-kmalloc-no-objext-v3-0-47c7bd138de7@kernel.org>
 <20260713-kmalloc-no-objext-v3-3-47c7bd138de7@kernel.org>
 <CAJuCfpG=Dk6PRWy-8wR4j0UreSsa=fdiFWvBYpOkSZE0zV2Z4A@mail.gmail.com>
 <fcee1dbe-1109-44c8-a3dc-8aebc5569c73@kernel.org>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <fcee1dbe-1109-44c8-a3dc-8aebc5569c73@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------yM11ege9wS0qxduGjNyxQyUV"
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 71E5140010
X-Stat-Signature: hw4rhdn8qc61qf9kaqkwpzkytiq5inct
X-Rspam-User: 
X-HE-Tag: 1783960099-838027
X-HE-Meta: U2FsdGVkX1/AneRUKvrZEUUv9QDvaGItiinAkLVq80yrgIYTNCiExcqiipLy22i5wnGPFeTyaSaZW9Rj+fTCHqi4hsWloyMFCEUSzLbWHxdAny9M86LEF8PYceQ1JO8WM0/Kn0LlrY9q1FSNCJmfqGQsKnYoh858D0EVF68+dUPV4H+TdS9Aly9UAxAxBnG5JoYsqP8x81kRRQvjbUXKw51lAlK4naBnFETrCJmwnUKhqK7FBeJDm9ADIOACjIT5iHOplkl99Ef1GhssjA4WLVIx7q0ifvb9cbD6nvVNEtyE8fzp2GKH9o3dR1Oj4jZI5gv0RqghJeKBivdXA0ITrJ8wS7qzHh3hJ4SOaPsgoSkRzOO7ySIUo0WraHr1RckmocVFfzXPrk4UNJdX9LS2BNNXw3aHeSDqoYzJJk2BLO8+F/kkII2yKT5bXjI4MbKDNwmSX5OuZGoDfF3aW4GgWi3qD7VU04ap5Byu+hwTklYmAj4sThlCjd1gX/0gXcEx5i+Qmm54ATQitIfugXpJPESoOiOdB8n5QEe2tZrHeyoEfxjzZyn83lwiZFh8sx0phIZf6V2dSS0Ilx/vT/6ariIguqNPkcfhXYD3vydi8toNXibxgFx1etQpl1UMSlpYKmA0Hkrt++PNkjgKzZ3GjZkNdRIT8prba3BAYhMQi6gSsUMXx27KO47D6BXt4IoarhWYmeED8KyoZVOIqifVxGaXUoClcarR8pCe2+PZVBy/cA//38sOLYF6De1BXmm5gCmhF0C/ik/xpzpVBu+zEPVjFc+fNDRJbjdNqdHJXrC8OaIzXGNrEorHJRF46d2sS8KK+M81ZLPhfC8C1EvzUM5+OU1o8TnbeJcDZvlip80MzOyPhaErtdSO/mMyI3LE/IWLoh2Tdha1C9YW0Y/WQ/A0nEGvQGwViPuA+s1v6H0gRWpx84a3z3ehs8wB3cF7AGYlYC4xKFwdSNCsH/6
 h9ypOUZM
 mXeItb2heYpCaG29miFEt8haWhYuOK1YmUZFJx7bY0ceYt3sNDrk/NimlTFknIRvDNq1uSNiyL2soINuNa8zjVSiat818CYqAgf4vBJzJX6xXZcygdRjNgD/faP07kD6kJ15o4aVMzgAqAvaQVKjZuaG1Zk3oRIKlV8uC3zbQcb4FscXmDbDKwcEGOWPnzpwdHAN9ArxAa7fJMtIxp20i/1XZgXXPsIhM0zwSTHceyaEkVCGPH6L3uEyWD787evTD9HwXDXxcjHUa0MUpGMDmjlb+LFrjk8aYvCLYrcUl54z5mEDxDfXJU5ou9oj3qrCxueqH2CSYQ+ysxVYmB2fJkf5FG67njzwK3pyRECxzd2xGYlFCuaO17WsLlFcf4DgA6nEqP7wrnKf2VDDtqtxjtYol1jDo9+vk9sASso117BVh0Np1+JTCMPRBmr6tNn07XZWCZk+cv6/emLH4stp8ONS2JslTi6XF52xAuaVv3sB6DDUiFgH1hVdDRpH+Km4DNw12zeJEQHZNvN/ECcCIzwfjgoB4uyfqaZreIQSLh99lq6Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------yM11ege9wS0qxduGjNyxQyUV
Content-Type: multipart/mixed; boundary="------------QPtYmvYQljrwPUH3mcfP0W4m";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 "Liam R. Howlett" <liam@infradead.org>, Hao Ge <hao.ge@linux.dev>,
 Kees Cook <kees@kernel.org>, Pedro Falcato <pfalcato@suse.de>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Danielle Constantino <dcostantino@meta.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Message-ID: <34af7126-0a19-4da7-a3dc-4e6e0ae01ca7@kernel.org>
Subject: Re: [PATCH slab/for-next-fixes v3 3/4] lib/alloc_tag: introduce
 mem_alloc_profiling_permanently_disabled()
References: <20260713-kmalloc-no-objext-v3-0-47c7bd138de7@kernel.org>
 <20260713-kmalloc-no-objext-v3-3-47c7bd138de7@kernel.org>
 <CAJuCfpG=Dk6PRWy-8wR4j0UreSsa=fdiFWvBYpOkSZE0zV2Z4A@mail.gmail.com>
 <fcee1dbe-1109-44c8-a3dc-8aebc5569c73@kernel.org>
In-Reply-To: <fcee1dbe-1109-44c8-a3dc-8aebc5569c73@kernel.org>

--------------QPtYmvYQljrwPUH3mcfP0W4m
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 7/14/26 1:15 AM, Vlastimil Babka (SUSE) wrote:
> On 7/13/26 17:43, Suren Baghdasaryan wrote:
>> On Mon, Jul 13, 2026 at 7:29=E2=80=AFAM Harry Yoo (Oracle) <harry@kern=
el.org> wrote:
>>>
>>> mem_alloc_profiling_enabled() tells whether memalloc profiling is
>>> currently enabled. However, even when this function returns false,
>>> it can be enabled later.
>>>
>>> However, this is not enough. Some optimizations can be applied only w=
hen
>>> memalloc profiling is permanently disabled. For example, to skip the
>>> creation of KMALLOC_NO_OBJ_EXT caches at boot time, mem_profiling mus=
t
>>> be set to "never", "0" w/ debugging on, or have been shutdown so that=

>>> it can no longer be enabled.
>>>
>>> Introduce mem_alloc_profiling_permanently_disabled() for this purpose=
=2E
>>
>> nit: I would call it mem_alloc_profiling_supported() but this name wou=
ld do.
>=20
> I wouldn't like that name, because _supported to me sounds like those
> CONFIG_ARCH_SUPPORTS... things and not something that was just disabled=
=2E

Agreed!

Actually, last year I wasn't sure what "_support" in
mem_profiling_support means and had to look at the code while fixing a
bug [1].

This year I forgot what it meant and had to look at the code again :)

> I suggested mem_alloc_profiling_unavailable(), but it's not ideal eithe=
r,

Hehe, in terms of 'the meaning is obvious without reading the code',
it's not very straightforward...

> naming is hard.

Agreed!

[1]
https://lore.kernel.org/linux-mm/20250624072513.84219-1-harry.yoo@oracle.=
com

--=20
Cheers,
Harry / Hyeonggon


--------------QPtYmvYQljrwPUH3mcfP0W4m--

--------------yM11ege9wS0qxduGjNyxQyUV
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCalUSGgAKCRCGXBN6rc5S
1ixCAP9FE8TE8I5tHLN3kWxg6Nty1cqIAwla2PwkZKSDiqRyUgD/Yf2lKeJObRfT
RQjKVDRu4qpO1fv4/JCjlt89DtQdCwA=
=jIHI
-----END PGP SIGNATURE-----

--------------yM11ege9wS0qxduGjNyxQyUV--

