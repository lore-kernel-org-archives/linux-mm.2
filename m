Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B1D6C83F26
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 11:58:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3AA36B0089; Tue, 29 Jul 2025 07:58:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C10C96B008A; Tue, 29 Jul 2025 07:58:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B26F56B008C; Tue, 29 Jul 2025 07:58:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A3A666B0089
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 07:58:39 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 55F231605FA
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 11:58:39 +0000 (UTC)
X-FDA: 83717155158.19.F547C09
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4BE41100006
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 11:58:37 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=PxA3Jhyu;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf14.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753790317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=POGWpZ6qfhFiTvd9Pz2ShFbRonEQM2kdGcmdneyMevg=;
	b=rrfhwdbH4JoHQAhdqYykdZPxVqjTPDHU6qrd5ur/5wkNu1wvqZSIVlfmAzUEYlzEF+Qem7
	401hgBgtqTKrHEt1z630t49JuC95Mm4U4KUrvohmOqsumer7dYJvTUIomr8g+m2Ku2XKzT
	inK2L1oaVnNrzgAV3kthDSUmQAYB3gY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753790317; a=rsa-sha256;
	cv=none;
	b=TG57LOsMBoGMunfRMFY7viDo/5Aw8Zlsh9a5LMjmwRAyZMdupYEeNvOsi0I6Q0l9Pufjqg
	33Nyy4PHVy7E11GI7M5Fo9nWCJQiTea7AjemMyWCRspSZ+G4kIFXi5cpO4DUXr7ABAuMiX
	GH3tb17IRUIX9QKwcJBzi0VvOcFFPi0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=PxA3Jhyu;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf14.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=mhocko@suse.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-ae36dc91dc7so915745366b.2
        for <linux-mm@kvack.org>; Tue, 29 Jul 2025 04:58:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1753790316; x=1754395116; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=POGWpZ6qfhFiTvd9Pz2ShFbRonEQM2kdGcmdneyMevg=;
        b=PxA3JhyuEuptKVUe5FlGcfLK2DVCYg8MX16Xdqcq+ilfY4wTmR5XvQdVHGPgJRYP0m
         Q6u4+Jd+iBRz4lWsCUg4NHyWZaXgoVT9v8Q25lBZAy1oF67mzTeb4IGIET8d50cpvrAS
         alDUdPoRTAAxSi/e7hFAfWbCd+V0kh6t/OR/ppH03GVJkWkImrIhOR9N9r4NlC19rBF7
         wSncWIWkvJnckpA0JpPKE5mDls4vQ6/+w7wND3083cHWAytpLk6WO98Nvf3C99/OuzWC
         N/DmhzvKmdbIw2Roo8PgwQZZfbACE+CWGtMezlOmOvvPlM3NhQ1bwUMxPbjYUDJILEDQ
         ZiEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753790316; x=1754395116;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=POGWpZ6qfhFiTvd9Pz2ShFbRonEQM2kdGcmdneyMevg=;
        b=IYe7jyUWCyIhuISZFRTTTBMXgegOw9CanCyQ7vpPoIh0ABgCvzL0v5vc6zmkjyamk5
         VrtV5U/WTQkDPSoU1EZpTpCm7jNlS/5osl+md6GXOcuEHlc+wMEsrwKazwvEeu8N3gbx
         DMl4NheTcoLP9sER+MjZpbEJOlqFCeYhya9LCDXDLzAkXWXwLI+SnIAP7HoM5a8aXgUV
         vaYmmsM29Czy6Gn2klXVLMdUfizQKmMincAJKZrgNIp5FA3oftcI4O8i4enCPEoE10X4
         eJx3Akn8tBRD2lVmMEWD9n7PHpLfV8Zo7WOut0i2lqUfm+VO5vT8mhgqAMWmBMxrbkKg
         PRFg==
X-Forwarded-Encrypted: i=1; AJvYcCVyMDiBmJBhkUHp9GtZOfJ4qnxLR75zCUpub+j6QC8HwBMYi4gbglviYUJ4ebATneDrMMv1UQresg==@kvack.org
X-Gm-Message-State: AOJu0YxsmkOipezTPdqRG248pJBLitWE4rRc1khEUGN6Gvp48fbt0f8P
	FufK3lWaLL2u8LkfdY50h3V1lgbrg6Ep5dtYyhG6JiSzgus3/lXXFctPIDIDROTBFGE=
X-Gm-Gg: ASbGncsiJ1wyrGvIBbzCx4uEz7seDsCIUfd9g4hHYAdZ3sWyNd5h2ip6WvTlVgnRMD3
	Mn416NhAeGTZWxYNd2HjitJh3qxG4yGgpexqKiJ6hhOiVOKKRONOtUyfvimKnVROPzAtVrV0htS
	sXd8nWNx6NjoSkHX7HhyZ/LHrWrclrLYbKBsThah/0b6XLtXo+i2ay4uYwELhoB0/zPh7BMBcuZ
	gWAZ1WdZB+HigAcGbDMFlJRnWzXG9NJJRJlMlKXUpo2t2CIzuJMh/MTqm9WRtSR4j2/NNKemvSK
	NP2by8XAYDW912zmid9Ok0KoaFfJFBpQ4hR7LoCACs103VwJ0nG8NOjP9fYM+a4JvkJTWO3BSD5
	A8r5LS0m9baDqZjiXBegBSILmfsKHR70hmGA=
X-Google-Smtp-Source: AGHT+IG1PlE2mU9I1BQPF6OmXGDdt5cctth20pJTLixg7HsQoYwzUDT2pBsAOMu+gzekNSgaFvaKhA==
X-Received: by 2002:a17:907:c0e:b0:ae3:a240:7ad2 with SMTP id a640c23a62f3a-af61c2af050mr1685740766b.2.1753790315585;
        Tue, 29 Jul 2025 04:58:35 -0700 (PDT)
Received: from localhost (109-81-20-172.rct.o2.cz. [109.81.20.172])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-af635a63aecsm576919266b.85.2025.07.29.04.58.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jul 2025 04:58:35 -0700 (PDT)
Date: Tue, 29 Jul 2025 13:58:34 +0200
From: Michal Hocko <mhocko@suse.com>
To: Hannes Reinecke <hare@suse.de>
Cc: David Hildenbrand <david@redhat.com>,
	Oscar Salvador <osalvador@suse.de>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Hannes Reinecke <hare@kernel.org>
Subject: Re: [RFC] Disable auto_movable_ratio for selfhosted memmap
Message-ID: <aIi3ao2PV8GrYtRA@tiehlicka>
References: <aIc5XxgkbAwF6wqE@tiehlicka>
 <2f24e725-cddb-41c5-ba87-783930efb2aa@redhat.com>
 <aIc9DQ1PwsbiOQwc@tiehlicka>
 <79919ace-9cd2-4600-9615-6dc26ba19e19@redhat.com>
 <f859e5c3-7c96-4d97-a447-75070813450c@suse.de>
 <aId16W4EaqjANtKR@tiehlicka>
 <3e88642f-3914-42b0-b864-4ad374b659b5@redhat.com>
 <ac7add36-808d-4883-a09e-ef1bf6fd6834@suse.de>
 <aIiSEpQhWqPsvaST@tiehlicka>
 <41526d97-b3bc-423b-87f4-7e0ec6cd8292@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <41526d97-b3bc-423b-87f4-7e0ec6cd8292@suse.de>
X-Stat-Signature: 3zk4596g6c6e453f3yji8pf6uecwr91g
X-Rspamd-Queue-Id: 4BE41100006
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753790317-838653
X-HE-Meta: U2FsdGVkX1/CcMmltUZRCCuyuvg9SbSJdLZtrgtGoLuTHbytjvpUjznVFdd+1oxE+qUklopolST5VpjSCXBLXeqky31vU8vwFonEiR/JWslDvbB6nFGhqeeraB5Z6oTM1HkrgLD/QN8BOKCNfERQ8ozkfpSQjh7z3+dv0iXNiHvVZCxN8RZCI3GZ4nOFPqR5W1QvVh1QnHOrAoRDIuasG2qLEG5fAbNV705818MZ1MA2lR63FqCtXfvKlnNfxLvYOwlgbLslFV2L/5OX6fwJhkzn1UuxMvTb6km9GbpHp/dImDsEqOZn8WdJf6AlSFNU+ISc/x3wioV3Hk4DahLPrpQhITwPR/C/PNz9iZs2kUKhy2+qsPDK3N31zx5EeUbNKXnw/0bQeodunsbhhmQ+f+RslsnPDU/bWV8ql7az8Jdixg0LSXkuoXLNIg+nEbPLwCz8IVIV1WOJB1ngkwD6wP7ONJtqNqVH8Ksr6mSjHoxSsTAtNHrUWycquRkPR7bygwzwPyUIvqdNLHZWDlhbTgwZF/ci2mhjBbeaIS1wYJsJpIIbD2oxceSaEg7sSpaQuKCJ4iOPHIpZgV4QAC57kIaLc2Fv4m2E0RjsaSoSQzIsDW3/zmBUx+GUK7qTciYMNzkO3yt30g+EH97+/QRb20ChSCccbFKDCgMpd4Y+zWkymBpTgq1ZdyXZb8FrEk78mWYLH4Ll9wIntbVaZ888BozEd1jMzOagji/78QsppNXcvGVksxKmE9b9eqpu0zCRbyHFrFBBqV/2F8VTutInO5E8kK2Y2Vkv3km2U/Qw956GUZ+dLgPccea8+S6OQT3b45e7mrT+mc/SIci0mtY8tRIP2yTNBA+YbPN2NWQTArsRDDDzPgCIsP/frHpmJpQ4u23R2Bnh6Q/KLNweH/HyOfWyYFicRLfWBYbOjTsoqSKfiPBqqB07eJuneptqVtzNvI4l8H0Uq66231FqvFH
 DnefYOt/
 wmfElsXxKuEu8sVeyOO2e3iTXxQ5tX9vJKzPfyTCBN5cqEEdqfqIG/pBiFibwYi4FEGFaUWCmP8upp6I7lBFfnt0zxutY4agfK0ot2iK/pMiAuKgqV+mbrbi1uh4UAaFsXIBWhbfZWC2oagJn/qVPPM64Afof7UOKnavObF2YefKrLDHPqeqvkY/Gu0q0VXz9hP7N4LAWBUdRZzMPOqJChHxR7mX+8BB162sNRTkRd/5pqw/tJLLCncJOYcbBAQOTq27mBsl8y3nRt6jtC5jKOf4eeLR+V3+5gzc/EysIa/mczICRS2hxHfaiC/CJCwgx1bxTAmktcewS7zpyg7LQvYH/AjJMVpUE+8eqvX60oyCfAEo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 29-07-25 11:33:58, Hannes Reinecke wrote:
> On 7/29/25 11:19, Michal Hocko wrote:
> > On Tue 29-07-25 09:24:37, Hannes Reinecke wrote:
> > > On 7/28/25 15:08, David Hildenbrand wrote:
> > > > On 28.07.25 15:06, Michal Hocko wrote:
> > > > > On Mon 28-07-25 11:37:46, Hannes Reinecke wrote:
> > > > > > On 7/28/25 11:10, David Hildenbrand wrote:
> > > > > > And to make matters worse, we have two competing user-space programs:
> > > > > > - udev
> > > > > > - daxctl
> > > > > > neither of which is (or can be made) aware of each other.
> > > > > > This leads to races and/or inconsistencies.
> > > > > 
> > > > > Would it help if generic udev memory hotplug rule exclude anything that
> > > > > is dax backed? Is there a way to check for that? Sorry if this is a
> > > > > stupid question.
> > > > Parsing /proc/iomem, it's indicated as "System RAM (kmem)".
> > > > 
> > > I would rather do it the other way round, and make daxctl aware of
> > > udev. In the end, even 'daxctl' uses the sysfs interface to online
> > > memory, which really is the territory of udev and can easily be
> > > done via udev rules (for static configuration).
> > 
> > udev doesn't really have any context what user space wants to do with
> > the memory and therefore how to online it. Therefore we have (arguably)
> > ugly hacks like auto onlining and movable_ration etc. daxctl can take
> > information from the admin directly and therfore it can do what is
> > needed without further hacks.
> > 
> Huh?
> I thought udev was _all_ about userspace preferences...
> We can easily have udev rules onlining memory with whatever policy
> the user want; the whole point of udev rules is that they are dynamic
> and can include policy decisions.

My experience with memory hotplug and udev doesn't match that. Udev
sees memory blocks showing up rather than understanding any concept of
what is the memory behind that. So any actual policy is rather hard to
define. You would need to backtrack what kind of memory blocks you are
seeing and what the initiator could have intended with them. 

While this could work reasonably for regular RAM appearing to your
system asynchronously (e.g. physical memory plugged in or virtual system
getting more memory) when you always want to online it in a certain way
I suspect this falls short for synchronous daxctl like usecase where you
know what to do with that memory and you can operate on sysfs directly.
Udev just makes the life much more complicated for the later IMO.
-- 
Michal Hocko
SUSE Labs

