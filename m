Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DDABC4450A
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 18:52:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0812E6B0095; Tue, 14 Jul 2026 14:52:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0583D6B009B; Tue, 14 Jul 2026 14:52:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB0206B009D; Tue, 14 Jul 2026 14:52:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BD5566B0095
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:52:48 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4DC891C047F
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 18:52:48 +0000 (UTC)
X-FDA: 84988278816.23.336F6F3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id EC59E4000F
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 18:52:45 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XYxaky9c;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf27.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784055166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nIfwW/o8U7z/0oL+ZaQUBUaHVA8qfCLS7p9kgkBe1fQ=;
	b=opY0tkWo5jZ45sO4PIUx9VwXug4WJGN0EsRpGaVuG7uGS96/yFIQYHwwwfT4NBupZLNTpJ
	GwrNYg+GXydpTdlC72d/lz8qnzcNu8gUGFaI7Xxji0T2eZVGOGkT58DL1VmAVnLDGErJBd
	FsoX4VDH5mURTbHTqv7vky9SCBfk2PY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XYxaky9c;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf27.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784055166;
	b=L0BiDDokZwKnVn52Tyv9bHseCuh9ahLGg1hp/bsuR6SvVoOV1HCvJvpzZPto10/PGlhngL
	BpQMA9Sun3vuExq3KYsBJceOogXNS+eP6EZhTXsVEgGXL9phz4+v88Ti2Tqv5yR9uP1XnN
	4aXN+H6f7Bb8miO8W2DmZIDYomSwP6M=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784055165;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nIfwW/o8U7z/0oL+ZaQUBUaHVA8qfCLS7p9kgkBe1fQ=;
	b=XYxaky9cPWlOEL2KS88x6JBpWPwnwxRgchhSNRHioO+diYqjT///0j+Vr8HYYsZP4jGobp
	HBBAznsY1FhT9lptk0BrG8cLehNTNSDSzHsL6Xp4DIxXKsxnSjNLcuw+Q9AvjnM6WP0myt
	Q8FK7suH/LumcDP/1yDzm3mC1Y91XAA=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-313-ZMYrU9F2OL-MxL-Tvs8A8A-1; Tue, 14 Jul 2026 14:52:43 -0400
X-MC-Unique: ZMYrU9F2OL-MxL-Tvs8A8A-1
X-Mimecast-MFC-AGG-ID: ZMYrU9F2OL-MxL-Tvs8A8A_1784055162
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-4744b72f90bso2445062f8f.0
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 11:52:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784055162; x=1784659962;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nIfwW/o8U7z/0oL+ZaQUBUaHVA8qfCLS7p9kgkBe1fQ=;
        b=aC8JvTm8ZBTGuV/sWV75UiiPw14vP3w4kSZhWw++zyENvyTBFlVFy7ikeBdhswdeWC
         AJflw6/hda4zvnp45X/JFCjuc479Pepnmz2Rq1LwAqk4USpFi4xAX8VvW427k5SWZGtg
         AXgt5xvLvi3BZ8S0OzGzdxehmaLuxIpEVvABzYdM2kQfBOwXFg2T2MonLj0QakajUOUx
         yI7arbfL+Lk8Ws89E2celVTEAYhfm2uIphQB1SkhiQdDN9P8urJ2yY/2pmfJDrVNoOdS
         jfcQU3gW9GZf0qUMyGFnbbzY6J0B4Jb4kPf8zH/gmkb2/mnXxRCzVXLAxk7aNTotK2jv
         9rJA==
X-Forwarded-Encrypted: i=1; AHgh+RqA/z1Q4uxq4coQPnlF4kXhDzIN6l2+jZXx839Tk5rqddZF25TYaVVK72bZrhgzyNlfB+SaY7OXuA==@kvack.org
X-Gm-Message-State: AOJu0YzKlYnMJrdgexmtCbIz2jFqo4SCf/MUUTiaAcfvWwUI4p+z9tDe
	pWeRVW4ROKaETiT2ufnlbF5xTNOjy8H5uMScL1J/EG5okNQixOV5xJKxdaWF1N1C14R2NfYSPy1
	LnR06FKJSJd7/vxcRIus70bGuX+9kNN94NZscEw8ksicKET5F4U91
X-Gm-Gg: AfdE7cmW/32Da1nP9a6NS9YIiGLqKTJCMqNEvB2AmCS9kzrsIvKIPpp4RcIF/XAokYM
	VCTCYU8xD1i/ukoKmtNKc4YN2RfXO5JFvaSQXdHARZyn/6XORm8mZTLAHMCcewMCUKyOQH1kFrZ
	d8AjGy8NapU6x7FjvbQj0dzHbuBpMgzT4dpSqjd+4h3yBAz8vA2vabtolCiNFWD7GZ2yp53SuTH
	d+4xtHpNhisWWBuh4v77f48W3XMJtqjCS4vqPLhiSJDHqgrQ64l2UOL6utj5K7cG+vul0yh5d78
	b15TOmlnF8jz7bd1gneV5ChduxrONaJ/xcwCNXpslstsugrGxeY31bL6S2G6jogBleC42hCEXFR
	hg0u+wzg3Tiw0l5Ky1aUHRnJcFTrb5Fb5hlE=
X-Received: by 2002:a5d:5f49:0:b0:462:6aa1:4393 with SMTP id ffacd0b85a97d-47f4886edc6mr4094730f8f.4.1784055161954;
        Tue, 14 Jul 2026 11:52:41 -0700 (PDT)
X-Received: by 2002:a5d:5f49:0:b0:462:6aa1:4393 with SMTP id ffacd0b85a97d-47f4886edc6mr4094699f8f.4.1784055161476;
        Tue, 14 Jul 2026 11:52:41 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-24-117.inter.net.il. [80.230.24.117])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f464a9879sm11237677f8f.22.2026.07.14.11.52.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 11:52:40 -0700 (PDT)
Date: Tue, 14 Jul 2026 14:52:37 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: David Rientjes <rientjes@google.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Link Lin <linkl@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>, virtualization@lists.linux.dev,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, prasin@google.com,
	duenwen@google.com, jasowang@redhat.com, xuanzhuo@linux.alibaba.com,
	Ammar Faizi <ammarfaizi2@openresty.com>, jiaqiyan@google.com,
	ahwilkins@google.com, Greg Thelen <gthelen@google.com>,
	Alexander Duyck <alexander.duyck@gmail.com>, stable@vger.kernel.org
Subject: Re: [RFC] virtio_balloon: fix Use-After-Free in page reporting
 during PM freeze
Message-ID: <20260714145155-mutt-send-email-mst@kernel.org>
References: <20260709224330.946683-1-linkl@google.com>
 <8d316b6c-41fb-4ae3-8923-3b649b92b33d@kernel.org>
 <20260714092146-mutt-send-email-mst@kernel.org>
 <5e18d7ec-a9d7-2cc3-7741-695ec3580ffa@google.com>
MIME-Version: 1.0
In-Reply-To: <5e18d7ec-a9d7-2cc3-7741-695ec3580ffa@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: JqOP8e3rbFuqtA1n4oQ7NXpuGuIQ1z8EVqCkHyeF9mE_1784055162
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: EC59E4000F
X-Stat-Signature: u7yeqf93otzofmu34pwb4amnzm4kx883
X-HE-Tag: 1784055165-870866
X-HE-Meta: U2FsdGVkX18XzBiJA/oXg7M3v/OtdGZb22XZPdl3VFb8V9MCPjjBURwOkCXxV2V2pbVjwjxYPGy+A+vWQ4LRgt/klxwnkdVA55PJIy1J3lBvfZfZC6XjOLkPQLUDNBhJxdw1g7bgiZib7N5cLDIsC0za0uJcYdDLydtXR8t+VdaJqqCBNvvQ76dPlipR7eUkxon95pxIpvbTAM7l6xhTCswPphthRApigXfC+dmKiwyNcj38BpSgTWGfBozNLadnAbLqbGmUxro8e1v1+q7f5JKoNfXHWntB6ifIWupyvCpkXRCF+/DWrMb37Auxf4/CWJVda0rdY4xgGZPAZFJNKpXJLF1P1GjLDvZmhRDzBf228uhpEZw0FDV96qwMjuL1i0wAeHfpCwwDGJrnof/UgC867J8UrOCuUufB3xyTAftZ7tXUYvmqelsiJaR1dedzbIWzbR81Z45tIeTUfEViEQ1j3qz5Gw3oV7toXUJFwV2lGf77Rqzmpqo8FUED1BslpwjV8IKDmPXJdT+SlaWnb+Db9I3AjQITazaiOr/1lMDGPCpq4tGLYYtyOgJUofjImtkbIi7/LqERW1LAuCB8r0O17wzFhNMqS3gNyfB9dD/NmJHO2WPywo1ft2Tp6NTeumT5O4jueMQw2NNKmBhXOxGfVoeUqVU8uhIYJ9aJtlIi6nXD6FuwG5CCGJdYJdsenczhpobVeIhWgziOpl22H2OCfNgifU2tDzVKgiWD5b8zNGxO1LyDosmsh3+A6uV+E4LCYgBreyvKOpDCVsDEMbyJxVn+hHuohEhFglrq4krTgV1jow36qkrxrPwhqJyp+5fAkSgutUZ9duFas6YG72+9uSpPNKnIIUwx+5wccLs0cB3y09MXYaL/IXtu51LnUnmjbgvm968eSocuOBmBT9lG4OydA0d7T7DXf23rDrgT0+85f2PKOtQlcxH2XxKPYQzukS8PwfjwRcplE33
 +h1XDvI9
 Ov1eSBYShaESf/vhWJFl5e1Oo5/8f4yDiDxd8+BpvVSnNvHJREUXqJrjlGQbB+HbCYHSQsW23lGC0i80fO4E1HzWzjtAhQiSZ+qXKUGCRpHTVBqDd7axmDb3n/tvFc4P/UcfKYSNv3izbKIcfmQAEeS+nejeMsWVl+wASW8b7m0bKHYbgXiX/a6NRf0SVWWIdxWRT3F0FghesYPqkNPS576GHr6dW6goj+uh6GmnsSgpegqF33QRkbjIW1wuqo85qF0Rz8/R/EFXCIeDw53vyZSZCZv1J4fT3lgjt9S5LYU+mKvUafCpLYsyAQaRXY5lWnnffzwIjRYNvSp4ZBvxRvJ4Np8jC9TdNE2J9y8aNHUxVLDXAhiwFJtMuZ2vtg/sqlyXn7NB1VsjvkGhhAFTVxGEU65DXnAszZzjo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 14, 2026 at 11:21:33AM -0700, David Rientjes wrote:
> On Tue, 14 Jul 2026, Michael S. Tsirkin wrote:
> 
> > > > diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
> > > > index a1b2c3d4e5f6..45a90fb3abf8 100640
> > > > --- a/drivers/virtio/virtio_balloon.c
> > > > +++ b/drivers/virtio/virtio_balloon.c
> > > > @@ -1055,6 +1055,9 @@ static int virtballoon_freeze(struct virtio_device *vdev)
> > > >  	 * The workqueue is already frozen by the PM core before this
> > > >  	 * function is called.
> > > >  	 */
> > > > +	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_REPORTING))
> > > > +		page_reporting_unregister(&vb->pr_dev_info);
> > > > +
> > > >  	remove_common(vb);
> > > >  	return 0;
> > > >  }
> > > >  
> > > >  static int virtballoon_restore(struct virtio_device *vdev)
> > > >  {
> > > >  	struct virtio_balloon *vb = vdev->priv;
> > > >  	int ret;
> > > >  
> > > >  	ret = init_vqs(vdev->priv);
> > > >  	if (ret)
> > > >  		return ret;
> > > >  
> > > >  	virtio_device_ready(vdev);
> > > >  
> > > > +	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_REPORTING)) {
> > > > +		ret = page_reporting_register(&vb->pr_dev_info);
> > > > +		if (ret)
> > > > +			goto out_remove_vqs;
> > > > +	}
> > > 
> > > Hm, that failure handling is rather nasty.
> > > 
> > > 
> > > In virtballoon_freeze() we document:
> > > 
> > > "The workqueue is already frozen by the PM core before this function is called"
> > > 
> > > Your report states:
> > > 
> > > "Workqueue: events page_reporting_process"
> > > 
> > > 
> > > I assume that workqueue is not frozen yet because ... it's not freezable :)
> > > 
> > > So could we queue to system_freezable_wq instead, or define our own freezable
> > > workqueue there? Then a driver doesn't have to worry about that.
> > > 
> > > -- 
> > > Cheers,
> > > 
> > > David
> > 
> > +1.  Just system_freezable_wq will do the trick.
> > 
> 
> This makes sense.
> 
> I'm curious why this bug hasn't popped up earlier, presumably any VM that 
> has gone through suspend while reporting free pages through FPR is 
> vulnerable to it and could have panicked as a result.  Which would suggest 
> maybe >99% of FPR is done by guests that never suspend?

Quite possible.

>  While under 
> pressure this issue seems reproducible.


