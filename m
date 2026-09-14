Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BCF6C88E75
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 22:32:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 643D76B0096; Mon, 14 Sep 2026 18:32:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 619556B0098; Mon, 14 Sep 2026 18:32:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BB876B0099; Mon, 14 Sep 2026 18:32:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 166E46B0096
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 18:32:24 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 91E7D1C1E7B
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 22:32:23 +0000 (UTC)
X-FDA: 85213817766.25.F8DFC43
Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	by imf05.hostedemail.com (Postfix) with ESMTP id C0F93100003
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 22:32:21 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mfiSEOPS;
	spf=pass (imf05.hostedemail.com: domain of isaacmanjarres@google.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=isaacmanjarres@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789425141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h/mgh4gWTa/ucSTLn+qewaTi2SshWtrqgS51IF0oOeU=;
	b=4qFNk/VkUBKr/ihipAqFwvpD001mlmlQbxP+ggXDlmQfE33pLZiLfNVRmlp3WsHxrFcJdj
	Mox8buAxcw2rJ9QJNpMhkcqPlfhNTE0zGRDk2CnjNBl381DRlF4N9HNYRZcVOy0yZbeHSN
	b0OEfMNLb7pAzlZtGFPcfvoHHT+oHtI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789425141;
	b=nD1Z7pESMXryB8koGuhhbGKBeWkJDqgsivNXIWeTvrHoJlegxf+Dphw9Zy6aUOmPelK8mT
	qx009eSlE+UHp9ldw+07B7KtbooTbd8LH2RQWCI4dWJI1CHfNmHEJnUB5FlLwriCjZivNl
	J8L+5KCV2UHSSiEkP5lZ3Qu8DmbQDeA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mfiSEOPS;
	spf=pass (imf05.hostedemail.com: domain of isaacmanjarres@google.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=isaacmanjarres@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj2-f12.google.com with SMTP id d9443c01a7336-2d6ff3aca07so8755ad.1
        for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:32:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789425140; x=1790029940; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=h/mgh4gWTa/ucSTLn+qewaTi2SshWtrqgS51IF0oOeU=;
        b=mfiSEOPSYd86x9cYYLXdQpxWtPvFgImAIizSGd7TZtIhd12ztbhbCIFZr50Yu0K8Fi
         5cu2QreOgIcbxV1konGKGjiRON/zdLs/lXy7XWqjuN49c3sSQlGBgyE0/7YiKqSKAh+T
         1hQJ4X6BdBkwoGH355MjVUhecfS7p3J5iA2KxTakqIMTFKC995+cqtlcLYeOJ4gMwReF
         1RNc3leD603c6Rty0ujA64eicrufGS0S+YfRFpXGwGmut1RfAY8O1piNSWbJRjLNzsdd
         rqoL4yk1FtjAXIU5YHAC+So9DMsuxZ/0Q0cVWMiDlgIHY/xa3TVvS8uOOnegWL8536HT
         JtVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789425140; x=1790029940;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=h/mgh4gWTa/ucSTLn+qewaTi2SshWtrqgS51IF0oOeU=;
        b=bL2+SEcOMDmJtiBPdsumpNaIyWHlOLS6bCtGHB5i01ULXfx0fGizJyxSVvoB5zjXd5
         jTkyMYcPqo4qOYuopTLXlQ3P54UZz6+hX4+GyykS3a7PI9foEdlM6Wyo/oXDl0YFSzkf
         MaqUBu8TJtpV29jcd5wtm8+bI9DgKvMsZno11pA+f6lILb3OGQjW3+5s8RN8UXzn7+Wo
         qr5B3tDFSJ2xVAxXVijd3e8TSEnUcV/XjAFAsO77lNP34OnmfcyFoNYcqIe2Zb1GEJMJ
         bIcXNvokzq2rrG+4qWnR5Pg3Vlq5T0HtAPcFQsl7/NGHoCDO2cj0aEou/nzsofMDI6O3
         YdNA==
X-Forwarded-Encrypted: i=1; AKwUvBzOIU/ZjUXOyy07leNfwDCJvLmF8UzTJnSA1rAzbuqaPsKY55Xdqj+vmBWEWNZhgbljLmBH4ecjLw==@kvack.org
X-Gm-Message-State: AFuF++l/MHu7WRuVJ18nWxeCBSAounFqvMdcLDYdx13ZltIJlUVH3Je9
	tNjviKR0f3AKuNIyQKTaspgU83Hsw1iO/oJVZ1RS7EfxqoVWT29ojF204/HLXusdIfeQdPGxdpi
	YnIVvJ5WN
X-Gm-Gg: AYBFou1opwJzUiVUgWtcyi1BAeEVgztAfbOpwAkjrymZUQ6Bnl1UPSJ+wCNqEgW9ICc
	hNjO6e8odh2NCjB0D7j2JGQoMOT5883ojTDLmPWGH8DvHAQ4MtfERgJXVDbowWo3Lrj5YzEoQOx
	Igt1Hz4/DvzJrYEBuW0YH5bbIoWOoGCTe0/P62a5+3I64VLU1sGVtWk6SznFKTLTbvZcj7LHTvl
	birnZ42Ezs8CowJQE7YQkpuZorLoVV8slMe+G1yFRzKZPDs0qMVdBQN3oupNxLOp6xZ8h60GKkV
	vZUBqajPyKVHKrU7s3sT/nFDek1dnEnZd+Gy0kqCWx3nxBhA9/93TkHtmr6unkjKzW6z/MpFz+t
	K+LkmFKK2L6tAJwybisDSmfqkStd6ElsIROZwaKSkOtapGVTC3LftIKgksCK+43Mqo5LsnXkUZi
	aViPMb2pFIXmZv7zrLkv+JQdGFdnbk1W33kTn5vRFyEmFLJ1cegmLdH76Vwv4QHK2lay7l7DgLu
	bcYWdjMxxi6Whppe06wKrMIkJ6BDaEp5Wk2ym0=
X-Received: by 2002:a17:902:cf0b:b0:2db:2225:d2fd with SMTP id d9443c01a7336-2dd76be2bc3mr3447165ad.16.1789425140030;
        Mon, 14 Sep 2026 15:32:20 -0700 (PDT)
Received: from google.com ([2a00:79e0:2e51:8:9e:b709:96a2:f1d6])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1438d1381c2sm1704593c88.10.2026.09.14.15.32.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 15:32:19 -0700 (PDT)
Date: Mon, 14 Sep 2026 15:32:12 -0700
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
Message-ID: <aqh17GTlWiDVJ-N1@google.com>
References: <20260815091819.3651099-1-gaoxiang17@xiaomi.com>
 <04f3ce2f-67f5-4829-9551-a69b9df29854@kernel.org>
 <CAEf4BzbwZkoacX-iP1j4+p8YNbWsq0pc3eTermh2uT5ir66zbw@mail.gmail.com>
 <8d2e20842c24460296e4c83e6dc0dde3@xiaomi.com>
 <CAEf4BzYQvhSVN=Hggg5FHzFdkRr4UNBD6yXaBsOaAwbsRpXpsw@mail.gmail.com>
 <aqSNkbhIuaB5D0H0@google.com>
 <CAEf4BzbAOgwQqsRQnY4yxvubLtioQNL_BBHer4ExvNF7Rvvu4w@mail.gmail.com>
 <aqhZEuQTu394hYB6@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aqhZEuQTu394hYB6@google.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C0F93100003
X-Stat-Signature: td419siaawz7kszk45588rigjrmeqp6b
X-Rspam-User: 
X-HE-Tag: 1789425141-834310
X-HE-Meta: U2FsdGVkX1/AKg+fFRLzD4oByPaAId3nk+0TgdZIyrAOEhTtZ+gwHNZvZVyQXdP9xtsh5EKc80K2A5c4zojPzzwTb1440X381zNvGTLMYkyUDca6qmS9iZMumqKy8HmSclyS0MgcV8MGC7oq8p96LoiKJ0zTC6Ud8U9RbAmTXvbpYJON1G85Rzx/swtaZLyAfPNg0CSCOA5XSTzPGXnlEn1xvVbOrCG18H8ROdCKt5ekrvHRsJjPFoqWU12INkNwQimT+/SEjNmYeHAlTuqaMqsWXgd9vB/ZwsYEFIS7hsJIeWpv5ES1XYGAJIwgPp+mfJIMVNRVlx0mnF7Fp3gg4PEna/EXDyXWhxCYMiju5NM7YXhD73oZQh+psbO/+u3so2AQQ7qEyAxlGaRWCPsFQDdFCDf1EJvxQauc+qMgx2ww26ITmBOx2SvpnacH5y3KaWxFZVyrds3Xyk0Ya8cOsC2efIbYQiM/o0sXZfLDipBUkSSAEFe+6do+6GA1jIT7V/KBpP6JjTMTgO+kHZbmTSNH9DMPEySBJWHD0fNOwCGrC/kW7BAFSF2Yw53tTE/BFtH77OH1p8NDQ1Ge/C523l8a13huDP0yleHpejJhNDt/ZSwK48eHOiWf8xLpakBCNeLpelK8htn3B6mx3kbYIuBt7BOtX+GPtWRjKLqS+f76oYWgAojTIH8OeyQ/Y884RuhcrP8XFICo+RdHM+b56rmtZoB0JE2MF+/krY5IG16UHyABOBbJSH4H9Bg1GytjNlAo+yywHwQhlqCdV90zGNJm6I+VnZ9C28LDhiRNbGp6bQwVlipQaeUn41WfP2x+iQNNqRLW8YhLYmnsOi8cX/3ny3drSf/Y9TeXju0etR90aoEpZ7zagu1+0NTQZ0u3HGv3vLnAngcGsYg2xMJVqXAZTFZ4C5bZTemLQpY/cyY1AA6i5gWNsSPPEFHfYdP1pIlgO9MfLhzaLKaTZvK
 tyBPAJDV
 RwmaNSdJBl1X551JXmGQqpoN3RzvGTX51fXheOXdXwS3bwP9+tF3XQoW1qqMOyZ+BKC9Ucx7boYAUZ38/0ky5LJfdH371oceGUCxsWtjNYSzCJLQ6kTNzIZROHGEb9dfwdWlalr3+SI5DbllYuVF8kwHua2JfA7quGrRKRn1pGQZ4ZJc5OUKvUvmHJbOwPi6bO9eMhl9f1kCN5S9Vxw+LtErzULoxn09sybqA+BesEP9W5qS37uV03AxvMoysAjg2tA07K1b1ggUAUo3coa2dvqmdhyCIX85VcCz5wBH2RHyyMPpLGV4PLd+L9/qC8PXGdX3Ug15afJtPgjfHeZhskiziyTtriZgkWRMt7W0JAQhOPFMzGVkUcizu5AfK2c8nJEQpGesNDDOmmr59WZQbp3giG72inm59nl16b7loygRW6ARgzc2ccHNj2p28D3x0mWlArLOoteCozr0EAc2cRj4XvpfFr/KM7mvuL664GAszCfjBT0vktXtnN/Fvoxs5A0jmjF4yXTFyCpY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 14, 2026 at 01:29:06PM -0700, Isaac Manjarres wrote:
> On Fri, Sep 11, 2026 at 05:04:55PM -0700, Andrii Nakryiko wrote:
> > On Fri, Sep 11, 2026 at 4:24 PM Isaac Manjarres
> > <isaacmanjarres@google.com> wrote:
> > >
> > > On Wed, Aug 19, 2026 at 10:24:28AM -0700, Andrii Nakryiko wrote:
> > > > On Tue, Aug 18, 2026 at 6:46 AM 高翔 <gaoxiang17@xiaomi.com> wrote:
> > > > >
> > > > > Thanks for the pointer. Understood — no new NR_* counter or
> > > > > /proc/meminfo entry.
> > > > >
> > > > >
> > > > > The remaining question is on the consumer side: Android's Lost RAM
> > > > > accounting would need to enumerate all live BPF ringbuf maps
> > > > > (BPF_MAP_GET_NEXT_ID) and read each map's fdinfo memlock to sum them.
> > > > >
> > > >
> > > > For BPF ringbufs specifically, you should be fine just iterating all
> > > > map with BPF_MAP_GET_NEXT_ID, getting its FD with
> > > > BPF_BTF_GET_FD_BY_ID, and then passing that fd to
> > > > BPF_OBJ_GET_INFO_BY_FD to get map's size.
> > > >
> > > Hi Andrii,
> > >
> > > Thanks for the suggestion on this! I did want to express a couple of
> > > concerns with this:
> > >
> > > Scalability
> > >
> > > I counted the number of maps on one of our devices, and there are 112
> > > maps, meaning that there will be between 224-336 syscalls with this
> > > approach. eBPF is becoming more popular, so I'm concerned about how well
> > > this will scale, if we have to invoke 2-3 syscalls per map.
> > >
> > > I had a test program that implemented your suggestion, and it took about
> > > 2 ms to identify 39/112 ringbufs. As the number of maps in the system
> > > grows, I'm concerned that the latency associated with computing the
> > > memory usage from ringbufs will become even more expensive. This is
> > > something we had an issue with before on Android, where we had to
> > > iterate through various sysfs files to gather wakeupsource metrics [1].
> > >
> > > To improve on this, I was wondering if we could expose the ringbuf
> > > memory usage and potentially other bpf stats through bpffs
> > > (/sys/fs/bpf/stats)? This counter could be a lightweight counter that is
> > > incremented/decremented on ringbuf allocation/freeing so that when it is
> > > read, there aren't any expensive computations.
> > >
> > > For this specific metric, we could just use a counter to track how much
> > > memory is being used by ringbufs and have userspace read that. That also
> > > brings me to my next point.
> > >
> > 
> > I just don't see a good enough reason to single out ringbuf maps
> > specifically. other map types also use memory, why would they be
> > excluded?
> 
> I was looking at ringbuf maps specifically because they allocate memory
> for the ringbuf via alloc_pages() and aren't attributed to any counter
> that is exposed to userspace. The other maps use either the slab
> allocator or vmalloc() to allocate memory, and those entries are visible
> via /proc/meminfo.
> 
> > If you are worried about too many syscalls, look into map iterator
> > program types (grep for SEC("iter/bpf_map") in selftests). That will
> > be super fast and way more generic than what you propose. You can ping
> > such program in bpffs and that will be you custom /sys/fs/bpf/stats
> > implementation that you have full control and customizability of
> > 
> 
> Thanks for the suggestion; I'll look into this and let you know if I
> have any questions!
> 
I looked into this, and this works in reducing the overhead from number
of syscalls, but the other part about correctness isn't handled by this.

For ringbuf maps we would have access to max_entries, but that just gives
us the amount of memory consumed by the data portion of the ringbuf, but
it doesn't include the 3 metadata (kernel structures, consumer idx page,
and producer idx page). I don't see how to derive this value--rather
than hardcoding it.

I did see that fdinfo for the maps does give the total memory usage
via bpf_map_memory_usage(). However, that value includes structures that
are allocated through the slab allocator and vmalloc, so using that
value would double count the memory usage in the system. Userspace
doesn't have the information required to break that value up to extract
just the part that is allocated through alloc_pages() directly.

I think it's worthwhile accounting this data correctly, as on our setup
there are 39 ringbufs. This can lead to 468 kB -- 1872 kB of unaccounted
memory depending on the page size.

--Isaac

