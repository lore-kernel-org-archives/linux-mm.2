Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1470CD4851
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 15:44:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 187116B009B; Wed, 13 May 2026 11:44:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15EE36B009D; Wed, 13 May 2026 11:44:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09B8C6B009E; Wed, 13 May 2026 11:44:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id ED9EF6B009B
	for <linux-mm@kvack.org>; Wed, 13 May 2026 11:44:47 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B703B1C00EA
	for <linux-mm@kvack.org>; Wed, 13 May 2026 15:44:47 +0000 (UTC)
X-FDA: 84762819414.23.E263AE1
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf26.hostedemail.com (Postfix) with ESMTP id D7075140006
	for <linux-mm@kvack.org>; Wed, 13 May 2026 15:44:45 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=N5BQM7on;
	spf=pass (imf26.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778687086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3KsIXS59mcRQeKKkkiOCaaEGicr+26hZlUrTN/qAN04=;
	b=RBDAcJ0B/VG+5QneQ1te+VzNj2PDs8RCwNpg8LJ1uaBlOvyzBB5JqfbmAy573pJuzZ3yNN
	s/g+Q+QxWl8dVBACcgtWJw2CVB3iorTw7fMD3CEoeeLrQU//toSS9AvNUmriOB4Ba1c2dj
	3DVaocWNqavCa/YQcKOJ9TDuTsw5LFo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=N5BQM7on;
	spf=pass (imf26.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778687086; a=rsa-sha256;
	cv=none;
	b=PMnNTbnFvbAi6t1+WlWX9HePHQAy42r2VA37kijZxAUMWhX7tWfUzuNTF0RA0y0D5E3Wyq
	bW4/mQMMqQRTlLniScp7r/0HRPd16LamG3rloQSsBCn/atKZCwpqSt7JcVwsGiNY160dWu
	3W0ZPpa4TxyFEmceF41EfR7VvC2Bc1s=
Date: Wed, 13 May 2026 23:44:38 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778687083;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3KsIXS59mcRQeKKkkiOCaaEGicr+26hZlUrTN/qAN04=;
	b=N5BQM7on2iiq0um5dJyQqdxAF7ykEfIe15906gaSbLXPxajxlPdkwxyYcWqyAWf2miM2zx
	zvm9NFopmF1DRgVbBST2Oh20J8F9AfT5kxrDQ8DdEH2HttYcfitfJtRqWA5jVc7FuCoTZb
	FCoIeVagzKMMBdNt3J8VkmgFSItKCxI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Baoquan He <baoquan.he@linux.dev>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org,
	usama.arif@linux.dev, baohua@kernel.org, kasong@tencent.com,
	nphamcs@gmail.com, shikemeng@huaweicloud.com, youngjun.park@lge.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 3/3] mm/swap_io.c: rename swap_writepage_* to
 swap_write_folio_*
Message-ID: <agScZgsBgL-WRAac@MiWiFi-R3L-srv>
References: <20260512104201.716213-1-baoquan.he@linux.dev>
 <20260512104201.716213-4-baoquan.he@linux.dev>
 <agQNzhC_m9zvqBUa@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <agQNzhC_m9zvqBUa@infradead.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D7075140006
X-Rspam-User: 
X-Stat-Signature: urhf4u9unmkt4kjnu3mid3o86sdrr5as
X-HE-Tag: 1778687085-846682
X-HE-Meta: U2FsdGVkX1+M6GCJdenKm0Cw1X/5ivG85Ab5zI12W5mSGvqumxYd2tkKYuEqfygF6ewykQdLY0mIGf71mjEkjtL3guq2z2HTwhoHu/yvCOcnuGOm/keuf9o0TncBlLpOC2FtQpA0dF7RERkb/WiwWJFTRtb4r0y7yYRJJJ0ijUSmQmw4vMusn+H0fm90D+/2h+hlsfQ1rvuNb2He6DdMWzQ7VKJjS2YV32KdCuzEc4Fk1paREya2CS1UCWv6b5tnlO87+8LeRYe7JI0tCUvGmvXkscdt6XnfODgSKUnZjEgzfM4/yWJLBhw3p8CPUzKhi9CWviEJLpUSQfZMqko+fk4+d/fJx6+7u1zjpvaOPQy6Z5jRY0DFJbiUZWKwTHdnJ0mUbr910svaoWicSd3WeUPJKko4NG5xL1rsi67HbfCf94iA5T2AeMeTepF3cf+lU2DRLsqDCpI4Hj7/8nO1pylcIHETN4PEtxsSyEktYmVUXEJ9vdlICrP5Vu2NkLn9PjrLhfXrYuLzi6e6TWhYPEnQF5kjmhSaSgYkHr3wVl2lNheiFef9EB/iOXoDNcGSbh1A1L/VAMKyGqGNckIAiCxChsufK88wi0hjPhZl76b9fz4iV1gC4a8nrJGMWF7LtLmtFxEHJmRXAtrloS7gnahbxipGgmcX0aSyQKJQBy/Mk105cVMYyiUnx4poSKdCfAwaTzSBfObyCvZa5IW3I5Aq7Q4LMLOwx3fr92lFdcWlBAAnODLaobTHptNqPWVr+WN0tyTE8cGiTzuEfXxpSb4SuopEROoOEjI0WIY1223ABkx/fEkZpNnMZM8tJXTvgtCaN/d+ryj/kaCe/0LVapdQazHa7om+zCi+BdLIzy8F4OMvWlofua0xsXfpa8igyK4b/dW50JdaDFU+VXX62wf6QQw5Bdam5W9zUFJT4/83mcbQDsO0oj24vwk3LGdehSM+ge5WUdSIosleS+V
 6Ma9pEwe
 6viEbH8WrFWsZW3UP1jY5kVTFNvyO6P4BVU7rR2/ESjdIPfqI0BfKDo6CZAN5w9FshSYT9smx6DY1NW8wDqDeX8NgUYRZmmE50iHqE6JbGwN557C0LI3ZXlLXoFwXSnXB4ZADV5Eubz5EgsKqdjY/5sZVfIY7rhE+RVBpSZ1xWIVZa8hFX2x5N/tqFcHGdhMvB3tYtb90HepGUGtrD8LUbkccN2H2kFf7xfY/EgYm0JT+fGTLIaVfMbbg30oKO0uGOopYGsjaUWdFk+EaGqZXJ7TRmJAx8HNWyJwqZtMXVz+nl+M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05/12/26 at 10:36pm, Christoph Hellwig wrote:
> >  
> >  static const struct swap_ops bdev_fs_swap_ops = {
> >  	.read_folio = swap_read_folio_fs,
> > -	.write_folio = swap_writepage_fs,
> > +	.write_folio = swap_write_folio_fs,
> >  };
> 
> The convention for method naming is prefix##method_name, i.e.
> swap_fs_read_folio, swap_fs_write_folio, swap_bdev_sync_read_folios,
> etc.

To me _fs is a modifier to qualify the method type. If need change, we
may need change all swap_readxxx_fs/bdev_sync/bdev_async and swap_writexxx
likewise.


