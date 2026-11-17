Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44185606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 02:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gad53SSF
Received: by kanga.kvack.org (Postfix)
	id 3365E6B05B1; Mon, 16 Nov 2026 21:54:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E70D6B05B2; Mon, 16 Nov 2026 21:54:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FDEB6B05B3; Mon, 16 Nov 2026 21:54:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F10D26B05B1
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 21:54:48 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6B173A02B0
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 02:54:48 +0000 (UTC)
X-FDA: 85443093456.24.91EDA48
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id DA5E0100003
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 02:54:46 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gad53SSF;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794884087;
	b=5MYPNo5GB2AofSULVYsVBCtCHffeaNaYKReeDkcrGFIE4vF9QUYNu9QcO69oInKcGJ8kE6
	6JMtmaBGZuYlRze6jtVwcUlq56E8T3hD3pK9JRKkSjnT16DmsNaYtWgxx7jemHcb95ohyt
	Jg+juf27TdHy1MkiV9s6TLo85TE9Yc4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794884087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9mRXkzBGeilyrtl2xQUNu92A5sXxTwz+7Vog/x6aTi0=;
	b=x7+5dpefqH34/8qq6aIsPtXeavYLxFY3x900DgFrk8INVRlcy9TZ37zqn09xKJg75mxXXz
	ANYxd7uQQLXsYp5HAr7z9HoGCghr0Wxpfuywt1OtSC+NU3p2hlGnY0a31Fft8gx3x92XPn
	Z7/QF0fDAJxLEJre4on+cnKFdr/WgwQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gad53SSF;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 519F562A05;
	Tue, 17 Nov 2026 02:54:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D78601F000C4;
	Tue, 17 Nov 2026 02:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794884086;
	bh=9mRXkzBGeilyrtl2xQUNu92A5sXxTwz+7Vog/x6aTi0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gad53SSFAtTxw94ku7z15FEUFg5Onmufsy0VAucpxVCdX3w7K3NAYLbg+FPLgIPxp
	 4Up27XxYoinD6nvY8WRfyZNOwUbucJ5OWXY2ILMvsrj/KtG/iOJnE7yuaJ+IKjsa86
	 jvPSSgVUQfRfF5H/XfxonQtaWnWt6azhfilx9QNv+Pzt2Z+cg4LAKyRRKRM/zMjNCh
	 sVU2OCeaOJrkyhC6R5uTPf8C1WoIRDq0uy+jek3zKY5qo7UqgsSQBaSU/ly9n218yN
	 2h66TFtuW85r6m27izN/vWFql6EBfMywuwDSEclVqHscLWa9CAG7r8AYoXlWet9KjP
	 G/tVnaP4aPMZg==
From: SJ Park <sj@kernel.org>
To: Mark Polyakov <mark@thundercompute.com>
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: Backport request for 6.12.y: mm/damon/reclaim: use parameter context correctly
Date: Mon, 16 Nov 2026 18:54:28 -0800
Message-ID: <20261117025429.117165-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CAA5JH2yO-gw1gn_172hv0YWFfQpkXz915a=uoVH+e49P_D8-+Q@mail.gmail.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DA5E0100003
X-Rspam-User:
X-Stat-Signature: 57nxriggih7q8nw3azja7m9fg1d1f6i1
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam12
X-HE-Tag: 1794884086-324887
X-HE-Meta: U2FsdGVkX1+pIUMQXVCkC+eYuN2jfnhMEusqP+DMuDPrkb/3lJXkuZZWv8/ytgSuv9+MWvG08LF0lG9Xn5Zmj5DFuo7PWA2INNC7OtGk9TBDRRKB2DxOsfkDOD7rD3lZP4A495AfipB3McBAwuS3VS2AcZDgUFxToWmpHUwdfxt304VZ+36Q7JnMKathQNuS7mja3aa/6MeFyxiLovIZev33ikkNfIfS0pHqCHfxp2yhZYCCWqD0Cgk2ZmMQU3QOEYT9LWZixo06LbgsddirrcjvvznM3bdj4e4C903CdaxsnhaUQv6SYxCN/5ywdWi0fZST3AOSRmbQj+hwgHE+GtjYSJX9jFy7M9tKiHS7y/claJPsyGnu424Uj1EjYNvaOxUcUHipFwxr2zPRhL8YIY08jHjLPx4WI1cC0UQ7OWFSBLKXoEOMrYMuXHQmDEpRCnMl99jyaf0Wj3F7s+L0bp+/BZvfpx6zyMHBL7lm0PaxjFjFmjqEBCvt+khHXjW/0pzNTTaTTnwY9qbyzuyapyxrx80D6BxYx/unnDR2iPy6MQ+R+ZtHe0ZnBTUu0NrBxeLAiOTl2PPD/oO48r7j4uej3ZNmFX6cMDF2BGi5BO6wbiLdYhZKT4ANySYIKj5rx8DvLlFyoroP04DMkE+O03g1AP7QSf+/qkwo98FIe5z595eycmYb9N72ZS5mERIQ41cFvy7nT7L0A2H7fC2ktzWkmvM/WRbErr7pglxYVr5Ak/RkZaH4cAXGBO/4P/+3wfygWdegbRTAeqVKIApqIxC4cy2zx/cfc9BLsOPUn7AH6B6rrRgadRKVh7XAiuzCRFDR/EN4iSEjRPZ6c7un0kHXl1bvCAESxkQur/tA62AZT7p63jxX+bFdMHfCuvezeE3UiR6BaMCmrXCudmdt6kMDUinbfKI3CgbWascW0vN/Wl5a8ekIGFB3Qq9hrGDd3eBqwEfBaUtfw2R8CTf
 ayKs+OV0
 xz1/c8vK9R6BWJaPQ3QXgFO7wdOVpoIhn+jTEoJ2RVpnPYWoL21+qaIvmV4k1PrBwd7dTLQe4uPqxRu5Hn4Mb2rsOhyBlnecvzbZcgGnSCzGnD9oEYWOuR/jOfANlptdwqToflQUd+a3jfwO/jhkM17KvJSZlT0zhKVBlyPxPUzfGxNpl0bth/6Ef8Htmr+qmNITMtNEuX3/jooaGvdHQ5QSxmPB2A13p5D8kw/22Qc+uus+RkM3e8HjTCTbNAss+Ggv7eLQhU16fR1mM00sOHS4Rts/oY7B1ppVStM4OyH/Hc/j/aFMunB6rQfgTt+XDs+zYt72tUAreLm8dSLFV4JptHigCLuzZABz98k52o/yVIapvv+DAYbxRLR7Z9xRRPaONuXTX7XvQUqWGlGQqIjNziw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 16 Nov 2026 18:39:08 -0800 Mark Polyakov <mark@thundercompute.com> wrote:

> Hi, would appreciate a backport to 6.12.y of the commit
> fed48693bdfeca666f7536ba88a05e9a4e5523b6 (mm/damon/reclaim: use
> parameter context correctly,
> https://git.kernel.org/torvalds/c/fed48693bdfeca666f7536ba88a05e9a4e5523b6).
> It seems 6.12 gets backports of most DAMON fixes but this one must
> have slipped through.
> 
> We've run into the issue fixed by the commit on 6.12.115: A guest VM
> with DAMON_RECLAIM enabled but no reclamation occurred. After
> backporting this fix ourselves, it started reclaiming.

Thank you for this issue report and requesting backport of the fix!

I just posted [1] the fix for 6.12.y.  I mentioned you on the comment of the
patch, but forgot Cc-ing you, sorry.  Please use the lore link to review.
Also, let me know if I did anything wrong while doing the porting.

[1] https://lore.kernel.org/20261117025144.117100-1-sj@kernel.org


Thanks,
SJ

[...]

