Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1713ECD6E57
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 19:26:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E5876B00AF; Wed,  3 Jun 2026 15:26:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BC746B00B0; Wed,  3 Jun 2026 15:26:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D1CC6B00B1; Wed,  3 Jun 2026 15:26:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 595046B00AF
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 15:26:23 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 19DB2405F4
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 19:26:23 +0000 (UTC)
X-FDA: 84839582646.23.AC76F16
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf17.hostedemail.com (Postfix) with ESMTP id E73AA4000D
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 19:26:20 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eIwke9gx;
	spf=pass (imf17.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780514781;
	b=gUSTXXyinJhKiq/evLGfbi0E0H2YRrNTdJVTjN3fMxA/pPFLJODwJVeKvuWuG+3fSJQh/Q
	ncQJdalmnB7xRDc5I9TmgbhkLr5Tp2s0kZO1M81Qah22B+9/qR9usN7fkGbGKRZRUj4v+q
	SxjifTeRce9TC41PM906AKHXXtAT0ts=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eIwke9gx;
	spf=pass (imf17.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780514781;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tBlqGSO58iqBVZZw/2Y2ObnnEsd9OBRWmhZbqa08LGQ=;
	b=hBC93EHwmvMRIYMOH9CN3gwc+cuKN/pI0apuQ69/LlFIhTrMSOi/gz7TDcylMYDhXka6Ct
	4Eoy2UZ/hGsX6Kn8bw3t8g5GT4TDYFt5N/KHMfwc51r5bi1nFwE2CRsV7drweSdLhUnZz4
	v9V4on3LbvH80QffoISim+t+focSRJQ=
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-45eec22fab7so3759285f8f.3
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 12:26:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780514779; cv=none;
        d=google.com; s=arc-20240605;
        b=NbZX608X1h9yhWz/d/33TqzqJtML3gEdERWJ7ahRc257qwJ5r9Wv53wHHODp9UofJn
         i6sf2pEK7HYyaI3RBfAAnMLuHFxSDcJq9bOT62lItF3uKsHhz2O8qnQi5gmcwKkmXCNY
         fxdmOtVgoQFbOir0JgipKsJRst8373L7IbDRWlk0zAbpf1dTSAe0eRM+wKHUu0OE3fXX
         0/wVupZTIGxCqOeT157hg9dORKXA6wVaVikiBFF0Yb7iNmrwTa9hGrZtu2Rk4JVcABcp
         Xfk61Qjnji1kBp0wdVTv9BMNKjHEM/YJRcUIKEx+T+PVdcIEeBJEu3oDsUAVmOdQKSe1
         6z1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=tBlqGSO58iqBVZZw/2Y2ObnnEsd9OBRWmhZbqa08LGQ=;
        fh=mEStfWW98+BWbb7lun/LUF+L4cN4sn63WCoVDpY2ZDQ=;
        b=eIFvOGzo752Njds3Xob4Gvxdh7ib/hRfcAV0xN14HLi1pRdQm/yFaEQ+tEYzYMo4wO
         0Zdsd46j+6YAc8+pAk5Bl93tLyOD3lPgqtr0lbOqtpOqVqR10xphx9fSidlmFr2aNqbl
         CVuuk1Vufl5eYs25Ou8dU8/Iu4V46jQCLBTYB4ijhnj7/poARxgG6ThlFDFm9Ezdh+fx
         p+xA1I6vGdyqE+MVLc38dXmzri+62TJrDnFqnlYumdtJADg9S6TBRD/nSLcZ5zwxfYR9
         b77gIjdZPjpxHcMI74D8LasCJRAieoT7cqGhZTGKTNG7dtfcU1OFptAx0Rni61hJBIcv
         gRyQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780514779; x=1781119579; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tBlqGSO58iqBVZZw/2Y2ObnnEsd9OBRWmhZbqa08LGQ=;
        b=eIwke9gxLa74Swfi4olgIatpB1fR1dhujfsH/GGbLFyUUg+//vOHVAxYq1CAM4HPKN
         TclAtnsgV4PI1kRUZGrDXQjn3f6ZcKt5hAwMFzYk0op2lH0TE4Z+JaaDKVgsxX0m9loU
         hpR+VTMjCMfrTWxK++iwidLLnUhS1HQPDQ1eyQhu/jk5RuDW1w8VAt1Xs+Rr+QAWIjdw
         4aZhSpzQLcreJ/aRG3QSpSGUPgTPblnAk4S5QEBmdauuOjK9EYapaYg0ygE9pp1f3q8B
         D9CfJybmNOMmAk42i7jmtlvikC6ScHEQ6cEpbpwK3cfPU+eFjObQtvBA0M1WqSLMC4nx
         DpPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780514779; x=1781119579;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tBlqGSO58iqBVZZw/2Y2ObnnEsd9OBRWmhZbqa08LGQ=;
        b=eMiZldS3wngqc91fYiNcOJUnBpmlyR0Qs0TzeOLyOIKtjBPaTNScl1z97XGE+G2uY7
         P2Z2lu1OSrO0A3MTzptSqGbJ4Bki/tEBh3Xihk18/lDaMSEKz7jsqsOxDI/Wl3bFWH1Y
         dbLww9jE/Z+BTCtx8kavXUgNe0Dx+0TTCJK5W6SwPg6vsuY1E8eAZoGgVnFzXlv56XaD
         KxfSqqMtf4Vu+piPchph9YCjmp/6rauecS0NWH0vipxSjK/YylvV0ZwLKd45qxmhMWMS
         Pvq/OJaKoKw10v6LA6DdQbCIGLlXDdVa3lgY1GPS2VSc/VuTpx3syVBKwn94YQzcbmPj
         pbQg==
X-Forwarded-Encrypted: i=1; AFNElJ/tlHQL/dgzBSQiE3+QQ3k/7ssvxSDIXsVKImlUaam5ARHOCC5tJ9R/TVQSDRJZCjer7TIVuGh7Ug==@kvack.org
X-Gm-Message-State: AOJu0YxNTb2xvRYiIckpkkQDl/L8ZVJft792XBngrErRoU+Q8liLUIZO
	TY9q5C1ilQKw8pAFWMqXwnKvZSEfcoOhPUZXR56RBdfK/Bch5aaDWgYR9KgapInIluodHkxHFlv
	LV5rBpT0l+/rWjpyL1BbaAf7y7xeZtoQ=
X-Gm-Gg: Acq92OGDR5OIVAJHZL+yhhFCsxjbRtMeKclb57RRYUpN+LPOBjO4SNC39xgPictWSqY
	Uyby5zUrZ41QabziNKeabFz5frQUqsgAB4hx1dpMu1cI27zdgGjJb59iVGSoM45G/N7kNLmfg6Q
	VCutErqhY2o2FuV0+O1kGIOrlm+kw+0k6hzceA9CQNGGRNQQLm7salAsmgxykIzoeYL7lc4VIdA
	km9h74wsh9BU08lez5hVJjeAiM1KYVifrLyXgjCTLClnROpR9k2JIiPJpin6aWc6Hx3OTdiquvw
	M3NZ3y6ktAhOyGDwtwp9BQdQgkGfMrQaBkiWkTypEiMMmiMXyA==
X-Received: by 2002:a05:6000:1288:b0:45a:e3dd:5865 with SMTP id
 ffacd0b85a97d-4602179d1femr5352008f8f.13.1780514779097; Wed, 03 Jun 2026
 12:26:19 -0700 (PDT)
MIME-Version: 1.0
References: <20260528212955.1912856-1-nphamcs@gmail.com> <ah-A2gQ0GPgerXop@google.com>
 <CAKEwX=MWX9KkSFAoN4xEMg3b+gZUN9=yd7rirAWG5NOBf26eAg@mail.gmail.com> <aiB2sHqxcBAJrTkP@google.com>
In-Reply-To: <aiB2sHqxcBAJrTkP@google.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 3 Jun 2026 12:26:07 -0700
X-Gm-Features: AVHnY4KHcbe_bXQiAXNFeQa4TOqhlLT5AHoq3gLwnZPa6MV4BsBjJQBU0kZ4pYI
Message-ID: <CAKEwX=P95D7wNpWhEAXQpeNPM6eQa2mEZE8Srzfpct=-=Q40tg@mail.gmail.com>
Subject: Re: [RFC PATCH 0/5] mm, swap: Virtual Swap Space (Swap Table Edition)
To: Yosry Ahmed <yosry@kernel.org>
Cc: kasong@tencent.com, Liam.Howlett@oracle.com, akpm@linux-foundation.org, 
	apopple@nvidia.com, axelrasmussen@google.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, bhe@redhat.com, byungchul@sk.com, 
	cgroups@vger.kernel.org, chengming.zhou@linux.dev, chrisl@kernel.org, 
	corbet@lwn.net, david@kernel.org, dev.jain@arm.com, gourry@gourry.net, 
	hannes@cmpxchg.org, hughd@google.com, jannh@google.com, 
	joshua.hahnjy@gmail.com, lance.yang@linux.dev, lenb@kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-pm@vger.kernel.org, lorenzo.stoakes@oracle.com, matthew.brost@intel.com, 
	mhocko@suse.com, muchun.song@linux.dev, npache@redhat.com, pavel@kernel.org, 
	peterx@redhat.com, peterz@infradead.org, pfalcato@suse.de, rafael@kernel.org, 
	rakie.kim@sk.com, roman.gushchin@linux.dev, rppt@kernel.org, 
	ryan.roberts@arm.com, shakeel.butt@linux.dev, shikemeng@huaweicloud.com, 
	surenb@google.com, tglx@kernel.org, vbabka@suse.cz, weixugc@google.com, 
	ying.huang@linux.alibaba.com, yosry.ahmed@linux.dev, yuanchu@google.com, 
	zhengqi.arch@bytedance.com, ziy@nvidia.com, kernel-team@meta.com, 
	riel@surriel.com, haowenchao22@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: E73AA4000D
X-Stat-Signature: etek9fdn4jpf8x6kdgfu7mu6jh6hjxb4
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780514780-431671
X-HE-Meta: U2FsdGVkX18RFtbwmVRwGj9oDLe+8iM/ywZpLg0TJE6CraoV4ztqhwPcOPrLMBwRzd4i9zVBdqujj6NlOLOLjlfBBB1opulTY66jod8iPWZKYSo1AzAuaWbPEkk28zLru8+pACxiOammLkSRt9/pmb/+8/rmF9UybijVpKFD05jVu0kAas/mHilaZY5RZJogdSwknELTd773qW4CSpL1TApt+A9RnUUReH5Fquom5udtLQz+3WETSWHy18kkCOC+pguPdQrn67aeIz6p+oMZmP5yUxKjNqwvJKGWlwBI4O+6iN9dTpy6uNitRHfwNBZd0hVYTTCbe2jYdfpxyiLKKhjxbwuOn88gThGqeW8mcR+SQQuEKgj1ScZWtC4qepfJ/AXTIp9VYR9pwz57fJeKE+IClNPzuHBDeZ7kSnFvfZA5J2Goa08O2lASniu9vkuH9S0DKKvkCMWSAtNPKOT7DmbUdu1OVk5TY8y6D8/Uu7/dPZ5QSV+amYf8kG336MBTn/glFB64JBnQM9HSn1X81B+wUZrJiCS6G5dml7u9MEOPFKMl1TjPgNU7oV1bjUp6j2ShihB6kCboSRS+8gIDj6pV4OdtWwvQVOapuHdWB0RMOrwzor67tuW14q5XH2dND2wTRNGbTgl/RT75+f68/47ryHF3LsGmqAHWioDdzFWlenZNftl5wkvwFeJS2OZ3/gzp6H7nRCE6H9unhUgPQzBaz+NVVWHJhU7YzGlYFMU7sk0pEvdO5iFmQP5DbTSUwcnRuXlsTTlFDGU7dl37YWfy28NNyegcJZVTliRuDzlcg1F4f/pFT2P634eWv19DbB57b/Fkl1j5fUwwcZQeLgqbOlegGL9zMB21vnVRE09jE3u6tRyNUNSLX8QZ3uxsVEei2/7RjyUvu5osGUkzXriHfDzj0iW+zh6JNaVZ9kR3i7s3RXh1g/IRRdedEbDUK7wfxkmlOK6WO/9Mepw
 BszKz9hO
 rVuZQGuU7LAw/WvPRZ7som85p6pc6IjE+5zzmErsGGYUz+Fmg0/9AUV1yoXAl8kaPOZuNmXF9hdUlcPLbZYp6QgYbaR6LluFGiX0V6MxcZGA5M9ZMikUSLvl7sYkCUN91BmQbCHtxpGNS1XcSobm89tZiWk2YODrWKTkwDJpQmxxtQMSfw68vYL8JFKeURr3kkT/x5tjlN9WG5ALgicXe+EhozuBeRZ3x9FVMzU05zpXD/+zSrdjdy/1Q2qthqkgv1JfyGFj38bge6IpQToWHhrNTRSSGaK7cz81SNtarqTo9DmyXI3u1NxnDFabugjK/6YdR8nt0vK4C/BqIEm212kfmL9FSeuxGdiuNTRRGbuRDCUbP+zNYjWD320RJjK+wGLojs5tK2eP4AybzO4yD26Y3VzGzK0p9LB1CAa+6B2dFk1dJdIAX3ouXH8gn+3BSHDjfgao0VxVUMvx3/kYs0jVhK9LzbOz7veQz3zW5AfLKf0EoRIcXFiyTASccIBp+gSLeEsV0OpuxuIXGmZ67vUTTGQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 3, 2026 at 11:58=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> > > I assume the main reason here is to avoid the extra overhead if
> > > everything uses vswap, which would mainly be the reverse mapping
> > > overhead? I guess there's also some simplicity that comes from reusin=
g
> > > the swap info infra as a whole, including the swap table.
> >
> > Yeah it helps a lot that we don't have to rewrite the whole allocator
> > and swap entry reference counting logic again :)
>
> I specifically meant using a full swap info thing for the physical swap
> device even when it's behind vswap. That seems like an overkill, and we
> don't need things like the swap entry reference coutning. We probably
> just need a bitmap and a reverse mapping.
>
> So I am assuming the main reason why we are not doing that (at least for
> now) is simplicity?

Mostly.

FWIW, we're pretty close to full deduplication. Right now, physical
swap clusters have a couple of fields that are not needed when they're
backing a vswap cluster:

1. The main swap table (which houses swap cache, swap shadow, and
reference counting): I repurpose it for the rmap :) It's an array of
unsigned long, which works for rmap.

2. memcg_table: still duplicated, but I think I can make sure this is
not allocated if physical swap clusters only back vswap entries. I
have a prototype that I'm testing for this.

3. The zeromap field: this is actually not allocated in 64 bit
architecture, IIUC, which is what I'm gating CONFIG_VSWAP on. If we
extend vswap to supporting 32 bits, this can also be dynamically
allocated.

4. Extend table - this is for the swap count overfills, and already
dynamically allocated.

>
> > >
> > > I don't like that the code bifurcates for vswap vs. normal swap entri=
es
> > > though. Not sure if this is an issue that can be fixed with proper
> > > abstractions to hide it, or if the design needs modifications. I was
> > > honestly really hoping we don't end up with this. I was hoping that t=
he
> > > physical swap device no longer uses a full swap table and all, and
> > > everything goes through vswap.
> > >
> > > I hoping that if redirection isn't needed (e.g. zswap is disabled),
> > > vswap can directly encode the physical swap slot so that the reverse
> > > mapping isn't needed -- so we avoid the overhead without keeping the
> > > physical swap device using a fully-fledged swap table.
> >
> > Can you expand on "vswap can directly encode the physical swap slot"?
> > I'm not sure I follow here.
>
> I meant that if redirection is not needed (e.g. zswap is disabled), then
> instead of having a vswap device pointing at a physical swap device, we
> can just the data (e.g. phyiscal swap slot) in the vswap device
> directly. Then we don't need a full swap info thing and swap table for
> the physical swap device.
>
> This directly ties into my question above, about why we have a
> fully-fledged swap info thing for the physical swap device when using
> vswap.

See above.

>
> > >
> > > All that being said, perhaps I am too out of touch with the code to
> > > realize it's simply not possible.
> > >
> > > Honestly, if the main reason we can't have a single swap table for vs=
wap
> > > is saving 8 bytes on the reverse mapping, it sounds like a weak-ish
> > > argument, even if we can't optimize the reverse mapping away. But may=
be
> > > I am also out of touch with RAM prices :)
> >
> > In terms of the space overhead I do agree, FWIW :)
> >
> > I think the other concern is the indirection overhead with going
> > through the xarray for every swap operation, hence the per-CPU vswap
> > cluster lookup caching idea:
> >
> > https://lore.kernel.org/all/20260505153854.1612033-23-nphamcs@gmail.com=
/
>
> Right, but we should already avoid the xarray with the swap table
> design, right? We just have one swap table pointing to another
> essentially?

Hmmm, I don't quite follow your suggestion here.

For normal swap devices, we organize the space into clusters, and
maintain them in various lists (free, nonfull, full etc.). The only
difference with a vswap device is we do not have a free list, and have
the clusters themselves dynamically allocated.

If we're using vswap, we will incur the xarray overhead. There's no
avoiding that if we want a dynamic indirection layer. We can of course
revisit this data structure design later.

So yes, it will be one swap table (vswap cluster) pointing to another
swap table (pswap cluster). But to get to the first swap table, you
will have to go through xarray still.

>
> > >
> > > I at least hope that, the current design is not painting us into a
> > > corner (e.g. through userspace interfaces), and we can still achieve =
a
> > > vswap-for-all implementation in the future (maybe that's what you hav=
e
> > > in mind already?).
> >
> > That's still my plan. Operationally speaking, I want to make this
> > completely transparent to users, with minimal to no performance
> > overhead.
>
> So if CONFIG_VSWAP is set all swap devices are vswap by default, right?
> Would it help with testing if it's controlled by a boot param?
>
> >
> > The next action item is to optimize for vswap-on-fast-swapfile case -
> > that was Kairui's main concerns regarding performance. I spent a lot
> > of time perfing and fixing issues for this case in v6. The issues with
> > the most egregious effects and simplest fix (vswap-less
> > swap-cache-only check for e.g) are already fixed in this new design,
> > and eventually I will move the rest (lookup caching) and more to here.
>
> So is the end goal to have vswap be the default rather than a special
> swap device? It would certainly help to include some details about that.

That is my preference - I did allude to it in "Runtime enable/disable
of the vswap device" follow-up section :) I'm a sucker for unified
paths. It kinda depends on whether we can optimize most of vswap
overhead away though - if not, then we have to maintain both paths.
Kairui, how do you feel about this?

>
> > >
> > > Aside from the swap code, the only sticking point for me is the logic
> > > bifurcation in zswap. Why does zswap need to handle vswap vs. not vsw=
ap?
> > > I thought the point of the design is to use vswap when zswap is used,
> > > and otherwise use a normal swap table. In a way, one of the goals is =
to
> > > make zswap a first class swap citizen, but it doesn't seem like we ar=
e
> > > achieving that?
> >
> > We already have all the machinery to make zswap completely
> > independent. Right now, if you use vswap, you'll skip the zswap's
> > internal xarray entirely, and just store a zswap entry in the virtual
> > swap cluster's vtable.
> >
> > I just haven't removed the old code for 2 reasons:
> >
> > 1. Reduce the delta on this RFC, to ease the burden for reviewers (and
> > definitely not because I'm lazy :P)
> >
> > 2. The only other practical reason is so that we can let users compile
> > with !CONFIG_VSWAP and still uses zswap on top of the old swapfile
> > setup during the transition/experimentation period for now.
> >
> > But logically and conceptually speaking, there is no reason I can come
> > up with to use zswap on without vswap. The CPU indirection overhead is
> > already partially there (since zswap uses an xarray) and further
> > optimized (cluster loopup caching etc.), as well as the space overhead
> > (vswap replaces the zswap xarray). I actually wrote a whole paragraph
> > about how we should always go for vswap if we're using zswap, but then
> > decide to remove it since there's no code for it yet.
> >
> > If folks like it, what I can do is have CONFIG_ZSWAP depends on
> > CONFIG_VSWAP, removes all the non-vswap logic, and call it a day? :)
> > Then, on the swap allocation side, if vswap allocation fail and zswap
> > writeback is disabled, we can error out early.
>
> Hmm maybe we can keep it around for now and do that after vswap
> stabilizes? It ultimately depend on how much complexity we maintain by
> allowing both.
>
> I think another problem is 32-bit, technically zswap can be used on
> 32-bit now, right? So vswap not supporitng 32-bit is a problem.

Ah shoot I forgot about that. Hmmm.

It's not impossible to make vswap support 32-bit. I did that for v6
after all. It just needs extra fields because we have fewer bits to
leverage in pointers etc., complicating the logic a bit. Follow-up
work? :)

>
> General question (for both zswap and general swap code), would a boot
> param make implementation simpler? Right now we seem to key off the swap
> device having the "vswap" flag, would it help if it was a runtime
> constant?

Hmmm, even if it's a runtime constant, both branches still have to be
there, no? Does the boot param simplify it somehow?

