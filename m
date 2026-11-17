Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8752D606A323
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 13:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.a=rsa-sha256 header.s=mail header.b=CpC5ga6d
Received: by kanga.kvack.org (Postfix)
	id 050436B05B3; Tue, 17 Nov 2026 08:57:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 000936B05B6; Tue, 17 Nov 2026 08:57:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E097A6B05B7; Tue, 17 Nov 2026 08:57:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C00DE6B05B3
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 08:57:35 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 503B5A7F1E
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 13:57:35 +0000 (UTC)
X-FDA: 85444763670.26.D8FCAE7
Received: from perceval.ideasonboard.com (perceval.ideasonboard.com [213.167.242.64])
	by imf07.hostedemail.com (Postfix) with ESMTP id 582464000B
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 13:57:33 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=ideasonboard.com header.s=mail header.b=CpC5ga6d;
	spf=pass (imf07.hostedemail.com: domain of alen.karnil@ideasonboard.com designates 213.167.242.64 as permitted sender) smtp.mailfrom=alen.karnil@ideasonboard.com;
	dmarc=pass (policy=none) header.from=ideasonboard.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794923853;
	b=KEntphkKjeXUGekc9O04R53Xc7ZblM1O22H8noEFbi3SAVxk2W0jowOmAgjuUHN7323ySI
	BUMBmbqPUIrl9/VitpY1vqQ60OPY5YFdX70R225L8NumogWfVpqiwObdF6KWH/LQRE+D8v
	OTTBALjNnJ2HkQ5A5aUpun5Ju5KYMMs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=ideasonboard.com header.s=mail header.b=CpC5ga6d;
	spf=pass (imf07.hostedemail.com: domain of alen.karnil@ideasonboard.com designates 213.167.242.64 as permitted sender) smtp.mailfrom=alen.karnil@ideasonboard.com;
	dmarc=pass (policy=none) header.from=ideasonboard.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794923853;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oHtd/pbTnvrVurwDdLnofK84OY4uScGFLO1awwqENQs=;
	b=6Gr7kmcUg5MT4/xkACPurqymquA1gGemPrbJ5leQODUCHlIFv9VVvzp+0uw6AX3OrDltYR
	TZRcOzVlbpHBmBDUCqBAp4az6A1LoTRteO0SAD6+4s7qPUVNk4uU5dX25z/XMBTLo9Lhgk
	pFpUUC8d+rPUV1u4aNMVlyVjNfueBTk=
Received: from [127.0.1.1] (cpc89244-aztw30-2-0-cust6594.18-1.cable.virginm.net [86.31.185.195])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 1B85220F7;
	Tue, 17 Nov 2026 14:55:02 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
	s=mail; t=1794923703;
	bh=cHwdwzNargfc3BeW78Sng/2AI2tSJgiS/RyUNFGs4no=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date:From;
	b=CpC5ga6dMSesEiJ7rir/HGZ/EmCLaDwGe9KKBODAzTTQe9qb/FE9Z7pS1Vbob8EO5
	 nao8uNB0WdtbLekaQrGnC6Mm831Sne7+b68QlWZwm9QUd20Q1PvJd+O4zQlsTY7Gqt
	 7+BU3J/S+zF6WWD6zh/hZP6W1nQVuofFZqNsM/5Y=
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 02/26] mm/fbatch: allow folios_put_refs() to skip
 xa_is_value() entries
From: Alen Karnil <alen.karnil@ideasonboard.com>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Ackerley Tng <ackerleytng@google.com>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Alexandre Ghiti <alex@ghiti.fr>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>, 
 Binbin Wu <binbin.wu@linux.intel.com>, 
 Christian Brauner <brauner@kernel.org>, Christoph Hellwig <hch@lst.de>, 
 Christoph Lameter <cl@gentwo.org>, 
 Claudio Imbrenda <imbrenda@linux.ibm.com>, 
 David Hildenbrand <david@kernel.org>, JP Kobryn <jp.kobryn@linux.dev>, 
 Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>, 
 Johannes Weiner <hannes@cmpxchg.org>, Kairui Song <ryncsn@gmail.com>, 
 Kiryl Shutsemau <kas@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Leonardo Bras <leobras.c@gmail.com>, Lorenzo Stoakes <ljs@kernel.org>, 
 Marcelo Tosatti <mtosatti@redhat.com>, Matthew Wilcox <willy@infradead.org>, 
 Mel Gorman <mgorman@techsingularity.net>, Miaohe Lin <linmiaohe@huawei.com>, 
 Michal Hocko <mhocko@suse.com>, Minchan Kim <minchan@kernel.org>, 
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 Peter Zijlstra <peterz@infradead.org>, Qi Zheng <qi.zheng@linux.dev>, 
 Rik van Riel <riel@surriel.com>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Yang Shi <yang@os.amperecomputing.com>, Yu Zhao <yuzhao@google.com>, 
 Zach O'Keefe <zokeefe@google.com>, Zi Yan <ziy@nvidia.com>, 
 linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <c441176c-33b7-c8f8-fb7f-51774e1fd853@google.com>
References: <e28f9a94-4339-f8ac-8301-6be3c9b5b7ce@google.com>
 <c441176c-33b7-c8f8-fb7f-51774e1fd853@google.com>
Date: Tue, 17 Nov 2026 13:57:16 +0000
Message-Id: <179492383660.1554713.7829576009911841106.b4-review@b4>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=633;
 i=alen.karnil@ideasonboard.com; h=from:subject:message-id;
 bh=cHwdwzNargfc3BeW78Sng/2AI2tSJgiS/RyUNFGs4no=;
 b=owGbwMvMwCUWeK6p+sMV/3mMp9WSGLL+xLr5F3F9/Ne5sF+97axIV8yeF3s0wz/diZ8/a5390
 5kHXh7d0VHKwiDGxSArpsjy5ZDM9KU2K8IuaIZwwsxhZQIZwsDFKQATuXGY4Z8t//sVyvX7C61P
 +zM8UP0bNMPF/HDfq3l5rku3M389btfI8D/Z+eg+wWCmdwW3Zj7QWjAxdgdjH2+hx7515lF3j9i
 pXmABAA==
X-Developer-Key: i=alen.karnil@ideasonboard.com; a=openpgp;
 fpr=F4C21C97A53CA856D029540951CE827BF0D44F9E
X-Stat-Signature: 973r89w3s7p8ibxrbsoexr4op1kpaxbb
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 582464000B
X-HE-Tag: 1794923853-310413
X-HE-Meta: U2FsdGVkX194pugWForW2nx3nmD7h/eBb5J4HR3H1aPAVu+NDfWUyGz2wMlliLHg0oymAb4hknYb8KkJvgEVJ+BaL/7y16nhXIdcIFfXoY6fVk47B8Iyt+4lV86mTgbkDutye8Ah3Em7vG3hFNpt5vwDD/2aSovD7jxHgx3kpax56MszX+2r7GPH+bLS4+zD13Bwhft5zD5m8v9DtmFTk2vCceE0A+hBhufdFx79Yu/HhJkb/I1ubTKMfbQNrS/jtRT1650qgdISRcFcy9k6ODiZiqBdtEgrVNQGtB25jMK73KUSmrquuLNF8gL30+sh3tMzEbr7ioL37Lj9Ft0nZA1Ivli1Kd5j2VLTeuWwBFckT6X29zCstYNrhgbuYPF1cTmOkN7RIpC9Xkaid5WEXaQw4SREJ01kHTz53VgRSoqwrQooBTobYI6tg6AXpBY5Xo7wOa0xk9yHtOaLUXq4tO96qlwMbxjGkbyp0okx6SjEk501yp3KugkoJiYDxHePuOsvVBYzL9CAqmkv4lGKgK449we3UOBZvY+1y5YP4WhFw/Dv1JHTB3JgABZcbZgRR95nPkzRxO+blfasHvlMsyk1vkYt5KZz+mlEPE4ojChvTvKLGjUzjcTXDSKzeziPcGNWZledLp/x6eUiKIPN7nFVJ9GY4WYFaTICUsx0+BqqYRxHB7XEAUUCy4wUiqfsuk5wiWp66rBhGbzqYY7+4LOcA/Jv/OWB6uMNoEMma+9THkvKMqMsfTpfslGyzLLNbv1ILHHi1z/lUCYxqMTKW4OOjFkhyy+MVymrB0WpQYK5TwSXEzDpr68NFKTcWWBv82PhmD1G0vIPs/XU1V27gaUsDIydQN9wnk1y29JZuSAWMIN3XDKML89u07dREfwXG+U5dcTxt5shayCZoeSbrTWtiT/ChzVDN4OPZMFMiE7cdTR6oa6HxJL7A7rruXJ4Zhs7gDPKeSbwN9oSHJ6
 O2mXdaAE
 ZV35v8vPd+D4YJLuO5PFsmB3Q18QpFEiu4B7FP7V+u0AvhqJAKNcYxnyqNdR8yJYWhCwryT2nux2J9YhYQwo9JYV3vTzAtauGNk+xVeKgu9zram9F1o+KNXP7bua42BcHvDiSz0FmMgUJdSpLHjG+ikhq5Y2WvnorkZ4rwc4+UQmQZS64FUwav7G3XmmLQGNo9Q5dsR71ixVpqtk/SQyYUWgSXFCLHRS0JmN94gaQzZW837fw4qvAwVHuD4/3Z6hFFtyuYL7Rof2VXH2t/2Qh+twn1nXxfeZecps5N/iDzbzlDqS9mi+PHirV8qHEH2IJ7ylEj5+arDZ0ZtMyKqamvsmJ3SePrP8Lm1XEJm1bJzr+BBKBm506LB1/An4p/0DY8sRk7slGgc7nXjBYk1c0oALMCZn19OPonqYv07zTrMq8otwkNeO/w2nXnm5YyCMPppiR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 09 Sep 2026 02:44:34 -0700, Hugh Dickins <hughd@google.com> wrote:
> Let folios_put_refs() (hence folio_batch_release()) skip xa_is_value()
> entries, and therefore remove unneeded folio_batch_remove_exceptionals().
> 
> It made some sense when introduced in 3.1 for shmem swap entries only,
> but workingset shadows popularized exceptional entries in 3.15, and it's
> silly for so many sites to be squashing exceptionals out of the fbatch,
> merely to suit an inadequacy in folios_put_refs().
> 
> [...]

Reviewed-by: Alen Karnil <alen.karnil@ideasonboard.com>

-- 
Alen Karnil <alen.karnil@ideasonboard.com>

