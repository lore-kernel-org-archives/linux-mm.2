Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40715D711C8
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 23:55:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8AD806B0088; Thu, 18 Dec 2025 18:55:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85AF76B0089; Thu, 18 Dec 2025 18:55:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75D8E6B008A; Thu, 18 Dec 2025 18:55:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 627346B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 18:55:54 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0F7851A0178
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 23:55:54 +0000 (UTC)
X-FDA: 84234252228.10.1CEA283
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf21.hostedemail.com (Postfix) with ESMTP id C11911C0011
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 23:55:51 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ZbcV24Wg;
	spf=none (imf21.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766102152; a=rsa-sha256;
	cv=none;
	b=4dBpBNNmGcEEreKZ1fdPm2bUhLdcvCizyzxRY9fGb4A1DnXIlinIgG1VTvd/imux5TpeyY
	PMjW3zi581pA2j5YELFYoh5H2KXXrMluHKRcayDWIl4f3dQK9GONBViBSkDQ95nAd1nmdw
	w4VA1oxma2cqIrcpZcn5oYj/k8WTaGU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ZbcV24Wg;
	spf=none (imf21.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766102152;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7cRVqnT8PTUMlTtnuPb2AQO/9hbRZw65ZP76rwPKE1c=;
	b=elHJnc+05pVDFUPfQ7tK9je/mrZmb/X429kZDCsWYB6UcGSegofsSuHs7yJbLAVvAam7tV
	be1GrkQm7C8GG7wItDOv0ziL6Lh6Qz7lfotuLk+8SPg53pMme0E3IDnXDrpCJwQwxSrACs
	vq+iM3HDLulHdgol1BtWzhnX+mpu1hc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=7cRVqnT8PTUMlTtnuPb2AQO/9hbRZw65ZP76rwPKE1c=; b=ZbcV24Wgo7Invnggx+YGo10U0g
	k3Ub4BJrrQa42JxRBq96N8u/lt8QnaRuQKEZSbbOyMmN+0C4UZwldBfY/hO6YrfjI16S60uGKuM1A
	0L6m3Gaw7TJAQXzI7OpRr+PvPANWq9zqF0akdN9OXWvcLJXnLF7Et074WQGVOXmliS2giqShr3XK3
	DL/Mmw+9Cd6Hgh7D3Uof0XxVu/HZqJA8a1IKUC9ziMswAfPqyiV2Y0T5wAq9Yn2YAEQC0nkaHOYR8
	ZaUGlkLxMNXInyg43Wi8eUrZ8DmJCnVPqpJmslzV1UlMScm21UBqSrceem92beFSb5PwcbEa0laZ7
	0yF+f+8w==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vWNqN-00000006ngf-2n65;
	Thu, 18 Dec 2025 23:55:39 +0000
Date: Thu, 18 Dec 2025 23:55:39 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Shaurya Rane <ssrane_b23@ee.vjti.ac.in>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Meta kernel team <kernel-team@meta.com>, bpf@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	syzbot+09b7d050e4806540153d@syzkaller.appspotmail.com,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH bpf v2] lib/buildid: use __kernel_read() for sleepable
 context
Message-ID: <aUSUe9jHnYJ577Gh@casper.infradead.org>
References: <20251218205505.2415840-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251218205505.2415840-1-shakeel.butt@linux.dev>
X-Rspam-User: 
X-Rspamd-Queue-Id: C11911C0011
X-Rspamd-Server: rspam04
X-Stat-Signature: 1dcxyqknz5qqupt85d3z58ib7dh8tje9
X-HE-Tag: 1766102151-246685
X-HE-Meta: U2FsdGVkX1+9S891G9SSBYliZXiPmLsoSMYhPXpPVDuQCS/mhjsJT89nZfVGJt3auYkqxTD5lxsMIQay7LS0mWb8OdYA0wtOTB51BYFfTWLVynr5epG9S0zf9BXcnXGf4iADgumFA418elWmtBDO7pdhK+BY+WZnrm4xes9sNF7Z+q05clGB9DRqdSgdmz6DXHJLjOHDg61Xd/SNh3VpKubZuj/D0yVR1fdvkozspodr7HMvnMlpfQxIqRKQxGJ53k5y/bK7ltVL/a0MFy84hgcQPpEtxombOA2Og4D6M1W6UpZqEYWhKki4oM8hLaJfJ+RYxsbW1GPlRHV5weFrhqvnZOaw/BEoSM8ifh4aZ8EDdxZ3H8r/SE+ay3T2Zo8EZTsQnyJeB8DNgIHwvp9taypNuSLLCZ9nAiDwo147sb4gmfd5r7NaH9JKxSyg+C+Qy2BeqETzvvM388dLkLRakuZDorYQu5KGl8w51UsoEij0745YUAg6ZzKWXkKtp8RYyNvALfvpx2j8o6nliwrORJdhXKBdUBClRaGjR3Xlm7xDNquRZtVGeV0aKpfr9Lx6asDt5XDoqaePrxNrOtaMlwaGQTWzSww7LGnzXKCdwGtJ6L+L64oXlejJI7xd94GkhnaO1xH+VQIum7fqpex0kgXFX0p00qB9Q+7ZhyPuD5j0s3uVU7E4fsl9h/uepAH18tRZi82kKTvPBjgs3BGfnJ6n0UkGPyBYQ5SIXsXneaU3rc+x31k+bemGoIPZHuPuoon+XV9HGQctplgpY1iC4/hhASbaoIJXekeB3gl8wA/cRGZYGUd7AhQMMMUedHIERSstIO/YL4R6CF1YPxscFUHPseRJ/5DcmHNVnnRaF6LLNt77RRAtyCbAJ/ylZ8CnS6HUGPiYOu2ONtzziWObVDrmpuZsKLU3MdazZQGTXx9nmND7oWS9dvxZJX3CT2wOSh/1uFWXoOgN/LmU6MP
 UFeBMTw7
 BabmdyZcbWbzeVEW3chX9SVbzp6A1EZL79cbN6HM9QcyaQ1JdPHbEVguR1ugL+X+ohyNdydH1rpgW0cudu21xeJazdA+G6nj8NhtMO0EFnEbAszaEHinTqlPJT5bOHIouiJGH9IwkVralmGbClbq17RYvVG2nSaWowBGDr1V+KGuCmh6Ja5zAiHNpMTtAoFy6wfW+19Fes50gWNScm4BxoE+8AJ89hoXbwARbCH3RmFwwSwkiPYAGbY37jG+0XPUurg1hZNPNV6EUnSRfUL8R4uGYqI1YzF3fsnf4igcPgZEVxmaSOVaRVJJnIsihRon5l2KyKgADm9IXe1E5R1+bRKpcxT8QdZMyPzfNbyVbbiPx7ugQaZ3Rg569cuAylgfQ24DD1XbD7h4CJkY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 18, 2025 at 12:55:05PM -0800, Shakeel Butt wrote:
> +	do {
> +		ret = __kernel_read(r->file, buf, sz, &pos);
> +		if (ret <= 0) {
> +			r->err = ret ?: -EIO;
> +			return NULL;
> +		}
> +		buf += ret;
> +		sz -= ret;
> +	} while (sz > 0);

Why are you doing a loop around __kernel_read()?  eg kernel_read() does
not do a read around __kernel_read().  The callers of kernel_read()
don't do a loop either.  So what makes you think it needs to have a loop
around it?

