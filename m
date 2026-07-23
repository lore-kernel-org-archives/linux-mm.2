Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48F10C4452B
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 03:52:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 435186B0096; Wed, 22 Jul 2026 23:52:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40CB36B0098; Wed, 22 Jul 2026 23:52:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 322DE6B009B; Wed, 22 Jul 2026 23:52:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0103F6B0096
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 23:52:40 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6BEA6803AD
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 03:52:39 +0000 (UTC)
X-FDA: 85018669638.05.5E65738
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9AC55C0004
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 03:52:37 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KBYrIWhS;
	spf=pass (imf28.hostedemail.com: domain of farid.m.zakaria@gmail.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=farid.m.zakaria@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784778757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+KjB9ERoiyCT7CFBhmVdB5j9kcQH+fYHM1d2cSu2txU=;
	b=GKWPxvTVEnkoiqVHAChfcCVSEpC4CxqS7jbf12EylXr70B0NVXhyoH/imKMfQxA51UBkcr
	S/WiV6SiH7HKPwUcxKfogoNTDeVTSRwqBwAQeft5hSRmvtYt7XxheGXDl0Lt9G66ccv4bH
	aOXyb07U8snbmtZCgcxz6VXDsf2/dio=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KBYrIWhS;
	spf=pass (imf28.hostedemail.com: domain of farid.m.zakaria@gmail.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=farid.m.zakaria@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784778757;
	b=ssTSc3nu7wh0/sYx9M4XlOaOCpfECZfsaA6+uQiKOQneGFfPZQQTyg1l4YhK0h6Wsi5GRO
	MSooYVoBB9zW9P6om/lMF+rBjqzM9AKQXahaolwd0P/2HTi3XV0VMhYJGyLKsrirqswn/S
	4hQRS4qwv/EZmLOP5rjtSf1GnN7lXtw=
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-c9cf07d2df6so136548a12.2
        for <linux-mm@kvack.org>; Wed, 22 Jul 2026 20:52:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784778756; x=1785383556; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=+KjB9ERoiyCT7CFBhmVdB5j9kcQH+fYHM1d2cSu2txU=;
        b=KBYrIWhSboWA6VUxWeGqLAAndsK3FYPBW7wwi2sBhzXeb0vDzj9FBum656kGY9596l
         b6EpA67cOCtCgfi13G6u3iGrI7PHD4C2yP2MkSMsZWqRYVlqvSl3vGDlXXNo3DVMb1cm
         80FO+cBZYfHzceItme5+/dp24/nnd3gRpOO3UM57L+IiyAGa2dsKrSKb/vC7M7DHhYiK
         xwJG8tpZWOoWqboFF/4/iIvijvlxmlePSFUXw5nhSylEuW4KwytmTZ2xAbuh9FtDEbDx
         jH9OKM8CUg9ubzqjEuAcUEjyTVCBzcbLRXImsT4FfPbyfcg7TTR8oycRIjtxoy17206m
         6LSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784778756; x=1785383556;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+KjB9ERoiyCT7CFBhmVdB5j9kcQH+fYHM1d2cSu2txU=;
        b=AIDPZYQHLLnfVg8Mn5rt54tz0lkPSYvJw3kG/0BBTP0aXHdaL657Ozsx//15doilYh
         7/fLlM93nuFTyqR9fI8KbmAU322bcJA/2vlLFeUE6nbYMyUp+iXjRE2vW9+nIWf4S6l6
         UjZjYzpNh9get8E64rwfhBOlpqESyEucjGOKtya7BWdSfeh39FCnL1UxMz/Z01bOeTht
         8z/yb08rEHkJsooDc8OlaxUR9VzGYFfMdVD1qmZfvBBu9qZIScUjjF/xSzOiSa1Uk6NC
         yvckTJ65cvWql7s4I2Nq3rW9ueE4IPpXPQLQjgMeteHF//9rBKZgG515V4OivFa019S4
         CSRA==
X-Forwarded-Encrypted: i=1; AHgh+RrBQP67PrsuwYUzBKuz8yg2sJ9CRKuOpEAdjHQwTB+0d4Vs76aWPwMR7Kk8+Od5Um2OYnN8JqSq1g==@kvack.org
X-Gm-Message-State: AOJu0Yw2l6L0d0vPJyRU4YP6invMMDQUuPkcQhFujfm/j84cbu8mYAzJ
	WJEOB15qEBWoRmvHjO+FX3jJBNkcnWsc1eO+LtLr2WVQPQvfgXsM1U5q
X-Gm-Gg: AR+sD12W2fnLem5rcsgldeikzPnT0rTlx+qYuO0uADpVlQkHw99o3eZd+LDhLPZDfE3
	edYzSZkwiWgly0iVY4qy+4ZRhXO9iTaFwWxR8aggLjHsyC0hzV08YvSynPG1jPZQi5f3YEfS8i4
	42zpoCWwYjoh8r1KjqV8dgfSkNyXmC4UpBmdcujmZyUHCzm4WZrQGz5PiMl2fwGdSJbV4F5TKOq
	ZZ8HemqXrjBpkSZCrw/T7ThzvLrkgR1D9LKBaQZKQikOebNMgDEcRPjGvFbwIeiklgWLOMvzJac
	SZOjTxM3MePZlpjrZWlGrKdRAiPJG9jcuezCBjDqrY+0+1aEx1eqhso1SjzSAMxg786zgO/lO4A
	nFLJMvkQrxZrtATYPhGdtXRubF8XvkxH6ifT5kaaKmVRW+ZAD5rf9M3PigWLF6b/m9W0cxMhcfx
	JIThv9Yg==
X-Received: by 2002:a05:6a20:c784:b0:3c3:ac9c:9a66 with SMTP id adf61e73a8af0-3c44b25089bmr1370190637.69.1784778756493;
        Wed, 22 Jul 2026 20:52:36 -0700 (PDT)
Received: from [127.0.0.2] ([98.35.8.117])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13d12f267fdsm11497359c88.0.2026.07.22.20.52.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 20:52:35 -0700 (PDT)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 02/21] docs, binfmt_misc: keep general usage out of
 the handler sections
From: Farid Zakaria <farid.m.zakaria@gmail.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Farid Zakaria <farid.m.zakaria@gmail.com>, 
 linux-fsdevel@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>, 
 Alexei Starovoitov <ast@kernel.org>, Kees Cook <kees@kernel.org>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Jonathan Corbet <corbet@lwn.net>, linux-mm@kvack.org, bpf@vger.kernel.org, 
 jannh@google.com, mail@johnericson.me
In-Reply-To: <20260721-work-bpf-binfmt_misc-ptinterp-v2-2-e57866e4ae0f@kernel.org>
References: <20260721-work-bpf-binfmt_misc-ptinterp-v2-0-e57866e4ae0f@kernel.org>
 <20260721-work-bpf-binfmt_misc-ptinterp-v2-2-e57866e4ae0f@kernel.org>
Date: Wed, 22 Jul 2026 20:52:07 -0700
Message-Id: <178477872730.254289.4208397694401695848.b4-review@b4>
X-Mailer: b4 0.15.2
X-Rspamd-Queue-Id: 9AC55C0004
X-Rspam-User: 
X-Stat-Signature: tkuwgyj5xugsnwbhgmkuyf1stna6tk65
X-Rspamd-Server: rspam04
X-HE-Tag: 1784778757-959078
X-HE-Meta: U2FsdGVkX1+sl991/UNy27/xVnC7Sm1gqLbyd/lWiRfi6C6JrmU/99vGNr7LuZbYzmenhMBEqTEeSQN/2COigKISKz6fTEkw4/txr/Eap2vyBZ+9hmvu7wZYijrLLeoaMXMTgLSIr+iowRKYBrP+SE1KTrkCqjZqeFfnlvnMz+mK2l054k8gS76xYpIba/5O+k7TpJaN3wkSN8/8WMtQCQzzNFixvUaVT12XsGNDlWdahM9o7yZyMHR1zMy859fbGo5LX8JPi1u5+/7M1PeGAZIO5Xhl2+275UbAcYzYy36H0Uwx6Tj12BBu6aT/qNArxwER4Fc9eF2Nkp1P3JDOp56ahE+fxKHta/SfKrz61DYjriL31dbr5mD1s0QHdCU9UulkuSSYyLeIdz32lwagnxmm4J5K1UB1lD3Pt0JYBl5wkf/1sXLNfDLoHTsDc+tc2CMhs6jR8IlWuNgmYQvdeiLeE0fiDoGWuss5nGcCTrzXI4nRhgqOYVmvBVJYuOHDCH168JJaBhxekgK9H3uCjWw4yBkagyqfEHFFAO8MMi1yDlSJWjALdyclF21xAJ/4oaRfaHNABeJ0Bbh5ZdFhQwue8KnxZO3KvPz4GVHnz9MllX0agUvCMzeoi2fwQUC4a10g5omvY7YIIapfvGsTox6I+newy2p+OQO739hV5wIQwvMeSSaq4GNRX4X5uRVzdDcD73DzTlJBuVyPoRKxdCTEmNG1ROCOV3JuwtgGjrGPrUSx4jgJHnvwPw5xcDyVSpEgSApLl0sTwLMoiZoh7IPraBMVBZG5MeiOkF8TgOrZwp1YT3QP8UzZjaHtEcLSZqc7syxpweT3zLon45CdaA7i2lqzE4g/h/Lx3/lEePxid2OndzDH1YnKuA8tTMTHQjdwE+E4Kg3UsiFCzlpcqClgOTga61II5A+DbobdTWQxdbEV+OgwdZa6icxQaoDkz1TG6rIZVrvVGEOLRNz
 ZyHhbD1o
 HmswIhc7ohGdbSc4gZIrrGa1G2CQEd8c0VX34/JyG8iuQAMlorzzk1BAPFrwPnSu579oFjGPMuO8l+TUrQFV72RqJSKHG+Fa0g+ofnycgw9Q2bMgp3Rfr2Qm+jB5pCwVe6RajmcaRwnCMz8F0de2n6qRg7FARCBEjVOaQPAb8UccfiaTkS5YPWGKNK8IwvykXgCGauUS/m681+geQAfCe1MiPSuKP0fAxBnlT+KH3cnPErMgFfLjNYyU8rHk77YOSgVRmuavgRDHjgdrMj+MfqVrPQa4LAecuZr/f9DTZ0wq8czocG6FEJWFENgZGD6Nb2hejxF0E5FanQM7wLdsnQaxBJv5akCO8JbGv/r+CTe6tFe0446o2b9xgP6swu5M0ccoDDIf4LrGiBcSGfliRKe8cEuCvnwv3JmhY3BrbSMkgyr9x89YaavUoD8GqwtG2uv4OBe0noJ6a0NyeP90//ctO+R49nRF+xipEqJSjBedba+ZELEMQ8fInSfaXyVZ4RF7y8q5xqg9vuhUrv6upNrkrx1QhQZFf4fOJ6K8uuHAgxf4A4CWWDKkJMKLEcjEsb3pT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 21 Jul 2026 16:13:44 +0200, Christian Brauner <brauner@kernel.org> wrote:
> The general usage trails the bpf-backed handlers section and therefore
> reads as part of it. It predates that section and applies to binfmt_misc
> as a whole.
> 
> Move it back up so the handler section ends where the file does.
> Upcoming sections describing the transparent and loader dispatch modes
> append after it without swallowing the general prose again.
> 
> [...]

Reviewed-by: Farid Zakaria <farid.m.zakaria@gmail.com>

-- 
Farid Zakaria <farid.m.zakaria@gmail.com>

