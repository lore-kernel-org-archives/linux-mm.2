Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60CA2CCD18E
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 22:41:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 739A88E0090; Tue, 14 Oct 2025 18:41:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 719698E0041; Tue, 14 Oct 2025 18:41:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64E528E0090; Tue, 14 Oct 2025 18:41:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 54DC68E0041
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 18:41:03 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BA9B4160711
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 22:41:02 +0000 (UTC)
X-FDA: 83998191564.20.A0BB490
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf20.hostedemail.com (Postfix) with ESMTP id A4C001C0003
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 22:41:00 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FfwcNndM;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760481661;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7kymx9Ck3BaRbtCBkYGP0422cwTTn/aswqpSO+MgSvA=;
	b=g8twgZ6CEp0PYJGLy7q2sb71lWuDsHDnFFc/RDvy9ybbihVv6LH4mznhusIWNNlGVvsRh2
	lPtsrvldsUExP2ffy6CS+NxNq3OrIghOcBh9IQ/mFvKLYy261a7KLKuYAHaeGG5CemV5Xi
	NcDhFJW5KwHmNMtMax75aAappBCG0gA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FfwcNndM;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760481661; a=rsa-sha256;
	cv=none;
	b=DP6El7xImLZQNiRGoeprJhsqq8hTuO6kuOuDrnS+gMxQiU8w/nQiLCD2xMkMCRUtCFhbq1
	bH+GbkfZPD7eJzgpakaQYVRdykuItciKuo6PXWzhHrQ2/uG6+M61nHreKdhnCbrm+mjW8L
	IVP+VSS714OnZvB+Jc/msdkT3r0C++M=
Date: Tue, 14 Oct 2025 15:40:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760481658;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7kymx9Ck3BaRbtCBkYGP0422cwTTn/aswqpSO+MgSvA=;
	b=FfwcNndMIvuZehmylvrdGiExadwXIbk3/1qViaC6bJJUUD3T1VC2r18YrQfykTdqEDgD9P
	zIxKqXQNLJrI/n2vxVZxUCW5nl/JKRgAL+N6jCp6AJinamOlQwD7ezvRpGR5qBIe3O1vqK
	gejPMoT7vgJLDMCXCcXTfzw6r372xrI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Suren Baghdasaryan <surenb@google.com>, Hao Ge <hao.ge@linux.dev>, 
	Alexei Starovoitov <ast@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Hao Ge <gehao@kylinos.cn>, David Hildenbrand <david@redhat.com>
Subject: Re: [PATCH v3] slab: Add check for memcg_data != OBJEXTS_ALLOC_FAIL
 in folio_memcg_kmem
Message-ID: <j7tcixbgyo5ongfv33d2h4dvmko7ygrwi5fww2nc2op54nmvz4@ofwy5jpcvcrn>
References: <20251014152751.499376-1-hao.ge@linux.dev>
 <CAJuCfpGBxUmvWoe2xv2-bsF+TY4fK-m1-Z_E3OcyTiSYz5KeAA@mail.gmail.com>
 <vdngz65wojqalim4xb6vxb6k7upbzmkfoogmbuswc4lowju3ke@32hgwjlzxibr>
 <df175b09-c0db-4dc3-a0de-e1c38f70147d@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <df175b09-c0db-4dc3-a0de-e1c38f70147d@suse.cz>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: A4C001C0003
X-Rspamd-Server: rspam03
X-Stat-Signature: bjyifwor8gf6wqaxhe8sh579iu5uis4t
X-HE-Tag: 1760481660-859205
X-HE-Meta: U2FsdGVkX1+rbiVCFRSGVi3VFC/t/GaCihT6A7EdVSIgDsbNhWQrfbYp17cTATLz68zwwEolTwLEMlClONHj9hdApfoJnsgBcOZZ2G6uPlN/eTmUZoM/vqagqXivKCTpJg8i5UJlVjlBuZYckAMe/bzvSiv6eVWspLNyZKxagDuJNvxSk2fvtCIUJ8iHzzx8bWxRyJCSu5h4KQKQFd7DptIE8ta5qx20adzvoFpyO5lVSQewOI7WFcp/UDZrMD1HxnQSQxPqZo7nway2glYzF2kbVqWLW3o1RSPV0HFrNYvbi4oO/11ujAiQRZ/YBppilfHkZ0+pFuihk5Dmbzr31vhFyriUG3fLJRrlMdscoU0XQUdiiOYJuAJF0dvJ5EjdRNa1djadO7vkNSYYQDXOmWmYKxVpwbVZI8ICzldZBIy7nXsq+lLwao2ZWRQ/SiaVTTGXdhQo86NCDi0x178nzAaS4CGLmLKjgituFcgC/IBI//cuSBxdwuELnJHJgh0/7JwC0wEIgb6xmCVbkHO3/aGP2PogBiGBVC/dF4EdHIwsw/Ti5qZEeK1N22GR/PIYovkMknl7I4ZzwMXlpOfjHexWtdTBjcmzJhUSs70lBJ/58n81gTxMYgSvcSbqSMWgbFgYHOlZXrNpsVDy1BwvbL5kjNGDs2MnXfQfObT6DF3NaAssPU3XmUE3YTMzAFfdng9I1riYsrAY/HL6l2yvbr502z0uMWMyWtufY1KA4olcwJciYB3Y2kRjJEiRDQJ9VA0BfDYoBWeBsVUNImJijej3TcLMhsSBvxaVe3TisB1LKekbruWd60hJnJ5NiY7oQd81uW/mfks5xb/j4KHgh8P1wUn6pw0EE11AkYG5Cr9xCYOKG9+OwjZs2LTnKbytR+PP/aPnXWG5uCzJkAZr1Q5PSGbTehFJX/j5g9ze//EGFrZ6YjrsOsY5RxmDAjayb7Ho5k2WeRbxHkX1rQV
 0lUIXh3e
 T6cpyzW9NQ4SAKG5V7PiInN4eL6mgmiCe91XEHVjqne2NM4RYhaFhX97kxNZugaZs1l8TKFbUV7X1VbK06j8IpscUpv/kMYcpwryauMvLOUGEnO/DiMRHiukySS9mTcZxiOg+ziQHjVKA6ln+Lxs2ZfN+nn9/NO8uFZp8Z3L29kkRPSpvTufyvW+IOPVzlVvw/Io7KJLQfNDj+EjpUj53fA3Bqf3AAir0uOfQ4DKcT+gtF8Xv0C0wJyWGywFTv1lsi5WoMuolzzD5ZAd3VwTIhpfXPSm8QeWibKjMp4YyNjPj5Pr7568hV4HFmaiINtwx1eoOfryBOCnx6WAXIQXr48B+OHeBD1Mi/wvO7pPTWKwAXAyhYieJMbN1eaOelRsjst5onz5sXw0YK48=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 14, 2025 at 10:58:25PM +0200, Vlastimil Babka wrote:
> On 10/14/25 22:14, Shakeel Butt wrote:
> > On Tue, Oct 14, 2025 at 09:12:43AM -0700, Suren Baghdasaryan wrote:
> >> On Tue, Oct 14, 2025 at 8:28 AM Hao Ge <hao.ge@linux.dev> wrote:
> >> >
> >> > From: Hao Ge <gehao@kylinos.cn>
> >> >
> >> > Since OBJEXTS_ALLOC_FAIL and MEMCG_DATA_OBJEXTS currently share
> >> > the same bit position, we cannot determine whether memcg_data still
> >> > points to the slabobj_ext vector simply by checking
> >> > folio->memcg_data & MEMCG_DATA_OBJEXTS.
> >> >
> >> > If obj_exts allocation failed, slab->obj_exts is set to OBJEXTS_ALLOC_FAIL,
> >> > and during the release of the associated folio, the BUG check is triggered
> >> > because it was mistakenly assumed that a valid folio->memcg_data
> >> > was not cleared before freeing the folio.
> >> >
> >> > So let's check for memcg_data != OBJEXTS_ALLOC_FAIL in folio_memcg_kmem.
> >> >
> >> > Fixes: 7612833192d5 ("slab: Reuse first bit for OBJEXTS_ALLOC_FAIL")
> >> > Suggested-by: Harry Yoo <harry.yoo@oracle.com>
> >> > Signed-off-by: Hao Ge <gehao@kylinos.cn>
> >> 
> >> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> >> 
> >> nit: I think it would be helpful if the changelog explained why we
> >> need the additional check. We can have the same bit set in two
> >> different situations:
> >> 1. object extension vector allocation failure;
> >> 2. memcg_data pointing to a valid mem_cgroup.
> >> To distinguish between them, we need to check not only the bit itself
> >> but also the rest of this field. If the rest is NULL, we have case 1,
> >> otherwise case 2.
> > 
> > With Suren's suggestion, you can add:
> > 
> > Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> 
> Thanks, I added Suren's suggestion and pushed to slab/for-next-fixes:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git/commit/?h=slab/for-next-fixes&id=711c435c89e59ee32bf8bb1c0d875a07931da5a8
> 
> Resisted the impulse to change the single VM_BUG_ON_FOLIO to
> VM_WARN_ON_ONCE_FOLIO because we're still going to do that systematically,
> right?

Oh is there some coordinated effort happening for this conversion?

