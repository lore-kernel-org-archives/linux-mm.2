Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97F1ACA0FF7
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 10:31:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A841E6B008A; Fri, 29 Aug 2025 06:31:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2D806B0092; Fri, 29 Aug 2025 06:31:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91C106B0093; Fri, 29 Aug 2025 06:31:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 77AC26B008A
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 06:31:00 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 179731DE5B1
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 10:31:00 +0000 (UTC)
X-FDA: 83829427080.26.964C6D1
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf12.hostedemail.com (Postfix) with ESMTP id 274CF4000C
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 10:30:57 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=Fv8R9wE3;
	spf=pass (imf12.hostedemail.com: domain of cascardo@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=cascardo@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756463458;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xxHiL5pC7W4H7jqFvU/eKmDKFAZbn6zpj2ouP4FN9XA=;
	b=eXoX4aI+darAlZyFZdU+YgvJh+rUsvIMnYtNTzKHWMVZvbJGoJn9kwSzGHvH+Q/p1iInym
	a8eHt18seiVCr/lkZQU2ae4UXe16OnKhZ7FIzjGmdJR9pNtIRji8QMukGHybXbCoO0DI3D
	7ayMUJjSUituMdyi6/mbFDAl6SZOt+U=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=Fv8R9wE3;
	spf=pass (imf12.hostedemail.com: domain of cascardo@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=cascardo@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756463458; a=rsa-sha256;
	cv=none;
	b=6L3RyPu2eg4mN/VTZ9WspYzDGlMzLw/sZlE233BCA055xeK1ZBsu8GBxf4enxvnH/bcnVY
	oAV6fkpg9lK6xziN/07Xmq/M36ybYO6doiw3FytE26jqpQLRfXe/QDN7t4aPfYVyosQtCS
	zf9GL99ytzvtAzhU+sU86itk7sKya+4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=xxHiL5pC7W4H7jqFvU/eKmDKFAZbn6zpj2ouP4FN9XA=; b=Fv8R9wE3zxlyCryKWFyrovJl2R
	23qwlIO0d5RbKIgVPe0MUZsibOZCFfwqdYp/+nJzwYwS5Ri6/uVXScFiNT2+p9VMStzQR93oRR4KV
	uZgwvkMcFKpghCBsgoMgkMOQQAmmqIzkpRpgvliRe9hO3aWOJSN/kvlRh3JhW2A2KUi5HAfwCnqx4
	WvBPoqvgLmtj9JknRYclW3ABYE41K9LpmkGOVPZKWRc3dD8/SbPMNmieZPJSQdto/jeE18En/9HXy
	kR2M/kH9xNabdM53wpPAKY44NFmQLgNszOENAo+czQlurtepr8WCBBQXkzOdab8AK3r7oNXqOrXe8
	hsF61yug==;
Received: from [191.38.27.188] (helo=quatroqueijos.cascardo.eti.br)
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1urwNa-003mlJ-7h; Fri, 29 Aug 2025 12:30:46 +0200
Date: Fri, 29 Aug 2025 07:30:36 -0300
From: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Mel Gorman <mgorman@techsingularity.net>, kernel-dev@igalia.com,
	Helen Koike <koike@igalia.com>,
	Matthew Wilcox <willy@infradead.org>,
	Thierry Reding <thierry.reding@gmail.com>, neil@brown.name
Subject: Re: [PATCH] mm/page_alloc: only set ALLOC_HIGHATOMIC for __GPF_HIGH
 allocations
Message-ID: <aLGBTPAphSP84jZ8@quatroqueijos.cascardo.eti.br>
References: <20250814172245.1259625-1-cascardo@igalia.com>
 <10cdada2-f28f-4868-b821-4a13ed627e76@suse.cz>
 <77058118-b481-4c45-8f86-d9a67ea6a187@suse.cz>
 <filznxw2rq5ylpawl3auho7luiyaqxkmitf76bbpxyihkbkw43@pos7qfwb3i56>
 <5e3bd766-0845-4d7a-acf3-1493eb925451@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5e3bd766-0845-4d7a-acf3-1493eb925451@suse.cz>
X-Stat-Signature: 1hkw31qyah4iyb4uo4xcfy1zbtgjeumn
X-Rspam-User: 
X-Rspamd-Queue-Id: 274CF4000C
X-Rspamd-Server: rspam05
X-HE-Tag: 1756463457-497899
X-HE-Meta: U2FsdGVkX1/27Xq+SeIspLq4boxTVE3XGQC84K3LtdQB+7pUQ1uV1UTizTdIA2uKvenbTr25r+yBzXsYGJUA5+Nq0X00tEcun7bX8Mbls26AKqbk3Wu40ntT64+4ACht8r0BePv3+AFIDFve6CdmLQB3ZSUIkx0HMJJCdXnbgGUM/+4lmPPWa591p/prt0mr/KEX46+VxFt08iw1XHlz4sfvip9TXIg5WnypFIXQrwkcXpm2RSrp/EQq7xOXLrZkBnPmrZ2sqgU4FDTE+F98c+ELnjS83A1LBcCHz3udAuuTeZyOrsLCKnJkTC0tK3Nvreqzml+jl850Za/BIgOG84hhaZ1XVlwvLZAarXi2HGfm0cV4ngEqF3TxnUQE451WUJdLsWKth3+dVzPFhCQdzISdCEnCnx66JBxKi1CrURA0Gnwg1xq70Re4XIDBeHClGSJfMKVOIFExf0drD+aYyKECKL0Ru6QHvVYigLljP6+qvhwPZ0KYjNZyc9p9kikqfb/WaK1ebzvWfqB7YC02+H4a5TM6QrV8w/g6DLNrPfL6cFZk3RtQXEtC229Y79BdLlo0l6VniYJgpmB1Ua45wh6kKf/6sAaOqA6ikylKXRdvSLiR6G5bQWmnhenh58sxmezEicSTxTmIUEjjdtGTzsgVObF1o9KLUbQkmV1tB/p5i4c34Q7SaXWbG7mGIsd5y4zDNN5oGqSOTRYAB2skMOtbNmxOKbJk22vXL4sYU1ypjmXj59Yf98PYvoBKnLKnjUv9YSmqVUUV+iX+fHDrTnBpIAxq/FoyZ2C3n9T5xPZNbDAt2TbKzlnl8zd4yYfe1sw8Kk0BCsOGx94VwivNvYCjdW5lSdjwiDBMHp0hbwCgyF9JSeks9+ZwB3QxT3iN8EuFt7mA/24dRp7PCPq1pmoRRCRG2i/m9M8q/L662fSVtHTsR/GoqwQ4gKdUZVDhAR8f8EEDWT5UK0zBazf
 YYMMKSgf
 RxMDxV1VJ4aKY6kfIFw+eQQQcgAbu+OcvnKNRb2ei/Di78lojJq16rFJ/RvfpOq6WUu/AX48ZY+uPWAMD8+5/bSIQ4OjgD0cE/ksCwBM9s1tcduDp41/pDdSi2dsPdA208wOS6tnOsUVO1AwGdmEqp3crPM3qwWafMi7eLAslrPn9/Fh0QU8Ab/RE6cLJjabBRYi8UydzH+tw2Kc09Wl3qIhiBapeZ5cBbOja6NF//roNuprkGd3S3FPQF1cH8vJwj1oFDJsCi9alQBmWzC8VwwN7YXWQfpbcL/DOmuS2HnMXW1qKJtxnwy8Y0G+OoiS1S1BNERnTSZtTbyo+ERQbdEZl36dPY0Kcn+GTO/zruhOLVhlhDEohDc11DqlehB2Uknm+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 29, 2025 at 11:30:17AM +0200, Vlastimil Babka wrote:
> On 8/29/25 10:56, Sergey Senozhatsky wrote:
> > On (25/08/29 10:38), Vlastimil Babka wrote:
> >> On 8/29/25 10:36, Vlastimil Babka wrote:
> >> > On 8/14/25 19:22, Thadeu Lima de Souza Cascardo wrote:
> > [..]
> >> > Agreed with others that this change matches the original intention and it
> >> > must have been an oversight. Also found nothing to the contrary in the
> >> > original threads.
> >> 
> >> Oops, forgot to add
> >> 
> >> Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
> > 
> > Thank you!
> > 
> > FWIW
> > Tested-by: Sergey Senozhatsky <senozhatsky@chromium.org>
> > 
> > This needs Cc: stable@vger.kernel.org  all the way down to 5.15,
> > as far as I can tell.
> 
> If that problem bothers users of LTS kernels in that range, we can do that.
> I wonder a bit how it was only found out now as a regression in the
> browser/desktop environment test if it's that old? Is there another factor
> i.e. some new frequesnt source of allocations that trigger it?

That is not. It is just that there was an upgrade all the way back from 5.4
and, then, I caught this while doing some code inspection and reviewing the
patchset I referred to.

Well, I also tested that it really happens and caught a unix socket skb
allocation triggering that as it masks off __GFP_DIRECT_RECLAIM.

Cascardo.

