Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64771CCD195
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 21:21:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A31C8E0009; Fri, 17 Oct 2025 17:21:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87A528E0006; Fri, 17 Oct 2025 17:21:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B7278E0009; Fri, 17 Oct 2025 17:21:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6B0E08E0006
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 17:21:15 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 37BB21602A5
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 21:21:15 +0000 (UTC)
X-FDA: 84008876910.25.12BF3AD
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4B7F440009
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 21:21:13 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cVMhyYb7;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760736073;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YrDL0c/M+J3ZU+1YrOf5u7VfSDUST8z9dw2cDkrdgtQ=;
	b=V05Zaof7UbLJgalZ0zOF7QzJjqbrUFKoLhJ/OJ0sOaVMXhm7wMSHq59Fgx7jhtIcJrGP/h
	HjKec8GKj8TeovZiTlQWKl1FJfRpQUqJ4g68KALKYPBe+VzYzLoahS/TqXshPw0wJNBuER
	eEdqf7dV4L4rRQdkAeqooPK0pksfRBM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760736073; a=rsa-sha256;
	cv=none;
	b=ZBv2IhAO15CacGpLXlFzD9C3kkAoKGAwJ008Sd1q4OQKXZ11aKVsg1xC5GpRHuXT3Xa/iV
	8gRqWWoTRMohihM+8/+J4MNr7Zgdlpv+hoimhD5XoUrdz4jhLVJ+8Bo9iV79FzRlfA6hBP
	UyPyRH7lBmz//SBDH5++A93IKHlQfIk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cVMhyYb7;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
Date: Fri, 17 Oct 2025 14:21:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760736071;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YrDL0c/M+J3ZU+1YrOf5u7VfSDUST8z9dw2cDkrdgtQ=;
	b=cVMhyYb7hm2NG2noNVsHxfNZoFjbk7DYfg8bEDXc9k/szYHZqW3C+jIj6+SOEfnqf3XzBT
	fmGJWza+QDJZTFeIMiFJPnSvZ7lXpsVMhijyqBvUKirYWxPZ88gsco4LplzoQdQ8VI+yCG
	f/k2OAlWePwj/uG0Ps9Rj0RbLohCGOM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Daniel Sedlak <daniel.sedlak@cdn77.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>, 
	Eric Dumazet <edumazet@google.com>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Paolo Abeni <pabeni@redhat.com>, Willem de Bruijn <willemb@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, "David S . Miller" <davem@davemloft.net>, 
	Matyas Hurtik <matyas.hurtik@cdn77.com>, Simon Horman <horms@kernel.org>, 
	Neal Cardwell <ncardwell@google.com>, Wei Wang <weibunny@meta.com>, netdev@vger.kernel.org, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Meta kernel team <kernel-team@meta.com>
Subject: Re: [PATCH] memcg: net: track network throttling due to memcg memory
 pressure
Message-ID: <cyg7k36ohtg3irtz7qqlyzsgh27ewibbsornq6xe2cjw66zsy7@cjpxycqwgigy>
References: <20251016013116.3093530-1-shakeel.butt@linux.dev>
 <59163049-5487-45b4-a7aa-521b160fdebd@cdn77.com>
 <pwy7qfx3afnadkjtemftqyrufhhexpw26srxfeilel5uhbywtt@cjvaean56txc>
 <209038ea-e4fa-423c-a488-a86194cd5b04@cdn77.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <209038ea-e4fa-423c-a488-a86194cd5b04@cdn77.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Stat-Signature: jnm3un5qgi5wc89ism9ww9u5cp118as1
X-Rspam-User: 
X-Rspamd-Queue-Id: 4B7F440009
X-HE-Tag: 1760736073-466348
X-HE-Meta: U2FsdGVkX19N672K0aZNCunZ4gYKO6bYlBUr+NSXvFB7CXgUx6RwlpvNARs6db+tBloJINagqn99AiB5z1Y6ACb9uDwsr/Gp3si0DSyG7TcHI4jIkguvGpIOIRriZf2GQXlEPL4lvcNtKtLjVa7VS4c27n0/tjFVWiyXFDZ+f+YaqEN/cGzBkwMbPJ7CUwls2K4n3OXunLO6heMKBbJcO2izTnc/F9x3pXLg8cdS4IY2tKLICCTdkzO1F6MKnsbZTDYLyg4H4uKfEp3derptkndHRhQ7T2nAHZ9QpDrSFOHH2sXmURNtfEcbtFIeyQAKcVcM7dd6i/PS0wbrotdKhljd7KX1gGW0qP0ZSTUZpxoMtpQSw+djdnel6TJg2Ryv9mN92csIo5M2/4k7iKrwbprWsMPdCQ5NJjywvZ75UG119OWF9L+lNGhkR0OaNTEBRpSIZ63VyfyUBYBVipfKsfmlaK/qmQKnkByKELZpOhJzju3XTGA/tIrfXcXiwuWNceKN0evOeJckHOk+SAyqsOE4xZmSTtIjpHjDkWAvawpynBO16duqJt+8Smstac+wx/nAH1a4nxS764bnHOulDZM7DfVfXuw2p3qshxM5kYDAA+7LVsd9IRn720BO8y3ic477ZgvxBlY9V8HxiSNiDosM9Fl2/24BAZWWe1bJkHpVbNP4vSzJLeGfxNfVyoguMOeyUrylHyfoRSVZdnyM4zKsXChJqlWG4zgqnG5ef1hS0aXSHdwgQzOzwCEodJ90IC2SxCxL+S2cQScWwCALKCcWPW6Tu67FyQ0wyT4a0I2qbKwcIgBoaxnyhHavH8QV73MJifl7sZ6O8NOeFS/rAlviE1IGBZwR3znsOxnSYW/YkR2fNlwX4rXEuygyKaz72qGV7vFPDeoWMmit89gvGIAJ2mt76lqS0A0onanQ2xtKnvQ5mBxwPEdwXEtnpnRQgB3LV72eyZEI6/P7+9X
 /W2/SHvz
 HRR8zjNqu95YcXlI/fxksTmyl7QbI02Qi5xGte8eoBnuRohbmXpyyBHNgHKQhy9kd2aupIJ7K+qQWjvCdTStJh8nLRSJlj5mjMwlLaTNq+5pvkDvlbtoHQbxBAvUPssramq5ChnxrztLT+XqDlcjWOXM7noE3Z3W1A8NaHl80yU2oxs2t/OxYYvWsOWIr3aFKeO1gx7+DM3tSxdXoWdTZhHbAVA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 17, 2025 at 04:15:18PM +0200, Daniel Sedlak wrote:
> On 10/16/25 6:02 PM, Shakeel Butt wrote:
> > On Thu, Oct 16, 2025 at 12:42:19PM +0200, Daniel Sedlak wrote:
> > > On 10/16/25 3:31 AM, Shakeel Butt wrote:
> > > I am curious how the future work will unfold. If you need help with future
> > > developments I can help you, we have hundreds of servers where this
> > > throttling is happening.
> > 
> > I think first thing I would like to know if this patch is a good start
> > for your use-case of observability and debugging.What else do you need
> > for sufficient support for your use-case?
> 
> Yes, it is a good start, we can now hook this easily into our monitoring
> system and detect affected servers more easily.
> 
> > I imagine that would be
> > tracepoints to extract more information on the source of the throttling.
> > If you don't mind, can you take a stab at that?
> 
> We have some tracepoints that we have used for debugging this. We would like
> to upstream them, if that makes sense to you?

Yes please, send them out.

