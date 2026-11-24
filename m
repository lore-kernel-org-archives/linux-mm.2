Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05FC8606A321
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 18:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Gm0E2FDQ
Received: by kanga.kvack.org (Postfix)
	id 1DAEC6B081F; Tue, 24 Nov 2026 13:11:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18B996B0821; Tue, 24 Nov 2026 13:11:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07A366B0822; Tue, 24 Nov 2026 13:11:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D6CF06B081F
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:11:50 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6BC24140C8C
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 18:11:50 +0000 (UTC)
X-FDA: 85470805980.17.50AE4DA
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
	by imf13.hostedemail.com (Postfix) with ESMTP id B294020008
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 18:11:48 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Gm0E2FDQ;
	spf=pass (imf13.hostedemail.com: domain of 3Y9MFawQKCIAhqroksskpi.gsqpmry1-qqozego.svk@flex--dmnk.bounces.google.com designates 209.85.128.72 as permitted sender) smtp.mailfrom=3Y9MFawQKCIAhqroksskpi.gsqpmry1-qqozego.svk@flex--dmnk.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795543908;
	b=z/B0a+/+cj/A+dpFZ5AGz5RW7z/waAwyDGazpQvWIi79tIpvePLdHps+rPqkenHfx6KclH
	D/3Z73f3tO5Ex4JOaNFFJvNyVNW5MmxhB4q4ZZ0wMQykfy1lmYmpQpF6w0ujIoGJ737qYn
	9lHJTYpwJ+5KqpyhGEvfpHr5H3e+sYc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795543908;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+evi02qRgPYlZDoGKcijTxE0vvQ1vdbaN0hW746h38I=;
	b=r0ODNvOa8UcBi0FbSQ2a9zedSsMVxTP5H7yJVZ19XCMN8ZkJAthLZ+pc9F0uxE+UeeEiPa
	Xywo9bUVgNhELMxR102iIT+Fy59Lxva4LfjY6X+QM7HOWITZyurhBU9WhXwUBixhaCpxUN
	8r1L0MoQiTZ4c0MFPl9ukVJg8LDWlik=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Gm0E2FDQ;
	spf=pass (imf13.hostedemail.com: domain of 3Y9MFawQKCIAhqroksskpi.gsqpmry1-qqozego.svk@flex--dmnk.bounces.google.com designates 209.85.128.72 as permitted sender) smtp.mailfrom=3Y9MFawQKCIAhqroksskpi.gsqpmry1-qqozego.svk@flex--dmnk.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4bb6bac1e84so31388295e9.0
        for <linux-mm@kvack.org>; Tue, 24 Nov 2026 10:11:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795543907; x=1796148707; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+evi02qRgPYlZDoGKcijTxE0vvQ1vdbaN0hW746h38I=;
        b=Gm0E2FDQsqvlvFMOJJOYdEqS2CbCHHwfGchcm2TuFBfuqEjMxudNbzHRqxzzR7d73R
         FIyZnWl9NQgrBlk4VytmR3MnEorDnR4Rvkab3rLuM8q1BYbepWm94zdeyILIoWYBDwTD
         RC3ahqzi1CIZ9Lunmis1tBgMzm52++4bjzXxWjOhBv/YUZXACkrftBvjuJ11agcqjXLv
         PCDTCOiqGY46IXA+IqGxRC7pLiq6ntojYEywFTHVgFI9grtWNlr4ukdBP64hF83GNhwG
         t0S1qPnd61Mty9DO3W7boM3WFYS24agXu1mEaUIs0gwFHyynfTD7tUz3kFXSUuR7raNS
         VyqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795543907; x=1796148707;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+evi02qRgPYlZDoGKcijTxE0vvQ1vdbaN0hW746h38I=;
        b=IeKzVGxRYw6+f+HD6i2G2POjrekezau2GsX59a+A26wdiofsuqzFLOUNVfDZDhVAxb
         5+gFGRImxWkW5lIyKfe167XDsYsS/MK7grugTKDCPnfSV3ei2bg5dLqhP05/03CTXQfi
         ngjYdESCUgrhEhBiUNCf/9ax3qJICBCrxFZXj1oUxl6hH6JfLIYQweCm13F9uQV0Fomc
         IRCzWfgveSJ8+f1pedWM8kEkT0QTiotq1mNNGWkVFhCsGhbFaPwU/WDWEl0Sukn8TGdc
         dpN56sAKhZ3M4fW4X6EcCql1o88rK1jP6/KU7CM/pbZ+b5Ta9/Dj1UgpEBwpuXlhWX7R
         ELmQ==
X-Gm-Message-State: APuU4Z/XF4nvgBNlxz7CTxftl+rG0OSFwhmfvKl9qxy4WmUzpeNO4nEa
	5GsemhhEY9Btr3MVqzJ0RF/0M8JtHT6WznIi39fn4U1SsA9wZ/PRS2o/f+cHnOZUKQfeY7siYQ=
	=
X-Received: from wmpr22.prod.google.com ([2002:a05:600c:3216:b0:4a1:e780:89af])
 (user=dmnk job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:848d:b0:4a4:3a2d:15da
 with SMTP id 5b1f17b1804b1-4bb88812026mr295187955e9.15.1795543907167; Tue, 24
 Nov 2026 10:11:47 -0800 (PST)
Date: Tue, 24 Nov 2026 18:11:46 +0000
In-Reply-To: <b644bcc7-0c3b-4001-89e7-3e558fbb5d76@kernel.org>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261119192209.2651562-1-dmnk@google.com> <ac761e74-b38a-4daf-b855-55d5790504e1@kernel.org>
 <b644bcc7-0c3b-4001-89e7-3e558fbb5d76@kernel.org>
X-Mailer: git-send-email 2.56.1.663.g77904e546d
Message-ID: <20261124181146.144161-1-dmnk@google.com>
Subject: Re: [PATCH] hugetlbfs: respect F_SEAL_GROW and FMODE_WRITE before
 growing i_size in mmap
From: Dominik Maier <dmnk@google.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, dmnk+artist@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B294020008
X-Stat-Signature: yamzx66diac74315fqnncjxcdb975h3f
X-Rspam-User:
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795543908-266868
X-HE-Meta: U2FsdGVkX188FPQC1JnaK9IGF8Lih16G3Ey5ZwWdNzODogPl7qzFKQMX3GxIdLQHCNR0s/U+UBnspQRoJ/2zHfGI+u1aDxzIkT4Rlbl0smIZDodnCv1BJrpe9XQoNlqwllCVMvUhM46HgYNQb376B+eP3LaLSL+0w98hfMVaf8wQSJbdF+//HvK3uO30GDzoDxs1Y7Bz5dQvgqEl5ypecyTnqcsutfNrytKLosHBCiFdXyiWZk7dvkt4RutRyJ5gq+fdOmNNdOi8D86SWgiUfZddfxnaMzU7B56ZywGM7x+f1wM2m/ZchRMiq5aYyjKhUChmQwAp6FaWWPf1OKyCChtMUx+0k29Pzar8IjFa1zn2IytPr6OHG5S7AP7cffOtVCpLXMQDwo4QDtTUjIXN4Ff5oKelp+ozhQpJDfg6URzuvxHyqDBZ1rgLny+y7CtYulyCUK2bXlb7UeN3WHA6lpConAdxCKy6JaNp7yjtUw0KBZVrUtRZ0tYyBwVnvcciQVca8e5PtR2gBRjltbY2634XYA7MFjBAvmiMQIvzWRFn+p0cvD1CvvN4F/Y/3HrlmTd0YfJqq/D4oFLM7k1rNtT48ue53pmXbhxxjT4d5VW36A6DkmsDo/zjA7XQRkQWtTThK99MaBM25ZUnWHXCLRaGd1LzyEhIU8HCXnKlxhYYhW7HFBkV6MlmxHhzZMTcm5Qgj2UiAKZz2GDpQsBvCdpkbxUUwmiv3iv3Zx07xC9c3DeAolLKw7JZIzFwOFPZVRT/WTPUa7nt+pQQ4ucFdhtcT4Ul31dVNMYlFFNSrMbNOhmcEGH6E9ZzSo8fHx5QfuAglOcemfDxMa08EPSThXSJf/wDyjWAfQBHA5DDRy2ez2yjxy/VHVpQfRYaWWDlneyDgeivI9xBoTjZmasEHWoGAotsi+PbPSmZw3aWjoikYVxom8EhpJ5QRSPwKq4/Cvr0NPTFd0D+2bgc9YU
 X1OKAosT
 8rjQ3Yeh6Xgi1Wei9ZmvelAHd850e9zSvKTOH9qs+NXipxwyB9y74AYwspmBSXy8/lsCRbuhi59h9cH87XDpjqHE9BqXDStWe2YCsipuJ+iiY96av+hOKYH3ewLDvl/XjPi0eYz2Qx9MClwpZla+6thQwTSvlTjYMHV+vZwOfXNPzoRXztXycVr67zNNTISl7YZxgsbw1hu/BEL6lrsL3YHxJMhBnvNv9QBM6qy8NOyyAoHPJLbuFoPFlwy4MhOiqZ2QxsQbRIQ0uoH0/LO2zd57e6EdUSrX/kfBgB64hey7I0SpYL6aExHUJJSO1Z4EObKOjMJvpoSoTDWLN/SlT78nVeX17QvujDdag3ewXAoZCzhA92/nDNywK4S45/XDVWQcyUMin1PshsqgTeaSJfhgHs1K0ZgK688MujxvU8qcoY7t5xTEEBhlc+qeKmYJwlaGdO25213nR3eI0AzODiOfbDxGMw5b+k+d2gHSc8SDS+GN17ZerdO0kGG6hr227h2zRr13hyYjXM+2W2bhyW75fGBPi6DU99SxkJrA0ElfOeNS2RYbSvUk+Wk6RhDS+87MXJmZixwqs9xZVOc1S7K6zOPWnRNSOyU0NPIq4kWJYm1fJ64M/6+oxor3zE1E23yJ3NWE0vT+pKGCKh2i7VbloocwvamkYG3HdazvtCw5X9oX5jPpsnrdd5Y9Ahw4IAZ5HROa7/AGLjHoV94nMBq7Y7EVpa1akUflIHI6bLBMbqa+oLqoM90W4YHNptN7FMtHrGoERTF70mXLTcKV9bQPkpHYznyg/pKQ3xQAkFK/iIMjncxkIxwAxhoO3qtMWa9WB3Y+G9mS6yXrpq4Dflhki2U6Er+1y6QEiJniROMsmdKctF6TyZ3a9ktbqtCKFxiAFiN28IKscxyCp7hsEEIpbPixJuu8C5V06ni3uIHw1tkmKtyEAUThbP4uC5boiPiTn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi David,

Ah, I missed 14bcafd08ddc in mm-new, sorry for the noise! Leaving
O_RDONLY and unsealed MAP_PRIVATE alone so QEMU doesn't break makes
sense. Let me know if you want a small patch on mm-new stopping
F_SEAL_GROW from reserving beyond EOF, otherwise happy to drop this one.

Best
Dominik

