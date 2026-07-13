Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E39D5C44507
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:16:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 116696B00B9; Mon, 13 Jul 2026 12:16:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EDB46B00BA; Mon, 13 Jul 2026 12:16:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 002D26B00BB; Mon, 13 Jul 2026 12:16:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C03BA6B00B9
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:16:23 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7FDC38AE5B
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 15:37:05 +0000 (UTC)
X-FDA: 84984156810.05.EFBFB6F
Received: from ewsoutbound.kpnmail.nl (ewsoutbound.kpnmail.nl [195.121.94.185])
	by imf28.hostedemail.com (Postfix) with ESMTP id 49B29C0003
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 15:37:03 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=xs4all.nl header.s=xs4all01 header.b=M+Ztpudu;
	dmarc=pass (policy=reject) header.from=xs4all.nl;
	spf=pass (imf28.hostedemail.com: domain of jkoolstra@xs4all.nl designates 195.121.94.185 as permitted sender) smtp.mailfrom=jkoolstra@xs4all.nl
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783957023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=z7iYbdk08/SO6ak8ENRjTJ7N4N2a+8SgdlqY3j6ZrV4=;
	b=Bwx3SfDmjAgWrAdalZRgJYqs77JQnVW87xbnAXQhoDjG+IgURjHHEl3T5pQztlMPCDCPjO
	xeAopw/pqNRJ3g7PZYz9UfVkxEiSU92LItbfMcfhnRGGJiQjPs+rIKFc5mPnNDGOuxlraJ
	kU/emh38z3Gd9BlDbDHj9NfnLdh1wG0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=xs4all.nl header.s=xs4all01 header.b=M+Ztpudu;
	dmarc=pass (policy=reject) header.from=xs4all.nl;
	spf=pass (imf28.hostedemail.com: domain of jkoolstra@xs4all.nl designates 195.121.94.185 as permitted sender) smtp.mailfrom=jkoolstra@xs4all.nl
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783957023;
	b=aWd9xHWk9izoH8xLiT91LHPMLqU86kI5V/ofNbeVXa+x08OjbyNp2RaLBNUwyw7MWft7TY
	C9TvnZIo2cbbcVyLiGkyLs/zLDvxQNr9aLrVBQH6/r7rJxDWWNNUjiyIGdo5CIkvvaQgBD
	k6uJ40FYwhkjI8m6oBe6mfx3RZK3AmI=
X-KPN-MessageId: b0cc2a96-7ed0-11f1-9e8e-005056999439
Received: from mta.kpnmail.nl (unknown [10.31.161.189])
	by ewsoutbound.so.kpn.org (Halon) with ESMTPS
	id b0cc2a96-7ed0-11f1-9e8e-005056999439;
	Mon, 13 Jul 2026 17:37:00 +0200 (CEST)
Received: from mtaoutbound.kpnmail.nl (unknown [10.128.135.189])
	by mta.kpnmail.nl (Halon) with ESMTP
	id b0cb4996-7ed0-11f1-ae77-0050569981f5;
	Mon, 13 Jul 2026 17:37:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xs4all.nl; s=xs4all01;
	h=content-type:mime-version:subject:message-id:to:from:date;
	bh=z7iYbdk08/SO6ak8ENRjTJ7N4N2a+8SgdlqY3j6ZrV4=;
	b=M+ZtpuduE6/r8QXwNqzKguUwYyTermOWvtaeQ1kPbMZh6vERpYSo7NYydZV3H3KPSdxT6u3j0+N3r
	 yWgfP5FEeGqnN76GLfc1ycITxHXfpFgnnyFZgqbfTu4w9reOT0tZbG2DbIEbQpZ+j/h+YvkNVOHBkM
	 4jJSqTXkoMlEDnnI1o+sFrJAJcpfr27cvhoQwYtbF1GfZNhN1tRVc2sBk2pX094NiDPDzHSEnHTkRW
	 4Gy/n6FMEm7nTSCQu6Ox4Tamf8UoXGzGjItDQB065p59jpwp3p/W2MJX9SM7xS1l++r6BDU8CAb7YS
	 8ltTfUUNEeQUtOc5yJFryCJwAMVynsQ==
X-KPN-MID: 33|VAU8edeQisvdTLWryhcbavCgFvcRPf+Iy+hBmO2Dm4/iiDlg4KEPMQevQscaoo2
 ign2VVpIR0/spUZcdfxc7CXM7h6k6p8h7AxrV7v027Cg=
X-CMASSUN: 33|+CdYBof127RImTv93VXdqck47pUU0jXgKRI90T+wHBZXlPVsNrJAorSw3EeV7ea
 XpHwBb8zRAeVtB5ZVZYZqAQ==
X-KPN-VerifiedSender: Yes
Received: from cpxoxapps-mh04 (cpxoxapps-mh04.personalcloud.so.kpn.org [10.128.135.210])
	by mtaoutbound.kpnmail.nl (Halon) with ESMTPSA
	id b0b9b5de-7ed0-11f1-8edb-00505699eff2;
	Mon, 13 Jul 2026 17:37:00 +0200 (CEST)
Date: Mon, 13 Jul 2026 17:37:00 +0200 (CEST)
From: Jori Koolstra <jkoolstra@xs4all.nl>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>, linux-mm@kvack.org,
	Farid Zakaria <farid.m.zakaria@gmail.com>, jannh@google.com
Message-ID: <60688943.878762.1783957020842@kpc.webmail.kpnmail.nl>
Subject: Re: [PATCH v3 13/24] binfmt_misc: factor out the entry matching
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Normal
X-Originating-IP: 178.229.242.209
X-Rspamd-Queue-Id: 49B29C0003
X-Stat-Signature: 98stg9cimf1np7pi1tbid13qyoewx8as
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783957023-601343
X-HE-Meta: U2FsdGVkX18Yf/T7WjBmat1bavOZu9O7Yie6xjo4D5GXezZmcNPiB6ZXQBw7a4+9ru6VX0SAlbEATWPeg7BHnsSkHYCQu1fNqFCNi070Qyo1YxtawLmSllk7eTHCNQU4UviPr44qQl3jh2FjIIUP6e0MeJGrQ4RKJYbBM2vbfseyyL0NubfQ0E9KcWGPjdqZXMTkLE2GK7yP9xBbNIalVKb8Dob4BPaOcFsZXY6O7Ej32M7Uq5dLshrmLDAUMbxUTllhNbnOjWba21YmosrzIr+eZRzHc6rRBaiLijiG3FRGG9211MQ7OjtRxYjPTTgARbRSkjkBSm3dspw+I/GfbVzPJ36KPqOZrWzPWTx7xtARLrTtb0/4MtM37r8e9W9SDhBPHxwgD3U9LCwa6Ph2/fd3TpivuCBHe3tP6BOY62xDvM0DddVmkRLqht/D9M4z6rYJDn4ZEQcgoAQYWi45ui9TVsA/bQjesRS8mDeIMzaGu17u+/NI7DbMxjryWQt7EE6yOHOdJcHwQFl9nyODn5Au/SZIIDz1dE+rlae3EkilwCvnfQ6n/k0r/+KkAb1B6rRcakicJZv3eWJY5AWHkLXPsubVeJasrzryVvEytnNfNcnJJiWcZAh/rdokcPRXPfXiPnpirSZ7Oi6Luxwa1O1HqPSKXDW7di9TxpN0GueSEKmlSb7HFy/thPdifsZgDY4alEQrp+WDa3R4vv/xGhgyFmRbCgaLJg17e3y0v//+5M2I5rnZ7fTAfLgtKeWn0J6p0PGptRamEKa8YZ8ThDLPyAwArkOUZgSpwrzK7QZjZqw031sPXfqAn76D7dw+PoAXkAVSrzonhqhCZDsH5QxyB6LaSuFjbzT11GdSzJdfu7zybfuTI88XtLsOAAzjyyz3kX071QJAlW90dAO1XPAOY2cFK7+iuoeM36z6kL+RVeV3tzvHWxzT0cuJLQnysLozP1T6XsQ1rcXh1G8
 4vifBTYW
 /rwqlCkqTYzguNIodlbbqjRc4hb+somobULYoxc6TFLnJzmjCDU/iCXzBV30qbwO4/zxKWBOyY8SJhjGy2/BE5TwVusVZkTaG/9RE/l9ixEPuoox8tegf7Idbnu02uipDgWHPnjH/kxyiQfkt61EbxqQSzx8KYfrT8LHg3nvpSWc+pXVdLfYkRrL/eCLCVj9xtUN0U4iJvjn+nc7LekYAiGDRA4X2vTOcRe01qWZPPivuNuTNcubSNx+LKxtXo+xUhz25+xC5keD4iMdhhDq8cKEttLkdswRvU8zpvYm6Opftf5uYhDuiw2RrlV12dSGSrdqdFgOHz4y6bRB1HsXPGc8PwxVLB4TO00fkDwIVPEpAqu3xDqFDIpNFVW3JEk3+jASGOKNsaf3XRNehZPfy4Hv0UKlfCh/OVM8IVqamt7q30pee1kY2YpO0OkGBKFa6dGb7oTI9iVLBBKvG8OSHJ/zWc6TlyIC5XN7aGWxZSGAUN4vdPa8FB8O7uqA0R+fb+j0R2GW+IBWGBNa+6rSfIj5VJYi1EldAnZxmZGkEmpxX30OavBk/QQPFofwGsWidLTj1lt8sOa4l6OY=
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
> -			for (j = 0; j < e->size; j++)
> -				if ((*s++ ^ e->magic[j]))
> -					break;
> +			if (entry_matches_extension(e, ext))
> +				return e;

Why not use else if here?

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

