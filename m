Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FC7BC43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 13:00:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 834C56B00B8; Mon,  6 Jul 2026 09:00:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E5CE6B00BC; Mon,  6 Jul 2026 09:00:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D5186B00BD; Mon,  6 Jul 2026 09:00:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4883F6B00B8
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 09:00:05 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B961D120232
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 13:00:04 +0000 (UTC)
X-FDA: 84958359528.13.464933F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 54C25C0004
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 13:00:02 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KRmcX5dr;
	spf=pass (imf22.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783342802;
	b=2jODHIfFuO2p3HBQnJJ0ZyX/M+FAi81rmC8fwnPwQpCSue1/QoZ9ho+XmOTuvvkYMOfiUQ
	afconz96vlKMwsVwkdh2UjnYFKgMAp1HQs8t2izFGM9uPFsk8q3jdw2jfHBKP3s7NQ0abb
	h5FBlAb/9MveLKJMm7lVm+xr75oFqh8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KRmcX5dr;
	spf=pass (imf22.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783342802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GV9yo9jBEBI28o7XznZuNHujDFZwTfJarP6O8dyD09o=;
	b=tdnQm1GmjWFWcGUoHOdxbBqaO0YJRdrUUGY+KSNhd6V1g1FWOZN+IJaVEUUqftw5MNnpja
	t55bnRnyeDpHSwiuTEMGDMWy7AaNykQwOp5mBVW4vz9CxdNJ6gQOYRDiwE4Vsgd2XEHa5w
	4TwCkHF1ekMnNXH3hjysNT2gujiY3jM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783342801;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GV9yo9jBEBI28o7XznZuNHujDFZwTfJarP6O8dyD09o=;
	b=KRmcX5drb3QrsIMsOUZ3+JwbPN1H5Suv5EgvuEltFq0DLWd3agG/R9jtkIM3FiT2yX2hK+
	0/J1QbluleKrlteihoo2bGJWA87kuIl58M8kFqP242GkFb1WLitjnVybiuTq7yHxtH6RlI
	9j3S06KwNPBRfEds42i/ztG8K6061gI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-14-lk07NaFFPpSSGn1XxpkVPg-1; Mon, 06 Jul 2026 09:00:00 -0400
X-MC-Unique: lk07NaFFPpSSGn1XxpkVPg-1
X-Mimecast-MFC-AGG-ID: lk07NaFFPpSSGn1XxpkVPg_1783342799
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4926596eebcso19514365e9.3
        for <linux-mm@kvack.org>; Mon, 06 Jul 2026 06:00:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783342799; x=1783947599;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GV9yo9jBEBI28o7XznZuNHujDFZwTfJarP6O8dyD09o=;
        b=I/UM5iZ5mx5V3B6ArftopQgPR85C/wW0czUwZW//WYwNItG5jrD/ZVhtyvB7rU1/3D
         Js97aqGAGdvV+QiKFgXFJadmdC1/tKI8R8uijrj2KNU9jDLs8YZLhL0yiPE2dMQHqvnH
         99Po5rHdo0Pm0vDyBiq1OXtg9UW5h4tW75t464kdEyZYAaymyrkmlUtdoY4L7dK0pVul
         e/5Tyb4/2HierDNLpZl37JzktFZ934X26BDyc52Te6YmxXgnlKFlzFDpmwEe1DQG3Xh5
         7SaCA1RV/Hy31Bc57l++xLHDB+vFgqboBmtk9pf7SNupqWLNA9WF6OVj+TI7MI4KFrZ5
         grdQ==
X-Forwarded-Encrypted: i=1; AHgh+Rp5i8tQ2BKI1ftPcT5hDg24byOPwUMgbR5smC/7HN9eJPdwAQczTyBD3rTFzknRWjN5T2wBcrLfFg==@kvack.org
X-Gm-Message-State: AOJu0Ywlqjkpys0Cm/q5R6Y7NwoObh1KBx72pFRHbeEKhPJzYX8sg71f
	ALCaJTLHW/kB6PSGXbSQqPSIqmWBKJhH2vWeEQQjgCSUGBiJINKfcLsTon9Z+fXLaqxEnlLGvi9
	a2GjFrEOp2RlniH6C0f1O1/WD6aeZYtxmIwuQNusXy+duu4RAXqjt
X-Gm-Gg: AfdE7cniu3qbnBiEYWPfJ1V1E+deyGnfmV683noLzj1xxl4yOb2wSo04ZzL7fJuF1c7
	P5P25+g7ANJr6UWEUY8uvh7ReL3k9630/VtzEEWtcku0Wx+1VuVi/uPq6US3L7M2gDtJ6SvkfwV
	eqKGRimcN+vDzRP5wyYIZlRGV1YU7OpX2pxJYmbpvRoksFCA0LilmEq7MA3i8X9VtqZ2ckXAvYD
	1zI6+WrjapdCYDn2KKVPaLVES+7t/uhg4NT+YItH9L+wPXJilPerWmdBJRIvN9o5Mt6dB8itrIF
	UgToc9UdnzOtfQXODC6rSR5KxRJuG56v6hu3mX21rbynjiFMH9X6B64EKizrWS0tyGAMdwfUC0G
	8SHiKNanzUfy6nUFX/p0sC8zMQkBctJvP
X-Received: by 2002:a05:600c:a00a:b0:492:7142:f46e with SMTP id 5b1f17b1804b1-493df038767mr4416495e9.2.1783342799075;
        Mon, 06 Jul 2026 05:59:59 -0700 (PDT)
X-Received: by 2002:a05:600c:a00a:b0:492:7142:f46e with SMTP id 5b1f17b1804b1-493df038767mr4416205e9.2.1783342798623;
        Mon, 06 Jul 2026 05:59:58 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-68-31.inter.net.il. [80.230.68.31])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493ccdabda3sm287154295e9.5.2026.07.06.05.59.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2026 05:59:57 -0700 (PDT)
Date: Mon, 6 Jul 2026 08:59:53 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Adam Litke <agl@us.ibm.com>, Rusty Russell <rusty@rustcorp.com.au>,
	virtualization@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: Re: [PATCH v2] virtio_balloon: prime stats vq after
 virtio_device_ready()
Message-ID: <20260706070936-mutt-send-email-mst@kernel.org>
References: <2f0d0de033f3005d3b985883be3e5cf37b3f6c42.1783278596.git.mst@redhat.com>
 <13794c5e-375a-4fc5-84b4-a637d077f8a0@kernel.org>
 <20260706042207-mutt-send-email-mst@kernel.org>
 <6b8e4ad3-6909-4d0a-89a4-104a5ad9fe79@kernel.org>
 <20260706044122-mutt-send-email-mst@kernel.org>
 <24336f56-1024-4c9b-8653-b1a4658b627c@kernel.org>
MIME-Version: 1.0
In-Reply-To: <24336f56-1024-4c9b-8653-b1a4658b627c@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: dtagJUDG43qWMlT-8FoEsTDGEwcE62-ki69DsLBHVCw_1783342799
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 54C25C0004
X-Stat-Signature: 6ztjyjm6gxrxos5nbx5hp7rgbmcngrf6
X-HE-Tag: 1783342802-293167
X-HE-Meta: U2FsdGVkX1+ulHWzo5cpiTYbmEAHaI8xZqG0VtA2S7k/nmuzhNzGDzVF9KzSjaqu4onY1f48RwIKk1aDTbkTo/nbFObwrfxagn92cx38v2cTXKi+YN7KrjQzXlUa1+215YwNYXFQf6/p5EFI0Rz9uLLdb4vCNK1+ROfhQgg8K2Of4pqnfg5oQNpe+XawBhMlZbgAJYyEwfxNNdD61cynRasrabUb0mzGItYneABmAI9aQWT1X38+AiDe9NRsjIr8jGL5zAu253AHcw0UqLxTc3X7Aa8Tyy5cUu0C4vlwlP2zCoZdosxkLUGhSSCv16Q9A8uFspLle/3KgygMlv7H7a2xekGPonyJdCuUOYW0zKSfjqj8JjPCi7jB8GHx5lXkk+0k7yBWdTt6fa1hrbe+OcHmts+PrgcLtwMx4xY0HTzi2CMocXvBNN36VYhqLwT6Uy4O+QtDhhhLr2mmNv4duEA6VqzTALUw71O1dZKMNM9EoOJpWqOZHbWfLTRndZLUEgx1v5UoZkCIwGzbC/mSqBNoQNGtB7rKNc95tx+Fot3GMndjL8Cim369KXbUA7CSLcK/y9SV8jLfsBbRNV/foLSOPr25VdKgOWVTp65XIK4TJyxRoC/w+J80RX/sbuTht2oasPttBY7tWFYI+lJtaXFf9EGV/8L5UAz/dj67UkvIGuTnk6N7HgozJAmHKr7bf4XcWeL5/cGOMFJqR+s2QWicGoHv4HNjhmiBgCmrBrk+q76hyfl5NvoBzUqGKiNMLyZNIZJm/KigNbtIZ2rWl0oaANrdpMdO2eGHkcpNsKdG6C6JBoFn8jdHvWVSDNuZ3PsXvkU/6soDwfi9doA3TJx/9P3gKITM7Mf3oXynYP3Z0VxrRzV3kCExvAkhDounbbGUw/JohdZ+sJcXXD3Q2sP7tyTsMYoU8f28ZdUHBTymVErpUn3WA+PcAENNf8ruGRfPkVmDGLQhouM3zii
 Hd6lcTgD
 wV2LyZtzw38HAU97Jop94lan3jBXXo8TfPHMvtrRZkPl1V15Dm5wpJZAOG4XTlSvSduxg7Jf1HIJcxLseWAb0IQUtwkpopdsbPmrcZKjSqXrJCTEykqesX0JwxRdlBOkN/gLaVDLYNLKay1awMRzJEAo3C6aTnCj2rr84L3gOjR6ZkcDnXkhpXB2S5XTLcH86ePPagKF4v6MCdC/L5Bp9Ttq4XnzZj/W5U2btr3M/jCi8twobNSnQtaKpcd2nFX34zcL8N+aGhzRCNuC8emMXZeJWFebjEfj3Sd/gIL0kqFLnaKbJw52IE2VT948Q0hP3Fw8hZ0vgde8s9DPUxTbeo1DeTJQ/bhYSFqHzOGcdN/QozXLcfHJKjHxN1ghCVZVMHF0T
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 06, 2026 at 10:57:33AM +0200, David Hildenbrand (Arm) wrote:
> On 7/6/26 10:43, Michael S. Tsirkin wrote:
> > On Mon, Jul 06, 2026 at 10:38:18AM +0200, David Hildenbrand (Arm) wrote:
> >>>
> >>> Yes.
> >>>
> >>>
> >>> Why not?
> >>
> >> I was wondering whether the spec would state something about that.
> > 
> > Sorry I do not get the question. Virtio API expects
> > callers to serialize calls for each VQ. So this just prevents the work
> > from running and accessing the VQ while probe calls add_buf/kick.
> > I'll add a comment explaining that.
> > But it has nothing to do with the spec.
> 
> The device is clearly not properly initialized yet.
> 
> Yet, we expect that we get a stats_request() callback that would try to
> queue_work(). And IIUC, the stats_request() will be directly issued by the device.

With an in-spec device, it can happen right after virtio_device_ready.
We could defer it a bit, but I don't see what this gets us, and
this also protects against any out of spec ones.


> In QEMU, that would mean that balloon_stats_poll_cb() runs, which would do a
> 
> if (s->stats_vq_elem == NULL) {
> 	...
> 	return
> }
> 
> virtqueue_push(s->svq, s->stats_vq_elem, 0);
> virtio_notify(vdev, s->svq);
> 
> 
> That's why I'm confused :)

First the spec says there could be interrupts for no reasons right after
DRIVER_OK. Second there are situations in which qemu might
consume a buffer without a kick and then an interrupt
races with the kick.

> -- 
> Cheers,
> 
> David


