Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18F9CC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 08:21:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFB366B0005; Mon, 29 Jun 2026 04:21:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B853D6B0088; Mon, 29 Jun 2026 04:21:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4CC56B008A; Mon, 29 Jun 2026 04:21:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 774626B0005
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 04:21:00 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EAB451205B0
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 08:20:59 +0000 (UTC)
X-FDA: 84932254638.03.2B17D25
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 3A488C0003
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 08:20:58 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ALYdjdHR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782721258;
	b=w8CSanKz+KkH2lMXjeeWFFntP12xAtAVLg75Cf03RxM3cCvIdTBNPr1EePsorYvm7UJhBi
	MeGNaOGDOrhinJzTMoWFiV5DFfxameOXwhk8YPmKQK5TwKCOxmmTwMVNKJM/R4VIkBXap3
	XYU59PsoPPZYIVn76FoBSfj1r/4IJ8c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782721258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kia53t9Vmn3rVHR65dB2hSoGJC+kCBm9nZndKzrlbpY=;
	b=31N8hZZMzY9dCpBmbfcSjvE5FN5usrBRuQb71aktwXMq0WSeLxBXO4pzbDlWNavRayFf+W
	88UyXB3lnzJ88pGhOcK/ihfXS4gUL5Ngw9xknKbc4P3Z2qEZaOYc76i/yXdA47LKOZjbyV
	4zc2Ibi6MJTlCyUKtuLDIcVGDXSgvh8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ALYdjdHR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 64E7743D34;
	Mon, 29 Jun 2026 08:20:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F287B1F000E9;
	Mon, 29 Jun 2026 08:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782721257;
	bh=kia53t9Vmn3rVHR65dB2hSoGJC+kCBm9nZndKzrlbpY=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To;
	b=ALYdjdHREWYrGGiSraB7MR+uJIezD9H8RD62KChSKPY5qxgXGXnNPOmA0XJMurrdl
	 AkcvDW58TEZEpP1VIafI87KjnUhZDr6+wuOVo8M2U+CPKAURCoIRpcaz0eUU0pIy+x
	 Nr5nn+rpu7fQ2EyjOORAw0sP6LIEf5fSon8WkphyJmSJCzTWa+2f7PMN3A1rKTklKR
	 7tfSSATNMl2tmIcJh72y3vqvLxCEGX/i3vIpmOHpyUcauAEPrMJVSHvsuJAAoFlyg8
	 ZHcQH4W7mHA01/DLNoviNonduxaiLIX3gsV2xK9uh8cMi1ilmE4nEQTdUj32wpg4Kg
	 1Fn3sX7B19hVw==
Message-ID: <b48c8045-2297-47ee-a0f7-d7a67e74ea09@kernel.org>
Date: Mon, 29 Jun 2026 17:20:46 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH for-next v3 2/9] mm/slab, slub_kunit: register kprobe to
 trigger _nolock APIs
From: Harry Yoo <harry@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Vlastimil Babka <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>,
 Puranjay Mohan <puranjay@kernel.org>, Amery Hung <ameryhung@gmail.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 "Paul E. McKenney" <paulmck@kernel.org>,
 Frederic Weisbecker <frederic@kernel.org>,
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
 Joel Fernandes <joelagnelf@nvidia.com>, Josh Triplett
 <josh@joshtriplett.org>, Boqun Feng <boqun@kernel.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 rcu@vger.kernel.org, bpf@vger.kernel.org
References: <20260615-kfree_rcu_nolock-v3-0-70a54f3775bb@kernel.org>
 <20260615-kfree_rcu_nolock-v3-2-70a54f3775bb@kernel.org>
 <ajvczSpMOGWFhe30@pedro-suse>
 <6edebc2b-5f5a-4b9c-9a4c-564310acee1b@kernel.org>
Content-Language: en-US
In-Reply-To: <6edebc2b-5f5a-4b9c-9a4c-564310acee1b@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------8xQSbLfkLa3QcHTEy0A3WfM5"
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3A488C0003
X-Stat-Signature: kzrjnbye7kejuiujw6ubz5tias7mzaer
X-HE-Tag: 1782721258-577279
X-HE-Meta: U2FsdGVkX194cNv0ZUtEAoyJlyjKcmsS2ngUoFSXHyB4Wv1vCcmyhWzHwcjgRm5nCjKdc///nOjK3L/my7J1ATObOfcH7b0yXKA7y5inc7mo1AT6umxRDUZKWwtGxNRwKgHfVvchFKBmr/mzkwoE/KAwDcPNN9dEL9Z15PAmtrRpQKL5qqyUrRP6KZj9yyeVM+VVz/Co3o+dFdREQyG5QgYPKseMB7S1a3PNHC16t1RZkwckNrkPMbYlvuv3d7LrD64y5NqnAZc5SRD8PC+nQWbptiTgl1B5NYL287LtUHqh+Z3XyyLpjkg61pKnYPFHhgMPcFEKgQmFCTNudMR1ModOxqCTq+zFya6Rwnu5PXT0QyHHq431SBYrMWvzv1kGrx36nw1auQVlJXidsKumyw8G1TIY+hdyzYShbwxT1tfwDYU/N65/fxLv2mLRf4OuSRXMJThfWJMYWqwxwUpJ8tofdIFOoFgQ4Yeh58HAXb7YA/VCwMYNqJHi1uT0LrgkHFBjtKKBqwppHUnL6AxstAvUZZtHO5xSz5chPdwuQupAluJ9KvkQfkXhKzJTE8gJzkeQdlzrvKSShdjcbRl024YmeGph3jZXCE68hGga3+VnBQyT9A64K/fOMBHX1zBWU44vVvNkEb4Pp256ywSmImehzQHICN1BuLtynuXGqINMRErazXRAxiQ0PGxdLfx6HwJrMuVFfsFKrRQfge+zxUCOhI7eANPret2xSubWGnKQEAOlpU03/gcAJO8qG9bER7E/kWZQbm6lnyvImQB1SyA1yIyGPCJ3tl1MDBWR8Hw1Hp+QQpq7cHCPasvrt9HsbLYqam2ymgn/jv+nEVNhSlObNfDzHQ2mqX+9qyzWk4NhP69lSeAVc2NvTooDvcsHnE+pF8mUIbDcghXR0BWnw7jZGfiKuEwE5f55267S6snNl+vybrG4ulYCx7GqHkMAnmfTWB3AfSzLLd/D2Y/
 eclfYybG
 BsRb33gn5iMt1ER36m+3QvK6cHfDv9kP+5L+juilssappi7yGywxB7qwpnC4p1vNv6rP3j2Uu6FEX++HfOKwiA15BV/THq7pJLsU91uJdGkPzjJzmKfj0heplzfhkMVXXWT6/ByGanUImwZqj6co54UXvpDp5e9Kcp9lAvHCjUG0u3GG5koRejMt02F2BQGpZg4BltR9aSc/8EKvM/2mYTnVe1FH6c3UhxEvhunwfNyqCXe0IU1rCtzQjErXpwnaFYsgXG0Wenes/S5OBlSzlH0qu23juTdC1LdUgW0rr0zrAeEM714Z173uM9+jUS0U3UxkrjQSZidYbexkYAv5W+XlHYkb6z8vIPsn/HVYCz+nZg2WxseJuBEfr+9yBV2/1G6hVC3xxr5RI35Iy2TKl9d71n5boQHrFEKqrAfpIQQRbRnIsQjyMCnjqUGSy+3FAHKiigcYJh1uU8mfFopndTm8U3Zf2dr29f7MlHsW8gDo1OwO/t5fyTH5j/2/smjX7eFNV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------8xQSbLfkLa3QcHTEy0A3WfM5
Content-Type: multipart/mixed; boundary="------------H7l0hVTepAgAY5a6Xn02vj04";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Vlastimil Babka <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>,
 Puranjay Mohan <puranjay@kernel.org>, Amery Hung <ameryhung@gmail.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 "Paul E. McKenney" <paulmck@kernel.org>,
 Frederic Weisbecker <frederic@kernel.org>,
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
 Joel Fernandes <joelagnelf@nvidia.com>, Josh Triplett
 <josh@joshtriplett.org>, Boqun Feng <boqun@kernel.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 rcu@vger.kernel.org, bpf@vger.kernel.org
Message-ID: <b48c8045-2297-47ee-a0f7-d7a67e74ea09@kernel.org>
Subject: Re: [PATCH for-next v3 2/9] mm/slab, slub_kunit: register kprobe to
 trigger _nolock APIs
References: <20260615-kfree_rcu_nolock-v3-0-70a54f3775bb@kernel.org>
 <20260615-kfree_rcu_nolock-v3-2-70a54f3775bb@kernel.org>
 <ajvczSpMOGWFhe30@pedro-suse>
 <6edebc2b-5f5a-4b9c-9a4c-564310acee1b@kernel.org>
In-Reply-To: <6edebc2b-5f5a-4b9c-9a4c-564310acee1b@kernel.org>

--------------H7l0hVTepAgAY5a6Xn02vj04
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 6/29/26 4:34 PM, Harry Yoo wrote:
>=20
>=20
> On 6/24/26 10:41 PM, Pedro Falcato wrote:
>> On Mon, Jun 15, 2026 at 08:05:56PM +0900, Harry Yoo (Oracle) wrote:
>>> Since kmalloc_nolock() always fails in NMI and hardirq contexts on
>>> PREEMPT_RT, slub_kunit cannot properly test _nolock() APIs.
>>>
>>> Register a kprobe pre-handler to invoke kmalloc_nolock() and
>>> kfree_nolock() in the middle of the slab allocator. However, do not
>>> register the handler on UP kernels [1].
>>
>> Maybe explain in the commit message why that is?
>=20
> Because it's the case is broken on UP and we decided not bother to fix.=

> Thought the cover letter in Link: would give enough context.

But I will clarify this on the commit message, thanks!

--=20
Cheers,
Harry / Hyeonggon


--------------H7l0hVTepAgAY5a6Xn02vj04--

--------------8xQSbLfkLa3QcHTEy0A3WfM5
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCakIq3gAKCRCGXBN6rc5S
1oI0AQCmD4+FAnCL5s0WuOSoFo5XR/5TKwqVhP08qfsAyrwXvwD/RJBmV5okisfF
oBc6p+YW15g8jrEgvQwjI3qwgz+UDgw=
=v2D6
-----END PGP SIGNATURE-----

--------------8xQSbLfkLa3QcHTEy0A3WfM5--

