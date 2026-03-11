Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5E99FCC9AA
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 05:13:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88A456B0005; Wed, 11 Mar 2026 01:13:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 806F36B0089; Wed, 11 Mar 2026 01:13:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E94D6B008A; Wed, 11 Mar 2026 01:13:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 481036B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 01:13:44 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CF9B2599EF
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 05:13:43 +0000 (UTC)
X-FDA: 84532614726.28.21B72D6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id D60DC160007
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 05:13:41 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fBD8jk+A;
	spf=pass (imf08.hostedemail.com: domain of mhiramat@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mhiramat@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773206022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CodiYBsmL0ndtqHN7u6tywq9/pii3+ZsztJ5W7pc52A=;
	b=LE851Dm8yos9VRdP7hk1zMnkHgz6uvM7AeayhZZx//T96Cit+I4NfOHMfLZOabEeLdF+hV
	8N7cv7a+yvZ2LQbi+8XVb1gYcg1l0LemcYCgHwHcjBvbLHwFn26s8LOAFDNNQKfL9SexoO
	zONH9FgW8065iUVNT1yS+wLIX2Pn9ns=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773206022; a=rsa-sha256;
	cv=none;
	b=PQa2M4D9wr7dvXTWO8ZMXYacqqezupGAZOd1VW7Fm3VLltG0XqsN8PRmcY8V5K0NJrvIga
	Cyfj7xOG8f8b5dUxt+L+oUC3joUuHi8J6S45kiKBDYUop4R8EOURHHc4iE2AzVoN07Y3aH
	nZmeiFX0b7TrwD0i9U71O2OFImOlDIY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fBD8jk+A;
	spf=pass (imf08.hostedemail.com: domain of mhiramat@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mhiramat@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8E663440BC;
	Wed, 11 Mar 2026 05:13:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B290C4CEF7;
	Wed, 11 Mar 2026 05:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773206020;
	bh=28by/08L5sQfVInnpnws13wBN8rSRzXkYuFZbXIDejE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=fBD8jk+Az9XLzjQybetTno+W1ryvU+pJL+N7BKChPP4rEV9IYqgPEFF2K1MPy7V+I
	 icuIUfL/Dg5/kgC+Hmy6YXnokVmu1zBps2v+geMH037tafu9KbfbPBt55PGuheVQJI
	 z4qBbYgbztbgPszs8uOt3DWOo4BLsomiZb502AAVr8RGodlkXenJkrZoPQ7T4PM4Oz
	 vrK0XegnvMjvVzXWSmVe1LK/JeGbm1OZeYQWd07yKlzuY4gn+/WuMImks+j3fST4ms
	 212iplG27c78T1c+7zhxUp3BWeQ6jYmUF3g5aNFDkxAetR3pCSSickOn/0/x8U56nb
	 McVwjAbkgnZAA==
Date: Wed, 11 Mar 2026 14:13:32 +0900
From: Masami Hiramatsu (Google) <mhiramat@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Philipp Hahn <phahn-oss@avm.de>, amd-gfx@lists.freedesktop.org,
 apparmor@lists.ubuntu.com, bpf@vger.kernel.org, ceph-devel@vger.kernel.org,
 cocci@inria.fr, dm-devel@lists.linux.dev, dri-devel@lists.freedesktop.org,
 gfs2@lists.linux.dev, intel-gfx@lists.freedesktop.org,
 intel-wired-lan@lists.osuosl.org, iommu@lists.linux.dev,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-block@vger.kernel.org, linux-bluetooth@vger.kernel.org,
 linux-btrfs@vger.kernel.org, linux-cifs@vger.kernel.org,
 linux-clk@vger.kernel.org, linux-erofs@lists.ozlabs.org,
 linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-gpio@vger.kernel.org, linux-hyperv@vger.kernel.org,
 linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
 linux-mips@vger.kernel.org, linux-mm@kvack.org,
 linux-modules@vger.kernel.org, linux-mtd@lists.infradead.org,
 linux-nfs@vger.kernel.org, linux-omap@vger.kernel.org,
 linux-phy@lists.infradead.org, linux-pm@vger.kernel.org,
 linux-rockchip@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-scsi@vger.kernel.org, linux-sctp@vger.kernel.org,
 linux-security-module@vger.kernel.org, linux-sh@vger.kernel.org,
 linux-sound@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
 linux-trace-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
 linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
 ntfs3@lists.linux.dev, samba-technical@lists.samba.org,
 sched-ext@lists.linux.dev, target-devel@vger.kernel.org,
 tipc-discussion@lists.sourceforge.net, v9fs@lists.linux.dev, Masami
 Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH 15/61] trace: Prefer IS_ERR_OR_NULL over manual NULL
 check
Message-Id: <20260311141332.b611237d36b61b2409e66cb3@kernel.org>
In-Reply-To: <20260310100750.303af303@gandalf.local.home>
References: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de>
	<20260310-b4-is_err_or_null-v1-15-bd63b656022d@avm.de>
	<20260310100750.303af303@gandalf.local.home>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D60DC160007
X-Stat-Signature: coeokfxki9xpe45dtakfpcy1sedbxb6g
X-HE-Tag: 1773206021-167411
X-HE-Meta: U2FsdGVkX19aTiW6ortyiiUbv/aPoDFsiLZajPSrYneYSxK858zUncIA9RJNo4v06ee+n9LcpCcjMG3fBumfaLqPRjYVtMU5g5FnsczVICMk4EVSVS2zBeS+CccU9P6X3npVH3YNCrfwwoPOjLtQABBWZ23Zhp2rq1A6DAjx7y47H5Ct0N7QTOekB07z+ZjPKQUCr8UijuuZeQs20+Qmul289CTlQ5EVIHHsh5A86rCllDpAsOmGxuAbTHIHjuIyiDnUm51LyX6xGnFpyGc787RTsL3X3ZdsPmu8ovSO1bgJfX2qKv3NcoDUEoC71L8uL6xhYEFRrvAlP9ONNAyrd+qYdeJpWdvZatOYLaqqmOYOmE7ArGpPk/3gH5Sc87gtIXcwcVbGddFoFxBJ6mk7nEgNKUT0jgXabxwVThIKM2O7j8pnInuDDVgIZCUnVUjtOEqLDa2iJmNNx1GPkbs1OIyO+FvZ1I2VtKyHYD3R5liVcsb+3cKLIg1qeBaxXVVI5R9Zv745NYSxaoNOBLY8N45UzdHiLcs9L7ItvaZ1clZhnBIkD4lqm0i7L8Kg0tDP+g8AkfhpgTMyznae8vL1aC6cSkVP6xG1Qx4YGtWMCQwJvXcsWKYoOB0c9Szwfpqd6D2hIZP1gyGVsaCp8fNPqBsl8ijLcwFnjvteoIrd3+ze58kxT2XYYhRm6ye9SlsBp3du2cX03ct84JHyJeL8+j/FMe8XJTQ980j7dAT6E672WSQM23h65WszvWxwvxCq+cH8YxgQv6XTdVb5GeDvncVdsC65Eep4rHuH7/GLB/kALr7uEBKrN4tA4zefM+AMcuIDTArN+pWj0qDS3u1yHqfnekJ4UPx9jsWXn4qnVmCABTB91L4GrZk44lYe/gJThiuZMRVhAAzUIa0/50bm7jUJP821qob5TVXlcOQAqUipnmrbYlR5mCV2IVCHQ15WGRsXwec4zSnHsnDb8ST
 ciGN7T43
 I7LyIqTitdsLoq7TlkKgeITfFJxouTno4zH8kGPdc3Vsq+AeoBuDtzUsg57KaaYpBidcTvpiJMYRITzWt01xduy6CQm1t7uM9GCR5UW1A3FUuT6x4pmgzYkV9dJDKj/QcT3L9lJZBn87jAFmnZgs79ewNQsnZQTSqFm7Jak173PkC9ZqLh4CUPbM0Woql+NKOzLjAcoiTWQ1FUOmMQPmC8EBUqnffiCFqlhO5kdIwyxai4OcdIrW0rW6O6VpN54OyStYTAfHiH7uJMkV0UEbzEdHgPy3Tc1rGo9huZT8jN9aIuUbMISSKil7RW1Qsd73GG/G9mukuL9iXqAlosp/tU0FhHRP4FT+1WdjI3/uuM7UjztvZGBDxqLHKUT7T+/k4wwrTS8F1h2pf/+en6ptip/QjnZ+FK9vyt5s17dpUMwjctTIs3yOyE2gIsR9vnqA3TSYHHwW9kL8utw8OR9FzfUAr4Uc8hAgDPFgC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 10 Mar 2026 10:07:50 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Tue, 10 Mar 2026 12:48:41 +0100
> Philipp Hahn <phahn-oss@avm.de> wrote:
> 
> > Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
> > check.
> 
> Why?
> 
> > 
> > Change generated with coccinelle.
> > 
> > To: Steven Rostedt <rostedt@goodmis.org>
> > To: Masami Hiramatsu <mhiramat@kernel.org>
> > To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> > Cc: linux-kernel@vger.kernel.org
> > Cc: linux-trace-kernel@vger.kernel.org
> > Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
> > ---
> >  kernel/trace/fprobe.c                | 2 +-
> >  kernel/trace/kprobe_event_gen_test.c | 2 +-
> >  kernel/trace/trace_events_hist.c     | 2 +-
> >  3 files changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/kernel/trace/fprobe.c b/kernel/trace/fprobe.c
> > index dcadf1d23b8a31f571392d0c49cbd22df1716b4f..a94ce810d83b90f55d1178a9bd29c78fd068df4c 100644
> > --- a/kernel/trace/fprobe.c
> > +++ b/kernel/trace/fprobe.c
> > @@ -607,7 +607,7 @@ static int fprobe_module_callback(struct notifier_block *nb,
> >  	do {
> >  		rhashtable_walk_start(&iter);
> >  
> > -		while ((node = rhashtable_walk_next(&iter)) && !IS_ERR(node))
> > +		while (!IS_ERR_OR_NULL((node = rhashtable_walk_next(&iter))))
> 
> Ug, No!
> 
> That looks so much worse than the original.

Hmm, now IS_ERR_OR_NULL() is an inline function, so it is safe.
But if you want to use IS_ERR_OR_NULL() here, it will be better something like

node = rhashtable_walk_next(&iter);
while (!IS_ERR_OR_NULL(node)) {
	fprobe_remove_node_in_module(mod, node, &alist);
	node = rhashtable_walk_next(&iter);
}

Thanks,

> 
> -- Steve
> 
> >  			fprobe_remove_node_in_module(mod, node, &alist);
> >  
> >  		rhashtable_walk_stop(&iter);
> > diff --git a/kernel/trace/kprobe_event_gen_test.c b/kernel/trace/kprobe_event_gen_test.c
> > index 5a4b722b50451bfdee42769a6d3be39c055690d1..a1735ca273f0b756aa1fcfcdab30ddad9bc51c5f 100644
> > --- a/kernel/trace/kprobe_event_gen_test.c
> > +++ b/kernel/trace/kprobe_event_gen_test.c
> > @@ -75,7 +75,7 @@ static struct trace_event_file *gen_kretprobe_test;
> >  
> >  static bool trace_event_file_is_valid(struct trace_event_file *input)
> >  {
> > -	return input && !IS_ERR(input);
> > +	return !IS_ERR_OR_NULL(input);
> >  }
> >  
> >  /*
> > diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
> > index 73ea180cad555898693e92ee397a1c9493c7c167..59df215e1dfd9349eca1c0823ed709ec7285f766 100644
> > --- a/kernel/trace/trace_events_hist.c
> > +++ b/kernel/trace/trace_events_hist.c
> > @@ -3973,7 +3973,7 @@ trace_action_create_field_var(struct hist_trigger_data *hist_data,
> >  	 */
> >  	field_var = create_target_field_var(hist_data, system, event, var);
> >  
> > -	if (field_var && !IS_ERR(field_var)) {
> > +	if (!IS_ERR_OR_NULL(field_var)) {
> >  		save_field_var(hist_data, field_var);
> >  		hist_field = field_var->var;
> >  	} else {
> > 
> 


-- 
Masami Hiramatsu (Google) <mhiramat@kernel.org>

