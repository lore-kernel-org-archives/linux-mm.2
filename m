Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F4DDC61CE2
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 10:47:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E2A46B00CA; Tue, 25 Aug 2026 06:47:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 694046B00CB; Tue, 25 Aug 2026 06:47:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D0B56B00CC; Tue, 25 Aug 2026 06:47:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3D1476B00CA
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 06:47:36 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AB3C91C18CA
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 10:47:35 +0000 (UTC)
X-FDA: 85139465670.20.A7654D1
Received: from mta0.migadu.com (out-13.mta0.migadu.com [91.218.175.13])
	by imf23.hostedemail.com (Postfix) with ESMTP id A4328140009
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 10:47:33 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EBFnMX9+;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.13 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787654853;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pLH6sSBSRD9ZYQLtphBhG84Hf24X3sZQjuhSjzN6Ues=;
	b=waCJ+ZN+0MqjPGNN7axjf3/5P72FQNfFYhTONp6HXo52tbPoX+umjLxHwcpM+dVxe1w405
	sakAwggI7aE/W54WTkVy+njAp3n9YIzlzoFqre9h4EswENcrNhxZtLJF3Rn88FMKiRMPd4
	IgylXAU+IhG+xQ5aQ8eQ6lU1d7Tm2r0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EBFnMX9+;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.13 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787654853;
	b=3rNZ5lF0wPL170RS6bD8SMXYzA1l+kDTReZJUMP97UVqRGrAo8xrdwxQM/WkgI6cSZCPSA
	cRUXqmjajPHtAXtEz1BIT44fqeMaCZR5JDf4lNegfng9onaVbSBzUTT40o7+1ohw7stEsy
	guTqopUACLs6UrGlqa5rZMrOQ2YXeyA=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=n2aH1LW4zBf5JFqhZeoA8jQ7gEcZolG4XK0C5vf317Q=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787654849; v=1; x=1788259649;
 b=EBFnMX9+WMZeQIjhoes8vZuXoMzmKBeNcF34h/QJ3lUokZZjOGsgaZ53PTc0uFRytXGrkSwG
 4Fu2EjYsuPbFhYGUOpeeLbH3Rs7dWNw/7192bNoTE6xwZHiu6qT0FGU31AC+I6UpnI01kkliU/a
 iOLfz1EqjjLjaplEjE+Kxl0s=
X-Envelope-To: linux-mm@kvack.org
Received: from [100.82.85.74] (101.71.133.200)
	by smtp.migadu.com with ESMTPS id fa391d319a902b86;
	Tue, 25 Aug 2026 10:47:29 +0000
X-Mizu-Trace-ID: fa391d319a902b86
X-Migadu-Flow: FLOW_OUT
Message-ID: <196ff683-13e2-475a-8cb4-cb0d94f08213@linux.dev>
Date: Tue, 25 Aug 2026 18:47:20 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 05/17] mm/sparse-vmemmap: support section-based vmemmap
 accounting
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador
 <osalvador@suse.de>, David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>,
 David Laight <david.laight.linux@gmail.com>,
 "Liam R . Howlett" <liam@infradead.org>,
 Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Muchun Song <muchun.song@linux.dev>
References: <20260825084608.47437-1-songmuchun@bytedance.com>
 <20260825084608.47437-6-songmuchun@bytedance.com>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20260825084608.47437-6-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: b9nn6pqn7tfwrdx6t41yqtdn458d8snp
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A4328140009
X-HE-Tag: 1787654853-436885
X-HE-Meta: U2FsdGVkX185axXuemYrL/W8yAyvGPliig8qLQpBb7SvMDEp1CqqTbxCayuBs/g6lWPjVtZt2eup0N8an+fjyNJCRMy1xf9oeCyxwtwvEoprnYxeT/JFL7Xqt+4Z/UA8zHtEMoT05wAqvaUm0cl1O0m2BPn1KNczJTDBJE1jwRBqhFGFAhFVwXGHwyc+RbRu7NTiswZQ2XCoZmdL65oYcSXVCuXApMaY4am+NVhUUKzvADQ9ZQy8MUKEJdQqxna//Lvd/p5xM6ZbtpPqqKoWcP2AUy2TxasT17TljeqwLWtv4NipjtodY88TpW+VyaDXKJckmUuwIgTGQR11COgCTp+5NSOzOBojOGC4artjDO9yZ/yNxIo4GNa1FGfd9XrocrRUIVgNW6yDiv0g39cdNgnaF2twgRcwa0kSbHnftMIqjYaq8AxVnvfkRF8GMZpUJBB/Lfn6WTpz2floUPh0NR/RZUt0Xc59PN/rS14onXbPpSTuoBQo4Qnbsox719CyzisnDG/s/Xidl1fIxfM3ZUlICtLDmjBTCeXUP3XwtnQca5TXLKQUnMrp0xXDYdlRTxIReWVU+tcWwJzOq1B9BaGD9fBE7Lppbasd0I4ojdW5xY5dmjmIjPA8gV5M5Fu9C/kd0J/GnqQlqmRrAMW30ZetHRiR5zuaqzhc7Hn8SPWqF750oCvun5ZkYzbd+kn+XAbqai55Yk7zzV8RyDbMTCmIpnHPaXDTKRitp2uDxnwWYvs0WNYRA8vQJTo+xDGiU8Rtz/2QOITDT3l+eDWimbaj5UU72dQNZsNqzgeDLuLiwxg+3oN3IyKRBUIuEXjBq/0GSLuRCfhPGKccSd0QsywxSYSeAS5x3PdbuKlEN/WlFumge4XYCTFoYbvV0cPfG5iYGG1rm2aYfDFvVZhlM1CtsHz3z5/GLdKIY2tQ9170dbKs/pQnLZtJNtOOkDVgr72gk7ANZqoo1Kks6kb
 kSU1ztEn
 T9g3pw6GzneN8LCzGrGG9DQZ+TD3Sa6TYD5dLIGJE519ClUezV6Ui3Z5lul0YyVmhReDy2MFmmrGtKO3cKBsINu+VvERqUQR178OqguFaOL+dG8vI3X8NioHxmlcAe2tBIeokXE4NxyC6mKWPI/75VcLQ/17MIDrQ+izjSHcqHQuuQG5RfvmLUQuw3sq+QST8CMT9t8BsqswBA5Unv52SeBzVko8FFCYAkhFyrzsDEM1ZiL/9BS/OIbXGRem+94LPLfsLgUlIrNLKajJCg/Kj9M24EyIYnAOVs6xa789QbVgCVDM+ChcTVsLSaE8OlPrPJYqwPAjlCXJdmnCrhoM8h7Y8vW4vZVSs/yW07nnsht57ucz4M50uy2RRiL6XqRiXgVyVo8hgYh4Zdr6c8bxr/N6CJw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/25/26 4:45 PM, Muchun Song wrote:
> section_nr_vmemmap_pages() can account ordinary sections and DAX sections,
> but section-based vmemmap optimization keeps its compound order in struct
> mem_section and retains a different number of vmemmap pages.
> 
> Teach section_nr_vmemmap_pages() to recognize section-based optimized
> sections and calculate their vmemmap page count from the section order
> and the HVO retained page count.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
> v5:
> - Collect Acked-by from Mike Rapoport
> 
> v3:
> - Add vmemmap_optimizable_order() for order-based optimization checks
> 
> v2:
> - Remove an unnecessary vmemmap_can_optimize() call to simplify the code
>    (suggested by Mike Rapoport).
> - Rewrite the commit message for better understanding.
> ---
>   include/linux/mmzone.h |  6 ++++--
>   mm/sparse-vmemmap.c    | 10 ++++++----
>   mm/sparse.h            | 16 ++++++++++++++++
>   3 files changed, 26 insertions(+), 6 deletions(-)
> 

Acked-by: Qi Zheng <qi.zheng@linux.dev>

Thanks,
Qi


