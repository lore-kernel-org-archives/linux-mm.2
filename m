Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FEB0606A328
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 10:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EeMZhO8D
Received: by kanga.kvack.org (Postfix)
	id B4F7E6B00EF; Wed,  4 Nov 2026 05:40:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B00886B05B3; Wed,  4 Nov 2026 05:40:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A14B96B05B4; Wed,  4 Nov 2026 05:40:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7B46D6B00EF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 05:40:35 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0C5B41605EE
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 10:40:35 +0000 (UTC)
X-FDA: 85397092830.20.C80F565
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 68D2E180003
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 10:40:33 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EeMZhO8D;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793788833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OHhrH3mVCZL9F+uul7Pko5LwqezUEkg/0ds9TVqWkW0=;
	b=8XQAt1L/AEPGUiWqJ6sng9UYGIMzke/56CADVASRKoXnxjexUCKKP2HOi5KfclzzQq9wzs
	o21YBnXj/o2vdDV6IR7B/EZ/PW8vS/sPWUjRC2A07Uza+gr5ZuWCI8Bz9C7cGJqY2m1u49
	eQaMUDyHqXikD7WlEx2Rb2u6gZb/aHQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EeMZhO8D;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793788833;
	b=8L1BBBnznnJswDmTclY1dDyMJzbMzmoRuhYI536VmrKFlOCzz4v6sDIjccVzuvUN2yFMPz
	AL7MJrLy7OL/oaGdB8BJvJIvDL2Ig2d1K3dFNy5bGmlqDB11KTeiasX0f70VfMbgbYLfX4
	OuHDALNKtplYIqWeh1Zhdfk7CEwPI20=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A33E941926;
	Wed,  4 Nov 2026 10:40:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 962121F000C1;
	Wed,  4 Nov 2026 10:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793788832;
	bh=OHhrH3mVCZL9F+uul7Pko5LwqezUEkg/0ds9TVqWkW0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EeMZhO8DjG4Z1LNGDG6wdfrR5/jvvahFgvuj3m7HOQrS5HMxi/U+6lT8CdBS1mQBG
	 IC79mPKN5pooYxKGcfp/3nadOdWf8Fym3XSVAO968hO1SW6hTg6elGvzxmkBPwmNaS
	 v9T63ChJrQAQbad0an5kGXooCbmvv9MDXmPvDoorGg+XyLiYGBnkViAIHcypGwqbpJ
	 ppQezfycclcHYH/cH5pj6vY3QPZi1ua1tE+LaTlont55dEIEeB+v8CFlcxuVMlA3hL
	 myTh9yVFL8UBjo6Snz+ghL8sE2j0/RkU7G36RxL7WrUdRykGnhNHAiwYwIXZ3Ksf2n
	 rYu3AjolMYkzw==
Date: Wed, 4 Nov 2026 12:40:16 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Ard Biesheuvel <ardb@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Oscar Salvador <osalvador@suse.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	kas@kernel.org, kexec@lists.infradead.org,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	shakeel.butt@linux.dev, linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-cxl@vger.kernel.org, driver-core@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, rmikey@meta.com,
	riel@surriel.com, harry@kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v6 3/7] mm/memory-failure: add hwpoison_boot_page() to
 flag an inherited frame
Message-ID: <ausLkNhb8ZPz0ra_@kernel.org>
References: <20261016-hwpoison-kho-v6-0-f304255147da@debian.org>
 <20261016-hwpoison-kho-v6-3-f304255147da@debian.org>
 <aumt-4kfGGtoXuh-@kernel.org>
 <aumvVjoHo4KeuyEp@gmail.com>
 <auovL7i1rEcXCeGS@kernel.org>
 <auo3ScXy6dk0Gr3-@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <auo3ScXy6dk0Gr3-@gmail.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 68D2E180003
X-Stat-Signature: gttjiroe54sbcs1zp471r9o8pc86wmx3
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793788833-916117
X-HE-Meta: U2FsdGVkX1/jWLIQu76aYC9TEhtIjQ5ai3DzH+rnz2LeBiGudLrse68LFppaEOxN5AT8G8MpyGxtdM5XcsEGiNqbfzKe2tMdbCPHQn7o2eXjzy0+yyERuHlMeYEznTwk+smzrPkCbczjgrZaQOUBSj5E4jUvYUb7muK+FdOU6rs3xxfz4pp3+1s11w7oqbIuyhtcxtB9Flb58VB3I+UwGYWVuK5dC6NFj49SKit22EtRzBLpReQpfMBl1xVVi7atUjlGSNmLFJBTnRNV+GbpsNaputUqd0eeYHa0Yium3BImvUP6cUV8AZmySD6nStyMk9YTzAAFwgLylVlUtxM/i9Ym49C0bhZ6V4AcACpUWhoAFEpndiTqUEeo258kmNCZQ8fAaoKw6TNtR9T2bpAKEwu5r2bjaYeCJJBpPhO7pSAU8Ieux2bnaU/8Z5paUxu64JlSOxLkEyXxDDUcR5NeTHoTQRGjwNf2P+UAcScAx0hvfXXCXWtSAQC+lCVfesOzFPNNCQaJ9VNy6Kx9zqZLdbBAryfAUO8xrL9B4jtHPHDUL5CWtgQgVY4F39VcjtEioPSdV03RHT+pNcyYFhhzomep65fLMYE5JUy/9SMfp2n6wVZWDrQyWgpncRhWEbpjzKYmf2m2yeHdyzCX7i/4tlaqmG6iDBIH1EaIMgyI9dTHu+ZbpS9seo1fYXdmug1rICkP+AM9hxcwL5hDO0bxsNWmfe4RmetQQkLHoEsvDnU+l74F6PBrm5oHIk2jtx7mcmsEG90fBhblgol3rJk1q06RAC4DYSfL4Urrl8ogam1P5snssoG2flsP91IKo2efD1ym0jzi5wzS5kG4lZiJ2Bzj1rh110htcDX/ZMsNllYdCVCJnGdQVu18hn55v8zlMzZowOiRuey+rlGUaeKnIACSoadwxDr4/7iI02nhx1I5zLVGAUSTYjxSEs6kahOpl+5sxRqZzAzTgpoRuAG
 FdU6QrNE
 cP1V7lk9etHFQajMsY/+WLUXE4r7VSdhffue5+b+n7j+zgbP47TQnByVNI7EvW8ssJ2KRHReRmlnYQloo8IaiTdfStpYSCEeWJcGIQKj/KLI8oykpLh2d2cMgtOqncEDrMeweLPFSRyZTJm6IC10H4jP7FoTWyORmfp4OHdgfVWxIs3X2+pdyMpc6KDiBKMf/8ValyKdfB1sCVd1+Tgm8250r2vV2YvWYnlodmPpMTXEWYuHfgyBbiFTDIlAHp2NH/CIlwxuSo9CfnmLngFo6fsIsW3CTpL1j7G2OguCi9DiGvvueNTUuXt5bMvod50vAsEzP+aHtYhXqafqvtaaoub8cPFBQji9j04SMfkM4GImW37kOvObVABZeb9nke4u4leOh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 03, 2026 at 11:49:44AM -0800, Breno Leitao wrote:
> On Tue, Nov 03, 2026 at 08:59:59PM +0200, Mike Rapoport wrote:
> > On Tue, Nov 03, 2026 at 02:06:17AM -0800, Breno Leitao wrote:
> > > On Tue, Nov 03, 2026 at 11:48:43AM +0200, Mike Rapoport wrote:
> > > > > --- a/mm/internal.h
> > > > > +++ b/mm/internal.h
> > > > 
> > > > We've been splitting internal.h to smaller headers, maybe it's time to add
> > > > "memory-faulure.h"?
> > > 
> > > Ack. I'm happy to move the "mm/memory-failure.c" section out of
> > > mm/internal.h into a new mm/memory-failure.h, as preparation for this
> > > patch.
> > > 
> > > Since this patchset is moving slowly, I'll start the header split in
> > > parallel as a separate series, and rebase this patchset on top of it
> > > when I respin. Is it this ok?
> > 
> > Sounds good to me.
> > 
> > Just be aware that MM folks are knee deep into fixes this cycle, so both
> > sets could be moving slowly :)
> 
> Appreciate the heads up. In that case, should I hold off on the header
> split until the next cycle instead of starting it now?

I believe one header split patch is small enough and not controversial to
have it this cycle.
 
> Thanks,
> --breno

-- 
Sincerely yours,
Mike.

