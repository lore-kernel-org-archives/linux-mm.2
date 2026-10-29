Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09B25606A322
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 06:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=gQ7SPPtI
Received: by kanga.kvack.org (Postfix)
	id 229886B05B1; Thu, 29 Oct 2026 02:04:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D96A6B05B2; Thu, 29 Oct 2026 02:04:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F1B96B05B4; Thu, 29 Oct 2026 02:04:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DC34A6B05B1
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 02:04:57 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4A1DE1402C8
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 06:04:57 +0000 (UTC)
X-FDA: 85374625434.08.617C71F
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf18.hostedemail.com (Postfix) with ESMTP id 38F371C0002
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 06:04:50 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=gQ7SPPtI;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf18.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793253893;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o5W+Zg0rKLU9ViJ7Akn7TYVqUItF04jnCP8SftoaDZs=;
	b=5s/p9n8ReUKTbt1Zs0hu4WbkOUbgbBQogZhSyF+/5XvbY5/OcMix/ea6uJMP9KKlN68r+7
	OEGaF4sf1a5Zn+l9XBmjyf+95+6mouHgTu/v1QhG5LvlC0mia9Mylt+Hhta01Out3RKvh0
	Ig66/XgWVbNariUyBit/VvUjpKplUWI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=gQ7SPPtI;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf18.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793253893;
	b=v57GyUO11OcNnV6Rn99zjrZwFAgcuK4BtKqORnohAnca7+u1Vguh1boMbYUtiAkHdfst/Z
	2wz2dY/LJ2XhIOZr3+rLTy02zQbboUE+tFv+vc0i8rfZRmDXRKxVgYTY2a4YJomvYBeviv
	GnGn3yl8wSoi2tmnX3kPBnhmsANuqMs=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793253887; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=o5W+Zg0rKLU9ViJ7Akn7TYVqUItF04jnCP8SftoaDZs=;
	b=gQ7SPPtIAo+rqL1sg+dc4Sc5xynleCWDE3Y4KkzUO9cjM64XLdeG8Ea89qh5ubXzE82+ZPIDjvvdAxVn/BFPyKvKOMTUahoQwU9PVLTE2tpqPxtDSFQUkSS0PL4piku80JyQpxAPy4BYPOcZQ1quJJZIFb0JByLw5eVhnQ9SH7E=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R611e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=20;SR=0;TI=SMTPD_---0XDiZY8B_1793253884;
Received: from 30.74.144.149(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XDiZY8B_1793253884 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 29 Oct 2026 14:04:45 +0800
Message-ID: <6e0968e0-e061-46a4-a7c4-be27aad91827@linux.alibaba.com>
Date: Thu, 29 Oct 2026 14:04:43 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] khugepaged: fix readahead lock inversion in
 collapse_file()
To: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org
Cc: david@kernel.org, ziy@nvidia.com, liam@infradead.org,
 nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, usama.arif@linux.dev, kas@kernel.org, jack@suse.cz,
 djwong@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 hch@lst.de, pfalcato@suse.de, ngocthang2710.1999@gmail.com,
 syzbot+16bf7cd0ebeb1de93aa5@syzkaller.appspotmail.com, stable@vger.kernel.org
References: <20261026152013.10511-1-lance.yang@linux.dev>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20261026152013.10511-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 38F371C0002
X-Stat-Signature: ccj43xb5ghuo71juny7h58xua56ue9bo
X-Spam-Status: No, score=-19.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793253890-140806
X-HE-Meta: U2FsdGVkX1+R+jMlET5/iGq5ywHUAzcmoUkC6/mffqP9I0SKaoZ/yAnjsgW6c1oXJmAc8DyJ/Zb5IRRIWvYXlsc3MMKgbPcBDN+6j8b3m1YxydB5j1vvthCQbgssXThJ9iNc5L4Q35yi0icir0/5v0YtKPlf6iwVM6GWU1iTzt5unDMl4aWDb5/vvhjA4NRS9SSKzXZmPtWwvMX+oicj9GHqm/TkTdPlq6jD7o2uQ1SIhO/r4Nu4gDz7dRv505TtWX5kfApMD9jj4Y4aEoBWe9oVuuH20OSyOaS4xvuq7RiXc6V3u3LDnGDHqT1DT3y2vyxc0iVn6B6p/St844bx8TJon34JBOX3Ub0J61V/O0u9vBEdYNaGvzshZFpmnoeDAXyQ5775nlwFQb+aHqk+qk8d7+WaE7GOj+ZacUfN3Y0uq2Mji/R7jzJARCt9hC1efmHyjymcHs39eSeU8icnvCQn6ry5+2+DKnO1UpOa92ASyFJyfBOM6tng7kgtUPwqYx5Kt5/b4sUrYhOZJ/v+5ntxSmp4a7xeKdYPg+38qkYef8BbW2K68xWu6h0zo3FpCVZfmwwLOyxhpLMb6a7vPj8nDryoHF7ebIUJlloqt6oISdjLjcPVzgCFJcHV2rTggYI8Qcxcf9U1kt/GyzhdE14lmrBgpJI2vpamPXX5Oamp4P6Ic0nz1hecgrtbXx/3hf0dTtQCXxxGPRd78Z7KKN0KYmuQNfzaeUXCxkCMO+OyGiNJgvAYmDY4sEqMs6+lyZYXlopCpTPWgeZzhrOH9brCRtrw7Q7+iiWTfuzYG11mi/m9iFET9R6F2h2d7YABABMHH66LREexa98Ytg0C161lyJlbYy5Y56ynamgNEw13w3nHAaAYz9/v0XIR7Kj9lruHKDU2TxAk5Vbfu7eGR2LwIn4k0XyMzCgBri4hJ+rH0QMgYTJnPaUZ4Mc/sjQEDr8EJEGUlWMle4iZinm
 omjjCYFc
 DIv0wFTLZ3JUnNjhPQXvPnufHBgsK0t33DD87byQj0m1UD5RcJlEo+kmLAKtyJLZFq0RohkqizyBaiOSf1qGs+MvmqTB5MP6aRLheA0MruBX0tLT3+n3MjkGmoXfeF6cI2AKaR94pb7QXeIDaYy06B2dftVzAqqWdpNbvdTbCz2DtgHEcu/kyK3MmZN1btxmWE0h6PLrEfP1+0OH3tfB14db4YmekLrtzL4sOlp/TEU3v9GU9nzuoU9pLBFx72PAkMPq+/jWsNpISFtZyTJERPii+ZqTl33RsfuCyI/AK2zSqaQVZsIjXaSHldiVV2XhUh6OMHxh69qopxCyGqW4WwKtsozMqHMnx21CFDW6c7TFo6e9TT1q89B1hyxr+EXfp59aWRATEFkicf8zxtXweEOjOVKxsdpF1Yto7ed4pnDsZa0YxaOHG9JtDJPVORUkA0JmbVBLYlKXc5foU2Oi2e4wvQZJvE6ogxzM3YkwyZi53utXSJfId+8xd/SSfPQlPiw4ky+zJMqz4UUJKHZ+DYHxbfvYSs1dXvNDjJAOzwjO8FEwkLTQR9sFBDsc2hc32ZYPs5WgeyfNt0nk1XkEVaw0sva9fIYw1zS3qagrh77v2P2Lxhb7nxTXZqg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/26/26 11:20 PM, Lance Yang wrote:
> collapse_file() can call page_cache_sync_readahead() while still holding
> source folios locked. If truncate holds mapping->invalidate_lock
> exclusively and waits for one of those folios, readahead waits for
> invalidate_lock and neither side can make progress.
> 
> We need to release those folio locks before starting readahead. On a page
> cache miss, roll back first, populate the collapse range, and retry once.
> Doing readahead after rollback avoids an extra pass when all folios are
> already present. If another miss occurs on retry, give up rather than keep
> retrying while truncate or reclaim removes folios.
> 
> Keep page_cache_sync_readahead() and wait for read I/O with
> filemap_lock_folio(), releasing each folio before moving to the next. The
> existing uptodate check during collapse still handles read errors.
> 
> Shmem uses shmem_get_folio() for swapin and fallocated folios without
> taking mapping->invalidate_lock, so it is unaffected.
> 
> Reported-by: syzbot+16bf7cd0ebeb1de93aa5@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=16bf7cd0ebeb1de93aa5
> Fixes: 730633f0b7f9 ("mm: Protect operations adding pages to page cache with invalidate_lock")
> Cc: stable@vger.kernel.org
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> ---

Thanks. I'm fine with followups to clean up the code.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

