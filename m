Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AE2410F2867
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 19:53:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D3056B0005; Fri, 27 Mar 2026 15:53:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AA7E6B0095; Fri, 27 Mar 2026 15:53:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E7336B0096; Fri, 27 Mar 2026 15:53:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 32FA36B0005
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 15:53:19 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CE9E11A11BA
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 19:53:18 +0000 (UTC)
X-FDA: 84592892076.01.5F1862F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0ADF74000D
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 19:53:16 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=mR+0byTc;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774641197;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wsr/vLDeVSWMhyzGXG0Xm3NTM+fZabs57r2a5uJ8nLw=;
	b=YvacddtO+bsshpkG9N59/LjmRigK/qWPmoq6xQDg75jtVHZt/qhudmFVxxkc4YyGDnP6lV
	Ql4v5X0e7ov+tUrjbh2NPV6Ik5VIwWchKTb/BckKTBhEDhjWsNvKGlGg3uh64cPwiqj7fG
	kJ6KFSkfyD02G8Hr0U/FpStzblBmSNA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774641197; a=rsa-sha256;
	cv=none;
	b=J+z8hn5XIebMW7dOCx85pszwFprgfE+AMWUnqCCTflR6QmrPR4DMa9h0aoN68hJr1HoMdf
	1zd1NrznG7hfP19iXjfMhy0dAq+vQMO4fQcG7xqpSGRKCbCJfvtnHmogo7zRy/r/fz3WeD
	E7r4lG1Pz6gL86Uo3/Vesz9PhSIDcic=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=mR+0byTc;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 04A9D405FD;
	Fri, 27 Mar 2026 19:53:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59DBBC19423;
	Fri, 27 Mar 2026 19:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774641195;
	bh=DaA5q0E50fq7kc6gfssqfiv3pDfgvxYxqzPlV4F7Lsc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=mR+0byTclEiVX4ZIljfdL00vQe3lzA0cDfVRNASRJr6hGimvfLM2XiyJl1dFWPcgK
	 JuswK16t/bNraw7XTAJDE8AkJ7gVgUNFoczqfNhMvAWSOJqqcLu0Cplw/PN6Kkuig5
	 zVNBm8snOX8e4uPS/sHoJ8tfTYnHSkSD3PqkFe70=
Date: Fri, 27 Mar 2026 12:53:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, hannes@cmpxchg.org,
 david@kernel.org, mhocko@kernel.org, zhengqi.arch@bytedance.com,
 yuzhao@google.com, shakeel.butt@linux.dev, willy@infradead.org,
 Liam.Howlett@oracle.com, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] mm/vmscan: prevent MGLRU reclaim from pinning
 address space
Message-Id: <20260327125314.98f1087225ee48d4feb97345@linux-foundation.org>
In-Reply-To: <CAJuCfpFrQQDipONQN-ie-tWVNx7m_=jxyqsh0gGD9CE7HN7RLA@mail.gmail.com>
References: <20260322070843.941997-1-surenb@google.com>
	<f22cb9d9-7fc8-4a79-ada8-02d66a1155b2@lucifer.local>
	<CAJuCfpFqz3OvOrJOnYG8NF0gjzkzmSaiM0LZKD_aLoW9Br2srA@mail.gmail.com>
	<0f599835-9b99-4457-9ba7-a3eaeb0768d1@lucifer.local>
	<CAJuCfpFrQQDipONQN-ie-tWVNx7m_=jxyqsh0gGD9CE7HN7RLA@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 0ADF74000D
X-Stat-Signature: eo7tmtrt91r99quxr6hhpo6xi4fxigof
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774641196-376224
X-HE-Meta: U2FsdGVkX18GxmfPxYHKUQUK5cgjzG5v3s4NCuLHB/ABS0WiWyebbGF7sjaWFYRMHGPzQCK2jzQnOoB+yyFrTjELfuF0F+o8xO9fZOMkpTqBwiWf08L5fGaPqS21WqHPhD2D14lXFTInAEkSoZGgXRyS+aLfVKuZJEMzC5AaPJMFteh/XTk617ozm3gGAz+VdPiE/K4HTf63CGhXHi6KTtLZ7EsXFijpDLXnFdhzT+9d7wNQwuxflksGsH3IxBynbLPr+tBIrK/J2hBApIxpom1ZXxtzsMBDrAf37aOZTkhO/BOmBvpe2L1XQ5JyJ3TD0TqBIcLt9NxK4nOqwgdHpTRf3lStJ8E8lOkungKnIkq/vaMh9ukphXr5uWDaTTiS9krjEBbmf/yMRj8kNKn8JMPsHPJwmc40r1oRQxXJpNqs5AofbMAhVxgF7JcXEwHRWI68VoSCtBSQ9ZJXaNHv8nF6UUdYesFib0GUUb89jLPNqUq4mFBJrqSghkXy9YgHYHzWmOVRNzx8y9jqf7kv46KSRqwylPH4k/7NZXBhQjGG+jKI6evfbRIsyr21xb+9xF53L7spywE5gmPmFuW2MXNiAGCDeZcfpIRMk7T6CP1ZrveuVwi2TrskmX2VTQZ9C57KNtWnvp4D3ls4OeS3Kl1Xe2plH2EkigaxSaT2R7WEo8PhRTTuwTsKj3TMHdxUTrI5Ppqae/9XH7oEOj0DOB1s6Oacbz5Mcwjkjqmq17HZBnwYAE6Eh9gptrbCLOo9b+tt5abVGghlVgJxSShtkJ9IM1PB9hipMbEUPxJWF7sa+kRm1NfmeHsibAa0KLh5QvslV3bWfbspfbA9YSrbdUVYRXzA8qxXQjOXwPhnE1WSdYeLqKTjmwD8peNaFicgF2M9FTX+ZnvAlYgNSCL4PFdyIQKKXYLK7jBpZxhpPZCHfqitDo9bg2rKGIghmbq0F0zhpYHANneVJTZEHue
 m+x9i3l7
 l73B7wXQVLbxX93oVnFEMP6JwuDp5wU5otCD0r+THtBuGcVzcbuNnjruhPf3/QBp9+L7NAxLUNkHsJayHU00nVi0v7SDCBH69d4xwliteT6DE+TkidxlIJnqyTKpPkfpbHQoVVBLIcmtHpiYOw4ImT6twa8jOlQWwaHeayeEhQfQT26ZYXAa5PwvcGpgJGaFgJPQRhVf8CMBvaZNnDiL7JX6H7U0IGUQAlseTGV/m4SGA3mxc7h8sdZNProGUe8sZCotnuhGyf3AOFH98k2OcqadQgTQpEIZMXjpr97JkOYsdSqk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 27 Mar 2026 08:20:06 -0700 Suren Baghdasaryan <surenb@google.com> wrote:

> > Given you have cleared up my concerns, this LGTM, so:
> >
> > Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> 
> Hi Andrew,
> Any concerns about this patch or do you want someone maintaining MGLRU
> to Ack it before pulling into your tree?

That would of course be welcome.  But Suren+Lorenzo is more than
enough for me.

> The change is quite simple and I explain in my reply why it's safe,
> Sashiko seems to like it and I extensively tested it on Android.
> Please let me know if anything else is needed.

I think that if the fix is valuable enough for Android to backport then
we at least should have the Fixes: there to help others who are using
MGLRU on older kernels.  (We don't have an "Improves:"!) And if it's a
really big improvement then we could even pretend it's a bugfix and
sneak it into -stable ;)

But the changelog doesn't say much at all about how this change affects
users.  Just "delays".  So can you please expand on this (numbers are
always nice) and I can paste that into the changelog.

Thanks.

