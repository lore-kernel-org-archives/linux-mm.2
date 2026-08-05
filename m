Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98205C561E6
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 13:51:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67A636B008A; Wed,  5 Aug 2026 09:51:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 603A96B0092; Wed,  5 Aug 2026 09:51:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51B536B0093; Wed,  5 Aug 2026 09:51:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 31EEB6B008A
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 09:51:36 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BF5EBC0494
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 13:51:35 +0000 (UTC)
X-FDA: 85067353350.30.6F18E19
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3870840008
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 13:51:34 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="TP5/G0WW";
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785937894;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A55ICr5PoqB803qOLx5Egg13p9sfV6/wfqeAQSAkVsc=;
	b=Zkr6sB36y4zTH2qA7KBFizKOFgdvGZ3yoDjGkfBxsAbHBtCCJjhnNMC5rYIyDnp6O1v2/V
	9W6PS25+MIT6VHwPARQd3wTdWZmeHmkiPUOubL8bQER5oOsNhx87fGM3nryl6VZoO2x8No
	TLfhEb1u43wpe3DB7TkZ8zuMPWgdZz0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785937894;
	b=nKbceWdRFwkAJ0vuYz0WuX1iBw1w2Bda7iy79xvm3unlfS+12LE4AFeNUcf/eTgaKJwG5t
	7d+QaDZ15/Jh/xgwj39CKevovduJmPh45uH+AoJLin5ycvgFxKqFemwi1s3tAaYjpSr1v3
	SuH3937ZoGeGJ12zwMmTYAGXMiQB6bQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="TP5/G0WW";
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3FF7060A6F;
	Wed,  5 Aug 2026 13:51:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB9131F000E9;
	Wed,  5 Aug 2026 13:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785937893;
	bh=A55ICr5PoqB803qOLx5Egg13p9sfV6/wfqeAQSAkVsc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TP5/G0WWd+nIsJt0gJ9Gr7EqVH6u+8Cu5Lr5BdVrwMZW56gBU2KTB41AIXm/FchtO
	 yY8133jsiqG/QqGTM9g/QOgnNl90fEA0cuRSLJbpp2wW3nnzil4eOLi9p7rgfQWPQv
	 +MNNYtHnMMfK/2dNCAbaKGLJeBoIJx28a8ztBJNV20WMxryYJNeRqlUP5Nc29UUcm0
	 YsO/0txrBW6HqAPutp5HccdhYsLteo6dUwY0AQruRx9MF5PaKn7/hNK8+/S4zhVGmF
	 laHGkQ5I37wruJrH0e8kZRULW5XeUbizORisvljjwvgr5W2blbNktKpJ17kI6ZX453
	 9dgzWNZSin0Mg==
From: SJ Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH] mm/damon: introduce damos_sort_type for re-ordering regions list
Date: Wed,  5 Aug 2026 06:51:23 -0700
Message-ID: <20260805135124.88619-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260805081246.39417-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3870840008
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: sxap75iwaejy7exsfg9rc71dw1yofqys
X-HE-Tag: 1785937894-187111
X-HE-Meta: U2FsdGVkX1+64YtY0UaSx6LuUTLEjlcCoG0jkDg845e0X4VRYQKzxAVIgTYV9D5QQWlZ6qQ/FAgrzXqm/5csZ/0g9Q8fGPwJqLbb2nDMpocozlMy/7M6OHW+QhxKwFYyFnfkz6a3ziF38iULE9aAL9BVB+pXsjdXh/NyAj/qAT3+7wJ0aNyHHcAgWi7AKf3fTPdfrwA70xaJlE0Y753+7y/oFbcTS88dd1OoFljdFqhoaF6kWm1VN25OHVmRai2DuAWmaQa7ODHXYx42F56+dRDQSODyMnxyoIO27AyoZ+ILEHHEmycp6k8Zxq3G1UqTa2hbXWgozaotGfluTR4KXZ1W+VHzi516BCVywHj+eE/EExD0+zGldzXbXPLIqbJOoqef3t16uud6MwHBSM4N2cNQ3YNaZXTTgbLoM7CNQ2GKnqI2Kxp88Zz0WjzdZ0qsdomIidaCUajH/DYsSFYcMOaT4jdwh6yo39ZOK/ncsvm5U8OIzIm+olkNAc/d+OWi+JuVGemYuWrfY6hrFRGu0uWclIHI6Usl/4tvdPPlwF7P+5544IxKJtR+J6XzgAenPfW5Uf1n3gTM2asYtFAMhc3nWtjefW2vbY2f4vMmnjnR6diNtUx+gfxdpYTNynTIlCdIeeFnZCg/DFB9aqtX6JWI7B+9IXnBCgrb/U61dL4tJtKp6s41H41pXH95giDsSlq/yADzPWvGIre9ebK+2oGRLmnFQj8bMDOen4tPAXO5uBMZq2Zrr+65cvSIauhYgWnRzC2cpTyiH7ajmvU6dtMtheAG3S9+dpICZ014UPKmpjseqS5VOuLtT0SX0IQiDEIfB34FAzas28A3Ei4Qc3STNdw5VvSoIIvo9A1W4B31O/pgVndbMtHAYE2n2xxCqnOofrSvHY4RqUbO3KJpbhMXpGvr+ZfHgAdXuVgGH8RQUqs/S2PGHYhs7NlPu3P4fC0SE3whhYHHcEeC1Lj
 WCiEEVtk
 OLRyhlc9hpjM9OLjQwaQT31EWPg63IYbfzxyJPUCD+1V78ZQqitZbL9/icDLzQCIS5l+5A1hMzw2HiZ9W665cgnFsgz/wHamK4uNn+m+Mev7lbxweIqlfk+xzqsGj8+AUQpuzLzBOsrrj33X03AEEXkhxwaaTy5udP/O/3dyvrxbKvFbSGtvJy0W8KmeYOvCQJpyscVO47Mfy/cS7MwI3In4x1JidyiWEuWyYCwWyyUk3mCArIjz/vIEdk+qZfOfKYIY+eaeTG0bz0TucTe4quSRWcUIgRs9/3NnNYOmJsSdYK5w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  5 Aug 2026 16:12:46 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> Hi SJ,
> 
> First of all, I apologize for the noise, and I will drop this patch.
> Secondly, thank you for pointing this out, it made me realize that I was
> fixing a non-existent problem.

No worry, it was good to discuss the idea together!

> 
> On Tue,  4 Aug 2026 06:58:33 -0700 SJ Park <sj@kernel.org> wrote:
> 
> > The recommended way is setting the min_age naive, and auto-tune it using DAMOS
> > quota or aim-oriented quota auto-tuning.  Have you considered using that?
> 
> > This sounds like very similar to DAMOS quota's regions prioritizing mechanism.
> > Have you considered using DAMOS quota?  If so, could you please add why
> > proposing this new mechanism, with some comparisons?
> 
> Yes, I have. And you are right; the existing mechanism is better. I
> wrote this patch because I misunderstood quota.min_score and did not
> even check the implementation of damos_adjust_quota().

Thank you for transparently clarifying these details, Liew.  This is very
helpful at conversations.

> 
> Whether when implementing dama [1] or this damos_sort_type, I failed to
> realize that min_age might not be such an important parameter on a
> long-running system, and there is really no need to introduce
> auto-tuning or a new mechanism for it.
> 
> > I to be honest feel this is too much for "just guess" based patch.  I'd like to
> > get clear reasoning of the change and/or test results before reviewing the
> > code.  So I'm holding the code review until the high level discussion is done.
> 
> Moving forward, I will ensure I am not "reinventing the wheel" or
> "fixing non-existent problem".

I appreciate that.  That will be super helpful.  But I understand we are human
that cannot "ensure" everything always.  Please try not to spend too much time
on unnecessary thing.  But don't be scared at making some mistakes, because we
learn from mistakes.

> 
> Thank you again for pointing this out. In the future contributions, I
> will try my best to avoid spending time fixing problems that do not
> actually exist.

Sounds nice.  And feel free to ask questions or help.

> 
> [1] https://lore.kernel.org/damon/20260628085155.20828-1-aethernet65535@gmail.com


Thanks,
SJ

[...]

