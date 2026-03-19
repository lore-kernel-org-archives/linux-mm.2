Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE17D1090242
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 15:24:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41F606B0508; Thu, 19 Mar 2026 11:24:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CFED6B050A; Thu, 19 Mar 2026 11:24:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E6FF6B050B; Thu, 19 Mar 2026 11:24:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 184276B0508
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 11:24:39 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AC25A13B4DA
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 15:24:38 +0000 (UTC)
X-FDA: 84563184636.12.BA9452C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 22E2E1C000C
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 15:24:37 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NhKcwaPV;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773933877;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ih1pYo+IpjXARVuhf/g4/ImOyfOQykdLLpFJ802BmB8=;
	b=V+UGHwuummLfmYnAje/NObcB2yxeQ+kdm2KTiRL2yyRSzCG8y22RQtIvR4Pg8VXMX1xhJv
	VdwnT4m89yZqqRcpDrL+dbus0nF0QvkSelwPKUACeBmwhXbdfA8h+2ZoKyJtsQaaM80gJG
	eELSsyiDsoMJW9iEdvXzOOLyGi2FzEs=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NhKcwaPV;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773933877; a=rsa-sha256;
	cv=none;
	b=BOIwgR3bHhxQvzm1/l/pQeotTiOQcGJEmYyxX6o7D6hzk3d6pRbRYlewlA2/BlfUkH/JZV
	2MAZiqV6KuUEPmqpo7DpNR9WzBVLSraQark8lNjoOOIv7CHK7YVbSsfHAolX934QSgEJyz
	g3tpcagIO0Fn3M+rAc0LcphKrgyqEYc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 95E97600AD;
	Thu, 19 Mar 2026 15:24:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31A8AC19425;
	Thu, 19 Mar 2026 15:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773933876;
	bh=BE3MW6vNPVQLiU+P8M5EPT5GuRJwZVTSshCwMY3wHEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NhKcwaPVIMuH6l6y9bnIwW0oOwVmDqe+JufXrEvCIyenFRkw8aci4WNYlazlnqwyt
	 arjNCVPOLJYkFMW/KbH3m6zfIILgWe5gN5THHJ+bCbJ3RH0DOwCugOWDpZUI96iqOk
	 C0kw7RgiPJCRHfcxuHx8oft819fnG2kAZIKxamMMTW+x0kd4WyDaY9CM6D3cGf4ot6
	 RtfDAEL3R+C3o9FO6nv/jMsde0yFmJb7tGQhDE11SEb2ownvZo2YOp/bpINVLM4yMZ
	 PEI+GSyMCLcnTJ2+3QDuR7/FUAY6V3gf8eosYvKPHQ6G3v9X2M2oNrx6Kn2cs8cKoy
	 L8qj1tfN2mdgA==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Josh Law <objecting@objecting.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/damon/core: document damos_commit_dests() failure semantics
Date: Thu, 19 Mar 2026 08:24:33 -0700
Message-ID: <20260319152434.87003-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260319143116.82849-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1ss3tq7by5emi3fd5tzg3hw5h9axfcxk
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 22E2E1C000C
X-HE-Tag: 1773933876-908406
X-HE-Meta: U2FsdGVkX19CIyvQi7BXR83OdMR4H2S993u4TfnD1IoGkoMNaLIp3/LWM0F8RqQCkPOUCGA0/yrxvnlvNQ5RoYzUY8kzI5EwNJ3ilBmiH1per1+6mcYe9aiFTfIjIMPjz1CbWIfxni+kJOdwbJvCZhkwdIpjn/cyArS/uFAQL1cDNdanPb4ePVKjic1H4I8OSh1EWvWQhQH9y0prZ748WPpuoR1vexhbRI1qzaSZVAQZ17IdYFHu4gkFcMHYiafcsVUq/5IXPr5nmASrFYmw0S1nUNq3L3o80v5OGeWOBLp/lrWA24xVyRv9k75vKyXW+NSzJ6U38XnnZZK9iY68yT2h9PhTTXJvxuMxB9GpTuSEMy2CTkWux2KsXCLvadlcwB9/DDH0ol/Y59H7uo9LU+tLn0NMdz+cq+tSLG+OyHAZn0vFa6QAPHje8Kl3N5YXQGpgkZ6x3CmbSXtxRdSylqJwroPyiYTNtxGipp7t4Rh51PF6YD5d9O/o0XF+aWkQfB3YIb7JrmCUy+mAvaxO2eoHtrIbWhPYlo0sHZK1W99ZZ+b4Mj66VcJDYEQM0oLUDtcbOCSBLRG0xkcUnoHl4Slcwbqm7TCL0YSWoS2OXaJ2e3uSJtHQbI3nI8KOPvkcHN9BeW1mPcAlzaE6okDmOgiFWI0RBuYWVgryKadn6JTVRxKqcjgoJ/X6X3QiysQWxRjfCzeT5iutzTc+PGZxT8rZLAq94Z9RRqnBbYb+Qq4E2d/0wHanb6qsoXEwacBgtOX5yztDPEFLFkPLWiBd+9T8BgmlVxTUdQU6vtBEFZhRu1HGdJjKUchabnhiAuDx3XL9JAFp776uHdnMvx44wkWbItx85kZ7Rk/xyZlOO7pSzMLdSHcY97MG8rnboOzwITj2F/cjnrE4kjYLOscSYaOGbuXrirS4Jb5Wt7Hrcd6TLaEpnJ1XuUxRlxN4R6xFgk9qMeQdZkoniloGMET
 aG0YsPti
 +pcSYIwuy8eyZWPynoKSUtwZrQ7q/1qaETagwEqGzMDbb94/+F8Z2CRbmUVlrPkKxn1jSjfg1iG+OfxeVjuJfWI9lU2OMYxCz1Rb9QkvigUYrlm2TcQxZ/qVxS1/XUUQgLDlQeRt0DBHwCFjJsxdqv/vYcwJopQqqK+D2XqjncJXvXQHHA0tEYHOqMWng1vM27ma3LbuN6JS+I43viTN5p2MN+PiTR5RzGcR4rs3X5X7amPw8YNj7Q3qnd9mo8X4L7lgH532Ja+mNduXr6GzOvS1p/hu8wS3haVKI4u6+A6SEr32ZjCVO40C9/wsslTeQFItIYDZ0pCZdj9M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 19 Mar 2026 07:31:14 -0700 SeongJae Park <sj@kernel.org> wrote:

> Hello Josh,
> 
> On Thu, 19 Mar 2026 07:13:32 +0000 Josh Law <objecting@objecting.org> wrote:
[...] 
> And Sashiko comment [2].  TL; DR: Good finding.  We aware the issue and working
> on the fix.  Nonetheless, that's out of the scope of this patch.
> 
> : Does leaving dst in a torn-down state cause a NULL pointer dereference in
> : the background kdamond thread?
[...]
> Nice catch.  We actually figured out [3] this issue from the discussion on
> Josh's previous patch that motivated this one.  And I'm working on it.

I just posted the patch:
https://lore.kernel.org/20260319145218.86197-1-sj@kernel.org


Thanks,
SJ

[...]

