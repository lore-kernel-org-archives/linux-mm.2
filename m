Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F994CCA476
	for <linux-mm@archiver.kernel.org>; Sat, 11 Oct 2025 18:28:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 979E68E0006; Sat, 11 Oct 2025 14:28:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92AA18E0002; Sat, 11 Oct 2025 14:28:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8402D8E0006; Sat, 11 Oct 2025 14:28:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 746BB8E0002
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 14:28:24 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 060B987F1F
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 18:28:24 +0000 (UTC)
X-FDA: 83986668528.18.A343CEC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 65B5AC0009
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 18:28:22 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=AfBnhG7x;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760207302;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zaa9ob2Gc8VfTWIIcb5czAvOx1Y9VyhgIMC1bISdV2I=;
	b=mkTfZAAccdV/I50edYXYYa2LbjC9Fn8gpWCJ8s87T9aF+LQFioCPVhXezFw4HDbLzjlCCq
	N/+RtY0xwPX5KN9isLk0XLv1rum4/z/0i9W4fyDcNZentU+jPNOb3rDZbKiqaVVyvJJm9t
	jo1C54c8+sDkHjswnhTzfbf46wy5lsQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760207302; a=rsa-sha256;
	cv=none;
	b=fIazqfW6FngCtwVQsGoQvFI5pP1h2o6tzU929RIYgD42UoFmTJDRVIjo5ocxFO6EtRXEaJ
	qf1zA4iDr0jwQQSXGe9tANpZcUT2xQK8wrnOab5JRm9KVcZC0jIPIdUaeNUQAWC/0Kx4O9
	c6/GExqD7fw56pRkEtkqZIlixdYFmMs=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=AfBnhG7x;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B85B96038A;
	Sat, 11 Oct 2025 18:28:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8115C4CEF4;
	Sat, 11 Oct 2025 18:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760207301;
	bh=FgUWvbT3ZDva6ywfxCHqenEXxBKR7Oh/eD/SLOX+5Yk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=AfBnhG7xlmLmfVUbFGyjQ78bq1XHYdU9flYoPoaBuGBTWGnKucM2jmCncWuX7rT71
	 FlTSAz4fuLUwls7McF1/JtXOxaFcu7efZoCive7juPExhTihyq837YdT4cuC3G8aUc
	 dD5+OvKwL0z2YPpBYYro/adbqLfXaRiZQllp+pP8=
Date: Sat, 11 Oct 2025 11:28:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: Zi Yan <ziy@nvidia.com>, hannes@cmpxchg.org, hughd@google.com,
 mhocko@suse.com, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 muchun.song@linux.dev, david@redhat.com, lorenzo.stoakes@oracle.com,
 harry.yoo@oracle.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v4 0/4] reparent the THP split queue
Message-Id: <20251011112820.0bd349399187a5eb662024b9@linux-foundation.org>
In-Reply-To: <4a134193-ee55-434c-98a9-ca3052bab11b@linux.dev>
References: <cover.1759510072.git.zhengqi.arch@bytedance.com>
	<925E0247-2976-4D85-A8AA-E8C92C64CED4@nvidia.com>
	<4a134193-ee55-434c-98a9-ca3052bab11b@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Stat-Signature: 19h544syzsydbnhgy9ida49p5bcf4dt8
X-Rspam-User: 
X-Rspamd-Queue-Id: 65B5AC0009
X-HE-Tag: 1760207302-970594
X-HE-Meta: U2FsdGVkX1/MmZquF+4sbf5x1WBzB5vAGN0GNUdGcTUenOUaVdCYRu5r4Og0+OLHEm6C3zk1adJc5zAbCsxcnn0XYmD7HBXQlKqle0jLo/Z4PWvpZiqeWk35sIH+q7pGpHwPc+g/YYdMSM0IJ/HoAFBPJLNBXX8Q3N9C1G33lIYIioChurcoVpBYjkniZb1QmVqWs83N2astmKWvRl/GaXkjjVm1rlopwHe0LAG//Cj9C2+PZkpjH7Lr9Klcl00DtCMernzRphE+q1iiHvY5e0zatZ3gSznnzNI/k9iotch4pzOLInW7vBjMhMFQt9/oqPG9MwpowTYSIFBCau1HresbRMraC14pryvtD00roXNzec9QXePWsPnVAfMxAsjwGu+uFKyhM54jYmlN/89V0npZXZzxgiWWlqCN9GlFur535s+xpD1JOIcbmf3NtmhqfQ0p6QJOvM4w4XiV//soxuwmTFLK0FfJVADTaZ2aCT27IDuyQ4Y/Ru9f70SurlH9m5grQKDOF4B1PfDX4TX0EkduWyhj0jADSiMhmQ/f64ra+8iGj/hQjctEDg33JBGo1/RSxGnt+DJtw0JnJvr9cH2hU0MQv1XlaKylro1WNUMCsWE4k9R/vneZdFnkA/1xbHLerZPmKccdIUPHtrrTNf0JA6zx5o3dwy+7c9MH/WToiE0vdG2ovAYbpRa2kQdXaMUNGF0opPTAeqXMEPa/ZpVrjpmOF17zCofwHHZis9s4RtEeK1fxtmk78rznwZnclXp4QooIYB4Zwn+W0hfW0iojCqY1XJWxS3M6x0AyDNhae6Zer/FAbZblOfW1stPyY9PPQFvMyb4UptUBMiKBtGPpwRQFb1EHwrqFzK3W5n6eXYAtPD02Z2IZ5+chyRhfBJOLWK3T4UMdwOWbhLJXkiqmTyErod5xNBduAADtWSILC2JsCp4K79XLWTWl4LZVGP/lnfV6gWSVlJkxwob
 0JZPTCEx
 UNWic889NQyZUTQhAF0sTco3X/EeNObQ3rpQ9BqItNfYXAD3SopcT07b4mjrHHG9iP90SjnlkUQ0VgJM7z5cZJbvAE3fHUKf5lq3oLUaMh3oCVzX9dreMWDXaopPE5zO75Z9tvIwkP9cqN77Ypj4+ochlJanryqlex2eb3mLlS0Vg3pspCrt8zJ1eq92vGW10wSozsngq+Cmu3+5WeQ06+sXChEMnM/k1FUDTLIoKb8BK9PK0lJ1UFq0Uyw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 11 Oct 2025 08:51:21 +0800 Qi Zheng <qi.zheng@linux.dev> wrote:

> Hi Zi,
> 
> On 10/11/25 12:25 AM, Zi Yan wrote:
> > On 3 Oct 2025, at 12:53, Qi Zheng wrote:
> > 
> 
> [snip]
> 
> >>
> > 
> > Hi Qi,
> > 
> > I got CPU soft locks when run "echo 3 | sudo tee /proc/sys/vm/drop_caches"

Thanks for testing.

> And hi Andrew, please help drop this patch set from mm-new first.

Gone.

