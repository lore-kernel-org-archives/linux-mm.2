Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8203CD3E784
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 01:37:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A93D6B0006; Wed, 10 Dec 2025 20:37:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55A216B0007; Wed, 10 Dec 2025 20:37:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46F646B0008; Wed, 10 Dec 2025 20:37:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 39A936B0006
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 20:37:17 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8F996C07B5
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 01:37:16 +0000 (UTC)
X-FDA: 84205477272.25.DD45041
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0CEB840006
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 01:37:14 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V6AMT8jM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765417035; a=rsa-sha256;
	cv=none;
	b=BFW/SQAKB67gW9F4sMJbtr4myxjRrXBASc87P9BKBMBqVT0N0ZjRKAU/I8k9/7qEp3wNo/
	360VPr22cVs2p1CXfh1j9y88mHnhEbc3T+Jbx9wmy3Oa9zZLmIcFQ91B9w5BaVChsAsdQM
	Vm9sCNEYfGYXM3SXfzoC47HaZ0sEHcI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V6AMT8jM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765417035;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jY+grogXXBnWjoMFYm8oVsSAVN+hszOu2GWT+9d/IS8=;
	b=X9HMYJZ7tzCezidV7Cad6ThRzTI+nMmmBUDlZupEtY+wi+BvnaG8H4A/PaH/pxb3pRXeU3
	Bym++iooQXT7WFlzXg55CJ9k/SzCza/ZtaAQfvWKoLxr3/qZ/bf8dbDdEOegIuBxXe9Kfe
	Gfo7v2i0ETr39zqmakY/ejA6VKOLzWE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 43E7760010;
	Thu, 11 Dec 2025 01:37:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF1DEC4CEF1;
	Thu, 11 Dec 2025 01:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765417034;
	bh=n+9g2JgdFj8T1N/HU2TUa1N0FmuWTTQ+EG/gxfX3CKQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=V6AMT8jM/NWZgAaaUGPPuWI1qMzBJz+zOjs4zb7tpTK7FPSUMxZQOkuEkuw7vGa25
	 QNoAWlM1YQ5qhv3qNEFLEYJ3CYdWKKsYtpwnjZGrZYOlot7FowEd8nbM33Lp2AzOA8
	 V69jxhN36SKUJpp1bj2ZcW0VkIo8xjN5tRfUG2XziOkPiU6vPs15XE60rjWp2FnV5m
	 WpOluu1qliViMciPhLMkb4Udyp7hUpcNt35QN4HGx/LbMaAc/3+qoTytZgrpGRFQ9i
	 npg1B49J7LiraRY0vLupKzuJVo2r1CAZ3WwlK+MeYLum7tCz0uRAwfQwpvpRE4n7mP
	 K5gi0nmY2EvMQ==
Date: Wed, 10 Dec 2025 17:37:13 -0800
From: Kees Cook <kees@kernel.org>
To: Alejandro Colomar <alx@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Christopher Bazley <chris.bazley.wg14@gmail.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Marco Elver <elver@google.com>, Michal Hocko <mhocko@suse.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Alexander Potapenko <glider@google.com>,
	Dmitry Vyukov <dvyukov@google.com>, Jann Horn <jannh@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Maciej W. Rozycki" <macro@orcam.me.uk>
Subject: Re: [PATCH v5 4/4] mm: Use ARRAY_END() instead of open-coding it
Message-ID: <202512101736.DE24BE89@keescook>
References: <cover.1758806023.git.alx@kernel.org>
 <cover.1765406336.git.alx@kernel.org>
 <e7bde864b0394dd0946b5227c6afac7c05560654.1765406337.git.alx@kernel.org>
 <A17C0418-E304-43DF-A6AB-0F142D7B8764@kernel.org>
 <lo6fdczvfjb5q44euckxi5thjrply4wqk62ori4slz54ivdswj@3c234g733gzq>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <lo6fdczvfjb5q44euckxi5thjrply4wqk62ori4slz54ivdswj@3c234g733gzq>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0CEB840006
X-Stat-Signature: kn5g81besm8nw5hm8amq1rojeh86zkk5
X-Rspam-User: 
X-HE-Tag: 1765417034-698647
X-HE-Meta: U2FsdGVkX18my1knxHtKc0XvSsHQvp2aXIqTEkrr8dML2w2ByNvCy1pv5sz4d57KlP0kEy6N66Tn0E+gH8hY1uVoR4fyGyWdif+hrWtmBqrKf2DbGZhF9M/aNpSevyMDXyST32H0AqdUCzmRmlAwPkqTVuMrEtNYe432LbWilCZ7lhTu1KJ85TB+lpUgZThLiXDOShwF8q4VS//2xlEwsKtiubOFhm3OdM8Y29c3PFwq0Az8tafzJq8KlO1M6rUTHSL3Uihg+DPiiHU+9vTNARvEuVboXZt1VgIVde3ZUoVfLvvci9Q/BBhjrknXUtiaUdAOdDx99huH3ykGy21z3yp+itBKJEeqxa8lKc53qqKIz95NN+T3x0FHY54A9wiYr/l6jOzq62BGRIAkbA+9Af64uEH201K3ormbqLwDPwoAv/EQOt6sFx/nzexYEMva404/5Af4dykEfJ7oHYB5oys/UjQdPKwWbTKf8ig6VQRFURsj4T0Y6NSEiA8XUQiUJyHpUs+o5DsacXO1TvwHCI8+N1AlN3ho+emxl6XcqCxRo+6/sqdVNQYn4FeZKdiqoHR761QOWrBe/PxA37Qbej85A048HnE62Dxoo1lHI/kT/xsbJU5+yACuYo5PvevDc5phkJpZs04YaOuTe+HwNk9Kd4mC4uleErXrN/qczDf3q0M5cE5drV2kj4P7D2Za00eH3+W8BNyJehWussSqUPCyPV3sLakhVffda/F9DM+pK5lrO8N6usv8HnuAdBokIntiXo4Lif+UuSIOsLe2LKxbZMtqk+IyrAfQVCP3lrsk53+uED6qvk6yX8UpFd7U8CstcJvrfEO07LqxgW8SHfs8u8WNl4YnJpfokpApgmawvWrLQ6xFaLMbWgIX8L9alUbQlK9zWMjQ/yu0D/UWLSJB9heO85tuPHJS0T7XTyio3gd5PY/aml6d86FN47/za3Qx+xcSsqhCGBhECdv
 jA+nRG4y
 C/RtRPNxS2w7GoStQALpuntDvugFfw8aGJDY8f41sZWK9/UBGOxgIdu9tMJE6PpjBPXduFRIEkIE6ltOYbLDEZ1wtQWk0cxB2oLBy146FzL5rVqjOjgyfDALoIhWm2YGHuiDFyp04pSJSDgdDONTLP8yWNVCpcClMjhuiRGKaZSYfz0KznOuWy4TV+eI12iHvxHr5/9xjyziPEO1mPAN0v9PKLj76zEDjvjZtjy7dgJZpox++Om3wiCYuYemqRVg4v8JZfiTYHvmxHQouLeIg64YzTTNg8iuz3X2djXqdLB4bzZV613ZloUJDfGRDGzjlAd05bwyiElFEqb+cMuo0yec3DuoDznrYgOJ7VtHTN7qfJwO8WxGVTAg71cnFvgtCWu/yAFEyvK6NpK3y5cXuRtQZx7XAeFVqY1DTHBS0gcnNIM+JcEItvwsnfRnit/BATQyusfYaiOZ7IxE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 11, 2025 at 01:21:59AM +0100, Alejandro Colomar wrote:
> Hi Kees,
> 
> On Thu, Dec 11, 2025 at 08:18:56AM +0900, Kees Cook wrote:
> > 
> > 
> > On December 11, 2025 7:46:49 AM GMT+09:00, Alejandro Colomar <alx@kernel.org> wrote:
> > >Cc: Kees Cook <kees@kernel.org>
> > >Cc: Linus Torvalds <torvalds@linux-foundation.org>
> > >Signed-off-by: Alejandro Colomar <alx@kernel.org>
> > 
> > Hm, this seems to be missing a commit log body?
> 
> Actually, there's not much to it.  The patch uses ARRAY_END() where it
> was being open-coded.  There aren't any bugs in this code, so it's
> purely cosmetic (and of course, to prevent future issues, in case the
> code is modified).  Maybe I could say precisely that.  What would you
> say here?

Yup, that would be perfect. A what/why, even a single sentence, is a
minimum for commit log bodies.

> > Are there other open-coded instances that could be replaced? This seems like a great task for a coccinelle script.
> 
> There are many, but I wanted to keep them out of this initial patch set,
> to make it easy to apply.  When this one is applied, I could work on a
> second round that replaces more of them with coccinelle.  This is just
> for showing that this is beneficial, and to make sure that you ask for
> more.  :)
> 
> Also, it's easier if there are few maintainers that would block an
> initial patch set.  If restrict the patch set to a few files, I don't
> have to deal with many of them.  Once I get used to this, I'll deal with
> all of them.

Sounds good!

-Kees

-- 
Kees Cook

