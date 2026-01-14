Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 228ABD39004
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 17:58:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8977A6B0088; Wed, 14 Jan 2026 12:58:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87F326B0089; Wed, 14 Jan 2026 12:58:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7ABE16B008A; Wed, 14 Jan 2026 12:58:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6D9976B0088
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 12:58:44 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F3B391AE2DB
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 17:58:43 +0000 (UTC)
X-FDA: 84331329726.11.6E28486
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2D8A610000C
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 17:58:42 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=b3csv+P8;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768413522;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DPUuLEm7UXsulGVZFtKN5eZVJzFddxxHXCKNZIrAZCk=;
	b=kMY3L7a0H4DvEXcOD+vg5j8lcUONkDKS7mGx0Z8tlMS+qwePBIfEEaKnVdkIdgBv3X7AP/
	PDTT5BBnyKbNCCdVyj0CU95/OoXUxCg+G6dt9ipc3fG+r6wqOpbjACWaAiGaurpLxL2+9H
	rDLCYoW1Su/0+OC3mQQ/KE/5FGqucCo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=b3csv+P8;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768413522; a=rsa-sha256;
	cv=none;
	b=pRkTqPc04MEqMS6FlCRv1Vqy0WjpiagaWq4QsIMD4HPXll9EtAJ8ztvGtPQhP2VKl6cFLX
	O/Cf1/IeB8ERm4S6fMFc395YBzo/s1hSacFnbmo2kDb1frMP6qt91Ezt0GWvtJ5hJnOZH7
	DQlUSPleRkS708i5GtnQRWCSMJEasYU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0110343B64;
	Wed, 14 Jan 2026 17:58:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 063F4C19422;
	Wed, 14 Jan 2026 17:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768413520;
	bh=9Fv9tS9uQrGFTi2th9Xoxxzo7Y0x6OhXx+Sy3T2KfuA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=b3csv+P8615OFxJg1bifahfXhNgrmDvfbhd018ZXmvO7eitG2MqdJPXyle+rSrcrM
	 EQmQSa68tG9p0SMJRibZEokmbdKPpNvodTJ0padh7NBvNIZOaqq6Urq/vFtarrxC5P
	 Vof00TTQn2UmtBLJUXzzleywj758yixQmP37bPjk=
Date: Wed, 14 Jan 2026 09:58:39 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 david@kernel.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 harry.yoo@oracle.com, yosry.ahmed@linux.dev, imran.f.khan@oracle.com,
 kamalesh.babulal@oracle.com, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, chenridong@huaweicloud.com, mkoutny@suse.com,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v3 00/30] Eliminate Dying Memory Cgroup
Message-Id: <20260114095839.eabf8106e97bf3bcf0917341@linux-foundation.org>
In-Reply-To: <cover.1768389889.git.zhengqi.arch@bytedance.com>
References: <cover.1768389889.git.zhengqi.arch@bytedance.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 2D8A610000C
X-Stat-Signature: pxjkcw6jcwmh1nx3abfgcnhfpdzkdoit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768413521-56725
X-HE-Meta: U2FsdGVkX1962ACXe240rivHND2I4O5NX0XPwZRf1jtyiKG8CStboD4S1Q4AllSs32QGFf/zTBhQG5Z2zY7iDKFr7FvSJzzBLglK9NseN41HzDeXBMnw1HGFf60/1lLIhemty6a6he5ooWaHYE13q6uO75e0NH+afnev8ow+6ROe3yxD6LNVtRH6MGHZwkxYtKUPGFDuPqZGSnvPyE+56latJXcCgV0bA/FIWKQyCIEg+0it7K8kS+7vyi36qwVliYqxXfFDtlep5R7AJppYOOVAQPLlpYtHriQJV5SRjn/8er05DGKQ0XtYNDnDPHzvv7swJcEUr+2cgX6mR4cNdWrWFJkfGKD3TepRTKdjNVcS82nEq6UzT5cGX4CxOZoGMlvSstztfUTZWN3i9aHaOV6ZbdRGKx19D7s5abU13qC+k1KxJj6cgdcAn4zKVIlcWruZtqCCAyYNTDZ0sAQ60lYq3GZLExNjXoLgkqmTpGJ93dwkdfvh6wfp1xwtxGv3n2IlqojufOUu4n0LrXfnYHN9ZQ7AtyRxrmmvC8ro0NYGkY50obBtnuKKCWhIfg8XvHo6XlA2q4paDYWXXtRz43usk1QYdy2zEDvQKADGxlCFqwDhfv1kbEabZCvO5hOa/GNkOHF2ayf9K9H5gKCAheKi+uIjV1qzMFrPmaNOFX2ZIoctUrNwWX9hczlXWQ85Mo3ieKlLjBYioSllFbeZwRrZ39xo7ccWzBD8m05qQRwRqQpFB7YVPJb6qOhT6g93OUMqqrEPlWT6htMD50vzDVy/46I/B8aaJZNusg1I2PLHFqUNqsR2TAnyHRjQfDt/i0YteeTtLHJ0xGrHIsoEKPfcjM1ksf38D/1LJvPO+B7bVnmFrfdGE8BW6kLTgvKD286lZiyPKD62vHGPH/zkccPGz0Y0gg+/SA73nyh63GVtLPHk6sECE16n66jsp5oaXBlRCn2eYbgWEUMU/vP
 zPXtNqxO
 cMdTfr3ImOWMrNME6FsCvgtwJWGVGQNmFqblwR5nBKeZbVCLS0ORCoZCU6+RRjdtL2744hAaKjI2xFZfqtOzcmAGFwDU+tLezfTKpyRwT0klEL65GxBnjeWgSNaoNtUSnjW4uc787GAXCbaZik3IoHsbCqcwZyvKiBtQSFISMgeHT+a9Sdz2EphU/fAyaIPY8IG2itOdqs71pHhH0r231oAFCDltW4RR251VuguLF2DfE4nqy6o35l3XM2oc9oBzQG9/BrRAFOJl3zsyEaWCeWEWDRw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 14 Jan 2026 19:26:43 +0800 Qi Zheng <qi.zheng@linux.dev> wrote:

> This patchset is intended to transfer the LRU pages to the object cgroup
> without holding a reference to the original memory cgroup in order to
> address the issue of the dying memory cgroup. 

Thanks.  I'll add this to mm.git for testing.  A patchset of this
magnitude at -rc5 is a little ambitious, but Linus is giving us an rc8
so let's see.

I'll suppress the usual added-to-mm email spray.

