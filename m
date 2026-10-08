Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A12CCA600B
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 07:31:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 419EC6B0099; Thu,  8 Oct 2026 03:31:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CB2C6B009B; Thu,  8 Oct 2026 03:31:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BA6F6B009D; Thu,  8 Oct 2026 03:31:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0986F6B0099
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 03:31:17 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 92677A79D5
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 07:31:16 +0000 (UTC)
X-FDA: 85298638152.07.2AC79C4
Received: from mta1.migadu.com (out-29.mta1.migadu.com [95.215.58.29])
	by imf02.hostedemail.com (Postfix) with ESMTP id 77C2C80005
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 07:31:14 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ezwG4nhP;
	spf=pass (imf02.hostedemail.com: domain of zenghui.yu@linux.dev designates 95.215.58.29 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791444674;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w5JY2b/LqTJLxFtNLoW9b7HKljP8catE0jGTQduKh9I=;
	b=773UD5rSkzYwyECUs+dojQW6JzItU/UC0e9JqRwOdHI/zuIjNx8LG9MgMFHXmGiqXMM3D7
	9AJnq8oDRMHUIc7+p+GOEe7kKbvw5buYjFDk7K1SnEcECWZpvFSPf+vs6UB6lPs69hmzoz
	mpJK35bR2X8Q//pZYam4hT6u7oIoz0Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791444674;
	b=iAwpai8gPRfZU14vnpZ/IDVi2kH+vHiB8+ISMR9oddn0Hg7/bSVfKFCyBx4Nn2HhDw3/Tk
	KMoeZBOmz5YcisX6lPcb+EkKuS3ybiOKRLFoY2ucL/h2ZHrMAqb49dntwDuxZEv+EsYZad
	b6UfPdbAY7v0ZptKu0QuXzhWYzZyauk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ezwG4nhP;
	spf=pass (imf02.hostedemail.com: domain of zenghui.yu@linux.dev designates 95.215.58.29 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=JEx2OLckwemutil/MN151E8aEqCJockn3ZT2A2YL1GI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791444669; v=1; x=1792049469;
 b=ezwG4nhPyNVkBBwhdSClSW+Wyjq0AnX2ZF77S+N7PIiHK1DGKk/nvPNh+GHQX47wWpc+8KV4
 0AQtP/2bb0mil3X3PQbyjqk0+BGTJ0ixggS7qxUHQOpfEXRvrUkpMo0g/t24YO9pEAXq92b2m5j
 B8UMJAs3DtzXLurpE5z6X9ao=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 0f9abccb4081472f;
	Thu, 08 Oct 2026 07:31:07 +0000
X-Mizu-Trace-ID: 0f9abccb4081472f
X-Migadu-Flow: FLOW_OUT
Message-ID: <85b3725a-6dde-4a57-b303-4ae2b53b60a5@linux.dev>
Date: Thu, 8 Oct 2026 15:30:49 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 16/19] selftests/mm: add khugepaged race harness
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "David Hildenbrand (Arm)" <david@kernel.org>,
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Kiryl Shutsemau (Meta)" <kas@kernel.org>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 Muhammad Usama Anjum <usama.anjum@arm.com>, Usama Arif
 <usama.arif@linux.dev>, "Nico Pache (Red Hat)" <nico.pache@linux.dev>,
 Zi Yan <ziy@nvidia.com>, Barry Song <baohua@kernel.org>,
 Dev Jain <dev.jain@arm.com>, Hugh Dickins <hughd@google.com>,
 Lance Yang <lance.yang@linux.dev>, "Liam R. Howlett" <liam@infradead.org>,
 Michal Hocko <mhocko@suse.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Shuah Khan <shuah@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Alexander Gordeev <agordeev@linux.ibm.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Leon Romanovsky <leon@kernel.org>, kernel-team@meta.com
References: <20260919002451.496763-1-kirill@shutemov.name>
 <20260919002451.496763-17-kirill@shutemov.name>
Content-Language: en-US
From: Zenghui Yu <zenghui.yu@linux.dev>
In-Reply-To: <20260919002451.496763-17-kirill@shutemov.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 77C2C80005
X-Stat-Signature: 13maowrtdh4s67i77yubhu5kwjm1ubka
X-HE-Tag: 1791444674-872670
X-HE-Meta: U2FsdGVkX1+btzFxgEV1zUi0Llen4Xj+NraJjyCP5og+VvwefcNC1no0eBj/yLY0+b9syZnS1B+No69l+56VRLoDb1Ie7j/qxSlqBFBlJXrLgI+KkWQ4OmyuOuFuR0uRYViPOqSuJTNXyo02Fh8zeFJlzFFNohnaBcsdAPDmUyo6szpSY/fNuh2IaTQebP2usL9NMXL5i0kNkpSo7Sz71wiAeqMh1zTMuaGzE1fdkyx5wbWsoFFQjQtpICrY+XbcwpxgVjNNi9pMyikfso6yYCG9N0fW6rdnmN1Q3EGRzqphJINtaIwahvwGs+mH38Lzluk1yxO5/Otl87zE15bGrMJo7Y9b8WcLXOPiZHeXCOu1AiXY2Zk44xqq+tBI3ap0b31du4k3bE56krMf0r4C1S6qyjsnRaaF06HcrMtuUcfC7B2JdQdVljSDlzwkdGprbgedJ6XnqoBwqBDRy5kVv2xbDC5laBuPEl9IZMV/yOyVfqPbrdRtZE4gV/nn06V5VGOwHknXcUoiZzw2T0YbSsA68Z01ZH7QWYidxJ3e/GpuwHjD0UfXZ/4z/g+jZALlCVdgAcGuyEnfxPYkYTtCtk4t/eWe/rmMo+PfGfbqz9I5qAi7tsxbz9NYj1eyoGxxU89+BhBjtgSvzjKV+Ms/hFDyW1LL+JYHGtWUSyMeko3yAbxQmQpdJHImVXnu1Rwqv5JZuxE3qsKGUOFmzAp36wa7SneZS95m0oRQOoaSuR6pfVNhZpNB08Ty2b1dTqwKFhHYxXnKRp4nidnd6LdYLvfTxma6SQdqgaNe1btcZHU6f+j4riqOH1Kx2PKMZ2aHPqwVKtbKGEXS2RhPecCotzo4IM+P3LyHIWQ1XqqmUACO26Qjl8esj3y8cLXOSGkkcQtiYbBI1qQHb0i5lr9BGkEaPGT76WrjDohTnGDwPggrMMJ2tgXPahuBthg5e99KzBixENVAGgUCVkyl14K
 a1uyLoqc
 ptg8skeiDNqBWr0tlUcggfi0URC8qWn9uRN7HW7SjsIx4SSkuOsoddnvKXXtuRgMCJCcw/RsNovUNgnGPwlO4GwrgjT4cO/Jwz5UIe3PYVemWqMfZla+BwC1SLeAdJ1+ZY6v1A9cfWsjaWzY7BisaCgJvjOfYXE4GGtuo7xBUUpXEV9NADfAbJHOiz40TflyYGD7pW1GhW+6IFI4Vvx2AXDcUzKzwvbdS3oAfi6aGwSwh5APe0QJDrv5quLVt61E/W2CdyfEW9Nld8NLikjmzSRR3tfZ8l61KoFzhFVAaBlI+uLA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/19/26 8:24 AM, Kiryl Shutsemau wrote:

> +		} else {	/* madvise */
> +			while (now_ms() < end_ms && !corrupted) {
> +				for (i = 0; i < nr_shared_areas; i++) {
> +					madvise(region + i * hpage_pmd_size,
> +						hpage_pmd_size, MADV_COLLAPSE);

I got the following error when compiling it:

khugepaged_race.c: In function ‘main’:
khugepaged_race.c:506:23: error: ‘MADV_COLLAPSE’ undeclared (first use in this function); did you mean ‘MADV_COLD’?
  506 |       hpage_pmd_size, MADV_COLLAPSE);
      |                       ^~~~~~~~~~~~~
      |                       MADV_COLD
khugepaged_race.c:506:23: note: each undeclared identifier is reported only once for each function it appears in
make: *** [../lib.mk:225: /data/code/mm/tools/testing/selftests/mm/khugepaged_race] Error 1

Thanks,
Zenghui

