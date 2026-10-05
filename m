Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED61DCA5FCE
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 09:31:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4D196B0092; Mon,  5 Oct 2026 05:31:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFE426B0093; Mon,  5 Oct 2026 05:31:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C139F6B0095; Mon,  5 Oct 2026 05:31:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9D0E36B0092
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 05:31:26 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1CE5BA597A
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 09:31:26 +0000 (UTC)
X-FDA: 85288054572.30.5F1AED5
Received: from gwu.lbox.cz (gwu.lbox.cz [62.245.111.132])
	by imf02.hostedemail.com (Postfix) with ESMTP id 90D278000E
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 09:31:23 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linuxbox.cz header.s=default header.b=4sE8ky3G;
	spf=pass (imf02.hostedemail.com: domain of nikola.ciprich@linuxbox.cz designates 62.245.111.132 as permitted sender) smtp.mailfrom=nikola.ciprich@linuxbox.cz;
	dmarc=pass (policy=none) header.from=linuxbox.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791192684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BBrWUUXSCL9gFn2uxP6KDGd2JEbEkHet4WqBH6N7+cY=;
	b=ikQ02NyYcmnVLpvDgckYyx7kntiJud+EEzXah1lCQbP21PIWnHDscdjxSufwWK3eI2t4Yo
	hHo/8P3kJCqXejLdrCZodSyugcA0BvM/O1h80DFdiZG4PgGXReykYuY6cml9Bs11fBUC5n
	qDt5BKR1CLtSyGWttrA4W7YEfLCUG9o=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linuxbox.cz header.s=default header.b=4sE8ky3G;
	spf=pass (imf02.hostedemail.com: domain of nikola.ciprich@linuxbox.cz designates 62.245.111.132 as permitted sender) smtp.mailfrom=nikola.ciprich@linuxbox.cz;
	dmarc=pass (policy=none) header.from=linuxbox.cz
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791192684;
	b=ILGAeT692vGuoajq//otja4f4E5eJcil/e5UMkBx/l63EdmE6p2ptAXzCHUbLKuIOapMZZ
	CCADm1HcJq1ZCygbTcgKKaJQko4DGjHCWrpkVAoaAVzvK9owS4E1aAhymCIVVYPrHAsVW9
	bX5Q3GiYi28pzjHn2Yqg5gZx9imj4v4=
Received: from linuxbox.linuxbox.cz (linuxbox.linuxbox.cz [10.76.66.10])
	by gwu.lbox.cz (Sendmail) with ESMTPS id 6959VFPh4139732
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Mon, 5 Oct 2026 11:31:15 +0200
DKIM-Filter: OpenDKIM Filter v2.11.0 gwu.lbox.cz 6959VFPh4139732
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxbox.cz;
	s=default; t=1791192676;
	bh=BBrWUUXSCL9gFn2uxP6KDGd2JEbEkHet4WqBH6N7+cY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=4sE8ky3GOzfgE9kpii4L2Xy7yl3Zikrlo4fNKWxq5s7V9ucCj++gMHfHbqn9VdBv1
	 YbPtF0QGA9G7noXmv2CTHzdHcotaZqpi6HI7eoeFz0PPOuGLkvQXQyjeePbeoQGqrS
	 6mFKXe/j7ZxL98FmttFEoLqvRLedCZD2HqY6l1q0=
Received: from pcnci.linuxbox.cz (pcnci.linuxbox.cz [10.76.3.14])
	by linuxbox.linuxbox.cz (Sendmail) with ESMTPS id 6959VElD045326
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Mon, 5 Oct 2026 11:31:15 +0200
Received: from pcnci.linuxbox.cz (localhost [127.0.0.1])
	by pcnci.linuxbox.cz (8.18.1/8.15.2) with ESMTPS id 6959VDSw2367544
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 5 Oct 2026 11:31:14 +0200
Date: Mon, 5 Oct 2026 11:31:13 +0200
From: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
To: Rik van Riel <riel@surriel.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
        Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Subject: Re: hunting memory corruption bug in 6.18.x
Message-ID: <asNuYVRrhwOvdWyu@pcnci.linuxbox.cz>
References: <arY1Wq6R9OY20ans@pcnci.linuxbox.cz>
 <e31bb97e34de9e37ef27f02ff98f63fb17fc57a0.camel@surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e31bb97e34de9e37ef27f02ff98f63fb17fc57a0.camel@surriel.com>
X-Scanned-By: MIMEDefang 3.7.1 on 10.76.66.3
X-Scanned-By: MIMEDefang v3.7.1/SpamAssassin v4.000002 on lbxovapx9 (nik)
X-Scanned-By: MIMEDefang 2.86 on 10.76.66.10
X-Antivirus: on lbxovapx9 by Antivirus 
X-Milter-Copy-Status: O
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 90D278000E
X-Rspam-User: 
X-Stat-Signature: swdnokabncfko8u64hndecap4fjyu1oe
X-HE-Tag: 1791192683-287676
X-HE-Meta: U2FsdGVkX19BnFuNVjY1j5LvVcbRzvkmjPxvM7JWaF3W7hYekNaC9fNO0yC38Dj0zhBiPaR9wPOGHnHQcQgs+8GY5KrDYzhCjKcgYvmcUHMkA2dVL91WnRLZiHzupoXqsOTq9Co5iKs0Kq33uEiM8jjCuj39iyShnt2sG5eblLZYSK0VY0FmHHzJEIG+TJvOBiqVRTgpwZFejN4TzpRisieR5zApwnogabTJJETGrh8q2JxHZIMMVDiNXynHlYsWATTY8ham7pWJRWuILkvZwJpiwYpTUak4s/yPLalmLvp/v+MZ1XvQqc9Xnp1jJA71WqQeE9YMzNuNvq+RQA7MT7LhAxQaemqin1MoyzQWgBijp9qynpb/ijfb6ZE6qgkGg4Xyd7f8GHQZmR3v0zfhJ7m+g9388eBl2CfQzjTWwvywmN5i9Hds0x7g4UyT+BJTjOB2a7zem7f7YxsMGkcDtpOTOBerd7Ns+5NscQx6HZiNWCWLtVjaZCLpyglQofWXeSaBpr3c+EG1+8Lf68VAkAsB2hyzsny7qxb9VTcIqLIC52IcP96diVp4SmD8aFH90f0EHvBIcb7QMrh/9xRiwvYbTfyDIm8d0tC8q2dYJd0CD6LuYKWiW9cLi/31aAZILAAyQLFixM+2n34QD6SNWIAvWNrJa5xypOtlKxvV8stoCEsKjIGvDEHh7rCHLKc5QJd/nE/CuyrMfRM7sHPspOFTp4sOTNAhPfQrLtdVNoZxVD2Vq7PJyrWVPp9ld92cF2RqY/J93oRw/EvMEvdoX7jt4dkZDWF8mbk1btk4Psq04xz9CQz8+Uj8cJlesBnsIeH2qI+bEv0nfRYqs7YTJqnbpj3gRVq742f/LzHqKpAIFhU45gu+AZQh3Lyzcc7zGWs4l9N6s1Aww0C0NlHqGDh060eadcXZw/SNazQf5ow/8WkOIJhdnpr8y5bJ7qHfcsMcLp4Op2EXUqKmlYZ
 S7DTz+qb
 sCe8s/YHELKZPRKRB/y+1j+KB3Xi8B/WRZX0VB+mBjO3Nz62B4p2vq64q0LaQvOP0u28cKmIsi7ex/HAoSKiAj5/X64ZQ2SyMesiWkpN1MUFww4/nfr3Y0fzKrux9rTEf9CL4Y9dQgRN1PouPSB7C9LCCsLIEmgGf5YRyLLAK/P6Ea2kLBKOnx5kaWrvXQQrBpNVojQaBHL/gR6jHmnSE79l//KsjfdSE3RtYd936oxyIJsTAHg3jSeh1P0eAmw/hD5ugkoGRxXmczyPQBbdKXH/W368pZGY1Vj4KGJC6BAtA9px5AjKL9Vb7otkeMwau2/0asXXAntF2HjO+tzm1grZBLd9h43LXRo2q
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> THP has a recent patch that may be relevant:
> 
> https://lore.kernel.org/all/20260903031608.1194238-1-vernon2gm@gmail.com/

this one got to 6.18.53 which also crashed for us (this was the last crash,
from which I have complete vmcore), so we're most probably hunting another
bug.
> 
> > As a safety measure, we've disabled THP and NUMA balancing on all
> > hosts.
> 
> Does the issue still happen with THP and NUMA balancing disabled?
we've disabled numa balancing on all suspected machines, but there was
some confusion with diabling THP, so I don't want to bring some confusion
here.. let's rather assume it was NOT disabled.

-- 
Ing. Nikola CIPRICH
technický ředitel

+420 591 166 214
+420 777 093 799
nikola.ciprich@linuxbox.cz

www.linuxbox.cz

