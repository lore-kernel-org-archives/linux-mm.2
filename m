Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F24EC44539
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 10:09:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84CEF6B0093; Wed, 22 Jul 2026 06:09:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FDD86B0095; Wed, 22 Jul 2026 06:09:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6ECC36B0096; Wed, 22 Jul 2026 06:09:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3C3406B0093
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 06:09:35 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BEC1440413
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 10:09:34 +0000 (UTC)
X-FDA: 85015990668.13.B7A8019
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf07.hostedemail.com (Postfix) with ESMTP id E4BF940009
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 10:09:32 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oRglCF05;
	spf=pass (imf07.hostedemail.com: domain of nico.pache@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=nico.pache@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784714973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rYhVqJgz/LSkLNjg/Okwb0MxG/fMCnKIAMDpcHmPYIM=;
	b=RW7Gwe2AHC1rMfrGufeqqJ9RnMuTkGNMVwOby85UTjREm1xt75N+RzDr2O8/udfJKZbs0+
	54MFNQuk7l8QFTlgkmu7DkRTR+AWpAQp3Yr0EetdSQnHIeyeMfK697Yx6yC6XExQ/L/wiG
	T9A6/9dmQn+Nf47PH5t2wkASO5v+ods=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oRglCF05;
	spf=pass (imf07.hostedemail.com: domain of nico.pache@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=nico.pache@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784714973;
	b=hBmjheZ71BTIWyG/kgtXHKPhOo2/a/1VOp1MuX87jexcTdkryq3UE2tTixqQRSyIbO7EXo
	38kCTmFOIA25M3DgrrcA1e9kGp+8/TxNw71QfmOo8+1RdP/JoCs6UPG1yizooPwNXYsBhH
	LQB3CwWs69bNCxH/OJst5F39swGGwxk=
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784714971;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rYhVqJgz/LSkLNjg/Okwb0MxG/fMCnKIAMDpcHmPYIM=;
	b=oRglCF05M6wI/1+Yp6A+568U6ThBaa+IA9tr/TF3OV45pVmk7VWeAVudvpaUoorBb3v96C
	8Ns/FhcTe/zpwnUjcckJclGq8PZkbu7AKv1sEvUPvnSrhDGhQhvQfo7wwo7PYa+hsUsz08
	eoBxAkG0yk1Txtkds/mh5xWJFJrhOi4=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 7/8] mm/khugepaged: hoist more code into
 collapse_isolate_folio()
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Nico Pache (Red Hat)" <nico.pache@linux.dev>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20260720142913.846902-8-pfalcato@suse.de>
References: <20260720142913.846902-1-pfalcato@suse.de>
 <20260720142913.846902-8-pfalcato@suse.de>
Date: Wed, 22 Jul 2026 04:10:38 -0600
Message-Id: <178471503895.281396.9667058491911094115.b4-review@b4>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E4BF940009
X-Stat-Signature: 9jds9ig7g31yedz7ep7jbmw1oksy6gff
X-HE-Tag: 1784714972-807512
X-HE-Meta: U2FsdGVkX1/1jEtnxeAbTbvhCIKKkPRTk2e1YH6AOxTM67A+dAjIjmFVkqB7LyJEx1tsEgCpAAlzIwrz38d+lMKMgAWHXs91/et9GH+HXviid/1ATEl8SlAwnuRLame/aVjStjEhfGRmpkqFI7ocqnNfsnIb2T5gFg0+J0eVfXnVdaXEiq5bk+oGWSZ5300lZ9WEvA/zwKJ2LmlWqZBGybhvfEUL6F1lDIFNMmz7C2YkJs6j4MaYLyPdSH3BZL4PUiK+7viIXf6xZkSTcn0yfJnHsL3/Oaj24jLvZVTJcOdP/CIi7QVZh6Qs79BbjZMY1TJMabUySmrjhoigv6Ow9KAVeHuWRU9VDx2HI95apW93QURk1jwyDLByQlZv6mkndxlgS6fbask7ab/6GXlXH0jdIwmaDplRNXSNK6/rb9R+MIfnqAGTzlVlEidVobUI6rLuagD/YdtW72qqPBjRThaEGJZJtqqn5kYGq68+NDN0CyVD1s+McTCg2p8kDKSmE0OcfADVC4/pbWuFhECxTuz6Tk0TJ1i8vBrEJjqJDIMazAAwrOR52BW3wRsuQW8r8hF16dyN8/AfU3UD69ozrJdtYzb5/0yTsXJecJ9zDzTmTNp7Q7hbInF9Zjmi0pFW8viDnuYGh7Qbnz0DJX4IS/3L8FrUvtwCdb7C2qPPgI/fPJWi04xotKoK3kWcvkM+pwMQbqCzSw/leFlBlmWMp8KF2C98rspfEiMT8qV7PczWqpmWrkNdFkhYY8EeBK03MM1qXWxpbcEzvR1C4j2lTc8iF8mUMYYZRv866t14uuT12Z+gcobQOu3OebZV6oy+WryQunfQNgOn+DUjpk6EuIOdisirRBSF9SHpF9DhxeNmTxWIap9jEBkyElGk8yzbf6g+H+ZiSiFXO6+/wBFNfCorxZnhZWWlbYE19Dc0+FbZBL11KUPnYufGjhxHDXpr5BeieZdmapkdYaeh4zv
 piqFH1T2
 CUOFmga0/I7VfZFrplso/YQHogG/WHWTeGT4oBf4hUdNdSKbtHcKwo3hksaRozUlks0tU5Ov7ab/71Q7IbVFvltSpro8sJxVIGacvtapIF5s5a+6lDMb9yhnT4gvyZi6uyCqPGXcMUFD7r8mZexWsTETHIMHSzuk/yNtifwwDE80tkrq9QiP8iprOECh94xFkiTs40nZ9jjdqnudHwe5AkQu5Ye4uuxTzcHbwsRt7m3k3tzuQAUM01sAp+qy7oRD3GC0r
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Checking expected refcounts or dirtyness has no need for the i_pages
> xarray lock.
> 
> Signed-off-by: Pedro Falcato <pfalcato@suse.de>
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 429e2c5833d0..a09e4e4e1943 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2382,13 +2382,48 @@ static enum scan_result collapse_isolate_folio(struct collapse_file_state *state
>  
>  	if (!filemap_release_folio(folio, GFP_KERNEL)) {
>  		result = SCAN_PAGE_HAS_PRIVATE;
> -		folio_putback_lru(folio);
> -		goto out_unlock;
> +		goto out_putback;
>  	}
>  
>  	if (folio_mapped(folio))
>  		try_to_unmap(folio, TTU_IGNORE_MLOCK | TTU_BATCH_FLUSH);
> +	/*
> +	 * We control 2 + nr_pages references to the folio:
> +	 *  - we hold a pin on it;
> +	 *  - nr_pages reference from page cache;
> +	 *  - one from lru_isolate_folio;
> +	 * If those are the only references, then any new usage
> +	 * of the folio will have to fetch it from the page
> +	 * cache. That requires locking the folio to handle
> +	 * truncate, so any new usage will be blocked until we
> +	 * unlock folio after collapse/during rollback.
> +	 */
> +	if (folio_ref_count(folio) != 2 + folio_nr_pages(folio)) {
> +		result = SCAN_PAGE_COUNT;
> +		goto out_putback;
> +	}
> +
> +	/*
> +	 * At this point, the folio is locked and unmapped. If the PTE
> +	 * was dirty, try_to_unmap() has transferred the dirty bit to
> +	 * the folio and we must not collapse it into a clean
> +	 * file-backed folio.
> +	 *
> +	 * If the folio is clean here, no one can write it until we
> +	 * drop the folio lock. A write through a stale TLB entry came
> +	 * from a clean PTE and must fault because the PTE has been
> +	 * cleared; the fault path has to take the folio lock before
> +	 * installing a writable mapping. Buffered write paths also
> +	 * have to take the folio lock before modifying file contents
> +	 * without a mapping, typically via write_begin_get_folio().
> +	 */
> +	if (!state->is_shmem && folio_test_dirty(folio)) {
> +		result = SCAN_PAGE_DIRTY_OR_WRITEBACK;
> +		goto out_putback;
> +	}
>  	return SCAN_SUCCEED;
> +out_putback:
> +	folio_putback_lru(folio);
>  out_unlock:
>  	folio_unlock(folio);
>  	folio_put(folio);
> @@ -2513,55 +2548,11 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>  		xas_lock_irq(&xas);
>  		VM_BUG_ON_FOLIO(folio != xa_load(xas.xa, index), folio);
>  
> -		/*
> -		 * We control 2 + nr_pages references to the folio:
> -		 *  - we hold a pin on it;
> -		 *  - nr_pages reference from page cache;
> -		 *  - one from lru_isolate_folio;
> -		 * If those are the only references, then any new usage
> -		 * of the folio will have to fetch it from the page
> -		 * cache. That requires locking the folio to handle
> -		 * truncate, so any new usage will be blocked until we
> -		 * unlock folio after collapse/during rollback.
> -		 */
> -		if (folio_ref_count(folio) != 2 + folio_nr_pages(folio)) {
> -			result = SCAN_PAGE_COUNT;
> -			xas_unlock_irq(&xas);
> -			folio_putback_lru(folio);
> -			goto out_unlock;
> -		}
> -
> -		/*
> -		 * At this point, the folio is locked and unmapped. If the PTE
> -		 * was dirty, try_to_unmap() has transferred the dirty bit to
> -		 * the folio and we must not collapse it into a clean
> -		 * file-backed folio.
> -		 *
> -		 * If the folio is clean here, no one can write it until we
> -		 * drop the folio lock. A write through a stale TLB entry came
> -		 * from a clean PTE and must fault because the PTE has been
> -		 * cleared; the fault path has to take the folio lock before
> -		 * installing a writable mapping. Buffered write paths also
> -		 * have to take the folio lock before modifying file contents
> -		 * without a mapping, typically via write_begin_get_folio().
> -		 */
> -		if (!is_shmem && folio_test_dirty(folio)) {
> -			result = SCAN_PAGE_DIRTY_OR_WRITEBACK;
> -			xas_unlock_irq(&xas);
> -			folio_putback_lru(folio);
> -			goto out_unlock;
> -		}
> -
>  		/*
>  		 * Accumulate the folios that are being collapsed.
>  		 */
>  		list_add_tail(&folio->lru, &pagelist);
>  		index += folio_nr_pages(folio);

This can/should also be hoisted up if you follow my recommended code flow.
This requires also passing pagelist (and index, as lorenzo already suggested) 
into the helper struct but thats fine.

> -		continue;
> -out_unlock:
> -		folio_unlock(folio);
> -		folio_put(folio);
> -		goto xa_unlocked;
>  	}
>  
>  xa_locked:

my recommendations also allow you to group all these gotos into the bottom of
the prepare stage which drastically cleanups the amount of gotos in the
collapse_file() function. 

with my code recommendations the loop becomes.

for (index = start; index < end;) {
...
-out_unlock:
-               folio_unlock(folio);
-               folio_put(folio);
-               goto xa_unlocked;
+               result = collapse_file_check_folio(folio, mapping, &xas,
+                                                  file, &index, start,
+                                                  end, is_shmem, &nr_none,
+                                                  &pagelist);
+               if (result != SCAN_SUCCEED)
+                       break;
        }
 
-xa_locked:
-       xas_unlock_irq(&xas);
-xa_unlocked:
+       if (result == SCAN_SUCCEED)
+               xas_unlock_irq(&xas);

        /*
         * If collapse is successful, flush must be done now before copying.
         * If collapse is unsuccessful, does flush actually need to be done?
         * Do it anyway, to clear the state.
         */
        try_to_unmap_flush();

        if (result == SCAN_SUCCEED && nr_none &&
            !shmem_charge(mapping->host, nr_none))
                result = SCAN_FAIL;
        if (result != SCAN_SUCCEED) {
                nr_none = 0;
                goto rollback;
        }

	//Copy stage

Now we have no weird goto labels in collapse_file and rely on results to
control the follow.

If you think my approach is already useable perhaps you can just take my
commit I pointed to you that does all the major code moving with no major
refactoring and add your further improvements on top.

let me know what you think!

Cheers,
-- Nico

-- 
Nico Pache (Red Hat) <nico.pache@linux.dev>

