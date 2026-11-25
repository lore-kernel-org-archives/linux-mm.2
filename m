Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 152F8606A321
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 14:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=GiC/VAka
Received: by kanga.kvack.org (Postfix)
	id 270AE6B0A3F; Wed, 25 Nov 2026 09:40:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2473C6B0A41; Wed, 25 Nov 2026 09:40:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 110506B0A42; Wed, 25 Nov 2026 09:40:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DC4006B0A3F
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 09:40:28 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 78BF2120E91
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 14:40:28 +0000 (UTC)
X-FDA: 85473902136.24.D6DD8F7
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8486F2000C
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 14:40:26 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b="GiC/VAka";
	spf=pass (imf03.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.54 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795617626;
	b=TsW0K/XMLi8UMRUbj56NqQ5Apry6cvJ2ioFbqhU0NjzgFnveA59Rhd1tr2SP4M9LwVx5Pl
	eQeEllgUUzoE1FYGQhiTaD5LJ7JhPyGvQ4GZ7iYx2lzbjR9CRIMU2Kj8n7hUmdOMhd4C1z
	qlZ+zNKQv4wB+YXO1adTWJri37GPsuU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795617626;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZXxCXDhXt89FGj+2wCW0FFI+CiFy5a7DZCKDEUhio5A=;
	b=2lO7u7KCbI9mnuVINLwi320QhYS7kau4F2rdtsCUF5nLSgfUAV8EcI0pccbTPleEANmoYB
	VuY1i10vqMj4KUjIas7vwcYSYmP4DqdupL+x/XjE1p9uK4eCpQSpENrR9ED4qaqY5rzWby
	rYTumycYtSxSXckC/r2DBA+FcBRr4Fk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b="GiC/VAka";
	spf=pass (imf03.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.54 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-91c1f548f87so78879836d6.2
        for <linux-mm@kvack.org>; Wed, 25 Nov 2026 06:40:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1795617625; x=1796222425; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ZXxCXDhXt89FGj+2wCW0FFI+CiFy5a7DZCKDEUhio5A=;
        b=GiC/VAkamzc+43igQCChPy2eRr/FCHcRhLITAa2BVK6uayJ4vk4zErkt3CncHu1Yy5
         ltU9sFzeymkOwBv0wuAr+ETaersDOyaK4BLatc6KlrT+vpgTCtjJ7jc+jhW0EybNLrMH
         EQ+uNcbs3KO+9DgZ/DbkBZsr7UvvLxLhrlyKAkFgx8V3/N/3H/XeLLtCNIkDJZMJfpv+
         a48kE162SnzXdG6+7irYGtYZXCI/rYB+DDjMg2wQyKzNU/rTTpb3QXgDpnM+b9hO2zd5
         RTB095ewiTpMsBft+OM/p+sGe14zR5owIs68QOT0xc1uGgoabkOQTVoyGpCvqb4Atk67
         KSAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795617625; x=1796222425;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZXxCXDhXt89FGj+2wCW0FFI+CiFy5a7DZCKDEUhio5A=;
        b=ZftJt1PjdjF1FhIW1uNC0KF4JtoC+H5BDF86VRM89XNOzOKXXjh9s1CJmhDMmj8e17
         5uAwo+hgG2KJSzXynmNtPjKR+jgJKlxT9DXa5HOg3dIG9fhjlwf0zbGPJqFNuCQy+f0p
         ZFhzeUxkTvHOp1ZfZDUfJkBP1p8VRyt+lBgpTEZJclP9mYBoZhRNWEnBBl5OOqFulclE
         ymB857q7TXWpDlPW30IIZ+Z8oNCqda8AnAat+R5kMvTjtE3CUyoq+y6kjipfx1aDrswb
         fDVw6cFX5w2Q/UrUmyImn1Y41pnRhq/E0zqV5HhnoZNSFlP+A+ftGAq+rULCEoQKoBt5
         1OEQ==
X-Forwarded-Encrypted: i=1; AL+hErEDp2LMAt8ZSz7Xiiiw4TkEwol+TNKL8SgyIzkiGP7c5ntqiDOQtnWu8kNmt5RhbVujKNqK0o13Yg==@kvack.org
X-Gm-Message-State: APuU4Z+ipl7eArvgTT/Z9ap6If/WTVctaecU7o/ekfMOxnT9LIzPTgI6
	8mwg3m6bCWSvpn88nz33FMmdl1nVMtASD+pgboKQAoGHG0cDfZEXVXJ3IX32k+zsxMk=
X-Gm-Gg: AZFdTZdnTks9v4EfpqAsDiQ4+3/tQZdCmvlm2l7l2eI2f8hoZqMlRyly/v3tSIDd4+C
	DPTtf9LxDHIRA6uvYPlpV9bCdvV2SSUhjLoK2LBhAag+j2ywdBT3MotAYTHv1Li2ahs0lz5qBtJ
	KU+7oS2N228jU+Mv54RmoxGWckWqaBb6dCZEgYgJl2pJNLkoAsg/rQHOYY3yy7GkEUJqh+y5Ofy
	CwrC+ft96fdvrBNJGV34KCKVJ3tKscmzUOhlg4C77DUAqMzjJplAlM+8gn1jFzx3cYGwTGIZEh7
	OEfEWi5XxV/BgpQXcDROe0Zr/ChndDAamksLIa3wwaQnnWot3f5jzlzKM0HX3xLgAak0U1nrcUX
	hzYX6RsXxSSyb8ZDGr79Ccz6oyJuKwoO5WKF+o4KASZCZVnDLUFNpqiEnQBVbkBcn4KzS2olkr9
	LVrtCVRhHz0MzzO0VDex2xWLKhAX1PfcWOIAZ5m97vSfnQf0G4HLrDKTdwG/pNdyHlM9LW4PU2w
	3K7J+Wy7Kchiim0h35aGdhbaqzej9AHwQchfb5a6bR9SYGvzKCnE3LFVY8xumwCj7acUvwwa1of
	dboDQQ==
X-Received: by 2002:a05:6214:e88:b0:921:23fa:2c05 with SMTP id 6a1803df08f44-92134b7aa62mr315798476d6.46.1795617625546;
        Wed, 25 Nov 2026 06:40:25 -0800 (PST)
Received: from ziepe.ca ([142.177.118.84])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-921645f50f3sm61254106d6.24.2026.11.25.06.40.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 06:40:25 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xWEAa-00000001lzg-24TM;
	Wed, 25 Nov 2026 10:40:24 -0400
Date: Wed, 25 Nov 2026 10:40:24 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com,
	will@kernel.org, Ryan Roberts <ryan.roberts@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH V3 00/14] arm64/mm: Enable 128 bit page table entries
Message-ID: <20261125144024.GH246011@ziepe.ca>
References: <20261117070613.1183243-1-anshuman.khandual@arm.com>
 <20261120190525.GC1133597@ziepe.ca>
 <aqcypbxidjbmjhuiujg2krseuy7v4lofrlq3upl4s7yjiq6bh2@3s4jqisdrkgd>
 <20261124135424.GL9566@ziepe.ca>
 <a54bdqfzj4eyoaaiekxxeqi27rc6pu6z2uufv3lblbyujclz36@egotqjcxv653>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a54bdqfzj4eyoaaiekxxeqi27rc6pu6z2uufv3lblbyujclz36@egotqjcxv653>
X-Rspam-User:
X-Rspamd-Queue-Id: 8486F2000C
X-Stat-Signature: dtwswxaj918nsurzmdcqx6f8ttoay7b5
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795617626-174122
X-HE-Meta: U2FsdGVkX19ZHKHJHwi5ybHpzUW6kOzGWKi0RHe/oPYh/P2Nuhyvp3dXBkzHCJ3ppDxSkTc4p09l56lr4OiXT3UAyyIW1DAaNM/LbgHZ3ZaAjMQHAHJS4cnLI15kxMpzRiINVnuSg6w13F6y8JKLEJKIvPpmiws1AQo34LFZ46jAYYYXUGEjIpL0fgs6VdWzcB4IdTNRf76XDdcpDAWEl8kDLJVJKvP2ES7Nl/bHIFk4qnhUyI1qnpZVETAbssV6ImAUY1uljtrMYOJ9ijCaMFrqD0fgiF4zWeta5NWHvF0MDLpcMcNbpv+5+81OHM//WUA/9KbT9tJKJFww8VkKt0oODRIMNfpe+u2Wt75cBR8q9ql0PPKkKyu7KxsJXvFVxyKIjAnJsgSI9W3c+k/SXruiRk24c5au3zypn5oSeMleGNl/zhtjZiXFjw9FNfhRU1zbRP6+uunr/sVl8gJAoR1R3nk80BNbrKK7CGKmSD5jaxLnSJ1WkI60JYF1tYDBZetZ0UE2CZcbSGqFtaEbFAm4lFM+YmoKZzrLVuYBTBgGJ5Pg+0wOGxF8sn5UCr+HoYshe+bQWkkp9CklXeHcza+L48QGhVUMnGT2lkD9tyrht2+TBb4l+loQkf7KH27dxRE4587b28jRra+3uP8c7ottFFXmjZmGJcnV6P6gtXhaPgdTovpMHhzVzDk0Q86CTwXQty9t/5AfkusQ03pKstDlAdh9aC0N4/fo2sdGWwgjGcgLu3KlVVHIf384jrXjJUym8ghMBwm7ema+6MYN/9/YVqj7FesgOP3+AESW5j+ixVhEyKiioSu1w+TCtYnxz3o32EFWZnNsYdQl0dvpztGoR1vNe/yS+tIOWSW9uYbjECPax2PjpdXAW+U1lYOOF1OY3DyJexUVcCvFQjMEfD73zC6hHIdTNnEGWpvskoXIoJncP1HsGss0i4excI2GQCoC+NnAF13O4JK2TUc
 pRKob1se
 FH4HbzxLA/IX7uRjLSLuD2Xazeld8Oig5hXcuOCmWn3DtIvbMUYRuDaA8oO8nB4CCZGCGoMzvhMCgeoinuS96xH0nmqOGV4SgYKlWBIS3ujbWqPS1wMQjI1gVGj/8GsJs5oO4GK1thjNJ2fwYzF62JoktbwhvfP+3yFyKwiMlUGu1oUMgISU5cMFW0c45S+IBQ60r2byi5UMsUG/ehgiTCyddpI2kZNzaFBrapjghKPgEOhVmNOiP3eMBkR2YIEsKQsXoVE/ADaNNOjc09qudqtfH+grOn3Ccr5i+IvU0U14XK11Um+/cw1GLfhRmkM8KB4xA1eqqEk/m4fabrQx/2IkPfCC0ceDzt2HQ5wqzBhkt3vYwhLUiNaQZkMx3UK8w9kOIU2I4XfXNtvYKrnkK5scXO/TdAqZNhYhUbMW/HMR4WYUW6ODJFYXcK9t4DqaUNthGHuZ0NgqrfnYUNC1QGb76+Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 25, 2026 at 10:05:52AM +0530, Anshuman Khandual wrote:
> On Tue, Nov 24, 2026 at 09:54:24AM -0400, Jason Gunthorpe wrote:
> > On Tue, Nov 24, 2026 at 09:29:27AM +0530, Anshuman Khandual wrote:
> > > On Fri, Nov 20, 2026 at 03:05:25PM -0400, Jason Gunthorpe wrote:
> > > > On Tue, Nov 17, 2026 at 12:35:59PM +0530, Anshuman Khandual wrote:
> > > > > FEAT_D128 is a new arm architecture feature adding support for VMSAv9-128
> > > > > translation system. FEAT_D128 is an optional feature from ARMV9.3 onwards.
> > > > > arm64 platforms with FEAT_D128 enabled will now have two different memory
> > > > > translation systems i.e VMSAv8-64 and VMSAv9-128.
> > > > 
> > > > Please don't forget to update arm_smmu_sva_supported()
> > > 
> > > Sure, thanks for the pointer.
> > > 
> > > Fow now will disable SVA with CONFIG_ARM_D128 enabled but later it can
> > > be enabled back with SMMU_IDR5.D128 feature. I will probably fold back
> > > the following change in the series.
> > > 
> > > --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> > > +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> > > @@ -205,6 +205,9 @@ bool arm_smmu_sva_supported(struct arm_smmu_device *smmu)
> > >         unsigned long asid_bits;
> > >         u32 feat_mask = ARM_SMMU_FEAT_COHERENCY;
> > > 
> > > +       if (IS_ENABLED(CONFIG_ARM64_D128))
> > > +               return false;
> > 
> > That seems wrong if the arch code is enabling this based on a CPU IDR.
> 
> D128 translation gets enabled when CONFIG_ARM64_D128 is enabled and also
> HW has FEAT_D128 as detected via ID_AA64MMFR3_EL1.D128.
> 
> Besides if CONFIG_ARM64_D128 is enabled on any HW which does not support
> FEAT_D128 the kernel would not even boot as there is no dynamic fallback
> to D64 translation in such cases.

Uh, gross, so it is like 64k pages :(

I guess that makes sense from a mm perspective.

IDK how this will ever get used in the real world like this though :(

> > I would expect distro kernels to enable this kconfig unconditionally,
> > so this will break SVA for everyone.
> 
> ARM64_D128 actually depends on EXPERT and hence it would not be enabled
> unconditionally in distros ?

Please add a comment to this effect, this not how the other things
work.

Jason

