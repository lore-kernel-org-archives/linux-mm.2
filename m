Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4268BCA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 09:00:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8961A8E0006; Tue,  2 Sep 2025 05:00:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86D298E0001; Tue,  2 Sep 2025 05:00:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AA538E0006; Tue,  2 Sep 2025 05:00:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 686228E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 05:00:05 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1F46113B518
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 09:00:05 +0000 (UTC)
X-FDA: 83843713170.13.A6D52AE
Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [80.241.56.152])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2179218000A
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 09:00:02 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=fFtnC1zW;
	spf=pass (imf24.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.152 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756803603; a=rsa-sha256;
	cv=none;
	b=QJy5gt5AnE3bnKszFJ+T9fpZVWr3JrRuyK4hPphuWQmPVrDCe6MeFCa75F7lPbS4mzPW1v
	yCS5ks1mRJ/IsoUE53Fwj1lG1N9EZNcZzAXcB01xB3CX6eu/ZlvuDY4R7VWNkA5nCEMf8b
	wo3qeMQoFZ54f0pjnVhoLNtqK3B83Xc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=fFtnC1zW;
	spf=pass (imf24.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.152 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756803603;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u6U/TCetAKMfHaRmR9thC/jSWNiJ+4ewzJjcPKb0o6s=;
	b=6qyxYQU+VjN497S9DJ25ePmn4wzqwAaRj+YvQ/fUov71xwT5SaetuaJceyz4hyKOCsvlqO
	FOTbqC2kvK6Rm3kopaPSqAYvaEePGsNI3opucKkBcN0NfilVaoPaDOLu6TWGW7xZ6wL5Gw
	OD5/DB2tSIYjGFH/ofjhw+dB1lwdZCE=
Received: from smtp102.mailbox.org (smtp102.mailbox.org [IPv6:2001:67c:2050:b231:465::102])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4cGKSb1P72z9tmC;
	Tue,  2 Sep 2025 10:59:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
	s=MBO0001; t=1756803599;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=u6U/TCetAKMfHaRmR9thC/jSWNiJ+4ewzJjcPKb0o6s=;
	b=fFtnC1zW5WM1bgu/WlqUS/sI0OJC2MxE5x1uHvH6i4fIE165xyzxBv3FdZwJUjiyqLBbxQ
	g4c8bbAwCE/LViX2pTr7zdp4JZzAlFKCMi/fgOaJK0w/t+XCnUY7EfJFqdk+sQU52wNW9h
	40kEKzsONmRYpoT/m3a/rEpxXKETmHtAuLADBYcfnDtO+JXYmmrLXTz6xvHSHSS1EPGbO2
	Ox6+LVfcJIZUKo0hVScj0ulzP4pQHSS/H8y8PiqftQsTBfLMVKUUBzrDHQk9bpW7VllRsk
	PYRSoaoNd1FTzKOOuiwbVAAZrisJGYJJlNefrJvwYKY44e1IfEX0Ne+OldAQhQ==
Message-ID: <cdbc4c22-7a6f-4c01-8d2b-550b643318d8@pankajraghav.com>
Date: Tue, 2 Sep 2025 10:59:52 +0200
MIME-Version: 1.0
Subject: Re: [PATCH] huge_memory: return -EINVAL in folio split functions when
 THP is disabled
To: David Hildenbrand <david@redhat.com>, Ryan Roberts
 <ryan.roberts@arm.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Nico Pache <npache@redhat.com>, Zi Yan <ziy@nvidia.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, willy@infradead.org,
 mcgrof@kernel.org, gost.dev@samsung.com, Pankaj Raghav <p.raghav@samsung.com>
References: <20250902084036.208921-1-kernel@pankajraghav.com>
 <1acb705c-4846-4a12-9e90-f7853da8a295@redhat.com>
Content-Language: en-US
From: Pankaj Raghav <kernel@pankajraghav.com>
In-Reply-To: <1acb705c-4846-4a12-9e90-f7853da8a295@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2179218000A
X-Stat-Signature: pmue67iqordy57ndifphcy9ysgf54896
X-Rspam-User: 
X-HE-Tag: 1756803602-518500
X-HE-Meta: U2FsdGVkX198FchhDGIMjXuYidy0AEgBAaB0IVKZtaq0KHVBAbrETG3PP+Z8ofJHxs4Mcjcv2wKTolWYV2dsql32+0S4dRwfwzVb4MEEwbZPol89LY4uRlPciR5WGrQ4WdJbIv4BdedaaMmGG2ZNMjvnvtmDlKaHThthJNQ9lrdxx4lTwnmgoySZwMTtfhwk4+7pKeQGj5M7lEqO5o8zv17qy3tnPCNRaEGYUROAlcFstPEWJz2tmqfbutcMRtkRRpgHgiKMzu/cz4XrkpZrWR3irfjG8G6quyhfeu0iLQPnEQXCYHx1HHOmfpkOsgWSLkAege3SKxS6eHBaO0OyHpax5P1FdNWcnOsk+JDRs+RS3VoZruvRSLXYkZFGqom68cgA4xRIqDaslroeWeJIXUcLvM6E2MuCFSAT3+s1orgByMzAZlWy7/Z0myguQC/zrnzII9v1YQ0Of4G0BTwYRcDj91TRNWYbI/3AI9IM1hQA3/1tRAms71pVRFzzSFruP6tVJpQcg7QxDloSN2qHRsHyo2OVJUOsM5IZD0+dsW1N9cXJFylwR+z3L490UEyiSTAx4+/SdYirGvUgJSgoZsFL7981SSaD5tfydKdcTuVNjDUL/2LbXl6zUZ/YcSR5v/Dxy/woUB3LUk2N/GfmFOif54FcQXFCjBU54lGmMia4x5MSBKtQOgzG29RUH/iFlOu/WDXTgkBVhSR3fdrZEuaUbmWACuHsCAPxTpU6IDUlyyJgMZw+4Gi8s/TBsjmfLoEJEze/N/5jIs1VT6SmXljI0QUXvecD36UPYzqE8//knsXDtuXwbeJvHe6ocKyIaBHZx5pIlRhldyJvvIVStAu0ZHzePiR1AwRr9Y8bENUc2Ota640abDEx27puZJscJ5TyfsLzznobe9hPfIa4E2xvXgUbmJ/Jf6JwHJppFTcKtB4wVeah+C0p/g5uFRyA/W73I9QBSf+iIJ5sqRu
 sGERc2Pw
 Bn7/EvP7dhrWvcQDzETQp+w10/JTziAkI7kJpAQwrAzTnaThcdJmwL+7kVCvIoSxeyyaP/Mr2a+bVWMz7JhAeP+vot6uD2DFhQwmtzpGDJtiPMEWSclbuGApPHLD1IKczlR5oLqAvYo8A9Fhb1EewVmZwXbVw3uT2UJ1hO7SOgzG8C5DxwOJb+m4syW8XEe9QNvFSTicLMGbI0s+SRhbzPBmfunPYZIBIpGcaPRXEJ+UaHN1iU4PKr488WAlWL38GWUfYXz85k27lcfk1359TDnwPTeM2JHOees4VycKOXkaNra1AchP0JrdinZoJfdVCiQ2zLanY/4C0XOeuIZXBlXbjwi1vnilhuf5NWlqBHHMADjaQtqdi7EslUQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 9/2/25 10:43, David Hildenbrand wrote:
> On 02.09.25 10:40, Pankaj Raghav (Samsung) wrote:
>> From: Pankaj Raghav <p.raghav@samsung.com>
>>
>> split_huge_page_to_list_[to_order](), split_huge_page() and
>> try_folio_split() return 0 on success and error codes on failure.
>>
>> When THP is disabled, these functions return 0 indicating success even
>> though an error code should be returned as it is not possible to split a
>> folio when THP is disabled.
>>
>> Make all these functions return -EINVAL to indicate failure instead of
>> 0.
>>
>> This issue was discovered while experimenting enabling large folios
>> without THP and found that returning 0 in these functions is resulting in
>> undefined behavior in truncate operations. This change fixes the issue.
> 
> Currently large folios that could be split are impossible without THP, so why should this be a fix?
> 
I was debating with myself whether it will classify as a fix or not. I have had people tell me that
I should mention it as fix even though I didn't feel like it ;)

But I agree with you, we can't hit this issue in the upstream kernel. I can remove the fixes tag in
the next version.

--
Pankaj


