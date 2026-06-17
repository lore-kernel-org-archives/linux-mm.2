Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FE93CD98E1
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 05:14:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCA6C6B0096; Wed, 17 Jun 2026 01:14:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7BDA6B0099; Wed, 17 Jun 2026 01:14:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6ABB6B009B; Wed, 17 Jun 2026 01:14:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 769F46B0096
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 01:14:44 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E3F7F4033D
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 05:14:43 +0000 (UTC)
X-FDA: 84888239646.29.FA57334
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4192340004
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 05:14:42 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Vq5KoxGj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781673282;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i4gI8nBuxA9HRcUwNvotK2yH1/Y4niKmJ4bOseHnoOY=;
	b=cRPzY6iLC4oFUbLinKqEHooTATAjYUC9imOjijFaypjWbXdvkKu52RbO+wM6aAgVyUeiQu
	xtQLoJb1I9WmU6LP1pSxTUnm6Io2q2HW/27ysR5K8CCGu1pnn0rZkv15JPo9Tqlvis0GmD
	gHkuzX7RltgoJtVv+U1vjghdKkG8oNw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Vq5KoxGj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781673282;
	b=GzeQHyNOfUuEfRilROuElyG45uSqFc7gGe4wq4Pvmk64jT4rEILlKDAfmRAwLyagn1xBZg
	h7/NFe8NlHmgUk31W7OTXVDOYjVlWuitn+ASaqXSU554wn7HC9niBFuBMgHN76lnoeq9iz
	2FHBI/hdXo/gKOkvwDrxjKTSt4pMRXU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 75B24600AA;
	Wed, 17 Jun 2026 05:14:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5991F1F000E9;
	Wed, 17 Jun 2026 05:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781673281;
	bh=i4gI8nBuxA9HRcUwNvotK2yH1/Y4niKmJ4bOseHnoOY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Vq5KoxGjOeZU7bfYcs6X2ic2+hFhWSKqGgqfdCjVZy2jo1ZH3yXx6tBFJUGVnDLPq
	 FRkbuYQdKulgt+hMMWNOJ6rg/hgsSsWtQgRZBsc8wIALCQdjtTY+90vF3lTjx+CJ76
	 gc7RwVd0S2MmHruzJzyn/jJf3x+enPN8Yk/c3tVX11PsHcEakhw30+CDNpaiGZxbLi
	 vo2iyxTE4uBv23I3XtYp5Km71YP+rjdtnogZPG5Ynv8IuBnmu/0SrQfqKiazfIrc2K
	 MzKx0UlxQIeCPhRWYE7Rlj1opOvG/qB7x+PPd2g3llsJgPCPP5lcop1iW+bs50TTtT
	 3GVL74u3KPyoA==
Message-ID: <40591888-3a87-433e-b3d2-cda1cab543be@kernel.org>
Date: Wed, 17 Jun 2026 14:14:16 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH for-next v3 6/9] mm/slab: allow kfree_rcu_sheaf() on
 PREEMPT_RT
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
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
 Pedro Falcato <pfalcato@suse.de>, Suren Baghdasaryan <surenb@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev, rcu@vger.kernel.org, bpf@vger.kernel.org
References: <20260615-kfree_rcu_nolock-v3-0-70a54f3775bb@kernel.org>
 <20260615-kfree_rcu_nolock-v3-6-70a54f3775bb@kernel.org>
 <f3a56a5a-f10b-46dc-bc99-28449ade1661@kernel.org>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <f3a56a5a-f10b-46dc-bc99-28449ade1661@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------kEBv9bKx3bhSjfXvp2FnnpK0"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4192340004
X-Stat-Signature: ea8uqdqxu48be4obfed85a1i74ppeh6r
X-Rspam-User: 
X-HE-Tag: 1781673282-643878
X-HE-Meta: U2FsdGVkX195mEro0/hGQbLU9VFjBFk/H6TYEhuonYGiiGbN/MU51NwFdTQjw1ipkHXbCHCYSBWrJCTC4DwkU6ZritOoTNIXlcVSOb6Ynw7oYGndRL878e9BaYCqTK3OjPdifzMa5qti9TBJ5XutxduzoqKw4Zgwl6Prtw2s57llEdSNzfyNKifU6bvc1Fd1BtD/aZsyiSZGi5DZJS0RlclQB3uQDloDBLHruo+ydMmFp4svTF6Ot+vAqiuqY+nRCohVGnthE1pEANEqfZLd8aGYT2rXNjN3uTPQDCXgo12nKn9wk64/nQBTS+VneMyd5A5UkPN3fjsEq0ITpYNHJ6yMg2UjZIQPYa4T+XM77qWkLje8nWZaHUE+MUlMMbz8fBb84XL6iUPNn7dNbZrC1Mi7dEUJtFB8k3BMvcFXMhtIs4u94Fm+BuThgdbNg8StwGwgbV2fkxa7AXQ3YfYpeMC2ebo9gZNK7XVBPP63vNuoruVru/QvzR3wgTt+yyiK9btAi5WQbtYs2RgLQQ7W4MdMzhZuR/H3G18oi0E0AtSV9Ik8N46X7VsA51Z0cGjjgAw4nzpWy2wbMPkO4PQYswg+A7j+weTO5a7dYhqxL5ILvxP5nHIviiBVW8upzKvKamHXMnFddkwbwaovhDDyiKsnH/U//R55+RTTBMWQJgxrlEergP2qGsXmN4rhKtcLnalrIuMRIiBghG/H19Kz7ptx6GEcZni+No7ww2UzOLe1KFJauanVuXJjgM3CHA21s9qdW0W5et6Tb5YdrSkSkP2uYXq8mTG7v9QfzDm5vPtskV56giKHNEVXiDUw0fdEkuPBZ7NNsrXh8bMUrXKjZyKKzqux1hTN/CABjMzCh5DwhSELwoq00KfF6XfEz5CgaJqM7KEuO4wJ9zlPzVxzzldD1rT6aPcGv37tAXdhxg1l/CH5POxdCnyiWWCBjn+MaQlvWLRNQb614vDJFqt
 j3zA94wq
 EffQRtTPrFXoZXfnN9+CbHHg4hEeubW8j+v5fTZLSsawdO5zxDm6sLgQ0PWwa4JtvnOXrj6Jg6Tha4ZQqcYGIVT3tN90O1nAeU+Vh78/sEmwPNbRd6/2aIEy6r/qsrA5eqCJcDFKmFURY+FCSHaXdlX3gDZtufdK1Ex/k5XKELjDSKHfwjPhPYUD1IaIKqWIZH+pz9QpYBTyUWTE3p2q1S6LMGRj4xYBQ+dKJJMS/5/wFWe0kAVLalh86qnJGDeAZqI9xoL64G1g/YER0etQRBNGSdBNQ3A416lSJ0Cao+b664SWcEgckqAJ8R/r5VrG3FBgu5BjOfmzjr6UgzE8O8FRcwTIomROMIosYNughBPMy8nJ0cWlkR3N5Qw1I4ZClTR3sz4bZU9WPzoCEWD3YhRCV7s02Uu77TB+i9Y65xYr5BI/WEelMrGXNdbf6d+GYlascPnYuVypJNNeMwJR7w9JTTbxRZtESssrQNenb6dnGFP74hmbAgxAugPkyx+/l0+u1BZht5W6nEMGlCgOu9KsNOg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------kEBv9bKx3bhSjfXvp2FnnpK0
Content-Type: multipart/mixed; boundary="------------vb0IaWkZAOplq9hp2tUYiTMN";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
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
 Pedro Falcato <pfalcato@suse.de>, Suren Baghdasaryan <surenb@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev, rcu@vger.kernel.org, bpf@vger.kernel.org
Message-ID: <40591888-3a87-433e-b3d2-cda1cab543be@kernel.org>
Subject: Re: [PATCH for-next v3 6/9] mm/slab: allow kfree_rcu_sheaf() on
 PREEMPT_RT
References: <20260615-kfree_rcu_nolock-v3-0-70a54f3775bb@kernel.org>
 <20260615-kfree_rcu_nolock-v3-6-70a54f3775bb@kernel.org>
 <f3a56a5a-f10b-46dc-bc99-28449ade1661@kernel.org>
In-Reply-To: <f3a56a5a-f10b-46dc-bc99-28449ade1661@kernel.org>

--------------vb0IaWkZAOplq9hp2tUYiTMN
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 6/17/26 2:24 AM, Vlastimil Babka (SUSE) wrote:
> On 6/15/26 13:06, Harry Yoo (Oracle) wrote:
>> As suggested by Vlastimil Babka, kfree_rcu_sheaf() can be used
>> on PREEMPT_RT if we always assume spinning is not allowed on PREEMPT_R=
T.
>> This is because local_trylock and spinlock_t are safe to use with
>> trylock variant as long as the kernel does not spin and the context is=

>> not NMI and not hardirq.
>>
>> Now that __kfree_rcu_sheaf() knows how to handle allow_spin =3D false,=

>> relax the limitation and try the sheaves path on PREEMPT_RT as well.
>>
>> Keep the lockdep map on non RT kernels. However, do not use the lockde=
p
>> map on PREEMPT_RT to avoid suppressing valid lockdep warnings.
>>
>> Link: https://lore.kernel.org/linux-mm/6811cc17-8ee4-48c8-8cbf-6bf4d9f=
98162@kernel.org
>> Suggested-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
>> Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
>=20
> LGTM, but maybe unnecessary pessimistic wrt call_rcu() on PREEMPT_RT?
> I thought (in the Link: above) we'd only need to downgrade allow_spin t=
o
> false on PREEMPT_RT for handling sheaves movement from/to barn and
> alloc_empty_sheaf(), but call_rcu() would be safe from kfree_rcu() even=
 on
> RT?

Indeed. Good point, thanks!

Hmm, but I'm not sure that it's worth the complexity given that
PREEMPT_RT tries very hard to avoid disabling IRQs...

> Or is the irqs_disabled() condition rare enough so we don't care?

Given that most users don't call kfree_rcu() under raw spinlock or
IRQs-disabled section on PREEMPT_RT, I think it's okay to keep it as is
(it's not making things worse, at least) and wait for call_rcu_nolock()?

On a side note, I don't have much idea on what needs to call kfree_rcu()
under a raw spinlock, other than set_cpus_allowed_force(), which should
really be using kfree_nolock() instead of kfree_rcu() once we support
kmalloc() -> kfree_nolock():
> 	/*
> 	 * Because this is called with p->pi_lock held, it is not possible
> 	 * to use kfree() here (when PREEMPT_RT=3Dy), therefore punt to using
> 	 * kfree_rcu().
> 	 */
> 	kfree_rcu((union cpumask_rcuhead *)ac.user_mask, rcu);

Any thoughts, RCU/RT folks?

--=20
Cheers,
Harry / Hyeonggon

--------------vb0IaWkZAOplq9hp2tUYiTMN--

--------------kEBv9bKx3bhSjfXvp2FnnpK0
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCajItKAAKCRCGXBN6rc5S
1jLFAQDJjkqWNsckxRckQG/ifpkFidi3A6aFYgVvzxCG+/hQQwD+LUnZJI7/+UOa
K4FDOVTUA6hwmP3OMAXM1Q1fH4PjOwM=
=nbP0
-----END PGP SIGNATURE-----

--------------kEBv9bKx3bhSjfXvp2FnnpK0--

