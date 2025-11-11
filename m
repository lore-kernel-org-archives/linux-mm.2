Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE707CCFA1A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 09:55:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D9308E0009; Tue, 11 Nov 2025 04:55:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B1738E0002; Tue, 11 Nov 2025 04:55:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE19F8E0009; Tue, 11 Nov 2025 04:55:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DBF638E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 04:55:02 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7F35C591EB
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 09:55:02 +0000 (UTC)
X-FDA: 84097867644.16.76F3A28
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3B07418000B
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 09:54:59 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=E09n6Evr;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=rhHNp8rn;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=E09n6Evr;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=rhHNp8rn;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762854900;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MaNl3KVXDMb4yVsW79umxB3okzTjoLpsTH9fuEvuObI=;
	b=7y4sYtjXMN4uhvlLqjCPF8/3w+Wn2pmfYI0zZBwuHYnv3TywE6am+CGQHS0uNi7rHe0MGE
	2EQHGtW2ndMERXTEM2cTZvDcdZzNBPCm3dCQJAZFRZWidk1/euwDfWDITD3RH9yLwoKll5
	XoA7iaf4RnPUxEU93zLSnrERdrCy2vI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762854900; a=rsa-sha256;
	cv=none;
	b=pYXJ2BCfbohYE3YEcfGvoECFisJnljQZEX4EYbYcANI04oIeQjFGhjNG0PWsXHsYpS9XnW
	4b/KKzLlW5S3f6Ez2sywTINuA4pRUzrA1irxW9yDWPhTO6YcaZtrvq60LzU6nWe8V3/Zv1
	6uBwPO2GK2+Q/tdm2GMaUVdMqtoZxSk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=E09n6Evr;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=rhHNp8rn;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=E09n6Evr;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=rhHNp8rn;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9B07F1F78B;
	Tue, 11 Nov 2025 09:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762854898; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=MaNl3KVXDMb4yVsW79umxB3okzTjoLpsTH9fuEvuObI=;
	b=E09n6EvrRECYQ74NuyMvO0OrLOP2ePwW+yg6IHMP+jX5ArQukh3cD/rjuBGFXY63npAiZv
	G5DhvO2yOKiSHCocoTMjrGl8ALoLUvgjw8ye+E+14Tq94tOa8+KYZfA5BWjW5tC0pgsrsk
	RfK36xXh7UP8tZnpNN17NEc6uLBXQFE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762854898;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=MaNl3KVXDMb4yVsW79umxB3okzTjoLpsTH9fuEvuObI=;
	b=rhHNp8rnyr8L9iaGwd/FjyGBSDZK6E26aKNoCtyKQEe8YDg/hPhVEQBsbSuqf5plYNNAHa
	zMXog1G3h/miPPDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762854898; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=MaNl3KVXDMb4yVsW79umxB3okzTjoLpsTH9fuEvuObI=;
	b=E09n6EvrRECYQ74NuyMvO0OrLOP2ePwW+yg6IHMP+jX5ArQukh3cD/rjuBGFXY63npAiZv
	G5DhvO2yOKiSHCocoTMjrGl8ALoLUvgjw8ye+E+14Tq94tOa8+KYZfA5BWjW5tC0pgsrsk
	RfK36xXh7UP8tZnpNN17NEc6uLBXQFE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762854898;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=MaNl3KVXDMb4yVsW79umxB3okzTjoLpsTH9fuEvuObI=;
	b=rhHNp8rnyr8L9iaGwd/FjyGBSDZK6E26aKNoCtyKQEe8YDg/hPhVEQBsbSuqf5plYNNAHa
	zMXog1G3h/miPPDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 740DF148C6;
	Tue, 11 Nov 2025 09:54:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 01KAG/IHE2mYCQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 11 Nov 2025 09:54:58 +0000
Message-ID: <75656c78-7e42-4a32-87c0-373416adb4a8@suse.cz>
Date: Tue, 11 Nov 2025 10:54:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] memcg: cleanup the memcg stats interfaces
Content-Language: en-US
To: Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 Qi Zheng <qi.zheng@linux.dev>, linux-mm@kvack.org, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, Meta kernel team <kernel-team@meta.com>
References: <20251110232008.1352063-1-shakeel.butt@linux.dev>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20251110232008.1352063-1-shakeel.butt@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: i55pam6ydg55493a3hyjizjtzfyky97y
X-Rspam-User: 
X-Rspamd-Queue-Id: 3B07418000B
X-Rspamd-Server: rspam10
X-HE-Tag: 1762854899-775544
X-HE-Meta: U2FsdGVkX1/A81ugcIOnVONLhEbHVxLT0RMJ81Hs62Na0bmoQzDsIakpClGRuZERufLmV1JBGa0teZ8OJmUMu4vLJcfK+UN3PRcE2V4yJOGsSJnSBSNZyH1Q/pqTtxkMaHW0FSfMBJk8ScFv8ig/EZJeEYyCHUnJEKh9ak6MIZXSxyZ8tiLHQpsB362WMKRui8DS1Hb5U8h9csiFAz0jFixwwGSlKWdle0+Oc7f8RLVPETRDPMnHlFLHw9ZPJOSoQefGhwryP08CKoy0uxSy6zojv70CsxqOcBw9czojA2ds0pLOE6O+WC/VGio0GT5Om8CNw/PnVB8Ie35Cz3qzZa7wLfAEi0cfl6JvRW4Z0zxFS3+zUQIFaC4XqIEqlA0AgpaeN1vH2rBEckjJ4i58vs4gdek2uPCwbLFPct0hxwnf8p/7Y/IioEuV082Hn/UhhxX5i7L88HI5bDNqf18aOE+zA6+iAN+6Sa1Vopf0Cr3GdNA27rbAYh+tumDGh3RyBXt2XRLPVQYrsUSiQ4tczTs6YJXCPUohII9ui6b6og3kWxgZ+V++J6uoFjC+mvEdNdUToYUh97cJ5+qWS40w3+w8o1/xyi3U6/BnwrXSnOPzsfvzdW9yww/HC9FYwTRgYYQgnkV+woEzgbp8560b47ujTPWlGqdNCb4LjVHfqlnD+n+tEjSqY+Zn+uD1E0XgDAfjHWw/6PtTZfOjhmWlTW9yLPUI0GbD/+fN/Ph6IBJl/Hep96VBJsmp05P5QYYfTcsqMHf8FX2j1HccYAkEpp625OjNGen+QOiqxgzPGf5eEonPXiU+4rI2dMUrU+BzIId7FE0nlR7syGyW5Yji0IPzyH8k5PWnrNW3EAPD0fnrh2Icz8hbAO9U6E8Eo0pc0rDBV9n3RGft9EVmbGp5Rt2MQBeqjPNx71Jjsz/mWGapokoefJTz2A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/11/25 00:20, Shakeel Butt wrote:
> The memcg stats are safe against irq (and nmi) context and thus does not
> require disabling irqs. However for some stats which are also maintained
> at node level, it is using irq unsafe interface and thus requiring the
> users to still disables irqs or use interfaces which explicitly disables
> irqs. Let's move memcg code to use irq safe node level stats function
> which is already optimized for architectures with HAVE_CMPXCHG_LOCAL
> (all major ones), so there will not be any performance penalty for its
> usage.
> 
> Shakeel Butt (4):
>   memcg: use mod_node_page_state to update stats
>   memcg: remove __mod_lruvec_kmem_state
>   memcg: remove __mod_lruvec_state
>   memcg: remove __lruvec_stat_mod_folio

Acked-by: Vlastimil Babka <vbabka@suse.cz>

> 
>  include/linux/memcontrol.h | 28 ++++------------------
>  include/linux/mm_inline.h  |  2 +-
>  include/linux/vmstat.h     | 48 ++------------------------------------
>  mm/filemap.c               | 20 ++++++++--------
>  mm/huge_memory.c           |  4 ++--
>  mm/khugepaged.c            |  8 +++----
>  mm/memcontrol.c            | 20 ++++++++--------
>  mm/migrate.c               | 20 ++++++++--------
>  mm/page-writeback.c        |  2 +-
>  mm/rmap.c                  |  4 ++--
>  mm/shmem.c                 |  6 ++---
>  mm/vmscan.c                |  4 ++--
>  mm/workingset.c            |  2 +-
>  13 files changed, 53 insertions(+), 115 deletions(-)
> 


