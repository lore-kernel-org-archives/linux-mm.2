Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84C33D0D15D
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 18:32:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E30106B0092; Wed,  7 Jan 2026 13:32:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDE316B0093; Wed,  7 Jan 2026 13:32:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC0566B0095; Wed,  7 Jan 2026 13:32:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BD3796B0092
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 13:32:12 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 890561B7E8
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 18:32:12 +0000 (UTC)
X-FDA: 84306012504.14.5ECDEA6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id BD66D40013
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 18:32:10 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=jjTWHxQh;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767810730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LsWKgKGLWMw9v2gWg30ZKYDhQra3uhOE4tA/oNZklm0=;
	b=Srt7bQ0yLYWRmlZPWdPCiNaE1d2WbBCSHABcKII6sLDh6MJElKC4rWCJ+HHVU2DFaJnfAW
	LAIXZveWg9ZgoiTMoCQaxy22Nbf21LBK8VV/4nQEkNhurUk79JYyQkVCuYn2Nz0CUFbhgO
	fa33JQqRQUrPmj/Wv10gUuCCFcEVCx0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767810730; a=rsa-sha256;
	cv=none;
	b=kX8wHVrccnOUrDUBPA5lGpYmZT5yZeW+szg/ZAGtuvL16xcJxIlBbxhsv1HSirYJyR6ZUg
	eUQnIS+2+kZS6yaBzNkETgw8fN1VtudBJ1qUuIn15Fc7gQ3oJZKsGUXum4QeZN0bv2gp2Z
	+r5d8oSS+RNEOerTM/5GNEeu2418ISU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=jjTWHxQh;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C235440E03;
	Wed,  7 Jan 2026 18:32:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73219C4CEF1;
	Wed,  7 Jan 2026 18:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767810729;
	bh=7ICgTImWvYWCenkI2+hXNPLSdjtpu4hBw3mxjXZeAlk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=jjTWHxQhmiDt6mFITXMLh7G4TTTr7lD6lgQzc33gGccDRZD7o7luipSPDYygxWlr1
	 DEkgWhhcWVA4LxZE50vb4udhBsjJV5C609p8TMYa1XrqnK/1DJPTA1gQFMEGikO5hi
	 ricr2Vpg6Ve2FrP/lw4dDsSQYDfMdIbvfZBWwRKs=
Date: Wed, 7 Jan 2026 10:32:08 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Thomas Ballasi <tballasi@linux.microsoft.com>, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, mhiramat@kernel.org,
 rostedt@goodmis.org
Subject: Re: [PATCH v3 1/2] mm: vmscan: add cgroup IDs to vmscan tracepoints
Message-Id: <20260107103208.e64fe3c26d02bfcb21404dd9@linux-foundation.org>
In-Reply-To: <ovqxo2mmjiuymqk36t2xydcyzvtppcqsog62yx3qtwsknbkgzq@3phadh5gfyjd>
References: <20251216140252.11864-1-tballasi@linux.microsoft.com>
	<20260105160423.23708-1-tballasi@linux.microsoft.com>
	<20260105160423.23708-2-tballasi@linux.microsoft.com>
	<62ia3v3oduyt2srkaneccoei7cwimifwduarteyn2ugpmmbw3p@rivcqvcksgpt>
	<ovqxo2mmjiuymqk36t2xydcyzvtppcqsog62yx3qtwsknbkgzq@3phadh5gfyjd>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: x64qwg4sh4uci9yc7fy5s785j88rrapt
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BD66D40013
X-Rspam-User: 
X-HE-Tag: 1767810730-288111
X-HE-Meta: U2FsdGVkX19EPlpCcWqGeCCuQ0nCjyeZgDtiSPLwnsb5RGiI5lD3noC3WoMUD9VonkrjMNJhoS5V2mrEukeCTYJTcmsZCjFsx95K0BXEnCwHN/4TxhJCI8Y6cZ8z9XzWAFB11o2p1GF6XOK5yAwecOh/mme1THPtj3EsAaDVYhvRj4doYZ1xOg6VeFUeNyjho/0ZIa/11MZm+rbnQJEScWDtQy30l4bjLwKXJZznmtnDpZL42n5Ip3rfizKCAu1ziFcr/UGu4dc9SQWvaxl9ex//aSnZpuTPF1twBnTzXlh0N0jx6MDrQ4wccudSlmuhKBM8HlUk+S46WNRqrb8FnWYa6YOK3yBr9vDRoGQNF8GARq+eKy1uWaxm4vRZ2AjXWE+TnaAoeRSxHcvj6qL24MjjLBhMJTK1DB5aSeqtFQTZmPVGaUi+lwNhcGI5YDRBuSEkpNtDFxp9HV4vcNSxQGN8BOWKAslxZuagIxsQ7zjnFbwqFtihBR/9W59DGlDl7ftqeY/tC3+00/4mQcxdljeqhOLpDzO66OnsbG/CLV71ua66KX4PeLQJVO5+lAv/CaKN/BSaTeoXae2UXeConazmpzAXW5xvA2yS69O64j6czlsEkFkh1FyD7DlNelzFNbTQBGE4AtIFVLx/wVI9L+n0REItzwvk8nRW2mdUZyfSREANQd/5CpYtefFtIgjllIouDvHYfZESWgccJo5VIAjD/v9gIoUCwoBl1uHpzN6VkF9pfvYjexP4wFooXYNzON6S5yEEhB372QfDnDWgXqaZxHRKWlPxwIS2+0xhrSQfizOfy7lHPl9CACuMO4f/lMuWn4xFR/z1fnlDqXtYf7Xc/W2ILImaZ2g0geGJ2BB3N3bUiAb3loRgNwgkC0wppPTlibbXm0JC/JuhRTtv3zR7ecOOgslQqVOifV26CwwGsXWEU5qJJ6eEqCfyk+s7tpymjp+J609r4RTFs9F
 3R49Dum8
 O8iKVE2aszHc5BgoX7x5FhZe7VRQYWsRXjk4vEUIrL1c84XQApMt+reZCG3nWVv5H1lZeYlA7QLcHLSfEK5CnWFdck+VdfHbX01f4v2zrg0z1n4O45gqIqhhuXl0bYgZx2oLrv3T6ET/aExi67WbFBQGjSumW7aiQA26cm72FOw6RdSMUFSuWzfxjHHvMjJ962Y/LDeSLLanwSpsv7oVJ6VrKhnR0ROaSmuZGnlUryLR++Soljs4tN9ZDhw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 7 Jan 2026 10:14:53 -0800 Shakeel Butt <shakeel.butt@linux.dev> wrote:

> On Mon, Jan 05, 2026 at 02:46:39PM -0800, Shakeel Butt wrote:
> [...]
> > 
> > Orthogonally I am cleaning up memcg id usage and after that cleanup,
> > mem_cgroup_id() would be preferred way to get the ID. No need to do
> > anything now as I will cleanup this usage later as well.
> 
> The series has been landed in mm-new. Please use mem_cgroup_id() instead
> of cgroup_id(memcg->css.cgroup).

fyi, I removed this series yesterday due to a CONFIG_MEMCG=n build failure.

