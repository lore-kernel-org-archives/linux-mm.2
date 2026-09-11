Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01E8AC88E4C
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 08:56:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 074866B008A; Fri, 11 Sep 2026 04:56:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F40596B008C; Fri, 11 Sep 2026 04:56:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE2786B009F; Fri, 11 Sep 2026 04:56:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BDDCE6B008A
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 04:56:32 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8491BC0163
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 08:56:31 +0000 (UTC)
X-FDA: 85200875382.03.B8A5856
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id E58B2120008
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 08:56:29 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iEaYaema;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iEaYaema;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789116989;
	b=1aEn94Kjlq7vIgMzQNqm4bzM0f4k68/SJPDp2ei3qVmRdkCU7gDgH0b8kfpJVBCD15YFzz
	SYB+RtWivqL1ku8tnhtsXqHuYWQaJNUGbviTBFFTaL+EwsI8k1fW8YYsPUI30N7P97OX9w
	4y4knwuWLMo0W0H6rjba38B/tXJDeTk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789116989;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/WaDDKNNc6/toqft5LhU8Mh6zDSp04ZStewDOUu/aUk=;
	b=h93ENnaNbgi/A0ab7vl6dGIbU6kDf9uyPR6F/FpFv/1fi0V3bNpiswpn81rZd6Li+tdWF9
	VLDaeJ28SDYgg3gT2ex38wUO/k8SsAxBdtemSBsLcc7wIKyvXYHAEAXMIvKHTlECr5c4cL
	bNaWTNnMtKcSItMQOWB17mB3rCt+s8Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 668F0601EF;
	Fri, 11 Sep 2026 08:56:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3400A1F000FF;
	Fri, 11 Sep 2026 08:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789116989;
	bh=/WaDDKNNc6/toqft5LhU8Mh6zDSp04ZStewDOUu/aUk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iEaYaemaVOQVIEiuIuyeU4o2CEj75uxtoast6xBeOX0e9UhqlRymB+QkPBrRZKO52
	 rDWK1PyOLr419iF3FIMslO5HYA+CrrF7zBiG65M6paD6WXUeGYCBkSpyokJnNSyzNs
	 TX1F+/uGrVFAu8eUAUlNw19+taa8ax9yo+luoJp0XN/BvxtlXR6Z0CgC+c5Y/JIijR
	 KlcciGKdRBXrgNziRLrPiayL3uYyBf286+OXCK6zgACnc0f86yLJVdmrWNXc3OLbDg
	 X7cjeohnbhBWw1L4kcpRFeb/Vl/BXEKz9l2yjXvX4UoNXZE/2DQ5dxYT6LF9mb1/UG
	 UBSr4FuQ13Rqw==
Date: Fri, 11 Sep 2026 09:56:24 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: xu.xin16@zte.com.cn
Cc: akpm@linux-foundation.org, david@kernel.org, surenb@google.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] mm/pagewalk: delete the unused member
Message-ID: <aqO_memM4BIbFAxf@gremlin>
References: <20260911160421076_KNXun8Mpp9Xj7fxHG0i7@zte.com.cn>
 <20260911160725440VlRXkblhz6f7GJgQfbVv3@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260911160725440VlRXkblhz6f7GJgQfbVv3@zte.com.cn>
X-Rspam-User: 
X-Rspamd-Queue-Id: E58B2120008
X-Stat-Signature: exinfs6ukkod9nmzq94icujtpchuc5k7
X-Rspamd-Server: rspam01
X-HE-Tag: 1789116989-895880
X-HE-Meta: U2FsdGVkX1/DfpYg7a60gOXZTk5mHAZZM/k1p8OdByEuYE+ieLoYeFp5PK1cwUkzGWewaxLM+SeTyMon4NdCF4Wpnp8VKXj7z5uGHRo4MWtPHXJEvgOmBDYtYsjRQpmekft7N1SPM/Qm6l9fWnusmxUfBLkUmmspj6uuCfD+QAeRLg80ivQdSTYCrEIwV9wVQeXnBSXYHdWHopyWXsUKPFNEdTUzqIBRQXKb19ViHeS6d4lOmzstqCcgQLolT1h/+viTPOOjGn5a3KerBZcBqKoRRnm+4p2rgdPtL+ASsebiE8rHnLIXV+3U2Xuq5Pp35G3clO4h8vV9K/DcddiOkQtew/pftH/SbdRG7Ykbz5Xo3SvWPcp1TP1H2ujKFIBwG3JWBQ6MNwJYkRK+8XRGpNlYZD5sowLGaFrAzAAOSdsP60pu5toE1NoiKKzperXsdX0mF3jMwp3lcJSQ3hS9fkH2P5X8UJrI05S9eBo071r/VhpWtBeU1aQMD5ZwcQQj67QxaIr5WGDYtNCMtJEIzEdvvHLrF4DrdUFsFbHdSmC+q88633QGT9k+kyKModqwdxc+eOzrGnGKrmFa1l3yEImW55PcehbbgW2XzumFo/BB4LAk7awSeq64wW87QCCTCJwsZNUbPkdgMys3/NJt9TAkMAy4OFsgh827fR/Un1WPgKLafzFwb/0lf2djA/Xi8rN1P1WqVBlDMQZHYNqTpAF0zsxRz0gYFnmhGnTnXiIfg/UYxp1eWl4G+z1w9vEE8VyUXAYCd9Tpvcs5b/p5AV6Pxklh5YczAL+15zcGUNh+2T+dFdBMsdkaXBkiMAlTNfPYXhlfLuX0V5mKzFYvkq7ILVsyY6aRvjC/pIq+jMR977Rg549RUJaWe26P0VeKNrq5phcorBbWwJHRPsBG0UISD+kSVXZkw6fqsjSBYljXqJQzYL+QU9p8UY18RYqfmgWOiZID0EKNC2GAMdb
 jyPh0QrG
 Zf1Px8sOpK6LTpQrQGpzLRuC42jDAhGXAl9ys+xMjz5mr51ZOvRD3OntKfacN2qHZjPK9p+7w0oLx6dqmfopEcWSpvqPOBKaZcjKO/ucuRHybRlWnlC0Y+/xLq9a1YcA5H7hJNxdsZkhLu1adiVpJcE67hGZENYLHFi5yhdZRpFxc3QnANJ+lK4Fhxlp3NGeZj8C3RBsk0JtzE9Hfy1UNHrTxTH4hOZH0r+kwAP86EVDGYN833R84xD/ulIIDUAEthUHaO9k/GEIqKamWvVaJdOex4gtp4OEza50MMurypQmA6fGYLWMMAV3mzQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Please fix your cc'ing.

Cc- everybody on every mail.

You cc me only on this (1/4) and 3/4 but then don't on an mm/rmap.c change in
2/4 when I co-maintain rmap.

And 4/4 is about use of VMA locks which I also co-maintain :)

Just cc- everybody on everything...

On Fri, Sep 11, 2026 at 04:07:25PM +0800, xu.xin16@zte.com.cn wrote:
> From: Xu Xin (ZTE) <xu.xin@linux.dev>
>
> The member vma has never been used, we should delete it

This is very sparse. Can you back this by talking about commits and how the VMA
is actually used? Have you audited it to make sure?

>
> Fixes: aa39ca6940f1a ("mm/pagewalk: introduce folio_walk_start() + folio_walk_end()")

I don't see why a fixes tag is necessary here. The struct folio_walk value is
kept on the stack so what exactly is the point of treating it like a fix?

> Signed-off-by: Xu Xin (ZTE) <xu.xin@linux.dev>

AFAICT this isn't currently used but I think I need to hear a stronger argument
in the commit msg before I go looking myself...!

> ---
>  include/linux/pagewalk.h | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/include/linux/pagewalk.h b/include/linux/pagewalk.h
> index b41d7265c01b..1c397be0d092 100644
> --- a/include/linux/pagewalk.h
> +++ b/include/linux/pagewalk.h
> @@ -183,7 +183,6 @@ struct folio_walk {
>  		pmd_t pmd;
>  	};
>  	/* private */
> -	struct vm_area_struct *vma;
>  	spinlock_t *ptl;
>  };
>
> --
> 2.25.1

--
Cheers, Lorenzo

