Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FE44606A322
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 02:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ojX0EpIo
Received: by kanga.kvack.org (Postfix)
	id 572876B05B3; Sun,  8 Nov 2026 21:33:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 541DC6B05B4; Sun,  8 Nov 2026 21:33:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4321A6B05B5; Sun,  8 Nov 2026 21:33:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1C2546B05B3
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 21:33:09 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8A4F4160572
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 02:33:08 +0000 (UTC)
X-FDA: 85414008456.16.6019F09
Received: from mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf27.hostedemail.com (Postfix) with ESMTP id 908A740009
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 02:33:06 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ojX0EpIo;
	spf=pass (imf27.hostedemail.com: domain of cui.tao@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=cui.tao@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794191586;
	b=3Vv17o8GbqILfaiUmZX8UPMseKR/3oMYGjERie5iYjvkSwNIxDn7EroSiFvP11tn3I7vEF
	NafneHRjPEph0uJFCvlBsmRstI0N8dxWYb1v5Oh89nQeBT1ia2qo8gbibU0hHlZB9lqcP9
	pD0rAjY5QAnzTmcR4CIiLgDojx4GP6Y=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ojX0EpIo;
	spf=pass (imf27.hostedemail.com: domain of cui.tao@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=cui.tao@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794191586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kB3IFpQ0ZIO1cp7bsYqiegxOLRHS/D0OEp5d5P2E9bs=;
	b=s0cBSdm/PYbVpQRgN0wu+i+Ph9ZiqHZ7WtQjnYNR4s3KKedaBjXGTKifsVKtOF0GGPtj/0
	EIzpKqAEOoBAXhY/UFJ/RYITBTZGZXJIwYoLSBWSTzrjzBAk2A1rfufsU0fsNI6K1UzV7F
	eZ+t0OiqFpBocuGpkg7vpmCr0P9EnGQ=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=nmqRaiM/EiJNizjn79AmK4k2MmWrkYTwEz2GWquosKA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794191583; v=1; x=1794796383;
 b=ojX0EpIoXW4Q3WWoKTSHFyYfVB5/NGKPMoZkCmCbZqBScUyhu6sLm3yjkz3APWW4PPjlGsGs
 08BhfDJF0/bIs+cEwtmQZ/pXWdCFPiZK/kLkGbfQD3yI047xH2MZMmKuO4QwBQXVhNIdwf/A+O3
 H3ZmjPkz0bDxno5X6rlhxv2w=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id fa418301c63af391;
	Mon, 09 Nov 2026 02:33:03 +0000
X-Mizu-Trace-ID: fa418301c63af391
X-Migadu-Flow: FLOW_OUT
Message-ID: <c6bf9ef4-5a61-4f4f-ab39-11d1ddf59d64@linux.dev>
Date: Mon, 9 Nov 2026 10:32:01 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: cui.tao@linux.dev, akpm@linux-foundation.org, dgilbert@interlog.com,
 mkp@kernel.org, loberman@redhat.com, jmeneghi@redhat.com, kraxel@redhat.com,
 vivek.kasireddy@intel.com, mst@redhat.com, jasowangio@gmail.com,
 eperezma@redhat.com, stefanha@redhat.com, sgarzare@redhat.com,
 rostedt@goodmis.org, vdonnefort@google.com, mhiramat@kernel.org,
 jgg@ziepe.ca, kevin.tian@intel.com, axboe@kernel.dk, linux-mm@kvack.org,
 James.Bottomley@hansenpartnership.com, sumit.semwal@linaro.org,
 phasta@kernel.org, joro@8bytes.org, will@kernel.org,
 linux-scsi@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
 kvm@vger.kernel.org, virtualization@lists.linux.dev,
 linux-trace-kernel@vger.kernel.org, iommu@lists.linux.dev,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 bobbyeshleman@meta.com, mathieu.desnoyers@efficios.com,
 robin.murphy@arm.com, mason@kernel.org, aesteve@redhat.com,
 harry@kernel.org, vbabka@suse.cz, cuitao@kylinos.cn
Subject: Re: [PATCH 2/7] dma-buf/udmabuf: account the page array metadata to
 memcg
To: "T.J. Mercier" <tjmercier@google.com>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
References: <20261106131829.3228926-1-cui.tao@linux.dev>
 <20261106131829.3228926-3-cui.tao@linux.dev>
 <1e18fcfd-785d-43cc-afd6-d181bf8305eb@amd.com>
 <CABdmKX0nCB2hT+iMh=BB-nC=fUBPof8YvjvO-gtEw+zcHZgvZA@mail.gmail.com>
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <CABdmKX0nCB2hT+iMh=BB-nC=fUBPof8YvjvO-gtEw+zcHZgvZA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: mchhyxqzzt6jgaqktpn6ce3c11d61mez
X-Rspamd-Queue-Id: 908A740009
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794191586-830393
X-HE-Meta: U2FsdGVkX1+C+1tlDlAaEJEmwLP8IRN58dSN9EDWWGxicIOtRMQTPnDQSSWvQIsvZTUv5jCKGFCAaCgjFCXOvi5KYAM+kwQ0V8DcX1ZwX67B/5f0oJZNA7bHrciXWvkvJEfgig9nRfrqSVnrRhFYLxLXpRY7Wpf9VRRWIw1J3fp5ECfL5Xbj+6UiHYRwd4zktvo3OHJIfLf/ZdUcRBPL+lJmRNXVMcG5/m5gd2oZtxNUD8ld9yKEZWOdtlcYy3l7nlepk8+2vDitwLSywRa/0FR8ELO2IGpt9aeJEccIA82RGBzTmIMm/Uovtw9fT7amWimpaKwOKrZSssdrF88k/RQyzGkrdcKy3cfxhZUuiXi6lv50+1KOfJ7qGeWKtyP/9/+yIXNL4qxwhVcltsNECnzzb/eWlq5ncGIEcBpfyHS65dF09d1EUd4nQocxVaMspQ07rbnyuNKs+l6pmoGHFDD8WvAZtbtRvgRJ0nFvqotvkdVd2QjPrsp2vc9Z6/KSXW5p02aidzGfV8CVzU0Z7jdO9zBYsfG6Dx9R2eh6HozBeyJtecGiX6MzL7esxsG+8LV/mGElbZpPhJf2LniIEJO/BhyJRSA0cq0YDEdhBk1o6Frp9J+6nDAqmOSo8NEOXxFWJhxp0iodDr4l5SBpp1WCq5s6f91DbfuP90vziq2FANcdwvoAF4Ye06XMXjQ4QN1EtKRamaEsTBkl7DlYr8LPJPBndprfVyFCSmbQgqUUbqwqQiksjKy9hoblSmz2HKw1q4/YhxO3MTCjuHF9FpvH3GvEj/ItX9OMc6fl+ywQL6pTwqO09IlLFteniwV6cZQR8s33bXuTHIF8tHxUBA7MUndewAVg0DB7l9Dk/btgWb6WYGK/H1sg7bZS61VtxZlosx26cCRVpW9HHBdb6KoMSJ4e/oPzBuB7husI3Q6NsFjvs2sAh3q0CXtA13JVav6HlswpQnpJIiJQT14
 pQ0SPAyh
 mpECX7bMVu55kHGGraFoHd2wkCHe6UVnzHKb8Dc7Y5usZRMQzHNUs5N5QjpixjhNvWC33MbGYFPtSzjF74ZsI9a6MDu9EKNhqdYoH66o13eBZ4yoeKmau/SpvC+iKDYrkvgU6F18/j2fpaK8ZIyo7kQf3QF58BIqnasQHdbILdH5ikN6o0pN9987kE+4a6pOitITW4/MUnu01p97A/R3eS5gIesCnMmoI7qjOY1sQq/z/9yeCEKDCcMPCgVg3rebnSxlR1V4ARE4kbaozyjPFqPWKVzAM/xGYPZrLgnrAOt9Vwo/PEExSqr0t6Tp1HL5nPngKhtCj8yiKANBX0c7rA1TMoYJYl3zwyIPvQxMQyrUxn6ONNU6w+mKA70cQz0unsJcXQv8EUckd4+Ml2v8fj6WePnhwGa2P+39Ds6KM+u2SE20=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hello，Christian，T.J.

在 2026/11/7 01:25, T.J. Mercier 写道:
> On Fri, Nov 6, 2026 at 5:23 AM Christian König <christian.koenig@amd.com> wrote:
>>
>> On 11/6/26 14:18, Tao Cui wrote:
>>> From: Tao Cui <cuitao@kylinos.cn>
>>>
>>> udmabuf pins the pages of a memfd and hands them out as a dma-buf.  The
>>> data pages keep the accounting of the memfd they were instantiated in,
>>> but the bookkeeping around them does not: the page pointer array and
>>> the pinned_folios array, both sized by the buffer page count, plus the
>>> transient folios array sized by the memfd folio count, are plain
>>> GFP_KERNEL.  A 1GB buffer costs about 4MB of uncharged SUnreclaim
>>> memory, and size_limit_mb defaults to INT_MAX.
>>>
>>> Charge the three kvmalloc allocations so the creator pays for the
>>> metadata it induces.  The system heap in the same subsystem already
>>> accounts its buffer allocation;
> 
> Only if the mem_accounting param is set to true. We (Android)
> currently depend on it being disabled because system heap buffers
> don't have a single owner for their entire lifetime (ownership often
> changes immediately after they are allocated), and the kernel doesn't
> have the ability to switch who is charged for the buffer memory quite
> yet. Albert is working hard on it at the moment.
> 
> Could you update the message to note the mem_accounting param pls?
> 
>>> the data pages here stay with the
>>> memfd.
> 
> memfd / udmabuf is a little special because it uses shmem for the
> backing store, which is already tracked by memcg under all conditions
> (except hugetlb). We don't currently use udmabuf, so the lack of memcg
> charge transfer for udmabuf is not an issue. But once we get charge
> transfer working for the system heap it'd be good to follow up with
> udmabuf.
> 
>> T.J. needs to take a look here, but I fear that this might break uAPI.
> 
> Thanks for looping me in Christian. The buffer allocations cost
> gigabytes, but these metadata arrays are only 4MB per 1GB of buffer,
> so I don't expect charging them to break anyone. Leaving them
> uncharged is an accounting gap though, since someone could spam many
> udmabufs from the same memfd and only pay for the memfd pages once. So
> this change is ok with me.
> 
>> A lot of the DMA-buf resources are intentionally not charged against memcg.
>>
>> Regards,
>> Christian.
>>
>>>
>>> Signed-off-by: Tao Cui <cuitao@kylinos.cn>
> 
> With the commit message updated to mention the mem_accounting param:
> Reviewed-by: T.J. Mercier <tjmercier@google.com>
Thanks, Christian，T.J.

I'll update the commit message to clarify the mem_accounting parameter
and pick up your Reviewed-by tag in v2.

Tao


