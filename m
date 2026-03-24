Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1E72F532E7
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 23:23:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0376B6B0088; Tue, 24 Mar 2026 19:23:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F12C36B0089; Tue, 24 Mar 2026 19:23:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E289C6B008A; Tue, 24 Mar 2026 19:23:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D31A86B0088
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 19:23:27 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6DEE816016D
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 23:23:27 +0000 (UTC)
X-FDA: 84582535254.03.AB0A036
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 02E8B1A0005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 23:23:25 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=PQzi39UL;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774394606;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7zcA2K8rqeqMAo58tf25PfNL1syujxAWKQeseXJELRc=;
	b=XELj6sWn8wYJFBdhCnDsCqEMUMdlU6aRxxn8iMSm9i9jMqoQVF0V7X2gBhFaSdXxpEopyJ
	YUl5a2C4/3aqAFRqfFVlGC8Lr2pcHeIbsphIdEeoukLYbu5TEt2Ny6L6PU+/W5h2s5U/VA
	WdSIB51I2ni/DVS//S9C5sV3CSs1pio=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774394606; a=rsa-sha256;
	cv=none;
	b=VAvopcHlONlPQVcAYSDtj+QsTs1eO+RdUFhB4/cBvMpxwuKstFZSFIUkUhIi6H8V4oYgLY
	Gq5fH090mDkmyfsSpjDAsJQ7ALHqbK2I5V5MYwnZ61/kIWLQw+lsNXkXNj97ZFXxLOlrIj
	ELIsIIG9yv0w02HtMYoDI8e5hEuWHZ4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=PQzi39UL;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5064960120;
	Tue, 24 Mar 2026 23:23:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88A87C19424;
	Tue, 24 Mar 2026 23:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774394605;
	bh=GirE4UWJ2LcK2wAzlGa+tmQTxh+/DadBCRMtX6wLQFQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=PQzi39ULuF7qCf3+iwmKHcywjTfN2jiKoaYaOR4lgOFzAKRAK+thutR4Ur1XXyVUF
	 wPeb6A1Ckbg9FaAG1ow3/U2Dqq6XVvBIpvQWsKMwp9ruz3yALSfSfrS3glnJ9lP4Pz
	 kM5CmATBipFDUV9C9xBk0Y8HdgM1U3jFGQ2IB8Uc=
Date: Tue, 24 Mar 2026 16:23:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Audra Mitchell <audra@redhat.com>, ljs@kernel.org,
 Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, shuah@kernel.org,
 usama.anjum@collabora.com, colin.i.king@gmail.com, avagin@google.com,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: Fix soft-dirty kselftest supported check
Message-Id: <20260324162324.6efa49422d145afd4dd37dda@linux-foundation.org>
In-Reply-To: <a4fb1d56-8c10-46de-acf5-9a00ce0db4ad@kernel.org>
References: <f7fef55d-4334-4d1d-b6c6-b409fea7e2a1@kernel.org>
	<20260320184010.759461-1-audra@redhat.com>
	<20260320184010.759461-2-audra@redhat.com>
	<a4fb1d56-8c10-46de-acf5-9a00ce0db4ad@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: wzp7qabghanmyjn89s11bzmfuzwdww1z
X-Rspamd-Queue-Id: 02E8B1A0005
X-Rspam-User: 
X-HE-Tag: 1774394605-426047
X-HE-Meta: U2FsdGVkX1/i9SBUhNvnbMpMwiYIepFfCavkoV30D52IEEit6ALof1vfvhb4QTcLYV8nd/Fczip/PB8ZhDCJD5tTMMTlfHHm0tVWiI785UyFuQZiKgfpuCwoRs7Kc56OUPT4PgqzRxPiDTVNgzE4T3Mk4Fs8Tbgp4655zcGi33Wxji0PRwgOnffw4e8NGFo4huruTW1n0MF94bnPZDjsEoodIwQMA8sN9eIrXuqseEzgrs+FsTFhCvCcE1swYIRYPTW1TbVPmrvJtGljcNwM/CI1g5FeMPZgHCewxjTjtaE3jY+nraQfyczxeOL+3StPT1PE0Zj2JHtxQLyA7zeJrf6BFQ20JZgDRyfI4zDY2hc7TXeColBD9NDlKu7Q9d1fEuIkJljEnE7807Xk1GAZqfhfmY4C0YBXCLZKTigk8zlwFuAmSIdi2E+lZOJXaUsc1tfsLl2jRwMLi48EiRDptZjqXQOmtsediQoj/f1QkYE3eQdhJUjTaUdrKmAh0Wx7HNhiy/h68HJktKwtidYWXd+UFkPvtG76OOmh8bxp0/KRVSwwxHCevi5lcFRW7CNSe7pHLUNTXU/kXxWyh7cuFCTHlAGabvbj/scsqANkuez2g89U//tVZA+NRalr3AWoKb69SE2fzo8fe8sbwPcdqBQBqL9L8Ik/umd+Q4X826ewS/RJMFbP8qFYF/mUhV3oxxaroCyoTjkIa930jsVcFWEl1sJJWHAoymaD1dK5wURk/DwL4Vwr1I6KNt9DaV2W1GbhHmLJ9W6vzWx+ieKAenFfjj/JjwsKTYqLXqo9TG4sbnmBAASS0Y43y0/SOrcR6qkTYTT7KyX//aSG0mCQNQtlBEutJUnmM+nADxsHyAM89q2dhSCCKSuc7rQ6j7ANn/d1fvmyJRKXetvOxdDWPZxfJPQUN0D7K97xRfzNeP7WkUAGuJg7puH+ql0vef3FfwCpB9EkNvhwgFmCDJb
 frznZhIw
 fxRS+gMhDwWc3P1sdH17XEzdrEA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 23 Mar 2026 12:56:33 +0100 "David Hildenbrand (Arm)" <david@kernel.org> wrote:

> > +		supported = __pagemap_scan_get_categories(fd, test_area, &r) >= 0;
> 
> You have to cast it to a (long) first before comparing, like we do in
> pagemap_scan_get_categories().
> 
> 
> Maybe best written as
> 
> 	long ret = __pagemap_scan_get_categories(fd, test_area, &r);
> 
> 	if (ret >= 0)
> 		supported = 1;
> 
> > +		ksft_print_msg("errno: %d\n", errno);
> 
> I guess we should drop that, was mostly for testing.

