Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF21DC624D3
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 11:34:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4FB46B008C; Fri,  4 Sep 2026 07:34:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C00196B0095; Fri,  4 Sep 2026 07:34:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3CA86B009D; Fri,  4 Sep 2026 07:34:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 946BB6B008C
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 07:34:27 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DFF76A449B
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 11:34:26 +0000 (UTC)
X-FDA: 85175871732.22.DEE59D0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4A6C840006
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 11:34:25 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nzkp3ZVc;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788521665;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=irC8j8xyI52ogOtso1++Qi9/+5gUDfx1IlgeyjWZd8U=;
	b=2r4dZbueRKppNX2E1sLfGzXAzwltHYNHHmj3IAI8dpV3VyiMP7H/mqsYUboKMwUuYce64c
	xJydVoIGAYkGCt08nqlUTCRacmVUPKrU/r5MTycrs4l9hUSAqP9I3xKFAgHld0mec/Vf03
	7Tcvc6A6+uAgsOaC1BIZupAJxk8OfkA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nzkp3ZVc;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788521665;
	b=h4CgZBLS6GBmt7MMANaBImbVtpMrkxsLAs7FQ0mV8fT58FOeLA5Ede/l84SSvgtjGyzdGX
	SNW8W5xYtzo3O7EZBKGAQXI0zdVkV47WqYXXDQgPFS8BEQTk3Ceu1DVwi8v/y7a7hKtarS
	KZbHF3RphCnH6pjhPYnutzTmhmvYBp8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E1C8E600CB;
	Fri,  4 Sep 2026 11:34:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3B011F00A3D;
	Fri,  4 Sep 2026 11:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788521664;
	bh=irC8j8xyI52ogOtso1++Qi9/+5gUDfx1IlgeyjWZd8U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nzkp3ZVcXRWVGT7XHOMyRxt8+0ITVEQaF3/yAsfIY52CIlEeeD38VYIVsoiPTdPpK
	 LYGEEUmcMrq39qXvBxe36aR7HE0WZeXZTkAMi46r6/78dFey1SdJ4bw2ZUT6Meywcz
	 wBBFmBgjCCV/H4bOZ3CqMpgJjEduw893/Dxa9LunTuNQ5+YTzsbfRe9qrTBT7/8AFN
	 Uky9dOfr1JpMb1DWTQ6jex4a/NEuMCxlqEGuHmBNxOmFQdqilthCHC0j2IlgcHJt8a
	 K9j6LN3qosAhh3fnoSBoevUOqj+2RlEojSNItcxcK6DMP227Hw/lx77U3McTksGjdH
	 VsJR6WtgZAZNw==
Date: Fri, 4 Sep 2026 12:34:18 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Hemanth Selam <hemanth.selam@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/5] char: fix typo "funcion" in comment
Message-ID: <apqsko2qanqFBmb9@gremlin>
References: <20260904104854.25272-1-hemanth.selam@gmail.com>
 <20260904104854.25272-3-hemanth.selam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260904104854.25272-3-hemanth.selam@gmail.com>
X-Stat-Signature: i3btftc4t7d161ntr48o8f43xtw3u7zz
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4A6C840006
X-Rspam-User: 
X-HE-Tag: 1788521665-746960
X-HE-Meta: U2FsdGVkX1/5/PAYNoi6vPtUguCVoVs9EzflPaOGSkW6LJBUfZFd//lLpfM46u+R1nb9HNZtWhTeDMEKCShhJlB1ssc8IlubCMqQju/ik258XLTYXYzyQ0Y2Hk3dnTYvbijRjlTcKI9GNFoqoXlbrLUJ+0itw0t1D85Ye/mwKoQIoQOo5XtASsDXJNeGnt5LIhdFh8OFzaee0sAovrsirsuzzCcp6Qd/XPUf+EAh/RbD8Jd7Hz5vQeB8Y35YbtSrQcbJk7flZkJ0CKY9aPxnWkfinQl+HXiNFTJvZH7FbQZcnd9HFnwCBGRzsYFsrFcgv6fSZLm5L4vyWmp3uOCBrrtGbTqu2hx2VQSwUiDzisbK9dwS7aSR98TLni1J3Efke7B752s350voypjI13RfHOwt1AKeJYC+QTl8mMCw+5lGzD++NiEthF9DV22HOYy9UnXV2MNriHKpKt0xuvHhxOstljnLfbTR8y1HmdTs2HLXHpIStPJVu8MdsEu4G6IgEBVPmZ/5M6EozOazeOJM5eS5h4E1/yoSS6GAp0t7SV++juDHpMoSVvl68A+YIr62IjyJoYnM6e2z43ElGuMx0iyY44NAQ4N+K3CEl3cQDz0zUvPPOnBR2H9F8IcvKcSG5pvoXUoJMoym1M8K8VMM4vT3CY8nl8jHTL2XYscvT7nzPHdhkoOMaVb/Vg61gmS6Bz3X2CxEpWQlaAq6PaIRY+zmNBb0BsfNNW+VGdq7EsSX4cej5qQTllR9/myZ+Iu39X2ivdvbo5oE0t24fHpfTl2+w6sBhS4/lt0hyNdGbae6zaRcR+riDaowZr7JljuFKHQR6XPcXwrDRXeea7l5kQczkxaWtdnvagKA1l1YRp17enoIjZhzrggENbcWS3XqAZwVV0ay6pUgToItaM9XdF6GZWPs+BYsNfly0aF8h16BJilHMgTpTWl2blE/Y2oXRQYeg51VliEF5r2IPFk
 nc+xnqBc
 wpe0xLTHF/8Nt+QNbDGpsXHYAvUtR+6MdjQ5nX+26ycIFc5K4Ugd1G59gvKgV0/jDKIZ2dGSQJCodY0GvfXIFQpMsqnx4pFOV2W9apAD9NqTwRNygRLq74GFKN5VhRmJbHb/EkvO2wSSIf8xKtE/dTn1Bjy3Oyq5JP860kFozFpVSJrGLizhoxj/iRs8DtRsYP4vNCogA1QhhkkAeIxgQqlBL3xNpweZ8vqHIPhkVnAYvVZvISxAnL8M66B8bXVB+D4MsPY9tJld4U+gIqdUD51hWGnst4V4eLJSoRbd1vVyCxQ3phTTiS0lR1nBjrIDyovqAFOENCyo6v/DSLv24S3SPiZ/RbvOslkCetVUFiaknDeDm5uI+sfVocA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 04, 2026 at 04:18:47PM +0530, Hemanth Selam wrote:
> Correct "funcion" to "function", reported by scripts/checkpatch.pl using
> the misspelling list in scripts/spelling.txt.  Only touches comments, no
> code changes.
>
> Assisted-by: Cursor:claude-opus-5
> Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>

This file has been moved into mm/ in a recent series of mine, but I guess it
should all come out in the wash anyway one way or another.

Anyway LGTM so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  drivers/char/mem.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/char/mem.c b/drivers/char/mem.c
> index 63253d1de5d7..f9db486d7029 100644
> --- a/drivers/char/mem.c
> +++ b/drivers/char/mem.c
> @@ -76,7 +76,7 @@ static inline bool should_stop_iteration(void)
>  }
>
>  /*
> - * This funcion reads the *physical* memory. The f_pos points directly to the
> + * This function reads the *physical* memory. The f_pos points directly to the
>   * memory location.
>   */
>  static ssize_t read_mem(struct file *file, char __user *buf,
> --
> 2.48.1
>

--
Cheers, Lorenzo

