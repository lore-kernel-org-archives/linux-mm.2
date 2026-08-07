Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5153C5AC7A
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 15:00:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E7A16B007B; Fri,  7 Aug 2026 11:00:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 898AF6B0088; Fri,  7 Aug 2026 11:00:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 787DB6B008A; Fri,  7 Aug 2026 11:00:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5691F6B007B
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 11:00:47 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DE9E540447
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 15:00:46 +0000 (UTC)
X-FDA: 85074785292.08.21A8E90
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3CFDE140011
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 15:00:45 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Rs5Q+OB0;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786114845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+h2ntushaSurPWxhUgJp+aSl7bfbjD43fXSlCFyGReU=;
	b=Li6Wmake9qFljqRIgSdHKDCIiKoKP/9B9dqgYDmPBHi3zy9EXagJDVRglNw8diFfev239X
	8tvgPTdLBZ8vAbE1tKV2aj9kZV8r4uSXleEw5zMDMVMyQCdPkBsPbBYO76MlDfP0lK1HNa
	tf25VX87kdyyPGbUrhonzUfymrsisoQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786114845;
	b=Ji9lSzpSiRLw36WQbqTDKXOkJGE2jHQjpDMwL+DX0JJnid/A/MmNXc47Heay4u36JjhxhU
	ocosP9TETh2R8KBjSwuwuVntfOsk91ZdKdHWzS5MZUv+34zBFBMFNiDcA2W5/MukOk1WNZ
	jMB7vNzzpKjC2z/uDirmyjvQxQlz8Gk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Rs5Q+OB0;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 11D6741655;
	Fri,  7 Aug 2026 15:00:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E31B81F00A3A;
	Fri,  7 Aug 2026 15:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786114844;
	bh=+h2ntushaSurPWxhUgJp+aSl7bfbjD43fXSlCFyGReU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Rs5Q+OB0Wx01lvmG7UQ2SWL/oswGIMCb0bGn51z7kxjRXwFCBcpuGPKP2IaSe+L9D
	 qzYpNK01oIbWiVXb5ds9Zqg+ZPVIUhKrjuyD3eWnCLNn5cFzMVxzIEwmiFenJQ/oTN
	 YHVNxIN46KjNUt3awv7QEKwJIrOk+x8Kuq7nLQMFNsp71UVMwIemD3U13IEU52YV0D
	 63K7dZY3cMCV77d61lIF9pvF/dsTXxEvvDZQQ44iYaRUFZ2Sy2I8IN6KQCx1NqD9lE
	 oBfLzt62arVBgZrEjy3qb1fIou5EtMYt/BHlDrYJ3k3/T7gPeHdcQji8x3iXuhU/p5
	 9yB+Z3OouJcUw==
Date: Fri, 7 Aug 2026 16:00:22 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>, 
	David CARLIER <devnexen@gmail.com>, David Hildenbrand <david@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Juergen Gross <jgross@suse.com>, 
	Kevin Tian <kevin.tian@intel.com>, Kiryl Shutsemau <kas@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>, 
	"H. Peter Anvin" <hpa@zytor.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@kernel.org>, 
	Toshi Kani <toshi.kani@hpe.com>, Vishal Moola <vishal.moola@gmail.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>, iommu@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, stable@vger.kernel.org, x86@kernel.org, 
	syzbot@syzkaller.appspotmail.com
Subject: Re: [PATCH 0/5] x86/mm/pat: CPA fixes
Message-ID: <anXyv6CffFFmpDNn@lucifer>
References: <20260728-cpa-fixes-v1-0-2ed2352300b3@kernel.org>
 <anCwUb9lV18v6mfN@kernel.org>
 <anXp--mLLEE2Qo0g@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anXp--mLLEE2Qo0g@lucifer>
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: 7dzftishz9cr1s4etmpoo43mak5seiqk
X-Rspamd-Queue-Id: 3CFDE140011
X-HE-Tag: 1786114845-108499
X-HE-Meta: U2FsdGVkX1+5gYxi5rJw0kjkbvHuexXuGYFU6MU1ySart0WlX0S69V46+0F1pnlXyt4xCyhuHw/tTei/b3x/+gG+k6HC2Gto9/alDgMGiR8EgRDhkVP73jf7hoTfxQtQ4OGn2q/XBC0s5fctKRVDcYkJvwcGfE17uCc3x+9B/uBO9vJFkDsZTlWgxvQJ85tJtpFsPWxnvgGcUdvhpGjehQuWHyPGYTmlEaP7bEe6XPJ1VACWDIln3KEblT7mppxrip77XNNc7up+S/CvHE2m4daLYR6HslVNrZHv3ZuyAUklQHMUVlwCjKH1KllafV/sa/L/iNwTDLGZiOtLgC+gBVJ2QVzfIzX46iigxdXHXhsTR1Aixb9gI3/1uwRzzB3kZPf2j8F1lloWWRbfidM9iny34Iw3jfbBeNfwPlp+DWXobV2shPdjlywpFomYC38o+jSiovVNnywTnsf4PzRRVwQ2HW0y6gBGSR6Kx2dBWpLWfGpyzNB9FwybyQwX3SkecsxafBIRTE+OVecia5RedBExVe/0BmwNCk6LhpyfPB9/+GO+ZipyFLyXFL/VqlWwH5InvYxn/+0HUsqG7w1DLPBKIuad+d8DbGrvgbpMFG/f7FhbLdQDJlUUE09V0x8BJctkYcFtlLnSunydDQf+BNBBFrfjmrozbjmGIs+HxICF8MrW+0Pm3DwX+u6H3UrO6ayQacFrLNfrHVU1TpGxMb7UBS5OTy85nJ6Q27kChoKrIhvTGbIRyh9CBM+vcEybVpq6U07/la86Z44Z8gf4CFNFfBgNS//kw6feRIApjKBIMiXZVDfXmI8mOXBZWqBxY1RgQ/97vZWdpEVMB6nxnWi6rimi54gMoQ/7n7ZmrLZBoRfKniYhgDJtCZHqDltp7mbX+kGRAym++nJoTBH1YwRYu47C1TN025YA4exI1u0bkcsRHr9pQfUrqphgN+hJiTLicwJt2D3WEQR3WBK
 aUwbr2Qo
 IHoDSr8R1h7ktVuYW2A8/zIMnrLVsQU5oYSSkDGNY/4WxHPGuEA27avx7QxkAey3Qw4BdaOeLVze5ehUfplfO8y/vPCN4k1dhaOiQdcV1nPxa2ulWcKeoF/mzwsGocoW2kMnRHC9NRwsJUMMlcNXRtAiqbdP/D7YyQ4ROQtqW3dUSJwHYkkoI5Sy0eCbpdeiMNytJkl0i/7/aIa1s5ZRQq7EzHUfPuwebn3ylxqvUrq5kym6oeNvGU2U/dih4JE4zr0PT0NjUolhKe4d0Y2YyoLfpa9f8CPfxYqawDTUOJBHyQkH7tEODiKj0n4o8ridncZLMz4xEs6UcoYk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 07, 2026 at 03:34:38PM +0100, Lorenzo Stoakes (ARM) wrote:
> On Mon, Aug 03, 2026 at 06:14:25PM +0300, Mike Rapoport wrote:
> > @Dave, @Peter, how do you want to proceed with these?
> >
>
> Hi guys, I know as discussed off-list that you are snowed under but there
> are bug fixes here that are worth looking at.
>
> I must say I'm a little surprised that the series which came out of the
> discussion here has been taken to x86/mm while the actual series hasn't
> but there we are :)
>
> The core mm bits my changes rely on have been taken to Linus's tree if that
> makes life easier?
>
> In any case - Mike - I think you probably need to respin this on tip
> x86/mm anyway?
>
> Maybe worth doing that and seeing if that makes life a little easier for
> the x86 folks.
>
> --
> Cheers, Lorenzo

BTW if there's an issue with it I can ask Andrew to take the 3 of my patches
through the mm tree, they're still sat there as they were originally :)

--
Cheers, Lorenzo

