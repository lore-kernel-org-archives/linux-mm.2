Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 287B6F483F8
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 21:09:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 760276B0088; Mon, 23 Mar 2026 17:09:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 710F26B0089; Mon, 23 Mar 2026 17:09:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64E466B008A; Mon, 23 Mar 2026 17:09:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 57BC56B0088
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 17:09:42 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E867413C24D
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 21:09:41 +0000 (UTC)
X-FDA: 84578569362.02.B294108
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 327CF20008
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 21:09:39 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=h3sSe+Dz;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774300180;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QHqRcmkS4qReoOOIrKumOQORycdCWhfWQruoCPZTBUs=;
	b=cmDUKBm19xykX8H6+6VGT0auEA1NXkImGIEpSgxoYJCXEW2lb/mwjCPJarR3X4/JJiFvkl
	3aCgiQyCiae9layvE+JC6TX5RsBq1e/eYvNuoW+6kOzk/GhDKf/w051wNwyNFVzV030i4z
	IfCtgTCjpstGOPyiQEL/xXJStirvUyk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=h3sSe+Dz;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774300180; a=rsa-sha256;
	cv=none;
	b=Ax44527s4RpoXetGUyLYO+dR0mCG66Qjnz90fmgdQlkFHVNWIP5S2wyXEXNVq6Uqu1FnyO
	YPG1b3WkJBN8lWH3vYsorpDs2Y36q7K3U7yRDFWf5sDNWdK+u9YApnYaYyYnf9VmyB02zD
	hLaId0bbbu1vgl+y/ZjRSQHWPvzLvT8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 402D9417FF;
	Mon, 23 Mar 2026 21:09:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4C03C4CEF7;
	Mon, 23 Mar 2026 21:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774300179;
	bh=5/We3+BcQJRhoknLTQm5Tm1jmVPBMPoeEPx0+8cZgRo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=h3sSe+DzJx+p+VbMRfZnYj1ZydBfF9uGYcipObtREJTbIRCn3VPHDiuqcBWkVlyF1
	 r/moW57Ln53+rEfUv6YfhWW2O/o5xKd9J4z/TWLJ4S9IGr2LavWO4TYq+eF3JDWRdH
	 oamBJJBMB1j++63nnIyw+coyH9e7p69NbzBfk6SU=
Date: Mon, 23 Mar 2026 14:09:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Chenghao Duan <duanchenghao@kylinos.cn>
Cc: pasha.tatashin@soleen.com, rppt@kernel.org, pratyush@kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, jianghaoran@kylinos.cn
Subject: Re: [PATCH v2 0/4] Modify memfd_luo code
Message-Id: <20260323140938.ba8943a5247c14b17bc70142@linux-foundation.org>
In-Reply-To: <20260323110747.193569-1-duanchenghao@kylinos.cn>
References: <20260323110747.193569-1-duanchenghao@kylinos.cn>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 327CF20008
X-Stat-Signature: 4uf8oxt49qbdnnz7n4gaz5mb7bgg3n1w
X-Rspam-User: 
X-HE-Tag: 1774300179-568048
X-HE-Meta: U2FsdGVkX1+3c1oLhIln0Ra64jJyko12xteU9nvWhjUZH9aO1kCYYm9oLT8PSZDBXUDACI/GPvT/0RvLjnGoJk6vLNE+9HUJRbamHCc275YwYYxydk1q1hfHqE+QDD8EZ9otO8Ittzlsm9SIdpxAMLynXcQbnImQ5D4NMCjGaoPrVkKHkDldOm7inaSSNmqalG8m1rBiNWKPVw1A/4o/gNWxvEIFRQ2bXVgCm5TAXP6H1pY9B+KMwHwAM/EpYGXHNpRWbhIYFFXH1YzeGajR1kdwHW1b6Jh3nlgTUFilS1KPNM9xQCbsadwoUGmjI9ZbyEf+Fz0Fd9fzPxgbO7DstjcRR6YoxN4RuoukOVnmGExb3IYX1IGCvxrUQW8Pnoz2dTVDwqjrCQDemIEDGOViWK9rL0Jrksp9gMhAC7omDNlNFQJ1agi0oLgMDz7Sp3JDwOzwMy9Vk375klJR2FZYnSIhtoMYlqjTVlIxGYsiihO1sdZopV9l0gQFrEoX63ZBb2DAcj1A+OjQWKcIZVkVV4zGgNubA8rYKtwsIz1J7UmiVrncO6TLnVV0oi5Rn90DYlpcAUs007e/rlowXVFZ8oqHNSzVPQBXQH8oivg6GVmnyUeVNEoAzoPs27rfDZKuSpUp+O/GFWqkAuGsoQx23DUU9IJwf6oVRjWibelbuvFCbcIPA4bU+R3mu9AZlq0Pw0VKvtZcytDpzdH8gu6a4oq6dl1N5vch4gvFfY7PAe9sjhVvFIPwrJ/iPZ/LJakQoozRKRtpQ5WkMyQLj4Ub2t6bskZQvqRc6JrQxcllg/7BEEY9wzmQh15n66PtyZBt48Bb9egWrfko/wl5A95W/9qGJe031K4cLxX5SE1dcjFOCL1Jdxwvyc7Q6J5LINmIVCBIKn0ujLmyW1UENp34Tyfz7WmtfoKFyaOM7iwoxCH8UKLoIIcrsYnFNi0RYQpwKYlLyj2VShDSq+xdpQa
 aqDKSS9o
 HjZFffw66QuF4+K05f94L6Jm3fNskx/GyDW609+LaeVOWzckiMU8+KvodPAAq32YspuBuEiqFOMNjw31I1hFLwhSSFI8WjMPABlKdwWFC+bUmht+prEGMdcfSV609Y9lIFd4I+qSbQNpOb7Pt1HDXCYTpczNfBTSqkvJbmrN1IBQDImPJ4J17BTffDYfhAUQdMW9m1YJAM08IsoTTkOWjpGAkHHiSIBIo+nSBdAI//3GAHi1nFx8WzCEwAZTXdo0mCNTw/jfis6Nb85P8Y0cwZV8Q7RC3CQjNRpHdAyKxeTVLlJe6tGg1q2ZsepgKGbLgjFkzAVx2c8R3tsTxbp1VY5/OJkFEF43rSbS8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 23 Mar 2026 19:07:43 +0800 Chenghao Duan <duanchenghao@kylinos.cn> wrote:

> I found several modifiable points while reading the code. Please review.

Thanks, I've updated mm.git to this version,

AI review has raised a few potential issues.  Perhaps they were present
in its review of the v1 patchset.

	https://sashiko.dev/#/patchset/20260323110747.193569-1-duanchenghao@kylinos.cn

