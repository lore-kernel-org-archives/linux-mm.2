Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3995D68BD5
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 03:00:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCA8B6B0088; Sun, 21 Dec 2025 22:00:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D78B56B0089; Sun, 21 Dec 2025 22:00:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7AF46B008A; Sun, 21 Dec 2025 22:00:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B601A6B0088
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 22:00:52 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 817DC1409BA
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 03:00:52 +0000 (UTC)
X-FDA: 84245604744.30.E6D0730
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf03.hostedemail.com (Postfix) with ESMTP id B2BF62000A
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 03:00:50 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vxbPEKyu;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766372450; a=rsa-sha256;
	cv=none;
	b=qtEhG/k2DEV4iJzq2rvGxxSXEZxEo5P7S3ibqFxVuex3XbpCLTuWiloLrS8u9dLh4JhkE1
	Je8mFd0SMS7b0bnpnsjNAAbybUjWjX0i5dwEQYVKqv+VymcWI5MsCyFLkJpQl2r/11MvJi
	21BA7g1XOkY7rVwSvlytE9mNhs4EzJI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vxbPEKyu;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766372450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YSeHczoqP12Y8AVomaqptrBKs4j+Qk5o6drkuI0H/pg=;
	b=dBaiUJkKlNT+oZeQJgNLDQRmNCxStY+U17qbiwxvOhkNVFUV8r+RfGxV3UDCkSEoTaKepW
	+K++cGO98ACHHdjyxjiH+0O+Bb9x1HR7PEx12BrwTdYDKPBNbLlQmy07n0VnkK+BAEx+Mk
	kqccRA59rttN0ibiVLO3nnw8zmbFLts=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766372444;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YSeHczoqP12Y8AVomaqptrBKs4j+Qk5o6drkuI0H/pg=;
	b=vxbPEKyuOY5d8vxLynCKQE55Fcn0Urid3Ha7WmyBAGR/dOPhxVv+AMF4ezxsZMOmalwc44
	/n6ZUGcVuW7St/bI9SobajzvxsZJzqyJ6TriQHiDuVDb/FUilFDCoxsI29GAG8R1EbT4+d
	CKLliPY55UW8YFdhTdeqBVlHHqeCiQc=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.200.81.1.6\))
Subject: Re: [PATCHv2 04/14] mm: Rename the 'compound_head' field in the
 'struct page' to 'compound_info'
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20251218150949.721480-5-kas@kernel.org>
Date: Mon, 22 Dec 2025 11:00:00 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Matthew Wilcox <willy@infradead.org>,
 Usama Arif <usamaarif642@gmail.com>,
 Frank van der Linden <fvdl@google.com>,
 Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>,
 Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Jonathan Corbet <corbet@lwn.net>,
 kernel-team@meta.com,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <98BDC08B-9A77-44BE-8BBD-FF9F8E4A6DF4@linux.dev>
References: <20251218150949.721480-1-kas@kernel.org>
 <20251218150949.721480-5-kas@kernel.org>
To: Kiryl Shutsemau <kas@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B2BF62000A
X-Stat-Signature: 1y1kqss48znsed6okpcsn8qzgwwo193r
X-Rspam-User: 
X-HE-Tag: 1766372450-761738
X-HE-Meta: U2FsdGVkX1+MtjQKb/Bn91utMiU3DWt+9EHh8NfRtNGkJ8JnL7tMaQhO4EaBj11BUxY6zA6moa9GRM2pZ+ZiWMhJ5feCPPlQiyQTBCWdoh/BO7fEO5mhH79O1uZed1uzfaHzMHcdoxTJqVxrlwic6DCjwcJdtpuL3DiELW+e9f5JRX45RI1+uOzKtgZeOA84wjnUjjqLGiauvALLW+X3L2/2gZ+9/MQpdWnCs4w988U8s8PkbxREqQ4zv5ho0xTMdT8Og1b0QlhBtoGpC6+QOuLSuLAeMCtfmu3i18jv/9q7/0SF8LTPKhHCqIzJf+HYcWQumYGXbgJFS5bMvLKl/pUJa4TADML3wwl14zhzCxvOcjMXMcPu+XKNv0sX2Rzn2a18yJSS9NXhnW95k1+/vWyhBDmiBrK/BTJKaAMMsnLB0wIhexIHQ+UbauZc3aScF99+mJonEOaqNiYmJPYZwtcaXuHnyc20W7KVDWDzg5nCkYdTawk4CFzXt09uUyt9xeExILdekChPB++IrU3jVLsl0fksyIqf2aD2pYkoKdIc1uQvfm5OCVXkr87uBlvVWFJY1aWfNbleV5DkzyYRVzM+hYZo9cta7IY+L8LTaAMuTvWUytg66kq//BV1cTo4pkg1QVBGXrLAYT54f2ecRUorbmoyLCvlTs6CVQC6Jjs97EF7yB+Ym0twD1etPmsZ4VCQUQoj0lhAX/l6CEJ/UgM7YCuHGx7t85266/puOtnfbpT0DAQF66Irhf3ZAcNvhfilMh44X7UBnsqGVdwC+wtRJHVk0Ov9ZXyO13G3BbCWAmYdqUGmMDGZzUgyIhPu04X8fuGCiARXs7QeWpWXAHFKHCtPwEZ7VBj/RtiTWX97ggkBNG+lBqePt0kSqZX89MWIAG21xvVJj41vbcrwflB3rXbx2q/IGcW7U5HmxihPdcptt7E/v9saIUTPIkShc38CfbAULbMV7436X6O
 bRhn9+fV
 DuBLauqe4sua0a/B7dFw2ThA5/dGgbSBuC9fPlrGB48ToACH+TiIDIccrK0ctffZSAkYbQ/qtd9I+nqmll/lF/LLXt3LIE5RLvO3najDnENED1LQ1FVUfgjvzKXKQrqQoExIsllEXQ1FE8pG7sxRAM+AbiYIyay3DIlZlMhWCrOMUxmE+RLoOSFQg4LAUd6UTN1pShIbJD97HY8dqb5I1pgr6u9t2oDdRaXcCL5gD7JOQ04mB3VGyOPVR8Nw5MjhPcU5ugqICpGhwCjZXA2VA20DdCuJzra9mZfmMsyjrLRrW0NoU0UH5ZepzKA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Dec 18, 2025, at 23:09, Kiryl Shutsemau <kas@kernel.org> wrote:
> 
> The 'compound_head' field in the 'struct page' encodes whether the page
> is a tail and where to locate the head page. Bit 0 is set if the page is
> a tail, and the remaining bits in the field point to the head page.
> 
> As preparation for changing how the field encodes information about the
> head page, rename the field to 'compound_info'.
> 
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>

Reviewed-by: Muchun Song <muchun.song@linux.dev>

Thanks.


