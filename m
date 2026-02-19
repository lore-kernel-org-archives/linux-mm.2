Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F9CAE9A048
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 15:28:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF8036B008A; Thu, 19 Feb 2026 10:28:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAC016B008C; Thu, 19 Feb 2026 10:28:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD93E6B0092; Thu, 19 Feb 2026 10:28:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CDD266B008A
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 10:28:42 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 874E659609
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 15:28:42 +0000 (UTC)
X-FDA: 84461588484.04.12A09C8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7E73380004
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 15:28:40 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gg2Uv3Mq;
	spf=pass (imf02.hostedemail.com: domain of mtosatti@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mtosatti@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771514920;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B/MYhX9u18ZxQhXovryB0Eh7LFOheskfwpriZ+MbSug=;
	b=YCME6KVUBueEwaZWcX219/bOv2YURAv8dZgjolHvcHw0iMPGrI0m1h1I4gU/hYCVVVFlK7
	/rS8IeOt2qTeBb59CPFpC0FH1l6FjTnybOjfXIqHVZMUQ+fqpfXLUEBSADdxD13T2IS4xa
	mg6DL5ycAV2Q8CbLhf6V5YSVXFghPPE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gg2Uv3Mq;
	spf=pass (imf02.hostedemail.com: domain of mtosatti@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mtosatti@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771514920; a=rsa-sha256;
	cv=none;
	b=tqAuAObdIzOL036gwY6NXHCV5w/PYu3aJwXlm92r9B1A4yDZpzUlx0HymRJy5vSDDVWREO
	tyymT3GbrbHjPzMtTNGqeNWVMluKmD5uIjAShcwpHZhnNd6yMrATwBa88PGH13QNyFZWkR
	Inlv5NIQwurc4V8g7oBew6wUZmSG/QE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771514919;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=B/MYhX9u18ZxQhXovryB0Eh7LFOheskfwpriZ+MbSug=;
	b=gg2Uv3MqCm9gXOWpsfOgholmi+rDFArv1CkBkkALQ/4fP1HWSH2w3ZpaF/xaoo5tHDa92g
	e9UBbntKfLkS66lztatCS4Oy0wSgjAZ1c7MrX+tpnBJNUa3v/tR1ou//7IKM7c+KP3+/ou
	WbgXVoNbk40Sgp0eENwmLcjGkCTtffU=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-488-nuJ9k3mtMk66GG3N1gk6Ew-1; Thu,
 19 Feb 2026 10:28:33 -0500
X-MC-Unique: nuJ9k3mtMk66GG3N1gk6Ew-1
X-Mimecast-MFC-AGG-ID: nuJ9k3mtMk66GG3N1gk6Ew_1771514909
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6BC7E18002DE;
	Thu, 19 Feb 2026 15:28:28 +0000 (UTC)
Received: from tpad.localdomain (unknown [10.96.133.5])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C87211955F22;
	Thu, 19 Feb 2026 15:28:26 +0000 (UTC)
Received: by tpad.localdomain (Postfix, from userid 1000)
	id BC8EE401E2101; Thu, 19 Feb 2026 10:15:41 -0300 (-03)
Date: Thu, 19 Feb 2026 10:15:41 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Michal Hocko <mhocko@suse.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Leonardo Bras <leobras@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Waiman Long <longman@redhat.com>, Boqun Feng <boqun.feng@gmail.com>,
	Frederic Weisbecker <fweisbecker@suse.de>
Subject: Re: [PATCH 0/4] Introduce QPW for per-cpu operations
Message-ID: <aZcM/X6vnzhjPTVm@tpad>
References: <20260206143430.021026873@redhat.com>
 <aYs6Ju2G4bm6_tl2@tiehlicka>
 <aYxviLoWsrLqDU7o@tpad>
 <aYywl1hdBQP2_slo@tiehlicka>
MIME-Version: 1.0
In-Reply-To: <aYywl1hdBQP2_slo@tiehlicka>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: uSLCw1eZN8l_Q_wqu0kyLNfcH9GKg5kQstghGZhwE94_1771514909
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7E73380004
X-Stat-Signature: yqie99wki5sojh4de8gc8m1mj7ths176
X-HE-Tag: 1771514920-817801
X-HE-Meta: U2FsdGVkX18SXcE+U1wj7vhFlpZv/3A0by6tzRi7Gohgg5/6OpgA/EXllww2chHJGOEJucQ0QdYqfB+s7u+UwRnz4ljwRKth8gRFO6cqAq5+cq/OkUYmLj9HU38Pk4i8yA+B7tuHRIdFU68n8xiMdBVMAZEfN8PGZ075JChn67HZJQcgs8/FhLRO2qIu2kKjfmvL8eJcUwYNfh6zmLO+NLWyn6vWqUq95AuNT4SJkF0Gjq6l7xeVPr2B5H0a57O5HuFP0CpQ1G2O//R1lGna85piXzTpKfgjqxD2O0VNlV2/5f0dxosqdqAlPAw95/qykI0IT33LiCsF77KoBNIdpp+6n5Lns5cqVrWebAegdwNKiqpcKN6j10k5aXnU1ep5pC6bPDqOp/CEZymMVj7V/jrBVJe2yzx53X2Q+G/uw1Gqo6HNhKi+jwaxb2h6/YiEGXULiVQlwmrqYLXxFrm0TLyjsBnS14rTktcNArqXKx+knnh22MwzsxYxuodxQExnfJfDAFCa/w98WAcXR2NQSibjhQJrmVGBCHPZa4pAohxGQmUNwqDxXCWTbkZ35BzkpglNiLHNy6a7OwHvRBI0/tk/duwIfhwsrRo3CaQbXEGEHNa1gOb2Wj3d759JpHzb5aYV4rOb4QHEcKnNevnE6oINPZnGASdJ3op99Cx52E0y9RJHLBhqU+SkImWX4Hvs5i4hTIZroIzXzM9/jvMjjjTRv/4C7nji6/VhVP2ChmMYerREypuMN5bvtxl2m7jAc9L1G4qjz9Z2fhNUi4euzG7u1gyC8fZPPJrVfsXMqSdY6eK0uUCQ6r7/yueclACH4Ks7wIZy+4kk+oD4SAb4NoAVlhigzfVQ6U51qq9RWQvDvbpBDlTOquR2VRRHzsPGy4hGdsis+ge8IqcWBQrRJjjxS5cHTbvi+hyRe2nqCsNAigLV+Pm/I+PWxKZCRgEstsCkB7h2UzqKILUDy7E
 cGWAQbN9
 /kmSwZyp63yWfZj3nV2G753dCb5SxwXhZ7vet/gWslLUI5PV9Qdsh4GTLHYBIOBFfawsulSTz0+X+r68Uw/y1GwDc/LnqT/oKA2A2aAcj2ZBdL0iR9N5XP1HwQ1eDOww4nfABeb+YB83FuFarQNMnBn12RFByYoo+SSS+dQ34eVXPOdXIE7ZrekQXFQYK2m0IDkE3gh3U0vZUZa00GsMmvs5kTrvlWSb83PoUXzxPxwfbVckj2FYorSfMVka+5TusOmKAsC/3FVILBRevFSiYLOIxSerM/Moe/YGGF7qYfJoKB9rT256yg1FV482OLFQu9qyqx7O3/3FbxclbhL8Ccjy+dM7UhtMaOYaCxMZLB3qublbiaW4JybBXehBSqlet55ECr3ZEASUet1M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 11, 2026 at 05:38:47PM +0100, Michal Hocko wrote:
> On Wed 11-02-26 09:01:12, Marcelo Tosatti wrote:
> > On Tue, Feb 10, 2026 at 03:01:10PM +0100, Michal Hocko wrote:
> [...]
> > > What about !PREEMPT_RT? We have people running isolated workloads and
> > > these sorts of pcp disruptions are really unwelcome as well. They do not
> > > have requirements as strong as RT workloads but the underlying
> > > fundamental problem is the same. Frederic (now CCed) is working on
> > > moving those pcp book keeping activities to be executed to the return to
> > > the userspace which should be taking care of both RT and non-RT
> > > configurations AFAICS.
> > 
> > Michal,
> > 
> > For !PREEMPT_RT, _if_ you select CONFIG_QPW=y, then there is a kernel
> > boot option qpw=y/n, which controls whether the behaviour will be
> > similar (the spinlock is taken on local_lock, similar to PREEMPT_RT).
> 
> My bad. I've misread the config space of this.
> 
> > If CONFIG_QPW=n, or kernel boot option qpw=n, then only local_lock 
> > (and remote work via work_queue) is used.
> > 
> > What "pcp book keeping activities" you refer to ? I don't see how
> > moving certain activities that happen under SLUB or LRU spinlocks
> > to happen before return to userspace changes things related 
> > to avoidance of CPU interruption ?
> 
> Essentially delayed operations like pcp state flushing happens on return
> to the userspace on isolated CPUs. No locking changes are required as
> the work is still per-cpu.
> 
> In other words the approach Frederic is working on is to not change the
> locking of pcp delayed work but instead move that work into well defined
> place - i.e. return to the userspace.

Michal,

I can't find such work from Frederic. Do you mean:

Subject: Re: [PATCH v6 00/29] context_tracking,x86: Defer some IPIs until a user->kernel transition

From Valentin ?

Or if you have a pointer to Frederic's work.

> Btw. have you measure the impact of preempt_disbale -> spinlock on hot
> paths like SLUB sheeves?

Doing that, will post results as soon as possible.


