Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 729E3606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 11:43:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4904A6B00EF; Wed, 18 Nov 2026 06:43:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 441966B05B0; Wed, 18 Nov 2026 06:43:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3325F6B05B1; Wed, 18 Nov 2026 06:43:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0575F6B00EF
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 06:43:24 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 809A8160712
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 11:43:23 +0000 (UTC)
X-FDA: 85448054286.04.0B2ADF5
Received: from a3.inai.de (a3.inai.de [144.76.212.145])
	by imf19.hostedemail.com (Postfix) with ESMTP id B345C1A0002
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 11:43:21 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	spf=pass (imf19.hostedemail.com: domain of ej@inai.de designates 144.76.212.145 as permitted sender) smtp.mailfrom=ej@inai.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795002202;
	b=RQC1I+NTnyKplP97XbLL6rmWzOD7KXYrRMfIxv3gjen3ZsUODzQjW2xDD+yZr4pWJbydt+
	V8CEgLAMvESI1jqDwJe3s9azIFH78VsSrwbhizN3LUQ1IBUxcTXL1Kop+UsilvmFbACWJl
	QDlPng9fWoZoyIlmom/Lc/a+38v1jx4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of ej@inai.de designates 144.76.212.145 as permitted sender) smtp.mailfrom=ej@inai.de;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795002202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iii72bAln91AxAYWqMoQsj+xak14m3uKD/kq756gkCc=;
	b=0D7MBSIDILKIbHviV/vQiEyZWutqpEzd4fG7SIKBvr22dFjperqSZHnljYVD67+Y1OdYgM
	zYpowAY3l8/21mM9cjSIIbsevNlhBjynt9qd8gpe2RduQlK7T7sULx1jjyAhEYgIICI+0T
	ha+qCz2oSe53oDKFbY5vktukxcmTAwg=
Received: by a3.inai.de (Postfix, from userid 25121)
	id 4FF8C1022963DE; Wed, 18 Nov 2026 12:43:17 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by a3.inai.de (Postfix) with ESMTP id 4D5E811040FD86;
	Wed, 18 Nov 2026 12:43:17 +0100 (CET)
Date: Wed, 18 Nov 2026 12:43:17 +0100 (CET)
From: Jan Engelhardt <ej@inai.de>
To: Vitaly Wool <vitaly.wool@konsulko.se>
cc: Andreas Hindborg <a.hindborg@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
    Miguel Ojeda <ojeda@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
    Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
    =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
    Benno Lossin <lossin@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
    Danilo Krummrich <dakr@kernel.org>, 
    Daniel Almeida <daniel.almeida@collabora.com>, 
    Tamir Duberstein <tamird@kernel.org>, 
    Alexandre Courbot <acourbot@nvidia.com>, 
    =?UTF-8?Q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
    Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, 
    linux-block@vger.kernel.org, rust-for-linux@vger.kernel.org, 
    linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] rust: block: add rbrd, a RAM backed block driver
In-Reply-To: <20261117233211.3137168-1-vitaly.wool@konsulko.se>
Message-ID: <176sn0r1-3s85-0nq0-p258-220pnspno416@vanv.qr>
References: <20261117233211.3137168-1-vitaly.wool@konsulko.se>
User-Agent: Alpine 2.26 (LSU 649 2022-06-02)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B345C1A0002
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=4.0.1
X-Stat-Signature: 866tpgukityk5kgkunishad5axexrb8d
X-Rspam-User: 
X-HE-Tag: 1795002201-891264
X-HE-Meta: U2FsdGVkX18rrh3Y6v18D/X+F5U9OT95iHCxTRBxtWwlfSyy3AkKdHNHuxelObfLmwdH9RBCC77Ke9gp8RE4P+79F84wCpON+Gu1yLtoWSCRymdxJyScKbimvTVe8nnoThdg9umdVi+fjVwI7q9r+dGYWFM5xanwnipUYmUgOXlE/mJg44pC/i5Il6oOn+kQiUlDeZFciAUUH8VbL/aik0LNF5qFh6/MvVn9FzhX4MD3IunswAvlgDJEfYoONUVWgx5npKSEnh5FKdeEn7gj0RGgqtwSbMQCBJw96nxOy3jptFyQCxQ6qtJBBU1iRCQkUbohG1/jg3Tp2+q3UeYMc9yKaX547b9yl/Cq1mz7y3Ugl0eHNdptnnFY7/f+ibuxuObwoznayuu6FGCKBx+FRPINyghbdCsSdnAZ4fyYbduaeTs7C/BOsD/eSt2/TPr9mavHx0jUynoboMjdGnMIZaG43M32xAGA5j+FUeWS9GINoMvBP1QCSM0Co0X7pCxQTD1ZJg3KULk807gAwnEIrabr5FPCqP2rXRCDYQerbWb3xUYMEgutssfZGjJmS6aMw+VevcNYYHPirVDtWNho4+0epZuX1oVvZXAieJP2uU6gFvMsIJD4uSOi3aYFAo0B5hIKe7sUUrb1F4DPriG39ypeKM+GgzD1s9upVa3sWJ7/+W5lfU3wyQ/Iv0kreb13SbEo9BfqnvXf/3PvXawVS52Vl0uqZ1WLKkfIhtinem8gsHpqMfqI6Mw2jvjkYRD26D1T60xDRsOuPVuAWI8xIppmys70cVo+q6/wX4T+PT9ULdKywAuT0NQqJS2n4kWq1yqWtajK8Mn9Bc+dIpC0U5tPRnoZ85incpMQeVJJ9XMPzlsOVBSPsAf0MZupisWiaG9Ub37yFISsNOG+uXjUblNlirsH/WVPwZ413TSyUc2TtVBaUw4OUMeRyghSPqoMzLCmiQhbU9e+HcHtzwZ
 USa1w5XV
 P9JOE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Wednesday 2026-11-18 00:32, Vitaly Wool wrote:
>
>  test                  brd    rbrd   change
>  write, 8 threads     2004    1563    -22%
>
>We think this is a small price for page integrity

A free 28% improvement, just by using a C driver, and a bit of 
discipline in the program (not submitting the same page).
Supercomputing will be all over brd if they need a ramdisk.

