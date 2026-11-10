Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F6BF606A325
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 22:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=YuC5jIUj
Received: by kanga.kvack.org (Postfix)
	id 5FB5B6B05B0; Tue, 10 Nov 2026 17:39:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D6FF6B05B1; Tue, 10 Nov 2026 17:39:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EA076B05B2; Tue, 10 Nov 2026 17:39:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 212E76B05B0
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 17:39:51 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 86BB1C0154
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 22:39:50 +0000 (UTC)
X-FDA: 85420678140.17.9284CED
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id 80DC420003
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 22:39:48 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=YuC5jIUj;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf13.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794350389;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a1bHwZlYSD2BW5v3v1BOVUB7uMkjZmsOG9hh7y5BbEg=;
	b=X+2SofPLJbdvlcOLyxlu7JCLy5bfLHYO4EnWlA8zvi4DfR4+hFifi5A09ltI5oDztOIJX2
	ELwnwcfGZV/JzvsOsjQ7p9ZeKfLoY3dfbuDnfx0+mZ5fmeCMA5jSQCKyPV3gTndm67F7AN
	zLLV2z6zwvhVpsrUQe2ovnnuE9j9CxI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=YuC5jIUj;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf13.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794350389;
	b=tEk8kuTJoOKyhfRnhRsECpkMHjVKG8U+TsQRh4HgWOtmvGr5xfFGxCEIWjlzc3jWAMYG9U
	Xl8ozgXdW/+Zn+VFkFgolPKCT6CLkWxQ/U9NojHQnA1HbccOXAA3Hexojr/qS3bWMKcamQ
	IN1yaCbsuWdlfdeg5uRl2dOztBpDVzs=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7CA191477;
	Tue, 10 Nov 2026 14:39:44 -0800 (PST)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8F9B93F85F;
	Tue, 10 Nov 2026 14:39:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794350387; bh=47N9Y/9hU3S6BEA5zDQDwUZ1lx8KQxi4n7ENHeqP1eE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YuC5jIUj1X4tX345MmGh7nc7u+Pc11yyRl68eR0M3uBMl/DcVeFxxAPb9/Dw3+Xz5
	 ZwcijTHo30ovBbbvqc6VSlBzIHDdw8xsEUIneSa1VBhrB+Fnmb6WFHT9gwCHXMu8b2
	 jUXE5r1P/97US5vMO/dxrYae/4S1BOV1imprjiyg=
Date: Tue, 10 Nov 2026 22:39:43 +0000
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>, Rik van Riel <riel@surriel.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>, Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Yuan-Hao Hsu <aa9736195201@gmail.com>
Subject: Re: [PATCH v3 5/6] mm: gup: introduce gup_unshared_pages()
Message-ID: <avOdL2ctoS_2zi0x@e129823.arm.com>
References: <20261109-refactor_gup_fast-v3-0-2aaef02df0e1@arm.com>
 <20261109-refactor_gup_fast-v3-5-2aaef02df0e1@arm.com>
 <7627c0d90188b581e7740bf8d17c8dd07b460f89.camel@surriel.com>
 <avLqwIWHa5CAbHO2@e129823.arm.com>
 <aa227fea-d22b-4c0f-bd11-bf9ec36b0767@kernel.org>
 <699499e46ace0875fd0f32052399e665c8209ea9.camel@surriel.com>
 <avN8WISVUF7u4bXl@e129823.arm.com>
 <5db7a358c293393a93984ac3c3cc58e810edd75a.camel@surriel.com>
 <avOMKWJe3wwNb2sW@e129823.arm.com>
 <0ff8276d-9535-449a-94b0-912651411bfe@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0ff8276d-9535-449a-94b0-912651411bfe@kernel.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 80DC420003
X-Stat-Signature: az35b75uo3is7ewqajkzwepfxuogw51g
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794350388-254143
X-HE-Meta: U2FsdGVkX1/AoGx/NglXgug6ABDf5N/1b/VYG2GzQyj/mfgbpuq2XKJtcazfu/k6j775QGmCDIagorQ/OdopXyeKVD2Xllug5YsmV6tCJGvgILjPz9qzQoVXSxMPL8ow0/zkmG6QseGVMxt6Ukg5agJ3xHOi6192sjF9EDSZGSahfhOM4j9RwuH26PJk8HGEGJcKottu82KtWfNtVILVi6JEfGNWf5mDs4AV/6q+0eHBRs4ioSp6VcEtiaa/VV/T7c2uo4fute2mKJPx2reHPUa4bzfHQe8Jj7fZzBDmlEvMB74qfaZbksqMg+P6YaN54l+2d6t3511RCGEQDjWwS3mSkgZwAmCZQ9mN2OON7ImfEdlRO6AoPbJ0ieItLWsSwkkEXzZC4W19V1RiGFDLOHi/2bGoyB0HbFIA99seKrRSi9fMQ30fYxtArJzJzf5hkiM3LddBaqhr2aJIEBkBAxvWtIVhyV/UPg0MUeP7J5yzLQ8MV+F5/HKPw893ZO553hqDae32+4gJEk2QC6XNSsnW2c3942I2i27M7Zl/km2ze9ae3RoPCX48JH8E6UuqS50pEYocwtfrYKJ4SdFr6SenY5HeFd9Ocm+dMWkGWzqE4kJn/yh+OYJcs1iy+pIawp5HLdgGzGKoDR2g3ONeGuHkDTpINjLtwrQNXuVEEFxNSOKH2zCZFt5bAQk+jAoSy3Ii8nNsMtZO0A2a5i9lS45tb4Z2VO4mLRy0go6vXEjjEudoyUBhtxIfqrCC7Qu7ob1Y2IP78CaERGnlDDifjp3tbsdTrz4ptRO/wBpbysdJy0geVjtEmcQ8cMuKGfkP9OIHsRuib0+HJfpfEKMIuF4geGXAYB3BJI85Fhht4+eZNuPRrhIa0WU7gbmnkM/mrRVcsQg3/aE4wlSk3dcClp/2kmcbRb129JBzuZnTOukkBrXXaDYbhIIdQdZY7HkjuxbeFUWrK1WxQEV2zwQ
 0R1T27oY
 2F5rgnkPMEdQIkSnWkIu6nGTavBaheDcGOcYQn3rMawOmvWFqW8P61TcCjGU5no8OEbjqxukevz+CxYI1cV+Do1vZfeluDZLJDSmBpmIOmbD4fpKBbfe6QD5/1N7arA5vN+qqJLp/w8Fp1sUrENBhNovm580UdgYMF7wbTl30srH9xPcmez/veoxjMn/A3IdnTTIC9bOhRWDGV1aI+kQeiG1J7Val7qyF9uaXzo6n5lx+lw9RiVaO3MFzfhjq0s8ZC8U9ZicMFRPAD45pGmbP9eRLFHVcqEQGDibg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 11:35:25PM +0100, David Hildenbrand (Arm) wrote:
> On 11/10/26 22:27, Yeoreum Yun wrote:
> > On Tue, Nov 10, 2026 at 03:23:15PM -0500, Rik van Riel wrote:
> >> On Tue, 2026-11-10 at 20:19 +0000, Yeoreum Yun wrote:
> >>>
> >>> Hmm, Wouldn't this name be semantically much the same as keeping
> >>> the existing gup_unshared_page(), since both essentially convey that
> >>> no unsharing is required from GUP's perspective?
> >>
> >> The function measures how many pages in
> >> this current interval do not need to be
> >> unshared.
> >>
> >> I'm happy with any name, though.
> >>
> >> I would really like to just see this
> >> code go in, so I can post my two
> >> GUP series on top, first the batching
> >> for the GUP-slow path, and then the
> >> series that allows access_remote_vm()
> >> and friends to work under the per-VMA
> >> lock.
> > 
> > @David, If you don't have any strong comments for original name
> > -- gup_unshared_page(), May I post next version with resolving other
> > comments so that Rik's series be posted soon?
> > 
> > Otherewise, gup_skip_unshare_pages() works for me.
> 
> Let me think ...
> 
> Maybe just throw in:
> 
> 	gup_pages_not_requiring_unshare

Agree. though name is long, it would be better to explain anyway.

Thanks!


-- 
Sincerely,
Yeoreum Yun

