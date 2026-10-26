Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 703B660A2609
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 14:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=ERkprg9R
Received: by kanga.kvack.org (Postfix)
	id 8B7E96B05B1; Mon, 26 Oct 2026 10:54:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 868786B05B3; Mon, 26 Oct 2026 10:54:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7301D6B05B4; Mon, 26 Oct 2026 10:54:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4B5426B05B1
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 10:54:04 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9D6C24073D
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 14:54:03 +0000 (UTC)
X-FDA: 85365072366.20.FBD8D45
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id 118991C000A
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 14:54:00 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ERkprg9R;
	spf=pass (imf20.hostedemail.com: domain of aesteve@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793026441;
	b=l4o+mHwIUhoux4pQ5ve5n98m8IjVMqmNPUzSLgKmDFbTY9MHHk6jZrrHcrATDJgCHMRGfo
	W5gnOi6jWCEmoo80VunjYqOZ8Y1LHUH7cj4b+nUVhlVYiRbCRsgUj1Nq/XoMTX50tiDYDg
	QMMsm1YePe4EBPQITDt48HMAUYq0eow=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ERkprg9R;
	spf=pass (imf20.hostedemail.com: domain of aesteve@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793026441;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OKz8jQo/auRPZNzdWHUdE6yB8Ix7XlP0akY/URWqfWs=;
	b=7i4ZXih8e0zNMuLhK4FpMucLMcroXkec0IAVBtQ6gFWEW/6JpfZQh5q6JsEWSqlRh4L8Ru
	VZOL3wkSTLHeBOpnJB9HKshJMOd8PMDfJuAqYC6yELqFU/eOeJOCv2RImggDFCiIbWFL4S
	oAx9J4fPm7nVqJgq0g6Q7FYUrRaTkTo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793026440;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OKz8jQo/auRPZNzdWHUdE6yB8Ix7XlP0akY/URWqfWs=;
	b=ERkprg9RQDF0hLYEQEK6W4YCQtJjEBAQ2TsbjX0HNA7pDMMr9hxWvnDrf1AwjvOcUkPO8A
	i4B0XAr3Rm4srBQh/5THFEiFYLs7Necl9hh9WEIafQRRXJuQAtKtSphr0iU99grbeYdyuW
	Pjp5DevJWYd9DUES5b6nE5M3FfVpMkQ=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-629-4VqDJNfVMRuWHFx2oSImhQ-1; Mon, 26 Oct 2026 10:53:59 -0400
X-MC-Unique: 4VqDJNfVMRuWHFx2oSImhQ-1
X-Mimecast-MFC-AGG-ID: 4VqDJNfVMRuWHFx2oSImhQ_1793026438
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4a1895ffc83so22897995e9.3
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 07:53:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793026438; x=1793631238;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=OKz8jQo/auRPZNzdWHUdE6yB8Ix7XlP0akY/URWqfWs=;
        b=Eq13GMz3k0VOR/mua9q+Y995N1nxDC7r8dkxeLN3MI5xLvRH5qD+OdNcBnyZNiooME
         WZiDZ9P0KsN7UAXGwMILxcbnEzl6K5f+k5Nu93Knui+52aQDcllvp0tGPWZHnWl1Nx0f
         4CQK0KHwwiA1wH4JSDlYnxDUlRvaXLa0ko1pRqOr7XUs/NewseVkLj45M7iYicZFM32B
         fJarLizA+UH6WfWqnUWctUQ3ixydRODIt0jEEXXsxqGR6M4FcMP18sjHTBpvUwxi2Lp+
         ZY1O+xknsGK7QZw6BgLZUtwFlfs4VEWWTGm3nPhbpSKl8cJ7UxfvPf9Q0wH9tG9Frd8H
         lkzg==
X-Forwarded-Encrypted: i=1; AKwUvByO33E6Rxe62SW8lhhh/hPJul1Mhn9oLOcQedNKecFzCjljme48KmxDWts6fzerS1DACFv+MiJ0jw==@kvack.org
X-Gm-Message-State: AFq9FYLaVpV90XcOeVJGYxqyML4FUi11i1kDK03WP1vmZBhqTd/dAHFW
	SAbfSg/a90E7Lx3spToydesJMDQV8ITlSBNNoEM/Jszq+TIeMEm4QeullTlql0DAENIMG5r92LN
	dtJYZ0XCOexonCSi5ZUjyyz2ysPopjT93B5MXXJ0dt3u+vwKSJpM+
X-Gm-Gg: AYBFou2vfThUrmBon/SR6aivkOJw9WVHF7/M2QY1HIATQwlfnKh4C34lCZgBAkxAhU7
	puifK+6SXT4KHi8Qxh0YTdMYY0FtFja+nYc4YX1JrUKA8Ioe7VSpav9f3b0OtJdKwjSd9WSYPz5
	RQP1HK5DUt8e9C4hiSQR5QTsU+J9u87xGo3+IzMOWziiotnSNrWguEZhGnXrHf/xMTZfmrvmOWY
	ufvxGPa6+Fl0z/U6X1GAhszzeLmlICOCV8Mmf2xdfANwLm7leQMmaDuMi+otzK+N/UlI7dV3EGk
	GeBl7d+aazqWYPPeJxj75qt8uXXRC84FNA/o+F9ujXBC3T7LT3+yDCS5G/m5XebVBSI=
X-Received: by 2002:a05:600c:3487:b0:4a1:fba8:b13d with SMTP id 5b1f17b1804b1-4a35ac8c231mr138381735e9.9.1793026437551;
        Mon, 26 Oct 2026 07:53:57 -0700 (PDT)
X-Received: by 2002:a05:600c:3487:b0:4a1:fba8:b13d with SMTP id 5b1f17b1804b1-4a35ac8c231mr138381105e9.9.1793026437038;
        Mon, 26 Oct 2026 07:53:57 -0700 (PDT)
Received: from localhost ([46.6.57.114])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a35a0bac37sm213564065e9.6.2026.10.26.07.53.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 07:53:56 -0700 (PDT)
Date: Mon, 26 Oct 2026 15:53:54 +0100
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
	cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	linux-mm@kvack.org, linux-security-module@vger.kernel.org,
	selinux@vger.kernel.org, linux-kselftest@vger.kernel.org,
	mripard@kernel.org, echanude@redhat.com
Subject: Re: [PATCH RFC v2 7/8] dma-buf: transfer memcg charges via
 DMA_BUF_IOCTL_XFER_CHARGE
Message-ID: <at9pgl9sC8__GHlZ@aesteve-thinkpadp1gen8.rmtes.csb>
References: <20261021-v2_20230123_tjmercier_google_com-v2-0-ef6ee2dd8c5c@redhat.com>
 <20261021-v2_20230123_tjmercier_google_com-v2-7-ef6ee2dd8c5c@redhat.com>
 <9e54354d-b037-47e1-9390-86d5e25444a7@amd.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
In-Reply-To: <9e54354d-b037-47e1-9390-86d5e25444a7@amd.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: dfXCEEEI9UDpUmQo5AqfxUYb1HJBkKKrKFLG9wNyHNM_1793026438
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 118991C000A
X-Stat-Signature: ahnofkzoectk87kbzakensip13sini5w
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793026440-605053
X-HE-Meta: U2FsdGVkX1+PdImFL+as1eruE84vMyVW91LL98K8kPUkxQ2CMcjBrkJ+GgLJ609iMbuu3Ln4iLPzjjkevUiJpSL5OeXeHi/n5FTuN6qYVCoN/xJBKuirv/fZ5jLR/SJE2eiNpzvtLKZa1p/KWurtYT7YWW7x+D8Nr2Z7uLMiW8sHhYU2HYC4njRkQfFwBGOsNWh2JfrUEHiRFHfCXjdWBV5ZKK3b6BXdFGjPn24s/X494JJtOyg1IEQIjo1HL0nG0fs+qwvBUgwFjtbCUnW8XvSwLAPfJTTn616GETLmGVPoEXLBAdfJJbt4vJRmHeA3nDdTeq+KBD+STWYtEXGYscd/LVg0UHmca0eBIbQSO8p5wO61KEjSwIcQIzdGMfgSMVi4Hm6OEyAwT3QDF5HPDGc4BVtcbhMrDMvpKKhWWuHjH9xTaJ79VmPMsWgKj7Q+K+w8bdLw4JJrGHHCmetfn4SCb69OL6UhMZHBkTLTzk4ZIXj/k+s3IInGw7NFb7v4Smq5gxolqs2M9qS4qVTooABG+/nvrepkDke17UaZc2iQTN6Kmv8kjPx22/aVtVOaAMh85GqInEpOhfbiljIKYq0uMB6OqvRWZB6PN92DldsUNMjdBz5qujxJc/qps+/La0I0yretxEFzTJ+zBEyQsiz+4aE45sEwzReeXWKPZK8O/YMIUJpn6k4HRHsm7PpkuXzmYyari6PnKl9Qj8vYTsdHeD4TEBOw+bjlCJEvbGFknAf696gqsZ111X/8ASwIp+CECwHilCgw5o8qVYCw6+Rgj4+DvCc02hxqPg/WUHkfs/uPExEGj7P24HL+2qtOuPsysckJlQ7uDfEpn9JjOZWjsY/dET1R7urVsALdulwrReXmc6rg3HJ/xRfm0HrNhomAfl9AkXmYW/MO6WG7tHscLhgoA0avsHpCyulsOKP5R5dY93cJDx32ReeJSi3gUE+fzL+xGHHc8LXuzby
 ASlap7EQ
 HVkrXOAedkzPhIXW9CWP62uMi2xR1794QKAPye7YV420B9178RmWK6Tcmi+jKi8VRR4LpJDbmKzf0HhUYOv64FwtX/gNWZXMbm577GmjJZSfK+JIgTqwPxRVQSDEkGyzMKLQOg7gLKerFaR4pmQHzj906s7DH4ucL1TvyWJWVV8pUKFuhWKkmqaY2VjYi82HO8b/DFC9qkM1SlPZza+AnGwHKn9nqJyOizt272cVFHd8SvkKurUUWqv1ZR1+ciRGKuI5M4LZgyb/IE3dApWShHVutY7WsVbSTTV/m/HLWNUMvEFuawgQdg0BEkmVMVPvV5DAM/2QwpyNxcMwnWL+Oh1k7ZJtKTHye6MaOJ+ePbI+zgwV+7Ciil8ujf3CUa+ux+/6xwIhhkhBlhPZbr9rBbMem8Nq+8/l7oKR27jTrGksiTqmT3Fn8yVu3BgQx/6S+dVvYEr/oIIs9eblLgiAN/qZmN2AaLLgzojSnHdzWxwxI6vpCZeHg2yhJP17+kgvwvUN5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 22, 2026 at 12:23:57PM +0200, Christian König wrote:
> On 10/21/26 17:42, Albert Esteve wrote:
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
> > preserving the original charge on failure. An atomic cmpxchg on
> > dmabuf->memcg prevents races with concurrent transfers.
> > 
> > Usage example:
> >   int cg_fd = open("/sys/fs/cgroup/clients/app1", O_RDONLY | O_DIRECTORY);
> > 
> >   struct dma_buf_transfer_charge xfer = {
> >       .charge_fd = cg_fd,
> >   };
> >   ioctl(dmabuf_fd, DMA_BUF_IOCTL_XFER_CHARGE, &xfer);
> >   /* charge now on app1's cgroup */
> >   close(cg_fd);
> > 
> > Signed-off-by: Albert Esteve <aesteve@redhat.com>
> > ---
> >  drivers/dma-buf/dma-buf.c    | 77 ++++++++++++++++++++++++++++++++++++++++++++
> >  include/linux/memcontrol.h   |  9 ++++++
> >  include/uapi/linux/dma-buf.h | 26 +++++++++++++++
> >  mm/memcontrol.c              | 40 +++++++++++++++++++++++
> >  4 files changed, 152 insertions(+)
> > 
> > diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
> > index f31f49ebd0af..7fa607d9bf65 100644
> > --- a/drivers/dma-buf/dma-buf.c
> > +++ b/drivers/dma-buf/dma-buf.c
> > @@ -540,6 +540,80 @@ static long dma_buf_import_sync_file(struct dma_buf *dmabuf,
> >  }
> >  #endif
> >  
> 
> A single line code comment what this is all about would be nice to have.
> 
> Some note to look at struct dma_buf_transfer_charge for details is most likely good enough.

Sure, will add it for next version.

> 
> > +static long dma_buf_xfer_charge(struct dma_buf *dmabuf,
> > +				const void __user *user_data)
> > +{
> > +	struct cgroup *cgrp;
> > +	struct cgroup_subsys_state *css;
> > +	struct dma_buf_transfer_charge arg;
> > +	struct mem_cgroup *memcg;
> > +	struct task_struct *task;
> > +	const struct cred *tcred;
> > +	unsigned int pidfd_flags;
> > +	int ret = 0;
> > +
> > +	if (copy_from_user(&arg, user_data, sizeof(arg)))
> > +		return -EFAULT;
> > +
> > +	if (!IS_ENABLED(CONFIG_MEMCG))
> > +		return 0;
> > +
> > +	if (arg.__padding != 0)
> > +		return -EINVAL;
> > +
> > +	cgrp = cgroup_get_from_fd(arg.charge_fd);
> > +	if (!IS_ERR(cgrp)) {
> > +		/* charge_fd is a cgroupfd */
> > +		rcu_read_lock();
> > +		css = cgroup_css(cgrp, &memory_cgrp_subsys);
> > +		if (!css || !css_tryget_online(css)) {
> > +			rcu_read_unlock();
> > +			cgroup_put(cgrp);
> > +			return -ENOENT;
> > +		}
> > +
> > +		memcg = mem_cgroup_from_css(css);
> > +		rcu_read_unlock();
> > +
> > +		ret = security_dma_buf_charge_cgroup(current_cred(), cgrp);
> > +		cgroup_put(cgrp);
> > +		if (ret) {
> 
> 
> > +			mem_cgroup_put(memcg);
> > +			return ret;
> 
> Maybe use goto skip_transfer; instead?

Yeah. This is a copy from the ALLOC part sharing this logic.
I will refactor all this logic (extracting memcg from the fd)
into a function in memcontrol to clean up this mess.

> 
> > +		}
> > +	} else {
> > +		/* charge_fd is a pidfd  */
> > +		task = pidfd_get_task(arg.charge_fd, &pidfd_flags);
> > +		if (IS_ERR(task))
> > +			return PTR_ERR(task);
> > +
> > +		tcred = get_task_cred(task);
> > +		ret = security_dma_buf_charge_task(current_cred(), tcred);
> > +		put_cred(tcred);
> > +		if (ret) {
> > +			put_task_struct(task);
> > +			return ret;
> > +		}
> > +
> > +		memcg = get_mem_cgroup_from_mm(task->mm);
> > +		put_task_struct(task);
> > +	}
> > +
> > +	if (dmabuf->memcg == memcg)
> > +		goto skip_transfer;
> > +
> > +	if (!mem_cgroup_transfer_dmabuf_charge(dmabuf, memcg)) {
> > +		ret = -ENOMEM;
> > +		goto skip_transfer;
> > +	}
> > +
> > +	return 0;
> > +
> > +skip_transfer:
> > +	mem_cgroup_put(memcg);
> > +	return ret;
> > +}
> > +
> >  static long dma_buf_ioctl(struct file *file,
> >  			  unsigned int cmd, unsigned long arg)
> >  {
> > @@ -590,6 +664,9 @@ static long dma_buf_ioctl(struct file *file,
> >  		return dma_buf_import_sync_file(dmabuf, (const void __user *)arg);
> >  #endif
> >  
> > +	case DMA_BUF_IOCTL_XFER_CHARGE:
> > +		return dma_buf_xfer_charge(dmabuf, (const void __user *)arg);
> > +
> >  	default:
> >  		return -ENOTTY;
> >  	}
> > diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> > index aa08fbb0c26c..3a6acfda1423 100644
> > --- a/include/linux/memcontrol.h
> > +++ b/include/linux/memcontrol.h
> > @@ -674,6 +674,9 @@ int mem_cgroup_swapin_charge_folio(struct folio *folio, unsigned short id,
> >  bool mem_cgroup_charge_dmabuf(struct dma_buf *dmabuf, struct mem_cgroup *memcg,
> >  			      gfp_t gfp_mask);
> >  
> > +bool mem_cgroup_transfer_dmabuf_charge(struct dma_buf *dmabuf,
> > +				       struct mem_cgroup *new_memcg);
> > +
> >  void __mem_cgroup_uncharge(struct folio *folio);
> >  
> >  /**
> > @@ -1183,6 +1186,12 @@ static inline bool mem_cgroup_charge_dmabuf(struct dma_buf *dmabuf,
> >  	return true;
> >  }
> >  
> > +static inline bool mem_cgroup_transfer_dmabuf_charge(struct dma_buf *dmabuf,
> > +						     struct mem_cgroup *new_memcg)
> > +{
> > +	return true;
> > +}
> > +
> >  static inline void mem_cgroup_uncharge(struct folio *folio)
> >  {
> >  }
> > diff --git a/include/uapi/linux/dma-buf.h b/include/uapi/linux/dma-buf.h
> > index e827c9d20c5d..4970a7b8e08e 100644
> > --- a/include/uapi/linux/dma-buf.h
> > +++ b/include/uapi/linux/dma-buf.h
> > @@ -168,6 +168,31 @@ struct dma_buf_import_sync_file {
> >  	__s32 fd;
> >  };
> >  
> > +/**
> > + * struct dma_buf_transfer_charge - Transfer a dma-buf's memcg charge
> > + *
> > + * Any holder of a dma-buf file descriptor can perform a
> > + * DMA_BUF_IOCTL_XFER_CHARGE to attribute the buffer's memory
> > + * cost to a specific cgroup, or move it from one cgroup to
> > + * another.  The ioctl charges the new cgroup before uncharging
> > + * the old one atomically.  On failure the original charge is
> > + * preserved.  If the buffer has no existing charge, a new
> > + * charge is established.
> > + */
> > +struct dma_buf_transfer_charge {
> > +	/**
> > +	 * @charge_fd: File descriptor identifying the target cgroup.
> > +	 *
> > +	 * May be either a pidfd, in which case the charge moves to the
> > +	 * memory cgroup of the referenced process, or a cgroupfd obtained
> > +	 * by opening a cgroup v2 directory, in which case the charge moves
> > +	 * directly to that cgroup's memory controller.
> > +	 */
> > +	__u32 charge_fd;
> > +	/** @__padding: Reserved, must be zero */
> > +	__u32 __padding;
> 
> Maybe rename to flags, put before charge_fd and add "/* unused for now */".

Agreed.

> 
> > +};
> > +
> >  #define DMA_BUF_BASE		'b'
> >  #define DMA_BUF_IOCTL_SYNC	_IOW(DMA_BUF_BASE, 0, struct dma_buf_sync)
> >  
> > @@ -179,5 +204,6 @@ struct dma_buf_import_sync_file {
> >  #define DMA_BUF_SET_NAME_B	_IOW(DMA_BUF_BASE, 1, __u64)
> >  #define DMA_BUF_IOCTL_EXPORT_SYNC_FILE	_IOWR(DMA_BUF_BASE, 2, struct dma_buf_export_sync_file)
> >  #define DMA_BUF_IOCTL_IMPORT_SYNC_FILE	_IOW(DMA_BUF_BASE, 3, struct dma_buf_import_sync_file)
> > +#define DMA_BUF_IOCTL_XFER_CHARGE	_IOW(DMA_BUF_BASE, 4, struct dma_buf_transfer_charge)
> >  
> >  #endif
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index e94222237d31..d994a4b2d35e 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -5688,6 +5688,46 @@ bool mem_cgroup_charge_dmabuf(struct dma_buf *dmabuf, struct mem_cgroup *memcg,
> >  	return true;
> >  }
> >  
> > +/**
> > + * mem_cgroup_transfer_dmabuf_charge - move a dma-buf charge
> > + * @dmabuf: buffer to transfer charge
> > + * @new_memcg: target memcg; caller must hold a reference
> > + *
> > + * Transfers the charge for @dmabuf to @new_memcg and, on
> > + * success, stores @new_memcg in @dmabuf->memcg.
> > + * Returns %true on success, %false if the charge against @new_memcg
> > + * failed or a concurrent transfer raced on @dmabuf->memcg.
> > + * On failure the caller retains its reference to @new_memcg.
> > + */
> > +bool mem_cgroup_transfer_dmabuf_charge(struct dma_buf *dmabuf,
> > +				       struct mem_cgroup *new_memcg)
> > +{
> > +	struct mem_cgroup *old_memcg = READ_ONCE(dmabuf->memcg);
> > +	unsigned int nr_pages = PAGE_ALIGN(dmabuf->size) >> PAGE_SHIFT;
> 
> That doesn't work as easily as this.
> 
> DMA-buf can contain litterally *anything*, ranging from system memory over device memory all the way to functional HW blocks. In other words doorbell, GWS, GDS, OA, I2C, I2S, any random data consuming or providng HW block...
> 
> For memory the "size" is the actually number of bytes the buffer represents, but for everything else it is just an arbitary number given by the exporter. In most cases just 1 or actually number of HW blocks/channels, but for GDS for example it is actually a pretty large number.

I don't think I was completely aware of all these uses for dma-bufs and
the specific meanings of the size for all them. Thanks for pointing this
out.

> 
> Saying that you most likely need some flag from the exporter if charging and/or the changing of charging should be possible or not. Otherwise you can potentially do quite a bunch of nonsense with that.

Yes, a flag seems to be simple solution for the problem at hand. I can
focus on the system heap for now, and it can be easily extended in the
future for other allocators as needed.

> 
> Regards,
> Christian.
> 
> > +
> > +	if (!mem_cgroup_disabled() && try_charge(new_memcg, GFP_KERNEL, nr_pages))
> > +		return false;
> > +
> > +	if (cmpxchg(&dmabuf->memcg, old_memcg, new_memcg) != old_memcg) {
> > +		if (!mem_cgroup_is_root(new_memcg))
> > +			refill_stock(new_memcg, nr_pages);
> > +		return false;
> > +	}
> > +
> > +	mod_memcg_state(new_memcg, MEMCG_DMABUF, nr_pages);
> > +
> > +	if (old_memcg) {
> > +		/* Uncharge old cgroup */
> > +		mod_memcg_state(old_memcg, MEMCG_DMABUF, -nr_pages);
> > +		if (!mem_cgroup_is_root(old_memcg))
> > +			refill_stock(old_memcg, nr_pages);
> > +		/* unref from buffer - buffer keeps new ref to new_memcg */
> > +		mem_cgroup_put(old_memcg);
> > +	}
> > +
> > +	return true;
> > +}
> > +
> >  /**
> >   * mem_cgroup_uncharge_dmabuf - uncharge a dma-buf from its memcg
> >   * @dmabuf: buffer to uncharge
> > 
> 


