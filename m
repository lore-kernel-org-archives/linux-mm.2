Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79969CD6E57
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 14:11:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A302D6B008A; Wed,  3 Jun 2026 10:11:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A07716B0092; Wed,  3 Jun 2026 10:11:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 944976B0096; Wed,  3 Jun 2026 10:11:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 85A2D6B008A
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 10:11:36 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 253A414031E
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 14:11:36 +0000 (UTC)
X-FDA: 84838789392.17.9FBB905
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	by imf22.hostedemail.com (Postfix) with ESMTP id 3F7FDC0009
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 14:11:34 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="ixhb/Ac4";
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf22.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.180 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780495894;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3JBFLHHchSf6Ugt56GZlS5cZe18tTPuP1JId2xHEinc=;
	b=QH/nDCu2yMClpmP01Ik+Jb4H+lJPCABQNr0ctyz7yiue3NclGxZy+qdGtw2adtuAks2XO+
	f1EA2yQK6bc2qmjJ1Tj27sClQQa3xxGvkB6Jthjynwqn7A3Q48nYSveeWq3W0UXrfBgFNf
	cWUt4TzMATetD+BKK7N+8FCwbSKFRmY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="ixhb/Ac4";
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf22.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.180 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780495894;
	b=FFyKK3koXADDltpLARkHHE9SSItoyka3T4V/2KLCweup3N3Dc9y6MwCt0CKvkE0NZ/oDlM
	n2EocfHRSLXx3azZ+YDNwY72s7WdzL5vaW4EAZpuJRTgugpU1oJ9zdrpAtzYGOhS89TvUY
	t5BIrMYQyJDve8WIrqLXxLzYv8sJF+U=
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-91587626ae1so160429185a.3
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 07:11:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780495893; x=1781100693; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3JBFLHHchSf6Ugt56GZlS5cZe18tTPuP1JId2xHEinc=;
        b=ixhb/Ac4oCVnG3eX0QnvU+pbOKIdCZRySdX7WdJmuYHUxgUGGAHeNt2JKLixghp/KS
         hC9fEbW6aUrJZatHiGDXFJujMbEyC96wi/wErjlPsnoGdZd8acuBzRDhqU1co9Y3HpH6
         gxq/7DYYj7IDz2VqkQZaVksz6+C+vCU6qCzohE51A5lqEeGIajnyNjBRjNabsoj2Suro
         KTVwreUosQnQ3TGAhMhJhlfumpp9+Kc2UMi9QIp8mA4snCUjQbVTO6paVimIDiocVLRB
         w6Fujc75JuF5Jgr746mHCIcTSaS2PamtivKZeAFc6Rqq+qfm1KqgTj4yAFhUAAnC8kde
         ImbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780495893; x=1781100693;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3JBFLHHchSf6Ugt56GZlS5cZe18tTPuP1JId2xHEinc=;
        b=FJPa6a88l3EWs4FOG9TSkyuzSwmfsHQrfSa2nmDxLTcEzHmZvbakS7POhfCXQWHRlN
         cUpLzxuvE+O2DDAulp0PEYFY0cce2kXFat1HtikOE+XhHQKpBIv0yLKiAsV/m7vDbgqJ
         c83zUEnIC0DKuI6AypJyHyc7ZBovzzJMp732/cs+ozcQZ6YHy1FdtbkTpzPM4/pTseZ3
         UdeRWaRgpfQthtlQdEjEQLlJmvyilG53+84uLdXtItgamM8Pi1HeUPdGjxN0qQOpgRU/
         At/tTFjVAmP9R60kJlBW2f2D1XNM8rmc3+BIOgrxVRHUdgWcY5zfpd/iuCIGoAaEtMFQ
         DhrA==
X-Forwarded-Encrypted: i=1; AFNElJ8KEuN+lydrkd/P8dNMGE64+nJuS4+pKeAoL0KIvNufhXnyOZ7xUZVaLQlfn8d+OFxKWOyUnlRZuA==@kvack.org
X-Gm-Message-State: AOJu0YzdTyKiclLxTaUmpF4jeAUoCw8UeOc+nxbEDJn9oKaSlzNr+MJg
	R8X54b7tUAVxS3brcNDDxu9f4ImFa6pWtSLT45W2SFRa+obeXcPgbrV/2qejRqttr45QDOpkFZP
	N99Dt
X-Gm-Gg: Acq92OFd0OkHBjHG2p0KSXQUYWVXtEgi2gccBKuawjQLojmV77N6v3/NO1cxYXyNPr4
	GTUKmHTzO+kjz1lnQJYmoWCxsEhWtVuy4JflPiz+bAf8OqR7PSxutTT3Lx7r7a1aSWjCCYvRc2R
	bZdBDk0j7TSvD2M25O9e0aqWmjffQkqlT/kd5pwaZA2BzqrnmIPo1+O7f0/QCfoT3zgTaKknbW6
	iHGbi6dhSJ2O7WAlX90OkQ1toO7AQCm1nOwP6P5NE5QWxvK+OR/ziytgSFR1dDcHX4ewjpBh/tU
	wVAL+FSh5UGiok02YyyMCFnh+D3mA5XfxsCg+yy3gPjoOa1OZW6qtAf6XuFL+wOEtncIoEh22j9
	daCghUj1Zo7qMkcRkeQqLtC04e5DC5yGtnsq+kd4hm4pZwuAwuFZpEBnv5c6+4WVQTUA23L8I65
	hSV7ksVeGWxCuCXJ3A9b2sCSNa6oRSfY9qH1zwKPTYLi/iFLETXnWpsKpTHw7idQ==
X-Received: by 2002:a05:620a:4613:b0:915:4ca3:61bd with SMTP id af79cd13be357-9158a83f992mr602997485a.59.1780495893289;
        Wed, 03 Jun 2026 07:11:33 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9158a402ff9sm248774285a.45.2026.06.03.07.11.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2026 07:11:32 -0700 (PDT)
Date: Wed, 3 Jun 2026 14:11:31 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, 
	linux-kselftest@vger.kernel.org, shuah@kernel.org, akpm@linux-foundation.org, linux-mm@kvack.org, 
	skhan@linuxfoundation.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	corbet@lwn.net, dmatlack@google.com, kexec@lists.infradead.org, 
	pratyush@kernel.org, skhawaja@google.com, graf@amazon.com
Subject: Re: [PATCH v6 07/13] kho: add support for linked-block serialization
Message-ID: <aiA1slnqPnC4_8XY@plex>
References: <20260603032905.344462-1-pasha.tatashin@soleen.com>
 <20260603032905.344462-8-pasha.tatashin@soleen.com>
 <178046937151.468621.13398573538792303093.b4-review@b4>
 <aiANtYRRDr5iO5QR@plex>
 <aiAzT9TvGYjITiB8@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aiAzT9TvGYjITiB8@kernel.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3F7FDC0009
X-Stat-Signature: 5rr5kc9fnae3n6n13dhfnr6o7nraz7z3
X-Rspam-User: 
X-HE-Tag: 1780495894-212813
X-HE-Meta: U2FsdGVkX19UWGzN5RjKX/bDttjoa194Rd/wWhXJqyAT2+XdB1nym72Dk/aHsJizbmASGuq/FxdQGojLy5Z3jRYZ5P416zwop8JzNdQUmFFO7AKx0l2ec5pMEHPTqACQuqfo74RvsTdHnHlICNXSFvuZNOgGt0jcbxsPvgkRe4E/JeD4rEJ8LP86Vx41/ct5OSRduMdrnTmYeaxQRvkPsjzQ/LoQqXU43mLvgMtuUN90R7DktJ8n0qnTTRR//ipbpWU6sXQLZOH/C52gfTr+O1gMkOuiS5S3/7Uf9ZBMg9psAc+0zH8a0gUzbeu0Et4+XAQ0XnJRYy5z+w4n+QDaeJNyk/en8vDnk++cblkLu3FEYYusfNdkLZtvY490be5fnbsTyx635ybvX1zeBwdV1AQ+fvi91rOeCi7G1yW6Q2T8FoLuXpaz8uhflho5j+Nm+nFrZDo3AAXp1zXyakXFHPWhQFFWmdzAfEfmzJiQjrgAbrFt1Hy1xhkeu+arAYWzmMXoucNZqMhh1BEAPRHZvaLIdOSgggNp4FKrgDKdCD8/bOUSmT9TaHmKkAFJsYx3JZADaW433bzAWqoSt/TVT/eI1UdfCZji7EZfTAI9hxg4Y5sumXxqtLGH//liKMOKoMV5lkE8poWqbQhsYz/GHXVSlZt+RmI1glWMK2sbpdYOnVA9BzH7P9ZAd4C57sbgOYgHryD0DgXLqFQnByKbZ6SLEvG+xUgOi1+8jTCE1rvGM4gN5qQKz0fepxOJr/viIvOlOFUpWXexsHIwGMhUPYF+IQ3bg9ZCEoYaq1Ci3/ZibRUPKHj1TwV0vkx9uJUGWgQG/T/VSqiJUzkKJC98VjCSxl5YtXtxrUmuaAWBvnQkpP4NmrbBRcM08Gq1t2bEz57ywX2c7D2DtfOUiWYsfjzqhR+mD/lkUWoimSAe4kfYyhfYQl4KZ9eJPYEjgZGBy939TWbzX19V2o8tdFp
 stTZVy/9
 mXeQ+0Pb1ePUNmBuQYNNIy5HFkF9+vhBo4Mdh8f5A5wpbbZ8/D/bRynApNDf+6izy0R4C3JEbBK+Ir7Z2+rUZBWg+BqTHCAgPCsPDk6GSjYyq7xIH3yOse89QUIKXFRjfCPkxp3+puv88f8sBB5Dr20qBVTGRflRQjx9TpjCWAdtqNjab+jHD6DE6rrHYmA7oRiX3WBT8njk6Jl21Gp8EuhQtenluJAblyJB/e56pHRo3PvcBxKt8O17hLGGB5NXhzBS0/BCcrqfBm5Bw5UjZdsK8ogEBOR5GoW6Dh18tBoCNgtqNV1v9OT96paxoRz1YtUCWefo3XR5KECp7eFB1CTB1qUtTqaHd01jGfr9s+qBH7vYcJQhffBRW3sNBMWoRAWDVWPv7KT68/STm8C3/Qc7hIHAnSn3VM1XQcnN46sALd16kQBdKkv0bXThTlcWxeaMnZdTdmvFid6E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06-03 16:59, Mike Rapoport wrote:
> On Wed, Jun 03, 2026 at 12:05:04PM +0000, Pasha Tatashin wrote:
> > On 06-03 09:49, Mike Rapoport wrote:
> > > On Wed, 03 Jun 2026 03:28:58 +0000, Pasha Tatashin <pasha.tatashin@soleen.com> wrote:
> > > > diff --git a/include/linux/kho/abi/block.h b/include/linux/kho/abi/block.h
> > > > new file mode 100644
> > > > index 000000000000..8641c20b379b
> > > > --- /dev/null
> > > > +++ b/include/linux/kho/abi/block.h
> > > > @@ -0,0 +1,56 @@
> > > > [ ... skip 25 lines ... ]
> > > > +#define _LINUX_KHO_ABI_BLOCK_H
> > > > +
> > > > +#include <asm/page.h>
> > > > +#include <linux/types.h>
> > > > +
> > > > +#define KHO_BLOCK_ABI_COMPATIBLE	"kho-block-v1"
> > > 
> > > It's never used by block set and after looking at the following patches I
> > > found that it's appended to LUO compatible string.
> > > 
> > > While this works for LUO, I think it should be kho_block_set_restore()
> > > responsibility to verify the compatibility.
> > 
> > It should work for any component that relies on  kho_block. My proposal 
> > is to use this method for other common KHO data structures (e.g.,  kho 
> > vmalloc,  kho radix, future kho xarray). There is no need for them to 
> > carry the compatibility string in their metadata, as whoever uses them 
> > will include their compatibility string.
> 
> So if, say, memfd_luo uses kho vmalloc, xarray and blocks it'll have five
> compatibility strings glued together?

That is correct, but it will be in only one place: the header of the 
client's KHO subtree. Since it is dynamically sized and 8-byte aligned, 
it should be safe to include in any struct.

Pasha

>  
> > For now, reviewers will have to make sure that if the ABI header content 
> > is changed, the compatibility string is updated.
> 
> -- 
> Sincerely yours,
> Mike.

