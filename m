Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85938CD5BC9
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 15:30:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CAE936B0099; Mon, 25 May 2026 11:30:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5F026B009B; Mon, 25 May 2026 11:30:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9D006B009D; Mon, 25 May 2026 11:30:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ABA426B0099
	for <linux-mm@kvack.org>; Mon, 25 May 2026 11:30:40 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3DF978BCCB
	for <linux-mm@kvack.org>; Mon, 25 May 2026 15:30:40 +0000 (UTC)
X-FDA: 84806329440.03.CE6958E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9183A40015
	for <linux-mm@kvack.org>; Mon, 25 May 2026 15:30:38 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S415AHNc;
	spf=pass (imf17.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779723038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OtJlsoM2fF6Cnpl17HukfO1fqAnQBAvmo87VBXGoBmo=;
	b=Zw2h9jF5l1zxxtEue/FZe3jRC/Ae9FZydi1bNwnjxdYpg4C5tOD3Y2t6ejol1TGwIBiMP6
	gmF52bZt6oLvgYCbt2cHUXV/RSfFozqwVVXz6cdTvLXnb3gR1a48ptCMZ4eVH2sN6DBXxH
	XxUzBZgFiefe470QJ4opFHYwJoFGmC4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S415AHNc;
	spf=pass (imf17.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779723038; a=rsa-sha256;
	cv=none;
	b=qBmzgUwE90ZTWh45sLdg0VzCETFmkZg+wXXKhA51moq+cS7TK3twJPVRujsBJiwT58efMD
	6C8GPH7ZCC8TDeakg6TqzIyEjWo3UUJw5ZJ9+R0ZhN0zqHaWIY4/OtP+LpJWLAxjtb6xji
	5pgBolkoKCLHzxoCFYifY4PDLy9bo6U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 140F3600AB;
	Mon, 25 May 2026 15:30:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B50B1F000E9;
	Mon, 25 May 2026 15:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779723037;
	bh=OtJlsoM2fF6Cnpl17HukfO1fqAnQBAvmo87VBXGoBmo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=S415AHNc03IacdvQbnISEPk2z1abb4XVpEac+IYMKNL9F1T65+bfcN7/vL7fDcTGs
	 k1Xo6TYD8kyRb+MZZ3ENaTNByGpWEMCVtiTRgVFpKqGzqgqNQ9xtVnHXPClP9EXaPb
	 PECYEHpyJ0oY5f5i58xKCWrexuNtdvWil+ULjWJky+EIZAFDD9KzhG6ukX2rHZdAUo
	 5gR4E1/5hHfaq6mcMKV5dynarDuH78p69AqniiNyE+bVzTOR/s0fGUp5yKAX4ED7Eg
	 dZ511PZk/USgwGcq3z4JmYrxjbQgP0Mg+QR2tQ3utqOU8kUjgz5FZuHPp5FCHexA66
	 w9vJIQ8e/3Plg==
From: Pratyush Yadav <pratyush@kernel.org>
To: Yifei Chu <yifeichu24@gmail.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,  Mike Rapoport
 <rppt@kernel.org>,  linux-kernel@vger.kernel.org,  Pratyush Yadav
 <pratyush@kernel.org>,  Andrew Morton <akpm@linux-foundation.org>,
  Alexander Graf <graf@amazon.com>,  linux-mm@kvack.org,
  kexec@lists.infradead.org
Subject: Re: [BUG] liveupdate/memfd: duplicate memfd preserve restores same
 KHO folio twice
In-Reply-To: <CAPJnbg+nrOfyYGaX7rPP1pQunzuLb9QXVbi_cnBhj8NoiXjM5g@mail.gmail.com>
	(Yifei Chu's message of "Sun, 24 May 2026 10:44:40 -0400")
References: <CAPJnbg+nrOfyYGaX7rPP1pQunzuLb9QXVbi_cnBhj8NoiXjM5g@mail.gmail.com>
Date: Mon, 25 May 2026 17:30:34 +0200
Message-ID: <2vxzfr3f7bhh.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: dr99uyignnwizpuffcwn3ed1iwju7suj
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9183A40015
X-HE-Tag: 1779723038-51118
X-HE-Meta: U2FsdGVkX1+oGexzusz8AUAf1SBDmH0u1lhkk7HjC+EoXUD1XG/aJ7LiqlNOKNBuaWRRw2T0y0nuOO36+1UyOgS65xprBb2uW8VspS651i889BrWQkOn8PM7V4KMRlpC01fquIN9nVZ7pc1D/W+nOs1HUH13QyjSTK05ci43KTCV582uGtX6fVrPvQgZ4Xhfsw5veMhlfqoj3rLCPPCIOweWMmOsy+WLhH6CTcf57cxZiVKhEKc2YE9D7kMxq2/d6cK83HFzlw5Jl5JkTB5ndq1fAx1eG3BUDsCZvAUbClfIok1eJYnn2eYt/KnfodmOtGOkHu23REenQDR06SRgjD7RPNZnkaqLZOL/YMq1OKBCcqG5d8L6cMxcDaoI2Ioq5vp/kfqbfg57haFYh5BaHStNex3wx/d+4GRbusciIDsfzGaFCmp9y/VWYj3DqAzGAxpGoJl2UEsKGLiD9mrCB4F642K1xJqkyf8DK7PZPy6cTfyGhdn6X6JUcugpTPJcR4iyqJWioS54k1Rca78tEztUiq6hrWVk5LGX9l5E5GjUSP948cL0uTzmKLgD4BpgXqFj+QNg/aVMjxeK8cUfh3fBYTRvp6I0LLG+44AXjjzNiupMMRSG+a7HN0RrLYfWhKFhIcEnMhgCVsLfkiuZT5WKOFwS9jCnX+gPLzHI/CFPQWF6J+5kPIz/MfbHP2VAXy3WsDvqjr05rch5NHhEebUQ0dSkRfErLJwR3a3qmxFw5KupwbDN5f3QeGUUGY4Y4bKbGTsNXTi39/uhkAajPIIQlalT04TFFK98LTCmB+ZLWQKok4XJfsU2ZpC5+nSykDmz/BNZ4FJzMsDpNedc/XrOLpLSeDojEVwdwibwmGMRoxazoh/8OYJG6llqb0pcnrmBmRQjXya+amPIm/9QHD7Il/0jRb2Pnk3fN2YJhdOcmxCbVKRNyEnRZBfi1BbjKjFg8yPaehr01EXH0dj
 DOxHqhB9
 PezqtbolV08eeTs02wxFhVBtsU/CwAJotCYPNYQjtvm/eyzzK79nvNQf3DHGxcT+vRrhQ0aucIsDBehIN3EaN6M8jqDCnZsf1DfaNJio21NgDsRuTBZVhGVUIZ8zVkq0qxUMYfx1+wigpFm2T6h3vP/OpHMFuctIk2D8S61fiJ7kRLpcdieE+/YyxUPIvLyxxR2+B
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, May 24 2026, Yifei Chu wrote:

> Hello,
>
> Short version: I found that the same memfd can be preserved more than once in a single liveupdate session under different
> tokens. After kexec, those tokens can both refer to the same preserved KHO folio, and the second restore path hits
> kho_restore_page(). With panic_on_warn=1, this is a reproducible panic.

Pasha fixed this with 00d0b372374f ("liveupdate: prevent double
management of files"). It landed in v7.1-rc1.

Since you seem to be using 7.0.9, please port this patch to the 7.0.y
series and try again. If this fixes the problem, please send it to
stable@vger.kernel.org so it can be included in the 7.0.y series.

-- 
Regards,
Pratyush Yadav

