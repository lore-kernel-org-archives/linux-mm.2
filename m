Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB17B10BA426
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 06:27:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48AD06B0005; Fri, 27 Mar 2026 02:27:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 414C26B00A9; Fri, 27 Mar 2026 02:27:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DD316B00AE; Fri, 27 Mar 2026 02:27:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 155D66B0005
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:27:26 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B8579E15F8
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 06:27:25 +0000 (UTC)
X-FDA: 84590861250.22.C9BF59C
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf08.hostedemail.com (Postfix) with ESMTP id 1B270160003
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 06:27:23 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=3ozzZMNI;
	spf=none (imf08.hostedemail.com: domain of BATV+7b1de7ca9b09bfe890a7+8251+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+7b1de7ca9b09bfe890a7+8251+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774592844;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G7w/DjtHh6UU1dKA9LsKeKfhy2A9T6huT5mWVhBMMqQ=;
	b=S1xDXsspeVvT1Fo109urrfF3OjSHYmR3lBShc5cd5NL7+eI3ls/35ZVRMkybYM1pz8knkR
	WmqfjxNtU973LdGCbfAZIdvmNP6b2vkkLgGK/JF7dbSrIPs8KycEso3OHPCRFgn4EF2XWS
	nwGVFDw36VH4r/2+cTqjWMCIMRAR6rM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=3ozzZMNI;
	spf=none (imf08.hostedemail.com: domain of BATV+7b1de7ca9b09bfe890a7+8251+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+7b1de7ca9b09bfe890a7+8251+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774592844; a=rsa-sha256;
	cv=none;
	b=aSfyf7uQdEAMWaKsks6JJQTRtpoq88yTm0+5VZXw2yYz7QeZSkccGJYsf88VxhYW47Mxgt
	W1HrmEYQJXcT2Y5/Aqf4Kr6legzaa4rGVGJrrw72vZPGGCDHuEaFSihDHPyNsVzWkXeBLE
	NBjgTOIhQnbO2nPM1G6+FaF5zJswCF0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=G7w/DjtHh6UU1dKA9LsKeKfhy2A9T6huT5mWVhBMMqQ=; b=3ozzZMNIwG7iBmBHIggRh8/DLu
	8x+FlaRDvryUNTt7u7s70BsPfBhzLzqJcly52Sj8EZXyBrLhdpCOCL8iuerychQUTJuHQGPkibYdX
	GS2ScIm0cdDILYGgjoitivuR6YBcB0QRpTlt6rYa7PHKjqDsmyqNbCO0YC3wdURLu5RXaTEPQc5c1
	Gk+hNp2DXUh+QSndqK8RULVt5f1o2qqnQA2d73cN673EvDHwModjWdMqCjgfM4BPlkCcKKq5jhfRz
	4gGaPd7jnOf2B9gVXAEIbxNgQMKIY9VTlhJmAk3gYl/596taDXr+MU4G1eZOZijYf73mgUF8AiCC8
	1lq7qTxw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w60fA-00000006p8d-1NCq;
	Fri, 27 Mar 2026 06:27:20 +0000
Date: Thu, 26 Mar 2026 23:27:20 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Gao Xiang <hsiangkao@linux.alibaba.com>
Cc: Christoph Hellwig <hch@infradead.org>, Dave Chinner <dgc@kernel.org>,
	Tal Zussman <tz2294@columbia.edu>, Jens Axboe <axboe@kernel.dk>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH RFC v4 2/3] iomap: use BIO_COMPLETE_IN_TASK for
 dropbehind writeback
Message-ID: <acYjSMkz9MdWQKoJ@infradead.org>
References: <20260325-blk-dontcache-v4-0-c4b56db43f64@columbia.edu>
 <20260325-blk-dontcache-v4-2-c4b56db43f64@columbia.edu>
 <acRG5f9QjdEKg2JB@dread>
 <acYe1oCInkDLWGGu@infradead.org>
 <9e8061a5-980e-4e6a-a349-8a89f9eb1ba6@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9e8061a5-980e-4e6a-a349-8a89f9eb1ba6@linux.alibaba.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Stat-Signature: rsfepqw865xwo3ke77brf1b8jdrahz6g
X-Rspamd-Queue-Id: 1B270160003
X-Rspamd-Server: rspam09
X-HE-Tag: 1774592843-904228
X-HE-Meta: U2FsdGVkX19SoACD4w+7bDfh6+9jRxBa+/Jn/7/hQ/iMaVXIBStdFLy1cqeUzU4aVRGoBf7FwfqyfG/tvrK6Pw46PvlBXl5emBJNa0D4sOXeZMoKssvWhTZmTcyH5Z7ljR1R2DV1dAdfGir40+PRNYS53flflIZCbBMVneOc50G8T8xhAljdF2sNz218FRBz+5vIoU+SjU9rQaM5fPa3NZI8jmJ5YodXmGvIMzNSvizVsKfXZPDK0PdoKozpa/4FrFmOudv5nQfn/EvEEZi0PMuULn5Ui25+bEqoytkCx8QZvsAsc2TgLUkDyyoiteH6U1W5SH5KObsak46FVb6EcO42CQEXDTVJb5tDiTxSKAKlOQ22nM94SYC+0754p2Xsdhn0jykCkNYZS9LTjyNU3Eoharqg+o9l5edLgC7jBbiWhYPbntWshe/u8Wq7aSOWh9wGti5ZL2dr4JmYbDoLc15V/+5iTJIDi3pMYbOlIxlZQXXh3X2JdhgTHkdkHej3Ts2DoB7gF+tkKy7Zclhe84vvP6roCmBtgdKrm7RSjUVP8ON+/DTqe8+24pDzaa+ARfJsdfe2GPaQ8waDojAYa+3R5QlWlQ+VFFfbVgE1bGrRjiGFsdXqFHpibyM1evckKXasVT1q2NBoRrnvWUNHPOh7eM2tRFtchIHvb8YS4vSlszjiqYTf6UxDo8F9qV9XFLm/wLH16P7yeHxQ+Nq9ruxAouI61gQyZIeSfby6A8dwxfs7iqf8/gs5rDTAw0s1az4uAGZMJnC3J3DJBmsg0aDiTXLOqUO3c6u/aKsLa9+ptuaF/ilFEkVO2FFLvage/dZDCQxphfP0Eg0MPyaDykF85gzx65qFJQeOTNy2uBo9HYVlSTYL2g9bI6gQA9zvQZFRaXuCiEjJRM32Dvy+yiyvi2jnR9VGj1+wdCGqEw81ie8gMEtMFvpe0RdGcLaa8sZ/oqDfmGBM4/jctWA
 ta8ito5T
 oPCRaKkw92Dny7U2gAHLS9irrJbkrCGcXkG+DBBfcIJpgOD5KtFskP094J5PpBj83WKuzUX0WU7m/6YfLzjBFeexp5KX+BPKJr7h0oYM4P5GQpQ2yDhz3sPU4yxEeO7PnqouuKnrWG3VMQXSIiyZwJanyEgC38uzI5TahmodUllhk5z7rCYSuTwRlN1Ixq9u353kIEr/KBCZ+zXpETXqNentYLlKS+83nyfFvjn7n4x3AhsRzCjaofo/SKKR17ziRI1JowBPI5aVXrNGYjM6aOp6fwuBH1IWm9LfkANN6dRHuUnV4wT6EyRk1mRPRmVOXgIZJkxlT9HtYgGYM1JMwhDhO5aKAlvmjvvahCCApBtXi8Itz27ZWnUPMEQyOgVApYAtzdgUKokBisTLxhKJ9j/6b3qtoCz7F1aIomXFD6d92vkboU6gcFjjtp0H4DtaSYSCB361d2fXlC9NsYgyLUT5vTcS7nXzkjegq5ZdrrAjiqJ4rHL8FXQVdKEcYpMo/woTP/12cEgtgbGIE69LgUV5tBTVJNlaIFdGdN5yvdzm6XL8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 27, 2026 at 02:24:02PM +0800, Gao Xiang wrote:
>  - use EROFS directly, in that case, we still need process
>    contexts to decompress, but due to Android latency
>    requirements, they really need per-cpu RT threads instead,
>    otherwise it will cause serious regression too; but I'm not
>    sure that case can be replaced by this work since workqueues
>    don't support RT threads and I guess generic block layer
>    won't be bothered with that too.

All of the I/O completions should be latency sensitive.  So I think it
would be great if you could help out here with the requirements and
implementation.


