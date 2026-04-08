Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A69B110F9963
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 18:09:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CB186B0088; Wed,  8 Apr 2026 14:09:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07B696B0089; Wed,  8 Apr 2026 14:09:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFA7A6B008A; Wed,  8 Apr 2026 14:08:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E2E2B6B0088
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 14:08:59 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9159716021F
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 18:08:59 +0000 (UTC)
X-FDA: 84636174798.02.AC51940
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id C60B5C0017
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 18:08:57 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rleA7Q5F;
	spf=pass (imf28.hostedemail.com: domain of jaegeuk@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jaegeuk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775671737;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cVy1B61jPfd1mqXOSfnu4MoAYmwNE/rJGLC+hm5DRqE=;
	b=aP94NwYHVxfdw39gXzgncgMdSHKfjK9bdxJQlf9uiGxnCXFsT/1edCfHpRZBhp4cVQa2uV
	0J9fFnE7B732EAMKDDUU3KWoEtqVG1I06lRnilK/WqOR9qbplWscn3h7vtbOb2QmqB+v9e
	cSmBlZEuaBg03YtAdRa0AHuhT/fhK7A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775671737; a=rsa-sha256;
	cv=none;
	b=V05YbuYzn9Xd3H2vObm9lmNRjONr7aZY+QBAv0NgzzyE6ujn6YoAzmjXkdTsnkfqvxIUA8
	mK8BAw6e1yPlWW130ZEGeA3zVR1ZP1P04rH2hxYlun+ftm/jgCGbALCFyg6M+3XgeQ5C1v
	jTYqIFiaryuvQKUZqgopSwdmbX5Ek/A=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rleA7Q5F;
	spf=pass (imf28.hostedemail.com: domain of jaegeuk@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jaegeuk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DDA27417ED;
	Wed,  8 Apr 2026 18:08:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C95EC19421;
	Wed,  8 Apr 2026 18:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775671736;
	bh=gjoZ6EXEho/9YKSh2vZc0t46JYCGruU35fBS6/DCjSA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rleA7Q5F12Eow+XD+tZnHSctqeL3D9Ff1H88myZ+EhzFCsEUxCY1TeHKrN5vUd1on
	 lSidBKoUoe4z4cE6FYjOLQmDIw47e7Uwlf/RIUdizj0rh+vJA1an0TWKtaLPnWW11+
	 SYU2UcATvkP8dItxb9ScLadbutkefcyaAVQhk+s93WT2rjqJOk2LyR1FxHXHuwRt8s
	 G66+rqKRLf6H32b5HiQ72uCtPNZyyVuwsAvYzjdDhgQFiLub2wBnweSp0v9TX8w9sa
	 mtVXpahw9aqEGyFqC2Rw32mb70iI0hqLV9Ew9maNMOjASYCmDvYEg8reM/oERKDUjs
	 97dsgB9d8q0RQ==
Date: Wed, 8 Apr 2026 18:08:55 +0000
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] f2fs: do not support mmap write for large folio
Message-ID: <adaZt8GYIw1tKjaV@google.com>
References: <20260406154940.2407853-1-jaegeuk@kernel.org>
 <adSTUszGSlEK_IBv@infradead.org>
 <adWMAzmaHiYzSTzN@google.com>
 <adXhq-eEjJji1rcc@infradead.org>
 <2aee26dd-703b-47c4-9210-f70ffa6faf09@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2aee26dd-703b-47c4-9210-f70ffa6faf09@kernel.org>
X-Rspamd-Server: rspam12
X-Stat-Signature: x9637kcetw6biosqshynna1qcxik1fj7
X-Rspamd-Queue-Id: C60B5C0017
X-Rspam-User: 
X-HE-Tag: 1775671737-617675
X-HE-Meta: U2FsdGVkX18+vz+f2m6MuwBJL5gLkp9znQwdMm9vQF2FE3VFgr3lNomFpNOPkgJwklChDS9jIwSSb0dNNgTRq/R1tF8vypAQcXU/d/r0hZuYQfAVxxZvDFk8Mgk5ziJSdOv4IVtqALYYm7B0eDuV/Z+7SwLCaKe+zkx2RRq2VdJjfMQzVC4LiLCDy4pxh43eG8ZJczTtKfEXXWnwdnXOhC8DQ10iZTT3rDcEFhyovv0Uy/07VtQywuwWjqrPT9zjeGTq/xg3CbxLr1DcXWUCew3QxawClE5FGySp/7wylUOioHtpJ3vw9qyaUHSH4T51XZMBcbolSfIpc5TnZd5ZxFd2W0TAam0pywl3CaFlfRhI/4NgovlUPtK38K88wZvFhhVxCN5x2dJ9t/4Vqdo9AsGEz7SdBBydQ3VHWaWRE/YjvijodSyMrfSOEjioYrIYBOIhdiB9nFrQKrSmGy7PoQYml33hWaGrQxV+lhVRrzqBpHMYkWaADVg/5NNAjtACBAie5lO4/6oiEe8UGlnDMUxUgYAcGjUG3jU+adrV835o/0yCKfvSMoQ7GW1iSZZQL9086UTXh8S8vp3BcCHa8Oe1iwkqNZr2/b20BuHmGZXmndw0aThb0x7RNszhNPcM0cjTflKrv2Mm4zLSni6IxzfahBSwwElEETz4UYiq5Wu/S5UAXnBb5gAO1fNZgChqVVx1EAPaZiPwoOZYRKUyv060qQgLBof2LZ1TUfzLiDsShW0EzBgKG92HCE7EBH870e0AaTDXLQjjSnodvKkve7Q1iuh/yWdV+Wd5vbc5UwL2UI4DUM1aOgj2KQwTNKXC77z6MMg0kH71jO0ebeCSrRHcDDFhDDJSnOqd1+ketA/bwKrytbwckwjJDoZVQtBN8Zxu6qSTVWWhlckbl6QtTO+sRSy5MxAqI1N729yRj4UVjIgKsZNM+BLltcMIKR85XBo05/iqCVWvJwmwe1V
 nCY+u2sO
 jTIQ0o/Gz6Zf5LzmZkm9kKnEh9e0l5qfF30pqhK56CLmdKOkVy0oeZENiTWiQNIe6MV9NNDJ9e2E3psFC36D/HSmJ707qMD9dx6MUtsFHCxGyJjDTPUhTefqAnF6Qsqx6Us4npPeqi4Y8+/Jkn5zrL4H4PMrByNEJFjRxYmf5+T14axP5swA/mLJ2G65AjdOxQ02Sz7djN05+efl4COqpDebjN/YluWBU/fv2rPvAG5RBMGHrrDlMrf6cQbdwx4b5ikyRcAHGlno/tQI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04/08, David Hildenbrand (Arm) wrote:
> On 4/8/26 07:03, Christoph Hellwig wrote:
> > On Tue, Apr 07, 2026 at 10:58:11PM +0000, Jaegeuk Kim wrote:
> >> On 04/06, Christoph Hellwig wrote:
> >>>
> >>> Why?  And how is this not breaking applications?
> >>
> >> Since we only support the large folio on the read case.
> > 
> > In general spelling such basic out in the commit log, and even comments
> > is really helpful.  I'm curious how this works, though - by the time
> > you read a large folio you don't know if it will ever be written to.
> 
> Why are only large folios supported for read?
> 
> Where is that allocation logic and how can that path even be triggered?
> 
> Also, usually we check for large folios by testing the actual folio, not
> whether the mapping supports them?

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?h=v7.0-rc7&id=05e65c14ea59a401cec4284e9d612f9d5dc1b3f8

Currently I think it's simple to check the mapping in our case.

> 
> -- 
> Cheers,
> 
> David

