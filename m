Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78E90C55838
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 02:09:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E572F6B007B; Tue,  4 Aug 2026 22:09:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E08016B0088; Tue,  4 Aug 2026 22:09:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF7826B008A; Tue,  4 Aug 2026 22:09:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A9B0A6B007B
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 22:09:17 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1AA8C140370
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 02:09:17 +0000 (UTC)
X-FDA: 85065583554.16.78B2DCD
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4665B180009
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 02:09:15 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=FNLBAO+B;
	spf=pass (imf16.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.173 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785895755;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S+S6S6s3ykcDL+sn4RRyfl6V6n9KypIakUfUNmNrjYg=;
	b=VzOfXoy0hGTyuOd17IoOmmN8MT/uKtIiLVl23ttjH7AMd+4upFsfBV/1Xt4HDfgnLuzTpJ
	vtSdvGD3z3Ww+wxOrKHn60J9L/Z+BMYXY4nld/zXuQvtn7sxAsSbU6t+P9zAP4TUNr3iaB
	w7kvXSpUc2CNW7kS1OTCHnGDCZqqMFY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785895755;
	b=VAsGFQSyLdNuRbJr1N/b8yIN9Trp+m0UbtnoH4r/JrXPJfu19F6Gu5Q/vAX6j3TCOIWG48
	R2xTZW9JCI9Qu8l1fdVoCcwg1/XZggrNegCZBnsCm1jYY5YSx79JR0nxXOvixTKPcdN0jk
	JVfNOrx3FSccKZ0vkPcuzTLBUaokF5s=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=FNLBAO+B;
	spf=pass (imf16.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.173 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2ce7d2adef4so7392555ad.3
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 19:09:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1785895754; x=1786500554; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=S+S6S6s3ykcDL+sn4RRyfl6V6n9KypIakUfUNmNrjYg=;
        b=FNLBAO+BwoFPYtABzEQzK4NaRdmTxihc4zYMLJTtzAm2c83gVE2oPifAtmpMxWlbWK
         Z5qkZkEWUqyAQxfezqQTHVpjwVf4NwlGneiqjckv8goEX6bwKBJN5JFj3zhlvICd7yuD
         a1VAJQMoZQPn+bQr1btfbW70pGTaqyyrfdxbk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785895754; x=1786500554;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=S+S6S6s3ykcDL+sn4RRyfl6V6n9KypIakUfUNmNrjYg=;
        b=kXvXQ6N1B9OC/XtMrKYBo+gqB6tircSvSDhQAo2eBWmq31AeXDoVrohZ1VGAWSPvqx
         j9CdUg2DbbvnX9L39pYo6uV63zFM8tPYkVvTZd2OH2/5fR0OZELfMUZ8IWhoDU3yAU3M
         gwjaTDr3yGOyC9bO/bIm98OyxAqvVMYgk3d37wR51P6yijxSqZeT2OG930uo2hWJywsZ
         QUkUSlXO/VWwMrLf1CN2sqnltep5S7SeSmUoE4O8bZn4K2c6q3HUpZVVzY5ljkckqN5h
         bGRympAqcWwI8zv1lA84vHSg8PMdqkJUS4XJsVJHA1G4gBevYiOmyKFkhBXGnNFjsY5U
         eqHQ==
X-Forwarded-Encrypted: i=1; AHgh+RrlwPuaT9o9NdGK9eqr4lpEpit2p3SffniQM8zIHxpX92rU06Ofz3nGx6FW8rul9EyiH15smqir5w==@kvack.org
X-Gm-Message-State: AOJu0YxB0H4iP0beDpaS8W6KOUlXrb/UT+MbMD2lKyr6eJm0m9CEwA6m
	+t2JAEbH+fr8xTWV74IIDf2HpCFJQSOyCn1GhhrdJsM/rtKobKPV+IEI+zU40nW8AQ==
X-Gm-Gg: AR+sD13lUerBYFA5A20annRc77YtLDEckIbB4z61j5cOit1wFWeFMaII1Ib3vLQ9ZRI
	zRyQ2VLZuqX6E0Mg7aoNw09NQlCtVgT1AInagDQUg7r2ZSFJtYCLrxKxwfM02A0EC6+uJQmagVj
	SUGDYVIgven8H6cnReOEwuH5O2pldRfCCuwV+U4mJowwQHVlpijEQJrAW3Siq8phLagatI8voMH
	q32S3aQgfSW+x744VWzemcrqJ/AgUPeDigZ3mSDbeNQ23Y0FkI2MKmlR+RGID8O9FCC1BoRI36D
	Ym/+spfN1VCSsMEOvEhtc5y1rtow5DIw57bd4/iSvMtjOCrvwUNe/HVP587OqAySXak8WuNuqqn
	00Ms7zQncZcwdfApPhkjrwGiZ+2rV6Iehw2zJgRuAqnpRMftexFRX6pp0Lsv6ExjeEO8CPMLrMO
	ZSPiImfLm4eZQfQAdxYh+lzENe89Z/NfNCpcpIaYr9Vw2XM86QdhX7JO/eRntTrNtIBuJ2iYFll
	6hUZpbFaNCAglKlqEuu4m3d5scd
X-Received: by 2002:a17:90a:ec86:b0:38e:bbf1:de34 with SMTP id 98e67ed59e1d1-3903c537a12mr3426590a91.7.1785895754136;
        Tue, 04 Aug 2026 19:09:14 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:32eb:b46b:e9eb:65c5])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-390392b2b7fsm1235640a91.14.2026.08.04.19.09.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 19:09:12 -0700 (PDT)
Date: Wed, 5 Aug 2026 11:09:07 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Barry Song <baohua@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	akpm@linux-foundation.org, bigeasy@linutronix.de, hdanton@sina.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, minchan@kernel.org, ryncsn@gmail.com, 
	yosry.ahmed@linux.dev, surenb@google.com, Dongdong Zhang <zhangdongdong5@xiaomi.com>, 
	Suleiman Souhlal <suleiman@google.com>
Subject: Re: [RFC PATCH] zram: avoid preemption with CPU-based compression
 backends
Message-ID: <anKaU6VStrW8zaQo@google.com>
References: <20260805005545.66112-1-baohua@kernel.org>
 <anKQ_qZ1-Q6FchZ9@google.com>
 <CAGsJ_4wD+KNL0yMkuS4GijbHaiyPxgTmqKzkr0DErC0XH30w4A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGsJ_4wD+KNL0yMkuS4GijbHaiyPxgTmqKzkr0DErC0XH30w4A@mail.gmail.com>
X-Rspamd-Queue-Id: 4665B180009
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: yrjq96jm8mf4qs1m7k35c1fe7xhdanh9
X-HE-Tag: 1785895755-796209
X-HE-Meta: U2FsdGVkX19ftZ+1MzcWN5bP3mMf/rgDBLFYDj0ZBkPb+wTToy5b5qiCIChuk7nn7DCnPu6fA9BTojHXV6BgxOLhAxZBt1dZHbpigkyQ1irZGxgvBd5bebn2piL9G4Tv0cqP6Uvwax2aSZwwGYo/V+UzyZZwzXKh8jDa8voPuMCVRNVBq7P9OcA8SNII0h2uDsBfI2pczBn3EC8XwmPvq6rykH5PwkVU/Z+fNZ/n6n0Q8pz6oNb73nxWOqkIU91kj2r2ZLuSKTMSPBGjTtRonJcp9wPxzH94zdueP7NKLYSLs6FaODDcfZzMsqZccans3nG2wQ+9mkFDHmRJ/CYVEUpAvfbqSzg7NmVw0vl8LoQLfxKGOV+8QXC22pjmeIBly0R60QgEG8+sVS5b/Peatp+Ff/GI53FS3IcGdGCR8gYUesIxOlacdMi/QxLx05Kd/do7wXaecK5E6t1k8dGzO6ykjMfweqs4ojejNAfk72+ftQzL8Galrb99KsZ9lIZX4Q9pvS+wOYa3aGHooup1rii04cwrMAfqlahI5jaOhK8mtQ3E0N6TUgW1fpPQFV+QfX1abl8eiC7hkAAZg6s01LKAFBhXHdDNDrw5ecgJsc7JUykY5bIkUXN52x0OrVbEmoW4UYLZ8VDLAOaY8p6EvuTUsG0DbkFiUu9Zm8py3BKPsmw5GDizBqGlZILBGZYNiUwhTiZMJhDf/bZ6TB1HiQ0+RGx8k/ZbXCg6KScdlRLGh6bN+qlQiu1dVJmv4bxGVj3u3b2PL+o7GawlfQNqF9Vm1sgp6TbB63YSw4iVdOJUfLExdoU4hZmZhuF9ukcx5Husze7h48Y3B8YSkxJSeIXyo7C63SuVVyzF+U5G9uI8FjvEjSc0kDRCyA1aQ5flsMqYDX9ToafYa1O7uQ7dszfznxDGYue2eYLpt8A/KS63AMmu7nLxldd7/lpiuc72TkPAEnn4k83iJnfQgO7
 1PMEwsL0
 LKc1/A76uykuPb2yjdf+5fgs5Xh3SxU3Jb3j1V8U9HFqJheuuqFWZiS4EemGlgawz2S4ZJ94/RCMW93DVcJ+uTbG0y5SCy9eguaU67Y0rTbcMoeL5z5Db93lQdMmVCWFv6K/91BB2ncjR09p9VsZToHWT7q7NKibIocOZgShjlJRjTrAYF2yQgBgL7r0aS1jTFMg2E0WsZhXomKcn0m1i770HTXmJfRjyP19z0Gf1mdTOZJe/fSTIor1XTWxAC4tGlIt7H/qVfRudjLLwIcRlj93z9VZG8T9UAEnbiJb0HMsNscYsF9e10nioxTMSPaVRH0G5wIO+3V7vVzrTIaVGW/UEKkPMdFHO+FglJQgckE0GS6A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Cc-ing Suleiman

On (26/08/05 09:57), Barry Song wrote:
> > On (26/08/05 08:55), Barry Song (Xiaomi) wrote:
> > > Since commit 2efa9e9eb4db ("zram: permit preemption with active
> > > compression stream"), a major Android regression has been reported.
> > >
> > > The reason is that compression/decompression is now sleepable and
> > > preemptible. This means a stream may be migrated to another CPU or
> > > be preempted while holding the stream mutex. As a result, high
> > > priority UI threads may get stuck waiting for the mutex during swap-in.
> > [..]
> > > We add an async flag (currently false for almost all backends) to
> > > indicate whether a backend is asynchronous. For synchronous
> > > backends, we use preempt_disable() in the !PREEMPT_RT case. A
> >
> > I wonder what does that report say.  Is that what I think it is
> > (we discussed something RT related privately recently)?
> 
> This report shows that the zram mutex has become the top lock
> contributing to UI frame drops, even surpassing mmap_lock, which we
> are also addressing in multiple threads. :-)

Any chance you can share more details?  Are there perhaps RT tasks
in the mix, priority inversion, starvations and so on?  Can proxy
execution address any of those (if it has relevance to the report
you are looking at)?

