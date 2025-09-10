Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A983ECA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 05:31:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBEBA8E0011; Wed, 10 Sep 2025 01:31:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E47748E0001; Wed, 10 Sep 2025 01:31:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D359C8E0011; Wed, 10 Sep 2025 01:31:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BE8FA8E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 01:31:53 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6FAFAC06E8
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 05:31:53 +0000 (UTC)
X-FDA: 83872218906.28.D8D0373
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf25.hostedemail.com (Postfix) with ESMTP id 137E4A0005
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 05:31:49 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vn9+cnkp;
	spf=pass (imf25.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757482311;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vqRaYitKdT9DARnP1lto9syW0RNlfsvHQXasmHs9Yus=;
	b=Df6Ze5QuaGI4I2cV7bhYp2LznNMX0PI7pHbCSOGYR9ISY+fLfR89jTgoXuCgf+9aAlcVrs
	KYm+8zm17cWd7BYmjxW2HJtApIBkAJUwOzOSR7fSQNT6kUV95mxi6fNABmit6I/asM5xFT
	kg27ZRmc90P/3GQGmHdFtmjztbnbrSo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757482311; a=rsa-sha256;
	cv=none;
	b=LP46szwsWu/XzdxjLLNG/q5F/bvNe4w+ZdF2NUxuKFWw2xm6HLqw5ZIBMFM+ibc7KotitF
	DhHxpmVWe+k8QJMDKtX4YA3DCbroiI7wWtNApyqvDQy3wb1dD4d9kPgY6EEEprovc5MXQu
	6E7g0MyeL/YajF0BClnLtSddVgzxUk0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vn9+cnkp;
	spf=pass (imf25.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Tue, 9 Sep 2025 22:31:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757482307;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vqRaYitKdT9DARnP1lto9syW0RNlfsvHQXasmHs9Yus=;
	b=vn9+cnkpi1SaJG1Ii5WaFFsQIFKaGfugmVAxpGa3C8DD4EuNK8K+TUpI3cBDhuZI+kmBVG
	hyixA+eQY+LIFIxHbB/5RbKMOtBQr5SNjhKNyksoUmFpLwV248x8966FxWhCCTnUJ7Y1NX
	yKYbGCs7MFeuaildI0pCTTG7zHhBr48=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, kent.overstreet@linux.dev, vbabka@suse.cz, 
	mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, 
	usamaarif642@gmail.com, 00107082@163.com, pasha.tatashin@soleen.com, 
	souravpanda@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] alloc_tag: use release_pages() in the cleanup path
Message-ID: <qr6flxcm5t3ctb2plabwgfyf5izcqoshl2dzhm6usp2uo5jtbm@u4zv5q7mjio4>
References: <20250909233409.1013367-1-surenb@google.com>
 <20250909233409.1013367-2-surenb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250909233409.1013367-2-surenb@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 137E4A0005
X-Stat-Signature: f6yosy3jandyt44rcmzqncojw8zqhoji
X-Rspam-User: 
X-HE-Tag: 1757482309-317834
X-HE-Meta: U2FsdGVkX1+Ckc7uyhGhYm6gbSPZ/WIz9qcACu6Ps1wd/weofINqY/VoviAFUX4OeE/RfeZCk0Fos/e8o/ZY/bq8A2FoZj9PhHIoQNBaoeaH8k5Vzgf9xccmeDDnCXBn/CoDcmkJ6Nkzymx2ZiQedYOBMDd7cUzcxnctZ5du20CDnCc19xoBsXs7GAHszNLNz1rawJUINDzN4YbfPUYXWgulRp97bGXUtdqdtr0pC//H807NpPchKHAnhsZnj7or6HDI4cQsnctlYgfVBrBvR7vHpipyfQSfrv3pEY59EoUvsTbH961bLgVRlT07AcEcEf2AGv19+3l0kNt7S5oR8XGVQjGpD27e7n8Fxnuti/uf0wSySArVCiRQ8mBpDyyxuEYIdlfitXCg+ftWMejPw/xjh8j41Y77Od/LpTJXituEp2W/W6t3/IV3HdleDKYknMo73CvTNUtO9mZ4Xj7XLTIgLcslWU2u2yLsY2vxXFET3ZGUESMlku2t7oAwKDUQGGkW8FPJyh3SLZRqzihm6HptuANb+OFKhjePdmHd392Dyn0/29psz4b2dg+lTCcNn6xdmQexsbULbe2fZrGD5pBcx188pMdB7FfD4DwN0gDn5pfKnAfbzfdSBjUgWW9R8sOBhyjpqdBVgc4uWZsLxXboFRgkt3rdE0N9hPYcUoHqZjNa3A0Nqd7EqfFIAd04r0KLjZVvVoBPhHvPYSyJCXRFEtskv3EWaYOtFZieLF+Fk8J/WTl0QX2dUAaeC0c+lPxa5v86nVwUft7oG/OGhY81wv0FVL/+ryf/CVUFL4nTzH2LNdK+vZchlps3/4osQeR3LZQDMrNQlJ6+l6xc51IdVWZ4hs6LTLcAo2++oJdEDiVrbZ0vn/4N0KlkMU6b04gIs8+q1VDhxcL/fw6m/oCBhWoaM3ZXw7iLfxi9Z3zuzMXHK3SBsJ82ad7PoVwDAyoCzCSdEfFoFalwvET
 S/Jo16kr
 /sWv02Vcsxdq8YavFZH2INbdOmsGQJ1dtN7IrAO/ak7m9yuMyDxqLx90tdt+RMq+M4+aUogJaGYIGp6vLFxnHumc/hebFNRMdHY7BBwkkQ2JUaCDw+geZ9XOPoJ/X2svr5cohvya83MMAiFsTbb2WnhrQ3fV3m03Yf10A/qM+iuLSXRVODKRktjqvwM8dFuXrIEKTfcb99tXvKOmEX3PjJwKEdK1msHvZodaBLBtRMPZ+YAT1W1nlew+TViJ7qHAX/JQtQG1kBZQ2p2doAuju6M22TJ6J6dYJUnmdqyHE/ax91Rk6qOprCb3S1BigDu/wtUuAXV9yUodjvD3Iufy5fl50xQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 09, 2025 at 04:34:07PM -0700, Suren Baghdasaryan wrote:
> When bulk-freeing an array of pages use release_pages() instead of freeing
> them page-by-page:
> 
> Suggested-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

