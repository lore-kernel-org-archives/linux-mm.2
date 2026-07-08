Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E4CBC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 07:55:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22F0A6B009B; Wed,  8 Jul 2026 03:55:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DF0B6B009F; Wed,  8 Jul 2026 03:55:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A69D6B00A0; Wed,  8 Jul 2026 03:55:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CF9B06B009B
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 03:55:23 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 59275140662
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 07:55:23 +0000 (UTC)
X-FDA: 84964849326.15.ACD9BF4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id B2324C0002
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 07:55:21 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mGcrgBs5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783497321;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FGLD0lBwBOza5qGEuYHyTEO5snzgDd2JCF7uerUmJDA=;
	b=YEpBbEW1ObAQ/+6ou2C63VRDk+Suf2CVYzP2SqTgLv1d6OdMsRDaKZjuV0fo54rnEVqpzJ
	ad6HfdHMD5HIL8NZxGHXbnVuJHC09BRsjnN1loL8U1CPCsqsKD8uVs+0fUr4Y6WNh0LSU5
	OaId8Zu16lE8tvEqW9xcfNKic+uAFTI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mGcrgBs5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783497321;
	b=i3vpHruiKahbrda1pesfokidm9tJEZIdACNsw+U8NRC3BsLRIcGj13iw+1zrzb/dXW7/tQ
	jOxMCqEGwCn169l//xVnSbaHGR6ulJSmlpSoXPWBfyfZ5YeY3SrLdueGfg5BFDJdGaoOui
	2iKCpeIAI44Oe2abeLpbDej1p8qDyuA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C1FF24041B;
	Wed,  8 Jul 2026 07:55:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF31E1F000E9;
	Wed,  8 Jul 2026 07:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783497320;
	bh=FGLD0lBwBOza5qGEuYHyTEO5snzgDd2JCF7uerUmJDA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mGcrgBs5/vg3Vd5SnHL7lqtCAfSCfHWs8GW3AEUmce9wsmWNv9ojKUWfDuosr3A2B
	 /9pUOQBlEzNtTgB+gLQ8GEnbi9ShdWvpKuXDqkEm899h0/1Ga+sR9Kiq0Iqf2FiJMo
	 wDAdqZIYR0utJM5INXn83bOaSZ3xyggKrKT+vwNJ5/t/Gb2agcM6NHcjq/ZvEV6038
	 y5BpkB6eUBFrSheOv3jiYSvx03nzO90M1tNHyKDiQzIsoWFIHUXEX0GrkbbzPaCNTT
	 6/IT4fwRhj++fdu8RM4V2hEiNk4FecbuMwGdIQ5anvuP+uyrhYNhuyWtPjEvo8byb3
	 5tb+Yx37WTMmA==
Date: Wed, 8 Jul 2026 08:55:00 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Cc: Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Eugen Hristev <ehristev@kernel.org>, 
	Arnd Bergmann <arnd@arndb.de>, Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Thomas Gleixner <tglx@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Anna-Maria Behnsen <anna-maria@linutronix.de>, Frederic Weisbecker <frederic@kernel.org>, 
	John Stultz <jstultz@google.com>, Stephen Boyd <sboyd@kernel.org>, Kees Cook <kees@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
	Petr Mladek <pmladek@suse.com>, John Ogness <john.ogness@linutronix.de>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Bjorn Andersson <andersson@kernel.org>, 
	Mathieu Poirier <mathieu.poirier@linaro.org>, Konrad Dybcio <konradybcio@kernel.org>, 
	Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Conor Dooley <conor+dt@kernel.org>, Saravana Kannan <saravanak@kernel.org>, 
	workflows@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-mm@kvack.org, linux-arm-msm@vger.kernel.org, 
	linux-remoteproc@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v3 19/26] mm/numa: Register node data information into
 meminspect
Message-ID: <ak4B8L57VDYFGGIh@lucifer>
References: <20260708-meminspect-v3-v3-0-7aa5a0a74d5c@oss.qualcomm.com>
 <20260708-meminspect-v3-v3-19-7aa5a0a74d5c@oss.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260708-meminspect-v3-v3-19-7aa5a0a74d5c@oss.qualcomm.com>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B2324C0002
X-Stat-Signature: dd5ndz3krzzh5c1bxwas1fuz5c4mokd9
X-Rspam-User: 
X-HE-Tag: 1783497321-947410
X-HE-Meta: U2FsdGVkX1/rKDu8z9nTBwebTAfQ617EJBgoKVyXaJ+tzRjwm24WNGvdkF44QMhllb6S+SfpB0b7a0IK3dF1xtTqd3J+VMKqDHDqI9/OnVzIcGapp6LABs9ZvGOmZucFZCWl0H2DtMQbAYWytaZBjWuIoaA8cxOB9IzfBVF+Aa/lr2xDg311ztpwCAEpS/aOPRAfAFyjka0niSD6CQDQ74i+uBHIhGTXTvZ/2KWTwAJj4oux5U6sFg3MGmEmPh6ngDvn7BilakqBVlht3DsbpzK1PrtY6nvR2Mosdpv0Cp10isqpGtlz8ndUU5FuLsC4Lach/i+W7H7OvFKe2/m0NY7NE/L90QpRCIdIQJ5PBnLeZZPRHXoehFueM6zNPb1Obrfbpm0pRnzSkN+UXUIVIvU9lFiv3t7LHxhm2tkloScRLMLCHb78qSSUbGxIz/PYpFkTw7o9kqEKxeKqeLzsPrcOIkM5a+o1xVcnD+reEH5byp978IkZVTeMkQqpZV6JNMFuBLzoaqyD1AbYxDlY/wZHWlPSFmxpMcUMFVwb+3nRx5KnlKZ6eXdBkbWDup7s6JLIswf6EgeAeQUrgc2/LG6yZqOj5bVa1YmWXzX+SHH6x63dZuuKqGI+KoZYmYK6L8KR6IN9AVI7xtLKGHxZKzeOSKm6wZcjfiVd333akylXx0G8XV2fehINzr6NCz1QLnoZTyXntPn9vZ+WguiC+Sk8H4rJ8CFiuH6UuKJss6B08DXgxmn9hupkGSjcbqkRz03wTUu5kOy2PDbRfHKiR2jrPImJWWpFv4vqnSTWxKR/raBbSv3LC1V1nrr4GkNsC9ZJYcrEfR5tJ/sjRBfgCTYz9YdiXCuYEHpcCPK80VuOivevqy4PSW+8Pm2zZxbi49AXgmWl5NlyUkNTJdclhd7RDBowFgSCU2vnKRbxq8y6EmMc6W6bEoCG3N3e771PiMYPnnPUdqJG7eYyFst
 zw26h9dq
 nyMJR8nsnfVzgf6fU3W2NVWWynsSpuVWQQf7nSLGY8Ku0vSqeqa0Q8hxeSM7LJn2CAq65/DOomhJw6RfBZ/wQVQUGpwcF/FXFi0Ux29lJQxg6a0FdP3wu4H8tooviK91oiGL82/n1GBbAeij7FWxQy+jFVUkV2oJ1iRzP4AFSC/HueZt5YFvHXXcmV4CZPdD7xrRL0wM/aF5sgyH1ZFTN54OWetfcqNEvInpmGX82pWm1k2WRWMu1hQPfw4BJryQXIXxU4w4PmJH7RSkqrRPTxp65q7eaw1Z5O1XXpG8pt0sXhOql8hyh+WxV03EU1RwoUIow65W4OcidIenSuRRUWCaYRSYCXlXTeq1sR/Zv2pxmwifMoeA+7uun81q3lWlUfyIws6KlX1T4j2boa+9gT5GA8aCyENmkMF+tEVpUSZhdKQKEMATwZsfDK1yRbgwX/m38
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 08, 2026 at 11:01:58AM +0530, Mukesh Ojha wrote:
> Register dynamic information into meminspect for debugging:
>  - dynamic node data for each node
>
> Use meminspect_register_pa() to collect node data into meminspect.

This commit message is a total mess, this feels like internal development stuff
not something you're trying to get upstreamed in core.

>
> Co-developed-by: Eugen Hristev <eugen.hristev@linaro.org>
> Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
> Signed-off-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
> ---
>  mm/numa.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/mm/numa.c b/mm/numa.c
> index 7d5e06fe5bd4..f04740dfb2cb 100644
> --- a/mm/numa.c
> +++ b/mm/numa.c
> @@ -4,6 +4,7 @@
>  #include <linux/printk.h>
>  #include <linux/numa.h>
>  #include <linux/numa_memblks.h>
> +#include <linux/meminspect.h>
>
>  struct pglist_data *node_data[MAX_NUMNODES];
>  EXPORT_SYMBOL(node_data);
> @@ -20,6 +21,7 @@ void __init alloc_node_data(int nid)
>  	if (!nd_pa)
>  		panic("Cannot allocate %zu bytes for node %d data\n",
>  		      nd_size, nid);
> +	meminspect_lock_register_pa(nd_pa, nd_size);

Not keyed on node ID, just exposing the physical address assigned to a node to
all drivers.

Nope to this.

>
>  	/* report and initialize */
>  	pr_info("NODE_DATA(%d) allocated [mem %#010Lx-%#010Lx]\n", nid,
>
> --
> 2.53.0
>

