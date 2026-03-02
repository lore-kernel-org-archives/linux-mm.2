Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 774CBEA4E04
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 14:17:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9E6A6B0005; Mon,  2 Mar 2026 09:17:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B75CF6B0089; Mon,  2 Mar 2026 09:17:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA2816B008A; Mon,  2 Mar 2026 09:17:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 95F636B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 09:17:01 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 574FF140116
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 14:17:01 +0000 (UTC)
X-FDA: 84501324642.15.D34F3B3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id AB70C14000E
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 14:16:59 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Y2223cUk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772461019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JvpNt3osEjYd3dt1DAr3Ouk32hQgCG4wbSIMYSLa1rA=;
	b=ZAgpihwTbYvYwZFnrw4vf1ldz9wVOcYGUl7wnuIT7we8Ze3V43YJipD2RrCN61670EYRQv
	Y9pWiucsr6QjrzEu1tsfb9B//+omNzzlKZpMRh6sIPNorjgPWZTd3SYtjMStrbAzjntXv6
	nb9m7DzbbDgZLY+Km6LACQiKC4ASsPc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772461019; a=rsa-sha256;
	cv=none;
	b=Yl37KT5liOfvD5zBQHgzty/rMHdkNPt9NdtpjEgqROPh1xnmpwL//eVVhvgl4OMFK0E9sK
	wXaMDYhIkDadZClvNaQWS6F85Q/cT7cfSCay7TIMxPuluIQcMec0tcczQV10Z8qIBDf1NX
	clAiOfO1Kye5GwpWJRsHcZAI5QEXkeY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Y2223cUk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E570860103;
	Mon,  2 Mar 2026 14:16:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40ECDC19423;
	Mon,  2 Mar 2026 14:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772461018;
	bh=eOi621zBxOkJY1UKHW4ZO6+feq9RArS0Wq0cDsH50hg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Y2223cUkvjYf8lYJZDxKuyv8L0iTzBaH3j6FhQOjgs5aA+bbaXbTF1IxZkZV9Al3C
	 Lo/KTxpqgArklPvabIdDAElOmALZG3jaHCo1ZVAshHi2SaPPvhl48Fjffx6p11UKGa
	 a6pyqPdjAPbd8lb9rg0HhBJurH3FFmMB6zSa0NG3mroIECbWt6m88JmfasymxL0PLW
	 2GM+f5yDLwg+NyrNWmqhK5rYUqt4Z7hONlA0bmg/ZlamYi1huD1U+DabiPVzOQnlD2
	 U1H6jkDOW6gfpm9hXavn1QO1rNkcFlI/Ixm0BDH+Uu5ilSfACUbRoe+WhdFScYxNuS
	 szdsnJ1D5LMRA==
Message-ID: <502e0f7c-cdf7-4a2d-b038-cfd4b993c9bc@kernel.org>
Date: Mon, 2 Mar 2026 15:16:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 5/5] mm: add tracepoints for zone lock
Content-Language: en-US
To: Dmitry Ilvokhin <d@ilvokhin.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 "Rafael J. Wysocki" <rafael@kernel.org>, Pavel Machek <pavel@kernel.org>,
 Len Brown <lenb@kernel.org>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Oscar Salvador <osalvador@suse.de>, Qi Zheng <zhengqi.arch@bytedance.com>,
 Shakeel Butt <shakeel.butt@linux.dev>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
 "linux-cxl@vger.kernel.orgkernel-team"@meta.com
References: <cover.1772206930.git.d@ilvokhin.com>
 <ae145fe890f028409f727b4921904b547346fa0b.1772206930.git.d@ilvokhin.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <ae145fe890f028409f727b4921904b547346fa0b.1772206930.git.d@ilvokhin.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: AB70C14000E
X-Stat-Signature: 9pcrqi3nhs8jof4k43fepgqh6r9dr1p1
X-Rspam-User: 
X-HE-Tag: 1772461019-195705
X-HE-Meta: U2FsdGVkX188ybmwEuCi1j0CZRxy66mik89frAJJKmgFpyHLZD7ZRhq/7t6GWV9WGS0dJTc5so7KgchncjpyYhj6GLNmQv48qFSBjSPz6U+jSeoPDvZqeRyJdO4TIaGvKz20sLGQTjgFDTfjshbHaIXNJFHr4blod2501R2do8oU9wswT6aW95nF/+3sSbiT4Gh3g8/Egl86n3OWNOMAPEytKYdvmo6OXTikKK4JQ4Dl9AiYkEnHukeXhzU6sak9mESpdaGS12krtVetNJieH8IDbO58hzkTI4oSWcWwR0AhfHd3LGzycyAaSMfltmWaHCqZn+qOZEFxuvkp/vXnWElLuSGpx7cJneyU13/Kklb5MeM29vFbS6dUsp6o/yHue6vMmEUGgAxpR0K/J0id3JYyFOnbyv5bdsHLhGxEciSUdl8OQI9SxUdLTVBEitBdb4SUL0hE3ryPfJpaoOWy+oKc+v7rim5b5flEDa+jc8YTjXgbdyArT85oPJgVTYHuOzf/GROE0eU1S0V2XJtdaX2p+iKWaScNCVdHd0RPIxvGkC0woNnqXNb3lUXpqiUlWGDfdNee2EojBbHkh8Fhkbo2wLOe6u3/V86zmsAC0dfSzwR4Ohu1wRJCZpdjeY2czrOUjV0z0HMsC1P9jFbBHQfEQsGGc5IncFi3gjbv/7z8VdQt9o2sKBC7enoZ8DlepkvQ36GkHlKlhavnNMaAzj1BLWmoyc7PHSnukou4lL5BVhn7Trg+gxcis4AbVNXbbmjEj+5nttT+UtS4T9m9nlnm/UXY/5G9TeQMbgLhZsgf/K/IrlEdYoB91iYnR7brpWTNV+EBLxAJCZPjf4HZHu+Ui2XIIrkbUN+bOV3yoKCKMFFgvz/u7mp/P57/3ykverTX1f53JaJGYecfidig9VECFigQIJoZtziAJzcEaH83AWIICAlOJKv+ZS80BbZNA5KQm4TIDKpf1FA6hdL
 qNfTXdAV
 Eliqqm3mAweM0IcreZzBJFIphT0cElibmnxMz+GD7mKfDGld/LZy3Ha5WJMpiR80z6KV0G9FbXiv9XPBB2Cq5xP3bMBygZZTXgN7R+/oNfPLTzlyU8kUwhmU4Uy0zAa90t2GgCOhIipFicv6J4vIhOOswR4WK+pIUfazod1CfaYBaFNQ9jU6ERXm6QSUnGCITNMvONQ/2XtviuIX5JvrZYxyTlfOlO+MxoLC0e2dyn/Ex/p+pY+eMwDVVK9AyW8JdNxzuObCNGb7yHVVxRcp7VZtKAfed75rFX+sPWZpjwlx73VTgGZa2OsyXKOraF+V9CQaCOEcBYBDEfNAL8qci6XrJBg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/27/26 17:00, Dmitry Ilvokhin wrote:
> Add tracepoint instrumentation to zone lock acquire/release operations
> via the previously introduced wrappers.
> 
> The implementation follows the mmap_lock tracepoint pattern: a
> lightweight inline helper checks whether the tracepoint is enabled and
> calls into an out-of-line helper when tracing is active. When
> CONFIG_TRACING is disabled, helpers compile to empty inline stubs.
> 
> The fast path is unaffected when tracing is disabled.
> 
> Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

Agree with Steven; otherwise

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


