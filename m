Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43E76CD13D3
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 17:17:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 799D86B0088; Thu, 30 Apr 2026 13:17:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74CD86B008A; Thu, 30 Apr 2026 13:17:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 660D46B008C; Thu, 30 Apr 2026 13:17:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5739E6B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 13:17:55 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D638A1601B6
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 17:17:54 +0000 (UTC)
X-FDA: 84715879668.24.7AF82D7
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6BD6A4000D
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 17:17:52 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Em+EeYYJ;
	spf=pass (imf12.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777569472;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ERNXVyDvvdjB/y52CiMZ1JT+Mz59b+WRrRXJvJ9Eofc=;
	b=SMmRWDhGmUN/HX2CL6bUwAfSKRFCj08eNi188XIbzVBwlyUxb3Q8pWoB4/WdJalAHmoy5h
	tf8S9pc8vOna+UtUyuCLhIRox1aiIpXtBYx9XsuTYB7B5E1KL1MjSZkhSAHRhvlpb3iWXt
	AqwWrqHkfHg802xyIY3PWS/MdvoTSac=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Em+EeYYJ;
	spf=pass (imf12.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777569472; a=rsa-sha256;
	cv=pass;
	b=Q8D3WeBon5HG6TgU0nIJFroFST8jCg9gODh0+rGEMqTjmm3S2mcbXYf7IheIPuJSF27ruA
	f2HeOJD43nVEdp7EB8EArjgArJ+Lvg4FVkqQ/MzuXIVNJ87JKBvYgSgp23NgsZx5AZMjCe
	f3nptK59BHnZ1l+1/gmLpRLeet3I2Eo=
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-50d6b393d60so34211cf.0
        for <linux-mm@kvack.org>; Thu, 30 Apr 2026 10:17:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777569471; cv=none;
        d=google.com; s=arc-20240605;
        b=YHxutcef4iDcoj39hIp9YU1S7JIlRyZJ3leS3izYGnMHSBfosY+H4F83vhTOZhfqG2
         0wX812sTlHvWyfl6NNEZbqJQJOyYyRAjQSFhBkg79ATsSWoiKiMeSTK+pJH90xXffw8E
         RFIE2Xu7doVnAz7Bj5ngDPtXypul0vulrtpf71m9NPq3gjrNyGTtFOG+e7SP4PAlDeAY
         5l/Fhh+XVrVCmwwMj7SgdbSlo0AlGIOZhGCM+Yw2yWLOFIhm+KyPHJNhyE+OOmWwo4gL
         QbywwIwZHCUCGIUcIvYYGJW9jwpZ1UN3BhRayKzmWESKcLdyKFTANtgPgUFEq8bULkqG
         /CHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ERNXVyDvvdjB/y52CiMZ1JT+Mz59b+WRrRXJvJ9Eofc=;
        fh=I63hLfFsQuSBCsJHisif2EMUJnb8GP6eVTb5mN36J7Q=;
        b=VMK/2pJ2EMY9allxKlj73jArAgg2l74jiDPuxP22AFCCPQiKJ7jrOvZ7C4WEsMaw5N
         MaMyNwhnpWUOEovpzKe4zIDxS6I/jdhZCJQF1m21ke79tMq+501a9ov+pw9gTC2vsYJn
         l1pdWAISriqcllgZGheHr8+PPedZH38lbM3rgk7eA0s/tLlu44LFPpeoEuOXxjyyVVaj
         LyxcF1Pa5Ne+YQQCtuCSHzoD8y1HONhFhNLdtxvJeg9PoiQEvhKxbTe+nY1coXFjKDhL
         iI3+bKJeTL4h46CqYcDkh2GHu6/vwAPgK4ptjQ2wGHoWb2NcAkqQjRSnHRl65SSaM2M6
         d0+g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777569471; x=1778174271; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ERNXVyDvvdjB/y52CiMZ1JT+Mz59b+WRrRXJvJ9Eofc=;
        b=Em+EeYYJZQqlUVDHkJPYH5HK7z0w6Cn+N/fgU4Oj+esU/ivYu4OdsQ7JAN2cYom7Fc
         9yQI638YNM4I99Ofu69C5NkYbRvHU2M+tGqRbG0Je4e7P6Rv5B+fI1CPJZv4FxSu/Pra
         37ztMgIrMOv/2athbV8bvvwyCXWL1bsUWEsi7HY8z4u07KxvkYrWS0jYKHvghCdxzcmw
         x/YqSlVBg5RwxG00rV4VRjhClLHy4i5mAxudn03xpYH5gkjWseDpPxwW7nz+G4v7O6or
         2OgxHKe0Us+z32cQg1mLRPx3/SByk0igVa4/JzFO+/e0aDWfL3pRpEImUOMeoZkmkcCX
         ieUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777569471; x=1778174271;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ERNXVyDvvdjB/y52CiMZ1JT+Mz59b+WRrRXJvJ9Eofc=;
        b=JNiqNpQ2lqMB0Rf3l5Dg8FanV36umDDtrG8DLItlIazzn+shX8tGVDRhTwuLU6veuo
         TelAggunRVS8NtlraSfkWdHlOfUM30NnLTOtjQZswx67PUXppK7mSzYeG8jGPebIb2r6
         s6QM93wlNrpgqlNWF2BQ7ybjoE1qbiEsPzlbOPpt3Wjuje1IWXDDkT68EQy9MFiYkzwp
         ZewobO3/NVDnFqHFsMXmt86DKv9bw8FZ1EBbN45lDVYh46Ec2e8MaRj+Oa1z/gqTaHok
         cM08tnvpSYuNpFf1mn7F1VZuk0EeNSlZ9uFgW2H0+l6UF9dSXyLsQhe7f/Jks/HACs0j
         LFUA==
X-Forwarded-Encrypted: i=1; AFNElJ//H7jx67a14qatVdJYZzKUjC3OrxrfyDJ6gnkWcaXcw9N9qCUSFvtqefcrlGri1qZ5ZYxAb8bbqg==@kvack.org
X-Gm-Message-State: AOJu0YwFwZCBhvvlfuz1RA152PUVgzFinGFuv1lQoEniOyMM0YAvJYRr
	mWATI0k3B9tO65SVPLuqUZQLhQXyGedjAc8cce2a2FPMxX/NqWvoF1W7XGIIDbPYwh55U26zY9Z
	AQoP+PYCM1kc13RN74+XsX7ctM14fFkdzZmyKD63h
X-Gm-Gg: AeBDieukrr9UdR5dCJboOS/jeIra4idHP0o7fzdpE+8Nb6iV0xOKki2bb+nP9AYtStO
	DHdP5AszmLEF7gPk90M0ERUkyDFJ6PcfY3eLW55MnZC1e2NvJ1BRB2ZaD+suVSfHfZPfFk/tgw6
	S17AB67a/ph9sB2ooCkFE78N6wgZqKUh2wMKiP+w8T7OrL3PIOWTXBy8dOzUAcTaCNNbML/f4M0
	48ZfJI465cPguShk2C1/ccSxhiPv6HV1IX1fx9qxfguCv6PzNWfq6G6yl6/9J7g3kQVfDsN6qAl
	xkri0HplbhkxJqXX1gS+xs/M9yd5XthbLRS9MPZJ2P8C1ApdmNNL/zRT7Bo=
X-Received: by 2002:a05:622a:aa06:10b0:50d:edb1:6bd1 with SMTP id
 d75a77b69052e-5103d3bff9emr7701cf.13.1777569470571; Thu, 30 Apr 2026 10:17:50
 -0700 (PDT)
MIME-Version: 1.0
References: <20260429181954.F50224AE@davehans-spike.ostc.intel.com>
 <3ce3f304-12bf-4e1f-b85c-11fa5832a0e5@intel.com> <afMOmZ2FjAPQ_0ug@lucifer>
In-Reply-To: <afMOmZ2FjAPQ_0ug@lucifer>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 30 Apr 2026 10:17:39 -0700
X-Gm-Features: AVHnY4KXVESitPZjVUC0UUUVb5Q9D8GlbIClFxRqJjjjioyCwWKOSk_hVnR447w
Message-ID: <CAJuCfpEF8VTAErMPCLnv-y5Hzo0JBpGs=L_dNfb=5C3enp2_dw@mail.gmail.com>
Subject: Re: [PATCH 0/6] mm: Make per-VMA locks available in all builds
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Dave Hansen <dave.hansen@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-mm@kvack.org, 
	Shakeel Butt <shakeel.butt@linux.dev>, Vlastimil Babka <vbabka@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: hqcw7n9aujigjnk3tuna79s7poyaqfbu
X-Rspamd-Queue-Id: 6BD6A4000D
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777569472-606750
X-HE-Meta: U2FsdGVkX1+3v3O6vFjvaFd6EcpgF6VX1B3o/ydIAs2Grtt9r7HO1tT7TBP3XnkNNVVIk5uGCablWlTHXvCQKXSQOeh4yydjldO8zvJ5iWWbfBAm8VNx1kjghVrm0wyDlH9Fr6pFxmagX4fkFFWYZHvkhMpiJZilImKGrtRBrZlEyKS8adlH3FIHFIg20yj0KpLwc+qO5NDT2vOqz6bwu2lPQo9p83Xy8RnEcs9XwA/dGXsYKamfmjogsFajuaKBS2Jgu2lhwXOjVHMnoQLYm+f2noaARcEcESKr+RW5CbQQ9kiuQo/jCPwyhJhsIuQ9+zUtn2anAZ7gPDFQyI5S953u4DARXYax2wCYVVFcJTWzVdFunahkg3D8v7yfrLPkSKEyiOebahApmNIV35LtcLfGr8KS2OmWQ0hf4Ss8bl+dC5YU3G8KsyHFcEtUgpfDGTgMoTy5Z3jPDX81+SpvTI2Y6ocRFzNL271i0P+cgZgwlTV1FbYV21v0SCJcw8Cima7r4l2MGSzBZv/6mzXt8SRLu9FueApX/nmoN8Zloees/TWZwU4YvMLvg16mhT4QLEY9f+L6jsWDFva0J4Wxc4Xg/ifUI6mL+sRPXFOzAEKDbMIOguv1u8caX+IMzUSo6Hf4Yr0o9TNtwET2EQnDlkbYk+3WHEHUyHbMug52qrCEUwDiraQRSHzgzU11Bhv9Nqa9VrqGWiC8sIPX9Z+4nB5x9lZEfwaf1hVQTzykuYXR2tpAecCJvje432WPin4cjzi/aXx0KiQpQIZR6ht0bGAOUUDFeUFQgEtJz4cznRTCWTnSPP+l7accUKyst1NydGgQXO//Lrzwf2RP1F29+MU+GzcsdzJb7GmSbz/S+dV+rnfzBSCKYgIW03X0HLrtWnh6Rd/xfxDv/HBbR8jjTe9+GB5plsmvOjLrYqrxUeBinZy/hnYPBy4zSGkkoEwYZs08pPgVqo5VdWbLfJS
 bIXKKaaW
 +fCXJu3HCVyYdDzXbfdYf9Kyoa3AOcNbGOnD/tFY2v8c5bE3/tDYAoHe4Zs1pDdUKSYXCrZ9i8eKX9kOZEHxQdaumlYcipf8WqX83wXtC1nXyPKY8XNY1oEFDFHxP14uZFIX0iAWW+M4zxkbPFUZENkS5lWU1t1qIMJ5sQfwXSTU0uF74gTTgem1EAljJ/V7dRiDfdemO2Nfhhi7lnHgkSLSD17SRxQucxhBYwDK3mLG15Gj1muYUa5dSuZyOyV6CyCd4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 30, 2026 at 1:11=E2=80=AFAM Lorenzo Stoakes <ljs@kernel.org> wr=
ote:
>
> On Wed, Apr 29, 2026 at 11:22:28AM -0700, Dave Hansen wrote:
> > BTW, this is *ENTIRELY* an [RFC]. It's just not tagged properly.
>
> Was going to say :)
>
> Not going to be able to get to this until after LSF... :) Likely the same=
 for
> Suren also.

Yeah, sorry. Trying to wrap up all the urgent stuff before the trip. I
might be able to review the patches later this week before the
conference starts, but can't promise.
Thanks,
Suren.

>
> Cheers, Lorenzo

