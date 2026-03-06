Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D890F01828
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 11:47:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F101A6B0005; Fri,  6 Mar 2026 06:47:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E92E96B0089; Fri,  6 Mar 2026 06:47:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9F196B008A; Fri,  6 Mar 2026 06:47:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C9F166B0005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 06:47:20 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6EAB45921D
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 11:47:20 +0000 (UTC)
X-FDA: 84515462640.01.02AF53C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id D214640012
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 11:47:18 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jtG5q1Km;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772797638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vg3mWkOsCcwlQzS14ppgVVZ8A5ujChwfP+Nc14eW4E0=;
	b=Tm291NLztXciedr2mUvDcMPH3ktkxmp+XQV7f3TuQ3qfVQA2+YrQpoFi5+xmuvgSSHZ550
	CBdqtoBPKbtmPLXYUPZEQ+muMg/C95pbb6U+8n5yiqudUcvuQ5zX5Idn0UKikXitNMOMqd
	0xXntkm4i5G1gKpn1IEhtg91Exb9i3I=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jtG5q1Km;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772797638; a=rsa-sha256;
	cv=none;
	b=HZ4W6ucEtrvx0S88409+37t6KGMfe6OSNDjZtQv85vHS3zMdu4N7JhEHuECpiEwu/NvmHx
	v8SlRV9t1zWcU+HyG0L9zga5FGIvpDNtiiY0n7OY6wZh9/CHW0FoJ55mpO9r0pPo0CIQKz
	msIkEX2lyB3aZ+BR/H0rnOKskdZajNU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 62AFC60130;
	Fri,  6 Mar 2026 11:47:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67D7FC4CEF7;
	Fri,  6 Mar 2026 11:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772797638;
	bh=kbnOxVHTjFYd6MSQ8SErV2L7U0l7wedWRtqeP6pVGNM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jtG5q1Kmhn+PiJvu77IEI5k0ykpPF+SufD+T0RK3C7j6I7QQ17C2IGmuen1U8nYRm
	 b3Lhk/JXIdAc3islBwH29Xocsb8+4tn+EgEzCkprsPUUeI3MhlnDRbPSlaFmukwOBt
	 FZ+OHGYUaeW+7iZW9HG/+lHyzQAtXU3a2T+fnL6t3BDk0Bf6yEDJdpH0OacSpKnYFV
	 t36vomE++uL7rxAt0adEDM7e8/jWJD1lahv/XAdrygKC0DVPPcaY2oCu9aWomez1kB
	 eqtgTk93RVlAQZhy3V47DBGGtV3WtXS0aLYcKmRagjBld6svI18OkhcwPJSCIiUnbZ
	 B0ddPMgsNh+Mw==
Date: Fri, 6 Mar 2026 11:47:14 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Miquel =?utf-8?B?U2FiYXTDqSBTb2zDoA==?= <mssola@mssola.com>
Cc: akpm@linux-foundation.org, david@kernel.org, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: fix typo in the comment of mod_zone_state()
Message-ID: <cfa8f6a0-bb8c-451e-87ac-7e37a277220c@lucifer.local>
References: <20260219234407.3261196-1-mssola@mssola.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260219234407.3261196-1-mssola@mssola.com>
X-Stat-Signature: gumftqcijface7e9h7qytca7emd1e3xg
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: D214640012
X-HE-Tag: 1772797638-963189
X-HE-Meta: U2FsdGVkX1+7xosxTx9cG7OrgNGejMNJFXD16qR8JK3qwf8lI2tEzn6n1G/9N1mxUY8OnQcdIGxiP6UmJixKpw+zDF9rR2RpzJA7ueY0IHjSPkoygY5Pxnz71ctGYb7o5PcGpbzoBA7g+NbTE1oM0ClPLFp0v6KumehUuit6yWs9bS9Ia7wDnxKDB4bvv95Og2UNMUUR5bLU0yudo7KDZ8OQJIbpxELt1+YNIsyGIy+8tVPmbtUYwOMcfbsvqr3xpzs+67S9cGWB1TJvvnRVYmJeQH6FqfP8aT5u8TJ6P7pmhfLLkoOpshl5TGcwVbvARouFSh4BD/mJkCK9wWE12kbJPShzqAEw6xwxSRjQWsiiT+DtpqqwHzr0eMbNHDo2edgj/bmk/g9M+3NY5vcry8BLaNrt5AkKqU1RpPOvlRkh4KuWyWP2hqie/0BGw4XAl5Yzv33D2RmQgIs1WUy974oMHSTNgBh2/J4GMi5CiK4btVnn30PGDmeRk+5iTsa9mhp+5aImRye4mzTj/jc401t015a0/4J+oM/a3X1MAXB6Elq2PcF6vUrWABF2Jzo8r0Xn1hdlBRrCt7kizUDw9Q3eptblu16GZkMHCQroUfHmNcykbU2TGYfy7jRVxY+sYr4TwvnhqM3XamcWoYaGn/hrq+iX0AZp0QPHY8nmIsWvp6mYWSmcapQk9fIB8rg8ELajkkIfv79v7QjkKbTSOQbbb7jj1LuNJD2SfJglKd4/5SVV1H4jTyU/ZetJqxm+b0bA94dYw/DFcYabn7uBWRsKtKmSzd2Yn3m3QUHzL96Zt73Uz3kqiGfBkQdDm9kWK8Iup2p1cSUpc6LKtYTBS2pC2tZzZ3lHlsS8P0vcUQPUnYKQZ09BxZyjqQ2ttOg1a5aMAtwYCt+Jdbvcn0OXl3sP2J0e3ZRcwTyRZBd+Zv3f1JKsQlMOYfPZum9IVI7tNVJJcMZI/U7nTqyYpkA
 p933x4MN
 yL0Aj3GuT0pt/q2tUBPKS0f4LkkOaXYkKy2ZDLYsMdkLGLXfDOdqGrsuj7xqKZCuhsDY/WZHwEnd9yqTty6X9AgatD5MHoTvdWELteJK03SFe3Ki503JYDumWLp1Ma4UjiVGm8fbFsv5bIGvXOExuuAS7NAPgqeeU6zrBcIJGjE06MyWNwloEralVXpra6pp88FQZfGKI03yHO+UKp2yIOG6hvF2Ks8NVz20RrmtWS//ag3pLloSr/nZiB4DYeYOQcTHW4VRdm1frCFEBn24FXgU2hosV5WJXDypaPoCTBO2+RimfOR68AcdOsAYWvaT2G9v1jW26uQuXzEq7opblIbrO4scoISD6vZ487J8Z9hKF6oAmEwvwe+LSBw5tdGQMolwzHh6owIu6g1S25Nb9hWFUlg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 20, 2026 at 12:44:07AM +0100, Miquel Sabaté Solà wrote:
> Use the proper function name, followed by parenthesis as usual.
>
> Signed-off-by: Miquel Sabaté Solà <mssola@mssola.com>

LGTM, so:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

> ---
>  mm/vmstat.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/vmstat.c b/mm/vmstat.c
> index 65de88cdf40e..f69225122768 100644
> --- a/mm/vmstat.c
> +++ b/mm/vmstat.c
> @@ -547,7 +547,7 @@ EXPORT_SYMBOL(__dec_node_page_state);
>  #ifdef CONFIG_HAVE_CMPXCHG_LOCAL
>  /*
>   * If we have cmpxchg_local support then we do not need to incur the overhead
> - * that comes with local_irq_save/restore if we use this_cpu_cmpxchg.
> + * that comes with local_irq_save/restore if we use this_cpu_try_cmpxchg().
>   *
>   * mod_state() modifies the zone counter state through atomic per cpu
>   * operations.
> --
> 2.53.0

