Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CAD1FC72CB
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 16:41:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48D626B0096; Sun, 22 Mar 2026 12:41:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43E766B00A1; Sun, 22 Mar 2026 12:41:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32CD66B00A8; Sun, 22 Mar 2026 12:41:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 20F746B0096
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 12:41:37 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9C46FBB601
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 16:41:36 +0000 (UTC)
X-FDA: 84574264992.10.88C4D7E
Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
	by imf15.hostedemail.com (Postfix) with ESMTP id A6905A0002
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 16:41:34 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Xb1WJEIX;
	spf=pass (imf15.hostedemail.com: domain of devnexen@gmail.com designates 209.85.160.45 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774197694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UygfMtOJ6WycYibEscp9BcqIlnDy0mhESfEMXmTarYc=;
	b=164IZIq3xiNIW1e5xx7LUqlN3yO0onE/qwbuDVuR+GtpT+R+WVOHsec0rSSV5rWO3ladHI
	Gqtsw6ZC+bZ1YnoJzZn+Md069UNICTao1zUUW+kB+VSdtoWrAQwNaiWMl7wRkXFXISAlLB
	a1Jriu6f3kNfHibel3f8cPreXL+5ONc=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Xb1WJEIX;
	spf=pass (imf15.hostedemail.com: domain of devnexen@gmail.com designates 209.85.160.45 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774197694; a=rsa-sha256;
	cv=pass;
	b=SYaQOjGtfO9eoomxYiSL3tr4qbcIk1BbwNhRnZlBKt0nafsErgybG1AP3b1347axP/1CsM
	0lM1/lG2/PcMBS0ghGCClvcwY4x9lpB+ISsGYz++a8yhptfGYPHG15IokBqk/sbLBKf+Nq
	jsz/cDYSSW2xZV9SHR4mlMlojZXtOnU=
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-409de4132b5so1191829fac.1
        for <linux-mm@kvack.org>; Sun, 22 Mar 2026 09:41:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774197693; cv=none;
        d=google.com; s=arc-20240605;
        b=XCUuUoqmzzuRGAbxdAXDvVoa50AVvw9p/IlA4EodTs/dsPCz5Y20RNGTIPmw+sclJ3
         RnVpSKzUdulN5jO7b/dfoGvfPXHj7cHmyjchUAP+IvOj/LA6qORlmX5JJpsNA38QLTxR
         d0fWmO2Cr/0KXSkJuie17HSM8YZkZ69L93BtlOE4iGqRA1OdtOBKO3M8i+NqN82nVvaD
         oMchVtw9Lfp9kkf+rDgplrcsJEmxuwddWvmPT2r5vainNEi5NqEKx2C528wMglJ3Q0uo
         SYlUclpu/Qdai+tX7ounWMsJIaMaWMGtfkCm6eJzLk3H61yu6HDrx5our/wt8nwJCugo
         FQEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=UygfMtOJ6WycYibEscp9BcqIlnDy0mhESfEMXmTarYc=;
        fh=0qy1FLHlY+SwzCQypjz+7QJ5x/OECI0yDnGlbRRWrdI=;
        b=KGpEgAh4C6CsU43/sYIb9JlWHV5QW/6j3tTEmJkDlijSy6Y46JbuXBy74xafLxAkUX
         bP+LNWSdbvhZse9YnCAPhUAJPyTdh3HeS/4mrUuzMcQJ03UrhsxEqVXWH02Zh8G/bxCs
         fda8u0078Xd9pEIkGN7uYH4IxiEfu7TCx1SIqWQ++O1VyjfeXuxXSl2M7j462fHa+ZcH
         wOWl1RYDVH1eK6Bj851+t98qYodLH6BChsW8c1QGIN3l6Gp/ualXGfpPfzQGpfTHm3Yh
         apKvs9g1yqnhDShPBqMaDsXuXbMWxE7rwXZNX85bVQRUH0w+STurUziqHQMsPLv+0VMg
         g7mw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774197693; x=1774802493; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=UygfMtOJ6WycYibEscp9BcqIlnDy0mhESfEMXmTarYc=;
        b=Xb1WJEIXYPIMMNK/Danz3l/fC12Kxy3+v1X8o4VYLD9/48js67zCxhCiMI0FZRbLV4
         HaGT32bMGQOIBYj/nRTDBiptp6cvHwY7aoKiuhGHmneRXQve3PPcbf73iMXBHGmFmseb
         EcDn6roQE3pspMHoQelxbVMIIjzBSvouxkWoUeekN3QK2Og/NQQ97Lg20a1rXivb8pJx
         GUo/GkEvjzy/9+/QArp2cR73btlXj07RDZOvaufSfJd0L371WhROKrBeNLlUUBctuPHy
         HMrgCfZVuAmfxwVutZMf+5syxwwBoJwJurM4F9R89b9gUB9egX8B9jYknkK68nW2ntUd
         ZHAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774197693; x=1774802493;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UygfMtOJ6WycYibEscp9BcqIlnDy0mhESfEMXmTarYc=;
        b=OQSauCtrVHI7Dj44P1P2PIw3b4pck2j9KyIMSkNQNHA8N9jHmGcmzicxBIO23iNH70
         ng4YugqeD1Lqagu6VlzpAyNeeYxAZ/bR7ziZGBYGGKs0sP3PVr5OVWw/k710+s2alfe9
         rp3gVLdHsVuZNbkaaGPwsgmkxaGKqe/Urg4qGq4M4rrEzWfR/xPaxJRPasVjvOAompk9
         UCW2HFHdrrushY1JoMdODbhMUOzYK/a9LbXdiYrxfN4nYnWR3cDB0OQFkLbrN+6QbZ97
         YY2U6iJNB3sJgkbVMUbsZy/QyWv8vhXKLibLqBVm9Zwye+iYris8eATO0ASguGck3Rmz
         mvPQ==
X-Forwarded-Encrypted: i=1; AJvYcCUsWwlEr6ElQB4qzSnNDU1AN8eNLNlGfqv+zFIZFk2anVQXjj7EA8Jygtuv7OX8UAZv73i887XXPA==@kvack.org
X-Gm-Message-State: AOJu0YxkOwQbBIpsbYVoD6PjIHim8v9SO3ID9NptCn2EcX3r3FaJVDsU
	vIowS7KOCLVCGm8pdy/ZXZBE4VuF/96KxaQCdCaa9EdPVpKMSihAMKNB1+FYzoa70Ld3feBEPDJ
	bXFkbTVMV/OTncvB30W3/TGPsiOWsO/A=
X-Gm-Gg: ATEYQzwhIuqK9i74wkC3MCU4kzD02m1an0StNLhD7fSvMAh/xv64+NyrfcGcvLoVJjk
	7kCgpzEYgzWMyzmeVnU/A13ZoL3NCqGQQ5rfF5vbNb4RkEJ1xPZhV97CdwP06PJUT/48TTsM7S4
	OIY63F6gdYc7NalTNSkaKRMw4IVM4QGi6HrpF0hO6tcIKY+kN0BUBMYYu//0ZzgFpsRkp9yIemo
	kGPub5rStYR5Pxn4f2iiiuY13sNVdEYvWMqZRWFy4am95hn+fE6+Y7VwevXpTk4NOQ9wSFAcaq/
	KszAT2HEAJTr8Pz6RMDQz/Y+Vz7YW0sCyEzWZQ==
X-Received: by 2002:a05:6870:b0c9:b0:417:5a8c:feba with SMTP id
 586e51a60fabf-41c10f8df21mr6204359fac.12.1774197693494; Sun, 22 Mar 2026
 09:41:33 -0700 (PDT)
MIME-Version: 1.0
References: <20260322080142.5834-1-devnexen@gmail.com> <20260322092043.2c411821c2b883ba86c7cbd9@linux-foundation.org>
In-Reply-To: <20260322092043.2c411821c2b883ba86c7cbd9@linux-foundation.org>
From: David CARLIER <devnexen@gmail.com>
Date: Sun, 22 Mar 2026 16:41:21 +0000
X-Gm-Features: AaiRm50KUQZhn5mijKvExU03fMI6RXQO2XfIUx7DNkx_z4S0nSXFWK1lyb8dVdU
Message-ID: <CA+XhMqyy82d9PmKVBgjsbod4vwris-3+prOoVwJatYqqJf4nXw@mail.gmail.com>
Subject: Re: [PATCH] mm/memcontrol: fix obj_cgroup leak in mem_cgroup_css_online()
 error path
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <zhengqi.arch@bytedance.com>, linux-mm@kvack.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: aurjwfng7rkawjn8kdjiwx7jtob3399r
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: A6905A0002
X-HE-Tag: 1774197694-600981
X-HE-Meta: U2FsdGVkX18OcbypGRxux2JUMQoJ02A8ojFPvk/qzLHUTVh+ffPOijPUuhbmxhnsVu57NtzFMgliVfRa5pF7S9xvvZpEFyhd9ETZa3jw888YPtE03UGucLNFR45uAjyY9ZY6W5k4u7TJz5vXYPsFqLLjh+mm4U7VH2MItaumUPMLnRJjcu5QXfMPFLWZd4AMYCmPPufKJIGw23gDudoO+pyaLgNgZDPH54fquYiSHMR3syQiltgwB1pbs2V5u+IAsy7RCxM3cZVOo/cRdPGLQpdXgU8oIK7cC4YwmyRrmEqnjG/s6TM7qKSJa+vwjc1chkBBihFpJ0yq6vjbwzBIY2PtwIZq4yKgwmGfLt34EPCWXB5LRD3xv49pCE1emWQi1lad8zr9YZ6Ome2LIfDSVhsi9H92fTX9b+QjpP83FNOwfSfloH3hmdDjqAf9EkUvyw8YUo+xQ4FiUjlYTTr6+x3a6pnhgUr4PNlJ9MHFkdT+4/xAhzyp5cgtxFLyImvT6YzJnZ11Z4bEaJzVfFX23OQmbQ+dRjsWWqVeQecXvlcvi7rCWd/KDcaMc+jTinddAal8WploG30J5ks9xaQ0ySRZcOl4q6UPYnEQcJsn2bA/jKrPoShXtsfwYMcRmHXP3nWmdICAZqVQPLYtAm1YGeJcS3MgQvVFIE5ypmNmUO9NYMPyHx1/BqUQxzykn/U19muXM3xSqEJcBbaG3/K2QLvPoUlOzZ8s/me+XRD2P7I8umhlHKrmJbsFssDL/FLQmitrmyTM7FvXP/zvE8NeMTS4uObcOLOF2U/FUVGKxGxu18YeoxZyI6BNj4Qu/ER5qJXm+Zijpy8vX9GJ5TirGRHqwVdAsbYcpwhZC4RrQakYNvzZVquEcynBmH0KVgrpLLbZhHp95gOzgt1j2nLMk55OkI1uRBKPeoldG0Ac1hlKduo3BEF7r8BgY842Rz91sp0c9ittu6eu5Gdlq2w
 7qIHLiQB
 I0LlMfafLi/HVg0XiV4/3mM+KY9Jagz1Um0HcUjNRoJx4mTmmXVRPXzEG5lvO2SCwyEwpJgZguOFQI32IXC/YX89jLZAygvoF3vQoptArD0nQQjV6VC99+ZqG4XZ8o0ADWj44s/Zqvrm8RT7CGEN9nuwAdQIQuDbFHLPcVl1TDBDm3VGgu4zBzZsgdzapuph8SRS2JBs4F/ta85yWllUsC7+J7gcDealGQb+a5jsW7eMMjr2TkmWoYJ/1ZyVPkhzPpV1Z4zFrXrKMsfUacBK/MMJSpYx99TX6ue2VszLx/lpPeAVwvJSuP66SpB6TXcvhFLEozK2fG5JOlnx+Wh4jDSBLO5UFmY/AfOQXPAh1PPJERHJZPnE3QD2IJ58loFw9ByY2fNyUy33j7Tl6jdnkv4BxA9e8YPkSJebptpCjPcHYgAgIuxyStywVgPX6e4aUB1YGtVtwGgFFt+al9kzrB9wLeCyHbBf4dB+ugCiEVChb60ApZ8uB7LdBphjH3LqFJJ0IY/Mk49izS40vBjHRv0Xam+6veRSkPgayK1rHQabe0mLkdLHK6nePa9oABklwHbjzJsmBqJgjq6nUrPTx+fJfNw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew,

On Sun, 22 Mar 2026 at 16:20, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Sun, 22 Mar 2026 08:01:42 +0000 David Carlier <devnexen@gmail.com> wrote:
>
> > When obj_cgroup_alloc() fails partway through the NUMA node loop in
> > mem_cgroup_css_online(), the free_objcg error path drops the extra
> > reference held by pn->orig_objcg but never kills the initial percpu_ref
> > from obj_cgroup_alloc() stored in pn->objcg.
> >
> > Since css_offline is never called when css_online fails,
> > memcg_reparent_objcgs() never runs, so the percpu_ref_kill() that
> > normally drops this initial reference never executes. The obj_cgroup and
> > its per-cpu ref allocations are leaked.
> >
> > Add the missing percpu_ref_kill() in the error path, matching the normal
> > teardown sequence in memcg_reparent_objcgs().
> >
>
> Thanks.  Some questions from the AI reviewbot:
>         https://sashiko.dev/#/patchset/20260322080142.5834-1-devnexen@gmail.com

On the first point - you're right, the pointer should be cleared
before
  killing the percpu_ref. The normal teardown in
__memcg_reparent_objcgs()
  uses rcu_replace_pointer(pn->objcg, NULL, true) before
percpu_ref_kill(),
  and we should match that here to prevent RCU readers from observing
a
  dying objcg. I'll send a v2 using rcu_replace_pointer() instead of
  rcu_dereference_protected().

  On the second point - the pn->orig_objcg = NULL and the comment are
  pre-existing code, not introduced by this patch. The free_objcg
error
  path already guards with if (pn && pn->orig_objcg). As for
  __mem_cgroup_free() not checking pn for NULL, that path is only reachable
  after mem_cgroup_alloc() succeeded, which guarantees all nodeinfo
was
  allocated, so pn is never NULL there. That said, adding a defensive
check
  there could be a nice hardening improvement as a follow-up patch.

Kind regards.

