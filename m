Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFE8FCC6B0E
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 17:01:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D85236B008C; Tue, 13 Oct 2026 13:01:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0ED06B0092; Tue, 13 Oct 2026 13:01:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAFD76B0095; Tue, 13 Oct 2026 13:01:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 837B76B008C
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 13:01:40 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2158C1A0E22
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 17:01:40 +0000 (UTC)
X-FDA: 85318219560.08.EC01F13
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf04.hostedemail.com (Postfix) with ESMTP id 19AAF40005
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 17:01:37 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IHVTm+oq;
	spf=pass (imf04.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791910898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UQ6am3LgmR/Ys7leJ+gNMiXEAQz+mkoYeAP0NcDYoRg=;
	b=0mHNiVcaJFgfCZ53YdysjyBMDYd35hbhTB6Aq+g8VrkW7AvLfqO8FD7LfzSkAZYqocfY5q
	ZonCVqvaq55wkdcI7CKLAjP9CZwENi7O4yhBUO35V8eDUEcpibTgEQhCHof1IJDlgPjwcD
	HD+ou8yDQXgyCBDYazhHPLp+5HWSe3E=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791910898;
	b=OSS5r8gl5j3UIQ2CTSwbsBKxvIiIU81d9BCi5Do7U1liwxdmrZCjk1NqIK48/wum03rKgh
	JQnwPQNiH/WKyT0t3aCkDd6vT/JB3IDQ4JERjk0Gp2E0tdpH8EZgpeFqklsYrkaDJn29K5
	lI185M4xnvqeerMsmo81lub0C1zIYdY=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IHVTm+oq;
	spf=pass (imf04.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-48c4be28b82so3164502f8f.2
        for <linux-mm@kvack.org>; Tue, 13 Oct 2026 10:01:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791910896; cv=none;
        d=google.com; s=arc-20260327;
        b=INJ5fIqVRH562O9qhnaVPVm9kQhzYW84CdEbD2sdW89/esDWG+H4L/VwGO7yGZ8QNc
         QdmNbeuaGtovPo9oDmfg585yO3ea//T95t+oDYj/INs5kt40IMbJMTABBggKj73Y6GYN
         94LB79NTAPC0oLtEkXFUVWNB0P1eEKfMbaHNVG59d2QtXXNj5PSlaHXj107xYKctN5AI
         up/JLAXikw36gRI+ybaXa0drmi2RRhYzrg0Or4Gk4yWbwxYeEeK7GKMQK1fXZzQxz1w5
         tpf8FIJUeyunx6Z2CinSYQ8eJJYBaj5vWQvx97dNldT/ZN08oOPGydT9W0bwFmOaVoRu
         rbZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=UQ6am3LgmR/Ys7leJ+gNMiXEAQz+mkoYeAP0NcDYoRg=;
        fh=QDGLo0Ws5ZxBrg57vCMkQRRuDwF0EwANf8Aekkl5g5E=;
        b=iSuRJe5eWD7bOMPs9OrZYcnDGOPklYSkF3tkmEeF7zZ9UOUkKeyJBjq8H5CllJcQbR
         kODAuevP3A27LZO0DgCdQpwtUA4f+xDBprmXYMDJKsNWE8uL35fnywPGcZeN6CDVBIk6
         Q1ppCorZE42bLb2u3dBFdC4/J8trUJzE3lX80IGzw/7+hQYNhUDkCw5GcCc7/ufdj49X
         9I/ScqwTuh8Wha01P3VbvB0adyl+p4/0rGE0jmDU7ur9H3LGumW8kT+TiozRdK/yk2ol
         7IILbvCkvkPlmfhY7MGrsZQ4qLVU9mSEJeUr5+6K0Q23tyTXR8DE/t1SF4JAglD1hrZ0
         lMkg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791910896; x=1792515696; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=UQ6am3LgmR/Ys7leJ+gNMiXEAQz+mkoYeAP0NcDYoRg=;
        b=IHVTm+oqba/7vIsaVOLe6VRyUlPkzhL4sIbYNNtAjGtgxk41yMFSBCFMF8zUAnwZ1B
         H1aUsh/h5TTt6F0eXz1+RCaNL5SNBitx7OW8s8A4GOdt56uZaxlk+d5HYc3vo5TvTuiT
         FApgHgi/XzJE3eoaVlk0i4o6tT3V0x/unN2LIEa6mf+7xtPqskzi7MU9zL5AZ24w2rF3
         M0A6EdD3QFHV/uKHJLPDnj3jzmrmu1NmC6KbdP/jaq1QS3pNXKNKqpZqNocm56uUMu7Q
         H/DchQOjCMIlGhNxbKVtZ1qlGIjkNnf52Si6i9EWGX8ZRQCJFdZA8zU0eJCncJhjHF7u
         88nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791910896; x=1792515696;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UQ6am3LgmR/Ys7leJ+gNMiXEAQz+mkoYeAP0NcDYoRg=;
        b=cYZy17Re7U9sTNLn9nAruvTsgtOd2YxOIQro7eCfsCIDd79p520n5u9TKr/iLSQPmx
         f26QWLpmv8IGbgHYEjFFOENhEr9She6Horf4Yz0wYN2JPyrSh9QXq4yFsp1QqCbMK57x
         EKtBYUP0J/oDoBpgV21dsQKbRKOSZlqECjHx/13vRbRN0hf9dj4TszFkFfhNfQIKYulk
         ztcUdlO09k4k+8u7B5M5CfUu4yrgUfEf9Z11FCtaruVzn+3yDHgGA1YBUNkg7c5pksX/
         Hzm2JDKLx99rm7FH2gzf/bVq6fuWM4DFmA/AFncg2dqpu/G1bSiV59PcrUmlWHc+6VkE
         X5UA==
X-Forwarded-Encrypted: i=1; AKwUvBya561qQwpW0ymcplv4fxxVe+jMNgjr4uftVBOmSCoU632Pe/5n3F1h51KM41zFzGaaoSeiSlCbjw==@kvack.org
X-Gm-Message-State: AFq9FYKk3kG5LTGSdpcAD6WYNo342H2DTxwP0Jcy0yak1c9BYPV7pFOy
	ahIBSEJiuoOFQqW9n3GpYPoOKx9GJKunAhY5+MQ94GAl3mNwpffSdQjTXJX6H+Hg9XjwBd36cyt
	5hUG/XSr1FHv3i+ATPBY4nCYlvB1fdW4=
X-Gm-Gg: AYBFou1xy073K9LZw+4itu/qnwiKc/pQGwifHtypMnENV0JGeMDtEVlvzb/8G7Cq/BW
	xoin4od02G0MVDpZVJWY0E4go4jLCjF5CA4fMt2iKsnepRmCKSuoEMWY9++Sqx7t0pcxvEyidiW
	FIp2lIaCzn7JItA05JCZVN1Lg54XEM9ezvwg4k18pX0vOutvzmnT6GrujKOUKr4ACTjjLAcmRq7
	2GSn0HUourrjXXU2SF1y+nDf/iB6DbDIhtifnNbW4PZTAPAl4FnG/GFmhoDgShUBMcChEnaC1mV
	8vB4u/5sxlPUMhWxz2ExC52ZOuTlqvIZcs2HxrSUrjkp/GovbX7A67jUyALHI3kg1mMtghqWaMr
	+mnJ2gE7riSxSclNVNUjnbrk1juovAuboIVN91vTe+HuVjCL9PbUQNm5QtJpsKK+ZGhSdbyU=
X-Received: by 2002:a05:6000:1ace:b0:48c:571a:a1aa with SMTP id
 ffacd0b85a97d-48dba9dacf6mr28217721f8f.19.1791910895957; Tue, 13 Oct 2026
 10:01:35 -0700 (PDT)
MIME-Version: 1.0
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <5fdb3777-95a2-48f9-bb38-aa4ba3c96a81@kernel.org> <CAKEwX=MuW6q354nB3tyFTM8d3ox7LRaqcSfUxeATR=Sop5mZPw@mail.gmail.com>
 <5ca344de-bc34-4a9b-ab85-f553811a1d9c@kernel.org> <CAKEwX=N05iOC4hmiyTt5OxjAsOfU7_V8xGfmK_RgUyrKtuyUTA@mail.gmail.com>
 <CAMgjq7DJwGCHCAchcfi2Kcu+XHx2YnKXDj53e0t2kpG_GSejkQ@mail.gmail.com>
 <aqgMCIOFi0dKx_6L@fedora> <CACePvbVMFA9N0nQers=sOnSXGbNhtNE0ewq47AJEH5Cr8imQXA@mail.gmail.com>
 <CAKEwX=OMYhUs3tt7jUzEzxsOW3yA2JmzpwwxVBP2eZuHOFu=vw@mail.gmail.com>
 <CACePvbUMjRgK=dQzLjECgBXaUtQSPdAnBXL1Y4=Kh5d15swYvQ@mail.gmail.com>
 <5c8a2b7b-b76d-4bba-92e1-ec3d66794273@kernel.org> <CAMgjq7CT2O2VHpwZazugQRopi4grF+T4oOxZznoAGvy93Yjh-A@mail.gmail.com>
In-Reply-To: <CAMgjq7CT2O2VHpwZazugQRopi4grF+T4oOxZznoAGvy93Yjh-A@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 13 Oct 2026 10:01:24 -0700
X-Gm-Features: AclHuK9oUwgVv3XRRzK2ZGaoq7d_UoCd4WV6CrUoKrvhZqpz39_1MbDWEVKEMOM
Message-ID: <CAKEwX=N8qKhhVUR2Xd-UdtE45g80Ges_+BU_sCc2MzoVS4d4ww@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Kairui Song <ryncsn@gmail.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Chris Li <chrisl@kernel.org>, 
	Baoquan He <baoquan.he@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Barry Song <baohua@kernel.org>, YoungJun Park <youngjun.park@lge.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
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
X-Rspamd-Queue-Id: 19AAF40005
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: hximjhh446xtd4xru5539arghuf811i3
X-HE-Tag: 1791910897-24683
X-HE-Meta: U2FsdGVkX19/zP+xYRWZLNnD0cOtEFVH5eCltXPUw0oPONd8TaO3LotddjIezSgUhfqlQ1v4QdHzzFePoqMH6IO6+PW7ucBfn9Vt8yJU/rToupzyQvop4kd0oXYoCMr1mQl1OzUv2pT4efdMNHQuE3iuCwVy4Sc/VVGkvQqwJY8S79Z7mzvPvEhKY6wqQttLzR6p89UhOgf+r+g8nnLC0gwyyC5/VcXzqJMylB2+iIbOf+updD+9ZGVB6SXbwlxo8/1aUNeKVOxLcSAo0O5Z62Igz4PBw+UzkIQ+C6/e2jnxHyjUL93I7EBhaUi1bHctLBGGD7K0hUJEQnkIg9dJtj9cse1DRKC5UdAFRUTD+3NekJOnZYIOUQKaqhtqOsyXq/3AxHMe0bAqVcwBdyd0vQwPeEmQgFPzw08LiHLABr20Mz71POTrs3m8WqEWRP2awXYa1r+UB6cpScofCtUOwoaGnGDb7d9EmxYBPtDHyPF0AmncsMC9bcGKQTy+nN72GKvJnjJ4LX37/i/35EtJGM3nXS1Ksqfzjlt6iMXYCNWcC4KGw5Q+iRVmPU7um3wicPC7aGNYFvbTEYHT8BlgzcGXVgbeeI9i+O6/JpQBDSSSxd/vGIbR6cov+YffX1RazPHUS5YNnRa5vlwp0y/RVPE7yQXcJeiGtuXCcGtkoNBTIoMNejoH19AQjnWqH+yPljOJn5ZMOExHRuRQ9NewDQ0G66j5dekWq19YhEh4a8JJfx6SG1N6EqIfOgvN7mHCXl/KrglHoeA5p1RBkoRXoUG7CE1r80nHNlM6BLWurTRj+14Jc9qMZLJ4HR0SQAuwwyLcjlIydPSmBBq6MrXyOsJYmxfgJ5WUUm7YO099AwPoQMv4lfu60PwdUSblSTIuzYUywqV8PvM80whfzLaJz1v2e453J5NQRv/EHlhn1P8ar+Ddv8qeXaxgbkmvCr8C/2l51TTWG6JABiG7q67
 A40DUoRR
 5W9qZqVoJTXyfPS22XnhY/+0P/y7Lym06FWv8ekK7pwPumErPy+ThWTlWwFROdbulyDPdK74OHrO+ir/0qXSTMRGDGwlxBwY7m774RBHbGVYLiWEFR6TDlB6/LOsz2UfbfwqmaqMXldPMbzMnPQCl3UvKfBCddiobQrh8QWr+hjwpNhao2sKtIrv5gptfamtMQqTHNSu/11rBPAk3+jYfTn31GHxZkS+JB5OQ5l1wvZ1zfuWS19IvrWRG+Fi2Nw6cSvI6Lw9QYfbvVlYphDOOfuXYwT1PWLk0kph4eEQCp/5/QQlVLlKr8rWZEs/gkrI3M7P3KcHk8/n3HOEiSy9N9f4MtOuxcT+XXBikmwqM7rocpUfGe5OeCs1ikMplx9S1Zrf9ELq85YQCMG82cYvba95YUGmjz21FZWgj0X35nT6zptc2OkxR9oSZ9qwSxrpICtRjHj5RsgsyVLhrGKUt8cFiojdpBxNMLsZKuJ6ixZeQGNpc9TdzxD0XrlWKJuA8Q0nblhnPcr+u1vXf1NcB7uLcXwzvE6qcxkDY3nwY/3Q3AEB2mGnhkJp3f6aCk8Uj1wsG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 13, 2026 at 9:59=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> On Mon, Oct 5, 2026 at 8:19=E2=80=AFPM David Hildenbrand (Arm) <david@ker=
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
> Thanks so much for suggesting this. Sorry for the late response; last
> week's travel resulted in a lot of piled-up work for me.
>
> Both slots look fine to me.

Hmm let's push it a week. Johannes might be out for some personal
stuff - I'll let him respond with a preferred time.

