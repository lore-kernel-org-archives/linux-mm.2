Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B0D1C5DF9D
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 15:32:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 799406B00AA; Mon, 24 Aug 2026 11:32:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 770386B00AB; Mon, 24 Aug 2026 11:32:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 660656B00AC; Mon, 24 Aug 2026 11:32:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3F1BC6B00AA
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 11:32:46 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C82944019F
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 15:32:45 +0000 (UTC)
X-FDA: 85136555490.27.5405E43
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf30.hostedemail.com (Postfix) with ESMTP id DBCBF80002
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 15:32:43 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=haBjpTDO;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of lrizzo@google.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=lrizzo@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787585563;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pMin6QXf6mzaFI9tqvtNXTL3PhczVNb4o6Q4NA2CycA=;
	b=O6S07zhXXfAJHyk2j7ktjfePPpXm+iB3OA6YPFvBwQdcdnsOdaaDWx/DjvOu1X0hYbxes2
	ItpZvswP2ze4pBSa1ec45nL0cKwB1O/oO42auU/ndcbP9/qlBIZhMMmIJakZ+9K+4CmuVF
	U1RLDrM8NeM8m6YUZHZVhCeLeR1kBrU=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=haBjpTDO;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of lrizzo@google.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=lrizzo@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787585563;
	b=E6VTNH/OTatxVR9bqHUN7mD3Yw7VX7GQamm9qwXS0yfWbzceNZoPsMUrZoic+Q++Vv6+3N
	ARtGivACX0hllm8c4L4ou8V412ZyyMK2zMf+jzWnPQ4v8s0By7SaHj4nOxelIHAnCNVZQQ
	GYppZYo8i+xNnQr5sFrPCHd3yIrA1a0=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2ccdf36f63dso178115ad.0
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 08:32:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787585563; cv=none;
        d=google.com; s=arc-20260327;
        b=DrCh8VKxPuHPTj730mqG27kCqt30ecz8Es5Q1PbN8HOnGcGmijJBWxhshOuJi6COmC
         vhP0DEySF0TZVdff40vUZfMPyfcGR9yoPBXhT/S9pYCFqMo0UtwiXZeeIwJetnVSThic
         /j5Oll/g/oOrcilAvhyRblBof8LPJBaU9ehiiwiJRg0K9SPKoE/bouNcTHA+gjSihnAf
         pchP1zxa28XKuBg5mT//DBP/cso3T8GQ1gVobcyFyInIge+JoUPz3udi2RrggeQJOZcO
         7BCXu/V4hzJvIr+sUrAzLxPdJDWDKA45fIkCX1yw/sj0Gs4fAhp7OSy8pUBsQ6CNMoJI
         2q/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=pMin6QXf6mzaFI9tqvtNXTL3PhczVNb4o6Q4NA2CycA=;
        fh=8jDo+2Nt4RewzYAN/hio41yaMPNhyAqP9piA4dPmnOU=;
        b=sKY9CsqWrjzJM+CbEmYkHnYzUaXI3NRf5+q52l1T0rADZzafmMAuV+6hRlSy7MMIpG
         x1JPYK8az3AcN6xdBlYRVpYbxTX2627fkZyDtkAQjpZD1IXjHLZD0YniKsnHcz6G+I4t
         FHH1Xn/fciFeCFDcobWiUW8OgRzIFvNRMwUF0o3J3azCB8iwJJF5YtKplI0KhdovNz/E
         kpWsk3WiUMHvT2QgkLNEkDboW8D2fT+sIp6mrA+vB5xkDHb2sfljopH15/eFe/tQpa3a
         6k6WPWt68b8QRiOBqlpRhIvRN+TJt/LV9e3vbPHSWty5pXQ9qS+B7iXGuCECjMn6Pv6m
         fV0A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787585563; x=1788190363; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=pMin6QXf6mzaFI9tqvtNXTL3PhczVNb4o6Q4NA2CycA=;
        b=haBjpTDOJA6oMURUkfjXbeBgEu4H2XlBnozc5RbOb0TDovABxTHqMTpY1ioxJeZEQ6
         Z3ZUrVSIrK3izOwOXIFh/I2gPAiyFwSItCXtaMGplNQb2giF2oR1YM7V9YNJ6WAscjON
         z9Y2Xg7c13oixRuV2iRJ6p0lGAoicFapO9ZA2fqUMoQ8hbpcfQyh2VRsiqC03eLrufB0
         Xl/Z1g0OLArch0AgM6gBIdPscdmHAl1gMQGgDGhl+xl8kIBY7LVS8LcNBjwczieQ4+r5
         y0QbbWljew+SB0QevnT/g3d2uyKahV0yu3CWoUOhzmvUpoWDB4fzIpxTDsnek9lsyn3z
         cz/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787585563; x=1788190363;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pMin6QXf6mzaFI9tqvtNXTL3PhczVNb4o6Q4NA2CycA=;
        b=AECAhUjYN9YTKON4f2IoFeCT1EXNDb5nejdy6NmN8Pcr6ZP6h3pU+9wQB57n9t4W0w
         NXdfv48phYaKzd9xX6E9jVB8q52jCznEQc7RqDMVLzcuYQo2yITZPUdsS5FDhRGJytvO
         pxZlHRw8iFbyg8kMYaZHwIkDnB0LPBboDexvyfETIdAw7mXV4UqU9LwYEmb9VG6wAF2A
         j4TSRx/1826m5yIl8gtKsM64hMyq1jpKyJiB2yjtbMJ7XkZlLEEZAsa8F0GkjeerZ52X
         pzNmWg4028pDELosTUWNgShQatyNGnI767nJvJlgtxE9Cn4lDo+uYQKg1Zr9Oyd/2RwH
         Ix/g==
X-Forwarded-Encrypted: i=1; AHgh+RrpR9dksLepWn9+S1dHnsNWdGQaGATHpu8w3I9ethYgcEtsmuGrNxAcTNqkLS1XB+o2Kdihm/cE3A==@kvack.org
X-Gm-Message-State: AFuF++k3mxSIizVfbcxlqpM28fVD6K9Wca2EwV+N4olPqhnZKFf59AAC
	tM7xLRoKvd9sAceEzEodVY0TcxqlYQe1JaNn2N9jZX2oCrO0VWEss+/qm1Uwbo6rtzTVqF6Qnti
	G+j6ITsQyJuE+JkBYIlFAvU8jBAty0HFnoZC5sX1y
X-Gm-Gg: AR+sD113QwDz+Lsl0GjQb3CoGmeMLzCaPTtNsAbe+DPmDs0F/KrTZEAPGKs+/XEoRof
	Wqa9ipQMLk1Yl+twfCfqIUP6GlPqTj8ydwt9nB732EaYF4yB+E+be1OQrK7ulKuDi1cPnhnSHAg
	kCqTas4axvQF26GBaIMH/IxEjMg6wfdSea6mFB6Mxyoem7jDY9uf5y2Ryxvxl+xxDkTcQs9Ce4t
	Z/4aPf1jX4GpgOY/fro5WrHNpvU3ozL7SD5oUnIsVvTktFfkMEbcJEvQ89fMQu03z/q8HRtXveM
	5648Ld94oVG0UuDwkwFt3c+Cx3OaSjbrFWmWwwSTEgCEN9eyseiUlqqJ4hLGCg==
X-Received: by 2002:a17:902:d592:b0:2ca:bf8e:360b with SMTP id
 d9443c01a7336-2d673b9e9f2mr10182565ad.9.1787585561896; Mon, 24 Aug 2026
 08:32:41 -0700 (PDT)
MIME-Version: 1.0
References: <20260615234220.3946885-1-lrizzo@google.com> <20260615172535.080cf94f@kernel.org>
 <CAMOZA0KAHKsvA9yRcdrjG13S+=rJhw-Cvnw2WdLjGGY0azG0kw@mail.gmail.com>
 <ajEuUZMgS_NRmDcp@google.com> <ac473a83-c77f-4a41-bc86-8a857d2d6e36@nvidia.com>
In-Reply-To: <ac473a83-c77f-4a41-bc86-8a857d2d6e36@nvidia.com>
From: Luigi Rizzo <lrizzo@google.com>
Date: Mon, 24 Aug 2026 17:32:05 +0200
X-Gm-Features: AcwNN1VGtdaRS1g0BYe1RjEgd2mMtkM251D-YEt_DU0VPfQjcinAUbJbvNKEsc0
Message-ID: <CAMOZA0LJ9qTs+d5Mg9CB1Pio-Kw1HDmuVSMiz=zUZdWFC7zqdg@mail.gmail.com>
Subject: Re: [PATCH] swiotlb: avoid double copy with swiotlb on tx socket
To: Dragos Tatulea <dtatulea@nvidia.com>
Cc: Mostafa Saleh <smostafa@google.com>, Jakub Kicinski <kuba@kernel.org>, rizzo.unipi@gmail.com, 
	m.szyprowski@samsung.com, robin.murphy@arm.com, willemb@google.com, 
	kuniyu@google.com, davem@davemloft.net, edumazet@google.com, 
	pabeni@redhat.com, gregkh@linuxfoundation.org, rafael@kernel.org, 
	akpm@linux-foundation.org, david@kernel.org, netdev@vger.kernel.org, 
	linux-mm@kvack.org, iommu@lists.linux.dev, driver-core@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: h7uo5cqgufuf73i5yjzwbbnic89t7nmi
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: DBCBF80002
X-HE-Tag: 1787585563-773450
X-HE-Meta: U2FsdGVkX1/3qBROPS8+yQV40/NqAjYJhd4mjUT1Q6W+d5uv0a+tfKiGkjPa+v9qw1yaE2peLfsdxdtL2vWkoEWtSdMzNK/cHB7QcbC07Dm/l7EiZtmSr3z8m7tNgaSEGdnIlm5ZtZcGUCLWTfsFb5JmbCQrNCF2RHJQigwb0qf2HTJYGBKootqT3fgk9HGFxS0cXjleomXapbYaFOolJ4ICq4TBMyOPm6VGWtpWoiGKmwk+dPpuEzr6QdkD/HUjBrf1fcj+Uno5UNZwokDBTCDbLujt6yYXO+eKHwT66Wfltnn3ggAGZgk0znCYji7vfH4ZYoXlpWa+BVqy03tX9QTmJDOzX11VEgmtlnuWIhVtRzxKQanMOBhMGekSOOfI7h+iw5JB5DAayIG7qHqPPMUmIFuB/jMXK/l/24WpvqhIkeLINIW+oQIywTJC11yY81EokkPZzUaJScaNDO85eZMB9KBk4zrK+kDeFblxKJbOKBhGmFg1FODx6n9YXioz5L+9mF0fmaZ1ii7rraVx66uX60AgU3j4O8AS4DiJ8xE5/FhmrrN+N3YbFKrSwqRAz++rg82a+dO64oBBZ8GPUI6pQSrmaCmbW+9HMghPF5uof5Q6yFR/L7lYsIDAXsJ8sy6Y5owdkf0wSMSfQSA01afvQ3JO0ywrQ6R7QgAapNMxEfyktFicInnVYTRIAuoUwq4TqjFW9mO7WGFxvROFlB//bIK+93JpfcZ8DoeiUT3/IlauwFEhoajWD3FZXIqe0iPmuh1CQDbMnN2SO93+g2VnmZYL3b3P4Ox21U9cQuGpMxopYw93kKMH+iyg336/1ig4m42ftjvxjJAdN0JpwxQFFpWeMIt/GExqS4wybEmVmFiAtn6MyLB4A0Gi5TmSWj3oviAp7N44NCkS3L+y8VHD8kQHtlHG7FFw/JrdvbhzcX37pdnZzxkzzVjQWkHU9/YiIQKQOw2sIu2Ey1t
 o7TVGucY
 tM1BSzH48B6lMreozdjBLGphShu/3jysbcHDIjRV0TzyOGRWBypffDYinpMUxdfwrCxls9xrThxRnWGOrQhjZFu/W2fIinxcdo8hiDtT8b9BryMzIPRjqRlrRo3Aknaz0mg2QlHAzaEujLcSMw6+QvS5fH7rxvu3Q1elzYR/8bnHB1MSrZc8+hbunDVMQrq0OZo54Qhcbqi+Ju2ohmZ8g/DSac/D6+Y+N8pisLtzBcUrfb7L2HPg8MYP28HiMO1N/dVl52btqXpGeqG8W2rcsceFjqfU9eBiGHNcoU0NMeTXSkeHIu30CUfIBkq9plPCFD/TcF1NHtdxkgeNBwyllDnK1TU7Q6uA95UbPA3N5qZI3OXskiJFszjM6PH24AbBmt3knu5Rck0wZS/pE2JOZ7MQ8SQ9slCORh0xRftevmLM35uij9sEUniP8A/a9ooKxmOss
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 24, 2026 at 10:59=E2=80=AFAM Dragos Tatulea <dtatulea@nvidia.co=
m> wrote:
>
...
> An example of this is Jiri's system_cc_shared heap which is a dma-buf
> heap with decrypted memory for userspace.
>
> > I am still looking into this, I was planning to bring this up in the
> > upcoming LPC.
> > I will give this patch a try. However, I believe that we need a more
> > generalised concept for CoCo pre-decrypted allocators in the kernel.
> >
> There is a talk at LPC in the networking track about this [2]. This is
> exactly the type of discussion that I was hoping to have there.
>
> Besides the issues mentioned in this thread we've also found that a lot
> of overhead can come only from swiotlb allocations when running many queu=
es.
>
> I will add information about this series in my talk. Hopefully I will als=
o
> have time to add some numbers for comparison.
>
> Sorry for the late reply but I spotted this thread only now by
> accident.
>
> [1] https://lore.kernel.org/all/20260325192352.437608-3-jiri@resnulli.us/
> [2] https://lpc.events/event/20/contributions/2464

Thank you for the feedback and links.

Do you have some code describing [2] ?

I just sent a cleaned-up v2 of my previous series, if you want to try
it please use the latter.

cheers
luigi

