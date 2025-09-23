Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C749CAC5A5
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 22:35:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C4088E0007; Tue, 23 Sep 2025 18:35:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 774688E0001; Tue, 23 Sep 2025 18:35:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68A268E0007; Tue, 23 Sep 2025 18:35:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5461A8E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 18:35:14 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F35BD1DFEC6
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 22:35:13 +0000 (UTC)
X-FDA: 83921972106.03.5A78768
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 51928C0002
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 22:35:12 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NfvKLIEC;
	spf=pass (imf10.hostedemail.com: domain of kbusch@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kbusch@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758666912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K+REPAt7YGROMU060Sut8pDiJmmKCZ4JFkal1RQOmGs=;
	b=8fG2zNlxCclnrn+InF23r8uuD2A2peWTCOtvVaEERTXbz3PQ3zWmFtQ8efKXYToMpAdt1u
	TkWktZqR7Dd41t5Odmci51uiACz9pz5WjOS3aSiieeggteXJItVxHFv4NSJqE0FKiRBqno
	TiK4lWxBPydJQFzfe06Lz0bwtpDyUw8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NfvKLIEC;
	spf=pass (imf10.hostedemail.com: domain of kbusch@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kbusch@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758666912; a=rsa-sha256;
	cv=none;
	b=o819icRHEZ205oMqJfMRAoALe+iv7zP9VUvhmd2Ak52Dn3SQRg7gsUFVIz2dDnfvLMM/D0
	BT+4q7aYr66sGIBkQcjaRyE3/zEiqurP+c9oeLcYIqW0orqUCgePwXUiT3SCyxrvKwnSWa
	sR/ovcBkMY69/kGj7Ov3YKXHIrxWJGI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 34F4144593;
	Tue, 23 Sep 2025 22:35:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68E0DC4CEF5;
	Tue, 23 Sep 2025 22:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758666911;
	bh=K+REPAt7YGROMU060Sut8pDiJmmKCZ4JFkal1RQOmGs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NfvKLIECePVJSfIsLMzuzmM3Lfkth90P9jpbucNQ1bDMKtxnUUxV5JFtKuhdhpmWb
	 Cw3GZEX3eQpIT/PWZ/yXnZMG824R5TCQPjlm98ugF9huAG8DeaThH3gkBcbwr/TZuE
	 vm/De9fznWxi8yL9W3hbwpzVsdSjYKdJINx4sFLGsP2083YAha5J9C5fBwD4MqMtXT
	 ir+xFYNttlpYqZZmrRAZCSLQPAaJ5po2rCCjv7hee+rH9n2nEI6G7JOlhDYZQf0/X1
	 1DkImokD6CqYRTWU50ZSiWc781Xdx+oofE6BqZqS50/4CeH67G98lYY+2B9ZA6UvmX
	 2kJmK3McZDdRg==
Date: Tue, 23 Sep 2025 16:35:07 -0600
From: Keith Busch <kbusch@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Leon Romanovsky <leon@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Abdiel Janulgue <abdiel.janulgue@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@lst.de>, Danilo Krummrich <dakr@kernel.org>,
	David Hildenbrand <david@redhat.com>, iommu@lists.linux.dev,
	Jason Wang <jasowang@redhat.com>, Jens Axboe <axboe@kernel.dk>,
	Joerg Roedel <joro@8bytes.org>, Jonathan Corbet <corbet@lwn.net>,
	Juergen Gross <jgross@suse.com>, kasan-dev@googlegroups.com,
	linux-block@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-nvme@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
	linux-trace-kernel@vger.kernel.org,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>, rust-for-linux@vger.kernel.org,
	Sagi Grimberg <sagi@grimberg.me>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	virtualization@lists.linux.dev, Will Deacon <will@kernel.org>,
	xen-devel@lists.xenproject.org
Subject: Re: [PATCH v6 00/16] dma-mapping: migrate to physical address-based
 API
Message-ID: <aNMgm33W7gh75h3t@kbusch-mbp>
References: <CGME20250909132821eucas1p1051ce9e0270ddbf520e105c913fa8db6@eucas1p1.samsung.com>
 <cover.1757423202.git.leonro@nvidia.com>
 <0db9bce5-40df-4cf5-85ab-f032c67d5c71@samsung.com>
 <20250912090327.GU341237@unreal>
 <aM1_9cS_LGl4GFC5@kbusch-mbp>
 <20250920155352.GH10800@unreal>
 <aM9LH6WSeOPGeleY@kbusch-mbp>
 <20250923170936.GA2614310@nvidia.com>
 <aNLnXwAJveHIqfz0@kbusch-mbp>
 <20250923222216.GC2617119@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250923222216.GC2617119@nvidia.com>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 51928C0002
X-Stat-Signature: nyfkq6kbkd5etq8bosin3tbcorbbpy87
X-HE-Tag: 1758666912-392831
X-HE-Meta: U2FsdGVkX1+SAbcUU4cMtHLP11O7v/p4lNg9sujb4cE+mV6x6OFb4ijpDDbXCMofYIflr7QTOQyZwLxK9DZMvU77RvgKJNplxjNkfx/rh9G8py6U76Os+/8hfGl63nGUQ/v5c8hhQIqlxmdfshCIafh4AlSSvLVQ7BW6M2eB0dRb1qJjqC4RqUMkbi3ZrSUE+5wkY7agQePWRDHYyrZXd0RmAt3DovA0HmugnrNhw22N+JxcpfmEw+O/o56JiNbqw4c3Sf1fp3lwASUBzhNtAftJZigvzszPhFGhGHh9VOwNC6r5deE/lBVR+kHi7ena3ycuI7QQKQQQjD9D/ho/54wTb2PSa/lC1VDgK/Dis8OXQf4pDVeJEulnMNMuiGSObUKXWEyobFGFsgzYAnnqC7XTDiyLvc2pex+DKc3JBWfIjdWK5H5PI4Of4TC7zmg/3QLsd5XPJcTERcOF7x8t0nXsOKQUiIGZX0RMPk3fxXszDvF1SnNhI3KTt1S1wjz4iX1gNxK2Ekh81Sh7Vs4om9jP7kvn5rOCAtB0pYjRHJs5trakT5F/p8hQMjXTAoqYY7hH20luUZxnYWZHvrc6+dpzjmG7z+cYmCqPARGvnXtAtC2k0FL5Wvd6eS6j0xFcSUmgUVP7jtP568HdUJ9Md81hl+baLLhkgoj+pEkR3s9ZPznVpqPAI/LV9KcKHV9pHECW2ifF7PDE5X9o7ZMg61qqqGLv9YnmRUtGkeCw0lRqzncwNVKAz+r4JfmYZflQek+P72QkxuroshIOQ28SV7T2K37sPtWOgQSc96mCKxaB/NTqetGRZyjIEh7Yi41zJEqV49Fyc09ohP6icEcLBlgn64ArmUf3vJ5RdVF0FeBIgHUUhL70YneK8McJOIsjWjJrbQ0FwHUe0BJ1gT0Ndnjvu6AIlBDQxNzw/t4A55og3hyYrgUWl/Ilj7LGZpy7X0h2Uy6umyeaqN38LZV
 37lATKkY
 iJeJtCSuP8grHlRkeON9nprwHelQ9/YVbd5qwtJdbSgUj0dKQGKch6LnOQ0j1T6tlTfFSnE5EuaOqot76DuoWiEGLSZFcf/9FTSxiKlkWNVJX/omyjYlNPKQmcwDDCawQNflBGsIWsA7A2cdIIiJnps4hCbeEkpiTVRPricnLGNGMLGEJbqfqb5a1h6iR62yuNIrrAxqg4cOfhcKI/B8Tfpd0LkP1OFHd0UUYyDvLGcFpqU9GNpWGGuBGSdArRxJDv5R3yQi3f4jT9SHInlV5aLkQyB0GpTaV7f46yv4zw6V4SCSLvmVCrXY0GvhzOY+xiHoDCvAMKhn/q8O+ufoE9wm4I+kiddijvvNR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 23, 2025 at 07:22:16PM -0300, Jason Gunthorpe wrote:
> Very rare is a different perspective, I mis-thought it was happening
> reproducible all the time..

Yes, sorry for the false alarm. I think we got unlucky and hit it on one
of the first boots from testing linux-next, so knee-jerk reaction was to
suspect the new code that showed up in the stack.

