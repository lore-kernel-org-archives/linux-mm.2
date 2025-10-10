Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52195CCD183
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 02:52:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 863CD8E000B; Thu,  9 Oct 2025 22:52:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 814708E0002; Thu,  9 Oct 2025 22:52:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 729D28E000B; Thu,  9 Oct 2025 22:52:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 645408E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 22:52:27 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 042391A013B
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 02:52:26 +0000 (UTC)
X-FDA: 83980681134.15.D11D542
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 294F420004
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 02:52:25 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YrwR9Nos;
	spf=pass (imf13.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760064745;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kU7urDg7rZTTfXOqwh48pE6KbpFzOfWmpZ3u99MFwtc=;
	b=Dodk58wiZ/FuwIibopG5jPlAq2Bv+6hetsB6PZCN0ttZ81Fv8t4bDCzvSU4LlXjvHJI8xi
	fl5J3ZkHwmws+VSdLgsJ/5noPdxEPUQrq0rewPzKmc2Hqq/h3b3i+demiNV9pWwYcXZDhW
	t5f7ZfMRAKQ5fBt8BRVIujq0cp8ogx4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760064745; a=rsa-sha256;
	cv=none;
	b=qfkd4oj38dORa8yN+NWE+8EMxWGeroTSqZKJU20XzkxvRiG8kuXFuoa582gdfImm7V/Ckz
	oi+PRdn9KCkNZfUDUOEHvlTd1Rh5rJH6ilpsOILv2fDdtyNwYgbVX+aMuegpsy+yJ5jqK2
	ByTwoF1iMKpv8EiC7eXTbCbRGfOIL3c=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YrwR9Nos;
	spf=pass (imf13.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7B143624A9
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 02:52:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 245F5C116C6
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 02:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760064744;
	bh=znhVVt/xVT+0zD2wOhtx3kG1HT5EzgCjpr0/yNJdHzA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=YrwR9NosY3qlJWWh+bcfpiMzWSMDtcF1/GnzQVT59FvmtGJgcR8bNACKs5b6/CpF1
	 6lmUAWLhl4Yo5Y5ugsZSYouH9mUF5gpc1qQz5j1dcgRrTRqrw+IpsY/nr32m23qTf4
	 NjRzFBpgiP8z0v+9DycX0eRTFnCDzUn3IivnQVqDE+LAmRou8ADcwGwN2FN/XHeqIi
	 rdz+CsB2riLltpw8rSFSNlvn80CQrsmX+fF1uRcy3TGMB5TlxCcEoG9YtEnFmHAkXR
	 Wr5FzlQaf+IfUM90zX0FcySTVaLujG3nAA/rXi/QbpDGg2p4HWVlD1CtRjBbCOLAJi
	 tkGspC5gOYGDA==
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-71d6051afbfso17091347b3.2
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 19:52:24 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXu4T0/VNxAoM1ofOP4an5paP+TVzZWJ+iQLcxmhb4usDQzdErkK7bqK74bKIljnROPZDUdFfVUNw==@kvack.org
X-Gm-Message-State: AOJu0Yw6GMVdZ5O1Bs8pWEYS+PMqLzfyOSI578mWVMyL7FpWxNRGstSY
	gahh5lE+RbvGBl1FiWHe9QXgRS3n8AkI30oOmr4g26HDplt+1cmPuVNZvKSchsZocYrW4lQvXuJ
	8I+Wwd+3SxFO0tBZIpNRohuggbnYVqMRI6SEh5IIo4w==
X-Google-Smtp-Source: AGHT+IGxi2fGZrmcE7a2O3KE+s7xB4gsc/TkKZQU++0aKXoEGMNhqEMiAAWtZ/+lhWRgmuZnXLFVIx67ZVwDFL7FbTI=
X-Received: by 2002:a53:dcd1:0:b0:636:1fd9:d640 with SMTP id
 956f58d0204a3-63ccb8168cemr6586521d50.6.1760064743404; Thu, 09 Oct 2025
 19:52:23 -0700 (PDT)
MIME-Version: 1.0
References: <20251001043436.41338-1-bhe@redhat.com> <20251001043436.41338-4-bhe@redhat.com>
 <20251008202623.1ef2ac29af9b9c3d53aca4b2@linux-foundation.org>
 <aOdoehPH1O2vJnqv@MiWiFi-R3L-srv> <20251009182840.55426eb0548e7da1b721d4fc@linux-foundation.org>
In-Reply-To: <20251009182840.55426eb0548e7da1b721d4fc@linux-foundation.org>
From: Chris Li <chrisl@kernel.org>
Date: Thu, 9 Oct 2025 19:52:11 -0700
X-Gmail-Original-Message-ID: <CACePvbW02C9NROqURe-4MA+7zs8pdNdJdhFkbu-+u8MCAtjLCA@mail.gmail.com>
X-Gm-Features: AS18NWDl_PZIXgYvv9sY9Q54WP4ArjGDDzLC4L4yi0077lrgXk8qL-U1MBkhS4A
Message-ID: <CACePvbW02C9NROqURe-4MA+7zs8pdNdJdhFkbu-+u8MCAtjLCA@mail.gmail.com>
Subject: Re: [PATCH 3/3] mm/swap: remove unneeded swap_active_head
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Baoquan He <bhe@redhat.com>, linux-mm@kvack.org, kasong@tencent.com, 
	baohua@kernel.org, nphamcs@gmail.com, shikemeng@huaweicloud.com, 
	YoungJun Park <youngjun.park@lge.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Stat-Signature: a3iy3378rew6ywiosn378yuxbf89f67c
X-Rspam-User: 
X-Rspamd-Queue-Id: 294F420004
X-HE-Tag: 1760064745-46358
X-HE-Meta: U2FsdGVkX1+WekYACBQyLA3iewLIZii4Voo4U8He3D5QxADq8jqRuPpG/n0Y2XiOj78On2vlc/1QyI59IQSTHQP+8CYDY2Ku9qC9BHc0aQZ/P/Pn2EJqSSu6q4gQjZ2VcI0aCqEeGQqiGpaRTCVlUZdMeCAznaN34J+RRn3fqRXoHO+IrkPKF4Jyd+k84Br59gC/PyMD2FfiuJTjT4yp+BI6mSOtI24FlTwewzmsB8jcwftTByBGD3v3cIXXEE98aCDAp7pjHSPifsPE/7qkdyysg+z5mfQ8ujcvXbncTb3Vae7g3WXg3QdsN+FD2JbZxuZRcMkcO7S7XmwX6dEdFkoSYRv1PzVFdt60g9WpRqphKcexLz4lDLugMKbBH8hwwl49TXNA48o7AOx99WWWXARLEBYCsy5+YD++DyIgNm773akzVRZgB+t8jkmrExzE9PID2JsHGokLonUSzKoiTdf/Vb7aDEviu5I5w4MF/ymLTBHRgfuu1PLtA7KIfII1u3YxR8mmNO0tAzh7Ji1jDO2nLtkaG8gPEjJgrd6BoIDhRNF/UN18cmGvRfUwckcvD7DMvs54DYQ1kvdS+OwxVfZAGD7RQvpMwkRnqyvA/CTwIbw36xqaMGnQieRV9LM2IR9K48mwEUn8EYrduLoTgu0ucZfBwU71Jl2uacxBZDs4B37zfx8pGB0avbjK4V5so5vbrWVEHxHuGpzh7uHMTVmOGcIMHTE8R1k43vcX6s9KfjQmTeEvC0YLXmOlPqsJAmm5aMjLbqT+2y/UDelRKf5sAtheNlJl+gUqwnhJF8aER7SDaLX6ZFKVvFtJNtHKasdi/W+DFsU0M/4XdRgT9ifJvLZg4ZaFloASXUX57sijCRTxFHc3tPFvFSAsFNYdBu9WR1kNnSkc+SDdTr6Mt59AHSWjXU+k8tNY+x4Xo2aIBMEJKC9rgzPyzD4iotFlSaG3PwJSK/kEu43xvU+
 eJMpqvIp
 FFouJlZ01iYRlWxYJooCk1VvQqGEAJnybCjwGwW1Ynf2idJ/01uwsMqQ3/reD3Qw1McXZ3egoxDkx8Zoi+mi0vE1EHwtWrYqo86Mwu4dFh3SKyrLSJ1gIOGvlb3R/uNDwuI+jOEumvJ9G5pDfX0Wm5HxxHr+HTqwLTlzYgsgBe9eILIXBqo/wAIq/pzFo35VuCFFyXzCrDMM0RwAT3O7OLvCsCIMjHQ6pNC7I2WXxykKwkDZVVUTYIAvOp3H+TAoZPgRJop80a0I0LInoQvGxAuFjQhnoLehOyNrokFpjMGwy53HyAlr3cT9Y9bQrQ9YRK57EDHYV3hi6pW/twrO3vobXsp9HMf+Fc0IJuBlSiTR+B6EdNf/LUOCyhAatyHg1OMNC3eW45yTjZfUgRtzdqGg/zTLba278BFxo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew,

Please drop/ignore this patch series that removes the
swap_active_head. I just received the patch from YoungJun. Just as I
worried, YoungJun is indeed using the swap_active_head in his swap
tiers patch series. Let's not remove it.

I copy/paste from YoungJun's patches here. It has confirmed usage of that l=
ist.

+
+       p =3D plist_first_entry(&swap_active_head, struct swap_info_struct,=
 list);
+       for_each_active_tier(tier) {
+               plist_for_each_entry_continue(p, &swap_active_head, list) {
+                       if (p->tier_off_mask !=3D DEFAULT_OFF_MASK)

Chris

On Thu, Oct 9, 2025 at 6:28=E2=80=AFPM Andrew Morton <akpm@linux-foundation=
.org> wrote:
>
> On Thu, 9 Oct 2025 15:47:06 +0800 Baoquan He <bhe@redhat.com> wrote:
>
> > On 10/08/25 at 08:26pm, Andrew Morton wrote:
> > > On Wed,  1 Oct 2025 12:34:36 +0800 Baoquan He <bhe@redhat.com> wrote:
> > >
> > > > There's no user of swap_active_head, remove it now.
> > > >
> > > > ...
> > > >
> > > > @@ -2553,8 +2545,6 @@ static void _enable_swap_info(struct swap_inf=
o_struct *si)
> > > >
> > > >   assert_spin_locked(&swap_lock);
> > > >
> > > > - plist_add(&si->list, &swap_active_head);
> > > > -
> > >
> > > There's a large comment in _enable_swap_info() which needs to be
> > > removed or updated?
> >
> > This patchset depends on below patchset:
> > [PATCH v3 0/2] mm/swapfile.c: select the swap device with default prior=
ity round robin
>
> Oh, OK, sorry, missed that.
>
> (When I'm working on the post-merge-window patch pile (700+ emails) I
> go in reverse-time order, so highlighting dependencies like this helps!)
>
> > By the way, Chris worried the plist swap_active_head could be reused by
> > the ongoing swap-tier work and suggested to hold off this patchset till
> > swap-tier work is clear. Now seems it won't impact swap-tier, I will
> > send a v2 against mm-new.
>
> OK.
>
> Is Baoquan's "[PATCH v3 0/2] mm/swapfile.c: select the swap device with
> default priority round robin" series still considered good to merge?

