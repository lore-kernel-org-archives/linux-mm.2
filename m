Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 777D8606A331
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 02:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=tN54d4fE
Received: by kanga.kvack.org (Postfix)
	id 6A39E6B05B3; Sun,  8 Nov 2026 21:54:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 654C46B05B4; Sun,  8 Nov 2026 21:54:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56A156B05B5; Sun,  8 Nov 2026 21:54:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3211D6B05B3
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 21:54:33 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9BE8A80279
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 02:54:32 +0000 (UTC)
X-FDA: 85414062384.28.C4588A8
Received: from mta1.migadu.com (out-137.mta1.migadu.com [95.215.58.137])
	by imf16.hostedemail.com (Postfix) with ESMTP id 932FF180002
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 02:54:30 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tN54d4fE;
	spf=pass (imf16.hostedemail.com: domain of mengmeng.zhao@linux.dev designates 95.215.58.137 as permitted sender) smtp.mailfrom=mengmeng.zhao@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794192871;
	b=O3DVRg9AC/FRBzAWjfuLchWlwo02EjE1CvQRkudUfKe55NB06gCfx3qEDGlrruYCcDFaYQ
	hPIAvBs/Pfh35N/WxdDaUfmjuAPR824sliMtqrYCkHgnbcrKxKmrxVDtiX6c+XskY1vAkx
	mS5AgBhMSCQptzTzlxF00syiIr+SzhU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tN54d4fE;
	spf=pass (imf16.hostedemail.com: domain of mengmeng.zhao@linux.dev designates 95.215.58.137 as permitted sender) smtp.mailfrom=mengmeng.zhao@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794192871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eoxX5hhnrVdnCsiEYxw4rUS1B0+rsEN339m2Nai3htg=;
	b=QzbMpGVHgmn09mGSSE8m2nLIrJmeL+l+qA236Yt3VMZq8yDfXe8cTzjdtDWMI79NEvOx2h
	o+nN+jdQshPlN/qmo6ytrapfVNXZj2FDw2U/fkloupPttnt2lga8e3DbRl6zePsmYhuF2L
	cf/c36YvMFMWcajXZBf0Xr7SIRwWPuw=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=8GZA7yXccoOl25ncF5WoFStP/OWge7+wGkdg+7Q22+4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794192869; v=1; x=1794797669;
 b=tN54d4fELbTw1iziAe++lO07fZ5SAh4ue1naK2/9LPEFWsB9OLEZ7IIGwvMwJvNf7ENjDX9l
 QF+x5znsrYZqBLXzHYLOEerlPhB46/CjWVcI55sfgyCGnVuArQb6b6zkWJJxnh0Q7RS+EamCd8D
 JxPzlZh1L1SF3JmB2gcgkYPc=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 197dc3b85a73d5c0;
	Mon, 09 Nov 2026 02:54:28 +0000
X-Mizu-Trace-ID: 197dc3b85a73d5c0
X-Migadu-Flow: FLOW_OUT
Message-ID: <e483fc86-9a7e-49a5-873c-b5fb32d01848@linux.dev>
Date: Mon, 9 Nov 2026 10:54:14 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 2/6] mm/filemap: refuse dmabuf iterators in the generic
 read/write copy paths
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Dan Williams <djbw@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, tytso@mit.edu,
 Andreas Dilger <adilger.kernel@dilger.ca>,
 Baokun Li <libaokun@linux.alibaba.com>, Ojaswin Mujoo
 <ojaswin@linux.ibm.com>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Zhang Yi <yi.zhang@huawei.com>, "Darrick J. Wong" <djwong@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, asml.silence@gmail.com,
 Anuj Gupta <anuj1072538@gmail.com>, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-ext4@vger.kernel.org,
 linux-xfs@vger.kernel.org, linux-mm@kvack.org, Li Wang <liwang@kylinos.cn>
References: <20261105065847.196540-1-mengmeng.zhao@linux.dev>
 <20261105065847.196540-3-mengmeng.zhao@linux.dev>
 <20261106104205.GB5668@lst.de>
From: Mengmeng Zhao <mengmeng.zhao@linux.dev>
In-Reply-To: <20261106104205.GB5668@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 6y714fzhrwrawyfwezrwfuzif6jp4j6c
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 932FF180002
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794192870-496789
X-HE-Meta: U2FsdGVkX1/nlT48lDcNeM1oSWU++aLxgp5PRvuALMjOG7BnmcdUXU5TCbSVSTHPW9cP1dJjYnZUNUcbM33kLiO2h3Ae7Pv1RwbDOSfTORmbLfVUGz11jfqGX7fXWuD5e6IhCD+VaFcBsVASxNh6IAeiBOL33tRgU3azZyT1dMmcSNvo5L2tYQWH5o7fY1T/VXTcBIFO7mLDYOkOkQLCH6cX2nbpif+UC+q4GhXh0XOQEFilEQJkoq2XUF5vpMO/2STIt+z+jKUxvNPMdD3ixTkGAKlhjmPlIPh4gNTdmDE0ATU1Wvt9EhOl5rBxsdPejt5iP37sWF12y3yXg2CDe9NsxhzRRmBoCLjTwqpEYMBcJ6vSNEVlFqSrMl+3YTbY8ZHawDIchKR1EPPpU5uvtunS7avvv3xjF1G1bYVQTGfXpQoYdROBK+9QU9u8srt3v9U4wWApSQq0dPLrEwaAa1ha/y0m4UgYupVSwQLyFrSJCcVA08tHxsG3RupfB9iuJcUggiMQ2z9wKhJIs1YNXjcQDn2f376L+AvMvldPcQig5O0XMT1SuyGkNwRmc+XKkigNax/ZbZLZ+UHlN4BGBmqqmlFl95OrX2lWDskSQ59qB6YVS+7d9TZl6FS3pHU3zbcIBfCBxMKb/rjgC/lYg+JA0oZ1CYhe6XV7E4IfoHl407lNXYzPdClg2fEdpDSqDnw8wspiO+IjQMPUcGRGeG12x4J8EqjiVSX7vI4XDdIG4Z0K/OAtunxYqBJGE7Hx7AsExiljwd7mSScU0h/C0sBlsmQklQ0hzuGpZmSqXVA/HSBojcS1lLjsxhmyYiVzgBgTSAlUivXUayZqmEMeiVLa4s2L0rEb1gA0A/NH78JfzqlLTHT6GYKiUfc3WqSNGkVPzEsaMNdpp/wHzPzNBljLYVepniiJqcP+BQ417EXjAaIRBQLDffkP8moOQtoKjsBpzV4OKwEoFtVNChY
 ldhWVA87
 VjbvvZYh69A2HBRZoe1cqxxCNJGTfq6TY232XPcmqL4NHaU2hYrc4NW6n8If5a2XITLcVByYxNtGhBbe0ZjdW9sNvvCcvN/mRn9QbsFxHBuTdMF6f+KpvvvCcYG6REIQ43U9xySAOpxP5xkEcqmufzLflxPUHPbhG0LJ8GxnkUTh8PQWPG8SoSbi0qlaYvifL0x5NdIa1Pj/zEmotYVGZ3RcU/XqL1I2DsSu6mfNoZUBw6Cu3pDTaQNV103dgPw4CLcQy4R7QL5KmIrmfXYn6UHYV+ANGZzmnRlSyI0fTsA/teFGKgor4dQwNGYYhYrkD4I1it3ZNsYctGyMA7wsBiIQIvUILk6GfqCYQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/6/26 18:42, Christoph Hellwig wrote:
> On Thu, Nov 05, 2026 at 02:58:43PM +0800, Mengmeng Zhao wrote:
>> From: Mengmeng Zhao <zhaomengmeng@kylinos.cn>
>>
>> The generic copy helpers cannot touch device memory.
> 
> Which generic copy helpers?  This doesn't seem to touch copy_file_range
> at all.
> 
Sorry for the inaccuracy, it refers to the buffered io patch in 
generic_file_read_iter() and __generic_file_write_uter().
>> Refuse a
>> dmabuf iterator in generic_perform_write() and the filemap_read()
>> fallback while keeping any direct-I/O progress, and report a busy
>> folio from generic_file_direct_write() as -EAGAIN instead of asking
>> for the buffered fallback such an iterator cannot take.
> 
> I suspect the fallback code in the callers might be a better stop
> for this.
> 

Ok, I will put it in the callers side.


