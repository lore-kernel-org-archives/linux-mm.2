Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B71E9CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 09:07:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 269476B0005; Wed, 20 May 2026 05:07:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21A1C6B0088; Wed, 20 May 2026 05:07:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1090E6B008A; Wed, 20 May 2026 05:07:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F20E26B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 05:07:34 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8EA6F1601E7
	for <linux-mm@kvack.org>; Wed, 20 May 2026 09:07:34 +0000 (UTC)
X-FDA: 84787220028.09.5C267B6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 96067100010
	for <linux-mm@kvack.org>; Wed, 20 May 2026 09:07:32 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HBpj2TO2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779268052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v4NWBagxYzHasGGEcU79T5ijVXX4z2pUOQ5qYXZ7jJc=;
	b=xGvuJxmC01fYXpp4uqjvYJ5K69rm+srkGAR6TvtUFE1PcCBXWVdiDo/0mLNuSTGa1rpW0j
	lX3IKWIcxH1DkWVxZCrSEp2CSNlUWOU66qt2aRnIcjuRdXcTwh6ir0oBB88+mFO3lap5b0
	0r2UUvsjZFLVXd2V0+GNn+fGEPF9V7Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779268052; a=rsa-sha256;
	cv=none;
	b=bAkbO73U2Ip5i1EwKsFsvjLH84iV2GIqjNDnkVbKUdFr5XxECvS18vGbNHxKE3nHVToJ/z
	8XCxbXqP9go/7bp8g55/xDXF+LFhStDbIcNQjDTOioGWIyjMoWJLMvREBGWxD8/Psqxa6R
	LzxtrGp+vkOkeG93WpALnOs8o9rmq30=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HBpj2TO2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BFE3D445CF
	for <linux-mm@kvack.org>; Wed, 20 May 2026 09:07:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7BBB1F00899
	for <linux-mm@kvack.org>; Wed, 20 May 2026 09:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779268051;
	bh=v4NWBagxYzHasGGEcU79T5ijVXX4z2pUOQ5qYXZ7jJc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=HBpj2TO2qA5Oor7OHt5Ye/pMrVKsAa+tgR47UAhIhwI3yvvVE0YC6Uki3M1ZSwg9X
	 asyERscZ397Lo+0XizKdIs72Miu1IMnt3PRJZo3ougkZdBCWhlygkHaiUNzohh15IR
	 vAhXqfXC3iF2RbQvfZPdWAgx6KAPH7jkop0CvuXrEWN21u49pHn8RQZD1BwA27fuvq
	 Bt1H1Lj4ObEpuYoP93W/mda/nuhZ48Up1nhVyCOwnVaQZ1CLCPdw5a+spdcD5TWEp6
	 0QGlED+uyIsjRv5jN30SuEcKCOlN+lu8whLsgH/GtAV5SFLkN7eCCxHzB79FTYk8Yj
	 HlaNDYyigSwqA==
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-9125d2a4d36so311896085a.3
        for <linux-mm@kvack.org>; Wed, 20 May 2026 02:07:31 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+iryVDpXgNOCEj5MhH2Os2xUmtls5M7Mpgj7L4pYVCyxE2oiM2SMfdWsfA/sWkQTewaZo9eCrwtQ==@kvack.org
X-Gm-Message-State: AOJu0YymSTaNhg/CbzsBk9f04DvjO7W9ugXWf7OVViOkpr1OP+LMq7vz
	/oT/psf2pvYPimqrn5pqcOBHtG1O/ev9pc3sBbULLFvobU0ya7EvOC0r7OCBabCUdaKWPClHQ0m
	2Nf94gEbe3B+SycuDNRfzlcxfP1wu4+0=
X-Received: by 2002:a05:6214:29e1:b0:8cb:fd76:e904 with SMTP id
 6a1803df08f44-8cbfd76eac8mr35985186d6.17.1779268050694; Wed, 20 May 2026
 02:07:30 -0700 (PDT)
MIME-Version: 1.0
References: <CAGsJ_4w0qcYmukHqsyRd0jomoyYkJjOt8b-Cgp53BgP-8QQghw@mail.gmail.com>
 <afS_L-5XeWIldTXA@casper.infradead.org> <CAGsJ_4wk=SDtgin+84Ev2TamU-JFfmrg_SUay=-tcYmnFvK6Nw@mail.gmail.com>
 <afTpoL3FklpQZNMM@casper.infradead.org> <CAGsJ_4ysMcrmDLSOwBkf7qwCQrcDWeEMXkHDajTJFMLKUk0bSQ@mail.gmail.com>
 <agrWuDNGddNmvMFD@lucifer> <CAGsJ_4zqLfdWoTH9s7FFaqWWj0mESfikYgr7=GcV64qcuXrPxA@mail.gmail.com>
 <CAJuCfpE0WQrB3zJp9qn3jvn5DthS=ttpX7gJJvyEhA_BJGrp5g@mail.gmail.com>
 <agxbq1TxJdniMQT3@lucifer> <CAGsJ_4zxyZP_xkFCGWfLyXkqomrX6DNqyMVirk=aggtwB1zExw@mail.gmail.com>
 <ag1mk2DSJsiORaxK@lucifer>
In-Reply-To: <ag1mk2DSJsiORaxK@lucifer>
From: Barry Song <baohua@kernel.org>
Date: Wed, 20 May 2026 17:07:16 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zN5ezh9vvvQDQdMF2KuuDGvkhNjTZWc0y0Lsa-P4Aahw@mail.gmail.com>
X-Gm-Features: AVHnY4JPJjfMfRWu5irKuds8oTQCJquviUDQwK-7Iye_Xeif_N9I88YUISr9aq8
Message-ID: <CAGsJ_4zN5ezh9vvvQDQdMF2KuuDGvkhNjTZWc0y0Lsa-P4Aahw@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] mm: reduce mmap_lock contention and improve page
 fault performance
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Matthew Wilcox <willy@infradead.org>, akpm@linux-foundation.org, 
	linux-mm@kvack.org, david@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, mhocko@suse.com, jack@suse.cz, pfalcato@suse.de, 
	wanglian@kylinos.cn, chentao@kylinos.cn, lianux.mm@gmail.com, 
	kunwu.chan@gmail.com, liyangouwen1@oppo.com, chrisl@kernel.org, 
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com, 
	bhe@redhat.com, youngjun.park@lge.com, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, loongarch@lists.linux.dev, 
	linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, Nanzhe Zhao <nzzhao@126.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 96067100010
X-Rspamd-Server: rspam04
X-Stat-Signature: 1uhsb68bjwqay746akxwqp9n9pi5r79j
X-HE-Tag: 1779268052-508301
X-HE-Meta: U2FsdGVkX1/jaHHTa5aNd+WF5nnb4posT17daX11kggwoZ3myOPG62jgglL1RLNXYAWHJuiKT+lDc+vG1ZWPDEviAijTTSrPQmp12iBdaGLAWk/YVYwbGYrBM0+xC6+Shk983/qATBq3uSFMZsgpKjmeoQHElVuf0cgN2/l/FD6SivZtrDS1dVVGa+ByCoh1yK9CYBStzl4F5XNZprhVCc0Zd125ucAMKCX0VYeW1cVNgnMa6DPjxI+9Dg1KlavPwlvBb3FXD1xDIgsOtIzeareJNpS/K4NHUSnfrlABGjcAkG4J1QM+4WJTdObSd3PxnYzirY29BfC6edWRqUNKECq6GMGPUalOoCDhQS+Qe+1gRgyrMy5ssqC9KeIASQzCBT5lZZKYdQzDbbQJ9bIQmNPIz3r8fefMGAigHzUtyX7yxX0Gl9+y144lOiyCfq7YW/gaXjU2ItUGqwOudJiVvpXuX0Ia31VThIyhfkxAixfj9auSCx8JYwvjrZ8GrKSXHoVM/wzoMiW8TWFdIEghKodeeZ+3tarrPnvjxwFG17Znt3kaK20aaSXdiqgLlGgqT6cNnKP0WOldDiP9DlH730ucvRa5wieL7Rvkq7OtozrnLOBLrQvEoHJlfrgZnVDjR+SJFEyMjYugENz2nF4ubLp/5s7XRJt2lp38yisf58RVWwW6/fhiB8dqYCnyXhjrZ2jF5r7/wwvafgDISPOoYaFc2tDKEO9RHZiiMHO8/XuODdkoABCP3/rnZEeKoYIS+XJwStmoXoF1LsgFA3oRbYRu037X/hbRB7nwvnzAzwi/NVG90yjTnT0c5kuELzkwh71d3FwbkDz3TVnm7LNPJ44WjhoHazL2MaieVhWEx698p6lPWZ1TW5BIy/tC1CpIuoH4HpA6uf+X/Pmzpoa/Id/bdYfiGS4BDAD1e9DKZbXlzuKxX0eWtRDKQ2uHID9MgEHaeS5Aw79UkTsCtzH
 CXNqi9EI
 Z9YvbLpGUqh/uydZn6MJHBj5xFjlhvuo8YlGBZ+5wzvAk36Ufu9wX9J6uCKVx2hrM65pEy7FBtqumvfEXn2b+BD3v9agGNZYi7SExRMC98WZW9FWO2YlIMdn8GSXvi00U+YfGLyjacO+LsAiA3d6GwQcng4GstxgiYbWIJpwZqVgKWzogd/O2Ig5UBvSnHUFtNJ2p+nkB3FWlB4AKKkSv6vautbAeqzqD4NcFfI8pmCPnWm8oy6isikS668OYgFmlsLpnZxXZtImI9Qn+ahp+qXBGqlEFNLCBD5u1j1PFq85GBeKKmCwCcC82lJj/Fh98bPoLX550KnuPOx19RvB0Rjeg2szA+hyiv5w07ftYfuRYzgvgxn/BRgCPoAEydFbwkyHmg1vA9EgW4Co4/VRPTAjxwV8lzYxNNxm4DpW8SsMXhss=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 20, 2026 at 3:50=E2=80=AFPM Lorenzo Stoakes <ljs@kernel.org> wr=
ote:
>
> On Wed, May 20, 2026 at 05:18:52AM +0800, Barry Song wrote:
> > On Tue, May 19, 2026 at 8:53=E2=80=AFPM Lorenzo Stoakes <ljs@kernel.org=
> wrote:
> > >
> > > On Mon, May 18, 2026 at 12:56:59PM -0700, Suren Baghdasaryan wrote:
> > >
> > > > >
> > > > > I think we either need to fix `fork()`, or keep the current
> > > > > behavior of dropping the VMA lock before performing I/O.
> > > >
> > > > I see. So, this problem arises from the fact that we are changing t=
he
> > > > pagefaults requiring I/O operation to hold VMA lock...
> > > > And you want to lock VMA on fork only if vma_is_anonymous(vma) ||
> > > > is_cow_mapping(vma->vm_flags). So, we will be blocking page faults =
for
> > > > anonymous and COW VMAs only while holding mmap_write_lock, preventi=
ng
> > > > any VMA modification. On the surface, that looks ok to me but I mig=
ht
> > > > be missing some corner cases. If nobody sees any obvious issues, I
> > > > think it's worth a try.
> > >
> > > Not sure if you noticed but I did raise concerns ;)
> > >
> > > I wonder if you've confused the fault path and fork here, as I think =
Barry has
> > > been a little unclear on that.
> >
> > I think I=E2=80=99ve been absolutely clear :-)
>
> On this point sure, I would argue less so around the fork stuff but I res=
ponded
> on that specifically elsewhere so let's keep things moving :>)
>
> > We should either stick to the current behavior - drop
> > the VMA lock before doing I/O, or change fork() so that it
> > does not wait on vma_start_write().
>
> Again, as I said elsewhere, I think there might be a 3rd way possibly. It=
's a
> big mistake to assume that there are only specific solutions to problems =
in the
> kernel then to present a false dichotomy.

I recalled that when we discussed this part in my slides:

=E2=80=98For simplicity, rather than using a whitelist mechanism for
per-VMA retry, we could use a blacklist instead: default to
always retry via the VMA lock, and only allow mmap_lock-based
page-fault retry for specific cases such as
__vmf_anon_prepare().=E2=80=99

Suren mentioned introducing a FALLBACK flag. With the
FALLBACK flag, we would retry via mmap_lock; with the RETRY
flag, we would retry via the VMA lock.

Not sure whether this could really be called a =E2=80=98third way,=E2=80=99
but it seems more like a shift from a whitelist model to a
blacklist model, without changing the fundamental design, but
it does change where we would need to touch the source code.

>
> We absolutely hear you on this being a problem and it WILL be addressed o=
ne way
> or another.

Thanks. This is a bit of light in what has felt like a fairly
dark situation. I really appreciate your thoughtful and
responsible approach.

>
> Of the two approaches, as I said elsewhere, I prefer what you've done in =
this
> series to anything touching fork.
>
> But give me time to look through the series please (I'd also suggest RFC'=
ing
> when it's something kinda fundamental that might generate converastion, m=
akes
> life a bit easier on the review side :)

Thanks! Sure, I=E2=80=99m happy to wait and there=E2=80=99s no urgency.

Last year you made quite a significant contribution to the work
when I tried to remove mmap_lock in madvise. I really
appreciated it. Now we=E2=80=99re back to the same lock again, just in
different places.

Best Regards
Barry

