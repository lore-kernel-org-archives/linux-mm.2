Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C904C531C9
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 16:14:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11E0D6B0096; Sat, 25 Jul 2026 12:14:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F6B46B0098; Sat, 25 Jul 2026 12:14:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F29956B0099; Sat, 25 Jul 2026 12:14:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C011F6B0096
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 12:14:55 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 34684A1370
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 16:14:55 +0000 (UTC)
X-FDA: 85027797750.10.58C458B
Received: from ewsoutbound.kpnmail.nl (ewsoutbound.kpnmail.nl [195.121.94.167])
	by imf15.hostedemail.com (Postfix) with ESMTP id 4722FA0006
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 16:14:53 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=xs4all.nl header.s=xs4all01 header.b=b4FfEhmK;
	spf=pass (imf15.hostedemail.com: domain of jkoolstra@xs4all.nl designates 195.121.94.167 as permitted sender) smtp.mailfrom=jkoolstra@xs4all.nl;
	dmarc=pass (policy=reject) header.from=xs4all.nl
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784996093;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tHPJsB50xQmYK+ehVil/6FrHa+/zw3dN6HSI8VBDdlw=;
	b=M+NibKyGILp9hfTpNrxHuLGTgZth47b/rpSsfYGnCI/9OIYtywLAs3hUDxuHwoNC/x+wGA
	4BSdtIZBVrQColB+Wlfx5lUy6/1x00exTSvGSvMYZAAOu7q0p5mpthv+Z4aj4980DYHMDC
	07lzM5S3HXEE1uD03Pz7D1KIiI98xKU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=xs4all.nl header.s=xs4all01 header.b=b4FfEhmK;
	spf=pass (imf15.hostedemail.com: domain of jkoolstra@xs4all.nl designates 195.121.94.167 as permitted sender) smtp.mailfrom=jkoolstra@xs4all.nl;
	dmarc=pass (policy=reject) header.from=xs4all.nl
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784996093;
	b=IhS+Wfe4d1rZ9ox0YYAThmql1OLXS5QJ+3WMAU6iTuR3T3/Dm03a25D6i4+F/kFSH4PMHk
	M/eQSfL+NxeFJ2F0l+8S2pOp9v+Pj02OcMTHeQ2MHxvSDJe45Qo5+4ACGh/Dc763G15wyT
	wMFy44exOF8EyznEiUs6puZCmsAszLA=
X-KPN-MessageId: f6882f08-8843-11f1-b2a8-005056abbe64
Received: from smtp.kpnmail.nl (unknown [10.31.155.37])
	by ewsoutbound.so.kpn.org (Halon) with ESMTPS
	id f6882f08-8843-11f1-b2a8-005056abbe64;
	Sat, 25 Jul 2026 18:14:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xs4all.nl; s=xs4all01;
	h=content-type:mime-version:message-id:subject:to:from:date;
	bh=tHPJsB50xQmYK+ehVil/6FrHa+/zw3dN6HSI8VBDdlw=;
	b=b4FfEhmKXiIWNhve1ZZ8oM/2Z5iP3puVFwu8+zlVmqA/6eGMfwFqDJmQ9tfbCV8R9gSWaWl2gy3dI
	 4ST91thz3oG/7vbq5+30pggB63VRBN9W1FAEeZiVrrgScL5xVdu3daxdTWVHTU3e7LNCILGkxDbcsy
	 ZY470K7DmJI/3pWgFNas7y9M7qV2upYj/OTYGom+FMNzFyf9qASQ4smngrEdpxRiW1V4haYEzlHZ7w
	 JzCAqMagwoLWLv+YoJUzt6hQxtY9oKT/ZOWC47zzAenLa+gOpS3S89ZVYUWhEZHLY9XjTVJXJF9wak
	 wnPlZZpEtoElG6STGL7RrnzUH4lKK/A==
X-KPN-MID: 33|aZQz5wymlE1uLEnDHEJOnBG5lJJr2DnWat8jZk+/ibToRq9QDJOCtkIo3tWYSuT
 8AFflJn+IRBy1ho9dunTh0Yoo5i+idW1zCmDUIN/unTs=
X-KPN-VerifiedSender: Yes
X-CMASSUN: 33|cseRJcjgKnl0i3Nynao5hE0x7To2akzhbTunPGtN5kDjFKLLf7ezQPeYz31ELDW
 RRb6CRb5fttajPyern3h1tw==
X-Originating-IP: 85.144.169.142
Received: from localhost (142-169-144-85.ftth.glasoperator.nl [85.144.169.142])
	by smtp.xs4all.nl (Halon) with ESMTPSA
	id f655308f-8843-11f1-9226-005056ab1411;
	Sat, 25 Jul 2026 18:14:50 +0200 (CEST)
Date: Sat, 25 Jul 2026 18:14:38 +0200
From: Jori Koolstra <jkoolstra@xs4all.nl>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, linux-mm@kvack.org, 
	Farid Zakaria <farid.m.zakaria@gmail.com>, jannh@google.com
Subject: Re: [PATCH v3 07/24] binfmt_misc: turn the entry bit numbers into a
 proper enum
Message-ID: <amTelCErRS0gVXvR@lt-jori.localdomain>
References: <20260710-work-binfmt_misc-locking-v3-0-a162f7cb58d6@kernel.org>
 <20260710-work-binfmt_misc-locking-v3-7-a162f7cb58d6@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710-work-binfmt_misc-locking-v3-7-a162f7cb58d6@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4722FA0006
X-Stat-Signature: wnhskg4drohw73t8x95fd7rheipat1e6
X-HE-Tag: 1784996093-611016
X-HE-Meta: U2FsdGVkX1+yy6j4xYoh5q47kAvELk2Bx3urqs4FVYAQJO0qQXy1lDEhj0vIhkygW6dyNUCWb8h8IcjCJmy/QoUEtCuw/mzwfzMqfqdf1Aqi5X/f98jVApnndWcXkZXRQG/mqxSVjajK5lmGYavQ3K7kh2miutWJWVFrwg8aGU0wO8SVRQa3q6Sy8avFP1+10faKa26TNpDAZvTH0ZpTMvNJvm0jHIC4YKVX8HWKP7FVKWSLESwvkYfG/ZgtVN7XMwZPkzxMk5uRrbT3M5YIXibCJ3pVuLVoSrkHiDrGuzeUT4C6ej+PHEVTPf1GudOJMZJ3zxyP/aI4sWwlLkH95jn2vpJDZZ4p/080Bhh7WFYX5T/ZAcK/9hyxBtdNtw5fSiipn4LX5hlQYDJqZuueilOMfovd+/VKiL26oIY5c4z3eVEtyXFnFnGBypra1CL5hKMfg9bn3bUHRKDiRcEWiq/v2CMc3ZrNHRxq7r+58K8R9lOqR3ZN21gL8z/K02XUL7dS26uiIYEo6IcFIIghqs0/H9lWVG8G0G9k1QRKDsHRuFwdZRn0Z3EgG/Z9oWsK5WcWxo3pvdeypaIlZW9BMilY/13U/mNemejNGNxPJt/OIVhoBdNecARWgcUA5whnGyDs+xPJAV5EEOXRCL+LjqYOB7k5bpaF52FrlI9Rn2PJdjVtoWivgIY7lRfGV2DvsyCELBVj8I80iAZm6THE/VkWgknrfHw1jY2BBxsZDm3pB3tCPC2U6c8cRjv47v+Czodt+dNdf+kkrtpjNpPDaATLffDz7vq+g/yF5M6SoSMZ/YR7N5y+EjShElZXMxjToIDxqXdbGe8ig0MIkGiIHJo6YF0yrz0NItvn2umXtr4pKXcnkHU94KD58v+zoI2XKqjs3XehI3qm+l6niW97J6fjEwikZ6gVc9LpkYQ6w3StN+GBFGiongWq5LjwnIiwk39fQFANmnbdbhyRBYV
 J8nm2l85
 O0dAntzNR1yCImbGKaeRUTUpODRtzBjl3RsPUUSeAVua//IA6Xj/iBlcXrp/clQVSKLapkfP599wA/6sNUY5kMDG2Ai13DWYBC3TH1Jv2vDostawsMQjKheXLZmj06DwfiKsRdr4wliYrSZYZ3gptHpussV3lWUF2AwySrPxviDWzJA8VfRhj1cFm9FIhi2zMyhfzHqi8d9g2Svn5QZEawBxKChPOsq51ZIzxNjMDaL99S/NsltLI7wK945rOuxa3bezfuwW5TBeBhSnNblfmOhli63wY7QKdk3gss1furCbgd0ZgxS/zK+jun4u5vbTbdpwbzrqYZ+Neu1bkhJDf0G4Cze0jMXiHZZVAaaCIwMxm06LRqtDmpPAe72V9jmJYjG67LDV+lTvVxptKJ8FX8Whu4xoY1i05oMrw5WuSkhghCbMjJqByRR0A+NpbTPs0RAvHOyS5uyxogfoFSsMTMoDr/lHPUodEh9gxjDUY5xvMtdZs8Q13DaOzs8eRb4UaC3BKDAjxucXewqux8CBPNPeBonQXZwkD37iMQOic/yIaxM7AIEvcmCf7lQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 11:33:08AM +0200, Christian Brauner wrote:
> Enabled and Magic are bit numbers in the flags word of an entry but
> are declared as bare, unprefixed enumerators with implicit values in
> a style that predates the git history. Give the enum a name, explicit
> bit numbers and namespaced names and use BIT() instead of open-coding
> the shifts when building the initial flags word in create_entry().
> 
> No functional change.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
>  fs/binfmt_misc.c | 24 ++++++++++++++----------
>  1 file changed, 14 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
> index 0b9758da1f88..90962044d19e 100644
> --- a/fs/binfmt_misc.c
> +++ b/fs/binfmt_misc.c
> @@ -42,7 +42,11 @@ enum {
>  	VERBOSE_STATUS = 1 /* make it zero to save 400 bytes kernel memory */
>  };
>  
> -enum {Enabled, Magic};
> +/* Entry status and match type bit numbers. */
> +enum binfmt_misc_entry_bits {
> +	MISC_FMT_ENABLED_BIT	= 0,
> +	MISC_FMT_MAGIC_BIT	= 1,
> +};
>  #define MISC_FMT_PRESERVE_ARGV0 (1UL << 31)
>  #define MISC_FMT_OPEN_BINARY (1UL << 30)
>  #define MISC_FMT_CREDENTIALS (1UL << 29)
> @@ -104,11 +108,11 @@ static Node *search_binfmt_handler(struct binfmt_misc *misc,
>  		int j;
>  
>  		/* Make sure this one is currently enabled. */
> -		if (!test_bit(Enabled, &e->flags))
> +		if (!test_bit(MISC_FMT_ENABLED_BIT, &e->flags))
>  			continue;
>  
>  		/* Do matching based on extension if applicable. */
> -		if (!test_bit(Magic, &e->flags)) {
> +		if (!test_bit(MISC_FMT_MAGIC_BIT, &e->flags)) {
>  			if (p && !strcmp(e->magic, p + 1))
>  				return e;
>  			continue;
> @@ -417,11 +421,11 @@ static Node *create_entry(const char __user *buffer, size_t count)
>  	switch (*p++) {
>  	case 'E':
>  		pr_debug("register: type: E (extension)\n");
> -		e->flags = 1 << Enabled;
> +		e->flags = BIT(MISC_FMT_ENABLED_BIT);
>  		break;
>  	case 'M':
>  		pr_debug("register: type: M (magic)\n");
> -		e->flags = (1 << Enabled) | (1 << Magic);
> +		e->flags = BIT(MISC_FMT_ENABLED_BIT) | BIT(MISC_FMT_MAGIC_BIT);
>  		break;
>  	default:
>  		goto einval;
> @@ -429,7 +433,7 @@ static Node *create_entry(const char __user *buffer, size_t count)
>  	if (*p++ != del)
>  		goto einval;
>  
> -	if (test_bit(Magic, &e->flags)) {
> +	if (test_bit(MISC_FMT_MAGIC_BIT, &e->flags)) {
>  		/* Handle the 'M' (magic) format. */
>  		char *s;
>  
> @@ -599,7 +603,7 @@ static void entry_status(Node *e, char *page)
>  	char *dp = page;
>  	const char *status = "disabled";
>  
> -	if (test_bit(Enabled, &e->flags))
> +	if (test_bit(MISC_FMT_ENABLED_BIT, &e->flags))
>  		status = "enabled";
>  
>  	if (!VERBOSE_STATUS) {
> @@ -621,7 +625,7 @@ static void entry_status(Node *e, char *page)
>  		*dp++ = 'F';
>  	*dp++ = '\n';
>  
> -	if (!test_bit(Magic, &e->flags)) {
> +	if (!test_bit(MISC_FMT_MAGIC_BIT, &e->flags)) {
>  		sprintf(dp, "extension .%s\n", e->magic);
>  	} else {
>  		dp += sprintf(dp, "offset %i\nmagic ", e->offset);
> @@ -745,11 +749,11 @@ static ssize_t bm_entry_write(struct file *file, const char __user *buffer,
>  	switch (res) {
>  	case 1:
>  		/* Disable this handler. */
> -		clear_bit(Enabled, &e->flags);
> +		clear_bit(MISC_FMT_ENABLED_BIT, &e->flags);
>  		break;
>  	case 2:
>  		/* Enable this handler. */
> -		set_bit(Enabled, &e->flags);
> +		set_bit(MISC_FMT_ENABLED_BIT, &e->flags);
>  		break;
>  	case 3:
>  		/* Delete this handler. */
> 
> -- 
> 2.53.0
> 

Reviewed-by: Jori Koolstra <jkoolstra@xs4all.nl>

