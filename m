Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C215CD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 15:36:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67A2A6B0422; Mon,  1 Jun 2026 11:36:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62AF46B0423; Mon,  1 Jun 2026 11:36:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 540FB6B0424; Mon,  1 Jun 2026 11:36:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 43EA96B0422
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 11:36:42 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DDD0DC2476
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 15:36:41 +0000 (UTC)
X-FDA: 84831746202.21.A2B34DC
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf04.hostedemail.com (Postfix) with ESMTP id C9B3740009
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 15:36:39 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=BHrNpzeG;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf04.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780328199;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uh/rSo04bA41IYEYhuCEmiPxe1UvV/t0jdyDzVX2YG0=;
	b=X4vhnYASc8+808OzPL1DbAwa0c1uRgP9DnPJG1z+Id7uHdx4+RxKY5qDndvTf4j6w8CnZJ
	eUMr36HZ+aJJCVVAS0qZwQUnx5EGBotwjRsvbkKDJ++zqcfe5ihpBz5m10FHplpLBT8zln
	gd3fJzoo02DFZUwe+1Jz1vMEEmKS3Kg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=BHrNpzeG;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf04.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780328199;
	b=hIrHWStu64Brl3kPxTePTNdNsMv8ZDXJpoaChYgyOJa4CslU58PbJTiOZPBzwgCxCM/R8W
	ah/5TSeZmyXN2naQM8DtO63cw8ulkEMKn3VYrQ1F/NWq5wrJqz2iGXBbCkiQzAYf54j+wD
	KJkgObexrMQIBoH1K2vR4psTm3ILBBc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=uh/rSo04bA41IYEYhuCEmiPxe1UvV/t0jdyDzVX2YG0=; b=BHrNpzeGZqdKJuNp96JO89ttPJ
	bdb+A5SD0YvtoDoKOX0CC3qchpCkTZ2sI3UM5+vS3aurB3SMNU/xuzXKT6ui9yT8laW8VxXYNd+Rv
	C08f5zIYEOjkeCCyZpXVZEUiPSHLKkaZKuGArp5Bh/d8uXdfJqpl2kKNB4wSH1ss24z4TyrYzHia2
	lHUWhh64JLazy8RinYX0kKD/d0zf5/Z10mlNfPhR1nXy3hJf5z2uOV3OjaIOQK2M2+6ALpsXj0gS3
	Zf1W7XuzTtQBA6MZZwthFzEcFOL6eR9aVlXkTl6XWFmGHUjDcfewUeG3hXPoPtR48i/QVNEPOt0Dw
	9NMgQ7Ww==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wU4gu-00000000KjY-0W0S;
	Mon, 01 Jun 2026 15:36:36 +0000
Date: Mon, 1 Jun 2026 16:36:36 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Askar Safin <safinaskar@gmail.com>, linux-fsdevel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-api@vger.kernel.org, netdev@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
	David Howells <dhowells@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Miklos Szeredi <miklos@szeredi.hu>, patches@lists.linux.dev
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for
 preadv2/pwritev2
Message-ID: <ah2nBAdsE5vVJ2PL@casper.infradead.org>
References: <20260531010107.1953702-1-safinaskar@gmail.com>
 <CALCETrW__=8mSusayfXG7UFCfue5BGbx+vqESj1d9wqOfX4s8w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALCETrW__=8mSusayfXG7UFCfue5BGbx+vqESj1d9wqOfX4s8w@mail.gmail.com>
X-Rspamd-Queue-Id: C9B3740009
X-Rspam-User: 
X-Stat-Signature: s6udigt1j54yetsbqbgjkrn5dxcu5tw5
X-Rspamd-Server: rspam09
X-HE-Tag: 1780328199-794152
X-HE-Meta: U2FsdGVkX19/Xbj4yyJ6Zcl66qAt1D4C7IItGvZaHnnD+LBv5EJyB/DjuDQmPmcHmAY7+j55iXlgsOHeyxEiXt2Ld5/UMgNvuXVvwjwrzMrCsfKohf+QuQaxCWPrhD/B1INfnt6jN+3ZvbNK2Ni8CvJjcDIso4+G2hSoRD5+Z1kTcbzzTdc77mWdJcgfVhDPPPECJ2KcscA4UqiWPOH1SYSCi/uNoPVHqAkFhEbeE1SMGzYiphVvF/3Q8vTC/JfNUdpc7qSLsijcYRGyAFzmpwT8XkBQTxF9esoWsI7v8/BUZ6Sp4IlzM3EnxXN3v4W7fAbvTXFeqQ1Swac8sdhwINEF+eHspOmaVrAu43rzlLqig6oz0uDfH5vYFNV0taKKZRntZpTNCD94MCEpgGrk76UkSERC6TXveg6q1D9LluMUEhnU9UH66RImmQ202OZ2N3psSsS5oTWTcy+K2cAZL2cx3YUyXbb1X5StY/ogEm/RGJy5J38bOepjHIe6vfv4opvcylXgCL2bYwlASzKyjQUpqdKS4poiO3BUClkuVYu5cOQpJDYZjeDFwoU/uo/JABTupHs2V7keZaa3BxKDT7jU771lVpOoSiSJniQcebPB3NRbaPDu9l3yRzytwX/lQXNKZaTSXQ1/dyJCO7Lafi9zAi0ECAxPWP6HS3t/jMmDAZlpJc6J9A/HDFkuTvomzibecxvaURJRJbVaFXvWgCmQ0sOrPFhWjxgDx4vmh8ARA2RDs88pr3/Xys9jupv2fHoOdlILSpcOe8aoigFbcwOLDzaD/E+wyRW5DWsvP7pOcKgwanStMA3eKBjCRwYAWoMno9aGxB1Z5Cu7kIIleCQ+LT+zVumQGPdHNNmV9hSYdSW+p61XR4Sv1xJTHoo67yQ9iNHqqFZfc+pAZhrrGeZxbD52aPW89F4f0YNpmNZrlbA4Kp9JHYRvqTuknNH0RZshZ2w+jFNjU692gFN
 J1rPhQem
 axyZkKgw60hrE45kygj4hYtAL9jFNwjptciC7A8q3ayjvqzR81TN9zOK7WIJoRDGRWgYspSDKJFUHZlbnJf0ll6WlX7Wd6ikcq5jTY0sXf1MCDiT1v9PvSZorpxWRAmbtTszQmB8FLJy9PjWXm0BznnfA9F7kWWEuWgK9RC30QQEOdonWYMDaQGkCiEFN2bbRNBdWj26Axw92iV793Dw68l/Ok6KzAOsOMpbTnler8B/L6/2ZX3RIG3/HFROCsQXw+z0ZQXTgggBllXHqRW8pJxAZmXGIXEyiu8NIcZH8Rm7vSOLnnchJTqunI98Yas6ZvSv5MGcPaaqcO9tpvrw/AUe3qgxDGkRDRibM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, May 31, 2026 at 08:11:34PM -0700, Andy Lutomirski wrote:
> On Sat, May 30, 2026 at 6:03 PM Askar Safin <safinaskar@gmail.com> wrote:
> >
> > See recent discussion here:
> > https://lore.kernel.org/all/20260516182126.530498-1-pfalcato@suse.de/T/#u
> >
> > For all these reasons I propose to make vmsplice a simple wrapper for
> > preadv2/pwritev2.
> >
> 
> I have no comment on the code or the history.  But I'm 100% in favor
> of the solution.  vmsplice is a crappy API, and would be incredibly
> complex to get the implementation right,  and it should be removed.
> But it has users, and the approach of just mapping them straight to
> pread/pwrite makes perfect sense.

I agree with Andy.  I think it was appropriate to send this series, since
(as far as I can tell) it's a completely different approach from the others
taken.  I'm not really qualified to judge whether the implementation is
good (it's a bit outside my competency as a reviewer), but the described
approach is more convincing to me than the other approaches.

Can we review this series properly?

