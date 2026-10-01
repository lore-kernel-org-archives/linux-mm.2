Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FC5ECA5FCE
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 18:43:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4784A6B0092; Thu,  1 Oct 2026 14:43:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4224D6B0093; Thu,  1 Oct 2026 14:43:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C3846B0095; Thu,  1 Oct 2026 14:43:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 124EE6B0092
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 14:43:46 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2F045401F2
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 18:43:45 +0000 (UTC)
X-FDA: 85274931210.24.DD774FA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9A21B1C0007
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 18:43:43 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ei+G6BQ+;
	spf=pass (imf18.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790880223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8IhyPraaZ+0Y4y5yNF3T0TZ5caa5fwXRSAMFytUHil0=;
	b=2wU9LoiCQuPWEIysOyurmH/pz6cyBCIKzgTP64ylaJhrQLbqJjphOeBlUzhd06azTAC4wx
	au7nbGiDmnK0dS/3SkwuwlDoqQYCpDCKCAVVWF/Aoql9y9GyQwkbYtxdFBQZbPRXm9i1cr
	kQOtAS6YC4yvphtUxn0ORqTX3STqzM0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ei+G6BQ+;
	spf=pass (imf18.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790880223;
	b=AXpLxR4+ycv2fMpNSsdld29Dm5keNkyiVBKvt3wPbpe2yYPSrNgEjk/Qy+s62VElmLPByI
	/fyJBtUV+bs6wDM2bbd1ahE4EWhq1x+zlOvIbihDryNLFNuLJnA6BMRIVXon5zTRlvW8rp
	GKd4ApzyH9sfBfJxhojRk5qgC1r3iQ8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2648460218;
	Thu,  1 Oct 2026 18:43:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7A981F00898;
	Thu,  1 Oct 2026 18:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790880222;
	bh=8IhyPraaZ+0Y4y5yNF3T0TZ5caa5fwXRSAMFytUHil0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=ei+G6BQ+kQusBfSuAr9wTOsaqN5ckM7JLvO7hIUYeDcCqP43VlOvoItk5A4Mru+0z
	 TPGzdx7kMbtZcAzGelAhophnMIcY7WlH0Gh7kS/kGOy+hyokmWH6COBlDWGgXqD8Zq
	 jdkcItAqxwlM5WWGriLvIiLGGMm/Qdc5h7mh4hPUKxQwDn4F+panOEuPfGx1zYqqhp
	 HrUgRFiIZ8dijReXRACFrTPLlbuX/9xHzDxUfTUx2XiUUfZ8dmASp1p1+NvV1mFc86
	 ih7ApInwzZXkJa23LlvYks6M+jUJY0tT8Ae44TF261aLpujb/g/VDpdVRkzjZSTL0l
	 W2LMvjPwwmHpg==
Date: Thu, 01 Oct 2026 08:43:42 -1000
Message-ID: <ef728276c74f15e11f42301b4e6f011f@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Liz Fong-Jones <lizf@honeycomb.io>
Cc: Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jens Axboe <axboe@kernel.dk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Xin Yin <yinxin.x@bytedance.com>,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ian@honeycomb.io
Subject: Re: [PATCH v4 2/2] writeback: switch a replaced cgwb's inodes to its
 successor
In-Reply-To: <20260930-wb-dying-cgwb-flush-v4-2-bde637803a96@honeycomb.io>
References: <20260930-wb-dying-cgwb-flush-v4-0-bde637803a96@honeycomb.io>
 <20260930-wb-dying-cgwb-flush-v4-2-bde637803a96@honeycomb.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9A21B1C0007
X-Stat-Signature: g6keok6u51ukj7b7d93c6douan8gej46
X-Rspam-User: 
X-HE-Tag: 1790880223-293673
X-HE-Meta: U2FsdGVkX189GVN60PQaPcXdnY/u249BMt0NjDbxGdejJVX4YOuS4tJ72s2hLTScYhzBkBJBnQ390tSrkGjvU81wpQzSm8PI/k+CeMp5LnbMpSX8gKzccGjocFS0+IR6PGuHArXMEEx6TXVov2p40m2O+cCzh+13CbxUCLCuuNUb/PdXEVAoSu+wkJWDu0PNaJmE5N/jtGhJyh9m+kzHALFwACZjo44XJbk21l+f7U804sbl4rIKtNIGMnUNff1hpXY3qtz8yz8Lj1CDE7w8G2V9BCdt/RfEEfuH1gamTPukWXupG5SUVN4FNu5BjCFWIlLXnuXgaaOCbFEz9aIRsaUiA89vHVtlpIBRx/KnUjQ4GPcSRq78bRk+scBCRMpYIPI9Q2qr6c4+2k6azqyPqxzyzamcv0kKNWiyfg1JWb0C9YRBqQNWfaM9jRQJeEPrapYJUyhtFBr89ON9+20ezqVyv1MsNi+CC3uQEv5n6OuT1tB/3J1IpetOY5QvtHNIiIyJm51YPHVDfNlzuPeGPGIavlPwLf4gf6aRH5gEx1Fc957ESLdfcurYoARwzuTu+PkzX7gudz/4kMrvOqJbqUL6JxVqZOiFUYx2I/0gjcb7KSIlbyxeqFTEJ9gJv0FWbFK/s8PN6ndgi2dT3Jugr3RzSyR2b5fU1y0I5FQxSXCAS2Y8nRWrTfzrGZ0Z5c6Gy5XKibBpvFp6VAkzPCvHyr05ko6sTIW5xfYEBIb1ktut390llVq18bbbSfYe/ilBl5LeUNSKgPQutbR3GerpGtodptaoglxXHUC3CwoCyOKVzzC6P7NjtU0NpC2hs9a+u7ons2uQVMgGGZTA99ETpXTiKFoYkh/f2n1RMJd3+7zh22F23JDT2N/auggyIq68XRK+gW1NukL7J2gpokGsInLChg9vd+kBRP1F8yE2yf81xpaFPf1nQ8jsklMAYFn7S8np3i74aGgp/MU69sX
 gu7G6zDg
 sRPUHihrppxMjof3RosqMHXpc6BaZtAx/jYZx3xi27pPPXlM0R4dx1NB7wIm8u8wyopWW/RL4ca53yFY8ag/vBhAeq0SGO36ylhZelOU4WDeqKA1DAbgonK1/6gvUI+/fpUsonROSbpX9bGXIEIR9sSv/SUStKuBM0Qv4baeHVRSmKbUWkoeYf/28nf5x6CLN0AiMNLYK1V3F6pq/8oJyqCwjJ3yqq/TuLIIPR+JlzWMtpcWvIkSLQ4o0t4KIgHj2LErY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello, Liz.

On Wed, Sep 30, 2026 at 07:35:37PM +0000, Liz Fong-Jones wrote:
> +	new_wb = wb_get_lookup(wb->bdi, wb->memcg_css);
> +	if (!new_wb)
> +		return false;

If the successor was already released, the slot is empty and the inodes
stay on a wb that foreign flushes can't find. Maybe fall back to
&wb->bdi->wb like cleanup_offline_cgwb() does?

> +	spin_lock(&wb->list_lock);
> +	restart = isw_prepare_wbs_switch(new_wb, isw, &wb->b_attached, &nr) ||
> +		  isw_prepare_wbs_switch(new_wb, isw, &wb->b_dirty, &nr) ||
> +		  isw_prepare_wbs_switch(new_wb, isw, &wb->b_io, &nr) ||
> +		  isw_prepare_wbs_switch(new_wb, isw, &wb->b_more_io, &nr) ||
> +		  isw_prepare_wbs_switch(new_wb, isw, &wb->b_dirty_time, &nr);
> +	spin_unlock(&wb->list_lock);

Switching a dirty inode away leaves WB_has_dirty_io set on the old wb.
inode_do_switch_wbs() moves it onto new_wb->b_dirty through
inode_io_list_move_locked(), which only updates new_wb, and nothing calls
wb_io_lists_depopulated() on old_wb. A live wb clears it on its next dirty
to clean transition, but a replaced wb never gets another inode, so it's
freed with its avg_write_bandwidth still in bdi->tot_write_bandwidth,
which wb_split_bdi_pages() and wb_min_max_ratio() divide by. Can you add a
prep patch which calls wb_io_lists_depopulated(old_wb) after the switch
loop in process_inode_switch_wbs(), while old_wb->list_lock is still held?

> +	while (switch_replaced_cgwb(wb))
> +		cond_resched();

cond_resched() is a no-op on PREEMPTION kernels, so a wb with a lot of
inodes keeps this worker from reporting a Tasks-RCU quiescent state. See
407a5d205179 ("writeback: report a Tasks-RCU quiescent state per cgwb
drain pass"). Can you use the same do { } while () shape with
cond_resched_tasks_rcu_qs() as cleanup_offline_cgwbs_workfn()?

Thanks.

--
tejun

