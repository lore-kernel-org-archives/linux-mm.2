Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FB05C44524
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 04:07:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3FA86B00B0; Thu, 23 Jul 2026 00:07:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC9ED6B00B1; Thu, 23 Jul 2026 00:07:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6CA66B00B2; Thu, 23 Jul 2026 00:07:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 641F16B00B0
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 00:07:20 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D2F76803AA
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 04:07:19 +0000 (UTC)
X-FDA: 85018706598.25.A8EF15F
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf02.hostedemail.com (Postfix) with ESMTP id E119380008
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 04:07:17 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=vjyoJrV1;
	spf=pass (imf02.hostedemail.com: domain of linkl@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=linkl@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784779637;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8K+zEl28QTXFlBY2G5c0iSNTDb1DkSYdmQKQjZLUJmE=;
	b=ofSFNwdcKOKPG2twUTmfLCsTWb5+LOgUfucAnDNPDrYuBEPLmGI3XEaNccV8npPFnknHtm
	LP6Itlvjm3XpXrfYP4GlIQo8I0xZkhLwifRi7Oo3/+PCDzGw5GFssBQjDNqEH2ofDCCvKG
	IQD+ZuhljVMH6/EYdtPACuQydXAk6w8=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784779637;
	b=CmCZWPAv7tMM3fY6WosGwmOr/qv35Dsn0QOl6z7eWfdSiYKzdP9VZ4nws+HPw7ME0EnzfO
	/aNLlMi08ssa4j8kpSCuE7ooLnLrmuQ0DIKtn+uI0RxneVz8sfOMUygQ/6AMKTNMJVJUes
	x89O8KkqTNhlJPgtZBJZEroLmpR6RME=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=vjyoJrV1;
	spf=pass (imf02.hostedemail.com: domain of linkl@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=linkl@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-51c10e86e52so70531cf.1
        for <linux-mm@kvack.org>; Wed, 22 Jul 2026 21:07:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784779637; cv=none;
        d=google.com; s=arc-20260327;
        b=BRCNogxBnWQV0RBAD4clrR7gNidhtWxOrc1K6wB1ZXhxYXd6StdIGwtT7YgW73/XN/
         p76hZz5xlkz803qyMYlh0ZVV6Dg5BC5VkPx6KEQhvZs9qUCmG1bCTFuwVzaEzKvP20IW
         g9Ojvs1pmzfqN+Yz7/8BWb0eO0flE+dU/VHds/HHA1YAtoT16TDJIziFlvV+5FXksgdf
         fjC64mKFjtvPf9XttiWZ+xBzDVS4nqCtzEwrAc6d91uNcZZMkfwfDrDQoe+BJEDCkjD8
         goJ5Qu/ytTOlrk9RIwMrZ65RX8eFLNV4Ih68wq5YxzEQ3PGAdZCAvRdmf60mGYlj9frF
         E63g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=8K+zEl28QTXFlBY2G5c0iSNTDb1DkSYdmQKQjZLUJmE=;
        fh=SuDX8bs/naHuucQ5JCUSpeSpspDKLHC/Wi/neufsc08=;
        b=ajEuuqfztsLpMVZuCa4imDL3F7arwwBqz5e+BiGZpDU6dtJu8buwvn9qGbeo6+3U4r
         QTxMAxX675k3cQyFSVlE8SX8X3F3cAoWPssTQex1zjieX5UqwvuuUo4VfFSquVPRaxeN
         hj+NhfLHYLO3A6ULqwGoUOcthqqX78X2cTkzMd6RXaa7qD3nE4Hf/ILArHsNYfhDrPk/
         Zfcmsj7a+1HHuIETJYB/pW/5XsujwZVRWuuq1uvwNQz9hUfLrTgkPA3pte+FuNnCDWgx
         WhT5GWsfRtKaqSoRBGPPgktFOLjQb1/BjAq7ze7tGpI6QM4lNcl22gIEX328hXPFeuRX
         ooZg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784779637; x=1785384437; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8K+zEl28QTXFlBY2G5c0iSNTDb1DkSYdmQKQjZLUJmE=;
        b=vjyoJrV1h3u+A8MGLVt6eizksf/DPFu7viy2Pqb3a7L7Lbl1UJSgWlJoQMy5y4UrAE
         kQlghLsHomUn2YMNL1L6dyUnZe6sCsrkFMSP75AG+67L8Rbd80/Jd7Ea6kmQoMuJXZq3
         ccQN+gb7gV1sEGMjNT+KLGUcQdegSOR2PzhpYQIM67jjNSJS5bnstUgU4mvJVPHlxsEV
         EOWjRZeZP9Mtz1htR2y0Jv/0ABN3oXbmQewJg8JART4vayIPtQA6JYt5A8L+T1eE9P3y
         2/6aGbmwW2CBJoVZI1A5k+Qk3ALhymqLhdKyE3ojCbK03wZfYCvlYFCLLdGT1L8d4Olu
         2BoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784779637; x=1785384437;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8K+zEl28QTXFlBY2G5c0iSNTDb1DkSYdmQKQjZLUJmE=;
        b=iw5It5QqJE8jsP9b6kptY5e8QPHpVWCP9DSCEVBxPnKcxuJAy/xc1IQ9zTnd37tG40
         +jkQ7RTI58/Hp5/o4mcDhTar0PXVnLvP8nD+0cSWSFdHeM7vA9A/H9syralVowHbnHCY
         bv0Ouec5swIIP66H95JkVox2QgfOXzEQPeI4MzzYM80PexjxExXs2RALOQRA7Ucw3E/y
         /BIoRw/RYC+gtYqRyvAS92vXlL7RZZAVcfHQfUAojKYhhTq9qcU7OPx7tWaNPfrUk9nH
         GHX2ZEKGDLQg+Fdk5HkXByzGHexFIiUDoVDx6sBpjzjMaptASW8uvZ5xBIPCXOUI7uFV
         C7QQ==
X-Forwarded-Encrypted: i=1; AHgh+RrrXHf7Lpt0xVUxLq8/L+BmXMD2iChhJ84nwd8l4MRt/Vv0fGvGaHpYabgeMSY9DLLvuGq4op6MVw==@kvack.org
X-Gm-Message-State: AOJu0YzkAcPGRdRDM0hVibDXQysjuVfmaIF8Kx1WDTDmGCeluGwJssI3
	GQYKSIZ4TAQqv6c8Nv1ZYwuApjFBj8bQVZzjN+nU3c0CJ45TwAhgzZD9uslYxJq4yHa0jyRHw4i
	WPsSSQBdqc55Z1VYmVkJRrN1h296o4JmKiYPOye8j
X-Gm-Gg: AR+sD110O5TbAR+LaKWLInIrYZJQr7JQaEYRs7pvSMhRT7vdOVfqjpkKG99kZlwqa/F
	8Ya6SutewKMQjJO/IlT4Z5jX7XNe7XF08C1S5TXrvxZzmp4cMZKMDz0lPRSkOk81E1EHkFORWxy
	4s7P/Zc6ClyzbHXiknQtXZfIK59QGWwkIOrpOPk4AQWqQq2/FnbZkdgnyiifTKy7pbbmidA8su2
	Gt2MkcfDsp1gUWouBjmzCX5ehz9/FMhx2NNfuGPQi4yj/3Lm5wSFhwKR3rACkEDSKlt3MNsYqxM
	xiVSvEd4J7LkhHNd0Q==
X-Received: by 2002:ac8:5a45:0:b0:4ff:c0e7:be9c with SMTP id
 d75a77b69052e-5283b8f3543mr6081881cf.0.1784779636303; Wed, 22 Jul 2026
 21:07:16 -0700 (PDT)
MIME-Version: 1.0
References: <20260721005603.1710551-1-linkl@google.com> <20260722173639.34d3f58413354218b24a5b0d@linux-foundation.org>
In-Reply-To: <20260722173639.34d3f58413354218b24a5b0d@linux-foundation.org>
From: Link Lin <linkl@google.com>
Date: Wed, 22 Jul 2026 21:07:04 -0700
X-Gm-Features: AUfX_mx3uQZpyv5zi_Q9zPvKus9UiXbRlkAo3cxV-vdSjkfxBWwgopwFhNLbarQ
Message-ID: <CALUx4KSfUUud86k4SLwETJAciRc8kZ9QocvBj39KmzXDiQ7J1g@mail.gmail.com>
Subject: Re: [PATCH v3] mm/page_reporting: use system_freezable_wq to fix UAF
 during suspend
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, "Michael S . Tsirkin" <mst@redhat.com>, 
	David Hildenbrand <david@kernel.org>, virtualization@lists.linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, prasin@google.com, rientjes@google.com, 
	duenwen@google.com, jasowang@redhat.com, xuanzhuo@linux.alibaba.com, 
	Ammar Faizi <ammarfaizi2@openresty.com>, jiaqiyan@google.com, ahwilkins@google.com, 
	Greg Thelen <gthelen@google.com>, Alexander Duyck <alexander.duyck@gmail.com>, jthoughton@google.com, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E119380008
X-Stat-Signature: 55m8gxe1qg7mh6jwmya65nn69zoxazk5
X-HE-Tag: 1784779637-916324
X-HE-Meta: U2FsdGVkX1/JmTurmpd7GmkRsMOO1B7TIYkrtk+s7hKWanGPSAnY2RGu082f5SAFUQqj9HNlMnFgfnL6tqpYsDpn1PYpdpFus3IVsqHWh3YQFsnnm2OihA8cUJu2X3a4E4H6ZBt21/hB06jZrm2V7j6NKvp/842rBiUFHCVNW4nnwrDkCG4jvQ27z2AP/FndX1AhT77QCghTft+2c+dv4xPs/4YMceVeGnaS9T64d68tcKTDZwiyqnXhDHqTtGFd3TdxoPhMbxaoeoxJven1KYYYes1PJuD0k49BinLvYtVRdgeo4YI1FHS6ajG4T7rZCPZ4B4SRCErFj0eFK5qX50jws72iRpfclFvp7ksCtiFW08eXinB80efrN1N43ssV3OIWUn19uMXHq4axZSj8YOqwJ2saH9NbNK9KrirKV9Hysp0R2hEYWHL4h15dhtpUrHxduKcV8MESOxguqjKtm7cCZGha4gouB8M9oSVJgh4zyTmywqaYxDC82DW4X6N40x6u/EQ5OHo6ZOTMFX6ejj0lox359XuBB1deiHdQe80U5Fw4UmdVXEjhu1bC25mPMB6waHiN2Ky+QxSLzQD1pFLt8/QiUMMPq8NB1x8tYmtSQ0irtvf2eXn8/8hT4e0Py4FxXrkaqsiElN0J9ykPmZwgArBzm1ycfmgGMLstPslOqtjsX1CHLdZayzecjrZ3K2rBGm7GK3M4P8FpkukNhAUp4fOd63idjSuw/88UaEFaK/EGsMMlOmqdugfgBfLMks0KQh9Vi6vFYYDLKA/nHVisb8tLe+jVRGyTxl/j+HFNULU3WytxHjex9QEZLK5KEcb4b+AVC8jOwZ9w7StN/vvuH0BTWf0RHlS+Hdb2pga3aCAT/8bj+CY1BrjNS8E/61A8BZWj6Q3whIBWbfNBaHaqXeRld+6UNsRKviT5lSfUyxf+/Z20v/MrEZTxW+ZEfxd9c+xe2gOe8WiAL79
 bJ9r1tox
 sHvpGwZqB1N361PI8xX+fHqjHYrI1/RcQ+sISdrtyRXDLp5d9O70uH35/KoQAVHN5UNteneKeUiDwQdx8JoFtdHtx46Bbbq7amTXgfyuzKf3J4mtUSjOpdx56Ijcue+SEK7cwEESX/B9sZfiXqL7ElQTR79izPd+ygAa+GnZtJ3xXdVS+gMP7qPl2c25PIcgp0BD0r1FMQjohaCF7pU/OzmgzT2RazA/TUPX+LeTb+UJpN4khppcw4FfxYUrD7IPXUDW1x85x+W62UDl/fZBd5UwRJqvv9yhRama9e9RmR6oGzO/LnJuVQhxL9WH2Oi7J7gpVu3qMI42QLkUHFYoUcEhIfpwB049jqQvz+tm0LKRnemnIkbTuzyiNShnZ26H6RTZSQEZIOW0v3s2sKLmmMpqQXiQg8weGEYekEFBC+vDM2Jg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 21, 2026 at 5:36 PM Andrew Morton <akpm@linux-foundation.org> w=
rote:
> hm, now where did that come from. I can find no such commit and that's
> the second time this very unusual thing has happened in 30 minutes! I
> wonder what's going on.
>
> I'll use
> 36e66c554b5c ("mm: introduce Reported pages")
> OK?

Yes, that Fixes tag is perfectly OK. I pulled the previous hash from
an internal downstream tree by mistake. Thank you for catching that
and correcting it!

> The bug is very old so I won't fast-track this fix into 7.2-rcX.

Completely understood and agreed.

> AI review pointed at a possible pre-existing use-after-free issue,
> related to virtio-balloon. But I think this is a rephrasing of the
> issue it flagged against your v2 patch.

I actually looked closely at Sashiko's flag, and to my surprise, it is not =
a
rephrasing=E2=80=94it caught a completely separate, valid edge case.

My patch fixes the UAF on the PM suspend/teardown path. However, Sashiko no=
ticed
a UAF on the PM *restore* error path. If virtballoon_restore() fails during
init_vqs(), it aborts without unregistering the page reporting worker. When
system_freezable_wq thaws, the reporting worker wakes up and dereferences t=
he
now-dangling vb->reporting_vq pointer.

Since it's a driver-specific lifecycle bug rather than a core MM workqueue
issue, I will write up a separate follow-up patch to address it in
virtio_balloon.c
shortly.

Thank you again for shepherding this fix into -mm!

Best,
Link

