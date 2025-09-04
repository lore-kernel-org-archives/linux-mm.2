Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD836CA1013
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 21:38:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E55C68E0003; Thu,  4 Sep 2025 17:38:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E06718E0001; Thu,  4 Sep 2025 17:38:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF4D48E0003; Thu,  4 Sep 2025 17:38:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B850A8E0001
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 17:38:39 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 53AC213B399
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 21:38:39 +0000 (UTC)
X-FDA: 83852882358.21.4C4AC2B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id 28180140007
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 21:38:37 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YonimIRa;
	spf=pass (imf09.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757021917;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9rHD7plJVEZkv8PkFJEx5BeBVBt5QFBtzvV5bLJfU1s=;
	b=nz9STv4QwA1Ym+kfvOxpYeJz2/uNMY0Sxv40zo31p6VMLhsomdpIEAAo88kqhkK1EbS5WZ
	CP4wgxGLJ/2tk9PP6r+OMa2E++8TeT7WhIzSAWytv0dBU+owxLGr1qv8Bi0/5kxq+AuvoB
	dIB/8QfpQ8bj1eTUhmImtI2+DR5H3eI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YonimIRa;
	spf=pass (imf09.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757021917; a=rsa-sha256;
	cv=none;
	b=d2uBVtu+MdVQTVNoOwFEIlH4iZaFs4v98IT8iS8+lGmXcAFWz0YvuAmPeXaeLefCiqurVo
	HSlRIzs6FbFw9gurYfFZ3ftHMl3UfUtlOkVv0shsm2QqDKhCT8MNasukaHfg/s9GHG37tz
	sXbUMLar/Fh9Kcolm/fiALpoY8+HUrs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757021916;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9rHD7plJVEZkv8PkFJEx5BeBVBt5QFBtzvV5bLJfU1s=;
	b=YonimIRaQfmjZmONKBCfD6uIUf72F7UeUjgj3gOSg/Y+tQDZew2Of2aKrFfKjJoUwkVtGU
	CtwQrj0Yg6Fccrt15AocknIp7VJ4OTOA2l+CAiOi9/Fnik8vGSLbmhjPHG3rtZgsCCMaq+
	KMWT7TwKChngPxKZFUtIPehdExsTFmk=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-199-4TyeOn_cMU-vsEp3BzXLIw-1; Thu, 04 Sep 2025 17:38:34 -0400
X-MC-Unique: 4TyeOn_cMU-vsEp3BzXLIw-1
X-Mimecast-MFC-AGG-ID: 4TyeOn_cMU-vsEp3BzXLIw_1757021913
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45b96c2f4ccso8174465e9.0
        for <linux-mm@kvack.org>; Thu, 04 Sep 2025 14:38:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757021913; x=1757626713;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9rHD7plJVEZkv8PkFJEx5BeBVBt5QFBtzvV5bLJfU1s=;
        b=NALTpkvEbN+AgYbuOJvp69baOXQqRiKWr3XRHoNHEFuyC2prBF/IR0UkGuEwdOX6XV
         e+uZ57yo9aebMwsUk2cuIjUsB5yZDWPHfWZ71imi7RKkbEhor2QNH2cUWi4HAjgMy5V4
         QCPupKoIRNRRjYZpG2ySPRzJIlPI7uMLLmN9WZUZ47nsTUgPwMha1sid4dOFw+ItsahT
         aDaZFWScBK1lTCX2aKNHXQE3x4V1isA306C783D58y13p+0pu19tr5zzE0IrojjKJKe4
         s+lcWYUPAloyvEhjhLnbmmorM4WepoWljtizXDmwj5T8w0Zvj/HJGHCkBVYv1MkuyrTO
         uYTA==
X-Gm-Message-State: AOJu0YwXlDaM4VKMvzn9OWSmgptP6R5xqc7NFfrW261Y9tgf+AG82nxc
	8IRBV8zL0R7NhUxt7OFEuhVby5Y74cjxrrLR4AzJUal1ic4vMeUJ3YX0J80jGgI01LmYKnGFTKf
	jOSeKqH5auLt1xImlX4rDYNO+V58JLtwTK9Uy1E81stgjOfuy1Bzh
X-Gm-Gg: ASbGncs40m6ELGGMv+aO0S7KESMfcMyHdzcsblx587gZdoc7WjhAmMBVDgtPDKLkxyf
	0WoyQQqeEMicBlOu3w2a9GjPsYX4qJnNLdcZU740uAtBwMIcAb6NSmj93AZhxAXLHNZ7NJXE5U1
	H0GuPX3B5Snd93vTbeHEFeKtBMKth+aiFHlFyCHbBExJO44pnSex3704tXEpdLXVZiWn6x1CXaY
	C74u8k9ZHDN+OkPCrR3PI7vacdt6ZBbriViOIsJezOrlr9Uw9rpCNbAkYYu/Qtp0Zdsxuw0rsId
	pH9BDejMrBQ1qGlEvnmlbdDu+rIrW2vvrbvQrQmG2wrwOKKJfSmHW1Iz+TFNLpoXvA==
X-Received: by 2002:a05:600c:1d10:b0:45b:891f:afcf with SMTP id 5b1f17b1804b1-45b891fb24dmr144597845e9.27.1757021913368;
        Thu, 04 Sep 2025 14:38:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFWbBDlkpyRRxeIt/+qH4VagktWDBCJazVbSXDHRMhx/diXSZUFSBaQ6M24PtRDNYL0yu7m/g==
X-Received: by 2002:a05:600c:1d10:b0:45b:891f:afcf with SMTP id 5b1f17b1804b1-45b891fb24dmr144597725e9.27.1757021912965;
        Thu, 04 Sep 2025 14:38:32 -0700 (PDT)
Received: from redhat.com (93-51-222-138.ip268.fastwebnet.it. [93.51.222.138])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cf3458a67fsm1872200f8f.62.2025.09.04.14.38.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Sep 2025 14:38:32 -0700 (PDT)
Date: Thu, 4 Sep 2025 17:38:30 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-block@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
	linux-efi@vger.kernel.org, virtualization@lists.linux.dev,
	David Hildenbrand <david@redhat.com>
Subject: Re: [PATCH v3 7/7] virtio_balloon: Stop calling page_address() in
 free_pages()
Message-ID: <20250904173824-mutt-send-email-mst@kernel.org>
References: <20250903185921.1785167-1-vishal.moola@gmail.com>
 <20250903185921.1785167-8-vishal.moola@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20250903185921.1785167-8-vishal.moola@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: lKserBZzOkbpBIB5pq8s8s9CXJb8EQGhq1ixv-FnyGA_1757021913
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 28180140007
X-Stat-Signature: horb3fgjymqqe8sjcb196fur59z379da
X-Rspam-User: 
X-HE-Tag: 1757021916-196733
X-HE-Meta: U2FsdGVkX18jyaWeo3OO6wz5F5bI4WYr+wUUauMi293IeWlLxJdpxOgLuHYZ59bF/Xwc0SGcgKDIf5nZaxqxRle9SC/5MTRI05Fa3btNnx2Mt7T6+dJDu22Xw+3XsJ0zddeE8YlYrsbeR6rOhKRQd24s2LcepgVV+DxWjnfBT4UfhU1D1NLjSm7+95nt0d5qoqCQiVCRMPxJNa0aMP9nGphc7/3rvMtmCj0V8EnPjE3vCQ6NstgZNDsWolEnO+3keyS99l0/yqvieXWkBpiUnIwFjK4Gk0ZzwA4Fb1IPKrnni0ZAnz9R8thNrsZ2J6lwP2MHuL3VT25i3Aw68QymHBw8+vBVpzPBYitnh2H1chzyXcMaT8zP1ti0h4r3QJUOKIYoEhre0Pg9Ja+d3F6q7r2xf1f0T006oUDAFPXAuFwnXttSbnWqpIDmGBQ+Ov/GRJuxZpF78/QPqgmkcMOr0IcwnZLfL3yo4uiBfqfwyhjjVQo3tIHCzmBkuR6md+vpRcew7GmNFqfgMqPicVRNj5Hiqg25mQ44Shfga9R1FY034iqBXoAkK02VEu/IEZJmPsKFwuM4d7Kbc5XWFt9NSjFjGKfFtl988ceHYuURBzZnY6GuKbl46/RgDLoUO9CHK9pKBoIZjocPAkprV94L9Qqi7F4Mtitgx3pGe4rT6MNNpZ3BD25PHSonVFT411cndDfzFKrbCP0C0/x3scGheybgLCMFMuiiO7uPNbJ6nnuGanxgHQ1e1BnFmfBMUz5xlf7D2qEEbjtNTAxzkmXJBiKSLA9nWYMjKtPpxHaA/tadSRKMXmXDSislVOSOp27Lq64CGTLsr7WfmCD+D4/HZxG41T1L3VH7YrNj/RiQeLUgqk32sCOod+HvRck9fBaJQcJH09fcqz3j1Od2J+bs9BmNQep6yc8ADD0lpm371tTZ6TO4qF/ucf/9yAGPEhu8HxJzKg8NHb9PsC+Vcy+
 GvWFTNZK
 XtPxJNr1VsTEuj5MMdDzbxxyJlS6oPqw7EQYYqA5x2M8M0kPUhX9DcwHhLGNoRY1DGLL1GSxv0c+UHsT+o+7mdJptG0uEst+NdYaed4AD1j4IXdZrZozhmkbPsHYaPyELBPQY718EQEG0A/T/KgfzcDvHWud7mN45XCtgcZOsCPvnmb0z83TpfQ1K8utPkJ2RnIbdYCdEoV2E7w7hzxeTCeLSESI2jOibvJmAqBQWfcvXjBgocqV1RQ8BdWnyRBRlZm0b+6XavfykWiP69ZWd9m4U7RxodJIIQa66I3tkpdtlAYBSzsfO7/FpgtJ5PzTXvt/qW3QCI12yudw3MTxqzqtg+vuGGEVivE5M9W0DFYbnAdEGheS/AaT8jApAV36LxPLjy8z7exxn788b3aQ7HsJDAy1XR0xKIKOTVUIa5O1TNqhZliKkE7E4fg4UGyDwBDlV7EFLpNjMelBikiYKW7gd+XRqM5Lb9BTXX8qXyPl3Iy+5O6wNbyisbZ7xmkrdvgiR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 03, 2025 at 11:59:21AM -0700, Vishal Moola (Oracle) wrote:
> free_pages() should be used when we only have a virtual address. We
> should call __free_pages() directly on our page instead.
> 
> Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>

Acked-by: Michael S. Tsirkin <mst@redhat.com>

> ---
>  drivers/virtio/virtio_balloon.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
> index eae65136cdfb..7f3fd72678eb 100644
> --- a/drivers/virtio/virtio_balloon.c
> +++ b/drivers/virtio/virtio_balloon.c
> @@ -488,8 +488,7 @@ static unsigned long return_free_pages_to_mm(struct virtio_balloon *vb,
>  		page = balloon_page_pop(&vb->free_page_list);
>  		if (!page)
>  			break;
> -		free_pages((unsigned long)page_address(page),
> -			   VIRTIO_BALLOON_HINT_BLOCK_ORDER);
> +		__free_pages(page, VIRTIO_BALLOON_HINT_BLOCK_ORDER);
>  	}
>  	vb->num_free_page_blocks -= num_returned;
>  	spin_unlock_irq(&vb->free_page_list_lock);
> @@ -719,8 +718,7 @@ static int get_free_page_and_send(struct virtio_balloon *vb)
>  	if (vq->num_free > 1) {
>  		err = virtqueue_add_inbuf(vq, &sg, 1, p, GFP_KERNEL);
>  		if (unlikely(err)) {
> -			free_pages((unsigned long)p,
> -				   VIRTIO_BALLOON_HINT_BLOCK_ORDER);
> +			__free_pages(page, VIRTIO_BALLOON_HINT_BLOCK_ORDER);
>  			return err;
>  		}
>  		virtqueue_kick(vq);
> @@ -733,7 +731,7 @@ static int get_free_page_and_send(struct virtio_balloon *vb)
>  		 * The vq has no available entry to add this page block, so
>  		 * just free it.
>  		 */
> -		free_pages((unsigned long)p, VIRTIO_BALLOON_HINT_BLOCK_ORDER);
> +		__free_pages(page, VIRTIO_BALLOON_HINT_BLOCK_ORDER);
>  	}
>  
>  	return 0;
> -- 
> 2.51.0


