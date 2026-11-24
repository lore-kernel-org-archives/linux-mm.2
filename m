Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8EB5606A329
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 17:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bbp6WT8l
Received: by kanga.kvack.org (Postfix)
	id BC1EF6B0807; Tue, 24 Nov 2026 12:35:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B99626B0809; Tue, 24 Nov 2026 12:35:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD6D96B080A; Tue, 24 Nov 2026 12:35:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8DDFF6B0807
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 12:35:42 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 108B5120AFC
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 17:35:42 +0000 (UTC)
X-FDA: 85470714924.10.088FBFC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3DE8C12000A
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 17:35:40 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=bbp6WT8l;
	spf=pass (imf29.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=quarantine) header.from=linuxfoundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795541740;
	b=7XTway5hf1YLxdsCGTEhGj6veZJgtojQ38I3nDvxG7aUNHoNHdHngIntgGkoWIPfYt9lCY
	sCvQqVRTvD/lvIaxXYARcuvAi5ms9/Vd3sksUjxPvJ3YVLlO11m/vx7O8SwNwa1waixzyn
	t5xamF93qMZXLQBjWgkmiezKHiXEGEw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795541740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EOrjpQJjfBkE4q8XiTb4DK0inCr3iHWjs8GQJ6hksQA=;
	b=ZeC4jILWugqLntCqmw7SEgp6m+Znv09iRXNG1KehwEyEHUi/VZYiA97/VuREkOjSxPeOHt
	q45XLiTFZzX75U9T9XW8gzXo2WO+Wb6XVYfmFyVWu9pnHk1AphHYFP6ogR1rV/5j5uYzyj
	m4ab7JJZ6zpj2kqoOVodQau2GX/fSEw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=bbp6WT8l;
	spf=pass (imf29.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=quarantine) header.from=linuxfoundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 689874167E;
	Tue, 24 Nov 2026 17:35:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 805FF1F000C6;
	Tue, 24 Nov 2026 17:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795541739;
	bh=EOrjpQJjfBkE4q8XiTb4DK0inCr3iHWjs8GQJ6hksQA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bbp6WT8leTC+EudoAXk+7oAE3ZQiSJAbbkOEDFJ1Cyn+x/eHFMCRiDItv//5oYvRg
	 sm9eU6d0mbBH49Qv0vE4Zw0AxRReqykdGC9Eh2QJap+PTO2d26SleVdt71fcZRDu8a
	 8HsP2XZbn5aNufzOHtqI5eiyzmGrnWcgKO+9npc8=
Date: Tue, 24 Nov 2026 18:35:36 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Dave Hansen <dave.hansen@intel.com>,
	Nikolay Borisov <nik.borisov@suse.com>, x86@kernel.org,
	mhocko@suse.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Dan Williams <dan.j.williams@intel.com>,
	Kees Cook <kees@kernel.org>, Ingo Molnar <mingo@kernel.org>,
	Vishal Annapurve <vannapurve@google.com>,
	Kirill Shutemov <kas@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"Naveen N Rao (AMD)" <naveen@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	David Hildenbrand <david@kernel.org>
Subject: Re: [RESEND PATCH] x86/devmem: Drop /dev/mem access for confidential
 guests
Message-ID: <2026112404-hyperlink-widget-ff36@gregkh>
References: <20261124160025.738362-2-nik.borisov@suse.com>
 <0dc6759e-ada2-461c-85de-809c170abd6a@intel.com>
 <awXBtrPSHfs51Y2f@pedro-suse.tail5790ac.ts.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <awXBtrPSHfs51Y2f@pedro-suse.tail5790ac.ts.net>
X-Stat-Signature: pdxhia4orgytktsgwmfyd66tzw9zqk7m
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3DE8C12000A
X-HE-Tag: 1795541740-131730
X-HE-Meta: U2FsdGVkX1+MLT6Nam5cvximp4cWP5cAyeWfmJjVdhmd9KFLI9hUdqY3VZ+5Sg59A8r9q/9DyrbSsbc1MyHKV1ByMyGj46eHqoocrVHypG1Sfl5qjcEYLoZqEprY6RJsJjjkrEwb48WVt6BbZXChkpcbTt5bj8YA9CVzsKI5UUHraWynqX2FL8HInmunJuLa50WThDyqwFvhDNE8/r6N5EfUlcFQYTV56DxyLDXrRcvQdYxfofIhBcyuqrH2NvvIcvui0bFxzFmyxovDOVX1CRuP3aVQ728ywY5yfiLWfBDBIhbXOaN9N6atYEiG9yKy4fM5nfk7BXuWmRbkaxh1Tlym1SFXGHkeqllw+A520kV9MeiP7MSfyl0PhdNs7zMVq6nI39geiEdAGKInThG7X1/VceujgM1jYiLmIPZkwlKP4sMNNgft73v8p3peWeK/pC+sjBi4lScw7nzOTFQQAsloWh47xvZFxCcSft3XnHBSfZHOfjoY0pdFlT1ZvudpumZ05DdJ3kjsC88Rcl7kLDJmTbAWIq7YF8eC56AHyVLE7msEL4lvFTzw4D0f47r76ipCik4lLZeFS2HdNG5EcH3M3MZO2ySnIz+jmdTx2c3Vkr4SzktYZDS0yCbtqmqzkO2ZwY4cSasJw9ZTRoMB1C9Zu91UlMZCgz2qA/ZkeklS0cdFPyEs6PKKqv4TJKYZq6E4NXO95UPWFeiYGb5060GsHlKJikHRn+z2EHRN5yhvKR1Y/qTjX5eSOsZa3VWm5Vebo2aJgwCtp7m+VVbVSE+ai5DXWI+fIlmimWHjfdXJ/cB0cyINcTIpimG8dxN5Svju4N0y7LTx0xaVkxuGUrz4JRAWDII6sve6eh4z0Id9pl6Z0wVKCylpB6goxfU3D5cH8ZhL8Rs9Jr+oh6inWSsZTFNBJmUje/YaAjamIJBeC6shaTIu695lgEHsDpvT5PtMmlHeQSXzivEm2tw
 UorUnC2O
 b7YAOsADLUPRMy6SRC7TVbma7W2MHgBI0aYap0/lmYOV3Chg9DOuC1ggaYN+XGteleJRLcu0OXLLIZdBTjVd4xCX6/hDR+lmxMNGWg9gF0b8+8Wz/gSQMNADGIcpbAJPZRWY2Kc7x+/lbpitVJpkTLHdD6tWKR3XMUXEbhVyX82kJCsNzfp+PIQheXXcqGL3Vg1h1AeCL+FYw9f+dwoZ7fLV4sOLfzSf1mt8GvKpZhusIpHep9K5jujFdROWnINVXcUR8K5s2RS70XbrBq4wku7G/S2rous7uil4QQYt8Imu1OKRHriiorc17G2DDqVLt8qq7LNYBfjat0+Jtjj1JUhWe9XAiQLl0EfwIRatDV5BnbtyHbgB6X8dsoeNLtddVlxCAjdrxODuFcaDzuPMsjcFa2v/2hNjlVmyGxonofVJYjb7+8w6ydugpIn7lYk7fN+tImXBlhfwDrETprsTY5CE5mKT8hTbkQeQ+iTdp/iSEbXboqj1ufHAnVw5Xlx47K/O/z/7i4nDm3czmmYd4/D0pOk72SJgfEc0ftKQk609qKYg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 24, 2026 at 05:10:21PM +0000, Pedro Falcato wrote:
> Holy cow the CC list is stale.
> Fixing some up.
> 
> On Tue, Nov 24, 2026 at 08:36:45AM -0800, Dave Hansen wrote:
> > On 11/24/26 08:00, Nikolay Borisov wrote:
> > > Resending this with the hope of either getting it accepted or
> > > arriving at a consensus what exactly is missing so that I can take
> > > it from there and eventually get something merged. As previously
> > > mentioned this results in real problems for confidential guests both
> > > on TDX as well as SEV-SNP.>
> > >  arch/x86/Kconfig |  4 ++++
> > >  mm/char-mem.c    | 10 ++++++++++
> > >  2 files changed, 14 insertions(+)
> > 
> > I'm still OK with doing this.
> > 
> > But I didn't want to sneak an mm/ change in via the tip tree. Any mm
> > acks or naks on this?
> 
> For what it's worth, I don't love this fix. Yes, it fixes issues in /dev/mem,
> but it:
> 1) skips any other potential problem spots (I don't know which)
> 2) open-codes random CC checks in mm, which is kind-of regrettable
> 
> OTOH, it's unclear to me why that CC check is needed. If configs select
> STRICT_DEVMEM and IO_STRICT_DEVMEM, shouldn't it Just Do The Right thing?
> in iomem_is_exclusive, etc. If not, could the CC awareness sit there
> instead?

Yeah, why is anyone letting a CC system access /dev/mem at all?  That's
ripe for abuse lots of different ways, so I really don't like this
change either.

thanks,

greg k-h

