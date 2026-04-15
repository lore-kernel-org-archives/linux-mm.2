Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8112F4198E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 11:04:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D1426B0093; Wed, 15 Apr 2026 07:04:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A9796B0095; Wed, 15 Apr 2026 07:04:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E6B36B0096; Wed, 15 Apr 2026 07:04:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1F59D6B0093
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 07:04:38 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E50DE8B854
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 11:04:37 +0000 (UTC)
X-FDA: 84660506994.20.3DD69C9
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	by imf29.hostedemail.com (Postfix) with ESMTP id 49B35120012
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 11:04:34 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=N4M95Yhv;
	spf=pass (imf29.hostedemail.com: domain of ranxiaokai627@163.com designates 220.197.31.4 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776251076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OEARKQBxnn04zkvEzfKGe1qNS9yfLYWPkusw3SDlgrg=;
	b=Hv7tiC0zqGCUvtSREprBSO7ECrh3hkS2CyHHPsmbXdk58cpsaACtD8/dLRnlv9X6NBlrAp
	UoW9Ou9B21H4neFDLtxavQx3qzrkujiJe7hV+V0B1/gS5uRCeFI0VM38SQ4vqG7ruzLzpZ
	w+qHaQSOWJHw2rS6n1dHqKfjAr+3PA0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=N4M95Yhv;
	spf=pass (imf29.hostedemail.com: domain of ranxiaokai627@163.com designates 220.197.31.4 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776251076; a=rsa-sha256;
	cv=none;
	b=5UgOyRc2vr4li1G4/6MgyKWW2MxbCOBr945tv8jIpXZoPSPODqGA1bPnNUOkZA+URpCIsA
	f29SU4vTVbflho1w+qJGe1FiosV/bExdKj6xKCREfufD2Qs/LA2PQ7Z9Ny7MkH0mSQji25
	8jDRXwTxq7s94bYk853IHKfmIuTAz6w=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=OE
	ARKQBxnn04zkvEzfKGe1qNS9yfLYWPkusw3SDlgrg=; b=N4M95YhvcQrIaB9dFR
	eyqy1LTaxZB7QB0uFegoouZGDAkKXDT9EM9HMxO793x0vkEdMIkddGaiGO47WKQR
	DMlYpLmsI5OBoalvTV9Awnky5OSjCE/N07pcDmZYoiohcdTe0yqV8OGhCwr+7axj
	iGG6KRB+3g+tbrglMrY6ugYRc=
Received: from ubuntu24-z.. (unknown [])
	by gzsmtp3 (Coremail) with SMTP id PigvCgA39QGdcN9pD65+AA--.81S2;
	Wed, 15 Apr 2026 19:04:01 +0800 (CST)
From: ranxiaokai627@163.com
To: mkoutny@suse.com
Cc: akpm@linux-foundation.org,
	cgroups@vger.kernel.org,
	hannes@cmpxchg.org,
	hughd@google.com,
	kuba@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	mhocko@kernel.org,
	muchun.song@linux.dev,
	ran.xiaokai@zte.com.cn,
	ranxiaokai627@163.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	shuah@kernel.org,
	tj@kernel.org
Subject: Re: [PATCH 1/2] kselftests: cgroup: update kmem test tolerance for multi-memcg stock
Date: Wed, 15 Apr 2026 11:03:56 +0000
Message-ID: <20260415110356.3546-1-ranxiaokai627@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <vjhou23d62pvtdqsan2nrlldkwf27qchpfmzf4yoetqn2gdhbj@cfiuqzzotbxf>
References: <vjhou23d62pvtdqsan2nrlldkwf27qchpfmzf4yoetqn2gdhbj@cfiuqzzotbxf>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PigvCgA39QGdcN9pD65+AA--.81S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrurWUurWDJF4fJr43GrWUCFg_yoWkuFX_uF
	Wjyr1DKw4UKFyxuFZ0yFs3XF12vrWUArn7Xa95tF4xta4Dta1kJrZ5Wryjkw4rGay3GryS
	9ws0q34Yq3ZIgjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7sRM8n5JUUUUU==
X-Originating-IP: [117.176.243.250]
X-CM-SenderInfo: xudq5x5drntxqwsxqiywtou0bp/xtbCxQGW4mnfcKGkwgAA3x
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 49B35120012
X-Stat-Signature: 9x8g86ab8grtonqkapmu8wp5jbcezndd
X-Rspam-User: 
X-HE-Tag: 1776251074-111002
X-HE-Meta: U2FsdGVkX1+2mSArPBe43wZgFWkJLRR48AgibNNAxp7TCTBvRUmlsFDb1XQFHRmFduOwI45C9jsy8tRsiTB14tcLATBRQPPkevPX0xI/AApDyYZb9kljBTqtf7HzCIX61XYDGcMmT3ihzdvDOKXrqmI4HVeiEZKqeXb0duYghu2VxUA9sKzbI238OJvrl6mhTfN5qKr5MLBYNmLPyKAyWDK7A7NZxlbDCcZ0LrnkjXDkEdmL/xaqIsozv3I43eTu6aZ2H9Iwc7XggfnfwA/eoj6Je5gXX+ZqQB/gR4wv6mF2gxzLceKomDNwx7u4fXU8RXZMljOknU78AFj3Vvj8x5YQp9Z6m6VWmvgeAHq8rNq78FZ4RtzwaUjA68UkLh3ToPxKmsQXSj4ToUyPIASFcYqxhhPl6j3H/vvr0gWFfvlrhospSxQrItoblaiqtgNO+03f2BUpS/JYQ3+CHTiDzF6q5QNcQGMRcOsGt3zMz/u+e8Ux4QTtlw3LC2Qn7qKhMyHax5Sd6EFCdqFAIoj5OTf/2Zh05P0YR6XC9iInJCXkr8MMqiiF2Rf6aUjk8Du+cfwGxBV9jOE8rKL2zriTQt4KZ072HBTKFLobqcP+2NgnXb2n71VSewPyyxoHHx2XmJ8LZJpqQUGG2znpg3f7SX5tTsEFVkfDtYhOOagHKkcEJjjRvmYJDlOZfvMWe9fvBO3w/2x/3ko7B8zvh7bmosGOUR+7JYVFAzi2lBSUvT4/tAP+1O93AZ0iCvcS4LWL7yp4vLlGfivpAF8DjhGDqvUXWBJa/9yEGJmY74P2aypV9xAlilZI+qCVJytlsFuhPagRtQ1xWW4gU40B+tfjBl81ojdyvrVwheWLPyd1YepxmNv+KV5HVoQ/QdPTcA5e9LvkjiAWTgRYaFbEumagg74ItZlR32eOI5Wq7G66j00xW1c+p+TZsJRC5KsboZVGjqZETeKKsply/8RZhGV
 /kQy+Yza
 ibRiU9k7LFkcnlTI0y+fUrwM+mVNpb0BPoMl1AGe4aLfQ9/kzbn0XLTAgH9YshUY2aWvuo78AJNzksM3FPyvJal4eDv4x+ccVnlA7fodStq0Ti3e364EpU6V5zhKmkXuOm10wyOipOWGd2DaIEH8l/104avJrsp+aERy8eag7RRfyVCyG+J9gDbMM7aPXv74iAIdAmPXK7nnscD3bM81bnKPXD3VJbjOVCsUlpi8i4oqb4637unzv2ecBN3JpyiDSYT/PL1GK8bZEeppFOMxUqwECx3icAdUrQ/lSIRSKJEc8Dj7Ffm3kPaQzWW3RJJ8PpWKXYGAo3FUdfEWZS6UxQjESzMgqbR+aa3NVt67kwErNeDI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>Hello Xiaokai.
>
>On Tue, Apr 14, 2026 at 11:05:23AM +0000, ranxiaokai627@163.com wrote:
>> Fixes: f735eebe55f8 ("memcg: multi-memcg percpu charge cache")
>
>An interesting catch.
>
>> -#define MAX_VMSTAT_ERROR (4096 * 64 * get_nprocs())
>> +#define NR_MEMCG_STOCK 7
>> +#define MAX_VMSTAT_ERROR (4096 * 64 * NR_MEMCG_STOCK * get_nprocs())
>
>When you touch this, I think this could be factored into it too:
>
>+#define MAX_VMSTAT_ERROR (sysconf(_SC_PAGESIZE) * 64 * NR_MEMCG_STOCK * get_nprocs())

Thanks for the review, yes, this will improve the test' portability
across architectures with different page sizes.

>And given how much the selftest depends in this implementation
>detail(?), I see that there are other selftests that include directly
>from the tree, I'd suggest also
>#include "../../../../include/linux/memcontrol.h"
>
>and use the constant from there (i.e. move NR_MEMCG_STOCK to there too).
>
>That should make the selftest more flexible, resilient to future changes
>and it'd document ramification of these constants too.

Agreed. Including memcontrol.h ensures the test stays in sync with
kernel changes.

>Thanks,
>Michal


