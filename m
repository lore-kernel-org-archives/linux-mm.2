Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4770D4114C
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 09:32:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 592756B0095; Thu, 15 Jan 2026 04:32:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55CF46B0099; Thu, 15 Jan 2026 04:32:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45BE46B009B; Thu, 15 Jan 2026 04:32:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 36E8C6B0095
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 04:32:43 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DDB8F16025A
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:32:42 +0000 (UTC)
X-FDA: 84333683364.17.8D7C488
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id AB9AB1C000A
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:32:40 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LeyevfOw;
	spf=pass (imf18.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768469561; a=rsa-sha256;
	cv=none;
	b=GfIVux5O3/Or6RugG4okTCRF3EZzNHhozA98C9hE9NfAHfni3jVFFCBLLfhUjKPy3RPW3s
	euui6nUOSOYpQhT8cCSSbY3zRIf8wXo1sesRWlz873TAcdIVO73BMzQ5w5LT6oGK/uqilq
	9RvBZScoUJnElO8bvzXXUguU/oe4dvo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LeyevfOw;
	spf=pass (imf18.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768469560;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C4Jd2k3tJmH6usMx/hzIeIrNAyuq9j42Ypf29Ccd2co=;
	b=Pn43L6vrFfJdfmf8Goh4UFaqmRs4bvwmNAHsylGPNfOD7Tq5xj8KpmrnQAFjMWerZ7Y9zi
	iNCxXVyRuP+Y7Q9RY09/JLAZipn2Bb+/hEg29eAzFAOtZrKD/gH1PzP3hxapXDxDAaXPyt
	uK3jHjR5rTLGRDNVx3HEMfprLBEc7eA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768469560;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=C4Jd2k3tJmH6usMx/hzIeIrNAyuq9j42Ypf29Ccd2co=;
	b=LeyevfOwHDIGsrfXe9WHxt+oBhKtvDkP9J88zjs/3+H73+RvBXLTeEh1fTsHOj8HtbGuqx
	hb1lGVKCHyJCBLSfyuG4FK5kCygd7ShYS61i0TE4zkGGz9SU+I0VR2f09/892ZLtAPanaW
	a47QOMuqhJiwcJhvFGiKEreWRjt9FOI=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-412-DPCZXLDaMi6SmdA2J7N9SA-1; Thu, 15 Jan 2026 04:32:35 -0500
X-MC-Unique: DPCZXLDaMi6SmdA2J7N9SA-1
X-Mimecast-MFC-AGG-ID: DPCZXLDaMi6SmdA2J7N9SA_1768469554
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-430fcfe4494so706115f8f.2
        for <linux-mm@kvack.org>; Thu, 15 Jan 2026 01:32:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768469554; x=1769074354;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C4Jd2k3tJmH6usMx/hzIeIrNAyuq9j42Ypf29Ccd2co=;
        b=JQxuRw7s8Oxmv0vHbIKvQPlmMznMiqfrRvhMxIJ9rW2WV6Kp4iR07UiEu38uAqNLtB
         VpsiI8WT0fJQ8NbXdSeD30fvZL65HGZG/dQJwOKEtvZVOxOJpTS7Q/hLOt9+ucFTvSlo
         9vXeqXaQmQ/Icde+hNx4J/7QDd/FHxJty9O//Y0iBcWPdzsJh37YpwhOh0itPg/3qM8g
         UpCVCsAkePlYQyfJbB00CRDtMFN3569e/Gfr6p73r8jHvfLUgEqFwR0QrX6g6IyNJhJ8
         FpggR4mbyvjUXVd858p+rSV+muQ1lqmhmPxnGSNZZL19MaRbf1Hn5gnmEYLUAAPfFc+2
         5rHQ==
X-Forwarded-Encrypted: i=1; AJvYcCXKAx4WIPcOkJckOU3PLAmr/XtWt+dU1UJnwiLBaPAlPCDb6T3pVNeJkEn0Nr1rI8M9HvzBmgLj8Q==@kvack.org
X-Gm-Message-State: AOJu0Yw7STpu2ZBWYNxA67qtTYirHj4Pm7vO+kqkaDtZH0bT4yQZJ+fg
	90ahRjwjuzAalWur9XT134RgZynDz+OJVo3BLhBYy1A8biZibEBI2NG5c5HvIOFsjMHrOcc+kbT
	IMPMipv7/NFFlvT3jCOwjYoiSNIE+x/hN2FVYV78FXw3jTskocPf2
X-Gm-Gg: AY/fxX4Dtdo6FpkOqEFqhexcqxbnQZbFtHIz4Ob7RbvLSZhB5Aio0pwEI1f1ntfHaRh
	I5lum6n7ccX8NpA6Jq8Nn7h+s7lBwSFrjHZcaPZVpDgnKCar6bK7DLnRnuk5Xj0ioGMPbpEi5U9
	XL2870yeT1j0PpjAFaIuhUSofy83yGZ/5ZNt2g/oc/J6Tc7mSzjsakB803u9KUEY0PXd//a6G3A
	NrxjSaexvG7nAxiLEaCGYZjRCgDEfBo7k6KtDpEDQLTMRiMWK95a03b0cOpS/xGQxGojpd2jr8c
	C8uKnIpb72fL285B2SZtib2NoZACBDPGQV4m64+41zPSO6xdkNmupGw/jxGSeqq2XxymmP0TH7c
	TTqPHebylSsdYyP0ExjklEg6WaOihdg==
X-Received: by 2002:a05:6000:402b:b0:430:f41f:bd5a with SMTP id ffacd0b85a97d-4342c5727bamr6648834f8f.57.1768469553966;
        Thu, 15 Jan 2026 01:32:33 -0800 (PST)
X-Received: by 2002:a05:6000:402b:b0:430:f41f:bd5a with SMTP id ffacd0b85a97d-4342c5727bamr6648783f8f.57.1768469553541;
        Thu, 15 Jan 2026 01:32:33 -0800 (PST)
Received: from redhat.com (IGLD-80-230-35-22.inter.net.il. [80.230.35.22])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-434af65f649sm4794185f8f.19.2026.01.15.01.32.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jan 2026 01:32:32 -0800 (PST)
Date: Thu, 15 Jan 2026 04:32:29 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	linux-doc@vger.kernel.org, virtualization@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jerrin Shaji George <jerrin.shaji-george@broadcom.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH v2 23/23] MAINTAINERS: move memory balloon infrastructure
 to "MEMORY MANAGEMENT - BALLOON"
Message-ID: <20260115043136-mutt-send-email-mst@kernel.org>
References: <20260115092015.3928975-1-david@kernel.org>
 <20260115092015.3928975-24-david@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20260115092015.3928975-24-david@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: S-EZwGP0mevyEQKEORA3a9DMzzrrpS1IlnGFIt765oM_1768469554
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: 6g3da1bd5bhxmhu151b1m1bpd17zea9s
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: AB9AB1C000A
X-Rspam-User: 
X-HE-Tag: 1768469560-797318
X-HE-Meta: U2FsdGVkX1+2xC5cG6ElPWrG/oj0gHNo+DejIqPjrIr69D2ZvLYNyxk/UD5+0pUfDE/B/vq2Yw8qq0YYkFnraEIk0CdXoGgf/UKDP2NLqkvicoRNy5a6KyXGc7q6pT3pvgsfNJdwvnP+KYz7Hfjo9aRTVYIfkztXBLw09yw4VbLwyxd05s/KYg6/EZ5cWTCv1ea0lF4BcJX2H8mrG75wYDkr2/GxVPgUQ9oN0n78YdEzAH88wdestJarK5YInIJFuP0T5K2Ycaas5Yd7gKme0hVUR3ME6ewIV/hzrWMLdyr2lwnvS1FZKxggEV0Jk11X1YIGj5duLav/RX+cvK+kyxj+ja2q6rL2pzEo/HD/i/QCSsQeWu2v2Ooolv7+YCMqnoxUrJQkqGWyt0l5bZi9En7LwQp/xkNSlCL8ZpR9N3Ir2Ejo9nAgKdlUrz+vEqAgdqDrdImZ/Kr88jTkoQxI7d1Q1//TNT+VIhPuzHL1vIqwGyTVE6w52qO8OnZ48UMYoc+hLPOa0fmEGoICATUNPRm7uwMLxbCr16rAAY2JQSvCj0S4JBjMBE4OB1RUnD+6ct8TndgH/d4ZvnHB0hwC5eKn29uqYYptxtiFhlI1qFhNbi0IJ4T+aqKZDDAfDGuJ8xKsTAEwXh3pzWq9qAKNzQd2BmUGOxC+ndOlzTMa/qWN7PzXH1zYvtrl6UDoBGuqJkaHn4JIcOMFpn8TaFv7vI5QsQiU4jBgC31Kd6x5mYepRqZxK6C4EnpN7gXQ6Wbk8EyQPuxxhU22/GxlffbtgBRsNHJesWB/8MAA4yZvRQN643ALDSHHU3I4D4ihOk8kuujLnOaEwbvHEZf6Mkl3r3Xivnwlbx60wLG0zL/VzRxUgHyyt1g2PEKCLmNoNfK5nKNxWTtoWuuiHS1agtlAVbZ6o14pKfE4YP81fq71RLRgOiiBleMIX3uzQrKswawRQDOTgbC/M7o6r09ahye
 BurXEf/b
 r2PMhzu05wwZVyeqHq+ijU86q8PY3M7yT0QC4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 15, 2026 at 10:20:13AM +0100, David Hildenbrand (Red Hat) wrote:
> Nowadays, there is nothing virtio-balloon specific anymore about these
> files, the basic infrastructure is used by multiple memory balloon
> drivers.
> 
> For now we'll route it through Andrew's tree, maybe in some future it
> makes sense to route this through a separate tree.
> 
> Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
> ---
>  MAINTAINERS | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index de8f89ca1149f..b974f8c1c2225 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -16454,6 +16454,16 @@ T:	quilt git://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new
>  F:	mm/
>  F:	tools/mm/
>  
> +MEMORY MANAGEMENT - BALLOON
> +M:	Andrew Morton <akpm@linux-foundation.org>
> +M:	David Hildenbrand <david@redhat.com>
> +L:	linux-mm@kvack.org

I'd still like virtualization@lists.linux.dev included, too.

> +S:	Maintained
> +W:	http://www.linux-mm.org
> +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> +F:	include/linux/balloon.h
> +F:	mm/balloon.c
> +
>  MEMORY MANAGEMENT - CORE
>  M:	Andrew Morton <akpm@linux-foundation.org>
>  M:	David Hildenbrand <david@kernel.org>
> @@ -27536,9 +27546,7 @@ M:	David Hildenbrand <david@kernel.org>
>  L:	virtualization@lists.linux.dev
>  S:	Maintained
>  F:	drivers/virtio/virtio_balloon.c
> -F:	include/linux/balloon.h
>  F:	include/uapi/linux/virtio_balloon.h
> -F:	mm/balloon.c
>  
>  VIRTIO BLOCK AND SCSI DRIVERS
>  M:	"Michael S. Tsirkin" <mst@redhat.com>
> -- 
> 2.52.0


