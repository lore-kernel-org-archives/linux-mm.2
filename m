Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A885C531D0
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 15:37:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBA166B007B; Sat, 25 Jul 2026 11:37:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6AA66B0088; Sat, 25 Jul 2026 11:37:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B80396B008A; Sat, 25 Jul 2026 11:37:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8A4176B007B
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 11:37:12 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C1A8D40394
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 15:37:11 +0000 (UTC)
X-FDA: 85027702662.25.0F03CD5
Received: from ewsoutbound.kpnmail.nl (ewsoutbound.kpnmail.nl [195.121.94.167])
	by imf31.hostedemail.com (Postfix) with ESMTP id 63B0120006
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 15:37:09 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=xs4all.nl header.s=xs4all01 header.b=Mm3u0sp0;
	spf=pass (imf31.hostedemail.com: domain of jkoolstra@xs4all.nl designates 195.121.94.167 as permitted sender) smtp.mailfrom=jkoolstra@xs4all.nl;
	dmarc=pass (policy=reject) header.from=xs4all.nl
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784993830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kzrm4el2kJ2zOPrLkCzsRanxnWrcZ1Z8oao0kpE8c24=;
	b=bf2QFRhQwxWaKKSAajgAJuRL94PnT7nWi/GzVlg/vGDs+x4Ys/WxOj2iODDCBRz7T4dAAO
	B4uwDY1L10oanr18jLEY37R+WZ5IQSDy8Ygv3lDBfDRFPebqc0goYrEZbe5OcG0RQr70dP
	7NkBgRptzHLLc0blcNDYM3IKTSyNsMw=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=xs4all.nl header.s=xs4all01 header.b=Mm3u0sp0;
	spf=pass (imf31.hostedemail.com: domain of jkoolstra@xs4all.nl designates 195.121.94.167 as permitted sender) smtp.mailfrom=jkoolstra@xs4all.nl;
	dmarc=pass (policy=reject) header.from=xs4all.nl
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784993830;
	b=vWpfeObk3XAAwRQPrgcygi5q/58EuRUe+b/oLWz3sNkZK5Vt+7oqDBFVaH+2VEqVTyvMFU
	yw67IbOsHakAPf7/+URfjJ7OU2cKUAjv9oWP77CGVGRbqc0UBL6YrLAeg85YMRgr9KLXdC
	hyOBG5STyq3LNq3eIr1XXJWVkqSNbBo=
X-KPN-MessageId: b11cde50-883e-11f1-b2a8-005056abbe64
Received: from smtp.kpnmail.nl (unknown [10.31.155.38])
	by ewsoutbound.so.kpn.org (Halon) with ESMTPS
	id b11cde50-883e-11f1-b2a8-005056abbe64;
	Sat, 25 Jul 2026 17:37:06 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xs4all.nl; s=xs4all01;
	h=content-type:mime-version:message-id:subject:to:from:date;
	bh=Kzrm4el2kJ2zOPrLkCzsRanxnWrcZ1Z8oao0kpE8c24=;
	b=Mm3u0sp0ICBTVGxRZdQnqFy09UC5qtFAC2Ca+p1rI/TOZGu8Hw0mk3t47xIb1zA+HGclPt7/ZtNTX
	 nvfpztScDHyunoA90fdGUEMaGbdlviDFQTVEq7SVCc94rvLzAJz392eww9g/tDWfarM8hCzsGzYcIh
	 z6lsyl//uT0DXM20fefpweFTTo0CWTwoqIreriH3gMZPck3SNBIhP+Yl3bKLKmzKxr1ZkiCH7jPbvv
	 UJhDkF+RVHu4pGXdkxEzHMHF4aPgbHXNAsbQVDxJphwW7lsFyZWQq4jNIJxPNA5sX53fuhk6a0kA8b
	 md1g2Lx2kuphafSIDUZhFvKfnOvzirw==
X-KPN-MID: 33|AQDj9gEmkudzdLpa44XQjDKvy+eKWzFMBCJoRQdzzVUguD9I5RY4fdBhZYLixuU
 9+pieLSto7Ys0EqD7woxXV+4UoU4yNIYZqoLSo890TMI=
X-KPN-VerifiedSender: Yes
X-CMASSUN: 33|CYCKKQMDdoRjpRO+ERFKxTy+1TovFz6t48NFminXX/rUyEufmxvmRTb8RSj2/9k
 TjOnchlGRcLNGl7uWQRfssg==
X-Originating-IP: 85.144.169.142
Received: from localhost (142-169-144-85.ftth.glasoperator.nl [85.144.169.142])
	by smtp.xs4all.nl (Halon) with ESMTPSA
	id b0c0eed2-883e-11f1-a998-005056abf0db;
	Sat, 25 Jul 2026 17:37:06 +0200 (CEST)
Date: Sat, 25 Jul 2026 17:37:04 +0200
From: Jori Koolstra <jkoolstra@xs4all.nl>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, linux-mm@kvack.org, 
	Farid Zakaria <farid.m.zakaria@gmail.com>, jannh@google.com, stable@vger.kernel.org
Subject: Re: [PATCH v3 03/24] binfmt_misc: reject a flag character as the
 field delimiter
Message-ID: <amTXwUK2FXu2sHI2@lt-jori.localdomain>
References: <20260710-work-binfmt_misc-locking-v3-0-a162f7cb58d6@kernel.org>
 <20260710-work-binfmt_misc-locking-v3-3-a162f7cb58d6@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710-work-binfmt_misc-locking-v3-3-a162f7cb58d6@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 63B0120006
X-Stat-Signature: 417s3qbbqg86pae91f4xw6s7h3rabqjd
X-HE-Tag: 1784993829-322048
X-HE-Meta: U2FsdGVkX1+euf8p91jN0tPaRnGahq7OY0DPTj9ILQFHxQ/xeSuD/COa+6wzYEQADXNRw1n49XGwSSsLyxbpoWGCnxC5jc5gYF8OskJcWJmICvzZuXyOMbwEpDnAGMj8vRw8jkgzgq7zIVMJjs2ch0oRUJuvNsYXq+whcWMgw9botB7mKFAABzUxnxsjWMH7dWDTzlO0q4QzYBb9+15gsjvk0HcvnJOeLLHoBATId192dIsb53EAbHpTpKMmffqCpvE1tnf08mL1zg7Bpe11aUOuljo8JZVIGjcVYGFP3RuOURPqa9Jf6/6su6XIsM7EbnwA8bQaPo6Gg0uLC8T7E8zuH8PnoFDJ04NOaTWvaUcYvIoCqAwG19j21X1XcnQjx6Y/SyNhQyxuZFVH3xL7ktDqsFPcrC64JSy2s8pZ7lNf3hho1nXD2vLM5c8Crb5r5JlAhTwvOe3eaWEgA5j7OT0Jk8r1iLuFCfPBK8z7IwK6561mBKMQIlp0YQe0/dMDd9e7As2xJcpHa3PF2e1GM6+O9RaHlnuPsvH3XNJ75fcYfnKKYG60LCn7vq97tjneyh1WYqELLoofXt0/yEKrfmp9FXr5H5XLtOAeDDI2HRlrngsJqdcoWG74MOUqY4ui4NjSzckhfWEdnt1xdWhmpCrEWENiolYRgUCPwhJ4j2zoeoWEwlgC3/d0rK9tnBEJbM/vh1LZ++h4Cox+EISFQTRC263rTSUFjBMwo0m1Mwkk6rhKUlB7+yyV8noMDsoyJYbQ5U804eEH3haY2iR7dIZRV5De+60yeLQCSl+qUpwWGtEv3DA/EPdgrkz32E1MQx/ONCk30EfTnGiYZZejaVOtkQA5poVilHI9IB1kKNz3ciMwyBUr0dPk90GlCGuPHXbGSGCDd5Yqwh/2CYyyT9CZJpHUIro2Gd2YusghQ73Hs3rXyCBRnSSqAuyd6kKYEVdmAWfBofQLlfG+JZC
 x/3pHwUp
 WdmYDiAwjrua2zrAdb1+2DUUQIgkBPicsqpeW5jvTdgKKIyfAs/B4D38z0XoLfYQJMR8LFJq8qmvMVMtubjMBbgF+Wca01syzNUE84hNsMjMUcEEyrx6vg6l5vG5Gy6Orr3xTpuDzcev25kfhMpEy4VOroMKjRjSMQSOmYLh+aSBHRbO+so/1C7pDzJTdyIniXk7R5EcPkdBIs/EvLiEjn+8fp8fAjXQ4/clcR4y43lau1zvUdx6FZ2pPMh3G1P4fI6MIYy9/vuIkcywpxEkK/9UhSOIPfegszQR7b9GCwtJ/T4Qe4jpjAoUxFnB9f0qgdNqmW3vsGZZmaic247adDRypw/mG2rkhjLav1lPiuQRFbd6Ftq4hoSrCqeM+S7QL6v8QJHfA2GOjwuuLfUX3/nT9XbRfF/4j4Q2a9KbyAACfdQIxyonGs5jxoEemXTn5osN82JUFjBAzHUho3quNrY2abQlG6A6Q/BlF0saVTSJ8xZHx1RY9ZhFCdqXYehdmUNuFKxglmtBtoPVgBHbeZO8siO0Xuv7IFV7g2Chb5q7NpuJbqwhMLbsBIg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 11:33:04AM +0200, Christian Brauner wrote:
> The registration string starts with a user chosen delimiter that
> separates the individual fields. So that the field parsers terminate
> even on a truncated string create_entry() pads the buffer with that
> same delimiter:
> 
> 	memset(buf + count, del, 8);
> 
> Most fields are scanned for the delimiter with strchr()/scanarg() and
> happily stop on the padding. The flags field is different: instead of
> scanning for the delimiter check_special_flags() consumes the flag
> characters 'P', 'O', 'C' and 'F' and stops at the first byte that is
> none of them, relying on the trailing delimiter to end the scan.
> 
> If the delimiter is itself a flag character the padding no longer acts
> as a terminator. The scan swallows all eight padding bytes and keeps
> reading past the end of the allocation until it hits a byte that is
> not a flag character. For example registering
> 
> 	PaPEPPxPPiP
> 
> with 'P' as the delimiter (name "a", type extension, magic "x",
> interpreter "i", empty flags) leaves the flag scan running off the end
> of the buffer. The registration is rejected in the end because the
> parser does not stop exactly at buf + count, but only after the out of
> bounds read has already happened. With an unlucky allocation layout the
> scan can walk into an unmapped page; under KASAN it is reported as a
> slab out of bounds read. binfmt_misc mounts are available to
> unprivileged users in a user namespace so the read is reachable without
> privileges.
> 
> Reject a delimiter that is one of the flag characters up front. Such a
> registration was always rejected anyway, only after the out of bounds
> read, so no valid registration string changes meaning.


Looks good, I see no user visible changes.

Can't we support a less arcane and impenetrable format, like JSON
or YAML?

Reviewed-by: Jori Koolstra <jkoolstra@xs4all.nl>

> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
>  fs/binfmt_misc.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
> index 24142859658c..b7664d90eb8f 100644
> --- a/fs/binfmt_misc.c
> +++ b/fs/binfmt_misc.c
> @@ -385,6 +385,10 @@ static Node *create_entry(const char __user *buffer, size_t count)
>  
>  	pr_debug("register: delim: %#x {%c}\n", del, del);
>  
> +	/* A flag-char delimiter runs the flag scan off the buffer. */
> +	if (del == 'P' || del == 'O' || del == 'C' || del == 'F')
> +		goto einval;
> +
>  	/* Pad the buffer with the delim to simplify parsing below. */
>  	memset(buf + count, del, 8);
>  
> 
> -- 
> 2.53.0
> 

I am resending these reviews since I had an issue with my email client
and they were not properly attached to the correct thread.

