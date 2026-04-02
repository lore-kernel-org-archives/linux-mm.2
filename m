Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33ECAD6AAEC
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 17:43:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64D876B0088; Thu,  2 Apr 2026 13:43:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FE5E6B0089; Thu,  2 Apr 2026 13:43:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 514016B008A; Thu,  2 Apr 2026 13:43:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 41D856B0088
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 13:43:24 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 73115BB60C
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 17:43:23 +0000 (UTC)
X-FDA: 84614337486.30.940BA17
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7C284100014
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 17:43:21 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=czSrDZIL;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775151801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XLIu16R81a6Izal63mzKNc1RbTHou9FhIcWMfBcuh1Q=;
	b=FtbG8gfa9emzIrnFZdv9DQQnggVQCsgwTUIK7VHyHCLfUhjjrWS9kF9+Y9n3Q6xbRor+/q
	CDvjV1oaLKt4dqmEWIVRFpojF6ovt7f5e0+BxwiBnSCSr5BbXqMGsppr/lNiwwQYMsjKna
	wHrr78dhpAXmdO5wFMgv3194MSF7HDs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775151801; a=rsa-sha256;
	cv=none;
	b=DcQRh9SfFM3rpZL4TBuYLTu8LbjRawpH7tVAMAQwScnuv2n95O2/6dfRVPFYa9kzFqolUN
	BDEboHwLZy3n5+jCnkrgVC8PbtswrHWcB8wtDTGPSeQId5L0NdC76ZUaLq+nA4CTpmK3/L
	5g7cjlg8WwTRBT3ewQivQgi+LM3/Euo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=czSrDZIL;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4C883437BF;
	Thu,  2 Apr 2026 17:43:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBDF4C19424;
	Thu,  2 Apr 2026 17:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775151800;
	bh=pwKNwUVxaCXmByQYLzB9FJ8TI+JLhbOG0OeFI7p7Tvc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=czSrDZILnsKbdHGSnLQYTwEaGYqq1Eys5MgpsnTmr1OE+loHk8za6CyUJ1fbc67Fl
	 L1hTeARHjogiQO/BHioswYcf/glIPYuOlkbNKCxYP/ThWKdR3BDEOFgloDe9uFD565
	 3rwi26YzxpX+5kyQE1+ACOyUMDUNG8SzR7/jSWcw=
Date: Thu, 2 Apr 2026 10:43:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Chenghao Duan <duanchenghao@kylinos.cn>, pasha.tatashin@soleen.com,
 rppt@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 jianghaoran@kylinos.cn
Subject: Re: [PATCH v3 5/7] mm/memfd_luo: fix physical address conversion in
 put_folios cleanup
Message-Id: <20260402104319.14186685ea81dc91bddfd6d8@linux-foundation.org>
In-Reply-To: <2vxz4ilthb9s.fsf@kernel.org>
References: <20260326084727.118437-1-duanchenghao@kylinos.cn>
	<20260326084727.118437-6-duanchenghao@kylinos.cn>
	<2vxz4ilthb9s.fsf@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 7C284100014
X-Stat-Signature: c4ddqzjf7pid598px1trfnd5pc57ok7r
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775151801-108100
X-HE-Meta: U2FsdGVkX1/ys09AvB35x/DoH++LsFuOXea6PaFAGs+wZvaWRqipRZv211vMoeUH1qh1Yfz9DJY/bC/gse4+N+YYi5JBgijWmZos0tw4M+iRLTiWifwSNBUuxNJHlhMV+bVbc6NK2A5oPnt6/XK1q6ifS9iTq3omxnVt9HuFkFT0g8jLr/38I5AktZSUu7H2JOgsnACC3jEVMp2A41tuERMaHvam5kf7Yz+aHAlz+4nka1yss5DJdlXgSNC6MAQBF1h7ZXkThjnkmbimUrrs/enpF6clLQxFI6CXHPrVb0a2bsWSuzCXnuvxEYHGOBrXOYHAnAvy5ptm0NKTj62JSwbT5pDDJAA/v6oypDjzBBhO5OKtazu+y9+j8jUj0RbcNZV0iFcYMqfq8O97hD1pSyN4SvPCuD7klKlvmtC42lyGTkV/7gaEdw7Ihw7SBkZK+bp3DKUM1aqNpTa5NsPBCr71UZ3jCFGOZfb3gqUClpsdfDEVF1zRKgLkKMZNtlN3HdJZ3PfhYgjmM/6KHURsy2lIvkG6AXGZ8n+hS3Xc3le14dhUyB3XMcjezjTgXTtQyH9ymOqEhB97K0lVGUZaZagIepuulSLHE2UJyC+2UKhVbXrhmSJ/7aKxBCtbP7Nhh5FvJ1rydRReixrzcZPQNfQWEiFD+48Q59XxdVbTUM8fM9vjE2wVb45J4HwtPMVEiBLgb82aaWtzBoy4N7wXtKalUYUdrhG1c2Ua+G4/LKdA08kgU1Kffui4yTYLG9VH4dP0jgCrgB5SSdL/LJ+LWGV/GSdhy/qwYbjdFiwD+ODVTrdBDJbpJlC+w1LEBIEFuoQP/T48Pu5GzHTwtzscFdagJ+fk5IoXXx+UKPqhZqpTqWZSas5BbaTnlOiPnCPXRa/jarBupHVu7ifRFtAfYZT3EAWva5Bu5DRz1JhRptpyYtYve6Mk/7bZuNKCrnOEc+eUYgQ5hc1sW+AlYHg
 nvy9xacT
 3gEkbboCVkl7FPCFZVXZuqJWa4wp0rBnju55gG6ldbe7eS5ywaobB5hwukqdAtRLOrx0vHHxVrSXo8M6Q2/ZSA1aiok1AI8tYw20Gu7Eir3tbNiiZ6UdRisGJmFgT4y8Fq2evEKH8SQcTRTTiY8xuIb1//bozw0+YKP6pzVVrSP/RZHx+J/1RJcVgFVpevED+bRsYDYlQD+oP3jKwJcxIeG7/1VBPR9dh4Wzv4x16LP57uUx37VpJ2EnQ806nllHGj6IHMpUJtQSXwE47F8ezJuooJ2+2JA+3GTp4xYYcIUaKiF4rZShQoTW9l7u7ll7TKcyx2tCwXifSZzOhCv10wF+KliLhhaeMMb2xzIzh9B8PM1xLu4IhZzcUyh4mTi5bPzOC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 02 Apr 2026 11:06:23 +0000 Pratyush Yadav <pratyush@kernel.org> wrote:

> > Fix by converting PFN to physical address with PFN_PHYS() and adding
> > the !pfolio->pfn check, matching the pattern used elsewhere in this file.
> >
> > This issue was identified by the AI review.
> > https://sashiko.dev/#/patchset/20260323110747.193569-1-duanchenghao@kylinos.cn
> >
> > Signed-off-by: Chenghao Duan <duanchenghao@kylinos.cn>
> 
> Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

Thanks.

> Andrew, can you please add:
> 
> Fixes: b3749f174d68 ("mm: memfd_luo: allow preserving memfd")
> Cc: stable@vger.kernel.org

Done.

