Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BC5EC79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 17:02:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 076C26B008A; Thu, 10 Sep 2026 13:02:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02C976B008C; Thu, 10 Sep 2026 13:02:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E58B66B0092; Thu, 10 Sep 2026 13:02:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BE38E6B008A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 13:02:16 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 04ECCA5242
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 17:02:15 +0000 (UTC)
X-FDA: 85198470672.12.5C2E55C
Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	by imf23.hostedemail.com (Postfix) with ESMTP id EEE7E14000F
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 17:02:13 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=RI9tsJsM;
	spf=pass (imf23.hostedemail.com: domain of surenb@google.com designates 74.125.230.204 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789059733;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P+DLIY6UxOqANj9LNama4Ax3pwH1auByUeIWevB5eqk=;
	b=mCjAZEV59pVHXVJpoEc4pece8IAUgaz7mZtngejIUKs9Frv9n6R5zqrZZDFYAITPl9+LOU
	kSRpBAHeYGvCDPhZGuCiNhZPwGTnbTkpgvl0ZIz+6ejxCIJbKgoakD98YRJ2YawJgDdpSq
	Ah2feLhfCpeQ4NOoIOK45j9uczWvVj0=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789059733;
	b=W+urr1+sy5EPkYoN+SYvPwWnpisI+ea3EszGVs680Oi0HbFkLCe9GDdrSPkt9Q3uFPiwPs
	UhG0d5/cvQ9NjE6jxj/wvr9Yp+MpmzDYe1opWhuYp3GghC67G1mBgCYD4Yjn3DO3OfTmT9
	EjKwMMNQX4eyETAKmz7jZXEHTR1RNsE=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=RI9tsJsM;
	spf=pass (imf23.hostedemail.com: domain of surenb@google.com designates 74.125.230.204 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qk2-f12.google.com with SMTP id d75a77b69052e-53012819c04so300711cf.0
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:02:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789059733; cv=none;
        d=google.com; s=arc-20260327;
        b=R8tHpvwmS+uqEjmi+9YrTFc7UyOZolQcFGn1DJ9Uj/Qk0S8BJPnhD73lrm6fzAJXlN
         RnLvpEmj/6OcUQcANgmB2xF3IdCu5LOuHDVlZRBCpDVImIEo5wb0b4iK36iSdeW6ctRK
         Kbxt2dvBxpmW2fHmekt+RfZA2YQfomKzXL9qcOFhq75DV4nQmA8N7cpyUpTh2tUxENbt
         8giuDDGsI52q97o4DADu8iqI+f+yEQQs6sA8iXDcNhvHme4GfHzlcobEIUIfWuZ4ukap
         jiOafn270hK+SsJuY+Mk4PTqBelCv8oCHHOQf9XDQIBPG/dYhtnW9vJsDe/PseSE+AYY
         eBVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=P+DLIY6UxOqANj9LNama4Ax3pwH1auByUeIWevB5eqk=;
        fh=aMXMLBkkKA00/qtUIH7tktESBlguZp+JUk06tbD36g0=;
        b=O4k7n7C1PJ5ur1RGrBkFfZ6sReDekhbWjNqxmr50WJ7HwcauAzS/mCWnViR3m4FkDg
         9dBdm3XrUlPWeSsBEc0x2HmUSFv0QTWU5PzAZ+4qeLAF/NpVk5ldLPCuAHpK2vESFzm5
         FGoaxyE6lvdUSr4LJKaZuzxgGUdyKl4vL6B7f0IMU+81nN8LAs/ItYgYi0BFZAjKHN83
         x+RpD2dnlWLV/00VH56enKhpiEZAWml3QxACib8kib6YnxsZGVlEXiYL1d4htV8L7/Sa
         49Yn9tIIStWzNNiZS8cpATh1YGrHP7s0Y6+NeOqrOhgIBJEX1tjomjizoOOD4dlhdP1v
         pz7Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789059733; x=1789664533; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=P+DLIY6UxOqANj9LNama4Ax3pwH1auByUeIWevB5eqk=;
        b=RI9tsJsMNcC2CssleUI222I7hOytReoWS6WwexXBVPA/ke8+rNKqmphSkT/TJSpjXv
         sIFI2cyGUo3ZVyCrZZTjRi1PNnaAHm8lPVYnyAM+d4/avjhEJk5pzsq2mXQLkf/98oML
         eYdvYNRuNr7TaFx8CSyZVqFMyE2OZBYJRYhbLNY1DkInXF30vs2NNaM625NcbJyLYF0X
         d6n44ol5JzKo4EIEvXgDstHuUAKZnko9lzc8l9ztckXvogkFgYtFVfcGh1RuUUDDBPFz
         +fInrxdqs0wEUUorzhs/8jJmFxbNjIEX8scj2UMxEBf+ocLGr4sZTMINjJhsL3E6Sb+o
         /9SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789059733; x=1789664533;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=P+DLIY6UxOqANj9LNama4Ax3pwH1auByUeIWevB5eqk=;
        b=C7r+Gf5xh3r1iCKFpf/NROn7ktBxLdREOvmclcFLeA12FUIr2TwC4wYRkRowpmWwta
         WnIqKc6Qz3cFpiQNpreVbns3twaqI0YA2w3FqExszxd8hS/myJfWvmA7estAg1f2sD6F
         a0sKWCSGqR3CYsXZWyxRFobvdOFpzLmPb/ORKC1R5spFNa5FTvA0ZJGK9PzSiRlwW0v6
         YQtDt7L9a/jgJDFBCcKtzOlCrbhbtvjcy8mjPX7IbUH22PsuE0adnmD+htKwsuZC7wbO
         MKo+vw7bWB5Ovuej/EVZZdPUKyePXzYMBvOea9gRbmnWL5Avbd+RmVSINu069BqwGk51
         WrUg==
X-Forwarded-Encrypted: i=1; AKwUvBxKpDyQ0TDE/dF31MPzmaUgEMVRLXVjBpJfcvBDt6fiD1ng189/H6OmZv1PiVNZLNjSLEdtYicS4w==@kvack.org
X-Gm-Message-State: AFuF++kTcAfY86+rRW18S7oPHZSMiMSXErLLeRawVr4SfYkjWHKLDeuu
	fbygJ8NUQ9Z47JM7XstUX013ZCbUxJGHz9sM9HQ/XVM1LJkIsauf6Cqfbi2lg6qSFsXO86ZJMBP
	CbJ54n9RIcRSwf7vI+OFCjFoduTlhwypuEYi0YKNe
X-Gm-Gg: AYBFou2vbScmZbxRFVveOqFi3Z/skb9AfEgfoBI7GQn04+nwyL9ECnmC2Hfe+VAgFZc
	OtSxpxWI4Icp6os5v7EF+yp1KecLhXBJUUgPjuHz/CnMWsm7553axVNKMykWdwEiS7GFwjv7Qhw
	Kr7nwtG+80xs+TBwQj99EilRgD+UMyvCa2iuyjqwCJhOPmxq8d9LO8L4TgVV2oRpbxDfrqXxacn
	taLKmSeeCzUSGSq9zL1MbuBEhXkN9t6AEIPqnUrC3zPqPt+RnteVivFRIcpoNomrY14CeAFEDLN
	AQFzwyfTYLW6zPf7gA6AyAoD5d1n7Q4yKg+qkZXPyzGF2kAvnaV+pWLcXu3aFEGTtTsVsBdN+iP
	Ke5SVdJeo7g==
X-Received: by 2002:ac8:5750:0:b0:52b:806e:2633 with SMTP id
 d75a77b69052e-530b601f181mr19081821cf.1.1789059732422; Thu, 10 Sep 2026
 10:02:12 -0700 (PDT)
MIME-Version: 1.0
References: <20260907063918.3432401-1-surenb@google.com> <20260907063918.3432401-4-surenb@google.com>
 <4825a2fe-f064-45d7-a7c9-e98de7efe86c@kernel.org> <CAJuCfpFL_g7tELjT8p8ExM3tX_v2gNDM9rRKwwefPV_KW=fHfA@mail.gmail.com>
 <8e643f51-a47f-428e-9443-678326288fa6@kernel.org> <CAJuCfpEYdj=u0wczKRrsB8uDkbSzPy+hrsCo9TW9-3J3r3p0xQ@mail.gmail.com>
 <2336140f-c993-467a-b2eb-e99dc9427a59@kernel.org> <CAJuCfpEL40p+vk6-km6_BBuE3+YY0WqkpbvQnQGFEo_73MAomQ@mail.gmail.com>
 <9e48cf7b-1700-4a85-af83-8883789ba87b@kernel.org> <CAJuCfpE9_1VYqHp6bctUEihSW35TaTw_LZuOGP2UAnF7SA_UAw@mail.gmail.com>
 <CAJuCfpGvi10sibu_=cE76h2O14WA4KNOd1vARu0r1CYmAiCMEA@mail.gmail.com> <dd134a0a-8fe8-4990-85f2-7b524754b451@kernel.org>
In-Reply-To: <dd134a0a-8fe8-4990-85f2-7b524754b451@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 10 Sep 2026 10:02:00 -0700
X-Gm-Features: AcwNN1XzTzo0tLArJpTqgDsm55TNkm9hrEOzHQgtAQph4QFYlsjRry6cHR3SJSA
Message-ID: <CAJuCfpEN-CWLh__rpzOHaSOpb24ikR5_y=yC_Aqyo3BScq=_RA@mail.gmail.com>
Subject: Re: [PATCH v2 3/5] proc/task_mmu: remove special-casing of
 smap_gather_stats() start parameter
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, liam@infradead.org, ljs@kernel.org, 
	vbabka@kernel.org, willy@infradead.org, jannh@google.com, paulmck@kernel.org, 
	pfalcato@suse.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: di7un1pbyqynwir1fqojy99ew1ahnute
X-Rspamd-Queue-Id: EEE7E14000F
X-HE-Tag: 1789059733-911204
X-HE-Meta: U2FsdGVkX19e7MEsJL2c7yRFpSUVfVC949IXKLpkdeLWhUXeFdt+mG2kUt2ubamWnrqf2fKsLsSIy6qSrHmfXFnLJh/Bm5B2fIX5pCILexrFOY5dPkK5pGZ3CUjdcNAt8o+EINVxVRx9NRWcHYPxTf67N9k25uu1VEygPvEL2ntkMXdl2jbE4M3z/G+nx/306OR2V1GJ97tF2ipVaPHusM8TwQWKZQtoOH2NX56+vbX7SRdym0b4OmGJ5BIowxNUH7hEMgns3QqMsil08nKzS6+GCZ7WYgDOioSgPGO1QFDYo4Q3fI1WW6Vhm7PFwXhgi821/vCfUqc9Tyq5AhGuHdOHVx3C2ytfrjUZV73BuJn44lZUz35L58piNzNZXHHRLrs0d8rk4LKcp8+77qn4Ae6FVSHsitCI1PEiYL7K/YQO/HLYUfOmGHOiSeZkeCl6oEneDV5A5bSXMMvR+JuAr/2ELgaD8yBv2GhWbL/PypH6H4cXAMj3ReDXuYt5bLA7Zo2iY80Jin2qPlG3xu8VdkQEYQ8EIFf22Hw7CAPkLmcItuxPw9D40PKYOiL8Yf2p2BRdZRjA0u3vgzHlyEq37odtfnkHc728WH80RtZyR5U02WHMRf++VG5ix/7cD6DEN1l+hJZoac8iaWWqXBWJYCze2WStHp5myJ9AtkDbg4g0fD6qkoWmL3avTM+qwdWj2MkVbNwPOinQ2nPz3hXoXfRBvK3BST8SYWNWkZ8oeZdlh0RGfR2xuKLfy79rh6kw1UhaJKOh2CCNcsCKCEFPJ5emYR87hMIfu+OfDg7Da/PhvVzKXCJElyDW4tP0Na9/5I2z6guKaTtSbRBHNWEEjbsbDbEsibL+AYvz0nrtERpFI4L4MwzpgJhwhV93Vq4c7ypBHg+ijuWJpyND6wVtPBeHhdHUgijyymyWK/VztxcSdHpuoQXt+ZFKO3x7qEn25KmMdWEl2PLlF+/kKfm
 UqOt6+tW
 W3uY2pngIbT8iynrAKygUd+7JEF0/o2vJHaauDseR5sm2BkksPfRSCkYl/wKgq7sd2MWFenzQKeuukacgSyeRMUeKJMIspCGqrPLqpW/GyO/JsH+tmp42frP4J9QqQY3mgAhz1Ns+OnOLrZS/1iq78nx/81xMv8l5vK/W2hLxA3X1GT0i0e4IwNOFJ4tzOmgfYJ6YO/MsZy4MKsieIqwM9N+pRAl5Fl2uAwEIH5eVL5TIldmbSbSgWUxI5J9pHbPtaVXBhNGY96hzYUtpEeZ5pDChrv7HAQ0tlSs+C+O283PEDVI5xgTsc4T1TbJdhUcqIdENabTn0LmUeBE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 10, 2026 at 9:33=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 9/10/26 18:21, Suren Baghdasaryan wrote:
> > On Thu, Sep 10, 2026 at 9:09=E2=80=AFAM Suren Baghdasaryan <surenb@goog=
le.com> wrote:
> >>
> >> On Thu, Sep 10, 2026 at 9:01=E2=80=AFAM David Hildenbrand (Arm)
> >> <david@kernel.org> wrote:
> >>>
> >>>
> >>> I meant as part of this series of course.
> >>
> >> I understand but this particular patch cleans up smap_gather_stats()
> >> function, so if would be weird if I move the comment change in that
> >> function into some other patch. Unless I completely misunderstood your
> >> suggestion... Maybe you are suggesting to split this condition and
> >> comment change into a separate patch and making this one a pure
> >> special-casing elimination?
> >
> > Ok, after re-reading I think that's what you meant. My first
> > impression was that you wanted this part to be in one of the previous
> > cleanup patches. I'll split this into a separate cleanup patch.
>
> Just to clarify: I'd put all COW mapping changes (using the cow_mapping h=
elper
> and rewriting the comment) in one cleanup patch that can argue why it is =
a
> correct cleanup and doesn't introduce a functional change.

Got it. Working on it.

>
> --
> Cheers,
>
> David

