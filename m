Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38650E6BF1B
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 15:55:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76BCC6B0005; Fri, 30 Jan 2026 10:55:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 723466B0089; Fri, 30 Jan 2026 10:55:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 622116B008A; Fri, 30 Jan 2026 10:55:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5335D6B0005
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 10:55:56 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E1EB11604B1
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 15:55:55 +0000 (UTC)
X-FDA: 84389081070.16.93F0BE3
Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
	by imf05.hostedemail.com (Postfix) with ESMTP id D076A100005
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 15:55:53 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel-dk.20230601.gappssmtp.com header.s=20230601 header.b=upm61rgr;
	spf=pass (imf05.hostedemail.com: domain of axboe@kernel.dk designates 209.85.160.41 as permitted sender) smtp.mailfrom=axboe@kernel.dk;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769788554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4lWqgXH8a8eOxRrwfmqGJmpBJIu/eoT2SMMiuVC7jWk=;
	b=AbSlarGfr8IEaY/IrvR4fZpI8Ky4bCwahStJ8d05Up/+dr/R92cvZxZtrItX1b7tWmISSM
	iKnpzWOof1wy6oVBfiQ7xK3qXyxoNlykKpOCrxVxCD916Ajd6DQiv9iLt8c71PsN2hpHTM
	UVrsLPEk6MGLydy/BedP6NbkhYbS9+s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769788554; a=rsa-sha256;
	cv=none;
	b=8ROTgNdVJa24Cp/x06+K5cBGTh2fctpyqL6tchy4A0esJS1MQxbphtKtuEAmLkDvgcMh64
	fgukFCbAbhckWQl3wok5sR5irqPfLglVYJktz/veN3LtcRn4V4b7Xwq7lAlHUOce/MoR7r
	vPi/tAs8ir6HEBorIVIjL89oELzPI/M=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel-dk.20230601.gappssmtp.com header.s=20230601 header.b=upm61rgr;
	spf=pass (imf05.hostedemail.com: domain of axboe@kernel.dk designates 209.85.160.41 as permitted sender) smtp.mailfrom=axboe@kernel.dk;
	dmarc=none
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-408778a8ec4so1459990fac.0
        for <linux-mm@kvack.org>; Fri, 30 Jan 2026 07:55:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1769788552; x=1770393352; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4lWqgXH8a8eOxRrwfmqGJmpBJIu/eoT2SMMiuVC7jWk=;
        b=upm61rgrNi++CnoQtqKxRwX7EG8WfLyp+2d4TYRSAoxK0dxiLsoVflhMVCHiJ1zjS9
         WAFI5TfRZ5QHZ+NccOxOKPbc8Pq8XF8n84FPrStDCtmMrQimAtM6BU4BUCL0RwTOPwpY
         L14j7RTaGQz0ciz/CYE6f/AHv0/54qeqzK+f3MILwH5uv8XcUq2xyeKXtatFeh3nkhtk
         hnjy8l7IrCLOdoXrSmA7V4WLX+CddU9Kd3oqj2hMEURtxf3Pik4ynt+GK3sr2VLM5U3t
         dFTCfReoWQbVbOeuaj78Re5T9WgJsj6SqOXAYbjof20zw7w269sjf2B5nJHg++RQBJ/J
         OKDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769788552; x=1770393352;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4lWqgXH8a8eOxRrwfmqGJmpBJIu/eoT2SMMiuVC7jWk=;
        b=baSk3wDqpmLEuD95F1T3Am7nL9Lvmmz+3zQlFfimhmWZ0QOC1NNeFbkkREaHZNs6h5
         DFmWKbnfmaaw/ofsnYRcVOCt18d4+SRUlPsd4Ivd7EkPfgIDL585OTUTWNhHZHWCJsRS
         bUDbzuELXppPEIQJUFTR0Bmhnnz9OzPrkkAx/Biry/g6keezizQyK4aHwX2zup0yTALw
         4JIqnY6XBANfCl1/anoMTnir9Vm5fUdoPnBMH5/kGaUnsU0lJx15F9mg3zgF2wjuX9t6
         iHdl7k7SSciduYX5ohjFD+saBR/Vp7Jkv1EGQ7ukN37pRUy9LWOdAZdOYHjd5BghmF9u
         Gi2A==
X-Forwarded-Encrypted: i=1; AJvYcCWf0CoZHqkG1Ivfbadi7R4nJYys8biyCUhjJrbIIIdw3KB2PEOgOK5mQR7f8MEKoQMkWj8v8YfUEQ==@kvack.org
X-Gm-Message-State: AOJu0YwdCmDzweQOoTkS8v5bwzdLKItUpmOZouGMyga17wKoZpySgf/I
	EeurWUAu2pjCU2+4kSUwa11RuvBR9NkwWtTv1SMAsHm/0WrBBZb7gNJUWo9KQeplUL8=
X-Gm-Gg: AZuq6aJ+pfEEaF0PlEBQ47hezK4fh5NUKd610mK51KAoE4Lal00RQcPFyj6X1nRUpHx
	ydl15htg1gxH9ylNfJO2RLSQiPXpFUoTMr3R2DzMQhk5eNdGVIaIr3dCfTtXv0s8yeCe3rfaGwb
	mvkJyJxodI2mxWq7hduPxCG8mST+0w/c/GdjHQBR+cD5kL2J1oEavihKfblTF68vgOi7RjN0Ki5
	usSGCmbGpHrPz24QEodCmwysGudgIER8YEXL2weKenf68ZxIETaxcAW8IxYHeMQO9aWPqi2nlEy
	a0FwnsjPx2szUOm27+5+pScBM2Goo2SWjTzXvCM+3YC64ZQVv0Qh7AZ0wokXIgiqr11sZDZjVKK
	8+FfRJs3veltXY1uAvdQ9CFN9qSwfOc8lgUPVZZb3oEAteyMzH8hFZmIrq4kjxLlcqLfHSaoPB3
	/1fH+eY0BPAyEdSdDxDXpjr1utsFDaydtKlTFF664BiwhX1KWU+YbM4d0zct2ImFh1jv/x
X-Received: by 2002:a05:6820:f014:b0:663:46f:603f with SMTP id 006d021491bc7-6630f02bd9dmr1550651eaf.22.1769788552396;
        Fri, 30 Jan 2026 07:55:52 -0800 (PST)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-662f982703fsm5202672eaf.0.2026.01.30.07.55.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Jan 2026 07:55:51 -0800 (PST)
Message-ID: <efa7714d-565d-41c4-af85-d7a89e7fa399@kernel.dk>
Date: Fri, 30 Jan 2026 08:55:50 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] io_uring: introduce IORING_OP_MMAP
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: io-uring@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org
References: <20260129221138.897715-1-krisman@suse.de>
 <20260129221138.897715-3-krisman@suse.de>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260129221138.897715-3-krisman@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D076A100005
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 1gr447fik4ypfhni5c1qywtbubkg9st3
X-HE-Tag: 1769788553-233887
X-HE-Meta: U2FsdGVkX1/0WBDLPy1OncOsEm4yarAPgGybJstGyyNNz+SaJfTh/w3gqiDUsJcTSpm8tgwJWibUsvpwAuM8UrH8iIeSc4LJdrOKoFwZiQakpRBu650K8zneBjnCupIbtwj4jdrk2xSok6+UDBl9n4n5O5NxjjGpTCOTvOuGmUJkuLiWEFIdtgg1iBYkuCSEzG7iXb+Sk3pdHZQyVgSpK8wZyQMl5ErESHx9gRS77aexgQmdfxqJd7AEw662fSMgZrX7gsQAiQXV5kYy9esTMN+Iyw84IzK6n06DmY2SeRQzIsFlozvNKpaB0/YQT+w4hFug4j2Ha9q99ZqrLtaRYWfHNUnr97Jm8sbwlpzw5YFS3XtpNVsKLWF7D0NSre9XtZn2JMws4W7BkgfR8kbbNkObyEhtrZSjSdG/a2M/ulgzt1GrFemUx4bJx5wnS+bcsEdN6srCkaOVvTD39+uRgOYyg8TtDDqQ4KTuq/WsSPXCFYO3VRQ3Ul4yyAz4I33h3iZ5xF+ZImtZehDiSP2kmw3L4flVf7KftFBt5t8w0s8Ju+3Az8BYP+hUGOyc5qbCKPR8KeXxcgxxhgnbUVJU1JRiir+O8kLSfqjrMjfUE+gsWVLsiBfUonXaWaKwmxiSSXI86MY2iFIC/EIRGmLXMtmSxG3j3Rr5HUxOi9ZPbjGUWFkAlCseHhJWk35PiT44m3xh1Q/xr+5KfVB9kzc0IPnXIfRUgczb7x4tK0MrYY+xqCsWkwmaeXMHLH/tNICpgL0Ojw8TIvLBj2ZRzQxXOy9u11l91yxUWs3AS/qnybe6hI2OJIenqv2SWBbjQKUi7/TheiX+dAwyDsluUBZQpAwrR1Te2x13M4ERGxegUjp6N+eUFf+j4gbIXN24C0TrRafxKmUjjKGzddT2NwNAmoV/GUZXia/a5GJR72DFNfJc3xmNJaDeWXUPZiPcmbHqYgtBSEWE71q5yZFTSom
 hrl9/nYK
 QLXg179mdQhi9Y0z60ZjRDQvhyQiNfJE1LpJ3dVWf2uEujtmsHF0ihtNfkuPgm04XiSC3y7VhIjGaMF3hKD8kdqAAa1Qtr2yS+PIYdv7L1AlkJIw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/29/26 3:11 PM, Gabriel Krisman Bertazi wrote:
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index b5b23c0d5283..e24fe3b00059 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -74,6 +74,7 @@ struct io_uring_sqe {
>  		__u32		install_fd_flags;
>  		__u32		nop_flags;
>  		__u32		pipe_flags;
> +		__u32		mmap_flags;
>  	};
>  	__u64	user_data;	/* data to be passed back at completion time */
>  	/* pack this to avoid bogus arm OABI complaints */
> @@ -303,6 +304,7 @@ enum io_uring_op {
>  	IORING_OP_PIPE,
>  	IORING_OP_NOP128,
>  	IORING_OP_URING_CMD128,
> +	IORING_OP_MMAP,
>  
>  	/* this goes last, obviously */
>  	IORING_OP_LAST,
> @@ -1113,6 +1115,14 @@ struct zcrx_ctrl {
>  	};
>  };
>  
> +struct io_uring_mmap_desc {
> +	void __user *addr;
> +	unsigned long len;
> +	unsigned long pgoff;
> +	unsigned int prot;
> +	unsigned int flags;
> +};

You can't use pointers or unsigned long or unsigned int in a uapi, as
they'd be different sizes on 32-bit and 64-bit. And then you need compat
handling. It's much better to make this:

struct io_uring_mmap_desc {
	__u64 addr
	__u64 len;
	__u64 pgoff;
	__u32 prot;
	__u32 flags;
};

and then generally also a good idea to have a bit of expansion space
there, so you don't need a new desc down the line.

> +int io_mmap_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
> +{
> +	struct io_mmap_data *mmap = io_kiocb_to_cmd(req, struct io_mmap_data);
> +	struct io_mmap_async *maps;
> +	int nr_maps;
> +
> +	mmap->uaddr = u64_to_user_ptr(READ_ONCE(sqe->addr));
> +	mmap->flags = READ_ONCE(sqe->mmap_flags);
> +	nr_maps = READ_ONCE(sqe->len);
> +
> +	if (mmap->flags & MAP_ANONYMOUS && req->cqe.fd != -1)
> +		return -EINVAL;
> +	if (nr_maps < 0 || nr_maps > MMAP_MAX_BATCH)
> +		return -EINVAL;
> +	if (!access_ok(mmap->uaddr, nr_maps*sizeof(struct io_uring_mmap_desc)))
> +		return -EFAULT;

Does this access_ok actually provide anything? We're copying it in later
anyway, no?

> +static int io_prep_mmap_hugetlb(struct file **filp, unsigned long *len,
> +				int flags)
> +{
> +	if (*filp) {
> +		*len = ALIGN(*len, huge_page_size(hstate_file(*filp)));
> +	} else {
> +		struct hstate *hs;
> +		unsigned long nlen = *len;
> +
> +		hs = hstate_sizelog((flags >> MAP_HUGE_SHIFT) & MAP_HUGE_MASK);
> +		if (!hs)
> +			return -EINVAL;
> +		nlen = ALIGN(nlen, huge_page_size(hs));
> +		*filp = hugetlb_file_setup(HUGETLB_ANON_FILE, nlen,
> +					   VM_NORESERVE,
> +					   HUGETLB_ANONHUGE_INODE,
> +				   (flags >> MAP_HUGE_SHIFT) & MAP_HUGE_MASK);

This looks like it dips into vm_mmap_pgoff(). More on that below.

> +		desc->addr = (void *) vm_mmap_pgoff(file,
> +					   (unsigned long) desc->addr,
> +					   len, desc->prot, flags, desc->pgoff);

One concern here is that vm_mmap_pgoff() ends up doing:

mmap_write_lock_killable(mm)
	grabs mm lock, can block, for a long time?

which could potentially stall the io_uring pipeline for a long time.
Ideally you'd be able to do something where you try to grab the mm lock
from io_mmap(), and if it fails, then either fail the request (if it's a
killable thing) or punt it with -EAGAIN to let an io-wq thread handle
it.

I'm not so sure simply wrapping vm_mmap_pgoff() either directly or
indirectly via the hugetlb stuff is going to be super useful, if we can
end up blocking for a long time on these operations.

-- 
Jens Axboe

