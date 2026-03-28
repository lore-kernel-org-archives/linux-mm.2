Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54E8410F3DE5
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 18:08:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B736A6B008C; Sat, 28 Mar 2026 14:08:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFD816B0095; Sat, 28 Mar 2026 14:08:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C50B6B0096; Sat, 28 Mar 2026 14:08:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 87BAF6B008C
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 14:08:33 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E86B456D10
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 18:08:32 +0000 (UTC)
X-FDA: 84596256864.08.C155900
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf02.hostedemail.com (Postfix) with ESMTP id 178A380004
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 18:08:30 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BxEFIfQL;
	spf=pass (imf02.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774721311;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=diZhKCC9I7JLNY07BvTldczKweLaMhfWrzg57y8Kyec=;
	b=HTZT/PFKDirw+mXxuVZC4wEKMbnWPBvJOkchA7XrI636XsnSh0b/SKdd7a+03iTom0b+5Y
	aU1KIfiktmsBxstP6ekjclGnt7e5rzoOlICey1NimFcVi55C47zq2ayhkB01rR8flIGzu7
	L5f+EEKBYeeUQYMbzoOckkLBBGThGIM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BxEFIfQL;
	spf=pass (imf02.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774721311; a=rsa-sha256;
	cv=none;
	b=db87p/9Dw5DiBVym6R80Cj6FfA5oDlhWEiEEg/hyO9t8nV/x8cF+xr8zNU393hHKemIDxs
	ulGpl+s8x1A0+pNmz21v1VEG7AUJs0xLK8myT33g5zukjWtGc9IU1e1ZV2dFGpdwQ8MjMY
	t/GSdjiPQ8tLvISamVtLGXdfJIvC69I=
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-82a893d289bso1396646b3a.0
        for <linux-mm@kvack.org>; Sat, 28 Mar 2026 11:08:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774721310; x=1775326110; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=diZhKCC9I7JLNY07BvTldczKweLaMhfWrzg57y8Kyec=;
        b=BxEFIfQL8zI6ka/KB6ZKb8s73OcT3mSKaorKWjZkZdB7OXNfpQkEqDTXbvQz8HTtKY
         nogu5mJWNCjJ/nHVUuzbt4xwzjbL5xO/uwIiRQLce06CQsGbhXtNCy02XjpLb5a003gb
         4gY4jmO1GW4BNybgD3QwBEMqK/TUYKGuY4PLvznOom2zm2lX9uDvdrKPeeqBs1o5B8TO
         BJsB1H9HoNf+iiTRPO43jDGUq1RzvAf/n2M1xLA3fQEWTs17XwwKCqfwrnZehKlRxlZo
         68EnqfEC1xeExXEPgMJDTZmuc2+M0rcFgZB7WuTyhZCdpXIbESk7FYi8QkKb1dCBF186
         Ov0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774721310; x=1775326110;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=diZhKCC9I7JLNY07BvTldczKweLaMhfWrzg57y8Kyec=;
        b=Xn0+HY20PKXNCT+PU6KfYYJml/Jvqm6vWNH1yDMhLss+Z0uxH/ECrc3gKfh3w1KTyN
         HgeQDpxG+FwNyd0+IMgPjne5hA1H0ItzK+EP0UKpECrrWptneI/kkf1ENYEWnqrNOTDb
         1OYQckxuT5w87OsH7YZhCmn62ML/0DXm/RyxjmI/Gn+URKHAQx9mcWmePeTALquO52zl
         davWrAQs/6/aRq2nxhivUSJ6y6SX0gT157287Oe1QJUUZ97buOV/n5l2CocFphCMq54M
         NiyG3Y3jaVvJBUtOYR9mtjEnaMJI4e6vXIserTEaRdIff+smQyw/jpvFiRQiK/jNpDyg
         RUsQ==
X-Forwarded-Encrypted: i=1; AJvYcCWS5+9WVRi7UqUTPgSLnG/kxhwohNGkOzYX+MjCb2nJMFLDjvI31Zcmz/grbDPrY+OHnel3s6xBAg==@kvack.org
X-Gm-Message-State: AOJu0YyUBev+wGoXH6gpIRbF4RlCO38XRoW1eMcTpjeG6XNaPGT45f6H
	XlqAkWXZwBToJcuIOJqCCoRPn0WP0w9J2VfA2GziI23YcttiEB0ACAVN1XrEXw==
X-Gm-Gg: ATEYQzzS6AugvAGZ9d1BvaPnJ3ArG29e4rl1fouZ3xNW/fJ7c2YbXv2vC+++/5WjoSh
	YFash86hp/gXHm0CTCG3v6nFYZE//hJNOk0Lmzy3mza/0Arc1yOJc5vPf1Kxvq7oMgXO2rT5kB/
	EqmV2NB9xfyu7lyIMs75t7wf/YQLTZK0j0Xe0ctxZyEsUYDJ0AkTpK7cOUwxJG2HYKzt6vRkFWd
	otuBcNjHZy4CfwB+wZDEWawcLjpNwEyWG/EhIcXFk0LiHIuZtJYu0I3AFGyCETKZ1dBJ6vgXR6z
	AgTXWGghX7mDN/1j7580K16+ym9dWiRmyuuUn9Onu1XZFnhVYZ/urnNheMHqu4tNmBgAYubTMsA
	UeL6b7qbMstIGi9uVWmlDhMf4aFMRhk3omdzfJfAGQ5jxiilEBtPKQ1ShIwztEK9ziCC4XB5Put
	U/jK26jlxs00znqTD7DLsjP4/NFAg=
X-Received: by 2002:a05:6a00:3405:b0:82c:77cd:50e1 with SMTP id d2e1a72fcca58-82c95e45397mr6087053b3a.20.1774721309733;
        Sat, 28 Mar 2026 11:08:29 -0700 (PDT)
Received: from celestia ([2402:1980:898b:301c:d085:a35:99e7:ffec])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82ca85d3a71sm2969211b3a.30.2026.03.28.11.08.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Mar 2026 11:08:29 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: sj@kernel.org
Cc: aethernet65535@gmail.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [PATCH] mm/damon: add synchronous commit for commit_inputs
Date: Sun, 29 Mar 2026 02:08:27 +0800
Message-ID: <20260328180827.8136-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260328140907.10389-1-sj@kernel.org>
References: <20260328140907.10389-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 178A380004
X-Stat-Signature: xikxfiu1fp9kbs3q4gz41dequati1978
X-Rspam-User: 
X-HE-Tag: 1774721310-81204
X-HE-Meta: U2FsdGVkX181VdYvY3zf3t9yr7RsqGYVrQBnuNvRVI12s0wKFE4GJZ4MoRZv57NooARhnmCMbrLC3KfUM42yYujC03Y7pwSKJqJGB+A9TY1gymdEwsjNcfF+8yBoUhRmS4D8ro259WlXTG/vgv53opDqKyXLhcAZidESS0zp5UK1JuI/YLjlhPW++GloiqVVu6nmYkr5vhKV94/RqOTH24GrSKa2SK9HwNeH2OSB0rdU8rvqtflepEZs+tZoqrWSWsUTZCaS1SFDiFxQ6kazFwjNpKp8HaKT2fzWBdsLJfwKkWQn4eHC3V3YZIkPNdp6nkpRcV85ZEjX+VfiKPMS4KO/lTKilJ9LC0+KbcNu7od03Tr7HPNRAj5xZiW/mVjq9EaJ3+HdY3Vgb2ezzikjQADxQ54DoOZ3kCx1NBj3BsBQRXeDR4cHVFNS7geYaNyejJz4AKBMmcDxHUvxyG3MTEbstO4VR29mpdbClhLXPkcV5t+N45z6aQooWqbFFwqw8yTVWEfDJPlSM/Ng+3FgIBkvsHPMZHydqre4FpKwtn23W2SrooGzcxFcJyoZzC4yCVaXx5LnZfN7APQNfXlevzMhpvldm8DhQtBTTkRZjsrzSURFwkrd3hhCZ2letFNyPV46WPp2yIVksvCbEvWrdK3Oq7Y2Oorh5nR0duBY02mDGjauK2z9qkDLGUEAht8LLY/2nYI96bm+/l63/llCMmNmCjj6wtXfyQtExtufTHgAjazFkNo9W3MMs2fA51qQdS8zSLCCITLSHgk9BHKIk2zw4VKB4Hv+srKFxqUTI+ZalSzKADOhlY1H8Wxznm7MIUKAH6uCURbO6RgGHxZpIgMGsAPGNy1gl8Gb9mnNsLAUCF/RuaLXE1bXR55dzz+ignEgTOaTMFLHbB9BdUNyvVuLh7dfuHgV38NmnSA0aX9iAAWr2ixBoc84WSsVCDglXy/yXhup6addoqRBQCh
 ayvn+cRi
 KIHTo5FUF8/gRaJ03n3T0SpJuhYXPQ4kMxJ+is4hnEcFFFHvVKS5aLcQVkvygaTvUXXguI2NU1IT4UmGcGKkM2m34o5TJUbSI6ppXNlGfjB4NWDyvB15oax44UJK32MOjdfgOFO5JoLOe/yIVIaXLDnUY0RjXi77ij2N5FTRjle9UjVV1QuIGkYVN5EoHC0chnn20GNXvoAwI5KmCvSOCy47SrMz64sG8Dl2hdQnWKAYWe7AUWMvs+DWpB6A/QQ2y/RaMbZKwPxwgJLrQcn11niqiy0EoIy4UPfaZapsLEu+GW/HUMBXVDCEZ/82Y9aXIH8uAvUUZAD2h8S2XXSmxVtKcrgn/vTnA0oehuiColvmVvvrm+HZvYd6Vym75goPjcCJiA+j+m7pzzEJufExuOJt925QrGX9UYZ4K0wYQPseX4f0TstRk7qBWRnGksl2Ct3mzv+zVP8RQCXYKqT+WPVo066P6l/+tSJoegqzy9nA0ar0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 28 Mar 2026 07:09:06 -0700 SeongJae Park <sj@kernel.org> wrote:

> On Sat, 28 Mar 2026 18:44:50 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> >
> > [...]
> > > The previous module_param(..., bool) macro used param_ops_bool, which
> > > includes the KERNEL_PARAM_OPS_FL_NOARG flag. This allows parameters to be
> > > provided as a standalone flag without an explicit value.
> > > 
> > > By omitting this flag here, does providing the parameter without an explicit
> > > value now produce a parsing error?
> > 
> > To be honest, I was not aware of the implications of omitting the NOARG
> > flag. It was not a deliberate choice on my part.
> > 
> > SeongJae, what are your thoughts on this? SHould we stick with the
> > explicit 'commit_inputs=Y' requirement for the new synchronous behavior,
> > or should we restore the NOARG compatibility?
> 
> Should be a no big deal.  But it would better to keep the compatibility unless
> it makes things too difficult.  And it seems simple to do.  Could you please do
> that?

Sure, I will restore the NOARG compatibility in the next version.

> > 
> > > > +	.set = damon_lru_sort_commit_inputs_store,
> > > > +	.get = param_get_bool,
> > > > +};
> > > 
> > > The commit_inputs_store function parses the input into a local variable
> > > commit_inputs_request but never writes to the global commit_inputs variable.
> > > 
> > > Because param_get_bool reads the unmodified global commit_inputs variable,
> > > will sysfs reads of commit_inputs unconditionally return 'N'?
> > 
> > This is actually a design choice we discussed [2]. Since 'commit_inputs'
> > is now a synchronous trigger (or a "button") rather than a persistent
> > state, it doesn't necessarily need to store the 'Y' value.
> 
> I agree to all Liew's opinions.

Great! Glad we are aligned on the design.

> [...]
> > [1] https://lore.kernel.org/20260327233319.3528-1-sj@kernel.org (Lastest
> > but may not the last fix)
> > [2] https://lore.kernel.org/20260323150544.81042-1-sj@kernel.org
> [...]

Best regards,
Rui Yan

