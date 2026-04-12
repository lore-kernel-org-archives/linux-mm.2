Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9702E937EE
	for <linux-mm@archiver.kernel.org>; Sun, 12 Apr 2026 18:10:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F8B06B00A2; Sun, 12 Apr 2026 14:10:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A9E06B00A4; Sun, 12 Apr 2026 14:10:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F01B36B00A6; Sun, 12 Apr 2026 14:10:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DE18D6B00A2
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 14:10:31 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8AB15BC08C
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 18:10:31 +0000 (UTC)
X-FDA: 84650693862.26.BAE5E68
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id EB6AB18000D
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 18:10:29 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KNmJw5jd;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KNmJw5jd;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776017429; a=rsa-sha256;
	cv=none;
	b=UDsXhV4bd7VbInbrixuqf28YR/ObCkuypcHyXBF/7VnrWGGt5piN+ytD2seAasi7wF1t8r
	MpPFxrrUmL6KJnRSFOo50NWBQ9ebdP6d3o+vdKRWWBezYwbsOY41tK52FxJ+EMYg4A3Ogi
	BmGecG3vnXNammrL3JHixPsbdxZB9eY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776017429;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NwGsCKsao+/3UhFNtvfoxyQthD7GF4uOhlrmTnY9U1s=;
	b=jjGtObntTdDKzBG6V84mHxr4I0yPouGp0gpz2FCaUP+aeFvV8o/t5ZqIbTd8QRUI8U6Sq1
	FPsiiQSDSTuTkL6eLm65AfAaiGcD61g0Wn+BZo6Bz6Oph8S/ShJx+cz//FI+UtCAptOp3V
	KnnDW/NAVG6IulRPFhuXiwPi2Kuk0PU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0748660142
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 18:10:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8746CC19424;
	Sun, 12 Apr 2026 18:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776017428;
	bh=9iH3qkwImK1/O+QefkDCqpV04KGR50w7LLCmPpXJW9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KNmJw5jdueSCOXs7VUrUkiY8QVH8oJ/A9q7fVqcNAn38Gv0nmsTsKkeAe7GnPulgk
	 5WODFQgKijbNrPHdEmEk7FGoOEBEw+W0ixwvTb22PjX/dh9r90UnLNis1aLxEAJJcI
	 Q+FPcMpBqKvOibqbE63qEH6LKh1iPYN/rrZF/onpPfAzeSUds7lpY5rwJ1XId4v4zT
	 GlIhbb2fz1XmmG1jsp31ZWH7HRMrWbJ2eCosZAQrFdYu5tfA2q3+MDaLSau9J6T/jT
	 ZV72LwuMwwIW3Pf5G22EKzac+fALyOoSrSkxUWGgI34RSgMmCj3tZiPH68pv/uCvJ1
	 5ses5Y/afSkOA==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	sashiko@lists.linux.dev
Subject: Re: (sashiko review) [RFC PATCH v5.2 07/11] Docs/ABI/damon: document fail_charge_{num,denom}
Date: Sun, 12 Apr 2026 11:10:20 -0700
Message-ID: <20260412181021.84296-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260412161957.82835-8-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: EB6AB18000D
X-Stat-Signature: bk1tasi68ifb3w4u119a6bub9spp99xj
X-Rspam-User: 
X-HE-Tag: 1776017429-853950
X-HE-Meta: U2FsdGVkX19sg58XuNDixASuWCQfK+jZ//wHnLrE9ptsGQzsTp7rv0bqnxXmMXsipafvM3hAXza8bWlBJkL6XJxCzcveYZS5ixHXY39Yi+beO5kx1YC6RkJsjDjoKde9qyqHZxfNcfIrDrJWZT0dcvEOY+E94jxXqFGdG/XXl/wWGUEuvmuztkg4m7D1GcVM78fdnNTyAO7UZrhhL4RT/0x6K8vSnM6j+hL4pFyaKkGg3CaS9SlfbezkIb/vWwsjRsmVYsdL0YXNofvr+xqoMskwaZRIlDUZS4Q6CvPWAY0o3D1WPGwOhf1xEdZca6+kozyAzFYZy89giTrDaxjf5pDdm7yqAPCWIBfQoU273Jf2yWbQsGoc6RNbJH93kq9ao4MOC+O9vzu8yHP7/jxXZbw9qNhuEDulPXHBpv+vakIPHIu4iLbauJr5yg+VNvzxSbjkX7VQQd305tShf2Ri0JC5XnKVyb0yQ80rvWgGFBgQyV0aSBkDhUPVYu5zvz+JDfV7sE91T+Ct9tNZDggODXtRvftoGF3hVHJpXHh0jioBsRWXpM1t3YYXfCWZ0YTO0+yPBS58slca2Zc98o98sQHf+lktjwdTRKO87GY2RQVFld1jH+vfFPz16/lVtoEjyiSgvhwh9Z0kCzwTsfu7n9u42z1KKZXEYRWs8Y5OAzB+lUlFr2keRsUeq9PGHz+RZXraTu04zHUw14XxG7MTJRK3d/l30alTl0XM0ZIPKKt62vNsZsSw3rGP1VX2QNakub0+e83UiQ/kRED6AAAnVbS04Jwfbao6Uw1z4pc6C7LEfxMrHYukARWcN1V/QKXGA+1OYUCL6XtrUN6XJcLgcet6yDP1yGkbl4sGNGh3yqUFFZ7UgqX1BU13Z7jbKEiC1yokrVH8ZaWQCbIAZTkvyth85XrTD98vE69dkkIn8lbPjRlK9y1N/eiCHzn/LD7aJ6bodUyWz3TMmgM9WPM
 6SSPjRAZ
 L7dBLqqHOtUvr88LU6Zeq1tIttanB4HzxNUZvXrak4DGkM0lYMcQjiEgK819Lcdhp+KY86r4UPR2PMBpttQdw8nOpkxDzskHh3IrnkOhVuf5DtTBXhw6ZlnH7uC2n7ZhDlSM3rWQEwkFYpeBIQ3e9BXX26/jtRw96HXu2wn25xVnOAjrQPbiRBhUL9hb2LM67ntvPgIFuvU1B1b6WQ/Hm/KTebQvzt3vLOy/7iCm7IIDpGGSTy7EqUY4ZW8hS+6VdhRhQUU5a7tGmpPqgmjlAxU7+YKLCiEkD1lWKs8ZRN43huHt+2PKbwe+CtyCQBcKIkiAlYptr3WRfKf3rijzfeBx7MzYaBWVz6FGxaj+PqJKuf4I4dCUqF/IpRqMT2hWwBBgfOl0obIUc1xLGoYQCpmQHvhuOjB4S0V5dJ7zE+mYq6Wk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

TL; DR: Sashiko found no issue but hallucinated.

Forwarding full sashiko review in a reply format with my inline comments below,
for sharing details of my view and doing followup discussions via mails if
needed.

> # review url: https://sashiko.dev/#/patchset/20260412161957.82835-8-sj@kernel.org
> # start of sashiko.dev inline review
> commit 4091d558c881126aba4445ec7fa5033266c62c55
> Author: SeongJae Park <sj@kernel.org>
> 
> Docs/ABI/damon: document fail_charge_{num,denom}
> 
> Update DAMON ABI document for the DAMOS action failed regions quota
> charge ratio control sysfs files.
> 
> > diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-damon b/Documentation/ABI/testing/sysfs-kernel-mm-damon
> > index 2424237ebb105..213eb87392d88 100644
> > --- a/Documentation/ABI/testing/sysfs-kernel-mm-damon
> > +++ b/Documentation/ABI/testing/sysfs-kernel-mm-damon
> > @@ -322,6 +322,18 @@ Contact:	SeongJae Park <sj@kernel.org>
> >  Description:	Writing to and reading from this file sets and gets the
> >  		goal-based effective quota auto-tuning algorithm to use.
> >  
> > +What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/quotas/fail_charge_num
> > +Date:		Mar 2026
> 
> This isn't a bug, but is the year 2026 a typo?

Apparently a hallucination of Sashiko.

> 
> > +Contact:	SeongJae Park <sj@kernel.org>
> > +Description:	Writing to and reading from this file sets and gets the
> > +		action-failed memory quota charging ratio numerator.
> > +
> > +What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/quotas/fail_charge_denom
> > +Date:		Mar 2026
> 
> Is the year a typo here as well?

Ditto.

> 
> > +Contact:	SeongJae Park <sj@kernel.org>
> > +Description:	Writing to and reading from this file sets and gets the
> > +		action-failed memory quota charging ratio denominator.
> 
> 
> # end of sashiko.dev inline review
> # review url: https://sashiko.dev/#/patchset/20260412161957.82835-8-sj@kernel.org


Thanks,
SJ

# hkml [1] generated a draft of this mail.  You can regenerate
# this using below command:
#
#     hkml patch sashiko_dev --for_forwarding \
#             20260412161957.82835-8-sj@kernel.org
#
# [1] https://github.com/sjp38/hackermail

