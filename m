Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB18AC79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 16:10:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9629D6B008A; Thu, 10 Sep 2026 12:10:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 913AF6B0096; Thu, 10 Sep 2026 12:10:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 802776B0098; Thu, 10 Sep 2026 12:10:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 558436B008A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 12:10:09 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DEFA81605B7
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 16:10:08 +0000 (UTC)
X-FDA: 85198339296.30.656D14F
Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	by imf05.hostedemail.com (Postfix) with ESMTP id E50A6100006
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 16:10:06 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="P/slmQo4";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of surenb@google.com designates 74.125.230.204 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="P/slmQo4";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of surenb@google.com designates 74.125.230.204 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789056606;
	b=aGeAL4e5lK5no/cmVQ+ucUvy1tYXsq9rQ5rjDsQwUtnaIrhSXkf0bu/i3rJTNIbCFTVyAe
	+0BP82ZcWRu4LfLUUGC/bJDVUSB0nehqiSyI/UJfly16i2qBJjdbU+CBlm8m6kZ7rjeu1u
	qzIGW4Jer+QDS3/Zmxdv1RXTMh63nho=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789056606;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nn837W91rvFvYJRiTa/P9FmCzgytAxp2W6ySv2FpOa0=;
	b=ON2U0RDgw5XGDazkgdblJzm8OnCM/KE9wMfStfCh+9lGZHRxNvVs3xBvCOCj0hajon99qL
	aslxFMiRBR2Wnd3hJ/bti1BcrrJGh2oeA3xwKrvQGuT/+U036wYe3rBSJD+Ul0mvHomCBP
	Oz+MzUE/6y+qJa7h2COiAEUW0vNOBHI=
Received: by mail-qk2-f12.google.com with SMTP id d75a77b69052e-530411c7ee1so325171cf.0
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 09:10:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789056606; cv=none;
        d=google.com; s=arc-20260327;
        b=qKrnt8DgTTCDyvfsHB4j3IEfeSXG1EhVMP923hLA48ZZLvRJumS4yKDpqmnFS7XsCx
         EeP9rpvYzCRRQM7Lj6b3WPi9cKctfZClSq4xAhzTV7Q84Hc2Q5uIpg/E6c/fAvY2AH2B
         xTNwZ2UAXIXdS/Ezcq5C0/Etq0q9POIC5/UIov74MfEi7AYpkIEFEtvzUL9I0YT7EhGk
         n5CBF7pcwiZn37QC88jqyD9nECDxiygx+foujKtlhlmllwmXijk7UhKQwUk5tGm4IJ/7
         Hci0XbnZVsXO+8iwvr7L/r672b9EO29tRHaiKCopU8RNfr0H9FuRTthPPguwZnbwj9tK
         EG/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nn837W91rvFvYJRiTa/P9FmCzgytAxp2W6ySv2FpOa0=;
        fh=7c+0ChdYYdYIFXfFFGcWN2hEJfzBQVGO0B3XS/hVJic=;
        b=aktDWnd3ClWu+cTXjJcp9rMxIEYO4Ta3VM1uyz07Ga2fAeat06T9dhweH3cLyjtrd2
         yTmDrHpXonl8ZjRi6K7lMA5VA3KLbf5yqLm78IVb+ui0dYMdED9PrwqksntSZLmDxM9c
         hoFjBIIAgoxTaVkIscEPpk/k4RwSPSs1QLZsROr75QPmj8umEA1k/AD5wFa6OChbXhnU
         kCWGNbFgYZI7P9dU1MbJSRQy2AIB085TS3/tcm9a+KMUgR8fNol3JTWsQatt9ScjFp3v
         oDG1Itb1dvcUN9tjNLCTdpOCQvvGVtm9z6vviFJ+iGE5wXKZ2WnjAMQzDg1QlmPDRU9N
         L/Kg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789056606; x=1789661406; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=nn837W91rvFvYJRiTa/P9FmCzgytAxp2W6ySv2FpOa0=;
        b=P/slmQo4TGIU/4nx2Yd68z9dSp1eSfozLIAtlkJCFJYr1DzjQYfN/syyw3Uv5MIpb1
         3/tOijXDHn3SUxBhedNeob4VTkh5SzWbq/+sI6A0MOZYxrC3tyIaWdqpbWNo0jNPphKz
         mmWbl0hT3Vzo80XGOvZhDnRKzEj0Afau7oJ2aZ9G0HXeJBmx87Ja9XIvbjLGgHOv1oXe
         URjVxrwYhi2QhZ1MWQ92ZP11PPg+fqtvvUHmBt350I7uC4pcvhOkb0XlzlBrbri5yIUy
         GxcA0pKdin46dzcnGvif1ml8AvGBxLFhg7ZVw6dQeT1vRHWPR2svhl5bFU8hbBGKwEV2
         72Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789056606; x=1789661406;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nn837W91rvFvYJRiTa/P9FmCzgytAxp2W6ySv2FpOa0=;
        b=sfeXdmQuD63EDRHv3VGVTLkCPpfqfjEQlYvi/SKTmWY5wx7/P1n5huK6SY5t86btSY
         ziF71iOuaL9qKCKu6E8jkZKVxuwGn3V4jlC8MUW2LYGdST4PUXqz7QYa1zktm2Fwzs1Y
         ektaRWll3/eGv63gzl2x88ei7Mr08qm0TwKFXuxnDZs4zLEKLZ0f0TTS4EYtLVxi5y2/
         VIoJwWx8/6rSWDefoGbNSgOI0hFz1UFrcI0Y9n/JWWXkPbNE91eBcsQ6smg88ZQ0iW68
         0NSmSGdkuuM0rAWRcMxk7+kgxSgrWSx3USy1LBp6flKQ+uBPef731hspgs5pphvkz1mu
         NxVg==
X-Forwarded-Encrypted: i=1; AKwUvBw/F/TPWB3rrN4mlz40fzF7XV90M0v7DUXZAfFyKOn9MKwRj3L9yf8dDqf8cERpE8TK3aBoeeix9g==@kvack.org
X-Gm-Message-State: AFuF++k/B+JWLu0FLomp9wnf4S23gsfYfZciwTD/BkM3vxSn0sKmHn1G
	WOx9jwv7m5R1Lv9B7WC3AZ5RKqI4UUAcVnuJ/uWkc9fakgOppkOJl11ogAfs90FHY/rDKOtfr0F
	xcP6MOb51zFxw4ugakBomb3YTnf5pOZOST3ie68po
X-Gm-Gg: AYBFou1SryAW+tIzzLX9dUXQVOtCXq8u8RdQnVJ2rgsPv2teI9kTfL8AOCTJRAOLt4M
	I67lQ94RZYkGn1TRbzbzyXqtd8UlYHT+m1HlSLMWdfJ2bZrbWdUuRpb7ZjpaMqWVfFynJQuSybJ
	JWyUfptneLA+WV4+XHSEtPNzhPqpL7JIE1MMC0VejaHJUbFAKCesnOwEcQHmqFeFDUs0IGRlh/x
	mqliIGronmQ2uen/XcPCv1BKGDMrqchtMyUuqYbJj5ITr6tZFkbiXXBeIV3S8I0wOP6ISw9u6Pc
	VXtr66ldQY0pf7u5uW+zU4J3lo4rjPodDDQKwtfoJ14uEm7l/JAUn7q48MsvlxRVD2hIRAPUN5c
	wn4KZAQdB9F9t9YLSx6tN
X-Received: by 2002:a05:622a:258c:b0:530:39d7:ef48 with SMTP id
 d75a77b69052e-530b60199b9mr19460481cf.3.1789056604206; Thu, 10 Sep 2026
 09:10:04 -0700 (PDT)
MIME-Version: 1.0
References: <20260907063918.3432401-1-surenb@google.com> <20260907063918.3432401-4-surenb@google.com>
 <4825a2fe-f064-45d7-a7c9-e98de7efe86c@kernel.org> <CAJuCfpFL_g7tELjT8p8ExM3tX_v2gNDM9rRKwwefPV_KW=fHfA@mail.gmail.com>
 <8e643f51-a47f-428e-9443-678326288fa6@kernel.org> <CAJuCfpEYdj=u0wczKRrsB8uDkbSzPy+hrsCo9TW9-3J3r3p0xQ@mail.gmail.com>
 <2336140f-c993-467a-b2eb-e99dc9427a59@kernel.org> <CAJuCfpEL40p+vk6-km6_BBuE3+YY0WqkpbvQnQGFEo_73MAomQ@mail.gmail.com>
 <9e48cf7b-1700-4a85-af83-8883789ba87b@kernel.org>
In-Reply-To: <9e48cf7b-1700-4a85-af83-8883789ba87b@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 10 Sep 2026 09:09:53 -0700
X-Gm-Features: AcwNN1W0lCJR22Fjje3cvEQd6sZVvwbNRZsVrrFWOXlsi8IV5nagaOj9ko-nhZo
Message-ID: <CAJuCfpE9_1VYqHp6bctUEihSW35TaTw_LZuOGP2UAnF7SA_UAw@mail.gmail.com>
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
X-Rspamd-Queue-Id: E50A6100006
X-Stat-Signature: eumd81zpn4h9b9tiqyqfa7y6zm69zmts
X-Rspamd-Server: rspam01
X-HE-Tag: 1789056606-566459
X-HE-Meta: U2FsdGVkX18rh8ATMAQGkmLeUMQsEhLHRGWbltmAUcSv7aMg8WUFceY1F9rG415xqYPIjjEvS/75RlyVapJg3XQzsf3fexGGFS2ra3sD2G651HN493FoEk0xrQMBuC4kAebdzgGf04rQLnA/hFx4y4oDH24CqRwLhyyxt/cBKQo+CtKuirooot9ydg+fIGOJZQDDqnR/iDbUAEEtWKg75G9j13zFSDT7Nehbh/tbFC6hVbV5tQJz1lal0agtnVvkGjLzlW8FpZSqc+oTbNJ854FIAhlarSAqvAbBJEcD+fSh21yi3e/XMqsCS55MWe135RymHLGIrJOKTgdWGMdnET6fQ6d/7vBrtaKdc+K084fqjPtY74wCcN1+fWLGLqdyKfBmN7Y6h7FhMVrlVBCv0gHrm1UdeQXWwY1IRcU9nINF13TlXf9fBpObh5/Qp6iheCDXWKRGQup3uhLxbAsc0i72QU0G5aUUEQvh/W+HEA61aY40kj4Cwwapzh74apTqUd3PjXXkSB4d3HfXAwoy4VUsU+VS1DKdocm2z9irtG1ZxQ6tZnUicv4lDbsXJ/jwFfu0J7hhflMe9KrnTmTa1hwE0YijXm7kdyUtJ1zhrvSiRRbNIq9bPgnzeSNmOaLk1fPOzSztwrzg2LDtpgS/I+7GepCT4bigEKuvdD8Pv2LGJbme2qe0RUwosEa0Jmu7XVH6D0rH95h4YG9LiEk6YVMDtx+oBya16HSzw0hXMq8B6/N/f4CnsWrFCIcv87Hjps+2/6p8sn5TuWWPuzTtVb6aV1yAxkD4xcwd3pPOEjzsCAG/XbF8V4OTP+vl59EA3k525eK3UC1NeZs67qVMcUMCyduULwFy91Kqc+ppUUdahtyEAnKUhbE1EzRKeaZq8xMkQujabW4tBuEw4qAhhrFSH0XZPF1yTplApk6KsE/6dD7lDtb4av7h9sKOPMaBe3ukviOWn87D8kO4dt6
 9B3qDZhY
 RG7addZnmtZbCVZrJPC0uPHzxV3TL96erXjI9m2W0qL4xy1Zq0Ng1+E3iMsbP23MPvPqdqZATR6AEktdz58to29sHFdG7uYFoBXQep6g1aobpX910XYhra0UiJDIKI6vB1znlEFAEzom0KtkgluTf+hXeeEAVyvSEmznDFjrbvXPfcRIvy0ljJVQxQerevpEPkH7arkDN9ktB02OfMiATkzq2JZKrhrQTdLCABlG/l2l+Jk6pzcP9DaH5dwV86pzN5LzPNe3sL0fZLvUMeEyyUTx08CPf1WvUWXz/KrBApmGWDxHRD/iWWvXirQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 10, 2026 at 9:01=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 9/10/26 17:45, Suren Baghdasaryan wrote:
> > On Thu, Sep 10, 2026 at 12:41=E2=80=AFAM David Hildenbrand (Arm)
> > <david@kernel.org> wrote:
> >>
> >> On 9/9/26 23:51, Suren Baghdasaryan wrote:
> >>> On Wed, Sep 9, 2026 at 12:16=E2=80=AFPM David Hildenbrand (Arm)
> >>> <david@kernel.org> wrote:
> >>>
> >>> Ok, just want to make sure I'm not missing something subtle.
> >>>
> >>>
> >>> Ah, good to know.
> >>>
> >>>
> >>> I see.
> >>>
> >>>
> >>> I was obviously overthinking this :)
> >>>
> >>>
> >>> Sounds good. Will update.
> >>
> >> Likely worth putting that into a prior cleanup patch, so there is less=
 noise in
> >> this patch.
> >
> > Well, this is a cleanup specific for smap_gather_stats() funciton, so
> > I would prefer to keep all the pieces in one place.
>
> I meant as part of this series of course.

I understand but this particular patch cleans up smap_gather_stats()
function, so if would be weird if I move the comment change in that
function into some other patch. Unless I completely misunderstood your
suggestion... Maybe you are suggesting to split this condition and
comment change into a separate patch and making this one a pure
special-casing elimination?

>
> --
> Cheers,
>
> David

