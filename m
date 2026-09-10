Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7A0EC79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 16:21:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBD796B0095; Thu, 10 Sep 2026 12:21:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6F3A6B0096; Thu, 10 Sep 2026 12:21:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C36316B0098; Thu, 10 Sep 2026 12:21:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A65756B0095
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 12:21:23 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1A033405A7
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 16:21:23 +0000 (UTC)
X-FDA: 85198367646.27.DF05F9C
Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	by imf01.hostedemail.com (Postfix) with ESMTP id 29F1C40009
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 16:21:21 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="uNPx2/iO";
	spf=pass (imf01.hostedemail.com: domain of surenb@google.com designates 74.125.230.204 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789057281;
	b=pGVtS5bRWo4jhWUUMYQUgCgmdcAAuGsEXEoqtNsWvlY1MyTZN8hOKgLi4R9gy2roCEzSAM
	Jo4B7yZAiaIHqHVnCwLXxKR7Xh9e9BCiVYjWzRbWRrAZtQOMgVfSjKkKgWdOFgUPBznLRH
	fvWZKwilYvaNNsMNUGCHu5xnkQTisOY=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="uNPx2/iO";
	spf=pass (imf01.hostedemail.com: domain of surenb@google.com designates 74.125.230.204 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789057281;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rUo9u0Wn3HX0BHKDm+fuwzmG4aoAVjhxf19bucJp2Hs=;
	b=G3NmcrItWqrMhyXhPJCrSJaifQ4QGwVidkGlmujbjIzmFTq6Bk263vxIwAGvKIm5jwePQj
	QkDsnxPyFye+z5pzoviMfGggHHMroDfQgvzgIimjdbv7EotiSi+y5zGgHkXVW+Op7eHInP
	dPc48jrr5IH/Zm1R3mE38AIA317XQ2g=
Received: by mail-qk2-f12.google.com with SMTP id d75a77b69052e-5307425f44bso284291cf.1
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 09:21:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789057280; cv=none;
        d=google.com; s=arc-20260327;
        b=ibIW0CGSSx3G0hd/ujg4oMcycCmagQ8IbFLhzk45vKzI/GmRV2fNYU5YKYWcnpYD0A
         QSlzVI7IZE9ZlArWQpS0rOmRxht82tdwQ/iFmyyEV2L8BDYAYG4BmFtNB8KIBU+dYNBl
         HFApcF8x8dhwNA67jpGIx77w9sfqRW2a321Fue8tPE5kwnEPr5zOx2D13QKNo1XaGVdG
         HY7/KIDGOba4GB35w2KU758QZRYK9tCEKXSFPFn9qb20tYRXLVq7qUJHPv+H3pJpUF83
         Sxu2kz3V2JpaacMrwMmnixP5WXrNtt6zOBlIZ5cQyZ2Q70L6r1GOjJgR44Y0iKuTqCuN
         U90g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rUo9u0Wn3HX0BHKDm+fuwzmG4aoAVjhxf19bucJp2Hs=;
        fh=YMDFnTss1bwREVVZzTrXcGUZ7rBMqSQfwUWfiQg/sAA=;
        b=gYpZiKxGpfDciG5g9OWSNSW4S6CtQakG2ghZNJ49u7Kr2MKKkW+ZBJ29ck7diTLEY6
         H5hciAzm7I1Ljy/VUV9bX55x88TmI1KDsuPxMfc1dyM12cmspE3HQyNtJaIGtDJLiN4k
         dBS/lCqXniyUUHvAh+cIGg0PcQYUxzLW6+Zg+fcgk+rv+RKFmkJaYbr3P1P7WPEHlntL
         UNutyNB2owTNGWVEKDcT59ZDCAmlN2baMZtx1zkxraMUIdDU4Ch/zS4HhB4b4SxMd8t+
         Fvf+Gy6ss69B41PTvzOCesUFCvTREcXV61Q3T+Ic/GEo2TSFR91G/UcdtIcxZE+4h5YL
         ml+g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789057280; x=1789662080; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=rUo9u0Wn3HX0BHKDm+fuwzmG4aoAVjhxf19bucJp2Hs=;
        b=uNPx2/iOMqW7tbdCYhf1iOxp3qzcFvQ7E5lF26jTgkCHkndux80P7vxI/rFMqQvZvq
         9fvK25MQv/t4l/Vb+ohd2jZZw1Pbn/Y4GqjMQ30oYvDq4Xcj0BjxdMaQdPk5ziDhEaYd
         wH4NOjIofREXUHIV7UnMh217OedSonzMxRO6FsdbWdVbGJiXeN6bQSXDhWI9w5jKA29O
         NLjjERe/WLR6kL9Oofyc53/d2h8qvzgQNuc0PWRuSS1RjofMm5nKMqP/RcWTZMJM8qOc
         drcC9iNw6RH7VS8LGLFOF9xDqkh3YpbH5YdC1u21jdK4O9hA331I9RGJ1ta3xRgkJjXG
         PL/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789057280; x=1789662080;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rUo9u0Wn3HX0BHKDm+fuwzmG4aoAVjhxf19bucJp2Hs=;
        b=HOeaR8ejs+/8471FejSQWa3vhovUydg8n0R0+Gct+v3fXLr/jiAj6wAWrjkp24LVT9
         sGTVWjk+/3/eMgjpJ4euvY2HNZXkZoYAPwT416/4gKjQZH/vqAHoPEh+/Z1vxTAe69My
         5Tg/A14lRMdL+tpZjHR05Ku0ZrDz0CyHEjLzBbxz3+VXERu37Uk31h3Qiz9y/L7kD8BO
         eO5hV3vB1NNog385pEuloEF6NkQATu3wgNB2HcF9cizLWAqltLQi8CC+K7DnQwDray0b
         H/twb27a7N6YhvDHej7cWKJmh8G34zwgc7968xDg9IlF9BwpVPHnuUNRDxIIam3CjsT+
         q2ZQ==
X-Forwarded-Encrypted: i=1; AKwUvBzHBPkuTz0YEawTaGHccnuOEnH1EK9WjYlrkWYK/nWXDnYsJCa2KYShMTnvvSEElhqsi1gBNTLm1A==@kvack.org
X-Gm-Message-State: AFuF++lmz8uqvcDMzFXYvJcrkXedBngrX8SYf+Ugc7xlWnSMNKwL2hvC
	hcmYY1IXzHp7s3727upgZswJHCrjE5gfOTPvT8WpasJXVceJxosHX1r3TcHv1057Xyz8B7zw7e2
	8h/bGvxZ52KPD7MJOVE5K0gfNivEJzBv8BWa0WOCo
X-Gm-Gg: AYBFou2BI9tGnWcprX558OXEELP0sP/QM0sCoQau6576TDKi83X1AxWo7+vL2dccOH6
	rkCf+mcImgDSmRieo0OXg+KLLJj5OmdJ7KCgRjxajGjsJO6ROlb7ifhQYiqqfnhiHOQjYBEXXMa
	fTiVhOnkUaUeCNFsoBaW25atC+VRCxN0SILVLMuBGTyJ9ml/MIbOmkmMoTz9oX/GT94fGc+oxSz
	WcpEmysjtgKhC3rv4OJUxDae/DmO//bqZ8fIxiIPhrXIlPolujqDI+WnnbHDO7z+Mj3psxb5rrL
	ofEb2XyYyn01dNCWIAXj7Yud1EnXVKnkPFWFvu2Wju7oBGV6aR/U0sK5dr98gpiT0SWDE9T33cR
	CUF6L4ZDOzQ==
X-Received: by 2002:a05:622a:14c9:b0:50f:af60:3496 with SMTP id
 d75a77b69052e-530b601cf18mr16999061cf.1.1789057279175; Thu, 10 Sep 2026
 09:21:19 -0700 (PDT)
MIME-Version: 1.0
References: <20260907063918.3432401-1-surenb@google.com> <20260907063918.3432401-4-surenb@google.com>
 <4825a2fe-f064-45d7-a7c9-e98de7efe86c@kernel.org> <CAJuCfpFL_g7tELjT8p8ExM3tX_v2gNDM9rRKwwefPV_KW=fHfA@mail.gmail.com>
 <8e643f51-a47f-428e-9443-678326288fa6@kernel.org> <CAJuCfpEYdj=u0wczKRrsB8uDkbSzPy+hrsCo9TW9-3J3r3p0xQ@mail.gmail.com>
 <2336140f-c993-467a-b2eb-e99dc9427a59@kernel.org> <CAJuCfpEL40p+vk6-km6_BBuE3+YY0WqkpbvQnQGFEo_73MAomQ@mail.gmail.com>
 <9e48cf7b-1700-4a85-af83-8883789ba87b@kernel.org> <CAJuCfpE9_1VYqHp6bctUEihSW35TaTw_LZuOGP2UAnF7SA_UAw@mail.gmail.com>
In-Reply-To: <CAJuCfpE9_1VYqHp6bctUEihSW35TaTw_LZuOGP2UAnF7SA_UAw@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 10 Sep 2026 09:21:07 -0700
X-Gm-Features: AcwNN1UFxQ2wu-uZyXCXVwqJ9KTg7zgVVBQWwLZe5OjPrLr6lqSMAklG5FZN_ys
Message-ID: <CAJuCfpGvi10sibu_=cE76h2O14WA4KNOd1vARu0r1CYmAiCMEA@mail.gmail.com>
Subject: Re: [PATCH v2 3/5] proc/task_mmu: remove special-casing of
 smap_gather_stats() start parameter
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, liam@infradead.org, ljs@kernel.org, 
	vbabka@kernel.org, willy@infradead.org, jannh@google.com, paulmck@kernel.org, 
	pfalcato@suse.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 29F1C40009
X-Stat-Signature: figxnbdmhcc5ihjemhbdrgmi43eqg4nb
X-HE-Tag: 1789057281-702864
X-HE-Meta: U2FsdGVkX1/ZH1AQOBTOB1iaCTRYjN9h70GmJcDAt924yC9eV5uK6K6bi7MxfeNTDUSXLUGrFpZcQI3wFw1YWfAlB16kJvhulHDJzi04Ygd3IBqv0EdVR+fKSaM330Xq0TChR6F67VRnZBuP6KQpUMQ9sju5aVYduQwO4MzFzSrW+4hzY0Fm1Pe7IvnuaLcwndbnkce9CsqjSS9e9iVmH6NwHemsdDm/fLXX7Tt9gVifzLoF3iKwmF/tCOEEezvjIwJPW45XddI1t02pg115HiOajZUlJ97yfwIjQM1SGbuf7sVNIHlLzrdk/x3Bcu188SuMrsgk/IFcOhPX5LqG1D5OXq5KUjH6SsQMACGJH10NXxSvlY7mmI/1iuJVUe6CpAGnzEjLKBqEjT7uzAUo3gP5twkQDd7O7PCQijeKTjwwMUoKlZCYmWuLuXO2iLf1DJxGc5lKv+1G9YxH+iWw4W2ozcupWY/yVPnUJ4/FJ97lDWsStYlIIFwgX3nX/w1hwGgyngxPjOxFM9WnWHd2+Tc1xyXPSUH/N4I/w1jKmJm69lNZ/ZPQZLdRzGAZMyBct+S7HVcqhsDETE1B93qY8yI3DkKbqVM1JrD42J44wnjX5jMbRJ4ymUx6R07Vnf1V2vRdKgjStvY5YYTcy0++AmSCacJG/rPI1+jrUujEv7U+E2SMN6JXhFKHZdIFouxy6V7CDY/WGrOsIXQO7pD8QffZRx3+0Uxjl9xn6beV0PPwYdxyRr96kCXZUSJvP7qcCW76Z23o5viVqs+0ESdZr+tt4LFVY6TaYWhvShGDS/WTov+gjaWhxD87qWoOmQF/NBR/am5cUqomeC0b5yW7mZMMriJC8mR2gA8Z2cQcTnLSh456raZSSh/W/QL4AiJZLDLKLMsCyUR39mMEAX5wNp5vXbAfFhpN0NO8YWSzlSxvvf2x2ERfV1LEdlwEopizh7gv2gFvuqSafE4UZJd
 rfnj3zhL
 0VT1NGsZERqtB5f1oEfSn5czXJd61ky2Xlp3mzJilQuevHWNEGyRIJnr/Uu2y1eWTmGyQPlxt/eX11we4WZxcK4X66WaSKPB7wpRGPBUcpOQpE2NamY/Cpxo3diNDww6/nYI4Rg6o6ifdplBDfJXELDbB+buiCgJpNpw2WCtJDc19P/EgZ76VWHadPqXQR2wKMn+mmtQOUSREz8E3ADrFp1xLAein8UhtggLLLNNUuqgA2dDDTUe6eukMFWjK+psSE7zV6vvzpd0hqkEvqrChEX7LYOPoV6kefTuHm/VHzypRmabK0hUHL2apB7MnPC4jHSgWWezstYaieXA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 10, 2026 at 9:09=E2=80=AFAM Suren Baghdasaryan <surenb@google.c=
om> wrote:
>
> On Thu, Sep 10, 2026 at 9:01=E2=80=AFAM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
> >
> > On 9/10/26 17:45, Suren Baghdasaryan wrote:
> > > On Thu, Sep 10, 2026 at 12:41=E2=80=AFAM David Hildenbrand (Arm)
> > > <david@kernel.org> wrote:
> > >>
> > >> On 9/9/26 23:51, Suren Baghdasaryan wrote:
> > >>> On Wed, Sep 9, 2026 at 12:16=E2=80=AFPM David Hildenbrand (Arm)
> > >>> <david@kernel.org> wrote:
> > >>>
> > >>> Ok, just want to make sure I'm not missing something subtle.
> > >>>
> > >>>
> > >>> Ah, good to know.
> > >>>
> > >>>
> > >>> I see.
> > >>>
> > >>>
> > >>> I was obviously overthinking this :)
> > >>>
> > >>>
> > >>> Sounds good. Will update.
> > >>
> > >> Likely worth putting that into a prior cleanup patch, so there is le=
ss noise in
> > >> this patch.
> > >
> > > Well, this is a cleanup specific for smap_gather_stats() funciton, so
> > > I would prefer to keep all the pieces in one place.
> >
> > I meant as part of this series of course.
>
> I understand but this particular patch cleans up smap_gather_stats()
> function, so if would be weird if I move the comment change in that
> function into some other patch. Unless I completely misunderstood your
> suggestion... Maybe you are suggesting to split this condition and
> comment change into a separate patch and making this one a pure
> special-casing elimination?

Ok, after re-reading I think that's what you meant. My first
impression was that you wanted this part to be in one of the previous
cleanup patches. I'll split this into a separate cleanup patch.

>
> >
> > --
> > Cheers,
> >
> > David

