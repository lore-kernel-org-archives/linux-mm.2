Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E639606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 11:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=GUG+eMYz
Received: by kanga.kvack.org (Postfix)
	id 27DC16B05C1; Mon, 23 Nov 2026 06:47:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22D8A6B05C2; Mon, 23 Nov 2026 06:47:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 144116B05C3; Mon, 23 Nov 2026 06:47:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EC94E6B05C1
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 06:47:08 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 804B04089E
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 11:47:08 +0000 (UTC)
X-FDA: 85466207736.21.4387405
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	by imf12.hostedemail.com (Postfix) with ESMTP id ABF4840008
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 11:47:06 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=GUG+eMYz;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795434426;
	b=CrbRM2b5ongidlU5mDyqWt1HWEyupaCaiq3gBpTZPqh6glcsGxKTehpl9smHAefF+Hz2Ht
	S04DEB9B33rYbDbapopfCiJUMrFPU9z7YgLUNCBNJtsbXCCb4rUGNl+RFTnwi+MbIxr5Du
	YhKC3eDrpJZFi1bRoFEUTFcs/U/sblo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795434426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bg5FSTN0ePe7eQMCpHVjKBFbVINT9B2P1+zfAPuDdmA=;
	b=TjUKKJYEfJBLWhbnkbY4iWQhnj8JnV4KIlPkgvZVOAMVYW4ORuVohZZJfeeiDdU0pPqL0R
	k9fkVzbkRv7oFb9/IsFgZYZ3lJ0OvzXgjxhD1F+7t7MoITiELtAG19TRrkjyDqkLlG2ABd
	yZpN5jQRheCbk5C/ITgnEQINab3chlc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=GUG+eMYz;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-cdb75699c7cso1177097a12.2
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 03:47:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795434425; x=1796039225; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Bg5FSTN0ePe7eQMCpHVjKBFbVINT9B2P1+zfAPuDdmA=;
        b=GUG+eMYzmsD7iALCMQaexCu7Rr5w6mYiMlpDQxAut6310o4FxFYgf9exeiz5tHnvY7
         II/CERWZk6FuFCX7HQ+P3yIIPP1Mq1lMcGswK5EtEhbQnaORBgnPHSYXMoW8uwtt9C/R
         qkz6KBXD10MRzfEZoPS21+OqSAo7tppTocwLmScJbb9b+4Y26THJxOzyJqJGB/SbTcDW
         Rw5PTcB2LGVV9iaHwTzaCzsr+EiYclX/73Itti+TZfTO9lhtG1oUPaN6pHL/oDgQdGQS
         ITBdhp0ezj6TVj1P/o0uKxcmIAuHgaXOZ+op6GI4NRuqxoSGW/2HYUfVs36GKcSTBfIT
         s95A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795434425; x=1796039225;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Bg5FSTN0ePe7eQMCpHVjKBFbVINT9B2P1+zfAPuDdmA=;
        b=iWtTF11pgVJ4jrGSzaCUVhmTg/J5NmhBub9S2NUvkM9sY0RZmybJPz8IlemAnlVPnQ
         ddyMWBYlSOT6EJ1M6aPwtaNuZIljdwfbTEghjci6ECCvqhpnpkstYQ8x5n+xeAfUX7KP
         VbkuxRjp1sFx8d3V4Fu/smANxXmGAAq9ggFemjQmJE+e0iDzN4B4HdnAh+kMc7umWAbD
         x4m3wFiF8wAwqeyPPgVqRCseQkcKgMT2xKh89HNF0PjnUD/3U4Rpk+p2EaEle/uNQn6H
         D72BNW6GzNyPiUxuRKr0fWtt8Fd9nUb637Jb+ZHQ0ngt4AzfeyURquhYMGtxYXfvUTxS
         BPBA==
X-Forwarded-Encrypted: i=1; AL+hErFiTcfwvQCD2ZF8Ty3jrFH2VCioc2iVcgGWGHKWyWcj7KgqeGau5Siy7CYHypGXkB7oc5OWbU087w==@kvack.org
X-Gm-Message-State: APuU4Z+fLTB9pQ2Wv0TeZUXGNp9VphIXs5CEkNfhA2Z4lADx+iySfH2h
	jj5sxk5Jhmuc7pTc3fiZR/tU8jaiL/pVZZ3ffexVd0BvKKR8RrJP5U5sdoaORmrZYa4=
X-Gm-Gg: AZFdTZc+p2uFHPGmKRv+1cuInbUl6zSNO66YnV6YHAvw8lws1j/d5Vjc+3JjXq6im6s
	X7HP1QqB3XQ+M3f9NR4YHSH1JKLXVMa5YCENzSWlicVUnxN5pVYlUp4vC6vyKCvlKBKnM/L1uqk
	UVzDVPmq9TscTTdxhfrkAERL3+4ku22V9PP0VWwxBC/rQdAsaBto5vG8d0pCUllwZLhNN9Ywsd6
	qhEr5PnQSJiLtADMCktIdwXzoZI6AARyPSSbxcMkXQhcoUAOt8DKtPsSNQ/57tRCZGH59naMl2q
	6RDSQi71CJcIiBj1FKeqC+RXSeFdSZbsvTmjPulHWQy2a+5C5lQDYGKfFGwAIqd1iMiwqCBJASE
	IHyxCktu8ACFGrCm3litwJUV/vrLExm8yJVJXyY2YsrlxHdoOZWbe0IUHv6nlkM6J0cQM7A0cUG
	hysYLwMlBLnt+onZhfriLnsn6kXahgQvZgkGOIGs9CjbPUMn6aUjCmUuH5FuwPQfw6EpesUFCzW
	2cv5ijQ58abApmpnHzyCf5Txou19kRzQxK8AQfaFQpuFTJPVTRii/mYht8JIEa9b4MuQvBh3UwL
	9oU2Vl0CTteFahBmIoDkandT1RLltM6jCjxkVpGbM7XAwLGBIpPISO7hB7GP8vr13x8d
X-Received: by 2002:a17:90b:3f0f:b0:3b4:1b37:ac89 with SMTP id 98e67ed59e1d1-3b41c8ff71dmr15235429a91.34.1795434425295;
        Mon, 23 Nov 2026 03:47:05 -0800 (PST)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b56ef9fd16sm14380045c88.4.2026.11.23.03.47.01
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 23 Nov 2026 03:47:04 -0800 (PST)
From: Lian Wang <lianux.mm@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH 05/27] mm/damon/sysfs: add reports/producers/ directory
Date: Mon, 23 Nov 2026 19:46:32 +0800
Message-ID: <20261123114648.7138-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261121210013.130397-6-sj@kernel.org>
References: <20261121210013.130397-1-sj@kernel.org> <20261121210013.130397-6-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: ABF4840008
X-Stat-Signature: ukorowwya1iymot8zo8u6ghek5dosedw
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795434426-542552
X-HE-Meta: U2FsdGVkX1+BN19yo6+cSxAXf9VLPrgpDaPfbMTa51rqj6Umk/w4d/xpIKeDn/qU1uPhnyu9zcuQPW4he/Fr0MYv/HLSnEfKwmfZgGnDsPBshv7tUpQpFi8acxab6ORyhZaXBzfPV8lVthdNURHyFvo4jezefBDNSQoiFBe1rQRj0ojKRI7gKLVy/AinD1y+WBG6lLAzsK1dEXkBkF+93TcQb95vXSuZBmCd/vZvnZbmZHX+AshSieEgaZHJ32CN6jB+fuWo8XeJ17K5rNPglG4cOFdqt6Vs848CAgZ0URKFSSnLaU02HFa11FtXdnlrcaKmcQByOGFrvkThsHWmWbK8Xu15xJtsEkn5pBK7YUF+AbpaICtnzvnj4QscNf2yqIpwJ8mtCxQXR78rUYAeMiGo9Bb9aEWKwF7zOaCdwmfYAqTweTQkxMBqeRGQLznhl9lmy3mJPJ1PTLbHrY5hxjgK0zSDInQS8xxxalHo5gD3fFKxW6Y0+8GfnRi/7afNcQda75F9dPWrYU7lpeufFiNiBmCuxltLcwGKQud5C4VtEJDzKIanXQkN5chfbenZ3x1i0I0fU1OYZQPndL+cTI8nkymiOT5RNAirUsiqOGP0j8D0gf8XpaSyXYUff4kX9MnvyGqSO7Hz2PZU58+XWpyHuuPZBOsFlD38XxZZSqG8Gi6UtegDyc08qN3RrVnl/qpQwSIxIIT7JGEeszSjhe/T1F9eHVPii2w2KrsFrKQUSDEisF9bvv7uGa/eHGD0WcajlonCvbyg6RRPjkxGcSrl37GwhFHI2k/BDNO55A0cJ4DCgRqLVLoX3EplsUl1QrtUarD/Ywaj+8LoSPZ0Vhukd1pwK2YhKBPm9Uu6uItGtdXSjKwDkeOdAMliJVKFTzciwbcWKL8zyHLNMye7ne7UMTerXJL04ElkAdtG8AuHdb+YPfYgJCmL5ViAcxnpGJ21iTlXVUncqnfLrDn
 uEFhGriW
 8Nrl6Ve5ej+TxgvBuIt0DAmZpjLL0pnTtzcBdCWo9+Mbvm8wMwm+GpFuEcBoJQ0jt2F8Ic+e2CiLAwKKyGH0mLd85Jjta95qW4mx3zkBJUBZka+bLlSQR+B310EC9IaGd9DAa+mf5Y1o5oqVPTXylWcAUEx90uCfDXQJKbiTcHJej5Kc3xIo1RqpBGHnRjwAJYm6Bb7z4YEFNauXWuNXNBb9CJxmoucTWZezTxSTdXhspWNoua7eKikTWLz360D84MfAUCTw02d/FSpnbcJgZUvuNRVI+r1peYksKRjpysHCQGBxHj+Uv1PiHVBxfyTf5DAZqOYVSqxEi3cc90F+T4u6W2Gn1AXYvJ5c+G3Bwyi9e+UBwita9BZ1chjVjEmoL6WzqjzcAr6uoO/qy5pg1PR6g1IVywhe++PURpYIrQtA4PSOWswd9mjgC487N47JL132ciOoXJumn2KCScSYGI9iTMS+OMKdriDoBa3Ok/XhVbE1x/E7vnpZMmQRGXRLXCZrhzEnPzz4y50AhPl/LVvuJlMEAyBjRXfYM6B8EUkcd00c2Opo9xCq/7vW4ynFejt2g2vR9ZNAquwVD+RFS0Nlzj/HsC2kCVm7Li1fEuZgFBXGwqumx1pOBiR+KOOnbysnscNJAy8t2BjGmCb3GML5BvF3Ue+COTUib05K3RgOUVv2OtDNt/NZmb6i7Rj0dKDwQzgUhHgcmk76K5sQr/zwsgCrHK6tyhdv8ZfOJfAmm0LNCPIL48yFi9A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, 21 Nov 2026 12:59:49 -0800 SJ Park <sj@kernel.org> wrote:

> Add a new sysfs directory, producers/, under reports/ directory.  It is
> a placeholder for files that will be used for controlling DAMON report
> producers.

Makes sense, so LGTM.

Reviewed-by: Lian Wang <lianux.mm@gmail.com>

