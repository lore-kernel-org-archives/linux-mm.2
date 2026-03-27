Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 296DB10BA45C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 09:33:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A29F6B0092; Fri, 27 Mar 2026 05:33:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 579D46B0095; Fri, 27 Mar 2026 05:33:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B6EA6B0096; Fri, 27 Mar 2026 05:33:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 39C8E6B0092
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 05:33:11 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DF6181B96E8
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 09:33:10 +0000 (UTC)
X-FDA: 84591329340.16.6F0935F
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf27.hostedemail.com (Postfix) with ESMTP id E2F0B40002
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 09:33:08 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=D3qK82Ed;
	spf=pass (imf27.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774603989;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5Lpsur5mfhIYIdcGTVML/ZxkQ0VDgNhtSZ2tOFHDJTk=;
	b=QA06Z3L3+vqsouW9XuC16I5mt6ra+JRSPxEqCcmowFIwMFOg6wc5vy+KaXzN6v+fv+uiGI
	Xjr6TmbBqgxjTMHTQf4jBLDTnrDra1aiD01cJZRAGE6GurXCPTradyIeL/fkg2MIwW5xfy
	Ztib75FtfL/8sGoPPQLraCQmPxpgmhw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=D3qK82Ed;
	spf=pass (imf27.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774603989; a=rsa-sha256;
	cv=none;
	b=7Nd5DR8CXpO0m1I9uFNsOyQ84YMJ2qqH9wmtVZIuECDZy0aoQoK13KB0x0f2q8fPjabp0q
	szHv+fmnZcQnUqIKRAfApwyJybGsZcyKbK76JQhkyTcj7F2NSG60dlD5wInVgZCSSYW/AB
	LX44kvJ6a3LBeLU/SY1VF+I/uMFKOD8=
Message-ID: <710a9152-83ac-4d5d-a74d-ef0653596bf8@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774603986;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5Lpsur5mfhIYIdcGTVML/ZxkQ0VDgNhtSZ2tOFHDJTk=;
	b=D3qK82Edy8XhDc0vBrTeZETe7pTWZ1aqy26Q2CHBvfLW1hhtD8uA39WUpR7gwJC1eNy5dy
	vimnFAwMAPkSbf15e1ev92Fqrn1kRoilpUGR+8coKrQLDzApVrsvMagiHDz+3ULa71u6Pk
	tB/QHzmUxD9Vi+5nRiQpt+xefOW9a8k=
Date: Fri, 27 Mar 2026 17:32:40 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v1 03/10] mm: fs: remove filemap_nr_thps*() functions and
 their users
Content-Language: en-US
To: Zi Yan <ziy@nvidia.com>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Song Liu
 <songliubraving@fb.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>
References: <20260327014255.2058916-1-ziy@nvidia.com>
 <20260327014255.2058916-4-ziy@nvidia.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260327014255.2058916-4-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: E2F0B40002
X-Stat-Signature: 8i8p55fabbenfxgagmdhe8yrwcdxmddf
X-Rspamd-Server: rspam06
X-HE-Tag: 1774603988-327272
X-HE-Meta: U2FsdGVkX1/BGjTmLZcNcZV/vBrc0SMSJYUfbST+t5jgBWha5ChxzrFlinJePFwNGJmLjN+B2SpwmcbhW6OD3cfeAVxKar+Aop59RkJw4z4dnYHXxE54BpS6R4YvfGY/40IMGsjOL1LUlTm5lzf/wUh/t5a/+nx8Uv0a5mVcrCHRwLyjwQrddVJaj1y98/QHChHdF2ubyuWF0nK6Iw5mz1fwIJnQAtFkblOxaPQyYnniwAnT+qMqBtaWdjjYvxHQHr9v5JoHLi4GVKSHjBDpseC6t4p8AJggM2RjynGSheL5ayhdMgbD9ldqyir1yzqI3CRFGAAVD9kr9+2oCqb7DbuNAizjy97G2QUnjQUnMXcprzaO8wjPBBo/tciaBc8eRDcNVMej1vgROfoPljGNEakCRT5jqJccePhhpCW6SFsn/+W7Y/QtUeteAz7MmSxJKZnawWKXKlF2/88On2hGs/CeNNWEhVENFGL/4YOGwRmtEmgzSvMtEqdG4XVIv7mIcpyNgEwxTw/V8epfyRfIBz2DSAKhiFi34ik/WWF5CFfxue96ZQzOmpVi7xy2rNVgUEXeEQ2S5QYXb6vwb/mDGTWr3auUEVz5nMBZNbxaEs2rROKlIK+EJFLQ/oU6oA59uf47cfkspH/PS15ptMb1YXgrKFpl6i5LipsOL8HIB0fVQCAoJgLak4a88WsG0FjcQeuhyp2AtT24iSQJ088FRI7sZdQGm6gJgVWfvdVkhf+ufqnmxeuU+147LRSqcPemrGI8U4onYqWnIoqNTDOx/wTOM84P13jwzDjxt91Svx2YQI5RaT60XKxQFmSQGu9DM11vekTsIid3WJNn7xv9KvCaL/KkiwQfVUDB5t+xKJlNJPFhC16D7UTqmOxkiJopeXDq176VIOwR72R3HnFP7hF3yo0cj7OMWyr1RqZYn+XGCcjggpcgA5SDbLvi4XI+37kPaWqrElpN3dAqLwX
 QOmI8us1
 Sjcz7TadroaIcMVTNe48TzLr6BqCuhxlehghv9o6qFVWYgfed0mDWDN8zjN+SYB+aq0NSjIW2CcrDIbVNaZ/YwN15euw7jf/o1CVT2xCCS93LH2I9rmV4elpxAJw097VbMSjMqZ1Rsbrio0B30kE7+AsVkiahHtEuoaSXyqsrlvaWdDjV6mLoZSM2gieDIbbA9Fb3Nj6kvnHbZIYbfXFDbacB+M8lUzlHoqYKak/sw45ABQbvX57kAJoyqQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/3/27 09:42, Zi Yan wrote:
> They are used by READ_ONLY_THP_FOR_FS to handle writes to FSes without
> large folio support, so that read-only THPs created in these FSes are not
> seen by the FSes when the underlying fd becomes writable. Now read-only PMD
> THPs only appear in a FS with large folio support and the supported orders
> include PMD_ORDRE.
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---

LGTM, feel free to add:

Reviewed-by: Lance Yang <lance.yang@linux.dev>

