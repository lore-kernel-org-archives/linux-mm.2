Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFF83F531DC
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 00:58:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBA836B0088; Mon, 13 Apr 2026 20:58:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E92176B008A; Mon, 13 Apr 2026 20:58:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA8716B0092; Mon, 13 Apr 2026 20:58:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CA7DE6B0088
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 20:58:34 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 77A651A0213
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 00:58:34 +0000 (UTC)
X-FDA: 84655350948.02.BC1DB3C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id BB068C000C
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 00:58:32 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OcsJXF1P;
	spf=pass (imf22.hostedemail.com: domain of dgc@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dgc@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776128312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r3LAEV04Ii7sBhBVEYN/4cey+p6saxFGFs/cAnZ92yk=;
	b=P8/6z4sD11KkGDu46PTLcIkT8pSDZtmSPQ3bKYzqKhCrbqOLFQWtPRG2be4XyjpwcbPHHa
	r7wGa94HyHoDHzgU8wHSZ7xzWFtEXX3dfM/7/BYsa4QjSgdfx1FYTupZ3+cTquK48dZqjA
	hWZ6u6PsLJAy910r5btiIezfmIdLZtQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776128312; a=rsa-sha256;
	cv=none;
	b=SwyPZM1X3sdNCJht2Jr5TRyhfamkkHfBIj0uT0ZQ+IybzbsRZSf8CX9F8khmGlyONmuWTb
	uRJSYtsB+2XG/FN5TO0NHBrOQRAjSy7unArKv43ZwBn8/DjJ3EzYvrHxnsWtNvnWrrtkSn
	zJBgcThGGyvLNKMdDiiMJcNGoW3CSBw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OcsJXF1P;
	spf=pass (imf22.hostedemail.com: domain of dgc@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dgc@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AD32940667;
	Tue, 14 Apr 2026 00:58:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0E1FC2BCAF;
	Tue, 14 Apr 2026 00:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776128311;
	bh=3CPipGJaHA3s88GYGUsO7x7ehen2R8UngXGLoTHJjjw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OcsJXF1PmRjCZDAfuYGZoXbIniLv84Y/ELoCE7qu3TgOHRTrVtUykun/PwQZccOnZ
	 6PAQXF1uHTMuw8JRnCIRQUcHacvwwIDGYCflED7jspQ4Dk1hSHD9EIcwKt75U25MNm
	 GXlvVkaNlmgoWYfPVlmEDVmQScReiJW+SBCFXwC9TUJUDDZ1cNQ85FCC6BNOX1ClBS
	 7uF4GFWmCBmTZwJWoobFmybkYl5JZ0bqL7SL29031q8R1x5jvJQ/8BR+0CLMx/W7Bh
	 FYTxmGNZr/VD7oP2SiGvam5GfwHFsK17AbwxbrBGeDQtDs/cKX9vhXFAmnc3HFDkkt
	 pqwDN77HE8ImQ==
Date: Tue, 14 Apr 2026 10:58:16 +1000
From: Dave Chinner <dgc@kernel.org>
To: Gao Xiang <hsiangkao@linux.alibaba.com>
Cc: Christoph Hellwig <hch@lst.de>, Tal Zussman <tz2294@columbia.edu>,
	Jens Axboe <axboe@kernel.dk>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>, Bart Van Assche <bvanassche@acm.org>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, Sandeep Dhavale <dhavale@google.com>
Subject: Re: [PATCH 8/8] RFC: use a TASK_FIFO kthread for read completion
 support
Message-ID: <ad2RKNo2FGhpzJQp@dread>
References: <20260409160243.1008358-1-hch@lst.de>
 <20260409160243.1008358-9-hch@lst.de>
 <adl1iqhldFvJwSw-@dread>
 <7f0d072b-97a7-405f-bff5-d3819de2e3dd@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7f0d072b-97a7-405f-bff5-d3819de2e3dd@linux.alibaba.com>
X-Rspamd-Queue-Id: BB068C000C
X-Stat-Signature: mxy3gu7gqadhf786tyo9sownxbqsfys9
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1776128312-926859
X-HE-Meta: U2FsdGVkX1+9IH6EwX+LmNemfaRjuXM99cKzVmx1v2XD2kaFwNBGU7JqM+1IYdicZOrm1s/0M+0y9kr5UB876/k1Wsvqe31nYz4aXsMet0J0gz2wcjdove8TJKFAtqBtYWJ+UKdaQ319+Od7kXJOq6x2MfGCu4dJI/pLIOI1Gulr+3YT6OVkpKwgMOySJzlJJyZWUbRVbcW4+lED7oRsnnnHhCeOcw4YJzmK0XTroxUeAuxwUx+hzjdMU25/UHKXZEy6fXcIUpwudSg1YtyZOYWkN/1RYQw+X3gZ57AZfXw5y8OsFfWOuvYBaEz/7GNXrVxcMgYTT5cBPGGIE9QxgKu/FEPzurNWrF8D1TQnXLrSMEu9+9NzxucNG/y7w2/e3pnr5FjM8eHs09pQDZ2e/HGgOxtIdMBJMBy0knXLGxllv0gb9vSULpfrz2cp/ED+CnJDl+VD/wUEqgaVW7OKHcTu0tiDM3Dr+TFc+7cpAwkJOlEF0/xluZ+HubhrcYqExQRujKZCtQyycJCOtgA2VQq0iU2aHdjRX+IsKx3VG170vGinvt6dLECYOJrTlTqRhXL+S5YA6+TqWFR9NBYVi0M/zC+z6Ysx/Yi2/ulbj4f3VD4B8RIHPg3J1iwZkSjL7su4H+UTdVWXhGPZkDHNUn+KYxNaUW6ySwIIKNT53f/K6S/fKULE4zm73dQIQqzYzl3lBDhufDuV264hGA0/LNtNdDu6M1qZ+ypLl1mNkoAlJrZVEFu5IcVyCyO8gcvLlNxufp/+xdDEGOTJo7p/VED7WXYZKEmr3hqhPrPZMPI9naHtx5j+P0N0AOasNxk171UKmTnMLTZolHIDqm0EIosnUVnysjUgVjne/H10W7I+BCa0F+aJPjd+5oigqCZFsD+yad3yh7dJr4dNsowG3FxZuBHaKk8EhpegsKoBKr4pOuscCsXWRwikn51ifKfE2YFbeTEgJPtAlSn3JUw
 0ysjk+CM
 0EIQg4DfMdKrOPs3JC9h5RbG1cLpxVUusXzNVnku3p5CHnWrF8QRlYm4f+6f3EHDfvr3lKHQTFFVgMRlbePFu+/eyFQkRfy7q5xPJuILQPuUom3ChOw5O8cwyjS+MA+E8kNSKtvBUjPI9e9jg9A+tV/EnkGg0YG7OoRcTK1nd9Av+l9gNOB3xeB2K3L2JbyV/7LL/jRHEZX5tjz6JEp18I4Dh5Aq9Szq9qxT20XRSTkldaI4X1DCBrZXFqARGDup35DVMourS4Ifqk/8eYZmKBAi6JdFJ+vheZmdLdtR8MahvzLaguHedjxoeTvfhzF48rYicybBVnZBhpoqBLeU6LFZsdA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Apr 11, 2026 at 07:44:43AM +0800, Gao Xiang wrote:
> 
> 
> On 2026/4/11 06:11, Dave Chinner wrote:
> > On Thu, Apr 09, 2026 at 06:02:21PM +0200, Christoph Hellwig wrote:
> > > Commit 3fffb589b9a6 ("erofs: add per-cpu threads for decompression as an
> > > option") explains why workqueue aren't great for low-latency completion
> > > handling.  Switch to a per-cpu kthread to handle it instead.  This code
> > > is based on the erofs code in the above commit, but further simplified
> > > by directly using a kthread instead of a kthread_work.
> > > 
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > 
> > Can we please not go back to the (bad) old days of individual
> > subsystems needing their own set of per-cpu kernel tasks just
> > sitting around idle most of of the time?  The whole point of the
> > workqueue infrastructure was to get rid of this widely repeated
> > anti-pattern.
> > 
> > If there's a latency problem with workqueue scheduling, then we
> > should be fixing that problem rather than working around it in every
> > subsystem that thinkgs it has a workqueue scheduling latency
> > issue...
> 
> It has been "fixed" but never actually get fixed:
> https://lore.kernel.org/r/CAB=BE-QaNBn1cVK6c7LM2cLpH_Ck_9SYw-YDYEnNrtwfoyu81Q@mail.gmail.com
> 
> and workqueues don't have any plan to introduce RT threads;

They don't need to (or should) introduce RT threads. Per-cpu kernel
threads already get priority over normal user tasks on scheduling
decisions.  However, they do not pre-empt running kernel tasks of
the same priority.

In general, kernel threads should not use RT scheduling at all - if
the kernel uses RT prioprity tasks then that can interfere with user
scheduled RT tasks. This is especially true in this case where a
non-RT tasks issue the IO, and the IO completion is then scheduled
with RT priority. IOWs, any unprivileged user can now impact the
processing time available to, and the response latency of, other
RT scheduled tasks the system is running.

Tejun asked Sandeep if setting the workqueue thread priority to
-19 through sysfs (i.e. making them higher priority than normal
kernel threads) had the same effect on latency as using a dedicated
per-cpu RT task thread. THere was no followup.

In theory, this should provide the same benefit, because what RT
scheduling is doing is pre-empting any user and kernel task that was
running when the interrupt was delivered to execute the completion
task immediately.

Setting the workqueue to use kernel threads of a higher scheduler
prioirty should do the same thing, without the need to use dedicated
per-cpu RT threads.

> If Sandeep has more time, I hope he could have more time to
> test since I don't work on Android anymore: In principle,
> I still think RT thread is needed somewhere for such usage
> since lowest latencies is needed.

All that is needed is for the kworker thread to be scheduled to run
immeidately after the interrupt that scheduled the work exits. This
does not require dedicated per-cpu kernel tasks or RT scheduling....

> Compared to the scheduling latency issues, interested users
> don't care "individual subsystems needing their own set of
> per-cpu kernel tasks just sitting around idle most of of
> the time". If end users care it more, they can just turn
> it off by Kconfig.

Distros enable all these subsystems all the time, so saying
"turn it off via kconfig" is not a viable mitigation
strategy. Proliferation of dedicated per-CPU worker task pools is a
known problem, and we really don't want to regress back to those
days when a typical system had thousands of dedicated per-cpu work
queues that largely did nothing most of the time.

-Dave.

-- 
Dave Chinner
dgc@kernel.org

