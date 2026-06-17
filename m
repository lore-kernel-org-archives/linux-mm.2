Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC882CD98E2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 14:01:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3FB96B0099; Wed, 17 Jun 2026 10:01:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF0BE6B009B; Wed, 17 Jun 2026 10:01:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DE766B009D; Wed, 17 Jun 2026 10:01:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6D09E6B0099
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 10:01:38 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D83BEA042E
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 14:01:37 +0000 (UTC)
X-FDA: 84889567434.23.9621C77
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	by imf25.hostedemail.com (Postfix) with ESMTP id 7834BA0018
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 14:01:35 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GOXfr9t0;
	spf=pass (imf25.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781704895;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tiRv+G39h+X8YKopQA1rD5KpEf5r1LXb2YHn926YfMc=;
	b=JxtGudPFiTnSWEbi9M3EsxDHdDJe0gbgCwvxpzvgnEKKaPgvVTWq/nTh5B8zJvxjvDvDaQ
	JTPMTrGyT17eMk5SIwj8NdswvTgBPDTxHcUjE1Hh63Ns1KenGebZOpbdADg8an0cNBaTYR
	/w+gr7u7W4iHPc25eyt8F1N/nIR5J44=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781704895;
	b=GtBPPYSepLwhIdIylg+OERuIQLuJYrJChjiSpPmDGCp3ujxiIEC7cak4UUt1pi3oq3JiFC
	bU27hEjFQRho735e4YMbd/u2XnhBMh7JtmawtVRBqjA21nznK5fs1hwd3/D96Jf28RoqcS
	ZiDPV8SP8Mr/th86+h41XhWyP8lL9bI=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GOXfr9t0;
	spf=pass (imf25.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-36da8439078so5043887a91.2
        for <linux-mm@kvack.org>; Wed, 17 Jun 2026 07:01:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781704894; cv=none;
        d=google.com; s=arc-20240605;
        b=hwLdcxkJ7q5ab+DGG7ntvZIKS4SCd9L0BUMN47lEPcG8bGOstWV3VSdoW1Xbck3P9T
         AZQF9tjk6mR7/etZGwckCVuX4V7Ui7ks3EkCVvw7ihwJrK6T08O4MZmIk4tXM+epSDgG
         XQ4DcUOjqJ49lKhe0Sb+Yoqw2YVQVdDCT1pxaX42IAPLPFO/BNjOlei54VhjM0SzFmzO
         9N+v8SdDDUKwC3TD9R9Eznc0Wy2uPbWR17uqzTPaPRFgfDif8btq6zg6bta8fWPYNfAN
         kKwO0KrbvupVrcZndGjXk7zU7/SD/ETFqg7VJY6s6viB70rLyhjxkCQw24IV/RaOFr1Y
         x8tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=tiRv+G39h+X8YKopQA1rD5KpEf5r1LXb2YHn926YfMc=;
        fh=C2AtZn8xIbuKtvRe73/tUKnqCmefSdyXRR7vxiYTQWM=;
        b=IH1mQz8GDkxCEAJFvR7OGTwa4lpSS1oILjXYgHV17uBIgDSk5PM37hFEfwXZleoVqk
         k444ZVq2vmp1Ge8zVqyMwziii2+oUa+k1ms1BpNavH2GQxKdY/9DQNA6UHjGb+YagFhh
         bydG7sYG6Zqte7guurXaoG73mSai0xfKpHmN6yMvCzfoIQAlXI1bbvZljY8USvagsXvF
         ncDqmY3K3KTJfKfMi76sUCwTIB38obH7wOaDcUHg7wb3scbO8jRzj6WioK08hR+s1aCu
         1sGmDqWhMJlWi3gnnQWFXrJASFQydjDb//SYr/N4qDTjFaWaS97MhaiZNgkno3XnKR+b
         Pghw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781704894; x=1782309694; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tiRv+G39h+X8YKopQA1rD5KpEf5r1LXb2YHn926YfMc=;
        b=GOXfr9t03V2YJjzvsRNZtKbapr6Pdzn07SBXynNmpZDz3jmSHHXdkpX4MtcGyyHOUP
         pEQSLxD2kwo2/+g20nMqx7TBmFr1RKq07RWl3BxXwVgh7o1KFh9CPJL0vLUoQyiMB4U2
         EFWRa3EwgPcygllBQGkcPBdZ176cGq1UNfJULmZW39hj5dZv9yMzskzWFKoSwBnewY82
         flfoF8MlaL6oFD4dEotQ/9A1SreSJcdTH8uHUkXtD+YJsMOtA3+AqT5sj4Ay3hA/1BUq
         wD45b8EBsnsGDjr4x4zZ3byfPzKaSIsvOCuwMaIec1CtAXEHle/ctSbwr1EFGc4n18LK
         FBbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781704894; x=1782309694;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tiRv+G39h+X8YKopQA1rD5KpEf5r1LXb2YHn926YfMc=;
        b=AXBq0hM4ofxbG3dwKdW2QgXTK4D4okL65/ZstqWnjvjyW1caSEj/de7l/n8QHFgujw
         fnakyaIg6k4B/BIzLEf+flwWGrMsbc6L4Drl0jgiPyKmeXRz5ChkdhoU/IIMtwUHuCXp
         HYFy6HUBHBTrbf78a5R/hwBmJFjdabQFOYc+v2MweWKuaaRcKBDk8KRL7zCCxV3g+0lM
         sAUXNV7F8f3RyAbkOY/jqne8385zmOBNXqm9tebzl7Q/WkZD9Hq3sRcC63aWLFuO1SvZ
         pdz/eNo5L4fo5SpF/0F6wpYtBK5TylEwXPFLN14H0KJvAc/IcGSckDMbMKlP2uZEOLbC
         vpLA==
X-Forwarded-Encrypted: i=1; AFNElJ/hlxDC0/8on0IqJt0/EuqtUe+GwR09nL0/Rc9d5wggugNp2zwS+r/1O9dePbXGs7eacd7mPQI+7g==@kvack.org
X-Gm-Message-State: AOJu0YyQyYN3x86GQ2UCUkDQvAO+oG3x6LesDORS9fLGJie20gXTsb3M
	YacPrYPfBhmqVSddMo2vS4b+GI+QwYxVyrv8S9/K4qcp78EmwpAP1vVofTNexi+PtadqPgC2EEy
	N739drmLZIw9kCYY9vW7YFSOx1uINppE=
X-Gm-Gg: AfdE7clpZuGxVS6/35RETz58vY/hRG9s3Ih2wW23ibKDQPPNv2nQQ6u7Iu1yYKFZiBK
	PhTm8DtFSQEu2Fl8qWktRZS3DJPOeZRuwi/yXnJz791cGz6RQoik+Rbzu/OE7Js+AM2csVIWTTP
	fMRfchmlGcXEW8i9w1YZycMLm9Nh3CeOUUFWDHIx9ZQjXmB7Wq7fmNv/TkosR+Ry8GXDJg1yA0f
	r9fWsO3vMKvzDv6dWB1wu3r71439DG1sLBsDbCFPeXA+V3vwmsNFDl/dcbYMz6bO7CmUyd0x+h3
	IWwTbAcu2T8avGH0kw3scDX7Ww==
X-Received: by 2002:a17:90b:350c:b0:377:36af:c996 with SMTP id
 98e67ed59e1d1-37c947363e6mr4256111a91.21.1781704892396; Wed, 17 Jun 2026
 07:01:32 -0700 (PDT)
MIME-Version: 1.0
References: <20260614-zram-swap-ops-block-register-v1-0-6c1a6639c222@gmail.com>
 <20260616123646.GB21024@lst.de> <CAJxJ_jhK+zkpjhs3YsQ9RoasKYh+E0NweQci0sPAEY1ne5LmBA@mail.gmail.com>
 <20260617061743.GA19844@lst.de>
In-Reply-To: <20260617061743.GA19844@lst.de>
From: Jianyue Wu <wujianyue000@gmail.com>
Date: Wed, 17 Jun 2026 22:01:19 +0800
X-Gm-Features: AVVi8CcmbYlKs19G5r-C0VfRk8c0vOg--A7ctAfStsGLM_YhFG6Fmldj3URh3So
Message-ID: <CAJxJ_jiBFUwqZwbE1XQg4oKM0XDrBzZeScvJ0PAUqusG0CObvw@mail.gmail.com>
Subject: Re: [PATCH 0/3] mm/zram: route block swap I/O through swap_ops
To: Christoph Hellwig <hch@lst.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Youngjun Park <youngjun.park@lge.com>, Minchan Kim <minchan@kernel.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Jens Axboe <axboe@kernel.dk>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7834BA0018
X-Stat-Signature: mmhotjy8jndrf57igskbuaahkk4wcaog
X-HE-Tag: 1781704895-324243
X-HE-Meta: U2FsdGVkX1+K2OXR/8dr/+hYlbCrmsAmZPZuPw7xZDVMWgHVIFwA5kWGcwCEbtT6SzeO+pARzLxoRNj8Ne9l11gTdXlnittTy3YsBjemDjhC37DWsgYgNkuiWf82iRKpSkO/fRiYfDSJuJtBaewu21xcoUxS72bjB60rnzof/xEN1VNtVrXkj0ZXUYf59CjnjzmKEjSV3+MKPvcLERJD+OYM6tmSmie7y7MMedZz0tZMbALHxNJTLuPDz1nOHUPlSgKwXQSHlU2WfQUaSxzA6YdYlUXaGV2pZCrKTXg0ZmcShbEZh1C7Dt4aE81TMUZ3c8WJBK5JALjsmZdOPqcwE5Ux2EaVwQlmcyzxp6c5hW5HoMUPT0sdcZNuBjVR01k78uJuvCwD4XdvyC0mwGfuENseTFx5bAsde0z6ww/4QTNdOuNV8H+QnAiX87rDpS9+PxeanJDt9U9UCxERTluPcXd4+r1PRmUgNQkwbY1FpTshFwt9ueASRX3adU9oq70xYzBBk+V+E1c4qlePIDwUE5eKjmdSerLu5ZO6xUgDQQ660t9zqMb6fVqsKKCTYLy3O+Frj8ar/7FEnvvOu0mI94ywj9gqcuaCNUsJNgALh3xA7bEDWpPNoTTE6/9tW0ax1HcSo83jCoeQ4P839FarekYVEieXwEZVrUceHj2ferCf1TOdDJrLBkp5A4Vc+szwMqYwQ279MeU646JF+0rwG1bG/9n2q6ryqrOCfCUgi4hUPvjoVsCLUpKjB4yDwPy0xehFK0kTBQ8YAIWrLExcdADz+H0seqUVKz+1fgVx/Ct1UPkqfyqdpIN2QTDtUFe88MyHwvSgdj37/oufSEyMwyMRGrDsfysgd6D4fVZVJ3PZIkCnHH3/vWW6IJS/9QBtWtGsae3QcHvyPLnk/dcKq/vdGzxVzoJcg48e3LIxI1RChSoFBzx6ch5Xf269o4yLXvfbmZTVeY3LOerzoj9
 0ogh4dND
 zgN/4aw/My3n6TtH8McNQqJ+fB51xkKNyyT+45cZh9MlPKydsckEfbYzqkE868NbcuS8evtqYEAMRN8KT9iqXWau3eIgR5RvQzpk1lKpjput7g5YvGMdpjmOXhcsDL2rCSIGr3cxtR7mu0IN00Z1zcSpKXFmau7xBRRmtGG3GyHRvUqfg8aWRHuPmQ758aLY8MEiQ1bLZ21MWD2t5Qu4H7s4L2A60cvFP/j0Sy6yHbNQ80LFj/Y9IKowLcPs1Fl4zvpQDlgt3W0zoe67tdw2mm7iq1DOyoqn4BvVdVVCWQGVRWEFmo+rACp7q/Dc2/InUvl5sMGDzovaKMH9bMMmz2/1JaP99QmhgXcKjL1mMe+e5JufTnJ5u+pNFlvdicUjyZAeeyDiqFVvMkR4yTPl1vyiWYk43jiYi8P0VLp/kKUs3Oeo2K19vxNbNJjlI3kOPA6aBRyVhGjvJqCKT28BDr3pJu/0MlHxExKmQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 17, 2026 at 2:17=E2=80=AFPM Christoph Hellwig <hch@lst.de> wrot=
e:
>
> On Wed, Jun 17, 2026 at 11:38:02AM +0800, Jianyue Wu wrote:
> > Before I rework or drop the RFC, could you outline how you see that
> > core-side model working? In particular:
> >   - How should a compressed backend like zram or future block device
> >     plug into swap_iocb / swap_ops?
>
> I don't think that is the right layer.  The virtual swap layer that is
> currently in the process of being upstreamed is the right level, and
> the actual swap devices or swap files are just a dumb backend for what
> they higher level code does.
>
> >   - What role do you expect zram to keep while the legacy block interfa=
ce
> >     remains: current block swap only, or something else?
>
> For now we'll need to keep it working as-is.  It is heavily used in
> android and potentially elsewhere.  Once we have zswap fully working
> in the virtual swap layer world it might make sense to say never
> compress again in zram when REQ_SWAP is set (or maybe a new
> REQ_COPRESSED) so that we can use the core compression code without
> breaking existing setups.
>
Hello Christoph,

Thanks for the clarification.

I understand the goal is to have more common code in the core layer,
with dumb backends. On the swap path, once core has already compressed
the data, zram would only store it and not compress again, while
non-swap use of zram stays as-is.

Thanks,
Jianyue

