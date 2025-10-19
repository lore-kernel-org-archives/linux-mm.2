Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A5BFCCD184
	for <linux-mm@archiver.kernel.org>; Sun, 19 Oct 2025 20:14:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AC2B8E0003; Sun, 19 Oct 2025 16:14:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45C598E0002; Sun, 19 Oct 2025 16:14:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 372258E0003; Sun, 19 Oct 2025 16:14:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 20D378E0002
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 16:14:45 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 65D8116063C
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 20:14:44 +0000 (UTC)
X-FDA: 84015966888.21.3E10060
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1F61B4000E
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 20:14:40 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=OMVoWoFp
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760904882;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KQE2WMICXol8M7tcsnsAvEN3DKCYGmwZMsLRsgncwyY=;
	b=lLIZ3m2C9iyw028bE3QB5mFf8/Kk9adVkqifnw0Ohy4Ig4r/9RZMOgtkFyt5+nn4xbpKbK
	lBSxbinGL+U1DQLEH0IXory/RFIOl7s4qlAqtvyL8737ppR3h7fIcBv8P6DT1sfB2ss8Ng
	MYnd78X0msfhcFb3/sVCc4fT21Iopxc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=OMVoWoFp;
	spf=none (imf07.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760904882; a=rsa-sha256;
	cv=none;
	b=Szk7LGf5ngvGqTAME6gPyiUQnBMBObzAAlX9Lv4wCtpX1SgnWywmNKBNSN51PLc3OEV/5M
	SRMNWHItlnmDJQuzq1MgZvJP8nFrBP+ZmUK1XmJ3BW8XZZ9Abbm2qDpxqf5JjEfrNyI6OW
	Gpvv9F2GUrAe+Oek1ADB7xOKc4bUsJ8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=KQE2WMICXol8M7tcsnsAvEN3DKCYGmwZMsLRsgncwyY=; b=OMVoWoFpW/R8ekxshETeb2sT/V
	RsAxgDDDV0SiymSoaeihOaQQG8eGnDWqr9E7fxZ8gK2qFk/wuGAPkURSImtaLkx9+IPxVuLnwa4Hx
	jSO4M+MhzQcLKdTwzmj66CWbnvrXbmSWA8G6MPJaYTSYNLpdzSZE8fHFjyEjGUJIFfKmSFQ2YB9Zf
	6dUvw/lOoCl5r4pm8/3GcX+lKKj6KzHRNVUgoJ/Am0b90aRY9GPaJ6peTQiqJS0nlLWYpopHT9lMX
	j68+JvC02RRijOvzq2BbeUk+bu0NutbX7k7bXVtRbApwNm9/L0zuBAWxTnyCZJ1r2xCHellOSpYj6
	nmsyfNZA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vAZnV-00000003E9q-12RS;
	Sun, 19 Oct 2025 20:14:33 +0000
Date: Sun, 19 Oct 2025 21:14:33 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Huiwen He <hehuiwen@kylinos.cn>
Cc: markus.elfring@web.de, Liam.Howlett@oracle.com, aliceryhl@google.com,
	andrewjballance@gmail.com, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, maple-tree@lists.infradead.org
Subject: Re: [PATCH] maple_tree: Fix potential NULL pointer dereference if
 mas_pop_node() fails
Message-ID: <aPVGqRKFcI1SjZdk@casper.infradead.org>
References: <9092f8af-72d9-472e-8d5c-f950c8ce782d@web.de>
 <20251019114916.1618642-1-hehuiwen@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251019114916.1618642-1-hehuiwen@kylinos.cn>
X-Stat-Signature: i5zzkp91oj4ycdjxzi6jxttcqag57u51
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1F61B4000E
X-HE-Tag: 1760904880-267603
X-HE-Meta: U2FsdGVkX19sSqrwWNcCFIbkr80Jz+nNc5/t35rIAz9aW33vYf+oLLZXQ0/95ur8iVEj6yWq5fdF0MIcBHkB+u0r7d5+vZ917RND1KB3vr6QDAXdOxdg8UFjwrzs3LIUvoRnScnzvxDs7gW2tuNy6WOe8FpC2YdywMQKRg5d5tWFcZPfcm+QxYnJpAJ7vb8lwKB+CH0HNnFnbf/0tj42R7pJB+IkGTV0VSaBKcmusP3Y3G02zXctre4NFup/Mx4n+BVqocXVoSoEJva6lKJQ8D9vJJ+rr4HGU9m1ZOWLp47kA6n/g7LQrvWUersAl4KFXiD35kSrY4WdfkaLXgLMqlUHgKVvIK09Y9u4SiM2nL6gR4zmlCmYIewpcc6luoJruIiCXyhcmmEmJx3YrV0w9hMZNlLdTmi0aAriA38ARPXkz+BesBixfb2s2gEbUMv6QDXHdSGUcF/qXFf9KR9LUfuo7MysOu+GSAWqWOC3DUAwwUyGmh9gqoynknCHr860xBFSi7u+E1+aJBFyMtCvrOu3UbNevLCaBw+1/Xj6ULT/Q8PTo0bGsrad4J+olEt2I/Oj0ZsOOBAA9oms3u7m4GlpBRrIGwRtbdGvGjgWxKV6Psfz0PXuQ3Gir1RE6bKboe7U/eBTJx1IRzVbA4yahO0cYPziIfdTpejAv/ioYDxxi1waQOgHZWXlH1Dkewz3terhd7WhP6PZKiIh4LFZ8DaNuH3BNTCVg6ep5u/kz73uD6gE4C0emEa23emct7ODOpPMy/CoAI75Qv0zSLdncQxSrH+E+Ugu2qgexEzJZgI0+ci26ajmek0dCfPKGkFnUDp++UM9iDmeucQwpMmgMSCuFHN7NyMuC2DUir2BnCtiMbBbE6hf/nRXmDHr4N/Hzn842u7exsY9u2f1bo2ZWsxwfxn0LYw+Dhz34yrUR1xg72dE4uVrDWbQbViMxwujuJamqMwc7iRd+k4vlks
 /ZEjbuAn
 82W2fKVtKcK8hBTVJKcDdSCjdPcfSyfAvbUqRjmIiupkBo8iibq01hWcK04VrW9ppHjzeubdF2SrFBF5tuiB0daux5i6tGz89ziSFRyShXqliJSEivkTn9+o4V1nVDQ8C4LI9pAp3OuSJb79QD8yJG68/Pk7l2fkozZWeg4R72oj9N3YLDApBZttHH/INVuwg9KuOzhqBAPpk8ir9gxJqM5pcXXp1rv03+pIq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Oct 19, 2025 at 07:49:16PM +0800, Huiwen He wrote:
> Hi Markus,
> 
> Thanks for your suggestion.
> The commit description could be improved to better follow the imperative style.
> I'll update it in the later version (maybe v2). 

Do not send a v2 until somebody has a substantive comment.  I suspect
that what you are doing here is wrong, but I lack the understanding to
explain why it is wrong.

