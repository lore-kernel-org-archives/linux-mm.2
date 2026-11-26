Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CCB7606A32A
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 12:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=b2GdKWKk
Received: by kanga.kvack.org (Postfix)
	id 3DDC86B05B6; Thu, 26 Nov 2026 07:23:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38F606B05B7; Thu, 26 Nov 2026 07:23:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A5296B05BA; Thu, 26 Nov 2026 07:23:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C87F96B05B6
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 07:23:36 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 66E4D1603FF
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 12:23:36 +0000 (UTC)
X-FDA: 85477186032.06.1B9CF89
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id 447D080002
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 12:23:34 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=b2GdKWKk;
	spf=pass (imf30.hostedemail.com: domain of alexandru.elisei@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=alexandru.elisei@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795695814;
	b=ewsc19NaudnVwq7CcpULgTsBDSlsABsYKadFDU467j3Izn6rR70LulsIDim0VDgYPH3dli
	MGBthiLEPyxZEIlmUwCkbSwX1C7AUjAzHiVZ8ponQHBRqh7Pf3q4WtQcBfgJgnmRrEfiwr
	IFeFLP8SgjvSRCze6cPr4hBL3yDvcqM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795695814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cahhcaJkLSgbEXecUz3sF/BpNciuZTRujvnzV1iz1qI=;
	b=Hft8oDwzXeynBG/QQVSAxQy9LTsIcAcOinEUQCpku1IRDj1RbaxAnbxOjOqlZ2zd6hCs9a
	rrCtXoSxEW/GtW7btJZsdSizmypPK47V17nSEWBQM5pf6t+/Bvi7uCBGCyiTwBaNEIZLML
	IOR7ZU7BdqwHkyO6iKn7k/w50n4+WG4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=b2GdKWKk;
	spf=pass (imf30.hostedemail.com: domain of alexandru.elisei@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=alexandru.elisei@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4F0B21C2B;
	Thu, 26 Nov 2026 04:23:30 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E77E73F86C;
	Thu, 26 Nov 2026 04:23:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795695813; bh=z+IdbNawuD9ltkD6CIHv0qQogSEt72dKkCCiWg6ydoI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=b2GdKWKkzhHp/0Yq3ixGcL40x9Vg7RS9//T+G4j/CE4kZ9YHIKOqvwfoeurOofIcf
	 38qlwg/L+TWUehuri88N67jYwpOUSatWUrC3zALaQ5pvD8p8dULHGdQuFu4Rp8Zm9E
	 ist3QH727Y4pzC5YNdvXpS/KcNtc3Qzr+tLTT0eY=
Date: Thu, 26 Nov 2026 12:23:28 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Mika =?utf-8?B?UGVudHRpbMOk?= <mpenttil@redhat.com>
Cc: Aveline Noir <jm5905938@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	Ralph Campbell <rcampbell@nvidia.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
	Shuah Khan <shuah@kernel.org>, David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH] lib/test_hmm: invalidate all mirrors on device-private
 migration
Message-ID: <awgkwFE0P9miJj-n@raptor>
References: <bae41f6fc4114357a8a74c8b958f2bdc.1@linux-foundation.org>
 <awbtZjtII9h1oJ5R@raptor>
 <CANOyQmGPHrHAzVW70Q8T3AYtzFi3C7jCQdd-QW0rQCPEf=ycyw@mail.gmail.com>
 <awb5agUP80qz8iss@raptor>
 <be640357-419b-4c78-8d96-3c698424ecd8@redhat.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <be640357-419b-4c78-8d96-3c698424ecd8@redhat.com>
X-Rspam-User:
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 447D080002
X-Stat-Signature: sxgakxzxj6r7cc3endg5gzj3bepq4hw9
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795695814-501087
X-HE-Meta: U2FsdGVkX19lY7WMqQa2T2hKBplvXIScJ9mucULIDBwHOgUxykHDho6pOjBnN8XLWHM8suafyoI/cgVdoJtmmw6rh5PVS1yT98h67xwcHDKU+Kcb0YuPLZDJG6YUevKb0cdEx2N+Os8g6EdHNoIK8/JCeE15ImJ1w/SIlyqCadeAQeU38jYt6kZuMG08NSk93vZOJIkHPZKjaKQ23u1dAUhLu8bPumdWuVYyQaogYmFULW07ug59wlN//nOKDdHq8JhJ0nnubYGid++RFPAgV1lBlZxF9ntpIQNzIXsN+iQA1q2hsxCHn84D36/PUmMMhEthUwtU0eElHDAYFI+paSiX9MF0gApWPC3b/utllZQvBwg8neZzaGkCHMnpKw787EcDboHN6bVQ2zHvy7P2kZ5FORioWiNYyUIbuhT2kuIqBicOBjSbB4bV4Xw0cWdWAd5hyTbP0cnOoveSduVpcchUkLABZwsghQMjO8qQeDTYDt8I0tZKwriYInkXyeWNy1CQEc+IE97DUvENERVw79dYWQPm9dtEUnMNlkNTn+MLgSmzkjh4sWpkScE7KsnFURTjzYNUBIvbg4AnV/5pdi1Vb8X81axrw3Z8Nb40QmOuyB1cD9qqZBa24biWmh+vd2MLnTZ+vXv3OPSG/MaGH0NC4QjaOdRu+i0M5lIiKpfwGckeUj8xb4mKC5z0JbOvqqnuUBicaJnp0R39X9C7/TqILJGU22RX193trztBnSbY6d9FPyzGFwhFM9ulPAS2eVmmCVImfuHceaRm5CHOZXXmy9wT5kcsqoBNfjDz2DokgcbUYtMmGvjmn1L0G31cmM0ko9gf85UERa9dMwxvHid+88KRVcvk4fBGs5yvTQmvoJ8beaVrH+3+LZQrbx9mjNZR7TPKXM1qfImtenEmVa38yDwwaNtAU+XtkROq4ZrTsoWp8mZqeTnlrquS362A9HHLVPRlhFCfACrcvYv
 eVmRHyB1
 eAMc0AaZk5uzi7rj3/8hDOui6DNGbyKS4zm4/kZp5uuWhP8XbjR4VMlayNrlM5H4xkxBRMptCRYZo8LDfavz7io429PDr9FjULpj+KMVLlthq4RNDPmsw7gIbb/2lRWNoUXTgKuIBqH4+dy5gBPE8/UW3eDljo93TTQDCxwERyLpommVn8Z36pOmf3EQZRtsn0lLMImvOS3fuRvc1dBdqqAUuqC18rSCkBOQV8ItY3pX0uN2D271HKHlXPiQtixhfldNDJj2TifWNQfoO5ERYyNkXo83mV/2IQyzhtpPsDMpuA92xyoSuLmN0iVktisMwgSdhNS9H6pqqMIRUaO4mAhEiPPiZLi4RCxb224e5Ftab0RqJ/zB4PL5rxEBavfGARLJJ6SNH/l8S4BPGtcpmw85fUYRsNyOqSKo7VkRz7fcYMNsel6m8fkiQt1jgGKfdGMzeVk8aWo7xTB6V4pwowMUYzn+u09eV64ENmtxz3sydqWguAbgBKUT6UPzrMcWdj5lW7AjQgzZvcQdxrACpmuEYhUZ6AwW9s0Xj1yHklenxuT5k3z8wvGMKdNWpoCg/Y/e9QoMGr6PXw/B9BKsaqDwSkA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Mika,

On Wed, Nov 25, 2026 at 06:40:12PM +0200, Mika Penttilä wrote:
> Hi,
> 
> On 11/25/26 17:06, Alexandru Elisei wrote:
> > Hi,
> > 
> > On Thu, Nov 26, 2026 at 01:25:41AM +1100, Aveline Noir wrote:
> >> Hi Alex
> >>
> >> On Thu, Nov 26, 2026 at 1:15 AM Alexandru Elisei
> >> <alexandru.elisei@arm.com> wrote:
> >>
> >>> Might be something on my side? I'll investigate further, but I'm not very
> >>> familiar with the code.
> >>
> >> I reproduced the same 0 versus 523264 assertion on x86-64 when the separate
> >> mm/hmm: account for subpage offsets in device-private PMDs fix was absent.
> >> With that fix, the test passed. May you check whether it is in your test tree?
> > 
> > Indeed, I didn't have the patch in my tree, now the test passes!
> > 
> > Tested on a Radxa Orion O6 board (arm64 architecture):
> > 
> > Tested-by: Alexandru Elisei <alexandru.elisei@arm.com>
> > 
> > Thanks,
> > Alex
> > 
> Did you run the full selftest? 

I dropped the ball here, the output of the full selftest is a couple of screens,
so I just focused on running this one test while I was trying to get it to work.

> 
> Without skipping own invalidations the normal migrate to device test fails
> ( With no skip, migrate_vma_setup()'s invalidation erases the caller's own entries) : 
> 
> #  RUN           hmm.hmm_device_private.migrate_fault ...
> # hmm-tests.c:1023:migrate_fault:Expected ret (-2) == 0 (0)
> # migrate_fault: Test terminated by assertion
> #          FAIL  hmm.hmm_device_private.migrate_fault
> not ok 14 hmm.hmm_device_private.migrate_fault

I can reproduce that:

$ sudo tools/testing/selftests/mm/hmm-tests -r hmm.hmm_device_private.migrate_fault
# [INFO] detected hugetlb page size: 2048 KiB
# [INFO] detected hugetlb page size: 32768 KiB
# [INFO] detected hugetlb page size: 64 KiB
# [INFO] detected hugetlb page size: 1048576 KiB
TAP version 13
1..1
# Starting 1 tests from 1 test cases.
#  RUN           hmm.hmm_device_private.migrate_fault ...
# hmm-tests.c:1023:migrate_fault:Expected ret (-2) == 0 (0)
# migrate_fault: Test terminated by assertion
#          FAIL  hmm.hmm_device_private.migrate_fault
not ok 1 hmm.hmm_device_private.migrate_fault
# FAILED: 0 / 1 tests passed.
# Totals: pass:0 fail:1 xfail:0 xpass:0 skip:0 error:0

I ran all the device private tests this time. I don't have a device with
coherent memory on my machine:

[..]
# FAILED: 77 / 78 tests passed.
# 40 skipped test(s) detected. Consider enabling relevant config options to improve coverage.
# Totals: pass:37 fail:1 xfail:0 xpass:0 skip:40 error:0

Thanks,
Alex

