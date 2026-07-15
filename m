Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 702C6C44501
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 13:56:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D16D6B00D7; Wed, 15 Jul 2026 09:56:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A6756B00DA; Wed, 15 Jul 2026 09:56:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED9596B00EC; Wed, 15 Jul 2026 09:56:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B87516B00D7
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 09:56:50 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 43273C0192
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 13:56:50 +0000 (UTC)
X-FDA: 84991161780.16.EAE7D19
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id A61B1C0011
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 13:56:48 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iDQO1uZP;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784123808;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LCsWQYFVNSg7uA4Hso/40lGt3fnLGJdyXFxUHGfslFE=;
	b=BRVs2iXiU6AlZdwfu+7ZKVXx8uCVeroo0eiLBa4M7p7HN1nZiIplMJTJOB/XEkYzB1Ad6a
	SgNoPZJNhkTxfsSGuDALG4Q4uqaKnU7eYt/jxSnWtZwjjIRkr/lNH5w+8/MZBSAGvGaA/D
	v+prUqgamTG8Jrivan7IZ2AwUZq4DOU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iDQO1uZP;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784123808;
	b=qX7jPlmzdn8Q+54mTVzYw/F2Klyj+h5cntqw7+bQqoxdCov0NRKrO7gATUBUs6/Q3ZWGST
	gB7oUNZTffkciMiDatJ7smTaNXGzjQNz1MF5LfbTx3J6wjc+LVvYDH14aOQl4HnMmlRRe4
	0kCtWBThjm1JBh5oe8QrwzJAgAJChbk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 35524600BB;
	Wed, 15 Jul 2026 13:56:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFFBF1F00A3A;
	Wed, 15 Jul 2026 13:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784123807;
	bh=LCsWQYFVNSg7uA4Hso/40lGt3fnLGJdyXFxUHGfslFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iDQO1uZPO5gMGFgCWTiFdeuEcYz30Fhnyxx6qhAcmhYNOWvoVEUFdDcg9u2eHONZX
	 5MNwywrFbmqAQenF4hqn/sHiaXVso9iQoQ1YPisjATK9Qrrb1nORCsvTGtrYQy5XIi
	 H5mDwM3uSkqigHIrLD8RknbAtgxiOTVGTImgCQr5sqpUWpcMNlCetcdPr1Knd41mm5
	 afqMg/N+d74EWsb0ALLKvioJsQAZ5x/vyD4BLmwwsLcIpjqxM5c9FsTXos5rVFvVzS
	 saS4F4hURs6ixYG2GkHZl9a9CDHu2lvoZXXNrEsZJTx3RZXqu9DTKhE8HIm7qOLlJM
	 tdAc9iRzUfGGw==
From: SJ Park <sj@kernel.org>
To: Song Hu <husong@kylinos.cn>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] damon: update outdated comment about DAMOS filter handling
Date: Wed, 15 Jul 2026 06:56:40 -0700
Message-ID: <20260715135640.84147-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260715092634.1450702-1-husong@kylinos.cn>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A61B1C0011
X-Stat-Signature: hmhx3mcwokbcq16soxscr3n1y7pa3pbw
X-HE-Tag: 1784123808-361398
X-HE-Meta: U2FsdGVkX194gS3KaVe2gMxi3a9FAp+oNNjjAwi2LwUtTCagIvoXztsj7ZjAoazQGpmalXodZsFEHKngQm7gzTSsaetRPJAFPNwQZEkzpeE84U6rHBm8Q63fNejPuH8NZIX0LoQ1wFGTieOOQnIJLOshh7hjMqE6tNCxKF1Fe7ofqOxqu/8Yhx2e6YXuCjwxDWUTBtaKQXR5uwg8S3j+2+OMj9UmtcQGJNSUq3MHcp636qJHVZRckKOT1y2ZxHgJgOUfPRnXt66nY6n86hVqPwCgMxZ0Nb2Pl1/gkypZbXCZFu0JG2fmUKRVh5mSW1MG2Sf1MFLHD3uUwuWbp+ZgFw3aK4FZ6lwild2INyBCEVQCygsZpi7sGNqLinK9FnQU5k/5fLMTVaVHd1MmcEugAhplIGab2f601w8MyXomcrB+nPV0vxP0VNDA52jqzXhKajOYcCkZdEi3Rj8bU/tvNcKYPU0QfvXMM0Qr98Y9XS/AXG8ejBJsafIFQnzpzd16BEgkj0pxYYOorkWyrWRAPVby/6FTFe3KT5CGCtSSK063QxuSGlfczScFtjdligjBnNIdQPdzLmC339JZfh3x63/uCV/iy1Lpp+2lsDtrjrJ4mJuitjWEip6vG1ndm3RFrPDdSwzjKd3BmFfYa/X3WRZll+w3el9rYuq6KQVVz0QPEBZB9TcQR3p2tz0lDs4QQUodvhyajGQB+VBNV0esYYMhtxgCSHpXbs1qxNizI4DdP/qs8Ow+M5Q4fTWxgFv3p0h8tWyEX+uOwCN32eURlUVCJ4xleR4HCCdgn/ze2nhnEu2FISqEdf1m5h+WqUyxoVWE0fvvVP4n8Z/qmTwXiB4wtqFA6XLACp1ZyJTCVxrPDOqAROzZhWR8YI53Os2IFMOf/fsLizkQ0HMCu4yvefwFXW1Wb8LFYeYu36Mh46b38znWWSPhzAHM3Y6+fTU+wdbysvS72bqRCcRnO0D
 vzNxD14+
 BUgpEkrm+WOAper3w+Ug+anLnZv8N43McCo3zqNU9vW3dO4nxzy1kxsYuI/MhHArjLZ/qzOTHg2PGryj6edwgxU07R9rl21ArLhUQbfrmdimaIjZGKDMhuaGwFdBiBlwl1EsBZ0KgHBjsOHeOuY9SDNqfnqFFRxY2Efc/vHhxIZw+ZroPisEqk517T8e538UxWZD6BAJxWZuDYNtcwdA7bjI1xRZnba4aQLOAA9lJ5VolHKIF9pmpXeqWu/U+pSxy+D07
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 15 Jul 2026 17:26:34 +0800 Song Hu <husong@kylinos.cn> wrote:

> The kernel-doc comment above enum damos_filter_type states that only the
> anon and memcg type filters are handled by damon_operations (and therefore
> accounted as 'tried'), and that DAMON_OPS_VADDR and DAMON_OPS_FVADDR do
> not support those two filter types.
> 
> Neither is accurate anymore.  damos_filter_for_ops() routes every filter
> type except ADDR and TARGET to the operations layer, and the VADDR and
> FVADDR operations (the latter being a copy of the former) handle all of
> those types through damos_folio_filter_match() / damos_va_filter_out().
> Update the comment to match the code.

Thank you for updating this!
> 
> Signed-off-by: Song Hu <husong@kylinos.cn>

Reviewed-by: SJ Park <sj@kernel.org>

This patch is applied to damon/next [1] tree.  If this patch is not added to
mm.git in short term (~1 week?), I will ask mm.git maintainer (Andrew Morton)
to pick this.  So, no action from your side is needed for now.  If it seems I
also forgot doing that or you cannot wait for my action, please feel free to
directly ask that to Andrew.

[1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees


Thanks,
SJ

[...]

