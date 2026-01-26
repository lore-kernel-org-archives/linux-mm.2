Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3325EC88E7C
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 12:48:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 892716B0088; Mon, 26 Jan 2026 07:48:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83C066B0089; Mon, 26 Jan 2026 07:48:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77F926B008A; Mon, 26 Jan 2026 07:48:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 66A596B0088
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 07:48:46 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 015D81406CD
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 12:48:45 +0000 (UTC)
X-FDA: 84374094252.18.502971B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5924940008
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 12:48:44 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZImDQmkF;
	spf=pass (imf12.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769431724;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yC9dNYMx8a3aPFHGUz1eG+4PftVW8uXalOORr96sP88=;
	b=wG7gYfRzjgz3eC0ICKF0MohI86y4NrHCm7y1LNrjn/xdFjnrhuxXgJMwyiXfbXwlfFCjE0
	1UgWVJxEGIY1kwsclAV5v2/Z4YiK/1GJSbMJOUigPC9sJcYAvwyZCeDEcfx3vkqBaIjqp3
	mzhvjIx/s38DdkYVv4uVI8dFfd49HMg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZImDQmkF;
	spf=pass (imf12.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769431724; a=rsa-sha256;
	cv=none;
	b=se9vweGdA+UTZZDpdiyQU59w7VMb4+MHNsWvajdZVgKXG4C6TufvKWH9qW4AKM82v1C44c
	QOJUcKkJgU26sCNLS4w8m1hkpb60hRSfXSuAYKP/IcuEfohDMTMBfuJ+2vIUjUxuSe8Cuv
	/C+CIVUse1N95dbpSJee5XO5xmg2v64=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1BF554442E;
	Mon, 26 Jan 2026 12:48:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CCDAC116C6;
	Mon, 26 Jan 2026 12:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769431723;
	bh=A7DYWrpyfHFVWltF6mJpprzDHTr2ZLlsNkHc14svh3s=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=ZImDQmkFknNM/HRBpo4EztcpeaH7C9U7edLdMLwrMUzW5tMc6aD4a4cD9kKPx6KVS
	 yYEVGeBS9+Od1AEmxQNT/EduaKcUqJn48kvyxE2OWJhDsWEen2ms81KLOS9psdMaeD
	 tnuMOZWNRt5DnpznBPLfjh22VmjBSHp67wJKxmhM+wDxbrK6IbraqkfO2TWx1btfHx
	 Q66+YWuUunra8vVBGHbJvO+CMoPWe3yf1aABV68/mwK3zASIx6v2Mzjpj0ed0wz73A
	 aM9/e7Fz8sM5JrGJ2ZRUcNwlr/QRkw9XNSHqTDyVRE/Nt0dMkX3/3kktFEcKn3sSy4
	 VYZeYe+ZOB9Yw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Tycho Andersen <tycho@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>,  Alexander Graf <graf@amazon.com>,
  Pasha Tatashin <pasha.tatashin@soleen.com>,  Pratyush Yadav
 <pratyush@kernel.org>,  kexec@lists.infradead.org,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kho: fix doc for kho_restore_pages()
In-Reply-To: <20260123190506.1058669-1-tycho@kernel.org> (Tycho Andersen's
	message of "Fri, 23 Jan 2026 12:05:06 -0700")
References: <20260123190506.1058669-1-tycho@kernel.org>
Date: Mon, 26 Jan 2026 13:48:39 +0100
Message-ID: <2vxzms20a6ag.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam11
X-Stat-Signature: wt3awzfb3q5niimtzdztewffba38zprk
X-Rspam-User: 
X-Rspamd-Queue-Id: 5924940008
X-HE-Tag: 1769431724-659375
X-HE-Meta: U2FsdGVkX18v+SpRM4Pe146XW+9r4c+wfp5EOA4LITUdE9UmCUL4PdCFNrH94eutp4gBE69l8C/FMIGrSRdydeySTIY5swu0qoMxo2nltYw/uEL7VzcjXb3ez7N9Lt/L0pTxbkqVw/WTNjGGRk1ZhiZRJ1ZndMraIhvbufS61mE11z+aAsQWmj+BA+Kvqwzz5NaLxfMWWINVdx66QbQ0CDdiIqeatWX9ZRHleFMqprSA8Mb2LfLcxjrwMxDmO4H0LM8UQsBOay8Ojfeyl8qdhmbnLq0IVdnmizge4ArezB7TjMZLkCqJzBirUx0dzcal2ViKqdPI3xwgTl+7vPM6oQFRo8+ammW0loMTPAC20jvU1OIK+GJG4hw86o+9vlNefgwgsqjJq5jNtd/WmtEofo08rur3wlL3uxfTfLVd7ilcVol0MjSFcrFEPXL9R5pBNPiAyykOvzZoG+PgjsJSUtX6GiKdy7vnG6SiAjF+ztQAXt/rAx1LNmRehZ7zdULhcs7wcA5VO/RPT8iNc6e81KwbfX6n6aWYwgQuDuJCSWd3FYr8eBh1G6YKs7SoDyMQiyUxkzuTvwA0qnLTWcGEO2YBZYGxGkl69LBP1SZaEHlLYKTqvZR4N2dIevml8qeWTbScZmiXrroWgCMfNleOyt9HmAaIjSTDKc/u/MK8qXgPDraUVKY/OUtK6DDpaubPQP4OTKfQiFILsZaggwlC4nYBokHreDCLRQIj2rENbbblVRvvehPQB75/Vf4+pfPvPnFjtH4BHV4fap+nRCXUAHPcJiKXVLo9TShgswjlJhjzFynQWFtCvyqGpSDBaZ3FIzxTE+IhqhRbU51BeSAqlC2BeTztPXPKJ2ATz1sHbYXTZgneJ/37/Nb72TS636d6BqmtsGAglaJgErIkSexd6UEW5sXMeF81HxfjHgZTgRsYW4zA6BD9KxTDh3VHpRweTWz0JCsyJS2Qvg/k7uY
 QmcCJsun
 liSRsMMpPw8qh7FU8Qom0s93x7YmbSOANnK6hEpXbcTrdS0tNSPAHoutNrEi/3Q0ZOwqgor+g6Rhi0b6hdy+R5GJ9w8zBdu7HyWaMCvuO45W+jhhVnbjp9B7JEZH7EFBjNb1Sk9k/X43vGWMExD8+55raN7jJx2Mj03vVzMwvp3dFVSaqgLVoYpOGvAUo7y4PCY4Y8zDyOS4xmioYl8YU8ADNfZaGK6bzT11PYZbYEp1bWx6eatJTxnZoCg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 23 2026, Tycho Andersen wrote:

> From: "Tycho Andersen (AMD)" <tycho@kernel.org>
>
> This function returns NULL if kho_restore_page() returns NULL, which
> happens in a couple of corner cases. It never returns an error code.
>
> Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>

Thanks.

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

