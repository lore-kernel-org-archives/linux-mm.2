Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEAF5CAC5AE
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 16:29:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 125A28E0005; Fri, 26 Sep 2025 12:29:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FE1F8E0001; Fri, 26 Sep 2025 12:29:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03A368E0005; Fri, 26 Sep 2025 12:29:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E772E8E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 12:29:57 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 821441A01D2
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 16:29:57 +0000 (UTC)
X-FDA: 83931938034.08.D9573FF
Received: from gentwo.org (gentwo.org [62.72.0.81])
	by imf15.hostedemail.com (Postfix) with ESMTP id E296AA0016
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 16:29:55 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=skDDhUwp;
	spf=pass (imf15.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org;
	dmarc=pass (policy=reject) header.from=gentwo.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758904196;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pXZMnjw+Sy9OuF5bFWxCBJB/q1PalvTkN3dKPnTWL5s=;
	b=y7YZy4i8m5Zqp6ZngI4eh5hhBb2s0tUTHu7683itkEaJwz0C1/bS+dAxEFjtb/vnn+HnB8
	voGf7cXT8H5KhfTA7UmC0kXdHOw0UXHQ4yowyRoQVqeWNPQOTYSW59U3GKbQs/NCOZSD5Q
	KlXKnN9UbR0XV5BwAAoZ4A7NaAHKnZE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758904196; a=rsa-sha256;
	cv=none;
	b=ibQ5zfeTnAW937EAX9puZgRKjeNE3HXYiHLxHJkwfQurm9Tabqugw+td037JhUSrFjJJOj
	OBusd5tYvMKuLwV0/TIRrGiWCQxuengJn+XU7lcvVP1Lor83yCdBgaPZwxyA7U2+ulGDO2
	Wrgiowq8qim6y5ftBE7c9vMzqD+U524=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=skDDhUwp;
	spf=pass (imf15.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org;
	dmarc=pass (policy=reject) header.from=gentwo.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gentwo.org;
	s=default; t=1758904194;
	bh=pXZMnjw+Sy9OuF5bFWxCBJB/q1PalvTkN3dKPnTWL5s=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=skDDhUwpJ28QhFf/DSEnPG5i/j3L4lkVN7HJLxmnX4uQxrTIFaawx6ZJ0RYaqdB8P
	 TX2qnBt3jCnEEZntTEo9pqbumFSpzucw40GmAk3mt2XUuX0BlDUT7m+kowp6/xsUBs
	 Vt5Gf6ITs6DFEN4o42ynwJyrLtOXnNVSwUntSpBs=
Received: by gentwo.org (Postfix, from userid 1003)
	id C2062402AD; Fri, 26 Sep 2025 09:29:54 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by gentwo.org (Postfix) with ESMTP id C0E204028E;
	Fri, 26 Sep 2025 09:29:54 -0700 (PDT)
Date: Fri, 26 Sep 2025 09:29:54 -0700 (PDT)
From: "Christoph Lameter (Ampere)" <cl@gentwo.org>
To: Yang Shi <yang@os.amperecomputing.com>
cc: muchun.song@linux.dev, osalvador@suse.de, david@redhat.com, 
    akpm@linux-foundation.org, catalin.marinas@arm.com, will@kernel.org, 
    carl@os.amperecomputing.com, linux-mm@kvack.org, 
    linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: hugetlb: avoid soft lockup when mprotect with
 PROT_MTE
In-Reply-To: <20250926162034.1785899-1-yang@os.amperecomputing.com>
Message-ID: <1038c7c7-81d6-f273-6fa1-93eb7206d5ed@gentwo.org>
References: <20250926162034.1785899-1-yang@os.amperecomputing.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E296AA0016
X-Stat-Signature: ubqjpj89i41ii4xin3j8a691usezh6w6
X-Rspam-User: 
X-HE-Tag: 1758904195-783521
X-HE-Meta: U2FsdGVkX19dT0FrdELH3t/xUmD2doSmHK5NDOsa2hP2NkgekCiF6hhk8dVtvZ7cmiZyzt5rMyAgP05a2vWMtTN+WfZTDowA5lSn90FMSY4d6PXjMGcLr4NMT/ayMkO9x9mR3T1FJts2GRoY3AJsyL8Tr17UPd2qRBB/f6XfGx+LARyGmG3tFUJe/oWfOKrsiN4jjDll2caPqiKmG7yYhQo14F2yIPWmFd998FjAJMUAmTISUllUEOTx3mZ7XdjxDCWubPkDL6MoSuznVdPVch6MvKfzuVxcxrh5/GIrtXqdJi6SKKfy0YgjpS9Emy0Rip2dlifccJ5vMlIKLSVlwHHJusluoLq4e2AAj75bRLVJ6SemH740/qfFq6WCfwZxbWkWs2BSQoiDaE5V3a8EB1o0693PJBJjiRUdYH3Gzf+xzkmuUvSEYRz4nt1E29ysG493u1rmHNmAKKKWAZtR7i3gmM/2d4rXQwpusSyS5uO78h84a85SrKuu0vv4Dy/KSuSOhkbmj1qikS5ZH02mpoAXBiYsbLGpGTmsbleXH7gTjoVgbZxknj53uyx8kj60KnWixl1qmvJeVkYKj/ZN6WO+OMNQT3SdYFwPODYYZnZAe08GRxZwWQiBWVvd3db1IvIOLnMazbBXAiwMNZPbMJAjHZGNZEo64jdl4vEpOSHBApB9l5rftKBkjpe68i+F2kv5dZK0eEe6Pp4XhHc8Ao+RPsZSTYpibXgi3LOkz8Dp9HwSMP78ERkjTv0TmKXvDpTwJX5Dt/ea5TgMIGrQWQ9PsHgC/xSVDu3gc0xzYPWjWntHSr+9HIDthlyFZnD4cJOn9GkuCZj2wber6hzZjcr5XxBkMWFjVYNZYa/Wywx4PyiJn4AS3bxb893iG37C3RtRYy+byh1s3dDtbyw6jlJ9R1Otx02mEDfhio/JWiSdjPHvqJkKJQSdngpG5dxVaClTQMhA9R+Hwhj8c1y
 WnWUDf5d
 CqQqboVI2+1spID6bv8ESB8/L79wIcVHEkr/63/2TksQsLwcW4CS1Fl/lNG5QEK4a5tYvERVFDjNFBZ+UjOPeIHNVpHMh7F1fkpHcUw2tXuszwI1uIGmHsTZKubpAW5yZ1bshfEBxDzf+MrLFkBBTVAvUVANtYjeUgxjVCH5xWlwHST1XJQcdxP6qLJoC7GRpqW8wj6wEc0l043BCtw7Sp4q3Snh3weG6U3BFImHkv5I9zWf+aoF2H/KnVyKz9d7D4CGeMrrh0KvLNFMsizr0Yrclt/Ek27j8hVbvpYkygYOinZaQpEGSYirP5g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 26 Sep 2025, Yang Shi wrote:

> When calling mprotect() with PROT_MTE, kernel will initialize MTE tags
> for every single page in the affected area. Soft lockup was observed
> when doing this for large HugeTLB memory area in our customer's workload
> (~300GB memory):

AFAICT this is a bug fix. The hugetlb path should be doing a
cond_resched() like the base page code does.

It is not MTE specific. If other processing takes a long time in the loop
(setting up terabyte size mappings for hugetlb for example) then the
softlockup could also be triggered on non MTE workloads.

Reviewed-by: Christoph Lameter (Ampere) <cl@gentwo.org>


