Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61D1A10AB838
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 00:50:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7D3F6B00A3; Thu, 26 Mar 2026 20:50:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2D296B00A4; Thu, 26 Mar 2026 20:50:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6AB46B00A5; Thu, 26 Mar 2026 20:50:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A848E6B00A3
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 20:50:56 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3DBF0E11B2
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 00:50:56 +0000 (UTC)
X-FDA: 84590013312.19.C2182A6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 85FF620002
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 00:50:54 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Dsd3gqOS;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774572654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xyu5go0hoonNipiox2cEMMKKVMnTXInaSisBq+zkiXY=;
	b=MMFyUGQMBFdbEJMVGXI4fDp6sUeXcHgtRwiZ6M9TE7f+sZRRBiBU2xAsX/mPnDQLMTLtZ9
	Z2Z0tFtJE4SEKCMZJ+F2a3EPHpZgovXLPByrFF0/KipqaAVh0pHiGwuXuVBuS/AUBTtQj4
	tYskJITlrW7BRctCCVIGwbtO4+jTw0g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774572654; a=rsa-sha256;
	cv=none;
	b=ig3r1NI6QwaHujkUoWYB8vhbFk6gt4torptHR324GJ70jpf6Rs0dwnCrl93x2Gv3PRiq7v
	5u5Tt/NOD8xEAsxCbWpK5YdU4Sm9Ho9+Ysrw55n2WMhBKUad0P4bbiDOJklZaKwmYzyKkc
	wSXNVcKLu0VVQExQZgbD5JsA7JrKfGk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Dsd3gqOS;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A9A77434DF;
	Fri, 27 Mar 2026 00:50:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54271C2BC87;
	Fri, 27 Mar 2026 00:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774572653;
	bh=KkXQvPzPwbE2ulwwTtCgJ705N/C/D+U1v1MM1+vxmYc=;
	h=Date:From:To:Subject:In-Reply-To:References:From;
	b=Dsd3gqOSRXZ5UsSv8d3py1AIUe+z3FVQfH0fFjtGWfXn6vhRptl+6Vl8d4aLxzr97
	 4MV9awn5Lk+G+Zpja7/4+grOQ2pMIBw1JS4QCpT9Ap4jUBjRA4j2GV3PCmpnFpo3C6
	 r0vMaUGt/Lwb4F40XPw19lgEkJ13Fxg2BA+GotHk=
Date: Thu, 26 Mar 2026 17:50:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joanne Koong <joannelkoong@gmail.com>, jack@suse.cz,
 willy@infradead.org, miklos@szeredi.hu, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v1 1/1] mm: start background writeback based on per-wb
 threshold for strictlimit BDIs
Message-Id: <20260326175052.06871e1fe76af965a114bb3d@linux-foundation.org>
In-Reply-To: <20260326174237.0ad75b578219aad36f137e4b@linux-foundation.org>
References: <20260326234629.840938-1-joannelkoong@gmail.com>
	<20260326234629.840938-2-joannelkoong@gmail.com>
	<20260326174237.0ad75b578219aad36f137e4b@linux-foundation.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: rm15q4o63qaexe1yefqdr8r8ws31mqop
X-Rspamd-Queue-Id: 85FF620002
X-Rspam-User: 
X-HE-Tag: 1774572654-579753
X-HE-Meta: U2FsdGVkX18mEsuBIJ0ugZmpwIRK71jyb3HBfcMQKVLtbt2uMgbT4eqXkRJrOYn6beBdgdE24X5N+Jz8GRff1HF3V5hqA6B/SmoqwdvvzGmo1jnk67EHTLi/rJPLUZex8qgEK3LvnX6zm0x7jre9UhEuYpKcuM473SsK1lCKfze0ObKJH21FCixWyW8fG1G1WM+N4qwlqqtRQg5RdFqPPl03zzuD6izAWZnVbIoqvY4dFl8ZlZtvlfYm5AXPEU4/ndvlS9JbTQvG3xI6Hp1HLQgOpQAd1Shuz0UhBS9uNyqWYVkl+LJVegMl1JBry3DerW8JKfGe8RIpoTxadjuUVw7RdIsvjPckQ57DjOmRD5BjaMW0tALnoPf7pe4SxzCXH+2ogsCsdySYxJ2718AllGOd4xIJsTqERGuf+1ty83U3Iy53giKolUTfMeQc+A3Nz0vunmTBlZU821KuNIrhw+GjqB9erHbwQmW9LzmI5SL8ndinpomFsi9UEkYodBYTWhzlDTKybKXsXbuW1J/HmglUEptXNXB9UdER3XuJmNhdUFBi72jQ41mtcbl8vye+hnL4NCLZ+a4MrtvZj0bcKGBchLO3yO237+2MZnOaIgvg6hcaz1eOUn8y0ymuyTjei/OStcdbWP9LxWIHWRdW8F4ULyD3MWO9vhGUvYz4K+Gzz8Vv7A5/GH6iIy4NLzetvXkNqbwvR/nWkCj5PtSLsDvNUWzgh2U3G0UglebKf54w0z8KcG3CZhA8slgya79d3GQeoRmqb5MRc2a4O18TJ30Nd9LRALV/1WRwF7b9XdmC2uPh1U92gMCtIY+BwcO66JkJjCmycyqArK+ipAdJm7lNf1G/UqtX6TNosnkWIDy2pjEZgeLpCrz38scmLDyVooqfLb2O0lfGbWLhQnqItM0uYkfbLVML6a/Avrgb5/baw5wWwoa/Z/k6akhck00epHC9EkMBhe9Z309PZpR
 8uYSyRkZ
 1vu3KUqPGQJka+yZCnO2mz39mqEsbkoYivrdXZMOqlkPpGoDg2J8VveOO4i2xKWh9/V7ZjDBj6G1saC/W1bAvVVNUYwIyrHBRNej6AniFNG/FVIpSnIaYomauww9CQZvqJ094C4heDsfsWmaWZuEzx1YPlRTEFle7dF8sqk7C4dDTfWU6vaiUAUm+w6QQjem8Q7shxyxMXFLR0NNPSOlb8DV4dc5sb8chvHXzaKNo8S8pOdMXFKerfDm11YXJg0ofVI6KEobkfALeyw5raLkUc5IbJxUhY23HrJYoCUMHnDgXMmETOQNCAT0wVA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 26 Mar 2026 17:42:37 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> > fio runs on fuse show about a 3-4% improvement in perf for buffered
> > writes:
> > fio --name=writeback_test --ioengine=psync --rw=write --bs=128k \
> >     --size=2G --numjobs=4 --ramp_time=10 --runtime=20 \
> >     --time_based --group_reporting=1 --direct=0
> > 
> 
> Thanks.
>
> [bunch of nonsense]
>

argh, sorry, I didn't read your [0/N].  Ignore.

btw, a [0/N] isn't really needed for a singleton patch - best to just
put everything into the patch's changelog.

Transient info such as "this depends on my other patch" can be placed
below the singleton patch's "---" separator.

