Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 451D6CA101F
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 03:23:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C78C8E0007; Sun,  7 Sep 2025 23:23:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89EA28E0001; Sun,  7 Sep 2025 23:23:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DB788E0007; Sun,  7 Sep 2025 23:23:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6A7F08E0001
	for <linux-mm@kvack.org>; Sun,  7 Sep 2025 23:23:43 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 153F7140928
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 03:23:43 +0000 (UTC)
X-FDA: 83864638326.09.0D48CD5
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6056C40003
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 03:23:40 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=FEfKE3Q1;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf12.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757301821; a=rsa-sha256;
	cv=none;
	b=omDaZyJR0rlx2wW4PngIi8BxqOFvnzLa8o7kwftT+r0/nlgzmlWC/WkPSrGP4it84aHIG1
	OAUSxXqEABSXyBlmGWZq81CE1NHvFOz2J3sFzleePJfpVXxph8GsV7/eVDaagsrFB2wpuZ
	vjlCEPcPuKI81UVa0Bhr7q7upqfTH8g=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=FEfKE3Q1;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf12.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757301821;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lfmam1n7TdC8vpNeNDuwecMrTMDdFYZ9Uj7AdA9Dih0=;
	b=OkkcHICXU4++goD86diZVNHe8hUc4l3FoC/jl6mJViNId3AueC5xpXQX8eFMdH1PuV1vu/
	kRYQaKsBju43BXmb2Ebu+kbg/FrN/MBq24+vIIcKri+cEOtP31U0O8OzdQl/iXuynz4Axx
	2II1hK6N8irDfh5z1PdmrM5YJotkTaM=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1757301817; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=lfmam1n7TdC8vpNeNDuwecMrTMDdFYZ9Uj7AdA9Dih0=;
	b=FEfKE3Q1QT46ABR5quufM12i88i6NQSRmQJku8Y5zTd1PJsRrZ804E5cWwLRQ7cdjZWxPhEoMQTGCXnQP5zNBMxK2+6VRgANqwebL1YHL5m3yTHCXosZI9YLojwpWBgBlgw7s6RF93s/yyAFKSt0uVMqxMY68SjWTR0IK8fIrT4=
Received: from 30.74.144.132(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WnQYNOE_1757301815 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 08 Sep 2025 11:23:36 +0800
Message-ID: <73120e6d-0856-4ded-af87-1455c554bfe0@linux.alibaba.com>
Date: Mon, 8 Sep 2025 11:23:35 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 09/15] mm, swap: cleanup swap cache API and add
 kerneldoc
To: Kairui Song <kasong@tencent.com>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>,
 Chris Li <chrisl@kernel.org>, Barry Song <baohua@kernel.org>,
 Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@redhat.com>,
 Yosry Ahmed <yosryahmed@google.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 linux-kernel@vger.kernel.org
References: <20250905191357.78298-1-ryncsn@gmail.com>
 <20250905191357.78298-10-ryncsn@gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20250905191357.78298-10-ryncsn@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 6056C40003
X-Stat-Signature: btwq4xs4ugef789feny6k6xp8x99kt8b
X-HE-Tag: 1757301820-85603
X-HE-Meta: U2FsdGVkX1/+IJKqqMAuh22Hi0fPo7RceafYgTE7cj1Zj2Gdyug3ZW7FP285BRovmMWL5IlO9GTCZ1iga7D21Qmiu0M2381nFL5pJ1pptmPvHUVW6B4WMbePz7qTE484agsnls0Wy3YHtdWvqlpU6iQQ3seD1S4lJKZr6J6oPpCclLBf7nYTBpZxd8ean0VlZwb8Mbcn77Hqlji9ItQyNPSO7QiJDSLWy91jRqKsWh5OKVAJCZaIpsGy53IHWBmSNN5aotH2Jb99+FdckSosWyJsIV7V828vd7X20JAHwx3RHiRAE7vuhZAnA39+NDbw34L2G9WHAiNe5Ii2iFY+pZMIkxB6TwRFQCdb6j9mFyho+yj14Dx5+oyee0jUR/72k/qEujAG5KStYE7PhjS2Ld123H8k+BFBsR701Y/E5cXWWauIerWCjW/KqlpbXl+oDMW13EWBwtvplPO1DVfIe/Dc2lvUn/m/Rc8ZSbUEU4QjjJhfalwylH7NrGIA1LuxLIlkDrjQQD3xHHucP9sozmO9xUADXv5TosEQIZ+A5mwHlhHm3EUqLCOzRH8EN8U32WIdW3+2jntrXJa/WGqwcI5qfQ8+PqeLyxJ9u/yfKQMctqrtnzK80tuBl1bjHv+HFi9FrrPeTI7Vahvj4XisG50ZNkdiOwkEzYnG1CLSR4E232PGvJxzm7TThCqYV/W3SOWL4khksqkHrUEmFfDiWi/KH03I7dUDJPwWXPXxpggSuBF9EadjZxLP27tEzXBDGFr5HxzllboFOdhFgpDxKbIQcyx4MHr9dJ3Ab2jPL4iDZ5KUONpZVGuGF3XGLXTo/MW41ZF1SUuUelz+zTM6Ztd1HeKBJjzlpe2EmQ1Cz9Ph1BDNfAJIGz2/fadfIFqf5oD29qHFjPD+Opd5TrmeXpvyckPGAqDVsuP3p/NlgGHJJiJ25Nvc/Qkcb5ODLV9WtHUKxnpVlFmVQFeP78F
 nVKxoDid
 hzPsMcRzbrbzN+ttFWPO+inzhoxophCh62DZFNSkpTSat3e4oSRZ/FZxtYlgvStg9MijqTp3GB4kJF/cuTZMjyKtd+xY1LSniqR4s5Ro0zC6NijTMWe+6Z01qzK9TGZF+dAG7XFDTkqT21Sn6xRgknawDo+bpNQudEUr5cr4SKr8e7Z5QflU/CXt0qvtas904ojOE32gS+gvjZYowYCEyDziP4zRwiEZQYbtL9Pn6al1xXij7KXS83jAaqbydPhz6Of+G8wgkYDjKTi/f5G3KDloUiU3aqNQ0nYJWNqvNReWJZlgvRvugMORYKmALwQf8VToP8RakVBHORq8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/6 03:13, Kairui Song wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> In preparation for replacing the swap cache backend with the swap table,
> clean up and add proper kernel doc for all swap cache APIs. Now all swap
> cache APIs are well-defined with consistent names.
> 
> No feature change, only renaming and documenting.
> 
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---

With the shmem parts cleanup moved into this patch:
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

