Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA6E5CCFA02
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 19:30:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 008298E00CF; Fri, 31 Oct 2025 15:30:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F22598E0068; Fri, 31 Oct 2025 15:30:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5F198E00CF; Fri, 31 Oct 2025 15:30:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D50418E0068
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 15:30:21 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 804431A0549
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 19:30:21 +0000 (UTC)
X-FDA: 84059400642.18.4FE53F4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id E70E6140011
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 19:30:19 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Ngld96Mp;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf26.hostedemail.com: domain of mpatocka@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpatocka@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761939020; a=rsa-sha256;
	cv=none;
	b=gWBlVLXR0F6wBqO1rH6ZSej+2AAA7MDrXvUJUspxWxGQvAFe4PKAXMxl9j/4pJHyEgbTx7
	ioSUoJjd54UDjWNlLmSJ1puLDfa76Nq1b0OZL2+LfAeyHBMCKPpHeh3EDlGS7LWiqicbEi
	/2q5Ckuy5z/Je0OHD8RVslUPBXn+XUw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Ngld96Mp;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf26.hostedemail.com: domain of mpatocka@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpatocka@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761939020;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SWgRT7WaYDoMlN1l4H+rmuJdT1C5jyRgb7Xd7l2YF2w=;
	b=U7+36itYMPc1xT6ulC7O+KKmFtut/Gz/EvywGYMjnqNXaEmp+1JEsmJBEjXV/8OmaSFn5R
	GZoKUY5fZyFaulN+q4SZMJzpiE+r7iqVPonKgOLLR7ewSk/lfwmggmVTj/xfnCYZMGCxIo
	cah6VQJp8aLEpMSVHD/sLMIbUPPO9+E=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761939019;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SWgRT7WaYDoMlN1l4H+rmuJdT1C5jyRgb7Xd7l2YF2w=;
	b=Ngld96MpnUlCi+eolgTD+m2LU2D2nZkF/zcszh1k0UqWvDyskkKqv10CodhHd2QG7ih742
	neVr6GBgMvVQnn7moomdZyITgdJ+kIsFH4fjWe1Z8DZUOMsgNs6cwxWQhisRv1hun/gn5T
	+iU8Ur3D1We3Hp/r8o1kSvUbjJl/gR4=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-668-lZ1S-KggMVeFoVz9gzeAxQ-1; Fri,
 31 Oct 2025 15:30:15 -0400
X-MC-Unique: lZ1S-KggMVeFoVz9gzeAxQ-1
X-Mimecast-MFC-AGG-ID: lZ1S-KggMVeFoVz9gzeAxQ_1761939012
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 747B21954B00;
	Fri, 31 Oct 2025 19:30:11 +0000 (UTC)
Received: from [10.45.225.163] (unknown [10.45.225.163])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2B2C118004D4;
	Fri, 31 Oct 2025 19:30:03 +0000 (UTC)
Date: Fri, 31 Oct 2025 20:29:58 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Askar Safin <safinaskar@gmail.com>
cc: Dell.Client.Kernel@dell.com, brauner@kernel.org, dm-devel@lists.linux.dev, 
    ebiggers@kernel.org, kix@kix.es, linux-block@vger.kernel.org, 
    linux-btrfs@vger.kernel.org, linux-crypto@vger.kernel.org, 
    linux-lvm@lists.linux.dev, linux-mm@kvack.org, linux-pm@vger.kernel.org, 
    linux-raid@vger.kernel.org, lvm-devel@lists.linux.dev, agk@redhat.com, 
    msnitzer@redhat.com, milan@mazyland.cz, mzxreary@0pointer.de, 
    nphamcs@gmail.com, pavel@ucw.cz, rafael@kernel.org, ryncsn@gmail.com, 
    torvalds@linux-foundation.org
Subject: Re: [PATCH] pm-hibernate: flush block device cache when
 hibernating
In-Reply-To: <20251027084220.2064289-1-safinaskar@gmail.com>
Message-ID: <de1f0036-84f9-2923-2c0a-620e702d850b@redhat.com>
References: <03e58462-5045-e12f-9af6-be2aaf19f32c@redhat.com> <20251027084220.2064289-1-safinaskar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E70E6140011
X-Stat-Signature: fnc35ksjmf13c7pnrkr61p4ipw6j7pry
X-HE-Tag: 1761939019-651440
X-HE-Meta: U2FsdGVkX1/O6VzvB8oJGLM/go89zhY/87GVRRW/6AWAOMQhu1SqSe6hP6u7jBSsNb3FfOY9D9Lb/uMcxlQwoku+MZQ7l4PDZIUl7pwh4qau00SzcbXojPPkJhsfRW0KELRsqvqla3aQRtbNvF26ToPMl3lITJJefBRXL7fTkcA5Fos3pbeLqIa224ofpL5fiH+YiM58puqp68+57rEOOJc7daJa7Cth4e885x9yufqpmCwPOK8Hchz27lF6XRZTfqhOcO99Vi/FgrKm6fuk3sz0JgSHsZukAyZ27OCRk7okPB0gwvpvWhVhwU3b7itYcQ8eESr1gRj7BDKb7OImUfUMwIvtp9XnSH2i0KBza7rrdptgXXOpNjy//mII8x9h4GbljfhysQ23k3SorcuQYOupxPY4TzmQD4MxsAXmgXhhgz48SrXOjGqidphXh7LDZ0eX+H9RjUV4p2MaLBFMxpqY4j1lJirKw1ZbNZJ59avNHPdpwSTnHhY1tAtarT2Eq+cRTRM66nZC135v/vaeDm0WcAeD0PGWp/Ksf98Y2d7LsX09t/+Wy161IulWaZzAFaIp7kZXJlDSFnChijDdqJvQqkCWSNdNCHEYjVymCeKClpVvltHH5AwOWyIgOsSbY7olX6jROMziQj0gGLqfffY8EsId/zQTPVSVZ7aRt0OvsGki4JnX8+EyvN72Y1BkEcpLMhSKvA28eMWizbGAWoovdzLiLHz7MqsgSIIjklTflIHFFLBBJ5Emn2I2VCtA2OPTjONdySkG1MRRVpIhNP49YJJZRjmG2n8M7tzUlPxPm9kY+EMHmTTC64p4G/1ZYUygxtyzP3qP7sKUASVx3uyn9D7JnFCLiF5Odp/DWRZ3C+LUcTmkiTyd4X2daykOwE0/0m4/vlcO5VSlvam9XQS9YjGrEAFzDh8V3DvdsJ+XuME5b3GKn3n+g/58XpUL8huBgpd3WPg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On Mon, 27 Oct 2025, Askar Safin wrote:

> Mikulas Patocka <mpatocka@redhat.com>:
> > Hi
> > 
> > Does this patch fix it?
> > 
> > Mikulas
> > 
> > 
> > From: Mikulas Patocka <mpatocka@redhat.com>
> > 
> > There was reported failure that hibernation doesn't work with 
> > dm-integrity. The reason for the failure is that the hibernation code 
> > doesn't issue the FLUSH bio - the data still sits in the dm-integrity 
> > cache and they are lost when poweroff happens.
> 
> I tested this patch in Qemu on current master (43e9ad0c55a3). Also I
> applied Mario's patch
> https://lore.kernel.org/linux-pm/20251026033115.436448-1-superm1@kernel.org/ .
> It is needed, otherwise you get WARNING when you try to hibernate.
> 
> The patch doesn't work.

Yes, I see - the problem is harder than I thought.

I've created two patches and I tested them that they work. So, you can try 
them.

Mikulas


