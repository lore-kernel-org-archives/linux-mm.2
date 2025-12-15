Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54C94D5B868
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 20:42:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5D576B0088; Mon, 15 Dec 2025 15:42:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0B056B0089; Mon, 15 Dec 2025 15:42:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DF0E6B008A; Mon, 15 Dec 2025 15:42:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 71FE76B0088
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 15:42:04 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F225856FBE
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 20:42:03 +0000 (UTC)
X-FDA: 84222877326.28.8226C05
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 85BE910000E
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 20:42:01 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QYINGqbb;
	spf=pass (imf05.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765831321;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vIugujDFg05cEDjSFPsNuy7/nXwlnSCGQEq9oeQZt8U=;
	b=SjKOz9JP3rqE+ol4xstsJq6obemm8j4XXQglH+Zg21wckwIG0E2VFMYdUwvZfFFxBytpZo
	JirHOJUxkfx4Rdk7YhOedHHwMtBlB23n5lFaqnilaQh/dPCx41C/vU1VCfbzzi5T7p0shR
	2+xLPAq1t8+8I7Pidhoz6wpjV7oO19U=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QYINGqbb;
	spf=pass (imf05.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765831321; a=rsa-sha256;
	cv=none;
	b=qJOnwZfd5MzjGl/BonPBlhr7jE0F9ceXSeUCFJtPV4pB277mYXoaX8uvVAaTrPA/WOSwi3
	Wq40WSqNH32TPnRUOzONGubpKc0s3IHONr6NiFuIEmU4qDP+5gXRLkY3FnOegmrCWjT5Xq
	lkfoX3/Uc3x3miNrWDcmfCqE+da99Fo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765831320;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vIugujDFg05cEDjSFPsNuy7/nXwlnSCGQEq9oeQZt8U=;
	b=QYINGqbbRc/FUPodLAsCOdI6iNJAWOz0cigxmje7v9iWY2vLYqh+36mxn5Y5flqd6pqz7Q
	KThVt3n4fWMSeeREoC+OK4qOLZvpPJorz6TWmltzE9jEw1AlT0V4F5jCrS9JShHdvJgRj5
	Y5Ftn3TVUE0L6Aa/NL+XTp0JrK0Vumc=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-128-gocGmutVPDCRFXZxef_fyA-1; Mon, 15 Dec 2025 15:41:59 -0500
X-MC-Unique: gocGmutVPDCRFXZxef_fyA-1
X-Mimecast-MFC-AGG-ID: gocGmutVPDCRFXZxef_fyA_1765831318
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-477cf2230c8so37539395e9.0
        for <linux-mm@kvack.org>; Mon, 15 Dec 2025 12:41:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765831318; x=1766436118;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vIugujDFg05cEDjSFPsNuy7/nXwlnSCGQEq9oeQZt8U=;
        b=Dlh2sBECBKSBoO6CzwgJzwAlL8zNf8PAJW41g+D199gX9OMtm7/3YC6dhvsXLKaOB9
         synu7Xz67LiEuuhW6ZNffuMlJ66VeL5avE27LOGC9CAKzOAHbDFbjYgfKInE8vkiGQp/
         S3rth38XQsy6d2v2Ubs8FZd08d0ZRIB4IdNN6w53DEQYdTi9IutELkdZiO6XH/luXWHF
         8zJD6LyTyY84GPo818smYEz0rmuy0X0nlnGuyJmPR5aTe98yMiwvOcy2Rc8otNVfFa1Z
         d04qD4psFE+3v4y5U12kZN0MHzu9y5cg1pYadDg6F38vgoRKaqCU+Y2GhEC3jLY4Xz2J
         mnpg==
X-Forwarded-Encrypted: i=1; AJvYcCWDS72Nl2T6qpfvp8hLDl8X2klGwmxUhpEPt1/K140XGb/B6j7BOCNxIYW3soEeWvF5AQkCqakNQw==@kvack.org
X-Gm-Message-State: AOJu0YxOP9lBvx4BHfgmkY+GfJIgvKIWD0rrFevVwxpPesaBrkLZHPsx
	mnyKXuPHANvnZnj54fBTjYV39rewDiLPXK9WNg6zDnqK5fojwmwG0BFYLqK/xq3tfG1vjQ6dc7H
	/TpVmpE4lUZhHyKOyGjqSglq3LNsb+2bmMIS1qZSs4/+EZF8CO/VX
X-Gm-Gg: AY/fxX5xi638oNuKHh0RcEZv8MyExDpy7ZJQy79JiFvnTcbYkADcyDI/PJ6xobKigvq
	/WGas6dKIbVey+gU32gVMOk3WWNRU2QrrfjahXlJjBtHj9x2sqMKTlI968umOJmlP6eqmGt3bU7
	Hh/jLQWwI1kx++4qICrPggCcQ25SbpQDABk/N1Oz9tUmK3wBS9eR71rYLbaxfoV8dEusH5YhGlW
	reSmvc6DkZ/J5Acix3GUUKpjSlwHwztRv1o5aJrbLUEzdigJTUIYmqWkQsLVWQUwP7Z61VA1N5t
	3JmFAGx11y1wB/3skz8uLa6Pr4VL7n06vU2hxcI4WKufS+CwzrXOE4I9wCg9JmxvHTJVVE8/pdL
	0RPPleUDTLcmy1aNrOEPl7jhEAcCjA0nbIw==
X-Received: by 2002:a05:600c:6290:b0:477:76bf:e1fb with SMTP id 5b1f17b1804b1-47a8f8cdfd1mr164694925e9.16.1765831318234;
        Mon, 15 Dec 2025 12:41:58 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFpvKxyv9KrTZN+I+gLKkWZxXPblkRG4VaB9KOKEG2SIjVVbTsH1HJ4pcy9Q9bDzIs00zZydQ==
X-Received: by 2002:a05:600c:6290:b0:477:76bf:e1fb with SMTP id 5b1f17b1804b1-47a8f8cdfd1mr164694005e9.16.1765831317597;
        Mon, 15 Dec 2025 12:41:57 -0800 (PST)
Received: from redhat.com (IGLD-80-230-31-118.inter.net.il. [80.230.31.118])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47a8f6f26ebsm211656485e9.14.2025.12.15.12.41.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Dec 2025 12:41:56 -0800 (PST)
Date: Mon, 15 Dec 2025 15:41:49 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux AMDGPU <amd-gfx@lists.freedesktop.org>,
	Linux DRI Development <dri-devel@lists.freedesktop.org>,
	Linux Filesystems Development <linux-fsdevel@vger.kernel.org>,
	Linux Media <linux-media@vger.kernel.org>,
	linaro-mm-sig@lists.linaro.org, kasan-dev@googlegroups.com,
	Linux Virtualization <virtualization@lists.linux.dev>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Linux Network Bridge <bridge@lists.linux.dev>,
	Linux Networking <netdev@vger.kernel.org>,
	Harry Wentland <harry.wentland@amd.com>,
	Leo Li <sunpeng.li@amd.com>, Rodrigo Siqueira <siqueira@igalia.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Matthew Brost <matthew.brost@intel.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Philipp Stanner <phasta@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Taimur Hassan <Syed.Hassan@amd.com>, Wayne Lin <Wayne.Lin@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Dillon Varone <Dillon.Varone@amd.com>,
	George Shen <george.shen@amd.com>, Aric Cyr <aric.cyr@amd.com>,
	Cruise Hung <Cruise.Hung@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Sunil Khatri <sunil.khatri@amd.com>,
	Dominik Kaszewski <dominik.kaszewski@amd.com>,
	David Hildenbrand <david@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Max Kellermann <max.kellermann@ionos.com>,
	"Nysal Jan K.A." <nysal@linux.ibm.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Alexey Skidanov <alexey.skidanov@intel.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Vitaly Wool <vitaly.wool@konsulko.se>,
	Harry Yoo <harry.yoo@oracle.com>, Mateusz Guzik <mjguzik@gmail.com>,
	NeilBrown <neil@brown.name>, Amir Goldstein <amir73il@gmail.com>,
	Jeff Layton <jlayton@kernel.org>, Ivan Lipski <ivan.lipski@amd.com>,
	Tao Zhou <tao.zhou1@amd.com>, YiPeng Chai <YiPeng.Chai@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Lyude Paul <lyude@redhat.com>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Luben Tuikov <luben.tuikov@amd.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Roopa Prabhu <roopa@cumulusnetworks.com>,
	Mao Zhu <zhumao001@208suo.com>,
	Shaomin Deng <dengshaomin@cdjrlc.com>,
	Charles Han <hanchunchao@inspur.com>,
	Jilin Yuan <yuanjilin@cdjrlc.com>,
	Swaraj Gaikwad <swarajgaikwad1925@gmail.com>,
	George Anthony Vernon <contact@gvernon.com>
Subject: Re: [PATCH 06/14] virtio: Describe @map and @vmap members in
 virtio_device struct
Message-ID: <20251215154141-mutt-send-email-mst@kernel.org>
References: <20251215113903.46555-1-bagasdotme@gmail.com>
 <20251215113903.46555-7-bagasdotme@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20251215113903.46555-7-bagasdotme@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: MUR3EFxF1_38oR-qj600LJ7524rreBoiRFvJPDkvEjw_1765831318
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam02
X-Stat-Signature: 9zmufu13x7gtp1qsmkqur1h96aam8duz
X-Rspam-User: 
X-Rspamd-Queue-Id: 85BE910000E
X-HE-Tag: 1765831321-700900
X-HE-Meta: U2FsdGVkX1+94l/eoOBeFAFl2viZEytMblsZXuuNa85TI1pCEJfSq6LvQbYLW4nyRuze21Va/xMYvFtSYSO1sYGM0w2aMFLo9eu63Vv4JTZywgmpNGCYAd2OKrRiKUH5CPP3OO+qJxnCeF3LggyX+Xr7l+wZ6s/xBu2KKlJUcxGmXCwTVWEbE0lnXBVkOkPx53zR1ffqp6BAvLTIJ0Ioln4gfLz8D7trlLWVBkZMzJC968t4PZQl0BbtXXZdnjq3Yxskk778dfCqoTkRRIcT8qAQd2CF9bYsJPVlsVBaVCFtmE7WlOgINVl3/857pyqU/jykKPjlUefuz85ToLSWahxlFQ52zoCUdEiA5utA4IKvlE1i1MYEykuYTtfBFP1YLuvqaK+ro0ezX+FRIV0g59nbtx6k1BVmbyMHNjfgo3SkKC3e2AnDfdhmK4cVJUuM+wrZtFg43lZByNRt15+GFd0RVtIHMf9nhXlx5FaQVKlq2kNtev0PxCC+QKWmp4AAwzYOfCF3ZdQOC+TxprvBtIu8VbW/MJmixWtB24nAnM0wSkhfYCUgS0Z9xh2REuLnXCbaidgqyeXrOMKmfGgNdKhqnVM2eL3E2LFsXbtzRm5d8vrJTwsQ3/MQChqAYTbAuTQfzHNYiq91n5GWh9e9Zivtk5p/s6a4sX0I91SqYQWVk/kTV3rv3OaSHEPkEgESJk3fbEjrU0MeADHhJDhXJUrCJeI05qrHwPK1u0lR9L2NS+hIIHugynU8RsGfmyThNbyvLJ7hYrSY6I9ElxW55U7u0McVc0yBKcL+JWoFapsDm8BNQaUwVybSxqxkrIGb4DkkZdDPOT5y9Su41Tu5Q9skw7cDZvd6mp2rYzc6b4xQplcwoAm+2h310hDQJWDOX8dOCZSkJMM8QwUCWlMNcpMIZtyCkIhqHn5HpNfOYN+Kd0uotifpyI1t0abMEuZrTuJdiX48IAuZThhHFh2
 8rBsWuqx
 1JhL2ERaCrqHt53ZNyP5kSX8RkgX5z/XbBYUesRCUF0i4NOOdhanqyjKqFs2oROjY9BF6LoIrkt/EQdi4jgxw9ivhP8se91EXutm+129Z0WgJ2Td8piutlgSEXgfffv6pKwzV4dG6PRnFHFOOOWfAGKZ1T2nxbaVLNNs+U4oBJzsAjwCxVrpP21IFjYrL+Bvqo5tExdRzVng0i5TyIYJYMvXqVxTZCsaYK7Aq48CjSvnMNHQLW43z2n8csf33mlfy3/KYpxS7FVl+YGo7CFeuGIx3P3/KfWypf1GiZmwfR3FwmjNpyo0wMw1RHMVRe4ZLgXI10HcHDIchBRw0AtDbXSsbIi7vubrJcGLAMP6lWfTSZ06dXa422+44AW1g9AWfo1d4olG9zg0MZRRmDDMvttTcU1wjPQbBpZ8v8C9xQha/wjroP2+tc3IgyQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 15, 2025 at 06:38:54PM +0700, Bagas Sanjaya wrote:
> Sphinx reports kernel-doc warnings:
> 
> WARNING: ./include/linux/virtio.h:181 struct member 'map' not described in 'virtio_device'
> WARNING: ./include/linux/virtio.h:181 struct member 'vmap' not described in 'virtio_device'
> 
> Describe these members.
> 
> Fixes: bee8c7c24b7373 ("virtio: introduce map ops in virtio core")
> Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>

Acked-by: Michael S. Tsirkin <mst@redhat.com>

> ---
>  include/linux/virtio.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/include/linux/virtio.h b/include/linux/virtio.h
> index 132a474e59140a..68ead8fda9c921 100644
> --- a/include/linux/virtio.h
> +++ b/include/linux/virtio.h
> @@ -150,11 +150,13 @@ struct virtio_admin_cmd {
>   * @id: the device type identification (used to match it with a driver).
>   * @config: the configuration ops for this device.
>   * @vringh_config: configuration ops for host vrings.
> + * @map: configuration ops for device's mapping buffer
>   * @vqs: the list of virtqueues for this device.
>   * @features: the 64 lower features supported by both driver and device.
>   * @features_array: the full features space supported by both driver and
>   *		    device.
>   * @priv: private pointer for the driver's use.
> + * @vmap: device virtual map
>   * @debugfs_dir: debugfs directory entry.
>   * @debugfs_filter_features: features to be filtered set by debugfs.
>   */
> -- 
> An old man doll... just what I always wanted! - Clara


