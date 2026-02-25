Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60EF4FD374E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 12:56:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 947726B0005; Wed, 25 Feb 2026 07:56:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F55C6B0088; Wed, 25 Feb 2026 07:56:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8011B6B008A; Wed, 25 Feb 2026 07:56:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 694766B0005
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:56:07 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 18C9CC2190
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 12:56:07 +0000 (UTC)
X-FDA: 84482976774.29.7C42BE1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 105EA18000E
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 12:56:04 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TPAKu+WD;
	spf=pass (imf24.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772024165;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cS4rdgedqlmqaWfxgVDuJfWd57QxOS/bBH2dVx9uI38=;
	b=HI1WsUHNJLZdNfZ1rlv0E+21Lus9c5Pa7S4SGpfq+fEObs4S7N+Y0+QeNnnkaKeVwAXBLm
	8Z+CNw8AE0/TiMdhotDPyD6QwmsQVVyBhXWiI//8ByEgoHHuP4Ek31qpILfcJToCaxowyK
	JY1y6ANB1ebrAUyIVCwkrYdUV/wbOes=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TPAKu+WD;
	spf=pass (imf24.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772024165; a=rsa-sha256;
	cv=none;
	b=1GU/lww3u4JOaYmZysbum9yGlU5RVZxYupts6xLmEJVIVVv9lH0jSM10DVbWYeguzKFpZu
	ipuEQlUrdylok03xh6ovtIzyOjseGwG51yyN8y585Bu203D94qiDHKtPDQMjnEOuHgyhNL
	mOTw/om0oIExJeOf5H53MXw1sf8d/Mg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772024164;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cS4rdgedqlmqaWfxgVDuJfWd57QxOS/bBH2dVx9uI38=;
	b=TPAKu+WDAIt0r0E+vOCL+H6/dCimNM2xed6F3DIXJOzfmvV87e/7cxqQHe925w9js56kPn
	dvhX5StwVqHRsc60Nu9I0YDLXHAzNdcouABQaqC7X/VOIuqyDpvEeAS0nbu7H/hGqvF9od
	Nx4O+o9X+FSYvGOffqBao3QfmHwWAwo=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-644--4gZuI3ZPsaweAwChCvgwg-1; Wed,
 25 Feb 2026 07:55:57 -0500
X-MC-Unique: -4gZuI3ZPsaweAwChCvgwg-1
X-Mimecast-MFC-AGG-ID: -4gZuI3ZPsaweAwChCvgwg_1772024155
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 81A9E18004AD;
	Wed, 25 Feb 2026 12:55:54 +0000 (UTC)
Received: from fedora (unknown [10.44.32.38])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 75F603003D88;
	Wed, 25 Feb 2026 12:55:47 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Wed, 25 Feb 2026 13:55:54 +0100 (CET)
Date: Wed, 25 Feb 2026 13:55:45 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Cc: Christian Brauner <brauner@kernel.org>, Shuah Khan <shuah@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Jan Kara <jack@suse.cz>, Aleksa Sarai <cyphar@cyphar.com>,
	Andrei Vagin <avagin@google.com>, Kirill Tkhai <tkhai@ya.ru>,
	Alexander Mikhalitsyn <alexander@mihalicyn.com>,
	Adrian Reber <areber@redhat.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v3 3/4] pid_namespace: allow opening pid_for_children
 before init was created
Message-ID: <aZ7xUYi4VFTxWzqG@redhat.com>
References: <20260224164852.306583-1-ptikhomirov@virtuozzo.com>
 <20260224164852.306583-4-ptikhomirov@virtuozzo.com>
MIME-Version: 1.0
In-Reply-To: <20260224164852.306583-4-ptikhomirov@virtuozzo.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: Qw7QoRdakB6mSUgLD2PnsJdRvLppujRHHsYS7ZQzHDw_1772024155
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 105EA18000E
X-Stat-Signature: 74eepaxmb6xfj6ro4rggugiiyoomq7u6
X-HE-Tag: 1772024164-332584
X-HE-Meta: U2FsdGVkX1+ZhlNfPqxvqyBPi48//YMIR9daD+lxc2SkXS7FWHtmcJ8OCQWR+s2owmRqkuh3gcpvZ4axmrryUfQqprQkLBfq7m0H10pY1nwPioufpca+h8iF/p4ZSKOVMxPmaKPtZvzzKDfujcN2bNA1rWTVQNH2IpI4bhwskTdXloZA9Uqbb61cJaANAe6e8rLRGjP5i3+PFpGxAQNY2xSTb8ngbGk8TdXq/oY+hVlefKNu3BYRUSgxE2ZWWRN3Xhj7UZ6ZmRrn+NS1X7z0S3JKVOQRtnlw0b6G68SmNhXvxelyuIIlW6GyHApruZdV4WugroPa9g66Nu9wtk08Zj2uP5sV0NWFu+mE98XBl+SqbOl3U4Oa5uCxEAg8Q9t2AvEFn3v+Wtugp9gMo2PoPU8v40u0ttgnpuiWMkHT7B9rXvMo+A0+O/ySEN9CbxBc8ln96kaOaIcY+0sWp77binqyqN4zBIkXEdOcOeTjlDWQxBwpIQanW4tmFX6u8irY3JKPosgQHSabG+z3oGr2Si5KGr8dH5ka5iWghjeOYYnCny8f8B/hOG0Py+VuKfSQYVIwUadvkWF+LQqXFolKuzNGneMEEc2z5wqycuDPCtve0Qy33dZw6lmpAk121fUI3BgBrHsXYoAuOPvNEKqQN/3cjEfnGScg5YZF7zqZ9TH8moo2io0DlOkSnnaXdemSIxNDx17gqyzSYH06uz2N7MBqqxE7TZxeF4d/Ea/HySV904IQZmtA45zzyEBCbdEucMDV4MJTgGASrwcZogSoNKqCqgbNJB3AUUsazyhtQe5onJ+rntDw8uQOsKpAVaMtXcm3D8WmcYWoo7B2D7wGHWN953cDRRYruLjFW4bZgWU/MiwRdaRQwX5mgHSCb6G3aBewNLTAyh2FO8bbslvQ9QSmq+UbBB9OAdaSyLxyYkK/fk2Xh8Ut9yiqD1lAl/ytxijdvV0hLQrytxonzEl
 sTZgk/Nu
 jR9T/4nPOjqXqasJm2F2ox2wgYWDKVEY7bS/HgRFCyzz2GrHq0Z0AKumhj15Bc43bGCypLPNsFmm2JN0CDYt34okO+iGRBZwRfQnqqnbU40jPvFu7bPYS4IE/3flnKEXIHyCcK7jclymO1IYFAUo6bhFkiUmPYRWRnpQZgsAUO/VxVUDxSkH259LoRWsg+Bw7LZ35SStl8+/mr6UqYd4IItZvrtXEYzpR3GmynzA7Oi9LaBuL8W/QFjNq1gOJx/ym2TTrsOKWaysDFvsTZJXiLTRax50Qnr/weeXnm4Mt13LyzcNzUoHTQpEUMIyd0fXBi50W+FJvpLFJSzA9EeXHddP+ZZLNaJAYAuL0TprHm34N4gB9qpMmX7ciGimRgGnPYl9WvbDjeE9lR0nxfVv2JBIJvYIkMwL6OBQSz85kp/h7RrI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 02/24, Pavel Tikhomirov wrote:
>
> Note: I didn't find anything in copy_process() around setting the
> ->child_reaper which can influence the pid namespace, so it looks like
> the pid namespace is fully setup at the point when init sets
> ->child_reaper to receive more processes. Thus tasklist lock looks
> excess in pidns_for_children_get()'s ->child_reaper check and it should
> be safe not to have it in the corresponding check in alloc_pid()
> (introduced earlier in this series).

I think you are right.

Reviewed-by: Oleg Nesterov <oleg@redhat.com>


