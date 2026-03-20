Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1F8C1093170
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 03:20:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A9476B0005; Thu, 19 Mar 2026 23:20:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2802F6B0418; Thu, 19 Mar 2026 23:20:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BE326B0420; Thu, 19 Mar 2026 23:20:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0C8EA6B0005
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 23:20:11 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AAF8313BB28
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 03:20:10 +0000 (UTC)
X-FDA: 84564987780.18.C3D22C4
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf27.hostedemail.com (Postfix) with ESMTP id 782DD4000D
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 03:20:08 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=foZ1Zvt5;
	spf=pass (imf27.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773976809;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6kvcdOy8PHd748Znf9GoXMatn6ilXfT0VuUn/Hau19o=;
	b=umxIRPXR7xWRhSZIZXEsXRaWzzw83WteltYlgtvSQqSBqRfQ5uqbPHx6/cOL7w6TK0gkrW
	wkexo3czITTNZVo37iwvLJLYVb1c9bSspDE+JmazoyJ6Nn6eUxzFrP2ffs/AyBC7dxgE8G
	F/qzmGKa9y8LvFqEcu02agGfbC7CxZk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773976809; a=rsa-sha256;
	cv=none;
	b=gVOa4SnHnUlsH27PbBdeWUJ0aeKlRCGIfxnLKs39PDgALYQBjOd3jozkAA9LhJt2f4/2+T
	uWwWBVai/vaqU94W1L315hqVpoiny23ypy5uQP1Jz1iE/N7XjOoPyJ8OA2eyHL+Ijpat9a
	k0CLPUhT05e2PE82yLAgHW+jp8KGq00=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=foZ1Zvt5;
	spf=pass (imf27.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1773976805; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=6kvcdOy8PHd748Znf9GoXMatn6ilXfT0VuUn/Hau19o=;
	b=foZ1Zvt5PXUYcDMsftHTHdrpLrX1KmQkA7KYZ0toftm06dPzP8u1SRBAJ7B9yk4eS5gk0ku7nhmUNSsXG+byUaORQ7ltC/5fSd8xgZDKKQkR66/qWgSjmAaBcj0yUDUiIkufCB2xc+Dn745ADXojtdYLgKNamwUf93Ov/AswvtE=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0X.K7mdY_1773976803;
Received: from 30.74.144.136(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X.K7mdY_1773976803 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 20 Mar 2026 11:20:04 +0800
Message-ID: <87a5618e-3ae8-43f7-b0a2-3c1e808277df@linux.alibaba.com>
Date: Fri, 20 Mar 2026 11:20:03 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/9] mm/huge_memory: handle buggy PMD entry in
 zap_huge_pmd()
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <cover.1773924928.git.ljs@kernel.org>
 <1ec18767b106a1ee1ed6e33e332c3ad5531dc636.1773924928.git.ljs@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <1ec18767b106a1ee1ed6e33e332c3ad5531dc636.1773924928.git.ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 3dis788oo6awyo8xokeaciw6gcu5yh63
X-Rspam-User: 
X-Rspamd-Queue-Id: 782DD4000D
X-Rspamd-Server: rspam12
X-HE-Tag: 1773976808-280408
X-HE-Meta: U2FsdGVkX1+7Ya8ZgljVBIwlXB0BXKly0BVZfqug71nk8v7UX2chjF+uMXrbz4drBs0cuVd0vZ4F69oopn6hL7WWZfnj5/EhOxF2Q7ortJouPpajbrilL41/po9Hozl4xfyQDskxtX8uzD+eNWOqhj+m/cWnVecmr+01gUVKAUKs7HiL6Gf61FPqs+EmFPhSRkuF5F1Wnku6ARHSjymN+CfaNqjSH9LjwYUljTX1cyQGXLUKyfUivvCNGmGHn9+0cSBpgzbfXmwVutMQSiUJBfX6/2Juaolykgg24/t8MGPRGC/YT45koj8ba3PQEfMPQBiMo6BOqXt+02CZUUSKha5ScC1/MDHF5iB9rUOVrmCQSDFx3VkIQ6914I8L5qARhkqgl+xb6pwrSVe89cIDhuzMKK7klNyZu6WZgKX9rTNyI/1hDByejM8W9Kcuufo1+0sZWyqh2EX0WKXrnMX8N23WMYgm+CVjux+Xq5moRGzJ9a+DTWQE8sMVWxcxa+qkqFrtem3kgqOIo6iM70Weyxiqt+LXZBg6GauZIqiCnlK1iOjaMJkl/EZwoSLvhpSgPOzDtZvghDzEs9DLqSyezE7A8+V+2ntPKDSYs2WNtqWCMMldobvaoJL1ehVchfGApP6s7Gebo1orNHqIBLOEI2kk+Nche3nlejWX4dg+UOLXvXJx1r9MYAqSgpKkvPCdGsDgnYxc21TN5p+cV+3uoGt9DZ05AYVLAdPRqlxG0EAVcQdPjUmM69HdbbCmSW6gC0S35hHxDgYIgfoXsd7av13y0ell71svEMvpMkHQQVQS5GmLrcnu+L5/D3cwLRRoM4GrHRt+x0h9pAOSSX//BpzEu7dLoXp5AFM6KW2pyeExGbgz0ngeEtO2DBhpcWYhdE8qsyTZRL0ydG/U2yI/0R5MEk1tdzpXJgwocpXDOkyMoabSLSh693tcm06pOTtpAmyuKk9d+o4ugzpP7xw
 NRP23+JT
 h/JWqgSdKwizkkohJi/XpDMsxF6kHFxAbz9LctO+ldpG4GrLD1XB0rmzDKpR7uLwOzFeXvwN7gwIdDwcTvTJw/9qLFz4kugHmxDQ+KCOqLYOvkhKUQSpQwrGhF4ako0YL9PEb5I/0m3FF1sDCTC1wZ5GZSQIr7MRB9rdT50iPKOhjoiKr/okyPI2mZFLxoFgrJrjpmkEylELjYydvfJ+ux2eiy4aikIr+a66ToXkC/ACtYsWAKGDGHeIB8ITBsisX0qNaf4f0Iaq2jttTqphRn0l4N7eWVHGsKOtAaLElGIPJNzTLxjwl+uHCY9BIncJwzZm8d38LLq3AJkUwigXshhXzEoJfqikSZDZPC3VVquxhJ76Te3wWpPD+Gg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/19/26 9:00 PM, Lorenzo Stoakes (Oracle) wrote:
> A recent bug I analysed [0] managed to, through a bug in the userfaultfd
> implementation, reach an invalid point in the zap_huge_pmd() code where the
> PMD was none of:
> 
> - A non-DAX, PFN or mixed map.
> - The huge zero folio
> - A present PMD entry
> - A softleaf entry
> 
> The code at this point calls folio_test_anon() on a known-NULL
> folio. Having logic like this explicitly NULL dereference in the code is
> hard to understand, and makes debugging potentially more difficult.
> 
> Add an else branch to handle this case and WARN().
> 
> [0]:https://lore.kernel.org/all/6b3d7ad7-49e1-407a-903d-3103704160d8@lucifer.local/
> 
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>


