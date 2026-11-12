Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B60A606A893
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 10:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=eBvXpv/9
Received: by kanga.kvack.org (Postfix)
	id DA1F16B05B6; Thu, 12 Nov 2026 05:02:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D525C6B05B7; Thu, 12 Nov 2026 05:02:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C41726B05B8; Thu, 12 Nov 2026 05:02:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9CA526B05B6
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 05:02:25 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8D1C5160483
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 10:02:24 +0000 (UTC)
X-FDA: 85426027008.17.F9CDCAC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1DE6A1C0008
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 10:02:21 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="eBvXpv/9";
	spf=pass (imf18.hostedemail.com: domain of aesteve@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794477742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ku69CJLRXzwwOsA6G2xqy4VdyNyzfbNSiJBSoeXd84w=;
	b=5OhYxfv7G3Q/ZWs03kVPpdnwN1/5wtPQLeK1cfl2P0tkeYaN9TQwJ5HLKwGm+bRGIBA+sM
	aHywCE+5a3HsOjkTAkV9Wx2sDGdNORwUy2YPD6vce+boCFZSsEK/4pQdN8EiY6qMv4bs73
	m4/wa4rvVR+e8XqkMhlEjwbwL+STj7w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794477742;
	b=AwC98+5vgPcQsu1nupLFecL59S2MWrPNLVM1O+Pm4riwZunwm8ybr0+LOGgezk6QWFhcEi
	hh7bku0xeXxdml1TrxOF2icTYRNTHPuFSgKKEUSl4N/71ohqtkefmylb4mnqeP8Y1Ky/rL
	Bw4zrDQOWS0Q4AGHnhTV2XwG0/4DG30=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="eBvXpv/9";
	spf=pass (imf18.hostedemail.com: domain of aesteve@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794477741;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ku69CJLRXzwwOsA6G2xqy4VdyNyzfbNSiJBSoeXd84w=;
	b=eBvXpv/91ElvSiIqIDTuwTEIGZodPjBovCs8FY39z63CbvfIma2/9Iveem5jB2BbtFVC/r
	GwI8wwoXqqr1gSjLoUX1r+wcBoIeWsrhAzqWhnssnYiQy5H+WtiERUnocuCAHUqEHHFh8u
	vZpGnbt09LMbf7dEDMg8dAeSKyumEMs=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-154-K7TgZRD5NKmLcMtQlLFviA-1; Thu, 12 Nov 2026 05:02:20 -0500
X-MC-Unique: K7TgZRD5NKmLcMtQlLFviA-1
X-Mimecast-MFC-AGG-ID: K7TgZRD5NKmLcMtQlLFviA_1794477739
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4a211bff50bso27397045e9.2
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 02:02:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794477739; x=1795082539;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=ku69CJLRXzwwOsA6G2xqy4VdyNyzfbNSiJBSoeXd84w=;
        b=wGrENdP85CoGyl1Txb4Q7vxJ+xKG650X23Glnz1xtEZv4e20qXvkOCtJRdaLN77XM7
         h9MHhgT7FhYXfVEb9oZ46k4Tnfphv0oeG/a8ADLdrwC6Y4mIJ5AoLrmY8S2lrtJ7wKNm
         YWoVhTDb67cNcw/99HF823utheJzdVYNxQbGsFDJGAR9KpXBjTR4dIuA8uwrhX9cs41y
         9O3/15nOfO9efWMroyVgCoLRzqBu8RYT/wjKrWv8IrKtjoNTuSDB2augPlNTnzUIvaTr
         HafIda/njyCyBVFOuztVrB4XvJvrVD5SNizjYveMqZzvCtXOi9fm1EtUldpYq0jiXCkw
         u1MA==
X-Forwarded-Encrypted: i=1; AL+hErGSNsUBWfB43/P3KAEsJHac0gSUtMWB70/VC3NwCefRF4hPvoBRZycRUJ9jRO6JEs3TiOrpZkOm3Q==@kvack.org
X-Gm-Message-State: APuU4Z8Dmc8FCpDORpeVogJ559e19hYIH8eS5Lcfmh2KwpLlsxMixYRT
	bUhRub9H3Lbt8sDT7Ov7a8D9RIsPEhFXehQ0HU57BgpgHSAcbPFk5Lpp+ww0ZzbNo8S3qmksRK5
	RbAcqQ1eOzJjEGTWPNBR3JVtc7ipV6rmbZBNtfbyxqo9RdROuunHU
X-Gm-Gg: AYBFou1ASYvAvCdBeofeF4e6VTu/G4bX4ZQNHTJebYsMferdm6FwMDa8na4dPJNzgO6
	jxPM7OeWzOO414eVnqYNC4c093emWiQaqmDBDa/SoY4iCpO2v073YlORYaaj0hL9v6DzzXP4ohU
	TIqF95Te9CrqE0vGncARI30EQy/kqkwYClfWpuyK2KhI8eji/cMuQYZ/otzYJjEfzOHD8l7VUsj
	vSV673B3DjZXL7P8g4twVvOvpXgGmeB9B5omUeS3U2qOKEXeXvVvxgwMiT1TfOP07vU37BoLSi0
	kqQUJDribcWGllVCziMba71lcRq9NgTgDr8t1/dh54W3OKJhHDMzREfNScsb3Iov9XF92ObAKw4
	9fk4C+6StgJ8L5KAnUDyZOsUvAngD35IxIAwDiEFcZdM=
X-Received: by 2002:a05:600c:4f84:b0:4a1:e92b:ae4a with SMTP id 5b1f17b1804b1-4ba093b9a3cmr86690345e9.21.1794477738938;
        Thu, 12 Nov 2026 02:02:18 -0800 (PST)
X-Received: by 2002:a05:600c:4f84:b0:4a1:e92b:ae4a with SMTP id 5b1f17b1804b1-4ba093b9a3cmr86689595e9.21.1794477738330;
        Thu, 12 Nov 2026 02:02:18 -0800 (PST)
Received: from localhost ([139.47.30.142])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4983284c99bsm15755230f8f.7.2026.11.12.02.02.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 02:02:17 -0800 (PST)
Date: Thu, 12 Nov 2026 11:02:16 +0100
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
Subject: Re: [Linaro-mm-sig] [PATCH v4 3/8] dma-buf: transfer memcg charges
 via DMA_BUF_IOCTL_XFER_CHARGE
Message-ID: <avWOqDLI1xmfBqn2@aesteve-thinkpadp1gen8.rmtes.csb>
References: <20261104-v2_20230123_tjmercier_google_com-v4-0-1819a017000b@redhat.com>
 <20261104-v2_20230123_tjmercier_google_com-v4-3-1819a017000b@redhat.com>
 <b77aecccce2dcf9bc42b1a6fccc62d06ccad4741.camel@linux.intel.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
In-Reply-To: <b77aecccce2dcf9bc42b1a6fccc62d06ccad4741.camel@linux.intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ROJwql5cryRI95lp5Hrjj_DBkiw0jEVaJGQ69E3TfoM_1794477739
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: 8i6u5czgiwspd68gfwoh5aoqna67pbi5
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 1DE6A1C0008
X-Rspam-User: 
X-HE-Tag: 1794477741-80005
X-HE-Meta: U2FsdGVkX19AQwo2X15onl2k4isylRnhzTCrm/DpQ2IqpSVshYMDQFb/VDhFBHgCWGab/+HN2z3w7VEVZTuHihPGGvBTzVAv9jmxampCIDZMcjxzyzaKyAauNUyhhnKRSidSRGeoxmyWC8E+Pz0EMNpyqXRShg2yTUjMPdPWwEdLJDg/cRRXcPKFg+4MQdS/ge/Xtxy4idMTyggNkeJP5c84qRaOIQScszmX4qJH4mm4Xjn9Y92GxmC4OtfZPKSX+DMCIQRsdJ1lYJ4yKzP6IKo/+tW8pPcGM9NeFJ8Y1CdXK5CyF9sXcRMheR6kseV0OtqZ2GVLxMwDtU+CsZmRCMo3iKQTdPKOoXBw/x8q77kDU4Xs8qFq0PnWFI4LjdbBYmBnw5E9DG/DTOY0Pd4f2ELNA/zaGO64BMEzgOdm/9BKVjQ2C88sMZLrbYsWhjIKFqND2ccCqZ0KHDzqto4jD1kOdVs3W3HcRfoyzwoVwRUSjjl/k6lyxa14kgST0RhPmhAUw6vyJYcEsBAtNKHJ04AhWm0VojDm1qIEM+OgFeGe3DzYLLvQHHlIfRfLaywzp8RSHnOwevbo2QPeX2HweH5ZZde9/kgaf7WCaT8/1P0TuJQATvV9iZXXnMd5SsyxlwpHuhYO1jaAXEY5tNs2//JR4RzNj6typU029NF9aMxqm5rmytYXNuqCzgnMvULw9T3oC/jGFlX+qlBB5XQfnnmazUCO3nNnlecJiQZbBd4igC2KtTTt//uyqWlCNz6ZQ3+mpg+p4GoOOKLxyW3C0Lon9rdosFRwMZRH+k8++Wg33N3IGpSS6pW7x+V2qY5MrXJiXuwCir0xoK/oGJ6k35Vjgi3bWJQ/WqzAq0KJl1q2K5jUYrUJVfoWtxB2/qLz4Cf/01R5mCPGzop8ho1E3g6vB+tZF8J8XnRgvrAmxpMW0AKyVEN6ok3pzpX2JT9vj4ZTSUqhg9ZQnkOnT03
 ns8xwnL1
 0LLZH3sQXXsk2/L12/PG6s2EzBVPPa0qcqYUZ8j3xKLIP8Nm1gYrn+CimvGJcZnNSA8YwLDvCloIsfUBHjhxHKh8lAPtP3bALB+CiD4AxkxKkrsH69iyJubFIQ2ZtQOkxDbn115GPkT4qHrOqJkLJsnH1DPO8A8YCCTKfqb998Yoqnm0pq1VWIlCDn5ki7zGW1HoteIZ8BAC8gAUESMBauaffEJNBxO5laJzEq2pBmCApZuPm+7GCnNhrXrvXS3MCewQC4/2N5b2EmLT2xg3tkRp9Y0Gl2jgruLXnHgiQ2GubGNpyzvL0K6re+bDyW7yVp+ZTCO1fpRSVYBLFgXI57yoASFQttWFnsZJ11JZiLZcn1UnM7w2lXspRxR1bLYVu/+iIJnqih6kqE3PgaWVsCCk/s2pNMoNai1lS0Gb4nA4czf+KM1YWAI41F7E4Yc+NL8k7eAx4JPlyxR9JTfj/q+HVZuZ5+3piR9QoUwqHlaCBYXdT9bspS77aOoUmrw+1cfE/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026 at 08:46:02AM +0100, Thomas Hellström wrote:
> On Wed, 2026-11-04 at 12:09 +0100, Albert Esteve wrote:
> > dma-heap already supports charging a specific cgroup at allocation
> > time via charge_fd in DMA_HEAP_IOCTL_ALLOC. However, dma-bufs can
> > originate from any exporter (DRM, V4L2, etc.), and the allocator may
> > not know the final owner at allocation time.
> > 
> > Add DMA_BUF_IOCTL_XFER_CHARGE to transfer a dma-buf's memcg charge
> > to a different cgroup after allocation. The target is identified by
> > charge_fd, which may be a cgroupfd or a pidfd.
> > 
> > The transfer charges the new cgroup before uncharging the old one,
> > preserving the original charge on failure. Concurrent transfers are
> > serialized by the dma-buf reservation lock, so lockdep covers the
> > locking order of the charge path early. The transfer implementation
> > is generic (mem_cgroup_transfer_charge) and not dma-buf specific, so
> > it can be reused by other subsystems.
> > 
> > Not all dma-buf exporters back their buffers with reclaimable system
> > memory. Some represent device registers, VRAM, or carved-out pools
> > where size is not a meaningful memory cost. The xfer ioctl returns
> > -EOPNOTSUPP for buffers whose memcg is not set. Exporters opt in by
> > passing a memcg through dma_buf_export_info at export time. Currently
> > only the system heap sets it, other exporters can opt in as needed.
> > 
> > Usage example:
> >   int cg_fd = open("/sys/fs/cgroup/clients/app1", O_RDONLY |
> > O_DIRECTORY);
> > 
> >   struct dma_buf_transfer_charge xfer = {
> >       .charge_fd = cg_fd,
> >   };
> >   ioctl(dmabuf_fd, DMA_BUF_IOCTL_XFER_CHARGE, &xfer);
> >   /* charge now on app1's cgroup */
> >   close(cg_fd);
> > 
> > Signed-off-by: Albert Esteve <aesteve@redhat.com>
> > ---
> >  drivers/dma-buf/dma-buf.c    | 42
> > ++++++++++++++++++++++++++++++++++++++++++
> >  include/linux/dma-buf.h      |  3 ++-
> >  include/linux/memcontrol.h   | 13 +++++++++++++
> >  include/uapi/linux/dma-buf.h | 26 ++++++++++++++++++++++++++
> >  mm/memcontrol.c              | 42
> > ++++++++++++++++++++++++++++++++++++++++++
> >  5 files changed, 125 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
> > index 837666273550..3bd26fbb1109 100644
> > --- a/drivers/dma-buf/dma-buf.c
> > +++ b/drivers/dma-buf/dma-buf.c
> > @@ -540,6 +540,45 @@ static long dma_buf_import_sync_file(struct
> > dma_buf *dmabuf,
> >  }
> >  #endif
> >  
> > +/* Transfer a dma-buf's memcg charge; see struct
> > dma_buf_transfer_charge */
> > +static long dma_buf_xfer_charge(struct dma_buf *dmabuf,
> > +				const void __user *user_data)
> > +{
> > +	struct dma_buf_transfer_charge arg;
> > +	struct mem_cgroup *memcg;
> > +	unsigned int nr_pages = PAGE_ALIGN(dmabuf->size) >>
> > PAGE_SHIFT;
> > +	int ret = 0;
> > +
> > +	if (copy_from_user(&arg, user_data, sizeof(arg)))
> > +		return -EFAULT;
> > +
> > +	if (!IS_ENABLED(CONFIG_MEMCG))
> > +		return 0;
> > +
> > +	if (arg.flags != 0)
> > +		return -EINVAL;
> > +
> > +	memcg = mem_cgroup_get_from_fd(arg.charge_fd);
> > +	if (IS_ERR(memcg))
> > +		return PTR_ERR(memcg);
> > +
> > +	dma_resv_lock(dmabuf->resv, NULL);
> > +
> > +	if (!dmabuf->memcg) {
> > +		ret = -EOPNOTSUPP;
> > +		goto out;
> > +	}
> > +
> > +	if (dmabuf->memcg != memcg &&
> > +	    !mem_cgroup_transfer_charge(&dmabuf->memcg, memcg,
> > MEMCG_DMABUF, nr_pages))
> > +		ret = -ENOMEM;
> > +
> > +out:
> > +	dma_resv_unlock(dmabuf->resv);
> > +	mem_cgroup_put(memcg);
> > +	return ret;
> > +}
> > +
> >  static long dma_buf_ioctl(struct file *file,
> >  			  unsigned int cmd, unsigned long arg)
> >  {
> > @@ -590,6 +629,9 @@ static long dma_buf_ioctl(struct file *file,
> >  		return dma_buf_import_sync_file(dmabuf, (const void
> > __user *)arg);
> >  #endif
> >  
> > +	case DMA_BUF_IOCTL_XFER_CHARGE:
> > +		return dma_buf_xfer_charge(dmabuf, (const void
> > __user *)arg);
> > +
> >  	default:
> >  		return -ENOTTY;
> >  	}
> > diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
> > index 85dd747c9b36..b01149d26b44 100644
> > --- a/include/linux/dma-buf.h
> > +++ b/include/linux/dma-buf.h
> > @@ -507,7 +507,8 @@ struct dma_buf_attachment {
> >   * @priv:	Attach private data of allocator to this buffer
> >   * @memcg:	memcg to charge for this buffer's memory. Set only
> > for
> >   *		buffers backed by system memory where @size reflects
> > the
> > - *		actual allocation in bytes.
> > + *		actual allocation in bytes. Enables charge transfer
> > via
> > + *		DMA_BUF_IOCTL_XFER_CHARGE.
> >   *
> >   * This structure holds the information required to export the
> > buffer. Used
> >   * with dma_buf_export() only.
> > diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> > index f8ec751b7d7b..af02d9777fe9 100644
> > --- a/include/linux/memcontrol.h
> > +++ b/include/linux/memcontrol.h
> > @@ -676,6 +676,11 @@ struct mem_cgroup *mem_cgroup_get_from_fd(int
> > fd);
> >  bool mem_cgroup_reserve_dmabuf(struct mem_cgroup *memcg, gfp_t gfp,
> >  			       unsigned int nr_pages);
> >  
> > +bool mem_cgroup_transfer_charge(struct mem_cgroup **ptr_memcg,
> > +				struct mem_cgroup *new_memcg,
> > +				enum memcg_stat_item item,
> > +				unsigned int nr_pages);
> > +
> >  void __mem_cgroup_uncharge(struct folio *folio);
> >  
> >  /**
> > @@ -1197,6 +1202,14 @@ static inline void
> > mem_cgroup_cancel_dmabuf(struct mem_cgroup *memcg,
> >  {
> >  }
> >  
> > +static inline bool mem_cgroup_transfer_charge(struct mem_cgroup
> > **ptr_memcg,
> > +					      struct mem_cgroup
> > *new_memcg,
> > +					      enum memcg_stat_item
> > item,
> > +					      unsigned int nr_pages)
> > +{
> > +	return true;
> > +}
> > +
> >  static inline void mem_cgroup_uncharge(struct folio *folio)
> >  {
> >  }
> > diff --git a/include/uapi/linux/dma-buf.h b/include/uapi/linux/dma-
> > buf.h
> > index e827c9d20c5d..0aaf2e7d593b 100644
> > --- a/include/uapi/linux/dma-buf.h
> > +++ b/include/uapi/linux/dma-buf.h
> > @@ -168,6 +168,31 @@ struct dma_buf_import_sync_file {
> >  	__s32 fd;
> >  };
> >  
> > +/**
> > + * struct dma_buf_transfer_charge - Transfer a dma-buf's memcg
> > charge
> > + *
> > + * Any holder of a dma-buf file descriptor can perform a
> > + * DMA_BUF_IOCTL_XFER_CHARGE to attribute the buffer's memory
> > + * cost to a specific cgroup, or move it from one cgroup to
> > + * another.  The ioctl charges the new cgroup before uncharging
> > + * the old one atomically.  On failure the original charge is
> > + * preserved.  If the buffer has no existing memcg charge, the
> > + * ioctl returns -EOPNOTSUPP.
> > + */
> > +struct dma_buf_transfer_charge {
> > +	/** @flags: Reserved, must be zero */
> > +	__u32 flags; /* unused for now */
> > +	/**
> > +	 * @charge_fd: File descriptor identifying the target
> > cgroup.
> > +	 *
> > +	 * May be either a pidfd, in which case the charge moves to
> > the
> > +	 * memory cgroup of the referenced process, or a cgroupfd
> > obtained
> > +	 * by opening a cgroup v2 directory, in which case the
> > charge moves
> > +	 * directly to that cgroup's memory controller.
> > +	 */
> > +	__u32 charge_fd;
> > +};
> > +
> >  #define DMA_BUF_BASE		'b'
> >  #define DMA_BUF_IOCTL_SYNC	_IOW(DMA_BUF_BASE, 0, struct
> > dma_buf_sync)
> >  
> > @@ -179,5 +204,6 @@ struct dma_buf_import_sync_file {
> >  #define DMA_BUF_SET_NAME_B	_IOW(DMA_BUF_BASE, 1, __u64)
> >  #define DMA_BUF_IOCTL_EXPORT_SYNC_FILE	_IOWR(DMA_BUF_BASE, 2,
> > struct dma_buf_export_sync_file)
> >  #define DMA_BUF_IOCTL_IMPORT_SYNC_FILE	_IOW(DMA_BUF_BASE, 3, struct
> > dma_buf_import_sync_file)
> > +#define DMA_BUF_IOCTL_XFER_CHARGE	_IOW(DMA_BUF_BASE, 4, struct
> > dma_buf_transfer_charge)
> >  
> >  #endif
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 17fdefc56b97..3e717b5663c8 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -5752,6 +5752,48 @@ void mem_cgroup_cancel_dmabuf(struct
> > mem_cgroup *memcg, unsigned int nr_pages)
> >  }
> >  EXPORT_SYMBOL_GPL(mem_cgroup_cancel_dmabuf);
> >  
> > +/**
> > + * mem_cgroup_transfer_charge - move a charge between memcgs
> > + * @ptr_memcg: pointer to the memcg to transfer from
> > + * @new_memcg: target memcg; caller must hold a reference
> > + * @item: stat counter to adjust
> > + * @nr_pages: number of pages to transfer
> > + *
> > + * Transfers @nr_pages of charge from *@ptr_memcg to @new_memcg and,
> > on
> > + * success, stores @new_memcg in *@ptr_memcg.
> > + *
> > + * Updates to *@ptr_memcg must be serialized by the caller.
> > + * Returns %true on success, %false if the charge against @new_memcg
> > + * failed.
> > + */
> > +bool mem_cgroup_transfer_charge(struct mem_cgroup **ptr_memcg,
> > +				struct mem_cgroup *new_memcg,
> > +				enum memcg_stat_item item,
> > +				unsigned int nr_pages)
> > +{
> > +	struct mem_cgroup *old_memcg = *ptr_memcg;
> > +
> > +	if (!new_memcg || mem_cgroup_disabled())
> > +		return true;
> > +
> > +	if (try_charge(new_memcg, GFP_KERNEL, nr_pages))
> > +		return false;
> > +
> > +	mod_memcg_state(new_memcg, item, nr_pages);
> > +	css_get(&new_memcg->css);
> > +	*ptr_memcg = new_memcg;
> > +
> > +	if (old_memcg) {
> > +		/* Uncharge old cgroup */
> > +		mod_memcg_state(old_memcg, item, -nr_pages);
> > +		if (!mem_cgroup_is_root(old_memcg))
> > +			refill_stock(old_memcg, nr_pages);
> > +		mem_cgroup_put(old_memcg);
> > +	}
> > +
> > +	return true;
> > +}
> 
>  
> This has the same lifetime issue as patch 1. After a transfer, the
> buffer pins new_memcg until it is released, and with cross-process
> transfers the target may be removed before the
> buffer is. Since this helper is meant to be reused by other subsystems,
> would it be better to have it take and store an obj_cgroup from the
> start?

Agreed. I will switch to obj_cgroup through the series.

> 
> Thanks,
> Thomas
> 
> 
> > +
> >  /**
> >   * mem_cgroup_uncharge_dmabuf - uncharge a dma-buf from its memcg
> >   * @dmabuf: buffer to uncharge


