Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43917EB3636
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 21:28:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B1CB6B014E; Mon,  2 Mar 2026 16:28:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7648B6B014F; Mon,  2 Mar 2026 16:28:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6756A6B0162; Mon,  2 Mar 2026 16:28:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 59D016B014E
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 16:28:06 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 182281A0319
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 21:28:06 +0000 (UTC)
X-FDA: 84502410972.13.29200AC
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9D00F10000D
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 21:28:02 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=POwJT585;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772486884;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fyfyeOjenhJY4nI2/2R4evalYM5N/W5OnG79VEXJQZE=;
	b=HUpes7dMI1ZRX9FIAPgCgR/9RVLUHg0y5wflWra39hY0qCSaC0uCUd6G2zrW1J0IGnLSE1
	fTP5wZERR/EnSyi7MW9FKN/nf+PItk7F393bVYly0bMb0JwzkKihefD5mEzdz/e4jqUIOE
	ZtMeHh1GI0pK31vn1eEm00/FEE0jAOw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772486884; a=rsa-sha256;
	cv=none;
	b=GlkyenTapeL9Pop0xhCFgDeDAr190jdZN4aJ1K+0/JXSb7BjV5GmtuzWfqt58SEIVCRmAn
	xaAs4jqUM8WGbwPJow29VZLpJDgXi7thIeOWkb0wpykJ+qczgqPC5/a+iORZ+8bTulOtle
	I8lXko/zCMMZRgh0tOIjId5Wa3f+/yU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=POwJT585;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
Date: Mon, 2 Mar 2026 13:27:31 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772486877;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fyfyeOjenhJY4nI2/2R4evalYM5N/W5OnG79VEXJQZE=;
	b=POwJT585eR2dlo1KJTx/3uvC6mpuYWU3W0nMBUG2I/bRe8JnlV/JzJVz4OSQr55ga1M54A
	hd7BOGWLF50IkWQRT0l32SEV0gmtOWsi9t4xMyB3Zrlr38OfnN6IxqoaCog9gJFwL7WsQx
	Y3HEYTAwA36vnnQYTaBzxS4rfqbyLvA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: YoungJun Park <youngjun.park@lge.com>
Cc: Chris Li <chrisl@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	Barry Song <baohua@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, gunho.lee@lge.com, taejoon.song@lge.com, austin.kim@lge.com
Subject: Re: [RFC PATCH v2 0/5] mm/swap, memcg: Introduce swap tiers for
 cgroup based swap control
Message-ID: <aaXM58EsMtbGri2B@linux.dev>
References: <20260126065242.1221862-1-youngjun.park@lge.com>
 <aY4bQFvpPRWgnOTM@linux.dev>
 <aY6hcPNxiolf5jj6@yjaykim-PowerEdge-T330>
 <aZjxP2sTavBRGC1l@linux.dev>
 <CACePvbU=4f4gT5kHUBq0wD7COHN+quE5g4bPQqJYgJNx_9vuhg@mail.gmail.com>
 <20260221163043.GA35350@shakeel.butt@linux.dev>
 <aZpY1FIjYLtLdu5F@yjaykim-PowerEdge-T330>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZpY1FIjYLtLdu5F@yjaykim-PowerEdge-T330>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9D00F10000D
X-Stat-Signature: 54iyidsgwr7c9ucenhex636ubbd17sgx
X-Rspam-User: 
X-HE-Tag: 1772486882-395983
X-HE-Meta: U2FsdGVkX1+dbr9SqIp7jOncM5dkLhfShb7blWzCQeQyw5uPb90dTMLNM7e8bOUVrkRP37Lp/nWkkN4fC/ypGC5NIrq3bUAkiqNh9QiM9n/C2sx9AW/QhBZBTruYTt/lvvi/87e5b6uF5udL3N9gnxl4pgwyRgQP2IlZmU+xjztCBNMectn5dJ9VGN7ea9D9HHJe+kHf+UK6RUOj5js96uv3t9djUvS3z5zpYT7nckiCQliDJB6x+euz6kqQfv64mgs2yd0M9LMaj2UsfI2oSVGzrmkGzdM7mEzgY5nassqDsmKdsjHLFtBn1q2fh6zGZpNetO6rLfDggAxAjR6zMzjAsYf2KrIQ3vi75mvAOfjLk1o25XRKOmBi/NR/UzzkZPvHfX8WVNS3gAdmxhUA2kk2z3kL+aur44NdnYfw5bbgqj0sGFX7xqU1j5JhfuQ7j6gJKvF3GcIlf7mrLCPcBGtGvNvfn/PDcpGoVpWgwa0uOT+WAsD+HIJz1M+m4GCJOCoEad/J9hlTqBO1+fSQ7lpcY3uh5H2O/e47mu6jsBZn/GsG7Zrr+/NsysI++8gJ/HfP03pL7gcYU2LmsdhUYWlv39Mz/8TrqibE6tpa6yoXmk+2y1dqZ+HzqBRy5DmCtFjYa91PYqDg9fTl2/9RfN+lMkNkyjCI3CnE7LVPFomjY3xLkm4cXUrHChsuERRmbgye7dIFA+7maBoAenpAaOl25Xmvw7palszr7/NtAne68v9aWmOA6DaiCy0eWVcm2nAqyToVjZ6IDOp/CCiU6RGswD0vP+eJLHM5Q5KjMogSb/osmkSSoC2ro1CoqdBbyaghdG35RjNU1Eh3FqEmRQATf2DuqdvLe3VrCFlrsrAaeF8PRgUcUqxHiAMgU2XgE9tXsS6WO7FYH/pqXa+asiimBctbTBZG6dD/BSk3wrZpjnqWHI9xYQaOq+k+aT4imPHijbRlVEFuBy0VmUQ
 670kzASw
 Xw+/BlarNAihpJbhK+U3LhZPZepV3f6HasdgVoTG0mcFwxOcifqYuhOo4ZOKy2OFLkL4XfK/odeRxVOM8N7mnWwiPLpfvc6OwmVkOE41Dbn7sOOvhiPB1bFZu8z4oFPli/UApRvGTNI5WKGHrOfIJzG1r1n7gfVTueqZG1l1h9x+l7LS4S8npsDyZVSgBdt5dSInVhjWOkVB82db+plr+Xfg1Jw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Hi YoungJun,

Sorry for the late response.

On Sun, Feb 22, 2026 at 10:16:04AM +0900, YoungJun Park wrote:
[...]

Let me summarize our discussion first:

You have a use-case where they have systems running multiple workloads and
have multiple swap devices. Those swap devices have different performance
capabilities and they want to restrict/assign swap devices to the workloads. For
example assigning a low latency SSD swap device to latency sensitive workload
and slow disk swap to latency tolerant workload. (please correct me if
I misunderstood something).

The use-case seems reasonable to me but I have concerns related to adding an
interface to memory cgroups. Mainly I am not clear how hierarchical semantics on
such interface would look like. In addition, I think it would be too rigid and
will be very hard to evolve for future features. To me enabling this
functionality through BPF would give much more flexibility and will be more
future proof.

> 
> After reading the reply and re-think more of it.
> 
> I have a few questions regarding the BPF-first approach you
> suggested, if you don't mind. Some of them I am re-asking
> because I feel they have not been clearly addressed yet.
> 
> - We are in an embedded environment where enabling additional
>   kernel compile options is costly. BPF is disabled by
>   default in some of our production configurations. From a
>   trade-off perspective, does it make sense to enable BPF
>   just for swap device control?

To me, it is reasonable to enable BPF for environment running multiple
workloads and having multiple swap devices.

> 
> - You suggest starting with BPF and discussing a stable
>   interface later. I am genuinely curious, are there actual
>   precedents where a BPF prototype graduated into a stable
>   kernel interface? 

After giving some thought, I think once we have BPF working, adding another
interface for the same feature would not be an option. So, we have decide
upfront which route to take.

> 
> - You raised that stable interfaces are hard to remove. Would
>   gating it behind a CONFIG option or marking it experimental
>   be an acceptable compromise?

I think hiding behind CONFIG options do not really protect against the usage and
the rule of no API breakage usually apply.

> 
> - You already acknowledged the use-case for assigning
>   different swap devices to different workloads. Your
>   objection is specifically about hierarchical parent-child
>   partitioning. If the interface enforced uniform policy
>   within a subtree, would that be acceptable?

Let's start with that or maybe comeup with concrete examples on how that would
look like.

Beside, give a bit more thought on potential future features e.g. demotion and
reason about how you would incorporate those features.

