Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FB37C44539
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 14:06:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54D8B6B0098; Wed, 22 Jul 2026 10:06:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 524856B0099; Wed, 22 Jul 2026 10:06:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 464996B009B; Wed, 22 Jul 2026 10:06:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1552B6B0098
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 10:06:00 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7A82FC01F8
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 14:05:59 +0000 (UTC)
X-FDA: 85016586438.19.6EDD8D5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id D4F5740009
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 14:05:57 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W8yTBpCP;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784729157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CdWv5bw+MY0yLpnXKBhDLO1smov7xMcfQOosrjv5JaI=;
	b=VkHzCDOcW/MM5Xlj/fcfJmAROcQPMNzkEUO93kzPoK6YboI7xi17JoSQGpaU2CZ17VXZgk
	TstGkzUpq17qofJExX0rpme9Ny35kPofACOx53vc/zgR/IHZ66KevftUHjdgy5qkz4LGdR
	hRtt1T0k4DKYc1gc0REP1H9ykXHjVvw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784729157;
	b=zF0+EaioRCMrT0dBwKV3TJeXZbGXj6vxFcN6MyR2kjeS6rZJsTyL+XIfIdBlC45orj1ese
	qFvFWI3FDdfk+D3pjRdyYq0MyP1Hzeg7ntYY6sEkHHY1QbLWibqOP6Bws1LErmeSnvhRxG
	mepxLV7nbazL8l2ej9nCP70m1KpbMEY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W8yTBpCP;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C4DD74375D;
	Wed, 22 Jul 2026 14:05:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 687041F000E9;
	Wed, 22 Jul 2026 14:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784729156;
	bh=CdWv5bw+MY0yLpnXKBhDLO1smov7xMcfQOosrjv5JaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W8yTBpCPXZTphyTItF9YAy6BinPK3E8PxOwuzYe7TlP9/Kd8q/7C9CR6O4nsIy4vC
	 rpEyat81AOAb/shtHpatDgHeHqfCRBeR2CfEiLBQrbfzxQi9Ms9NrBs3oAynx4jyYv
	 3nx7dn+CnCMxj1gpHSCytP9NuFPWcJVD9iIIbhNUga6gtQ/w+8iIeCKJg3MayAjH2p
	 J8Baq4phIDvKaV4umR764EcwZi3FgDuJE3V++T6Iu+jlJqdjcJrpQCpSNoL4fiF+qX
	 p7oyy/WFolz+WmGO3vUKpzccT3od19qHeUo2BJeQRo79vxQ3PHaF67F+oxnDkXahHO
	 gJ2SLEFKyHv8w==
From: SJ Park <sj@kernel.org>
To: Cheng-Han Wu <hank20010209@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-kernel-mentees@lists.linux.dev
Subject: Re: [PATCH 2/2] mm/damon/core: remove unused damon_nr_running_ctxs()
Date: Wed, 22 Jul 2026 07:05:48 -0700
Message-ID: <20260722140549.91106-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260722113338.302603-3-hank20010209@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D4F5740009
X-Stat-Signature: 5fmpbima6sndni7h3tgwq977cz6qy81g
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784729157-296899
X-HE-Meta: U2FsdGVkX1+NKh8YEzE+S9Vlt4zySQPPGpCwIiEQ0ba1M7pGbXRANQ1tF1trPa2bNKsQFy0gZAdKIMNPw72BfKY/pTg1sGEKhrn6NFyl1od+28yxhLY8ClbHBZfy8j6k/AQSxZBR6VTo0+n/PGmSCMToWegQeuavTFtobj+iqak+uROpG25lbFGYkBx8R9bXi3Py2RSQHqiDSyCsasm9VBevUmj3/SlV2bwoMIr14G60AEZ5LsGmYvBdjQOaeJEub67mdkynMbCVKWvSXNi22AtmfNCzqui6g/aTjxLVSSXbokRPsBg7fWykEUorxNA8KYxE7h10jyqsysQF/HUO02kpwVM9HBvZq6hh2fhGw7+PnatyJFAbdCyJ4+KC+sbpAcrL9aAIHXPC62OxrExxWaVJQc9U/dewQ4LUW9JkLwOmKeCfIwZ2kcgV0498jMCO7bxN6/X2LpqFQ06OEMh8QZyWgG5vkcXJ9/n9fPhMO5U5uDNDn6523jSr8opegKi0Y0AsiEX1B92KRt8menvBnngVcRw8h/dyxy71lXXckk/1mmkCjprtNEhv+B7RSf+PF6qnLdLhHi6KYPuLVzxPUzQVS55QWr10bpY7YhArn/t2nuHc0PQDS9OgfFcMISq1cXzckIISNfEe1sg+C6CFLT1hnJ5SSNXYWr6HJPE6D9cZYyja2M+lAmNLawCVjTxKGQspvkLbmndAQGED9U41/etbxXWhNEeg94OMY6JXfmdKI+8dPj0Vh/POjIwDCnRDa0ESDHKUVHDDtKszabQ0LYuoyCLkc6YcXYROrs5GAcBTkVkBo6EoImrIbaCGr3Lr3tj4dNoXEdk/tBdya5p8+401QIx6nxt5BYfGxsuzN2Cb6Fhc3xXIulZ0vGDLx2poV1Wu0UIT/136IzSTmS/45zFo0rcXDFAI3rSpCvIUxjRJj4Vz+gX1zgTtwwnHcgJnrfWdBje5CLKDjNlsYN+
 2skZRKNT
 ACAyGJ11VqHaqKnB8JbrGhXhqb7E8YogZnGb8xf1yANFzJUAF2XELDgfH50bcRhvQUPctK/UxR9Sx+6WhK8/eafXWmI3CNpdYouG3hcslgKEu8Rma6vTMgycwbjraofxU1flrsQHbbd3YSiKtlpXnE9KecPH8uqkn+mD7JfBJ3xhRoDvFOkzI8B6omHx+3BSRQuoBm5E4b8hOIGAfupkMWpRFWPkjH4DFyNpnybBDhLv8O4yVLDpVl6F+MIsKhVyYlHH4Azt7pulw/yb1pOIMColes4A50aTMYLog+yB+3YEQbSrqg8iTUK7AtA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 22 Jul 2026 19:33:38 +0800 Cheng-Han Wu <hank20010209@gmail.com> wrote:

> damon_nr_running_ctxs() has had no in-tree users since commit
> 5ec4333b1967 ("mm/damon: remove DAMON debugfs interface") removed
> all of its callers.
> 
> Remove the unused declaration and definition.

Nice catch and cleanup, thank you!

> 
> Signed-off-by: Cheng-Han Wu <hank20010209@gmail.com>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

