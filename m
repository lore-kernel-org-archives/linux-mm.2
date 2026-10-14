Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 008CBC3DA7A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 18:15:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F52D6B008A; Wed, 14 Oct 2026 14:15:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A67D6B008C; Wed, 14 Oct 2026 14:15:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 895596B0092; Wed, 14 Oct 2026 14:15:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 68EA16B008A
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 14:15:22 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EE89C14022B
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 18:15:21 +0000 (UTC)
X-FDA: 85322034042.08.3789A6F
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0C13F40003
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 18:15:19 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=iW7exucd;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf27.hostedemail.com: domain of lrizzo@google.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=lrizzo@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792001720;
	b=J8z7jC0GKxAc+Ldt9Uu/5HyadfeS8Dm5PXPEFqHCqdPetlKGsLbNTjqWs+2OlVkun9Hf7a
	trBbU0usSIlx5ftNlPhaOrKLxcW2fIkSeFYlmIb+Tr+zR0h44bxgSnIflYRTuOOkZRQ3x3
	EGQYYRJHE0ZFpqosas0NnfE8kCazbf4=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=iW7exucd;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf27.hostedemail.com: domain of lrizzo@google.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=lrizzo@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792001720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ukWxxq7IJoiKFikFQrOXvwgn9jZTFnVv2R6ijBLFQBc=;
	b=dCBcX+UZC6Ax++AnNad/R4L3eB+yi0LiDnSMda+XVHHmk3kF6kRt7l78r6LgTO++XA9bpN
	TlrQy1io3zr9QGg+M6ae9T9vm0bwef0pxYw4HOf8jcKL+Z0diA0m8Au3XylOs8boymQgDv
	YGq7mGt14/DTP4xo6UOLCHAzevwygCs=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2d8fd7a3f38so253945ad.1
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 11:15:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792001719; cv=none;
        d=google.com; s=arc-20260327;
        b=W9V2Y0nMzRKrL+EjgrQp/pFlZ29i+uYEh0EZzhYo8tS2djDQmhgGOU0nGhHPvcfuB3
         7p3Ics28jqt66ADnIGaz1ADtiGTHHUaCndtnMDoM/hiT9hZq2PSFu5J9pujVwTX3bxQu
         AumPxeZIVoCq3ZP/L3xwfLdpupHCfP0vJLCevZpvcNlYg5gvpH7e+K0uXj0ZWc14F9fK
         GRvZJOSlunVAFh6Yr2w13EQhUl5BdB1rCHUoh/EEGSx2bT/Tex7n4rSoBkqyzW/0fVgD
         ZIbUgAPzPEH6u91UHJka8t/cJWn/VS4yDaHTLGi/udDaX06+EoeymyM+SHGajB8+MJmW
         5RIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ukWxxq7IJoiKFikFQrOXvwgn9jZTFnVv2R6ijBLFQBc=;
        fh=eBfYInRhDtaX+jqzaWDin7bxsO1Xj1d1pCGtVTfhoGU=;
        b=MyHyMy0VYqGuHphFwulppUC7n5zgPJLt+vGUElTmQk1OWNLthZ4EF8R2Wu82AB2UZi
         c4vkKmWeXByaN4+jUuxljRubGgl86BQq0ACEUGYmrExUimetq5Pc82qi7Fu91TMwca5W
         9LzmBUnKvaN7hfI3D/T2Ar0gUoO39RAG81iehfA8YigFExpCkurT/888mjz19HFwITse
         W3akPjHcJnpCjZV/PhINSPEulHgHYso55giAqoyMpnS+oTAUmn9n4VTRks8UpSXd3ow4
         yS4lvbUM57lahXb1EjLb8N9cHfzhSSnFeFfQSX52kzy8LMEpmroZS3JeVM8Rtp6U7c2s
         YyWA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792001719; x=1792606519; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ukWxxq7IJoiKFikFQrOXvwgn9jZTFnVv2R6ijBLFQBc=;
        b=iW7exucdlHdK3WAv7CjRnJxbpy1LYZB4jJMR7miN71CSJvBjK+e1S1dBIsdHbIXozi
         O33rdpjb7C2cvCfB/2q3VGvNwaCsBGCvY2KhoHiwxC10rshxET7o0wqe6B6uj9JSeqSA
         s+Az++XrceZCchqYGtV4lpvV16KCQoJ86JFQSqT4HsMs1+yFnmiShdRgIwjDp+LXnBqq
         roYcg38sv7+XDSvyPLx4FiS1dCc43SgFNbHGnJllSv0ODm6J0+SatXWjNq4pbP+kFpK+
         6hKfgTMptL/KHaBe8N0YGyiu68wkTHyCLiwKdJDy9K+FolKSRruXULxVMzpu+ezJitAg
         WSLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792001719; x=1792606519;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ukWxxq7IJoiKFikFQrOXvwgn9jZTFnVv2R6ijBLFQBc=;
        b=EijJlsE7NADCbmjHlj8k0fpm5qO1FnZWYlmhN/tGGocHWtB2b3tEl1ulaz7dyiWToI
         EPImt9DXIoHMJ/doEYdQjnKdIWnxIf1H2tHV9wKcRAoCO8eg+V/cxdnUZTwhB/h+tJQx
         3VIPztfLXH/fS3Ox765JtfL7Z07kuVUFmDOl7emXa7LuPX6/1U9CcuVyJbNUO25Q98IW
         aCne4kklclKqiN8LydgKYwFdvrGPYj5ekukgaCLLgyFqY4l9rybPqqLl5EI41lbkRiaI
         1e0WQsu0YlU6Wm9mP8DaDPWvhf9Qv8kWDyJ25MjdK8fkZzrhJJBAZ5NgcJ9+dv79WM5I
         0mEg==
X-Forwarded-Encrypted: i=1; AKwUvBwzf/8l7KnY3UOzcBTdrolps3ThfPpKeVOV+ozKBBCbwlxqQ8Iw1eMks05V09MdL9PHCcc5hCxOmA==@kvack.org
X-Gm-Message-State: AFq9FYI1ulbubyDgwMonxKOIgB3rr3czEs7YY6XFm2qvqByJyboRRVpv
	n2OEzdEXI80ac6963cct4HPk7qimk5XTHTp1Nr4uleTe4JY3qbMdjE0EW9DJT7MSZt1yr8AvwC2
	rndQTzO8Nwsuc2l4CGmfIui0bfjnqaaJ0MKA1NAli
X-Gm-Gg: AYBFou2PohMLeJ6Z+rW3laBXtjGJrPesAh6i7UwHnZyDO/70mGKFn/hXhOB+ueWOgL+
	90q7WMOUoT8e+QcjBK9gMKQnYmB89znVlZ6DCxK4SzJFLV+/mCi4Acq2NCBS8Uz1RKWvlamr3QI
	lN6yy8xsSdSwZeVDfLhQxkVnOhI0d7rgPAbo1BtKVJI8wtfThVnfkGT6t+JgLA2DglPmq+78l6D
	n86idXYEEbPCqWp5MNmGp2ThXyfjZ5qc2lpu/WBf/e7I47ENOufc1jYB/S1R+Qw9dmrJT+FrAAu
	C7ShNtDjiWS+kCrkULIHJWDcfT8WL47+IgL6XJho9U/O3inQ11i/ANlN
X-Received: by 2002:a17:902:ec86:b0:2e6:1013:ad57 with SMTP id
 d9443c01a7336-2e939d090a3mr4279565ad.12.1792001718105; Wed, 14 Oct 2026
 11:15:18 -0700 (PDT)
MIME-Version: 1.0
References: <20261003212241.3432303-1-lrizzo@google.com> <8584c31e-fd93-4f1a-9929-e71c5d9ccd0f@nvidia.com>
In-Reply-To: <8584c31e-fd93-4f1a-9929-e71c5d9ccd0f@nvidia.com>
From: Luigi Rizzo <lrizzo@google.com>
Date: Wed, 14 Oct 2026 20:14:41 +0200
X-Gm-Features: AclHuK9G3FSCwwu9o-cWYwZA7nUn_K71LEEmvdGinw_0nCstr-Fs63NFljz-hj0
Message-ID: <CAMOZA0JiGhVmc0PXajBzha3cBY-sdc3pz8eLCCbt6=hmsEh65Q@mail.gmail.com>
Subject: Re: [RFC: DMA_PMD 00/22] DMA_PMD: PMD_SIZE-backed IO buffer pools
To: Dragos Tatulea <dtatulea@nvidia.com>
Cc: Luigi Rizzo <rizzo.unipi@gmail.com>, Joerg Roedel <joro@8bytes.org>, 
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, Christoph Hellwig <hch@lst.de>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, David Hildenbrand <david@kernel.org>, 
	"David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J . Wysocki" <rafael@kernel.org>, 
	Danilo Krummrich <dakr@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
	Willem de Bruijn <willemb@google.com>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Joshua Washington <joshwash@google.com>, Harshitha Ramamurthy <hramamurthy@google.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>, 
	Tony Nguyen <anthony.l.nguyen@intel.com>, Przemek Kitszel <przemyslaw.kitszel@intel.com>, 
	Alexander Lobakin <aleksander.lobakin@intel.com>, Michael Chan <michael.chan@broadcom.com>, 
	Pavan Chebbi <pavan.chebbi@broadcom.com>, iommu@lists.linux.dev, netdev@vger.kernel.org, 
	linux-mm@kvack.org, driver-core@lists.linux.dev, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: zraoedunt9fegkmxqmdkjuzf4g8f575r
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0C13F40003
X-HE-Tag: 1792001719-358230
X-HE-Meta: U2FsdGVkX18grkfdGf1Sac9UTkjRpF4O2TfI3K0H1EvpFzK91rhE7q76HLaEKIno8/t4H0avT+bq5zVWcu7jmNSqPOK5WFbz2r+fW6RPfQCZGDb33++3ajTsjLa6u6u/bYnxULqWC51y8FhFqaPXDN+v4MnomwiHYWeTnsLZ739rF+Rkc2LWqYQc8zWjSclSyE9wI4lTmvUBSTbcjax81dyglNI4WuC61urUGv7xfejHdPTnCDonvGlyekX/8jVlKldwSsKmJxgbWc/YPv1EJJOQrjD9tcBYX0cNTSkluQ4AVN9F2W01YlkHtsZqcefwdu/+lflMHPTHUtSVChoQGbPkax7Y3fn0RhAEop2VdZfrWPflEkHy8GEznqFCxUFX90eJYrH6O+QzvqzVyMXaKHVf0utZHSLN9sypBZeubx0BDDV0Av2kt7dWKF11/+KZI6zHddzDPMisoo/kDueJaNf6XeqyB1cWKEiVRQPUB61Y+yJfsTPPmipswV10D46n+9veiaBerpjGQXl+rYeAbW8SSe0GDDYoeDj8JzU7j0oprcJ0ARxWihU3mUhMRJ0v8MIplY5PadwJeBW3dm+iL+mjNzOOtYMMimVH/CazYP5Sl56fZFEafgby0AoHMi+bDEWrgpH9WupgbZYo16EJk+L00wO7sV2J4zPRHRekw3Zu0W2SHTJgl5ljearm9qtEUUlXJLkDNGxhJ8q4++PO/CEHxrZzx60QQUNPYdCN7Bhk5Egxxo+IV/+Qi1Dp/Gzi/K9f5GG4oVRBtMPDxtxuuAsTwT+1j4ysP8/N4PpEKaIpjtPtV+08zb8fe/UwYTApNMvy6uv6+aiGuNHSavZMjAWrXEE//RkPP2+RUPtEZA0v4245tBY8flDAWXH6nNp0VhRODDMf0jWmdcwuEDOrtuZF5S8m6HXJVk+cQ187txAonaiiSX5D/7L82BtcWQKhGxgi0SJC1xCix7EB8N/
 y6IUt38c
 M9L2o3MZtRejXXq3RXS5Jg/npJiEAgjTWYOU1EncDEnUObw9votZDvVgdrGSyxaWw5ux6QkZyuRJmK2URGhd8RDaGDVJWcJbDtDzW+qbWU+Jp0piR0mtSRJDz+za56iGrs4UqEqaNu1+h8rRsLvxKjRzy5MC4QmTLNCciN7M81oAjX8EzfCRISImMrslm2OOH8zRWyY2yaL+wG6OQnZqWmkNb4My9/1ouWJL+tebbgnL6r8CWoH5321vI9yvxt9ztN64hyO5PW8iUC4FtASJ1OOqQ9N51W+rfobtLX2Fd2hv8+/ScqqI49cA69cDY9vzBAuvm769Be+67u5ADlJUPJQ4XUR1AkQsKHVNqEgiGPJY6xQBFjrITYitAe6vkI+eebCo+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 14, 2026 at 7:28=E2=80=AFPM Dragos Tatulea <dtatulea@nvidia.com=
> wrote:
>
> Hi Luigi,
>
> On 03.10.26 23:22, Luigi Rizzo wrote:
> > Here is a subsystem called DMA_PMD on which I would like feedback on
...
>
> Thanks for the RFC. Here are my notes (some points rephrase what was alre=
ady
> said):
>
> - On CoCo VMs it seems that the only way to opt in the IOMMU optimization=
 is to
>   also opt in the copy avoidance which is not always desirable.
>
> - Having the pool generic opens up more visibility from the untrusted hos=
t
>   side. Having device based pools at least isolates one device's memory f=
rom
>   the rest of the system.
>
> - Also, device driver could help with provisioning just the right amount =
of
>   memory that is needed. And per device control also means that probably
>   you don't need to map everything RW to the IOMMU.

Yes on all three. I am looking into providing more knobs for different leve=
ls
of opt-in and isolation, so users may adjust them according to the
threat models and performance goals.

I am not especially worried about provisioning because the system is
already reasonably adaptive, and leveraging existing caches, the waste
the waste due to allocating 2MB units can be kept relatively small.

As an example, the update I am working on has the following:
- a lean per-cpu cache that can be attached on top of a dma_pmd_pool,
  similar to the one used by the buddy allocator. The dma_pmd_pool will hol=
d
  the 2MB pages, and the caches can buffer smaller sets, reducing the waste=
.
  Useful on the tx side.
- on the receive side, one dma_pmd_pool per device will feed all
  pagepools for that device (typically one per queue).
  The pagepool is already a pretty good cache that does not
  access the allocator often, so once again the waste due to
  partially used pages is minimized.

cheers
luigi

