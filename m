Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 055BEC44520
	for <linux-mm@archiver.kernel.org>; Sat, 18 Jul 2026 01:07:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D22F36B0111; Fri, 17 Jul 2026 21:07:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF8C26B0113; Fri, 17 Jul 2026 21:07:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C35C46B0114; Fri, 17 Jul 2026 21:07:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8B8986B0111
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 21:07:03 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 09C6D1402BB
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 01:07:03 +0000 (UTC)
X-FDA: 85000108326.13.BCA2EDB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 5F25A1C0003
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 01:07:01 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Izo+5/qw";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784336821;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vk91zqmkPVUe7yFQkVR0enbUPDMSCZSzWC7GhPFYNJk=;
	b=5gyf3i+BCSxTlR6CxK7EKC2kUaV02GQeRPkD171SqSFHbUzgAWqBTQtC7ySKr+Xj0yx0dh
	vYTfr00nffmFgnd3zD6C8l93X3IuSGlI/VpAh0xslCI9Lmk38TbvApOasNYufAJaC8YjFk
	Tv++guncdOVd1BaXen8ZVIKgK00RTbo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Izo+5/qw";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784336821;
	b=GJ2lKp2ZKhFUqif9OC14Z9Vr3CZdd3e4/rwvI2+i07jx27CWE2hU07khvhBiiu0wYFth9I
	G0J5nh+0ZTAyLsA3Dtw2ox4Z901Qbj7C0jT8wjtyz8p5Qvpy4pDf/n6crnOMMhdxv2HP0M
	BA3kALhp96+a8Fslq3EFSW9ik9w8kXM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8D7FE42AE5;
	Sat, 18 Jul 2026 01:07:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FB611F000E9;
	Sat, 18 Jul 2026 01:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784336820;
	bh=vk91zqmkPVUe7yFQkVR0enbUPDMSCZSzWC7GhPFYNJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Izo+5/qwMP0EU+kHudTvtcAvadEZX9z64+UjS6Fe3fAJfIZJumtZyi6troLLmGJr1
	 /T5Vut5/Q5L0T3j9lKhtHoAY6E8KDAEyezaMSp4gtLxrdjGBGZKhxr+UhdoR0DXhAn
	 UXFyymyuJmr4M8tlUi5TVS8Na5LfyYbLvx0F2AZ4R/nOb/3xdI7mIydmU+0nZXhY4C
	 ZxGNCKMU5KXMXQL4XMldQ5HRpswHQNWhZ3Fh0WGXfzkG5g2FndcRv/Vrtc8SN6cct1
	 wFJRYDefvfJ9HPvqX5AiZIydZJLQ42iH9fd8/zwHonnCRqutZJeywVfylNMgg7tHh9
	 zlZ+0X7ha0w/w==
From: SJ Park <sj@kernel.org>
To: Enze Li <lienze@kylinos.cn>
Cc: SJ Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	enze.li@gmx.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/damon/ops-common: remove redundant local variable in damon_migrate_folio_list()
Date: Fri, 17 Jul 2026 18:06:52 -0700
Message-ID: <20260718010652.92773-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260718002125.637104-1-lienze@kylinos.cn>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5F25A1C0003
X-Stat-Signature: mcnxzu7fyqn76qajuw354du163uk1rde
X-Rspam-User: 
X-HE-Tag: 1784336821-699853
X-HE-Meta: U2FsdGVkX18aMAT41pwIY+vSbiObCZ8oJA5i9bXaUpdahfiBfolCA8pTfil5ldfz00ibEF4WPwL67jySXrOD/qrwTST5Z7Gec3cLVcsEE9y2pWjdEziI5xytRh1uSN9ufrKef//Vmd8aOEwexlw963C/TDu3x8LZdOUYZPSYcLCNWvTIdKBMBjeu+3HCMc3BL68acC07EpeBpO44byrq6uYoE447+GIG10UfMES/qivDYloyayY93589rXG5FTmg7S5V737p9rNWcBL8vTm+tgHXMvVZej3WZHoV4lf8DDy9pt4au355tOP4Ntgyj5dJxPxhyiw3JWUsUrRHkuhDYHGKg+ANVLe6pANox48qs2xhOIEwezdG2UVRkhgD4neD23Tqw8a7L3KFGkDImd95x7YwoXEeWBERXQfySVquEXjMlwUHdsMO9gJ9NHOzn9qhBdyioL2cJKUbpj06+QP0N5IECW0uMOn7+m6FZwmYvZDQ2H727A4h63g9UeUi+h6istdRl8qSHqEHtytUy5Ut3t9S/SSPsaB/VHFIxnfGAcRwp4qwLf1D/y0lZb/KXN3vnI0xvkWGi41FJLI51HfQyd02uNb6rMRjDGqe0dlwlNJXbvyQ6dXq7HaPzQ3EOsVOqeChZrkAEPUWhUj8ga00qJ+DDS6Z+NDBxE8IFVrZE+FFtTWf0GIrPD7VDhrNGhIMCvApcN/um0u3W1XG51EnhpoIB6zibeS4gG+M+VUwT2/5A44VoOaxhGF7GjOFG2RH1IZ1JSCz1ZVzoVrw5/lTClr7wWik4qO1FIUAfZbsJ63dDMT2QJN1jFHh6NXhXDlh0ZEuLVz8rN099uADwfBj9XpxPVC9t31lZ9FPqCKDB3Kc13swh02RxOyNjjGke9KlmWtMSmAKoc1hRqsVHW2oY+NkAi60vF9m/CDH7TnKukOm2oCdxluEYClBQnmF0bFbuUfxqp2WeG7M4390cX4
 nd5PtuKx
 tzeKNGKhRPfy2ztxZc6PiEWYC8kYcbsK5t96qbitLvqbu1XeInHiikfE1UR2lxuJcBZCCFnE7erQulniRpn3N7TmXJn4tyrb8eUMnz36VSjJrqAaELSxZDR9ZVbLMYYIjQqofVAIrWwetM/hFKjqewZdUTntzw7Uk2mVfcJcVQBLfF1ALEMrpbS/wEfA0w9k+oTomPfc6qRVIvKz9YVuh3mJc5SfTBnGQ7V05LHF+kUgXTvd/A4QWgQKG3924MZShsP/5AFeE4oo/ZL08N63f/dKzeYXmY/7isVFMUJaNB9ySj0d62ghg2raouA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Enze,

get_maintainer.pl suggests to Cc linux-kernel@vger.kernel.org too.  Adding it
to Cc list.

On Sat, 18 Jul 2026 08:21:25 +0800 Enze Li <lienze@kylinos.cn> wrote:

> In damon_migrate_folio_list(), we're redeclaring folio inside the first
> while loop, but it just shadows the outer one.  Since the second loop
> uses the outer folio anyway, the inner declaration is pointless.
> 
> Remove it to consistently reuse the same variable throughout the
> function and improve readability.

Nice catch!

> 
> Signed-off-by: Enze Li <lienze@kylinos.cn>

Reviewed-by: SJ Park <sj@kernel.org>

This patch is applied to damon/next [1] tree.  If this patch is not added to
mm.git in short term (~1 week?), I will ask mm.git maintainer (Andrew Morton)
to pick this.  So, no action from your side is needed for now.  If it seems I
also forgot doing that or you cannot wait for my action, please feel free to
directly ask that to Andrew.

[1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees


Thanks,
SJ

[...]

