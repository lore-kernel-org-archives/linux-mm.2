Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7E95C88E75
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 00:12:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5AE396B0092; Tue, 15 Sep 2026 20:12:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55F526B0093; Tue, 15 Sep 2026 20:12:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47C686B0095; Tue, 15 Sep 2026 20:12:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1F3986B0092
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 20:12:50 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6927840557
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 00:12:49 +0000 (UTC)
X-FDA: 85217699658.07.61E1E24
Received: from mail3-165.sinamail.sina.com.cn (mail3-165.sinamail.sina.com.cn [202.108.3.165])
	by imf14.hostedemail.com (Postfix) with ESMTP id 556ED100002
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 00:12:45 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=UW1DsWW6;
	spf=pass (imf14.hostedemail.com: domain of hdanton@sina.com designates 202.108.3.165 as permitted sender) smtp.mailfrom=hdanton@sina.com;
	dmarc=pass (policy=none) header.from=sina.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789517567;
	b=qQKFubpJZhZVQ5gopaNZRzBSia+65ovh3VPwiV7MDwrllEqAMvz1iAJhbs3dKfeEdzewug
	4EK3Cw1Jkji+MuxZ466/S5BMnSUUJVqc+T228PnOQjuvdAP7hoN04cxoZBEnzCZpiRaASD
	I4t1zNKxn/HI5y3cNLYt8VKxuAk7RDI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=UW1DsWW6;
	spf=pass (imf14.hostedemail.com: domain of hdanton@sina.com designates 202.108.3.165 as permitted sender) smtp.mailfrom=hdanton@sina.com;
	dmarc=pass (policy=none) header.from=sina.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789517567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GY582zb6QHNiPHqk891VTICodNqo3q7sniFUVog2xDc=;
	b=3/fXOCLWv6EtDuwJmLT6FF9YsB9F1d5oAsw/NCy9mvn3NNhN/q6e6LXa2b0YJy4vgqhu3c
	t89qlmI0cBfxVzdDP63ixoVu1R6jewHwM6xI8WWx+C0RqTWKBXJbNGJA3NjwjXzQ4eCIk9
	U7OiBN9QE8pZxSMXMQMmrEe96JBvfOs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.com; s=201208; t=1789517566;
	bh=GY582zb6QHNiPHqk891VTICodNqo3q7sniFUVog2xDc=;
	h=From:Subject:Date:Message-ID;
	b=UW1DsWW6oIFsGqkdOaNa4R9HHARLKP5dN858zmZjJzLAxmAmEVO7hKdV0/NS4KgE0
	 C85s2v2nJ+9TlkEUCzNQ4+Z8w7ccht0eZxcwYbHYuD3x3aunMBra4Y53UWlHslgQXM
	 9eTFXJGt7i0cLy8TRDRiWC8E205PoBBy4Apsm88o=
X-SMAIL-HELO: localhost.localdomain
Received: from unknown (HELO localhost.localdomain)([114.249.62.194])
	by sina.com (10.54.253.33) with ESMTP
	id 6AA9DEF600002A55; Wed, 16 Sep 2026 08:12:42 +0800 (CST)
X-Sender: hdanton@sina.com
X-Auth-ID: hdanton@sina.com
X-SMAIL-MID: 2824336685594
X-SMAIL-UIID: D3AD1081AC674FDBBE6D223CF7F2172A-20260916-081242-1
From: Hillf Danton <hdanton@sina.com>
To: Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org,
	Baoquan He <bhe@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	lirongqing <lirongqing@baidu.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH RESEND] mm/vmalloc: Use dedicated unbound workqueues for vmap drain
Date: Wed, 16 Sep 2026 08:12:27 +0800
Message-ID: <20260916001228.644-1-hdanton@sina.com>
In-Reply-To: <aqgnOoOjWxRtaqxZ@milan>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 556ED100002
X-Stat-Signature: y5zum5tjwpb1gq7pkr7qiibnd7qjq8jh
X-Rspam-User: 
X-HE-Tag: 1789517565-2961
X-HE-Meta: U2FsdGVkX190katfwOzQrcBwghbcCs3R9qg6HtbaFO9bnjDv289hQxlyZzXBHF4gZezlPKnu0gyc5+GpGDmpZFhGvycSglZrpOMBZmzWo+UK0k7MaeK6tENvTGnQde6Z32RBmYgmMNdZIqsMuZvQHBkI2pT6aQ0krGKbpEGrCltNRvfX1kigp4EOSD2xiCl8z5O6RRuUbFIN+76TRD8ENvaCZX306Qg2GNOQ7BP3hL6tbQwZYwLWUzlPWutacnT1r180d46MCV7UJdRbHjWnUNMimINoNLx/htX5Ajm7vhFg2U49hhjUIN/oW1HumhMNAusrDAtVpoVbrWo1P7cKHAg5FHgJ9gxXyZWn7nmyM6FQplFMqOdeSM30Gi2yQWQ9ocs2KPYq7WC2XNwwr0YwlXS//aKqzk6pIA9nftZB6/51QJYY32cuzpK9qTwZVxIq3goRTfATdCvsOvNOhbzm9eXGol3WNE81ULd6uePgUtvHvrKv2f1ibHuz6TB5vPd5RK2x26DmZ5KBKv67qYOyZbJvLagv23X0mc7dTFQputQzNvUskIJLZcXTp8BkU4vKIwEsciQUF42r0ZYFvnb/mYUPxoYv77+e6BP2JpVkvvsWsPFLE1NDgmaQ5eVB58F805F975ZKKXVHoJdVwJRlq2mN7hrhq4VFZhnZJ0UZgrIWKp9dQUAY7JQTyWJ0kk3QrYZ1IkNxTySRJqJ+IleuAH70/WTwKCygTNmE7eYkw9MRUG7pfwjy+Xz+XeKS2ovL4Wcu6NW23R9oKFPxJMCTcWWlj3KpkOVp6QAbUKbAsTmAtpgAHgf/KT9PpSkAnVibDCcM1q06XgoF0YHLVRt6Gjaj32CoYI4Oxz92X4GflGvA7Bjiz2JloT8aMNHmgKvlC3riOl8mHLKQiGh9RlVhitbZ4Rg5CyasjAmEA/FdGY47+GhmtygVEN+4H7G4ckyw05T5yRVDO3/jpUZtYNN
 ieZsqQV1
 fDG88GbTc8TlvvrlcElWmYPr7dB3fqQpxkinPE0C9a7K3SJgzCYGEJw+9k4FNKxKW3IRXbhnT9V+qVXaoG/n9oeX48rX4jRK0fjp3eMjcxeYO7iRvO2z+pkHBu7MpYGt/VG9j4kchPBFLPFC2noEN/Yd6DmXTPthoxZPlz8MnILHBrT5N4nHrLXSz5sq7tKNKxnAdcuy5aGLpFkDc09s1CNPuR1UXV8Ypwwc52kUPawGX3r65SdgMuwZY2Eey5XBuTics9cUYuNWp+VTcdQQEaqTtWf5KFdNBq/UWTF7sKHvtzNWfdwAjUsz14JLvybIPnvqIhvnHWI8O0VBDHsNpMWAZyQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 14 Sep 2026 18:56:26 +0200 "Uladzislau Rezki (Sony)" wrote:
> This patch does not use queue_work_on() semantic thus i do not want to
> queue all helpers on current CPU. Instead scheduler does balancing and
> that is it.
> 
[Fair queue in the Eric Dumazet accent]

+static bool
+schedule_drain_vmap_work(struct workqueue_struct *wq,
+		struct work_struct *work)
+{
+	if (wq)
+		return queue_work(wq, work);
+
+	return false;
+}
+

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/include/linux/workqueue.h#n697

static inline bool queue_work(struct workqueue_struct *wq,
			      struct work_struct *work)
{
	return queue_work_on(WORK_CPU_UNBOUND, wq, work);
}

queue_work_on
  __queue_work
	if (req_cpu == WORK_CPU_UNBOUND) {
		if (wq->flags & WQ_UNBOUND)
			cpu = wq_select_unbound_cpu(raw_smp_processor_id());
		else
			cpu = raw_smp_processor_id();
	}
/*
 * When queueing an unbound work item to a wq, prefer local CPU if allowed
 * by wq_unbound_cpumask.  Otherwise, round robin among the allowed ones to
 * avoid perturbing sensitive tasks.
 */
static int wq_select_unbound_cpu(int cpu)
{
 	pr_warn_once("workqueue: round-robin CPU selection forced, expect performance impact\n");
}

> Or you prefer to tight all helpers on local CPUs? What is you concern?

Who blamed kswapd when it became a cpu hog, given it behaves the same way as
a UNBOUND workqueue worker, regarding cpu affinity? Given kswapd is acceptable,
why is vmap work blamed? Unfair.

