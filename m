Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B89E7CD3445
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 16:00:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29C296B01A8; Fri,  8 May 2026 12:00:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 273E66B01A9; Fri,  8 May 2026 12:00:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1625F6B01AA; Fri,  8 May 2026 12:00:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 088A56B01A8
	for <linux-mm@kvack.org>; Fri,  8 May 2026 12:00:12 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BE6308A866
	for <linux-mm@kvack.org>; Fri,  8 May 2026 16:00:11 +0000 (UTC)
X-FDA: 84744714222.18.6F69869
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf21.hostedemail.com (Postfix) with ESMTP id 54EF61C001B
	for <linux-mm@kvack.org>; Fri,  8 May 2026 16:00:09 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=MokCdbdl;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=GpCyBlHu;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=MokCdbdl;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=GpCyBlHu;
	spf=pass (imf21.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778256009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LXVVyze4kx8kMS2s6zXyMtskN0p+eWsbnQJaLtfTRVU=;
	b=pDwe+BhgFjkJAjTvA/RiID6PnZOc2e3IcNAz7Sw5gM+n0/Qf1z+SwLhYcJeMMzf4wvcyti
	HU9uwh5mw/pO9/drq2c56KhPQ2nP9Qf5G1J+ex7hfgCstNZ2UI7FCsk4IwybUZ8uLwbmcV
	nsFeRDKGVBcu9wwmqRqBnzpFrtZzFX4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=MokCdbdl;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=GpCyBlHu;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=MokCdbdl;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=GpCyBlHu;
	spf=pass (imf21.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778256009; a=rsa-sha256;
	cv=none;
	b=7XXPm+CedUzaKdG/8T84PyIH/UZ4td3EhynXzQwA3HSba8o17RBnyktkQeKRW+bkVpzklY
	zTMwrFJsKcITZwOwmW2YQR5D2PBIsPtIXxw4QvvWMsml+IvwoPCoUGhA6AQhWhXG1DTUvZ
	8K/+hlYhwCgxVJ2mC9AIt48dAQw99cs=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 790DB5D298;
	Fri,  8 May 2026 16:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778256007; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LXVVyze4kx8kMS2s6zXyMtskN0p+eWsbnQJaLtfTRVU=;
	b=MokCdbdlVqPFyLxx06jdq1XDoiO9YnmmR9DeOuFs1hxz5a8sWcfgScqRrFqSFR1fhlx7cn
	M6aF/AnbmBIYNIum2n/jIjGgXQsTIwTR27dFFmF8hMoA6CIWZqIDbv+1m19htZxqYgRrhA
	keJUvKVmMFpUaX+QmhFE4w2V7HowfWs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778256007;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LXVVyze4kx8kMS2s6zXyMtskN0p+eWsbnQJaLtfTRVU=;
	b=GpCyBlHuo6uoF9mfSynsoCqUCL3NqOVk7ALy1192vBbEFlBRpm9LSRXp8AVG2sGoFwcSbx
	WKBa8+8otTAbkiAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778256007; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LXVVyze4kx8kMS2s6zXyMtskN0p+eWsbnQJaLtfTRVU=;
	b=MokCdbdlVqPFyLxx06jdq1XDoiO9YnmmR9DeOuFs1hxz5a8sWcfgScqRrFqSFR1fhlx7cn
	M6aF/AnbmBIYNIum2n/jIjGgXQsTIwTR27dFFmF8hMoA6CIWZqIDbv+1m19htZxqYgRrhA
	keJUvKVmMFpUaX+QmhFE4w2V7HowfWs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778256007;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LXVVyze4kx8kMS2s6zXyMtskN0p+eWsbnQJaLtfTRVU=;
	b=GpCyBlHuo6uoF9mfSynsoCqUCL3NqOVk7ALy1192vBbEFlBRpm9LSRXp8AVG2sGoFwcSbx
	WKBa8+8otTAbkiAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3681D593A8;
	Fri,  8 May 2026 16:00:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id WXbmCYYI/mljJwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 08 May 2026 16:00:06 +0000
Date: Fri, 8 May 2026 17:00:04 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Vernon Yang <vernon2gm@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	roman.gushchin@linux.dev, inwardvessel@gmail.com, shakeel.butt@linux.dev, ast@kernel.org, 
	daniel@iogearbox.net, surenb@google.com, tz2294@columbia.edu, baohua@kernel.org, 
	lance.yang@linux.dev, dev.jain@arm.com, laoar.shao@gmail.com, 
	gutierrez.asier@huawei-partners.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	bpf@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
Subject: Re: [PATCH v2 0/4] mm: introduce mthp_ext via cgroup-bpf to make
 mTHP more transparent
Message-ID: <af4HYivyP7LDG2-k@pedro-suse.lan>
References: <20260508150055.680136-1-vernon2gm@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260508150055.680136-1-vernon2gm@gmail.com>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 54EF61C001B
X-Stat-Signature: oaiu4q61ei3ntorb9wy9m3yd93h8geo1
X-HE-Tag: 1778256009-461184
X-HE-Meta: U2FsdGVkX18ZXaoslN9OQjiSasCMZvYCpsgJueBwiI456uQPZBtJTQckKoM3y+vf4xyUUOU4ulxnndoCirIeBcG+GprYvRKqAT/6nFwZK4iRTRQySBAuvBlbyA5OrFOi9p22T38fIGzVZzSEKf7vQsNexdBbwXhFsDDcWyqrGNpClvvQsm5i3W4GxaRRBrAcNkyvOc+jyCJRYjaV4MOxctKIqFv3XzJMZpAL3zfqfywUQW+zZ1CKYBWXHV/G5Pi9zr4hgWSp/AN81Mtwq5tWfcQ7GEcuSos+KXCXZg8PB/+6xvll+YoNV1gEKWnyyXD2ftajCCV9bMJn9bmCWP+AA3V8QiryBB7cIrL9Yhyy77bMH3009lUVxqgJ+8KOAdNGsxV784G4/sBRNJlOV4ZhMxt73behrbcCviMYY+AvgvyhgoTgND+k1ue40ibJu/55+mo6DYDinqe2wuHflJjButFs9qyFoVcIJs7P6/FD5xD6USDl2QJEQQhcg64h45M7iZLzSgF8VHi1izpTW3TVDGGCL6JBlN3dP9vI7d0QiU3lnjf56ZMP1NQvMw9C3AgnRiaZcLJpinKJNZbY7Wt8ZQ2Uw5q4GLKvMCJMXN7zDhaK5Cb1Z5BG6U6X2mOvPMzVo8zNiJzwISBUiy2dIL/bMHIZwRzao0BxR8CKB15m3TTEzTGdEtjMBBNkRZx47q7oKz+yZaxP5pPO1rscwoxWtK+T4BqvS+4b75MQMbIA1hBOvpn/w76lbKIJJTQMM2H+dYJOWSXklrBNOrRoid4OLMwEdbd4q7ctz55MWf+FkJbAT9Qu8QMKg7vbhgIYGj7WBxbgjhaLtC4OGlZC9Mjui9fo0ez2AedOJ+nk3S4WjzN00YFhdKIwXjAMw9Qr8d1D5eLvSp503MRVscLpgiG9Z1QkaFipV2Bl7SP9KTVdh5wUq49IkzOZGkrSa24m1J+E9z3W/GDSwRtC1/X+406
 9OaIrrgX
 tBSV+nXRXs4BUwWCbB6ijLRxizFoJDqLAtvV4wTYcU/TxtMoPyOiX6NYyvuyJ0IlM3H62drnL1qncTEbH0lMEcsKW21+4t9xBOUiFm9XCbHryMZtGTQRa/XD/n1HNrZIK+xBrls7/dE5OLRyBaD0WxXr1j6br9jDN72v9uuqLsUemEmQIqChRgHZCXoU7ldynCNH1oEcQwypPqQ1e3U5Jvdy4Xl8Vypn+3wAZekywxWwi//QlD7pUMTGlw48EMJpJOzVPjhHu5I+a3q+0dMNK9pkKZEQ3GoJou+DdEcGUzYnFJCpXsx/j40bZN7xTf14m+oIZT9mzHhW6wGSGBBkfvZiwdcnMsWM+EoS/DNHSTK9Spqn4nKdX4ZlU29NTayI5SyMEqv/fs0q+m0C2fWfsqxfs0w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 08, 2026 at 11:00:51PM +0800, Vernon Yang wrote:
> From: Vernon Yang <yanglincheng@kylinos.cn>
> 
> Hi all,
> 
> Background
> ==========
> 
> As is well known, a system can simultaneously run multiple different
> scenarios. However, THP is not beneficial in every scenario — it is only
> most suitable for memory-intensive applications that are not sensitive
> to tail latency. For example, Redis, which is sensitive to tail latency,
> is not suitable for THP. But in practice, due to Redis issues, the
> entire THP functionality is often turned off, preventing other scenarios
> from benefiting from it.
> 
> There are also some embedded scenarios (e.g. Android) that directly use
> 2MB THP, where the granularity is too large. Therefore, we introduced
> mTHP in v6.8, which supports multiple-size THP. In practice, however, we
> still globally fix a single mTHP size and are unable to automatically
> select different mTHP sizes based on different scenarios.
> 
> After testing, it was found that
> 
> - When the system has a lot of free memory, it is normal for Redis to
>   use mTHP. performance degradation in Redis only occurs when the system
>   is under high memory pressure.
> - Additionally, when a large number of small-memory processes use mTHP,
>   memory waste is prone to occur, and performance degradation may also
>   happen during fast memory allocation/release.
> 
> Previously, "Cgroup-based THP control"[1] was proposed, but it had the
> following issues.
> 
> - It breaks the cgroup hierarchy property.
> - Add new THP knobs, making sysadmin's job more complex
> 
> Previously, "mm, bpf: BPF-MM, BPF-THP"[2] was proposed, but it had the
> following issues.
> 
> - It didn't address the issue on the per-process mode.
> - For global mode, the prctl(PR_SET_THP_DISABLE) has already achieved
>   the same objective, there is no need to add two mechanisms for the
>   same purpose.
> - Attaching st_ops to mm_struct, the same issues that cgroup-bpf once
>   faced are likely to arise again, e.g. lifetime of cgroup vs bpf, dying
>   cgroups, wq deadlock, etc. It is recommended to use cgroup-bpf for
>   implementation.
> - Unclear ABI stability guarantees.
> - The test cases are too simplistic, lacking eBPF cases similar to real
>   workloads such as sched_ext.
> 
> If I miss some thing, please let me know. Thanks!
>
<snip> 
> kernbench results
> ~~~~~~~~~~~~~~~~~
> 
> When cgroup memory.high=max, no memory pressure, seems only noise level
> changes, mthp_ext no regression.
> 
>                             always                 never               always+mthp_ext
> Amean     user-32    19702.39 (   0.00%)    18428.90 *   6.46%*    19706.73 (  -0.02%)
> Amean     syst-32     1159.55 (   0.00%)     2252.43 * -94.25%*     1177.48 *  -1.55%*
> Amean     elsp-32      703.28 (   0.00%)      699.10 *   0.59%*      703.99 *  -0.10%*
> BAmean-95 user-32    19701.79 (   0.00%)    18425.01 (   6.48%)    19704.78 (  -0.02%)
> BAmean-95 syst-32     1159.43 (   0.00%)     2251.86 ( -94.22%)     1177.03 (  -1.52%)
> BAmean-95 elsp-32      703.24 (   0.00%)      698.99 (   0.61%)      703.88 (  -0.09%)
> BAmean-99 user-32    19701.79 (   0.00%)    18425.01 (   6.48%)    19704.78 (  -0.02%)
> BAmean-99 syst-32     1159.43 (   0.00%)     2251.86 ( -94.22%)     1177.03 (  -1.52%)
> BAmean-99 elsp-32      703.24 (   0.00%)      698.99 (   0.61%)      703.88 (  -0.09%)
> 
> When cgroup memory.high=2G, high memory pressure, mthp_ext improved by 26%.
> 
>                             always                 never               always+mthp_ext
> Amean     user-32    20250.65 (   0.00%)    18368.91 *   9.29%*    18681.27 *   7.75%*
> Amean     syst-32    12778.56 (   0.00%)     9636.99 *  24.58%*     9392.65 *  26.50%*
> Amean     elsp-32     1377.55 (   0.00%)     1026.10 *  25.51%*     1019.40 *  26.00%*
> BAmean-95 user-32    20233.75 (   0.00%)    18353.57 (   9.29%)    18678.01 (   7.69%)
> BAmean-95 syst-32    12543.21 (   0.00%)     9612.28 (  23.37%)     9386.83 (  25.16%)
> BAmean-95 elsp-32     1367.82 (   0.00%)     1023.75 (  25.15%)     1018.17 (  25.56%)
> BAmean-99 user-32    20233.75 (   0.00%)    18353.57 (   9.29%)    18678.01 (   7.69%)
> BAmean-99 syst-32    12543.21 (   0.00%)     9612.28 (  23.37%)     9386.83 (  25.16%)
> BAmean-99 elsp-32     1367.82 (   0.00%)     1023.75 (  25.15%)     1018.17 (  25.56%)
> 
> TODO
> ====
> 
> - mthp_ext handles different "enum tva_type" values. For example, for
>   small-memory processes, only 4KB is used in TVA_PAGEFAULT, while
>   TVA_KHUGEPAGED/TVA_FORCED_COLLAPSE continues to collapse all mthp
>   size. Under high memory pressure, only 4KB is used for
>   TVA_PAGEFAULT/TVA_KHUGEPAGED, while TVA_FORCED_COLLAPSE continues to
>   collapse all mthp size.
> - selftest
> 
> If there are additional scenarios, please let me know as well, so I can
> conduct further prototype verification tests to make mTHP more
> transparent and further clear/stabilize the BPF-THP ABI.

How is it more transparent if you're essentially adding mTHP
micro-programmability from the user's side? This series makes it
_less_ transparent.

If you actually want to make it more transparent, then I would suggest
improving the heuristics such that (m)THP doesn't churn through memory
on high memory pressure. Or such that it doesn't feel extremely compelled
to place the largest THP it can based on vibes.

-- 
Pedro

