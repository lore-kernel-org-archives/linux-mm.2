Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63B3DCD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 12:32:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 846D86B0382; Mon,  1 Jun 2026 08:32:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F7026B0383; Mon,  1 Jun 2026 08:32:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 733E66B0384; Mon,  1 Jun 2026 08:32:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 642586B0382
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 08:32:04 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 019D990739
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:32:03 +0000 (UTC)
X-FDA: 84831280968.08.9DDF7FE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id CC3F3C0012
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:32:01 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PO2s5Upn;
	spf=pass (imf10.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780317122;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+D4PHK+G0v+lkjMJEe4hiF/O0fl6XamxHZ2AeM2qWhQ=;
	b=EJC0fvpSIRJh1XoCjl5XrBA1f6EUB67u0JqVFNoP9gXvdeFihzvAFh5mXwAUGYG5ijO71C
	4aeL7H4Z1N/IBg6+zYwOlunp7C1wJ6WAionwJ5RlyoQs29HmDGJh7FqLeltcIQ/mhRxQhm
	lWkOHO+zuimSDtGde8A/4mFp9o/5Fl4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PO2s5Upn;
	spf=pass (imf10.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780317122; a=rsa-sha256;
	cv=none;
	b=bPA9ZIusaPT6SCsj1upNevFCcYu+llvGz2JApkwII+IUKDg756WIVOVHfDKf074GjzllLW
	X4mwxLxdMwXzK4r0bTEUIPN1qQUHiofdqY6mJ6Gi4fbH37SXMn8u/xL7+7PxMeTIFxOJ0r
	b+duFIxASLgTc1jttXyNAGioguGJiis=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780317121;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+D4PHK+G0v+lkjMJEe4hiF/O0fl6XamxHZ2AeM2qWhQ=;
	b=PO2s5Upn5JF7opl1MQpU8eRQs5ZMZTGE08X4v5OSOLEecLQYOt6iJAoGBNDjn/V9S4+pNa
	gNvMx+e4ZRLrlUJMu+u3BPBHp8tqF6F5S3YuOgXICqjDcs1G4vQk3Odk/ybukV79CmyT0e
	hrNc/R6Qg8KDv5mJxPN0+INu5SVTX+M=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-135-mRYfuuFhM2i8ajN0B6e56Q-1; Mon,
 01 Jun 2026 08:31:55 -0400
X-MC-Unique: mRYfuuFhM2i8ajN0B6e56Q-1
X-Mimecast-MFC-AGG-ID: mRYfuuFhM2i8ajN0B6e56Q_1780317114
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CC7D51956060;
	Mon,  1 Jun 2026 12:31:53 +0000 (UTC)
Received: from fedora (unknown [10.44.48.10])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id A342B1800577;
	Mon,  1 Jun 2026 12:31:50 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Mon,  1 Jun 2026 14:31:53 +0200 (CEST)
Date: Mon, 1 Jun 2026 14:31:49 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Christian Brauner <brauner@kernel.org>,
	Jann Horn <jannh@google.com>, Kees Cook <kees@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2] mm_access: simplify the security checks
Message-ID: <ah17tTbarD2dKVWE@redhat.com>
References: <ahrsfJE3NkKjShEX@redhat.com>
 <ahrwUGytgulEwujN@redhat.com>
 <a8846033-094d-4e1c-bfba-f7f543944709@kernel.org>
MIME-Version: 1.0
In-Reply-To: <a8846033-094d-4e1c-bfba-f7f543944709@kernel.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: xjtQhgAW2GIJIT7s-KKFIJaTZNzMFxitXUjWunfZedk_1780317114
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CC3F3C0012
X-Stat-Signature: u3euogk9wmn57wzkw9f1i5wx88wonqos
X-HE-Tag: 1780317121-685734
X-HE-Meta: U2FsdGVkX19rgRWo4cGkoTKZAgUz3MYZL7CjeKH0Wo4mjbAV6Zchntr8T5Sh5JAiQ7tzIJRXJY/8R7PJGRvbtnOasGH3NdMOITs5BdQHqzdXHCK3hg219wtxL2SalbTC/1J+hGCs7f2WZPawBwpzTu57REefrVRuZBwm6kjdrahNPqGbqEhcgZo5UonbNeSmT9151T6XsTzokzzmx9hJ8egL3HTqmsnTAaAuDROzHvUHQeATJWmYxDZfWdHHrbcnljbOC6WePAbRbuaJwR+GSh2qVYykIxK+RrWroQn1uG3YwJFwudR+o4O7eBkUIMoLoAes0LNloC7LtmUJgqTebEI1YXyUGHC/WkQBw0L5EzhJ21Od4PclYwb7zzQMCM8YhQVLxjkLuPbuOjbMz6Otvqgloo9hMLTz6pRjkKRgL4hT466FrXqnwUVHUDVYVqhn8iZ2IkQj2V6e3swl06xz2e8OzITxxTKko/eMWmgmzV18MxAzvC0jecAKGhMSgvmkMMO5bHSzTH7b40wN0od+ZkFi3ZUQUtAgrSmKZg2L7Zcn/XTgfH4eD8l8DGcAQLvlisvGmFsWkckQ5v3Z58kqAX4G5mRRVJV0KbNJ0VxA3D5sTUWs2ErFhfansuI6HJCST5l6AZ1WmuIP1cbdI24jh/R6zHfAdJV1wQHL9n9bWxF/QrpyxFVZoLZx44K33RkH2SaPWKQlNQT63SKYw+DEf/1buQpCn4NXgrcZyqA4oN+iSBsu4FYRnZ6gsA4X4YDeLQ8eZXAJqirH0mnGDHVtCqoxh21R3bAbRzCBWrEIUkQPGJyjPVvj4tfblwkkDv92FuDu2y5sr+e+U3FRmLGkIZQ+p6qS2qFqZLUy3iSkveOKJ75FMbLSsp9tV3pLJ+DGDXrewmUgZ0m+pXdCCQyZN8wgybIGC4ymb2n0LjCt06gQjeCUJ7s/FxrQOTNW29YZhOFpCxzKiGW2oARCZ6p
 5HSZN1pj
 YlMpj39JLSxvEux5ruvWvXGO678yPA2j5YtmU6EwZE0Jf227UZVBZveqNvF82Dvc8K2YvTkPma89EIjbF8ektp0K9n5ve8SjX+w2+v8tiE9yuowNjtZNT7iTtzKIy5CK9HEkSWWit5J+sbr2CyOeslVb7aIsu72mcAOvUkFbDUd1NUVVWGd++movcBqBNM2TVGCn0bzgVIahMBIkJPLcZ/gRssqjCBVd2VOCHW47rE9hPelVJuvxRce1Y7bMtVeQkk7kmmoJVE4LJGe9MN9/Veu7vOWY5rszfGHywPuZ9qFmj1MVWvQJM3XstOcqoccalhVqn3B998EzgA0kx32g3jkM6KYiOtTGV11J/pL3F/s/z/l83gXOO99O+GrgMMD+nKll+SxlZK3nsUEU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06/01, David Hildenbrand (Arm) wrote:
>
> On 5/30/26 16:12, Oleg Nesterov wrote:
>
> I am not sure I spot the "simplification" here?

Ah, then lets forget this patch ;)

Cleanups are always subjective, if maintainer doesn't agree - forget it.

> Looks more like an optimization that makes the code slightly more complicated.

I don't think that !task->mm or current->mm == task->mm is the common case.
Just the code looks more clear to me if it takes exec_update_lock only when
necessary.

But see above, please forget.

Oleg.


