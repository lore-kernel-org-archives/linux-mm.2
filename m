Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CB28C87FD2
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 05:27:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 081416B00B8; Mon, 11 Aug 2025 01:27:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00B126B00B9; Mon, 11 Aug 2025 01:27:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E89D38E000A; Mon, 11 Aug 2025 01:27:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DADD36B00B8
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 01:27:12 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 79DE8116B99
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 05:27:12 +0000 (UTC)
X-FDA: 83763343104.01.9EF4F23
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id ED176C0010
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 05:27:10 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=x5006o8m;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf28.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754890031; a=rsa-sha256;
	cv=none;
	b=IKUIYzlzVn5RalPVdxISqbr5TYC1+nYbiPuGFrmSiUqJ53pigTA/b/0aPWpWBS9iRrkLA9
	rg1hhv8Hb0X4Wfc4l5dchgu27visgsmloDcL19HQ0ujIBhF+TX1LsDPiY+g1jKLFIOYUXv
	0DLNQAV/rvnuFYW92jcm95MrtdpfIMw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=x5006o8m;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf28.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754890031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sXATakx71Y+0hvKGEFfbask1V0YeM5fQC22QUEA3cL4=;
	b=GGqGmlM4TdBS8HCG0xkOgdCVvmA6bBM29iNoJDDxk079NEX3dji+wWDVRLin3vlP/6FtS6
	dq/OxaQzFtsYmhkq9ADLWjaNouyrRoK6BDNfn6nAcPn3dXCD31qXfXTrtB3lrtpQqJ3MJL
	pHOpV8hdQ/uMUbSDvlNxPEmiONaDwMM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 17276601D1;
	Mon, 11 Aug 2025 05:27:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46AE4C4CEED;
	Mon, 11 Aug 2025 05:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1754890029;
	bh=PnIysY3Acp1ildEXnpEXoKVbY/LKFl/zcs0bwAjrAz4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=x5006o8mbTDS9iEkeI5HdANFtI0hw4MnaKRfRRRKRqSILWZjWq1WOg0fOh5KWZ/AL
	 8VJgMEYTp00xUe6o0hghBu8mPkoYRactd3zYf05M3Zl6tK3VTphd1iTfS4n4LFnyU+
	 TOO2TQQlW7AGTFMKHNCTD0Y/cwBtlxhZsyg3WJ6g=
Date: Mon, 11 Aug 2025 07:27:06 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Danilo Krummrich <dakr@kernel.org>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, david@redhat.com,
	mhocko@kernel.org, zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev, lorenzo.stoakes@oracle.com,
	rafael@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH] mm/vmscan: fix inverted polarity in lru_gen_seq_show()
Message-ID: <2025081158-had-fracture-a5e6@gregkh>
References: <20250727105937.7480-1-dakr@kernel.org>
 <DBYXZ0RQ58Z7.2UBHDTZ2LCT2B@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DBYXZ0RQ58Z7.2UBHDTZ2LCT2B@kernel.org>
X-Rspamd-Queue-Id: ED176C0010
X-Stat-Signature: qjbw6cdjz5dntigap8qwr773uzofcypc
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754890030-66237
X-HE-Meta: U2FsdGVkX1+3FTYQYcTgoXxUE0QBVSSWK2avhKg3121aLG+TLJLdLoWL5lnUZER4DBsUWCWZthPzJKgcv1BqmPcsFj8zZpSgXij6oUYBjcBeILZ6wIkbzh+4DulA1T4/X/vlAy9FY4Q3kAwG01C1RnXEptaOUmpYGHc3x0pKEM1nwpqtJqUWuuz0kGXO7I4SEv9SvrVQml7yCeW3Fr70Ru5r9Bq1aV/0cZ3PrYCiKJ+EckiDhGAHGGzV2FVl/QHw1qKXHhHwwXwH3r0JhtTnGuGRNFYPB63lUHRBc30BZpJplu0qjz39dk+Ou+4x5RNnSpSdGiMW7YGsYXXKFfgwLMmFYdmtDUy8JciCPcByqb4IttjdFgtei3SYOselUdiNNUYrxz3s6nvo6GE6OvKZKiwo4eLwH5BvviDw/pVNgyni1pYDTxwkwOIgaITIT1CH6cSb97ANdj94cx8FB+ZlKHSBiirx5VWtuZRqepaTBpyx+V9vXM7iaYarwxFN2m4pb6PynzRNSE/YCh4PPOZRe4G6/UkD6Ebm7JNybGmyHPi1a04XZsRwhlSLej19EaC13XQTZyA7idTgME9ZAxE91Zfpd1NKbdPNJVckLEUJ1wTVv0jwS5y/D+RbQcMj+IikfqUQ8z4cJNg7YjCBMvH307FLgYzxw7oS6MDaS4uKSrHpHsgtRDwWR57tLGVQN9MjtXOLjpTCWdSRkWhx56mD8gtBEQ90fnf95QBaclEYjjJedoUQRmHPphHlloYMuvDkVo2oXKG4Vhy9hlmsCCRvdQOAEno3/FHcn/JAEIa2E5G1mKDjWYMPmcnC3/4fwjSKmVNJTxc1JyddCJ1kUdsU7uDXODGqRxWXbIB5LrCf7XxHkOxO7QclRv3QJRi8RxAWH/n5tJMqxt7INLinXZtyk1MQiDKeO5OuyjgVlOovYNQtK9+xuw2Qi2EhLrF7Mke0zsFmDaKxyk+qNQE8XtM
 BKJTZ1tn
 6uxJoJxQtHapbaXGuAFDkpt2tNkt/MrG4VG/XGzjMRuIirBY2uVnPlLZwmWmLUxefNKjCb+0KGFzfgxj3pSIzoQRgatzpsVzPaJjICx1ck2Sncz6FrECyI9CE+iCSMW9V438d1Mj6vrAZySj+5gJqpa2HV9tbZouUtl9Hg9UNfakkrhvbh2G4QIpx06fhtVWV3LpvMzheN1CSD7W+PHre5Op1fXBLY2ayA5yDGPPBUbcwVtABT/YRwyJvKpF1dSvs/uE1wynxTEjcOULXD0jGKYdixmWgnzYTemTF063a/BmN6CaRbtrt5BTWAUPpJ6zc66Fl0Y/cH4LORG0IzsvzB6yApD23ktbUQEHCBhhQZrJmWqr3hnN6+VKIRCIrY82HWw8ev/42RB8AjEIfkwnWAZ0ZxGe/GEw0TcCBcUaKZScTK3bcoNvFe750EBiIR4ct5U0aviX37dGcOG0zABm0IccpJwvkvjBdECNbD0vIELijr/qN9tPcW7Tn0Q2+7UilS4YDItBqM2ERuxF0E4oxD2nCl0vfzJ5dCjby7435UxDtI2VufrWsLtvXnduXism0LHci
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 10, 2025 at 07:59:32PM +0200, Danilo Krummrich wrote:
> On Sun Jul 27, 2025 at 12:59 PM CEST, Danilo Krummrich wrote:
> > Commit a7694ff11aa9 ("vmscan: don't bother with debugfs_real_fops()")
> > started using debugfs_get_aux_num() to distinguish between the RW
> > "lru_gen" and the RO "lru_gen_full" file [1].
> >
> > Willy reported the inverted polarity [2] and Al fixed it up in [3].
> >
> > However, the patch in [1] was applied. Hence, fix this up accordingly.
> >
> > Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> > Cc: Matthew Wilcox <willy@infradead.org>
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Link: https://lore.kernel.org/all/20250704040720.GP1880847@ZenIV/ [1]
> > Link: https://lore.kernel.org/all/aGZu3Z730FQtqxsE@casper.infradead.org/ [2]
> > Link: https://lore.kernel.org/all/20250704040720.GP1880847@ZenIV/ [3]
> > Fixes: a7694ff11aa9 ("vmscan: don't bother with debugfs_real_fops()")
> > Signed-off-by: Danilo Krummrich <dakr@kernel.org>
> 
> Applied to driver-core-linus, thanks!

Sorry for the delay, thanks for queueing this up.

greg k-h

