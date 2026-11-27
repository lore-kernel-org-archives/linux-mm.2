Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8725D606A31F
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 18:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bcJ2KeEY
Received: by kanga.kvack.org (Postfix)
	id E90EB6B05B3; Fri, 27 Nov 2026 13:53:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E41FB6B05B4; Fri, 27 Nov 2026 13:53:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D09666B05B5; Fri, 27 Nov 2026 13:53:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A75C86B05B3
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 13:53:57 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 25CFA1403D8
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 18:53:57 +0000 (UTC)
X-FDA: 85481798514.20.5DF5A4F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 84670180003
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 18:53:55 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bcJ2KeEY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795805635;
	b=67rBKCrHw87C07oL9V5EbcrklkDqLNvszmeW8XJRE12a5GTiVRA6jWU9BoXECodaM2FPgf
	t/6jJqIenseXdlpduFuqGBP9DwOxvYgszggvcypBbMCfEQoxRZBtcYM3/FAsllC8OjFq5z
	UTPTXCypHM8sYS5LrdTLzUmmH+Y58b8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795805635;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bsy9XaBxFwJHELGQ0D4AViTHM/99Y7dZx09auKzIQcs=;
	b=WojDuP3npjZqIMhCC/z2YC9fH3lcvkxeHzTzBocgs55zg8tlMv/X9l6MRHtRLxh2YTwx90
	kqlo6Bp0OfYQMqGnrjRG5kkVd9ufVeDf9qmbLdMa/Mcb4xTsWPB02a6FMWC/4HVwW2e0vz
	gxsWkbnoZt1AWUoIpWzdBbN4Xyhqj3s=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bcJ2KeEY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C57DA4557A;
	Fri, 27 Nov 2026 18:53:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C8501F0089B;
	Fri, 27 Nov 2026 18:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795805634;
	bh=bsy9XaBxFwJHELGQ0D4AViTHM/99Y7dZx09auKzIQcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bcJ2KeEY+WsprTbktROaNUEbsR9BdSkjKAKXmTnzIO8rFMTkh3iYEkaV3wSOVhdPv
	 gC5OX/hlyxEefTZSgjK2joNPH5JIFis886pxWGQNJdJAy3UUAR7RWnlhE2GEARioTR
	 Y9yfC04rXcZ8BKaCcC153AoJkdlYgwjCGt24JR/hLRJdyzTVYQxr+1ZxjYQiOuERC8
	 r5gzT1hqN2ZHAIuilHNnzEnJFYjbVref7HFe5cZ6csne5mQtNXzXAseZjZ7Ywgfvso
	 kgUOHjy2QEUKspiPnucDdGlpl/0/5ztOs2NdmIdjWme9ZdAuJYwAlp5QF8DAQ1w5Z3
	 8DCeNrM2sKKTw==
From: SJ Park <sj@kernel.org>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Minchan Kim <minchan@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] MAINTAINERS: add mm and block lists to zram entry
Date: Fri, 27 Nov 2026 10:53:46 -0800
Message-ID: <20261127185347.87793-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261127031658.2049871-1-senozhatsky@chromium.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 84670180003
X-Rspam-User:
X-Stat-Signature: 9rakagpufcnidf4mjrzj7of9e7qgimjk
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795805635-811794
X-HE-Meta: U2FsdGVkX1+VVAhzBzLTwguid9Qy6+glQV0lvw9aAEc4B+K0fzrj9Xid7Ko/XCOQuyM2OuuPcCcOmceOj98GiueenUi3ja+fmxRwg7qVIJljkieh3+bSCENfj0GqZj0QmavYA0e8flybRRMrGicK6VeaFtd0RP8wM5h+OBavJOwjl6GcY/XMsumbKtLeTMuS0uDenJgO/SPre3qcioPe3Vekc54cjqhD46eFLDOjwvlCLP54c0M8TcbgL8jeg2ykEJdz1ENxyFnAfgogHWalosLBq/1gxBsVAxpbnE35TqmZElcV+w3UreXobHdVI7lWwArUtmzhrjoz4hZ0xpqNJV6Vrggjicc5e+nsphkw7gVQg0wXkx48cAepguXx9knz/PyNdfalSedf3C5UoQalI8y8Mwj/pN0h+Mxd1ZQxvgeCnUkI/qwQTELJiegW0IvH0941M1kH2+dRk79sPCIPHDKYYOXAuo/236InhUHE1G5BMD4TYkM9ED/4weKF3Otr3Qk2npLNrz943d1lOErtjhwx8nS9y+TurppvfajYnBtYZJ54Nei+P4CRyq+EPqWZnj/S/2VGm85pl4jpvXVMO6A7dfvt4Au54c+CQ4COfFmMQrlawOF3lZpjmu1DSDkbHOiyY7386mCcICQ1WYDk9ruc9h0gI2qfKaSvkxi62NFfQuJgTdjOUJ9/4s77iy44zV5F9h0QbLMNHzxauZp+3t8E+I66XkC/7Qvx974RTwdfHGmeH6oPjCk2+EaWVbZXukb9SMzL9AmtsO7X9IbR3rVvFRB+SDTZC96B7Isv5dIKNYaY1PnowDnVk4V8Kbpx8PPORBaIpSR6JdFpsoZIo8ioEAaoVpfP5ZuLj5VZZ86+e1mYDz+xvayxoZGx/72HLDN7dx1szF4dgKU3ToU6QY7sptdi50gtz53PhBa3nk9Lyl0nZwpmN0N1ZjbA+GBExVjEGW7mGLSDIEmfQi3
 zEBdqhVn
 wt039D8XUwTRgkKS65bbDylGH/VKRiOSOEwgYDe+VJhSn2E1XZUKbR6BorZ7xwEhgExd6kyW2PHPw1C9ReEzlqnrSftqddeoEQDl3PlEHfrEjnrGfkS85bvLTmECm1UhZjZNbal3mWe148Plkl0D0pugG9mln2NBskGeORavd3rsc2u9MqFumOPx+dqJm8Ge7wKrXxMv0DCP0Zeu/2bgYRTYN4Ii8EzqUE3pgrymRo2IvQQqcU47pF9wPsOHFyxe2uLOEUjNKo9pVvuhCGcza10EcRHY+u5fKGhWma8m7LEok7vHkpr+4T12EUDUgxxi94K68pcK/tFDNEbLYN5YGIHefaXoiGmq6BOS8sD4wFog2Y0Ou+GnYk9tze901sYF8dp3CiupRJQQZqP4FBfJVYoVjhqdTphMalVRD76pk1YE/IzuRLHsmUX/b6lgg8YXZcz/B5qSoyfHVrANYLh6MJnGp56lFwCmVz5d1Gbuz7YodrcVjeiUykNvanDdiCe0b02I19Twdk3aLwMQeffjsMjsEjMPP6Yinb7U+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 27 Nov 2026 12:16:38 +0900 Sergey Senozhatsky <senozhatsky@chromium.org> wrote:

> Route zram patches via linux-mm and linux-block lists,
> rather than through the generic linux-kernel.
> 
> While at it, fix a DRVIER typo.
> 
> Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>

Acked-by: SJ Park <sj@kernel.org>

> ---
>  MAINTAINERS | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 68811a0b7916..3f10a5772b31 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -31316,10 +31316,11 @@ Q:	https://patchwork.linuxtv.org/project/linux-media/list/
>  F:	Documentation/driver-api/media/drivers/zoran.rst
>  F:	drivers/media/pci/zoran/
>  
> -ZRAM COMPRESSED RAM BLOCK DEVICE DRVIER
> +ZRAM COMPRESSED RAM BLOCK DEVICE DRIVER

Thinking loud.  I was wondering what is changed here.  I found it is fixing the
typo: s/drvier/driver/.  Maybe good to note on the commit message, but I don't
really mind.


Thanks,
SJ

[...]

