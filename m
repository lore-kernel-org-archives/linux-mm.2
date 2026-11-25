Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8D6A606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 05:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=f66ErpuL
Received: by kanga.kvack.org (Postfix)
	id A18716B08F4; Wed, 25 Nov 2026 00:37:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A23E6B08F6; Wed, 25 Nov 2026 00:37:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86A7D6B08F7; Wed, 25 Nov 2026 00:37:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 44B616B08F4
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 00:37:36 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8CC2880DBB
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 05:37:35 +0000 (UTC)
X-FDA: 85472534070.08.440E522
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id BE5B11C0008
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 05:37:33 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=f66ErpuL;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795585054;
	b=tU8gmsaex025lErePvDX3r1sw3kDwwfcRe0XFActWzlMV83/7fHmU5Cr0ou6fn4IjrZvNO
	uaLGCqAXuaNDLNXUz5t7+5cqpSHZqB97b/7q5cfe/gym6lu4IazcWKLETCyhpqXn1T1DgP
	HMms0upGD4H5fZ6Q8kAZCRBBgbrqvx4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795585054;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XSfIMZHut8iBxCb9DHFVLnEm1t2B9jQpHrQrL1J4PDk=;
	b=2/62FDUW0qHa0d/qODCg4+ftyDjJQ5tIi+d0XZAcrq71Zh1vkguJcVIocF/KmsrS/SIzsj
	5nQZMVDTgcL+b81Ud/ZCByc0qOCJN/OrXuZTmXU5+TkhBLDAm952BNyQ8rm7Ji+qFCINDN
	3pZ3dVaisXDGspzn8QtawmHvzoNz0t4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=f66ErpuL;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4326560A6B;
	Wed, 25 Nov 2026 05:37:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81C941F000EC;
	Wed, 25 Nov 2026 05:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795585052;
	bh=XSfIMZHut8iBxCb9DHFVLnEm1t2B9jQpHrQrL1J4PDk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=f66ErpuL3IRyC2ReYvbG+fzz3NeYV0zaxdulpoEgMUh+FjIpIo91RxutQFTESVVI4
	 7P98SizEYS5dMevwN0CpsYY/yoyBRdMNynk6ImIQzsF338IJ6JpWtT4/ylmTg/LAPY
	 SH57Z0bn7Is9sLF3TeQBfPqa96wZSCbg/ug8pWxo=
Date: Tue, 24 Nov 2026 21:37:30 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alistair Popple <apopple@nvidia.com>
Cc: Zenghui Yu <zenghui.yu@linux.dev>, linux-mm@kvack.org, jgg@ziepe.ca,
 leon@kernel.org, david@kernel.org, liam@infradead.org, vbabka@kernel.org,
 rppt@kernel.org, mhocko@suse.com, balbirs@nvidia.com
Subject: Re: [PATCH] selftests/mm: hmm: give migrate_remap_fault a longer
 timeout
Message-Id: <20261124213730.a8b4f5100785a2cde54fa8b4@linux-foundation.org>
In-Reply-To: <av94SXo6ZAU7Z5TR@nvdebian.thelocal>
References: <20261119133955.54001-1-zenghui.yu@linux.dev>
	<av94SXo6ZAU7Z5TR@nvdebian.thelocal>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: wd1cq8a8qxceydmwabjyh3aafq7j4q3f
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BE5B11C0008
X-Rspam-User:
X-HE-Tag: 1795585053-63291
X-HE-Meta: U2FsdGVkX1/WLHTUeRUxzL2ezTZVeqSeqIwbBmC1KQIwUIWBgoKGJQlIg56Vtopi6u06mCnfqQ9iH12k3DeujcxijTKAiodSMaiZLxm5LGvvEhoTweGnPIm5EsqQQCxmfW7gjWNOoEj8UjE/2LoFta+1eX1f8ZNmB1DJeGdQ5GMZru2KnNQAYCcwngrpn9xgcU3xH3oXPvEJOFQ9vsp9J2JRjXUW5DJSTSYmfDDB3ycd7IgBOzwhvey6WuhtigY8Z/2QlnMg3FtAYqRDQKtXONS6gVuZjxMKNpbATfb2VQpSGE+WIcqFnOLpFFxKqEf90UEDRlr4Lk5r3dbRGYznmtZIxHg2ZWaBgq9O7V9mZ+Z8Cn+z0q0RyCazaKf+r8dXhsyUJ8m8Ir4JQk3Z/xlyppYUmxCvEyn8TgscKI1giI09ryWgCKpEzwN7u6bGMo3b2pahJ3zhfkENrUY4N88arDjXwGnySVLqGJy1iOL6j0b/rdGGfVaK0kA722m7QM6m/1wp/9paa4nw7OBwOFcB1+ijjijYBInj2UjX7+RhUbcCDPS/PRpg4VKYbdD8WLnTlvOcMO3eYOniVPVv2BaL/hHgd0lBVtoPt6qsupjhIXJSZsW8NE7IDQn4mRwTe+jxvYsb6qSBnifFPHBeigKVGc4LBv4YFKxATs9bPz4T9W+IO1tVFnt/oHu0QOR6tn7zfGUtdO9CGYXqP3Y/vLLW2lgDAE8ewuBaBZHZLrSxT/TrfKVNuCkS371n8wIwaU8JoEIUjpXJEWDFXTN1gZu0zEsuFAQup0g7L+CJAWR+rGalWi5KC6kBhwK3Kk78CyQhPS5SSKSQgiVF9pGgWi9PrgE9+4OYTk2Y+9PWopI+K2efzN6RytdN6cepkb0k0wXTkADOuF+zwNLI/63t+lchsLxofdZl4SgS4W8i5Qmr+3NzTqNhsV51ZWAqmCl82N8ReaAFIzpF55zJct0C7qS
 pVajKKSv
 Unqxuz9p4wlQxr7FDLi2/7NLyE8UOC6zQ5yxo1A0iOUo5GxOHSYl2c7HHROkkAzILBtD63EF5b1kKwpXWaq30JhrKdbYgR1W1aOoxx5R719N4dmzJYMMLckSAGLen2OkG4SDeOPDwHfes0WNEMu2IXGL3p0HPDeaRG+XGmuu+q7WL7BZTemqYx+9OsNVe7mnOA1ymq9LZVkdr1gYj4YLaKmCHPGihqg1Ae7C5/ZN21lubC3PoIE9NbgL9MYJwiXqGfYd+wJgrMEgdaYXgEs15ai6AF1MTfTTJ8aEa9jCjs92py5aHlWlFfRATPxWsc7iRCucsoojIJ/XdK2a6ptHYtf4cwhVNB09dbJLj5rRsWTajY7+FLuYFFcXJnfnlLENXXOzGkV2Jy//zp/Wkl4WIfa1pVZ+gWsf+3//QSX02QInjV9ByBJymn926RdOe7PdPQwFkhS7r/BRFjBZ+NflCeVyxKb7q4Sv8jfd0VEpF2/rKMX4M7ABqEtzLAQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 20 Nov 2026 09:31:23 +1100 Alistair Popple <apopple@nvidia.com> wrote:

> On 2026-11-20 at 00:39 +1100, Zenghui Yu <zenghui.yu@linux.dev> wrote...
> > From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
> > 
> > migrate_remap_fault sizes its working set from the PMD page size and runs
> > 24 combinations of migration/mremap parameters.  On arm64 with 64K base
> > pages the PMD size is 512MB, so the test churns through tens of gigabytes
> > of memory and takes ~32 seconds on my test machine.  This just exceeds the
> > kselftest harness's 30s default per-test timeout (TEST_TIMEOUT_DEFAULT),
> > and the test gets killed with "Test terminated by timeout" even though it
> > is making steady progress.
> > 
> > Raise the timeout to 120 seconds via TEST_F_TIMEOUT, so that the test can
> > run to completion on configurations with large PMD sizes.
> 
> I guess the alternative is to reduce the number of test combinations, but that
> seems like it would reduce coverage so this seems reasonable. Adding Balbir to
> CC in case he has thoughts though.

32 seconds is just too long.  We have ~1200 seltests!  Imagine if they
all did that.

Can we figure out how to make this test a lot faster?  I slop-coded a
thing (below) which halves the runtime but it still needs to be taught
to do at least one full-PMD MADV_NOHUGEPAGE run on systems with a PMD
larger than 2 MiB.  And 15 seconds still sucks.

See, if running all selftest takes multiple hours then lots of people
just aren't going to run selftests and that harms our overall project. 
They need to be snappy.

If we can't do this then I suggest we find a general way of excluding
exceptionally slow tests from run_tests unless the user explicitly
passes some --i-am-very-patient arg.  But that's out of scope for this
present timeout issue.

Zenghui, are you able to figure out some way of speeding up hmm-tests.c
to avoid the timeout without compromising test coverage too much?

Thanks.



--- a/tools/testing/selftests/mm/hmm-tests.c~selftests-mm-hmm-speed-up-migrate_remap_fault
+++ a/tools/testing/selftests/mm/hmm-tests.c
@@ -2250,7 +2250,8 @@ TEST_F(hmm, migrate_remap_fault)
 {
 	struct hmm_buffer *buffer;
 	unsigned long npages;
-	unsigned long size = pmd_psize();
+	unsigned long pmd_size = pmd_psize();
+	unsigned long size;
 	unsigned long offsets[3];
 	unsigned long i;
 	void *old_ptr, *new_ptr = NULL;
@@ -2258,16 +2259,17 @@ TEST_F(hmm, migrate_remap_fault)
 	int *ptr;
 	int ret, j, use_thp, dont_unmap, before;
 
-	if (!size)
-		size = TWOMEG;
-
-	offsets[0] = 0;
-	offsets[1] = size / 4;
-	offsets[2] = size / 2;
+	if (!pmd_size)
+		pmd_size = TWOMEG;
 
 	for (before = 0; before < 2; ++before) {
 		for (dont_unmap = 0; dont_unmap < 2; ++dont_unmap) {
 			for (use_thp = 0; use_thp < 2; ++use_thp) {
+				/* Keep a full PMD for the huge-page cases. */
+				size = use_thp || pmd_size <= TWOMEG ? pmd_size : TWOMEG;
+				offsets[0] = 0;
+				offsets[1] = size / 4;
+				offsets[2] = size / 2;
 				for (j = 0; j < ARRAY_SIZE(offsets); ++j) {
 					int flags = MREMAP_MAYMOVE | MREMAP_FIXED;
 
@@ -2309,8 +2311,10 @@ TEST_F(hmm, migrate_remap_fault)
 
 					/* Check what the device read. */
 					for (i = 0, ptr = buffer->mirror;
-					     i < size / sizeof(*ptr); ++i)
-						ASSERT_EQ(ptr[i], i);
+					     i < size / sizeof(*ptr); ++i) {
+						if (ptr[i] != i)
+							ASSERT_EQ(ptr[i], i);
+					}
 
 					if (!before) {
 						new_ptr = mremap((void *)map, size, size, flags,
@@ -2321,8 +2325,10 @@ TEST_F(hmm, migrate_remap_fault)
 
 					/* Fault pages back to system memory and check them. */
 					for (i = 0, ptr = buffer->ptr;
-					     i < size / sizeof(*ptr); ++i)
-						ASSERT_EQ(ptr[i], i);
+					     i < size / sizeof(*ptr); ++i) {
+						if (ptr[i] != i)
+							ASSERT_EQ(ptr[i], i);
+					}
 
 					munmap(new_ptr, size);
 					buffer->ptr = old_ptr;
_


