Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57912C87FD1
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 11:14:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8CE66B009A; Tue,  5 Aug 2025 07:14:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3E526B009B; Tue,  5 Aug 2025 07:14:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C53D96B009C; Tue,  5 Aug 2025 07:14:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B1A4C6B009A
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 07:14:24 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 65164140111
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 11:14:24 +0000 (UTC)
X-FDA: 83742445248.01.EB89D23
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3B38220010
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 11:14:21 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=KAG0nDb2;
	spf=pass (imf03.hostedemail.com: domain of bhsharma@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=bhsharma@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754392462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bgVI/REEX1RcSxnDg5Q8C5uv8j4eEiN9+bNJh7WkDrE=;
	b=AVS7wYl0AlDye6Zk6/OsEzgChYXtDuURs21XksT/hgbdzISq24vs9QbxlblRpG5FNd10kR
	gx5ZhvJvnuNH6sNRQ0O7edmZTEVPm5QK+2QlwxVS8ZdZWyzg/yI4KhYkGGWFPkAMA5Qc4R
	e3UN2uQ5qTn1Sw4sMdaa8Poh0iWwUJM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754392462; a=rsa-sha256;
	cv=none;
	b=wlnft5zWtzY6oCkOuMxTsmSWOTPMjdUgylDytSnTX5u7xv2ExDqLfKx3WKSyryd+Woi/XW
	FwGgue/Lq8KEg6dry/OS3f54Rv2Jaz8vBqLUd6F8Bv6OlKFXyBARIRql5osU0KGjfWkCfB
	XItSUZ4wvAMpHpo+sq3Ec2A52IorgI4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=KAG0nDb2;
	spf=pass (imf03.hostedemail.com: domain of bhsharma@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=bhsharma@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=bgVI/REEX1RcSxnDg5Q8C5uv8j4eEiN9+bNJh7WkDrE=; b=KAG0nDb2y1oP1WiWoj0oaxb99a
	OQadSf83hX7TeXKy+bACaAQJjKdOpPXnB0oICAPokwy7Nrm0AIuA2cjpyI0SWTHd81y0FNe7z16e9
	LU2R+YSHOyVvYwFWmh147QSFpaCHcyxW0KlDYmmeYp3fRIll47oo5vowhHj4KVWioO4qYm/FyifQT
	cQtrV0dEUJcf/63kTcEzJzrHXj/ql6JFBmiUFDVemTTvSmyHTyDFFljKXzERQlGP4rvZIY+nkFi7u
	1KvCLSvSn991ikuYFq0KavSzT9Akddcniwec8tFG992e0qsdnGC4Io3X6ctd97FRFLdbCZfp9FzCr
	IwjGnzlQ==;
Received: from [223.233.65.189] (helo=[192.168.1.12])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
	id 1ujFcO-009f93-3s; Tue, 05 Aug 2025 13:14:08 +0200
Message-ID: <dfdc2c2c-1486-a84d-9ca2-3b48b68773ce@igalia.com>
Date: Tue, 5 Aug 2025 16:43:58 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v6 2/3] treewide: Switch memcpy() users of 'task->comm' to
 a more safer implementation
To: Linus Torvalds <torvalds@linux-foundation.org>,
 Kees Cook <kees@kernel.org>
Cc: Bhupesh <bhupesh@igalia.com>, akpm@linux-foundation.org,
 kernel-dev@igalia.com, linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
 linux-perf-users@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, oliver.sang@intel.com, lkp@intel.com,
 laoar.shao@gmail.com, pmladek@suse.com, rostedt@goodmis.org,
 mathieu.desnoyers@efficios.com, arnaldo.melo@gmail.com,
 alexei.starovoitov@gmail.com, andrii.nakryiko@gmail.com,
 mirq-linux@rere.qmqm.pl, peterz@infradead.org, willy@infradead.org,
 david@redhat.com, viro@zeniv.linux.org.uk, ebiederm@xmission.com,
 brauner@kernel.org, jack@suse.cz, mingo@redhat.com, juri.lelli@redhat.com,
 bsegall@google.com, mgorman@suse.de, vschneid@redhat.com,
 linux-trace-kernel@vger.kernel.org
References: <20250724123612.206110-1-bhupesh@igalia.com>
 <20250724123612.206110-3-bhupesh@igalia.com>
 <202507241640.572BF86C70@keescook>
 <CAHk-=wi5c=_-FBGo_88CowJd_F-Gi6Ud9d=TALm65ReN7YjrMw@mail.gmail.com>
 <B9C50D0B-DCD9-41A2-895D-4899728AF605@kernel.org>
 <CAHk-=wixR7ZR+aebFsWX4qWZ84tMTmyNWLUPmTy3YvaNJGqd-Q@mail.gmail.com>
Content-Language: en-US
From: Bhupesh Sharma <bhsharma@igalia.com>
In-Reply-To: <CAHk-=wixR7ZR+aebFsWX4qWZ84tMTmyNWLUPmTy3YvaNJGqd-Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3B38220010
X-Stat-Signature: 617p7ymdz65zfi4wqggfu8drum8zarp5
X-Rspam-User: 
X-HE-Tag: 1754392461-336869
X-HE-Meta: U2FsdGVkX1/Ys3Hnc+nOkaubMw9gJ4TlxnsC8lDiMfkkD/V7rsW/lxjJ/P8NmMd76rxPt3dhRevCkDpbrGeO+vaQRap754Y+bmz3FnP53fmKLQy1Fx/V1gm/ft6zwxOTILst+ab04hGNd4YHLU6KgQzonkJqHYv6ECF8zSKltfO9eCihh8G430xzkwa5xFpejK5iNr2sWSXvHPBKjLqUvQOZYmVDby/xq83VvoIZzphtc8PznA6txe19NwyYLZsVVlG53XkD2DeRKMGU2zjE1OLRnmO9wxI72CCDgV0x5+En653i+G6KVQH7nb6oh4S+LdqyJ6Q1wzPKeLh1io4manzfw3uHdzPa0zGOKysBWUfkZXIaOEgXA+vCY6RAx13e2nnRWpKz/4G5HGDpkulpfQJlgdabJdT7D6FUVn8L5sYTAJTyTG/YPXxmWob7CGrIP4TWkWSFT6tE44CcWfITnwT7SQRwH2Dj0JcUKGaGt2U5cWW/WnDnvl64eRnkPj6K5I6NWq/yDAd5o68xbHSuXsS4dzpguEZTYOHcW0sH+1am4XKBn/246vwQlPvYEXmBfJyX8ql1xMUh7kCoR7NqBu0XA5Ag7gtkrN7NdOjcS9S55yLsKAQcM+jCvmYuVCa5t0tvedi1NBxGnZS30pnHX9pv37cu6jSBKNcYucvkCNHyhRv+ev/Z8VyHdbbnVQACWOOTyk9bwd6mHcJWMObvPLAvZV6wXquKvEYck94v3revk3t4P15AU3sKtWrE2PtojCrBJdznPwqRBLFrnn8soC9Af1Hal0TjssV8LINdjwdmSOwCGsg67ui6MDbwBxFGK0Z1DglxG1jEpWG+PDUB4rTHd+gkkWbUUnpnBIeKzKCD2SdbIcaxxNWE3zd+pV8rihZ9XTy4t1ywacQtzeOJMAk6OGKEhhbP+Exy4UOMduWZbg4sPHlPjgdmQuDBJU09SVS2WQ/DcGrsg3CGhpG
 IfKZMNQE
 pMrnNYZ5616gKJkDOT1uyA/nNcRHPSFN/GYiLIOfeaYs5D3L7i0jcDLFmx8pl6623KWrU5ER3HCwp0tODA/eroGifaQrZM5H4QaA3uUdtqrl+D5utqxRLbVszgab63yTvac8uNwzl+rQfLJi/TCM/uLYOPiHPy/HJs2wXj/H56lrPmWSdsxOEbe9hZWFD3DPrHx+iaufb8OHb9qR3ae5jfCd2821QTWfalrvdow1er6i6t7Pb8/pJHoMzMqmH1ElZqGH7hQtt0TVLJ670M27Ny03/U+xfQSjVYyqmrFCUOTu3QPtcvr7q/zKZMM1KKCABZqAL
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 7/27/25 5:07 AM, Linus Torvalds wrote:
> On Sat, 26 Jul 2025 at 16:19, Kees Cook <kees@kernel.org> wrote:
>> That works for me! I just get twitchy around seeing memcpy used for strings. :) if we're gonna NUL after the memcpy, just use strscpy_pad().
> I do worry a tiny bit about performance.
>
> Because 'memcpy+set last byte to NUL' really is just a couple of
> instructions when we're talking small constant-sized arrays.
>
> strscpy_pad() isn't horrible, but it's still at another level. And
> most of the cost is that "return the length" which people often don't
> care about.
>
> Dang, I wish we had some compiler trick to say "if the value isn't
> used, do X, if it _is_ used do Y".
>
> It's such a trivial thing in the compiler itself, and the information
> is there, but I don't think it is exposed in any useful way.
>
> In fact, it *is* exposed in one way I can think of:
>
>     __attribute__((__warn_unused_result__))
>
> but not in a useful form for actually generating different code.
>
> Some kind of "__builtin_if_used(x,y)" where it picks 'x' if the value
> is used, and 'y' if it isn't would be lovely for this.
>
> Then you could do things like
>
>      #define my_helper(x) \
>          __builtin_if_used( \
>                  full_semantics(x), \
>                  simpler_version(x))
>
> when having a return value means extra work and most people don't care.
>
> Maybe it exists in some form that I haven't thought of?
>
> Any compiler people around?
>

Sorry for the delay in reply, but I was checking with some *compiler* 
folks and unfortunately couldn't find an equivalent of the above 
*helper* support.
I am not a compiler expert though and relied mostly on my digging of the 
'gcc' code and advise from folks working in compiler world.

In case there are no new suggestions, I think we can go ahead with 
"strscpy_pad()" or "get_task_array()" in place of "get_task_comm()" 
which is implement in the following manner:

    static __always_inline void
        __cstr_array_copy(char *dst,
             const char *src, __kernel_size_t size)
    {
         memcpy(dst, src, size);
         dst[size] = 0;
    }

    #define get_task_array(a,b) \
       __cstr_array_copy(dst, src, __must_be_array(dst))

Please let me know.

Thanks,
Bhupesh


