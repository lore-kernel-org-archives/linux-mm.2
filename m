Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC0E4CD98F2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 18:09:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BC9E6B0088; Thu, 18 Jun 2026 14:09:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 846A16B008A; Thu, 18 Jun 2026 14:09:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70EED6B008C; Thu, 18 Jun 2026 14:09:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 402BA6B0088
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 14:09:22 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B08721659C0
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 18:09:21 +0000 (UTC)
X-FDA: 84893820522.26.6C8BA96
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8D26A100002
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 18:09:19 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="RVZ/1diT";
	spf=pass (imf05.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.179 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781806159;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MaFteEIwkz4tq/KigGnjClWvDuo1M6hpghzWE22jDHI=;
	b=B5EBzuPvfEEp6mHFuBzoNwlksBFcxrvpoirHf6w5KIVVGp0AWdBJwgH02VbnVG61aJVqIe
	a1n6i+BUPJx3N8LP8MosxAq8N1HevewRGOFcOGTLyJ0AhoPhF7p1zFqpmM+czjVzY9ttSC
	sDuSBYIR8u2+4/9IgD5zGiefpu0hNaE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781806159;
	b=7ji6nwBXA/ZLtWBExoAhK1nDwvGDMhBuOW4H4MgQhcYFiigtccve/0LBqyIOJOqB4ScSGH
	zjK/gPN3zsxdQrSjg/nQZcGFAFzZKWvkvV6Kg3Tm7HNOkWBxxTPvTbAl+G2bD7Mxohix9U
	BZlF+XRrWfvYhy/L+v/IrbNQ2PFxYME=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="RVZ/1diT";
	spf=pass (imf05.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.179 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-91562bf6c12so157518385a.2
        for <linux-mm@kvack.org>; Thu, 18 Jun 2026 11:09:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1781806158; x=1782410958; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MaFteEIwkz4tq/KigGnjClWvDuo1M6hpghzWE22jDHI=;
        b=RVZ/1diT97KAPBfTcm0cy+GZYLZzK8NBlK5R+WTUM9luPPCATm7IVgMmNF0oJ/RfJL
         QXNsUnStzc7qbmQJZ4U7lYEtIzSSYHS8RVW4u0wzGmmyWO7G375lMWqlPUFQiY0xwYNw
         uVuoIk6ENT9d8fPnPMnsvl5IehrSu3X1cy67abYGV07OK91IJTDBfeYg2DdOEvYqH+yp
         bkJSNSVQApPHz07eVVdpwXinW/meim/JEvyFfhPWh5UV2T/HY+t8B96DUlF+N1EaATVi
         cfGBk2mNsBLnSVaigdrJNEGcOW1KnHd4xQ2CIQIUwAtH2/CWuDzzw23AAF4jg+7ZodUZ
         GytQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781806158; x=1782410958;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MaFteEIwkz4tq/KigGnjClWvDuo1M6hpghzWE22jDHI=;
        b=VOSxZ4jcQC7F9fS1H4bYYRoznAkzaMHQov2DowUJCD0VMgWK2d1NYxUmHnWjdYOpRH
         9K9XISXUL8QEWDpXFH3xHSzsNllTc8srNk+SuwpEt+lbTFaMazTIAA+oe9O0M5KiSrt4
         XgOLZnQcUtjpNFzNWToOMmuRPg3HUyp4XzHri7+RtI2Htdap6JLVOiqKUglwQ567O97e
         kyt7rIX0ZGUgqqFL3TGrmrvJ9/YfzBe+HfWG43i3Fo1damHdovHoKAjT+MklffGOZwHS
         lcmlIDoH7HKP+QYMz4rSynbkgbvjgnFVeWQyDBFf9gYxlnhv6ACKE4ZWxCcUE8t+B5bK
         qghQ==
X-Forwarded-Encrypted: i=1; AFNElJ+hXqNOZaY32OY+BxwDXrXuDPb52kw/bC9r2/XtAOaE/CdR/F1DDzWXh86Dyk6v2Gn4Om+QXflPrg==@kvack.org
X-Gm-Message-State: AOJu0YyNiELE1MyxbrY8vymBWA3dWUxhw44AbLmJg70EbkNpVA728DAF
	yXI3qyFGCRL/JmCBBHRw0XxklIUSBVN/HIGXaT1BgHPXG/uDY8IBGeizZ4siYfY+JTQ=
X-Gm-Gg: AfdE7cnNKpM60QKoOsf/DC41+nAkntezx4HYBYsqcJUsON0v0jYtNz4V0DclmQJoFFZ
	cFhKs2SJBfJh8U0VbwPoU6jQhRFplnCMTcY9Sd4trVwxAcEKBrdLJd5KU6nvwAxD7lKXtrYiPHR
	n4Lamvf8JDA7HLHPKofKDKjpujPbpYT5Ad0DW8d2w+gcyTqzqp6x0+af6StpEEJ/MpX1S8pM3RT
	jQGqlKz5kZpqncCFFX/b9yp1UeKPMmdveu+VdFA2anOCTqn7nv08PSsSmkw6j+RmzM1zaeXoplo
	ufoEwoN2O86YO2ig3O8Xw2BCiaU7f46rWQQhg+WqyYzohw3tDdKbe3xgG6meh5etR4wGcSuF2+u
	gao/ZIDCM2oApHKY1qKYmFr3kwdz8sv6ZMFa7F/lqwvqI+Q1k8Q0ZEKZoQvPN1c7hSrBj5od18C
	26wLDXs7NOR1E=
X-Received: by 2002:a05:620a:4510:b0:915:eec4:49ab with SMTP id af79cd13be357-9208f155b0emr10475785a.51.1781806158503;
        Thu, 18 Jun 2026 11:09:18 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9161a00598fsm2159106285a.31.2026.06.18.11.09.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2026 11:09:17 -0700 (PDT)
Date: Thu, 18 Jun 2026 14:09:17 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Ben Dooks <ben.dooks@codethink.co.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/page_alloc: don't build vm_numa_stat_key if
 CONFIG_NUMA=n
Message-ID: <ajQ0TYGpgoojPOEX@cmpxchg.org>
References: <20260618100614.1321950-1-ben.dooks@codethink.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260618100614.1321950-1-ben.dooks@codethink.co.uk>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8D26A100002
X-Rspam-User: 
X-Stat-Signature: yt5qb58r3kouagjfogm8ztcpdwfrunwx
X-HE-Tag: 1781806159-568516
X-HE-Meta: U2FsdGVkX19iRQyGttS5mPufEYLFgYhf8OeSdI6RZR8rOO5CXC/iL8dHh2jfOT2ZKvV1pX6zWMZN1m7CHA+q91XPq+/PP+4tKdswbdYESgGJkLgmH/BlOMeebC2PeuM+Jk626017Otutn1sAzqmmNUU0U40AjurVaIb95pJ3n7kRNpScwUO0Sf5r9RphIVGw+6gRygMsLnfcY9tne0G+BAUwy2xagA4iKA5p19fJPgcSXjnCait8vl0Eq53SmzEyq49LD7zg1Di305iL3Hj97EdyGz5RqCh2M5q9n94C8Ym+kb9hvADXz14I1eDd9LQnsNKtzxkcVF9EorToNUpQC2/N9J4TMDMr6YKpMWe2lwiohBzSGBNsVFe9uYM0I0ankWmeKpz+kOwl8nEviHod2XvG4B8lRr9SvmPEQfQ472OhUJfCEz1xlCs25coRUVrEgc10Dq4WVv8R4mkr0U09op1avb6kU2FNWzz/ZzULOwctmmvTh7Buzf3tsN5AIsEH/99h5RLL7XGOKG6/iBHGKMjofkL5yZJtk2EfhRtC8E6EOAkdXzRPfw+smHOCF0us93BFkBsCdhSizcF4hjfs2GBzbuPdtZbMUYV3pfDL5GXeTFcWM3AZwPTGuNC34Rf7G8iPYfOoMS7xhVksWClZOrjs//BvNv8VkEwtYo7TkicUkejT8gFeaugQmo1deaRf9Tjtje13DTcQwMBR65d8n1m3mr4rSygqZDX0f1pHu8pF0YbIF/IJAsEziuydvrfNuFdCGpa2qGiRFIu3BS63rgHDUcyzAbwtnFV/jwDApoQKivbvDNMDTKa4W2rIe80fcsy5iI6CiGSfMYSnEYPEVHKCB5kDR+EZLBH2usxvLO4fwOGGOdAWxhYlvSXkq4Cq/2kjOESMwIO/2DH45tN9JqkdIE1oSgaq3S+ik96xLjuYtqU2fFB3dIFPlYRmTIBegHXdXfmhIS3TGrv58RB
 1Qs5kCp/
 h0yMEBt0dnRClr2/1l9xcOGMeXdcGz8iysdZVPKOwLDmYQH7lD+7Ln88BU4xbUCwb+Faozp2xZ7u9dLQpVdMAhgwLsUzMgM3ZuvggmlHpk41ThboYzOzijF5xk6QZaVhoeZ5zOgKn9tQ0EgxedhnTBiC/5Q7vZ71EpKSQONktycfMS68lWC3AAuu892GW1LxXMIElOu0zY/QB2tzl6qG/6wwt3mankBtavDPei1MOqH0DIbOT/F4z1HBZ7B9oxoXH1+HaioOT9M4J9xAIHXKdYFNJMZxm23SjA6BPDIB26PdkzFMUlpWfUCIVBMn+Eu5Q3xOFb0xZ1pnh+0cH/lp5gY5DL0sICk59NrrEgfxLYllCsTCXduwcwF7GcONx6HIKiPdvH+mQi9f9lC1cGC1QlWaUPMM2zB/jFUg7kRkeHqRenUdBfhMrIuqkBAX+7UwbbIGr93ouul4ZnXueGF2K7zPHBUQiYcxTfd5HpHqB991IRSLpTLeVXNVk2q2tILkyG9JmM4NF3BvKWYOKzNhewwATMxao7DL75HaJnh+6VzwJ0VPwvjuBOqHUng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 18, 2026 at 11:06:14AM +0100, Ben Dooks wrote:
> The vm_numa_stat_key is only exported if CONFIG_NUMA is set,
> so avoid the following warning by guarding it in an #ifdef
> on CONFIG_NUMA:
> 
> mm/page_alloc.c:165:1: warning: symbol 'vm_numa_stat_key' was not declared. Should it be static?
> 
> Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

