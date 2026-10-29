Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8476606A331
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 17:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Jwz5Vig9
Received: by kanga.kvack.org (Postfix)
	id D2C6A6B0613; Thu, 29 Oct 2026 13:11:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D09C86B0617; Thu, 29 Oct 2026 13:11:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF1876B0617; Thu, 29 Oct 2026 13:11:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 96A1F6B0613
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 13:11:30 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 09F32804CC
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 17:11:30 +0000 (UTC)
X-FDA: 85376305140.27.4AA47C2
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf21.hostedemail.com (Postfix) with ESMTP id 140C81C000E
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 17:11:27 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Jwz5Vig9;
	spf=pass (imf21.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793293888;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tWIs7qde7qVf47bMdBUNRj4kmNzByzqvwM3TO1z2Isc=;
	b=CrkYVYLxWQGSJE2I4+khqosFzadAzrQNfYHbFcXjLl0VanRqF4IS3u4NiRlhZTbUJtNzdR
	XPEp6MHuL9dTAtcxQlzSIwtxIVOZ1MRw4e+vFpTZo1lKuOs2r7+PwoQeNg0czmSK9AuN+h
	Uk6G3uCAyGLG4zwaj+l224TdVIdK1Ds=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793293888;
	b=8jBP1GxvdipLxiurQlvsN1dZ6kcGwrWMJlARETWAEsq/htbSg6HWvoYvek2zBKU+UPlutE
	bUabyudOXYLvmiYkE0vMPxO0YELbA5Ko2u3HJd+4UNHmfE7IYT7Gt0+3QD96ZGpQlEmmRn
	ZDkY6tHBNO8mvVOYBLsGNDOdLqJtMv0=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Jwz5Vig9;
	spf=pass (imf21.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-48bbb06e746so1149874f8f.3
        for <linux-mm@kvack.org>; Thu, 29 Oct 2026 10:11:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793293887; cv=none;
        d=google.com; s=arc-20260327;
        b=ThUfCB+NoGXuVshqHtM2oxN1gPnLhWY328k+/q+cNffMMDfBycPvqiOTf3vkIJStec
         mkMKlf1Ng5kG/yK1Gx/SE7b7KnPogFuGehV55PJmdCh4zyC0b4MBq7ULxrLUimlinn2B
         iRjuM03jsdXRkP8EybexTgOcIvRU//Uq1kGkQZnQauTwwaOSl3hY40CgPOkYKo+7lbdv
         SFDfmSfxk9cRl5jiZBHo+5SPv8+6CJkQzAjx+7azjsV3Bf1l6uFR0qD0umL1GszQMZYc
         VmM1kiZwT0wV8x6HVg76kwaZVhiIFNw+Xo+rFumOKSWDfFIlR6qgXteZELkDDNnJHQc+
         JTHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=tWIs7qde7qVf47bMdBUNRj4kmNzByzqvwM3TO1z2Isc=;
        fh=tXLRC1pu/1Qa5bincYPiGhE12JXziCk+QP7sPklSzNA=;
        b=rXkxSDUXery7xRBdJ9CwcPGBEPkoyVntBeSgvxrgZtDlvMol0AyY+d2Wx2dYC/P48j
         BwWwGjA0qxjpIbhoVakBm7rJ/lY4z+iGvIcNAkaY7hSJFmHC7y7c+u16D6truGPQS7J4
         Dz5SO+DYE+nc1ffdtXy77aiJ6HY5XPOOodBh5kZgnhIPkMOF1UOK/fNVzpthZ3cP2ME6
         6xLniIhA6LKk790SYFDHVHRMPD7fM8Jt++8XOE9zF6ErTjDDSvGITzPJnXsicATsDd5I
         zPdKGwUN56eV3kXpqS3MNe77KM9pWNB6h5H/MRMX9VkxLkzaDD6ejbdheFeN9JqiakQH
         q6+g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793293887; x=1793898687; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=tWIs7qde7qVf47bMdBUNRj4kmNzByzqvwM3TO1z2Isc=;
        b=Jwz5Vig9tryi9O6JAEQWNRn0dssK79wjgPuwqSMbF2W8DjTEvxv3hU4Mwu5RkPcsVu
         oPURtZELYrYTOwtitdm2ve1EH3TyfZ8dZH4oy9/iDvDrF1BIaHwgMe9YaSZIY3CMSlJi
         8BbKwduXLZqSt8lvD6xMdzPP47A25mUAk1ISfLAdBAnYm0kiEbGmGxEKQKJ6/PeK4Lvh
         iTMigUpAmu9HNmSJx6CD7yGm0V7xfIJwpEUhIWPf1XYtCBcpidWlXj2JeSkKR/0CNDPS
         LMuQf6uvG6iFtsk8MIDZBf4rmGE7VqII+madY0EvELjC20TPRfaXN82r7SMVi4h3JHV9
         6Sow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793293887; x=1793898687;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tWIs7qde7qVf47bMdBUNRj4kmNzByzqvwM3TO1z2Isc=;
        b=xRbI/KftPHSKGyVBTTvV8habr2LeBssjKPwRM5DfydeY4F4t2sQt5c48hDi1UR2Asj
         tzI8ecN37jDa1Q5wOl3ottF87OxNNDxdDPc6vvqbdV3NboGjFKrWhkL5FU8yABWF7nTZ
         HzhbG+RjEe5FfaX0geG265rn0UKz92I8t2AGo9RfcgkIBHwp/CbdKgTC5oHTO5yh8z0M
         DanhBC9YY+AWPG4o7QOVuCXK+xhqjYlRTdAF6n6d7B5/1QcL0occOJTUTMA8wQP4amet
         C6/dAU1g5tm0sgXU9qul0OyfSINuKnoT86uKEnnVIZjTYc4DGzUE2mXnbSmfo65vARs2
         o61Q==
X-Forwarded-Encrypted: i=1; AKwUvByHtVlGWTnDRMYB2KNW9sNkuLzuT1QJPfz0vLjCgI5KIl1/VJ7sQq8k2nNp4p93qbBzY7wPYdN9NQ==@kvack.org
X-Gm-Message-State: AFq9FYJ/yPMy8PhsyRIHjZ5/CujkKOJwLJyMAFM6UDidoiTh65IRh0U4
	GuTReQAzMZ+7uCQXwgiJACqtywawX06q55DCEIoQ5+ZfOj/zRWpB2qu/4Tim1CJRyTcw4SVISoL
	jJE/XOy6jHjuoosfjLwvJJcHE8ypXL1w=
X-Gm-Gg: AYBFou1+bUG8heiS1LDeScWCdvxgyPBrbGoZ8mfP58lIkQ6YjtVBlDQapaOXp9EoYO5
	PNH91GpQQfHztAHKlWADtAMq/gs+yp0/oDKj7AjJwl8opi8MwtcIxkLjplGxBMtdi6Q/VYd625G
	cqQ91NCk03/msZdZV2TnNiReazZLlt5QHCr1SY6xqPnz7wfSuO3J1qQIRA2fOTAoWHbiaAIegX3
	k7CrQaSVBQq0Y9YULrOT9iViZ3cfjsVtc8h3/yHXJIwA/HEhN/an12dZSFqpSTU38RRUZrdXMJn
	ncYmqo2n3E3LPb9SMXKtHVxe9ku5MxVoQtdA74pKOsCzd9+HEFO9k1Vc7n5/fsnRDZHR5rgE8rL
	P1Me0cW7/8V5lR/72ontj1V0o+8uGBHUWxEYR/A8U+r0FvCjVGpXcKpuZBT+sc8gJ3djqyxdkGI
	jGQid4qeqqKK6ihXZXIDegyLKBiHwtq/QM8WLef6HWxVyDGze5YA9vPQ==
X-Received: by 2002:a05:6000:2486:b0:48d:ff81:5201 with SMTP id
 ffacd0b85a97d-48e6e4f44f2mr41720f8f.41.1793293886562; Thu, 29 Oct 2026
 10:11:26 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261028113619.38752-1-kaitao.cheng@linux.dev>
 <CAKEwX=NfFNbBwhvNpYz8iWgimFuOow8J8x1SzV_6GcC_bb=Etg@mail.gmail.com> <3410e049-2e61-4ab1-b776-e77f3b97517f@linux.dev>
In-Reply-To: <3410e049-2e61-4ab1-b776-e77f3b97517f@linux.dev>
From: Nhat Pham <nphamcs@gmail.com>
Date: Thu, 29 Oct 2026 10:11:13 -0700
X-Gm-Features: AclHuK9bGc2_lFtcOpZQ5BfNhmM3b9GrSn5IrOfOf7ZTzL4rwMpqhXmug54aEy8
Message-ID: <CAKEwX=Odrncvnh=OU0Tqahb4ED0UYD2fKR7L2=_PVh=ZbB=jnA@mail.gmail.com>
Subject: Re: [PATCH] mm/zswap: fix double decrement of the LRU node count on writeback
To: Kaitao Cheng <kaitao.cheng@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Kaitao Cheng <chengkaitao@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 140C81C000E
X-Stat-Signature: 6wukik4ibe69pym3rahu6fpka3ki4tom
X-Rspam-User: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793293887-135904
X-HE-Meta: U2FsdGVkX19GsTYsFGZ8m2735FnP5MHVcY/Pk7MbqdMGX/PkBNZqFj9CRiNFhTrUQcSZy2INlDttG1d3Y2PWt1KDbBXP2xvG2Iw5yUsoarDeYlaPgVDK980eYgH2pLoX0vlFucKmLWUh6pxpNHyg7mBO2yjb3Q/2NVfCKhtAfCb4XodYpFteHttQLUdehOg9AWktcuXZt7ptz7nyX1Vd87GvUVRzTfuDtOnTeN03wRhMY0KzoIQKRcBkcycWPjDCR3JDqrBEwdk2tJ/AOViX0qwVjjIcF6lYq8Fs+GooGF+PiBg9S5/L0fYARgOsQ7LRHhrEXnD5Q28jeK4IhS/YUjpovavp9/Y4OfvZZumo42zoCcm9rjsPQXN5img38KQkN5Uh9kGy7EMX3m9ThbakGSDVIT/o2STWgI/kn9SaKbsJNYye4X4uac8oVrkzlcNZUymP+lnsZYmm/Azn/1GaSeS3rVdCCx7USKx7u72bFUMaSw7cqgyBMtovXob8vWcdibmVK51DXan9ZVAJyEZRmHMnCoSyCCwkkcsF/Fmx/HXl1fjHib5JSu/RQ9pzaYgut/ppdqrDwHXVpn0lH+khhF+TGO0O3IdFhtzofyku3S49+JfDzlN270mL4+S6FIop2FgsgjWbA4B3fmNRDH4K4VWiuVxyx+gO+HsTTKfhEMQmdbXejLO18vdOBjvDPmawXayn+RbwHAMomM6Ljd/6whqci97WF9n2zhIwuxBslfgi8NKvwpUmtGGyojQALOho6hufImh7zX/TBL5OunyQJyRTH2+6yJU/BsHSY+Ncgxkp+7HtsCu0KruiivlxpbGiXFc4xJNuO4nf/+7RxRlkfsLMSRmdf9sEcONTp3ips9kENDCR8IlVgXod4YJO33e40d/re6nEgsrXn3lzpZ4hLXExdYI6a4hEUoS4ZpJ6glgg5s7qhHqLKOsaMvhoQQXGCRXXhGD9onMBMmjVPGs
 9RiZD6XM
 v9PjxZjctmW23CYtI/WYNU0788DUJa+qdn4m+perH+Qh36xq90EFY3jdydAb5IQyGRKfmky9NkztfhLBkk7MARZGeTTIHbdpyNFxwBC5tXBIypuOdIV9Eri4wBL1feQN7GfvsBXNvSCUASfQgQvEvy9EzWfPriWkaYlMs+fNfx1ewV8yvkSQfkT6Um+ne+wwEoB7Oyng4BXmFgQQNFHaLjQepkJSXzQZ5QWk8TGLTVLCZQeJitDopExAs3byUQK5nmrJBvVpIyYElwqQYNdpPbd28+zXZCOSPe13yNko0So5T6rvMv3IAgtZmz1jRu2RyY5aXfA8KzYUn+gcnmqL0WmtDtxcKr0MkE7sbFWtErVcZHfNCMWtiH3c8Ljj/Qn+ESE5lM7vD3reeXWosxPufBso8Ug==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 28, 2026 at 9:15=E2=80=AFPM Kaitao Cheng <kaitao.cheng@linux.de=
v> wrote:
>
>
>
> =E5=9C=A8 2026/10/29 02:47, Nhat Pham =E5=86=99=E9=81=93:
> > On Wed, Oct 28, 2026 at 4:36=E2=80=AFAM Kaitao Cheng <kaitao.cheng@linu=
x.dev> wrote:
> >>
> >> From: Kaitao Cheng <chengkaitao@kylinos.cn>
> >>
> >> Successful writeback calls zswap_entry_free(), which removes the entry
> >> from the LRU and decrements both the sublist and node item counts.
> >> shrink_memcg_cb() then returns LRU_REMOVED_RETRY, causing the LRU walk=
er
> >> to decrement the node count again.
> >>
> >> The affected call path before this change is:
> >>
> >>   __list_lru_walk_one()
> >>     shrink_memcg_cb()
> >>       zswap_writeback_entry()
> >>         zswap_entry_free()
> >>           zswap_lru_del()
> >>             list_lru_del()
> >>               __list_lru_del()
> >>                 atomic_long_dec()  /* first node count decrement */
> >>       return LRU_REMOVED_RETRY
> >>     atomic_long_dec()              /* second node count decrement */
> >>
> >> Add zswap_lru_del_nocnt() to remove the entry and update only the subl=
ist
> >> count, leaving node accounting to the walker. Split data cleanup into
> >> __zswap_entry_free() so writeback can free the entry without performin=
g
> >> another LRU deletion. Other free paths retain their existing accountin=
g.
> >
> > What is the visible effect? Is there any effect, be it in reclaim
> > dynamics or userspace counters? Can you add it to the changelog?
> >
> > I'm not against fixing it, but need to gauge the effect for
> > prioritization, whether to cc stable etc. etc.
> >
>
> This is only an accounting issue; I could not find any code in zswap that
> reads lru->node[nid].nr_items.

Yeah I double checked - this is the node counter
(list_lru_node->nr_items). zswap uses the per-node-per-memcg counter
(list_lru_one->nr_items).

I think Johannes' approach SGTM.

