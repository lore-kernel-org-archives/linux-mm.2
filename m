Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72040C61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 13:52:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 440BE6B00B9; Thu,  3 Sep 2026 09:52:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A1E56B00BA; Thu,  3 Sep 2026 09:52:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B8AC6B00BC; Thu,  3 Sep 2026 09:52:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id ED6996B00B9
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 09:52:20 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7C320A0592
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 13:52:20 +0000 (UTC)
X-FDA: 85172590440.25.ED66284
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 532F2100005
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 13:52:18 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OWEIGGmQ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf05.hostedemail.com: domain of bfoster@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788443538;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RYValkT1RfLf8KNyXAg43KyIUolG/6q8D740NY7N3y0=;
	b=TZIjobuMEmXlDX05kQw6dA4SGkiH31LOCsoIJLAiccs9BuPw9fth8OaZU/DkiJCRHdfBnN
	8dEn12ccgMfB7YuTq9HkaOTUoUgndciwGVgqLlQzw/drp0woX6vu2V2HNoi3O2Yda+E5TG
	bGU5VXLC+itjeEDiL22wcqUtiDUzFG8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OWEIGGmQ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf05.hostedemail.com: domain of bfoster@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788443538;
	b=E5ePXzaR0VJFm0/K49A8kXeP0wG5eVYhPDC4xDakl134iLepBq/I0leg6n/N+ygy917kfz
	XrtE+S0yRrLutrbD6Z724tjdNGzqixvIcL5oxj55hBqVe0l4Whsg/VUT4RwxzhNfO3EVa5
	cgn/glEpeXl33a7BtaijZVgHbsIxIU8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788443537;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RYValkT1RfLf8KNyXAg43KyIUolG/6q8D740NY7N3y0=;
	b=OWEIGGmQKYVHSOLO41Jor1RzhFe2pcLYt2cihwxGesQQNMJXIQitgf97DjxWtIeHfeA1TX
	Opls2oJwpbTdBfhyN2uwEThkCDpyOynTIeQ/lDZU6PYdTES+Q7FMZdpVAc1kjpWoI+cEmO
	H7oay6tt+WB+aOphPMSRHhLZACo/Wig=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-27--MjhSEGMNGGbQ1VSHW1TjA-1; Thu,
 03 Sep 2026 09:52:14 -0400
X-MC-Unique: -MjhSEGMNGGbQ1VSHW1TjA-1
X-Mimecast-MFC-AGG-ID: -MjhSEGMNGGbQ1VSHW1TjA_1788443530
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E1174190FF8E;
	Thu,  3 Sep 2026 13:52:09 +0000 (UTC)
Received: from bfoster (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 830C73000239;
	Thu,  3 Sep 2026 13:52:06 +0000 (UTC)
Date: Thu, 3 Sep 2026 09:52:04 -0400
From: Brian Foster <bfoster@redhat.com>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: brauner@kernel.org, djwong@kernel.org, cem@kernel.org,
	akpm@linux-foundation.org, vbabka@kernel.org, surenb@google.com,
	mhocko@suse.com, brendan.jackman@linux.dev, hannes@cmpxchg.org,
	ziy@nvidia.com, david@kernel.org, qi.zheng@linux.dev,
	shakeel.butt@linux.dev, ljs@kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] xfs: fix NOFS state corruption in btree split worker
Message-ID: <apl7hNnt0lR5HFXA@bfoster>
References: <20260902134417.c44503a1d65533f81fb1c391@linux-foundation.org>
 <20260903133756.2006032-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
In-Reply-To: <20260903133756.2006032-1-wangkefeng.wang@huawei.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: iFkVR1UNJWRCfr7phBQIlEEFR_LImCxkHjqIJvgcwtc_1788443530
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 532F2100005
X-Stat-Signature: jermwud6mbzu4nij1mzab3qt84wocnh6
X-Rspam-User: 
X-HE-Tag: 1788443538-699466
X-HE-Meta: U2FsdGVkX1/o3xLHrqYa6kPaJeWPifI8LA6jS70GQMQyD58Ev1sos+WWmigUDkIzsUx87ajjhR5XEBU+LIFeOKd9R/tbgjaJasC6KLoCyBj3tznqCXJQKtK5B3utbqLuM3D/Z8gcv55hPdDD82wpcrcefNeWjRR3QnRT9kED7/GxlSGlFPwVfQUBDebkNGyboHC9dgyl5UH1OCO7yNBNkXUNNBmMGj6vvcR7r9iEx6wd1U2i/vecb+uWHBuj1kmUK3gC04wsPhzRFUT2vhdc76caPknBrwAJujTFC+OKoLe2sZmGgN3HKk1Xf3+Ch48N+GI+2I9AMuBUUWg25T0QrJtzX8xUptfN/brOX2dxH8MhVc572v3ova9eVTvxdde4/jAQ6kW9rGqgMli+toL+7DXIMjLcsyxHLbn51Dby6b2s5i5sQcPd28i50U5wkR2oEMQPJX0bAirzMSiJoXUEmtzbT9dI6RkZ3WUvkAgh4wnCHphOB+Cow8rnwlvs5ba6yjUQKQ4u04AVmXwrWBHiZaVHPyeur2BrpD6F7GpnEwSDTMGTM0YEFkSDaKguLMkO2LOVxPfJmmO5hv+9oS8q8B/upysMkYjElBw2iN5L9196lydlxCQlf2bpuUHilElmjDVsXiqP41/WUmve34lzctw5HtWjh/o0NyWAMmaRJV9Sx3UDUF3JnOeDnW37S/wNNgZjnmSGnV3/cjcyV6jbTaB7B0lEc/ZX1pg+xD87VwFR8YwpPW+v3h+6CwtQPdiE0tUbaw1yQwppEkOK3ekhXej87R3CEVRrtnrP4F3avGkWfVAprPPUz65wA+rbZZAO+NbIHsazd/By+OjSi4rzRGnE6tNe/8HQxmg6RlSbQeUoxTKP1LGxnMydYFpJB1DI50ZJWQhVykuyD+qGG5sdx9+j7yddIb1BKgRo/1LI+ewh7k5BctKmSTFU/8+ncaVbSVDhNrZJhO75LWW2vHa
 W85mFVNx
 SEVndrZFRTfXt2KiIxfgmf9tHK3G96h71xTpEiCZ+wO0XvbTYR1ifHW/zPk+X+TLfy1Fh+rA7VT/eEBadylhL21/2sCEoBTc5gMV+WCNXOLCToGd3BJL/5TxcO+G709wyz2JjE3VNePqolx3sd8i6kFu1FSSfIzmtAQ4snXU3QZIGXfctIyWOOpyuTIihd2cEhvLgEn5JcRTmXp5lFXVOHX2E5oV9P8UsZxKkoF+M8/SC/rrN808ejGKDjex4gyrSBcPOcEjUADyVJ2kyxAGbhUJ3/C48hJueCp9yHOOFrtc28KwonE88SCUp/ReO8Dir/KLrgHjQCho/CBYcW1GxGrx3o0EhfRRwghqMNd9mGrVwvqNc8sOpnw3Rs+nrWvnujQTKvwpBYlL64cDDu/0jTUjP8gLRSKZMLt1NNpSeEAn3edg+0jyD2/D3ZV8yYrXhSosM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 03, 2026 at 09:37:56PM +0800, Kefeng Wang wrote:
> xfs_btree_split_worker() calls xfs_trans_set_context() and
> xfs_trans_clear_context() on the caller's transaction, overwriting
> tp->t_pflags with the worker's NOFS state. When the caller already has
> PF_MEMALLOC_NOFS set (e.g. xfs_end_ioend_write, xfs_dio_write_end_io),
> the corrupted tp->t_pflags causes xfs_trans_free() to erroneously clear
> the caller's NOFS protection.
> 
> Use memalloc_nofs_save/restore with a local variable instead so
> tp->t_pflags is never touched.
> 
> Closes: https://sashiko.dev/#/patchset/20260902131653.1338227-1-wangkefeng.wang@huawei.com
> Fixes: 756b1c343333 ("xfs: use current->journal_info for detecting transaction recursion")
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---

I agree that the Sashiko analysis looks correct. The only thing I wonder
is whether it might be a bit cleaner to have the set_context() helper
return the context instead of hardcode the assignment to ->t_pflags so
it can be used in both places. The reasoning is just that the current
arrangement kind of makes it easy to repeat this mistake in the future.

Then again, it's a single line helper so maybe another option could be
to just remove and open code it. I suppose the pro of keeping the helper
is that it's a decent spot to document the concern and why it returns a
value, etc. *shrug* Thoughts?

(Please don't change this patch just on my comments alone. Let's see if
others have input first..).

Brian

>  fs/xfs/libxfs/xfs_btree.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index 6738d9d1511b..8ae4b94e6995 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
> @@ -3007,12 +3007,18 @@ xfs_btree_split_worker(
>  {
>  	struct xfs_btree_split_args	*args = container_of(work,
>  						struct xfs_btree_split_args, work);
> -	xfs_trans_set_context(args->cur->bc_tp);
> +	unsigned int			nofs_flags;
> +
> +	/*
> +	 * Don't use xfs_trans_set_context() here: it would overwrite the
> +	 * caller's saved NOFS state in tp->t_pflags.  Use a local scope.
> +	 */
> +	nofs_flags = memalloc_nofs_save();
>  
>  	args->result = __xfs_btree_split(args->cur, args->level, args->ptrp,
>  					 args->key, args->curp, args->stat);
>  
> -	xfs_trans_clear_context(args->cur->bc_tp);
> +	memalloc_nofs_restore(nofs_flags);
>  
>  	/*
>  	 * Do not access args after complete() has run here. We don't own args
> -- 
> 2.55.0
> 
> 


