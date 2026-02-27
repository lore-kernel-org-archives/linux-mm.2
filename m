Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB1D3FEFB51
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 20:29:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0001C6B00EA; Fri, 27 Feb 2026 15:29:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC5E96B00EB; Fri, 27 Feb 2026 15:29:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD1636B00EC; Fri, 27 Feb 2026 15:29:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CC63E6B00EA
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 15:29:01 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 820CCBBF4B
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 20:29:01 +0000 (UTC)
X-FDA: 84491375682.14.EC19C8A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id BF5CAA0013
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 20:28:59 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=w1HTD9m4;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772224139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IPVRJq4S20e2XclCdtBzBYHWh1KwrZYuSzo7U3WLSnQ=;
	b=I7a9BavWYXUDafYr91eg1I4pRqP4azbkkNc3E/TihsjfcDVa6TuVPn/bBHnug7tgZCtxh/
	LZcwdqtbWDwUx7M5MxnNRoekWCbEum699uiAj+qfwWBbZiCVwoice6DxOZRZRj9JKfEQja
	Efa+6mvjyWItL4RuTqGBgzTq19VjBF0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=w1HTD9m4;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772224139; a=rsa-sha256;
	cv=none;
	b=w3Sa1eU0W1jj1MET3saY4nJnHjH+On6a7T74oGGPV4hDFM+Pd7lUItgRprbfEhIveIVQnk
	0JIQ5Xab++t5unI/Svts7sXGGV80OGjOKMUChay1SkBgMKmaYujbTBAfUsMSc4ez+H7RK0
	qMZF21SgRDh5OgWCBRyKWcxEPFcqZ8c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1DBC660137;
	Fri, 27 Feb 2026 20:28:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75707C116C6;
	Fri, 27 Feb 2026 20:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772224138;
	bh=lWZrAMHtw5UzETwtNfpRyUNcmqJTeG/3y3lEgOPYwFE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=w1HTD9m4xQJi4FjFB+OIdrFkPGm2WlFfCHgcYBPv4hKlcT8DILY7zKXKD7HqGG7cl
	 TiMrdS9wDqPW6m3wnxKWld3vmh4HM7BoW1J+7YDGPNYXiV/yidBEJJnMm1ra4suURX
	 R5NPnZEUdsyFcnh/YN+5RJth09f2buKgejmhCj98=
Date: Fri, 27 Feb 2026 12:28:57 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Benjamin Lee McQueen <mcq@disroot.org>
Cc: david@kernel.org, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/vmpressure: scale window size based on machine
 memory and CPU count
Message-Id: <20260227122857.dca67a5f281e39a3e78acc74@linux-foundation.org>
In-Reply-To: <20260227163333.6394-1-mcq@disroot.org>
References: <20260227163333.6394-1-mcq@disroot.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: BF5CAA0013
X-Rspamd-Server: rspam07
X-Stat-Signature: haszdw6gsc5oyt5ntthostwcyrdcecm9
X-Rspam-User: 
X-HE-Tag: 1772224139-996620
X-HE-Meta: U2FsdGVkX1+X1SM4ZnlwEY2UHqUKXT+7/mzTkqd5heBCMG/y+NX0K0NThDrPL8d6sgtaK8EYXEmbDv2acJZfVLKdcRXDE16ljk8wVm+R4myQVBDnKTwfNloq2kmVaM6C8IpA1wWa6/ybTgP8ukljpnfNU0AoMfEdZ6esvqM0b/2tjFozPWLkCWRG5M9xkmeuF8znmJKvlzSz13x2fX3F7aIXQyrMB2LeI+oYKumI+kdqF4fXLLEJwjYsWA/CbNMiBtMSf/tpPP8RsZq2g/a2i5defTMG7726lBxZMX/8dQOdqmSWIEcHcI50ZTgriKTsmeM+3J1Revychtib3CoL0TtBiVD6VG9tAZQXWUbMqoeRP4my2yK+90T+rGNe9ayBeNa6JOQ2Ddglm79cD47ZcBv5jAa1lxZ+gSVMEaJKEAQlCtxB6q2I6+iVkaB7wY4mKo7QgnltJ4gBJB0J8elCMOy+Ul5dZyW/jJtt6T614yvnH9i7oGkQY7b/k5zu0dT95fQQIlgl0R6XmihAQkjVnjTdf7Gqd2lQNCLiVg5DDPtNHyZBKqw86P+Hifl0FzuXnyoJZOHFZYzZIr/pSyyuAkUn/vXx8GmNCsA252iWrfvOjw57zMDosQw0Fx1uekDKoEcvUQXkUQOh5NCLekBPmG4wctY6s78EuBNWI4herWoRFXmQSe3Wa589Se+OYCE9zBn61wv27I4vuEXgTutfj2XosN2VotEAyrzWPtD8jJ9F+7VpRrEYyxdvJSZ/vdGs66b/iDtPkjiEmtzn8aB2gyRlIDR77XM4scoAZWL0tJtUckaRA0jElRS1huer5ahxcm48U1iEK+wcKaYOpK9n1mfEK0NlqSZ6BRDa7qGqHlz6dxosdfANX8IZnKnHKANliTFXn0CiiMvuqQl0GPz6HvZe4ZGc21e68sKxtzj/ShJHbthiDvYxMMZeLFOFHeYpxwPy1aykHVpzr4ANmAF
 VcUJ68x/
 sIygsQUP7dpF0GQbuYz2LD9wBtbM6M/xkPZusMONOG5Ejx3CZX72G9TprcrRpDTCT96a+C6NW7DzWsVsH1p3TSTO/DxZrxLAwgNldh2qUMm6K/By/JzlLiQI/+RjKuA1kwiqiy5jhtmC34b7aSRNYzH/91q0Cx9A2gCEiOCvoKhgrWakCPwdWK3Y2OxCYd7F0jVNa3ImQEj48iaDPXBwE+pqoA3XrNFWCXOnOPHZdDqrfyw4JPNvXHJ/XDk9j6LnNz6P7ON9GIHlHwIruX94ZgMCWTZHUfpRZDvtKJ3ezxTWeQMksJXTw6Y2HDA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 27 Feb 2026 10:33:33 -0600 Benjamin Lee McQueen <mcq@disroot.org> wrote:

> the vmpressure window size was recently fixed at 512 pages regardless
> of machine size, this patch makes it scale based on the machine memory
> and CPU count.

Why?  Presumably the current code is causing some problem - please
fully describe that.


> --- a/mm/vmpressure.c
> +++ b/mm/vmpressure.c
> @@ -32,10 +32,20 @@
>   * As the vmscan reclaimer logic works with chunks which are multiple of
>   * SWAP_CLUSTER_MAX, it makes sense to use it for the window size as well.
>   *
> - * TODO: Make the window size depend on machine size, as we do for vmstat
> - * thresholds. Currently we set it to 512 pages (2MB for 4KB pages).
> + * Window size is now scaled based on RAM and CPU size, similarly to how
> + * vmstat checks them.
>   */
> -static const unsigned long vmpressure_win = SWAP_CLUSTER_MAX * 16;
> +static unsigned long vmpressure_win;
> +
> +static int __init vmpressure_win_init(void)
> +{
> +        unsigned long mem = totalram_pages() >> (27 - PAGE_SHIFT);
> +
> +	vmpressure_win = SWAP_CLUSTER_MAX * max(16UL,
> +		2UL * fls(num_online_cpus()) * (1 + fls(mem)));
> +        return 0;
> +}
> +core_initcall(vmpressure_win_init);

Whitespace is odd.

