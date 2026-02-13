Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE9BFEF48DF
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 08:14:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F338D6B0005; Fri, 13 Feb 2026 03:14:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE1896B0089; Fri, 13 Feb 2026 03:14:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE3D46B008A; Fri, 13 Feb 2026 03:14:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CF4076B0005
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 03:14:16 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 469AC13AC89
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 08:14:16 +0000 (UTC)
X-FDA: 84438720912.10.79AF029
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id B6001C000E
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 08:14:14 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WS6gPhEK;
	spf=pass (imf28.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770970454;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=drJSL88wJEdic9IrLagp2MyydYF3Ujm3mOz7Pd5v97I=;
	b=dq03oioVRrPFK0Q7T3ZOgkPC3MReuoum7xl7t6oDQsQBhN3sPpJx/QlvkHDcSQkEsG5daH
	y2Q00n4Er9IMtKUttBoYSsKpEiGI23Dn716mY8IDhvfM+02HbuHpMYK/W8jcBxbtP+MgGc
	01lwEDW6jhLaMj5HRhqr1SqcqBP6esw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WS6gPhEK;
	spf=pass (imf28.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770970454; a=rsa-sha256;
	cv=none;
	b=LWlXF4/4Bp3e32AAV5A2kfB5k4IQf6FBZwaUtZtyo6aKxtYi2JSDs9HWyMrQd7GeFFEmsm
	eKy8y1fl2Sl7Vt6/ziE1CDa8TSF9n7GKNJrYss7Onpn0gMw71o7ZsLFz5HSLtiRpBunwfV
	ixcAJxv/udk6RwMoMebrnIai5oj2IoQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 113C16001A;
	Fri, 13 Feb 2026 08:14:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEBAEC116C6;
	Fri, 13 Feb 2026 08:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770970453;
	bh=KHHTft1r98iNakUAiYkr8HqIRyfuvhWX5WhKA9ZdSRc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=WS6gPhEKIYL6CcfVFVzUzZicQOOWYpxvpbVxDK5yZ9OqKUo70EGywi5PTxpLamE/h
	 mKcIO06idqIt2V0bd07gfrnMFcFRrJMkK3Zh4+xTAATSr9KFxJ/mKKifAZOFG6bwjU
	 mDOzFezQlCTdOPIMJ4pdDqOjy5nR7y/fCsSyuvYarQvCZn1cqakOfaG+9rmCM1K/kG
	 t448JMX7VPzDvpTZVgkIeIMqAQUtCFfYsY4pgsPV8T5H2bRemPH9zPMoYcT4PpuBD9
	 GI8CUZBS10Qap0pi4IVtOk5kn8BNDWaQsHmcw7JYnTm2G73c/Od6D+d0j9qXg5XYTY
	 +k4Jv52VYOQVg==
From: Pratyush Yadav <pratyush@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>,
  mm-commits@vger.kernel.org,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] non-MM updates for 7.0-rc1
In-Reply-To: <20260212104956.1bf57d3b1e91586aa95c9f2c@linux-foundation.org>
	(Andrew Morton's message of "Thu, 12 Feb 2026 10:49:56 -0800")
References: <20260212104956.1bf57d3b1e91586aa95c9f2c@linux-foundation.org>
Date: Fri, 13 Feb 2026 09:14:11 +0100
Message-ID: <2vxzldgxqcvg.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam11
X-Stat-Signature: etpjyykqic56mje5s4rusrg3r789cxfw
X-Rspam-User: 
X-Rspamd-Queue-Id: B6001C000E
X-HE-Tag: 1770970454-5042
X-HE-Meta: U2FsdGVkX19Mte32ESk0OExwBRf6xNFQg5Fn9ObB5Y3gUx5cYzkNa+e7otOzPUpSuCHe5HhjkwCceolhOb0jP/n+H4zMnxKsitVxY8r5TP2hGGAX7kdzLtW3MZ4TAMc6C+90cKnk/Og6xx/+H+MB57M+7hJXwiiabCcxFikTfS2GPtt59gikeHV4yzMcaoRs708bkE46tArizJSXkvDQY0BDXDg3E+luUr4ImBtK9H0LoqtWfZy5oKPaPDsaVOG03L9rq0wHOMDPpHPuZyCE3pPOaVU21SC1f+ZMhIjLHfWNdSzHKziYsu/99fpEp0Htrlm8UH/7H8wuORsSOIEyxEim4o82KOsWpMNJ4bG7QpeoXTWCbH6yx3bHLYNkhUKGCWcWV0XS/OuSO/I5r0IEf9HjZJcBMmuy43J1VYZe5sAVw+v72LRTUhs6qia4p38JYMW9xjp0oXpqwtwlhXsP0GRt2a1JYhC2jNfTg1+fEaHt0Z9TODvhk9OUSon51T6a1smG0ojqrfKI6s4zrIN5tSkiZKlyrZm+sVYaW+tBq7i9WZH7RiWZ9PZ96b6qQMkN9DcErqP/8z7P+u2uCDn1mlbuU7iBmW+fPEz0IgQtFBp7VpMIxIAJWNv/C5x7kGDeH8wxhfSysbPzUkU2ff8pOGQy2wJOgn35yzO9t/ex/kGFGch3JxHgTkKoiAlSBKRyAub5Lrod/I1WHXcQ9PLgppaAavRi4GlMlXFbmt0A0q0UvN2RMdosOFihtqJ5YWNdROWuWMmKry5kPZqKeeWJFftVHWAFlQysf32ZBcoEucbWsdIH9Uib6CmiWn/+eRmOmSsXwRM3Nf3dQe5T+n5a7oCTGiy6bKkcVnlTdXwbKTCrQCxNyhxOT5+TsupRufCs9CSjAvfGakCnqw+qjqonWZW/B8twZyN6VzxIOq3bodIXfCvBaxj4aQh4nelk9Bc8fpAZIXn4vd8o8uheqLk
 BuMy0JOp
 AUo9U4+sv/ebwfZebYuOtMo1RMm6s6z1ACTzDih0tRzzvWrZWhPRZchFZcTix9LszPGQLQZTpMQ7N5qyiJky4pN+fl5JvQj3Rt21fjpsyRvYqQ+atx+WGPEAJsTB8+8ghQXZuuK3BUOa/V8YoqKXtbrEH3xbJ5wTPCzOW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 12 2026, Andrew Morton wrote:

[...]
>
> - The 2 patch series "kho: clean up page initialization logic" from
>   Pratyush Yadav simplifies the page initialization logic in
>   kho_restore_page().

Oh, nice! I thought this would get dropped because of merge conflicts.
And I didn't really have time to do a re-roll past couple weeks.

I think this needs a (purely cosmetic) cleanup because of e86436ad0ad2
("kho: init alloc tags when restoring pages from reserved memory"),
which was posted after this series but landed earlier via hotfixes.

Will send something shortly.

[...]

-- 
Regards,
Pratyush Yadav

