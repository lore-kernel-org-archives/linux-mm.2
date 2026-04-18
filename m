Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44040F99C78
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 04:09:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21DA46B018F; Sat, 18 Apr 2026 00:09:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CC4A6B0190; Sat, 18 Apr 2026 00:09:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E2476B0191; Sat, 18 Apr 2026 00:09:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F31316B018F
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 00:09:20 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5D2A113AB84
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 04:09:20 +0000 (UTC)
X-FDA: 84670346880.05.135CF70
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	by imf03.hostedemail.com (Postfix) with ESMTP id 81A6A20006
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 04:09:18 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=F7O2hJBo;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf03.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.178 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776485358; a=rsa-sha256;
	cv=none;
	b=lHh2TtEGBiKx2McDBTJUUYqnB9vB/fBay+H43xXGNtHGwndm3pL6q5QzfKJHMnMOSAqRNY
	ubz8H1cc2DMjM1wBzc9XwLfqQApQpFQWQ0eWOD+EGG4NRaM/2ZrfavXBykcqaYNtjA9TH4
	rgj8EgaYc4XskjB1B2qaJEWK7lGAJH0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=F7O2hJBo;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf03.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.178 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776485358;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q+mY7WPrjBt0/ShGgutDaSnhgXo0yyza7SyHVmsYfX4=;
	b=gYnB3TFwhD3qUXG0A1FFmtJ5cyksilSzcr2VOVcxPlvXJkPhkF/AYEpyzLgQOQDogAgLC6
	0EfwZrBasyF/xwMxZu5Wtbco+p3WoWYiTGziFqDIVDPizUOkcltedokmAKyoMyuJjMRE2q
	DwhLsApRQFQgt3VEovLU7d5gv4ghHtw=
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-8cb40149037so131314585a.2
        for <linux-mm@kvack.org>; Fri, 17 Apr 2026 21:09:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1776485357; x=1777090157; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Q+mY7WPrjBt0/ShGgutDaSnhgXo0yyza7SyHVmsYfX4=;
        b=F7O2hJBosuX9RhBV5KS0R91ER5xQ0NJXa11nBglY2xMyOUsmkHQJANXJApoQyfkYb5
         2pf9Y0e8FTKPkvfyuZ4f+hi2iuZPO6O0u9zBxLWIdoREymHUJQfyN//dtlHfX40jnA3r
         OV8Em6K3eN2v10m3QZQHWgn/vSzhwMcwT+1iBKAbAAJiC1rwFBSqNSKmos3QjWEVML5W
         R5pSk4je/VNVJ/7H9jjm96KPTDBBtLnCM1yhepffU+mhwgqX507O4r2J4UsOXnF7N3U/
         0TZOX4mo5sVFEKpOxUYVQP58jFcBVhXhYozjuyvkRUHDSFirJRjmur7eaPtLaiIYJDqo
         XPiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776485357; x=1777090157;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Q+mY7WPrjBt0/ShGgutDaSnhgXo0yyza7SyHVmsYfX4=;
        b=YqcV3fMeFNoBXkFTUPBkPJIsccn20Q8FNw4V+i7uXLSOi6xvj1ZQUMA985HVGkGpEW
         X9uS6OMcARb9YHyb4LeYBVin+91ctoZ9h9sK0v+gTo6gqJTgphCYlBgIgn0tDBMLmAjP
         8rrUmD0FNMjvvppygDFdZvksQu/X6t2Thx1Jvliui2+aGSuLQpBxQRAL0PqHz9aJvdh3
         g2BufiJjkin7hD7GomfcJmWA59KteIXniJ53x0ycn25SdfYShqpJnVLLNCQseSmkP+CE
         pt6BUTFRZ56WcDQdc+Naf5KAnKs0EbiAvsQV8wpCzr/ld4VxukEyXWL41XcMvYd/zJMA
         QkCQ==
X-Forwarded-Encrypted: i=1; AFNElJ+RHojF6649HyTwwmfNoL8AUfpv/qUFodPyLVwkMW+XGCukeRpC2oBwdCfYizCCC6YB6XQi38dakA==@kvack.org
X-Gm-Message-State: AOJu0YyNnQzTPsquav+HpnQ2jc7yqGhH2yp9wmYlZKQdPtpYiHCbxLeA
	EAdM2ETyaZgick3jm6bGmkG8F+jiQuZFv0dAb1eWHGHvTD0v0fZWSWzsGpWseQ8ViGk=
X-Gm-Gg: AeBDietWNW5IoMdABDKLCbryiDfezlwNfUOcCu857WvFO1pvP6kjEgmsxw4ecBPnuOo
	+Ejn4IXYKlqtRIaQxMVC8kXkrCbQ80Ag/PN2qeZ98MvX+NmW812rABpAb1g8rnH2DXsEoJftLxs
	kBk8Q/8msdpkAPjlOovGhrlXckjsDOcHooK65yeoEgVGtPkguYmz1spJQtuXsc+gu1Mo3ypcTjp
	qpMZOUWWfqSBL0an3Nc8klQ8V3dhHUCeOjZfdpdKdH9SMmEB/e/hNgCb3iMqIVRo7nJ+rD8E07K
	R+/DrOcpdT7WbXCYJ6eEfSYp/brIoVQa8Oj8e7p4ZN9Txu01zT/9aJoQ6q4QULSSB2o+kPMcO0e
	YCDK+rxFwzCvlSPnGhImnfnHyczi/axF0u2IDzlz3kMiu5tMvTJFdwnIEbMhi3tJqMInUpAONBA
	NQeREVlUgp0qD0lih9T2hYSVCHTfaFwJASQ1oAFf0PzfBbjP8+XRlVFxPWmnmH
X-Received: by 2002:a05:620a:2944:b0:8d7:e7f4:7e9d with SMTP id af79cd13be357-8e792f44c37mr787915285a.59.1776485357527;
        Fri, 17 Apr 2026 21:09:17 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8e7d64cbbdbsm288756285a.12.2026.04.17.21.09.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Apr 2026 21:09:16 -0700 (PDT)
Date: Sat, 18 Apr 2026 04:09:13 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: luca.boccassi@gmail.com
Cc: kexec@lists.infradead.org, linux-mm@kvack.org, graf@amazon.com, 
	rppt@kernel.org, pasha.tatashin@soleen.com, pratyush@kernel.org, 
	brauner@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 3/4] liveupdate: add LIVEUPDATE_SESSION_GET_NAME ioctl
Message-ID: <ntukp7nk6emz3twpcxn6abdwzbd2fxn5c2udb5scrmnjyvsvua@7272xkwt55qh>
References: <20260417220831.1934945-1-luca.boccassi@gmail.com>
 <20260417220831.1934945-3-luca.boccassi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260417220831.1934945-3-luca.boccassi@gmail.com>
X-Rspamd-Server: rspam10
X-Stat-Signature: b6n6xntxkyaqqeohdsi3i864dnqcqnyz
X-Rspam-User: 
X-Rspamd-Queue-Id: 81A6A20006
X-HE-Tag: 1776485358-272620
X-HE-Meta: U2FsdGVkX19iZkTbgz6OtNFUWg1raL4DfNfWSMEP5ACQMf5SvuxRoUJmbVzXAvM1YFNXmul6ZajwySaetslwitLMWR087oQ/MQlhUs0ZbTFYVF8N71uL4Nhp1lB1HdaVxKMCHoCB/029Fbq9fKTi46+FE8fiCtgrbnK8T76E1o8UBR2r5qFRtBgUds3K3Y0s4YMeuHU24kmUOOHQ2XLAZl4TnI4wq8dFWNjVY+BNrO3e1CJ7HnZb7WWLE+39rJ8DbgKWUMfQVgJThD8HJEOldgeL5Z0WiV81cpY6fLxfRuNBIbokM/xfv3ZCWg2Fe/sizi8Jn+XVSyCt0EFNXaiVJbTkFVn8iPzNTPlZjWYn+OY2I88xA+gbklQwNofDhKHE9uREx9faCwJ/LvSH9tSqsm5A5yQQdF7TcrMMc8rT3fYNqlGhQSKKOhs4nodOwDNHvd9ZnD2qivjJfM4LfZTxx4BDlfBjU1usiGZLgXy5k5J07Ec3f6MdJDTBElqzTesX1otDBmufjZIrBYydu2IsaFzPK5gl1AAKDRb7wuCZCmQ6C6Olt7PhxJouWuJhBwEPDethPZ0SqsdFntXc8dSUAnyBJ8zFwYWaLVzFXprn3gYoaMz77CXa+U1QI1EiXgyh6INwDTTYmR0hjztWsFZj8nES9EXmOb4FV38DrEgARzAHI2l6g6DH71JpeLI2eL7SEhSvQfFYKAevvLo25SiALJ2nW210S8ZI+eX71WN2SRcoQN6cTd7G0c2HcZ7k7kljp0IeScWEsbyP53pa1AMabF87trT/zeb426hV+IzTpHNfPRXYBr84IgW+yFMoUPoah1nlX/0ctDuTuyWUV6oLkNC4WOxoAmXkME7pMhFMhZE0iQjdRyJT9Ho2MJvT7FJA/t0wB/+8KPanKxSUHtscI7brz7JpfVzrXu9f4+uQhEIqmDXbQZrGR918526Oj2lUZIRK7ZbOCFTL9cbvJ6S
 W9GAhYsI
 vBr4UBN4suLqU1Wx0nzpjO4FLmO8lmf2zB7/HPfiV1x+YRUmDLXwY2wyqFwwKPpn4SND7TA7GzXIny4LOpI0e4iFDl/KJphYK8aJs4cS+sw8MKOjf+kAdPD/i5rbEQhzBvKc/62NtggCImRzdGGScNBTVCjyS5G+MaOABkQtocRySLLnfMZWRlIASIsiJLI/G9jDkGPBi36lbg3Iq9fvuDAxrChIxOSwUNQSAdPgkvElq4msfWsPQyE6P6CZNPaKw7X8gVy6NhIYZUakbOrcAeVs/LiZETriEfzeJpBPsqOa7F42uBwifno07cHoJ2dxiMiq6n/9nrP8RpQebAOSImAI/Xsup4uHx5Lr6HqST33Kg4jC4ndTG5M5Mn87LMzUu8wHKPKhBawuVtb+LHEIKOoDtiHhuxk0l7Np4g29U7wWt0HHjQMpkCHMJwjVyOKmYfalFpl6Iam1J6eU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04-17 23:05, luca.boccassi@gmail.com wrote:
> From: Luca Boccassi <luca.boccassi@gmail.com>
> 
> Userspace when requesting a session via the ioctl specifies a name and
> gets a FD, but then there is no ioctl to go back the other way and get
> the name given a LUO session FD. This is problematic especially when
> there is a userspace orchestrator that wants to check what FDs it is
> handling for clients without having to do manual string scraping of
> procfs, or without procfs at all.
> 
> Add a ioctl to simply get the name from an FD.
> 
> Signed-off-by: Luca Boccassi <luca.boccassi@gmail.com>
> ---
> v5: merge with LUO_SESSION_MAGIC series as they both change the same
>     unit test file, to avoid merge conflicts
>     add '__u32 reserved' to the UAPI struct
> 
>  include/uapi/linux/liveupdate.h | 20 ++++++++++++++++++++
>  kernel/liveupdate/luo_session.c | 13 +++++++++++++
>  2 files changed, 33 insertions(+)
> 
> diff --git a/include/uapi/linux/liveupdate.h b/include/uapi/linux/liveupdate.h
> index 30bc66ee9436a..079ee6afb15a7 100644
> --- a/include/uapi/linux/liveupdate.h
> +++ b/include/uapi/linux/liveupdate.h
> @@ -59,6 +59,7 @@ enum {
>  	LIVEUPDATE_CMD_SESSION_PRESERVE_FD = LIVEUPDATE_CMD_SESSION_BASE,
>  	LIVEUPDATE_CMD_SESSION_RETRIEVE_FD = 0x41,
>  	LIVEUPDATE_CMD_SESSION_FINISH = 0x42,
> +	LIVEUPDATE_CMD_SESSION_GET_NAME = 0x43,
>  };
>  
>  /**
> @@ -213,4 +214,23 @@ struct liveupdate_session_finish {
>  #define LIVEUPDATE_SESSION_FINISH					\
>  	_IO(LIVEUPDATE_IOCTL_TYPE, LIVEUPDATE_CMD_SESSION_FINISH)
>  
> +/**
> + * struct liveupdate_session_get_name - ioctl(LIVEUPDATE_SESSION_GET_NAME)
> + * @size:  Input; sizeof(struct liveupdate_session_get_name)

The kernel=doc comment needs to be updated to avoid errors. Add 
something like this:

 * @reserved: Input; Must be zero. Reserved for future use.

> + * @name:  Output; A null-terminated string with the full session name.

> + *
> + * Retrieves the full name of the session associated with this file descriptor.
> + * This is useful because the kernel may truncate the name shown in /proc.
> + *
> + * Return: 0 on success, negative error code on failure.
> + */
> +struct liveupdate_session_get_name {
> +	__u32		size;
> +	__u32		reserved;
> +	__u8		name[LIVEUPDATE_SESSION_NAME_LENGTH];
> +};
> +
> +#define LIVEUPDATE_SESSION_GET_NAME					\
> +	_IO(LIVEUPDATE_IOCTL_TYPE, LIVEUPDATE_CMD_SESSION_GET_NAME)
> +
>  #endif /* _UAPI_LIVEUPDATE_H */
> diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
> index 5e315cc0dfd52..f30151c37bd43 100644
> --- a/kernel/liveupdate/luo_session.c
> +++ b/kernel/liveupdate/luo_session.c
> @@ -291,10 +291,21 @@ static int luo_session_finish(struct luo_session *session,
>  	return luo_ucmd_respond(ucmd, sizeof(*argp));
>  }
>  
> +static int luo_session_get_name(struct luo_session *session,
> +				struct luo_ucmd *ucmd)
> +{
> +	struct liveupdate_session_get_name *argp = ucmd->cmd;
> +
> +	strscpy((char *)argp->name, session->name, sizeof(argp->name));
> +
> +	return luo_ucmd_respond(ucmd, sizeof(*argp));
> +}
> +
>  union ucmd_buffer {
>  	struct liveupdate_session_finish finish;
>  	struct liveupdate_session_preserve_fd preserve;
>  	struct liveupdate_session_retrieve_fd retrieve;
> +	struct liveupdate_session_get_name get_name;
>  };
>  
>  struct luo_ioctl_op {
> @@ -321,6 +332,8 @@ static const struct luo_ioctl_op luo_session_ioctl_ops[] = {
>  		 struct liveupdate_session_preserve_fd, token),
>  	IOCTL_OP(LIVEUPDATE_SESSION_RETRIEVE_FD, luo_session_retrieve_fd,
>  		 struct liveupdate_session_retrieve_fd, token),
> +	IOCTL_OP(LIVEUPDATE_SESSION_GET_NAME, luo_session_get_name,
> +		 struct liveupdate_session_get_name, name),
>  };
>  
>  static long luo_session_ioctl(struct file *filep, unsigned int cmd,
> -- 
> 2.47.3
> 

