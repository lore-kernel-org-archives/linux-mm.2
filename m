Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E73AF506E1
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 14:49:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 234596B02BD; Mon, 16 Mar 2026 10:49:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20C3B6B02BF; Mon, 16 Mar 2026 10:49:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 143546B02C4; Mon, 16 Mar 2026 10:49:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F3C5B6B02BD
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 10:49:51 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 84B7A13A226
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 14:49:51 +0000 (UTC)
X-FDA: 84552210582.10.7BC7CA0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 17362180008
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 14:49:49 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=erPcNdRr;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773672590;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8WbBa5NZ15FWilBsvGIA1FpXTn7LFaIM1ZGcUUdJTC0=;
	b=D5/vs3phzn2jvbhn2OsqV5iLwq3JrAWeJh2BXx2+g6tQPwjLJoIcsZ/4MfA7onSMZyCw36
	em/T67nh+1ZC4N03hI/hXIMNFBU8ZsVIZo0q6M84RdQFY+EGvD5mRoBk9xnuF896+P+v1A
	7tZiLTRTwx3LLnGX7+ES9/jqU+vAKO0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=erPcNdRr;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773672590; a=rsa-sha256;
	cv=none;
	b=T7IBYP7qLXAm8en8ahPzYnBWZn402b4ZetAmUuK7tLUyyWXAjEtUMuhUSvyvmDUs/w1Y/X
	ajVdHAOwvWKdfFzFPsQN8miVVQPJ0EcMmMp0mhGdbo0PWlFOmMldGQJ55eXZd0FO1Gw5II
	Hl/Bp8K7swWSaGeg/M0gc7JxCBEu7Es=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 72F5D60018;
	Mon, 16 Mar 2026 14:49:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4208C19425;
	Mon, 16 Mar 2026 14:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773672589;
	bh=FNxLuIsdj1rcfvCD3t5aqHNbmMs+iUHxFAnqDU2yMVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=erPcNdRrzSzoBmpTVlu95ZNbsecE8P2qaKZt/azsVJzsJxdGOqSRiA+tXJr3zz8s5
	 TjN08ppq3ADBs1No4j0+PIc614vCK6BijXfQG0ZKphb+tC07jT+ViD4DWkunCDezDP
	 3URvTNSbxypqqE2HeOA8iNGODdBIDKxg3rr53u4OwKoBbI9lP0rcMQu7tIJbXKhTha
	 M1pdgES13ae3uWawJukxsAuv3PtSvVxSu0LUnPU8R85f8rN5lLkjaKUC6+nLWnLSnj
	 3/PfNA0uhKHoZcXb9h6v1h9g01QRPnbj0JHYokHNEdnD7Dyndh4Rc9UenF8BBLfnj8
	 yRS+PDsbp6GwA==
From: SeongJae Park <sj@kernel.org>
To: gutierrez.asier@huawei-partners.com
Cc: SeongJae Park <sj@kernel.org>,
	artem.kuzin@huawei.com,
	stepanov.anatoly@huawei.com,
	wangkefeng.wang@huawei.com,
	yanquanmin1@huawei.com,
	zuoze1@huawei.com,
	damon@lists.linux.dev,
	akpm@linux-foundation.org,
	ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 1/1] Docs/mm/damon: Document DAMON actions when TRANSPARENT_HUGEPAGE is off
Date: Mon, 16 Mar 2026 07:48:47 -0700
Message-ID: <20260316144848.99972-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260316140822.2033181-1-gutierrez.asier@huawei-partners.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 17362180008
X-Rspamd-Server: rspam08
X-Stat-Signature: jke6bfdgmsfxpu7cgpsnpkefhxn37scj
X-HE-Tag: 1773672589-130196
X-HE-Meta: U2FsdGVkX1/dDpmys2wxCpQKXWujenE5r0kytRZHDwv+lPdgqj3XXpZxwk/ZDuaUs60HOSZVUkszo27v+pdXWIptuiwA2Irh+uOCTJdmtDe4Mv0s4kHVfI3Q0hfrD+0mhhafNf8mULVmu5+90SpPwFoCriXAaHYJo/nSQC+pESoPux94X6cjadpCJ+v+Awk+rFJw2fXtMJ6wCfpUx2varbDXiNlxKFypTg6VDobZxSF1uCBqbhljxIeq/bL3a8nxjxvoTJbis4AB/dhI/ioFmulHYF9hGgAek/WZj4EVm9+73fsVShB3gIa2PU+DTMo0hyAp3ZCH/XfshfCeber7gLkOx15Mdq694PrWbBUPzlgyI0aPH7LOnabB9SPwH6Lj/zfDrQBlXcBam0Ckddb9/tmAt8WJYkdVqLTLn661wv2gdKA0Zs/prnDi6VDh/txRdhE7LbvpoqwTZki6GE8YVzkZTxZsUMfbUl0Fx+c2hsBksEo12x99HTCM9QWL5dOPYG11hhNjSzmNr2ol9PEWnYOd7oRXZDrrXnUdgrdA96Vp7Ef0Qg6W/JqfhY7QrH7a8OdQE/tJKxBcbFW2GTEJMWhop/ud8QwjRfgTrnlXlcB5375+x1Ta4GBDykG6Tk3cnu9iF+sE01nydseAJQzsIyYCSHw8/opT92HCIvULQvrdqdy6jMjJu0WxRD8MOptMq6gEULRjQbYnO2Hr4DUCEHOcLB1Tpsi2dyufNntrkQ5lNoaPTE4S2RODnfqW5/MAIBNavYxq9AdC98dZDS2+SMo2Mf13fYnJ0ETkCSRxXYTu/AzgzyCjTwUdxOzjuVVGXyh4T7kb+ja/mFRLRcLADa1jEVb3GYGL2JnA3gEVv7PQKlDXSCz5iVU2lNIiczmIc3QQRx64RuBNjlPBt2+aruXJ96oH+rQbUD33933MsGTASZ5PD7wxKAMnrCGqJ4tTs7S9idHRG3YZIn1OKGx
 RaCPI+Qr
 HVwvb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Asier,


Thank you for sending this patch. :)

On Mon, 16 Mar 2026 14:08:21 +0000 <gutierrez.asier@huawei-partners.com> wrote:

> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> 
> MADV_HUGEPAGE and MADV_NOHUGEPAGE are guarded and they
> are not available when compiling the kernel without TRANSPARENT_HUGEPAGE
> option. The DAMON behaviour is to silently fail[1] in when DAMOS_HUGEPAGE or

checkpatch.pl shows a warning for the above line:

    WARNING: Prefer a maximum 75 chars per line (possible unwrapped commit description?)
    #12:
    option. The DAMON behaviour is to silently fail[1] in when DAMOS_HUGEPAGE or

> DAMOS_NOHUGEPAGE are used, but TRANSPARENT_HUGEPAGE is disabled. Update the
> DAMON documentation to reflect this behaviour.
> 
> [1]: https://lore.kernel.org/damon/66131775-180b-4b9f-b7ce-61a3e077b6e6@huawei-partners.com/T/#m278d3c9bbedcceaf2efa51e3dc7b40a40654e51c
> 
> Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>

Reviewed-by: SeongJae Park <sj@kernel.org>

Andrew might add this to mm.git while fixing the checkpatch warning on his own.
Let's give time for Andrew today.

I also added this to damon/next tree after fixing the warning.  If Andrew
doesn't pick this with the fix today, I will post mine as v2 of this patch
tomorrow.  If you prefer to do the v2 posting on your own, just let me know :)


Thanks,
SJ

[...]

