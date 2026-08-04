Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AB91C55184
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 18:43:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 174EF6B00D9; Tue,  4 Aug 2026 14:43:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14C616B00DC; Tue,  4 Aug 2026 14:43:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 089146B00DD; Tue,  4 Aug 2026 14:43:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C786D6B00D9
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 14:43:08 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E8FF8A170E
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 18:43:07 +0000 (UTC)
X-FDA: 85064459214.23.51A5CAC
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	by imf31.hostedemail.com (Postfix) with ESMTP id 1451E20010
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 18:43:05 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=CYKMU7J8;
	spf=pass (imf31.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.51 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785868986;
	b=S/9LXU+OkVHtjT3aLaiP4YHzLDhka/QYYXbJVk6smrBKZHZVxUCg0uzL90og/DCXNC0w2t
	UJXMfW4u5vNongFwJrBJ0zWUif8/M5FGVkUdS69W5F4/mLexEgCqfZTVPZzrztlyDz4LNk
	EU3cwfSULvFZ2Hix/L867+U+AnHG8wA=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=CYKMU7J8;
	spf=pass (imf31.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.51 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785868986;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FdjiYMrOe4oyIn7wBQJUa3e8e6H1YyqfJPN5wr7l4Qg=;
	b=Cix5mRwztIW+6zfrKKpbAelpkbEYNi7YRvIAIAc3GLewQaazNZPxZDQzxTVlfoS2Od0MTQ
	rNt6vInh2KVBMZoRMRemutEyhrosGM+qU4oJQ8/qW3qMsE76KoAMrgfW70ekzD6XnaGuY5
	52owiMGhvOSp/zct0VLh9aJiEdl0aAA=
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-8f256eaedf8so1329286d6.2
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 11:43:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1785868985; x=1786473785; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FdjiYMrOe4oyIn7wBQJUa3e8e6H1YyqfJPN5wr7l4Qg=;
        b=CYKMU7J85oPR/VnepNyHzrwuS/myN3DCT2OQF0biWf8p/T3Pkv7Vk4kZmr4oWvree4
         whmP69IIq7HFDc/RQta3Kjo8mAAKMcWByIpiYzVRWylwfRlPsGxp/1kqZb69jx1M2vtk
         zRif7riPWH4i0fsHFCJr0Zo7j98e5VPx/DPzMeuwBER/BbR5ihOv2lxPdXlUV1q4HkEC
         gaAuJCk1s5F8ejn+B38XIg8RZe9+LNv0GIoyh0UKKzG4iVWh1duEn7jQe3ykEHetekcz
         TN/+dkBgoO6g/kxrL6bBN9WWhcN9v4tfi5H+0maD7VyTUagMDBqJzD2VzfIpGm7/aN8Q
         zMOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785868985; x=1786473785;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FdjiYMrOe4oyIn7wBQJUa3e8e6H1YyqfJPN5wr7l4Qg=;
        b=JdAP6p3nPXBW1tfeTSbZngJ7HJ1pJxZYm9ZAbHGXX6rJcZbPtGEjezmzSUVtQyOy3A
         rbpY4BhKyrs/qw7Am+4fp+PwMvo/V+xLSxK2XfBUaEVz2lyJoQ1hxgWz8hdkbf5RMKR/
         tdkw+H7l6WC0fVl5MKhUVC3IOwS8yaZG+n/KEEHOLyzJ6Q8CNcet4iME/6DASopt5nOz
         iKqAfzYGkEkPkwWae9TxwLOOCTgfLA9BT89CcUidezk0We/d7VNBSLUT1EhALXbv3ugg
         Acx6tCe2Bm1LZRJpYfl4q4DJ1rk3V27iww9u1RySPvMMzfrNFAR4fxgXioX8EyLePNmG
         mpqQ==
X-Forwarded-Encrypted: i=1; AHgh+RqWLk10GGTeSKo3HstKVhFiyLuoMN1OnCSIXEwWY57/eoKH1ptCfsS7EUo/L9yMC88QqqZ3qsGPFA==@kvack.org
X-Gm-Message-State: AOJu0Yw0+tlgp2Q4GrefLY0R+EsP9IKvfVHLLIHJsORerAeIdkLm/fAy
	+kAT4jIXYE545gPxXhrK7ih4N5I7ATmoYr77FfCkS3S8jS2ThGs4bsbU7N5dJtt+zP0=
X-Gm-Gg: AR+sD10y0J+nRIwC4BsaHEAuXC/0nruqmGxMJWqQjotw1AKLOk5DZVtRWo6Hc/OLDUS
	3VGygziqgeA98D6nqH0s/LWGvS9K3f6RLyYYTZSaLg0IcjpSfMNmhpgUOegwjmGvxe1qaLEaQ19
	UGP5IvdTQRMU+cR2dh4dHicVGHTpXOpSe2ZnMYKDA+TZE4soUuYRuRF7M0aZLduy/46Uv30QTxS
	Qx4upcDSkYPr7TnKzy3V5WQKTs7dWzvgGhC/DsLoBiqetBDmZMBrEKyh22UNAe1fZae136DCEKc
	ArA40l5o94JNarMPl+a/m4YG3NGAXn886u+n/iTEZPFRuaPAuQcMpbPbkH4FebjqbSX47CItpeo
	/MkVImyHDSxXooUw35kXEHa6oCRzlrqf2DoIlA0oTmvEZtKMCCcpQdP0+oV/LQn9DUN4/qKbfhX
	mZ0zfqIWJ+swS5xk2cony8iyBkzqwQPdulj6Eo7bvlcYv05qSitb1CYGUaFbX5LYKNygxQt/+y7
	eXY+f0s+Yee3ankEMxfBVPFKO+9iqKzDflP+tB1ltzF
X-Received: by 2002:ad4:5c45:0:b0:8ef:867c:b8be with SMTP id 6a1803df08f44-9088109301dmr17916816d6.8.1785868984851;
        Tue, 04 Aug 2026 11:43:04 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9087ffe09f0sm7914906d6.22.2026.08.04.11.43.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 11:43:04 -0700 (PDT)
Date: Tue, 4 Aug 2026 14:43:02 -0400
From: Gregory Price <gourry@gourry.net>
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Jane Chu <jane.chu@oracle.com>, linux-mm@kvack.org, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, 
	Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	Christian Brauner <christian@brauner.io>, Jiaqi Yan <jiaqiyan@google.com>
Subject: Re: [PATCH v8 08/15] hugetlb: Use the has_hwpoisoned flag
Message-ID: <anIyVIUzIpsVDtro@gourry-fedora-PF4VCD3F>
References: <20260731200802.574821-1-willy@infradead.org>
 <20260731200802.574821-9-willy@infradead.org>
 <anISVv340bo1l9as@gourry-fedora-PF4VCD3F>
 <anIWdALS_1pmGA-t@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anIWdALS_1pmGA-t@casper.infradead.org>
X-Rspamd-Queue-Id: 1451E20010
X-Stat-Signature: s5ape759sjp5x7pccyfw4dywpgeg11dg
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1785868985-187787
X-HE-Meta: U2FsdGVkX1/017Qtpi+ZiyXXs6C0RyrfrMzP3jLIoIpFDHjdfqc6JvTvQSPvIjuO1UX+PyQVIfe/+6yhmRoRdyDovshbEQjwBbX61kYAkXdePLjcQvOogzHfC+RsvWfK4DSF4+N1xTtyoXiC24OUQjinwoondVjKLnNJp0hyyBzVpN7SbNXDwqW8JQEAatj9OeTPXQFLKBjRuJ0d2oOT1qk/WLzzL/Q9/6mucYGUlvd/uPXJNRXpbaLUg8GIDkZ7Z+6MIqW5yXij0XXdkd1Macv7lTjFfjmcpYfI3HNqqv3YlR0u/iS2Hk4N9FlSJz+bPvy/rEEOxtcE1wbfTPywDoUJd/24KPNj1C8UyNnJWzMkxuzPwwzWPTYRVHFAqzvgf90nZSCpn0hhTmXomfe2KzlI0n/OyZ6UPRW96aL0Z4i5EEL2n/gPM46qSuUfKUTpiAMph+D8ayrpxsGCQBDBjot9oUGvSoyzeBtPTKbUugxNPZX6ReLT+2YotrQVcSotuWjHe5pXOaXCanO1VbGPMiEobZARswHw1qa9d0sNOv3mW1sHFn5NDaYYEzdNBS0PbBf6MSv/Tb/rRwvvMV6X+ITKEzQmkDKf/v3vanfAUyOEh1V71J5x90IGFO783D7kPfuXoK3sXd1PUkpN2EXNDeLa44CRJzgMjxSSkjby6v4QKais6afJuHxkBxJQt1Dbb2TB+7dl5w9y5Y8bGwSH5TAw3+H7qZURIDRx8HO5Hjta7RI7Ttt1pOTyukk7x0XWaQ9zRCsb5yLRfDUs85i46JhwpUzZX5G8Yw02YYaUvAb7J2WuUk3SB5ZCknB6C7eAXoiPWuW+14+xySPBRBvPXFnG7B/sbq+kAEpLB+zILOCW0pmmoFfbLEye5LBOeBMGtLxxaRTREce62Amjls1IXCQnRrm8/EY71YEySIZPkYAdsOrmF94wVm/Itiw8vcdBOlBvdXhuIlo/6jS/ueF
 RkyNYRDW
 IL/jw8oC2pNjw+1C8Z3M3xSfYG8WcbU4NcvHxCm9U+LtJl3EnNgHfpNOCMZGdI6MLqKglBDSXYG65u2Cu+xxdI/xVwVtc7PjyCSX535Ur8+Etun9HzCADBo1+QBj8wgTTSkToTFMUa6jvBWdnZotumr8AUaGujk6SFzxIm7phEESCGyWpQo2vQIuth1hvDWzCkz58Q7gYSfYU4kPHXMPW8gFqX2WFAzQpFilOWzfmPiT/j1EkuJKFR6bRwPIYaTV2GRQb2CPryNGYqYllMFw7WNO1/OVnyOoMTCuOGR5D4oWO+s0hXPqCjd65Z/xU1BmlM18XVMFyJcPSmMIZtTB57arEnZpSL2rkwA1/kLtD3FiCOdr/6V4G3sAQFVhUSEnnHXLJxo0v34zpvJBSRT5McOwwcEfOsgx74PL4IVx9vWG2W5JBvTRv2Fxm6xwHrMvzco8JoV7vkdGEgtLzG47pnJb6w+QyhxK9Ek1+jgztky4f8J5g0MMiGGaq3PDVFEPORFQU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 04, 2026 at 05:42:28PM +0100, Matthew Wilcox wrote:
> On Tue, Aug 04, 2026 at 12:28:06PM -0400, Gregory Price wrote:
> > Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
> 
> Thanks, will add.
> 
> > > -#if defined(CONFIG_MEMORY_FAILURE) && defined(CONFIG_TRANSPARENT_HUGEPAGE)
> > > +#if defined(CONFIG_MEMORY_FAILURE) && defined(CONFIG_LARGE_FOLIO)
> > >  /*
> > > - * PageHasHWPoisoned indicates that at least one subpage is hwpoisoned in the
> > > - * compound page.
> > > + * folio_has_hwpoisoned indicates that at least one page is hwpoisoned in the
> > > + * folio.  That page will usually also have the HWPoison flag set, but this
> > > + * is not possible for folios which have HVO (see memory-failure for the
> > > + * scheme used in that case).  You probably don't want to call this directly;
> > > + * use folio_has_hwpoisoned_page() instead.
> > >   *
> > >   * This flag is set by hwpoison handler.  Cleared by THP split or free page.
> > >   */
> > 
> > Had to google HVO, and didn't see HVO directly mentioned in
> > memory-failure.  Maybe worth expanding HVO to its actual definition and
> > a sentence on the quirk.
> 
> It is mentioned earlier in the same file:
> 
> include/linux/page-flags.h:      * Limit mask usage to HugeTLB vmemmap optimization (HVO) where it
>
> but that's not obvious when reading a patch.  I'll just expand it here:
> 
>  * The has_hwpoisoned flag indicates that at least one page is hwpoisoned
>  * in the folio.  That page will usually also have the HWPoison flag
>  * set, but this is not possible for folios which have HugeTLB vmemmap
>  * optimization (see hugetlb_update_hwpoison() for the scheme used
>  * in that case).  You probably don't want to call this directly; use
>  * folio_has_hwpoisoned_page() instead.
> 
> > Does "Hugepage Vmapmem Optimization" just report poison for the head and
> > we lose the sub-page poison information in general?
> 
> We only lose the sub-folio poison information if kmalloc fails in
> hugetlb_update_hwpoison().  In the happy case, we retain knowledge
> of which pages contain hwpoison (and later in this series, we actually
> expose that information instead of just pretending the whole folio is
> poisoned)
> 

Gotcha, thank you for the additional context.

~Gregory

