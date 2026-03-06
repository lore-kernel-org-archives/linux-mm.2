Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F250FFCC051
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 17:53:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F008B6B00A9; Fri,  6 Mar 2026 12:53:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB7C06B00AA; Fri,  6 Mar 2026 12:53:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE43E6B00AB; Fri,  6 Mar 2026 12:53:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CE55A6B00A9
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 12:53:40 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4F57F140687
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 17:53:40 +0000 (UTC)
X-FDA: 84516385800.24.33709E7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 74EDD4000D
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 17:53:38 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=IKxtYZjb;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772819618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VOM86RnJTGxaD+xE3J/lqr8J9Hd9qebM5zyJxAiLx7M=;
	b=NCv8fPzieSvDVZOKOQPL/o83mbyTX+t/rp65KEtH2QH1mxIuikGbOHvqanw09MF65aihB9
	HiNkIZW4M7/VSeKB0XpjXKk1nWUng51dG7JTy9ZMw2XHUn/ORKvbHH5cQMdC4so3zTPf6w
	E+fwArYlb9AK6G+OJB5HwBPmUAQ1GRI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=IKxtYZjb;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772819618; a=rsa-sha256;
	cv=none;
	b=PxmOuv/trvhvkp4/JxW+xhIFGGTGfno1zpdLHrl8vp5djFdH91U9BFlJUVKm8Bzq9VR6bK
	MVi2ni/DkhAIJejlwMLPGPBDjSXNxblP2k4/trtwcrWzqbDIWs3pLkH280fBMucpUvQkks
	LLk1zAGsW/D7KZ5CgMLoNuW0qhtdzqw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 721E941B33;
	Fri,  6 Mar 2026 17:53:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6DC9C4CEF7;
	Fri,  6 Mar 2026 17:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772819617;
	bh=IK7f6ZZQLGH/8gc+FQtWRsI6EPYIrlFMQHhmz8jVhhE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=IKxtYZjb9FLFClr244MdACELVFVgUWT07gXuoO0sEpXa3yuBexHTqHCsQzcM4jTkt
	 3N9Si/HjWhBKlLxeKuMAt7xaf7p4h0HYjVCgv6GgbjwqIOe/8Moob5cUbzhzKA03ta
	 pgBsWVmBidVkJQSlogXogMQknemrE26ElA//3D5w=
Date: Fri, 6 Mar 2026 09:53:36 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Brendan Jackman
 <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan
 <ziy@nvidia.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 kernel-team@meta.com, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 1/8] mm: use zone lock guard in
 reserve_highatomic_pageblock()
Message-Id: <20260306095336.a79fcc869a7f6d2b2e97501b@linux-foundation.org>
In-Reply-To: <cf489e5e79f5e9ba450111ee655d9924fe7a1620.1772811429.git.d@ilvokhin.com>
References: <cover.1772811429.git.d@ilvokhin.com>
	<cf489e5e79f5e9ba450111ee655d9924fe7a1620.1772811429.git.d@ilvokhin.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 74EDD4000D
X-Stat-Signature: ijwgj4rf81g7roj7yg5dii4tb8nd34q1
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772819618-842366
X-HE-Meta: U2FsdGVkX19sm57wP8mZJzt76qc2CSSNt705FcsMIjOazMcfIsocRqbbCikbeN101DEp3ElQeN1Zpwe+YtaA2r+qqbbo7oSKLWCgHus4SesWf2Yq+uoERChqbYwvbOALM8j5O1/TnPkKqH4/d31YLJVg48LaEs9eBWyE9qX2KWC8tTJho+WlAsXB/b1A9L3ss9cPZON2pawpxvUjK0Fw2QQvtL8gLk3xP4pfkDcfQZlkWXh8MnFGk1++JsXAQTw6Tl3LR5fLtsKM57u2xXGAbhKA6+yXZwJvJLIpGTeHouQa+5y5x5IyWjTUkCCXFWFHm47F7XeQ8+lIaDma8uB08nQQZOmlCRgpr6PoAgo6FHMgRsBwxOA47+RRN7Jk3ARbMwgKgIC2uQovVe8qwo+9iZmtr9Vo07I8KfSnAU/o+zpXne6h+s3GC1uo2f34lf3/YLCgJORcz9aA7xNRzMwMZYFkSUf87Zj1ONVncaiKr6dbHEJ0fVnlbSiD/dMHkiXy6nlFKVD5uC00ag5TCJd3WPFHBj/s6BbyO2wzcYLH1HPZ8OJUWCCMbE97+yqooiYf05BOorFgQ174sOFLNbesIwA/r2LScl9f868G9oAX9zX5bpUD02puc/pwrK39VfJmxgKsRjustgeDPgG/MAnWqazmpARBcGyWbXmv1Vht7+2qIQQp9GYE+JbKI6G0DHPr2RkrviDq6KwgYlavdKrAcm+1abUufkZPiUbG2dxCkr8MJ+vatbYgZ4ppzyPN9AsYpA7D8hbX0F8gq0BgqjoSW7INOnSyRLpdvzThTMVmSmHyfCMmn9J/WgbanJ9YUi3rByda3Yk57q2Kb00dsgPxY/TLYzRwl42YJNl2IwyfBPEOi+Mx8++ch08WCT4LQYx0ivYG93sGulUzglgMdAUa6EKaehEwpWV5yexKL/g49B+6twZe9gfoDEyGl7caljLNxq5cUsTkcHkRXyLYvhH
 jJazol6i
 n2yb56ifEcch08Uw79chOdRdbmkz0h7RE1WFP7hJbbIXCC2xOLEHEEmJjFu7tr4gvWE4+tQY5nHf75uAg9YT/fWiweTMWmvuMI0uiVnEnWFPO+KliEz5lw6fIfBisL46IL2TqxYQZEEVaDZXx4e3G7KsW9mXYfyRnTShR5se+leOmwfHSE2RAgiqSK7QXV5g5oSy7wfdKsjAhrRTEsU11a5i5uc1XkH/qlrGNDwHFVHAkL/iQ1LbGqs7RWRFddX6a0qLm0fcvA6BUVvEZooJcZArKl9MFtXLPlYspJXNLjSmlhRru+cY6s/If18vBLcdGBFse1CtoLOACGsXuprwwHU1l24kb7t5s0jTn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  6 Mar 2026 16:05:35 +0000 Dmitry Ilvokhin <d@ilvokhin.com> wrote:

> Use the newly introduced zone_lock_irqsave lock guard in
> reserve_highatomic_pageblock() to replace the explicit lock/unlock and
> goto out_unlock pattern with automatic scope-based cleanup.
> 
> ...
>
> -	zone_lock_irqsave(zone, flags);
> +	guard(zone_lock_irqsave)(zone);

guard() is cute, but this patch adds a little overhead - defconfig
page_alloc.o text increases by 32 bytes, presumably all in
reserve_highatomic_pageblock().  More instructions, larger cache
footprint.

So we're adding a little overhead to every user's Linux machine for all
time.  In return for which the developers get a little convenience and
maintainability.

Is it worth it?

