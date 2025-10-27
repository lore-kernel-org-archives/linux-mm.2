Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83F86CCF9EA
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 14:53:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C7318005C; Mon, 27 Oct 2025 10:53:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89EB38005B; Mon, 27 Oct 2025 10:53:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DBF68005C; Mon, 27 Oct 2025 10:53:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6BC198005B
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 10:53:37 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 35527C0146
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 14:53:37 +0000 (UTC)
X-FDA: 84044188074.13.80A1D97
Received: from relay.hostedemail.com (unirelay01 [10.200.18.64])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6FE491C000C
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 14:53:35 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761576815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LBaCICudemK5hqX8hGCj3Ny3uuhnAOdCVI/QK0vqE8U=;
	b=MbdolDYtIdnxscmMq9ksYFb7zLIS8d363ui1Tvkleqyn7YiF+ZI2WMY8ZDT/S3m3qtNN6r
	WlakiuE7eP1qrXI2vKPTMuh6MOrnvOi/D91MMqxbh7ScVtkFJcHEv+GsMIqtpd23lLLKW+
	J7FNLZi8oQiif4c4uoRWy6tR0yrF85A=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761576815; a=rsa-sha256;
	cv=none;
	b=1xM8WEZIsgUhfbXV54MmIWLs5DR6setzS0P+nXEi5pF9TR9LWWMG2qnDnouGt+vLIrhd/2
	0+YBi6rNfkENIjLQog6nhWnPC1hKKepqzs79t3F5yA67pcnN+LCdfAFymXi37zhdUeBtn7
	ChzHSr1gwtQgNobvQILAEQyOZE/Kch0=
Received: from omf20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 158CE1DE3B6;
	Mon, 27 Oct 2025 14:53:33 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf20.hostedemail.com (Postfix) with ESMTPA id 28FBC20028;
	Mon, 27 Oct 2025 14:53:28 +0000 (UTC)
Date: Mon, 27 Oct 2025 10:54:03 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Alex Markuze <amarkuze@redhat.com>
Cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, Liam.Howlett@oracle.com, akpm@linux-foundation.org,
 bsegall@google.com, david@redhat.com, dietmar.eggemann@arm.com,
 idryomov@gmail.com, mingo@redhat.com, juri.lelli@redhat.com,
 kees@kernel.org, lorenzo.stoakes@oracle.com, mgorman@suse.de,
 mhocko@suse.com, rppt@kernel.org, peterz@infradead.org, surenb@google.com,
 vschneid@redhat.com, vincent.guittot@linaro.org, vbabka@suse.cz,
 xiubli@redhat.com, Slava.Dubeyko@ibm.com
Subject: Re: [RFC PATCH 0/5] BLOG: per-task logging contexts with Ceph
 consumer
Message-ID: <20251027105403.2d020b8d@gandalf.local.home>
In-Reply-To: <CAO8a2SgZ8gZ0VdtBAeW8wLMDxa+Eq42ppr-99tUpiu3Tpwqz5w@mail.gmail.com>
References: <20251024084259.2359693-1-amarkuze@redhat.com>
	<20251024135301.0ed4b57d@gandalf.local.home>
	<CAO8a2ShRVUAFOc7HECWbuR7aZV0Va3eZs=zxSsxtu0cMvJmb5g@mail.gmail.com>
	<20251025105944.1a04e518@batman.local.home>
	<CAO8a2SgZ8gZ0VdtBAeW8wLMDxa+Eq42ppr-99tUpiu3Tpwqz5w@mail.gmail.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX18QkOO9R21LVBrW4cwrEsvG40q+N7FRrKg=
X-HE-Meta: U2FsdGVkX1/y2rxUidxPu/q4n8C0KJZeyG9NUfc267rFSYjiZBs19+cLFZ1Ce5eI25D7AtEIUV88ToUUjzXl12lsYbGAgOTQYwQg5nE7AyNBP1f7Bt2CIa4mybazVYojiJXsfpZEyBhhJuY8YYQW/U0XRduqJYyOMi4Xk3v9Mo1bW7ImUBopldJfQW9+NP+Moo18A+AzIZtEdv8wx0PpAiegJ9cvnQI705vJv4huyvM5eprVEIcCifuhhNtKcMV6hRz124rK2MjqUDdFccljiUkErq6KpbP2LYaxEaDSoqwcHaVp1KD7b3B6Zz26gXdoH4pIcwzKBvP09JRLCAVwIjFCzDQSEur7
X-HE-Tag-Orig: 1761576808-121962
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6FE491C000C
X-Stat-Signature: btabxbh6rn4s9y75i8tsernxrkczhxfu
X-Rspam-User: 
X-HE-Tag: 1761576815-503571
X-HE-Meta: U2FsdGVkX1+KVifotOSdaq1uGbh2Af2EBk3SAzYBD2g2KTKXapYZWpUC/ntWrPgo615dhbumw3+k6iuKSQDpQYEZNj01Aw0dHUmhisSD/U4m0AfEfBE6++yUEcEcv3Xir9zQop7yLQyfc4QkP50Y1y8pW0E1hcKOev1bhh9mhiQHndIrvUxorPtMrMiiRv1SyItRqa++IX3Fk4ODHEVphN687fHkxjTt27mJnV4FvSPf8CbHEgZq6mUZPBUIpaGX0Umr3U49uVkxPG2MFcRmKyTwVmzpvXw8sGpa3i/OePfl+bQk8SFZDCghGjNLzuKpcuw52g0v+/luUrdDq7KA6aE58xeH+7UYPDkn1v41N8lzfDNbnwj0ra2GEeSV4uwFbSwHwFF+hkCdweSvIpk6bD3rq8x3yH37rtR0ERMaK4/8SmlecuHit1pTK9xpDIByud0LWTUhnI0tNbRZONG9+EO4kDE2aL1w1sU5G30BIAwyMhqc4pmI/ZU7CGOp4nBOqiH0DGK6nLzCquxTPRmDOCjuP/yBeeVQkxzhFeedAeIu6B95SONuxL6V77m3TVDGZRPn7X1h6JxZXDym6wzl9ZKI2hCWTm1jgAvXXbjp0BFTyZEqp4ShEuwwaiO3vSvzOTm5VgFooym/padYN9rmvAdBj0GNQXdgIDG7gaMYFTlXkcsMcjTJWwOQtYwPAYJqlitUBpn9OdRo07mXLuNPGKRxTZHGXYXy2tIjHQuhErIudUpiLBeO2OdWCU6h7rHZMm+3H6wvgzK4XsM9ynrgQT20Cu379loE+xWRe/RKIUrZdMlmY6pplkCxj0AoKhAjNHNC/NZmU3lshJnhpl7RUBJC64I1zNBRYirfud0iziNtuxduTZ4DOfIPGxqhYPlBrpkUn8h2YtgH92sBENPqb+AohHkJgVWzY0qYMTqpmPCkvTbD0MGbJg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 25 Oct 2025 20:54:00 +0300
Alex Markuze <amarkuze@redhat.com> wrote:

> Please correct me if I am wrong, I was not aware that ftrace is used
> by any kernel component as the default unstructured logger.
> This is the point of BLog, having a low impact unstructured logger,
> it's not always possible or easy to provide a debug kernel where
> ftarce is both enabled and used for dumping logs.
> Having an always-on binary logger facilitates better debuggability.
> When anything happens, a client with BLog has the option to send a
> large log file with their report.
> An additional benefit is that each logging buffer is attached to the
> associated tasks and the whole module has its own separate cyclical
> log buffer.

This looks like a very specific solution trying to be a little more generic.

The more generic a solution becomes, the more "bloated" it becomes as well.
That's the nature of tracers and loggers. Ftrace was designed to be very
generic, and yes, it can be more bloated because of that. But it is also
designed to be tuned down to be a highly efficient tracer. One that can be
used in a production environment. Sure, if you enable every event, it will
cause a noticeable overhead, but ftrace is designed to surgically pick
which events should be enabled or not, keeping the overhead within the
noise.

Ftrace is more of an "infrastructure" than a tool. It provides access to
trace almost every function , but you can use that same code to implement
live kernel patching or BPF hooks to functions. The trace event and
tracepoints are part of ftrace, and are used for things other than tracing.

Perhaps it may be more suitable to make BLOG use the tracefs interface,
then to create an entirely new interface based on debugfs (which BTW, a lot
of production systems do not enable debugfs which is why ftrace uses its
own tracefs that does not depend on it).

-- Steve

