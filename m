Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 941D8FA0C35
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 06:20:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C13566B0092; Wed, 15 Apr 2026 02:20:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9CAD6B0093; Wed, 15 Apr 2026 02:20:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB24B6B0095; Wed, 15 Apr 2026 02:20:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 94F5F6B0092
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 02:20:24 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 230B458876
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 06:20:24 +0000 (UTC)
X-FDA: 84659790768.04.47C4479
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	by imf11.hostedemail.com (Postfix) with ESMTP id 885464000D
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 06:20:21 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=m3tk3O1T;
	spf=pass (imf11.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776234022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SLjSccDc2NIp2/wGYqd/TLfyKUp5TkLsnxrhbbYw5GQ=;
	b=o6dIuTVKT9YDe+bVneuoIeq3lSeqevkYmQNuhqGF9ERczIhQTsuJNi9n/eLrFKBh4H5SQ+
	k7tyJ1tVu0LkevyjL6Lzoevx/zXG7NEGXRY1cevGE2SUARa0yGHnnJcvIIDLIlCVd3id5N
	sky8pZThDh4NGO94RexPV8TEopxU3bw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=m3tk3O1T;
	spf=pass (imf11.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776234022; a=rsa-sha256;
	cv=none;
	b=Nonivy7F0kuQso5u+D+3jbMIqX/JHMhQbV6ZhYFl3CxU3eOb4DYMgMAAMA7EhzSJUVp08V
	gON0FABhUz741fzQohs2dQTDpIp2eh1svY1e9F4oAPFNM99g9arjRXSUoJv1mrdgRjg+4A
	1BGC6GdR6VQLxxPAt4VyddcDRhmqp0U=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1776234018; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=SLjSccDc2NIp2/wGYqd/TLfyKUp5TkLsnxrhbbYw5GQ=;
	b=m3tk3O1T6aa3XYbMwtQWc80Hrc4lB9LtKpaeoBDMwLZrlNtlcH6/iWSqx6iXBiAJLlVLQ6HSzAs/eK0TVI3fKmMaHh/XY0hXW+jE4hquHdVSrCJVd5XfnfFY2CQQrOWZtECBqxX0gZV/FV7VARbRp4AJmEax9QVo2Mu99mE2e24=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=27;SR=0;TI=SMTPD_---0X13bDWp_1776234017;
Received: from 30.74.144.121(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X13bDWp_1776234017 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 15 Apr 2026 14:20:17 +0800
Message-ID: <d57d79e9-da3b-4ff5-afda-f705bec54f3f@linux.alibaba.com>
Date: Wed, 15 Apr 2026 14:20:16 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 v2 04/12] mm: remove READ_ONLY_THP_FOR_FS Kconfig
 option
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
 <20260413192030.3275825-5-ziy@nvidia.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260413192030.3275825-5-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 885464000D
X-Stat-Signature: fhbhkdxm3xaebfmawzygrykiuby4w5to
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1776234021-895705
X-HE-Meta: U2FsdGVkX1/LEJ6ZIJSExIFQvDSEpWKC5hmYvT7dWTKIZ+4ZGwEJWgsXOV8E1WWxT5vu0omdnYvhwTh2t1KxOFRdDOBIAqt0JSkCmjxwoKlnzdYStYquUyRh5YB0b+R9zXsVuWWV5Nzml5wfPyf4ruGwJyz5tykv/TqHPWj5tFJ/t57tf6C4FWvHUaGe3CtSgZu2xRyTdtWMcXmD1UXzsM63z9PR0gFWEkEx2Mwq6fu+584OS5U8F6H20h6Fzzcn3CG9bX1Gm+NfmJR2wc9BdbmcYaGQ6PhQRBg40FV1JJcxoq/DVfccUcVC6ejuHhHEKEu5rCWtjZ8qrrsrA573yvYuc8rAOWEeZDtgx5WqfR4ylCJWdNvwJbAdyvZt64GdZ6hqh45dKNgp7HnsXeX1wE/uMMIl3YG7YzzN4GQLzn8OKxy/I4GOq9mbUGVX1ncrJidTqRqG8nWj/R0478pALC9t3qypvw1a3rYOcIONa64oqTq6vKFBm3e+cNoWDX4uS9V7qk95Wh47Q9UlSUgYfocHTr5Oi02MgmmV7w4+N8Oq2kUpWHtPWFLdD4vz7R3niNOc8bfUhpbPnyMfHIsx+QwqP/C9UG+uGraPtiXmXjgSSIv5IjxSffS4k//LGZ+qIs7Od0pno1Ql//dT1isPS8RNzqgWFrXx3j1KlNKXMt/0Bn3hp4pz+K1TLYQXpm9CrE72lbmpDem+oTv5Hjgl+klYaggE+1XamCYQA2YyhRaKKV96cpSOLJPkloQCAGUvSrkNC+dTn7U4bjzPuzqFFY5K2YlYOE/LEomWoRCWOOPUUfxngTPiIWVoZHHJTHyNkKmE9k6bdeemTmqvY4hmEfa/YLdEechdKopTQ89HQlogttRExQlUzaNK2YM+oO7p4aEWCpdT11t727Npthib2q8VYxCy1fbl0KVy/s6fsob35BKy8LYd90UAs6T29UZuGz63Nu6Pssllsw3Aukl
 y9/5IByJ
 ZmVNdjW87mS0JttfEsUSQNb70X6kPZYnnoLZaYpRTvseZualFfDPSNrr7wwSBksl0WtUp6WP7ncDAO4P8mVZN9Y7YVQanZAW6h7HbDVpS8im6kelVPm4hknAeYm1vd66GoA/Zr7YS5YLCO3GiQqLHGU9qLXKm4+5/MD6A4MsScQd85JrDtd+xCnMBKu+hsT6rxUoM8rbNcr5w0L6+BZj0aooDUgun5BbUNu2yr4d5fGubXImdVmUYTSW7JcFr/e1HLYWeF8kKt+E0IT3i3EkyLwmsKQ6RfdTWVpgxVZpeliMMxV4TyYhgz5KAT+b8wQfUPdF6wL1j/+nV0AHS3BxSH/Q0W6rg4qsF3ZIRiFzrNanEBhZK94f++1eyXwzUt2UynllgwJ97hpMikRY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/14/26 3:20 AM, Zi Yan wrote:
> After removing READ_ONLY_THP_FOR_FS check in file_thp_enabled(),
> khugepaged and MADV_COLLAPSE can run on FSes with PMD THP pagecache
> support even without READ_ONLY_THP_FOR_FS enabled. Remove the Kconfig first
> so that no one can use READ_ONLY_THP_FOR_FS as upcoming commits remove
> mapping->nr_thps, which its safe guard mechanism relies on.
> 
> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

