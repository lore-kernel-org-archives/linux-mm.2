Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB1251067040
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 15:00:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C05ED6B0088; Thu, 12 Mar 2026 11:00:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB4DE6B0089; Thu, 12 Mar 2026 11:00:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB23B6B008A; Thu, 12 Mar 2026 11:00:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 985386B0088
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 11:00:28 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 105AA1602D2
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 15:00:28 +0000 (UTC)
X-FDA: 84537722136.06.6779479
Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	by imf23.hostedemail.com (Postfix) with ESMTP id 08005140019
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 15:00:25 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="JAFcq/oX";
	spf=pass (imf23.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.49 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773327626;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zZGtiJN9y4ZZ4JfI9NE8H692/RL57MUDkhcDsED4q1E=;
	b=eV4hNyNOIa3BQ+5pHXVEcMoZqGvHtOWeqgwGNEevJ0qRM4EEadd+MwzzQKCA3KyMDPanGY
	ERQ1jVKUKBgOcdINQilWCr9jWyhE3mKyZa3wRbPmMUzdlMgfO1ny6QHTrD96YrFQP6DS+v
	Ln84Nk1R93XWn5qVSMxXeTGXqyoWRIs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="JAFcq/oX";
	spf=pass (imf23.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.49 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773327626; a=rsa-sha256;
	cv=none;
	b=lNRbmxbpCJYIOFwG0JwFFjEvL4AqZPivlk4oQyD1/AytQWv6UnrunRIZ36vkwDmnL41IoX
	tLJEo7ywCHw/qjuvONaWGPYinjVkmDIhTXW5eCUQlv+qioo5OhDNoVr/P3SNJCZziWLNQa
	RmNfIE5XnLZ+DAbiErO9Ry78Wst89WU=
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-40ee9b945d5so732865fac.0
        for <linux-mm@kvack.org>; Thu, 12 Mar 2026 08:00:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773327625; x=1773932425; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zZGtiJN9y4ZZ4JfI9NE8H692/RL57MUDkhcDsED4q1E=;
        b=JAFcq/oX0BIHjP0RDp3aNMY+3NbbeUeOl59SqK2Bd1OlPdePeOWei87coaVpOwrPaN
         x5q5ZlKucAnZ2fJ2WY1+Op9lXXGY6vzyE4x4kJ00LziVt9PNDnQETzfz1+YTWNm0IKt8
         CUDufc+vLUKkt9CX2ca7Z+aZVLN4oYaHrQihh66/ibnaTWQpcqrQTkM1PL5HZoajNGMo
         Ojq5aLyshsK72iADH8axdBNKNMe+8NhZXrFyB6fOPFKu1MnC4Gkcy6EuXAoYm/FZFxxU
         QrckheZp262K97fpEU06BcGX9b4SIKomb0qkLwg6SiLdUV72HZOxUf4hoOrFxXq5rGLD
         Y7Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773327625; x=1773932425;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zZGtiJN9y4ZZ4JfI9NE8H692/RL57MUDkhcDsED4q1E=;
        b=h2nka8U+ZjcpiY248qvXUtmMS+1VLNQB9dOKvx3Dn1w6q5IWII4fJsaHX4E5AzKDWq
         aPo0OmeKguET9MpuuePR2vCaeRixj+rLxrDsXzNEcmVoaj6GJww6B04svLC6FOIx2Wmf
         owejSxgm2QwoTD1WRn/ymJRztOc17eF8YdzFNj3bCOkP/+E8WCGAh17mdCMvIGYxhfHt
         vORvTQ0hAmXpnhz6STwoytCLy8iOZWeY/dO4If9Q0FlfDpISodKg+2j3LhecexpHMIlI
         GbhydDCzzc3qEFjydlnpD571HdI3eh6vMmcjZQtY9uyFvuy08NByq4lXhpBtDNnjy03x
         bs5A==
X-Forwarded-Encrypted: i=1; AJvYcCXdGwk5h8t/bQa8p4CCLdl+DYnHMKGEy/A1peyzGHI8lmKougealFBHPN5pnxTHrm3Cljpbug+OUg==@kvack.org
X-Gm-Message-State: AOJu0YxSUjpQOqt6cauhX2GOH5YpJvtFzkfKDOZ28Agt8B+Iz1Oo4Zn5
	f7qXXjunGfdnQZtmfyIdcHHWlB+YAEQqAo94Fr6ioSv3QEj/6UPb5Q+V
X-Gm-Gg: ATEYQzyXwNjiphE1QdAhqkNPHAc8kTAuUJXzmvj3qHeSkeOXtnAIIGwfB6NhY/dMHwi
	6NahxdkpGfThpIzraIprRbpYyb47ZFhda3mKInyDEwT86e3ovIP++nwDcYux5jEYO69LvFCyNTA
	c9SzPobsb5cm+WINjNZBSADgXGRAyjc3XxCbltTcfPbko0nNPwQ925+hnmDjNe0xnmLD6ibq7tI
	/5XVzDJAhUgb3LSNYlcnRincq32HTV429jzl7BasR+RGR21l208xXqJMGtWfwJfYuQAHj/nur3L
	VDNTP9tfYXgS5r37uh3a1fiwwgyeoV62lBmJQ1Vm/KSUpwxBVHlI+znionWb6L69cDyDZufl44n
	ls81vxneHYYHNu2gw9p5hmXw1nsiKRZ3s1BnMkR5iF8Lj7AR/IjuxOvvknRMyv885CyNAz23rHG
	ahPr2izF4TAlO4dvF9BApKnDdszlpsINo=
X-Received: by 2002:a05:6870:798d:b0:409:9a0b:b733 with SMTP id 586e51a60fabf-4177c5d49d7mr4215501fac.10.1773327624652;
        Thu, 12 Mar 2026 08:00:24 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:6::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4177e5e9f53sm5583147fac.13.2026.03.12.08.00.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2026 08:00:24 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: YeeLi <seven.yi.lee@gmail.com>
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	dan.j.williams@intel.com,
	ying.huang@linux.alibaba.com,
	linux-mm@kvack.org,
	joshua.hahnjy@gmail.com,
	linux-kernel@vger.kernel.org,
	Jonathan.Cameron@huawei.com,
	linux-cxl@vger.kernel.org,
	dave.jiang@intel.com,
	gourry@gourry.next
Subject: Re: [PATCH] mm/mempolicy: add sysfs interface to override NUMA node bandwidth
Date: Thu, 12 Mar 2026 08:00:21 -0700
Message-ID: <20260312150022.1373486-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260312091207.2016518-1-seven.yi.lee@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 08005140019
X-Stat-Signature: knnb7y1jik7kdemsxz7snownmjpc1oj5
X-Rspam-User: 
X-HE-Tag: 1773327625-81408
X-HE-Meta: U2FsdGVkX18C1nZEo/4ljjerFPNZmwD078mNgAkQdsSZlEqrg2zAl09+PbJRjdKIzQKcupsDSFnDtgk/MPhSfZFHjZByQRNpPknU4PzXvkJ9BCLbHxTa9ClfzssJm/X4XEdMU9PJ9BrcTl9iU8WDYoul9aTKPqIIiqL4CWOgIAsWYBaX0v3L8cyNUFG+1TvHRi8j0gP0MsgFEAL8JqbwctuH8DOvHBCPfRlDa4+zYenTujUt/wK6podH4MKmizyIaN6bOWx7GwEPRVhUEquvfdO3fubjEfmuAAVbovKQVkpO7MYULr60JG0vkw+Gi/gvfQ5vnyDx2b5hPHF5jA7IKa4Op226rJOu+UrB+pcn45uqHm3vDv2uA9d9gf8miQBnOG4GnUKLfEOkavJy8lDupGeeCYRd2f/IQP9yhI3LcouUcgaImoibUi+XwWnUDQYZ322Km5zS7M24wo9Z/slBhJ4XBwBZT16NfH2p8ls5OAmQPeypkAw8wlwvbtztdex644TloK74SIrZzmv4PLxfb9njuG2QD5M/CLVeBVtDIBz5jcIxUzybqA1vXXIhR3dl1fBcn1q40Z7HiYxLubNVH8Ff+8TOBsQykiquoKXEbP/QgbP+twcKD5qtm+bfVoszPVKcXJVW0icpB8MaaeT6feys/ZbTeODDO42PIz43sRItH/1Peu5QKT6dgXCZWPLehSDW6qpEQf9Jz1sjdTGdQFVwYbPsc0FoUW99K8JFvGA9/JSTb8MnWDWFYNGggxrwevwuHteTTK8BkVjaU5zo8QgNOW403NbVoIpZbp5HuMcvuvebxH6b8VILle2OIwmq8olrEDrYsvGKNaYT47HyolM1JGGvhnDeVdeVqugTQLkEWP0rH13l+w8jeZX6JvlqMbZXg7T1qn0C/d7tMrEq/VIGo/oSArOJGjJxWGG7hCuc4jH7bivW0M3jaZJmD/N9KqRedvFzT4YXiykjBXO
 fDKrHkN3
 o8jrlTDVKFToxWPS304xM7EREudHumlvm2Bg93HD+gTFPxoBN3CZ4zkGQTeGs2G2jbgxqjZYyGm2yI3kPrZaWP80/cZOAywLHQZ5V+g9XzqpeW7oQAV6/CZxKT06jlOecUqeu1aLVXcPkAhGelxegQJnI1xzqCBeBVoFmU0RBSMBDMGE7XVVS632fsKeDRAs0UFZhwypwELndwqDtoD6i3y9QNXZEpnC+R5gtVEeeg58+JMIhNb+Alme8BuQXr/1qTxex956EehSVW9ZSqmsoIMgvuTbeQczvWFx3n9kt2CtVBo+MtLWTGZRHe0dfGi/l3RsRDwqu+CasakRBmMJp9Fqs+vS33dWiJFDEQ8zA+9aFMBefC4pouMds6rj2iwmmzi663KwD9a+RoMOQ5iBweEj3GgvG8C0a16H/a2mTe1xIf3b2uTwXaRNBiHoPydFPX7UgMWWEOPZ2oX83B8RRlyWw+T4PRcTlwQ7nxWrucpV37YQRXFd2AtbsI6ltQpVfVzUlPQhYdfmQiZbqAtLGx+1oeif8HdYcmQilaKSGM8AY68QIjZbWP2JCFa7aXzTADlCtNgJMEntGcv42XxwhpuVzOg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 12 Mar 2026 17:12:07 +0800 YeeLi <seven.yi.lee@gmail.com> wrote:

Hello YeeLi,

I hope you are doing well! Thank you for the patch, I think it is an
interesting and helpful debugging tool.

> Automatic tuning for weighted interleaving [1] provides real benefits on
> systems with CXL support. However, platforms that lack HMAT or CDAT
> information cannot make use of this feature.

Thank you for the kind words : -) I'm also CCing Gregory Price, who
is the original author of the weighted interleave mempolicy.

> If the bandwidth reported by firmware or the device deviates from the
> actual measured bandwidth, administrators also lack a clear way to adjust
> the per-node weight values.

I just wanted to touch on this. Is this true? Weighted interleave already
exposes sysfs that lets the user set the weights they want. On one hand
I think it would be helpful for there to be a tool to see what the
effects of setting bandwidth information on a system could be, if it
had other side effects. I'm not sure if there is a strong case to do this
purely for weighted interleave auto-tuning, which already has a manual
weight override and pretty simple calculations : -)

> This patch introduces an optional Kconfig option,
> CONFIG_NUMA_BW_MANUAL_OVERRIDE (default n), which exposes node bandwidth
> R/W sysfs attributes under:
> 
>   /sys/kernel/mm/mempolicy/weighted_interleave/bw_nodeN
> 
> The sysfs files are created and removed dynamically on node hotplug
> events, in sync with the existing weighted_interleave/nodeN attributes.
> 
> Userspace can write a single bandwidth value (in MB/s) to override both
> read_bandwidth and write_bandwidth for the corresponding NUMA node. The
> value is then propagated to the internal node_bw_table via
> mempolicy_set_node_perf().
> 
> This interface is intended for debugging and experimentation only.

Thank you for the helpful clarification. Just to be sure, are there
other intended things that the user can test other than what weights
weighted interleave would resolve to?

Thank you again for the patch, I hope you have a great day!
Joshua

> [1] Link:
> https://lkml.kernel.org/r/20250505182328.4148265-1-joshua.hahnjy@gmail.com
> 
> Signed-off-by: yeeli <seven.yi.lee@gmail.com>
> ---
>  mm/Kconfig     |  20 +++++++
>  mm/mempolicy.c | 148 +++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 168 insertions(+)

