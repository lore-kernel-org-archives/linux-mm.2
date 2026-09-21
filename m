Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28242C982DE
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 08:20:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C53E6B00CD; Mon, 21 Sep 2026 04:20:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29D016B00D9; Mon, 21 Sep 2026 04:20:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B3C16B00DB; Mon, 21 Sep 2026 04:20:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 017196B00CD
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 04:20:38 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7C0541C2F0C
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 08:20:38 +0000 (UTC)
X-FDA: 85237072956.11.38BA95C
Received: from mta1.migadu.com (out-105.mta1.migadu.com [95.215.58.105])
	by imf21.hostedemail.com (Postfix) with ESMTP id 33B331C0004
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 08:20:35 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=geLga7TP;
	spf=pass (imf21.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.105 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789978836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pQrVdrIXKT+mdbFaer35dB4HjLy6wUnP3qN7KblpCwQ=;
	b=NG3c1FOyZGg5HYeCLjswg0Uebukq0dXJszPGE1ij95HiiYcWZJ6/jocoxOR8eI8ShFEle5
	NcPKCuUzU3tfOSrI+CxeikRltuE6QPEq9Lc5vHaEg5H02AYUYeK+nBLN46STRpNxd3KsqC
	3Lh86Rtqtz9fNW8L8O7QzBKRQWPBX10=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=geLga7TP;
	spf=pass (imf21.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.105 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789978836;
	b=xPjdWPanHJQcUBTS1B1to/Q2ueRK66Es+NZSRUkbNSmWA9swVrTFDO4cj1zO2rw+v/f160
	99vdoFPnZNuSZvYlOoVXpWu2YE57hG8UOtHv6C7fuuDx3bvYCRfYpEm7+ZfU7XqkdAM/OU
	oG1nghXLjQIeSVD651KdCTFnjIjT+RM=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=aoprAUYmUN2jwm3AkI2t0iJil/x7yD8M/lNnyU1MNmM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789978834; v=1; x=1790583634;
 b=geLga7TPKZdw6BZ0Chc/T231GpXsFeZchfx695jB2nzmcsbTlL2XHqZkxROTzjWBjYz3G7Pf
 bHKM+CWF9rIgbDAtmUjKDXaJI1QgOcnOESfWzn0cJ1DIBQeFpmxBGavEjQiDoiWXVLoTw2lCK4A
 g5M5kkV7Z744lWN/TgNw9GDg=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 3d02c4ea80ac0ea7;
	Mon, 21 Sep 2026 08:20:20 +0000
X-Mizu-Trace-ID: 3d02c4ea80ac0ea7
X-Migadu-Flow: FLOW_OUT
Message-ID: <86f06c26-5318-4196-b792-0662ad64f2bf@linux.dev>
Date: Mon, 21 Sep 2026 16:20:01 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 08/17] erofs: mm/pagemap: add readahead_folio_last() to
 avoid folio->private
Content-Language: en-US
To: Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, David Hildenbrand <david@kernel.org>,
 Dev Jain <dev.jain@arm.com>, Usama Arif <usama.arif@linux.dev>,
 Gregory Price <gourry@gourry.net>, linux-kernel@vger.kernel.org,
 Muchun Song <muchun.song@linux.dev>, Gao Xiang <xiang@kernel.org>,
 Chao Yu <chao@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Mike Rapoport <rppt@kernel.org>, Nico Pache <nico.pache@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Lorenzo Stoakes
 <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Qi Zheng <qi.zheng@linux.dev>, Yue Hu <zbestahu@gmail.com>,
 Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep Dhavale
 <dhavale@google.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 Alistair Popple <apopple@nvidia.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Hongbo Li <hongbohbli@tencent.com>, Kairui Song <kasong@tencent.com>,
 "Liam R. Howlett" <liam@infradead.org>, Chunhai Guo <guochunhai@vivo.com>,
 linux-erofs@lists.ozlabs.org, linux-fsdevel@vger.kernel.org,
 Ying Huang <ying.huang@linux.alibaba.com>, Barry Song <baohua@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
References: <20260920-remove-pg_private-v5-0-bb68b6a21869@nvidia.com>
 <20260920-remove-pg_private-v5-8-bb68b6a21869@nvidia.com>
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260920-remove-pg_private-v5-8-bb68b6a21869@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: foafqg89pwipjt56mn7snnqiww9zgehw
X-Rspamd-Queue-Id: 33B331C0004
X-Rspamd-Server: rspam07
X-HE-Tag: 1789978835-191779
X-HE-Meta: U2FsdGVkX19Z0uzJayjgI4Oq/ZXvtO74IJu9QwhR6Yrv7zi1QT0s3jY89kVDwPza673VTDYHZb1exIow94nz3a03jdUvVEHU3zZwb7HTPSXmMbjkBi2SWVWizh9dEOPStlLJbzHACSUqOQTO4sT3GLxp+9AZQwoTc7iwuwcW9i0b9RKkyh5uWJpv4fOif4raFpP+GbuvinLvQ58yxpNek7OEOnSGRr7qIwjlGVbkWRCVQ48HgqmBKjYSnwSe+BcaNsSKMN94Cmwam0Iu0z8cmce8gP+VpLIeEYeAWGgR0KHj6a36mVHDrAHmiSeLh659HWO78O2qE3jNShHnqGTcFUbm+qgpJQlScokSXFDy/jGGppgL8OiROKhVkXNKydQFgxwrPRoJ/EciCQ9nnwE71ti12bdEyWjvQA4ITs77A7Pa+UDoceRUGYZX48WO1P9h0FZY0AvSsJfXOHAPQCNRbU0s3n2jGQ6+bkCjcyLaqpeqxypKdaSD5758mW3aw8wPi0DfPuNYWqrcLt35XDUKmXeBX/ZbehY4wAUdrlL+P6zF1kGO7hRhQWFQOvwaYCpuhw4A2J7k4v9JHCVQTNSs4pO5imAUG6f81dxjNciP2a8kbcpHkwN8/xaI0BZntWO+88jshJ70eiWLhizuxO1vfjgOKi++JTm+zahLwNGbwSk1vQGd7r9kI3hJzp8bZX1shCkJblww98Wmwf9jtS5/mNnBWxU8+yE/0ZZ7gBLlDtl3suUqYbGtNhfcoUKlUEaIhLndQ6vT0XZ9158ecnl89/2kk+qOjkA1GIXSwW0SmfZSmc5w7ABjCYwfY71loQF79S60+QkOuxw/uH5LkLlQtYKbHMvRZ/+r7flrifv1MphWl9E8J5SWCaC4LMEDEbxsjnssr5huatge0GHIitpzd6DcPVMKOs7k9LiXRl/1xBanGnnNM9IMLJcMkInUk6KIcV+6PfFZvwrbNnUTRwr
 oAH56sgW
 CoPMlJf1KjB9LqRX5Zrp2zY0dK7JHik6ZH7kaXccQgAgNoR/jmCfz7AmYa9ICccchDcECv09vjyhyNvUnkL+/h5MTDprCeycjHeHUa0iFjuTsqjBd1X1IVoyXAkGbnuPVC/o9AtT4mdYxViiPwa9L1Wi0Y+wNIt2VmWnjq19qJCOm2yJZKExfCNUT3DamoR/RE7X/RyHXTrYKx+7NZpQ/UkBoaEWeHbqa+4Gw1vD2wxA7IJ+r00B2PNjrNcsv0ICi0lhFzD34OTYWqpy32cclgQLybYJF3jjHQJa3kgjcUdcJB+dA4tgNus2O3BasL7PfBsHbLAmUmBHdEy5xY6BNkYiZQWQss4Z2NqOL/W5ldSfNsOw7T/vazyxRLeNP10j0XSIpSsOxZN/4nKk+YIq4acWGJw5kzs5uS0AOUy0bIgIrCGNIDJYdreqg+vtSAW6B5uzVfCGbyTd9fTuvo21uWlrzQ7hqeW30YWLTotQxFsPhi8joBeyCeTq8UN99vEet9f4+i1P3PNX4zA315RwR2epMtW3zn1e7IGkZjkv0FpB0tLoBPa4j7pU4MSxt30Hawh+7ChvqSdRVAFZmf48zYVxnwtQfb0nUxukprt2QPpm+E/QHAt6XdkXIzUrnSCTPVD7N6Wha8Zt7yZH5WZEu5TSi7KLEkefvySBR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/9/21 10:28, Zi Yan wrote:
> erofs needs to traverse readahead folios in reverse order to achieve
> maximum performance by
> 1. reading all folios from readahead_folio();
> 2. storing the prior folio pointer in folio->private;
> 3. traverse from the last folio to the first one.
> 
> Add readahead_folio_last() to achieve the same function without using
> folio->private. __readahead_advance() helper shares readahead_control
> adjustment code among __readahead_folio(), readahead_folio_last(), and
> __readahead_batch() by checking new private member, _forward, of
> readahead_control.
> 
> It prepares for a future commit that replaces PG_private checks with
> !folio->private checks. After switching the checks, erofs's use of
> folio->private without bumping folio refcount can cause unexpected
> outcomes, e.g., in filemap_release_folio(), try_to_free_buffers() becomes
> reachable.
> 
> No functional change intended.
> 
> Assisted-by: LLM
> To: Gao Xiang <xiang@kernel.org>
> To: Chao Yu <chao@kernel.org>
> To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> To: Jan Kara <jack@suse.cz>
> Cc: Yue Hu <zbestahu@gmail.com>
> Cc: Jeffle Xu <jefflexu@linux.alibaba.com>
> Cc: Sandeep Dhavale <dhavale@google.com>
> Cc: Hongbo Li <hongbohbli@tencent.com>
> Cc: Chunhai Guo <guochunhai@vivo.com>
> Cc: linux-erofs@lists.ozlabs.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-fsdevel@vger.kernel.org
> Cc: linux-mm@kvack.org
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---

Nothing jumped out at me, feel free to add:

Reviewed-by: Lance Yang <lance.yang@linux.dev>

