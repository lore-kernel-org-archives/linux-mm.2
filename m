Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 391F910F284C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 16:07:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8199E6B008C; Fri, 27 Mar 2026 12:07:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C97D6B0096; Fri, 27 Mar 2026 12:07:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B8D16B0098; Fri, 27 Mar 2026 12:07:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 560AE6B008C
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 12:07:54 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2FA7B1408C2
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 16:07:54 +0000 (UTC)
X-FDA: 84592324068.25.B38044E
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf07.hostedemail.com (Postfix) with ESMTP id D967240014
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 16:07:51 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="ja3Gn/8X";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=6ey6zWAX;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="ja3Gn/8X";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=6ey6zWAX;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774627672; a=rsa-sha256;
	cv=none;
	b=NMhYhmqERfmEzGvxJSIxO46MzJG0lCugqQ6HaFr889N+wY9XLJNx7qlVXbsTKiW76ItAGd
	W6m9wvepIXD62zhw9D/UWn0cLYBXecazvKKtPQQj8lDZsfv2Km58Q9ptSoXbZ6SKP3ef1o
	tr1dc6H2Pj2341GQkLOJSVbmPdgk4NQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="ja3Gn/8X";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=6ey6zWAX;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="ja3Gn/8X";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=6ey6zWAX;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774627672;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rqt7sqz+Z/AOlrj075O/J83vs51Td6xl2fSsWyleBdc=;
	b=GpnE79bnpnaY0U3d2qe9WbbQTBIIs0KPuW/o9cV1jzouTpW5nKqFQx7FDf3FiKTmS2Qv/f
	RTXo10z/1+7thJp/SjnvTwzHYltz4Q0bXxSL4QS12WCUXMgoo2t8ccLFY4gv9klzfDl6oi
	+gpspLiQMyVRRoW6btT+moiemDu/2O8=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 48AA05BEE5;
	Fri, 27 Mar 2026 16:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774627670; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Rqt7sqz+Z/AOlrj075O/J83vs51Td6xl2fSsWyleBdc=;
	b=ja3Gn/8XuXTXwihUUdv/cNCmN7MtssZoejPOEB4PHAphVKwmoUC6Vq/PBFI2iqjZ6da52m
	CTuOg4cfctf1M6mSKiqiCutpFTQUglGOoUOblqKVKHdKzCSzYA07x/4N9kVH7EhlSTtMRR
	hDJrQZCA8Wb1B9w9DtTH8o8iDTISoOk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774627670;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Rqt7sqz+Z/AOlrj075O/J83vs51Td6xl2fSsWyleBdc=;
	b=6ey6zWAXJfAxJDq+xvcXMq4+Sin9q63+W6u2wa9o/QOVai0NqglMX55Q2aFD5u0NUylHGM
	E+2XIKCFwuWTIfDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774627670; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Rqt7sqz+Z/AOlrj075O/J83vs51Td6xl2fSsWyleBdc=;
	b=ja3Gn/8XuXTXwihUUdv/cNCmN7MtssZoejPOEB4PHAphVKwmoUC6Vq/PBFI2iqjZ6da52m
	CTuOg4cfctf1M6mSKiqiCutpFTQUglGOoUOblqKVKHdKzCSzYA07x/4N9kVH7EhlSTtMRR
	hDJrQZCA8Wb1B9w9DtTH8o8iDTISoOk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774627670;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Rqt7sqz+Z/AOlrj075O/J83vs51Td6xl2fSsWyleBdc=;
	b=6ey6zWAXJfAxJDq+xvcXMq4+Sin9q63+W6u2wa9o/QOVai0NqglMX55Q2aFD5u0NUylHGM
	E+2XIKCFwuWTIfDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3F95B4A0A2;
	Fri, 27 Mar 2026 16:07:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id NuaCD1arxmmuNwAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 27 Mar 2026 16:07:50 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id EE9B8A0976; Fri, 27 Mar 2026 17:07:34 +0100 (CET)
Date: Fri, 27 Mar 2026 17:07:34 +0100
From: Jan Kara <jack@suse.cz>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: akpm@linux-foundation.org, jack@suse.cz, willy@infradead.org, 
	miklos@szeredi.hu, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v1 1/1] mm: start background writeback based on per-wb
 threshold for strictlimit BDIs
Message-ID: <pkmsqdxopfvphud4qvionkl45qnz64xiuo4gnhd3m2mvy4m3xm@fcrenmksutyh>
References: <20260326234629.840938-1-joannelkoong@gmail.com>
 <20260326234629.840938-2-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260326234629.840938-2-joannelkoong@gmail.com>
X-Rspamd-Queue-Id: D967240014
X-Stat-Signature: y1gf5g7p9h3x6t6cdm64g1wxr9ukohi7
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774627671-300624
X-HE-Meta: U2FsdGVkX1/m7pA8bD97h6K7glaohgeQNQ08DyerRWzKqNwjtR5y6CWxqRkDQ8PdEACQLQCYK1ZA7DLn74rVj5YqORC8u/+6PteOxathIYdVxHxMFa9pv1zE6zx3GbBft6CgEc49zHqnPxMf8MIkgqN9cC9JBZV+Xa97YEIqUTA7IUbNu4KS0s2W/3l8QvAHFfBYL/6/7VT+XeE/IVxvMNsM2jQk+M+/VPSgJ8HRsZM0JNg7Y7nJpgPI5o0VVxY80Fg7kTtJ9I++Oz9lceXhVuWjFDRyTzN4EQRfcOgHnc2L+Zn1ZR1kYh8IbXYCFEcsRVO//NlPPxQO5fhXm/3uUQMGhP1Db4D0j118x+AwuGDvQ7Iti/7GRcv+we8b+eF2sGNXo68g83p7F1Zl1kzPMFEMma3gumF6R+dnMDJp72A6LVjQ+yPyv3F7Fl0mOPbuYESZ20/KTSemASSFApb4sUSsJrNCs3ugmNiJq0jmIZdH7TtfWNNz93fVUIQaTowaWcLSKb77s8fhF2se56cPRUubZSjNIiUc9vaobyxtu+UW0MchDgQFw+jdJa3N+/jnO4XpnM8Yg63c9JoJEE30jwArSyeL6T1vz/7M9G8yoYQC3nFWmM7NbpT3qSPvaMVfkfseo5wkG+X9572XR/H9NcpefyXp90JlqdLNdRiSxRjpWYY+ZshxM81sVYXkdDTodQi+DNX5Exq8yLjG3Jx3GnsVwHZvzB3QZ7mShxwBNjYurmRq4CPyPnTgznzCnfqzYExPLC3JnHM2/Mw2S1/R5CUZ+sLHKCy18mjHGim1blpVclPPMlfuz3sZNhbEjZqIqL/cHSGGIsn5F08eEfBvkYXXCvSZRGd8/03BRiD+rRpV8B1AvsUIl2T1HFzz/OgZSEji+Vct/0uUthPpD3tno9QGObdQkl8RmFGB+v6YEv0W4JzJG4Xvdyf3ut87sYgjg9PKhHChThWmCHpkYij
 wVOTEVbx
 LKF/uLwr424tTOSqdPH5fmIJbKe8QgUfHsX6h7k1oYvh/23oLYP72PTrxSpMBxCJmdkv/2yanG4brKqa9Q7EvoUa4kjLO6oTfAuAGab7Yg5uJmJlNTZhSWZZbreVH2rRsBctbrHh+1bz5fRRYqisdD8/Funjig9fqV2AUDQcvw/N5SUuVp0AxJeG1G/gE98oAjI8mvKB+tD8KB9X2Ntdka8YVGfVa9VbTzFkBF+3X/HqIwm4jhZOWYzQ30jKhmJfNnk3wsOq0aowBTJwtna+wrWXAMCFXpF58SL/a5SxK2ZHLoz1UZDpsiYH2YvftDJIIv8SDrx3E/PnCb334oHWHWU8VNMVstiu3fX49iOgYRg2y/1I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 26-03-26 16:46:29, Joanne Koong wrote:
> The proactive nr_dirty > gdtc->bg_thresh check in balance_dirty_pages()
> only checks the global dirty threshold to start background writeback
> while the writer is still free-running, but for strictlimit BDIs (eg
> fuse), the per-wb dirty count can exceed the per-wb background threshold
> while the global threshold is not yet exceeded, so background writeback
> for this case never gets proactively started.
> 
> Add a per-wb threshold check for strictlimit BDIs so that background
> writeback is started when wb_dirty exceeds wb_bg_thresh, which drains
> dirty pages before the writer hits the throttle wall, matching the
> proactive behavior that the global check provides for non-strictlimit
> BDIs.
> 
> fio runs on fuse show about a 3-4% improvement in perf for buffered
> writes:
> fio --name=writeback_test --ioengine=psync --rw=write --bs=128k \
>     --size=2G --numjobs=4 --ramp_time=10 --runtime=20 \
>     --time_based --group_reporting=1 --direct=0
> 
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>

Looks good. Thanks for improving these! Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  mm/page-writeback.c | 16 ++++++----------
>  1 file changed, 6 insertions(+), 10 deletions(-)
> 
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index c1a4b32af1a7..30f3d5a6270f 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -1835,7 +1835,9 @@ static int balance_dirty_pages(struct bdi_writeback *wb,
>  			balance_domain_limits(mdtc, strictlimit);
>  		}
>  
> -		if (nr_dirty > gdtc->bg_thresh && !writeback_in_progress(wb))
> +		if (!writeback_in_progress(wb) &&
> +		    (nr_dirty > gdtc->bg_thresh ||
> +		     (strictlimit && gdtc->wb_dirty > gdtc->wb_bg_thresh)))
>  			wb_start_background_writeback(wb);
>  
>  		/*
> @@ -1862,15 +1864,9 @@ static int balance_dirty_pages(struct bdi_writeback *wb,
>  		 * Unconditionally start background writeback if it's not
>  		 * already in progress. We need to do this because the global
>  		 * dirty threshold check above (nr_dirty > gdtc->bg_thresh)
> -		 * doesn't account for these cases:
> -		 *
> -		 * a) strictlimit BDIs: throttling is calculated using per-wb
> -		 * thresholds. The per-wb threshold can be exceeded even when
> -		 * nr_dirty < gdtc->bg_thresh
> -		 *
> -		 * b) memcg-based throttling: memcg uses its own dirty count and
> -		 * thresholds and can trigger throttling even when global
> -		 * nr_dirty < gdtc->bg_thresh
> +		 * doesn't account for the memcg-based throttling case. memcg
> +		 * uses its own dirty count and thresholds and can trigger
> +		 * throttling even when global nr_dirty < gdtc->bg_thresh
>  		 *
>  		 * Writeback needs to be started else the writer stalls in the
>  		 * throttle loop waiting for dirty pages to be written back
> -- 
> 2.52.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

