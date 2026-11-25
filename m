Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84423606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 05:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HlXDUdBs
Received: by kanga.kvack.org (Postfix)
	id 62B1D6B08ED; Wed, 25 Nov 2026 00:06:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DCB96B08EF; Wed, 25 Nov 2026 00:06:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CB026B08F0; Wed, 25 Nov 2026 00:06:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2868E6B08ED
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 00:06:11 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F2E78A0CBD
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 05:06:09 +0000 (UTC)
X-FDA: 85472454900.08.DF341C4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 1F39A80005
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 05:06:08 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=HlXDUdBs;
	dmarc=pass (policy=quarantine) header.from=linuxfoundation.org;
	spf=pass (imf30.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795583168;
	b=kI2Ue3G7dpBXKRO9A61wSj6qTVwczaG2uS61tt7ISDZEe7KRE2gCsD26pQcMoWnrH1Qn5O
	Cqi+v+WQEzJxY4UFTrYbAItvDx06jA5HFqDG0q6+dFUIfei4sgHAs5mibEoA7a0NlRGNTj
	crzFlcz3Krx6JH8XPMbveEnXEn7xDlQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795583168;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Uz/lRB43XRntDAJzkH7ycnHE4dBan8nKXw3o4HGoSjE=;
	b=YLEEPsr56S3rJmGOGC5C7fKv4YOePj+k296nr4cL+51treb9o3DRfg/3AdrasTwWYBzBqw
	juoxi3OF3cSyUPSWaCZli/VhyfF8kxDxDQ3HKRW+oRW7vYORIG6h78v53jtFlOqL3LZWf9
	1eqpriK2NBaqfbMvGg7ou0UKolgmsMw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=HlXDUdBs;
	dmarc=pass (policy=quarantine) header.from=linuxfoundation.org;
	spf=pass (imf30.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8DA7260E76;
	Wed, 25 Nov 2026 05:06:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 392EB1F000C6;
	Wed, 25 Nov 2026 05:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795583166;
	bh=Uz/lRB43XRntDAJzkH7ycnHE4dBan8nKXw3o4HGoSjE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HlXDUdBs2uLBBs/puvB7zu8QlY/VjjLdP0hmISSus30YRf4hL0tV1W2VDoWCetPW9
	 k6GUWglGmvzRaVJf5K/o168KBMpWmZ86xKCVZKu3vATMtNSEABNCV1AkNfvPcjFmBg
	 IOIZnu2BAzE8a3gNJopeLTbH2ZE03IWUZdBhBopU=
Date: Wed, 25 Nov 2026 06:06:26 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Nikolay Borisov <nik.borisov@suse.com>
Cc: Pedro Falcato <pfalcato@suse.de>, Dave Hansen <dave.hansen@intel.com>,
	x86@kernel.org, mhocko@suse.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
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
Message-ID: <2026112533-juncture-skyline-91d5@gregkh>
References: <20261124160025.738362-2-nik.borisov@suse.com>
 <0dc6759e-ada2-461c-85de-809c170abd6a@intel.com>
 <awXBtrPSHfs51Y2f@pedro-suse.tail5790ac.ts.net>
 <2026112404-hyperlink-widget-ff36@gregkh>
 <15d9c032-a8cd-4469-9272-0964e8d9ac9d@suse.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <15d9c032-a8cd-4469-9272-0964e8d9ac9d@suse.com>
X-Stat-Signature: z5q7xxzp8ha63g85zadc1a6u8ridig5e
X-Rspamd-Queue-Id: 1F39A80005
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795583168-688440
X-HE-Meta: U2FsdGVkX1/zyvzTmuoghB/DOaGJhogcwU/cckt81vPJvSoSzmcPf3/2E7NAxvVdFycManzIP5Z+tirDdKy8zlESlLYk7WWtZ/J2I9wagTFo6I2FbsGvUSyF4AUUKfTWMQRI2SicuMiK8lBDk5CiRNRPkXQ1PRuiry2MQSKDqGU733AomN4dls7MQwkImfmP62SX3sKqVdnuln6IeQ+7DMYRKb8refv4KTkswJB43N9FF/02+tDUsuLXkgdFvi2ksbBRWoP2nv454uj1GtT/GFNdckLkgCnAkSUHZu2jh7j8MN0mVqsIi+Em94kT5GP6reKtCQooN8iEQAZLCwPOa2spj9rjGdCrjXevoEPddJnB2Wc3+xbIjs8JkyeiueGHFLj28cpeNNdrnZ4z5tEnQKmTl5OHxvDskKXDCjPC1BXkfCxly+UluV+mI18MxeXXHjJTBnbDvNcXh1c3aGNf3Zzavi0FyeQHTNny5JPaUrogmdeJgaJFr7mJnq7cC8OX2Pe/AVGiRVjEREPyyodXZ3NLS2mE13Axgn/BKWDDuT1+5QaphVNqzz4O1a/Rca7lpqyxBBbfGXVMpGfFXLz5WZkMBlbAHsM0hosXHyOtXu8rwOLG5wx3tvIi3GlI8O/ymUVugu2CtBd0Lm4NU8nA0+O7T1QuKvZWAQQp9CQC3uucxAccLwIFKejVy4N5xadcx7f96TnPfFOkb/lTKQ67e1/XArCodh2aEJzxKYUha1JXWvebTFIo9omAFz6RuMubTZ9c/hzvp2iMv7rRo9f7eP/YEQ7gfQORDqmuJJnw+ZYvJnkvOPvcLa/cFULtKumOZWqkQuurla6THQqNBigUNrlsLAKNGWUZExoQTi4+4GqeSwu1xiH6JjwS8mWKemOx0XBbDw6fyE6KAcnpPBplgK65/f3jM47DJpFtw9XCttY2BRGLx2MdO9q6K4tDQTK0nOI+SrE+0qQO+J/XiXz
 h8pAwavs
 Cvw5o2SlVM2gGb/415kt9ZOKdaUML/9scK38SDRr9hqAlwp1y9k0zrxDrtD4VHyiJmg6iGoGyvGoltECxo7mCYNw5LjtD2kMKwIqidfREA7RjqHvD0g/E7Eq3B6vVcfJC6Syyn7ENddWczEMRKh7o2CGzXOVpTHQ9aCOU3wlZ6ek2+3cwQJCAhRRnJ2ZH+yTKzzHsaMf6J4XtsvWwW3raJyx/qjFA6L/+PJQ/c3BRTMYpXjMc+qpelY5w+dHpvKLbbfFH88piVKJZjdis7PIN7/ClDtABuWWEtz1kWopNKXFJfhpZgsYm0FUwRQCGRqL+18M34baEI0FBsLInhA9SW7rq7oQZHQ+bT1Nmlj+EZGv3lPnjxi3h0vJF+szcD8HFF8xehmkbhzI/9r3ddEga5GIaFF8JWJ/PUMnhSYFwDzSK8JEd5xbKsHr/YNTpKWZSFAxUIvkiOOU6w+9RexJ/FxCLVNNa9EHI1WH70hcOb4ADT5av/muAL4eFD5l2habshPcuHdaYdX7bPkU/9MzqbhLC/1UMDWF5cTkTm7SGLKOTIvQW9xU8j/aWU9pnW4r/dMQY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 24, 2026 at 07:53:53PM +0200, Nikolay Borisov wrote:
> 
> 
> On 24.11.26 г. 19:35 ч., Greg Kroah-Hartman wrote:
> > On Tue, Nov 24, 2026 at 05:10:21PM +0000, Pedro Falcato wrote:
> > > Holy cow the CC list is stale.
> > > Fixing some up.
> > > 
> > > On Tue, Nov 24, 2026 at 08:36:45AM -0800, Dave Hansen wrote:
> > > > On 11/24/26 08:00, Nikolay Borisov wrote:
> > > > > Resending this with the hope of either getting it accepted or
> > > > > arriving at a consensus what exactly is missing so that I can take
> > > > > it from there and eventually get something merged. As previously
> > > > > mentioned this results in real problems for confidential guests both
> > > > > on TDX as well as SEV-SNP.>
> > > > >   arch/x86/Kconfig |  4 ++++
> > > > >   mm/char-mem.c    | 10 ++++++++++
> > > > >   2 files changed, 14 insertions(+)
> > > > 
> > > > I'm still OK with doing this.
> > > > 
> > > > But I didn't want to sneak an mm/ change in via the tip tree. Any mm
> > > > acks or naks on this?
> > > 
> > > For what it's worth, I don't love this fix. Yes, it fixes issues in /dev/mem,
> > > but it:
> > > 1) skips any other potential problem spots (I don't know which)
> > > 2) open-codes random CC checks in mm, which is kind-of regrettable
> > > 
> > > OTOH, it's unclear to me why that CC check is needed. If configs select
> > > STRICT_DEVMEM and IO_STRICT_DEVMEM, shouldn't it Just Do The Right thing?
> > > in iomem_is_exclusive, etc. If not, could the CC awareness sit there
> > > instead?
> > 
> > Yeah, why is anyone letting a CC system access /dev/mem at all?  That's
> > ripe for abuse lots of different ways, so I really don't like this
> > change either.
> 
> You are missing the point, this pertains to /dev/mem in the guest. There are
> a bunch of libraries (libhd for example) which reads the first meg of
> memory. This causes the CC guest to shutdown in both AMD-SEVSNP and TDX
> world.

Then don't allow those libraries to work in cc guests :)

Again, why would you want anyone to access /dev/mem/ at all in those
types of situations?

greg k-h

