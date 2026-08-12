Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7FDCC5B572
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 13:30:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D2C96B0133; Wed, 12 Aug 2026 09:30:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 883336B0155; Wed, 12 Aug 2026 09:30:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7794F6B0156; Wed, 12 Aug 2026 09:30:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 598F96B0133
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 09:30:05 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D98D31C0A3B
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:30:04 +0000 (UTC)
X-FDA: 85092700728.23.48E4AA7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2F40220002
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:30:03 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SZuGYHiy;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786541403;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dVTARtfo1PiugiWHu3G7qJctiG0TgL4bcA37kyCP5F8=;
	b=DvgTX7qhYuTypn+cmw+iEe7U8tDqhlZrkkMg6XuSLRL7dJJLhYjTSitbGRO+4dDxtwMsJf
	DdUuoL83Jed1qGked8OUNSo0VryzeejRWq7niMhK2blpT3wA6qx/CFGs9n9XpSMJAi5+4A
	DLCF956JGP9Sf9BITgysB5lEUrYZFlo=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SZuGYHiy;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786541403;
	b=FVnnBAb8hbasCuJixMbLGq3gTEnsoiVQRjJI/oX2EWKrKdrKR5D4K1RLSlVJLSu+p+khEg
	OQvCzZPikJmVIOL0C3tXFtploIkGz8WbR5RX5jSQ8oKxDrLUrtCJd9OirWPBHfz2B3N9iB
	MSje1IdHF9tE/eRGSsL3UbVRO9UGdXI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BE66C60A85;
	Wed, 12 Aug 2026 13:30:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 363CF1F000E9;
	Wed, 12 Aug 2026 13:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786541401;
	bh=dVTARtfo1PiugiWHu3G7qJctiG0TgL4bcA37kyCP5F8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SZuGYHiyUz2rUEDyUByfGDK4x3iKNnliHEBB0eryUYY/AhTSjW/MuKZftSSi1JSBY
	 hYSSo9qbiBusgDbRBW4CncJHlztYTDXWys3rkSN7bIKmKdjG2yuHah8B8TP/tcuM+B
	 XuWoIj92+kF0StD6GsTFwapVWVBgro81zG4dzhpRYaPq/c6xprG9mBc3xuIV9xwHo5
	 HvHEU0SFCNEnL0XL7tpscCLYUBlcwBLsInWBbP03ivJ1mWjv8ysVDhywwdT/VzwUhU
	 A4SlcZbA+y61NgdFhRG6KkQedHvanukyqk54IyFNI4u5EJ0jwS5s61y/xBg9TPuWwC
	 Hm5fVE++VsQ2A==
Date: Wed, 12 Aug 2026 16:29:53 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: add drivers/char/mem.c to mm misc, memory
 mapping sections
Message-ID: <anx1UQb6sQY-QjZS@kernel.org>
References: <20260812-add-drivers-mem-to-mm-maintainers-v1-1-6218b861f4c8@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260812-add-drivers-mem-to-mm-maintainers-v1-1-6218b861f4c8@kernel.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2F40220002
X-Stat-Signature: bp1k6ziuttpxhsft3hmmy3ykciyyu64y
X-Rspam-User: 
X-HE-Tag: 1786541403-200441
X-HE-Meta: U2FsdGVkX1859Csm0HPBLasDu4xX/oY9ZrTFtgOpeQlXFkSfnAXlqOyIsth7hF+t5O468oxH/QRFcyj+7H8CHt6RhdPu/pF3/neYMXbKprVr4wou75kFKIkPOgiB3JBg/STVVT4vQorH3Knn8cGfW3L7Z07yfwQWlvPgD7heY7JkjDgYdr5YLR+mAPCPYpXlAzUtPhgoNtagGSSLx0q0efdLt/tEzgQy4SqB6aXpUwpSETRI8Mhzrx3Bwa2rRMenbCic9r0fyzS/vRdSkbC01He8A2QWWEuuY95sDFMt5NEF1nCJl13X59LUP2C8YBEaAm0dc0gkSXh12v8RMuh3PncVCnrJzEawQsTqm+3Yu8YFYSgyCtQsdLsOLttl5M3+9pC/mHoJSEgSWdJiXXhE8LZxsRp3MHatQa7Z2lvklW/+E3TK1bgQLRW/U+XVkdxffJ+ZuCZ5ZYjFOQLp8HHedtoOfyKe1TRgt+tEqFDmIz2o8fBnK3qJ4eSuLZs9Ooli/T2tz3KLcwdsRxf+L7Tb3KCLjTi14/4wMoyqN0hQ+R4a/pzstKUSYGh6UNJsldRFN9q02iytfHzD1OWNtxFjOENW1L42/WTzTQcsiRTrXC3Fens9ZnxxOCkqFPu+rObeZeTECqqY3I/LR1rfLulHsrZ8NssljI8MaRaviODH94D4MOeOEG2wJL0eXB56eiZoTLm5/R5RZ+tRIPH6ZM7F9ewACcZVIIib1WJixpfSFpvCiscBdf82Vz87LPjrkTkmaOmNumlRDUhKvGXTlVgZUmhZTv3vPwged7XAztyTC/gVSFYgDtS869PHVQXBZszzS6ofTbqtd9M398L/bqT3gO7/KsVlGuMC/nmkrvFXtxnx5wcVlZGA0lu2SRrc9atyYmwwanPx5Rm+4ffh22M1jJPiy4BMeumvwXM04+01kZQCH6VWyKByOuCOXOl/xowuuTQ1R8zExJDzRwvnH6T
 BFewh1h7
 fdr6uE/P8aQHzvBlBMyPBcJ10TWVGmaCLIASrbajsTfngVYdtRfhqR0cK8zOVxdYSliXLdUpsDiBgHCz6W5nSGrroR0ofghUnT+Pzcwqx0qibBF7p+Fl559iYO+hXPbZD0hoHSg77hb2i+MjIsX7+vKGrqXz8IWt0ohILEJntQommPXAjTLLOY0Zu3QZUC2uTO04Bd36nZ10WYcjevuSXKPCU0tkzDLsfDMINhywSOLMQIjF1e+ZnA4tYoI3gt6iF52mTdylfMPPdPoggCRfaMkWb2g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 12, 2026 at 08:43:31AM +0100, Lorenzo Stoakes (ARM) wrote:
> This file is a 'special' driver that implements /dev/zero and /dev/mem
> among other things.
> 
> As such it makes sense for mm to be cc'd on mails and to have some say in
> how things are changed there, so add it to the mm misc section.
> 
> Uniquely, it provides the 'old way' of obtaining an anonymous mapping -
> MAP_PRIVATE of /dev/zero - so is directly tied to memory mapping, therefore
> also add it to the memory mapping section.
> 
> scripts/get_maintainer.pl copes perfectly fine with files in multiple
> sections so everything should work correctly.
> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  MAINTAINERS | 2 ++
>  1 file changed, 2 insertions(+)

-- 
Sincerely yours,
Mike.

