Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE3BE606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 02:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=E72qajSD
Received: by kanga.kvack.org (Postfix)
	id EE1C26B05B0; Tue, 17 Nov 2026 21:02:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E923A6B05B7; Tue, 17 Nov 2026 21:02:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA8696B05B8; Tue, 17 Nov 2026 21:02:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BA2716B05B0
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:02:53 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 54276C0620
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:02:53 +0000 (UTC)
X-FDA: 85446591426.04.D5E26AD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id B91B0140009
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:02:51 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E72qajSD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794967371;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BzRw3magrNAp/PBSLA8AnhF9lX+dGyqPalNhhDXQaV8=;
	b=PlyY82oVZ/lszEYQDEtixxPkzfgPeEjGGiG29ObrLXggcO/gnIZoXWWk9EpvBdM7EV5pLk
	iPE1IIuJ6eLAO2pXiF1ZaaNCE7mLGaWmHrbRCnU8tWmCBjpPkd2eoodSAWer4u2eoZwwVU
	Ks/IrIRhA5kbMXXtahJrwPwbldHdvhQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E72qajSD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794967371;
	b=053NKLYEs8tmgeJBycncZ+PoF87tg2Wbx6a+TFFJ+yH9tDJo/wNKgyw4Se5d2Xi93+zbFV
	k7IfeTshEGDkwmolqLpfI1gLJSd98AmJU07Tl+qVF5qBK1OUkGn5VuDi8hdFqma3xASkO6
	/R6CbWWFSulTq6HRSMtis20R/p5s+PU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F197442AFD;
	Wed, 18 Nov 2026 02:02:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8221D1F000CA;
	Wed, 18 Nov 2026 02:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794967370;
	bh=BzRw3magrNAp/PBSLA8AnhF9lX+dGyqPalNhhDXQaV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E72qajSDmV3nOkafXwYqu3Uc3T5gIWylsZU9YvxKQVwiIhLcTxa3a5rOZnPL218kE
	 FmTgscjfO6sxYoKxHeUbYExEnIPBjXt1EeQDQ23yIhOR/bsklCyJ/wBb/nalfYJGQP
	 uuNCoTfDK/QrOlu8UfgLTMjCLGKY6iRpu0qASXvwnyX00OffUvPlZ1UACWH0TaZQss
	 kfJZXHvYNw2miYdeXZoAI27anCIDcYNVT11qnRKtiWuvOQZTUQ4wHOYMzX1/OmgxJe
	 xPsMAE8Ol7g1R54aMSVgOx43m7RGL5gasmVXHMrYoFUkrWrqt15hgGUFPYj8pp8Gb2
	 NmPS6m8mJXPWQ==
From: SJ Park <sj@kernel.org>
To: Mattathias Pinchover via B4 Relay <devnull+mattathias.pinchover.uber.com@kernel.org>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Mattathias Pinchover <mattathias.pinchover@uber.com>
Subject: Re: [PATCH v2 6/6] Docs/ABI/damon: update for sz_ops_filter_passed_last
Date: Tue, 17 Nov 2026 18:02:42 -0800
Message-ID: <20261118020243.97414-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261117-damon-sz-ops-b4-v2-6-439888fa04ac@uber.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B91B0140009
X-Stat-Signature: ej9rnsdd4pq9ikq3h3cfyupi9j5tspki
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794967371-524775
X-HE-Meta: U2FsdGVkX18hN6OK3K2Jexjm7RZgcAnxgS7zA49xaLZfB3NiUEfluroljsIUbH6R4SndmRQdNAtCWy0WvOiObsvCWFrfmGxUCvjIAHekl1gmQPg0mJnmT9sEBpvxZRNgqKI4/Tnj25hoss92ooQwxQkaS9owRZHbjCoTRkCLGIFGmGmkw4ccT8OW3PAtCHYUf6tZzUqGit/pHyUsItC2Ks2NzCT1mQt0zEllpO1jjdc9svKgsmLpGwzhLmESyqg7a5jfPoMbGEqBOMg0I5qt8fpbjDXTuhLZMujKN4kyprYAdUzBgS73Y8xMcEcRZQiHs3iQFsWooOdmSB7zHC3tW004r/rAInLxDYdUdfJ9AzRc54NWXZHWT9wIerlGfRWOpadQMunc+hIbCF8SX8Hp6c52yYfj5REbrsKmbizgbhjb/GrQ5kAjfhzOKRmtziiO3bFdqz21IytA0NOeHGESJnpROuODMxQHedgDH7rTf7qmi4jzzYSsq/TpPFAHFhKJzs93xTWbOfEhTvmyk4t4Cl+8AxRF7UdYJ2FEn42+i9pKYN1SejAs60Qq+8zawOvt21qQbEQe/VxLTwg7rOOwDUPH9Jfxn8xaTVNh2djjEDo90hDWPyiZWGguvss0ZHDCCX2xUtrtBh7ob4L9tC237pyeQBN7guDVxD3pe2RKdDrF2G80XYgFthzJ8qAUTt8BopbmV+dOibSOO+hs/ndXnwywIOhm0lxBJXB4Z0NXfSJ4zajJC5IxmIeF21Qqb9Nj5lG6AMKbDESi3owhl7qFTEKHIf9Q6hf4q3zW/ZPm4oPAiWoeLDN6dfNDphh5TPKCg2GePWF1yGzw50a72zw13DgE8h2ERsa+puJGocNr6F3S1Gv+/16cNozUa2cDUT8CuVKwCiYyukZsjCA3R6pewTzk2rlrJrVVeLbcN3xBbR+Sx9QiIEnb6+of3k7qHFRXS2FrrJkc9hjKgkx0aba
 UEbi5sYb
 /A+J6/ujwn59UAOdIFGiM0ctxUKi/hbfj0hDPgh4/j755EF8U2mt29XZPzPx6pw+an0ckAGtUiws1xMmD34PVTKWr6WiiHdXrhaIYXSz6aFU++BS/FDZZGaTm3OQT+/vcaTkmUzHXmVJS1cyCTSJ1yQJ0Oh8qyvmvoAA/tek8CYYg8SixgVhpGEBNz+A0/Q/eHApK866nUux12Ek5AYueP+JT3ISqKbOy0hXIWdH9wL35KfjKM/TAhWba/4nqPb9W8v1wT3/vKFrOXt6aLSgGVYVK4jyQet7no/Eu+2GC2zWAwNNvHZiiUF2CeI0trAFARIVPh4G0CTOyf4om0YrptyQRZc4WNmYCQlZPbPCFCW5gLwVE3QsGpBAsjizILpYaYUjbXLzHKX/iymWKvrcNt2YpfJnUl4d6kL7Fj+LW79PC+OVaRDSaS6QyrEwUAsQEp7Kd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 17 Nov 2026 23:22:20 +0000 Mattathias Pinchover via B4 Relay <devnull+mattathias.pinchover.uber.com@kernel.org> wrote:

> From: Mattathias Pinchover <mattathias.pinchover@uber.com>
> 
> Update DAMON ABI document for the newly added DAMOS stat file,
> sz_ops_filter_passed_last.
> 
> Assisted-by: Claude:claude-opus-5-5
> Signed-off-by: Mattathias Pinchover <mattathias.pinchover@uber.com>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

