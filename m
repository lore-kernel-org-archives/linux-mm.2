Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D136C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 13:24:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40DB06B0095; Tue, 14 Jul 2026 09:24:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BE716B00A3; Tue, 14 Jul 2026 09:24:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2866C6B00A5; Tue, 14 Jul 2026 09:24:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E2E906B0095
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 09:24:38 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 730D6C037C
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 13:24:38 +0000 (UTC)
X-FDA: 84987451836.25.9BCD336
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0E8B440006
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 13:24:35 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WCY38rmv;
	spf=pass (imf12.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784035476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8CpLHRy6/20YstfcDyrkyOratDSzuro/7QBC+7w5m58=;
	b=5KYOwW25ti2KJbZmjH11kH45vaLTsQQ/+BMNiLM8LUKW/O+7yZJDCQg5Wb28/gx1YrIoFh
	E8NDYBa8w3GrhviUg8mLfSp7O+A4y7E+NUTP2PIw9J4wenS9ryE4xHJi6fehkq/tzni004
	iAtkbizrGe61Tb0DhORcOk1xRqBEbgY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WCY38rmv;
	spf=pass (imf12.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784035476;
	b=aBuxed8WsJHx7m7AavUHiMizFCdU/POqKdShCvl5CA2GoXtHhf77vIfkBMYACa9vILyReX
	/U820coBDixfp+9oHG58RJeXv+ZKAvP0YbQ44VhHwUPGrSTHEsUdvcu/DxHwTa6T0SiFFX
	qHlKJNACikraUppNLKN1uz98v5zgeQ4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784035475;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8CpLHRy6/20YstfcDyrkyOratDSzuro/7QBC+7w5m58=;
	b=WCY38rmviGa2bbBEX5YlQWLXF2Fl9FLA5/DapYBxPGvwKdGg6UJaY7lfns7Acj1/icljnU
	7o3Tk1hesyal+0FnKZ6N/zMec4BiTXuRS2HGf5Xx2jcPxNnSXCfY25dFo0zg6PKvyRVzIt
	zUk0A8+320F31s2maTr95haWDsVexpQ=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-479-Pn67FedCMoyYdnFmg5F9FA-1; Tue, 14 Jul 2026 09:24:34 -0400
X-MC-Unique: Pn67FedCMoyYdnFmg5F9FA-1
X-Mimecast-MFC-AGG-ID: Pn67FedCMoyYdnFmg5F9FA_1784035473
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-49244130073so45155235e9.1
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 06:24:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784035473; x=1784640273;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8CpLHRy6/20YstfcDyrkyOratDSzuro/7QBC+7w5m58=;
        b=roD4ASEwRT26uoCuuoGdjx+grrh1ylCYUORCisChjr1CvNM6ZJbrVohrKcvKPFU5YO
         j58kubFkO1rtcDyWbAVT3pBGxYyMUACzvz+9VbbJcECIDQMyN5eZ9pB0UOAb1QU0re6r
         e6Sfq7ckGi9bl5iYtCg9JhAHBS43e0VuJIvUk0yZnDFL7uui0X4L0mE6XvIM+ynD84oX
         2UA6mcoNaC3knq2PgJy484r2SPzGG0U+bpwXCuifltj6Yxu9VUv7KIXjofUgL2CPbqqV
         O89BE6Cv+NrIk6ym8aexVEUbLIDCKB+Q9hy8sWacRbvRzPtJ08vsxElEAnLRwZ3Zf9hr
         9akw==
X-Forwarded-Encrypted: i=1; AHgh+Rqiv3EJTUTeWquqVW1+cJR0Z5UX7U/ejsApFotxL6JPF0+e7jIsmv4SbLNhDz0TwC7LBQuNeqa0aA==@kvack.org
X-Gm-Message-State: AOJu0YxlUlyJxJh1i6csvKGC6DddxYYcVmB7F9AMCkVjaFGJq53UgQCO
	mPZkoH3o4chn+/vlxyELYc2HzHfGTNmLol7TvZJ82moBjthSyWTZ/cZ3xKgB03Za6aaFzZaFcpd
	0SkVcagbEKNohHbB4Mgk0tAHp9uCWLRa7/h88uS8cdDw0xTXpdvvo
X-Gm-Gg: AfdE7ck5yst39PI72nTTrXPECISAfONsAjfbi2WpwS0yA2tgBy40wRSMMZrYXyRiYZC
	ybRxRIzJa5Y2MEACPXV5IfpXlWP21i52ofXa9KcPz3j9c8veZZu/tbB5a9TZpT2s3JMjZ+tWcBZ
	l7WUV2N87HR0nX7g34os3ZTRxT4Pc7Ky98sCmRbUTEQ3N26h0DdQx9TlqpZveOeHx3JGEiLsyK4
	x/pEyob12y1Ii7AuxLv6MSTAAqGgP4w98ekPCo8oYmUfAs5/NrHLMmKlWes4RfHJtYWKzYsWBam
	29c9eOa9UijTvGBotIz6UlkFAl3lBMNBa7NgPLU+myRvuxO1O2OMKvnm20AXBAK+JARjed0Efkm
	g2ZJHVb6fUWlVQkYLSkgFB8JslyubNszEuP0=
X-Received: by 2002:a05:600c:699a:b0:493:bcba:46a4 with SMTP id 5b1f17b1804b1-495389bcc5bmr25895025e9.20.1784035472836;
        Tue, 14 Jul 2026 06:24:32 -0700 (PDT)
X-Received: by 2002:a05:600c:699a:b0:493:bcba:46a4 with SMTP id 5b1f17b1804b1-495389bcc5bmr25894565e9.20.1784035472269;
        Tue, 14 Jul 2026 06:24:32 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-24-117.inter.net.il. [80.230.24.117])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4950a32b9f3sm86514755e9.13.2026.07.14.06.24.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 06:24:31 -0700 (PDT)
Date: Tue, 14 Jul 2026 09:24:28 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Link Lin <linkl@google.com>, Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>, virtualization@lists.linux.dev,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, prasin@google.com,
	rientjes@google.com, duenwen@google.com, jasowang@redhat.com,
	xuanzhuo@linux.alibaba.com, Ammar Faizi <ammarfaizi2@openresty.com>,
	jiaqiyan@google.com, ahwilkins@google.com,
	Greg Thelen <gthelen@google.com>,
	Alexander Duyck <alexander.duyck@gmail.com>, stable@vger.kernel.org
Subject: Re: [RFC] virtio_balloon: fix Use-After-Free in page reporting
 during PM freeze
Message-ID: <20260714092146-mutt-send-email-mst@kernel.org>
References: <20260709224330.946683-1-linkl@google.com>
 <8d316b6c-41fb-4ae3-8923-3b649b92b33d@kernel.org>
MIME-Version: 1.0
In-Reply-To: <8d316b6c-41fb-4ae3-8923-3b649b92b33d@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 7BxtQwqg5EYWukNTWPGi0Se574XuRif4-R-LbyA9q7k_1784035473
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: qftd41zoqy81xm9rryakycg1n54f6dnd
X-Rspamd-Queue-Id: 0E8B440006
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784035475-651016
X-HE-Meta: U2FsdGVkX1/DcZ0qXYLFkSgQigyqHcOViMu79ffOSM5ri0xc2yXsoehN/fEGhOgiZfhIJQltAEGu5MSfjK0OXbtNmd+u+ipq8ybyIg/4emVVtNy1bio5S6qrcXGHntZ68PR7NsniOtPrg89lRzIJmXCMYlrkf9OLF+D/jBcbqqiykOy3VWBWTbFLW7EgIpAtMkNDDAMTi4Ct2CpqPfrpiHPRbuMF0s/O5+SXSIpg2YupSPTMRlnbWhwUGcXtRk4FNXUiXqRr3wfW0777j2eTR+krrajCB1J/ij13WuekI5spR0XHJyAvg9UG64oSzULCiRkjHOYRDmeNPhWqrNAEU/v4rZc5cUuWITlP1VyZDJ7i2gn/SprK6W/Eyr5j6rLJ0nyjQSQHKXjgb66I0T0UVFcxbvbE2EVNzYwH991957O56YRDDJUVYg+bQsJDpI4cgJF+qBirxRagkc4q0rJlJKnIELDalgeJfSaSDGpvaJ5iaCI35rN9HV98I+h1kkOBZYr/sXEMoaAoztKUlSdcEHHMVjLciF7cshZpdKzhjCSBkuLqoxQoDr7paSW7vJxBje9A4OpZlw33R75K6uHV/3Y8/Gp7ZvSVZQyFedPhiW1BLDjtHzMsh2BUf4vICmIiqoTNmV6PTrOWljcLMwT4dwSCTe4vohMxUMSV23Nmdb+inhlWWCv62aw+NjcnvsafyfWYEtF+HpKYfBPmibzhdPJGGrj6w8q6hmRYI1yFtM7BD1L1axx/KDq6880J+BAQt5C0Vj6zB+L9yPuXS1FuHnMcw5VKWF4wvMLC6nNXPb8wpPdBbhIcOLt0bxXae4p1JhmvN52NImlRkTX3dRmGHWNOkDmq9CBpd5mLoi/mHF7bjLo2441YSCBOTEl9jcmT7ZZyaWYn1KhSbyd6EalWZh9V6efZIds6gf4M90DVHiBxta/o9wrCox4xm1CFb2qXJ0mQXyzAXtBg8T5dBTH
 u8g4+Fjk
 OgK7roL1D8wpT1z2qVXzn6WKLBqLYBFLkZHH8A+nje0o9UqkoMHdq1s8R9IkA6/ucB4PaPZ3ohdlpkZvjRNY1pQu9S9hHKopiUwx4SB6cpt6jy2fIniQ38P3QBgmv7HqlMq8CVQdaoA6yJuzrrtN4rc5w9EJVUz4UU8XilL6LanqFGMz7c4LREmUeXvFrfOjiHAhnv3yqXIkSswUOtGS8OyLXpRxkvR8rbMadsVxOdWEGFDhZDtEdrP4CvMs+8KHv/zUQV+uADhWG2sC89cf6TRKT0MFmr6v3u/p93aeme8qYCM/bthr6veeL1/QGfQNtKjvT2Ots9dUy9lKFMjZaswzrjOtyCEOGRWJyqTXqqSV5I7g+xEhx9BsbWjABqdM1IdKMb6uSb26/7OI4+makCZPLh5t0cRtnPtYBIkzufGH+g66/QlTIFILM6lWaINtJmRb7EdPiXfZXLr0bUwYVoYk0Osu+v9j1Xi0fjwa7uFujcDPUgS7e0AcLMi8/KPZ5SB9GmmsLyfC6EHgP0tt1WbLxO4b3xDnLlPGQdaDWREiZ9uxICasSTBDYQDVq4xPl7JfEhuFwU9QrR3p2HAhidF+N4ps2rsfB/r1dx4enY4tQiPZVsGX+PJvt5w3eigpYo60f
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 14, 2026 at 03:17:42PM +0200, David Hildenbrand (Arm) wrote:
> On 7/10/26 00:43, Link Lin wrote:
> > During system power management freeze (e.g. ACPI S3 suspend or S4
> > hibernation), virtballoon_freeze() calls remove_common() to reset the
> > virtio device and delete all virtqueues via vdev->config->del_vqs().
> > However, unlike virtballoon_remove(), virtballoon_freeze() fails to call
> > page_reporting_unregister(&vb->pr_dev_info).
> > 
> > The comment in virtballoon_freeze() states:
> >     /*
> >      * The workqueue is already frozen by the PM core before this
> >      * function is called.
> >      */
> > 
> > While this comment was accurate in 2011 for balloon-internal workqueues
> > (such as balloon_wq, which was created with WQ_FREEZABLE and is paused
> > by the PM freezer), it is invalid for Free Page Reporting.
> > 
> > Free Page Reporting (mm/page_reporting.c) schedules its delayed work
> > (prdev->work) on the global system_wq. Because system_wq lacks the
> > WQ_FREEZABLE flag, the PM freezer (freeze_workqueues_busy()) explicitly
> > skips it. Consequently, page_reporting_process() on system_wq remains
> > active and unfrozen throughout device suspend.
> > 
> > If memory is freed into the buddy allocator or a delayed work timer
> > expires while the device is being frozen, page_reporting_process() fires
> > on system_wq and calls virtballoon_free_page_report(). This function
> > passes vb->reporting_vq into virtqueue_add_inbuf() / virtqueue_add_split().
> > Because the virtqueues were already destroyed by del_vqs(), this results
> > in a Use-After-Free / General Protection Fault:
> > 
> >     [  250.709271] general protection fault, probably for non-canonical address 0x7f728084daf08d5e: 0000 [#1] SMP PTI
> >     [  250.732967] CPU: 2 PID: 38 Comm: kworker/2:1 Not tainted 5.10.0-44-cloud-amd64 #1 Debian 5.10.257-1
> >     [  250.751575] Workqueue: events page_reporting_process
> >     [  250.756665] RIP: 0010:virtqueue_add_split+0x233/0x4c0 [virtio_ring]
> >     ...
> >     [  250.867678] virtballoon_free_page_report+0x3a/0xe0 [virtio_balloon]
> >     [  250.883446] page_reporting_process+0x225/0x4f0
> > 
> > (Note: The OOM Notifier and Shrinker/Free Page Hinting features suffer
> > from an identical lifecycle flaw and are also vulnerable to UAFs during
> > S4 hibernation when memory pressure spikes. This patch focuses on Free
> > Page Reporting, which runs periodically, to ensure clean backports to
> > stable kernels).
> > 
> > Fix this by:
> > 1. Unregistering page reporting in virtballoon_freeze() prior to calling
> >    remove_common(). This clears the RCU pr_dev_info pointer and flushes/
> >    cancels prdev->work on system_wq via cancel_delayed_work_sync().
> > 2. Re-registering page reporting in virtballoon_restore() after the
> >    virtqueues are re-initialized and virtio_device_ready() has been called.
> > 3. Unwinding virtqueue initialization via remove_common() in 
> >    virtballoon_restore() if page_reporting_register() fails.
> > 
> > Fixes: 924a663f75e2 ("virtio-balloon: Reporting free page reservations")
> > Cc: stable@vger.kernel.org
> > Cc: jasowang@redhat.com
> > Cc: xuanzhuo@linux.alibaba.com
> > Cc: Ammar Faizi <ammarfaizi2@openresty.com>
> > Cc: jiaqiyan@google.com
> > Cc: ahwilkins@google.com
> > Cc: Greg Thelen <gthelen@google.com>
> > Cc: Alexander Duyck <alexander.duyck@gmail.com>
> > Signed-off-by: Link Lin <linkl@google.com>
> > ---
> >  drivers/virtio/virtio_balloon.c | 11 +++++++++++
> >  1 file changed, 11 insertions(+)
> > 
> > diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
> > index a1b2c3d4e5f6..45a90fb3abf8 100640
> > --- a/drivers/virtio/virtio_balloon.c
> > +++ b/drivers/virtio/virtio_balloon.c
> > @@ -1055,6 +1055,9 @@ static int virtballoon_freeze(struct virtio_device *vdev)
> >  	 * The workqueue is already frozen by the PM core before this
> >  	 * function is called.
> >  	 */
> > +	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_REPORTING))
> > +		page_reporting_unregister(&vb->pr_dev_info);
> > +
> >  	remove_common(vb);
> >  	return 0;
> >  }
> >  
> >  static int virtballoon_restore(struct virtio_device *vdev)
> >  {
> >  	struct virtio_balloon *vb = vdev->priv;
> >  	int ret;
> >  
> >  	ret = init_vqs(vdev->priv);
> >  	if (ret)
> >  		return ret;
> >  
> >  	virtio_device_ready(vdev);
> >  
> > +	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_REPORTING)) {
> > +		ret = page_reporting_register(&vb->pr_dev_info);
> > +		if (ret)
> > +			goto out_remove_vqs;
> > +	}
> 
> Hm, that failure handling is rather nasty.
> 
> 
> In virtballoon_freeze() we document:
> 
> "The workqueue is already frozen by the PM core before this function is called"
> 
> Your report states:
> 
> "Workqueue: events page_reporting_process"
> 
> 
> I assume that workqueue is not frozen yet because ... it's not freezable :)
> 
> So could we queue to system_freezable_wq instead, or define our own freezable
> workqueue there? Then a driver doesn't have to worry about that.
> 
> -- 
> Cheers,
> 
> David

+1.  Just system_freezable_wq will do the trick.

-- 
MST


