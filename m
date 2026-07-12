Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CB88C43458
	for <linux-mm@archiver.kernel.org>; Sun, 12 Jul 2026 09:27:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B6946B0005; Sun, 12 Jul 2026 05:27:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0670B6B0088; Sun, 12 Jul 2026 05:27:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBF7D6B008A; Sun, 12 Jul 2026 05:27:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C3C1E6B0005
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 05:27:46 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 503CD1A08E3
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 09:27:46 +0000 (UTC)
X-FDA: 84979597332.23.BF15A64
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id B61EB180009
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 09:27:44 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ka37fTyx;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783848464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eleGJpEnYFxDxqONcdE0kQSQcyi7bZFQeN5aLXAYq54=;
	b=CA3RgES+294KQEFTifJJMnpFPqn4Ak+u2PBBUqKCsbiBOSzt3WR8mz+Dlal1Kc9PoP4fjC
	Z8aCRSuKeqqeZwH7jIWmPVAhgTQOrZkDy51EqFejWK6NLYULsvREwc4D4bPVArsy2s/Ojp
	iCjZpDMcxaU661azKeHsMclT5HmIVH8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ka37fTyx;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783848464;
	b=295ge8vbOKFD+my7HCnbhdZQ7XW+ORVxYrSsxUo45aaZwrFL6sc0eJ6zegxhdnl9qAzpmY
	mnzfku5PWEFHxTdGnsku1ocN8zmtg4cUKM0tGfEPhmfaFBR2G6R7wVlF9lKBoV2WMU9iyr
	kwc1tAS0Kh3i4/QdrO6yCnfqPg2DLeU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A899742DF0;
	Sun, 12 Jul 2026 09:27:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF8961F000E9;
	Sun, 12 Jul 2026 09:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783848463;
	bh=eleGJpEnYFxDxqONcdE0kQSQcyi7bZFQeN5aLXAYq54=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ka37fTyx+JNPlw83sQi68vWVt8JMjJt2tNkTNPcKRGzmTHPEEqiJoChin9qpQaxdN
	 /rYCH6H7Z1cI4GEPWa3N05fu+XaZVbqXO0bTtAfzkrQtEVOet2dZu2zq1Dsv9vo7M3
	 g4W0NgQ6hGAIE3IRw3DjY28ZxEL+BjdyGjpEfnfVd5xtn7ieaanNN4Hgs9k2lh6++i
	 GoP0a+nUeqhZs8X1j9ldvGavcQcytsjw050iyvWcXY2kpcn6/If3pfAfmqOd7Ry0N3
	 pwIaCPMKfn8lnm7IIw/KCYQpv0rSDRJuPucmqY+wFy7e4NEG7c01WITL05nPeNZepM
	 3SCtswq0L8OpQ==
Date: Sun, 12 Jul 2026 10:27:28 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Dev Jain <dev.jain@arm.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Uladzislau Rezki <urezki@gmail.com>, Toshi Kani <toshi.kani@hpe.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	David Carlier <devnexen@gmail.com>, Ryan Roberts <ryan.roberts@arm.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org, 
	syzbot+fd95a72470f5a44e464c@syzkaller.appspotmail.com
Subject: Re: [PATCH 1/2] mm/vmalloc: acquire init_mm read lock on huge vmap
 promotion
Message-ID: <alNcMpAtslog2wPW@lucifer>
References: <20260710-series-vmap-race-fix-v1-0-5b3794c113fe@kernel.org>
 <20260710-series-vmap-race-fix-v1-1-5b3794c113fe@kernel.org>
 <d47ac961-4767-4ce4-9c75-f281beb24e42@arm.com>
 <2026071252-sweep-quirk-a068@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2026071252-sweep-quirk-a068@gregkh>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B61EB180009
X-Stat-Signature: 9e8h5if466d3fbacqafb5jbyz5iuwxnw
X-HE-Tag: 1783848464-581760
X-HE-Meta: U2FsdGVkX1/WFW0xyhCANFKBMGaOnfvGAsKWqiCpovW7YcjUW66IKPZZJ0jzO9oR0xJZmfddILza4x1kTj7ICEFBd7TVSPqDTQ4vQn73E4iDAXS2Ka6IrNmEo9nEFdt0lqidConcXHj+7gq6ZWE1Cp4HykHk44JvkNYNKRUgIhxd8tFSYAy4DJ7IUtRUw8v/LcvMZYvCN1tgFmzzwXySNd3EQNbI1Z+UJ3o605QAqMGKYbzehhRSSG2ZgzrYdDR131w6JzdFO8vBRjnbLUQXLSc78YiuPS80LTxfr+fzrzRt5iIW187gicOPyMACU9fZLp1KrGg9+0cRyOCnTstTCUB21QMJsDj+JpzheGTR+302dEqmhgoZSKaUPT6Y+AoZ3alguqZAzpK7k7tjeQkgasS10CfUL1o0s21kYvYuk18qvVsNGWioGxy6Zrj5Mm8Cv3t5ZTnaTvxqnUX4CxUeKy3ojN5S+uatNcT7i083lu0RJUzeFO4nyCYyyuy6GGwwlvo+zLvTaOjg9gQ5wx8kkm49fdckW01Fdfg0NX7wdFuDaUm30ytyg9D93bNIHzPHPKZpHxCVJZ3ut2CZ7CobXfF6T5TINVtXv1xNTGa/vOxVIngf+PT1MTs8kdMUA9+1VnDVJx+tFj9QN8Iuu/QZ2g67vYoPgMFy5CeqwrEmRoCQOiNBCpYDzIlCSWR8l1KqDpYXec/IEMoczrFYqGano5K1bTdw694DPF/zmGIdkM++2cS7krIE/prp7gJQ3mG+JteHkSXi5it7uaGFpmCaJi2hWs7obEv8tYh+PhM6Pmjy8pE1zN0OFZxrSnT/+U1KILtzVWya3v3k/f/dd4RVINL3K6FGW7nydWOrq7Fpq7fi18QfBwEcUeH1iteGn20WcfH/Elo5TFexPG81QZdkGmPur3H34bz7kCLxawFsg+/CfDyr1AH0Xstzp3ZbZqXzkfm/f7gx4TWDKUmY/14
 kmoK35Jc
 Pn/XuGLQ9hSBPjcn1z3vDeu04Vp+/BUT6dnAi54l1F+gwAQmjWnEYkbxwJIC/RTmPoooGvUIILBs9pJUsqQw6vVH5dtfn/LA4mN+VUSanAGKv5kFAG2RJusxUkljnbWenkKpc6bMZVOynGBAYV4FZ9sX5qnWee2sx8m/m9uBE86i3P9PsCBUtM2GRBxMeSFHYwVD1KPrKhhDU3af8M+H8YsohOReyxUE/d0OPMp7xhDmgy71RmRFOWeKmlxcp0mhI1e8CBL28Fyelkp4l2YsaaGHQgQRk9+svSYYpmV7v9FpcQ8S25O6LtwmblWiwjharN5azQqax885qzssH3ryz0B4OfXsqBBaLZW6xKrbB7V0tbQp6/MioXphHfe568JbNm2qsT8TGP6Up2cPIUFgDh/Son3zKShEvds5yqMpcWYG/baNEGsGA3bDBeQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jul 12, 2026 at 10:01:37AM +0200, Greg KH wrote:
>
> And scoped guard has been backported to many of the LTS branches
> already.

That's really handy :)

>
> thanks,
>
> greg k-h

Cheers, Lorenzo

