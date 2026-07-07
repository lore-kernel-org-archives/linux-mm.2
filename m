Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3FCFC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 19:32:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD62F6B009D; Tue,  7 Jul 2026 15:32:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A60906B009E; Tue,  7 Jul 2026 15:32:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 901486B009F; Tue,  7 Jul 2026 15:32:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 54AA36B009D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 15:32:52 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C10D8140534
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 19:32:51 +0000 (UTC)
X-FDA: 84962978142.20.644B313
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 523D91C0004
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 19:32:49 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=c5ElvzbZ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf18.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783452769;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UXZp/HypJus1dyeVVJpONiQNeq38HK6Hd4EzEcMoqME=;
	b=xjSvge9tbv5o8Q+fOTLamKh5FWOUJgg44xYRjzvC/gPQ54GGJFJK8GdqRce/lyRWRtFo4V
	FKntu4zcKocgaeXMgZxOi33UN226TFMXr5Sux5m+fSjn3JvIcPkpQrPIMF5UJ6I8aixJEJ
	IfaYqhHhtf4hjNxmwO8SZpf/5uObGLA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=c5ElvzbZ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf18.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783452769;
	b=c8eMWyUMG/DwhqaQ5RIQhr7LXevEZ/+0gUjcItxozVxAgxcURGH2MCgEx0S9Lk8GEtxhap
	ZV+61dStu0Hqr7SjRaHH74ryfWq3MsiYiqlYaIGc5TTWnhI8kfs7Axda9PD/3lotbe0jZA
	t/21pnZxu2OWqoh1l5eOnEq8yWWIK9E=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783452768;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UXZp/HypJus1dyeVVJpONiQNeq38HK6Hd4EzEcMoqME=;
	b=c5ElvzbZGmQpwIrD8qJVocWYiss+MOuUsGfvH8r6wsSdJQISPZBelx+BBG4lYhUFGCxi2r
	/ZVIYDhDuxxmQ5GwY3dU4kQKaJGRMoTVRiCg9XfonVXrFqTdMUr6SIxxI4Gu9EUPBt7oTe
	8YQX/qqYVLbMtHkP7AGJTl0pOYVWd18=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-563-JxRgmp4NNCWSGtv85wq8ng-1; Tue, 07 Jul 2026 15:32:47 -0400
X-MC-Unique: JxRgmp4NNCWSGtv85wq8ng-1
X-Mimecast-MFC-AGG-ID: JxRgmp4NNCWSGtv85wq8ng_1783452766
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-493c1bc7a70so43641875e9.1
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 12:32:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783452766; x=1784057566;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=UXZp/HypJus1dyeVVJpONiQNeq38HK6Hd4EzEcMoqME=;
        b=mwjagvnnnjtv2MATyfymZRPghi4c+0o6IHOrn4SQ1jnW0A3UFas1i6XChlpbQDtZSK
         bhnCgBPOLanHbQtXEnpJNm8hQwcY/0jyApG0YVgsXm2SOXJvTFqWQV3peyPhyUpBNIZD
         1m6l2LkPXTDoJsDc09JYHiOF/g8QSyArAQ0tGEPeBAKlmktIw5G9pUdd0hUb7PXfxG3f
         BqXMcCLkg6/Xc0xmBjuaILDSX1JDn80L5ITPQg/2wkvVhdd8XgNZB6wvJII+aq2c67li
         qU/tHwhmSefNP19PPC6XYbvnsfw21pHCD3Lglg1cAKxNEgpmjcB7smhblXT89CQ+0ta6
         DVwA==
X-Forwarded-Encrypted: i=1; AHgh+Rrdsrw/Q6ii1hqNY6yrveyv/XiQk6o+Y1ctSOg3afzI4DEzZFVH4IDl3Y/nurt7byUQNRD+KzY+2Q==@kvack.org
X-Gm-Message-State: AOJu0YyptKpEJOdGyAPsFs3YPH6TnQs/701+kcMr6N7ISossMRKRngOa
	2gbVAN9g56eQAaoS+zE4Cj7L+qmfculkQwU9HDXu4CZdV+mRuj5tIhYgcEBHUeGgxKh4jS1h3B+
	4MZhn0Amgl0EJibDWH2J0M3qA8R01cgCgje5EpuJdN/t+K3C8p8iS
X-Gm-Gg: AfdE7ckyGyXRrVyj3gpnvZf2SqhpwudWgcJmjYBcWuBYcaCeh7m2TkPulrbFs4PYyys
	pvwXk3aMy37NQhV8l4oCTRi6Mk+ISnmR0uy009icW3mH9h4PwfSMEI7Pmjj4FF9wJuX3jcL1B8e
	2kSrJ0uHN24Znn2Rh77VJKdZUItQRxdHAQz9N49sUBLDW117IY/AE3p+R+qpIOgljOIdVXXCIcC
	SjbjefQuJ0zsHzLSOAl0oT10YZcTkjKhkTPZDiWl1lLoJqsgkBPXqGGKPSGIaX5PYvp6JxVDXIL
	3GF8vy+qfhmLZHBCux9EIwzF2csNy5Qg5pMIs+Tx5yajqcRn+7MXRCZW4YHNn9ArlgM2N8Irs3s
	qQnINmxW30bXJpC7Gg9JRVHnubXPiFBnn
X-Received: by 2002:a05:600c:8286:b0:493:c412:b806 with SMTP id 5b1f17b1804b1-493df04241amr74639955e9.0.1783452766057;
        Tue, 07 Jul 2026 12:32:46 -0700 (PDT)
X-Received: by 2002:a05:600c:8286:b0:493:c412:b806 with SMTP id 5b1f17b1804b1-493df04241amr74639615e9.0.1783452765524;
        Tue, 07 Jul 2026 12:32:45 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-68-31.inter.net.il. [80.230.68.31])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493e5a572c3sm2863305e9.1.2026.07.07.12.32.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 12:32:44 -0700 (PDT)
Date: Tue, 7 Jul 2026 15:32:41 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Sourav Panda <souravpanda@google.com>, muchun.song@linux.dev,
	osalvador@suse.de, akpm@linux-foundation.org, liam@infradead.org,
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
	mhocko@suse.com, mhklinux@outlook.com, fvdl@google.com,
	gthelen@google.com, mike.kravetz@oracle.com,
	pasha.tatashin@soleen.com, rientjes@google.com, riel@surriel.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [RFC PATCH 0/6] mm/hugetlb: Dynamic, NUMA-aware HugePage Cache &
 Free Page Reporting
Message-ID: <20260707152755-mutt-send-email-mst@kernel.org>
References: <20260707064235.1386552-1-souravpanda@google.com>
 <9624988a-366e-4884-9408-3f3b88c27290@kernel.org>
 <20260707062428-mutt-send-email-mst@kernel.org>
 <b9a48d89-74f1-43d4-b7bb-be988b6855c9@kernel.org>
 <akzZr2jfJ0J8zox4@lucifer>
 <20260707095843-mutt-send-email-mst@kernel.org>
 <ak0xWgpJPSaNWPsl@lucifer>
MIME-Version: 1.0
In-Reply-To: <ak0xWgpJPSaNWPsl@lucifer>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 0iPbh9x5SOcOUq369xWk0oImUYDaxWae9xVHNtEFltg_1783452766
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 523D91C0004
X-Stat-Signature: nmmb6ij4ccrnsjjoxf5emfu5qk3i5cyr
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783452769-427960
X-HE-Meta: U2FsdGVkX18y+ueiQzrYrpdeX+1bENIm8FH16nE4z0FD/crgC0/hSp33xNZGUztvPVP4yl0bkwz16wBTtqVo7xCCS2G6PfgOIaesAPIgPorA9YD7/fLgwM62JY5Jg+C4wBMxjGdWXJAxurvLdl+anB09PnKTExHxmeYG4Eql9iCiAQAkh6Rutu9WBf3GCtJFaCwp1gHW293e2rnLz2OrTrVldHQ0RyPydGHm8N1CMBz/ITt3Z4ZbVzH2EYxrBwUpQmEIKkExKJGMU49+WUvOeStWUqBIMSwx1CAblEDpY3kgzM3zKYgjwSEf5D9tkjtg5ZrmwtavXWNynvZJH2l3lO8dnr7jOkz9n2A60F/HOSgvfRV1xb2Os1CHEnwanw/EVlnQ+ntQlpK9Zu2aK4H0lteaWc1idBbRvgvgHpu3jE7qhw0XvB+ZcEBsD+SnR74JXAr1PLb6DDQcpSVCpuzCmmeypcqykUHDzkhKZ2vp6SefGCKrariHNYir2O1BvvckUYB/9T87cf0u2IIl7yCLdHvz9i0wYfo5CV6lawsp1BhrXs2wwgVdM++UTNdpoJwXd+vxsidJt4ZZx1cZ6trpoVcOJ2cbfWn2DBmW/MoBu8XNjbJ95G/ymXRyPrUlK1pBZoSDiIgjbZhOIlZgEGuWvWhyVPfZs3giyap0BnnGz8DjUrtoi6oNkt1eV6kDog/6yRRkB8xNCJNdComWoIDTmrLPozd7kcSceu85kE7+akntz8fSpdhrMGV5SaUCzx5K1vDJO/5eCYFMm8y1RDoVGtHkjW6y7/xotQWauhQORYJG7yhpRpdhuzttbTDZGAbPemd4Y9I0NESLLvAMQIG9dYPengSyzEX7Q16h4PeOTwVaRVrlMBQoVCI85ONRcKMmyltZGhom20caOQpyR6Kx+eAB7jMaNQQtCuJ8OG3BpVRXHnk0POT0GxW6w/PewdwtXi0VGmiZy/P211xJbDr
 H127kEmi
 70rwEfXQ7dMJ8T0Wh6XYNb1sK2RflGC6l0SyPyss68Kbt+Wlf7iL3HhISz6tofneuYhcBVRwSM5zOvEI1McbtsvZToDLMGUUTplXL+jwihn5DHHLn7sD5JsUldyLFk4mH8X4ANSWYnh3CCAzwZBwpRK+57AxejSK8QHlE2o+areeJHEsShrJ7uo8AfL1s2C6TZ/gCv+6shMIsorIpNPeTRJykbx9eOtaT9iujX7GqHWARHGLoMWV+PlqrJ0husii0ZbSRaA4u++TdjsJ4sAuwnJXZixWnDmd++tZwOYl4BGlbAGnO6a659amkfisapMVDvt8719h/rrqlAv8rR0QGJd2at+ukLyw1NWD7wURQPo2zLv4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 07, 2026 at 07:46:28PM +0100, Lorenzo Stoakes wrote:
> On Tue, Jul 07, 2026 at 10:01:55AM -0400, Michael S. Tsirkin wrote:
> > On Tue, Jul 07, 2026 at 12:06:34PM +0100, Lorenzo Stoakes wrote:
> > > On Tue, Jul 07, 2026 at 12:28:44PM +0200, David Hildenbrand (Arm) wrote:
> > > > On 7/7/26 12:25, Michael S. Tsirkin wrote:
> > > > > On Tue, Jul 07, 2026 at 09:29:07AM +0200, David Hildenbrand (Arm) wrote:
> > > > >> On 7/7/26 08:42, Sourav Panda wrote:
> > > > >>> Overview
> > > > >>> This patch series introduces a dynamic, NUMA-aware HugePage Cache,
> > > > >>> backed by a kernel shrinker to safely return memory under pressure, and
> > > > >>> integrates it with Free Page Reporting (virtio-balloon) for HugeTLB,
> > > > >>> specifically targeting gigantic (1GB) hugepages. The goal is to solve
> > > > >>> the tradeoff between allocation latency and memory
> > > > >>> fungibility in virtualized and heterogeneous cloud environments.
> > > > >>
> > > > >> Hi,
> > > > >>
> > > > >> in general, we consider hugetlb nowadays to be mostly in feature freeze, as we
> > > > >> realized a while ago that adding more special casing on top of something too
> > > > >> special for all of MM is only going to hurt us more in the long run.
> > > > >>
> > > > >> We want to have less special casing and less special sauce, not more.
> > > > >>
> > > > >> Now, there is nothing wrong in making hugetlb be less special, by making it use
> > > > >> more of core infrastructure etc.
> > > > >>
> > > > >> But optimizing for surplus hugetlb pages by teaching hugetlb about new caches
> > > > >> and its custom free-page-reporting support rather looks like the wrong direction
> > > > >> for me?
> > > > >>
> > > > >> --
> > > > >> Cheers,
> > > > >>
> > > > >> David
> > > > >
> > > > >
> > > > > It is currently bypassing free-page-reporting completely.
> > > > > Making existing free lists not ignore free-page-reporting would
> > > > > maybe considered "making it be less special"?
> > > > >
> > >
> > > You have this completely backwards.
> > >
> > > You're advocating making hugetlb _more special_ by duplicating functionality that
> > > core mm already supports.
> > >
> > > I mean:
> > >
> > > mm/hugetlb.c                                 | 590 ++++++++++++++++++-
> > >
> > > Tells the whole story right?
> > >
> > > The whole issue with hugetlb is the very fact that it's a parallel
> > > implementation of a bunch of mm stuff in its own little world.
> > >
> > > We make it less special by mm/hugetlb.c smaller and smaller and implementing
> > > what it does sanely elsewhere in _core mm_.
> > >
> > > >
> > > > Depends. We don't really want an orthogonal implementation of something we have
> > > > in core-mm.
> > >
> > > Yes, exactly.
> > >
> > > Feature freeze means feature freeze, not 'feature that core mm doesn't support
> > > feature freeze'.
> > >
> > > Hugetlb is a poster child for poor decision making in mm that has left us
> > > saddled with maintenance nightmares because we allowed 'just one more feature
> > > in' (TM) with little to no thought to the future.
> > >
> > > And we've all learned from that and don't want to repeat these kinds of
> > > mistakes, nor make existing mistakes worse.
> > >
> > > And work to improve hugetlbfs and make changes like the above are VERY welcome
> > > :)
> >
> > Fair enough.
> >
> > > Laying a foundation for hugetlbfs to be more of a sane mm citizen through rework
> > > series is really the asking price for stuff like this in my opinion.
> >
> > Lorenzo, do you know *how* you want it reworked? Could you write it up
> > at a high level?
> > Because if not, it's not really practical to make it the asking price.
> 
> Michael, you're an experienced maintainer, I'm surprised I have to tell you that
> the burden for that lands on the submitter.

Oh sure, "fix bugs A,B,C before you add to this mess" is a classic way
to actually not end up with even more of a mess.  But I usually do try
to be explicit of what are specific issues I want submitter to address.
I don't really feel figuring that out lands on the submitter.

> Nor does a no from a maintainer require an alternative be provided.
> 
> In any case, I felt I was clear above but to reiterate - do the opposite of what
> the issues are:
> 
> - Implement things in core mm without it being treated as a separate entity.
> 
> - Reduce the propagation of if (hugetlb) { ... something specific ... } strewn
>   through the code base.
> 
> - De-duplicate the appalling parallel implementations — and not by pulling
>   things out 'just for hugetlb', but by making it ordinary.
> 
> There are a WHOLE HOST of issues and problems and difficulties with doing all of
> that. But that's just the reality of it - again, the burden of figuring that out
> is on the submitter.

Thanks, I hope the above is specific enough for Sourav.

> So the price for entry is high, very high, but that doesn't make the no any less
> emphatic - we're not going to accept the problem being made any worse.
> 
> Note that I'm currently working on reworking the anon rmap which is similarly
> problematic. I didn't get nor expect detailed guidelines on how to do so. The
> burden's on me, and it's equally a high price to pay.
> 
> But setting the bar such that the codebase is as good and robust as it can be
> both now and in the future is what maintainership is about.
> 
> Thanks, Lorenzo


