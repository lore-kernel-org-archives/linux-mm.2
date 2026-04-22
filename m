Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 112E1F9EDF9
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 22:41:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA4586B0005; Wed, 22 Apr 2026 18:41:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C568B6B008A; Wed, 22 Apr 2026 18:41:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6C336B008C; Wed, 22 Apr 2026 18:41:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A4EE66B0005
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 18:41:34 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E37498AB7A
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 22:41:33 +0000 (UTC)
X-FDA: 84687664866.09.074AE07
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 22E63140010
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 22:41:31 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jVsFPXe0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of "SRS0=hVWM=CV=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.105.4.254 as permitted sender) smtp.mailfrom="SRS0=hVWM=CV=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org"
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776897692; a=rsa-sha256;
	cv=none;
	b=SrLTFMK43gJczV+RUYAfiPrrD9QZio9uVKfq4ViN7rbaPRAPUqIYDga+Z/ZvnnE4xWbdRE
	utZxOVZcrGhzIgkitBaoMJHBbOF0VIIBMvmonDwZ4NXmqOIYGCAN9SOmC5oT9yKZhZ/7WW
	MYq3cDAhNy3JsmRDmGs55cPICNn8s9E=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jVsFPXe0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of "SRS0=hVWM=CV=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.105.4.254 as permitted sender) smtp.mailfrom="SRS0=hVWM=CV=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776897692;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FxcUPO4equ3YjCkaPjz6cR8CN+AW5BC+3S72FPsJ/M0=;
	b=dbid5DiFRv85dtkHTxFXUnkqfgZsXt8ivGw8TyER214GH9R+XlbiC0CQKFK1B7Tlh7fLcd
	NmC2YEhiQPNW8Wi8g2K4AT3iXgDp7/28iMilJ7vxv0Hln5K2JdCy4BEMSWv1wgPGyC9F1p
	sgskwJHBYNBia+FWb+hQEiVGztCZv0M=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2731361334;
	Wed, 22 Apr 2026 22:41:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8D1EC19425;
	Wed, 22 Apr 2026 22:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776897690;
	bh=gUEK152lwoAI8GlkDU0asgwfk5vJmlbdfCMd5yE1mWI=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=jVsFPXe0khsDOZDfOQ+bRAR84cRTacJtOLZZQutTo2qDX+EN0fm28b7fxoVRqxBj4
	 pQxBC8IycM8qZcApMlBirU+WSma8HFjtRP3g7fAeGHr8a8uSirwpxrRRy+7zHgqH0x
	 Qx+du/HEepHE4dQH/OyJ4MUBW5Sk7u9oSyI+GZQfYZv/Ah8Io76ofNDMHynqNIDVpR
	 DsDbf5DjF14ejzWupQM+vSQAVmgZs/gcSA0oQ0KTVqkHoC3yPMSw1o2s9uME/3FhZC
	 tatpnlqShTcBapfl+ujtXTQqZtTyDTSaRVDy6WWnmyMfIq2b5evJL2CX3AUTxdENjc
	 enKVgqr8rO7Fw==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id 6987BCE129B; Wed, 22 Apr 2026 15:41:30 -0700 (PDT)
Date: Wed, 22 Apr 2026 15:41:30 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Hao Li <hao.li@linux.dev>, Alexei Starovoitov <ast@kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun@kernel.org>, Zqiang <qiang.zhang@linux.dev>,
	Steven Rostedt <rostedt@goodmis.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>, rcu@vger.kernel.org,
	linux-mm@kvack.org, Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>
Subject: Re: [RFC PATCH v2 0/8] kvfree_rcu() improvements
Message-ID: <db93f3ad-0446-41ea-b460-40b7fe24a4cb@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <20260416091022.36823-1-harry@kernel.org>
 <214ca3ac-45b7-4131-86e5-ac134ab0bcbd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <214ca3ac-45b7-4131-86e5-ac134ab0bcbd@kernel.org>
X-Rspamd-Server: rspam10
X-Stat-Signature: wbdgqqe1oqr96654z6fbw19a5ebkc74f
X-Rspam-User: 
X-Rspamd-Queue-Id: 22E63140010
X-HE-Tag: 1776897691-271362
X-HE-Meta: U2FsdGVkX181yl2ZCYddajj03yUtR87vbSH6Qysan/9Q0BsbBWRf1yEv13tPrlNr9hRKQmQPK+ZCl5GMhiLvurKvJXVEaDeXWjm+GdTNncqEQ0o7TYUvHeoRol3fLrq03qvAAu/vJjyW4K28fYGRjiDOsBiBsMKq1zQSE1nAAEQNTok36/3WPfiNnkveQV5L9ogl83nYgGTKxEGVUBA+W+8U2lKHjJrI1tt/R0mt1qvcNMn2zKtYfd1wd/fiYuPeYbFhhu/abHz3BmM/qcq4kaUzen2xUWH3RT3pYUtv3rTz0twu9F8W8DBbzYc6SJEh664BB1eaRACOIxCP+q7JfBIbJ/+H1/N7G7PlOW5YXvNGr9Fo5MGiKYg53IscX16pqqi2kdgxykPGlVHDP72PYKk8TGf/ch7MavxwtwqshO8fXkBy3TvPG01/Yl160M/f5uvLV9NEYdWJb7A1ZYOz58foMf4nuP0lhRbJJkRYXyHpmkjfnmbjUF2RrS3g9MWEaLlLaX2uJ8k429TdNh3cpB78gNOrJh6WN5ggd6EvqQZB0rr6YZG+z+1Bv2vWhuDe+xeQ4xuVggu9BkZ9/5DwYYXjMWCDbW5flXZ2AgjsMnHmiFlO7gbbveuDlu1jDf85J21VAXtTg9bXE/97fOget8vibd0QaiN7BTxOo0FQZt/PavaMSZ/rx3p7CXzGvjptXSrXRcDdYRuvyv9efzk2JCS9/9rUibBkcuydn/OOQCTlBpcI2CmbFePsZcya/oj10JBpvNzMLV8k2GoT+hqfxTmg9dMt58RIOf7Xh1+mfdyqLZjn970AL9ElkxexIpfpUyPRQ1x8jPnFVFpo+NeFZFH+JI9hciuSts9agaE+iDrdduNJcXWv/T2kfjAd13V//oWM8LxpDpoAmeGZuBI1mBN+qz1FG6UiJSfQnGVKLryLO8LZVMsoq4TaNNBR9uJHcq9BKwC+kV4h9zeOubW
 3O2UWVsI
 9IRsYISQ25yqHiUHQxPtcWwa2nYib3Wbslb5K9TMh+VvtL7cTkkz4dZqDA+40QDb6vw5YC5gwz0xDobTl3bLG9Xkzo0qkwePK+3C1OUBHUB6PLXeYTmBdtrs6D4GplukqG1Z71EfqhBHiep2iIqtvACcz27PQx882Th/vRdaL2P7t/du+/laKRQYxOhGKiECIgeCflmK28FQPjxAyNdznk2zQqeQcUVU8VVobd+Mnf02oH0nb+Nwy1YbSyJxnooabKdFJ2R/1lKLoYLvnAA91ttXNUDPDIip2SaWQ4TH5RTss+Rc3CCK0ZccJR4Bx1BEfSX5epHyfDfRX3eYjh9hWEMX00bY6pwoHNyzZUZy1xmjOfVtPSOUo07xGDGCco64M5eTY9UublDX0tFkiFafy2a9dcEszypYNunAW5RbWkAr1Lx7dWKH6muStihHd0wJ0IqkQb56KwtkgXU0qkn+6DYGBRKFTfPY15qOR8Pb2WyX/5jYCFoxMMfGjH8RiwtyOJdTZptcQwhUw/gPyOSH2/7Rp0hdf4Ng59NNJOSb0Bw2WXu3LyEP1jeiy569kqNMFm2057SsCA/TnKBKptIEyj1n1kRxvdBikPdLtoVANu9sb5ZqpW6dUKczt3ZE1R3o6HX0xG+HDXdYsOtY9Ma/CxN0+lC/f/I+pEZve3Dl6wbbdhQ6qeeQqTufLQ+FZ9+RtxlVO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 22, 2026 at 04:30:07PM +0200, Vlastimil Babka (SUSE) wrote:
> On 4/16/26 11:10, Harry Yoo (Oracle) wrote:
> > # Part 1. Allow an 8-byte field to be used as an alternative to
> >   struct rcu_head for 2-argument kvfree_rcu()
> >   (patches 1-2)
> > 
> > Technically, objects that are freed with k[v]free_rcu() need
> > only one pointer to link objects, because we already know that
> > the callback function is always kvfree(). For this purpose,
> > struct rcu_head is unnecessarily large (16 bytes on 64-bit).
> > 
> > Allow a smaller, 8-byte field (of struct rcu_ptr type) to be used
> > with k[v]free_rcu(). Let's save one pointer per slab object.
> > 
> > I have to admit that my naming skill isn't great; hopefully
> > we'll come up with a better name than `struct rcu_ptr`.
> 
> "rcu_ptr" sounds too generic to me. Things like rcu_dereference() talk about
> "RCU-protected pointer" and it could be misleading that "rcu_ptr" has
> something to do with this. Only if Paul think it's ok :)
> But maybe just "kvfree_rcu_head"? As IMHO It's an rcu_head specialized for
> kvfree.

What is in a name?  ;-)

I do have a slight preference for kvfree_rcu_head.

							Thanx, Paul

