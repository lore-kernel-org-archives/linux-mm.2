Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E52FDF89252
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 10:33:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D54A6B0088; Tue, 21 Apr 2026 06:33:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 060C86B0089; Tue, 21 Apr 2026 06:33:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E69276B008A; Tue, 21 Apr 2026 06:33:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D177C6B0088
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 06:33:52 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6782B140D37
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 10:33:52 +0000 (UTC)
X-FDA: 84682202304.11.3EF2876
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id B3FE740006
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 10:33:50 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="PiaYdB/6";
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776767630;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5DEfO3Om6MFWAZ2G+/mg4cy2D9H7hgXJ3pHTPPk1W80=;
	b=cxcDoD+bt/F3pBlacVr3kkEnd+Af5OR+YxoXJIQwOR4gIsea6Y1/rqnxF0ER0QRcpiukWm
	9IjBbqDl4NzTj1Ct5qXazxxmDWkCqqKY7UIBzqBy0MGnSRnrfWXM3Ilzjq9Vg11P8pMa1e
	OACdt2i4Q21kh/xlCSI1hQ1XfhDKb7g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776767630; a=rsa-sha256;
	cv=none;
	b=2ByQkYajO1ERvLMB3m6KnttDH9nz0bJYAvT025F5VDDfdZLSpppbCiRdkew4Lco7AdOj44
	lKFhWNa5zEwBtBFwAmu8qg8F6AeDpUIPNtNEEaPvXIxU8opLCkx9N39cLYV8dyhOZfgDvO
	fOhDs+l4r+P/c/PxkEeij3Fbupd2uyQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="PiaYdB/6";
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B103942ACA;
	Tue, 21 Apr 2026 10:33:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A342FC2BCB5;
	Tue, 21 Apr 2026 10:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776767629;
	bh=+HYxyzzmrs8BA0f4ocV88SQtOQuD4Dh2f+8I1JsB5Pg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PiaYdB/6a+Mmpo8s7JnI43D9v3kTtg0YWl0Ywx4jNX47uPO7NvVs5caHtJ8loMX40
	 QOP77tYBVIbUSxtHmAxPxkndq0Ai65F3GhP+7CBZ5aFRfi2gfdD7PuJFZZzeUg1npd
	 UcDZQjCzpEmieEiD/2DcrBZyExhMwVlRaDykIK4JIJESnesyofEMn8AaLYuc7PyMEy
	 HAuoPdFF4llpLEBFvlYKjSeki9rMcMlMVsDdGmZsspdA/dsPzZmVwzwf0KMORHs2b7
	 WjjyWbBfckfkdfVZh7b1KDCNp7xVMk3R9vi8RgWDFZFjrX5mEQRUf31A/ro5cUvLnS
	 CUtQpY8UDsWhw==
Date: Tue, 21 Apr 2026 13:33:43 +0300
From: Mike Rapoport <rppt@kernel.org>
To: luca.boccassi@gmail.com
Cc: kexec@lists.infradead.org, linux-mm@kvack.org, graf@amazon.com,
	pasha.tatashin@soleen.com, pratyush@kernel.org, brauner@kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 3/6] liveupdate: add LUO_SESSION_MAGIC magic inode type
Message-ID: <aedSh8oA5_nXPZ8E@kernel.org>
References: <20260420141741.2688371-1-luca.boccassi@gmail.com>
 <20260420141741.2688371-4-luca.boccassi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260420141741.2688371-4-luca.boccassi@gmail.com>
X-Rspamd-Queue-Id: B3FE740006
X-Rspamd-Server: rspam07
X-Stat-Signature: 4udhhuhxwupzy5ceoxc4piptpnat1qcx
X-Rspam-User: 
X-HE-Tag: 1776767630-79555
X-HE-Meta: U2FsdGVkX1+O8K7vY6/MMOYHLQsEqwA8zoNkMHqhFjMt6sdDjiaV2aQL41NHTsGI3movkgY6Zw8LTYWRbVLCGpRjUUC+x/khW/KjbTa4FwzPAiuMCcmaRjoPju6RqKVdzujldb+eCWvq0dOkY73TVsleRfr2pzXroLaEeXXTgoAt2O6vmpG0Oqz6PCuaCej+M7utgkyXrqQZKg/y4MGqL+5MeTPqRyaQKg5OC60yMyzQS8rlFaRrZ+oRnDzFLfRo3cLI+u4ZEsuuJs/KVg8nbhXB9IuqIdYM65WydaOxB+LAPutkO9tlm+ShrC6AS3FCBVY6rVFnOWQ6kRniNnbkDInrvZYtNI8P4j+4pAMRkVb9c2WOzR4GbqnRh0k9CjMRUcmz4ZyB/h3Lt5IgAcVqR4/4wWSflDWpU1KNepLqMbVqXKIPjivq69WP3X0NbH/MVm2diIVhza1rHtlpZtPFtFNlOWB/6cUabIROxvqkpLEMG3W4J5Wsii6pfUR04vyH8vObT6WRn3ooByLOVQO+oFxPcTeNkcRsF0L3fDp+sXr6JIvRzXcdabDwK8O1B30N3P2izdmee1HLI0rmGKReM47/lSsObS0govMQ/nYY+6v6nXfDhHJxaiiDtmritnQVDZasbbplKKBMvYDMsSSaMsXxNhe7/eZzg0JMx2+l/d5904ao3Wy4r84HOuh31zjr/nNOU9QU46Qt5HaGhGpwWMDlYKQLAW7pitDxosoztr73u0aWjl2ETuF1n58PCG7Qd1b6WabaF8gFVxA0+orVj9kqO6EpQou9AM/edyxrOmGTA/zMnkaxodU/ds9ADuSWjisUX5R48S9qOU++TNqJ2nzox5h+1aFvY2mkaDMZN36uH46whd3+0M1HIM+5vvbZVTgIU25X5CvPj++oM6z5fblxY7zXtD2v7whVIhXwcz/jaefdQq2T2cIOwjqrQvheQUDzrfDncEXmEho/fPS
 j8lhSSf+
 eVXkD9E1vjjz695a/3BMOtdn2euXd0SyljWPD+dNVgfbTqhF9Mru7jbK3Aml32zI1r1rTgAShEAwBKl8mEWf3dIZInfC09nKp9/fIptkfn/3lhwKjmzo+ooVnsIg/yP80YsFg7nIoFAVYcRuzCLpskhR9REvHp+qLhX/UaWcB15+jjWgq/yVGmR57uagRbL0X4dvcpoIjqsWbVls0T+eiKbmZMDUayLM/F1OimxyKqB5vFcI8Kq/IR07y66ngCOkjZeC9GA6fBcmi2yed3uXpj+PSOVI1y6hsTiq1WqHH6phZOfaLfRvASsS8e5GI0jd3NBpSOT5PR1YAqArltYd2SoLt0nTEG1YNLel1hhgRibXxncNVerCaybIfMPrngYG5rWHwhalTuWzD/qUL1f1zvimRjZDpoyc9ciCu9QWsdNW76HEDKfsJVbKLMAFdvtx1Rd8ZFkLRKPC5oGUkDSgVp4gtCGsJHRy2+oJJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 20, 2026 at 03:15:11PM +0100, luca.boccassi@gmail.com wrote:
> From: Luca Boccassi <luca.boccassi@gmail.com>
> 
> In userspace when managing LUO sessions we want to be able to identify
> a FD as a LUO session, in order to be able to do the special handling
> that they require in order to function as intended on kexec.
> 
> Currently this requires scraping procfs and doing string matching on
> the prefix of the dname, which is not an ideal interface.
> 
> Add a singleton inode type with a magic value, so that we can
> programmatically identify a fd as a LUO session via fstatfs().
> 
> Signed-off-by: Luca Boccassi <luca.boccassi@gmail.com>
> Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> ---
>  include/uapi/linux/magic.h       |  1 +
>  kernel/liveupdate/luo_core.c     | 10 +++-
>  kernel/liveupdate/luo_internal.h |  2 +
>  kernel/liveupdate/luo_session.c  | 91 ++++++++++++++++++++++++++++++--
>  4 files changed, 98 insertions(+), 6 deletions(-)
> 
> diff --git a/include/uapi/linux/magic.h b/include/uapi/linux/magic.h
> index 4f2da935a76c..4f51005522ff 100644
> --- a/include/uapi/linux/magic.h
> +++ b/include/uapi/linux/magic.h
> @@ -105,5 +105,6 @@
>  #define PID_FS_MAGIC		0x50494446	/* "PIDF" */
>  #define GUEST_MEMFD_MAGIC	0x474d454d	/* "GMEM" */
>  #define NULL_FS_MAGIC		0x4E554C4C	/* "NULL" */
> +#define LUO_SESSION_MAGIC	0x4c554f53	/* "LUOS" */
>  
>  #endif /* __LINUX_MAGIC_H__ */
> diff --git a/kernel/liveupdate/luo_core.c b/kernel/liveupdate/luo_core.c
> index dda7bb57d421..f1a63ebe4fa4 100644
> --- a/kernel/liveupdate/luo_core.c
> +++ b/kernel/liveupdate/luo_core.c
> @@ -197,9 +197,17 @@ static int __init luo_late_startup(void)
>  	if (!liveupdate_enabled())
>  		return 0;
>  
> +	err = luo_session_fs_init();
> +	if (err) {
> +		luo_global.enabled = false;

Please use goto here and on luo_fdt_setup() failure to handle cleanup on error.

Other than that

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>


> +		return err;
> +	}
> +
>  	err = luo_fdt_setup();
> -	if (err)
> +	if (err) {
> +		luo_session_fs_cleanup();
>  		luo_global.enabled = false;
> +	}
>  
>  	return err;
>  }

-- 
Sincerely yours,
Mike.

