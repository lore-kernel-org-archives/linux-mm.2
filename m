Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24AEECD98F2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 12:46:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E61D46B0088; Thu, 18 Jun 2026 08:46:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E12CA6B008A; Thu, 18 Jun 2026 08:46:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D013D6B008C; Thu, 18 Jun 2026 08:46:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A5C106B0088
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 08:46:19 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2DD60A0418
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 12:46:19 +0000 (UTC)
X-FDA: 84893006478.05.9B82140
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6EBE240011
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 12:46:17 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z+aV6eXH;
	spf=pass (imf12.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781786777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=12/PAUDTOYfrkJ9zjxNjbQQEDZEGb0acxRasEquNV8c=;
	b=TsrwDX4NPJ+eRWIz0JWFavqX3UkNbArABLbvSB0cGqeiSTPW9CCQSIhguJym4PUA78ERuo
	/adHnfCoHNgGdckyVBaee7Cjdewi0At2ffdKSGPIdwaVNiWYyHI0OUn24WwKbJ1+B6XHjM
	2uYY/7GjBBLrnb20Fba/zcljK/OwciI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z+aV6eXH;
	spf=pass (imf12.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781786777;
	b=kqGWD95z6jpTae6MLDUvj3ZRaRZ2BZj+fZ1DA3Hx8yXpezJvhSP3nmWDI8Nw3P3HD4uvHd
	gPIGJjDBIWgdXr5yQMaxNH8sTPE983ApwFG0aRclfgvsR11ala+wOoEp8pMmer49KvwbZS
	YpZ0gzqXXt6s0ikDyQhBexfJu/S+7NE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 784A5404F6;
	Thu, 18 Jun 2026 12:46:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C5301F000E9;
	Thu, 18 Jun 2026 12:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781786776;
	bh=12/PAUDTOYfrkJ9zjxNjbQQEDZEGb0acxRasEquNV8c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Z+aV6eXHEz7VlgrnsQQ03Z+8Zb9YcjYrK+HMqvFJSpghpQu39jthl+uUJoATiBkss
	 cleXhnjiOavl5FCxDhBVQWY7nkZniTKAC0EuFJs3M8ryMmM/JL3AkWqL2pQ8oDPyv+
	 zpib5/x5p9qKtSzJlegXic5z4V9LWD1qQKFyo0/gZJp/nR3M9tVuPj97b9I+Lw9yAo
	 1g38OX4/l8gaWl5SUjYY8xERklp7FAUfYxtp7lWExEAizO0VVPy6AignHbfgZxs3Wt
	 YMQqE/qAAJIRPfXMLSJqgTvxObnFUQnnscTGGxSQR8K5+4YNgi0J50dUn99G6+7MqP
	 DwgptAJDbbzow==
Message-ID: <39758d58-f646-470c-9c35-818ac75427d3@kernel.org>
Date: Thu, 18 Jun 2026 21:46:04 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH for-next v3 6/9] mm/slab: allow kfree_rcu_sheaf() on
 PREEMPT_RT
To: paulmck@kernel.org, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>,
 Puranjay Mohan <puranjay@kernel.org>, Amery Hung <ameryhung@gmail.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 Frederic Weisbecker <frederic@kernel.org>,
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
 Joel Fernandes <joelagnelf@nvidia.com>, Josh Triplett
 <josh@joshtriplett.org>, Boqun Feng <boqun@kernel.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>,
 Pedro Falcato <pfalcato@suse.de>, Suren Baghdasaryan <surenb@google.com>,
 Peter Zijlstra <peterz@infradead.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 rcu@vger.kernel.org, bpf@vger.kernel.org
References: <20260615-kfree_rcu_nolock-v3-0-70a54f3775bb@kernel.org>
 <20260615-kfree_rcu_nolock-v3-6-70a54f3775bb@kernel.org>
 <f3a56a5a-f10b-46dc-bc99-28449ade1661@kernel.org>
 <40591888-3a87-433e-b3d2-cda1cab543be@kernel.org>
 <9d8ca1ed-bc53-417f-944b-d78eecd1e6a5@kernel.org>
 <03da8742-3790-4428-84b8-11911bf44c9e@paulmck-laptop>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <03da8742-3790-4428-84b8-11911bf44c9e@paulmck-laptop>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------r52TW6tkzMED0vgUCNBCiTch"
X-Rspamd-Queue-Id: 6EBE240011
X-Stat-Signature: mawuoe5i1q96gis36xbppnexbtu7k9g5
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781786777-82678
X-HE-Meta: U2FsdGVkX19YK37xD4T0OUahfzWKD2hTEgdg5Cb5mAEgO3Mu/VCOB3vHauVbgtT+ai0R1Z1ETSUTWqaCJy985IX8QwXPIibBjCvirQSYMAmY7dAT/Ziy2tSFuW2OU/Kre38qb5sZ8DySdWy5wszOTckQOUjB09QfrseWzS5diCVZZzXrFV0pYH394H+GYzKo+zGxbqcXU8CS39cqZoi00NhM3sie5H0Cg2FI3YaamC136rxLQ/TLT6W4d7cjrZ/2FzUMvh2YrHByQ9dxgpvTKrue6ednZFvbmGspEf+ERpS+yNmsWvwagDpMzH7n3x/a8Asi9Ho9UAIXTYKQS6i96kXDtk/kZeteuw70OcdDmng09SSPwoZAOEt5H34NIYdkqL560i/XpZTWnBvE20crC59pW7DenToOMVPw99knIs7ZIvrnh+kdJjSZORJWnl0EtLPMkbyOoFX7Ijx+6j6wUIadPyBFYvkNytypcdm7uGpiuJBi56qF2989f5+esfgpRG6jF/Sxu51QWTnwAZHnwTrgaamrrROXAyadKIeN1lw8IOOdMdCUyOvPkl24YRsIRyFpDnoVyWCbcCoZBifdhAuS4WtY1zJzW4FrBapFqhqTj3I/mlatlri/1Qmv/dk/yks4VyVLga6Mh6wuga+3Vvjwr5tx5VdQ8O8nWPquUgCuyBTTB0hekEYXAFEKB3LU9+pYkHbhOM5SHHnol+zIE1P8S0JjSz8BwfGfyCJUgjW+n7fJEQw7Dnr+p0Hh+LJdr+WCdTulVCqWNIhrswh9HOlNO98wdrmvhtzZHwd12B2H/x3srHXcxrF3h9pnrVYJGsIePMir2gh7SprQj3mfB0nfPEPkG16lbyHBrjpIpcVB877P0q7VATZJb/2Pg14fh4mWUthMmHgFnMTqrJHLoQ4bPDFO+gsl13I2NAefzrmk65lVJwW2Md8mXUO2UUoc+90WnKzKvc3qhwv8pgF
 IYSoDubI
 2af5ChnwPWq1Iq6Q0UjfcwIIgR4eez5OIqmgNUKZwkytuAUqZpsrlp7HPvBPBbjrFWPcbu4XbDxpuFcXseXDRvg3eSUy7Gh7MZNOdU2zIcHrSITDXXaiV0QUKuKn1yp+J1rr9Cnu+GQkH8PljgjXhMI7QGiCIqWM3s79UVt2vErqUP8pjJq7DIekVHBpLAZHWCiSLjJwtnMjKjKrXy4RAV+i4W4z1EK20OqQLa7itwvBm2Vk27N3yuSJSxhehgmMA+qA5PvOYBUivRTKK3RFqrIGQ5FwP4O41NY2gGOL/MPWIfB0J3u95h/AVy2ZE5PCHtWJLPhd64vx4rGiG7zfLWnz4O/3F258Oe4mddJg1X6zmRM1hf5vO6J0z2S3T/aUzW/0Ro3hytFlRK6LeQ7UULldizBgdHt0a+sG5cCmN0V8xdf4MVZV4R+vFA4e5PHPyicI65MotiMuhIeLwedm7/Fgy/RhQ22/CH9YrQEA+ypZ1AW/FJZB0YJCnxYW9DYEqTvtpQdjpkZ8nsEiiyWS3gQx6sw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------r52TW6tkzMED0vgUCNBCiTch
Content-Type: multipart/mixed; boundary="------------CZDOJb3QDvzu5IEDZMoq1w7C";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: paulmck@kernel.org, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>,
 Puranjay Mohan <puranjay@kernel.org>, Amery Hung <ameryhung@gmail.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 Frederic Weisbecker <frederic@kernel.org>,
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
 Joel Fernandes <joelagnelf@nvidia.com>, Josh Triplett
 <josh@joshtriplett.org>, Boqun Feng <boqun@kernel.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>,
 Pedro Falcato <pfalcato@suse.de>, Suren Baghdasaryan <surenb@google.com>,
 Peter Zijlstra <peterz@infradead.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 rcu@vger.kernel.org, bpf@vger.kernel.org
Message-ID: <39758d58-f646-470c-9c35-818ac75427d3@kernel.org>
Subject: Re: [PATCH for-next v3 6/9] mm/slab: allow kfree_rcu_sheaf() on
 PREEMPT_RT
References: <20260615-kfree_rcu_nolock-v3-0-70a54f3775bb@kernel.org>
 <20260615-kfree_rcu_nolock-v3-6-70a54f3775bb@kernel.org>
 <f3a56a5a-f10b-46dc-bc99-28449ade1661@kernel.org>
 <40591888-3a87-433e-b3d2-cda1cab543be@kernel.org>
 <9d8ca1ed-bc53-417f-944b-d78eecd1e6a5@kernel.org>
 <03da8742-3790-4428-84b8-11911bf44c9e@paulmck-laptop>
In-Reply-To: <03da8742-3790-4428-84b8-11911bf44c9e@paulmck-laptop>

--------------CZDOJb3QDvzu5IEDZMoq1w7C
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 6/18/26 5:40 AM, Paul E. McKenney wrote:
> On Wed, Jun 17, 2026 at 07:38:16AM +0200, Vlastimil Babka (SUSE) wrote:=

>> On 6/17/26 07:14, Harry Yoo wrote:
>>> On 6/17/26 2:24 AM, Vlastimil Babka (SUSE) wrote:
>>>> On 6/15/26 13:06, Harry Yoo (Oracle) wrote:
>>>>> As suggested by Vlastimil Babka, kfree_rcu_sheaf() can be used
>>>>> on PREEMPT_RT if we always assume spinning is not allowed on PREEMP=
T_RT.
>>>>> This is because local_trylock and spinlock_t are safe to use with
>>>>> trylock variant as long as the kernel does not spin and the context=
 is
>>>>> not NMI and not hardirq.
>>>>>
>>>>> Now that __kfree_rcu_sheaf() knows how to handle allow_spin =3D fal=
se,
>>>>> relax the limitation and try the sheaves path on PREEMPT_RT as well=
=2E
>>>>>
>>>>> Keep the lockdep map on non RT kernels. However, do not use the loc=
kdep
>>>>> map on PREEMPT_RT to avoid suppressing valid lockdep warnings.
>>>>>
>>>>> Link: https://lore.kernel.org/linux-mm/6811cc17-8ee4-48c8-8cbf-6bf4=
d9f98162@kernel.org
>>>>> Suggested-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
>>>>> Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
>>>>
>>>> LGTM, but maybe unnecessary pessimistic wrt call_rcu() on PREEMPT_RT=
?
>>>> I thought (in the Link: above) we'd only need to downgrade allow_spi=
n to
>>>> false on PREEMPT_RT for handling sheaves movement from/to barn and
>>>> alloc_empty_sheaf(), but call_rcu() would be safe from kfree_rcu() e=
ven on
>>>> RT?
>>>
>>> Indeed. Good point, thanks!
>>>
>>> Hmm, but I'm not sure that it's worth the complexity given that
>>> PREEMPT_RT tries very hard to avoid disabling IRQs...
>>>
>>>> Or is the irqs_disabled() condition rare enough so we don't care?
>>>
>>> Given that most users don't call kfree_rcu() under raw spinlock or
>>> IRQs-disabled section on PREEMPT_RT, I think it's okay to keep it as =
is
>>> (it's not making things worse, at least) and wait for call_rcu_nolock=
()?
>>
>> Sounds good.
>>
>>> On a side note, I don't have much idea on what needs to call kfree_rc=
u()
>>> under a raw spinlock, other than set_cpus_allowed_force(), which shou=
ld
>>> really be using kfree_nolock() instead of kfree_rcu() once we support=

>>> kmalloc() -> kfree_nolock():
>>
>> Looks like the case. Well if the fallback path of kfree_nolock() that =
is
>> irq_work_queue() is indeed safe here.
>>
>>>> 	/*
>>>> 	 * Because this is called with p->pi_lock held, it is not possible
>>>> 	 * to use kfree() here (when PREEMPT_RT=3Dy), therefore punt to usi=
ng
>>>> 	 * kfree_rcu().
>>>> 	 */
>>>> 	kfree_rcu((union cpumask_rcuhead *)ac.user_mask, rcu);
>>>
>>> Any thoughts, RCU/RT folks?=20

Thanks for looking into it, Paul!

Perhaps I'm missing some context here... let me clarify.

> For the call_rcu*() counterparts, I am currently considering making the=

> existing functions check for interrupts disabled, using irq_work_queue(=
)
> in that case.=20

Ack.

> I suppose that I could use raise_softirq() in the
> use_softirq=3D1 case when in_hardirq().=20

Ack.

> Either way, the check should be
> cheap compared to rest of the processing.

Agreed.

> The additional rcu_barrier() work required is of course way down in

Assuming "The additional rcu_barrier() work required" means
rcu_barrier() now needs to wait for all CPUs to complete irq_work or
softirq...

> the noise compared to acquiring a global mutex.

Are you referring to a specific mutex, or just in general?

> In your case, kfree_rcu() can be quite a bit lighter weight, though.
> So the extra checks might not be lost in the noise.

Assuming "the extra checks" means checking whether interrupts are
disabled in call_rcu()*...

It will probably be fine since we invoke call_rcu() only when sheaves
become full, not once for each object?

Perhaps slightly off-topic; at some point, though, I think it'd be
better to teach SLUB to use RCU polling API for RCU sheaves.

e.g.) put sheaves into barn->sheaves_pending instead of invoking
call_rcu(), and the SLUB alloc slowpath checks if there are sheaves
past grace period before allocating and refilling sheaves.

--=20
Cheers,
Harry / Hyeonggon

--------------CZDOJb3QDvzu5IEDZMoq1w7C--

--------------r52TW6tkzMED0vgUCNBCiTch
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCajPojAAKCRCGXBN6rc5S
1iYYAP9R9SRxcpb+Lf9AzvYwC0ginyzWgaosKoEpwXTRJndtRQEApm4GZI/2RNXu
Q24xU67ieuyKBqFI2alWnLxiGr7+Bws=
=8O7i
-----END PGP SIGNATURE-----

--------------r52TW6tkzMED0vgUCNBCiTch--

