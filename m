Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F955C61DB9
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 00:33:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2979D6B0088; Thu, 27 Aug 2026 20:33:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 248796B008A; Thu, 27 Aug 2026 20:33:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15DFB6B008C; Thu, 27 Aug 2026 20:33:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E8BD06B0088
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 20:33:07 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DE990A34E4
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 00:33:05 +0000 (UTC)
X-FDA: 85148803530.16.DCEB5A0
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8371E180005
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 00:33:02 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Jxt4EzZU;
	spf=pass (imf16.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787877184;
	b=E49z+T6TvgswhqsCTSKHAzPrAznDeCvMJgjJcEGWKt9Z3qGj975wr5sEgg/v9YqFlbLBIq
	Vqq7mnQ+f45A19wdspTCBkSpcfXaxZJYOrIGi0D+mOSHX4HoPkI3DfPKf+mNOYiU60Glwl
	7F2Zfa3PE5tIfVqYzALuvdOW190IjPc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Jxt4EzZU;
	spf=pass (imf16.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787877184;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+7xdGd9TqGZbrCxJ96IaSdBVpCo+88VJ8jMieceLa5Y=;
	b=u8Vd1egoZCsDJayusGPB/x5iQ0WJ+fhBnD5uaFyCE/vj91Pqr7YWqMLPqxY0up/g/VbUux
	1Kl4XQlkOZsgiw2WNErBrkKsGY6Ijtl6xpyEkF5QKbi9DJTv6pSpY0ywDl9i4km/CGOHTQ
	p9jOAuGplA1HQzuAwf9HH3Y31rEt+NY=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1787877179; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=+7xdGd9TqGZbrCxJ96IaSdBVpCo+88VJ8jMieceLa5Y=;
	b=Jxt4EzZUtdgNAd4Wsdid0eOLfwnDmDITyMlJEawv+14BcsuUiM9S8/9K9fD54aL/qOUVZeDFHymYGVPyqWWw+XKAtwB5+RZdM85A0mFk+EFs0UguO2vjpEZPQ8cpZ2YkYTfvQfXUMdYpZbyZLTaZttiLdRnStwR4ZtSCiBPp2Ns=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R991e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0X9khrQ2_1787877177;
Received: from 30.74.144.116(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X9khrQ2_1787877177 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 28 Aug 2026 08:32:57 +0800
Message-ID: <7891d521-5541-4461-b0b1-e8f4fedfe37c@linux.alibaba.com>
Date: Fri, 28 Aug 2026 08:32:56 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] MAINTAINERS: add myself as a THP reviewer
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>, "Liam R . Howlett" <liam@infradead.org>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260827103435.1371882-1-kas@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260827103435.1371882-1-kas@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8371E180005
X-Stat-Signature: 9c3xpoub5ioosyfj7q16hpnoazypcts9
X-Rspam-User: 
X-HE-Tag: 1787877182-811308
X-HE-Meta: U2FsdGVkX1+eBW+658M5N/YJ1Za0ykZlNC2231mCmbxmV09HghljMFYg84lfAs6x3NOLD8GKWca0+kn7svWPHxLUl5npd10CE4jmAXEfrq+t4UOHb5U0JIYlM0Qx2a8xS6PR+xHXhGsED1HMsES3ZTOTpynTxsIEGl1ky6sq5oiIW/KBNHKCxSlocFWnPBKjgi/URvN6zLEty3vZbrx2GseizNG2kjAzyw8PaH98hB8w8WbW31iKwq+UPmJk36rq0B+fS7BkznlMvtLBIBqLYs/CeUOwYC5RLXeuKtayokJ+JdQKc2oTEF2t+tUL+NqPAY4RkDxDR2lfLz9goKup1g/KtQ4qYeXr+hzugM3ZV4toVuPeGWvqh4VsP94rf52UmWHOC4hK8FzitiZ2R0eQruGn1iqPiHVRquurIbGQ/VwSQUHJOeF4/CntRG10i6+YHZq+3ZipFw5J9Ra3ULCCCie+73IJV6khWPKbSPylF5hp+IaZne+NntPnXFF5js4p3mESely5XYGFJ/EFoGQUHJ80fpr4QTCKhCb5P8aXOrhjGifeNazvpSBwxxMewX1FhwbcUZmSF1Yi9klqezZu7Iaq8Nvw2Ymw4y0G/aq5fkPOXXsIIpgZ17qAzM/IExWs5p6/t1IuFyqWAazDyRw3IgIuX+uMpBnV8Ko+Ej1v/+0PHeFo0ptMhwcSXkjIrXQuHO4nNsGC6uIWIUUVta4lkdhqUHsHoRzSIXXsAFtHJ6dkuySTJsZ8TiBQN9uY9bgtNSdQ0doDhiPFzzZq6Ku0DeGAxshqTX931Dlef8bgajrcNttCCBKdIwCKbmlXfG878LUVnzsdJz6EphoDQacOs/d1a+7n4EBmR2v3Z1odb+Lt8/PfYpyqDHv+2tR9OrOYkFKtP3olPPciBtkPIJ0X+DtadBU8FmXKlbXnO1fkGoCe2/7f2P4m+6j3vSOlCwM0mPAmtfVFNeZLAq8KO0T
 O5WmE8wF
 ebfNWCDLyIzZp/gYFSD7NBb2KISxIXtWgw0gcYtxuWpJMblpHPPwcrLLhwqXk9KSXYSnMJo3LGdInCHjfye9pNLckg79qdOYBdb57NKk348An2XvfmoFT9OVeJQY9XPg1LXct13F3MjgK+XpELxPIJmyZYFz2y0xBMb6lEg+TP+kuDFch6XutdNqTkpSG6cOoK9Fqw+s6upKbC8xJCFQsnvR18dz+yp2tGVG2cG6HacgvqlJ4QAGt4vrjWYHjxx2CBn05TMXJIDF6Q2kkQIlnihKOD5RfBgAyjdlZ8Wfji70NUDdr119Di+ZcXvhHb129THbu5ywJb0lw06TaxC64q8FskD6i/Iwv94x/e3JgcPtqvxjSJJAl4IIF59eBbt7Y7t95MWUOBzBqx/fqa0/FefXAHfD6Nx145iNZHP4OHXBkCcwU73cxmtL0R3vq9pQMbzTlXcNT4OScyAdBxLUni+tDIUcs+uRtSm6A6gsRs/ygJ7G6bmTCpZ7rJz3mYZS0KOXm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/27/26 6:34 PM, Kiryl Shutsemau (Meta) wrote:
> I have been working on transparent hugepages since 2012, starting with
> the huge zero page and file-backed THP.  A lot of the code that causes
> pain now traces back to me.  It is only fair if I share the review load
> for THP.
> 
> Add myself to the reviewer list so get_maintainer.pl puts me on Cc: as
> well.  It is also my commitment to be more active in reviewing this
> code.
> 
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---

Great.

Acked-by: Baolin Wang <baolin.wang@linux.alibaba.com>

>   MAINTAINERS | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 1be7da9b6e2e..f5bb29ba41c5 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -17264,6 +17264,7 @@ R:	Dev Jain <dev.jain@arm.com>
>   R:	Barry Song <baohua@kernel.org>
>   R:	Lance Yang <lance.yang@linux.dev>
>   R:	Usama Arif <usama.arif@linux.dev>
> +R:	Kiryl Shutsemau <kas@kernel.org>
>   L:	linux-mm@kvack.org
>   S:	Maintained
>   W:	http://www.linux-mm.org


