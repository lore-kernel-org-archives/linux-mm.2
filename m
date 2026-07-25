Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A0D5C531C9
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 15:41:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 806996B008A; Sat, 25 Jul 2026 11:41:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B7776B008C; Sat, 25 Jul 2026 11:41:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CF9A6B0092; Sat, 25 Jul 2026 11:41:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 41AD86B008A
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 11:41:16 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AEE3D1A038C
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 15:41:15 +0000 (UTC)
X-FDA: 85027712910.27.D572742
Received: from ewsoutbound.kpnmail.nl (ewsoutbound.kpnmail.nl [195.121.94.170])
	by imf13.hostedemail.com (Postfix) with ESMTP id 61A1320004
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 15:41:13 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=xs4all.nl header.s=xs4all01 header.b="EIzzS/ba";
	spf=pass (imf13.hostedemail.com: domain of jkoolstra@xs4all.nl designates 195.121.94.170 as permitted sender) smtp.mailfrom=jkoolstra@xs4all.nl;
	dmarc=pass (policy=reject) header.from=xs4all.nl
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784994073;
	b=bnkIbCVv7BHJUYxLVbfJuhmPpZEQzidEWjN5CpvY86ZbpxKc9l0VKXpWag8uS2eOEgpujh
	wVQ8C/uAmvxjbbBANcZ8nY7919+l5HVvZn2K01oaePTt4WHYqmdn/CwBIrCbwAVEEkim8u
	jAkJyESGNbcaKpxo4gL9i/EQ9QV0IsQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=xs4all.nl header.s=xs4all01 header.b="EIzzS/ba";
	spf=pass (imf13.hostedemail.com: domain of jkoolstra@xs4all.nl designates 195.121.94.170 as permitted sender) smtp.mailfrom=jkoolstra@xs4all.nl;
	dmarc=pass (policy=reject) header.from=xs4all.nl
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784994073;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wx81lLP7hXUWJpNdKKWFqKhuIhTVDLNbjdJ9wFEaxLo=;
	b=hsvy2wf6E9zESqiBIqvA4F2/bVqllU2G8jI33Wy7HsrimOmljlUonneDP+1dnA1uiyNVtJ
	D2nvQFNDxJkq3p31jA94D6uTIfXny8hS4WsbROVDXgjmxLUIDmdxQKHGWYb5rNSop6vdAU
	06ia6OipWC3jZEtxpZUx7VL5UWLq6Wg=
X-KPN-MessageId: 42d1a85e-883f-11f1-83b3-005056ab378f
Received: from smtp.kpnmail.nl (unknown [10.31.155.40])
	by ewsoutbound.so.kpn.org (Halon) with ESMTPS
	id 42d1a85e-883f-11f1-83b3-005056ab378f;
	Sat, 25 Jul 2026 17:41:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xs4all.nl; s=xs4all01;
	h=content-type:mime-version:message-id:subject:to:from:date;
	bh=Wx81lLP7hXUWJpNdKKWFqKhuIhTVDLNbjdJ9wFEaxLo=;
	b=EIzzS/baclYUtjbi85CgVcJ5z+eHVCEbguPJgpwcY6++LfzI+siTqga1+hJPWFTkH7ClTsy5C/XEB
	 EgQStG1c25atbX6CDS3kd18ZBVCcNn52a0e0aZyMAxTKnWgd4m1bYW8M5Sc+D1b7t67c9zcU/HV/E8
	 bWIKvqrm1T6DidkCYPYCnSXlx2I+i3uVGq7S8FdQiVUS18/HpalhTcYnwwenYVV7IceeouluGEnbQa
	 Pp+2nQdLkB+vKHKYxKkqjrruls1Fmxovcjz11QxQ+D6DRVX3FHGGKzbPnkFSziMVhyOGq0YEWKCPJ1
	 69HTr84TmvVqwKparVgh/MB6Kno9ZAg==
X-KPN-MID: 33|/G2fYnTMOZHzL+r5C9Db6iGAbSG9KRCSRqjNnjWqdsxzswG9vmrKNvd6tvj/bhm
 K7E85B8/mh9AIIkUJOn5sBitaUnaR5laP9ZRQP+dmvTg=
X-KPN-VerifiedSender: Yes
X-CMASSUN: 33|OssebP6AExbBwggMlszUqMGSp/bjpyczuxoWEXW51He5UrF6ucVvSqnUVaap1OA
 gBGthrxEvHScrvF3L6Vp2sg==
X-Originating-IP: 85.144.169.142
Received: from localhost (142-169-144-85.ftth.glasoperator.nl [85.144.169.142])
	by smtp.xs4all.nl (Halon) with ESMTPSA
	id 429a2b98-883f-11f1-86b1-005056ab7584;
	Sat, 25 Jul 2026 17:41:10 +0200 (CEST)
Date: Sat, 25 Jul 2026 17:41:09 +0200
From: Jori Koolstra <jkoolstra@xs4all.nl>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, linux-mm@kvack.org, 
	Farid Zakaria <farid.m.zakaria@gmail.com>, jannh@google.com
Subject: Re: [PATCH v3 10/24] binfmt_misc: remove the VERBOSE_STATUS toggle
Message-ID: <amTZBngsF-_vbJHi@lt-jori.localdomain>
References: <20260710-work-binfmt_misc-locking-v3-0-a162f7cb58d6@kernel.org>
 <20260710-work-binfmt_misc-locking-v3-10-a162f7cb58d6@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710-work-binfmt_misc-locking-v3-10-a162f7cb58d6@kernel.org>
X-Stat-Signature: tianoo6nm1rjqh77o3by78x5ejfhetsw
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 61A1320004
X-Rspam-User: 
X-HE-Tag: 1784994073-111474
X-HE-Meta: U2FsdGVkX18YWZYutgYkDLKmRElORbIAVKJ0zjQZyFzf7xxoBSi1zLYsotWcgLSBUwzyl5RmH7dfGPx7Ijw5Jx9ZAMYE2iFxNSEASqVz97K9YsWm3KFIuEXAIOhWOJ0klE81zNLLYfEwhX3vyoOs+08NK/4ZgxKEzca69X+oqd4sEY9C8Qd8CYy+ukM/aDYe6CeXdjsDy4LsYqOi5e7G54vmFMQfbLaQyTuuUdzAHmdfwx/2FOn1EB564DPhoxLtWEQaaqwDmytsTWyltWQcHUxRerYM9TJE48053jAJiE8kX2e/COBze0BsSoHixQya5uzTSkKBA0woGQtaxU3OLoJZrBgr6y+RR3xs35iXDZOXOkLIal6sjY2w6/uIfW8YqOgbP0hGF2xFGzwjZ65ziuwdVKqVLQlQRnlbWX1lk8og3zBWxc5VDVztCmtAJtlRNbbiTLgLhoitVGTT3CwBqfYA9YkULKibU30T/0amcKYs6oVnPNo6lVAVp0Un+ulcpFzqiVKRAr1DOTGk3ta+1haaMcgYMZmwhzk59L6BKZY1ku8bw3kf9qyxqp9g7GOdskq8I8Jz+TjMBBD7CoAsazTN7YMskwUAQxuAXYrLYB2DcV8XB3g0xPlzxE7mfGGEk+VwV+pun3y5bQudXfh0xw7hNXABPBoZXNJwgpmXv/oBmaTCekGukc6nqb9aU+K/nf0dbX4saUeCQlAf9uNsoAUt0HiXI+uqVp6mAQUAFN/mwRcG/RJ7k95QgjnKcDBYX8VLgg0pKAlgOX/1fx8BUD28E3pGgpmI6oI6u/bfItV11Guh6eVxC+ggXIAytX7kpL6tbxuF6A7vuIqK+ZV2HkYy7X3jshfM/v8LIB2Wo9P97+jr2HBpaZwFSnGm3eUOxWrzb6ohkuhG2YXYEktZsBgzIpMOYCBzlXHygc5o1mCpBfSVPosgp7cq7vYqkYgstjGuuyZVce21gGV2XEu
 EMy8zPnB
 uwna7+O1noF5GOedJUky93wwJ7iLfoBEs2mpiJXUdFJhb1s/Q4sU/BTiEJ97+BagWmVMb/gJ2ymcjUcxrpDIsPGSNi7rIi67TIxT/Kw91wJlgzgnDSFKn7XeGy/hrlJA7VwpKHXG0dFcyn4g5HGO8XcPTgqbU7Jr8snaGOraEBn2QUR8mjYHrdizZfrvWgGPXz0VVb6xTD2JrOFo1t4vZdzLW5ajF4Fjz2lCXSfExM9j4tDu3T7dGfORJ3NZhKgYddk8mLDs/R7QdDWiddW2uCvsxIqXnV5PT6P1simOfHCZprpAaS4/2BpTXWJpmgRaKYHD4uwWjdn4PuFsQgNyGSTsXM3dvH55JjztHdrRO2eJ33Rak0qYZ0XBwQSIj1vEfYA4VDep/UY6biPXtkiBYPTH+i5Xoy49onVV44Rdc4qDB02D2lZEAqlMZbyU/C5BvhC9C32Jm5ceOo81dFG3nUNKI1X3frlnrKEj1mABqJxd1qMJjY2SIxaHTJeQHvSOuV7A8eFaljtePgfOMfrH4UE0rawGH+U3uo9W3SnMc1h9zayX0vPND6eyG6g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 11:33:11AM +0200, Christian Brauner wrote:
> VERBOSE_STATUS is a compile-time constant that has been fixed to 1
> for as long as git history reaches. Turning it off requires editing
> the source and yields entry files that only ever report
> "enabled"/"disabled", a format nothing has ever seen in the wild.
> Remove the pretend knob and the dead branch it guards.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
>  fs/binfmt_misc.c | 9 ---------
>  1 file changed, 9 deletions(-)
> 
> diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
> index 9be57f387524..96f9ac752511 100644
> --- a/fs/binfmt_misc.c
> +++ b/fs/binfmt_misc.c
> @@ -38,10 +38,6 @@
>  # define USE_DEBUG 0
>  #endif
>  
> -enum {
> -	VERBOSE_STATUS = 1 /* make it zero to save 400 bytes kernel memory */
> -};
> -
>  /* Entry status and match type bit numbers. */
>  enum binfmt_misc_entry_bits {
>  	MISC_FMT_ENABLED_BIT	= 0,
> @@ -611,11 +607,6 @@ static void entry_status(struct binfmt_misc_entry *e, char *page)
>  	if (test_bit(MISC_FMT_ENABLED_BIT, &e->flags))
>  		status = "enabled";
>  
> -	if (!VERBOSE_STATUS) {
> -		sprintf(page, "%s\n", status);
> -		return;
> -	}
> -
>  	dp += sprintf(dp, "%s\ninterpreter %s\n", status, e->interpreter);
>  
>  	/* print the special flags */
> 
> -- 
> 2.53.0
> 

Reviewed-by: Jori Koolstra <jkoolstra@xs4all.nl>

