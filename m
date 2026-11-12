Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFC6E606A884
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 10:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=eEQLmxb1
Received: by kanga.kvack.org (Postfix)
	id C80BA6B05B2; Thu, 12 Nov 2026 05:35:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C591C6B05B3; Thu, 12 Nov 2026 05:35:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B476C6B05B4; Thu, 12 Nov 2026 05:35:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 89D4A6B05B2
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 05:35:29 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 18012804FA
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 10:35:29 +0000 (UTC)
X-FDA: 85426110378.01.AFF0C9E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id 6B7E9160005
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 10:35:26 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eEQLmxb1;
	spf=pass (imf08.hostedemail.com: domain of aesteve@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794479727;
	b=c7aYEf6hh8ulaPtOBRn+cV0XzbAUyueoOYPvlK49hYeZYDEIGkZAF7iFHKNAT2R/O4Q79h
	gCbgCXfAPMoY2Tauye6rsp3WtPEw+xQVp19jWbqIJQxQZUn41bE/vkFi0q+8baJWohKgNr
	yupyzHIKK73/rUOegJbCPXNPAbvnilc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eEQLmxb1;
	spf=pass (imf08.hostedemail.com: domain of aesteve@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794479727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CADxnTwTU/PtUOG2lGGDUX07ln41Fkh6JA1CPAPl0sc=;
	b=QwAXPv3g6/Z0yxzbiE9ngxEgCXARkcCC6pAtt/22OpRVJHR72vOpkcG3qcVH0tZRM6JKoc
	qHGqPbK18I2qGyrxPmVucpxHiP5JhX6z35daVXQXpuOtw1FI48b2HZaZx09fPhrXU5lTCz
	xBGfhn+8eUyJy6y0CMup5cV7l3ibwlQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794479725;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CADxnTwTU/PtUOG2lGGDUX07ln41Fkh6JA1CPAPl0sc=;
	b=eEQLmxb1ulDtlikvIpkSnynXQfV2xYGaIkPkofoK1Rg5iCMDhY91RYBtJI82nenNcR7Exx
	+nMfH12dZpiSzZahosc9vH+hmmlzOU/9zaUNXsqLGnk5xp72wP7PjD1dsuixpV62p1+kim
	ycBpOfrtUC2jTAq6u1hDPN+5gN3IN5o=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-344-rgyrnRlBOOaFIhH0OjypuQ-1; Thu, 12 Nov 2026 05:35:24 -0500
X-MC-Unique: rgyrnRlBOOaFIhH0OjypuQ-1
X-Mimecast-MFC-AGG-ID: rgyrnRlBOOaFIhH0OjypuQ_1794479723
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-48fbcf023dcso2467198f8f.2
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 02:35:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794479723; x=1795084523;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=CADxnTwTU/PtUOG2lGGDUX07ln41Fkh6JA1CPAPl0sc=;
        b=Us9mMhc6lcAAm/nfeVDWsZQPLDc86Y0BSuGjlbQE8lEjQ9TeBWL2Bcz2rsNniXIEG/
         tO/K+PmU3D3W5SjrRdMtcFmHHP7uMMN3NSBybmKtCwHT5MQpSeehEP18XnMRyUlTuXSv
         gdNCJR1QU+5dBqt9NBbLM2Qzhp1ouVu8CU4wMaIPRqWWFhCyDxchrgEvW9sqXjCntDfJ
         mwOrKkDxF0zVGe8TI8rp/OjbbW9lU+IxCHM2LPPCnv/idOtilUub7WVtOx/j7eXX5CBq
         +U/RC3tQBnhw0fDZ1GUevWCsWv70ksbNGljMI136XfulEsq51zftBGUMsRPT2kGUMlLJ
         oW/A==
X-Forwarded-Encrypted: i=1; AL+hErHP3SDcnxzzJDKUle0km33LVKlMapj/HPz3soAAxpKsYWLBHQ12YuYsZR9ZTKqwWDJZeEl0iIEJ7w==@kvack.org
X-Gm-Message-State: APuU4Z8pf5f62AahDRQu1R/srgmpEhdVc+F/efaYOu5mz4kcThZSDKS7
	SA2YTwgqQ507goWjUU4nYQ6ElbZepAV3xQAKu2yZoOWpxZq9HgrVQvel++H0mTIV/5ala3z3CB4
	C663MOBNR8ck3btkzCo9SjFs4hjFCZqPyH5glL7E6143tRxguqgvB
X-Gm-Gg: AYBFou002pdFQiGFiHuEZmtTL2I+4FLCNuMVpvGGOr15KOl5Dde2wRmuu+brUF/7Oi0
	otxXwjX6xQNHSLUhlu6qrgs0kMqMRSXFCrF9DLg0UamPSfIfTlTU6THNjRvGqwUH4uZSwBKNyH4
	1eH928dTkd1Sa+qF5dIelzJFeBe2cXE0+q749E3PgcuNnblDKZwTQkIVrDB9Kw2LFhBTjnlvt4o
	yin2FWM4z1yVo9o/whwKwHSyAsIKp9wnb3/7/Wfrj+GQUK+XrXenRwxrZzCPUCamZr/hvkbkSwR
	nKfmWR5pqJaxsT2CFYSlyEuz+6jXtI4j280zucnsl69ryc5kU/3CvzavMO0nGti0Eg7Bm4X7nZ1
	F6MhsABjBo/QYWKaCPi7HhYIpMmeKknyknuyw0AuqBRc=
X-Received: by 2002:a05:6000:2085:b0:491:8462:20cc with SMTP id ffacd0b85a97d-499c83c0f21mr9326465f8f.37.1794479722859;
        Thu, 12 Nov 2026 02:35:22 -0800 (PST)
X-Received: by 2002:a05:6000:2085:b0:491:8462:20cc with SMTP id ffacd0b85a97d-499c83c0f21mr9326382f8f.37.1794479722342;
        Thu, 12 Nov 2026 02:35:22 -0800 (PST)
Received: from localhost ([139.47.30.142])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49895f4e6ffsm14747224f8f.16.2026.11.12.02.35.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 02:35:21 -0800 (PST)
Date: Thu, 12 Nov 2026 11:35:20 +0100
From: Albert Esteve <aesteve@redhat.com>
To: Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Brian Starkey <Brian.Starkey@arm.com>,
	John Stultz <jstultz@google.com>,
	"T.J. Mercier" <tjmercier@google.com>,
	Christian Brauner <brauner@kernel.org>,
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Shuah Khan <shuah@kernel.org>, Randy Dunlap <rdunlap@infradead.org>,
	Ondrej =?utf-8?B?TW9zbsOhxI1law==?= <omosnacek@gmail.com>,
	Jens Wikland er <jenswi@kernel.org>,
	Sumit Garg <sumit.garg@kernel.org>, cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, linux-mm@kvack.org,
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
	linux-kselftest@vger.kernel.org, op-tee@lists.trustedfirmware.org
Subject: Re: [Linaro-mm-sig] [PATCH v4 2/8] dma-heap: charge dma-buf memory
 via explicit memcg
Message-ID: <avWWaMg42vIJM2Ot@aesteve-thinkpadp1gen8.rmtes.csb>
References: <20261104-v2_20230123_tjmercier_google_com-v4-0-1819a017000b@redhat.com>
 <20261104-v2_20230123_tjmercier_google_com-v4-2-1819a017000b@redhat.com>
 <3fdad4e17008cd59bc528ab22e34c0c913a6d50f.camel@linux.intel.com>
 <avWNWnXCXm1sUYch@aesteve-thinkpadp1gen8.rmtes.csb>
 <22b3ca8cd78b61ecf652a34c5b6b23d7d46208d2.camel@linux.intel.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
In-Reply-To: <22b3ca8cd78b61ecf652a34c5b6b23d7d46208d2.camel@linux.intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: btCJOjrE3T_jPdwI2ARCfOpfWkuNwIzedXb4kmHxKIE_1794479723
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qcgorxpxd36mszdqdc8tdxzghjh1cdeu
X-Rspamd-Queue-Id: 6B7E9160005
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794479726-386124
X-HE-Meta: U2FsdGVkX1/Xg1fUNwTz3Lhfy7CJ1xgbUcC/1XhTewu8nVxQXgrHLaXx2JGpmi7Hq3Ffxo3UBNwOQyD+A1z3IVIvhicdwrv1euwd/ofsrq/iO35GGERE2fbKcGpgP51NamOaiqZuh/udyAbxVIoqx7DkllZVVWU5cFQ9etW4dcdiUQ//G+///s3nNV7DUvrf4yK6Jdce6EJhI3g5FiYKXJBhG9QrQSbOHHDpQJwEiLrPproTrqEw47fxbUNPFUyXpze1qQCvojmgViGnSHpweo1AQVDu0aexMehvUWI3we5hYQAXuvT2XBdZH9nGOk5ezM9lfdeOfMpT/MIVgqlOF+a7fy9GV9NNfZ/bSaB2wYpgLFCm6QxSIHfEYw/0nOTkvu/zKpTz9HR3NVdnw4GwH0nl49kNHuZ4L6fcsNdmAdyN65XtS+jH63AQkRBdVqJQoy6czg+3HLgpvtKOp1d1q44sHCv7b0181+SgRbCVLCd/tOxbzTLHpLdhYcxMwSpI1h4nJOzLbGvqK2KbjPtsCO6n7PF2/s77T9tOklONuF485uIk5q7LX/cQ60Bi5BX0deQZAQ1jBepUKGKDgACgonnV7Y/WpNfiInQ9zQ7VDImAnaKi0JV7gZQtICBlYF0JETdjIUde/YB0hc9VOSTsA193gUSiCNTXJDH5kEEBPC0XXe2rkt/76Ij3KEZDs2aEyUCQ/j1tLB4Hqn8Xq9uTAYYyNHdaaaiFrA4cZ6NILyBguTpywN0BRZ2DH1g4/2VYzdo71WGwAbWLOTBMJn2+jEUCGyywfLC/cAj+RMrUFyRX2LiRHYSUhiaF1sphZcTYJ0v15gHi0tpzvDf3Uvsq8S8l/6A8vJQRwDoCjEdEZq2JNflbQzckTKXzrpjzWm3QGmUakqLakQx7aL5CglMQ9wiKoUdaHqYQ2t0sBSfxs2LEseYfcQgBawSBPbkrNmPkmKySgBZUcdpTM2SjHXd
 ZkN8kIEd
 VLtrHn4iUhMPqn7Z8fKN54uS5SPkzBMRnnNXPcjH18tm10s2N91aOFVhHAuzjnp9TrDyOpnM8b5wtsjY3YeaVf+ZwRB+93xil3++YITeYn8bWcxwFrKKAu2sYK1OVPn4JMMLjxPzTDcu4g8vI+zmrHk5mnRregIQwWKLnn0CY13XcNjEj6ClTu4lJ1S1Jp6Ypoi0Haso9YSWiT/bGboj/cDE0NSURI6KyIwD4DwRnyIxvET/LWkYRyr6u6dCp2/j6pw0ZdR75GT201rqkgKZZ1nyLFgfSQdrs/Y+xsCQ0MKZbL28wgGCqc4pMIzGTSexXmvmT2A5rEGeVYwnOPrSku8K5dNe9pVTQ5sMskMxPWl4sD7fpF4oM0uOlhV/ZIJuDvV6cnbSEe13e0Ua56jgjjknRB4xMbrJ4ueq1dZy9zHJ/rLpu3QRMitDVXuFE2hXeG6GtccMY3hsoCMTX92bY2c76bgiADM5WiLjMqkXiIpgClOsVWewX5vnw1ZXUsBvkbCNIhiHh3ELBCC8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026 at 11:04:54AM +0100, Thomas Hellström wrote:
> On Thu, 2026-11-12 at 10:56 +0100, Albert Esteve wrote:
> > On Thu, Nov 12, 2026 at 08:42:18AM +0100, Thomas Hellström wrote:
> > > On Wed, 2026-11-04 at 12:09 +0100, Albert Esteve wrote:
> > > > On embedded platforms a central process often allocates dma-buf
> > > > memory on behalf of client applications. Without a way to
> > > > attribute the charge to the requesting client's cgroup, the
> > > > cost lands on the allocator, making per-cgroup memory limits
> > > > ineffective for the actual consumers.
> > > > 
> > > > Add charge_fd to struct dma_heap_allocation_data. When set to
> > > > a valid pidfd or cgroupfd, DMA_HEAP_IOCTL_ALLOC resolves the
> > > > target
> > > > task's or cgroup's memcg and charges the buffer there via
> > > > mem_cgroup_reserve_dmabuf() inside dma_heap_ioctl_allocate(). The
> > > > resolved memcg is passed through dma_buf_export_info so that
> > > > dma_buf_export() stores it and updates the MEMCG_DMABUF stat.
> > > > Without charge_fd, and with the mem_accounting module parameter
> > > > enabled, the buffer is charged to the allocator's own cgroup.
> > > > The __GPF_ACCOUNT flag is removed from system heap allocations
> > > > to avoid double counting.
> > > > 
> > > > Usage examples:
> > > > 
> > > >   1. Central allocator charging to a client at allocation time.
> > > >      The allocator knows the client's PID (e.g., from binder's
> > > >      sender_pid) and uses pidfd to attribute the charge:
> > > > 
> > > >        pid_t client_pid = txn->sender_pid;
> > > >        int pidfd = pidfd_open(client_pid, 0);
> > > > 
> > > >        struct dma_heap_allocation_data alloc = {
> > > >            .len         = buffer_size,
> > > >            .fd_flags    = O_RDWR | O_CLOEXEC,
> > > >            .charge_fd   = pidfd,
> > > >        };
> > > >        ioctl(heap_fd, DMA_HEAP_IOCTL_ALLOC, &alloc);
> > > >        close(pidfd);
> > > >        /* alloc.fd is now charged to client's cgroup */
> > > > 
> > > >   2. Default allocation (no pidfd, mem_accounting=1).
> > > >      When charge_fd is not set and the mem_accounting module
> > > >      parameter is enabled, the buffer is charged to the
> > > > allocator's
> > > >      own cgroup:
> > > > 
> > > >        struct dma_heap_allocation_data alloc = {
> > > >            .len      = buffer_size,
> > > >            .fd_flags = O_RDWR | O_CLOEXEC,
> > > >        };
> > > >        ioctl(heap_fd, DMA_HEAP_IOCTL_ALLOC, &alloc);
> > > >        /* charged to current process's cgroup */
> > > > 
> > > > Current limitations:
> > > > 
> > > >  - Single-owner model: a dma-buf carries one memcg charge
> > > > regardless
> > > > of
> > > >    how many processes share it. Means only the first owner (and
> > > > exporter)
> > > >    of the shared buffer bears the charge.
> > > >  - Only memcg accounting supported. While this makes sense for
> > > > system
> > > >    heap buffers, other heaps (e.g., CMA heaps) will require
> > > > selectively
> > > >    charging also for the dmem controller.
> > > > 
> > > > Signed-off-by: Albert Esteve <aesteve@redhat.com>
> > > > ---
> > > >  Documentation/admin-guide/cgroup-v2.rst |  5 ++--
> > > >  drivers/dma-buf/dma-buf.c               |  5 ++++
> > > >  drivers/dma-buf/dma-heap.c              | 28 +++++++++++++++++--
> > > > -
> > > >  drivers/dma-buf/heaps/cma_heap.c        |  3 ++-
> > > >  drivers/dma-buf/heaps/system_heap.c     | 21 +++++++++++----
> > > >  drivers/tee/tee_heap.c                  |  3 ++-
> > > >  include/linux/dma-buf.h                 |  4 +++
> > > >  include/linux/dma-heap.h                |  3 ++-
> > > >  include/linux/memcontrol.h              |  7 +++++
> > > >  include/uapi/linux/dma-heap.h           |  7 +++++
> > > >  mm/memcontrol.c                         | 47
> > > > +++++++++++++++++++++++++++++++++
> > > >  11 files changed, 120 insertions(+), 13 deletions(-)
> > > > 
> > > > diff --git a/Documentation/admin-guide/cgroup-v2.rst
> > > > b/Documentation/admin-guide/cgroup-v2.rst
> > > > index a3265a4a953e..66ddba678784 100644
> > > > --- a/Documentation/admin-guide/cgroup-v2.rst
> > > > +++ b/Documentation/admin-guide/cgroup-v2.rst
> > > > @@ -1663,8 +1663,9 @@ The following nested keys are defined.
> > > >  		structures.
> > > >  
> > > >  	  dmabuf (npn)
> > > > -		Amount of memory used for exported DMA buffers
> > > > allocated by the cgroup.
> > > > -		Stays with the allocating cgroup regardless of
> > > > how
> > > > the buffer is shared.
> > > > +		Amount of memory used for exported DMA buffers
> > > > allocated by or on
> > > > +		behalf of the cgroup. Stays with the allocating
> > > > cgroup regardless
> > > > +		of how the buffer is shared.
> > > 
> > > This doesn't sound right. Graphics buffers exported as DMA buffers
> > > are
> > > typically charged elsewhere, like gpu_active, and a transfer of
> > > their
> > > charge would likely stay in that key? To be consistent, shouldn't
> > > this
> > > be related to dma-heap memory and called dmaheap or something
> > > similar.
> > 
> > Although this work initially targeted dma heaps only, in its current
> > form is meant to stay generic (while solving the central allocator
> > problem). The memory exported as dma-bufs has no memory.stat of its
> > own, and an exporter allocating plain pages (e.g., V4L2) has nowhere
> > else to report it.
> > 
> > > We should have a tighter definition of exactly what memory is to be
> > > registered here.
> > 
> > Yes, I will be more specific and clearly state that an exporter
> > whose memory is already accounted must not opt in. That also
> > naturally disallows transfers.
> 
> I would suspect (although not sure TBH) a system that uses a
> centralized allocator for gpu memory (even if it's accounted as
> gpu_active) might want to be able to transfer the charge as well, so I
> think the transfer mechanism might want to be generic enough to handle
> that.

That makes sense as a direction, but my aim for this series was
to tackle the central allocator problem, that is, memory charge at
dma-buf level to the cgroup an allocation is made for, and moved
afterwards if needed.

For allocators that charge per page (as in Dave's series) a transfer
would move each page's charges between objcgs, which is a different
mechanism from the dma-buf level charge in this series.

But iiuc you feedback is in line with Christian's feedback that uAPI
should not block later extension. To that end, XFER_CHARGE ioctl has a
reserved flags field, so more buffer types can be potentially supported
later, as they opt-in, without uAPI changes.

> At least the initial design should IMO allow for a future hook to
> handle such transfers even for !dma-buf memory?

Not sure what you mean by hook here. A callback in the exporter?
A charge op in dma_buf_ops was already objected before [1].

[1] https://lore.kernel.org/lkml/5cc27a05-8131-ce9b-dea1-5c75e994216d@amd.com/


> 
> Thanks,
> Thomas
> 
> 
> > 
> > > 
> > > Also says "Stays with the allocating cgroup regardless of how the
> > > buffer is shared", which isn't correct after the series? Perhaps
> > > that's
> > > changed in a later patch.
> > 
> > I missed updating the text after having added XFER_CHARGE to the
> > series. I'll fix the wording in this patch and mention the transfer
> > in the next one.
> > 
> > BR,
> > Albert
> > 
> > > 
> > > Thanks,
> > > Thomas
> > > 
> > > 
> > > 
> > > 
> > > >  
> > > >  	  workingset_refault_anon
> > > >  		Number of refaults of previously evicted
> > > > anonymous
> > > > pages.
> > > > diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-
> > > > buf.c
> > > > index 1c6b9cee7ac2..837666273550 100644
> > > > --- a/drivers/dma-buf/dma-buf.c
> > > > +++ b/drivers/dma-buf/dma-buf.c
> > > > @@ -714,6 +714,7 @@ struct dma_buf *dma_buf_export(const struct
> > > > dma_buf_export_info *exp_info)
> > > >  	struct dma_resv *resv = exp_info->resv;
> > > >  	struct file *file;
> > > >  	size_t alloc_size = sizeof(struct dma_buf);
> > > > +	unsigned int nr_pages = PAGE_ALIGN(exp_info->size) >>
> > > > PAGE_SHIFT;
> > > >  	int ret;
> > > >  
> > > >  	if (WARN_ON(!exp_info->priv || !exp_info->ops
> > > > @@ -750,6 +751,7 @@ struct dma_buf *dma_buf_export(const struct
> > > > dma_buf_export_info *exp_info)
> > > >  	dmabuf->size = exp_info->size;
> > > >  	dmabuf->exp_name = exp_info->exp_name;
> > > >  	dmabuf->owner = exp_info->owner;
> > > > +	dmabuf->memcg = exp_info->memcg;
> > > >  	spin_lock_init(&dmabuf->name_lock);
> > > >  	init_waitqueue_head(&dmabuf->poll);
> > > >  	dmabuf->cb_in.poll = dmabuf->cb_out.poll = &dmabuf-
> > > > >poll;
> > > > @@ -771,6 +773,9 @@ struct dma_buf *dma_buf_export(const struct
> > > > dma_buf_export_info *exp_info)
> > > >  
> > > >  	DMA_BUF_TRACE(trace_dma_buf_export, dmabuf);
> > > >  
> > > > +	if (dmabuf->memcg)
> > > > +		mod_memcg_state(dmabuf->memcg, MEMCG_DMABUF,
> > > > nr_pages);
> > > > +
> > > >  	return dmabuf;
> > > >  
> > > >  err_file:
> > > > diff --git a/drivers/dma-buf/dma-heap.c b/drivers/dma-buf/dma-
> > > > heap.c
> > > > index 8a6c2b6e0cc6..7bd416ae2c23 100644
> > > > --- a/drivers/dma-buf/dma-heap.c
> > > > +++ b/drivers/dma-buf/dma-heap.c
> > > > @@ -10,6 +10,8 @@
> > > >  #include <linux/device.h>
> > > >  #include <linux/dma-buf.h>
> > > >  #include <linux/dma-heap.h>
> > > > +#include <linux/memcontrol.h>
> > > > +#include <linux/sched/mm.h>
> > > >  #include <linux/err.h>
> > > >  #include <linux/export.h>
> > > >  #include <linux/list.h>
> > > > @@ -78,6 +80,7 @@ static struct dma_buf
> > > > *dma_heap_ioctl_allocate(struct file *file, void *data)
> > > >  	struct dma_heap_allocation_data *heap_allocation = data;
> > > >  	struct dma_heap *heap = file->private_data;
> > > >  	struct dma_buf *dmabuf;
> > > > +	struct mem_cgroup *memcg = NULL;
> > > >  	int fd;
> > > >  	size_t len;
> > > >  
> > > > @@ -90,15 +93,34 @@ static struct dma_buf
> > > > *dma_heap_ioctl_allocate(struct file *file, void *data)
> > > >  	if (heap_allocation->heap_flags &
> > > > ~DMA_HEAP_VALID_HEAP_FLAGS)
> > > >  		return ERR_PTR(-EINVAL);
> > > >  
> > > > +	if (heap_allocation->__padding != 0)
> > > > +		return ERR_PTR(-EINVAL);
> > > > +
> > > > +	if (heap_allocation->charge_fd) {
> > > > +		memcg = mem_cgroup_get_from_fd(heap_allocation-
> > > > > charge_fd);
> > > > +		if (IS_ERR(memcg))
> > > > +			return ERR_CAST(memcg);
> > > > +	}
> > > > +
> > > > +	if (!memcg && mem_accounting)
> > > > +		memcg = get_mem_cgroup_from_mm(current->mm);
> > > > +
> > > >  	len = PAGE_ALIGN(heap_allocation->len);
> > > > -	if (!len)
> > > > +	if (!len) {
> > > > +		mem_cgroup_put(memcg);
> > > >  		return ERR_PTR(-EINVAL);
> > > > +	}
> > > >  
> > > >  	dmabuf = heap->ops->allocate(heap, len, heap_allocation-
> > > > > fd_flags,
> > > > -				     heap_allocation-
> > > > >heap_flags);
> > > > +				     heap_allocation-
> > > > >heap_flags,
> > > > memcg);
> > > >  
> > > > -	if (IS_ERR(dmabuf))
> > > > +	if (IS_ERR(dmabuf)) {
> > > > +		mem_cgroup_put(memcg);
> > > >  		return dmabuf;
> > > > +	}
> > > > +
> > > > +	if (memcg && !dmabuf->memcg)
> > > > +		mem_cgroup_put(memcg);
> > > >  
> > > >  	fd = get_unused_fd_flags(heap_allocation->fd_flags);
> > > >  	if (fd < 0) {
> > > > diff --git a/drivers/dma-buf/heaps/cma_heap.c b/drivers/dma-
> > > > buf/heaps/cma_heap.c
> > > > index 3fb4b946c91a..04de88b468a8 100644
> > > > --- a/drivers/dma-buf/heaps/cma_heap.c
> > > > +++ b/drivers/dma-buf/heaps/cma_heap.c
> > > > @@ -281,7 +281,8 @@ static const struct dma_buf_ops
> > > > cma_heap_buf_ops
> > > > = {
> > > >  static struct dma_buf *cma_heap_allocate(struct dma_heap *heap,
> > > >  					 unsigned long len,
> > > >  					 u32 fd_flags,
> > > > -					 u64 heap_flags)
> > > > +					 u64 heap_flags,
> > > > +					 struct mem_cgroup
> > > > *memcg)
> > > >  {
> > > >  	struct cma_heap *cma_heap = dma_heap_get_drvdata(heap);
> > > >  	struct cma_heap_buffer *buffer;
> > > > diff --git a/drivers/dma-buf/heaps/system_heap.c b/drivers/dma-
> > > > buf/heaps/system_heap.c
> > > > index c8959eadc71d..2bd245e1eab8 100644
> > > > --- a/drivers/dma-buf/heaps/system_heap.c
> > > > +++ b/drivers/dma-buf/heaps/system_heap.c
> > > > @@ -17,6 +17,7 @@
> > > >  #include <linux/err.h>
> > > >  #include <linux/highmem.h>
> > > >  #include <linux/mem_encrypt.h>
> > > > +#include <linux/memcontrol.h>
> > > >  #include <linux/mm.h>
> > > >  #include <linux/set_memory.h>
> > > >  #include <linux/module.h>
> > > > @@ -388,8 +389,6 @@ static struct page
> > > > *alloc_largest_available(unsigned long size,
> > > >  		if (max_order < orders[i])
> > > >  			continue;
> > > >  		flags = order_flags[i];
> > > > -		if (mem_accounting)
> > > > -			flags |= __GFP_ACCOUNT;
> > > >  		page = alloc_pages(flags, orders[i]);
> > > >  		if (!page)
> > > >  			continue;
> > > > @@ -401,11 +400,13 @@ static struct page
> > > > *alloc_largest_available(unsigned long size,
> > > >  static struct dma_buf *system_heap_allocate(struct dma_heap
> > > > *heap,
> > > >  					    unsigned long len,
> > > >  					    u32 fd_flags,
> > > > -					    u64 heap_flags)
> > > > +					    u64 heap_flags,
> > > > +					    struct mem_cgroup
> > > > *memcg)
> > > >  {
> > > >  	struct system_heap_buffer *buffer;
> > > >  	DEFINE_DMA_BUF_EXPORT_INFO(exp_info);
> > > >  	unsigned long size_remaining = len;
> > > > +	unsigned int nr_pages = PAGE_ALIGN(len) >> PAGE_SHIFT;
> > > >  	unsigned int max_order = orders[0];
> > > >  	struct system_heap_priv *priv =
> > > > dma_heap_get_drvdata(heap);
> > > >  	bool cc_shared = priv->cc_shared;
> > > > @@ -416,10 +417,15 @@ static struct dma_buf
> > > > *system_heap_allocate(struct dma_heap *heap,
> > > >  	struct page *page, *tmp_page;
> > > >  	int i, ret = -ENOMEM;
> > > >  
> > > > -	buffer = kzalloc_obj(*buffer);
> > > > -	if (!buffer)
> > > > +	if (!mem_cgroup_reserve_dmabuf(memcg, GFP_KERNEL,
> > > > nr_pages))
> > > >  		return ERR_PTR(-ENOMEM);
> > > >  
> > > > +	buffer = kzalloc_obj(*buffer);
> > > > +	if (!buffer) {
> > > > +		ret = -ENOMEM;
> > > > +		goto cancel_charge;
> > > > +	}
> > > > +
> > > >  	INIT_LIST_HEAD(&buffer->attachments);
> > > >  	mutex_init(&buffer->lock);
> > > >  	buffer->heap = heap;
> > > > @@ -473,11 +479,14 @@ static struct dma_buf
> > > > *system_heap_allocate(struct dma_heap *heap,
> > > >  	exp_info.size = buffer->len;
> > > >  	exp_info.flags = fd_flags;
> > > >  	exp_info.priv = buffer;
> > > > +	if (memcg)
> > > > +		exp_info.memcg = memcg;
> > > >  	dmabuf = dma_buf_export(&exp_info);
> > > >  	if (IS_ERR(dmabuf)) {
> > > >  		ret = PTR_ERR(dmabuf);
> > > >  		goto free_pages;
> > > >  	}
> > > > +
> > > >  	return dmabuf;
> > > >  
> > > >  free_pages:
> > > > @@ -498,6 +507,8 @@ static struct dma_buf
> > > > *system_heap_allocate(struct dma_heap *heap,
> > > >  	list_for_each_entry_safe(page, tmp_page, &pages, lru)
> > > >  		__free_pages(page, compound_order(page));
> > > >  	kfree(buffer);
> > > > +cancel_charge:
> > > > +	mem_cgroup_cancel_dmabuf(memcg, nr_pages);
> > > >  
> > > >  	return ERR_PTR(ret);
> > > >  }
> > > > diff --git a/drivers/tee/tee_heap.c b/drivers/tee/tee_heap.c
> > > > index 007c00156520..83e2fbd6960b 100644
> > > > --- a/drivers/tee/tee_heap.c
> > > > +++ b/drivers/tee/tee_heap.c
> > > > @@ -167,7 +167,8 @@ static const struct dma_buf_ops
> > > > tee_heap_buf_ops
> > > > = {
> > > >  
> > > >  static struct dma_buf *tee_dma_heap_alloc(struct dma_heap *heap,
> > > >  					  unsigned long len, u32
> > > > fd_flags,
> > > > -					  u64 heap_flags)
> > > > +					  u64 heap_flags,
> > > > +					  struct mem_cgroup
> > > > *memcg)
> > > >  {
> > > >  	struct tee_dma_heap *h = dma_heap_get_drvdata(heap);
> > > >  	DEFINE_DMA_BUF_EXPORT_INFO(exp_info);
> > > > diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
> > > > index 23ec0ff23fba..85dd747c9b36 100644
> > > > --- a/include/linux/dma-buf.h
> > > > +++ b/include/linux/dma-buf.h
> > > > @@ -505,6 +505,9 @@ struct dma_buf_attachment {
> > > >   * @flags:	mode flags for the file
> > > >   * @resv:	reservation-object, NULL to allocate default one
> > > >   * @priv:	Attach private data of allocator to this buffer
> > > > + * @memcg:	memcg to charge for this buffer's memory. Set
> > > > only
> > > > for
> > > > + *		buffers backed by system memory where @size
> > > > reflects
> > > > the
> > > > + *		actual allocation in bytes.
> > > >   *
> > > >   * This structure holds the information required to export the
> > > > buffer. Used
> > > >   * with dma_buf_export() only.
> > > > @@ -517,6 +520,7 @@ struct dma_buf_export_info {
> > > >  	int flags;
> > > >  	struct dma_resv *resv;
> > > >  	void *priv;
> > > > +	struct mem_cgroup *memcg;
> > > >  };
> > > >  
> > > >  /**
> > > > diff --git a/include/linux/dma-heap.h b/include/linux/dma-heap.h
> > > > index 648328a64b27..2d69f8432bd2 100644
> > > > --- a/include/linux/dma-heap.h
> > > > +++ b/include/linux/dma-heap.h
> > > > @@ -23,7 +23,8 @@ struct dma_heap_ops {
> > > >  	struct dma_buf *(*allocate)(struct dma_heap *heap,
> > > >  				    unsigned long len,
> > > >  				    u32 fd_flags,
> > > > -				    u64 heap_flags);
> > > > +				    u64 heap_flags,
> > > > +				    struct mem_cgroup *memcg);
> > > >  };
> > > >  
> > > >  /**
> > > > diff --git a/include/linux/memcontrol.h
> > > > b/include/linux/memcontrol.h
> > > > index 4d1e82cf0833..f8ec751b7d7b 100644
> > > > --- a/include/linux/memcontrol.h
> > > > +++ b/include/linux/memcontrol.h
> > > > @@ -671,6 +671,8 @@ int mem_cgroup_charge_hugetlb(struct folio*
> > > > folio, gfp_t gfp);
> > > >  int mem_cgroup_swapin_charge_folio(struct folio *folio, unsigned
> > > > short id,
> > > >  				   struct mm_struct *mm, gfp_t
> > > > gfp);
> > > >  
> > > > +struct mem_cgroup *mem_cgroup_get_from_fd(int fd);
> > > > +
> > > >  bool mem_cgroup_reserve_dmabuf(struct mem_cgroup *memcg, gfp_t
> > > > gfp,
> > > >  			       unsigned int nr_pages);
> > > >  
> > > > @@ -1178,6 +1180,11 @@ static inline int
> > > > mem_cgroup_swapin_charge_folio(struct folio *folio,
> > > >  	return 0;
> > > >  }
> > > >  
> > > > +static inline struct mem_cgroup *mem_cgroup_get_from_fd(int fd)
> > > > +{
> > > > +	return ERR_PTR(-EOPNOTSUPP);
> > > > +}
> > > > +
> > > >  static inline bool mem_cgroup_reserve_dmabuf(struct mem_cgroup
> > > > *memcg,
> > > >  					     gfp_t gfp,
> > > >  					     unsigned int
> > > > nr_pages)
> > > > diff --git a/include/uapi/linux/dma-heap.h
> > > > b/include/uapi/linux/dma-
> > > > heap.h
> > > > index a4cf716a49fa..bfcd1c25bc7e 100644
> > > > --- a/include/uapi/linux/dma-heap.h
> > > > +++ b/include/uapi/linux/dma-heap.h
> > > > @@ -29,6 +29,11 @@
> > > >   *			handle to the allocated dma-buf
> > > >   * @fd_flags:		file descriptor flags used when
> > > > allocating
> > > >   * @heap_flags:		flags passed to heap
> > > > + * @charge_fd:		optional pidfd or cgroupfd whose cgroup
> > > > should be
> > > > + *			charged for this allocation; 0 means
> > > > charge
> > > > the calling
> > > > + *			process's cgroup when the mem_accounting
> > > > module parameter
> > > > + *			is enabled, or skip charging otherwise
> > > > + * @__padding:		reserved, must be zero
> > > >   *
> > > >   * Provided by userspace as an argument to the ioctl
> > > >   */
> > > > @@ -37,6 +42,8 @@ struct dma_heap_allocation_data {
> > > >  	__u32 fd;
> > > >  	__u32 fd_flags;
> > > >  	__u64 heap_flags;
> > > > +	__u32 charge_fd;
> > > > +	__u32 __padding;
> > > >  };
> > > >  
> > > >  #define DMA_HEAP_IOC_MAGIC		'H'
> > > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > > index e53dd7eebc3b..17fdefc56b97 100644
> > > > --- a/mm/memcontrol.c
> > > > +++ b/mm/memcontrol.c
> > > > @@ -5661,6 +5661,53 @@ void mem_cgroup_flush_workqueue(void)
> > > >  	flush_workqueue(memcg_wq);
> > > >  }
> > > >  
> > > > +/**
> > > > + * mem_cgroup_get_from_fd - resolve a memcg from a cgroupfd or
> > > > pidfd
> > > > + * @fd: file descriptor (cgroupfd or pidfd)
> > > > + *
> > > > + * Tries @fd as a cgroupfd first; if that fails, tries it as a
> > > > pidfd.
> > > > + * On success returns a referenced memcg pointer. On failure
> > > > returns
> > > > + * an ERR_PTR.
> > > > + */
> > > > +struct mem_cgroup *mem_cgroup_get_from_fd(int fd)
> > > > +{
> > > > +	struct cgroup_subsys_state *css;
> > > > +	struct mem_cgroup *memcg;
> > > > +	struct cgroup *cgrp;
> > > > +	struct task_struct *task;
> > > > +	struct mm_struct *mm;
> > > > +	unsigned int pidfd_flags;
> > > > +
> > > > +	cgrp = cgroup_get_from_fd(fd);
> > > > +	if (!IS_ERR(cgrp)) {
> > > > +		rcu_read_lock();
> > > > +		css = cgroup_css(cgrp, &memory_cgrp_subsys);
> > > > +		if (!css || !css_tryget_online(css)) {
> > > > +			rcu_read_unlock();
> > > > +			cgroup_put(cgrp);
> > > > +			return ERR_PTR(-ENOENT);
> > > > +		}
> > > > +
> > > > +		memcg = mem_cgroup_from_css(css);
> > > > +		rcu_read_unlock();
> > > > +		cgroup_put(cgrp);
> > > > +		return memcg;
> > > > +	}
> > > > +
> > > > +	task = pidfd_get_task(fd, &pidfd_flags);
> > > > +	if (IS_ERR(task))
> > > > +		return ERR_CAST(task);
> > > > +
> > > > +	mm = get_task_mm(task);
> > > > +	put_task_struct(task);
> > > > +	if (!mm)
> > > > +		return ERR_PTR(-ESRCH);
> > > > +
> > > > +	memcg = get_mem_cgroup_from_mm(mm);
> > > > +	mmput(mm);
> > > > +	return memcg ?: ERR_PTR(-ENOENT);
> > > > +}
> > > > +
> > > >  /**
> > > >   * mem_cgroup_reserve_dmabuf - charge a memcg for a dma-buf
> > > > allocation
> > > >   * @memcg: memcg to charge (may be %NULL)


