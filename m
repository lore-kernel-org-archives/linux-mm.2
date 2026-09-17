Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CFE1C88E72
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 09:45:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A1E56B0098; Thu, 17 Sep 2026 05:45:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 179F06B0099; Thu, 17 Sep 2026 05:45:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B7BB6B009B; Thu, 17 Sep 2026 05:45:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DF6FE6B0098
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 05:45:44 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 707FF802BF
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 09:45:44 +0000 (UTC)
X-FDA: 85222772208.08.DE7ABE1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id CC6EE1C0006
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 09:45:42 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P2OGlLyn;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789638342;
	b=FYyk4QAeXXUcl40aX+FQXAQ44rvZiFpMwHmIZyeSkBXxTFZbT6LvRqThUhyks4G5NJCmXr
	Oga1hY2JCuCXT9TAHFKaPUJqilJZKeq+1bLYRRVn4HCtdfJvWuPcmzTrosPMiBIm8FvF3g
	GP3L+huqZ4Drq1CpU7q+mkKqum588Zg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P2OGlLyn;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789638342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FDNuj8kuRT3U5fhsiJ+tvKS8uIKKCbPWByXgFVMYkX4=;
	b=65586Ct8jJkYHktQQQTiF1+pzVr30snrlhJg7I/Huf9Sk18h8bqQ8h+CfjBfrQ21RRcohR
	app+fQYCjVW5wVs2fSJHFIjYpG95en5TPDf+doR1G967roPSLe/NcYGrbNZCyzCCwsPzBR
	+mlJf/pO8WcNcQETtAf+E7PSnWFuxt0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7155460210;
	Thu, 17 Sep 2026 09:45:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EC841F0089F;
	Thu, 17 Sep 2026 09:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789638342;
	bh=FDNuj8kuRT3U5fhsiJ+tvKS8uIKKCbPWByXgFVMYkX4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=P2OGlLynDadxkQjpPnk4D4NVYaPuiEWaEXJ1oPsc8R5f0E8yiwkI9gaNA4EK6Ynt6
	 1+XhDmDx+FGo+i/qY/8dUOgUGMVAL99r2jrKSqsKJxoIUNfgZF9fWHDFRXdfAA+3e8
	 gWOCWYRa1hXwwWPLgyIoOEZfwB85zZtkoHxgkZv0lu7JGPKYtF95fBVNNSrV6fwfBs
	 W+gOx6O/JXW6YiEuecXglDEgHbtmAvqSnE76wVNg69p4LcWDPYjaUTXvygqTuWFtYH
	 NyTBtsvc8T3lW0xPW5MfqedKxWB27iolgn3Z4cg5SCB+HR51MYZu9prBFO6R9Xa7Jx
	 JiQwQy1uzzXxQ==
Date: Thu, 17 Sep 2026 12:45:36 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "zhenghui.hao" <zhenghui.hao@qq.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-mm <linux-mm@kvack.org>,
	linux-parisc <linux-parisc@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] init, hugetlb: fix early parameter ordering
Message-ID: <aqu2wGY9on8eBmlk@kernel.org>
References: <20260917062837.558251-1-zhenghui.hao@qq.com>
 <tencent_0490E1CAA4336214AB70F813325F3020A608@qq.com>
 <178963086483.2200502.14463144472620315064.b4-reply@b4>
 <tencent_770E6207ABD8F875322130E7A6D5E1CDA408@qq.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_770E6207ABD8F875322130E7A6D5E1CDA408@qq.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CC6EE1C0006
X-Stat-Signature: ydyd71xtqkmqy1ouhyyk17n5emhmuxbm
X-Rspam-User: 
X-HE-Tag: 1789638342-264081
X-HE-Meta: U2FsdGVkX1+s7IpNPp8zl6CjM+rVFogSgAaVOM1LmZrUctPrlPibG3uD6YOoWgFd5Q8yFwaHWjA9Sfrfrfh4T1bsTIisIJ0n5scUQmHMgGaeXWBIF25WltlvXvE1fsdNxHl7fkBo0H+dtOITs627gFn8T9S1mXUC2p5Qkli/VlFDaLF97fbyaaZw49XG20bfgSmg4hsTUoKi7jaxGsPgiUmYqxgMT8oJdxgRJekVLoLEd13EXfp1dYl9JNja4RCLUc5qPNMBvLbNotHfKug1inQNK/WfQ8o1uG4OXroVnZrwnazdzhCWdMW+h+S9bIj5aHbcEsC3eQkiVOZ0j1RzkguDQn57POBYA29vdd9DVthNFjypXMxzCjGpn8+VYTs/yMBugpT35iYaB8dH7c17TlV3tkoRZ1uSiZvYoeP5KIMFQBOp46EYSB+KILSqZuieEH326RP8ZYyXCmgK2zvmMM0xrXYOHl3DfHffpd337UM0FWYO5s9YLT7OvnfHIBzAywWErMjpvBBxRO0ke460qoNUNqsircmus9NSAK/oFY48nriQ89/My+BfbWAn2AFJykAFKk/qlLeNV3zNp4DDIJ6a5Plpjn/FTmJ8FCZUM3i3AW5L7ROxFlPi6jidldMWi7cjRTRiXgfUt21DmzEOMSNYLpI1wq0MNqBuD7R0A7bduXAiAbpHnQRGV8tLls1l3+RODNqGXteWD8fLRUyss7rAEUHjhBgOf4ixnmSo/XIzFVja6VRr4fZHQ+rLkNlSLipkANjZoPfaeafWdICI2o5X+t8lJg0uuQGtOUfBZMLdWCoKlPpIWFY1D1klmDZnBBCFqx+Cii26poFS74mHO1mPizC1rSYAuvFZ0QHJ94LPLGiMhVe1bcycpcmBExdwT11TTJDdIr+7Nhms9ude1ylfHFce3Xr/z7UOHZ5SANimaBU+WvxLPQ4UfQ8Ppcpj8R7qxQ6LwLATI6WHtb2
 CIU5tsag
 UHv5xIbrdL2tPagWXbRjUFd7RwpxP0LIf9Bf/GfNTDJW99BusZKswN+pdrOIqdWzQOkWQKeZaZ9kD/JH2+uDhFEa95msvVvh34XMTZbon5U7FQsDSnwKPxLKIEi6R4HgTD9kB3Y5SVoE1BhPmQ6/8WXbzlHsACgtVINfkc3ZQLXxKJG3IlYxDEwNvGM43lqg+hNry3MV5hcbAavln/hyzLG/Xy7zGPX6F1tJ9HXIJueLBgnwLOq1OqjF1tA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 17, 2026 at 05:19:46PM +0800, zhenghui.hao wrote:
> Hi,
> 
> &gt; Since parisc is one of very few architectures that does not call
> &gt; parse_early_param() from setup_arch(), I think an easier fix would be
> &gt; local to parisc.
 

you should really fix your email setup :/

> Agreed, that is simpler.
> 
> Whether a fix is needed at all depends on the answer to your second
> question.  If hugetlb is not needed on parisc anymore, there is nothing
> left to fix and I will drop this series.  If it stays, I will send v2
> with the change inside parisc's setup_arch(), keeping 2/2 so that the
> same kind of ordering problem would at least show up in the log.
> 
> So I will wait for the parisc maintainers on that one.
> 
> Thanks,
> Zhenghui

-- 
Sincerely yours,
Mike.

