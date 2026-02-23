Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C5A5EC1101
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 16:09:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1A516B008A; Mon, 23 Feb 2026 11:09:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEDC56B0092; Mon, 23 Feb 2026 11:09:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E18376B0093; Mon, 23 Feb 2026 11:09:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CD7746B008A
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 11:09:07 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 722DA1A025C
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 16:09:07 +0000 (UTC)
X-FDA: 84476205534.27.39EC7A7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9C9BA1A0006
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 16:09:05 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="l9pVaPN/";
	spf=pass (imf19.hostedemail.com: domain of maz@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=maz@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771862945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uUkulhqd3j21MPEfBNgvIJ+c5xdGo3X/2WCE+4JMzlw=;
	b=oC22ghjk6IE5FErbIlGGagSYqpFGHUAVczWiWlWFyKTwKq5IHMY1mfkr+tEB+/AWGvqzuW
	C0+EolNXdS9+cXADWGvdK9vI4B7S+7Q6dBK44PGVACti1c3rBXUowm2BwnCXC4vbV7lFvn
	1DgJ26B+k3vyPDU3NqfjcvsgykmibTU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771862945; a=rsa-sha256;
	cv=none;
	b=NOor9Pg7hXjKFOROKCqSlhjgLrgrZUC8WGTWj1mMlOho1gLpwj1/cji9I9hC58qsBWIwi1
	JpXNFuhyum21mZ6PFqxbZAix+XVjxAVzYfgpLcUuk41b0f+m2ejeXh0gMlVNxV1NMI2Whh
	7bnILQtfjHZ/x4an5DjcTxABx3JAWBY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="l9pVaPN/";
	spf=pass (imf19.hostedemail.com: domain of maz@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=maz@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EB17760097;
	Mon, 23 Feb 2026 16:09:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91C5AC116C6;
	Mon, 23 Feb 2026 16:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771862944;
	bh=U1f4VUWvlVoHVRzjSsvSj6+GTfFekKDeqZn6GrwXI0o=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=l9pVaPN/cxEh/suCVhuWE9zKuRvobiCEGJ0txgkBo9PpXkl47x3YeBE24NtYlHPBp
	 Z9MvnO0WtjK2zPWfQ/IfIVLCZffKJlqemIihS/QeSLhwIJq8IdOPIU+1f9688A4XMp
	 gwlAn+/8UAVE4a0QW6Jp5dz96715FKWMWVIWgA0sngCXHv+7g87EwavNZvdprMhmg7
	 MahbRAl/A4ygOiEtD77hedrDSCJEvgQIk8RNwhzzo9fFOFuUA/+QEBobC2lco7cD/+
	 etfl/NJ7Xp0yiJtecEPjRZB5hFueUHK0rlemZus13jXbfPV+sMsHDxL+4n4NsgZMVR
	 B+47pl7GCN5cg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=goblin-girl.misterjones.org)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vuYUX-0000000D3Lu-3QOf;
	Mon, 23 Feb 2026 16:09:01 +0000
Date: Mon, 23 Feb 2026 16:09:01 +0000
Message-ID: <86jyw3a1cy.wl-maz@kernel.org>
From: Marc Zyngier <maz@kernel.org>
To: David Lechner <dlechner@baylibre.com>
Cc: Frederic Weisbecker <frederic@kernel.org>,	LKML
 <linux-kernel@vger.kernel.org>,	Michal =?UTF-8?B?S291dG7DvQ==?=
 <mkoutny@suse.com>,	Andrew Morton <akpm@linux-foundation.org>,	Bjorn
 Helgaas <bhelgaas@google.com>,	Catalin Marinas <catalin.marinas@arm.com>,
	Chen Ridong <chenridong@huawei.com>,	Danilo Krummrich <dakr@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,	Eric Dumazet
 <edumazet@google.com>,	Gabriele Monaco <gmonaco@redhat.com>,	Greg
 Kroah-Hartman <gregkh@linuxfoundation.org>,	Ingo Molnar <mingo@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,	Jens Axboe <axboe@kernel.dk>,	Johannes
 Weiner <hannes@cmpxchg.org>,	Lai Jiangshan <jiangshanlai@gmail.com>,	Marco
 Crivellari <marco.crivellari@suse.com>,	Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,	Paolo Abeni <pabeni@redhat.com>,	Peter
 Zijlstra <peterz@infradead.org>,	Phil Auld <pauld@redhat.com>,
	"Rafael J . Wysocki" <rafael@kernel.org>,	Roman Gushchin
 <roman.gushchin@linux.dev>,	Shakeel Butt <shakeel.butt@linux.dev>,	Simon
 Horman <horms@kernel.org>,	Tejun Heo <tj@kernel.org>,	Thomas Gleixner
 <tglx@linutronix.de>,	Vlastimil Babka <vbabka@suse.cz>,	Waiman Long
 <longman@redhat.com>,	Will Deacon <will@kernel.org>,
	cgroups@vger.kernel.org,	linux-arm-kernel@lists.infradead.org,
	linux-block@vger.kernel.org,	linux-mm@kvack.org,	linux-pci@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH 04/33] mm: vmstat: Prepare to protect against concurrent isolated cpuset change
In-Reply-To: <47be2ff3-c25a-4aab-89fc-53921af8b0a9@baylibre.com>
References: <20260101221359.22298-1-frederic@kernel.org>
	<20260101221359.22298-5-frederic@kernel.org>
	<47be2ff3-c25a-4aab-89fc-53921af8b0a9@baylibre.com>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) SEMI-EPG/1.14.7 (Harue)
 FLIM-LB/1.14.9 (=?UTF-8?B?R29qxY0=?=) APEL-LB/10.8 EasyPG/1.0.0 Emacs/30.1
 (aarch64-unknown-linux-gnu) MULE/6.0 (HANACHIRUSATO)
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: dlechner@baylibre.com, frederic@kernel.org, linux-kernel@vger.kernel.org, mkoutny@suse.com, akpm@linux-foundation.org, bhelgaas@google.com, catalin.marinas@arm.com, chenridong@huawei.com, dakr@kernel.org, davem@davemloft.net, edumazet@google.com, gmonaco@redhat.com, gregkh@linuxfoundation.org, mingo@redhat.com, kuba@kernel.org, axboe@kernel.dk, hannes@cmpxchg.org, jiangshanlai@gmail.com, marco.crivellari@suse.com, mhocko@suse.com, muchun.song@linux.dev, pabeni@redhat.com, peterz@infradead.org, pauld@redhat.com, rafael@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev, horms@kernel.org, tj@kernel.org, tglx@linutronix.de, vbabka@suse.cz, longman@redhat.com, will@kernel.org, cgroups@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-block@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org, netdev@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Rspamd-Server: rspam09
X-Stat-Signature: ufnuhgaaoxp143hbxhohcf35kfyasesg
X-Rspamd-Queue-Id: 9C9BA1A0006
X-Rspam-User: 
X-HE-Tag: 1771862945-680628
X-HE-Meta: U2FsdGVkX18Jyz82vxrntjpgnu6dG6qhkaWSLrDQuAeut6BLxIH9I2fnpoeBiy6pH0fDPfEo0lEsFsWQMrYsha4zBuhlO7H027mbuU20yfUy5QrdxnuooQCKz8DwR4fEZEsSLIQ/ltXkyn3UWDRMuZUOEihFVwwgjxE/nwo7Tcm16Clmp54yZsAKMFLEut6Uh/GMdQ65gedP2BNFCASpB9ZngZlIbSYNOX0C/+t9ADuZ0LVMPOL3qLzIOkOd4e2RasC8qa/02jTRLW2yUJTrlqbbPor4fnnkcbsYrBf++g39fieh2tmCnS80Lph24PLLNbpho9oPKX98m2YBX3P7sET3XxzwNAJDNMZUqIr9knFCRIbW+FDtlbT0pxZYvJ441+T9ApxNTjfs+OPP4bpE2xPvEotOJRV4Dfs3zLVhG9cuTaF/pJ23YcEUpzSYQ4ANV5GNml7OcWkJSziXZlpCRKgUaf07EflSBZYxs8NikWqQa+DYp5sLCYRCnKTrw/xEE2Vgt3WTahWqynKcmmeOLHYQUvvGSCZC9n+TAaR+0P39D0CoP5BIhEUBAs6Y/4EcAL3s1j+UDsMBiJMsYdsZdahUCDTdQpJ6BtDCSCI80HYnsUspxmV8xDmk85aMLfXhe/ynV9OJYcRq/InXSgubGdQAZgyYg1QBlK4WSpqC1x6vJg4ngsluLFtb0M05J9a839Su6kEpvk0JMTXDXUW679saWOwVax3Mkv3K/0FV7VC8WUYDevDp3KtHLY6k1IpDhIklW4/pH3m9HvCr4aRDx8PIscFL9pWaPD+j0NyeCbu7TzFKtTtpIosBWLt1iWaKILmiTFwf+8LWFceo+dSCgkfRFcpH7uo/S3k3MMI6m4V1gh0cX9/rvRXoSkaXmbypuOC5cI1Jji9PPz1Wr/kFtcpir30hsNltL4GaFrc/QlV3hBa+5hcm/a5d+FLM7Ek9uni3p3sCV1s0G/NaGo0
 wBuX36Xy
 H/+i6SFIkvJWVEEj6I8PbcA9pHtMWfGGp19vB/7GBGaIien65JOpJSmCbgo6m5vVZ/O9B20BsAKJZ/ZKOZrT62V1OVsVAAORTWizHNkEYuE6MCEPww+neL0KJH3zlxQ7+Z81Fo//k8re7qaZh+KpwV7D/gzfEGn+GxSGrR396hyoVY8Iffxex85gwUW3zgmW1s5Hx0imTJnhiV24rAFCn04uhq3NzCN73I8xvZEdrwGrbW+FN0sd/Rit38CDvjBYTKXkKsdLO5uwanno=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 23 Feb 2026 16:01:03 +0000,
David Lechner <dlechner@baylibre.com> wrote:
> 
> On 1/1/26 4:13 PM, Frederic Weisbecker wrote:
> > The HK_TYPE_DOMAIN housekeeping cpumask will soon be made modifiable at
> > runtime. In order to synchronize against vmstat workqueue to make sure
> > that no asynchronous vmstat work is pending or executing on a newly made
> > isolated CPU, target and queue a vmstat work under the same RCU read
> > side critical section.
> > 
> > Whenever housekeeping will update the HK_TYPE_DOMAIN cpumask, a vmstat
> > workqueue flush will also be issued in a further change to make sure
> > that no work remains pending after a CPU has been made isolated.
> > 
> > Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
> > ---
> >  mm/vmstat.c | 10 ++++++----
> >  1 file changed, 6 insertions(+), 4 deletions(-)
> > 
> > diff --git a/mm/vmstat.c b/mm/vmstat.c
> > index 65de88cdf40e..ed19c0d42de6 100644
> > --- a/mm/vmstat.c
> > +++ b/mm/vmstat.c
> > @@ -2144,11 +2144,13 @@ static void vmstat_shepherd(struct work_struct *w)
> >  		 * infrastructure ever noticing. Skip regular flushing from vmstat_shepherd
> >  		 * for all isolated CPUs to avoid interference with the isolated workload.
> >  		 */
> > -		if (cpu_is_isolated(cpu))
> > -			continue;
> > +		scoped_guard(rcu) {
> > +			if (cpu_is_isolated(cpu))
> > +				continue;
> 
> I think this might have introduced a bug - or at least an
> unintentional change in the program flow.
> 
> scoped_guard() is implemented using a for loop. Now this continue
> statement will only exit the scoped_guard() scope rather than
> continuing the outer for loop. This means that cond_resched() will
> be called when it previously was not.

Yup, I've been bitten by that once before. It lead to very subtle
breakage that took me a while to figure out. I've now mentally
banished the use of scoped_guard() inside any form of loop, but that's
a pretty brittle strategy...

	M.

-- 
Without deviation from the norm, progress is not possible.

