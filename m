Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F022ED7B9C
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 10:50:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E0596B0088; Tue, 14 Apr 2026 06:50:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8913B6B008A; Tue, 14 Apr 2026 06:50:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CDCF6B0092; Tue, 14 Apr 2026 06:50:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6E3D96B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 06:50:03 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0DB6258FCC
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 10:50:03 +0000 (UTC)
X-FDA: 84656841486.10.6E024BD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3D9D98000E
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 10:50:01 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aKhZnflz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776163801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n4udqocBH9ZgzH2mwLyYL0J9oZUTqD9b/dzFXjdro0c=;
	b=M7LCiwg4U3ijC9dAeIRDx2x2z2ENq+HntuvTK+YxhEoGFbNZqKdT6V3K4mpKnE8pbrmVT+
	35DDUNdHtZlIRrABcRlh0L+R5tu1YUAUgl7nGWERuKJK8RAiHARf4CA7nn3NC7N2aWuirJ
	2BWAQ63mLEjyL3awgPWeHck8CBDiVmg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776163801; a=rsa-sha256;
	cv=none;
	b=oFDegaQPrMeUl/s5YaQnlE4WjY+0mpy68BwIBXidgjGwDK+uWUunBX2hsE4w9LNzhrIQM8
	JblsdvSiy6CJnB0UNy3nWbNBV6ozljvdeFgBK/EkaYtS5FBVoiWl5lUN5rHtnzd2tukrdo
	ZU2y1D+r/E5ZgqLy9UhnnQZo8XvTGrM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aKhZnflz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2A5304047A;
	Tue, 14 Apr 2026 10:50:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CDC1C19425;
	Tue, 14 Apr 2026 10:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776163800;
	bh=5dfofYZWT7uqUCmy5NQlGVWUEYkcuFDZeuPSee6W9b4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=aKhZnflzHV4fEdb8h+TZmUueH8i6ZGggshJP8FJtPE0nXck0uESdDvwfAMk3wrHvx
	 VBNV9B6giASE/DjXwbH1LrwIQWZR0lXfkDpR9LpD6oAWVb6v0srRBb2tFrRcHEiU+c
	 sB0cSTG8kamcj89WTyJ9DguAeDw4+yt+nArjAGYqQDy1Jo0ZT8a5gNYhkuH+f+ewPc
	 u5BOU8d4KCgmrNGf5SRqeVrX+QuFU9oMJVD2GEvyAGWeE3JBSoasGoTHAnPVO6zPyc
	 WbmrztB25R77wVN63mApKzmVQgNk+58Omh9kdY357xoDHR0YGEoZ+QjiZTFyRANQnc
	 ZZnQOajyqc7BA==
From: Pratyush Yadav <pratyush@kernel.org>
To: DaeMyung Kang <charsyam@gmail.com>
Cc: pasha.tatashin@soleen.com,  rppt@kernel.org,  akpm@linux-foundation.org,
  pratyush@kernel.org,  linux-mm@kvack.org,  linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: memfd_luo: fix PFN conversion in retrieve cleanup
In-Reply-To: <20260413162929.156163-1-charsyam@gmail.com> (DaeMyung Kang's
	message of "Tue, 14 Apr 2026 01:29:29 +0900")
References: <20260413162929.156163-1-charsyam@gmail.com>
Date: Tue, 14 Apr 2026 10:49:56 +0000
Message-ID: <2vxzeckh95pn.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 3D9D98000E
X-Stat-Signature: 8sb1f5fe6mu41h1fwptrr8p1io76x6c5
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1776163801-339272
X-HE-Meta: U2FsdGVkX1/NqunyKI6FF7hVIUYU18ROJxVq4Haa7NXEaMGuOzCeIMnaiLM+UGxHVoiJf2dl7gZQTsd90l0x6BC5D6vyH4QuwSIdAwbzOKjbtn5opwG2I0o0Re7Hle04TDRVJI0kfOGXoOv2EzXM0Aw1sm22DJacfpkWxwFXd8L7Lo0anWXQsKatYWm8lIJFZ9vUixkYMxtWHeyRuXP3EFRXZgtTzZteF5P2kfqdWKIFh24jHzM0YlcxffQSdZhiqpZSU4XhcCHaocwMm77LEr3Qiu6XqvgX11PNsmrwpc6fxgYqeHgzfsFqaUxOdCA8t/M1yTdyR8T5Tw/wRhCEBEfUxRJmoerpJZgr8Z17JxkGQZfLrl2fUeQ1ad70kXxsMjyuVzPvbCJ7zkcDMsdbv2jISgeJLU7e50LmGx0sL8+SDBFMvH99cVoiv65uVEYCoZqYvo8S+js5hd5HkZl+nXu56h3BdVfMU16sDU2x97NOqe4/4sR/nIQSyVXkxK07p0xnFlqMnLHWOPMaDwY/sY3CPPsWZzFKYV+Yz0dsn/NIsuTyfqpERP3eyjtli09t0P7l+sin86jU6MhjkxKxY4B/d/5fGRbQJ43IslY7yhmRqcrVD62BOETlrexuk+q4VHaDnQjz8rVqdOzKUSLdkoYAGGPnbEOcN7zEI6C4S/LCw4m4a+rgFcGHnC9jmPRtXWOMeAYel9b3WNCArR56/mZzLAHCxLufo/LNgYWd4pqFU7bY/xM5dWvFm2UG4R3lIsvKcTm0uXl/J7ePXdXafFADJJpezgRQvQ0GvRzlYuF0vFFUDCSDLnWVN+A3RlB+v/cA55Hd73XXXFrYCHBmuTjJzFEPKEB/+PBUTzrxXRxHtu7YMPqeYbn3i+ZaDBsyPq7c88F8VyY5C9JbBUlkBQ+f1ZbVLjGKKSKTgkOZHw5d0WEJ3aTspOQRWTYNe5mu+UM9cjRAsdo993JXBcb
 HIj+nVcs
 1gPemAlxd1GlTjty8xbyfxPaWlwN2lG/0TlreYEV6lTyaRc9JLZTKKoYryvWz4IWdt7bY0mRpo7YHptrbtXR8qKj0pGTm2CqdvOtaYITVQiakSFaWhg1qRpZPJNsiUV5f4RmqTlSCMdxMSA1wHeQX09Vwop/RdLvKFdCt63b+KT/bpJOHDSQ9iJpCTzli2OuYWUq6JrjLdWt7gSUwEgJFC6PKvr1gPpu/6cVpkm6CSTKBfLRmsSR7NWEY78vLVPIad6NdFecmU85vLt8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi DaeMyung,

On Tue, Apr 14 2026, DaeMyung Kang wrote:

> memfd_luo_retrieve_folios()'s error-path cleanup loop passes the raw
> PFN to kho_restore_folio(), but the function expects a physical
> address. The two other call sites in the same file (the discard path
> and the main retrieve loop) correctly convert with PFN_PHYS() before
> calling. Without the conversion the cleanup operates on the wrong
> address and fails to release the folios that were preserved but not
> yet inserted into the address space, leaking them across the live
> update.
>
> Apply PFN_PHYS() to match the other call sites.
>
> Fixes: b3749f174d68 ("mm: memfd_luo: allow preserving memfd")
> Signed-off-by: DaeMyung Kang <charsyam@gmail.com>

Thanks, but this bug is also already fixed, by this patch [0].

[0] https://lore.kernel.org/linux-mm/20260326084727.118437-6-duanchenghao@kylinos.cn/

[...]

-- 
Regards,
Pratyush Yadav

