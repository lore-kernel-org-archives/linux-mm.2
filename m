Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D53D7FA0C39
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 06:47:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49AA36B0092; Wed, 15 Apr 2026 02:47:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44B7A6B0093; Wed, 15 Apr 2026 02:47:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 387D46B0095; Wed, 15 Apr 2026 02:47:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 27DCD6B0092
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 02:47:29 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id ECE4958754
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 06:47:28 +0000 (UTC)
X-FDA: 84659858976.03.B99F25F
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf10.hostedemail.com (Postfix) with ESMTP id 52864C0010
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 06:47:25 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=CRAwgA+D;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf10.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776235647; a=rsa-sha256;
	cv=none;
	b=sv0kwqxmw+j0oZGYwhJxnGAEx3fWD1KhW/1U25Xnvuk2dIf/JHrj2f91oOhYmF4GvEZfGg
	Kzn0zY1NDzOV02vtpcwJxeLKvquR4u7K4ptPk5VuxRUW3FP4dxSKWASL1BJ87DOOOJiXtQ
	0a73YmYv90wCZ10dDzmG7Cy/9p7oE2A=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=CRAwgA+D;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf10.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776235647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3DQuf7+0kMfpKJ4/36jkKibmxFPSSLW8kPR0wcs9GMs=;
	b=Slz4234Pb4xu9BNVrYK9aW0e74eVsWfT4V5qrqIqlcJVK5xKka4EY8f34oi/isD7ErAGWz
	BNys5Edy4tGUpjCffWecmsZVqnn9XayApz16bc0UrvPnZkrqWwZsT5gChqBNON4VgGJBXq
	rvK0/0Sx7eaT03k/VDiV8i5YYM9Kw5I=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1776235643; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=3DQuf7+0kMfpKJ4/36jkKibmxFPSSLW8kPR0wcs9GMs=;
	b=CRAwgA+D6uo1M7V91aCCKF32+XngwOE9s7FOKM5z/f2zFyl1BM5uKjQ3OwqvQwSoVrJaILhMNuW5T8wUyV5TGf6cpkdq1IFBLV/eGmZYwVK6dghNqFqPC5HOMkC1Xli356xGXavu9TYnL/J0LcWLVV2vQmebh7123EJTOMPBLOY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=27;SR=0;TI=SMTPD_---0X13bM1d_1776235640;
Received: from 30.74.144.121(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X13bM1d_1776235640 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 15 Apr 2026 14:47:21 +0800
Message-ID: <ff491f4d-46b0-4463-9daf-7f89e2d1b638@linux.alibaba.com>
Date: Wed, 15 Apr 2026 14:47:20 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 v2 08/12] mm/huge_memory: remove folio split check for
 READ_ONLY_THP_FOR_FS
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
 <20260413192030.3275825-9-ziy@nvidia.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260413192030.3275825-9-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 52864C0010
X-Stat-Signature: zi3p3o7gykytxxgjc5iy9zu37u438gfs
X-Rspam-User: 
X-HE-Tag: 1776235645-275206
X-HE-Meta: U2FsdGVkX1+r+FCd/hTfUz3PSL9IbxisP1XAOh2ZRcLHCScVy/riqRyl54IaZkE6rUisCn3duQXeWxHtvBtAqxvW2OQYQXMBncuY5qO/j4WgjmgkZv7t4iWeaMOgBHlG6iadeHnPonu7ZIAyf88byf12zpIJikRKrnTXqDJODg9xqKq796iszZZnc/h7ubzu4/tL7ZKgAl1wy754qysTNeRuwt/YwQePPNeSO734ewDQK9RApBeztHyi04BfjY69SYyLV0rBCHXL5B8bXd0Sxpve01rpyrB83lKEgPfJ2cjlVzj9L2hks+CYfxo9ohajX2bH5WvXnER9JDtqpe5/KYwCd4PsMhUl3F33JXe3ExnY8U+HsUlpXLa4U/p82qyrhI/FOpqDAneF9Z8gvUKjxfP+xuAd8noPUvtV7mRJ2vcg5dl3k6QClZTgL2CxoYVhrMI+W2h2D0lH360gSWSFWb/W5ygfacwbGmoLn19+ltNpFCZEX6ldXJUg+Ds0MLIXlgMryuc1Q238yi5HzdUbsh1pD7bJnnW1Eb9YhJ3y6BCBcdAIkA/s+Y/CM6aRuVXiKrR9dI05/eIi65SbMzKaA4uughhCT9rf9Mw3N8d2ItqyD/yPsLmHSntv4Qr3yA6LoapY3QWbgikaGZq9D6a2kfwWsEoTTipbkaa8XYE8JKuceqgpu/8OJL+U9ZBUwVUrn+RB/dRQ1pJugdil2XJ4/wXyLYPt0AQSzMEZNwh1hA7tMkbdFpfRM+0rRYZ5CKzgZ3FrQEkq2kjitUgy7twYQo9CaIM7D7CsN9KtcmS4ls59AAgFOPYN8iUH57I+p38y8UtnTzjpBXCOyG0BrbL+9fdKdg5fpgeFHXyQS7bTDzgh3vXaePE4aHBd7jHw9vCpfe1tNYsjGMjLUTUSmqdq5RxBhJ+O5AJFtTnx2MIe93N1qlQsWqQ8GFIjfnnJ0rdV7+0Xh5UAMEIsVVVn9OF
 +ca72jpw
 mVlCVO+uBFNRk09ytuQ+20k1eEtj/e1MxioTXliURy9F/IB4Y5/YYdZ+Mcxi4wbk6iXV8eepcaXyArx4+tvi1LBclyRWSsXt/Ab9s2jnmFgVy4z0RhonceOXK3tslI7MMj9OISlQnNLML+FOR7atkq5of8qINkF4Clv5HeMEBDlKp8Pg7VS7gc3Y/oellM2GVAoA1Hvxan61L8nXVjVqK30Vn6PmddT0e1zz6xnuNaVc6xT0Y6EJnh7urV6/kCPHw05wx9YxHU4oY0wxpEB5PSvnv5YgiRQc4+zRylJzUCTnm1y5nd0WhX1Q1zfh6ZVgh5OM4y/muXbEYTZuFeIeCkJ4cPl0YWT0cl7ZZD3vCIEbR6rC2vhJkAdc0KabhnVIz2jPlZgoVIyuWHp8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/14/26 3:20 AM, Zi Yan wrote:
> Without READ_ONLY_THP_FOR_FS, large file-backed folios cannot be created by
> a FS without large folio support. The check is no longer needed.
> 
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

