Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A055CFA466
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 10:55:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B75806B0089; Mon, 24 Nov 2025 05:55:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4CDB6B008A; Mon, 24 Nov 2025 05:55:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A89D96B008C; Mon, 24 Nov 2025 05:55:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 97FB16B0089
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 05:55:08 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 69BF31602DD
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 10:55:08 +0000 (UTC)
X-FDA: 84145193496.05.F6B1731
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id B05CA1A0007
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 10:55:06 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tOVSlTS9;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763981706;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FfdDOGUg0YeE4tddf8KaECjivEn0P4n/3MuLPm82a+8=;
	b=jDT6nHBJVp/Pgo3IZ1yIu9Dejs3olDiXYRVfKg3WQF0V9bh1LOB+DUG1qDwjvEQzcG/cSz
	zZzqf8gjSUF53+HlHf1x+vi/pYcsGvHF4zlVah7V+QuLAUUKWFFWif/gKOa5BDYZ/WuQHf
	DJfCgeYkzfmztLpvJRHgRJM/9jqLSJw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tOVSlTS9;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763981706; a=rsa-sha256;
	cv=none;
	b=yfQuaJ7ZPU+qP8CZrSiZCTjNxjbb+EVWmXiEAQsVHfXXwDBtVk4qcm03XrQ2DAKbU1mIBE
	2tR5tNHRi1YsByT8JTY0PBuPKjjzrKl4rVfSl+UU7IihM/YFbKA280ihkKqfZaXhLTeVwI
	mL/RlOlh3tH4W48rHhKtJsz/ZCxDcdY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E4D054427B;
	Mon, 24 Nov 2025 10:55:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE3B7C4CEF1;
	Mon, 24 Nov 2025 10:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763981705;
	bh=i6piP8RVoo8Nfdlpthh5mtOeZm0yzG1ybXNQAG99vVc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=tOVSlTS9uHwA7qPLUoqGUooAiY3MY3hAv7tDgVMG0kcMT5v71gel2peoOQFqQBTQE
	 5TfqF/iv2ZSUsaEDwbNaaBilNOvPodFk66se0Dnx4sKemwre/nRqzeuKKN6xrtFV3F
	 0lyFQtNWbETvjOJ5aWCqd9RcExFqyeKTigX+x5fza6oXh81BHMKS4EOwkMe8/JdwQv
	 ujnRkbia7wlXRenO8IwXoVxwrmpEkkewCK0cp0NrCutaB0jpRRRX2FJNLH+45ejvV1
	 5urNehGrWFVaqo70kSfkS/EpV+hPwrwsVLUJPNG6uGs+U0SzngtkzSNu+oC61a6+eQ
	 WbwbOUKMoeQxQ==
Message-ID: <c7546593-75f7-4248-9986-f89c157a18a1@kernel.org>
Date: Mon, 24 Nov 2025 11:54:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] mm/zswap: use %pe to print error pointers
To: Sahil Chandna <chandna.sahil@gmail.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, mhocko@suse.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, hannes@cmpxchg.org,
 shakeel.butt@linux.dev, zhengqi.arch@bytedance.com, Liam.Howlett@oracle.com,
 weixugc@google.com, axelrasmussen@google.com, yuanchu@google.com,
 yosry.ahmed@linux.dev, nphamcs@gmail.com, chengming.zhou@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: SeongJae Park <sj@kernel.org>
References: <cover.1763796152.git.chandna.sahil@gmail.com>
 <0c00ceedce6e0d9aed35cee5faf15fd9126a1f70.1763796152.git.chandna.sahil@gmail.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <0c00ceedce6e0d9aed35cee5faf15fd9126a1f70.1763796152.git.chandna.sahil@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B05CA1A0007
X-Stat-Signature: mbqoqowb3u19cg64ucmjojgkaxxxawe4
X-Rspam-User: 
X-HE-Tag: 1763981706-369182
X-HE-Meta: U2FsdGVkX19gCwgNe1PEmKYU8grFiUpQopV64herjlbBLj3sI/edNe4ayoWDfyQ04Jtv/dr8h5Syt73W+Pn/qSolsn7YTpumOZYxi3YI3qBqoCM2nKRrD6FZ78IDbkGk2L/Mu8D0HlM2EgaNiH+Mi0seI+IZqWwD8glKjre1PVstOrt10TwQocxhumNuQzYBBbHy9fcZXu0AEz3IRIZuFL4k/SV5LHJPg1RqtW1UV7vKPoUDgamLK+qyNt23OlyQWAfXdO5o5TzKDKQ1inQivDL0Je5HJv8ucCGNDlWlbHVr2JGa8uNDJVI5/aBPrtnH1eU2XFkSz3RA1bCEP8Ym5J08AjsLRmsPbdPUJ5VbXyCl9iRu3In5SxqgHPmk+Strpy6tdAWd5pt2TJQb97z3oM0FZiJDBHgOXlTvRzuPW+7VFYvuMPQrdOXemEweiiFYVLtUT4gkPP67e4hHprdyQAVYu7UVkdwQUMrrR11rwbreyUonwNjhgEsfGj1ipAmQpaP52CRMW4ABSCB9hr1cni7tW/QrGO7pdQ/8q6MjDiksPo+412+dMDehEks2yr+xqhAAR9HdXIg04oxgHuMUAWKiJtYHDEVg7Rx0ifvJoh/vE/Pk/aLesGTAv5gI5UttEc1rwT4Mr8U/jr/yHCWxEqY+NVRiwWc8fwEuddFrRvZ9hndjCWLRMLAOnjrXqXNSOio2figbStZ0DUPVrg1vtpEzs9nMAh2Oi6Kqt/0xuscd6EcKcM/b8PGpmmSmaQnkWBqz0oFPamV+/FXpoHcdN2FRZU1MdUT6Kki31+LYANN8BeWGrHULAsFXjvqApWKLytZtXn6RCF58DGArtd20xv/KiOaz8U0qO2Wb0olSCYAleSlrCx7lJXcFNq1oZyvX0uCiaUn5ThPRsodazi7rAPojkaxgdGJN4w3tjHpj+mYftqZVLuUtsQCbBErJSFutPBgqICSnKxRIcq6u7L1
 aIqMXYcm
 IdQjo2QO9X5hiZYq/U6/3xBnkdO4o/iSD/NQLu8EIhrBm01HXkar3PXW7DTe2MOWq5LQC7Q6mMUMNE9n5s+7wwjbxCXTmVEZWZx0oLXV/7R9YY/4lhZj4+ljXKz7oErHU3K+8vygeYODNhoOrjgdUXqK5qWRn90AQn6OCvUY3Z24Jy8D6gfICVIIqf+UqlSFCOJeZJYA/JNjEnmc4nuWP5S81Pfn99H0D5RvdV0ffllh2UIK0neAD5UTZ4e9dRiaQpOYlHfSWVEIOHudnD17OPNtaVDQ7W3SqGudqhsk9futxED+v5qXEvUD+dpJs37uc0jbb/DR1moUZEem5ETb1blgbkvyN4K1Vd38y2TILfhpy0n0i13W9uhrWCQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/23/25 04:04, Sahil Chandna wrote:
> Use the %pe printk format specifier to report error pointers directly
> instead of printing PTR_ERR() as a long value. This improves clarity,
> produces more readable error messages.
> 
> This instance was flagged by the Coccinelle script
> (misc/ptr_err_to_pe.cocci) as an opportunity to adopt %pe.
> 
> Found by: make coccicheck MODE=report M=mm/
> No functional change intended.
> 
> Acked-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> Acked-by: Nhat Pham <nphamcs@gmail.com>
> Reviewed-by: SeongJae Park <sj@kernel.org>
> Signed-off-by: Sahil Chandna <chandna.sahil@gmail.com>
> ---

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

