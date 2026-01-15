Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6D83D46638
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 23:39:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BF1F6B0005; Thu, 15 Jan 2026 18:39:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1973A6B0088; Thu, 15 Jan 2026 18:39:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C3626B008C; Thu, 15 Jan 2026 18:39:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ED8596B0005
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 18:39:23 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9E8731A0161
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 23:39:23 +0000 (UTC)
X-FDA: 84335817006.18.454073D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id EFA0814000F
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 23:39:21 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=RAxIlLnG;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768520362;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KxtUx3jmroJ8DmPSGCxms6jieBO1uQL8tVM/95RBZ04=;
	b=DfYWseRWxFnfGlVT1F0rDl8tVi0dsPKxF7V/ktzhH5DCxPpsnLOqp/FTQqeGDQqfH+8b7I
	YEpLNRU4BMnJN7I7MzxzDaejUoR4eJx4cLFDeFpt9Cng1XnruX7P7TuOLm8NC8GClEvQdL
	pgZUMz9osW4RXQEhEIh3x2uqXvpkmAw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=RAxIlLnG;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768520362; a=rsa-sha256;
	cv=none;
	b=SOjc8eBXMhKY30rFHBSbHV/lNffPOV6cVqo1u8NTsO684nDUysyl2vVEjFS/fn4Rdj0Ve7
	UN/atIZO7EvEcb47ya9001hwNwtsXbdL8rs/oebOY83fx12A4VGrmLxqK4b+rlcyWI4QNI
	9T5848nmYnHhTJBHv36N9Zq/4W8/54A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2ECD360130;
	Thu, 15 Jan 2026 23:39:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3450C116D0;
	Thu, 15 Jan 2026 23:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768520360;
	bh=KCeARxCrKeSqaMItrCLAnyFOC+geLL3gQ/QCeIKrP0M=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=RAxIlLnGNLMCPBtrDZMsUIEU3zhooo1hJa7Hoq355FoDqojW0Bh8gt7tyyySW+Bh9
	 29+Kl8v/FsTalODBJZQkPo3vx9OL1A+3innwvH4FZaP4W4FeGKNc0wwbPHN4v1ainQ
	 QV/JuRm+LyKKabK+9C+1KjxCyToZ3vd4L3BsizFs=
Date: Thu, 15 Jan 2026 15:39:19 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: linux-mm@kvack.org, shakeel.butt@linux.dev, David Hildenbrand
 <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Axel Rasmussen
 <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu
 <weixugc@google.com>, Steven Rostedt <rostedt@goodmis.org>, Masami
 Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Qi Zheng
 <zhengqi.arch@bytedance.com>, Jiayuan Chen <jiayuan.chen@shopee.com>,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/2] mm/vmscan: mitigate spurious kswapd_failures
 reset and add tracepoints
Message-Id: <20260115153919.6c3253ba9e81d57efe2d4716@linux-foundation.org>
In-Reply-To: <20260114074049.229935-1-jiayuan.chen@linux.dev>
References: <20260114074049.229935-1-jiayuan.chen@linux.dev>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: EFA0814000F
X-Stat-Signature: o3bei3gd1i4bru8r5r3p16urqr56whse
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768520361-89283
X-HE-Meta: U2FsdGVkX18LBhocTYcSSNt5bF2GaFuBj1GQXaOwsI4Ust6Debw3YM3a4hvabAbPSjLExwzR9+HUHMrEhDprQJSFiZePGppOMCFPqirMdFo+lsj+X3nAxeA2qRfsbLjTE2Z6tiHEYXtyMZdpLQOOt72pYkcuiyid68qD82SYbiC/ZGoArVLfov8CEEGcsSS5W8n4Dklp6MVZ4pypKwM7MHyZtkpI1C92bAtDRa6odsib5zeykQpd396WWXYPmpqNmsBk6lEX4urltb5cSTJM28AFnZxszYlvDmYCeHhmP/86wTD5gW6NCSX/1iU1+TeeGSRHMctIOgsgpjo6oIC2tp0sHiGzeCNKkCn7df48u4qknVDL1KbNs1Q5MuPCb254DjTK4xWZSdoxoJR6FpvPSor6msFVHlCHiYGLOaMUJHqHwJzd6EM9wgDRTlEsi6JdxqqA3rZbfPrRddmVaXCXSonnFRAtnb5qfJDiagOqGRB4BHo2FHhsl10HHplBSbKUrRAWNrmhajpqji8+EhPJLi0543+5+cwe8Fow7nBJKFoxudJh2/aE+ylPy32CEdUAz+MqxPr3qve03mWKrzo2GVwxWQG9p63Jk/Vcp/uV1QRH9Pe0tLZ4LD+O9vGmu7rg0ZUptwa9HXkqRfkb6ULHIEUQ2+Zry/KugfJbeGzC2sH5m2oby0Cfb828z/fdlqRTQ+Z8Gz2BMp2JoS7Vvk7+mkqZPneSVvOyT+9MjYOeSyocI3fqmrkXbRo1f29ruwp3NgR24Xar235XMmy7H4ltqtgwIzdH3fF+ByigI4CaPMOBK9g/MVx6+7ha3E5CCE304aBNZPlGYIYoClZKq3h5g4jiJQBqB3jAPkAemIIDEPR3v71mNJyrs2Mm5hTQyrK13rEA8Uwxg5SXJ2uk8o8wV7VsMbzeR+yswDYfVZkEaHa3iTLb7TZNZuMkhjYOSW+feo8B4k6BuCMeG4V5pHe
 HNCrOkKv
 8GrulHyyKRrq6xUKZXT78DM9JK10MY3l7ZJwRkHhMDFopd9LypsY8yRniCaVuCx4oU3Mkq+7mzh/mE8uOZyx76xqY7rt19nkpFS7I/fgu8BEppr/JHGXiV1kdpcOO9aZMERPUuQYFpr7/VHuLR9zcIjpOEBKiP25zJ3oClnC45PeqO3GBOO9Kben2SArSyv5qBlOrY4meJoLvGXOUSoFCOiRJaPDvl/c8G+RsIDMjXg3/oEthUqZIQtW4IFJKm5kkmn+yIm1iUGw1p8/7HFNdoy0zJEj7lkzJ8Rj1hdH3RI8AQkE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 14 Jan 2026 15:40:34 +0800 Jiayuan Chen <jiayuan.chen@linux.dev> wrote:

> == Problem ==
> 
> We observed an issue in production on a multi-NUMA system where kswapd
> runs endlessly, causing sustained heavy IO READ pressure across the
> entire system.
> 
> == Solution ==
>
> ...
>

Thanks, I'll update mm.git to this version to keep the series under
test while Michal and Shakeel continue their review (please!).

