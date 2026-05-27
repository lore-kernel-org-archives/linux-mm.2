Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 642FECD5BD5
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 14:41:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0C946B0109; Wed, 27 May 2026 10:41:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BDE06B010A; Wed, 27 May 2026 10:41:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F9CA6B010B; Wed, 27 May 2026 10:41:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 832E36B0109
	for <linux-mm@kvack.org>; Wed, 27 May 2026 10:41:42 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3176B1C04CE
	for <linux-mm@kvack.org>; Wed, 27 May 2026 14:41:42 +0000 (UTC)
X-FDA: 84813463644.15.632D91F
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	by imf25.hostedemail.com (Postfix) with ESMTP id 44FA8A0015
	for <linux-mm@kvack.org>; Wed, 27 May 2026 14:41:40 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=azdK1xcy;
	spf=pass (imf25.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.179 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779892900; a=rsa-sha256;
	cv=none;
	b=ev+CVovdAXc5mxIbSpYcqtGLH+D34T6zg2Ws5dw8sWbOaL5psiug3xJqaFn5hYp8SrKG2k
	XeaQs3+lLMFkL5f7htUYJWaJ0EdwL91xAhouHYqiPRdgBD0krudziYhuFkxt4gFxf13ePQ
	7m7FSRMsRDAPlHJs6hmFBEE/gL3uJqI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=azdK1xcy;
	spf=pass (imf25.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.179 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779892900;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CbYyflbi1csVccgC7xokEK3x+MW2cvMKopZtfNHzrQY=;
	b=WIc2sNt4nodUJto6gt0VPQOjHwkMbybwMKjoPa4YmNOyvb16ShWhmpV6xxwvavPUHq4A43
	mCaAkmCITfNE3aMCJYNlyvcPPry8w43dJ6IlzPTFe2mpmj/6kHmyIZui5Dw0HQFECmXhXU
	DIoAJjZWTbw3NftrNpL9vHU36G8nR7s=
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-913cc4d7c71so1282730285a.2
        for <linux-mm@kvack.org>; Wed, 27 May 2026 07:41:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1779892899; x=1780497699; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=CbYyflbi1csVccgC7xokEK3x+MW2cvMKopZtfNHzrQY=;
        b=azdK1xcyCfOKeoFZuc6szn3bNpROnFvRYA7eLkBCXHZVQBp3DOZYJP18lnUVn7Rw4d
         ffJgLJ5LSnPiEsAs/AJsJrlKYrmpVEmtTZ+Ilpi7Tu/32Anb1CNn9Csmi4Qx+cspCkTk
         +jk8j0dLrhLkydP2zf+4R9t6jZizvyrsbGN3MLWLPEtEr8EPMTHTUS76HQ2viqopAp2Z
         +olxhZh6PrCQegDaPQ5PL1Mq0VVnjdvduNRl+QpZU4n1Ouo5mZalxnXbheyp1oGxgDLm
         yNEkBsBEezW4WrDH67BPS8wnjjnwQfEqP8scovjysIqgUXY0AUwsHIaICPUDpKicfn/L
         boYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779892899; x=1780497699;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CbYyflbi1csVccgC7xokEK3x+MW2cvMKopZtfNHzrQY=;
        b=sst4kvvvFxAJliW/IggA5AiZ2j1ziqHh+pLWMyFKwzLebGVlG7oL940je2L0eW0Ehw
         fx28VT99jczAFUEskriCIy3dS/gAE7G0TrYymZgFuQPWPRGqjyXrPJ82NrsQMCkbsvGk
         X8oau8Gs93I4ZEYwpzHHuW1iy3MkVdIYiAVPRMrv5XWaRhpz/NA3sZrzJSpGfJRS+D0q
         IKiTN1VJK+qtJY625SfpWjuCylzuXH5aa8s/S2rbPZnF5Wbmbg1XYYP419BCSetSqnPK
         SbtDTLrVlcM7AzpY+tIUHbdfXPc1r8FPtLcmlLjl4ANg2/tLTW/guV5VmjxCUsqxVqDN
         UPCA==
X-Forwarded-Encrypted: i=1; AFNElJ+ZfJWFpZ3DDd9aCuJHj0kFfcASvBbESI4VY2IjX+Res/OfS1C3iDmuE6GX5CXe1UA4QguDQVq+XQ==@kvack.org
X-Gm-Message-State: AOJu0YxKtOY+/eV0KtSSArEVa1J5+8Rqyw0YmIZK+zYj3nDeFesNJcdv
	gxqlsD2pvCEE+0y81Ebim0RF69C9kYHIADmULhFmmTD/AmhiZzvx8n7jI9zt2tZ89Nk=
X-Gm-Gg: Acq92OHC3TLtkAvmGSVlhjGxRcR4LUMMK0Pn9Po9guYS66bCele0BkwYp4DaGD3SvdV
	PuZWaVdWPJTqnslwHjLbo5YbUeX0cYZf4FMUa/HV6gjPlueOrsUyFxdv38ko9h8JbZxSjMlwLX+
	Wepwuj1+7OEd1icnag5orbHuXI8392gZ2iNrW3pYrHd5q3olqh8+rnludFhFuANE3hcqR6LjslX
	oWAHQWqVZ5nbdkJCVz87my0YAxvGh3+4K3GOK3I8/TmNVLAaLCkLf3Bg7Vl1Vf0vlhwQU9HkW1q
	zHGF7DHyzNOgH8ciRJbThoGlK/eUueyFNlZTa+ZwEc1hRpTO5Iup1mmyVfTeX1t70zQLJOf+w70
	AitczqIAfrG2j9m7cUQjUGmTAz2h+e9/7eM5+INocWfsj2j5TvbzMOsxR9oRLdEuf7qtyQql3g8
	ne7aRTOmbr2ftUWN90mDrjDTRigz1IVQ/QXhXnhJSPAh6lw8oCtacJjIZfMxJKHDV4IEuIng3/
X-Received: by 2002:a05:620a:45a4:b0:913:7bc8:79b4 with SMTP id af79cd13be357-914b49f711dmr3312535085a.51.1779892899207;
        Wed, 27 May 2026 07:41:39 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-914f86fbce3sm487939485a.11.2026.05.27.07.41.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2026 07:41:38 -0700 (PDT)
Date: Wed, 27 May 2026 14:41:37 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: David Matlack <dmatlack@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Alexander Graf <graf@amazon.com>, "Andersen, Tycho" <Tycho.Andersen@amd.com>, 
	Anthony Yznaga <anthony.yznaga@oracle.com>, Baolu Lu <baolu.lu@linux.intel.com>, 
	David Hildenbrand <david@kernel.org>, "Heyne, Maximillian" <mheyne@amazon.de>, 
	James Gowans <jgowans@amazon.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Mike Rapoport <rppt@kernel.org>, Pankaj Gupta <pankaj.gupta.linux@gmail.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Praveen Kumar <kpraveen.lkml@gmail.com>, 
	Vipin Sharma <vipinsh@google.com>, Vishal Annapurve <vannapurve@google.com>, 
	"Woodhouse, David" <dwmw@amazon.co.uk>, Luca Boccassi <luca.boccassi@gmail.com>, 
	Samiullah Khawaja <skhawaja@google.com>, Jork Loeser <jloeser@linux.microsoft.com>, linux-mm@kvack.org, 
	kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [Hypervisor Live Update] Notes from May 18, 2026
Message-ID: <ahcCXlbbnsxUAfeb@plex>
References: <ahXiYGo-IWI94IVP@google.com>
 <CALzav=dkVWYmbWCO6wDuQrxetAcqYkitJiRF_BhDDGqn2_-RKA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALzav=dkVWYmbWCO6wDuQrxetAcqYkitJiRF_BhDDGqn2_-RKA@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 44FA8A0015
X-Stat-Signature: h4n43m8jqeonjn1bwyyt9jfdpwxy6dy1
X-HE-Tag: 1779892900-302053
X-HE-Meta: U2FsdGVkX19iaoCBfNwtux8XGERmPtCPK+kZZzhiAdq8v79vX76iXGOyYX2kCsyQHZq1w8sNH+Hn/Y+3V4mVQBHn4D045WoVfGpVUtI5GO1OY6o3k3uCy4l9fTrv+r6GKbYuRJgFRcBP5eHVNDHtjte5jXy6BDoCU4ZYYhodnjzT6X4VcaEygmvl1zpuahHMvt4ssZo8f072QS3DcBfanqOu2ap5DmS1dwF7OOlo5fU5Y5eYuXggQRJ76d9dBTk302u+vMQCY29zpuLhTaOw8bh1sR3oHzq9nTmOaiBxu4bZeVZc2d0d3h2B0b/86l8lAgjdoZqf6SYHIPYFFubRcl5SjE6MSIiQo/ZUv5dtNko78R6vF1zAKB4xAyplf6PQ3wOTTJ6MulZvBJ8pQK5XlpWM4OidL5qEt43nVrugymhMLKcmq4p3v9nEN6+Xhq6CAmpX4/0kxm//o3fhg+OwV46vcBM40xGi9YWI9heor+IHV0xk1yYLUL1yw+AHLmsZ7d3rqE7sIjN6TxejGceTH7uA2uHHAptM786OZjciN6oYhCc+3klVA/5RnPtIu+/q8Hf1WbND//sCyM/yIV+tx4NxHZqkFweeD2Z+hVEblMQ87SheUehmqK1yvcHlyI0KrfPfQ5QDyIM5R17pQkEUgziZyUuQZst2A0STszXHC2IJDgr5I7XnrSn8uVf/oGeDvinoZjAhIzIaZqdhJHkbYVlIXc7qqc2jwVe3o1wbftAl9EYWBCtJlkG5AfNO2rWBvJ8cvwfPjl/iuHiYjspsvIL0dZkZ6a7EaQcbmHIgOfhXdT3PWsX11SDxODgLrBDTmmiVIND2FTEzd34uCGv+J+ogSAjSRrRQJP14uIJa/RFNvueCmboVc8WDxU5JjJejhhgFZG5+5Qu+18DivDHqsyWR7bL6A5RxrkaDeLWNLOJqd4cnay+yyYLW8GDIx7DkEPcEsS0ewxuemukghG1
 +bIm05lZ
 cYnYBjzqzmMr2MRoRnqFAJwZ2vOkkhRZ9fJXkn+LFzL56e7V4HK8HRH9Ibbs1MhqZRXDh79UQtZpL94137emT0eYCex1fFlsjTZZRMdhLNGZUauwjTnyMYw/MXiAIVZchAOyCZz/UTBLVD0WWun3SXoG9OfMkqJy1uvjQNIA06Pz848njmqF6VUhZ1tzbDQPIYbCPuv5VLt+UMCT868lkjfOT8xPOjESRawQR6LQHn6seL/3RnliGHKfTHKks9l9iCYoW0PNI/GyjC/co6fPt8GJ01xLlRMD7dpZVaPuF+4RxBNC5K1iuc/nLaLE9AwSG8IaJEp54mK4dM8AfURQIg+f4LzY6C5cJ/iwlnv61zWE2wOGV+dpEQjK+qqQDy14Nl2QD52o/HKg/TqTIxgcZaPOFfiLT2RvdLCNP7Y3SWtcjL1lbXW0jxQWBeH51OAm1g/yS0c1W7V/WWqnTlJFCAuU1k5bljANHlXQdR85u5jvJwoQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05-26 11:53, David Matlack wrote:
> On Tue, May 26, 2026 at 11:37 AM Pasha Tatashin
> <pasha.tatashin@soleen.com> wrote:
> 
> > Next meeting will be on Monday, June 1 at 8am PDT (UTC-7), everybody is
> > welcome: https://meet.google.com/rjn-dmzu-hgq
> >
> > Topics for the next meeting:
> > - Vipin and David Matlack roadmap for PCI and VFIO changes to solicit
> >   upstream feedback
> 
> Hey Pasha,
> 
> We'll need to push this back by one meeting (June 15th) due to the US
> holiday and some out-of-office leave we didn't account for.

Understood. We will address this on June 15th.

Thank you,
Pasha

> 
> > - Status of I/O freezing implementations and HugeTLB fallback allocation
> >   patches
> > - PCI core changes v6 review and next steps
> > - IOMMU persistence v3 and roadmap progress
> > - Updates on vm_splice investigations for CRIU memory preservation
> > - later: KHO support for Confidential VMs including page table
> >   preservation and pinning
> > - later: versioning support for luo to negotiate
> > - later: KHO enlightenment for ASI
> > - later: testing methodology to allow downstream consumers to qualify
> >   that live update works from one version to another
> > - later: reducing blackout window during live update

