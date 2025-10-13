Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04600CCD185
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 06:17:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DBE78E0005; Mon, 13 Oct 2025 02:17:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28CDF8E0002; Mon, 13 Oct 2025 02:17:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A1C48E0005; Mon, 13 Oct 2025 02:17:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 094918E0002
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 02:17:39 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 80184C023E
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 06:17:38 +0000 (UTC)
X-FDA: 83992084596.05.6407DF6
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	by imf27.hostedemail.com (Postfix) with ESMTP id BD24B4000F
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 06:17:36 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eBsNhESF;
	spf=pass (imf27.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.173 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760336256;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k/dVPa4TRbPl7TiMIJPKcXrHKk45GME6H6iH0DRffoU=;
	b=bNZzB8AaRcAWnkCflzNN4r6WFByPQE9KdyBMyWetvBX+Y6Xgt4jlr3OKyaUcGJOMkLt/Km
	YGJ/RDdkWR1JjqamjydTiG4Kqj0zJ8eAISatHIJ6OscYcvTJrP2xARJIwbbNbxvUzpj3Kz
	WeUGgJRcbCmUtIdtxtn/Tigjen2Hr6k=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eBsNhESF;
	spf=pass (imf27.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.173 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760336256; a=rsa-sha256;
	cv=none;
	b=s9OUFTusj5lQjFlLJVWWBgN7NQ/GZV10dACKxKk0RP1x6fDOrRxzvX4Una4KFjjQq112ZZ
	Cw4llIgXyWRFbU836AmH8tghjDER9SeNzqBs4EL9mci/afw/FSPjYukIrfd1x+xYEa6fSE
	qZuYEaWM5Io/PRRc19exjzDNEBx19JM=
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-8599c274188so455123285a.1
        for <linux-mm@kvack.org>; Sun, 12 Oct 2025 23:17:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760336256; x=1760941056; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k/dVPa4TRbPl7TiMIJPKcXrHKk45GME6H6iH0DRffoU=;
        b=eBsNhESFabk0MDF6DejlyOTacrKLCL+OBQ+iip2yQEd/svI0Z8IZs9lOpoZkBgkGAd
         4G81lrmiBTDjIJ28zK27hHvT1W18UW9ldfPxBhwJbK9laIUJtnlze8VYgf/gXbgBVemr
         U87OJzW1FiXskLRlfTiXxq+P5uR5FB0cUkMW9gUnBWVZPRFVYslWcJ14XhOqupZ4ESwm
         STFItw9e0KVodQ7HTWg8l15NA7RzlS4kTAsylHA0tLPdQcUakxwnddaiOzAKJyPBLXt7
         efGiAN5K7ta77hEmWoqBTHNYqOI9pfBeRIYuHqFDeY7MvjyeS+DOJYmABYGQ9FQszz/O
         M3mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760336256; x=1760941056;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k/dVPa4TRbPl7TiMIJPKcXrHKk45GME6H6iH0DRffoU=;
        b=GjaH61m7MRND0oGLFAkvSwlPdtoRFi9XtuMAOvtN+wXl+LnAgd/Q3V1YUcIw8YSMGW
         fJF4F2/yRuIZ9eZctHIWYVR1UObVwFdJPboHHZJc4N5YD9UyjmEdAUXRO1wf9qV0Xlp7
         xW81MT0GZMUDSp0EjENZUzAfemG0KDZy1JLfqiYMaUW3KsDzT4SsM/nL08/z6aig+/Ns
         ws66hsJRzGSSzXL/RoAYxHzJ/ZLJM1ys6N/ocfves+QFvJWpTJWKs5CApUdACgrpkgaL
         hJwJSPaWxgJy+/2jvYp/YXo4R0CVTjwsjzDSjDshNHw0sSMRODP3fyMQ6qJUqnR/vajj
         i8Tw==
X-Gm-Message-State: AOJu0YwR0wsj4SqMoRtiER3WUnMOVTLH2WSjFrJn9tnADCVnRXYGHyx4
	izAt3Z9OBJEQUXwnRS1he6hGyCdsfPKbO3xPklz1hSKgXf9s10pW/3PL/v0ljDkZlxBs8gVQEw2
	VRY9eMtlJtdq53PQo1JXgPKe4DrlyEDU=
X-Gm-Gg: ASbGncutjNl3LlOxYZe7MmGSAzzbq65wLoyUwZYLHVseFX3u+i20UMnYPiCz4SvbnLK
	ouPFlSwXNNH9uUvQIVc2v/zvqaflrKPH1F8Ky8bTw/z/Q6h99LSShWf/KcgR0oORGvI5B9dYaYs
	vsWw4K2JphxxaN2qANnGBjYw1gPcL8jsadVnHNCgftwMJ+r5Jq1LTW0sIKWE/LxfU4R0ABgpDfz
	Lfuyqm//Rg1pAiOpcRkA+wFttorGs8hILwiZWqYhuJCqvgKKvhYir+tXIKf5+lk46Gn
X-Google-Smtp-Source: AGHT+IHGvJHd3Uy0GozRP00ValRizIiguXJ+IEY629aZawxCzN+H5EOaweZBBgl8Cb8zKPWHku/Jli3NjyBOC2EZy8g=
X-Received: by 2002:a05:620a:410f:b0:806:7c82:fd2f with SMTP id
 af79cd13be357-8835509897bmr2996629685a.75.1760336255659; Sun, 12 Oct 2025
 23:17:35 -0700 (PDT)
MIME-Version: 1.0
References: <20251011081624.224202-1-bhe@redhat.com> <20251011081624.224202-3-bhe@redhat.com>
 <CAGsJ_4y4CLu7qeHijhJtL+NDrehfiWpu9mtsVGxmn5rBy03v0w@mail.gmail.com> <aOx42iLkuyYqXBMW@MiWiFi-R3L-srv>
In-Reply-To: <aOx42iLkuyYqXBMW@MiWiFi-R3L-srv>
From: Barry Song <21cnbao@gmail.com>
Date: Mon, 13 Oct 2025 14:17:24 +0800
X-Gm-Features: AS18NWCal39fu6lJgh8e8o0unYzH-HcIkl-9vk402UgV8dSLNwrw7rfirxXqHD8
Message-ID: <CAGsJ_4zSeMfiy=9Pa3A3UtdNigOc=w4eWc1KQpkBbD4AdvmPTA@mail.gmail.com>
Subject: Re: [PATCH v4 mm-new 2/2] mm/swap: select swap device with default
 priority round robin
To: Baoquan He <bhe@redhat.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org, 
	kasong@tencent.com, youngjun.park@lge.com, aaron.lu@intel.com, 
	shikemeng@huaweicloud.com, nphamcs@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: BD24B4000F
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: tetwqykn1dc9rfgqdumkpt1e9mz6zys4
X-HE-Tag: 1760336256-254738
X-HE-Meta: U2FsdGVkX1/HhbTsV8rlgeUY3XFlxd/OVQs4bx0vqUYQof/2bbrnGAwhR0DAXziQimmUHnxloeqynPFn5BDCEcJGCU/fz82JMv7zAGJZ1pknlZEVoXgXP2Onf2fv44mhL5GH/JODuKXqGupZ+375R7DLTX90qEc2txTnRfjZonarWMqEXoLe7ejHK3cXKhLUNiC3rimeSPR4DKDqxbyvrE0dG1He531qqdXKDjbn7VH6e6Bvg+jFE2MeWbEVjHD8OggxMY7iJw2StN/hbz+hDwOs6uNpiQCNo6rKW1Sb8X5E4giMKaqW5nGqVJi8tchvuaF8u8nJasKaf5Fvftv/zu6YR7UFZWi/SlDuS7pR9TKku47uw3l/ZjI8IRkZszOD2rf4TQLJQxTmMYvXoMOxfWdXyBYYN0SP+c+aHrc5FFkq6zNe26zP9k9rZGyg6vFGAOzUmSJJMQ8Z7wtByG6Z0N1nMyp6E81n9ZK5hxjCD+mILoPmzchReHUEe7p64VRTDH29TnxL63+Z7GZP8rgUni17h0Bfo9HdtXDVTjB25libP6BlOfrWPaoUFfqCBEku1LpQt3LKlOrBprQPR4ILEjGI+B5raJCdktanFtRPjTQFK9r7aYx8G553DfRzvQlGSkBidwkOD+hFCjOaNf0EzNRqw9rjtTAipNq0Ue91LTNZUEybMetqN4QawXa0EEXdyVEqkMn28aRXib4rNwcyEyN4MvcHpfyaOb/I9Djm37+kP1Sz6oM/OaUq3chncHDf2c51TrRrCfFE0ucgdHlJhSbNG4lBY86PiEbfESyu2ZL/DO2uXo40EUia7/zIcyIq7XYCgoPiOiknjShJUmSp34VscOX/zrbzL7QK+woUYKh/UxC4cg07Fe+ejg7rxiuK4rVh1oasq5Xw0HjgzH7rnVxULu0S+FgeZYgCH2ULdYL0F3SPGNcuRj+DMNqpVRDHkTNg6JiuQ9qMdH91uFu
 7lNI8/N8
 L7rLwhmgDdClE/NTqifPWNMqIfz6QTfM9Zfcq4b0fhkQWV/Ubn8LcUfL9coU/3cxggvRolMqR33zBjF80XzE6vCOcWxET7JJNRDoSXrl1BQRVhKV1jhF9HQDA8RvAW+pZxoVJBavabHpfKVWQy89a+RZFBVBkXqdSxYCYaVENEzWzUvboNa5nahJ0ZuOFpnwcen+DMK3dx+pHCqlZ2yUl93hOBPt8ZvXjvoKL/D1QI/vRlJLwgGR3FQDmNildq0WmwxITePwnuesjaNM+QgJAq3mNV7QefoQ3xGmlNnXUkVRbFl31WTvZr7aduqEGw/ELEp8E+Fd0KRFeRvYSjJgEcnQhjRQlTdwifAy/3ctzm6HBCOZatTwyoTcaIooDFuUPer7b
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 13, 2025 at 11:58=E2=80=AFAM Baoquan He <bhe@redhat.com> wrote:
>
> On 10/13/25 at 04:40am, Barry Song wrote:
> > On Sun, Oct 12, 2025 at 5:14=E2=80=AFAM Baoquan He <bhe@redhat.com> wro=
te:
> > >
> > > Swap devices are assumed to have similar accessing speed if no priori=
ty
> > > is specified when swapon. It's unfair and doesn't make sense just bec=
ause
> > > one swap device is swapped on firstly, its priority will be higher th=
an
> > > the one swapped on later.
> > >
> > > Here, set all swap devicess to have priority '-1' by default. With th=
is
> > > change, swap device with default priority will be selected round robi=
n
> > > when swapping out. This can improve the swapping efficiency a lot amo=
ng
> > > multiple swap devices with default priority.
> > >
> > > Below are swapon output during processes high pressure vm-scability t=
est
> > > is being taken:
> > >
> > > 1) This is pre-commit a2468cc9bfdf, swap device is selectd one by one=
 by
> > >    priority from high to low when one swap device is exhausted:
> > > ------------------------------------
> > > [root@hp-dl385g10-03 ~]# swapon
> > > NAME       TYPE      SIZE   USED PRIO
> > > /dev/zram0 partition  16G    16G   -1
> > > /dev/zram1 partition  16G 966.2M   -2
> > > /dev/zram2 partition  16G     0B   -3
> > > /dev/zram3 partition  16G     0B   -4
> > >
> > > 2) This is behaviour with commit a2468cc9bfdf, on node, swap device
> > >    sharing the same node id is selected firstly until exhausted; whil=
e
> > >    on node no swap device sharing the node id it selects the one with
> > >    highest priority until exhaustd:
> > > ------------------------------------
> > > [root@hp-dl385g10-03 ~]# swapon
> > > NAME       TYPE      SIZE  USED PRIO
> > > /dev/zram0 partition  16G 15.7G   -2
> > > /dev/zram1 partition  16G  3.4G   -3
> > > /dev/zram2 partition  16G  3.4G   -4
> > > /dev/zram3 partition  16G  2.6G   -5
> > >
> > > 3) After this patch applied, swap devices with default priority are s=
electd
> > >    round robin:
> > > ------------------------------------
> > > [root@hp-dl385g10-03 block]# swapon
> > > NAME       TYPE      SIZE USED PRIO
> > > /dev/zram0 partition  16G 6.6G   -1
> > > /dev/zram1 partition  16G 6.6G   -1
> > > /dev/zram2 partition  16G 6.6G   -1
> > > /dev/zram3 partition  16G 6.6G   -1
> > >
> > > With the change, we can see about 18% efficiency promotion relative t=
o
> > > node based way as below. (Surely, the pre-commit a2468cc9bfdf way is
> > > the worst.)
> > >
>
> Thanks a lot for reviewing, Barry.
>
> >
> > I=E2=80=99m not against the behavior change; but the swapon man page sa=
ys:
> > "
> >        Each swap area has a priority, either high or low.  The default
> >        priority is low.  Within the low-priority areas, newer areas are
> >        even lower priority than older areas.
>
> I didn't see this in man 8 page of swapon, while see it in man 2 page.
> Means people may feel that change when they call the call swapon()
> syscall, but people may not cares about in script or something like that?
>
> > "
> > So my question is whether users still assume that newly added swap area=
s
> > get a lower priority than the older ones?
> >
> > I assume the priority decrement isn=E2=80=99t a stable ABI, so this cha=
nge won=E2=80=99t
> > break userspace?
>
> Hmm, I would say that this will change the assumption, BUT I don't start
> it. That assumption has been broken since the numa based swap device
> choosing at below commit:
>
> commit a2468cc9bfdf ("swap: choose swap device according to numa node").
>
> Before commit a2468cc9bfdf, swapon behaviour is taken strictly as the
> man page states. The earlier the swap device is added, the higher its
> default priority is. And the highest priority device is used up, then
> the 2nd highest priority swap device, and so on in sequence. Below
> swapon output demonstrate.
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
> [root@hp-dl385g10-03 ~]# swapon
> NAME       TYPE      SIZE   USED PRIO
> /dev/zram0 partition  16G    16G   -1
> /dev/zram1 partition  16G 966.2M   -2
> /dev/zram2 partition  16G     0B   -3
> /dev/zram3 partition  16G     0B   -4
>
> However, after commit a2468cc9bfdf applied, above behaviour had been
> changed. I can give an extreme example, imagine on a system with one
> NUMA Node, node_id is 0. Then I swapon several swap devices w/o node_id
> value (namely node_id is -1), at last I swapon one device with node_id
> 0. You can see the last one will have the highest priority to be chosen,
> then other swap devices.

I assume this adds logic to prefer swapping to the closer swapfile first,
while still maintaining the old behavior for non-NUMA cases.

>
> So I would argue that if people realy care about the default priority,
> it has been broken since 2017 when commit a2468cc9bfdf was introduce,
> and complaint would be heard since long before. While we didn't hear
> complaint, means the default priority doesn't really matter?
> >
> > Or if someone sets up Linux assuming that a newer swap file will only b=
e
> > used after the older one is full, then this change would break those ca=
ses?
>
> Hmm, it could happen, but I doubt people really count on that. I would us=
e
> 'swapon -p xx' to specify explicit priority to make sure it. In the case =
you
> said, swapped out pages will be swapped in, it's either not guaranteed.

Personally, I also dislike the behavior where a newer swap file
automatically gets a lower priority than an older one. However, since
we have a rule to never break userspace, is this considered such a
case? Or at least, do we need to update the man page as well?

BTW, we can achieve all the benefits of the round-robin =E2=80=9C18%
efficiency boost=E2=80=9D once users set an explicit priority in userspace =
for
the four zRAMs you=E2=80=99re using?

Thanks
Barry

