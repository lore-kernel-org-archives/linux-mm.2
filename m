Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAD76CA0EE6
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 01:02:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21B5F9001F6; Thu, 14 Aug 2025 21:02:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CC389001D5; Thu, 14 Aug 2025 21:02:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E2B29001F6; Thu, 14 Aug 2025 21:02:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EE28A9001D5
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 21:02:21 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4531B1407F2
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 01:02:21 +0000 (UTC)
X-FDA: 83777190882.11.49AD6C0
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf01.hostedemail.com (Postfix) with ESMTP id 868D340013
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 01:02:19 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ymFXDpZI;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755219739;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mb8ONu6QkWqrTFdi4JAWFkm8mSX+G0fuKx0Yv0pYwxI=;
	b=Vkdg4vjdi+JJHq51+VtIYqjq7aXs9EAvdrszyidOV+vZHK1/LpoaJcKx7yw1Z7p19gynDj
	lFYiyv36ldafEJpJ7Q/pMgmTSZpRETwTRdJ9peE8KiV8gbnHz3dDW0XHEpaugFs02f8DgE
	1kbN1PL9gR7FJIAEhXKwAVklMsEpfvg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ymFXDpZI;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755219739; a=rsa-sha256;
	cv=none;
	b=o0Rw7UB/9tURMUDQfuT7ck+EG32hnQmDZxWFO51A3N+Gj68j/6jHUSrChpb5r3UK//zy53
	xZMtdwbyOkLWiRyqlozu2Q5jD9FNuTwJWli/bms8nszKmy6CUS20oUzCIlwZpSqN181CHz
	yl/2JhTCpFpCfupBNkvAl5nFpo2V0Ec=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 4799A5C67F2;
	Fri, 15 Aug 2025 01:02:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1B60C4CEF7;
	Fri, 15 Aug 2025 01:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755219737;
	bh=aihU9DtoEvag9K9c6xo9yUJa4EYuRTt9+t8d76M7c1s=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ymFXDpZIIp3WlpSY3ApmpyoK+ZWZaGFrwQ4ZDyKG7c3XGDICwY2WNztQjGE+Zh/2a
	 w+OSG5I+CZXpaeAiNBagoOVEYqByBhrnzCZLEWKDrFmy5XOebjvvEyaZguFnlFW2yf
	 GUWHNnnpmNaaq9ByvFiB5B3TDZyzUGg3fwO1t18s=
Date: Thu, 14 Aug 2025 18:02:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Matthew Wilcox <willy@infradead.org>, Sidhartha
 Kumar <sidhartha.kumar@oracle.com>, Vlastimil Babka <vbabka@suse.cz>,
 maple-tree@lists.infradead.org, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] testing/radix-tree/maple: hack around kfree_rcu not
 existing
Message-Id: <20250814180217.da2ab57d5b940b52aa45b238@linux-foundation.org>
In-Reply-To: <kq3y4okddkjpl3yk3ginadnynysukiuxx3wlxk63yhudeuidcc@pu5gysfsrgrb>
References: <20250814064927.27345-1-lorenzo.stoakes@oracle.com>
	<kq3y4okddkjpl3yk3ginadnynysukiuxx3wlxk63yhudeuidcc@pu5gysfsrgrb>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ufs8ho4serc9mpdad7yyutqsak9f6bhr
X-Rspam-User: 
X-Rspamd-Queue-Id: 868D340013
X-Rspamd-Server: rspam05
X-HE-Tag: 1755219739-28660
X-HE-Meta: U2FsdGVkX18U2lwMGcEk468bbvMyQbepJ75wWi9ed5GG9Vd22Eg6WV1Jk6tJaUV/+EfB30FpSeKPoLphjnoOJQZTuJSPcpI8cBeOvM4QprdAQq6LMCM/AN8Mgu9KHib2zYJJFkDbJaOOd4M1+02aTXTm+2jf3m0UcBrh5XD7qq4OnYIQL8I5vEwpnWTaKINY93qCkLBK8abFx8t0xGiuVxhtjY6fxVtrV4tONdz4pbpgl4EOfK7YtFoLqLW7hLLUA4dOVA2qN2gr13Xww3zNT1jYdtd5abnGQoCwWA4LggNp3pbpgYrE5dZfrKvV0vhJazMo21tT39/z02PJ+Y0rA15znaJsLouv9LBcmRdEjO+5Le+9pnH74LdI1ouSXsmznb5Rn2uDmkzxZJqLQs/sU2XzCrazY5a9ZwE2IxbcqohLSBUZ578eoyJA0VobH63Dl2skaMXQKqMNk5p/+zqKzzvMtBpnxpbybbeKZFX7M1c75Vy+QRTdY12h6scCGboFVXK84hxmMzWgf4oPnyX/qODgwbWskGRXZVgRI4txxiknccSqzhnVCExZTXmSsggvCapkZlwmwavxxBnMZOT/MEiAcKu4bEevMmQcT/fd2OpGEYPBSsQwUfcQUJVv2gJh7gTd2mul0OBiaE1LKIHhNqaZWyH0fTXBBO1YNs+OA3GV73K5PDXbEbbtZSopE+j2syVil686UX/11cn4o/c3Q3MWQ7QrgTCs8wabrSxmXeBr60oiJoyAgJkthnsoBEazalSDLpAnhhmurjTDI/+6R+KVDxw3+b/xOCcXf8qFdTmrXT5RWnUU+BgQ4WjBC+QDw9W/qzj0U5hiwr+yx+7mwC0GiLZiQ9fmm1D2TIHLmFcKkUp4sueSOmhRaDtM4WJLvNxUoxJPpxYwtqWEeDwHbmOAK8w5897S28qdxkgORw2MkLg97LA5clri06gGi514ffH0S9BBi7k3zgFKQod
 YjoRM99G
 mbJV7iokZvRjLtZSaFfGWXQpso3p0Ay/dk7RLTrRzDDHt+wx0A/iH0BLbcNB6Ah41uM3h5PXROPP3oAuS5VCGw9iJWBCUK4/WFPfXFUI3F+bQlbBBvzOkqlYpCM6ehCn24kQs13dnmpBa2VZi5mgU+ds5PdFMyUMFXJdutvE8y0/af+06vC6BD80lEXjhnoDv1L3gKmcb+Jmm8q++qRCr2CPzBa8BeZXxvJZYPo0Iv0zr8CwQc7GrVEwfqGgk5bzwilzDhDDj5CDtOHUtPaWn4Rbj/uACs3GhSRAWdpFg3Bw5KMiasqE6hgpov3O1g6QQBqVRlwzYhNkRBdxKMuNQkKeNSRMcB8vfhNFK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 14 Aug 2025 13:40:03 +0100 Pedro Falcato <pfalcato@suse.de> wrote:

> On Thu, Aug 14, 2025 at 07:49:27AM +0100, Lorenzo Stoakes wrote:
> > From: Pedro Falcato <pfalcato@suse.de>
> > 
> > liburcu doesn't have kfree_rcu (or anything similar). Despite that, we can
> > hack around it in a trivial fashion, by adding a wrapper.
> > 
> > This wrapper only works for maple_nodes, and not anything else (due to us
> > not being able to know rcu_head offsets in any way), and thus we take
> > advantage of the type checking to avoid future silent breakage.
> > 
> > This fixes the build for the VMA userland tests.
> > 
> > Additionally remove the existing implementation in maple.c, and have
> > maple.c include the maple-shared.c header.
> > 
> > Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
> > Tested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > Signed-off-by: Pedro Falcato <pfalcato@suse.de>
> > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > ---
> > 
> > Andrew - please attribute this as Pedro's patch (Pedro - please mail to
> > confirm), as this is simply an updated version of [0], pulled out to fix the
> > VMA tests which remain broken.
> >
> 
> ACK, this is fine. The future of the series is still unclear, so if this fixes
> the build then all good from my end :)

Well, can we have this as a standalone thing, rather than as a
modification to a patch whose future is uncertain?

Then we can just drop "testing/radix-tree/maple: hack around kfree_rcu
not existing", yes?

Some expansion of "fixes the build for the VMA userland tests" would be
helpful.


