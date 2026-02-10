Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8E59EA3F04
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 05:20:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E50116B0005; Tue, 10 Feb 2026 00:20:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFE316B0088; Tue, 10 Feb 2026 00:20:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D00886B0089; Tue, 10 Feb 2026 00:20:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C1D006B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 00:20:40 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5A5A513A743
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 05:20:40 +0000 (UTC)
X-FDA: 84427397040.15.1ECA3F4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id B255A20010
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 05:20:38 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=w+MgGOcf;
	spf=pass (imf03.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770700838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gk8iPKgOFqUhCq0ztG7CQ5PG/+suwYitJCiQDuMf3AU=;
	b=dREb7phoGGZ1CU8FoeiTAqr59+gUMdRq0e1CY1Sch+TQJnpl+2N/jUXKu6P6BzImKqdJOW
	9vCs326psR7WFe0Amb7Nr9x4Y2DIuw1uci3uZPgiNtH2qgdbAmEx9lJGEgH4rqV18ImOyO
	riRbig3UkUZGruC+t9Ep6cwkpK8MR5M=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=w+MgGOcf;
	spf=pass (imf03.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770700838; a=rsa-sha256;
	cv=none;
	b=kbE68CQ/WQbIMBSa5PtCfXKEjyh8N1ODKsprzPpfBo6OH/lhFFeF0P1n8LzYFZCmJcOudR
	M6YrLBTxDOhbvrav0HyGBuXY2DU3WQjVeIWvMv6pmjis8CIBD8D4NvADvyjmqO79NXIIin
	5fKpkAiTMcyg2gAq4tdrSEcJ49cnngU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E986D60008;
	Tue, 10 Feb 2026 05:20:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 471BBC116C6;
	Tue, 10 Feb 2026 05:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770700837;
	bh=j6m+QaLyoFfdem09Nnk7STgk0ODlJPaEKwgQiyH2Paw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=w+MgGOcfl8CJJQTgJN0zR8wMpZ5lgV8ZWlk5Y9JI59jZ8w/QszoW0mPaoxwiEFxJm
	 4LmDcTTevfVgAFYP3TyfLnct68nwlVWJy+hl7CG3QtNo0ASUV/t7gcT/0Dr3XS+tgu
	 J9ZjZ1U3M8BAfXdRoRbgm47REledk8n/CrFFY16k=
Date: Tue, 10 Feb 2026 06:20:34 +0100
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Cc: "slava@dubeyko.com" <slava@dubeyko.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [RFC PATCH v1 1/4] ml-lib: Introduce Machine Learning (ML)
 library declarations
Message-ID: <2026021005-tacky-pentagon-aab1@gregkh>
References: <20260206191136.2609767-1-slava@dubeyko.com>
 <20260206191136.2609767-2-slava@dubeyko.com>
 <2026020756-remarry-declared-9187@gregkh>
 <46449ed46d60767bd13b980e5ab63faf4364f718.camel@ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46449ed46d60767bd13b980e5ab63faf4364f718.camel@ibm.com>
X-Rspamd-Server: rspam12
X-Stat-Signature: 4koibnm95a8sb7xuzhixzpyqfh1h78a3
X-Rspamd-Queue-Id: B255A20010
X-Rspam-User: 
X-HE-Tag: 1770700838-684736
X-HE-Meta: U2FsdGVkX1/hX6N+qNSMqAvV4GQrwfqm6h9m5iyxPE5ioc7oa9SHvt1tF9DwZd9nW0eWmrVlnEqHe+BFBLt6nH/o+SkSVf5t4xOviyDzOvkhot7ahe7t9GX/oc3jHMNQH8qJMyvXlJImja1P9gOhB+cJRQGugph4fJ/x4LA3EOCxLxW4zPN9A/xCQmlt5K+9uArTAyJuRobAD81LaUdyStY0L8W4QjCujJpmKe70XkYdpFsLc+onUAgBMI8lbxNCQzvYhYs9CsJb9nizfT9QpozvlrLGnsE+TjDdizNM+JY9V5opaEG2a3DY0NVHbss/+rkI13EOtHVAz0gn+CZWWPp71o48BKE2HU84jiCmoiSViDMgSALCJk/aUlv1KvLOou+qaaazGQPJgrklVGbvN6oW9ons7gXA+i1aGTAywM7eyp6GaKXgKIo3WkbLA0dE8I90xv6u1c3dF3AYGJc5+zFzGH5x+6PVB0sAwOPod8Wy3uGGRgjl+HB2iW8nbgTOYg815OMybtESZk+274fah/1aCVFmpStuUO1SySoAHs7K6w9dLncgUqUr8OR4uVm1F4CXp0cB0HNZczn9xY9ope75+r1+C5HdzEFm5RQxxH+zinWJZnFSRw5SpQTP3OGh3HtBhjgzZKgoIGBZIAyf5BbLhainI9AFJyiQsPz7326m7LXn3yfpiv5++8UjGVwOc1x5D/bpZwlckLmXllWzMg0smz8uKrnlvEAlaiaSoORZXLiXjLZ6ZpAhKrSdhV0jzADfZY4XRkVyrHb1s5y1WpN2dYF1e8RDcAU6lPD/88v2s06c/djzyHrQuRT0jk96yQC8fOhl5OqDIuj8iwgEELnCLa9UAVBechBSiybK4CT+UJ1nvugvoNIG6dtJPJ5bUMec76e9mz4Ry7slOtUXvEpLLhyRiBaJ/hOK0Z39VqH+1rwSBiSxxQJfxxJThCtyuIwBJ5pEvp4vEilYR/y
 npcMzGF3
 apfYmXjsqPpsZh04Hwn6H11b9FcvaxOxEgsWJpKlpDc3UNZM75S+VjEFleRe5REoHKWxKM4/CSc2GZZpCjjoazDm92uXGhXRlskSGhMGT17zsUCAheOWUu3mZ+q/o4rpoaEO74UBt282nfzRC98HV6Ff+mavtPBwB3nH56FOn3C4p+teNa0vPfwtnrSh/JwOIOsd6SBc4o4Rc70Q/AeUYn2/+DFRxSz9mchBJaRsjjoRQTPPwaiW0bHqtKR5uqy2CBtjMV0vpFYfFCqv+gKnOlL3kMgHujlvbiH2jHYAWrdfeus3pyGNOJBezjQty1aLDl3dX5GArx8+iclMVo1ZNilyW8SqCJYFqhEisISdy5T/c/pUJPaxVdX6++EZKEIzfx3QsHcoAviIWtwc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 09, 2026 at 08:48:17PM +0000, Viacheslav Dubeyko wrote:
> On Sat, 2026-02-07 at 16:52 +0100, Greg KH wrote:
> > On Fri, Feb 06, 2026 at 11:11:33AM -0800, Viacheslav Dubeyko wrote:
> > > + * @kobj: /sys/<subsystem>/<ml_model>/ ML model object
> > > + * @kobj_unregister: completion state for <ml_model> kernel object
> > > + */
> > > +struct ml_lib_model {
> > > +	atomic_t mode;
> > > +	atomic_t state;
> > > +	const char *subsystem_name;
> > > +	const char *model_name;
> > > +
> > > +	struct ml_lib_subsystem *parent;
> > > +
> > > +	spinlock_t parent_state_lock;
> > > +	struct ml_lib_subsystem_state * __rcu parent_state;
> > > +
> > > +	spinlock_t options_lock;
> > > +	struct ml_lib_model_options * __rcu options;
> > > +
> > > +	spinlock_t dataset_lock;
> > > +	struct ml_lib_dataset * __rcu dataset;
> > > +
> > > +	struct ml_lib_model_operations *model_ops;
> > > +	struct ml_lib_subsystem_state_operations *system_state_ops;
> > > +	struct ml_lib_dataset_operations *dataset_ops;
> > > +	struct ml_lib_request_config_operations *request_config_ops;
> > > +
> > > +	/* /sys/<subsystem>/<ml_model>/ */
> > > +	struct kobject kobj;
> > > +	struct completion kobj_unregister;
> > > +};
> > 
> > Do NOT abuse sysfs for something like this.  Please make your own
> > filesystem or char device or something else, but this is not what sysfs
> > is for at all, sorry.
> > 
> 
> Currently, sysfs entry is used for sending commands (start, stop,
> prepare_dataset, discard_dataset) from user-space on the kernel-space side. And
> the intention of using sysfs entries is the export information about kernel
> subsystem and exchanging by commands and notifications between user-space and
> kernel-space sides. Do you mean that it is wrong using of sysfs? Have I
> misunderstood your point?

Yes, this is NOT the correct use of sysfs, do NOT use it for an api like
this at all.  Use the correct ones instead.

thanks,

greg k-h

