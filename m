Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A2FFC531FA
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 16:46:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 490FB6B008C; Fri, 24 Jul 2026 12:46:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 468E86B0092; Fri, 24 Jul 2026 12:46:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3340C6B0095; Fri, 24 Jul 2026 12:46:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 08D116B008C
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 12:46:09 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 858501A02D1
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 16:46:09 +0000 (UTC)
X-FDA: 85024247658.09.A2F1C6B
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9CFFCA0014
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 16:46:07 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=OJHcQ+UR;
	spf=pass (imf25.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.42 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784911567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FftrUEk4ZkE1WXNTNenEBP8mAR3bbgckW3kBU/PXrbc=;
	b=sn84LLcvtu9GVkH6NmseesRCFdznDf2hBhae5pOXlJEgK9A2qSty1mrE3b7C/OFBRdyBKY
	6eBMal7RG0NHHPypksgzpRnCplkuSoSwxSKpI30efww9cJYx5is9zFQ5eykbBWCiz8g64o
	35o+ZnA5pcjMXC0jeDO1k26+uWVbbFk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=OJHcQ+UR;
	spf=pass (imf25.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.42 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784911567;
	b=HB1MbUcZZhb2r328giXZl0ni+hxMVqg/UnM19osKx/ralVbTNIgZTZh6SDNG6o6bVu3VZB
	HIKr1MRoC4/oZDOOLt1YyDPpP1duUsbMAxDX+WSDgoXLNntQzYD3Y+aByJ2cC/l/VFD+eO
	DtFKQN3DtvqiZr6b9t14uUL8xcT9oJA=
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-9034b6b7674so5986186d6.0
        for <linux-mm@kvack.org>; Fri, 24 Jul 2026 09:46:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1784911567; x=1785516367; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FftrUEk4ZkE1WXNTNenEBP8mAR3bbgckW3kBU/PXrbc=;
        b=OJHcQ+URqCjSK/U4i0cD+sVLPaRyuTfH25AowZkxRkNJMP9Dw+Xmogz0GpQAvaqHGm
         hAWfWjCNeDw+of1tDfRQ3+GSYvOj79WIACtmT02mzf2j3TkSbbLmT1ZsMPqM57pBqqnm
         oonGodXp3Sgav+RLoPvJk5widOb5F6DdmJwhTPZsOQCn2GdshC2R2SM4bx7pgDzp0e/2
         DHN/+M3A66w2PJVNbFBejEn1koRbkN23itRdGIEfagxisk/hYbnskmKmh1rKJvOQ35O1
         5rnSIp7/LBVMiVGsriHhWMulcYGpcAetMikW+xyV1zJlsJ7ec+GGwlVKSW/HU5GyBkKl
         3TFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784911567; x=1785516367;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FftrUEk4ZkE1WXNTNenEBP8mAR3bbgckW3kBU/PXrbc=;
        b=licdsgY9TI8Wr8nPsXvDCT5pa1ynJIgLqrrxrEhLXyygHVHuoq9v/upXouQ0XTGm73
         xDkuffK8SyEN95lrhPeMapnUE4xXYeMseWHBHs2CLIMqMiBQeumVQEGVzeSN4dgMYSZS
         VBt4Hp85kDyrbJml9/xmIA5Uo98Nbmwyj3s/gOe/COzjzkn6FtJ5Ingal4kvLQI9/aMO
         ikcflN8i9ucJJh6GS2V+/vN4LGmtTOkoLxOsGCLkH1juOA9dNFw2dnT0q2/GgTOJkWWT
         xar5HEMQiSdXwhFoGBexmrsQdij6t+vPW/lr+HBqF4fBgvvG2pV0WCUcCPO2fhTah4YO
         Bggg==
X-Forwarded-Encrypted: i=1; AHgh+Rq507TJ7Ty04kEuMtNhdoDSzIOCvVc0hOAeh8AiGwAC8Y3xIyw3wKuPCa8bIJ24VN9MXOD4WXGBAw==@kvack.org
X-Gm-Message-State: AOJu0Yxjpikm55/8KqoHZPh4O4qMLFYOZxdaEKgAN7vGSgkrEJDXeBZu
	UyVbLEjteSx8I04ezSVH57pJwte/sEHI5ciCKmpVwpR7P9ioCVqIwn2PM+ETl4MDLlE=
X-Gm-Gg: AR+sD114/3Q8J8NB7hZyFArB9JE72s+rqDrAGbF0gv8ZamEU/aM/SU2Zx+Y9+6hU0IP
	kmpHcGp4Wz5IdNggdhzAa3MzUAAVbrZQ6zr6ffL3A+TRgQOCqd/jFav1AaXLkyHabdkEJ1eY7Hu
	tlYzTX8EEQVuL+1bbiTN3CxmSj02opxreZ4qsQg92nNZx+4iPkGbK77SRXAMl8YmqLEI4m3yHFn
	amWbrCmj5Xylzv2jnk+YdRD4k2N0odz3dt0QAeCeoulm7vnfwfi0nqNUUgBVCyjZitzSxmtSrIa
	DtyHY3di/DQiUrNzAI9+rLQvYAoNMLU4I2QnGatQ2shOa4gylioMLYunriDOiGlTIawAxGKG0DZ
	XrEP4g4BPEZuy1wm5V0MYqq2dfQsuM1qKJn9imHWH+T+mvnAanQMUv6zhiLssQ6sbAsEOk5M8Rh
	UU87M+XrEqnQqFM8mhEh5+SEV4y7yN5hBAjQyGRvhe
X-Received: by 2002:a05:6214:f0c:b0:8cc:de2:3b5d with SMTP id 6a1803df08f44-907ca5734acmr98718436d6.16.1784911566647;
        Fri, 24 Jul 2026 09:46:06 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-907e851ec5esm1986286d6.10.2026.07.24.09.46.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2026 09:46:05 -0700 (PDT)
Date: Fri, 24 Jul 2026 16:46:04 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Tarun Sahu <tarunsahu@google.com>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>, skhawaja@google.com, 
	kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 3/3] luo: Update serialized data to use KHOSER_PTR
Message-ID: <amOWTew3JpsY4QcB@plex>
References: <20260628001114.1869564-1-tarunsahu@google.com>
 <20260628001114.1869564-4-tarunsahu@google.com>
 <178271651966.13502.2620034351625890943.b4-review@b4>
 <2vxzldbklb18.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2vxzldbklb18.fsf@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 9CFFCA0014
X-Rspamd-Server: rspam01
X-Stat-Signature: 3ttand3we8whxxw46kmqjqykncxguizc
X-HE-Tag: 1784911567-449425
X-HE-Meta: U2FsdGVkX18oSoaPDbJMXXxLl/FvgPp8a/CBFWnOwN65o4ACKesl9IDCUhAX6gjO2c3c1BMcm/OuvgOd+l4YHnVBcI2QujC1j3saFmNYkM6qCjpg9+JGJGw6sYNPmzOOGfv8GaFdta8XXlNcQ49PiWtdSXT2G1H2XJyiCjrOfMYunhu2jOYfCP4NlUucS08BLUUoChL6HsmWj03H6X/pWf5ADzZKpLZNAJXwDVwChKkR2BTqJrVvhUi3zPoG3wY25lvugMPrmkiz2f3p8zKI4ZbZI49Xg3C6XXPdK0vXmiO4RVZPQlrV+k/3K8skDrB64O21y824Cdv9Uxzpk74s4lnOKmyXwEovFJEVBFwi25bPZDaWhCtM8ViQGNnuEt/oU99Oc/di45t9kOAl4zgnMuAvBE7j0EWry7lBSH0MnFiUeG5RQkeuGH4friVCS64hF3PHE31CT9uP7CZNvcQBAW75GgJZiGn1EWoi6pZ1qDwHXM/79sSiZz49leYK6XncFZJXUp9NIgsb/PMImA3aVKFBimb3fPzadxGV/tnsA1qojTVcEde4ItxRb6SSqvNv0c/pKTNonOb60W7B9U2u3xxAjPPfnk1a6wVkWr6Lt7vj9PdVYdSum8B4NLy+TsDAWEnYHOHDdD5wXFEr5glWyZiqYdGrAHR+9abGcyFcC1DGpg2Hji0tVkQpReGWQAuzEkia94vmHq5lAYn3Wfg7lDoY785gMiS0iAdjwk+KH/FpEj0P6MEg5SkNOQvElqhflpeZYb0ZPf12mRgMCtu8I3ABfpi8XwtZaFNGNGiBUC6XGQAz695HbxGonneHnhM6UJNGrGy/IJpAfHrV+8U0IDWenteAu/aaQyxtdxl0keZ9i86VAcH0w7XrXmOX77xhoFiCSFyjM7Nz4OtsWdYsEM5NWY5Hgge0bup+s8gncEHATcv0h7Iu6gsll2C46WDnDHKtQxcYhzJIFqdRPIx
 bmgVlDMa
 ekPxlIleuq32QXgjmWfNnrY42QbVoTv+9PxqyYlCLFSIfipY8O6CHZo5d8JC/MmBFUsJHLi1xI9zlCm7X7wWA4zDO1npvFeBjKFIHW3Q8CvDHG/uooNP4ZKu4m9UVJYy0nmLu++hJ+x9A3IpfIMvE2Hb225xl86FSK4/KS7/INqIPiPiGiQKIvvM8HE5xUJIeEKp+fZNvGkjHJIa+s9ccbtfSi72uv7ph0+/5khEpTKoqXLOeyDk9cSmPG70xkGanwghYSY77a1/MNxsOLbKpJRomqB4TnfEKklB8+8g+RK2bbZPt9wnrDCgEocIMP7m8T4W3eU98R2slBVvmf4ol+HJZPcpLLXkL+z8eiM7B7COWPRiur4WfJVbJQjyi/rnvygNJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 07-09 12:20, Pratyush Yadav wrote:
> Hi Pasha,
> 
> On Mon, Jun 29 2026, Pasha Tatashin wrote:
> 
> > On Sun, 28 Jun 2026 00:11:14 +0000, Tarun Sahu <tarunsahu@google.com> wrote:
> >> diff --git a/include/linux/kho/abi/luo.h b/include/linux/kho/abi/luo.h
> >> index 288076de6d4a..9e78625cfdc1 100644
> >> --- a/include/linux/kho/abi/luo.h
> >> +++ b/include/linux/kho/abi/luo.h
> >> @@ -89,14 +90,14 @@ struct luo_ser {
> >>  /**
> >>   * struct luo_file_ser - Represents the serialized preserves files.
> >>   * @compatible:  File handler compatible string.
> >> - * @data:        Private data
> >> + * @serialized_data:  The serialized KHO pointer for this file
> >
> > I am concerned about layring violation here.
> >
> > LUO is designed as  a generic, opaque transport layer that promises to 
> > preserve 64 bits of raw data. How those 64 bits are interpreted is 
> > entirely up to individual clients.
> >
> > While some clients like memfd_luo will use those 64 bits as a physical 
> > address pointing to KHO-preserved structures, other clients may store a 
> > generic token, cookie, index, or non-pointer status. By
> > changing u64 data to DECLARE_KHOSER_PTR(serialized_data, void *) in 
> > struct luo_file_ser, we force KHO pointer semantics and layout 
> > constraints on all generic LUO files.
> 
> That makes sense theory, but in practice, no file handler is going to
> need only 8 bytes for its metadata. It is always going to need more, and
> to store more information, it needs to store a pointer to that
> information with the 64 bits it gets.
> 
> Do you have any examples of something else one might store here?
> 
> At least looking at the current file handlers merged and in flight,
> memfd, iommufd, vfio, pci, hugetlb, guest_memfd, all of them store a
> pointer here.

Right, and all of those types are private to file-handlers, not to LUO, 
so my question is:

> 
> And if everyone is only storing pointers in this field, might as well
> give them a bit of type safety.

How khoser helps void * type?

Pasha

> 
> >
> > Clients that need KHO pointer serialization must cast that opaque 64-bit 
> > value to/from a  KHOSER_PTR  within their own callbacks.
> >
> > Also, the field descriptions in  struct luo_file_ser  are no longer 
> > aligned due to the length of the new variable name, I believe it will 
> > cause warning when making docs.
> 
> -- 
> Regards,
> Pratyush Yadav

