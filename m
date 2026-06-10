Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C34BCD8CB9
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 09:54:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE1396B008A; Wed, 10 Jun 2026 05:54:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B91A06B008C; Wed, 10 Jun 2026 05:54:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA7956B0093; Wed, 10 Jun 2026 05:54:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 969196B008A
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 05:54:24 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 37466120949
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 09:54:24 +0000 (UTC)
X-FDA: 84863542848.04.A204F30
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf21.hostedemail.com (Postfix) with ESMTP id 937DC1C000A
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 09:54:22 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=jH67hAAN;
	spf=pass (imf21.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781085262;
	b=D3kv1F7+fuAYRXja1w0o8SzYJeiYhI5Q/g5OPrzFPqy5UPyjmvbyvYLo6rdcIwjole9vYa
	Pk79x/GcWuH0hCXiRD7xitTUzGk3EsfO2hwqS3vO1pRHyUuY9Tr5CVRLtpUFfIPP/K0hwX
	K8YvspvLa0W9YvrJA9lcK97vpzKXoic=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=jH67hAAN;
	spf=pass (imf21.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781085262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WJ+oozuTPWZxI5kixO5e7S8FM2lyDR3C9rSQw3An66c=;
	b=nSugsG+QluAURENKP9eldtV2G5/m9Y6KW45QARfx0Ez5l/aAWYLnYAdOMAcV9oGcUmASDP
	Tncu5NQiSUtTlj+ZxEVgnALu94qpYwTzGZYLkHr0xz5Eu12SZKG4TDrPcZNwng+vw1dm7E
	hNILZvfSXl9fmpWDUgVAOe2o+1M/bpo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=WJ+oozuTPWZxI5kixO5e7S8FM2lyDR3C9rSQw3An66c=; b=jH67hAANF8wuJYBMqz+qTNr8+T
	nORRSP5pvnJJPbq5vwen1ZKCwTaW0SEbxnHjxJLzGVTBJM+PIWeXD4P1At/BzKrvIgotviRRpS+8g
	7nhaiWFOrrg8OWXQBAEM9PYMeCgg5S23Y3cx4YqzHUs1UQyPSlLjbBngmrAkVBgCZwxE9UMe7Ckuz
	XTy7BcjWOLSatFNmIjq1JmYPpB7j17bCoRVouLW5hy9fG1B4SUyE4zroqKZqNaYX+mWJYkfMzqLKg
	AFWQA4DMtBH4hodbla/UBBN0qaG2+ifF7eHoK1DcAUT8OvNtBYyQXwwoic+fNS5hK1Z8zeYe5McY3
	twfitMzw==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wXFdG-0096hL-1t;
	Wed, 10 Jun 2026 09:53:59 +0000
Date: Wed, 10 Jun 2026 02:53:52 -0700
From: Breno Leitao <leitao@debian.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, "Liam R. Howlett" <liam@infradead.org>, lance.yang@linux.dev, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v9 2/6] mm/memory-failure: surface unhandlable kernel
 pages as -ENOTRECOVERABLE
Message-ID: <aikz-gW9DHeyrksy@gmail.com>
References: <20260609-ecc_panic-v9-0-432a74002e74@debian.org>
 <20260609-ecc_panic-v9-2-432a74002e74@debian.org>
 <174b8d76-5514-4942-af5d-c975ff95ee03@kernel.org>
 <aig7jzwDHfVCxikl@gmail.com>
 <cf2bb24e-9341-4ded-b238-064dca442a92@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cf2bb24e-9341-4ded-b238-064dca442a92@kernel.org>
X-Debian-User: leitao
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 937DC1C000A
X-Rspam-User: 
X-Stat-Signature: zqwieohek6fto76snjfg67i3juffq34x
X-HE-Tag: 1781085262-980898
X-HE-Meta: U2FsdGVkX19a9h4C15oV8Eiol/dzTk8nGKePCH29TVoWXThDl7n7Ng2DmmYQuXKcgEuo89obMMnhxOjwunN9UHi2+92ltjt2NwwrsT64gny6bPYRf1Ge209ZPQeWBtYHYVg2fZksHIdJyPnNZBw4e1bS7HsPrastpLf4EHxn+xgu/TBqqZlHdLH+a1dmTlMXpw1m+3ryenPt6EuCvKEkOcQsCLLiN+ZRl++tFDZcOmOf59LTlUNNm95DHIAAuyB8WcHJhWx4PoVK1MBaK/z04DV+G3GxlRdpqZwvVkEGJSoREnmNfKvt0itraWdhkcvc/yDigN8EWjG6rnYu9aRjChamvXWX8sxD2NvBk0xT7XAvP2Cr/COx5Uc+E+g3dTwLaTPnFnMP4KRGWzYLtrzFP1iLYbpgr7OZOQZmWaSyzWIuxLjGbesKP3lOZF3TI4Xg5E+1skXNDaYsykYB4OL5+HqV3OJVL16kSojHP3jGKbC4/JQQLEGkcWEB+kJ7ISFrZZui1V9ard7PERyKZodWVZiWfmzqx5OmVmHDqie3UvoOcWrmFZxC1gZqhLn33sOTfjdd2iGw3SCauEuTBrCSokuX8gQAN8f825F8o9Gvg7gIBw7mGfPVzE9cm1h/B731vfGaSQBCpotKiFeCO139dds3FCnLOT1jUWxUYk8hzxQRNE7fpv6CDs17n1HUwSpB++yjAtAYgCR/i/zRdPEf/0p+qxSsZWhtkMISEEBpRNsbJu6Qlbwpaa4IV5gPuO49+yRQguqpn9s4ZdL2sFzrPVym5O/O342vBFPI7CAgAvaEShr96m2u3C7PKumzOx3Q/4hyf14MigySErhpYxOO4CkkXevTKOGZQWxWh0Kt37sUMU0h2oJ4LQ+yg6psfMD4Eip+qzQYQz4/u6aYHMum8wz9MNJfsEdiFguvtqWB0dst3XMDoXHDM7+58z8iE3pG95/ayXYZMcR1EA79QHI
 nklLppag
 na94Gn4ET8iuaiSfgaQTbU6CPPriUvHxUB5/X1b2Frwjd2FAmwVf3tDmGfcOSw7s2fu+K1q7hDhsLU8vzbKXPBuKzT7oEFmQVpS+ZX6umLKhQash/Ise00cC3w6sXmhy3mForwc1Bi/B+ShFHdwNHwMP5BfUvbJzwhbym1jF2IP3L/frBRLhqQcZPg/Y1QXXqsgrhE+uRTs9fARWGaP1huXcW/qQV7Xfewapp4GehDGEDAKwnKVUeCj4JmmWaKwD3eQ92gmD/9ibQHTw6f9GxK5+oocBXtNud7P/pK/MRCVDHUAS746lakaQJidNXDF6swKYdBMZNZ3xFtW4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 09, 2026 at 08:41:25PM +0200, David Hildenbrand (Arm) wrote:
> On 6/9/26 18:15, Breno Leitao wrote:
> > On Tue, Jun 09, 2026 at 04:41:01PM +0200, David Hildenbrand (Arm) wrote:

> >> a) HWPoisonKernelOwned: this is not the common style for us to name functions.
> >>
> >> is_kernel_owned_page() or sth like that would do.
> > 
> > Ack, I will rename it is_kernel_owned_page()
> > 
> > In my defence, most of the functions similar to HWPoisonKernelOwned()
> > has this name format, and I got this discussion earlier (with Lance?
> > I think). Here are the similar function names in that file:
> > 
> >  * HWPoisonHandlable
> >  * PageHWPoisonTakenOff()
> >  * SetPageHWPoisonTakenOff
> 
> Some of these probably date back to our old way of handling page flags and
> things, like PageLRU.
> 
> But we really should stop :)

Ack!

> > I will update in the new version.
> 
> Thanks! Probably best to wait a bit, the merge window is coming up either way,
> so this will have to wait a bit either way.

no hurry at all,

Thanks for the review,
--breno

