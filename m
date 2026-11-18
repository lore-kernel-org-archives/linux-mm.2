Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2591B606A337
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 01:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=J+o8YWMj
Received: by kanga.kvack.org (Postfix)
	id 905706B05B8; Tue, 17 Nov 2026 20:32:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B6286B05B9; Tue, 17 Nov 2026 20:32:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A4EE6B05BA; Tue, 17 Nov 2026 20:32:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 430116B05B8
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 20:32:41 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 05D5080663
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 01:32:40 +0000 (UTC)
X-FDA: 85446515280.14.470E64E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4C7E320007
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 01:32:38 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J+o8YWMj;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794965558;
	b=qJ2VJHZd2Mwkgj0OlX1qDbU6S4DLi9d96R9BmbFmpf5DYJXW0ZEcOI1WHRPBC8siE2Ipos
	6ZMeAeN6ZwvXRuu59yVrO0Q9Yrysuq3ytGZ4r8IG5daKCZm4BWTjZ4jZNRFZShacZW136/
	x5DRqRlKcjyNk/nBFDLzMz6mKdw3Qpw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J+o8YWMj;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794965558;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=60eiZsC1vQ0qBVJ9i90dmpYE8S+lEjH9IMSqx80A0ng=;
	b=b7JR9c7cZoSQzgfEHKap7XzwTg/FPcCDfbV7Vj6XMGa5LuS+4GqIOyru5KJweLyKX00MeV
	xmHikqfwlp5xH5nio8iE6IVBD0+45Vmb3ATpdQOExHZRN58IPQl5w48ickYybPHTo6MI0u
	RYwGZ4SUgEKMKNQ7uZ/d6wHMmgS38+I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 78A6B43F8B;
	Wed, 18 Nov 2026 01:32:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB1581F000C4;
	Wed, 18 Nov 2026 01:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794965557;
	bh=60eiZsC1vQ0qBVJ9i90dmpYE8S+lEjH9IMSqx80A0ng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J+o8YWMjgX9T+5jaNOFnKzda/YbY1BNrE/oTberX3jpMzeB7wh97ZK10rgf3CwYSY
	 zq8mfbmcExTlNGaPUAdcqtmjnW+KVJR/dZpuwoTUH/GAizTqsbJ5pmwDSrNCULxRcJ
	 3ejeOy1vgVYdhIvtqX9U1pC4IRSEVtZrjI2QnNJD5vP+9t/V0MgcmVgC2z4cRDrCjS
	 f5XF/8p4dyvTiyWMKx9wr8jsREZ7FvT4FdC0ipJFFrF/iUn5TZCsahLeC9HttFpdF2
	 nQ4SAofcjof1wqiK4mRA0JHf6ohnn+LhWahQwWRci43iLDHiUygj6j9tIsPsOPevBX
	 J4VNdsXdz4+WA==
From: SJ Park <sj@kernel.org>
To: Aveline Noir <jm5905938@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	David Hildenbrand <david@kernel.org>,
	Justin Stitt <justinstitt@google.com>,
	lienze@kylinos.cn,
	linux-kernel@vger.kernel.org,
	Linux Memory Management List <linux-mm@kvack.org>,
	kernel test robot <lkp@intel.com>,
	llvm@lists.linux.dev,
	mm-commits@vger.kernel.org,
	Bill Wendling <morbo@google.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	oe-kbuild-all@lists.linux.dev,
	rdunlap@infradead.org,
	sashiko-bot@kernel.org,
	sashiko-reviews@lists.linux.dev
Subject: Re: [PATCH] mm/damon/paddr: avoid truncation warning in high-address KUnit test
Date: Tue, 17 Nov 2026 17:32:28 -0800
Message-ID: <20261118013229.94629-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261118-fix-damon-paddr-sparse-20261118-v1-1-3a0e943406d5@gmail.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 4C7E320007
X-Stat-Signature: xouiirpt8gpzspaz81o38phgj3qd6d9u
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794965558-674946
X-HE-Meta: U2FsdGVkX187vYJq03d1plQYyD8ncQ0MHTd6yzv/7nB/nzFid7vjLoSskJB1L+CvitxsSLhQQuUwQk1jUqHqLTzwpkYrwgRXCQyEsF/ImgdGXlWKA5UGH/L7lcmINAHcyncEZEPNGrs6CW81axqzVVNuQuIozQj2Q7WE7eJLq5p7fpDKRWilTqKh2JEri8oDotO2mvZIk9/eiAQVVLll7PIvWdphtwVF+rONGpqmqboDz4/TmGtEqJuCw3+ElfEMzUiulQVwJZdkW4/4rVtkRfNaLbGf0xys3a2Qs9lrz0uuf+kLnK6pEbeC9PP/9laQrrKfbVbUwvUPWkk0x1SwhraUDb/ZQz6PznH2l3/8N1q1DfUgqD8WEo0UkmPzF3wXUibj3tRKBblqkLtwBXrN5sDsJ53TzhzXFHu83XGlg9XW1GmYTXht87aP5Qqk04QaTUxHScE+2upfTrDPJAK5l79d8DAQehKx2hqMxVvBGWEGXa9UIaeenVn/x9N5EBE7QB/HR0Q+B5OTLVIq2HgshTjhtlHL2cPvnRDVn8huqSaAjNWv7QE4uDkPeGi/silL7ofL6IkIbAJ3AxSeThPmAd+qzoagfNsY3o5hSGADAMK+2XjNCBFqDTfz4fWGSGPGJm2ZELTccVd6ykbKaPXrTaZeLvJbW0wxTz6WTpWBFc8LBycAUl9lveMNcZ3B7ACWdjMYhNboZFDzS4J6RtoI/50pClrsO8vhvw1Y1pD5V77Mnrfj4kIV8PG8AM8OCSNwWCuBX3YkM9ckakJ/PWO29hPRlUk4tYlX4RfMTWxBssrUGsa5V1vaiduXh2SIKR/1vRJqBHR2iAv4GG1gZsLXNLyh1SrtpRpmUzUCrtRpdgLGoL2HU9ZcdPJuQZas4A0T/QtBURW2e8Gg8ma2H3v8TnLcW9BUnBdIh7whuZ++Q4o97HY0Y7EJ1kkM2wqmx9M1ieq1COzoCwHWTX0KGXF
 7MQununU
 //zJP3M2oePCKMHDDnErhwAkCp4rbeEUPex9H46se0BobgP3df8+IouZP+j2IYiAxpBh0Y2IMHsRHqLLWC3g4UjRBeEKNO0ch3KK1r/jwRVSucgWoC+Lac+/lX2W/+kPbR1HqQZywQ9UiL+DlFQE9q18PTwOa2F0sBdo0TU6j9+3SUTP1n+FXzkRIWz+TzIHNi3Lln2kbg8PToyuGaU6GKkoLk9hnCzj/qmyiHXckRBVgyVY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Aveline,

On Wed, 18 Nov 2026 04:04:33 +1100 Aveline Noir <jm5905938@gmail.com> wrote:

> Hi SJ, Andrew,
> 
> The kernel test robot caught this issue in my earlier addr_unit KUnit
> patch. Feel free to fold this fix into that patch.

I will ping Andrew again on Thursday, if Andrew doesn't add this fixup to
mm.git by the time.


Thanks,
SJ

[...]

