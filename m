Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35A21D35159
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 08:23:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 770E26B0005; Wed,  1 Apr 2026 04:23:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FA736B0088; Wed,  1 Apr 2026 04:23:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C1D06B0089; Wed,  1 Apr 2026 04:23:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 45EFC6B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 04:23:58 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E5C9E16070D
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 08:23:57 +0000 (UTC)
X-FDA: 84609298914.21.EF4B101
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1A1931A0002
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 08:23:55 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MasF9480;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775031836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+tahSagRy2rxRu2goCN+5yCBu9Tsu0dbKR4tdDc4VDo=;
	b=3Upp1Risqg1s3ioxk0ZocFqR7jTpCv7+o471xC0gRdldkhQ+NlkoXkOUlxHFz0AJPEI74S
	TYqk4jf40/1m7X6rQMAxjOcPTd8VEiWXJxCkyaE13Io3xPkNX280daVcii4eWY9ryutz1t
	VqXL1NwC57q9Qq0UMnNQGKwScOrhLbY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775031836; a=rsa-sha256;
	cv=none;
	b=tD371LJqE/3KfTDBlqCIn+PMgsziO1hQHCRsMLxcBAG42TeTCOPZk5S4C19AUwE8tNCkNQ
	uDwUsrNXmT6jL40p47mt6gFSh1wcrFmgAXndHGoZ3R29Bt6/UlkXoD2RlW6EBfnj8YbmOs
	UirXBdJWGhWVq5qetMJu3k94/AmXb64=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MasF9480;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2ab46931cf1so4655855ad.0
        for <linux-mm@kvack.org>; Wed, 01 Apr 2026 01:23:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775031835; x=1775636635; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+tahSagRy2rxRu2goCN+5yCBu9Tsu0dbKR4tdDc4VDo=;
        b=MasF9480LhcDTmxPy2R6SVgaJDERBAkaYT1wWekcb3MvDsibivmmJVr+T66HcDG+cx
         oTvtLOKN85vqCRBjS/wTLnqYNaBdesoigVYlIbuBuAKDvvmZ1YL9gbss4f1Ms4P/t+C/
         5BRoVzYoyGtnQSjD+GzHi8xvvXx8TwjlORFM0+7kcLatAyr9TCuCVzQt2oUnqUXs3CL0
         B5hJI7wZNSNYMrygnv8AWiKvd0IhZ4cp0CXFF6Ace1ClyU99IeXAwhi7QfFeCGKiS/zK
         8Ufcx3UEPXjhJKcT2RLnH/QTP7u2F1o+I4RbRy76TOrOMXNskiKeESCHzhuWG8rKKsDq
         qKXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775031835; x=1775636635;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+tahSagRy2rxRu2goCN+5yCBu9Tsu0dbKR4tdDc4VDo=;
        b=F0SiiJSxS2bh1RXQs0zSelrNoO6walyzx0mGrZSuomfGDXn8skRrQu/xlAnJ2C56Wg
         3c9vpM/cBALeCvZNeaIw5DYB0ig+9NkgjOkDlalV3pnFxgfiU+/UFCyuYpknKFwpIC10
         73ySoTOt16gwLvBmNb1xY0y1VENunCmUZ2KkJj02LgVCnd6tSYCLrmpbshxREN+434IR
         dGr+pOta+THWNvDpZMGirCRC4uzyc7k8nGDSTNQHf7jmHpoPNfs/l1O7ADQEED3LFa5/
         KiYKJRGEP+ccmyZRkAIvYuiEiO1RxB0R3Glo/vIBN2q4fAiD90gmTHRPB+EfoAKDJR4C
         XRYQ==
X-Forwarded-Encrypted: i=1; AJvYcCXVgKODswKzHHW98+lC2h+jQrL84GYGRjYtBVAkm33dXZyHk/5Jd4nXvi/x2xPs2EfSl83c4ww59Q==@kvack.org
X-Gm-Message-State: AOJu0YxCPd4CmU/yKTyHGW0hKSh25KSnnEuA5AoeyFbemvr1VHJq1+2d
	IRTCFSsxAu9Q+5oz9+cjt23ee92GnCEoGwipeOBVRxmvPTuIxvWB7CkP
X-Gm-Gg: ATEYQzwlPBjJuXkjfrN+QN5g++4jOyXZmlGYiqU8t10rgvqTAV1vXroNS5Pwp6CLJcP
	9izoTnINxd/8+4S9Zj/B8Nx1xNPR6l+3ibp0X/kJryjpurz0rPBFeC398C3O/64Ku7rKhNZeyKh
	+3i18/TTV8WvGR9S0r5mA2IcQ4RAhJ9SD8y/hJmgkZR/EYaSwBYTpTEU2z0Ta5F5wp2QkxfpVyI
	7zj2RYA17ZREpYJAUWDvqMt/+GC8o1lMQChjhh7qko67/bmXb03wJE7p6A3HPwtWyRU9cKV/luD
	/JflmtDwBcBu4kmfrTD/1h8C/EySLBDVXDucgkzlm4MOYEYBjGG0TwXGTseZssdOJR7Uyk4P/oA
	DLV6+AEe0bhY11mSP7X7eKEob00HZeTnHyTehjMa+pc41cb1U4gN/TWaa6MxQCcFYvl3eb1vXDb
	eg5hzD1nx64pe3qlsDE8ZlvPpG83VrfYKUDU27dQB/MvYM8k3y+Iw=
X-Received: by 2002:a17:902:e54f:b0:2b2:5168:2f82 with SMTP id d9443c01a7336-2b25ef80e90mr62217495ad.24.1775031834583;
        Wed, 01 Apr 2026 01:23:54 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:898b:301c:d085:a35:99e7:ffec])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b24ddc0afbsm142463115ad.64.2026.04.01.01.23.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Apr 2026 01:23:54 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: sj@kernel.org
Cc: aethernet65535@gmail.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH] mm/damon: reset thread status parameters upon kdamond termination
Date: Wed,  1 Apr 2026 16:23:54 +0800
Message-ID: <20260401082354.12467-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260401002918.85255-1-sj@kernel.org>
References: <20260401002918.85255-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1A1931A0002
X-Stat-Signature: 8oo5qnibfxa4ar9jfutfogp5eiiqw4qd
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775031835-690568
X-HE-Meta: U2FsdGVkX19LK4yeSjOqoVeYRSG0pbJNkorFAqqBREeFmlXVoYygERmOUO4ww8fPHraxdtwuU/ZDH5kWfmfhs+fAqqxWnYXc/tKTAHqiaF+p1l4y26kVuYBeod3EqbGMH7K0rmxlEfLb3HQ7ChmbTM1eUuIDI2OiQVR2cibjY7sMEDiXv5aLC3POey/UUgms5qUOFjA9ONAXoHvxpF0fGRx1zSDAovG61GHUiC8eFskXHTiyfGQaFW/05kZ5AGUHA3ikC0t+dWGCViKkpkGOc744jxfxGhuhsiF2TCImrbGexYeUzP+eSC1IogXTlDfrccukAmaM8iyNafOAE914CdKP1/vdqCRsiTwXmmn+IM9uq813asZCPOwY1ITuLbV0RTFAJf+VoLx4GF91J/K0IJN8NuVVBz8CQCm4GEBe8RKrSA0X5bj3SQItSGAhH9qJ2Q3fD38bcjHwY3c3hns5cGTPZVLT9rMAeM8Yub9taULz7CQcI3Pdbp8fQzAxLfBJNIpzJaNDHZIjl2ntoj4k44UqfIiGXW5ZHPi//tA1jMEH/BeKbRTgr2FrREeCrtLspvmsSXF0htqgV7BPfin0DaUayHKDf26HdN22WmY0kx72uBeSrBtho5XxSgAL2DikP7fitMocnDHpSqlD4mRpkgXo4YKAQuPJ+rf0UPeV8JDSzZd9y7mGxqbPmBKgyyxQ0TrhH5XU7jlxN8GDgg1dM0wG/gyn7VQx99+t0FITwmoy0njCNQqDUuQzplXilPtoC/Ht1Z+wsa3NRxU+cyiiyJXbZ50x3maCwsvIeokxGH/A+IJfbRXva7/hZCTisQAtQdjct89APLZ5PcUKDAA+cEL21hKA6hBOzbmV4arrd6sZYC8uX8WSV1iFhYqI+dnVWJ9jJzhFsubmHPXMPbssKy6QlDrJE2sIWWuO9InY7JfTFNJhPdrD8sbqwjF5Tjp7yHV7BHUOx4Hp+MKCbBU
 oQuVKck2
 7hYTCpfHcCbdcsUZuEU24JwCkFGvSyAngP/iAgBLRKWD8987Bfm2UsR6TLJyZrQkx8L20UqU2BjnkeHTv6T6rGYSEcL9z2ufzLqErpETinwFLmieV4wvPEJiliYZtXA6c5wiKV0mlE7J23B8zLDWSF+sYpv5XYyEcc2ANUhwYqw814cKJ/Li39ePNIMr5rBoEP4FJZOZ9/GSJnd+zHXP0Uo5YLxCyInfUiHlZkvxhw5aXknAfOrJyTOtLqoYNx/8PXVMmuZWGYKghxZJC9qYpOlE/CRGx0IB58qDNTBD6vJMpEGv3P8CYh4lpKU5zxdafIWRpDL+rWLFR+B2lpJdvpDW0PH4NolFfU86gTyYx2QYTFd36nSwTXmzT/lbJsKQMNyRn5nOSehFtUPjM9BnzGIyuUkAzi/Ca65L+nQpdaeHPiqq9wD9ZAehtQaGvTN6pOizb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SeongJae,

First of all, I apologize for not completely answering your question,
and I will be more careful next time.

On Tue, 31 Mar 2026 17:29:18 -0700 SeongJae Park <sj@kernel.org> wrote:

> On Tue, 31 Mar 2026 14:58:36 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> 
> > Hi SeongJae,
> > 
> > On Mon, 30 Mar 2026 22:02:28 -0700 SeongJae Park <sj@kernel.org> wrote:
> > 
> > > Nice catch!
> > > 
> > > I guess this can easily reproducible?  Sharing detailed reproduction steps
> > > would be nice.
> > 
> > I will include the reproduction steps in the next version.
> 
> Please completely answer questions.  You didn't answer the first question.

Yes, this issue is easily reproducible. Specifically, setting
'addr_unit=3' and then 'commit_inputs=Y' triggers it. I will include the
detailed reproduction steps in the next version's commit message.

> > > [...]
> > > This feels too much extension of core API for a problem that can more simply be
> > > fixed.  Can't we detect the unexpected termination of kdamond from the modules
> > > and update the paramter values accordingly?

Yes, we can detect it. From the module, we can check '!
damon_is_running(ctx)' in conjunction with 'ctx->maybe_corrupted'. Since
'maybe_corrupted' persists until the next initialization, it
effectively indicates whether the kdamond terminated unexpectedly.

> [...]
> Please do not add '> ' to your reply.  This confuses me.  Also, again, please
> completely answer questions.  You didn't answer if we can or cannot detect the
> unexpected termination.

I'm very sorry for the formatting error. I accidentally miselected lines
in my editor while batch-prepending "> " to the quoted text. I will be
much more careful with my editor operations.

> I will reply to below in another reply, as you added a few things to that part,
> while cutting the above part.  When you reply to your reply, please consider
> keeping the previous reply part.  Then I can reply to your two mails at one
> place.  That would help my life :)

Understood! I will keep the previous context in my replies to make the
discussion easier to follow and reply. Thank you for your patience and
guidance!

Best regards,
Rui Yan

