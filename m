Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB2C7C55171
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 00:17:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 827C06B008C; Fri, 31 Jul 2026 20:16:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8003B6B0092; Fri, 31 Jul 2026 20:16:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7186E6B0093; Fri, 31 Jul 2026 20:16:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 449CA6B008C
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 20:16:59 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AB6031C025F
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 00:16:58 +0000 (UTC)
X-FDA: 85050785316.02.286B6C9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id 330FEA0003
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 00:16:56 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EeVcjbfB;
	spf=pass (imf15.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785543416;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YTUbWgbCMoV9mNudsltxaFWvTkWg6x0Ijnt3ApilYfU=;
	b=beCpgtOI/h1IPm+8OOmfTUn6YOhRjErRNoToQ/JpvUPDTYt8srnlYI7pf4pA9l5oDpm2wd
	3y7Tc3XkqgQCRZpz4hy099X0pNvL/DwXQe2bI5hUWQQVbxSh/v5umOuefqeskXTKn8LGhw
	xCdwMUCpcC/9CCa922YRDqDmGeeNS2M=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EeVcjbfB;
	spf=pass (imf15.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785543416;
	b=evVLihx9osqK4+pdzxj+89RuO6olTdAJvHBGI7D+ha8MqIFWnFsUNCRLns6OCgVk7RzNIZ
	+orjp/gOvbhB8YzjsHUpeFQB2sF/jh/fvUe8hfkQSOC8P/RXJgjIh53c/8ASWelAgcsmya
	sWV4/yDke6mGyIpxBJiWH6H+ciXtqX8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785543415;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YTUbWgbCMoV9mNudsltxaFWvTkWg6x0Ijnt3ApilYfU=;
	b=EeVcjbfBTMiiYFF6PfihcgrsOuD5OveM204zZW1sYbSejhv0THkmPRE3rXlpwmPUgPoQpj
	RTljvRb1hU6uHYeFdMi10hmGOM2wcF7bEFQMAL9NxsmE5R00jDnJKWNfOQXdChP/HM6em3
	D5jkF8wOSSAIgUSQGFBA+Zy32eZZ8O8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-471-cy7hat5WP7-2m8LetrD6RA-1; Fri, 31 Jul 2026 20:16:53 -0400
X-MC-Unique: cy7hat5WP7-2m8LetrD6RA-1
X-Mimecast-MFC-AGG-ID: cy7hat5WP7-2m8LetrD6RA_1785543412
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-47f6e8b5996so1821094f8f.2
        for <linux-mm@kvack.org>; Fri, 31 Jul 2026 17:16:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785543412; x=1786148212;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=YTUbWgbCMoV9mNudsltxaFWvTkWg6x0Ijnt3ApilYfU=;
        b=Ugg2kL+XpfxTylsJy/W8nqHFbWvTGkA/QvMJFPTnvNSmRw2JjrpauFMzt9cOT7F3X2
         tfXkVi+8/6hBO1EKzv4lBrBw/6c8qp56uIwFs2YAIW4IWF4Eys6fPu2S+yFQJlKeFuDj
         DjEfxs26wwrDxSeaxiA7OoWpxF5FAC37cUAx/Zoay2h6C7tkxnWgUzUBg840406/8REB
         lEBP1bCV6bICYV+LxTeq8hs3L3kcBceaR67EZkM0lPTcs8yp71+xjx3zwaQysQ1Kpmk9
         RqY4IWscHaeHlAnN0aNX1YnFxR6MAalwweeTx5X5VhGub/F9upnnFGViKJkxPmJCEhbL
         N2yQ==
X-Forwarded-Encrypted: i=1; AHgh+RrncVqjuAdh4Uj0YHmZnuEyctxX8GsmyKYSLgsAg0te97MaDs2TokKFIcYqDgtWPLdsMFcD2LPDTw==@kvack.org
X-Gm-Message-State: AOJu0YwOOw3whJdoVHrJtPIcv2VrB5WY+GJAoDEFDpPFVS/M70BLEv7w
	fvRAFsl0UdPJfsTqj+fB7adcMf5RRODxqbIJZqgrh2wNluqwmH3LPcDkzRF5t9V+i5X5dy3mZ6f
	ThNljddwGXuHFP3fYOmfT2IKMwIcCOdwkmodEjp10Fbv8Viam39wb
X-Gm-Gg: AR+sD109Mk8kKSPvlbPPEhagriodNN0TIm/Xe/l8XmkuxnbLASVPKuDWwpRzrAqju8/
	Wch0q9kdOjnWR/j3nJxGac2pbO2Cbp+GR/ya+T8NTlrzET8j+DBM02Jcgeo3lcjOOOF+pZbNwwR
	AIrfGdyBGudU/s0fZw77ROWecH4zNvDyA+vfyuiHrt1uPul9RNrfWI5KqeDU8PzysPPsVOOqb0G
	lTJNs7BXSjm2NMPgvBUMlxMIh2GG9IX5Ds0mLiUWQeR2WArn2+4Zgkl4NsIz9untnkjzMdy3jmo
	lU5Ugr+w1daQysloCSE24zowJ1kVMInY0MM9VAhC5eY4xGNnWKcFjZnKUNciMbeqx2uXf7u8avZ
	yl0Q5rMkAK1Nx2vQ/ajilMO8=
X-Received: by 2002:a05:6000:46d8:b0:47f:6a3a:9e6b with SMTP id ffacd0b85a97d-47fd72f1612mr1988334f8f.32.1785543412353;
        Fri, 31 Jul 2026 17:16:52 -0700 (PDT)
X-Received: by 2002:a05:6000:46d8:b0:47f:6a3a:9e6b with SMTP id ffacd0b85a97d-47fd72f1612mr1988296f8f.32.1785543411814;
        Fri, 31 Jul 2026 17:16:51 -0700 (PDT)
Received: from redhat.com (ppp-94-66-118-61.home.otenet.gr. [94.66.118.61])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fd45a0c8bsm10836910f8f.34.2026.07.31.17.16.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 17:16:51 -0700 (PDT)
Date: Fri, 31 Jul 2026 20:16:47 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Link Lin <linkl@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	virtualization@lists.linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, prasin@google.com,
	rientjes@google.com, duenwen@google.com, jasowang@redhat.com,
	xuanzhuo@linux.alibaba.com, Ammar Faizi <ammarfaizi2@openresty.com>,
	jiaqiyan@google.com, ahwilkins@google.com,
	Greg Thelen <gthelen@google.com>,
	Alexander Duyck <alexander.duyck@gmail.com>, jthoughton@google.com,
	stable@vger.kernel.org
Subject: Re: [PATCH v3] mm/page_reporting: use system_freezable_wq to fix UAF
 during suspend
Message-ID: <20260731201559-mutt-send-email-mst@kernel.org>
References: <20260721005603.1710551-1-linkl@google.com>
 <20260722173639.34d3f58413354218b24a5b0d@linux-foundation.org>
 <CALUx4KSfUUud86k4SLwETJAciRc8kZ9QocvBj39KmzXDiQ7J1g@mail.gmail.com>
 <20260723051327-mutt-send-email-mst@kernel.org>
 <CALUx4KRoCco0HA=Y_qFzSD=CegbJPUkQkvjRb1Y3UcgRdwQToA@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CALUx4KRoCco0HA=Y_qFzSD=CegbJPUkQkvjRb1Y3UcgRdwQToA@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Mic4rYGXGkFUey_JG3J89e2oRcc-7xRwLyLl9_X3KmI_1785543412
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 330FEA0003
X-Rspamd-Server: rspam01
X-Stat-Signature: gno6sgx18udiojw63gx4da875ynptrsh
X-HE-Tag: 1785543416-9615
X-HE-Meta: U2FsdGVkX1/w6wdLPZfw2Abrw6cie5HtDUbdFd3ai+4pr9jlW10ZQ39LTiPRsNWuFAKpYJf23LUoBUjtvw803HcTx3NsRfA7tCkJgDa36yb8l87umI/fdYWvsPpRItSALnIa8H3w76rBCZuX5IB5erehlUe8CHsSdkAxf/O3DbZnsVwjb0+30MoIPZr8UaiafxxLhbSnOzubO5uXguOPnpwo1pHfbVlcFXvK5hprQOXdpssX8tHocBn5/oQT+j9et95S+NDEEalp4yaGS6MlNDVoMfbVU7AK7dzFR/0kUn3uEk+ctZQgS/JJ8Swr5i71g9Ju/XMmRLl23eOgbzNfVDFYEw2T5SQJ2xpxAQMzOoGdXLho2m9SVomXdrSUwPZUUnYvu5HbZIoGsyxIgm+UXbgx1vNwD3lAK3Q1Jr9OQgQTOp9+NaQYyQK5qppHqYmovGuUyt/MTAALlRLNe/Ce/z1hqqBs1gMyiBrhTQT08Hs2+52wodbi2vXlFfu0RqClAUty3SQa/4CkuHfPk3TeXN/WcCbBcmfqOi0D/Cda8tzQtjHaeyTBGyr11sTsE3lcAn5B67XBZHuuN0SzZZhjpGl5GOnxZLEwpiSFPW9ETW5mDJAyl6F+8Uaf2w+aNNmw32kcvkfjOFRp6qmgzLECqqNrc0zuuz0uoaUmGld6x5IDTFZeq2LugMnzTtvElM0Ve8URzy2FP5HJojdNumOJffwATfMywQH2fcuJZCKjPGWaZI8dCzO+sH0DQEV3zQSBxukQ7u8HAN/HfmW0jpSOmTPQwDcrz58QqHB9JaaRBo7xpjtqkreaSJo0RUrHqSj3l7+Szl7uIGhqO+fuYfoe6GZy39QuTiOGN/fP6dfwi52vdT11U/tmqBrloz8eZYCGCfEWdBn9Bm5fKYBPUkYwYe0ix0d7TOVw06TXNPjwDNCR8YWvQhs6U5T7cujoEJdDa6lha2+zvSwAauD+Vk7
 i4T85fz8
 9fg9TiZT5EFX7byGR6krCKEtqWdIdQbdbGQu4KkkcvN3J57rw19eKgag+r55DUzNbFfHLLl+BbfZfdI0SfGGCOD69YupESlAWSWaLteNHtR2PaSmSBAiSNg/almzYq09ZbRVx6mi587Hfy0HMG9xbhB5TjuPrl3Q91WJm2DlnAFxhkL/2kCFE0hb2nXom3PXBdaabF9nofxjJ4CDoYqEHVgoZVRMOBwtCfxsorfa7npiBQ5DNUsPMWpReNYUwq8S2v0SGDQs08N10rnOftzv82UeX59GWaT3JRNhuNKyCVd5PZBIxgb4s5xDWcWcZ2de1ULIk2RGy/wdFd/zBrQ1GhE190iozFlPXup8mVsK6G1k68Sb10efofMWwWBba3y+JlXBqR/SJHL4eeBQoOrsEsKj2yfnBl3YHMk1BM1fqyCM7RS/nLZNUvvv2W0bccSrqZvdWNJZWBQh12L0gxckQHGLvxOUJ7VoM8UmIKKrcVl6tNlI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 31, 2026 at 01:21:40PM -0700, Link Lin wrote:
> On Thu, Jul 23, 2026 at 2:15 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > I suspect rest of work items we have, e.g. update_balloon_stats_work/update_balloon_size_work
> > all have issues around freeze/restore and error handling.
> >
> > --
> > MST
> >
> 
> Hi Michael,
> 
> We have indeed discovered a kernel crash in update_balloon_stats_work
> after the balloon driver failed to resume and initialize in our
> production fleet.
> 
> Alex Wilkins <ahwilkins@google.com> diagnosed, root caused, and
> reported this vulnerability.

I wouldn't call this a "vulnerability" just a garden variety bug.

> I am currently drafting and testing a
> 2-patch series to gracefully unregister callbacks and cancel work
> items on resume failure so that the VM continues running without the
> balloon driver instead of crashing with a kernel panic.
> 
> I wanted to follow up and let you know that we are actively working on
> this. I will send out the patches to the list as soon as they are
> sufficiently tested.
> 
> Best,
> Link


