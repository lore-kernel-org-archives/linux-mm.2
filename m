Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA19ACA5FE6
	for <linux-mm@archiver.kernel.org>; Sun,  4 Oct 2026 20:07:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 695536B0088; Sun,  4 Oct 2026 16:07:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6449B6B008C; Sun,  4 Oct 2026 16:07:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55C996B0092; Sun,  4 Oct 2026 16:07:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 360CC6B0088
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 16:07:56 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 423301C4011
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 20:07:55 +0000 (UTC)
X-FDA: 85286029710.23.80443CA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 87AAC100003
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 20:07:53 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Mx3OeGyw;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791144473;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F2CprrIV1+vnrvZtv7aumlrns7J0kiy7ez1pluHWuPI=;
	b=IZhyReXUAqKXCOXtrk/hu904trY7JVbU5B+imMcOgMT+X06GVljEc99Uo6Ll4DpbJ/TX63
	jQdXoyyeQYQKmn2TqPV9IeUqhuZgaG1cpsdrIAF+aCShGmD2hP/gs2Gv7izyof/HsymSXk
	dn519YPbnti07UzQiEoU9UPWjrHbrMQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Mx3OeGyw;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791144473;
	b=tyDoRe1P2lnScPqPfiwb90qUlzpIos12EaifyoPOXndagVnV96wMcrokTTYRAVmvGVSbI4
	0w4nxJDbDnzxMczPM61UYv0P56CEI9y8QqfHEg6AWx8V6n+yqnXCh6WtBFI2aWRSms/EBD
	nTT4TLEyAgo/vFC1Uk9hzvW7O4uk0SQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BCAD9601F7;
	Sun,  4 Oct 2026 20:07:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE9B01F000FF;
	Sun,  4 Oct 2026 20:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791144472;
	bh=F2CprrIV1+vnrvZtv7aumlrns7J0kiy7ez1pluHWuPI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Mx3OeGyw4mBMuZbhxP+kZ8Yze1JJTWm6pV1IAfezi4CT5EdyzeaQ4TdJfJEW6VwBl
	 p8EdqXusXxKObgj9b4Q4/xfVD61oTz+Gb23FrCuX4GO8LyEuMBBsTXivo5hQR43jZf
	 Dw65pGexM1LNSYVm+ZFNLaFjxvakbKogJgT96vEI=
Date: Sun, 4 Oct 2026 13:07:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
Cc: rppt@kernel.org, peterx@redhat.com, surenb@google.com,
 aarcange@redhat.com, david@kernel.org, ljs@kernel.org, liam@infradead.org,
 vbabka@kernel.org, mhocko@suse.com, shuah@kernel.org, kas@kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/2] userfaultfd: clear the inherited uffd bit in
 move_swap_pte()
Message-Id: <20261004130751.1cdab825ae521c16e02f66ec@linux-foundation.org>
In-Reply-To: <20261003103030.63380-1-donggeunyoo.kernel@gmail.com>
References: <20261003103030.63380-1-donggeunyoo.kernel@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 87AAC100003
X-Rspam-User: 
X-Stat-Signature: rt5wj8qowehyyaakgybab33pw1wqirmm
X-HE-Tag: 1791144473-38940
X-HE-Meta: U2FsdGVkX19iy/pQmq9VDB2COEJMSBFebc+etq0rBOy4i3jF5fLCc+FVrK1ByRR7f5dOeSuOXxZMA8sNqcKiYv7HNVum17VhrtcoES82lzMsnWGiSOk6MdUZCLGmLjR/yyJj/aLDDarNGHCdmWRlNPMoyd2FlexvgQvdmMkkUrYTmnVhuqcVmb2/+b9GtZBW/MT2zbBW7c8fRh3yBRLJzPgDY3TG8EuDGERs3DQwl2AlyYkbvsnMHqYOUIgep17GBobZsn/v/oEvbxR3AA3yS9Eqvg7hkY90IUjYxahJDF4vVVGWd/JekuI1C8sR8qEBx58xpCD9saWjr/eeUdw6kM6qtmGNeOngksQdN59ES6S9EwHRnLdywv7JY/++G6J4rdEi7Q6Euo9Z0n7JSwIAUSyRrsF9e0+pmXf7bvfgN2R1ybnCSQn/26FvPdPkOlVKQGQtYmWjMK74QIVeswkfChF63oLf5D1Pfgy6aRomZMKga/VjnWe/aXblQUtQd5+y1DJuMOB1AmEhlalTb1yyi7hZ5qujDN+OLIDq5at2w4w2P3WSozvAR8L863r25w0vL0q8V5z0NxQbp7wAMxp49ylVoB3YfT4Wf46uISRaiAxZXqxJZh7YIunTzz2XoIKfKj8QmuSvvI2uAlnUlEwWHhKZDI1rCCOWaWjeyALmdOc1exUOu2yYxaVKhh4f3FOgVXEIY/7v8NtFtkdTKpzN0Ned3Up8eU5eWbO278RItyuXaD0SMY4UGAHUQB2Bw8AWkTgG5uGpghYkPld373bwZ3To4qA0xZylpeBXgp7tKUJGWSTd5/R2TYZjhMvgvcofvuaeYH+k67b4aNzISZ+HYp2KmZ7e9tFd6YoZNWStnUi8zTW2UZztt/+3UEmtoS/WlkMmL/C5fpcb5opva4ieSlKmDJbQCOlOQJjp1ukWoe4So0QVT1DW9I2oRVqssshrvkbD7bF9r1GjDqcdNIt
 4kbqVhrh
 L9zOKROj+Qpjf/iRLAVKstSdouKeRH1M6rvb5rQ+kC4HrRiKggUglNoHonmZTfS0YaHo2R/i23A2JyKtRbYPNALRIx1ZqEIkCB1ZxoS5AMarFLQ6smrtBW8XDCdWT0OqtIujIfInOSOKzLiDIecZQzudcvGDkPPoJ/XacrfgbTEfD4NaG67ncRsklG/eNGtTIy6eNX2Bpyq3viTp0+eSFA/3dXVqiw9rUnyvBIsdDTNuCu8HLih5N7417lWg7+IWBXRNZMxMz3FJp6ad+xT4lZ2FoWXZM16IbpMgUVTlXGc+uy+3LFtX6FOd8+XYGeajX42d6XrqhjxccdxAA8hS70PX492q/BhGJZdiXMX8rtPi1wc4sXUw8im20S6KmvU6gwchF38Hb5ISCRF8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat,  3 Oct 2026 19:30:28 +0900 Donggeun Yoo <donggeunyoo.kernel@gmail.com> wrote:

> UFFDIO_MOVE on a swapped-out page installs the source PTE at the
> destination unchanged, so a uffd bit set on a write-protected or
> RWP-protected source lands in a destination VMA that was never
> registered for either, and nothing clears it afterwards.  Patch 1 clears
> the bit, then re-arms it if the destination is RWP-registered, which is
> what the present-page and zeropage move paths already do.  Patch 2 adds
> the tests that catch it.

Thanks, I updated mm-hotfixes-unstable with this version.

> Changes in v4:
>  - patch 1: add Acked-by from David Hildenbrand and Mike Rapoport; no
>    code change
>  - patch 2: protect the source right after registering it, open pagemap
>    at the top, and use a designated initializer for the move (David
>    Hildenbrand)
>  - patch 2: fail only the test case, not the whole run, when UFFDIO_MOVE
>    fails (David Hildenbrand)

Here's how v4 altered mm.git:


 tools/testing/selftests/mm/uffd-unit-tests.c |   36 ++++++++---------
 1 file changed, 18 insertions(+), 18 deletions(-)

--- a/tools/testing/selftests/mm/uffd-unit-tests.c~b
+++ a/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -2049,28 +2049,29 @@ static void uffd_move_swap_test_common(u
 				       bool rwp)
 {
 	unsigned long page_size = gopts->page_size;
-	struct uffdio_move move = { };
-	int pagemap_fd;
+	struct uffdio_move move = {
+		.dst = (unsigned long)gopts->area_dst,
+		.src = (unsigned long)gopts->area_src,
+		.len = page_size,
+	};
+	int pagemap_fd = pagemap_open();
 
 	if (rwp) {
 		if (uffd_register_rwp(gopts->uffd, gopts->area_src, page_size))
 			err("register src failure");
-	} else if (uffd_register(gopts->uffd, gopts->area_src, page_size,
-				 false, true, false)) {
-		err("register src failure");
-	}
-	if (uffd_register(gopts->uffd, gopts->area_dst, page_size,
-			  true, false, false))
-		err("register dst failure");
-
-	if (rwp)
 		rwprotect_range(gopts->uffd, (unsigned long)gopts->area_src,
 				page_size, true);
-	else
+	} else {
+		if (uffd_register(gopts->uffd, gopts->area_src, page_size,
+				  false, true, false))
+			err("register src failure");
 		wp_range(gopts->uffd, (unsigned long)gopts->area_src,
 			 page_size, true);
+	}
+	if (uffd_register(gopts->uffd, gopts->area_dst, page_size,
+			  true, false, false))
+		err("register dst failure");
 
-	pagemap_fd = pagemap_open();
 	if (madvise(gopts->area_src, page_size, MADV_PAGEOUT))
 		err("MADV_PAGEOUT");
 	if (!pagemap_is_swapped(pagemap_fd, gopts->area_src)) {
@@ -2078,11 +2079,10 @@ static void uffd_move_swap_test_common(u
 		goto out;
 	}
 
-	move.dst = (unsigned long)gopts->area_dst;
-	move.src = (unsigned long)gopts->area_src;
-	move.len = page_size;
-	if (ioctl(gopts->uffd, UFFDIO_MOVE, &move))
-		err("UFFDIO_MOVE");
+	if (ioctl(gopts->uffd, UFFDIO_MOVE, &move)) {
+		uffd_test_fail("UFFDIO_MOVE failed: %s", strerror(errno));
+		goto out;
+	}
 
 	if (pagemap_get_entry(pagemap_fd, gopts->area_dst) & PM_UFFD_WP)
 		uffd_test_fail("uffd bit moved into an area registered for missing faults only");
_


