Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 569F0CD4F47
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 17:24:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC1C36B0005; Sun, 17 May 2026 13:24:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B72746B0088; Sun, 17 May 2026 13:24:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A88246B008C; Sun, 17 May 2026 13:24:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 988BF6B0005
	for <linux-mm@kvack.org>; Sun, 17 May 2026 13:24:45 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3109E1A062B
	for <linux-mm@kvack.org>; Sun, 17 May 2026 17:24:44 +0000 (UTC)
X-FDA: 84777586488.08.7BCF58E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 83D5C120008
	for <linux-mm@kvack.org>; Sun, 17 May 2026 17:24:42 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pTx0Mu1I;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779038682; a=rsa-sha256;
	cv=none;
	b=SYlKpf4XPnvmh64iCRQGYJ1W/LnX+7EVpxioDQWAWnvkkUk0bn+Oki9xlDgiuOTS5x1UGU
	AdNw2VkoHBDIrdAk4IvliUw98jhM4hfxw2+bH5wzeMh6jBjuxgvaimFR9PBbVelXjQivkL
	sABtboxH0u4nFtmi1iCW/LfPyY2FmuM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pTx0Mu1I;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779038682;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U/85E8d1BoxEQjGDBBe9ZPjDbaxTJxayaXmtPrM0VxQ=;
	b=bxqeZfXqGEQiuGZSwytSXvCIZZBtASRg8+PYrcVnfXKCt4hu0rJcZ8ZwjRWZsXvD7uysPI
	ZF6qfGRW6/p9tcLxQxhSQZmEMApwgMkkypJm76UiGF2hwHsWdKC8z7Spsw2kLuABoykdrM
	/bI9FE4FqImW+PJk3NoNfnUC4rMQBRw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EBB3F60125;
	Sun, 17 May 2026 17:24:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80395C2BCB0;
	Sun, 17 May 2026 17:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779038681;
	bh=18wU4AaA8QQO+xGJ2kIhTsunkndrM76R9Ox2d9eFd5E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pTx0Mu1I8DpGHA2aJuMI7NKp8xzGNMC0P0k63npy00s0iHZlPGlMRb+FwVyDrnWf9
	 NUv4DcxtPx7aMQ4I2Kx34VcOi65DjSVPQJnL/GETiVIvTnA8tGowjq2iazzDert6P0
	 RK0J9ayNhloK1k5Kg+LkgpODxR6Rrq0lAM1fXAjqbK5uL1GtOz72KXhepk0qmzD3/7
	 wPPI4rJnRp8cqjgVyAn3OmyWAF2jncHX60DelW3kF2fNLKgHRQILWN0vhHIQO8Trkj
	 FNPtfWIYKop/JzvEoixE1K+Ya35mFMRgPDLEeVJ5ADOZx7cU3UeQ+H+GQpsn4PrOUZ
	 +FwOpkeLN/CBg==
Date: Sun, 17 May 2026 20:24:33 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: linux-kselftest@vger.kernel.org, shuah@kernel.org,
	akpm@linux-foundation.org, linux-mm@kvack.org,
	skhan@linuxfoundation.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, corbet@lwn.net, dmatlack@google.com,
	kexec@lists.infradead.org, pratyush@kernel.org, skhawaja@google.com,
	graf@amazon.com
Subject: Re: [PATCH v2 02/10] liveupdate: Extract luo_file_deserialize_one
 helper
Message-ID: <agn50TRvhDpGm_9v@kernel.org>
References: <20260514222628.931312-1-pasha.tatashin@soleen.com>
 <20260514222628.931312-3-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260514222628.931312-3-pasha.tatashin@soleen.com>
X-Stat-Signature: 5nrhoemf53a45e5fr6j8rmk16ypay5gp
X-Rspam-User: 
X-Rspamd-Queue-Id: 83D5C120008
X-Rspamd-Server: rspam07
X-HE-Tag: 1779038682-293158
X-HE-Meta: U2FsdGVkX18KcUqfRGbBfwzYZD+OoyNfvD4RnBjhttnShcP7yPNssLIbXY7HfP/TzVtidDhkn7y2cITnGulxPSlG3d6H0frg9uSo21rLUgow5FX0Lh+pDsXjuS8lYwcrixg++gMix6IDG+P6XpY/a+fVQTntH9HhmLQbJ4z+uvXhr+FXaTRDYZ2Xb5m2Q2AvXLaxM0tCSV+iMuZ8BxL4cwn37bVWBjcryNkMT9/SEjQLQKqirEOlb3dk+eoEoyDxmqsXkDweImLNeefrhuFu8Zq5AoFr69pfx33wKU0Qz/8rX4R8Uk3gcaIp1W2P+S+InJrR7EM6f0cAkhj58tooIGcWqmjAxyRYG22RgQuV7t/fOYe3nLO4P7qZ/yBGOWTsSERtxzx2pW71mUCuj06KIiG9gXIXtdKXvv5LXLP1bawmaBBJDB0DYF9vWHv4z8PqrvYwk73hcPx+DuzJSc3O41C3CWJxWsZFW9uSfIM575m6boAGLvxw9Q4jH9gznXhU76uACnBdPHrVmPtkGwJQMAeuP5gYyn0BzfN+anhGcNpOxk0c0RAxFaPpjibd3sMRR69wBI33afhAmHHXRhmJt7pEuW7vBVz6H9kU18WMnM7MaH6FjCrnKbIjI4Mw8SsdbsmPfnGWuKLoAWBVMV5jA2AjlfhW7UvjzxfdNspyS4+fIMFSzf1gvDjRUStxCkVcRKnGfpI0vzDtfs+OMYC38JCMPZvclhjouAhx+ORAKyIktwSoWHwZiUWKouIwzwL5XqhrZxp41t7cgusEBwwpTu4oJ6QEA4ieRplaPm0C/zIw1ZAJUebnUvnY0a2iAeyTM8eKyzFWr4J/wPoDIZXFIipatjKIBSpaTfLk5xjy9WZwv5N5HXRYcIK8oddRnAfGirnQXXGc+rjxTDpFL3qAh98PGX/EyehbBLs7T52GPIDVzinNAEgqESeds1/yFZ1tnsNJXEQkFVHIsACGBwQ
 iaXuV2Zn
 L+W2G7j3TZ1B2obubzw4wMHUrmj6RIpbC95sYBOxQH/KF8lpAGm7xiWSq8fdtsY3lMa4iROWnPeIKRYG4LnwRHz33NmpD0Ux7Xqtl8YLu1uUXONP15ulwt8/XHbGm+0WpNfH7i/LkV0m37RoIxKB6liFSVAm7Tocrh2L3o3ggF+DmXgCvz3mSnXcoiuJGUg3hNFevfYxjSspOlRGwHnpsSs5WDqwnRl2kmgZijVeCfDfyL1W88IcHQziPb1L3sSibkCQxjJF5gqNklBwnJLM3cssdhiWX9PyOCUfX73SftP3DWqLHUSSbZckO+8dX89TXGIeDIRtFVs6u6lwiG5637qHqmaNRMN+Xk8W9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 14, 2026 at 10:26:20PM +0000, Pasha Tatashin wrote:
> Extract the logic for deserializing single entries for files into
> separate helper functions. In preparation to a linked-block
> serialization for files.

It would be nice to mention that this is a pure code movement without
indented changes.
 
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> ---
>  kernel/liveupdate/luo_file.c | 77 ++++++++++++++++++++----------------
>  1 file changed, 44 insertions(+), 33 deletions(-)

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.

