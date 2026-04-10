Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CC1CF459E5
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 22:11:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FA2F6B0089; Fri, 10 Apr 2026 18:11:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D2446B008A; Fri, 10 Apr 2026 18:11:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E7E56B0092; Fri, 10 Apr 2026 18:11:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 601E66B0089
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 18:11:39 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 212891401A3
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 22:11:39 +0000 (UTC)
X-FDA: 84644043918.26.F7E3B3B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 65F95180008
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 22:11:37 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=O0UosEhb;
	spf=pass (imf24.hostedemail.com: domain of dgc@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dgc@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775859097;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aEKxRds2gv9nUcHds3kAu8Ord4mdUMqS/yDW0rbJ/Ls=;
	b=mHTMYzD12BFgqkNMbvg7lGmzD80MQQHpoLT51i6Md+383sZSVn3iyN5h/utlyVNzgYUUvm
	Q7OytMHAOhBq63UJevd1CmjVTBsQeUisuZlJJS6Xywf6nKzK1NLCPa+A9xb2fNdF1G9PKC
	jDdiloJSrQIJshP8BnKNT1b8GD8u1qM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775859097; a=rsa-sha256;
	cv=none;
	b=nkHXlrFMou+2sGVhetMQRw0QPIn2SNxcKOZpT/mUdyYGI+6mk0efK4yRZaCs/HM7VbT5Kk
	0aEGyZGGr6Uv1yk3KnghbzMV5wDkwCqQhI6UiSZ3tHkaM4QC7yrqlAPxohKshk8Net2Hxw
	MdNahFj+3Iri9+30YN7vcJuvaHp+ptw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=O0UosEhb;
	spf=pass (imf24.hostedemail.com: domain of dgc@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dgc@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 25BE243EF7;
	Fri, 10 Apr 2026 22:11:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E95A7C19421;
	Fri, 10 Apr 2026 22:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775859096;
	bh=TD1pp2xHcOkkxrulkbwy4Mz16Cdc52MMGL5vPeTdYro=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=O0UosEhbQqlCe7BDoVNDV3AAplB6buy82yLtBbVNnnDFVUUmLlktsZGxSpAoXukfp
	 wg1EIi9X11ZYxQzJt+naoFnVDbC8YqcVZc5uyk6Lg4jGRboGTOl0xyYiBcfKSiXrSX
	 i8INWnE/Lr/xlyPLe4tg9PR00Z6MKMbbRAguYJEgxGJMFQDd8umIhR7xsUkrC/ckqI
	 4kCoTEqkNhYcllyJ7ox0GBi8C17YtPK56RfylOTPVuWtaipiKEoorhZeOTt4dHuWi0
	 6QF5oGJStzdnDSv6MuqFkn3Evysc8l/uOygH1vfAc8tuVOPFHMm/bhALTHFkYrjjvC
	 tYHcWc5zFAfGQ==
Date: Sat, 11 Apr 2026 08:11:22 +1000
From: Dave Chinner <dgc@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Tal Zussman <tz2294@columbia.edu>, Jens Axboe <axboe@kernel.dk>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>, Bart Van Assche <bvanassche@acm.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 8/8] RFC: use a TASK_FIFO kthread for read completion
 support
Message-ID: <adl1iqhldFvJwSw-@dread>
References: <20260409160243.1008358-1-hch@lst.de>
 <20260409160243.1008358-9-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260409160243.1008358-9-hch@lst.de>
X-Rspamd-Queue-Id: 65F95180008
X-Stat-Signature: 77xdx7i5k3zy6ckkgcfoo449beuyo5n1
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775859097-100016
X-HE-Meta: U2FsdGVkX1+1WqP2tMhwpg7ZvV7BtKkIgIYSLN0kwBWF+NqQFYj2Ycs7WOc/IDJG2L0NcCnlJAPIJOfwo+KQqN30TRfmnDbLxBfWjTTVKy++5nkjrXbtUUqhHvhgZuFfoXU2Nn2xa5V95kb1/ICkNCUGtu1AHSol6T6kz5tLV2hNgf3zY57V1f9lVvfCcS1S7mFLaz5SCIJYkrEWatSbPhKGXrnwbPEUXr+BWx+X5un4Z6znBZZ0rcxcu+j78Lm7+mMTk7sX0AH9nVunVgWfT+s+NKHwxc/vbdJrlq5lHnsSi/w8tamM2jbRgyBue+3o5aS8heL1qtHpxdRkSLzSu5tAEk705cDS1SkvJqCHdJAQZOsDutuVH+PfZvGBbIo2wpecvvaBPProCtUHoKA1mFLqXfaqIEkQlQlTzG+X3WKyzEB6E0iMpGSuPjCo4qo2j0DYgx31+pY2w0KG9dBOYYQLkPexnOOwgX3+Sk8oKFv44y7hk7qshpih08jSMbweBUFXchICLyQcjpjY6z9NejyHbs52xXvKmiD5OI0NmLjc4sU0H04/2vSqWPBCjaHxM2Yq/SOwF7T1FgDEO0xDtnBtONF6mXkGC9KdMSfxUEjwFHUX67Fv4bAPEXmupimzgWeMcm7PCKHth5LAAARObNy/6J+eGlxLrc9IM25j4i5slIHBTt8xFJSIUWFrycqaubgNNmKSkp5rJfSo9M/tZv9FMt0b1uclYYEQ+8Ni5WNXSzkiLt6z6vBsgWqS3eBD1DwcIFuapcUaCEU1PPxryDmZowe6nlW36UJHcUcAENZvYALTUgnTEIP4LIZBaioKwyvTCNdS1Rylowg9GcIgWfdPQml+re65aCSWhVsikSuSDziuOXPq1C3oVFXOv4Z7VWQQ1ASNgsr/Rr+9FvBgBTTuYedOhOWurVI6lAkIM/1+dgxix6DKh9FjdHzPP+pTpunrbqi1d3HZEm3FRJz
 Ph3J3IBN
 WApwsniRtDfegs/231h6w2hr5IfgQblCU+Zqxk+M6pZhi3PuAKElOwGnNKwKesoaPv6WrcA0gwR7UZpIpufpCMkmVjS53JFy7WycQuBQN6o8pQ/xvnWok7KheBFc1dxaKhhw/XfDhBxykrrOYwfIvsGaGmAacKVk3fIb8IyR2RNduk1YeG9HfZugG2IviPIwpvNd7JfRoWuPxTWJFLIitq/QwhRFHRk5fwHlznymqOl6vDBklYp3KuMUemjFVLNclkG9gd5hNV655Cb6D4hphEv7gxKzJZIOQJbYIwSAsoOMM/mBAKMjKsq6el5ffGqv09Vma
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 09, 2026 at 06:02:21PM +0200, Christoph Hellwig wrote:
> Commit 3fffb589b9a6 ("erofs: add per-cpu threads for decompression as an
> option") explains why workqueue aren't great for low-latency completion
> handling.  Switch to a per-cpu kthread to handle it instead.  This code
> is based on the erofs code in the above commit, but further simplified
> by directly using a kthread instead of a kthread_work.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Can we please not go back to the (bad) old days of individual
subsystems needing their own set of per-cpu kernel tasks just
sitting around idle most of of the time?  The whole point of the
workqueue infrastructure was to get rid of this widely repeated
anti-pattern.

If there's a latency problem with workqueue scheduling, then we
should be fixing that problem rather than working around it in every
subsystem that thinkgs it has a workqueue scheduling latency
issue...

-Dave.

-- 
Dave Chinner
dgc@kernel.org

