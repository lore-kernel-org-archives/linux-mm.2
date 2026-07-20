Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0935C44520
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 22:16:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 847286B007B; Mon, 20 Jul 2026 18:16:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D1046B008A; Mon, 20 Jul 2026 18:16:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69AE26B008C; Mon, 20 Jul 2026 18:16:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2E7566B007B
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 18:16:37 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0400F1402D6
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 22:16:35 +0000 (UTC)
X-FDA: 85010565192.21.52C9607
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6A62E40002
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 22:16:34 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NAT4xJHq;
	spf=pass (imf01.hostedemail.com: domain of dennis@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dennis@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784585794;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8DU8obaCw0iTM7IFbaaxyEJABTOe4jgbs0pWKQlHlMA=;
	b=iXjPu55xd5qgEgWhLsKkj4xshv8fiE+ooCH33blFQL2xtVSj0QDz+xlKb6WqdU5BoeLAVc
	6e+JsLOiAoDpJZv8cVq0KMrNvxCFT0gI80q9L/SBds/1r6LwsxT0jDvhUWmKfqysdBEceU
	YUEePziVvN+Qv5LzedpgyuZafcXUPNA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NAT4xJHq;
	spf=pass (imf01.hostedemail.com: domain of dennis@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dennis@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784585794;
	b=w4BzAZgHwyWqH5Rn4gQADCo+773F3+NIobyx0l+69WmIUIOX9s110tJHQzFe1x7Gs+yGTY
	3TAH7nUAju2xbPC8KxChChKuD2aoE0N9wyXEONqoqUjP5f8IZjswHapzGuvo36/ZKoIbOa
	jH+yHXjRRnWQV8+UvTz8ic5hGG5qjOI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AA20A60A7A;
	Mon, 20 Jul 2026 22:16:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB9851F000E9;
	Mon, 20 Jul 2026 22:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784585793;
	bh=8DU8obaCw0iTM7IFbaaxyEJABTOe4jgbs0pWKQlHlMA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NAT4xJHqv/vfaFe9m1w9iNPwcaMKlEUIvqtLY6RvG6MVhwXPAJ1XmQih2fV21NpUt
	 MEbuKTBqvw7PsgiKE/xDXbwvU6oPvjiqbinaI4TbkDbrwej1DFCskK3BX2i3W1GBPz
	 cEmNLNXk+N7Jkmi6vszHvmu70jFH5T2Dcw7SpjbRI7MueIyrTrTZo+q3itraQhEN/Q
	 f3p6+voUWojJsA7wdMAmuycCxX16UCJUAHSI5DISp+SCwgyHQ2mfhg0yYnUWFbG/+w
	 32ASHFNn0kzmmXTE/1Sb/C2pqUla5slcBEfnZ4CyGSUhALQS/+g+9z4FE+ByS39weW
	 m685xUvxDOnxg==
Date: Mon, 20 Jul 2026 15:16:29 -0700
From: Dennis Zhou <dennis@kernel.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@linux.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Sashiko <sashiko-bot@kernel.org>
Subject: Re: [PATCH] mm/percpu-km: fix bitmap overflow and accounting in
 pcpu_create_chunk()
Message-ID: <al6ePXAJ6iwQYvfx@palisades.local>
References: <20260709-fix-pcpu_create_chunk-in-percpu-km-v1-1-1f64745a84cc@nvidia.com>
 <DK3N4FET9ORM.327QYW7L79VOK@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DK3N4FET9ORM.327QYW7L79VOK@nvidia.com>
X-Rspamd-Queue-Id: 6A62E40002
X-Rspam-User: 
X-Stat-Signature: rdt4rm6e837e1ceahwx59gfj3hfk9qc7
X-Rspamd-Server: rspam04
X-HE-Tag: 1784585794-560460
X-HE-Meta: U2FsdGVkX1+5qmt0+6hc3KmXjdFS48kSWBkQ3MGzHnXyIiw1PIZFGmgXvV/vEyZVxm2ru/IwqrMdcVGOqReXb/h10GHMp/QqnzhbAzoCY+qyum8qq9zPcI7LZdTE4LPwA17uoMb1Y95OqxtMzkS1df30cK8R19OoXwg/VPh7GVYDhsnjeUWtwktc549zM+sKvRUgPKMwKJwQo3eE/vgQDU6RFq8gzAgtuzbssSIOvsmSYbX1vWV2NyLnXIeZLr3FZPHXGYSCynZKafI0iSk/WCxts3+eL8Z7Z7mm2YPqVPAwgvXHkVc7KcBdOx71ppBua0Dy+N269/I2xc7zKuoX5FpyYYgU+fAogwaOvt3qdIxC4VD2my67egRbaK+sn3muDcgpLOisX2vZkJWxcJrUblV8qlvi7sQesRUVkih2fwM6ZjiktrxewiSZeojtCAbqkoNLTYDjyJQXN6rRwqpP701QOfC9IRfi8kJS+f7WxDIFsVAlOC28I+GfeTx/aoq6bGZCFXSdzp42T1qZ1S+nE+t1lAFfuHb7oAg+mhH/FEwrAcorUcAL8SYDKEItRzRqSfhWZ1lnJ2SyZiBIqNbUmB0k/JSTCrRGNFdzNyxyu/Hrjxv10heU8AfG6gCHvSqeTyDJD4pTksFBV8Yd0oEdK0y0m8E0PkE6v6iCeets7WelqH9InCs4uLGqERSiCuBzW4sQXJQ7b9oM3jyKqAQvLc7JgTk+WK/o1XPacbVvkIIE3SA35pPcAJXDj1yVDKz+gsPu8Z16kgetNCQrnkXzsVch6VWcmG3bQqYls7g1NHXjwTXl+6XR8zydXjI4ffWiRr28TV1UAdKZ/bFjAaiB6sQFxfaY4Vlq2WkPXXNHaz6ikzficwr8JvO/MhkiyzkUB4SHqd8k+Sd0PxQjGP8jcFl3Wm0sRLxJBgh2iO5RQGd+9T2XiHODoFCU6dFbolzbiJwrM3X6hlJD6JUqSPe
 2sDKy6DL
 XIvadMfWa5krW1TMzJRLVxFbDS90nNZiNG9QBv1/cqVg4e6aN37PVbqN5Z9Mh/H3T9RcSs79PbR3e63MO03d2y3O+ZCe9GuTOf84Nn8iTBO98xvlgnY7miGjPWsgId620QJZ5VJ+eui40+WxfYYrydLq9KEHkrpft02MOUFE0dBrHevJAm98G+h4jDIlwnmd68nQJPlYVSfyIPCAivbZZFcfi/QJimHsXcojb/qXMSJGOR6byEGt/53U91eCipf772HEy2TL6ZSrgjYqIKmtrbetzfQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Zi,

On Mon, Jul 20, 2026 at 03:20:31PM -0400, Zi Yan wrote:
> On Thu Jul 9, 2026 at 3:12 PM EDT, Zi Yan wrote:
> > In pcpu_create_chunk(), nr_pages is the total contiguous backing
> > allocation, i.e., nr_units * pcpu_unit_pages, but pcpu_chunk_populated()
> > uses it to set chunk->populated, whose size is pcpu_unit_pages, bitmap.
> > Since bit N in chunk->populated means page offset N inside every unit is
> > backed. When nr_units > 1, the function writes beyond chunk->populated. Fix
> > it by using chunk->nr_pages.
> >
> > It also fixes the global pcpu_nr_empty_pop_pages accounting, since
> > pcpu_balance_free() only iterates up to chunk->nr_pages.
> >
> > Commit a63d4ac4ab609 ("percpu: make percpu-km set chunk->populated bitmap
> > properly") introduced the bitmap overflow issue. Later,
> > commit b539b87fed37f ("percpu: implmeent pcpu_nr_empty_pop_pages and
> > chunk->nr_populated") added pcpu_nr_empty_pop_pages and caused the
> > accounting issue.
> 
> A gentle ping on this patch. It would be great to get some feedback.
> Thanks.
> 

Sorry, this is right and I missed it years ago.

Acked-by: Dennis Zhou <dennis@kernel.org>

Thanks,
Dennis


