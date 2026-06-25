Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7463CDE002
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 23:56:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D14E6B00D1; Thu, 25 Jun 2026 19:56:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A85B6B00D2; Thu, 25 Jun 2026 19:56:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1ECB76B00D3; Thu, 25 Jun 2026 19:56:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EAEF96B00D1
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 19:56:54 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5AA521C1CD6
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 23:56:54 +0000 (UTC)
X-FDA: 84920097948.10.C0D2505
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id B4B5B140002
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 23:56:52 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UqAJO5Uz;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782431812;
	b=187rDTXjiwIp8oTFTRm6GMIQZ5qLcEMq7ijrayOlTEKXpwZM7vjVAVr4k+EopLhaA6PIhz
	iHR1VWs26TS6EFJlRnijQCZsqjfEVM5h8vfK42DBctSmRwG25UJ1gl57vQCurENe0j6QTP
	TCM0ibgiRfcDk5nURaKW2mfiH4EKq+I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782431812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kl0uaEa7v1YO+p58aWA8kk6kKslV4QuP9YXWBU0Xnvo=;
	b=GZFzlWACXsQb0Qz5qIuUNuIE3Wg7L3+ocJ7XOG1QhEDqpYF5yLUmd3GMEqioVUBS9sxtlu
	K5FBlFt7k7WxGjXQnW8WX6/cd0YMhEGCu0OjUp0nN4Cp1pJr6OKcQw4CQMtFdA6xnGSCyb
	pCI4UMC9WXxJrs6LD4T2AOBdFBNGybY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UqAJO5Uz;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A0422435FD;
	Thu, 25 Jun 2026 23:56:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C2291F000E9;
	Thu, 25 Jun 2026 23:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782431811;
	bh=kl0uaEa7v1YO+p58aWA8kk6kKslV4QuP9YXWBU0Xnvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UqAJO5Uz/AA1XT6fV22zU9FaNbwdYc0Hw/vCstcuJ6ISJ5QIPR8AbjhxcHgkPW7gz
	 2ha1hMCustlZnEBc5u7WQ7PF5t6P6ZdBuevasAbYUNbyKpUFIbG5yuMQ7leQlSEyIR
	 vTMtJvcPDmejdxApdQ9/VFBYQisOS+Gi9Us/hVomAqlWzV2lZy2wGRy2xXmeZAWQC3
	 6EhKHaTlcQcTt/g/gDC7P9j0CeN40TxlOZKRcLEG/9XgZhveMbhG/8XotqPwUBSwZI
	 m4nR7VtzmNDcpeT7wfrw3wN/D9J8q+CI2aq27YZovOXQAiwp8I0ea1TGBwzlbmg212
	 PArQp/AjOxsTQ==
From: SeongJae Park <sj@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	kent.overstreet@linux.dev,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	hao.ge@linux.dev,
	jackmanb@google.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 2/2] mm: move alloc tag to mm
Date: Thu, 25 Jun 2026 16:56:36 -0700
Message-ID: <20260625235637.84801-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260625184857.2193482-3-surenb@google.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: q7zdcpnfongkg1ekqxef3caghuwwkw9r
X-Rspam-User: 
X-Rspamd-Queue-Id: B4B5B140002
X-Rspamd-Server: rspam02
X-HE-Tag: 1782431812-522473
X-HE-Meta: U2FsdGVkX1/APEN+MknFZmWYtxTF7PxgY/G0jIJ/KbHQKQHYuDtMzzZb5mFy+UEp5VLq074tItOloggwg3BiyVIZ7GyaoF+BDgBl/cJ0KtD1Ueb9ssJL6A7CVKvL5c6UhvKN0H5cxtOg+UWUK/tDeHpHrfdXBrwg3IdAw3WtrQZLCgan3jaXXFPyQwd6iMTRmAfFsPs7XiaagTdBCiO8GkqbV/p5PIxL+CSHjcAXQc47g49gcpZC02AQAPjpw+ekBSHr2lf51eeiDBBOM38t6fEeFm9ym3Y6EYaev34dYr+69pvK4k4dIaD5bITvUN4NNwMYjgmY6+i+6uZoBWOsBRtWjfHV6rwvNH93ZFX6asoIlQ86KGqEZ/r/VnHDYE81OLyND+6VI+gSMpaoEU0SgaT6MpGlCfFP2dvwHd2ot5CzdCx+8NQXAW+acfsaC9gfkBYjQ+DHXMXEhfTeKv0SOkroO2lJeaRgkc+TuPFQwPXSvkCGicuuXSas81sB9Jh18bLoqgP/751UymOJuI4/OJ68ItjcTyRnFbfn/zL77rlOmkrmbDYdv0ikCOZPNTYE0ABY8tn5WhzMKDdAagfYeQXrBy7VIIZ2Av5rB5ayf4E89LXF7WPAhG8cwJW+0Bt+E35/2C7we3GfqLbZm6jLp1b49ICprl1plYjYu7Tsi1wNWqibWAQSn0jaxBDk00lBVGN8MLpRt6B6uh7R5ndOGxm7SQ+AKX3blrxb1FRp/BLE+oefPMWJwiyjDxHMa1JfEy1Hln/P504cQJ2lFgfnN+hqsHpB1wNTDnaJXAf6tBHBrgEo8oaHsUm2/fl/4amKtF3yj5eQugcPIYVnyK0uQNwW/tFmPr2n5TRjaZusVJXtqbuec+sWXYFhVFcohlA/b0zUprZggq/Kbu+ahnxyYPdZMpoSP8d7NPQyi6jK5OXeF1RM8yLoGZpSdjWgOeBWqrDGzFOLE0PxJQ0bLFt
 DOW0z6ya
 /+940sQrhlz/9/t2Q2JugxbzMAKcadjsqSb1yQIK/PMOzzjgP9d0sn9XNtqqNIaEVEKeAW+qTB4k5Fkg+ZI6S3tupl1nF2qePT0PH/fQDxr8dnTb8Qz3ucKP/zK/5xvneKpzG1tnyImfAPbRBtZNvfdIpKoEgXqlKyEd7oUS338gvNJ9qT9be7yEcM1DqxG5vH3Gx9pmhdUa3cr5+J14elvVJ2uZ+vEfkxF/xiH+Aa3jAfsUpiqXuqvz5g4M2PQXMPgOL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 25 Jun 2026 11:48:57 -0700 Suren Baghdasaryan <surenb@google.com> wrote:

> From: Lorenzo Stoakes <ljs@kernel.org>
> 
> The alloc tagging work is really mm-specific, so move alloc_tag.c to mm/
> and additionally update the MAINTAINERS entry to place it within memory
> management and port over the Kconfig and Makefile code to mm.

Makes sense to me.

> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

