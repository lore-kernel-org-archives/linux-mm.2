Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7DF4C79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 05:54:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBA336B009F; Mon,  7 Sep 2026 01:54:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6B026B00A0; Mon,  7 Sep 2026 01:54:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A816A6B00A1; Mon,  7 Sep 2026 01:54:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 84F996B009F
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 01:54:12 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1AE1BA0636
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 05:54:12 +0000 (UTC)
X-FDA: 85185900744.07.2B56092
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf19.hostedemail.com (Postfix) with ESMTP id 49E251A000A
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 05:54:10 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf19.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788760450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=YOiXyrMga8+K3ZlN3RHUPML4Aeue3RLtK2gek++D0ilZZCaMQBNalQMX3SIwFNtQuehSW3
	pwNja4xcFEDRI3YJIod3ygawe3Y/LjyWza2MN12lFcqG6HOkslBUA7L8gGQ7o/xTMbjTkG
	FTNqPQRmhMSqBw8+SRaahA/X6XzcUfc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788760450;
	b=Wvd0kNaoSkgWv6iXUQJNvmB0k1Ig2PG8DAXcXvV7HOJlhgMsfnV4RZ9njjikLZdMBmgk4p
	AiXKNdr6Nc18mDuOKmpqZD/Rl/lORbKyfrDGHfCYU1aXQlbWrCbi9qpKaUiGm9oEwDaPbF
	QssYOYiTgyH+6DucsZotss/Ra2Ms1fs=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf19.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0C71468D05; Mon,  7 Sep 2026 07:54:05 +0200 (CEST)
Date: Mon, 7 Sep 2026 07:54:04 +0200
From: Christoph Hellwig <hch@lst.de>
To: Salvatore Dipietro <dipiets@amazon.it>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org, abuehaze@amazon.com,
	akpm@linux-foundation.org, alisaidi@amazon.com, blakgeof@amazon.com,
	brauner@kernel.org, dgc@kernel.org, dipietro.salvatore@gmail.com,
	djwong@kernel.org, hannes@cmpxchg.org, jackmanb@google.com,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org, mhocko@suse.com, ritesh.list@gmail.com,
	rvvandan@amazon.com, stable@vger.kernel.org, surenb@google.com,
	vbabka@kernel.org, willy@infradead.org, ziy@nvidia.com,
	Vlastimil Babka <vbabka@suse.cz>,
	David Hildenbrand <david@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Brendan Jackman <brendan.jackman@linux.dev>
Subject: Re: [PATCH v4] mm/page_alloc: avoid direct compaction for costly
 __GFP_NORETRY allocations
Message-ID: <20260907055404.GA31706@lst.de>
References: <20260904115629.3993331-1-dipiets@amazon.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260904115629.3993331-1-dipiets@amazon.it>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 49E251A000A
X-Stat-Signature: qiuso3etrqm3o9wmdd34go9ipj45daj5
X-Rspam-User: 
X-HE-Tag: 1788760450-119433
X-HE-Meta: U2FsdGVkX1+kl2JbFSElVA16hlu/wyNpofZ/27zplpOUxWbHDRu1TZsxDpiQrCGWo9OYyAcXII0MzYP9AvpOh70SWI0nW+UnDWe0FfbhVFIkQqlKNdayfRoatDD2DkU1mrzbhe2P0S53iNHCnodBSORDKOp5nPD2A/tAXinWIgPuUwEVZzPdfsCjOBru7rNUL2KC16TGjSPAuIEWbL61K28evyatxWaCBQi/p5Dcidesz9XnYOXQT7PV2O2E0KdId0fffkyn1p6SKEIwxhWxVi19aJJiwVYXODDnhc0nnHmt8/ck4xkfleJpuA/ar6LXJnfr7HVKbPnc3qZ7IkvAFSLIK2dPQbT1lYb66mUiWAZw2DsxUoSdh2UwdN+9ewwKU9CD989TIzh0AfN/LPtOiY4MTinc9qoo8jhfg2Bgr2658vIw5jbTGpqX4cqiOhaN2OaZ42MjXMKGw9OPoxaeMCu8KLCteJqQ/1UYgFPKtWG3f89hLVshuDMg2zrKRxM5P59idKuZ9ILPso7KkJdAm3tcji8q+vRcslTRyoisknoTlO5LGeGJCw7pBe0Tz3kARN+haC1HvYK7VkEjbsCNnYS5OIN78i/4i9EOaHrUytAmf11D1piZTNOlRTFLTqmB3KMbt8mavNQevMc0lFKF8/TyCKjVhzurpepy27F/uoYta3FtjmrPv37ZKt6WGvJJ06pnTARJ02TK1AOlowi1jfM/XwJe+AXOIxZpk4OShL/WZtpJIAJIP49VMY6KKQlgHXzHILuhbV3PEbCov4QT4akG9TPCVydf4u0vbCjgCS+tNKSN8uanTCiw5yIvu0NH701oFkuqWdS+/1qlZRRL1c2KwmoqLHisjXekclm4MGbV4kSSa3y23na8wM8L+CN8DFoYyaFI1jSLs7VtZKAN96y1f/WCd2ANPRLVOzy2isMDsgxCVbBs0RtLEFQYyqU3SH8qEKLIWF+IJzRvvsD
 U4UQLAQO
 ckVgxGrObmMgOR96in48TlwA/PnWKvgP5fCgxkr67DipqpA4acanaTc3SaSVcOEuJcXQ/LQAv5HL6arQwq0CJ0FziNz4/tv/N9GoMOS723YQ8uaLLdwOX9IP7dNvy4eQ3GaLm5j5msStEXzDtzNq/VkB2fqFdoMBC1Gu7G69jgj0JcfCrWjHxPzY0wVtZKACHdJdwDzwgNYBnp9N0zSnERQY0JRSa1Mofam/1X3hNiuEgwMpt0y7AfLtn7Ds4MCDQhauZ5f1YrC4pchmvf8hrSDb8Fl/dG9h2G7Ppiba83WEraDVnsJrujoLLu1KOJjVYe8Q5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


