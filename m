Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9354FCCD187
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 06:43:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA8B78E0067; Tue, 14 Oct 2025 02:43:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E80478E0005; Tue, 14 Oct 2025 02:43:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D96318E0067; Tue, 14 Oct 2025 02:43:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C6F928E0005
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 02:43:28 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 621A413BAC7
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 06:43:28 +0000 (UTC)
X-FDA: 83995778496.17.63B5146
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	by imf28.hostedemail.com (Postfix) with ESMTP id BB868C0006
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 06:43:26 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JyePmnwn;
	spf=pass (imf28.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.170 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760424206;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MhrDyaN2J3TqzVAMvoBpM4UfVuraiqPhFHlfn6YNa1Q=;
	b=wrAyrCL3is2BcKsUp2Bm6ytVGqNHp1zwU04PJJ2/Arg2Sd+0ARXXIXEXu3jf404J8lACHM
	L6peNHzbD1JeLvJ0E7dnJ5MMAYhRt5tGR5AfJdchsKqCGpEPNigX4CyH1GLB/a3LAws3Ko
	pHgs8n75U+gTkf46/MTKE9xhaG1zRBM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760424206; a=rsa-sha256;
	cv=none;
	b=1ec+S3qDgF6VT7qMj0TDE7KgZZtkOAqhKuEsgvQO0l0cem6U8wHH3XtPxMO5sFFKD212rh
	fUzNOL624kJzj50CdPhkkH6N5S3t+/8zjM6/3PcF2iyZDGZIlYl/asdeUolp/8beR+e/sA
	qJfadqFNuN8j9mQq2eduPcKfofzmEw0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JyePmnwn;
	spf=pass (imf28.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.170 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-855733c47baso969217885a.0
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 23:43:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760424206; x=1761029006; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=MhrDyaN2J3TqzVAMvoBpM4UfVuraiqPhFHlfn6YNa1Q=;
        b=JyePmnwnGsf/8dwp8Yl4ZOARIyaqVsTlKn85jNxY0WHXnWF0l11tNIYtYO30BnJ5cn
         kImzfSo0rGW3vjsgeeFr5iGhLWU3FTvjbj64ZEnF8OT7B44m0BZiozJwtRSjc/MSnc8g
         zWdyTji+X2tdb3amHH3lbOJ0si5AY8jrkM8t1VDFW/RpXRhTFB00l26b6AwSGYGxxZt/
         JfEdW5Ah14OS2eKYU1BZLKfquyGPWWwBciEpgnIc+ObVyyMoPSPP5rE3P00V8blEvoMy
         CIZKIG+U4bmUvaIzJ0v73ia241sQAsaWH/qCEtocxlLvMYf/9YsaLDoCw5babDfDbUZS
         +K9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760424206; x=1761029006;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MhrDyaN2J3TqzVAMvoBpM4UfVuraiqPhFHlfn6YNa1Q=;
        b=pHGCQTCHMUIs8/5pE63dbmUTjZEZlwecjquIaVbL4D5rpaF4jwBdlF7t7VmAif40aM
         7DRhMUDZjxc65JhuCPmw5R02KkKkChGK2bqYUCo95Ce05zI+Z/hfL5deijovV3SldRLD
         uIWB8y8hHWE4ZtoR70ymOevOEDPynOjDUFK5pJlLUbPbqICfYSGD1K6J11gvpG4tJbp1
         Cc4u3/jC4DE3DjbM1qN9UKll+e0/5mZ+V+i7ELV30r5ytyS9/tAYQRE4OFqS12j60FCT
         Ml2mQ4eWJoqqyVFpX1/Nnod6IeWD7Eo5K239O9sZcDFUtLQPXiflOsQNSyVXR62qB74s
         KUFQ==
X-Forwarded-Encrypted: i=1; AJvYcCV1hRn67GoO9gkmQJvrOXDWjEzA4YDJAEunwuVEREV9sDvEqPwdIGE+H1K0TE/Tx8KgjWDVuJzsMQ==@kvack.org
X-Gm-Message-State: AOJu0YzTahMMmguDn4a0hdkASoJadBifG9c2vljKtemxKAGxsfI5bMVF
	d1ERMcmM05XX5+uqFZ/mPXUfw0pT7/kY6AhAM6Nuep4Dzk+IhqBsZQUCkpFnihPO+HS+vPqODK/
	8iFIc1iDBo5D/VohDoQnRl5ARATtjjdk=
X-Gm-Gg: ASbGncs97eTFwPxD3PzyQDrJHPEwhyioi5PCtTKWH/DLLv1Z6TPH4OLIV+4zijDETjr
	77KlpxhtB+PTO15VDFehwew2gnNRYiM+5djC5b8GGBLZucPRauz0IQpuZDeRT3+S0vcHvtzG1P2
	AO65Yo99COXYxPYrDyFTSLAvbpGSj4p1C7jymrGuFE6/i9xVsbZga61aGkx8Nm+I4cmbAXrSva5
	xx6l1lCi/lHMALEBLO/rammg7EfATeYepEsOVMQQ/wynrCHGGHTQf/2zJqTx6qPeEQ8K5tiwOGj
	E6M=
X-Google-Smtp-Source: AGHT+IFYutlmQKCrkDt8XJQ+cgRq1f7xMcV72qnx5j0NhR1+uR1WTW9C1BFQIW6/sa8OGzcLx/Y98zV9viwi45m4nU0=
X-Received: by 2002:a05:620a:1709:b0:848:6b67:ea57 with SMTP id
 af79cd13be357-883502b6ce7mr3038377185a.16.1760424205591; Mon, 13 Oct 2025
 23:43:25 -0700 (PDT)
MIME-Version: 1.0
References: <CANn89i+wikOQQrGFXu=L3nKPG62rsBmWer5WpLg5wmBN+RdMqA@mail.gmail.com>
 <20251014035846.1519-1-21cnbao@gmail.com> <CANn89iKCZyYi+J=5t2sdmvtERnknkwXrGi4QRzM9btYUywkDfw@mail.gmail.com>
In-Reply-To: <CANn89iKCZyYi+J=5t2sdmvtERnknkwXrGi4QRzM9btYUywkDfw@mail.gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Tue, 14 Oct 2025 14:43:13 +0800
X-Gm-Features: AS18NWBkvzMB1sYbudY7gB27K6cY5x7_rxgh42n5L8scA-jiQSzN7FZuNS0QWLY
Message-ID: <CAGsJ_4ySSn6B+x+4zE0Ld1+AM4q-WnS0LfxzWw22oXr7n5NZ=g@mail.gmail.com>
Subject: Re: [RFC PATCH] mm: net: disable kswapd for high-order network buffer allocation
To: Eric Dumazet <edumazet@google.com>
Cc: corbet@lwn.net, davem@davemloft.net, hannes@cmpxchg.org, horms@kernel.org, 
	jackmanb@google.com, kuba@kernel.org, kuniyu@google.com, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linyunsheng@huawei.com, mhocko@suse.com, netdev@vger.kernel.org, 
	pabeni@redhat.com, surenb@google.com, v-songbaohua@oppo.com, vbabka@suse.cz, 
	willemb@google.com, zhouhuacai@oppo.com, ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Stat-Signature: 6mo4mbgb65hbdx7uy6y1wehxjuebr5ts
X-Rspam-User: 
X-Rspamd-Queue-Id: BB868C0006
X-HE-Tag: 1760424206-599893
X-HE-Meta: U2FsdGVkX19vD84NNzA6WENW7iQrFd+UGlfp2FZ1wWPfpZxG4bh7t5oRXkSQi97yX0CG1DwtzDaYovYpBkviuaMa0e1DnjGoHcb0AzrGq6fyPfAQlJh4aXr8G5VbDlys+qT/69BmVdA/8NFsUoWG/yCvfmpuJA3+FSwLj1tdIly6wkSR7A8/PzsQuP+h92jkG+qkt5yGxnFhSdgZ9szJKHGyM3VnR+1NNUx1Q4ZUimdwYt6iHBZMrj+G0sLTaon14ECc1yAxDNOYC5sUQHfYL2F5J73hjlxXLI3wodlLD8rW87JjFSawPAMxMFDnCIPkZR0ZSFyUl4ghtPr24B7yLRbatnCXNb//GeNxoLawTHD//KEZEvuMdv6iQRlt9OFwUpODEcQsB0CpL0lMmvwCn23MCY+Cyk6ACUOrPCOsVdivvNvdT3CPDE7pfozNU1eckEwym4zokUk69WCCqiNSxZQSFyVbUGs6Cjd1mT+5pRk6CEZXxm4JnT3JpIQ0eBJF1QIkmxv26cBfEgNPzhbcKqMHIdyVlIdW6gr0VRsWvmkXzSdqsmfo7xIyKquF8LoOq2Xf7g7yAE2bKczaxav88+N/UwOXzU9dQQY2vPrQXS/kN8Z8r5CSjpTkrKZg3/lrLvv+NCaA2LtCu6AmAovAr4pwlJzK395j8yYiBCJUWSqiGcFRC5COr5FsTl4QupqjNK8XHHP+KdtuS2FYREStnA5ojie4h57HbFwT0d2juGjbISRobAyCn+fB2O4Vvb3zX/exWRT4Kf7K+qZAAej9LZ+CVTcpVllzGZSilzd3tPqEYuiq7XAScxZEIbIpukUMphKKIaRKMQIVduoKsuBApRAZfxOb/9/NSiAnQZFS3+ChUd7IPduHjDjCu+1xC7PCamxOvc9raq12TRFzQMIWxoUZ1o/s6iwrcv2Zluq8vBWQQvlmKGGEH/nKeWcyt2F5Rp6Va+4gzokUssTDOsO
 AGpowETL
 qgkh3iH0g1N3sMEs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> >
> > A problem with the existing sysctl is that it only covers the TX path;
> > for the RX path, we also observe that kswapd consumes significant power.
> > I could add the patch below to make it support the RX path, but it feels
> > like a bit of a layer violation, since the RX path code resides in mm
> > and is intended to serve generic users rather than networking, even
> > though the current callers are primarily network-related.
>
> You might have a buggy driver.

We are observing the RX path as follows:

do_softirq
    taskset_hi_action
       kalPacketAlloc
           __netdev_alloc_skb
               page_frag_alloc_align
                   __page_frag_cache_refill

This appears to be a fairly common stack.

So it is a buggy driver?

>
> High performance drivers use order-0 allocations only.
>

Do you have an example of high-performance drivers that use only order-0 memory?

Thanks
Barry

