Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21FB0CCD185
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 02:08:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18E828E003F; Mon, 13 Oct 2025 22:08:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1660F8E0007; Mon, 13 Oct 2025 22:08:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CA318E003F; Mon, 13 Oct 2025 22:08:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F01308E0007
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 22:08:00 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7B1D75A556
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 02:08:00 +0000 (UTC)
X-FDA: 83995084320.30.2BAC4F4
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	by imf20.hostedemail.com (Postfix) with ESMTP id 66A9E1C000A
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 02:07:57 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=F0upFS+S;
	spf=pass (imf20.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760407678;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l1e4yHys0usVOjKdbyGgqRdrFgCWnc4S7nXC1/DNEPU=;
	b=cLMsSrCGUjC7/rprXad7A6mfJ6t/gu2lNY4pdCFQOtDlfaAsjo0nmiSkdDkHXgxBN4Xq2p
	YEjqhIgqbi1eHZrCs0MI7njWtQBV3MGU0Es6FC3PcHUQrAEk5PDUy9iJnP56rmZeBSxmxK
	e+3l3HEb4fnMoMeQBO6R6Bwm2r3sxDA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=F0upFS+S;
	spf=pass (imf20.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760407678; a=rsa-sha256;
	cv=none;
	b=ckPK/7K+EdUiLGHfcz4Uozxk9Szg90jWElo1Hr+FPkh8tsYJdjQH8IkyH0y9K9sP8TsYyn
	9r/Sv+oUTOeRq0YY0Sa5MUsPHjL7sRbOE3JA/ccUXBalLwOODA3AeBauKFVNZlIc5bqggU
	3DCB7Ocxol62T1F8jBayA0pv7AAKL2E=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1760407672; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=l1e4yHys0usVOjKdbyGgqRdrFgCWnc4S7nXC1/DNEPU=;
	b=F0upFS+StbNwxG+GlOwPmcbENmmVfrn1BEed1pH/fiDFtHORmLA8AZ7DNMzB3PlKsojzs2nIRphLRVPH9/q0z4bq72+GLY0gLrTiJjZ5NXNQvWBAnqZeVsKZamlVOt5Wl/HMRxZ1qz6QcrLYnDe190yN6j0Zh2SEjy09Zqs8v1g=
Received: from 30.74.144.134(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WqA-OlU_1760407671 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 14 Oct 2025 10:07:51 +0800
Message-ID: <125ee0cc-fb37-4c7c-8d2d-ac37bdd0317b@linux.alibaba.com>
Date: Tue, 14 Oct 2025 10:07:50 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] mm: Consistently use current->mm in
 mm_get_unmapped_area()
To: Ryan Roberts <ryan.roberts@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20251003155306.2147572-1-ryan.roberts@arm.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20251003155306.2147572-1-ryan.roberts@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 66A9E1C000A
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: pc87i8tiecsmqnzcwpta1ztupn18ftke
X-HE-Tag: 1760407677-847836
X-HE-Meta: U2FsdGVkX187Ki2FRaQy5YnG97V9FKyj0G9CBXhak+O9yqzZFdceqB2XnFOqXZos19q2OxYooT0TpcH1YMIKuaqurRWtl/MI+AN8ERUMhqx90zcXIGpl0Nwtgw1FFRymeoj3BSNxXJP27WnoDS3kWxiwVs1kfz/Vy79/d2rGG/jPRJ+F+80GOyNXTQCJk1yMa2KOnLJ1yE6WYihM/JgawmdSKzmE2i4aerF/ID9OMFqiTf1bs7wTaDmkPvo8YcJ3jQ/wPZkZ+QGw/pP7FoKtr1PNeHAj/DvyY8SJLrzKeoQ3kD/Xz+kGU1lXhQkvPTbNL7RGvs8OTIt8hILeeBWfwcI4KHTCcNbDDLQWlzON7NZH+6cBTNVVWeLV0hS4GDg8WJo8CtKyE/QVVM/Eb9T7su/ZmFe5Iv2FqoJIuW66Kf/5Ox0tcG9dH9XXsBWn8c0g/F7g+WbO4jbM3oM9y39K68/HneOZdXirmRNkQ4l6ulQaVbZ6QGcp4lxr2BlAm9m4Wj1pTcZAO+cbGVegp3uckPHVFqsbKjbBVEJjJpmtEIpnRvPTVMsNyvRrMcOMlyXn6JcU5PqIhN06LvyVnIHprGMoftDwYdoiupg1TFcAV/i+kujhoypQWLO+YDSa1BX7eQGMyOh3K90Dyu8QeGeOxHZOPXbogPDl8kOD4tMoNj+OUOHXPLYb2f/5z24mmDlrx3rbA+zB4ndkSDQEFwzUM7SQ/mhu7WHUiqtufxj+G7xZbvLRrQS9hIN5tj3PlSV/j8DISOCDVwvSxFHNfp6WC+asQzgDfTsPLig7qSjT3SXHQLtpfe3zlv4+IYFfvZk0FEisdOQKQ/tKfiy8K7q/w7U5H9dJXow9Vzpo/XV/8A3izwltTMJ7kbl7pXEAsiMVyiU/bAL8O7AlCMwGfp+lP6UFUsgdsqjcHSkNh6AWtxPOih6T8awFTo4bb9npkSyrIbrYv0liA73KDyUB8YL
 ncqqpkO5
 /CpKuJGzsnycuQSsGv0u9OEnZJN/96j04Kgvu5dkXzJWFgfLvwTPxu4sVhmMMb/buIzZmFIUlW9FZlLTQLWOZAc9xVczyk90wovk+O4cEjEGw5XPpCJ9OMpHacr/pM0VR6SNxSZNzi8L6kcJtvAn0b6uDSq+0oA7ToaQCN1vj6/7QWNWoc9PSreBvncpwX5p0vvHa0e72pMI4U4Vglj26SZPA15ketS7ggOIMiBb/efifv2+CUyX39cvRBkLpTbI3OPLGIwtGLAAP6U54vNQAlK3EyIZY7Y3TU73VeKuTDMN7Oibag6fC/3xOO9IsFv24nUUFfSlwWX9uYQHBn+eQHXlQmLRiR8GErSoy+ZZhrULxkUXM9Z4rBBS4+5Qdoub4al4CHa4w6aJ3937Bawelgyji3rlSoJEqD40r47TQxB58hyhXzK1s896u4g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/3 23:53, Ryan Roberts wrote:
> mm_get_unmapped_area() is a wrapper around arch_get_unmapped_area() /
> arch_get_unmapped_area_topdown(), both of which search current->mm for
> some free space. Neither take an mm_struct - they implicitly operate on
> current->mm.
> 
> But the wrapper takes an mm_struct and uses it to decide whether to
> search bottom up or top down. All callers pass in current->mm for this,
> so everything is working consistently. But it feels like an accident
> waiting to happen; eventually someone will call that function with a
> different mm, expecting to find free space in it, but what gets returned
> is free space in the current mm.
> 
> So let's simplify by removing the parameter and have the wrapper use
> current->mm to decide which end to start at. Now everything is
> consistent and self-documenting.
> 
> Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
> ---

Nice cleanup. LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

