Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D53FC9830E
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 16:21:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B1F06B008C; Wed, 23 Sep 2026 12:21:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03B116B0092; Wed, 23 Sep 2026 12:21:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1D5E6B0093; Wed, 23 Sep 2026 12:21:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B09986B008C
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 12:21:30 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1DD7240791
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 16:21:30 +0000 (UTC)
X-FDA: 85245542340.22.35F85DB
Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2EEE810000A
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 16:21:28 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=a9zLokHs;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of kunwu.chan@gmail.com designates 74.125.225.141 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790180488;
	b=v8zooReJobmwAylQDrG0GRZh2iIUCBNM0fjMUMMClUtL8R4KchKvxD7Pfnr8FxnDXMEPhq
	jvGzRUAFw/OucimOZsYQKIB011QQpOK68C9jO+/tyqFOVrnXH36dNn4lREerfW9tSQ9pg0
	AlyVZww2UcCM/maRePPiX9ouh8mMTt8=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=a9zLokHs;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of kunwu.chan@gmail.com designates 74.125.225.141 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790180488;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+gZQqC9B+BUDyYE+tMiw8bRYJDZM+j4YKIzRl4ESdRg=;
	b=qk4P+2930MyMpK0DCvirHJMyUUWyTnLfvKxKk1igmUNr0GmgASrohAgohlkvtmGvczQ2ec
	LtGzf11QxrAcC6IKezO/Pa+vffxG6VYoTSNNcS2qHWJMFU6kJw2pJJEuiqX7BDH3k1WYDy
	phOuWpllUAyDdlHu4koFWQ7gytBwqW8=
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49ccf3ca626so6392995e9.0
        for <linux-mm@kvack.org>; Wed, 23 Sep 2026 09:21:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790180486; cv=none;
        d=google.com; s=arc-20260327;
        b=lnJW/m3ldzQCVyzOAubCVotvqFcQ6mPH7TmpWkxfX18fvZHnFAEC2PkbNSZjIwQesD
         GlHQxPKNg7fUwpcXzfa+539MlU0vk9EkqdmmBkc8UZzuy8UQa7Rtyw+2kQ6Q3Ww2xtUI
         13XkH6Z+1+Jhd/ph0qnF/UWg0fMKN3xUiiUZA7qbLTscsapA/xlbYhdrIm1Wi8Jkeg0+
         bzLP3dKCA7NBal/HiHuMVGIfdcAOgZNkvE7FIngB3rTws4DpmYMTMfghxkZR9Tb+CrUX
         pG9/TiiyARSKFOr1yMa4hNTn7yBjcqCBnLojK81SQothdTVC2xxGnlAhh9jjVLNwUfC7
         KfBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+gZQqC9B+BUDyYE+tMiw8bRYJDZM+j4YKIzRl4ESdRg=;
        fh=OiJcMe8JZPxmC4pC/jVA2VJbXkaHNNgojC5MnAWDPtU=;
        b=C3AybQNQYrhJ/0hTzmCuX43cjfy5N8gpO7/0/ZfPMwEOX8+wftIqu5STWBWDkNuz1m
         VqXJBMagVmVpXJKrnocGX+qbzCIKRfqaWjFQdwbMfo+u2JQF3701uoDPreoKu/PwDlJA
         Z/714KTtZR+jllWAMCX0pjSA1x3uJFJeSOL7dnNxr6lZ7gOmZUqFMog8ncqITHr+jMmg
         ZZOTCU6feIBVktJKqe1EN81fWf6qKXCPJPl2PtXZ4NOsWhKaakpVMw+8OvCgnUgs5Z1e
         QUMJBktQYtq7hk6lNInMdyXSG8AAMhef2CX4jnCK90tTdBTJNQaSpPDoP/1e144ROW5m
         0Thg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790180486; x=1790785286; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+gZQqC9B+BUDyYE+tMiw8bRYJDZM+j4YKIzRl4ESdRg=;
        b=a9zLokHshCS6eNo3kSWhcED75HRC8XubT+m50QjHvmr5MhH8dzXQkxjZ7ROsABiHm3
         RWspXhR9ER8Bnm5yQ2jWpyHvCyAr5CZgP9CLrxLKdqL8qwHBBivsc5DxY97CMkfcx+qo
         v7vkc0wU+8NKrbIzzlXPdHEpOq/+RxzLxKMDFMNJ1PH9GDt4RXZUUzel5KiHiAKMMYID
         TUzPImwRLEwIq/wk/B5ghLx3Gszxmbdf9lYH0MCbgP2UjjsYXF1g0Y8ZsJwvkOjye8NO
         KfUE+dU59ju6FQRwweM6mkTmiNQ4mRwllZK8v+bnsZwQ3Rwz3AbRl1HQHTlK0rNT+3BS
         oWhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790180486; x=1790785286;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+gZQqC9B+BUDyYE+tMiw8bRYJDZM+j4YKIzRl4ESdRg=;
        b=ASKmP9s74RpiZ/GiE0+dqzoEeBHKhJ88qKE4agELw7dZlQUdwymJjWZESw1MpgCmhO
         gwVrGqrtDa08Qc6A1vhhcM1jjWpTIPWeHBmONai4iwypDeQP+1B2P7pQ1XJzagxlYWoe
         raHvfd+AD+A0pxTpI4PyilSCbUZzFBP9oBvFqtASUmdzXSLD2rhdPV0xeRUbNlpupZSb
         dIq7YOfWdwfLXybykL9Qm2ErmLZ9wjnbZm1jhf7ttcy8PzWL15DUy5z6AeewmEhtZM5J
         LU2SjUY2kgvj2tEKUfmlHGWSqyQ/4J0GLIba87vB0n6OSvtLQRn7/XRAevEhz5OzXVG2
         Oy1Q==
X-Forwarded-Encrypted: i=1; AKwUvByioVKhqtyj/DmJm1c5HKtTIIfo4bTc1ldgKS9jqvZXwOwD0o7o5T02nOaoI/HEIeWDtfHYI0hcHg==@kvack.org
X-Gm-Message-State: AFuF++kLDg55dsL0zjQBih6AnRfxBIaqa1eHvERjfH7d0WBLLg+KyG6z
	k6wBI3MnA7R0w1Pr9zSDLe0AKXHUcd5GICw2PSiOef3B/Tlt/ky/pXtfI40xV/fVFbIBXk1FLid
	nFHzenkJ+GMk5IoKyv4eCgmSuzQqC+Sw=
X-Gm-Gg: AYBFou3aYt4j9G7eTa6/08cN9GtaNawtEUJUcCL4VkvsTHC1y5K8VKaed25iPTk6U2o
	b4wnCsrlQRSdrwGtOix7GlQx6mHHyDqCLb0pwyUY3KvkjesUAzlXmzxnZiMSMEyLM2mNBIP41lJ
	u5ho+fxwWhFxGvvPJUNyXCRxtPgOS6U4cIb8hfZe9k+8anU8/fgevJIp4OUgzljwpA4BfpkantH
	cHVm6T5VmidH4okhWo3qr1IkP9RfAQLDJ9VGVppTm118Gs9kiqz6TYM9McGXKWenNCoQzXnI95R
	6f0AcSPG4SaIClHI1bRiMydMNBIzrVrgNramlQEWhhytq4Evdk7Anb6WDMAgVF9KVPAir01Qq/Y
	WCkstRNwSFdU6
X-Received: by 2002:a05:600c:1385:b0:49f:d6b2:4dfa with SMTP id
 5b1f17b1804b1-49fdee0b74fmr42450225e9.4.1790180486307; Wed, 23 Sep 2026
 09:21:26 -0700 (PDT)
MIME-Version: 1.0
References: <20260921152449.629486-1-alex@ghiti.fr> <70cae945-3a4a-40db-96ac-5ce66a3fa186@kernel.org>
 <CAGsJ_4y8-wD0yMV8GCtCz5MfNrOKqUaTd+UgH=8MoP_nuvPnGg@mail.gmail.com>
 <108487b7-0529-4282-b5f4-355804b4c0cf@kernel.org> <CAGsJ_4zGmGh70QtRBpnhueev3qt_bgB4ZiE9fkW-hgNjAVhv+w@mail.gmail.com>
 <2e695c8a-4212-42b5-bb51-fbe1aa162e1d@kernel.org> <CAGsJ_4z2nakqBCKd_uAn4bfub99r3NJt2spOUx-K0M7bHW3_-w@mail.gmail.com>
 <4c7c6ea0-84a7-45f6-989c-d1502b90694c@kernel.org> <CAMgjq7DeYsJxG_VCf2KnViV5nd10m-PPYzXRD1fi8QcGWwD0qw@mail.gmail.com>
 <d9a77381-cf88-4726-9223-c16a5c6608c2@kernel.org> <CAMgjq7CLGyLHi7Lb8WF_m9bWUHpMRp_uDrqYNRQsH2GkuVQ=Ng@mail.gmail.com>
In-Reply-To: <CAMgjq7CLGyLHi7Lb8WF_m9bWUHpMRp_uDrqYNRQsH2GkuVQ=Ng@mail.gmail.com>
From: KunWu Chan <kunwu.chan@gmail.com>
Date: Thu, 24 Sep 2026 00:21:09 +0800
X-Gm-Features: AclHuK_BdL6NqIQOym4w0mnD34hD2lehVVu384RLkcQrbTLuEv6NeiVb7h4sMvc
Message-ID: <CAN_Opa_PrLP7mpF7gRjQUKfoCJGP7KvZMB-23bPUG269QASHpg@mail.gmail.com>
Subject: Re: [PATCH] mm: madvise: drop MADV_PAGEOUT folios at swap writeback completion
To: Kairui Song <ryncsn@gmail.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Barry Song <baohua@kernel.org>, Alexandre Ghiti <alex@ghiti.fr>, 
	akpm@linux-foundation.org, willy@infradead.org, jack@suse.cz, 
	liam@infradead.org, ljs@kernel.org, vbabka@kernel.org, jannh@google.com, 
	chrisl@kernel.org, shikemeng@huaweicloud.com, nphamcs@gmail.com, 
	baoquan.he@linux.dev, youngjun.park@lge.com, qi.zheng@linux.dev, 
	shakeel.butt@linux.dev, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, hannes@cmpxchg.org, mhocko@kernel.org, yosry@kernel.org, 
	chengming.zhou@linux.dev, tz2294@columbia.edu, hch@lst.de, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Stat-Signature: 5i8x9oh7mhy81otjify6xoecu688ep7w
X-Rspam-User: 
X-Rspamd-Queue-Id: 2EEE810000A
X-HE-Tag: 1790180488-672341
X-HE-Meta: U2FsdGVkX1+KutX/IrLk1OwJ53XZhLsswGgnDqvYOvBQ8u6JreWhM2s5jHLnzFr/QqTMMmbfF14M83lMj6nBgCUpxrmhNV0aWoXVExU1elr6mwEPjdx5j9+q5t7ZhKjOa6uK9ABw7oudBXhmp+E0kuYywQ0bYheFmHguwgqKKN8OCBMD2medIgOz86fBpI1Qe7wSTZYJ0wvEjXzi6rVrMs1H4yftqG4iPFzEyFgLzPeKirecn+1n3ZC//eN7xEbwH5rI3Q7X0o6Vu4FvviBG5qfYATNboQebqUky15bJ65blfRX0E/dsqvM7MA/A3KauFOO9Z0SZdZeNgISWM5C0jUOxboOXHbhtfA9I/w/sM67CLS9PEyGnpT/6tpEkv1cpcuX6juDKR4gkI+mzkhv3B0uKNy0TZ1jg9uRtYAClTK0Jwf7jk4h4qaE0i9qk/t0AlVSjnKTngsKKD3p8mRSclzcX0cIiws55y856+Z8xnY6uO9ZgNPn9r4MNsKqnhg2sWdz8OxZPc6J/hTc81oc4dJaKd0RroGeIGS4vmgVRopy0gBBpS3a/6EmBxBtLjla1+fBYEEMA2nazhNe1BEyXo1H14V6LMOMqsJCqXN8dqOibSjPpUE4mzilarDo3kgo3e5zM2WrLDKSzAIWygzIlkRPM1wMAfzDf016lGgUb4IBeEtletV1Dyey8S6jZ4n7niyCKdiH4M8nIxvyIjr1DQt/xgqZwDY9kQHYIzg+NCrrLQ/uTrsw2pVVznEBF0etteKHupJV40eWwS/q1RWgMPxm12ciobiLw5jvS6xC69pmmEidHjaASdL8pfoKDHBTOkEJ6JU2S2z9qm2S2BNu/B2CARqOsDXuOdJtyPxUm/Iu5/cvzd72SfU6H0V1Ulmn12UPbsBDxhiYDggkGslBV5kQfL42QBX/YcCO2NQnOdGcxS/rNkXtfFSrjqGDLUKe5SbH7IP5oW9p872FrwQm
 SbQgJwxA
 zixW49Qr0/95OtvajJvq8pW1QMZ1ZUKYO+2PTdv05cHdL7FDh2DJX2RGoqe5UsGysR2MOUwxaN0JGnvOSIsnmwTT0FUOQrA3fhLfTYTETbp6LCkUCUBN+Y+9TB8Yterd3HtdTGxi7GARzaj8dnrA0BXOHWqZrJMVtWb/+7eSi2AcrmFvJvixcwHUfC65ArskEjz02fRIgybjwbptEESbEwKpbPux0wj5YTsfE13k8MtinCweRhLGK6YeLzaHfrj2P00TIi2BRVBaYiQfv9p5hqqzxe6DCGKk3OUEytcOax+baKNgX0xcvQ7PMCRW9SevrSH1qH8WlGkOnug7RiuzsJQ7mE4plKjN4DXwm437AIUl55sacLWczkhd1EOn801+fYKo5MQCibu5e1e+ABr2Er32CKOkI+4afMZI/vMZ/6ze1mp2QjFBQZ5vtTHXajmPrfBeY4fr5aHRdqvCVGm/43rE53+COmhXWbkc1qwpLYY/0rVH9gKD/yEjsuJMEWyA5hRvTeJVEzuZQH/zYkcaBa/wA+w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 6:15=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> On Wed, Sep 23, 2026 at 11:47=E2=80=AFAM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
> >
> > On 9/23/26 11:35, Kairui Song wrote:
> > > On Wed, Sep 23, 2026 at 10:46=E2=80=AFAM David Hildenbrand (Arm)
> > > <david@kernel.org> wrote:
> > >>
> > >> On 9/22/26 22:55, Barry Song wrote:
> > >>> On Tue, Sep 22, 2026 at 7:26=E2=80=AFPM David Hildenbrand (Arm)
> > >>> <david@kernel.org> wrote:
> > >>>
> > >>> I guess that's because the LRU is not always accurate. There are ca=
ses
> > >>> where our prediction of future access patterns may be wrong, result=
ing
> > >>> in refaults?
> > >
> > > Hi All,
> > >
> > >>
> > >> Right. But these would happen in both the SYNC and the ASYNC case. W=
hich seems
> > >> to indicate that making the SYNC case behave like the ASYNC case (ke=
ep in
> > >> swapcache before evicting) could actually improve performance?
> > >>
> > >> Or is the SYNC case in general so fast that it is not a problem and =
the
> > >> swapcache is just not a good use?
> > >
> > > I think the problem is not LRU being inaccurate, but ASYNC case could
> > > overshoot the anon reclaim very easily. File folios can be simply
> > > dropped, and increase nr_reclaimed, but anon writeback (swap) can't b=
e
> > > done durig the reclaim iteration so nr_reclaimed never increase durin=
g
> > > the scan iteration. So the scan tries hard to scan and reclaim more
> > > anon folios, more than it really needed.
> > >
> > > I think the real fix is some kind of different watermark, throttling,
> > > or a different counter to limit the scan of async swap. I mentioned
> > > this at LSFMM this year but I guess I presented too much at the same
> > > time so few people remembered it :D.
> >
> > :D
> >
> > >
> > >>
> > >>>
> > >>> Even on Android, which uses zram with very fast synchronous swap-ou=
t,
> > >>> I can still hit the swapcache from time to time. So perhaps with a
> > >>> slower device, such as an HDD, keeping the swapcache around for lon=
ger
> > >>> could allow applications to hit it more often?
> > >>
> > >> Why is that specific for HDD? It's the exact same app behavior indep=
endent of
> > >> the underlying swap technology.
> > >
> > > If you have a shared folio, you must use swap cache, and even for
> > > single used folios swap cache is the way to do synchronization,
> > > regardless of the device.
> > >
> > >>>
> > >>> I don't know. Maybe Alexandre can share more details about this
> > >>> benchmark. I'm also a little surprised by the 15% regression in
> > >>> Sysbench OLTP. My initial feeling was the same as yours: we should
> > >>> release the memory immediately after writeback completes, for both
> > >>> synchronous and asynchronous I/O.
> > >>
> > >> Right. And see if we can identify why we are swapping out the wrong =
things :)
> > >
> > > I think we are not? It's about over-reclaim. In the worst case we
> > > might put every anon folio under writeback, while no folio is
> > > reclaimed, if the device is super slow.
> > Ah, that hints at the real problem then? How confident are we that that=
's what's
> > happening?
>
> Given the fact that ZRAM/ZSWAP doesn't suffer from this, I think this
> is the cause: the main difference is that ZRAM/ZSWAP frees the folios
> after pageout() so nr_reclaimed is increased (reclaim loop just keeps
> comparing nr_reclaimed to nr_to_reclaim), other swap devices keep the
> folios under writeback, and continue reclaiming unless they hit enough
> clean folios to drop.
>
> I can't say I'm 100% sure, and it's hard to verify but I think we need
> to try fixing this instead. It's not hard to construct a case where
> all anon folios are put under writeback due to very slight pressure,
> e.g. a dm-delay (e.g. 500ms?), 1G anon in one memcg, very slight
> memorey pressure could easily put nearly all anon folios under
> writeback.

Alex, One question about the `nr_reclaimed` accounting.

`PAGE_DROPBEHIND` increments `nr_reclaimed` when the write is
submitted, while the folio may still be under writeback and is only
actually removed from the swap cache when writeback completes.

Kairui pointed out that async swap can over-reclaim because
`nr_reclaimed` does not increase while anon folios remain under
writeback. Does the early accounting for `PAGE_DROPBEHIND` address
that over-reclaim mechanism for this `MADV_PAGEOUT` path?

It might also be useful to check this with a delayed swap device, such
as the `dm-delay` case Kairui mentioned.

Thanks,
Kunwu

