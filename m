Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E94C1CA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 13:57:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87B04900176; Thu, 14 Aug 2025 09:57:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82B79900172; Thu, 14 Aug 2025 09:57:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 741AC900176; Thu, 14 Aug 2025 09:57:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 60302900172
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 09:57:04 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1143711787B
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 13:57:04 +0000 (UTC)
X-FDA: 83775514368.17.CAA20DE
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf02.hostedemail.com (Postfix) with ESMTP id 74B128000E
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 13:57:02 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=Sojiv3Us;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf02.hostedemail.com: domain of gregkh@linuxfoundation.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755179822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XZQ+zKi1BJJZsIYK18V5XsFCGcBFG5Hycvtld+r5Tfg=;
	b=j2GEYyR/Uuv0CevpYY5rgTxkKOX+cMkgU6GMvKLwcl8dgSfEsgNKjhOj2G6UpuV8S5DRw9
	lAvTZiuHKL68JuVuSpcpvMSDFBk/2bAUfj5Hr1/1SoLe7mSGwJNad9NnRFD4oOUryiyYii
	SjoBmHu8oSJxsZ+AvryFbd/gGN/oBCc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=Sojiv3Us;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf02.hostedemail.com: domain of gregkh@linuxfoundation.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755179822; a=rsa-sha256;
	cv=none;
	b=D4xjTu26y59fVTe6PNElUayXFg1MJ/eCneD25tboNYGXE3J3DZwwIUkt+pHfAvcqs4eCrP
	aIRvwwy1TNW8DCJptsvFcRMBS1LkEmM7eduN+b5K2Kj97rQUipwvobRhvqnt7Loc5sTqMi
	BEyndNELRN23GmG2qc92PCuZyK/KO4E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id D5B0EA40433;
	Thu, 14 Aug 2025 13:57:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F10AC4CEEF;
	Thu, 14 Aug 2025 13:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755179821;
	bh=Q7mbc3OIpQaPF8obJ8icgwvmlyAtL+TbGOLtiSQZ6es=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Sojiv3UsybtdunXpyA0Crttz/b1pWBG0WsE9lbXRXbLa9LCyn+5d5BrRFyAjTLPjw
	 2ktGP9YHMe450uLz1StN54N7defGdpcppvziO6onfFeQdJxq5jRP5EfqmdPEeWJobD
	 RSs6hrcrlcHYtGfeqQJewvrnIxTK0VHuvTSzvjAQ=
Date: Thu, 14 Aug 2025 15:56:58 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Gu Bowen <gubowen5@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>, stable@vger.kernel.org,
	linux-mm@kvack.org, Waiman Long <llong@redhat.com>,
	Breno Leitao <leitao@debian.org>,
	John Ogness <john.ogness@linutronix.de>,
	Lu Jialin <lujialin4@huawei.com>
Subject: Re: [PATCH v3] mm: Fix possible deadlock in console_trylock_spinning
Message-ID: <2025081450-tibia-angelfish-3aa2@gregkh>
References: <20250813085310.2260586-1-gubowen5@huawei.com>
 <20250813155616.d7e5a832ce7cda7764942d10@linux-foundation.org>
 <f3e631dc-245a-4efe-98e5-cbe94464daec@huawei.com>
 <aJ3f05Dqzx0OouJa@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aJ3f05Dqzx0OouJa@arm.com>
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 74B128000E
X-Stat-Signature: r6ts6asim7pn7xuz1toq6smyszf97jtu
X-Rspam-User: 
X-HE-Tag: 1755179822-418476
X-HE-Meta: U2FsdGVkX1+fZAXPKf1/fRq8mcNX15uWZSpA836+oQT4lEzM+v5nIA+4kdwcDegZfvPGOYDrB+HxNlo8J8VMAK8EqDkYYbtA0xO+R6KzL9XQevTPiCtT3HmI1Al8hn+UsuFecZd7yI63mQLNWVn40YAozrrVh/KIJ3UcH5w8SE+7DJRbjf3e72pkK1sESM89xQLJXb27YGip/Iuv0xXStEXPh3zFPUhxZOmb61JgLc2Z0oTQkJGj0hd6R7HwwekU+BsK9EPIFE3yVFdlWX/86sRiwL9l7o46+3eHTNrsCSYR8cOjnAk30kd6ssmsgjbVVOcwHCas4NiNB1+Mp1oCRGrP4KGA8CzoUHIlLtfd1xQs903609TNYh37S08Ix2XCcHly92i2NGo+qyfIbHD0fS/gtvihlEmHJf0Va3u/uan/EucrQgwmO/4qNOLpnr7l+3Wr5gJiEX7Q1e9FbLxpnw48sCvVJ/JbyTZXDAJSoKuVsX6GFBtn+EOJ1cTfdweC+XTD7H/TxEHoakc49iAT20qWnvwPe85rPbbnoe7yL9oQdlnCxJ7jsxSCyHFHSRKwA+6WQ5cY4UfmIEP8aPuyMymd16XhmxwiNH3dDp7e7QLoyUMvZcCmMyU9Czcqwz4XhzqPrce38/C0+T+xzqC2ST+f4XmK6ctjOZ6TtsqkDsc1O7dSKhcENPInA0e+sJZiUaFdF11Ln7bUWntS6jv81nfzp+/jqcVXODDVKhEGMUCtq9dSl7jUzHoELtQw+KfAnS+aISE4n3XdKSQiUtzLwfdXTdgtU8bj7H4jsnZI4ez0mFJkwhbMggQTimehN1DMNrue35s5E9D4cItJGzszpqIinA4mCI2t3ZTJ71SdYykh5pWKdHWM08qZ6V4Vgmbd37l0GZrdS6E/TEikN/6ujD5y6PCPyjSda292xzJbqhbu+Hg7DOa7YilFZvtRy8f46l7TgX4YJBHyei0ZL0s
 WTxeJJDy
 dJ3ZRvojLfT8fo7rW8YYsJNENAgpRGDzCLyZq9k2u6BfAWfHnLF36pWYpTZdC5+kx5z5hSmVz6ia+8tboJVI/d8qijS+plX4PoTG6nY9VCfy6yGpjCh3CC7ViHHY76EziqKct9CtoYrfwvKNIgWGa26bAfwSxY8pCUuZ6SMbVM9ImI4akLlAP1ss+1xDFagn81kXGpgXUf2H2tO0kpdFOoJppayrCQLVfdwhbi+z/0x4Xuz5lPxdZYua7K0gllTRxL8QESkN2SLYdbRrW0KF0N1bywHyP5zgMREyzGhGg3/JqUy2LOohBFuGKX459+PNLT+9Pm8F+vcRPecJ69KdTO9MtKRq3J/k1sjrMX6piiaObxQWvAa1ZWMTh/WsJpzrcyaLx2S7POWin9us=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 14, 2025 at 02:08:35PM +0100, Catalin Marinas wrote:
> On Thu, Aug 14, 2025 at 10:33:56AM +0800, Gu Bowen wrote:
> > On 8/14/2025 6:56 AM, Andrew Morton wrote:
> > > I'm not sure which kernel version this was against, but kmemleak.c has
> > > changed quite a lot.
> > > 
> > > Could we please see a patch against a latest kernel version?  Linus
> > > mainline will suit.
> > > 
> > > Thanks.
> > 
> > I discovered this issue in kernel version 5.10. Afterwards, I reviewed the
> > code of the mainline version and found that this deadlock path no longer
> > exists due to the refactoring of console_lock in v6.2-rc1. For details on
> > the refactoring, you can refer to this link :
> > https://lore.kernel.org/all/20221116162152.193147-1-john.ogness@linutronix.de/.
> > Therefore, theoretically, this issue existed before the refactoring of
> > console_lock.
> 
> Oh, so you can no longer hit this issue with mainline. This wasn't
> mentioned (or I missed it) in the commit log.
> 
> So this would be a stable-only fix that does not have a correspondent
> upstream. Adding Greg for his opinion.

Why not take the upstream changes instead?

