Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61B83CD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 15:31:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A01936B00E3; Wed, 20 May 2026 11:31:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D95E6B00EA; Wed, 20 May 2026 11:31:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C8336B00ED; Wed, 20 May 2026 11:31:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7B0486B00E3
	for <linux-mm@kvack.org>; Wed, 20 May 2026 11:31:28 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1D5B7C18C1
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:31:28 +0000 (UTC)
X-FDA: 84788187456.06.1EF0D53
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf24.hostedemail.com (Postfix) with ESMTP id CD61B18000E
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:31:25 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UrD4QznM;
	spf=pass (imf24.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779291086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gxePXEMQDWwNnRA4fuUAEJ8toZ4JkLQ6obW+0ibr2gg=;
	b=ozSx2UWrK3P2VAxZzL6u3A4AXqV4p1N/88IXor1JOJ/KNf40S9fMitkjU1pL3xaqmFrGi2
	azF31MpmllGdNf8DTq1PmUSQJazE3gq23ZZsMrCRXfRuOf1JTjelrhN23wSkic0uVXk0Zt
	CKLKMdRgM6rPwhQVdKnbyC8gG9oBVkI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UrD4QznM;
	spf=pass (imf24.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779291086; a=rsa-sha256;
	cv=none;
	b=WmREN/4eNJOVwRVp0ZbEedWsFcSjbB38DB9vnmXdNe+vnDWOZwGupHkptjoCK3a6FSBR4y
	AVP+gi0pmBdbB1qtH+pnyDv9W19JWeA1YYjS2OseNORx8RqRf5NevVzUkG2hp9bFv5uWRO
	SXGSExe8j+7qD4CSOxIEfhGVD9y++bg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779291083;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gxePXEMQDWwNnRA4fuUAEJ8toZ4JkLQ6obW+0ibr2gg=;
	b=UrD4QznMUDmQ0luAlbLeSSiws6nZUUkmtwBztn8k6zeWl1F6tpAnuJzA7kqzv5F400/CJu
	tsnsT0njTgvs2egS7NWnQZ3sFoLN2sNldH6aweT3nAwMm/SUsrALg/hSZ40qnAurfGkQIy
	7NDdgJx0NZYt+FVg9eFvyCYbotjwbEw=
From: Lance Yang <lance.yang@linux.dev>
To: david@kernel.org
Cc: davem@davemloft.net,
	andreas@gaisler.com,
	rppt@kernel.org,
	akpm@linux-foundation.org,
	agordeev@linux.ibm.com,
	gerald.schaefer@linux.ibm.com,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	borntraeger@linux.ibm.com,
	svens@linux.ibm.com,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	npiggin@gmail.com,
	chleroy@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	sparclinux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-s390@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH 5/8] mm/bootmem_info: stop marking the pgdat as NODE_INFO
Date: Wed, 20 May 2026 23:30:55 +0800
Message-Id: <20260520153055.61173-1-lance.yang@linux.dev>
In-Reply-To: <20260511-bootmem_info_prep-v1-5-3fb0be6fc688@kernel.org>
References: <20260511-bootmem_info_prep-v1-5-3fb0be6fc688@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: CD61B18000E
X-Rspamd-Server: rspam06
X-Stat-Signature: msbqbakoy5iie6ubysjox5g58usgnf7p
X-HE-Tag: 1779291085-886540
X-HE-Meta: U2FsdGVkX1/mHm4uAlvrv6Nr2cUwMgsXy1TYY/kYxHghjQJHIGhgu0OOl9yTjP4zO54HWA2lo8BOnWFgwYqi1XiS8Jd4Y2CpwvoI/4d+mNMXYUiYNUaDVYf3CnAFW5HUeggHbwMPF5hH9braphcWrrheS9j0katPzNiXHWfIeeSwNRM2i7tLiOnlRB2OqtUlew5YapVLMsAQeVKgEoknrPXHUXA3gANhSN/uZwwyQbQm1C0m4DR8xp0fpQb9P22ATR5N2WrKzENSjeoo1Reu09zm4COrpoV+YTRS6pvlRRrA04OZy2E4TM+bLBQMem6grq9QDsmZegA68E3b871dnO7U8r29Md7bTVfeWak1EP8nqnnmtQL0pH92SrOimxsOgKd/K47WotYgK1aMlb/r1NzrYD+Fn3WKH9TtVXOZJ7c4F6OuW+NJlHrlZd65wddRyE/WSBcEkesjDldwruJMFUUAzKOR0YwulQI4yR1HrNjmyGnYajaYn9TgvBMFlaOqWDOS/zVLjKIl/qGfoJzF0rxoo2ZJyt8DEwrgfrIX6Gr+P7ctiNkmCQTUwKDLg/LwGzSqleeF3tQLuV5O3seQBewFW5g0sz27IK9D2H2xLuHja65x9ghe+uhvnhARjls7WxlLINroCqbFxsW7zdxBSwNw18NVY9voSuE/smb6o/79U1cLreBgWrncvrLRPqxNGeVIYtFtwwwWvhS1PakWV1BA3lg4x+4T/DqiuFfZqdznvmYdmr8+fwMs/oMEIPvmLgbCj250GzCQdeAhPo7ijgrLQu71UsPoOIWbGPNoyNPOic2nZJk+l1JGUbf0Wem8k27qb9utlwvA7fWwKvYPDHAaAuxhvMt8ypibUw1iERYPDiC76v2tmE0AKE97sBTbGJ4mOwz9JJqEgwMX0rLRQOcCyPQ/y1FBfZsGfznukkAipEuh+TXKtuvQ6jJTNzt4RByOwBfzcCbyolOk2Gk
 8K0ji/fu
 G9E2cviNYYYKdAjzo34o+myanx/e6zFAGjNrX1wRsnkinpKpaOy16HYpBi4bW3tz0L8nErO9y+QBYT9eha3G1y4cKND2d6pbRBLCqG1q6USZHBGRc/ddz93QUgnTG9qCf1DsBMb8rK5mRiPQSPuojnzAmqDry5r7nQXelDQUd233wFQhmukcCezVlDlARrQng7UbppYivqIJCPPCpb3BGpy12vzWaRb5XEFfhi7sfwq6A/+wkOEMRWGoPVCO9nwooWh+DfP0HK2shpYtMJgJSHo5htg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Mon, May 11, 2026 at 04:05:33PM +0200, David Hildenbrand (Arm) wrote:
>We removed the last user of NODE_INFO in commit 119c31caa59e ("mm/sparse:
>remove !CONFIG_SPARSEMEM_VMEMMAP leftovers for CONFIG_MEMORY_HOTPLUG").
>
>But it really was never used it besides for safety-checks ever since it was
>introduced in commit 04753278769f ("memory hotplug: register section/node
>id to free"), where we had the comment:
>
>	5) The node information like pgdat has similar issues. But, this
>	   will be able to be solved too by this.
>	   (Not implemented yet, but, remembering node id in the pages.)
>
>Of course, that never happened, and we are not planning on freeing the
>node data (pgdat/pglist_data), during memory hotunplug.
>
>So let's just stop marking the pgdat as NODE_INFO.
>
>Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>---
> mm/bootmem_info.c | 9 +--------
> 1 file changed, 1 insertion(+), 8 deletions(-)
>
>diff --git a/mm/bootmem_info.c b/mm/bootmem_info.c
>index 74c1116626c8..cce1d560f094 100644
>--- a/mm/bootmem_info.c
>+++ b/mm/bootmem_info.c
>@@ -62,15 +62,8 @@ static void __init register_page_bootmem_info_section(unsigned long start_pfn)
> 
> void __init register_page_bootmem_info_node(struct pglist_data *pgdat)
> {
>-	unsigned long i, pfn, end_pfn, nr_pages;
>+	unsigned long pfn, end_pfn;
> 	int node = pgdat->node_id;
>-	struct page *page;
>-
>-	nr_pages = PAGE_ALIGN(sizeof(struct pglist_data)) >> PAGE_SHIFT;
>-	page = virt_to_page(pgdat);
>-
>-	for (i = 0; i < nr_pages; i++, page++)
>-		get_page_bootmem(node, page, NODE_INFO);

Cool. IIUC, pgdat isn't freed during memory hotremove. Offline nodes
stick around and can get reinitialized on hotadd, so NODE_INFO doesn't
buy us anything here :D

LGTM, feel free to add:
Reviewed-by: Lance Yang <lance.yang@linux.dev>

