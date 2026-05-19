Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 751CDCD343F
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 00:31:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8BE66B00C6; Mon, 18 May 2026 20:31:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3CF86B00C8; Mon, 18 May 2026 20:31:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A52A16B00C9; Mon, 18 May 2026 20:31:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9570C6B00C6
	for <linux-mm@kvack.org>; Mon, 18 May 2026 20:31:24 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3B4AC1C00AD
	for <linux-mm@kvack.org>; Tue, 19 May 2026 00:31:24 +0000 (UTC)
X-FDA: 84782290488.05.309E959
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 5AF97C0011
	for <linux-mm@kvack.org>; Tue, 19 May 2026 00:31:22 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=C6+dbiLA;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779150682;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mdKd2ZxMxKa3UG7T8P5tytFob9zTlCplwzDD6FYjjwY=;
	b=1PxFuLzfuaax+zbc0zuBDEswO47qvVeKF5jstFtzdnWLfJsSYsBE/nvH7meMAvpkSBiuDl
	uvWm2GAlU6xNsRLaL1wfU1PViQmagzWkUNAVZjOeaONfIzz0lsrEkMSpZch8fJCvCFvYE5
	TI6QrLukACpZYXRyZrAuszWS4/mkps8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=C6+dbiLA;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779150682; a=rsa-sha256;
	cv=none;
	b=jXCDARbF4oxoH4/o3qlV6NShAhYcpjjZxRc+6wjnkopEGUTVZtohWLpw/xXCA6/lq3uRyY
	aasHmDL8C4YsjXwjOrKOcQuMrlqevoQ2PY/5CMPaAiPzrbNNWGYe/lYkMqfFND0geO2BY0
	XGi4AP+sj1BDtliRMYVMOX4DXUqM4NQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 02569400FD;
	Tue, 19 May 2026 00:31:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B115AC2BCB7;
	Tue, 19 May 2026 00:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779150680;
	bh=Hn8nkfC6AtTfS13eIodWwSfN5loWrhpApSyYRHdiRas=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=C6+dbiLA7Qe6C0VhGgzhrJtQCs/262xxPZUANDJfuzXdf5siA85xk0If9yuFKEStg
	 JNM8zLf2+9wzRszYeOSqj6gJWs/TZFkhPTp+jsjM28txbYbPLzs+VTomvIr1FBeb5e
	 QnXYXs9hEmJw+yiIH2VrSFVQO9NUCJT9ECzDRppg=
Date: Mon, 18 May 2026 17:31:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Byungchul Park <byungchul@sk.com>, kernel_team@skhynix.com,
 ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net, kuba@kernel.org,
 hawk@kernel.org, john.fastabend@gmail.com, sdf@fomichev.me,
 saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
 andrew+netdev@lunn.ch, edumazet@google.com, pabeni@redhat.com,
 david@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, horms@kernel.org, jackmanb@google.com,
 hannes@cmpxchg.org, ziy@nvidia.com, ilias.apalodimas@linaro.org,
 kas@kernel.org, willy@infradead.org, baolin.wang@linux.alibaba.com,
 asml.silence@gmail.com, toke@redhat.com, netdev@vger.kernel.org,
 bpf@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] Revert
 "mm: introduce a new page type for page pool in page type"
Message-Id: <20260518173119.f3348ec4cc66b793fed4cccf@linux-foundation.org>
In-Reply-To: <agruFy80Ag3uIab0@lucifer>
References: <20260515034701.17027-1-byungchul@sk.com>
	<agruFy80Ag3uIab0@lucifer>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: fk948ooj5ahpdx71shxqsx66e7amcr9k
X-Rspamd-Queue-Id: 5AF97C0011
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779150682-609597
X-HE-Meta: U2FsdGVkX195ZYuWia2Suq33ZhBC2BDaRlNjWHea1mtavWslanzZ29m4yd8Jns33/QaO4pS5AniZnLXExaIWFsL6W+L57FrdRj7dL3DeU9hSZKb8KUnx8T8NoZiRXk2KBRfa53HuvD02lnyFL7MWD9X6pmHMIp9jCrGxDUKq0CLtgvXx7JG3nzv53s3EN4ZkOW47syeYTFiTTsa4RAegRsNcITq5Qstj3BStr6EyC7MewPeOswmov/JXWPUB3tCpoDNIeC6crTidsDu4VEo2Vwn/c9atJvHXYEaiLRZpOxLYIQdTt6CTD4zG5noXVEuoAv8q78EYhbNdaKqRRKyyn4vvtf1zIuhwGizi330bDDNOSOsler4J4F1zQcpgfFcOSp4HkIHUctYVNbyQ0xL0/UepZ8+9ycs3dj6FO/lAgmKdgkh9yUhtClpfY3x4AAM35jZBa9kfmGFJno0jYRZawSWkeC8PzKkxmRWsxbV7kLskk8bRgYsNxTgNoK7gHaZ66n3QhmnPGwj8wmNCNueVQtldypDkRs7IW/HUydk0yLARsQG3iPNv3Zef8fbDcUfZgO60pjOfKR+F4jb2usaCII3Ywy6PJW35Kv/osGypRzRUQEooWGMYcmyQbXEH6iru1hPnOPMoibOw0GdzkHDejc0QO7ZBUQmciThBYqKhcYrk2lElZm+Y+clim4ZExU93nSW1SZYtVO5+2O6xTYgFlDCae5N568+D47+BaFBJpwB5t6XW+Z3LxvEOfFRwAZ9VsHMOYTq4op0Mnh6lV1SMavwfpjIT/KysZMuj4RXLqT62y5p5cv3Bj1QpIrB1qPsRILSpDgITfYvKfAPurmW6/nP5Blo8W6AYRfDBHtiE67fNMJs3WAMduzr0JpHBZviNKaCfug+xirF4SODyXZ0/u/Vhu5EiRmGpl5RDGCjfC0goJlxAuhtJpKDCmtuXs6rq8Zzy0ZG2spD2Y2m6w3Z
 t6dfc2+N
 MiJ6z7+s7ZYH3rVa2vfoX9rK5+VABV2aYBKaWjEPLbo5HsVlDXhdMZDZUzSVr3EeQ5yEZth+GCxqgj+8DlWN7AG9E84SQlEqxadhG8nq5h/s/xlTAIHP2Z4s2mXeG4cofWzeS0tJSthCwSQrLjItW/1NlulCaKd5R/EcDJe5XofzoU7nK9OHAXv6CmPZ9tC9lZL6RholXakPu16eCipLtjPshQj7MQMf4PgwyVK7AMUJ6cAvD9t2cNndMfbSyHJLXhZ/JXon06i9cUT+/We3+kBCEAr7eFW5MmFHsJAiFqVAFyOOs81n6WXvjjM8l9Ryeag/DuO0SKu1QoG9QvEsNSmIEXH8cFsRG2uLaxilnXNSuh+pLfhWMnWohBZDyRPy8NiF3iJwtYtO5wZVczw8XgYuStg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 18 May 2026 12:00:11 +0100 Lorenzo Stoakes <ljs@kernel.org> wrote:

> Maybe worth putting [PATCH mm-hotfixes] just to make it clear this should be an
> urgent hotfix?
> 
> On Fri, May 15, 2026 at 12:47:01PM +0900, Byungchul Park wrote:
> > This reverts commit db359fccf212e7fa3136e6edbed6228475646fd7.
> 
> Maybe 'this reverts commit db359fccf212 ("...") and partially reverts commit
> 735a309b4bfb9e ("...") <details>'?
> 
> >
> > Netpp page_type'ed pages might be used in mapping so as to use
> > @_mapcount.  However, since @page_type and @_mapcount are union'ed in
> > struct page, these two can't be used at the same time.  Revert the
> > commit introducing page_type for Netpp for now.
> 
> Yikes!
> 
> >
> > The patch will be retried once @page_type and @_mapcount get allowed to
> > be used at the same time.
> >
> > The revert also includes removal of @page_type initialization part
> > introduced by commit 735a309b4bfb9e ("net: add net_iov_init() and use it
> > to initialize ->page_type"), which will be restored on the retry.
> 
> As above maybe mentioning at top of commit msg, as right now this reads as a
> pure revert of db359fccf212.

I did

: This reverts commit db359fccf212 ("mm: introduce a new page type for page
: pool in page type") and a part of 735a309b4bfb9e ("net: add net_iov_init()
: and use it > to initialize ->page_type").

> >
> > Reported-by: Dragos Tatulea <dtatulea@nvidia.com>
> > Closes: https://lore.kernel.org/all/982b9bc1-0a0a-4fc5-8e3a-3672db2b29a1@nvidia.com
> 
> Fixes tag?

I assume db359fccf212 ("mm: introduce a new page type for page pool in
page type") is close enough.  Both that and 735a309b4bfb9e are new in
7.1-rcX.


