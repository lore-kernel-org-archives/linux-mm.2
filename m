Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C168606A32E
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 09:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=UV65ZWDb
Received: by kanga.kvack.org (Postfix)
	id 4F1536B05C6; Thu, 12 Nov 2026 04:03:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A22F6B05C7; Thu, 12 Nov 2026 04:03:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 369686B05C8; Thu, 12 Nov 2026 04:03:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 02E0C6B05C6
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 04:03:49 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D725012045E
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:57:22 +0000 (UTC)
X-FDA: 85425863124.04.72F7A39
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id 6CA14160004
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:57:20 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UV65ZWDb;
	spf=pass (imf08.hostedemail.com: domain of aesteve@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794473840;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+IM6c9SQzhSiNLCPJKNescY2jVpZ6DadiC6JkBUJ1jI=;
	b=hdc/ym6BEPKvANiwkLlgLOQA4sr/nvlZOzJV/+OEKfLpV+30aKQo9sxarWvbeD/YxT6lOv
	cb7Y37CqJ92bNX7TK72WtzUuSpTa4eq+KY4qq1h5qUX7ZX6e8aKWE0UA7t3JMyBeCUv1tt
	Et3cc13C4j1xhe/aJF3vPYUS12NHdyY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UV65ZWDb;
	spf=pass (imf08.hostedemail.com: domain of aesteve@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794473840;
	b=QSyzoHW2X2RV0yQ3eRnLb8K14apUfGtzonMRxTJhgB+2bWWNFC7yuuCcz0HoeWXytcgixs
	7baT7QU/iMroDaEze8LvDGLiAJbQ+TcApMJXS2GsdVqxjH1ZOiay+RtU4oaxoJOZXmDtaO
	ZzsTeo5NFIAI9V+ZGo5Haa5RQBGrYPo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794473839;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+IM6c9SQzhSiNLCPJKNescY2jVpZ6DadiC6JkBUJ1jI=;
	b=UV65ZWDb83EtQFm4jjDLNA2FjEtDDkiZsUcHh/fiIE086uIlVerrneT8fgBRxZku0o5i57
	cdzQNLkcoQS2O9Q7uF4HOx4QDoQlVjcM1GcViSlcgvK+wvFi6rLZW38WR10WVM5Ifb2WU4
	4qVwbOlQOPE2kI1OoYJqVZnksBp4Cn8=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-515-ItZlG_LkP1m-25vKAFZiqA-1; Thu, 12 Nov 2026 03:57:18 -0500
X-MC-Unique: ItZlG_LkP1m-25vKAFZiqA-1
X-Mimecast-MFC-AGG-ID: ItZlG_LkP1m-25vKAFZiqA_1794473837
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4a359b714f8so31050745e9.2
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 00:57:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794473837; x=1795078637;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=+IM6c9SQzhSiNLCPJKNescY2jVpZ6DadiC6JkBUJ1jI=;
        b=pblcIgwTTFHS9cMKTsmiHSFJiSC5U57vwOG2WXn4RbqoNqkVXPJ0CaIRCRQz3r7Nuf
         UXO0Ywp2rLlSvvrMAjYyO3dKVzSY/Omrrot8OenY+bSff/slLD2RmYhvC484WDfod5f/
         M3HT0e/+HCz1O6KTN3ddOsx5HZyFK3NZCppkeqv0woCgC0LWri/n7Q6UKlptx1JAlNGY
         53+nyPTEyhXu9ICCSYdV2zk2aS619zd2bpUJzIqvwYyLtoUMvF9gM10HpUDXJbBjbrlE
         QoVVCsHYWIrKDFzoHBz2KArszphT/cIDDcP+wIzrpiUq3ImTd3Ed1f7gZx5ni4HcO0Re
         2QYA==
X-Forwarded-Encrypted: i=1; AL+hErEJrMutN3rXpAiKxKxIAIJg35WW5+Mdw0aCmzfdSn8z1/To8IYc84NGJ6IY4P8/Uu2v+fMMgRqKmg==@kvack.org
X-Gm-Message-State: APuU4Z+p3X3cIhmce63g3FrTboROSKgXlqEmiAAX+nO+cuzSv8nt5yNU
	Z7s3xtc4/KlLKKE1Ff623sPCwtDesljQxhB9h0sgUe9uNpYbAqBFxaCItoukdCp65T0thGNRNm0
	7HgoASfa6UznoNn//YidBvbiYRrLqVV3zsFbVWrT3wICBn5Feb4pr
X-Gm-Gg: AYBFou1HcUATxyb40NFw8bNiTmv7diEwOeoCgG+gPcHUQFVYAejAa9+I121BIO6Zz8d
	ws9PHV29+GnT8zTfKsxyFaHfskm3Ta3iGXom8q0Z9uUORHnLl1OGdHgP90QEieH5hVpbJUl68KS
	KUQlg7cZxonin2yBXWKQ4k8IAE+hQzUXOTPfei7R2y1ROx+eSkWB4D5i1Ms+0eyCaqjJ1H/K7YZ
	Ly6u7WkZSxjKAge4XmxAs4UoQPZ8IxyuIMPsKJbT7mk8HcntImAUvuMAD+9oK+qKk+k7MSSi6G5
	MYACZyswBb2ZmiSddpYqpdM8jKr7YII2DNo7oWWjtXArKU+oWd9UiiX7SIHiDYiMcpIMCQBZ13x
	9sLS+r2BpoRJNOl4XvRKDp2IplEPu+1ShgaHxpj97MoI=
X-Received: by 2002:a05:600c:1c0d:b0:4a2:1e1:d55 with SMTP id 5b1f17b1804b1-4ba093a3cf9mr102102025e9.28.1794473836896;
        Thu, 12 Nov 2026 00:57:16 -0800 (PST)
X-Received: by 2002:a05:600c:1c0d:b0:4a2:1e1:d55 with SMTP id 5b1f17b1804b1-4ba093a3cf9mr102100215e9.28.1794473835545;
        Thu, 12 Nov 2026 00:57:15 -0800 (PST)
Received: from localhost ([139.47.30.142])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb4e251686sm54810695e9.3.2026.11.12.00.57.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 00:57:15 -0800 (PST)
Date: Thu, 12 Nov 2026 09:57:14 +0100
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
	Jens Wiklander <jenswi@kernel.org>,
	Sumit Garg <sumit.garg@kernel.org>, cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, linux-mm@kvack.org,
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
	linux-kselftest@vger.kernel.org, op-tee@lists.trustedfirmware.org
Subject: Re: [Linaro-mm-sig] [PATCH v4 1/8] memcg: Add MEMCG_DMABUF
 accounting infrastructure
Message-ID: <avV_asMMt16Q5S7S@aesteve-thinkpadp1gen8.rmtes.csb>
References: <20261104-v2_20230123_tjmercier_google_com-v4-0-1819a017000b@redhat.com>
 <20261104-v2_20230123_tjmercier_google_com-v4-1-1819a017000b@redhat.com>
 <96d6a6e828310738c0cb4550752a0b5808a81ef9.camel@linux.intel.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
In-Reply-To: <96d6a6e828310738c0cb4550752a0b5808a81ef9.camel@linux.intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: QBzhwb5tMyzoMuXp2OsQMw7cTpDxFSarMiAtPV0oWN4_1794473837
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Stat-Signature: dwsadnsc6zgnwihkp8873userxgj4nn3
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 6CA14160004
X-HE-Tag: 1794473840-790003
X-HE-Meta: U2FsdGVkX1+FqIHXnBNkArtfPOEvAIo+RrfgLMLA22mFzek1rn6mA+JKvdg2YH3TV2atg06QyzkUPReS2rskA8glrP6PoSp4k1KFRRYYaZD44onUa2zWUyJB5fyDDXb00pNodoCDPfbwsdmg+ZFAep1hnB7osYLM7LJrJsTSnMHAp7/c16xvm5WiELXXrZ+cZpt1ChMHZBGoudSs5Gc7A8S7nQQexEJ8+J6XO77fcnlAChCnifsaupbj9h0qTJvR7OQWwkTzT7CeX7TZ7wBLWhfAjaFphIN3RLAa8m/xujI97TiQ6WcWmGaJMEFhY2sNLc1p2aVZvL/S9E8r5Ys1q3XW6XmNbme8OS3flv4JQo50XBu7X3aSLQf0JGv7AP0+2jWgEokAQYmof8hlt+g7RZxFQb4FNMb9mqzzVIW38tsqk9GtxmBJKzVFTwks/IoU/ypBFek49KCf9aokc2oXAO9JdYniCXLA572V2XCx1s/v7CLtjF2g5ocs1ydGeDqBPqu+yh7bwgVXLthHIZjrpUYE64NAjLjCcL7+ZTZm30vnResod5Rv93pfjzbeVkFWfFZz3r3UnWdFkEQJh4Na+IEunVEiL4MHb8spLiXd/1pOTcKdWnObBnKiWdDt6ZyLDKEFRPIINUKppctk3s7ml5mVRFCDr5TagtcpekZFtNBK7Xhm9S1Sp4FysBkRZCpcw4Uaepewwl4tlBiSivGgjn3x9Ad10yo3DpCjgP98w+QZNaJzXTsAQXskyAMn76jqQs74heR1i1fYcf/QEyeLvAYHBJnWmsQTW46vTf9QcTanxMhiLcirFP4JReo+Hg4UJoG5r8KOFoaWDQnlZM6p9T4oxC68jza7JNKIAoE8iNQSI0ueYBVqIYgaUwhfWhlC+cxLcnOidhwdY/IK0ALpAheo8IhGXOtl1oPBIKNf2bm7ylbaLeImYTzpwwTJ79TjE552pObLBKM53DsiE8m
 E8QmVTAd
 O+mcO0uG8eF5bJgQjJgOPPOAbaFdVXAlu87orjACf6zBHqCJc0WcWYwaSUQlwjx7os90DlT4mjQd9cKZwAehadzOxWw6DCeRVG99J/P5R0pkgrIrdKlcX2tyOAoFBb1Mv0VghxMxYlELZQYuQwmhyv9U+SFkjqR4qxQmajDQNVJfmTKS7hKzkMoDFX8f87ETkKh0w/cvTsfFcTRqUWMizI+R9WcKQhvCUsltYepVY/hzB21ZabGwhoYSpG+QqQ13/zTo5x6uHhp1MGaMzF+JwirzJqPmzteCV2YyD8wcxT2mdp06YzBIXx+Lfe6apZopgcajthYBerUBNN267FDYx+OIgAyIPOVb8R4FwWoIB2Ewf5v+l3SmKsAmwNCzzY/f4lLo6BXGSmAhrFyqMlmLQxp/0+Cghx3ZT3gRCwEZqQ4Ukci8cdVbTmzmdnHXYYYLSJl/Jp2P5rjbWkIT6npzWRCIGnGIwCCcQCsR30n1S3JfUrbfDGKs5AoSzzxAbMvaE7cP61fwhOZonfDqKl+KT5ccfI/GoNtyfG2pX9ttxv9g94NM+p7WRdAislz/VwZbhk6ZbgC1lLTOAApM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026 at 08:26:35AM +0100, Thomas Hellström wrote:
> On Wed, 2026-11-04 at 12:09 +0100, Albert Esteve wrote:
> > From: "T.J. Mercier" <tjmercier@google.com>
> > 
> > Introduce a MEMCG_DMABUF stat counter and helpers for charging,
> > cancelling, and uncharging dma-buf memory against a memory cgroup.
> > 
> > The charge is tracked on struct dma_buf via a new memcg pointer.
> > The memcg reference is stored into (or cleared from) dmabuf->memcg
> > by the helpers, removing the need for callers to manage those
> > details. The release path in dma_buf_release() is reduced to a
> > single mem_cgroup_uncharge_dmabuf() call.
> > 
> > Rather than charging at the page level via __GFP_ACCOUNT, which
> > would require exporters to expose their backing pages for
> > cross-cgroup transfer via new dma_buf_ops, charges are tracked
> > externally on struct dma_buf through a single accounting path.
> > 
> > The next patch wires up the charging policy in the dma-heap ioctl.
> > 
> > Signed-off-by: T.J. Mercier <tjmercier@google.com>
> > Signed-off-by: Albert Esteve <aesteve@redhat.com>
> > ---
> >  Documentation/admin-guide/cgroup-v2.rst |  4 ++
> >  drivers/dma-buf/dma-buf.c               |  3 ++
> >  include/linux/dma-buf.h                 |  4 ++
> >  include/linux/memcontrol.h              | 27 +++++++++++++
> >  mm/memcontrol.c                         | 70
> > +++++++++++++++++++++++++++++++++
> >  5 files changed, 108 insertions(+)
> > 
> > diff --git a/Documentation/admin-guide/cgroup-v2.rst
> > b/Documentation/admin-guide/cgroup-v2.rst
> > index 86a2a0099178..a3265a4a953e 100644
> > --- a/Documentation/admin-guide/cgroup-v2.rst
> > +++ b/Documentation/admin-guide/cgroup-v2.rst
> > @@ -1662,6 +1662,10 @@ The following nested keys are defined.
> >  		Amount of memory used for storing in-kernel data
> >  		structures.
> >  
> > +	  dmabuf (npn)
> > +		Amount of memory used for exported DMA buffers
> > allocated by the cgroup.
> > +		Stays with the allocating cgroup regardless of how
> > the buffer is shared.
> > +
> >  	  workingset_refault_anon
> >  		Number of refaults of previously evicted anonymous
> > pages.
> >  
> > diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
> > index 4c9add51f9ef..1c6b9cee7ac2 100644
> > --- a/drivers/dma-buf/dma-buf.c
> > +++ b/drivers/dma-buf/dma-buf.c
> > @@ -14,6 +14,7 @@
> >  #include <linux/fs.h>
> >  #include <linux/slab.h>
> >  #include <linux/dma-buf.h>
> > +#include <linux/memcontrol.h>
> >  #include <linux/dma-fence.h>
> >  #include <linux/dma-fence-unwrap.h>
> >  #include <linux/anon_inodes.h>
> > @@ -182,6 +183,8 @@ static void dma_buf_release(struct dentry
> > *dentry)
> >  
> >  	dmabuf->ops->release(dmabuf);
> >  
> > +	mem_cgroup_uncharge_dmabuf(dmabuf);
> > +
> >  	if (dmabuf->resv == (struct dma_resv *)&dmabuf[1])
> >  		dma_resv_fini(dmabuf->resv);
> >  
> > diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
> > index d15b2b31d3c9..23ec0ff23fba 100644
> > --- a/include/linux/dma-buf.h
> > +++ b/include/linux/dma-buf.h
> > @@ -27,6 +27,7 @@
> >  struct device;
> >  struct dma_buf;
> >  struct dma_buf_attachment;
> > +struct mem_cgroup;
> >  
> >  /**
> >   * struct dma_buf_ops - operations possible on struct dma_buf
> > @@ -429,6 +430,9 @@ struct dma_buf {
> >  
> >  		__poll_t active;
> >  	} cb_in, cb_out;
> > +
> > +	/** @memcg: the cgroup to which this buffer is currently
> > attributed */
> > +	struct mem_cgroup *memcg;
> >  };
> >  
> >  /**
> > diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> > index 7d1c0ce189a8..4d1e82cf0833 100644
> > --- a/include/linux/memcontrol.h
> > +++ b/include/linux/memcontrol.h
> > @@ -10,6 +10,9 @@
> >  
> >  #ifndef _LINUX_MEMCONTROL_H
> >  #define _LINUX_MEMCONTROL_H
> > +
> > +struct dma_buf;
> > +
> >  #include <linux/cgroup.h>
> >  #include <linux/vm_event_item.h>
> >  #include <linux/hardirq.h>
> > @@ -40,6 +43,7 @@ enum memcg_stat_item {
> >  	MEMCG_ZSWAP_B,
> >  	MEMCG_ZSWAPPED,
> >  	MEMCG_ZSWAP_INCOMP,
> > +	MEMCG_DMABUF,
> >  	MEMCG_NR_STAT,
> >  };
> >  
> > @@ -667,6 +671,9 @@ int mem_cgroup_charge_hugetlb(struct folio*
> > folio, gfp_t gfp);
> >  int mem_cgroup_swapin_charge_folio(struct folio *folio, unsigned
> > short id,
> >  				   struct mm_struct *mm, gfp_t gfp);
> >  
> > +bool mem_cgroup_reserve_dmabuf(struct mem_cgroup *memcg, gfp_t gfp,
> > +			       unsigned int nr_pages);
> > +
> >  void __mem_cgroup_uncharge(struct folio *folio);
> >  
> >  /**
> > @@ -682,6 +689,10 @@ static inline void mem_cgroup_uncharge(struct
> > folio *folio)
> >  	__mem_cgroup_uncharge(folio);
> >  }
> >  
> > +void mem_cgroup_cancel_dmabuf(struct mem_cgroup *memcg, unsigned int
> > nr_pages);
> > +
> > +void mem_cgroup_uncharge_dmabuf(struct dma_buf *dmabuf);
> > +
> >  void __mem_cgroup_uncharge_folios(struct folio_batch *folios);
> >  static inline void mem_cgroup_uncharge_folios(struct folio_batch
> > *folios)
> >  {
> > @@ -1167,10 +1178,26 @@ static inline int
> > mem_cgroup_swapin_charge_folio(struct folio *folio,
> >  	return 0;
> >  }
> >  
> > +static inline bool mem_cgroup_reserve_dmabuf(struct mem_cgroup
> > *memcg,
> > +					     gfp_t gfp,
> > +					     unsigned int nr_pages)
> > +{
> > +	return true;
> > +}
> > +
> > +static inline void mem_cgroup_cancel_dmabuf(struct mem_cgroup
> > *memcg,
> > +					    unsigned int nr_pages)
> > +{
> > +}
> > +
> >  static inline void mem_cgroup_uncharge(struct folio *folio)
> >  {
> >  }
> >  
> > +static inline void mem_cgroup_uncharge_dmabuf(struct dma_buf
> > *dmabuf)
> > +{
> > +}
> > +
> >  static inline void mem_cgroup_uncharge_folios(struct folio_batch
> > *folios)
> >  {
> >  }
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 856a7d07586c..e53dd7eebc3b 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -69,6 +69,7 @@
> >  #include <net/ip.h>
> >  #include "slab.h"
> >  #include "memcontrol-v1.h"
> > +#include <linux/dma-buf.h>
> >  
> >  #include <linux/uaccess.h>
> >  
> > @@ -442,6 +443,7 @@ static const unsigned int memcg_stat_items[] = {
> >  	MEMCG_ZSWAP_B,
> >  	MEMCG_ZSWAPPED,
> >  	MEMCG_ZSWAP_INCOMP,
> > +	MEMCG_DMABUF,
> >  };
> >  
> >  #define NR_MEMCG_NODE_STAT_ITEMS ARRAY_SIZE(memcg_node_stat_items)
> > @@ -1625,6 +1627,7 @@ static const struct memory_stat memory_stats[]
> > = {
> >  #ifdef CONFIG_HUGETLB_PAGE
> >  	{
> > "hugetlb",			NR_HUGETLB			},
> >  #endif
> > +	{
> > "dmabuf",			MEMCG_DMABUF			},
> >  
> >  	/* The memory events */
> >  	{
> > "workingset_refault_anon",	WORKINGSET_REFAULT_ANON		},
> > @@ -5658,6 +5661,73 @@ void mem_cgroup_flush_workqueue(void)
> >  	flush_workqueue(memcg_wq);
> >  }
> >  
> > +/**
> > + * mem_cgroup_reserve_dmabuf - charge a memcg for a dma-buf
> > allocation
> > + * @memcg: memcg to charge (may be %NULL)
> > + * @gfp_mask: reclaim mode
> > + * @nr_pages: number of pages to charge
> > + *
> > + * Charges @nr_pages against @memcg. Call this before allocating
> > pages so
> > + * the cgroup limit is enforced up front. On success the caller must
> > + * finalize the charge with the MEMCG_DMABUF stat update, or call
> > + * mem_cgroup_cancel_dmabuf() to undo it.
> > + *
> > + * Returns %true on success, %false if the charge would exceed the
> > limit.
> > + */
> > +bool mem_cgroup_reserve_dmabuf(struct mem_cgroup *memcg, gfp_t
> > gfp_mask,
> > +			       unsigned int nr_pages)
> > +{
> > +	if (!memcg || mem_cgroup_disabled())
> > +		return true;
> > +
> > +	if (try_charge(memcg, gfp_mask, nr_pages))
> > +		return false;
> > +
> > +	return true;
> > +}
> > +EXPORT_SYMBOL_GPL(mem_cgroup_reserve_dmabuf);
> > +
> > +/**
> > + * mem_cgroup_cancel_dmabuf - undo a dma-buf charge
> > + * @memcg: memcg to uncharge (may be %NULL)
> > + * @nr_pages: same value passed to mem_cgroup_reserve_dmabuf()
> > + *
> > + * Returns @nr_pages of charge to @memcg. Use when the allocation
> > fails
> > + * after mem_cgroup_reserve_dmabuf().
> > + */
> > +void mem_cgroup_cancel_dmabuf(struct mem_cgroup *memcg, unsigned int
> > nr_pages)
> > +{
> > +	if (!memcg)
> > +		return;
> > +
> > +	if (!mem_cgroup_is_root(memcg))
> > +		refill_stock(memcg, nr_pages);
> > +}
> > +EXPORT_SYMBOL_GPL(mem_cgroup_cancel_dmabuf);
> > +
> > +/**
> > + * mem_cgroup_uncharge_dmabuf - uncharge a dma-buf from its memcg
> > + * @dmabuf: buffer to uncharge
> > + *
> > + * Reverses a finalized dma-buf charge. Drops the memcg
> > + * reference stored in @dmabuf->memcg and clears the pointer.
> > + * Safe to call when @dmabuf->memcg is %NULL.
> > + */
> > +void mem_cgroup_uncharge_dmabuf(struct dma_buf *dmabuf)
> > +{
> > +	unsigned int nr_pages;
> > +	struct mem_cgroup *memcg = dmabuf->memcg;
> > +
> > +	if (!memcg)
> > +		return;
> > +
> > +	nr_pages = PAGE_ALIGN(dmabuf->size) >> PAGE_SHIFT;
> > +	mod_memcg_state(memcg, MEMCG_DMABUF, -nr_pages);
> > +	mem_cgroup_cancel_dmabuf(memcg, nr_pages);
> > +	mem_cgroup_put(memcg);
> > +	dmabuf->memcg = NULL;
> > +}
> 
> Instead of keeping a reference on the memcg for the buffer's whole
> lifetime, shouldn't an obj_cgroup be used, which is reparented when the
> memcg goes offline?

Good point. I did not think of it, but after a brief check I think it'd
be the right object to use. I'll switch for the next version.

> Like in Dave's series here:
> 
> https://lore.kernel.org/all/20260706052330.1110909-1-airlied@gmail.com/

Thanks for the link! I'll use it as reference. I should mention it in the
cover letter too probably, as that series is related (should be safe as
far as it does not opt-in for dma-buf-level charging).

BR,
Albert

> 
> Thanks,
> Thomas
> 
> 
> 
> 
> > +
> >  static int __init cgroup_memory(char *s)
> >  {
> >  	char *token;


