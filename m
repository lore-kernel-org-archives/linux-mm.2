Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FD86CAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 16:42:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1ED88E0107; Thu, 18 Sep 2025 12:42:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF6C18E00F6; Thu, 18 Sep 2025 12:42:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0C198E0107; Thu, 18 Sep 2025 12:42:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AFF168E00F6
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 12:42:43 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5C9BD11953D
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 16:42:43 +0000 (UTC)
X-FDA: 83902939806.13.D621C72
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	by imf11.hostedemail.com (Postfix) with ESMTP id 50F3040018
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 16:42:41 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=Y6pdPutQ;
	spf=pass (imf11.hostedemail.com: domain of "prvs=5356f0da48=clm@meta.com" designates 67.231.153.30 as permitted sender) smtp.mailfrom="prvs=5356f0da48=clm@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758213761;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MRSW9PRf260/9Gt/pZkcfX+wCWrRuC4hgtYNOmdFk6E=;
	b=HiwIDaRlIidGTh1vgFAlfhQ17SSbb+B7xpPdTYOYiqzbnzTAwKUMxZqandFRPkSeERIio4
	dYmNRUv9/qWGDOaj5Mj5hWxTmbZsYNxxX7/Vqe3Y9nCZCsn2ivLsaD8P1i0iZ7+G+OAora
	EaBEbHvFbHPSkEWUu+Z6CFsCnCNc4mI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=Y6pdPutQ;
	spf=pass (imf11.hostedemail.com: domain of "prvs=5356f0da48=clm@meta.com" designates 67.231.153.30 as permitted sender) smtp.mailfrom="prvs=5356f0da48=clm@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758213761; a=rsa-sha256;
	cv=none;
	b=iuv04xghnUCEyeVe9u5pNFGqnMBoCtEKUZgflwdblD2mQMK30b6pKmT2Qt1uKDfuDH0cUx
	xtzGLfTEfUp8DG4EnGkYOGQg19VYezHZPIoI9ngmZkSGWcEUKKhePe9mUOPZvYIoA4yXNp
	AG83oPxCnamW32/7VhlkmCxUzjhmj3c=
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 58IFxXiI3010287;
	Thu, 18 Sep 2025 09:42:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=MRSW9PRf260/9Gt/pZkcfX+wCWrRuC4hgtYNOmdFk6E=; b=Y6pdPutQNUYI
	1C8YElettm7FxkgbNkPvwspxlu1INvT7ipj7MjnYKDKawHPwipzn8SJi+ILr3RqA
	ziVqa8rd/B4uSE18DHIZGtd6/yhHh/dAHZ0dLKSWWvJ+3rIRGJGqJhptF9Hrvt8Q
	SGYSM1BzpjgbrYtkm3E33uI1aBMvtMcvDx2e4Sz2dO7Vmm8kMqpoq66ZGYImaOhn
	S9iSrSc6o/DWoKwmBYgrz8dzhRkTTV25jenhk3McaBh1y/ZjRDWB9eEDziX6Auxv
	lTT6rDC0rATRyk4CUiKWpvhfmUKFfdlniLIkF+zI4juwb9sJPVRfH0arFTh9jOdY
	QK+J6UraMg==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 498dekbkmg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Thu, 18 Sep 2025 09:42:31 -0700 (PDT)
Received: from devbig091.ldc1.facebook.com (2620:10d:c0a8:1c::11) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.20; Thu, 18 Sep 2025 16:42:30 +0000
From: Chris Mason <clm@meta.com>
To: Balbir Singh <balbirs@nvidia.com>
CC: Chris Mason <clm@meta.com>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, <dri-devel@lists.freedesktop.org>,
        Andrew Morton
	<akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>, Zi Yan
	<ziy@nvidia.com>,
        Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim
	<rakie.kim@sk.com>,
        Byungchul Park <byungchul@sk.com>, Gregory Price
	<gourry@gourry.net>,
        Ying Huang <ying.huang@linux.alibaba.com>,
        "Alistair
 Popple" <apopple@nvidia.com>,
        Oscar Salvador <osalvador@suse.de>,
        "Lorenzo
 Stoakes" <lorenzo.stoakes@oracle.com>,
        Baolin Wang
	<baolin.wang@linux.alibaba.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain
	<dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Lyude Paul
	<lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>,
        David Airlie
	<airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
        Ralph Campbell
	<rcampbell@nvidia.com>,
        =?UTF-8?q?Mika=20Penttil=C3=A4?=
	<mpenttil@redhat.com>,
        Matthew Brost <matthew.brost@intel.com>,
        "Francois
 Dugast" <francois.dugast@intel.com>
Subject: Re: [v5 05/15] mm/migrate_device: handle partially mapped folios during collection
Date: Thu, 18 Sep 2025 09:42:07 -0700
Message-ID: <20250918164213.2866702-1-clm@meta.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250908000448.180088-6-balbirs@nvidia.com>
References:
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2620:10d:c0a8:1c::11]
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE4MDE0NyBTYWx0ZWRfX09D5wzG1g1J0
 lpfwp5tRS1QFIV82x7ZEba60J34+rUhvgAyuPxfE+SQGFk5ZpkE4naGPpkpKhLO+pKSOqnNhtb/
 bQAsIfJD0XqLCzi5UHNKvl+lV2R+yonbyCdFwHNyrRK6Xt45aF6KiHJk6NYCBUOKMtsGOoX3U7x
 O39VaDjR228rh2VFFL7p+/+cYPDdVXpe54Eg7lOumaeNnoqh/Yt4wrU1xxvMM0XxJftw5tvIxVY
 QMIf6EJxoUgEs/twEE6S0A7t0Va1WRGzz3AJ70mC8f6hW0Uko16tgRmoObh8qaoP88F9elhu2p6
 Vocsd85DnZ1VDmsBb2XjQWTeAqteJwUOYq5RLveh2FHDCO1cgjIN+SRBq0F/zY=
X-Proofpoint-ORIG-GUID: j2nobX77OFnJOXWbfUlIfqTNJlMlS_Og
X-Authority-Analysis: v=2.4 cv=Od6YDgTY c=1 sm=1 tr=0 ts=68cc3678 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=yJojWOMRYYMA:10 a=Ikd4Dj_1AAAA:8 a=qDUe-vZ6ZZVRykDNhw8A:9
X-Proofpoint-GUID: j2nobX77OFnJOXWbfUlIfqTNJlMlS_Og
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-18_01,2025-09-18_02,2025-03-28_01
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 50F3040018
X-Stat-Signature: 99do5j1g7ci9ho9jk7rq586cy9wjxt8p
X-HE-Tag: 1758213761-619765
X-HE-Meta: U2FsdGVkX19QcQFUF8Z4XJDkzUhTkAWRW1TTT8FQbmcIoToHVxDaI6f+1k/ddqoQ0iDst/e0cX6Crif9eHObFi6sSBZD+eTwsEJr4qbw8iE1bYQln6ehjqk0PenQt6wk+yYVtoClN6nkAqcxynViEZdHtA5yE98WQiA4eZpvirHt3X/+tzX74Lsuj53l0HImuf+lcfgGg9uOyDuImbppClnOWh+J8zHZ1/jHzRcSczelrC9Jmx9q5dL4KDggJpmu7eLLzylhEEh5IByquEShcENpR8n8UzbrSXSFTKMJbEi6k7iIf31BEDDGTqWEMNXYm6P1Y674ZmmTDCMIrcvY/1WbrkBGV12BpKadkS0pkytgAVe7IooqH4i2QQfMBTn6gL4BniiEWEMCuXm8siXGdL04bD+eY9ZDmkTjXfKergR1txx0+ylo8QKCLKqYY/gb9ORm/ccFiyQNxi84FRIrGEXTOg0wqs+r9SvOkBUK2KW59xSyvWSF4l1mhQBwWzUa+9/xf8G0zU3mkylnYicq+9QUpnLcKbVQvQfNEuz5OShEUrO5nVfIuGpT/kkvvLHxsDgvtwyb9wKRCqmRyJpq3fGNMnm4WDWdQFo4xJLsjydSGog6DHNde9jvXmP3aKqK2jYZyO5emFSkllTsRSIn+GNNtcR/nTt9TBZvqjbeFG2ofphMnIm0YNLa+zIj5rHlVIDUoyiUW718UptuMo2u5EDMeG1cGSjNZv78w75swXSH/PHi2bdv0++lXF4P53n3hGt/dSwwz48dU0i2j8igPPHOFcDiNpDJITEwwkfkSpIWMu6/1BmtNJRndpgZ++y++RHd3nimj3Rl3vqyeC9htyAnN/++LcM6O1v07mx87OkzTBY57zTbFFWE/rnmW+9S/ky/heGUJ31MlGndJLtJPAVrXNAcZ41p5qrLMprHRgHyewLVNadVPz3xYOsptH/RoPTA8Aqd8EhU2Wscb5B
 mDFgxpHP
 Uj09xGpXeWFT3FSewbWX8ZAcGiQhhFHZUq4pfBj2jqTGCZroSJunaIn9oA9t8qcnu0kdC4Mv0JmBbWnMxRg2A4lMuZb6kQ9XzSt4UrNn2yeMhk8ODNum9yXZznyAzO82KpIPDcFt+KD0tReEwZ+bqBDCfXeqxLfp0PSJTWNI4q3jamJFsqi6uuyFgDGL6NMph9e6zDmxGOmy86CT8FV5BQ1wPcRtXZNK4Ufni6dhzt52Tu25UDWRv3W1JNZdpjAJ3WPP38WHCmjYn0Qxp/o7oPPamdlLqMR8O7hHZqZSZ0js/Qe5Z5YwzV1cD1RlTTH9dTK9hjiuiKRXi6sFRjLLGmAcFtZulMJOjNc8E3S66hUBHqWl/r59VeDm55GhncjJcT5HJ44VBPKBOK1lVcUCFGnZF76X0Kbw61sM1CssMJGOcbBxTdrJ/kirtkRoV/m04PdiosDPInMEzmykMvvmTbM1ZPTSm4mWEumJ2pY8lQdTZJ+3C1ZmIswBocfKXBEZMvVOgEtzvhYUzOhe3BET86/HwQPjdQTHddF8FzlMb2X6Re6U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  8 Sep 2025 10:04:38 +1000 Balbir Singh <balbirs@nvidia.com> wrote:

> Extend migrate_vma_collect_pmd() to handle partially mapped large
> folios that require splitting before migration can proceed.
> 
> During PTE walk in the collection phase, if a large folio is only
> partially mapped in the migration range, it must be split to ensure
> the folio is correctly migrated.
> 
> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
> ---
>  mm/migrate_device.c | 94 +++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 94 insertions(+)
> 
> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index abd9f6850db6..f45ef182287d 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -54,6 +54,53 @@ static int migrate_vma_collect_hole(unsigned long start,
>  	return 0;
>  }
>  
> +/**
> + * migrate_vma_split_folio() - Helper function to split a THP folio
> + * @folio: the folio to split
> + * @fault_page: struct page associated with the fault if any
> + *
> + * Returns 0 on success
> + */
> +static int migrate_vma_split_folio(struct folio *folio,
> +				   struct page *fault_page)
> +{
> +	int ret;
> +	struct folio *fault_folio = fault_page ? page_folio(fault_page) : NULL;
> +	struct folio *new_fault_folio = NULL;
> +
> +	if (folio != fault_folio) {
> +		folio_get(folio);
> +		folio_lock(folio);
> +	}

Can fault_folio ever be non-null and different from folio? Apologies for
not knowing the lock ordering rules but this jumps out.

> +
> +	ret = split_folio(folio);
> +	if (ret) {
> +		if (folio != fault_folio) {
> +			folio_unlock(folio);
> +			folio_put(folio);
> +		}
> +		return ret;
> +	}
> +
> +	new_fault_folio = fault_page ? page_folio(fault_page) : NULL;
> +
> +	/*
> +	 * Ensure the lock is held on the correct
> +	 * folio after the split
> +	 */
> +	if (!new_fault_folio) {
> +		folio_unlock(folio);
> +		folio_put(folio);
> +	} else if (folio != new_fault_folio) {
> +		folio_get(new_fault_folio);
> +		folio_lock(new_fault_folio);
> +		folio_unlock(folio);
> +		folio_put(folio);
> +	}

Same question here, do we need trylocks?

-chris

