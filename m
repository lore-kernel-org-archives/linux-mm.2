Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D3DCFF60FB
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 10:25:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D99126B00A1; Tue, 31 Mar 2026 06:25:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6FF26B00A3; Tue, 31 Mar 2026 06:25:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAED36B00A4; Tue, 31 Mar 2026 06:25:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BCE706B00A1
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 06:25:19 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 793BA1B934A
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 10:25:19 +0000 (UTC)
X-FDA: 84605975958.21.B194C19
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf14.hostedemail.com (Postfix) with ESMTP id A333A100007
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 10:25:17 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=Hwn6F+Z4
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774952717;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wS0B7N8hTDMx34nsv1RGAeGiy66uMx39VPwXLEOqJc8=;
	b=5XTzkLVsdMaVupDlJjsSKXFF54YtZ0/22flh/vjPzJt1BK/A+ByUQwSPx1fBsKxiv1Ygqr
	UG2dGkXksLmOreRyW9EdwZM+RO87WtJqa9bO4WnZCefmy2qM9Qa2uY7rteG/5bBV7AAp+R
	JmORP4WfwORCPwWKBxD6rV1WVDcSRuQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774952717; a=rsa-sha256;
	cv=none;
	b=GTpc1+ybSiDvdg2waJoHm72pZ+V08HyvHzfaEfCbSu4f5JWnPbzPyZhAHN733zTmnEwwZp
	aTq9PwNuQoyQSo2n9vtAMIxCz/xshJqGV+mZG6D/vFRC1cNuzt/94z76+6IqqKGRXe4pho
	gL4DmA//6f7yTuTnHeo9NcQES5FbJyc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=Hwn6F+Z4;
	spf=none (imf14.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=wS0B7N8hTDMx34nsv1RGAeGiy66uMx39VPwXLEOqJc8=; b=Hwn6F+Z4RVWedrnbTn8XXv+KmF
	5AeftYsSUV+CpcKV8Dhh/f9dxZvvhDwV8TLXHhWIZ85ubtLv7V+dzW+Ag0UptxBYGS+m9wb6YftTI
	B5fFXXN/QC0DXIlf4d/xt4/rVFitE1jXpCJLb30QRn2PZW9adUoRaItFrM42JA/TBUOXR2gIbOPo9
	r53K28YM6LRlxBHGZP4IJ5d33vb0xH9lUZFE4T0aChDOX267xz7zI9ZcF8k7lI/K03CexBxpH2SM8
	M4kwg6kdgypyxMps6gjHM00AAsjlCxlXsh+OvLKm8W4AcXUgep2yodTI/H4sGPtvvwNme3gnpsBgr
	lRm7yyFw==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1w7WHW-0029LL-1u;
	Tue, 31 Mar 2026 10:25:09 +0000
Date: Tue, 31 Mar 2026 03:25:03 -0700
From: Breno Leitao <leitao@debian.org>
To: Miaohe Lin <linmiaohe@huawei.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, kernel-team@meta.com, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [PATCH 1/2] mm/memory-failure: add
 panic_on_unrecoverable_memory_failure sysctl
Message-ID: <acugba9zIDYTjp0a@gmail.com>
References: <20260323-ecc_panic-v1-0-72a1921726c5@debian.org>
 <20260323-ecc_panic-v1-1-72a1921726c5@debian.org>
 <a88d62ee-530c-1a6e-c05f-de324f940b8f@huawei.com>
 <acp8wYLHDGAfhzI5@gmail.com>
 <d8d2a5ad-9b8a-f0e2-3eb0-ee820eb7a148@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d8d2a5ad-9b8a-f0e2-3eb0-ee820eb7a148@huawei.com>
X-Debian-User: leitao
X-Rspamd-Server: rspam12
X-Stat-Signature: rb3pm44d7p7py16bpd4yyw6czdocbkz7
X-Rspamd-Queue-Id: A333A100007
X-Rspam-User: 
X-HE-Tag: 1774952717-987386
X-HE-Meta: U2FsdGVkX1/FIZRIsIPP/BJ+sXao4p5paBIU14Isd6ZIEmrb7z9LiYw8rfS4cFodTqnccmJP5vx9N82x4cfRWiqTgj3P+n7BHjfGfb/uqk8DcYHEJo9s3eZ4J1sLjQV3M76Uye8eusQkNQUErPIbZT0i+rPW2w69Iy6LMU9mFVYoMQv2X9STHVDd3ETSB5t2PwEozG5us+UUGU/3Wd8okglIROOnqAOPwXutfNfI0kMmor8ob2P8BptaHUq11H36lf9qP5UWwSNd8otuJY4rmRY4eo5uJyueFVYTDia0vAhEfnRUXW/PDg5jOAyxPmevlOk1IlfO899LFBzXASx22m5nfvIZQCiUXVwT1ojTyklQKIcfafR+cEcevGJpMt4WnE0xSsNyCfGXIzMm4SgkEK1HALJpirCja4LFhm0/c1l6NTPuRn7+1mHcSMWLVY0ngdKbEvzEqJHdqH+YBHleGgPxQ9tR4yv7EkHf4GFKjEs8yU/ihbL3AbPnDhHOqT/famvB25aYYu0hC+GPtKf0A/VGpMehe6nRIX9L1tYZUyYo8nSFmjKEn07ONd0ksaSmalip3dTEQEsPc03670LyoKs41nUggqHampsSQeAg9JkJlu6FIwrS/9MXPuwz3t8HTsSkw6FHEZAx4m5we5/UMO5okdpi2iLWwqQpvsA0goRs/uNhTheoGmb+tAiGiQkQOuVY6jxpAWsdH0sS/t3JMB/E6zxN666c29oen8ogTAy6OypDoAA4YDeUl8ruqsO6jZjth6RAEycy7hbA9zjNst3w2LZGrN2LjzQBIfWZy2PeGdx7rbeRzjJutwixN8WcKRV6G709Uez4ERUHV4slTl4Ju48zirIA2EgOaaDVQZhUG7z2sEUdlELGaT25pssfQdCsmloETY7qiaPDeZryVy/ciB5vYRStxS0qj4hJRUkHhP2WwjAmzKHIcYaVrROeN7Yv5OoRKxN8l14oef4
 9BoVO6oa
 0w4cXDuSIGSZYwYBi6Y6Ezpf0SYfCMq15cbYZnWwp3YFMyUMqU2ls/WsfRvIXROpHh0DCj3Cm9+4THOc80mC/psUivVVP8vrUb9Bwyt/daxCc7kkgEQjZUKgLbFtYmgEIX9qVUOA0uxAAOzI8bkIgL93C1pkKKrfsquMgb+jTAqFj7a22u7BWgd74IYyoeEYBb83o1CEuadW8be52LciGmVIgrQlTCgKpbkL74EdNevCKE0adL1XDvDGAMg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Miaohe,

On Tue, Mar 31, 2026 at 10:27:33AM +0800, Miaohe Lin wrote:
> On 2026/3/30 21:45, Breno Leitao wrote:
> > On Mon, Mar 30, 2026 at 03:55:00PM +0800, Miaohe Lin wrote:
> >> On 2026/3/23 23:29, Breno Leitao wrote:
> >>
> >>> @@ -1298,6 +1309,10 @@ static int action_result(unsigned long pfn, enum mf_action_page_type type,
> >>>  	pr_err("%#lx: recovery action for %s: %s\n",
> >>>  		pfn, action_page_types[type], action_name[result]);
> >>>
> >>> +	if (sysctl_panic_on_unrecoverable_mf &&
> >>> +	    type == MF_MSG_GET_HWPOISON && result == MF_IGNORED)
> >>> +		panic("Memory failure: %#lx: unrecoverable page", pfn);
> >>
> >> MF_MSG_GET_HWPOISON contains some other scenarios. For example, an isolated folio will
> >> make get_hwpoison_page return -EIO so we will see MF_MSG_GET_HWPOISON and MF_IGNORED in
> >> action_result. But that's recoverable if folio is used by userspace thus panic will be
> >> unacceptable.
> >> Will it better to check type against MF_MSG_KERNEL_HIGH_ORDER?
> >
> > Yes, I was discussing this with akpm, and maybe the better
> > approach would be to panic for types MF_MSG_KERNEL_HIGH_ORDER and MF_MSG_KERNEL.
> >
> > In both cases, it seems that, the page would not be able to migrate. What do
> > you think about a change like this:
> >
> >
> > @@ -1298,6 +1309,10 @@ static int action_result(unsigned long pfn, enum mf_action_page_type type,
> >         pr_err("%#lx: recovery action for %s: %s\n",
> >                 pfn, action_page_types[type], action_name[result]);
> >
> > +       if (sysctl_panic_on_unrecoverable_mf && result == MF_IGNORED &&
> > +           (type == MF_MSG_KERNEL || type == MF_MSG_KERNEL_HIGH_ORDER))
> > +               panic("Memory failure: %#lx: unrecoverable page", pfn);
> > +
> >         return (result == MF_RECOVERED || result == MF_DELAYED) ? 0 : -EBUSY;
> >  }
> >
>
> Maybe MF_MSG_UNKNOWN can also be considered? Kernel can't do anything further
> for those folios.

Agreed, I'll incorporate that change.

> BTW I think current code can't reach to MF_MSG_KERNEL and MF_MSG_UNKNOWN cases
> bacause there is always a (PageHuge() || HWPoisonHandlable()) check before calling
> identify_page_state.

You're absolutely right. I'd like to address this observation as well in the
updated patch.

Thanks,
--breno

