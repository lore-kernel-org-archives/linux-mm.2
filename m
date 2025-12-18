Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B34A4D68BF0
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 09:00:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D5DE6B0089; Thu, 18 Dec 2025 04:00:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 083846B008A; Thu, 18 Dec 2025 04:00:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED18E6B008C; Thu, 18 Dec 2025 04:00:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D93926B0089
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 04:00:42 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8331CBE1A9
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 09:00:42 +0000 (UTC)
X-FDA: 84231996324.26.642973F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9FC18180016
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 09:00:40 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jEpxZX6W;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766048440; a=rsa-sha256;
	cv=none;
	b=PpQ0OtUQCW5QAvRJuhfg7JNgKcrAsguyQK7apPUCuMkFA0wji9wpP4klLcX/oYqfqvrPZ7
	cNRmXIBMOoSv/z/3bXdKHIX/KYTW8akEWtebMzpuHkyJ8mvshy+fMyRy5BGtAkPTdGV60m
	WlY0vltGcH8mcuxH/+vpX+TpSFoZhxE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jEpxZX6W;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766048440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6zrB/QzR+CF1fB+S73StP2qTPH72sSqWf+tNuugyAes=;
	b=FUdAtfmkjlUeUY7czzynV3BrXst/H0VUCWqqS5GsCSPzMF9VACmm9Ypb9dhspvPXLj7Knd
	MTU+edfLMG1AwwjCz2Pai/u+3m3XCXN0v87sj0SVf+MWWwGYce3OV86x4d9fYE8WBvLg6k
	YCJCjXBxME7btvITS/fhQ69gz+NQX1E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AD9F4406DD;
	Thu, 18 Dec 2025 09:00:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C743C4CEFB;
	Thu, 18 Dec 2025 09:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766048439;
	bh=/0/rtcS385uWstxYx5vQaAZ1klTP2bjSTEEUQbZkcz8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=jEpxZX6WcT4c7dWdMrJJZpdtGqPgJ8kMu4eIg1pFdkUP+oikEB4UsfBdrDdRQ2WGq
	 eBwrStNELBsyZOLBGrYdgsazW4zjFXww8ESHIe53dWMjSRMRWXLUtSvdIgRhaKcKve
	 CWFO/IKhnR1dsTN9uYixAyq9l6iegYeCC9xYw6eK6WsG31Dmr7rqY5NMoOB4Wahsn+
	 7/4RZGYWhk2BTmp5762UMBy/r8xGPpGwHT/MH/mztp7G7HzQi5cbBaZe4wFhAuunxX
	 bkES8QgTQQsL8V80bh9TZPh//h3rlTDHcF8zQn/Dhpy8FowhtYr2Cfr63FCUtqTr5j
	 5cH3r6C2E0XQQ==
Message-ID: <bf97a657-f12e-401a-bf19-09223ae768be@kernel.org>
Date: Thu, 18 Dec 2025 10:00:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/28] mm: rename unlock_page_lruvec_irq and its
 variants
To: Qi Zheng <qi.zheng@linux.dev>, hannes@cmpxchg.org, hughd@google.com,
 mhocko@suse.com, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 muchun.song@linux.dev, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 harry.yoo@oracle.com, imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>,
 Qi Zheng <zhengqi.arch@bytedance.com>, Chen Ridong <chenridong@huawei.com>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <a11ca717ddd52fd83e1fff9942fc49c9c5c5b78c.1765956025.git.zhengqi.arch@bytedance.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <a11ca717ddd52fd83e1fff9942fc49c9c5c5b78c.1765956025.git.zhengqi.arch@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9FC18180016
X-Stat-Signature: m8xmzg5extxjogfs9kf1mp8kzetrx3ew
X-Rspam-User: 
X-HE-Tag: 1766048440-315735
X-HE-Meta: U2FsdGVkX18/5tnprYD6Zx9HbJ3+xhl5ZXD3HCozFFIlQFBhQOZjAlYGnNECbFrerfGCVsT34mTkCY8omGQi/89UolXLEtnb8dAFUXBXTm9Zv8hecvrxLPNBAe7cm1oV5VnMzF41u4yJu9+RUKbbAmE/dB21anLvZXjTar4bsXEXhp/6raRzfc9pjxyggb3gXtbmBC+UWJUM4f+KMprnovtFkfU/uJaKfLzWawx6nNvEJayzxmcItU5B/GWsuGgJ2rSUjXSnorbb7QN+FWfMWGpI0WaogrCts2BocpBWV9Y/BhB6T/dySd6ZfwWOBco3pIUgM/JjbU9T/vzwMSaY0cTFB5ai0vMoRzE9xWYuOSo/xO1I+wXwyLn73et0cIBZ1CQcVJcAlDp9rP7QnhW0pFu3JJTMo84CKlvVqhqsBf3KVcAtyYbicVQl1tXeOPY0OcJci3QtrU1S4xfdju7ZPKfFBbuayLESadqVih+Uv8xx3Oovt0EfhKJ1nSS6jh4X2u0+EY3c37rRanjfs4PwKzFmWWxFOJm1QflAEHgwzeKv1/h8mzyQet+VZ1mIZjdNUxTMhiNILkM0w/UsFJLsQMfsjbXf6z7dvZRXsm+eCJ8qMz55SZtNOnO9l/lhQHSzy8bnUZYpZVI1Kp455F6aSBpEqZPJj1IINQx5oULCGhmKrWnOlFsEnOdP08zb//GBeEoYgb/F1gzteyYss+gn4ha3hPu41Xq1fKiomgiEZTYgEFjaKDDjebzj1Yi5O1PNi/pjS7ab1tSPwcgDV4n3Egb9H2dB0HNtFnfFqadLoAyaiuM9YaKdOysnUpRBD337IWV205Gse00eFGR0mstdLMMc4agFo8CgaWjxUaZMq/YhjXUHbAB4pW4JcSFPMGuwT9qIKGvMipwDPXiz0aWpapARM9/VIpvZDQbwEJ0aK6BXWm/tkbrHwFlfm92UavkVlhkaPUSQE/oUKcvyIxB
 9hdPQijj
 LIQ5mi9dP1tzJdgSRwCHXIb89boBN0MNKjPXTcOBe+7EtN00DH9wKboUlWDW1T8Y/MCs2Vo0b3NJdQqAo0FTzEus8k5dIyeo3azIFCEDqM4P2xq1i/QtkINFumi5VwA8No2g81uvdZ9zUWVeDY+1zNwmA2ah1F4a2Q4Mjsf52I23pIYQLR4FqUwJUJgJchv53pIytc1b1pJWkmxzXyjmjQPDwLQ70UmMtpQD7pozXXpuYcjS66Vw3OZb0I6446NAfLtWpjWP3toMaq6oUqQU8bm31Aw9ZxgUkMHhtocj78mYrvFA9MDWuCuIwyuCrbKwdXZLm10jCzzEzC2DErwil44BnK/gOU92t5DmOrOKtMwoWm5iCHT9AvAkFPUjOlXHju9rdCAVQVjvInO3y6VHjfk7UrdL+SYoeON0f9SEd0rq2o7WBE13YlWgJKg3hxEzAWK4qy/6U+ZZe/lw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/17/25 08:27, Qi Zheng wrote:
> From: Muchun Song <songmuchun@bytedance.com>
> 
> It is inappropriate to use folio_lruvec_lock() variants in conjunction
> with unlock_page_lruvec() variants, as this involves the inconsistent
> operation of locking a folio while unlocking a page. To rectify this, the
> functions unlock_page_lruvec{_irq, _irqrestore} are renamed to
> lruvec_unlock{_irq,_irqrestore}.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
> Reviewed-by: Chen Ridong <chenridong@huawei.com>
> ---

Nice cleanup

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

