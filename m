Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A7BCCCD183
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 01:42:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 770DF8E0024; Mon, 13 Oct 2025 21:42:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 721678E0007; Mon, 13 Oct 2025 21:42:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 636E78E0024; Mon, 13 Oct 2025 21:42:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4E40D8E0007
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 21:42:55 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6A4808848B
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 01:42:54 +0000 (UTC)
X-FDA: 83995021068.22.A36E0A5
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4559940003
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 01:42:52 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=INaU7l8+;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760406172; a=rsa-sha256;
	cv=none;
	b=7zm1KtzrA/fBSD0Y5t6vNUkJzZpYmzQNMJkGnA4BUOLtMbX7vPY5lBrbmd5AIQEc7yVl5k
	u1WJ97UImAEcWu7wP8CN6aO/1+a+Qnw2kEpV1tEIrci7uCVNeu+Mc8W6CL6nrrCPmawmN7
	VtdHo6KXOCz4qgmW0d6rHwxEtA6NUcU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=INaU7l8+;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760406172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EBF0Ps2ImCzZ4tZ3MrZ01lPp3rnT5K2J0edlyN1v5io=;
	b=W+mlgYT6mUbuH/+4R1GqwSW5Anub8d6hqsRVcUqe3t4ct6JEgEjJw0J/INsbcWW3LKKLSw
	k2riP9R2IbPB/8Rsys4/K/+L+hxdElfzDzBlffBjYTyK4RD+ZDMNvWXClBrfvSRgaTUpLZ
	xIRgY025UBaersWkh964XyGLOarKj1M=
Message-ID: <b5f40a6b-482e-4e06-91b3-d6ad0427de85@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760406169;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EBF0Ps2ImCzZ4tZ3MrZ01lPp3rnT5K2J0edlyN1v5io=;
	b=INaU7l8+nLdnLaKBJrkREE4PEYNLcdAlPypw+HDjgAvWXi5r6uA0NTeuoAKSKy+xSMk1Ay
	WnCqeyQnda6EuoiIL7SVQ4MG9Jad+4HrKCZISBB+rXLdUyNsongpSuLEUqKgxd/4ZnP7HK
	OT7EB/j/yEn8rzpgIn1rwdY49db/oKE=
Date: Tue, 14 Oct 2025 09:42:44 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 1/3] mm: mprotect: always skip dma pinned folio in
 prot_numa_skip()
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Liam.Howlett@oracle.com,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, linux-mm@kvack.org
References: <20251013121536.2373249-1-wangkefeng.wang@huawei.com>
 <20251013121536.2373249-2-wangkefeng.wang@huawei.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20251013121536.2373249-2-wangkefeng.wang@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: f5rc6m96amdqsjqxnrcdna3oaz6iqqwx
X-Rspamd-Queue-Id: 4559940003
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760406172-824162
X-HE-Meta: U2FsdGVkX1+mqdmRkmq5OSYUrx6ppfkFq7GHpyDYLttw2cH05EtRK099E77/p17rYNwWliFgqHkALh2jboo/SrAkzGw6ujTmilWKCbSV4tSJi52oXY9C2NwREsWru4KpoOx54CpjS9uFJKA84IZHiRMaTlCYsvtXUxpG1JzeCgtkZlF9j5iv1nvJEdHS42D5lnU4Mn4Mhm+lH2KdUfaBlA5ll5FJUp5j5LYOTNkarO7LLEO8ZtK6fyhGBe2NPqR7i8ChFx1dZVIlsH+B0pkT7mWWEes7sDvrXrLx3+eSzRVf4YJg4VerrPJqoeSPvCfAGZjlhURG7zlr4pu6EbQLA2YxzDlns0xU6eSRVRaXg/EgP/RbrwPGcUQ3ZYgjiSF3d+MQlEe0LS/3cYtMLCpCdPANVFnIWF46A2dbNx3Imqd2zF84QmPgmLZSsNFNTrgeVRSIXeYHYS/CWwb+bE1VXnZOLC7thrclNbZFlLpqelBGi/tks5MHIeDl9Unoxx3u+piz7vtObPiZMu1cm6u5UjlBuZ7zgJR7QSF++3bsYO9Tr1aJKgaHANZGY95E52QdH2pqqPQnRw7AONIpYU4vuIcE+TZhLviNUbU97+SITGTeolQfkyoj7uS5Wv/U7klF4X74Tpd1D34UD8LiVqwOg3yJYHEuoNPLlV1RHmXSQRq8ljNdLSdzlccHoQHltNTRJAsguvHRdFqEoV78+s38doNqbavdIU2ucLD2Y0ZTicjMx7lnfJelVs66WRaCtHTKDGCB6lsbjoEkrUnDfRaKTPq1yZ4Gt1CzFbSmUMHfKjcffcxXS4KlTHsiFHXUJCgfzjqrKLtb+zJSxbE5vGdVUPqVtcZu/f7LfPOF3+0eBUxlqLFnto98BB1emtJ6M+CbU3EHUDUXmHPHl4fNQGEYoSE3wMYXYo1eaDyUJlELiLsuLRFDExdG6LKEBV9LkdfPpNiggp8/5E4yiCumLC0
 rIHXHAwG
 O40vIU9rtSyIRkYDTsDu+n9xfCk4di9kqQZeNhocvqADOoYTPORKuCmXQEQTW1f1JiqrQ6Si3n23AOO+apyDjeExgU6nBfq8AgO4sE8swsYIl2zATOmK5G6TJLcWA4msoirzJchBPpsKGKPtrnioFP11JX97fOX3R1c9KJ4nEXAXwsEuq//DYYtpKdowlZuVGMhF3Y42Vfr14XusvVCXygIWxSsP/v88QWu9vCaLxT3v7oIYERNELdjh548tEMSWq9hhQOLxvJ3Qs6cdoBeGFmWLYd/VQzGHFsNJo4qT79qx4ZNswW9PBFuQhpA4ypXiTO3BVOQSKIZVT+0x8B9gm57UDww==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/13 20:15, Kefeng Wang wrote:
> If the folio(even not CoW folio) is dma pinned, it can't be
> migrated, so always skip pinned folio to avoid a waste of cycles
> when folios migration.
> 
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---

LGTM.

Reviewed-by: Lance Yang <lance.yang@linux.dev>


