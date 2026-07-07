Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77D04C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 06:24:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BE5F6B009F; Tue,  7 Jul 2026 02:24:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 694816B00A0; Tue,  7 Jul 2026 02:24:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AC2F6B00A1; Tue,  7 Jul 2026 02:24:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 36DA96B009F
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 02:24:35 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BF1258D260
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 06:24:34 +0000 (UTC)
X-FDA: 84960991668.07.2EA4330
Received: from mout-y-209.mailbox.org (mout-y-209.mailbox.org [91.198.250.237])
	by imf09.hostedemail.com (Postfix) with ESMTP id DE8A9140006
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 06:24:32 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=mavick.dev;
	spf=pass (imf09.hostedemail.com: domain of m@mavick.dev designates 91.198.250.237 as permitted sender) smtp.mailfrom=m@mavick.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783405473;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Vdn+mLWmIf3XyYG3gpoC46QIet+K6Ff3AtVmykAvLys=;
	b=acIw8g+xQrjGH8G83T4q9c/xxKHHpOEKYiIE0yDsHJqngz1TYK7S92qGjJmJIsz5Oiszh/
	Ujf9uwxcQ7/lbY0FbrWBznhB2t3jFsm/r3V5zyZzbapNNQiKHhCk+Gy9SpUYT73IioK1VQ
	3lMkbGIxYVQi23mB3bYgeSo5VFNvMWw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=mavick.dev;
	spf=pass (imf09.hostedemail.com: domain of m@mavick.dev designates 91.198.250.237 as permitted sender) smtp.mailfrom=m@mavick.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783405473;
	b=459IVjLMNJ204+T1axZcmb72QLRGEOiLQfxgE3xcZ6HpAzLT+vHjEsTicGZwUBJU21AwP0
	qB9cOZCldm+XIFNj9lywyI1PrbsDn2DwGuwGRCatvsi8Wh58QulNlj6Ys2TuJq5d6lFYWL
	/f/crAGuAnH11xy8ejT6seDjanCeUOI=
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:b231:465::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA512)
	(No client certificate requested)
	by mout-y-209.mailbox.org (Postfix) with ESMTPS id 4gvWJt5DQQz7vTc;
	Tue, 07 Jul 2026 08:19:10 +0200 (CEST)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 07 Jul 2026 14:18:38 +0800
Message-Id: <DJS4CP5DU9UH.699SV5JGDXGN@mavick.dev>
Cc: <linux-kernel@vger.kernel.org>, <linux-trace-kernel@vger.kernel.org>,
 <linux-mm@kvack.org>
Subject: Re: [PATCH 0/4] tracing: add ref_trace_final_put tracing
From: "Eugene Mavick" <m@mavick.dev>
To: "Eugene Mavick" <m@mavick.dev>, "Will Deacon" <will@kernel.org>, "Peter
 Zijlstra" <peterz@infradead.org>, "Boqun Feng" <boqun@kernel.org>, "Mark
 Rutland" <mark.rutland@arm.com>, "Gary Guo" <gary@garyguo.net>, "Steven
 Rostedt" <rostedt@goodmis.org>, "Masami Hiramatsu" <mhiramat@kernel.org>,
 "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Dennis Zhou" <dennis@kernel.org>, "Tejun Heo"
 <tj@kernel.org>, "Christoph Lameter" <cl@gentwo.org>
References: <20260705-refcount-final-put-trace-v1-0-cdd0014626a9@mavick.dev>
In-Reply-To: <20260705-refcount-final-put-trace-v1-0-cdd0014626a9@mavick.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DE8A9140006
X-Stat-Signature: k78prhc49pgx9e9r146r4gdy55tdz1xg
X-HE-Tag: 1783405472-52187
X-HE-Meta: U2FsdGVkX197S4QXnsEZbGEN2hNlGweWjcfzcbUaUIZ+uxqXa9HFXYbZsgJVnXalNVF5UvlLa6aJirXxueFXRlKZvr/DkcxCHeylYQ2nwD18BL2HJYlBbkB8gboaWm/fY0Vx0+w0o97TpRAVCgg0bwQ6hnSv0R8nii+0G98ETe3VuRmCrgLXXfX8Yu3IYHTb815bZC6LGXHKw+cwCclS8uUhAZA3D4dKrKmwy+hb83W3BjZ8aQ9qd0EFHxbENI0ajbL4X5qe3Z6T0YBeUkO7466ABTR8deADPcIgZ+CS+OustXU72Bzr1pgiiLr0vdESvVrKQZCvWK9/TgA/CCi7Z8/K365xVADNOmG7an3V0g2Gd+gxmOMZHrSDJdvqvtBf11AMbUvaT3MTrANRvGl7gozizwlPjb2iKTVoY6xTT9UZWees5g63x07B84JXgOOzi1+AfPYaD5pwDYWkuo7ItM79me+aP1qqnRNCQ/F3U9IsDn/QvmrmxpJQfZWXYuJIojZ9p0F1XBi0OrQOqVblUXvhDF28X0QZ9F26NzlED8k/4Kwr8XP+TEXA+rK6xHLWZvftyrMTEwf5e2rxROjC14RdOLmQYenqRNm7mVGZ6fFxCatONZ+tiR3X836pA5H4JsDNTW+nOC2OpByNgh0/hMAmgd8v3muebpNbnqZeYRX5phluGSPtF8JxBrOnPlb3ulAJivmtlhzqaIE2JTU9sm9s3WbXfHpHh0wiJpEs4r1qM13o9OEydeB7Zwos5C3LTVpmqWLMKdAlxSIb1EqB8ZQCCbGrkr64oJHQj3MFZIpDqOV3xmjqLlqsYtw1ysuTXubqv3MrfXMKvmUao4gWps42uSG2fUpcoCnO7j7jsaCrTikIYO2LQqU+jrHx2W32nKBWRXUlp6UNRC1hQ+A7z1fLATZ0dE26PLa63VXSAZq+dUFRRHn6EVAMC6kRcNpABqpIKekSipBU6QXNJAD
 ag327BOV
 P1Wxyujx9F4WzF7cMOSKwwgg0X9ZzBSp18K83jJ+y412XvSh+TSD8c5bxM7H49wJE9OeE7f/bS7Rg7cWEir3K/jMoR5gWkSQ5Hz1rrBXwYqpoQzditrkjq56vhHhIs8ZhhgZhDzce1LKYZiWmoK3dyumyoBNJBtTPTfZPU+zZmVXzxu9cm31Gp5Up40g3z6xRkssBW3uMzOAWhPpBVUZ2zbEwO9Id39SgQaniB7jPF/33ASa3IBADK+iewK60J/u3KHPjhiPcZB3nGVo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I apologise for the duplicate patch series submission, I had resent the
v1 via b4 relay as it did not show up on lore.kernel.org for a
day, and I assumed the emails were lost.=20

