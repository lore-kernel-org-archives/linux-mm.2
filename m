Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2E90C61DB9
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 03:10:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0F3E6B008A; Thu, 27 Aug 2026 23:10:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A991B6B008C; Thu, 27 Aug 2026 23:10:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 961E96B0092; Thu, 27 Aug 2026 23:10:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 71F996B008A
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 23:10:41 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EC332A3BD2
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 03:10:40 +0000 (UTC)
X-FDA: 85149200640.30.BBDCA61
Received: from mta1.migadu.com (out-241.mta1.migadu.com [95.215.58.241])
	by imf09.hostedemail.com (Postfix) with ESMTP id B2B81140004
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 03:10:38 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XGQfXx2w;
	spf=pass (imf09.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.241 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787886639;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0Iqmvg32GGbKP2M3hLGgP+wucBtINQIgJgx2KMERq2k=;
	b=kQPYNdX3gOFJpW9m2fA/myArXEDLJTKJIiI+r7jPEmpkYSbFKcjfTjw/8M2gGanbcDKfk9
	FylS47E0TF+26xAPK9drJAEC5QH3wwQwiRwiqtM85D4m6MDQhbR4ltnKAnDCGHOFrhb47q
	tfKO6poDEc3BFuvFW59tSFQKWnNF2fE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787886639;
	b=V18SSYu0ka6qsnw5DCCCjuyRS7XhZklvUXOjLClPtLmsVlfY7bDQceNIKGuwxzguhNMtqy
	3Gj4qfpBj+m2fys6yzs6Nhkl66ANCmvihQa3PJG+9oA1vmiIivhtODgLGVZZxLIh4MAwn8
	+uV8gasnjHwchg02MDinFrrimSNgLS4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XGQfXx2w;
	spf=pass (imf09.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.241 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=hfXKRYN40nrVu7Eoi6miivu7UIIRPwt+ewg3z4W9IEc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787886636; v=1; x=1788491436;
 b=XGQfXx2w6iMYceE7NILGEYf9XUYW0HLS8aFsJ2qwMwXNplrTlNtDIId+yLQPWJbirT+e94nY
 tuVtUwgCKBO8WCYJzmX4tHPXVDflYGVsEAJahyCj8l+M4MFQ9A0LZMTl7RsNcyMn3VUTFh5maDQ
 Snwp4QS3BiJ3VNJ2Xr2ykzJk=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 4ac20235960621f5;
	Fri, 28 Aug 2026 03:10:36 +0000
X-Mizu-Trace-ID: 4ac20235960621f5
X-Migadu-Flow: FLOW_OUT
Message-ID: <afa606df-3d5b-47c2-9972-f3e0c2e13c12@linux.dev>
Date: Fri, 28 Aug 2026 11:11:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/2] alloc_tag: fix a leak and a deadlock around
 shutdown_mem_profiling()
To: Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260817062726.106511-1-hao.ge@linux.dev>
 <20260826203914.347c42aa00081ee9e0eb858a@linux-foundation.org>
Content-Language: en-US
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <20260826203914.347c42aa00081ee9e0eb858a@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: mc79qsjds65xw7f3p8g4tgpkc5yhi5zk
X-Rspamd-Queue-Id: B2B81140004
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1787886638-442232
X-HE-Meta: U2FsdGVkX19TEDhNw2AD3WBggqGL0FZhY6e0qqim2gGgjh+MY+N3qEUNh8Rcg7QzZIvNeY12ipj89tspjYmdDKarOS8Z79we6d4Hy6mLxhzBzREjijYaScsybsCnQSgi1XIxE3PQR2Bdw1OaOtFDkHgSZ5ZQeAfUQo4ixENZVVdtyU8nrnbtK2wCB66SjWbN8uEbZZKBgCSfK6AuGcmkPsiV/PJIgv6aoU208eov1W9H4J9oEqN++GinzLlaNaw7Hdy20tYOzl2xusO2wtJqUQpXPyioxyjZGPy5DbHS2keb9YZ2CooaO+SOYGZQ3olq7k2SieoQKNKpcCEO7dzrzA9nM0OyJZwdxvJr1Vf9YpXpZ6tNrFfhhEYyILJziV+3jIFSNyv2ag6OwF+qC26hIZ/UL7SBjMqt00jS/A5uWjDhwS0tgSgDtlj9fiCG5o82fr4Ckfr3MbqSz+IFu773EwAHtiWS9GN7zJACuITu/LbrJ1LgJK6lqRMNJd1GcQH2fZGbP2TvIXXpQlC3a3utMYhjhGzrco8Pj/Xf4Hc1ZOTEOrlk/iQCGI0NMDjOTS46bdlhcjWflSkg/xDNFffqO6RoDFwkYmsbSQR4Jta/X7k7TFLdI7OLs6Bj4waqrjWfiGm/QjsbPOHQ8AkOn+07gw94o6nvlkvMth7QaOz8O3swSPR3AxHfi/xfm7amRgX9Twhc1JY4Gx9lTP0xAyvtNaAYPDR9tMHyquyTWbXuuQF37ox2yRust/zj7tXTMmYDuVhMjrBcgZI/ku0RdewfEkUQY2izGIetYfA5jO/rcN00jy0d8w2PPzV3DA6XogV2JYaU6pdXowI3m21k8h3WKTdHmBiwePorCpyAka8JAZJYZJruUm7R8Z5mhfEO2qGAXV+rP2WtG1d01hX6OUnYaVduu8U31m2TTWOahSOGagbAqD7xm2Jo9lNa/cBBtXXwmfcd4kBCpebjdNJzoP2
 S+RFNdaW
 10pphbPXiMHZDksmzbenz/1IwYL2HbmqPFE3Hfwjbn7BdAf42lzjUWfZA4VS20kS3yBe/+2qKt1T/BVliKa3DMC04wNr9V3W3HcLUstZphJ7wKuUmAUYTX05lLCEmu5sOykOU4X9+0an++Dk3IY8yABy9QQvhTYYjmQdKDwS+NpRD++EYTQ2q78F+raoMOr7SDLIaHbPgh2E3k1KI5xzvmzmI5PO3cTLuOaKMaYYvac0cwNSmxkalc3u6cY3Z4Qd3wxlD4DCj/DEfPwOGMnZuYePmmlDfWBecgMYD/EbTRVyLxNfdgO5IdJ/OjbT8ZWwWHstWJi9Ml6ZR04d8S0QKe8HtpavI2+fHAgTraE0E3kdBXqyB6lYWDROjXWZ4uZvSIEF/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew

On 2026/8/27 11:39, Andrew Morton wrote:
> On Mon, 17 Aug 2026 14:27:24 +0800 Hao Ge <hao.ge@linux.dev> wrote:
> 
>> Two fixes for issues reported by sashiko:
>>
>>   1. percpu counter leak on modules loaded after profiling is disabled.
>>   2. AB-BA deadlock between module load and /proc/allocinfo readers.
>>
> 
> Thanks.  AI review asked two questions.  One pertinent to your
> alterations and one pertinent to Suren ;)
> 
> 	https://sashiko.dev/#/patchset/20260817062726.106511-1-hao.ge@linux.dev
> 
> I'll queue the patchset for 7.3-rc1, with a note-to-self.

Thanks for the heads up on the sashiko review questions.

The question on patch 1 (codetag_load_module() error handling)
has two parts.

The lost error code issue is already fixed; I sent the patch and
you queued it. (Thanks).

For the rollback part:

I've also seen Sashiko flag this same issue on another of my patches.
At the moment this case can't actually happen, alloc_tag is our only
registered codetag type, and codetag_module_init() cleans up its cmod
from the idr on every failure path, so nothing gets left behind.

That said, if we ever add a second codetag type down the line, the problem
Sashiko spotted will become real. I will follow up later to refine this
logic and make it more robust.

The question on patch 2 (async /proc/allocinfo removal racing with
alloc_tag_init() failure):

When I first read it, I think the window is unreachable. It requires
alloc_tag_init() to fail after proc_create() succeeded, and a process
to open and read /proc/allocinfo in the gap between schedule_work()
and the work running on system_wq.

But CONFIG_MEM_ALLOC_PROFILING is a bool, so when enabled alloc_tag is
always built in and it cannot be a loadable module. Its module_init(alloc_tag_init)
runs inside do_initcalls(), before /init is exec'd. Failures inside
alloc_tag_init() are already very unlikely to happen. When the failure
happens, no normal userspace exists yet.

That said, I realised the fix would actually be quite simple, we could just
move proc_create() to the end of alloc_tag_init().
I am not entirely sure whether we should do this though.

Suren, what is your opinion?

Thanks
Best Regards
Hao


