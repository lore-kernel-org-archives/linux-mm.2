Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89869C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 08:23:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77C6F6B00DE; Mon,  6 Jul 2026 04:23:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 753DD6B00E8; Mon,  6 Jul 2026 04:23:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 669066B00EA; Mon,  6 Jul 2026 04:23:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 31BB56B00DE
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 04:23:56 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B00F58D3B7
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:23:55 +0000 (UTC)
X-FDA: 84957663630.19.5962E56
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 4AB92100006
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:23:53 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="auS/Rom/";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf05.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783326233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KiZ7rFhsrLuWgwOq/cJtjOuC/zDIDMp/izDn3la0y/g=;
	b=1BITmznmCOcaSA2cZSpVUhVry8+S7Ph43NywzATRWRWLCaIS42FYwnyDSGCYCcXi5EZPn5
	cUZcpNA3FjQpOQ7rlt2Wy831keOBJlmwXWmgQPbnjKjP/+kNP2QJiA/YURQM1y75y0rCEI
	icvNyulBnJPQqs4SDncZ7kiuslZk6Mo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="auS/Rom/";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf05.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783326233;
	b=sBo1UVRwbuLlFoGTtr6Pi5FeJy8SP+qv+Rf5d3XJLLj8XNni+0eRc/S/ZHHsHkWzR96fd3
	6n5pofvIZ5ZncjBGLzZI95dKdj94NjIkRT+iQQ1+6CYjhH+Qa8KRO0h1HSulRyTo8L5xeN
	FaD+uknf/uePq9dcIsHrdI7dKRkLqLk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783326232;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KiZ7rFhsrLuWgwOq/cJtjOuC/zDIDMp/izDn3la0y/g=;
	b=auS/Rom/ilPrKEDZ6l8JFeIVu2P6p5DiGpWbytg97tQkOIUdzVjpoVNO2zVGtpGxUAbavt
	Xs/FLKVoqcl75We9otbmi1YlIERc4RX5Fl5zWbdPF8lozKd7FumxWYaAhWmFD2bcMdhlp0
	x/2icNvSGHebVrJWhmZSEPW5WMeklYU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-616-yPvpZ0DfN0m6V8Lg3r5GrA-1; Mon, 06 Jul 2026 04:23:51 -0400
X-MC-Unique: yPvpZ0DfN0m6V8Lg3r5GrA-1
X-Mimecast-MFC-AGG-ID: yPvpZ0DfN0m6V8Lg3r5GrA_1783326231
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-493ae2a6a72so23407535e9.0
        for <linux-mm@kvack.org>; Mon, 06 Jul 2026 01:23:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783326230; x=1783931030;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KiZ7rFhsrLuWgwOq/cJtjOuC/zDIDMp/izDn3la0y/g=;
        b=EoIu66m5FIlcBNYpEN5KApAd2EXFRpmSdhQlOiIlp0LaL+hdA591i2+tWozB/MMNjU
         7ISpXVZAn1Vh4SGL6avKdJFV00Ep2RBfPUfhAihrOqinpHd/3jHsHRRZ6Vb9mktLs+72
         JOiNPltllbvhR6O1PtOtKFPoEBuSgd9rObocgllJZDI0oJ54BGI9NCis0JyQvCQD3vb2
         D8OlXJgtg1OWeaMivZ85FuQxJt4ZdpGzbnUUaOe/eHi/W8dE5U4eUQZfHWgUCQZtmoKq
         aNp4X4+LjS47ZktqTCHrWnUXBlGbZgk5nKHnUTq02Q6P/Tk5mCDf8Q1EMxlVfbh7i51M
         /xRQ==
X-Forwarded-Encrypted: i=1; AHgh+Rqud+t6ujHPOImWSPus873OLBz6wwm7razR4Rn+EFyIYDYTjewi2FVMvEgkxRDEFHFgKQTUYdyrZA==@kvack.org
X-Gm-Message-State: AOJu0YzZyK6dFzNbId2/NZfD1VlGOF9vqnXJxHxKSjeqM4a/Randq7wF
	KsmrdbdbHm4jT/KHdefnVnfOZMsLkj4X/rvm4lN/lg6QXaus+Yc1/OquwdVFJKQ9Rg1A9R2kjk+
	ZDcFaIazv5ByVFwotipN4qwKxr58ZXpc3yRp0rhy2Ienez+2ezOTU
X-Gm-Gg: AfdE7cmwFW5jMkfGrKWAeyZ6JmE8hfLTnFL8qW3JYl02yFbTv7JVp87luU+XBfg+Min
	iqeQADnBxd/ZBQlpjczIrrcZy9pYwCGM2jl2pKK4LS07FR2l6qybztlRR4nHeSh44sczqGeWUxc
	Z04NSGEz2ZsizzGUopgFtb0raKOL0pHsDfXazxSUOqk7k5hqWlAIEs80abc0Clqdny/oQnoqVzx
	xv9yvmMuBfoS4zz2WxXLu2vX2tEOjAjQID2qzdrCLXhCloLMu+w3CetYUF9vjUz2fUHCjnJBhxR
	F9/dROXI4xVIVWeXKWfRLNMCF3/9FRBO/RVC0cqPohtUZTMKCMhcyP4b/Nd+2oC36tqG7Dr9fL+
	7FdAg0XwIueaybqoVY3ZA4ht0JUTo8vED
X-Received: by 2002:a05:600c:a01:b0:493:a7bc:5bcf with SMTP id 5b1f17b1804b1-493d11f033cmr112299275e9.24.1783326230332;
        Mon, 06 Jul 2026 01:23:50 -0700 (PDT)
X-Received: by 2002:a05:600c:a01:b0:493:a7bc:5bcf with SMTP id 5b1f17b1804b1-493d11f033cmr112298735e9.24.1783326229699;
        Mon, 06 Jul 2026 01:23:49 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-68-31.inter.net.il. [80.230.68.31])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493c637bc21sm635500545e9.7.2026.07.06.01.23.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2026 01:23:49 -0700 (PDT)
Date: Mon, 6 Jul 2026 04:23:46 -0400
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
Message-ID: <20260706042207-mutt-send-email-mst@kernel.org>
References: <2f0d0de033f3005d3b985883be3e5cf37b3f6c42.1783278596.git.mst@redhat.com>
 <13794c5e-375a-4fc5-84b4-a637d077f8a0@kernel.org>
MIME-Version: 1.0
In-Reply-To: <13794c5e-375a-4fc5-84b4-a637d077f8a0@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: -B_oLeTy7IdkOpI8O-192tbczdLkOiwFTQBmaTBnqVY_1783326231
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 4AB92100006
X-Stat-Signature: 8kbm5egmkkaxhkeeyzog3c7pfpp7qyr5
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783326233-68776
X-HE-Meta: U2FsdGVkX1/SN5QgO+Nln4NS/XdORuWnugjt9IokwEaU1oJfDbQNajqxJQCH9wH0LSnXDgmfpfugvaVjfgZVSSVR3GCLoB+bXwBAcz4K4j8XAUHAozn2a6loBtuXZdhMZmyFyOEluHB7LOMKQlxN6ZX5F1N1cbWCatxIiTa2fldGGhYyyGPWtKxWOg4sElIEXRXi/Tf7bVlwFpeunGBSWnS+sOrANQ/EvpWehW6WLPff7+SDGLYLm0kwESLg2GE9TG/0KdRBt7yArsMgppdlt9lUxXOdNlZ67eE9+nmdNbTgTh3whovDunqCQSneYUFlW0gx7jzaN6vbQeR8XmRq0/ZO0pPX2t6A7o3pXTKYXY5PX2K23W5BHia2d3biv3+F+TbDbmQvyW/PABEUTVQnaBdVChUWjptlFtBuKzE3HZ/qm2qjRw+h0R6FJEpciZdhTBGsKKI+PsfG36Fy5sFQvxGP9ukD2r3WR5Gak766gzqZzUA+Passa9WwbTBGkKTY2QpBk8fDql9sEyMAvcB/foHNFE4CmZFCJEd9zokjUFgZ2xKngFXRmu8J4+CvRK8Q8piQZytgqIHAvinagDcywWAicjO+bvCv8NKGGfcPQ/ca5kPYI+qckzlSguM0i7udVKoEDieQYOmV7C/PMg4rDsW97Ys3X1JqFPXt7twvqKDdXQimNoL4GoZfwMGJFwcYcCr5VTaOnBJrIZGSrSICVH3HGWhS6veQg+0L+rwA762ccmsvg8Wv39mTZn/IGbeHjJLp8LwqG5yjyGQ8SpnHh4M5bupPI/Pqss3tLcvL6LjXzXNhHufobUz0/2fulFN3yZRong2iSjfgCHYxCFS/XOCdYJjLF5vyAOfLDWakSMA7WJ1xs/j7RTBNSmL4mk2pYr7k9LAD6zy1FmrxLh2b5gHdiXWkRHAiZWp7iFrAUUnt1PodEIgXRL6zrV1ipDV0DhE2DsJ3EsayYoqD9ju
 tUtGBWUE
 r4zkT8DYm1irSlq003qYnBC083e0Cu5wFU0mz9Yx82hyxLRnWti+ogBkk6bjlXD50Z+DZ1o69mA4m0VuURLeWWLz31QDDpQdVLGQSO8HhvslaQ5GY2BGrmBILQNegJNIXiilVbpe5VF4yjB5oncVy4GMPv7u8y3Wg0XeSwCspyRDcp5GV0f1HfYepVjOSJiGcmBXerLpZlfmvabBl27yJIYAdotMJfFOwpTMXMOoqh0qXmnPP6HJWgSmRMP9Gzy1zfGxocTrksUmdUfubZV4b6vSdk48RWDM8EzaZbImhGeOk168MsPNdNDtvZF7MPaDChXMjOQ2bfKbDf3o/ujpt+QCEy60GSA8ejWp2cMQdGynUhS5lh1n4YkM19TMvUzp28CIhjKZ5yKgDmtOnZ8WvzgGJ3kZi+4wAlrI9PZC4RO9k5s8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 06, 2026 at 09:28:50AM +0200, David Hildenbrand (Arm) wrote:
> On 7/5/26 21:12, Michael S. Tsirkin wrote:
> > The virtio spec requires the driver not to kick the device before
> > DRIVER_OK is set.  init_vqs() primes the stats virtqueue with a buffer
> > and kicks the device before virtio_device_ready() is called in
> > virtballoon_probe(), violating this requirement.
> > 
> > Further, if the device responds to the early kick by processing the
> > buffer before DRIVER_OK, stats_request() fires and queues
> > update_balloon_stats_work.  Should probe then fail and free vb, the work
> > runs against freed memory.
> > 
> > To fix, move buffer setup to after DRIVER_OK. Be careful to
> > disable update_balloon_stats_work while this is going on,
> > to make sure it does not race with the setup.
> > 
> > setup_vqs() warns but does not fail probe or restore if
> > virtqueue_add_outbuf() fails; the call never actually fails in these
> > contexts since the queue is freshly initialized and empty.
> > 
> > Testing: tested that stats still work after the change.
> > 
> > Fixes: 9564e138b1f6 ("virtio: Add memory statistics reporting to the balloon driver (V4)")
> > Reported-by: Sashiko:gemini-3.1-pro-preview
> > Cc: David Hildenbrand <david@kernel.org>
> > Assisted-by: Claude:claude-sonnet-4-6
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> > 
> > changes from v1:
> > 	check that work enable/disable is balanced
> > 	explain how add buf never fails in probe/restore
> > 
> >  drivers/virtio/virtio_balloon.c | 50 +++++++++++++++++++++------------
> >  1 file changed, 32 insertions(+), 18 deletions(-)
> > 
> > diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
> > index 088b3a0e6ce6..bc0a2b19ca7d 100644
> > --- a/drivers/virtio/virtio_balloon.c
> > +++ b/drivers/virtio/virtio_balloon.c
> > @@ -611,25 +611,8 @@ static int init_vqs(struct virtio_balloon *vb)
> >  	vb->inflate_vq = vqs[VIRTIO_BALLOON_VQ_INFLATE];
> >  	vb->deflate_vq = vqs[VIRTIO_BALLOON_VQ_DEFLATE];
> >  	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_STATS_VQ)) {
> > -		struct scatterlist sg;
> > -		unsigned int num_stats;
> >  		vb->stats_vq = vqs[VIRTIO_BALLOON_VQ_STATS];
> > -
> > -		/*
> > -		 * Prime this virtqueue with one buffer so the hypervisor can
> > -		 * use it to signal us later (it can't be broken yet!).
> > -		 */
> > -		num_stats = update_balloon_stats(vb);
> > -
> > -		sg_init_one(&sg, vb->stats, sizeof(vb->stats[0]) * num_stats);
> > -		err = virtqueue_add_outbuf(vb->stats_vq, &sg, 1, vb,
> > -					   GFP_KERNEL);
> > -		if (err) {
> > -			dev_warn(&vb->vdev->dev, "%s: add stat_vq failed\n",
> > -				 __func__);
> > -			return err;
> > -		}
> > -		virtqueue_kick(vb->stats_vq);
> > +		disable_work(&vb->update_balloon_stats_work);
> 
> That's to stop the stats queue triggering stats_request() I assume?

Yes.

> Is that
> valid before we actually added+kicked ourselves?

Why not?

> Also, can't we simply handle that in stats_request(), just ignoring it there?

Then we'd need to maintain a special flag and I dislike that.

> Then  we wouldn't have to go through the siable + enable.

We'd still need to flip the flag on/off.

> >  	}
> >  
> >  	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_FREE_PAGE_HINT))
> > @@ -916,6 +899,33 @@ static int virtio_balloon_register_shrinker(struct virtio_balloon *vb)
> >  	return 0;
> >  }
> >  
> > +static void setup_vqs(struct virtio_balloon *vb)
> > +{
> > +	struct scatterlist sg;
> > +	unsigned int num_stats;
> > +	bool ret;
> > +
> > +	if (!virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_STATS_VQ))
> > +		return;
> > +
> > +	/*
> > +	 * Prime this virtqueue with one buffer so the hypervisor can
> > +	 * use it to signal us later (it can't be broken yet!).
> > +	 */
> > +	num_stats = update_balloon_stats(vb);
> > +	sg_init_one(&sg, vb->stats, sizeof(vb->stats[0]) * num_stats);
> > +	if (virtqueue_add_outbuf(vb->stats_vq, &sg, 1, vb, GFP_KERNEL)) {
> > +		dev_warn(&vb->vdev->dev, "%s: add stat_vq failed\n", __func__);
> > +		return;
> > +	}
> > +	virtqueue_kick(vb->stats_vq);
> > +
> > +	ret = enable_and_queue_work(system_freezable_wq,
> > +				    &vb->update_balloon_stats_work);
> > +	/* Make sure we balanced enable/disable, or we won't report stats. */
> > +	BUG_ON(!ret);
> 
> A WARN_ON_ONCE() should be good enough here, no need to crash the kernel (no new
> BUG_ON's).

Will do, thanks!

> -- 
> Cheers,
> 
> David


