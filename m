Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F651FF887E
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 14:35:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 782196B009B; Wed, 29 Apr 2026 10:35:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 732766B009D; Wed, 29 Apr 2026 10:35:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66FB66B00A1; Wed, 29 Apr 2026 10:35:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 555F06B009B
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 10:35:25 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F338B1A0143
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 14:35:24 +0000 (UTC)
X-FDA: 84711841368.03.8F0DC5F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6315B4000B
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 14:35:23 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ptZVpwHz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777473323;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jSIY5dDrNGunAsVpp3zxMSKdhVEZ4kytC2UcFzQyNZE=;
	b=kJXPha0jSXnQWbwWJ2un1YZFfB9LHYzLSHY3h87KhB7DHTAsWPfSE5nmK/Y+wi1ggxRLG5
	DKjJSX6E6sKIzv8aNwq+8b7uxP8HqrQddA8pJysFKUPTMX8KvdYAomGa5ICFMpLdCQlrga
	DWzKO6vfzLjV0pWe43lMeOJhWCXWbQo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777473323; a=rsa-sha256;
	cv=none;
	b=4kE4r8IJ+hhqi/OE734/h56v/jGXlDdSAewEIspBhGrI7DLokim1XkdhyejWE1KyFnScOR
	BuzsOQnzNay8zZV7eMgAwiG3mkczfsKLtiusMYLCPMBBrnsSaD/3vNvQN2ELbMyLgBMhRS
	QcKnk7Na1e4U9VP9++W86oeszf4lfXY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ptZVpwHz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D5B0860138;
	Wed, 29 Apr 2026 14:35:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50EDCC19425;
	Wed, 29 Apr 2026 14:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777473322;
	bh=qSqiep8Qpof8Q5a2J7V96rrIhl2L0+YtBJVeAPkOgcI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=ptZVpwHzwAfEy8WKiAsauOLnmEzpAdjJx0/KDi6B4W9VvJ4Q+NzlGgJZndYsLxvqD
	 3svf7hwcYqKHXjPXzMw/Dd+1vaSQt2FpcA6vn+4bVIyWxH5YD8YfqLFdH9Cf9CgTev
	 YPNvRybNRUEE9y/QipyqO2ikeqckWgDnC3GXBRE4cJrmLN8AkseI4Ubq8P1TcjG4s6
	 EqPU8NJiv4LSz9hEX6ST01ofgYwSRGu1X1jRTUBuGEmURTTi4StlMN3VjVjpEBJBIv
	 WM88XgTcFERpvVgcB9V6Xyf4aHcYyijsO4pgGbWXFq5m/X8h7vVGys2IaGM+uogAgH
	 pEyxrW0/85VsA==
From: Pratyush Yadav <pratyush@kernel.org>
To: luca.boccassi@gmail.com
Cc: kexec@lists.infradead.org,  linux-mm@kvack.org,  rppt@kernel.org,
  pasha.tatashin@soleen.com,  pratyush@kernel.org,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 3/4] liveupdate: add LIVEUPDATE_SESSION_GET_NAME ioctl
In-Reply-To: <20260423234753.3873095-4-luca.boccassi@gmail.com> (luca
	boccassi's message of "Fri, 24 Apr 2026 00:44:22 +0100")
References: <20260423234753.3873095-1-luca.boccassi@gmail.com>
	<20260423234753.3873095-4-luca.boccassi@gmail.com>
Date: Wed, 29 Apr 2026 16:35:19 +0200
Message-ID: <2vxz1pfx4yxk.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6315B4000B
X-Stat-Signature: p116pducoz187pqh94si7wgsczf3kp9t
X-Rspam-User: 
X-HE-Tag: 1777473323-54854
X-HE-Meta: U2FsdGVkX1/SJz5aZBc76RvNe/BWjy6yElwKv2APbmDNQgqPssEhcPIT2mRVkXwHJIaNlmuTmD9hXjHPKyKX0Vw/rQFinZC9VTg+oBWba5bmKpMHUjGEt5xQN9w1UoAL3sDJ2CwAiZ/fOssF3zrheogbNkOxPJbIRWXz73CFxaOxL1jN6RUbhdqGWgJBkxKgD0kNlyfSJSsGYTKoig6JWaD/zAKDCuvx8r+GnW6n9lw2HesS/IqfbP3GqGHwpS8TMz/xLMwnvwHhFSvKGAKGb1hcX7y1CGhvZ9iOukYW+0Lnmsnj9V9LQFeD1fx7bJE2e750gcApSUh0JKZzBNie9A183zHuPDI9aix2DY+TUPUXebswP+13x2RQv8FPh56A5aGKHBO1EmR7+CQ7LhwOUt4SY3+a40rS2eJeVmedCvSSwsWfQUe0L4Cax2PrXDe4TuY4YQWWYt445E6a9WLDOPQFBUEISOj2hqaEELLkrF3dV27EXBfRCI5c//B9djKQ2b7su61DHbrLPxaHlO4oRrLlW+ceABDFHjtpNL/7gsM2WcG5/xL8Cy5jh5apxBZMChI75w/AdvMT1PE0OMxV75gNLOQH5z1/XO0nUfC5spEeUdcTaVcyuh9iVwMy/J/kQruIvB/hG6/iwkDxsWs4jGpxGpV2WGIGb7ZK/ZMrdi2ZtW8CPGIyFaN7r3MmRwxX65d91SQIuwPect+I3aFLig8cEMff8gToQ13npjGhzBEwLyIG26uY3mBMxkfz1nk1SZfK6SC8aOrp+se2SchuJ8WQsBi95sgbrrsV1BeLtjY5OmU0Gy7R7WVVo93uxZDQNKCHKw6+M06511uNC7VwsX0v8uZyyYHfOqmtxGWLPfBK4ugGWRSRzdoJaTi0Y01e3bIR1T1YeAtf/PYy4sCy++pUSqWRWP/ofWqR1yH/c/ezSSRkgJoXUKLLfy4UkZgBAI/u8DeEqxdLL4oQ7/M
 KkNn2D1J
 9BMvIR/XTRqczCiYsQn7jaPfijEZEDnk7s4ndlJgqfjIFAZRR5uNXsQOzNiZytRlrxFcRaHWhYu9BY+P18aUZuhPuSxecLffpyR+9d9JDGSG077G37PGmbXPjzN6MBT+v2N4Pgm6zcRGE3sPAGwKOe2u4flRANTTxjTuLZQXmN52twrrtI4LY7NayU2+a1ty2pmFpqNm539/7qplsROlM8C3hx+UEOF1Su+NfR456CySol+w1/JIBhw4ZxFbvof00fbmlAtOtpnPUmgSseDm9anif2aiwrzPS3chM0RaEH6sYM2QnjTr1k2ut4mzpb1ZT4kuYLH0T3ICHjMmNGC/c7JVFF4tVdtl+qp65JJb4MuNXWwdI0KTRpvkARozBHPH43UnCc5+M3iwtsQ0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 24 2026, luca.boccassi@gmail.com wrote:

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
> Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
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

You need to enforce this in luo_session_get_name(). Otherwise some
userspace might try to get clever and stash some data here. Then if we
ever put something else here it will break that userspace.

With this fixed,

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

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
> index 5e316a4c5d71..0bcf2def074e 100644
> --- a/kernel/liveupdate/luo_session.c
> +++ b/kernel/liveupdate/luo_session.c
> @@ -289,10 +289,21 @@ static int luo_session_finish(struct luo_session *session,
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
> @@ -319,6 +330,8 @@ static const struct luo_ioctl_op luo_session_ioctl_ops[] = {
>  		 struct liveupdate_session_preserve_fd, token),
>  	IOCTL_OP(LIVEUPDATE_SESSION_RETRIEVE_FD, luo_session_retrieve_fd,
>  		 struct liveupdate_session_retrieve_fd, token),
> +	IOCTL_OP(LIVEUPDATE_SESSION_GET_NAME, luo_session_get_name,
> +		 struct liveupdate_session_get_name, name),
>  };
>  
>  static long luo_session_ioctl(struct file *filep, unsigned int cmd,

-- 
Regards,
Pratyush Yadav

