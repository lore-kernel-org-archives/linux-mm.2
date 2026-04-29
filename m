Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA1D8FF887E
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 14:37:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FFCF6B00A1; Wed, 29 Apr 2026 10:37:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AF356B00A2; Wed, 29 Apr 2026 10:37:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EC706B00A3; Wed, 29 Apr 2026 10:37:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3EEDD6B00A1
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 10:37:18 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0A8051C033A
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 14:37:18 +0000 (UTC)
X-FDA: 84711846156.28.D44304C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 591DA16000C
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 14:37:16 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uF9EcBM1;
	spf=pass (imf08.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777473436;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SelA/khA7FrWueam9o72/WVBnWcERizhL66SJlVwBng=;
	b=7YC811u5T0C3LsGClvI9JcsJa4YyEve1rkTQT4K2jC/zKy37P4W+uplP+BELRqpgbysftW
	Cys7f+S22BKLZ1yq7/n5jeL7GpkPSglkS/0ce7A/ktllQsnDQliVLw6kMa/rtJ1QUHz9Jo
	dXrv8iGxc5kA6umwNm4479uT7NDI81s=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uF9EcBM1;
	spf=pass (imf08.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777473436; a=rsa-sha256;
	cv=none;
	b=G9FFfRNq4zJmwlPjNCotv3as10DbqE+G1syeYua6Vea6EdqD4SADm/8Qm42EyIetkbWgZe
	06KkxG5dNiXnKCYmcD7Eiyyis/+Gdf+EdXVcKYcJwBifTRL6m289XV8bb7UPrsZUnpLpin
	XTU5YQ0st9G6Kln93nsyCIIUgzF6BlM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 69FA540A5B;
	Wed, 29 Apr 2026 14:37:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E44FC19425;
	Wed, 29 Apr 2026 14:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777473435;
	bh=YScNpVH1UHOoLbbJLA0x/IkWN1FOcPoi5y7ZJUsuXFI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=uF9EcBM1AJ1RATA/7vKyD97zriLLgWwTV8H933WHqoz7MqKkRUxlQZslb/0qQDvF4
	 fUc2rFZ/wU6zXYdq1/9hno5d3mh9+3FZEFtLQtTIoR7Q2D25h6L/UUn0WjZ/QV96Ee
	 xjs4rkGjyecR2ElZ5DHMvoyMF0KfFteMLihspvEKWABihiV2Se6qhNaxqOWqvZXVJv
	 sKHLNWgK4wLVfVkRmQGj6138ZRAG27yazdJgceJesEUkGYyS3/p+20rmDuJ4E0FRTq
	 VLChyiSlRtTQLFdQ8Rr1mXkJGm7vjr+TVvt7h2cr8SM8Op7JbhSZ62bySSChZvF6Kr
	 jbjSqfTI4gwtw==
From: Pratyush Yadav <pratyush@kernel.org>
To: luca.boccassi@gmail.com
Cc: kexec@lists.infradead.org,  linux-mm@kvack.org,  rppt@kernel.org,
  pasha.tatashin@soleen.com,  pratyush@kernel.org,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 4/4] selftests/liveupdate: add test cases for
 LIVEUPDATE_SESSION_GET_NAME
In-Reply-To: <20260423234753.3873095-5-luca.boccassi@gmail.com> (luca
	boccassi's message of "Fri, 24 Apr 2026 00:44:23 +0100")
References: <20260423234753.3873095-1-luca.boccassi@gmail.com>
	<20260423234753.3873095-5-luca.boccassi@gmail.com>
Date: Wed, 29 Apr 2026 16:37:12 +0200
Message-ID: <2vxzwlxp3k9z.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: 8ehw1nh3xnns9kcr7nmcq9nkufobadd4
X-Rspamd-Queue-Id: 591DA16000C
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777473436-239207
X-HE-Meta: U2FsdGVkX1+2hkp/abI+YmgTQzS1TnM7W01LOxAW7ZMwak1Oar1bQJf/XIPB17T/kPxZ87ID/OfdXb7EMilxT+p/Bd6ZpS7D/L8PInOd67ARlalpGZqS/NmPp95ojF+cQb+RSBJtGuUTQifWkY2SQ+Q/k8zdc+jAimgRjslw9h9g18WzVG4dpUZB21Pztigu2Bb6VfryasLzkaTIUOeBAotoQHaDS7wyIskMBU0sOxUx0OJ78iIrpxwUS+FAsh/DynVqHGC2gOu/YG1Mw9uW7wh2de5MBuQbHF4K57uvkHquhf3ce9EQe0NFA2ULtJnvSL4oDA+84H1k1SG77D28GeKj3vqQlalBYOJbhoG24KNdNKebwVc6xJDgDUUJ5NUun/jpHfrZi7gEHTpxeGFs66UaeKcNYDPWqhXXPQY5ujH7Zk12X/ce5GgoOIfoYDnOmSVAB08nl/rPN9ArqGStf+t4YDU1P+i9gtwgEypuCN+WoPY+dPxMkTYuWQFBHmfCQ1c2Hk6vFNf/KDBUcBQAjrPr+NQ/KWm+7tzhkxhdmBjCLJAKlqomndt6ewaf1L7+4rBkwAKHvjrnbeWp5mGkgIvB6N9h+Cq2sp7DnBFWnwwMx6avb0ykzwHmdEKwlM17DKhTN6CjnuMajrJiiD8Ddg0k5q/LqsipUOmZZgjcybOcbjZ4xwpTU5d/OLh3lmY7O9F3dAieTcOT9hL7EdMLPR2TDqHC5ltLpsrEhVhoP0l3g+Ywfxv33FNTlfDa1/VS4Tuwz/xDFpgIuu0UtyFUrLxRjc/xUP7pKUha2mqbdv0X8BYUAkQiB5FwiJNdAeYD+EpFVIh53fi16DZkDXtlBLSuZSIKXHMb48bQw+bYumB8TpPbVvuhRrxVcDMDYb/qC/AgeYlVFzaLXrFCkAyCXxZVNw3W3ADBrpGSmjIktArPhGHKHE4DXNwusaH7TlmpbIrF2oIuQQk7Gwt8lZq
 vjmzJkDi
 iykvAJ+RmG6pTUg6i+RFqwMTYKOTMKpn7j2//GXGX1VWE0GtGm9gAfVr4PuA52N1YEGIAcuGRsULyMy7Llw3sv7UKiMCSKdCfQXRr5nSaaSfKTIs6mtsZs6iABUEktROeg+9ZU9UFwdy5FQJoboPTj1MrHcVVxak0n2AyMhPoDw6N6hx+gLwEgFKADS+EOy8dguj5neiIenuoMu4J7e3SlEc2wC1wKlGSIAnBWBwGZAyUo90QJtmzdAzkB66/nMGuzTdTyiv3Gy6uRbEEP7rCpi9yWGz58ARLtRCvsQ57itLPgPey8JpKcVJx1CbfmJmAeMuLGrhnXcFW9CCQV/M49Y7IN56sWiv96Kq9CX8q70kdtbosv9VjbvdWghvG0aOICo1DNw+aG6H0U2060Thy515aZGNP7FRhqUBIvHp3jKTq8d2LZL6HguLGiEiPunpXBXvA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 24 2026, luca.boccassi@gmail.com wrote:

> From: Luca Boccassi <luca.boccassi@gmail.com>
>
> Verify that the new LIVEUPDATE_SESSION_GET_NAME ioctl works
> as expected via new test cases in the existing liveupdate selftest.
>
> Signed-off-by: Luca Boccassi <luca.boccassi@gmail.com>
> Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

