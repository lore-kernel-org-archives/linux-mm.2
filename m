Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7B5FF589DE
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 14:45:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12DE86B0005; Thu, 23 Apr 2026 10:45:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 106CA6B008A; Thu, 23 Apr 2026 10:45:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 042E56B008C; Thu, 23 Apr 2026 10:45:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E8C956B0005
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 10:45:04 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 849741A01EC
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 14:45:04 +0000 (UTC)
X-FDA: 84690092928.12.03B504F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9FA4940002
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 14:45:02 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=BhQJuqW3;
	spf=pass (imf12.hostedemail.com: domain of konstantin@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=konstantin@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776955502;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FYW/XRUxwH5ynA2LHhkFBYpt1zcHgmCzO25J5E5OZHs=;
	b=gT+WwgzRSPlFYQrK0cIKW6jfkXhP95YUrXKVOrOoqUdu0T7ISxclCyciqbRyXqxM+Wevls
	WPhsVGWfErjDbJeJ5or6VnufdJ4LLxmjUDXypva9emb4eGWdod5uqiTiu3cnabZX/4zpWX
	OJvD0daZ+kXKkoJZZvVVuAeck7IcLOA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776955502; a=rsa-sha256;
	cv=none;
	b=gFgAGjfTR2fa6V1XM2321ysFfKm99jtksAlZX5IRiMMuA1n4UNHJckcpKfYV0/O4gkS9+8
	vn0+bMOd5lt4w8rzm9O5ynNg/kM1UMKczcs5tdYjEPlg6byX+HUrMGETFW86SfIO7T7hBO
	xzFOEoWkn7EjBfjZqaBqj5vt0uR2LXU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=BhQJuqW3;
	spf=pass (imf12.hostedemail.com: domain of konstantin@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=konstantin@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5AEA341833;
	Thu, 23 Apr 2026 14:45:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07F25C2BCF4;
	Thu, 23 Apr 2026 14:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776955501;
	bh=OIFmw0Zt+E1TIBRjqQYJijDgQbMQMtOjHaQh+iQXWA8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BhQJuqW3RPBMKmIK40BAs8p18yPepeiwVpghW6NZfj6j3z5iD9wIPgJl9lHgXRqHL
	 NVNbRpZZa6gA/4+j57REAHinGjFGuU+zw9Eq8How8p0kl3W0jk7/NoGqzAHFB3j8Zi
	 3mY/f3CAJ5MwAWJnL03Dkh02kv1hJqY+E46kf9Ek=
Date: Thu, 23 Apr 2026 10:44:59 -0400
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, 
	mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] MM updates for 7.1-rc1
Message-ID: <20260423-tasteful-stingray-from-sirius-7b94bb@lemur>
References: <20260413214952.62836ac9df0eb348ee4aeb2b@linux-foundation.org>
 <CAHk-=wjMroU7PofBOC52f5u5bTjTO2tm5ehycf9evmjeq-hq3Q@mail.gmail.com>
 <20260416011820.18f5a11bbed7fff54be761e2@linux-foundation.org>
 <20260422-aquatic-chital-of-wealth-8b7fa3@meerkat>
 <20260423051246.5de8968ca017eeb8f053fbff@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260423051246.5de8968ca017eeb8f053fbff@linux-foundation.org>
X-Stat-Signature: gbxnwt76ybdbctgf6ew8mptq7w64uzjz
X-Rspam-User: 
X-Rspamd-Queue-Id: 9FA4940002
X-Rspamd-Server: rspam05
X-HE-Tag: 1776955502-412950
X-HE-Meta: U2FsdGVkX18a+yGU5xmUiuOkkv1ZXO3zqcJtOWItMdj30mz+siJajLWYmPszOf3+sxN3Pw3buwC6KHSWucCC0HJjs7SHQhYodR/EdtExHEDXI7wD4X3e0KveLrA4qCwa5IpJaaka992AWOxifHMtpZRmtC1CeWzOC0JsuZDo1HZ1deYN5lD0Ija8jMukKrOgF5gMHS89wcOUyuLP190tAtcsMrc9CrkaEUQbu6SCd3ysiajXoqGCpYqd8FUrHoc4fxzZPT4FbdnAomqGAQFkytLUrRkRuhYZE2ACZI7NW3asT+aXO7z29wvQTLGNe47S0/U8cbrzrZE9ICCpaFPATMrQKnrngcP9J2jB4X6rsJLlQHDJxZeQMy6aVXhS4moL3MyRcuDaXbqRkOsn6di2O/17uxxulNPxLrNmB9dYzeTPu/EdEWR2iib0oGyJtxRNDqvfgfTS/Tc0X6M+tgHpatoX8KcQqfMJLnTcZGe1EQTE5tkZ4ITp1/dYZz8DVwwWm3MSpKBUWDLjDW9KkIDDqZM+ZR5OKdLCNcJefIFzjHl5BmFxmVMl+ENo7SofPHHIcToPZ09yoHGKrSfIhkgI3W+QO0tesDJ5nxpwTdjC58Mr43V/YQc+MlmZHyCfrQ+94HBfVAb9zSJT0AVkOK88oA0UBjQhslvpi1Kgf/+HGUcyMJR/dCwXBUSCWQ9/yXi1ol/OXP749lCRvRH5kZ2pDRXOY1t+e/habyTnObtjYEWS9Jx/GRPIpXh8ZClAMudNPgyY+haXt+Di4ovHCLhcQIWV1iVOWKXLXIShHlLjWXgowVqTqOFwoyd7907/Ya/9zFu/RcqN3JtZv6m/343rE47guaxwxBS1MOM6RqQfglrvwsNaO9t6Wb4NGAifO0y3M3TxuQextkMh/KNKsJClHwffg8TUYV6n93NVWgCVwnMLupPlUdiChkzvp+hNKJHoCHRJoc3MDfci1Um4k5d
 kg68choU
 OriTJ5sS072HDopIOXoytczRRBP6Bk6xP7ZDgbiNCZs/A3mSB2cEc26FXiYP3RiOrtoOdplzrvoLgTh1rHXTZyQ9vsUTqeewMx1C0YBmRB6+6+VayZsPLNLO4Qb9j9/LQT3P6Mb0I61oKQWfUjIyz7RF9MjYinqklo46MRq5YWx7KNc+95C0HwtcKwLno2uxeMfq2l0ij6yofLoelIfVOJ0sIjKf+Y8sbHGU9TNYtJSIN7oU+ZyPHEp5nqkxI3T3icRTEcFqZVD8su5BwtQqq4YsEYZOcqek+gO6eg0PNA9M4PnEZ1pQaDEAVf/n7rp0+Vm2T0/j3Q9INd8h1JA73kk2d6a3c/VkbAQ3rNXiLC46q4rXetYr5dckCcrWT22pX0gmo/6KsRC9erFLwUQctl21thg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 23, 2026 at 05:12:46AM -0700, Andrew Morton wrote:
> But what is the preferred, official URL?   Any preferences?

Its in
https://docs.kernel.org/process/submitting-patches.html#describe-your-changes:

    When linking to mailing list archives, preferably use the lore.kernel.org
    message archiver service. To create the link URL, use the contents of the
    Message-ID header of the message without the surrounding angle brackets. For
    example:

    Link: https://lore.kernel.org/30th.anniversary.repost@klaava.Helsinki.FI
    Please check the link to make sure that it is actually working and points to the relevant message.

However if the link is purely to indicate commit provenance ("this commit came
from the patch posted here"), use the dedicated patch.msgid.link domain, e.g.:

    Link: https://patch.msgid.link/{MSGID}

-K

