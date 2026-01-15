Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8368DD46607
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 18:19:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDF956B00C4; Thu, 15 Jan 2026 13:19:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E761A6B00C7; Thu, 15 Jan 2026 13:19:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAC8A6B00C8; Thu, 15 Jan 2026 13:19:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CA0196B00C4
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 13:19:01 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 97B201BB23
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 18:19:01 +0000 (UTC)
X-FDA: 84335009682.02.71150B5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 07183100007
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 18:18:59 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=e814AiMP;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768501140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EFYHBPIUhMFvC8nNZ4RLw9YcCaFbdD2bSpveBTVTElY=;
	b=RY4k/pnrl4QD6OgbGe9VtI56aOgasKDi3oWpNXnl1OaPHFivEJEeoDI91Wt5w9cuRyVC1e
	TZ2p+S1xiJtpwl+8eW9bGZEJLdfj7f5FDgeUTKdTRJJGvw2BBUs07gNuhh6d2KN95th/5F
	mBz9isxwvONzTu4Snak9nUMiNCzLn5s=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=e814AiMP;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768501140; a=rsa-sha256;
	cv=none;
	b=mCqnG20Rk/KHjNVDXKqW0ZmvWx9duVHpNLCZ87DcMEKxDLdJEhvTIuR56kx1K/1OmtYTA7
	lgdtJhll1cTQKUZ/LSTYhVKzvw9WJo+C8SdyiB91P8GkxIyWrUUZscJFVQfr/mGIiO9Egn
	gNeqEIHrtozE0EK3/5iD2ubcOctGT9Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6B11D6015E;
	Thu, 15 Jan 2026 18:18:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA2EDC116D0;
	Thu, 15 Jan 2026 18:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768501139;
	bh=OoxN+wiYLUXA84AAEzLFYI4Crg2HGDqLMAG7AyG/Wk0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=e814AiMP04MGQQdvcF/eHiGR3mf/DMRLiaDPWrPEkG74cX3rRLhEga06ol//9OChC
	 vkULXBUpl0DbaS8P8n8lV4PmH+yaM1LyzgRYvkc1THr/VqmymRuJ47mo/jn4h8uQVB
	 1kwCMTpAMOChF+x4dKZrsq1Dv3Akpd17X8oldoso=
Date: Thu, 15 Jan 2026 10:18:58 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Cui Chao <cuichao1753@phytium.com.cn>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>, Mike Rapoport
 <rppt@kernel.org>, Wang Yinfeng <wangyinfeng@phytium.com.cn>,
 linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 1/1] mm: numa_memblks: Identify the accurate NUMA ID
 of CFMW
Message-Id: <20260115101858.85fd7b8e837c1c92a4fdc5f0@linux-foundation.org>
In-Reply-To: <9132054c-3017-4af0-84e0-e4359b0794a6@phytium.com.cn>
References: <20260106031042.1606729-1-cuichao1753@phytium.com.cn>
	<20260106031042.1606729-2-cuichao1753@phytium.com.cn>
	<20260108094812.8757ce3ad8370668eaafb29c@linux-foundation.org>
	<9132054c-3017-4af0-84e0-e4359b0794a6@phytium.com.cn>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: i1wje8pu1z9eojxiz1ky561bp1nkhaw5
X-Rspamd-Queue-Id: 07183100007
X-Rspamd-Server: rspam04
X-HE-Tag: 1768501139-98902
X-HE-Meta: U2FsdGVkX18VMxnD43RZfKqprcwgORTKjew9qO6GAIE0VJuaz8k97G95fXeTKNHuttgnD2Oehb6LAiSPQWEth8GaENnMdwMfMJ7Xy+o+sHkti6RcVG/lvDK+R/zNaQquhfrW3cuYGPR8lMPY/Q1YuxDzsA97VQrvfYt5nglumisIGlSOppwz4bnR+ZiWkxeQXVn9taX/yPGQkiSOtdET4f8t7FBbpfcG0LiP+Cuj3X43AuNzlqPgYZzW9xO8dCsgOOma7Qk8X0tTPRriCvC6AEiqfcR9V6FcwNkDKlk38OX7p6pXOxZber4ZD/MxhT5n2Tuj9I4qdWXoc9U+tnJLt9K00HYcqV/QdNEOsne7WfxDqQLFfxUh8FKdOihPsko0jAdJuGmgLMDP2ojEUSwfXireBqGGUBSwgn62KoTZ6cV7jQSc3SEvP9zvwSVr8K+ihk9p0ogbdfvBivFcXOE4medZCTPGFF0C0nx11z7qGS2VVj2J1dR7xnuBhzTm2qMT6xw8hbxFS/1vnfXvEMy6SlujFZlFmEquEepZlztGwtVxJ+NcooZIIC+yNPJZ0WCqjKIFaAAgX5ecVKjem4QnrjDbOjfMRiAyt1cQWdpaNBEQc5EwJBvDWsHvfYNfz2erOOYWvdFCbI2/JEBfemkZkOW9jyKzfmL2crmoEDM+OT2SgO7lZo1LOAQTxieEOrDY/tQ9wHGKuCv70XSH1WGKQIRJwI+A3t7xA7cBsU0aplqdFKGboD4b9wsgtG6xqcGzfOdCTeH8iMkYcka9fOVE0VR8oHCtT0on1uWOTQn9XyeEj977CyU9/0BowawjqPDAv1oTbp7Rhfx2aqdnErXjtaYqo38FY7TUR6GAIBubeqUQcTBEf/+DdAjNFU3rIsHVXwakYsutd/Pi5r/nFRDgxiNDy1l+kSQfhdxujjfdu2FBKm+6tBH5WIg5McMnAxqo7BECYQsgcUWM+0h4pI/
 BXovH9aL
 Se3vd/LLIn/avqGAkqbYoMdLhX+6tqBbZ8TVnHrE9SgXDymEBD1kCTj1cMwoR+SBPVD2FpJpRcH/TXiqAvkZ6Hz7ns25UDQjffSGK4bYJdhMvPxFqmiPKKbt1u53c0a3KnZqOqYIOC1pZJ0pW8uFOTzNoPCYhHLtnXkZhtfKatfWaOgOBS1FoCWEXrPdYXVRAMB/xjN2FaiLSEh0L4f9q3AaeEO5xSq5Q1o40tVuqD+kF3xkmveD+/YRomQnJfXrPNLCI0mREbOHLfC2Dm11EhS0vBOqDnVBsYOxCzJTdrCnP2+ng9EsGYfBiVEYdf3rFln5XvmYRsaxkzhtztgAb8XPyUKaSVLSOvXp2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 15 Jan 2026 17:43:02 +0800 Cui Chao <cuichao1753@phytium.com.cn> wrote:

> When a CXL RAM region is created in userspace, the memory capacity of 
> the newly created region is not added to the CFMW-dedicated NUMA node. 
> Instead, it is accumulated into an existing NUMA node (e.g., NUMA0 
> containing RAM). This makes it impossible to clearly distinguish between 
> the two types of memory, which may affect memory-tiering applications.
> 

OK, thanks, I added this to the changelog.  Please retain it when
sending v3.

What I'm actually looking for here are answers to the questions

  Should we backport this into -stable kernels and if so, why?
  And if not, why not?

So a very complete description of the runtime effects really helps
myself and others to decide which kernels to patch.  And it helps
people to understand *why* we made that decision.

And sorry, but "may affect memory-tiering applications" isn't very
complete!

So please, tell us how much our users are hurting from this and please
make a recommendation on the backporting decision.

