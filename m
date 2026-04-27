Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2D81FF885E
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 12:33:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5EF0E6B009B; Mon, 27 Apr 2026 08:33:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A0466B009E; Mon, 27 Apr 2026 08:33:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DD1C6B009F; Mon, 27 Apr 2026 08:33:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3B8C06B009B
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 08:33:51 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E2CCDC0442
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 12:33:50 +0000 (UTC)
X-FDA: 84704277420.02.0D47FFF
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf17.hostedemail.com (Postfix) with ESMTP id 073F94000B
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 12:33:48 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=q1uWzxPq;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777293229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=le6hydx/0AV9ez00tRp6YUb5tjV/ytJlHiXxDmzs5Fw=;
	b=dj2jDCdFPwwbBoIdcBuMs0kIu9PRANI1Uf0gaOxa636ZVg+cNVUOYFo1l7zlhizmuzHpd/
	sDytCCYTA8t8/PmtMbJz/Y1Z1dUdc/ei8DJCSPUmQ6yrXP3M8uJk1FIrpB0FmhYHJsR85l
	DnJBSzt5oj3Ir+R/HimHlbLgu2qBNCk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777293229; a=rsa-sha256;
	cv=none;
	b=Wg2hD23PSFkuEVOieiDFAc+pR+pzibqOoFFu9bi0j3h4zpE6xozantZAVdsiDXniU5V0kW
	OgCDI9FdrWbGFTjSD/IYBoL3osDZg48/EGugZHOe6yDeipNdna1UuufUnFjG38g2l/Lz6O
	O62OSN+fY//JwR1Oz64Vkw6rcfM3Lwc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=q1uWzxPq;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777293225;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=le6hydx/0AV9ez00tRp6YUb5tjV/ytJlHiXxDmzs5Fw=;
	b=q1uWzxPqZjeOSed5zBa2SVBta4POQ6DRm/xYANV+EBMy77g8C/H+CzzJafOcG8lynu166S
	nXOHZ+9j6PscxlvuS3RqwUkBiSg+g6O3acv5kW02iALlOujnhGt7QECEOGiXFVsD8NGbvb
	vlQyW3Mz0hVavf/L7W6oqgebqmdtJx8=
From: Lance Yang <lance.yang@linux.dev>
To: leitao@debian.org
Cc: linmiaohe@huawei.com,
	nao.horiguchi@gmail.com,
	akpm@linux-foundation.org,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	david@kernel.org,
	ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	kernel-team@meta.com,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH v5 1/4] mm/memory-failure: report MF_MSG_KERNEL for reserved pages
Date: Mon, 27 Apr 2026 20:33:30 +0800
Message-Id: <20260427123330.92847-1-lance.yang@linux.dev>
In-Reply-To: <20260424-ecc_panic-v5-1-a35f4b50425c@debian.org>
References: <20260424-ecc_panic-v5-1-a35f4b50425c@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 073F94000B
X-Stat-Signature: o58ihqr3d6reyuje1tun7h64pwwt97j6
X-Rspam-User: 
X-HE-Tag: 1777293228-600253
X-HE-Meta: U2FsdGVkX19Rb9qAnhTboLzuHq/v+hDyvZwXsX6mS3Z4bH+W4FaHLnX8D6obBfL9TNkr2VqQfeD3uKW5LoXm2wrxnQXws459jFRLCk80nXThEbK9XmjQqbTnxWLlKJrrxDGFJrZ70S+16JKauwlOvP4tKlmSopbfWEyv/kmUQ9gBl2ncam8TGQQkirPwbA0YbNSJ4PZ9MTESczJLwwm8LnrLwwGRoYFszjJwJffScvHZ0pnjjEdLSuz7uwsMY+C8rcEgd52sI0o7H3I+ycHeM9Fxsz33Cxi1VXk6QLbTKrkAgw0znDCZ1oL6fFsiA4HikP/vczT5CJKVYHiRvJAhmsUx3YonPV0CBoqdktEqmayI6jzzMJYFvzxR+VSsUGn5rJmBFAY7yIZLFoTh+bqaFS/ANjuuppXnoJxwx0z+82cfI3rIlBPPBGu0Xuw7lRDZRSHJVL4NhDpR131mbWZ3n90JUNNlu7eRvxJpwX76PFzo24yCi2TVEBupQxyZ55XoH/NY7A/EXenwy8t55me0KBFXv78N7KEoiv3Pg9n60tY4oc9WzdAaBiXP+kuM3MFHioa7ao/pnIMTR7a7Rkjg0SyEx/1IXtOD0FZJ6pJDXADX7r+cHjLrhMhJVeoIR6Zw2qS5QmASmMultnxB0MBQL1EKULsPq/7WCDq8tUx5aywsvdkyHqfX015I254tfVKRBjaLUi4rUgN+MXuQc/lKC78nXuWMI8QqZO4n9DBklo34rBQtPKlThCzdNYVTy2aVg+sgZNVnxw513ufmqCGgzmd9kIFKUGwL1mpnXq1rlakXjlwgHrdQatWA5Oz3O0m2k2NaqG2/7kdzVc88DlFSqwzFOosOFJOgXHMkgk8+OsrOgH/g5v19gEuWN+pRBik53XWZdTCdbCoy8Qds9Y8ZJfs6JuzCRMQ51UCYRLsBCW+7GbYNeUEiN+j2YTlv15S9+ujeYO9TgE38LrYbqHM
 sCmVgbTl
 7oAoLn2mSoth7lY3Rde3LL+WaefzQmAPrE4OQ0alj+z8N9Lw08YubT+VGycKg2kQvG7bGpBD8rlkLfBl/cyWR6YZt7vtx5v41d6FFWWLMJEMhvcfJJO6X3bqFLKi43AKRIRWJVwZPpftIaOMIrHdaGPUesTT3gz5QR1m8OPz2Hv31x5y5CHl6eHBsJlll3SO9UVuN3TDq5BZFk+hXGCKPaVoxDpjja1QXZtX/uMf9doobEFiVb57M+XqkCBTbqU7yg16xd0kzljQqs9ouQ/KMj04o+bao3TQrQefEo+RPf+Sex8cEJ1gTtoRQDhbCfbyrx9X11+hS3xJFQYPlRmqAuEMr+5bjsiw0CG7qnCbbFSCBPvpvpkzpyfsyFw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Fri, Apr 24, 2026 at 05:23:59AM -0700, Breno Leitao wrote:
>When get_hwpoison_page() returns a negative value, distinguish
>reserved pages from other failure cases by reporting MF_MSG_KERNEL
>instead of MF_MSG_GET_HWPOISON. Reserved pages belong to the kernel
>and should be classified accordingly for proper handling.
>
>Acked-by: Miaohe Lin <linmiaohe@huawei.com>
>Signed-off-by: Breno Leitao <leitao@debian.org>
>---
> mm/memory-failure.c | 11 ++++++++++-
> 1 file changed, 10 insertions(+), 1 deletion(-)
>
>diff --git a/mm/memory-failure.c b/mm/memory-failure.c
>index ee42d43613097..7b67e43dafbd1 100644
>--- a/mm/memory-failure.c
>+++ b/mm/memory-failure.c
>@@ -2432,7 +2432,16 @@ int memory_failure(unsigned long pfn, int flags)
> 		}
> 		goto unlock_mutex;
> 	} else if (res < 0) {
>-		res = action_result(pfn, MF_MSG_GET_HWPOISON, MF_IGNORED);
>+		/*
>+		 * PageReserved is stable here: reserved pages have
>+		 * PG_reserved set at boot or by drivers and are never
>+		 * freed through the page allocator.
>+		 */

Not necessarily. PG_reserved is not a permanent lifetime property for
every page that has carried it.

page-flags.h says early reserved pages may later have PG_reserved
cleared and then be given to the page allocator :)

At least some drivers also clear PG_reserved when releasing pages they
marked reserved.

Would it be clearer to say that pages with PG_reserved set are not
currently managed by the page allocator, rather than saying reserved
pages are never freed through the page allocator?

Otherwise, LGTM.

Reviewed-by: Lance Yang <lance.yang@linux.dev>

