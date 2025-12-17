Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EADDD66BBB
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 22:19:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5EA896B0005; Wed, 17 Dec 2025 17:19:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 598306B0089; Wed, 17 Dec 2025 17:19:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C1EE6B008A; Wed, 17 Dec 2025 17:19:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 39C466B0005
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 17:19:57 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C83A487072
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 22:19:56 +0000 (UTC)
X-FDA: 84230381592.30.3A3CA27
Received: from relay.hostedemail.com (unirelay07 [10.200.18.70])
	by imf15.hostedemail.com (Postfix) with ESMTP id 30E4CA0008
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 22:19:55 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766009995; a=rsa-sha256;
	cv=none;
	b=uXc2By5DfIzVWtljH3z18Tj4PoCFns+VMgbNOyvNR/UxIVYFnuMjAKbgxRTu6pXW6GJUSR
	sheJMVMciCMFe4YUVPXkrQzD1BRhxqfM36BfHO1X4KHGGck6wdYbnzhL2QvkFTIbaeP8UY
	3l6SRairXVizI8uxW3iIl4Qr70Vfb2M=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766009995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2u/1GBGUYAC2e5UCfXzrlVHMa8nPLkAD4bPW22fKlL0=;
	b=8otAU5BI2O8flaEUDY5GKrBPzr+4pRlYIxUqLUzE9J+8tyObp/gaFv3PtUms/rLdz92Y7j
	L/ZdNgJWnAjt61UFm5hBMDigJtW782PxECtFw9bRyaZ5Hwq5MJfdZBNfof2EP2RQaBR/Fq
	Nzi9QdE0fTMne53POY6jVuFL2CXjYeo=
Received: from omf18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 69709160A3D;
	Wed, 17 Dec 2025 22:19:54 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf18.hostedemail.com (Postfix) with ESMTPA id ACAB82E;
	Wed, 17 Dec 2025 22:19:52 +0000 (UTC)
Date: Wed, 17 Dec 2025 17:21:29 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Ballasi <tballasi@linux.microsoft.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mm: vmscan: add cgroup IDs to vmscan tracepoints
Message-ID: <20251217172129.724c41a7@gandalf.local.home>
In-Reply-To: <20251216140252.11864-2-tballasi@linux.microsoft.com>
References: <20251208181413.4722-1-tballasi@linux.microsoft.com>
	<20251216140252.11864-1-tballasi@linux.microsoft.com>
	<20251216140252.11864-2-tballasi@linux.microsoft.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1+i23Pi9VijgAv0wiuOMPrlDUDyfeGFM5M=
X-HE-Meta: U2FsdGVkX19aTPnMOX0Iq3Wqm7D4si7ujpb5G+dn07pB95DyASlVuNnm0Ynhp4ZTCIrz5M2ZgZmkTHqRiqUsup5SG738YSc2yD1VBskZTt7t0kEEg+OMy6+c174/d4+WluPA+gTLRYxPojsl3c2q6YH02CpX80kS3RMEbMg927mL74lMLBqsA5B65RjXNwDLQgDtsWCHAY3TAewslMxM179vso0b6mNQpIBT8ABZTKTWVxNzh8Sx0UGIR0+fqYgwHPz2Ne/eCbRibcuU2guTeZCmOMbu1feiVIWIW5Hg2q+IKrHEBhetGBoCQ21rGiDQ8a2SC0e3IsqOZ5fJUQ2hdlUhlZ5hQmjE
X-Rspam-User: 
X-HE-Tag-Orig: 1766009992-305526
X-Rspamd-Queue-Id: 30E4CA0008
X-Rspamd-Server: rspam10
X-Stat-Signature: f5b7zdn6p8foedi1anmbumzzdw8ppz13
X-HE-Tag: 1766009995-270008
X-HE-Meta: U2FsdGVkX1/XdT0khF0rtEgEZsYSSc/6XjRvsMoHZ2rm6b+tlOlKdgZMEv5rf/vudmiOiRDz2gJNDaRd5caBhDIg8X4GRJ6dIhP9l+lNU4bKixGNnfWps9JnG8q2TQOW67K9VJgRG7bTkyzLA4ztyhJ//ZZF3o83V/lSCXx6ltKavdx1s+xQe5i9kjpIKsd3/ObFnJp2aGRhxfTBxT6NYwqf0KlgWyVQWyosAMJJmY87hP4r6tMUEx0U5yyIwLxXSatLn/MeE7KTOWJcOoZGTp+Jg1NxqEjClBaX6wEXTIRKDdRTCm8sz4qTqn3TzmcnKJYj5bcVJOvXX47KuVmHr45bKvhPO3Z/kekbBWNpuT/yWrMdRsKpBOVitoMBdHA9JIUrPMPXC3RpvWJY6K+VX2vpG5T8P0gcuC+mlWdCNhoJ+bTV6FRnlr0/+1a/tKs6WcVWNUnRWGLk1fNeB8nq6A33gX6+fQgKbHGKzz3oPbLt83fG317IW6f1omLDKsA0eMsXAGOdtqlr+qHp3dpIXNQAQLnqZQkw648N1EhLjJQOSraO+MUNlyQPwuIEfIeU9w0m9WsdXsYYY9hFSll79aG6Sz0ffIzqraV5xbKyis2kmBHOwAN/kujEsq8XRlMb24JpTZz6O1DyL4ugoSryvGU0Nfk/JwR2Az2Mg3fntCw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 16 Dec 2025 06:02:51 -0800
Thomas Ballasi <tballasi@linux.microsoft.com> wrote:

> ---
>  include/trace/events/vmscan.h | 65 +++++++++++++++++++++--------------
>  mm/vmscan.c                   | 17 ++++-----
>  2 files changed, 48 insertions(+), 34 deletions(-)
> 
> diff --git a/include/trace/events/vmscan.h b/include/trace/events/vmscan.h
> index d2123dd960d59..afc9f80d03f34 100644
> --- a/include/trace/events/vmscan.h
> +++ b/include/trace/events/vmscan.h
> @@ -114,85 +114,92 @@ TRACE_EVENT(mm_vmscan_wakeup_kswapd,
>  
>  DECLARE_EVENT_CLASS(mm_vmscan_direct_reclaim_begin_template,
>  
> -	TP_PROTO(int order, gfp_t gfp_flags),
> +	TP_PROTO(int order, gfp_t gfp_flags, unsigned short memcg_id),
>  
> -	TP_ARGS(order, gfp_flags),
> +	TP_ARGS(order, gfp_flags, memcg_id),
>  
>  	TP_STRUCT__entry(
>  		__field(	int,	order		)
>  		__field(	unsigned long,	gfp_flags	)
> +		__field(	unsigned short,	memcg_id	)
>  	),

Hmm, the above adds some holes. Note, events are at a minimum, 4 bytes
aligend. On 64bit, they can be 8 byte aligned. Still, above is the same as:

	struct {
		int		order;
		unsigned long	gfp_flags;
		unsigned short	memcg_id;
	};

See the issue? Perhaps it may be better to add the memcg_id in between the
order and gfp_flags?

-- Steve

