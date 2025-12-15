Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93C5ED5B16E
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 14:30:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 032476B000A; Mon, 15 Dec 2025 09:30:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F251E6B000C; Mon, 15 Dec 2025 09:30:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E14256B0011; Mon, 15 Dec 2025 09:30:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D17836B000A
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 09:30:53 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7C7E8B75F4
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 14:30:53 +0000 (UTC)
X-FDA: 84221941986.28.0F80703
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf07.hostedemail.com (Postfix) with ESMTP id F00D04001E
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 14:30:50 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=j537QsDg;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=HCL1oKHE;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=j537QsDg;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=HCL1oKHE;
	spf=pass (imf07.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765809051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uOjQ326N1+1XAMUcwl6LgXVQlD80kPfn9sCwPFYyM5w=;
	b=hT3idh8pPlQOVa4dN74zl3As4WBZXRhEWT9fAUvLDO3u8qNFOpRjVIMOuMi9IGdJbdbYJx
	dBSC5HgugbT4Ym/AD0gVhR58ZK68Aso0DaNiNLbXWJ1WUj7BoeOABuxh5K8Ao21eB7TnXn
	Fdg4YJCtZ1Q6DSY7cR4zuB7pZmgtkZI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=j537QsDg;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=HCL1oKHE;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=j537QsDg;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=HCL1oKHE;
	spf=pass (imf07.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765809051; a=rsa-sha256;
	cv=none;
	b=EzWKW0Hl+PeH4tV4szUWhdF5uY30jr9uXmqnr2duGoY9MHTF5f+yzDugrnU33Fg1BeINch
	A8ZDTc4eUkNEVaU6EWUM709mJJ/PFY8W3t7tnMsuKLySMlCS62LmT70XXee9zk6QCHGuiH
	qBDGmEXFgW8sIVyE3H/yB3uzrFzI8lA=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3076A5BDC1;
	Mon, 15 Dec 2025 14:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1765809049; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=uOjQ326N1+1XAMUcwl6LgXVQlD80kPfn9sCwPFYyM5w=;
	b=j537QsDg4k9sEYNfeWpz574vSCcbZW/I6BKptvWUuzXmL5lFADsbtf7JnjAFvNM6qVBrCM
	coKNVOSCzZW6TXEFCbJ3JalykPTSyt+V6BeQMPmNW3y/QP7kY7a0LPD+lxc/U0KvxJ98jt
	DGCKDErOBADymFJ0YHo87jjtbUMZjFA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1765809049;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=uOjQ326N1+1XAMUcwl6LgXVQlD80kPfn9sCwPFYyM5w=;
	b=HCL1oKHEOBQa8/63tVGSZAsPl83Vdu5wRMr3aG2jHwtw7uTE80O3AdRnLtGuyeBIOL/Tao
	YAfGfv48KwjYEgAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1765809049; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=uOjQ326N1+1XAMUcwl6LgXVQlD80kPfn9sCwPFYyM5w=;
	b=j537QsDg4k9sEYNfeWpz574vSCcbZW/I6BKptvWUuzXmL5lFADsbtf7JnjAFvNM6qVBrCM
	coKNVOSCzZW6TXEFCbJ3JalykPTSyt+V6BeQMPmNW3y/QP7kY7a0LPD+lxc/U0KvxJ98jt
	DGCKDErOBADymFJ0YHo87jjtbUMZjFA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1765809049;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=uOjQ326N1+1XAMUcwl6LgXVQlD80kPfn9sCwPFYyM5w=;
	b=HCL1oKHEOBQa8/63tVGSZAsPl83Vdu5wRMr3aG2jHwtw7uTE80O3AdRnLtGuyeBIOL/Tao
	YAfGfv48KwjYEgAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 15D7A3EA63;
	Mon, 15 Dec 2025 14:30:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id vOf9BJkbQGkvIwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 15 Dec 2025 14:30:49 +0000
Message-ID: <a231264a-2da5-4468-a276-777fc0241246@suse.cz>
Date: Mon, 15 Dec 2025 15:30:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] slub: keep empty main sheaf as spare in
 __pcs_replace_empty_main()
Content-Language: en-US
To: Hao Li <haolee.swjtu@gmail.com>, akpm@linux-foundation.org,
 harry.yoo@oracle.com, cl@gentwo.org, rientjes@google.com,
 roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20251210002629.34448-1-haoli.tcs@gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20251210002629.34448-1-haoli.tcs@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam02
X-Stat-Signature: 4a6yf5cg6ukzzmp49q3685zhcnsdd38x
X-Rspam-User: 
X-Rspamd-Queue-Id: F00D04001E
X-HE-Tag: 1765809050-368479
X-HE-Meta: U2FsdGVkX1+9Kzw/nOIAKbaf1XqTRDMov5onU7fEEIf0ugnn05MbEI16vs6sm98bLzc18YKvAyCIlrX6jFS4RewljyEKgir2zElnqthyAh9YsNkKgQS/FO3avUWH6IElIaYWxWQtU+tbETru3X4xYVy6iAzDUtysaXOxbjCMpMiU3HgOy1DR45yYodaWaqg3ECmUvwDTMijR0AukSk/5xgdWHwGVv0eRkrTwnWUQv9AcryPhvqiVq1N5osdzixaZnQiZpP7KhnUUW6YyupqnlqGBmFNgRQmpDBtQDvkFW0qjmTyBCsDq1mUjRNsUmFrDnlLYapg15+xNXa0ZJoOoG/+DgjCHlwe5Q7VX18abvHV+J/CNmLBAScTKMOZo6lS3dSoIW95JGQ8DSwwIwzVm0A6Goaf3whoza5RqZcAMhyvLOvV30kQRgMNPnGsGl3xzopdWQHAk0G1YA7qCflJ1gY7PMpTSkuwfDCt2BrdKD3bjiNuRCLkXSohqRqCEbFs6D6M3RpSW/0cOvdGF5cJ5rzLeXrQtG1gk3B4U6gbnNBl9+IbH4aFhuFtYatyaDdCHx8elauybZSes0c1G2pIMbaG1h2VXQQYoo++jLh+gzGb6roDKyv4ZRidhh388ZLY0HfpvQ0GsvKiVEKVuCbLOTy+3iMnXDmjybvUjemdBdC+v/QI4An7OIBbN+5J3HXqI38oYbNoXyrWAs5pLCN/tk6u/qkUC/YQi7fWCUUw4fDVwUyg+elc4jIAHUBeSi2II4YKyEvhn/eJKEKNLW5womXZvyOjvM2sVK/3uWgMlwWUXfr2U8gSE6fpBXo3qJxQNF9TVhSkuMkuXmTadaujLFtM/bT/CdGAzfVgOvWBf/WN2LATspXSLU15Z/ygR4NdGKUR0OAy4XX9EtSwiBZi0J8swB3ATcP8viOQyRleTkTx4o4ZL91ZkMRN7iBK0etA4IitSZq7Cksjt5uxICTc
 gAOiyL65
 qWR/CddHZYclTtzzXwjNN6EY6hlcEun0nkWQqx5V6oc1QjHhq8JI2gW5mB8PdrHE/EuYwUaiQ/ElUEDce3WVmrdfpGsViYutBYireysxxMkGjgLJLQakYwoaCmefvrIfywte0TEhXuIXOwtok8mqagQ8j4WAaplH5CAnpqixPEzauss1ybVViKiSq9FmK1kNSIP68CUAncUeWe+0X5JoYeS4nkjcmYiQ7K+h3wl8wEYGbgXcnS9kmFzDij0h/euBYS+Tatq0yPQ07zQ8CLC4SASlPuHMhifpohImO1UHh3RloOGZxqDqdNbTjYKgXLz4dhPbnMFv1Q3RHlIeFYNNBeaKUBWnjiIMLmpmrEE0V/E31zcCWrw/Uk2iBYxa7ec3ECsQ840bdk3qc/2pQrWPlZV4JybYzdV5Zy/EY/465RqSnits=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/10/25 01:26, Hao Li wrote:
> From: Hao Li <haolee.swjtu@gmail.com>
> 
> When __pcs_replace_empty_main() fails to obtain a full sheaf directly
> from the barn, it may either:
> 
>   - Refill an empty sheaf obtained via barn_get_empty_sheaf(), or
>   - Allocate a brand new full sheaf via alloc_full_sheaf().
> 
> After reacquiring the per-CPU lock, if pcs->main is still empty and
> pcs->spare is NULL, the current code donates the empty main sheaf to
> the barn via barn_put_empty_sheaf() and installs the full sheaf as
> pcs->main, leaving pcs->spare unpopulated.
> 
> Instead, keep the existing empty main sheaf locally as the spare:
> 
>   pcs->spare = pcs->main;
>   pcs->main = full;
> 
> This populates pcs->spare earlier, which can reduce future barn traffic.
> 
> Suggested-by: Vlastimil Babka <vbabka@suse.cz>
> Signed-off-by: Hao Li <haolee.swjtu@gmail.com>
> ---
> 
> The Gmail account(haoli.tcs) I used to send v1 of the patch has been
> restricted from sending emails for unknown reasons, so I'm sending v2
> from this address instead. Thanks.
> 
>  mm/slub.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index a0b905c2a557..a3e73ebb0cc8 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -5077,6 +5077,11 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
>  	 */
>  
>  	if (pcs->main->size == 0) {
> +		if (!pcs->spare) {
> +			pcs->spare = pcs->main;
> +			pcs->main = full;
> +			return pcs;
> +		}
>  		barn_put_empty_sheaf(barn, pcs->main);
>  		pcs->main = full;
>  		return pcs;

Thanks, LGTM. We can make it smaller though. Adding to slab/for-next
adjusted like this:

diff --git a/mm/slub.c b/mm/slub.c
index f21b2f0c6f5a..ad71f01571f0 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5052,7 +5052,11 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
         */
 
        if (pcs->main->size == 0) {
-               barn_put_empty_sheaf(barn, pcs->main);
+               if (!pcs->spare) {
+                       pcs->spare = pcs->main;
+               } else {
+                       barn_put_empty_sheaf(barn, pcs->main);
+               }
                pcs->main = full;
                return pcs;
        }




