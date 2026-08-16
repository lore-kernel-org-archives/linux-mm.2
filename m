Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 628C4C5B572
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 13:34:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18FF86B0481; Sun, 16 Aug 2026 09:34:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 141966B0823; Sun, 16 Aug 2026 09:34:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07D8B6B0824; Sun, 16 Aug 2026 09:34:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8B78D6B0481
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 09:34:37 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EA489A0583
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 13:34:36 +0000 (UTC)
X-FDA: 85107227352.26.167D6A7
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf18.hostedemail.com (Postfix) with ESMTP id 310B21C0004
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 13:34:35 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="BHT/Ih81";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786887275;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RmT/AGzwEAxbVkUvJcJEXPv+tY662th9KIiDQPj5yA4=;
	b=0/1W4AN0YqJ7iXSglHBPTAkrGSKeU1XX2k6vNdv/a61neKYyd8tMGFsvSXE0T/wtizzqKV
	esUBaEMQnJdIKJ9az/WXt6QB5nR9j3VK5A3PYXI8VgwW3hbjXtRlb3mPgAzIgF/nTP1Gh+
	Rv8pP5tQWfCPmiZTXmxvDY7KGqMNdG4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="BHT/Ih81";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786887275;
	b=Sms6zEUSWWCF/OCjPyRp+swy/jd68Vx/M1llpjsbrrj8S96gZ+Ivs/VBWZ9IumGroZ+lUu
	y8mLFX03UhgK+/rl6gdopOQYg11bhBMD4Tdos9+LB5l0bLLFMTiM+BaYmt1HMCOvxtboJz
	LEKehuiktPQsoaHQ/dNT8TErO0Zerp0=
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-5218927884fso25322291cf.3
        for <linux-mm@kvack.org>; Sun, 16 Aug 2026 06:34:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786887274; x=1787492074; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=RmT/AGzwEAxbVkUvJcJEXPv+tY662th9KIiDQPj5yA4=;
        b=BHT/Ih81ahW6qeQZuYbgyLbkR4V8FMF3NHWdXqxVTAbXSOBwMKXoxEi2BKHiDLeNfh
         2bERKvBmIkhngb+THimw7wd6wURRkOs13iOk9pqhAJpdP7aadazx9n66fiE0ksmlVOzI
         Jjug5CCtFwNQZIwF53GV3qfNGZ81iFL+Cyn7bRXpgBGYGLMl0FfN1CVddbLGGDobYyZH
         KPZ6pWbQ+pwlAFtDduEHuSVSUrYalXLWU4jjeD2TD8nJR2ZshityOkx3m3JjagKHTPxc
         04q5n8QfHYR2upkoLp2Dv4kDPC/+PW3eAUkdunhZeukQGAhgBeV0wJqfv6G6yu0lZDdo
         zSdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786887274; x=1787492074;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RmT/AGzwEAxbVkUvJcJEXPv+tY662th9KIiDQPj5yA4=;
        b=WxlISxzQ9G7QhFfB8kF2nIQzbhzoT/cup5ZyUwjBBfDSmgHXuwcxV0+925TYoWhkIi
         bn78LDfVepBWdvARQelUV0074eWtyYn6Qk+8IpILzUJpH4GupepWr3hxZ5NEvLuOeXmb
         cjg7Z2+yFGTLq7ipAsWjueZ8ONts0RNchamvAJmncdoBfO4h0lZ2/qRmkiN3ssguMS/o
         nfUrOxb9sC9SpbVh9WbgdodmhCIpojj8ZQpZ54bpLoxb/7VZnWlLs3J7vrondyIjimTY
         fNt1iQDP967VWmLQuPhX0kpBYpEQIGQd2GDMmmEiKdPreLx0bIGtSIUfsT5Lfqut5f6O
         yX3Q==
X-Forwarded-Encrypted: i=1; AHgh+Rq85tlX0p7KGZMd7Z3FKkYxbgJbvNP+0/mGUKJ6g9382daEeHi85y6soXX6qsFHxUiwQe+HJ0tL4w==@kvack.org
X-Gm-Message-State: AOJu0YxcSeBkTE43o/5CsqxTB1fZxOx8aHCsRyX5WeeMwLfTXiESUXF/
	nnAdHwGKLsTA554QqyZNt8q55f1ullQDQTC1mGNJN8GXK/2m+45q750R
X-Gm-Gg: AR+sD13BQS38uJ+tJFotLuymLE1yEoGF3RcIGBOe9jKl/H6xln8enEvPgClManR5IJ4
	CZFtq2B/3ctA/HHD/UCqI/UxSaRNrsdO0jUUHZuSbiok+9ZD+gTi2PEkWI7K0ozXPBBlWp4QFc0
	pRgHJS/J3fY9OUHfIWrt7aPYUnG+5GrlxZlOtM4Sjl20DVfX3Zw5X+jCb+0EwQQ9etI88f6VuYa
	pcstz0fGc0w9KtP7OFwuc3Zu2L05d1Au7ruhJsn07kRSAn4uBOxDYG10J+LgkrxKgOnaS0NTQ9m
	/yP+8pXncap3lEzFKiEWq2t4DWhwo3eMEcYgXxGG5iwzPq20hh2TT3f0Bd+Ir6YWfkNJ8oqtIaB
	Y8ES/qNXv3MRhyNQQflTw0O4efv8x0OtPhvBlGSHnpDurLW8sjIVaBkFtpX0VEClRQjzTH9ArZk
	XWl/w3OQgR+XGIRH/BLcR0pR6aONE1h3lFFON1/iZcDoVNaQszpNlEg2E7Yvue42I=
X-Received: by 2002:a05:622a:8d12:b0:52d:918b:92e1 with SMTP id d75a77b69052e-52d918b9790mr143650671cf.5.1786887274314;
        Sun, 16 Aug 2026 06:34:34 -0700 (PDT)
Received: from skinsburskii ([38.69.194.34])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90a93594436sm59883946d6.46.2026.08.16.06.34.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Aug 2026 06:34:33 -0700 (PDT)
Date: Sun, 16 Aug 2026 06:34:32 -0700
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kernel test robot <lkp@intel.com>, David Hildenbrand <david@kernel.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	mm-commits@vger.kernel.org
Subject: Re: [akpm-mm:mm-new] BUILD SUCCESS WITH UNVERIFIED WARNING
 e0ffd277b09a7c9f1a436e5f75be37ac490bc59f
Message-ID: <aoG8aLLa2l_G1GRX@skinsburskii>
References: <202608101053.PhnVUM4u-lkp@intel.com>
 <20260810132334.3cf85dc3e9061bc7072759f8@linux-foundation.org>
 <anu1N-DOnQwxO1kF@skinsburskii>
 <20260811172713.d9f98913055bf8dc8331cda1@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260811172713.d9f98913055bf8dc8331cda1@linux-foundation.org>
X-Stat-Signature: fnbp5fw9wetcbob5mepr5i5oogfxnkzf
X-Rspamd-Queue-Id: 310B21C0004
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786887275-829187
X-HE-Meta: U2FsdGVkX18lYjNoigLMenDCRqaPTtpoW1RMu9MmUEaVIMaUFAYWTEhIXbZDJjOWL8zD7EC6tCCBFjNjPOigr8vaV9/+N04F3D70SRCPGedwPLWK+cCC1AAHsvnnb1MuSyvYJ+uw//zE+YLK+pbT9RRN0e36CCtmtiT9PShissLxmsNZYOx/3vC7R6/XYfsXA+zQ8IqSwLcVnZXYy8JhHYQoBgi9hLLlOOLTJlM6JAfhZUIwAXA9cOnRN4d7lrJ1oCA2dt3pDGhba0P7DUbp4SAa7GCOHWZH/E8nRgFs+ZxsIhQ8QGupIgF3Nr4cSmYv9KXaTkIfr+Llwf+sIdKehRIpBFTrdc2gx4rYCX/hhlh69EAjSpthTJHKtn5yglzKXb6sB+ES/NbBPcp3S7GMCYe28cK+6+0FVCIQrRtsMlt7HhYhzl1Q60fL0X73aj7MEnH3jicFV/qF74IngJayISqosM9ZAbyWXcifoiLFble0rsqh6kI1JsMfsYczPlYbYQlyhpOuTDHmY4q2PKd52W78X6+O11ffS4tCa01ldPMnFzjzlSd2boYrh5Xduxr6b4GScZZ15jnldY5vGwV2ZZvynsZrP/aWDr6R4itU9prlT0wy1jf9asfXo4yk3mkX4GCwmGqv5ti6XcCJyi0Z0cnNv9dNjBQu8bqWlKY9MqDJLskSxWFcQ8HEf8Q4JoOwV4KuXIU8PXId9qzdtzRArBw68uAePtsr7joO9fcDI3Rtk/50H94MXFb1HBjrk5SQ9rbEN2boI7lLQGUOOvz5kdm7NCTBLQ7r+9FZuZuN1eAUE2HiiymkoM+Hr4Dn5BEj0RmyL0G8uGaEmAdnnyyNPwkxAqolZRSGVBJi4V+agPS0b+0fCjsc0mKsJ9QDy3LFVjkvfwY+cNn1Xx7bcpNe4ai53OqsLzWRVMgzNPRf6Slj7cwACPAm0m799Z7AJnoASnVxc8bQmzsiZYgs+5O
 QTmYqCmU
 0Fj80RGECO/fr2wHGUnLopjgOFkCsGhNsbFRn5YXvabAAOX452dSqiCPloUJMA2UQrFTU/etqbUTIGo7bzoYg5QyTfRa44kK2LwbcDIcEH6nxfxJR8Tl3irZd1ZQHhbMptS8Z9cmLGGFPRWWSHp7XxCWcxs7UkJi+6A4xug0gFZS0hfjCQwDhNFc7eiYqnvoam4M9UXs7UT/gQSacfSCo+0oYEN7sjSaL+eqzhNFDZDTUX30MoYOlUBT96WXKfx3GUmKnla0G491kU7lpfYRxPAH92sLoJ5tico1PoesfufImh5u0Gn7E9yS3n2fb5t1AzIj0i5Blo62o+vNFH3vcE8ru4jYgROyi2envUBl5xzph0oBVuQrz11r+aNTnSqd3IXC2zAvZPX925D0qRyJEif+/NNfAmPOeOgY5Xw5blxnpD0wuF0+c7C1cdDjbddTTHAAYNveEoRnC72uGP1hl2iv3jjj+Rj63YGVDW/V98YMLcDOZERviaDh8Ww==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11, 2026 at 05:27:13PM -0700, Andrew Morton wrote:
> On Tue, 11 Aug 2026 16:50:15 -0700 Stanislav Kinsburskii <skinsburskii@gmail.com> wrote:
> 
> > > Caused by
> > > 
> > > 	121170831228 ("mm/hmm: add hmm_range_fault_unlocked_timeout() for mmap lock-drop support")
> > > 
> > > 
> > > Stanislaw, you've previously said that this is a can't-happen, but boy
> > > I'm getting tired of seeing this warning report.  Would the below change
> > > hurt anything?  I can't immediately think of a cost-free way of doing
> > > this.
> > > 
> > 
> > I think this change doesn't do any harm.
> > Perhaps it worth a WARN_ON_ONCE to expose a wrong fault handler
> > behavior?
> 
> Like this?
> 
> 		if (ret & (VM_FAULT_COMPLETED | VM_FAULT_RETRY)) {
> 			if (hmm_vma_walk->locked)    /* needed by sparse */
> 				*hmm_vma_walk->locked = false;
> 			else
> 				WARN_ON_ONCE(1);    /* broken fault handler */
> 			return HMM_FAULT_UNLOCKED;
> 		}
> 

Yes, or even like this:

 		if (ret & (VM_FAULT_COMPLETED | VM_FAULT_RETRY)) {
 			if (WARN_ON_ONCE(hmm_vma_walk->locked))    /* needed by sparse */
 				*hmm_vma_walk->locked = false;
 			return HMM_FAULT_UNLOCKED;
 		}
 

Thanks,
Stanislav

