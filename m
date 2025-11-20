Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF0C5CF64A1
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 01:47:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEDD86B007B; Wed, 19 Nov 2025 20:47:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B77496B0088; Wed, 19 Nov 2025 20:47:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A676A6B0089; Wed, 19 Nov 2025 20:47:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 90DAE6B007B
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 20:47:42 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4879F12FA7D
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 01:47:42 +0000 (UTC)
X-FDA: 84129298764.24.954A185
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8780D1A0004
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 01:47:40 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uF2z7xSs;
	spf=pass (imf19.hostedemail.com: domain of kuba@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kuba@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763603260;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qz0Kt9BVZotF+W8b8C03wV9uEpjzU2IZVkSaOcZVd50=;
	b=O7pG6qC8YxngEXeC4rbDsgfdtNclJ6gar7E5IDuMGLoJaTuWQU3jpEVrTVlVtxJ1tn7gJM
	2x9XgOh1wXKkDaaM4fckbjti74usMNtnueu60OkYGpElCUdF7o3cELvsCmkVcnJnL1Y+hN
	7Ck8fwcZx5CNvlQzrsDPGzHOfW4MKlU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uF2z7xSs;
	spf=pass (imf19.hostedemail.com: domain of kuba@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kuba@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763603260; a=rsa-sha256;
	cv=none;
	b=mY4gOgDXCPLBOvtTOoTsOF1il717t29MJq3bAxsZTl7bpFKhWj4FZ5RGT2LBbqpq1PdZAa
	Bbgn2aiaAyJbBhoOrKez5kaSeORZIRU/RqCRc6EDUrocna34NjvTg+1iK1IW8brgBFfRRo
	3zmN8eVGPeElmJdb2jHFTUb862jq0a0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E650E43A3A;
	Thu, 20 Nov 2025 01:47:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFC38C113D0;
	Thu, 20 Nov 2025 01:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763603258;
	bh=Qz0Kt9BVZotF+W8b8C03wV9uEpjzU2IZVkSaOcZVd50=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=uF2z7xSsJBEF2o7jOCGEA8BICVnf2Ll7GN/YdEoLbs8PaQeAHioKS/o3SZ7QSxsKt
	 vFnjbh6TICH8PLye1zHlHKdpzDE5Fm345e4L/w0hg/fEJ7Itp2slYgup6C6JZwwIym
	 LLCi+QyeEmLY48F4L7ZzcbTStdyHeEENY8Hfnp0DqQrXSF5r2MrZk7t4OMHkvbN7PR
	 8Qcsuc8hp1q4+vdSlLZQjWoYyrPh5U9WhuFsg9TNqdi8dNwuUtBQRxPyNJujXI9VwL
	 mc5s7M6miwKRs2zV2Elwkq7lUfoGg+X1KHfkkxDDXD+SynQUk6oIGjhckD0gmUEmi4
	 nBJOVjtHwyLhA==
Date: Wed, 19 Nov 2025 17:47:34 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: david.laight.linux@gmail.com
Cc: linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
 Alexander Viro <viro@zeniv.linux.org.uk>, Alexei Starovoitov
 <ast@kernel.org>, Andi Shyti <andi.shyti@kernel.org>, Andreas Dilger
 <adilger.kernel@dilger.ca>, Andrew Lunn <andrew@lunn.ch>, Andrew Morton
 <akpm@linux-foundation.org>, Andrii Nakryiko <andrii@kernel.org>, Andy
 Shevchenko <andriy.shevchenko@linux.intel.com>, Ard Biesheuvel
 <ardb@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, Bjorn
 Helgaas <bhelgaas@google.com>, Borislav Petkov <bp@alien8.de>, Christian
 Brauner <brauner@kernel.org>, Christian =?UTF-8?B?S8O2bmln?=
 <christian.koenig@amd.com>, Christoph Hellwig <hch@lst.de>, Daniel Borkmann
 <daniel@iogearbox.net>, Dan Williams <dan.j.williams@intel.com>, Dave
 Hansen <dave.hansen@linux.intel.com>, Dave Jiang <dave.jiang@intel.com>,
 David Ahern <dsahern@kernel.org>, David Hildenbrand <david@redhat.com>,
 Davidlohr Bueso <dave@stgolabs.net>, "David S. Miller"
 <davem@davemloft.net>, Dennis Zhou <dennis@kernel.org>, Eric Dumazet
 <edumazet@google.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Herbert Xu <herbert@gondor.apana.org.au>, Ingo Molnar <mingo@redhat.com>,
 Jakub Sitnicki <jakub@cloudflare.com>, "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>, Jarkko Sakkinen
 <jarkko@kernel.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Jens Axboe
 <axboe@kernel.dk>, Jiri Slaby <jirislaby@kernel.org>, Johannes Weiner
 <hannes@cmpxchg.org>, John Allen <john.allen@amd.com>, Jonathan Cameron
 <jonathan.cameron@huawei.com>, Juergen Gross <jgross@suse.com>, Kees Cook
 <kees@kernel.org>, KP Singh <kpsingh@kernel.org>, Linus Walleij
 <linus.walleij@linaro.org>, "Martin K. Petersen"
 <martin.petersen@oracle.com>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, Mika Westerberg <westeri@kernel.org>, Mike Rapoport
 <rppt@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Namhyung Kim
 <namhyung@kernel.org>, Neal Cardwell <ncardwell@google.com>,
 nic_swsd@realtek.com, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Olivia
 Mackall <olivia@selenic.com>, Paolo Abeni <pabeni@redhat.com>, Paolo
 Bonzini <pbonzini@redhat.com>, Peter Huewe <peterhuewe@gmx.de>, Peter
 Zijlstra <peterz@infradead.org>, "Rafael J. Wysocki" <rafael@kernel.org>,
 Sean Christopherson <seanjc@google.com>, Srinivas Kandagatla
 <srini@kernel.org>, Stefano Stabellini <sstabellini@kernel.org>, Steven
 Rostedt <rostedt@goodmis.org>, Tejun Heo <tj@kernel.org>, "Theodore Ts'o"
 <tytso@mit.edu>, Thomas Gleixner <tglx@linutronix.de>, Tom Lendacky
 <thomas.lendacky@amd.com>, Willem de Bruijn
 <willemdebruijn.kernel@gmail.com>, x86@kernel.org, Yury Norov
 <yury.norov@gmail.com>, amd-gfx@lists.freedesktop.org, bpf@vger.kernel.org,
 cgroups@vger.kernel.org, dri-devel@lists.freedesktop.org,
 io-uring@vger.kernel.org, kvm@vger.kernel.org, linux-acpi@vger.kernel.org,
 linux-block@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-cxl@vger.kernel.org, linux-efi@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-gpio@vger.kernel.org, linux-i2c@vger.kernel.org,
 linux-integrity@vger.kernel.org, linux-mm@kvack.org,
 linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org,
 linux-perf-users@vger.kernel.org, linux-scsi@vger.kernel.org,
 linux-serial@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 linux-usb@vger.kernel.org, mptcp@lists.linux.dev, netdev@vger.kernel.org,
 usb-storage@lists.one-eyed-alien.net
Subject: Re: [PATCH 00/44] Change a lot of min_t() that might mask high bits
Message-ID: <20251119174734.5cba3f95@kernel.org>
In-Reply-To: <20251119224140.8616-1-david.laight.linux@gmail.com>
References: <20251119224140.8616-1-david.laight.linux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8780D1A0004
X-Stat-Signature: o6ehmeqgzxczom138ez9azsk3pusbq9k
X-Rspam-User: 
X-HE-Tag: 1763603260-238770
X-HE-Meta: U2FsdGVkX190EgZ6weCGNFNY7Q/mNZvoJGJIpkB4gC4wWggsSraGL84DZNlinbawJAGCVE3gA9QeSjS0HVux0G4aS7yCUL5DD4zc+6kht5icVG7yl88ZVK02DPuOCmZAfY61p1cRHkK5tWsCaVhBr1u2maQO0fpudDf/gaptJUoyIydehBJr/UNJqHMkkN9Dx8b5j7KeRBxy3nFegSrshRZ1QKo7O2QTq086CJod8JEa8qffDfOrd3EopZ5dsde3Sv/3eUe9IUhKzlr1ZqZansI+ifTrqgDjlZOx4z1l/AExK1/4jg0W92N23eCC7BEwNbSIczwbxnDzTpajX+Zp/1gvlQKEm92Mf4xd9j5X1P3EbngXcMs3AJIpmiVJoyTLXQHTWOQPZDAirWZ05mnUmxe3eXfK5oUagpekNdd5Hc8xHStdeaCPu2vxil4XYkQ6vkTrOjAlf/r2Gch2ViR3K/F9ETYwOioiurztEZ5vOGRv57srQ/3q/U+fZuxbhP+FJoPsqp9pt4ShugJzwPAjQBHhY8ZFCbGh5dm6gK6+2pUFgy7Uwrd+ZpwvBi2IpzV0iy7yrOBo+5sgM9N9rl6BkC4j4Vozobg2MXHQ6JkOSCC8NIWq1pOEt6CjYXE88zAKo7qHzAsskBAx0vI4bsyMurx2/eaDW6Fi2cNuOx5Hw+/o+4jpW5ULLHeGBfY3YXN1gDY675PDRlGZE0MPGXrjHBLiLrms83Q3leBf1eM/hDCE+pcKS8J+U33Hx3RxQUd9CU5ZXobKI+jCaCC+QghWddOwd9ruqQT10hLMP1CjGQsB3qU672Cgecxkkzw0hood97NgLQEAHIby3zrQCCvjNApYXx5O9Lz7nuqrhZrYkbXrKQATcNLi1dMcnmzEqBfIoiBqueZgcom2OqzFkNIkl0vm1MCZNab1bKy1XSymyuCFHmSc9bTJpb1vYxSjjjP5feeQj4UtxuRaG2QjeUG
 caK9R108
 bnFTftl3u59U4I/JYKCjY2NXNaW/u5tCD3JxeRgzhGoItd0WEFcYINm3RdSHxXu/Cexpa1shzIGeX4yzxatgeNVrEH0qzKFgrgjAxB4gVosPupKfA+Q9CmKDKgab5wFH+F7rrsMbb7j3yt1F20qyGk4zUqiDhmeaacsRbPYJen6agUZ8hQqVA1CWcxUC3Ly3WQFbW4t2EKzc25owOJOXH+w6zw6EU8eA28zyKqToTNQTqxG79vu9uiF4h7Mf6NY1Scijt/eJsPuLAUWB12WZx7X6Uk1vK4GaG7MvrUcjEJ3knWaobTtusrYPvSWhchc19nwu4IDy24/EQ7Oq92DQVCgiRxueMG2wq3JSFJ3pyE3jY0+lRx6w69OSSGUdcnF78v9uMxIIVvs+7KNU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 19 Nov 2025 22:40:56 +0000 david.laight.linux@gmail.com wrote:
> I've had to trim the 124 maintainers/lists that get_maintainer.pl finds
> from 124 to under 100 to be able to send the cover letter.
> The individual patches only go to the addresses found for the associated files.
> That reduces the number of emails to a less unsane number.

Please split the networking (9?) patches out to a separate series.
It will help you with the CC list, and help us to get this applied..

