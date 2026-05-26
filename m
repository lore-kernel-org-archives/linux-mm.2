Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83237CD5BC8
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 12:34:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D82C46B008C; Tue, 26 May 2026 08:34:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D59A86B0095; Tue, 26 May 2026 08:34:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C96986B0099; Tue, 26 May 2026 08:34:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B98856B008C
	for <linux-mm@kvack.org>; Tue, 26 May 2026 08:34:29 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6794612035A
	for <linux-mm@kvack.org>; Tue, 26 May 2026 12:34:29 +0000 (UTC)
X-FDA: 84809514258.03.B1B48EF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id C722420003
	for <linux-mm@kvack.org>; Tue, 26 May 2026 12:34:27 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RmVzUO2d;
	spf=pass (imf31.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779798867;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hmoINqMgVgeubIA80Me9ZHWv15KWusGbb1TzukRmFSk=;
	b=qDlpKzkKXpS8HyGwmlsWeu8bHjK09R41/7devD15kYwQsY4p0noK6eZxtTkHx2VbAQCiuf
	6NSsyFFH6pS9dw3McpMFf/QLib3tIf5i7TCm1h14MqDgxZFwUyadqdIqR4GK3dTdyG89L6
	8atCYb8KKY13OW3rIvkepAJzzLluINY=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RmVzUO2d;
	spf=pass (imf31.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779798867; a=rsa-sha256;
	cv=none;
	b=DWXzQI7j2ieXY0fN3WQZKr+nVj4UCwcLiqChgqDWXORr+ZhIHLRTIi+FxdU4vtw/TnjTuq
	08V+2jkciRuNZMxuWAejqzHf/XJ5mKhGNtb8PyUag7AaDAV8yEdGK0R1PH3nEk3XCt48lh
	shnOFwx2r4VD2gHk38hLgV7kPS8164g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 506E260018;
	Tue, 26 May 2026 12:34:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B5C01F00A3A;
	Tue, 26 May 2026 12:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779798867;
	bh=hmoINqMgVgeubIA80Me9ZHWv15KWusGbb1TzukRmFSk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RmVzUO2ddb4EKCFTrOtfA0cRTCa7E3Y7UkKTIOgQrmtOcTBWRjWqN/mKjD3Nf0j/0
	 FdpY6rPRp5mwIGNeoyS/Jfh+a9rycednulXrTjh3e8/XdXVBJUOYwi/MzFnf1nmuTw
	 YS6zEF8tUuYbMkBDMBXuAy4ywWUYKYRlRcF0+NsD5LOW2bs8VXDh8U4RzSCUcj/AO2
	 cBcuf4qP6WJ2IANsM/9A6Y/h+FjzcIOTv4J/zVJv1rdqmFQ0OnIqfGpSzBBstFTGlZ
	 0Ap7zIzxAQllaqYuJOqGfvIdgAj99GATDe4GdEWrX/tD4pDyu+mvB2InmD5odu4mZk
	 l48kefwwgBy7Q==
Date: Tue, 26 May 2026 15:34:15 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>, Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>, Leon Romanovsky <leon@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, Mark Brown <broonie@kernel.org>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v3 1/4] tools/lib/mm: add shared file helpers
Message-ID: <ahWTRy5gkaeFW7m7@kernel.org>
References: <20260521111801.173019-1-sarthak.sharma@arm.com>
 <20260521111801.173019-2-sarthak.sharma@arm.com>
 <177964236205.4000040.3083558454897469696.b4-review@b4>
 <ff7d212c-d3e0-4476-8903-ffe88fb7048c@arm.com>
 <ahVhTWl0fTF3ASsC@kernel.org>
 <70a9008b-8b13-44f4-81b4-2397b4ccd323@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <70a9008b-8b13-44f4-81b4-2397b4ccd323@arm.com>
X-Stat-Signature: nfi5k9rd1ko5e9w469ozji7mzhrwydf4
X-Rspamd-Queue-Id: C722420003
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779798867-206925
X-HE-Meta: U2FsdGVkX1+LoKw4SdH2FPUCazXj4MSCNRmZCxyf291+wjgSnPJ2hSp/hdN8zZqmK/0R5MgvUyFwuNb4GsceiT1in0LQ65ucov9Pw/MLtdc2lgxH8NhkbbQORo+FIyt3V+FrFR2Mkx/W0znT2pvEC4r81wou9GAhLYcAWK+R5zHY+JCTyhJ73oKmC6SsE/Ylr7NbSL6GmI5jjPbll8lSaZ7/NNAZVxl0mTPJaOLw6s0SIYlxgFp6ljWV2NMzyU9UFqILvQuCqkk0/PpCopx6mjhCvmmEgbAlGwisskTb/8TXGUGyZJVKPdKmiOyBFShgGq1c6hR1tpnenBmb2qAXfKffrpOmQTyfelbYmOm7fIgGqRGMXcIteR21nVqde4WVNs5inaOMM18k3bje4kk+dM5P4wqy3OYpf1MVnLU7uvezemThwvywWgmW8R61MKo5xY1jb2ikuOzMA7o7iRn8r8mfYGG/V4MUjEHfCmWwGaGQeB/WfuJjLz9sS9HCQb4ChCvHVLv7ArAdsVmOrGaxgnW/nMewE8MXS1cYf1jjQIPsP9FMV0qGDrXCMR8Um1nK2qe4HklGpLeGLsHxn0+VQAI7KBUr7nwJl2S1Lbl6P0evli12HQNrPtzmsdcnuuO16197gkG8/7IhpMrKgtSnHBPTl1l/YbWTB6iG76Bqv00E5WuSSiZH8/HNUvAzfErtfjxioKohDOHuEelGO9FbcHQTnFPZo/0zdOw99S4//X6BxyKlvAEjpDAjU5oBkRhxII2CbP/5qZbRFdcJWMRqr8TS3mWjK9stqvsNNa1b/wWGmeHwYWmIJPjlyOuf0UBhRlM1P1uRNUOa+IM5WF+f+gc16SMPRUwhts5wewO3ZGgsqJRABkfTeg76sKdw+J3vPZyH7fBgrEr3J+CRS//F3KVFYM53nUNNnFNhFpFnjBayso92N4hfVR8c3Q3mMFLqIwZar6hB8lnEGPOq0G9
 2gBUOhHm
 LKb8k+Tz5STh/OB59HlNASp2HdX64i0fEYy+cHOibYRlQmRfTk9rjiwoK5uhdj0lDP5nYgf2b2LmFTmV43ggERgWQqvlM3tDhYcqzSHkXjvpUigGyq7B0jQ/4baYTRk7o8jYYpff0hfVAfznPq9/mfHnWi5Il+Q5txpyhakCV0g5fyz3ku4t1P2Owkpn/ZXC22x5nkl+bmMlQQM97nQCVkSdMc/NL9wEemYsa/lyufVBYlBxkpX2HKYUSZkCCzjOdFiv+3yBwqzKSYFjwO/3uP7KVoQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 26, 2026 at 05:38:29PM +0530, Sarthak Sharma wrote:
> On 5/26/26 2:31 PM, Mike Rapoport wrote:
> > On Mon, May 25, 2026 at 11:59:32AM +0530, Sarthak Sharma wrote:
> >> On 5/24/26 10:36 PM, Mike Rapoport wrote:
> >>>
> >>> and while EXIT_FAILURE == KSFT_FAIL I'm not sure it's robust enough.
> >>
> >> I used EXIT_FAILURE here because the helper is moving out of selftests
> >> and should not include kselftest.h anymore. The helper already
> >> terminated the process on these paths, so I tried to preserve that
> >> behavior while removing the ksft dependency.
> > 
> > In mm selftests a failure to update a /proc or /sysfs file meant there is
> > no point to continue the test. But if we make it a generic helper for
> > potentially broader use than mm selftests, exit() on failure is too harsh.
> 
> Okay yeah, this makes sense.
> 
> >  
> >> We can change this to return errors instead of calling exit() and update
> >> the selftest callers to report failures through the ksft_* helpers. I
> >> agree this is cleaner, but it would grow the series a bit.
> >>
> >> If you feel strongly, I can include these changes in v4. Otherwise I
> >> feel we can handle it separately later to avoid growing this series.
> > 
> > There are not that many callers of write_file() and write_num().
> > I think a patch that makes them return an error rather than exit() can go
> > before moving these functions to lib. 
> > 
> 
> So I will add a patch before the move that makes read_file(),
> write_file(), read_num() and write_num() return errors instead of
> exiting and update the existing selftest callers to report those
> failures via ksft_* helpers.
> 
> For hugepage_settings.c, I’d prefer to keep the existing fail fast
> behaviour in this series. After this series, the users are still mm
> selftests and the new tools/mm/gup_bench tool and for those users a
> failure to read/write THP or HugeTLB state is fatal to the operation
> being attempted.
> 
> Converting the full hugepage_settings API to return errors would be a
> larger follow-up, because many of its helpers are used throughout mm
> selftests. I can handle that in a separate series unless you think it
> should be folded into this one as well.

Keeping fail fast in hugepage_settings for now makes sense, they are not as
generic as write_file().

-- 
Sincerely yours,
Mike.

