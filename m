Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EDF5CCF9E0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 17:52:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7CD98E00E5; Fri, 24 Oct 2025 13:52:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B05508E00C9; Fri, 24 Oct 2025 13:52:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CE878E00E5; Fri, 24 Oct 2025 13:52:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 836578E00C9
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 13:52:41 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2E55DC0F54
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 17:52:41 +0000 (UTC)
X-FDA: 84033752922.05.EEB4F32
Received: from relay.hostedemail.com (unirelay09 [10.200.18.72])
	by imf15.hostedemail.com (Postfix) with ESMTP id 77F94A000D
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 17:52:39 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761328359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nqF5ekbBeYks8hP7eMFTsCADjQIKsE02FXNbC516kAw=;
	b=bLZ/FmAnLWbDd05je5Rjmz9hrdWg4WTEEYEC/YLBHyUshX8dEVdhzMr2UWAIIfJ+xBQxkI
	tUOd0yWyt5jAJzW3fhAdWuHRiBz+N1pP3LTegmBcwKhvUt0cw09LPEYCKuasxqjiVPV3Wk
	QZ6OA8dNS3T7DbHP6PYFZx+360Tsx8U=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761328359; a=rsa-sha256;
	cv=none;
	b=jDy7aAMlNu+o6XPRW1xn/ngk0ZVNZpIWJL6kuhs4pRlnoZEqEQNkMWLeznHO0/pRMrXMQg
	P7Gezw4ljrwgkt/XGMllZpPxt0fcYyeca8lbPBKB/iLq3trTpuETrT1IRc9tWH75OuzmV1
	AsI28Yi3xlb/Qi7Ralw38hKiLEns+o0=
Received: from omf02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1434988C4E;
	Fri, 24 Oct 2025 17:52:37 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf02.hostedemail.com (Postfix) with ESMTPA id 3528A80014;
	Fri, 24 Oct 2025 17:52:32 +0000 (UTC)
Date: Fri, 24 Oct 2025 13:53:01 -0400
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
Message-ID: <20251024135301.0ed4b57d@gandalf.local.home>
In-Reply-To: <20251024084259.2359693-1-amarkuze@redhat.com>
References: <20251024084259.2359693-1-amarkuze@redhat.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX18Il+RPgBw+4y/Ol7NLnuI2IjUEEWEcKgE=
X-HE-Meta: U2FsdGVkX19E8qyxD0KBCanmO5HEjEeVw85UOUdVtIZFFJHxSdhRzzuTOgQ5V4tZ23nAtpGUqOrxEtZSBTDgJr8Ukz2f5OQlctoC2nenIodpUFxlGK4TvDYeldYDN+U+gkIGYVOtWFBkFCUqIW+47AFLYAQ+SUcSw7RkMJcYA8wLoN2WGKOzxQi1SK1mkO95k0D+0Mo3tJ7fiWrqnjYRTRCK87BKA7QTVC4RC6puo3wsXv8vKUk/8cPkVxcAQC0sIlfQul0YbGnVJ8bzlJK2eO1zy5wrg/bjHX4k7WzcvRwXVdCKrhC70dOJxVhJjBh0GtdrE+rjmHDZGV8TOs3hHVJADyW6P8Vk
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 77F94A000D
X-Stat-Signature: 6x1d69shcekb9xwi81uzzujg83hzkb37
X-HE-Tag-Orig: 1761328352-50590
X-HE-Tag: 1761328359-120171
X-HE-Meta: U2FsdGVkX1/gbsJPDDgYRaLMT6A5BqbcuNzYMPetRL6oW5insQd/8RFn8uU41S1s6jH7x8OU50e5zBZ+fm1w8fCb2MKwH7gMAdk5mlPIs0zqbFjPtgmST9a8cfJYHZW7/CNch7u1Un+NQH8/6TcDGYNf/cam7EEBzmB2SEGHMM8yXA8ySmfdsybhwSsJ1etFw0DIzFmkB87yw7s5zKy242X7BZUxCzqW7oVT60s0fsQAMS8NxgzeYSDRjsZLswqldXBUnQQhx29I5YZOREfQFT3u7waqUQ8BBoXBDXiWjKVE/JSZ3r60QBdvYgyoJA4Q+RtFOa9NIf1avxUFrpkSEg+5VvHbfKtATEoYCzesZHn3JAgM8QniEhh6jlF91cSUDrGkrTihAGAAjqThWh8pZQdvzEbs5OVmJ+Vt91AeUePScwfR9pjHOfbBLr6dncjS9rIdw3fn94KszJHxFCci0upwpRAR46rAmMTRKtB0OcpJzMpWU+YJ4ZfwveAqI7sBYjCE0td2H0xg9cL/EbeJVWrDUY+KsTTG+7dO6yi+Bw+eJZ8b5wUzoLoze624jCQeNGF9+Tg+vwzeRop5gZcQjvYvT2lMMW1IjUHUu7OCLpZovyyrtLj00t6OQEsAxxczpOlTTdvok484LG4MaQZCAzsCd3rHBfOWu7GqfWyKP9/HpF41ds+MO4ToYyeBiCtu5k8fidT07I3xz5ZVg5CGL/W8W6ROCgAjjes4oMjj2WR+VaMhcCzpz269KcK09KOpYR6itDtIFaekoUxhv2e7WXOci/Y6+vmZzqNl+2ixC+wv49rFY4RQzmLLYamkNBXYwbfB/7/jEUspj0cSWCmL912smRaWHwJOHzqxZXgH4uMpGTiJ1ba2UdCjL8q0uDeJf3+hTT4Ccx77NruZBU13QtXJCaKvQSW0rCD0EAavAdWd35w058dX4w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000002, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 24 Oct 2025 08:42:54 +0000
Alex Markuze <amarkuze@redhat.com> wrote:

> Motivation: improve observability in production by providing subsystemsawith 
> a logger that keeps up with their verbouse unstructured logs and aggregating
> logs at the process context level, akin to userspace TLS. 
> 

I still don't understand the motivation behind this.

What exactly is this doing that the current tracing infrastructure can't do?

-- Steve

