Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09E4CC61DFD
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 00:28:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70DEE6B00BF; Sun, 30 Aug 2026 20:25:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 696AC6B00C1; Sun, 30 Aug 2026 20:25:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E9D26B00C2; Sun, 30 Aug 2026 20:25:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 189226B00BF
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 20:25:45 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A59A3A3EF7
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:25:44 +0000 (UTC)
X-FDA: 85159671408.24.C40639E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id A9E8AA0006
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:25:42 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TbZGfcdq;
	spf=pass (imf25.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788135942;
	b=n+Ai6xp4CWMW0Aur5giAZhcEpHoiLUbzVSn+Se/kanasu8m2dZkmXARVXNflNY4QggA+uR
	DGFe50hnd/q7gRf8tMNErNLPWWdyY/iykh9cG5p11cngNapMOyyFsYFyc7OqBV3iY+SNPJ
	KIjSXRr4bDSDKgHBTqtXlGCWOdFhf90=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788135942;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/CprBPViwH1Aa2/Sh7KpN24BeAqoFM/m48+7tOziyh4=;
	b=ynD7d87OjUuwIM2grRwsrhEE0KtBAajvx8zQ64TbMwJ0BM4SsVeuzWIcfUT5feD8DkStgj
	rz1l6yF+ZHIqhHE4b4THHZx0V2ZYJfFc1GDaVaUvYxPKyme0ndzBoihpunAbKY4fTR9Uz8
	CPv8laPYp4XXT0ZT5mZwNgcUPYFH62w=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TbZGfcdq;
	spf=pass (imf25.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EB117449BA;
	Mon, 31 Aug 2026 00:25:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A319BC2BD01;
	Mon, 31 Aug 2026 00:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788135923;
	bh=MBsdJBcO4TQvHjj9pDczibnuw9xpxWQnfVZGWTJVKUg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=TbZGfcdq7kzK5CCsa3AykZxdq6sTTAfupmtjkchE+NV99+G/oXHy/z32qCaBG7yil
	 9WrCpttCdJesYEqjoYscTa5LPn6hBJ9lJIvghrBPbP0LTL1lSKIhn0dRgaZ5oPHzlm
	 NtHTPWAFdbkEyOSvLgkSxbm1/0JEvdxU82qzQ5QaH5WZpr3D34nFvw6VKaSJ4SV2zg
	 m5V4ti0tiMJM3cLO1P89RafdUv96KHCQ5ZPh3NMtWFGAdGY2VHr1pg6ixUI15GdHoz
	 lklc7TXC7dPcSjRY38X+LQvhpoUXxXjmwsyauWIyZ+Bj9Ogs5qgKvlcG06xLwK6Mbc
	 pNF1/5ioaidzA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84BD6C61DE4;
	Mon, 31 Aug 2026 00:25:23 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Sun, 30 Aug 2026 17:25:40 -0700
Subject: [PATCH v12 39/45] KVM: selftests: Reset shared memory after
 hole-punching
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260830-gmem-inplace-conversion-v12-39-85e5fd25252a@google.com>
References: <20260830-gmem-inplace-conversion-v12-0-85e5fd25252a@google.com>
In-Reply-To: <20260830-gmem-inplace-conversion-v12-0-85e5fd25252a@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
 oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
 rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
 steven.price@arm.com, willy@infradead.org, wyihan@google.com, 
 yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org, 
 suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org, 
 Paolo Bonzini <pbonzini@redhat.com>, 
 Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
 Randy Dunlap <rdunlap@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Fuad Tabba <fuad.tabba@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788135916; l=2579;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=uV08q4RDK3FyngpumGt+e56rGp5WLQvKfEyZx0mVgVY=;
 b=iT+PS0xDjfvKp4QdlflKy+7dtweWMwhTAxNwE8dsJVeEO94OnCnUEaqmPrG+y6GLz0nP34akA
 1N1NalAM+U6DNWnLRM30OqjSc6w6dw8krqKqAhRtjiHKWDOuBdx1it5
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A9E8AA0006
X-Stat-Signature: 814kx1ibob8bknts9ubtzrnbb6kn5eke
X-HE-Tag: 1788135942-796014
X-HE-Meta: U2FsdGVkX18EBiDlt5iDWVkWVXLaQQUkYl3p3PjR/2wuaS4ogkcE26OLWH1ViVqlj6bKEJ6xdikwkO5suV/jEopGCaaO/LGAEJ9ozdvzRh1m9rDiaTIpyNcLIykx0OANtbOrN2IupC/slOKNjXfg1mpbdu5RJBWncU8hQZZCNx9LS6gGbAiivWyGUCPWAaLURg+ALcjlS6hjj0UaNH/H2thlh5d+3jc289Zg+bSj9rS9TBsYoOzFmix67WILOhJlhA2dHI1OrcDlI6niavSsQHlbmpop3K5r6UszLNBRlRw5wJ0++Dd31Jm34FOq5lk7C5vL9laLNaQbd9r7zoYhFNHS11U1508nlJQeOO+xPsy+vSb3HHRoJFffDVKzpNfRsv9bWZWwhYWXbaMpoAwQq62wr9V1S1DscvAXuqszUuPK7Mp+AJkNz9x1NzeMy43Ep8RC7Uyv+LrBY4R1NpcAeQGFbXlDIshzif6E0DVlcUyQ/8Xp2lG20WXS4XAHoXvW3F0EaSl2yVEGOr+Xlcah25AEDAkrU6N84VYJE3ILavwcsRSP43IUx0/xJhfF28SdSCjvebJr08lOokfhC5x6syy4zPqBjDNtulyV0KksKAi8Dnxr3i7qwQaQF07vJpL6muv7OyCHvCXntIICMskmeugV4Lvd2SKumdnbJrUH8j7Kugt7UG+ZTyjzWBafOSYm81k2gJS1t8AE6H7+N5q3RQXwtUUl8MLWy6UBwH3e3tmIFtf+j5RY2E2CSd773/TR0n99v25Wijig4msLk9qet/LWdjpeiNGXXPgxyDeIg7Yhnm3NUMgsZrEc6Kza+mU6IqRNy3DUH72W3rLo1/AqRs9Nf3C6vDCZaNy+NkqSHBZ/wl+z9jXtvu0PAIiEXIIQ/u8H33KfWWUvq142vH7CIKkPCEJNbAKufKjILc4xGZbj4TkTWzjlwlpuJzQv/QknFunc3nQvP3YBkNxV8Jj
 irweRLIv
 3tfZzCRvD3reGhQLIIvEXAi5XARvxwvBLauXopYYAUG2eFGfz6w1BJEQPrauRc6d72/W3AN/h8wkqVS2Od6VmiotYY4MW+F1qXtjujePHn49/lk5/arzd45rImVsoQZTyn7br0YKE7hhy4+Du7SLzh0/4OdRd+W8vwry3uU69a0qwupo+9EEur5/HCfD/Pg5Ei8gbV1RNbqPpDA9o01rciW4IJgpq/Oj1o9X5gkGo+QCrlumJCU1ZrVjOSUjJJ29fCCWUBb7BUUoj0SN3Y7sEty3kdcVZIB3AVUZeYkj3WFK5Kyh3lJezCp5BeelPniN5fMjghNOp/7jJGn+SjD4+Ps7Yaa/j1AjNWMX8Wr9UeMoe7N2HOzCY5mPkR7Pk5VRX7MPbMb/5GIkD/jiHIl8QY3V1zx9lL1ZHx8JutkVFF9E1dAK3wi+moPgoe/OZjWkXagj+9rOCSno6yJUF9uYiJbnM3sNW8mf+Ce6d
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

private_mem_conversions_test used to reset the shared memory that was used
for the test to an initial pattern at the end of each test iteration. Then,
it would punch out the pages, which would zero memory.

Without in-place conversion, the resetting would write shared memory, and
hole-punching will zero private memory, hence resetting the test to the
state at the beginning of the for loop.

With in-place conversion, resetting writes memory as shared, and
hole-punching zeroes the same physical memory, hence undoing the reset
done before the hole punch.

Move the resetting after the hole-punching, and reset the entire
PER_CPU_DATA_SIZE instead of just the tested range.

With in-place conversion, this zeroes and then resets the same physical
memory. Without in-place conversion, the private memory is zeroed, and the
shared memory is reset to init_p.

This is sufficient since at each test stage, the memory is assumed to start
as shared, and private memory is always assumed to start zeroed. Conversion
zeroes memory, so the future test stages will work as expected.

Fixes: 43f623f350ce1 ("KVM: selftests: Add x86-only selftest for private memory conversions")
Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/x86/private_mem_conversions_test.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c b/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
index f3de2a4ab0551..cf50e9a332c5b 100644
--- a/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
+++ b/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
@@ -202,15 +202,18 @@ static void guest_test_explicit_conversion(u64 base_gpa, bool do_fallocate)
 		guest_sync_shared(gpa, size, p3, p4);
 		memcmp_g(gpa, p4, size);
 
-		/* Reset the shared memory back to the initial pattern. */
-		memset((void *)gpa, init_p, size);
-
 		/*
 		 * Free (via PUNCH_HOLE) *all* private memory so that the next
 		 * iteration starts from a clean slate, e.g. with respect to
 		 * whether or not there are pages/folios in guest_mem.
 		 */
 		guest_map_shared(base_gpa, PER_CPU_DATA_SIZE, true);
+
+		/*
+		 * Hole-punching above zeroed private memory. Reset shared
+		 * memory in preparation for the next GUEST_STAGE.
+		 */
+		memset((void *)base_gpa, init_p, PER_CPU_DATA_SIZE);
 	}
 }
 

-- 
2.55.0.897.gb25b4bd76c-goog



