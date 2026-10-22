Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C1DC606A31B
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 23:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=sina.com header.i=@sina.com header.a=rsa-sha256 header.s=201208 header.b=m1IwdgDI
Received: by kanga.kvack.org (Postfix)
	id 9619A6B0A23; Thu, 22 Oct 2026 19:25:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 912C26B0A24; Thu, 22 Oct 2026 19:25:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 828166B0A25; Thu, 22 Oct 2026 19:25:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5D39F6B0A23
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 19:25:56 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DBB0A160355
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:25:55 +0000 (UTC)
X-FDA: 85351847070.21.0D86C5D
Received: from mail3-166.sinamail.sina.com.cn (mail3-166.sinamail.sina.com.cn [202.108.3.166])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7C5A540002
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:25:52 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=m1IwdgDI;
	spf=pass (imf17.hostedemail.com: domain of hdanton@sina.com designates 202.108.3.166 as permitted sender) smtp.mailfrom=hdanton@sina.com;
	dmarc=pass (policy=none) header.from=sina.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792711554;
	b=d6zsf8o9AZALnQsNJI6uWNtAQLX/n7y9WFSCLnzgE1F9Hi1IYDIfQu4clTXIiJHFkbYYMC
	zhwoh20mA/Ig1rs3v077fCPLf8q0MkPe6STgyyHnauUARwW2ab6erHVwSCuth57bG7nhj8
	tbNoJ7yAQzNDNCe5b2YGH//QUelhgiE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=m1IwdgDI;
	spf=pass (imf17.hostedemail.com: domain of hdanton@sina.com designates 202.108.3.166 as permitted sender) smtp.mailfrom=hdanton@sina.com;
	dmarc=pass (policy=none) header.from=sina.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792711554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=couYRd8E8JXWZWDdDnGH4eKgPjAkCu1Qn2pLPm6IYGQ=;
	b=FFwSO8xbeAR/kBYUEFzPMBE9tWWPxfe3SY70q5l5Z3voIDleIAoB+6PnEmQQj4vI5bbmvA
	TDNwFZxIBqWs9SniM50SbmTNkXnnxiZgKuV3Kqc9Ox74gykYeoyMRQNsr9cw4L7NWERzqp
	yK6/eQSVXvWANNbX13pRME0/2mS+2xc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.com; s=201208; t=1792711552;
	bh=couYRd8E8JXWZWDdDnGH4eKgPjAkCu1Qn2pLPm6IYGQ=;
	h=From:Subject:Date:Message-ID;
	b=m1IwdgDIVCPdVFpml9XFB0GLY5ZRAZlbdybnycppHsS05ratj+f9F1M4fJi+0fAos
	 eWWuI7RUxsR4mCzdHSjRNzHgGJMEZ8YG9bdrnbT9jurquqGT3FI3OAb8IGqgcqPaHI
	 CfWYsdSRUVHbFZJbPaeMYy+2Rg1ChVEspcm3oUww=
X-SMAIL-HELO: localhost.localdomain
Received: from unknown (HELO localhost.localdomain)([114.244.129.212])
	by sina.com (10.54.253.31) with ESMTP
	id 6ADA9B79000039F9; Thu, 23 Oct 2026 07:25:48 +0800 (CST)
X-Sender: hdanton@sina.com
X-Auth-ID: hdanton@sina.com
X-SMAIL-MID: 2334166815986
X-SMAIL-UIID: F945EA0D6C1C4AE692DD24BD6881420C-20261023-072548-1
From: Hillf Danton <hdanton@sina.com>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Brian Geffon <bgeffon@google.com>,
	Barry Song <21cnbao@gmail.com>,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v6 09/13] zram: split zcomp into separate R/W streams
Date: Fri, 23 Oct 2026 07:25:37 +0800
Message-ID: <20261022232538.978-1-hdanton@sina.com>
In-Reply-To: <atlt8YGuSxgRb5uE@google.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 7C5A540002
X-Stat-Signature: h59fk1xhte7w1okso1cmumwp9wxwuya4
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1792711552-496461
X-HE-Meta: U2FsdGVkX18+iG0czNxgvme07gzBxLMu/wbZsDMPUfIoYsa9tnJLSRw3/5Ho6Lem4ucOmwK7Jj6RzJihcT18oW6QoCp7r1G3A18MPfhMqOMlEpRQkZTF664THF78fMS/fibpbcbhJCe3Z2aJLBXyw3kMQq3J7juBVGGzExb/XrKSNXa3Mv9lDxao59WhMVXnRfehDhUbacb9/HEC0BVpnfDq3vNNLT9ayhrYevkK36PtZEUBql2PYxsjgwjyfu+taXSivPfBjeRGtld7oURMMF/998SHC0qB3JH5xZEQLns61r5hgdPxrZrnbcr6f32ox5H2UqDg681FPNUg2P/vH2m359lidoCnw0DmyPIo2Ubb/Y2VvYdrjLIU4DK4Nbo8EXkKig0+RaaWj3M9H6GOAaJxIsppeZZAE4lM8r5piqvcEe5wRhsqChLXz/55r5WAtXhYAVTpEPPWDaDQa/Qr8edR1v2jJd+1FZxAdy7FytEnZyFE5y6iwRyxzRpGtFYye3nT98ggHAy9gJGU9a3S2P5uhvQCRpOrBRkBMx+cwuxRuxadWItwt+YYnTPPwlYTx61sRyzhSYpn84ttGafluzp82csrSwh16BLAOaDd0WuRSRuSNAR5BmAOY8Ph3q9Eawl4ZKhlQzV7W6ty1hDqhz/gw+q0vTBntsUvqDj6lTd//q5/BwFtwDH6G1XGwWcKsPRDSk0STYt+ScEeetQWagGBHwOZTuHXQC12WyjwOjFpiyRa5m2a/sH4RFfWBEW+5ClMWRmwvOaKL1gmBiE77MR35DjpGls97ODMSzof2dFz5UGMUtkJdFtj0xZBM+hZN5g58T8TqxfOt8t/CsKaUH8QsynH+hhBfpphbHG/MXoOd84jYeVfW/DWTJxrxWxfioBqUnNbE7jKLiFsAcZYIxnhv2/dekBDd55uiEYpE+gNZIWc3oXD2rCJXvko3bam3qMs+WB8Pzfn9Dveltw
 JnzcA8Jc
 gw5PNutdb8fExDKUOxCxXCOqR2M4gsUgSF31lI9eUS//mKXHSau09o6IPljplfuZ+TC2DKtL1uKDL7wL+Y+7azOx8R2HGYR20DM2TWWzxWhmAt5F+3/dVBHFwpdZilus6/f4QrWjHSgFXiBfv7ZS2/L6LFsIZRG2AJHqF2EeuWZ99x6nZVRgVXusZuO5hf5NmObygbzCVSYdb30AGN5nhuWwxzBstYdgZ75BdhB1XiLojjGMP1JTo0kA+xAr+0LAuiqKHYZp8kKKG7u1LAeGmmYNWCuPCqAhRY+XIvtIkfUm67mAJZHv64pGrNw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 22 Oct 2026 11:06:53 +0900 Sergey Senozhatsky wrote:
> On (26/10/22 08:08), Hillf Danton wrote:
> [..]
> > >>> Given lock like mutex, priority inversion happens from Monday to Friday,
> > >>> but I wonder if you are inventing some wheels in 2026 if proxy excution
> > >>> works for you.
> > >>
> > >> Reader-Writer split is a foundation for further improvements (like
> > >> singleton recompression stream and so on).
> > >>
> > > But that split is not needed at all if PE works, yes?
> > >
> > 
> > When the number of locks and tasks grows, I have increasing difficulty even
> > describing the lock chain that you in combination with Brian are unable to
> > handle. That is why in general PE is prefered over whatever wheels you can create.
> 
> Hillf, if we reinvent the wheel then I'm very happy with this reinvention.
> But we don't.
> 
> There is not a single reason for compression and decompression to be in
> the same context - they don't share a single byte.  And there is no
> reason whatsoever to serialize them against each other.  Compression and
> decompression should have been separate contexts from the beginning.
> While serializing decompression with a PE/PI-enabled mutex is cool, not
> having decompression serialization at all is way cooler.  In addition,

I see compression and decompression are decoupled at the mutex level, but given
the "same CPU" in your log message, nothing changes at the CPU level, reguarding
the micro seconds to complete the two critical sections. So the decouple sounds
like the half baked croissant, HBC, the Eric Dumazet dude sometimes is happy
to deliver to lore.

