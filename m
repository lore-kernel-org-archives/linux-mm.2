Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75CD1F3D319
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 15:56:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98C2A6B0005; Thu,  5 Mar 2026 10:56:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 960BA6B0088; Thu,  5 Mar 2026 10:56:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 863336B0089; Thu,  5 Mar 2026 10:56:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 73E0B6B0005
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 10:56:14 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1E4E91B6E0B
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 15:56:14 +0000 (UTC)
X-FDA: 84512461068.24.DC8E842
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1622B180015
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 15:56:11 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=j804D6EF;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772726172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CL67FwLgJYo3bAjpZv3JUFOlo9GyDQqh66JIS6cOafI=;
	b=2qRERy/NCagcmMR22dIDegkVk5WXtBp6hFNFNQs4PFxaqaVMN5skcN4bD898ahkrAzV5Ch
	TyhoyqP4217Pw0kDMYDDIA8vooo4TFVVpTuZwX1IjcEiHLdNVCENNimtwjVuQ9Z450d1On
	606xmAoBPE0Gr6fMq0lsMzvbtwxnUkA=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=j804D6EF;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772726172; a=rsa-sha256;
	cv=pass;
	b=o9RrklzpVjm2msmMwYWQYyWGzZSFAB/cosEdhI85vfBItlHPIj+0fkmZ1MCYXvMuhy6EPr
	Vl0Sc5xivoAmheU6gVucv73Ht3Tz1/mk60tOUfsCAEJMPFQpdAxyYmpoG6KdAsD2/oaWiy
	AZiGL1VQucbiyMCPU0voKFKCf/dO0sU=
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-5069a785ed2so503001cf.1
        for <linux-mm@kvack.org>; Thu, 05 Mar 2026 07:56:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772726171; cv=none;
        d=google.com; s=arc-20240605;
        b=LbICzq7kqKS+36FCgkMYOmK8QhGI7VmrAv+nBwFQDEHZ6OFvzCkEkn8V0AYQPR4+FQ
         tbwmUIr2oG1/LsHUIJi400u+KqsPJ0s6HtXX0TnpAAANVTaRqeVBQ3Zfm6wbYw05RJgB
         9I20HI8uiiQrnHag1Hqbyr1ibRhJnkv8a0rqIw215qCJTpWbeJDyHG2TJORATHKT+mSZ
         HAU9F8XBij926/MXpKgBHGSwIMuEYfw1cADsZ2jy0GLs5hYKYC1ASPAdjA1f9P+37dT1
         rDZvLP0rG/1iqrnQ2MyOUVx/ezrxLx8NrhtpiwTKPTxsCrkcYvI+nk7xcbldKBdoCkC5
         zZKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=CL67FwLgJYo3bAjpZv3JUFOlo9GyDQqh66JIS6cOafI=;
        fh=pmuJ/ZyxZ5uL8WBSKKVYwBOMp0bvAaUTmCo4ZNRMaUE=;
        b=dAOPbLBW+I9ui0T4/MGoMf1/cvsXcqG/q97yfKasBjQclAWGTuUswoP4a80xWGb6jc
         mw763ZDUVLGw5U96EccOHw30Iw5XmpvojBVRLSECEUMqcI8fkOOL8Iv78LPBJhqdB5j0
         sxXS0oajiCjK0cLhZhJdoaU0yJ/hAQoyB7JkV+QMgKp9tL/jIhPQVtzOxugsXoDyYd4C
         DPKwjg/W3ipZS3ZzCdQ64l3I6pd5+Nv+2OWtS11SCfl05yynAQ/pAnJtucSbLs4EYzcb
         WkZ5TxNt1xtd6DoA0vPNoFwc1n+woN2Wrh0wc+q5xuEGGM++Pxq3+Cqr5mecchOvqEF3
         fR0w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772726171; x=1773330971; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CL67FwLgJYo3bAjpZv3JUFOlo9GyDQqh66JIS6cOafI=;
        b=j804D6EF5uNydoo1zu44e7Z+2IHsgcWnrUFopZxU/nhbsDXdx0ZbW9ilLEvcfVsG+Z
         uGvdJoMrqVjCOuW7df9m/0vcxDrHfPjLJkTquqxHbnf0JkMMsovB1VDet+CHZeb+Lk5B
         AdjuR6QFqBzcYpTOHgQW+CFouGBd3GIigSjUj99KCnapXcWpaW5alMdv3JWaiXlc3Xjq
         YWVJt9mHUxwB9l6fe+AZe/vGaJUZ5+H0Cf7/hrJxHsFWSXnbjWVYUELlAWeStabA3BNC
         wvfCJ2n2TIm1CrsRThUHAC/XBmmnTUOzblGkxGhTGplC6liuzFKCErzZg5z1Z/3d3F9K
         8wsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772726171; x=1773330971;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CL67FwLgJYo3bAjpZv3JUFOlo9GyDQqh66JIS6cOafI=;
        b=kRbdA5PKK0pElyoWwvg23w0a4Utq9VrQsuQLomKYb+OneQFS4iFzuPz7G+GXWLhTvV
         aoYqtEiCKhngrjc9doCwu5guai2irx4omxyVNgcOPjEVzwd2Za4Y0vl91E7URWFwkW0v
         Sujz70N8K8BA0WQuc1FghqVHlizxWVrKjgDglVGUoDpCiyr8ngltOVVsOMX8uD5KvLdc
         cSatw+Nzlly7UlUd+Q0YJG+Pj/AyaBhjKQUCcEWjAZfs9s+a51NQlibSdRV+zDeRdx3m
         h88feA3BFFRNALZMN656QEifNPrzUFppnyPDCzlLsaVjIaPvoFIewemlKxNgVsZMdihO
         FFpQ==
X-Forwarded-Encrypted: i=1; AJvYcCUHnktnhmxWhOv+8hfwsNDKauKW942uOLKcgxInN1iRy+79RvVhOZvSZlwB6uXErHIXwBmSCWaSYA==@kvack.org
X-Gm-Message-State: AOJu0YylaJbEWAYoZeq2RZX1Aholm51LywOlFmvhhHLipZkXT4e4xoPA
	GldJvJ4PcG0xK81hjS9Fci21VcOqc23qSwCgWGj8+6C3pK4Jm+dIFOljbUtDkW3NTX5agAjAwFL
	Zeto2slh0vRVNPNOR29y2u+vQs0iOQe750hdUTafm
X-Gm-Gg: ATEYQzyWjZQ65jqqEWsANP3TG1w9mitOG41z7YcE5jMNUoKQncuvBaCr0V6tlbC1c0/
	5xYT+n3g7qfzv9fOe87vfH7Azv+ESyyy3UpYjgbXgDUPqqAH9txZn2x1eqz6c61dVE46JBDH+RN
	edBC585CN2xtJpxJyX3spVilzhHDNmzU8S+ysULSVa/CwpEPEILASRtrN8T5w+moQeWt01vMHUd
	wJ/2hfLnZRvDb0645iAEdiCK3/5E4l/bYPNjbaxBU5MM4O35+JCYs3kCpI8Ap1JYEPEG5YZwzOI
	iJrT1S83McRHSw6n7jfkl9mEP95W8Lac+35poA==
X-Received: by 2002:a05:622a:508:b0:506:a1b1:422d with SMTP id
 d75a77b69052e-508e5e2b30dmr8659941cf.14.1772726170353; Thu, 05 Mar 2026
 07:56:10 -0800 (PST)
MIME-Version: 1.0
References: <20260226070609.3072570-1-surenb@google.com> <20260226070609.3072570-3-surenb@google.com>
 <74bffc7a-2b8c-40ae-ab02-cd0ced082e18@lucifer.local> <CAJuCfpHBfhKFeWAtQo4r-ofVtO=5MvG+OToEgc2DEY+cuZDSGw@mail.gmail.com>
 <aadeHiMqhHF0EQkt@casper.infradead.org> <CAJuCfpFB1ON8=rkqu3MkrbD2mVBeHLK4122nm9RH31fH3hT2Hw@mail.gmail.com>
 <aael1XWaOJN134la@casper.infradead.org> <76aff8f9-1c08-449a-a034-f3b93440d1a8@lucifer.local>
 <aaiBX5Mm36Kg0wq1@casper.infradead.org>
In-Reply-To: <aaiBX5Mm36Kg0wq1@casper.infradead.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 5 Mar 2026 07:55:59 -0800
X-Gm-Features: AaiRm53SpNsDBZ1BZJy_J-KSVGaLXeUaHRvKuxEZ4rqtXprCC3pHIR_HRRDvcVY
Message-ID: <CAJuCfpF1=DP4Whe9YkuMcqkE7CXnDWMDbvBAg9pAsut0YSeKEA@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] mm: replace vma_start_write() with vma_start_write_killable()
To: Matthew Wilcox <willy@infradead.org>
Cc: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	akpm@linux-foundation.org, david@kernel.org, ziy@nvidia.com, 
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, 
	byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, 
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	lance.yang@linux.dev, vbabka@suse.cz, jannh@google.com, rppt@kernel.org, 
	mhocko@suse.com, pfalcato@suse.de, kees@kernel.org, maddy@linux.ibm.com, 
	npiggin@gmail.com, mpe@ellerman.id.au, chleroy@kernel.org, 
	borntraeger@linux.ibm.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com, 
	hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com, 
	svens@linux.ibm.com, gerald.schaefer@linux.ibm.com, linux-mm@kvack.org, 
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1622B180015
X-Stat-Signature: 66hmqzx33amseou48dbgmjerrijd59r3
X-Rspam-User: 
X-HE-Tag: 1772726171-739145
X-HE-Meta: U2FsdGVkX1+AJKMmQ4HXnpPL35uRWDaYUT4Zi4zb4eJENOx9V5eX/PlLZ3s/R36XCv/EO5fy5wGqn59zXFIytd+5YxsxhMDocwIXgr9wwZaNeq0TtoQFOs8cUjgweMXXL/g2tuL04F/Wwe96iCWnhCSlWViJQp2o0BKtHJnPqQc6QAVsu/MbGPaogICIWHoOrZ6to6hPctoG5hNWRJ2j128h1wWzjNk+TSQK5GwciPSbjC2wQY3ms/wMMi36xZaKPQXfmtgwlnxsm4d3oYTWBnvLniW9w1nT4UKmMDajRx9KsvIM3PDoKVuE3mRsfu5oO9OUwgCbg+gGLB68GnQ6lbmH7Iiuf75/dRz0odtag0Aqe2NYiobLLa4X2wQAnEqqOureX47XDKqfhbcZ6WEl8N3uxqXIVmqWjBnRUkFEAw3gHB5U4f/vcQWFv9U9a2K9AIzeq7Zct1zWamNJV5KUHxYMTHDWu83HsEAk8csVCMp8AITCwmNUA4aEvMlCDpEjmZ6lhNiIOgBgi9C1AGkggXM6PeaIyA27PTNRcDKX+Y6OcP26VGgVd9bb9GWJM1JtkanQtj1aEDT/9Ej8RR1OJyMb0rA7otL8pbeUdqwucX7eatJIM3iOpabwC0VqcldXG/7PqtClMaYXQLnmF/8Pl7sDwlM3tFkw8fpEH7zVLZsmM1WPATFpUpIOR3HkgiX/ESs92VDL7zui0rq3pHIYX7iYdehMPsNL6BJU4Z0y3xjIBnuqd5AU+K93wgOYuw/4KCq/Uvs8NHl6r3h1NuAXW4ypDxINL/9tj70e+3V0IywIMbLT3QIEVVg1iYYpHQpDOhD+wTRwJbXObaDnbRgWj+JdxFyv++rWdSlQos7gVeuZj8rc/uzX/GLqDFeU1hcFuvZAut2dUjzTOobSsLzyhUZlGUPxT7lfJt9HLO5ZMYOwzuJiw9+lGyYts0PfJGN8kjHhScP5BHUaG9rUAEQ
 R4R3kViB
 +BWN5+F7YLpr3pcMziBmj8HtsCHQ9QTWYgz2T7R/06Mrwb4uCPrWNponJD5qUotrAwddXXf9sUCUtELwI2kiiSNwDmjknlKl1pSVH2boUjaWK/yWvlTAhqmDxbAfT+DnQPepD5PAKg8msFQCWHwUIWKfQUe0MTivl8z9fYqYEokv2KIaPvmwxX9quTQToXBaYDhTfvrNEegN0WTnKQhldu75PU8R5iKKE4vS1ZKRoDGIWq/pstaGKKEiW4CWHi8dDUwAq47+/vj6wbblKe4dZvvw9wPPgzKnMqgTIrfnJYE9z4wt/nTgmSNV4qUpb2HvJkh4drnnKp6COVlWncC7AJEVxvltSYZ8WsEZJtKZO9fDxVfz3LHTgGjHaXlEpp3mDtTtYspa9Il9AHB43pOXfs9ZUJSkDlPzYUn0Z
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 4, 2026 at 11:00=E2=80=AFAM Matthew Wilcox <willy@infradead.org=
> wrote:
>
> On Wed, Mar 04, 2026 at 04:53:27PM +0000, Lorenzo Stoakes (Oracle) wrote:
> > On Wed, Mar 04, 2026 at 03:24:05AM +0000, Matthew Wilcox wrote:
> > > We could literally return any error code -- it never makes it to
> > > userspace.  I forget where it is, but if you follow the syscall
> > > return to user path, a dying task never makes it to running a single
> > > instruction.
> >
> > Thanks for that Matthew, that makes life easier then.
> >
> > We can probably replace some of the more horrid if (err =3D=3D -EINTR) =
stuff with
> > fatal_signal_pending(current) to be clearer as a result.
>
> Umm.  Be careful?  fatal_signal_pending() may become true at a later
> point, so you may have acquired the lock _and_ fatal_signal_pending()
> can be true.  I'd need to audit a patch to be sure that it's a
> reasonable replacement.

Good point. I'll evaluate each case for this potential.
Thanks!

