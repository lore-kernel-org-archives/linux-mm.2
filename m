Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A5C2CD8C9D
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 07:19:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C17D56B0088; Mon,  8 Jun 2026 03:19:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC8756B008A; Mon,  8 Jun 2026 03:19:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB71D6B008C; Mon,  8 Jun 2026 03:19:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9D9C36B0088
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 03:19:31 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4A785A0A09
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 07:19:31 +0000 (UTC)
X-FDA: 84855894942.24.30F7EE0
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4DAC2C0002
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 07:19:27 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=D0JOnQZu;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780903169;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2l3Ys9A0d7kMMYqyWyEIIwgaM2b28UgnM/Zf6Rmaavs=;
	b=ESiqtU3dfg6kR/Lef/uzrxugy0rnFoO+caA0zbgBxqREojhHRO+M4OAdrZY8q47qW0KVXR
	lKKroBA1vBdT2OWJ8sbIr1KAEXROhiasvcfwjM1wh6/OxD+rA5uIzWW6FPlhYRagHaoe5f
	fTQnib5KMN5QYGR01gCwHH2Qtg8ntIc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=D0JOnQZu;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780903169;
	b=8eSeLS1kO2C2jChEIcr/U9sxDegUbGdcSJa4sfd8AxnKdt8MFw42HvQqwKe3vC0G+yHsI/
	r6OjpEwlzY1rEMDmBU/w9H0n0NSjXJYCdhq/3Mp2Cz33zJ0iTUL+Rm8LvKBOnKBVrHqe5A
	GgfvEBHocO2Fq0DzJMp+mBMKnOpWxwM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780903164;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2l3Ys9A0d7kMMYqyWyEIIwgaM2b28UgnM/Zf6Rmaavs=;
	b=D0JOnQZuPDhZzxZuSjhJhdOLC+GZpAev1ypxJ6uQBHSkd6EdY6SwAOV915TmagKr2IOF6x
	TGVaaIZy2hJhjPEDqYrjbCaLBN31Ph86m1L1SuK8edrzff325L4wKYQ0RTMz0JxzpCb/dT
	SEFZsbuASzgj7yeeY4Bv/8kqMJIbhyI=
From: Lance Yang <lance.yang@linux.dev>
To: npache@redhat.com
Cc: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	aarcange@redhat.com,
	akpm@linux-foundation.org,
	anshuman.khandual@arm.com,
	apopple@nvidia.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	byungchul@sk.com,
	catalin.marinas@arm.com,
	cl@gentwo.org,
	corbet@lwn.net,
	dave.hansen@linux.intel.com,
	david@kernel.org,
	dev.jain@arm.com,
	gourry@gourry.net,
	hannes@cmpxchg.org,
	hughd@google.com,
	jack@suse.cz,
	jackmanb@google.com,
	jannh@google.com,
	jglisse@google.com,
	joshua.hahnjy@gmail.com,
	kas@kernel.org,
	lance.yang@linux.dev,
	liam@infradead.org,
	ljs@kernel.org,
	mathieu.desnoyers@efficios.com,
	matthew.brost@intel.com,
	mhiramat@kernel.org,
	mhocko@suse.com,
	peterx@redhat.com,
	pfalcato@suse.de,
	rakie.kim@sk.com,
	raquini@redhat.com,
	rdunlap@infradead.org,
	richard.weiyang@gmail.com,
	rientjes@google.com,
	rostedt@goodmis.org,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shivankg@amd.com,
	sunnanyong@huawei.com,
	surenb@google.com,
	thomas.hellstrom@linux.intel.com,
	tiwai@suse.de,
	usamaarif642@gmail.com,
	vbabka@suse.cz,
	vishal.moola@gmail.com,
	wangkefeng.wang@huawei.com,
	will@kernel.org,
	willy@infradead.org,
	yang@os.amperecomputing.com,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com,
	zokeefe@google.com
Subject: Re: [PATCH mm-unstable v19 09/14] mm/khugepaged: improve tracepoints for mTHP orders
Date: Mon,  8 Jun 2026 15:19:13 +0800
Message-Id: <20260608071913.81568-1-lance.yang@linux.dev>
In-Reply-To: <20260605161422.213817-10-npache@redhat.com>
References: <20260605161422.213817-10-npache@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4DAC2C0002
X-Stat-Signature: o5guxr48dfh5sop1kat3rqzzf9rwgcfi
X-HE-Tag: 1780903167-978014
X-HE-Meta: U2FsdGVkX186IuAQKvc6I+qJWpxuccbP6Z2c2ss8V1hlgXSyRb0gAhTdQxVtpcVxYtJ7cOGms7xkL0afvGbggRkKOrDoImNyuWGcZZ7+mUkIUti7utdk6cFrOzQXo5Io1Xyums1TfwaQyugyysBUpgjS11/vWJ4uQLr/9yEaeYsZdmOodsisOzWjqQ0nWH/Qiro2+HmnG2LZQ5Px1ajQfld2BfrWpqs5aI7fuDzdUqx4giuXv5JsUhaLgIR/f3qL7eiGidm950Bb5AQ/YS3iQAJX2NrTW3gV37MZjm7a0WaBvM/HWsnnUo37l/uaPvIZa6sMfMJNXBB/e3Gi9NJ2b544DOgam+sS+oVQWo44MAEEEUdo6IXt8lGBTjhu/xco4Dho3HNwswkTD2qSYIy78r+PYt6Kd2LCNcOG+oS3SU9CP1ffxjT61RPMx85wpPzQvSKaRzC6iZJ3eOD8SdR4sbb9SZGyik39AbzoQFZFcT1nAQjSiUO9RR/2UMRgzwtA5A87Av60ELZVV1gxl/tA+3KCERSuU6Z1gBAzOWtyyzB+rf+qi2LK72UKtLM9zNoNcBXUF2Fd4eKACX0I37xXVTeyxZ51FoCaXb18SoYkoHtc8mU6OWtCZx/aNXKo6pYYr2ut9Xt+J6K4Ud5v6YtxlANwlUw+SnUhFORMO17zPdzR5QSHxVKHZkeDN51IfrJIpF2Ita9Kwn+SwvGDjKcBZ5PZApARl0WhvLBRtb/5IlczDxDx3uWtkTSx2tHLMQtJi3ijZky6wFMVxWOdrg2/Dw9mpvLsT+x2s/Sq1njxxEea+jLfoWEHMjJTo1cuUSasSsCogxHEP/0aAdJJB3IB78i8z3TGztboEeKWhcoW2lse6dWwVtIxvs7+Wco46QsNjElsHY1nYZeNW9PLCgp/uhrW5QaclS1xMofxIpA4AUA1IOR4CC3auxdYrcu+NmPywMmARptE5l3C0nefDu+
 H11Q/q1q
 AT0DBRAZ0Xt8MSRmz6Az1SHND/nu2jFcqOY8nRHl9eL78/eYvitgZl5jAPCdE/3CMOQM5CuyqXorOquCPejflnv/YcLXNxYMT1SF8dsovDgopIpXZ1Wb9YrYL5bnatf4oySK/CTrx/KmMRMNTNkTljuuatfm1Yq3tFMqWBAaOATZYWlfAvUJRBB/Y2UxAgvMMhiql190SRmEHsUunw4NbaYs+zjBz5XgmTWMe2Sy0b0yFMxP9UmMZ8NFF36mKSv+147POkaWfe+H3uD8fsFaXB5smlUtxl1Fo0EPNpQChMcETwKGcJVg+rooxz9uAtHa58DG6USzvt0Th9bFVANXAihvBfplWSnzy6d4K
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Fri, Jun 05, 2026 at 10:14:16AM -0600, Nico Pache wrote:
>Add the order to the mm_collapse_huge_page<_swapin,_isolate> tracepoints to
>give better insight into what order is being operated at for.
>
>Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
>Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>Signed-off-by: Nico Pache <npache@redhat.com>
>---

Reviewed-by: Lance Yang <lance.yang@linux.dev>

