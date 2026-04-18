Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16A4AF99C72
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 15:51:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81C026B02C6; Sat, 18 Apr 2026 11:51:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CCC06B02C7; Sat, 18 Apr 2026 11:51:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7094D6B02C8; Sat, 18 Apr 2026 11:51:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 622476B02C6
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 11:51:50 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B4D6CE4A05
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 15:51:49 +0000 (UTC)
X-FDA: 84672117138.23.BF4F884
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	by imf19.hostedemail.com (Postfix) with ESMTP id E15A11A0004
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 15:51:47 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=CLBButsv;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf19.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.41 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776527507;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MkRRlcAhUS32PwzsCXImISgP21H+dIYMB9rbdJES7eo=;
	b=M39daew+GBpDu58unwgN1GnyQx9tt/6c/EILTC5Z0EMtTIc7mL0+hINRgMNZfsoEi7SY1h
	Sz9DomaATL68RpH1rME8C+Y5UfQHNpNrBmilOXOd+2VuCdLhHCxrDzwBaRssXJMQyhpIif
	+pVp7Il1RQ3r6YNoFZV8wMupIqi9hfE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=CLBButsv;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf19.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.41 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776527507; a=rsa-sha256;
	cv=none;
	b=3qLfOyr7YIiDiGho5sUXX6QhJMqEB+TgA0o7EDuz14BALLlhBAnF2KOB9zUfOPqDLSA+AB
	d3KitXOGDZVBdlfngm09/IrRujSmYjOJgi3Iqb7g0q5EAs5Jqmu8NACPYKkxHghrwXcdsy
	aZjJMYZ08wTVIbM2Qmbnfg6zZCOq0Ac=
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-8a210c813f8so11918846d6.0
        for <linux-mm@kvack.org>; Sat, 18 Apr 2026 08:51:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1776527507; x=1777132307; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MkRRlcAhUS32PwzsCXImISgP21H+dIYMB9rbdJES7eo=;
        b=CLBButsv4RMKWSsdvdnQPMt2aSUgQfpmW4v2bsC1XbZWDtEcmQSx3gWhIuIYLcPjXp
         KHifGjFUdBJyxngQ1ggEeySjTgAs8Co8ZARaK0nC9ie42dRM18CYc28fWRHRdTxM+NCX
         pvMnN7WSdJHyJQAxIHgzdl+T7++JbpH4Cs0HihbR3IoYV3nkFD/EHzOkSWs+a9WFiHfA
         7eQG9XccrB4kHiQGYSqMCoGPf7zMZC48NAGiHH+M7DbO0TYgXYTGPx2X7+EBsp8fNvxE
         OR+4YmiWHXecbj24iD6oWoBKPHlCH9m697a6IF2ErBJTqqjppZF3ujf9u+h3Z1wYwdN0
         v/dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776527507; x=1777132307;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MkRRlcAhUS32PwzsCXImISgP21H+dIYMB9rbdJES7eo=;
        b=aFDdwJBGLVbhU0t84Y/iu7TRGvR+YkiibxZeGjgHSudsNcSUMaekJLNQehBBEdBYRd
         F/1wYvq0S7VqhbLfRhjETRSf0r5qOdTH4D1ebo1hb9tLuvUe0V2VUnz9xnHXrJL4Ka1K
         CZncSiyrqKK63Ogr7I1THC5OodxZVr0RlXl52SAA9cSbfCzqlNAgch4OeKb13DNcYm6J
         pwXuVHIayC5bfcccoumPN3igpwU8z+z1e//lPR4nfkjGtKRxNpSPZEJYOlyEDCYM7SFr
         eTJQOlB3L40pSv6DEvOXQQCpVPz/bSbi29FusRXEilk9BWJ0WdN5bfuRcilDzUunxIgw
         +B9w==
X-Forwarded-Encrypted: i=1; AFNElJ9lAhED6l2uzYjuYsga3ybok2EgnanY7ArRVeHarhTe5ssXUqX7kqsCi1Oy3P2CCjR0MOo4fNgaXg==@kvack.org
X-Gm-Message-State: AOJu0Yzmu7WG4E135IO7Uy5fwPDl2GQS+jIjfimJbxwI97cU1Sff9IDx
	1KYE9edrJ1XwmH2gVbbKIYploH8lip/BIBB1+h/rHX+9S0e2mZBC180BTbARI9R50/c=
X-Gm-Gg: AeBDiesBTgzAknxv82ELgJOxe9UVkKhA8B0CcmXMo4j1u9WZ6iYT7kLM+5Npi8A4p2L
	jIHuUZLrfGRZo5nfL66HTAH9evg0TcKDC25uE7F2X+1SuGouVW7/PWkUrppXDzbIpAFu/Sf0CfR
	AMLB0MdKFLG+IQKHPCqwBbjqz26cKk6MwOWDwa6pX5aC/fIcARSP+cKbZdvVo/Uo3CnhMkGCyhI
	pyEdoeCSWwb55vqkpbqtcs1lDS08d4KV1ix9JWM2garaoehwO6X8vV1hhLOWBy7ITqLNet5jyLO
	2bxde9KbsCXYvXjYCinrcWj9YuCn2cCwcHAqX0cHSUOSgOzi4YIlmAFhNro1RwX1nVuJIaJriKO
	1bvDCM7EUMtnYNKR4jigRXXYmtTEemONa2GfRco7h3flWkFmja6qVfLR7ak5kx5sJAZKoiUpoJQ
	/GT+jsfPD3HCsl1Bfru3VsATHEv6YgPgHzVQJJ8RwliKHwAWczREShQk4UNFnz
X-Received: by 2002:ad4:5ae9:0:b0:8a1:42f5:2c8 with SMTP id 6a1803df08f44-8b028065e21mr114871586d6.16.1776527506951;
        Sat, 18 Apr 2026 08:51:46 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8b02aebc655sm34782646d6.48.2026.04.18.08.51.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Apr 2026 08:51:46 -0700 (PDT)
Date: Sat, 18 Apr 2026 15:51:43 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: luca.boccassi@gmail.com
Cc: kexec@lists.infradead.org, linux-mm@kvack.org, graf@amazon.com, 
	rppt@kernel.org, pasha.tatashin@soleen.com, pratyush@kernel.org, 
	brauner@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 3/4] liveupdate: add LIVEUPDATE_SESSION_GET_NAME ioctl
Message-ID: <tiwltvdzwsm2c44xkzo5lbwkdv3vp3wsus6gbyin4caggwriro@lx6s6e6vrqla>
References: <20260418141123.2193917-1-luca.boccassi@gmail.com>
 <20260418141123.2193917-3-luca.boccassi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260418141123.2193917-3-luca.boccassi@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E15A11A0004
X-Stat-Signature: hjjde7a1x9k57g7mkzmnnh95fbsftr9z
X-HE-Tag: 1776527507-33219
X-HE-Meta: U2FsdGVkX1+c78JShmk3tDRdX1AE/XpBuveGMhiRmpSN91p8Wez6zppRCvK28NNBz6w3C3RvWk4HB+tViqYmK1C+KPM5O9kS1Kp4xvA0H17JbkSSUU2DPKrsbL5nd9DknEaFaPdzgCkCYuIcncOV9vc9A9a539bphmOjSfLbr6027HmTlxZA5DMdikMO7OKaBqc1Ff1fHqVDF0EHR+3IEzCb0zwL4OcizYYhrAzjlpSsoaGtxIFQPHHg/Xr40Sdo6vI0tvrUZcw9rkAOJ8lfwD65/OuIlsJvzOPypUmGBU1T6XA8tTUcoCabRCjQPlQG3OGR/TAvw1WBYE7bm5rFWBU91led5488TGiYGD46+i5uJZUOixAai3P/qFSHsmYY2jfMqzCrCIEk7ZFWXSoOc4q7wvqSH+xZbSI1fJLHH9blvenOK/TmicDbxkDRYtyFo7agorTKq0YtUcbCqYMCV2Ly8J6rPROn/SnC3oEp+Mv6t2WezLbEscuz5H1if2Qp7HoI9biZFkRgkPHp58qGyueso43YTGxHa4kneNnQvFpfr3qjke6aLKqrSm2RHTpFu7dAdGjFSiEQJqMiLfFXlMg4zOSqB797e6RxhrKpa8w2eN0QQTPHb9TEl4OQM7uRPrpGHUsdxHtRTIRWwyvmS0w5TxdLmnnIVuZnALiBnhLet6rPu1yt0sdc+lm2+c/VVWTzi8bzTyovsWemrYLbsv4d53vFBK1cmdSSktpDDmwLcsH8806EWErioGwgsUbkLzdMeKp22epDChMHXufA/t1tu0GKKqexwRgP+hGUR5B0+W5X9NDsGpFlDLaP3qFn1UCJIsOX3fGxUBBB9Je1p/WxQW5iPA5KWw4eJTm2cD6/My69N3Fb83vpY7/fCQXkoxqLK+7IZXnO1+uxkdk1taQ/Q6vtYc26LPhdcRAJIBoREhFGbcYg8Q3bMUUoH3XEb7PpirWRHKRwM7TjG5/
 6wqQoNMz
 s6XHssI1YueFl3UFBv/+hsPLMF0gn7jZAdCaJM4e3GPBedVLb94Y7BzBSEUrZdQ3Rg8ZsIO2BZLvJzxobTxtz2GjH+dtrit2kpOUqlhjp9Iy5h4MJCSwCmd/s1Y/hJ1L5KY9ObKfGXBnNgILEddgTgqfB86k2VgKZY+MBCMYAy0Z9Bbf1ovBa5hYMRR40uy0OCwRj0MAR2VsxlPChyRqFocYE02gG4VOz4ifz+SpJjFKpunV+bPMoZnbHW/uqG1LFkyHj5s8h+5fsy4uaYuQOxt78JoSbKZbqkpAI6uGE9JKjc4Pvv0RGmDdPhHerfD//czApHKCqf6zBZd6AU/BbuZoasrVgek90yfBnfXxfMitBd8i5iy3VZ7ZybZLm9JPSdSqctaEDpuKi1APbAGFM5HaRPAqOXKyf75vowbue6yfZLBN3woz3xIuZb5xexZnapd2qc5IerE4xfM6ysCtwNlU2ZJLs06D6SMdhYhoESEhkl2GD9VoQnTsVRpV5hJuz9N41
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04-18 15:09, luca.boccassi@gmail.com wrote:
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
> v6: fix docstring
> 
>  include/uapi/linux/liveupdate.h | 21 +++++++++++++++++++++
>  kernel/liveupdate/luo_session.c | 13 +++++++++++++
>  2 files changed, 34 insertions(+)
> 
> diff --git a/include/uapi/linux/liveupdate.h b/include/uapi/linux/liveupdate.h
> index 30bc66ee9436..3a9ff53b02e0 100644
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
> @@ -213,4 +214,24 @@ struct liveupdate_session_finish {
>  #define LIVEUPDATE_SESSION_FINISH					\
>  	_IO(LIVEUPDATE_IOCTL_TYPE, LIVEUPDATE_CMD_SESSION_FINISH)
>  
> +/**
> + * struct liveupdate_session_get_name - ioctl(LIVEUPDATE_SESSION_GET_NAME)
> + * @size:  Input; sizeof(struct liveupdate_session_get_name)
> + * @reserved: Input; Must be zero. Reserved for future use.
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
> index 1d35379e4e52..9b434470982c 100644
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

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>

