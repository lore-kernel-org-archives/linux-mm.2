Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 040DE10F285F
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 17:25:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 494FB6B0095; Fri, 27 Mar 2026 13:25:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4454F6B0096; Fri, 27 Mar 2026 13:25:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 382C36B0098; Fri, 27 Mar 2026 13:25:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 271636B0095
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 13:25:00 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A5FD51611FD
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 17:24:59 +0000 (UTC)
X-FDA: 84592518318.26.8083262
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id BBF284000C
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 17:24:57 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=mqx9zlSM;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774632297; a=rsa-sha256;
	cv=none;
	b=zqTr09T1Q8d3S2OwuYvDlMbMz5A9K30ADjFJ//+1Kow+YskJ0FbB+aTVqpVYqHEQ3juRP0
	b2ITGM/ITXloynkfDDY38RbjgTPNP6TH8EiQQQcx6MveiVUUm8QIT8bCstDRl1r6XBQToC
	8zrYnGDOpbwH6cQRk9jiCCLZZ9mz2Bk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=mqx9zlSM;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774632297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J+GsgnYrCr8JIra/iFHKtfY42RH2kUGUJClXVK2ntF8=;
	b=AxoE5EkcolPc8WXsCZcKoAAAn/6GYGU7VgC9cODxtWLNHXqpw3if/ZsAOGqF5iu1mXvfOM
	UyFzfpL6VkZ/pk2YdH5CeNB7O2gPMCe7sHWfFoJQF/4Quohsywdwit27u5W+eTNnpI2j3M
	+ATWRtv+moaPeYvfVkiqQIiCd+qaOE0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AFDCB44572;
	Fri, 27 Mar 2026 17:24:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5501FC2BC9E;
	Fri, 27 Mar 2026 17:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774632296;
	bh=TZPF7VCGq1cEH5Fyac3Q1gSjm+Tnh5sqNrORWnAT/yc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=mqx9zlSMPDSfyL2WOB2lP5TeYHilV/uqm69D4FD7sQzrEFEYMhKIs07aNmrHiXUs9
	 DWj04NRvLR4o8t7gGL9nW16DkEpfTZ7BhaCucfey9dCf0niy98rqq355PmybhQ8JWy
	 5csHTt0P9Hg2hqTL+WCNPcGXN/AaawCvkH7lQYyk=
Date: Fri, 27 Mar 2026 10:24:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: rppt@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 dmatlack@google.com, pratyush@kernel.org, skhawaja@google.com
Subject: Re: [PATCH v3 00/10] liveupdate: Fix module unloading and
 unregister API
Message-Id: <20260327102455.05d36a1f5682a2a70df05b7c@linux-foundation.org>
In-Reply-To: <20260327033335.696621-1-pasha.tatashin@soleen.com>
References: <20260327033335.696621-1-pasha.tatashin@soleen.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: zjg64egujno5pkamazaecorp4r9fcg9z
X-Rspamd-Queue-Id: BBF284000C
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774632297-870104
X-HE-Meta: U2FsdGVkX1+TmuY2ipCcASA52S47j8isgAiJpnfQZnVFngbxNr1y4hvcnguzUvWePNKtFgcj3zRbLRG2tPHHDAGEzeti05ViDvEBnUJoWTdIB7TpkLCECSbOU3EdOFte4pcaZG3XK9oBPAtlJ757K2XmZfID3dO05ShJaAikao9tle7QmaATl2Z+6AAYwsaKwcGc5M7xsAiiOrmgUVBSlHnLFZ8QJYMWyK1DWLCtPhmbKUpcdSvdfuUyoFhtSkf85FPQoWS4rt1gsNt8MAUK9U9P9zEDp3ZNFScZAEWy3ZJ55QYLDq87+YgRlcdXZNg+5CzUbuAByG7WbVP6I7JcRJ3h4Ob/phLQgo5JXTjasf0lmtcrlGk+RA+6JUyKC7I252AfqcdweB9xzfhV9ap0kHflZXwq4YhRBBruC/UB/S3vLZLVANWbC49YOu05n5JlI5bjWaktOoe5G/7swiMgDFAwjdhd4jJ1sEc/G0+sbHUkAfFpgnqVEPPzYD3XLhhykwJz6FvjUQHhaf+Sxu0KUyZq+azHNGM3yo+Zy00qfDpK1FyKtIPBpiJ0Rdc7qL0lwawpF7I0uxA9sZN54nVcbasgE0qQ+C0tCLi33V2KkW22rUe6CA+VJ/gHxYhVJH5PrsLn/T3FxqHTRySyooNhuxmE12dQD0AvigGagPg5N/6iITYJ4v2DJpz5fnSP/ThpXT3WE7/Dt1f01YpnNWWr1u/jhQAMRuKIzX0bATdARyLuhpsW1p1WWBXUa4InQZuOHvtF5oYb3kFPbg7X5K3eMbAWnQE73gHbglfy5wKzvX9P10pFgliB812ndWdsyY0Wg60o7qiA6aGD6IIu8X4PgC6kIhJN8HbV/UQLuSmEysFV1Uagd3jYtrUCMelveodeKzPjdgWqGd/iQy7Fplr+rytd0lG2X5Yj8n4x2B2Ngx2Z1JN5T8womBrQ7jRJrwXJZI8dwgogpzsjQ5J7z0g
 XtSwRBiN
 KcrwbBaRTNWuJhgFBH9UlXtOKaYwKFaP8feO9ZrcMIdPQhFast/dH2oUuQdEplNIaW0ho0p420nDQtQEtg0Gt8ialzJSza/D+NWSb1F3DW5io8fHVJwlR1yXorkzVnDiAOlBXQQRtv3ZKPBA9DtpRwqWOWdGqV7b2QXtOg21+aU6+aEQVCMpmOJahJOuWhaoAdbrI/06hyyNDOg+agjicYOo1cSSUx0kS0BGIABWWC9RY8vty/WKtbTCzhmZZ35nCx+8qjSseAhNolRxtWeElebf+ahdi2YEDLKW5tzy1hB/qa9dT5HMET3TNaw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 27 Mar 2026 03:33:24 +0000 Pasha Tatashin <pasha.tatashin@soleen.com> wrote:

> This patch series addresses an issue with how LUO handles module
> reference counting and unregistration during a module unload (e.g.,
> via rmmod).

Thanks.  I've added this to mm.git's mm-new branch.

It's getting late, but the series fixes things and LUO is still under
heavy development and is a bit experimental (yes?).  External testing
and prompt review (please) will help things along.

