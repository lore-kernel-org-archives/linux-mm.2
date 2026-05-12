Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95760CD4846
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 00:45:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA6466B0005; Mon, 11 May 2026 20:45:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B58016B0088; Mon, 11 May 2026 20:45:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6C826B008A; Mon, 11 May 2026 20:45:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 913526B0005
	for <linux-mm@kvack.org>; Mon, 11 May 2026 20:45:50 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D835FC175F
	for <linux-mm@kvack.org>; Tue, 12 May 2026 00:45:49 +0000 (UTC)
X-FDA: 84756925218.13.62EBACA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2991A40005
	for <linux-mm@kvack.org>; Tue, 12 May 2026 00:45:47 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J8fOvIZl;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778546748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r9/c+aGkl+XnIMUvawwWWyM5Ib2V/lac832o68B99hM=;
	b=qPkDrRFBMt7apepf6L/E2uZM/Pc7wj47a1rrGJYUUzeSjPsfHOFsbpPZwoe8s32C2J7iMA
	HGLfz6oGCjOE3vp1pDGqrVsaO9iBNnUMGYHp+wY/4Ns4sy9WLHXjEOvA4UYk0iySlqCqw4
	b42sQPnFaAmC/byPkhKlWXBWlfJ95wA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J8fOvIZl;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778546748; a=rsa-sha256;
	cv=none;
	b=nGSkulN1goKNFBfsxBtpWJRoKvfx7gBWndYRRCTotyECbPXRFQ/gB8a7fWqnNJCZmJvrMK
	4hJ0j+KXr3GIULABvLkMZKTi42redc050AlhgGTtB12KVs4h/sFVKpjG+Cuzm2JqveJ7yn
	eC8w/OsZy3oJeMPEAsoPAx94T+m9u+I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3D1A140378;
	Tue, 12 May 2026 00:45:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB6CAC2BCF5;
	Tue, 12 May 2026 00:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778546747;
	bh=l0rOYVdVwkAQa2ds+z/L0NfyKVSciLpCRPIyVzLiN+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J8fOvIZlT5vtfNXyCi83liTZNBbnECVYhGQO0pdwan7M5kkoDNF6vzpa2PmrMK6m1
	 t+Gb/qkpEfi7z56lBXQh2Ofo/K9Ozt4iNqJ/zzTW6BZan5CZ/DHfUJ09mGzPOB6Ert
	 CdFGjuSG7CgSXgRQhdvdNz/ooaWqJWNJtQlv3tLFqbzx5j+Gwiz0EmBGQpvllLNcOi
	 sJX+l4A8vLsN8x77YrEz5cxRAx75nvNTXLlgh7KhRF6cHQOvD0tXt7Lz3xxs1wI7wD
	 If+dtdVccBkuuqg5r+d0BkqJZm5GSMewlhprbW9eKYOlIx0UyymFlneLID4AeVyNll
	 DCiYNuF33cdHw==
From: SeongJae Park <sj@kernel.org>
To: Vineet Agarwal <agarwal.vineet2006@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] mm/damon/sysfs-schemes: fix double increment of nr_regions
Date: Mon, 11 May 2026 17:45:37 -0700
Message-ID: <20260512004538.1005-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260511191218.98881-1-agarwal.vineet2006@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3j5gg9rek3jb3tmmybpy3ikcy3xm4qza
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2991A40005
X-Rspam-User: 
X-HE-Tag: 1778546747-840166
X-HE-Meta: U2FsdGVkX1+d63pio4rFf/BroMoiJJEozXhSGTdo71TdG8GQa1YzKnKrMYc5/G0C3Wg17QzsrODuJL0RoayB8YumwISp6KUhOlxnFuG9NdytpeWEfFakZAQrpW9CA+IRMIXe1apSiWcWUKLGlc9EJs31nFGks4MTEEWyfc2/n6evP6J1PEvJDeFFRfet1nqoQ+KkEAqM+8C7g+iEJ2fnPkdx5ERwZWu0tGBqd7fFzuur9owNxKKpp7oQtNOqbMU50s1G2gO994TybQh3pkfN88ck7quWrPG5pPKdA5JQ0q3c74psyhvE3BdZhDGZFWpHrmY/MBarSBxLFPOoQmg4rD2+6qPzfkI8gbKLHNHACtSWdMC39nvhmrZkzxSW32QIOC8lCWyC0EVisz75zR7sLDAk9MORhQzKSsjFnOcdkBmtAYRkcK5zD3uPrXjLpiOGznZFguEF4b4dPqX90z1ae07K54PZwIVkzrWx5AG4fk3EOdY6YzdYK/ns/dMxX7rHLkN/1gYw6K81+WDlJf+6v+Hg6KSOAUZqqK95fpxVEtviLlha2tuCMWnL0KrH+L+wOwWz8ouN7G7IJFyMm8JhYb/pp2ftp4oE9z3s1WsiNh4yiqSovrYl7e7iNzkHxIfbuEIrW+Rl/eyK94kqxnUSEOsZi31qT3aaZO2IINRZJeVD698lmtbMr637+AcYBhwxiAC/OMdnRffqowEmYnIOlAbcahIERxp29QLI+PM7Rnxzf5CUoGY19WjtuFTmq0vUo+AAGCjmxEEqjyUCCv4hy+xfVB2A5Fj2fhggn9SSOVuS5F1uY7jTwCtpmdlF5zTX/lo6TAPoOUvOwTiurjl72XGV1HcaGKg4npVei4Oy7+PhMA9csKm25E3cBWiGmtcnXDCEvmH5l/UgI0Oc2zBcIuOTB6aH+FSJEn5oCVFY8ILD1CXT+lBRzhCwRA8H9RW1Y28XHqLJD8MPTtegd/J
 ZGGIxnVA
 YN4oLbekH+18AFBAmL21gL2JOKCIhXiyyF5bYaP/uQR5GsBh13LLNWgyQb9ujTwytmZES0PP3dKUERNjByAgJARD1sNVxZBuVooj5LQ+Xfw2fmTd6Ry7TuMes/YxuUwhHJr+/CnektvlZdrYLEsZWou3i5NjevNgh3yelpbF4ASr4+af21o8JDUEBJoPzl+fzNsAnZ0hvYmWQmKOWOuqI6tzAsfkLNUNNxc3PI1Ykrx3R9jt4yiaDfq4robFKEOeQEptVPdQTLFYheNd3/UByrinQq87zLC1UAnEnGtx9T9wshdueoNBtP0sAm+FyPkPbaFZYKquPjMusl+x93sQfKe0XrGu6aefp9lHG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 12 May 2026 00:42:15 +0530 Vineet Agarwal <agarwal.vineet2006@gmail.com> wrote:

> damos_sysfs_populate_region_dir() increments
> sysfs_regions->nr_regions twice when adding a new region:
> once explicitly before kobject_init_and_add(), and once
> again through the post-increment used for the kobject name.

Nice catch!

> 
> As a result, nr_regions no longer matches the actual
> number of live regions,

Nonetheless, this is not causing real issues.  The the nr_regions is not
exposed to the user space.  Similar data structures in the file use arrays for
managing sub-directories and use the number field as the size of the array.  If
that's the case for these region directory data, the code might allocating
more-than-needed memory or having some problems.  But luckily region
directories are managed using linked list.  I find no real problems here.

> and region directory names skip
> numbers (1, 3, 5, ...).

This is also not causing any real issue.  This could arguably make users
confused.  But still user space could work with this in a reasonable way, by
sorting the regions based on the index and/or the address of regions.  Actually
DAMON user-space tool is handling this.  That's why I didn't realize this issue
by myself.  We recommend human beings to use tools rather than directly
interacting with the sysfs interface.

The admin usage document is also not giving wrong assumptions about the names.
It only says the names will be integers starting from 0.  The real names start
from 1, but arguably that doesn't break something, becuase the document doesn't
say there will be directory of name '0'...?  

> 
> Use the already incremented value for naming instead of
> incrementing nr_regions a second time.

So, there is no real problems.  Please let me know if I'm missing something.

But it is also super clear that this is not an intended behavior but a bug.
That needs to be fixed unless it causes unnecessary overhead.  Meanwhile, this
fix is simple and nice.

So, nice finding and fix!  Thank you for sharing, Vineet!

> 
> Signed-off-by: Vineet Agarwal <agarwal.vineet2006@gmail.com>

Seems the current behavior has started since commit 66178e4ec30a
("mm/damon/sysfs: use damos_walk() for update_schemes_tried_{bytes,regions}").
I think it might deserve 'Fixes:' tag if someone claims, but Cc: stable@ may
not really needed because this is not causing any real user issue, as I
mentioned above.

So, this looks good to me.  Vineet, is there anything that you want to sort out
before dropping the RFC tag?  If not, please feel free to post this again
without the RFC tag.


Thanks,
SJ

[...]

