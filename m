Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B40ECA0EE4
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 11:52:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E68B890014C; Thu, 14 Aug 2025 07:52:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E18BD900023; Thu, 14 Aug 2025 07:52:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D076390014C; Thu, 14 Aug 2025 07:52:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BCB7C900023
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 07:52:03 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 72EBC1384C6
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 11:52:03 +0000 (UTC)
X-FDA: 83775199326.16.5B05D84
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7AD4020006
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 11:52:01 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=djASpFkZ;
	spf=pass (imf13.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755172321;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2aXYz9sti7d097J3nM05X5/YRpdJvcC3EyFw1+LP2Qg=;
	b=snsDkwXYuD598eP9V0w3q9V2Pfy1tYjEVlffXBDntP6WIPyWxCLMpaRC6eUi8bi3gCyjJn
	UzROVTuZrAH4eSDYFOcgdpAItNOMmO8buSFYCcGItG6Wm2/TTu/SethLfYFCQIkgRDuBQs
	H8quih95YqDEkzUbyUIFz7oOxS1lVTQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=djASpFkZ;
	spf=pass (imf13.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755172321; a=rsa-sha256;
	cv=none;
	b=6z2HCTzu9x89T5cPkqz11ha/JlHdNQM33DYzpYLk166nP0OgYY2CylD/dfazMq28YJfQYh
	/JDrBWnIj31lvb/EzddpYbZJLr7E4ML0kE/YVL5CjKv1D8QInlIJrNfJZx8lxlURN+0A36
	wErg4y9djn9G9bo2uF/Nicdy/q9XfY0=
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-3b9e414ef53so704079f8f.2
        for <linux-mm@kvack.org>; Thu, 14 Aug 2025 04:52:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755172320; x=1755777120; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2aXYz9sti7d097J3nM05X5/YRpdJvcC3EyFw1+LP2Qg=;
        b=djASpFkZBdPNscSLpgy1ca/7/dCAwJvzqG7zpdzji4XJSJN9mg7PJef+U8M2ufhL2f
         rR9iWnPosIR7KCLLjN+HQJ9ldOqgetc7BXe8aXcu+qc6FaDdkRR/fKa+hjhE+a9eSRoB
         oPhgIOdAL7Pg59D3ubQL16Ed9ZXop1jYAN6NJE6mbzFiz17z2xnG7T26Sgyk/Ur41FAa
         xBDvQTwXojJptxZ3+AN+Mqbbeac5KrueWQRd1TW3GUlqnqVBIEt6Q/ZPn+cBhjKnR+iJ
         AGg5ejS1oMZocAOwhMLsEUK0qkXWjFJqS9+c1up3s9CPuJ4GFnhFRMVnlj4j0hzJUCIa
         Y1nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755172320; x=1755777120;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2aXYz9sti7d097J3nM05X5/YRpdJvcC3EyFw1+LP2Qg=;
        b=CmkyaCPim9b8BiksX4ZHSMy6swrViT4HXBvk6QRMrzWB+N22WafVuHLSStVo3BDmSQ
         mvrSMSx5ARaElQ7RPtoQfmwU+na9c9uOnIr6WxBBYkP0Hm8qvq2ZO3UYaA6/Z5fGHDZf
         rJ10aVZSCdkNhtbZGyc8r0WDuFbjTBjtoc3BDNUn6T/XLK96yjRoq6FXNGA4PlnCXm0F
         QutnUN89s72pfnnDFaYiwdSpYvUIz9oFl5f6cHf0LpwiPWaJ+I32uUruONKUOd/5NQTf
         hEnYM+VmCyu5YZckidtAwl2P+s6UEtwOXWYctd1dcClkA3qBC6BTjXVaywA/0/TeMKRT
         EwSw==
X-Forwarded-Encrypted: i=1; AJvYcCWq5eOyKA5rlWWUwQ9EniEf3618lyVopQ29iujt4TK5WTPCr5zF5ehTwdoeoV5dF2dsG7jUuMAohg==@kvack.org
X-Gm-Message-State: AOJu0Yya391/kiNnJeyl0lDQuFKWVcJrsB6BqI34dcCgMTnuymq+b+Vv
	XO6K79GGaRgo4yLGuNdxibVbo/ksD7gNi1JuUcah53HlLY5ifABGIH7G
X-Gm-Gg: ASbGncuMCY9j+grH63vuqUzyGKfb8cpnaq1MCvZyDYzsyp/05gu2Obd+AsckRaWvJc0
	SKc3Vb4kTOh1Xeas1qAJ8M0zmcfFKjH/y2UVgnmjxpHA3NGXDHKW8cbEPEzwmXtrwuOBDJNxHub
	XtXrDIrwX4QdFKQUlswi0OEY9YXpdWA+dy1h9MR/YslfojoXgXToUYYZ9jCHC5FgksiUZKZP9Ss
	ZNfnvcD6t2HQYf+mILvOSnhGcSqfAFcXEtm8aq6bqVFGIZpXYTEx4tXeVdnwKJD/sxWpCcjwB02
	Vt6/uJX++do+bMdfTw4zf/DweTBnIAezW9z7SeA6AgGwp2uKiT6xuWA9eVfsLuXSmdFJ6XD4PwL
	E9pJfLIaRi/G+V8g7//BoZTciEd65vQgb/noOedGhCUmewO1yGWkuF26tfYygbR7O/ScFHhA=
X-Google-Smtp-Source: AGHT+IHQP8EPep7ADC1EPrnn+2NNU3zKvL7PTstarWC09hhGA0d7GWbatSOiEGnCz0J0LGGkKz5TnQ==
X-Received: by 2002:a05:6000:40ce:b0:3b8:f8d0:f75c with SMTP id ffacd0b85a97d-3b9edf2d867mr2713623f8f.35.1755172319670;
        Thu, 14 Aug 2025 04:51:59 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c453328sm53136827f8f.46.2025.08.14.04.51.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Aug 2025 04:51:59 -0700 (PDT)
Date: Thu, 14 Aug 2025 12:51:47 +0100
From: David Laight <david.laight.linux@gmail.com>
To: David Hildenbrand <david@redhat.com>
Cc: Qingshuang Fu <fffsqian@163.com>, akpm@linux-foundation.org,
 hannes@cmpxchg.org, mhocko@kernel.org, zhengqi.arch@bytedance.com,
 lorenzo.stoakes@oracle.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Qingshuang Fu <fuqingshuang@kylinos.cn>
Subject: Re: [PATCH] Fix the data type inconsistency issue of min (tier,
 MAX_CR_TIERS-1) in read_ctrl_pos
Message-ID: <20250814125147.483ff378@pumpkin>
In-Reply-To: <91d72c49-22df-43ed-aeeb-0b93a9da3bfa@redhat.com>
References: <20250808072106.153449-1-fffsqian@163.com>
	<91d72c49-22df-43ed-aeeb-0b93a9da3bfa@redhat.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7AD4020006
X-Stat-Signature: 4q79srsz7b7xst7xwmysobgm15kka8r3
X-Rspam-User: 
X-HE-Tag: 1755172321-584036
X-HE-Meta: U2FsdGVkX19L8bV3Z8rdddHhG+Ng1Cw9FaTcbJJK27Y6M1uEuE84XcJQfW+RZm/Qbq3ureWFPSE93vZuf035SGYHsFgPUoAdUqlui5ymmVjSH8eQMjp8tq9szcLWrl7tlOOH9kPfTMFvVT10cRtqsEjrJ+iQIsJQj+Aez8JYXtPeLeKkFFQqdGmIBpgmcnc5z5HXluj1HwuZAChZtGNoDwD2Lb8cIBxOii8TAhvWU+0FuzzZKG+b801C9xi1a97JzvNX2Nre3o3mlPIWLACeERT86HDoPToVC0JNtGXsbxn/xMRJmuZKYHkGYzS4SxCapeywLA6wnE0rZ3mt3m1L4DEJffQpwpugiyBr6mjvWPmOuwWvMr3AAC+Gydi2J2VL8TrV91GDYtu1jm5nZauS7mbA6suYuDo6hy4c/i02wFaQs356zD6OI9FzDN/z7/fgBPUIK1IkCkabubYiBZvLGU8lvjSxTGeUt8TRCB9w85KG9P/gmMTVAXM5hmSjUrqregr1DoSEDiiIlOJqSXaHXjDI3AU3Z9w1QV+q5VmRXimQRhPaHCOLu1rclsold0dhYyiQ8VDw+/Ha+zYWJYEFxZv3/D0CAOS4OvKVy3SyDalx84plqMu2GGHwcc6fDDwtd3gZVKKuU8UIi6A0vHGFDNz7FH8QYSUoHrG5QmAaGDd+XRH6X3H5yhbLQ8Y/ApNNg/tsSBGb64mbGKT5OPXSE1WUVLZncunWqpn8TkkotPLcH0u+x+y8RwxsEXAnaFX1sXlsC/khLLKsOAlgSPYWfOMny9b4OxZ6P2Huyu/kn2R3Sc2OeP+WPAY9Fr18QENsC4bzq0hmmIfHqyHxSt32GqOvK3gWl3ElldAx606L9yPchifgwHGG1FwmH7r7otzoC4ZQYFqyrSps/k8AOWKkImXxyACUT9O7VbATzAo/RWzlcCPFLhsh874hN5LsPqylox2gF/XbSnvmZFdHwOF
 PWX2A5OS
 CsVeTdgnUHsd3yt9/eWjcJ8zHQ6aDQg1wmTBQnNA4J58FC78s0vcIREBBMa72ZUxH1U94rXHLoVnFKBmGBswXxklwNIysSgdcejN+e3ecICNR7+U4IRmMd4s4k3xyul1IWUaqMM2/2lNAk9M+MgLXg6zgEtUdrUn8WutsGHcjLCPVoyOJQ5eM93LEB2uA1JRPxzKcUNRtDF+PrziK3K0NhEB7379v1Fy4XhvMyu21qNL3cum1/M491DhFoYdPPNPBkSOMru+WZo8oL4bFn+hbWp3bJGkCiD91XMjC95H3BNcQuxu5h9MlZb5cy6fl5abr3KnTwG/nZXhesyKsjopc5AZenVmBqjWzzGfthprE8OyDzTQh9nTe5MhjKKLs96xsOtKXzpjIy9hLXjL/Ehvbi/HAjTgYdT2hWvHyAcE4GyCKZUcV0OATj6Ww9lazfYLupYWttAvyifLOCXgZ0VBYKJrdmNqAyV2EIu3isqoCZLHn35iAb0vzuuCHyw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 8 Aug 2025 09:35:19 +0200
David Hildenbrand <david@redhat.com> wrote:

> On 08.08.25 09:21, Qingshuang Fu wrote:
> > From: Qingshuang Fu <fuqingshuang@kylinos.cn> =20
>=20
> Subject should probably be
>=20
> "mm/vmscan: fix build bug in read_ctrl_pos"
>=20
> >=20
> > Due to the fact that the tier data type in min (tier, MAX_CR_TIERS -1)
> > is int,but MAX_CR_TIERS is an unsigned type, directly using
> > the min function for comparison will result in an error:
> > from mm/vmscan.c:15:
> > mm/vmscan.c: In function =E2=80=98read_ctrl_pos=E2=80=99:
> > ./include/linux/build_bug.h:78:41: error: static assertion failed:
> > "min(tier, 4U - 1) signedness error, fix types or
> > consider umin() before min_t()"
> > And MAX_CR_TIERS is a macro definition defined as 4U,
> > so min_t can be used to convert it to int type before
> > performing the minimum value operation.
> >  =20
>=20
> Please use empty lines to make the description easier to read. Also, I=20
> think you can simplify this heavily.
>=20
> We should add
>=20
> Fixes: 37a260870f2c ("mm/mglru: rework type selection")
>=20
> BUT
>=20
> this commit is more than half a year old. How come no built bot=20
> complained about that?
>=20
> IOW, what compiler are you using and why are only you able to trigger thi=
s>

He must be using the pre 6.11-rc2 version of minmax.h

Some of the variables are clearly the wrong type, but min_t() isn't needed
and shouldn't be the fix.
Even the error message tells you to try to fix it differently!

	David



