Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99F70C44532
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 00:25:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71E006B00B5; Wed, 22 Jul 2026 20:25:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F5A06B00B6; Wed, 22 Jul 2026 20:25:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E5A46B00B7; Wed, 22 Jul 2026 20:25:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 35D606B00B5
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 20:25:54 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B09E614030F
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 00:25:53 +0000 (UTC)
X-FDA: 85018148586.12.78685E8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2285A80008
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 00:25:51 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ddntcYjO;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784766352;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AjmV+pFTu5g/gQQSb0j7+dUZGhkEqEku71eK2pBiGFo=;
	b=nTJ0lMzP2k/odtrO/sVcNxiP5poxFAhbYf0XJhcxWQePgdsd9UBXVKBMH5DPDpONXKL1/F
	Iw+PIKAUBtHwN9vafN02ytfkQwLQ+LVl2gxq405axlTFoJ3Khj0WEVXyhT4G1KwPHegg81
	ExSmr/uJ5LCrNm4TGr20ft1OMLFyr8o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784766352;
	b=i92Kyy14w++/mo2beaSNZIDSFOypUuIHX3o9ENaqFgFvvaAOLJsZoIqkc08Zfu+h14vXoV
	fN6N5mMiuu/J3Mfu4d5ali2brs3hIUJxsUh1bPRI5GMNDG8kcBzdOwb+IMfk5B2A7D9ux+
	UqVDpmtztq/AHU2XSLHOC1qvOWqg8uk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ddntcYjO;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 227314073E;
	Thu, 23 Jul 2026 00:25:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 641A31F000E9;
	Thu, 23 Jul 2026 00:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784766350;
	bh=AjmV+pFTu5g/gQQSb0j7+dUZGhkEqEku71eK2pBiGFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ddntcYjOLicDsdRqgPmCRvpTN4D/1DpCsOyQTpmYu753AnHz1gwUKf8gRu7Cbce8g
	 3sJma6GbAsJNZ02N+60/1n4A8QFWR84kj7OOk8uS2AMcDzzh2GH8M+8ZGzLD8qVnUT
	 FcIJfjqy2qh7GI7jWl+wr6lnwnQv4onRJ8zDfxe2FPlt8ocaDxkYXXa91o5u48qjgd
	 KbWIuwKMdDiXMd2LTKEPj4Jgn60MvEuoMTFlRXPgJVYQhN072nH1Q7JS0By8XG3h6I
	 VH+mxqPEueLJzjxspV1MEMSFc0V3v+eCsT17s3yH4DPcgfdZ/ZoIlCsBlbPDClhnhH
	 HK1/+mATDbsqg==
From: SJ Park <sj@kernel.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: SJ Park <sj@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Kees Cook <kees@kernel.org>,
	Andi Kleen <andi@firstfloor.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] x86/elf: Correct comment for STACK_RND_MASK()
Date: Wed, 22 Jul 2026 17:25:41 -0700
Message-ID: <20260723002542.96123-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260722-fix-x86-comment-v1-1-605080af988d@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2285A80008
X-Stat-Signature: fyjqnqb53asi97qg1r99xd7tqawhz5ei
X-HE-Tag: 1784766351-992418
X-HE-Meta: U2FsdGVkX18PLQjPbPOVEF1Bqs8cJtlT9cVOh47ip/WYnuQc8sC1zT25zn/jr2/xzPzaKq/5V7xrLx/TveY+29654sGzWGYaGXibdF6K+WNxWkAM+h9uetMfswZqObhkiPhy24aCfNyK4Jzo1MGLT0bxGbb8hBCzmatTR0uh8J1l7QV5Evq41e85OZWUYtuDW3j32J4njbpdXiKx+1bhlgM/U9E4SpHjP+dhtNgmzWs6j4MqmDN4q/WsSJK5ze6p/VyOGNW5q2p6hplNe/Mkzz4w0/V/V1JF5hLBELwC7C0f4P6o8VN3SBas6hLU5nqx3UA5+av4cPQfoe/tK9exV5VOMP+FOJDT7ufOTv99vpPTxNyJxHoVGF4jyEciY9wkjpBdMtM7i3nAgkhvxpluj6O3NLIy2kfF3iUVvDJ73xWf5bi8eSnao7BTirZSih5ytWVOkJOXckn1iya5AWQpnUyY6RKhNY1XKZK2Mqq1303PHIRBeEQrBw20kgskVVGY0jz4ovPA80su9gkc1DnWidITpuSHirehkCeEtV005XcMqIfHfHiTEyHz590dIElqYZzk1mIGmhzfZzMrGWwcRUIUqtahYc/xArPpcNrDurnTpG2B8hC5xIQvYhgIy5UBWTO01xMwTdlO/yT0KV+IPQ7gHnRIFUQQ5Z8kt+j8c3vlJkIDUNkD0inxdBv5TZbk2nUl5OHJ2YBxdnPofXeqY3rIW7uXSCQ7RTFt6hkZRc2/lLX/HIBaxbKAAocQ5NNlRsvzza+Lm4uGd1INm3n5qcFue9duqjvZgGRoTuF7p1SMyQ7b2hAQGdqk3AIqhedBEcJJyfuV2OHuKluQmqXpWulzK3Z6/K9Ex5jrDNfwoWARek9Fr9rwi2ShqDy3qwE/lINT/87ZWbFcdhXmppMaP6V5k+mQ1fvXj3Ggp6CDiLEv7mHXlwoeiR30sSVth9XKT0/yXs5+IFEZy17EHZ8
 nTd1Gjpt
 nwmYWtUSV2qBKZi37cH/NuUR8XBRAsMSOITZqOkNJMJw3YIGA9hlfGIg41bsydLEa/NMoEL6ga4wbBSdESqDjaFMoI8UsRk5d8NYW1KDvca2b6PeUsfmaC4D9GKm/4nkjRVZjfFXXYzhvkz0QyBos3rFlUNpssf+Fc7ZRSj5t4Kx22MyIKiTjJVePRNCNQXRspYonCrz+ky/g2TP6RA0g43/wHTJy4+F0Q91HqHf7i4Si5zH8V67Oqu05Worpk+5dCg9GY150MVlXvh4lCB5/nve+4vhYL6Tp84uW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 22 Jul 2026 19:44:43 +0100 "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:

> Commit 913bd9060195 ("[PATCH] x86_64: Increase the variability of the
> process stack on 64bit architectures"), merged in 2006, increased stack
> randomisation from 8 MiB to an ostensible 1 GiB for 64-bit systems.
> 
> However the commit actually introduced a mask of 0x3fffff * 4 KiB pages
> which provides 16 GiB of randomisation, not 1 GiB.
> 
> It appears Andi perhaps typo'd an additional 'f', as 0x3ffff would indeed
> provide the stated 1 GiB.
> 
> Since this value has been in use for 20 years it seems sensible to retain
> it, so correct the comment instead.

Good catch, and sounds reasonable fix to me.

> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Acked-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

