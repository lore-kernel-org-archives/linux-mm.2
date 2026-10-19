Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60F3DCCF2D3
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 05:02:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50CBA6B0123; Mon, 19 Oct 2026 01:02:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BE0D6B0124; Mon, 19 Oct 2026 01:02:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D3B36B0125; Mon, 19 Oct 2026 01:02:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 198AE6B0123
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 01:02:49 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 224FCA819D
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 05:02:47 +0000 (UTC)
X-FDA: 85338180774.21.F9CAD61
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2F6641A0006
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 05:02:45 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="F/vu4sl/";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf19.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792386165;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d+82KpTqWIxKLWYpfS12tE61Rj9/9wRHeFszm2cr2MM=;
	b=XeO6WT3WSxQvdDthA1sL7Vql7C4bdOfACoTaaZW/Sroo3g5QqrN/xiTIeQg6Fk0xBvbWOG
	c68VQD1eDPsGOQfnH62sLfFBlYEdzMsaDDF/XtjLFvCK63+S6o1zhlAEgswde99AkL9J3s
	u325qEHX5JnIcUHtYpRVg9yQzlcf1vc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792386165;
	b=tmQqMHCfseoGHoGuJHYHUGHRUMdA7+5Hp5eWrfQa5yz3FUurtISuBbfwFfn7EuUJj23/Oj
	uDRuTv3Wc1m9IjH6JuDdByhdnlwNTMj9ypVH6iWO92ySp9eyxsvvm04CbKNA3/cNHRvPUX
	9XIqHlDkjHT/g/QtTPEiYExcTXkHWOQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="F/vu4sl/";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf19.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DB42C1476;
	Sun, 18 Oct 2026 22:02:40 -0700 (PDT)
Received: from [10.164.19.84] (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A9B473F673;
	Sun, 18 Oct 2026 22:02:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792386164; bh=Cj/atyE4UCUgEPfqHW1EGv7amQMnd8KzvEvOkzLcWVc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=F/vu4sl/jFktMyJt2cKI0Q2G7Vdoa8O1y4xrvofUVi5wxET9PTUe8/yjpk6QDfIiq
	 rhuUParGnSZxzXCjU59/2UQdiqUZgl1dFVpFDhVFskymh8DAllwGS0G8T62gRaYopy
	 Ckj3bT27fkiN1L3gzL4soSU44vj/8bMchO1CsI/k=
Message-ID: <4459b993-84e5-45b8-9cf1-154457facb22@arm.com>
Date: Mon, 19 Oct 2026 10:32:36 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/8] selftests/mm: check that MADV_COLD and MADV_PAGEOUT
 reject hugetlb
To: "Gregory Price (Meta)" <gourry@gourry.net>,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com,
 akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, shuah@kernel.org
References: <20261014175756.2035176-1-gourry@gourry.net>
 <20261014175756.2035176-5-gourry@gourry.net>
From: Sarthak Sharma <sarthak.sharma@arm.com>
Content-Language: en-US
In-Reply-To: <20261014175756.2035176-5-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2F6641A0006
X-Stat-Signature: dh3tunis7jdcwtai1398cpatbxqgixoi
X-Rspam-User: 
X-HE-Tag: 1792386165-631325
X-HE-Meta: U2FsdGVkX1+hVYxOQ6zVwp56XbaniJ3w9GcsXcmBjBVVws4J910g5ims2VgNnsnzJBPr9ldcaq/UmOwaMJAuEVk61TX0cOYzBWJjUedtnbsBRO/jQ1GMyX2MB1KvHkv4MfvDOavMoZZ59E9Nm0qeRMGXtVah3l9o9Pnq8H3z58WGVnrKxy8ZvlAD7XE2iBQTAKtSL+mmppoAR475cN8LL4ooJh9wfwBiGh+ZS2qPdMlKJnkjdlr98MFXxAVAYZE1h4ZpGCU9OiuD9lRXOd7qBMa4n0WIve5TYyTMHu3w8g3YtcV3T63N8uTdI4JJ54m5CLg2vqQMu6GqKlM1TFzOwnzg6NV7c2LFEUMVdz10UbRIKqeeS5FDFYI4jNTnbInoB7hhiSXc5fOiS1dXf8tHhRJcY65kjW6wuDtgrpSAMD8Np5hQZt7OfQQu4pxWZajxGYaw1YEti+JYTmcoTqMaSrA/p07gQBz1ap1coSwPWKPIKyiMXg2DGbK/eL3uvENrioOw8N0PbACiL4FZNAgpoWXy/PM4/n378d+kySl7cAor5BUmJe/LjENiIbTvvQXoqG5ijcxESAGVB1AfzYS5JE8BP7Jk1p178kmqSRg4j5Mq/JEz+qnF9Mi7FwuTe2VXqsiFLdFYooQP99AcShWsCdsKkb2f3RboOaz9SsrN2Uonzby/O72JZBch/84GVQ1QAaUzzAqcIYaSkudLeAGUbKibisqOulEBzmo+y7X9YVGG1AyZi/g4tSpoND/j9VcF1BTaG4LO892eFDbRzN107xpLEj24xo2UGrrywCAKxmeIO7hARROg/NfChiIWK8kGARHUt1IS+rLz0+M5BMRoU5SErh4UU8tjGsUGsH/h50VtCse+UZydj9d4cFTFDC/BA6RwxPkwghzkZXT5UB71/XQi3wGODbN4+BfisPUKABKzOfZDfMMZv4MBoJzK5AdudE3Hb/0VR8sczKb6kLI
 jzrSUNy3
 nmWflXgAAChKU2zyBfk7jZQWvR+4L7rPpgmbBa07wrFCVS6K3S75yCK3TPb6eFmr5KUDu2h7V+gok15mrqpj7C0R2HfGf0xAlFDyxvARFrduST+j7ags74i97FBLWNY5NcXWoeHH8aeuIZnuL1XBPoWNMjBZVcVj2UIlachVe6QpSkhVgW2EomYeieBbzUGdUIGU9Cu6I0xoE3om84FEdYlDQkQetwGyzLelR4zi1g1I38jT33GisqUl5iuOTmubh0X2Cu/EG3xuuZobQqU6bdoxKjcQJfD942P60jGp+k7Cg4+aMlanwto+0WO+hpFlJ8/3vd2u/TACWh4SXTqvIFy8R6AjOvmGsu+90y02GbftMcCk/fm8zhvuWBM6BpNaZXt2mqnZTc3WborxN09sMWoEM1PyLWcX+OiaQVOx0fhaD5Y0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/14/26 11:27 PM, Gregory Price (Meta) wrote:
> Neither hint may be applied to hugetlb memory, so madvise(2) must fail
> with EINVAL for a hugetlb VMA. Locked VMAs are already checked here and
> PFNMAP VMAs by the pfnmap test.
> 
> Check the hugetlb case for both hints.
> 
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> ---
>  tools/testing/selftests/mm/madvise.c | 23 +++++++++++++++++++++++
>  1 file changed, 23 insertions(+)
Looks good to me.

Reviewed-by: Sarthak Sharma <sarthak.sharma@arm.com>

