Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D15C10FCAC0
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 18:37:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FE5C6B0005; Wed,  1 Apr 2026 14:37:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5617E6B0088; Wed,  1 Apr 2026 14:37:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 401BD6B0089; Wed,  1 Apr 2026 14:37:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2B2656B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 14:37:09 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E0B1A88B09
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 18:37:08 +0000 (UTC)
X-FDA: 84610844136.11.2BED9A5
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf15.hostedemail.com (Postfix) with ESMTP id B66CEA0006
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 18:37:06 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=JkZvhZfp;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=wbW8AIfy;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=POr51HJ2;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=hLiwalMs;
	spf=pass (imf15.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775068627; a=rsa-sha256;
	cv=none;
	b=DeWOoEl3oeIGOpCLhsMOKPkeMRAoNI7LKPnpBG4zpsqkWh7Z4AXUBViT2WID5mmJIj857S
	2OLFZ8WEAmLg1iquiejzGthj52Ika+08DeA1fdzFC3TLA7difGJqaqthjy723S+1fdFtx1
	cPAgnw15JrZE3Cd20+SCtWDt6B3R0uQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775068627;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h/7sUiZjbg4FKN7DXWpr1Oi6HzSM5TNIS0g3pr1Zlz0=;
	b=hUR3PsntULsw9YNttHcOhAdx9bHUf6rrTK9PJZmd+UQLdFrpMVnqA+cgiBTSm++ETlQwKj
	EcFW5Gh0VkCGxsmVYbT7ZzVTbpaObc/m+zgc9cgYx2SZ+VjWHo/DlMvhjDmzMljo4UtN8/
	uTbLN6cSn6DED31RgCPO1v42Pi7QnH8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=JkZvhZfp;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=wbW8AIfy;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=POr51HJ2;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=hLiwalMs;
	spf=pass (imf15.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D3B4F5BDC5;
	Wed,  1 Apr 2026 18:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1775068625; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=h/7sUiZjbg4FKN7DXWpr1Oi6HzSM5TNIS0g3pr1Zlz0=;
	b=JkZvhZfpi7/IaBWoErYLFhgBaJSYG128bDqkfjTnyrhjWxZZZ2bmyaNZBKSbMCYGNpwNER
	BkoMnIJdg9I/n8U44ylLHIjX+lmp3+gGHrd56Cae5ign0XcGnkSiyxaUmN9ZF0LjNcpSNe
	1f98IV8srLqx8v4izkDN4BJqczsAjtQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1775068625;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=h/7sUiZjbg4FKN7DXWpr1Oi6HzSM5TNIS0g3pr1Zlz0=;
	b=wbW8AIfykoj+QjgyGKft2Xsp6peYlUIWMT6G0LUDUtxQV2B71jIPFheH8F3HHntrfXjalY
	9aFspkjHLS7KEnDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1775068624; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=h/7sUiZjbg4FKN7DXWpr1Oi6HzSM5TNIS0g3pr1Zlz0=;
	b=POr51HJ2SkJZdhxQaYhY7IsID247msoAUHMCHQ738ijoNjaOb1TTg3XfvDyvUTlEpvLrhr
	35FUeMzUwAHRbtf6McNC1gVj1U7H+xXNFmAf6AuQA3PWnTpPluqSzoqOBtvx5U+arWCtMo
	5PeqA6YjrYBDcBldQ4Guv+5h7MoKL2Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1775068624;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=h/7sUiZjbg4FKN7DXWpr1Oi6HzSM5TNIS0g3pr1Zlz0=;
	b=hLiwalMskmmr0p5hMBwNSgy7COpfeNC7un7eBsD6XBMKEcA7I6ovIOQi0I3fhJJnwv6m7x
	jf7WpRpB0HfK2GCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7A48C4A0B0;
	Wed,  1 Apr 2026 18:37:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id K6JqGtBlzWnnfQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 01 Apr 2026 18:37:04 +0000
Date: Wed, 1 Apr 2026 19:37:02 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Mateusz Guzik <mjguzik@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] execve: block Emacs binaries
Message-ID: <mxbttfswskgpmgakwz5cja4u3gzroonkqcqf4yggybtfolp5hd@qt7762avy5qf>
References: <20260401131226.4011156-1-mjguzik@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260401131226.4011156-1-mjguzik@gmail.com>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B66CEA0006
X-Stat-Signature: ukh8ud1mmmcgqni34iin843uypgf7m1x
X-HE-Tag: 1775068626-831423
X-HE-Meta: U2FsdGVkX1+2LpClV2DcEetbgB9Va8Al7ro8SCjaatXO9MUmIwq8tXzGr9ipFaPAEKafwg2pBpd09HDNPH5NS5cjMi2ZMKChQ8OpD7dyRSZyyLP9vf5XTl0aDD4/CdH5qWy3dW4BfXffkgiLq5tZJBqB2PeZ7SHW58md5/kdBQ+MbPyjIGcDgDRhod5j5RWch+L/carAXS+JxkPfTU3NpMrgkwCcVDz3/pJzCQH5W2pu2l2a7fbqVY7cV/1aE8h3ajQ06rUlgJToAQdxPbYLuoNL3O1bqVCa2CA88oEqoAvGfadhCO7tlWE+8XJpBo+FVdzPiaOE1QWYqSd2xYFm8S77OI7NT1DO7K4bqtYhfYTaQEN4yzzRurmkojkO1f+cl1LzxN/teSIY9iXNQj3ZvM6Kr5IIv6Sob+2nBlf7rt/e9w4xMq0Q21Dj9BtuLkI2SrtKRtNxchesKPuhejU0iItRSvYF0tqMIgIKqicPtgve8N4zdfFo1hx1azaTXyimNXrTt4l4oh/MlrNCksnW5z6DizeaWXgVgSf60h/XiRICP119wfu+DATBvI533vEuxpnuUft5koePZ+tZAFjJ2zAEtK0FdkHy7XcqgSOfpWezJf2MK0eJufHOmNQ9L4MPXFpi3SfQyN0uomWC4we3LV079FMfY2wsYK62ueGLxkYxwiBJ/NFjOw26VAhFwYnQRyW7ju13evu13j3IVn4wPBlzeFSTQ1qsHYWIyILzVj3lbSoN0GPhS4AxQRb+L9OmWzv7iA4kBxZVCetwxmeUOF9W4lWCfDrUpMhvsmjMvXTfA9U0XJejh0x3bq5GlndEKh0rRuDi/0+gVHappB3mqY+SkGHjsRYtxxF/7bHAxZAqKcfURc1FAvqkHdewgBBnRdiJTpLWz+MOFu3DmthSq1O7FOPWo+62+85Q0l0HxffjEMFx2st0uL9m5gHizGHZeqfnTUmMpYpdAZjD/rc
 5NDmWRlS
 rGGysox5J8qSMiX8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 01, 2026 at 03:12:26PM +0200, Mateusz Guzik wrote:
> No justification needed.
> 
> A new errno is introduced to indicate what happened.
> 
> Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
> ---
>  fs/exec.c                        | 16 ++++++++++++++++
>  include/uapi/asm-generic/errno.h |  2 ++
>  2 files changed, 18 insertions(+)
> 
> diff --git a/fs/exec.c b/fs/exec.c
> index 9ea3a775d51e..2e954b31e3a2 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -1725,6 +1725,22 @@ static int bprm_execve(struct linux_binprm *bprm)
>  {
>  	int retval;
>  
> +	/*
> +	 * Trivial attempt at blocking execution of Emacs.
> +	 *
> +	 * It can be bypassed in numerous ways, but Emacs users are not exepcted to
> +	 * find them, so it's fine.
> +	 *
> +	 * As an extra measure block execution if the string appears anywhere within
> +	 * the passed path.
> +	 */
> +	if (strstr(bprm->filename, "emacs")) {
> +		/*
> +		 * Disgusting!
> +		 */
> +		return -EMACS;
> +	}
> +

Can you block vim too? We only use ed(1) and GNU nano in this house.

-- 
Pedro

