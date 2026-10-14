Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2057ECC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 17:18:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E216F6B0088; Wed, 14 Oct 2026 13:18:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD2546B008C; Wed, 14 Oct 2026 13:18:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C98DC6B0092; Wed, 14 Oct 2026 13:18:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A15AF6B0088
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 13:18:04 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B7F8E806C8
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 17:18:02 +0000 (UTC)
X-FDA: 85321889604.13.8115367
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf21.hostedemail.com (Postfix) with ESMTP id BECB71C0003
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 17:18:00 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IdTlT82L;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf21.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791998280;
	b=EMlJRi52bPvhanCSaU4vrJtMRWYQC4kksl3aDDod2DJcpXDqNX2RFM95w/66tJkRR/aU1H
	KKIqfesR5fLFxIB0kvuFBRyrgqy2NrWgwyFRdxST5bfH7zPjBR399wZVx/QkRSulXZfKxl
	uEu5A04Q+OuqPHgo3j/hus7wpmjT390=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IdTlT82L;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf21.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791998280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6AlnkTkjE6lopU0pv/Z4Z7ogvXCpr+/YMU8OabuGy9c=;
	b=x68be4e4jCyBz2Llkq0pLy9nCoBHVe2Z0wijDopVsKlPjEI2fA8h/ByaUxYSqoD1AUnYMZ
	FyTUhwmgObO9rRM0tRqwEQZdJHMq5OXrba6ae+s7keZLMo+RPwPUbhOJJRKfmE188cliT9
	H697ohgr5R4XMCWD9pogorswil63bG0=
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c2e62319cfaso134962766b.2
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 10:18:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791998279; cv=none;
        d=google.com; s=arc-20260327;
        b=E+WRQ5JS25pMY9fViTo5tDF6J4Y7ggFoL69JcPVvVVq+GGg8oJQ2ZabICwSQlwC0OA
         QIHPBNSC/CSe7A8+ZPDW2tk/3ufEZL1rBt+7Bq42mb1AQb07QwveevRb/o4ls6oW+jHo
         f9VXqjf7hXAoS/1GQkR1XiJyfNuXoYtm05OSgl3CEs0VSw9Y37zFTfkq+Xo3znAkAHyu
         h4OkiRH9O2+HRcumgnxGK7nB/nTFXPk4FXr2BKQnlLhBFUAG48iWLKpsDH1OZ4FW3Fpq
         9yWe63ehe7mvVngZlnCHW3NouJ1Kw8CKG+fuQHiI85893PkBWlpiGHYBOnIIblL20LMK
         vIcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6AlnkTkjE6lopU0pv/Z4Z7ogvXCpr+/YMU8OabuGy9c=;
        fh=p/n2Gb7M8jssj1pnQ/y69s1IQY8cAobiKxQxTuOeO/U=;
        b=lYdEsuBftZoOB+KwTiNBkJFxmppJiG2yiP2au29KPUwJ2OaIInMlKv/jhCMcD/SChJ
         pZmUdMO6/2keXRlxkQpa3q7y566zSgU4xDX7C8sLY3myyM2ElO6sF4IB+L2+ZK1iE/yD
         aM9DxQLFZQdvjipzGPKuOudcRdjhywsPqO2oFhqgkIT5InMmTO9Mo9Og9QKtx+4f0o/t
         OfzLL3xLVnNvwUAoFMVEOwk5Umo3UCrH4QIMw9XxChJKxHwK0/OTNY+uP+dsh7TyY+My
         97ToVLZ2wb/kSEZP6GqQ6/SbZlQ8tTachQXAqDbxeQUHI2c8rLc0ccqRhVJ1cdQHK3E/
         vGww==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791998279; x=1792603079; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6AlnkTkjE6lopU0pv/Z4Z7ogvXCpr+/YMU8OabuGy9c=;
        b=IdTlT82Lzpx/aM4qS3NWhss99onzw36S3PGGEY5yViF2TVPPgQ6TFFW7ybtEu5vyN7
         xHrGlYwiH3tXFteXut3hnakCNc5ro9Czooe4I/Vsq4+rXN+CQk0hEBTOMIPOwvORH6Ic
         FlWaGTl7gfEb6Y4EMRUGDVkqAztjWDxiSlA5A+m859vYvPSo5pOruxAEs4/X85kgNf49
         OKOoBqlvmWtcelKO7tCoHTob/cA+gUly7nuKYjieT+DPEeeVsTruSRvRvqN2u2nBzNKk
         Ivkh6qMJIkf2sE28gk8xZfK2klhVUau8CK4bRDw7eDrwxac4ZlMR8zi3achmMgdAEt2U
         nHxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791998279; x=1792603079;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6AlnkTkjE6lopU0pv/Z4Z7ogvXCpr+/YMU8OabuGy9c=;
        b=18vzsclkhLtJiCNtIzAhgZKXUX07M4oKbeqwu2IQw0r2bcjLAN7WVsMZuc7lf0ksxz
         d2oOpit3S4O0NaDk3tUKgmhg6nhBHaVhcvKYkvvunUgCMd9SG5GTMGL/m8gifE4QQqE0
         Ehay6jeo4JjSOyLGhDwwDx/BsWEKgG5QH5thAbJ8EytfbCUWcW1sHTCRxtXQUE1fa4bm
         p50LglnekN7XSDnIE8V+CsoV8juptx9xNkLj8fa5C8ehExeQXF21udrgidmj2KH0nVxW
         tX6aT2r66sCyihTRgGUw83qRrRw/BL3fx4WuwoekXeBGRhjJRoXwsa2oqjMCJe9RYn/S
         +/xA==
X-Forwarded-Encrypted: i=1; AKwUvByZPxJkFu4ecpsE2HyMy30FnhyYH5heo8B5T/fFgtwxH2Jw/YUjuwQEZoDQW2l8/CjzWqjfP4hOHQ==@kvack.org
X-Gm-Message-State: AFq9FYLisQr2HlLmb5cRMZ4PAh7dy5kVhbLk7xQTUcx1KV/IFzYqfhMW
	6E+24Us69gx7+Hdbtvz08HBHtAFOkem7ARc++gfDO/Q+YrFnq/bKKMW59Rvl3+RiXP2CrseH5Cv
	WBW0DQ0fsQXSqgYH1QVaGZuIcvxjKrqE=
X-Gm-Gg: AYBFou2QZPQ/JittiRQLq+IVc8X1AK3Xp2GH/CQOdTDQmndDiWbvevj2HTzZg/8GFjW
	j905b+Vz6ugfmrSp95wqVSqHN3B+OdncQzMKPK/DZq6yvu7tB0vjXDBk23+eYWRvxNelTutTC1L
	dkORhMVFjIc785xT/IhcT1u/cIpVmOZj+pRw3KUZ1uCWFFpf+j25pY7zMGo4yaf02jp7+kpn7dK
	YoGTn1Hkt+iaf8g3HlObfw6ZvZCh6MYpJLrAThcn3UdZCpPgjrEd2HLZEe1lZhm63Do1oCaEhZQ
	DXKo847n9MEocXyowcvxjyXiMPHX/XTioLSlGWafvmNubPbKOdTPRyrx9Ni2Bm5ZItenJaXxpaN
	+otMdNxiByOBXTt57QvZ0KSA=
X-Received: by 2002:a17:907:9449:b0:c29:3821:ae6c with SMTP id
 a640c23a62f3a-c31aa09a358mr1693259966b.37.1791998279045; Wed, 14 Oct 2026
 10:17:59 -0700 (PDT)
MIME-Version: 1.0
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <5fdb3777-95a2-48f9-bb38-aa4ba3c96a81@kernel.org> <CAKEwX=MuW6q354nB3tyFTM8d3ox7LRaqcSfUxeATR=Sop5mZPw@mail.gmail.com>
 <5ca344de-bc34-4a9b-ab85-f553811a1d9c@kernel.org> <CAKEwX=N05iOC4hmiyTt5OxjAsOfU7_V8xGfmK_RgUyrKtuyUTA@mail.gmail.com>
 <CAMgjq7DJwGCHCAchcfi2Kcu+XHx2YnKXDj53e0t2kpG_GSejkQ@mail.gmail.com>
 <aqgMCIOFi0dKx_6L@fedora> <CACePvbVMFA9N0nQers=sOnSXGbNhtNE0ewq47AJEH5Cr8imQXA@mail.gmail.com>
 <CAKEwX=OMYhUs3tt7jUzEzxsOW3yA2JmzpwwxVBP2eZuHOFu=vw@mail.gmail.com>
 <CACePvbUMjRgK=dQzLjECgBXaUtQSPdAnBXL1Y4=Kh5d15swYvQ@mail.gmail.com>
 <5c8a2b7b-b76d-4bba-92e1-ec3d66794273@kernel.org> <CACePvbVTnCOh51jvEpkDJ32idvCubgN1eHBps6vESjhVC8E_aQ@mail.gmail.com>
In-Reply-To: <CACePvbVTnCOh51jvEpkDJ32idvCubgN1eHBps6vESjhVC8E_aQ@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Thu, 15 Oct 2026 01:17:21 +0800
X-Gm-Features: AclHuK-maXeDqE6RBGOs7KQg41zXWuvLhO_tf3Hmyu48dJ37MpyAz42TW_3WsI8
Message-ID: <CAMgjq7D_=_4ZsCWJYywpZhPtg+YeH8o=ymRrV3sQ_58G6rs0sg@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Chris Li <chrisl@kernel.org>, "David Hildenbrand (Arm)" <david@kernel.org>, 
	Baoquan He <baoquan.he@linux.dev>, Nhat Pham <nphamcs@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Yosry Ahmed <yosry@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Rik van Riel <riel@surriel.com>, 
	Gregory Price <gourry@gourry.net>, Wenchao Hao <haowenchao22@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: kpo4mjpxo81yqakohzx8smaq657hu15j
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BECB71C0003
X-HE-Tag: 1791998280-456078
X-HE-Meta: U2FsdGVkX1/g7KfZbiv2UfwDdphjCRSd8P9YjzkdCDaT/bOUljIR6Hew57hL7STorhbi+K4aLvU9LCLEmuQGYzlWdv7uEKirI2nnvtTND9UZ8BkWhd1pIjQYHn+fvT6eCFEWgJNfAvgbRbaS/asNRUVes/QSbIbX5aerCyxhNtDbBeC3T06aLOxdhDKblKcEMxlrowXfkkap4EY7h/9CbUCpa64W7Z11zg4XhfjISmcZZy0aWb+10ycR9gC1LVXrZOjNS/SDl4/l23vNoCTU4pJgLFT9t3xg9aE5EDvvqxeBs5v3wkPk4a31i3T/HPGxGRKHRnlTkMzAKr0bq3wdkaBbbO1b4J6/riy8pnFVQlyzbyWyxOfPuYft0+yf/V6x182aUg+mxQZ1oSeQI90FTQVrlbclnqOL9J0EtTnk+uuyK3TYGrOoOtz7d1r+oS7rRC0ROUpCv+SaaG3Cs0WdeHViI159+U3kaKDI8PlJcJkx2fdmqsMnshVauajplAd76T74UOW9VbobJR446+JaCUVBxGYqlDBEHj9PjFK4CI3W37g0mzLl9Ih+WKEhTXRX5qnkN/n1bIB8AGwojNDIvU53PdpgrK3w3gqcnAq0D6b4Q1MSe4Y+P35YYRxiiu0o3AwtlWlq6dN0nHflaXfHklpjy582Ru/jOp5xgEW8Iu/+hqCjCUYv3COX41nJJChFTY+1SDOkx7RpBCmNHtXqmmKF9cJHY4FMZ1OXC4E/yzWs8AwPhOeem3hT6eQOg+zIreiE3sVBQe4jgdRMCT+lAWUqKMX/io8sg+eHmoE4YpO9QVPWzYQHao5AYhnbaXNxq7zrHE+xGt5WelSXOJueMJiJJMKWGnjfr8BHQi9KJqFeGZU4DdXnm7FV9hn5g1c9+74oP9HOCj7a1LHTp2JTwxr9X1uGs+LuvdJX46pTpazBgM6nL+fN/63j0h2zkxP+Js/ob2dooMdJ5mIMEAZ
 /gpNgw9j
 V6e2Wm8qgAw5d9A4DtOwqgl1ax31OOfTx4hPEsgm/UDjIsuhWLldryPjiSABXH9OdQxIbX08YkQYehDbQDpGXCJ5mFJ5Cpysw/ETP4X88nTUF+zmwusFhUtE2qdHPyPY8m8o3FQlz9Sr0xu01fbjAaWjLDQB0EEuUCehOiO5XnHnF6zQSJGVGlRcgjE9jc4EDB6QPXnWiYKkg+dpfHJjvT7y9CtwEeeNuky2Y3lejcDE22NOY9sPDTdlKj8Eqz0VUjxE+LHXGalU8HlHOhN0peQ4OHJiEkHBjD75WO2/Pp8QHgw7NsXSklsRef5V4imSPTP9AQJff1rDDG+v1lJoMi+jtRUucUk3qpaiyBsa5DhzM9eWHWFznBrgnKLSub2bAcTogQ0ZA+HhMwju7x/hrSY+3wEZk6Cbh/ZXfapjPIQ8LB69LvT+QchfLS0rynu46vZSkjdq6BhoJTWFL81p/OOmdPpSJSGD9gcoknEvCfKDTeoCDcrSuKy9k7+MBYKGxMOQjsgy1XL8iHsjWNtBrQdDbv+DB0F/bsbOcAODLP5qfczE4frEWK3k593erxIsm0/P3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 13, 2026 at 1:27=E2=80=AFPM Chris Li <chrisl@kernel.org> wrote:
>
> On Mon, Oct 5, 2026 at 5:19=E2=80=AFAM David Hildenbrand (Arm) <david@ker=
nel.org> wrote:
> >
> > On 9/22/26 15:38, Chris Li wrote:
> > > On Mon, Sep 21, 2026 at 8:56=E2=80=AFAM Nhat Pham <nphamcs@gmail.com>=
 wrote:
> > >>
> > >> On Fri, Sep 18, 2026 at 11:50=E2=80=AFPM Chris Li <chrisl@kernel.org=
> wrote:
> > >>> No that time slot is too late for Asia developers. I don't think we
> > >>> should use that time slot for swap alignment.
> > >>>
> > >>> We should find a time slot more friendly to Asia.
> > >>
> > >> Any time slot would have that kind of problem. We're spread out acro=
ss
> > >> the globe.
> > >>
> > >> Let's just use a standardized time slot we have for MM alignment ses=
sions.
> > >
> > > There are more swap maintainers in Asia than in the US + Europe, at
> > > least based on the maintainer file. Please be more inclusive. If the
> > > alignment is done without key stakeholders, it miss the point.
> > >
> > > Sigh, we can't even align on a time slot.
> > >
> > > In that case, let's keep discussing on the mailing list. At least it
> > > is accessible to every one.
> >
> > Looking at the mailing list, that approach doesn't seem to work.
> >
> > Finding a time slot that makes US, Europe and Asia happy is ... tricky.
> >
> > 1 AM is certainly unpleasant.
> >
> > US vs. Asia is also tricky, but doable.
> >
> > China 8AM vs. US West Coast 5PM?
> >
> > China 9AM vs. US West Coast 6PM?
>
> Hi David,
>
> Thanks for organizing this. Time slot that works for Baoquan and
> Kairui should also work for me.

Let's see Baoquan and other's suggestion, both slot are fine to me as well.

>
> Hi Kairui,
>
> I understand that you have some face-to-face discussions at the
> conference. Do we have a list of what has been aligned and what is
> pending to discuss? We should have an agenda to avoid repeating
> already aligned items.

Right, from my perspective, here are the following key points we can
discuss further in the incoming meeting (most of them are not fully
concluded yet):

1. A limitation for the logical size: from my side, there are real
usages for a global non-memcg limitation of the non-physical swap
space: e.g. thin VMs as containers/pods with no cgroup limitations
inside but which need in-VM memory compression and a proper limitation
to avoid thrashing; or low-end devices/desktops that want global
(root) limitations. And also, Android have a limitation on the ZRAM
size (well for this one I'm not from Android team though so that's
just my personal development experience with Android, enlarging the
ZRAM size on several Phone swill cause serious junky of Apps due to
over compression).

Nhat is concerned that exposing the sizing allows users to tune it and
potentially misconfigure the system. However, I think a user with root
permission should be fully aware of what they are doing or they can
easily mess up the system in many ways and swap limitation is a very
minor concern to me.

I think the requirement for a logical non-cgroup limitation is strong,
but the discussion hasn't concluded on the implementation method.
Perhaps something like a Kconfig combined with an interface or command
line? More ideas are welcome.

2. Charging: If you consider memory.swap is physical only then indeed
we should not charge it, however, user are already doing that for
years so this is a behavior change and we are also pushing memsw into
memcgv2 as a interface to limit the logical memory usage of a
container. So charging of the logical space is useful, how to handle
that is tricky though.

From our usage, this should at least not block adding memsw or
anything similar for memcgv2, even if you want more customized cgroup
accounting, we need to charge it into some counter (a page counter,
not just a statistic) in some way.

3. Swapoff: This was discussed again too, as vswap was trying to
remove it. I think the concern is mostly about maintenance,
performance, and practicality. From my perspective it's a critical
component both for preventing minor or major faults before predictable
high traffic arrives, or for operations/debugging, and for releasing
the swap metadata to rule out any potential swap / page fault effect.
There are concerns about maintenance or suggestions to use MADV, while
I'll be happy to explore and improve the current in-kernel
implementation of swapoff later if needed but removing it is a really
bad idea in my view.

4. Writeback: No doubt we all agree that we definitely should have
writeback support, Nhat's concern is that we should handle the case
where some cgroup doesn't need zswap/compression and ensure that works
well.

5. Interface: Given the issues above, what should the interface look
like (swapfile, sysfs, /proc, etc.) and how should multiple
(non-physical) swapfiles be used? Nothing much is discussed about this
part though. I've heard users mention the use case of multiple
compression swap spaces, but I don't have a use case for that myself,
so I don't have many comments.

6. The one part that I think we can and should agree on it shat the
implement approach: at this point I think VM_SPARSE is the right
direction, Nhat is concerned about the testing on it, and I think we
can have more data for that, and collabration is highly encouraged. I
previously conducted many tests on everything posted from both sides,
will try to post more on this too.

That's a lot of problems already. I think we can discuss these points
further in the meeting.

