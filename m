Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94A4AC982C1
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 21:54:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FA9A6B0088; Wed, 16 Sep 2026 17:54:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 483D16B008C; Wed, 16 Sep 2026 17:54:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34B6B6B0092; Wed, 16 Sep 2026 17:54:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 10F706B0088
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 17:54:31 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E1E99140199
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 21:54:29 +0000 (UTC)
X-FDA: 85220979858.17.4303D49
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1FF0740007
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 21:54:27 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=DXzi1Jf9;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789595668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gq1BSVOd53w9Y4VTYbQG4e9I+kizPM18DZDm9eCVhdU=;
	b=XjrycNGyGbVeBMrTROiLFfFOulNPK/EvCSYRAsspZegI/8WzSoQkO8Y45J27qOPanxkKVh
	eEW0LgO+kwTM7PxRAhiTfy/klotQlw0YwxxfoyFg6Zfq4BAYogaRGO4I/lW+BBRIWlJLD2
	h+tGxIa3Kx+l5wUGixZpV+F+QzYqFnk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789595668;
	b=FQPeyWCLZyZSIkc1IkFv0/YSOIy4K5rMWzZ/3osCGZnaqQxVu5t5A26UGq89kj52OB4Wci
	b0pzkJAxgsJpYy617pUtG10JlVrfjBMsB5vxPK8eib2XKrGA4X8zreEUVGFcnjeJZghNfS
	c/drYS44HrHVd0tPTVLEPKSIQpkO7wQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=DXzi1Jf9;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 50FA843DE1;
	Wed, 16 Sep 2026 21:54:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29EF61F000FF;
	Wed, 16 Sep 2026 21:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789595667;
	bh=Gq1BSVOd53w9Y4VTYbQG4e9I+kizPM18DZDm9eCVhdU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=DXzi1Jf96OLH9mzlC+Z5obvnvpHb/ZDWwIzCLNCaNsi+TNnrzFfyXW+w5XiTOUoI/
	 crDZki6Tt8rNNAZcBvTz5zYdnpXNHx8wist5Qdrk4vXEUglaQ0w9SKuJDidOiHkfH8
	 4a6UpbJl70OpgLCl+g3JXSTj2CrcPsyoyKX1uRXc=
Date: Wed, 16 Sep 2026 14:54:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt
 <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, David
 Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Kairui Song <kasong@tencent.com>, Qi Zheng
 <qi.zheng@linux.dev>, Barry Song <baohua@kernel.org>, Axel Rasmussen
 <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu
 <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Chris Li <chrisl@kernel.org>, Kemeng Shi
 <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Youngjun Park
 <youngjun.park@lge.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 00/11] mm: memcontrol: constify the read side of the
 memcg API
Message-Id: <20260916145425.32f739ea91f242e05e835560@linux-foundation.org>
In-Reply-To: <20260915-folio_memcg-const-v3-0-c239a6010b58@columbia.edu>
References: <20260915-folio_memcg-const-v3-0-c239a6010b58@columbia.edu>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1FF0740007
X-Stat-Signature: 9rtjjmr9b3uytab1h7xg75qtg4h68owo
X-Rspam-User: 
X-HE-Tag: 1789595667-300969
X-HE-Meta: U2FsdGVkX1/dVz6Be2R7F4R37Ub0TJVeS0BWi7abninx4kIE9R9Ghm0Y/vxo3zWMfQma+rR05877bTJ4KjGhoaIxlGyCT6pfIg1x3PyAxhNj8RFo47MQCHpJKtueICnUDPb9GaoT+GEKq7VfeAqoCF8lxlti6QAZeBtoQW38ZaCcAIGhNVIPYT7mxu6JAt3RosfZ73sPw17XshXzw5Y/q9wU9bGaPgp+wk1UXlGBNl+nFtKiDXnoSMGy2JIKjyn/zaVFh4Esay7/B7bsXe30BvMbTY2/WyuKfS70vw7MiCyZjS14Jfkf8mOIbp6r3PtrY+kl3av28Xk+3Upyq7UfTyhJM57bkc+u6H+jbrnf39kKN0ia/LYARO1L4PlxLk/wb5L/R9oM0nvYDpy/JYpyGL6Mr96d7IyLkDQlxHRR+H8NJJbNy8sYvk7riPC55lZjiwEcmDcPf/KKuat7S2LMknCaj8DUNevJgvXjexPbxRLWk8OwVqTdVT9nDTaFcyM4G1r8uJyjUuRfsKqlXbTMwhc0sPlgplFceF232uVpkHxsPaP/TF3ZmXEOvkJBuLme93at48xvHJi5I9zBX9U7ZlSc6qhZAfXz6rzd2sjE8rjXl2cDU6aVZdb0lhrqvcZB+eVhjziabNxFhR1nadNywX/Kmld9BtT8q1PWe6qQiOm61nNnTU+lQAsDOVjsxA4YLqTJmGd4bfKNsoiGrBQD0d36EoGDhsBXHJk7vuT4pLqHE7Qm+3hcw1zwyZhwvUM5omOeoPmv/eFvcAQbQr5LtdkdsFcHzH0KRh7VZ+cmVTCGnsJui8fQhJmBN6jrFgd617TOy5yXL+Mr8fjOYnGkpsg3f7xndsjYgFj8DjpF0kYvY9hkyjeAcSyovZqzLEtiNoMekn3s9TwWxtame1mwRAUZWiUoYCt5cYhxyPw5WD73C3XefVTOYa4Yilm7e+zvS36lO2EEktnxHXOsqfW
 8E4CSCy7
 Bxm092FZDVKd99pTfIsNSx6DEXuyMNVDVeduUu9yRe2aXtzN2nggboVtoPQXImzoA+D/CsnB/PSR/Mbnf1nR1ApNGqqaGgYd6yhAvCk/XmIL++IGAiNru2u6brf9GWG7dV0DpfVuMI6JeqaSoDaaAkfX5hUc4XlYVjROU74OY2VI4RWcLuoESBZKJ3hcPt9UbDki243q9PCxJDeyvolGWz8GpKCQ5O72EqO/LrmANGdcbkNhw9Eq3ZQNkGjc1yjRTNkj+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 15 Sep 2026 19:20:04 -0400 Tal Zussman <tz2294@columbia.edu> wrote:

> The memcg accessors, lruvec helpers, and stat readers only read from
> the memcg, folio, or lruvec they are given, but take non-const
> pointers. Constify them, along with the page_counter readers and the
> swap I/O blkg helpers along the way.

Thanks, all queued in mm.git's mm-new branch.

