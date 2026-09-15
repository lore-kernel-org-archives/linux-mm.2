Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 299ADC88E53
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 06:06:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16EF76B008C; Tue, 15 Sep 2026 02:06:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 121366B0092; Tue, 15 Sep 2026 02:06:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 035676B0093; Tue, 15 Sep 2026 02:06:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DC5FA6B008C
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 02:06:11 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5FE951C21C8
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 06:06:11 +0000 (UTC)
X-FDA: 85214961342.03.DE62AA5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 995C514000A
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 06:06:09 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="Q5OCUJ/k";
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789452369;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+xxEqhiF3vxSUzq5Nt+Fw5y6mQaekGAywZHRtZkajCg=;
	b=1ktuMRzRmdffvvJPRbMbzNPNHctwxI4CHg7YRNaI5WObJCwH4DBztxpEvBeuIHDEIY+oLi
	NMUrBuxRfDypznCtamU115wLfXsf31ReSdbeP6rf0ALDjMDYCjB7iV0kL0H8QA43eRVkjM
	acTSzKefL6lCr6RtTnaw0+p+OmIjCaU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789452369;
	b=fP3upawkT1RWB6EBVObczhqJwwRdoHk3uWXD7ugImN9sWE170N2YqzsVS91RNNB9I4ljkK
	WQk2mvM1e61pVIMx5xGW8C2ouI3SRLHxraw8Lkl/OYrBS9I1EK7q8HYR7hewvL+fIqU2p/
	HHgcp4y8zY6CeVyNCLLFsugAtn1l6Fg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="Q5OCUJ/k";
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 88A3F600D1;
	Tue, 15 Sep 2026 06:06:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C759F1F000FF;
	Tue, 15 Sep 2026 06:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789452368;
	bh=+xxEqhiF3vxSUzq5Nt+Fw5y6mQaekGAywZHRtZkajCg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Q5OCUJ/kGbEIlPHjL+9OEi6LGcdhCpjjZZQTNUXyD88CAOMW3kdJ+01jkWAGYgzlb
	 SZ1Sbx3y1iaUM46yvjh4tGuLVqjq2Mc8kSFFdufzUIMfJ3Lf0tFRecpdV6T6TIJbzQ
	 SN9YZOUDRIg5rPIBwxlsW+tNZ5yNfm4uuUKjmNXo=
Date: Mon, 14 Sep 2026 23:06:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Julian Sun <sunjunchao@bytedance.com>
Cc: linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 axboe@kernel.dk, hannes@cmpxchg.org, mhocko@kernel.org,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 willy@infradead.org, jack@suse.cz, rostedt@goodmis.org, tj@kernel.org,
 linux-mm@kvack.org
Subject: Re: [PATCH v4 0/3] memcg,writeback: flush foreign bdev mappings
 separately
Message-Id: <20260914230607.9e4d74933bb589eeef435e8d@linux-foundation.org>
In-Reply-To: <eba0295b-268a-4573-aeeb-de79b9ca6063@bytedance.com>
References: <20260914103119.1708452-1-sunjunchao@bytedance.com>
	<20260914205947.5aab9d7261ef0f26ec8f3213@linux-foundation.org>
	<eba0295b-268a-4573-aeeb-de79b9ca6063@bytedance.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 995C514000A
X-Stat-Signature: z8oa8rwmdbrk11kgos6gn1jn871cxbq4
X-Rspam-User: 
X-HE-Tag: 1789452369-860968
X-HE-Meta: U2FsdGVkX1911/bnccOXs9VIO/1bRe4My+hsTPFkhiO2SaeXjQfW1C74CSHYjk4hOM0FKhu3r19TzPLkj0b08QWiZd+XEsz+XP58hmyRdm+f2bfkYyj0Mrz1E+gmAn/eJEzfHaFl6UGLBYwAi8CPx/aZlPXbseOQVR5PoMTWg/LkBWADZCG9EsBulPVVzxbovpsyFdwYlmi/d9kgyL9svvVvklIIMgiIqkG4MaacUpK4wNdamgtYYMLti45Rb2uyFFiwaPhe2eFQZsioV3yRkbfp44jhxquq8F4mjQWHkCLqhqFT3hQCefRBUjXdV91kk+2Bhw0JiTeS4GB7fmCNPZwgexpvH9AwvEn01fB9RoQb+NcpytomxGTNZFibTkCHMzw1CRTSevNrORrtPpIk87/BK+4UHia6kFogpx62cJiCGyr1QZZojYMPBla6Zq4e22T9FupVPUIGNP+IMbjtdPmmAfzaiGnGxMBxCUDLpUVAVXARSmkgkri5Hl23xEO6F7JuRlH3u/pjLlnivsJH+0/D2kUr73ZXc1boqKHsbg9CaYT/qJA9C/s5Bv3qkKexf9bskuhcErSpUSbMDc605TH2nxaWEQ+avaOIpi8DfJHyd3CTeSGKwCDEDrXcEof+GwskBCBDmk3X6kwx5C/yCCaQk3LBYtq5DkiyOD6GhV8LR0cV3ihMqbCJ1Rtm5BdF1h/fMG6z+npbHjWOoUGP0YBbKpFKOENWt2+78hCAecMjfivYagg59viZXy0R+uwj7GR6iQnl9GY6O7S5xzUIj291CiiF66OXZb3xyfdUGv+QuM2CL2dROq9W5xvxCY5nyGnkgdLe6AI/k8rMVS8EayM+YSItu4jAjVzmW5cdNlZms1a8p9nW2fjE4DRibaJsOi6PWN9pqxjr/oGjG1byDFV55m/WEQlwfr5QUw6DnZp4OIaerpgzmGpJMAp1k8AGVQbwfu5QF7OL/gTC0ii
 mwhQvxpO
 fvZUo5DHr8G3h74tFJFBUQwzeXHKr8uMZItM7YYh73uV32qt1nig+v/Fv5g4x05eq/a4XsmPddNboTi45nh76L5QKvqouTvZdx8xFQ/XgXrXIiORI0/ZULDXEWaANr+8tgz6eScd6wm9TCHcmLPHIadkavPqB8RxtH2IIPaPPvLzsCCGXa0VkKDtl6Xg8qnrnGkwci2T07TPs4f+2DD9NtueiUn4hCWNUUS1C8AoLYrk8N9kO937ZwsKK9EbIRfrcpKuZNAbHxSO9gkFLqgUds/uvnw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 15 Sep 2026 13:35:18 +0800 Julian Sun <sunjunchao@bytedance.com> wrote:

> > 
> > What is the overall runtime effect of this?  IOW, can we see some
> > before-and-after numbers?
> 
> I tested this series using a QEMU/KVM VM with 4 vCPUs, 8 GiB RAM,
> cgroup v2 and ext4. Virtual NVMe write bandwidth was capped at
> 200 MiB/s.
> 
> A fio job repeatedly overwrote a preinitialized 256 MiB file using
> 64 KiB buffered writes, at 64 MiB/s, for 9 GiB of logical writes.
> Four memcgs, each with memory.high=32 MiB and io.max=2 MiB/s, generated
> metadata and buffered writes to trigger dirty throttling and foreign
> flushes. Concurrently, foreground fio performed 16 GiB of sequential
> direct writes using 1 MiB requests and queue depth 32. Normal periodic
> writeback remained enabled.
> 
> Three comparison pairs, with alternating execution order, produced:
> 
> Run  Kernel   File I/O (GiB)  Time (s)  BW (MiB/s)  p99 (ms)
> 1    base              7.19    114.74      142.79      1434
> 1    patched           1.57     88.62      184.87       480
>       change         -78.22%   -22.76%     +29.47%   -66.52%
> 
> 2    base              5.13    103.59      158.16      1434
> 2    patched           1.74     88.65      184.81       497
>       change         -66.06%   -14.42%     +16.85%   -65.35%
> 
> 3    base              6.14    109.27      149.94      1434
> 3    patched           1.73     88.68      184.75       480
>       change         -71.77%   -18.85%     +23.22%   -66.52%
> 
> File I/O is completed block I/O matching the overwritten file's extents,
> including final sync, not requested writeback budgets. The other metrics
> are for the foreground workload.
> 
> Across these runs, mean file write I/O decreased by 72.7%, foreground
> bandwidth increased by 23.0%, and completion time decreased by 18.8%.

Thanks.  This is super-important info so please condense, summarize and
emphasize this result in the [0/N].

How real-world is this test case?  I assume people won't see gains like
this in anything they normally do?  I assume this is long-standing
behavior, so if misbehavior like this was regularly being observed then
we'd have fixed it by now.

> > 
> > I'd consider this a memcg patch, and not only due to the line counts.
> > 
> > Please cc linux-mm on memcg patchsets.
> Sure, will do.

Great.  Please update that [0/N] as indicated - help readers understand
the expected real-world impacts.  Then send us a v5 and I'll get to
work helping to deliver this to our users.


