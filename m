Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7914660A2603
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 16:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=CwZBA+/H
Received: by kanga.kvack.org (Postfix)
	id 977D76B0609; Thu, 29 Oct 2026 12:24:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94F426B060A; Thu, 29 Oct 2026 12:24:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83D786B060B; Thu, 29 Oct 2026 12:24:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5C57E6B0609
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 12:24:07 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A3303A7D75
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:24:06 +0000 (UTC)
X-FDA: 85376185692.26.3A2FC2C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3A460120007
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:24:04 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="CwZBA+/H";
	spf=pass (imf29.hostedemail.com: domain of aesteve@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793291044;
	b=sBByG/IO2QWdK7hvs2B1mPr7mhgRRkKMFyNtiBGDA2vH+zLFLUEvmRkiC9qPx3oF+sVItB
	d5MkoSLycewbzEuUlnyZ2mn6fLQp29s2URgCd6aL9eGpZHpZztjufFrHeNVf5p4sFX5Q3u
	q7PRLDHjJzUtLXtxMiaUlZTKYguS10Q=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="CwZBA+/H";
	spf=pass (imf29.hostedemail.com: domain of aesteve@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793291044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ghsxH7KtDt6p02loMMjMSbIAhef8R3L73+2Haf8kghk=;
	b=ArsWw+GnyBOmNUi3uDdlp3BFGVs7F6htyXxGAtgIWqkhzLviPUdfQ/uFb+EfRSYlvLRE5M
	hfxO58tlv8DPGu33KxserKimGp5Kq0WoVXi4b8xLqRKa0vruaFHkyeKftFW2CPcvntedh8
	atXHiw+yd4gq19f5Vkyo9LHh6xW2dBM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793291043;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ghsxH7KtDt6p02loMMjMSbIAhef8R3L73+2Haf8kghk=;
	b=CwZBA+/HQFavIgsxe2BBvJnN5cSWlOG453CLSVCAa2qvPYXujat6LiWg/vtijwrlz/FG0i
	IAPfhBGqLPHIr3GD8uqQd4iBKed0LNVSZacLbeyS5a+NHoIO0gtKETTB1k/iuRaXoMcdG4
	f1Q5jq0cas3YOBhw/IciinNLs2qf4a8=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-378-RWyDoO2TMlaBTnOtLIQ5XA-1; Thu, 29 Oct 2026 12:24:02 -0400
X-MC-Unique: RWyDoO2TMlaBTnOtLIQ5XA-1
X-Mimecast-MFC-AGG-ID: RWyDoO2TMlaBTnOtLIQ5XA_1793291041
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4a359c7f47bso19605305e9.2
        for <linux-mm@kvack.org>; Thu, 29 Oct 2026 09:24:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793291041; x=1793895841;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=ghsxH7KtDt6p02loMMjMSbIAhef8R3L73+2Haf8kghk=;
        b=xSuLuKoEeGiFvTa5pE4ZYWAhJXfYu/rFR+dVyfH0HuCJgbO5+kUxg/43h/lT9f8yZ2
         Blq9FhIfO+t+W9sQ0e3ZMJbOM+mhUwdNtNFK2LQ+M4GJEtvXoqNdwDmpUpBF7p4XyXZ4
         kMHZe7vNcOZACFZEGleUlUhmeb+I6I2Vr1jdMfe9tnukIgyQQ9jd6u5GMf438CzpCApB
         JGT/zYhJHjvaiF7zJkEVr7grHMM/nEhshPFeqZEUIoanBLGED6YJTwNm9rGsLZL/otBk
         9WaT8i22sG31GmwM6rtmLm8rcD8D7vZjJN1c397tFWyIwFFRwvFsNMYe1KXrdnbESzfw
         sjwg==
X-Forwarded-Encrypted: i=1; AKwUvBz8GKOJzwmpuDE1RWCELnDPD1Aov7m+Ns3vFJsrnbfib003wM7PDhuddJgnLDgEHS+QZnpG44HjlQ==@kvack.org
X-Gm-Message-State: AFq9FYK60M6aKy2ljiOOKo1ivuqcf9PEISCmMHs+j5dyNPZ0YCwwAsk8
	9cmo6ByneO/WJA3bp24H1QuIQO3dYQjvoNfsjid76UQv4adCLOVVspgDBoPIMxIO53ZXtWUG6tg
	jyvhoYGmzC+Rn2yKI7E2MKXYUjT2EDkI1dKYoRa2Rvd5PTAbqVx0O
X-Gm-Gg: AYBFou1NBZ+uX4Dni8MN/ywEYxhcl69DZGuXSbwTyhKUa4459RZR0KEs/cq+B/aN+0J
	5LQ2IOnEIgMITL3hXJTfpLPphgoycKVX+Jxtjtb8Iz0QaQws2GYU0N4qOKF37edz5nAwG0r20F1
	EOW1/Yg1L7bhmJY4g6OrwGv1lowKfRIeBJSNZoZ0OY86QUCicnfh+vERofvtADcpCumiwsHKOWd
	UQuAIzlTFGXl0XCX8NTN8MunfBesxSCt2mISAneASikjC4kLCOLi135Z1EuMa995hJlaPU35EWt
	5wyeiyFxnxv/9KzgXgoAxP2/dHWdMq33DGPlRlj7Czu95azKuRX1zqbtgKde0Pb3d7oV62EAPef
	82/IY2eayj2ZiIAFa1Ac8gnB5PwDlm9x7jze7Ai0vKC0=
X-Received: by 2002:a05:600c:4455:b0:4a3:59c7:f226 with SMTP id 5b1f17b1804b1-4a965ec950amr131385445e9.6.1793291040732;
        Thu, 29 Oct 2026 09:24:00 -0700 (PDT)
X-Received: by 2002:a05:600c:4455:b0:4a3:59c7:f226 with SMTP id 5b1f17b1804b1-4a965ec950amr131384485e9.6.1793291040202;
        Thu, 29 Oct 2026 09:24:00 -0700 (PDT)
Received: from localhost ([139.47.30.142])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a94f05e4e4sm90190855e9.3.2026.10.29.09.23.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 09:23:59 -0700 (PDT)
Date: Thu, 29 Oct 2026 17:23:58 +0100
From: Albert Esteve <aesteve@redhat.com>
To: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
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
	linux-kselftest@vger.kernel.org, op-tee@lists.trustedfirmware.org,
	echanude@redhat.com, mripard@kernel.org
Subject: Re: [PATCH v3 7/8] dma-buf: transfer memcg charges via
 DMA_BUF_IOCTL_XFER_CHARGE
Message-ID: <auNzHjhT5xezyZ4I@aesteve-thinkpadp1gen8.rmtes.csb>
References: <20261027-v2_20230123_tjmercier_google_com-v3-0-78d2c4cb8647@redhat.com>
 <20261027-v2_20230123_tjmercier_google_com-v3-7-78d2c4cb8647@redhat.com>
 <d76d8bfe-e955-4e90-9f5f-e3e914c0869c@amd.com>
 <auIeQU0nAnOLdKUB@aesteve-thinkpadp1gen8.rmtes.csb>
 <9ebce3f2-f7a0-46a9-bad7-39059b99423f@amd.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
In-Reply-To: <9ebce3f2-f7a0-46a9-bad7-39059b99423f@amd.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: YQ1-2dug_kmIfALFIMVpSgSDo-pDqvvTZe9xObk6Oqs_1793291041
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 59fcrjs7f41aygupb6dqgigry766iupe
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3A460120007
X-Rspam-User: 
X-HE-Tag: 1793291044-177044
X-HE-Meta: U2FsdGVkX1/G6HnWDg5YCtGdvXs68Ibw/DmsjJgDU5ymkvUc9fc+j/VF+ypj9p7XwrfZhDeVAP+RmSGwM5OM2TJXf7bsGyLd/gWyP9jjqmd1znC1Wc/y1bcu+9H2OM6YsG3akly8EoBTB9Lsjxs90FaD19IbgLR5R8f7XmzefxA3xlYfNavQzInD13GtmGBJ2FmDOksg1Vn/b8ysa3PStieqFQ4yr6Xc+6IsIlbL65GjgVP5J7zvfprpO0C9kAV0BbGVpdEi7AUVpKAs5ueKiagcLCxvs/jtnKL0B+yG4H/8Yodqzb2Bs+h4uFr0cNA3CdlrVRFaEe7fSpDdi6n3wmxKKi2u9YZiJUpDmYLB8Osxx76MinpvKsM2fopNRs/h3aOiaox+VTb1gbrveZloCXT2+hagUbvhDpsUJReNlrmakI041OjLKX17v5v+kjbe9QyLI85kEGpdADeqGUhX0ELbJUtde0/PsuqWlcQm44KXAzQ4bt5e/8eGkD9Abif58rignSLs8m0tThzVEBGXbO6BYEvAlTDTzDP13V7SPzk9xDWMkqNNOz6YeqOXf8Zb5qPB8zt7LTg/qJsXBpLg3FPtmwOhaqmeqS4ckBlEXS67UxUzcdyonTDMVqKuiUNbH6ANVm39T1R4Vob8R6a0jKT+0eacjx/o1AqcWdRdSeGLOgtt3nJdIRKklswUzMmWhfK1IbXfMS4fbdR5N8hOMxk/PANS+QNa4QPoo5H/PQkj/W3jnjoWULJBEPb6rdgskXzpdCNi8Bsern/LxCqOO4QeEvYoEk7Gm9BJeUehRYWn1vbpk8EvSBJ6ov4E+g8ItnOkxuvga6KlKMYDV4lJPuOHEeOlMMGQeVwN+tv5OQQ82+Osiegwjhbz6r7YgTxvT/Wo6FOZR86opsbjBCaKdW3BISykoYXLpk1mFEQXO+4k4oIitJQ3dTA39JfM7cS3vVWRzR4J7vZGDxLhJG0
 hf/drg52
 C7+xEOXOUr/0sBGyRkQxd9Qvnad0lsGs45aBM+8zc5/PaCvIgZUY3sbhgKOPnJ12NimwWYtvvcd4CsbHOU0b5KSm2y8GlTHDQ2F76+IAdPq1i47oX05xLzYE9u9KykLgXbfNZQADvnuCmxC4nKj1t8IvjmCOY/Yy/O59PkCRmryabbzn2OlrUmfCzUbG7tXusOHmGQdzKImi4zq3eKlQb6RQ7uMiw2Vr3qhQdQUeUPG05hcnC0Dr6pcszC576bfeSCIvERe2CCkRMI/tK3sDlfn/om56/ydwzb2QGKfsylQ4UvxRtiVqBH1XAA+AZ4FcQqVlE6bAdRFPDS60YXV043oKgG/5MqnGKCZdV23ig7D9r83Ys+EiYZOso+rrgfLr0oePhCvwO7+9g/UIEJ4m8qShwN0XfgI/tOMbiAFbs3xdLz5lEVuAw4jrWIs+qd6r9yHRIEN8V/lmvNfidSa5lzauNN3KZXEYLkbSnY8J/YbwWM5aY/PPvUBk0qhms/eN5/1gc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 29, 2026 at 03:16:12PM +0100, Christian König wrote:
> On 10/28/26 17:09, Albert Esteve wrote:
> > On Wed, Oct 28, 2026 at 10:08:19AM +0100, Christian König wrote:
> >> On 10/27/26 16:02, Albert Esteve wrote:
> >>> dma-heap already supports charging a specific cgroup at allocation
> >>> time via charge_fd in DMA_HEAP_IOCTL_ALLOC. However, dma-bufs can
> >>> originate from any exporter (DRM, V4L2, etc.), and the allocator may
> >>> not know the final owner at allocation time.
> >>>
> >>> Add DMA_BUF_IOCTL_XFER_CHARGE to transfer a dma-buf's memcg charge
> >>> to a different cgroup after allocation. The target is identified by
> >>> charge_fd, which may be a cgroupfd or a pidfd.
> >>>
> >>> The transfer charges the new cgroup before uncharging the old one,
> >>> preserving the original charge on failure. An atomic cmpxchg on
> >>> dmabuf->memcg prevents races with concurrent transfers.
> >>>
> >>> Not all dma-buf exporters back their buffers with reclaimable system
> >>> memory. Some represent device registers, VRAM, or carved-out pools
> >>> where size is not a meaningful memory cost. Add a memcg_account flag
> >>> to dma_buf_export_info that exporters set when their buffers should
> >>> participate in memcg accounting. The xfer ioctl returns -EOPNOTSUPP
> >>> for buffers that do not set the flag. Currently only the system heap
> >>> sets it, other exporters can opt in as needed.
> >>>
> >>> Usage example:
> >>>   int cg_fd = open("/sys/fs/cgroup/clients/app1", O_RDONLY | O_DIRECTORY);
> >>>
> >>>   struct dma_buf_transfer_charge xfer = {
> >>>       .charge_fd = cg_fd,
> >>>   };
> >>>   ioctl(dmabuf_fd, DMA_BUF_IOCTL_XFER_CHARGE, &xfer);
> >>>   /* charge now on app1's cgroup */
> >>>   close(cg_fd);
> >>>
> >>> Signed-off-by: Albert Esteve <aesteve@redhat.com>
> >>> ---
> >>>  drivers/dma-buf/dma-buf.c           | 43 +++++++++++++++++++++++++++++++++++++
> >>>  drivers/dma-buf/heaps/system_heap.c |  1 +
> >>>  include/linux/dma-buf.h             |  5 +++++
> >>>  include/linux/memcontrol.h          |  9 ++++++++
> >>>  include/uapi/linux/dma-buf.h        | 26 ++++++++++++++++++++++
> >>>  mm/memcontrol.c                     | 41 +++++++++++++++++++++++++++++++++++
> >>>  6 files changed, 125 insertions(+)
> >>>
> >>> diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
> >>> index f31f49ebd0af..07513ecedc10 100644
> >>> --- a/drivers/dma-buf/dma-buf.c
> >>> +++ b/drivers/dma-buf/dma-buf.c
> >>> @@ -540,6 +540,45 @@ static long dma_buf_import_sync_file(struct dma_buf *dmabuf,
> >>>  }
> >>>  #endif
> >>>  
> >>> +/* Transfer a dma-buf's memcg charge; see struct dma_buf_transfer_charge */
> >>> +static long dma_buf_xfer_charge(struct dma_buf *dmabuf,
> >>> +				const void __user *user_data)
> >>> +{
> >>> +	struct dma_buf_transfer_charge arg;
> >>> +	struct mem_cgroup *memcg;
> >>> +	int ret = 0;
> >>> +
> >>> +	if (copy_from_user(&arg, user_data, sizeof(arg)))
> >>> +		return -EFAULT;
> >>> +
> >>> +	if (!IS_ENABLED(CONFIG_MEMCG))
> >>> +		return 0;
> >>> +
> >>> +	if (arg.flags != 0)
> >>> +		return -EINVAL;
> >>> +
> >>> +	if (!dmabuf->memcg_account)
> >>> +		return -EOPNOTSUPP;
> >>> +
> >>> +	memcg = mem_cgroup_get_from_fd(arg.charge_fd);
> >>> +	if (IS_ERR(memcg))
> >>> +		return PTR_ERR(memcg);
> >>> +
> >>> +	if (dmabuf->memcg == memcg)
> >>> +		goto skip_transfer;
> >>> +
> >>> +	if (!mem_cgroup_transfer_dmabuf_charge(dmabuf, memcg)) {
> >>> +		ret = -ENOMEM;
> >>> +		goto skip_transfer;
> >>> +	}
> >>> +
> >>> +	return 0;
> >>> +
> >>> +skip_transfer:
> >>> +	mem_cgroup_put(memcg);
> >>> +	return ret;
> >>> +}
> >>> +
> >>>  static long dma_buf_ioctl(struct file *file,
> >>>  			  unsigned int cmd, unsigned long arg)
> >>>  {
> >>> @@ -590,6 +629,9 @@ static long dma_buf_ioctl(struct file *file,
> >>>  		return dma_buf_import_sync_file(dmabuf, (const void __user *)arg);
> >>>  #endif
> >>>  
> >>> +	case DMA_BUF_IOCTL_XFER_CHARGE:
> >>> +		return dma_buf_xfer_charge(dmabuf, (const void __user *)arg);
> >>> +
> >>>  	default:
> >>>  		return -ENOTTY;
> >>>  	}
> >>> @@ -750,6 +792,7 @@ struct dma_buf *dma_buf_export(const struct dma_buf_export_info *exp_info)
> >>>  	dmabuf->size = exp_info->size;
> >>>  	dmabuf->exp_name = exp_info->exp_name;
> >>>  	dmabuf->owner = exp_info->owner;
> >>> +	dmabuf->memcg_account = exp_info->memcg_account;
> >>
> >> The initial charging should probably be done here as well.
> >>
> >> This way DMA-buf heaps only needs to pass in the charge_fd and we can re-use the functionality for other DMA-buf exporters as well.
> > 
> > The problem with doing the charge here is that it happens too late.
> > That is the reasoning for this proposal to move all the charging logic
> > into heap allocators before pages are allocated.
> 
> Oh, that is a really good point we need to talk about.
> 
> DMA-buf heaps is actually a rather simple use case, but we have way more complex things.
> 
> For example in some use cases the backing store of a DMA-buf is only allocated on first use and only then it needs to be comitted to it's memcg or dmem.

Yes. The idea is focus on heaps for now. But the uAPI is actually
agnostic of the time when the charge happens. When we deal with
lazy-allocation in the future we can just call the reserve/cancel
helpers wherever is more appropiate. As long as the pages are not
allocated, exporters do not set dmabuf->memcg, and XFER does not
work (returns -EOPNOTSUPP).

> 
> I don't mind implementing it for DMA-buf heaps first, but we should have the uAPI and it's handling so solid that it also works for future use cases.

Agreed. I think we should cover all usecases with the current status.
Your feedback helped a lot in getting there!

> > What we could do is fill the dmabuf->memcg field when the flag is set
> > (i.e., committing into the dmabuf in the patch semantics). But for that
> > we'd need adding the memcg we want to charge it to into exp_info in
> > order to support charging to cgroups other than the allocator's (for
> > the common case would be simpler as we can just look at current).
> > Maybe that's what you meant?
> 
> At least for the DMA-buf heaps use case that sounds reasonable for now.

Thanks! Next version will have the flag removed and just use
dmabuf->memcg as indicator, set within dma_buf_export().
Also, `nr_pages` will be computed within dma_buf_export(), the
contract being that exporters setting exp_info.memcg assert that
size reflects actual system memory bytes.

> 
> Regards,
> Christian.
> 
> > 
> >>
> >>>  	spin_lock_init(&dmabuf->name_lock);
> >>>  	init_waitqueue_head(&dmabuf->poll);
> >>>  	dmabuf->cb_in.poll = dmabuf->cb_out.poll = &dmabuf->poll;
> >>> diff --git a/drivers/dma-buf/heaps/system_heap.c b/drivers/dma-buf/heaps/system_heap.c
> >>> index adeea8cd328b..a764167167ba 100644
> >>> --- a/drivers/dma-buf/heaps/system_heap.c
> >>> +++ b/drivers/dma-buf/heaps/system_heap.c
> >>> @@ -479,6 +479,7 @@ static struct dma_buf *system_heap_allocate(struct dma_heap *heap,
> >>>  	exp_info.size = buffer->len;
> >>>  	exp_info.flags = fd_flags;
> >>>  	exp_info.priv = buffer;
> >>> +	exp_info.memcg_account = true;
> >>>  	dmabuf = dma_buf_export(&exp_info);
> >>>  	if (IS_ERR(dmabuf)) {
> >>>  		ret = PTR_ERR(dmabuf);
> >>> diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
> >>> index 23ec0ff23fba..ac0ec88cab93 100644
> >>> --- a/include/linux/dma-buf.h
> >>> +++ b/include/linux/dma-buf.h
> >>> @@ -433,6 +433,9 @@ struct dma_buf {
> >>>  
> >>>  	/** @memcg: the cgroup to which this buffer is currently attributed */
> >>>  	struct mem_cgroup *memcg;
> >>> +
> >>> +	/** @memcg_account: account buffer memory to cgroup */
> >>> +	bool memcg_account;
> >>>  };
> >>>  
> >>>  /**
> >>> @@ -505,6 +508,7 @@ struct dma_buf_attachment {
> >>>   * @flags:	mode flags for the file
> >>>   * @resv:	reservation-object, NULL to allocate default one
> >>>   * @priv:	Attach private data of allocator to this buffer
> >>> + * @memcg_account:	account buffer memory to cgroup
> >>>   *
> >>>   * This structure holds the information required to export the buffer. Used
> >>>   * with dma_buf_export() only.
> >>> @@ -517,6 +521,7 @@ struct dma_buf_export_info {
> >>>  	int flags;
> >>>  	struct dma_resv *resv;
> >>>  	void *priv;
> >>> +	bool memcg_account;
> >>>  };
> >>>  
> >>>  /**
> >>> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> >>> index 6b30baa79fa9..36fddafbef4e 100644
> >>> --- a/include/linux/memcontrol.h
> >>> +++ b/include/linux/memcontrol.h
> >>> @@ -679,6 +679,9 @@ bool mem_cgroup_reserve_dmabuf(struct mem_cgroup *memcg, gfp_t gfp,
> >>>  void mem_cgroup_commit_dmabuf(struct dma_buf *dmabuf, struct mem_cgroup *memcg,
> >>>  			      unsigned int nr_pages);
> >>>  
> >>> +bool mem_cgroup_transfer_dmabuf_charge(struct dma_buf *dmabuf,
> >>> +				       struct mem_cgroup *new_memcg);
> >>> +
> >>>  void __mem_cgroup_uncharge(struct folio *folio);
> >>>  
> >>>  /**
> >>> @@ -1206,6 +1209,12 @@ static inline void mem_cgroup_cancel_dmabuf(struct mem_cgroup *memcg,
> >>>  {
> >>>  }
> >>>  
> >>> +static inline bool mem_cgroup_transfer_dmabuf_charge(struct dma_buf *dmabuf,
> >>> +						     struct mem_cgroup *new_memcg)
> >>> +{
> >>> +	return true;
> >>> +}
> >>> +
> >>>  static inline void mem_cgroup_uncharge(struct folio *folio)
> >>>  {
> >>>  }
> >>> diff --git a/include/uapi/linux/dma-buf.h b/include/uapi/linux/dma-buf.h
> >>> index e827c9d20c5d..ea957f4b1d38 100644
> >>> --- a/include/uapi/linux/dma-buf.h
> >>> +++ b/include/uapi/linux/dma-buf.h
> >>> @@ -168,6 +168,31 @@ struct dma_buf_import_sync_file {
> >>>  	__s32 fd;
> >>>  };
> >>>  
> >>> +/**
> >>> + * struct dma_buf_transfer_charge - Transfer a dma-buf's memcg charge
> >>> + *
> >>> + * Any holder of a dma-buf file descriptor can perform a
> >>> + * DMA_BUF_IOCTL_XFER_CHARGE to attribute the buffer's memory
> >>> + * cost to a specific cgroup, or move it from one cgroup to
> >>> + * another.  The ioctl charges the new cgroup before uncharging
> >>> + * the old one atomically.  On failure the original charge is
> >>> + * preserved.  If the buffer has no existing charge, a new
> >>> + * charge is established.
> >>> + */
> >>> +struct dma_buf_transfer_charge {
> >>> +	/** @flags: Reserved, must be zero */
> >>> +	__u32 flags; /* unused for now */
> >>> +	/**
> >>> +	 * @charge_fd: File descriptor identifying the target cgroup.
> >>> +	 *
> >>> +	 * May be either a pidfd, in which case the charge moves to the
> >>> +	 * memory cgroup of the referenced process, or a cgroupfd obtained
> >>> +	 * by opening a cgroup v2 directory, in which case the charge moves
> >>> +	 * directly to that cgroup's memory controller.
> >>> +	 */
> >>> +	__u32 charge_fd;
> >>> +};
> >>> +
> >>>  #define DMA_BUF_BASE		'b'
> >>>  #define DMA_BUF_IOCTL_SYNC	_IOW(DMA_BUF_BASE, 0, struct dma_buf_sync)
> >>>  
> >>> @@ -179,5 +204,6 @@ struct dma_buf_import_sync_file {
> >>>  #define DMA_BUF_SET_NAME_B	_IOW(DMA_BUF_BASE, 1, __u64)
> >>>  #define DMA_BUF_IOCTL_EXPORT_SYNC_FILE	_IOWR(DMA_BUF_BASE, 2, struct dma_buf_export_sync_file)
> >>>  #define DMA_BUF_IOCTL_IMPORT_SYNC_FILE	_IOW(DMA_BUF_BASE, 3, struct dma_buf_import_sync_file)
> >>> +#define DMA_BUF_IOCTL_XFER_CHARGE	_IOW(DMA_BUF_BASE, 4, struct dma_buf_transfer_charge)
> >>>  
> >>>  #endif
> >>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> >>> index 7b841b905759..3adc84fe6668 100644
> >>> --- a/mm/memcontrol.c
> >>> +++ b/mm/memcontrol.c
> >>> @@ -5786,6 +5786,47 @@ void mem_cgroup_cancel_dmabuf(struct mem_cgroup *memcg, unsigned int nr_pages)
> >>>  		refill_stock(memcg, nr_pages);
> >>>  }
> >>>  
> >>> +/**
> >>> + * mem_cgroup_transfer_dmabuf_charge - move a dma-buf charge
> >>> + * @dmabuf: buffer to transfer charge
> >>> + * @new_memcg: target memcg; caller must hold a reference
> >>> + *
> >>> + * Transfers the charge for @dmabuf to @new_memcg and, on
> >>> + * success, stores @new_memcg in @dmabuf->memcg.
> >>> + * Returns %true on success, %false if the charge against @new_memcg
> >>> + * failed or a concurrent transfer raced on @dmabuf->memcg.
> >>> + * On failure the caller retains its reference to @new_memcg.
> >>> + */
> >>> +bool mem_cgroup_transfer_dmabuf_charge(struct dma_buf *dmabuf,
> >>> +				       struct mem_cgroup *new_memcg)
> >>
> >> I would make that more generic instead of dmabuf specific. E.g. something like this:
> >>
> >> bool mem_cgroup_transfer_charge(struct struct mem_cgroup **ptr_memcg, struct mem_cgroup *new_memcg, enum memcg_stat_item item, unsigned int nr_pages)
> > 
> > Ah yes, I like this generalization. And the implementation remains
> > mostly the same. Thanks!
> > 
> >>
> >>> +{
> >>> +	struct mem_cgroup *old_memcg = READ_ONCE(dmabuf->memcg);
> >>
> >>> +	unsigned int nr_pages = PAGE_ALIGN(dmabuf->size) >> PAGE_SHIFT;
> >>
> >> This way we can also document in the DMA-buf caller that this conversation must be ok when memcg_account is true.
> >>
> >> Regards,
> >> Christian.
> >>
> >>> +
> >>> +	if (mem_cgroup_disabled())
> >>> +		return true;
> >>> +
> >>> +	if (!mem_cgroup_reserve_dmabuf(new_memcg, GFP_KERNEL, nr_pages))
> >>> +		return false;
> >>> +
> >>> +	mod_memcg_state(new_memcg, MEMCG_DMABUF, nr_pages);
> >>> +
> >>> +	if (cmpxchg(&dmabuf->memcg, old_memcg, new_memcg) != old_memcg) {
> >>> +		mod_memcg_state(new_memcg, MEMCG_DMABUF, -nr_pages);
> >>> +		mem_cgroup_cancel_dmabuf(new_memcg, nr_pages);
> >>> +		return false;
> >>> +	}
> >>> +
> >>> +	if (old_memcg) {
> >>> +		/* Uncharge old cgroup */
> >>> +		mod_memcg_state(old_memcg, MEMCG_DMABUF, -nr_pages);
> >>> +		mem_cgroup_cancel_dmabuf(old_memcg, nr_pages);
> >>> +		mem_cgroup_put(old_memcg);
> >>> +	}
> >>> +
> >>> +	return true;
> >>> +}
> >>> +
> >>>  /**
> >>>   * mem_cgroup_uncharge_dmabuf - uncharge a dma-buf from its memcg
> >>>   * @dmabuf: buffer to uncharge
> >>>
> >>
> > 
> 


