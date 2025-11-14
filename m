Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA79ACDE006
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 04:17:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02AEE8E0003; Thu, 13 Nov 2025 23:17:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 002948E0002; Thu, 13 Nov 2025 23:17:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E81B38E0003; Thu, 13 Nov 2025 23:17:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D187F8E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 23:17:53 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4F1A187062
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 04:17:53 +0000 (UTC)
X-FDA: 84107904426.28.5697BC1
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf23.hostedemail.com (Postfix) with ESMTP id 37BF314000B
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 04:17:50 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iNIABp+G;
	spf=pass (imf23.hostedemail.com: domain of jiayuan.chen@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763093871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8za1Ngk+XgqKIbf8gfc+93lq99ESfyr8n5JBwYJ5ZPM=;
	b=YPT503HH2a5KcTsBPDAWs6uWOEoP/v7XlgE9m6NkOTzkXbwh+aftIWezUL7bqLYrenFabS
	ATWA+K3k0x42mYce2N3GsfVwijNt1wT9sTnNXTQaJCQ6Da3ga6YgH86zz0MIdk1jM+/jro
	vqcFVi3am+PqgCXCxYqLE7erpbTmxjk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iNIABp+G;
	spf=pass (imf23.hostedemail.com: domain of jiayuan.chen@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763093871; a=rsa-sha256;
	cv=none;
	b=N0oaTgWC/bF5+JCeY6ShiiCsl1uSq6rQorzufMFaEJLKMzeHpJXhJT4MP8Nh3SMaQlAjim
	7fHnwvaO1AYXAOVhNzoNFfv5R1EYvFYd/lxFcugl7bxQp8p/NjF/CvyB7oEKDppMRHloNy
	Gq8THkbuyrLpNEuJOGp1fbD9+TwSyhk=
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763093869;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8za1Ngk+XgqKIbf8gfc+93lq99ESfyr8n5JBwYJ5ZPM=;
	b=iNIABp+GOkH+yVV+pP3IoXbtDNwfJUTTE02piniavS0Fy7Izy/QK0JxTWBWs18aeTCj35D
	YOuLj7hXSFIa1FHKM6rFWRDUu1zHKg7VdDpAJsnbfZpRnzYIehW1LZDZfyd/47wfZhvpwU
	zN2kne/nWG/Dm4pA59k01JPsvfLL9gU=
Date: Fri, 14 Nov 2025 04:17:40 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Jiayuan Chen" <jiayuan.chen@linux.dev>
Message-ID: <53de0b3ee0b822418e909db29bfa6513faff9d36@linux.dev>
TLS-Required: No
Subject: Re: [PATCH v2] mm/vmscan: skip increasing kswapd_failures when 
 reclaim was boosted
To: "Shakeel Butt" <shakeel.butt@linux.dev>, "Andrew Morton"
 <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, "Andrew Morton" <akpm@linux-foundation.org>,
 "Johannes Weiner" <hannes@cmpxchg.org>, "David Hildenbrand"
 <david@redhat.com>, "Michal Hocko" <mhocko@kernel.org>, "Qi Zheng"
 <zhengqi.arch@bytedance.com>, "Lorenzo Stoakes"
 <lorenzo.stoakes@oracle.com>, "Axel Rasmussen"
 <axelrasmussen@google.com>, "Yuanchu Xie" <yuanchu@google.com>, "Wei Xu"
 <weixugc@google.com>, linux-kernel@vger.kernel.org
In-Reply-To: <lqcwz26ajddhoaq3gfuyt3mzwfn7waeqksoz6k55jrtn32u42z@pdf3dor7ntb6>
References: <20251024022711.382238-1-jiayuan.chen@linux.dev>
 <lqcwz26ajddhoaq3gfuyt3mzwfn7waeqksoz6k55jrtn32u42z@pdf3dor7ntb6>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 37BF314000B
X-Stat-Signature: c7k74oabjg8mndqwapjxk8j5wb4zi5tf
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763093870-120434
X-HE-Meta: U2FsdGVkX1/0Inp+/Ih7mkwpvRRKKAI9e1aPSJciOuolXtyEcsDpsWPwsmpV1g8wX8/YDZlThhvQXyjXF/qpGr9bx7B6ylMB64ZlgGRAqvSLFW/T29PgtOpRIXR8H5Dx4elx3o/8Sq20/dQUjbMZPhpxBEXp9ztxAF+m5/ksA4gKd+Wkpyemkrqtfvumc0nC5jM0hMtLctCvSwFbT5YjOKJ6xkuLuvxns0BjXgQi7lGYab3aLP8ybGg8n5fV/3NTHOrF2m2QCZ5Cylekrvtye1F5JH3sHfyAhWX/PzyuYcyqa3inwK2TUf2bGCLlLE7N5Gwt/GEGe6I7e4N92Vo4aLbnCNnS9zrqCisZbs1mppAwtKQN2Yv/v+pMGIpr6g4LMxpP8sFVEWqZxvbMWB6XvQzhFYQgpwJu1l/gTv+Hn3VUWmp+8rUR0VUq5O2In6IC5wJHxnkxnLnaHpC+RoEj0OpXCe9N/fJLzZzCnYuSWL3Wq4MlgkerdGF3SNPbZ42YCD0aMBhXBeNqFVf+1/Av+WTn69LGYa7PHmIT43iAIGVVdxge7iV2oOb4nRmB4tCUnjffuRpzXDYkV7M2M0tn4ccDrdC7FbMcDrcFHVNg20nC+whLi9oHjiEJrI1BhHq+yvcjPCoDt6qTCuRFIG+ftLoWs2zDcZj8yjW6xaPsh2hNzbhySRvu6NHrEoiSJn2TZyaAoa+Ew8SiPqur2pQexYfXZxDhqyYxV5WxKHqEjyX2n6HLKTH4dNRUGeseuacK8gx3o9PoKQg2I/9p7sBMchNreHo8zB9qVawuxP+nfuBIq/IMlf7GwyhEyeqrw63haxjq2JVjs5K9ryGMccEGXuRdNRX0iFnEOp0sJObSQo2FHqN3necg9A2/lxUhO10GVTJdv/SPhcAE8WFnr4B2odtHetCAejP0guRSHPUPTzOXFsh0CwyQ2N40Aa6QeDalsGMPTUpcr2bYGYyVXnt
 /oNZxUjv
 NcFtGW7iPtjIQSRSd7GU78Ki46OpsmAqc6nON6mZfBGC8z1iCxCiIfZ5lMcioZ223cZM7cCJco8ZCIhpXjTNxNah+goOR8t0gkoZwr9KnVe5nxnBp1x6Cx777Pi/bykRF4DHT9kw6o7alyGvtaO0VWgYdjcb/Rduop3YS0aywUpohHAvUYS8GsvTIgwVDWrv/s9BztgKIdyjkxYkM0ehhklk6b1s+QQyWDDc6kA5I/cReArbDxXHb8Liw9lwxlPCbtVQB4XsoQOsO//scbZZds/JvyAeQRrRsWU2IqFoplzSM1pFqU/H6zzU/rix5bBQI/KuORfUA6AlMx7xVYYtmy6a6/KF24Z3LVWcwChnu+ZWoAySLJ+Tc48RaLtNXUCf8K3R/VnXDQOw9poytb4ArFhAGqy8gAIgTAIJ8f7J59rXbqPfNUnJWtCgcxTUHUGog6CssihX0/n4ZvfMkI6CVunzTPZLa5SQ6kdvKPt/rM2/tZdkjZ7/kY22Maw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

November 14, 2025 at 07:47, "Shakeel Butt" <shakeel.butt@linux.dev mailto=
:shakeel.butt@linux.dev?to=3D%22Shakeel%20Butt%22%20%3Cshakeel.butt%40lin=
ux.dev%3E > wrote:


[...]
> >  The final observable issue is that a brief period of rapid memory
> >  allocation causes kswapd to stop running, ultimately triggering dire=
ct
> >  reclaim and making the applications unresponsive.
> >=20=20
>=20>  Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
> >=20
>=20Please resolve Andrew's comment and add couple of lines on boosted
> watermark increasing the chances of kswapd failures and the patch only
> targets that particular scenario, the general solution TBD in the commi=
t
> message.
>=20
>=20With that, you can add:
>=20
>=20Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
>

I see this patch is already in mm-next. I'm not sure how to proceed.
Perhaps Andrew needs to do a git rebase and then reword the commit messag=
e?
But regardless, I'll reword the commit message here and please let me kno=
w
how to proceed if possible:

'''
mm/vmscan: skip increasing kswapd_failures when reclaim was boosted

We have a colocation cluster used for deploying both offline and online
services simultaneously. In this environment, we encountered a scenario
where direct memory reclamation was triggered due to kswapd not running.

1. When applications start up, rapidly consume memory, or experience
   network traffic bursts, the kernel reaches steal_suitable_fallback(),
   which sets watermark_boost and subsequently wakes kswapd.

2. In the core logic of kswapd thread (balance_pgdat()), when reclaim is
   triggered by watermark_boost, the maximum priority is 10. Higher
   priority values mean less aggressive LRU scanning, which can result in
   no pages being reclaimed during a single scan cycle:

   if (nr_boost_reclaim && sc.priority =3D=3D DEF_PRIORITY - 2)
       raise_priority =3D false;

3. Additionally, many of our pods are configured with memory.low, which
   prevents memory reclamation in certain cgroups, further increasing the
   chance of failing to reclaim memory.

4. This eventually causes pgdat->kswapd_failures to continuously
   accumulate, exceeding MAX_RECLAIM_RETRIES, and consequently kswapd sto=
ps
   working. At this point, the system's available memory is still
   significantly above the high watermark =E2=80=94 it's inappropriate fo=
r kswapd
   to stop under these conditions.

The final observable issue is that a brief period of rapid memory
allocation causes kswapd to stop running, ultimately triggering direct
reclaim and making the applications unresponsive.

This problem leading to direct memory reclamation has been a long-standin=
g
issue in our production environment. We initially held the simple
assumption that it was caused by applications allocating memory too rapid=
ly
for kswapd to keep up with reclamation. However, after we began monitorin=
g
kswapd's runtime behavior, we discovered a different pattern:
'''
kswapd initially exhibits very aggressive activity even when there is sti=
ll
considerable free memory, but it subsequently stops running entirely, eve=
n
as memory levels approach the low watermark.
'''

In summary, both boosted watermarks and memory.low increase the probabili=
ty
of kswapd operation failures.

This patch specifically addresses the scenario involving boosted watermar=
ks
by not incrementing kswapd_failures when reclamation fails. A more genera=
l
solution, potentially addressing memory.low or other cases, requires furt=
her
discussion.

Link: https://lkml.kernel.org/r/20251024022711.382238-1-jiayuan.chen@linu=
x.dev
Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

'''

