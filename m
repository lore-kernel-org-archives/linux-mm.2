Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CB33C53209
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 19:48:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB4416B0092; Fri, 24 Jul 2026 15:48:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D640A6B0095; Fri, 24 Jul 2026 15:48:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C55BA6B0096; Fri, 24 Jul 2026 15:48:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8D6EC6B0092
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 15:48:29 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1C94316015C
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 19:48:29 +0000 (UTC)
X-FDA: 85024707138.24.C6E58EC
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf20.hostedemail.com (Postfix) with ESMTP id 49E991C000E
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 19:48:27 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DTjzX+2l;
	spf=pass (imf20.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784922507;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ioc+vYD1TGm3PkR61xqfpxrMbvRpPmr2378lUazgynQ=;
	b=GpADI6PBUWKDBxmg9pQO5leoPYGQ7V6yt7NkQr53FOpXVbYKRAfE0D62GIRYrt2HbG582W
	MePkcShntioYcxlsAdYkQ04Vv3a+/SKGJmHAcLF/InpcWHvuPDtYQHITgH5SnJUqPOn1O3
	y8cvs8Q46BjohD/vXF6Tr2CFQpDttL8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784922507;
	b=uNBl/LHg79BAyKV9jTC12+gFWtv4RyvugZNFZIcBpSgBUTflqMODeqBXxXU6cZVcJ8IS8W
	6QyHh8yV3BqE+SPXNeb9L49TttZsjpewCy5h0hRksuTUtNXRhjFtcQ6IXWkMgmuphk/iLA
	0r7ZlNX3a+z3mUbspp7T8xq0D86KGjk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DTjzX+2l;
	spf=pass (imf20.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-383cb94f742so813966a91.3
        for <linux-mm@kvack.org>; Fri, 24 Jul 2026 12:48:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784922506; x=1785527306; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Ioc+vYD1TGm3PkR61xqfpxrMbvRpPmr2378lUazgynQ=;
        b=DTjzX+2l1JHY0oIjnvEiTxupsSYCZXAaopnHycpZUDw4K2qeE7qhca2JfFBSw43woa
         SK8RhLpKqvaidGF5Qrg7KKi2PHRukH2E8o67Mmd1r7ZVbXUKybnT0rZHo9We6wPWw5b1
         RceCzo4Wk/dwlkByHRk24RsD8MtErVD4/8ywxi6UfNV3tvkF+OxJnVfl98s5vqOgXi/H
         pA66D4AnmX4RXQOe4B6D2KFg0MyLDsom7zFgIWLfsJCiVmKtGZSVjLClnwksQc6VFwMR
         TiXaavi5uOXH+2onxR45oMdxEXEdk3N2GEU13smrPt45JYtKMdONNJQamyWprtUrsclS
         L7MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784922506; x=1785527306;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ioc+vYD1TGm3PkR61xqfpxrMbvRpPmr2378lUazgynQ=;
        b=KHB1y63L42y+tpFv2qtKicS21V7pohnZYZsHostURPa1M8+CDXcH3Ob2ARM8v+8iqU
         2XfB6JRw7WoEunUJODeO9jFLo2NF0gT7wMdVrOr7CpIk8iaX+I4FoQOQtgsczWSbOw62
         BbHn5AJ8Cl47HhPplULLWgHEMOIUuFGKD2IJwmsi6v4M+JEwLolz0qEGe9aQhiG5vC1u
         0dvh+YbGrayKsE4OAurSGGtFO8KfRkztfYnpkhDr+IJ+164XNkY5tOdwaPaQs1W+Ynaa
         HdijvJesBN7JghM8s/1w3MTOaHQv0Zqy2IEBj4ykiqmvKk3WRgHpBZ+WVnzwwg38iOH6
         ODmw==
X-Forwarded-Encrypted: i=1; AHgh+RpCIZOPbrG2XAPLzl2lEVZnW3oWnLj1IGEyIy+xF7nH8wi+OJc1YJO26kkBfPmvdnq6WI0c3kS/og==@kvack.org
X-Gm-Message-State: AOJu0Yy9uodZmIUA5JQDwRG8Uy/1ESQRVucsoxVRGdjY++WIIQqZV9xV
	SEDtY73Fl2+cXJnWTtKj41rbObeORKUCNSpjMlhIwQEFZrw386OTEQbm
X-Gm-Gg: AR+sD11hpR2NNj24BaAaOJTF1tK21h6f4qdD3B5/h0zcFfHR7vgQ+22TBXRv/FJyt2s
	5wh555qpB7Z0KruvcGmwxIpMMxVFnEqbDhKC6SL//afNFQX6CiIxxCgQyd1aDJKGIrxM9vXdjE7
	z3lZwirg1WRozPgySIkUqNDgq4kPOtAadSa6oYAcAz5zowZE3WjOdzj7fylrFU7VKswgiqSmG+k
	0wZRCOC7VhVxPvsvYGo/ha/BfmcIfKzXZUX/41f5N7pwoXhNQzHIAyWrBnPuYXLLhuCClfVId5J
	9NhOzF8I3WiSXDTjM1/esc13APNbrQVZywqn8558ncB/4ogutmLIYbydWzwthiUuU57Q39EhRBK
	9YcF5Oz2znv1p7Srk9tERgzooquejiPOmQqNybunrgwFB4gMc/UBcFfpsqc6FhoIlxVCAYobD7c
	48+9IpO5snHSDUgQ9LcGE//xnR1byZ/yii/S/rx9RGSfJN
X-Received: by 2002:a17:90b:3904:b0:38e:584f:2515 with SMTP id 98e67ed59e1d1-38ec6aae88emr8486005a91.37.1784922506003;
        Fri, 24 Jul 2026 12:48:26 -0700 (PDT)
Received: from skinsburskii (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38f0417599csm2037544a91.9.2026.07.24.12.48.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2026 12:48:25 -0700 (PDT)
Date: Fri, 24 Jul 2026 12:48:22 -0700
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Shuah Khan <shuah@kernel.org>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>, Lyude Paul <lyude@redhat.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Min Ma <mamin506@gmail.com>, Lizhi Hou <lizhi.hou@amd.com>,
	Oded Gabbay <ogabbay@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-hyperv@vger.kernel.org,
	dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org,
	linux-rdma@vger.kernel.org
Subject: Re: [PATCH v11 1/8] mm/hmm: move page fault handling out of walk
 callbacks
Message-ID: <amPBhhqIbdUQdlPf@skinsburskii>
References: <20260723-hmm-v10-v11-0-c55b003a4b61@gmail.com>
 <20260723-hmm-v10-v11-1-c55b003a4b61@gmail.com>
 <7655eaad-dcbf-4275-93f6-1f92ffedfa76@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7655eaad-dcbf-4275-93f6-1f92ffedfa76@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 49E991C000E
X-Stat-Signature: 4qmqas7d1ypdco8i4hp38jogu4sojong
X-HE-Tag: 1784922507-801227
X-HE-Meta: U2FsdGVkX19ZmrywIBmCqdG7NACnwq3Xw1E9c+GTSSkutgVnv2+JqSwdldJ/i9MLdPxkZ1Lh6RhX3xaR1O56i3BXRvlPWRWP0CRCxyqLoKeu9ohSKGPVIt6/sjCHYUlW10eLMzQBq/TkROQcJjxmi0t1p86iSROTwDGOUwOB2ZREiqn2ulprhRXSSG7D8pYAHJ0upx5AU9iq/QpfWneuaP78lXotqDnS5O3hD1/GbqfbWc8dk9v5Sr6Kd+3G+HmQ5+v7rJZ9KHGcxMIOECQY+hJzjyDJcbnXyDA+Ke2XHSphR1nYBlnx8XvajkdCoygv8jD0wrH091rT1Pb2wuid4nhfG/Cp9qTk6y+vzKpHgw4ITXbt5f7UJAMhbisvQMbkUXt/9BGZXJrV3gqK5lXZeQx+7gTbeGHV7wK36WxDapbaWWARJhjqTJ2AcH4Iruo0KCtAVEtRWbxmyw1Cbyn7mXDhP9gLmHoXViNXkTM3P+M45iNcsjTDzHTXQ/AHf0tHMhnnaecEJjcoKkfGT8Iph2D2oCZkNrmUuet3+smA4E34vASB987Y5iSMg+zbUyyZgUyF8qQgKtJNSo51SgmPEXNOPe7MPmqJOBq6++3NWTbUIQFf3qDg0/03Wr5CVT2zLIMY3Ca/Dw3ABXJN2R6FalgFFdbbnPDdPe2IauTaRdYSDRl7zp+HUrIaOSJbOIeP/q1njaIjezDjeCUX1E6KVr4JrbtudZeL0FNHKDc9lEFaOuy9iAyNmHhaVXEma9I02BeoNSOHdjfgOnmREBeBATm4fIuy/SNgnGmFDaAviXv/91Llr+JfdxJlr5gjo58BNfY5ob+TU6DZzvW1oIVWv+ny/0GDE+w6zR5r/ChuCHmE9h5QZAwetiMgPcFI69CpMLS96p/lPfAOc9NAUP+2dUGABaqxi6/rQQV513dZrrHtCgabJyXf6j5yaJscUvPKXXVSN7cb8prI9mHNkC9
 kNm9aU4M
 rQASFjSwSbT+hImuqKpFlY0Q5cHib8fn6L3tDRHH7KoN8f/czuAy6nn6/9p/95AoIO9zRmmj5Mu4fTBSM5fURNViv1CLX0EemLIXGIKPi3lSH4/rU0Z3SS0XFCjUGM9+JwQTOh0b4oYMaFCMi7q23nkQaAS3LwUqlpT81agH0R1vCskcOzVUrHL8/k2dT+4h6hnFnUXTWR5gvWkgJifvlOgQ9n0ezSH25I2QUZmH97qrBJn/ZnI5sfPZb7BiVZz27bDFv/NGSeCa7J9IKgnygJa1Pxlp4wT7NKbp0U9l6AdjB58kGUwDmReOQ3BjKlO5bo3zRnckAWkOS09ZHyy+Tx9ZzzR8CfZ6iplXj78eL1kAgWNKquY4Rh2vJbjPeWhsttxVQVmW4WzV2f7Mi1Y7bccKfIKLm6pTronl7Iu4ZD2DT7nqA9ms/qM957Ap0pgCkqNn25eWBZ/EI3w7ITZ+BN7VYbFqHmU/zcM2Ue2ImyNitxQICJM1MDFd/PrQzKhN0o4XYGPoi6hqUWeX9MKxkdJVgSVrg9h+ZeprMPecK3mhOTVY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 24, 2026 at 09:00:24PM +0200, David Hildenbrand (Arm) wrote:
> On 7/23/26 19:36, Stanislav Kinsburskii wrote:
> > hmm_range_fault() currently triggers page faults from inside the page-table
> > walk callbacks: hmm_vma_walk_pmd(), hmm_vma_walk_pud(),
> > hmm_vma_walk_hugetlb_entry() and the pte-level helper all call
> > hmm_vma_fault(), which in turn calls handle_mm_fault() while the walker
> > still holds nested locks.  The pte spinlock is dropped explicitly by each
> > caller, and the hugetlb path manually drops and retakes
> > hugetlb_vma_lock_read around the fault to dodge a deadlock against the walk
> > framework's unconditional unlock.
> > 
> > This layering does not extend cleanly to fault handlers that may release
> > mmap_lock (VM_FAULT_RETRY, VM_FAULT_COMPLETED). If the lock is dropped
> > while walk_page_range() is mid-traversal, the VMA can be freed before the
> > walk framework's matching hugetlb_vma_unlock_read(), turning that unlock
> > into a use-after-free.
> > 
> > Split the responsibilities the way get_user_pages() does. Walk callbacks
> > become inspect-only: when they detect a range that needs to be faulted in,
> > they record it in struct hmm_vma_walk and return a private sentinel
> > (HMM_FAULT_PENDING). The outer loop in hmm_range_fault() then drops out of
> > walk_page_range(), invokes a new helper hmm_do_fault() that calls
> > handle_mm_fault() with only mmap_lock held, and restarts the walk so the
> > now-present entries are collected into hmm_pfns.
> > 
> > No functional change for existing callers. As a side effect the hugetlb
> > callback no longer needs the hugetlb_vma_{un}lock_read dance, and every
> > fault-path exit from the callbacks now releases the pte spinlock on a
> > single, common path. This refactor is also a precursor for adding an
> > unlockable variant of hmm_range_fault() in a follow-up patch.
> > 
> > Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> > Signed-off-by: Stanislav Kinsburskii <skinsburskii@gmail.com>
> > ---
> 
> Any reason my RB got dropped?
> 
> https://lore.kernel.org/all/0b9be5b3-93aa-407f-b83d-409bec4b55e1@kernel.org/
> 

No reason, just an omission on my side.

Andrew, could you add David's RB to this patch, please?

Thanks,
Stanislav

> -- 
> Cheers,
> 
> David

