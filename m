Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC988FDEE52
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 22:37:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E80236B0088; Thu, 23 Apr 2026 18:37:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E31456B008A; Thu, 23 Apr 2026 18:37:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1FCF6B008C; Thu, 23 Apr 2026 18:37:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C0DC36B0088
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 18:37:12 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 31521405C0
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 22:37:12 +0000 (UTC)
X-FDA: 84691282704.26.8231BE1
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf25.hostedemail.com (Postfix) with ESMTP id 3D057A000A
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 22:37:10 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=NgnEUswl;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of surenb@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776983830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KcOkDAwRnF9DZsG8k4nq6YrUO8JUinCYXdZGaNjU0Rk=;
	b=ZmCwancCAX0N9/6CV9xFCVH4Jgq+tZ8D6gdPp3no6VgGowa65YiEgbn3uYLsTgdYDiyE8O
	ven1yhcJqhMhxNmrd9pHiiOGaQlzIP1Iq5UTKzFfmZGEzC6RNn45oELublHYp6JYLI2nsu
	xS3EC5iiRiI3dVQCB+icjbFebnCq8Xo=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=NgnEUswl;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of surenb@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776983830; a=rsa-sha256;
	cv=pass;
	b=xnPb5DCvAe4PfzDzLmp4NZwhd9Ko5VtMyCLi4gokcc8ejyl4O+T89jMUHZyLjyAPx66iee
	eXHc3tqA1eDkdFptOdCVDOnmeedig3Nk8XMrXHBuq2nf/VU8/biIlJbo0mNbvEr5+7Gi9I
	wyN604UtElU5XnMo5DCmxIol0cz4CgM=
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-50d836552daso4088721cf.0
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 15:37:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776983829; cv=none;
        d=google.com; s=arc-20240605;
        b=Z5F2oOS/uLAe7MzRaYeawjkY2Smc+AzB4iYMSoWJBTzz2S3E+fD0zt2mgfbQ6XW0es
         yXi4t5IVVlCzGLk7z/HxyuaUa321PK4mcI+2PM/lBMyuvFOtEHpmtFdwJB3KlP74sj5w
         oJjvVNV9Xj/0MjmhLUd7RWIJYDB+i1cMz0HT85mMes++W+WCAyHTGQOZfdcztJv+tcEK
         7oisnJmSmPysZFTYwYOQ9p4YhEDCLvqk6p7ahB744EEnhvVgqDtrwu6np6OrowLpI7fI
         n86ysB8HpPxGPP4PzHu544DgxojrZ3AYzOKJInTVxAt+XPMW3LmXZ3aLPfgzTRc1+L89
         Lz6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=KcOkDAwRnF9DZsG8k4nq6YrUO8JUinCYXdZGaNjU0Rk=;
        fh=/ortrJ6/w5EVwxAz+gMjMA0nnT+erXI3G98O4S4r6ac=;
        b=ShYk91bp9234lUNjSOwh182C0BQ8ngFBzJIaY3D7fEJcv0Y9W+ICOKNQcvgVMNpw2l
         rF627ESCXIfJXGLuu/nhu7Rc8oOdagq6MSZYc1SOo+PGkPicZ1Qevm97LBENrCLqyDp+
         0aX+CDkmCYle2h0X83kcDsSCBnMUbvxKL5tKljuMonDaQoImmi3qM2Y3UH0+VL5JSwVP
         Bsjyql0PxKZDgncRhEbdq+aoBXm8xizGocsthPAAtQoqflP7Si5VLUq8h8d58wvAtSQe
         9KfOrrQImSKwcq4volewAN0mUOcDQoxdkxHn40FBFuw4qCKP6YT7IYTqB7JHGYMNfKd5
         /7gQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776983829; x=1777588629; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KcOkDAwRnF9DZsG8k4nq6YrUO8JUinCYXdZGaNjU0Rk=;
        b=NgnEUswlJ2f7L2X4ojcZVt4xIjSh8jzLnPM2i+CYSmpMdgtO6AmEWqM2iN3cPZLK45
         LrWFofnCQnUFynWPMQwkcj7vmaVCq3WU9vWIAXAprIhypDr3/vOE/iPrlr5l5SUbTmht
         OrFUsOy5ATO3vXa4fwm5rPHcfHOrCxnLU7i2pIucKdqmJej0b5MQy15rDzyoZeM2QUt2
         zgB0qVt1B+v34vkck2BjmmbRSQg2Y6AkOmgGeDu1zCST9TnGlX8od/H2Vgqld/adGvda
         iMo5Z46s1zlgbLM8JchTEUHUcY7cOj8EgxDPmEyjjFedBLHI/nHTcHXz82z/6ZeBYpbG
         GK3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776983829; x=1777588629;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KcOkDAwRnF9DZsG8k4nq6YrUO8JUinCYXdZGaNjU0Rk=;
        b=MqmWrCD7sQRrw8VV/0KlKa26wQ0LkC7eMWrExxDQCEzh8x8/N0z+TiCs8y6G2NSZYk
         swsdm779yFoyUYCXIU5HLFKJP5uu7fTixsYhLh4ghyyfw/NMHkQl+/cYGQ3ldsfZJQ7D
         OFJ4PvLp1MggG1B5GHrtpXK18Wd8ukrYWseUsWLEr7qVzZ1LIEPmE06vsw9nmVHW8tR9
         K0qEPYrMUv5VvkLA/2fMLN6qof7yuhopjeYCPJFtaszuMPvk8ey98UZLd9g7YSJnmdTL
         NusFSrTKJGQ/hi96reO011mGv+62praLnlBLULhuHJUxvOw0OyFkZX9HH8xWUut2ZaJF
         HLcA==
X-Forwarded-Encrypted: i=1; AFNElJ+v9tYb66F8xbeG0yu2HGRaZPcwwb1VamlJgJ5fNIsou6u0/FkIVBxl4w7sCKWUPifK/21W+gPgMg==@kvack.org
X-Gm-Message-State: AOJu0Ywp48gUKqTaUSgsvS38j6J8bPn18vgEe4Gt3aXpSeYxLSc8GWDa
	YeBSfNbYvNbh/xLVWlwjq+Mu8nDyKguQRni5UgL/9PCr3AvnIE8LUHHFKxA4JIXnnHSkK8ysd9y
	z4uDQsWZtmN2fworeDpZ48vz4Aoo7bcX21Ad5XS0A
X-Gm-Gg: AeBDietuXW+USlj3hXiwiCXaKheg2cmVle2QDvRY9Lv/9xJXanLzyke9GAel9hrKWvF
	9hJ4XeBGzKWBWfdm9ND76e/Pm19FBF9kIJ8Lh5xHzw2C8atKHXpmTMK4WEpRPA5miuR7dGuaVK0
	C4QrB8thiec9TroxofKeo3l/4bLNIU3efB2V+qs2Rv24FWq/reXOxRjTPdk4soP9EuKcsVu5puV
	MQk5PZWGgVYcnoa4fIrYEQrrGowwGsBKny3Sy8Q4BIETtKA1FFXXcDemSI4PpeA/hePspkp2Lad
	NAnVeehgu+Oe3BZ5QTKg+Ua9eD8=
X-Received: by 2002:a05:622a:5a87:b0:508:fd42:fd05 with SMTP id
 d75a77b69052e-50e4420283bmr101009631cf.15.1776983828775; Thu, 23 Apr 2026
 15:37:08 -0700 (PDT)
MIME-Version: 1.0
References: <20260413223948.556351-1-minchan@kernel.org> <ad3ldU4DZxga_J2L@tiehlicka>
 <ad6c0DN7AGoOQ_Iq@google.com> <ad9AXVYxWCkHmh6J@tiehlicka>
 <aeAeqoJ_acUAza8D@google.com> <aeCHvYOKP1exBBns@tiehlicka>
 <aeHRLv834FCAQlQ8@google.com> <aeHdGf7XDjvOES1V@tiehlicka>
 <aeagUxlju40rvkYQ@google.com> <aenPV9ewKAzRF2Vg@tiehlicka> <28c3ae9f-c974-454c-b8ed-ba0ba0a5706d@kernel.org>
In-Reply-To: <28c3ae9f-c974-454c-b8ed-ba0ba0a5706d@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 23 Apr 2026 15:36:57 -0700
X-Gm-Features: AQROBzCRT5mgPj-Ya1FtxxMdAbOe_Au-7ZTsnyq1eqHPkIRlfjYZhnEFFLKhA8E
Message-ID: <CAJuCfpEGCvuaQ43W4_bPjpoiYgmEspxV78-U4dkA2bcjfxCyFA@mail.gmail.com>
Subject: Re: [RFC 0/3] mm: process_mrelease: expedited reclaim and auto-kill support
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>, Minchan Kim <minchan@kernel.org>, akpm@linux-foundation.org, 
	brauner@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	timmurray@google.com, Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3D057A000A
X-Stat-Signature: x5c7jannd7athz7q9cgnmzyoncq6dchm
X-Rspam-User: 
X-HE-Tag: 1776983830-224205
X-HE-Meta: U2FsdGVkX1+pbWBOl5/TG9LcRMcohVDzmChaJgi/V72mFY3VQaSYNIVTtWDXZcRHUEzjK8wHXYRwlKm15iXX96W3RkugzAXPV5yT0uAQT8cVj9MU91xtGtuK6Io8k3whW9ChgMlA4p1jnnNeUzSdYmZP7Sg8SYDkK4Rt1yMVykFL8pJ1zATAQh5SB3VVGz4A5v1TLBxm+FWfUM9LTv00znq56bE+Igv+B/a5QImUs1V+DBSjQTsFZ75jnHYdkIP6nGiL/hc1f5CheFwhPtjdTBE7L0NEQy1I6R0nacbh33ouVZzNdUF3gBjmgpnYXeQEosqdbxwdYIz04JV7pJhCJLSqDa2ezmOw+2rvubvIviM4fu2QRsCPCfBr6LNoDOV2GqFiYO9LlJiLLVbUip1Xs0UNISNlHGOaVvR+z0BKb/K6s+JQ/c2L8VqWqQDd6i5il2b5f5frPl0TP3jUotg7shcqWQKrd1sU2jLO25vO0THu8D76NR/0Lj0lCsSce5PdSOqAi7CxqcA5sshtNbbuVDzo4CKos+ippxXphvUuFoq30Xbu0lqMbjo8GHZheraHN3cX1hWRVO7Vyrmo7P14pSr+uKNY/u4+om9+1M0ja4Y5beeicJX6d/vRnR78AAYAyQYRmXWZ7JxXxKFA0kqOBwGjr5odV63XhDwg0dNfY6+P3dJh/UjpfzY/6+YtYp1iqwGtoM6WEiUhqkfJrqMkmrJE0YG5sE0Ms8iSB37VCgdfEb367fWiOC9+jsDQF1G/1da4RCdoJCOWdTYjDnisF4+33Jo/VR25O4Un62/6cSLjrDpI8CnnU8/ikMgT6ax2F4AvDrHpg1t+Nyk8JlbKT+K9ANKONsZ+Gmc4U/g4LogujuKOnB93PiPI3Y7lqvfiWc+tbug28mwpvIgtuyEfe7eWZrKlsrTvqZKxtbmxGHE/s0B/a0ZyvU9bOrPSk7VRM+QJi+As0bBEh2+6oh/
 D1izdqwj
 AgEV6pwLG6I4trK3N3F82p/C/9BmPi3+1W6LxT/KHKGWLmz2HsY68jCC8HmSAFMOXUwzP2tAY2XydTJkT0Q1rfSA5H50uhTK6oe/V8/+BIOc/MOBalIwrxlIh7TCqzUMsddzmT9kAksRjL/nDR9zO3snu6olvNXKkal+AcBkbMU17gmMWCpB36/g3XvLqR/8eMUZguopsyzueUcrgZO8FuB2J7gPZRJMwTnbSqxdJklpS4ihkVf/bXGXKXAQo1695ATFEMM7H3sIDZIi2cfN3jmzFHyp4bZFnsCkDZE8EupXHWyJHgmYDCc9lGQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 23, 2026 at 2:50=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 4/23/26 09:50, Michal Hocko wrote:
> > On Mon 20-04-26 14:53:23, Minchan Kim wrote:
> >> On Fri, Apr 17, 2026 at 09:11:21AM +0200, Michal Hocko wrote:
> > [...]
> >>> Yes. All which make sense, really. I am still not convinced about the
> >>> clean page cache because that just seems like a hack to workaround wr=
ong
> >>> userspace oom heuristics.
> >>
> >> I see it a bit differently. When paltform decides to kill a process
> >> to free up memory, they want that memory back right away.
> >>
> >> So it doesn't make much sense for the kernel to ignore that and leave =
the clean
> >> file pages to be picked up slowly by kswapd later.
> >>
> >> In some aspects, you can think of LMKD as a more specialized, userspac=
e version
> >> of kswapd. It has high-level knowledge of process priorities and knows=
 exactly
> >> which process is safe to kill to get memory instantly. The kernel's ks=
wapd,
> >> however, operates globally without this specific process-level awarene=
ss, which
> >> makes it less suited for this kind of targeted reclamation.
> >>
> >> If we force LMKD to rely on the slower global kswapd to actually free =
the clean
> >> pages, it defeats the whole purpose of targeting a specific process.
> >>
> >> So letting process_mrelease speed this up isn't a hack at all. It's ju=
st helping
> >> the kernel do what the admin wanted in the first place: fast, targeted=
 memory.
> >
> > This is a very creative/disruptive way to do a memory reclaim. From a
> > user POV I would much rather see clean page cache reclaimed before my
> > apps start to disappear. But this is obviously your call and your users
> > that will care.
> >
> > Anyway, I still maintain my position. I do not think it is a good
> > idea to drop clean page cache as you do not know whether there are othe=
r
> > users.

I'm very much familiar with these issues in Android and really want to
find a good solution for them. IIUC, this RFC tries to address 2
things at once:
1. handling clean private page cache when reaping memory of a kill victim;
2. addressing a race between kill() and process_release() when
process_release() can't happen before the kill() but if it happens too
late after the victim passed its exit_mm() then process_release()
fails to find the mm to reap. This defeats the purpose of
process_release() call because the actual memory (released by
exit_mmap()) might not yet be free and a successful process_release()
would be very beneficial.

I see these two as separate issues and I'm not sure combining them
into a single discussion is a good idea.

>
> IIRC, Johannes raised in the past the we cannot predict the future.
>
> For example, if an app gets OOM-killed, wouldn't we usually try restartin=
g it,
> re-consuming the clean pagecache pages we would be evicting here?

Sure, we can't predict which app the user will use next, so when
killing we usually kill the least recently used one. That's a
reasonable strategy in most cases.
In general, if speeding up the victim's reclaim negatively affects the
overall user workflow then this would mean we are selecting wrong kill
targets. In that case, we would need to adjust the target selection
strategy.

Thanks for tackling this Minchan! I'll try to review the patches this
weekend and provide my feedback.
Thanks,
Suren.

>
> Just a thought.
>
> --
> Cheers,
>
> David

