Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 823D8CD37B9
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 11:03:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C02386B00BE; Mon, 11 May 2026 07:03:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD9726B00C7; Mon, 11 May 2026 07:03:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B16646B00C8; Mon, 11 May 2026 07:03:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A06846B00BE
	for <linux-mm@kvack.org>; Mon, 11 May 2026 07:03:41 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6C7191606F3
	for <linux-mm@kvack.org>; Mon, 11 May 2026 11:03:41 +0000 (UTC)
X-FDA: 84754853442.05.F501D41
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id C2ECD80007
	for <linux-mm@kvack.org>; Mon, 11 May 2026 11:03:39 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aJNb3rG9;
	spf=pass (imf02.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778497419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b3jDWeFYJ1RQc2SiIxMoyibpKT8QV19rCafUv4Y8bAE=;
	b=aSq9B4YPuw2QJBYwEaWHs9IKZClJ4lu4HIDiMNK1IjEoch+w4ecg7OYTeuz9uVTn5giLf5
	maJS6hInJ5sUUmwZH/xJ1qZNCjZWslfxMNjguMnFj7g9y4jg3EMyCLNLGBWat8/sLxfR8Y
	ItKOyciOzD2e58QNXwhnbgMD2xg1SoU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aJNb3rG9;
	spf=pass (imf02.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778497419; a=rsa-sha256;
	cv=none;
	b=QXFfPUY7dTt2XFAJQzzXPU3SbxFegnHnBa2N27KjMUP3/yKXWKG4gMqGDT3/GukZDjDlds
	QGv+AFJeY7TNR6LZmAW4X+EMydjTEuuFxVWAAjTAeKFeRudh3sml6p9gk4MgaBuarJuRx9
	01sAl19TufiOKd/N5uU16SMf4Vm+LZk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D282F4195C;
	Mon, 11 May 2026 11:03:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D9F3C2BCC9;
	Mon, 11 May 2026 11:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778497418;
	bh=TSs/vN70p0uwNlsWNWNw+qqsmsV+31QSlkIJ+FyA3Sk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=aJNb3rG9eLyETc+c7dCYcxs8r8eBXcRmz0vVg8vuKZW2GoHqqFbVgBbrVrjq9Dysp
	 WTN60mY3CklTkxWRllzkM7NyNddnqX0/Gbk76qbzyp8wTw6rWxy+W9pGwrqyNJQ7Jg
	 tCYkIkvGdY83GQvSDv4miLSw7Aicx8OR2sy0Vo2GQIwntQXfT9n7YyhnZr2ECabXTs
	 ZTyOI7GATKJNiaOtKWAk4JH1C8JvH3iusGCdCP7yPGxxOhaO/c1q0+4hm2DsPJoGGT
	 B/UTvqYPlB1eCwgQ5D7QlRL4dWvxb6jGXRe4b6V7Wwv3UgBlPriRN2fX+5nm4PsXUS
	 mwrDtr4syMDGg==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: rppt@kernel.org,  sourabhjain@linux.ibm.com,  jbouron@amazon.com,
  akpm@linux-foundation.org,  linux-mm@kvack.org,  bhe@redhat.com,
  linux-kernel@vger.kernel.org,  dan.carpenter@linaro.org,
  rafael.j.wysocki@intel.com,  piliu@redhat.com,
  kexec@lists.infradead.org,  pratyush@kernel.org,  graf@amazon.com,
  changyuanl@google.com,  mario.limonciello@amd.com
Subject: Re: [PATCH v2 3/3] liveupdate: block outgoing session mutations
In-Reply-To: <20260506182039.2623553-8-pasha.tatashin@soleen.com> (Pasha
	Tatashin's message of "Wed, 6 May 2026 14:20:43 -0400")
References: <20260506182039.2623553-5-pasha.tatashin@soleen.com>
	<20260506182039.2623553-8-pasha.tatashin@soleen.com>
Date: Mon, 11 May 2026 13:03:34 +0200
Message-ID: <2vxzv7cucint.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C2ECD80007
X-Rspam-User: 
X-Stat-Signature: 44mm47kik6j9o5ttr9uyqy1zds63c97r
X-HE-Tag: 1778497419-12029
X-HE-Meta: U2FsdGVkX18CKyuPDxwhjBlm/hiB6UcqhkBHh5YSZPUZTDMlFyeBFteyUrYtmAslb2kiFscPABbcpQRv1Mb6boXDB7GRZbyoulsp11spjhS5QJuHjg5lS+Ph1Et1NkGdPXjjHXpWJmKYIlIZYnalOtdXoT4qdU3wc7hxulDTJaAsMgQZET3bZv/UyCsYD8WGwS58g/tFdup7gOm47hhEdl7nQIA0HSCDkH09U+tBBLraZSU0furJyNzQ8K8kdqwYkK+s7oc83Rh44Hplj19CbHpOpUjkp3W/KjtzcGaUzrmg7FhkzPmpL4Nu6EdzPc3jWkGWL9GIWl3hfe+zopvXqjLi9sVKWp8BJAKmOci5BQX17zK1me9zVDSs1rR3faHqLfYF36s/dx5tC8IHRbZE/KMrVHUX/kq6FUg/8u1oyR9WyDH6QvcF5EW6hHhgTcOLZLUuCPhsQthex9jud/772ZDkZMv4qErV+BrkeBOo+3vD6yqs/dEUZ0DN11lCXnQfmdDmtf2wTdVSs42j1iJzau4Dkr1Csf70CYMBU34MIL8aBZ2OinsNUIE7jt7PMs1EB/7+opfUtNDmRWgp/A2ybemTAN2PnMpN+oUQvPlIyBA/axYy6HXeuVX7ISmVDhcm20WmIJukIlNafZgoGtKmcTgcjDR7KvgT38q2svIOX8vSs8nK8xWFIWB8PbWh+KmBmWJGuXUWq1oS0SaqXcH+mPvbtqTDDgKDmz+SePO6DdQBnCmvt3wtyXWx3Sqn4CEkNQVO9f37tddJ1A3KpW2v8Qs+UW7O8rEe1VAaAcbA/AWs0LtvdTMYyZavK2HWzOr2jwfjKtW/p5dZBLBGgavn3TR1Vil0ZtsPgJkquTFtXG9UY8syWS5yoouI02Qgg2kbP0iC76b6hhn9229TQEPj6foI9B5gNJuMdspgt8V7fWEnai6WJhSLjhI+i1jRaShukT+U8kQ0PtVxrk++uah
 WiEKxmWB
 PTXxE1SsMTsJdg7JvW72Mggpe6qBHfoDjFwVKDwuKvjGjuNJK4VK1o9mLLymr0Aza5SCSTZ8dXadlNZszbp4WWoTCy3shGJNqot7Jth8cTSbbwjkmMjMdZanIv8n8ruYg3YyOLWU0JUxnDUGPuGwlSXayCmXYzRKaLwsjjJA2U7qDQfrSCdYuEH1KqjzSsnyoOwZHXiZSD0TwE0qtp810EGjTRFp9bTe8H4/Rpln5aUSwOaE5UTl04tSYL0JrNR9GFFN08kAjWyWVace3MG2RVXFLeg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 06 2026, Pasha Tatashin wrote:

> During the reboot() syscall, user processes may still be running
> concurrently and attempting to mutate sessions (e.g., adding files or
> closing sessions). To prevent this, hold the session header's rwsem and
> each session's mutex indefinitely on successful serialization.
>
> If serialization succeeds, these locks will never be released as the
> system transitions to the new kernel, effectively blocking any
> concurrent task attempting to modify or release a session. If
> liveupdate_reboot() fails, the locks are released in the error path,
> allowing normal operation to resume.
>
> Fixes: 0153094d03df ("liveupdate: luo_session: add sessions support")
> Reported-by: Oskar Gerlicz Kowalczuk <oskar@gerlicz.space>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>

Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

