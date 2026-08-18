Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFE42C5DF7D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 12:16:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9F836B0187; Tue, 18 Aug 2026 08:16:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C77046B0188; Tue, 18 Aug 2026 08:16:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B65CD6B018A; Tue, 18 Aug 2026 08:16:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 987786B0187
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 08:16:14 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1FD6AA0BD3
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 12:16:14 +0000 (UTC)
X-FDA: 85114287468.24.E3976CD
Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3F0CB180008
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 12:16:10 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=CtkBOOzd;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf16.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787055372;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YJN1XNbV1kVG2NQ3eF3Cz0aSxHqvy1o4DerQ17ykIz0=;
	b=JzO9jHLxgRKRBOSmwuScVgTxIQFOBORDwIK3tt5c2ka/RhbSmDCXNZ2UMcwOr5iMPje6W/
	i1maan64xkwBBAwUb22ndxb82Marj00WNACITCUsGb1ByPuId3bDRDrv7AGu/b4u3P8yQI
	zKH+l9HqSpNyU/goR790ymuBmzdg4QQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=CtkBOOzd;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf16.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787055372;
	b=GwGX5MEBho19sLPApEuphTz8sgPqyUbb8dM3JAruzmWgiN0ovUBHBVdfMtyaxC3GlspXAa
	/aEIN3epvzpCdm3kTQU2dXsNvaRqzd9FhFENXux4cGbFBqGh4IPwBncZsREJr5JBQZUcEq
	yWAFrG6aCw/Y8agKPknZwqvS8Jm3Ta4=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=YJN1XNbV1kVG2NQ3eF3Cz0aSxHqvy1o4DerQ17ykIz0=;
	b=CtkBOOzdgvQOOkYQfbKQ9+0f6okaXLJPPYPMqpbF8rpax8HOWbesMuK28GuLhRD77zlNyyGCc
	b1Rvju6IUfwQKh/prrn2V54H+ShXHIpbM34dNJzEFASE4P+GnwduddcihO2hS+GFEcb+eDFnQkh
	xK3Kz/K/Mlck3bzypEjgXFU=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4hPT0x3MLnzRhQt;
	Tue, 18 Aug 2026 20:05:21 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 6B8D14057D;
	Tue, 18 Aug 2026 20:16:00 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 18 Aug 2026 20:16:00 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 18 Aug 2026 20:15:58 +0800
Subject: Re: [PATCH v6 2/2] kexec: keep the next kernel off hardware-poisoned
 pages
To: Breno Leitao <leitao@debian.org>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<kexec@lists.infradead.org>, <rmikey@meta.com>, <riel@surriel.com>,
	<kernel-team@meta.com>, Kiryl Shutsemau <kas@kernel.org>, Bradley Morgan
	<include@grrlz.net>, Andrew Morton <akpm@linux-foundation.org>, "David
 Hildenbrand" <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, "Michal
 Hocko" <mhocko@suse.com>, Baoquan He <baoquan.he@linux.dev>, Pasha Tatashin
	<pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, "Naoya
 Horiguchi" <nao.horiguchi@gmail.com>
References: <20260812-kexec_posioned-v6-0-e477887086f0@debian.org>
 <20260812-kexec_posioned-v6-2-e477887086f0@debian.org>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <f794a7b8-ea8b-ef21-5bf7-de36f3210837@huawei.com>
Date: Tue, 18 Aug 2026 20:15:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20260812-kexec_posioned-v6-2-e477887086f0@debian.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Queue-Id: 3F0CB180008
X-Stat-Signature: cnsi4amsa7xoy5cwiqqqpqwi6pd11wjt
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787055370-483308
X-HE-Meta: U2FsdGVkX19hYDJq/rd9fJjK6jUzWuJP2dEDpnvGnFC2c6KbcmTR328EjBx/QIgg22T88yLcdzR8pT4ZNv0UxM5N4eHauclK7yS9j1Z9TqQoo1FkN8ev1VQSOE8lpE78VpmVNRd6rCslt/rUO5U6G8n5JVEJXzC5C3rACUiy5ZUs0ujF7fARiCMQNqIQ1GpodkB8/bQfKfJs1EH8vlcdI+yse5DSUHqhGY9UKeCUx+6OcvAhdfKcIopRwI6kZLQz91U52oxRnHI8aTs65c14lcfsgkQH9S0QQ14a5yWDct3+cSJLeaLsIJ7lTSSH9rLLkZWxKuB6mPIzp44Ra0JrdlOAyA1yQ1iiPnXwi+uHjsxhheNH2Ic8LaGnpK+9mBl7lpQUjMyfSaSHfxR82eSV64UebHUqw2g+My+ms+U4vyS5u3toCaWczovnkbdxS4F2YWuV0j+hsxYd5m7ZYszF7PBUNTajlmo3JM5lx/4zJ754jFu1xS0c+lM5XkFVjdOCKMt8MdomjSGajusBOTqnwETmm8t751BIocU1UiFWlcGqpTfmvR4jK3+9cPlxarKGyG90aEXCp59aSQ+B9WifVbxlarCeJxoc8A2GumtCMjfVCccyTu6Iph8GgaX+KIUVls2FghvE7BfP3mFUkEUyav8ZJKD+gHhmfQHZ2j7jXc7YDcdJt1ipNsdQor5hCs3+QGuZ3F4W0BNYdjJFjc0wUIsYiTqmOSDVNsRFh2Bx8Ogr7TbKHG4obnAs1hP6VXR2N97JDlj3U+y++ZCiJItS4sHwNg5uDV1UlqZA4YpwPTT+zYdTO9rzJ4jZ9QBGz1f7icSNYyfUxvHYCMEoVQA4vL91fL9nz1xiYQAdZdJYNKdAQ3IStOyRpCw7B8G/owabry2Mh+J2StBouFAuvApLwi7lRtJRurMYeWC/MMyryYGERitRkcxgNJV+cus3YpxK92tmvQRGF4naOKYdKVz
 j1xmB23o
 j92C2//x1emESD03R3ffFb/43P9QCluUdy2o/NtTJLUfFDlfsfvYip3660OE+f8y8Gs9Eywit1FOu0stMjOxhnmOluhbph6MUgkuKeSgUACuWUxSvxeZSSQnbJRQQRP5gwNkdgI4QdhYOPYLra38eShMwxBPYpwGfBHn4W0kuaHqwysacIjBGDOnNsn/V5m1yot1IngAwtCgdCTjOp8gcVEuCqqLfb4QYNVypFtkScjX9LIWUzp+W5fMC2dLwfk94Dvrw4Pq25GCU9R6Ty47cymU9N0jm9Ez0Q3fhGa8brh7XA0+4bLpIw0sTEnsi9f85PnbBQwHSu7bsT7Alyyx17Z4SZzC/V8S+bClXwwkqm+0MQ/IKOAi0r8aIee8IOBNx3PFEzF/Ti4WPo2nQB4W5IHJ+uXFSL4kv84QeV4H7TjhhjwuwiBKNdhxd0YchYJdoSfYYtbghVvQmJmweUQddJUlFGvUB1y2AvOlO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/8/12 19:31, Breno Leitao wrote:
> Memory failures (such as unrecoverable ECCs errors) are getting more and
> more common. The kernel knows how to handle it while running, marking it
> as poisoned (and SIGBUS user tasks).
> 
> Poisoned memory is removed from the buddy allocator, but, not from
> other places. A current problem is that kexec will load new kernel
> on top of a bad/poisoned memory, which is undesirable.
> 
> If the next kernel's image, initrd or purgatory lands on a poisoned
> frame, the relocation copy puts it on memory that is known bad. The
> error happens on the first read from a bad page, and that is what we
> want to avoid.
> 
> Skip hardware-poisoned frames that were detected by the memory failure
> subsystem earlier when placing kexec segments.
> 
> To do so, add a helper that reports the first or the last poisoned page
> in a range: memory is walked top-down by locate_mem_hole_top_down() and
> bottom-up by locate_mem_hole_bottom_up(), so each direction needs a
> different answer to stay clear of the poison.
> 
> kexec_load() gets its destinations from userspace and cannot move them,
> so there sanity_check_segment_list() just rejects a segment that happens
> to have a poisoned page.
> 
> is_page_hwpoison() also covers hugetlb, so a poisoned hugetlb folio is
> skipped as a whole.
> 
> Suggested-by: Kiryl Shutsemau <kas@kernel.org>
> Signed-off-by: Breno Leitao <leitao@debian.org>
> Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
> Reviewed-by: Bradley Morgan <include@grrlz.net>

Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>

Thanks.
.

