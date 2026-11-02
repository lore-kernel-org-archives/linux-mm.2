Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5A55606A32D
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 09:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=NMkdta0l
Received: by kanga.kvack.org (Postfix)
	id B52F06B05BC; Mon,  2 Nov 2026 04:46:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B03CC6B05BD; Mon,  2 Nov 2026 04:46:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CB6E6B05BE; Mon,  2 Nov 2026 04:46:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6E10D6B05BC
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 04:46:08 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 090C71A0C47
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:46:08 +0000 (UTC)
X-FDA: 85389698016.21.93FF4B9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8652340002
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:46:05 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NMkdta0l;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf01.hostedemail.com: domain of aesteve@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793612765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DGADPf1s/Hceud+YrgbPtgRU1aDRhCryTUpted2/1fo=;
	b=hNPdyKF+obAEwT+KQueH7tNVphy0pdFZcaKx+KkO6TkpCPODKREe9iBAkzPhBoOyXxDFT4
	kcW61BYHBhl75+4gP/us8v37M/jNnBD/qo0VgoLa2amr+rik5IxHALOumemkZGj0gEwwYq
	g4DPzJIkGrfWhV4eKdxnWC2lDGfyoUk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NMkdta0l;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf01.hostedemail.com: domain of aesteve@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793612765;
	b=zSG73lVXYn6lvGTLykSCVktnS2OlAJ6C9dEiUTFUTH1NEX5GyvSpoNmiWU96Sb/V3j/MCE
	KMzZxi9Df+iuYSPJXXqs58J3p2zWpGp5lGnP54HzNJCv0NfJLDWS2VJA1xdOpQUrxSwNwx
	oNUmzikRtkszueT6n8lSQcarWdanI/8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793612764;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DGADPf1s/Hceud+YrgbPtgRU1aDRhCryTUpted2/1fo=;
	b=NMkdta0lyH41Rxq3tnKy8AgTP7fIj4Y77rATaldCKbr65ksjnvMLfGh9Xftt+rwk7kZPb7
	tUpHmapjlRK6GW2WY86jgxJ09mz106CZFJXZ2hj1dCLl6AuCp+EE+yJqjoN23iNuA5JEbC
	SrlshVU5kfJQTlQhs9epZqoA5vlFQ7I=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-106-AYQGhI4aNPG39DFgaG7iuw-1; Mon, 02 Nov 2026 04:46:01 -0500
X-MC-Unique: AYQGhI4aNPG39DFgaG7iuw-1
X-Mimecast-MFC-AGG-ID: AYQGhI4aNPG39DFgaG7iuw_1793612760
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-48e17d30a79so1373680f8f.3
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 01:46:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793612760; x=1794217560;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=DGADPf1s/Hceud+YrgbPtgRU1aDRhCryTUpted2/1fo=;
        b=aT/OlHZEf6094f5UROkPBR86thmcmGzPMPhVnJSA7JjMou2KtUEjDt4HS1EKRavobN
         b2GQ69XYMJhaH2o3nsmGJ9CMcgxKGEfahFvU10ndO9XdmVJ6bBjDUYhDcykrMPF5/ksY
         VFPpev1530qsy7umAzux2AaPKjhrwnomK2KN+ZJdgZLVza4Wk4YNUNy0b1U3pyadCUrM
         LARl33yHzbBUExTOJZ1sm7twu9j7iZ9g7mVnJJYXFL9CeiDHaUd2ofg+T6Bskb2zMT9S
         saLYbzHVGxR6eIl99Pq0LmqfXJ2afBppCzstoq2t+IsSydNrmjhwPFhbeU+2kCvj3GD3
         7Omw==
X-Forwarded-Encrypted: i=1; AKwUvBzxYylnk+SIezFpYFf1LQyFDbvZVt8qKOuD+wee6Nio1vqTdcLhZ/RTcFCau19LMmcCuvriV9xqEw==@kvack.org
X-Gm-Message-State: AFq9FYJ2+7N9QU+nm2N2vy6cbiGnJv6bNIqNmjKT2F5M8Zwf4nmJ14MA
	F0bX1vvrSjL30xF7sSZXa+ysFsRjL2TynLGTkaF6Sinr3h/P80URrLOygS6dEO8n1NTW+tru8+m
	xUZy8xyTwiqe6FVUCapJPNgnRR4Tv7HuYfvRtmypY3ke4qgaec4ID
X-Gm-Gg: AYBFou1V3sirjOZxFOE5PvkxhOKmvJb7emsfoAkW31bdwd229PGJ7PACAMSPzWWCD0C
	jZJZo6RlhE1mohM3UwPkwhLoxXdS21n+i3gpE/D6eD04RW+eEH2I5KqiunSeQr1IBAytaeFXJ0x
	AD/LoQuzbYm3RN5yhSAapqsBTkdD0K2Mk+tZND9X4Mui7hMCMjoqEzVmlcqfftKeG9xA7CkwmYl
	5TjjKQyugk3+FmnEfzNqIILxmQphVSacTN1OFW6g0Wm5oL6shbj/gat822s6NaeksKA/U1FOo9Y
	SK0qUqbIJ/t2rlgYPbXGcQ31yOqW2B7fo6A/iyoKriE1TJd4JOJ410zu3qh9kjb+q4TCQFRBqtT
	kRXw+UMDAxPKgJvcbNZoF58EmTBtUeceZVh9M+tTkWg==
X-Received: by 2002:a05:600c:3b88:b0:4a1:cf60:dcc3 with SMTP id 5b1f17b1804b1-4ac187a6ffcmr228127015e9.29.1793612760244;
        Mon, 02 Nov 2026 01:46:00 -0800 (PST)
X-Received: by 2002:a05:600c:3b88:b0:4a1:cf60:dcc3 with SMTP id 5b1f17b1804b1-4ac187a6ffcmr228126125e9.29.1793612759656;
        Mon, 02 Nov 2026 01:45:59 -0800 (PST)
Received: from localhost ([139.47.30.142])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e77409821sm15084520f8f.0.2026.11.02.01.45.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 01:45:58 -0800 (PST)
Date: Mon, 2 Nov 2026 10:45:57 +0100
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
Message-ID: <auhb1W6CRi0vo0Tq@aesteve-thinkpadp1gen8.rmtes.csb>
References: <20261027-v2_20230123_tjmercier_google_com-v3-0-78d2c4cb8647@redhat.com>
 <20261027-v2_20230123_tjmercier_google_com-v3-7-78d2c4cb8647@redhat.com>
 <d76d8bfe-e955-4e90-9f5f-e3e914c0869c@amd.com>
 <auIeQU0nAnOLdKUB@aesteve-thinkpadp1gen8.rmtes.csb>
 <9ebce3f2-f7a0-46a9-bad7-39059b99423f@amd.com>
 <auNzHjhT5xezyZ4I@aesteve-thinkpadp1gen8.rmtes.csb>
 <08705a7a-86aa-4b43-a22a-e80a572010f2@amd.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
In-Reply-To: <08705a7a-86aa-4b43-a22a-e80a572010f2@amd.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: qizZc4XMRURIH8oXPYK9irVzU1lMk5XFE1O4Ipc1pMA_1793612760
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8652340002
X-Stat-Signature: wrq5683q1676u4heyjmtqkuri6j9j8z6
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793612765-979042
X-HE-Meta: U2FsdGVkX1/T4/wgffwzC24eZadwx5WDKH0BdbRYzi3Qz9DmapaoUFgmVMb1LtfLkS/kFoMYyeHn8OSjx/NpUE16VUCEMD/qllNU5QZEwubcPto9HFeBb7xQ1vlUo4qDbbfBtx+qHqaDo3UItfkvDRqMZNfJS2M8rWR037Jpd71sj9eb7rLOAKBQgL6dYEj+1a21DFCaIxAZluEVSVIeA2f2vcsjNWKzo7XjiYZiIDjmQe0Ko1rtgerhnRArVwTOWxz68JJmcCZ3VT4J4bc4Jiu9DHuV8aD+Rf3KylbwiCxZlDwHfE34xHHTtvNGjXsFyNcO8l16HQvUJkEB7hJx5eBVYqib1h6VvljAEj9ixvUdM4vQxTmuaTxxEDGkgUJwrJK/P86+jaWq/2dK/WJR8DNdlgATZfOMFRIxiWOoc1psoC6n0rprAUyrWvPm/TjSt3Le8FUTn4kBin/5aSQ8oUpWa9u5usvV2iCgs61oCczAofhe4vjJTgDKT1LG/BrRUbjYl20kppkuT7yJaIHZ7AMqssd0a/RurJ58tUmd12TrUkjfXyG0oMZpsnkiuA0qyWZADFuR6n+rYx+zlLOmT2dti4QHwYGf3/G4KOLhsdjrElHE3vqnQytpVMgM2oA0Vtvt5TzWYuT8TkS+hWWn/i7gW+7VfXjZUdzRjZGwb1dTib1AxlsiSHcAG1m8btgwh7WXTbTje42Qs9Z0haCJQM/mcE9I43fKMz64wO1leKpOxz19Dsx76Bbd5v0uStq2jVKveNxtqsW5E0S3F/tyc0lvbiELQ6XKLaddxUL0gH67b5vb+noYHSO+qtwQsUN9/ZpzR+o5Xkaq/KRdHLjBvkxbjM4cSyE63LIVQUmmTy51QmW1Q/4R2VGboEguUB2Sm6yETZZn4NFyUrykbvi1fnEHZhUHVkhceJXEZvJk3G+b3h4QT0S0fJViOIQUOmYgWkQ5wBHFLYKhxbWVGCe
 +oBdnIOR
 ivorPu/5eWwOMS7+74gqQmpkI+LLymzUiHJXrvafOC9tQjjwK1ti7cLgF6ZT83MqqqO/by6145V6C9fDu9iDY0M5cvsutg6MFYjaE+StA9hn5gNI8Wp1/9q2prVNGPTcmRuJPpbIJK8Zy/EQJaNNs51mAIg8GoHmlewdJFlOcmSd2cFzqzYOgmYXSiM+K1rXSOeoXEBdzteDxUz9g4ZX3DTXsPwzKDaNuOK7569+YTQVZWpWsOLc5+Uc28hPGAASTDJcxgvSfuF0QKqI1bt+1TX2NCzFmLZxABiILQF1kmuok+7+CtvfYtcB5guHmdGDPzc4GFgKM2swRazN83z8ZlLP5aBJVdjRslX45v30cpFf8UtUoWWUm7dT1jWl8gKz4aX6v9+pX1G708z2OLM8A9czzcQaz5O5xq6ls1LyNJqvUGkxgups5K91xicDg5XJJGAX91SdbrgHtdU2Bv9Bgxdzx44Q861JH2YiCHdp5cgHa9LLupfOImvF1GA5aIko0HALN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 30, 2026 at 11:14:50AM +0100, Christian König wrote:
> On 10/29/26 17:23, Albert Esteve wrote:
> > On Thu, Oct 29, 2026 at 03:16:12PM +0100, Christian König wrote:
> >> On 10/28/26 17:09, Albert Esteve wrote:
> >>> On Wed, Oct 28, 2026 at 10:08:19AM +0100, Christian König wrote:
> >>>> On 10/27/26 16:02, Albert Esteve wrote:
> >>>>> dma-heap already supports charging a specific cgroup at allocation
> >>>>> time via charge_fd in DMA_HEAP_IOCTL_ALLOC. However, dma-bufs can
> >>>>> originate from any exporter (DRM, V4L2, etc.), and the allocator may
> >>>>> not know the final owner at allocation time.
> >>>>>
> >>>>> Add DMA_BUF_IOCTL_XFER_CHARGE to transfer a dma-buf's memcg charge
> >>>>> to a different cgroup after allocation. The target is identified by
> >>>>> charge_fd, which may be a cgroupfd or a pidfd.
> >>>>>
> >>>>> The transfer charges the new cgroup before uncharging the old one,
> >>>>> preserving the original charge on failure. An atomic cmpxchg on
> >>>>> dmabuf->memcg prevents races with concurrent transfers.
> >>>>>
> >>>>> Not all dma-buf exporters back their buffers with reclaimable system
> >>>>> memory. Some represent device registers, VRAM, or carved-out pools
> >>>>> where size is not a meaningful memory cost. Add a memcg_account flag
> >>>>> to dma_buf_export_info that exporters set when their buffers should
> >>>>> participate in memcg accounting. The xfer ioctl returns -EOPNOTSUPP
> >>>>> for buffers that do not set the flag. Currently only the system heap
> >>>>> sets it, other exporters can opt in as needed.
> >>>>>
> >>>>> Usage example:
> >>>>>   int cg_fd = open("/sys/fs/cgroup/clients/app1", O_RDONLY | O_DIRECTORY);
> >>>>>
> >>>>>   struct dma_buf_transfer_charge xfer = {
> >>>>>       .charge_fd = cg_fd,
> >>>>>   };
> >>>>>   ioctl(dmabuf_fd, DMA_BUF_IOCTL_XFER_CHARGE, &xfer);
> >>>>>   /* charge now on app1's cgroup */
> >>>>>   close(cg_fd);
> >>>>>
> >>>>> Signed-off-by: Albert Esteve <aesteve@redhat.com>
> >>>>> ---
> >>>>>  drivers/dma-buf/dma-buf.c           | 43 +++++++++++++++++++++++++++++++++++++
> >>>>>  drivers/dma-buf/heaps/system_heap.c |  1 +
> >>>>>  include/linux/dma-buf.h             |  5 +++++
> >>>>>  include/linux/memcontrol.h          |  9 ++++++++
> >>>>>  include/uapi/linux/dma-buf.h        | 26 ++++++++++++++++++++++
> >>>>>  mm/memcontrol.c                     | 41 +++++++++++++++++++++++++++++++++++
> >>>>>  6 files changed, 125 insertions(+)
> >>>>>
> >>>>> diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
> >>>>> index f31f49ebd0af..07513ecedc10 100644
> >>>>> --- a/drivers/dma-buf/dma-buf.c
> >>>>> +++ b/drivers/dma-buf/dma-buf.c
> >>>>> @@ -540,6 +540,45 @@ static long dma_buf_import_sync_file(struct dma_buf *dmabuf,
> >>>>>  }
> >>>>>  #endif
> >>>>>  
> >>>>> +/* Transfer a dma-buf's memcg charge; see struct dma_buf_transfer_charge */
> >>>>> +static long dma_buf_xfer_charge(struct dma_buf *dmabuf,
> >>>>> +				const void __user *user_data)
> >>>>> +{
> >>>>> +	struct dma_buf_transfer_charge arg;
> >>>>> +	struct mem_cgroup *memcg;
> >>>>> +	int ret = 0;
> >>>>> +
> >>>>> +	if (copy_from_user(&arg, user_data, sizeof(arg)))
> >>>>> +		return -EFAULT;
> >>>>> +
> >>>>> +	if (!IS_ENABLED(CONFIG_MEMCG))
> >>>>> +		return 0;
> >>>>> +
> >>>>> +	if (arg.flags != 0)
> >>>>> +		return -EINVAL;
> >>>>> +
> >>>>> +	if (!dmabuf->memcg_account)
> >>>>> +		return -EOPNOTSUPP;
> >>>>> +
> >>>>> +	memcg = mem_cgroup_get_from_fd(arg.charge_fd);
> >>>>> +	if (IS_ERR(memcg))
> >>>>> +		return PTR_ERR(memcg);
> >>>>> +
> >>>>> +	if (dmabuf->memcg == memcg)
> >>>>> +		goto skip_transfer;
> >>>>> +
> >>>>> +	if (!mem_cgroup_transfer_dmabuf_charge(dmabuf, memcg)) {
> >>>>> +		ret = -ENOMEM;
> >>>>> +		goto skip_transfer;
> >>>>> +	}
> >>>>> +
> >>>>> +	return 0;
> >>>>> +
> >>>>> +skip_transfer:
> >>>>> +	mem_cgroup_put(memcg);
> >>>>> +	return ret;
> >>>>> +}
> >>>>> +
> >>>>>  static long dma_buf_ioctl(struct file *file,
> >>>>>  			  unsigned int cmd, unsigned long arg)
> >>>>>  {
> >>>>> @@ -590,6 +629,9 @@ static long dma_buf_ioctl(struct file *file,
> >>>>>  		return dma_buf_import_sync_file(dmabuf, (const void __user *)arg);
> >>>>>  #endif
> >>>>>  
> >>>>> +	case DMA_BUF_IOCTL_XFER_CHARGE:
> >>>>> +		return dma_buf_xfer_charge(dmabuf, (const void __user *)arg);
> >>>>> +
> >>>>>  	default:
> >>>>>  		return -ENOTTY;
> >>>>>  	}
> >>>>> @@ -750,6 +792,7 @@ struct dma_buf *dma_buf_export(const struct dma_buf_export_info *exp_info)
> >>>>>  	dmabuf->size = exp_info->size;
> >>>>>  	dmabuf->exp_name = exp_info->exp_name;
> >>>>>  	dmabuf->owner = exp_info->owner;
> >>>>> +	dmabuf->memcg_account = exp_info->memcg_account;
> >>>>
> >>>> The initial charging should probably be done here as well.
> >>>>
> >>>> This way DMA-buf heaps only needs to pass in the charge_fd and we can re-use the functionality for other DMA-buf exporters as well.
> >>>
> >>> The problem with doing the charge here is that it happens too late.
> >>> That is the reasoning for this proposal to move all the charging logic
> >>> into heap allocators before pages are allocated.
> >>
> >> Oh, that is a really good point we need to talk about.
> >>
> >> DMA-buf heaps is actually a rather simple use case, but we have way more complex things.
> >>
> >> For example in some use cases the backing store of a DMA-buf is only allocated on first use and only then it needs to be comitted to it's memcg or dmem.
> > 
> > Yes. The idea is focus on heaps for now. But the uAPI is actually
> > agnostic of the time when the charge happens. When we deal with
> > lazy-allocation in the future we can just call the reserve/cancel
> > helpers wherever is more appropiate. As long as the pages are not
> > allocated, exporters do not set dmabuf->memcg, and XFER does not
> > work (returns -EOPNOTSUPP).
> 
> Yeah exactly that's the reason why I'm raising this topic. That approach won't work in all cases.
> 
> See userspace is not aware that the kernel is delaying allocation or that the kernel is allocating the backing store asynchroniously in a background worker for example.
> 
> So returning -EOPNOTSUPP when the backing store is not allocated yet and might be allocated later on is rather questionable uAPI because that is racy by design.

Ah! I see what you meant now.

> >>
> >> I don't mind implementing it for DMA-buf heaps first, but we should have the uAPI and it's handling so solid that it also works for future use cases.
> > 
> > Agreed. I think we should cover all usecases with the current status.
> > Your feedback helped a lot in getting there!
> 
> I mean we can postpone that until we finally need it, but essentially we need to be able to distinct between charging, e.g. making sure the cgroup has enough free limit, and committing, e.g. allowing the resource to be reclaimed.
> 
> And then it is possible that when the memcg of a DMA-buf changes that only the charging changes, but there isn't any comitted backing store yet...

Right. That would need adding a specific flag for committed pages or
a similar solution. When transfering an uncommited dmabuf only the
charge moves (limit reservation and dmabuf->memcg), the stat is
untouched. Once the backing store exists, the exporter commits, it
sets the flag and bumps MEMCG_DMABUF stat. For memory where its
backing store can go away (e.g., dynamic dma-buf sharing), it can
have a mirror function that drops the stat but keeps the charge.
That would resolve the -EOPNOTSUPP thingy, as transfer succeeds
when dmabuf->memcg is set even for uncommitted pages.

My question would be if all exporters know when memory is committed.
For those that only get, e.g., a firmware handle and cannot observe
the allocation, I guess the buffer can just remain reserved without
even being committed. Or in case of protected memory like OP-TEE
they would not even opt-in to begin with.

I do not mind adding that for next version, or leaving it for when
lazy exporters actually opt-in. It is not a big change either way.
Although, it may look weird while the system heap is the only user
and commits right away. But either way I can try to document the
flag / explain this discussion in the commit.

> 
> >>> What we could do is fill the dmabuf->memcg field when the flag is set
> >>> (i.e., committing into the dmabuf in the patch semantics). But for that
> >>> we'd need adding the memcg we want to charge it to into exp_info in
> >>> order to support charging to cgroups other than the allocator's (for
> >>> the common case would be simpler as we can just look at current).
> >>> Maybe that's what you meant?
> >>
> >> At least for the DMA-buf heaps use case that sounds reasonable for now.
> > 
> > Thanks! Next version will have the flag removed and just use
> > dmabuf->memcg as indicator, set within dma_buf_export().
> > Also, `nr_pages` will be computed within dma_buf_export(), the
> > contract being that exporters setting exp_info.memcg assert that
> > size reflects actual system memory bytes.
> 
> Thinking more about it I would also put changing dmabuf->memcg under the dmabuf->resv lock instead of doing it with cmpxchg.
> 
> We don't need it currently, but the dmabuf->resv lock is used for all state changes of the DMA-buf object and this operation is not performance critical in any way possible.
> 
> If there is a problem with locking order we at least get lockdep screaming at us very early and not when we want to extend the functionality in the future.

Sure, will do.

BR,
Albert.

> 
> Regards,
> Christian.
> 
> > 
> >>
> >> Regards,
> >> Christian.
> >>
> >>>
> >>>>
> >>>>>  	spin_lock_init(&dmabuf->name_lock);
> >>>>>  	init_waitqueue_head(&dmabuf->poll);
> >>>>>  	dmabuf->cb_in.poll = dmabuf->cb_out.poll = &dmabuf->poll;
> >>>>> diff --git a/drivers/dma-buf/heaps/system_heap.c b/drivers/dma-buf/heaps/system_heap.c
> >>>>> index adeea8cd328b..a764167167ba 100644
> >>>>> --- a/drivers/dma-buf/heaps/system_heap.c
> >>>>> +++ b/drivers/dma-buf/heaps/system_heap.c
> >>>>> @@ -479,6 +479,7 @@ static struct dma_buf *system_heap_allocate(struct dma_heap *heap,
> >>>>>  	exp_info.size = buffer->len;
> >>>>>  	exp_info.flags = fd_flags;
> >>>>>  	exp_info.priv = buffer;
> >>>>> +	exp_info.memcg_account = true;
> >>>>>  	dmabuf = dma_buf_export(&exp_info);
> >>>>>  	if (IS_ERR(dmabuf)) {
> >>>>>  		ret = PTR_ERR(dmabuf);
> >>>>> diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
> >>>>> index 23ec0ff23fba..ac0ec88cab93 100644
> >>>>> --- a/include/linux/dma-buf.h
> >>>>> +++ b/include/linux/dma-buf.h
> >>>>> @@ -433,6 +433,9 @@ struct dma_buf {
> >>>>>  
> >>>>>  	/** @memcg: the cgroup to which this buffer is currently attributed */
> >>>>>  	struct mem_cgroup *memcg;
> >>>>> +
> >>>>> +	/** @memcg_account: account buffer memory to cgroup */
> >>>>> +	bool memcg_account;
> >>>>>  };
> >>>>>  
> >>>>>  /**
> >>>>> @@ -505,6 +508,7 @@ struct dma_buf_attachment {
> >>>>>   * @flags:	mode flags for the file
> >>>>>   * @resv:	reservation-object, NULL to allocate default one
> >>>>>   * @priv:	Attach private data of allocator to this buffer
> >>>>> + * @memcg_account:	account buffer memory to cgroup
> >>>>>   *
> >>>>>   * This structure holds the information required to export the buffer. Used
> >>>>>   * with dma_buf_export() only.
> >>>>> @@ -517,6 +521,7 @@ struct dma_buf_export_info {
> >>>>>  	int flags;
> >>>>>  	struct dma_resv *resv;
> >>>>>  	void *priv;
> >>>>> +	bool memcg_account;
> >>>>>  };
> >>>>>  
> >>>>>  /**
> >>>>> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> >>>>> index 6b30baa79fa9..36fddafbef4e 100644
> >>>>> --- a/include/linux/memcontrol.h
> >>>>> +++ b/include/linux/memcontrol.h
> >>>>> @@ -679,6 +679,9 @@ bool mem_cgroup_reserve_dmabuf(struct mem_cgroup *memcg, gfp_t gfp,
> >>>>>  void mem_cgroup_commit_dmabuf(struct dma_buf *dmabuf, struct mem_cgroup *memcg,
> >>>>>  			      unsigned int nr_pages);
> >>>>>  
> >>>>> +bool mem_cgroup_transfer_dmabuf_charge(struct dma_buf *dmabuf,
> >>>>> +				       struct mem_cgroup *new_memcg);
> >>>>> +
> >>>>>  void __mem_cgroup_uncharge(struct folio *folio);
> >>>>>  
> >>>>>  /**
> >>>>> @@ -1206,6 +1209,12 @@ static inline void mem_cgroup_cancel_dmabuf(struct mem_cgroup *memcg,
> >>>>>  {
> >>>>>  }
> >>>>>  
> >>>>> +static inline bool mem_cgroup_transfer_dmabuf_charge(struct dma_buf *dmabuf,
> >>>>> +						     struct mem_cgroup *new_memcg)
> >>>>> +{
> >>>>> +	return true;
> >>>>> +}
> >>>>> +
> >>>>>  static inline void mem_cgroup_uncharge(struct folio *folio)
> >>>>>  {
> >>>>>  }
> >>>>> diff --git a/include/uapi/linux/dma-buf.h b/include/uapi/linux/dma-buf.h
> >>>>> index e827c9d20c5d..ea957f4b1d38 100644
> >>>>> --- a/include/uapi/linux/dma-buf.h
> >>>>> +++ b/include/uapi/linux/dma-buf.h
> >>>>> @@ -168,6 +168,31 @@ struct dma_buf_import_sync_file {
> >>>>>  	__s32 fd;
> >>>>>  };
> >>>>>  
> >>>>> +/**
> >>>>> + * struct dma_buf_transfer_charge - Transfer a dma-buf's memcg charge
> >>>>> + *
> >>>>> + * Any holder of a dma-buf file descriptor can perform a
> >>>>> + * DMA_BUF_IOCTL_XFER_CHARGE to attribute the buffer's memory
> >>>>> + * cost to a specific cgroup, or move it from one cgroup to
> >>>>> + * another.  The ioctl charges the new cgroup before uncharging
> >>>>> + * the old one atomically.  On failure the original charge is
> >>>>> + * preserved.  If the buffer has no existing charge, a new
> >>>>> + * charge is established.
> >>>>> + */
> >>>>> +struct dma_buf_transfer_charge {
> >>>>> +	/** @flags: Reserved, must be zero */
> >>>>> +	__u32 flags; /* unused for now */
> >>>>> +	/**
> >>>>> +	 * @charge_fd: File descriptor identifying the target cgroup.
> >>>>> +	 *
> >>>>> +	 * May be either a pidfd, in which case the charge moves to the
> >>>>> +	 * memory cgroup of the referenced process, or a cgroupfd obtained
> >>>>> +	 * by opening a cgroup v2 directory, in which case the charge moves
> >>>>> +	 * directly to that cgroup's memory controller.
> >>>>> +	 */
> >>>>> +	__u32 charge_fd;
> >>>>> +};
> >>>>> +
> >>>>>  #define DMA_BUF_BASE		'b'
> >>>>>  #define DMA_BUF_IOCTL_SYNC	_IOW(DMA_BUF_BASE, 0, struct dma_buf_sync)
> >>>>>  
> >>>>> @@ -179,5 +204,6 @@ struct dma_buf_import_sync_file {
> >>>>>  #define DMA_BUF_SET_NAME_B	_IOW(DMA_BUF_BASE, 1, __u64)
> >>>>>  #define DMA_BUF_IOCTL_EXPORT_SYNC_FILE	_IOWR(DMA_BUF_BASE, 2, struct dma_buf_export_sync_file)
> >>>>>  #define DMA_BUF_IOCTL_IMPORT_SYNC_FILE	_IOW(DMA_BUF_BASE, 3, struct dma_buf_import_sync_file)
> >>>>> +#define DMA_BUF_IOCTL_XFER_CHARGE	_IOW(DMA_BUF_BASE, 4, struct dma_buf_transfer_charge)
> >>>>>  
> >>>>>  #endif
> >>>>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> >>>>> index 7b841b905759..3adc84fe6668 100644
> >>>>> --- a/mm/memcontrol.c
> >>>>> +++ b/mm/memcontrol.c
> >>>>> @@ -5786,6 +5786,47 @@ void mem_cgroup_cancel_dmabuf(struct mem_cgroup *memcg, unsigned int nr_pages)
> >>>>>  		refill_stock(memcg, nr_pages);
> >>>>>  }
> >>>>>  
> >>>>> +/**
> >>>>> + * mem_cgroup_transfer_dmabuf_charge - move a dma-buf charge
> >>>>> + * @dmabuf: buffer to transfer charge
> >>>>> + * @new_memcg: target memcg; caller must hold a reference
> >>>>> + *
> >>>>> + * Transfers the charge for @dmabuf to @new_memcg and, on
> >>>>> + * success, stores @new_memcg in @dmabuf->memcg.
> >>>>> + * Returns %true on success, %false if the charge against @new_memcg
> >>>>> + * failed or a concurrent transfer raced on @dmabuf->memcg.
> >>>>> + * On failure the caller retains its reference to @new_memcg.
> >>>>> + */
> >>>>> +bool mem_cgroup_transfer_dmabuf_charge(struct dma_buf *dmabuf,
> >>>>> +				       struct mem_cgroup *new_memcg)
> >>>>
> >>>> I would make that more generic instead of dmabuf specific. E.g. something like this:
> >>>>
> >>>> bool mem_cgroup_transfer_charge(struct struct mem_cgroup **ptr_memcg, struct mem_cgroup *new_memcg, enum memcg_stat_item item, unsigned int nr_pages)
> >>>
> >>> Ah yes, I like this generalization. And the implementation remains
> >>> mostly the same. Thanks!
> >>>
> >>>>
> >>>>> +{
> >>>>> +	struct mem_cgroup *old_memcg = READ_ONCE(dmabuf->memcg);
> >>>>
> >>>>> +	unsigned int nr_pages = PAGE_ALIGN(dmabuf->size) >> PAGE_SHIFT;
> >>>>
> >>>> This way we can also document in the DMA-buf caller that this conversation must be ok when memcg_account is true.
> >>>>
> >>>> Regards,
> >>>> Christian.
> >>>>
> >>>>> +
> >>>>> +	if (mem_cgroup_disabled())
> >>>>> +		return true;
> >>>>> +
> >>>>> +	if (!mem_cgroup_reserve_dmabuf(new_memcg, GFP_KERNEL, nr_pages))
> >>>>> +		return false;
> >>>>> +
> >>>>> +	mod_memcg_state(new_memcg, MEMCG_DMABUF, nr_pages);
> >>>>> +
> >>>>> +	if (cmpxchg(&dmabuf->memcg, old_memcg, new_memcg) != old_memcg) {
> >>>>> +		mod_memcg_state(new_memcg, MEMCG_DMABUF, -nr_pages);
> >>>>> +		mem_cgroup_cancel_dmabuf(new_memcg, nr_pages);
> >>>>> +		return false;
> >>>>> +	}
> >>>>> +
> >>>>> +	if (old_memcg) {
> >>>>> +		/* Uncharge old cgroup */
> >>>>> +		mod_memcg_state(old_memcg, MEMCG_DMABUF, -nr_pages);
> >>>>> +		mem_cgroup_cancel_dmabuf(old_memcg, nr_pages);
> >>>>> +		mem_cgroup_put(old_memcg);
> >>>>> +	}
> >>>>> +
> >>>>> +	return true;
> >>>>> +}
> >>>>> +
> >>>>>  /**
> >>>>>   * mem_cgroup_uncharge_dmabuf - uncharge a dma-buf from its memcg
> >>>>>   * @dmabuf: buffer to uncharge
> >>>>>
> >>>>
> >>>
> >>
> > 
> 


