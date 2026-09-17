Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FCF4C982D0
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 23:24:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40D556B0095; Thu, 17 Sep 2026 19:24:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A6436B0096; Thu, 17 Sep 2026 19:24:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BDED6B0098; Thu, 17 Sep 2026 19:24:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 087A46B0095
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 19:24:28 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9B96180527
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 23:24:27 +0000 (UTC)
X-FDA: 85224835374.15.74D9E88
Received: from r3-19.sinamail.sina.com.cn (r3-19.sinamail.sina.com.cn [202.108.3.19])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5ADE5100008
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 23:24:24 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=mkfUSD79;
	spf=pass (imf14.hostedemail.com: domain of hdanton@sina.com designates 202.108.3.19 as permitted sender) smtp.mailfrom=hdanton@sina.com;
	dmarc=pass (policy=none) header.from=sina.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789687466;
	b=IHrFYpOlAD2UtzC+Jz9vAPxDM1UzTOMBKPTfkvIW9D7mvs5idksJk2JRyyy3K5GRw77rDF
	r4WsvDyY3iQaDy1AJnS5Fz+zhvHmk/mzv4WvChJgx5snXlzmjJHCp3x9vpnjdZFXeBeEth
	vLEfMUNt3ZTCoFNkbFPFVGUiWp+DpW8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=mkfUSD79;
	spf=pass (imf14.hostedemail.com: domain of hdanton@sina.com designates 202.108.3.19 as permitted sender) smtp.mailfrom=hdanton@sina.com;
	dmarc=pass (policy=none) header.from=sina.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789687466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wD3ix+GkvvUDsItvPW+fTEfQlpnEcapDfRBp/Zp7cn4=;
	b=d3rb2lpzJRF67dccXJb4M9EZjzyf4ZAjXZbt1mTncqYXuCznTrrfoaPndhE8Om3CTDIMFL
	z1DqQT2RD/5Uy0FfRCDulQRrgfMya5mbkrFy73y3Zt7of30O9xBE1/W3XxCFfNrIRR0uiB
	Go7e6vQHIpwSz/d9Aftzq9I999AC1q8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.com; s=201208; t=1789687464;
	bh=wD3ix+GkvvUDsItvPW+fTEfQlpnEcapDfRBp/Zp7cn4=;
	h=From:Subject:Date:Message-ID;
	b=mkfUSD79mvo45wjEDHoIzOl8ue8GuY4A8HFUIIJ1LsrONKLGeycy1+ibsMPa0HFXQ
	 bgovalo/7+ICfK83X7u2/u8nxNd5bKaOjv+JqGOCco43+ufnVXhrRXm+qmMofT7qCK
	 DBYyPYcP0s8y84wD8SYhKoQIuoWURLZXATs8Zsuk=
X-SMAIL-HELO: localhost.localdomain
Received: from unknown (HELO localhost.localdomain)([114.249.62.194])
	by sina.com (10.54.253.32) with ESMTP
	id 6AAC769F000043A8; Thu, 18 Sep 2026 07:24:19 +0800 (CST)
X-Sender: hdanton@sina.com
X-Auth-ID: hdanton@sina.com
X-SMAIL-MID: 8797334456770
X-SMAIL-UIID: F722E39483804F05854D24E375EE6576-20260918-072419-1
From: Hillf Danton <hdanton@sina.com>
To: Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org,
	Baoquan He <bhe@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	lirongqing <lirongqing@baidu.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH RESEND] mm/vmalloc: Use dedicated unbound workqueues for vmap drain
Date: Fri, 18 Sep 2026 07:24:05 +0800
Message-ID: <20260917232406.148-1-hdanton@sina.com>
In-Reply-To: <aqwdc7Oh24b_bxOQ@milan>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5ADE5100008
X-Stat-Signature: wxm6n9ahf1brhg3mqps8xrptaw1wu43m
X-HE-Tag: 1789687464-413600
X-HE-Meta: U2FsdGVkX1/K4ogKQX1vO3MndgV/X9Fk2U7/KYDjk3yBvibOyFyHcHeKmNCB40OwgYq4jHlEUIpsoH0R1f1+rrZMpO5PUufjA4y6i3NyX8/PtxwRp7k+UGWq6tPFLGaHmdmFgEMu0AqkF4wNaLQdQJGr6V4qeYZkP28irfSlAn9LMykdmZ679iklN71Zr52bkJe71NPTEZPCsIgPmCPZQ0MjxOqO/ygjaMosQd4VYPpNX6AUDBjqoyb+dxRgCrgQaxCkewuaAhQry8RZP8fBrhfKBDDDwIpHQrPTiIz+zhD0qQERtiDdQMFpc6xyOhT8ynom5yK9BL117jWHZN/G9Wrt9C50Kk/cKwu30FzY4oSqwXCD8akdpsVeVUhdwYmvikTNC+Wzz52oMR2/2ORbhWAGzVOd/1xxzCnE0ABVaL2Jk/zjXpOeUq8HRwHvdzyUVrxeqUIgXJXwwbESyzf4pqkM72t+MW6ea57z6dRfJTm36nWPRbXXeYjLWg0es2z3iZHByrr1yZ4rRSOezpOs/rAOTH6IXK9GKdF3y5J0aitdzMYdaxpy7Zqzx8ztytE/mrppf5JLqHgG+sRrMLy5kxwYTZaYWt5B4Suy4iOch6E2qOSAJw5zNbg5f4B/womsuQqk9JC1p0OGJmvBqIWvxZ6clU81Gz3+ymLy0i7KGDniN9a2A7OT4WldiBbhwJb7IrKbXa9ZiVw10twOJTX6z9ZKN+bgg9aTSGIjWRR5ozPgUAL8PJXMC+TeCJi9OeXmbHAUbBuM4jeoGohMRF6cXi6ZDfoNWhOI0ao3+vdJbnF/pJI7H5ilAkcotLyS/RZ9/Y7Lj5weu1K/UwPoU9Ujtu3snKC7hKooB/JOMaCE6VhIfm8/DvbYLJAWPLEFQYCUKSaN5spEaeltpqkzJnLNHjtqBglp0sAMHeYD+0376gG1z8w2EWtD6I7Zfuri5743+69YPMb8JvXuRh3tKgE
 AqELh19U
 zpCVHe4KNhbCHbvskcn0CEFACrkTHaZy2HwP9wga5jMpUWZSCG2NcJR74poImjokn+wym1tzpOysRa5+ae348QEdHkvG7jZP+CRGGSHG38RV/3HTMWTx4xVaLu9s8s15kFUzFu5AUYz9aTFj79+2ep8+5Fw5Bcc41Gk34UgDTsDXTwzQp9b+1MEDgKddwEPCmwZKLRH3/pe9NI1Xxl8tDpwp+KiBsc/TwHmTRv9Q4M15ZleXpWr5eOY/upcZy8AYE31Tw54s4T1Kn2wlEYLbgoqSzAWc2j1ovR0S2xpq5JmlqPajZ+GzhLM/Xcw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 17 Sep 2026 19:03:47 +0200 "Uladzislau Rezki (Sony)" wrote:
> On Thu, Sep 17, 2026 at 08:07:37AM +0800, Hillf Danton wrote:
> > 
> > Given numa node1 including cpu8-15 without cpu hotplug cared, a bound worker
> > for cpu9 can not migrate to any other cpu, while a unbound worker can run on
> > any cpu of node1, that is all.
> > 
> Right. 
> 
> <snip>
> 	if (list_empty(&pwq->inactive_works) && pwq_tryinc_nr_active(pwq, false)) {
> 		if (list_empty(&pool->worklist))
> 			pool->last_progress_ts = jiffies;
> 
> 		trace_workqueue_activate_work(work);
> 		insert_work(pwq, work, &pool->worklist, work_flags);
> 		kick_pool_pick(pool, &wake_task);
> 	} else {
> 		work_flags |= WORK_STRUCT_INACTIVE;
> 		insert_work(pwq, work, &pwq->inactive_works, work_flags);
> 	}
> 
> out:
> 	raw_spin_unlock(&pool->lock);
> 	if (wake_task)
> 		wake_up_process(wake_task);
> <snip>
> 
> wake_up_process(wake_task) - this guy takes care about task placement.
> For us it is TASK_FAIR thus select_task_rq_fair() decides the fate of
> unbound kworker.
>
At best an idle cpu is selected for the unbound worker, but it may be
preempted the next micro second. Maybe you disagree, eevdf means uncertain.

Even given an idle cpu without preempt, it fails to prevent the vmap
work from becoming a wart, no?

