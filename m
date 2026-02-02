Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0C01E7DEF8
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 15:50:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D692F6B009B; Mon,  2 Feb 2026 10:50:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D17016B00AD; Mon,  2 Feb 2026 10:50:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C19A56B00B5; Mon,  2 Feb 2026 10:50:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B34026B009B
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 10:50:26 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5ED4E1B0A50
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 15:50:26 +0000 (UTC)
X-FDA: 84399953652.23.C772ED7
Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7A62740011
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 15:50:24 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MW9Q+tmz;
	spf=pass (imf01.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.176 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770047424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C3j8Ja1rVxg6Ms+J096Myws5lx1WVeacCYgJOhAb19w=;
	b=TsUUV3KVpDpMLwX+BuskfShMXv7+MEwSF6clYQI5513BzEshWeAwRbO4eItgwaXCyLA4DC
	2jd8kyzZdms9t8V5IzH5oTJRJFAOnrExek9ZeOx8Tm4IzeZW/v0ID+pNq1X6AV1tdBZ7yb
	w8sr3sJInpnBaOGv6CCXq1z7clo7Wqs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MW9Q+tmz;
	spf=pass (imf01.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.176 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770047424; a=rsa-sha256;
	cv=none;
	b=lhM7QDlKrcmceoIOmokKmKlFZndYS4Y/bSge0Q4LCeNjDgoaJepPJaYOhvnWCTSCnrhVqt
	uRCoc9kM4AlipAcZWGeXWoLDE/ogGQsaG+WZgifTzAok2OUkhUBRr/aNufQIyxrOLhlq5e
	Keo1MsbvfbHq+/sTiRxlJEmTAqMI8Js=
Received: by mail-oi1-f176.google.com with SMTP id 5614622812f47-45c838069e5so3157459b6e.0
        for <linux-mm@kvack.org>; Mon, 02 Feb 2026 07:50:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770047423; x=1770652223; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C3j8Ja1rVxg6Ms+J096Myws5lx1WVeacCYgJOhAb19w=;
        b=MW9Q+tmzdmqPbFlcqbOUUbIdS6/xF3PiUFN8FdnbO2Qez2YN28gvE8jbA9geMtYX0j
         lth2Lmp6ujbgWBkD/CfA0dxDRtuYMVKN1KscEV3/gO8j7Di/9hmxq+wUEdEA9vlNOpij
         AN38bl5pcS1hFRzpIrSxjRUWojuKe78xYI3YPF9tQ/O5Snk26g4F5kxx7+9K9q7Lru/S
         2Ury9lNH3T3wK7/VyLSvlnmKoZ+PRDSu6we1bwGbaHTv7qtkVV3WftpBSgmbaoeXXSsA
         ywOb3V2Lt1dgnsHgKRSUET4J6fxtDvfydKP6FbCG7T2lRQEESnT50PAWiCfSjKxj4Izk
         R43Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770047423; x=1770652223;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=C3j8Ja1rVxg6Ms+J096Myws5lx1WVeacCYgJOhAb19w=;
        b=oise6vN8hhtVdVlrb0CgS7kWZNIMqaaReMAHZxnabSctkg1oU/LL5A+495GiEarIb8
         W4h9pl18sfFQD5TzLCoHVq10T5iiPMd0hDBBeND/dFuiNfAavd6OhVMGFQozTYxmoXvU
         s6fkeDp9ac8g5FOIGtnwUSqO4Lb8sykS6oZyy5GWSwMyUqlZcQAnXpEBMINJvA6R1e6R
         T5dXwdwMk6Bjm0//JQpmHk4h6e35w8r5OnQDuUcDf/UTDnXFUxjYB0ZvI8hGZMHCbWEr
         R31L2I4peaNtjvfFZcgUHFRjTpyWwB1Kc4z6PTN2r7hgtckgDpVwirLQ30NJC1TgDvoA
         0uNg==
X-Forwarded-Encrypted: i=1; AJvYcCWMdqta4sa0jkhMkdfE8ar+V10Ob6Ts1u2rvbEW6TeOtezbz4vCVYyq4hu+TSp/g5qJdE5eHMG6QA==@kvack.org
X-Gm-Message-State: AOJu0Ywogyj2PI8VTBzVgri+aHJrYPiSsS/5fBiVbN9RIjBgMSP1biGT
	1KDBZfYQzeHomEXORi5otX2278cIxiu4gGPVGkobDhnvcw7mRDd6ZShn
X-Gm-Gg: AZuq6aLZrvYUpZtMDZbkqQ3fHYCUeBBJz6jQdT+hoiVWkMpopkh95EBmkSBa0jo61gM
	kPNUx0yIfn6kwrgicV2/7GmioJW9UrfjICZMb6PTaZW4d/kzz9h6b8gAWg5dJd2HY6KrBDCxQiH
	lDYulPtBZS1l537dfyJuDgcSvQejrY6cMp+X3Eu3mVfjCPYmIbX+iTxc1c+COcHZDuqxYXNALVq
	o/uC+ho0A8nzToOczTORU1ARD4jPCfXZDzwOVSdHvDxiix/bseV/sp6WUm2OzMKHV2t2s7FqRKd
	5RoNebvPGghtCFnCl3KeV1Z92hkdT5nbAXP9WOEzDS1r29RN9YygvhZsspTw7aKiLV5GgtWOXRY
	vjdJNwEEtt7pZfTMzpsM8HfhldFKgAlto3hHCwJsaHI/LICespMOitYt52mgpP/raeXk03UAGrK
	POclrDKz4NRg==
X-Received: by 2002:a05:6808:4446:b0:45e:ecd9:652e with SMTP id 5614622812f47-45f34b31579mr6776965b6e.5.1770047423299;
        Mon, 02 Feb 2026 07:50:23 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:4b::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-45f08f20ddbsm9356590b6e.14.2026.02.02.07.50.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Feb 2026 07:50:22 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: Ingyu Jang <ingyujang25@korea.ac.kr>,
	linux-mm@kvack.org,
	akpm@linux-foundation.org,
	david@kernel.org
Subject: Re: [Question] Dead code in copy_pud_range() for copy_huge_pud() error check?
Date: Mon,  2 Feb 2026 07:50:20 -0800
Message-ID: <20260202155021.381552-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <aYDEsAWxcdU4PcvM@casper.infradead.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7A62740011
X-Stat-Signature: qhtu6nzi4g4cgdcbieo4kebsfuqrak1a
X-Rspam-User: 
X-HE-Tag: 1770047424-684127
X-HE-Meta: U2FsdGVkX18ejTujzAX7yydg6kHgWkuHCUIkLZ4Ybx8QglxpRHI9auFna7eLN+BAKRrGom9RAivDzwU9cZMDMhfX3KO+YA+PxhwJD7hU2z7vhwepts8jtQw2QkAaE7zmfPujCc7GN3jHvMguZBEAZQPXUfxAWQJMX8aPE7hakpxqyLJCgfxsORa6Kq8Noj8AtZ+hBHOpyOeMwCygmA3JG4XmVPgi+CWckvHo5OgBTzieSs87gEw3RGu7EmFti/boOW8QW285dhMpvhah1ypJazT35jwk8JZONnDKKTA14+yI75fVgXdQjyLhspJK0JpDRAMg+VcEJl3pmxxTAKVd634UfNi5PdNyKuoGLUxsEWUYrsPC9H73HozjRe4jGCI4Qhzl1vDSTGJ95WWIkszi9HVQDZWu0i0IihA0hYjaM+nQJycsRuqC5b++mQw71W9TwcSsdXxfMdIuu4R8sp/uDHVJcdC43/tk58mUKTEhoj3Dpk+DzxYg3z+876i1SbSa7SANhv4Edo8ifr/GJw00glHKSAZ0tgclJiyqsqJzAiqlWEpImdq3hOwwE+x7MPPkhNJZXQeqRnHDvG7e+CkLo3E1Z8FllJSUgVmN5weW2CYllOl6zkBHcGGCzNrU79RARvcjJrAD2T2s4fYua4Ze3BuvoFY3vo4WOqN8hBFcJNtOnGVXbsXbKNs5XPITEA1W0FrOf7ttpIbj9FRTmY7v3sZeOwy0qPWo2QnA4Zm82rPc9aQQ06AvmEuiaQq2KBQdK+JZ4JifxgtKKpSPx1K9TS4wtUsM9Hd5TN36GzV4EFzkXyQ02rjxXcMl0owMXZHFCDoCdRw6rACNDmcjjIxiYi76mVlmMH5OK5S/NoX1JgXEgPZ7hnLrTH1gQ55TGdZqtrn/levthhszaL/Cb6UeheX+gG0lQT5kdYxzl1rYFACnjkbX3+8Ru0hHlHi8WaTIL/cqV541qKgwBYleaFA
 tLw2FHeC
 7FD+xAYilBTwkQFphCf3JyahfA9acjOIV6T3cY/8dIVfnqkumiu4Y66zLnX/bpQI2bH9DKWMAMzYv76VYHjOa0m4+7nraEoB81dGfNkRT1Y/HoZi70D6dDuP/BZw3DaUuyB2pH+FN8lR/Mpt1LNKfhfZE/u5JrsRB5pWLkO4qxeh1D3mTSfmVP+HvMK/BYHOC6yRyaKxWO0E4dKzateRS8sATtr3sizP1wR6NQaI+QED07i2k4ZCpkUrVlQITBYftnnsi6tKQGd5xcY6NBAJ2xNaaG70Mlnl0tn9hNsPG2oscwzJ2hLF3IvLKYJVfBq1U9NnDyItJx3Xf7impHYzqgKyxoR3axX9GwoGWeliBqMBp5tdXOKHS/DZPhTk7TWHlgm5dq1YB9uN7P266lM3aEkKuy80/CcG033VtSUqwOgtwRYIHApncG4XI4qKzfgH5uRNwMLjv1G0tJbDWuiFse+ajbUr3NuLFOPfUV5Jc9sXeA8q23MrrXNbufe0ep9v0X+p0YyCm0hQP5DN1AK0mAbOsapOi3jvyDR3u/e0/LFnChhkadsgDACwaJkMkNbD8rRE1+5eso0e5kPNnmSzh8tgXo27p6KM+e7sdG9bTMCmfs3im6hZ89X1z+/Ap54sWvbD15Z9lefybN23nw8sozreMrg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000239, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 2 Feb 2026 15:37:20 +0000 Matthew Wilcox <willy@infradead.org> wrote:

> On Mon, Feb 02, 2026 at 07:28:38AM -0800, Joshua Hahn wrote:
> > My guess is that copy_pud_range tried to imitate copy_pmd_range and added
> > the -ENOMEM check. copy_huge_pmd can return -ENOMEM though, so it seems
> > like this is what was missed when copying the function over.
> > 
> > If you have other changes in this area, this might be a good candidate
> > for a small fix-up to be included in the series? : -) The whole if
> > block inside pud_trans_huge(...) can be simplified quite a bit:
> 
> Please don't encourage people to make changes to mm code when you aren't
> the maintainer.  The last thing we need is more tweaky little changes
> that need to be carefully reviewed in case they have a subtle bug.

Hello Matthew,

You're right, sorry about that. I'll be more mindful in the future.

Have a great day!
Joshua

