Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05696FAD3E1
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 01:31:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEDC96B0005; Wed, 22 Apr 2026 21:31:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9E6A6B008A; Wed, 22 Apr 2026 21:31:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8CCF6B008C; Wed, 22 Apr 2026 21:31:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B5E586B0005
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 21:31:22 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 62BBC1C00E0
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 01:31:22 +0000 (UTC)
X-FDA: 84688092804.01.D67B86C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9BC6220014
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 01:31:20 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZEJZWo7I;
	spf=pass (imf13.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776907880;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5xw8K/3N0pnimoWlJLILrq6OleBdTSLVFDh7+6+ZA8c=;
	b=nlVCWnaMeROcxmqzk+FmvY47xyCH9E+MZPEoxFiM9WExav5gUywrN5GBIQbFi/p6HCw12c
	e2PyfCpIPe9U4wFwRa7zOv4rPzfbF7gvf0GqXHq+cfKOIFfyrH17K3mha8sjYusgIuMFun
	Jq4dYgbHPzzhm5d2SIM/yd+KkM6zrkw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776907880; a=rsa-sha256;
	cv=none;
	b=WJHE61NyltXgLZEmy6VJag4JPZtMRMqtPSltQd+ij0d52vuI7NWUOga7OzUbsPv3dqPUUn
	SpbZty5plAZAABCO5uI2NvC1cdKH4U0WVSS46D9rncp2KgBOqlddrKH71mGhd6KKhnHSkH
	Cv/f4KfQbh0Z0Uki20DQqMJRcCKMleQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZEJZWo7I;
	spf=pass (imf13.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BD25260008;
	Thu, 23 Apr 2026 01:31:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFFCAC19425;
	Thu, 23 Apr 2026 01:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776907879;
	bh=jlAGtqvwrlvzYzSmfvFrSnoSFtUA9CDJqYVY/DrcyQE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZEJZWo7IQJuIGCKRZDR/ii0H6m9xm9EV9uOtNDrN0f8QCeqLoedks257e0Mte/UCw
	 K5+jGRaevfQ5qE+RMQzQ+nXMSoOHIhQC7rwC4oXhV1gxV4htVQUfw743nLlosIzf9g
	 vYk53ptKBWwJ20msbQngDer/b42Yew2NBQhJezXnlYq4uckN2HOunUPC4eYb3XrTMV
	 5SjtxITuoDs3apa4uPiphxFQvVF7ggKuZMx3jaQmLSbibTgethbcUWXDK9PNxtIhOs
	 V2entigvS7oOgS4YQ/hwA1sJI9gh76lTD8zXpFw7HpVIDrG28elz6SfcTk7WrXLne4
	 p5tFoFwXqPwJA==
Date: Thu, 23 Apr 2026 10:31:17 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Hao Li <hao.li@linux.dev>, Alexei Starovoitov <ast@kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	"Paul E . McKenney" <paulmck@kernel.org>,
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
Message-ID: <ael2ZUl2neBh2VGa@hyeyoo>
References: <20260416091022.36823-1-harry@kernel.org>
 <214ca3ac-45b7-4131-86e5-ac134ab0bcbd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <214ca3ac-45b7-4131-86e5-ac134ab0bcbd@kernel.org>
X-Stat-Signature: i7b8ztapad54kxtzdfz7jhyrwwzrqucm
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9BC6220014
X-Rspam-User: 
X-HE-Tag: 1776907880-813036
X-HE-Meta: U2FsdGVkX184jWLk3XtsmvZ7RT+9NaOJxBqu9Ag6m+msgaSlQAuVevcNFOYCvp/okyRsSX2Ufrn9NdtlLTUEWoNMyQpPQtzsTsD1PAlbyTSakAfBHbKxry6dN7JwXWVWzpCaYcjHFE2LJWOjKXeY287yYKGudOzVX7CkJK5suZJXNj2ArO8A0FNG+xNIqAn0t09b+GBA1VNW5YMqaZVplibBzkWzsIOe74UvvPcrVpVBnG3clD1cDnzaQGNfvQ0u180FP/gu3TEcZlxQBszPdp3XYPpeTMoNopF8u7hK6QPHJFDX1GVWaHhYlXcksTYthlseiPG3loe8wo9GcHpHhgCa77kFJs06WYLUJFi/4FQi90UGjDwb+WIu7ltSEMIRQJiOM+jduDLX7RRuVsqih6QdtQGzF9RTWPVaM12MjaQ0ULkRlcjcFe/CtDSpgneP3E5GhSUXzB0+5XjdhZiA+T6UHhXsem+csJm1ec0JXgwFrOau90xVOv4outNAow50ZjDbD2b2sN3VD5Xi4ancWny7w/qvrbsYXEXKqkrKc4qb/ze83PI3oJFuLIAdRPIbmxkq35uOLLWFEvTSc2O5CUNt+cT8S/YVUN3LOgjurwb/UhRGUcLtnhaJ+l8E3VHoCs9pwa3/rbRA5rCrB38Y+a8koypevE6zSaeAly6sLgiBSTpTgQXEyLvynY18sADuNPbCJVJ1iF0Ye7QMpGX1VOoJV0P+ZdZOw2HLIZc+7YNI2KjZzLIk3+GvqTcznocvgB7urjvjYYxppoIthVKYgZhy6Gu0PrNdefnSSNWDL7Iu60mQ3cxxq7ZOWf83dYZaUvchxlpcwFeGgF12Ze9rOY4VuJu/D7tntya32NrHCgDtxj415iP+t8YcPosFCpJo3nE/x6wY+K5tiq841UQn+8ZD1cFMgv3o6rMqIlAMdPe4djGTM6U+3h3VsyrC5YYAvcdn1uvtao0M/ywEq7G
 e6NTlsd7
 TZyZFEwjNS3SYGPeSHOIwQY2en6J8YoTsKXO584rU4SCiT/FNtrlxfqjvCdgJ/uZPoyn5BTODyh3aqcUB86gwW/MTnBilVU9XX7zmrGcUkY9lHkF3sJeOnq+DIMeWdK4PvQ7YQ2K+mvfnLj0NA0ujryabaYetclxZzH7W6QA3mVT15HUdDhfixpbMXxL270Tiw4Wi5YbJCLbl4aI+wGj9iJiXKzvnMjVifo/hpfGIiw76/9KbHqa/K6qCbL5uGrmGw3muKTOFR8IDnVuZGRrP5+/R18Y186mRjAZ2Zl4ksZz/1K8=
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
> "rcu_ptr" sounds too generic to me.

to me too ;)

> Things like rcu_dereference() talk about
> "RCU-protected pointer" and it could be misleading that "rcu_ptr" has
> something to do with this.

Agreed.

> But maybe just "kvfree_rcu_head"? As IMHO It's an rcu_head specialized for
> kvfree.

I like the name better and will rename it, thanks!

-- 
Cheers,
Harry / Hyeonggon

