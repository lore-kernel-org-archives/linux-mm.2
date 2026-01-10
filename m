Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F315D277D0
	for <linux-mm@archiver.kernel.org>; Sat, 10 Jan 2026 05:56:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CCB36B0088; Sat, 10 Jan 2026 00:56:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87AD16B0089; Sat, 10 Jan 2026 00:56:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 787056B008A; Sat, 10 Jan 2026 00:56:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6373C6B0088
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 00:56:42 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0CC151AB69A
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 05:56:42 +0000 (UTC)
X-FDA: 84314995044.15.3AEDB84
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf09.hostedemail.com (Postfix) with ESMTP id 666BF14000E
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 05:56:40 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Z1TbNG9C;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf09.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768024600; a=rsa-sha256;
	cv=none;
	b=5/pxD90bNfFLJSl4/2dDj8euf5bZu8PuxJpXl+aVchb4S+JDdPus3u71Ob9GTZHdQI+Dms
	s4FGqJtZEkPDWYPWF7p9SaVCAp/OiG5i0Dj126ysxuuQroLX9/Ol8F9gra78/d6eLIqGiP
	ZnEbUDFo5Rpl0I77NwYzrClygfwZ5i0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Z1TbNG9C;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf09.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768024600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KLe+Mi/b7dOgrP38Ir+vp2S6Iyfk5DV6D4CfuAf7BPM=;
	b=5NbSHxhMThSL8K+8lc7QSxcT3ebz32ayicV1Ow5XmrIq2G5F9HVYJOtldtxl1ROT6etUvz
	ssXs9btBkRxPlrwEjFtyaKGFX0qBE0ji3lPIHnlv4SWdYxM/i8j5pIAGhQevhqO8v1mRXy
	aQpQpTZVGYnoLedeklA1oa+oqrtn5i4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=KLe+Mi/b7dOgrP38Ir+vp2S6Iyfk5DV6D4CfuAf7BPM=; b=Z1TbNG9CpTxcy6DpAY+80uBkMJ
	AsYaVD7oqKSOXgE9NsGc/405ZZAEWccRkgPIM/deRvYGRjqq2ZKGmKUQDJ94rtuq+PTCf6cC6JU+G
	EtpsNOMu4blF5yhEFYkUsWjr/ce4Hr2UcqUA9KO85CWp/SEBL0yekBMWb7bDmTGzLQMgFTEnhIGpR
	L5EUlII81UnD3//exZRW357uOOQfKLvTaRZalC+1KGGmolgW2VriezGI+KbtU97nVh083tYH/sCxA
	hKwrsZOTuy7PwJs7L6p0636nIl54WecZGYTDUj1RoC24hSBA6pmsnO/zXCU78yVrYNBvBFvYsuZJq
	JZbZhzzg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1veRxl-00000000HUR-0L0v;
	Sat, 10 Jan 2026 05:56:37 +0000
Date: Sat, 10 Jan 2026 05:56:36 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: Re: [PATCH v3 1/3] btrfs: use bdev_rw_virt() to read and scratch the
 disk super block
Message-ID: <aWHqFJfzD9QeaKkS@casper.infradead.org>
References: <cover.1768017091.git.wqu@suse.com>
 <829db7e054cd290b5aed0b337cd219da128ac0e7.1768017091.git.wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <829db7e054cd290b5aed0b337cd219da128ac0e7.1768017091.git.wqu@suse.com>
X-Rspam-User: 
X-Stat-Signature: d1bnm7dbrdspe6rjrodjk1wy5gbgogjj
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 666BF14000E
X-HE-Tag: 1768024600-569397
X-HE-Meta: U2FsdGVkX1+whM8PbKwsgzjCGqLqNeCCeIY3BfoWPiDrCF8M39ljsfw7NSgauKYd5UQ81U1wfbOp97H9k6h18QTBQJpdnRoScPhBdO6J7wbcAA3y2IXE9/UfIzrS+MFntdTSp/NlRGVg0RDQSnfJhqNOhHVjxbW3AntIQ2zTV9Mk/uT7eEBmTQwWSUIFUX5EnYCdBqjOAiehQLCC0zni8+QASpX40Xu4Pr0D9QUJoPASW9HntpT/MOo9t9rdE1hrMvPI93j28Xo03x/pqgNALlgHOKg5+tRsWWitLPkhOV91oi1GPTbu3RvHvrWGl7Y1O+Fi3aTueXBX3naMQBZpQ94LgUvxPsorScRIRNSbZkwCTl9f6HCF7w1XpmeE/EhvT3bCJZa0XbID1p8n3tbsQlZHhspfgsXXyCnw1ndSuVX3jf4gOgs/JYolc4JecqcK1c41YjMkXm2f4es1ZIHzgNRE0Uk0gF7otxE2YzppdcPcs4HJXpL/09hZS4MR6obsdL12LAHaGZmlq4sK9aguwKv3xTiFg/o8H0FAilfFgmBg/cNC/0mO1tgjfbKzAbPLiWYk/yzeSMy/f79TQKMt3Rx3c0IuQoZkNTFuzO90AVepo3KdZKOd39JC2eYQIy9bYePgTg1Nl8Ds9P4HAenwD5hio5HVkO4uJxhaJZVJoid3oBOk6lqBWobxGWALmfPzJdognu40io7cersOImm7lv4wk2mYY33pIXBNS0txKRGxfGh6Cu9QkRQvj5CgbbMiwrlKismH79TalVATHEQ8MhV/kEzG9POSFz/xNPxyek3kJ4Q2S76FoshrlcKsWbAx+Rx0Cg4DoBWoBBBP/5HwYUux9X+ZuOG/bYKxg1sOLm1PX9NS+YxYgl2hzjtg2fzlZJD095Ac1Cg0UwGdJ6s5R4EWS+12BnvhM5bNtsWCHyGiODvwqp3RYcIQS4jfZ5E2bhYTywL2lHvtOzRxmmK
 xR3jC9Sk
 JnpQv6HQwobLiOQ53I0mnpN6ipIYjYao1JucG4XV5ItbeoedGwcNuN4TkDfQlLCpoA9kNaohK16QNpX2rEMKxVabrKxM/IHPW7XHwLCU5cs3tlA7/m4eo9EjzfKvMNcJWf9uHipdCWiGcwm0mpLgyZJSU5ZiwMbhLkEkoU237DrX83sv3vMXDyO0YAOoQx59jJPLZCnWlTbicXOMfgRL4Qj2hTCXZzHyKPL1g8f0v44+0fNSoY8ep1Pmdh3x7RNqDj7mBgIIdlX5LoDXFalEnG5q9L39qVctgg8sQERldJ/Bb5pc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jan 10, 2026 at 02:26:19PM +1030, Qu Wenruo wrote:
> Furthermore read_cache_page*() can race with device block size setting,
> thus requires extra locking.

What?  There's supposed to be sufficient locking to prevent this.
Is there a bug report I can look at?

