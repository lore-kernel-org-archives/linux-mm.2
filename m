Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18B601073C93
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 12:52:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BA216B0088; Wed,  8 Apr 2026 08:52:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66B326B0089; Wed,  8 Apr 2026 08:52:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5811E6B008A; Wed,  8 Apr 2026 08:52:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4895A6B0088
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 08:52:30 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E104E140AAC
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 12:52:29 +0000 (UTC)
X-FDA: 84635377218.12.8F496B5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 4735CA000C
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 12:52:28 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=Od6B71TE;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf15.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775652748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NSc3orVIihfB6HH+EJovspyaX9WDVWv+3uztoWNhFcQ=;
	b=sthT5FoFHp/atqM1DK39GfRgP7hdq34pYAQWWJU7OOqvFnJcbjzHzv2yteIFrndD+3/iMz
	sgj12vG6siKy4e+4NtJp1SeHUtDTzyef4/B4+rsT2TLzGnVUSXshKcFyCSlDDRgF2RojxP
	Qde894f+GjfueHqodrjfvHVf/3GVUyI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775652748; a=rsa-sha256;
	cv=none;
	b=VNMQqQEB/qC8eVoqaP9xylB//mZ8vbBHFwbcRBhh1HnXVtGTNYL+/zvP1Cd4QgBTB0k51J
	dRFmCZhOHJGdlHvld6WQ14DJJMpJPI3iQBW7OMMpUlssTpTcWu6VjH7k2WZRxg0IKka8uG
	I//yuqWr1yGGZOibRU4C4QScLh1BNKY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=Od6B71TE;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf15.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 97BB9600AD;
	Wed,  8 Apr 2026 12:52:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6F1EC19421;
	Wed,  8 Apr 2026 12:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775652747;
	bh=pI38M4TIKVe9bBgloxuZeTwodJ0BBnK5L95Fxg6BN3o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Od6B71TENC1nv7URJ7PCOcItPI5OsgRz6eFR6lVg6CMp2pQMXSlit1YlmgJgggN95
	 8do93KHQk5pYtW0PSIB90NUmiwG9u/Rf+CRb8SzPz2JmVRarfbf3BNIxLI0JpyZm0Q
	 C4PuYzl8Qd7OHAupF58qKo/fb3HFo3UvkzYxv84g=
Date: Wed, 8 Apr 2026 14:52:25 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, stable@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>, linux-mm@kvack.org,
	Jane Chu <jane.chu@oracle.com>, Harry Yoo <harry.yoo@oracle.com>,
	Oscar Salvador <osalvador@suse.de>, Jann Horn <jannh@google.com>,
	Liu Shixin <liushixin2@huawei.com>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Rik van Riel <riel@surriel.com>,
	Laurence Oberman <loberman@redhat.com>,
	Lance Yang <lance.yang@linux.dev>,
	Miaohe Lin <linmiaohe@huawei.com>
Subject: Re: [PATCH 5.15.y 0/6] mm/hugetlb: fixes for PMD table sharing
 (incl. using mmu_gather)
Message-ID: <2026040846-curable-portfolio-0bba@gregkh>
References: <2026012608-tulip-moisten-c6f6@gregkh>
 <20260218110129.41578-1-david@kernel.org>
 <c6f63b74-d532-4384-a1e6-2b0dcb7b5303@lucifer.local>
 <2026031222-vacation-cramp-6fdb@gregkh>
 <c6b9712f-2f23-43e4-b270-dd3a7371e57d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c6b9712f-2f23-43e4-b270-dd3a7371e57d@kernel.org>
X-Rspamd-Queue-Id: 4735CA000C
X-Stat-Signature: chp7kswynb7b83hazrcq8o5nres7dq5t
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775652748-605329
X-HE-Meta: U2FsdGVkX19+17yEFQrAOlRtV/ae4Hk0Ovnb04uZfUaGWl60IePHqAnzhx6aQ7s12RLDMO6Qaqplu5vtkO86iEgYujXP5U7U/vd/IHr70jDRljQXMMni5faALt7fx+ggX51TT5ZUqFnGw5LOdyFYIHeq87mvBIPll7lSUYXgsF8lLrN4DPZZN/fd8JQtmgIXW47t6qD6pm9sJNarDtcxooIS/3GbC/B49PIGhsePTR0c2qMWe9Krng5wFYvhIOuMaQlzLVDDCIAyFwlaNnuLOMuWfIqKYN2w57JQ1GWl11Sulgu/CSSADTGknZnWZjt1qsITw8UInOSTLcdixPf71mGpJpkqTzk5HOvvS7MPjRbZ79SvFKo47OgzpVT5/rZ2Enk6fLue3swnVEu1k8LJjTFwYWFNvyLtJvnhI2mzivCWYbVLYbW0TNPaBBSzexVvXPO0sz38vCEkMcBHSO/2LA49vv/pNfEygnffq7OTtIhRYKeH434Ob4x7/jtiHm3ZNMXiuist/W6bFTwDnKpVHDVafHlLDCOiLqKXJBLFNf97sN+5vHmgWnZWJ5e4nMk4zKqTOyvvAiqZhx9UENSoxJSqUt9m4PgD2xI2C2NARaKC728SXtLYB5TtEb0ZmljD7pSF3NDarEWgCco3I0V4PZ5YcSwZot+H/SpiMAwIIxtUftzijsPi096rpHMA4o14gB/cIECZlVVykUau5BCRHqTyu/1hZzRuY1dT235UsQF9D7xMojrK2o5ZOjDcAYn/QLYum8aSU7XJHdY9c9dT+7EpRrwo2VisWVaLZq9Fo1vfcU+a1GLfarWs5wQK7qO+iR87co8ofBWMmlQiUdAjTFpieY4mr6Yx/SacyHv+MRBZuk94a+swg3ukTpNhj1Zs1G20v5ffZntC7qjMjRq6LO7qM+/5Jjmvz3v3bBwbJlOc4SAj5QaJDx9GUd9fKILtOiHZn0H0H/Ch28eKRuR
 jAdNiIB5
 E/hBismWTblCxwsTXC54xd0XmWj5q7fCPO/TyHTCc4MCMIZYbIdM723m38r9E6QdmsUQ/6sbbWupr8NudmWYHPT/IkSynLzjn+jAfO/0lmStcv160Y3MC1L7Eu6PbyeK5sQQRDINrrVnHMklHgLA7AeNcpTVI9k0+g41/a+aUUiujEFvWrxvJu/a4+DW3+qPXJa8eMUMiXFpao47MTdNKkQJYGpIN6nyEgzUa9ty/lm2VajGKHZm6iX7YKEI9SVvPJkEaZc6uc/O+ZR/Rw7mtLq770WLRxH1i8JTbtDO93zheLbwwu7AXxlVroNXVB0BfzWMRMVnqNj2ZD9HQffsDnQNYHRzZEcLJCZ09gWAFbxvP1VpYFBD2q0k7mA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 08, 2026 at 10:00:44AM +0200, David Hildenbrand (Arm) wrote:
> On 3/12/26 18:47, Greg Kroah-Hartman wrote:
> > On Thu, Mar 12, 2026 at 05:42:13PM +0000, Lorenzo Stoakes (Oracle) wrote:
> >> Hi,
> >>
> >> This series was sent a ~month ago, is anything holding this up? The underlying
> >> issue is causing a really serious regression so it's quite urgent to get this
> >> pulled ASAP :)
> > 
> > I see 70+ pending 5.15 patches that people have backported that need to
> > be queued up as well as the pending upstream patches.  During the -rc1
> > cycle the stable trees get flooded, so the older kernels take a while to
> > get released as they are on the bottom of our priority list.
> > 
> > We'll get to them "soon", they aren't lost.
> 
> I assume that is still the case, another 3 weeks later? :)

These are all queued up now, right?  It's a matter of actually doing a
5.15.y release, which seems to be on the every-month-or-so cycle as
devices relying on this old kernel sure are not used to updating very
often, right?

thanks,

greg k-h

