Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0249EEB365A
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 03:01:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 305076B00A9; Mon,  2 Mar 2026 22:01:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AFBF6B00AB; Mon,  2 Mar 2026 22:01:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B1A86B00AD; Mon,  2 Mar 2026 22:01:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 082AB6B00A9
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 22:01:54 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AB9D01C647
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 03:01:53 +0000 (UTC)
X-FDA: 84503252106.28.F885255
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 834FC120004
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 03:01:51 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Z7wYa9k3;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772506911;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+FvUkJbqGmG+338syh2XbHE9693ffRfAl35ocO7Z2OQ=;
	b=Rp781QVCEWsG/q21WzoFW3Rlu0l4S/tyyaccXinPKxvFwW8AEj+HOhxej/jTXg9NJRUev+
	2//Yr0195v7ZAAIzLnATZp364+EVO8XkkyD0g5+xOsO+mMyW8nsniwrqlBXtrskRGRbxil
	DnZacsArgbeSTniYb1M0IkZB9K7yDvA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772506911; a=rsa-sha256;
	cv=none;
	b=7Lcy2t4jVmxeV4WdSTzlT8ZdungFeKmAuzxGICy1NC3cU4JVNDJMjJmWdF5yxWUib4yt95
	F6Xl6++cWg1daOjcgb2+3xI0haBahZhV6Kt6LNqMyeo685/BYh7BeVYiSXF8WjiAR53vvv
	hqLD9eAGTWDWjFpr3Z3myagwCOw8lfU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Z7wYa9k3;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772506910;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+FvUkJbqGmG+338syh2XbHE9693ffRfAl35ocO7Z2OQ=;
	b=Z7wYa9k3YG4KToKF7nXAd2rnpHjygh7MRzTkS4CuwLZFFtsrxeh02+g41q5bKFjIcO1DbE
	QNBkVGDexDI9hnh1GtFKub0U8H4rcrF/xcAh+HdxESr02jXK03JSq+3QZIC77PkZG+Ej9F
	4j4QzhAuPilFpKDuGlinmCzsD64B0Ew=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-673-fM4yOCruP7G-d6ZeIbjaTQ-1; Mon,
 02 Mar 2026 22:01:45 -0500
X-MC-Unique: fM4yOCruP7G-d6ZeIbjaTQ-1
X-Mimecast-MFC-AGG-ID: fM4yOCruP7G-d6ZeIbjaTQ_1772506904
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E72DA18004AD;
	Tue,  3 Mar 2026 03:01:43 +0000 (UTC)
Received: from localhost (unknown [10.72.112.42])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EA48F1800669;
	Tue,  3 Mar 2026 03:01:41 +0000 (UTC)
Date: Tue, 3 Mar 2026 11:01:37 +0800
From: Baoquan He <bhe@redhat.com>
To: Nhat Pham <nphamcs@gmail.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org,
	kasong@tencent.com, shikemeng@huaweicloud.com, baohua@kernel.org,
	youngjun.park@lge.com
Subject: Re: [PATCH 2/3] mm/swap: use swap_ops to register swap device's
 methods
Message-ID: <aaZPEcnpscHMjSKO@MiWiFi-R3L-srv>
References: <20260302104016.163542-1-bhe@redhat.com>
 <20260302104016.163542-3-bhe@redhat.com>
 <CAKEwX=Pb=W8WShjS5uq=8iWxZYjTiskhKUO-MgxJzD1HgHmX7w@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAKEwX=Pb=W8WShjS5uq=8iWxZYjTiskhKUO-MgxJzD1HgHmX7w@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 2ZTUkihNDDp3rn04_oV6h_eWPuzCOD2IXumTm6eJxNk_1772506904
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 834FC120004
X-Stat-Signature: jjq84uys9aiqc7y65hogfdqop79k85qx
X-Rspam-User: 
X-HE-Tag: 1772506911-1206
X-HE-Meta: U2FsdGVkX19jfsw38bhjJNxedISEzHGuR7Rgo80l5psEUyWHpAmU/OKHNz9TUEsjvqON1Rzz4sVg7RtaPMFQ7B1dS4dSrinK2yUgozWQ4iP0LEg32x+MflBTa1bVjyI56KZ9q7XrS+4j17dhuJ7qLuUIpp8BkrlrU5mfu2OgsUwbWCtZtC3QBTxVnL9fhsNPsm2ww+n3MU58vGv95RPsb+buL86cYComBFAqIBIM1acUFchpzrB1/ANMR0hVvcBcF+dRwGlsd8aYb5ZfCp2chKDuUBRSdLfKyrQTZ9NLlvygQsoisqnrWBh9c7GERz3h7FkCq0zSb1EVdUeEp/zxoeMJLB3iUbVgJNZx+eHnlPrQdvdrpwcXwar2Gehsk1IuSFlAS5yRdDOoSnEyKd6aRJsxzjBJfhOb7Dc9JCi9OgqRGE4qH0jxwubZe1Iwow9HszEe/yKapDiyR9/rOC6KYwD7Gz60t6w6cT/9t1Gl7wk1rT6nDfAAVU4x2Ngj2GAujQwbOOXoDm0JnkIZ25BWsI5MDfsDZ4VjSfbdWtmqYtNiJtK4Occdz2bDWCoOK+Fj6Z/hTI+CjcPGGFyOto1X/9QyreBWOhm05yms18yZ1toQB1sbNPffA14pr5YYWGIaUiRl5960gf1fdoJoA0m1yR/rqPoaF7ZAZ02uQIR8cIZpZroktDM0Fs8c8gr11Z/RYtWFuaj73GxD+cgovuJl9AYc9dR+7cReoRu7GPTG9atZKmEH/1Dne/dsc7blV4yWJpCClRNxoVVKXE4/T/bf5qiAALHRADwfS5uo/gQevjNxvo9pknZxFnHC7Md7oHHT989QFWob48lrDWULJxMmQP8S3GF8LWnYx2oW7yLA3oLg0AjddHqVl0C45+LO68ixDmTOvy5O8a3sAaXkasQ9t5tyAgqQeoHlijtYerTlHPmD1aekJkmn9fzH3dVODgRSAUuKUHJmLvuehkblwRo
 AKhO7QRE
 gEog/LNBqmsgAVAXhh0dKyLzWZ3dQXkxQPvRdnBGVfY0MOk+MV5YSslSWsWWDn5y5B+YkrnhlsBe39S80qx39qAkZ4xUiZCAgGxnj986j1xXsbxTGFsJTIbtAy2TRwnSGRMoVrZL19qh/t3+3M/KVBfgHz4qdJAeBaY0lBAkjnMofrzxM3DMPOsbXtbgW2o7M1gSxKQHw4T0tK0Ilrpd6Abjy6b1lY4cSm5iwvR/hX9NTOP1hNwymLFPHFzmqygzHpn41x5y7OPKeGtCrtBW+kHRLj913+JLCOkjxGbAFmHv52rVxz2d7cXH+LMO6uAWFTmV/VU9mDs2ropddisXWq91hMNEssGssluZrVxSElMNIbXTZKcTsTJ8TUt2nKlUv2lh1MEiBOsGohbQsLGi1OWC2u3I1dV7ibZdnot5D+cahCTfz5eo5ldtMJiWm0FQL41mOWzpIWUB1CK4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 03/02/26 at 01:21pm, Nhat Pham wrote:
> On Mon, Mar 2, 2026 at 2:40 AM Baoquan He <bhe@redhat.com> wrote:
...snip...
> > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > index 915bc93964db..af498f9af328 100644
> > --- a/mm/swapfile.c
> > +++ b/mm/swapfile.c
> > @@ -3625,6 +3625,8 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
> >         /* Sets SWP_WRITEOK, resurrect the percpu ref, expose the swap device */
> >         enable_swap_info(si);
> >
> > +       probe_swap_fs(si);
> > +
> >         pr_info("Adding %uk swap on %s.  Priority:%d extents:%d across:%lluk %s%s%s%s\n",
> >                 K(si->pages), name->name, si->prio, nr_extents,
> >                 K((unsigned long long)span),
> > diff --git a/mm/zswap.c b/mm/zswap.c
> > index a399f7a10830..7ce906249c7a 100644
> > --- a/mm/zswap.c
> > +++ b/mm/zswap.c
> > @@ -1055,7 +1055,8 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
> >         folio_set_reclaim(folio);
> >
> >         /* start writeback */
> > -       __swap_writepage(folio, NULL);
> > +       if (si->ops && si->ops->write_folio)
> > +               si->ops->write_folio(si, folio, NULL);
> 
> This one seems really weird to me TBH...
> 
> What's the point of a zswap writeback to a backend without writeback
> operation...? We're loading the coldest zswap objects back into
> memory...?
> 
> More generally, do you anticipate a swap backend with no write_folio?
> I can't imagine such backend.
> 
> That said, if they exist, they should be exempted from zswap
> writeback. At the very least, move this check to the beginning of
> zswap_writeback_entry(), right after swap device pinning
> (get_swap_device()):
> 
> 1. If swap device has no writeback op, just bail. Don't even bother
> allocate swap cache, decompression, etc.
> 
> 2. If you anticipate that this case will never happen, add a warn.

Good point. Currently, there's no case where a swap backend without
write_folio. While in the future there could be, assume you have noticed
the swap tier patchset introduced by Youngjun.

Here, the si->ops checking is purely defensive programming. I can add a
warn at the beginnin of zswap_writeback_entry(). If there's any case
involving no read/write_folio, adaption can be made at that time.


