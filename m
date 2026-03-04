Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03BADEDEC04
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 02:28:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4151C6B0088; Tue,  3 Mar 2026 21:28:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C2EE6B0089; Tue,  3 Mar 2026 21:28:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D4716B008A; Tue,  3 Mar 2026 21:28:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 193136B0088
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 21:28:53 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 99C2D1C3EA
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 02:28:52 +0000 (UTC)
X-FDA: 84506797704.08.0939735
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 083874000A
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 02:28:50 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=spjB+qe8;
	spf=pass (imf12.hostedemail.com: domain of kuba@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kuba@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772591331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wKj0ybLQ7OTEX7VYO4UYrqVGHCViOoCZ3KGzAf4cs5s=;
	b=SQv4aEdpRmTPitof5fGHl5dFNzIcCOvhnKnxCVPshjEvNxiNwYgUD5dZ6VcRHoHkzccXVP
	DECSEXD9/yH6Kx+m9MDRqSYx22JxMXbI5pIHKbh64bFjzILEq1xWsY5N2XftXv5BdHoIFA
	fePQxUwMutvg4dtdc9S/qTmz7TQ3LLU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=spjB+qe8;
	spf=pass (imf12.hostedemail.com: domain of kuba@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kuba@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772591331; a=rsa-sha256;
	cv=none;
	b=28bIvWdTe2oTG/SGWM1aFAW3oJx+jHyfnKuiPAUGLdvnZra9UI4ku8Hq5ik7y/BDhxNxSr
	ipQ+O+Nj8+tRHkNE+4beJlN57zInWW2tjvR/OIYhdQVIgA+BFW5GCg/xByURDTIKUCDb3d
	RapRtt1DIgVtk2jK2eO/RapT7Vs3GN0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 41CFF43A1B;
	Wed,  4 Mar 2026 02:28:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB983C116C6;
	Wed,  4 Mar 2026 02:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772591329;
	bh=w0enNDJ6vj/GjKs1g6Qapybf69Y+ysKOpkctiG5RrpQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=spjB+qe83UoElqhhSNfGwtYNBZK6rgflA8nN48IzNFPIWPeUr3QRcXVdCtF1NJKnf
	 z5EksqVKhftC9MLC9j/7nGeIaaTR87yGm5Rwd8MxIRtsUMKdsilMMJ3Cd9iakxj8Bd
	 EH9ATACpJVqsf4PLZG7kLZaviIgPJnXRNiYRro7z9N/ZFYixQx9IlT7mTSxw717b7C
	 FtZrlDgcd81FIPR+0JhvBn0boDgv6oQAtRyqPocimgjFVPbqTR/7W2RrWO0jyc8Sw9
	 QZEusDhvc5/gFZA6KC6+NigNLVm6yl1rbhBl2iBivGRlsjsn6q5oZHNnRRI6Qq4pAT
	 NJF9zxNmgNh2w==
Date: Tue, 3 Mar 2026 18:28:45 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Yury Norov <ynorov@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, "David S. Miller"
 <davem@davemloft.net>, "Michael S. Tsirkin" <mst@redhat.com>, "Theodore
 Ts'o" <tytso@mit.edu>, Albert Ou <aou@eecs.berkeley.edu>, Alexander Duyck
 <alexanderduyck@fb.com>, Alexander Gordeev <agordeev@linux.ibm.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>, Alexandra Winter
 <wintera@linux.ibm.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Andrew
 Lunn <andrew+netdev@lunn.ch>, Anna Schumaker <anna@kernel.org>, Anton
 Yakovlev <anton.yakovlev@opensynergy.com>, Arnaldo Carvalho de Melo
 <acme@kernel.org>, Aswin Karuvally <aswin@linux.ibm.com>, Borislav Petkov
 <bp@alien8.de>, Carlos Maiolino <cem@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>, Chao Yu <chao@kernel.org>, Christian Borntraeger
 <borntraeger@linux.ibm.com>, Christian Brauner <brauner@kernel.org>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, Dave Hansen
 <dave.hansen@linux.intel.com>, David Airlie <airlied@gmail.com>, Dominique
 Martinet <asmadeus@codewreck.org>, Dongsheng Yang
 <dongsheng.yang@linux.dev>, Eric Dumazet <edumazet@google.com>, Eric Van
 Hensbergen <ericvh@kernel.org>, Heiko Carstens <hca@linux.ibm.com>, Herbert
 Xu <herbert@gondor.apana.org.au>, Ingo Molnar <mingo@redhat.com>, Jaegeuk
 Kim <jaegeuk@kernel.org>, Jani Nikula <jani.nikula@linux.intel.com>,
 Janosch Frank <frankja@linux.ibm.com>, Jaroslav Kysela <perex@perex.cz>,
 Jens Axboe <axboe@kernel.dk>, Joonas Lahtinen
 <joonas.lahtinen@linux.intel.com>, Latchesar Ionkov <lucho@ionkov.net>,
 Linus Walleij <linusw@kernel.org>, Madhavan Srinivasan
 <maddy@linux.ibm.com>, Mark Brown <broonie@kernel.org>, Michael Ellerman
 <mpe@ellerman.id.au>, Miklos Szeredi <miklos@szeredi.hu>, Namhyung Kim
 <namhyung@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Paolo Abeni
 <pabeni@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Paul Walmsley
 <pjw@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Rodrigo Vivi
 <rodrigo.vivi@intel.com>, Sean Christopherson <seanjc@google.com>, Simona
 Vetter <simona@ffwll.ch>, Takashi Iwai <tiwai@suse.com>, Thomas Gleixner
 <tglx@kernel.org>, Trond Myklebust <trondmy@kernel.org>, Tvrtko Ursulin
 <tursulin@ursulin.net>, Vasily Gorbik <gor@linux.ibm.com>, Will Deacon
 <will@kernel.org>, Yury Norov <yury.norov@gmail.com>, Zheng Gu
 <cengku@gmail.com>, linux-kernel@vger.kernel.org, x86@kernel.org,
 linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
 linux-riscv@lists.infradead.org, kvm@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-block@vger.kernel.org,
 intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
 dm-devel@lists.linux.dev, netdev@vger.kernel.org,
 linux-spi@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
 linux-xfs@vger.kernel.org, linux-nfs@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-mm@kvack.org,
 linux-perf-users@vger.kernel.org, v9fs@lists.linux.dev,
 virtualization@lists.linux.dev, linux-sound@vger.kernel.org
Subject: Re: [PATCH 0/8] mm: globalize rest_of_page() macro
Message-ID: <20260303182845.250bb2de@kernel.org>
In-Reply-To: <20260304012717.201797-1-ynorov@nvidia.com>
References: <20260304012717.201797-1-ynorov@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: u46y8q784hi9g8koetmzkuncsnhr9tp8
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 083874000A
X-HE-Tag: 1772591330-906600
X-HE-Meta: U2FsdGVkX19DFwlz2KKeqlYqoPl+Nw+P8dKfLWypLocUyXJtKEhljVER5Fmyqal3z9MOUpUbhIuszM7wBKkO6jc4qL7KXlGRUYZ/baZDcBS6Pj4Cu3WBH0lsJmfnhx/7mYecxR8esnJ9wHqm7x9KL0gbhRfrSHlDNg2i5dt9HpV4CbToZrH9WBacMQmVwwn72E1OlsBg8dcQtRRHyC9EeZcRJx2HkIj4R62T8hQKx0Wm9alg8ir29pptLHYzn08KuPUSSnfl9JI0Io1xvH+031rsBi2mTAY52PIk7BQbUKb4G9ImjbSzVTF/whx/VS325olt6i+XSyOokFFiKahoTkxNxPb1XyH2RNEouzh+9NMIq8/9D50oFvMzSYNv4jLlqCpoZ1EmRVTGF0aXikQFY13EcBG1MfAsiqQ+oUQyWrFFqWkxZVnx0IgZNzx1Ut6U+RAAfjO0eg4AHabI99R+JHAydroTsPiZOXQ5yYgP+/iZ6+oRW6jyEbQolNoo0fT1b7LE60LzZvI55ueDiwLVALortkBDaCAYXVbMlh0Oi/6LKypCcxfALAvVthKaFD/7RyyZkUZDeWGXfSgjrykbBncsIj/9Z4wVzMdjhgit+v628M0wgCdpEV97SOJK7f8jD2JPiIAddBYpJRf6vXEzqRg7ww5ZfgKjJaurLPtwgHjOBpL+rzJ8BhJLJ9GH3wy8Ore1u9SrKK7H2hZmdmx/yQXwoUG5RW6aPyNB/PIOw2U/pKv8ZMPIEpSZoQx3t9Fr7jDt/wXP6fEj9Iaibc/+Jx+kGMAyuej5TSjkxVBYzuPcYXaTHr1JTY0pefV28Z3wvlNwgQTKI3dGIUmuqIOFpYoQfnxHe6nS0L+K4q8Tz+/EloTF9jhXpZ8RCjNU3rNxfwQ4f418yMNBtaP+JaAZmkgENf/xnmzUmQEpkyw2RyoIaDFS0cderuWQXWpX6p0V5YCx1W2B6R2+u9P/A0D
 wwR/zFQm
 dqWVoY4/GokYmu4z5c+7ZmJPeyb3npzGlbimtmnju+t0jW0XAD+9Dm9T5+Yd7g7cc4127olxSu5xpMFVP81ONXoqW8w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue,  3 Mar 2026 20:27:08 -0500 Yury Norov wrote:
> The net/9p networking driver has a handy macro to calculate the
> amount of bytes from a given pointer to the end of page. Move it
> to core/mm, and apply tree-wide. No functional changes intended.
> 
> This series was originally introduced as a single patch #07/12 in:
> 
> https://lore.kernel.org/all/20260219181407.290201-1-ynorov@nvidia.com/
> 
> Split it for better granularity and submit separately.

I don't get what the motivation is here. Another helper developers
and readers of the code will need to know about just to replace 
obvious and easy to comprehend math.

