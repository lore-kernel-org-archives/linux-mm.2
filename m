Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FE22EE57CE
	for <linux-mm@archiver.kernel.org>; Wed, 31 Dec 2025 01:25:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC7796B0088; Tue, 30 Dec 2025 20:25:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7E6B6B0089; Tue, 30 Dec 2025 20:25:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD5686B008A; Tue, 30 Dec 2025 20:25:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CD41B6B0088
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 20:25:28 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5466DC1C4D
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 01:25:28 +0000 (UTC)
X-FDA: 84278023536.05.A7CD2FA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id BBB9F100004
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 01:25:26 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ovjUx9Y9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767144326; a=rsa-sha256;
	cv=none;
	b=li0cWnc47cGJ4+deh85sFMIifUiVIC0KbBdJuWREE4mhjcu0xE9pwMFdpjtee5FvS57fXQ
	4FjPkrETg17kPdlIC9Ctdrr1DBeHKQj75vooVMWGOcbSDfYmNAHbH8xXpZKEiBTDZGLmM9
	5ltU4UC0KjFXDRLXYjFhvGWvql2Vlko=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ovjUx9Y9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767144326;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D7UkMcRrOHQpxROoJUtRldw3KlAmP5KWvruhbYyfLg4=;
	b=CeFpPeT9fJ9h5Mq9W1JPOu0KKpJcd6vL7CJfhsEPHISFAsSxBzUTRpxjf9d2h6xtqoxc67
	F7uV7hc6rbeLuEKuKK1OiEoOBaISjWmsuBOqHB//wboxChkDxoor+IxcRm5hb1bTEYlh/I
	Le2yVa/46s4DDxxqsGvQADZS+l81+sk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2A93A60008;
	Wed, 31 Dec 2025 01:25:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94C93C116C6;
	Wed, 31 Dec 2025 01:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767144325;
	bh=O5xxeuSOtbrcGO6p0D++q4AK9X/cFtiDX/QhXReUnnU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ovjUx9Y9iiMW5glAhyrYp5ExTgMJT3Yl+5KuUqsL8mwD23ntkR9sDaM37MqmLcAPm
	 c3mZraznn7ipiZOCFmczpodFb95ZPd7ZZWL0VyEHDV0KSikwkN6vX3uaQT86wOBY/t
	 wlxPoo2Or2IkubTHkzVyEAlPOHsnbtv0PLiySMO9LZqZhBdhxoZxeKi1/i06b32Nrt
	 OCJAw2hXYu/16iPIHFqfV2crQo8Q6hF4mm45dpG6hOMaXvS3qohMjhXLb1Isnz3V2y
	 a9H6A5Q6/XQ3cOO/gz71nZKzXLylxfRBQ23CG1ILn7iKXvQbh/EH659XEnT4bdfyy9
	 0/RA2rf6/CbUA==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"# 6 . 14 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	JaeJoon Jung <rgbi3307@gmail.com>
Subject: Re: [PATCH] mm/damon/core: remove call_control in inactive contexts
Date: Tue, 30 Dec 2025 17:25:20 -0800
Message-ID: <20251231012522.75876-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251230034516.48129-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BBB9F100004
X-Stat-Signature: dt736z4cie11huan6nxobnk7tcr8it6m
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1767144326-315319
X-HE-Meta: U2FsdGVkX18ERKqpy24y4yIY7nkJ89113bZ3ILIRGQnf4nGVVYPPFdX7re8Bodmk2ukN2DSCDn8ErPmgAawldmbjoktckCu7CBTWmnVm952OIBKuB5pblTEnVpo7JJjODB81TW/AfJtyjGVXdb/KIjKkl3c7EukcEdmiMQT+IZabOgLHkA5BnUaVfQKxV3F70PO9GXqKfHF4zZQ6HX/LZjUXQ5yGJTUdNZM8FzYnWDJsfVHJnOjKRsDqvVqv1ruwl17OYzGXM/f1Fv+edzCsduL4o1/rGQlVzDdCC4yBUb0mqJL0hXPXjjOCSlf9Br6G4sXkGgeaGYsPWuRh/hviCHliYmX+ZDMb7ey4dD7fcKQiMZUKN+CaOg2HcAzcnqcw6XrwWK7z4KN7POmr3G2gsBylK9Gr/7NiF9R7aXT9hTGvG39Dxc7Vw1PoRkNF4x991ajhifVjt+eoSnE4/huVkSW+KOtetlFPe2ljh5ETIRSwgbzRa1jdp/Nj89lmn6bEwmkvEpWQEGdTRZPVTf41K/Tq2aFVwfzx4A0Cb53gWSrtyw7VBUGX3Pw3iP5febMqjAKJdUH/Rah+K70mtJ8HV529tvi+WLRnYXgN2jOLevETX9vvlDFgh3i4jGkE1g2ILteOencmR6zO7xt3upVMKJHG85NCv8zTKXLSSPPNv22UGBKkkpbvV1U55QYnpdGCws5sP8rh5JoEkpNoure4Azuhn6wZ0qvpIQI6VLg3vJ7w2Lra9lPAkMOGec4OxwJJjRJve1v8Bz8YEhuCOa+xuXVpg+OT2XsRNeRu1yJAObGFojn9mzx35TlquGiET5lT7oPSLAIK+j9ln+4vgDESKZcJuQqJ4/ophUpze6VChVyrQPkgyG1jqMqrU9zqACmC20a4zSXzUHt05m4Z63nGCYPFkmtS5Pi0FXVDocr3mrkiNKdZsrf2Jz/hlqULZsczxPoOso2f0pm8xhWPfHH
 eUb2AQGs
 oGqsFfdoixzxV4/zXyRplHIudMqMqjruyWzC+hPVpvqQ9YeV565ocDRWzVCfhOIejW8XFbaxeDiOubzN1fthL/Vg97MgXBA80oQS0nrjAUr7O8YLo1noNC7z/01htD4YgqJbjRWgdZuB2fXXc0V8Luql3+oQeJQmjfPvpEVwA5HaCVWVEyTgi1p2292E+tUwgTdZtt4KHolsybdzIviFGWPNYhuDi701czBmoUAVzZgIr6Uo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 29 Dec 2025 19:45:14 -0800 SeongJae Park <sj@kernel.org> wrote:

> On Mon, 29 Dec 2025 18:41:28 -0800 SeongJae Park <sj@kernel.org> wrote:
> 
> > On Mon, 29 Dec 2025 17:45:30 -0800 SeongJae Park <sj@kernel.org> wrote:
> > 
> > > On Sun, 28 Dec 2025 10:31:01 -0800 SeongJae Park <sj@kernel.org> wrote:
> > > 
> [...]
> > > I will send a new version of this fix soon.
> > 
> > So far, I got two fixup ideas.
> > 
> > The first one is keeping the current code as is, and additionally modifying
> > kdamond_call() to protect all call_control object accesses under
> > ctx->call_controls_lock protection.
> > 
> > The second one is reverting this patch, and doing the DAMON running status
> > check before adding the damon_call_control object, but releasing the
> > kdamond_lock after the object insertion is done.
> > 
> > I'm in favor of the second one at the moment, as it seems more simple.
> 
> I don't really like both approaches because those implicitly add locking rules.
> If the first approach is taken, damon_call() callers should aware they should
> not register callback functions that can hold call_controls_lock.  If the
> second approach is taken, we should avoid holding kdamond_lock while holding
> damon_call_control lock.  The second implicit rule seems easier to keep to me,
> but I want to avoid that if possible.
> 
> The third idea I just got is, keeping this patch as is, and moving the final
> kdamond_call() invocation to be made _before_ the ctx->kdamond reset.  That
> removes the race condition between the final kdamond_call() and
> damon_call_handle_inactive_ctx(), without introducing new locking rules.

I just posted the v2 [1] with the third idea.

[1] https://lore.kernel.org/20251231012315.75835-1-sj@kernel.org


Thanks,
SJ

[...]

