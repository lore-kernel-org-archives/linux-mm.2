Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50DBD606CD53
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 16:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=W0QEHo5Z
Received: by kanga.kvack.org (Postfix)
	id 659C36B0743; Wed, 21 Oct 2026 12:19:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 609F96B0744; Wed, 21 Oct 2026 12:19:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D4176B0745; Wed, 21 Oct 2026 12:19:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 102C46B0743
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 12:19:08 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7EDC7A05DA
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 16:19:07 +0000 (UTC)
X-FDA: 85347142734.04.28A550F
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7DD22100006
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 16:19:05 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=W0QEHo5Z;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf05.hostedemail.com: domain of samarth.colleges@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=samarth.colleges@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792599545;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GaeKDuXFuE5olZ2ktLjhPukVuieiAC8t3mVSsDpdv9c=;
	b=SzRsL7+UIsCdkZEQ4Kg9H/rAv8E/YNwDJKhRC1cq6FkIbKKdsXEY3Dw4LVmlpMN8/NAF2u
	cQcboA8MDbM+emw1K/Y69+/iLW5Q5HDB4IWscOW1E6B+OJjOT85oKeowqW5vblRCVr+asR
	PErwTc4QMJCB+eKfaPLmoKhhDG6CZY8=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=W0QEHo5Z;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf05.hostedemail.com: domain of samarth.colleges@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=samarth.colleges@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792599545;
	b=1SVC04so3EM9OK8wOYMUetK62xWZ4VvevA18LEW3tjzPmyqUIYoSfmO6x6z225v28U7CTL
	/DSHkWlhEVhTXvogzx5abk9EaiYSX8DyG2zFAyZs2tXMTf1EIFTamPYVeGgAqinfuzGk0+
	1nwJmjScbHf5pAqK+4WEu/oEyr9hT2g=
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6afa651700eso1288757a12.2
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 09:19:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792599544; cv=none;
        d=google.com; s=arc-20260327;
        b=Q9YtFiuHMYmhb9LtR+AEFq5JSL4ZvMCK+bQGCPLO6rdVeJsitjidpxnmt//d3bF9Da
         ISXmeuB+NG2YDdrPqIkRmuk4BbUQi3zTo6N1J8m17/UfuK9ZU1vK5akooDuqxpHTfQJ7
         V0hsrpwP6zfBF0EQmW4tJ9JRGMbSRjr3mWmD0qZ9cNfM4neg2OtA2hSRI9EHHNX4ZYDK
         15ermjeqvA9OHsS04VmB2LWhaJ+XRTi504Yrx4ZqvOOJE16z4M4l+lg9lbzjStCZtMt0
         rwxU26646m3omYU1qClHmUAXrk80QPwmCEV7NGFv1pICtHXPDO/3Detq+BMKL2bpKUxo
         b/5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=GaeKDuXFuE5olZ2ktLjhPukVuieiAC8t3mVSsDpdv9c=;
        fh=SbPlT2HfYMdW1Pc17+L5dZ9cMX64OsJyoAxI9Ba5L0U=;
        b=QiaBTlejv84jvTGrLeXu6uHjI7g07QrTtlv+0nlIA5zMMPtyuEKjpJDabwM1Q3txyK
         Qp9pP/J2SgaJ0Y0m1Sw4x9QdegAa3i0127NfjamBT27u8Zy52r/G6ZCDrigXfVuTXYbp
         5H3o8b3moj+LFiXiSiCMBEw39a81aBSwblhiqWhNDIdwkhW9SHb2xdEnxvOCJYU3fnjT
         ytYHX7xLHnEQPbxkmAahFvZG755h7fsTBvyxVIoVT218hI7e93rO4qDZXqEKqFLyocJf
         Qg20Zqd0Si5LJS9gW/xj1J518qreX+92AoBjAVvvPilc6pCGVYfo+GLlU4lPbMpRwv2H
         HGJA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792599544; x=1793204344; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GaeKDuXFuE5olZ2ktLjhPukVuieiAC8t3mVSsDpdv9c=;
        b=W0QEHo5ZCSGXVUanQ13fbya2HQzffYf7YygW2MirrWtysnK7ar3Nu+YIoiWFn7k1Q8
         IR4WLZ0QKwdRRjiiD44zn/pQ+AAVfvvenSwyXP+33qGgqopAazo1hl7Rl4wv8hmTTzTw
         Vxam5ZhGwv18rpvzXfDvOHrmglweEZvIkiNVEaaJSMGEr10w4yN87nT91BL664EdBhVt
         apA9m92aBdXovwOHWu+lYk7OOtnO+aZsQzZenrLkRoEs6P83Jp+i7q8TfEQXtUELaaVa
         4FOK5cFT+oz8x/zgb7qOcZY6dHApkJjr6VwDDusnR2qOjqPGt750DYadMShuKsAo7j4l
         b7MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792599544; x=1793204344;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=GaeKDuXFuE5olZ2ktLjhPukVuieiAC8t3mVSsDpdv9c=;
        b=lSxCFcGLmHoUOVBJjMKrRLH9B5Q7kG8t9sNfhaVpNzFPDj0oOJclGxAAIBo9UMCrs7
         NYQzgxqaP0812DAGWAFJnHkmKxnazyPwZg1Z3oaHogzuaj31T8zss53MHGKklqulyp69
         7i91SNsoKX3uJri9QLzEFPQrZuj/pi0gWDHQNvfU8mvKAr+vf8LqiaUJ7f2jp6O6ApmP
         7BfSco1CLuAHjdMSOSCXfwbotnHmaxOaUeGSwlY9c9kZURKqjj+93o0Bkz78NHulj29o
         /K6zoFDlUQ3NdwhE4SeMNP5UWZKlWVxhp4g1N1FiSyXm+Kg/XtS9VUF9rhQFr8Cov5so
         xnMg==
X-Forwarded-Encrypted: i=1; AKwUvBwZr7lYT8zh0noEs+hchg0JjZJTS5cofpEX8nYD9Uf7obf28yra5Os8wrmAXizPeeaM4gR7IckvLw==@kvack.org
X-Gm-Message-State: AFq9FYI7viC1rDbLo5dPL4+NQ+UbXIvRUjcOqsTsyd47pXznV0M+1XUs
	XzLDL3CF8tU4zP6kFHniHO1e+AQllws0+xXHR3qSqC9NPlAkf3fiH8NhoINin6NQOfoL/H9cdHA
	IItbFsSvmJtzdWiQxfiSpF5M5dsoLBwLqPcHL
X-Gm-Gg: AYBFou1EFAt1KZgt9MyjPrJvY9d63JwXV2Bvw3PJhaOY/7aqaRvzY1+HripvzJg0sMX
	/gsvpEFQzjZpUCQMHTqAc1x7tSXIOeet0UFuUCS0nxVDYthlBd+jOp6OCAM4FHj5MzN6U+F+HNj
	ET9UJDzr4bXDlSdZZHoyRtJxs+gUQbsQc1I5KiXY+qp+j0gm8im3B04408PEpRsQXwV3fztZ+7j
	FLHex+MWiRfRwDBqwNuDB6k1bAJ7gfLtkhRewQWD8o6UESpNNeZdyeu2VI4/l39sEvNHPG7OwZf
	ldMqoI96azDZQSGedM4J3c6s+EFb5MFk8ikLtanCYdXp4jXokWtqB3IVvRwGd9DDuz/Bt9QLb0Y
	a3qxsOckjUIVqvMt5Y5H9dlMJZhYfmUT8g4tud//ynXotabcH968Ds3i7WN6m+y1CpPZM+rWz7G
	PGGkBUx2pcN/bqwFJEa6AFiA==
X-Received: by 2002:a05:6402:21c5:b0:6b1:d9fe:88e3 with SMTP id
 4fb4d7f45d1cf-6b408eb6337mr1608059a12.25.1792599543854; Wed, 21 Oct 2026
 09:19:03 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <efa6a28c-f0f9-4d1e-9cce-fec2c08e7d9f@kernel.org>
 <20261020055518.36087-1-lance.yang@linux.dev> <3da45e6d-2b46-4fff-9ff3-241f70d68296@kernel.org>
 <f6bdf823-be42-4184-87d2-fc7c128f4786@linux.dev> <68f17ee7-d272-4475-8a59-645442e2c210@kernel.org>
 <ath8JTlITYcXsyLg@thinkstation> <2329ee64-f9be-4826-a496-65344e9a9c18@linux.dev>
 <167a14f0-6a6f-4db1-a34b-905a33d5290d@linux.dev>
In-Reply-To: <167a14f0-6a6f-4db1-a34b-905a33d5290d@linux.dev>
From: Samarth Narang <samarth.colleges@gmail.com>
Date: Wed, 21 Oct 2026 12:18:52 -0400
X-Gm-Features: AclHuK8ojB3ztMH5VPgy5jwhMDSnJxrAod8byLjU_ygHRl2j-2uhUztC8xSSj0k
Message-ID: <CAAbz3fTjWnZmHaWT+zsycEvnEM-ZYXH0jG_XoV+yidYUquutVg@mail.gmail.com>
Subject: Re: [PATCH v2] mm/ksm: keep soft-dirty and uffd-wp when merging a page
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, xu.xin@linux.dev, 
	Kiryl Shutsemau <kas@kernel.org>, chengming.zhou@linux.dev, peterx@redhat.com, 
	rppt@kernel.org, "David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: multipart/alternative; boundary="000000000000093b0d065e5c1b54"
X-Rspamd-Queue-Id: 7DD22100006
X-Stat-Signature: 39mhhtsrxosb6paapznko58n5ftauttd
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=0.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792599545-635653
X-HE-Meta: U2FsdGVkX1+GUpTYWNXCGCmUftoppLv5IXbN8HuY78X+5RoTgIjpoYNRBGoy3lDrERV9qVuRT4GcUDQ6F6+95cgTCeNS5e1u32Nt1SRyvjgj5s4Oi8jxYDYqJujLKP2Hy5VCMwJRPRIl0pkM0xhr89JGS4ebwVsPfS+CPXNZWlhHLGKPQMr24F3tdSXnPrbQjCWsE9Sm2KV1E1Grhi7uT81dOCXLu+Dxtpx87Aqj6kOgBwNm6g4LALo4iLvlSmltnVSsCCOe+yiaQJkFzTNYHXbOmpCJXLSSWPilpCjRyLE3L8sNAohnFb3+AVMdhXZKTmuqpV4/vArwy9or8EbTB83CbDggNX+fSb9rvtCGtabdhwB7GSX1AyVJHk58wU1O2qymbdaegJ5fQu2u3Oc7xZSsFksx0hTScbOWCi4mjNXReFo0cRvPBYsa/ZGsFAdQtFTIGB2zNpRwkVyUN8ZBgoJQE0UUQNUfq+XfSpssBh7X3WQXKOLs/kPzPUZEkBz3c04AeGKh+j37uRD3XSk4l182eoepPQ1ijsCsJ0sPKr9zjq2DEfOw+kUZIM1NuqQKNm4MBQSOLeijco9fjrUwCkqH3z3SX9MfSOUH3KV5CTSPvsgedinKe1dL95ZTcaXcFaYPXm8vfCxuu+BpCTHXODWgwJYdiVMPQLl/hAWRvfIg3I8H3pqlrZBSmjHcdse/koPCNQxwCzWPn1wIvSaS2V0DK5AYo3IiBlTcup0CUN7qeOpB41kmUGVgrw4GvCLo52/MfNCE6YX6VHyk49/rdyQgO6hfYS4F9UcQjUAMpeWJk7Qg9kk/cX922gZZwPdisUO+jg4maSYl8PBgV5OrmONNlG3bRaihpXowO12D5qnvxxdwU/r9tY79OwrXN17MPwj0AvRutuQCsNuZOVBzu745BU8hx6DOfXi/odhWU3dciDCSo3iGJT2SbRtWPEt33f3cxpinV9T/vv8H/az
 jshB+hXk
 z7zo14bn8+Ip4i9xVePwlzyOvXChJD14goOtjBCsUYKAd1aRoZ2lCD0ig/mhTJPn45d+Mtvi53rL+S0byW4WIiEYVVw0p5WutEf5VAREUDz+r5syLJeRCreiqwrKtzR7UimeK7fTvSXG0FdQy3Eb6SI7JsCPD+4KuBHFczIZlcFpXAVeIyT1TpyYZA7C/6cg0DtHwHFAxjvHyO+jZWHbwx6r1rC9m+QCoMdPEWdRiK/MqLNCf45Cs0OgZfJ2eg+HAhAUAUIgysA7GpPlc2o4pYxgMQ+XVRgDZas3mpCIa9TTt14G6L/kakNk3OEiOTYxx5o0zDMJmfCqoznyylZwuWpVPf6T6ZZ+iYl0Xf7A8WGi7IXRxwulWeAaZcM9pYWIsoqyKIpYJiPcqtFQXt6qdaq5Vg/Bt2zLTUs6Amzi3VNsNo91Y6PhzJhmcgTytaXGV+YtzdWZCSPjX6zUIX38TsFC9TXk8kWjRAlliumoH7nJ1/Z5biHZj1CAnD5fk1pAorb/XP5TgeqoUHLFWPqeUjHDvR0TU6FxZVJ8k
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

--000000000000093b0d065e5c1b54
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Lance,

Sure, sounds good. I=E2=80=99ll send a patch out today.

Thanks!

On Wed, Oct 21, 2026 at 12:12 Lance Yang <lance.yang@linux.dev> wrote:

> Hi Samarth,
>
> Could you send a v3 with just the soft-dirty fix, as David
> suggested? Leave the uffd-wp/RWP bits to me (I'll take
> a closer look).
>
> On 2026/10/21 17:49, Lance Yang wrote:
> >
> >
> > On 2026/10/21 16:55, Kiryl Shutsemau wrote:
> >> On Wed, Oct 21, 2026 at 10:21:53AM +0200, David Hildenbrand (Arm) wrot=
e:
> >>>> +1. Did it ever actually work there :) Why not just skip them and
> >>>> call it a day :D
> >>>
> >>> I think QEMU just always sets MADV_MERGABLE and later activates uffd.
> >>> So that
> >>> needs some care to not disable them. So let's rather try to get it
> >>> fixed properly.
> >>>
> >>> Can you send out proper patches? Thanks!
> >
> > Thanks David! Will take it over next week and get proper patches out :)
> >
> >>
> >> +1.
> >>
> >> Lance's direction is right. Unsharing is not an access: do_wp_page()
> >> already skips the uffd-wp fault on FAULT_FLAG_UNSHARE, and RWP should =
do
> >> the same.
> >
> > Thanks Kiryl! Will take a close look at that :)
> >
> > Cheers, Lance
> >
>
>

--000000000000093b0d065e5c1b54
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"auto">Hi Lance,=C2=A0</div><div dir=3D"auto"><br></div><div dir=
=3D"auto">Sure, sounds good. I=E2=80=99ll send a patch out today.=C2=A0</di=
v><div dir=3D"auto"><br></div><div dir=3D"auto">Thanks!=C2=A0</div><div><br=
><div class=3D"gmail_quote gmail_quote_container"><div dir=3D"ltr" class=3D=
"gmail_attr">On Wed, Oct 21, 2026 at 12:12 Lance Yang &lt;<a href=3D"mailto=
:lance.yang@linux.dev">lance.yang@linux.dev</a>&gt; wrote:<br></div><blockq=
uote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1p=
x solid rgb(204,204,204);padding-left:1ex">Hi Samarth,<br>
<br>
Could you send a v3 with just the soft-dirty fix, as David<br>
suggested? Leave the uffd-wp/RWP bits to me (I&#39;ll take<br>
a closer look).<br>
<br>
On 2026/10/21 17:49, Lance Yang wrote:<br>
&gt; <br>
&gt; <br>
&gt; On 2026/10/21 16:55, Kiryl Shutsemau wrote:<br>
&gt;&gt; On Wed, Oct 21, 2026 at 10:21:53AM +0200, David Hildenbrand (Arm) =
wrote:<br>
&gt;&gt;&gt;&gt; +1. Did it ever actually work there :) Why not just skip t=
hem and<br>
&gt;&gt;&gt;&gt; call it a day :D<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; I think QEMU just always sets MADV_MERGABLE and later activate=
s uffd. <br>
&gt;&gt;&gt; So that<br>
&gt;&gt;&gt; needs some care to not disable them. So let&#39;s rather try t=
o get it <br>
&gt;&gt;&gt; fixed properly.<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; Can you send out proper patches? Thanks!<br>
&gt; <br>
&gt; Thanks David! Will take it over next week and get proper patches out :=
)<br>
&gt; <br>
&gt;&gt;<br>
&gt;&gt; +1.<br>
&gt;&gt;<br>
&gt;&gt; Lance&#39;s direction is right. Unsharing is not an access: do_wp_=
page()<br>
&gt;&gt; already skips the uffd-wp fault on FAULT_FLAG_UNSHARE, and RWP sho=
uld do<br>
&gt;&gt; the same.<br>
&gt; <br>
&gt; Thanks Kiryl! Will take a close look at that :)<br>
&gt; <br>
&gt; Cheers, Lance<br>
&gt; <br>
<br>
</blockquote></div></div>

--000000000000093b0d065e5c1b54--

