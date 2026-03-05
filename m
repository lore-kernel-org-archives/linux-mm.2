Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5CFCF30924
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 09:39:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3B856B0095; Thu,  5 Mar 2026 04:39:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB1AC6B0096; Thu,  5 Mar 2026 04:39:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D7996B0098; Thu,  5 Mar 2026 04:39:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 883336B0095
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 04:39:57 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5316A8C610
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 09:39:57 +0000 (UTC)
X-FDA: 84511512834.16.BC8B2F3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id A8095A0007
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 09:39:55 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Dab+KGm2;
	spf=pass (imf25.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772703595;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MTtnObu4o06dYbIMKvszYfMXr+teQSCMxeOcjufC/kA=;
	b=aUlGpdmddV2Q+FD67HlNuqoctxqqGR78UyqcX0VYsbnql9kGMQCgD2Wk759v6fhiHly0LD
	tHL3sb5ZiX0BHD+wN1Z5k55AdrXEu3H+80RKZPMM3GntlcB7Kz8rkNzGO+dOi1J+c+KaMN
	23MimPmKVlLNlSWYO6eqolpN60zWF48=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772703595; a=rsa-sha256;
	cv=none;
	b=jxQXoINgM9dfBFfnNB0psojSd1OvrY7k699yKl+5NWo2oY1SSD11zfh8UzMFeZqbJkBw6V
	rsokkvHCUDIinZuqhRZ1OOXORtNFz0zU676ssMyht9JoIYfvf5b2MGN7fuVJBm65sGCQ/W
	HryJ9eiI+C5/mKL216vS+NukKa+y8OM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Dab+KGm2;
	spf=pass (imf25.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 08F7F61421;
	Thu,  5 Mar 2026 09:39:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE45BC2BCAF;
	Thu,  5 Mar 2026 09:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772703594;
	bh=y81fmIVNpYzQvblJsrNayzEhCb5OqA/wQL4gzb+kqEA=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To:From;
	b=Dab+KGm2bS0CYqyCyVeUOw0U+4aAZCDfrUE7mIwrPUGrUz9sOH8jz2S09uSBqkIc+
	 6/QgMDo0RWSyo2IKiB43e/tS0gxcq73HvjsHuUD3i/BUCx3dQqkFe9Odx494kJJMg0
	 BupW/0GlhmmV+AqBCr2LIjAQYWQBEBgFjnv9Rcsvc036S5nJNC+c1QEVvDgiCOg6VH
	 i6yQtvQiJDmbwsHzX4PZp4hEQKcAVhOEWRHYzbYo1y01FeP07mhhSMKH/YIuw7+J0A
	 RtXO7j2UwEgqFkFtREy6FDmuNLtJ58ynMUzlQiON9s4sbaEkN3dCiDsErVz4atNyyj
	 XhtJgOh/DDp8Q==
Message-ID: <b7d2a020-8062-49f1-9487-a2cb37206d85@kernel.org>
Date: Thu, 5 Mar 2026 10:39:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: Re: [PATCH] MAINTAINERS: add co-maintainer and reviewer for SLAB
 ALLOCATOR
Content-Language: en-US
To: Hao Li <hao.li@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Harry Yoo <harry.yoo@oracle.com>,
 Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
References: <20260302101345.36713-2-vbabka@kernel.org>
 <qjsfacsbh2lkzhng77zl4xyknsjybxvsuqulbfegy5moac4za3@i5gg57ddh27n>
In-Reply-To: <qjsfacsbh2lkzhng77zl4xyknsjybxvsuqulbfegy5moac4za3@i5gg57ddh27n>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: kwhhtcxko618ixpxq334hq56tgw47ha5
X-Rspamd-Queue-Id: A8095A0007
X-Rspamd-Server: rspam03
X-HE-Tag: 1772703595-870719
X-HE-Meta: U2FsdGVkX1/VxZL6mAof8UhlMt7MMF8j3ZM1c8XU3JsPZ70aEjJTvbhaGIlbpj1wRsjhc+XaRbb1ISBJDJ0jS5kLOiTT+7JuuxQoX1nA0dkoOrS/TyXQneOAFOpDpLApETOdB1aJJB1zH3NZxfIC3yRNJr9MxViQsLkwcQOtTkIn3VXEG0Um8f+3DFwRddCQw/1wTOjepYno9jD3R58+PTaHzQED3AGq0ZxTcj9qthUUGQaKLNigNpesbKOrbmN4kovcSgNDbbIzpaQRu2lctt22ftIv5F2/REhhiee9Do1OiBzt83RcUSB/LLJVKgHDUvBi9Je1PdA8v2niLp71y/ZiBSqV5hpiKEFyXS4DCkhjp5vuopSniak8Qir5Is0NR2kpKBH7BS2k2VgFFMtj5/uFySa6jgdwog8fJsJ63N0KoCiSR3NGtAueoo52/XxZc5aymghxu9BOOS4C4RPdDcCqt5A0kOe+YcZEL9TR+E9eeidaZ+k+IDnGurlSzRSHloLP9W1pNCqtOfTGjla3B7P0ELbx8ULTk0iZfSYN8XWY1Na8qUMbrdRruYf3smf3BpwULUhdvdNYwGmlEH9P/syoed/ay+DrBBWqwFeFU1+l8ZTk2FvJekhRpzy8TSbVehVcpAO6RQcfNc5OsScgu2kREp6d8ZfekYjjHshkMatfN5PcHno2UGPaxyFh44WRm8yqqtvs1dxaq6Pjj+WcspSa1nKYmA10Jy1Qict/DpMyk6dd6rTNRhJOvBk/it6MNOt/bujsam5d1AIkrHKgIVkcRjfIjarsyWWwW+XC/urzYpj96o5m8L27abl3mM6vQnG4Xo+vNUSKVT0taswXmRn5MYT2iMn1H6Sa3SCdWuPV/Zud9zaAsE4j+MyM1CloVYTqIRx9ONUr/hVB8xt02e7rixcDXo/ACfFImAJoOKSoOrlx10ES9ruaV7uboNVSQydMxhsfoWFkRNJHeVg
 FEe7NONo
 lp54lYypL6zDzJf6+griteVXEuBwtWMbNlUxAhuRSzAJOwWI0ld2g6Hd43KVF91ydQZjUD5RzIMSSPxEevPOZO7fHUXxHHzoUpMrWBuUg4Lm+ty6a8l0J2bcq4i7qMUAizE3onlr2zQiUsE0dLPn1EQ5dtbZEl6GU2DtuahJ0slaXcI+Z5Y1Y1bcR8+TAcSA8CzKFPEO3XkGCL66GJkSYzEVLoXUzbRxd/GPfnSNDUa3uqvR2GdRy6kdr/BHulZisr0/m
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/2/26 14:39, Hao Li wrote:
>> 
>> Add Hao Li as a new reviewer. Hao has been doing very useful reviews for
>> a while now, so make it official and ensure the Cc's.
> 
> Thanks, Vlastimil. I really appreciate the trust!
> 
> Also, thank you for the patient and constructive feedback and for taking the
> time to engage with newer contributors like me on-list. I especially
> appreciate you proactively Cc'ing me on relevant slab threads (even when I
> wasn't on the original Cc). It helped me stay in the loop and get involved
> more deeply. Happy to help with slab reviews going forward.
You're welcome! When you started replying on slab patches with great
feedback initially, it was only natural to Cc you on others :) Cheers!

