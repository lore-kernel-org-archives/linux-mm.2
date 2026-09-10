Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DEBDC88E41
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 21:21:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CA186B008C; Thu, 10 Sep 2026 17:21:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 253DD6B0093; Thu, 10 Sep 2026 17:21:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11BBF6B0095; Thu, 10 Sep 2026 17:21:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CB1FC6B008C
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 17:21:13 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3E03640607
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 21:21:12 +0000 (UTC)
X-FDA: 85199123184.09.6E7CBB2
Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	by imf16.hostedemail.com (Postfix) with ESMTP id 49EDF180004
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 21:21:10 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Vd0Wz9Ss;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of surenb@google.com designates 74.125.230.204 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Vd0Wz9Ss;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of surenb@google.com designates 74.125.230.204 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789075270;
	b=SOyhbw7mAmu+Mg+yGQtNqEhZIzSJci4dCZDCZTcorcKcryV2Ri7/Z+clKN5OxhZZZgUW4s
	PZSRe83RxkxkWIfp26fzrQfgGB4U9IhBpJKKA8M2DTR0hz7ad4QOVisyhXMzKc00gAJO0d
	rdS0XMbFzu2CrwfboXN6qDQRtiE9pSg=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789075270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cPbVFgW9VwbajH9zUlcN4XglfWpRRu+3kWiEh6Msf9M=;
	b=rBCCK8wlN/ogaL8Gk7HAhnnW0F3ILVZglEbP1MKboagthxS/cFBJhf07PdilA52eKD+5PS
	BHreQ4zARg3sdF4/RwYnPYhhgxmac1xF+NzD/hyW28F1nXaqdafto1ZNyLsXRgdGbjgEjO
	50v3bvEMmandOJY6i+ZHUME1AJRY5Gc=
Received: by mail-qk2-f12.google.com with SMTP id d75a77b69052e-5306706e89dso27961cf.1
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 14:21:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789075269; cv=none;
        d=google.com; s=arc-20260327;
        b=hYXEWvASb5WEYpAyT4AOQI18ffjJzcgXZsQ3rlrMzjzNWcCiHQyrZvb/DQqPS6h2jX
         agUQeb9QqekwALntNFnTPerB6NpdhmbmaKaTL7MTWUFluqwY+234ZDGaLTKbWZyoP0CH
         45LspYlUDyI9RXbieVUZ+VEVyIEQ41pdPeeGBRGs1/MEDtJNSKsQUx8u6j6spGWux6s3
         Cqy+/1A+cP2XXegKD6O7IxbXsRAMqXRIUOZEbq0yoy7mi53m8C6jBmx6F/qQwo/hb8b4
         gbUq6Oi2TE/yS15o6M8xDQ/hqY9q6Mhq5EWEoy2nhwEMGPlPzmDBhPYHXWqxKzFMTQwj
         JsTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=cPbVFgW9VwbajH9zUlcN4XglfWpRRu+3kWiEh6Msf9M=;
        fh=Apm5TqGbvewPAvRi8S/LgBQ8NEc/CCJQ8mkbncwTxbs=;
        b=csrCktdCzcEd/kktnD6kiZL0lEKz7rcczHl8crCP0dk16oi5AZhjMpWMk9LXmmwnAy
         M25vFnR6buwqv9zPKFd8D8YneX25uEsmnXuJCbOZLf7m8/ACDrJM9b1NQMDB9kizgzJB
         rcFQ7VzU39DFDCaNrxJxokBorTfpH+3bA0LU06NG5aEKzx2UZomsC9/iRTGdbdyG1cyC
         MQAgEgXeEo7MS5Es9+BUk6a4kv5IJGB6i4QZIbhBc499y4iiqdTh12C3W7vOwUsiW8d4
         XtG2O6inXXy8QT+J8RojQlPIDEREdtNukZaMMGWJyhs7kZybQM4/1MtdnjTBH02K7PVQ
         xTTA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789075269; x=1789680069; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=cPbVFgW9VwbajH9zUlcN4XglfWpRRu+3kWiEh6Msf9M=;
        b=Vd0Wz9SsnWUW3THp8V+emjQxR+M+9ECl2vhZuxvXsMeFotDaPN2yFnUn4h9QtaGbva
         JLAr6nKGB7afnhRIj/yHiOI9u2p7xRrR3+PMv2MAt9T9BXrzGhL7qLGWJAoOS2vU+Fj+
         gPhb+ASjx3b5hhHIpDDMEageZu/BtjYfbmWDbvCrufFQRr/35tcCpPyu4oMU46LNsh02
         N63qej3mkjEASJ1MpnkDJEdHRo6NTU6O5v/EphKQeiYlDz/HtYxx4h5B7Xewcgm1L1AM
         qYzczkfvnb2q+KPky2Sr3Pzq9UKjzw6j8QriTxymDayF4dyoy6f+0It15HGfEOLe97nV
         4b2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789075269; x=1789680069;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cPbVFgW9VwbajH9zUlcN4XglfWpRRu+3kWiEh6Msf9M=;
        b=OlDj4CYUeRBPa8p1pWktHLnLvugx5+UbsJSaq5OMioPV9DBU/QL/I2iWWKpHHb5xXF
         8gcnZAL+dyWpTL4yh65ABT/nMpI79Ov8eOLgnvRb/EC8dJSuPQQkx3noViCCJCEUMrYY
         i3boj5ssQCqEGaRqeTCF4LTl3kBgTYR6D1J3Vdsf1VGs1aPyrgslgLMTd6HLAPQnhS43
         aJsyU3pqqgG/hO++w6p9Jjg5V8sS5EbSFBmAZKGEDEdVA5Ol4Q+HyYgsgfo4h2zqdsZd
         qXrPxW3tVjkNSKnQMbn0E95MGAjkD8pxzazcBDGfQeMQNC1LLvI+RfwxE+ZkkP0I8wsC
         Y6DQ==
X-Forwarded-Encrypted: i=1; AKwUvBx6f1XKg30Kr4P3SWLGSJ/oOnNRfcJ2/5THv7dkdls4/aoFHMQgs+4BogBlg/GlqJTlrnrid2LAtQ==@kvack.org
X-Gm-Message-State: AFuF++le8q1DPJYmJuMkwxqF0HTJdis/VSljpX/hifY97o+7jy3oWfTe
	XV+HIUtksOzIx1IkG5yRoqfGm3jeytH3INPV8ZYApO37Enf4bBTLBCXNHYxoN4zRfpjvZC9znqE
	D0f8gV++v/oBdERzJqaPQOFadgEtV3JafDSofXn5Y
X-Gm-Gg: AYBFou1y6Bqx2XxboWgYWKmKtndIpNeGRlcGYaoZQYimlaSBn6rsZUWYsKeuSe5X8zD
	MDNuJ5eSByeb6iA59nAvluKg1LCupE3hLUHoCGrsN5lXQOZWGB9UjuRxJ1ZF5Oh93YI0IiWyYU4
	Y8BHxCISdZd/lSZZhm+j4uopJlR97JiM8VMg/HC04l0YE5ItvAMYE2VN+aqNTpeav0EyHywM4xv
	W08FwhHQAsR0nyAdPiYNciaF+7tpAp4FHeTU3kEtyCDdtsbTQ/BQoPnzQHWAGMs1ZVgtVno5EoP
	7UZvc0r623eVLQqBKqnXz2ut4tBCrnZMZCGOlTn+Ej6k8gFoQX6ahw0susTHWcL3rgG+U+RMRyL
	iMSwSjNa4tQ==
X-Received: by 2002:a05:622a:2599:b0:52e:8422:a329 with SMTP id
 d75a77b69052e-530c94992bemr6190311cf.6.1789075268693; Thu, 10 Sep 2026
 14:21:08 -0700 (PDT)
MIME-Version: 1.0
References: <20260907063918.3432401-1-surenb@google.com> <20260907063918.3432401-5-surenb@google.com>
 <19e428e5-d8bc-4abb-b052-e23442464cba@kernel.org> <CAJuCfpF-xeED3zVL9YyCwrTUxcYXw4s6gVcCYY8p7rx_09mgLg@mail.gmail.com>
 <d24c425e-7913-4f80-987d-7105a8b13432@kernel.org>
In-Reply-To: <d24c425e-7913-4f80-987d-7105a8b13432@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 10 Sep 2026 14:20:57 -0700
X-Gm-Features: AcwNN1VRoq8CDVvkfELfH6Yzm9F4xeICdi1mk_n024FLQWRzxRX3c-6w3l_BjeM
Message-ID: <CAJuCfpF_1XNP87GL+z13OJqMqk7LNpF9yYNSs4qV7N7tGOTCww@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] proc/task_mmu: read proc/pid/smaps_rollup under
 per-vma lock
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, liam@infradead.org, ljs@kernel.org, 
	vbabka@kernel.org, willy@infradead.org, jannh@google.com, paulmck@kernel.org, 
	pfalcato@suse.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 49EDF180004
X-Stat-Signature: 31xnmheo8anz6bpxm4gec7darpj4d9sq
X-Rspamd-Server: rspam01
X-HE-Tag: 1789075270-858519
X-HE-Meta: U2FsdGVkX1/H6CkGbdXiA4T1ufgti2nRFU5HRvKEEI2EZweTuHTquPPyKJ0EDw1EJbVrDvz3YW6r+DoQx89ywocpFOIlgGFP3xPlVkO0bLQm7sqQoeArUQAY19iY80Vqzm3yIxPN90eB6NwgdiufaVAEkz/iDPfVj3hhiRIyGXQF+0gZy3Vwq2gZpkhNmRUfQz1PtgS5mHrqn3NdmuM4TQd/ARmO0pvidTyTpnOhd2IQanIbpm3SPV8ANYeVP0MIP2ALxM3yhpX9GxjXbxK1Q7+eANm/SoYVLN3UMUT9tSVpVv9bYUGoxhRdA8E5DicBdxJUyJf6XwTBODdzmou5gj8/igviVXo+Ti/UCbtzV7DyTiauAUoZCm+9kyT9moQjnV61hlU7q9d3lQ0BxXK8oc5UlMlbd9q0zjxQDwpxFGIq1dKAo8qPEL8AMgZOM7DD6huq2AH5jjRKvHyQOD2cKsLwtnq2906FMXjNHGfcNiSsbT4OrhYO42kDVt6FtpWu6a2+Fbv0LI6+Eeu4ocukYY1My3AItfsI0UNA4PGifmHu4b6J4vl6HQn9mR5p/m4CyjY/99ESOJ0S4w9BcAKmNLOc4rbPJb6DlIdHBKj+ChWH0jayBksdSz+l7V38GCHna7GBJoPzx+a2Wh8/c9+9rIwHsTUYEwWH4zcMunOXOFmjMUXWUliH1nW4kP80p+iLvzfAJvzyfaro4wCgb6hZODEvskXDNUtEsX8zRGftt5Esj4YKov299ZKacayldpmFPOu9Ipot/z3gGI731OHuiLIPfl/UofdNaS4S2kJsP+KKbZQTN5yDfCxQnFEk6/vap7Jg4Z8ZSPsLE+wkVLnV0A1yZW72/j8puHleholrzNKsbTDTKnx1UasDupcbzXZckloUhwKS+JHhAH4beMIUeBZMLk8hiuCLWVHpIr43RvDIdesGEk/+1mQatpsDzmjY3jAb5m3lRzMAxo5znK4
 MS2LoLrg
 8XE9S/crvEwgt3pFO5Wt1Y26f46nAdD7naK6ToIgxnwyFRNH3223172Nh5GO76UP9lyWdJmgfiPQ8bsmf7rO1xQikoJS/cezyLSBmmWAy8wRi9xyJGYsv0EgmRv0O3b355BjVvGZjMtr5jmITBrbdMh5dlJw/5QGvUXkrVt2Kw0feml5QHOG+bYfJvVP9iOSK0SA/zpTJsZa0UWpsRIU35+Abro5L70pp9yALdc6QowOAsYgIZi/H86p5R0DymS1Hdl1NcIrCvyZI0zjg6iC6+Hb7EArFC3ZO48W4SSgc1eWrGM3j+37B5fQ+kQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 10, 2026 at 12:44=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 9/9/26 19:58, Suren Baghdasaryan wrote:
> > On Wed, Sep 9, 2026 at 10:23=E2=80=AFAM David Hildenbrand (Arm)
> > <david@kernel.org> wrote:
> >>
> >>
> >>> -     vma_start =3D vma->vm_start;
> >>> -     do {
> >>> -             smap_gather_stats(priv, vma, &mss, vma->vm_start);
> >>> -             last_vma_end =3D vma->vm_end;
> >>> +     if (!IS_ERR(vma) && vma !=3D get_gate_vma(lock_ctx->mm))
> >>> +             vma_start =3D vma->vm_start;
> >>> +
> >>> +     while (vma) {
> >>> +             if (IS_ERR(vma)) {
> >>> +                     ret =3D PTR_ERR(vma);
> >>> +                     goto out_unlock;
> >>> +             }
> >>> +
> >>
> >> Can we add a comment whey we break (and not e.g., continue) whenw e hi=
t the gate
> >> VMA?
> >>
> >> (I seriously don't kmow ... should I know? :) )
> >
> > The way m_next() is implemented, the gate VMA always placed at the end
> > of the address space, so the next VMA will be NULL and we can break
> > once we see the gate. But now that I'm looking closer into this code,
> > reading smaps_rollup file does not invoke m_next(), so we should never
> > encounter a gate VMA (it's not in the maple tree, so for_each_vma()
> > should never return it). I think I can remove the special handling for
> > that case.
> >
> > Thanks for the question, David! It made me realize we can simplify this=
 further.
>
> good! :)

Sorry, my conclusion was wrong. The modified loop uses proc_get_vma()
to walk the VMA tree, not for_each_vma(). proc_get_vma() returns gate
VMA at the end of the walk instead of NULL. That's the desired
behavior for when it is used from m_start() and m_next() but not so
much in show_smaps_rollup().
I think the cleanest way is to change proc_get_vma() to return NULL
and move the part that deals with gate_vma directly into
m_start()/mm_next(). I'll post it that way and see what others think.



>
> --
> Cheers,
>
> David

