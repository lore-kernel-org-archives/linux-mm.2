Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D75DC5CFC1
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 07:39:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 511196B00A3; Mon, 17 Aug 2026 03:39:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EDA16B00A4; Mon, 17 Aug 2026 03:39:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D7FB6B00A5; Mon, 17 Aug 2026 03:39:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1AF156B00A3
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 03:39:02 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A5F51806A3
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 07:39:01 +0000 (UTC)
X-FDA: 85109960082.11.8B81AF1
Received: from mta1.migadu.com (out-192.mta1.migadu.com [95.215.58.192])
	by imf31.hostedemail.com (Postfix) with ESMTP id 7A46920004
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 07:38:59 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fAvcBpgW;
	spf=pass (imf31.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.192 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786952340;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EH4tDs/d5HwbhZaxavUhyBAHCbild7wYmuQeNMNmXvE=;
	b=jwAWVxfF0Ur98gfJUr7nPdKUbL8cjhixJ2NsCS066oMWW2zNeBdVNUjhjUb379Um3OYXiv
	csLV+uwtaMCu1Iwiy+B3WPhYzzxCjWUu8It+jXWoRX0IS2V5Q4X1twkoL0hAqkU9nXCaMt
	cyishfcIvXNWQJUU7qbvfBTc8oZkUkM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786952340;
	b=1PZ+7dsBZAkbou0xyaJD1pDLbvYqmawQeChKAkFvK9nBmc8p95d/jcsP2ZrZ5E0NMlnZpU
	6vCTMhcy3b6RHvjJO3OqVDM6el3uaT5l2Hlnofh12lo4gycD8USk0r/okip3bjGTsXMu0c
	6x7gnggw/5PUXh6bjS1Q49lIjMPvQjY=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fAvcBpgW;
	spf=pass (imf31.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.192 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=4YGgPm1wRAd8vr5pINF7lmz4ylld4f9QdvgoaXgstqU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786952337; v=1; x=1787557137;
 b=fAvcBpgWs9Qhdx7zHtKnZUXvfc/e05DuB4q15Xv1X+jwe+C46Lm3EPm4tKh4HbiLhY0WPHZz
 fCRoZh0TZ8AIvHNOq9yFFoW01YnLM0RpKwrFqMBgf9Q4bAB8p76tY9E9jjwbc/H6patvuooZwSY
 X96L28T3cpxqUz2paePTR0c0=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (3.112.29.171)
	by mta12.migadu.com with ESMTPS id 17e9312474d067d5;
	Mon, 17 Aug 2026 07:38:57 +0000
X-Migadu-Flow: FLOW_OUT
Date: Mon, 17 Aug 2026 15:38:53 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Lukas Wunner <lukas@wunner.de>,
	Jan Sebastian =?iso-8859-1?Q?G=F6tte?= <contact@jaseg.de>
Cc: Jan Sebastian =?iso-8859-1?Q?G=F6tte?= <linux@jaseg.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Dave Young <ruirui.yang@linux.dev>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, David Howells <dhowells@redhat.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Ignat Korchagin <ignat@linux.win>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>, Mimi Zohar <zohar@linux.ibm.com>,
	James Bottomley <James.Bottomley@hansenpartnership.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, Eric Biggers <ebiggers@kernel.org>,
	"Theodore Y. Ts'o" <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>, kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org, keyrings@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-security-module@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-nfs@vger.kernel.org, linux-integrity@vger.kernel.org,
	linux-afs@lists.infradead.org, netdev@vger.kernel.org,
	linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	dm-devel@lists.linux.dev
Subject: Re: [PATCH v2 01/13] kexec: add CRASH_WIPE_SECRETS to wipe secrets
 before kdump
Message-ID: <aoK6jXA-tF9qfKOZ@MiWiFi-R3L-srv>
References: <20260811-crash-zeroize-rework-v2-0-9561d13c2340@jaseg.de>
 <20260811-crash-zeroize-rework-v2-1-9561d13c2340@jaseg.de>
 <anw9ILJiO5xIjP4f@MiWiFi-R3L-srv>
 <9765f7ea-36bb-4c7b-a19b-7facec97b762@jaseg.de>
 <aoGpcczo5GkBsPwt@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aoGpcczo5GkBsPwt@wunner.de>
X-Rspam-User: 
X-Stat-Signature: jxq36g9t993d7eeog5ux1fmmd8kmbr5g
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7A46920004
X-HE-Tag: 1786952339-639661
X-HE-Meta: U2FsdGVkX1/R0VG/sksy5GwaoW4B4Uujb9u5ST7koiN0Fs2zeiHZtarHbLp18IgO/MhwiH4N0Gv0hgr6MG2QuM/HFQutJq3dgpiLSdJPtGtiylxunm1wHKHKv5/f/kELxFycBCkQ/EwBLgHTXsK3i0pEGUapsIX5yOCsCwrz7w0j9SL0ek//e/tXwGEWiJXFyM3IHtN/SW8azhWAW6cIo3ONf9IedmEmjc5l2iqOZuF+oozRqaCC2r4CHU6HT+ftR96HIbujTEu8WCOgHavmBI1Cmep3Lw3uAX1qTJQAKFa6C/QfMRlCNZlXf09Zpchs1PROrxyVYpuRg6+rc2GRVFhHmmKNWHa8/nTTe5Pwdcwd4cDci5GskNfWSI5pANAnzqtFgfE3dtquR1Nd/Yaw4aTHR8rPcJLS4HBg+faqbwGxQnFqP9PFqbwoqXnUTM7RF1p+rt7B1/VAXb9aZYKqYNvNAMBTeRYJrV/wrLstKUNDA3L4pa5rIrL+fyyvk2q4SSKy77Nt22CUBv5/HGfRNWbE95f2dAIPtLz7PxY3gXVSPvGb5XalwcQihf112llU8A4tljvuCBn+w8toKAARPzYY2I1iaVWmw1I0lY/DK91qQlple8KysIaLajJRjSUDykvbN7MWK7PwfjNAWf1BunkAq7T+9trBxYTeFuhvjgqse6qfDyc2dNnQkmqeI+V7x4w5k7G/ZE+5YYjnkUdaLb8vZuXUjViueiWBCnWHXpGh4shJNVcpdbkFkAXEqo7VrQVC7tTrCeufRmf37sRqvXfOZ99LxFpyrX+cV8OO5w/VNubhs76nThjKRvC2ElVxqddpvBVOdD8UAFXf7Hfh/3Cg/nX9haHfZbCXTuZDO8q5V4HmksgOGxfOl0tsqmnTJOwSLhYH/5WsU7A8Sw80k2132nqjQ/EGn8JrJvh+efdAdqMcKKD0nmtQ5i7vPjEURvZJJQYntyW8htZkGrl
 Ky/BgsoR
 6PHqTPgVBVka0gEoAhWOcLIpdjRQgvUYw+Lj8EJanxhwZQNgpS/usTEEFL92LAsDfpR1McWg1CIbQPnV38a+Zp11BmVYRLDUvUt2IP9AQ4SEnYdu0j20U6t+5aHAXRJG0WN/FFloEmWJfHJE5aLNsjUBtF1jCXdPmVidVRBaQyZScmDiJTLAKCdQGAFwSLJdPEsqeQNqa8g6hKjNYeZCGR7UIz7nJV5CjChMccpWgQQ0r2WfUTSBOLQInYQW12h6qcCvR/u/fx+bgap51qP6Tg98EeumHqETgeyHAFpuCGwAQOb266PPHXd4ZvDqQoAPz4q+VX+b9ylkOYkfXQIdcO+Vt57/aQG9jn8Omfta9o/29MljWRoS/wMbJPaK+IzsZg9JESY09LsoE+k4Csv4axsGxhQLlHD2uKTysWSPEtt5xKEd7IsE0gP/T1dx9B9y1iOPdBgWkDGdjYS1+KDo45SuwLVeCtl171fd4NyVPjr4E3zsfCGdKm1qbfOFM84Ubu81ZKoBNUKLq4WWgq+cbi9yaKB0S5kP21BtR6WWn7/EbQE9gg5x8w7FdGX1TDCrbpOj/3XiLsU46zl6HfJL+MApw8A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/16/26 at 02:13pm, Lukas Wunner wrote:
> On Wed, Aug 12, 2026 at 12:08:39PM +0200, Jan Sebastian Götte wrote:
> > I can imagine one alternative way to approach this, tell me what you think:
> > Instead of registering wipe handlers that memzero places on panic, I could
> > put an optional registry of (addr, len) descriptors into crashkernel memory
> > that the original kernel populates with the PAs of buffers to clear ahead of
> > time. Then the kdump kernel could do the actual memzero. This would remove
> > all code from the actual kdump path here. The registry could be made
> > per-core to avoid locks.

Since there are a lot of security expert in CC, I am wondering what's
the risk if we wipe secrets during dumping. System is located in
user's place, and vmcore is dumped and collected in user's place. If we
filter out secrets memory when we dumping, what could be leaked out?

> 
> Or create a dedicated mempool from which all sensitive data is allocated,
> then call mempool_free_bulk() on kexec to poison everything in that pool?
> 
> Thanks,
> 
> Lukas

