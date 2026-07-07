Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA9F1C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 11:05:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 934B96B009D; Tue,  7 Jul 2026 07:05:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E5A16B009E; Tue,  7 Jul 2026 07:05:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D4BD6B009F; Tue,  7 Jul 2026 07:05:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 55EF86B009D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 07:05:52 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C5B661203EB
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 11:05:51 +0000 (UTC)
X-FDA: 84961700502.09.D452160
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf05.hostedemail.com (Postfix) with ESMTP id E07AD100010
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 11:05:49 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JTO44uvE;
	spf=pass (imf05.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783422350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lD+7UB/rcPH703dszzWaFfRlura1yWF0OTvxBOmx8Qo=;
	b=lxRFnePNYNZNU59X6YJGrCyXU1zn9a3ZX8E29mlaU0M3u8sR2FAkT8ADzUzT8suJJzTDqw
	SsBr2w+nKlOTsjKfGoW3WrXR1q25DC+ePZu+EIDUSFYv919S5YxMoUiloPb0a2UxK9Cx7g
	mhhBDp/v1VEOj4ClP2H5ihCn5SzAkn4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JTO44uvE;
	spf=pass (imf05.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783422350;
	b=SWvr1k5ky0+5GIlTho6VeF06+do2NhGUPDQJ7F9gOegsi+rO+Vr36u7ytg9oxTVD3J/2nl
	x21KKFbliwGKpuwp5pP1S/vjOODRGbcY6GzIcrK6fMF78OJ56p2WUebJ9plPSqyx3/ipDC
	rptlr3Y3IotMuuywb/pIOgyP6GWwqPk=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783422347;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lD+7UB/rcPH703dszzWaFfRlura1yWF0OTvxBOmx8Qo=;
	b=JTO44uvEWN3KTcmlp/6dmwckLBSpsLJZeqJvH0aEO9gmJWR6wS09Y03pvobG6gt4m/uUHE
	n+bZ42QwQVzkNxL0fcUYSgO8Itttuvpotp44vag3qDYoQGO0SfRx/mGSlAzWKkCG55eB5T
	aVxVubBJezQ9Aup7miYWfeZh5Rkr4As=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH] mm/kconfig: Drop redundant memory hotplug dependencies
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260707090331.52971-1-kaitao.cheng@linux.dev>
Date: Tue, 7 Jul 2026 19:05:12 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 Kaitao Cheng <chengkaitao@kylinos.cn>
Content-Transfer-Encoding: 7bit
Message-Id: <E4DC73D4-24C0-484B-9A59-27596AF726D9@linux.dev>
References: <20260707090331.52971-1-kaitao.cheng@linux.dev>
To: Kaitao Cheng <kaitao.cheng@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: xjjwmb3s1muamztfh4wdfwt6kfuoc69k
X-Rspamd-Queue-Id: E07AD100010
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783422349-354906
X-HE-Meta: U2FsdGVkX19WSFNjh7K/Un/aqBnZRDoby6ebmBHK86oQxG5AGTMU9JkNlIoY7RpOZ8W4ZmgFpzFKhoZttqH9KH8AFFssWuWY9WtTAtmZ+/i64TTyDWqLDGPsl5DJ+e8pvmmFQolaNI3irzbo6LkQ/R6ac8sFbmgPDvA/+oVm0V2SlH0HxCEtILGMS9BGHRbWOOm14b1JCld85TIW5qd8wQ87j7YNQvuindXI8PQgw5xP3vpKkZU0WfgOXm8Uz6qHS1AhqEW1yymmiAKNDkrGaosIXLLf00fjT8HxWjgiBYaAq97/rlu/YCJPfxoEcpNpb9nJGjuIhzUwVdPJe2jYleFqe5MmWJUcIqDxSyaa0DGtRlUTN2ZCOpW/JMn5Ezt5ynODuwrYEJSz5kMZCP2D3PFDXUb+SpGhDnTVefw6RhLTSAiKOgcXvK7hjMlYZw0fDVkPFzYZVxwR8mEIbBI4zUG0/LRa38lOHOpqTHgk+M4ZtB1YgoDXTZyXjCcyid3Oqgmo24QK6cH+CnTxGsNm6T864NN0OgGyZPlb7Hw7gxRWmRSLSf7Kh5cVHaS23jVUtLe3ocUzeJtJ/u+pDHK1xholGzB2hVbZp1wRc7dMSVLLRJvMt/hh1+7AxCTCxAIvgw1eZXbukOcnzKVKAxzp62jRo3mbkSWtNa5U64s/ohNo3K/+P++tR4NgWuFP1eENGL6KvEAj9sTSmIg3Rg7IZjO4z/VwkZ6YZZ4jHdXqqk0haCF5WsvWjlsN5vyuqvXHrcLx1wkEsVD2oZ72KDTPgso8Kc30Bk0+MqCc9jCmqeapyohqqImYktvIQIsKyjcetCezZUYgaeqUkkhgRnq0lrHov7A6IzwKHEEhsFIoEsypGXWH8BipP157x7X2qGVlc83vQqT5aSEgQhMlz8z8EiCp0TzcmbtLgbtmrI9/AG2ECnEhmDfH1z+SSOxi2Z0BMsd28JpKW2Y+ewTPcKp
 9YnSNHhg
 5uegiGRpg9wJzkwOdkwyr0L4hR46jlD8338T3gOiPUBilqa6wu1EflKfqYulgECndm2sVFu28p67hffzq9sQurghpuZFLmoAF/9sz+IQo/eBwNcv475x2O3LqmJWCKz8wkasSEj/6XfFfkDrukN43KEuTF8jIl3sVomBXp9bLt0T86pYMpYk99RRJLttaihV0bLVqoVOCUXONlKq3Z3kIwhra2P0PEIJk5UBCVHr1vtpvw2Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jul 7, 2026, at 17:03, Kaitao Cheng <kaitao.cheng@linux.dev> wrote:
> 
> From: Kaitao Cheng <chengkaitao@kylinos.cn>
> 
> MHP_MEMMAP_ON_MEMORY is defined inside the MEMORY_HOTPLUG block, and
> MEMORY_HOTPLUG already depends on SPARSEMEM_VMEMMAP. Keep the explicit
> MEMORY_HOTPLUG dependency for local readability, but drop the redundant
> SPARSEMEM_VMEMMAP dependency.
> 
> ZONE_DEVICE depends on MEMORY_HOTREMOVE, which depends on MEMORY_HOTPLUG.
> MEMORY_HOTPLUG in turn depends on SPARSEMEM_VMEMMAP. Drop the direct
> MEMORY_HOTPLUG and SPARSEMEM_VMEMMAP dependencies from ZONE_DEVICE.
> 
> This does not change the set of valid configurations.
> 
> Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks


