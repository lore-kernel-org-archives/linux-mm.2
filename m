Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6AD58CCF2DB
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 10:28:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E6016B00D2; Mon, 19 Oct 2026 06:28:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 069746B00D6; Mon, 19 Oct 2026 06:28:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E756E6B00D8; Mon, 19 Oct 2026 06:28:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C23086B00D2
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 06:28:30 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5272714061C
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 10:28:30 +0000 (UTC)
X-FDA: 85339001580.02.66FE560
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id BAFC31C0004
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 10:28:28 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UC8edqst;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792405708;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4qz8eMfz+Jo1KHqS+s17rqoQGTMxaqrvVFecgZkRitY=;
	b=tKjN5UOBrgJn+tPKRI55PTn+anWmuo18B0v/n9vxKOMKdcWJv+D+twnvwyR6oCtvqlCOaL
	hT7u6tR/DS590LLeIul90sxgN1BNyYsCsMxOlZAivPGPf541n3RH8G6K7aLde0F+xPwlku
	jsQUODbp4EGzTLkiQhW+A84MFAVufxw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792405708;
	b=fskg+Ir7VtDETgvSs292l3VCGSnx84/4xh1hctJ3UpejoLl7Admx82A07l+01tJAL/Kkgr
	55qK6yhMxouooRuL90wbLmiQ3u3Qqf7QoZX/RmtHj0ipOB6q7dCa8+e5+YeoRLz/frE6O7
	qgiXt5mNw2+F66YIYVGGogyyv/uTxtw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UC8edqst;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3E4EE601DB;
	Mon, 19 Oct 2026 10:28:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD15D1F000C5;
	Mon, 19 Oct 2026 10:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792405707;
	bh=4qz8eMfz+Jo1KHqS+s17rqoQGTMxaqrvVFecgZkRitY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UC8edqst7rNXAAiHSudn8cE0SpHqwN5mu0IRB3MwqLGkD4KLbdFBkbNH+63YAa1y7
	 aB2CGqfzuNLYUEeT7JZIUtNoEZMBSJ6iyAPTMSCQsYF4/AAHox96ASbSzDYTJW1dmf
	 r4yHjsTqITpUsaDtORjeVdJGfu02BatGj4FERcrGXxT/BNOIPjhqDBMeYE5HqSf9ZC
	 MJyzB67rq1gV2S1IuV8mXA0njjcPsR/nrwLbdxzV/KFU9Z0RF2UCMM20X0AkfD/c+L
	 zCM4jmT0i+R+hEmaGK6bIQEJ6Nn9LUGG32qhCE7uUShFSd3ABoWIUuoqKSaHcuh9H4
	 PhldKIEJMV43A==
Date: Mon, 19 Oct 2026 11:28:23 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: David Carlier <devnexen@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, Kazuki Hanai <hnkz.64@gmail.com>, 
	linux-mm@kvack.org, linux-sound@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 16/39] mm/vma: only allow mmap to clear
 VMA_MAYWRITE_BIT if not mm-managed
Message-ID: <atXvrWt6kpQDPy8y@gremlin>
References: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-16-1aa3c9b139f9@kernel.org>
 <20261018025905.201296-1-devnexen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261018025905.201296-1-devnexen@gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: BAFC31C0004
X-Rspamd-Server: rspam08
X-Stat-Signature: jgw1mrpbpyi8w9ptpby3wwauxzimrf54
X-HE-Tag: 1792405708-915295
X-HE-Meta: U2FsdGVkX19yfOUP7hmqJsJisNqQTxwimOC8ih9pWvClNDW2VuJLSW92X3Xs9UrWTH5QgM0bFTTUL/ORy9kRcwmRxcS+l8fLm++ahlIlxm3Tps9GnZJn2RM4Os0uqLr0GTD7AzPFe+EGcNyQD5vILTG3JBKT7yzwShT4bNQYLFzvBAhj8BSDOrJAGctN8oBcXnbYFMZKc1KmU19kG1chGsQNo8mPQ2N9QTf+ElJfds1CsJ/CrbReMGMctm+6We+LbKEni5oAdz4/hLmTE8bmQLYGKKDDrkBxNV2rqz1/BHKuVGQLBKXSg2DZI3tdBCrG6CCv55Ssnogq1F991t1GoKEA9VV3+LUxx/puC4f6RWpFvQQxaXXh67dTd75+FwMT8JH2fx/OklYCFO/pSNeQ6UPfxEwO1Id2IDqiFxMHZL0mGVvQtMsg6h8ho5V2G66JXGxp+4nCUYmpKDWhUCPhR5HRxph+0UHBfehoslcPLB20nrkyi0qtNvJm2NkpguroqHHjMnYFerSRhoYUvnovfXuh00oOphdhH14/Bey7/A1oHc7Wb+93pjAaEwydd+rPf6pBnx936y4TDw5lt9C8OPwTWMfsgTCH63ASUN8jJHJf1Pfz8G41ukXHO6UdyTgAUp/Q03IWRhAxFvDB5Qy98+rD+EP/EKFF8U+Ci3y0sRAnTBg9d0X+Zz5e7jRZIaOsn1+WVbQyelMQGbwWEehMGMiLUUp8nUqfHzxB9A4a5nz8PqBuqiLK5k/IkV2886jZ76j7Zihh1ANcnuyCiCwPsMiMfyuMXy5I/sC7+P5jbwfnF7y60xHq3ux9DM0FA2Dr7yCSd6IfBuFTbnHg/98I2mMyAX5Yu6sdYYly4eTYZxZvE3pcv7Y0Qic4YjznQfxbLlsurLh172mcbfdsTxjiKsOTHCLO9rswVfVnGzr6CB4E6GUc6kkQJYkKnjbUTV5UdUZ0MuPpFj+PGo3z7p5
 1nZ1HKEJ
 NEcx5CwlabrwqM+gEUdcuIHxvmwTo0I6kyBGHAL4g1rqZa+O6t1exl3jZpzcuLl3Vvj05lBwqFYJMK6yAWVRGEIR+uaDj9tlGxfl6Q0ViGWnuJrxcXlnQjFApXmhj+ewrGDEb7n+RAtFs6ZJKgSi8h719xzffMeDPsdhYFbNNwJd6xrv1/IbXZ+kidSCyTb8WuIvegDwBpRlk/51sx+2tG2+xsYwvENufq1p/Cjt0XdsD69HmdRrGXy0yVmA2WSfH0ThIGae+2Ziils+zsBLZkYLEWYQv2NRum7U6tatAyzUlRq8eTPq9rVUNy1JfySZOqz07Vqi2tjs5qkosveVo0ZfBJxNOvNhQhSrNP7Fp/HBpxEyEEzRQYfaEmQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Oct 18, 2026 at 03:59:05AM +0100, David Carlier wrote:
> Hi Lorenzo,
>
> I think one site was missed: usb_stream_hwdep_mmap() in
> sound/usb/usx2y/us122l.c clears VM_MAYWRITE on the read buffer since
> 71c610aeb177 ("ALSA: us122l: Prevent write upgrades for read mappings"),
> but sets neither VM_PFNMAP nor VM_MIXEDMAP (pages come from .fault via
> vmf->page, like the PCM status page in 13/39).
>
> So a MAP_PRIVATE mapping of the read buffer, or MAP_SHARED on an O_RDWR
> fd, now hits the WARN_ON_ONCE in mmap_validate() and fails with -EINVAL.
>
> The VM_MAYWRITE clear is a security fix, and the VMA must stay
> expandable for mremap(), so converting it like 13/39 or setting
> VM_MIXEDMAP seems the way to go.
>
> Found by code reading, not tested on hardware.

Thanks. I will check it. Somebody doing something broken as a fix is fun.

It might be better to fix that with a separate patch, I don't think it really
makes sense to add a brand new patch to this series just for that.

I will follow that up.

--
Cheers, Lorenzo

