Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3E51C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 21:50:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9893B6B008A; Mon, 27 Jul 2026 17:50:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 939656B008C; Mon, 27 Jul 2026 17:50:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8502D6B0093; Mon, 27 Jul 2026 17:50:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5E1B66B008A
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 17:50:36 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D52811201E5
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 21:50:35 +0000 (UTC)
X-FDA: 85035901230.01.0B1B57D
Received: from ewsoutbound.kpnmail.nl (ewsoutbound.kpnmail.nl [195.121.94.184])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4EF5420006
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 21:50:33 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=xs4all.nl header.s=xs4all01 header.b="Q/sssTy3";
	spf=pass (imf03.hostedemail.com: domain of jkoolstra@xs4all.nl designates 195.121.94.184 as permitted sender) smtp.mailfrom=jkoolstra@xs4all.nl;
	dmarc=pass (policy=reject) header.from=xs4all.nl
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785189033;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tiFK3TTlaCYiiE/IomdbdjQ6Sc0CY9ECVbPojKqp1lw=;
	b=nEMRpMHOw/fyy/RJsM7Q10AyGWvgGNij4V47f/7FUKfGAGfjdlM/WnKzQmKTiHRUCB9LzI
	ZXjYd8d1YF94D9fk6JgLXEfF2HE47faNf121RWLrSzSeFGBfz1E3YOpegLr9s7ClPbpEDF
	2CKGqFoJVO0pP9hjRRIZLz0g7ckuRuI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785189034;
	b=QzxF+G2BCg6YW9YCez0B07zCI1tvh2+C8Wldtys/la8zvuvi0RP2CaEQAs8fCqxBSMdb4U
	8VvJ884HJeuVOQyqkbNHRHbx56l3igQHXPnr8ffAY0nfpngOZXJgQhT+vvIRmqEbnkkJ7w
	+e71FpfaipQPb7HZl5khSxEdmj9FauE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=xs4all.nl header.s=xs4all01 header.b="Q/sssTy3";
	spf=pass (imf03.hostedemail.com: domain of jkoolstra@xs4all.nl designates 195.121.94.184 as permitted sender) smtp.mailfrom=jkoolstra@xs4all.nl;
	dmarc=pass (policy=reject) header.from=xs4all.nl
X-KPN-MessageId: 2fc45d3e-8a05-11f1-a5a1-005056994fde
Received: from mta.kpnmail.nl (unknown [10.31.161.190])
	by ewsoutbound.so.kpn.org (Halon) with ESMTPS
	id 2fc45d3e-8a05-11f1-a5a1-005056994fde;
	Mon, 27 Jul 2026 23:50:30 +0200 (CEST)
Received: from mtaoutbound.kpnmail.nl (unknown [10.128.135.190])
	by mta.kpnmail.nl (Halon) with ESMTP
	id 2fc3648f-8a05-11f1-b314-0050569977a2;
	Mon, 27 Jul 2026 23:50:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xs4all.nl; s=xs4all01;
	h=content-type:mime-version:subject:message-id:to:from:date;
	bh=tiFK3TTlaCYiiE/IomdbdjQ6Sc0CY9ECVbPojKqp1lw=;
	b=Q/sssTy36sVVz87faAUW2EMPEeg8Dw7JOa7zgWOCVTwkLpxn6wx1nHjnR2l2jvuI7O89qab42p0Ue
	 IZPxjZnXpsYJhJE09yrwAhvueFZGmhPcQpOvA1b0GSUfKdNnOHs7Te7RhhJfK3hbc26U8kzrGJvLBX
	 qlo2YvPIq2H41kKVAUBmDHZf9ZHixFFGQz6CoaGP9f74k7nbsyyJTJE8vPST50U+1CBmma+wgWhR/A
	 W6/cyB3BeEWx957gjvei4S512kPmHXmITto52/ff0vR/okjiVtWZ9n4ULkn0UzcdsZTVAh/Gn2HkrS
	 EtCeTUHKL3u1B28LPk+v88v8vZK0ziA==
X-KPN-MID: 33|HB/HoxJj0hYkapXaKSN/+Q0tT8CdKeKsW/UneyZw+Lyc/YAk5O8/p/YagUF3XpR
 HLr4vumcMNOd3YFq4wqxOcCLfPPXMeALf4gfblHA82J8=
X-CMASSUN: 33|vyASR16XKcUQjvQKM0fdTBu+WGD3Gmz75nxiYE1v3fFoxg1nETf7mb46Tb2HWyh
 WwYSHstSl9fNLhJy/Jo+cmg==
X-KPN-VerifiedSender: Yes
Received: from cpxoxapps-mh08 (cpxoxapps-mh08.personalcloud.so.kpn.org [10.128.135.214])
	by mtaoutbound.kpnmail.nl (Halon) with ESMTPSA
	id 2fb7bed3-8a05-11f1-916a-005056995d6c;
	Mon, 27 Jul 2026 23:50:30 +0200 (CEST)
Date: Mon, 27 Jul 2026 23:50:30 +0200 (CEST)
From: Jori Koolstra <jkoolstra@xs4all.nl>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>, linux-mm@kvack.org,
	Farid Zakaria <farid.m.zakaria@gmail.com>, jannh@google.com
Message-ID: <175465920.316835.1785189030520@kpc.webmail.kpnmail.nl>
In-Reply-To: <20260727-zufuhr-wahren-couch-0637f96a66b2@brauner>
References: <20260710-work-binfmt_misc-locking-v3-0-a162f7cb58d6@kernel.org>
 <20260710-work-binfmt_misc-locking-v3-9-a162f7cb58d6@kernel.org>
 <amTYWb9X1B75lIdX@lt-jori.localdomain>
 <20260727-zufuhr-wahren-couch-0637f96a66b2@brauner>
Subject: Re: [PATCH v3 09/24] binfmt_misc: rename Node to struct
 binfmt_misc_entry
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Normal
X-Originating-IP: 178.226.150.234
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4EF5420006
X-Stat-Signature: r5ma4k393q6mx4gdqd8xqr1izaibiadj
X-HE-Tag: 1785189033-186663
X-HE-Meta: U2FsdGVkX18Y273c+Ji9P4zQKXzwGMH/raRCwte4QzE/Df/Lx7R/Un9ftRh0Q5NfXJIIQaulrmCirKsxNMSGxU39hxA8mZ/xDqiL7kTRPNMz8YXRWe2EwU3DvPpbl0TLLrGsFs578WK+8K0b59ZFuUZAejh/n3nBQmTkMdMgBSCRzE10sRGALa/7cR3eN/yux70SWXBHK3pRemEBV92BZeobieayXj7qWFWhxyb+Oe+WLqboWrgW/ANCUcy0yX42Oc0t/t6EsTGmoLqYqjTcgX/XHMw5U3pl2aLORp/lNc99XY1UxUv7rSiV/4GYQdIKasjLQ7WX5enFQUW0JGq/nLwWy0E3WD2DnWymFy41VBBjqV7MU3Q3vmAHKeev8IYsItbFEjbEfbwMsy9OAGfeRUhqXCts2ELSUIqnm0ZLZ6VbNza+JHLvchCvpnFFjZeA+v116PKdk68jaxMfPcV+Q6TUEb0J+7T8Pe8c5oyXRtEMga+jG1h4t1BZWY/fUd+HhcHDUaaebjt5qUDx/f13QMKNeScZROL9MKLB9IBnd3HjURMzMdmTB96QNwTGYA8xbjh4UJ6K40g9zShKhz/V04oeTnnYmvimOjOj+Z2mRJ0tKQdFj3kASuEIxDHFuhLLKnNkNpUQMSGfYU1QErCuAKhYewLoI8HJTBwd+dpFvOafiFrXHv8+dxkrgJmXDnTzLl4wuE5maXRAGBO5sRzUKpUkC9ptsfRbhVheVAFTu/IsAMfprBKzgvNJHmvRoNy7KOZBPQ0/3AoKqcvfS9Y8JcMZPbsvWRGXRY5llMAJJPTAd7Xiic95bAxo0eFiAv362UeY208ygrD5NC2O5hlsYcNqjn1Ie1igNU2wp2u+oK7gf8a9RYO6Fh/bjMmFFMM27O1FQIujpFobktiyulT23UCHO3MBf9QltOqY+IWeZsaTFyAPeajszuU75H1gyqweO17PCaUy1rNDVEt6xvQ
 kUrJOw0X
 FY/DMGx9EsZFl5ZLh7Au4cjYLeUAFxAEfr6yjH2deaw9gwtp/p4+JneNfjxT968KFvzj0dz+rI4Bmd/RRUVA8a4/+wxmM3d7/RqJoUU/nuZWAxOpwSNVsvt7DCqggsdtzTTlK3g6wwHVg06EMSdJhtHmYdmc6kUqhFwXdxeLkezYuQaUhE9IyJrWUuGozTsKXoFCC5erwkc4QE3wsIq2n2DHcUyTS+w0+YzSU9dhiQ5+ZZXSr7gws74UgQOrkrLhn676YH26l42cFCBOrRNVlY2w1nbmwFabRpsUqL9bIMLH5DFmUiJxaYG8XpnKxXuXv0DOnJsais3QQiooJjKqapNfro1WzyM4BCXbtqrmD/Y3M7zcDQpT4/0JhnjFkf7uG3q2KohENx10ZhH7kSmuUwFwwxG0YAnVO100AmklBIMMGpe4m+wrwT/FzF4kx7f8lGt4SItH3wvSu2hT7gfD9vf0XGYsLAvZaq/MEDCn97FnyJKRyqujwcIZ4a3tqnUmFDKEi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> Op 27-07-2026 09:42 CEST schreef Christian Brauner <brauner@kernel.org>:
> 
>  
> > Reviewed-by: Jori Koolstra <jkoolstra@xs4all.nl>
> 
> One very minor tip. If you review a patch and you don't have any
> comments other than you ack or rvb. just trim everything apart from
> maybe the commit message and place it directly below.

Yes, makes total sense. Now you have to scroll past the whole thing to
see if I have any comments. Thanks, and please keep pointing these things
out, it helps.

