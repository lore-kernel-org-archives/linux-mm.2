Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FF06CCA490
	for <linux-mm@archiver.kernel.org>; Sat, 17 Oct 2026 00:00:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2875E6B0088; Fri, 16 Oct 2026 20:00:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 238EA6B008A; Fri, 16 Oct 2026 20:00:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 126F66B008C; Fri, 16 Oct 2026 20:00:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E9DB76B0088
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 20:00:23 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4ECC81401AE
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 00:00:23 +0000 (UTC)
X-FDA: 85330161126.05.5733F88
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9DFEC4000C
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 00:00:21 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="YT/Kniwn";
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792195221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ShCsr8VpmfSVrYE38tsQnynm8VtQ88LG2PyXK4mEIVw=;
	b=EL0etntrPtHPdUKirmtIt0/sZUWzamyG5ZtKQ9QqrwAAmoZOly8xPoVueV+vYAl4FaOxZn
	evrbYO06+u2odJfm3qS5HWS77yLLKc+F8kAQvmyZ3wIgDBOAU6OxHZRoPPMxrk2uJiw6Rd
	YndosxZAqsegEkBx25n8Olbsn3ID8PQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792195221;
	b=udSbonCOa9a4Ozp+exWmTqBgSXS9w1Kps/qj1QKgttgBXIm0Dg47IXLa431YRU4dBE1CQk
	6XybjG0bjUjPYULJy4Hks67mzRAjCgbCHsItQEUvSHc2NJiRxrNuzqv1yZDfz4jX4y/P/f
	npAriOSEd6iEZc6XHGT7wVKZduwFINg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="YT/Kniwn";
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8ABB0406F6;
	Sat, 17 Oct 2026 00:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D44CE1F000C4;
	Sat, 17 Oct 2026 00:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792195220;
	bh=ShCsr8VpmfSVrYE38tsQnynm8VtQ88LG2PyXK4mEIVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YT/Kniwnli+s29yW9eREh6MrxOIb3XDAYCRJjjRU3iAFlX4Oax5cV3OHzXWrGRey4
	 bFO67sh6yb+zwA2ElR6CrK26oeD8wD2nT0urKNWD4Yw7YjlVS+Oh4Dtc96+PXgWhEG
	 rI5oltlo7G2B2tfYJdEdBZwS+Ys1Or4rMvJYUcgzSYxi7n4zo4ain6IDRw5/LdYAeL
	 G5Myn5WbJzSFWUYa67ozwJpjnK6syDV+TdXK1RQY4pv8gzKAxxzfjGc3MkpH8CIq5N
	 6IgcpXVJq5pRsI49kaMj/czV0hdUb18bzlaq4y32H+PQAki3gGlItpIdpaVT+cC9lc
	 E6Zrqu8at65Dw==
From: SJ Park <sj@kernel.org>
To: Aveline Noir <jm5905938@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Manuel Ebner <manuelebnerli@mailbox.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/damon/reclaim: improve grammar and style
Date: Fri, 16 Oct 2026 17:00:12 -0700
Message-ID: <20261017000013.97300-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <179216914308.58773.4774391289742300524.b4-reply@b4>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 9DFEC4000C
X-Rspamd-Server: rspam08
X-Stat-Signature: 93516d58o7f4oreyo7om9z8yacqppss3
X-HE-Tag: 1792195221-120702
X-HE-Meta: U2FsdGVkX19gC6M1oFgREnI/3PiW/JoOZdTQ9cX3W/du8DsCmdQtKoJd1ByCmIqHfNK59WofB0Aai/2cfIscYN6q4FKYzqevLtCiobDvKo4OKQbth0RhuGHzOu1pXWSRiDmAf7/LxBQjgEbmdVE8MfZChz6+6INS0hgwO/H/xYbx2cIt4SXWFhl4shHYkPXEx4U+RnqsCthDr/alrmaqIoU8AV8Og63zJv0rfqSvIRiraUtSsq9JAn7JFrBner8NYhT/VJ/68OB+GdYH58KGsqiW6ZY24yk9ToCq7sEzK9yRKDil/+zpjkDqdnbxNP7cU1Ghq1joRi5B1hLEzHjYp+4Ik1Ij9QYVMj1EowxP69C995gGwNdU7V5yz+qKuAg8GPmsO7FKzYX71K6X8T4YJI4vz52aCUfs0dw9fuvF0S3bOL9qbrAMblGkVSg43O4GOJOPxd/OsFmKmQQCZveQlVP3THWsifSpgPyEsPKG8zMYPr+O3ZOrCLLc2kgC6MEE6R3+TQH+uamHhyGSEnN+UIppqbuyU7FapokM0ntUbnubQfqoI4SulHlNN7CnNhPw1VN5BffSqxG99HUm9DyaE9oHGrHnqa+snmIPA9Qrr0eqCuzxvzI9MCHlF05y1XFQxKcK1MtCQVuk6B8isv5lriD50o2VNu7yGc44S6z3rwj6KK6z0A5gHndSS7tbiqeD2VKmdRnmrcoVT/cKPGKIXMq22gmHsvGAgrJhfHRMscuJu9fMm3SywiBrTgqw7C5h87Woch1Bo79w26o2C+C4ZTZVyW9cz7W21kvQBnmHh13somnNlpfqPHP1cPQgDW67CwjH9c1OvO8wCMoKeJQ3mWZpIKwemuHkg1bk/K9pjtbg5JOQWs59qbtDmX8YitXW7hKwljMnoDE+21ERn47mJSVSxDrM6nZIli1XDtW4Rr9fiq3ZLEYmAPwC3naRGKKTJKfbFovFB90C8lKKhn0
 u0k6Pv9N
 0FTiOTojY/OaYtdNeBf4ss5jgFte0hUBIrPUcYPQgc9UbUrh1p1CEXrZ3xkFtePQU6Oa8HRjeN9lTm+dw37FLN2Xzm6lKekBHr56WtvmeQc1gWat7WsQRrxHLmZWG7xk9maEtKSn+AZUhULbnMtD7Jt/JD+0EzdOtHmEiZQYTXuXALrthHZ9nxHSHkXyzBKG1EB+VT66YB7TvkJJC3TE7pB2fk4p4C2hrMbzS6lfxRbxb1uE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 17 Oct 2026 00:45:43 +0800 Aveline Noir <jm5905938@gmail.com> wrote:

> Hi SJ,
> 
> On Fri, 16 Oct 2026 07:29:21 -0700, SJ Park wrote:
> 
> > If both of you agree to my abovely suggested/agreed changes ('s/page out/ pages
> > out those/' and 's/records/charges/'), I will update this patch in damon/next
> > tree with those changes.

I was wrongly thinking this patch is already in damon/next.  It is not.  I am
waiting for Manuel's replies to my review.  So I will not do the update of this
patch on my own but wait for Manuel's answer and revisioning.

> 
> Both changes sound good to me. Keeping this patch focused makes sense.

Thank you for confirming.


Thanks,
SJ

[...]

