Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5BC8CE7B05
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 12:58:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 247458E0007; Fri, 14 Nov 2025 07:58:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F79C8E0002; Fri, 14 Nov 2025 07:58:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 135118E0007; Fri, 14 Nov 2025 07:58:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 002B78E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 07:58:07 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9003F139114
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 12:58:07 +0000 (UTC)
X-FDA: 84109215414.21.15C5AE0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id D372C4000E
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 12:58:05 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kmjz1HLD;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763125086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7LoGp1WjNMANI/DbYeDlbk1lu1zpmsfDhAaQi4T6DtE=;
	b=TvuRYPF6mTIbOnul82quIh4O0FTK4U2jQv/X0xE6ck1VrvEFsj0aAVvFdc1D7SSkw4IBFp
	jP2LgupaqfVIhRmWiytj+uoqyiWy4gmTREhJiVa6mlccf7AdBt77aqtCo6Il5+DcpmPDPU
	GdV76WU0vIJaS8ivoan1M3iuH4oe+dI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kmjz1HLD;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763125086; a=rsa-sha256;
	cv=none;
	b=HjdmX9eZbYHYFQwzpMbyk8xuyo83IgmL+Pkk5z3V9Dg0lPy4xIJK7itpwGgBWv+ECB2cUy
	asfURrZYwSOV0jxwml0I8MBn3N/kg2/cYW3Y1gd0OgQQ4Q7hiXImRdQUhX9gnp7mnDfATj
	/oKdz0eUifgZlasXFgVbWXFv4BZkveU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C3E2443AC3;
	Fri, 14 Nov 2025 12:58:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 591EDC4CEFB;
	Fri, 14 Nov 2025 12:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763125084;
	bh=TRk5CRDCjCUBl34vCSFEaD0Pky1Npmrx67ErLaAFNWQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kmjz1HLDGS/IllCSa4KMdHNSId6pueobxCl5xZgnBB8a+U4b5rktOY8PGz26D851R
	 3OroOMcquW4KQMQHsqFrENyBcOdheblBg9CeI7TibzYJdgz8MWbHrssPwLUQZJPqwD
	 dbsyDIETvjBviTJHJdxm8GtbEVM4wyXi4PnI3/2i19cFM+KMAQPLyr+Ku5CtcW+ldN
	 GR4TJWWYoVAkrws4J+tDb89esU6x+Bojt/RXBA6BPTksu0xTLUSOU9hCBx8vUmYKtD
	 jA5JgPxZX3LMx9VErM2cLByc6ag7hmxYIowctAvRci5FQ9IpxyRERhCp5q2LJYlxiO
	 Vlov6DBBTSJ2A==
Date: Fri, 14 Nov 2025 14:57:40 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com,
	dmatlack@google.com, rientjes@google.com, corbet@lwn.net,
	rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com,
	kanie@linux.alibaba.com, ojeda@kernel.org, aliceryhl@google.com,
	masahiroy@kernel.org, akpm@linux-foundation.org, tj@kernel.org,
	yoann.congal@smile.fr, mmaurer@google.com, roman.gushchin@linux.dev,
	chenridong@huawei.com, axboe@kernel.dk, mark.rutland@arm.com,
	jannh@google.com, vincent.guittot@linaro.org, hannes@cmpxchg.org,
	dan.j.williams@intel.com, david@redhat.com,
	joel.granados@kernel.org, rostedt@goodmis.org,
	anna.schumaker@oracle.com, song@kernel.org, zhangguopeng@kylinos.cn,
	linux@weissschuh.net, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-mm@kvack.org,
	gregkh@linuxfoundation.org, tglx@linutronix.de, mingo@redhat.com,
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
	hpa@zytor.com, rafael@kernel.org, dakr@kernel.org,
	bartosz.golaszewski@linaro.org, cw00.choi@samsung.com,
	myungjoo.ham@samsung.com, yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com, ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de,
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com,
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net,
	brauner@kernel.org, linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, saeedm@nvidia.com,
	ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com,
	leonro@nvidia.com, witu@nvidia.com, hughd@google.com,
	skhawaja@google.com, chrisl@kernel.org
Subject: Re: [PATCH v5 07/22] liveupdate: luo_ioctl: add user interface
Message-ID: <aRcnRFnqhm3jkqd3@kernel.org>
References: <20251107210526.257742-1-pasha.tatashin@soleen.com>
 <20251107210526.257742-8-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251107210526.257742-8-pasha.tatashin@soleen.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D372C4000E
X-Stat-Signature: 9bj9oz5u8tu8fz7gbe9wdn8o3eegm9ir
X-Rspam-User: 
X-HE-Tag: 1763125085-69206
X-HE-Meta: U2FsdGVkX19Tuqyt8h39sfQD2+igkJCviWMK1UBrR9wiT3j598VsBecgPXeELgvFCdQ9ga2EIAMfrjOFi+S/9WbqBq9eq4WWoHUAIYbxy+HI1EdMPiAjqwfub6UFT9e+EuXRYMQdUi2fp5Zhu83zNCn1/NwZ8IdrFhoM66s9SefeQWgrtGqxiYmgDqTx8SUnfvI3MAr/GylJrdfArrvjJSgU0lROyNa+qAFTeZLfjwkhBtE0WiTB0Y1ISaKFq/gTU7jh1hjEzDFQSkWw+3Op+5UAfLLGj+WmYVdBtDFEyQeqbb/JdOS5+5DWXFjd3OyVzaU3JjTRaNviwVl+02HpnNfrFDpZ8cEGtmyjzZVMtiITqb1WpOMs8m4PQziCyamJRwy+jEUT3WVyVtPOsL0aVunEGDf9NByEBCpDeD1Omn2g2o3EwuDuqKvqtUG3KNh81A92LoJdmGfGima7V09DqSNA3tGOlAoQxDAL7aEoDXgH4T3kL2hPPvlV8Wb5gsI15aO9tO4z5jVVZLViT4FpOjgs5Ppy01a+QRr4m2PkzltrrfMgxJRqDcr7G/gIbH8MEVCiIPRJETVWiiWeroyHu4C9hPpIP3RA4KRc0sTjxpbRXSaR+gaKq1yygBWonE4klNJB9yfx43r+eF+SobQBF8vXOfb/diQnrhNOe01zJIie0stp5lG9+FonyBqCJOlrvaaOMzFNsm1Tn44jIhqKitIxGIQj9YEFWSgzswTMM3iRJslQGwvYi288VWs4fnBXyQAly40gJvOGPH4lPUXaD7NgqxlDlp0dpIDIO2V8XhtjJheJBrzXOknH5bKJYbPlNPNPZ/GCONdMI/nO48bFxOOgAFEErZMHtjEZcNCqoh2sarrfKrCl1GlnVCA7D09Lh90jarVFhKHYU17E6oiCEFHP3vHtJ1CGk/8wl7Vl+hl0xMzqGURMMQVYG5/TwcAtFnmWsum65/dgQAgcWDn
 PJqgLD1W
 8zOd7xodXwsRvoS0/XtGXOb8E8JTxapOaVbDc6BvfPqC8KRB+b9q2lpS6pO4GYxCArDS0FC3N7wia4MMK72hetHhYOFPOxNaKrHzZxY3F5uAt1AVhihCamlVRh8vcYkJvB4CPrpaiZgJKCjqmwxIDM9KkaWYJIUgfU09rV2PhAXaazZKzAQCrtq/QOjfeCTLEYyZbwZzc4Q65S0X/7obfiJsun5Oqx4+fGj4obcQTf2uD08lb0QGfaOQFMhRSWfXXWNQgwDJIiduwMVc/DUQ9OCr3wud9ldJwBzy8vC6BBZOP3dG6gDdQNQsWQ4OAKr7qNRVxSb6yb33YXkn5jSZnodIv0yRQvYtJPD0LbfcpGEaH8mMT3lMS+0yYyX1GyMV/oow1X4GlTFL6lIIRTnclDV8YzFH12Bxu6KKV2rU/YJ2nOqGcD7qVbJYITg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 07, 2025 at 04:03:05PM -0500, Pasha Tatashin wrote:
> Introduce the user-space interface for the Live Update Orchestrator
> via ioctl commands, enabling external control over the live update
> process and management of preserved resources.
> 
> The idea is that there is going to be a single userspace agent driving
> the live update, therefore, only a single process can ever hold this
> device opened at a time.
> 
> The following ioctl commands are introduced:
> 
> LIVEUPDATE_IOCTL_CREATE_SESSION
> Provides a way for userspace to create a named session for grouping file
> descriptors that need to be preserved. It returns a new file descriptor
> representing the session.
> 
> LIVEUPDATE_IOCTL_RETRIEVE_SESSION
> Allows the userspace agent in the new kernel to reclaim a preserved
> session by its name, receiving a new file descriptor to manage the
> restored resources.
> 
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> ---
>  include/uapi/linux/liveupdate.h  |  64 ++++++++++++
>  kernel/liveupdate/luo_internal.h |  21 ++++
>  kernel/liveupdate/luo_ioctl.c    | 173 +++++++++++++++++++++++++++++++
>  3 files changed, 258 insertions(+)

...
  
> +static int luo_ioctl_create_session(struct luo_ucmd *ucmd)
> +{
> +	struct liveupdate_ioctl_create_session *argp = ucmd->cmd;
> +	struct file *file;
> +	int ret;
> +
> +	argp->fd = get_unused_fd_flags(O_CLOEXEC);
> +	if (argp->fd < 0)
> +		return argp->fd;
> +
> +	ret = luo_session_create(argp->name, &file);
> +	if (ret)

		put_unused_fd(fd) ?

> +		return ret;
> +
> +	ret = luo_ucmd_respond(ucmd, sizeof(*argp));
> +	if (ret) {
> +		fput(file);
> +		put_unused_fd(argp->fd);
> +		return ret;
> +	}

I think that using gotos for error handling is more appropriate here.

> +
> +	fd_install(argp->fd, file);
> +
> +	return 0;
> +}
> +
> +static int luo_ioctl_retrieve_session(struct luo_ucmd *ucmd)
> +{
> +	struct liveupdate_ioctl_retrieve_session *argp = ucmd->cmd;
> +	struct file *file;
> +	int ret;
> +
> +	argp->fd = get_unused_fd_flags(O_CLOEXEC);
> +	if (argp->fd < 0)
> +		return argp->fd;
> +
> +	ret = luo_session_retrieve(argp->name, &file);
> +	if (ret < 0) {
> +		put_unused_fd(argp->fd);
> +
> +		return ret;
> +	}
> +
> +	ret = luo_ucmd_respond(ucmd, sizeof(*argp));
> +	if (ret) {
> +		fput(file);
> +		put_unused_fd(argp->fd);
> +		return ret;
> +	}

and here.

> +
> +	fd_install(argp->fd, file);
> +
> +	return 0;
> +}
> +

-- 
Sincerely yours,
Mike.

