Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFC58CCD184
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 02:35:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26C538E000C; Thu,  9 Oct 2025 22:35:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21D228E0002; Thu,  9 Oct 2025 22:35:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 133798E000C; Thu,  9 Oct 2025 22:35:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 020C38E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 22:35:03 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9225F1DAAB7
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 02:35:03 +0000 (UTC)
X-FDA: 83980637286.16.BCDA475
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id A396280007
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 02:35:01 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fi6M22h3;
	spf=pass (imf02.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760063701; a=rsa-sha256;
	cv=none;
	b=4y7KBfrVRCj2Lw9L2VS0j5Eeez3J2/4/Z/g6Z/mRg87xZa23hmoAtAP9wDeqNYcW6iWo+M
	cenOl0ZijB2SeMCIr85/PX/0ami4mfZiNcWFElVDTdq28XqIfqYINZnKL7XVo8SnNH6ot6
	aE1kX+zwDeTjq/bfB9MPk+rgMPJGcCA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fi6M22h3;
	spf=pass (imf02.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760063701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tIWi/3dw7Y/B6UNkZ8GT9fPZy+5t2gE490BwSMo89z0=;
	b=oRwXV3QLYBNmyQIlyuz36EybKsidagRYB/YHsBEhDf9TXGkMd0L0CaKvjhm4DqXid1Q5OO
	3h93ZPzNbOSdAsG1Zm9t30IzMqVR8sykKzELydjyzOlENdoYL4RHBU21WUrV/NTYBP//CG
	vF4kicXuq9QHfvRokQ4ApFsLnC3u3eA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E5EDC60274
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 02:35:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96555C4AF09
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 02:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760063700;
	bh=9p31MGsioiR/mBzAv4tO7Yg6vglO8itTySFsYU+lMSA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=fi6M22h3+HKNVq8//FX3NsODgAjTIFVXEWtZ1jg5Kva4uzz+PMaFIWP11u9WgQoy7
	 VM0jQpykC4y+lnta9VfOf9NJUDHAVXd1XSv1IGBe2GAQmWxUlvhJFeImNQHBQoMLtK
	 xiTbSmpQfEE+xT8Q9S4Oh6K/E4lDmvVTXqAYtDdfshHO8SvZrVqWz7i9u4C4NDHM0s
	 ldComDJRahhAiioaaoS2D+2zOafShEVI4lxjpe7n9xxMY/hS2j3LqB+HAjmfPtKd/M
	 OJVVxPWt1umbdGkDcth1ZcNN7c6ukYiVZ1UuGKiP2Ez3c2eWHfQ5TJ8NM3W8vkEzKO
	 2s9yY8hVbhitQ==
Received: by mail-yx1-f48.google.com with SMTP id 956f58d0204a3-6354af028c6so1715187d50.3
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 19:35:00 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCU0EA9/Sgr0sVwjbXNjkOZkiGoUkPfB1M5SPyvlAAG4kc6ZOlbID/x2GYCFpAEtcP4SAN1RZ4b6Eg==@kvack.org
X-Gm-Message-State: AOJu0YyPKKA2if/EKTB5kQHPzc5r9Sek0b/QNpcPcOq7sSYw0lfymx6I
	koiH1QcR1wi4l+/do4K4Q4cTilKBDBUD7IuJBxvQNpwBF5Qch70Chwv4pI40ypU0AWXny5gBH8M
	bU/Xc0gcZXTFXYAU3KieQbjp90L0qnVPZx+L8LFneRA==
X-Google-Smtp-Source: AGHT+IHL/dTz7ThfMsAc1OPHjs4D6d62ntKT22N1PFcCGvrCDRDEghMer6Glt86YJvNvY55Df884elosW0vbPIj3Wxk=
X-Received: by 2002:a53:dcd1:0:b0:636:1fd9:d640 with SMTP id
 956f58d0204a3-63ccb8168cemr6571142d50.6.1760063699947; Thu, 09 Oct 2025
 19:34:59 -0700 (PDT)
MIME-Version: 1.0
References: <20251001043436.41338-1-bhe@redhat.com> <20251001043436.41338-4-bhe@redhat.com>
 <20251008202623.1ef2ac29af9b9c3d53aca4b2@linux-foundation.org>
 <aOdoehPH1O2vJnqv@MiWiFi-R3L-srv> <20251009182840.55426eb0548e7da1b721d4fc@linux-foundation.org>
 <aOhsF3x3dXD/keki@MiWiFi-R3L-srv>
In-Reply-To: <aOhsF3x3dXD/keki@MiWiFi-R3L-srv>
From: Chris Li <chrisl@kernel.org>
Date: Thu, 9 Oct 2025 19:34:49 -0700
X-Gmail-Original-Message-ID: <CACePvbXjjLsmuNb1N4KPMY+ao1Tt_zBxGc-SHP2wz0eTU+meZQ@mail.gmail.com>
X-Gm-Features: AS18NWDLK5kEiPPnALAlQaOeKijNZ_NIeifYhUXPrSNAkkp9oK337EBqvRkmbzU
Message-ID: <CACePvbXjjLsmuNb1N4KPMY+ao1Tt_zBxGc-SHP2wz0eTU+meZQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] mm/swap: remove unneeded swap_active_head
To: Baoquan He <bhe@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, kasong@tencent.com, 
	baohua@kernel.org, nphamcs@gmail.com, shikemeng@huaweicloud.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: 18sx3et1idm8cb1rgwroj4zi95zhmmdj
X-Rspamd-Queue-Id: A396280007
X-Rspamd-Server: rspam09
X-HE-Tag: 1760063701-280240
X-HE-Meta: U2FsdGVkX19m7aQJAqbxvOInF9H8vGLfHUkUAzBBRNk3t63VfbW3E9BCp+VtJlNEDsLqCODjU4X8HGTgCZ5sM0Cm57EYZuLqhYombXQZWa1nNVuV+nBClDcXxlJh2pQMJnQRaJ29dDJa4U9gAQWeCKxFjsehybnWW8UX+/iblVcRbYkD0MrI1PC/yU4euiFDqElNcuR421Melpr/u2DjBXhzP0qNabQMsM7y4wL60YNTE2LtUTFSnaEvhd26OpcjNMmqvDx/HUtAHQy3F9hE11p2Jsp5GHPp6hFhhAQj0QKWLgG1edl3BWzKRmlPxJh+vhNtbqrLCTU6RKk7aH6rcl9tXK2ZJ5Aiu0m4XTBVFrEiYtJGejaw5n2A50PS5f5NRNXr34oJgeRZmPiMvBHQHvPwCC5rW9CaFPw19/nAon+a0kNz7fygfEodLjBGM0copmEz4DURpljzWrHAJAF25SKr7b14lYxhLHW4hs3JvSVhmk1NE6zhgr4xJv2wjMRyp9dUjHr/cLnrBzA/ssoU7Wvxx1mqEu+ySuxnIccOGVfBjMWT4HH2qugPASC4GdzyGA5CC+WeCTZ6EptqqU2yms8ML78aktJdQVtT3Kqzg1KAhvh9q5mI8kjYH9DL/A5zOw0B3Iate/wiB16yCYlPDzqxEfI4DLfi3q/mRrq8anSiOrop211iK1lnwY9pvnewnB/Zx+zH8KFyeEteGyukNZgkTWQYXzrXA4TPFGAU0DfJI0A80FKZ+CIYUriaBsVm9KrgWRd6rMk/51US8s1X3ZFjFePV1u2Ce5R9rGhHZS8Yx7Bwl98ZwVR/9ESrI25R32bmQEDydac/cV5DCYMCnAONjN1FaDTdEdfLPt+o/byv8I3+de6pEawGS1pT5USIzR2IDVLIiePUzpnpZcEFWh/VlVrW+mUjoOnuLd6XCJIhlG58jNM0SwS+r8pS4C+7D9WOg/Zu8PM6cRMxwN+
 w7sp826n
 zs1pFL6e2Ziwoqa6poCFF7WtNIgu5jBM/L3MfllD87FJQHQB4i7GSiqYbKP2I+FRxlk/dl/b3IUR5upGb+MRWuqO/P902mTfKU55NevjlNK+bZCFzDKSSJA2SkOYp9wKU/lmf4IvzPCjCbC/f0CzNO+dDf9zVtHYxZoGmLowwepqtDvHc4CWQ87Rbx0fw9J6rt8hNHN6nhy05/tFhhxqLWA9skN+eZf7tXPMvIO4Qv0ralCnwA3ybKu6I0BrM5YHuuZ2IuNqf71Tnrdw5SG20qj/9sLm8CYYuhYbX5ydmYUp/lTtWicPZWLtYitFM0ba6xEVYcWOZCcr6QMbHjlytKtP/Rzc0Ybav2OiE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 9, 2025 at 7:15=E2=80=AFPM Baoquan He <bhe@redhat.com> wrote:
>
> On 10/09/25 at 06:28pm, Andrew Morton wrote:
> > On Thu, 9 Oct 2025 15:47:06 +0800 Baoquan He <bhe@redhat.com> wrote:
> >
> > > On 10/08/25 at 08:26pm, Andrew Morton wrote:
> > > > On Wed,  1 Oct 2025 12:34:36 +0800 Baoquan He <bhe@redhat.com> wrot=
e:
> > > >
> > > > > There's no user of swap_active_head, remove it now.
> > > > >
> > > > > ...
> > > > >
> > > > > @@ -2553,8 +2545,6 @@ static void _enable_swap_info(struct swap_i=
nfo_struct *si)
> > > > >
> > > > >         assert_spin_locked(&swap_lock);
> > > > >
> > > > > -       plist_add(&si->list, &swap_active_head);
> > > > > -
> > > >
> > > > There's a large comment in _enable_swap_info() which needs to be
> > > > removed or updated?
> > >
> > > This patchset depends on below patchset:
> > > [PATCH v3 0/2] mm/swapfile.c: select the swap device with default pri=
ority round robin
> >
> > Oh, OK, sorry, missed that.
> >
> > (When I'm working on the post-merge-window patch pile (700+ emails) I
> > go in reverse-time order, so highlighting dependencies like this helps!=
)
>
> I see, will mention the dependency at the beginning of cover letter to
> highlight this.

Right. Please hold off this series for swap tiers for a month or so.

> > > By the way, Chris worried the plist swap_active_head could be reused =
by
> > > the ongoing swap-tier work and suggested to hold off this patchset ti=
ll
> > > swap-tier work is clear. Now seems it won't impact swap-tier, I will
> > > send a v2 against mm-new.
> >
> > OK.
> >
> > Is Baoquan's "[PATCH v3 0/2] mm/swapfile.c: select the swap device with
> > default priority round robin" series still considered good to merge?
>
> Up to now no objection received to the patchset and got ACK from Chris
> for "[PATCH v3 0/2] mm/swapfile.c: select the swap device with default
> priority round robin".

Ack that series is good to merge.

Chris

