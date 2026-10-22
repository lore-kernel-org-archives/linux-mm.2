Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BE55606A31F
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 21:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=cEEqO5Il
Received: by kanga.kvack.org (Postfix)
	id 72E016B02AD; Thu, 22 Oct 2026 17:07:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DD2C6B02BF; Thu, 22 Oct 2026 17:07:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CB226B02D5; Thu, 22 Oct 2026 17:07:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 35A836B02AD
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 17:07:17 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C74F71A02DB
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 21:07:16 +0000 (UTC)
X-FDA: 85351497672.25.AD57B73
Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0818AA0003
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 21:07:14 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cEEqO5Il;
	spf=pass (imf15.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.179 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792703235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NVvn1gdNdOMG1Op9Y4sTxzvbtS66jmeV2bo4ZFR8VLI=;
	b=xKRFqMyouXF9EBkSBTxNrxkfmlHbOvTNEXtabmzjzQ3Owgut23jgOsh7YFfPt0URoDVSJH
	2WoZnPG0tb/Az1Vd/ns9k5lZYrc6Ls/mLQ8L/8tUn9+j0+gOZnZBMdpsEJ1+CnlnaFZx3G
	33kvBamAX9tHCvCBqzKZzn1yl39iQuE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cEEqO5Il;
	spf=pass (imf15.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.179 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792703235;
	b=hWIUSmp9Ov8kAyE7Koa6crBId3Ey8jsuEqBDCEUSpDd1LJ81shL9ES8VYwVBuijfbpi3b7
	C/F9N4GzgydR7iPu50W0Bv9tfd4pQ+QaUzcXjHCm+whDik3XTEyTZvs+f5LsI1FsSA8Aml
	pLvDyhBMkgwGOor8oCshbBjJ1kU9nCU=
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-8b0f59a5fdaso2620127b3.3
        for <linux-mm@kvack.org>; Thu, 22 Oct 2026 14:07:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792703234; x=1793308034; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NVvn1gdNdOMG1Op9Y4sTxzvbtS66jmeV2bo4ZFR8VLI=;
        b=cEEqO5IlUVrjcvRmTsu8zU28GRHm8b+Gp7P/3gtsobKBSqGKcNvHFYKXYUAyWz31tS
         fQufjTL7ct4KV4pKyrQgdpMIfXqpV74SjionZylTFUFC+f9pdVUE62tQCQ0q9ct2ZSm/
         eZx9JflPoJbSzxriDojZQ8xOeRfOqLHguiOLRMhBLjcJQS+QCsbyAGakVVX+G5NbCkbj
         wBTUmQqaKh/yOvpPS8uSQ6hm1cH26vo+lz7JWmFUNXyW2Q/fELvPb9EPahHoUtWZeJX1
         AmHYs+dLxgwl8kae6vwtMVmr1EwMIjT0VPx12r5Uqq2UVNm1JOqn9aXp2dKyXnQ3xLj1
         HmkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792703234; x=1793308034;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=NVvn1gdNdOMG1Op9Y4sTxzvbtS66jmeV2bo4ZFR8VLI=;
        b=rdVpVwCSZ8bV5adWc+Xyn9XbNE8Gam+xrwIWeP8nVP35tJiuDPvl9tows9oNHUU3eC
         r9d5BFRmYtnaJ8WaSl4W1YkQIe/lXzNEDRe+i+vA4WnDy3/Xj3QYtlIAtIdDyq4NUnaG
         Hr7pMRPB4xy2BOPdu9dkCDC3GuNzIr1CPkHcFloEQca+LqEkVGIfe/uPiQ+KXCunsIrX
         OJIA6TtkssiIAq2FXPYscZLZZ3hNZBz8pRzTBj4bJsI+wFQu8FhxscChHBk/C9uCn7me
         21unFVlgcYtVd+Q9cv1S3Dr5nriiW4+OUw2O2kE+mzKs6Us16qcjMVXastV5WapMgevE
         SEsA==
X-Forwarded-Encrypted: i=1; AKwUvByEPzQbJlP3O5q+w0C18A1vZFHpn4mcFBtJ5kDfv2OvnPc5/79+C3z3v/59O9YmBSnDoxScRteAdw==@kvack.org
X-Gm-Message-State: AFq9FYJVF9aJEG5at2sxyOb1ZyfKFgSLzIa0LV863bnonPUk8zXFr0Li
	Yr713+GgPmjTgTk/VElRi6/vW5wr1+prRZE2y6EP2XI5IEJw2K5zRELI
X-Gm-Gg: AYBFou2pVN/18RNkAzlrDJDMuQBsCOvs9RHY4LTdEivFp+wbeeZap3AJxDb+bBBIyZk
	adconRVfKc1buCuwXZwjRRchXrkEqmlsGS3ZZKJCXrgsQ7TFBid3RJ0cL4Q93xv4qRJ5pxMUXBZ
	cGVwzsnJ14jhiBRiou9IcWhTf6U5iXAeQwR+IjSJq8YsigxEhPB7lSARXcz4XMl007Qj39/n1/S
	EX2fECHqQkRYHxg0bsRt+KOreCPswfQsPSKgUgq7hTiWG9oU0an/lBqPaDIgxgu3dQtqYM/O+il
	rOxw4e2Jr1lWjbuL77+XLgl0QsUPwCFACQoBeZNPwKgaHyHFHY9Ejx9rxfuYDKW58uGPFxwwUP2
	iMPCKFMykfteW8YsEe/CGrg9oqOq+T/r2bHCHUtFOidsmrI/SLufrW2V+Xz/8cSENUxkeiAyXDV
	iFx+/1oPYHWANEE6Hc7uoosfT9aiUpjKguVpeYPt04DW9t/FuMZKHm4c2mIn1tDvJZasv8eZ+Ok
	e94rkKyAWr53RYYp3TuojoQ5s/emalr4IDWUh7VQuG5sEkbnKRa4KTVSDj/JwQv5Z6HldCavIBE
	JA4kIjodFg==
X-Received: by 2002:a05:690c:399:b0:8b0:cee8:53cf with SMTP id 00721157ae682-8b157ba3ca7mr2672967b3.3.1792703233988;
        Thu, 22 Oct 2026 14:07:13 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:f::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b1560cd3b4sm4094037b3.8.2026.10.22.14.07.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 14:07:13 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: "Zi Yan" <ziy@nvidia.com>
Cc: "Joshua Hahn" <joshua.hahnjy@gmail.com>,
	"Gregory Price" <gourry@gourry.net>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	"David Hildenbrand" <david@kernel.org>,
	"Matthew Brost" <matthew.brost@intel.com>,
	"Byungchul Park" <byungchul@sk.com>,
	"Ying Huang" <ying.huang@linux.alibaba.com>,
	"Alistair Popple" <apopple@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH] mm/migrate: wake kcompactd when huge folio migration fails in numa balancing
Date: Thu, 22 Oct 2026 14:07:11 -0700
Message-ID: <20261022210712.1239721-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <DMBLJDUCMJI6.2RDRAALJ84225@nvidia.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0818AA0003
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 4ada3u1pd6z6gjc1gtunnubt68o7soy1
X-HE-Tag: 1792703234-59831
X-HE-Meta: U2FsdGVkX19iHKwdlNjzVD4uY9EVDmCi3i3tCkeaN6n02gG8O6BbyyWxOfHvA9N/gr+i0DhAQ+yKK89dKQCHyi+UcvSXZ5kFqtT2ov5XZ/H2uP3H+ybze49OU21Hw59yjXRSki6eMjCZn7mTkZMv/UpnWxul1L/OwBw8jCrNb5f5xeEEouKklOdiBCPcfGv9LQKzYQcVLfY5tuYZJzMKiUuv90fZdN2D7rRVz55h5t/Up4UDFcfGdITTvuu+Wwa7j7YWaiMQ/9GRrylaGFx6HkE/zJfmsfu8ASgrAxQhLUX3ZQy3fo+0XOENWvR2E8rQfb2Gl7BlEQkcl5p/eLI+ZYSoHK7JwqdTl2SXjnuNPqm5deyPVrhz6WFP0CrNNd/tfFQWooVj6/heRTmu+7kGpAtxRGcvuDIKYe+a7GioFzYBdvhSkakd/46xkLO7V6/ai1c/IzcZFHZbUtG14s+tk10ZDPr5C0p8qyurXww+8MFdxUZDSDMkJnBs1BcVDomywnsj5PmHU63qdrfQylNWMVymXTavBuEg4lkbhZy2i047/ykf27AYvo7vaOwOjUpTXvWmOpGw4YBhAR8zGJvgJc05JNlXnIyQG2IGirhP2TdJtYGEiwvCRXCj5q5L+Dl4c1sLaJZ07Exj3hfO0+hVj44Gv5mLFBsV4AoRlPOMSa1nAoSxJ7KRdZdSc8QifHSzqr2AKyXRDIEE9H5+SMQ1W4jY6SolkKm6Fid5XEFvHIj/Jwl1w71qnpncp8LY0y0m4RdJk6S8w4goDXzZYfGe7DD7m+DOko61O+tAqinoGvAd/NNx4i6Fwj3aU7BrBN401uV/ruRybaLIv/CA9pFaXedTiM8axYy3LApo27v7ku1qSHxgFY5VXh/3CW8Uz9grvGAsT8yPO4Gh8kwuPhCvzuZVNvVUtLfZKawzpAIV15WFZa3ynY/sBZgESjzhiOFBWZvP3AwWpjuiYXkg9eC
 33xpl+ru
 zhtj3l3QNWYgfkaBvXd136li3Uu6+tNMlfTRTsPmZf4ru0ONo7ypENdpnyfSal/znZ0z2I4l8zd/0nn1cf3x/y3zK8Jjt1lt6krA/7/ckIkxoWKmFUonMeSmdEvs7UrCQV3WD/fIJ0WNpu20jyglq533VncPPVvK1OsEQ7HqmiUmPUDZO4I0Ycdj/KU398IfWA23e1qkL71YDqXAhDmTpL59WxUHnrrmc9ro/8XUF8CgD9N+dYwRFizjC9bkCtrMf8UF/FvlWqDlJALTP0mp/l1SuM/yKgrYHmcELEmlPV2Y1+QO5lp5nTLEXMiFzGIT2c0VuTYNGas+S6jb0MVSbc/R6Rnwt9KzqhFozOphU2j5xivoeSMYmgceGX9kAvoAyUu3Glvk5VE/iw8VrrBs3JKo1YnFFUEHU+bH8KhuM/kLjHbiamr4uOc4/PpgB3mel9VsFLIdPtkXy7BFPlPWa9xF3d5aKDDhTh0ooDzmv3uLoyJmFxrVr8lXATORVWDeTCcfOD4TPxqFzB8/AER/yDOCYTRCU5sd1hhSPzSTzut56TA+egtrbkJGpXX81Lxp0IKtu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 22 Oct 2026 14:59:17 -0400 "Zi Yan" <ziy@nvidia.com> wrote:

> On Thu Oct 22, 2026 at 1:25 PM EDT, Joshua Hahn wrote:
> > NUMA balancing migrates a misplaced folio if migrate_balanced_pgdat()
> > finds enough headroom on the destination node. For large folios, it then
> > allocates a folio from the destination with GFP_TRANSHUGE_LIGHT, which
> > wakes up neither kswapd nor kcompactd. This means a hot large folio
> > trying to promote to a fragmented destination may never succeed in
> > promotion even after repeated retries.
> >
> > Wake kcompactd on the target node when the destination allocation fails
> > for a large folio. Don't wake kswapd, since this path can only be
> > reached if there is enough free memory to service the allocation, but it
> > is too fragmented to serve the large folio allocation.
> >
> > This patch has been A/B tested on tiered Meta systems (DRAM + CXL)
> > running identical cacheing workloads. Without this patch, we accumulate
> > around 4.5k failed THP migrations over the span of a day, while the host
> > with this patch accumulates only about 80.
> 
> Is proactive compaction enabled? If yes, why does it not help?

Hi Zi, thanks for taking a look!

Yes, indeed proactive compaction is enabled with vm.compaction_proactiveness
set to 20. 

Hmm, I wonder why we are seeing this difference then. 

One reason that I can think of is that kswapd is awake very often. My
understanding is that proactive compaction does not run when kswapd is
on, with the idea being that if we can free memory, compaction becomes
easier in the future, so we should try when kswapd is done.

When they overlap, then proactive reclaim is suppressed, so it could be
helpful to have a manual trigger to wake it up when a high order
allocation fails. What do you think? If it would help, I can add this
detail to the commit message as well.

Thanks again for taking a look, Zi. I hope you have a great day!
Joshua

> > Those migration differences leads to about 25% reduced CXL bandwidth
> > usage after applying this patch.
> >
> > Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> > ---
> >  mm/migrate.c | 13 ++++++++++++-
> >  1 file changed, 12 insertions(+), 1 deletion(-)
> >
> > diff --git a/mm/migrate.c b/mm/migrate.c
> > index 7bdcdb57652f8..67364fe0851c0 100644
> > --- a/mm/migrate.c
> > +++ b/mm/migrate.c
> > @@ -2671,6 +2671,7 @@ static struct folio *alloc_misplaced_dst_folio(struct folio *src,
> >  	int nid = (int) data;
> >  	int order = folio_order(src);
> >  	gfp_t gfp = __GFP_THISNODE;
> > +	struct folio *dst;
> >  
> >  	if (order > 0)
> >  		gfp |= GFP_TRANSHUGE_LIGHT;
> > @@ -2679,7 +2680,17 @@ static struct folio *alloc_misplaced_dst_folio(struct folio *src,
> >  			__GFP_NOWARN;
> >  		gfp &= ~__GFP_RECLAIM;
> >  	}
> > -	return __folio_alloc_node(gfp, order, nid);
> > +
> > +	dst = __folio_alloc_node(gfp, order, nid);
> > +
> > +	/*
> > +	 * A node with enough free memory might still be too fragmented to serve
> > +	 * a large folio. Wake kcompactd to help the next huge folio migration.
> > +	 */
> > +	if (!dst && order > 0)
> > +		wakeup_kcompactd(NODE_DATA(nid), order, gfp_zone(gfp));
> > +
> > +	return dst;
> >  }
> >  
> >  /*
> 
> 
> 
> 
> -- 
> Best Regards,
> Yan, Zi

