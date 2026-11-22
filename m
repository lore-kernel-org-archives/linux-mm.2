Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 277D3606A33B
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 09:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=wBlI7zm4
Received: by kanga.kvack.org (Postfix)
	id 2555E6B00EF; Sun, 22 Nov 2026 04:52:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DEEE6B05B0; Sun, 22 Nov 2026 04:52:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 081F46B05B1; Sun, 22 Nov 2026 04:52:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D0B2D6B00EF
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 04:52:52 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D14C3C06A7
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 09:52:50 +0000 (UTC)
X-FDA: 85462290900.10.2B97BA7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0656C140007
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 09:52:48 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=wBlI7zm4;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795341169;
	b=N8OJcTdRphMo1jA6tvu+zRtd+oURrz7k27aIVr9JpnfAPJicD0hFbSRIusrCL6/yshl9Dw
	CbxFjBeuh/xsP/IXDU/BPw7nsMW4Y78MunxCm9FgiWpmA5stZGxYiAS+JVgr69kWjJT4EM
	3NnHNfr7c6/2ZwX+hl+FGQtN+rXCeFM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795341169;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=530GHac6mJJlARMcZhnSyYnD4ziuOybglG1oyg7MtIg=;
	b=bL1OPwZT2ZFBw4TSpLv1g8aHnbHinYuOe5D4bUpPRbXqTe4x6iV3sOHP6q+qAj5iP15uZ1
	OlV9X0ywQnPTbCuf7QkDMoI4JicVpFVrLyP5QpGgZl+7Pjhm8U/pNNQIauFUdJsv2gg87S
	udrLxP8u2fszpoP+NbClpU4seTVZE/s=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=wBlI7zm4;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EFFC36137B;
	Sun, 22 Nov 2026 09:52:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C1F21F000CF;
	Sun, 22 Nov 2026 09:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795341167;
	bh=530GHac6mJJlARMcZhnSyYnD4ziuOybglG1oyg7MtIg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=wBlI7zm4CR5lvitfKL08hDnNAC74F8f+kW0/gspGe5h/qgWpc/cDxmPZCWZGcZXMK
	 6435A7gXWZuVpxZl8DxkEyJP2dF3PN0HG6NxxY/BpORklPI0tlIcLZ+44lGFN1fJz8
	 8PPE4FYITG56tMZ4obJfZ1VG4loUfPk0as+pg458=
Date: Sun, 22 Nov 2026 01:52:46 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mika =?ISO-8859-1?Q?Penttil=E4?= <mpenttil@redhat.com>
Cc: Aveline Noir <jm5905938@gmail.com>, jgg@nvidia.com, leonro@nvidia.com,
 airlied@gmail.com, apopple@nvidia.com, balbirs@nvidia.com,
 christian.koenig@amd.com, dri-devel@lists.freedesktop.org, Francois Dugast
 <francois.dugast@intel.com>, intel-xe@lists.freedesktop.org, jgg@ziepe.ca,
 leon@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Lorenzo
 Stoakes <lorenzo.stoakes@oracle.com>, Matthew Brost
 <matthew.brost@intel.com>, mm-commits@vger.kernel.org, Patchwork
 <patchwork@emeril.freedesktop.org>, SeongJae Park <sj@kernel.org>,
 thomas.hellstrom@linux.intel.com, Vlastimil Babka <vbabka@suse.cz>,
 ziy@nvidia.com
Subject: Re: [PATCH] mm/hmm: account for subpage offsets in device-private
 PMDs
Message-Id: <20261122015246.d8b6b98ff5a8157168156339@linux-foundation.org>
In-Reply-To: <36be0904-168d-4813-82ff-27ecced464e3@redhat.com>
References: <179342234355.4.16705453209886955762@gmail.com>
	<20261121160037.1a479f3c8b4e860bc23c106d@linux-foundation.org>
	<36be0904-168d-4813-82ff-27ecced464e3@redhat.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 0656C140007
X-Stat-Signature: 3hjokqwh9cjj9gqwueoj5n8uw6eqafay
X-HE-Tag: 1795341168-77028
X-HE-Meta: U2FsdGVkX19k/dfsC2C84hGdhCYWbnuFfbqyJbrRYPuS4MBUXDi8Wwgw9KhSncNVI7YCyHfgjKD3CI01D3cERGIWeYu20fku5rvwLJH5ZLQijhIbqz3Ol+pf6XWRInJ48XROCCHeetVxkkR3kITnqL5ghWMkjctgs7iuIjRRtgwBUWoNHjpPzEWwVRD54v592Ms6w4NM2hKvGlEEqL69ibIaeq11FfirPYVcMMEKR3scnqdMiY1VSxANaWftRAdmc3XloaH7QPXicYujZ3S/JFimhwH/LE8svew9U5wr1VN7NVRIhzqLLkcy7vIvZlzn3/qr18w+tgXHbtqVlFWRL6l02fuC26Nj8iXo6h8TGoVhlrWrnsYoq13ZjCaVhj6kJDz3bvnzyhTtgJ06FUwy9MEumWFky2tOHCqpTwvkrdcU/tvUsVslQkgqmvc2SLzQsq9ee6Yd02JsGk+FQiV3H4fH/jaSZ+/FSC2W3isCSZQimc1cSBticYLIHWx2oC8mxO57ah5NXIGTrigx8zZ5reSygrf8zfc5tCjEfTZrp4U/nrAGFJ0QIp3BwFtCUXOCUTEcjUSOAURAqVi4E7xV4uNXwjH8mh85/yDHg13ARY2OUrR8YEy3+1/Ha01jpXA+wfQyerCV11pnBE7O5x5iR87WuXfxYDD+u3mbIMiqiqZZW0EX7CQmsjqYIn2jSLKWF5nnhbxKbtbNr3JN5b0cIwGvvEGyS0aXOkcM9DZgWdh1gfmfucsPPJ5ZO9Z6UEtLilWiyhZXEeC6iKm77t4X23beMwW5tqI4OweSD3GKBBa4SoU78SNboB5Qvi2+E3TF89roJDKwHgXWbP1hp7qqRvUWbkw0EvK7V0g53d2AOCUXM4YTfLPjfv5RjAED/ZpAjA1yvWxFSsymXcxeWWQk8LxkteZbvvt8UIjBmU8srTlVL0busrxOaZhjeZlSJ5/qWFVqF86rXJcThbC6uNl
 JRhMpjPE
 4S8AZ5aD39nBnK/KP5LfTImQa0S7v2myv3K+4BZdfnLJEvq01pWejPk7bX993cekdetxIF9n9MrW4K0tzlZMNny6kY2zuEmxI51Hzjj8Ebq8fQbKvGQACVc2JdT+ulOVIDQGws/TIrrCUlbJyNUoW7Im/56UDuMa6IuGCRCHSVntv5qTMqDfPh2K+hwG0com/YlgZz2JIWNmTiw2zqVHeQ8ycXWCtkYbhnoK6T8l97WIiQ42FWZAFGdm9Sdeglrdzk53gsHyVuOuMCdyCoS8oa0RxI+jFPNeaa1RZ7DjPk0zbHL6kS1PzLkWCQLFnJfIbmAuguzVLI8CCAp/yHVtKcVO+hs41kMXDXcCKyzxbI+xcA6NvExAoKMGDjl+7qkapXUs3xp2xjvSiUEefEBcxug/IxzZ9jm3Iwz4oKCEkpcbxEWMMaqBvij+Cg7P/d6MwnBHPOzeVsgiWsh22swZXrfLIuy8LLXu//uFhjtt3z5rhA4y3b9uGsc0t0r0eNIA2+0pZ4RTnhrOg8Nh3cOLbj72J/XQ1qw85mn1rYNAdlcum2w5E/QxNIdwsx5/QENeRTsvVRDQ1KSArjTj3l3sPBgoGwQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, 22 Nov 2026 07:55:37 +0200 Mika Penttil=E4 <mpenttil@redhat.com> wr=
ote:

> > So it accidentally found a bug in lib/test_hmm.c on the way.  "The QEMU
> > run exposed a real test_hmm bug: a second open of /dev/hmm_dmirror0 can
> > put a device-private page into its page table, then dmirror_do_read()
> > tries to copy from that non-CPU-accessible page and oopses".  I'll prep
> > a fix for that separately.
>=20
> I noticed that also and will make changes around it in my series.

I came up with the below.  It all tested out OK.  wdyt?  I guess it
should have cc:stable>



From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib/test_hmm: use backing pages for device-private mirror faults
Date: Sat, 21 Nov 2026 17:06:45 -0800

When one hmm_dmirror descriptor migrates memory to device-private and a
second descriptor reads it, dmirror_do_fault() stores the device page in
the second descriptor's page table.  dmirror_do_read() then passes that
page to memcpy_from_page(), which can oops the kernel.  This was
reproduced with an unprivileged process using the fake device in a QEMU
guest.

Store the corresponding RAM backing page instead.  For a large device
folio, retain the subpage offset when selecting the backing page; using
the backing folio's head for every entry would return the wrong data.=20
Extend the existing PMD migration selftest to read the last subpage
through a second open before faulting the memory back to RAM.

Fixes: b2ef9f5a5cb3 ("mm/hmm/test: add selftest driver for HMM")
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
---
tl;dr: The unpatched kernel oopsed when an unprivileged process opened the
fake HMM device twice, migrated an anonymous 2 MB PMD to device-private
memory through one descriptor, then accessed its last page through the
other.  The patched kernel returned the expected bytes on all three ioctl
paths.

A was reproduced and saved before B was built.  As uid 65534, a static
userspace program verified that all 512 pages were device-private PMD
entries.  A READ of the last page through the second descriptor produced a
KASAN-enabled kernel Oops in dmirror_do_read().  Independent A boots also
oopsed on WRITE and READ_UNLOCKED at the same last-page access.

With only this patch added, READ and READ_UNLOCKED returned the expected
0x0a byte, and WRITE returned the expected 0xa5 byte after migration back
to RAM.  The modified in-tree hmm_device_private.migrate_anon_huge_fault
selftest also passed (1/1).

This reproduces a userspace-triggered kernel Oops in the fake HMM device
used by test_hmm; it does not establish reachability through physical GPU
hardware.  QEMU guests used matching kernel configurations with
CONFIG_TEST_HMM=3Dy and KASAN.  The guest device permissions were set for
uid 65534.

 lib/test_hmm.c                         |    7 +++++++
 tools/testing/selftests/mm/hmm-tests.c |   14 ++++++++++++++
 2 files changed, 21 insertions(+)

--- a/lib/test_hmm.c~lib-test_hmm-use-backing-pages-for-device-private-mirr=
or-faults
+++ a/lib/test_hmm.c
@@ -292,6 +292,13 @@ static int dmirror_do_fault(struct dmirr
 		page =3D hmm_pfn_to_page(*pfns);
 		WARN_ON(!page);
=20
+		if (is_device_private_page(page)) {
+			struct folio *folio =3D page_folio(page);
+			struct page *backing =3D BACKING_PAGE(&folio->page);
+
+			page =3D folio_page(page_folio(backing),
+					  folio_page_idx(folio, page));
+		}
 		entry =3D page;
 		if (*pfns & HMM_PFN_WRITE)
 			entry =3D xa_tag_pointer(entry, DPT_XA_TAG_WRITE);
--- a/tools/testing/selftests/mm/hmm-tests.c~lib-test_hmm-use-backing-pages=
-for-device-private-mirror-faults
+++ a/tools/testing/selftests/mm/hmm-tests.c
@@ -2087,6 +2087,7 @@ TEST_F(hmm, migrate_anon_huge_fault)
 	void *old_ptr;
 	void *map;
 	int pagemap_fd;
+	int fd2 =3D -1;
 	int *ptr;
 	int ret;
=20
@@ -2143,12 +2144,25 @@ TEST_F(hmm, migrate_anon_huge_fault)
 		}
=20
 		close(pagemap_fd);
+
+		/* A second open must read the last device-private subpage. */
+		fd2 =3D hmm_open(variant->device_number);
+		ASSERT_GE(fd2, 0);
+		buffer->ptr =3D (char *)map + (npages - 1) * self->page_size;
+		ret =3D hmm_dmirror_cmd(fd2, HMM_DMIRROR_READ, buffer, 1);
+		buffer->ptr =3D map;
+		ASSERT_EQ(ret, 0);
+		ASSERT_EQ(buffer->cpages, 1);
+		ASSERT_EQ(*(int *)buffer->mirror,
+			  (npages - 1) * self->page_size / sizeof(int));
 	}
=20
 	/* Fault pages back to system memory and check them. */
 	for (i =3D 0, ptr =3D buffer->ptr; i < size / sizeof(*ptr); ++i)
 		ASSERT_EQ(ptr[i], i);
=20
+	if (fd2 >=3D 0)
+		ASSERT_EQ(close(fd2), 0);
 	buffer->ptr =3D old_ptr;
 	hmm_buffer_free(buffer);
 }
_


