Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8095DD116F1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 17:41:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9A4B6B0012; Mon,  1 Dec 2025 12:41:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A719C6B0030; Mon,  1 Dec 2025 12:41:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AE906B0031; Mon,  1 Dec 2025 12:41:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8BE9F6B0012
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 12:41:16 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 524C712ADD
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 17:41:16 +0000 (UTC)
X-FDA: 84171618552.28.AAD6B7A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 84BB1A001A
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 17:41:14 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=hTXvdYEb;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764610874;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qSVZICUKYoSlRN2gwgE5IR+lG1rVjeAex259ohKx2pw=;
	b=K94W9AMSxrLYh7CC5wIr1HQma/gdDbvXwnk87dkv1qhPfelw/z694bL+Y1hqla6zEWDxsr
	d0yiip7kp3ZlcNg7w4ZMtKYJcetL+MKr13vNwuFJ4enmpbaSVc5gc+OsIc6lNsxp4yrYST
	Ee5lvQe9Laz5mI476Q3PubUTZ4FehA8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=hTXvdYEb;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764610874; a=rsa-sha256;
	cv=none;
	b=v7cAITYYuUKn1kxMVgZfm8or0Do1fbGNT/WMaim76a7gmvfk4/eM8vJAXizQZgvkYE+wLr
	d6SHgvOK07HtpD3u38mlA19zRl3s3CivHQGhwMAmTlX8dNXb/fnOyCjDnMku0Nj7mvgDfz
	FAcuH6ZCPO3WKh+6dL+A6sbLRBz9wmg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3F08C41B44;
	Mon,  1 Dec 2025 17:41:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D21F3C4CEF1;
	Mon,  1 Dec 2025 17:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764610873;
	bh=Sj6mhjQMzdwHKohiqgVdzGZP3an7t4iAYfJ+mIr3XpE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=hTXvdYEb6i/unmZrz+Rf7slgVrzPYVDGF0B6e9pL8HGKiYrUK4oLodn7rYTnZUUWO
	 xfe44vZiPh58gel/gFsPkTUSSF3287dOY2wa5yYEqpGe/1sh4gSUN6VPBECc5IkX5m
	 A+YXc7eAAHUctuek6mq/uUkvvRk++tbC0XyDNBp0=
Date: Mon, 1 Dec 2025 09:41:12 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Aboorva Devarajan <aboorvad@linux.ibm.com>
Cc: vbabka@suse.cz, surenb@google.com, mhocko@suse.com, jackmanb@google.com,
 hannes@cmpxchg.org, ziy@nvidia.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/page_alloc: make percpu_pagelist_high_fraction reads
 lock-free
Message-Id: <20251201094112.07eb1e588b6da2ee70c4641d@linux-foundation.org>
In-Reply-To: <20251201060009.1420792-1-aboorvad@linux.ibm.com>
References: <20251201060009.1420792-1-aboorvad@linux.ibm.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 84BB1A001A
X-Rspamd-Server: rspam02
X-Stat-Signature: dh64on3izw6thdassbsz995btw3xo3dh
X-Rspam-User: 
X-HE-Tag: 1764610874-285875
X-HE-Meta: U2FsdGVkX19SoPWrMXhd/TfMMzOwyAae748Jkx1T5NJZPyIccBiOiUXDnlHO6JyaPUynj5CnpQ8XT4TG0Ug8KJV4cKlK9OfROFxC7Ekj66o9NxMKFwZrGfHzhyMmTEGtceB1eel59xFzd5k3Q5Xr+5UQz7BVrlROLD06xICV9lE7GofaxnuVWD8WHaSsVU3Ce+mQOmu8y5b6a5+HxtjK6BaugaNuZNCjsDygkBNMvZ0UWz7NKcMCgkTLDKWCQv1NmXxdcusBya2Be/PcvPyZIflH4mRhA6ijSCHAL/kGiW3pTQ+iaYwYGhJel4umjsQuRC+7/dZI33GlnH+8dVMl4cMuAEUQ3GM4K8wiR209D13+KEDBAC+nV5cWZ4R1RyVFoSjjxUk95dqg+k+abP2JvF7feLev0Ikos2vNlB7Sx7VsfMiX3Skmu++swYa8SJxcZ1b/p6gz6QXZO2G6mD4fvxOdxkGaKdmGTPac5LXv+kqBWRKQUL9jVz/07rseYTuHikJFtFo+WZJzARr6Kjbn6tu+qJMrlXQM8lvBz9Btvp+yiulgUzU7orrsdVhPuien+fTn5JSndtTH2jNyxhwTdhNe5Q8/+DTNKDsLldsc1mM0R64Gd6qcCT4R/v4SHY2eNVTn/Yoh69HSf2Yywfpj5tZBf0Si78kwv+lHdlrBVjFRFxTDLe3vLDjS2Lb7YiayCMdspLKRPJOesYyRo4w1Ek1HgVwsfYoE3+7xboKp51cgCXgnV5YGivvRMV1FCTxWe32rgdEbuwlFaBEuFaqFt15YpD6BRtHRLMmjz44cT60X1hzh2aynYPnsoafXWtKJcJyycGO4/bIzmsLYX9jyIi1aIGlbDAZ7GftUdPq5Zbo/Modadk2ODLNbxI2609KBtq740tULZ9o8ZXiSdijnsAisBRYqID2Lh6b8O0nS7iOm42YHwWSidHXRtEO4Ap+6cP5Svnce6LyMdFUx/R1
 /AwHht2i
 r94LTYPJKLKqJuTeW+6lYE8Xxx/XraTu5V6SSBWhwFIyxtQmwJQs1gHmf1JqfIoGh7SSaO6NQClO0r/bu5AheIRpAoEYFsmCY98RWE2sDFeFpDQjt7HGf9JNZtixrLnZIXzg/sIR0iSp+ftLoTvxpqs7t1JM+BLXmcJULUgq89++jtUXLVDWLxHW/KLSSoCFFih11imbcn3o44YhOyi163GkLSqtPBZyRgnzMxmmJDz6Ees1cIX+2YXNuiYR47a5ytV6jvMRZrHHPDQYzz8NNjrizU0meoeQRyEiYzwq9jvlC8uFCkSkNbONHJU9nvq1Pbxmu
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  1 Dec 2025 11:30:09 +0530 Aboorva Devarajan <aboorvad@linux.ibm.com> wrote:

> When page isolation loops indefinitely during memory offline, reading
> /proc/sys/vm/percpu_pagelist_high_fraction blocks on pcp_batch_high_lock,
> causing hung task warnings.

That's pretty bad behavior.

I wonder if there are other problems which can be caused by this
lengthy hold time.

It would be better to address the lengthy hold time rather that having
to work around it in one impacted site.

> Make procfs reads lock-free since percpu_pagelist_high_fraction is a simple
> integer with naturally atomic reads, writers still serialize via the mutex.
> 
> This prevents hung task warnings when reading the procfs file during
> long-running memory offline operations.
> 
> ...
>
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -6611,11 +6611,14 @@ static int percpu_pagelist_high_fraction_sysctl_handler(const struct ctl_table *
>  	int old_percpu_pagelist_high_fraction;
>  	int ret;
>  
> +	if (!write)
> +		return proc_dointvec_minmax(table, write, buffer, length, ppos);
> +
>  	mutex_lock(&pcp_batch_high_lock);
>  	old_percpu_pagelist_high_fraction = percpu_pagelist_high_fraction;
>  
>  	ret = proc_dointvec_minmax(table, write, buffer, length, ppos);
> -	if (!write || ret < 0)
> +	if (ret < 0)
>  		goto out;
>  
>  	/* Sanity checking to avoid pcp imbalance */

That being said, I'll grab the patch and shall put a cc:stable on it,
see what people think about this hold-time issue.

