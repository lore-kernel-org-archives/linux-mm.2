Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1F42FD9E2A
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 00:39:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 074876B0282; Thu, 26 Feb 2026 19:39:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0216D6B0284; Thu, 26 Feb 2026 19:39:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E62606B0285; Thu, 26 Feb 2026 19:39:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CE86A6B0282
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 19:39:01 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6DB5C8B61A
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 00:39:01 +0000 (UTC)
X-FDA: 84488376882.19.665C3F8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id A490A40006
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 00:38:59 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ldWMfqkG;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772152739;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RcBUk/Lxx9h4oV1cf81UdABmtuVUCIovtK5HeAfFVSE=;
	b=8LUI4RRiFBYPPXTZcQAJmcIPnQySsQ/ywzGv4aVwwE5hSOAu0PVfXY7cd/jlHnul2RTUIl
	5FnQC+DpDhMUcnKsb4Td9YnZvOX+3nL6R84dQ3ayPlqjdv2WwjytC82OLqNHcy2hyhJmr8
	MBi0obyyiXGaFGVjZaYHOwTDXzfw5rQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ldWMfqkG;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772152739; a=rsa-sha256;
	cv=none;
	b=KmXo5DlT/NT/5xbsUse+f2AjQSMAtCLclM+wk5f1DPGwmmuUI1rYF5dNkBGuiknHJqpvML
	t05ko5LwgFY8VP+LM72QC5eRZEncPrAIPGAFrT7SmMTt9Vm+fgYnKeVqb2ZCkIMoy3ui9x
	Vxlf74vCdkEbcvpHMpoD+mo18HnEi+c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5F25D44377;
	Fri, 27 Feb 2026 00:38:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 610C6C116C6;
	Fri, 27 Feb 2026 00:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772152738;
	bh=+zLLB70CAty+NdETlp4hLlKF20g9qfS3WT0A330lBlY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ldWMfqkG9pksWV2DpVwALltLFNKX6kPDCKJYXDlvhpFSpcb/KGrwW2ZGbCqdU/KC6
	 1UHlKZ8lac4iujmDTjndN0zlJ3cQSA98jQZoUtrMbNQOzkpiNRMtmJA+8YZY5LINn2
	 PAN1K+BA4CkZH8vnH01jHbuH/9pkXekDuek9QKdDNocl5yT9iTunq6bGtgzy8uGHPY
	 4ene5f81tWwTdyqJnboEV9c9TdFff8XZ5ToEXlAJg0EjeUX2Wc9+Txm9qtO8zQIb7X
	 P6LkIPvANC/fgLSUMD//akSJDsWHCo/uk5hRwTlUHQZbRSsNr1l1QSHz1LNafpDpiP
	 fXCdY0nuQv4nw==
From: SeongJae Park <sj@kernel.org>
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Oscar Salvador <osalvador@suse.de>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	kernel-team@meta.com,
	Benjamin Cheatham <benjamin.cheatham@amd.com>
Subject: Re: [PATCH v3 1/5] mm: introduce zone lock wrappers
Date: Thu, 26 Feb 2026 16:38:55 -0800
Message-ID: <20260227003856.83271-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <5bcc39cd3a227944d0fbe75ff86cdac92b38d4ca.1772129168.git.d@ilvokhin.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A490A40006
X-Stat-Signature: iats5zyff1z19xxonja5jq7peu7b6wno
X-Rspam-User: 
X-HE-Tag: 1772152739-11954
X-HE-Meta: U2FsdGVkX19Uc6I+ZNleD6zrMHWUnQlznFSQ5lL8gniYRsfzbgFeMTLCdo43IgdKgBg9M4umItD8XV45jcWhs4hMYJtsE+Mq4FNuQIR8z4WC2HkLYGraKKVwD8yAsIqRVzGHG6Dsv1fEndf7FSBoGT5HzhLNUfy7ncXxYuOd/PEofYZVMhlZ4Tpv2PHz9an7YZaQCYgFNY0Ve9qSuVKPf8smcLKRuwWp4+vLfwh6JbuHY0+0h6e/svZXL5J8zCNVP68LpbxIt9ZFrUKOQAjX/lwsdwuQUjJxbyF2wOY5SZATP3MM8wA/du81jQKFTF5BMIClpxOK8DhSVUNAM3x09WzWS13UQk7Mva46NQMoVTWIrTYJXdWF8ku3IBOOYNf57zJ854t9yKk6n59RpDy9z2w82sm5pFIzZOs74GmBWAdympVF4F+uDCyS5Yny5WVyQluxPvziPKFVeZ/0DsXDTNzyo2HA/77GdNL6gh0H0/yVL8srAbcMGAnFAcfoCYatjMblK4tQ4Tk08BI0e1cLIge9xw3m/aF05sdF/mwKq3V94HOu8i6SdWIWh69xJVMRXbx1A6uYP31gmIjSaHp7JqFsUQkbe3MZer8/8LMw9t+EGKkZMK3aC1P1NsZ2eJdl2UHpsj2OSg7LlSf50mbGbkGwfbkgn7HpqLy1nKYTDHN1PTv+/oA0kyotSlwK01qc/YiYAbleVL30C/LUdVtsouOF38O5AiIXCYzj+h31ttOz4r24GYPjaBZIykQVIUWClUkLX59u9t1RJ0FEp2m2HtOTwlG+aKrdA2koInd5G8qjX8W/uc+LKcL8VUoXD6O2xjpSCU86iRRef4aPcsfQP+DK5oG1HPJ26MYmkmF5iuWhXW0cabbJ8jvVLIujUDuyCDZ8yHOhnGXPi8dryWzWjAe0MhL/AqP4Mr6NdWTJ54EaG/dtyU2dZ4VOcfRypCOKYA894wZBOg0mQkQyOm0
 PNcPrb4M
 ND4XJi+k1YWSHG4PIXj5vERm1jR4P9puFMlFpCftqqjvPoKCvklnzsVlS6uM8OSbtr8bS3421aHbC0FKoj8crOepCAxWAXk/ETTdqusXWeWiBVg4yk3Ol4e12FtIO8OjnaU2iJsD+0QXt0kqZ8CPTKtENiPcurKXr3nyYLu7Orx2vdXyC9x3PFHX2gplps7X/yYt4uzGUvMop410m2f7h4mfyd5jNpuNNxBzTO2kMBtT+UDklGO9nvqr3lZAVvIJluLGqbkIbrDNTUtAh7fHzWflCgVU4+Es6AnzfyE40AcBx/2YB3aEoIWmigA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I should sent this together with the previous reply, but I forgot as usual,
sorry.

On Thu, 26 Feb 2026 18:26:18 +0000 Dmitry Ilvokhin <d@ilvokhin.com> wrote:

> Add thin wrappers around zone lock acquire/release operations. This
> prepares the code for future tracepoint instrumentation without
> modifying individual call sites.
> 
> Centralizing zone lock operations behind wrappers allows future
> instrumentation or debugging hooks to be added without touching
> all users.
> 
> No functional change intended. The wrappers are introduced in
> preparation for subsequent patches and are not yet used.
> 
> Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> ---
[...]
> --- /dev/null
> +++ b/include/linux/zone_lock.h
> @@ -0,0 +1,38 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _LINUX_ZONE_LOCK_H
> +#define _LINUX_ZONE_LOCK_H
> +
> +#include <linux/mmzone.h>
> +#include <linux/spinlock.h>
> +
> +static inline void zone_lock_init(struct zone *zone)
> +{
> +	spin_lock_init(&zone->lock);
> +}
> +
> +#define zone_lock_irqsave(zone, flags)				\
> +do {								\
> +	spin_lock_irqsave(&(zone)->lock, flags);		\
> +} while (0)

checkpatch.pl complains as below.  Should be ok to ignore, but, may better to
kindly make it silence?

    WARNING: Single statement macros should not use a do {} while (0) loop
    #116: FILE: include/linux/zone_lock.h:13:
    +#define zone_lock_irqsave(zone, flags)                         \
    +do {                                                           \
    +       spin_lock_irqsave(&(zone)->lock, flags);                \
    +} while (0)


Thanks,
SJ

[...]

