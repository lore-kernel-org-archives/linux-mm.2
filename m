Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1956CC6B0E
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 16:42:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A56836B008A; Tue, 13 Oct 2026 12:42:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A06D46B0092; Tue, 13 Oct 2026 12:42:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F92F6B0095; Tue, 13 Oct 2026 12:42:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 61FDF6B008A
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 12:42:55 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3766D80D20
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 16:42:53 +0000 (UTC)
X-FDA: 85318172226.23.617D2E3
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf15.hostedemail.com (Postfix) with ESMTP id 4FE0CA0002
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 16:42:51 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UjCrgvcP;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf15.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791909771;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YEWBZSCDOHNDO3i+3Dhofyy1g9bLH5Fceh3LVymGhIE=;
	b=h7AT5N+jaDJ/yF6DzcLaQkh6YXBv4MxBEIMw6T8h8gv7RBmWvpvpSJAXShp/njNKZLReF8
	TagZSTvYzQ6GJWTNC/iAA8e/RMtByBNaRlx92ICufoi5oPQ9WmNqQ/iAOW9J2W7qpXfEoB
	5oFcZJ6hzuAB3nb8ijGAfW3fc7evEqE=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UjCrgvcP;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf15.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791909771;
	b=GaHZHZ2M1B4ugG2OcLWsAa+GJeYi1mJlcCID4UoOUA3Eqhoe7moW67bDuKVeWiqw4uyMPL
	8aKNbVdLEVSbgwNDIGSai/rqaAKm8H2Fh3/MpB7C7s2chTmxEhnV7UZ0f+40JitICC5h6B
	b0BqOu/RmDRQxXMOb/Evx9ZXgqo6hC4=
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-48b0584ad71so1849280f8f.0
        for <linux-mm@kvack.org>; Tue, 13 Oct 2026 09:42:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791909770; cv=none;
        d=google.com; s=arc-20260327;
        b=cdKrGlgPbcioNQk+iPH+WkrfTcqXdpcSvi11R9z2WwoJpf8FchB7ADwTFhhVwLx4he
         khHlkItqNqdQncXUysVHYo4ap7mVdMpB246qADljv73dmmEd685pHj0Ix9aR6TOUsq4a
         YXvYUmnYxV1Enf6BzFAQct37Ap20hTZzv+ZSpufySCHNfrdtDoUB7P37xVAcvOlHNh20
         EYDFIkQxbsLcxfWVGieu52S1G3gswTf3cY9Habcmj7HPHrGuY0JGSRxu61dR+EeDCSrz
         AplUNqvevN3lF475833+B/P0bhvVtIvCore94btUS1E12HOKhNSoMPxVr7cn62Ny/lqn
         AvfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=YEWBZSCDOHNDO3i+3Dhofyy1g9bLH5Fceh3LVymGhIE=;
        fh=fTzhU+FWr0tKoIUp4EMNy9SHX9LKLpDiT6IUiDBnF3c=;
        b=ZBYsWISnacd7iOR0ePZbkP7SnAWRXP2T4X1+ZtjDRL2brIvYiJcwNMmYsw0+mrYC6G
         zUc6ukjBfsIsheulPOBZtST+70yQloQTEfV1hyt3l0BdmfTz9HuhOv97iUKpoo+8gOn9
         7vGHY0I033ApIOuIIGw0uHtfNaWu7klv4hzUBO7hQOHLiamQu/Va5QPogcHWFU6sXxJT
         TaWU6F4SbXtoUeZ/Lc8hwDUurfKrytfzrWzOvyL8vgTfOABl46y30tajAqK9FmPy5Gul
         Uwd7hTgclLBk0bjQQW0KsVMxjeUNDcswKi6QVSKuUesnIZavJ8mSR68AA8mRAWRIMXBO
         eqQw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791909770; x=1792514570; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=YEWBZSCDOHNDO3i+3Dhofyy1g9bLH5Fceh3LVymGhIE=;
        b=UjCrgvcPTwm6cSTeXT2QWAWKDQm0j9LvprkDx28lHT21ixSsLQ5M+0so+UQXLYsvKT
         i2tWV4bu/JkqPN6SK0BQn/+pwl5gsEbzZv0OWG17HT7cnHGYJ2gBsHfSH8UhHI24lj20
         8EYooLVAhHNoKniYkzSQMoRf6rt4d3LnRI1llTjZY571uHGNyv0F89Fmnmd0bj2rUqeK
         ZLDtWgyxpYyFrDkUsyi8Xcu9K//SgDJgGV8c6jdIJFBYZkxn3URZkMIaCdi+nyVS6jbJ
         HabsINMQPAvjexuCw+YiWEAeB200qWUghOpNNWWfH4FmgXrkCNhUli2UKL72DyeCM+uT
         o1fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791909770; x=1792514570;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YEWBZSCDOHNDO3i+3Dhofyy1g9bLH5Fceh3LVymGhIE=;
        b=iA7Wvfl/6/g8UJbKu78syyL+JOXI5JOcfiVDmqLRL/bUWG4THRGoWfm1nc9kdX2RuP
         gIMbvJg6bIM0qE5pg8bQjhb6bwAVNICrrbyepAimV8CDZU/u1L7LcVnD//+/bRL/Uvbs
         Xrt/TxK3VORUP2Z1ylOvUthvAI4tndtWopOLh6K291pCj0XoqIR00mQlQk2TEfT0ZQO2
         QvsMbjrK0hbJL8Q1il1tALg8uHkhkoEptxuN+r6tRjk5MjXVfNds02uQYMYQRFMxOJOF
         wNHs1lX34Ed8HGGYNk46prbz9xHKWDB/MAHTRfFLI9Q93CufA3Tfa33EjhxCovzYOwyA
         xYlQ==
X-Forwarded-Encrypted: i=1; AKwUvBz4LAtw2or0tcLyCa2uy3X2qrMAEFYKoju7sHfjs6IYhe2lvvl5mWjbckVjcZHUlYP4YPIp3thBRg==@kvack.org
X-Gm-Message-State: AFq9FYLOzkcGhqzQ1AT9PMeEKbYtsFr65iP4F8JX0GCtIAxzRD7l0D20
	BpL/9yzmKI3YPY+5nW3f9o3Z1uXs6YuL/vq0iweFLr93SSgpDen3oNw36ckTXpqFHHdTJsev1SI
	BEKj/72798aeNFzuuFes8ZJsS3992WCM=
X-Gm-Gg: AYBFou3u5TI6SaDwZKkYBM/0smfDC9u4GuF/akGSiH+gAL/GZDEsDayUfAikumg75eO
	8Jxv7u56mNu9DsDnLliKKDtoYMTauMbahWEXq1Ez1CetnNSgfRilb0H2ztKsWqMgGNCCoFNIEGF
	751sz6v95Iv0J6j5MPI5hycE39yTEtighHr0TZie+6iaqbOYoJLXyRExatfp6b5rKpM7ux121Y0
	kfumUa9TwgP7GzYRtgVX030jwi2Gk01ifzijG0gNcjGnh3JSMhSmeHv7MBf2Vp8/f7nx7qaVnHK
	XG5NB1S7TOgtnfqyXNElPgjreJVWP070vkIz25fcF9G25gvEVMVuoGEa78ELlvsIlUi0vX/YFs5
	iM+tQo7DzTiKy/aWXzcqN7gYZzOB3z/Ewza4SDlHe/quHpYIkC3AG/WGmeCAkHRLPyKLBTv8=
X-Received: by 2002:a05:6000:2212:b0:48c:5cf9:88d6 with SMTP id
 ffacd0b85a97d-48dba7bea17mr24931533f8f.2.1791909769542; Tue, 13 Oct 2026
 09:42:49 -0700 (PDT)
MIME-Version: 1.0
References: <20261003003136.750633-1-hebaoquan@kylinos.cn> <asZt7-8mcxqc1a02@soda.int.kasm.eu>
 <asylV5YyyaHs8rP3@fedora> <565e1744-54ff-4daf-ac14-7b6c49fd3fa2@kernel.org>
 <as33VMjNRIZOG5Ua@MiWiFi-R3L-srv> <d6209813-d53e-428c-90a9-6404618d0804@kernel.org>
In-Reply-To: <d6209813-d53e-428c-90a9-6404618d0804@kernel.org>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 13 Oct 2026 09:42:38 -0700
X-Gm-Features: AclHuK-ryAPyn7SnvcpWGj3a4GSukncAVwfSrD3pFoQuFgdkLOUuj2IqX2pNiK8
Message-ID: <CAKEwX=M6iVBGDs21obLu3Ese_wHuQnspsSdo+HddhCeecn-L8A@mail.gmail.com>
Subject: Re: [PATCH v4 00/14] mm, swap: extendable swap devices (xswap phase I)
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Baoquan He <baoquan.he@linux.dev>, Klara Modin <klarasmodin@gmail.com>, 
	Baoquan He <hebaoquan@kylinos.cn>, linux-mm@kvack.org, akpm@linux-foundation.org, 
	chrisl@kernel.org, kasong@tencent.com, hannes@cmpxchg.org, baohua@kernel.org, 
	youngjun.park@lge.com, yosry@kernel.org, shikemeng@huaweicloud.com, 
	chengming.zhou@linux.dev, linux-kernel@vger.kernel.org, kunwu.chan@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4FE0CA0002
X-Rspam-User: 
X-Stat-Signature: aop3ejbzs7c561wy61y4bjgzb9abkug7
X-HE-Tag: 1791909771-294621
X-HE-Meta: U2FsdGVkX1/z1v4Q8rIJQ7oU/uNw6Z9aP1pBe5PoOduAgx8taS1WhbOty6LuET974DKoYA9jhFTd4AVR7H4rtNwAD9RmsQTkv3ddGZ7D1Xws2pCA1Y9CSIUdN/MOrPDLmXxsUTnSKAP+CLCCLTrMrNOzbs7f7XmEwCSQEhDur02ZkLiXeLyltBRsficWF8WBIcIlO1811N1Ao7C7YT68ZWPT+2EXQAlbBmAU+eQEKaoV3BUZ5R7i0LM9ip00WQawRmKyP0NrZRfucHjtFhd9bvOTNw/YAxwvIFnbjY5JcRpEX5JjlyaJonB5D9muMjqKk0aQEjmlbPxcqOqFjmSX7koSG9mZiXtR4kjiFIqvNVNHTaWlLiJfrkSbF6tPOWWz/TMNpEMQJK6FPfYrf9VVz0K0ZEtV0NkvIhnKxYc88yoFulboN4NJE8ObMDLc730Ww2jA9VkTGyNN7G/IgdipMZSXvvQI1x1mmnF3TvlTDrZjX/5YBA0ZlpFKrZdUQwH3F5cwfQ84C+qXHBTZWPOqZQ/7KqwC82QYMJJHR6g4GtFTRa+c1y4VrdnlDCqBgnzJ0MsAAF8sgPfsWhNcvNXhL4h2juBIg0fkZ4DUSpkXFiH/Pokc5tbayOyCOvZxMsDbK3bIf/rql2lY7IitsE6gMYytUW11uS7M7QwbdgXQTWb8SFF2+9Yel1CTwkRuooNWV85l7dw6k0I5H0dc3Z0Ya+RX4j4/yUA49xcm0iRWN7DnHAOkh+yeRuabWkaxM2LNMJy25Yv1Em6tVHqJDdHq0Qp5OYakZXHTeY+3WVrt15Od4AIhFPe464OjsOf9kOOk7i38QxPP7N/UpXtTxpdNsjr+oTBqZoJTAtMQHrI0xhtWihVJBoZTBa0isxTT/7zNSqEAjvfoitcQZPCAQm4+qsWWBReecpTfxOhuYLq81d/kU9dVZe8ed7YwuhClA/OD6BZgwP8XcGGr8vWJXa1
 sdYSxByF
 jv2IzYljj3qvj5M8sETk/WmP2aB4eC/PBDguEs/YxT9HbIknKyzQQnfu/4v4g6P6POZrBWwBxyBgxwsg70kzfOb8+XmLcXUqVZfV81x3uEMl/XCjW2UXnwX0HRayyhZrwJzlgq33ozUwpRBQ/O9iGJrHCfNMcnCziMw8wnz1s+J0ZjCw0ulCJWzv/iJCKYg42wf2XKSLFRgcsWsC60xVFjWJ1iusH5KwApHhUXVULWnfznd+6ffDcrEiRLc4dG4YeQk+vf28DCVm60ZU8ftFSlHsWF99ZsQzY1sW8ezrQU1FfR76MT7Og4tNLTI+/WpBH5vLHqTZRtkYZMtKPb8LHiYEQHZ6eMZcRkYnWLovc2//FlVFbsYyR+YPXhu3UHnWFgRz/zxZnNsxBs8E4OMuv0vrbmT73/3yk83xqyWkPoZXg764Jf95X0WYtX84idY7eS0qW0G1v9xrIikqRJUen3KifSzv6hUtvtPl4T+3qzmIKOuQi521f6IxrYA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 13, 2026 at 8:08=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 10/13/26 11:18, Baoquan He wrote:
> > On 10/12/26 at 03:44pm, David Hildenbrand (Arm) wrote:
> >> On 10/12/26 11:16, Baoquan He wrote:
> >>> Hi Klara,
> >>>
> >>> ...snip...
> >>>
> >>> Thanks a lot for careful reviewing, and sorry for late reply.
> >>>
> >>> ...snip...
> >>>
> >>> Thanks for the comment.
> >>>
> >>> Here xswap.max=3D is a global boot parameter, while not a per-device =
or
> >>> runtie knob. It sets the space space (si->max) of the xswap device
> >>> at boot and can't change at runtime. So on the two places: the size i=
s
> >>> a global setting, fixed at boot; the priority is per device, it is in
> >>> the create interface. They are different things.
> >>>
> >>> The default is 2xRAM. From our earlier discussion, this is the larges=
t
> >>> size we think is sensible, and in practice I don't think it is not
> >>> reachable in reality. If a system has swapped out 70% of its memory, =
and
> >>> even more at 100%, it is already doubtful that it can still function
> >>> normally. So 2xRAM is an upper bound, not a target.
> >>
> >> I remember some overcommitted hypervisor setups where people swapped o=
ut
> >> significantly more -- without any issues.
> >>
> >> For example, Windows VMs initialize all VM memory when booting up. Aft=
erwards,
> >> you might just have plenty of memory that was touched once but will no=
t really
> >> be used in any near future.
> >>
> >> So I would consider some crazy hypervisor scenarios as well where peop=
le
> >> commonly have significant cold memory that is currently not hot (not i=
n the
> >> working set) but might possibly used in some distant future.
> >
> > Hi David,
> >
> > Thanks a lot for the valuable input. This is probably the first first-h=
and
> > information I have heard about a production environment. And Klara
> > measured about 160% of RAM in zswap on her RISC-V box, so the 2xRAM def=
ault
> > is reachable in practice, not just in theory.
> >
> > So I see 2xRAM as a default, not as a cap. xswap.max=3D already overrid=
es it.
> > After your comment and Klara's numbers, I am open to a larger default, =
or to
> > a "max" value for the address space. The real limit is still the backin=
g:
> > the zswap pool plus the block devices. The address space should no long=
er
> > be the limiting factor.
> >
> > By the way, in Windows-VM case you mentioned, is there a block swap bac=
kend,
> > or is it zswap alone? If it is zswap alone, the knob that matters is
> > zswap.max_pool_percent, because it sets how much cold memory the pool c=
an
> > hold.
>
> Excellent question: I don't remember all the details. There were talks ab=
out
> over-committing up to 400%, and people played with both zswap and zram to
> avoid/reduce IO.
>
> I assume as a safety net people would always look for an additional swap =
backend
> (that's what I remember, but I don't recall all the details).

I think the better question is why do we have this knob in the first
place. If there is no justification for it, we should not add it.

We should start with the actual usecase, then figure out the
interfaces that best support it, rather than just expose the whole
gamut and burden users with potential misconfigurations. New knobs are
easy to add, but once a knob is added it'd be much more annoying to
prevent user from misspecifying or to deprecate it.

