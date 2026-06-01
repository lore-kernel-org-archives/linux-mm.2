Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74C12CD6E55
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 13:29:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C45AD6B03A3; Mon,  1 Jun 2026 09:29:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1DC26B03A5; Mon,  1 Jun 2026 09:29:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B33DA6B03A6; Mon,  1 Jun 2026 09:29:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A117D6B03A3
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 09:29:42 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 718581C1E28
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 13:29:42 +0000 (UTC)
X-FDA: 84831426204.03.F21603C
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf28.hostedemail.com (Postfix) with ESMTP id B9BF7C000B
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 13:29:40 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=m1Yh3jox;
	spf=pass (imf28.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780320580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+R2lfmP9pQuhindin4fShCfv6Ae5W5y5CMwyefGW9qM=;
	b=51SpJgcF0Yx/rySJv7j+8b2qOwX+4gNnHqP7xoxWi3WDCddYDB5gmvP5koe44VTxLCgP4j
	m99VN3zxTtqP++12t46AV/AFnRhSda3UTudzxuoWHbLRNGYkmtc+ywIjJ5WaLjT/BNtqX0
	aQ75E0SKDinRacFCovm/pP9GrmWYN6s=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=m1Yh3jox;
	spf=pass (imf28.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780320580; a=rsa-sha256;
	cv=none;
	b=A93ZRA7/OS9mBjvKyH5NhceNf5edHdg9BS3AlxF9UsnLoBHrC9XucU+sCdxbtAOnlp8PR1
	5ZLt+l2lWfAglKGe8BXf0lZwtAnsa73mycZi1pCwe7OEbuQx5CNJtZmOkMWGdRd1xT14m3
	491Iatd9+e+jw4kGIcNedB7a+4C24NY=
Date: Mon, 1 Jun 2026 21:29:30 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780320578;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+R2lfmP9pQuhindin4fShCfv6Ae5W5y5CMwyefGW9qM=;
	b=m1Yh3joxqmiw1IAgN5b5XCYDJXluJDZqHpQameYZaGvpUex3E0DhnTy/xabw7QGBh9xAWn
	U1x5wTtQMBXTmQRkoE067IAoZ1XKBj5pKi0Z6b8l4XIowWr35cKQgFwBiaP6YzM2fedoXu
	emXekkZVGp4+0bH4ddUlwKmvkv2DQuU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Baoquan He <baoquan.he@linux.dev>
To: Christoph Hellwig <hch@lst.de>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, usama.arif@linux.dev,
	kasong@tencent.com, nphamcs@gmail.com, shikemeng@huaweicloud.com,
	youngjun.park@lge.com, linux-mm@kvack.org
Subject: Re: better block swap batching and a different take on swap_ops v2
Message-ID: <ah2JOjCiDqXvPci_@MiWiFi-R3L-srv>
References: <20260601113449.3464734-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260601113449.3464734-1-hch@lst.de>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Stat-Signature: ny5kgfa89wz3sj9hsq4gsje5r15e1bur
X-Rspam-User: 
X-Rspamd-Queue-Id: B9BF7C000B
X-HE-Tag: 1780320580-514195
X-HE-Meta: U2FsdGVkX194Xe5Y4LGwvjKQtGwoD5PoZ93686J3c/MUDLxmW5JeUVVG3NQ4WolRVXIavbneumHR25BPHhboKap0ATVgUg6XbqaxcE/EhMZQZShlJTdciIg77dsfH8W//IPEyiPfN6bE+J+UzOnRaQS3kCpNkuy71AeuMieI1OlnJVZKbEERNG5RBdUpKCQ49WnDuseydiUuIiiMoXml5DvQ3gw6PjogFWRwxSVT4MY1af57yU9iwFWOeG/4zBBF1mR4ZXT7NbL0YDKbiIKlvoSPo/EKMjOmPjehdIkJUVarFyIUugIL/OrsTpWFN+77HBjsrNLlpXedx8eObUPpXbAiVTAW7iGKF1ekqU/d5pIa7KduW4dlKpA7pDBRkXhfaY+bJNztSHz5XsBi8gHw7KBB6GGs4njmKtVUBukxqVCL5ewXjml8WMP9tYjr8fQ7Cu88r6yqf7KcBEOzb7f/KNz0o+1nxrMVDoZ2/n6EPxRj4oQwSDF1zWy4OIZKgCFMuHM5dNuyBwRL/Ri/P84O0LnAlMZHr2rxYTUrpCb6QUOlB8eRTjkZBKIMgn0OJdRfT6KtRhPJoVMF6rAvY1asmzLIOBH8qeMwbs98OO3GwUHKtKrgq+YCGfIWjOpdaRRERHBUOvZJAdel2A3ewubJxCaMsEjMnV1hTV3ibT7H191Pec+aRtRmSXEfcuxnAyIQb+qyo6++v3aFnwOngFaIjbVBR/xZ9C5DZe24oEmyrtcofEJA9FMl8YlwTxrP5/kTUaA18bH6OlwxwDirGc71d7d/2Qu+pjE/OFGL6Z82vqGwaUMKOdme52NeCjK5LSLfi5RNiDpjBvNld5GOiI6Tj9kJHhLBrVGjXbNTKlG0cOX2Gn+hun8Acw+IuyoP3bJ1M4HmQzfA5U8XtrigtSWOSmyFleNnjdlC+MJgJn/2Tw+Rxwn/7ec+IKR018sLcOes8uN2VGLF2ZViIAyIN2f
 RJS1UH3f
 47QViug4Nk1qOW7InwADA9QzXt0LyDFJt0tsaVopI11cDDYEU0pC4kl2oAydINwsDrgT6jM11xymst+LHnwhw6lK0V/qNFC0gxSKe4f10LPX3b4fh3Gkp7F79mvp3IgxvUd8FibRvDIQglo+1POL5A7mDJycACkDVkY7Bz5FsAHzR5qgqdaQWFMwCY2sUGBPOlX5OP7M6GuitlrDTGO2Wd/QkvAAeebjOT/YPcqZeX7D6kQ5u+UnbL4vm1Z2EpwVAw+oWo92ssWASG67SwZjZxNuDfFchXj6yj0eTlrfmxBBfkAKuJXDjZqzGXTQZ0jyLDNgRt5yOa5wxZ4fd7/3bKTJ5f/aC1K6+yb6XhCM/TUowb4g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Christoph,

On 06/01/26 at 01:34pm, Christoph Hellwig wrote:
> Hi all,
> 
> this series makes use of the swap_iocb for block as well so that it
> doesn't do inefficient single-bio I/O, and then rebases the swap_ops
> from Baoquan on top of the now very different method structure.

What tree is this series based on? I tried the latest mainline,
linux-next main branch and Andrew's mm-unstable, all failed. 

And by the way, usually we add version number in each patch's subject as
"[PATCH v2] xxx ".

Thanks
Baoquan

