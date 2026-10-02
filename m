Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEF30CA5FDD
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 19:23:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD5646B009B; Fri,  2 Oct 2026 15:23:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5E9B6B009E; Fri,  2 Oct 2026 15:23:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B26D46B009F; Fri,  2 Oct 2026 15:23:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 937F56B009B
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 15:23:13 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 599661407C0
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 19:23:12 +0000 (UTC)
X-FDA: 85278659424.05.CD28CB9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id A7446C0002
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 19:23:10 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IxFSYnvj;
	spf=pass (imf10.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790968990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LDKFXAR0QzYZG82qZDFlEgdx5fL1gbJMd6mPxLwtfJ8=;
	b=gXjW4Z+u2WkVuoBrZDFEncD3Mk68Ed7EnEmR6uLRNA2DIlF1Ns1abhpj1l2I5cvHwEcETz
	rVbC4vGcIC78IuiD48kDp4ghC6WH4lZ6axF+VZinJ42ors/D09/e4fFMQsKgDTCfA5LyUE
	kYIA/sRj+2YXHzCYNnYi2GxfFI1kxf0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790968990;
	b=jvyY/fI7i5KbV5n6xj4z98Vzl5o/h3GQMx1XrnovtS7mxIj+3J7oyaBIg39XWbsrDZ0J/C
	2W1wKYn3udoPYJFdFbZGqw4UDK0sjnEdr/IZefXdDF5Xsnze+1cpepcDJCo3R4vlX8ipzF
	GLwFcQPGs1seChCZqsXY1ys0WE2Nz00=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IxFSYnvj;
	spf=pass (imf10.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E6ACB41ADA;
	Fri,  2 Oct 2026 19:23:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0A0A1F000FF;
	Fri,  2 Oct 2026 19:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790968989;
	bh=LDKFXAR0QzYZG82qZDFlEgdx5fL1gbJMd6mPxLwtfJ8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=IxFSYnvjc06qv3d3xnR17CAgIP4Wz9E6F6qevNBi/fKJKUPzJJCa4Cw2Hlqj0A8S6
	 8vxK1piI/0QitQ8hDLk0ns43n+pUfVYziyoOgxZ70ETTr41LumfymTfb31h37kakRC
	 /eDFP7Gnvr6mYrRJXNGUP6t2keD9dgM5DtLiYWQLnGUkVevo1bA0z7fBrk3oQSWRdy
	 kSykIwEdeT43cHBqZ9scoC7+Q4ebajdk5V7LwZTw/9xQ3Shg6Iwm3Me0/Yu3YTo/AO
	 aPeJ/PihcT1HQTmKABKJpgYYbylJrjCE/4lm+PayNLrLheAJ9ynUpIxQms6hsivNU4
	 ThTXurHZBZ2Cw==
Date: Fri, 02 Oct 2026 09:23:09 -1000
Message-ID: <c5675dcba08c91acaddfc2869193cdb3@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Liz Fong-Jones <lizf@honeycomb.io>
Cc: Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jens Axboe <axboe@kernel.dk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Xin Yin <yinxin.x@bytedance.com>,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ian@honeycomb.io
Subject: Re: [PATCH v5 3/3] writeback: switch a replaced cgwb's inodes to its
 successor
In-Reply-To: <20261001-wb-dying-cgwb-flush-v5-3-8361eb8c65c6@honeycomb.io>
References: <20261001-wb-dying-cgwb-flush-v5-0-8361eb8c65c6@honeycomb.io>
 <20261001-wb-dying-cgwb-flush-v5-3-8361eb8c65c6@honeycomb.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A7446C0002
X-Stat-Signature: 47ucbjpyt3dxn4d1nwxeiitoaq4sj7ix
X-Rspam-User: 
X-HE-Tag: 1790968990-884931
X-HE-Meta: U2FsdGVkX18q7fmzpDTiRhmGbCjr8CgZDyfxtJhBGTRWterVbbI2UkGy7+tFt9LWE7eu3hlFWR6CLMvsvrIYOyImj1d/6G3jENzcycHEW6wreLh+8Z7hYhYXJ3dDYXDZjUH9XobftuFlwSLXT5qvZE0i46zFJLFlx3vOC4m6A/5Lgq9u6pkurbrBuxPl/cLzgGpLJIUTf4DeqCKx7OkyiM17Gxfb0JSUqH+y7CU293Pq3YvTs72R10V60P7Hgiizrcj3moGqQN3SBsOqJ93HzDphf5Bw90/fc6TSfNbDfhRVyM18P8Dv+S/qpxvZXGWf+NaHUA25pSf4bOp7uUqKSUD6Ex6J1Od/yQVLnoeTks7BlzwRd/OBClDb4sbneEVDzZUQ0AOkEtaEwPjLcwxu60fraLLbleUGxMvjotrox0nNWS1ZPKEuHCYqgiiir1i2EzK3LOpTERheewkR7n9kIbiQyknAD7jqNEoYNRHGpDKtIMAU26INzqSDSMHrJaFlvAfgM7F+LQOblTaMRpeQ8LPJaxcrJBDw4MRADuVvC085v56CZcWJWgwY3i8eexQlDB/I1mNKNs+0VKL1XBDVFZbY/w5jlZT1QSoImHZwsU6U5WkXx/vJVTFmXKEvOCl9LoWug/ioMRZIWhmpn3sRE4L/+2XY3GPlJI+X/7qRyTO+i7Gmqw5Ad7baiQPoAxwPDwGLZPXcC9NJJo6hBFMx+s92UaPgsY55qSCvFF0SBdsPIQtLmysHcQ9vfvzrYsFJQt1dK37RIYJoqMn6F99l2Auep4SfTUeSmvOUb/uA4NdJleedW4sYtOeoTMeIlkp2kGV0Duigojmqx7ViN36wFwkROpuEwYoetwOWWSCdxR+ThoCMpD0hxDSgOKdtW3aEmuaHN/S8SFfWCcuq2x02IcRTTwHSGxFS9a6T6JMfERUTImULefkpZijJObdIWgP5MJQlDjqOl+rXGeOhMyn
 ubHPHD1k
 rnamoJMfjjzeW4x4rg/SDHl/kBTDV/Mfsr/+uNGmioEWkmyhO7GZpbo17Y13EKA0LNvbE+QZMmWJCDXySwXGx5R7zmrm1pJb8/Z4zg2IkLmGLJxHxKSrIJHuihN3AlxVt+t7omIQ4tt2mvbGfjMoIPo2CZIgbOziLL3rL14q6OAZOIW8LHZDEMnuA0P18Otj3XSuuiEZFpae44v4z5WtErTSKNncRon0hT79XlQXMkPSmYYTrWZtviPYtcrk3DMjtZcVv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello, Liz.

On Thu, Oct 01, 2026 at 11:50:21PM +0000, Liz Fong-Jones wrote:
> it only queues the work, after dropping cgwb_lock. Inodes already being
> switched when the work runs are left to the existing per-inode
> switching, so this is best effort. If the successor is already gone,

That covers inodes being switched away from the old wb but not the ones
being switched to it. inode_switch_wbs() pins its target while the wb is
still live and the context lands later through the wb's switch_work, with
nothing ordering that against replaced_work. Those inodes end up on the
replaced wb after its scan, and for a removed memcg css_is_dying() keeps
them there until clean.

Every context lands through inode_switch_wbs_work_fn(), so can you kick
replaced_work from there when new_wb is dying and no longer owns its slot?
A dying wb that still owns its slot must not be kicked, or the work would
look up itself.

> +	/*
> +	 * The replaced wb is out of foreign flushes' reach but may still have
> +	 * inodes attached, dirty or not.  Switch them over to @wb.  We may be
> +	 * running with interrupts disabled, so use a work item.  A replaced wb
> +	 * never returns to the tree, so its work can't already be pending.
> +	 */
> +	if (replaced_wb &&
> +	    !queue_work(system_dfl_wq, &replaced_wb->replaced_work))
> +		wb_put(replaced_wb);

With the re-kick, already pending becomes a normal case. Maybe make this a
helper which trygets, queues and puts on failure, shared by both call
sites, and drop the last sentence.

Thanks.

--
tejun

