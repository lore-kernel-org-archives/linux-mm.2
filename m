Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7D531090234
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 14:13:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 254AF6B04CE; Thu, 19 Mar 2026 10:13:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2057F6B04D0; Thu, 19 Mar 2026 10:13:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F43C6B04D1; Thu, 19 Mar 2026 10:13:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F31B66B04CE
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 10:13:56 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9CF041A0559
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 14:13:56 +0000 (UTC)
X-FDA: 84563006472.14.1FE7E85
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2F50F180003
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 14:13:53 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=qJFdgiFw;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=4jpB79yc;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=OrcSAEzL;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="HXVk5/yP";
	spf=pass (imf24.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773929634;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4fUFXPph0d+U/6GDmGbgLZ/FXBjYuxpYsgD69WTKZEc=;
	b=xD13nUwAnWXW1WWnoAkzvj/hVqT+ZLIVbKXEJ6G1tfnBgqfYGyextAswqcU3IOxspt225/
	2kV9IxENk/rNYo2W4pMlyX4ADsosKPFJCLfz1liHwx+aZ5DaTTY/olJyjFBA1d3KI6EauZ
	kFvz1OQ/64nWRRPh1S6wiflZ6MpBqAk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=qJFdgiFw;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=4jpB79yc;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=OrcSAEzL;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="HXVk5/yP";
	spf=pass (imf24.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773929634; a=rsa-sha256;
	cv=none;
	b=X/ZJ/xZd0dhqSEGgonkJfy6JNMD3ONgnWyEspJU76knT30afy2ZhSivqb+jqOHvIcJrpDf
	ezeDeQLcVpKcpVSBCTXpjd8+dd92192IQiER4X44E/hP9pCDaf2jTbyNzBoNPy4VqvvjJi
	tBi4pnt7OKdDN/TOzWhxSKg1qV3xSXo=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 233AB5BD4B;
	Thu, 19 Mar 2026 14:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773929632; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4fUFXPph0d+U/6GDmGbgLZ/FXBjYuxpYsgD69WTKZEc=;
	b=qJFdgiFwZof840urwELAyJUPmqr5R5KSb1T4rwYuc7bb8XNbCm/kv+M5FkrKSBEOM1bZiu
	/MGyuwm/OFnFKmJm/t/Uz/+GbEcAEAQCMtEWioCbgwKOh4DWZ0qNVZOg9g66xDY+m4U+fD
	w9Xqoe30eNI+goFz62hSwZMzWorThdA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773929632;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4fUFXPph0d+U/6GDmGbgLZ/FXBjYuxpYsgD69WTKZEc=;
	b=4jpB79ycXSQsxOkgtV3HKUa6Dm/vQ/wRir8pmFsiYnB6qgK3LbPe12RtulXb4tol7/E3ij
	faYPra8B4GTfZjDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773929631; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4fUFXPph0d+U/6GDmGbgLZ/FXBjYuxpYsgD69WTKZEc=;
	b=OrcSAEzL/6c4UDB40dZmtUkHL2UKN/t418W/3/WLfRE3VUYtttdOTA1LBRs2LexriSZBXr
	IUCLAcO9QxQoLCNXA0PSitgNb7BC5cuH9t+EXroQLbXGhfbC1mTChSWj64vc6V41FfYy8R
	mio6pb/J12e+5TPnOnmBoDRex83ce1A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773929631;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4fUFXPph0d+U/6GDmGbgLZ/FXBjYuxpYsgD69WTKZEc=;
	b=HXVk5/yPJtxIjyky0dtujMNvVHE9KONXRU8D1O6wb4LBxoqwDaKPYOnkGEkCrYDJmYyVOA
	klxEA++oJw6AsaAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 14B714273B;
	Thu, 19 Mar 2026 14:13:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id TmUEBZ8EvGlPZwAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 19 Mar 2026 14:13:51 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id C850FA0B32; Thu, 19 Mar 2026 15:13:46 +0100 (CET)
Date: Thu, 19 Mar 2026 15:13:46 +0100
From: Jan Kara <jack@suse.cz>
To: Philipp Hahn <phahn-oss@avm.de>
Cc: amd-gfx@lists.freedesktop.org, apparmor@lists.ubuntu.com, 
	bpf@vger.kernel.org, ceph-devel@vger.kernel.org, cocci@inria.fr, 
	dm-devel@lists.linux.dev, dri-devel@lists.freedesktop.org, gfs2@lists.linux.dev, 
	intel-gfx@lists.freedesktop.org, intel-wired-lan@lists.osuosl.org, iommu@lists.linux.dev, 
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-block@vger.kernel.org, linux-bluetooth@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-cifs@vger.kernel.org, linux-clk@vger.kernel.org, linux-erofs@lists.ozlabs.org, 
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-gpio@vger.kernel.org, 
	linux-hyperv@vger.kernel.org, linux-input@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-leds@vger.kernel.org, linux-media@vger.kernel.org, linux-mips@vger.kernel.org, 
	linux-mm@kvack.org, linux-modules@vger.kernel.org, linux-mtd@lists.infradead.org, 
	linux-nfs@vger.kernel.org, linux-omap@vger.kernel.org, linux-phy@lists.infradead.org, 
	linux-pm@vger.kernel.org, linux-rockchip@lists.infradead.org, linux-s390@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-sctp@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-sh@vger.kernel.org, linux-sound@vger.kernel.org, 
	linux-stm32@st-md-mailman.stormreply.com, linux-trace-kernel@vger.kernel.org, linux-usb@vger.kernel.org, 
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org, ntfs3@lists.linux.dev, 
	samba-technical@lists.samba.org, sched-ext@lists.linux.dev, target-devel@vger.kernel.org, 
	tipc-discussion@lists.sourceforge.net, v9fs@lists.linux.dev, Jan Kara <jack@suse.com>
Subject: Re: [PATCH 12/61] quota: Prefer IS_ERR_OR_NULL over manual NULL check
Message-ID: <ol2d7c5z7yfyuwo5tyfxurgqedruhr6bzmuv37bx5phhrmmoyh@4zjspbtexid3>
References: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de>
 <20260310-b4-is_err_or_null-v1-12-bd63b656022d@avm.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260310-b4-is_err_or_null-v1-12-bd63b656022d@avm.de>
X-Rspamd-Queue-Id: 2F50F180003
X-Stat-Signature: e8o6qo3quowuwpo8xk975u68tjqao1ym
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773929633-194888
X-HE-Meta: U2FsdGVkX1+Or35G0Y9iGpWkVoRuCGfLCJ1aeSnoDrgLZJ6VRJzNbHUuLbF8kysoCAAS5CcTI6QVKL4wH701fuhyxcbMgfM0AD/qef1vNOR1wCYDQnILNly+3T0+0vH1mbXzjPwCwfjZ5oAOrZ7Pjup5svVeJ2bhtB1yLpU8LBLwg9VPgtv1chuyjevMldx7N1v8l9JxEiufUqRhsGUS+uIxXOZllV/pqXbDDRBErIjcS7QfH5BRklTNOIbg3DLMn5AeNh55JMKLt/MkoC8bH4CsitsnjoDRhBXs2GsP0j8D9w6xz/1kZP/uVNoSr5+I21Ogse8jZVxtQjpVQvbOdIaxWn/8NwxrCs2Ke+lqSQ9l9SJBNM0vdIbElQ8RMTgy2ZGrofuyw4F8pvxEMRPi+YZCCSmh3vmsHfro0GsNDymEYG3VpR43FL2Slq2PsdWdS+F7ZsqhySMGXb1k20gC/hQoNgXGQ8MLhgLWel6Cjldoe2ctUqiga6Ei083TTsony8O+FUwwKqMhH+oHG+bPG11MG1uBPTpjBzvpK7dHlEZh7elTIgTw9jRr7tGkyhl90CVBqQC20MRNzUEwbBp4mYoICaAv0tzfVhAmg9Wir7NZSLfyTV1PiLoHox41Tlup0CDE4NnyWv5ANrtBg1LtmAm37TqV5zpGiozJDMKnoaess6GfJVuWD8Lh336Q0OzKgjPvATcwOPEi9ymKECb4W3/w2/J5h5bAIvevU1hTlHz2uvWnk6VlF1naPJa7j3qvL90lgocNpueFWmPcIP6ssZUuIP12K7Pac3zWea5oIPd+8NiFwBYIJGIvM+xBrXmb87a3JOzeChAO+HeSUcKdeqKaBEpA7e8BJgI6Bksuee0IZ27zTcEYR1tRCcpfqhvf8Lm/4YNcYtIIfQ26kYYDFtjewVfigLkCTrehcVWy+cV+2gdRGkBGwK8g1svrgK5GEUtwQAwj2OVpAPLTKrc
 M292Puld
 F6ZA3iYuVzAoR5uflQ6QqJJVwFCmLeYAVkp/wLkiN8vav2embGMv0CO02bxfd7oniy/TCFUxlkSnaAdBdIDTdxpLIN2DSPQI/Ri//PmhhThVO4sOGEzUqcynND7/ydCiudsaxNfBuIErv2Nhyh+PyLtE6Ve7B+uM/MwAOtyQbJACmB05gTL21pnVauXM0uSI1+be2hLXlBGoI9IAQfEbQIraG3dKQWThlNhiaQpA1l0D9BTiAD6IJ9bxHsb00FGfdHu2ckQ1igL3a7tQqOte8mRYVL38DcArjaBAjEU3Z1Jp9wnikzt6cvIXdYoIvhwpRYlHu7EggyTd8rs2U2cUetrooCHViMHTPjg2cRdh+rKpZ+dNh0nh2qZqXCsooDy7y/YJcxarFFq4ihOG8lZOgvFl/rXLDfx6o1mFhUkG5e7GnZ6u1wHd/AJzmlS4GQzyX39rQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 10-03-26 12:48:38, Philipp Hahn wrote:
> Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
> check.
> 
> Change generated with coccinelle.
> 
> To: Jan Kara <jack@suse.com>
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Philipp Hahn <phahn-oss@avm.de>

Thanks for the patch but frankly I find the original variant clearer wrt
what is going on. So I prefer to keep the code as is.

								Honza

> ---
>  fs/quota/quota.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/quota/quota.c b/fs/quota/quota.c
> index 33bacd70758007129e0375bab44d7431195ec441..2e09fc247d0cf45b9e83a4f8a0be7ea694c8c2a1 100644
> --- a/fs/quota/quota.c
> +++ b/fs/quota/quota.c
> @@ -965,7 +965,7 @@ SYSCALL_DEFINE4(quotactl, unsigned int, cmd, const char __user *, special,
>  	else
>  		drop_super_exclusive(sb);
>  out:
> -	if (pathp && !IS_ERR(pathp))
> +	if (!IS_ERR_OR_NULL(pathp))
>  		path_put(pathp);
>  	return ret;
>  }
> 
> -- 
> 2.43.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

