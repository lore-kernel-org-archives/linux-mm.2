Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14D84EEC2AB
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 23:30:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72FD26B0005; Mon, 23 Feb 2026 18:30:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DDDB6B0089; Mon, 23 Feb 2026 18:30:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E0406B008A; Mon, 23 Feb 2026 18:30:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 496D46B0005
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 18:30:24 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EA993B83EF
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 23:30:23 +0000 (UTC)
X-FDA: 84477317526.11.648A155
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1A3334000E
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 23:30:21 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XQplAEaz;
	spf=pass (imf11.hostedemail.com: domain of mhiramat@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mhiramat@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771889422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ye756R42gxexSJRqGTZDTSp1gOBoqFlZTvzzC7NQ+/o=;
	b=3+58sMBdaiLhKazEP619f77NVdmM9BmC9LfUyjZgTezSvCGUw6JzJBeqxAqBYyu9Dr31aO
	qRHdxHhpWIc3B4mRlopnHuRuhROvqMT19ayuRth8fOa51V5+BlqLih6IRPzCNBgo59bsiC
	9wJgeYuybvoP9f0ZHd+DQ5ZNSfwxXd4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771889422; a=rsa-sha256;
	cv=none;
	b=6plSgZfTE2NGMvayIsQfoaS1cvIoRoVxJNGR7YGnkwqZ72AyA/tbABnqz0LMOZCUYGjnRX
	Umko1tufp9vxqhCWM3eXMSCO9hJJOufnv4eztWEmVQ2EgfQOB02049QMkllQN609x1FN1c
	q2KzLMca9TDlq/d4ps7GUGK+YrU+jJs=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XQplAEaz;
	spf=pass (imf11.hostedemail.com: domain of mhiramat@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mhiramat@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D646D43B27;
	Mon, 23 Feb 2026 23:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A74EC116C6;
	Mon, 23 Feb 2026 23:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771889420;
	bh=Glie2dDdb0rtYRRJaB/UrvAAGXrFPRVG05iXdt9Zf5g=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=XQplAEaznmMrCJ6SgkIq5wf0WtoJXumBiFEkgJe3OJQ3oqPctce0aW2nZYm4W0EV9
	 EVEO6T6DZvaJkJgtRoQyey8sILh+2X1ppdtZjMdrzAGFlgVw5d/v3kZMlYTHDgsN+p
	 e8XlPGTWv/0KH1oAVE/w9LK0MVoGRmZer55PopAVjX7qKAqIHUVX2QEaYZXvWA6hb3
	 LGby9WFIxqBZGFQxusZvD7q4PWlHUViAjzwCThkhysUMWQ2dJMEPFGZAw6T2f3z+o1
	 XLiPlOrX5K+2qxV3cSreRHlukrKItI+ujzkNpCxKnQDEVXgfm/L3e3nH6lJi7uhNqu
	 PUuFrnPj9xacQ==
Date: Tue, 24 Feb 2026 08:30:14 +0900
From: Masami Hiramatsu (Google) <mhiramat@kernel.org>
To: Thomas Ballasi <tballasi@linux.microsoft.com>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, david@kernel.org,
 hannes@cmpxchg.org, linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
 lorenzo.stoakes@oracle.com, mhiramat@kernel.org, mhocko@kernel.org,
 rostedt@goodmis.org, shakeel.butt@linux.dev, weixugc@google.com,
 yuanchu@google.com, zhengqi.arch@bytedance.com
Subject: Re: [PATCH v7 3/3] mm: vmscan: add PIDs to vmscan tracepoints
Message-Id: <20260224083014.66bf222ffd81a3ebaa57a0e0@kernel.org>
In-Reply-To: <20260223171544.4750-4-tballasi@linux.microsoft.com>
References: <20260213181537.54350-1-tballasi@linux.microsoft.com>
	<20260223171544.4750-1-tballasi@linux.microsoft.com>
	<20260223171544.4750-4-tballasi@linux.microsoft.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Stat-Signature: gi71s7b1fbusy14cr8wdh38arsfy1pr1
X-Rspamd-Queue-Id: 1A3334000E
X-Rspam-User: 
X-HE-Tag: 1771889421-553515
X-HE-Meta: U2FsdGVkX1+/x6WQ3+MunQR/VSJ3FS9yJPaztuT3lCO9hMvndzr8/9GiO9F4hbe6KSi85qmir8GO79Di/kBLG0cfmygmwvNbgQsTgkI/o+KOs0FPMqa9yHlspaFKv/CICU/nXcpcpYyP1buaMfbaPqkf9/O8cgXXOA52v3+OJD795KoU4SbpK7w0gcoZs6w0kFf6k7lLoi+nxDSkuJgZzbEfbQ7vAsqxorficZQnXw5HRrxaW8MafV/94Frp15MX+bv3M+v8GWB5DBWh40ZJRKE4NeozKfCkjVynKQBAcn55PQZp1aiPeUaI10Zp4htVVdpXwcLyJoWGq2HlHr6fjX378B2DT+h+HDm+4c4una1IS9Ub/p+vA6gung4HJygO9PFRDGQUjiG395PEFFWED1SJcF47mtuQYi3S44fBrt8ycomaka4VApXbOUtzwOyPqOsEBgssbbLDaiVwhJORWe2qJzlbdENsuz0kVWbWiEtVZv152nlHJr8b2DDEUepWVymc/ejHx1MS6I+fO6JTvQdaURJKpsN9cU32BGz5IO3gQqDlr0koUrhgOr41+FigkxSQ5BEjS5LYr1lME/rseX+csui9yzmrdi48B4F0Vxv/JQelj4qMnanUX1ZnLjRVR7/0C1CjdamByYyLXXKEkrneZzyQe3d2JkFtb3w5rJEgLsvTpRZjHMOyWCTFwKs30cArZqpgjMilTEctQNn77eaZRwMvvlEQTN7MbfUN/DAokoU39yc2hIw4wK4A+25YfeHzXF6Io0A45+FpTszCga7+m2HtcjO77OTXa/NIXO3W3gI/k3NYTtFIiynKD2o++f8W5BRGoRLYEFkMDQdmp+oPMekY6B7tF7HvUF8eI8x571Bfl+4KTZj2Cko4gVwFLZQ3pYJzDQd+Ou4LA8g57mi6x+SkO80IftUEuIS+e+FgwZN8H6WgaHxvM1PL8jnfknbf5zKUPH+ROLPG72P
 g92bMMD8
 bxOAK0c7lMa8NyP0ve6DOAzYdEbey7xK89gOhHC2kZHa6iKVLuJ2Qpcwl9elXm4RIyT6NaJNSsWQ9LBMlYGOenIKefDxpgfQnDP4lRoCzEhJvXiVG9pgGc5ZQLh42OdH2aDAc+Sok0JA3dbnZMhZfHJNiahk5oaNAjOG5aFiYNxtMNeeAAlzDio1ftl324sY407kl5EFajWdPakE+0h6MaXAVTFi6DzppPMCuBaYTu27Bao8ZFN5x9eMo7Oewd+aEJz3D1pS10+RXfmkAOq/m9/zusu4hH86E45NzmaUMQB7A638=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Mon, 23 Feb 2026 09:15:44 -0800
Thomas Ballasi <tballasi@linux.microsoft.com> wrote:

> The changes aims at adding additionnal tracepoints variables to help
> debuggers attribute them to specific processes.
> 
> The PID field uses in_task() to reliably detect when we're in process
> context and can safely access current->pid.  When not in process
> context (such as in interrupt or in an asynchronous RCU context), the
> field is set to -1 as a sentinel value.
> 
> Signed-off-by: Thomas Ballasi <tballasi@linux.microsoft.com>
> ---
>  include/trace/events/vmscan.h | 34 +++++++++++++++++++++++++---------
>  1 file changed, 25 insertions(+), 9 deletions(-)
> 
> diff --git a/include/trace/events/vmscan.h b/include/trace/events/vmscan.h
> index 1212f6a7c223e..15b31281f0955 100644
> --- a/include/trace/events/vmscan.h
> +++ b/include/trace/events/vmscan.h
> @@ -122,18 +122,22 @@ DECLARE_EVENT_CLASS(mm_vmscan_direct_reclaim_begin_template,
>  		__field(	unsigned long,	gfp_flags	)
>  		__field(	u64,	memcg_id	)
>  		__field(	int,	order		)
> +		__field(	int,	pid		)
>  	),
>  
>  	TP_fast_assign(
>  		__entry->gfp_flags	= (__force unsigned long)gfp_flags;
>  		__entry->order		= order;
> +		__entry->pid		= current->pid;

All entries saves current->pid in common_pid field. Can you use
this common field?

# cat events/vmscan/mm_vmscan_reclaim_pages/format 
name: mm_vmscan_reclaim_pages
ID: 590
format:
	field:unsigned short common_type;	offset:0;	size:2;	signed:0;
	field:unsigned char common_flags;	offset:2;	size:1;	signed:0;
	field:unsigned char common_preempt_count;	offset:3;	size:1;	signed:0;
	field:int common_pid;	offset:4;	size:4;	signed:1;    ## <------------here

	field:int nid;	offset:8;	size:4;	signed:1;
	field:unsigned long nr_scanned;	offset:16;	size:8;	signed:0;
	field:unsigned long nr_reclaimed;	offset:24;	size:8;	signed:0;
	field:unsigned long nr_dirty;	offset:32;	size:8;	signed:0;
	field:unsigned long nr_writeback;	offset:40;	size:8;	signed:0;
	field:unsigned long nr_congested;	offset:48;	size:8;	signed:0;
	field:unsigned long nr_immediate;	offset:56;	size:8;	signed:0;
	field:unsigned int nr_activate0;	offset:64;	size:4;	signed:0;
	field:unsigned int nr_activate1;	offset:68;	size:4;	signed:0;
	field:unsigned long nr_ref_keep;	offset:72;	size:8;	signed:0;
	field:unsigned long nr_unmap_fail;	offset:80;	size:8;	signed:0;

Thank you,

-- 
Masami Hiramatsu (Google) <mhiramat@kernel.org>

