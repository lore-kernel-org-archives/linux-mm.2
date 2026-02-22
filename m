Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29915C624A1
	for <linux-mm@archiver.kernel.org>; Sun, 22 Feb 2026 01:41:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B2B96B0088; Sat, 21 Feb 2026 20:41:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 360366B0089; Sat, 21 Feb 2026 20:41:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26C266B008A; Sat, 21 Feb 2026 20:41:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1044A6B0088
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 20:41:57 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AD296140598
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 01:41:56 +0000 (UTC)
X-FDA: 84470391432.20.266CCC4
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8BAA51A000B
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 01:41:53 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf19.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771724515;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KqFhoKnkHEcPrpwAw5aTFsbCr5J2GG2+DdpE7QS3+qA=;
	b=Qu4iNNBHkl8+NRPOnfGYZL+ZtenktK3anCqYMqqmF1BZQaJYZ6EoV/U1s9Z7bZ7/VZAigB
	ChrLKjWvpB+TrVvIl393B1MqxDgbPRLVu+f4qIiMNczDO+khk28k09beXtja3KqoPCa0Tp
	YZ5tILEA7Cspba/4k8o29L9y5q8rn+A=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf19.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771724515; a=rsa-sha256;
	cv=none;
	b=gfMez+/VClRV+mkSVZ6v+9gl4wfbZ+rmzd/r6bN6fSR5rAdAJ48dBjTp+RG2uChik5P5OL
	ufvwKBVZMvgOa3Y7k3ivAMNaCD3oPuaAAXkFiOLp34FZDAIuuu0uWH5rnuZOVdBVWfDo7t
	jCJZTqx9ntFWheP45XxgxszcfsKc/oE=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 22 Feb 2026 10:41:50 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Sun, 22 Feb 2026 10:41:50 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Chris Mason <clm@meta.com>
Cc: akpm@linux-foundation.org, stable@kernel.org, chrisl@kernel.org,
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
	bhe@redhat.com, baohua@kernel.org, linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mm/swapfile: fix list iteration when next node is
 removed during discard
Message-ID: <aZpe3kD/xmz87zYH@yjaykim-PowerEdge-T330>
References: <20251127100303.783198-2-youngjun.park@lge.com>
 <20260220151338.3234934-1-clm@meta.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260220151338.3234934-1-clm@meta.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8BAA51A000B
X-Stat-Signature: ooo5dnefixqxbc3izy94b75a4hexmx99
X-Rspam-User: 
X-HE-Tag: 1771724513-944241
X-HE-Meta: U2FsdGVkX193jK3A8t7JjX36aNhya46YsmbzPmVMnIQ0GoubiejW6c9hvDRRpzFgGtImkuIkCkIvPOGjo6g9pqFcMdIhSSxU0Yeada60lHrvE0CLC6GNhHsW2Sg7m4kdUfefcxeCSjorIrhyQ3I0yleJOOdB0xG/TNSu6QGEDX9XHXyE6oSSqTgxM9OoMFHQ5jOZkXf+qOHWkHfmZEPt8HTY88Qt45IsumRJVMi0mgiJDgnAHpA3RFVVR2uSceXBabKIo/qai8svWz/DwNo/erixXQpzBeFEhKVvt221xEmvbQPZ8KYOlRZzHeW/cHH7FqCnBFvHjXDbKJKsiTiaI9JWso3rMXAP/K7eGmhIxY29OYmlNec1qW4p0EmRAGaxlw9l7JlP7WrjcwtGMFLwmyY5nnvxLtSA4gmfJzdoHDTt8TbPu73QdKdhrlD3Pbnpa7sxKl0diJIjnicS8qBV4o0IKMvZUDbwxMLbQewZQKqJ4ljg0TLWNibIDkBQrk/gX+vIWKm1G7zL3T6fItUUDWqG0+OV5+7ug+z6Bgsi1ksF+wSCUn0xksJHjWK5KN9VcAtr58JUd3pRsmMTvfWpGjKohWulUhqKyI8cR759LWtZbp3b32LswhC/VYA28V7RtE1S3XSXl9xaXBIVJDSRTPLb1wDPiISHp0vVq+F08HvZRDakiFapDfwW/AlKii64HOHD8p611Ytjb0bYyB8HW+M0WfH9n1zWicmbtcdUYyn2dD2rZGHaUBilWHb2qSEEeLq39/BpMGhK9HRT3+yHeDSlqXRXBa/aoZlIYqQHGiMwNGnXnS61LH5NDHi1yHE8gbw2/UUTJZaEInHgQaHfPrZNAeW3ini7F3Py6mKnnra7TWSF/q50Q8zGC+a2+lxczye25aLlqSGmB6p0clmfVbubGdyYQ08mCgtNLxkAaxJnx+L93BXXUyxea5rK/9x3lSigkDTPfT0jvOBIlAu
 2lrw98sQ
 E4eRyb5mOVdrxCHtp0hvBpoN4lWHCP5F5dJZeigYdQvND1KNx64bTVwcb/5oqjZfX0vsKtsOmJZOIGA3KPOHEgT2IbnLMHHnbmatD6xbXX6RGBRUBXhKbFXo+7wIYxRmwtXAcJoZtrfW3jtdMWKGa/fF7+X8jFzGOJrpMOJuVxOEWbOrKpwjKqxXfW2DawasfRe30gEd/bCtdkpO1HWP2cbgjRzToXDy95mE6aio8/fk+BK1pm6WdPm0craXC2V1gfMAFS1PKYJkvcmgEZZiDQwVl7okz1TInmcYn
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 20, 2026 at 07:13:33AM -0800, Chris Mason wrote:
> On Thu, 27 Nov 2025 19:03:02 +0900 Youngjun Park <youngjun.park@lge.com> wrote:
> 
> > When the next node is removed from the plist (e.g. by swapoff),
> > plist_del() makes the node point to itself, causing the iteration to
> > loop on the same entry indefinitely.
> > 
> > Add a plist_node_empty() check to detect this case and restart
> > iteration, allowing swap_sync_discard() to continue processing
> > remaining swap devices that still have pending discard entries.
> > 
> > Additionally, switch from swap_avail_lock/swap_avail_head to
> > swap_lock/swap_active_head so that iteration is only affected by
> > swapoff operations rather than frequent availability changes,
> > reducing exceptional condition checks and lock contention.
> > 
> > Fixes: 686ea517f471 ("mm, swap: do not perform synchronous discard during allocation")
> > Suggested-by: Kairui Song <kasong@tencent.com>
> > Acked-by: Kairui Song <kasong@tencent.com>
> > Signed-off-by: Youngjun Park <youngjun.park@lge.com>
> >
> 
> Hi everyone,
> 
> This fix landed upstream in v6.19-rc1:
> 
> commit f9e82f99b3771eef396dbf97e0f3c76e20af60dd
> Author: Youngjun Park <youngjun.park@lge.com>
> Date:   Thu Nov 27 19:03:02 2025 +0900
> Subject: mm/swapfile: fix list iteration when next node is removed during discard
> 
> Looks like the commit being fixed is actually:
> 
> commit 9fb749cd15078c7bdc46e5d45c37493f83323e33
> Author: Kairui Song <kasong@tencent.com>
> Date:   Fri Oct 24 02:34:11 2025 +0800
> Subject: mm, swap: do not perform synchronous discard during allocation
> 
> v6.18.y stable has Kairui Song's commit, but this fix hasn't made it to stable.
> Johannes noticed the Fixes: tag doesn't match, which probably explains
> the gap, but I think we should pull this fix (f9e82f99b) in.

+Cc: stable@vger.kernel.org
Thanks for catching this and pushing for the stable backport.

Acked-by: Youngjun Park youngjun.park@lge.com

