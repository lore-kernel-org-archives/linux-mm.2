Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77055D116F3
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 03:05:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C056D6B0024; Mon,  1 Dec 2025 22:05:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDD0B6B0026; Mon,  1 Dec 2025 22:05:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1A746B0027; Mon,  1 Dec 2025 22:05:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9C7886B0024
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 22:05:04 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 595EC13207F
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 03:05:04 +0000 (UTC)
X-FDA: 84173039328.17.99BB3CF
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6CF3C18000D
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 03:05:02 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eBxIFDjk;
	spf=pass (imf24.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764644702;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1TMOXL6yAIfCfUfBfRhzLBPkFL4/fzP/8gLyV27jj8k=;
	b=z6mIunQnW1oEOonFF2+/my/JOOdO8WMofU7ro1dTirApEuFKm+omAuWkKhyFrGvfScdT0u
	ZfLENuoO8YGx5M6GQsXPpdd8tfkY/ooJo2I5/MlzLDxOOUaVwsFDKmYCpMTN3f+kOSFEa9
	xVThV0ZJkUVbmyO1JhDXZcNvDLsQcXc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764644702; a=rsa-sha256;
	cv=none;
	b=5DMJjwN4bjbIZnGNhGzlZkUHtyW+zkL1VHeGLdvOfo0xngPqjVAosEneQxMxMEHrYFEeuj
	w1bo1fJY9vUaQcLmJ8sUVN8oPrVMm9yJnyrBReFxEkpWV8VPe1rxp+b08kMzrb0XnbCTHn
	DfXrzximBv+MecyTFIW2tYK5ip7KenQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eBxIFDjk;
	spf=pass (imf24.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <3595bfda-d7a6-44a1-bc0a-414c890e00c2@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764644699;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1TMOXL6yAIfCfUfBfRhzLBPkFL4/fzP/8gLyV27jj8k=;
	b=eBxIFDjkFXnkO1qpCt2R9+AuPQyxVxruuEBuSgndZvMd8I/255bYj4MMMs5hsQzlI9niuu
	mhtlxmUI1YFtjV5YyvPH1LbOGMCgiABiVppQ3n7+GVnQ8r2DZdLZFe4HGHk8JcqGv1XQ8E
	b+UxsouADo3ix9LQtltlTUT9cmtjmFE=
Date: Tue, 2 Dec 2025 11:04:02 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v1 23/26] mm: vmscan: prepare for reparenting MGLRU folios
To: Yuanchu Xie <yuanchu@google.com>
Cc: Harry Yoo <harry.yoo@oracle.com>, hannes@cmpxchg.org, hughd@google.com,
 mhocko@suse.com, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 muchun.song@linux.dev, david@redhat.com, lorenzo.stoakes@oracle.com,
 ziy@nvidia.com, imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, weixugc@google.com, akpm@linux-foundation.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1761658310.git.zhengqi.arch@bytedance.com>
 <cdcedd284f5706c557bb6f53858b8c2ac2815ecb.1761658311.git.zhengqi.arch@bytedance.com>
 <aScFNZjGficdjnvD@hyeyoo> <d94fe146-5cc6-4aa2-bd7f-8ca2a12e5457@linux.dev>
 <CAJj2-QHu3u1RQpkBw8uV9P+-xop+bJvxt+s-ZB_cj=u6ia+tbg@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <CAJj2-QHu3u1RQpkBw8uV9P+-xop+bJvxt+s-ZB_cj=u6ia+tbg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 6CF3C18000D
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: e9byx3f8hthquz713saewc47ebsfweuo
X-HE-Tag: 1764644702-967675
X-HE-Meta: U2FsdGVkX1/s8qUDRuudWTSppJaJa4rXPxLfg11HWXVsIGRSZoMH42up2LtY57GxBj7FjNKgRDGtFWLOJ9l7bcVXfr4N/L7e63KCKMaJZtGQXhijBd0NRq0EcFGL3OWmv8v8KuplkJmukK5eN6nKNURwCwAcwRlXo/l2VHpTfuDApCnMuY1IX7szmv8svSLiIC7k0viwYxhD0wrIYuEIEgdL5XVK6gpaQaqAQpMFcp1ganQdfYJdju9DUd+Zc1M5clEHYpCCIlIPegzsr/bxbeWckvw0X+G67S40zvkg8v0Bb7yNggmiu70rNZlinE835z6AdlISi7PIC1FtQsRw8hGvGIc6ZB36wcbfooGNrewz+njF3RFgB/xI00Bbk99Ee5oG2pSgwntB1wLYF1g1RUBhMgxOERt7m4JDXeErxpHWVaMetcDlZykhfzJqYwLy03u/wtMXrmCEM5Bh9LynStWXRk5YdFI+/WXDJGtg4xVCPSfqf+4dM2t6taao8UPpLBquGyGxR6Fquzp3qJ9e2i1vS3h/cmjMBhHzLWdrALAgU2F2rU7l6aD36EfDYUBi1AmjWEtxBJki5iPQMNCSaTaJ452+O9Zk/nxe/xlqAuW7qiybUmHlaJo8CZ8v7PWy2d3dc51XtaHmCeN6aZQ0hHd4weNRKp4Lm/j/eeFj+WvIJqfVTvAXgdLXypQXfnPzH1ivQGFdC+c5CCMsT7pzmhLhmq7WL47Eq9FFPxTjYsONdwSnP/IeTvBMJESf9OaFA3S9XQac8U+lSFdWPfPxCxIoW4QuqLWHC7bJ3VZVrDtfCc/M9yAvtMpAlM7gWVL3fneBSwlEHp1S3nzR3nLNgb6iuMap3NTJwWwu9v7vfe9PfPzgsJA3C6S5tFx70VAMfzvxk/NOXSvLf6CTx1xtLK47txjpp+5Zv3cKt/pOAVY6Eilnp5CBpVYWK92qVii7D7Pfk+C0Yfrlek/bO1e
 vcEYZE98
 q4F5LZKf95E2IyNkkxOVLzDIxZ7dh04GX4Gcg4aOjqGUTCzR8yIGSEzPMfPh3VYq+3qcFSS69I09OGzTH5hdxlCQvBrxQMdrhLF+XqaqO6uPATBe4HfUCf2wCckBHlRj0V1icc4qk7C2goTDzubwrzcK5pTWhdVFQnHM8Vosf5Yme6lLK5x/mSiuQ7514GZY34RA1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 12/2/25 5:50 AM, Yuanchu Xie wrote:
> On Mon, Dec 1, 2025 at 9:41 AM Qi Zheng <qi.zheng@linux.dev> wrote:
>>> Warning 1) Here we increment max_seq but we skip updating mm_state->seq.
>>> (try_to_inc_max_seq() iterates the mm list and update mm_state->seq after
>>> an iteration, but since we directly call inc_max_seq(), we don't update it)
>>>
>>> When mm_state->seq is more than one generation behind walk->seq, a warning is
>>> triggered in iterate_mm_list():
>>>
>>>           VM_WARN_ON_ONCE(mm_state->seq + 1 < walk->max_seq);
>>
>> The mm_state->seq is just to record the completion of a full traversal
>> of mm_list. If we simply delete this warning, it may cause this judgment
>> in iterate_mm_list to become invalid:
>>
>>           if (walk->seq <= mm_state->seq)
>>                  goto done;
>>
>> So it seems we can manually increase mm_state->seq during reparenting to
>> avoid this warning.
> Agreed, don't get rid of the warning as this check is supposed to make
> stale walkers exit early.

OK, will incease mm_state->seq during reparenting in the next version.

> 
>>
>> However, we cannot directly call iterate_mm_list_nowalk() because we do
>> not want to reset mm_state->head and mm_state->tail to NULL. Otherwise,
>> we wouldn't be able to continue iterating over the mm_list.
>>
> 
>  From the original posting:
>> Of course, the same generation has different meanings in the parent and
>> child memcg, this will cause confusion in the hot and cold information of
>> folios. But other than that, this method is simple enough, the lru size
>> is correct, and there is no need to consider some concurrency issues (such
>> as lru_gen_del_folio()).
> One way to solve this is to map generations based on
> lrugen->timestamp, but of course this runs into the reading
> folio->flags issue you described. I think the current method is a good
> compromise, but the splicing of generations doesn't much make semantic
> sense. It would be good to leave a comment somewhere in
> __lru_gen_reparent_memcg to note this weirdness.

OK, will do.

Thanks!



