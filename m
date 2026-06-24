Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFF70CDB47F
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 05:54:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93F866B008C; Wed, 24 Jun 2026 01:54:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F10F6B0092; Wed, 24 Jun 2026 01:54:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8088D6B0093; Wed, 24 Jun 2026 01:54:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 574556B008C
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 01:54:53 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AAF121665BC
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 05:54:52 +0000 (UTC)
X-FDA: 84913742424.23.BAE615E
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf22.hostedemail.com (Postfix) with ESMTP id 18292C0002
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 05:54:48 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MwlMk1Wn;
	spf=pass (imf22.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782280491;
	b=Vqp52RBuOt+aBV9hiwBQBug1KMASqPYeiAC10XjlCF76q1yS105X7EVcs+0VKBGLdP1XAB
	tEwn9ZTK+J9i8qomfhsAz99Dnjs1ms/0nhaoMc8uSMli1jOxxJqjUi3v56wrUze2elxk7D
	mT/gWrGRt35CIyuAamEHXXHpYslVJdY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782280491;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4+yfwppAxv6grV/iuiLbt0kuinxwy5HNYFpZxLDSMSU=;
	b=cyVNGo1GHCqpwIMouSCaXxEj3QYk8TbopuF99sh2WJoeZadR2KCaJhJtD5lbUeSM1MEAr9
	SJOf9a5ufHDLewQhYCYoYM00XVOwYraYIHbns9pQvLUhdgcCF32J5NIolEaiJyI0Q0Y3BJ
	zF2UJRWDG9Syvo059MP/H1e/kJLzHWg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MwlMk1Wn;
	spf=pass (imf22.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782280486;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4+yfwppAxv6grV/iuiLbt0kuinxwy5HNYFpZxLDSMSU=;
	b=MwlMk1Wn61TpGLRz1AMjptjMw5oSKHIbdyTCthRtQugqb/2wqt2msnSb/EasAP5pLVVXrm
	gUV/NGRVY7vo8g/35PHzAv472PgnZ3lageFFbX/gFSIckXyOWqY5ga77snS/WV2+COeC2D
	aW/W2KD80ku1OI7NrchSq5gcsoPj4YA=
From: Lance Yang <lance.yang@linux.dev>
To: igorpetindev@gmail.com
Cc: ryabinin.a.a@gmail.com,
	glider@google.com,
	andreyknvl@gmail.com,
	dvyukov@google.com,
	vincenzo.frascino@arm.com,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com,
	akpm@linux-foundation.org,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH 1/2] mm/kasan: remove redundant initialization for kasan_flag_write_only
Date: Wed, 24 Jun 2026 13:54:33 +0800
Message-Id: <20260624055433.5971-1-lance.yang@linux.dev>
In-Reply-To: <20260623114743.4565-2-igorpetindev@gmail.com>
References: <20260623114743.4565-2-igorpetindev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: ngoc1exrgskadhu9ta9nhr49dkkpqb5b
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 18292C0002
X-HE-Tag: 1782280488-136700
X-HE-Meta: U2FsdGVkX18Va7LSRSJG1yjNp0zffjbaaWRhoSHlo3IV+YQVguzHiMLgMIoz8wVzYXHOp5Np6H93lujV1U829esgEXnJ1ln7lMCybpYWzr0ypasPr7AXxkK6vz4asP9vP9lGfvjiYAhAWHBOSF1pboXmlZ2Ggf1SLulkQHPgvA24rGRYiztQ7xhiK1mtHnEIRkERlXtVylddyU0qgqgeCEdT0aUZLOhOLR7AHdxbyXcLXuCSdtKQk5GZsqSGjFQq7FLrsb9ejcurW+WmpFqv6Im/pxTp+1XUjgAEpediKmYwRi5E7DJWWvn0dYSWlf8ajaXGuF5FCvZBJPJHkNHNO+E2l3A8NZZORok9kv8mXnQB/dkO86eNVwrt4ZHGEAWSH8Yd7hOVhGR+ivKua3sgzKFrQAd4YCXA2neypalQwiWWozZu+tfbKRfn5XsNcwkcmK+XgBmRaXph6R5L0TwDIPb/gcIqiQ0OPShwIjfEoFlLLhsXIx4j91nfBFmm/l0tP4r0V7O+lDZgtwdDOrUA9vP9Hggfqkh37Y0IcSIqJfOB2Eksg7hv2QeUntn68aGsjw6IG/L7u1ihKb5Aom2O0y7yBx6LtqTQp+BVkRasYJP8oGGN2LEKXHMMQZbVwYAshmSaNNsDC7+/NgEfmidziBfeTxrcJqbL7vQs/1kQSGvYeSNN8YDEeO9oq3H5zsedCNj5QAAWMpynIgHj0fxXkTwDDlmGEk+eDQEJAKAuaKsWMgJzHA2huEcWrZ8m9o1KbXHOft4GLS/ASxOqrPK+OUmSvyErHIyRFFMVfcs03L1/nEaZVmHiwkoTs4x/I+Jkdye2256U/9WKtMQhZDyraTxEbE1H/02eM31QS9gZvBOgf2vt/6GszLEncfq+SKxVQOZIy4CfQeVJxVGeYCNf+qG+LkCaR3tBgjNiwX7tXAugRL0K4CQ8SR5oTgwOClei2kRzUOjRT0wq1qfTe+q
 4GRu3x+T
 lc6TgzJA0iPKt8XOSmhjog/N9lVCq2AzxaR8hfxKv55mIXn8ZkfOn+uYWBD+ckX1FFT55JL+Y42IcjLPPMj3UvWeZBUphE92nlKtDzumsQ3Y7Eino9rGmrlRQemTmnzYdsHB5UuPMB0Dxd0AJcNGq2Co+eXzUbMFKxgzxRkZzWKPL8MOxRo5J03tSrut0/RFGf2IVUDeGQm23l/PH13r1QAccEul5d60Y5sbDg41M9oUF48IzdTk7mWpC6C/MCUkSPwjofwdg3ycqXALiUjuJxUSmZp3XNigtWcBfgkXFhfv2EtqBDYyN4IkBbraV4MOaW/f8piB3DUbWubtjpTNliSlG4tRUipK5YcEg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Tue, Jun 23, 2026 at 02:47:42PM +0300, Igor Putko wrote:
>The static variable 'kasan_flag_write_only' is implicitly initialized
>to false. Remove the explicit initialization to follow the Linux
>kernel coding style.
>
>Signed-off-by: Igor Putko <igorpetindev@gmail.com>
>---

Thanks.

Reviewed-by: Lance Yang <lance.yang@linux.dev>

