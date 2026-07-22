Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E8B3C4452D
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 00:24:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AA896B007B; Tue, 21 Jul 2026 20:24:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45AD66B008A; Tue, 21 Jul 2026 20:24:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 349986B00A5; Tue, 21 Jul 2026 20:24:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0C68B6B007B
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 20:24:24 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8F0B01A02B6
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 00:24:23 +0000 (UTC)
X-FDA: 85014516006.04.DA2BEE9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0AC5B40008
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 00:24:21 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CsQwnhxv;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784679862;
	b=bJxRaXxslccs27hL+0vQWLlRgriCmNTBz86j7vq913sPhS6XZwCzrH/j5PDgT0u/OwVTCR
	geioFhDMIKCoNdBcYrQ8JTGaLeti8dif6/WfUk61AdlpomjhMe56N4PHOsPY21dzUY+ZVt
	WPerwjfLK5jYAKjXnXLP8v2glo5EWPo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CsQwnhxv;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784679862;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q6ZtWwJbi47KLhDRmMnb3Zg0qJF7lKRh73y+5hGmLLA=;
	b=X2VSUDyvNJSya+fHBad7xtEfdv5TnQuxI+XAYl4PcWCcKlPGX5v/nlZMGYwFTvxdexyOWJ
	NDoYd0CTx2E0ABKqFFtNzsdlBoxnY5YMpuN2s4cvSK5qYshlCFrQJUITGN/nYhDBYJ1WTz
	rb4GjFcfTZAAzrUrA7AJnSSKc4+FITI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 526B9600FC;
	Wed, 22 Jul 2026 00:24:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 841AF1F000E9;
	Wed, 22 Jul 2026 00:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784679861;
	bh=Q6ZtWwJbi47KLhDRmMnb3Zg0qJF7lKRh73y+5hGmLLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CsQwnhxvA9ZxgnP7LaXEJ5c08PoHAPt5HJmn+V6skPO2tfujGXJ6CKOqHWRbP7+p9
	 OPGHvE5TkjZ72ku9JRsfH8kf3eIFg6d8B7FqF9o8fdjr0IZGpIbJC2tRnC6ka4cw8k
	 iaqjpCHCwIeGNnbEV4ryMLA6YvieOzBntxqnX2XyCjLocDz0oSX6EsThdrWsZUWi2o
	 a4q0Xxmv3ygqWXxuSMpiofmUsufQ5eRpq6TCOt7duWrklyXo4bckfupvjsMaIXolET
	 1Bzd5Q8yIPDfCnQaGwinQCSTxR86dUESSm7cg5nNY+wIJW4RrAy5lD82/S246r3DOd
	 Emd/JHIcRtRdQ==
From: SJ Park <sj@kernel.org>
To: Zenghui Yu <zenghui.yu@linux.dev>
Cc: SJ Park <sj@kernel.org>,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org
Subject: Re: [PATCH] docs/mm: Physical Memory: remove deferred_split_queue
Date: Tue, 21 Jul 2026 17:24:11 -0700
Message-ID: <20260722002412.150464-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260721111919.22923-1-zenghui.yu@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0AC5B40008
X-Stat-Signature: qnqafbst35zugpojtquhtm9xtrezmotw
X-Rspam-User: 
X-HE-Tag: 1784679861-631949
X-HE-Meta: U2FsdGVkX1+TK2j57VYsIQVjTV3aTcGQrZ43OiBNTVzcc/J1mGvKA3ONwxiBaMxz8sUNZ+XrImpPyVpCrQYD/C7rIHhne2sz5VT5ha5is3LK134v7CFplSmhCpqxCnNlUgUYTpBOuuzvFF/xZ/bgNAZaH+MXGYeRDcTEM+8YFr48EP2m72FEtM2t9q75FjrYiEvoy32sFaquhJ+j62/xA9StpTSMg2s70wODDY7KqjYZ3twNnk+ZreX84Z2sr35c3gy8jSwVcS8D5bqRButO2v3zI837lUwN1adfWrJXG9p4uzFwlfsW/7lk4N+RhKFlKj7k/YAYMsc7tgOCzsL+Vsdz/m99QnnXKuYQVLsJGjxwHfXyQ/xjHByyasmWe+yh/WWHqqUpcMErtTgRvP8G1+K+iLPWHvQcaYF5hPY+3Kk9ahwghHx3A3Gl4shPwGCY/l/yM1uKm69HquLePKcrtJt6Xns0kagd9Wa0PqKUWIN9DghBE00Ks48Al7SJ6P29nE7KWwidEeh8sYO5ktYbzR2+e2B+wISOUQ0KhEFVYlqPUEcta90NPLIpLEhe1F7s5nDjwhApZKX0wI0OR6mjOFxaCZpl5kN6k++Z5QB+Ku0GICVZm4SvXzQJR/EGq8INnZf+cWz9+OiyGIZm8awLTLBNFKfYtMoxcPaLbdrcbVR+5XRXG5TSkNyjazs4+xR/hekyKp5RSym3YSTQ9chl+Z0xVhwZf2lVt22p+wWhiIoYpM5XAF5VhI81hK3S3gLMqt+taC9LnsSmU+pmBxej+2sBCP/PWzNGOw+Z3WR9Go6RTQGgXH2zvBi6+MVIei85lIyrSo5Wg75aC1rEVwd78XUlT5nm64GggTD1GdpsykX7HfvTcfpJiHfj82P/MD14Wy38F5+PVnApvQy0HjEfieXbuDFGcIzcHoCuttiywM2IrO1SPYJaTIshb+Hd4U10WFU6RkIpsvBaxR0aECz
 eYN4xZXG
 7UwGjJMTITXAbX3KD1xL+N5YY2xs9QQo59ph6D/T0uM6q1UFx6RgrHFsaG7K5M57XrtyDCdEej5mNcStE0+9S38QPRFuseG2OqZSOVXFYWN3Lz7iBeV42VUI2HjIUXgzkz1GcfnMokegUrEfSRz81AVMJ8FDxRsOJKkmy/Z0aIkbHPLJWqAJI0+VIZ1sYvjk91AzVZEZ/T7HFmWTHjilryadUNxIatcYiKc8VT4CdZC6JOA60FRXaN5+Yj+94etA1L/tr9Pcu7KifggQVXQ254tGC4HV0hYUTTO8gQCMucwHjhFr8NI96Y/nE/HfKV2FcF5uv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 21 Jul 2026 19:19:19 +0800 Zenghui Yu <zenghui.yu@linux.dev> wrote:

> From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
> 
> deferred_split_queue was removed from struct pglist_data {} in commit
> fafaeceb89a5 ("mm: switch deferred split shrinker to list_lru").  Remove
> its description in doc as well.

Nice cleanup, thank you!

> 
> Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>

Reviewed-by: SJ Park <sj@kernel.org>

> ---
>  Documentation/mm/physical_memory.rst | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/Documentation/mm/physical_memory.rst b/Documentation/mm/physical_memory.rst
> index b76183545e5b..a09407d72973 100644
> --- a/Documentation/mm/physical_memory.rst
> +++ b/Documentation/mm/physical_memory.rst
> @@ -262,9 +262,6 @@ General
>    PFN that needs to be initialized. Defined only when
>    ``CONFIG_DEFERRED_STRUCT_PAGE_INIT`` is enabled
>  
> -``deferred_split_queue``
> -  Per-node queue of huge pages that their split was deferred. Defined only when ``CONFIG_TRANSPARENT_HUGEPAGE`` is enabled.
> -

+1 for removing >80 columns line :)


Thanks,
SJ

[...]

