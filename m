Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06C47106F304
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 08:48:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 728826B009D; Thu, 26 Mar 2026 04:48:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D9246B009E; Thu, 26 Mar 2026 04:48:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C8206B009F; Thu, 26 Mar 2026 04:48:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 494846B009D
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 04:48:53 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2091E1A0C42
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:48:53 +0000 (UTC)
X-FDA: 84587588946.15.0CF2F92
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf15.hostedemail.com (Postfix) with ESMTP id C467BA0003
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:48:50 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=0Oxt7yR3;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=azaDylUx;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=rplQ+VPg;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=wPBLDhR7;
	spf=pass (imf15.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774514931;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EnbEqvKAd1umNPypewf+IOICrqQu9pmFoTVtZPEsqZM=;
	b=hidJvrZJMqz6mBiwySQ2f/LzXXi09XiAGV4GAEdpofqN/gfEZyoRVFj/BeD5VXpflSCWef
	aVqUGjuQ7VfjRE7JKC4BLExgcNS8obdKFiA2QIyIzbIFq1qkLCNV43YNe81Nv/wqQpG/nW
	Qx5poKpL/QjA22ufiyRLhW15hkZSfD8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774514931; a=rsa-sha256;
	cv=none;
	b=5btPsUZpavzyQtwuKGA8DpXQ7WEd3yrmN9hud8N8D7St5O7+p4Q6X8mk4gDLp+NMITN0mQ
	k26e+8wyAovTy5g9ZTJzg6Nkhp+NjefAgEnSSa8KcRvZEIjv50udnU53nQV1iWV9bp9PvZ
	E6jDVq5NTFJdaYSNVzbde7BY4Im/FFw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=0Oxt7yR3;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=azaDylUx;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=rplQ+VPg;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=wPBLDhR7;
	spf=pass (imf15.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id EDA785BCF4;
	Thu, 26 Mar 2026 08:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774514929; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EnbEqvKAd1umNPypewf+IOICrqQu9pmFoTVtZPEsqZM=;
	b=0Oxt7yR3pKsJxG794dJ1CnhiQ7jNgFvGyFD6fHTrYV6KktBbGonj3wy6LuvEbnXnA55M9a
	5znR54+aaHh+AM7fdYpO3ImrIW361b+TM3Vepol1KkXbMypgV82+2Q5pDs3Ym7swfoOydo
	B9f+7BVZ+oI20i+ythVEYt/wVDHqSgQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774514929;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EnbEqvKAd1umNPypewf+IOICrqQu9pmFoTVtZPEsqZM=;
	b=azaDylUxg5+DP2OXZPmcOlCsTi6mhsTxYCseyrOgULoKGoh0QfYqLC8wl5W+mcGKiBzkdI
	QuMZ7CouagYJxoBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774514928; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EnbEqvKAd1umNPypewf+IOICrqQu9pmFoTVtZPEsqZM=;
	b=rplQ+VPgSqlRFihjDumPRJzdBuZKPDjdB5nCg5nTvAh00ALVXKmnkrQmnG1x6PyPziT2Jc
	9xt6Ce+auEtLM2g8K1OA+TScc2iSRvtAtqAQ5wxjlUcCo1pDIKJm3h/mb8WaQbFzrEIluO
	ss7/m8yrO1GOhYIKl8lstVa8xy8eWuE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774514928;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EnbEqvKAd1umNPypewf+IOICrqQu9pmFoTVtZPEsqZM=;
	b=wPBLDhR7JdXXaFP/VkUwk5EauLVXV+fHAiSls3auDBypYaFyiFM163QYkbIopQyGFumzpb
	voERPB6qNNYja1DA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E40134A0A3;
	Thu, 26 Mar 2026 08:48:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id kkCjN/DyxGlADwAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Mar 2026 08:48:48 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id A9C7BA0976; Thu, 26 Mar 2026 09:48:44 +0100 (CET)
Date: Thu, 26 Mar 2026 09:48:44 +0100
From: Jan Kara <jack@suse.cz>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, jack@suse.cz, 
	willy@infradead.org, miklos@szeredi.hu, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v1] mm: fix writeback regression for strictlimit BDIs
Message-ID: <yet2ddivcs3v4g5wmr4zfjkwsbzfjmwjhq56zur7wjivd72abs@tq23xp4mle2o>
References: <20260326001337.828947-1-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260326001337.828947-1-joannelkoong@gmail.com>
X-Rspamd-Server: rspam12
X-Stat-Signature: j88hui6u3bdcu31s17tdkhapo8ij4cmk
X-Rspamd-Queue-Id: C467BA0003
X-Rspam-User: 
X-HE-Tag: 1774514930-30378
X-HE-Meta: U2FsdGVkX1+I4hgCZaSQgHdMqrz/LQuI2eG+9L+sFg3Bv2MOj5EIvHo1GlOIc05gPavhkeuzZ7ApsEkGdJ+kIJ4v8cEGePuUXmlH/fVpm41Ud+kQjU4i/aJTeR8ACSeRo0FtcUdf+7IoaETU+9wRmerwD74N/GeQWNVztrsI/YiOGQPg8UanlWyvS10hkrmp6KyGzbNEIRbbRBk7EVzLzakqpTUupPPQuI7vOAPpghH+/4WHVTGnn/3eQA23TfUCbfHlY2S4hscWzYqnhXOHhZuIDtU0Dm5SUjZASEBVy6xWSZm4vOrqGxbzY1+o1xFdMWxa8HB5w105UYt98Oeoc98vi9H1j0A/Gw2ACZKDnLLL2IxkeAys+orJXC3Z8Q0fP0uLdaBPbrWhUjub5HYnKZK7jxPz2WwWwJdaaXIae0G6SNDbnup4vx9gR1WceuH4dwVl6c51yo5H9LwgtnITQB3JNSB3Xise5lM0Jcs9fFcs/Fr7yhzEZysNDH2IZW5AWnSlGYoESCbQYcMyGcZnx2QYl4m3iLeDW9q47QYoyJNeslinZ1JU7Lpg+Y65Xw0gUO7VVTJnagZ90WpTDmvuXAc7O3wlXNkF/lvAE1dBd3n4gCrzN5EC4bJWWttTwE3Hf/PnN3gzq3F5wrzXXzFLYTRB1c29Mx+zPPQHdKzMQ+ZkdtMsieLsOqiXm8vQexuIsxBofiyWncwoNKmWbkCGt+b86le88YlGaDKr3+fB8VF2YxViogbiS8716RWJKEcY1jmflSmcDUSkBPVBT0TKQ5W3xAjcnSI0bD/cgHXDFOPIGvMBgZZKCvQGK0a2VgesmzsjujHxe/LDdZtEdRD3rXolUzqs0REC1LtgudppBxcYa5CflTk+Wirjp3Yw814KeIFx+bEciWWOwlmceSlRyFZdeS3FOeC65BtPgLyLbzirkk46hNUT3j5ai54e05PM3LyhSsverHyCpBakb/x
 EqgCvL+V
 c8OEyaYycMpxihj6mkqaNoTnSCJHRH2UzilBKr+MUwOehaeBD+dk7Dap0H7MHOjltQPQfVuUKceJ99mF3Z1KNx7ZOCfbjxHZeh5oJzZwSQsSkchxCXGkzxzrj6YuvuXl5AvvFYxso35EmJQ+SQRt/e5nzpwKaKfROWzi/U+KZ9btKUYLu9p9DtxT+mEEG1DtB8j9BClsKgHJRjobgx5ExfCbPcVdMpVIem0G6Sts/o/7jW7LNJEUhnDUUweqa0ZbbYhEFltKcETCOdBd1fUXTrvo3RNrgs6SOOpeMneqcl6XE5pkKQ7F8WSTF7dHDdLGjc3OiOfg5eW2TiT4JjNV4KZLEqNmVOR+TkYN3U20N4VYFKZo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 25-03-26 17:13:37, Joanne Koong wrote:
> Commit 64dd89ae01f2 ("mm/block/fs: remove laptop_mode") removed this
> unconditional writeback kick from balance_dirty_pages():
> 
>        if (unlikely(!writeback_in_progress(wb)))
> 	       wb_start_background_writeback(wb);
> 
> Earlier in balance_dirty_pages(), background writeback is started if the
> global dirty count exceeds the global background threshold (nr_dirty >
> gdtc->bg_thresh). However for BDIs with BDI_CAP_STRICTLIMIT set (eg
> fuse), throttling is calculated using the per-wb threshold, not global
> thresholds. This means the per-wb threshold can be exceeded while the
> global nr_dirty is below gdtc->bg_thresh. This causes two problems:
> 
> a) background writeback is never proactively kicked off. The flusher
> should be kicked off while the writer is still free-running, so that
> dirty pages are drained before the writer hits the throttle threshold.
> For strictlimit BDIs with global nr_dirty < gdtc->bg_thresh, this never
> kicks off the flusher, so dirty pages pile up unchecked until the per-wb
> freerun ceiling gets hit and IO is throttled
> 
> b) while IO is throttled, the flusher is still not started, which means
> the writer basically sits in the throttle loop sleeping while waiting
> for dirty pages to be cleaned but no writeback is running
> 
> This leads to severe stalls and degraded throughput. On fuse, buffered
> write performance drops from 1400 MiB/s to 2000 KiB/s.
> 
> This fixes the issue by kicking off the flusher if wb_dirty exceeds
> wb_bg_thresh for strictlimit BDIs. This restores performance back to its
> original baseline.
> 
> Fixes: 64dd89ae01f2 ("mm/block/fs: remove laptop_mode")
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>

Good spotting! I think your change makes sense but I don't think it is
enough. The problem is that writeback throttling depends also on memcg
setup so with your fix we still have a problem that when throttling due to
memcg limits the flush work won't be queued early enough / at all. So I
think the best fix is to perhaps do your change so that background
writeback is started earlier for strictlimit bdis but also return back the
unconditional starting of writeback (with properly updated comment) when we
find out we're going to throttle the task for whatever reason.

								Honza

> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index 601a5e048d12..3f89b08b11b4 100644
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
> -- 
> 2.52.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

