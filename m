Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DBDEFEE4F8
	for <linux-mm@archiver.kernel.org>; Sat, 28 Feb 2026 20:05:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71CA46B0005; Sat, 28 Feb 2026 15:05:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CA8F6B0089; Sat, 28 Feb 2026 15:05:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D5FA6B008A; Sat, 28 Feb 2026 15:05:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 49D1C6B0005
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 15:05:23 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EC3531A0269
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 20:05:22 +0000 (UTC)
X-FDA: 84494944884.04.A7B6C98
Received: from relay.hostedemail.com (unirelay03 [10.200.18.66])
	by imf18.hostedemail.com (Postfix) with ESMTP id E837A1C0010
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 20:05:20 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772309120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yAzpckg+/nraiNZj/hjeJPRvDIkg3E8fCM1z7tnwQJ0=;
	b=nMX8XNddjEvKaf80eltd1kmig5v4t8+C9943l9Q+SKA8PJQMkkuE/a2j1+YpHGYJvsRXaM
	AwY2TMhTrTUPb/7L/40OiRQVGVzy6GEjLFDYkkS5Mpbxtc2COeCqDHyOgAma+l7BU0y4xL
	tBWSN+U7idARRc6n6U065iCh3CN55jI=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772309120; a=rsa-sha256;
	cv=pass;
	b=eoNmJvNMvcNq7iLBHY5RHz9SW6pYI2fCtnHNUsm9r9R5lw175TJVynZHn7r9N1QZaujHwq
	CMBB5sWshCcEzya8ge66OGZAWS9qjhZ9hC6vkGBrpl8f59/XgmXFaAJfTsQiaXx2tHuPoh
	u+nGKlDcXiYpr7pChRbjPezKHI9vX88=
Received: from relay.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6D1C8B79E7
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 20:05:20 +0000 (UTC)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 44887C14D9
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 20:05:20 +0000 (UTC)
X-FDA: 84494944800.02.535F7F7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id AB67180003
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 20:05:18 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772309118;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yAzpckg+/nraiNZj/hjeJPRvDIkg3E8fCM1z7tnwQJ0=;
	b=lE/v93d2fKa1FH0KpTt2x3NKCnF0EGN/1K9YJGbqdxT/6qoyNs6dmvWcSaRgat1AUB8MeH
	cB4LlgVh8T7XhJxkJVIu/v165IH1pzB7/E9BZxpz1Km92Azj+oqwNnfMSeN6E7Pzbld9Hr
	/b3TJ6+b+xAgM6aK/WY7NwTQSZkkbCs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772309118; a=rsa-sha256;
	cv=none;
	b=2UUVcNNekMtp/viZjYLqurtIiNDGLbY6dNhKnwkanjd7Azxoe7+0VewzqhZDyHneK6eYNR
	XNdgaaC29uw7o4E+ELr8FhJSn7Rgp7yuA8d/WwRDoOX3NmeuIAewETgUJ/U+2BehbWDAer
	udzFqPQnuuxXGoQtCOT2rAiqIVoG+fQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=aAF3ulMe;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6BBC8407CF;
	Sat, 28 Feb 2026 20:05:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12DFEC19423;
	Sat, 28 Feb 2026 20:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772309117;
	bh=yAzpckg+/nraiNZj/hjeJPRvDIkg3E8fCM1z7tnwQJ0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=aAF3ulMeOoKPIs13NZj80nOWPj2MQSAWuRgFnXpmnS0zWc+FNOKK3A2pdi/hQShu7
	 mfAek3HflaUutbGk2VU+pJYepH/YYpSfAfZXdZsj7XX5B+vE4MpHLuGrYiZEAvFBCm
	 RgRarKWKmFe1lL4+7ulHulg0a2CyTtNU+BgY9Qrk=
Date: Sat, 28 Feb 2026 12:05:16 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, linux-mm@kvack.org, Brian Geffon
 <bgeffon@google.com>
Subject: Re: [PATCH 1/5] zram: do not autocorrect bad recompression
 parameters
Message-Id: <20260228120516.e5323a704d4a26bda041dd4e@linux-foundation.org>
In-Reply-To: <8a5d53d19a8dbd51d7d81d153676895163e0735e.1772180459.git.senozhatsky@chromium.org>
References: <8a5d53d19a8dbd51d7d81d153676895163e0735e.1772180459.git.senozhatsky@chromium.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-HE-Meta: U2FsdGVkX1+Pe7Xd4w8UsR4wLny7QtAM+RgGlUxo2OVhUzrAF1lBvH0Zdy8QQDODSpxdJL38SbL+TrzwHLbikK/J6Ss2lL/Ddd4APu/dKDSYXV/gCKlb+I47gZ2kWwR7OA/dVOEggPyKQRJgtyfpB5anrDjxhE8vFUI3gu556Y2+syHBOMfmIRIieO/M0hzpiwiFRDOVR7vviZzcJpNFPlpAxSzVZw1pNUk6JEAsDMZawJtCiDn24AfWUj0uL2brFC3mpFL8Tr1bOiFLJ3yCeMnpbWNEhtUK9ofe/lk9F08R32HGSheCzm20p/OYo0JCZnvrD6Vtx5JqSx27adua6Ilm3OAQGqGovk6QPJQCTYj9DC7zH9z0BzwgaIZpVmJJtbFznPN8jE+6nJuIKypjHGvewM51xhVAF/fthRxt9nY7co3qfUfV7GfTj/Kx8v4UTIe7pb/6LFm3n4WiILU1FiUTMd+TL+Q7ArG7MDNu0PyVY9iWsW7GcMOQIDa+zH5HSyhHfx4VtZoFqn4yszYU5u6/vlVvyr6PqIGWgi4tCXwHs78wszWr9jZ17CHFrMDAlbZw8YOvfCY6i1N8Fet4VfJxT8CFAet89idX7vV0ZzhrE8G6vwovm6c75xyVk79UgBz1507y5aPp9M9Uge1o90jhBsyshkr8Suot7lLrvaAJijQRcTasrlfpNqGWMkgawrIsR3wUYA5h7dSMsdzjDnrBhKTyji0zTneAIdbu5DWXI+Mbrtg7Y+JfmJstErGHy1yAX9cF7JUocq7gtTbgKZKzvBUnDTng5oG33n7BGeuaWpwRrKISAvrTG8sBbWPS/EcLvvz8qHFvye+v0GTUUa+ro4wmMUQMkgw0d1r3yCo4HCWKFxy0P2eSqE+irEmnlUgdr3+FqwdoqJmd8aXRAHZHnzM0P/0Os3bwhqGVtW4=
X-Stat-Signature: kojxc6o3uwp4ehurpoc81qxuxa91dbs1
X-Rspamd-Queue-Id: E837A1C0010
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-HE-Tag-Orig: 1772309118-77727
X-HE-Tag: 1772309120-314302
X-HE-Meta: U2FsdGVkX18KITcCUxWhFKwvFi37gOWm7D4rTr48yAVsV+k0gRCw8CY8GcvRUH0esF77XKat7AARz+0orxiPUgRbwqTnC1JBv72oCT4WBMs5xg7/LiPBZz7torccxn4Ow+mhF6pDirTiFFNTH9omrDl0yPK3BXsPSmVfIMxs8Oc/JbTUTYqXBwglii8sUnKWHXrnEvBTX2VSctinRE6w3r15q85tRolBzV3zQ6cVeXoyhJya3fblvjxnPqRDe59RodNdLvSAC5oZxVrcEYpXQMzyq2SR6h/5qMIDf2KhHIfx/SV66StUG4f3yLif1uasLHZyyVhjfS18/4KKDMsjst4glRYGOlBh77A4aScR6MPZEJm4cNGDfMtHvm7RDCmWy8qwY1ldydVxQGkVdvjiJu9LVOV/sFZ5NiJya54Z7Jv1sK5VjLVweOIwb5TONGSHYM9YO3ovOGIIqLfIfUl/4rbiuiFulXvZkNFF0pAJN8QPpgZlqHvdOK6D2Nfp+BVx8Y3fw8guyD1ItNdGk0yaiiQXEfrWX+lSZljTS19kbioCLuojCIX/PbIL6r8kAIZbbgGCMwN7QtKydOqu5W3oHnjjyuagEftzplbtN2Oyif5IP8P4ikKuoxOfypm1RgynrP2M5BjwRn+lzpAZlC0Iev0mNL7lm+1N7D8TpbjGOEH7+5Xrrmp4FSZbB4mHC/wEmgYtuAaFy1plzxuJd62XBPk3UmX0AOMKpEYsovP/q45T7d0SsN2hBMU6lc4ub1hc384EQznmDbMpwkTgRiJGsakgfbgjTlUBTrI6JUgbN+aBn19zz+rupn6spvo/5oEO9OLPxVlA6r4NEKhejcHE8vw5/HZIJ53gDlmzQI7i+t4dsP2pBpyeE1SX0AUMGYdz3FKm9UjWl4Bn8jG7m8QWEQ+gTeaLwbp8lPQI/kSR7VrSeEeTmYHwR6Md8QYpnjKKNfLZzogLk1BU6nRiKEz
 jcaS84BU
 xTLVprWk0eO/VTILzyy3FV0ar1OiBkJAltemJbt8XYAnfxf4Akia8ackH3apXKsWRPeuh33+/gZiqjh2ZUNnTtvC16iBBy5pnmO6GOVMVdgaRy/5/dymQnajf1xfTc0sYmgkRbhXJfekk2zp3qXKs39XCDcGUmsYg+akBD48Ij2Xf10fU2E6C2lotrDzohR2DzO0TpLGwhitIZhTaJuhvVNnGe4qQmBqh2YV/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 27 Feb 2026 17:21:07 +0900 Sergey Senozhatsky <senozhatsky@chromium.org> wrote:
>

A nice [0/N] overview would be appropriate for a 5-patch series, please.

> Do not silently autocorrect bad recompression priority
> parameter value and just error out.

What are the reasons for this change?




