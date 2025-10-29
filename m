Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DE9DCCF9EE
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 21:27:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99D8E8E00B2; Wed, 29 Oct 2025 17:23:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94DB78E0106; Wed, 29 Oct 2025 17:23:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83C908E00B2; Wed, 29 Oct 2025 17:23:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7483F8E0106
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 17:23:59 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1D9F112B05F
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 21:23:59 +0000 (UTC)
X-FDA: 84052429398.16.9B5D1DA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id B02A940016
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 21:23:56 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="MNx6/0j7";
	spf=pass (imf11.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761773036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YxJkHaOGqtmtID7r7jgJwxwqavOG8btDMZK73zs/svk=;
	b=Vg1uBtLHmqGoG6sRviDJpGE7qxyaST0KbW0IkbLoRVTBLVfBcqiD5iMKcCpfMTDN0B0XJR
	+LvCnhFOZGwz7YkbCtkqM8vlrJNViGZ8wkxL2DRwRpe/gj73y02fj+A0jItMndnsnEXjxC
	oWrT0ET3lhNZ6qRtQ3BWbdELpw0EH98=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="MNx6/0j7";
	spf=pass (imf11.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761773037; a=rsa-sha256;
	cv=none;
	b=QPYJSe0CkXO/zFmB+w8RUKkJLf+5vD4kRVaunQB+dhaWWQueS+o1KJx39iFzmQAGhVOtTm
	q7cYslN5wRMK6WUYbwfNjF7UqNPaMvPuyfFKfcobIeiajcV2Q3O+x7711Dq0QjUR7DS06d
	Fg67LOlua3gTnpacScOJ0ahG0oWvYVI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761773036;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YxJkHaOGqtmtID7r7jgJwxwqavOG8btDMZK73zs/svk=;
	b=MNx6/0j75DkXKA8HEhpx6Q1AokaoUoEHTdmEM0le7mpKbsU+jR0IDvYLura5oWgeb93S+b
	qhfB45erqGOKILmmBZ+NpN42sEoQ5GQznPHbNao+1wl/e6Oo16j/sjfgKZHXXB3krTCkha
	kSPL1TRRjV7cOSRNjv6nA3Vtx0WyjYo=
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com
 [209.85.128.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-576-2aeVlESXNceEgo2mXewnDA-1; Wed, 29 Oct 2025 17:23:55 -0400
X-MC-Unique: 2aeVlESXNceEgo2mXewnDA-1
X-Mimecast-MFC-AGG-ID: 2aeVlESXNceEgo2mXewnDA_1761773034
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-78103962c97so5029337b3.0
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 14:23:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761773034; x=1762377834;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YxJkHaOGqtmtID7r7jgJwxwqavOG8btDMZK73zs/svk=;
        b=HHthOep61w6TPqpWlNRwYVV19rlq8CCcB41KRLJOygQZV8kWhXLIHZ2TWm7j0Ctnpx
         RBoYt2wd/4xbe4SljJDEeRUTECxqPwknTSA+c9j/LN6eSJYjXrucT+IAVPjmMw7v9HYk
         o/hv1+4HlcNq9IEIZ+m1GlwOM5+ycJrgjgw+oF1SpfWW/n/g4M8nuZY18RrOcjZh0s7Q
         tBYGKDBYOqzhW6E301XNldsW1WcOTpfC6TUD7YdzyOqj4CQPH/XgtKVqERIG4f1PP8hx
         bdNmypc7UyCdMeAG1nqmYSVF8sCCN6yxavLzKBfb2SRTuWJtaQqM52akMulSkO496Qml
         GyQg==
X-Forwarded-Encrypted: i=1; AJvYcCXejKrr95+BJfZYOgzOBdI8Nrv8XJapaY/OtrOifS+NDhRvcFGoF7HabxwkBcCy6NhzmoY4AE26cA==@kvack.org
X-Gm-Message-State: AOJu0YyvrvaK1RfuvUEOqmxIeCdzI//iYibeZSoucZ+uJcVx2a0vtWGj
	ra/acbozPUFRgrelDQs3LDtnr8FFqfxHBB+XatHGk+tn9aQ+wBsefT2XeZLLVhmXWNb/XVHyjNf
	J+KNGeygGU9G32qmr2E5/jhc3ZW+QSZ8ESZHhA5e9ZWYGTof/9aGe2kNQMeHYud7rclxjxZas+e
	lxHsb0VGG03pjgBT3X6GGppdXLd1U=
X-Gm-Gg: ASbGncvq95w7bd9q7+5Mu4qG+D5VmmsQawODlUc30ZhKXFv8GCb6CIIrz/N2Pm9HASw
	Kuokj9nA+vc98FXev6zEKM7WZU0Xb6uxIMjq2vMyaVOmVrajJJRBEKixzCIfFYDPMeolGeq45eW
	DFDP0MsS+rFfjqfhBTq3VCtnjV9OTBW1ybtYIbfFeA1TZ7RUpB4QT1unursHRMYBk3wOt2Yw==
X-Received: by 2002:a05:690c:6701:b0:783:6943:f530 with SMTP id 00721157ae682-78629002465mr47289407b3.63.1761773033723;
        Wed, 29 Oct 2025 14:23:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH8yc33v52nQ6YPYjNybWuYm4cbGSVVsczrtKKNT1ij0PL3hQrawg7LmLb9r6Fd2P+MKYkK8oJ/nx9Rz6pq4gs=
X-Received: by 2002:a05:690c:6701:b0:783:6943:f530 with SMTP id
 00721157ae682-78629002465mr47289077b3.63.1761773033204; Wed, 29 Oct 2025
 14:23:53 -0700 (PDT)
MIME-Version: 1.0
References: <20251022183717.70829-1-npache@redhat.com> <20251022183717.70829-7-npache@redhat.com>
 <5f8c69c1-d07b-4957-b671-b37fccf729f1@lucifer.local> <CAA1CXcA4AcHrw18JfAoVygRgUZW3EzsN6RPZVrC=OJwSNu_9HA@mail.gmail.com>
 <e69acbc5-0824-4b07-8744-8d5145e2580b@redhat.com> <e66b671f-c6df-48c1-8045-903631a8eb85@lucifer.local>
 <74583699-bd9e-496c-904c-ce6a8e1b42d9@redhat.com> <3dc6b17f-a3e0-4b2c-9348-c75257b0e7f6@lucifer.local>
 <CAA1CXcD1YDAbYzdYfchOWbmUasa3tN55AYroOLJb2EqoQfibvw@mail.gmail.com> <02a72419-bc89-481a-ad2a-a3c91713244d@lucifer.local>
In-Reply-To: <02a72419-bc89-481a-ad2a-a3c91713244d@lucifer.local>
From: Nico Pache <npache@redhat.com>
Date: Wed, 29 Oct 2025 15:23:27 -0600
X-Gm-Features: AWmQ_bnwjuOd-l21r_gYz6uTD3EwVnE8ezkHiJEP0hwQdGdZ9Dom1N0UNfRsm3E
Message-ID: <CAA1CXcDR7pe1jKvPOBv-WVYObYtZNNx0w9vESaUsLe+BPR=Dzg@mail.gmail.com>
Subject: Re: [PATCH v12 mm-new 06/15] khugepaged: introduce
 collapse_max_ptes_none helper function
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	Liam.Howlett@oracle.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	corbet@lwn.net, rostedt@goodmis.org, mhiramat@kernel.org, 
	mathieu.desnoyers@efficios.com, akpm@linux-foundation.org, baohua@kernel.org, 
	willy@infradead.org, peterx@redhat.com, wangkefeng.wang@huawei.com, 
	usamaarif642@gmail.com, sunnanyong@huawei.com, vishal.moola@gmail.com, 
	thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com, kas@kernel.org, 
	aarcange@redhat.com, raquini@redhat.com, anshuman.khandual@arm.com, 
	catalin.marinas@arm.com, tiwai@suse.de, will@kernel.org, 
	dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org, jglisse@google.com, 
	surenb@google.com, zokeefe@google.com, hannes@cmpxchg.org, 
	rientjes@google.com, mhocko@suse.com, rdunlap@infradead.org, hughd@google.com, 
	richard.weiyang@gmail.com, lance.yang@linux.dev, vbabka@suse.cz, 
	rppt@kernel.org, jannh@google.com, pfalcato@suse.de
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: POdwONsVXGUHaXOTg-FI4lCzcutz3m_DE9hoik63tWE_1761773034
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: g3i1ar3anedb8un4tr7y45is9w6cwmec
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B02A940016
X-HE-Tag: 1761773036-268180
X-HE-Meta: U2FsdGVkX18WRAz9gYBSB8vsOnOAWTOm49NyLKe9elmzvrZbWoE3iONaPxIXKzR5JSc8PVu/cWtesoUes0IGrZaD+0me9kBWsniINfS9j5J218oJAHkraJ+Sa+dKaN0m6vKheKUgzJYL/eOab8Dc1627z3PuHDuwpvHZ+AAyRgQUKfiti3zEgP3Z7nYBuMip20ZWggvgW+QvDp/QHLXzu165X3KdwK/EcVFzpasRcyha1toIsic5FYAaFGf5zRg8xBtyoc8uRHydZX7tQY3OWly8AiRqgjA9YYya02W9WBE+Hz3XRuBArKCvrzybdzqddv3Qa/XB2IdDTTYTEoyuBBxA0J1NBM2dDClJf7PRpUaRPG0eCjxnk75y7ZHjp7DIF9kR+qUJ6xfc3EZmeaU3Sm/8j6njOEE+nY6ELEaEY/xvE9pFBVwyd44a0Aj4yDBu2KIGncgh3X67mVZvp5HbBEA9/ar+VJrHVwwqiegC4fleCTWXPbSlhqePeLb0+0CrVGsIQK2RLeeoV/VLETdjqAX2r+o3SwwsZpvO5fTAQaKmTogPkaaUdk9JDdmxQT9pwzSB5utX/Dqmeu58sQi/TZYRPENH/HyRXrFU5XQVOLb8QP//CMyoXgiCmJKSxvj+lhEQiznIH9W1eVdeJ+kHyYSK5OfjX9L1VSJCEFo+VLmjm6iHertAq2RqdqKqK427P5Qp6ugjVIEhTPQL7XL58t8eS4VNITzrmm508LXFPtrpjMQzNmWDymGPQ7bpWorZT7mG8+2/kxmEmi3rikZAIAeRbF9eK2K8eQGmLRAL6w+e6ee/veXzH488cJ+QoC5+yyf0J4GSy1Oq8O/RqNSQ3e8Y6DdvOx81oFxYwXgHHZGMguS1ADRWJl0ci6yPCClKhkuBUta89XigGKzMklFgWwaVLd9xlQRFewZnl9fmz5QZ5ti4nE5XiqE3H/Q5MFHganj3vlfIhnbpQBZDIVd
 84bBM82T
 S2s6xuROlmKJU0pA9qQWyySttqoSShwVnSO3Jlohj56UP6zng084oEWxRew4XYvcFKZuGl9QK0SMiFB0dI+14BYHoRJ4OKsEoFf1GF2jCVw+xNS+c0RJYHaLccR1ht2ABmc8Q+qHI7YavOzSPzLBtB0voyV+CFoHvucCPAEuYHNpufmO1nDedoMFQuTu4/2elwU++OS0hu3F5+FZ18ornYwUFMjYz5OH9K+2YUgwLTYElnc3DwgWZEiqLEkHhrxG9/X+0i5EzwkRZIW+QezO3lafy1knD6muyYU+XsX7lzfhl44uzghCwT6H9TB6/JeCX5JRGEYX1SDSNG6Kifk6Tjnj2VzRYMCetYabDgWZT2lig+FQ1ocmdueHb8lW0rF8olC92FgusIjklbUKbFCMN5bAisA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 12:59=E2=80=AFPM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Tue, Oct 28, 2025 at 08:47:12PM -0600, Nico Pache wrote:
> > On Tue, Oct 28, 2025 at 1:00=E2=80=AFPM Lorenzo Stoakes
> > > Right, well I agree if we can make this 0/511 thing work, let's do th=
at.
> >
> > Ok, great, some consensus! I will go ahead with that solution.
>
> :) awesome.
>
> >
> > Just to make sure we are all on the same page,
>
> I am still stabilising my understanding of the creep issue, see the threa=
d
> where David kindly + patiently goes in detail, I think I am at a
> (pre-examining algorithm itself) broad understanding of this.

I added some details of the creep issue in my other replies, hopefully
that also helps!

>
> >
> > the max_ptes_none value will be treated as 0 for anything other than
> > PMD collapse, or in the case of 511. Or will the max_ptes_none only
> > work for mTHP collapse when it is 0.
>
> 511 implies always collapse zero/none, 0 implies never, as I understand i=
t.

0 implies only collapse if a given mTHP size is fully occupied by
present PTES. Since we start at PMD and work our way down we will
always end up with a PMD range of fully occupied mTHPs, potentially of
all different sizes.

>
> >
> > static unsigned int collapse_max_ptes_none(unsigned int order, bool ful=
l_scan)
> > {
> > unsigned int max_ptes_none;
> >
> > /* ignore max_ptes_none limits */
> > if (full_scan)
> > return HPAGE_PMD_NR - 1;
> >
> > if (order =3D=3D HPAGE_PMD_ORDER)
> > return khugepaged_max_ptes_none;
> >
> > if (khugepaged_max_ptes_none !=3D HPAGE_PMD_NR - 1)
> > return 0;
> >
> > return max_ptes_none >> (HPAGE_PMD_ORDER - order);
> > }
> >
> > Here's the implementation for the first approach, looks like Baolin
> > was able to catch up and beat me to the other solution while I was
> > mulling over the thread lol
>
> Broadly looks similar to Baolin's, I made some suggestions over there
> though!

Thanks! They are both based on my current collapse_max_ptes_none! Just
a slight difference in behavior surrounding the two suggested
solutions by David.

I will still have to implement the logic for not attempting mTHP
collapses if it is any intermediate value (i.e. the function returns
-EINVAL).

-- Nico

>
> >
> > Cheers,
> > -- Nico
>
> Thanks, Lorenzo
>


