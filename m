Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF404C531C9
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 15:47:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B75F6B007B; Sat, 25 Jul 2026 11:47:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 468476B0088; Sat, 25 Jul 2026 11:47:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 357756B008A; Sat, 25 Jul 2026 11:47:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0E7736B007B
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 11:47:38 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 75FE2160364
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 15:47:37 +0000 (UTC)
X-FDA: 85027728954.17.33DD7CE
Received: from ewsoutbound.kpnmail.nl (ewsoutbound.kpnmail.nl [195.121.94.186])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7A55740005
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 15:47:35 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=xs4all.nl header.s=xs4all01 header.b=mJpQKmFZ;
	spf=pass (imf17.hostedemail.com: domain of jkoolstra@xs4all.nl designates 195.121.94.186 as permitted sender) smtp.mailfrom=jkoolstra@xs4all.nl;
	dmarc=pass (policy=reject) header.from=xs4all.nl
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784994455;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i4ydykD6V+3+U4iaRPvJmsbyjlTfOIKGt9umZ72t3cQ=;
	b=Ks2SovSAwd73zjcRTG7kDv0orOqgfjE+lBW9mftmvIcT3oSo126ZIdIjJs4hQ4RNDgMYTD
	rw+04SW8OqXf6Q8XA14DGM18OWDFC1wicf5Gga/ldNmF2q2caAUapdosQvzZotie+/Yy2o
	NrLOHS0CiSaR+8nQjrguwUrtdIDcIrY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=xs4all.nl header.s=xs4all01 header.b=mJpQKmFZ;
	spf=pass (imf17.hostedemail.com: domain of jkoolstra@xs4all.nl designates 195.121.94.186 as permitted sender) smtp.mailfrom=jkoolstra@xs4all.nl;
	dmarc=pass (policy=reject) header.from=xs4all.nl
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784994455;
	b=fussS+J7zKUhA1RWilaAnDRSwWt/R+IIfx0L4J711AkUxTwMvZzVoLwHViNui7R8WstlEj
	5bOadHGjvAD180LBx89KYzdmC77H8+fYOyPRhEkrUTfkfJes5wWk70crl6KifSCjhr9mBU
	UQKNk3xotXOxCDYibghfre+Szw7WGQY=
X-KPN-MessageId: 26a289c7-8840-11f1-bfba-00505699b430
Received: from smtp.kpnmail.nl (unknown [10.31.155.8])
	by ewsoutbound.so.kpn.org (Halon) with ESMTPS
	id 26a289c7-8840-11f1-bfba-00505699b430;
	Sat, 25 Jul 2026 17:47:33 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xs4all.nl; s=xs4all01;
	h=content-type:mime-version:message-id:subject:to:from:date;
	bh=i4ydykD6V+3+U4iaRPvJmsbyjlTfOIKGt9umZ72t3cQ=;
	b=mJpQKmFZAMRKbLAqTfaDawchrajSvnu6WshknpPbJx3u9g8W6pUWc5ZCMIXtgsynH5lgv+thT4YlM
	 01b5FO1itECWvqQDuT3BxZKd1NxZMeruy/vI7bHXERWqzM9dtykNH8BCf2TTenanKMm9gl/qppkqZb
	 n40aE4hyAaPERWFfl1j3BbhXPiLC5/Ei0tolhlzQyUKry70C06A2MziTkZTf/L+fi+VOJP6FwhrQ7S
	 oqYqCoEFMbNokqN0f/lU7eywNHhbp0Z8l1sYmyF4K3NUGjFs4ldUYE/R5ZL9YezDo1YbTLwhzlQWy+
	 /ApopiHYmO5T5w8fp2sght1epDhu0tA==
X-KPN-MID: 33|tCBIjNA60F/5wc+E0+19sYESqAheNmiYOAAIOBuKehyf/z+1W+snzwYjalhfEyq
 LjGhY4A72LU2yK49ee7z4MDMzbYUxkmot2cQXU1BhZtE=
X-KPN-VerifiedSender: Yes
X-CMASSUN: 33|3H7GIxBg0dGGV3/VDwgCdP5MA4WVS/TjBwGOALBiyI3OiBf4Q+PGPe5bNJ0EEMI
 rLOfo8lFQCDII1ogOFEgvFg==
X-Originating-IP: 85.144.169.142
Received: from localhost (142-169-144-85.ftth.glasoperator.nl [85.144.169.142])
	by smtp.xs4all.nl (Halon) with ESMTPSA
	id 26687a12-8840-11f1-8dd2-00505699d6e5;
	Sat, 25 Jul 2026 17:47:33 +0200 (CEST)
Date: Sat, 25 Jul 2026 17:47:31 +0200
From: Jori Koolstra <jkoolstra@xs4all.nl>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, linux-mm@kvack.org, 
	Farid Zakaria <farid.m.zakaria@gmail.com>, jannh@google.com
Subject: Re: [PATCH v3 13/24] binfmt_misc: factor out the entry matching
Message-ID: <amTZesOS4C5kwrIe@lt-jori.localdomain>
References: <20260710-work-binfmt_misc-locking-v3-0-a162f7cb58d6@kernel.org>
 <20260710-work-binfmt_misc-locking-v3-13-a162f7cb58d6@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710-work-binfmt_misc-locking-v3-13-a162f7cb58d6@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7A55740005
X-Stat-Signature: 3keow17n54n68njpaiaf6nuaf6turb1a
X-HE-Tag: 1784994455-485695
X-HE-Meta: U2FsdGVkX196qfbnUKvoj2U8blOwaMauWMZ3cdm1fKbBVzyVkPUZf0QSuDwnueT57St/o9nOEynztOnUUFQl2STCnK1Sbcfa8J3/EPIIUBHyQKm+FbJU3a4mRG6t9db1u8VqLMq8/NYI1Sx4/FFSPTuxJx8S67Ea9EAV/mau5FkZqGyQVhCjRkEhGXjhycqlvVCIcqw5ENN+o6KqjhnSZAsbWTcpPxfY6c8Jrjx9nLgdoTofhGCbju6cse9ncvLvaqT7IWKR1bAcLQajXJq+XycJpLvtcewKv+NI4zFdWm8hj5PCmD3a5MnuW/P9Q5v/rx+GmgJmInfpBF3uPC+xohrbnqimvaD6vMhJ/8oxAC0GCCqkubOzJToaN+skGPSGic14LJbE+x2v2G7eGNQ9hwHUBvlWcSrZ91/yCn37+/vdoEsTVknQwqmf7Xhx9TOQ02U7xhkh9PRso4OPjRL4KL9+7DfF90h/6dpZuVS5yjinvA7Z5mHiU+YtRiMFA7254RAazwGZriN1KKRa3P5Gq6PuB9PfgxCcTBne0+dN0mEr9zmwIP69skzYuMmXuAiKnJUVT8BJgEk2rQdPFEeiGsw0osWsx1JDXxQBe8We48lneikm+1H4mEhQE7fBf7+3SLQ8lZW/Sbiv30qtxyntaNGmy8GYYF8wTH23Zve+K+VmVKsA0WC5SS8lkUchuOjedMg0U1OJhFiip4ke6aICAeMamCeOKJypAD8eeH4mB06JNk7z+JYBtCM50VQAvylEtyzNnogYVYXcVoke9FEFSfefPo1xfzYTNdjw48Qj1gPG3qd61rtCA+rKTe6Z9nLyP0Pq5COXuI11+5J0mRMm8xeu84fh/f4r8AlFKQ1gV/mtHSti26rUot7JQxYnkQ2eMYDwYry+0g549j3QQlHVNzzQmsLN0b3dkZFMYRfRo0SF5NUWpP+hGNcNeDEYJB8JedpBW0iwN9iWpH9oqmc
 lSlIJRUE
 cERsUL8IXWvhNX54gjIi6vRbtm/hKJC1XiMtmaWqc6HHEk6oGgLP7N3sMAgQJqHn2feRFwJG+kPul/10WvxCFsae9UaQHgHa7MU2XYucZ84+MaQPuGIZfSf8w1RrDot453/WY/dsmlsCgpp/dL8jlCpVo+tFoVUf3P83FCwykPw0rIBbKYUTIcSd0BkZBZa5zOO2H8Gu/RVVcy/KDgiNiXez2YY8eJhTLrxcuwgoJvtQF0RzyRlL6SPCbIIz5mzSYT6VzZZJSC5ErvzZ1ztWkrFNlLabAWm0z72xl/HtW42A28X9xO3kRQEea8wEPQ95HsQ7hX0K9BG7K8GQ5AjNrD/iBC2SqxeZxuCrqIRjWQ4CJ10uQtneZrk5uUbe05aYSbii3uroKcveIxv0gZIA7vmvV1qj7QqWd/iw1RsiUkX4HAXbGs5shiXVPcK+LuN2cz3Nttmi+7LrHpMYbyPPerdxWst5yVvyA+QpoXE9TTUMhg5JadCOhLLoLPy+x3nIpQsULKtCqNXJRs0raDy7t2OIBvszV0Ny7wIvToj4sxRUsnyWLt2G0NGZxbA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 11:33:14AM +0200, Christian Brauner wrote:
> search_binfmt_handler() open-codes both match types in one loop body
> with the maskless magic comparison spelled as a manual xor loop that
> is just memcmp() in disguise. Move the extension and magic checks
> into helpers so the walk reads as policy - skip disabled entries,
> match by entry type - and the maskless case actually uses memcmp().
> 
> No functional change.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
>  fs/binfmt_misc.c | 50 +++++++++++++++++++++++++++++---------------------
>  1 file changed, 29 insertions(+), 21 deletions(-)
> 
> diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
> index 23a2020d9266..6a56f40f23ae 100644
> --- a/fs/binfmt_misc.c
> +++ b/fs/binfmt_misc.c
> @@ -78,6 +78,29 @@ static struct file_system_type bm_fs_type;
>   */
>  #define MAX_REGISTER_LENGTH 1920
>  
> +/* Check if @e's magic matches @bprm's buffer, applying the mask if set. */
> +static bool entry_matches_magic(const struct binfmt_misc_entry *e,
> +				const struct linux_binprm *bprm)
> +{
> +	const char *s = bprm->buf + e->offset;
> +	int i;
> +
> +	if (!e->mask)
> +		return !memcmp(s, e->magic, e->size);
> +
> +	for (i = 0; i < e->size; i++)
> +		if ((s[i] ^ e->magic[i]) & e->mask[i])
> +			return false;

I guess there is no helper to do this word-based?

> +	return true;
> +}
> +
> +/* Check if @e's registered extension matches @ext, NULL if there is none. */
> +static bool entry_matches_extension(const struct binfmt_misc_entry *e,
> +				    const char *ext)
> +{
> +	return ext && !strcmp(e->magic, ext);
> +}
> +
>  /**
>   * search_binfmt_handler - search for a binary handler for @bprm
>   * @misc: handle to binfmt_misc instance
> @@ -93,38 +116,23 @@ static struct file_system_type bm_fs_type;
>  static struct binfmt_misc_entry *
>  search_binfmt_handler(struct binfmt_misc *misc, struct linux_binprm *bprm)
>  {
> -	char *p = strrchr(bprm->interp, '.');
> +	char *dot = strrchr(bprm->interp, '.');
> +	const char *ext = dot ? dot + 1 : NULL;
>  	struct binfmt_misc_entry *e;
>  
>  	/* Walk all the registered handlers. */
>  	hlist_for_each_entry_rcu(e, &misc->entries, node) {
> -		char *s;
> -		int j;
> -
>  		/* Make sure this one is currently enabled. */
>  		if (!test_bit(MISC_FMT_ENABLED_BIT, &e->flags))
>  			continue;
>  
> -		/* Do matching based on extension if applicable. */
> -		if (!test_bit(MISC_FMT_MAGIC_BIT, &e->flags)) {
> -			if (p && !strcmp(e->magic, p + 1))
> +		if (test_bit(MISC_FMT_MAGIC_BIT, &e->flags)) {
> +			if (entry_matches_magic(e, bprm))
>  				return e;
> -			continue;
> -		}
> -
> -		/* Do matching based on magic & mask. */
> -		s = bprm->buf + e->offset;
> -		if (e->mask) {
> -			for (j = 0; j < e->size; j++)
> -				if ((*s++ ^ e->magic[j]) & e->mask[j])
> -					break;
>  		} else {

Replace with 

	} else if (entry_matches_extension(e, ext)) {

> -			for (j = 0; j < e->size; j++)
> -				if ((*s++ ^ e->magic[j]))
> -					break;
> +			if (entry_matches_extension(e, ext))



> +				return e;
>  		}
> -		if (j == e->size)
> -			return e;
>  	}
>  
>  	return NULL;
> 
> -- 
> 2.53.0
> 

Nice clean-up.

Reviewed-by: Jori Koolstra <jkoolstra@xs4all.nl>

