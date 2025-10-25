Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54105CCF9E0
	for <linux-mm@archiver.kernel.org>; Sat, 25 Oct 2025 03:31:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3B838E0139; Fri, 24 Oct 2025 23:31:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC5018E0135; Fri, 24 Oct 2025 23:31:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DB778E0139; Fri, 24 Oct 2025 23:31:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8E9D98E0135
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 23:31:47 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 54BA45E8C8
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 03:31:47 +0000 (UTC)
X-FDA: 84035212254.12.337FC26
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4C52E20005
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 03:31:45 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BUKgjb1g;
	spf=pass (imf03.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761363105; a=rsa-sha256;
	cv=none;
	b=DHmKwssvE4tOkEXkoqv12yuJhi+g8YNeSMuOjQE5ut3grsMvv5mVU2rgYumzvbeOGro/4y
	O4j78QtP3NWAT9vV+2VxTSfxenr2qfZkD3MfBvx/X/IN3FKWXIX+TuJJ1yHm8YOIv4Difk
	++axEqB0RPR/qJvs0hVlSXgqmAfqGaw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BUKgjb1g;
	spf=pass (imf03.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761363105;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vrOROuAh2t0TxV1g/ZHhUSBmu1NMnGW6lj5cEu+eCAM=;
	b=JoDamkzfrpTQe8A4K/x286wcCuWs3J4mLJuhR752yHJrN2j/aPkPPxaex8/hL9xqbWD+eZ
	Ao6nQ+KpoVhjbtf0tYRwnTpRqGM9NsJ7YTXooOpquQE0EH8sTihcDa135I8IW51n3vSzSX
	IyYA9Ce9DRmtGrb2Sq3wgQdswfeJz/Q=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761363104;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vrOROuAh2t0TxV1g/ZHhUSBmu1NMnGW6lj5cEu+eCAM=;
	b=BUKgjb1g4ohkWZq5NGVGFtR12y9bT9Qb9R6rJ6d+/OI+a9si290dx4ISmRT0FQwCZEXwCT
	ltQhLyPIhlyhzhQsCUDfojw9oyU3lbhbRl27G8RYDXxCDZF2x8oyuqSJU78oKiTwWqaN3A
	lIX+u+SMM2hboPX8RK0xhh2Fdt/at4s=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-370-a0_GJqOkP2-gwcGckHzPLQ-1; Fri,
 24 Oct 2025 23:31:39 -0400
X-MC-Unique: a0_GJqOkP2-gwcGckHzPLQ-1
X-Mimecast-MFC-AGG-ID: a0_GJqOkP2-gwcGckHzPLQ_1761363097
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0E2B41954197;
	Sat, 25 Oct 2025 03:31:36 +0000 (UTC)
Received: from localhost (unknown [10.72.112.41])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B7FA81800576;
	Sat, 25 Oct 2025 03:31:33 +0000 (UTC)
Date: Sat, 25 Oct 2025 11:31:29 +0800
From: Baoquan He <bhe@redhat.com>
To: Kairui Song <ryncsn@gmail.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>,
	Chris Li <chrisl@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	YoungJun Park <youngjun.park@lge.com>, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2 0/5] mm, swap: misc cleanup and bugfix
Message-ID: <aPxEkSIUI5VAUXt0@MiWiFi-R3L-srv>
References: <20251024-swap-clean-after-swap-table-p1-v2-0-a709469052e7@tencent.com>
 <178e2579-0208-4d40-8ab2-31392aa3f920@lucifer.local>
 <CAMgjq7DuJp_zyW4NLHPoA8iDYC+2PaVZT4XzETV-okVUPLNzSw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMgjq7DuJp_zyW4NLHPoA8iDYC+2PaVZT4XzETV-okVUPLNzSw@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspam-User: 
X-Stat-Signature: yftqad16aykumfgfkf6sqk6ohubgjrdw
X-Rspamd-Queue-Id: 4C52E20005
X-Rspamd-Server: rspam09
X-HE-Tag: 1761363105-655700
X-HE-Meta: U2FsdGVkX1/5uBKS4p/w8e4ni0iffZ1SxTSmmaPgo4N4WBTFmq5id3ruC6ZEL6o4dnXOPDcTw24CoqULOD5e+A/QhfjvgxGPcI3SDz0sZVEf8r9Aje9nFoIIjx9x21EjrMvgAgNrZsURNvy3pIrjUQVLSrhU/L8BMOSCmKtEE5cogazDSSYTd/ofb4hraefSMKhguw4qCYI4383eXNTgyvZB9/IIrN5cVhlKp058sNmIRCe/DrWSiTU8xxGvDj2J2Ijrz2Ykb8mFEZlO8Eh3yhZUt6dGhWuDWsypP66n1igWlRVTopQPVaZQN0+yPGv1nOVp62zXQNZXMLvQOxQeMJ3p33amY7NJphuSQZKVvncvyTZLFzAYRHeX5IjIVyefdo6/QuJeOT7OcLWgmemY33WSxSP+PIgJ+abgaNj0nep1TUJ3GtolrqymiwnEPEVDt599Sfleb85hkHL/K5Py+AQziYF5N4louZv3lTmsB0njxOoQVBYRrqdKdF7cjv7ZAMl7ztL7ZtHCaA+SNY0GkXPXZDHmtiAcFe5mcSd8SkOtXLZqiRxGVBWrB8h2BzXH8ai955UqMbWjNSzcTqGsSqP98XhKZPIm4eAM0hi0cf7tJQGA5plCQYgl3QHdiHMBxVt75t2mMqTCqGA8hBWabzcnxpTgMCHfw89xguc2/FCZLRjmKwEdKWACzZLTg2eguKI3MandS5fSzzlqimtg4CKN0NquTN8AgDMDe5DimDu4zOgUM7ndFxNK83XXhm7iTihwunIxNaPyqNDWNpQcj04Dq8to3jiIfIKsXeNpXF2JXA3As00bKLr6xuz8LhrHjR3slgs7UL8A6f+z+lMnMwlv4fU1d+qHZldd0B3oWsaQaOTWzxgPRojzyOvAtukkvVLSfcpqZWKZg8iZY0yJ03j/W1y39+cdRUae0GfBlO8KKQWurMGW6/jqX8eChfFX8zhDbCN35u5cL8BT6Jk
 LylLDfFb
 IEP7zyfgXDLDGePZvin0SXpY29NPrw01loozrPfDM51UXjzPPP1b56pPLZ2o5NsHcni8PDARk4bJkPVhBKv01DaoiTaMgqCU1aYL7WN3ygw5+9r6yqGJAjfFtIlFQkSSGExiCgd5FU1gNE2nYh6Zz4s5EXRjCTUixBuMzdvZEqeWRWphbwXEYgNBnU+IfRgOwpuBriqp+20QVUam+8Vi+RU8uP3rCvNXmdknoam8viqBXNxDzae3wQFS1kmAlSx8QPPTmYaZRggx2igmOjM7gl6qz0rgRVs3X+a0w8f0ULCZ/Udijc03AWety/TMwPq2VMLzdgnABjzfqsEtFh3kBPEthOudzTszmEVvmpD6W2RADC/4NBSEk62ibk28d5Fgqf+wjI0bB6LeUtCf4bt1bLHV2KV3FCSzmU1iuxyfX/dOEqfbMqR5TImKrSVoM3udpF1iY0azcvr8TgK1cufYBR7D3eJlY7xo9pBs1FxtR61Lzko34yWnP7CPt6g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/24/25 at 09:26pm, Kairui Song wrote:
> On Fri, Oct 24, 2025 at 9:18 PM Lorenzo Stoakes
> <lorenzo.stoakes@oracle.com> wrote:
> >
> > On Fri, Oct 24, 2025 at 02:00:38AM +0800, Kairui Song wrote:
> > > A few cleanups and a bugfix that are either suitable after the swap
> > > table phase I or found during code review.
> > >
> > > Patch 1 is a bugfix and needs to be included in the stable branch,
> > > the rest have no behavior change.
> > >
> > > ---
> > > Changes in v2:
> > > - Update commit message for patch 1, it's a sub-optimal fix and a better
> > >   fix can be done later. [ Chris Li ]
> > > - Fix a lock balance issue in patch 1. [ YoungJun Park ]
> > > - Add a trivial cleanup patch to remove an unused argument,
> > >   no behavior change.
> > > - Update kernel doc.
> > > - Fix minor issue with commit message [ Nhat Pham ]
> > > - Link to v1: https://lore.kernel.org/r/20251007-swap-clean-after-swap-table-p1-v1-0-74860ef8ba74@tencent.com
> > >
> > > ---
> > > Kairui Song (5):
> > >       mm, swap: do not perform synchronous discard during allocation
> >
> > FYI For some reason this commit is not present on lore, see [0]
> >
> > [0]: https://lore.kernel.org/all/20251024-swap-clean-after-swap-table-p1-v2-0-a709469052e7@tencent.com/
> 
> Thanks for letting me know, strangely, it is here:
> https://lkml.kernel.org/r/20251024-swap-clean-after-swap-table-p1-v2-1-c5b0e1092927@tencent.com

I don't receive the patch 1/5, thanks to the link.

> 
> But the In-reply-to id is wrong. I'm using b4 and somehow patch 1 was
> blocked by gmail's SMTP so I had to try to resend patch 1 again,
> something went wrong with that part. I'll try to find out the problem
> and avoid that from happening again.
> 
> I'm seeing that patch 1 is being merged into mm tree just fine, I
> guess that should be OK.
> 
> If anyone is reading the threads, this url above should be helpful.
> 


