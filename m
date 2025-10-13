Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D55DCCD183
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 23:08:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 725388E00B1; Mon, 13 Oct 2025 19:08:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D6E78E0024; Mon, 13 Oct 2025 19:08:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C4F38E00B1; Mon, 13 Oct 2025 19:08:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 45A5B8E0024
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 19:08:13 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 49BD45A123
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 23:08:12 +0000 (UTC)
X-FDA: 83994631224.27.F8CBE37
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id 214B4A0002
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 23:08:10 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UwsZrgkO;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf15.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760396890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WsULGpTWYVJqyd+s2rzVYTRP+oWghbcs0VO7v3VHL6A=;
	b=ApQtDvCoNcJYDSuxdlZm9N6QT1jJlHsv/NSGIo6lCUtPO9DGMs4RtRcT8GDXM16z0v5Y6V
	8k5jbgR+7kiJFfiXWmVChhjT7YkEd9d98zToDXHpKQjaSRhSDMTseWsXTQpt2dm78AB2k7
	68yU7O6VKpo8fjITs0+yKVzFu7Br97k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760396890; a=rsa-sha256;
	cv=none;
	b=4jxcyvaWm+Wsz7S52OScORgVZW9gvXQlMh78TF4fZdUaBR4qX+ZgJt/7KjDOtqtpDp6vfJ
	E25YWUgvRlwuADjDoCLlNy2ywqSLpKX5QZc0vLdVvpyxEyqxB/8LDczMDx21hjiXkMB7Fa
	p/FvV0eAriLEsJSHkKt2Fd3DJrDTEAw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UwsZrgkO;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf15.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760396889;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WsULGpTWYVJqyd+s2rzVYTRP+oWghbcs0VO7v3VHL6A=;
	b=UwsZrgkO6o20OEUPAjmILTxhdhbXyY01+5QsyfIl0GXlYkR1IJ8pf2T0R09x+waKXT0Sr6
	vnmC2En/xN+UyDuPghiJi0eKO9GFEFAs78SXrS2dbEI3dy9BRAmVOuqS8fSUcHb4cH4T7X
	hlKfm6l79rQXW9SpaAlx/Sewb38yYQY=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-58-qigN8ftcPrWxxfSpGsTOYA-1; Mon,
 13 Oct 2025 19:08:07 -0400
X-MC-Unique: qigN8ftcPrWxxfSpGsTOYA-1
X-Mimecast-MFC-AGG-ID: qigN8ftcPrWxxfSpGsTOYA_1760396886
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8D2EB1956089;
	Mon, 13 Oct 2025 23:08:05 +0000 (UTC)
Received: from localhost (unknown [10.72.112.12])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A08D91801AD7;
	Mon, 13 Oct 2025 23:08:03 +0000 (UTC)
Date: Tue, 14 Oct 2025 07:07:59 +0800
From: Baoquan He <bhe@redhat.com>
To: Barry Song <21cnbao@gmail.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org,
	kasong@tencent.com, youngjun.park@lge.com, aaron.lu@intel.com,
	shikemeng@huaweicloud.com, nphamcs@gmail.com
Subject: Re: [PATCH v4 mm-new 2/2] mm/swap: select swap device with default
 priority round robin
Message-ID: <aO2GT6qqOu5Qsy4X@MiWiFi-R3L-srv>
References: <20251011081624.224202-1-bhe@redhat.com>
 <20251011081624.224202-3-bhe@redhat.com>
 <CAGsJ_4y4CLu7qeHijhJtL+NDrehfiWpu9mtsVGxmn5rBy03v0w@mail.gmail.com>
 <aOx42iLkuyYqXBMW@MiWiFi-R3L-srv>
 <CAGsJ_4zSeMfiy=9Pa3A3UtdNigOc=w4eWc1KQpkBbD4AdvmPTA@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAGsJ_4zSeMfiy=9Pa3A3UtdNigOc=w4eWc1KQpkBbD4AdvmPTA@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: C1Qt31ew2SnKSPBebArH9yf1hHbY3G7X5nyBlk26Fv8_1760396886
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 214B4A0002
X-Rspamd-Server: rspam02
X-Stat-Signature: a1efbsqbkfehshxehxrj7m3thnr61frb
X-HE-Tag: 1760396890-129140
X-HE-Meta: U2FsdGVkX18R37Z5zyGVdYYiA2KaNT8rX0pHGJbFYfzHynrDPJT/h/q49Dai0cgMq+1pavEy+70Epzf2HR42/Di6hOnOTJorzXZA8B5rM9SoHPbVw3DzCExKLUM5uvIIwOI0+Tcmr5LMUATgZdQkuK5+6UwV1wnNh4dDhyoaGjKRodmSCYvcPYeRkDUm0wkwGwHBBB3Ja9PsC4vE2FE/GpnHSGX1nbJmPrbkuY5G2GZs3F1z/PX34l1bwTetHCa7BRTT2azQHPR4WZhtv+As4Bj0JCZQ9E52LfIzEYw9HR4N7MYNPHFwY4WO38DZySBP4YRf3EXss4TUtHGcb1pBsxYdGkZdgAuIUOZKOXXagE5HhJLB40/y7tF4VrpwEVnwkfL59I1tiFewDpThEDvTOevbJ3sSinWhj4CiR2cMTg2Bmk9qsYnPKuAwoVKsipit6Ev9Hul3T2QKDnjn7PC89yM/bxWEM1R0f9soEf5yv7Cb0+XMsSse/B6qyLxeMN57RLktamADGLjrFtsbyIzpYUvM88WRrHADf5QSXls8FfGFhXsz9x9aSAhgbdeCRcENPR/s8f5iHLSRRXowuhuAFo3L2VHRG8mGrGywGQGAwdIQiSNgtH87y55DIJ6SNhI94TiY/aB6T4rgo6so0Nco1F13CRr79RKTHIAK4V/HVmLWGOWyEEWihfUWJDdqU3I0qZGMA9G2uTId4rKI6MBSL+KUmQCUGnMXjLg2UZvlIsQf9Prg9Yd0MvTXofv8L+uNoAIaCV4J9pDyxVXuve4K7yrkopG2/VB4xc5IdhNMLuYUNFBKdz40pPCIGlfPaRnkJd0aG9odRabhHs9KY+UpTLXl7M7K46QiNSWyC+2gj3cIcJjjmqRck70fi2B8y2yjWXjv0ITI8rkPw9+NEblxTBOM6YCMMHWHICwdbUNJf8zj1hpkJlhF1IwwLhizxt7KI6pT6WK9KgkniD6/5hs
 BvxolTRP
 y4RXHntCiO55rkFZJ+f6plNNSd4883SxXIVdGaVbro+KDkGklr0CBSIVklrAErE/dkk51+/Q6gPS46sV2L+w7jFAwMiXL31oZVrGijJYGWISiLDGpkW4smc74TmI4qCj7BcaF1h90xhgwk2HMEta3PgpnymFWEKDjjja685JvnGi2fPDEwob5LGCUuSKMMoteMgh7pfxdSzalJuDV5Ay9Z5qmmMVbspDB5KxddGunm+gIIlJIrsulWmi8N65Yd/wb7K3QTdtQMZ9ekZFxJSeBO//scqhO5S6Uquw5cuaA8M7W2kNKhq3OYGh9gNwP9j4+6l+ncBAk05SNnsvQcL3RbSlxvziu4ceQ5mLpPdwMXKu5hA0w02+2NBmjmCRNK0Rv8YeL/5qdQMoviWC81KeWCH/aYqv4353yT3HKXQ89fL5/7g8lpxiw9pfa9bEtCH3+Y0cM1TJdvuc2wGBvACyndDeQmAIQ+0sADbu5seLhqIn4UBEnkIspfPAhIA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/13/25 at 02:17pm, Barry Song wrote:
> On Mon, Oct 13, 2025 at 11:58 AM Baoquan He <bhe@redhat.com> wrote:
> >
> > On 10/13/25 at 04:40am, Barry Song wrote:
> > > On Sun, Oct 12, 2025 at 5:14 AM Baoquan He <bhe@redhat.com> wrote:
> > > >
> > > > Swap devices are assumed to have similar accessing speed if no priority
> > > > is specified when swapon. It's unfair and doesn't make sense just because
> > > > one swap device is swapped on firstly, its priority will be higher than
> > > > the one swapped on later.
> > > >
> > > > Here, set all swap devicess to have priority '-1' by default. With this
> > > > change, swap device with default priority will be selected round robin
> > > > when swapping out. This can improve the swapping efficiency a lot among
> > > > multiple swap devices with default priority.
> > > >
> > > > Below are swapon output during processes high pressure vm-scability test
> > > > is being taken:
> > > >
> > > > 1) This is pre-commit a2468cc9bfdf, swap device is selectd one by one by
> > > >    priority from high to low when one swap device is exhausted:
> > > > ------------------------------------
> > > > [root@hp-dl385g10-03 ~]# swapon
> > > > NAME       TYPE      SIZE   USED PRIO
> > > > /dev/zram0 partition  16G    16G   -1
> > > > /dev/zram1 partition  16G 966.2M   -2
> > > > /dev/zram2 partition  16G     0B   -3
> > > > /dev/zram3 partition  16G     0B   -4
> > > >
> > > > 2) This is behaviour with commit a2468cc9bfdf, on node, swap device
> > > >    sharing the same node id is selected firstly until exhausted; while
> > > >    on node no swap device sharing the node id it selects the one with
> > > >    highest priority until exhaustd:
> > > > ------------------------------------
> > > > [root@hp-dl385g10-03 ~]# swapon
> > > > NAME       TYPE      SIZE  USED PRIO
> > > > /dev/zram0 partition  16G 15.7G   -2
> > > > /dev/zram1 partition  16G  3.4G   -3
> > > > /dev/zram2 partition  16G  3.4G   -4
> > > > /dev/zram3 partition  16G  2.6G   -5
> > > >
> > > > 3) After this patch applied, swap devices with default priority are selectd
> > > >    round robin:
> > > > ------------------------------------
> > > > [root@hp-dl385g10-03 block]# swapon
> > > > NAME       TYPE      SIZE USED PRIO
> > > > /dev/zram0 partition  16G 6.6G   -1
> > > > /dev/zram1 partition  16G 6.6G   -1
> > > > /dev/zram2 partition  16G 6.6G   -1
> > > > /dev/zram3 partition  16G 6.6G   -1
> > > >
> > > > With the change, we can see about 18% efficiency promotion relative to
> > > > node based way as below. (Surely, the pre-commit a2468cc9bfdf way is
> > > > the worst.)
> > > >
> >
> > Thanks a lot for reviewing, Barry.
> >
> > >
> > > I’m not against the behavior change; but the swapon man page says:
> > > "
> > >        Each swap area has a priority, either high or low.  The default
> > >        priority is low.  Within the low-priority areas, newer areas are
> > >        even lower priority than older areas.
> >
> > I didn't see this in man 8 page of swapon, while see it in man 2 page.
> > Means people may feel that change when they call the call swapon()
> > syscall, but people may not cares about in script or something like that?
> >
> > > "
> > > So my question is whether users still assume that newly added swap areas
> > > get a lower priority than the older ones?
> > >
> > > I assume the priority decrement isn’t a stable ABI, so this change won’t
> > > break userspace?
> >
> > Hmm, I would say that this will change the assumption, BUT I don't start
> > it. That assumption has been broken since the numa based swap device
> > choosing at below commit:
> >
> > commit a2468cc9bfdf ("swap: choose swap device according to numa node").
> >
> > Before commit a2468cc9bfdf, swapon behaviour is taken strictly as the
> > man page states. The earlier the swap device is added, the higher its
> > default priority is. And the highest priority device is used up, then
> > the 2nd highest priority swap device, and so on in sequence. Below
> > swapon output demonstrate.
> > ===============================
> > [root@hp-dl385g10-03 ~]# swapon
> > NAME       TYPE      SIZE   USED PRIO
> > /dev/zram0 partition  16G    16G   -1
> > /dev/zram1 partition  16G 966.2M   -2
> > /dev/zram2 partition  16G     0B   -3
> > /dev/zram3 partition  16G     0B   -4
> >
> > However, after commit a2468cc9bfdf applied, above behaviour had been
> > changed. I can give an extreme example, imagine on a system with one
> > NUMA Node, node_id is 0. Then I swapon several swap devices w/o node_id
> > value (namely node_id is -1), at last I swapon one device with node_id
> > 0. You can see the last one will have the highest priority to be chosen,
> > then other swap devices.
> 
> I assume this adds logic to prefer swapping to the closer swapfile first,
> while still maintaining the old behavior for non-NUMA cases.

But it still change the traditional behaviour, right?
The old man 2 page of swapon obviously doesn't state the prefer swapping
to the closer swapfile first on NUMA, while still maintain the old
behaviour for non-NUMA cases.

===
Each swap area has a priority, either high or low.  The default
priority is low.  Within the low-priority areas, newer areas are
even lower priority than older areas.
===

> 
> >
> > So I would argue that if people realy care about the default priority,
> > it has been broken since 2017 when commit a2468cc9bfdf was introduce,
> > and complaint would be heard since long before. While we didn't hear
> > complaint, means the default priority doesn't really matter?
> > >
> > > Or if someone sets up Linux assuming that a newer swap file will only be
> > > used after the older one is full, then this change would break those cases?
> >
> > Hmm, it could happen, but I doubt people really count on that. I would use
> > 'swapon -p xx' to specify explicit priority to make sure it. In the case you
> > said, swapped out pages will be swapped in, it's either not guaranteed.
> 
> Personally, I also dislike the behavior where a newer swap file
> automatically gets a lower priority than an older one. However, since
> we have a rule to never break userspace, is this considered such a
> case? Or at least, do we need to update the man page as well?

As discussed above, the rule on swapon had been broken. Of course, I can
update the man 2 page of swapon. There's no change to man 8 page of
swapon, because it's not mentioning the default priority thing.

> 
> BTW, we can achieve all the benefits of the round-robin “18%
> efficiency boost” once users set an explicit priority in userspace for
> the four zRAMs you’re using?

Not sure if I got you correctly. The 18% boost is only related to
default priority. If user sets explicit priority via 'swapon -p xx', 
nothing changed.


