Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BC79F428C2
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 18:46:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE9856B0093; Wed, 15 Apr 2026 14:46:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC1626B0096; Wed, 15 Apr 2026 14:46:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFE1E6B0098; Wed, 15 Apr 2026 14:46:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CF4EB6B0093
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 14:46:25 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5B1EFC214C
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 18:46:25 +0000 (UTC)
X-FDA: 84661670730.10.35F3BD1
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf05.hostedemail.com (Postfix) with ESMTP id 666C010000F
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 18:46:23 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XsHj0C8z;
	spf=pass (imf05.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776278783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nTUX2lP8ldkGAZ7wG7bThpxi+xK5iNQ9DFcH7xMd/Is=;
	b=EiiItbxbcLYPCJJ1WHjo4T4WYt+zr9/f16/LcEZ1ySlCtIRALapt9YrdYSvdRxpWXDg51u
	lTcBxgpBVy6rJOikJT0ZM4aHED3dFsNW4Ia85AvtDTrYdLDJGF/ZCWbdJwmVFe45nfcpDU
	ER5xB8MEBtJlPHunF7y2mx2U0yOmBkg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776278783; a=rsa-sha256;
	cv=none;
	b=NIdLefwEMPgP9slJSHjbmm8Mrsy2DjRFrcDIguevwSl0AhSsMZaoYRaW2EgBZCIDSioVOl
	r4USJQ2tEt2sUYwraK18zj1zxYwjF1Ou2rT56i//TTlQBbQNOG3lrKzWoxhyfnn3HmCf39
	4EYqoQ+oZfrbaiR0tHe+jN9tWI2XEiY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XsHj0C8z;
	spf=pass (imf05.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-35da1af3e10so7189734a91.3
        for <linux-mm@kvack.org>; Wed, 15 Apr 2026 11:46:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776278782; x=1776883582; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nTUX2lP8ldkGAZ7wG7bThpxi+xK5iNQ9DFcH7xMd/Is=;
        b=XsHj0C8zXm1akDH/DHCkvNogXmG2Wb2MLRG+sV5knwr7AS2Z9w3ESTv951w5oplbGA
         Zw/+GlMJLOkR8R9688o22/LSE6t40Y2hN9U5wBahPTPB/e9e3tYViFhVfo9vG0l7KjBZ
         cTwznemyXMAvsfHGU9TCHLL3luOiicC9qFKwuOEcXsUmbPT8o9CIbFzEDW8z8Fx0f/Sl
         VKE9DyCA3ayeAJDWCOWZTcOOZcOpWI38MY4jazyxR/zAa7ZRsHyFLMlD9zVh8ACaQxJ+
         wqr18xqMiC6Nyop/zzeCkP6P5oN8yh3F5mVNRbG7LBmZch0Vk5I9QWPHxg+APDosJuI1
         7IAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776278782; x=1776883582;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nTUX2lP8ldkGAZ7wG7bThpxi+xK5iNQ9DFcH7xMd/Is=;
        b=V2117vnay+eubFo9SGYFaqk442K+bWd4KKVJ1cKl5GvuIaZL1YwVyyt91DJX2I/Mai
         7UULRtPnUhknwCVOhYknr4Nmvrd1x1mskHFZQhO/LPzbdxjoz6gMp0J38fs64CPCZ5e1
         uZIRyEUJFoqmpriIHfoqy1d1W4DWKviRruCuz29n5XpZ8Sa8LaC/wVc+4Y5Rne91gNYp
         fkr7drgBgKqu4rpa2qp5gYmp4PECL+iN3lxZe48LdFPXURpLKnd2e8KfEpqf0h61+c5o
         SXIEEwvWUp2c9bnstxAuFpnAzjdA7OzoJCVgisEie/XBUnduAzyTkMIRuyjZ1QCkaI5d
         6aRA==
X-Forwarded-Encrypted: i=1; AFNElJ8daQVLZSFTNXqR83mwvBXPHYJUg4d7or/sRacKwSf5InlL1QiB91nMCxylFx8zO5mqA0fmKMHY5A==@kvack.org
X-Gm-Message-State: AOJu0Ywn5/4tOcaNItTn+aiYIJDKM5tKR6DICRUFKLRjKaZAju3Flqid
	9GNiXP7V6WcUYvm/m1eGOD4ixBrESXdYaOuqdUqy/M3Oviy9vicE8qvQAPN63g==
X-Gm-Gg: AeBDievbOJyeEGCpBd+HLy6Akgbv5oyg+zRg26vdAcYYp/CwbhSNSNAs1K7U6oBZCCv
	IqXsd8c1Q3Mh1U0zDQRNIx5Ntm0muXYClp8fskG6YgEOGsXHFTdBQ8V6oFVAc5+jg9hVbJcPnNq
	WEp/2JMUEa8sOqjjTOjeFI/gasY7vR7oK+cksEoAB5nX5Ql+r/JCKjyIQfG0doNZmQDOQSYUKFl
	HrJWg3lyEGKSQ9/P3VVqzGor5UABfnmdkjWBX3jHMfq2ClqrN3LfFAAXErTs+MVGsqNfVrjQRxK
	dGQ8z2MxbLjAiB20XDy+1da370O7Y1C8jFclwSIlawy6JASg3hjYVsFsDdHfIIuBARZGJ//UsD4
	iTVJ6UZRci9A1aMCqiDlfgAWaPDuFD+e7mEUPeki60imWCcavzvin0HzfRkKVRJVlZIWxkedN3/
	NC15YF5+Y7gTA92lIiRDqRRCBGyo5cYlGg2n68wA2Ah6GhNZz6234=
X-Received: by 2002:a17:902:d581:b0:2b2:4cd2:e162 with SMTP id d9443c01a7336-2b2d5a4a3e1mr242397235ad.34.1776278782139;
        Wed, 15 Apr 2026 11:46:22 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:898b:301c:d085:a35:99e7:ffec])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b4782b6fd8sm40227985ad.73.2026.04.15.11.46.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2026 11:46:21 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: sj@kernel.org
Cc: aethernet65535@gmail.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [PATCH v4 1/2] mm/damon/lru_sort: validate min_region_size to be power of 2
Date: Thu, 16 Apr 2026 02:46:29 +0800
Message-ID: <20260415184629.14435-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260414003904.83824-1-sj@kernel.org>
References: <20260414003904.83824-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 666C010000F
X-Rspamd-Server: rspam07
X-Stat-Signature: sx6qz6i34ju16ctr4tfetkq5qn3b3a1n
X-Rspam-User: 
X-HE-Tag: 1776278783-379425
X-HE-Meta: U2FsdGVkX19VqkrYS1np1UjVo+p+T4w3oMvpQTMlKVI3guwEtoPSNdYJVeUeCMCKX7e0IaqC3CagxKHkCCHTOSn9ZUwBSpL0j2vV/wU2PgY32C1zqGTIPk2+4bCNWYM0miq+qcpaOhdIPFnBJ2mutMDfRVQPYACwFbVRGapmWUFAgEg3AIanQuHrIcPjH8I6HwwipIKOAdkv89NQnX8Sd3R7w10KhfbskHIC+ByKheHP1MuycWP3f7TIGxMzIhwTzRzCV5gWOhLy193+LMq/jhpwwKk4UQHDmu+ya0KTIK3TMRJCEkHrCs96MglKGGPIVkoGobMnc3qtUIubmFSn151m/o+C38vAMiG7RPNUJ6X5YufQeng7EvsECVHtGy8JjNAGWSv52nlX0azvHu1ooV1g3hgk5u0H42z99v28xDpeOejZ3ADZ39sEopIqSZtPq9aEpcRHlFzHIrPazlWJlzMcEg2O9c+nFqv4VhJaNWqOIDpZWN6hYjk9I9K80DqIYB9T+8BDgUrgyLo2UrpzRi+xZqic6cthWzqZmwesXUUryG+9fqUmK2l82pXwcRm2+ukYGW7SWL50D3SivMYly+M8We7H8d+8mfTWgLN8WDyF3Ejm6LoxmpAs3PVr2iQFzHEKuoVV+wtuf8+oAutztGsguEaJEDaWf21t2286Mux++wdVpRntRxTKzh4VX/0eq7d/rpFBQydIbHhMV5wIICaQ1p/5ol1nLJervGGhfDhWXwnVUvDSjpcTWcXxBNfASlVXZJg3FKsOnrTCFHI9JOmlZUJnOJezW56p88zlrWrwvfQR7fs5vgQin4yvhesVFx1fyZnWu9R5iOYlNl9pBUaX+PwqwWs8GF2JnWGxkkj/oDo4sO4vmi3KqIP+3c2dhFVEkDy+NwDVdFY8aW4IehkqIOGGpt07XNn2CSXQky//MIaopQXsuCpx/RR5MOml4hhdzFu3wBFoMdaipDk
 RhcbgcMM
 PXq1tNFVMNHg/IYEmrSpy7mzvST+DeGtnModuMOW2ME+/KzrBlOyOdGPeXZwKMsHJZVScvjfB8xmDuckYxssFd2JCMbM3z9qXnOmE226rQNcdx0T9nACrou43md9pIdOZMUWTT0vyEmQhoUhvSOVzB1Q+rCwzzYLd31sTqaOjTPTr1WgZfvU33FIvAX7Ng9x/f4eSTMLF8x5j1OJbMdyxy8krhoB6+7Fuq7zZl1XXJwt1dhCq7rgc9HRFfCKJSf68IfnRt4UhWPkTEqtPXy8FeFOznQCoCMF/S5uLtvoMN+D5av0GFCQMN6vnl+aPf+/SGLagM8a2GyGKMct8MOPKVrAKItzzgWN5gZKHPDiFjXsiYNiTjBVv/EATR/3y9yaTiqN25r4gbzOkNP7IPgcnduDzuxExWOESfSgrQDv7wRDXBzDeU19H9q61MQbvhCb0khPcn03hBillLmMQMABExqPA8ED6mboJKtxznVmZLV5DW74=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 13 Apr 2026 17:39:03 -0700 SeongJae Park <sj@kernel.org> wrote:

> On Tue, 14 Apr 2026 02:48:45 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> 
> > [...]
> 
> To my understanding, you will make series B merged before this one, right?  If
> that's the case, you may not need to add this description at all.  Rather, you
> may better to clarify this is only a minor user experience improvement.

Yes, I will make series B merged before ths one.

> [...]

Best regards,
Rui Yan

