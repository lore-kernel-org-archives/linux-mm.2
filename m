Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C828FEA82E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 08:34:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 448FE6B0005; Wed, 25 Mar 2026 04:34:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D2616B0089; Wed, 25 Mar 2026 04:34:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29A296B008A; Wed, 25 Mar 2026 04:34:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 140EF6B0005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 04:34:49 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B3CE11A0800
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 08:34:48 +0000 (UTC)
X-FDA: 84583924656.26.FB316F5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 17D7F80008
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 08:34:46 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jZtJs5oS;
	spf=pass (imf02.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774427687;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HcUB44mjj7bEuMn/TmR5X5iIL9ZhHOay849LIbq9R+w=;
	b=I8CJcDTomd9z9/DiIcWanN24bGpZz4jV+H2/92KMS4PuDuaI3MwmyQfIy8qi7sVKNMsNtH
	vKIpqb+nbjLawWC1+D6rQ3xcvEccomv3qp8tl0p46Eg0VY9MC48XUxH/myE5qugrGE5osr
	BbZYTL90gMozdUPijnVz6b8y0isZMpM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jZtJs5oS;
	spf=pass (imf02.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774427687; a=rsa-sha256;
	cv=none;
	b=ASUgAVrKO7A1Xcg+HhuOJNKxfeDWy8x44UE/ZF+lp63gB3366wZbBe9OI8NXni+N2qMNz1
	1lBIdcWISG7SLLJQtY0HfcEvM+ClYc9PqvenbCWd89WXtqMwNBvldrf+fX/opZK8RoKi1g
	WleYYzXSEy034jJzUjCbRFtwoBG+kjA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 50AAF60103;
	Wed, 25 Mar 2026 08:34:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 472E2C4CEF7;
	Wed, 25 Mar 2026 08:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774427686;
	bh=ZltXuo3y0hZumFiHX9g2/4w1IoWynutuFUdVx5jC7ww=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=jZtJs5oSkHBlvxcqGTv1K5bZuebrcPNeR+ep7pebrN7SXJFOvGsZSAlYV3NYuhVBR
	 Jy4Fs1vK/9M+rWFWnyLnBk6Sn4pWR4MCc2okQM9FGoHAfdVJobT+ccJGzRpmp2nJ/T
	 pj62Ea27WguWZQedAxbeiUFZ/1XXBw4LDlkFHxAdxMhT9sIHNhYzfOCBW/KolsbUZq
	 G2Vq6/wl9GATQHfV76daayv0LVS7jBfU9YBJRhijwb1CDZkBq917IIS3F+wc9rStI4
	 2oxABWp1VaB9ONp2/zx28YmnCL/RqUmUK1wX58MWZNXnso36YDpraGseF7JlCTshQ+
	 c1SWVqN7Z+GXA==
Message-ID: <de209b21-a39a-4c8e-8f13-458d095c1325@kernel.org>
Date: Wed, 25 Mar 2026 09:34:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] slab,rcu: disable KVFREE_RCU_BATCHED for strict grace
 period
Content-Language: en-US
To: "Harry Yoo (Oracle)" <harry@kernel.org>
Cc: Jann Horn <jannh@google.com>, Andrew Morton <akpm@linux-foundation.org>,
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 "Paul E. McKenney" <paulmck@kernel.org>,
 Joel Fernandes <joelagnelf@nvidia.com>, Josh Triplett
 <josh@joshtriplett.org>, Boqun Feng <boqun@kernel.org>,
 Uladzislau Rezki <urezki@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>,
 Dmitry Vyukov <dvyukov@google.com>, rcu@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260324-kasan-kfree-rcu-v1-1-ac58a7a13d03@google.com>
 <ff139493-1964-4285-947d-1b43fe40f8e5@kernel.org> <acOa8ErxLgbj0Uer@hyeyoo>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <acOa8ErxLgbj0Uer@hyeyoo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 17D7F80008
X-Stat-Signature: mm8s36smnc8e15gxsdruetr8oiscbk4k
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774427686-433871
X-HE-Meta: U2FsdGVkX1+vWpWcUVFow6GvAsY+u8F/lEqv/zJxuJPGZ6A8CZtGZSekC9bsN93WFn8iL2JyrNIUI3KnwTJMuI8ugE0o13s5KpDcDNK6klBB/qFKpM5ty4ELNLCsk5VF6Pgr0fpvQ+AaCmXe0EdYj/CcF6DtzDZFN/yYO322OCV3XcCP6vJHmocuastvdIDmwGWJDxs1gz7TogUA7WebHZgcj5VnwXivBxJK3vLJTx2nnhggySIk0gd4idJTmx3kVePDWNvJ5Hsg4ljylr5JJdUkY4YSc7vg9OGeY0+fcLnK8hcQheJFdM42gA3V2ouXGGouPXvbd4kiyrEpERElaM0i1WY3z9O3J9kXc/Dqpa74Ip1trq8fFQIa0d0sTKP1uXyCxLQJ4AABgHRDDNzO17TQ125qBMh2qCpJW+oKfL8ckvGNWqu9nrBY9eTQyedIgq+spHHBhR2eRLR26pCuKziNzqEhG64Jjr9wk+3jgE1hM51abi0atyZ37UZRPi2OR8FoTtm8fK+9Ez3Plm4wYljjGZLdOH2lzi3cbCfJZNCZgonx4PCDqemtuX0HyAreeOHpzfwjxARhgK0JtxIZQJlj7Zphau0VSDoKtTwFvAn1VVWOLlpu5ctVyC/JqneGpg0tjGA+118RguoX+xmIxfZqEnJqn0lzP/h6OomnC3SgJqGbfQpLtbruVE8VT4AcyFfvmc+PsYqUDouF+el32bzPtYX+f/Dp5Wy0zcz3VuMC8jUiDhkKGWkGP4mZtn4POsNGMXfNI52npG5HFO0sCcp6OOv1sfR0MFfVT3EjKom9kKKDaecxVMzCWyddddK/LTxdFeR4q3XGNbpNnI1FUuG8Bw86GsSbu97slLBTKgUdAUs03PHqYqDGw0KYTGmTNWBEG9sK23wxtl9z5+s/mmHnKHZRmTzcixfDSVrgfJjzP1PfV/FeZjL3ulQQSEoPGujxmQ/rfoLF9aToYnu
 /OMT+Byh
 XxbnGqeL5DOZiOgroIEjx7vrst3/9ZPx6xcXVSTeDBjMpnpoP6PsHu0Dn66wyrfab9iqR1evR6bJnExbZ4ldvwa8Gg33aS1Gn7Kb8CgWqxo0NC+DTvXNP4uSlyHcCBcvA2s++lE18wZg1SbCYf99vYT9/6rqsV1mIbSBjVTYPlpIa9OL2xOG6kmaw2HtPpmi3Qkxz4rpW0qHMX1JtL0x5RKhQrQ5HQBAkMVapOZWO7FhqyflUF/Y0wPw1a0XX2sGQlyfFQBos0hLhgJu1KsKO9f0pZhBOA0PVVxpU13JKYrJSpXj8WfzV8tdA+K59TSgRacadfyS7fj6+yv8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/25/26 09:21, Harry Yoo (Oracle) wrote:
> On Wed, Mar 25, 2026 at 08:50:07AM +0100, Vlastimil Babka (SUSE) wrote:
>> On 3/24/26 22:35, Jann Horn wrote:
>> > Disable CONFIG_KVFREE_RCU_BATCHED in CONFIG_RCU_STRICT_GRACE_PERIOD builds
>> > so that kernel fuzzers have an easier time finding use-after-free involving
>> > kfree_rcu().
>> > 
>> > The intent behind CONFIG_RCU_STRICT_GRACE_PERIOD is that RCU should invoke
>> > callbacks and free objects as soon as possible (at a large performance
>> > cost) so that kernel fuzzers and such have an easier time detecting
>> > use-after-free bugs in objects with RCU lifetime.
>> > 
>> > CONFIG_KVFREE_RCU_BATCHED is a performance optimization that queues
>> > RCU-freed objects in ways that CONFIG_RCU_STRICT_GRACE_PERIOD can't
>> > expedite; for example, the following testcase doesn't trigger a KASAN splat
>> > when CONFIG_KVFREE_RCU_BATCHED is enabled:
>> > ```
>> > struct foo_struct {
>> >   struct rcu_head rcu;
>> >   int a;
>> > };
>> > struct foo_struct *foo = kmalloc(sizeof(*foo),
>> >     GFP_KERNEL | __GFP_NOFAIL | __GFP_ZERO);
>> > 
>> > pr_info("%s: calling kfree_rcu()\n", __func__);
>> > kfree_rcu(foo, rcu);
>> > msleep(10);
>> > pr_info("%s: start UAF access\n", __func__);
>> > READ_ONCE(foo->a);
>> > pr_info("%s: end UAF access\n", __func__);
>> > ```
>> > 
>> > Signed-off-by: Jann Horn <jannh@google.com>
>> 
>> Hm but with 7.0 we have sheaves everywhere including kmalloc caches, and
>> there's a percpu rcu_free sheaf collecting kfree_rcu'd objects.
> 
> Right, but only when CONFIG_KVFREE_RCU_BATCHED=y
> 
>> Only when
>> it's full it's submitted to call_rcu() where the callback rcu_free_sheaf()
>> runs slab_free_hook() including kasan hooks etc. If there's nothing filling
>> the rcu_free sheaf, the objects can sit there possibly indefinitely.
> 
> Right.
> 
>> That means CONFIG_KVFREE_RCU_BATCHED now handles only the rare cases where
>> kfree_rcu() to the rcu_free sheaf fails (and I still owe it to Ulad to do
>> something about this).
> 
> Right.
> 
>> So to complete the intent of this patch, we should perhaps also skip the
>> rcu_free sheaf with RCU_STRICT_GRACE_PERIOD? (or with !KVFREE_RCU_BATCHED
>> perhaps as it's also a form of batching).
> 
> Maybe I'm missing something, but...
> 
> by making KVFREE_RCU_BATCHED depend on !RCU_STRICT_GRACE_PERIOD,
> selecting RCU_STRICT_GRACE_PERIOD disables all uses of rcu_free sheaves?
> 
> kvfree_call_rcu() implementation on !KVFREE_RCU_BATCHED does not call
> kfree_rcu_sheaf().

Ah yeah, I missed that there are two kvfree_call_rcu() implementations and
kfree_rcu_sheaf() is only used in the batched one. Sorry for the noise.

Will queue the patch

>> But then I wonder if the testcase in the changelog appeared to be fixed with
>> this patch on a 7.0-rcX kernel (base-commit: below is rc3+) because by my
>> understanding it shouldn't have been. (unless there happened to be enough
>> kfree_rcu() activity on that cpu+kmalloc cache combination, so that the
>> rcu_free sheaf got submitted withing that msleep(10)).
>> 
>> > ---
>> >  mm/Kconfig | 1 +
>> >  1 file changed, 1 insertion(+)
>> > 
>> > diff --git a/mm/Kconfig b/mm/Kconfig
>> > index ebd8ea353687..67a72fe89186 100644
>> > --- a/mm/Kconfig
>> > +++ b/mm/Kconfig
>> > @@ -172,6 +172,7 @@ config SLUB
>> >  config KVFREE_RCU_BATCHED
>> >  	def_bool y
>> >  	depends on !SLUB_TINY && !TINY_RCU
>> > +	depends on !RCU_STRICT_GRACE_PERIOD
>> >  
>> >  config SLUB_TINY
>> >  	bool "Configure for minimal memory footprint"
>> > 
>> > ---
>> > base-commit: b29fb8829bff243512bb8c8908fd39406f9fd4c3
>> > change-id: 20260324-kasan-kfree-rcu-4e7f490237ef
>> > 
>> > --  
>> > Jann Horn <jannh@google.com>
>> > 
>> 
>> 
> 


