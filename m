Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 333AFCD4851
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 05:58:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39FB56B0088; Thu, 14 May 2026 01:58:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 329CF6B008A; Thu, 14 May 2026 01:58:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CA406B008C; Thu, 14 May 2026 01:58:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 08D066B0088
	for <linux-mm@kvack.org>; Thu, 14 May 2026 01:58:30 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6D42C160706
	for <linux-mm@kvack.org>; Thu, 14 May 2026 05:58:29 +0000 (UTC)
X-FDA: 84764970738.15.41A8B73
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf29.hostedemail.com (Postfix) with ESMTP id 231F6120002
	for <linux-mm@kvack.org>; Thu, 14 May 2026 05:58:26 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=i6HFG86H;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=OB0HZCAy;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=i6HFG86H;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=OB0HZCAy;
	spf=pass (imf29.hostedemail.com: domain of ddiss@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=ddiss@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778738307;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JOgWhDRcNjDz19mj/rWWcL4Q1L5v6fdJ+Xa8kqqczdo=;
	b=BlKqhkUup/04h1t6KY77fOifAGcsNqdcguxB3I2oRL1wA/VqDnEyC1RFd5jE3Ao2nB8oQP
	USsj0d0BA/DoX469FtThlY2taDhf5IBe5drAkDDw6bi7enFrPFQtmpX8gKtIvrnXIi3Eey
	h1ouKlVMSZpTRJwDVDE10nT+fd/hY9k=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=i6HFG86H;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=OB0HZCAy;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=i6HFG86H;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=OB0HZCAy;
	spf=pass (imf29.hostedemail.com: domain of ddiss@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=ddiss@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778738307; a=rsa-sha256;
	cv=none;
	b=WHfMtx1rMqjwavvZZ4ca4J4VGoTakkIlQKRC/ZA0N/vS1EmbDtnvpI5LPK0K5nufppjQGK
	1KHyXwC17zJWdor4p4fJGiK6El7ICa+ICV+GyEJ1H/YlXR1vmv7cbn06aeADWa3Fih8G8F
	q4ZA1uiYjUETiO+7LKIC1YKI8u9lOqY=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5C99A5CB3C;
	Thu, 14 May 2026 05:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778738305; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JOgWhDRcNjDz19mj/rWWcL4Q1L5v6fdJ+Xa8kqqczdo=;
	b=i6HFG86Ho/jLEDkLruEGfg49LHBt/v3tY7G4R/HaVgxHR6EIPvlz/awbadbbpptERtNl6w
	SWTK0Xs7fxEqB+J6shqMYArmM5VpJ/kmaRc0rKUiX2ZYZ/3MgqDUd/DgsoKn71M7F2Vn4M
	8V2Ty09Ga3b9ALOVNwJ5RDGjB8VRxd8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778738305;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JOgWhDRcNjDz19mj/rWWcL4Q1L5v6fdJ+Xa8kqqczdo=;
	b=OB0HZCAys4Gycg9vUT+ugtZ9b1GVIIbBg8K2FOXC6sBb/tKvv1iXNTIj33ETVQdp14y+5e
	KD19SrvIi+/lwLAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778738305; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JOgWhDRcNjDz19mj/rWWcL4Q1L5v6fdJ+Xa8kqqczdo=;
	b=i6HFG86Ho/jLEDkLruEGfg49LHBt/v3tY7G4R/HaVgxHR6EIPvlz/awbadbbpptERtNl6w
	SWTK0Xs7fxEqB+J6shqMYArmM5VpJ/kmaRc0rKUiX2ZYZ/3MgqDUd/DgsoKn71M7F2Vn4M
	8V2Ty09Ga3b9ALOVNwJ5RDGjB8VRxd8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778738305;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JOgWhDRcNjDz19mj/rWWcL4Q1L5v6fdJ+Xa8kqqczdo=;
	b=OB0HZCAys4Gycg9vUT+ugtZ9b1GVIIbBg8K2FOXC6sBb/tKvv1iXNTIj33ETVQdp14y+5e
	KD19SrvIi+/lwLAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D61BE593A9;
	Thu, 14 May 2026 05:58:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id L/gEInZkBWqRGAAAD6G6ig
	(envelope-from <ddiss@suse.de>); Thu, 14 May 2026 05:58:14 +0000
Date: Thu, 14 May 2026 15:58:04 +1000
From: David Disseldorp <ddiss@suse.de>
To: Jia He <justin.he@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org,
 kunit-dev@googlegroups.com, kasan-dev@googlegroups.com, linux-mm@kvack.org,
 Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Peter
 Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Arnaldo
 Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Alexander Shishkin
 <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, Ian
 Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, James
 Clark <james.clark@linaro.org>, Brendan Higgins
 <brendan.higgins@linux.dev>, David Gow <david@davidgow.net>, Rae Moar
 <raemoar63@gmail.com>, Alexander Potapenko <glider@google.com>, Marco Elver
 <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>, Andrew Morton
 <akpm@linux-foundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, Petr
 Mladek <pmladek@suse.com>, Kees Cook <kees@kernel.org>
Subject: Re: [PATCH 1/7] init/initramfs_test: wait_for_initramfs() before
 running
Message-ID: <20260514155804.1fd13627.ddiss@suse.de>
In-Reply-To: <20260514050455.2954509-2-justin.he@arm.com>
References: <20260514050455.2954509-1-justin.he@arm.com>
	<20260514050455.2954509-2-justin.he@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 231F6120002
X-Rspam-User: 
X-Stat-Signature: hpaq113bzt4gc8p1jn4nzwd3stteq6fh
X-HE-Tag: 1778738306-360376
X-HE-Meta: U2FsdGVkX18Cpqk5nedrOB47hE2fs0vWs/uzfwPt8Tfk9Io9r7SuqzzZUTB2mgBRC50SwidCcZ4TiXU4osk9+1Xhnt09DwJqvfl+RcwmYVAG2pfCVn62n7Hw7VyVRiVCPk0hiW15VLo0iY5vzTj7TcLJOIlNgf6CJBlwDhbiaDKvENbi6eJXb8yU7Nox7lXJZUqsmzxJ8VWict92GWJgNy+TSYu7UVtziuNZy9DFvUAWoFWiiSzoPgTr6GBCw3Gs3hYasqCBRgGL4FYLEmuqJlXNxePAO4GhVbo8DlN/dW9DtEST+tTYxEUxqgzxUfA2k42e74TIJ6ZtlHn+XKM7BBBcfgGnbuv5ZHioaLjcFW4PE2/hoyjWcjEFY1r31YUi+ThhbUfphDMAZIgN0f/7RYCxDVAlYfCxcApCtWQZatOHid+gjkGyroAT/jnw4W8lmUwODCpghzsjH6W8JAUJgJtPUtSGDS9yREx/OJxaKzs7+LI7dyiwBPu7Xscx3JHNWAYiA01td6Kd9ve8f+g1dN5OcVfjbGkyhx96b+qofDJmmaA+jpQRs0ppcnfQOoiEoUbgFyUk8XOUMctXiXT34d0uoITxng+AXry6p+9zEY3WzqcImxmB5D8DBFw0u0SjoT/Z2W7hw9ObBq1j38QoCsYfpKtLPo1wQ1ZZrNb6pMo3cXD9CffTPJ/rhxQ3N8sn352K+D1TsIoaBK+OCo2v1ME1R/KJuHpj2IuXA5+g/jrm30jJ8fpnk0QeJKQx7oFE2GDqNFCB5YcsB3ZQ5xX0N11wirNcuokeYe2E/1+8DgC6Ax+L1xrOG/GRkYHd4vTSOOq0XB550xMkYHNiplIirxyQFRvvEWmNNAJZu+u7JfrAtKdQE2HuLEKfu7MJ4kp9c2JG0T5BOrpQm16UMJ1o3OWBnIdofqe40XMcCQMYT794jV4AYOovyzGtJZs1PxMYM+XQqvXgMiKX4oW5iew
 A9QwZEF8
 sosDq1T8IOyPAHz/Tbb4DkEFvkL9Z8I2zqrLiuxkokPhuQqj34ZBwV2s/kPFcdVOX5E9IOgD24cTtc32LPucx49kCtw7SCLgcB2hi72wZUQHQKmxNwLapG4s5y9GQbOTUZtZC32PbmG4Qv2p5a4oPsmY1tBPHmeuEUb5CyjH6g30l0g9BTwwLOcY/yHJoXTV2WjbT57qIO3nqGL+CdQKS9lNLjTpfni2C8sV1diynvsAGH0CmJGNAoo0b3R97VMbswjvQnwXMG1y7rOeIJ5znIniupujVoV7kQU+S9LaxtsrySbXIpDwDseKfTcky5gip2txIO8+2R90pQd6LbUbd0TkJqFxCr1alnPnr4y4dkWZORetDGgphJKb3xQkKJUS0i1yKs/ji10QK3IbpL/9xzyvOm7QU97XOmLG54HksolBtlj+NlRTPsTsUg8OCqyLa1ll4A54Rfu1iwMXs6uNXFYnrSh421a3npE1AK7ebzNkspFQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 14 May 2026 05:04:49 +0000, Jia He wrote:
...
> Add a suite .init that calls wait_for_initramfs() so the async unpack
> is quiescent before the first case runs.
> 
> To: Alexander Viro <viro@zeniv.linux.org.uk>
> To: Christian Brauner <brauner@kernel.org>
> To: Jan Kara <jack@suse.cz>
> To: David Disseldorp <ddiss@suse.de>
> Cc: linux-fsdevel@vger.kernel.org
> 
> Fixes: 83c0b27266ec ("initramfs_test: kunit tests for initramfs unpacking")
> Signed-off-by: Jia He <justin.he@arm.com>

Good catch, thanks.
Reviewed-by: David Disseldorp <ddiss@suse.de>

