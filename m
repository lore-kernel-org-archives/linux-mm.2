Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0643ECA0FE7
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 17:31:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B2218E005D; Mon, 25 Aug 2025 13:31:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38A128E0038; Mon, 25 Aug 2025 13:31:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 251C78E005D; Mon, 25 Aug 2025 13:31:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 125CF8E0038
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 13:31:46 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BB7751A04E8
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 17:31:45 +0000 (UTC)
X-FDA: 83815972170.11.9BD719F
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf05.hostedemail.com (Postfix) with ESMTP id 63597100011
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 17:31:43 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=MXp9PBDy;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=seTj2QGb;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="pwCq/00p";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="FxuoR/Wr";
	spf=pass (imf05.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756143103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YS364hpmOKei7UeRO8j75lxgf+wkRk4zGEk6Bv6bneQ=;
	b=sSs+7x/jht76h3iC2Iiw/aUcXxdMEQf55Ua/LWLt8SKZ0RejLEGsjXlCw2y2YPK9zJhH8a
	8YNMZDoALMLpGAeZeS2eKKfJ5c5RO/3taleSsqI4ekRaxQybP5+xt0qUmbq9kK3oHZGoL/
	LcN6JMftQzU0LTO18yd8CnO8yEXTAvA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=MXp9PBDy;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=seTj2QGb;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="pwCq/00p";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="FxuoR/Wr";
	spf=pass (imf05.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756143103; a=rsa-sha256;
	cv=none;
	b=5/9EV169WoRi4oKNWLY41swp+CiviXAZ6ndCZBcsgEeVYYQkVbOhC/yYDaJ6HknqGZO+/+
	bedUAEooeYdYXXPPUF9DnVoGzln0Wglswp3maJrmU7jyCDR3csjYN/CXEvKXkAUWs7ddSf
	/cYfBW/P5jb0oJ6FGFGxOtFSMjwwBL8=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E07C52128A;
	Mon, 25 Aug 2025 17:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756143102; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=YS364hpmOKei7UeRO8j75lxgf+wkRk4zGEk6Bv6bneQ=;
	b=MXp9PBDyr75xGAq9hjgyXW2uVKoI26/vpXnVx8jiLGF90V8xDlfrU3R6qS5GVdhnQcrf0c
	gF59UDiUrtrOPxbTHKfVaMHQhmZIC4v2rVLKhWid05D/m0ZCSbJ5GsQ2mYtPTx+RRi2/Ve
	8463RfPMFGqcAcr8sp0GcTkRCI5rPsA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756143102;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=YS364hpmOKei7UeRO8j75lxgf+wkRk4zGEk6Bv6bneQ=;
	b=seTj2QGbTgOQAHx1yV4CsaJYc/VFVL8G56yNcZSK1llQnX2A/kNuZG83aV4+/P1ywVfRdt
	iu9uQp5TidnUA5AQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756143101; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=YS364hpmOKei7UeRO8j75lxgf+wkRk4zGEk6Bv6bneQ=;
	b=pwCq/00pFSBmobHGBqVk86CbJ2ZjoUkghmfUaIcPBaevCMm9RZVV8CMeFCEyMgi+RnyHzj
	Ngdozsp/mfDmVzOn9lPmofduTHC9AuKgImaCLF5Y6bGz+mM01Ge/orJh+kwDdLpzOo9PYm
	eM2HQrKAmYP1xCHnRiZdHCi1maqWvJs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756143101;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=YS364hpmOKei7UeRO8j75lxgf+wkRk4zGEk6Bv6bneQ=;
	b=FxuoR/WrBavFqQqrhoJUJk+yx2OK9W0XHQnmJ1WXzBUqFVdhGy9IgPF087cWlE2NywnFtc
	uQWZPOZOozgDITBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C8AF31368F;
	Mon, 25 Aug 2025 17:31:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id pssYMP2drGhjbAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 25 Aug 2025 17:31:41 +0000
Message-ID: <7cfb3108-342b-41b7-b4fe-b01a574dbdf0@suse.cz>
Date: Mon, 25 Aug 2025 19:31:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] mm/slub: Replace sort_r() with sort() for debugfs
 stack trace sorting
Content-Language: en-US
To: Kuan-Wei Chiu <visitorckw@gmail.com>, akpm@linux-foundation.org
Cc: cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev,
 harry.yoo@oracle.com, glittao@gmail.com, jserv@ccns.ncku.edu.tw,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250825013419.240278-1-visitorckw@gmail.com>
 <20250825013419.240278-3-visitorckw@gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20250825013419.240278-3-visitorckw@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Stat-Signature: fd4pijd37c7kmqo9x6tajda4bhry5jur
X-Rspam-User: 
X-Rspamd-Queue-Id: 63597100011
X-Rspamd-Server: rspam05
X-HE-Tag: 1756143103-545078
X-HE-Meta: U2FsdGVkX1/jUVQm6DzrO7gzgZ0X0+nvy2hr1MGqf4IGYiOl75HQuknhdJf0ZtRYCZWv4K2JXqD+X9VLlo+hw91nStL3F1ZS++4g1cE/x4fuizhxJXTq+cKVlxN2aBDgwzeHbm0YRu923xdaEZbz3tBvuAFm/XcThRWO0Mc2Jjupc1MyIrQiJrCI2oUgAU8wQ3/Or9OtgJD6UTMOl1kWlwCS37cK/dUne7pHZTPIwxL655F9WBm8fqA451hAsreqiXNRuPc0toiaAB7PHJ1+WwJtfnbQuxdIyN6tQawza8r3YKlWv5yIJsWX89U+KfOSAGvDkMNlEL+EJdbUgVBXnV1ehIbXy8P7pyEFaahKZRxq0ka6vmmeZwl5ruzdb8eP3Es8tbvc2ey8TGbjKpvr3zDRja5i0ysPGA0l55ALMpYEsjQF40db760VLYQh6Y+Ot5bBVkVuPv82h/yMIDGHEPN4qd/9PJZWmjZGks4y4qtKjwwUauaJi88sgxGRTmx8M7IBeMhM7O7S9EUMJeNALI5OaU+/qlL88eX3MLpQzMETZzjMp/8QUkogGgMs0jWkoMfBa0gxDb0IzhQkRjCUdacQ//10ZYItQZq20kQtXQ24KGJk+lsyTv7PV8UWwKI1sdo2QK4UaSuLJd67i5cpiJNuoOdmUT572WEnK9steEQqOLUFr7iuOTsjEd5SpfDLNMlJrk2FpENQN9Q2XprTDqG5G1kxF0Fem1hz2BZLpLAXyLMBbXuLgD7X8wD4NVBe/AlilJs+VSxfj9uCqMJoP0Fuzq9X56Y96rYWioahyZdQ4sTHzoZC5oamoJcFeJVTloQcT888Cx3uZEpDpLUd64iv4AzYjo5UAMOXXsfzsgKp1hMZZZmBfUCPFBDuf+5CG9/EsYhhR4RO8I99jyPfG9+CTT8Qs+hgSpApi9LNc8Z7TqwuXIzRemO4XsEsakgoP3cHyzEAnx3g2MR69q2
 ME0FZ8Ir
 NThbwzVQK4JfZNIUxhRBP51Lbn8mFGS2/RQJsSXSF357wwieUAO2LVfHM5LpkvjpEVf8UG8GMhcopiWDyfnXYkEHHyURqVgwRcD+FmnchLX0ZeREJwGH21iilvyA84sqMz6/KZcjOp7j2S6QE3yJoJjWxEvTbzS2u/gft3jY1+Xe5BQU1qrIIvDKqtEXcohDWoDDzdLF9zXpUtraAh8+mEkeMf0uyamRZt7056baqQvAZdMPlw9Ezr/lPacEGO/Rh0ZiBOcwMCUazo4iIy59iFZuRgyPNEqOFcQgVZsQunEjKntqhwKL3uR2rDItNdPS0UUDq+lqY2E3FHJqCyRJclNIbRRYzKvF3GWj/9wNbqYxijag=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/25/25 03:34, Kuan-Wei Chiu wrote:
> The comparison function used to sort stack trace locations in debugfs
> never relied on the third argument. Therefore, sort_r() is unnecessary.
> Switch to sort() with a two-argument comparison function to keep the
> code simple and aligned with the intended usage.
> 
> Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>

LGTM.

> ---
>  mm/slub.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index c91b3744adbc..67b68f132f84 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -7711,7 +7711,7 @@ static void *slab_debugfs_next(struct seq_file *seq, void *v, loff_t *ppos)
>  	return NULL;
>  }
>  
> -static int cmp_loc_by_count(const void *a, const void *b, const void *data)
> +static int cmp_loc_by_count(const void *a, const void *b)
>  {
>  	struct location *loc1 = (struct location *)a;
>  	struct location *loc2 = (struct location *)b;
> @@ -7782,8 +7782,8 @@ static int slab_debug_trace_open(struct inode *inode, struct file *filep)
>  	}
>  
>  	/* Sort locations by count */
> -	sort_r(t->loc, t->count, sizeof(struct location),
> -		cmp_loc_by_count, NULL, NULL);
> +	sort(t->loc, t->count, sizeof(struct location),
> +	     cmp_loc_by_count, NULL);
>  
>  	bitmap_free(obj_map);
>  	return 0;


