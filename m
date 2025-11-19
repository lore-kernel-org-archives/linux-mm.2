Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81148CF58C9
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 19:45:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A670C6B002F; Wed, 19 Nov 2025 14:45:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3E626B0088; Wed, 19 Nov 2025 14:45:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92DCB6B008A; Wed, 19 Nov 2025 14:45:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7F40C6B002F
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 14:45:13 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0276E160511
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 19:45:10 +0000 (UTC)
X-FDA: 84128385222.30.9268022
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	by imf06.hostedemail.com (Postfix) with ESMTP id 005D3180008
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 19:45:08 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=DjfAQGpD;
	spf=pass (imf06.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.177 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763581509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ngigizqFoW1/n7l/UtYTJcb/TxX1OBEkHcoOUDKA/VA=;
	b=wRu061YZ1LiQuULEfGzwxSmZ6D/yfKxlajOkqMIwVFTPEfu9k2AxXI6X6YoZ6fOhwpQKwt
	5hTJsl6rNb5XlM4aICvoJaCvahKOnDUv6rBKOUy28C2xlndCdzJnUoTUXjPGoSuBnitfEa
	2srRaNfuqEgaNRTiWd6dvma68sIP5zs=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=DjfAQGpD;
	spf=pass (imf06.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.177 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763581509; a=rsa-sha256;
	cv=none;
	b=7R0/7xPeh2UHNHe0csF1R6rgrCAvoiIriK4mtdeMZ41mqonS8pp+IsAV7bmjuSg9OBAOpl
	DYBWhgDM4xI6tLlsT+7QgdcK9Ky+RhVmIqSWw6vDvABk8RAtPFHoBZgS2DgJjtgKjIw3JJ
	UDtQP1kWS8N02ejDWpw5oa7FyP+iC+I=
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-8b2ea5a44a9so13057685a.0
        for <linux-mm@kvack.org>; Wed, 19 Nov 2025 11:45:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1763581508; x=1764186308; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ngigizqFoW1/n7l/UtYTJcb/TxX1OBEkHcoOUDKA/VA=;
        b=DjfAQGpD916Wzt+CuM108GBVJMC0TCf3otk2YDpZqjKzuFXL3GOEsNfWr8n5YQ2ibV
         MDPHxK4WMiygV6WvwGdBKGRKDpWQXgqJcTTXZLMYOwsQJ15r51NyeQQv+oxtVrmq81aN
         L4+ce7fSPI0PDwqCyyBN+T5LuACUIFIilSTXQ1m0lJHocMwy6pl7/Q/PERHUF/eKpe+5
         Q1ZsgXzDxh+LrZu30yyzc+a1+YEhqy/NPUQCPxq469Bvg1pllgvmK1nzWNyj9shDObAt
         CdyHmXXHjPLMsR2xoewThtv3tZYEr+/xFDKYZonUMQR8L7LPtizoP0/LU3xCVY5NkvGr
         tvzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763581508; x=1764186308;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ngigizqFoW1/n7l/UtYTJcb/TxX1OBEkHcoOUDKA/VA=;
        b=vymdROXW+Xb+9fBlaK0oPi5CfBOT63U0DBgrYNYIt0Zpqft0HwbHc65lXFlfT7hrCB
         L8bo3uGO8l4/CAMwuhdPao2AWE/giELEN24JnSengvrF2D5QBrI3F7ZKFuMuSI3yv/yM
         GL/C5clkseOOzLzmrchcPuvSMtHNxxZdLZGsjWrUgnXOh5DkeJyIp1v0nXdss1FAWKnt
         fpo0FPFmjbliJt+idNGki03OJezgvW8iz106W0vL9eBSb0qCnOcS5CFbcAXbRkV/AYCw
         rOFYfrIwEwSORdInIw4zpw4ns+uZobgbKO+zJ6jLycnVuDPgVVkk+ZbEGJ1aLtaPvsrT
         nQKQ==
X-Forwarded-Encrypted: i=1; AJvYcCWfe2Bc+Ipq6v+oI0jcEARts4OHFDRFirejLcWC0Ke1hnut9B0JNxfj6g6kiY2IYEH6BepfQSRK+Q==@kvack.org
X-Gm-Message-State: AOJu0Yyqe6vRU2rf89D16rMz5SKgPFqWX31pIX1Iy4Qyt00aNUHB5s/P
	f1nz5Px5nhX2ycaouAqkMkbMyJO/FDgxKxcKOyXgi6eP8jlTelFFEMMFO0867sUXPwE=
X-Gm-Gg: ASbGncv0mDiY9pqjpgsd8idR+gE6x678pMwKC55LJ3vR2+NQxlotmJRndNkTcI316po
	i0O1H6/la4aHxoyI6KYkzZBdJjeTlMARjGje2YJuS5opO7mLb/Yu+1PjGvGtm6wSiXC/1YmawHe
	hgD2H/Nwby7RYJDd1N8AknD/tE769upswQU1bVjIFTZwnu+rH+GB7HBn/IjcM74bRkiNbj+XQzx
	9bzQ725IxxXeH66VWpoG6U3ul+shla4yR4fWl6CIo2Fzv+9RpkNWNayLNmviaVcPYNIln6UHmFv
	2+1aeDYOg16Md+t9sf2N5AttPXN84PWyCJpyHxnaDqgUN3TIs3G4lz/iXA6O5hnqJ8Fb8RRfP8o
	oAE+zBIoq0NZWCbVfH+p8CjAqZStB5NEQE1/ti8xgKa8JqXvS4/kbjFrFmecTfXopBi8nOHcoUF
	qn1D1BkDUIGPtypvYD0+PrivS38o4c11PcoGHj8Jh7T0QWS9VFW/vFYWE+
X-Google-Smtp-Source: AGHT+IHM2All3T5KCtKB0YCjHC7VAw8938Pjcsqc0YyXScERh5oSqA8kZNdUfx1RTYUHZ+fIhtYAoA==
X-Received: by 2002:a05:620a:44d4:b0:893:31da:1028 with SMTP id af79cd13be357-8b3274b5313mr86654885a.90.1763581507903;
        Wed, 19 Nov 2025 11:45:07 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8846e447272sm1944186d6.5.2025.11.19.11.45.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Nov 2025 11:45:07 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vLo70-00000000bcb-3TE0;
	Wed, 19 Nov 2025 15:45:06 -0400
Date: Wed, 19 Nov 2025 15:45:06 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>
Cc: Leon Romanovsky <leon@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>, Jens Axboe <axboe@kernel.dk>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sumit Semwal <sumit.semwal@linaro.org>, Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex@shazbot.org>,
	Krishnakant Jaju <kjaju@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, iommu@lists.linux.dev,
	linux-mm@kvack.org, linux-doc@vger.kernel.org,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, kvm@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH v8 05/11] PCI/P2PDMA: Document DMABUF model
Message-ID: <20251119194506.GS17968@ziepe.ca>
References: <20251111-dmabuf-vfio-v8-0-fd9aa5df478f@nvidia.com>
 <20251111-dmabuf-vfio-v8-5-fd9aa5df478f@nvidia.com>
 <9798b34c-618b-4e89-82b0-803bc655c82b@amd.com>
 <20251119133529.GL17968@ziepe.ca>
 <ad36ef4e-a485-4bbf-aaa9-67cd517ca018@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ad36ef4e-a485-4bbf-aaa9-67cd517ca018@amd.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 005D3180008
X-Stat-Signature: kartzxgaops478hw9whdxw9xx1m1u8fy
X-Rspam-User: 
X-HE-Tag: 1763581508-741798
X-HE-Meta: U2FsdGVkX1+CBB54WDF+U4BXKD36HI4ZK0Ardm9agozsneEfshTIoX39V+9t68DsF57ZdN7p0BMpd/WflIp5GL3Mtj6xDyxedSrV7sWjeN/tKNYOFTPUZ6PwM4k6qa24ulsFOP0eq0TOtEBozTpcPMvUkjJ0lab8reWsJC5HFstpFHLeFjywQ/DZsA+2keF7J+IQmXSEMCDHTCuba/vPK+C6PUCIukR0Lwv8egjTRTV73YjCF4y+8LwIz7Shm0lmlB5n7Ca1BEeMfGRTmpwFWynaT/58UQD49vNPsRVGBNtLC4WmVgWMXQIJdC4P9SNDmAPAzkzgOTuUwzRDBjruOE1P/GFTm5mqv4zgjpbdkpNF3C+CE/00KRUw2U5oj0Bnx7mF0KNEZUxPNowwuvIw88j87JklAyNoaSuHDIrlDE8PSLa5HOhKaHEVvYj+JpYZ9MvScsZob7WynSPCBOH5Gt5Ounausueo9UfiLs2bU9pdInlz0tfvKnM65v6PEx5bYcmEzUB0IKib7pcMn1DKgF2MPhJaNQanJ5cVrhFuSw+SZsvePO/LfHJATO9bhO+LvwNRIgZihrIUsdEmum2vaFwf1AcrxBrSs7bdme+uvMDEzmyPzOyGIaacsH/Rz76EwUDRBvYIsACb88qjW0NnwX+YCEY2h5eI0zghy1B2HireX3HoLNdY/V7PAhgJ5PSurIlCcgRBhfo3uHMQNB3nE5cwRLZ5uftRo+KJ3xm8AscTEnUC6a83Uzdy/hDB1oFddYFY+919A9hSQkw8ia78OETFy/tJW0VqoV7D6oMwOicLxJ5b59n4CEDMlGRU47xKR7rzNzR4P/bGS5PxON/5ScnQJVAgAf2pluPKiCD7xLXL4164CWjUxmymaFCJJ67NB2iARGMNUXLSJ3egAaB3z1TcmtjXmTVm8IMld8rXdjt9ViGYG8g95vU53yu1xBPtEGIEIJdaH+1QIvRyrQr
 G/TTPMDW
 nCxNL/OfLKbOEx1mHf0a8LKp0ElWiJaACSctkEySs2vYD3Lg4qRkU1sycgzoq167zKEzI73/vcObjpP3WTFM0MDFy/XRbhZL2w7X/1Dvs2XY+EX7esDZDf8+fMypptSIHoiRpIaweWAHcXq6gb+bWKxiclejgHJI+UB4KgZIewrPM7WCGD5DvdGHsiNcir6b2O7/KtQ6P/ho4Aw8stkmPLKl4sHOAdcEZilzEmRQDtFzrPGYE5QqtVjiyn5GNQbXtykWEfpbLwKLk3LndOcAUwMUGAM+MV0WZh4aTIOklUh1gDYOqW92YOAD6Gg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 19, 2025 at 03:06:18PM +0100, Christian König wrote:
> On 11/19/25 14:35, Jason Gunthorpe wrote:
> > On Wed, Nov 19, 2025 at 10:18:08AM +0100, Christian König wrote:
> >>> +As this is not well-defined or well-supported in real HW the kernel defaults to
> >>> +blocking such routing. There is an allow list to allow detecting known-good HW,
> >>> +in which case P2P between any two PCIe devices will be permitted.
> >>
> >> That section sounds not correct to me. 
> > 
> > It is correct in that it describes what the kernel does right now.
> > 
> > See calc_map_type_and_dist(), host_bridge_whitelist(), cpu_supports_p2pdma().
> 
> Well I'm the one who originally suggested that whitelist and the description still doesn't sound correct to me.
> 
> I would write something like "The PCIe specification doesn't define the forwarding of transactions between hierarchy domains...."

Ok

> The previous text was actually much better than this summary since
> now it leaves out the important information where all of this is
> comes from.

Well, IMHO, it doesn't "come from" anywhere, this is all
implementation specific behaviors..

> > ARM SOCs are frequently not supporting even on server CPUs.
>
> IIRC ARM actually has a validation program for this, but I've forgotten the name of it again.

I suspect you mean SBSA, and I know at least one new SBSA approved
chip that doesn't have working P2P through the host bridge.. :(
 
> Randy should know the name of it and I think mentioning the status
> of the vendors here would be a good idea.

I think refer to the kernel code is best for what is currently permitted..

> The documentation makes it sound like DMA-buf is limited to not
> using struct pages and direct I/O, but that is not true.

Okay, I see what you mean, the intention was to be very strong and say
if you are not using struct pages then you must using DMABUF or
something like it to control lifetime. Not to say that was the only
way how DMABUF can be used.

Leon let's try to clarify that a bit more

Jason

