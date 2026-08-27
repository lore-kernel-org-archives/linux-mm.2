Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F24EC61DC4
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 17:44:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBB366B0099; Thu, 27 Aug 2026 13:43:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6B956B009B; Thu, 27 Aug 2026 13:43:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5B336B009D; Thu, 27 Aug 2026 13:43:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 684456B0099
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 13:43:59 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BDB48160114
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 17:43:58 +0000 (UTC)
X-FDA: 85147772556.06.A57A77E
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	by imf18.hostedemail.com (Postfix) with ESMTP id D99691C0002
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 17:43:56 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OhsAcJDP;
	spf=pass (imf18.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787852636;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4i2SR7f2g7WojHVXlIh+MHMjOE6RNdaClrU3jFaCNYs=;
	b=j0WU4oQ5U51qDOP7Iwh41oAATbpPcjDa8zlimgMq+4qmScN8vbYdLMpKXg7n3qdh1tMlOQ
	5r1iBa92MLPHFOSD5pXE9L8ISeRsgedekEVFavY8Aqdl5vsOVwQbfc/ekctwaFQ6LpPwfK
	QevG0IcJJj3mulNmKXcLQVbeT7l17p0=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787852636;
	b=qEGqtRzPqN8HXHWl276bR7Gs09UJyZyqiUo4/knfBGesQ3Xvt7wbrDWLkHABQsQKJpe9VQ
	Eq4jrgwZuthWc+8kvXqGpeBvvJm37FwA59qOkb3ZDLP1/omhfxL5sefcuNiXlk5R3vlLIz
	bg2CGVxsPriJkHk/ilpgPzIDOQzAmss=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OhsAcJDP;
	spf=pass (imf18.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c1c26d7e951so24295766b.0
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 10:43:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787852635; cv=none;
        d=google.com; s=arc-20260327;
        b=HMvAF6qNej42nXs530eQsEy0rUGCMXPLCjZM0udxxV4b+31fjAldI6aSpUtQnJq0va
         YHF3Pd/xy/RW02+1vtGDRe3fmkKxMReZMXZq/KjSPRVmEBWBnHdQEO8vbVGmwwHXD9Zx
         HaA7bzcKBxDZlw3g+yn4zM5TQ3mWGqtWemp/bJzxq2TePwC1rRb9F4J1ustEveAYRkAa
         pQoTU+WJ/eyM2qTUvB07x0cMoRrgCyupGVJt8pwd4+K0zzFyKcmecBuZJZUFZ4IpnMcW
         Vp4WqpT5AKg0X9fBLmSM6gczdTO6Uk/pZ+aznoX3pMZWeD/vG+Y3Sqg0bf6MMFDnxdQ5
         5hWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=4i2SR7f2g7WojHVXlIh+MHMjOE6RNdaClrU3jFaCNYs=;
        fh=gW5ivs51vbjATpS7fTtCbsRWfHNWurt1lFXO5nnQLVM=;
        b=Wvc1AlLBzZ78BOSBnZPzh+nJYTH3PfLrxzFmmFM2hZy53AwXsTt7F2suHp0TxPzrrn
         0xU1dwQGOi9+0Lji7Sra2FLUe3x0Pp4JJjKNLaU2NOAtLIlZRpcDTCwm1joDNIIG12Jo
         IHKwFhUfqstZwblZpbLSgwKTYTNLQrmXxfoG1swhQfIArcAT8Vg3kX+DdyX629djOb6M
         v8TUG/NMiGwNn/IQLYvkRcC7IfA4NIiCQgcuLM3JQ1hFd4/eQyFdLzC4DVMaFrAH48A+
         q/yySxQAU2jWUFCMUCwzL6vHxjj5kbE3fvYSU8lrWzWCGbagVUDV+1I57JC1b5m9Gh0z
         bIuQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787852635; x=1788457435; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=4i2SR7f2g7WojHVXlIh+MHMjOE6RNdaClrU3jFaCNYs=;
        b=OhsAcJDPEV16OLcp9Gygk6oYlxpuwUyfQefTTg0I1uxbUc4Pr14sYG3jajOIg0W+LN
         0RD/Vtc7THnsZjHnucwrcMNMrot+63QCefBdpDXFHAdKW2PBviZD4Mg/GOIIrO+Xekr0
         jBv7vDS5ThzQ8jfjQ+lVqk0IgDXE3UOzRrnCsewghaZxQTwYrS2I3cQmeg4pSQK2J37x
         1cZk5tO8tPsPGNawiKfgKEtpAINoatWm5Hp2Z2q4c9Al7zexQE0GxeQ3LYzBJ1W54U1c
         w5SENZZaWwwfDKWeSE/RyvLNBgavxgsYNVMqDMxKh1VnJJna14s68sDXe0m3uSu6LJE6
         o/pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787852635; x=1788457435;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4i2SR7f2g7WojHVXlIh+MHMjOE6RNdaClrU3jFaCNYs=;
        b=XdNleHJmuRgYiiTiCj9Hnbo9mdjHFykG0EezBxjt5oLlAupibz/99ceus68yIzjECM
         9wHAhjeCZYmPYBFeM16qo8yy5rzJ9SsUkIuc/AY11/yop/iOYcgzqVZy2QIx+SU+wAzO
         +WZXBABfZi/j34BoUE1dwou/KIav3e5yBFZourG0SMhOcidzjLJz+TXSKznsL7pSzkQz
         BSjbpR5Xnx5l/xbZNVDtHQ4bPU/0kEugApqeracg1sJ4n/skHL6FXvntY81qyNTW3WK4
         QbpUNj6FhslZClYXX2LBVoO6K0+LqBRm4BMxOngm24ZBrRQ4OFoMlbSpAJlvO02+KWHs
         6xqw==
X-Gm-Message-State: AFuF++lzHgvB8zrBbTnmVFmThXKcnYPve4l4Hix6cBOVBJtZMeYceAZt
	C3Eu9jraeDY9g7GFxn4PsuqpeO8zcOoBxkiG6mlPbNEAZrYSPwkFQTujD+Ipy9145wNiJhw+yFg
	/hUQaoAh3cb2kI8ixOqDLqyOxPRVhThg=
X-Gm-Gg: AR+sD11TXjEU52SWK4cCoDjjoKMkpQ5N+0NsEFHFTkz2CCR8UXkl9QZr+d1r0OXTMmE
	otF1avJufQDANAbYQlg9nKaCtTdiIFOI6wvtPFIvMDNEBuEoqapOqTwmbkqz7BWdxxtJRKBMaVc
	LVzwJf4OULUzfEpC7n2DcVGzQaRS4zpEaCZt8GSp6TgR+QsXZWyVcDN5ue5lYFUSp85Rh8HBfpE
	m2OuQRXY87zu2SbuCoVVn2wS7savjB+7Vqf+xoUvqUomjgEDPL45iRFmM+/ixFnkb79PyRDcPYV
	xZEGLwyi0lGInCBWsz5DqvO7C2vtW0RjL2joDLv9jP9p79uy++KdEARzC8b9Czn85UlLRng6I0N
	f
X-Received: by 2002:a17:907:d0a:b0:c25:32b0:e56c with SMTP id
 a640c23a62f3a-c2556bc8abfmr42528766b.4.1787852635390; Thu, 27 Aug 2026
 10:43:55 -0700 (PDT)
MIME-Version: 1.0
References: <20260821-swap-thp-cleanup-v3-0-9b43f5163238@tencent.com>
 <20260821-swap-thp-cleanup-v3-12-9b43f5163238@tencent.com> <60908273-aeb8-41fe-b7d9-d35c80e950ca@kernel.org>
In-Reply-To: <60908273-aeb8-41fe-b7d9-d35c80e950ca@kernel.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 28 Aug 2026 01:43:18 +0800
X-Gm-Features: AcwNN1Xii1DElQxgbinEAbRld_DdPsEeFSRZ1LYyW8zHIqr8BqfOJ4o6uENGKYY
Message-ID: <CAMgjq7BaJzPggVSt-F+7Xch+EkC3Lci249TOw9=Tes5+7nEZ7Q@mail.gmail.com>
Subject: Re: [PATCH v3 12/18] mm/huge_memory: add kerneldoc for the split helpers
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>, Shivam Kalra <shivamkalra98@zohomail.in>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ji8ugcxdjnkybg6cc69w58zcsj5yejpu
X-Rspamd-Queue-Id: D99691C0002
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1787852636-420435
X-HE-Meta: U2FsdGVkX1+hM73LymaijyFEUWEH1YYl9KJqUR5wVZnWeARU+5W4TV5W71hICphrU89uL2XOndbyqqFNlFHclhMlQ4RimxnnKuSrOc9lJ9NLPC8Q45KoDDPOSmeRaJiqkJJ8ubx/6u8EjmCExa8uvd0h3LYnJwnUEHC01ISj9Y7L/j+ZuURyCP9NYikhUUhE7FmegAbzeV25TNvsb9slK56RPUk2YSQ0aF8WFV3ZS2SD2geUIhm+kJsdHwOL7I1gj705Klmy+uK/xgFRQLzVi7NZvZ8rHOnghpocorezT1aR4pqCaGXW/2fwmcHrY4y5RzkrEbBkr0uagFiraQWHul5fISFFPLKE5YIQlQKHV3QOXfDpm8d3f5nXCgLEuJVBWnQ3mPWhmOFe3Z2J1To5cGfTrQ25U4dsEWy9oGQg5iZMNFMUDe9WMPuyKtQtL4FOMl5V2EPOM0/RHCXcyHwHy2ds7MJRpgXk197Q8Ws60cc3hKxeHoQul8UtDzVln+xsskBmqcW+s45MhrbO/1Nkl845ox3lAwWZ43JXll48LFWejg2qnK0IM3f6m/I0T9E0Bpf8CMhp5+Ye/NCsc1ztBR0E0UoNJMpKUj5IpTgWqGY6Xf+TdBsPDecAqDRzGx0OJvgE6KD/qDDee+CpQVYXpnkDvOKRLK1Erlra6/7sEUG+/2M3tLd/bYpJjUlm86CAJd45eKyWyKR78dfqnaupGHNCQW2HUnHh2xxeQgqqpStVF4uAFiLPEkiS/Dde7q2cAONbJFhzVsyM/KOMbjNvbd5iDPW88FRRkW2cG0WyR9dE72hiUiU+RxNDbPF85g/QoZG7av99cArb9aNVvMN8lAlDYmi09ri1oSqdM0LV31OFcxPj5LiMjW64CvVTWRbGsgzM0LuN+/B2tLZNhyjpidEpm8Kou50+am624FHEhKumYPMJKv30GJcHFhdWU0DQU2g+5OERonTUazPrA7M
 e/L1OU2Y
 raTtynoHZJPF06QX/0w7fmltqfcYjH5YPtFoLasK4QLEffkhHh6qbEKddLm9OAcUrbhEEf24Aj37VJ5cRoosoQ7qwhMatF//hW/wDz5Sd6Cj/P3aYPywUmeA01sRFznuiR6kwL/wxSRtQzCnCojKYeSuLlfr7OZ0pFh9zju72cZu/36qqRVOx1ni2LH6f8sKYK5gldJiidCnjwFj+G8lMvKYufJApWDJQFSvsPqDN/22PAs3fV7xwy18C9UOLYvpvlvzpUYglP0F139JGVetOcPOOG6fmTwtaJZAUgkVH/dNtdS3tYkVwpoe5D7BoIvqUPlTZmIV8lkSa0SqzF2I9NIlCkg5dZs4w0JPgWuN8SD70mnSN9f0SveWufkDjcs6WMg/Fb7ftYpNRSrZupDNHlrsF8NpTKfmDr0LW6VIbfP0H2gZos7AsIHzuO680xF+3/+iZNEcEq9FvLs+c0zsvD5GshhchO3OLrqet+/g0wPTL1sGkeeUhULtTKw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 28, 2026 at 12:45=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 8/20/26 20:55, Kairui Song via B4 Relay wrote:
> > From: Kairui Song <kasong@tencent.com>
> >
> > Document __folio_split_unmap_and_freeze() and
> > __folio_split_unmap_and_freeze_file(), and rename the file split
> > helper's definition to match its call site.
>
> We don't really write kerneldoc for internal helpers.
>
> If you need excessive documentation for internal helpers, it could be tha=
t the
> function semantics are not clear enough to be expressed by a descriptive
> function name + variable names.
>
> Sometimes taking a step back and questioning how the code could be rework=
ed to
> be more self-documenting helps.

Sure, I don't mind dropping these; they were added during mid-review.

