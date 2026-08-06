Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9184BC5AC67
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 23:00:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77BF96B00A3; Thu,  6 Aug 2026 19:00:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7536B6B00A4; Thu,  6 Aug 2026 19:00:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6692A6B00A5; Thu,  6 Aug 2026 19:00:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2BA2C6B00A3
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 19:00:21 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8BE1B405E9
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 23:00:20 +0000 (UTC)
X-FDA: 85072365000.24.549F7D0
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id F2585120007
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 23:00:17 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RZ7TElDH;
	spf=pass (imf29.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786057218;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V/XyIJ0P1Ncw2ZC5RUbuOjY9InJ1Bze3sfj+kDZLJRI=;
	b=gW0EwN47B8t17N5jBbByFlKIFL7mSwRH1cpn5XoJTQ8zvVx72AvpNSneo+u66z+BPu6crP
	ndohdQ9J6I55gowyEXUhd+yH+asfTmyIrWpoo5qW7SSHItEVtKXsbQyQimJHIYaeml/qYq
	ztIbrqor/cxM61G30Vs7MBNe7OXU48M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786057218;
	b=tPoCTku6EphcNkAuCkjWvBi4MJdhoUmsrG0CVkxbWrsw3JF/sxWQC9gy8Fb7Z44d2IcuS+
	O97aB0+nm8bTJ4v+4QFgOir8U+fmzcPY5WSwsqHOMaFDSON/to01KHT6NZYc04Z/NaUxhm
	U7dtFEdnPS0m14qY/8ZuTqkfjx7+uEo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RZ7TElDH;
	spf=pass (imf29.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786057217;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=V/XyIJ0P1Ncw2ZC5RUbuOjY9InJ1Bze3sfj+kDZLJRI=;
	b=RZ7TElDHrAVdbTVMqfqbx81FukVXkECk6M4Q/leM3geBs53qnsmbcTK03hXOHLfKSyrNsa
	TmSCelkXW5j351wfIFtQ/px8Vfyh4knZLB7Li7ZzK04FEERCADf42wVEZ1BL3+YGPnVPA6
	95BZjzdDVDyTy/c+UJtk/SD20vDsz5s=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-602-vesV0ewbMzW_X0K32szJuw-1; Thu, 06 Aug 2026 19:00:09 -0400
X-MC-Unique: vesV0ewbMzW_X0K32szJuw-1
X-Mimecast-MFC-AGG-ID: vesV0ewbMzW_X0K32szJuw_1786057208
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-48000d75326so80316f8f.2
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 16:00:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786057208; x=1786662008;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=V/XyIJ0P1Ncw2ZC5RUbuOjY9InJ1Bze3sfj+kDZLJRI=;
        b=s5U+nCzrkLUQvB60PkDquwB3g9xoHZBcfJmrw1mwxEkmGAmMjJ2ylPZ6xbGitT6QY0
         hch7E9gyJzma9jrLRYJmg1LmA4lcYFr2kKCDrAK8/IEAIiW2SEB6FLQneq73KRMyfchq
         nrI06uBB4KetV9vIbpPwLHLpBi9c312x6LEp9ORCCokyUDULyQ8oKv2Yjxd/sMDmSI/A
         Y61DC5aV87xVIVqQm7KX7ALpUencVSe1yunJ1M6H8/CJkwzzJ5un26EEx7/N7i0zvW1c
         9QwDSm/zs2Dqn0W7hiYJvFsY7evMzjs7rz2NwLxA3XCXh3blZyOQUxaGtMcxkceOYeZH
         THUA==
X-Forwarded-Encrypted: i=1; AHgh+Rru8h8oV2S5etEkBrEIywEJPIbLrMZBiYaguR6S38HZmO0VgvZD68HVxW3KE2JMKcnO/8XG4GKcKA==@kvack.org
X-Gm-Message-State: AOJu0YxGFUPzcbKBklxgvcvt+xubkHXTJGFon1z/ZvRcOgS9kc39EJ/H
	9nGoY7z6rC6HJNTiTNVzmOEZ192yFNg/kDGqht3STheRkQLN2si9XNEnuwkGALtqwSw8Te24/hb
	QN9XG+nPO7uBgeHiXLjxC9wHyKW/WoUCUfVpok17lD1oSyxe62hEe
X-Gm-Gg: AR+sD11/59xHecjHrmmId/x7t8ApErR+gWEc0D34KxEuW8s8QSMgYLCMZ+6CCo2xT8f
	Kie68v3KvEIvTN1tGvxJU3n905lZxuPX4b7WQk9MQ+828dePego1+a0xcdVQyj6tAaDc49ykhAJ
	SPs1VxuI6sr9sDbeuuO7A2NyOpT4cpyXZckT1jo2uii9xeJgIS1s4jugxEMkCfN0A1Tz9eWnxPH
	+e75RyA0GVi+Vnfkz5LaG9kLXTxMprgAETNXHKFw2AtUZmKNF/S3sSehEdHbqSy610Y+ihvY0lW
	nRQE64ort/1mGaFRktTruBGdZnUx8OxM8cNVppPT3tHVHk6m4oOaeg92tRng2OuEBxlmhj0I9Sx
	txhsET0EFUbFqZ2B2vJ7vIw==
X-Received: by 2002:a05:600c:3b04:b0:495:5e86:4e11 with SMTP id 5b1f17b1804b1-4994e7baa85mr237163815e9.12.1786057207743;
        Thu, 06 Aug 2026 16:00:07 -0700 (PDT)
X-Received: by 2002:a05:600c:3b04:b0:495:5e86:4e11 with SMTP id 5b1f17b1804b1-4994e7baa85mr237162725e9.12.1786057207114;
        Thu, 06 Aug 2026 16:00:07 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-28-14.inter.net.il. [80.230.28.14])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4995d85254asm1707125e9.1.2026.08.06.16.00.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 16:00:06 -0700 (PDT)
Date: Thu, 6 Aug 2026 19:00:01 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Link Lin <linkl@google.com>
Cc: Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>, virtualization@lists.linux.dev,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, prasin@google.com,
	rientjes@google.com, duenwen@google.com, jiaqiyan@google.com,
	ahwilkins@google.com, Greg Thelen <gthelen@google.com>,
	Alexander Duyck <alexander.duyck@gmail.com>, jthoughton@google.com,
	stable@vger.kernel.org, Cory Maccarrone <maccarro@google.com>,
	Taylor Scanlon <tayy@google.com>
Subject: Re: [RFC PATCH] virtio_balloon: add
 VIRTIO_BALLOON_F_REPORTING_PM_SAFE feature bit
Message-ID: <20260806185414-mutt-send-email-mst@kernel.org>
References: <20260724014605.3377283-1-linkl@google.com>
MIME-Version: 1.0
In-Reply-To: <20260724014605.3377283-1-linkl@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: nBg7vnyiLfvtIiAHzO4T3dhlz0Aba6LJ11bhw2bpROc_1786057208
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: F2585120007
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 4keyungu6bttwfuspdpiy9rybd9u6jsj
X-HE-Tag: 1786057217-909051
X-HE-Meta: U2FsdGVkX1+STQTSzeLb49WgPuRlMXAc0HnrP/CGSDXJPQM9DmzgWkGE8PVt6lIS3oLYaw65PB9F/rpzsTv8hs+PhwGiXk1cq69gKdhypvziEqUN3c3FtcdgCtjFCV+YojFKnoCfm1EONk6N8OONbt/m9EbGjxNnOWWIQhtvcKOM0bha7tO9oAY6A6pdBpwFeSQNFFI1eCivpN54+xfgg6bqI0HVwIEP6VM+ETi78M43lscnHzpZtixAko5wO0jKjHcuTbFdwag0LomkX8y+d516p5Xfr3s8d6j+XD+SmVyYXD+X+Q140N/SUQ+qVWxbtoiGTFaIlsA8yJMjqHneF+YMbs/9Bz20HhjqqLhqvYr4qHWrodC5g9pY3RFtrWysz6hiXjU0sf1FPoP88vOeWjUQMdNCV7xUDRVM6lsgi3mOJR3ZcgWj8YwljWdPe0v6FyAzfgVC8g4IsW1Z9snb5dhNJmSD8YNCH7aE1Tsu6Nwrn8Hiw0RXAiFOTzhmKeiaizV8j66PS22n8MBkLB6jVgvwSqLJk7pJnZ5gpRN/Wk7SjVqe536StdaEI/Cx26mHI0a6haY7hcyclX36n2gi5kxqFQ19phitPLSfbrdjUCIqcRlk6T69okwIilqs2/ZZvW76jJWlaNjSU5KwtOfUiSYp/ybfhgIJelI/Oo4c82O6rqB0o/DLe4JSxEprDUSqmc7GSzZIVejztuCtKbJNlcTaaIYqQiwpYCZyYY8c4j1Y3mbuClqL1JUphWFo9HvyNI1C4q2wuQtMJr0b3JZdfTQRsRcPiBLMPnnLSUn4OwApVqU5Br23+wU2W12ZNzKljbI8BI657NlcEHpNKuKEeoBvwsb4Xtjg7cudYCi0hG/lBvJolAZQxHTy1EbBYSeL0jytBMH43XpZd2IaVZD6RX02aUfdoDcjSvDpz0RLqo3XWy31J8OHvZlT5nMeak//KIAs4XSfqBaDvk8V215
 wq1/zyuw
 57YdV9VPskaiM9sjXL2AFkoNUN0IwRuL3bmXukm1Fur5sZnWgREkNVFeINvg6A8w3xU+3PdMTwg25MDX9xT8MmnhsuB3zsBCmchq3sW2bg+9JUe/DaMhliSvp+S8MDLOadaXNIw0g+IIGq2khOlGCS+4kYkxX1mci0rvwT3SMRZ5X8QKfBNw9zgoV5WwNg/ymx9ScUuz9L5CORNvXgoeNmxmZefCz8Wx5eXcRAkvrrtX9JleHAppp7Cw+HjBvJRC7e1lLho9RavX077ZYkTeLRDOROnH+qNnENZsr92k9ohC1ZB5Mp23r3Es8Mya0qJUgPgVP44vaughBJmDQJ03VsKfksp8YSkrwcEQNeAFfNmqvi3HWEOzC2mqWRILfXI+RBJvV1x6kj/M49lE4zG4bqZtcipGKhSrTNctuMK/WX39m0nA/jPzxbCw9UCZJRynLmYKNbuLuzSPeIxu/PphwsfgSyA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 24, 2026 at 01:46:05AM +0000, Link Lin wrote:
> Following up on the fix for the PM suspend Use-After-Free race condition in
> mm/page_reporting (merged in mm-hotfixes-unstable: 
> https://lore.kernel.org/all/20260723003650.CAAF01F000E9@smtp.kernel.org/), 
> we face a hypervisor-side deployment dilemma.
> 
> Cloud hypervisors want to safely enable the Free Page Reporting (FPR) 
> virtqueue across their fleets, but enabling it indiscriminately on guests 
> without the recent suspend fix exposes them to UAF crashes. Relying on 
> out-of-band metadata (e.g., OS image tags) to selectively enable the 
> feature is fragile for custom user images or live-patched kernels.
> 
> To address this at the protocol level, we propose adding a new feature bit 
> to the Virtio Specification: 
> VIRTIO_BALLOON_F_REPORTING_PM_SAFE (Bit 6)
> 
> This establishes a formal device lifecycle contract for power management:
> If negotiated, the driver MUST guarantee that all page reporting operations
> are halted and pending requests are flushed before the device/system
> transitions into a suspended state (e.g., ACPI S3/S4).


> Deployment semantics:
> - Hypervisors operating in a strict "safe mode" can offer Bit 6 exclusively 
>   (suppressing Bit 5 / VIRTIO_BALLOON_F_REPORTING).
> - Older, unpatched Linux guests will see Bit 5 is absent, ignore Bit 6, and 
>   safely skip FPR initialization, preventing the suspend crash. Standard
>   ballooning remains 100% functional.
> - Patched Linux guests will recognize Bit 6 and safely initialize FPR.
> - Note for fleet deployments: Non-Linux guests (e.g., Windows, FreeBSD) 
>   that rely on Bit 5 will temporarily lose FPR if the hypervisor exclusively 
>   offers Bit 6. This is considered an acceptable trade-off to globally 
>   protect unpatched guests without relying on OS image tags, until those 
>   respective virtio drivers adopt Bit 6.

This makes no sense to me. So there's a bug in the guest and it crashes.
Patch the guest.

There's just no chance we'll add flags every time some guest drivers
on some OSes have a UAF.

What makes this specific bug special?

Trust me when I say UAF issues e.g. around hotplug are a dime a dozen.
Now what, let's add another one around hotplug? And so on.

> 
> Implementation Note on Upstream/Downstream Dependencies:
> --------------------------------------------------------
> Because it is critical that downstream Linux distros do not accidentally 
> backport Bit 6 without the core MM UAF fix, the final upstream 
> implementation of this patch will enforce a strict compile-time dependency. 
> We plan to export a macro (e.g., PAGE_REPORTING_HAS_FREEZABLE_WQ) from the 
> core MM fix, and wrap Bit 6 behind an #ifdef of that macro in 
> virtio_balloon.c. This guarantees that compiler backports must consume the 
> entire dependency chain to advertise the feature.
> 
> Below is the proposed Linux proof-of-concept based on upstream master. We 
> introduce a helper virtio_balloon_has_reporting() to ensure virtqueues are 
> properly allocated, torn down, and validated if either bit is negotiated.
> 
> If this architectural approach is acceptable for cloud deployments, we will 
> formally submit this patch and open a corresponding issue for the OASIS 
> Virtio specification.
> 
> Depends-on: <Message-ID: 20260723003650.CAAF01F000E9@smtp.kernel.org>
> Signed-off-by: Link Lin <linkl@google.com>
> ---
>  drivers/virtio/virtio_balloon.c     | 15 +++++++++++----
>  include/uapi/linux/virtio_balloon.h |  1 +
>  2 files changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
> index 581ac799d9..00e8273dc3 100644
> --- a/drivers/virtio/virtio_balloon.c
> +++ b/drivers/virtio/virtio_balloon.c
> @@ -39,6 +39,12 @@
>  	(1 << (VIRTIO_BALLOON_HINT_BLOCK_ORDER + PAGE_SHIFT))
>  #define VIRTIO_BALLOON_HINT_BLOCK_PAGES (1 << VIRTIO_BALLOON_HINT_BLOCK_ORDER)
>  
> +static inline bool virtio_balloon_has_reporting(struct virtio_device *vdev)
> +{
> +	return virtio_has_feature(vdev, VIRTIO_BALLOON_F_REPORTING) ||
> +	       virtio_has_feature(vdev, VIRTIO_BALLOON_F_REPORTING_PM_SAFE);
> +}
> +
>  enum virtio_balloon_vq {
>  	VIRTIO_BALLOON_VQ_INFLATE,
>  	VIRTIO_BALLOON_VQ_DEFLATE,
> @@ -598,7 +604,7 @@ static int init_vqs(struct virtio_balloon *vb)
>  	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_FREE_PAGE_HINT))
>  		vqs_info[VIRTIO_BALLOON_VQ_FREE_PAGE].name = "free_page_vq";
>  
> -	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_REPORTING)) {
> +	if (virtio_balloon_has_reporting(vb->vdev)) {
>  		vqs_info[VIRTIO_BALLOON_VQ_REPORTING].name = "reporting_vq";
>  		vqs_info[VIRTIO_BALLOON_VQ_REPORTING].callback = balloon_ack;
>  	}
> @@ -635,7 +641,7 @@ static int init_vqs(struct virtio_balloon *vb)
>  	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_FREE_PAGE_HINT))
>  		vb->free_page_vq = vqs[VIRTIO_BALLOON_VQ_FREE_PAGE];
>  
> -	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_REPORTING))
> +	if (virtio_balloon_has_reporting(vb->vdev))
>  		vb->reporting_vq = vqs[VIRTIO_BALLOON_VQ_REPORTING];
>  
>  	return 0;
> @@ -1013,7 +1019,7 @@ static int virtballoon_probe(struct virtio_device *vdev)
>  	}
>  
>  	vb->pr_dev_info.report = virtballoon_free_page_report;
> -	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_REPORTING)) {
> +	if (virtio_balloon_has_reporting(vb->vdev)) {
>  		unsigned int capacity;
>  
>  		capacity = virtqueue_get_vring_size(vb->reporting_vq);
> @@ -1099,7 +1105,7 @@ static void virtballoon_remove(struct virtio_device *vdev)
>  {
>  	struct virtio_balloon *vb = vdev->priv;
>  
> -	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_REPORTING))
> +	if (virtio_balloon_has_reporting(vb->vdev))
>  		page_reporting_unregister(&vb->pr_dev_info);
>  	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_DEFLATE_ON_OOM))
>  		unregister_oom_notifier(&vb->oom_nb);
> @@ -1162,8 +1168,10 @@ static int virtballoon_validate(struct virtio_device *vdev)
>  	 */
>  	if (!want_init_on_free() && !page_poisoning_enabled_static())
>  		__virtio_clear_bit(vdev, VIRTIO_BALLOON_F_PAGE_POISON);
> -	else if (!virtio_has_feature(vdev, VIRTIO_BALLOON_F_PAGE_POISON))
> +	else if (!virtio_has_feature(vdev, VIRTIO_BALLOON_F_PAGE_POISON)) {
>  		__virtio_clear_bit(vdev, VIRTIO_BALLOON_F_REPORTING);
> +		__virtio_clear_bit(vdev, VIRTIO_BALLOON_F_REPORTING_PM_SAFE);
> +	}
>  
>  	__virtio_clear_bit(vdev, VIRTIO_F_ACCESS_PLATFORM);
>  	return 0;
> @@ -1176,6 +1184,7 @@ static unsigned int features[] = {
>  	VIRTIO_BALLOON_F_FREE_PAGE_HINT,
>  	VIRTIO_BALLOON_F_PAGE_POISON,
>  	VIRTIO_BALLOON_F_REPORTING,
> +	VIRTIO_BALLOON_F_REPORTING_PM_SAFE,
>  };
>  
>  static struct virtio_driver virtio_balloon_driver = {
> diff --git a/include/uapi/linux/virtio_balloon.h b/include/uapi/linux/virtio_balloon.h
> index ee35a37280..d206f156d6 100644
> --- a/include/uapi/linux/virtio_balloon.h
> +++ b/include/uapi/linux/virtio_balloon.h
> @@ -37,6 +37,7 @@
>  #define VIRTIO_BALLOON_F_FREE_PAGE_HINT	3 /* VQ to report free pages */
>  #define VIRTIO_BALLOON_F_PAGE_POISON	4 /* Guest is using page poisoning */
>  #define VIRTIO_BALLOON_F_REPORTING	5 /* Page reporting virtqueue */
> +#define VIRTIO_BALLOON_F_REPORTING_PM_SAFE	6 /* PM-safe page reporting */
>  
>  /* Size of a PFN in the balloon interface. */
>  #define VIRTIO_BALLOON_PFN_SHIFT 12
> --


