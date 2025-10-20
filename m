Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18219CCD199
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 11:44:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6923D8E000F; Mon, 20 Oct 2025 07:44:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 642BB8E0002; Mon, 20 Oct 2025 07:44:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 558718E000F; Mon, 20 Oct 2025 07:44:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 445818E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 07:44:37 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E1DCCB3BF3
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 11:44:36 +0000 (UTC)
X-FDA: 84018310152.29.EC984B3
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2F95940002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 11:44:33 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=aBoqO3eD
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760960675; a=rsa-sha256;
	cv=none;
	b=sNUps3H7nZVzFUNDgQVO8MdIM0KlsfjExmOO5pLhUm6HU2u43Cp12EfxBUwbkjX79ZEP7c
	H2CxDy/g9WEpq31sFsHMKYHxqfwmsXPUdDrzjabCbmnQjKJjqYSxVgiSKW/G9Pn4i2oLy0
	DgDEK8bOBTMplr6lLPnME6VE0wZI0Bs=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=aBoqO3eD;
	spf=none (imf04.hostedemail.com: domain of BATV+17a2c00bf4ec3f455068+8093+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+17a2c00bf4ec3f455068+8093+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760960675;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LlJHH7GKULBSEuT5LoQ4g/IkuhD4tO0XQl2oZHZZRe8=;
	b=koJX1LfJy18cWAIyeFxDx7JwS41JXRnFyWm6uufQ5qkRdB5LmzEpf7y/nY1YzRdrgikzSb
	b42WYNG6kX+HdosCC/hi7z/oML4F9YKeYfjF+0GPNkNVlx/eWeIm6u9o+yYT6cfm55S5ah
	KivkfOqBwlluZvOBwgAZ3w/50WIrxeo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=LlJHH7GKULBSEuT5LoQ4g/IkuhD4tO0XQl2oZHZZRe8=; b=aBoqO3eDFMGv0ZvvPfgSILWBQA
	a2owlrlvFh8FfnKwzbB+0hbDMZLVbAqyvhPHDse+jvjzWvWqjMvrkB9qKzd3RmSk8ukxNwZhWogLt
	At1lB/TwnABz3PiEKr/PoN4rBn5mRpRmtHsCFVFCJ6DJiGPKmrbGpovj14e5TfjxbXEx5pdjXPn85
	LqA5AxkX+KhhqjBLbZ7QY7y5yB4fp7xFCKPzfFMDKyjsgsHZgcRi3gA63Y67stlMthQG4ehJP6NpW
	diJ0mQ8Bk6AiOPEu3MeuWcmpYFCU5AzTS9TKDIVGbUzAeb26+9boNc4j3zHgmA0IN48ojhQLpzXqH
	1FhW135w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vAoJP-0000000D6vc-2d9U;
	Mon, 20 Oct 2025 11:44:27 +0000
Date: Mon, 20 Oct 2025 04:44:27 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, Qu Wenruo <wqu@suse.com>,
	linux-btrfs@vger.kernel.org, djwong@kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-block@vger.kernel.org, linux-mm@kvack.org,
	martin.petersen@oracle.com, jack@suse.com
Subject: Re: O_DIRECT vs BLK_FEAT_STABLE_WRITES, was Re: [PATCH] btrfs: never
 trust the bio from direct IO
Message-ID: <aPYgm3ey4eiFB4_o@infradead.org>
References: <1ee861df6fbd8bf45ab42154f429a31819294352.1760951886.git.wqu@suse.com>
 <aPYIS5rDfXhNNDHP@infradead.org>
 <56o3re2wspflt32t6mrfg66dec4hneuixheroax2lmo2ilcgay@zehhm5yaupav>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <56o3re2wspflt32t6mrfg66dec4hneuixheroax2lmo2ilcgay@zehhm5yaupav>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Stat-Signature: tyg99i9os61rdc87q573438kf7zdhsmx
X-Rspamd-Queue-Id: 2F95940002
X-Rspamd-Server: rspam09
X-HE-Tag: 1760960673-446084
X-HE-Meta: U2FsdGVkX18N0Nznpau+ajOiZc7NWoi4EqzzqvGuVIlo9a+EUoRKOuXKNQsvYkxMddmp97+iG9CGlGLlqrj9cMTH3UxCEl4gs3SW/O8IFLRXiFXgXAebwvqJoN0IgPIVNhNb0teli7YGOHIH0GCkm0PajA3Gh8uJWGZ9pXFpffvh9TRLmCyBi6HDqJArtgGhwIOoCiwcV09xRxpLiWMa6MLxAt/wfEl25BKGunI2FYidbVYszizhlAM1SUSL+yKa6m8cGx4AunvlSq6GO78G7rOBQdO/RuvLk7Nt+jDYK71S6jZFVthgamOCHTKMcXb2OPWvjLnGNVwWqP+AKiW/ljqpKSyuFR9CtGXszzYdQ9p8kGZc9Xv3ZQB6di18GlgSk4IJ6EGQLedxRCzLCLufMd+9S8j68ICjK5GiCJfKQZvqvYWl1SxcxYDKtFZo4wS9S3Vqt9vTBr+1EsDMt1h/iLKqCp1H1mw+d659/IlLgzytGEwHO7pNbQ7WUqii7cuHKG+Fcd8C6LgsJ/SJPSV90PmZ2MAbeVpASrl9gZOtfBUZ6OyNWhjGYwFwDQZacdCOdEyDB870FwdcvEiB3HWl7ipUZrTOVjcigBlOlWor+1qVgtIYZNl/BlfKX8V7sIC0KyNzqJ/+Q5n6rCZkfYa0JuTkp4MIWXoJbtR7CQHZ6zFRUFhLvQ/fhRI6gRchFO0bL3oPEaw2VL+qADf8rmP6Mk3Moyy3eIYJY6iTRSaKWcE47vJmykuEjngRrLGRx6hLL37fwX6f/WVOfBr8Ei/19gV2R7rLV0mf2VuKQqHZ26x8NW5Edg7rjLcEiHJdtrj2bq5QLcszMhcZkOmdu9W0RpGiAeId5kYzTWj2J0FqnLXM91IfUKnAv4sgipaeFMWI9UP92iuTjxULUFihWMFDwfSEzXIlWmrAnhu5KPGcD0uS+E181G0K4klcMh0ZaIr7gqW1ZTTtP5tg6uomFcw
 a4wAGjCW
 PTUPpy1ELD0Qkx0WGxxsWz7YEGwCdN6UquHInmqzj3nYe8fr2DTjYJycdLSu253e9QCQpP8j0ntSkQb+7+YjOWGL2ZkIOPOMJPw9fiXmc9EwPjJUGSx716BLjHAanFesLVlRY7osLvKZzp3x6vI5vd0RjKJjVs4hE+0pvuDT3flmqLnKrMTi+Ae/HD71xNL7SUgWVh6BnTIdGsq9/6+yd6wnoyFoD58vOYorgjeZZCxdK4O7pi4q4FuqdBH51ufeCQ3IIpchQSIK3E6bxbYi0plXv9Hs0AU/C5zVA3WzSUCJu/L8x66C6CIJSmlkavxEsQnjxNXf/sHAUkaYWkkAPpZc6fRTsxAZqAZiRyT0S0TeNItocnosFfvCdapuC+SqmaOSkcbuvA8FmQ9EZ5/Cgd3lC5zAjmn/PlheUvjz4wbWL4FH0OIfyXMe6fkQkkOIIHCZjxcNOF6sFGp5go+AIbTzasZrsUlS25JjR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 20, 2025 at 01:16:39PM +0200, Jan Kara wrote:
> Hmm, this is an interesting twist in the problems with pinned pages - so
> far I was thinking about problems where pinned page cache page gets
> modified (e.g. through DIO or RDMA) and this causes checksum failures if
> it races with writeback. If I understand you right, now you are concerned
> about a situation where some page is used as a buffer for direct IO write
> / RDMA and it gets modified while the DMA is running which causes checksum
> mismatch?

Really all of the above.  Even worse this can also happen for reads,
e.g. when the parity or checksum is calculated in the user buffer.


> Writeprotecting the buffer before the DIO starts isn't that hard
> to do (although it has a non-trivial cost) but we don't have a mechanism to
> make sure the page cannot be writeably mapped while it is pinned (and
> avoiding that without introducing deadlocks would be *fun*).

Well, this goes back to the old idea of maybe bounce buffering in that
case?


