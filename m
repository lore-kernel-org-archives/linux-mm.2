Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D739CD98CC
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 11:37:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD6BC6B00A0; Thu, 11 Jun 2026 07:37:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CADF96B00A1; Thu, 11 Jun 2026 07:37:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC36D6B00A2; Thu, 11 Jun 2026 07:37:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AB6606B00A0
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 07:37:10 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6ADB2405F5
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 11:37:10 +0000 (UTC)
X-FDA: 84867430620.06.8BA9BDF
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf17.hostedemail.com (Postfix) with ESMTP id 294FE4000D
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 11:37:07 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=szeredi.hu header.s=google header.b="Mbdsb/s3";
	dmarc=pass (policy=quarantine) header.from=szeredi.hu;
	spf=pass (imf17.hostedemail.com: domain of miklos@szeredi.hu designates 209.85.160.173 as permitted sender) smtp.mailfrom=miklos@szeredi.hu;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781177828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Krbn+MYg+M809YBLBqA3HPhCu/oACb+iPAXWhxNcpGc=;
	b=hiToSq7DbzGk+HNkbtmWqrJUg8eiOP3XCeaBe/zQdFrmyuanUZ9tYN8Qzvh2/3YpVx4Oa0
	yO0coq9t+AgNut6dhE5M2CxPWKT6+DY+XLoFMEVhs9e6Oo/gwUUZkjevQFBPg5KgY9STNN
	fQ0ghkQ/0esdtvWt1s7Pt5n1XHRFtXk=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=szeredi.hu header.s=google header.b="Mbdsb/s3";
	dmarc=pass (policy=quarantine) header.from=szeredi.hu;
	spf=pass (imf17.hostedemail.com: domain of miklos@szeredi.hu designates 209.85.160.173 as permitted sender) smtp.mailfrom=miklos@szeredi.hu;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781177828;
	b=Eg/UuNldvM/EefS3ac/ITGDONiAgjnBuxO2XEPX+kmGJ6pwTyYz2/NoOJOLrThefuljlun
	6a9lcvcQVmsPfmhbSdmF5PVCNg0oQ8u3IIUFFTLlfRmDN4gZfkE3ZX7xqtmwNJYFozl7AP
	a6gLpbMxEeAllYRpylel3bQL4tFAId0=
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-51780bbc560so7565491cf.0
        for <linux-mm@kvack.org>; Thu, 11 Jun 2026 04:37:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781177827; cv=none;
        d=google.com; s=arc-20240605;
        b=QFER/Fe9JQQI6PZcGteOsebjis9S2vPe8EH5ybLuXmJEJbja0pHtGSEoZgsDibDuQc
         0izYqqo3uf/VlGRCqlMCl2X8D+6Hlu7Aodd6HsRpG1UKZJY69YyTX1I7clhXNelQ/4BF
         Ic6aDqj/sbMqrvdMVDwKcj+LUb+WtBFwKvEc1JTUlsiTxAz3pSpZ36/cOygTN1b4+KqC
         nMUuxR/p88f6nUUg0ST2gJAgQH2c6Aql/fDr6rTT/77hx70GI1d9Zv5nPdhpA0RdSkki
         NdWIOZtRGQhePxPwLU90Ezoql3WwsWUxJmF2Ynqie9pGsNcyRyVuxIzwBzbGMCrPKW0v
         I87g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=Krbn+MYg+M809YBLBqA3HPhCu/oACb+iPAXWhxNcpGc=;
        fh=Hsbp9RYDxXKznV5kkZz/oa/iQhKoQlFKrInbnuVLG9s=;
        b=EcxkTTFmAyfWXoTKJEzLeqDqYxvv9sjGtmD/4lSEhCOxBMey8/QGSpvZ6ttXCcRoNG
         B+oiNCM3wnM/BvOAHLwRQ/4mgcBkLHb3vW5IDiHPtauELgbGfSHNyifSwWS+6HQNgfCZ
         FrL6rVCXcW8WpFU75Vr76laPe9qNRpAcuOA7q4BYukxxS5aOkXL3mXbYeJ4a948M+SUz
         mLcwIsV9a+fW3W2CrxqhA8s9GuvQDg78b3611mUH7nwbug41YUyfIJ60OunA4v/pR1kx
         nAJibINYL+KHrwZaPnr9yJngMH5w4noQKLRF7aCdH+sa0qFN0K+CQ+hXoci8VMcSpo7a
         fgnA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1781177827; x=1781782627; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Krbn+MYg+M809YBLBqA3HPhCu/oACb+iPAXWhxNcpGc=;
        b=Mbdsb/s3lWjzYKqGXXYTyBztjR4bl3xGvCWWuC7NBpN/nkHq2PvO9bBot5nGOkrJeh
         LtXVPo05NqcN41XdC7FP2rz8b4xDhy4UcybFozk3TgtfTjbiSQ9hZFTJ62yYLAcRGcIc
         n38v/1k7c1kIrYy52GFTD4H6Xe/qMK1wQ0OwU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781177827; x=1781782627;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Krbn+MYg+M809YBLBqA3HPhCu/oACb+iPAXWhxNcpGc=;
        b=IA5EPuoIYOjolb6wEh2HOeJuH2N7n3p8ZTL9Yf9nUUHhyMuwCqk5XD7tKrnq3Ao3bh
         98t7QeIQbBBwAFYUPcUta/soJYqtRLUnAQhZG/hUGsoSikZ/1fmH6r6YrMuyQXP66BbH
         EgU5DlNFEBC1btP50vm0Ou23clrtrdYcDzT3NiRBFOoh9esEkoGxuX+X4YO9iFmQpWs0
         wgpOaLCSboqgJvheZfLaprjpsevOYPqXTLKD+P2/AqP1hWsxNik07qRQV/AIa7FkcWz/
         HGDZCpBmfyZ3DUYdVk1rlABghMDlscx/AJdfMyDNubY+7GGGXuRvw/9g+0DPhbIxyUcC
         8GPw==
X-Forwarded-Encrypted: i=1; AFNElJ82hNSewmMXX5+5W7M0hSqiLlxcWP8hZFfLxcOzKtv43nVEeiHGD9ErFcJNIbZ6EXq/AdzNFva1Vg==@kvack.org
X-Gm-Message-State: AOJu0YwXr0h+zLT5/64Xky1zSXwy138voR2Q2hPP2AV2RrpvWM17DNGf
	FV3dTkaWiPjQZyXiD7n5oyy0TJDV5REl/LkydBv9sXsfTUVZt71m+MafFBw+xXgDK10Rj6SO19v
	laPyDJguRg33T8N71ZrpUTgM8e9jRaMMCicE6Fvkg8gGmGRNv1I03VP8zNA==
X-Gm-Gg: Acq92OFgowaMJ1fyg8ZK5N3nRdDoYXvFjTBMhdBBlU0Av7bTTscqD7j7PHu60i02RUv
	9SfGGd9tOcZu85efHGxL25F1KGr8bweGkhvEyaI3Fuh35YGPl0a4lVHiKYlMIU3hkSbLyg+q4cr
	Yk+M5HNhBAx2qi0CijE2yWskZvGU7Wlv36uEnJClSyxoAywLvCIcp8Fw7rfa24FhpDHF6+EyXR7
	EuT1Z43KmQrr3hFd2Ujyd807xuh9qfEeVOnxKeSErj4b+Z7CBsN2DN5Cv7oMF+rqWRpTUJxaMBE
	U8IK2JmqOTetHM/N9Qg3++7FIZDiSWvTFghgn9B6GjB2FnC5hv60Lv2owG4LCQ==
X-Received: by 2002:a05:622a:2c3:b0:50e:600a:638c with SMTP id
 d75a77b69052e-517ef5e438bmr24070671cf.17.1781177827196; Thu, 11 Jun 2026
 04:37:07 -0700 (PDT)
MIME-Version: 1.0
References: <898a4e10-6193-4671-b3b1-7c7bc562a671@fmap.me> <CAOQ4uxjoS-PvnZ2poh0bx0C6ocTYwuEpfV0q5md15SjS620OMg@mail.gmail.com>
 <CAJfpegvxF7F+XKFKokSH4eOgCA0V2RNm6B54MS9nr9wG=U66OA@mail.gmail.com>
 <59ab54f6-680e-456e-91f4-0a26889844ef@fmap.me> <aeFuarTL7xBbut0F@casper.infradead.org>
 <CAJfpegtAeyMRENdneJkJrMKu8Uwnyk9LYBThjvTrFjHmPr6O_g@mail.gmail.com> <9fe5ff50-4c1c-49ee-a8c2-4cacc3c6781d@fmap.me>
In-Reply-To: <9fe5ff50-4c1c-49ee-a8c2-4cacc3c6781d@fmap.me>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 11 Jun 2026 13:36:56 +0200
X-Gm-Features: AVVi8CeK6Z2zBhavJJXwn1vbtJS7ePzzglnt_f4GGpdHii0ALfHsK0WKEmVT6b0
Message-ID: <CAJfpegum=LJTCGqMUfLHehQE19kgdZbE2eXS_002fdpX_sd6jw@mail.gmail.com>
Subject: Re: [fuse-devel] Debugging a stale kernel cache during file growth
To: Nikolay Amiantov <ab@fmap.me>
Cc: Matthew Wilcox <willy@infradead.org>, fuse-devel@lists.sourceforge.net, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, Amir Goldstein <amir73il@gmail.com>, 
	fuse-devel@lists.linux.dev, linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 294FE4000D
X-Stat-Signature: qh79iunqt7bmoa6cd69rrh5rxk5xi4y7
X-Rspam-User: 
X-HE-Tag: 1781177827-989986
X-HE-Meta: U2FsdGVkX1898pc1wFAqqkfJ7Mec6GRHRhNOZPvf/IRAw6zs0E28i3hnRCSGPYdN3HrqIc94vjEiUxMcYRn2KHRqv03fKcPQ7ANLSBSF8XJlzNnHaSeAxlBAOs6wLJkoiMXftAOUPn1C4dLZ2+oDVKzc1BywVX/XXIiQSFk0hPDd0CWmTvgQXXQK0VjoXZwhnucQfSoQ5pmebOCFKQPr6YeF+3AZJ5KITg4rIQ1jV1h705B3pv5HEE48/biewM2LeVCi8Eg2hOp93vZ005yJBuRXyg6+p2G2ZwoT/bVf+0hFp2xoD5TMkw836JRouU53T5NRFLosa3Hw+rOS57rX66B5ehzkfam1aIdEh0chJNzlaczDLBi0KWLGDLgVS6nC8dTgTr7PBL1s501lt46hweoMYLhm4KRmjrer6c9aFUQSXuhe7IL4MLZMZTTmdTWEGDsQCWVHrQo2Ayz7p+jGbcmkj4FzGc/93BrhW2+j1DLj/nkDav9G8wHa4nHT4O9Sh0zyxOVQqnV+N8viiNDBlSfbuYnKC8xPONF0r5HUsQDL2/j0prwqKovRxjWYJr3dbeBxvSDKAz9mgtgaFnaEffpQAQzjz578OJnd9qUf1tLpZ8nux/YYL/+YgEmS4dUu76kOB03uBjxfwq4HjK/8IFglZPIypeiXkkFauNJtphSeo4qYedYGSeXwtrnYo19w0ZlsggfLB0B5DMpqYrJMPqTul+BaTmmVhkTrDfhMhBc7XA4UpKl9EDQMI3BGdUSu1zpVOwNvOmFTdYTO5Ut3Be/676oyzed2URpfNR70U0YrVJ/MN/CMd9cziPHeIOI/yOqJ7QwNTVeYG4izAd0blr6IocKm0Ye1YgQPlodwi+DHuhIfV98+AyQzZcW5zII9fSyVs23rdrNssVpVe1RJQfYlXvO0QHzsrmJ717xdaPb1ZwOJoyPEDeeEIyw7hLp3Vq1b8ODfTcDGKMIhjvR
 FDx8bk2s
 buTQPvtYwx4RmCvrzsDBT8GuigK3jKoMQJE8XcvYFmepjjQLi2JX0NDtrDXG2qEcquKJz3Nw/+Ovt+hwOJ0Js5H8Ij4I2qsR8S2MIIRdEjaI3y2Ld6Vr3sBZWSzcyTC646GUMd6UkeaNHEQHu9FIypNVGm3LY1flozoh+D9iwp2N76vazupKAwQmknW2mIDf928Ab0ANdvxYEo9UG+ghxd0JXiA1lVNQNs7/h495UwpKvirY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 4 May 2026 at 18:49, Nikolay Amiantov <ab@fmap.me> wrote:
>
> Kindly bringing this discussion up.
>
> On 4/17/26 20:48, Miklos Szeredi wrote:
> > Should that code check for a truncated page and retry?
>
> If I understand you correctly, this can be accomplished with a new page
> flag because there's no other way to find out the truncation happened;
> would you say this is the right way forward?
>
> Sadly I didn't have time to try and make a PoC fix yet, but I want to
> try tackle it this weekend; meanwhile, any guidance is appreciated!

Sorry, this got lost in the noise.

I was thinking of something like the below for fixing the invalidation
race (untested, whitespace damaged):

diff --git a/mm/filemap.c b/mm/filemap.c
index 4e636647100c..c9ab0eb35afb 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2856,6 +2856,14 @@ ssize_t filemap_read(struct kiocb *iocb, struct
iov_iter *iter,

                        copied = copy_folio_to_iter(folio, offset, bytes, iter);

+                       /*
+                        * Has the folio been truncated?  In that case we could
+                        * have been copying stale info (including zeroes after
+                        * EOF) for a distributed fs.
+                        */
+                       if (folio->mapping != mapping)
+                               break;
+
                        already_read += copied;
                        iocb->ki_pos += copied;
                        last_pos = iocb->ki_pos;

Thanks,
Miklos

