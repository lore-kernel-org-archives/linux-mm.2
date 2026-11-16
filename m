Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94F2F606A322
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 15:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nQkysCmQ
Received: by kanga.kvack.org (Postfix)
	id B69F26B05BA; Mon, 16 Nov 2026 10:18:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1A3A6B05BB; Mon, 16 Nov 2026 10:18:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A300C6B05BC; Mon, 16 Nov 2026 10:18:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 880A76B05BA
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 10:18:03 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 27E4A160138
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:18:03 +0000 (UTC)
X-FDA: 85441337646.25.E61868C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 8C62012000D
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:18:01 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nQkysCmQ;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794842281;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kAiajgZh1K0aXxscyfggwMSX75ltYmb3PF4vZUEOkbM=;
	b=ibh2IhWP/nPkqL1aa2ItdNvLODPtGTQtWncsHBozzf9HJi0Q/NsZDr9uu+fQqJk46BvHFc
	s0HjFQu/vXrD20xMdCM/RL8uhHo3QZYNnOESWWKsdBWL1Ly8REzZgrKeBp3BCrbBJhZlsb
	jU4JKQQc13X13DBlbGzuEN4NP9Xn0T8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nQkysCmQ;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794842281;
	b=aYvtn79oYQEjFmM8RZDP0lDiQrwy3J8veAAqWtrolDFWn5bmYGCFwdmZG/rgvRXOtD7ATl
	58A5BuFjhn7v923C21u1ehEzAj3eqtKbNTZnXnKtCRkDQkYQwtjFTHYkTaeYnC4fU23I0E
	3NY6/mL4XEVVIuTLNz9nCqrx+ppJjnw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 172B862DB2;
	Mon, 16 Nov 2026 15:18:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9255E1F000C6;
	Mon, 16 Nov 2026 15:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794842280;
	bh=kAiajgZh1K0aXxscyfggwMSX75ltYmb3PF4vZUEOkbM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nQkysCmQ0C+mGKrrVYOwYyWGAqRDWcgOCJ03/p/Rkp23+S2ZiRcI25yyN4iqUzCDO
	 OcPGkLmivRxG7ffh7WDJdNdRRp8FKlNf87jTq9AcI1V1VXE9NLJRgrLhvocBc0QrKJ
	 CM230ihXniaqDG0JInhAuG9Z+9QfHEk9KJzhAGXMDUDgLZBB9Wqzl7Iyo5pKryXjlY
	 jfwBosQIctDZq6ZLcgIRyMAywXJf6sK9wiIgFA7Q67+e9jNqsEVZuxUsaOVHNx/Beg
	 Y2fiJuOtVbGKwUkv57RfXYtv9JicABV/O9T73XSuDjN79LWcBd2inRQhkAE/4oMsAJ
	 9gaN3WLfA++9w==
Date: Mon, 16 Nov 2026 15:17:55 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Eliav Farber <farbere@amazon.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/4] mm, uio: huge PFN mappings for /dev/mem and UIO
Message-ID: <avseiYtoPp1UhAbb@gremlin>
References: <20261112125638.12209-1-farbere@amazon.com>
 <avsbLgh-zBGmE4KF@gremlin>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <avsbLgh-zBGmE4KF@gremlin>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8C62012000D
X-Rspam-User: 
X-Stat-Signature: cqi8j3naxrnm7dks4etyjimwjm71g8k9
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794842281-258147
X-HE-Meta: U2FsdGVkX19lk2JkA3a5zuRF27GLfzccIJr5TW7sA9REb3aHphgxTe9AllC7vdRZ3fFb42LTUXwz78VQbyiE1KqPdLPSjaGg/he07oGHMJ9WZcP1NrnTeF+mRGXgL0ogjqeBOaJgzIzr7yqRAmu2z4zEBFLsM5l7J6leJetO8J7QxAN900CdzBoOCRa7MiJvYJTqntExTt1ZIJJ+jcxJh+aq7pcxbc2ylU+vmHZz7juLZ9lmlRGczlkSuVkcxVGJr7rrLU597uMZwSk6MInSec9MjPwes2E2R0D23M1ZSypu3kU1bZaBpDIqjxi70gkJ2BPu+OsAHcC48x7m6SxTvmcYNgNiUU2W0b6Qrh9+DlkvkuOF1GjHoieIPRqL/gdzMPsFaorqbAAr/zbaShOeU8zCympNUlePFbaCLoC7EyEIy3O3mFrIRA1EeJtIgmCfjHcMyFpOfpvgrYzPgTETv2eluocq3rEnHx9GTtVM7j1ehlS7nBrch0oQB1Z0vyhUTEcCW/p/qCx2T6GZd8eRCh/MhCzHRjmS6CUwp23iRFFOuKEdiyHwV5e5XAhmYEuxzeI7HaEUkpkS4XXDE1LZPEZ7WndqoXXpUqM0ZduTiVGjrDfJqI5hBotDPP+TaHz8Y8WsGqE5tR45gIvJIJJiF35Zb5GeCfdQnQcPZ7n7K6lgYT0N5xU2VwM7et3Qpdk5zDiu2HcPkYH8QBjpmWjGrqvMcvSe9Rz3u9M13oRMb8cyun32q15zOPQwts8ji5D1oVgKaPDtvADoBCji1NDd9lo8xouzSYphPJgoDUJfepHuAFdelsypL6ehCcEt0Y2GRq6rQj4HggOL4i2Lu/hXzsGClAbkNOrjaIqz8LtF3n6Tct3Y13VoCyfwCFSuLGSLBBxSew4dqrWDE74SPcsLqMzl96TSY2e1sZ+loHSC9dNU4Cvw+yjPuyaaMmvaeb6UrLS3/1fgUZrWcba0a4R
 nU43v8LI
 7HCq1wOzaYitZh92b5QGca3DIfE5touDlS/8KICS2spwvOQC3MGA8QkmyybzFXGS3w4I3YaRXfprIGnZSvNpnrro5KWjqq91DClhwSxqZABaHbVEw9ZgG/AYLC4bzM9l12BCc0JHuJyBoKdfYwQbsvU5OCSvGJITLDAHwTk2qlUQ4HhzN2zU85rcczK2aD3xtCPZ+YSzG8KqGXTLA/qfxNIVdX9xB8Nw0uW0gVT9W2yU/FLv3aRTtpXU1QZgloXnY8zFk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 16, 2026 at 03:12:42PM +0000, Lorenzo Stoakes (ARM) wrote:
> Err, there unanswered questions on v1 of this review, so why have you
> sent a respin?...
>
> I also seem to remember David asking you to slow down on the respins
> earlier too.
>
> AI might make it easy to send stuff out but you're outsourcing work to
> maintainers here...

OK on this one I see that this got sent out before David's mail, disregard this
bit, but please regard the rest :)

--
Cheers, Lorenzo

