Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A26B9CA0FF9
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 22:52:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE7BB6B0025; Fri, 29 Aug 2025 18:52:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABF7B6B0062; Fri, 29 Aug 2025 18:52:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D56E6B007B; Fri, 29 Aug 2025 18:52:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8C74F6B0025
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 18:52:17 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 30B04119DCD
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 22:52:17 +0000 (UTC)
X-FDA: 83831295114.13.B9D94EB
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6B122140005
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 22:52:15 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Qg/UkcKy";
	spf=pass (imf26.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756507935; a=rsa-sha256;
	cv=none;
	b=jfRcaPVr7jXr4PN+aC75JuZt6LfdqgP1LTcb8d1u1L2rNKWAgSTxmjBmFQQ5z6Isr7Lb0M
	gv2dyxUXcVNaeNczsCNLswtCejAczrpTZaMXbN1Ei4Qx9Pxq0rb++gFOQIuBDAuGRzcJvM
	1j0rlw7R9/b6w8svIZvo8YjInLODRO4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Qg/UkcKy";
	spf=pass (imf26.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756507935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ub2Ww0VQ6nRQD2cRJl9mOGNTS7FBmsfYEZ9UU3eods8=;
	b=SVP0W2VXB54W1ejMMIL1F0GCgMAUKxR4r7dQm65k/KAbIgRZEa6eE7ZAiuASkIY32MYaH4
	7HH3dsI1bZNw9ldv8WhmtZH+ebyeaGmZFddOaA9Xr+CTEXynRENzGU1F533yoVnKrDBYjC
	S6ZoaoD63pr6FxA5vqwqNUXYXLKsx+c=
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-771e987b4e6so2101523b3a.2
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 15:52:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756507934; x=1757112734; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Ub2Ww0VQ6nRQD2cRJl9mOGNTS7FBmsfYEZ9UU3eods8=;
        b=Qg/UkcKy/p+ymc319mhb0ldPskhHJ2GSk2Sn15xtxj0XPIR6G4ubkgwNq58ecW1at5
         FeY6c3mxy0xjsmct/3OITgp7/f9po4ZUxM5CsD5QQYWS6g/wp8jd6JG+Ii5nP2U8xlRo
         l0rzpJ17EOPap/gbVYpdu+gLPu8nKubpg/4g6JVECaWsVanWf3QsE1DMZ1QXBVEYgfGg
         DDawfY9uN8VFo8lVCedDNROPWnA6UgkHIYXSy309396wzwBxoEnCEiG028IBihOySJpy
         JPjeJlfh/O4JGTtNWaxZtK0GGSGXpVwIcTC9KlW2pX3cj0Ec2EW+590FmffQRKN3bWZt
         BiSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756507934; x=1757112734;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ub2Ww0VQ6nRQD2cRJl9mOGNTS7FBmsfYEZ9UU3eods8=;
        b=eMDc4Bi+FsVDdl8eGHK6FbDRtOJJPB0QekEf2kS17+9kVaHvYiq+zlZ1pX9FuyYVr1
         Gqh1tl1//kw3vdkrZMzFfRyUXTUmJ5gcVXb9udHe6WLYUUGbmouvlqaP4XF1pTkS+odh
         Kr6gX9xU7n8E5LadnbzWHcELnrFggX1pxIEa0j9OGEsBmGltMzMtdeseN5hWldwRCpwv
         gQuvPAbpt8mniE/aW10p4vgY8P1FkaSjDaUjN5GaflHGy6A0Qpq8PL+L3+ExFoZ0xCBv
         lyvvSQlpRjiBW9r9SmZr8fU/QgtoWU+QTw8xWBaatnk/GH2sqkNfBGTmwHfhdggp7JLb
         R7vg==
X-Forwarded-Encrypted: i=1; AJvYcCUCuzw6Yd8Iq6vSYHufqklqG/dVgeVopdcAXTrxv5x8wbzDkjUYZwSmakxv/7LgXtKM8BL5LIkFDQ==@kvack.org
X-Gm-Message-State: AOJu0YzdqEOR+RPrexUnOSlTbiLdqkgoxv3YkfgqCf0OQ7/um4XXiDnK
	hKQ/Tc3oGcuuUy5HJKxTKZAF05Y9uuLnr1QhR5aqn2brephDO6Gd+Ec9
X-Gm-Gg: ASbGnctbWv34/VpJvnkI9V2V/PrdOB4899ZQ1j7Hof4Zz6mKRHNPIHfRqwFYLv5oAbu
	7zd8FqgKRuQJe7zoh9J2KYjUzkh14Izwa0ST0AE0ljBbFfe462x0TY8YIuYDh7+0VcTv472Kmpd
	/lgOGfdvvO/Z5T6ZF4xOMZUoEjbbRMK024Mbd+PVAsmz6+Hz7Eq0XYQ6r+4nTdEWt5qcUMF4ZNg
	tT2F0NbCWK4fbiNQU3CR/lcFVP95KcMtah72ZzsOm94W/AltWPt08YOpWXUk3hqbU5Eil3cry5c
	qTdj4Cqde4DusIME8ijrmliFDl71gFRjApSCywPw5KRBPg7zAG9Aii23/PYH2wxBHhfvBkaF5Qu
	+rDGzDSJ4N6K7AiKWcmjC7GiYnj4Z2iSPEu7pU+qdsDPgW7JjheUQ4DSmeQ8+H++D
X-Google-Smtp-Source: AGHT+IFzWvz4pQi+E6K2m0w4vMz/X4+sVa3l/qLXBdfOtJ5zgENKlC982L+s/HdfG0gdcnJyRJUeRA==
X-Received: by 2002:aa7:88c8:0:b0:76b:e936:607 with SMTP id d2e1a72fcca58-7723e0d3420mr291138b3a.0.1756507934178;
        Fri, 29 Aug 2025 15:52:14 -0700 (PDT)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-772396d2b97sm1065519b3a.67.2025.08.29.15.52.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Aug 2025 15:52:13 -0700 (PDT)
Date: Fri, 29 Aug 2025 15:52:10 -0700
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Yuanchu Xie <yuanchu@google.com>
Cc: Max Kellermann <max.kellermann@ionos.com>, akpm@linux-foundation.org,
	david@redhat.com, axelrasmussen@google.com, willy@infradead.org,
	hughd@google.com, mhocko@suse.com, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com
Subject: Re: [PATCH 01/12] mm/shmem: add `const` to lots of pointer parameters
Message-ID: <aLIvGsEvXSoNDbKl@fedora>
References: <20250829183159.2223948-1-max.kellermann@ionos.com>
 <20250829183159.2223948-2-max.kellermann@ionos.com>
 <CAJj2-QHVC0QW_4X95LLAnM=1g6apH==-OXZu65SVeBj0tSUcBg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJj2-QHVC0QW_4X95LLAnM=1g6apH==-OXZu65SVeBj0tSUcBg@mail.gmail.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6B122140005
X-Stat-Signature: 8ux73t1efpyu5f756h8fhm56z1kjk8fi
X-Rspam-User: 
X-HE-Tag: 1756507935-150710
X-HE-Meta: U2FsdGVkX197/IE4OW2GObeOVb4SN0Xttyapt+xbZ8XYViUBUMMCZ3UZLUoB6X+dQed6XkTMxS+sbUCOqXAy9OLdXtBe4xv/679VZ8DjJB5CcJ+3evGtwo9isMg+h9z7+J/AGx3eOdnrR9XRfjHEyv+EcJG4M8RoHOjqEaGf6ttlfITPZimlEIj1LPjfZkk1UsFg0OTmXfI4jvN/kEadUQwAT+8/k2PWAf9z1UkSTVZHzgMGxQdtpjJUoFE5I5OQ7MSjGoB/6fnT89SEo9PA34yu/O70XmHeQRvEyVMfQYSIxWpTx69neC+CUPk1blyR+lxm6HjqsDUgLw7H9/p4KbepYnPZkUKcO1PdZZWVgFa9Nb+/vzPBs0Qwfu0DFoM47k9ur0b7SoHtcl/Kqebk8jJOsR+gEZJg6BsVR9ZfyA3o9jOCpkIZCrfFjbrJIM45IDVctuxYZEF0VmVnZahI3Ehemi81l4YGx/B8VwxwqcwphtJRPEYLWWF/Vin2NUxN9BpWQHjDadptTSTZ37JHrzQj1yumuQMLwoo2MO9W0hrkW3oEf0t6tbkvv0P5bV6XOCmMYPylq4os/jhmgw8I35MLAqmfhF7oWDjqZ4Pwg4/bWa7aptul3J8UVVc3iJEZAYP2HQlFAw0kX7Nrp6G3mTreuIcDaHj4p3RcooeOutqZECueO7SxW+sntOwvXAsdR3sdWwtsSLTTP2rhPRt8nrwnUzLdvrADdU7+gfso7XRBSNjkUyZWY12aDAI/cE8q17VKqAwEpNNvtAexggi2w0vCMUMZjRm6c2jXKXGxyTOhZIi+qJfyW9sRdFcZaqmI0iWedl1PRyezg27ShkcUanmicf/aiWLvwstE/XeKt8jydONvu0Y/jtmoMQiPnk9T3xu+iFK90M+bVx0CXtJMSxVKF1YOWxosLNryD3pMGwXWcE4xJDsV7UOe7rwrTIYUkgsdWO8XujNfm2HC9Yz
 VdA1pFlb
 fRwE2qwurgOUS+n3k84fWLMfssAFI/C+YlEP/vK1rgWCrPH63U8lOYKOFGAHdiXgxa2zGAYiTpZl1eF/bobHU+ebK4w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 29, 2025 at 03:44:12PM -0500, Yuanchu Xie wrote:
> On Fri, Aug 29, 2025 at 1:32 PM Max Kellermann <max.kellermann@ionos.com> wrote:
> >
> > For improved const-correctness.
> >
> > Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
> Reviewed-by: Yuanchu Xie <yuanchu@google.com>
> 
> Appreciate the work. On a side note, Andrew previously mentioned[1]
> making the actual parameter value const (which is different from
> adding the const qualifier to the pointer). Longer function
> readability would benefit from that, but it's IMO infeasible to do so
> everywhere.

+1

> [1] https://lore.kernel.org/lkml/20250827144832.87d2f1692fe61325628710f4@linux-foundation.org/#r

Imo the lack of these value const's isn't a blocker, but it'd be nice to
do that "For improved const-correctness". Especially when you're changing the
line anyways (see mapping_tagged() or folio_contains()).

