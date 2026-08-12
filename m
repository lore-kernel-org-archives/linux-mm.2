Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EF8DC5B56A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 15:46:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D3F16B02B8; Wed, 12 Aug 2026 11:46:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1854B6B02B9; Wed, 12 Aug 2026 11:46:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 099D06B02BA; Wed, 12 Aug 2026 11:46:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DD22D6B02B8
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 11:46:55 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 70B9C1203EF
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 15:46:55 +0000 (UTC)
X-FDA: 85093045590.01.772FF74
Received: from relay.hostedemail.com (unirelay04 [10.200.18.67])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9C8D020002
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 15:46:53 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786549613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QYpe5dD90lBHYR+yRQqAk6ksMnJ3JUX+hr2OjU7tbbA=;
	b=i7/SJwM9wyt61ntMokKRMjtdKK10/wClyKKqKOe26y7cdI9pXV/oQ9dmNfIe0LIC+FNsW3
	xRjWy6SUOpDgAVYFz9pxOiH7iVjMiEc1k/C8nWpfjHAOcOsPM9WeETv+I+cpGqZmXvGGOC
	LHCO9hTMEiMdVmqjT4ccSvxh4ymRZPA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786549613;
	b=7rqgta5nRMea9mV/gdRMjJyj93RZ/93tJYt9NWkqwyiTabENcm4MrDrE82RKlMejr/abDA
	NE81Gapk3rMq+iYWFnseJYfLgO+iqL7StrR4b2maQI953mSxE9Pg1fAnIr85b2e8AD4z1F
	iP6RXfML/mbgQC6jPa9r7y30kWwjoAk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	none
Received: from omf12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 595761A0220;
	Wed, 12 Aug 2026 15:46:52 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf12.hostedemail.com (Postfix) with ESMTPA id 2ED3C1C;
	Wed, 12 Aug 2026 15:46:50 +0000 (UTC)
Date: Wed, 12 Aug 2026 11:47:04 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: =?UTF-8?B?6auY57+U?= <gaoxiang17@xiaomi.com>
Cc: Xiang Gao <gxxa03070307@gmail.com>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Lorenzo Stoakes <ljs@kernel.org>, gao xu <gaoxu2@honor.com>,
 =?UTF-8?B?5Y2w6Zev?= <yinchuang1@xiaomi.com>,
 "linux-trace-kernel@vger.kernel.org" <linux-trace-kernel@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [External Mail]Re: [RFC] tracing: aggregate ring-buffer usage
 statistics
Message-ID: <20260812114704.2f61bc5a@gandalf.local.home>
In-Reply-To: <cd441eb194d54265b1bf9ab659716c45@xiaomi.com>
References: <20260811114818.1449933-1-gaoxiang17@xiaomi.com>
	<20260811100830.7976bbe8@gandalf.local.home>
	<cd441eb194d54265b1bf9ab659716c45@xiaomi.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1+by/rQIKubySb9lhljso6RTy3PoJgX2ew=
X-HE-Meta: U2FsdGVkX18gjr0dOC6PWIz5eVBeLbyJ3izL+U0m82/9r/HPau+llgEP75MBoxAEPEQTN/l3MX1VSvnWeNMGowQmOk+rObggFZl8nJwt4FPQoNCEIgeTvgDE1Fb+gHa/LihN1JW8MBdo1DSj3eCveydHIz9AAwWnvZNTt4vt2rsrX6rr3z2AT6+IZUIbYaA1WSJMiQyvLgawQ97FeJdiM6h1JqGOC+LOQpXlTtRQ5+7OoJYKbYdKNNkXyZH4phaVasIl8mtCSiGHKQJ5sLk6/DKt0FC1/qFCHhrqiscSVoJFndeCv/HgUcAfdKH0he/qHfOvLx1Dh1cwXJtaiPfWTNWoyI42XrYC
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag-Orig: 1786549610-224787
X-Rspamd-Queue-Id: 9C8D020002
X-Stat-Signature: jj55tpuq734zrntr4mkk48tuo8hzoa9h
X-HE-Tag: 1786549613-932743
X-HE-Meta: U2FsdGVkX1/Gj6zEGG1+kYaZIya1kscCS+dMVh6wq5Cj/6NU6s23Yaif0DB+dOiSKdRvNaQY+bMJSyurMBxpoU4veCQkd6PeUKOOAyl0HqhE1JW7Mo6wcvnrHwgUCBT+XB0Y4x5Pk3Psj719AFvyo2gPcQdL3v3Pysdclk+BSaiUzLeVNgyl7zDxoxSMYaE/ZAl1hLxJrqbpw+JaVRqonbe6hcgO4OSpiW3MCJc/5CWqKPZgWlpVYUvPtQEDYj0G3+GOd0+Pj6wIEmIJZYg/OosxFY822YBpg/mDaKdY3R5BK1HvMEKLdG3J/t8gN5o0JetqUAXzlrodvZaNKKneszwKq1bu8PJfT2h5ZkcP91eqi3PQn5gAhuZFesgZVkvnVlPaN09KkDn2GjwAQ1yqFfqdPyRf/h0jsecyi+4aMe3/BSkpmv8xIWLwyF9yRLISVbSgUU4o/qqa8naMiLNIegzebRb6P6GUat46SPJiCuXc1Fg861/U1s4McfrAiWQQwQobjjg1zxZmIWs+meyzYCiBIl6wvm7Cv8Q4puFFAfgsvI3Amv5zb0d31pyF9hG0S/zkvk5C8SmB5P8fkpQ5iJ5pnDw3v7qHxK3sz8cWld7SwgTwf4O8tPl854MU5/EnLMLGRkHu+RMYifXUqSy1cG34ZhbphiSUSD9uMR0mihK0WepHCOWIcSHwFzvbksOgwHQhGJRCjiRTS5Grk1aFl1p2c4eyoBUqmtvEzPNvapMj/19CSXVpPy3viRXKnH12J7aKksC2n2kHqgsByMXWesD6vnisFVByr7CErhlI71G2Pqb7BlIAAGljo5boraTdtFcMvDEUJPVfKeJ2zwShbpBNDU/BSC0AcRiETzGmtoF2ZmRZXuKoWDljHHicwxQcpLdgLaHVbFoVssTa7lG6vfFXqlHVU7ArSQ2vDXQSfnoJf6xuEvgB6ODrtChvFugPX8mcJ3b3u57S4rht50I
 k5lmuYUi
 HqcwuAXY3WXCzlQmBHs1DqCaBooXLA+qgvm1w8e7EcE0tTjWvF/DgSQr8BO7bp8EQQNBbHirnWp9EUhBs1VcHZ5hI4w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 12 Aug 2026 13:21:29 +0000
=E9=AB=98=E7=BF=94 <gaoxiang17@xiaomi.com> wrote:

> Thanks, Steve.
>=20
> For the initial implementation, I plan to add:
>=20
>   /sys/kernel/tracing/trace_stats/total_memory_kb
>=20
> The file would use an extensible key/value format. Initially it would
> report the ring-buffer data capacity:
>=20
>   total:                   395664
>   ring_buffer:             395664
>   ring_buffer_live:        395544
>   ring_buffer_snapshot:       120

You can rename the above to:

   total:
   buffers_mem:
   snapshot_buffers_mem:

No need to use "ring" and it keeps consistent with "buffer_size_kb".

I added the "mem" part to distinguish the difference between these numbers
and the buffer_size_kb, as these numbers are about total memory whereas
the "buffer_size_kb" is about usable memory.

There's already a total for all memory listed. We don't need to have a
total for the "live" and "snapshot".

>=20
> Here, ring_buffer is the sum of ring_buffer_live and
> ring_buffer_snapshot. The values cover the global trace array and all
> tracing instances across all tracing CPUs.
>=20
> Additional accounted categories, such as event memory, could be appended
> later and included in total. Per-CPU statistics could be exposed
> separately under trace_stats/per_cpu/cpuN/ to avoid mixing aggregate and
> per-CPU values in one file.

Agreed, this file should exist in the cpuN/ directories and be only for
those instances.

>=20
> Userspace would parse fields by name and ignore unknown fields, so new
> categories can be added without changing the existing format.

Right. I would expect additional items to be added here.

>=20
> Does this initial format look reasonable?
>=20

Yes, thanks for doing this.

-- Steve

