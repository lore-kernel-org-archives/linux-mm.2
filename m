Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0F61D2F00D
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 12:45:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F16C26B0089; Tue, 27 Jan 2026 07:45:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9A676B008A; Tue, 27 Jan 2026 07:45:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9BFE6B008C; Tue, 27 Jan 2026 07:45:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C74BC6B0089
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 07:45:12 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3885E1B10EB
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 12:45:12 +0000 (UTC)
X-FDA: 84377714064.18.854BC2F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 77795C0010
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 12:45:10 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZqptSIfL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769517910;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J9/EIz4N/PqvzPN862/dmJctkdzBuE9L42PE6AXKKCs=;
	b=TUqLPGjiWR35hLs1Uf8wSMu1ZaNa69+HSD4HdkP35KYtW1xs4DSn366O56rY7gt91enJx+
	ray5H848Np8HhUWLkC9WvvanKAFQRWwWYJMkr3txEjQQ78uBAisDjYweCYYQsp18SQItX9
	3oX7nNnO+hynq319n/+UpXke7B6+/+A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769517910; a=rsa-sha256;
	cv=none;
	b=wZQSsQBaD2zUE+LfRYURKVjEZgExPfVFYas321KpZvVHnnk2SUUABT6ry9x4ezgvLzFnLV
	OgTOed9ntcxHqjsBbKQWy2LzPpujielFfARMxTLuM5fcotNx3KSZMhHIlLvZU9+OEmA5OT
	ZYcdWyzr+IhhvlYmpfo07VuvlYFNMAg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZqptSIfL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 52A93419E6;
	Tue, 27 Jan 2026 12:45:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AACFEC116C6;
	Tue, 27 Jan 2026 12:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769517909;
	bh=ofe10jGZoPAqJE9FQOSEtDptbVaYpx/CGbuhre/HHNI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZqptSIfLm29TLryUzU52GQpI9Y5j/egT2jG8/oQhaPPiFuy2brZcTTjX8upURbbwK
	 O2avXbgCiqu9oze4K2pbYNChHpLvtm1Jz9vMFgmPsvm1Qg+qCGw0xz/oS/xiGbbAQa
	 SpjcCq8AzzyIPMh00tl2Kgj9nT4Pwz/av8vbzs9TI8IvS0TbBOA5TPk5EJhldEKCd8
	 z9JwUU8X8St7FkUL33asPHS0EmzbQdBqKLrg7pOsDN/QpZKsgStUPPRJtFFRc43nWE
	 6CsKod/Uczqk8wBl9Y2/65PFXOSK8XPZjs8cgK1siNQjv5//Rrl9afMnIDi/jt4EBR
	 gt2lbSbmoncAQ==
Date: Tue, 27 Jan 2026 13:45:06 +0100
From: Frederic Weisbecker <frederic@kernel.org>
To: Michal Hocko <mhocko@suse.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Chen Ridong <chenridong@huawei.com>,
	Danilo Krummrich <dakr@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Gabriele Monaco <gmonaco@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ingo Molnar <mingo@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
	Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>, Phil Auld <pauld@redhat.com>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Simon Horman <horms@kernel.org>, Tejun Heo <tj@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>, Waiman Long <longman@redhat.com>,
	Will Deacon <will@kernel.org>, cgroups@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-block@vger.kernel.org,
	linux-mm@kvack.org, linux-pci@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH 03/33] memcg: Prepare to protect against concurrent
 isolated cpuset change
Message-ID: <aXizUsfywjtIIN50@localhost.localdomain>
References: <20260125224541.50226-1-frederic@kernel.org>
 <20260125224541.50226-4-frederic@kernel.org>
 <aXeZQoSHJ9QX7B6W@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aXeZQoSHJ9QX7B6W@tiehlicka>
X-Rspamd-Queue-Id: 77795C0010
X-Stat-Signature: 6wdbxrhjhhktddhj7ua8wcoepf49w1cs
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769517910-207631
X-HE-Meta: U2FsdGVkX184CyoZqyWrcmXrBt4G9MFRqAIQdALGWqHq8HVyfcifascLZUpPitqM9WvEwx6VRkeNy0oHKBR5921Xt3GZ4r6MWCiVS+w75REAnXexqaxpLmNqKCzCypqwjwOLQVX/dPHVg8HK3EplvTnPn7iBAhDMvBvkfJXScjrCPFr+IxJ/hMFWm1vbWLpmJuc+YYZCSG/MLT4Q8q/i/18pDTYgKaVzh0XQvYGOUL9j1bw+2qeXU2whp2nfn3PzSFp045jI1MpVKxQRlQsHVElIKtAO6GogmL6Exov/HL0YIWXkRPIMSr4f22zSv1z4Nx3Op8fwSDCeDRQ8+Ti3qEHLb5XmE5vbQjvsgyoIAHwwk6zEy8b//pStv9DJL72gUK1NArMUXUTPQTfDYxkujlfr1vTS6AoNRvZT62kEdY7yBaqFP5eX1GJDLI847ulAKZOriDH+ee7dsiGfjxuW4QO3AZ+HHHCai/SPs1/zJU30+4nV8hrDGYFqIpO0ScWkpwkvjTGbS41FxqHHBve/z8QkJKRMcUOk8FPSMFR5EZsi4iNd0zJSXLlYi4NmV5dmwOznOxbk1+Vrt5TQ2kmHePZjlo6S0G410+8k0yV92zWNhgCcqVL3CjnfJnr9LNIvm3NaVTrqLW92lIDV84TXNOPknuDHawwaYo2tNpOXdA+G5LGZFXD4oDNrxWeSHDO3eyIr0B0zW8wDXnECEQn3ospzMkSXBp4yXWdtflj3OJBNdWEcTIublTk1+OMGNFIuDa+cJT9lMzPlui0tsHv8LO3fL20uE2AF/v9nE0ua09QlnEFMvHAq8FyXWenH1rRtvvoFQoV1V+eab5sYkFIcNjnwiGyi3pgqCRRp49iHAOCcjRTr3u51MhZfQ+KCy4PZO3N8WwtU/SgIm+5ULrevB0RFHWhmfggnYG6BxUm1E5/0XTp+X/vGPffycviT7ozSqdcehe7usAfiK17JAZg
 89c7f5ac
 tVY7xY57oQxZF7Oqtfh5QgG64NxwcHys6YeRBCIMAI/xQ2VbSu40aDdEh5JHEEH84K3cNzJkIIwLk0OEsQSYZV+++Syshy5HxKiQY/TyFTPZPJMgUlDmBpaEGDlDubxHMhiyEXGxBuO4KeVJDg6cVbiWzZ+V9siHgFFPoQG/+C2TtzBlXIlL9hLQl8UG1RiI0r2EmXbEGf01qaw0XFiR9M4fWIlqgw0rfNeEOk+QESIIb7eVYJlyU/CxFecSnXf6Bhf7kpyTcxofjSrz7OM0BT3CjY6IVQk9cN7D3kGfDoitVjHA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Le Mon, Jan 26, 2026 at 05:41:38PM +0100, Michal Hocko a écrit :
> On Sun 25-01-26 23:45:10, Frederic Weisbecker wrote:
> > The HK_TYPE_DOMAIN housekeeping cpumask will soon be made modifiable at
> > runtime. In order to synchronize against memcg workqueue to make sure
> > that no asynchronous draining is pending or executing on a newly made
> > isolated CPU, target and queue a drain work under the same RCU critical
> > section.
> > 
> > Whenever housekeeping will update the HK_TYPE_DOMAIN cpumask, a memcg
> > workqueue flush will also be issued in a further change to make sure
> > that no work remains pending after a CPU has been made isolated.
> > 
> > Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
> > ---
> >  mm/memcontrol.c | 21 +++++++++++++++++----
> >  1 file changed, 17 insertions(+), 4 deletions(-)
> > 
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index be810c1fbfc3..2289a0299331 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -2003,6 +2003,19 @@ static bool is_memcg_drain_needed(struct memcg_stock_pcp *stock,
> >  	return flush;
> >  }
> >  
> > +static void schedule_drain_work(int cpu, struct work_struct *work)
> > +{
> > +	/*
> > +	 * Protect housekeeping cpumask read and work enqueue together
> > +	 * in the same RCU critical section so that later cpuset isolated
> > +	 * partition update only need to wait for an RCU GP and flush the
> > +	 * pending work on newly isolated CPUs.
> > +	 */
> > +	guard(rcu)();
> > +	if (!cpu_is_isolated(cpu))
> > +		schedule_work_on(cpu, work);
> 
> Shouldn't this in the guarded rcu section?

This is what guard(rcu)() does, right?
Or am I missing something?

Thanks.

-- 
Frederic Weisbecker
SUSE Labs

