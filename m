Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBFB0C88E77
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 21:50:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1D1D6B0088; Tue, 15 Sep 2026 17:50:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F50B6B008C; Tue, 15 Sep 2026 17:50:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90B746B0092; Tue, 15 Sep 2026 17:50:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 492EE6B0088
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 17:50:44 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E41F5C0584
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 21:50:41 +0000 (UTC)
X-FDA: 85217341482.10.4D5F4F3
Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	by imf09.hostedemail.com (Postfix) with ESMTP id 038B2140005
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 21:50:39 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=L8js8VZB;
	spf=pass (imf09.hostedemail.com: domain of isaacmanjarres@google.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=isaacmanjarres@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789509040;
	b=4PWwuXDRlMexbV+WgQbrmGoLUPwKGi03f+chh8FCrv41p5wKzJ71TMYSN8JYesRaGEh7fs
	cl3k4p1XCeDompUYAUA0x3aVlW6hNPn7gAxl+NKPzTzg+L6S/Rw8VkC/kWWN7yK/OJkhP8
	eWmYC0Qq6N4Ka620cF9+f8HQ64gase8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=L8js8VZB;
	spf=pass (imf09.hostedemail.com: domain of isaacmanjarres@google.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=isaacmanjarres@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789509040;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tI17L7xSTrsApSfRoy8c9Azix9/YhE00k0p3SqEz6us=;
	b=g4460Ke/40Qu2XpkCFMpa1DEZyuXH1nI/h7TyrMrsgIHl3PxiaVSvj8cwtTVA/8sVn6UOz
	wGvFOtExZIZhYivI34TccTl+QG/KQswCIl1D5hTiC2Fufu+Y1HnMyKh1ET1wF89xGNxPYU
	ei1fY+A8DxZEAvIS7u/25o6WrWNucaA=
Received: by mail-pj2-f12.google.com with SMTP id d9443c01a7336-2db425c9050so16425ad.0
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 14:50:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789509039; x=1790113839; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=tI17L7xSTrsApSfRoy8c9Azix9/YhE00k0p3SqEz6us=;
        b=L8js8VZBvQCvKLgWAEoQNzUpd+MDIQ6RCTTWD2smoxi4zsW5BUCxABhGdcf6utUmdK
         TxGDCtnfZ2QqbuW4oO14XNiJhNN7bLC5/ZCjLgwwivjAJVz6CYCBW5b9vropDQwQ0gTL
         s9d90uNGjeqs2Zn6PcrAzc7XfOFLIJfFmoJlvuhitsbkNo2VPzjsBA+pL+WteGaeknHf
         QS23kOxxpCP4b1brrjMztKQglLAHOwipOC+qhCPvdXyG96Oxxe5+mYN3loYYlNZN4VFi
         K+u05qyj57AkbrE5N7il4sqOSrc77yLaOiq8lybtmsU+4RG1KE+TghD9qWEBMa0XADQI
         na1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789509039; x=1790113839;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=tI17L7xSTrsApSfRoy8c9Azix9/YhE00k0p3SqEz6us=;
        b=jfcqDVOr27XNq+rgAMKc7CkrMZGY18/GDxh+4lno8w8RwFz8mIm6gsFOCNv+XnDvUC
         5FokWyedkW6ouE4EjWf1uD3XIw/s3KFU/foYcE9sJMWRFgpuYAw5daT51NgrIFVzI8FB
         kFrvAdV653nFkDHd3UJf72OpwQT2ezt5+1szhqtIpnNe61KAPlijUlNANx3GWgk/iTYL
         59MzCuYYNz19SMQCkRxp2M+IzW+tVDaVpV+xa1KwKSgY9G14hdcNjLOcj4mw7aNMiArN
         QfcUM1im4L0fJq1d/CK0oiFO8tt/bFQGQJ7N2b/RJDOXHrFDYSl2Xtv+H6kO1ncZJIT+
         51Lg==
X-Forwarded-Encrypted: i=1; AKwUvBwexQoK4O+iZVccCH/PoShGwo+W1C8/eKd+fcH2rd29UunV+t9xGWoxs+YbznQsFOPZf1sX9FSIow==@kvack.org
X-Gm-Message-State: AFuF++kaTj3ZJotA+YPB/0SNRlqibSX2CdhoatIC/t9TLNYBbKul2BTE
	Leh+ZJ7Qv9+waQcxFsX05FkYrEDInGbeEgj+T10PH3Ic3sIS+G6cizTLp0cOIV2WqQ==
X-Gm-Gg: AYBFou3qsEfIarsX+jTS+VlfzdtcAD3SzG5vuKPp9uboL4kpyoFgU9Y4wM7345QhCMk
	rtO/Srvn3SVnfxENQPS5VDSkBYedU2OgJQMxvEiFnEclOXWkqWopmby2dL/uwdJL1Hr8B5JXSJV
	dfmLIHJkXjTstj3b2N2UR0dVJLZkso4Sgl1w9JeZ1ik5X/v8yYd7oQZ9mMUVF+V2BzlLkAlb524
	73oiH2vrtkrijqWEd91iXVhg23Yoay5n1d1aQOVR7gfar/herMO1rBTP+gHpeo+ULVTONJ71+QQ
	Kuwp8WjNNhkA24YHwv+3a0rXlV1JqHxFwKA0Og6RDFE239P2TvTt5LizImBlfyEeJEK1gu2rCUe
	6b9pfpRm8HRaUDpcZQL0/+Y/YI1pjv268ipF9y6aF8bL1E/S4gOO7ipFGM/cSLAw8UFU20ZszVQ
	sthB+GvtEBMF74D7j6fVENiVldN3HXkV7HMn4lnu+ha8eqynPBHIl6fxYDRe/txxY8iRf/aworo
	cAqf6rD5BmK91zj+rv99sEf8SgjwnZcfuW+AfsiE6iLVawf2O4=
X-Received: by 2002:a17:902:f693:b0:2d0:1aaf:daec with SMTP id d9443c01a7336-2dd8be54ab9mr842285ad.9.1789509038186;
        Tue, 15 Sep 2026 14:50:38 -0700 (PDT)
Received: from google.com ([2a00:79e0:2e51:8:8352:5e93:3fd9:766d])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33bf5af4f0bsm2082822eec.24.2026.09.15.14.50.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 14:50:37 -0700 (PDT)
Date: Tue, 15 Sep 2026 14:50:31 -0700
From: Isaac Manjarres <isaacmanjarres@google.com>
To: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc: =?utf-8?B?6auY57+U?= <gaoxiang17@xiaomi.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Xiang Gao <gxxa03070307@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	=?utf-8?B?5Y2w6Zev?= <yinchuang1@xiaomi.com>,
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Lorenzo Stoakes (Arm)" <ljs@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [External Mail]Re: [RFC] bpf: account ring buffer backing pages
 separately from Lost RAM
Message-ID: <aqm9p1uW7ls65_S-@google.com>
References: <20260815091819.3651099-1-gaoxiang17@xiaomi.com>
 <04f3ce2f-67f5-4829-9551-a69b9df29854@kernel.org>
 <CAEf4BzbwZkoacX-iP1j4+p8YNbWsq0pc3eTermh2uT5ir66zbw@mail.gmail.com>
 <8d2e20842c24460296e4c83e6dc0dde3@xiaomi.com>
 <CAEf4BzYQvhSVN=Hggg5FHzFdkRr4UNBD6yXaBsOaAwbsRpXpsw@mail.gmail.com>
 <aqSNkbhIuaB5D0H0@google.com>
 <CAEf4BzbAOgwQqsRQnY4yxvubLtioQNL_BBHer4ExvNF7Rvvu4w@mail.gmail.com>
 <aqhZEuQTu394hYB6@google.com>
 <aqh17GTlWiDVJ-N1@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aqh17GTlWiDVJ-N1@google.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 038B2140005
X-Rspam-User: 
X-Stat-Signature: p5k4n9o1sfxafzpmn7itgbudfyhabghp
X-HE-Tag: 1789509039-548644
X-HE-Meta: U2FsdGVkX19G9M4ecSlkoaZ/8QTysNx+YkJx+jR7AClo3eSkA6ZR61zRJ0/NM14CFv0PDsb8UL8bJ0OEy++8Mit1d0CK7ma2crLts5Drz1GomPQfYKGLDpTTEtG+9xMr23TPNTQIn8E9NiWI+/e7RmYPtyXdU1hTDiJQNgYH/zdUmGolByqZQddTLBw0SsjaYgtzs/uqUXZfyiukBfNkrmAocszcu1YNr+IGmCqEW/RmUfryU+VX90D9U+eG3lzfV+VsfH6ucmcPE5+xi463hMphEzsQI3Xt8zGBOAjHymc/XJESL6WDqgq4C6o0WjCzjK0N24KuDBBYGeOicdBtf70MqcpMlm/rkr8yNCn8eWsjfLY3FmV7R4Vi1l2nWlylYT99V1uh5xI/yGNq7RD+fLLrBO/yxHCtczGcbqWERVP4+IyVptR37Hs+xSjMdeNv+FNqH3xNw02x9Bw8/p947tvda4d94JgDX4ekhvhT+LFNq15IYE9QtHm1W6LIKD2eqQZe0gC+ecIjTJ/sXig1JJF2EO0f3Qb9z3S2XrVU8o8qWXkCQre/PyJD8jIZpZyVULRI9uEvwMnVXKuZNxUOdQXv406k1Kqvgx6Dx8Eg8nJnmpFd0L+2mhZ02h7mSlRsLGbt3idPne6kaVLiIdjXRZzuXlWia5Ub7l8FqFIfj52FVAKC9csoyCQs5xF76IowDWZp5M4/mEkdz9YUjt977XfnFSuVTVLlY12A3uAjgXrvh9BHO4ox4J6XlIcJiJ56M6COqEjzKZNwX3bEoSGvA9riNSj3MhfBchN0PCiiHZPA5wiZ1FHJ2FYxKYjD52CvmNSXziNt5REnTdXdUy287BAjPOIrvll6gVZdiPEauyXD1rD4D32yQKJGZBeaxQXy86shDtycGVPuOSSL4i1GaJnuOn/2ehpkdWF5fCOpo95kfqHNwwZw/HQCGQEqJV+qboXFy/c42RCQEciFFYj
 0MX/ebwB
 omPpmJ+2+equvuzIYOjf+pgzo7ynGR3f5945MQFvAyk8k3akB/XQmnZ47Fi8y7KBNpGoQeAzhsjH53BykHoDAO8LEaGZU6CnBiApgpaekR+RXACo0AWc8lR4IuQYKHSGfNPzrXGoUzAfEcilsl8e+9zcIXcPGNSmWPjyeBTKLNfKXJD2jxcIRj8BcwyuoiDOK7UDOrEbTa6GtkQ98/8O1Jn59Awxk/CCLnZrsxJB/klVHS763fhWs9kyqCNuhRNhzEc4xrPgLRg2wfNELUU4c6ak3v/0iDdpaFtQpv7MwgU6Z/T2Q2nqy6gFyPAUcRGyj2tsqDFIXlh5FLavWC8VGdO0NpVvsgHoTWow2wEXulmZWB6CcbCiat+dpxbP0AwO6/3Qr7s9icZvn/ffhtTQ2gEaRWVrNoPcAKmOSv4eBTuBXyh9FK0IEO/fE/UxkPRE7EPWn1NojBHClu9ukUW/XqKCXfQtOHmId7Qc4rrio1iAASVID0rhCuNcWxb2sOXG8lrlUPb7LGMsQLOU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 14, 2026 at 03:32:12PM -0700, Isaac Manjarres wrote:
> On Mon, Sep 14, 2026 at 01:29:06PM -0700, Isaac Manjarres wrote:
> > On Fri, Sep 11, 2026 at 05:04:55PM -0700, Andrii Nakryiko wrote:
> > > On Fri, Sep 11, 2026 at 4:24 PM Isaac Manjarres
> > > <isaacmanjarres@google.com> wrote:
> > > >
> > > > On Wed, Aug 19, 2026 at 10:24:28AM -0700, Andrii Nakryiko wrote:
> > > > > On Tue, Aug 18, 2026 at 6:46 AM 高翔 <gaoxiang17@xiaomi.com> wrote:
> > > > > >
> > > > > > Thanks for the pointer. Understood — no new NR_* counter or
> > > > > > /proc/meminfo entry.
> > > > > >
> > > > > >
> > > > > > The remaining question is on the consumer side: Android's Lost RAM
> > > > > > accounting would need to enumerate all live BPF ringbuf maps
> > > > > > (BPF_MAP_GET_NEXT_ID) and read each map's fdinfo memlock to sum them.
> > > > > >
> > > > >
> > > > > For BPF ringbufs specifically, you should be fine just iterating all
> > > > > map with BPF_MAP_GET_NEXT_ID, getting its FD with
> > > > > BPF_BTF_GET_FD_BY_ID, and then passing that fd to
> > > > > BPF_OBJ_GET_INFO_BY_FD to get map's size.
> > > > >
> > > > Hi Andrii,
> > > >
> > > > Thanks for the suggestion on this! I did want to express a couple of
> > > > concerns with this:
> > > >
> > > > Scalability
> > > >
> > > > I counted the number of maps on one of our devices, and there are 112
> > > > maps, meaning that there will be between 224-336 syscalls with this
> > > > approach. eBPF is becoming more popular, so I'm concerned about how well
> > > > this will scale, if we have to invoke 2-3 syscalls per map.
> > > >
> > > > I had a test program that implemented your suggestion, and it took about
> > > > 2 ms to identify 39/112 ringbufs. As the number of maps in the system
> > > > grows, I'm concerned that the latency associated with computing the
> > > > memory usage from ringbufs will become even more expensive. This is
> > > > something we had an issue with before on Android, where we had to
> > > > iterate through various sysfs files to gather wakeupsource metrics [1].
> > > >
> > > > To improve on this, I was wondering if we could expose the ringbuf
> > > > memory usage and potentially other bpf stats through bpffs
> > > > (/sys/fs/bpf/stats)? This counter could be a lightweight counter that is
> > > > incremented/decremented on ringbuf allocation/freeing so that when it is
> > > > read, there aren't any expensive computations.
> > > >
> > > > For this specific metric, we could just use a counter to track how much
> > > > memory is being used by ringbufs and have userspace read that. That also
> > > > brings me to my next point.
> > > >
> > > 
> > > I just don't see a good enough reason to single out ringbuf maps
> > > specifically. other map types also use memory, why would they be
> > > excluded?
> > 
> > I was looking at ringbuf maps specifically because they allocate memory
> > for the ringbuf via alloc_pages() and aren't attributed to any counter
> > that is exposed to userspace. The other maps use either the slab
> > allocator or vmalloc() to allocate memory, and those entries are visible
> > via /proc/meminfo.
> > 
> > > If you are worried about too many syscalls, look into map iterator
> > > program types (grep for SEC("iter/bpf_map") in selftests). That will
> > > be super fast and way more generic than what you propose. You can ping
> > > such program in bpffs and that will be you custom /sys/fs/bpf/stats
> > > implementation that you have full control and customizability of
> > > 
> > 
> > Thanks for the suggestion; I'll look into this and let you know if I
> > have any questions!
> > 
> I looked into this, and this works in reducing the overhead from number
> of syscalls, but the other part about correctness isn't handled by this.
> 
> For ringbuf maps we would have access to max_entries, but that just gives
> us the amount of memory consumed by the data portion of the ringbuf, but
> it doesn't include the 3 metadata (kernel structures, consumer idx page,
> and producer idx page). I don't see how to derive this value--rather
> than hardcoding it.
> 
> I did see that fdinfo for the maps does give the total memory usage
> via bpf_map_memory_usage(). However, that value includes structures that
> are allocated through the slab allocator and vmalloc, so using that
> value would double count the memory usage in the system. Userspace
> doesn't have the information required to break that value up to extract
> just the part that is allocated through alloc_pages() directly.
> 
> I think it's worthwhile accounting this data correctly, as on our setup
> there are 39 ringbufs. This can lead to 468 kB -- 1872 kB of unaccounted
> memory depending on the page size.
> 
> --Isaac
>
Please disregard my previous email. A colleague pointed out that I can
use bpf_core_type_size() to compute the size of the metadata that I was
referring to and that worked.

Thanks for all the help!
--Isaac

