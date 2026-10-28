Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C764606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 03:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Pu9NKXB1
Received: by kanga.kvack.org (Postfix)
	id 253BC6B095B; Tue, 27 Oct 2026 23:02:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 204376B095D; Tue, 27 Oct 2026 23:02:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11B016B095E; Tue, 27 Oct 2026 23:02:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DF2796B095B
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 23:02:40 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7D0A51A0B2F
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 03:02:40 +0000 (UTC)
X-FDA: 85370537280.23.9AA56EA
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	by imf10.hostedemail.com (Postfix) with ESMTP id 9AA2FC0003
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 03:02:37 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Pu9NKXB1;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf10.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793156558;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qcEzChDALBrZBXlc8c36RbFS5xKsTCpeOz2BY/FdvFU=;
	b=Eb89iIJ/iOJzzS3hPsxxmG6K4KoBAiRQPOL9tyh8WxBRGXpVafWoDBVi8dux96VeCFxpiM
	5MZqeNPXjFplUmT1yJvUjJjxMvV7NFi0+6aIuc7aIEmsSe8QUddi/vXCaio6sgCcDwoblV
	xeOBxi4UCZmWtF+wYyYzl2nKbLuHIss=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Pu9NKXB1;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf10.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793156558;
	b=r/S+G8WeT9eas06RznZI4ao4UI8ljj5bSG2K5glRBLK2v4zOHtVKg1uueL2IMvGoVLVMkH
	SkWlIJ4pBDB03xRYptI+WeajqB7d7QAjERMSIWthToD6eT/k2ONuyDmy5rd33tqt1glTEx
	rni0U5isc/2DzDuq3P9Wy3SDNFclT34=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793156555; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=qcEzChDALBrZBXlc8c36RbFS5xKsTCpeOz2BY/FdvFU=;
	b=Pu9NKXB1sE0aG6/VWwzzQhXzufISp9c/FDNhQKH97nsi7MHV6vqtl4K/qvTck2dpXua40XfuDrAzaz92N7Rl1JWCQnvwA6NGjt6HEWYeXgZ47uJP8C27B5rxqpYX16GoNu/hq+pJI1yT3A0l3QIt8AZWGJmjUpWj+DIUOD8TWXY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R311e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0XDfWWsR_1793156553;
Received: from 30.74.144.137(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XDfWWsR_1793156553 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 28 Oct 2026 11:02:33 +0800
Message-ID: <4d32bebe-1a00-475c-8320-b303693603fd@linux.alibaba.com>
Date: Wed, 28 Oct 2026 11:02:32 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] shmem: skip empty unmap ranges when punching holes
To: Hungyu Lin <dennylin0707@gmail.com>, hughd@google.com
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20261027171753.1485-1-dennylin0707@gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20261027171753.1485-1-dennylin0707@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9AA2FC0003
X-Stat-Signature: ebfs433ijy6nn68cy4oio657b6inhmsu
X-Spam-Status: No, score=-19.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793156557-837325
X-HE-Meta: U2FsdGVkX18+pVDkP4TOkvNTuLUaXvGL6kNuA1DbYVWlxOqLPqEs7UW4l0Aowgk92hR1Ln3X1mktcGxn31upFPu3J9obd/cEsf3UGBz8SI4tRrIrcPqYg0pdkg3qlVe40lgpv/D+VQLE5MRnyLDHqd0CSK5SyR60xo2ydy7v0WM+7vagq0H4tM1xWT/pxjbAIFmpgo1+ITBMSMmTRCRpWnqeF4ztioXy/ya0NRfHucUMTykJOHiCvbjh/VsvfjtFyuscIjbi/igRZJ7Ybph4RHutaB9tBUh5WdjWiZFOwY6nzn2VpFEornomruO/YiyN1TNDt1E95zM4JqNlH2XUsv3KK+gRlPbzCAkHuRi33vokGyVNcINHd1+mFbeQIFTe1cXJgnsKp/RH5vpxs1lAGE920NK1lMwuU06890bz1swqVkDYgjyydyRIyy6uLGCE+aNuca3/GbOb3qnoocBzA7+ZrcsLrEqChhO8KNkViXMeMxFndb7zdhnB55TLFnSULVpCTNFn4l3NzUpED0Jhcvk54Srm9ztm39Q8dMGWoPsKtJKbmBm2OIUFPMOpJ4Cw/dk8+jZtID3ecPRpr59Sc9IqiT/5vp7ie0NsUa7Wrgah/wran2ZZfO0AfjN/L+xT4EAqUhDISB6vAvOTWCPS1slVZtMYETUskECqzKc21ONJjr6Nbu7Sfz1VCxmBTgURlMKzSjnygC0wpDt95ZOU0LCgXDuNW26mcLDpANBN2a0OF274muD3dks5WfBjdMZQqieQ45LxJLyzS5DEz+/OY0BIE7dUEczB0ux0RiEUCGdSnGVNDoxRk/5RRtQBcJY/vpRS0Qq9qeuFhY4DXLtvVi1QXssYRxGB17rx8OYI9eW6VZgr9uod/7eKwWmS0H62h0/eAbXRJ0TYher+wPIXo4OQ+61KnRW8QasdrfhaeruJag2dXoByBqCQB/FupRriNals32tOS5iTVs+clxm
 RdrPORDu
 mD17gvJRT3N/dLqg09hWpr6OGtFr2ev8sKPeew2dcOPdy+WFVPSL26RJAq/8lA+vTZrblo1FAv91v7nHCihHt1sXsysNgvE+SQMGwhiOmfMKcksAr9r6OdAxgGj7fL4oIVu4wCrkwhI7RYHUqfg8oci+J3xX7f8NzIiEpMf9Y2FGy1paUg8qWWLnD0m7r2G8+eHxetqyOGoAN5BcU0q4nXHlA2om1DQo1xoEaDkR1bP9aAw6LccMjbnBkfz3TsmB80j5oBOk91vu62pKvQKP1Oymh2bS/66DgfBVJa9JsEcrXEs8MeNOTA4rtMj7eYvxGE3Y4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/28/26 1:17 AM, Hungyu Lin wrote:
> When a hole ends within the first page, shmem_fallocate() calculates
> unmap_end as -1. Casting it to u64 makes the range check succeed even
> though the hole contains no complete pages.
> 
> For example, punching one byte at offset zero calls unmap_mapping_range()
> with a zero length, which means unmap to the end of the file. The file
> contents are preserved outside the hole, but unrelated mappings are
> removed and must fault back in. This can be reproduced with fallocate -p
> -o 0 -l 1 on a mapped tmpfs file.
> 
> Compare the exclusive rounded end against the rounded start to skip
> empty ranges. Keep the unsigned comparison so rounding the start near
> the maximum file offset continues to be handled correctly.
> 
> Fixes: 83e4fa9c16e4 ("tmpfs: support fallocate FALLOC_FL_PUNCH_HOLE")
> Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

