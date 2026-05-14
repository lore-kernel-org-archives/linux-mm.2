Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3520CD4F25
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 07:02:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E97E6B008C; Thu, 14 May 2026 03:02:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C0CD6B0092; Thu, 14 May 2026 03:02:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FE576B0093; Thu, 14 May 2026 03:02:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 307E56B008C
	for <linux-mm@kvack.org>; Thu, 14 May 2026 03:02:49 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F2F65140540
	for <linux-mm@kvack.org>; Thu, 14 May 2026 07:02:48 +0000 (UTC)
X-FDA: 84765132816.27.A9A1293
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 521AE40012
	for <linux-mm@kvack.org>; Thu, 14 May 2026 07:02:47 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=Xc5o6ZH+;
	spf=pass (imf12.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778742167;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q9jFI5ampjE0C8kmJ0TznRqj3Q8NKDYfSXkAQm2xG4w=;
	b=xV20bIMYvEZNKbz1iGQMmDWEjIiYwP6LBlIZGrB3Eb6Ltq6+7wpAAR6rCaJsXlGlQR9aEO
	1p36xt6hnx+HT6vKAInDYri8PxCw0TRIMNvqEq6/OJ2RoVovfrhCEcQv/dzUF2KERy6z6r
	HBGF4Iu+eKTjgEzrLB4HEYouXbdbmO0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=Xc5o6ZH+;
	spf=pass (imf12.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778742167; a=rsa-sha256;
	cv=none;
	b=4x1uS2RyW9r5RWzymgu6ePz1QlWAXLeZ4e1TZUgL+ibdkPZJuhT2eqxUE6gFH5SQSCfshy
	NuAk7MOSJuvOG8HrmtFHUmsHhdwozgmejCx9g1pdMYFXkWosDL0u9hirYcsHkDd2lRTMs2
	KNeR1e8DRYPawglEBmAwZkaIhrY3kzg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 95924600AE;
	Thu, 14 May 2026 07:02:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7EBFC2BCB7;
	Thu, 14 May 2026 07:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778742166;
	bh=y52kfi9WilI/tUA+FQZJuSnWSdg+0Jnv0yMNHuqxb7A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Xc5o6ZH+mUCmm7dG3C6tb4OaQMkPqB7FznCmUAlfkSnuJuNMf+uEjB3Qh82WQJ0lW
	 KKwNKinKmJCxLDg6bhFJqNJgh8n3T4W3tATQGqvHrFll9Jg8ezYIIr1J+ayhtw2oc1
	 w8RznansvCek7pGZrn5qxe4zeN0by8Oo5jbQghe0=
Date: Thu, 14 May 2026 09:02:01 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jia He <justin.he@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org,
	kunit-dev@googlegroups.com, kasan-dev@googlegroups.com,
	linux-mm@kvack.org, Arnd Bergmann <arnd@arndb.de>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	James Clark <james.clark@linaro.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <david@davidgow.net>, Rae Moar <raemoar63@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Petr Mladek <pmladek@suse.com>, Kees Cook <kees@kernel.org>,
	David Disseldorp <ddiss@suse.de>
Subject: Re: [PATCH 0/7] Silence spurious warnings and crashes from kunit
 test suites
Message-ID: <2026051429-bauble-tarantula-1683@gregkh>
References: <20260514050455.2954509-1-justin.he@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260514050455.2954509-1-justin.he@arm.com>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 521AE40012
X-Stat-Signature: 7uhynpk3iatcqxya54gfciir1uyacbqe
X-HE-Tag: 1778742167-442940
X-HE-Meta: U2FsdGVkX19KL6y9IvAsMMc3cOS92bp9Fvt+YW2WKpXHAlxWgv1iuRLrgRwmDAfl1b6CceIcT3l3xqunFQZ2SlmZ/MzdxUioYp6AjLVp/JZPRHYj2NcNOJtfi7MpGzY2ZhmIyKfDhH9wPVyAB1RFv5Tzq4/XzbMdQc4N6PSo0O6a8mAUrCiGewydxPoiDjpeY9/pwj5sS/xJQQlHyC9rEFiQ8gWcygDfJgbXGllCLd8iJt3dzvxURrxRrfs1u8DnabxnQwI+3PAAsjIgnQa8CG6NmeqPm5DC5cCd7VGnsR7G5AViYMvDQGOjDxJOaefyBg9BelZxhCGyZ8VPiuiSe5Bqx9PZ5G9erY3NOgyw4ppjm9DayFLox3P2MxLhCOJoMx/qP8f1RQ0GANHXHzzGFIUW6GO8+HA/555mLNw1GybRq8cG6KHmq1bB8i3vEtbDLE9dgYLiZqmWP8trexspZufAAh/9+cz1EqopUuzI7+ghHXyyv2UW86wshdd/YouB16FDgZTBAckii0IveqIJNs0pTxCZ0GtGemOwk+IEnzIrZ69zt3aom+G/mFaR0zDxet//eShuYx3eAsvDD3PiCYWI5Eoo9yup4oP2pDBT9Amb4NLigK+9ZHNP5ss6beXK4sYYuaBrMOHRfjJDeCYWF3N1qxUkNOCdi1Xp76eFGJoektowBUI6RgQDUhCzKFlsohMSbSJPjpUa7karvWvY53Bb4WABEmLkn8/43coL2a3IFC0MYlAgsMpLmfHbs5vpiWQe5LC/nHS41Ogw7oLQ3n5RjFnj60puxyAXIVE3TST67Y+9gorRyYBeWuzHkBfJNFgptFnOi9Wcu9m5A7Z6DmygPxH4cGN7DLSrU8iRJFAn0C8DxcuFUeGQl7CdN39pQ87lBUBBHR8gTwT+rdvwwR7QIzZPbiM98Y3JWCg6QHwU8UhreW9wUAho+WLhLDgCmxwDAcXgD/ph75iuH8l
 gvH3cLXb
 ZQ8oRwPKE949P7tWP+qMK6Vc8LJw7DwR1Ta+X37j6bPwgstngY6VZ28VcsaszwftJdH2MRlzpXobQl0zJf6YybZHF+w4aHxmFeI8y8921adwIlj4kPcBmiAFXD6Wxi6UG7iHhI1pcnhESWCZXjtu21PNrFIwDyNLDusKyCrYivgcLW7bipe1tZmq13FZDfW7eOtErfO+YgLVejLg4IGBRzYvKnILO+CPXmGdY6rfeCgTi1Xzwa9dOU+tN9M6ffF7M3qyXNw8m87RkNcKFGB5J124sE1Hv5b2iocWTOcwy2nYNu6gaEmK98TcB0T3LZ+DBVbGe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 14, 2026 at 05:04:48AM +0000, Jia He wrote:
> Running the full kunit suite on arm64 (128-core Neoverse N2) with 7.1-rc3+
> produces a handful of backtraces that are not real kernel bugs but
> rather test-infrastructure issues: races with boot-time code, missing
> bounds checks, resource leaks, and sysfs duplicate-name splats.
> 
> This series fixes them one by one so that a clean kunit run no longer
> leaves noise in dmesg:

This series was sent to too many different people at once.  Always break
your changes up into subsystem-specific series as no one can take all of
these through their tree, and our tools, as you know, have a hard time
of just picking one patch out of a series.

thanks,

greg k-h

