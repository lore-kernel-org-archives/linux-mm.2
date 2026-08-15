Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 352A0C5B572
	for <linux-mm@archiver.kernel.org>; Sat, 15 Aug 2026 00:28:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02ECA6B0736; Fri, 14 Aug 2026 20:28:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFB906B0737; Fri, 14 Aug 2026 20:28:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC38A6B0738; Fri, 14 Aug 2026 20:28:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A0D116B0736
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 20:28:30 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E51A7A28CB
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 00:28:29 +0000 (UTC)
X-FDA: 85101617538.07.FE1AFEA
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf28.hostedemail.com (Postfix) with ESMTP id 21170C0006
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 00:28:28 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HwMubyM1;
	spf=pass (imf28.hostedemail.com: domain of kmehltretter@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786753708;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e5K+G6TwOX21s1Ie3PMbo+iOlYucj/5s5+PZY2NK0NE=;
	b=pmFlpz1MFo/zKxEWDyDaf9Pytof3BcKR7cDoYGF7Afue8l8WDsH/YXoyJeeeWPwaYo6YXK
	TbqqaczTT/mlJRhZEHZab7bTJyAdG/KvNElogShGkFrGIj4JLMVxM2kUX7dtPNc99vhbWO
	VyNCTqCSli/fEXzQA8hE7enzd1smYF8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786753708;
	b=ZWSTiZAig1Q++BzfYMKiwXWO0MaDY7yg1dhp8WGoEfi8dNmEby9y8e0lLGYVqD7PD8SsFo
	8IT++BLfNY2vvpxu+zJc+gVpD+HK47gMTPy7vOux+FkpPj5dO1Aop75ZN+pAWslzfyUEEJ
	mjSflDgqSByy3IRvvtW/alDpwzVdhEY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HwMubyM1;
	spf=pass (imf28.hostedemail.com: domain of kmehltretter@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4955aa106b1so13423195e9.0
        for <linux-mm@kvack.org>; Fri, 14 Aug 2026 17:28:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786753707; x=1787358507; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=e5K+G6TwOX21s1Ie3PMbo+iOlYucj/5s5+PZY2NK0NE=;
        b=HwMubyM1FP8nSxoOCdlptXK9H2RZTwNkIQZBDZKZJaGhw4vBqyB7hyoaTN4NO4nYrL
         CptBsn23f/FZGxMJbyOhfuFcmpBdROhsMc1lQul/F68bwi/AvCDaBgBVM73qW9fbmfig
         5nuyuOuJSnNiPd8R3ExkOxqkKuXpxMbQYTQfuZwZrYLQHsmvGScE0/iC9ukoS8OlXMSo
         HoBSsB4RY9r4qFR49iagS5UGpyzDABxMZdc2yl5/f+qydqTMGBadpg40y5XXV0MvbsNF
         1YJXSZsHcepP/0pfF4Z4A8KPwRK1TedjCcqrMcFMcbou1iIU6eUnRZCOM2ftdTDmwHn/
         4H9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786753707; x=1787358507;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=e5K+G6TwOX21s1Ie3PMbo+iOlYucj/5s5+PZY2NK0NE=;
        b=Mdg/QCz+c/+LqKD4B1vA436ocE9kFnJV3hO7xTEEApoAGYRYbNYCHTMPQOyFyInb33
         EIABn9Ytx6bZqA2Pcp0LgfOD6FuI2Rjb7t7V6mEagVc7608/hQEuF0qvhNgK0wPUa+cC
         AyyiiITQmtcfGlHtixcdTH2yzyH+PT+Zl5Xqggp12mg3xBHYTULrLDQ0/DpIFtcDN04a
         vR3k6ObR3SUEARWIu6PQCpOpbssx0500p5irD+U1vuSGu73RiuoDIpouKPVyP55tj6+e
         nhTL3L3m8xpPiMXVCrF8FrTmmv1/WoQWoSMo3V5awC/KoeSUPJhJEdW+RbOGNVILhkKz
         p3nQ==
X-Forwarded-Encrypted: i=1; AHgh+RpjQ2jTzqwxLrPkemnFvyL273ZBVlPnyISbnTMgCC6damGRziwc39hIPvuzqWJe2661tLtWRg3YcA==@kvack.org
X-Gm-Message-State: AOJu0Yz7/pbo8/Rm02nxAWRZXInUYhJ0wdFLziyE1F9DiaxD7KWrT66h
	nwG+LyUPpObphVMkOgiP34rgA0ABXIUdPIPkq48HbdkUGPpSaQnxM7wA
X-Gm-Gg: AR+sD12h5DT/D14KP1/+PNG9/W8blTEd9yUoDeY8ywloJyjAQ9+l29VeJ6wR/mBxeER
	x04DkBD36v5obJlGZjQd8kN51H3eibgUHIQipx8h80SqwtDEkA5/w/XNuVn7eABipZS5An+yg2r
	ynAQo0SacAZ2zYKCBepUYW+q+cSahJfmPHolMJqXiMc1cVNjBXBCs0ypf1/fOeenpUq1ak6hLz6
	ibaOo+zvGB5HUxuzBGNT0K2MYtRD28Nz357Ou9IOFAjjJ591qlTnE1RCo8TjkyKNtu3XyH3ljfp
	hYkVfISfQcMeMwaYlrSarMqZgFsazD2Y18fhTq9lCSmQKsdEhTpJX+JOvat+LklpyMSGx/UTXGQ
	33Y5XV645nbI6zhvfmgnaq2cou8wx4fsrpUu+WCE+SF461ovLJoZ9S3+gIlFhcm4OxU157JLajy
	15bV3EZ975VhbkGY9jMVxvJrKtWTUu53Mubo8JI9wY97z91Fm+cP+3QcVidbgInnLuomwC1FGi1
	Qqb/qsT23t+avwS3n2kuzFB/8OaXLINX8Ga6+I/TeM7Kz9o7tKcAL/Ov6PwROgG1oIDVPmBKM38
	Sn/D+sjOLrSzi3j298KLK1J7GC29mYrYbSJOtU6Gl4qZcdnVaL5iKVB8t26AyQmpJQ==
X-Received: by 2002:a05:600c:4e0d:b0:499:900c:9c68 with SMTP id 5b1f17b1804b1-499900c9d75mr3231915e9.6.1786753706369;
        Fri, 14 Aug 2026 17:28:26 -0700 (PDT)
Received: from unknown748F3CBA5068 (dynamic-2a02-3100-9d7d-f301-9495-44ec-73e6-1be7.310.pool.telefonica.de. [2a02:3100:9d7d:f301:9495:44ec:73e6:1be7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4998ba01c62sm58696145e9.14.2026.08.14.17.28.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2026 17:28:25 -0700 (PDT)
Date: Sat, 15 Aug 2026 02:28:22 +0200
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Kees Cook <kees@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Catalin Marinas <catalin.marinas@arm.com>, "Gustavo A. R. Silva" <gustavoars@kernel.org>, 
	linux-hardening@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	llvm@lists.linux.dev
Subject: Re: [PATCH v2 2/3] slab: check for ZERO_SIZE_PTR by exact match
Message-ID: <an-yHQe938PS-Opz@gmail.com>
References: <20260811141240.62519-1-kmehltretter@gmail.com>
 <20260811141240.62519-3-kmehltretter@gmail.com>
 <202608111716.0FA9DB17@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202608111716.0FA9DB17@keescook>
X-Rspam-User: 
X-Stat-Signature: wuqc4wrsdgeobfh1j7kyqxddir1prmf3
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 21170C0006
X-HE-Tag: 1786753707-355329
X-HE-Meta: U2FsdGVkX1/sAjlBFbjj2E7w8z60AIQBKDbUHUW9pfa++TQsTSxJp7pgOrDKn8njxADx6LIh4P+M+Uddb3wAsVTnVPQmLC8MNR56aNQdPKVuEz2UN576s5rEX7ipb6TqMNVq2z+wd8YRAPMxP4S/xC9BpX+6nsAAhclIvYX2/w0a2VDr3iNGxwSl7R0qhTJ2CSxPG9EqGY0GlP4hw/soM/erN23cTZjo+AVrI/7kRd+xaQQvzbvphlLH3dfZmHN1WvOW4ECqj8ysb+7/NlGkTzwIapRgKxQVk616NhdNCTp1BmqJLzKo2j6xJBYc5ug0/ttNDgoUSODf7mIcGkGc/bsz+roE4T5mHpZ1DuXR2ULiKJx33kafOAl/d9mNLlGUJlgSXIvISdcuPdRz26kM5aG6ctGfgE3PLeNs5V2hupESSMQOI8+kIU+Qr3zSA6EFM0ttp+B7Ib6PJCB4KfNOTE1TUNdiVkLWk9BtSCUqNA/xr0gHFloA+IkpWGfXrCc9BAUyVHXOlCwf4t+6Pvp9YD3nmYAhsur/x7YuGlDlbS6mQTJWJEMCmXU2plwnm39kidUrXpMeS5IE/YcJisq6WMhxVeQ/XVgpN5OFsQyBHUG4B1F0U5vIVjfePVChuzG2BkBedcvyJIQJ4cpvq9CO0ZiNcMxJk41/YMU7UD2jEAWK4wz6Dh/uyprnPaQrzsDU1Iqk6+QvXiFs20MFbjinF6P4Q62QM/7oIFR5OnXRdaNDvu7jmMUT5xI/KY/c/wBYZJ2AdakIhf2H7beJP61Ro6hzsbkzionRsWAYdI1ufUJOXLzTlRuVpcyitA+0Xz4c+KT2GjQ6NB93XqrTSA2pX/9e0L0DWP2bne2h1kkRJ5y8ZvoFaYxPkh88aQOpUL83qXWhfODaP07YKfJGE1eTpihm65q3YhOxV/34+R2If9PuVjvMW7juGAewBUt/gxPN0yWE7xDfM4dF0S6YiZt
 JeR2sG8t
 OjEc8ejwjMzmDCszA8xMmP3l9Tg42zoGitIp/tJ9iybo5xtfAX87edYOw3ZWKaNKe4NHKZ4ruY06XrBFfppdIexJ9B2+GKDS7U6ZqkX0CQV/6bwUPQ7epDViAl7Rstk5cJhaci+KvVZ6yJdDa1MUeeayhnkd84QZpUIeGFn73zTdZkDtNAE9A1mvXDQgzRKs57Vp5ua4uxySpiQD2DdnB6QxNTMkwgNH0uzrGOWuOceNElKbmk+zs/qIDT3h3OKknXKjNM8zbOu4hPTOemsA5DnyvfYYNlZ5K0AN4/6dj6ppQyNhgUBATWBeQ+feLuz2fiEIglRMNqFtDVMsDEyg3F0Xdm87X/j7O0oavdX0L9pu7EpR0tkA25AOgIqLl1p75KWk4c8IKPYEq5VVdLJ6uf/FVxTg2vrYYUOxd1lNLLxYwJmKFFKcwrr9e5jZZoK+IBwacQeuAgr1s23GLbcSAtvZFgJsuKDOwsU+otXAo9RZkx5LTMpg0TQ4RN2CpKEL6jCzdO26emnoRESPmYuO0+hO7W504YI6e0c88jnVhvr8qPlYXYDJCuIBXeNTOi3LtmOIlgFqmGWwRF3Cxvl3r1CnvSz+qdsFjYnZ6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11, 2026 at 05:17:48PM +0100, Kees Cook wrote:
> > Compare explicitly against NULL and ZERO_SIZE_PTR. Store the argument
> > in an unsigned long temporary to support both pointer and integer
> > address arguments while evaluating it only once.
> 
> Can we move ZERO_SIZE_PTR to cover the ERR_PTR range too? See this issue:
> https://github.com/KSPP/linux/issues/93
> 
> > This also changes check_bogus_address() in hardened usercopy: nonzero
> > addresses below ZERO_SIZE_PTR no longer cause its null-address abort.
> 
> And then check_bogus_address would also catch ERR_PTR.
> 

Thanks, I did not know about the earlier discussion and the KSPP issue.

Using -4096 for ZERO_SIZE_PTR is tempting.

However I found a few conflicts, for example:
  - PowerPC KVM guest kernels map their magic page at exactly -4096. A
    kernel making this change would probably have to move it to -8192.
  - m68k DragonBall has a hardware register at exactly 0xfffff000.
  - OpenRISC could reach this address with an exact 1 GiB direct map.

Linus's original reason for choosing 16 was that it should fault
like NULL:
https://lore.kernel.org/r/alpine.LFD.0.98.0706011554300.3957@woody.linux-foundation.org

I would not include ERR_PTR range for ZERO_OR_NULL_PTR()
globally. krealloc() also uses it, where it would make an ERR_PTR()
behave like NULL and allocate new memory.

Maybe keep the exact check and add IS_ERR() separately
to kfree() and hardened usercopy.

Karl

