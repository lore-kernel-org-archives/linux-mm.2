Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13925CCD1A7
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 16:28:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A1FC8E0023; Tue, 21 Oct 2025 12:27:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47A088E0002; Tue, 21 Oct 2025 12:27:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38F4C8E0023; Tue, 21 Oct 2025 12:27:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 263458E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 12:27:59 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id ABE1C48732
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 16:27:58 +0000 (UTC)
X-FDA: 84022653036.14.FB29F92
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id 54A3240009
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 16:27:56 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HePrGfpu;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf11.hostedemail.com: domain of gpaoloni@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=gpaoloni@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761064076; a=rsa-sha256;
	cv=none;
	b=6ZcjQX+I9zNQLio3cBtI8bwXfQZa6D7dOvvk5Cdw1hxrFacD6uqQqaC2WpEZlSJUT1NKwW
	ajO4V6g2gGXi8cQPJQKf4YiLcf+uEa/RqK9lrAgkRsClIDjDO3SlhcW8mjxkgiiov5rWp5
	yFPXYGXR+m5QT6BVKcVnkSupGzF5c9s=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HePrGfpu;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf11.hostedemail.com: domain of gpaoloni@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=gpaoloni@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761064076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tvopacnigHBT8bombNvmTILspbaRSMSn7DFUJVL0nnc=;
	b=ReQnjN4JM4shQ1Ch/+WD/wCqkKr0DuZK34E1fQlOuoM4sMgwY/lJIetAXZ8dkqeUfV1AW9
	6GlIs995TFBXtpTITU7u40z8PMq4bNw5kqwTQ3M2VOnfuyalOdAaO7xxZZ+4XBo0Hy1avO
	gITLSX6F/1c1qWvGHciVohfKOhdiqlw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761064075;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tvopacnigHBT8bombNvmTILspbaRSMSn7DFUJVL0nnc=;
	b=HePrGfpuHO0NAddAtozFro9TTREwO+F54nL37qXG2k7lTjlfJStxQvEta9+ybgZD7SmAk2
	KPVa2ai4eNz1hKabjPS514iAgO3Qx/HU1W6LMOb/1ah4PsnwQCHzt1f8BGaW+lgyetZ+NO
	aFv9EkHLSvzw1BN1LgGX44fRN/tlp1M=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-465-umjD_H5cNC2CmU3gG8osdw-1; Tue, 21 Oct 2025 12:27:54 -0400
X-MC-Unique: umjD_H5cNC2CmU3gG8osdw-1
X-Mimecast-MFC-AGG-ID: umjD_H5cNC2CmU3gG8osdw_1761064074
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-4e8b33c1d8eso1865131cf.2
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 09:27:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761064074; x=1761668874;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tvopacnigHBT8bombNvmTILspbaRSMSn7DFUJVL0nnc=;
        b=tDHOTEnirb+vc6me++8ChDf2rBs/SEoxkrpoG//f/0R6CRnpUpOXRKHFK8eksgODSv
         J18dREC0BzjmQ63e/VfMYZEp/cdP05rJHQta74TLwJR3fUMwSwC/6aBymu6zMXBCi3gW
         cfAsJgbmhXGC1uuY+OTFR1Er+KJ8MuWnSHyOLJBrON6zfa0o63Xx6PL+e9jWczCtHFKQ
         +tXVTmH4r5LrWfOfw02VQRiMt8fsDCxcjJPvGobwVHzqqCW60QY6cFs0kdRh6ZYy9PJ9
         LGNq0hAW9MsTbXE+ih6RO/vhAC/d3srom1+Grf3gvyPy5KtIcQmxx90joBZdrjT4qd3i
         cVuA==
X-Forwarded-Encrypted: i=1; AJvYcCU7LZsHOo28qvUen/hfRX+YpfxvH+Jr5kuZimL97H4lj+ASwmr0meKwjRu3+ivul3+U9z/XcQAy9g==@kvack.org
X-Gm-Message-State: AOJu0YylUEXglRI8WHX/IdU0cNZxFx4AIdBBFg2FZrE1iXNQSbM64QWy
	AS8YbYeW816Skp4MhPVOEF/I50jpUug61GRExC0VFMx6kLLG18Lb8e2izglJdWzP0Ox0PbBd061
	eC7cm4X0VyjdpAd3XoguaAPXM83NL+h1z0H0aCEZ9pot8WChIcUCNXxJ/VXooYHWvJYOPB3y0OV
	HID678wiUaJT3x19rnyciSkP/Y2H4=
X-Gm-Gg: ASbGnctSlIYX30G8TTnOLQP66LU7rJrUjPNu51TpCtainvGusWheg0JKZqFwtP6oU1F
	tJ4OrfUADgykty9Y0IRUwvQErfxE2dBuEtkoCK7pI7MiayFkxtamRVrVEuhP1kJcLexjZ6M0+vQ
	dlJ8C/LN+5/hCmaY48wigBaYoCpkoC69KD/X8b6Rxg/2Oid5tukQbYW0hPA24+NNBye3kC/6NMI
	bnmqj06v4wdjxY=
X-Received: by 2002:a05:622a:5:b0:4e8:b4d1:ece2 with SMTP id d75a77b69052e-4e8b4d1f832mr136116861cf.18.1761064073672;
        Tue, 21 Oct 2025 09:27:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF+4bhTh0R0rxAhz5svf4CCiuJcWStZnahyEqAUmkhny4II2PoiiE/S+8ADSs8/XKYkUEz/fKi6H3YvlEckWRM=
X-Received: by 2002:a05:622a:5:b0:4e8:b4d1:ece2 with SMTP id
 d75a77b69052e-4e8b4d1f832mr136116461cf.18.1761064073103; Tue, 21 Oct 2025
 09:27:53 -0700 (PDT)
MIME-Version: 1.0
References: <20250910170000.6475-1-gpaoloni@redhat.com> <20250910170000.6475-2-gpaoloni@redhat.com>
 <878qifgxbj.fsf@trenco.lwn.net> <85166a8a-ad54-42d0-a09f-43e0044cf4f4@redhat.com>
 <CAB=6tBQP3aCDWch4ZcEYMqFsJ4OKXSyC_hb9V9hA7ZZty7vFeQ@mail.gmail.com> <042629f9-f295-494e-8fbd-e8751fcbe7c0@redhat.com>
In-Reply-To: <042629f9-f295-494e-8fbd-e8751fcbe7c0@redhat.com>
From: Gabriele Paoloni <gpaoloni@redhat.com>
Date: Tue, 21 Oct 2025 18:27:42 +0200
X-Gm-Features: AS18NWCYr1SX4wkTTAv1mmDjb6o7jALXBoi79rLo1c5c8AJEkanUrVwY-K7NzHM
Message-ID: <CA+wEVJYLF9T21-V2k0Y0zxcF0zcRG64QUVrM=qHDWHz7+4+ptw@mail.gmail.com>
Subject: Re: [RFC v2 PATCH 1/3] Documentation: add guidelines for writing
 testable code specifications
To: David Hildenbrand <david@redhat.com>
Cc: Chuck Wolber <chuckwolber@gmail.com>, Jonathan Corbet <corbet@lwn.net>, shuah@kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, gregkh@linuxfoundation.org, linux-mm@kvack.org, 
	safety-architecture@lists.elisa.tech, acarmina@redhat.com, 
	kstewart@linuxfoundation.org, chuck@wolber.net
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ST6jBCjxzS2Se9NVfrXMKK1J3MzNh8J5y0slRIjZI2U_1761064074
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: nq5kntxwztm76ttg7hc47d3xwcumkr3j
X-Rspamd-Queue-Id: 54A3240009
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761064076-321931
X-HE-Meta: U2FsdGVkX1/uaQ8pKUXjxuuh8/ppUjs6El+Ik23dfLS5gUdmLbII1AHwh5FQOEatL6E/VbnI27o1dLCvRVp65TU+iWfHobgZnozxhDpd4r4jzn7LsfUJZgQFZp6fMcXFWjl3YO91mTM3e3OS0iAVZciPETjx0SeMEOR9HX9Bjp0qxy3f6Bx91FOytvJOXmYmCgamh3ADO/zW2qwpmZE0PADYF0DPAnoZA3cktkRi11OpoEeJeEgyPwoSDaHwkc5640uvLtQRZxD1EUFOORTGKfBB6lF4RVmFkKgp9sOOPY8DHfajMx9TGo/yaBPXN8Lc5v3DD8htYr//f3PIBJMzQ36uk/GTocqHyone4QH+hUTk5W9u981rhHpuzxUWLcRurW7Ui4IhQAwT4hvQ9lqClHLPQG3ELWsudDTAqHbxowOgmGUeG5Tkf7berhfP/JKujxE2f4+rulnSxEFciIgM1tBVnhya2N5tD0c+cgZKH8xJ89q7SowEbEL4dCBF8a2b263gI+geEmzpDGt5GFLKsZUoatw9ROGfHf0G/2r9Yqm1jklI4mZZPL/XrSIaXROTeRWeENuQJ8G1HohyOmJ8izwRjZyiLCUwNmsI1McuFy5PYwlm5iTaQsGFP/nd2o766D28uN25ay22sAvJ6DHp8aoFD1a4kQ3iUqOJWZb4sUnk4jMUtigvv8yqd2vUCCwxoKwy29zWSlBYZnl0MqxeyQ/Gabi5WS+GzsJesMZQS+jTqd1FZJiFr9XbGhXk5kwSLf/hw0PRul65y9+s6qtKrHX30bS7CGlHfXVshOOoH/MsLQyoz5vK8NCMWB/xNR9GPo+R8+nXmXc86ILK3emZA7qleXwlNMpayzexVXqTMG3WRKKafgAF7nVxydK4CZt6Za8aZP4FS5byV1ZybS7LHijYdD8mi0KE1VJg6a66gcFYYydVMdglZSi22Zj2M/wDLrxLK8mqLh87xLJ6Lvo
 HYYz+YLe
 o7iWvxtJd3oDeEdbDC5qVfid3wGUzumrNBje9/8XtwvNhQmnHVx1dPb5LXYGky1LailKfti0ru+PrNz2Ti7pQT/RSowhAtFDC8m3zaVL/T31foY4xLF/58tRAGwXgUHJdA4YdT7WQ01RExw1FhVURn6XK8GNnER3Cp8mA7/CRSGgTmyUhfbnprm+CJfHPoqIbZ/WqTSKOv1W/6WKB6+TUU6Stieeta6tqTCSroiurJCrtuhtsYXydAe2i7AeJiFngDg7Td97/NSv8wChqKCgNmsJcjG7rN/9KmiJmXFsJcB8T4H4InP1Tc6i6hRXb4ROidac1OwaVrX8Hyftv/F8wMH0z0Chh+xI+Y3gggIktrEYHz7I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David

On Tue, Oct 21, 2025 at 5:37=E2=80=AFPM David Hildenbrand <david@redhat.com=
> wrote:
>
> On 20.10.25 23:02, Chuck Wolber wrote:
> > [Reposting with apologies for the dup and those inflicted by the broken=
 Gmail
> > defaults. I have migrated away from Gmail, but some threads are still s=
tuck
> > there.]
> >
> > On Mon, Oct 20, 2025 at 7:35=E2=80=AFPM David Hildenbrand <david@redhat=
.com> wrote:
> >>
> >>>> +------------
> >>>> +The Documentation/doc-guide/kernel-doc.rst chapter describes how to=
 document the code using the kernel-doc format, however it does not specify=
 the criteria to be followed for writing testable specifications; i.e. spec=
ifications that can be used to for the semantic description of low level re=
quirements.
> >>>
> >>> Please, for any future versions, stick to the 80-column limit; this i=
s
> >>> especially important for text files that you want humans to read.
> >>>
> >>> As a nit, you don't need to start by saying what other documents don'=
t
> >>> do, just describe the purpose of *this* document.
> >>>
> >>> More substantially ... I got a way into this document before realizin=
g
> >>> that you were describing an addition to the format of kerneldoc
> >>> comments.  That would be good to make clear from the outset.
> >>>
> >>> What I still don't really understand is what is the *purpose* of this
> >>> formalized text?  What will be consuming it?  You're asking for a fai=
r
> >>> amount of effort to write and maintain these descriptions; what's in =
it
> >>> for the people who do that work?
> >>
> >> I might be wrong, but sounds to me like someone intends to feed this t=
o
> >> AI to generate tests or code.
> >
> > Absolutely not the intent. This is about the lossy process of convertin=
g human
> > ideas to code. Reliably going from code to test requires an understandi=
ng of
> > what was lost in translation. This project is about filling that gap.
>
> Thanks for clarifying. I rang my alarm bells too early :)
>
> I saw the LPC talk on this topic:
>
> https://lpc.events/event/19/contributions/2085/
>
> With things like "a test case can be derived from the testable
> expectation" one wonders how we get from the the doc to an actual test ca=
se.

Probably it is the term derived that can be a bit misleading. The point is =
that
we need documented expectations that can be used to review and verify the
test cases against; so maybe better to say "a test case can be verified aga=
inst
the testable expectation"

>
> IIRC, with things like formal verification we usually don't write  in
> natural language, because it's too imprecise. But my formal verification
> knowledge is a bit rusty.
>
> >
> >
> >> In that case, no thanks.
> >>
> >> I'm pretty sure we don't want this.
> >
> > Nor I. If you find any references in our work that amount to a validati=
on of
> > your concerns, please bring them to our attention.
>
> I guess, as the discussion with me and Jonathan showed, the cover letter
> is a bit short on the motivation, making people like me speculate a bit
> too much about the intentions.

Right, I'll keep this in mind for v2 and I will improve the motivation aspe=
ct
(also leveraging the response I gave to Jonathan).

Many thanks for your feedbacks!
Gab

>
> --
> Cheers
>
> David / dhildenb
>


