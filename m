Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 822A6E8538C
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 18:32:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E75776B0005; Fri,  3 Apr 2026 14:32:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E26876B0088; Fri,  3 Apr 2026 14:32:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3C566B008A; Fri,  3 Apr 2026 14:32:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C4D9B6B0005
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 14:32:10 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4CE7AE1CD3
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 18:32:10 +0000 (UTC)
X-FDA: 84618089220.09.16C0CF3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id B8A0D1A0008
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 18:32:08 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UPoCO5jm;
	spf=pass (imf19.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UPoCO5jm;
	spf=pass (imf19.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775241128; a=rsa-sha256;
	cv=none;
	b=21i/xpddNiZeK7+los+O4E5uTOeqrteb48mgtpiACdza52IBj6jIJQe+u05i6g0b1LnBR9
	tvRgtMEfMNjIRSlopNCjAbYdOjs7p6j9SEggWQS+STzojeeISrTcm3dHwvI6bm3+5UpyMF
	MnIrd4NHCpdJmcUkiOuPjxNupTKoab8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775241128;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dMazjs+V4JMvxkZG9IF++8mnYc4SK9agSqWjhv0zmig=;
	b=F74b4i3cDdaYafv3EZ+w3W3xYLmLv3fSbFwRSqY9YtrgwwLzSKidOzS7OZNgm0bDhFQ9MO
	AiZIo3SrdvIaNEH6B0O1S1CSi10gs4tvmu0B5/HqwYPJuQ9EynvN1rj2A7hoOGfa42z8s2
	w8GtIplJKpjNeoROio9O4MRVoCdZ7ZA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1117260008;
	Fri,  3 Apr 2026 18:32:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94DBAC4CEF7;
	Fri,  3 Apr 2026 18:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775241127;
	bh=TvVC+nwUPJvPfGBp3UoDRWVZctwPeVAHVfxSvR91lDg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=UPoCO5jm3FOOHMaZv5E407upgpxENY+rmKh42fDTdDe1Z4+7ItgYWs3eU+5Nw5ZGh
	 2LOhA8vpaoNz5JqDcrqykaE6lKC9J+cUa0oROkuT/CfPnr/+cAoKK8Aag4txVJG7Y5
	 xJk3kp0QBZnle/Hb2VnOb4N9eVMrDrJyi7ledMTLN4YezVKisZMSpSaXGlwepsrt7s
	 BEEukhsGVVAA73c9XmZlg19IOMSnVuyh7U8Nn4zm3K0MwQrekeZTLCU7T9UBuXjJkM
	 KaYu59syDU5GhjJf25Bu8fYl1Hexh35N98fYRDCfiFwAMLblZ3WgSW+EvpHtyvFovs
	 RDcLGCSPyBENg==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: linux-kselftest@vger.kernel.org,  rppt@kernel.org,  shuah@kernel.org,
  akpm@linux-foundation.org,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org,  dmatlack@google.com,  pratyush@kernel.org,
  skhawaja@google.com
Subject: Re: [PATCH v4 2/3] memfd: implement get_id for memfd_luo
In-Reply-To: <20260326163943.574070-3-pasha.tatashin@soleen.com> (Pasha
	Tatashin's message of "Thu, 26 Mar 2026 16:39:42 +0000")
References: <20260326163943.574070-1-pasha.tatashin@soleen.com>
	<20260326163943.574070-3-pasha.tatashin@soleen.com>
Date: Fri, 03 Apr 2026 18:32:03 +0000
Message-ID: <2vxzpl4fc2u4.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B8A0D1A0008
X-Stat-Signature: qxie7hx9fh78doop6o33jxrfqe9rzyxh
X-Rspam-User: 
X-HE-Tag: 1775241128-766291
X-HE-Meta: U2FsdGVkX1+WlCKSgBIvMOfdPKlleqpBdaVgIaHKzmPv78LSxEitDfpFveCwPp8k8mbHOE9PIpwKOPEXwyZlEb6HZou98/E20b1HGwAmQp2ozIW2ZSj9MbsLT4QXqr4XHvqhLvl274VBCMMhQzkceoZ5Sy10g2XZl4nTXYyq4CN0yqYy3DJfGna8nkwBDjYwjIKBVuF2nZ0GYF1p/xt1iRiMahK085ZJKpXVNrARkUzqMAiQFn9ZQRnEf220TeIACumR576qL0XHMsORCplHu9X90uBDkxQTRFx1HRtJuTSnSAhDsJUQW9kubEsYphZI6IMGB8cOnUXc8Tsf3GTybbn7q02sO6U5SlyeyPb4O9MeN4BGKB0ODOVgLmgcWmsvyFZGgrtf2hL5hkL7yN0Bovn//Q2MjG43m6aHAd4FGU1iqDV5VbG/5VAucMs0wov/9ExbOE7fZYVv0580h9Q7EovIB7DRRKp7UFeHekp961bLABHEDktnt0f5eUjKNRDLYt0LA8XKz/R9p1BYYqXSNAp+0tj0BlGlF3zgn6amzIZ3YW+yvlGxMcovfu0+sRUnAfj1w5BxRt6DrKBlQFdJis/Yp01l5ef0gq1p2IwamswF8pNYVVPKg2aiOAhiKqQK1X98tDarXu4D6Wi3zZfT7vfwjlvrwXAH/Rr5w3ihi8Iit379uY6U+159CWuDPo2XWidMjIvg7gOQxqM38vWvodSH9+0qPdaoPEselHkoCEcGz3zJTpRz2pZtZ9R15x2DyMsiqQUguOA3d2UG3y8YfkfADia10ThdDmH7sCASDK9RdpdWeryW2imDB2zq23tLymLspVamhztsodgrxorBLq0TMOizBZwP/uBD5bCooR60w5nOaTZGSSHPcVf4LdZTeRU0Ia9/3cQb/AUMNB9I7ndan5m/6oQr554KmEU/Lx6JVvO1oAMWKLYwWGcMumc1kcjB+DnfTTk0cXqrmYP
 1+dkGWrT
 KH50p820dyA4VHohEK6nGU0T/kYixdFbyedV+wLOZfekDHHuzJEES3VJHe7guUuhXlylpKMDW67KcsUWH94Si7ErswiMEhAB54lMalWPDrRXffSj6zT3he2P4xLiI2Ovain4405piKT4QlFsqzPthS6MiG6XinWMfWKUZpbDKksh/WLePIM9CVG7ZaN7ceKlss92qz1T4MkbDZmzxOTEsE525sM8tMG6qqq6+EUIHxJKacdgtvaCldAUY25jypdqUhmhN4MdsGNmnsGmFWP1lWSrL5Sz+h379U96X9tkh3vcmHY0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26 2026, Pasha Tatashin wrote:

> Memfds are identified by their underlying inode. Implement get_id
> for memfd_luo to return the inode pointer. This prevents the same
> memfd from being managed twice by LUO if the same inode is pointed
> by multiple file objects.
>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>

Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

