Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E69BF30955
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 12:44:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC8B36B00A8; Thu,  5 Mar 2026 07:44:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4C256B00AA; Thu,  5 Mar 2026 07:44:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2D906B00AC; Thu,  5 Mar 2026 07:44:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C09B66B00A8
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 07:44:48 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 74E7FB52CB
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 12:44:48 +0000 (UTC)
X-FDA: 84511978656.21.CD6CDB5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 82A4D1A0011
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 12:44:46 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="X0qwN/EC";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772714686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fBrVNr8U7+Q5wJBjA4RUl6ZU0wRV6cfO3qkElX8TTi4=;
	b=8nOOJo4qXcpgU29bSlolUnsFaLunMu6VksqBRfxq23cPiRs5s3lMz6Kvd38JweTWcpht5X
	iFqr6z5sPplRzQpLXBqKrEEEkzeeB0ExcT2cBnb0dynCaJKsGdH8KSCLMh52/adlmEKC3h
	/KxIQGybPK7FPBCxNtuQwZR1Yvu0No0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="X0qwN/EC";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772714686; a=rsa-sha256;
	cv=none;
	b=lYctgp30ffYi41PP9rT18QN2+EF+leoY4IwjGzelNIk6Q9wuEwpjjzqP0cP7KXreafRKjL
	QkJkWgRX8zJvvt7efMMlvEN2BpprgtKRQDaWXk7HkRmrk0SluQB3ez0CnBu4Hntiz2Pzzi
	Cq/pDOk9+0CSZQ0BGhAmXTkx3C9zPhg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 975F9416F4;
	Thu,  5 Mar 2026 12:44:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13A2CC116C6;
	Thu,  5 Mar 2026 12:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772714685;
	bh=LT5WDnF3AEBAwycCjCP/XOjYJhTLyjqHOFCpeuthPJQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=X0qwN/ECeir9rGC0LjCiZyn0JyZf+32HIuxJyiduMwF830I3SgYDqR491uDRXs1pr
	 19cIJiAlcP79I8a80g6p/PB4DIFkancQ/RfXZsKWqtf+pAJrd0/gsDcU8ekXetzaIO
	 W3DexH0mX6hPFYHsNIBrdt1yQDUXcyUT+jFvBIsmYFqGhTffEQhGnxH3uAA1YzsFwv
	 r4255vQ7xPx1Are8JAGSDuW1TN4tRsAf8ZAXl7KkJvDzkEodONf+A8ifswhGbm/GaT
	 +V+e0V+AjILSnqKCKwgkoSmz7f5ckdvJXlZL73e+MQAvout4vsJ/IqcaG2ApgTxqoN
	 UWS/KvwAZ3KPw==
Message-ID: <39bc40d6-197b-4dcd-9d1e-2758aed9495e@kernel.org>
Date: Thu, 5 Mar 2026 13:44:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm: thp: avoid calling start_stop_khugepaged() in
 anon_enabled_store()
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, usamaarif642@gmail.com, kas@kernel.org,
 kernel-team@meta.com
References: <20260304-thp_logs-v1-0-59038218a253@debian.org>
 <20260304-thp_logs-v1-1-59038218a253@debian.org>
 <ec07d7f0-cad4-4d9b-8e40-d4ded8170340@lucifer.local>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ec07d7f0-cad4-4d9b-8e40-d4ded8170340@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 82A4D1A0011
X-Stat-Signature: u9rgd38toco4t5aahjdsfe4ffzrrxtnt
X-Rspam-User: 
X-HE-Tag: 1772714686-335064
X-HE-Meta: U2FsdGVkX19Yn55ck5dcjEU92PwmY5gpT0XOsQ6M55ZRiGHQYDTfNS2AbMh+4sT3Stva/rkWQr8moPmsDog+2IW/ATI7/DmQZkmvM5vth3ZC/oKYFszV7amxVX1+HpDWXYR1tSbqZecSktkJ6z/w87+QqDe0YmuPVLKeKwVLj151c3R/20aSEOTq0nnXV3y0MIPpTb+zDm/PtGZg+MUqi40yOKYsNsMGfNbexvmCcLId7ZPL8NV/5Aw9EEhaKR5/KNOYuJ5sVnrMXilw8JBBRZp+QbyMHIIJ9VTS+2OQoXEdyDQcBP+ZJLmsxXgqLOhRF36xKW8pJdFZKPB1kQNVFluiRWM7Phe4pgX0TjjLmdrsSr35zuqnm0xiZtbh3PIYayQ5TNvrEyI78usxhYiTP4wkIlBiYbJU4wZdGXNCVgIHMuNMJJfWSWOmdC7pI9+mRg1lzJroUB9OKgR7ZM0gtnXySsDOGDCQtjcYWy37qiT2atqqsPNxWY+PM/TwAyOdSk+lZKueomuld0mlu9f6nGM3JadsS3FUqrPzAwDePd+YL/3UM9lwnPqQknrVMkaCVXHTkc+VI0tqqzhGeBL9YVxhKsCsEStbWMXo+m+ySxm8wSETF1vkImRt91byi4UIdVV8HV2c9WIALOXPzj1dIWsBYlmjqE6kxQgTuLZL9IBkq6IH5ZC15Li8+cNwL+C+yhR0gZ6s94PV+1tsIKpte4/iPoH9uHlOrBgJRY/R8whPO9ZhklmEEQ17xM2mHI204v1n4NjdrSraLhc2Cjl8SiPRwYRZGLjHCgkZsvDpxAbxouWkbXejkUpSTShoUR5eLCapWjHNJzenbx/XmO71gUBzCjf2gtVqeXpXnj4KcL34oHW0hSFm1abIOuOSrh1kWTabxBe+1RH6NRTiz7Y1dxfvsqH15AG3JUXMBIqlPySKx7Xg3Kiie1AquUmQ1YXhZV6c75g7riXKXHXXegt
 vhlFaxjF
 zPVibiip6FY3SNldNntr1SFpSkT27q+FFqO9hPhbggzvOjKAW3QWizntWd0Hi/L1uM7gqXxSvVTB1VDY+Lu8STXdkqe0q1saEkVd0c6+8crRsS1f5umJtbpsrbq/DbTw91ifKsvmg5k3LeE+MqrXZW0N/RJEpa8JKV74rRIdbtR50L0Sk/eNVZuKzpPBkf7e3Vj4V4bw3ecCgAeZCwBxSSoSoAqF45RoW/X9MtTeZhT7LUEJxtDAricBkiHdlHu3vlFLsVwyTo4F9kEnOOQwaSDSqt32NAu9WiblsEqnfbMlo3ExVILNLYeJb1A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> This is badly implemented already (sigh) so a little tricky as to how to
> abstract.
> 
> Yes the existing logic duplicated, doesn't mean we have to keep doing so :)
> 
> To put money where my mouth is attached a (totally untested, in line with
> Kiryl's :P) patch to give a sense of how one might achieve this.
> 
> As to this vs. Kiryl's... I mean it might be nice to fix this crap up here to be
> honest.
> 
> Maybe David can have deciding vote ;)
I guess there are plenty of cleanups to be had here. And yes, we can
have multiple ones! :)

-- 
Cheers,

David

