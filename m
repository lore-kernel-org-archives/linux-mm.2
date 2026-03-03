Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99EEFE67A63
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 04:28:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0869B6B0005; Mon,  2 Mar 2026 23:28:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0344C6B0088; Mon,  2 Mar 2026 23:28:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E75846B0089; Mon,  2 Mar 2026 23:28:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D26BF6B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 23:28:15 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7FAA9C224D
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 04:28:15 +0000 (UTC)
X-FDA: 84503469750.27.D19FBDC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0D7CF120004
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 04:28:13 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=HAOaB3OY;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772512094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FK4dBpvwFRyJlvmkavVZLTF2xD/9+o4ZvBJ5CMpWL7o=;
	b=PBnplJMY/3+DdoCP+HDI4w9H5rNwlC0lZoaciRfK8YqY4RobuEIzfDdZ5ax8h7XFxM16cN
	4x96+G35ghpRuO6IrEBHLy2bBzhkDhUxnT5hPdDMxOZUtiAgbR7w7q/JYFGuE9BYTJv8kc
	r1HtEk4OfprxST+rA2Fnq/teCIX2vT4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772512094; a=rsa-sha256;
	cv=none;
	b=h052zgQIxlqdJH4rGKPRK/AqzVmgvygczJ1JrVF6OMDh2yNWdHcAQrXGo3V2XqheAfnV0k
	a4A40WbhGpaWI4JVXwzzy6JKH7wDGT811mEVM907x7u3OasG10YA7qQsYARo3ExZOyPJan
	FcCZvCt0mUoy83lD/sTszfUjIGp2Pf4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=HAOaB3OY;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 43D1460053;
	Tue,  3 Mar 2026 04:28:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3BDCC116C6;
	Tue,  3 Mar 2026 04:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772512093;
	bh=F1u58kc2HKbh7sJsNByf2oUOzn/KUBrEpV26blvtw0o=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=HAOaB3OY4SLyxJWrh5SRbiTKbgqhvEsg+nhSRIcgrRKEa6kSvtvVJgVwkNSM36pVN
	 zkAT/+U5OhkjKXqQMMqq4RJt6phOSBxZ6agjvCN1Y1vzGbhNxdf515VUYrnzWrG8vW
	 nGoocEuIBpTpb31/3TCiZUYLQlhuS93v7qxjViVM=
Date: Mon, 2 Mar 2026 20:28:12 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, linux-mm@kvack.org, Brian Geffon
 <bgeffon@google.com>
Subject: Re: [PATCH 1/5] zram: do not autocorrect bad recompression
 parameters
Message-Id: <20260302202812.06e4fd4156e5315f0b5f3fad@linux-foundation.org>
In-Reply-To: <bg7ivz7ajiuzdbpv3h6hbptxgmqk5fhwakw4rzk4sz3bczky5a@rde3y352n5ej>
References: <8a5d53d19a8dbd51d7d81d153676895163e0735e.1772180459.git.senozhatsky@chromium.org>
	<20260228120516.e5323a704d4a26bda041dd4e@linux-foundation.org>
	<bg7ivz7ajiuzdbpv3h6hbptxgmqk5fhwakw4rzk4sz3bczky5a@rde3y352n5ej>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0D7CF120004
X-Stat-Signature: ghkqfipfodusm5bdabwrdefys34yrb44
X-HE-Tag: 1772512093-338560
X-HE-Meta: U2FsdGVkX19fOLEBfy30pcw6dg8WyBHbVpP/NgIjh5xPJwZYjf22rgwShDlO/M9mRqdyMAR8lYdSldm/k925RLRPM6ROVyg76MekgoZVcmuf5kv+QxzRIo3mEni+dTB/Pj/VWDDH2mHkWE8uSaKuVfHRxY5oQGYpOshKsvecT8CKJ5B7/9MB0KjCc94BHzhe9RJMzPchkdSI2HxVVt45bbXcqzsAFeoijVo9X7C4ccysOabatm62Bvzb86zglhgUtkNG85G7HU6VyzWbWZy6HUEbF+HYFdBj2T2yGoG9Z7FEPJcOC8tAknm6VwdvKnEbZWqRo1rutN4UEzw9sDSdnUemZJ1J+6fyScEyKcA7UqXkfuQQDaHtqPG0rF5U4d1WjqDCd/ejBP9MV7Hh9JvarVXbPWkIEoJLsw4zC6qQll3bvqkhRN0J8wZe6M/GsgxVDYX3bNY2BvDFnJgCRfNrGhyWG8u2s+7+zDVTND5Uylh1FrFb3i3PqwiAhTkiLglUAhEzUaI3UaGahPDusir7fuFnPIQg3ZvvLEU/y+iD+BUQqWsBEyP+3B0zj9aXYtDLJvJFHvaja6OOGFGK33P9i23JMhxg44pKJg2e1yaRpn8UVSLBkf20zvM/WScdh7lYQ6D0TSfDNLNRMTkl+s3cftk77lXbuaoPC1I3vZe9rKaLSUvMaAyHMIs7zLBGUfQrLUh05RmejnASbsuOmSCrN8hrckVCFT7lvb+/J2ec0eCTcTje29h/ErKmix3TYU27SWi7EjV7nfRfFRlVOXihYaHaPMFpzHCSPHsnVwlMR03Hy4lOfjZfjuOPoZbuvI1ubIEOt4AgjZxtBtAGHNuet/F2WX2NFZvg1G7p/JEwgP0PgG2Kx9z7w8KaMq1IgScsaFwNc/AEZ//gQD2U/21K6ikoXw6WThK+i14ohdT8bNU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 3 Mar 2026 11:59:45 +0900 Sergey Senozhatsky <senozhatsky@chromium.=
org> wrote:

> Sorry for the delay.
>=20
> On (26/02/28 12:05), Andrew Morton wrote:
> > On Fri, 27 Feb 2026 17:21:07 +0900 Sergey Senozhatsky <senozhatsky@chro=
mium.org> wrote:
> > >
> >=20
> > A nice [0/N] overview would be appropriate for a 5-patch series, please.
>=20
> Well... I couldn't come up with a nice overview, let me try.
>=20
>=20
> The series is based on internal discussions.  Minchan looked at
> recompression recently and pointed out a few things that he thought
> were confusing or unexpected/unintuitive, like the fact that zram
> would autocorrect bad recompression priority parameter, or some
> other assumptions that zram made.  I couldn't explain why it was
> like that, and just agreed that it was confusing.  The final patch
> in the series removes chained recompression, which also has some
> unexpected behavior, so I just decided to simplify the code and
> remove that feature.

OK, thanks, I did this:

From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: do not autocorrect bad recompression parameters
Date: Fri, 27 Feb 2026 17:21:07 +0900

Patch series "zram: various cleanups".

The series is based on internal discussions.  Minchan looked at
recompression recently and pointed out a few things that he thought
were confusing or unexpected/unintuitive, like the fact that zram
would autocorrect bad recompression priority parameter, or some
other assumptions that zram made.  I couldn't explain why it was
like that, and just agreed that it was confusing.  The final patch
in the series removes chained recompression, which also has some
unexpected behavior, so I just decided to simplify the code and
remove that feature.


This patch (of 5):

Do not silently autocorrect bad recompression priority parameter value and
just error out.

Link: https://lkml.kernel.org/r/bg7ivz7ajiuzdbpv3h6hbptxgmqk5fhwakw4rzk4sz3=
bczky5a@rde3y352n5ej
Link: https://lkml.kernel.org/r/8a5d53d19a8dbd51d7d81d153676895163e0735e.17=
72180459.git.senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Suggested-by: Minchan Kim <minchan@kernel.org>
Cc: Brian Geffon <bgeffon@google.com>
Cc: "Christoph B=F6hmwalder" <christoph.boehmwalder@linbit.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lars Ellenberg <lars.ellenberg@linbit.com>
Cc: Philipp Reisner <philipp.reisner@linbit.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ...

