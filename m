Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DCA0CCD1A5
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 10:11:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDAFE8E000F; Mon, 20 Oct 2025 06:11:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8BE28E0002; Mon, 20 Oct 2025 06:11:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC8428E000F; Mon, 20 Oct 2025 06:11:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9C2248E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 06:11:32 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 158E01A080D
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 10:11:32 +0000 (UTC)
X-FDA: 84018075624.22.44E1E6D
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf13.hostedemail.com (Postfix) with ESMTP id 41F5820007
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 10:11:30 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=j9EzymXH;
	spf=pass (imf13.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760955090;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=thqmaBr5SnMdqTFodzowvqsyJlTkVDv3C36xUDXcoMQ=;
	b=8jDIi4cwYUb9Nn8VXnJcHTNnFp1eEK9IgfdWu75PNXpHq3nUDUQXbJAIpjVpOX5frTdRsu
	muRmwiZPfOjRZKHwayQ6fl8f2rX2F65IY59T4B+DYeH70kY29O1SQsz9YFXumroEAKFHbo
	OKiHgpAfcK+H8bpmiyjAicb9g5gv9zI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=j9EzymXH;
	spf=pass (imf13.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760955090; a=rsa-sha256;
	cv=none;
	b=L+mZaNk8UqaT1/N6SWUWCpZUGR4WjroB/ZgvBxwuFoCVB+6+nnOVAiCvR9gyx3Yd3KlQdI
	5arS2r0WF7+ZkNlw7WncGlo9Y9nmWstqbjfzICcwV+/1hlXI/cpGDyfciPGK2g9bJ/M6Ss
	KLp0ITfYv+aRHedou6wGsqnOHsE09R0=
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760955086;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=thqmaBr5SnMdqTFodzowvqsyJlTkVDv3C36xUDXcoMQ=;
	b=j9EzymXH6xplPMFkNiSM/r3T/xoM6jYPrxOz55fSbSNwrbRZdZP/+Apng27+iIx9pMY93j
	JpB9fW2aWc4guQvlXazw7tm8KW8NSfyFAy+GMXCAVPS4/dBX3EPPjhM8xX+aajXoykb6lA
	YVocxzm+BkNw0sckolpU7eICCWv0PX8=
Date: Mon, 20 Oct 2025 10:11:23 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Jiayuan Chen" <jiayuan.chen@linux.dev>
Message-ID: <db4d9e73e6a70033da561ed88aef32c1ebe411dd@linux.dev>
TLS-Required: No
Subject: Re: [PATCH v1] mm/vmscan: Add retry logic for cgroups with
 memory.low in kswapd
To: "Michal Hocko" <mhocko@suse.com>
Cc: linux-mm@kvack.org, "Andrew Morton" <akpm@linux-foundation.org>, "Axel
 Rasmussen" <axelrasmussen@google.com>, "Yuanchu Xie"
 <yuanchu@google.com>, "Wei Xu" <weixugc@google.com>, "Johannes Weiner"
 <hannes@cmpxchg.org>, "David Hildenbrand" <david@redhat.com>, "Qi Zheng"
 <zhengqi.arch@bytedance.com>, "Shakeel Butt" <shakeel.butt@linux.dev>,
 "Lorenzo Stoakes" <lorenzo.stoakes@oracle.com>,
 linux-kernel@vger.kernel.org
In-Reply-To: <aPE84XfToVH4eAbs@tiehlicka>
References: <20251014081850.65379-1-jiayuan.chen@linux.dev>
 <aO4Y35l12Cav-xr4@tiehlicka>
 <a6cd4eb712f3b9f8898e9a2e511b397e8dc397fc@linux.dev>
 <aPEGDwiA_LhuLZmX@tiehlicka>
 <46df65477e0580d350e6e14fea5e68aee6a2832b@linux.dev>
 <aPE84XfToVH4eAbs@tiehlicka>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 41F5820007
X-Stat-Signature: 6yxjq3p5e7q4bjp1et83xdcgauo41dkf
X-Rspam-User: 
X-HE-Tag: 1760955090-139754
X-HE-Meta: U2FsdGVkX1/8K3vZv1oYyeKTOZxCrVScbZ4Q8rCy/vyrXA3eUiJYLySMWQ49fE6T3SXuFNxMQXIE2cL+/yU/UwOy0x5wJ/k8SIIUdDEAP0D2LwjJQMfxN2EteIHRQ0zFDz6C9Q4yViruYotT6bTN1jyZRzk5pCFVDTwSw5WodG4LvFqLYO8XwCh/DQ3j/rLeD/c5U20Mj3ISenvTloDyZphFoH+En6jPhp4ed/rNUd/ac1t3g7DjctZWdjGDMYc80Sf+CQhOL2L5S3w0oldWwgxkKYAbGwue4mohgVB0L+YuLKBA+q7G97h8t+VEaEMXowEJvwyI6k1UmVzKVkmCxZ9SOd+PBKIdvyeCrZsd8TqIqVB65kyFE4hn4w0bSilira61w/h6y9hrt5lNI4hdMyBV1g89s1r9mlSOPdnROww0swTC2VHHobm5qUsxaHveErCmEOY+OZ7XpsJbbFrzWVENaGsTOj324XtVMeDmVejURAzX72Si1NH3dT9M+P35jvlc+JoB4VfW6BbibUY8PSDowk2v7SFfWNtcvqs3+3npHig6DUlECSzPAQU4GhyQLyahCCXVpZFSG6dC78ORSW/yIEcvzpoelx97htfA1nwZSfYF3TxpyYp5kMonJf8pMJxM8hrIZKHRUkXTNPQpT2W1noUHI6sOpKHdgbK6Tgmg3sWeYm6jtiefPBtuYxjyKZPL73mSZqIj9diwGULqJpBEQZ6OLBWiAIjBSBLm1j2EheTuGtgK7wVayyY74TFnx4aS6bTbQLqHQ241mNDQR+5onzg1aLB/Ob8xH5t60BLcPSmqPbMVvE3BhDZP72q8Y6fsShsRPAG0gqbW1raY1F8KFgn95mYKa/CY5xF2tw8CtQpz4oNMAg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

October 17, 2025 at 02:43, "Michal Hocko" <mhocko@suse.com mailto:mhocko@=
suse.com?to=3D%22Michal%20Hocko%22%20%3Cmhocko%40suse.com%3E > wrote:


>=20
>=20On Thu 16-10-25 15:10:31, Jiayuan Chen wrote:
> [...]
>=20
>=20>=20
>=20> The issue we encountered is that since the watermark_boost paramete=
r is enabled by
> >  default, it causes kswapd to be woken up even when memory watermarks=
 are still relatively
> >  high. Due to rapid consecutive wake-ups, kswapd_failures eventually =
reaches MAX_RECLAIM_RETRIES,
> >  causing kswapd to stop running, which ultimately triggers direct mem=
ory reclaim.
> >=20
>=20>  I believe we should choose another approach that avoids breaking t=
he memory.low semantics.
> >  Specifically, in cases where kswapd is woken up due to watermark_boo=
st, we should bypass the
> >  logic that increments kswapd_failures.
> >=20
>=20yes, this seems like unintended side effect of the implementation. Se=
ems
> like a rare problem as low limits would have to be configured very clos=
e
> to kswapd watermarks. My assumption has always been that low limits are
> not getting very close to watermarks because that makes any reclaim ver=
y
> hard and configuration rather unstable but you might have a very good
> reason to configure the memory protection that way. It would definitely
> help to describe your specific setup with rationale so that we can look
> into that closer.
> --=20
>=20Michal Hocko
> SUSE Labs
>

Thank you for your response, Michal.

To provide more context about our specific setup:

1. The memory.low values set on host pods are actually quite large,
   some pods are set to 10GB, others to 20GB, etc.
2. Since most pods have memory limits configured, each time kswapd
   is woken up, if a pod's memory usage hasn't exceeded its own
   memory.low, its memory won't be reclaimed.
3. When applications start up, rapidly consume memory, or experience
   network traffic bursts, the kernel reaches steal_suitable_fallback(),
   which sets watermark_boost and subsequently wakes kswapd.
4. In the core logic of kswapd thread (balance_pgdat()), when reclaim is
   triggered by watermark_boost, the maximum priority is 10. Higher prior=
ity
   values mean less aggressive LRU scanning, which can result in no pages
   being reclaimed during a single scan cycle:

if (nr_boost_reclaim && sc.priority =3D=3D DEF_PRIORITY - 2)
    raise_priority =3D false;

5. This eventually causes pgdat->kswapd_failures to continuously accumula=
te,
   exceeding MAX_RECLAIM_RETRIES, and consequently kswapd stops working.
   At this point, the system's available memory is still significantly ab=
ove
   the high watermark=E2=80=94it's inappropriate for kswapd to stop under=
 these
   conditions.

The final observable issue is that a brief period of rapid memory allocat=
ion
causes kswapd to stop running, ultimately triggering direct reclaim and
making the applications unresponsive.

