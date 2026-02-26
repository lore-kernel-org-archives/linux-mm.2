Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2BFCFD461E
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 05:22:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CD3C6B0088; Thu, 26 Feb 2026 00:22:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 950076B0089; Thu, 26 Feb 2026 00:22:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8318F6B008A; Thu, 26 Feb 2026 00:22:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6BD316B0088
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 00:22:41 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 18D33C2E3C
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 05:22:41 +0000 (UTC)
X-FDA: 84485462922.25.54BF226
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf06.hostedemail.com (Postfix) with ESMTP id 12B81180005
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 05:22:38 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gfsZadyW;
	spf=pass (imf06.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772083359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J3Xn/gWW36p48ewqFSbbJlWXO8yGfqmwyJ3x8B1Ls2U=;
	b=ss05MyVGS9cncbUqj6SkMKnWLyrzY3ZzX6jk+c+l8u7BGrV6nc14q1WM+DlCsdlB2DM5lo
	N1LcyuwhS83Xupd3F6MvfEYOe345rXVYYed9XjRXoHcM3ROGvH9XT73op5aMsjInHsjHu+
	zE/jUu0nQDSuBacshp+BqGcEngEqDcM=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772083359; a=rsa-sha256;
	cv=pass;
	b=XDeSOgJv44DfA1ZwAEJIk8X9hM4mIfwwwKXFbE7Ge7Ms8J93Ola3PuhDwySdi/XOCaWVPv
	5czqTzHeOYvKbNpnGp952dRWTaecAlMjQL6vEB+nlja6UdSg8wTvcB5mtktc8K8WawDDk2
	uwj5MgsFDwo1u6qCvKbhfyYg6ODHi8g=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gfsZadyW;
	spf=pass (imf06.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-5069b3e0c66so22708661cf.1
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 21:22:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772083358; cv=none;
        d=google.com; s=arc-20240605;
        b=dfTbTcLDO+ka+2/sRFq4W6Jtxz4GkIPvpT8cIZEGa8HuQtj6CIo+ygaA/zfNyMQNbK
         EpuF5PwMrDmCODdeQPt2q2nksI+H8BN5OpbnPojI7Yi8RLJPaP0dG+HJBEYNuGeVo2le
         vXl2ExS4l0t1uzLfuFJaOkKc+KMpYKzwlWYSeehEYubvhaP2E0GM+Xyq3PtfVegLl1e8
         /uCoiyfnh+ehqgD1IFwjCKmfKb89Ha0AiZGWie/L0znDXlUq3mpvHhjoERaL0MXPkJUQ
         hFirh8ZX+vqnVihj+6RH1mAnMmqqRD0wsSYfb+8Ifcz4XNjymjmd3uAuIwdlPBY2j3Jm
         0LTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=J3Xn/gWW36p48ewqFSbbJlWXO8yGfqmwyJ3x8B1Ls2U=;
        fh=CBJA9oTZQ+TFU77I1pk/rKC+1y8817C4vZBSgGfI480=;
        b=eDoaWxWMfJPq4O3JfMsErEN4bdnGmER81wxhvJRG97M5WU2l8NRqGL+MmYeSFjXSnS
         cAISxjxBqOWW+RFOjepo9XEpaFrzxFZZZlRp1RwfnIs6VPn67Aw0RzBftxOKduFPOjzf
         oT8zAIraNBJ3ATwxGqLN4npPR6AgfW4vbdHLekXuemUoeCeZO13ignUbC9KrBxYQD0Yt
         6oK2pWB9zyvmT+zNy0fPThFCmA9NJIjTA+ncqTS8Y9Fz+hq8UT35hrwgsC8NRTDrHNfJ
         bh1nqC91iu3/mIEuTRtrBxpwZwb9/PensJMbLEKvMihZ4dNEfPU3CYqEE04lOXDIMJSA
         l42g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772083358; x=1772688158; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J3Xn/gWW36p48ewqFSbbJlWXO8yGfqmwyJ3x8B1Ls2U=;
        b=gfsZadyWyjQ6xZb5PNvykSge09J/JiRCqew4dBV1WDDiXdiC8wB3YGvvFcSagNSxIs
         UR0j9wScUXchUl9WWbk2b2VgqfTdgcgOhenplB+sh+7Umpyd7i7lLiq7dL7k8Pqa17wA
         89PzI7YBngkTxqsdYiEADyVK9wiDNf79M/9148qWzuWbZrkpG9Iwetd/vrlHfPCNrrh/
         UISMZF+hBxEitbGOxXS6NvIeRDESAdq9gzynPyag/XsDqGf7d2c4ahXDueRKilqwVlde
         vFagHDcxybDbRfbKVal/3ZfOiNtNFCn+E6miVoNNeHwiTM9knzM7C8a+WLAHr3G7PyE3
         9cqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772083358; x=1772688158;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=J3Xn/gWW36p48ewqFSbbJlWXO8yGfqmwyJ3x8B1Ls2U=;
        b=c+VGmjQPJFeHxBe3Q5ZSn5GSsZbqiYaZwWup351MgE7ye7SkYcopBZwT1KarUBR7GN
         OOatHhalVG92f/mHQ5qVdWJqjbY+b/7Nw5pdDTwb/sPfP/LjF6YP5S2wKdah/0SnvtOz
         CvqV7IIK8ylqr+KEE/frVApXfZPqUwBTLEFCLI8LkoBKoOuAp+4W0IxnwxJ+RwGPYTTQ
         vYodUVPbnqz/rjpj9UuOVPGyDtHeaoh6CQuFfTo2xEkghlLtfoSmliHdEtStNd3A/FMs
         2gcHZ9EOI61QQi/eu5EIlA2Zz7S9P3glIq87MlND47mbZxzLPPWUojhrOpLrBQZN4jaa
         NQeQ==
X-Forwarded-Encrypted: i=1; AJvYcCVSF/b1lQd/+NptjrMTccsZcHfwZSsAkPNJL9hhVpPAFH7Y57obUisTEv7lrdNhcrbfmkCRz5ZDHg==@kvack.org
X-Gm-Message-State: AOJu0YwOvvvUVbxAkJ2yTqDA24avOV19Y8+Z/6UNnD6oBYn4ROpz53kB
	PjwNvK4Jk2PIeOPSFz//SHRSYLNFbGdrxf3I5Kvy0tyVtR4z4Ozy+HQSYvHCXHDOLx02Lf/+m22
	VRZcPFB+3Mqm4W2Xv3R+3CWRKrU0VdX4=
X-Gm-Gg: ATEYQzwdUlfA9E+XsPniSJbVmh/9noUfyOCyJK/lylv74FbqZ3GYfPLNlJh7QTwOYAI
	WicUnE+kYQhKkm2FyS1xjcsZOuGJXAzl6PDvWsdMfV4mDhVArKaewe8wcSrIsz8O5HUN0LYppG6
	FpavvXwOf5/ESs1JpF/770j0SxQVuovlUhnpGHLBEj3hIN+tVe4UFvDn4MneRsrsVhCQmgGPbB2
	/IORYcEQvCmjTehCgwiqGDO5aR/6NXW3M30gZgkGYPnSKqWM3zRaehb1nOGajQJK5QXZZcViYBo
	o11/Mg==
X-Received: by 2002:ac8:57c1:0:b0:4f1:c601:3ca4 with SMTP id
 d75a77b69052e-50744430078mr20149961cf.32.1772083357864; Wed, 25 Feb 2026
 21:22:37 -0800 (PST)
MIME-Version: 1.0
References: <20260226010739.3773838-1-youngjun.park@lge.com>
In-Reply-To: <20260226010739.3773838-1-youngjun.park@lge.com>
From: Barry Song <21cnbao@gmail.com>
Date: Thu, 26 Feb 2026 13:22:26 +0800
X-Gm-Features: AaiRm51ZAuX05JRJ9EY-dZAx9ziDiaJ0X1DP5CVBf3Ia-vqwqnJ7yhQL52xV7mw
Message-ID: <CAGsJ_4zEWVYtyj2TR_Rc56gjpz6BDP2rjrcGLva6kgNCxs9tuA@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: Add myself as reviewer for SWAP
To: Youngjun Park <youngjun.park@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 12B81180005
X-Stat-Signature: 3somrc7wujm3i1ah9dbkb4hf8gxwjbu6
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1772083358-45758
X-HE-Meta: U2FsdGVkX19GL50GUN4zSU/O/Y4saKFKQ7E3fOey1RhDnVAQc/tPpgSuiSO3VajAUKn+X4tnpMQcd0BtOmhx7PyDwC9bH5CmQ3Gd99tQxXyb4z5l0jEiXL7p7de7fHu50wA252MQHOX7h1Ud5ojgozxfR51oWAYLdfThe+8CFy2qpzsmjCUt74JGz/fsYB2xdzAu+Qv/39+hBhH18FhmJDskyA5Jgfjx0t1HxzQOzzs9TFlUCySaYf3P21bevl0x4Z5MTm5wLhDSvAUf+44xBC/LW9QDyxj1CU2nAJvH4of0C9owZ+D//AaSILZi+WP4/TlKPVkTwrdRVxyh3AvFUGxLkRbhurZIZY85YbusUKw850Y8Reflqr2LbYl/x6YrP52xCgm6IePBsHxqj9DgxBHNKa1F9Zye6fstPFHuV6p3gK/BxsnlZ6Eb6sdLlm8OdAKX5FlT4N+WmpuRkeJUhYdbxXQObvwotNRVDiFLevuCX1RwXIWj1dIJ0anV61zG70LpOAPKCkvRsntfai4GOJ/qkWdCTpuZ0D9nt/nbIUmvYI89/nVTLsyJ/d8KwhEK3trdhGKKL9Tx8gShb3sReVRzcHR62rK4bsIP+2Q4+eBzEDLwpbLK+g9gxvk7YEcLvYPnEre4GhL/Z88gRSURihdNcVwbcAx1SHEuGUpH1tJbSvB3WNVwHAjuUSJW6nkneTqa/dwRUrnrpikstemIMQp5mxNUpH7vUSIH4/2kP7jqnE0vniQR2fNh7CB93izgzX+ffDN6dPcObPFm0eSrvMbN0qaMwAPOTstqu8haVFvEz9EVzbnNDFJkWvrUnI1JDS0CyK8FBDSJmHyKv4oWULVjhEpOjF0j844tjEOTgTMsTeEMoV9GtucU4GjOL4LN/iDR5w26IS2BMN0CWzITyOVomnRkkvGPc9QhSXB4IGJrWwhDWg+9NMZwtk4MEcE76s6kJxVXU+RGYUZZtYs
 3R+psjR+
 vGTMFacVBYhlUVrw12EpoArfYxEbhE6+K+RGuyeWLdAfE2qqk6NRB0yXAL82QJSmUKTDCFdYyLSH9EtgxNr5Q5ojoswNV9NE49VZEOERdEdw9N7mFg2H/5ahU22qgJM47VVjyDU3YNX3ES6gaVlba27kApKKXcfsYU5wFy+OUoFoWRrH2ny7dHuS7/D8TpjEZaOI2dXcjv2f1wrWXtwaFmi1YkmTWTnvM2No8AVfmg/nx+czZi7ko3v8OHcedEIyWiBf14kycuZ6fXP85NlUEXbWv5rPGRsBOFbbFjebNwtRjqP0MrB82u20RyAiEFo9OQ3YWZ52XkExfoAtlni5ZyBM9YUAEJdXvg5ZpNe3lrAN1106ycG9RwpC2TSu5G4SdpNjf3e5Oh7tW8m93+aU1zU0tjBN6mqKO0ke3bwZCqwVMLV4B/FYTZOXBK7GxrzjsBcx1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 26, 2026 at 9:08=E2=80=AFAM Youngjun Park <youngjun.park@lge.co=
m> wrote:
>
> Recently, I have been actively contributing to the swap subsystem through
> works such as swap-tier patches and flash friendly swap proposal. During =
this
> process, I have consistently reviewed swap table code, some other patches=
 and fixed several
> bugs.
>
> As I am already CC'd on many patches and maintaining active interest in
> ongoing developments, I would like to officially add myself as a reviewer=
.
> I am committed to contributing to the kernel community with greater
> responsibility.
>
> Signed-off-by: Youngjun Park <youngjun.park@lge.com>

This is very welcome.
Reviewed-by: Barry Song <baohua@kernel.org>

Best Regards
Barry

