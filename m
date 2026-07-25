Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5C0DC531C9
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 16:00:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A28596B007B; Sat, 25 Jul 2026 12:00:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DA576B0088; Sat, 25 Jul 2026 12:00:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CB426B008C; Sat, 25 Jul 2026 12:00:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5FABF6B007B
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 12:00:44 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D80FFA0386
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 16:00:43 +0000 (UTC)
X-FDA: 85027761966.25.B8DF822
Received: from ewsoutbound.kpnmail.nl (ewsoutbound.kpnmail.nl [195.121.94.168])
	by imf14.hostedemail.com (Postfix) with ESMTP id D9DE1100010
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 16:00:41 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=xs4all.nl header.s=xs4all01 header.b=sw7JtyBt;
	spf=pass (imf14.hostedemail.com: domain of jkoolstra@xs4all.nl designates 195.121.94.168 as permitted sender) smtp.mailfrom=jkoolstra@xs4all.nl;
	dmarc=pass (policy=reject) header.from=xs4all.nl
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784995242;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1r7gbXcpVJa0HZz8gczXPlp1j50BEqiZutlLB29cpvs=;
	b=Hs/TMgtpNYFDLqn/Cu0RgDJFtuKWQRfLnvJI+43RSiodhcd336/j8ITINuER+7yqUVxiKX
	W5jdJ6WBCEcAXnGzNA+IWG5Xv39qebNAG+9Ty0aB6E8jrK0pRP9xhaYGcqrRtV+ybxrjkD
	d6ARp/YAbFcmkISvI+j2GtVAhX35odE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784995242;
	b=ru3YAQ6XCCCEmd4pbIq5NPdabWzz9ky8gLhStgf+rp2YBQU41yBaBeE5maRJxSpV3Vl7Jq
	uLifgWdRHUnO/3pLJlWBoDyV0lBfGIyO6OUMgMdWwAekUCgAccjOw+qVzlmEwKAiMlSOVd
	JzxzxvNpKMLEOAit3rSnZkb2nHM8xD0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=xs4all.nl header.s=xs4all01 header.b=sw7JtyBt;
	spf=pass (imf14.hostedemail.com: domain of jkoolstra@xs4all.nl designates 195.121.94.168 as permitted sender) smtp.mailfrom=jkoolstra@xs4all.nl;
	dmarc=pass (policy=reject) header.from=xs4all.nl
X-KPN-MessageId: fbee96d9-8841-11f1-861c-005056aba152
Received: from smtp.kpnmail.nl (unknown [10.31.155.40])
	by ewsoutbound.so.kpn.org (Halon) with ESMTPS
	id fbee96d9-8841-11f1-861c-005056aba152;
	Sat, 25 Jul 2026 18:00:40 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xs4all.nl; s=xs4all01;
	h=content-type:mime-version:message-id:subject:to:from:date;
	bh=1r7gbXcpVJa0HZz8gczXPlp1j50BEqiZutlLB29cpvs=;
	b=sw7JtyBtN3pzednrieRQs7MCDT3glmB+HO/wOeNePJ8tAUUY6WAjavk4amT46uQkifep+LBM099n+
	 iIIRe5JYalGoI34hBhtyh2a45V//dUR9D8S94PNcKn9nT7+7Gfe9eGOnOpBndO6Qy9sn51crTpIPfD
	 UfAkwK0jmWUvFNk63VJSp4dajasse3j8Y8bJoSJMkzBLIN8jwWL0DP6dnTZBjvyQsStIf5/7ZCefrs
	 b3G5yX85soTPBS8QIhJwl5ufSeK2AWKo2/OD8FH2NE/48xaAZaNW20uKNsl4jnGEhgGekG8t77AyvW
	 Vt5iByid0PKV9GYUm7irGJ51xlaGHgg==
X-KPN-MID: 33|hZ+YnX/W8ij3Pd1oMEZnbTEZqiX2M0B0BUBEfz3hvdQQvzWA0km1TAD+M1pSDV3
 aZKvfO5ZDbrCIXD8AZeHv/e3N7ppIyEC6UUgudlx6yEs=
X-KPN-VerifiedSender: Yes
X-CMASSUN: 33|Lb9VjmF+HzgjlP+73I4kfPPlZm7HlxYtboYFtf5Xsf3oFRqwqIExWn8PnTD1BJF
 tM0XSkG/BbpLqNugbsIj3Vw==
X-Originating-IP: 85.144.169.142
Received: from localhost (142-169-144-85.ftth.glasoperator.nl [85.144.169.142])
	by smtp.xs4all.nl (Halon) with ESMTPSA
	id fb8c87e5-8841-11f1-86b1-005056ab7584;
	Sat, 25 Jul 2026 18:00:40 +0200 (CEST)
Date: Sat, 25 Jul 2026 18:00:39 +0200
From: Jori Koolstra <jkoolstra@xs4all.nl>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, linux-mm@kvack.org, 
	Farid Zakaria <farid.m.zakaria@gmail.com>, jannh@google.com
Subject: Re: [PATCH v3 08/24] binfmt_misc: turn the entry behavior flags into
 an enum
Message-ID: <amTdlrXYqNZsDC-C@lt-jori.localdomain>
References: <20260710-work-binfmt_misc-locking-v3-0-a162f7cb58d6@kernel.org>
 <20260710-work-binfmt_misc-locking-v3-8-a162f7cb58d6@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710-work-binfmt_misc-locking-v3-8-a162f7cb58d6@kernel.org>
X-Rspamd-Queue-Id: D9DE1100010
X-Stat-Signature: sqke599gic7ase7zikuq9zof4amtqa3n
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784995241-18076
X-HE-Meta: U2FsdGVkX19OhzNbSmZaA6PvWomAMuQETzxNVJLOb3M49Y43K2fBnJl7ld7RxGyrYN1xL1eKcaWRUTZ6nXQus6LoAo2RLnY3qoQt9LEtArtOX4hanHYotkEYQsdLsvQraQwdcUK42LBeWid0W/CQJ5dzTKAP4N7TxpKblCPi0RTdqkxVUlEpLTwm49h/5Q2EXifau6X6LbfdBM0eDSTwPXr5uUumWN8k1oW8DfFGflm1HF6wa+q0RqiNJwsl6qAu5Br1+BfGFdjpFsTe+1G+kDJugQF6K1TOm01IR6wA9xgTTNyyKCs9XkiiGKJp41p2d1Izi2zsRiMSqpdr8bRA7wOQVEmJT+4PXEjgkZhUe2Ure4sfHXsIFQvhsJp9gsWRuKKOm7VbFgIgDqIfxBJ7xaNGitp1lVtakxWrUBlQnoNcWDnTgo+nL7SdjyoZQM7wQBL31mk1I4EiVhcUfNhbmmXUm64lvHWGtWeS4yTPRIY/jdnT+aYmYhmKdBBtijzlm5/jm/y8UKK60kqlnIy9LQmI1VKNC7D6sNCNTzmih65NS3h2MCgjh92v9pDr2rZ0fhvDzwgqQK9rHdrCrObQnXGtMytFv5/ShqxePO/lEPi58efNf6qSyGr4RSSOj3C3WPAjPU3Ssf+IIe1HYwwOrRbKJboMzH5PffzkJX9xeCvxqvtYPrAGkWHOIF2gsPMPirdV1Sl3QKmvZ9P14j+3nKnpWd4JsapmAJYZbGmskyQJtYZ9vI+REUIDvwIZrGhi2JUrf6K+c0bkz4DOmMBwdYB7FQjJKWK/3aDDPNOONvDRcjw+QJSvJ8R5AUf2/ng8TGT+rX7mHnTPt85g0FonLx2sOOhRvVI+RoRBiqoNTz3ei/+KuInA87leVQAK+/VHkG50v+q60T65bGxHT+x/s6i6eismWUopuO5YTT9i/Lq/FkOTeVpkdtywES8coVTfe6sSpt8XIW7+3Q+YJVm
 srqZczkm
 50mqrQ8SvM2nZGnrT8cXcfARKlP4HMpxoW5tMOs0wr3I+ffwTvKHzTXMM/c4FZE7+RHqG7NQLIVQNNOgUUx7zxbQUwQV5kvmnkI6cz8nZGTU+B50BGJiW1yKeGGTXgnpZKVJQja4cfRhWwNAP792CHIB5uta58F9XSWjjhax3eWT6uMLlzWwh162OLw9LUPgkP4tb9H0TwkgBP0+HWo6/VhjOFQRfonL09SJv2giF+G5ifQV+3T8Y1HytXdizXuK3bHIT48v2XF/bE1ud+I3aFOySnMeYq/1qP1EHpLPY2RtK1wv7FPka4tnpJryUG7x1FKbtzJ6G4B63xZTsaTEj2W3inFQ+8m9rP7uPefqgHNWU5+/qaQxpSbtJTpnoRz3tDTSi8Q7nXyjbWwDeFCwBrpxaBLqMd2gKqMPF384FNsuBIDqymuopG7guU0VyZMSvfLhJRIMn2nGIfT697qFayzaBEEARa7Q9g7TynZ0VGdyNR/9cUPliFJusaq4HJGKuGAKX5s0GT1WakM6W02eqInjPwWOH+0KnCWJ5keZ1Y0AbdcoY1nFrobqgBg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 11:33:09AM +0200, Christian Brauner wrote:
> The MISC_FMT_* behavior flags are macros using unsigned long literals
> while the entry bit numbers right above them are now a proper enum.
> Move the flags into an enum as well so every flags word constant is
> declared in one form and shows up in debuginfo. (1U << N) keeps the
> enumerators within unsigned int range which is well-defined for enum
> constants and the values are unchanged when promoted to the unsigned
> long flags word.
> 
> No functional change.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
>  fs/binfmt_misc.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
> index 90962044d19e..98ad1383ba6b 100644
> --- a/fs/binfmt_misc.c
> +++ b/fs/binfmt_misc.c
> @@ -47,10 +47,14 @@ enum binfmt_misc_entry_bits {
>  	MISC_FMT_ENABLED_BIT	= 0,
>  	MISC_FMT_MAGIC_BIT	= 1,
>  };
> -#define MISC_FMT_PRESERVE_ARGV0 (1UL << 31)
> -#define MISC_FMT_OPEN_BINARY (1UL << 30)
> -#define MISC_FMT_CREDENTIALS (1UL << 29)
> -#define MISC_FMT_OPEN_FILE (1UL << 28)
> +
> +/* Entry behavior flags, fixed at registration time. */
> +enum binfmt_misc_entry_flags {
> +	MISC_FMT_PRESERVE_ARGV0	= (1U << 31),
> +	MISC_FMT_OPEN_BINARY	= (1U << 30),
> +	MISC_FMT_CREDENTIALS	= (1U << 29),
> +	MISC_FMT_OPEN_FILE	= (1U << 28),
> +};
>  
>  typedef struct {
>  	struct hlist_node node;
> 
> -- 
> 2.53.0
> 

Reviewed-by: Jori Koolstra <jkoolstra@xs4all.nl>

