Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4AFEF89253
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 10:34:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 591FC6B008A; Tue, 21 Apr 2026 06:34:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51A8D6B008C; Tue, 21 Apr 2026 06:34:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40AE56B0092; Tue, 21 Apr 2026 06:34:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2F7AC6B008A
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 06:34:42 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 025031A0C97
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 10:34:41 +0000 (UTC)
X-FDA: 84682204404.26.4DA47A9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6AE1E80009
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 10:34:40 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=t6frr9CR;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776767680;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aPHIpKOc9JZyUVGjXGttEnMgI5KTPFJGM2sZ3Ay83ZM=;
	b=5kJl/ubWI4XgcWfUiDfn9UIbK9y9ke8a9ls5Ylf4PVxx3yy5MBiKRsMpcmCLYSsrPPCPsu
	f3FyCcWSrj5VmkdQkLjL/REP0RSjeRDO+DDSP6bYzqq8JZONqPcr190u+Ts3/coY4IXNLX
	2UkTGY+uqvzGjT5ZPXDgvopA9EbdoOY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776767680; a=rsa-sha256;
	cv=none;
	b=ExomIQdRgF7JPCgVaAsYfbgN8QfisavRG27zVugU3425JMzLWuhxTPWH/LAZQpv2vTOXgl
	tIncRP/0Hpj/sXb4+qJ1kejAwVi9Rm3FeMJlnwJEm8ca/iS1BPbF5RcUucKZqkitjuKr3B
	TU0CoetytngFepqmVg/TEmkElDCd5jo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=t6frr9CR;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E905060125;
	Tue, 21 Apr 2026 10:34:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3A11C2BCB0;
	Tue, 21 Apr 2026 10:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776767679;
	bh=0r79gkwhQAWosOnQRra+o1K5QquGnUsKq8Elo7H4MXU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=t6frr9CR/lR8Ud3hTbLBDuZgca0Fjbr+keXAjG4OGkcLI8emYGfzIiTdpBqmkeUW8
	 I0p1nbGFcSioueP5fqyXROGJHpS2qsHNetHmO1mJBVHyFbvhwEG9yZY5qtgif8pSWA
	 FUGb/R9d9xic0LHcDqjSIiCwj+2pHJkTfSUMfGm0nggHBhI1FQ76Fu8RJbPH51XOUO
	 8aSS6NjVnp4XkMvzENLU/JB731X74IikpAl7AMBdeRqHswVeEyUgcIAVMNSJ9RJyog
	 fQ8sUs3XaRWBQSG44JHfoe/Te4TcZw+ePh/DJg3ZyHOI5+l/O2wo+ve0wpvQx2ZOP6
	 +G8y8RCBPzhuQ==
Date: Tue, 21 Apr 2026 13:34:33 +0300
From: Mike Rapoport <rppt@kernel.org>
To: luca.boccassi@gmail.com
Cc: kexec@lists.infradead.org, linux-mm@kvack.org, graf@amazon.com,
	pasha.tatashin@soleen.com, pratyush@kernel.org, brauner@kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 5/6] liveupdate: add LIVEUPDATE_SESSION_GET_NAME ioctl
Message-ID: <aedSuVXsD1pGmYCr@kernel.org>
References: <20260420141741.2688371-1-luca.boccassi@gmail.com>
 <20260420141741.2688371-6-luca.boccassi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260420141741.2688371-6-luca.boccassi@gmail.com>
X-Stat-Signature: zskr89h6h8je4nt7azzrkhdz7iei4azs
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6AE1E80009
X-Rspam-User: 
X-HE-Tag: 1776767680-62884
X-HE-Meta: U2FsdGVkX1+5c1WoyF9M+WvUWCMWAMRNjvbbr7J/s0AyRph/atuhszWUzeYIc6R/3wPPgR/V05ic4a0xAqxd3nydIk+ijMcaTh5CuFUKAMWS6LBjow1PB39UDi+sVc5dBlIkmU28EC1dfMnZ2l88CvdhlgHb2KPTskccVK02GCtzsunZD47PRACvJ3Ak7465jnNhZrXKQASZ4EmENvqcpVRir8VTAosjZzeh5DXQfKqrv6Phk96y+cwM491SuRjbVIsGNwfS1gFqsrZ8H2i7cShiDlcy5YyiQKgKMZzYgusn2q+CYFZoWpbsG4a7CPfnn6oE+uUCH5uzldPuvoA0tlraM3y1PJCdLjhbE9UAmkZ8/Zm7jD649XMtMHUeFuS56SRRU7sMZHiyQQSL2KNPh9dt1utbZPdjCVCM/6SAvmPL5yQQr7Ko9Qciz+SW4HZy2nutwCHnoMho/0u94q3bLJsPUoSHD79/3Nuwsg3p8smsMZKFFUQAw26ScszXxviNVOK+vdIwIc87yrePAu4dC3QYm0PxCRn8Tc13pRUtHtLvwjusZFAflC22PW/HRLOvEpf5XZaotMRmWyH8MTKodVQu9LwHWkNAfYu8kr2Mi0Zum4VkeYfYWuzPFgp9zvGvNjz4qXDhlxdYd4CpLm65ZaQLuVoFXH6FUW7Qj6RRlxK9zvYKsaIBgDTZRxxr6sd2erZdbw0vbqTO6A621bHgXsazU+6vfPmdTt/clrr8IZxEh53nXZzu2ww+ydzJC1hIHLjH9F2zOP0MhKM1/5I2H2ikAhYYFIi1e6oKeyomxhYX63h1lhCrSE+/GFUxXgGLRdbF6kHctMlL9sUj7ZkRuRNDVbGEpnyVTAGRMDmRSkigr9GWTyx46FP+pyIngOKycECtdBNZui6jgxJYCyIPLMXS+XasJyedSpWwsSlkDkquuh5pxP5aT+bWgUx5Nkf1YNuXt0UeiqaRVrl/VV9
 OqSXFv7p
 s3VfT5faDADPrwPTATdtuPFt7IGmXotqLrCd/YSmC+4kYbdgL9xaI6y+IdKf2m9CqAcqyc2EuxZWmznNxPFSvbzniTx8hoYly73Npv+clST1Z2JYN/884F1X2sa9apQeRaBQz3dnxcx9YPn7DYgb+BXHWMMO5KCg1mF379qusUZgAyJjDLwVg0lVvOEcUjXTjSBZsjYH64wpYBhOHgobSi6T+CY8SYS8R/TeK1tVCE9PBsOqMU2l/QcDlL0NvPHbksXFLf5Xfgc3Dmq4c2pU0xyCT+UH1wWHcqH86nmKxS+HzifYplmAFqGV37s3BY2OChKyC50GASf8IeMlz/xDfWh1VG4YNiDynq5l8YTPr9GK6zokKeNIJHkdqdJm+CfedjQK0x+cSRWilg5gSvIR1WpuywHop450UfLMyLEfx07UxwA+DJe/aPSgeSq0Vb/sgJF1vRWLPuiWfylLP17foqY+oiw8UVmLeawJd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 20, 2026 at 03:15:13PM +0100, luca.boccassi@gmail.com wrote:
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

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

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
> index 9e343b6ce513..885e1f346caa 100644
> --- a/kernel/liveupdate/luo_session.c
> +++ b/kernel/liveupdate/luo_session.c
> @@ -292,10 +292,21 @@ static int luo_session_finish(struct luo_session *session,
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
> @@ -322,6 +333,8 @@ static const struct luo_ioctl_op luo_session_ioctl_ops[] = {
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

-- 
Sincerely yours,
Mike.

