Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8F26FD45F1
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 23:43:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43EA26B0088; Wed, 25 Feb 2026 18:43:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C2316B0089; Wed, 25 Feb 2026 18:43:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29A166B008A; Wed, 25 Feb 2026 18:43:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 13C726B0088
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 18:43:59 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AD42414074B
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 23:43:58 +0000 (UTC)
X-FDA: 84484609356.14.0545778
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	by imf14.hostedemail.com (Postfix) with ESMTP id B37C6100004
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 23:43:56 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Tb3W5fKV;
	spf=pass (imf14.hostedemail.com: domain of airlied@gmail.com designates 209.85.219.43 as permitted sender) smtp.mailfrom=airlied@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772063036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uKa/vajBWOBwhcb6ZTw/N1BLKynDSWMpaPUdswW6428=;
	b=B5nYT+IM2cjCtZJt6yIAUYseFyz2Ck1smhCglh21oWTtHKy8kJoLwf+Xxkx5OMaCM80a3q
	p19+dXloDa8xCXsUWuKA0pNFOWlEH9QFqV/Ckqe1qrsFbf96VOi2WqVRQooUHz2nT9j73v
	Z8Wnwx1/RcaIILu2q2FtRX+GZplYtSs=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Tb3W5fKV;
	spf=pass (imf14.hostedemail.com: domain of airlied@gmail.com designates 209.85.219.43 as permitted sender) smtp.mailfrom=airlied@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772063036; a=rsa-sha256;
	cv=pass;
	b=MTB4lAzQqUd4m/ntqZMVXjw30O50DDVCE12PyDn/POitpbsW4JnP/+r3df0q+piyPQ4Rka
	HCzNXieMyuzCyYStmgAlzF8xgub+RfMyv6ObRCEr6L7WAQL/vNmpprc2DH2mIbyFByaKv9
	zgX3tIZGk2O2zGie8WaFJxBlpu3dyh0=
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-896fd2c5337so3352656d6.2
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 15:43:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772063036; cv=none;
        d=google.com; s=arc-20240605;
        b=QiSSQdV/W9Gulk+5CRrVfnbS91Ku8ZFHfcTeF7b5LBnD9H71tXAwk/UrhUxOwEitV0
         6uF8BXzXNyk+5si8M2toNgaSi5ANZGooZJ1pCbKGRickSthx16AwB2dWPbwI9bp8hi8I
         6gtwt4youKNHrVQACicK7FCthtlOYNPebQGBdNG28eR1ZGqFjJv5w4oyWIPjoivpAdEq
         +yK1Ode07o7aEce9PXZ2hCwavi5lrZ0E9h6sRQymTdBGkjtPY4M6YBuplzvz4bplJyS2
         6Yc2uR1HjHEYHB7KP5xZI+EacHHyuh+aYWsg9adPqz+1+FJhrfBYXR3D4+tgTONz6Ziv
         tXAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=uKa/vajBWOBwhcb6ZTw/N1BLKynDSWMpaPUdswW6428=;
        fh=xczxFWd1iqMv+2UL+irHTPmm4r2l92YeAwcjeI8Bi6s=;
        b=Rv3SvYno525dgQvGqZl0dLXeIDVnjv8eFKKf3Qj/rkyuU+ecineov37ZeiSXS0Rt4b
         6lfeV+tpZwnKJCUpb0s4EsRqNEb2JHpYBszpd16mL+PN983XZftJKCendDGkYhvRFmgm
         43imKpEeMMULVWwwz8OXveVzlww7GtJAjjEAXD7WGMki2+0/gtHnny2WvjKB2V6lm5Yx
         LT9GMO9Oekv+wPy0+gZq2vD0E0iMUpGhmSODC0Xspz+TE5mrDrfcCsT+Tdr4C6oXleYK
         3fPAa9QzLmYeDupaZDHI5zpNhm7IrwefdnYwzb9p+mO4fXv6HKaMVVnK7EkiQz+/Dca6
         vJNA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772063036; x=1772667836; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uKa/vajBWOBwhcb6ZTw/N1BLKynDSWMpaPUdswW6428=;
        b=Tb3W5fKVWfU2oHSCjBSUPurcCZvgt1huwd8nPvAVeh9o4ufcmnevlYIEXMLX/7kR2B
         Aw9a0mQPe+ouobfsjkG800mD7Tr47OftuTqNjeTl9NKjkBnQ2W3zFROC4zfhWN8UprBk
         Yikg3WcYfdkkCe4CD3noNy9MsccUQ03rSIuHNgx1UOPaRmV68eu3s7NSRNeJtHcVy0sT
         INK15XX672U0ZhnynPnHCmiCc0PbKi1fc2aAPbKuDBn1j5aPZRNcMKmjbLych2wBdliT
         Tqisoww4slRsjjdZXCtqELBOdQlIk5h6wmXnkcp/WW2cAnMUBXhuekBGSfv6AzUrw+tm
         NQyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772063036; x=1772667836;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uKa/vajBWOBwhcb6ZTw/N1BLKynDSWMpaPUdswW6428=;
        b=PQ9AhJYAvl15eJ17ewCK63TpnCS+5T6rd2RAcUJFCmhMGAxZECTqUCvwpVBbWhV8Bx
         cuyJ0m5K6odv9+5juvKB0q/q1ixkWITTOwa0R5+kqYYI8vFRsQvcMro7x/GSXaWvQUwY
         jsoxbGrPicNqEirCM+MUXovVWwgwCTTxKpA+6oTaNqXAFZReDj0vesOMonLsEHEyh+Ro
         W73imd+9q2BWeCPvurnEZMeXvXS09Z+awucxLylrwnd27/uAEWZIohk4UI8Ffve1kRJb
         Oio6bGdz2z1snx53o8CEQqOrvqlYJ7xPLdC00MpYWFNdCyhn3I9t2H7a8n0crlqM/e0e
         3wMg==
X-Forwarded-Encrypted: i=1; AJvYcCXl1stGpqfYZpEedJndQ0gqNytZRBITyH9bQfBLU0M4TqD4uTvPMT6Nz3zhI6ecwi9Vy5o+lcYwJg==@kvack.org
X-Gm-Message-State: AOJu0YwPOUtnueLnttyvodMWZt7i4Ka83FKCRaWEhL85gZuz+rQOOuy0
	wk1fTZhZ29fjwYGsdqRiHdgWoOZ81mvesA+B3S4G3qyLzSLtpJ9IFF7vR32lKdumgEYdrIBWKVK
	QJyywLmtU1odYyNIz5AdxjD93LmWOHxo=
X-Gm-Gg: ATEYQzwkGe7+/w75lUTr9Mj1EaU095pf95UmoyWmK9GZjMmdeJhLVEH0ax//AbymbMd
	+XyX5gEcRETn+OSoNFuSUflovrp/yFqW18S8vZL44hRduVb9iKYWjuj4bQxSbe4Bwf1VrEnuGtJ
	+nOD8QxPQxGyXU0Gpv6joxf8w/0JxE1rETubyhBaqPxZrp0cu/WYapbO/yunVN0cBltPwU3evBg
	uh+0MoMdRfL8WbofX2hu0yDb8iy6/8LAFyNNYiGqsGwmKp3kOydpX5KW657f4rjoQehVMeRZISj
	498E01gwC8WgCJd07XQgVFvlTh6AhRVmXX7w9de4nRdQTN/vwGtYymZMy1SyEu3OrhU=
X-Received: by 2002:a05:6214:dc5:b0:899:ac2b:6ddc with SMTP id
 6a1803df08f44-899c8065c8emr3236056d6.62.1772063035679; Wed, 25 Feb 2026
 15:43:55 -0800 (PST)
MIME-Version: 1.0
References: <20260218-dmabuf-heap-cma-dmem-v2-0-b249886fb7b2@redhat.com>
 <CABdmKX0LpKJ9tw48oQh7=3CF0UR5uFtgo0OMwQhHBB40LnijyQ@mail.gmail.com>
 <a446b598-5041-450b-aaa9-3c39a09ff6a0@amd.com> <20260224-solemn-spider-of-serendipity-0d8b94@houat>
 <56400505-8a13-4cb2-864c-cb785e4b38d4@amd.com>
In-Reply-To: <56400505-8a13-4cb2-864c-cb785e4b38d4@amd.com>
From: Dave Airlie <airlied@gmail.com>
Date: Thu, 26 Feb 2026 09:43:43 +1000
X-Gm-Features: AaiRm50TeEvqc50OnpAEgaAX78C2joyWBAyYfH_ecZDl20ZLik30HZzrg2UNE4M
Message-ID: <CAPM=9ty5mbMAVHPO4mRy1jKGnpChr7gK6uMtco2=j7MMJGpZdg@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] dma-buf: heaps: cma: enable dmem cgroup accounting
To: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
Cc: Maxime Ripard <mripard@redhat.com>, "T.J. Mercier" <tjmercier@google.com>, 
	Eric Chanudet <echanude@redhat.com>, Sumit Semwal <sumit.semwal@linaro.org>, 
	Benjamin Gaignard <benjamin.gaignard@collabora.com>, Brian Starkey <Brian.Starkey@arm.com>, 
	John Stultz <jstultz@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org, 
	Albert Esteve <aesteve@redhat.com>, linux-mm@kvack.org, 
	Yosry Ahmed <yosryahmed@google.com>, Shakeel Butt <shakeel.butt@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B37C6100004
X-Stat-Signature: nnx579qkb41w76tj9ecrpqssj3f8zje9
X-Rspam-User: 
X-HE-Tag: 1772063036-762654
X-HE-Meta: U2FsdGVkX1/mp1LG/O2i4Fs1cd9yiYfVrui1osJ5dalxxTdJIdj9Ou7QKXM2B6LEtAvtB1qRuSK5MdbwRUHx3n4fM7zBdOBlkgWak8ktf8/8DU+7bQ/yus/GOi+AiptbHdVeK8iSru3wKtiM64/jllUHK7TAtGTSZAvLvCpw5stf5dj25yvc6WcwzeUfCtVrpPa2EKW5s5jXMlnlyliwz21NyaMHsVuNfOdGz/iwTM41Owb+6wxtLYJQ2ZYrvnxck49sq5kLeclQgmKTHUNpTMJy8IiEDOJCHyYKnU2JCEHypuIbC4FvP97Z9JKg7bOR+axnM37Ge6hJlLFnMEDz7hrmBL+SDAqjpQnr2tjDFvdAM55OJfTSIf1/Ca77Ask1j3s5YlVlvCe1k7Iz9sA6xS8HN903t+djIgtlXFm+Ui38Dj7c9ycekoH3OPOnVfg9xGfkDMbbEBrrdlGUjNYco5Y4NztEzhT3Jcccmzfi9DmVphkVs3AcDJqfWUjjxYeM1NQhdXNEaI7SRs2avbaJe5QZDvAvvP3lMT/L7aj9vTGhColynMRXV9q8kiT99YUE72iflLOZW1Tvl+YpNnSISmq1AK0uJy/8dEx7nBlOtDDw61YToEcjoq3ELh4gZxfstKi13AErUdLhPuFHsWPFmSGtggX5GTwPW/4VPXxtDARvEKicceBZIzj8bH7DhVEGjlwsR8tOI8IGzYFkJf1zvU0fh1KNe+6BoakVMqxpRtNYRcxyuolMOGeCS3qF1C4XbYYP6zPJhHfJS9pjXZ2iAG2mn5ZwuWcBkyHS+b9SQ3b95jHTs+mhgDtvj3coDuJ8hZyW16X1GblBwXMOA/VOB5VAaWngeY50re2MHTz1bvYMo51zSs5hF39WrsHeZFOzQ6rXFUdHAR486gfnm8TBX946AxCiCBdtID42X3yPuW3IjqCuhvqeq6h2yapILZS4uyN/wVsfKxrfJ5/0KEZ
 7hEYAyrE
 qZwx/c5dKvPbadN4GqpZXSGy++TykyDIlK4ZEc2tlaqGxdNQu6ecVBGYRoa0S78a9IZ6qAG+cEzVPVVaXpKyHGdZd3NE5i5oQ6bfJIEpDr2BxcZtMU33op//DDkrkFKhKEWThS0LF5VYWVKZfg6RZNuxUoTCjt5CqABv910xppT6UE8WSpgdV9vRIKnfID5AIlFpUS+OfojJTiUmI4HMC8S7xyMD3vto4uTUYaeQKvmNNmhntZN1DMs16IOpRsQlEUN+dvQ/3j+JilIdpRyMJ6jr8/Kb3nEDccqoLdLLncSTjDVuV3oefQlvqaGfvYoD/7gLEwl0AcGT2ouusJX8rDM2prHIV8GYphunDmvBIt+vocxWyGYf+9dRsvyLQi+FgdnMBP71RUEfIZdrLJLszejP3RAppoPgCXl6TU5xJO5insCs76ChDIIpbUJlzhR1bOer7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 24 Feb 2026 at 20:32, Christian K=C3=B6nig <christian.koenig@amd.co=
m> wrote:
>
> On 2/24/26 10:43, Maxime Ripard wrote:
> > Hi Christian,
> >
> > On Fri, Feb 20, 2026 at 10:45:08AM +0100, Christian K=C3=B6nig wrote:
> >> On 2/20/26 02:14, T.J. Mercier wrote:
> >>> On Wed, Feb 18, 2026 at 9:15=E2=80=AFAM Eric Chanudet <echanude@redha=
t.com> wrote:
> >>>
> >>> Hi Eric,
> >>>
> >>>> An earlier series[1] from Maxime introduced dmem to the cma allocato=
r in
> >>>> an attempt to use it generally for dma-buf. Restart from there and a=
pply
> >>>> the charge in the narrower context of the CMA dma-buf heap instead.
> >>>>
> >>>> In line with introducing cgroup to the system heap[2], this behavior=
 is
> >>>> enabled based on dma_heap.mem_accounting, disabled by default.
> >>>>
> >>>> dmem is chosen for CMA heaps as it allows limits to be set for each
> >>>> region backing each heap. The charge is only put in the dma-buf heap=
 for
> >>>> now as it guaranties it can be accounted against a userspace process
> >>>> that requested the allocation.
> >>>
> >>> But CMA memory is system memory, and regular (non-CMA) movable
> >>> allocations can occur out of these CMA areas. So this splits system
> >>> memory accounting between memcg (from [2]) and dmem. If I want to put
> >>> a limit on system memory use I have to adjust multiple limits (memcg =
+
> >>> dmems) and know how to divide the total between them all.
> >>>
> >>> How do you envision using this combination of different controllers?
> >>
> >> Yeah we have this problem pretty much everywhere.
> >>
> >> There are both use cases where you want to account device allocations
> >> to memcg and when you don't want that.
> >>
> >> From what I know at the moment it would be best if the administrator
> >> could say for each dmem if it should account additionally to memcg or
> >> not.
> >>
> >> Using module parameters to enable/disable it globally is just a
> >> workaround as far as I can see.
> >
> > That's a pretty good idea! It would indeed be a solution that could
> > satisfy everyone (I assume?).
>
> I think so yeah.
>
> From what I have seen we have three different use cases:
>
> 1. local device memory (VRAM), GTT/CMA and memcg are completely separate =
domains and you want to have completely separate values as limit for them.
>
> 2. local device memory (VRAM) is separate. GTT/CMA are accounted to memcg=
, you can still have separate values as limit so that nobody over allocates=
 CMA (for example).
>
> 3. All three are accounted to memcg because system memory is actually use=
d as fallback if applications over allocate device local memory.
>
> It's debatable what should be the default, but we clearly need to handle =
all three use cases. Potentially even on the same system.


Give me cases where 1 or 3 actually make sense in the real world.

I can maybe take 1 if CMA is just old school CMA carved out preboot so
it's not in the main memory pool, but in that case it's just equiv to
device memory really

If something is in the main memory pool, it should be accounted for
using memcg. You cannot remove memory from the main memory pool
without accounting for it. Now we can add gpu limits to memcg, that
was going to me a next step in my series.

Whether we have that as a percentage or a hard limit, we would just
say GPU can consume 95% of the configured max for this cgroup.

3 to me just sounds like we haven't figured out fallback or
suspend/resume accounting yet, which is true, but I'm not sure there
is a reason for 3 to exist outside of the we don't know how to account
for temporary storage of swapped out VRAM objects.

Like it might be we need to have it so we have a limited transfer pool
of system memory for VRAM objects to "live in" but we move them to
swap as soon as possible once we get to the limit on that. Now what we
do on systems where no swap is available, that gets into I've no idea
space.

Static partitioning memcg up into a dmem and memcg isn't going to
solve this, we should solve it inside memcg.

Dave.

