Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E12BEA4E20
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 15:18:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 527496B008A; Mon,  2 Mar 2026 10:18:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F55A6B0096; Mon,  2 Mar 2026 10:18:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 401946B0099; Mon,  2 Mar 2026 10:18:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2B9356B008A
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 10:18:54 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C2D9F88CF7
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:18:53 +0000 (UTC)
X-FDA: 84501480546.16.E1343FF
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf28.hostedemail.com (Postfix) with ESMTP id ECF4CC0012
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:18:51 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=oXpdMlRz;
	spf=pass (imf28.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772464732;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BFYzZEBixlS+zcZl7LsuEKBEMzuKJceTVNM40UE/LP8=;
	b=jwwBJdJLg5ZRlj/3KOhS+KWh+x+CdMnk9BqLEUbp0/RbrBIcw5GlsEqPHOtbqoKawPmzLu
	kWrV7PkdDRecrH7vozVXkMjbFxlO7ydFO/MXllmcPCs+YsHGu8me4R+1ZqFuvXDdx9opji
	UZ26vN2d78/azKv80XZy4U3Hb2jUFjo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=oXpdMlRz;
	spf=pass (imf28.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772464732; a=rsa-sha256;
	cv=none;
	b=xgIlZrMTlM832raswPeF84CB331kQn83QOmrAqHqh8X68WXhSifcUD9kU7plw5UElQT4Th
	Ue/f1BNiM6UcC1UCya3ySBfEEVBPImJcRw1xE4/1+uT+WNwx5DDQylU+PRKzNefJUWO8FL
	f5HwwMnUS1EHF5VCNwVi/Zj1kbLI8WE=
Received: from shell.ilvokhin.com (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id A32A2B3085;
	Mon, 02 Mar 2026 15:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1772464730;
	bh=BFYzZEBixlS+zcZl7LsuEKBEMzuKJceTVNM40UE/LP8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oXpdMlRzh3dhWg4L7e1wNlTox7fVWTR42Pud1whiidbKQmr2FQfBFHS0BOCTKSpBe
	 R2DIdS6d5ws7XChDY9B/cUn27jM6mwloRl+Pgb1LAhHjBvlEMht6wQWyutSDnREvtR
	 IOe0L9Ulmzror287UzM5h85fSgdc4Gtg+B8D00DE=
Date: Mon, 2 Mar 2026 15:18:45 +0000
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Pavel Machek <pavel@kernel.org>, Len Brown <lenb@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Oscar Salvador <osalvador@suse.de>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Shakeel Butt <shakeel.butt@linux.dev>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
	linux-pm@vger.kernel.org
Subject: Re: [PATCH v4 5/5] mm: add tracepoints for zone lock
Message-ID: <aaWqVZ4t5AaJfih7@shell.ilvokhin.com>
References: <cover.1772206930.git.d@ilvokhin.com>
 <ae145fe890f028409f727b4921904b547346fa0b.1772206930.git.d@ilvokhin.com>
 <20260227144649.3dbff742@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260227144649.3dbff742@gandalf.local.home>
X-Rspamd-Queue-Id: ECF4CC0012
X-Stat-Signature: cjuwq4xij6p7kd7pg6guoc97r4o5gyxp
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772464731-454506
X-HE-Meta: U2FsdGVkX1+UbbTMMNujzaI8O8DuHbt/QmcVIbckLnQWeDyLUu8O2ViGFxWQ+BsxNV4Ql43sBFHshRoTJcTmFMPtI95zH5HCoLOfE/ZoiS/6Rd90/XwQGRNcLEyYQpQuUjKiJ0Ljj1MxD5EORSM7bccPhV+LHfNMqfSO41WX9rjk1uCDByCeuYalPkhgd5E0Me12NMC113AtGpdZCk08/NoGGEBNuiJteXv0tXduyo+qg1mhxlFx49Kz5Di5oynAc5ap6JsHpOCMs3FwLfgIvT2BrTga9+Nsdqjerlgh4+P/cazHRzJaUW8TI1G3Uewww1zWSb8xeSMqLIZV5v6NKZc7/24K6YjIX4B2IIpV/TUYwuJ7jLOHv2tzMsgeekeCGZFGanzqRd6Y2eXDnB12XHyVogDzGVsIoPfY3swDquFewLsidIuF750D7g8jp/pqv6jgPokbfUlQYbYd/5NY/THQesWHpC2/zIKmwy4Yrzj1POsZQqFIhWHPuO6TfqelrA03Q5JMKUdUtDtvCYJ/yT8XYjIrNMlDhbZcV6b4tDpAkAVzlqaSDCXf8pErKdcx4hsaUArJUIYlNOeABIPnrA/WZxYyaI0v25ZNWq0QM9PEh3QwV0OYhYv2q+PMPBn6DwbH9Ri1b7EssUAIGmX6rrTMuzH0pyoNHH1+bUpY8gNkO3NgtyjLXQpsiLAKhbPyaAlgyqZeaoLap32+NRQVsGlC91/Srz3NaqWkOIQmLG3doPtOppGYEVldws8hd5Q3MlibA7ld6IhGCJclgAVk/RGrIpy9FWgmrrF7K9L8Ris6f/K3FnH4gJsItsW4UXWJvbtsWaRvE/I2cQCSNb43KgyYl9+Dzdo4kX1p86MrNvfTs+9LGb+u9BrqaF2x9Vx+odgyi5NHBb3OxS28Ixaj5ZTCog3BqOUcfdTl29VjBvUC3GYedcYd9np+82Kgdld7qqbm9yANFKEE6PG8M5F
 HhydXPPC
 rEPbHI4CErtRhq9WTg1ZEeYakGfQfPkXPPccLVMMfv2dBeNVtwTS+sp/wZqaFX9+wD4SNz/jVMb2SNoYMIIoi+3fpEn5u94nwMHN8JfyAw+AhQJlBQjcrUc2dev+LdHzaiLbFL/vhOnTUTc6RHehMRvQSRHEEMBDWs5Vt9aj84BSokGSPXgicry6ml9wjzPsBnxcFPN7b8M3zCMEHYiIdtNSUieZ2pmbUm3feNosjYZOQ+S4LoK6FTTmQdcJjrsFZcMCfPz80AAfgFVNq0XjVvhy7RHCoix82XWxh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 27, 2026 at 02:46:49PM -0500, Steven Rostedt wrote:
> On Fri, 27 Feb 2026 16:00:27 +0000
> Dmitry Ilvokhin <d@ilvokhin.com> wrote:
> 
> >  static inline void zone_lock_init(struct zone *zone)
> >  {
> > @@ -12,26 +59,41 @@ static inline void zone_lock_init(struct zone *zone)
> >  
> >  #define zone_lock_irqsave(zone, flags)				\
> >  do {								\
> > +	bool success = true;					\
> > +								\
> > +	__zone_lock_trace_start_locking(zone);			\
> >  	spin_lock_irqsave(&(zone)->_lock, flags);		\
> > +	__zone_lock_trace_acquire_returned(zone, success);	\
> 
> Why the "success" variable and not just:
> 
> 	__zone_lock_trace_acquire_returned(zone, true);
> 
>  ?

Good point, passing true directly is cleaner. Happy to respin if needed.

