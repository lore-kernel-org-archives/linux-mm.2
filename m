Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53647CA5FA1
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 09:39:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DFA36B008A; Tue, 29 Sep 2026 05:39:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B6CD6B008C; Tue, 29 Sep 2026 05:39:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A6346B0092; Tue, 29 Sep 2026 05:39:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 15FF76B008A
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 05:39:52 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8B1A6140453
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 09:39:51 +0000 (UTC)
X-FDA: 85266302982.15.FE5A7FB
Received: from mail-qv2-f41.google.com (mail-qv2-f41.google.com [74.125.230.169])
	by imf15.hostedemail.com (Postfix) with ESMTP id 81343A0004
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 09:39:47 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=dgu-ac-kr.20251104.gappssmtp.com header.s=20251104 header.b=oZhLoesJ;
	spf=pass (imf15.hostedemail.com: domain of ts930@dgu.ac.kr designates 74.125.230.169 as permitted sender) smtp.mailfrom=ts930@dgu.ac.kr;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=none
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790674789;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O6zidI4zTNOj0TGHNQTaUW2cJSlvWPwFzk8EpxAP9bc=;
	b=clPbauUEXvLmesN8vEeuTrqtKYpdKgtJ7EdX7jgX8gFoOqMlTmM8yENSonkEdt/YF0YVA8
	j/BNAliQFHxKAvWhdyF3h4BFlKIF/WIZgxbbReGoAKuWMbFClJyzEugT9vqm8uL/3SGGfc
	ozu6/x35+ZyessbAFcrlznkVeEjAWnY=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=dgu-ac-kr.20251104.gappssmtp.com header.s=20251104 header.b=oZhLoesJ;
	spf=pass (imf15.hostedemail.com: domain of ts930@dgu.ac.kr designates 74.125.230.169 as permitted sender) smtp.mailfrom=ts930@dgu.ac.kr;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=none
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790674789;
	b=v3sbQQ5ZBUk2AMRCFkgHlja9skbwaYV/bUGA078zzlYbEFLc4I/PviQxO+btd9NVzVcU/q
	4RpKhfdHTOVbc33cgHarVBxi5VnfoPef5pDh8B0EgIyL6tJbSrYi31sTc3Se0fyk+OWxaj
	uuEyWVTXZa19KCyeBdr4IvB6EcwE0pc=
Received: by mail-qv2-f41.google.com with SMTP id 6a1803df08f44-91782a91a3aso9627466d6.0
        for <linux-mm@kvack.org>; Tue, 29 Sep 2026 02:39:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790674786; cv=none;
        d=google.com; s=arc-20260327;
        b=M6VNCw1MA+4694mz0UcUzsZ6CK1X0DyN5GPZYmdkNE6IH9YA/mr5hV7DIkVaUT6BCr
         jUzs1PtfI/dcO9hIfN/icalAEFjMP1homegDectTEVNvwStl49uCJEzzq+A5BcS46cDC
         P/CVOmRrWrQaKDmaUb1sKQ3M2zsQuo0g7LdUglRSj4vAfX6400U+qhDwUh7JT0tn6qM1
         5Hkw7BmMvdHSrTS9dzWal1mf215yLeNQ5RQV5x/pDGFLmFEjYSl1h3wLfvdMcQzBD+65
         HSFyt8ly7OiY52FxWKoNGmQleuaLaA0mwr7+m4w2AupOH3lddncpIiJCJtsqvR6VzN6V
         APsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=O6zidI4zTNOj0TGHNQTaUW2cJSlvWPwFzk8EpxAP9bc=;
        fh=YtM/PmgZ+qLXU+Vk/+zgv7qTzbKUkKcnY6kmsA5JP4U=;
        b=bNrWzoKq3spjsZYRF9E6/xMS0MZ8nMNDdUXoux8sQxXiqb/PTAhI8LOkkSyZFOAiU/
         uBcBJL1dczIROkBneYhgf3tWI/JowgTwnV3Dj/crMmrKKr+h2ui+fhg3idYQq/S6i488
         UxxO39agGoUtRIHwgB2W4Omi6OFQtFBSeqeAN/rljD5kQCBqkCIFvVchJ+oFhjDUvewR
         QM4GViMQf08tgkqogBSZY9L45yJEgtgIxKcAHJ68jOojDfMJOMqiyrLp3bWp9NoMcWo3
         p0w3Gt7aPkT0jNHZHhkG/5A0g4co9VO86w7jbFKQ9t5KwTFm0zxeLRNI2ESsUDiY5wR4
         x/PA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dgu-ac-kr.20251104.gappssmtp.com; s=20251104; t=1790674786; x=1791279586; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=O6zidI4zTNOj0TGHNQTaUW2cJSlvWPwFzk8EpxAP9bc=;
        b=oZhLoesJa2BKBinC3S8p55ZrSEais2svPLRONuCszbmJxfwZBavA91v6bkSu0K+9+S
         kPlgqeWcoPRCkLhaYJtsbml/BXusO1AMuZuQino7lUYiz+dnxx6hZY38kw45TAbIkkbt
         mkaabCNql3N7Wi8tZjIasxxJM65uL9RM2ro4aKUgVUEKgImevrEmzzOQNBWmyUCArtWP
         qKWPywbMUZtpCIDOSEvUT3l+rnR3rLzCdJqQWnGeP7dlbuuqZ6+wJK068VzOBCj13Kjo
         sJav9Lr+/qZF/rA4VcZB5J2aC+O1r/EGSwGjBeSWMax12Uum5MbriaQph3vEG4Xg7mJ0
         II1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790674786; x=1791279586;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=O6zidI4zTNOj0TGHNQTaUW2cJSlvWPwFzk8EpxAP9bc=;
        b=E8qfLjNCMuEQUi3nsMr8SOyGfb6bWWZrg3rjaGWQAZqxGZg1yMZz/L4Kq2aAve1Yep
         8092Uxu9jU/5cyYr6jcTg85AomETVirQFzR464VO2IYXH4wQfbQRCtDHBMe9wZg0biZj
         ayZZ9d8Y8Dda/4OJu+LqFPJQcrIrMQbXavNuYaKmxQMkRYvcUsQDBZlcqEf24vPj8VRu
         MSl0IJnSJyEF5wc72m4BWu12VaZPxyBGyNgLX1kx1/Of+XuMtTN8nqPGrCSYhTQ70UyG
         HL1/C9LpXA/wVgXx644GvPW0vGBX8LLbApzi7a9IssIfTvmX4+VA9NgYU39TvC+495pS
         s2/A==
X-Forwarded-Encrypted: i=1; AKwUvBziDTKhSpSqQzt4RUa4TUEoPi898wau/7ohVyj+nltkDxWEi4wu0VGfcxuv+bkhLReCjzrRqb0G+w==@kvack.org
X-Gm-Message-State: AFq9FYJbbcLmd19nw7Tmb+g29Mom7lZz/Fkasb1HYcyVw3h4F/PQem4N
	RZ3mHcIzqzmt5LWlqwW/kNyjFZKtRbE8pVOBM+ovwR9HHyheto1bOPrxWteCNEfr4Hdjx8PqgAj
	5gxYDKgIoyDl6D9C3wHkgkx1ijyf0YJFiDRsP76HR8g==
X-Gm-Gg: AYBFou0QXoKrIztwhbJBo7sI+B0Xq4Jxt8EB+sgciDq7MNA6SjPpi4+J6KNbLZc/jcA
	6+Cgz9HNvQJ7QVsFnJaH4pMUCgVZRr1f+b7WRANdVM5EewvJjLAiTXsbFlG951DWWbyGgq372vO
	GkRsGpn9FqGtRSzjm66eLB5/wjbM9vW16UTdixn3/jbK5diDqe7kWn6srfZkvFOhtsKWePKbIbp
	/m7FjcamarxiP7/DrFriGuzg7tzO5eYEME799RhRtLiOb/LmJ5inyaxcY4NJKO6z45UPAvXhBBE
	2aIw/ae/KHizjsSZ7zQoM+ZmpVvXNI/a0ZncNmE6R9+kzOldhK2mJ3KEoA==
X-Received: by 2002:a05:6214:4a88:b0:910:345a:f453 with SMTP id
 6a1803df08f44-91432483830mr243057896d6.36.1790674786553; Tue, 29 Sep 2026
 02:39:46 -0700 (PDT)
MIME-Version: 1.0
References: <179066531783.50175.13377521828379196177@dgu.ac.kr>
 <3a95d0e5-7969-4b0d-988a-ead62b06b6f5@kernel.org> <art6x0XpWcT2aUyy@gremlin>
In-Reply-To: <art6x0XpWcT2aUyy@gremlin>
From: =?UTF-8?B?67CV7YOc7ISgL+y7tO2TqO2EsMK3QUntlZnrtoA=?= <ts930@dgu.ac.kr>
Date: Tue, 29 Sep 2026 18:39:35 +0900
X-Gm-Features: AclHuK-TKGufm6-Y2TQLaPocUQkmdwuwTHOz-rtMMxexWAdTwmo5Rynwnpmf1gk
Message-ID: <CAFPGN2jPGhcWVqa3k16RWMaMR3TwKyhFbYYF4D3L6L85T8E96g@mail.gmail.com>
Subject: Re: [PATCH] mm/mlock: fix zero-length request normalization and
 integer overflows
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 81343A0004
X-Rspam-User: 
X-Stat-Signature: fzmomd1zxw4fxqbwirw75b7w8qckqo1d
X-HE-Tag: 1790674787-201739
X-HE-Meta: U2FsdGVkX18p4x1QgjLOU4Lg0fNVPYfRTFdbT2sTfle2MzVAvHAhVjkBshatO3HPmluLipOVszqmhP7TN8K/ULYMr1bKlnfidKUbtKevHNlvMgI7emR5PR9Os/wm3UrEjuCBMc4ZeEFbUEZ2faEcB5xNzQgULL4vNyG+y49iRi+9aS1REutovjjvLIZNXjSj7Xa72D6yPWK4qck5Z5X/JC0zqL7NtvrnvcuMjisfTL2miusr9FbOKuooidyxlncQDHp2jg84vInQPddWbsF950khDD1XBPsYhHG2nBld8upjZ0UhVlMZ9o5Z8X+HqGJYHbU0e5aRnf1Z5qSYsI+cQ85h+r9+3iPtP7uOU+HNQX4LNtIF0ydlrTcAdcLoJHI+nkOFzSdibUXme3DuPbRyryX13/7eHch2gonPgEJjHOWwSy4E77+PDzIXn56QGgtT1xNSkAVRqAuNJLoE6lU5Sw33UFz7+cUEpz49aohnHAeiFA5zkslUCvcbx0pOwADV6Quu3c52hJe4/Mgtkhm+mVdCSY/ahxHVm3+wcOLv3IMerwdEGrwLxGbGVT7EXbkkehqSZA2MszfQMfMkQgOASPN7ZSoAoGXzcEsD3oXHeisWxa/LfO3W2YzWVlze6ygwQTifQRT1hAIGRGy0brAqlvDRogAfZxkgPyRB2iaQb8yKcyfvSF6b9S23374UCnI4h08SOBB4JSy40Eg1iH8F/xyBMcjcBxcnwLrgTm6IHs9cyJ+xVdtB7qwYXwJ1nQIBWSnUD8sCW7rhRfKlK70guJZk5nqxg9bWHuAYG7BO592zy8KrJkSJDOw8c+L9jitS5CcjvPJ8eJZCK6alk5KnxwAaP56U8viPachAc3r8tBXG+s+pSzSEQo0hHtTqDbiN0Tbs4kemWo1dj9YJgOCy+IkBaVXfam0Is867hGkMgA5iJhBjNcyuI8iJoWQt2HoU/MSFX6Y+wGiSB9vjNFK
 xJmJH3q3
 flrCD7mdPck6aZ6lKxMkx8AUzrVNI7Sa5mNQEtPBXernSnpH7gUCCSc+YJHQDL85UvdutEffDCZJnoEGBMi06n50Tw2WQY6bbwuZ5AsC8dsLhIol33R7auN6inS0FRpYPEWsBNVNqrmJBEvXq7PBZO9RHDq15KTqfx886JH2pKwMUJgJbumiRCfXACHIvG3FgGv/rzIda0PRk9CO5cj/KAimEqculI+A2F/qG7osfDsrHimCBYeJiRz9u2hCA6JvR+DsMwPM4lOVsEdwiqHOlVQ++3TT58wanXCGu0wUQnWXy/nkpM20jlVIJfgYpjK3xGZE7pT38ONOcFyi6fwZ/V8EloiQwd4ec8O4smhJRnxEi7f9J1I7rBDnw18QZpj0DiYhJyfz2OemUB7dpm6mgaWSiYg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Understood, and thank you for the feedback.

I sincerely apologize for the poor code quality and flawed helper
design. I will be much more careful with commenting and ensure future
contributions strictly adhere to kernel guidelines.

I will drop this patch.

For David's question regarding reproducers and user-visible issues, in
case it is helpful if the core team addresses this later,
here is what is observed from a small test program wrote checking
/proc/self/smaps on an unpatched kernel:

$ ./test_mlock
mlock(p, -1UL)    : ret=0, locked=0  (silent success without actually locking)
mlock(p + 5, 0)   : ret=0, locked=1  (0-length request falsely locks 4KB page)
munlock(p + 5, 0) : ret=0, locked=0  (0-length request falsely unlocks 4KB page)

Thank you all for your time and the review.

