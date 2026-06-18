Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFB9ACD98F2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 16:02:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 957D96B0088; Thu, 18 Jun 2026 12:02:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 930C26B008A; Thu, 18 Jun 2026 12:02:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8460B6B0092; Thu, 18 Jun 2026 12:02:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 569116B0088
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 12:02:32 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B0E83A019B
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 16:02:31 +0000 (UTC)
X-FDA: 84893500902.22.76AC1E7
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	by imf11.hostedemail.com (Postfix) with ESMTP id 497EC4001E
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 16:02:29 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=LxQROQUx;
	spf=pass (imf11.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.49 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781798549;
	b=tVxs77QS9gIGnddN9t6fZWYSZ2CPhoAZ+pGrxSEYyPGc5EsSqFyBWlg9YIGSZ+TP88DM9d
	jIePSgNsZxMp2uZC4nq4v+9WJQUIYTVAgwrC1meA7R1fOD+aE/9kfaaWlnINIOIC/JacV8
	xhR5cJpMNY304v5d40Lv+6+dI5lgNus=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=LxQROQUx;
	spf=pass (imf11.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.49 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781798549;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XiFrlN9u2kIOzdDbdgTMoI7zFXGysr9y4Am1xX7xAWk=;
	b=GBbbtOi0Yj59ZdYG67w0ld+HS1SHiOdUiVu5JDaeqzxkj2YX1PteJezvWXyZVFrHptsXsD
	1JGonwjgyyENHcteWe7EQ6YXTGAC9ZJ87pa/AZg1/6Se5ideATojee6EDEIRBLzafYl7Y9
	E+ip+X4iO1VhsFa2ya9Y0zq3As2duxk=
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c07a6520cafso112701466b.0
        for <linux-mm@kvack.org>; Thu, 18 Jun 2026 09:02:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1781798547; x=1782403347; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=XiFrlN9u2kIOzdDbdgTMoI7zFXGysr9y4Am1xX7xAWk=;
        b=LxQROQUxt45n70d6JUWnIAzZmppupBBstmlIQAPkDKsutzxJalWi9yypacFYe695Q+
         7g3JZBX3CjYdfieAlvZ2x8LUj1Ngw0BnI1gM2BruMAYVwP0OdfytJV8QNm7T2jUf4wSN
         LqUc5kH1psqgmBRgHiiFMonCH0oFqmEEny3Wo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781798547; x=1782403347;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XiFrlN9u2kIOzdDbdgTMoI7zFXGysr9y4Am1xX7xAWk=;
        b=KJnVkBsWUc8t1tYmGOz6cWQE4XwcVHyhq1OrtanTFO4oLnA4UD7thSH2nDdFW2tvHh
         adwwrNjviME+8rKfgFK2XitWVanCluNshldzRfvgQYiuWFD889BSett/l8rt0dsKgXQu
         tickd4cbydh5aFRjkqyfpJh5az7cT86BRJ3ENmvLoKp5vg0CvWLoozno7OZ7x9Dd8rj3
         XaOIG0fH0sPzhN0Xr/v/rZM+9BbQ+UYH0+fMWflYddeYDXA/cPu8sHWI9plcZaKByJcl
         K0JIK6RfTyUG+VOQWVGlXPXITim/VsTfvCK777knjX5GqLKxrW0AQNYY07zmLhecABIG
         BI8w==
X-Forwarded-Encrypted: i=1; AFNElJ/3UpNk7R+Y8DoaVjFL1uuFai5WCSCX2VDmGnoWrHb409TP+ACW4mCBr64Y2B6oZOxUoFyo4Moezw==@kvack.org
X-Gm-Message-State: AOJu0Yzb6GdaQ2UsIGwh7t+iEruxrS22gqiMQ5VGRzTpU4GqI6h+RqDl
	VseqPJzvsOHWJYIhruPTaB6fqmfT0KaU3MIi2mpF5fJLUEA2UllGjgoJroO8Yf0MrShMjaasRAL
	u2mgT4l0=
X-Gm-Gg: AfdE7cl7sclGJllVSJJwjYbunJNEfZiiud+D1Xj30PbjByP5K6XQENmnCZzy5hu6+Wn
	I5AGrpenrIJHgHo+9vr2ejSd148vYQGUcme1eo/ROuQBvSwxn3EWAFzQZ1mdmDQfbnnD7fkBmYC
	pODQiKnl2Pw1//AeWr5tjxSauJV3B/zLTZf3aUrPaBkDux0VJ2Iuukr+CQeFigZJaqD+KiLN/H4
	i6LFjIvuUtp8ppJ5vrpomBSJpoSvRq2Gi1Nk0Fp6QZAiAGW6vRJ/sq8wp0yc37PNZfGBf8VJfVa
	UM0IKpeQzMxavNv+PAcxOBJwnG5+SU8NaZSWJBLOI9W9RJxTmbPP+WFIqxwHZ23kqVz6BTKRawz
	f2prs7KElu7TTjudYJ3ZzFDYSWgANVY2zDUkPSlBGXJIWd3LYK7f4ONIYzM57MU2vcKQqoD0OY+
	CuJPY/7Dql3N3pm+UF6sN8xaKpTw+W7kkqd0o63fNkinIpleRIQ+Hl0EFblDmbrQ==
X-Received: by 2002:a17:907:962a:b0:bfe:ed25:c562 with SMTP id a640c23a62f3a-c07c82c8822mr149428666b.51.1781798547032;
        Thu, 18 Jun 2026 09:02:27 -0700 (PDT)
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com. [209.85.218.46])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bfdb8341840sm985060466b.43.2026.06.18.09.02.24
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Jun 2026 09:02:24 -0700 (PDT)
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c07a6520cafso112692366b.0
        for <linux-mm@kvack.org>; Thu, 18 Jun 2026 09:02:24 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9utWvz29YnZS/cDlwOuZvzuKu8f7h5mqgGRShrMeGGxd+VI9LlATdasUTBgzcv2ressTILC9ByEg==@kvack.org
X-Received: by 2002:a17:907:1804:b0:c05:21a7:6b0d with SMTP id
 a640c23a62f3a-c07c7bdfdfemr172026466b.47.1781798544383; Thu, 18 Jun 2026
 09:02:24 -0700 (PDT)
MIME-Version: 1.0
References: <20260617153144.acead3f2795da15f1e56005c@linux-foundation.org> <178179616355.2947725.4377157124023044624.pr-tracker-bot@kernel.org>
In-Reply-To: <178179616355.2947725.4377157124023044624.pr-tracker-bot@kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 18 Jun 2026 09:02:06 -0700
X-Gmail-Original-Message-ID: <CAHk-=whn39dQtoMeJrz++nAnZpgnrooU0dgzOZXdn1LyxQ+f2w@mail.gmail.com>
X-Gm-Features: AVVi8CciHIaGTA_UXGcV5OZpxqlwvfzejICQbiD_QoQSAfSAS7HIF_HX-wWOw0E
Message-ID: <CAHk-=whn39dQtoMeJrz++nAnZpgnrooU0dgzOZXdn1LyxQ+f2w@mail.gmail.com>
Subject: Re: [GIT PULL] MM updates for 7.2-rc1
To: pr-tracker-bot@kernel.org, 
	Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: jdjar693bq7u9r39kzpm3ghp1n7mommg
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 497EC4001E
X-HE-Tag: 1781798549-615252
X-HE-Meta: U2FsdGVkX18QxPF3iLunGWryko6IdpCUbOmtn+GBsRoLgGsuHQODpHtzYhZDihff7vx2C7WFCpVjJT//XEi+NxSX3oG1DXrNJiG9R1RLX85cjcmowIO/ACyN/LCjCOjGLcwWW8TmJTyMKPcqKrYmCg+JKbFpVtAZTz60Xr6lN9CjHmbIzDfD9skHY5eXc/CStTMXJFxVTiAc8LD8Xh5UScZx6SYxiPJzFBgrSUDiYS2P+LhFwRYMNXphHy1C9Ng2B5JV0ps8KBIY/bAh2UQfpn5Pxokg4HrCkVDXGp7fI8HanBegauw83HnUyvplp7Dd4jNB1SEcT/EAJAL2UutnnoHd9rZ8804v3wgLm6CG8yL7z463rbUt2ZpYb/Kg0cZ6oG8YaXxkanUZbf0zphQZm9MbQ0f8xRkiTAGD5O1I6ngcMdL/6pSQdLofqm15ZVdZ6ZbE/bp43srKWP9JTf+0oishEYyHcig9cmFCJpvY3H46XVEhmWyoyyZBy//wKHos2lTNKjlTdDnFQisnEKwsmf9q2keqAlNwA4vYhHHDr25UIeWSJh7CzXTwTWb+PKZHU4ERcWDZERp4heGquGo2jhSZI2hNvW7rC9BB4lww5SZTu7cOWWRwSXBomBUXIHexDxNeMJ6wVsNfVUsxIJBgI2hx++QaRtIvFWTN9BZ9v7VOlr0XZc76glh62asqhUp78TyhdiUh1OmKgSmLPhXy+EJNS/9ROaL2UuoMz8Od+wrfRax4MAtB84gpZQTA419oNISiQ7ngBzN/6RsK1QznC7qGG1d64qbgLbLtky5LomrLwXY50kRUvDYT088fQaeVnOPYjGbgsK3KQFdhkczicHceMqkHOx2WdJKEEvCROqU2ijkw/A+mGRGYFDUPMFmn3htx5tF8KCY64BrUPcNWGSXjKJmo7gHY4JwOXTw8HuJ45YviZ63f+GC6POhHrBjPhPmZj+4TM5kdUwm5I1f
 /Pq13uRP
 qB7jVHCuyD5PqSA1WjdsfO3vkpYmsyr8qmmKSU5DpzK6dh8tIy8wgerN+Jk0s50l8PUNpNVjky5aOyKGnO4Cv/Br9S2+MCdZxnYRXa3OJ36f+gHCu93sVqFlPJbPTVO01f0viKnsjQjyHeH2s0K6ykE/Jhf2v5xmLQWc1Bj9eXposAvQ+2uHp8DVPXYcFzxkyqOQ+Vu3leAs19v8QADHbj9leU2UiNwOZs3WkB4aqFsroCkktOJIMrMknuula4nPh56eBVzeaIM8O7r1UpbdEb3wzszFmkJPgPBHG0miyZfDF1cRhoDYCJlqHGUc1RNDtFUZttMqfpIXZYECf0BoKAZn0qDlrs66FbCLd4OX/AUx4XEFwSyHry3drEiAB9wGnde3LpAW1u6X6FEZtLu0BiHEhosjL1d5Yw/P7kVuihdG1AgEK0beTo0AHligleQcYYZF/2YOoWDUG2vrT+DHHr0Ev63yW17i3h0mUU25M1wDVXIYSpNF7eM5UCF2gSttKPSPNtcn80jV067m/xXUj3mwQAWfNlitg1jcpM71EHxEa6iyZ0A7uk1HLRJq1E1kb3B5NyM79a5wUfx/4GucJMDtfOrbuezSDwVm4OmAYNph9hJTKtxI0+I5OSg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 18 Jun 2026 at 08:22, <pr-tracker-bot@kernel.org> wrote:
>
> The pull request you sent on Wed, 17 Jun 2026 15:31:44 -0700:
>
> > git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2026-06-17-15-16
>
> has been merged into torvalds/linux.git:
> https://git.kernel.org/torvalds/c/2f9f5887b42711595e768b9dc0582dccfdf60c3b

This is very wrong. That merge (2f9f5887b427) is merging Jens'
io_uring epoll cleanup. Not Andrew's MM tree, which I haven't gotten
to yet.

I wonder why pr-tracker-bot got this wrong.

[ Goes off and looks ]

Oh. Andrew's pull request is confused. It says

   The following changes since commit e771677...
     ...
   for you to fetch changes up to e771677....

and note how the "since" commit and "up to" commits are the same (and
is my iommufd merge). So then pr-tracker bot thinks it's merged when
the "since" commit was merged.

That doesn't explain why pr-tracker-bot thinks it got merged in what
was me merging Jens' tree, but whatever.

And I have no idea what Andrew did to generate that bogus pull request message.

              Linus

