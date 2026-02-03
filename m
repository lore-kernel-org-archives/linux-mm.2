Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35782E87846
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 16:18:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8750F6B00A7; Tue,  3 Feb 2026 11:18:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 826256B00A8; Tue,  3 Feb 2026 11:18:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 721DE6B00AA; Tue,  3 Feb 2026 11:18:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5F2766B00A7
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 11:18:41 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1DEB113B268
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 16:18:41 +0000 (UTC)
X-FDA: 84403653642.04.EBAA2C6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7BC5F180011
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 16:18:39 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EPw9Yz2e;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770135519;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6T3Az5ve4UBbIJhUKrG9rATlOgWfWRksnYXGgxKSvYE=;
	b=RCaX3EquIcLpNLg+HgvYIqrI4GZQqKTY5F0gV6yzsKpYEvmr2SIeJ+eje55q/qqU+aEISy
	/Wkzsraw4HevaWo5p2Ej/w/I7wV2TZ1xMXXtOYakuN/0D0N4qSdYX9oFydIet9Bp3Pciv1
	w8z1m66hGm2FFkWb8Qgdrf7Zx1IAf2g=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EPw9Yz2e;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770135519; a=rsa-sha256;
	cv=none;
	b=Ekwfnd/gOKjNv4OaaLvj80cxFAveYrisSxqbZqpt2J20bZsYbJNgdjCSib0NDo1swGy+iC
	ohUa6T+Gf+kTJ7Yg4rvoCiS1WHiYwNJSJj9pnNxAmXc8eln1ztZwiTELC8uRKYnst2PRUD
	sBnuEaGxBmTmYJ4UdeKADkrPb0CeRVA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CBCCB601E4;
	Tue,  3 Feb 2026 16:18:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A752C4AF09;
	Tue,  3 Feb 2026 16:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770135518;
	bh=t+xsjeWFVLSKurDj7D5PeSnLdx1mHlEer5mWWhx0m+4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EPw9Yz2ewWsZC74qCWy79KV4zsVshB9Iq/hOHPwXPkby4iTb1vviUNVI95rFWf+uW
	 d3hT1L6a1m6W6qTyXU2sKIn7mU8YNOXSr6UJBWZ7KLLSeda6byFvzEaWEmiQnFtR5I
	 FcwctMmaiENipUcr0hLmua/ZZmMFm1FoGCiTdB5aZDdGvML7fHQsnp6HZMZ2EliVjp
	 //DSe/t+woW8eO9F0uWmzJEixjW5kYCuzIAO6mLNPnFVKrsUNsMQEb3y5deWlcCSNU
	 Pw374nkEBvZmDZYfQgxTpcCkTT8upXMyHcnw75bd8l9gRG5Yo1itUkBqUWxeH7kMaF
	 oeQ9nePc6dLqw==
Date: Tue, 3 Feb 2026 18:18:30 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Jason Miu <jasonmiu@google.com>
Cc: Alexander Graf <graf@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>, Changyuan Lyu <changyuanl@google.com>,
	David Matlack <dmatlack@google.com>,
	David Rientjes <rientjes@google.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v8 2/2] kho: Remove finalize state and clients
Message-ID: <aYIf1hOQzG6xuTAA@kernel.org>
References: <20260130005739.3163049-1-jasonmiu@google.com>
 <20260130005739.3163049-3-jasonmiu@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260130005739.3163049-3-jasonmiu@google.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7BC5F180011
X-Stat-Signature: 13i33ywm1ysutxuyunhna5eftpo5gzsd
X-Rspam-User: 
X-HE-Tag: 1770135519-481840
X-HE-Meta: U2FsdGVkX19rI0ZYRAX6d8LPCP+n64opSz4Hxhe9ruhCSQ3ORo6k4BAlPmbwu4IcHbT5jyHNSW/YkER5NchoeZTcB3eoe8BSjhu9pGnLz5tPCV4XSpOpmEKwKlaTyG71553Hzq3FKlObqf9tup6IY4AAa6WXNdYCkfjp7DGbqzeYuGGVMnJCHPz5JOLR4oCQUf+/f/BKRckOYUFuRG4yj2lKBvNESvLjDfr2z8J0xkCxlcDenL9fY/WV5HsN7NiCBGcj7xmLKJmq1zM/qGkMVF0eoIdHsGcR4IPrlMdHN8WVcjPT/DCTU4QCDrIeHUwKLtsrdQu7rm8nGPSv72Fuk5GazUqyqEaqEyC07gd5GCfDFzohCy0rGH31l6/G4NuTukb5+2yLNaD6WVzOjF6ClwDYLM8mqqZ4SA7n2qEhvjQNg1Bz06bXOxepo061rtk+f+MTsiF6IXsOiVo/qj0q5yyKPOfGJUdCBsJ28Dlpx0A1JBgR8ELYgJ7OhXHkqpxBz0Q/EI5ft1Mh5Nbr5AO0iFifFiip/9qEShsVoy/BnqYCDqH4PHCQsCiKMgz2iMilGu3LZbwvVEMHaFx/uX5aj8G03XL3RvjifaGQIiKpYWO1UqbOO2nv24aTrXU5R7DpORK8EyvORv3McB9sG6By/6mHSGjBliUrL9ecADJHu0+Q5ND0sgBc13rCXwzljSTmT5Bfo4v2nZg51DljZqtBj/kJ1nkyMY0hC532YP/VLdiEueBXUJlJlAnj0S8WWWp7dWHizvylZ1hSHFfXMpCGag7eI56TvzsnazdI15BQsDoZqQERzCzEDvsg9MRHTLVMEcncqZ6s1GrTBcBh/LpL6ylqmDHoq7k4nOPLP+j9l6rcHJqwyWzYaw9aTrPb0GsttikVMh0yRasiYQKY7uhWjnncBu0OWpjxKOlA9c1MKkC19iI39xlzUi+nNi0Qywsu1udKTBYgjME9tI2bhpL
 ut3a2VXZ
 7WpbUznOpZGygZoFcI/aanFT7TlALFUZLWvYOFF9kvtOJn/8lt60Ydq69eScVBKqG9LCoved4vtQtrEnKGAUnRXKsu+9Zt9yLkgM6jS9P/+/RKx/OapEQvwJoKZ08xyNOa3E3IkaeCz0NeQY0BaZojLOifx7AsLprRjFSEFMGgjMi1hUDZtq3Tb7fWLxbXdN95YbPHTesl09Mr3YOZa5V+evgPE3UmrqPx7oekYY3GJtovX6pxNbb56WF20Mbs8ARP1TmTK5QTbI636ts5tGobW+3JZ5p2LVStC9oiaY5eYNpKEQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 29, 2026 at 04:57:39PM -0800, Jason Miu wrote:
> Eliminate the `kho_finalize()` function and its associated state from
> the KHO subsystem. The transition to a radix tree for memory tracking
> makes the explicit "finalize" state and its serialization step
> obsolete.
> 
> Remove the `kho_finalize()` and `kho_finalized()` APIs and their stub
> implementations. Update KHO client code and the debugfs interface to
> no longer call or depend on the `kho_finalize()` mechanism.
> 
> Complete the move towards a stateless KHO, simplifying the overall
> design by removing unnecessary state management.
> 
> Signed-off-by: Jason Miu <jasonmiu@google.com>

I think I already added RB tag :/

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.

