Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6E8ACD3440
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 18:38:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E79888E0006; Wed, 12 Nov 2025 13:38:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E51E38E0002; Wed, 12 Nov 2025 13:38:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8E768E0006; Wed, 12 Nov 2025 13:38:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C992D8E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 13:38:38 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6E38612DE3D
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 18:38:38 +0000 (UTC)
X-FDA: 84102815916.02.2CA84E3
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8F41540013
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 18:38:36 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hDNYHmUw;
	spf=pass (imf04.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762972716;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d+G8+iIuAhEgULEzocPDssGo8BH46zvY9bxVPTxi2Vs=;
	b=5+iKAJgycvKbjFCMwr7/+kJ8Ev77A/eZHV1Cie0NT/bYVKSHxrL7cRTeH6eFDv6fFRGol9
	9ihxMT+IwgvO/aEN1rWwaOzVfdNYzlmzMdVmN6HFe2x9xkTWcgVXIxuVfDCC8h3do+ILW8
	/NKgF4QvKPymrauvAsHqX+vpkDGmvGM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hDNYHmUw;
	spf=pass (imf04.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762972716; a=rsa-sha256;
	cv=none;
	b=UknlrRhO6GwUJv90UVh/7cK0RN7nUAKdyxVEDlqq++TrUz2NfqmTMRkzlNjRiSftoeDrKh
	bBIYG+vmQ17FMrbZ9D/ZbKr2pihdAn2e5XnPwZVWc+4mPicLecTcCbg0x18jWJaUweXJEw
	Ll8sqsMnb7xwX1E74NGKjlv2ZBDBMyM=
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-7b4933bc4bbso1034650b3a.1
        for <linux-mm@kvack.org>; Wed, 12 Nov 2025 10:38:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762972715; x=1763577515; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=d+G8+iIuAhEgULEzocPDssGo8BH46zvY9bxVPTxi2Vs=;
        b=hDNYHmUwo2Z8bXRwHbLFoRmoSfhmJmdnghbi4qcu7Q7De98Sd536tTDDWAkFrYlSAB
         9kNs1ERA2sHZ7E8G+kedQ47IqUV4Ws1CU80s1Kn9yVUGd8KcLmac/cjPcVFNC/kELpso
         xnM29z1amTE6idCoPgRg5Xto34acBhyGSDM3WmArqVKv00cSzpthCAB0Zmlk9eCAF6Sg
         h2QKfmGJRJkpHMfU1SVhRbeHO+Vx6qKbBrnewulEOIP+WBvMBlKD90X5cK1cldgedV95
         6+mU4Ofe+a5DJnlZi1TdSaT8hyp0gQKjZEobzsWcJGf3MPnAO5zHIXMBqgsLCAybF6q4
         HVCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762972715; x=1763577515;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d+G8+iIuAhEgULEzocPDssGo8BH46zvY9bxVPTxi2Vs=;
        b=sGGKVJukmihMzvX1hnzTkAIRyiq67UNDgrX5szB7JFf3f9ujJXrRbPfUw523WRxg9b
         UzUlF41iyUp7PppV/gEf3jgfVSnckylyyxRpcMjvkg8M9Aj11IMy8RYTi4HAST4e13P3
         3MLmIj2NmQQwK3hiwXQNpBRIpcsxktOHIsmZKaVjhF8KfC05dnnjtXIuv972Fzhzroc5
         Y0I9sPn3KE9U0FIuTdQ0l3s6CHff5cJKMIJKvHIAjUb80pYoQzY6fmcTGidDI6JOUjg4
         Ah3hUoGlBPXLXaENY9EmIbewHRJkWotO8uD4JJ8RfsePmKVPFIb/CwDGMiYBVClNEYIk
         uqXw==
X-Forwarded-Encrypted: i=1; AJvYcCUpDXyGxgyxU+sduj2jFvUJm34vFvkXFYtYYWnHg2H1CQO5XkhNbpWAQ9HRffGte/1j3PhXq9f7Rg==@kvack.org
X-Gm-Message-State: AOJu0YzLbSAPOm0xrv4nfgEfNn+N0qUCSJ9sGZHfusM9c1Y5R5Ua9rCH
	8M2yC4H6o7ieBw6Fb1C/3SzE0z8ekzVpuZw2wckWQ2ylwJ2NxVChdwm5
X-Gm-Gg: ASbGncsQjfrSlDYlFhqbHKDxlYaQu5g6dR2LiVEGeHDetrW/RUfdx8w+oL/pcNzo4pX
	8blUDpUwiQTRyDfJQsgBvI+gY6plkQqCnhSA3C8m+qSQAKMDUBFokjGM4D7vDt3bcLKTHgExYjp
	IhojZrHd0REAWpG+lEnV7dpog4g635H4Bdj2G3zcwhfLFz/4A+6kOg90V92C1hzhocPm+63YZ0c
	Z6mwjSLtvThSytiAYuWiCnZhY5IKuGtr12Tc4jCZfsFXNLTCIJwRFrX614MzK5Za5DKwrH+dMqU
	gP3HyxsQkjEc1yQ52KFyjx0pcJwx0xzfSdZh5x0W5NlI+8TRs0iHCzl6qGNFSKYwSJ/lDOw3k3B
	SEo0gOBvnw4neQlI4lnSxbGKJseUekLRH+8NzEPgFS8ew3Bz0bkOFYwcGk1/fEYhSqJwr949hTZ
	YrtWyNIyhTdipfQ9g1e9ON1Y1ILIIif6Y2
X-Google-Smtp-Source: AGHT+IHkCPrM3gjJlcuUw/ai+5zW7z604YwPQxNzYFX5718wDwKJoqe+bSM0awd32yJLRzmocpTJQg==
X-Received: by 2002:aa7:88d6:0:b0:7a2:7f45:5898 with SMTP id d2e1a72fcca58-7b8e01e21a5mr455797b3a.3.1762972715085;
        Wed, 12 Nov 2025 10:38:35 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7b0cc17a956sm19641876b3a.44.2025.11.12.10.38.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 10:38:34 -0800 (PST)
Date: Wed, 12 Nov 2025 10:38:32 -0800
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Uladzislau Rezki <urezki@gmail.com>
Cc: syzbot ci <syzbot+ci9989da8336cb2bc7@syzkaller.appspotmail.com>,
	akpm@linux-foundation.org, hch@lst.de, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, syzbot@lists.linux.dev,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot ci] Re: make vmalloc gfp flags usage more apparent
Message-ID: <aRTUKDMa8avHdvKp@fedora>
References: <20251110160457.61791-1-vishal.moola@gmail.com>
 <69123b72.a70a0220.22f260.0105.GAE@google.com>
 <aROasppMPmek9Afh@milan>
 <aRQyMck_MeVvvCdX@infradead.org>
 <aRR3O7l2Ewx-VRoE@milan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aRR3O7l2Ewx-VRoE@milan>
X-Rspamd-Queue-Id: 8F41540013
X-Stat-Signature: swbi77qrbkq7jcrdy5kaxmj4u9mokc6i
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762972716-246397
X-HE-Meta: U2FsdGVkX18O4XexwnXcmUFWO8xn37MmEIqRWpJvdQS1YI0pnGhY+Z0+nD3q/IpmwX4XvgXAMBDCt+byiPH8cZ2nylAa7tSuChVesQaXRU1Cnlajcx2rJy+fViFps7LOzzgat41dR42Fn/7hZyZROsYkHQZLA+4QLs8IYE0RwbSIrbsc5qawgQnjnS+LapQegMrCVHlm2mVfbgeWKQHghoO1UeN9wKoYA7e/F8Fp6GbcdHru4QIuJzDoT7gCu7/eQJf+YTkB2wExaKwEtfIptsysQEzHb/ywmc9lip75cYCkHhRtfL4Rb3HLtQEwksQfms4L2xuaUjsQqB4oeZM+p72AZiKGJEHecpFDFHULupcDHKBGLW9tOTd+2pFHSf0q7knQA1Tu7fvR9bdp0T4jAPGpkTDd0ftkFazYw80WfujBEJz4Y8L0V5Yv+lLNXdmK9MpMnSuJTparm6OdqmoTqmUdgAg72s4KjzLBcU9RR/lY4JvJ1w6RRfGEml2M2AuB76M+Kinl5AillgVEgP+o9QxSYhEkI9B/lENIlFCGh1k0NjgxwW4WHUr4oiGRx3+JY4t0ut9a8kah4w/0OynUTztuaUVDpyhJCo6ePZhX/scUl1vfKBN/L3MHXuNskcMPnSuAlnQPOLz/EG8blec0etvbqVqGgINlQG781pHuHpUlCix3T88Vj8uq6XTpbQmE2KluloIiqPA5GeGMP/wAkhoRHrnVgiAUhKb/0kF6tcXCM4Ho5ahkfcQDtn8rgI00b2agBZQMiyoRwV0wTozqx+8he0/c1aog33/zvdNxZxICqyajxjKa8JiJY41lSp5PeiOGgQrE3tIpnMRbXbJUi+RBsOZ16j+NXiqJOrpLm7pQaxD2SwX+B79ceYwa7w78JMt7pi+Aco0fDwPByhTUNwVdsfg4wwuf7IagfhxDxV8yNHunQoUL/m6/XKWpYIy7Szmu25HnDqO7XO/8qY+
 7cTVVegh
 4CLNBGeLW0Wq7/2McEo1UxdsE1GTKIGkh+3auPp2kJUWev8qhwCRQcW79+lBd917HMrU1MNIBQ5NTjcl+j/lF2CA0llPeJRibM8Tx1dVYZ1AIY68e2uDjJBT/0eWomFeldVrsB4AaD1AfaAVH6sD2v4VmBJvRgUW+xLxMtxzhOTVYzJaU/MlkuvedSobAhG09HLZ3pARuyuQI8X80PELXE4dBYLSiiKLBM9U0XkzypFN9umfW+03AwdmuuXIXSNoG2BL7Wus4ALf5eSty7oo57MmIwrP6ydoroWEQAhcPjnDUkgRd+hSPVeWIDSmxl/5o2DMZcJ/GihMQXcBMi8BK2000jnb5TgPrXtfdxxOjaV+mrFdvyUQFx9Lo/Gu5lYHsX2ormsqHxLF1p9I95DWgj/5lQlqQ4CY4bbB5ORFXC99J0oNUHdpESEuKPVSRd6FmJD3ni4AFK2Qhdye1opW4okMy0KCoJwESRchKBL262RZ7eekN4eCLGvajL5N44PGiopXWxO5X+z2z6OxQPu67ZxK947DogHUpfzzm8evqkXgkddxpiffY2EbJ3g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 12, 2025 at 01:02:03PM +0100, Uladzislau Rezki wrote:
> On Tue, Nov 11, 2025 at 11:07:29PM -0800, Christoph Hellwig wrote:
> > On Tue, Nov 11, 2025 at 09:21:06PM +0100, Uladzislau Rezki wrote:
> > > > Unexpected gfp: 0x100000 (__GFP_HARDWALL). Fixing up to gfp: 0xdc0 (GFP_KERNEL|__GFP_ZERO). Fix your code!
> > > >
> > > It looks like we need to add __GFP_HARDWALL to the white-list-mask.
> > 
> > __GFP_HARDWALL is part of GFP_USER.  Doing GFP_USER vmalloc sounds like
> > a bit of an odd idea to me, but there are a few users mostly in bpf
> > and drm code (why do these always show up for odd API usage patterns?).
> > 
> > So I guess yes, we'll need to allow it for now, but I'd like to start
> > a discussion if it really makes much sense.
> > 
> <snip>
> 	/* plain bpf_prog allocation */
> 	prog = bpf_prog_alloc(bpf_prog_size(attr->insn_cnt), GFP_USER);
> 	if (!prog) {
> <snip>
> 
> I assume that was the place that triggered the splat.
> 
> Vishal, will you send the patch adding GFP_USER to address the splat?

Yes, I'll send a new version including __GFP_HARDWALL in the mask and
update the comment accordingly.

