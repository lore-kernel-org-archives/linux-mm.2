Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39BA3CA9ECF
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 03:05:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA7366B0088; Sun, 11 Oct 2026 23:05:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D585D6B008A; Sun, 11 Oct 2026 23:05:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C46616B008C; Sun, 11 Oct 2026 23:05:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A2CD86B0088
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 23:05:54 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2A1E8A871F
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 03:05:54 +0000 (UTC)
X-FDA: 85312484628.19.AC4D339
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 521FF18000A
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 03:05:52 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ldwNn/VM";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791774352;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HFJ3bTcdbmrMb1MjB0qjlxO4NeEn7LJaB/BqUK+sTCc=;
	b=KAh6uAZtyZSQN1aELAXNkl6/Jx1AqSNvcB5iUC3PN23K4zQ0coL0dYAuHJP1gILurm4l8K
	mHbHWcWpCgYAEvh/oLPmg0jJHwaJNpIfjovzDq5t996H7wGbdbnkd4xfRIR/FFltvBEDuW
	7aY/Weq74oTridX811IA8uCzMkN2pK0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ldwNn/VM";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791774352;
	b=MZKo0Lr4yDu2+4AwLqxkkAHxwV4fHfm/sn/qjKTakrhutstur4ZRH37c8RL5TiYHKSPDLJ
	Xgye7JZDYFqyyzYadqCdtfPCPKAwmYCjWD0j31DDDs7hQECLB+/PQTYR7mNLJ2b2i0kO3b
	o4tZOtIuffrqqmGrrg6WWisERJ333tk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7DDE6601FA
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 03:05:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FF6A1F0089D
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 03:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791774351;
	bh=HFJ3bTcdbmrMb1MjB0qjlxO4NeEn7LJaB/BqUK+sTCc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=ldwNn/VMPx8v7Kcn29kRtGMTtOySNQaJkhZOoeM8FkNQ0HB0NQIDV/2XGpccMxNOB
	 Slnqj5nsDcXbwLqHPZlc2iBrAlbPLB5cfDCZcly1suPUvW/+B4W/vXfpGvPJ5JCFcy
	 uYnJ94giE02k/viObsYlNcXL2Zfqpb/kHem9m96UH7lwZo+fyZns09rEr/8nzrlGH4
	 MZWIyPtYEQrrITmMDNzZhjqEc4enlcEAtupiX/6gi3v3MBphwn8+Sglp5tfWuE+mZ0
	 UF0aK0snXDzMoAX4qVR2/8hjz0399ufadXAjcFj3/ehw5ZytknzfwSdQIQ+L8TbymA
	 NkXEE8Tk8/B1A==
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-93e706a6ba9so209773385a.2
        for <linux-mm@kvack.org>; Sun, 11 Oct 2026 20:05:51 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzempl47+zGTi7jqAJjJOAH2dkZPnB0EADyTODeV4t4YE9YJXXiaMjA5X53+ZwNO05/dmCf8oo5gw==@kvack.org
X-Gm-Message-State: AFq9FYJVIGoHDjizekuDQh+f1F/CZf8osL8op9Ub6y5hA97GpBXoscWT
	ULg3G/jJTbvw0eQJ/2rw1RQWu++mN4BA/oEX8q08i0VsuMita5vvCFNv5IydPXh0vcXLwLQMV9p
	gPnwB9kFtdB2IW8Ww23tjByvlpaWfOuQ=
X-Received: by 2002:a05:620a:4487:b0:93c:2c15:e51d with SMTP id
 af79cd13be357-93ebd273655mr1425306985a.46.1791774350592; Sun, 11 Oct 2026
 20:05:50 -0700 (PDT)
MIME-Version: 1.0
References: <20261012022917.1102467-1-vernon2gm@gmail.com>
In-Reply-To: <20261012022917.1102467-1-vernon2gm@gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Mon, 12 Oct 2026 11:05:38 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yW-58kLX7PCep=HVfc-CxE6rF7QKZhYjdeLGve7HX6pg@mail.gmail.com>
X-Gm-Features: AclHuK8IPcilkK8uwSMSyfgjCCtsjbWzPblwAMuBWNreMXAjVfMoXdJFAnSD8mc
Message-ID: <CAGsJ_4yW-58kLX7PCep=HVfc-CxE6rF7QKZhYjdeLGve7HX6pg@mail.gmail.com>
Subject: Re: [PATCH v2] mm: vmscan: don't count per-node proactive reclaim as
 memory pressure
To: Vernon Yang <vernon2gm@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, kasong@tencent.com, 
	qi.zheng@linux.dev, shakeel.butt@linux.dev, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, baoquan.he@linux.dev, 
	hannes@cmpxchg.org, mhocko@kernel.org, ljs@kernel.org, 
	roman.gushchin@linux.dev, dave@stgolabs.net, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: o17j6ka3df47g46dztmgdrmzpdiwqdsw
X-Rspam-User: 
X-Rspamd-Queue-Id: 521FF18000A
X-Rspamd-Server: rspam08
X-HE-Tag: 1791774352-144468
X-HE-Meta: U2FsdGVkX18hojJslIiMQ4e+OM3E7N37EyrKVHhy6Jzw2d9m1JEMBHZciow6ItCiUrux/P8h4dSCd7+ufBHfEKopsFxGB24KZZFSSvSXYg0whlyHNGUJ0HHnpexrJUy0V+zGohaibMnehnsSBCDgHmFNhaRqKQvLYLYzV3h/e5g8fGnL4wVD6ZNT7KbOYVm7qIZ5Eb1TvnUruULsAiY/JLUl72oxRqc3nh00x/rvHqQ36fX7AGLUUroPWZ2/ZPaTgNFbs9i4JjkPwnTdgQZ4wPH7c6WpDbFs/fVIIrzJ+Vfj6WG6xoMtAwJpR6/g7f/r1GAslSmSVIfzueNqR42kG9/BZ3/5puxID79WKbqM26F8jZd8Gudam6GOEwzhwNfk9gdXfVTMDr82PISl1KFE69ix6XrJEv8XkXJkXxoowgHRvRj62GW2eNrUBKqwr+sodGCds/wlWa/IUarSL3C/o7F/8JQ8JGW19KjFXzn45shHJiXj4pFh6QPoL2x2TO39UclF0gZ50oCrZWrJBKx0sKdkC9eOOwXXZccjERVInq59o0HPnhoFbuTcW+8uTYhE+O12a6pAfDBJlFvMaHUiDHsdqnFMmupT5CJ12VieXFNYaRbb7MbxUDFowAFH3RGE887rI9MGNmiRkDZwbAPfF1Qu4v8uHc+eaB+lSzSxUz6Laj7zR85KBxvEInZ9JdjK3aeoC3qHWby8DxBOysDTvQkial/Wq0TnWShlRtkd+pbOBvFO4m+jOTJBXnxLGI4CYBIEN2n+LtqIQm9Co/4lp+h7sjbaPrQbZGq8X5N6tCFi+Nb9N9jMdCn7m7iqQXReq1G1OogP/P1pc4R3QPfgiTooxEcpyFpdM3LlDTaELjwHHMGVBrMSlDgKz7i/g8i49UEHSiZZZ+jP1qbYQKoI5dkQFApYJieYEfHTXW3gAHgdy31COClbA6iH/wTHYpl6yfkJTGFQ9uOtp4m3Kqz
 fBqiaalx
 D8vc0+l+nYS9kaLRdhqpiFEg+T2LUs7bkStxRM5umukDdZVT3s2STEfCLAN32Sl1o/8pqjj8RTc1Vj08yhGx0NkKU+lHblcZxTXY+dDTbNA9klS3jX2y8Syi+IdlwGv89vEWYo8Cwv5wonYLLDI1EAbvsDCda3mtCJjzN+JMQuA79KrqRdQE5cmLWAF01O8tgzmjIN7EfkvVkDxXeoVq8QYOsCTPU1H1XYPDCxT97UZrJtisReTRJqXfjC5QNyo21kQLFiZbv3QLykLlmDc941BNJ5yWcPmFQ69bLqJ08kKFLkg5Y0hlMBcwof5srlpx/KNQGmLbaGnt4ZHANdH0lKKIx0XsW/JQdejSi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 12, 2026 at 10:29=E2=80=AFAM Vernon Yang <vernon2gm@gmail.com> =
wrote:
>
> From: Vernon Yang <yanglincheng@kylinos.cn>
>
> When the cgroup has no memory pressure at all, writing to
> /sys/devices/system/nodeX/reclaim triggers proactive reclaim on
> NUMA node, causing increase in the writer cgroup's memory PSI.
>
> Due to this reclaim is performed in the context of the write(),
> accounted as memory pressure on the writer, like
> commit e22c6ed90aa9 ("mm: memcontrol: don't count limit-setting reclaim
> as memory pressure"). This is unexpected, the similar scenarios (e.g.
> senpai) will continue to occur, only this time it is for the
> /sys/devices/system/nodeX/reclaim knob.
>
> The Documentation/ABI/stable/sysfs-devices-node documentation also
> notes that "This interface is equivalent to the memcg variant."
>
> This patch unifies the semantics of the memcg and node interfaces:
> per-node proactive reclaim is no longer counted as memory pressure,
> and the per-node proactive reclaim interface no longer produces
> phantom pressure.
>
> I ran demo[1] that performs per-node proactive reclaim 10000 times
> in qemu, writer cgroup memory.pressure as follows:
>
> without patch:
>
> some avg10=3D31.53 avg60=3D13.42 avg300=3D3.31 total=3D10602985
> full avg10=3D31.53 avg60=3D13.42 avg300=3D3.31 total=3D10602985
>
> with patch:
>
> some avg10=3D9.59 avg60=3D3.41 avg300=3D0.81 total=3D2686221
> full avg10=3D9.59 avg60=3D3.41 avg300=3D0.81 total=3D2686221
>
> [1] https://github.com/vernon2gh/app_and_module/tree/main/reclaim_node_ps=
i
>
> Fixes: b980077899ea ("mm: introduce per-node proactive reclaim interface"=
)
> Cc: stable@vger.kernel.org
> Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> ---

Reviewed-by: Barry Song <baohua@kernel.org>

