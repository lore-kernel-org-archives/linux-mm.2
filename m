Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4DEFE92FD9
	for <linux-mm@archiver.kernel.org>; Mon, 29 Dec 2025 20:41:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 069B36B0088; Mon, 29 Dec 2025 15:41:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 016F06B0089; Mon, 29 Dec 2025 15:41:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E65116B008A; Mon, 29 Dec 2025 15:41:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D80766B0088
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 15:41:33 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 75FE61A5F3E
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 20:41:33 +0000 (UTC)
X-FDA: 84273679266.04.1EF1015
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id D75C44000E
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 20:41:31 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QSRG7hvx;
	spf=pass (imf11.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767040892;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZmZssKPM+S2HJhyKQHBY9PFi7F/yMdlrGGqCoMigMsY=;
	b=VFQAJlqcGO0XoAsEQ8N2p6SATWRvaFUT3DoCnLqHJ4nUfyVyGrutr41I3+oKRe7GWO8h7b
	OrnlJhLEx8LU58fYmUeUv0tUEeIYOaegjw2qAytYWVKdJkQv6Tgg8NeecNW2GunLd5ojdn
	2AxYwIWMtaJyUB5XUXnVMhtxBpcQ8JA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QSRG7hvx;
	spf=pass (imf11.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767040892; a=rsa-sha256;
	cv=none;
	b=w7JNvss19nnHy76jMmJqezlYUK2FdBmguGsvA4HWVbgBKz9QlbtoggQ4GZzJ9B2V8BZ288
	j+hJUikjtCrrY6DSkgTuGphHWV1BFtIDGZHBlyaSeeU9NjCAna5G5iSHKvKplI8Rfs9g0b
	C4A0YwX1ZNfRAfaCtgEpeQ4T0ZGdIgU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EAA664183E;
	Mon, 29 Dec 2025 20:41:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9322EC4CEF7;
	Mon, 29 Dec 2025 20:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767040890;
	bh=GZ+1KKfaWUAEcxuxIpgqLNo0r9p6egS5f7P9gKbzco0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QSRG7hvxBwQ796IfjClt8gqnHeEg9FV3z8mjQpYJOHPTnhcOUr+/cnAT4eS+xWhcw
	 Ry/Yz2NJZ5DA5UhE7xlqILcigyZGgJoMpuIuB0HMrcb7Ey7m1vgaCm9xAfhtLSz4bn
	 sbTYmz31UIAeLJcFVaXN7OOZdttuepR+uxZUfFaBQo541btafW7mlmwhzqU1GM58MY
	 M1UJdK4hRPnph8apO7+VSUObxlZC5iMC2GiurW2KC0C0UTBxkCWb1C8TBghjVP78ye
	 lD82sIfiiyao8xdsYvHQc2rwHPPIbHwa6sC1CjLJJW0iqFCco3pfM0oBcDvtUsNP3Z
	 l3grsjsZqTnwg==
Date: Mon, 29 Dec 2025 15:41:29 -0500
From: Sasha Levin <sashal@kernel.org>
To: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Sourabh Jain <sourabhjain@linux.ibm.com>,
	linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
	Heiko Carstens <hca@linux.ibm.com>, Ingo Molnar <mingo@redhat.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vasily Gorbik <gor@linux.ibm.com>, linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
	x86@kernel.org, linux-riscv@lists.infradead.org,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Subject: Re: [PATCH v7] mm/hugetlb: ignore hugepage kernel args if hugepages
 are unsupported
Message-ID: <aVLneaA6gaGUaBJS@laps>
References: <20251224115524.1272010-1-sourabhjain@linux.ibm.com>
 <20251228143533.33e2be2d6282d036f55e12cb@linux-foundation.org>
 <398ca47d-19d4-4b26-98db-2bf283b6b0cb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <398ca47d-19d4-4b26-98db-2bf283b6b0cb@kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D75C44000E
X-Stat-Signature: ajxxaahsieg5186qs9bu1ztgjbn36ka3
X-Rspam-User: 
X-HE-Tag: 1767040891-435005
X-HE-Meta: U2FsdGVkX1/QfD2c2/lWoaqwCN5S6RIXUcZc4G9URHrOAlaRjfR6n86usf8oF4yskbRHTlEPQ35W1ksSRBP32Rbzu3W4tJvPZ2JsrFcSofKEY9N2G1cg3LKdHbqqeCzJ7T6PsJfyAiZSBY211M/1jYHvpOD5FFM4wo24Uw7NOKF3eTqZQb8XjaYLG2SYa9doPlMe9r1iZYJcD+C78rcMWITTHek3MeQAAi5l60t82pwVr25gyvUAMxaqKKy11DIPdvf6RylEQvMKHFJ8g80aSQdBjTyUX+NjWCTf4q3QULBXL/FnHs/KM4kcitnZt8JKwdS+ocqkTLWlgp4FAxujpHS2LoN9Vx3SbjKahlCptmcGIaChSw0tEnXVBW1DEUDPAGnNfcF/iHStvIt904Jngse1496TvV81HKmx1YHBybRHnARIjNnFD4n1geVMYMWxZqCq6Tpr5FQ4PQNigrarLL1j6zbX0SinTXQlF6BVgfI+y6jCxRxIgpjX8nfsuEd80AGiEEj6rlo4SywucCzNzwYkOJOl7pScd6S99jw7N41M7DPToruGSYxQvx89lOW3vd7DgAsNByH5hsHb6kI2htfzN8B9roXfYRpnlSEY0oLKKTHX+2Iyr9Ba11ALUYXsH53DPyhe+pmbX+bjf+egqe0dgCx93fJyeRAmxjAufCIrWNp+cBLXHlpY81yPnVcy/13ljNBHyTVvORZyR3Ecfz4DwqvItM/4gHQBXpdPlxryCGnCQdExxi15fVRrxj94id7740eG+TqZ09dW2xgWhJxEju9iSsc1DLHmPt7dxInHKIhAhpDWKBASwJpzdbLw0IamnX6Ibp41tRRyIcJK/W6qsTEtrDZ4ACDzlIuLaMz2l2hYEebzR5XzHR7qet6dVZs21coLQU0tQL8aHjBn/jItqO/tRajgrUaMyCljtzMkOomJlsfhneMTwYeOj/Pn3T9PSgy+mBM9Q+ozeKZ
 UmCzQ2qH
 PN6SIrzN94vatk6uUr+4JvuhBDg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 29, 2025 at 07:35:18PM +0100, Christophe Leroy (CS GROUP) wrote:
>
>
>Le 28/12/2025 à 23:35, Andrew Morton a écrit :
>>On Wed, 24 Dec 2025 17:25:24 +0530 Sourabh Jain <sourabhjain@linux.ibm.com> wrote:
>>
>>>Note for backporting: This fix is a partial retrieval of the commit
>>>mentioned in the Fixes tag. It is only valid once the change referenced
>>>by the Depends-on tag is present. When backporting this patch, the
>>>commit mentioned in the Depends-on tag must be included first.
>>>
>>>Link: https://eur01.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Fall%2F20250121150419.1342794-1-sourabhjain%40linux.ibm.com%2F&data=05%7C02%7Cchristophe.leroy%40csgroup.eu%7C93a8f925fc024ff9c3fe08de46616c3b%7C8b87af7d86474dc78df45f69a2011bb5%7C0%7C0%7C639025581404027066%7CUnknown%7CTWFpbGZsb3d8eyJFbXB0eU1hcGkiOnRydWUsIlYiOiIwLjAuMDAwMCIsIlAiOiJXaW4zMiIsIkFOIjoiTWFpbCIsIldUIjoyfQ%3D%3D%7C0%7C%7C%7C&sdata=3iVUdaMBWhExKkDiV%2BBfYufPTKva1dVikhyQShOq7mc%3D&reserved=0 [1]
>>>Link: https://eur01.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Fall%2F20250128043358.163372-1-sourabhjain%40linux.ibm.com%2F&data=05%7C02%7Cchristophe.leroy%40csgroup.eu%7C93a8f925fc024ff9c3fe08de46616c3b%7C8b87af7d86474dc78df45f69a2011bb5%7C0%7C0%7C639025581404053206%7CUnknown%7CTWFpbGZsb3d8eyJFbXB0eU1hcGkiOnRydWUsIlYiOiIwLjAuMDAwMCIsIlAiOiJXaW4zMiIsIkFOIjoiTWFpbCIsIldUIjoyfQ%3D%3D%7C0%7C%7C%7C&sdata=GamDe2R87SdpFurnj9Cmt9wOQtkGLgIO1z7nl5QPxgY%3D&reserved=0 [2]
>>>Fixes: c2833a5bf75b ("hugetlbfs: fix changes to command line processing")
>>>Depends-on: 2354ad252b66 ("powerpc/mm: Update default hugetlb size early")
>>
>>This will be the first "Depends-on:" in history.  Which is a hint that
>>we're doing something wrong.  This innovation will surely fool any
>>downstream automation.  Let's use existing tools if possible.
>
>What do you mean by "first in history" ? Do you mean it's never been 
>used before ? As far as I can see it has been used several times 
>already. First one was in 2014 with commit a0855054e59b ("iwlwifi: 
>dvm: drop non VO frames when flushing")
>
>Sasha, do tools use it ?

The standard way to annotate dependencies is outlined in the docs:

   To send additional instructions to the stable team, use a shell-style inline comment to pass arbitrary or predefined notes:

   Specify any additional patch prerequisites for cherry picking:

   Cc: <stable@vger.kernel.org> # 3.3.x: a1f84a3: sched: Check for idle
   Cc: <stable@vger.kernel.org> # 3.3.x: 1b9508f: sched: Rate-limit newidle
   Cc: <stable@vger.kernel.org> # 3.3.x: fd21073: sched: Fix affinity logic
   Cc: <stable@vger.kernel.org> # 3.3.x
   Signed-off-by: Ingo Molnar <mingo@elte.hu>

   The tag sequence has the meaning of:

   git cherry-pick a1f84a3
   git cherry-pick 1b9508f
   git cherry-pick fd21073
   git cherry-pick <this commit>

My tools don't look at Depends-on: and I don't think that Greg's tools do that
either.

-- 
Thanks,
Sasha

