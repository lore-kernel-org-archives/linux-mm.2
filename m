Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32B9C606A334
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 20:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=S3HWZSdE
Received: by kanga.kvack.org (Postfix)
	id 4AD6C6B05B0; Fri, 13 Nov 2026 15:15:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 484DC6B05B3; Fri, 13 Nov 2026 15:15:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3744E6B05B4; Fri, 13 Nov 2026 15:15:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 10F7D6B05B0
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 15:15:32 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 95BC1802A9
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 20:15:31 +0000 (UTC)
X-FDA: 85431200862.24.31D5784
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	by imf11.hostedemail.com (Postfix) with ESMTP id AC17A40006
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 20:15:29 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=S3HWZSdE;
	spf=pass (imf11.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.45 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794600929;
	b=jfqyhIY67EgxQI2HBV0HjHEVr+Vy3O/3oJ+QEi/X6nvgoR9rOQ+DrH7D5AE/dlZ46lNCqw
	A7AXPd0UIr9CpxtAYlfDcp771ziQN023FTyVwu42ef0QkeUB/Jdy+G1v8o5MMn8ne/Slfz
	pWxdfpmcK55STmJBeNfy0T3tLNF6PWM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=S3HWZSdE;
	spf=pass (imf11.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.45 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794600929;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8H+CWUGQzI4Qy2wQthU4p5PCrPJHw0Bm8PIx68UYiVA=;
	b=XazMCOnHmCyE1tozyB2lS+QmpG5asz6lZkG+zCvrRpeC1+gJH946mZ/vbSLlPJO2rPp8a5
	Afyn64s/gi/Ld5nKwSZZWwRzjG4Gli7ecQmmJutylFO6ZU6xdhoL9c0E86Ge0/mkUphsHH
	GYY6eaEtb71xRdgi7ye9o/7LYDW5syA=
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-91f2b826fe9so15711716d6.1
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:15:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794600929; x=1795205729; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=8H+CWUGQzI4Qy2wQthU4p5PCrPJHw0Bm8PIx68UYiVA=;
        b=S3HWZSdEq/62FsxKOIPw09wTW3IeiInY6vrHxR3z6TVesJVyOBgMqv1gQARMxZmgPA
         ILXtoq1MNAAHRXQ+HdlZ5tEmQM8/Aj5sLw71+kZ//LP7/uad398lIwSsCnkVeY7RYKUF
         valW0K8bhwW0/iLRvUbIG86S89SfpAzPYdhQhBvjp8XMidlFe0AHjZLO63x8hg/jH7tP
         C0cxK7ON0OYn95Xa+HVoRdlGcsk5XVIF0GwcAnXysUtT0x0o+N4MXQU4l/DQGWv877B9
         XpUnGcl2eh6OLs1eAIehkqUXOjSLacnFwqEKEvwIjxM8YAMLTB+k9XAEPnmNfT6+svTj
         cCTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794600929; x=1795205729;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8H+CWUGQzI4Qy2wQthU4p5PCrPJHw0Bm8PIx68UYiVA=;
        b=ns/kIEEae82OAw+FOoE34cKbES77hmBmQuHtv5sGriCb72wXW6tgqyaAGXE3ZdRXbu
         4S3djxkZjhTyhZjy9mGnl2w5rpPc6GB+5uje5TzuFfoUxOiuIjqIrkiEXfBW6E2VK+Dn
         J4t5eBnebLtmlKRmiKuga5mY9CpG5ZO2LQHOZS5n86F2wTOpE7rRJn9QHSyMj2DtnO/o
         7UYEFocaO7m/Xhxwd2dwPyVEyRRHkwRCjvK5Ycb1qTLB96DENtIbnKAWlxBixnTV6EBd
         Oi2j9P2WyKaFnBY3sJcHUKjANwdkhevuQ5npJ/B7mz/e04/9eElA2/M0HNwrHS/l+PKV
         4whA==
X-Forwarded-Encrypted: i=1; AL+hErH8dOq8Q89O40o3ABESV2yi7YFZ3w+D7HquHCPKro2U0GLYWHupWcdHpH/v8hpabvaraHtNT77EFA==@kvack.org
X-Gm-Message-State: APuU4Z+357BZM5Wx0kqHzjfTzqlDMFcCKup+Cb+UDMN0CHFhImt/7Jxs
	jcOeROvDiOEKi/hmcJXNQezn1N4B3mFRJf3O6L40lQH5rAMpFnHxxhIGggX0b8/P9cQ=
X-Gm-Gg: AYBFou3iaXCAJYQK5Myik/8+Rxl3rYBprD2toxYT6wfbFM5UZ7/rl6ExsgcIbRXv4KZ
	Afpb4U4lcfl/HbfPCanyhgL/aXUxPexSnuHAwZVCyChXfsiuaDxjjlbwH/vutKQ7zx+UxIijRql
	CZw130vxiKMuwoGr4IIb3mWBwgbFVbUiqMGcnDtiNjYjP0nmXjn3bDK8tLK67o4PegZVt5R6FUN
	8EJEo370kNMaqogda7y+iwvkR9bwUZbxtoD9AEscJgdosTOEhIrVRTaB0Ftju1Y1PhFnOeNVSTE
	tHal67ZdPgT8eGhzHJz+XC9xLSCt/Oziplc/7fb89jNQl/fdgLXD9hscqGAOfjHvCEm9wM1/q6e
	pcRX5lAdVUiPmyl73qGvWDna1PjiSocNiywIgciEtlb6TSw4rZAsMSf0IFwMcMLcKxEHt45xGj0
	6JtdHxetHXfTC+hNfdqLjzxVV1oe/i43uhac0JH8lHlM1NaNnk7oM+OYQd1wzgyL9/aE2jG6dqc
	cygV3pof9RsbCFzklWb2f/sAfLMjrZF2Rwq1YQjRolkLRMh+39NSxqZa6M1nAoyPpDH6FZi7kTy
	DV/kcbJaTuFmNmf3r9qTcc7JQ+HXSQh4uhGSGl/YI2llehJIyY4C/1Cb4X9bSOgoiHACqUFdL4h
	G/Bk4EffGVZkfekN0ZRbFB6yyymxI
X-Received: by 2002:a05:6214:1d2a:b0:91f:17be:7c90 with SMTP id 6a1803df08f44-91f2424c199mr58365016d6.55.1794600928649;
        Fri, 13 Nov 2026 12:15:28 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91f23da6adfsm27424366d6.36.2026.11.13.12.15.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 12:15:28 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] mm/hmm: reject shadow-stack mappings
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: "Gregory Price (Meta)" <gourry@gourry.net>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, kernel-team@meta.com, jgg@ziepe.ca, 
 leon@kernel.org, akpm@linux-foundation.org, david@kernel.org, 
 kas@kernel.org, dave.hansen@linux.intel.com, bp@alien8.de, rppt@kernel.org, 
 stable@vger.kernel.org
In-Reply-To: <avdrZ716BHN-JLc6@gremlin>
References: <20261113195536.2660763-1-gourry@gourry.net>
 <avdrZ716BHN-JLc6@gremlin>
Date: Fri, 13 Nov 2026 15:15:27 -0500
Message-Id: <179460092754.482102.6921125310815388864.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Stat-Signature: 9phpb11ea9eoo84y77ix6qxcqpgwqibu
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AC17A40006
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794600929-293944
X-HE-Meta: U2FsdGVkX1/lASxC7jet3dFd5dLI6rBrvwaMHgaggOwCyOzDeap5vwYUZtVz7psgUETBiGEK/ZrPZsZ3l0lDw6+huWWBqGcme9WynbhNm/0eWecb360E4VqNEb45fDPdNNnHfyg/nbzZZVQwgPF/E9wHuOtPr/i4Asr/e1g/sy6cBbdhZLCLc7G3kabq/3M+qPhmQ2QuEXWEtLWjuKdScDIXTzH6468HELkq0rLI53TRdQXKnfZxvmJAks0bsN/dMvMJ9O3BrxlOsFe+o7i4u259e3DdjUEBw3MvZBY+UrKO/wvc1p8Xw4zu7gau1O12ZCJHw/tTAyTiI96JuJyaOI+GcLjrhP/bruPKpVDMSt5iQdvHk7F6UTgbVuqyoH2uSzdHefM8oEEUt4hWHZHcc0oKklbNocwUV1h1eiUCAG3NcUmc7cQBfnRp+zJSTGi96qK4sOfEFbrTy6aCzwDOydaXrGt/G5K9CVCelKHTI4nW3CGl6Spm9GBV8Q9JkTQQSipg8TLXiXiLRKt67WKeQJ/++I2VWE9GdorM3FJmHTxXig+9+47wFya6Mh+9TdupIPAFwNrfiw2U9qVRgye+bLYZ69wKM0MpMbAsfWkOpt0+gOmEumtYs2GtgP6TdD5153etzHuxh8dkty28RwB+TKcRbbkaYrMA2seDyLjBPoaSzk3XZuMQV4oEHb00VcT2sIHAGyUXCH8jyVfE47+5jia5xr69tLJXxXcHKkKbnLtr+yMbPSCOigNXZdjL1se91s1IWZ4MS/+Y+mHFrfzlvhDe9mkkONR9tORKnMSjMFyMPwmBE8Mn0MOgp/VunNe855RJFj3TOXtWKcK28t3ajI34EIFBRBuTzwp3SjM0qRPo2iHViZ+MiT6BifHQBAWLnj7hP5i4/WeJybe3fqLFWoOhBEv0yZa36yckjsLwdaRuRHhQBkQFMlvAvt3Ll9LGF4eKgt48ri1jBPJzsZM
 o4SB6o2p
 99HaZudYclzCNOSZMWcTPR/57LD9BKAKyBiNPSSPFzV059L10LHcewIopnlrgLwNNlEzcF9u9lIu2HlkWmVRN+bP46qmuFy1YJx5HCDgj/CoYvXkVVp9AqBYIW7sYTVsrHX+iWqcgjGirlICbTQHritPkGEKA+2aQTvVwnoe13+Ce+t4W9GTfCqmeSoj+/96HHbKMaEG7cuz3Wy4CxNt2T3B3/DDpr5gZVPyrBBaL+gUC8wYoKBw6jyljehaMpK/GN1md+jKxM5u7vkRFX77EMQhwrPVkm1oNPHVndErF29m4cVXnVRkUD1kZ9dWhX74aVo9PuBBD8HTRmG5NX9hBhk0Uww==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-13 19:57 +0000, Lorenzo Stoakes (ARM) wrote:
> On Fri, Nov 13, 2026 at 02:55:36PM -0500, Gregory Price (Meta) wrote:
> > HMM can grant ordinary device write access to a userspace shadow stack.
> > On x86, pte_write() is true for a shadow-stack PTE, so a populated page
> > can be returned with HMM_PFN_WRITE without taking a CPU write fault.
> >
> > Nouveau translates that flag into a writable GPU mapping.
> >
> > Reject shadow-stack VMAs in hmm_vma_walk_test(). Use the existing
> > unsupported-range handling: a requested fault returns -EFAULT, while a
> > snapshot records HMM_PFN_ERROR.
> >
> > Link: https://lore.kernel.org/linux-mm/20261111-mason-migrate-et-al-fixes-v1-10-3d2454362e8d@kernel.org/
> > Fixes: 54007f818206 ("mm: Introduce VM_SHADOW_STACK for shadow stack memory")
> > Cc: stable@vger.kernel.org
> > Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
> > Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> 
> Thanks for doing the HMM side of this, LGTM and:
> 

Fell out of my testing harness when reviewing yours :]

Stuff like this is becoming much lower effort than yesteryear.

> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

thanks!

-- 
~Gregory


