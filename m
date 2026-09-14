Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1BEEC88E6F
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 20:56:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98BCD6B0088; Mon, 14 Sep 2026 16:56:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93BC66B008C; Mon, 14 Sep 2026 16:56:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 851126B0092; Mon, 14 Sep 2026 16:56:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6B5A16B0088
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 16:56:04 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A531D140202
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 20:56:03 +0000 (UTC)
X-FDA: 85213575006.11.7F1FD76
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id DDDB840006
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 20:56:01 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=L+DwTAmO;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789419362;
	b=FHGfQ2TVwFNwDZYM7/bpJzWpnVQpMhGdZRg3iMm2e1Wps0oZ/ARl4SASWdc8h3l0gMyhX1
	HcIo103eGqPke1bg984uWi1fJyuA4TWouaJ1ympURFAOWXni3Hy9WjVoUtOKuwAb5y0sVs
	MTjdG4RciKrlFBA4uddKwTP3LNpN2KU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=L+DwTAmO;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789419362;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nk79wNuQLVKJISGTfB4drkGy2RkVZbAL8Hbrk3o0mxU=;
	b=RbbokiEaUiKEyF6sL6YEBqQ95WmIq8fTSN2SmcDN+sjPSiu62LREp9ERiwEwRsBDTHPpDT
	K+jS2emBYM0xr/dmgkWIWAkay2DwtZXNY0UA5ZiJ8i97UBECNoQAr27+emthktXP/or+mi
	pc+LxrAQl4R3FTruI24IFaYBOfmnbbQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9B56C43703;
	Mon, 14 Sep 2026 20:56:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 523C41F000FF;
	Mon, 14 Sep 2026 20:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789419360;
	bh=nk79wNuQLVKJISGTfB4drkGy2RkVZbAL8Hbrk3o0mxU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=L+DwTAmOmsiwqxd0pkJATpC3TvKf7ETZC9sqDV1KUF6GOsRBJl/6rj5e2AqaYPd9s
	 j1O7FwT9NTjquPbzkR01Sdj4OoYRCBX6FJ2oV40VGnvDbh+PTTS4NNVTUNavX/8i6s
	 Rwf9w02HDKaPB2e3Mid61hC539BdlFmdbvdspcdg=
Date: Mon, 14 Sep 2026 13:55:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: david@kernel.org, liam@infradead.org, ljs@kernel.org,
 linux-mm@kvack.org, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH 1/1] proc/task_mmu: remove unnecessary inlines in
 function definitions
Message-Id: <20260914135559.5784327913c6247fcddba4e0@linux-foundation.org>
In-Reply-To: <CAJuCfpFoWjM61tFLiZ79ufr7TLvWBarP--nmtHCm7OdiY-95Gg@mail.gmail.com>
References: <20260914190631.3167420-1-surenb@google.com>
	<20260914124223.3ce35057f35313d7c2a6254d@linux-foundation.org>
	<CAJuCfpFoWjM61tFLiZ79ufr7TLvWBarP--nmtHCm7OdiY-95Gg@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DDDB840006
X-Rspam-User: 
X-Stat-Signature: ep836rgr1mfqxjuhg1t3pqaiz9ioq8ym
X-HE-Tag: 1789419361-279696
X-HE-Meta: U2FsdGVkX19IYCMP1vZoKIz015c7f5MQT40QhsxB7XnguZvbAxz8JeuBmxg0xAquBmRyJ9ZLGnivrocYGtghPEooTNEsdOQa4FIzRaf2bWBBkWjXqjVXeL9wJVotQrohIEvVnRXW+Kg75MWGYnwwAgfz3Pvc3L2XVxhlnf8+80GqgGmqv4Ofq9C10eL8brKdjtRjsOzC3HvIPN5cyI7nN8ffWAyE0RXXHQW/uTrSML6ftXpx6bOZrnSA52TPmT4RtpG2Cp/+iXxiFofRuj9xkgLATDOF/FEj8BxcX1QfFQTT3I8cNXNgHTjBT90ZUDbr65GH9Kh9qHmMAIv3jAjiWAramZqKE70WujgPL4OO0DSBZ0JQ+rmgmomMr/omArM1WYS8owryla8LwxphKK2JNAZ82xRYxpQSt5DlJQu/EmIfoMwuHT1wzxgX+FeNVebKR03n1DoQvKKO9BvA3Qpt9bFNrYUcT8228dC7UIWd+ap/i9Ys8aT6r6zjRW7qxmJlwJPNd9pb8aSWcIZ4GC1Zqsd0EcRtJJVoGBl6iNn1q2iJa+zJe3dSBQvuJ+6I+L9I3o04V5mrjM1f2mUxieJqIeEt8CoXST0UXWoQmZV7Sy2Qmq0r1+mdgqeqGqTWyuzoYZ1axbFcqjv4cPoTfFYwH1afXd7kp4rgd4iKQRf3HnspIE6pXDyKRLNZ4voqYL3cMqf0YdjdH9XXx2kCESRtkc2FReJfyonvJDV5Ofvmw/FzNqkpi53kOmru1Uil3SZh5G34X6Zen+mKOXrAzb79YBgdIi7QzFeaXTtY5z03YxXWGz8Qme3Huo0rFIB2rdgQAVrTNM0sPQ7B1E4L2D09VRQddsRyozyiB64dH0iPh9ktA70o9Vwahe+420tvcxnznNrOSwUxyHOdrpPSbDIo1WOalFkLyYwzp0yZozo0Ru5kScTCHYw+sT7jHq9NZTEBPalLq81JOCM9up8JOKz
 7kMYTNaZ
 303BXGoR0QrqTUJd6i9vaAvbApD8lVNuH3wTBygq4Eg0cUqswntGu4OAljVWIRtUi3f4R28r8MoPJc/sqnqWqDSY0tEEYQ7wIQewQcSYlInx2BnUor2bhXmzVe32RAkMrb95xr+8aPturSx5hD5wVvtzqQjubiupNXeRznOTOiRwXdFRBI5CVRPEIfOntYQicyh0I319E4CyZiClZnyBKLit1zA2oSYnSnZ1MrMwDVAihlp6Sap91QJy7i+nPL03W4JnWnor9h+mPnyYkaz2XtZDgD+duKoHc0UrMS7usgmjsMVEH/msuSG8aP+/rLvrxrp1XnQk2W4hV8qpQMULgilQH3w65z+/5v3XVHSFwt2c5D/GfKKnCTILAqVye2TJiZqy4tKuE/TF3T7jLDSwFJgJs9Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 14 Sep 2026 13:11:52 -0700 Suren Baghdasaryan <surenb@google.com> wrote:

> On Mon, Sep 14, 2026 at 12:42 PM Andrew Morton
> <akpm@linux-foundation.org> wrote:
> >
> > On Mon, 14 Sep 2026 12:06:31 -0700 Suren Baghdasaryan <surenb@google.com> wrote:
> >
> > > Uninlined drop_rcu() and reacquire_rcu() functions are not used when
> > > CONFIG_PROC_PAGE_MONITOR=n. Exclure them in this configuration.
> > >
> >
> > But there's also
> >
> > fs/proc/task_mmu.c:133:12: warning: 'lock_ctx_mm' defined but not used [-Wunused-function]
> >   133 | static int lock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
> >       |            ^~~~~~~~~~~
> 
> Ugh! This function is removed in later patches...

Yes.  So it's a compile-time bisection hole, which is probably the
worst kind of bisection hole.

> Should I just repost
> v5 instead of fixing up in different places?

That would be best.  Leave it a few days, we'll survive.

