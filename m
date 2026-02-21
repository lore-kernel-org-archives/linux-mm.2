Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CEC5C61CE0
	for <linux-mm@archiver.kernel.org>; Sat, 21 Feb 2026 06:08:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B61B96B0005; Sat, 21 Feb 2026 01:08:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0EE26B0089; Sat, 21 Feb 2026 01:08:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F0576B008A; Sat, 21 Feb 2026 01:08:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8A97B6B0005
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 01:08:00 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1F48313ACAC
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 06:08:00 +0000 (UTC)
X-FDA: 84467433120.07.33E0900
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4D6DB1C0006
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 06:07:58 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rrGOxfCf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771654078; a=rsa-sha256;
	cv=none;
	b=h0sPRZw+zECgtInyJjhd/Nl8kw9HPHe8+7F/WZIbIrf+my5RXII9gRbK9LyVFbs4koXh7B
	aj3eqgXhejfFY1AU7h4Kf96V//loj+RQGEYpi3RnXt3gUnes+Z9kEZ72RgLn+DIlcJnbpK
	azWyLUpNkNmidvyIy82veal6obYPT+4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rrGOxfCf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771654078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vNYOII3ATo8v6v5YfJjwWytPBUpNMd9xBlA+zTtOasc=;
	b=KygRmWH2kY1w+5lvwZuZxbhSHLV9TOOYoAB6Em9GM4lmmQmUj0Jn8apbfvuetitXZOibeF
	Tqx6hdOxF9ltBNJvS3qC9H4oYT/ucH2PSA/4g7jGtREOtsRVxkFFk1DJMIg5J2a0SGLTLc
	ruR4hXUiG2ywOKaGBTs/aSOq1Q6YpRI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 057FA4455F
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 06:07:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADFBEC2BCB8
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 06:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771654076;
	bh=tuqfdUH5dLNaI48UltQSQ/DDXtuz46WoSnM/Ewc6hV8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=rrGOxfCfrzO5Z6TnyNZTGHHC4AhkzmXzc5/I4icCCEJTpLic/HBXPpgymzMVXUeIV
	 g6H0/oLcyDcl163lJCCr+cHv8ngAYosNdzRxHPGp+unCyQzeCSQVtDHH+J7QdU1+5W
	 r0ne/wnYGg57yboj15LDo3iwcEIb4NIdbIAazPZAIGHrVVWX/n6yTSF6JcxyEI5LqC
	 8yZdxcSomkvg3lRtkZtlaW6AXuJBJIGnPzNFrCBFW7uOf9OL1a3/zKc/Y8HsZhGTTj
	 cdZywz7YCTZIGId7HSNWks/LODrcKsBUur+p858EiiWlcI4aOa9AqWf6vDL0csC7XX
	 tSjxIKaaXnklw==
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-79628fb5c05so21913357b3.2
        for <linux-mm@kvack.org>; Fri, 20 Feb 2026 22:07:56 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWT/hTIGGZPttNHoXEDhVRuzrzVPzjLB5RdBNQv/t4NUHqgGHLS2pLABv8aJ4qqTs7r+jev+ZoJmA==@kvack.org
X-Gm-Message-State: AOJu0YyUe3JVi6+oN0i02J6dgMo28C9GiiRB+uOVi/iVwqVeJlQweqec
	GPOKDdPv2TuqmOikhkZ0ZKi/VFJ9Moxyko4J3b7MOlfRFTfvLXKXDEZlYU98G41U8b9yX0sgwpv
	yT47x3hA+NIJI2wKhhcpVRWan2lYYVK/eZucTXU7eVA==
X-Received: by 2002:a05:690c:438e:b0:796:2dfb:4aeb with SMTP id
 00721157ae682-79828ff5e9dmr17141547b3.37.1771654075666; Fri, 20 Feb 2026
 22:07:55 -0800 (PST)
MIME-Version: 1.0
References: <20260126065242.1221862-1-youngjun.park@lge.com>
 <aY4bQFvpPRWgnOTM@linux.dev> <aY6hcPNxiolf5jj6@yjaykim-PowerEdge-T330> <aZjxP2sTavBRGC1l@linux.dev>
In-Reply-To: <aZjxP2sTavBRGC1l@linux.dev>
From: Chris Li <chrisl@kernel.org>
Date: Fri, 20 Feb 2026 22:07:44 -0800
X-Gmail-Original-Message-ID: <CACePvbU=4f4gT5kHUBq0wD7COHN+quE5g4bPQqJYgJNx_9vuhg@mail.gmail.com>
X-Gm-Features: AaiRm52oT9bCdTg2KlqgudQjXVvw63FwwA4FX_ypBGoSC1POgtIdGTHmnFwj-bE
Message-ID: <CACePvbU=4f4gT5kHUBq0wD7COHN+quE5g4bPQqJYgJNx_9vuhg@mail.gmail.com>
Subject: Re: [RFC PATCH v2 0/5] mm/swap, memcg: Introduce swap tiers for
 cgroup based swap control
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: YoungJun Park <youngjun.park@lge.com>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, gunho.lee@lge.com, 
	taejoon.song@lge.com, austin.kim@lge.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4D6DB1C0006
X-Stat-Signature: xd3cfwpyhmo1wkfqhtkzme6iq9exkucu
X-HE-Tag: 1771654078-405557
X-HE-Meta: U2FsdGVkX1/otnOz45HpjxFwJ9qCso8ukx119UqIhakV4wWHr0tsEKoqZT/9DhUc7GCcVXy++S4piyvXc82h+kY8mMlo/xtHahvReNeq5VMDzwrkoTQD/C1kWqfxi8723b2yhTBa54wNJ0X7KYw5XkJr49IlyxRbLsCBfxGeNdGYAYO9lW/teMdD1amqV1OKf33T+h4ujsbpxHxKDoFDCOO/UMrIiw5n2821wg12eXN5+95BIPTfhSHmunz9/tmfGbaQRiTBEbabivQ8+XGuMf4jAMCVb2fXn0T7AwgF0UWzoya/OOaIw6+jBV63P/2dDB9yypYpaMXjrCoZTlCUenvIGOXdUtbi3T4uIX4DTDJ8fM1Bp0+rPfWBkiEM2u9GNE2yeqRU1ldkXgTvMErFySDZFjd0iYyT4oUglJpaXg0xHaFiNPTGIzEtxLbGSgJlXBMS0Lx3Zh2xMk/rbgsOIicg0vfvSjk1lk5QnjU0CQbAlN9ny9c7eEqHhqsCGO/y2POPHEQ7PVkqfZvVOEVPwYH7BDUEBsyvdQSa3aqzGo04WjuJbM7U+X1tpalip4Weh8g3agW4Cp94Z6GGfWnDrhHwsd+d4ebVSfExGzerYln+2UA+EU0K9jodJDYKYZO/AwOZWfapM9U3u9ny/G5EdJyviag0BX8+eLFVhA+nWn0GutD/mls/ooxu9mtQLQvnxOZQiWXpr0TrW1z7g+yCh3DKGI8wTHeu93Y/T3GEA5o+GtaNbNxN5KYYqoYZT6QCh3HHZ1aWMSQL6A1JTyt21HgA5fSFMENvNs+96nN1bPljnBtSxux9GNQdL7Ua+fIUSXbA2SVrmRnH+4n15pn3+9Igpgl9UXzgKhCkXNQhIXNbIP26EP6+hT3rQe0znEURnmITfnBkgtk0HrCkWU8l8GEWqg9K08MO2RnU1t6FGwP9wJ7I29x20N5LkXVICkqmc1OKnIL8KUOCB64EmvI
 ysg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 20, 2026 at 7:47=E2=80=AFPM Shakeel Butt <shakeel.butt@linux.de=
v> wrote:
>
> Please don't send a new version of the series before concluding the discu=
ssion
> on the previous one.

In this case I think it is fine.  You haven't responded to YoungJun's
last response in over a week. He might have mistaken that the
discussion concluded.
Consider it is one of the iterations. It is hard enough to contribute
to the kernel. Relax.
Plus, much of the discussion on the mailing list always has differing
opinions. So, it's hard to determine what is truly concluded.
Different people might have different interitations of the same text.

>
> On Fri, Feb 13, 2026 at 12:58:40PM +0900, YoungJun Park wrote:
> > >
> > > One of the LPC feedback you missed is to not add memcg interface for
> > > this functionality and explore BPF way instead.
> > >
> > > We are normally very conservative to add new interfaces to cgroup.
> > > However I am not even convinced that memcg interface is the right way=
 to
> > > expose this functionality. Swap is currently global and the idea to
> > > limit or assign specific swap devices to specific cgroups makes sense
> > > but that is the decision for the job orchestator or node controller.
> > > Allowing workloads to pick and choose swap devices do not make sense =
to
> > > me.
> >
> > Apologies for overlooking the feedback regarding the BPF approach. Than=
k you
> > for the suggestion.
>
> No need for apologies. These things take time and multiple iterations.
>
> >
> > I agree that using BPF would provide greater flexibility, allowing cont=
rol not
> > just at the memcg level, but also per-process or for complex workloads.
> > (As like orchestrator and node controller)
>
> Yes it provides the flexibility but that is not the main reason I am push=
ing for
> it. The reason I want you to first try the BPF approach without introduci=
ng any
> stable interfaces. Show how swap tiers will be used and configured in pro=
duction

Is that your biggest concern? Many different ways exist to solve that
problem. e.g. We can put a config option protecting it and mark it as
experimental. This will unblock the development allow experiment. We
can have more people to try it out and give feedback.

> environment and then we can talk if a stable interface is needed. I am st=
ill not
> convinced that swap tiers need to be controlled hierarchically and the no=
n-root
> should be able to control it.

Yes, my company uses a different swap device at different cgroup
level. I did ask my coworker to confirm that usage. Control at the non
root level is a real need.

>
> >
> > However, I am concerned that this level of freedom might introduce logi=
cal
> > contradictions, particularly regarding cgroup hierarchy semantics.
> >
> > For example, BPF might allow a topology that violates hierarchical cons=
traints
> > (a concern that was also touched upon during LPC)
>
> Yes BPF provides more power but it is controlled by admin and admin can s=
hoot
> their foot in multiple ways.

I think this swap device control is a very basic need. All your
objections to swapping control in the group can equally apply to
zswap.writeback. Unlike zswap.writeback, which only control from the
zswap behavior. This is a more generic version control swap device
other than zswap as well. BTW, I raised that concern about
zswap.writeback was not generic enough as swap control was limited
when zswap was proposed. We did hold back zswap.writeback. The
consensers is interface can be improved as later iterations. So here
we are.

>
> >
> >   - Group A (Parent): Assigned to SSD1
> >   - Group B (Child of A): Assigned to SSD2
> >
> > If Group A has a `memory.swap.max` limit, and Group B swaps out to SSD2=
, it
> > creates a consistency issue. Group B consumes Group A's swap quota, but=
 it is
> > utilizing a device (SSD2) that is distinct from the Parent's assignment=
. This
> > could lead to situations where the Parent's limit is exhausted by usage=
 on a
> > device it effectively doesn't "own" or shouldn't be using.
> >
> > One might suggest restricting BPF to strictly adhere to these hierarchi=
cal
> > constraints.
>
> No need to constraint anything.
>
> Taking a step back, can you describe your use-case a bit more and share
> requirements?

There is a very long thread on the linux-mm maillist. I'm too lazy to dig i=
t up.

I can share our usage requirement to refresh your memory. We
internally use a cgroup swapfile control interface that has not been
upstreamed. With this we can remove the need of that internal
interface and go upstream instead.
>
> You have multiple swap devices of different properties and you want to as=
sign
> those swap devices to different workloads. Now couple of questions:
>
> 1. If more than one device is assign to a workload, do you want to have
>    some kind of ordering between them for the worklod or do you want opti=
on to
>    have round robin kind of policy?

It depends on the number of devices in the tiers. Different tiers
maintain an order. Within the same tier round robin.

>
> 2. What's the reason to use 'tiers' in the name? Is it similar to memory =
tiers
>    and you want promotion/demotion among the tiers?

I propose the tier name. Guilty. Yes, in was inpired by memory tiers.
It just different class of swap speeds. I am not fixed on the name. We
can also call it swap.device_speed_classes. You can suggest
alternatives.

Promotion / demotion is possible in the future. The current state,
without promotion or demotion, already provides value. Our current
deployment uses only one class of swap device at a time. However I do
know other companies use  more than one class of swap device.

>
> 3. If a workload has multiple swap devices assigned, can you describe the
>    scenario where such workloads need to partition/divide given devices t=
o their
>    sub-workloads?

In our deployment, we always use more than one swap device to reduce
swap device lock contention.
The job config can describe the swap speed it can tolerate. Some jobs
can tolerate slower speeds, while others cannot.

> Let's start with these questions. Please note that I want us to not just =
look at
> the current use-case but brainstorm more future use-cases and then come u=
p with
> the solution which is more future proof.

Take zswap.writeback as example. We have a solution that worked for
the requirement at that time. Incremental improvement is fine as well.
Usually, incremental progress is better. At least currently there is a
real need to allow different cgroups to select different swap speeds.
There is a risk in being too future-proof: we might design things that
people in the future don't use as we envisioned. I see that happen too
often as well.

So starting from the current need is a solid starting point. It's just
a different design philosophy. Each to their own.

That is the only usage case I know. YoungJun feel free to add yours
usage as well.

Chris

