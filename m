Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EE9FF9D0E7
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 16:35:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 604566B0092; Tue, 14 Apr 2026 12:35:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58E576B0093; Tue, 14 Apr 2026 12:35:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42F116B0095; Tue, 14 Apr 2026 12:35:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2F1236B0092
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 12:35:38 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D14331A01B6
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 16:35:37 +0000 (UTC)
X-FDA: 84657712314.06.D30CABB
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf23.hostedemail.com (Postfix) with ESMTP id B2C63140005
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 16:35:35 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="KIh2fr/C";
	spf=pass (imf23.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776184535;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fQleDbjaYYUSGdpynlKDYhzpuJpOjymZUKR/yJ1TCio=;
	b=pQCZzyBgbgZmTlrAi10s0uIXtAC4nRIt13YcaxCEcWbwPb+wLffH1YSyTCOPOz3VUUrzrQ
	HKt7U/2F6wg9qaZWRJWLTYtffTKNZE9AoNzRq+xXUY9OmCwuTqb3K8oZ2otl1V/9vCdu5c
	+lZCpzzUMEfJObnVEw1npGPyVb8OIQY=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="KIh2fr/C";
	spf=pass (imf23.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776184535; a=rsa-sha256;
	cv=pass;
	b=shFM16ydHhYFF/cTuXNPqLuVdnSu4mIixcvfY8WxpVoAyhx+gioDHyJA6g8fE0OCv1DB5A
	hc/uJSv2KtadEh9VgJhTWuM1+ttlTr/xwgt5obqFlT5ahGrWSQPTvB9sxVdmzhtwFfZKW2
	Y+MZfr2+YnNALLIM1S766rWrReTaouc=
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-43d75312379so1706509f8f.1
        for <linux-mm@kvack.org>; Tue, 14 Apr 2026 09:35:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776184534; cv=none;
        d=google.com; s=arc-20240605;
        b=XDQv4j57Lh7WvCYrmc4zDZs3YdXXFvfi4kLLvLC8um6SjMDEk0h4xITyvCbiM5cRZD
         hLPw83uX9DpjtvoJtm3WjuDS4CvG05Mmu3WLQwGp1of3eO8ijFIUKY4YLCh2fAdnD3+q
         zPXtHuUJJaX/vXl/sZJF7Q8VU7NdHn8/AScmQOEUeO7S2vJIfa7RFojk/ZcWkkTILe9y
         tyhhTknpIwybLiOzYutlkfRWclTBGEuKR8T0m9n20abDVgk/WvgbML6gxcosRNyqADU5
         CsC1cw3xH9pKW/hHEqjI4U6GxBiXDx2ohg3GirjOkbfhLo3GLFI28WabETzxqMxxmK0p
         9piA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=fQleDbjaYYUSGdpynlKDYhzpuJpOjymZUKR/yJ1TCio=;
        fh=VbXX379yIx5Eyq6qhBAFd0XM8U0JrN7IIHjY3UjdTx8=;
        b=DQ7erIuRQm4b90gXtps8wwByIG93U9kE8n2t56ZWAkw23bOnQlpFaTB/Ze6N8adDiM
         luwT0db9Kl8X66QREt5iwYbOvgcbz0ngFxSrxcvVipdhguwIcj3AdBiLaPSOWxpSbxK3
         mbHu+nMvZUP49WmWSmtE0qVNlntRsz1+liw92FH0UVS3mZ0qf9u83ptRSew1YpyXJJlU
         Kg+uD3cFcElCobmpmJait1EideCEMQ+BmSw2wf0NcPQHs/dqGPhuZWY37a9AvI/cN3h+
         896a8jReF1MPS7od9vCfqd74oRjpqpHPjXK3YZQgo6v+fkwcPsYNiqBKOgbJcppTmn2M
         Uxtg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776184534; x=1776789334; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fQleDbjaYYUSGdpynlKDYhzpuJpOjymZUKR/yJ1TCio=;
        b=KIh2fr/CKFaIXk8/hIczSbE5RBGwIeLEGxvlYdjf4u+0w1QC2VMbAdWe+orAvo9r4f
         OwpphaRv+NkqR3LGvLUT7U0mTPpoTKxlesyz3GJz970SjZFIlttEqHkllVHPu1HJvHNl
         u7qdkOeCUCHWY/HBr57kZJgDqRrI/SUOhxAPiO14bGf1oG3SZLPFc8Ze1lGkSYnzS8vI
         iSniHGkl5OXHgNOHOJ8sVrDjS2R9Q8jW/4cUWvmSwt9TicJ2QIf5J88tpm8/5JyehMhO
         KsA9Cjf+J7o2/eKf54xQQZ23XS7hwe8clQD7RiesOX+bO7oJyWrSbKojtNGu2erpz66M
         Hujw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776184534; x=1776789334;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fQleDbjaYYUSGdpynlKDYhzpuJpOjymZUKR/yJ1TCio=;
        b=K3LxojtGdgJBDRB+VDRpIxsUvicb9huftt5rxrsfJprp6fxLtpVNU5mqd3QW4U547b
         7nY/TJFoiSLpuclpCmFQQVNozeBBxT5CPQL3OXfhp506dAl0JHE2tY4li40+er74MZUi
         diGVsta/wVvh/OSuZLsIstr/FOYQsjQzTralWmNh2+j7hS0RHbqrsgRAc/ms/ANpiDF4
         EGeuJT5+LWLaMsqMvSp7rZ+bJKWGAgJTbW7flcRcp4ctfZUe7gAs/KK5dkgCPItkk5gI
         vSQCt03usB021n3C/SlFuZhF+3ToL7IqCUoCPan9Lk2lpWSzEzoo7hhssEmMlOsjJ5k1
         SZCQ==
X-Forwarded-Encrypted: i=1; AFNElJ/ZXjfqqjTfXX2t7DzZMuxVmIdA10f07wn+oofltJgYvxX4rIyLl7Mb417p+BpAkVkf+7v3mMPffQ==@kvack.org
X-Gm-Message-State: AOJu0YzHkTAzhJ+lah2R9cseVkd2fs808Vyw8tmj9xo/2pV3wem4ty7J
	Y0wizYvc0KDEZCO/pyp/gL5JgqO8JcTPQb+/LSiAIlrJul8FS+Yn3FEqK+EGmU09/4oy+V6PjRr
	Pmi2zcC8dUW4525tC69Ku1QukPVvR65A=
X-Gm-Gg: AeBDietNqWhjcOSJNDbb/nPip+iIAxsRClABEL1K8BRH08rdh8MnqpQ78QTFrV/OzAr
	67PPOF2/8FTbnA7BeqxDo6lhDP5RNMn6amShpA3/CzkuTQZbLGOYgMFPjCkUAW7MKM/lqFryQn8
	Nzu7zaOOwnI4U1E+ItYjletrVpALG2VURtWI2h//Hf91aNy3AvCy6RawCdGxRXircGBKPJelgYi
	/LlBKy6UgylNkls84hRUh+BeD99aycXBGPAnG1dL4Pw2kqmxh45RPISTCp4ccIB3sIfd0/8pw//
	KwNwxkvRah0VSAD/EBekxDyCdTXCDqgUdYdtZyc=
X-Received: by 2002:a05:6000:25ed:b0:43c:fac5:d382 with SMTP id
 ffacd0b85a97d-43d5958e3b8mr30561697f8f.12.1776184533792; Tue, 14 Apr 2026
 09:35:33 -0700 (PDT)
MIME-Version: 1.0
References: <20260320192735.748051-1-nphamcs@gmail.com> <acQrQYHJgqof0yx4@yjaykim-PowerEdge-T330>
 <CAKEwX=NnHxpQKp9qBg2=r_euyjgxw2nHXjbgof3MymHTgJmRAQ@mail.gmail.com>
 <ad2rYH9tUPthHFoj@yjaykim-PowerEdge-T330> <CAMgjq7BO6SLZPfNXDh1F-7RAOqDAfqMQ4PM=qjAq1mCsWyD0LQ@mail.gmail.com>
In-Reply-To: <CAMgjq7BO6SLZPfNXDh1F-7RAOqDAfqMQ4PM=qjAq1mCsWyD0LQ@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 14 Apr 2026 09:35:22 -0700
X-Gm-Features: AQROBzD5xGWfOWAJA-1nI1ObWe4VBmguR2Q9Syvbquy-jm8YJp-HL-l7rnLn-Mc
Message-ID: <CAKEwX=NtcGBnDpSuePqfK9G4jACC5gU95-69A4z5JzKkYRq1YA@mail.gmail.com>
Subject: Re: [PATCH v5 00/21] Virtual Swap Space
To: Kairui Song <ryncsn@gmail.com>
Cc: YoungJun Park <youngjun.park@lge.com>, Liam.Howlett@oracle.com, 
	akpm@linux-foundation.org, apopple@nvidia.com, axelrasmussen@google.com, 
	baohua@kernel.org, baolin.wang@linux.alibaba.com, bhe@redhat.com, 
	byungchul@sk.com, cgroups@vger.kernel.org, chengming.zhou@linux.dev, 
	chrisl@kernel.org, corbet@lwn.net, david@kernel.org, dev.jain@arm.com, 
	gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, jannh@google.com, 
	joshua.hahnjy@gmail.com, lance.yang@linux.dev, lenb@kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-pm@vger.kernel.org, lorenzo.stoakes@oracle.com, matthew.brost@intel.com, 
	mhocko@suse.com, muchun.song@linux.dev, npache@redhat.com, pavel@kernel.org, 
	peterx@redhat.com, peterz@infradead.org, pfalcato@suse.de, rafael@kernel.org, 
	rakie.kim@sk.com, roman.gushchin@linux.dev, rppt@kernel.org, 
	ryan.roberts@arm.com, shakeel.butt@linux.dev, shikemeng@huaweicloud.com, 
	surenb@google.com, tglx@kernel.org, vbabka@suse.cz, weixugc@google.com, 
	ying.huang@linux.alibaba.com, yosry.ahmed@linux.dev, yuanchu@google.com, 
	zhengqi.arch@bytedance.com, ziy@nvidia.com, kernel-team@meta.com, 
	riel@surriel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B2C63140005
X-Stat-Signature: 53w71hoo3p9mqwi783fyzsn6z5d8bnks
X-Rspam-User: 
X-HE-Tag: 1776184535-398233
X-HE-Meta: U2FsdGVkX1+QqoD/V+ofs/3J8s4Tcw53hptx48A2mHBwUfCWeA7ZoBzp9qg+nw3FZ6RL1De9D5KteAi41XDb7Y25EPRk5GW6yDT3GSKqE49VL9xIcYN0bkmoj3pCI2o63PsMgGRUMedZkxeVc9mXdOgQ8eFvvLCkjp6rKN5XedKDB6g+xCtL9YHuU3OatprtQfKiYq1W0jmAUyj3o6FYbcspJ0WwUXz0paDTKzn/NUsFBEUZNcJc0CjA7Ow4zoAK27FtwCAcznHNWs8sSpuGOGYUMIHHL/+p3cCi55iP8RhQ1OTXCBC20/zfWOL2SVXzDXF88JMn1EVqmfL142Io7K6XrKW31e7pjLH1GBUL5etfShV260h/BbaXDI7o31mewFjovyyE/sA6bsjXb0KTAlHCDxlmgZ6BYdCFod456UxxEa6sJRKVOwr0XkPhUkKpeIg5zr3nQT8raCWBWSOmgLUGopT68+i6j9zMJGTESYPwNckAQyXO31YCCLxi6BdCq7iLsMyWx/9FBrj7iqr0ia4WrbIG/WfYjznGpyR+SWvEoiGtUOTk3C2Qo8IKZLAQp9uJWXbnd94AzSFHzmDWVDwTTUWqn9AWVKmQcj+eKDKXQC5BA3fO2nDRgA6tX1lJk390rCL9ZNRR3I3ReSWxRysLp8C0oNHnFYvDTBMmXFqlUhp8Uq+P8GQkG1nOyCu/Zbx73gYaZRc1pTqI1UjBV6geRDfnGXABANc55WO7ezWIBc7v0q5g7Db0W7d+oBOGAUi8dixBxRnf+HikQ8yKFDzwqRo38gptqNz/aQg6ncPXNM7lMadClGxowOcezB58mlygeC3OlreeRqg8FbKD/NpvnMeLY2WDRh8Mq2qzNIH/Tf9KCVoHJb4GXGR+x9q8wYzEQ/YpUXygjWvou2Rmdp9G5lKBYV18Ug5osJlGOWveQQ0aq49jbfmfL0ut+NiP7nQeeev4be1fZ300vZ+
 MvK+or/S
 DUrgloZt8ejVKvZdbqTbU3gCEpCEHl4qxluLHyBRHV5nQsoxyC2n0abSmPcvFwEG4KncP2GscHE/57moQLnkiOCu/taNML7nwJ84TQgJAgNxCoH3EcsvSPpuEFlfTkdRpHOfRs74C7O7gixRyt24eQnVQx2AfyuKEfczA3PoehM3Ktrs6U94G6scr5e72Ej0zX7uO/jF+eOz0imXflIRAX1FymbNnEZqDjovgIreYBsE7+SIuvrYzBq459sQWQOBfp8/9zWdDdOuOH2SyqWcTNrX71lXUvzWk1zXYN1CMiWmDDwIro7w4y4y5ExREQU1NZSut8xLhqmUX9r3U4OT5MVXtnnFOEm96XoHwnk7EC2q1HmNvRfwGRVF5D4UKU7m1cFRVyb0DVgOPBFB1e0kwDyUtwcPzpWR60t0l7aXJNQBpgFhA98WipzofN+SqM8+jweHEs6hxjhz6q9alEH0g/iRonDLbgWxSANfESXk1zDBz++4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 13, 2026 at 8:29=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> On Tue, Apr 14, 2026 at 11:05=E2=80=AFAM YoungJun Park <youngjun.park@lge=
.com> wrote:
> >
>
> Hi All,
>
> > On Sat, Apr 11, 2026 at 06:40:44PM -0700, Nhat Pham wrote:
> > > > 1. Modularization
> > > >
> > > > You removed CONFIG_* and went with a unified approach. I recall
> > > > you were also considering a module-based structure at some point.
> > > > What are your thoughts on that direction?
> > > >
> > >
> > > The CONFIG-based approach was a huge mess. It makes me not want to
> > > look at the code, and I'm the author :)
> > >
> > > > If we take that approach, we could extend the recent swap ops
> > > > patchset (https://lore.kernel.org/linux-mm/20260302104016.163542-1-=
bhe@redhat.com/)
> > > > as follows:
> > > > - Make vswap a swap module
> > > > - Have cluster allocation functions reside in swapops
> > > > - Enable vswap through swapon
> > >
> > > Hmmmmm.
> >
> > I think this would be a happy world, but I wonder what others think.
> > Anyway, I'm looking forward to the future direction.
> >
>
> Yeah, I agree with this.
>
> And I do think swapoff of the virtual space itself is also necessary,
> we really need a failsafe, e.g. a clean way to drop the swap
> cache and data, kind of like drop_caches or shrinker fs are
> commonly used.
>
> > > > 2. Flash-friendly swap integration (for my use case)
> > > >
> > > > I've been thinking about the flash-friendly swap concept that
> > > > I mentioned before and recently proposed:
> > > > (https://lore.kernel.org/linux-mm/aZW0voL4MmnMQlaR@yjaykim-PowerEdg=
e-T330/)
> > > >
> > > > One of its core functions requires buffering RAM-swapped pages
> > > > and writing them sequentially at an appropriate time -- not
> > > > immediately, but in proper block-sized units, sequentially.
> > > >
> > > > This means allocated offsets must essentially be virtual, and
> > > > physical offsets need to be managed separately at the actual
> > > > write time.
> > > >
> > > > If we integrate this into the current vswap, we would either
> > > > need vswap itself to handle the sequential writes (bypassing
> > > > the physical device and receiving pages directly), or swapon
> > > > a swap device and have vswap obtain physical offsets from it.
> > > > But since those offsets cannot be used directly (due to
> > > > buffering and sequential write requirements), they become
> > > > virtual too, resulting in:
> > > >
> > > >   virtual -> virtual -> physical
> > > >
> > > > This triple indirection is not ideal.
> > > >
> > > > However, if the modularization from point 1 is achieved and
> > > > vswap acts as a swap device itself, then we can cleanly
> > > > establish a:
> > > >
> > > >   virtual -> physical
> > >
> > > I read that thread sometimes ago. Some remarks:
> > >
> > > 1. I think Christoph has a point. Seems like some of your ideas ( are
> > > broadly applicable to swap in general. Maybe fixing swap infra
> > > generally would make a lot of sense?
> >
> > Broadly speaking, there are two main ideas:
> > 1. Swap I/O buffering (which is also tied to cluster management issues)
> > 2. Deduplication
> >
> > Are you leaning towards the view that these two should be placed in a
> > higher layer?
>
> IMHO the swap infra should be doing less, not more, so we can have
> more flexible design, and different backends can implement their own
> way to manage the data and layer. e.g. Having one backend being
> flash friendly and it can do this without caring or affecting other devic=
es
> or backends.

I think that's what Youngjun already has, unless I misunderstand his
descriptions.

>
> > If it goes into ZSWAP, there would definitely be a clear advantage of
> > seeing dedup benefits across all swap devices. It's a technically
> > interesting area, and I'd like to discuss it in a separate thread if
> > I have more ideas or thoughts.
>
> Just branstorm... Why don't we just merge these identical pages like
> KSM? Maybe at least zero folios might benefit a lot if we keep them
> mapped as RO instead of recording them in swap, seems better in the
> long term?

That's our preferred approach too. We just didn't manage to get that
to work (yet). :)

