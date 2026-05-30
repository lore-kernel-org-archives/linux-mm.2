Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14E3ACD4F54
	for <linux-mm@archiver.kernel.org>; Sat, 30 May 2026 00:34:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55D856B0005; Fri, 29 May 2026 20:34:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 535866B0088; Fri, 29 May 2026 20:34:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44BE86B008A; Fri, 29 May 2026 20:34:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 391CB6B0005
	for <linux-mm@kvack.org>; Fri, 29 May 2026 20:34:52 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BB59AC11F2
	for <linux-mm@kvack.org>; Sat, 30 May 2026 00:34:51 +0000 (UTC)
X-FDA: 84822215982.15.F1CBD6A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id F377B10000F
	for <linux-mm@kvack.org>; Sat, 30 May 2026 00:34:49 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=tgEHl9t+;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780101290;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5dbhBDdd/DrGeu/5P9odXdozxmwXWM3YH9wJqvuZxCk=;
	b=J6QTOJOGY5PW16bmMXjXOAp9oq+PomWSRzOxSHxR45s0XFUQoEBhsDeYG0jeB3JWIEa2Ae
	hyL94uGw5bRT4iQ1VzfOviEVp7wxedVcKbHUU6wN2vaqz2HsJ+ivNjoNAUkGSA7bz8sJUX
	3ScyWzRdHBgYi58P/2OWDTC08kQ9ogg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=tgEHl9t+;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780101290; a=rsa-sha256;
	cv=none;
	b=A9NN89zunmq0OucQEUhjaAPRTL2UCA9oMilH7NFQ+JQjkl77XvvH6ahjGNykOtREH/noUP
	kY5b/MUoUxPHXy8kKlgZHvMoG3MIqEchvHdmoxqBYk6ZkAa+zLGoX5tXTAMZp9vpuErPCI
	YG5Zz8fxs3ppgsMaI7s/p3LNRAEwn14=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5374A60103
	for <linux-mm@kvack.org>; Sat, 30 May 2026 00:34:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFD5E1F00893;
	Sat, 30 May 2026 00:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780101289;
	bh=5dbhBDdd/DrGeu/5P9odXdozxmwXWM3YH9wJqvuZxCk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=tgEHl9t++bTNDAYL6ECXfbyjXU0A1XVg6g9Mu42a0kRX2QrIDetWRXsYJq6OuUC+U
	 bfL0aqJKYMJ0YOGofHKH0rGJ9A1Pq4nUWaeAWJ+9d0fO4hRUcmkCpKhd8HBBTvbOXE
	 IGl0I0l0L73YyFh9/WW9uVmq1y/WFKpKFo2VbF2c=
Date: Fri, 29 May 2026 17:34:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, Lorenzo Stoakes
 <ljs@kernel.org>, Mike Rapoport <rppt@kernel.org>, David Hildenbrand
 <david@kernel.org>
Subject: Re: [PATCH 0/6] userfaultfd/pagemap: pre-existing fixes
Message-Id: <20260529173448.40a37785ecbecb6868fdd6a2@linux-foundation.org>
In-Reply-To: <20260529172331.356655-1-kas@kernel.org>
References: <20260529172331.356655-1-kas@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: c7kod8dci69ncxhpu741mdxqrrt4ajow
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: F377B10000F
X-HE-Tag: 1780101289-298631
X-HE-Meta: U2FsdGVkX1/+Z+Hp4fbRWNQrdEldAwKF5ja4yJyN7FXL4Cd6Fhs9Xod5+8NHOaUDzijVfopctKUAUWU9n5E9oa3WsLrHA0UqH8PmuNabmMHaVqS7bDa68NOhffV6DcCk/RqyvDbjyEaq8wM6DnWwDWWqFYgTVDhR3iY59Qg5PT9jbQv9blOzlXVIpI3kkgI0RlbAvX/PU59RRSNk7CXDkDR30gsH/Qu86B29FnvzB0K6ZCsWgDyfojfwFliLoi8ryTodZ84x4ue75KAaK/KF44v0wG0/SAL2ROjAoiH3lrRpSo2j+Ia9Au7HYpaXiyOBoNB5D5edYeohxiJ647wGzzr7KQvnmVR56IGD9SaXbIySs7Us3FgJSgOrytdMk9IWwPCpMzPVV9CzLLKuFDeWKgdjadZ+/xNFzG6oY9A/xW2vX129H9ma4e2wpfRwR0HyrBPxmhvZcHY3KxbsRclzIAxH30+4SF4H5QMd3PZR6+BxZjofnDr2JhByok9dtHXRDfb6VNbHvNsXO171t4ZhnNAh11KhcOSgggip5j7/UA9fbkeS6qxAHKa2G29n58SO0g38gsR5Qt2HLk1P47xyJ2wn8ByPxiAV3dVO6qL/ZH6NYgVl3Kzjt6hUwjfMb8biII6LjyIRCizAQfqsuOS2pc7K98Ddi08KDIxIa3l5dMXDeqZg65l8BX0k+9O9auRpKoGHD197Fw48ENWX2w02Un5mgO8gCMabthcGobXOFWNU7cOuOm/MXCtAuCP18oKgB5vIjkU2d9Txw1QqWsdyhwOS3Z4MS61lIy9qO0lraisENkyxLWB7uidbF7xfMHWcZS8ZsJ12devJxGVwMg8CdyCEUUMjypkG20od4LX2YGUjt2kUjk2IpGJ3Dapk2ENWoN8Kxiu5W/NNtdhVdguNbO7VZgSt2X6RwLmP8H9TxjpkCiyYZrcZwfcwLHS+Fux9MVNoJUWl1tmmTAxamfq
 j/o3WQAe
 xB3nYwLDi/ao9SSVoEJw439zBYt876Ioaqjwf7exw8YFXELO8qzAJ14F6Yn6fcrk/V/yiEejgSy/cmiQDnSvB2E6Lrg8etxTL0yqojarn4yFGVF5013heNLkKG+dEkOd9Cgi29zHM1pkjbD1ko79FmmwHZ9iOrmgus16LJ8rTmh7hrrTDTbzk3tRapp3qWrrmqS6VgXoFt/0tRPpokvsun3g01zRVNvUVzAPRO7P3Tf6NYphBgMNlTTS7S1373NjWY2ztTvIGfL6RSWoAsJPcLDB74+WVY2NCSU7dYv98zk/nJ2lRYJ5BFasgBVcr+OWoHDA5rZr6e7Bwmv+iJKGZMPxb/HOCe5+TdAUMdwizQV5brmkYapsHhlwFrJsTFDd87vAYTJRjxn9KE/w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 29 May 2026 18:23:24 +0100 "Kiryl Shutsemau (Meta)" <kas@kernel.org> wrote:

> These are pre-existing bug fixes that were carried at the front of the
> userfaultfd RWP working-set-tracking series up to v5 [1]. Per review
> feedback that fixes should not sit in the middle of a feature series,
> they are split out and sent on their own; the RWP series is reposted
> rebased on top of this.
> 
> All six were flagged by the Sashiko AI review of the RWP series and
> carry Reported-by: Sashiko AI review <sashiko-bot@kernel.org>. They are
> independent of RWP, apply to mm-new directly, and carry Cc: stable@.

And...  this made Sashiko point at other stuff:
	https://sashiko.dev/#/patchset/20260529172331.356655-1-kas@kernel.org

I can't figure out why four of the scans failed - "View Raw Log" comes up empty.

It's concerning how frequently Sashiko is finding pre-existing things.  What
would a full scan of mm/ tell us?  Gulp.


