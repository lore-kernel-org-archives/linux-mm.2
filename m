Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BF97606A330
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 21:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FWqv1Tsc
Received: by kanga.kvack.org (Postfix)
	id 8044A6B05B3; Sun, 15 Nov 2026 16:43:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DC306B05B4; Sun, 15 Nov 2026 16:43:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 719B86B05B5; Sun, 15 Nov 2026 16:43:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4F7B26B05B3
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 16:43:36 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A770A40845
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 21:43:34 +0000 (UTC)
X-FDA: 85438680348.02.5151C9E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id EA5F5140006
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 21:43:32 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FWqv1Tsc;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794779013;
	b=7NodRwU1ALSdW9RAF3HdzyXp2fndgrOpktFrjRdv6WbasGYjAuYfAR6ohaKBY7Svxt92tL
	4Ak7cTiSe5gg2Nz8P5833P9Z6yrVz/Gv4KwY8kSkgLa61pQmIHo4JQwE0ihJeRRXuOQMBg
	/1wh/l8Hb7Y8hzIPsyKd5Im7NHKQFAA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FWqv1Tsc;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794779013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=At5BFZ8I2aCU5FwPovXmPCKJBj+XIcaUYG7iZYPdJ7Q=;
	b=CYGwrqiM2olngQCT2npj8wRxEXl5C8icVPORrboMjNKoH0GoIbB7xByNPGh0rSr7btMdMo
	pCd/vF0iuLAaA8x1jLD8zWhMdwsoPn0ekgX7D/6pbXOaump3uKZ2o2km/CoGcpvF5Ug0kN
	6qsiW/z93D7vXSoZhRMGhm+xdy+8+EI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 322D640684;
	Sun, 15 Nov 2026 21:43:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF26B1F000C4;
	Sun, 15 Nov 2026 21:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794779012;
	bh=At5BFZ8I2aCU5FwPovXmPCKJBj+XIcaUYG7iZYPdJ7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FWqv1TsceirUVxDuqWjxvorqJmkWt/oZ3x2Pn6vRqiGsaLOOg3oBhAgUvBTYUrjgx
	 7Ss86Rm+IEoL6mXUe460FUQlDv2pPK3sB0G109c0IgNM4JgLbjg9zmzr+3BObAHTIP
	 tqExd+jifuy/doLTkdzaHDWvSMEEHTJuv0pGn+aRXiFdOQ6iPnuOBxCU7Tgo6CGdIc
	 NmjM/TsXC05ZZ8c5Y22hBbbh/5vINTZ4zUU/IB2iyQAQlA/nzqItD2hSbr0c3OslOA
	 j01KcyEsBcQyc0/qtxxFYok0dzUwTdgQxm+5ajDqyP4DI8lS02wRSxtOgONDA7WdGX
	 lr4iNSunAciDg==
From: SJ Park <sj@kernel.org>
To: sashiko-bot@kernel.org
Cc: SJ Park <sj@kernel.org>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 23/27] mm/damon/sysfs: implement submit command for report producer
Date: Sun, 15 Nov 2026 13:43:23 -0800
Message-ID: <20261115214325.104133-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <sashiko-outbox-215852@kernel.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: imsine4gdqfstyogd4w7qqs1nsu6whcn
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EA5F5140006
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794779012-110605
X-HE-Meta: U2FsdGVkX1+B4LCT63TkxuwPYyPb6+L7fOpeSMUdWrWKCG/jJwFeEWoJugIn34CGmB96IfCzeE3QNhpAjYelkC8riv1IO1Rnig9YudrNTkuFzRhmvZEVgUGa1KBduMFTLOHDueseSCYc0zAddEjb1V+3L4AZAaw8k99MRD8FhoyXBc66cwdUH4H+pwcfM7+tIUQcnkL4R/r9zK7JImSNXsyDqtVAASKDgCRlchR6RXzKjIviEN4Mux31RGRM0zWwCNjA5EP4DbKCGJ4uhOHQfQvzakXvD4/RvS9jFP/9B5+vI63GUNb8MmMbrn2ywJ4HxqO3E5V1GqiryROou3QoS3kjlOAgzE071Oz3q1xLTWc/wWK3n9r4zLpuqBzumdlLK1CWCdZdWh/8FrCQkQydr23JRawkhdEKWeEfX689wiM13gAGNRkr4d0rz7j2EQ/F/4cd056vyB9PQkysmSdVuqrqVg9kQjZLaW9+NcuhYFl8jBWNp2tXimOBB51F9bGdnYo/8mHR2GSJjL0fADdladzJxD1iWTId/SF6W7CIG4f48V5oanXflLKIVL7S+FaHdekR3jgFn3sxEvYAAK8ksL18sUyE0pvYuI3FscYt0tVksCrHTcZphpEIKEKsR7uzO53IEq3Sg5urEXE1XKferXBEhe0XtNVrQSnoRjDfZsXYny48z81G7x2bVhmx8TP8yFWbUWyH+FR7APTDOqc5jWd7zzlXJZ2mIh91weFdBRhvRI1dXrniFwwqCvVWtPDQso38XlI85eiH57j2CUJcdIJsfqU013TcTn4ccG3JW92arPoQJ65oSAfiyUWfsynYnmDPoXcBoec5cIWShYzfOne8leNPpPlI8tc3u0LG797unKPEWLg5nwF3eGVR7oYol1DV8DdpYADs2pzXKWw1erGAVK8/Ha77rvkw0VaN0l8tdukRsjZy38k5Kp2dWvY9E/36QjQASE+snr41TjJ
 3PRV+ZuV
 MTgAF4C173HU0FWXpyLUAHIwqVIrxY6HNq2v/0RF3KUa8Z7UAl8QR5ezzU9L2SQMwKYeiNlFJ1nIDZesX8n9NE5j1PxotO0AOqoSKayxqytnSbS6qAOZwu8uP6CIM4qVO6xdodWEN4wy2xdE/7eyCtnxeZkSG++Ox9E7WJNnjZyjU0x1MVPxSfJW8snFolaUTbx04pbSTznqAyJVGV4tDe1bY07P89otVGGtcA/vOk4Ull5U0ajF626ZcmGMX4f/SSgD7FHRy8Kb6/txOrNzssgqwEZyLeaWQNp0bJibhz8GvJsgTi5TJgGfM5aGWKd2RWyng2d7x3AIQ86c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, 15 Nov 2026 20:43:17 +0000 sashiko-bot@kernel.org wrote:

> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [High] mm/damon: OOB write in damon_submit_report() and read in
>   damon_report_exist()
> --
> 
> commit 2f4ed587e778c0d51407454ba3a19b21c1bc10c0
> Author: SJ Park <sj@kernel.org>
> 
> mm/damon/sysfs: implement submit command for report producer
> 
> This commit adds a "submit" command to producer_state_store() so userspace
> can submit manual reports via damon_submit_report().
> 
> > diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
> > index 5f9bb1955dfd5..0049aac6ab974 100644
> > --- a/mm/damon/sysfs.c
> > +++ b/mm/damon/sysfs.c
> > @@ -3107,13 +3107,26 @@ static ssize_t producer_state_store(struct kobject *kobj,
> >  {
> >  	struct damon_sysfs_producer *producer = container_of(kobj,
> >  			struct damon_sysfs_producer, kobj);
> > +	struct damon_report report;
> > +	int err;
> >  
> > -	if (sysfs_streq(buf, "on"))
> > +	if (sysfs_streq(buf, "on")) {
> >  		producer->enabled = true;
> > -	else if (sysfs_streq(buf, "off"))
> > +	} else if (sysfs_streq(buf, "off")) {
> >  		producer->enabled = false;
> > -	else
> > +	} else if (sysfs_streq(buf, "submit")) {
> > +		if (!producer->enabled)
> > +			return -EINVAL;
> > +		if (producer->report_type != DAMON_REPORT_TYPE_USER_REPORT)
> > +			return -EINVAL;
> > +		report.type = DAMON_REPORT_TYPE_USER_REPORT;
> > +		report.addr_range = producer->addr_range;
> > +		err = damon_submit_report(&report);
> 
> [Severity: High]
> Can repeated "submit" writes overflow damon_report_queue.reports[] in
> damon_submit_report() and read out of bounds in damon_report_exist()?
> 
> mm/damon/core.c:damon_submit_report() {
> 	...
> 	tail = queue->tail;
> 	if (tail == queue->size)
> 		tail = 0;
> 	queue->reports[tail] = *report;
> 	queue->tail++;
> 	...
> }
> 
> When queue->tail reaches queue->size (1000), damon_submit_report() wraps
> only the local variable tail to 0 and still increments queue->tail to
> 1001 instead of setting queue->tail = tail + 1.  On the next submission,
> tail is 1001, the equality check against queue->size is false, and
> queue->reports[tail] writes past the end of the 1000-element heap array.
> 
> In addition, damon_report_exist() starts its backward scan at
> idx = queue->tail (the next free slot) and dereferences
> queue->reports[idx] before decrementing idx:
> 
> mm/damon/core.c:damon_report_exist() {
> 	...
> 	idx = queue->tail;
> 	for (nr_read = 0; nr_read < queue->nr_reports; nr_read++) {
> 		report = &queue->reports[idx];
> 		if (idx)
> 			idx--;
> 		else
> 			idx = queue->size - 1;
> 	...
> }
> 
> Before the ring wraps, the first iteration reads uninitialized memory at
> queue->reports[queue->tail] while the loop stops before reaching
> queue->reports[0], missing a single submitted report entirely; once
> 1000 reports have been submitted (queue->tail == queue->size), the first
> iteration reads out of bounds at queue->reports[1000].

Yes, I will fix those in the earlier patches.

> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261115202849.99134-1-sj@kernel.org?part=23
> 


Thanks,
SJ

