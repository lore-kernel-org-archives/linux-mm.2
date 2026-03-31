Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36DE910F92EE
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 19:24:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96DA46B0099; Tue, 31 Mar 2026 15:24:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91DFA6B009B; Tue, 31 Mar 2026 15:24:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85AC16B009D; Tue, 31 Mar 2026 15:24:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 798866B0099
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 15:24:40 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E1800C2BB9
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 19:24:39 +0000 (UTC)
X-FDA: 84607335078.16.280788D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 44676100005
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 19:24:38 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MetRsd34;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774985078; a=rsa-sha256;
	cv=none;
	b=opETPKWPZ8/yRhgVLcioTTKi6mh++o6xa0Xk5q6EKxnCJ4hojVCcLaU5ib0NMa/7JsPwZ/
	FH5D1Bot/8BDlYf3W8mOZuqWprLBph4lhjZTAfMwDiHaPVuOQrivdoraDKdkf+u0OzTH50
	9/23wKrh/YF+D/jjqBSw+/k+oTLxIS4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MetRsd34;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774985078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pgs8e2dcuH9Yfl/pQc4PDNTXXEeh/qFM/BzC56+Vmxs=;
	b=dVyN8OZpuw4O1gtYPx42mXNP9FR4vDzlKSUnWDLn6eYR6OlZEmABPpqqsW+zr7GZsJ/HU9
	eLq9vPsuzSap2WoexufvfNAkVLynhOh+SPZRgWP845/tNw/KDo4cBW23NkEV0l1fZypLgw
	f1wI+qbHvjy0n+jdbx0CMjhP8A0yLaM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 736E160139;
	Tue, 31 Mar 2026 19:24:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77C7BC19424;
	Tue, 31 Mar 2026 19:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774985077;
	bh=ca2PhavqgDv2R9in2fzAJY6/zNAPdq8KaVAU3DEM2AI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=MetRsd341qzHrULJEq2bVsKizErCgynV7J0GC7Q2dtCkgw8QiIApupfym6tT996Vu
	 IISFGcC3jVQlAur409SfraNezvSw4WypGqwN4V4ZXJjNNr1iCmau04fVq0IMZXDx8z
	 VSSaCyUYxaRgEvERiarMBBEx4fowr+qorp1yy4bZ0l6u2f4kiMorT62wjgKx8HBcL3
	 fq79rhf6s/PIpCSdwFUBLayJ8vgkG3cLLkk+KCWbybagL/84GoZtn9Um0PqqrGcShS
	 /0j+A32slRa5B73MY3PTIb8/MTJ4c+CWNnf1zg/R3yQx1pk82bOkDS42BSV2OmWTai
	 1fFL5RyLzHqKA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: rppt@kernel.org,  akpm@linux-foundation.org,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org,  dmatlack@google.com,  pratyush@kernel.org,
  skhawaja@google.com
Subject: Re: [PATCH v3 03/10] liveupdate: Protect file handler list with rwsem
In-Reply-To: <20260327033335.696621-4-pasha.tatashin@soleen.com> (Pasha
	Tatashin's message of "Fri, 27 Mar 2026 03:33:27 +0000")
References: <20260327033335.696621-1-pasha.tatashin@soleen.com>
	<20260327033335.696621-4-pasha.tatashin@soleen.com>
Date: Tue, 31 Mar 2026 19:24:33 +0000
Message-ID: <2vxzwlyrhkem.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: d9nx66453gtc1oydaws6qthrqkcrcz8u
X-Rspamd-Queue-Id: 44676100005
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774985078-353916
X-HE-Meta: U2FsdGVkX19JQpxV1e8INRQE/U42w+kw4s7gj70BIs5cRxeLGf1fMTRqBbtdoyYL9l5f3TTEaFctG6OE7Er/jWQWJxHrDRA81ejGIXJZxxVAoIZG0IMWwKddHFxxtvVi523IVgZZbdGugKRyBerQ502nDToxZSr6h8aJzsoAi4swzxUqIgMJ1AKaPkqVnrS5xcyInY17RGv91N/X6DIcSX/e0WH4Vx7yiDNqCZNWRkmmpmUViViRgYih4jnRgARbNNQbIhckcpOUBrXcXI86jkOlvrgCFRo12IdVThP+bVPoGwLsItLcL9F7fuh+R3pm8LRVgK/I060UASzcj6CpL3QKP6CyeToZP0KWxOW1SgBmCK4OgkFrGTinMNucLcm9mK0mvd88KIJPLmDYv/pWUFen7Eo3EmO+5xQ/B0xenkeeD70e520+6BX4v6pj+4evk5YiDSAFFTmLpB/1ghmn+Ss4zd5ZXUgusngKu+3cXwqrABXVKnU4SP53rsm3xL05+TKKgoKBlxnTYPh5P7WkeehqfIGq/DtwV2fitqJt7YE4BVrxtD1+lwfP6cPp1JSeamlk3TBpitRof2nki/aXNj/5YlzuI4nyCUZogreXKHDYI/BrHjm+ZAPSpT38RDVuoIBihKx5/Q32cfX+bnS6HxzP4ff82NJP+8c058zUIH8WDtffRkY1eKDsSdf1J0nZ7nbdkNORi7cdXRuXyCtnK7WJpgurE7CswYWDLqCdhFC/E9p4hNZTEBuctZ/v/RaU6izPnPnM0iJc794231i7Z+AOUPGd5pyyibRKaP2GM7WomwVoXQeObzdlm68NGARmzPrfkDTXgcJN/fDJDTQYoeVlP4TcUmFQQC16WQuXAG7AhMwCcmq89gvS7RWlyqjBLDTPcEi/Kp4+2bhFx5mnHn1xz4UVFX8AAJUsJmoYAO7yIvX/juVLZUXpWuu1XPWaBLneowEuZZL9OWt67ra
 fCITHj8e
 Jd1TeIvZyIHkdHcElk0Jx7EQ2MKoJ2Snsr33SSRrRPN23VeKazpNDJyzz3MtYRisLkajkvKBbb3DpzD8keunfZIpMdRpI0eEQ1k0yIbCwhOYylr4aQOCa60/+UAz2zgqwy/dvDeQZwPsSYLajaSMX83ItLF5f8Ri4dReAEBdt38cXONYV/oY3Qe/3SYeXkVy7KJ96YbjiMRzgT/YOEP++BSIK2oUsYOrIywKhi/6blH8DFzkmdC8YuMp3nyeibzm9w+AsLOD55XDgLH121UXxHvadUx/blg3McfHZO2ZfvG2BXyI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 27 2026, Pasha Tatashin wrote:

> Because liveupdate file handlers will no longer hold a module reference
> when registered, we must ensure that the access to the handler list is
> protected against concurrent module unloading.
>
> Utilize the global luo_register_rwlock to protect the global registry of
> file handlers. Read locks are taken during list traversals in
> luo_preserve_file() and luo_file_deserialize(). Write locks are taken
> during registration and unregistration.
>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>

Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

