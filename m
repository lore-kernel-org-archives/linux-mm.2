Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A12E4606A321
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 09:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OdtnVYVc
Received: by kanga.kvack.org (Postfix)
	id C07666B05C9; Wed, 11 Nov 2026 04:34:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDECE6B05CA; Wed, 11 Nov 2026 04:34:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1C8D6B05CB; Wed, 11 Nov 2026 04:34:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 92BA76B05C9
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 04:34:54 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 332DD16022F
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:34:54 +0000 (UTC)
X-FDA: 85422328908.29.F415F7C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 996D91C0005
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:34:52 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OdtnVYVc;
	spf=pass (imf21.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794389692;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9oT8mJ+Ro9B5pT3ilEOpm07E7nXRbdqUWub1X6gjjq8=;
	b=XI6N/KAPzybs3TEdh6G/1BNXAqnqs742I6vsto6MVWoudoKzVWilUil/XufOYDt6+Xpxzt
	hF1DlOd3Lvh77XFOArGjOQ1L+uGB+07SULgi9cFqJs97XxBFTznt72EiQ6HS+YoXkhFmGY
	9ii+7XUH5phYiVzPMKTWowS4OT65/Yw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794389692;
	b=xrZrTRsgG5XVoQXULy8h/uZbqumQQ/u1GtMMImoE6DDG7Ms8pToxzTRSDJ7YnspIC2Lz3w
	2pAsXsQ1iDw17fWT+ZmSUkhBnfkvAr0YnACyCWp8+hZFlmc0ShpZu+YWBVHin6a8+Flbdq
	yCftafILOqdSODW3vywG8/+m8BAavaE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OdtnVYVc;
	spf=pass (imf21.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DC8E3433D1;
	Wed, 11 Nov 2026 09:34:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90CCD1F00A05;
	Wed, 11 Nov 2026 09:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794389691;
	bh=9oT8mJ+Ro9B5pT3ilEOpm07E7nXRbdqUWub1X6gjjq8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OdtnVYVcsG19f5hTkpS9kaTbzYuiT4HMccwgMwUjVwnIpesQBW34vpb3Soyr4kOrP
	 hOWU9u/FdRtMey9V9HCAE456IT8ckxwm57A+Ly6VYYZWBpzFU181QmxIL4ZKaQBkuv
	 R4IW4Vu3xTtqaWY7OChZuL0TLDuaiwTiXF6Sh1i/iIOBQY4YZqWcOBld9mgeDtepGg
	 xhpH4Hal/ORXF7Ws8rDRjza2UZ1LZnHqJFb3QJhbDQIkq2cHWiFFEkTUDv9nHA3f8I
	 KC2GcTd5PWGGo5PuIK0Rr7OdS0N/e91AdadUEU857idCihrAQD4FlV8x8zGu2F2D2e
	 mjn9fyjTG/YWQ==
Date: Wed, 11 Nov 2026 10:34:46 +0100
From: Christian Brauner <brauner@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: Jan Kara <jack@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, 
	linux-ext4@vger.kernel.org, linux-mm@kvack.org, linux-efi@vger.kernel.org, 
	linux-mtd@lists.infradead.org, dsterba@suse.cz, tytso@mit.edu, Mark Fasheh <mark@fasheh.com>, 
	Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: Re: [PATCH v2 17/34] ntfs: don't set SB_RDONLY after filesystem
 errors
Message-ID: <20261111-weinreben-einlieferung-sequenz-e817949ea18c@brauner>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-17-2f44f64f0b66@kernel.org>
 <sashiko-outbox-191236@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <sashiko-outbox-191236@kernel.org>
X-Rspamd-Server: rspam06
X-Stat-Signature: 5s3zqkw1knb9njn7rhy9bptuwi1admdp
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 996D91C0005
X-Rspam-User: 
X-HE-Tag: 1794389692-507542
X-HE-Meta: U2FsdGVkX1+7Rhv/jKXu7goIPYQVBgzB+aQG9gnKp/Nc1/dfWtxehuDGQXEDgoCIq5hgG/YgzwQGRCC6ntvjzZY4EWYVcvNwjRNEDWlX5dqdvWBJZqswRAcIU80n8ZeTXTlCVH3KW0BPFo2ET4CJ8DNwbX/w1ZAGkluihtcVJZeqkQbGBr+iQjSRv5T6JPxMltwrWcM/a+JcrVjRSSwLhRJhbvX0j0s+Ds3dC/pg9I8okYtR/axcBwuFUTwl1eQhhaFcQz2Aaxsb+AsTIeQEJOVGbTh2ZiJMU/XNNhaMWCt9sbOhQDSmSSCiGoHS0CqnAzqljNlhuxafa0uy82zN6aSC/R3pLtfmfjl1MtdeE5b+8iGxREepbiRuJVfd/vQSlbXjdh8te6GncGmNl78Aq9mtaZhgK9cwHLUrcFe+KeadJawCZJ+UpigBJPD3NUncYY+IyoKL0kwGakMZ7yqrTYOW7DmEe5cIUWmMkV6vUbgii7ADDHrhsHgNWyTI+eydmj7xHmdE+oGcUdOcvX3UXHsEumXIuHC3LT8onziVWGf55BcwQYVFcu9VDqkxs2H9TIYVI1NcUUeGJZw/sh5Ty/eGCx3mwPFFeAWzEjJ5wPPKp8RwKCDdkw3u8zutRtUj7gVDxeJ5AE39qxNp6o4m5nprcQ1Q23x9uyUhzfd5E7flZI4hso67W135grNEMCKzKW03vRuAYWkjYB7bClKpPaRQ/XwkoFxY2D9bPHXy+EqwpVFActrA9Pk1JGaURxuG4maFtRZnPSzjtEkITor8MFfCDSav2y6p9r3FuEI4sdYFar60YTfxzTD0GuRFhfBoPxAlpcS7Tw+g/ZvjwZ/Mi4kOpDeYK7mrRUvn+boWPDnS0VU/w85Ly1/K536s5NDhSBGDUhdRyoOtOp/yeLAil7RNm9cmuS/TrFuSSbXWujWD7IsfeNnt7DYU5ZM7vBh1wl1oDczxmQYTFKTvWn1
 qFierFXY
 WCW0VA6Sq7OO6axK6CWl5WUrjwCQCTIVyRPlM0tmf2+2Ul6cGdVRHCkTI+S606gbG47MGFDfWixa5DZ/F2mrc/kz29VkPoyp2YtW3am2AAABE7jjrfBXbdJEVHRzB0ZbQvURD+9S7g9TP2uAo7VW32o7sJHqiW2qChegL+kzUfLpJ8+UlwG+PS05sN8qeFFNcYfWzkzsWtadxDKRs1YeNE3gqT/FAaD7BjzU+BjqMFToppg9MLCyIy5qgY85XUcQlMPuvZ5nLYB8rvGSE/VyasnM+XeIKloPRE9Tn6xNvJOnH8ootp1cv5osn92PT1cWvGPL1n+Efe6LHNsbIatB7sY5WuasCzCR9DLh1ZQ/OmZIEqDFgAtp7I7iFqg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 30, 2026 at 04:10:02PM +0000, sashiko-bot@kernel.org wrote:
> Should ntfs_trim_prealloc() (called from ntfs_file_release() and
> ntfs_stream_file_release()) also check ntfs_emergency_state(vol) before
> rolling back preallocated blocks?

It only drops trailing holes from the runlist so no clusters are freed.
And __ntfs_write_inode(), ntfs_mft_writepages() and
ntfs_mft_record_free() refuse in that state so nothing reaches the disk.

> Does ntfs_drop_big_inode() need the same !ntfs_emergency_state(ni->vol) guard
> when truncating unlinked inodes with I_SYNC set?

Yes, ntfs_evict_big_inode() already leaves unlinked inodes alone in that
state. We'll probably just do the same.

