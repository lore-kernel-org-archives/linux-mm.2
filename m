Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E125C88E45
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 15:20:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 566AF6B0093; Fri, 11 Sep 2026 11:20:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53F5B6B0095; Fri, 11 Sep 2026 11:20:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42EEE6B0096; Fri, 11 Sep 2026 11:20:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 10B7B6B0093
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 11:20:17 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 72087A4536
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 15:20:16 +0000 (UTC)
X-FDA: 85201842432.09.FA94562
Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7F7A240011
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 15:20:14 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Ehn7xQCN;
	spf=pass (imf07.hostedemail.com: domain of surenb@google.com designates 74.125.230.204 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789140014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yk13UDKhHBWrmRCnNILsAJ9pW2ZdOFTsJD8wrftx0/0=;
	b=3Gd4ohtM9YibagRCCwHoQU585JorhveuTpAXLMSCaPz1n6mWVW5bxwG8kCo1UokT5gWxHA
	F3iTiFZ2vK8acK/SCCiV59/bTYJSeGYBLpMvatNFL+nWyg+GgS53C0PiWKUVMemX1IIRRf
	0wEdd2+NpV05I6/Exfa2C4/qhcRD41M=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789140014;
	b=PhcYlFpmMOiVfKQwGlJzXzQr6rlMLFi215XYKMrqaJNRLL/yJfae5fXO4OeM0suO3GG3Jy
	1PV3z24QUcXUzzYGwWsoe/SDiZVby5TMCFWxr4aKFg62LyUMkh+RBkMx37LZ7GwXrpLIZs
	MHRx1t5mkRKUkSPaojvK5rShMJXhC3U=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Ehn7xQCN;
	spf=pass (imf07.hostedemail.com: domain of surenb@google.com designates 74.125.230.204 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qk2-f12.google.com with SMTP id d75a77b69052e-530411c7ee1so24461cf.0
        for <linux-mm@kvack.org>; Fri, 11 Sep 2026 08:20:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789140014; cv=none;
        d=google.com; s=arc-20260327;
        b=OviGQ4ehon7t6D9vHWh4VQ9yJUOd6jAf92b1mrM5s/WNZlMHen3CEoU/1uu5Zfx/Op
         IsWx3mW+tWHkPJRcn3vAbPkjAVd0LNFAtWOfjyrNGdDn9ErzUAJ88hREdMl+Xi8Pk0YM
         53ZKr6gNU8a1QbZ2aUKVL3r4QqWqjLciIJZ6L7BsQGoo3LsqDL81fWi1icuaetU9EuWh
         Vs1ccTpU8gxSsFCB5bBfk5PNtMaYuinnKz5lr+1ryVs1QN/4BulWVWd/oM/Hpi/ydgKo
         j+m8OsQVcKJZ/MNeP9nhP8TdCKvQCFVRid2kDU1FCeJR6yrNSWiTvAa4svvkP+c1bDM3
         BnBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Yk13UDKhHBWrmRCnNILsAJ9pW2ZdOFTsJD8wrftx0/0=;
        fh=ihTK3SidjUkxEl7ZLEkI3Yoq4K3sfTI6VXp74QJWbhk=;
        b=Iny81G5dUfBpIfdLSC2RXEfjZh1gabgJ/jP9wCJMtAuVl2ejdJ1oduLFvY8Kc5tBJz
         qAtBa/6NKTgS7xwgEwsuYICEbcGPrsidaxGURlpGjt5O54VR2TRq/AZJm9rzCq6PYkoM
         RTh9xotH059/QMHj6V68K33wezHCkiaqlb2nvehXZvd8Kge2kS0AVDRw7bzPFo55powJ
         TYx2XtqjxdMNoh7AeHwrecQCjNQFgEkMfs0fnLI+PLRe+IG9jTau22hiLOZKYuSR0wHU
         ujVn5aTW81dH3memhs/IYoCLVcvep3Gi9WBZYQ77RH6nPYCmOkjedaqXUh/l1YKS0KPs
         e3gw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789140014; x=1789744814; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Yk13UDKhHBWrmRCnNILsAJ9pW2ZdOFTsJD8wrftx0/0=;
        b=Ehn7xQCNWlV0ELuaYyEWEzUyR1TJiT6mH2+6OGeA701FM/NNLEfjNOwdsFRnn2SEEH
         EYMh3HO7uI0HTHBdpsXjnHq83CAPPv73iUuX3jq4JrwWDzwOhjV5v/GhnAK3CsSKPBGW
         cpVXB+E0p6q8cLNPeJz7zPYNmUmIoaPGvNa+i1I0N/vDXx2CVD3GvFP9DOizmpWGfYhl
         JzTpFrIW1uphTHPxQDBiRtW0ia3BgcHqxBBAwaMBKbG138Tt0x1JfEhGIknJHIqiMbEq
         NvpQJ2d1mxsTK8EJPdy0c79TagTOy4ezQguuWD5ee6f37foK69dElWhbsX6xHsyw5eUu
         YjJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789140014; x=1789744814;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Yk13UDKhHBWrmRCnNILsAJ9pW2ZdOFTsJD8wrftx0/0=;
        b=HQGmH6cXnyahyhNYoldTdxr1tgClKUkSYeS0NSJsh+TP4mpDuNBF/prfzq+uw2I6x9
         SPGwKMIw4WFEl9f240hNz98gb9HWyVKzxnvuer03ojbdA/jM4jkxroBMkqGmKLdipf4E
         N9ZXdXSDd63F1qAqRxhNv32wmEUUO2bfg854plpPsJzEu0FyXddA6+KFK2MsNmABdjBH
         RtWDUEjoiOPdtK8PhHYDHmzRe62H3qgumfFJTq36V6ZvHTSknpbOkNrMTJmIJBauy7OM
         0AUgtBJnwFc/dyxSYhmFsTE94hLaKQ2YR5WFyGq2r5Ad+tUoyQJZLvI5wVVANXEK49Ag
         In/g==
X-Forwarded-Encrypted: i=1; AKwUvByOs93715knjErqiWItYQmN/2SsjMkn+qmHdt2rAH5aE3iSeFEfZdF0guS8eosScuFACrNEYVTthQ==@kvack.org
X-Gm-Message-State: AFuF++l6Ztx/Qav60+s7f0zd4FWRsb5Qeybwh+nkusQNq3QWUx5YWueZ
	/YF2xisZ8V6N6CT0Y2+MMivL17Pj/HFFQm5S0yg13IchwmOZMsXOW7NizcaSdjlpGoeJixV+1hw
	w/Z6lhyRTKUQ18PW+klUtOW+UXeTCVVXb145addI8
X-Gm-Gg: AYBFou10+THAQjiv2kHU818+CWYWNd03B5+Ck2P39gbwdl3v8gUMJC7bLLYFPx4juwC
	bVruTcC/7bowIKJkuMaJrij82EVxMMREYIp6MMaNA6mlOc0/lEq/DlKxHVSIagck9n0sNl/6Eip
	rrHF4e2yB5L7UZolU8NJhiSJWA3P6GFtKLgd4NydQwtwPRf61QCPeKVaRUbQuZEad22kf98U7U6
	6XgYw+BNS6y05uo2I9tTyXGen/v6L6Q9bRWFis8PthpPnnLrHsXqTMgKATJaD6PTlaU5aQ93MTh
	+FaBnpqbT/r9EqmKE3Hrufms53an0L7q2A4kHrAm90UT7lZYTZi37riPr3r9D/+9KUA6TmGnPr8
	xz42kv4k=
X-Received: by 2002:ac8:5d11:0:b0:530:39d7:ef48 with SMTP id
 d75a77b69052e-530cb49695fmr15549621cf.3.1789140012704; Fri, 11 Sep 2026
 08:20:12 -0700 (PDT)
MIME-Version: 1.0
References: <20260910234737.1340642-1-surenb@google.com> <20260910234737.1340642-2-surenb@google.com>
 <008dcaa3-2068-46e5-9e58-afb590d90584@kernel.org> <CAJuCfpF5CBrCxZWm+Luopf2gq_hHxsbw0QptNhfRT=+KjyWbJQ@mail.gmail.com>
 <88838d36-ea5b-4c76-b785-cf2bb71e34a5@kernel.org>
In-Reply-To: <88838d36-ea5b-4c76-b785-cf2bb71e34a5@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 11 Sep 2026 15:20:01 +0000
X-Gm-Features: AcwNN1Xk5ADz_rJe0NJkhhPYuxax2hrdjw3AnJOLY-8G8UUIe8p-ZF3eb2mA0Kc
Message-ID: <CAJuCfpEvyfR1K2ZjM2-AnrfQtVwHiD7zDvHLqfcSCUyfteYzkg@mail.gmail.com>
Subject: Re: [PATCH v3 1/7] proc/task_mmu: remove unnecessary helpers
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, liam@infradead.org, ljs@kernel.org, 
	vbabka@kernel.org, willy@infradead.org, jannh@google.com, paulmck@kernel.org, 
	pfalcato@suse.de, xueyuan.chen21@gmail.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Usama Arif <usama.arif@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 736pw6ehit7iu9y4yyj3g5858ckm491q
X-Rspamd-Queue-Id: 7F7A240011
X-HE-Tag: 1789140014-450207
X-HE-Meta: U2FsdGVkX1/XikzKq7WtKrph/5nG94pE21sifs2eAssSjLyMhFgznV3Cl1aFqfAq31ey5nu6aFB2IxookEKGrnRW+yXX+ethMSVaxJPJzTwyojKUQN5s7RQOMufi1EmVvMy3IlVlMXq1kgz4ZArrwEJANakeNUdm7RSC/iW7/ToZK+Ldv3deFw+bSU5bBMyyz9TFXL6Fa1Wny6JguWYLGV1Nd12wOI5DT8nWZvQTcIllf9FXIvj2vxJT/Ge6mDGy1VVxsY8ssOhZXgjSsog59Y724lTIguNk6FS3t20YthTC6uYnuFyhj1ouXcBCb9mrG6Fw9FtOrKCN1gG5KKYLAaBaE/8djSpg5h1chfHokK5cyx3sdrUDahnb6c3Wn3ZUBqDjT28nTSjO0fVnuuSy2KzCgAe/Auz+Ml+VE0drNKN3VdSDS4WaQngYGyCgFe0KVEhSTfsA71a9yzcDqNNyXTYmbGTY4rUxkIZ+kvXjBvIkaQwe0avRPJtcak8xznqRK6ZQ6i01MnS/BavNZUe//zGLu9QFpvlHAhvow/UjtzsyWDsgP46kdlQJwuyeBCZcoQ+hYqBTMFs7c/TM7Jts2uF6rqPA9K7fxNLrfYV9Fks8J0a62jQGG0iQMm8DjvbBXuPAZ1o0LwL1bvcpLIzPZorPsw2kUqEwuguQ7i5QEKOBbp4Kp1B+whfPor1yCJQFI4qYjaJfRqzahfGLZ48C8troxVZ46D/lS9Cu/8eT0FAeC36t1yGdqCT9+YkqbiRWn6FVK+vcepgpH52PKVWQLFE0GPhGuEFEzH4y7A067vU+cQ2bcS8FcGgHnOHdi6WvfnA/pjaUmPtZsjXE0z5HYu1kFPoiFRMjkDIWIvBXoHGahPLt+YrqpN/j85AgzQ39DIbCs1xHWKRkOpfC+imrst3t/3lHeisUG9JKZc4jwM3UEApVN9koIxE9Mj3NWbgTaS8aItkYrE07FzrDbBW
 YRMP+7rw
 U/O+c3B4yoq8u6wLWjVaa4S9iexApjs3YBvyej/gWe3BJ0fvP9Q+P2DqZMAv/s5KSg349Cq5dAcJOP88f9hSkDE3O72sCfYuabjNadqD8o/nmhE4vRBmLfhZcYQujOz4U0Kn4+Q53nrbwUz/cDcgOgkIZZkJ710WRiuFB8NqALizTS0vwAjpDRaIxT3s2/iZfYy2+pEd7EblvTwqWBnTOZCm9T/jOrdm6/wQBbEAnoyN2jS1UFKgUd6IaCqDYEPuiJ0kxwJhRP1Em9R9GygkagJ655bVQv7u0XtS1YbOxeYNqD06/Nojw4lMOubvLtVNhSC/9ARTi6S3sFHTy7JwcDZGXS3zZV9KeKdBI9SbfeioFPhBrn++FIQcWw2xWx782URF4r7JC+xLROVckop8IRa1B1p4tGb+aoskHK/6rJ0EG2hwIlXukto/z5ptygNyxQEp7szsvkhX+0KP1FGF+6GQoWw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 11, 2026 at 2:58=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 9/11/26 16:28, Suren Baghdasaryan wrote:
> > On Fri, Sep 11, 2026 at 3:52=E2=80=AFAM David Hildenbrand (Arm)
> > <david@kernel.org> wrote:
> >>
> >> On 9/11/26 01:47, Suren Baghdasaryan wrote:
> >>> When per-vma locks were behind a config option, a number of helper
> >>> functions were needed to simplify the locking code. Now that these
> >>> locks are universally available, we can do a little cleanup.
> >>> Remove lock_vma_range(), unlock_vma_range(), query_vma_setup(),
> >>> query_vma_teardown() helpers.
> >>>
> >>> No functional change intended.
> >>>
> >>> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> >>> Reviewed-by: Liam R. Howlett (Oracle) <liam@infradead.org>
> >>> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> >>> Acked-by: Usama Arif <usama.arif@linux.dev>
> >>> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> >>> ---
> >>
> >> I think you CCed me only on this mail correctly (the other ones went t=
o my old
> >> RH address, I thought that one would bounce)
> >
> > Oh, man! I used an old list of recipients :/
> > Should I resend to avoid bounces? So far I haven't seen any bounces
> > even from the previous version which also used the RH address.
>
> Odd, I thought it bounced for a while (maybe it has a new proud owner, wh=
o
> knows, haha).
>
> I changed Monday my mail filters to not catch to/bc to the RH address whe=
n also
> CCing a mailing list ... assuming everybody got annoyed of the bounces.
>
> I just reverted that change, so I'll just fish the mails out of the maili=
ng list
> folder and should also get replies to the other mails into my inbox.

Sorry about that. I updated all my old recipient lists now. I thought
I did that before but apparently only for Lorenzo :)

>
> --
> Cheers,
>
> David

