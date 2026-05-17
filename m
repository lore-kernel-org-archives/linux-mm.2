Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DA32CD4F3D
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 18:40:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6EEC6B0005; Sun, 17 May 2026 14:40:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B47396B0095; Sun, 17 May 2026 14:40:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A84686B009B; Sun, 17 May 2026 14:40:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 99D7F6B0005
	for <linux-mm@kvack.org>; Sun, 17 May 2026 14:40:56 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 596301610DC
	for <linux-mm@kvack.org>; Sun, 17 May 2026 18:40:56 +0000 (UTC)
X-FDA: 84777778512.06.83D345C
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4C03C40007
	for <linux-mm@kvack.org>; Sun, 17 May 2026 18:40:54 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=jqgcBJ+Z;
	spf=pass (imf01.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.48 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779043254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yO9O8pu4RjDyHVPuvzyCd3iEZISD+KMOY00JM/YV72g=;
	b=Zx1l1pw4dcb712AkrmkDtNpoYEXpScOizv1bfPgLy10riEoCXKj5UvdDRZRYVCDmYNf+r+
	GTVPGAgrg283KyPNMhREOMcLNQ2rEjRV6b3p5Nd/sffRB7B5am9DMuGEzSX32WQd8VXYA3
	tQCwcPtNFSIgdKxV6jg4b+CWUr/HnHA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=jqgcBJ+Z;
	spf=pass (imf01.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.48 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779043254; a=rsa-sha256;
	cv=none;
	b=jJVFG/1OVMOBCKBBjnvcLkimawX9Uo6O5KSoPmToobK5hKIPv4j5tpxSl0yffD/D4V9hC8
	hZcSCpnTo/8M3uiOvtsCXklE9MVjxh/5h+g9UVJXC26M3is6YvAl4I+o+rwtabNn0xZbCU
	NJk7jp+AZkgiNw+I6KkOMyyZTLNKcXw=
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-8c7154725easo24203736d6.0
        for <linux-mm@kvack.org>; Sun, 17 May 2026 11:40:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1779043253; x=1779648053; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yO9O8pu4RjDyHVPuvzyCd3iEZISD+KMOY00JM/YV72g=;
        b=jqgcBJ+ZpJFI4b4iSW300htTVDxbnzMA7DwkbXjVzgB6/MDj/OkTXjotMNO3sSVWOT
         taDlBTUMHALxxFz7Hd8WLugi5aU/UwyIFZKZg+F6RyZPcjZ+dMburh00Elj7tpVklqun
         gFiG94YcZupgdT/CwYYdFCzHSlpOvVpTY5FSxSN+IEU+hMDkgq8f+kMrTU+sfdRRSRrP
         JVokKY4rjxIon4Q+n/L5Z0Nn65eLyFH+BOK8g3zorhnQRrWcHuD9pZHSbHXsis5uuJza
         uvZSi4cZ8krH5tafYZog0Eee9sZMV4rMT/K9pHKVEFwvZhTOYW0XyuB+ayQuMO4GSUGe
         Jlow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779043253; x=1779648053;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yO9O8pu4RjDyHVPuvzyCd3iEZISD+KMOY00JM/YV72g=;
        b=Juee5wNMZGLQThYcnwG0wIjzDYnDmYS6MJDXC7YNSywz5+VSErmz18HygMqOXq4wbY
         xgL3ZINVdlwMqONFmdDOVc53mVwfIE4HTqJg6HZKSwWPqQCPi++EK+Ss6+BB5ycIsOQV
         W2t4psZEMgEogOALcStvM4Wt//vT+F0UHp3qZ0bnm41BrRtfSy2YdEgHTdvAh6w4/zrv
         BGL8OiqhGdGU36s51pkLdPS86W5ZzDkHRoserj8LD3FII5evS840OUD5Se1esrLOFAtj
         5mepuUcHQffb7eACDHfx3jxfTktK0xZzdSnJHGht5iyTWJ8DVdzC9jMbkv7bGz0oByRy
         jZ0Q==
X-Forwarded-Encrypted: i=1; AFNElJ+gQPdSbevv2VGR9r+iZfzNJIor9TyWiVmJo7C43iAv/KCS+rwvOH+FiDCx8YZochpW/Cf2rqJalQ==@kvack.org
X-Gm-Message-State: AOJu0YxMkbiapantsGGE6DktyzlueUJGkbKYwdiO7SdY32BFErU58Po9
	Kn9kN0Bd7vSN7IFd9BXZCyExQaRsnQV2v+CIrau1y3hyC5eKPSzjn1nkFcNvwqlJGSc=
X-Gm-Gg: Acq92OHgznkCxDtT2vJrvIp7cDelDk6BSJanErSvtbWl6cUucgk0vMjcawmjVIgny5s
	nfWSyRCbJ0qNMXFvZ3oHRGaxlU+FmP5QCW79ESxtr3dilGi9I4NiB1hEFLONjC16hnuSArrWeeS
	L2caXHmooVeiCvtfvF9+jMvU69G2VUFBIfnXl5gi5QEv48LYuVUunGOYweBfC4tNfMB4n4WDgle
	DKD+GHWl7kd3vaOY3nWp+JRMryCGWtjzT8p6EJ62BvPl90UrfyJnNwQ1mq+VCKwW0vU0Qd1oJQr
	9n78FtuKS1DRYpyefmvo/sFQWST1UeX9//14WSGrXyfx5OCOqXcgVh6Dz9JR8jBHAv5RiydhGmA
	MMGbScXteifM8i68jIrqFUoh0P93QXFU4iqznurpOozt9LRn9cSFjWS6/993V+4g8Imo3b8LVnI
	XbeO7IWFYaiwssKr01UYoZRYzH1nsVyI1f7lkbJX95Hkx9Wc9xEgU=
X-Received: by 2002:a05:6214:23cc:b0:89a:f0b:60e9 with SMTP id 6a1803df08f44-8ca1ecce8bbmr127423436d6.13.1779043253347;
        Sun, 17 May 2026 11:40:53 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ca3619c7d9sm29192256d6.36.2026.05.17.11.40.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 May 2026 11:40:52 -0700 (PDT)
Date: Sun, 17 May 2026 18:40:50 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, 
	linux-kselftest@vger.kernel.org, shuah@kernel.org, akpm@linux-foundation.org, linux-mm@kvack.org, 
	skhan@linuxfoundation.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	corbet@lwn.net, dmatlack@google.com, kexec@lists.infradead.org, 
	pratyush@kernel.org, skhawaja@google.com, graf@amazon.com
Subject: Re: [PATCH v2 04/10] liveupdate: add support for linked-block
 serialization
Message-ID: <agoK7TRpT1LErW8H@plex>
References: <20260514222628.931312-1-pasha.tatashin@soleen.com>
 <20260514222628.931312-5-pasha.tatashin@soleen.com>
 <agn6QeIamoeMkesv@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <agn6QeIamoeMkesv@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 4C03C40007
X-Rspamd-Server: rspam06
X-Stat-Signature: dhwnjxocohkuc6z4dch6rsxgq4scpqtf
X-HE-Tag: 1779043254-686192
X-HE-Meta: U2FsdGVkX1+ChDdxuTAUwUAV9y48dL95AgeGBl8RkiekJASekdfTR8mt8fJNo1CnCWKD1Bw9wuGNRmcSuJoiior+mon9gF1I2x5S1aXQbk+MNyDFpW3Kam25HhrjV5nz9WM1uj+26ZJcDI4wEZ3xcOYOD5SxQSwJlMJgU6Mu3QgyVPCw+WkCq0kUL7fXSGJxGn4s1EeTdCGZVazSriVxQv8j2FKpj3mRxWHdBL7bfcNdC7O+UXA2a2WIvlSDtnrgyiuEZhuRJT3mMCX0VEFrybFPDOVb+9pKdsBE0xc3jS0BmkA5Asv9AXYnXM6wAgT3RRL8Z2BBRtY7b3AgIwJ59wLUTYy+BaaOiNENA7fkmagQmCRexLKKaT3guex3QPIbOnJBLGycv9zTFcboeOaa83xLVe8ULEM4Tm1aNNEQu4XwgNkXtl4+NQjqRMI6i5+yAHVHgwE1anQ8JC/Mqn8JKyvOnUmAec375YeDkwPCrO8J9bwVVI4HmAvxmQnvGLK4hEFv1+wCRcCy1jyz8rFRaclUPnnO+mm48ibmfk0UYrRVStq8pVlA8MPmRBrUAI/r6gXNiCLcS8UvEBXQtgL0biKq64iXBFGoDxOu2KFYQqBmQbTfI3xuRlQNbsDPHzvciU77hojrqF5BfU6bNTapUL01rKBSyaNgoYItaWLox5NolmRjE1lsoLd+ZuvUCNef22l5u5mEHhOJh5VtTU6s5pfFeQ/X3vbpo7fSN33Wjqzth9yhwOewJly+W5IYSgxk3JqeqVEAOp6hlR84OBLm/4BHBs6ZXp9MjtsGnB4SGHxciLt/XrL2+TGu1IYJTliSHSvoP9cEyHw+wS+zSnr0W6+hymiQuZDHA1rkrC8swbcGCAMJoURFcorH61cHgb9G7BZbOPaZ2tzX6DUs/q7o0AAtp8qFyhRIbFuig6brsSbcoi7kbvvsxW7+/rkPKvjaIu7ArT75lcE8KrOQfM+
 WWtks1CA
 88Q1O9pchg0z41uT9DcTz8X67KWzqhmj/RQzkvYVa3uc4uB8ZnGaHTeU7IS0PLOCqKaO/VAcJWMJapNkI8l3ug9arXUgEzaYxFdxKc5g+4Ox1n4rFiHJWsmEZWbhbLxoXX6KHg/QiM6Qqzr4XIQqcM4F3dCc4OskpHUFnThk5SloApHtPtCoXHEJOVRp5aBpySweH0WlMn63DBy6+kpsJkUWQzxTrhS2nBTy5q0szM0nXRcXDFCLEjOOx273o6qNNm5Z0dBcHCHwh3V6jCkgaxhwJ556sH5okpPSOtcjUSnNWprnn8MpY4roGEq/JpBz76QpWVNLiaepHHVbhhs6GxmYxlnxDvJXj6EaUqr9ZVq0HHpMT9Lg+qbhwP7xJCaLSRa0JeoU5ef/NzjFEC8Q9hiZcF1yRh+A44SNj4FLUIQ+GuzBBqWPZWiIlto3c7a/uB76admdR7Htnk+U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05-17 20:26, Mike Rapoport wrote:
> On Thu, May 14, 2026 at 10:26:22PM +0000, Pasha Tatashin wrote:
> > Introduce a linked-block serialization mechanism for LUO state.
> > 
> > Previously, LUO used contiguous memory blocks for serializing sessions
> > and files, which imposed limits on the total number of items that could
> > be preserved across a live update.
> > 
> > This commit adds the infrastructure for a more flexible, block-based
> > approach where serialized data is stored in a chain of linked blocks.
> > This is a preparatory step to allow an unlimited number of
> > luo_sessions and luo_files to be preserved.
> 
> Shouldn't it be a part of KHO?

It can be. However, at the moment, it is only used by LUO, so I kept it 
there. Sami is also planning to use it for IOMMU; if so, he will adopt 
the interface for his usage as well, and move it to a separate KHO 
library.

>  
> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> > ---
> >  Documentation/core-api/liveupdate.rst |   8 +
> >  include/linux/kho/abi/luo.h           |  22 ++
> >  kernel/liveupdate/Makefile            |   1 +
> >  kernel/liveupdate/luo_block.c         | 388 ++++++++++++++++++++++++++
> >  kernel/liveupdate/luo_internal.h      |  57 ++++
> >  5 files changed, 476 insertions(+)
> >  create mode 100644 kernel/liveupdate/luo_block.c
> 
> -- 
> Sincerely yours,
> Mike.

