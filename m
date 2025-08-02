Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 587F1C87FC9
	for <linux-mm@archiver.kernel.org>; Sat,  2 Aug 2025 03:53:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD00D6B007B; Fri,  1 Aug 2025 23:53:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B81236B0089; Fri,  1 Aug 2025 23:53:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A96D26B008A; Fri,  1 Aug 2025 23:53:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 991516B007B
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 23:53:28 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id ED2FB135196
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 03:53:27 +0000 (UTC)
X-FDA: 83730447654.03.7B2F093
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 58CAF100002
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 03:53:26 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=yPITqYAp;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754106806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5Iwz2/QbMuVNf6m/aMmKX6JmYwcKzO/hW4LBQqb77X8=;
	b=uKF3jRi1xNTAnLSd+E2iOS7ZjVzAby0LWBMO4eQuoDwssoPOtayD4WcL9UdX3cWMC8qD7Z
	82nePTVpPeb1fsAFA0Kz2qrcLiTEx8/FTlN7czGxbrUPkLYz6r9lxMa5ZixGV7hxAF4vbu
	qtCKzQpNdBodIclrv4U08qXiKMVNAB8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754106806; a=rsa-sha256;
	cv=none;
	b=VjB8XJsfOZ0tJTE2TPfQ/g0xI7XNHTbXoJHdZ2rqVkLyyqZus2v2XQnlkrFqbI5r1sMEA5
	jFRtQo3C5HNqDJjLh5rN/bwtHG/uUsmxSuu8rwU13/h3yKbgp+/tsaU7SkUduXxubp+MGf
	xT85dPmnZBNI9Z8ThZL6QEm0Lijwg+4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=yPITqYAp;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6F3F5600AE;
	Sat,  2 Aug 2025 03:53:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91322C4CEEF;
	Sat,  2 Aug 2025 03:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754106804;
	bh=xNpaAbYMIRCCf6qEC+M9c6KCuXluSMu/QNeteQuQbcA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=yPITqYApklWsg7GXdNRWSYrT42/vqoyceqxpRWdnMClXlwluh0UGWLrcLU+kR3sB7
	 rIlPtIibUq0cN4oBa30v+x2sfpyNUz4Dfy4c6m8LvXLq7O9M4cySB14QVonTSqiofo
	 S1K/PMv7uS3ObPup2jZFrYazE+QhrFAs5AIBnReE=
Date: Fri, 1 Aug 2025 20:53:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Waiman Long <llong@redhat.com>
Cc: Gu Bowen <gubowen5@huawei.com>, Catalin Marinas
 <catalin.marinas@arm.com>, stable@vger.kernel.org, linux-mm@kvack.org, Lu
 Jialin <lujialin4@huawei.com>, Breno Leitao <leitao@debian.org>
Subject: Re: [PATCH] mm: Fix possible deadlock in console_trylock_spinning
Message-Id: <20250801205323.70c2fabe5f64d2fb7c64fd94@linux-foundation.org>
In-Reply-To: <5ca375cd-4a20-4807-b897-68b289626550@redhat.com>
References: <20250730094914.566582-1-gubowen5@huawei.com>
	<20250801153303.cee42dcfc94c63fb5026bba0@linux-foundation.org>
	<5ca375cd-4a20-4807-b897-68b289626550@redhat.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: m3ccibeps9kdjghah5u7qihg7n8t5jzb
X-Rspamd-Queue-Id: 58CAF100002
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754106806-478999
X-HE-Meta: U2FsdGVkX1/JPQfZ2wlH6Cz6NpVg4IKLh1rHvwi9rrdnnyRqyGkpbRE/6q2o0zgN/1H7QhSvsGv63pIA7OmGZbm4BnjlX7DUvnIdLqkH88ed3/lwPxSLXaRwyaC//DKYbzfkAz1uN9/5H57vYGOA7Og5PXp+LFo9vaVvL3sZyqBjPdhd1LqIMQIkl8fWGvM6ECg0JmHUi8rvKdluVOuC5tmfVOuwyiiORuE8UJE9gr+z+dZ8yLYPW9RNYuXoLKAixVD/1RVkswj/hjls3EAhMGOzqFS0QPmlBMPOjFNtRXKu28BgrTtBPBxaoa8vM7jzRuVEvzIxyMnr3q9/pBLNHDwjaCebFu1L8rtRkAJ9OScjSR02qMuj5sBRjkDckLfhTkxeh3PCHvZyP/SyNxAmZSoLj2dXCSOmpAtMewXcHAEg467uY3acU81bxQCk1FPrT3wCcxZa5+OVtKR8ttuKwPXZXeCdgdedAhDrRQPbFXJbCo7AIOCVoKYxK+t33kKNf2DhROMUFdb98OioahKk7+oyy6r+yDOvli97YdaWJe15aa2e8So3oG/Qu4UzjBHnG4bRmo2NsCpsEzk5Wf9SXLuEKFXZ/qnFptWpQFrufZTNPJ5Rz7JK5XPLKJPFC/GeCDJgPnPNiiGtSLBRUbsPbSgWQyQTaVDh6KpuQAKmh1srX9gH6odNLN2hoQyltlN6hgjtF2qFDDK6wwbFokT34NjrsJyhCqqyiYtPomjkFTPmgJEaaBOqkKpOhmIHYwXe2ED2gXNF4+R9OWTzW4GZicRuqo0QTOBhaJ/+3GGxcAHQ4dkPap/IGe6k3tnIur8BBaMhxOdP0JbKU5sG2bsGGVZUCPppmC03JHOpqhjqCz+qEi0Ea5e/DR8YBERf2413z2zK30tYvcWYa2RYGAE28sRxuZ5+2XYfCX0j1BPJDAzTU+tFj6+2qib6o9NDOTxVglZnpSnp/rH9xzI9u2u
 G3zM1Xxx
 ox2EfyOxdDJRWDAuVSL9t0vLuvRJYQDZ8eeotRo6PIoNWkA95DE2Rjug26IhftA6dtoY31xg/mt+YiMv8FINYMbAJfL6ia5yohDbjq/xBceumpa/SmAzZ9jE+s1G2tksQU6FkTmQ1yl5g9Zc1NvYsD/GaiPhW7YvL82j2nYM+b6W4hwbg6aEmQO6IECEBxiNAIYfWCoYbFqx785dBFKwhURZWl6E+upEhYWPaWVqRFADeHNmxkf/edHSmJa3tqf+7F6CcNfnRiPGBm/pym38x9FADpulIs/ElUQn5i6RhQOJZ+shHytyw/GNnRgXQSjh1cuEv7Yxn6vaNYfHZJrFOarEgeUeYZnFpWuNDeIUBYTCMBwNMgkriCpSY0cxiGsQAvba2Dxyde/5BBoA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 1 Aug 2025 23:09:31 -0400 Waiman Long <llong@redhat.com> wrote:

> > Thanks.
> >
> > There have been a few kmemleak locking fixes lately.
> >
> > I believe this fix is independent from the previous ones:
> >
> > https://lkml.kernel.org/r/20250731-kmemleak_lock-v1-1-728fd470198f@debian.org
> > https://lkml.kernel.org/r/20250728190248.605750-1-longman@redhat.com
> >
> > But can people please check?
> 
> I believe that __printk_safe_enter()/_printk_safe_exit() are for printk 
> internal use only. The proper API to use should be 
> printk_deferred_enter()/printk_deferred_exit() if we want to deferred 
> the printing. Since kmemleak_lock will have been acquired with irq 
> disabled, it meets the condition that printk_deferred_*() APIs can be used.

Gotcha, thanks.

kmemleak;c:__lookup_object() has a lot of callers.  I hope you're
correct that all have local irqs enabled, but I'll ask Gu to verify
that then please send along a new patch which uses
printk_deferred_enter()?


