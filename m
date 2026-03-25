Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8EA19109E528
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 23:14:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F396C6B008C; Wed, 25 Mar 2026 19:14:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F11466B0092; Wed, 25 Mar 2026 19:14:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E27186B0093; Wed, 25 Mar 2026 19:14:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D1C2A6B008C
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 19:14:08 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 68656140A65
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 23:14:08 +0000 (UTC)
X-FDA: 84586140576.29.4490DBB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id B286680013
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 23:14:06 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=DzPlWLZ1;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=DzPlWLZ1;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774480446; a=rsa-sha256;
	cv=none;
	b=1uorwJKtGOaZY8TDN7cnpDAZatjo0kwPQ2JOnkpyfeIcEFLRj4ejEDAGzt7/l4KTPybO1O
	esQDWUbnBn0NHN8ekjNECBSu2DLVu8sWYqhH8oIdnwIJO1QjHcX+JRCUu+9Yxz40IhzZPE
	ZJoc6+xRG3yWnYUfvj1cVE7eGSAmpuQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774480446;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kgaD18qe8jStVcw2kDpgAj+m0dRSVrb734oChX9FLds=;
	b=mJR3fq8CN+Qs+ITMPwKdEkNFmpY2i+jl5iEl4naW0taR9OZvb14qHVnW0QbJG/lQfApKi2
	DHm7arIf61EAx1E+HwR6FU6rbRbPgeLddfVPABdvTKxPQiIcyaE8f9oSlSVHeQiWTq6esU
	TANME6+QB0jyr5vogIlbL8EfyK0aXpY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 29F2C60053;
	Wed, 25 Mar 2026 23:14:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EECCC4CEF7;
	Wed, 25 Mar 2026 23:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774480445;
	bh=haZVXxeBGIxeTbMGR2l+K3ghTX1dn/WL8wdUhji0HaA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=DzPlWLZ1jCtwp23rJXoQing7SVhZ2BAEcteSdO5u4bi/w0SRokpfrVIW08GObOv/V
	 xJ6G3WOL84PORYN9lDn+Q8f7wJmOAwP+udoI5mryoNhLqR5oBTUtFqY+PqWOcMHKhq
	 gbwKcCZqcJ6qaEgzuFwOhCqvCTBPEQ/c50zX9Yag=
Date: Wed, 25 Mar 2026 16:14:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: linux-kselftest@vger.kernel.org, rppt@kernel.org, shuah@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, dmatlack@google.com,
 pratyush@kernel.org, skhawaja@google.com
Subject: Re: [PATCH v3 0/2] liveupdate: prevent double preservation
Message-Id: <20260325161405.0840dea1549b13c5a1653462@linux-foundation.org>
In-Reply-To: <20260325182026.467307-1-pasha.tatashin@soleen.com>
References: <20260325182026.467307-1-pasha.tatashin@soleen.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B286680013
X-Stat-Signature: frw14dsj8pxxjmmycw8f6m74hubtyiib
X-Rspam-User: 
X-HE-Tag: 1774480446-387966
X-HE-Meta: U2FsdGVkX1/VAowdzD1iNAgJ0vqdpLUgLlrHfyTcZ3RUQG4erSXCdiDp8vTnvJkzuac6zSeQic34EcAknDuKQeDWp1E7kqZFGd+NF8D2q4qk1++zgJwJJh4Bz3v0w4ZqbrkDrv3EchyUOaEWfX0a6d+EhnOrWmtpvOL/JTLQyND9HD5JMJ+5uo1H5keCKbR2h8SfzDGrmRAa1zVYZFKPBZwFHDS138Ot9il8ayvaXym8xPowOh7GbP2FCDlyaX+qMqXJgT90ueBTiSmmoVKRtzO58ijYPP3jRQ0exiyLeVb+Hi9vEGo2PIZXMYwGzqHc0DRcoy9z6kiH+128N1Ah/QTV1PbM+Jzo+H5W10xumX88EUaCPGMGf6ytkvrRLT6Y4f+fo5HxSMO6FjBOCTnqnxsw9ph+DTI+cP2CGmxj0iM9aDdXnK3huQoszK5d8YMwDXPpGJSZ3Es8DkIKCGgw3wRrCj4EhHUsCcEX+e85Bgu+LQgxOoBkFwcge3d9LMdT0dUAU2bbOoSGLDd5Oc6PDxpw0s0lSTjhKqqGlVcPoycx3FsXN08J8dhqtozuOca0iKvhVhfn03OsaImfR7dls5Nxhqw6Z6N2sBN1TSoAuQ3uALpJtCByFNLvh+n5QIpI1qUqFEs6s3kY5wnNYZI77Fun4oXM7cxTKr/iZymm8qyNTyMz5TK1CxxlxPVhhW9qQTrQdaCrlcjWvZrPo9UqubkYv6iBWx+8nPyJQl9i9qetKIJ9OK4MEXwSpBHwY7xEFt7V1lDt6T5SEJFlCiSzzSY4aAdxsGAf7/SR8WKDmpneEUvJfno+pagL/z5AIitDwTdJ0/J8l/aeAHeJp1cfntQc9lTG53troyKdl4BhiPOHQ09dZICCtv5z3Vr+5CpBIO1NmpcxK9QOcSHueEO5TkpdVyVY62RZAVcYWpu8DffSv6S02ZyOB9AxcEHSdHjxJpfQPbijcYx2WwWaHzS
 w1R25+0v
 T9OjtFgQkeC2XnATyA7f59qrbc7j589/k5g7fZokNOid9ZExldGjme5vs9AdqmL1GXTnvU5zJ8udyBPpp47KmwyoEujU3s69s9ydoverf7aIhRq22VBJSUXizjRuNGVfWXHoXJb0PXCGiqoRR8UEZW1y2GfQmKXmqYPyuB40Md8Kx2zNVqQl96Qs3RcbodvdQHtuxWzuQGVsIwBzi/XXwOjpJUAPF8PqWo7np/+HqtYx2aw6KhcGGeE9Ji4qS8CPkYU50fcR8tcGqKiDAHo0MPED1meOOBBnMSMBP+hmQIGbCb8mOOB75gHaaQQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 25 Mar 2026 18:20:24 +0000 Pasha Tatashin <pasha.tatashin@soleen.com> wrote:

> Currently, LUO does not prevent the same file from being preserved twice
> across different active sessions.
> 
> Because LUO preserves files of absolutely different types: memfd, and
> upcoming vfiofd [1], iommufd [2], guestmefd (and possible kvmfd/cpufd).
> There is no common private data or guarantee on how to prevent that the
> same file is not preserved twice beside using inode or some slower and
> expensive method like hashtables.
> 

I updated mm.git's mm-new branch to this version.

> Changelog:
> v3:
>  - Renamed luo_preserved_files_xa to luo_preserved_files (Mike)
>  - Added xa inserts during restoration, so a file that is not yet finished is
>    not preserved at the same time. (Sashiko)

Below is how v3 altered mm.git.

It appears that some significant changes are in the works.  Please lmk
if there's actually value in keeping v3 under test, or should I just
drop it?



 kernel/liveupdate/luo_file.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/kernel/liveupdate/luo_file.c~b
+++ a/kernel/liveupdate/luo_file.c
@@ -117,7 +117,7 @@ static DECLARE_RWSEM(luo_file_handler_lo
 static LIST_HEAD(luo_file_handler_list);
 
 /* Keep track of files being preserved by LUO */
-static DEFINE_XARRAY(luo_preserved_files_xa);
+static DEFINE_XARRAY(luo_preserved_files);
 
 /* 2 4K pages, give space for 128 files per file_set */
 #define LUO_FILE_PGCNT		2ul
@@ -282,7 +282,7 @@ int luo_preserve_file(struct luo_file_se
 	if (err)
 		goto  err_fput;
 
-	err = xa_insert(&luo_preserved_files_xa, (unsigned long)file,
+	err = xa_insert(&luo_preserved_files, (unsigned long)file,
 			file, GFP_KERNEL);
 	if (err)
 		goto err_free_files_mem;
@@ -334,7 +334,7 @@ err_kfree:
 err_flb_unpreserve:
 	luo_flb_file_unpreserve(fh);
 err_erase_xa:
-	xa_erase(&luo_preserved_files_xa, (unsigned long)file);
+	xa_erase(&luo_preserved_files, (unsigned long)file);
 err_free_files_mem:
 	luo_free_files_mem(file_set);
 err_fput:
@@ -378,7 +378,7 @@ void luo_file_unpreserve_files(struct lu
 		luo_file->fh->ops->unpreserve(&args);
 		luo_flb_file_unpreserve(luo_file->fh);
 
-		xa_erase(&luo_preserved_files_xa, (unsigned long)luo_file->file);
+		xa_erase(&luo_preserved_files, (unsigned long)luo_file->file);
 		list_del(&luo_file->list);
 		file_set->count--;
 
@@ -622,6 +622,10 @@ int luo_retrieve_file(struct luo_file_se
 	luo_file->file = args.file;
 	/* Get reference so we can keep this file in LUO until finish */
 	get_file(luo_file->file);
+
+	WARN_ON(xa_insert(&luo_preserved_files, (unsigned long)luo_file->file,
+			  luo_file->file, GFP_KERNEL));
+
 	*filep = luo_file->file;
 	luo_file->retrieve_status = 1;
 
@@ -717,8 +721,11 @@ int luo_file_finish(struct luo_file_set
 
 		luo_file_finish_one(file_set, luo_file);
 
-		if (luo_file->file)
+		if (luo_file->file) {
+			xa_erase(&luo_preserved_files,
+				 (unsigned long)luo_file->file);
 			fput(luo_file->file);
+		}
 		list_del(&luo_file->list);
 		file_set->count--;
 		mutex_destroy(&luo_file->mutex);
_


