Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CE05C4452B
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 18:24:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F64B6B007B; Tue, 21 Jul 2026 14:24:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A7956B008A; Tue, 21 Jul 2026 14:24:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8967C6B0093; Tue, 21 Jul 2026 14:24:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1C5206B007B
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:24:26 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6BCAA140249
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 18:24:26 +0000 (UTC)
X-FDA: 85013608932.18.7C1D6A4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 7FA2DA000C
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 18:24:24 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DVV+feby;
	spf=pass (imf25.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784658264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yvn6r7dHmDV+5JRqVix1IFpZCujrNiFtwZVefWGMRs4=;
	b=JjJ3YVul0Ee4kjUmlvLII8lVM3lGaEYF905mZAA4PAu6uzzLj04mnGbHWQF5ov0rXLe6e9
	61F/0dPCoAtYAHftDyGosZMLgzWjNOMytDL+x/T/jO1WkdWLpR373q4bxnopQx2SMcHPrG
	uY/EUbjVamtNqV1PDTT28kRyBYEv2dY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DVV+feby;
	spf=pass (imf25.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784658264;
	b=xFk7NuMqNFGunHgSNDAi85+KRlsLnl0Z0J2bZORr6Xg0r/gbTbUbkJmeN+5asvnvkxpFlj
	K6gT4I66INesX413ikF1rVaEXlz6a/Mw3JqbuqZ6NWnscWu5uje0VO4rYmflPK2l3XOBGd
	wr665TKU1S/6SJOmwgseplWLrSjrR7I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B367B43D68
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 18:24:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9794E1F00ACF
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 18:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784658263;
	bh=Yvn6r7dHmDV+5JRqVix1IFpZCujrNiFtwZVefWGMRs4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=DVV+febyc5SvZzqTFnHNw2MPh3b+F9nSZIuNhLgTZksAbb3j9qNUtbYoL0ddpXEgL
	 sdNOglak/5v3rcobGxEMx7QYOSVvCbagF+BEH6eIovd2R3FwRiqAYMAksJrBO8LFp4
	 9ywnb8JLyqUFlYVfKiDu63UK7u1dhEwgVwI4srmYpuLMjbLvoAZdvgMGu6MoElbLQ+
	 ltnWYq/jDKzauGvWDi3CSJQ3Nd/ffIfom4DGPddbVaqJs1jT1LjC5xKVAG4T5I7nnC
	 Cy/MW9SgLfpA/3JLXi8wTWo8lqNFAjHZxhEmYGc3rm9S1uHBIDAOcLujYHR7TrM9aX
	 89i2eRU0UtLCQ==
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-8143daf89c7so78316167b3.1
        for <linux-mm@kvack.org>; Tue, 21 Jul 2026 11:24:23 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rr9bVQTQvdU4Aqn65YlU2iU0HoOm+KOa4EfM5fT3E3R3J1h9I1YFMFFRrxBl64648ORCqu4/NIkFg==@kvack.org
X-Gm-Message-State: AOJu0Yz36RcX3EsbIC5OQnSSkiCfdyanchwHDZdt7msXitgfMol1CjEe
	EkGKMi4AmQkJYVmkEHVl3qV8svBNATQifA8FQN5+Kq4r4Uer0GMK8YHnMo664SOQVoXwxro6daK
	r3pCOS0QSJ64K4TuLhU+bV68Jb4REP//KiqB/xDBwMg==
X-Received: by 2002:a05:690c:6303:b0:80b:a6a3:937c with SMTP id
 00721157ae682-81ef23e7382mr58902807b3.20.1784658262941; Tue, 21 Jul 2026
 11:24:22 -0700 (PDT)
MIME-Version: 1.0
References: <20260707082614.95030-1-baoquan.he@linux.dev> <CAKEwX=P50av2rfocpsqZoDQowZ=EEhQ-5vj5tBykbNz8vtKTzA@mail.gmail.com>
 <ak-IS61GeP85Jnxg@MiWiFi-R3L-srv> <CAKEwX=PEgnJ4nGFZYUwMryjq+Yp4v8Op_HdZ6_xEJ4n_MrM0Yw@mail.gmail.com>
 <aldtS2S-TXc7ocsH@MiWiFi-R3L-srv> <aleW5xL2gYcU_Rl4@MiWiFi-R3L-srv>
 <CAKEwX=Pm_C6OD1jAo818wzFVVhLwgVFu-4bLdNrmUZ01URpLTQ@mail.gmail.com>
 <CACePvbV62T9LA894vTXzBZQ2PNh6iYZD7eH6=UjeFSWhUW2aDA@mail.gmail.com> <CAKEwX=NXJ1LKQOA8Qy_4YOS6v+jGbAJnbD5K0=jNbgC8Da0iKw@mail.gmail.com>
In-Reply-To: <CAKEwX=NXJ1LKQOA8Qy_4YOS6v+jGbAJnbD5K0=jNbgC8Da0iKw@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Tue, 21 Jul 2026 11:24:12 -0700
X-Gmail-Original-Message-ID: <CACePvbXAqutPvawTcBXLa47=WVKdLBDHL8unKOSvV+KbrEmmwA@mail.gmail.com>
X-Gm-Features: AUfX_mys3vauyZ8WwH1CBisqlM0IDjOy1s3SJEbaC5t0V3bCJk4rdpRQb67k2sU
Message-ID: <CACePvbXAqutPvawTcBXLa47=WVKdLBDHL8unKOSvV+KbrEmmwA@mail.gmail.com>
Subject: Re: [RFC PATCH 00/10] mm/swap: ghost swapfile with backend switching
 via Redirect entries
To: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <baoquan.he@linux.dev>, linux-mm@kvack.org, akpm@linux-foundation.org, 
	kasong@tencent.com, shikemeng@huaweicloud.com, baohua@kernel.org, 
	youngjun.park@lge.com, hannes@cmpxchg.org, yosry@kernel.org, 
	chengming.zhou@linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7FA2DA000C
X-Stat-Signature: 1tsutw81rogxizc535bky1pdc75ssxun
X-HE-Tag: 1784658264-622111
X-HE-Meta: U2FsdGVkX1+0H/5oS8qc8wvosjT0MWsWD6oJfU1G8KIgIl4qS5aUsoRQsLjbh3L5gkJeTpJSKAupxehZZofSJhGOX4S3QQMnUtiBzW7XDCt4ce66Cc+9NIpxUukVNc+u0/xkBMv8qWTxsNh26a5w4Dpnp3rqsE5xnklyutiHB66xM3AkoaHr6PTYJAhEIsq4PCx3n6Jj7o4/d/e3N1G9RATSCTHWCmiJ6QQV/vbTkO7adw3645ttyRukQUifiVBMel0LXVG5ZjxGcsFbzWIdoCF67zShlslki9+dwOoc5WzVu/PX7fb/3v0JRj/SoQunfxEOzKpeWTrY0XeBAfEncbHojQYxQiNXO1yvZnEd1gV5JCeW7ATEBW8dJFyESuYWpdOFJjJ81BNhSB1Xb3HPl+MVQ1///KZaj6Or6gF8QfVP25B6SCJv/b0052q3muGZg5WqRRRYesHiYMlnPJO3znAMKEd0CyWmEtyHRNL3+iQFF1FccTfg+nULXYjJ2Kb51ICR7aiJHuFO1jm/3imFi2JEjeBWuZ0nEexjPLJC9PlA5ODaVMZDVpgULkShQVayTmKmLn66J97MeWHY6DCfLjw/HL8YTNk8SZGpgOVCgIBvopWUDPlfSKu2D+ijSrq9E/VLTq+C1dUH1p21c+wUe7bxaKcGHCt3/C1Al/kOVsENH2qvTpJACfm+yinPoNBt7fTp15zbFz7yWReJvniBpUSMukt6j5qe6me7F2mHmJHSXbMEu6CdPavqLjgZekdI9n9p3vVh649vA7Bw97lLYMv49ReXmJyrM4dXv3DHWbsAtOLD4FsdTAmC4sHWJeNCtwYK+LTxhyrhQ5n1RP4tfvxZTD/aXbKRa1UAKHOhLAbxlPQIV058yTdLbeeXxH7RdSaHkI4NDcNwOjR2yQ1gKMB+2mo1ttc3UwzoHwH8gqIsu7+qav2lozvGrWe3VTdjfqAZYda+7eD/HgmS4Aj
 4CrSptQ5
 uKEPvX50nnLmO9m8QjyInS/IhZY+ntHonL9XjK4Vh91+1rz4hMSIxcuYIniaDl2CNTtXgGfAWAZVJ4cftLTzz7vCj3NFAaUBeJYSZV15XJYemBPxBpJtoTWRHQp9fw6rX2Ln1ThT3y1/3bEBtzmeNNFAlbuXiAjUA1KKDoZIyUdD5TT6wXRHZrsXWulMX/nbKY4GR668WYqFiX3raj0JrepBO7dO49Upeun9XocT3FyKA40obQhD7ziLWksCotIzIE8TZxjzBg4RPDBlD8gWRCT79hTlCMfkrGkjg2UmkDfvAdE5pZxrq/Q6FJBAHCBjVTrLvKhe5cqRUkE4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 16, 2026 at 9:49=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrote=
:
> > > [1]: https://lore.kernel.org/all/CAKEwX=3DOvR7GbU_9f2h_MtU4m0g6s-esHm=
NQKYNhJz610M0P3Sw@mail.gmail.com/
> >
> > Hi Nhat,
> >
> > Sorry for the late reply. I've been busy and just saw this.  First
> > impression looks promising, it is better than any previous version of
> > VS. Thanks for incorporating Kairui's feedback. Please give me some
> > time to sleep on it. I will get back to you on that.
>
> Please take a look. I was waiting for your response as well :)
>
> The patch series is large, yes, but it's an RFC meant to show case the
> final end design.

Understand.


> > May I add one wishlist item related to ghost swapfile here? I will
> > reply to your VS thread for other feedback.
> >
> > For the ghost swapfile usage case (no writeback). Can VS support this
> > usage case while maintaining per-swap-slot metadata usage comparable
> > to the ghost swapfile implementation? If we have to put a number to
> > it, let's say the increase in metadata is less than 1 byte per swap
> > slot compared to the ghost swapfile implementation.
> >
> > We have large deployments of ghost swapfile in the fleet. I want an
> > upstream aligned solution that does not increase the existing memory
> > overhead compared to the current ghost swapfile deployment, for that
> > usage. As you know, memory pricing and optimization pressure are high.
> > The ghost swapfile patch itself is relatively simple. If VS can
> > address this usage case, it will remove a lot of incentive to explore
> > ghost swapfile-like solutions.
>
> Hi Chris. I have some thoughts on this - let me know what you think.
>
> I understand the memory overhead discussion here. In the case where
> vswap slot is backed by a real swapfile, I have not figured out a way
> to make the overhead disappear yet. The damn rmap is very annoying - I
> have some strategies to get around it for certain operations, but none
> of it can be done without a full fledged patch series of its own.
>
> However, with the ghost zswap swapfile backend specifically, I think
> the overhead is going to be negligible compared to the status quo

We might need a clearer definition of negligible. e.g. in my mind less
than 1 byte per 4K size swap slot.

> upstream (things might be different internally at Google - please let
> me know!). This is because the main remaining per-slot overhead comes
> in the form of one per-cluster array to store the "backend", here it's
> going to store struct zswap_entry pointers. This is not extra overhead
> though, because it basically replaces the xarray (that you added all
> those years ago)!

I hope you are not clinging to that xarray because I want to get rid
of that as well.

> The rest is small stuff here and there that is not O(slot) but rather
> O(cluster). For example one struct rcu_head per cluster, xarray
> overhead for the dynamicization - note that this xarray manages
> cluster, not slot. I think that's all, unless I miss something.

I also mean the normal path that accesses the swap table will take an
xarray lookup with different locking requirements.
I prefer to keep the swap table and cluster info where they are now to
avoid that extra complexity in the mental model.

It seems allowing the cluster array's virtual entry to grow should
mostly answer your VS need?

> So if you don't writeback, i.e no physical swapfile, then I think
> there is negligible overhead (no rmap and all that jazz).
>
> Does this sound acceptable to you?

Regarding the memory size, yes, if the overhead is less than 1 byte
per swap slot compared to the ghost swapfile. The location and lookup
path for the swap table and cluster info are not ideal because VS will
force a different location and lookup code path. I prefer growing the
cluster info array to gain more swap entries and keep the current swap
cluster and swap table data structures where they are.

Chris

