Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF984D46607
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 17:47:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 479076B0089; Thu, 15 Jan 2026 12:47:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4237C6B008C; Thu, 15 Jan 2026 12:47:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32FF76B0092; Thu, 15 Jan 2026 12:47:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 26CDB6B0089
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 12:47:08 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 05D611A0441
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:47:08 +0000 (UTC)
X-FDA: 84334929336.13.DCC10B4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 539F9100002
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:47:06 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=YT77vFZ2;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768499226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dUftHhOvNR6RUT3RynV2bsB+MJ8Bt788NuzGnjlky/8=;
	b=FDjmSpSJxQTlYcgCt3fGOKTEb9z4/2VAmrlwrMoi7sJLdcRFsBKfAKOjv19+PX9g06lEcT
	MQbe4iZBMzlpiZsAqkgJB0lypKEef7s/jCcaKY/ixqSPPSB2gjfdUSS1VtR1gF6YgIGD61
	VlKf59XR1vmol1q0Tn7Iev7ORQcB8jU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=YT77vFZ2;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768499226; a=rsa-sha256;
	cv=none;
	b=MvHAhT8Tm3KZYnvNvtRP37wxZMQmBa9w8Zdj852+WfLIrRqeHxLCe+eiawIgnwlqF5waEZ
	cxdJQoMYz/yHaumpCi5rgyPPLmxbJf0qcvOCHpr+Pdf6pxULNL5Sq1w2xVywP/Ym963n8G
	2J1tn5wC3tPxAxqTlxXfn/VQNdf5asg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8492341B3A;
	Thu, 15 Jan 2026 17:47:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4442C116D0;
	Thu, 15 Jan 2026 17:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768499225;
	bh=C0SodaDfVTiyD9izfNenedvQEytBtrnvMR6/MpPi0+Q=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=YT77vFZ2+7Mb4JRJnlkEcCnCQ3FdCi/XnGOboKt/d4mGB5ja5LxRc2AK/LHwAQK1D
	 r2IzpDbFlLtgWyVyyl0Dy4RU9OnH55YSUvc85GZ7VFqSc7zqtiR4SALjv7HmtZs/Jj
	 i1UfLPTGugFvU3Ffxhzzq9yBJ3aZKF79RmfCPLJY=
Date: Thu, 15 Jan 2026 09:47:04 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 david@kernel.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 harry.yoo@oracle.com, yosry.ahmed@linux.dev, imran.f.khan@oracle.com,
 kamalesh.babulal@oracle.com, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, chenridong@huaweicloud.com, mkoutny@suse.com,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v3 28/30 fix 1/2] mm: memcontrol: fix
 lruvec_stats->state_local reparenting
Message-Id: <20260115094704.17d35583bbcff28677b5bc12@linux-foundation.org>
In-Reply-To: <e5afd1b5ae95d70f82433b9b4e13201342d16707.1768473427.git.zhengqi.arch@bytedance.com>
References: <b11a0bde9fe18673a61a79398f226ad7cb04a894.1768389889.git.zhengqi.arch@bytedance.com>
	<e5afd1b5ae95d70f82433b9b4e13201342d16707.1768473427.git.zhengqi.arch@bytedance.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 539F9100002
X-Stat-Signature: ow3isz3n3fut74jzdbofsgpb7doxgdfr
X-HE-Tag: 1768499226-574052
X-HE-Meta: U2FsdGVkX188fHWETtBDe+e4GMBIx4Jnmb0EAaAZkq9TPMB4n4s8Plr2qXI86EzxkCLwqFWZni8yw7xeyo1+N+pWZFDpHGtEUh9msVku3foCk3aI6U+212RW/DgqO1j0x0MEdx3kbNpKOW59Uk8qnnxASzVN/Y4OjH40muGUNl4djh03vCDOap5HRqGIDPBhVgn2zSZ2QyS05g7sgTuvhwTFh4k29zn1MpFN6oL7goEP/4Psq1u5vPWDpgd4ro3JPvG1EfnXlfXjCJntLuu9iPFCWsxlLo9qmLVhCISYUC47cC6SZDOe5eGSKOfsBWPy3wEGK1LEAwEIZdW9Xi5hRHrnby/+RdTyxjf5oahLt3frhdh0kNO0X7yzN8QYrt8T7X5sfJOpVxXzlklW6uqcozKrO0/11Wbmeufc2G2f5QcRV5wrZa82ZQh4RE2RW77zHt4Eb2ejmjKWj55ECFSiyNegkLaRdyiZFDKTJxWxg55B8s7sZhdTJOEwxaJgAcVdIVEq3TXc444zYY/1ztCl/0pDlh0CnpMt/hZNuZkQqrUsJ78qzjLqupjrQs3JVMpHvDNqf6EmEvuj2Me9qbTgGtW2F/Dz5UaHLdVN/Spqsp8RY8yLTWzynJ5bQhxSXLTi1vwQNSxYvlQvK92Vw8zcfImGxdSs+sK9J78HKf/wOJEomPWj3yAvd53IjKN+F+s1KN9ITQcSjh8OxxcHi1dkjqth3JueeRKv1px8lcKFFRUtIuYEfJ6Lq2edPokCP3lGFDivczy7GlZphgtZn/kDtSadcR1PSag6yX9t5EZRYiyZ8uyNXfjnFRsuwZQrTcSnxJ46MJHiZSLaRVBmfg8Tvu1zQLzuxz34Ex8kUzTHVERn+1KKatgwcO2sqGuULT4Graka2QnaKvF7Stt7O8WxcryN63shzFiqztbpDeTHEQq82onpldg+ArOSVE1+vTM8SSLfhxuQWfuXnyKsVIS
 s69JIq5Q
 cWjGnc27IbJJ665yxXCt6xFLNdSpYUTjBThBQyOUgnjWqRUYE82UOaDZ/GfoY0SQMVBD+I71nVc0dIe5nc4V5ezodiysOR1tUXPfQ1qYRLtJ2gxfEYAA/cTiG1CsEF2S+j2cPK7Wzgd7QRznAnyvVuIoxOwr4p0rzwx2UM5unjD1hhzOfatIaPi+ogIytVQaG7QTcxzfGLo2+07boF0ev8H+yIN0bhICJ7frOjUcDWlzL740qyITVksuBP53PWMOrvAaFtsbSkPn00JnqopXXvQNDMjKl2Gpy2lpzLhMniqB4n+jSV4MOtopuLkCT9b09YBejHT/wzw+f4IO8fLzh2n9R48cDN+nWG9Xl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 15 Jan 2026 18:41:38 +0800 Qi Zheng <qi.zheng@linux.dev> wrote:

> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>

What was "fixed"?

I queued this and [2/2] as squashable fixes against "mm: memcontrol:
prepare for reparenting state_local".


