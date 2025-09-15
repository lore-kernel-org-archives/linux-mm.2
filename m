Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68BABCAC592
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 18:12:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE6218E0006; Mon, 15 Sep 2025 14:12:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A960F8E0001; Mon, 15 Sep 2025 14:12:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AC5A8E0006; Mon, 15 Sep 2025 14:12:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8B98B8E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 14:12:38 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 31F03565FF
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 18:12:38 +0000 (UTC)
X-FDA: 83892279996.25.91E70B1
Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [80.241.56.161])
	by imf09.hostedemail.com (Postfix) with ESMTP id 5FF53140011
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 18:12:36 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=Vhy4i+tl;
	spf=pass (imf09.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.161 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757959956;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uabTcZlsJwj8cGPmkeFh4JkdU8A/qF5iN2gRJmC26sQ=;
	b=szktVWnP8qCZLAo2y8p4PsAZQwUISqICk7Q+uC46FwA92oi3IPW/BoInCqwjb2XIBF0MTB
	m6ClCgBp6br2azyqIukIrNg3QigSUuVf/3hYM/mU40bkdMJgcq0DgakyAvB+B+VeqonpIr
	cuUjIlehzuuOfBFhG9onaRe80hf58Fc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757959956; a=rsa-sha256;
	cv=none;
	b=C6kHpB3xTZpjChgQ2FcVv2ljPn4xE949G04RECCGfYWvMuXHLszStuTSzneKMq5CofilDZ
	92Afrcy1ypJ+hfOwZJOyag/TL63wytEtxExD5rxz9EFL69SfFhniSUmRcm6h4WYe1DvotT
	cyO+bKo8bNybZjzHzJIJZcjBI8WAJ3s=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=Vhy4i+tl;
	spf=pass (imf09.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.161 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com
Received: from smtp2.mailbox.org (smtp2.mailbox.org [10.196.197.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4cQY681cR1z9tBF;
	Mon, 15 Sep 2025 20:12:32 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
	s=MBO0001; t=1757959952;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uabTcZlsJwj8cGPmkeFh4JkdU8A/qF5iN2gRJmC26sQ=;
	b=Vhy4i+tl0RbgFcusaRlZzpZ5hXU5TXY11dM3DEki/OuRfjmIrMpqWEsyZHdnIdSa61k6AN
	AmhrTuKLfSuIZV8/TYGLkF5KPhuQmodSoX+s8wha0/xXCUqJPr0N/cbwZyd/BQA2eoh+e/
	ie5n2SLrHtv7S8ih4XDbLOXhf+QQ0dDAYeuqdw1pCSUE8kb3t26E3mtvDP+33grijYy0qb
	qNO8KkeWS2TVUWvotMa42zqUxi+qmh4K14Qt02Zf038eC+ZYS5OqergbQqlp3sQKU3gHu8
	GuPD+y0Nlu7oboyZO28Vzv+qv2aAYjBfPzqRz+oUioCkOfnrZe+TddAZF8MYsg==
Date: Mon, 15 Sep 2025 20:12:25 +0200
From: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>, linux-mm@kvack.org, 
	mcgrof@kernel.org, p.raghav@samsung.com, kernel@pankajraghav.com
Subject: Re: Any way to ensure minimal folio size and alignment for iomap
 based direct IO?
Message-ID: <2h2azgruselzle2roez7umdh5lghtm7kkfxib26pxzsjhmcdja@x3wjdx2r6jeu>
References: <9598a140-aa45-4d73-9cd2-0c7ca6e4020a@gmx.com>
 <aMgOtdmxNoYB7_Ye@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMgOtdmxNoYB7_Ye@casper.infradead.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5FF53140011
X-Stat-Signature: qjg5fuoj9tfaxpsmo5g8thpi11fsqj8b
X-Rspam-User: 
X-HE-Tag: 1757959956-216739
X-HE-Meta: U2FsdGVkX1/AMtngRqr5cczTptiuzrbdrcvg/NYkkvQ5KaCKrLdlWXojLq0nnWin1MQWk3Q3Zpl4/Mr0olrEgf6IrtmUBbfaaoEkl0MfoQ1g7Hb0FDdhJT4BcjSmEudqyMr8EMeiT3AlPUEqx/ts/edattXhFxqvDqiyzkw4KjYHTdpiKZTEIZI6aldC8Ze3C7fHG8E/bEp/Ohs3WiorIcE5SWwu/QLFMWB7Mvv86qYNnwt57qHQJfaB/rHf9kr7JVZ5U3JjmMMIjSdlRhLwGTACqjIymFwG7+No5YD+3A/bBguT2w/tGxn4OnmX7Z7WQtiF7sjbTpmWQ6+Uh2lgOL2Ag2THB67ub4Q7sjm+9FXRXt3DHtC3+oJJDcT33g+DaZe8VZE3sD5m7EXlfvimLJ7FSBTa2RpXn8IMHqUo40gax249gbQzocLrp7W9zjgedqzg3iKg3zakrukzpGhzxE5KRsErYiB4oXFmTDiGmZ+Bekb74Ozpcg2WEIvOM110jUmrzdOEkm5JSr8WblTjsWmPEHOTko2II+go2Zoj7yP8qifMoKvlmHXDINc8bfmqcY5l1Sv7jV/fYIiWQu4G3IP0TQohDZXh0AGySikaFBqXjx44fpkyzwZ0l06dvcjab7WCRQCqpmIDH/Ov0xLNXMhrM+m7llJ3kcF3IYb1whS8uNn5qAMMm4xtST4uCclWdFx1LnsYyKBjHm6/RtCf1sKMrWlY7UyKG0FTDEhuY+JqhH1QC4yyTlmpnqdcbwixhAKFLbDrLYIhwMEXV2WizpimypKw2xzkcIrNn4vII6uTt+/OLEMrTcR2V9eHo88421N4RSEEj1hFdo5/3eMzXXltr1PFzmmuFrrfXeKbD7Y04rSO8fGfF29qPvP8MzdbUrx9PlP42W1e8uGyJ+WzdC6ue19sEd7KRzAWzwCOxLT/yJRRHIPE+4+/TfOxSHVdwPQwhBTi4FvKff1aSKZ
 oM/ZS5ku
 vwBkCSAf18EFVMecTNfVrq24/iqOSB/DtE/bh3XyZH6tDqZ1NInouG8uRn4eqDNpTYtB/8GSbiEfKkJwq34xVM2ZSpPDwjjcHxJCVfH+W1lkriKxiEpSRcXkDz2mr1eKo2aKgEywtGqGQUeN7Sonwsv3QTV0p24hbrjKsPz94bWoyysQAkqcqddjlrRI1AhTtOoVmNCKinQD48O2N9icsk7+38MyWQ2npVX0IcX89l4XmY7wtV/X2b7r7MqQVFUvV3WPK0W+Y4FzAjVD3z0GtTgwdzuwLkY9Iu/yeEF8nrgmhS2ILelBwra3RG4A6h6LxC+Qoy0ZxD+Zejv1L/hOrnEej5eaG5CN0oOc1Nlhq9wJWUt1IoKwq4Glxjn2c/xFcgQq7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > But unfortunately I can not find any folio allocation for the direct IO
> > routine except the zero_page...
> > 
> > Any clue on the iomap part, or is the btrfs requirement incompatible with
> > iomap in the first place?
> 
> It's nothing to do with iomap.  We can't make the assumption that
> userspace is using large folios for, eg, anonymous memory.  Or if
> the memory is backed by page cache, we can't assume that the file
> that's mmaped is on a similarly-aligned block device.

Just to add to willy's point, XFS did not have this requirement when we
upstreamed block size > page size support. The only thing that XFS does
is to pad the direct I/O with zeroes if I/O was smaller than block size.

Is it very difficult to add multi-shot checksum calls for a data block
in btrfs? Does it break certain reliability guarantees?

Another crazy idea would be to either fall back to buffered I/O if this
condition is not met or allocate a new folio and copy the contents so that
it meets the condition of single large folio that matches the block
size (like we do in bio_copy_user_iov() when we cannot map).

--
Pankaj

