Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A046FED3C3
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 12:56:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 440946B00A6; Fri, 24 Apr 2026 08:56:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F1E86B00A7; Fri, 24 Apr 2026 08:56:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E5FF6B00A9; Fri, 24 Apr 2026 08:56:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 180AA6B00A6
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 08:56:28 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B8CB1A00B7
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 12:56:27 +0000 (UTC)
X-FDA: 84693448014.08.0A9A1E2
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf08.hostedemail.com (Postfix) with ESMTP id A8B0C160005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 12:56:25 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="sT5DN/jc";
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777035385;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tTcVUX5JhCczcoSlWAaxglmsZJfnn4N9O+4CcJ4MkH8=;
	b=Jkc0ujoRjPsw7evflYjeQ4TTtm0b3YPZVl3TFQCqWZ9dLIdXC+60Y1Lcbd7JRB7l++/kTs
	vxgUMrdtIbAQ1K0hdEyC0XGc3CJxUzHVBmj2/5a3ank4zo0qOqMXjBG7+wFcSHjG84v/z6
	x0uz7sSeqXsjA/zfeqendQ518Hfp9DU=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="sT5DN/jc";
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777035385; a=rsa-sha256;
	cv=pass;
	b=Z5iQL4qlxfUefi/989+9p4GK4JKzGVqBHXeGVseOiT9LkyQzeGqKAocdqd2T0ojDfmt/5S
	XxN14FmXb2ko9uc7x5ZjxBtG0tZHLOwK9iepcdprHaPOAQB5iTE/cmUyg1YO1kCcteoToW
	fr/uFaWsrQRezTMwYkIKJC7Z5UEZCxQ=
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-676d8582a13so6531218a12.0
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 05:56:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777035384; cv=none;
        d=google.com; s=arc-20240605;
        b=U7ljj/9MUfBjGWqbv7fKIrCoKOgj+f9l+8Gmfjnj57PyeBY6NJTovefe7KymDUZiVp
         v1RENJ0by3EaMLbo8al/ZGq2ZGnWm5nf4wLfZel4aADeLGsDWQ9XbW/uu0nXgAp9G9cz
         SbArGsWNb4nXMsf5tQHxClZUmgVU/vmbQwuzZWQCDkkXUzF8i4C7MXLtYyIUBPwdHV0r
         415Y6y2Lp8dsR2unxV36/5bwkjFMTB/VZe4YRZfjq0Z/3Z82Pft2oO4rvgikdZGkA+m3
         7CLCcuT4BzD63W2eBcrgFm0GKtlt4EfgEH+bIvJ8QyMXZElGiDHjDopcrq/qKv8GNg9e
         e59g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=tTcVUX5JhCczcoSlWAaxglmsZJfnn4N9O+4CcJ4MkH8=;
        fh=H8awOgofe9e1ujESOU2zM5cTDXjgfwcd8q93/hU1FxQ=;
        b=Yv4cKs8c9wyvb1n7Ufl24UBc4eVQ8i01Rs8X62+Xujen00zW4eLjxBtEv6zwwGFm78
         I+Lw7Oraxk4HMNPr4995+fabOlUvfYRUqEahbFo3OR5vblNCi+UlJdAZ+XmU0FLMPoWg
         H8XTDRq27n1WKAz3sncuk2TE+EvXq3Vr9+Odl7uSgpCFi5hKidAOIUzP+V3wLQ6nZFxk
         0BcJT588Uc8gmrGGPxoVIqATFNv9Duwauh2nnyD/l7AsYyE2iVf6JuVEEClkEK1veRNG
         bvfx4nr1jWfGtM2jIgbaQE6sLFBEyZ1Z/efjlwHAWrlVFYUdnBGr2ceQW3U5VwY39tIG
         W4Vg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777035384; x=1777640184; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tTcVUX5JhCczcoSlWAaxglmsZJfnn4N9O+4CcJ4MkH8=;
        b=sT5DN/jcFl8rfRChIGGnM1GE4kSrhg2B0VBZlFHW1G5JtBdTJiKVrZ7SZsXXsp3uyc
         j5T/oX6FIOu8tuW08378r1ALwD5k2qNj9uTVFwy+AQhcX5xJReaF7Q6wmoNo0dg9q911
         xIjULNl0ipqtQh1e/zY6Eg1/ZejnjhQFMdxnSyA/VtUq9P7kkg9nFDla+TAmhtt9YhUf
         q+x7HkRBJaeQTYzAYf2lTBztUKggUamXBQB2YwNhiVLmmPkWE9QZO6dg0YH50JT24bhP
         l0CMw//y/hbI28OuSZK/fYeFpdvebshST90mn0z6sEe33HYcvLNVK0kZh/xmSiZxOm/k
         I5+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777035384; x=1777640184;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tTcVUX5JhCczcoSlWAaxglmsZJfnn4N9O+4CcJ4MkH8=;
        b=oAa3RmKJq7DQX2VsCMfvRLxGhb/PKGe20a4kEp3ySKfHWDLR6q8aq+5lrks86FDYX0
         D/0sGRKISnq5FMYTom3oAIuciN7tWTP2tFBlyashurWVYJNcXWX3ME3CiY+mGO9kiqA3
         /OBpcicKg68SOtDVbPUq2E6WUS5oTxvYKKkKCJAag/nAzt5c+ABW3+VqDQJT4MDPj35s
         l2FW5UY2i7CgHKPJytcn/gfd7qPDpUaOUBAir8k8qoJQHOzsxvubfEqBaZII2zz9peTA
         C3Lbif5IFNcoqamfVrwaUhZbpl5rYw8eyCcawBV98eMchhIhYBdIabR9FAOVJkw+B3FQ
         EzDg==
X-Gm-Message-State: AOJu0Yy9Ly2C4SjpIhAhexkxxqwmUIz4pg9Mv8pjn5hmu8ZfEGYAJgpc
	U0h+VPXYLjd9aJZK6tdH2KCH+D66WeOV4umGfo+VC8m9kx83MUTRTNHj9kUsRPycbfZIEWSsY0h
	8X4gJcEYE8h0zc2w1qX8pbCmkCniOu0E=
X-Gm-Gg: AeBDiev5bR4yII8mubRTtzBEWaNAVARx+fYkHNchW7ngEimw4j1Wx/JCCUtzmXr3jwm
	/QVESHmlVgPTCPHQg+VB0OX3JTdMcaSk/4iwH20Wd8XWA9ql314Pc/oxnnsrvy6USY6FwqsWLSz
	gOoDwi9b6999G1qjgpePRGqsBKPnG/D7thf16iS3OqZPVuxJ+qxnbEx4mmoXtVpIL8n2t50DUud
	08Kpn79HpP1+03x4mdScNwej6Xx+CyLeCkwow2PjOW7PZXnwdT/5vWgBO/gl+6qmobVixgOItaO
	cuQ1LRqvXSxE0/UsobgRka2AFSiWt961MBiWBw2s+tpIFAh3e2E0DLxRMZ84EA==
X-Received: by 2002:a05:6402:90a:b0:65f:71ed:7ab9 with SMTP id
 4fb4d7f45d1cf-672bfddf0e0mr14905216a12.22.1777035383732; Fri, 24 Apr 2026
 05:56:23 -0700 (PDT)
MIME-Version: 1.0
References: <20260424-mglru-reclaim-v6-0-a57622d770c3@tencent.com>
 <CAGsJ_4wLc15iF4sa6z+i812vaoabAGHS5ErPpjRyjLGMP=44AA@mail.gmail.com> <CAGsJ_4xre-x0e+qNVm=KLFnO1dbPkPX5RuecqwvTZu-vS+o8yQ@mail.gmail.com>
In-Reply-To: <CAGsJ_4xre-x0e+qNVm=KLFnO1dbPkPX5RuecqwvTZu-vS+o8yQ@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 24 Apr 2026 20:55:44 +0800
X-Gm-Features: AQROBzAedSEH_76D2Py-HqxtpxgJTSPD9LOJgTLbTE-XKW_arC0hDvb_L6tRGa4
Message-ID: <CAMgjq7D1bzYd+WmdbkUvS_7sNmC-QKYYY2+J2Oy60njJx4FfJA@mail.gmail.com>
Subject: Re: [PATCH v6 00/14] mm/mglru: improve reclaim loop and dirty folio handling
To: Barry Song <baohua@kernel.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Lorenzo Stoakes <ljs@kernel.org>, David Stevens <stevensd@google.com>, 
	Chen Ridong <chenridong@huaweicloud.com>, Leno Hou <lenohou@gmail.com>, 
	Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Zicheng Wang <wangzicheng@honor.com>, Kalesh Singh <kaleshsingh@google.com>, 
	Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>, Vernon Yang <vernon2gm@gmail.com>, 
	linux-kernel@vger.kernel.org, Qi Zheng <qi.zheng@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A8B0C160005
X-Stat-Signature: xa45734uwkkksbdeds3jt1cenn3apfoo
X-HE-Tag: 1777035385-490429
X-HE-Meta: U2FsdGVkX19ij7jrL2uRbnSx78IeXhSIao3UZb7GXUg85yoEMsmoG2JC/jXKH6dGC6kxL+K97FDAXMmmtZ6+Z9+TE4/T/0HqDZmKnefmuhkizVuNDqZ7X3nWur36BC4jGaMJpgjv3iHYo5OxR32UqoRNQlIQZ7ZLYSSqCNOaumgkR/sUS9GC6s0iPDJSCLV0SNFSOPNMFwSC2FVBD7nQExhi8fKtLVSJ5z/dHaQdewkaSFw9JZk715rRTS8QuJJNSAHlaUeO1PhNAsNet/KyYg389XzJkiEO7AT/PtgpZ3lRgdLa6kDJGG/bFrkpYHCg6wwcDJ5zb0xq8aFJY2apX7DdII74hWLuuxV25tvgrVvzhQ3/fJpE7r/SguKsTFR4u1FTU+jGwE133LgfbqTtWTpVWVJ2+0yacy6XFMbFHZwf/1CtzzFuedOwVZk6l7z/Z+hC5upLRmiONC5ZpO1y4vdEbhlazvrkGDYSSHlAJUB/VlQOS3+IXKW5IHcMOCIcYRJXBlPqOioKI2+Z+EKVZtyyhCVY1OuKNPr3bsKOIRv2yDjI6tALdX+dnWszKkSgR81iAFm+VeySkdacSQxAVwnXUOdVqovHCi4qvuxCF+bR0/HyWTD8u5NBJWE3L/MWfuE+8u8GisaMrFVqUQLXsDSi6QLrpusXXj+060tyRioa6QOtF+rbPZL1fQmDP/Um0hY1sxPeKB5a5EK608O9go+a9mjbh28HPtdpzBEvwVIDnhQvAEx6AHvpvvTbV1SpBAPu53h4im+GANKzNjmLgf2gD33qTkRMNdGwlZyBaX3Gv/5aQ0UNyIxhXOXIkUfo5mKUyhDPBXZXnMn/UoIqYqpAIPs2mCxlR5EEEjTbaIzzQmyPyRJWvjdd3PA+SXW6LlTQ2N+oCsmpzsMbytCqAUafjnmFJuaNDCFHRplVBw+NKd9AgEkvXEeYqwW4mIqy0KUi2BHoA0pgLJOeTy/
 j/phK0iX
 bUApfN8b6SdIdej7nMQ5xN1/x8ce9ucjQeBTH+ZNHPYhxNaUFOz0h5EcUmq7mW7H1PtIM1r/Jtz/utuPokDEPOiQthBryewLpjvaefTw90SujwVE8JnpCprfbiSyP1gdsktGh70SwVRFlDnVu41TJ1kfbDUZF+pWHcujUDBBp2dSXj8JwqC9tdsXApjh6Wk/IEk2E7I5xGSmmIMbib2/rDtszXLjQfROnq2NBtxQGgKoGCbDYTXkqqLuiKXlXmkIjYKGZaM7srfwEJv4+uk2RZx5PSTC/KpOAjufmCnvyZptyORcAH8kxRuyxS2zY/oIqqZf/zT1BhD9vDOowpdEmiffvuFk0b3mr70ksihwsccG/casBGXGlZLcaOZSXZENthi2s0PMiYF+ZR5ws3PtltKuTkQZOVJzDSKDW0gDGI5T/PpRDZ19BQJo9iznHiPHqvgJd5McRTVjCKzt1LO8oLyKz2j9NgO52E4caeqaMQv+9O/Ze4jCu0VZf0eGsB/neO0E4y98LaIqhn1UoaWfKTmApqLt5a/nN3wbW4WYev7QaDMLRqNaKHXo6SCvW1mDZdrJO7NV2E1UhRAE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 24, 2026 at 7:58=E2=80=AFPM Barry Song <baohua@kernel.org> wrot=
e:
> Could this be because get_nr_to_scan() was moved out of the loop by
> [PATCH v6 04/14] mm/mglru: restructure the reclaim loop,
> while in mainline it is re-evaluated in each iteration?
>
> Will take a look tomorrow or the day after.
>
> Thanks
> Barry
>

Hi Barry,

I ran your test script a few times, and strangely I can't reproduce
it. Swapniess behaves similarly after or before this series. I
directly checked out the mm-new commit of this series (4ce85c040e0a)
and compare to the mm-new commit right before this series
(31a112f05f62). I also extended your script a bit to test more
swappiness:

Before:
uname -a
Linux localhost 7.0.0.mm-new-g31a112f05f62 #305 SMP PREEMPT_DYNAMIC
Fri Apr 24 19:07:30 CST 2026 x86_64 GNU/Linux

*** Executing swappiness 5 ***
set swappiness to 5
Running as unit: run-p6675-i151640.scope; invocation ID:
e8b79eab2854418b81c2ad62c3d121c4

real 1m50.652s
user 38m58.129s
sys 21m41.763s
pswpin: 15917615
pswpout: 41199479
pgpgin: 76113864
pgpgout: 165640720
swpout_zero: 1546131
swpin_zero: 285359
refault_file: 1648508
refault_anon: 15829347

*** Executing swappiness 35 ***
set swappiness to 35
Running as unit: run-p44771-i189005.scope; invocation ID:
562deebdc09647a290a2165870295ef7

real 1m50.623s
user 38m50.505s
sys 21m45.217s
pswpin: 15915841
pswpout: 41297235
pgpgin: 75425648
pgpgout: 166025592
swpout_zero: 1546865
swpin_zero: 277756
refault_file: 1546926
refault_anon: 15778795

*** Executing swappiness 70 ***
set swappiness to 70
Running as unit: run-p82859-i1819.scope; invocation ID:
82aead8ff78742bba6bf401a6534588e

real 1m49.605s
user 38m30.262s
sys 21m49.417s
pswpin: 16088273
pswpout: 41592875
pgpgin: 71469324
pgpgout: 167370708
swpout_zero: 1657002
swpin_zero: 319600
refault_file: 857694
refault_anon: 16175619

*** Executing swappiness 105 ***
set swappiness to 105
Running as unit: run-p120948-i250916.scope; invocation ID:
e7bc4e739cab4e8bbc5efb06b50ead14

real 1m48.951s
user 38m30.080s
sys 21m48.815s
pswpin: 16265236
pswpout: 41884071
pgpgin: 70923620
pgpgout: 168654260
swpout_zero: 1649763
swpin_zero: 316386
refault_file: 691818
refault_anon: 16368960

*** Executing swappiness 140 ***
set swappiness to 140
Running as unit: run-p159035-i42797.scope; invocation ID:
ea31084e41bf4c7b9427800bf78500fb

real 1m49.596s
user 38m32.881s
sys 21m50.914s
pswpin: 16434435
pswpout: 42315789
pgpgin: 70803660
pgpgout: 170344784
swpout_zero: 1659821
swpin_zero: 314116
refault_file: 563047
refault_anon: 16557648

*** Executing swappiness 175 ***
set swappiness to 175
Running as unit: run-p197122-i325303.scope; invocation ID:
181af70e74b74bff901e10ed97d32c50

real 1m49.091s
user 38m31.101s
sys 21m56.002s
pswpin: 16470200
pswpout: 42370706
pgpgin: 70388644
pgpgout: 170452728
swpout_zero: 1689922
swpin_zero: 330216
refault_file: 487950
refault_anon: 16613124

*** Executing swappiness 200 ***
set swappiness to 200
Running as unit: run-p235206-i68603.scope; invocation ID:
d6af085ecd9a47a88ddecfb326af4d58

real 1m49.458s
user 38m37.696s
sys 22m7.194s
pswpin: 16473742
pswpout: 42413098
pgpgin: 70351964
pgpgout: 170454504
swpout_zero: 1653981
swpin_zero: 316654
refault_file: 539774
refault_anon: 16620315

After:
uname -a
Linux localhost 7.0.0.ptch-g4ce85c040e0a #2733 SMP PREEMPT_DYNAMIC Fri
Apr 24 19:07:08 CST 2026 x86_64 GNU/Linux

*** Executing swappiness 5 ***
set swappiness to 5
Running as unit: run-p10510-i123098.scope; invocation ID:
7773cea9690140378786e496d7bf0523

real 1m50.042s
user 38m59.555s
sys 21m25.018s
pswpin: 15913149
pswpout: 41183479
pgpgin: 76136184
pgpgout: 165910472
swpout_zero: 1557330
swpin_zero: 282842
refault_file: 1599524
refault_anon: 15876245

*** Executing swappiness 35 ***
set swappiness to 35
Running as unit: run-p48606-i45593.scope; invocation ID:
66799f770f0944558b258fa42a62cd28

real 1m50.479s
user 38m59.363s
sys 21m27.155s
pswpin: 15865488
pswpout: 41087641
pgpgin: 75103236
pgpgout: 165212060
swpout_zero: 1557445
swpin_zero: 287809
refault_file: 1421868
refault_anon: 15790633

*** Executing swappiness 70 ***
set swappiness to 70
Running as unit: run-p86689-i246403.scope; invocation ID:
ac7303701c524901a64c9a5b945f9e20

real 1m49.409s
user 38m36.037s
sys 21m37.421s
pswpin: 16198083
pswpout: 41876332
pgpgin: 71719832
pgpgout: 168490208
swpout_zero: 1622494
swpin_zero: 304799
refault_file: 847114
refault_anon: 16283181

*** Executing swappiness 105 ***
set swappiness to 105
Running as unit: run-p124782-i205752.scope; invocation ID:
591727ffbc1d40c1b79a5a20567e1616

real 1m48.638s
user 38m28.237s
sys 21m31.590s
pswpin: 16278124
pswpout: 41920058
pgpgin: 70591876
pgpgout: 168801512
swpout_zero: 1660539
swpin_zero: 321367
refault_file: 651376
refault_anon: 16400826

*** Executing swappiness 140 ***
set swappiness to 140
Running as unit: run-p162871-i189610.scope; invocation ID:
3be1d782d9724eb79e7803eb72c47e4a

real 1m48.602s
user 38m31.708s
sys 21m39.510s
pswpin: 16376932
pswpout: 41921230
pgpgin: 70503000
pgpgout: 168528328
swpout_zero: 1684494
swpin_zero: 333271
refault_file: 524031
refault_anon: 16513067

*** Executing swappiness 175 ***
set swappiness to 175
Running as unit: run-p200958-i133720.scope; invocation ID:
12da6771f02b485ea6cf0c6842bd5f73

real 1m48.905s
user 38m28.887s
sys 21m31.592s
pswpin: 16535604
pswpout: 42244753
pgpgin: 70727968
pgpgout: 170088056
swpout_zero: 1675139
swpin_zero: 327897
refault_file: 489367
refault_anon: 16669662

*** Executing swappiness 200 ***
set swappiness to 200
Running as unit: run-p239041-i341992.scope; invocation ID:
31ff32be856f41f4a3ad60ea7878a230

real 1m48.746s
user 38m25.722s
sys 21m50.843s
pswpin: 16644335
pswpout: 42660348
pgpgin: 70911344
pgpgout: 171749444
swpout_zero: 1675432
swpin_zero: 321988
refault_file: 501717
refault_anon: 16775111

Since you mentioned it's mm-new vs mainline, and you have reverted
part of this series and the problem is still there. Could it be
related to something else in mm-new? I'll keep testing more stress and
workload to dig deeper too. Or maybe the swappiness behavior just
changed slightly, some it may perform better or worse depending on
timing and workload? Swappiness on MGLRU currently only works as a
factor for calculating the refault and reclaim balance of anon / file
so it may behave a bit unpredictable. There isn't a proportional
calculation like active / inactive LRU. That's a problem too, and we
might fix that later.

