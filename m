Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70FACCD4F21
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 15:38:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3D1E6B00BB; Wed, 13 May 2026 11:38:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CED866B00C3; Wed, 13 May 2026 11:38:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C03A16B00C6; Wed, 13 May 2026 11:38:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A99EC6B00BB
	for <linux-mm@kvack.org>; Wed, 13 May 2026 11:38:01 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 753B91A018C
	for <linux-mm@kvack.org>; Wed, 13 May 2026 15:38:01 +0000 (UTC)
X-FDA: 84762802362.24.FFCB6C1
Received: from relay.hostedemail.com (unirelay01 [10.200.18.64])
	by imf02.hostedemail.com (Postfix) with ESMTP id A68CD80011
	for <linux-mm@kvack.org>; Wed, 13 May 2026 15:37:59 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778686679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nyaVaV/gI4RT7k/IpK9F7cWJ2N3FmnxAA7acs4tl6xM=;
	b=CdsI7fsRbPzzQKEh/YmMRDzG/ywqxeiKs95isJWHP5grgBSuHIwW4iRrI3V4VvyPvQs+9W
	0w5hqLZO8z2tPn/9DMha6+JHtB0ypLjVatQB+Izwi/6qNyMXJ/lggKwbef6wvDbuukuDtQ
	NK9K4oC5FxFH0aJ/Qvxmc93torpzmTA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778686679; a=rsa-sha256;
	cv=none;
	b=JA2IV742u3ogNwflatB2D9n2AFZphF2JFasCy5jlLmU4WgVv3pw22bLc+dnWNMa2zDWP8z
	6qIrlggT2gBzSGz4ea6Bf/rawdJ2AB5QeYhjFBIdh6KkrgEKMGg3qZFd8zhTCLZUAYGxij
	oEcZZBKvUcJeLZZqzxU5w2IJdb4k7vg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	none
Received: from omf14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B530B1C0437;
	Wed, 13 May 2026 15:37:56 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf14.hostedemail.com (Postfix) with ESMTPA id E2CAB30;
	Wed, 13 May 2026 15:37:50 +0000 (UTC)
Date: Wed, 13 May 2026 11:37:54 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Will Deacon <will@kernel.org>, Boqun Feng <boqun@kernel.org>, Waiman Long
 <longman@redhat.com>, Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Juergen Gross <jgross@suse.com>, Ajay Kaher <ajay.kaher@broadcom.com>,
 Alexey Makhalov <alexey.makhalov@broadcom.com>, Broadcom internal kernel
 review list <bcm-kernel-feedback-list@broadcom.com>, Thomas Gleixner
 <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>, Dave Hansen
 <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin"
 <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>, Dennis Zhou
 <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, Christoph Lameter
 <cl@gentwo.org>, Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>, linux-kernel@vger.kernel.org,
 linux-mips@vger.kernel.org, virtualization@lists.linux.dev,
 linux-arch@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, kernel-team@meta.com, "Paul E.
 McKenney" <paulmck@kernel.org>
Subject: Re: [PATCH v6 4/7] locking: Factor out queued_spin_release()
Message-ID: <20260513113754.051c50e9@gandalf.local.home>
In-Reply-To: <64c202b8a76a7d98515cf10cc1f99ecb0a9a7ccf.1777999826.git.d@ilvokhin.com>
References: <cover.1777999826.git.d@ilvokhin.com>
	<64c202b8a76a7d98515cf10cc1f99ecb0a9a7ccf.1777999826.git.d@ilvokhin.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX191fRG9JHtupJy9pd45jNQyIWUqbihg3Yg=
X-HE-Meta: U2FsdGVkX1/Xz0KsUrlgbQ6P0jqSsi0BuOOQ57BSdsiBmiHSiqcnhQ8GGF/57kY5vcJ/Kp/3f3hVXhFX4GKJd6dUHccPq7zIEHyQxn5yDoVxMijnzCiN8wJ8SDaVYwf66HqkJmTiFdJ7pJh3X3xBeD26+lUuy34LqT1aZOLssrwR5BQSZZo9PBde81EORMGBaUxWkhXB2CrVDuixHOOyqducHcecosvvnTb/fZrh00Esfpaocrvm/lYF5zhG0N+LkOPDBCjYZcjvOuGc0vZBxMjXiv4M4p/fDszLwC/Cm9LBow3UCP5Zi/qp3HetYEBByXLUrv4ZuTRn2iP6b3iT/wWWHo+jNXq7lo9cNMgRiATjmxEOnW30JzPGPSXoL4wAt8retxoe8y0BmTSkSH3xzQ==
X-HE-Tag-Orig: 1778686670-783690
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A68CD80011
X-Stat-Signature: uew54cpg7odf4hwzm1e8ogr5uztk4ec5
X-Rspam-User: 
X-HE-Tag: 1778686679-812299
X-HE-Meta: U2FsdGVkX1+hSy8Bcf4wXCHe1J9+mRmsoa/+/eMS9wvS9DGuPnUCmShAqsP63Z9B/gMql2b61HU3N1korF5v7AxiazcNZykrsvKuVZL9krf1g2Q2bz9953NvAu7BA2xJuoyVQzyxYkzMKlmfs/TUJ4uRE7JwUYPJhWm+HeJCdDKa0mAkfJI/+0zqYwoYjEmreQ/CYen8vuUd5/mOSeGaJBhGOHJ0qotV4vlY+dbJV/7/oeR10bOssKp3/44gLswfnC11TgpSdu6DF/u81P0JXvxi7C9i3IOi8bTv2NRoNzUV/IHAy0zUUPlMlgDXz6CPtz5mdAJ+vbyraw5vLJ4JfultLbON8COo76zASRdFEgLKl9HGqOYLDUEKwi81LRejr59Bizb5GUxIHS42X0AWACbswfZ6HIr2Ct/Fu+axX7BiaRTGHJbqOyuOyJPsfWsaiMQVfl3Ri/YWXmNQQMks40xUA5oBR2puorBTgLyFWNiwabP+8WszJZoxxUbwHSy9QunnorS3ihUF7Qggg6swraSXWNeNzhGxvMe2Jf3epeyakVnwuSqdv6pA0zd05CHMYN4kCvyz8yRItUAt1Vem7mj4LDnZ3sUyf0fFID4ztPowzHhDjMJInGB5MAylhkElGEMkBfN8X5aPJsC/DfHd8GJ+M2YVhHE7holp+n86pqr6dnBFqsQmSj1YQG2BvClE9QVvpH/sHJy/OhbL43jUZzewsrKM67oLfmrd7NtiG0wz6lU6r/p1fBPPzpV0uLgUabS+DfSN3bJLsdFG172kozEnDx271ncItIGHDaw5CUzrOM+UNVpHrb20+b/6n/pDOU3zs4mPNKoQPd1O5KnLpnpbn1JLmeCiWDjzAYnrc9dLbaZNLT2hgrcC0zLhmhmq1alBmQOr/XC17F9NfHQP1ZU3Ook6QVaufDR1t7BxYy2D849UxsK0a/WOeb8ZNXMKZObnsyecD7QbfksUHEG
 TlQMOX9e
 9Yw/bWmIuVDozrJRMTlhzV+n2p6aXvoAgPvPdA6rJREHcIDBN7FjN2F1UatuqADppEGQN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue,  5 May 2026 17:09:33 +0000
Dmitry Ilvokhin <d@ilvokhin.com> wrote:

> Introduce queued_spin_release() as an arch-overridable unlock primitive,
> and make queued_spin_unlock() a generic wrapper around it.
> 
> This is a preparatory refactoring for the next commit, which adds
> contended_release tracepoint instrumentation to queued_spin_unlock().

In change logs, do not use "next commit". Instead say something like:

  In preparation for adding contended_release tracepoint instrumentation to
  queued_spin_unlock(), refactor the code to allow out of line calls when
  the tracepoint is enabled.

Or something like that.

-- Steve



> 
> Rename the existing arch-specific queued_spin_unlock() overrides on
> x86 (paravirt) and MIPS to queued_spin_release().
> 
> No functional change.
> 
> Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
> Reviewed-by: Paul E. McKenney <paulmck@kernel.org>

