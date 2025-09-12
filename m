Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D050CAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 12:45:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AE928E001D; Fri, 12 Sep 2025 08:45:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 986588E0003; Fri, 12 Sep 2025 08:45:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C3168E001D; Fri, 12 Sep 2025 08:45:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 795A38E0003
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 08:45:55 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1E5E186E23
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 12:45:55 +0000 (UTC)
X-FDA: 83880570270.13.9BC76AB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6F8F940009
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 12:45:53 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=pi6wWXWm;
	spf=pass (imf07.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757681153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VoP5P5m4UFcgrLJBWCJl2WTnNmypn+YpDH8toV7kcY4=;
	b=pCxrKoXV4YnkpaZprn3RM1mLEKK7jcrSwGXaHk++ClWTVt8WyVKCnHCXxgWnhVKzKhkMnl
	M4KhGK85ErSxrZRKxPPRWzjgOmmbqQiY/iVev4mU18g1g0jq5xisUYepG+scyhjdZj3WtE
	XBkz6b3aSAFIHPZ3ulqGE+QM0kaMldw=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=pi6wWXWm;
	spf=pass (imf07.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757681153; a=rsa-sha256;
	cv=none;
	b=ig8cv0vGOMqYrIEltMKwOyuxoWrZ4aF+qzTWJF91258YpUymeR6VLi3pP8k7fEwBuniSv5
	5HA3sS5svqviCcreMp21h49XUaaYLNxX5gtrdhKtDjsfMHrz4nWuMzNfJsS/93AcOrG0sd
	w2mdzPyvHIt8DfraFVMwBSYDpboiSh0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id ADA7F6021D;
	Fri, 12 Sep 2025 12:45:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDBCAC4CEF1;
	Fri, 12 Sep 2025 12:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757681152;
	bh=lD5ROtoWeAtmKAISXqDN/6McT33HUmW9pjihJpJCvFs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pi6wWXWmQDtPgt2V60hAsaqZj1tVBkAvmTLZ+o3qpgRgmD2p03mdvdELPH70exUwF
	 WYpG8IWw43ziWv9WR/YMz+vytLSkBPhkovit7iN7uZ6iSxIKa/qfTGalJR2rxwyw7V
	 egJY3LU0VybbRWgl6Dm0NyepInCpRe3AAtOyUh9w=
Date: Fri, 12 Sep 2025 14:45:49 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Andrew Guerrero <ajgja@amazon.com>
Cc: akpm@linux-foundation.org, cgroups@vger.kernel.org, gunnarku@amazon.com,
	guro@fb.com, hannes@cmpxchg.org, roman.gushchin@linux.dev,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, mhocko@kernel.org,
	shakeel.butt@linux.dev, muchun.song@linux.dev,
	stable@vger.kernel.org, vdavydov.dev@gmail.com
Subject: Re: [PATCH] mm: memcontrol: fix memcg accounting during cpu hotplug
Message-ID: <2025091216-purveyor-prior-2a81@gregkh>
References: <2025090735-glade-paralegal-cdd1@gregkh>
 <20250908210900.24088-1-ajgja@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250908210900.24088-1-ajgja@amazon.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6F8F940009
X-Stat-Signature: 7h9p5a5ecrkkgp5j3kx79i4dpxi4heyi
X-HE-Tag: 1757681153-25796
X-HE-Meta: U2FsdGVkX19q5uyzrOmTmTkbYmjCbNfQJ/doL5YHuehGKlwhGsRljeHuDuPRD0AiBy2n7fydraAWNLlltAi9MjdGU+gh0QO4icTc+FHNmB+GQVFFWPXP3CXbNb8mjK71YIee25cXgXcn9KNOF+N0YIL3XFcFO2mAx6q2L8LMTprhpqnTHQ13UDv3QnToZM5Lz+pW65xz8ZCnzD9U+EgDzoJ67lLQ6b8BJ+TUWhZ49Valv8/29BaFIdfOJ6PwUEsST0fdfr33urOnDKWx6LUJ5yjGWh+kPWNvqGKmp3l8h3o5415e0TlS21xu41W/HI5g13sO4eeElFgT5opEcM37JR1eAD8bKFEjKxrxdRi06Z3TWhmu1I509dcVkCbJr3jGJ54l5v26z8x/fMqJsVEg26MNSfd2STL0lspDhuA5hxftSXoreA5X7wSLX+tqoQxkEOUhcdpvIyzkpTbylKNiT7OTrw97oOzhcNe2vsZwg3Ur7bcsAfkSdlI7uWYyOtuLgIDMgFwfmZdJ3hNYzMZJs6H4THi4CAqEHoKDgQH34n9EgxMn6iq0S7OCTVKLDAkNs6HwvT2pdMsJkIwSQN9ZxbmqLgPPjPN8gMzoy6C90HOZ7VJFZGJE345qjtzGx9s091s1imR3tXPO4ItlIVen0YH00JjpMZaSEfaPoGmDRu/jxv5QZBIWbIzgNop9PaoCE6qPB1k7AxPUDs6WLTIezTF+TTBpIk2qjJcivo/qD6cwrlIkJ5gjS2ePMXwlwdlC/UtwgOpF19lM9P4q1m6SlRsoL6UoBit1BW9uVRJNuvZsIlU4GD6LZuVR6HVNKwbulnbboMBG/9rzJD0TUiK1M7/0vPQNLB4oORY5SN73nC1cxlTyA6n9gxXzhycg2q6pbmFQzxS3oxEUanWdz+oXcitgtNh8T1/epB9yCHtCEdmkydkMxDD7DQ07TNWhgg8H1wRItZxngN44xwTnNjN
 7W9lucyI
 0sAnx1GE5UvPfBZkYYZckONZtRlMEZWoX8U8zxKuPneNMooHoHFrhdbebVp5oWR0ucqrou1CMujWJwwzPjQZA9rKDmMWsjKhclGDUkPRjYpbuhk+Bzm6WV1Dt+gdD9I97n+L2vb8LKMwqI9yDSQrGaMQRov3nqJ2yyRGqztLId6K6GQB38Pl2WCCdT+Y0/eA826/DxSiZG2mSfC2LFFXryQJgGeVGOwyS27udVF/SA0siW3Vq/LuqULriGIJF/SKCbRlyK9J7KkY4/O6hUpcOk7SOyPkKDPwMRXSiTYDcybWKBX9hhcztuY8VkXlmsGvlwNS8NbPT0xkPHaByoYKDkUVXCCSGfEQXlFOldT9WXmaAaUC8BUxrxvfIB2A9Gl10xkatKZWpfrTvh5FW2ljedql8EPMbzCchYN40ple2OnVAZ8sPbYp9shH1E0yr1n07L2xEzQggnK6dXXuEcvhq3j2ecqP+FHkHfY/Lozup5M0MHiULu/zhytQwqA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 08, 2025 at 09:09:00PM +0000, Andrew Guerrero wrote:
> On 2025-09-07 13:10 UTC, Greg KH wrote:
> > On Sat, Sep 06, 2025 at 03:21:08AM +0000, Andrew Guerrero wrote:
> > > This patch is intended for the 5.10 longterm release branch. It will not apply
> > > cleanly to mainline and is inadvertantly fixed by a larger series of changes in 
> > > later release branches:
> > > a3d4c05a4474 ("mm: memcontrol: fix cpuhotplug statistics flushing").
> > 
> > Why can't we take those instead?
> > 
> > > In 5.15, the counter flushing code is completely removed. This may be another
> > > viable option here too, though it's a larger change.
> > 
> > If it's not needed anymore, why not just remove it with the upstream
> > commits as well?
> 
> Yeah, my understanding is the typical flow is to pull commits from upstream into
> stable branches. However, I'm not confident I know the the answer to "which
> upstream commits?" To get started,
> 
> `git log -L :memcg_hotplug_cpu_dead:mm/memcontrol.c linux-5.10.y..linux-5.15.y`
> 
> tells me that the upstream changes to pull are:
> 
> - https://lore.kernel.org/all/20210209163304.77088-1-hannes@cmpxchg.org/T/#u
> - https://lore.kernel.org/all/20210716212137.1391164-1-shakeelb@google.com/T/#u
> 
> However, these are substantial features that "fix" the issue indirectly by
> transitioning the memcg accounting system over to rstats. I can pick these 10
> upstream commits, but I'm worried I may overlook some additional patches from
> 5.15.y that need to go along with them. I may need some guidance if we go this
> route.

Testing is key :)

> Another reasonable option is to take neither route. We can maintain this patch
> internally and then drop it once we upgrade to a new kernel version.

Perhaps just do that for now if you all are hitting this issue?  It
seems to be the only report I've seen so far.

thanks,

greg k-h

