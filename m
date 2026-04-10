Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8C06F36B9A
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 01:15:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D5046B0089; Thu,  9 Apr 2026 21:15:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4ACE66B008A; Thu,  9 Apr 2026 21:15:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E9DF6B008C; Thu,  9 Apr 2026 21:15:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2D74F6B0089
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 21:15:37 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E94EDC1840
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 01:15:36 +0000 (UTC)
X-FDA: 84640878672.27.715CCEE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 53A61120014
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 01:15:35 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Nqkeab3W;
	spf=pass (imf29.hostedemail.com: domain of jaegeuk@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jaegeuk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775783735;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LNrDbGljjL6XxcePl/ySBhhGzOYbseAX/BfHZ0vVBDs=;
	b=fKZrDeuIkQchEVzBpFZLKiZkilFBK7xkzuJuL7tUCo3plou2TBFbVmuq7qmMI7OZ861TmA
	nDOOF4QdxwjACyAZ2tv8VXtDiMZ96s3j5ppbD7ZzRGdeZ6rO7khqFMn/PrnXr6IZkAsScF
	Z7aaR0E9C7ITQOM5onzaAyXPY9zWy+M=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Nqkeab3W;
	spf=pass (imf29.hostedemail.com: domain of jaegeuk@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jaegeuk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775783735; a=rsa-sha256;
	cv=none;
	b=mqRAcxfELkATZ0gYusVDsWTPgZcyh83s3O2tCOOz7XYMTtYU+9D4LVBAjyJkl/s866imVX
	am37zE1++lQj3XxuJQ0q9+eKkboH6GLMGSrYAtCep4AhZgvFjaYWdOxbEFg7bBeLjXEact
	O9OVK7q4DZvR3E29DXVVw/2IqUI9LFg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A3FEA60103;
	Fri, 10 Apr 2026 01:15:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C8C2C4CEF7;
	Fri, 10 Apr 2026 01:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775783734;
	bh=82GZ4KNob8JYqSsZTREpcrcft6ZYfucxtR+SCLEQTTo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Nqkeab3WAwCYXh0hgzomJb+0jNUlUxcdx/ESJpMn9jt2YiCXrMO4oVqcDnwSW0FkX
	 DekQwDHj+mA6oIA31uB2wCKKXkQDU3+pWHvpzL8RvIEPRhtcvLtGER5884Un8RpVwn
	 YJNiwopI15oJxtrHkrRpzV+qRrx1+wmpU+kRHsN6B5DsWGon8ceWucuyxYv2Ov6iDk
	 EiSQb93ea0zpq9A5HYRbfiwirLyxw7fdejtVRhP3mLOTEbsXQDnK1B2+nyGUREu3lw
	 P3reDXvVmaLVcMSs3oOm+EsZ4ABLwbkWD3V7PoJug8rewBhUj5cFT7LM/k2MYA+nU5
	 i2+DB5HR8DN1A==
Date: Fri, 10 Apr 2026 01:15:32 +0000
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3] f2fs: do not support mmap write for large folio
Message-ID: <adhPNLtbAlqI8F3l@google.com>
References: <20260406154940.2407853-1-jaegeuk@kernel.org>
 <adaasm42rLxRY2GN@google.com>
 <adc7yo1_sr_eeV33@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adc7yo1_sr_eeV33@infradead.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 53A61120014
X-Stat-Signature: potc5t99ctodayk54kgy4rph53hyi5ow
X-Rspamd-Server: rspam06
X-HE-Tag: 1775783735-223006
X-HE-Meta: U2FsdGVkX18Ueua7K3rz1Pu7M7rnkxmNZFN6jRf12f3t6Jo4u3SPQ3bkA30xuv4geKTGkhbNETX0j9+qcRxYpSdbRef19jfLTXzPkc236LwYWdDqOLCQFsMFZsOsZoEwr6X3RvA9Ol1V/4xeYv2C8V+1a0o70SUSJZIBmBpfEUtX8VrgGKOOxJ7+0aq2JFL8bJiih5qXg800kqO7vxHZ/eX2+X9pe+SFHEbJP/ZdpxaxjTs0ZsnOqekCx2coG1cCIkQfCn3PkPVTP6yquW7omUnyWAKM4TFWK3P/vzY3R8J2WGi4NmzACrUHNlpWotbbU3mJRLf4G0s43x7pJgj94d+UTM9ySeGk/yyitVC+Lm7znogMQ7eiMXCv1y5Qrq+E7raXfgQDhnXFpDvdIVMXHkMGwrvtqg+MTQiC8P53HaXPSOFTi2tLV/xPeV/Nq3wHiCoYerX4Vbb5lfMXYCpyriqfGpmBgrD5G90We4bNx9ZbBxf8Ign7jwvCIV6RenrqxByiT2+BA5Tr2x7W7eMeR0wcG64PPhzgnaA1TOnSLpc7tOsxVhHCNxwoJK0RT/YIbNAHQRQPk0GX4PqFTnXB0GYatJ45mVMgSnvwXoivuyWbmYQ1Q44dTPaQMpVBdGDU1CRD2gZpG5xxqQDhFse1lfQil+SJOfYd8faTtDTl+OO2hspFryJC7eK0RRfMgjQizLEcCvEnFPHTGaIgdyiLjqvjgT0kb8mkqzCkPqDXEuQn+L3BouWT3Yrz3heYGz8HlTVKL/oCQebMgEf3TpRmHX2+0QcpHwC6PsQ5gT+RUcfB4meMXZnQoLxHfy1y1YignGhLoYAkSmvaY5IatjYANEUiqmH2yrogMemVkIuXa1J+netmCFacxc/o6hnOjy9p7/qWjY6CRJPq9//fF2KYPsVCY+GsNXgoIJ+N/4r9nkvfe7XobR+ixZhYzzeSKRPBNn+sdZdGV0PIRthPzZa
 plu6QJTC
 7FLKYPdi6uFOIjya3JUY68CwoXwr6ETPeoXhkmWy49klmsGSusRQ83bDms/IbXhojDeLnK7f6ejR3bovFE7TNFjhV3Zr928zn/27mRtYWIouYgQfN8RGzriA2IU6xyJpM3SlAJUFxUwQAHsBlIYNkCzBICAJcjsU/973+ht0gPRxyJkzk8zI3TAk+IlCOAcANFMLXxiFoId08S9tY9xusf8kZfKeUYDlknK0lyab4nVH8YqUPZyFPkK3ZEIFHvieTbC/ZjTaJ3n8B1m5kkJp/UP+p3L5tQseAiYQh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04/08, Christoph Hellwig wrote:
> [adding back fsdevel and mm to the discussion]
> 
> On Wed, Apr 08, 2026 at 06:13:06PM +0000, Jaegeuk Kim wrote:
> > Let's check mmap writes onto the large folio, since we don't support writing
> > large folios.
> 
> What does this fix?  As state in the previous round of discussion f2fs
> only support large folios for immutable files, how do you get ->mkwrite
> called for them.

I'm approaching this as a safeguard first, since in any buggy case, this will
crash the filesystem.

> 
> The only way I can think of that is when clearing the immutable flag,
> but simply rejecting writes with SIGBUS after that seems like it's
> breaking the expected API, and I don't see handling for normal writes
> after that either.

