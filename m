Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EA52CD98CC
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 11:50:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D3336B0092; Thu, 11 Jun 2026 07:50:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 483D96B0095; Thu, 11 Jun 2026 07:50:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 372E56B0099; Thu, 11 Jun 2026 07:50:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 269B76B0092
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 07:50:00 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B54D68F6A3
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 11:49:59 +0000 (UTC)
X-FDA: 84867462918.17.AE16C59
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	by imf23.hostedemail.com (Postfix) with ESMTP id AEBC8140006
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 11:49:57 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=dqWs9NKu;
	spf=pass (imf23.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.178 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781178597;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dNgsH2tvtJn5m59hVAt9rmEgOo4VHkNi7fOm5lsoIhI=;
	b=XcpGK3NN0NF33YakzVxizyKAzpmX8LZ5LL8zpFHx05lm3lWZgqMw4Jo8oh/7XVwx+Spuxx
	sa867w6+unb1myqHsMnNnrNaO12rmhCXkvfrzaVDbMug9Qq/9MTmN+HQEcRiDHw1+oQS6A
	XKL9bhiVJp2RydmMGQC7t9H8b6yj584=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=dqWs9NKu;
	spf=pass (imf23.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.178 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781178597;
	b=3iw1CggyCRp9RYhqsMemYI7KGwkqhfe3XRgMQ/d5eOTx7TTeR4z16OD+ABoA5QiGemv0YN
	fKea1vndCaTv/eFPUsZycid2M7xxt1ey9z9qQuPdEdHaj9KAPncUyvpfAPsnv0WoePTp3/
	2AElbxMq2orIe+InXmRUz96T1RdRBls=
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-9159da9bba5so571499085a.1
        for <linux-mm@kvack.org>; Thu, 11 Jun 2026 04:49:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1781178597; x=1781783397; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dNgsH2tvtJn5m59hVAt9rmEgOo4VHkNi7fOm5lsoIhI=;
        b=dqWs9NKuvZb/BlXCycMAwLQgeRlZSK61NI47zvEA+tEXkWqV2oSonlgeGcLXY+HQlU
         Bm5xIQ9RTU2W3X7LtpqsCqvfH8Zx9d3RWdBnSk+kWKpyJjfJ8gDJQYGwpnN2hpS4bUtw
         0FHI/fLF7YxgQV3nKrmKXsnvJtQR4FQAiO/7Sqyo5OlGmGijGhjIJrdVpveepoqzkh0y
         hUlUC6asbAiV27wmEwKdvH1xBU+8jBofKpAvE/5bPhr19UJBR0snW+1LNiApY6B31Z4P
         98TzDJTRJPEkVnzdtN0Fxbn7i7fYzw7/R9OC153yKZyK6j9sBoCIoI4HBXopqtUxP6Aj
         1QUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781178597; x=1781783397;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dNgsH2tvtJn5m59hVAt9rmEgOo4VHkNi7fOm5lsoIhI=;
        b=FXs2UIiV28JQdRm/W7HOEZqV58Pqc2O1M2QRtc7R0niAFAkx9bVM7BfYJOWKsK9woY
         OTkRrfq2hQ9KSN/ZpojJVY94CqdRhMSBZHAVUMwKVWuJDwN5xtcCyHlIZSRzbXrmH12R
         74+PQrMhOjtNHahPiZohahTSxOpSWeUDWICzcrxhfjaSGQelxFJJQPkD0pKDIj6ssNTS
         py9FvDiuKbrgiChiEer4xbox5Cd+VLt2ZT+sOXTcHNWDLCI5t+nvITPzIFXm3m+8RFNG
         Q5Vxo+hOZAvl9ACoOnglz4AXH5Haxabaex6aQ3/6yQz9fTPuTt2QHxCJeeeMB09KAqcm
         Dr4w==
X-Forwarded-Encrypted: i=1; AFNElJ8Gi+6v7PtF8bFqnD//9LprjN34UQHg+32uuNgmIks8adgkKoJWCVu4OgFfxifjFyE5GSk0NHDhbA==@kvack.org
X-Gm-Message-State: AOJu0Yz1E70jmVJCDuTstlQh7zFeYIK0LX0Asrrc5stkxZaPC4IIEipx
	Zv/JD/36yCQ85IAKjF8iZvbg6z4SUPtPyDwCsYcB7Jcq7d7GzvWEbxtUH1q8NwSF2mQ=
X-Gm-Gg: Acq92OHSvVgm5IyNEsDSO31TDBkzkGWpXekfmmCMh2lu5t9SqdJ504xghYJlydkOhXS
	uiMIy6+S0wZMle2jf4+tOvshHMjEVMk7uan+an5DQABdFhp9CoPkvGObkouJVejZ7saw3uvU4br
	J6DOcrEwTKVcud6WqF5s8Zzj0k32yfH5ynuOvPtj5bHySb9Sn9X+faSIca1dHfAwHj2L5ie4rwV
	IJlUo8X5q26oYW2yvRkSySMKbLJaJVqaQD9MX9GB3OEFc1LKsCUebqw7dWHP9JlTRhf6pN0WTcv
	fMjGzTtEyAz0pA0WD482sNzJybIrIWiF9kpw3tRzlxLzsHwIIyXtCYGUNvgg5+k1sVzmXExXqmV
	urH6Naz2RQbx3vp9NoaGvyVAFKoG/gHl234OCv+cZNyE8NCrq4i1dDzMQoTiKgTSSUyufzuHyEw
	4ctUJbJKTrShNs7pHe0fQaY2dsCRt2wq72wWDe62EOq6xPS6o8n1/xEgQU+Xu0XwmIQA0/CxrXb
	qTL0qQ3Ayls2oGV4KaDF2J+P3I=
X-Received: by 2002:a05:620a:1a12:b0:915:87ad:d5b1 with SMTP id af79cd13be357-9160ab34661mr372192085a.15.1781178596642;
        Thu, 11 Jun 2026 04:49:56 -0700 (PDT)
Received: from ziepe.ca (crbknf0213w-47-54-130-67.pppoe-dynamic.high-speed.nl.bellaliant.net. [47.54.130.67])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9160acab48csm167602085a.16.2026.06.11.04.49.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2026 04:49:55 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wXdv0-00000005gTA-3lYL;
	Thu, 11 Jun 2026 08:49:54 -0300
Date: Thu, 11 Jun 2026 08:49:54 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Kameron Carr <kameroncarr@linux.microsoft.com>,
	akpm@linux-foundation.org, urezki@gmail.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, rppt@kernel.org, mhklinux@outlook.com,
	linux-coco@lists.linux.dev,
	Suzuki K Poulose <Suzuki.Poulose@arm.com>
Subject: Re: [RFC PATCH] mm/vmalloc: add vmalloc_decrypted() and
 vzalloc_decrypted()
Message-ID: <20260611114954.GC1066031@ziepe.ca>
References: <20260521205834.1012925-1-kameroncarr@linux.microsoft.com>
 <aibhnnDFQTHWMEFe@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aibhnnDFQTHWMEFe@arm.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AEBC8140006
X-Stat-Signature: fkzxzd69zbjrrdssa5ziw7srnwgdd447
X-Rspam-User: 
X-HE-Tag: 1781178597-495897
X-HE-Meta: U2FsdGVkX19IAd5ntfBITlqIpUig0+RCqG4/KPVQQlDFWt7y8qSXWQ2Dioein/9wKQzl17l8dpiIZC8EfzIc3+9AX/wlKW0XI6eja54R+QxCu+G6Kvca89f/6PK42aSMGm0F+nnPPOb/KzhzqoliJPs0thVIXHuxCmoH4Hqn5d7zPNF6DLfCPCcUIUHQL77iFg6D14GBMYdJ3QB7MMUkuzfZA8qbkp6MN3BGC6ViFts/odmd3zuW2kqbmy+NnCHH7Fg30DIQZgyTpV9rNI/pMKnRqPdpRbb20purUKe2Nj4MS9INmSDBOEfp2hQ8FPmO9QWHXLwwSnWc7+t083x9mXBhPpKas3iCM9PF2kQlOpYU/vsaqp7f5oXxabDzauWvPfFxpnT7HHnO/gP6ytrCxdQvDnJS16FyKbMvcyIItsIM1B23GyaErPAiFbpCb/iMgKUKoSYZDShcoHDqSI5ulGIAJ8lh8ceaPAHgiz7Mk/XKN5bYqZ7azdYqQMaq4Ql5FNKcLfdNhEMAaDIWVLyevO/w82XM6id6ACZNu7s4cUzMGHxu6rVvWoTo/WsC2EPWDo2LnAy4S2Xtjp2gfl8qvNyXxxvKFlhm6rk42yLnlpmIenvkOlnL9oUomGk1acbLH8bw40MnyZDpl10EdYsObFy+RgDP/vjrHh9xjHVqG2lX8UzRP+AtbjvdX/FFWqBRMgUYVBL9cCLy6qgyLjjQGyMVm9x959qR2YF9frUvSDBT6KSC2Cs0WUR0/nh0Vjw7SlEG+wcKwyalVh/jSbKyDItFwYZwv1PQ0E4kcgvT15WD7FAPts4v2oipgZgS4HZCGNNF3xaeGNo4tXHfS7CyESdixbvf5Yu8Knn89P68PS3OpDfcdc0ulFLkJpdW2rRF3Xr4XA32r5sfRek847SprzgAvegTg34FUdQWp7pVCWx3M6WIlw8oZSuNcKxIAsDxEg3jij2DDdnC/IDkg6y
 qwUrDkuL
 hfma9hzEwOSGlQOLesB6WgObgKxJGi/0uDBZjNvAPVM+GXBTS5KaFsxZv4ZD/EBvV+uW4m7lWd/DJtURDp80j6PBGCPrGvUjJ+pw2D9E9nDLHZPZ1/fK5WLuuEPGGS/FU4SxrB9hVrCwPu6fEfAnKZWMyyKEkdqlV2p2+hqm0ljlUIHoxn/4sPv0ZlJ961qA2CRipGUJe1U70owVNH1Nq/wfjUsqTXnz2cniwu4ZlGzhRLh82wKSmabrC8BOzTT6Ek5GKQ+4SxSa3BMXF+C7l85GBg+I6AM2+G0O8IE/c9U5DV/AOZR7pC7ELz10dlDbaXSqKJs+yoE7wORA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 04:37:02PM +0100, Catalin Marinas wrote:
> > +/**
> > + * vzalloc_decrypted - allocate zeroed virtually contiguous decrypted memory
> > + * @size:    allocation size
> > + *
> > + * Like vmalloc_decrypted(), but the memory is set to zero.
> > + *
> > + * Return: pointer to the allocated memory or %NULL on error
> > + */
> > +void *vzalloc_decrypted_noprof(unsigned long size)
> > +{
> > +	void *addr;
> > +
> > +	addr = __vmalloc_node_range_noprof(size, 1, VMALLOC_START, VMALLOC_END,
> > +					   GFP_KERNEL,
> > +					   pgprot_decrypted(PAGE_KERNEL),
> > +					   VM_DECRYPTED, NUMA_NO_NODE,
> > +					   __builtin_return_address(0));
> > +	if (addr)
> > +		memset(addr, 0, size);
> 
> Talking to Suzuki, the small window between set_memory_decrypted() and
> memset() potentially exposing stale data is safe, at least for Arm CCA
> as the memory would be scrubbed (there are other places in the kernel
> where we do something similar). I assume that's also the case for other
> architectures, although not sure what pKVM does.

It seems like a poor practice though, this should probably be
re-organized to use __GFP_ZERO so things are ordered sensibly.

But what is the purpose of this? I guess some hyperv thing - but
shouldn't we have a more structured way to "DMA map" things for the
hypervisor instead of stuff like this? Why can't you use
dma_alloc_coherent() which actually gives you an address that is
sensible to pass to the hypervisor?

Jason

