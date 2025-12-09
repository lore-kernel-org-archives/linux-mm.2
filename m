Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD327D3B7F8
	for <linux-mm@archiver.kernel.org>; Tue,  9 Dec 2025 16:34:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA9E86B0006; Tue,  9 Dec 2025 11:34:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5AE56B0007; Tue,  9 Dec 2025 11:34:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B70AC6B0008; Tue,  9 Dec 2025 11:34:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A47CA6B0006
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 11:34:08 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1E8C0140203
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 16:34:08 +0000 (UTC)
X-FDA: 84200479776.06.3770F18
Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [80.241.56.152])
	by imf09.hostedemail.com (Postfix) with ESMTP id 25E3814000F
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 16:34:05 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=AAPu8M59;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com;
	spf=pass (imf09.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.152 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765298046; a=rsa-sha256;
	cv=none;
	b=VerkaWcQefStfDWpW4BJx6mzrOTUUHXg7WG9GHQLfjdxY29FMohZ6q8hs8tgkvZ3u7pFbo
	f7CDCYMzwl/t6ToM69YWr2Svr65Xz/xsOAUoia6tabX7pQdPM5IWAeQpNRpsGCsUyX3mxb
	oMbnrZbns+Mko/90E1FyLHm4/mrlwhM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=AAPu8M59;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com;
	spf=pass (imf09.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.152 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765298046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n9/LnpcEgxl44nJ3KI8H+Y8yvy+C1IYBZbso1/35huI=;
	b=N7nthAi6R1Y/T7Jt6igApLJfv0whainkpLFRSmlNmsUS0AV+5C8iQUuyx5aLRljueZZhpm
	nZ/phO20vFRBnYuiu1KRgtnTvpKoq7bz/jRTymT0vjUHdrh69iPNZoIO3fyeWOiR3f8dAH
	MOKeSB4m8wdGuDyW+Q6Va6u0GoaXAzY=
Received: from smtp102.mailbox.org (smtp102.mailbox.org [10.196.197.102])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4dQkvF0Gq5z9v7T;
	Tue,  9 Dec 2025 17:34:01 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
	s=MBO0001; t=1765298041;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=n9/LnpcEgxl44nJ3KI8H+Y8yvy+C1IYBZbso1/35huI=;
	b=AAPu8M59AtZ4i6+FO0b3qagpHrfFsulku/cwvAn+/eSMjQD9lEjCmjVP0ZwsyAvh5TxAel
	OrE/Q5+4ckViAx+k8+FPTR+69Gn07nw23AsosKdJTsHAe6C5wjxxKsZMYBJK0wYgsYELo6
	YH7GbEf5dM5hxjhuLan7f1LRkyDUw+xqFRbvGULoaP1ShD27mTODqaixkSkhFGNh/PD+ff
	0d4S6kYPNnsOp+MmDG4W3DWOKbh8Tchg/Q+zWnaWeWyrt8oDQxxGuYK/0Dfw7yymoIwPE+
	BCZIeMkybZ90iPP6Nzlz3S+Nggi2NmInHCHs2MGB7oY81+/odna/5brbrbBi8w==
Message-ID: <3ced3736-81e8-4bc3-b5a3-50ac4af3536c@pankajraghav.com>
Date: Tue, 9 Dec 2025 22:03:40 +0530
MIME-Version: 1.0
Subject: Re: [RFC v2 1/3] filemap: set max order to be min order if THP is
 disabled
To: Hannes Reinecke <hare@suse.de>, Pankaj Raghav <p.raghav@samsung.com>,
 Suren Baghdasaryan <surenb@google.com>, Mike Rapoport <rppt@kernel.org>,
 David Hildenbrand <david@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Michal Hocko <mhocko@suse.com>, Lance Yang <lance.yang@linux.dev>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Nico Pache <npache@redhat.com>, Zi Yan <ziy@nvidia.com>,
 Vlastimil Babka <vbabka@suse.cz>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 mcgrof@kernel.org, gost.dev@samsung.com, tytso@mit.edu
References: <20251206030858.1418814-1-p.raghav@samsung.com>
 <20251206030858.1418814-2-p.raghav@samsung.com>
 <d395cf62-2066-4965-87e6-823a7bbde775@suse.de>
Content-Language: en-US
From: Pankaj Raghav <kernel@pankajraghav.com>
In-Reply-To: <d395cf62-2066-4965-87e6-823a7bbde775@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 25E3814000F
X-Rspamd-Server: rspam10
X-Stat-Signature: 37q6e7aatccr3634aj99mowxat7uxjfx
X-HE-Tag: 1765298045-501433
X-HE-Meta: U2FsdGVkX19GddogPqB397CYWADHd5rQTMBCqasl+YuvLexR7UV6mkF29aBPLgUtYevA6f/ow8jdYUs50kangwf7WG0HmxWRRH/lT56fuZwMNSPLsVbzumGNFZdtsfWtYg7TmbbsCTuEEMKTvRnglXjdMMnUTJwoqaiLUEPth/BzudDdlGDiqJRbVUEs6srOsBnAIGi+GcPfa3cThgt/zSnTBsqasOG6xqfGuuYrdPAoj7mJACvws0MG31dtSnk6baZPjdnMEvKBwWnm4Kdn/XnV+IfD/0jjcdUy752EtLipF1L6dPCQGzEPlBTkGRjj9U3GotqjhnoF/wyOoxOSoYRPw0PIx9GpNz0jwbpVY18eXy8nRODeq4b7zgsDeyiIll7Jn0bJevAEupbG5I2wQZE/Pt/8RAexwhQCXrD7ktNFYX6p4qVw/ezj8VorTVEiKF4hnNPDB8fgR37Y6A/kdmS5HQEYZB7O7p9YAn1WrQtf83f69Do89Ip2dcWFdv0ExdVJTQjbhNdis5IUdLl+kA1JbB7jzMPGD2U23nZpqjZCSOc5M7pYTlzHloqR+nQe8lQfsDLiU+1fSK1lCdFdt3VADwCSXv6bAUHivhaaH4mhv29AeSkMb4Jj9MNe3RP3imi2fbZcKd9Whdtn4eM1IRWwMmhvb+Ic8zuwGWcVjrsApPlogzSi2uGLGRkIULczy7ZdmZ0AEbqCu+V/Czw+JeyPdZ+I+9MeBrb5HSS3Y8nL0U/K0ASOkxIJG1EQ0wuBFYUkulK4fkYIXZ65Kdt/rLwl1kxDv80HnbSvgDZgW8djzzgbzyhE63EnnVyq877Pn0sEpFfwlOi9h4M34eBQYAiSnhGsMhYWkacmS/sXbTFVXe1H4qhgcZvAUs6/YgTSQZntDJ0B3C4oo0dEpdZF/5GqFibdHpe6UxdVwA4C7l1J11xNkr2sjF1PB0pi0RWCXX1SRTGb0TIBYZ3SKe+
 EkTOJT8V
 xx+UnAns94WKb6md68pTqPDNiYmcpZ6Vw7YA6nS89PquXZEdPE5atgDuR0xXImDXcFNSWNds35gpLjZYVJkO1jsdW/3F7sTcovgxyHEUODk7yp/vdTNEuvCnf9MJBGYUgyuwyhs4LTIxJdSA1glpZDbJLIx5vvyxoyS9OavnlPJupWP7ttgZyW1JiGpM4v3Gj+6ywSMKYc+YvmstNj0O3xzu39IJRB6vPRl13TbtzhxzHUCRXga5r0dug/d3dBhwoXGB7CdSeb2hz2nw6y+u7Z7W+GaR9nc58AUhxV5pKiFQsm8GBNB4otSyUp075jhLQlvAdmQ0lsVFvf4Z+0pTNSNKwKavpigHeS94vciIIQmMW1Ji5N0sSiCnQPZoTujcbXSBMTZ+WDbTjb22T4dA5KsHnfA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/9/25 13:15, Hannes Reinecke wrote:
> On 12/6/25 04:08, Pankaj Raghav wrote:
>> Large folios in the page cache depend on the splitting infrastructure from
>> THP. To remove the dependency between large folios and
>> CONFIG_TRANSPARENT_HUGEPAGE, set the min order == max order if THP is
>> disabled. This will make sure the splitting code will not be required
>> when THP is disabled, therefore, removing the dependency between large
>> folios and THP.
>>
> The description is actually misleading.
> It's not that you remove the dependency from THP for large folios
> _in general_ (the CONFIG_THP is retained in this patch).
> Rather you remove the dependency for large folios _for the block layer_.
> And that should be make explicit in the description, otherwise the
> description and the patch doesn't match.
> 

Hmm, that is not what I am doing. This has nothing to do with the block layer directly.
I mentioned this in the cover letter but I can reiterate it again.

Large folios depended on THP infrastructure when it was introduced. When we added added LBS support
to the block layer, we introduced an indirect dependency on CONFIG_THP. When we disabled config_THP
and had a block device logical block size > page size, we ran into a panic.

That was fixed here[1].

If this patch is upstreamed, then we can disable THP but still have a LBS drive attached without any
issues.

Baolin added another CONFIG_THP block in ext4 [2]. With this support, we don't need to sprinkle THP
where file backed large folios are used.

Happy to discuss this in LPC (if you are attending)!


[1] https://lore.kernel.org/all/20250704092134.289491-1-p.raghav@samsung.com/
[2] https://lwn.net/ml/all/20251121090654.631996-25-libaokun@huaweicloud.com/


--
Pankaj

