Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 313A7CD37B2
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 01:53:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA9E96B0088; Sun, 10 May 2026 21:53:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5B2E6B008A; Sun, 10 May 2026 21:53:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A972E6B008C; Sun, 10 May 2026 21:53:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9C6C36B0088
	for <linux-mm@kvack.org>; Sun, 10 May 2026 21:53:31 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 26B981C0437
	for <linux-mm@kvack.org>; Mon, 11 May 2026 01:53:31 +0000 (UTC)
X-FDA: 84753467022.24.FBC69FC
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7F310C000A
	for <linux-mm@kvack.org>; Mon, 11 May 2026 01:53:25 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf10.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778464409;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=x4GHE54Hoi8bBVBXAiy1208QilWlsSDH8Vz+cyjYJOE=;
	b=6IX3jpxaK5auUyw4vSqPvxqUtgsoQpZKnqWriU7ApYU11p2LRZkzmCtNQ/v3MSHU22kWW5
	OS43bdDvQCdCQQjwNTHEbxivedtHhYvqo7sQxAU6WKZ6roOjbC6DIMhiskkRClltHIJ3ka
	Yzu1yYCzfiFIVxmFGJYL5U+dyCUyi+k=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf10.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778464409; a=rsa-sha256;
	cv=none;
	b=RUpjG3Q/9E+Pe8eDcUEDp5lxpBXcnlckUQ6pvVZXi4DrqoUHO5rX5k6AtRTEzf2sNmFWab
	2qSdK9iV9+xTFAagSG4H1zNA6LZJ9BsQlsLexyL49DTdNW/PYRNoawrD0hwr7QEEZF/34Y
	q14kN/SxvR7qU54QwBqjgQTaXrXATuA=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 11 May 2026 10:53:21 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Mon, 11 May 2026 10:53:20 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Hans Holmberg <hans.holmberg@wdc.com>
Cc: chrisl@kernel.org, linux-mm@kvack.org, hans@owltronix.com,
	lsf-pc@lists.linux-foundation.org
Subject: Re: follow up after discussion at LSF
Message-ID: <agE2kEVjesh8DJPR@yjaykim-PowerEdge-T330>
References: <aZW0voL4MmnMQlaR@yjaykim-PowerEdge-T330>
 <20260506084741.14228-1-hans.holmberg@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260506084741.14228-1-hans.holmberg@wdc.com>
X-Stat-Signature: 7n4pox65beh9nu89o5w9et87uf1uzi97
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7F310C000A
X-Rspam-User: 
X-HE-Tag: 1778464405-159083
X-HE-Meta: U2FsdGVkX1+MzE1r4l2dufdDc4pwyoxvLt8N1fhIZCRki7ixM8ZD+vcs3qFvCEhvI92olwH6TzWsuFd6Ho7XbRXb+UNCOL454lGaInE3baa1Va88v8xIjnGcn5ElAPozpxdHzIrYymSWfP9G2Cb47z0JWFpgNb+1E0X7vhJL/mkss5IFvg/3hqJMGqwU90lJoa1TeHupAcd23LdDbk2+JjcCAcxb+zKtdyLUS6YGnjNk7zI7PVj6IeXAY2+ykWUnyhSJTCbbzOSXMKCP5lTAjJhlk9vjGNH+y++0A4k7ulAB9QQngvXW/Z+TOIg/zlz+Zw4VX4EuCxedwz27vc/7Tcqlx+9QBdIKOakKwIpiI6N83b+OmqcOCY00A2D1gb0zplVcOK8cm/5Efg9NflLfUFRxm5hEZWsVwn+dEZq8rX4tT47qeNtopvAGakJlWr+5G/eWr3xhqRG0HKifN/yAa5BabT/54y6DqSNFMat3i8WLlV4x1UUJdjcmY6vrdjY0Mf3XDTNySm2IUnREBrrYmDbIEpggnYyr8M5Om4ZXVAogCJqIpMGbtUZnk9h4gYoN5qFvc6V4QKoAgUFdwdiPTXnnHXh2WUwq9yQtk3WaZVA/YqUxoVoXTb8tlRS/EO1IvKEpabFHJ6yvO62w/lVf/ma07awQvEIGYRKcClRwZPeCT/gnjrBnfB774GgBcealCVVJeeBPGegsnN00Vw0iFyBQp0yK6rfO3ha0QcFT4WAiZLErN6B8uG/XnFMJSjmI22okclRq1SncQeWzuq+AsIfPcKVZetgJsW5noGJ8QJwI6TSQ0Vjd7Ol/JPefpj2+aWVGidwXUY525ygKw+esPDiYgDnGI4E8LJ2/idekVkEX/vpmLlJTPBUjFTEigsHb3BdgtkiW+Xn8PosJhmoGAmJWuy1lyFwiFkeDqz1VAf5GQfLr0BhyvdPKIpyNj3stDRvIVWHRXs4bSJbL3Ln
 Q0sdRaG3
 PSWckIIe1LWJB+RPc7mTa9qjQq2dlkoSUgBlh+zxNm/4Wdf7kM9qFcLZgGWQQvqOchM5hFg4S7y2tY6ezAMHtNHmCWVL9uRG83QeV6GSOE8QPUX6f05PebGpu1oPR97vxPc5hybOKTvVpW1ufL8W09gzPZQtyFFIB43EUZ3EpxNjQtuKmEhIo/FV9nNNoBEyTnRSGuiT6cgxdB171B81tXJzLFofP8FDNr54YvtIw3v8PttCHyuTXJR857/24nOS7suoBxCY5ji16wTKBwzW11G83qQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 06, 2026 at 10:47:41AM +0200, Hans Holmberg wrote:
> I'd just like to point out a paper by Shai Bergman:
> 
> "ZNSwap: un-Block your Swap"
> https://www.usenix.org/conference/atc22/presentation/bergman
> 
> It targets ZNS SSDs but it has a lot of relevant good stuff. 

Hello Holmberg,
Thank you for sharing this paper with me.

I appreciate you pointing it out.
I will review it carefully. :)

Best regards,
Youngjun Park 

