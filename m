Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9A46CCF9F0
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 16:33:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F244F8E00AD; Wed, 29 Oct 2025 12:31:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAE4B8E0042; Wed, 29 Oct 2025 12:31:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D75EB8E00AD; Wed, 29 Oct 2025 12:31:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C3CAC8E0042
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 12:31:39 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8176ABBDE3
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 16:31:39 +0000 (UTC)
X-FDA: 84051692718.07.B6B75C1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8CE1540006
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 16:31:37 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SyCwToen;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf01.hostedemail.com: domain of mpatocka@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpatocka@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761755497; a=rsa-sha256;
	cv=none;
	b=LfvZ0hJ/2/GMf5K4qFpcPqr83IbSoZxNR121OBs3lNihI6d3ZBVBfrXOh46h+KoB6cCu/q
	M57P5hn0CGGvGv4rvDvnYKSYsZz0L7ncNs51HkFjA09I1WJJQfBi5W82mGSUpU2o4jy8ar
	ZyeBBzbfALDrOrvEHxU8owQCS8ts7yE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SyCwToen;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf01.hostedemail.com: domain of mpatocka@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpatocka@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761755497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1T52Vj5IIAdBYMNDfCC4go6XkTYm9qfscMzwG6wwCuU=;
	b=2FLTdma7JRK2Gwy/wVCuGaT5iqgNljGK746foG53N//Osm738fwIgnG9EfxSJor3zRLKA8
	3Xd0t1sE4o8kXkNTDcy3i7wZQWTJ96ELgPXtIcFBFSOx2oXjyOr3wJtLOXylC+1OxlOF50
	8b/4J93mR+mMaOS+bTN8Il3ttRlvrJU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761755496;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1T52Vj5IIAdBYMNDfCC4go6XkTYm9qfscMzwG6wwCuU=;
	b=SyCwToenKZAhO6ww1+x7+NxkfC8i8BkjKmkM5Z4cMhRbN0FIPtNEJsB6e0D7vVb3z8m3g4
	GeuF0/B7f282ikZ1jCjW3+Jcn29XF4+8ih1N5MHgWdBMjZkVqSz1ZMQSNs6KyvfwRBxE0A
	iPF3L8+JYSgrfXs4XRGADpR7B7YoUHE=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-433-VrIc2NguM8WEFqbFBmCdqQ-1; Wed,
 29 Oct 2025 12:31:32 -0400
X-MC-Unique: VrIc2NguM8WEFqbFBmCdqQ-1
X-Mimecast-MFC-AGG-ID: VrIc2NguM8WEFqbFBmCdqQ_1761755489
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 18891196F74D;
	Wed, 29 Oct 2025 16:31:28 +0000 (UTC)
Received: from [10.45.225.163] (unknown [10.45.225.163])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F0BFB19560AD;
	Wed, 29 Oct 2025 16:31:20 +0000 (UTC)
Date: Wed, 29 Oct 2025 17:31:13 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
cc: "Rafael J. Wysocki" <rafael@kernel.org>, 
    Askar Safin <safinaskar@gmail.com>, linux-mm@kvack.org, 
    linux-pm@vger.kernel.org, linux-block@vger.kernel.org, 
    linux-crypto@vger.kernel.org, linux-lvm@lists.linux.dev, 
    lvm-devel@lists.linux.dev, linux-raid@vger.kernel.org, 
    DellClientKernel <Dell.Client.Kernel@dell.com>, dm-devel@lists.linux.dev, 
    linux-btrfs@vger.kernel.org, Nhat Pham <nphamcs@gmail.com>, 
    Kairui Song <ryncsn@gmail.com>, Pavel Machek <pavel@ucw.cz>, 
    =?ISO-8859-15?Q?Rodolfo_Garc=EDa_Pe=F1as?= <kix@kix.es>, 
    Eric Biggers <ebiggers@kernel.org>, 
    Lennart Poettering <mzxreary@0pointer.de>, 
    Christian Brauner <brauner@kernel.org>, 
    Linus Torvalds <torvalds@linux-foundation.org>, 
    Milan Broz <milan@mazyland.cz>
Subject: Re: [PATCH] pm-hibernate: flush block device cache when
 hibernating
In-Reply-To: <aQIm1bfwKlwaak52@infradead.org>
Message-ID: <355486cd-6c52-df82-7636-a8259995b522@redhat.com>
References: <20251023112920.133897-1-safinaskar@gmail.com> <4cd2d217-f97d-4923-b852-4f8746456704@mazyland.cz> <03e58462-5045-e12f-9af6-be2aaf19f32c@redhat.com> <CAJZ5v0gcEjZPVtKrysS=ek7kHpH3afinwY-apKm3Yd4PmKDHdA@mail.gmail.com>
 <aQIm1bfwKlwaak52@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8CE1540006
X-Stat-Signature: u1bjyjgwoubc91tmjfn17ncjmku1dm78
X-HE-Tag: 1761755497-339213
X-HE-Meta: U2FsdGVkX19Pubx+YlMF1K1DEEVSLglH8Q9Bt6DFMmAWeau8HqyLsV+kCBoSxMT9tY/8CF58y1fU0dsjI/sltp/Yj8n4/+IEPNTvusjmMOU6iqzwJ1Oq+D+dux+30OXd2Tc0LMv3IyA7U174sqD8x7t51Ud0LBJaj1nGdOJVZidYMIDtu5vDreNz5Dow4D5lKTf81VdCCh0LGyYsVSmPEvSb+dEE1I+dZbepk9DpVoq3KN5zCeIiwJWUVczhTTOBAoB31kARUJ0guN7au/4YvmW7icTnMZpsWnPnrPtpEM4Kmjf3chE1mcqxEMFdqEchHY5FyCPtIsrgGZIPZr9TJJZqm5CP3+mDKZ0iLByCkv9L0MGg7+VN8FUyageOLH6GDVqcBAzzClxDxRFDich9KAtGPLL5RyXJ8AlkivS1bh45GB7uIMc3TRtO8dvsQK5vMSXHaN3V6hQXZN95kr5d0LYS5sj5LLTp+4tR7EPrkKIeLafb+h5T0qwqTp69mSbm3s3sjFLJF5uK5PtY8kmIuKzucgzZ0S6cZ3Xym8SUh14OdTEUDKfDLrO9B/UnAMP8UcLFOu8DQi+O+paAnU5GPuFh710gEODrlTFP1ivgHgxQ5QhogrTY5biRj/AZF7yT6EmA58yFQr0BlJWeHRprRgrDv28p58omKDvzsf5uQ4M9SV6AC1PrPpFY83Uw1Om/Ikz1KqFlkBv4WpV9v4OQCMXqEzGBlzNbQaLYuNoVRw1SJ3EElgZ7y572Prfdtke0DGhPyXidiT8mJ6e8OPIQEbT/uD31R967Xmk2OfvPJIzekePI1hLY/z69CnR1ZQFvYj/1Z/fW7IQWuvG8rT8W4NWB1ftBuZ0rcu3XEkxYcL705FSPjCxhzzvni8DTY8ehJilCnWpEIZb0QvlbyEFX1l+ZKjLTpcjwNgwymf+jFDTQgMe8CjYSpLJQ1VaSijZgPjBCv6tZSNdU9ojrV1N
 v/UQ8sk5
 sMZNUE+evoQq87T1D97u6beyYNKNFB5iUiO0PMTucd1wI7KItA/tJ57wwFVgiGRi5nUOHiW2lCC93vOD4HbsauKJ1LqoNScBdDq6EghXkHcE0Xru+5ANfJB5dv2ZBaZtqguozhR6cMKK6uliEgHUbES+kU1PL+p+VxXWTk6LguO06IXqHOS/ZPLGaTcKjsS7l3Nq2+N+VAekI42cPhqmReLXgt0LTpI1RNijyJGMqZG+JOQicj+Fja2Pc3C5ulNJobcmfYZNx+kP4unCZdxNyNo1W2ivv0Ksf1vyH75iE6E+g1/3tbotkEEP67tFD8NrN13xujOO8+bwHCI7k1T2uaicMZg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On Wed, 29 Oct 2025, Christoph Hellwig wrote:

> On Wed, Oct 29, 2025 at 02:31:05PM +0100, Rafael J. Wysocki wrote:
> > > This commit fixes the suspend code so that it issues flushes before
> > > writing the header and after writing the header.
> > 
> > Hmm, shouldn't it flush every time it does a sync write, and not just
> > in these two cases?
> 
> It certainly should not use the PREFLUSH flag that flushes before
> writing, as the cache will be dirty again after that.
> 
> I'd expect a single blkdev_issue_flush after all writing is done,
> under the assumption that the swsusp swap writing doesn't have
> transaction integrity for individual writes anyway.

I think that we should use two flushes - one before writing the header and 
the other after writing the header. Otherwise, it could be possible that 
the header is written and some of the data is not written, if the system 
loses power during hibernation.

Mikulas


