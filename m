Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43CA4FA0C39
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 06:44:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFF236B0093; Wed, 15 Apr 2026 02:44:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD7016B0098; Wed, 15 Apr 2026 02:44:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A15106B0099; Wed, 15 Apr 2026 02:44:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8C5516B0093
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 02:44:52 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 54B018B579
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 06:44:52 +0000 (UTC)
X-FDA: 84659852424.05.164B4F4
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	by imf20.hostedemail.com (Postfix) with ESMTP id 37CBA1C000C
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 06:44:48 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=N422xTeH;
	spf=pass (imf20.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776235490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5mOipye9evHPcrGtSUD74q7SjHPzzHhjUmf7hrymf/c=;
	b=UeCmw+eLOiCD33Ip9T4tUL2oWUpQB0UJ0UMvu1xHKIF0VQnQLX1vMvhxSVpydcfUcQlG8M
	43InvuUDLgGgsA8EYpzqfKlmfDl3BLbD8mmANGFN9TxFnuRlKGTuh9WH6pPZE5bQ/AaHSF
	84MMeuEX19j2iJKsf++z+d5zHYh8IYM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=N422xTeH;
	spf=pass (imf20.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776235490; a=rsa-sha256;
	cv=none;
	b=R14gm64qL9wsxwqBkGj+Up5Xyr3xsp4JRAjpEfZeozPxMY/X7W5zNtly6IUtWQGnbl2uMZ
	kF73U2IZUR3h98KKMXivDuKB8+7hcUVr547M/kKVAZE8sdxFiapsIuuoycyZXF6ToVAOuU
	wbVk8Fun7dOEEzgT7FuR6NJfpkeuMic=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1776235484; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=5mOipye9evHPcrGtSUD74q7SjHPzzHhjUmf7hrymf/c=;
	b=N422xTeHYal6S3PCIk34PhYJBvo1kGd5rstSkScnG1jqv7a0djt7aMtitQ+RcUBRiSJbjlHsShAZmp2MqGdNZUXX7Nr9gKxTBR4hxOUoN5wun4NHnOt0D9AI9nZZYWmNwSSuzDhWtddpDI8RD9gl12v5tTcjpsl1MMSPr7LLh/g=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R411e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=27;SR=0;TI=SMTPD_---0X13mSFc_1776235482;
Received: from 30.74.144.121(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X13mSFc_1776235482 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 15 Apr 2026 14:44:43 +0800
Message-ID: <3fb827a2-cdf4-4b2f-b501-737ba7140c8d@linux.alibaba.com>
Date: Wed, 15 Apr 2026 14:44:41 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 v2 07/12] fs: remove nr_thps from struct address_space
To: Zi Yan <ziy@nvidia.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
References: <20260413192030.3275825-1-ziy@nvidia.com>
 <20260413192030.3275825-8-ziy@nvidia.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260413192030.3275825-8-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 37CBA1C000C
X-Stat-Signature: hmcpijkf4i1jzkcieixpntnx97i337it
X-Rspamd-Server: rspam06
X-HE-Tag: 1776235488-877267
X-HE-Meta: U2FsdGVkX1/vRNs5brdWR4luJo2Asr2ShXhrygb7gKtgmjRQVpTZ/6bD8qspAfEkN3CxxHVRC3FwBOby4CLDBIZheoi4+V4gsrgsSCjiiemoxSCigI57YxXMsOE3mXo92QmVQnQaECL5vyaJ59FmX9pn19+W26vVsTa7mGkR2bwcT0GY7STjd8OCNp+CWWzJ64npI0X5ypGAfWmD2mHd2P7FOjNkxxFIjPRpXTsvuLSEOOkplAerkAxfdUlbIt9MByB8IkQC8y2t8BwtVwL7i7qnJe/y+bLOoY4QXKHMW5Di/i/Uni2Ih5/SGgE1eVvno0llwb3oWByXMZLnWoFp7ZEEKTOSaFLmLK8+/wQvhsEmfrm4GEjDwv6mHresUgiBNpSTewHaNRdh8IL2fpMWYUpFb4JoA4vbZ5U1c7FE0q52VL+V+CuvZhE1Ns/JThp2xMf0YBvWNLCIiGeqNIOvps1tnzgEN8/fdUVU8FwCNfe47OARFIWXNiFIhFjaLutmU7aJIrfRueiow+7N+aQwwqURUJD2lTsOx9FEkkyzqyj+cmSuK6myeidD6ytDat1/q2lUUOGguEUxIpXMy313Rj6yJG3NPMuuIF4eB1WSlpL+xmVnxSANBiFU01lphS0zpkWPU7njN5KyjtmyYEg4P+g6sSfPhDlySziU9SwQycElIyFEL+jSCU/T8bjxdsjWbxvd/krhsFHMKFIHlT9Xk3GQtJToEuFUDuuPLZ4Zkn0p0csXjhPocGq5nIXFbbrSNSB2pe7EFAAWsLNOz2+RsZsP1/xpdfyebgqskLddeLornJw6bjnLRu4UTdP1BVuwjQ9wJFQUliceIzseimkSys35Wk0ZT7rWAy9IvwfXdgIxJxcAg5dwwqjvkpAEB3UR9+3fbxSXlcKnGHc3pP0YEnol9Nm2Oca9uRdHatHYp3Y6Uu71McV5JQ1XLGp/hjs8AgF1eHVCDmFHT4UAJcs
 dTYRVJuL
 xfBGp/d5M2KtxlfWPhM2aKI0RRtjq4Toymr5ykWuMh2tYnNtqweejCluSHyYnpmz180RKwr9OeCcsfIlQsuzZvy+B5SMWdBiiKu6m75ie0gGOJanwp6Hiwyx3YRZRIWIdp+YnPWPir3E71Y6+XAICiDtRvNsU0nxo/kASVu01Mv2q+mFt4e1v32SwDtoSpQ0Oe+i1vI30Jp6bUEyrQIJ/3DqUf4xdJdKIyf67Z2F4kleMLJrRiYvOMN2WweYrAPipll3lHCFuAmyQd21sn8/0aNQtFvdweH1u1mykQ1hCcUrxpo3bz+2dfVePrsKQ5ghDrEAMNNSB28VwG9Agq9giVXF7dlynl3mKQR8hJtJx833+j7s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/14/26 3:20 AM, Zi Yan wrote:
> filemap_nr_thps*() are removed, the related field, address_space->nr_thps,
> is no longer needed. Remove it.
> 
> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

