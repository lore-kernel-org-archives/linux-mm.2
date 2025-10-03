Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1243FCAC5B0
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 00:48:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F84C8E0006; Thu,  2 Oct 2025 20:48:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A9038E0001; Thu,  2 Oct 2025 20:48:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BED88E0006; Thu,  2 Oct 2025 20:48:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 382D68E0001
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 20:48:39 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C2DAE11A42D
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 00:48:38 +0000 (UTC)
X-FDA: 83954967516.06.CD7CE2F
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf16.hostedemail.com (Postfix) with ESMTP id 42786180007
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 00:48:35 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	spf=pass (imf16.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759452517;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IYhN/WxsJVmEWhUzR0BmPkh6izesvX+l7PJWbaMxvfg=;
	b=vYQ3b6hjvPhkJP7hXOPc10u80gU/X2wt9UqqD/+SKk1359RwWGMPktY3P6unA9Zg9dTNUX
	35fpETylNYfd42R06RH5j/RhBT0z0QSNYA1mwajSpjOPlN+ilbULhxRYWn66M739bxRYtR
	bZlTkHmJOlxoq0y05DKK3Meia92irqU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759452517; a=rsa-sha256;
	cv=none;
	b=yUYmAXDZqreCDDJUgsI5rzz8AHQtNQgIj4AoKtRN/WYi90Jid5+li0TlEcSwdVTYZTMgz/
	gBV4oXqG2/0aqPfp4WJkZs7XTe9I6WbSWZ8oJfl5iVKg6DLIurbuGMfEN91Nzy1porLsah
	9SCY4UGDK7h81iEPMSvP3lr6eTq4Bko=
X-AuditID: a67dfc5b-c2dff70000001609-cb-68df1d61727e
Date: Fri, 3 Oct 2025 09:48:28 +0900
From: Byungchul Park <byungchul@sk.com>
To: Hillf Danton <hdanton@sina.com>
Cc: David Hildenbrand <david@redhat.com>, akpm@linux-foundation.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kernel_team@skhynix.com
Subject: Re: [RFC] mm/migrate: make sure folio_unlock() before
 folio_wait_writeback()
Message-ID: <20251003004828.GA75385@system.software.com>
References: <20251002081612.53281-1-byungchul@sk.com>
 <20251002220211.8009-1-hdanton@sina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251002220211.8009-1-hdanton@sina.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBLMWRmVeSWpSXmKPExsXC9ZZnkW6i7P0Mg+59KhZz1q9hs/i6/hez
	xYGfz1ksLu+aw2Zxb81/VgdWj02fJrF7nJjxm8Xj/b6rbB6TXrh7fN4kF8AaxWWTkpqTWZZa
	pG+XwJUxaXUHc8EUlor2h5PZGhgXM3cxcnBICJhIvHpfAGM+m+rYxcjJwSKgInHm01dWEJtN
	QF3ixo2fzCC2iICyROeFWWBxZoFJjBI71xeC2MIC4RLT28+xgNi8AhYSB65dArOFBBIkHq95
	wwYRF5Q4OfMJC0SvlsSNfy+ZQNYyC0hLLP/HARLmFDCVmN8xiRHEFgVadWDbcSYQW0JgBpvE
	zrX+ELakxMEVN1gmMArMQjJ1FpKpsxCmLmBkXsUolJlXlpuYmWOil1GZl1mhl5yfu4kRGL7L
	av9E72D8dCH4EKMAB6MSD69Hwb0MIdbEsuLK3EOMEhzMSiK8CSvuZAjxpiRWVqUW5ccXleak
	Fh9ilOZgURLnNfpWniIkkJ5YkpqdmlqQWgSTZeLglGpg5DUV5z99zYZ5wTO9Z99q1P33veYr
	8brOW2+/9trfjBT7lxfMCrvsPh76WZpwuqNTWO/9e4e3DBURj30dW2yVfwmfjpgd8eV+kuLt
	WSZpV42iyi3X16/s2dXc+imxsMJ3p6jGnOBlPC/3uuWtyzlkfJl/86ypH17dt+oIvdz5NnL+
	9um3k6o6lViKMxINtZiLihMB7B5lSVsCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrILMWRmVeSWpSXmKPExsXC5WfdrJsoez/DoOuDqMWc9WvYLL6u/8Vs
	ceDncxaLw3NPslpc3jWHzeLemv+sDmwemz5NYvc4MeM3i8f7fVfZPCa9cPdY/OIDk8fnTXIB
	bFFcNimpOZllqUX6dglcGZNWdzAXTGGpaH84ma2BcTFzFyMHh4SAicSzqY5djJwcLAIqEmc+
	fWUFsdkE1CVu3PjJDGKLCChLdF6YBRZnFpjEKLFzfSGILSwQLjG9/RwLiM0rYCFx4NolMFtI
	IEHi8Zo3bBBxQYmTM5+wQPRqSdz495IJZC2zgLTE8n8cIGFOAVOJ+R2TGEFsUaBVB7YdZ5rA
	yDsLSfcsJN2zELoXMDKvYhTJzCvLTczMMdUrzs6ozMus0EvOz93ECAzIZbV/Ju5g/HLZ/RCj
	AAejEg+vR8G9DCHWxLLiytxDjBIczEoivAkr7mQI8aYkVlalFuXHF5XmpBYfYpTmYFES5/UK
	T00QEkhPLEnNTk0tSC2CyTJxcEo1MPq4X9//tWpOy7usH+fbgkN2LlqbXbAgX/+0s+a6icIp
	gnU3Z7JcCv/NnSZ55lWrwCXH3DArXVu+/8xh867s2D3Jmsd7XS+H52KmyJ55+YvLp1nL8yRa
	hR/K6VxQ2Hgw3vqr9Z7/QRxLt7sssZ4292NMtbZ5/pSOt3pmf+cruvZscrXZ/GStshJLcUai
	oRZzUXEiAO6chMlEAgAA
X-CFilter-Loop: Reflected
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 42786180007
X-Stat-Signature: sxgiq5eqe3yk1noheng7tkatdkcwzq83
X-HE-Tag: 1759452515-813915
X-HE-Meta: U2FsdGVkX1+yIlGopwxfRh3FvKhnzy34xSEf9vc6tZ2bthRqvCvIAiwqi4MMBqRLUTuy3mqBDfdcsZRG7vBD1PXBDCyiLjpq4zndyrfRLZAzV7XmS73F0eeHBacAhzYg3UIFwg70MW5z8xlESG7jJ/F77Nt0yTngMV4ToZtD2VGJSQ+cvv7lBttWmiBeVm869uZp9jCwJivWvDyLXJJtyANxxTZkwZvYJzqX0r2vZRlq8PKV+A1vX0cYtRPxZF8Om915KHRBjFy9MHnKwy8pKSs5r6XbD5ahaeqTx3iJP3isEvmEvU77P6uVlPtFoHurApGflPeMqHG9w/v9Mng24guLAnc5NX2XMvlJe40VcPNrJrCLTLG32li3HTwNdMJQE8VGSGLoo/yLKip0RDrmXDKDVTs+gIDrpz/OmrRIEuqR/6tRrHuFypRO4dtXUl1u3/tnvvT7mX0lQPJY0gqez8doKiUVJajjUzyCMownnvoBwmEJS23toIugKmwh3l02JZNPI8Ql2tLuOr5PmyR1ga5AfT0y9so8NaJSIpP9hHltoBzqaAd6jHh5bYImtDyRKT4OQ8fVq27w9jhJzQxoEX6ffEj/vVhAZphJdExja0puuWg1xvvrPt+GMaRJYrTkXaWJ+MkobgAReD79ZmXjfArSY/UrTMS6FNE/nhBLtEAB/Vb+P7xbsw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 03, 2025 at 06:02:10AM +0800, Hillf Danton wrote:
> On Thu, 2 Oct 2025 13:38:59 +0200 David Hildenbrand wrote:
> >
> > If it's a real issue, I wonder if a trylock on the writeback path could
> > be an option.
> >
> Given Thanks to Yunseong for reporting the issue, testing, and confirming if
> this patch can resolve the issue, could you share your reproducer with
> reviewers Byungchul?

Sure.  Yunseong told me it's 100% reproducable.  Yunseong, can you help
him reproduce the issue, please?

	Byungchul

