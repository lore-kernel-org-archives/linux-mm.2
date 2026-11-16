Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADDA6606A31C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 05:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=c78odPp8
Received: by kanga.kvack.org (Postfix)
	id AAD6F6B00EF; Mon, 16 Nov 2026 00:58:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5E496B05B0; Mon, 16 Nov 2026 00:58:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 973A06B05B1; Mon, 16 Nov 2026 00:58:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 747BD6B00EF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 00:58:00 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0760A16089C
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 05:58:00 +0000 (UTC)
X-FDA: 85439926320.28.AA99426
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3182E40006
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 05:57:58 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=c78odPp8;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794808678;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bxSArsxaCkviuzkJwRXAaqradlVMZJysA2PPJZZMFoU=;
	b=C0iO1oGX/IbjAiHkG2p4IjHvuS+kHp4KOmmFl05kY5/uK2aMLM0AfcCSeAwGEqIF+UyqUv
	kZCNeq9LvpfSm9NtGTb8EIPymUNDNAGb82BiA/zOAnyQba1Mq5wWzaFSQdBwqbUE3BbttO
	7aIMwhMx1M1XQzq/el9fEe3AdFjaXDs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794808678;
	b=yvfgzMQaEEYvuNGM+tPkLSl8774alIE2uwQfPhaG9RGAwJIWg1wmbpiq/y1Archv2/hXZw
	z9H6UXPFO93pP2WOqKKnYYU+YX6DmhLeE78zYMCzFlZkAFSIMEtdur8/K+DXE8Q+obN16h
	morqO3fmLNaK6/mNKgTnB1LDaYVwU0Y=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=c78odPp8;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1B8344055C;
	Mon, 16 Nov 2026 05:57:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4D531F000C4;
	Mon, 16 Nov 2026 05:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794808677;
	bh=bxSArsxaCkviuzkJwRXAaqradlVMZJysA2PPJZZMFoU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=c78odPp8OJft1v91gLdhRaAMxTlGLixH+0rokNUgBdtZ2JsYkZdgy6zWS84DUY4Lt
	 zV3T5byWolVfUj8r/gfr4x4hvaY+ABQlY0Z9I3znscYfDE72a6DSXRQE2ylHk4jnlR
	 NL6GBkm63tQ//yo+x+/TrniHsmhYwWdkNg0BC8cw=
Date: Sun, 15 Nov 2026 21:57:56 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dan Carpenter <error27@gmail.com>
Cc: oe-kbuild@lists.linux.dev, Phillip Lougher <phillip@squashfs.org.uk>,
 lkp@intel.com, oe-kbuild-all@lists.linux.dev, David Hildenbrand
 <david@kernel.org>, Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: Re: [akpm-mm:mm-nonmm-unstable 139/151] fs/squashfs/namei.c:283
 squashfs_lookup() warn: passing zero to 'ERR_PTR'
Message-Id: <20261115215756.839150412f8e2ce4bab5105c@linux-foundation.org>
In-Reply-To: <202611131955.0Gd7ipSP-lkp@intel.com>
References: <202611131955.0Gd7ipSP-lkp@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3182E40006
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: qe3ig6etscs3rdz967c45usg8w4a4qk5
X-Rspam-User: 
X-HE-Tag: 1794808678-100870
X-HE-Meta: U2FsdGVkX19KCPi0YloH7d93dc27w/QJcEq2MqzUNpvwHn5hYGgQbTzK1G10CGD8tW4V2TwyeYSIGGoXNsvrvPuEGD6O3VP5eOWHBd0IlWcnCsL7ttEvXvttrds69bMXX3NXObN81ybro8O+u5NllcpZETBvDtLMdr2218u4kndpPZQvsON+PsXtAcGGwVpW23Uhsap7Nd7OrC6Xcj5C1yGuSwP0s0Sh3cOG83joL6QMthZoPPjxDqT1AIwf7bsx9qG1ziFnsfCPItE1UJKvnMow57uZwordMRqEgG2sbR1ewgSbz8n3gQiM6vkctv7c7qv+SWerOF/kBXDPY19ejgWiZY0Opl5J1bTN1OiidIFesGRZiLw7LI6Q0IfjKhT69s25cQXrfb8//vBX0TEDnjmZCBeCf4pZxiOZCctU9D24nQRg5cgU/CAYm2Qjt7EuFnTcDfCHsT0Bl21M3GOdhNzg1jlYO7LypwmURieKK1fna3198nQ1gZS3aLwM1SRjAcqndVGI3SGjOZaCXidTT6Zv3zt0kuIokKo6olSd+F/2sni8DAM0EyaNUK9+djrP9dji+ks23YgYaTWrYBuoUifNBlFIIpzvQ4IIZ65lKNZS57SIL60HgCJf04a8kq0EECtlIQ+obmVoiJ4Xj+Ff+3xBvzJXxdhqD/0bQ7XoQ4YkaRycW/0oDYwweRLMUIswESeQgXb7XZ4yltvdkFHmJRoR1mvq5MZdsImxuT2sVrJp5odU42H3mqXc/EkPathD0/L/nqOgNcmAJ8dnR6V7PVWAxKK5NL5iFFEvMeGQNynzxY50vdUhP7KH2ILjeZBF3pm1hcc2VxAuwfOEH6cARRjwkzsj5I6T46iEcenAiz9vFjrTrmfP1i3HgeQXKjGGc+ME+6p15A/xtBDA05IyhNBI1arOsBIQ6oHoNVrttjrV6pm1YKiiRtquBke/aQNr8Ow3NP0YoXlYDWM6Tv8
 7sutjaZU
 kBTGEXN6pQ+bAO5ItVlCJfv9vZVutjXOGsbOYCwR02u1JsaXCpjxt+H6t1E/A0VFTsdXLMD46/4xn74b1YPuhSm8+CD9P0uQAenWuRj1fU3OAfSqdTfasMZ66wNJ/lD1EFK/iaZKm/bO70i4pvvHRc1ljWiTtsTgmsSIYmHD7LLFHkMUXj+4xOCG+/PNcD8GCEPrtXfWplS+G0mQcjLCUeax8wxbt+/fy/4K19Ut7WF9aHQTaSWzAIBjc8kPTa2Ev6snGRELRrUbzG+Yk1xPvRy23uJF9gv3cN/lSkXmLUcQMcHYkfjd9PSphDKNPZIIuervy73Uqrj0GHnWUaSH8qCvmyc/qddnw/MoI6dEDtgzydhCyINNPFIzR4nVy5ECsXMyFH2EIa+Y3ulP+1O1Fm4tx9alNSGRAV/Xny23GzKvi5Hb5k2arUzFHBoWHCSJ0wTRk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 16 Nov 2026 08:26:18 +0300 Dan Carpenter <error27@gmail.com> wrote:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
> head:   152f0559e66c079f717de375f133ff127afb1f58
> commit: 5213b0a08263b2191b86b046c3a63f11e8abc399 [139/151] Squashfs: fix variables in directory code and add more sanity checks
> config: um-randconfig-2200-20261113 (https://download.01.org/0day-ci/archive/20261113/202611131955.0Gd7ipSP-lkp@intel.com/config)
> compiler: clang version 24.0.0git (https://github.com/llvm/llvm-project 8621950157210c1fa68f20f0614cb51310ec9dff)
> smatch: v0.5.0-9187-g5189e3fb
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Reported-by: Dan Carpenter <error27@gmail.com>
> | Closes: https://lore.kernel.org/r/202611131955.0Gd7ipSP-lkp@intel.com/
> 
> New smatch warnings:
> fs/squashfs/namei.c:283 squashfs_lookup() warn: passing zero to 'ERR_PTR'

OK.

> 5213b0a08263b21 Phillip Lougher 2026-11-11  224  			if (!squashfs_dir_space(dir, length, sizeof(*dire)))
> 5213b0a08263b21 Phillip Lougher 2026-11-11  225  				goto read_failure;
> 
> We need an error code on this path.
> 

How's this?

--- a/fs/squashfs/namei.c~squashfs-fix-variables-in-directory-code-and-add-more-sanity-checks-fix
+++ a/fs/squashfs/namei.c
@@ -221,8 +221,10 @@ static struct dentry *squashfs_lookup(st
 			/*
 			 * Read directory entry.
 			 */
-			if (!squashfs_dir_space(dir, length, sizeof(*dire)))
+			if (!squashfs_dir_space(dir, length, sizeof(*dire))) {
+				err = -ENOSPC;
 				goto read_failure;
+			}
 
 			err = squashfs_read_metadata(dir->i_sb, dire, &block,
 					&offset, sizeof(*dire));
_


