Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37549C55167
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 20:45:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEE876B007B; Thu, 30 Jul 2026 16:45:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9FD16B008A; Thu, 30 Jul 2026 16:45:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB78D6B008C; Thu, 30 Jul 2026 16:45:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AF0FF6B007B
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 16:45:34 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C9FB5140275
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 20:45:32 +0000 (UTC)
X-FDA: 85046623704.24.1324C7D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 238721C000E
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 20:45:30 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=qIEyBDuP;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785444331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NI8F24gX7xS4QrXS/zMAnM2js9tvRYhDpN/5mL44Xko=;
	b=x31xQZ3N7OldUfjKOgpZgGt+B7ZGUoKYgaGod85YVPton6vsP8vilvJrAuTnFPnlcBRo9s
	DWGMaU5ibA58WkLjyprQ/PdJFMFPKwwbQwO8Fms/pzOjKu3dJplwxyaXuaEm4kmecyCpmh
	slByBJcu0StzDZ2f/eYRrTYihLGevQw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785444331;
	b=QsN3e8QTakhkHKH5aBQYEEVeYg2J/I8OjJybSPqee4t1797ocaCBNlmc2FO1xJN+UmdntF
	EuZe9PuTlG1z4ZPyCClGIxk41wR79A46X16E0bum+tI092GtjvLlXVymOuHwEOf6n2rOrG
	fZeoeQ00SmbLCHknnwGjOuCnl5DmMps=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=qIEyBDuP;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 624166001D;
	Thu, 30 Jul 2026 20:45:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 007E51F000E9;
	Thu, 30 Jul 2026 20:45:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785444330;
	bh=NI8F24gX7xS4QrXS/zMAnM2js9tvRYhDpN/5mL44Xko=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=qIEyBDuP0qreEfcDzd6RI5Q25NWu2jQmgr+7oEK0ueFWBnplcT8X3oaTQB6QCSTVs
	 uad4oDBHBd+ZgfLc8u+8yXU0b3ZfI923aoKC5wPZczi0W2SwjhY/0iNFd1tErepElB
	 KLMv8mhQb3/iAVdfWgcGqZE0ndZGKQbG0ByiI5mk=
Date: Thu, 30 Jul 2026 13:45:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Warren Xiong <warren.xiong@ugreen.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] tools/mm: prevent page_owner_sort from truncating
 input
Message-Id: <20260730134529.29151e44a6da7430a4caf10c@linux-foundation.org>
In-Reply-To: <20260730015809.3819606-1-warren.xiong@ugreen.com>
References: <20260729053812.882137-1-warren.xiong@ugreen.com>
	<20260730015809.3819606-1-warren.xiong@ugreen.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 238721C000E
X-Stat-Signature: i3qsnaea5rwng1ppuw8xyximyxq1aj6c
X-Rspam-User: 
X-HE-Tag: 1785444330-275335
X-HE-Meta: U2FsdGVkX1838H5eCiltxLmw4+ZcJCnEQvpImYQGUwWY2WFv1nLNNxTWRTlKFx6Yz/s2/l7Va7yDOj793cB2Q6d9bFVvCtCPh6McjXx9qujZ3UP3DvXOzKk0HPLC6xursYwDZkxppx+80/3j+wrw0SWkFzvCDfS+ICndBWO0PJgE7g5s9f9CPzsREI8d6I1DlvAOONMWlBBOatqevj6RleBFYkboAln7ZkcdnV1XlQ1rVy+HtXIXRxhGJjbhb1g+CZlRVe/qlRQ312le31p2Dc3zjtwxTqXnstkkijel8KOOPECFA3KVVMqj76jqPq96in4s7kipuYJCPkzpCZmneW8eSF0XTos/OGfBw71OZ6OlNPVa5+/zdViMZZWKewLdUt9R1MH9JbpKlpr3lTVpfC1IK+t632y495LHKiGYi4gy54y73us5GAfqxea62yLaBHzQO2fvOC9SvATKO5VvAqzS6SqHmEYHQYVVZIAeFJpy7dQddzkWYwuk/OrKcvBCtsk/fRrAIdnSK0KgByfPpXBgqSApLJ/FheckB2mlJCybacmRjfj6gFQHgiynUhYKb6rC/GV2ioqY62E8zWNv4eifeAK8A0fqpgOmVhRxHM1SQUXJ/Jq2+S60aNL4dRBLGE0ag5nVmMmLJyc7CKxeazsz6QzfjTcHz6UjSkc7QYyiiX8/K/1p+XEZSpontFNk9wmHgMqH2LXlNOAg6xZVNoMauWHPKxusvMSK+VtSSoVPnojLTUZXoLiFVA55NqMwtdjJKEb89uYTSG1/42DvWzruSyUk8i+9WLheam2CBRcfQNvf3gM8LXl0q5fBGFqNCXXQ7g9XQsJ2HmaqDHq5n9Y/yLVOlvDEknIqbez/jRyK2WiyHSKG/CEllKjFMNpt/locUykEPWJmR87ZBnoMde8hglxchQ4U+VK+hTtpsXzvxPWUJVjntwoHeRC5LVvImLE4D8iAbnsDQWof5iK
 beZQE7zn
 BnDofRwQ95RyLBFNglJpKBTZjpr5u65Cd+bwItExhamhLfVoQUVgXcdJQXK+ZOlXeLOHuSh8LTpguy7HVigszs1aS/bjFIVA5PbBRXSG3CihBFubdPOJegALvmi6XnrxiShtHE2gZrZJLge2ZVHWoObp2QwOCwuYEF53KZCoYeGImV+luOFVCtxjxG3TtMRuUukNLMgvgC+sGoMQE6BzxJ0HWML7+sQcXn/7KVwkhYRyjGlgVJ+OVUj4YkwggXOowU1a8qWx2kMBxdmyzkY5/w4R0CssM794sIp0QyXPbafZTfk8wS0ENa981KOO0rxlyueMzNUNn38crWYVlp4bpWI4BMGveCrX53Cr2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 30 Jul 2026 09:58:09 +0800 Warren Xiong <warren.xiong@ugreen.com> wrote:

> page_owner_sort opens the output file with "w" before reading the input.
> If both paths refer to the same file, this truncates the input and the
> tool silently processes zero records before returning success.
> 
> Delay opening the output file until all input records have been loaded
> into memory. This allows the tool to sort a file in place without
> truncating data before it has been consumed.

Far nicer, thanks.

However I spotted a thing which Sashiko missed!

> @@ -874,6 +873,13 @@ int main(int argc, char **argv)
>  			goto out_free;
>  	}
>  
> +	fout = fopen(argv[optind + 1], "w");
> +	if (!fout) {
> +		usage();
> +		perror("open: ");
> +		exit(1);
> +	}

usage() calls printf(), which can set errno.  So perror() might print
the wrong thing.

Not that I care very much ;)

