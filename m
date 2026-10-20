Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A2D8606A33E
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 03:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=enk7HOK9
Received: by kanga.kvack.org (Postfix)
	id 84DD66B03F5; Mon, 19 Oct 2026 23:04:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FE9F6B03F6; Mon, 19 Oct 2026 23:04:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6ED006B03F7; Mon, 19 Oct 2026 23:04:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4131B6B03F5
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 23:04:18 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B225D1608B3
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 03:04:17 +0000 (UTC)
X-FDA: 85341510954.14.59CABCE
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	by imf10.hostedemail.com (Postfix) with ESMTP id D490EC0003
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 03:04:15 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=enk7HOK9;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.182 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792465455;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FvpcUWOMJRPh8Fi2Ngt6U54Np2NRjnE0G0LmqIgTo0M=;
	b=sidfxJpr8rk5RMheh49FDjpklXncRNWsyJlQ97BGGtNzoz49oYWRobM3r62JPAwYIO1Xw3
	/jL1pJ9oq0kvgWPzhEo1+8lClG2CSChkRBmjrwZ8TpKtuiWzPLKrSrcCLruyqDYQVcRcR7
	KgL2dH9jgxs3NwyZyLbmELMIUXcfpbA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=enk7HOK9;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.182 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792465455;
	b=TeUfb6oPdBjPyYkGjkPz2o8Ya2Fh6HSOOir2sJA8vSRolSAY1yFTjI6t9yvDgetfD+J8D0
	dSts5OktesEunagNZ0zfHi8JhE8I4SW17K1v2cHDBUwgQPN49ysNmPA1sOZvx68kFYxOGE
	l2chWF28gzXQkWOzeTbyAGc5vFylXJM=
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-93e4c00d71aso258898085a.3
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 20:04:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792465455; x=1793070255; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FvpcUWOMJRPh8Fi2Ngt6U54Np2NRjnE0G0LmqIgTo0M=;
        b=enk7HOK9sU7ZO/ISRaa9g4EZXMBYOi40vmYGyCZSypKygEi9Ty/LLD8aIV67hCBiel
         tFr5fn5TuVU2uscAu8nXmYEEOAsd0b0W504gU1FZgfqWSTz/Fb5nujskZpr1jqnUvb9S
         B15/QiCXHSexrH2/6Oha9pCkLCbNwrZrHEH3h+1QD0RPNCUnHxMfPRwjrGz6p8eqYG6P
         3W+XKMV7iMMVh6MRqMDFVfb/khn/RqIwx78nbSzEWHcrE1Jt666T8P/CG9/k4945zmrZ
         ZaIsCseJxi6YBPBM2H9ZJXJP2xUH4f956/eR2JniV1R+tjNumo9XQqzwxUl6fW0HNJBU
         57ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792465455; x=1793070255;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FvpcUWOMJRPh8Fi2Ngt6U54Np2NRjnE0G0LmqIgTo0M=;
        b=xfxlc1zDWVd3l5dIyj7A9ElQITiDRxTqUUH3boQtTgEXTwPd/OKIFrnnTjcGY/vsBL
         gwWPu+CwfuT5BykOsbCRZdMtJW5VIarY4iwSH8M1uw6HyFjhQtiwD1rd7z07Z+TiJvWv
         QmPft+nIImIMA0gV57hiT3dAnNuFu/Ad9Z0nLuNotQFgMJl752BpzdG2LntBrahuQqX+
         uM4882a4OJcu+zjzabCFvP+iHsu2dYMV+jrPmSi9zAEnP1kZZxjtJSvVsy/8IdT+Nrqq
         FHKsXRPLWwr5a39GH0YLYwbAIkDSi0aC77kCfByh1MepBFRy2likDAXvF8x3gpl4GHQc
         JnAQ==
X-Gm-Message-State: AFq9FYIixwJgT3ew6Z0SkVm3lsYlERQVq+FbqeoNZ2N+6OWaQ9D1KMvg
	UsuPTYGw4lpyieW8uErhPu70lEko+tGER/fmlQq9efnRSPqlDDrlLZ2BbfoQ/a4ayy8=
X-Gm-Gg: AYBFou3z0StCEsjwOXa2ceZTTLJoKgG/5qjRM5lww92kackWqS3ESvqT8gVp6ZCve4J
	+wh/CmztG31O4ZtoguYOuEIzTDPfb3Cpciuar0rZOZa6ERZw3Te557/48N+fL5fNoUF/5QRbtrA
	zYhUGsahca1LjyUjnbNQay0FPA3OsUN5qVf/fx1M56c3BYOdtv0iZnrdDHM6ajGoMBC1+ood6Ux
	FtMonCW6wOwZcubpqWM+yav6g+t5VUXpQCe3+tIhZwHElk8wlV0LxpxsljeBF44X1hem2C7/IA9
	IDt9aBnr+bV+BhkHaE4x95/8SmZAwPPbRjjscG61bIN2K8Y1ympbKvhA7HMAKqm4/izvWrkk1ey
	GU3tPztTP6bO4uMEuT3frVO+NkSkKq7NJO67uRo6KEn2ICYe70R2+DojtihOYTXpY0ce5mDoATz
	bt8+cnORkMx3ygcvjGO1YepkHwLvO0pTCjTVnwmHappYkwWAXPSCX9BcbExjP3hbQxKc7U1ESKx
	JIb2vEq2twREw3INlzkObUWCbp1PeYP2bZsiCJtoEKyizjCiFs9PD8=
X-Received: by 2002:a05:620a:28c6:b0:93f:3565:813 with SMTP id af79cd13be357-93f3565089bmr1140582985a.9.1792465454862;
        Mon, 19 Oct 2026 20:04:14 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93f4b0c4f1asm114948985a.33.2026.10.19.20.04.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 20:04:14 -0700 (PDT)
Date: Mon, 19 Oct 2026 23:04:12 -0400
From: Gregory Price <gourry@gourry.net>
To: Balbir Singh <balbirs@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	akpm@linux-foundation.org, kasong@tencent.com, qi.zheng@linux.dev, shakeel.butt@linux.dev, 
	baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	baoquan.he@linux.dev, baolin.wang@linux.alibaba.com, hannes@cmpxchg.org, 
	david@kernel.org, mhocko@kernel.org, ljs@kernel.org, dave@stgolabs.net, 
	roman.gushchin@linux.dev, stable@vger.kernel.org
Subject: Re: [PATCH] mm/vmscan: reclaim every zone in per-node proactive
 reclaim
Message-ID: <atbZyUYli9Ioy5O6@gourry-fedora-PF4VCD3F>
References: <20261019185002.3428594-1-gourry@gourry.net>
 <b7aab691-ae63-498c-8d0c-1696592eea60@nvidia.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b7aab691-ae63-498c-8d0c-1696592eea60@nvidia.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D490EC0003
X-Stat-Signature: pcmdi9pctnupfcudjxikxwf9ybgz8r39
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792465455-611900
X-HE-Meta: U2FsdGVkX19TziXiPftzztV3svvR91P8pwIWGEUVueiwkkoHm1Ix8RDGRVVPtCecssT6ucYgw88ctgFu1esBmaW5GWO4+6GnCziCTH5wn1lQCq/iRFESEp1GmrAVeArKUldhjtNpgSSDzlIQdwaQU5IxhagYjEzJyaTlaGWEF3kR6sSmLmT5D7FHuXRwGSaoY2QeDJ8B7UYw8JFbdqvjR03pEoNR8ZwF5FpRjYxgVN9Mv0YSTDKx8l5a416+6aJT6HGJyx/GLoPDK+YowhTLrnoawAHwuYbU5mSfeMbMcAMHlgyzwOjukkS7yL4O7xNblSj314hDYl8jig0SCMlk/17cc54JQntcap+QOhC+WkrbPEOCqhH5U+VrHa3fhvZB6UbvMNwdUJRP26MGkgDpV+vKuWypwbKBy9WZInvQcvrqZUl3fZRtxnClEdr2Yg1OY4Yd6kBSLIUqa9Dqn6Salaeq8fcRpoL35Gn6aLzgv2p25ynRBnIpZUOovOiAqabucMtVNn07XkgieH36x/LDQG3PfxoOPJPn358qwQAFXM78KG4ltbwLFTXmLHT/ae0ROUCddv92FB2WWP4LGZ52b4hQkp8VtaCYuGXI+d91BQdVuC3EU5utgFhazKQKtMTlLIeJn7dUZK3Alui24cEOj/VOVeF/80u/ZmgP2cq9jmVTW5yXtYcY9h8G9y/h1Wa3YrzDQkgN+a40aAeEZMhW6OOQnJ2uwbCDWF9wT0tuXPvVvn4Q/TjS/FXnfUdlCHHlYlZFmGaHdW1TjDxmmrBTiauM85nW3VU35zlvjrsIVfqgkuSS/kcU/C9idh6LHfwcJ4S2xibEwHiIUGPMll0YZS7yqV8C3AtJDfuMNAGUtP31zAgvXowD8kuGemOzV0CRlss2k6E4TGBS8IXiW+3xIUBMFLYUbeYCNO/ZAKu99PJWtbiVXZAguupE15bLVDKNWqIh2WOhg6zE5n4oVf8
 VHxyIpjQ
 lW2TvS4WXOUm7J43yQRdTSo/JQi19pCwdngg7BDxBo+GPtgBQbNfw9NUVPvRrOwxOMB0+IrBJbUceSdcinICUPbeFAUkyf//FqlAB3hreIp/FBakoeYdd9y7if719kHZBJU8zz6ATARUZOKle1+KgPMCyi6vNRYk55mTIU2fv/CqtUAvB1UDXCp0SP2Zb+LHQxCVPYXjAeuFE47ugbCLbwriA00vzfxOYqR1b027uwU+vvXj6qa2IoKEox7l7vu5KbRM5eM9yss9tPSQBQdC1CJycS/qel+WfjJNvnWZJXs9nZYF9NIb4cfw2f0Zx9qeEFfEW6DtiYylNm0M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 20, 2026 at 12:49:37PM +1100, Balbir Singh wrote:
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index e82ba737c028d..90f7a7bf4e426 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -8180,7 +8180,7 @@ int user_proactive_reclaim(char *buf,
> >  		} else {
> >  			struct scan_control sc = {
> >  				.gfp_mask = current_gfp_context(gfp_mask),
> > -				.reclaim_idx = gfp_zone(gfp_mask),
> > +				.reclaim_idx = MAX_NR_ZONES - 1,
> >  				.proactive_swappiness = swappiness == -1 ? NULL : &swappiness,
> >  				.priority = DEF_PRIORITY,
> >  				.may_writepage = 1,
> 
> 
> I just noticed some other issues with this code, in terms of honouring
> zone_reclaim_node (not related to this patch). I'll send out fixes, for
> this patch.

I'm shocked, I tell you, shocked!

These are all things I accidentally ran into by just uh... using the
interface.  I'm absolutely positive these interfaces are full of bugs.

~Gregory

