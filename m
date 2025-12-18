Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34E36D6E2C7
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 17:28:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9ACEA6B0088; Thu, 18 Dec 2025 12:28:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 977636B0089; Thu, 18 Dec 2025 12:28:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88D9D6B008A; Thu, 18 Dec 2025 12:28:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7837A6B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 12:28:06 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 46C87C0158
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 17:28:06 +0000 (UTC)
X-FDA: 84233274972.06.ADDBE0F
Received: from relay.hostedemail.com (unirelay02 [10.200.18.65])
	by imf24.hostedemail.com (Postfix) with ESMTP id 897F6180008
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 17:28:04 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766078884; a=rsa-sha256;
	cv=none;
	b=wcdOJRvFlryq2YRum+IqFNe/1QUYrmqWTy3t+qdfvsPBNJUWWo8YTI53X9cf0IzjfL4qon
	xaMRSrDnv4ROWJDFfi1eyqimAW9lUUwstcjjKAeeqAPctmdyEIvU0RQVA/+sXkrtVII8fm
	GCKeyIimN8PzsPwEXPipqRLDV2Ne59Q=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766078884;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TCIPVPcHHTGUtadi4vzO8txEIZJjTRKxfD33aP4p6v0=;
	b=KE9izCs9geIR+scIKBqDgUSxB0feMCoCuKAAztchO+sP5QpyclfAIzpAiu/eFfvX18Ni8L
	6Z8vL4v+VNOIB1+f8nW7QL80R/xzxwez/bbnyVhPv7ASH1SjRFmBzJRPvsdCn68jdDqVLV
	ciecSLa/2MJtJLIbDUl2yr+dLbcHawU=
Received: from omf02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5E7CB13862C;
	Thu, 18 Dec 2025 17:28:03 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf02.hostedemail.com (Postfix) with ESMTPA id 54C1480009;
	Thu, 18 Dec 2025 17:28:01 +0000 (UTC)
Date: Thu, 18 Dec 2025 12:29:39 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>, Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, damon@lists.linux.dev,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH 12/12] mm/damon/core: add trace point for damos stat per
 apply interval
Message-ID: <20251218122939.57963cd1@gandalf.local.home>
In-Reply-To: <20251217182915.5284d66b58ac7b744b8dcf7f@linux-foundation.org>
References: <20251217174851.28e7c4e5@gandalf.local.home>
	<20251217235219.2750-1-sj@kernel.org>
	<20251217182915.5284d66b58ac7b744b8dcf7f@linux-foundation.org>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX18LqqMBRgo7b7noeiaKz6NeF6w2KmXGUdM=
X-HE-Meta: U2FsdGVkX18iZGF2g2mjWYfsz1mg6gAMGDTeGr7Hsp3vnmWhVpznh9bseXMrHQAyqOPNqYiM6xtd0/K3q2t/gV4U8v784Q+/xMFiDaVeuFGb/CFF67yLKAcDG1Ldu8q24u+KA99Fyno9AVE2dfUEI4+mD2LxHGm0TjlLVZODWKMRJd+MdlYWvs80EOuFEFPl4JT4fEDJeWAxirNk4g95dVwyxU2LNwEfTBJVq+roTMZinhWscIWVbxj1OQP8SRzoq0HoZF7P97TrOXQ5TVbFxM4biT/PAZpDZMFCauoVsRRCZRC3pO/ZCKMBFbXenDnXOEqSP1VTISCbP4hhVmpMFUMh7ns4N+mxc4QVE8Hn3w1Sz9RbkZ1gAC0LKI7rS7dj
X-Rspam-User: 
X-HE-Tag-Orig: 1766078881-76418
X-Rspamd-Queue-Id: 897F6180008
X-Rspamd-Server: rspam10
X-Stat-Signature: 6payrkwug7d5baq3ayi8txdc8p6zpnfs
X-HE-Tag: 1766078884-810200
X-HE-Meta: U2FsdGVkX18CcthdyTxN7ho+HrPrES1EBFu73K2AfrZvWFy4NzeX1scI1H4PWkkesFoy9xCgqs+Tb6wPHFKLvudyBYt2AGDai4ZJOFt9smPBNZPZq/EdEg6R5KlvzSneWapdZQA29CMcbcyPy3x9ExJwXYS4gPDYHnrd2czJdqPVcBqDT+RVXJG1/N1CytMgRQdotOXp5KdosphLgET61dxpHhR2kSJMRUQGdAntEuripuvhw8d+0LngI/VUxcWcKW6sv6yvrt2QKexDcbtGa0tmPmbN+8h4isVuy7YsQokowWnK8z/j3QNKMX/KULoqsPGiq/I7DZDEOC0XUra+EYB1KozfxYZKxJ/Ja+KMQXZkreFKTd8imHWhN/J/Y56vaicHUWjnTlgx0o8NfSvhPQOj8MM6M/WCXq8MshzMzkXgVh1BFniQSDUrrY3QOsWlpzDfAX82Q9eMXk8xKFI1+HAOPdMvgYmoJtGSNQ9YMA0e8PXG134xcdi1blMSA2OqHMvSELsNwREVUtSPec3QJdX3fn3lgRu1ZQtMkAbYYzjLHp5pvjQIwKnjO78kPH7SibObBOZ6+Da/Ycl5A2sT0dsT3fOQPrBxyeK3kvvtb6UmxXEDXY1G5phLhNaioqb+9qd3vIq39q+sXWpmXX9V8KS2UKfprE9qugJttGML9H0qoFFxbPKKPSpw25jB4Wbg++OT87dihChczhv6JusTjq2HHMHD3utysqn49JZpa1ofgS3zbBbWaTiHkFiKuPn6lrCZd0DxIh0w6qTtuAHcBlTlPkGkx8o1m5juuMXqV5RmAWdUYUakelTJ4MlAVZ5jyaTMeLsNaR5ANSdQObzaYTvGtuGF77egIlNXo7KyP+ZuPtdu4vjdgu3UhK8oc0s8NZqC3bohaz9GWyq7Tw8Wkq0txmUGAAu3E5phmVpQ6U5TJd8UjRKdkUon9uGr5gFeonQYm8yCtArHilYpAh9
 JtdE/mB1
 cblnwB8jWtu62NmU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 17 Dec 2025 18:29:15 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> > > Nit, but it's been stated that strings should not be broken up because of
> > > the column limit.  
> 
> screw the rules

Heh.

> 
> > --- a/include/trace/events/damon.h
> > +++ b/include/trace/events/damon.h
> > @@ -40,9 +40,7 @@ TRACE_EVENT(damos_stat_after_apply_interval,
> >  		__entry->nr_snapshots = stat->nr_snapshots;
> >  	),
> >  
> > -	TP_printk("ctx_idx=%u scheme_idx=%u nr_tried=%lu sz_tried=%lu "
> > -			"nr_applied=%lu sz_tried=%lu sz_ops_filter_passed=%lu "
> > -			"qt_exceeds=%lu nr_snapshots=%lu",
> > +	TP_printk("ctx_idx=%u scheme_idx=%u nr_tried=%lu sz_tried=%lu nr_applied=%lu sz_tried=%lu sz_ops_filter_passed=%lu qt_exceeds=%lu nr_snapshots=%lu",
> >  			__entry->context_idx, __entry->scheme_idx,
> >  			__entry->nr_tried, __entry->sz_tried,
> >  			__entry->nr_applied, __entry->sz_applied,  
> 
> because that's just crazy.  Let's use some judgment here!

Does it really matter? Actually, I prefer this way because it better shows
where the format ends and the parameters start. I care more about the
parameters than the format string, except to look for each "%*" value.

-- Steve

