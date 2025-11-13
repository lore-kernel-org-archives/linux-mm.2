Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 280ACCD98D5
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 20:11:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3577A8E0011; Thu, 13 Nov 2025 15:11:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32E828E0003; Thu, 13 Nov 2025 15:11:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26B9B8E0011; Thu, 13 Nov 2025 15:11:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1434E8E0003
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 15:11:33 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 815D11DE6C4
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 20:11:32 +0000 (UTC)
X-FDA: 84106678824.26.A506B4B
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	by imf07.hostedemail.com (Postfix) with ESMTP id 930C44000A
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 20:11:30 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=j4PGyJJS;
	spf=pass (imf07.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763064690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g1QxTrWXodWBMomxAbAxFA1n4YHk0BckspM2UrA+wSw=;
	b=1rjjyycnEMIOl+1/H6Ss7zFWDQRxEfC+yZxNq5moisEgNHC5SJzP84174XrZWbhDDWfLEj
	ufdDPkLPFTIshidalzPKgiKrQAgm0raRuj1h1gEV3F1iVRwY+eq945k8smIaCmhWWHimaj
	KqV447b3+lCsQl/VZG2cf4vbXP4NQCw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763064690; a=rsa-sha256;
	cv=none;
	b=Wh8S0X+MGZEqlAaCF1RdKCa9Jmy5LlOOjtnJYhZifOPjaOUapHrhFk3cLux0BYxakFOWcw
	PkRy3kixwLZWSPVMFh0Mqv5WSPV2cW22yagaIVXgU7BBkbKzi6LjGuGMFkaurjgRwBYneP
	FvuATWwlQ1oW2vHF0wI+c0eDQll96dk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=j4PGyJJS;
	spf=pass (imf07.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-64088c6b309so2143339a12.0
        for <linux-mm@kvack.org>; Thu, 13 Nov 2025 12:11:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763064689; x=1763669489; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=g1QxTrWXodWBMomxAbAxFA1n4YHk0BckspM2UrA+wSw=;
        b=j4PGyJJSdVyeJ+6b9EecU5Ib9tuXi/sedK7ZJCmrGdeuxjVRYbtW2snJpKgeczEIh5
         sZ79GZYn51m4c2w4T0fM2P5oTPghXrzFgyYPp9V+0hCxLK97QWKzjXDjqgTGTy77q6HQ
         dEF1QFe90YdaQ/NWGBwgRkrjytjufABzgT5lIoCuF7GZRIxKqqZjfEZvHMvSwC5lS4h2
         CR21NPiyvh7xMzD0YNNT5QQeLz/XPhbnnwXe+T66NmQbrXxKHwISw/L9cHCBDHBqKrhw
         BWpc64plbOSwvHY0rvAsYf+EQIMsXCaeBExhzu6tk02wGLMlOrpWSKyZU/xBh1tCJD5U
         JtxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763064689; x=1763669489;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g1QxTrWXodWBMomxAbAxFA1n4YHk0BckspM2UrA+wSw=;
        b=bn/9QXvO69Asl5Rt30JU/lP8b0svu1xM1X/P38Cr0EKpvxhUM/44tcgfcwdAvDfgQC
         MXSrWIDietASQGAVU4o7km2U0iQ0enTW2LJc/rNTOLd8VhbLZzdjCdwiqMpedj6jbpON
         Fc5pNxtWY0amcXfxZCIwkbpKiJPdRtJjgkQqnL3N1qxzSzHZUVYfj/SZIr5on/MPupK7
         cR3jTKA68wQcsnebJmHPCapFtT07m1IlMuHVVMFy1IUqxQp/jFsF6MHCIhSBFsWJ/BVM
         VJ+KTggVdKAhHwN/tOOfQvUgxkHOCaRLBYxVx7/H1x1SjIquzAflgxTHuWNHPgDjggGJ
         Siuw==
X-Forwarded-Encrypted: i=1; AJvYcCUZT9C3d+k+KNIVogtYdKQ7i3T5ZIE8o1d9bvqQZuZxQGF9VtRNcbmOaSiM8g68nF7gTyxsnqfa0Q==@kvack.org
X-Gm-Message-State: AOJu0YyKG7lXMVkCtacMwQniB4Mu4oNznuA/ocO+Chyl7+U8aCCSWnZp
	FeTcxfKY319/ps2BOVBcN4BDqFACBup+ALElpIxcRk+yXuOILMNurcBy77PVjk0gOACLkjavkVo
	LP5AsW05/5ASnaWr9Zjcp1zmj2gVq1HwEHUqSj59J9w==
X-Gm-Gg: ASbGncsZJm06tq7gCt+r9/UxS9OyUq/3M/N6TyDApWttsW9NmY6lDm5FNUGnJBA5mzd
	lB3tRtfIMSzf1ywDHq93vYdxVHaES3Br/xtEI13/whqdHmHixM4Cz2wJC2y4iQBmgeGXTBQzla9
	fxfzBa8bnLymTIm2iWgWBA5J2KbLYlWhIlr0VhXN5rvo13zlquH06VQiV14qtnEn/rBCNcLtSCp
	ZA3CTQVqwTdKEgFG0PKGZD3UnVTKFV6Dq576PxT2JH2mjCRy0UCbEvgpA==
X-Google-Smtp-Source: AGHT+IFqOOzcW34Qt5BtLWZl2weqcPZ4vSKaEdo/r8Kg1aP22Cs7VB3g26OtE+gc5XTlHx+GtBN4rDcQMAuYp8I/OQ4=
X-Received: by 2002:a05:6402:4543:b0:640:ebca:e680 with SMTP id
 4fb4d7f45d1cf-64350ec0940mr319721a12.37.1763064689030; Thu, 13 Nov 2025
 12:11:29 -0800 (PST)
MIME-Version: 1.0
References: <20251101142325.1326536-1-pasha.tatashin@soleen.com>
 <20251101142325.1326536-2-pasha.tatashin@soleen.com> <d7651272-f979-4972-ae41-bab2faa8473a@linux.dev>
 <CA+CK2bDSvtuwrrXGOC07Rj42yGFHWR4Sse7Q5z1z8f1ZFHWQ2Q@mail.gmail.com>
 <CA+CK2bC_+repP-q183hjAuYYB2-Yx7fr_U3zr2cxysAWx5hzpg@mail.gmail.com>
 <029090cf-9a4d-4f79-b857-04c3ada83323@linux.dev> <CA+CK2bByYPJXSNOh6R3swqFrGsS02m3Dfh=ZU7YhNjNX6siyqg@mail.gmail.com>
 <442fa82e-16ef-4bde-84eb-743450222468@linux.dev> <mafs0qzu69gei.fsf@kernel.org>
 <CA+CK2bBEe16x0em1gRxQD3jhfV9t3QA2vx5ifk2pKb_WEoMTeg@mail.gmail.com>
 <0735e1ef-2b65-4a54-b4d5-964fb875cd09@linux.dev> <CA+CK2bBnnGyQ-N8-XS3W3tnSRwvFbstOdo0oDSdkF70KP1AVxw@mail.gmail.com>
 <9e144e21-a5e7-4c12-b8b0-07172787ab37@linux.dev>
In-Reply-To: <9e144e21-a5e7-4c12-b8b0-07172787ab37@linux.dev>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Thu, 13 Nov 2025 15:10:52 -0500
X-Gm-Features: AWmQ_blSG7On0GhlPsFoQI0cU4BjzgyhDv68bXpGIzhq4rnHTQGnsGUkDO_x7mo
Message-ID: <CA+CK2bBQxB7ihmhBa76vJbdD988B+8PBrV4arDSNqjv_VB4DVw@mail.gmail.com>
Subject: Re: [PATCH v9 1/9] kho: make debugfs interface optional
To: "Yanjun.Zhu" <yanjun.zhu@linux.dev>
Cc: Pratyush Yadav <pratyush@kernel.org>, akpm@linux-foundation.org, brauner@kernel.org, 
	corbet@lwn.net, graf@amazon.com, jgg@ziepe.ca, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, masahiroy@kernel.org, 
	ojeda@kernel.org, rdunlap@infradead.org, rppt@kernel.org, tj@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 930C44000A
X-Stat-Signature: sp7hjw6bhdi76kmeq7r1451j9jsy3jxs
X-Rspam-User: 
X-HE-Tag: 1763064690-907319
X-HE-Meta: U2FsdGVkX1/zaqFqnQG0gfBrjY+WvoN+M2HjqqCnmM+d19ItI9fRRgn+u26kouijzisAISF1X5Q2awUcxGfW+7KmV/XuxF3jbjEPIkerr9Y0whJrxqJuo8tiiCQdKa9xwcsz1s8YG7eOjz/w1iHDRQOpaK22rA8nhDuPTu0+kVFUgHRmJs5pBsv4qdupIfi8aiOki5wN5B7yG5CJssDqSbpGdWujRA54EimQY2Uw75bWnb8OkSMn5Ut+Xhy2gqq00zYUr/OYhh5emqVPKBauyZvCb/WQ7etaUYL3tyflueqEncVGEMzB5/Qgf09I5H181cFDP1WjUYJoiPczYBDbV3EH9FhlLcVX44Y4DWIICuSl3vxcN0CERtR9Ixxbgo2lnlQC8m4QyBpoorrJKi/Nl9XLsgjUamI4M1jYpNaV9MhvanqEi47/YE0avon17KUToS+YzcF30KnG58HgGoznHvzQxwaBWtDq7Bbr2fZ6wThKQHjleYcnZkojmr+3D+Usd7urAxzZ8AgGdeSSGmz51kGF4+dAbDIwQHcmTUrmY/K490511TGG+1H6LE2L/nq6lhx9f8Q5+FQIrOksBGNuVngHBxLPwZjiSxElUWWUv4UpwmhZ2PVep4nPDY7/hqq6lhnEXX1Z1kdWGHn7+S0jyPB4AJtdRZu/b+Opk4ce2MjK9iohAh4GBZnzjLymz3VgjVCz00/DrHSHRagfNHqbUzvdpjTmSvBrG8pp2qh4VEMf6lamyyRidMTuEVxFUfMeKcN/pFJVihN+KE8BsJf5w+wVeF3pFL0iSJsxIXizA0KH8Csjnlp7ap0xmQ9n8T7MVoHS9fGEniIN6OCQdU/JDZD1whmb7pQHid/eb3uhSKIDWonIMy/kgAMMgbFHY/ysvGCm3J2iyZgDmUwRZoIThhkG2p/p3Z1oJscmC4st2gyx9tOW5V+1JQ7lao0qSaTF8ScezieSoofW20RyQdX
 0BcI9FX4
 aTFJ3ilpdAHLKqaH2NrayTMsr059tPq2Daz6zY9o+WOvxK9sWYMlsaR0gLX8HLZjVWhiv4HoHgBdT8tHto8G+5RSZXcJre99Y9oy0dUgdi3wc1S4vrDohZ8f4hdRPW8M+9uCQhF/xnSZ9qFfxbWFCL84kk7Owazo+FZ5Oyq2HnzbXj5r30ZisbIDplnBlEIa0PVB4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>   set -e
>
> -kexec -l -s --reuse-cmdline /boot/bzImage
> +kexec -l -s --reuse-cmdline /boot/bzImage --initrd
> /boot/initramfs-`uname -r`.img

Thank you for your suggestion, in the next version, I am going to add
initramfs optionally, I am thinking to update script to something like
this:

#!/bin/sh
# SPDX-License-Identifier: GPL-2.0
set -e

# Use $KERNEL and $INITRAMFS to pass custom Kernel and optional initramfs

KERNEL="${KERNEL:-/boot/bzImage}"
set -- -l -s --reuse-cmdline "$KERNEL"

INITRAMFS="${INITRAMFS:-/boot/initramfs}"
if [ -f "$INITRAMFS" ]; then
    set -- "$@" --initrd="$INITRAMFS"
fi

kexec "$@"
kexec -e

