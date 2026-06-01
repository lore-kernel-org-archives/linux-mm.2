Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E326CD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 16:17:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D22A56B0455; Mon,  1 Jun 2026 12:17:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFA8F6B0457; Mon,  1 Jun 2026 12:17:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C37CB6B0458; Mon,  1 Jun 2026 12:17:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B4B216B0455
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:17:43 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 56650C24C0
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 16:17:43 +0000 (UTC)
X-FDA: 84831849606.14.37B4D8E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id B2D4440006
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 16:17:41 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BifbDx5D;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780330661;
	b=zNQmPxb+bW3+vPrPDV9+R9/ETcHY3MZIVBZG8tXz68rUcPn6t04aBdSQNblwU3dL1cLfs3
	rYHKDUBnL5nqxtNfgaweo7vdiY+Oty/LmKbPNXWcUFWLCvjQ73cExcPQAYvRFKXNHrTF2z
	PjSh7r966ITUYitcH2UmQ+V4U8CBoK8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BifbDx5D;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780330661;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rNLnkxLxw0b3sBZzOdV8X6NVlh7ujukPI0iIaNRmGIs=;
	b=zT/Hoym3isBz1XCNfcDzbaCj0zGJ6UcxV9YeylwPplRFfsz9mbQnYHXr6KGQk76oQzwjOK
	46l5NvKTmfkhwkGISGvK29uKF8cGKduJ9F9E2Ls+rSY+F+1cqP4UG/LeZBZMEmvQ6iuNwO
	9/nEW+uoFgxOPpFSZseUQP4A1yG9XNk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A7A18416F1;
	Mon,  1 Jun 2026 16:17:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67E1C1F00893;
	Mon,  1 Jun 2026 16:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780330660;
	bh=rNLnkxLxw0b3sBZzOdV8X6NVlh7ujukPI0iIaNRmGIs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BifbDx5D653jXTMEUYB65fYghTtrNqepjSBzEEPnsZHuvMiKkUOlVvAuDnhiuDt+S
	 304eftkIVK3rIX5PhVwBL44KNhsA9dJwCSyTFzVTvI30ARJthbxHrK6U7NK9+WK5GY
	 TC9AesLZFTlE3g6mll/KzrdOMnxuE7tBLKicmwOzeWy73MC+/4AL/ZfXfEjcqljG9V
	 pBY6dZiayBvckutKYiFU/gdYkCs+GfJfmG1ifRYuW+2TFchPjF+q+XEM/3y/pdWpRJ
	 eCatAhyfCn+EEyD2fqdkmd2KXIZ26Uz9dsqb3EYg5nVWNFlArRGKYC3M0cqkoD14cB
	 9u/DYe8gzQbPg==
Date: Mon, 1 Jun 2026 18:17:34 +0200
From: Christian Brauner <brauner@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Wilcox <willy@infradead.org>, 
	Andy Lutomirski <luto@amacapital.net>, Askar Safin <safinaskar@gmail.com>, 
	linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-api@vger.kernel.org, netdev@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, 
	Christoph Hellwig <hch@infradead.org>, David Howells <dhowells@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Pedro Falcato <pfalcato@suse.de>, Miklos Szeredi <miklos@szeredi.hu>, patches@lists.linux.dev
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for
 preadv2/pwritev2
Message-ID: <20260601-aufweichen-dissens-ausrechnen-0d9b84728113@brauner>
References: <20260531010107.1953702-1-safinaskar@gmail.com>
 <CALCETrW__=8mSusayfXG7UFCfue5BGbx+vqESj1d9wqOfX4s8w@mail.gmail.com>
 <ah2nBAdsE5vVJ2PL@casper.infradead.org>
 <CAHk-=wiFuud0Nn3B9YpTWyQja08TeXVk2AB-aAkmVXyigOagbQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHk-=wiFuud0Nn3B9YpTWyQja08TeXVk2AB-aAkmVXyigOagbQ@mail.gmail.com>
X-Rspamd-Queue-Id: B2D4440006
X-Stat-Signature: ukzunga7g48yg4y6i5f5w6eiik4mqtej
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780330661-269053
X-HE-Meta: U2FsdGVkX1/aA3HuGVuTjGuJui5QVH5GbETDg2BZGYy+iMbqO35vS+9VPs8EIp+0EQ9xfaUoCLt+cEpuEirDqEZrLG8kkiGhLyvPQ91attHEde48XsLyROQsx8osZI06v1S3T5zaK1pIZGp/uirgxFKYUao0X9oGb27hQ5mrrhrp9+pP5wby9U0ujbADZZ0PV/qYvjB1LO0chJUIKyMPD6vulIo42jQV3RXzGqOF/+Fxe810Zwd11VAItSpUW9vfADa3GjzSwlxlta36abzyaHnO10ODJekw2AOF6sm7Circz8veXtwAgIwDW3cp0Gfe4n7tjBmGiI5cCaBIItMpgHPeWsv5ebylukLcxqDNwh/TCj/euw3oL5F5RQlPredxr+pyZpKuFyFPQJ09sch9oxT60CrEj8VIw0Z0ZSyqrzxrx+ccVVQw7abXkJSdv23OfZ8NVdfhQZrTiGhXxhlg9RN10cEC4np/IgcBkiHaWIg1STaqnZfU5kBLAC/ZdNts6311FC75umBaLAyQtlDlwG/FKmeVY3ow/mG65CHQoRn3dFLGKWQE3tM50XdUYpVv4zTU2T8FqT9iVZsWEbc5DDUXIumdqEnWFzUov5EFtV8q5hlW9+WxI64ULr7qAkdTJsoOPW11zcLr/Zs0pR6rT4YKFh26sIKNPgXSejj6y2iDF1gbzopeA4SSibg2SlAXqC/aT9/mUNQ/GK9J8SIrXxNxa1qXBPhCnBh/SLg+sCp8HiLvo/aE+YvUn5qmeGzLMbytT/kikBNPmL6UdXUHos71XY1gl+KkqNsrSyICIZXQTqol41BY1xGkvf6cx2qb4wh3Kn20pbsH0nYwQGLDrs609YmrmjEHBLzAJoz5sagdkxzs5fuyL2O0IqoFYI2Ox7feS31FKJLFFbYyy+/aCFqTZTzBHwCcTlOPprERXGvDO7JLRZRBGdoCVn1Wa7x/MRLxUEXwika3lc2p48M
 eNJFN0hw
 7pvxbnc/bOIszwKdHCl9JH+KsE6S98iQ77/u0GxG0U484Cj7kPM9howvN5l1ikDt59wEHJxDuGHa/aLXbM3CRYtJFYeYeQqtJzDzOK1Z+fJyCcceXI7iKwGBQ4VHLCpm+ZaZFzZ7W15yOaa+t58tnfLssMAo1pCvxJqB+jioeOF538gBn9vA2c0zwDBMnAfFWfKu8IhqghQCFDNeUIFYNeB63LIXlBDqR/z+mAJFoYYdh3XqBwd1czVFzb/ZILi6gmIEIJaQB1GizitzVubQWsPIjyoNTP/zZFbbIsCJxawUWGK0T0L8U7GqrGKWDFaVolDxLy1gsGlEvcyfLqpuSOsq1qDpWUveqQjMaMgfdy1QUOBc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 01, 2026 at 08:50:00AM -0700, Linus Torvalds wrote:
> On Mon, 1 Jun 2026 at 08:36, Matthew Wilcox <willy@infradead.org> wrote:
> >
> > Can we review this series properly?
> 
> Well, since it pretty much is what I suggested a few years ago, I
> certainly won't NAK it.
> 
> And the patches looked very straightforward to me. Just the final
> diffstat is worth quoting again because that certainly doesn't look
> problematic:
> 
>   7 files changed, 33 insertions(+), 204 deletions(-)
> 
> and it removes that GIFT flag that was truly disgusting.
> 
> So I'm certainly ok with it from a "looking at the patch" standpoint.
> I didn't _test_ it. I don't have any workload that might remotely
> care.
> 
> I did a quick scan on debian code search for vmsplice, and after ten
> pages of entries that weren't actually *using* it but had lists of
> system calls, I grew bored. So there are likely users, but I don't
> know what they are and how much they care. It *might* be a big
> performance issue somewhere. Unlikely, but...

As usual I would argue to accept it and revert in case we get actual
regression reports...

