Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2229CCD4F25
	for <linux-mm@archiver.kernel.org>; Sat, 16 May 2026 17:32:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A9F46B0005; Sat, 16 May 2026 13:32:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5814D6B0088; Sat, 16 May 2026 13:32:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BE496B008C; Sat, 16 May 2026 13:32:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3EEF36B0005
	for <linux-mm@kvack.org>; Sat, 16 May 2026 13:32:35 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DD8471A03C4
	for <linux-mm@kvack.org>; Sat, 16 May 2026 17:32:34 +0000 (UTC)
X-FDA: 84773977428.05.C9CD976
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	by imf21.hostedemail.com (Postfix) with ESMTP id 885071C0009
	for <linux-mm@kvack.org>; Sat, 16 May 2026 17:32:32 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=google header.b=BdenHiZQ;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf21.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.54 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778952752;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PRqWOI5lEDkAX8dh7uVdCRdEuSOby6Kyc0mg871lWR0=;
	b=zIsRerTZmyDEzybpPvwLiLG92qTNmVPr/B+lBkyBsFXE0+d1zbLfjTtS2ww70nwNVj5FUa
	N/ZLB5yCDcnm3USuleMHX4ME5lycaMkTdWei3njq+pATK2GXj/x4bMu+Xa10j59720eyWH
	LtqnFqY7R+1PHQymO7iihVJj/61yHCc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778952752; a=rsa-sha256;
	cv=none;
	b=vWDGzZb4k5o6c41ZsBHtZXiXNwToEBgcujg1URPtAeNeOjy5cvrETRHBmoq6P++fI3KA0I
	cS66mUsxoXFB/4DjTvtZ3VApVcbKav4PngvEObH2oyiKZOppvS4hdd6BUEanO6k2AyPrme
	Y3Wtx8rqHt642kGNZwFzG24xSepxixk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=google header.b=BdenHiZQ;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf21.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.54 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-bd373f83042so212860566b.1
        for <linux-mm@kvack.org>; Sat, 16 May 2026 10:32:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1778952750; x=1779557550; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=PRqWOI5lEDkAX8dh7uVdCRdEuSOby6Kyc0mg871lWR0=;
        b=BdenHiZQEk6ZOVany8+sFneyEN7aROCTMTf0P1FByfbpmpuPshD4kvuvvf1tZ01JxR
         KRQxz+dM+YkIiaKE6wdSdV7X0IBt8EXcBkKECokxQ+7hG6rpsCjYAI4TjdA7RQw1w5JA
         y7PvCcvnOYjXi/X1pVT0X9QRimTVfy4KV1Mus=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778952750; x=1779557550;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PRqWOI5lEDkAX8dh7uVdCRdEuSOby6Kyc0mg871lWR0=;
        b=C/XCZkDw9SIVemd3n2vst3x44gSqVUksSnt3Ust44Jj4NbFepQpWrZuXX3lCWM0Y18
         c9iPI+YlRtk6Cen7NkTZrpXHl3z/HSQeZNEfPc1SQzaOM+h2NkGBaCyP1G7fTSEnSIUN
         pb2bO+uZ0lAfnsMXsFz9xp2Mc6MypCbO2yEoYg35YjG+HVFm7EXQYb0zmAGshupruSi8
         nlVCAlVSjqWvIVP4zlSD8ZfI0/XhLt16KPQglnU3+klfT7FdqPvHEPGO7pQlLU1ccx+O
         nKIlYt2gwzItNqxQ6q4lmRzKuUPyv0uWiMIeMXvefMxQG8QQK9xX/m9YsQgKDurWnHxy
         Jo1Q==
X-Forwarded-Encrypted: i=1; AFNElJ8D9TMtyfY8AEo5aUQd2mVXtdwm+qZR7fg3N7TPvESXKDDdsCO34EzGYAUcnXj2eVcYgElo5YBGsQ==@kvack.org
X-Gm-Message-State: AOJu0Yza95aEEeD0GObaMQsse1FtiaoUteGgE/PG3CG/rgDv6eK/BDE6
	5W1RmJgz+uHgUNYh0nch05hW/hzvhYQi8zC2IKarp0CrV/yIShVU73iJ4JgGZyQQrZzuD/s+Tr7
	yl2/M6p8=
X-Gm-Gg: Acq92OGBpiDzQXzQ7JMykFktPtQ3uJhPcwSGyqpJDYaHFz7C4N2PI8+DOwncTDDrGk9
	Em6ziG8u6k1Q7QbLND4P4VEMjALsDTuXIGMSfUilTemv9G21aSC12KuJZC0CpFs/4WEAR3TTKiw
	ZTMjoj6jmN+c/6buGL+hhy7aF9AXcQC++QGHmpN3zPQMkGWlfmL6B0F2j8CsmmCSeWZnOWvpVZQ
	/FYkHuNDo7l2Ao+2wDEaP6XxiwULbq9smCmNNdL6ptXru9kFin30boei9JpqIXZOhGAPUI3f86/
	3zd33SnMkdR0ePHrr7FarRvy6CYnGePHfLvjCqzH0uReqpqJzdyevEluYox5FKhdO885l8McPi1
	GsMzp9+LrWpZcujgqY4hf48CnHjcxn8BUU9WZweWzwwTEDDINAiZ7/fnz8TAH2Nkg4630uz33Ku
	+QOhNI+HdyHEOjcFypdegb61T9E0etqAHXrQEl4tx02TWoqItQM05PiR48L50UilVCLuWLf0gia
	YzGbWnKHA==
X-Received: by 2002:a17:907:c8c7:b0:ba8:8c8c:1c67 with SMTP id a640c23a62f3a-bd5177dbacemr490031766b.4.1778952750459;
        Sat, 16 May 2026 10:32:30 -0700 (PDT)
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com. [209.85.208.53])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bd4f4bd1124sm368944066b.1.2026.05.16.10.32.29
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 May 2026 10:32:29 -0700 (PDT)
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-67be871ed3fso2462611a12.1
        for <linux-mm@kvack.org>; Sat, 16 May 2026 10:32:29 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8oWf2M+rMfnv0T5XTSiVg+tHWSCTiRqMQ5UVmWrMNQz+PPAC/hDkd/s9wHZDlknDVch5fOt+bpYg==@kvack.org
X-Received: by 2002:a05:6402:13d4:b0:67c:5745:ba25 with SMTP id
 4fb4d7f45d1cf-683ba93ae7emr4639055a12.0.1778952749527; Sat, 16 May 2026
 10:32:29 -0700 (PDT)
MIME-Version: 1.0
References: <20260516-work-exit_mm-v1-1-76bcc7c2439d@kernel.org>
In-Reply-To: <20260516-work-exit_mm-v1-1-76bcc7c2439d@kernel.org>
From: Linus Torvalds <torvalds@linuxfoundation.org>
Date: Sat, 16 May 2026 10:32:12 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgvUW=1qtJxYcvbA_WaTom6n73nT7S_=7tZd0bo49BNOA@mail.gmail.com>
X-Gm-Features: AVHnY4Kka0j2IZtXlEubXEvbRLDshDfFW_ViyHQQNFc30kCO1qbUru6xi8FCkyU
Message-ID: <CAHk-=wgvUW=1qtJxYcvbA_WaTom6n73nT7S_=7tZd0bo49BNOA@mail.gmail.com>
Subject: Re: [PATCH] ptrace: keep task's mm around in separate exit_mm field post-exit
To: Christian Brauner <brauner@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Jann Horn <jannh@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Qualys Security Advisory <qsa@qualys.com>, 
	Oleg Nesterov <oleg@redhat.com>, Kees Cook <kees@kernel.org>, Minchan Kim <minchan@kernel.org>, 
	linux-mm@kvack.org, Suren Baghdasaryan <surenb@google.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Michal Hocko <mhocko@suse.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 885071C0009
X-Rspamd-Server: rspam04
X-Stat-Signature: 9i144n31uhh1di9mg6ozo3hcrkmhiy4b
X-HE-Tag: 1778952752-820812
X-HE-Meta: U2FsdGVkX18zdEwQjH81F77tL//jmWLnNwXk/LEiXj7jJmV2+v/NVrRRGVlq1Y3bv1EFNtDFHb3LY5Gr5y++fLZlxtYbyMfVwUrwqkVK6Radzq47c7wT0sOJYNu3gKpCR3NpWolHiFGCV5djyXFDVCvkdqyuymOXb15aVSA4DdLfbzhkOjVA9R8o2LFFVY1LKj82iJxhI1JUZXHc5HCIooPa6iA59U5okq8+yrkvoc641nTPhzYyte3fHGix0Yi9E0w4o69auQomhNo6qheAYqidugCN4+Yboc1K7RlPNV2PGk76JBRlzeuLuhB9v5yZZtKnoY1HpoU7lFcQmiEZim8d8HBVmy7ml6pzroYuExoUHWc2BCFkj7GkvI8VZjiwiErZ33eY2PxKM7K1I+qFNA+9wn8XcURmZIV9K97bONGhht884ioR8+MmlS6a2D06nYeilX/rRmyL/vXpqWPO5rpqfamvJqMM2ASl2FTniPAUkCyowtPmjvD908otjWlkhkE0wsYnQc4zYqZhdvjMqxXlgplyUOD8EONRF/WKkbxMg4mKaA8KMKLXg27ZxjPQ6jqFF1KyjBqpXzLKOtlKaQG4/rpBR8cuIisrWOWgPul3DQKu+Vs1C89JI7MrSyquuuUnk9jDvv4o9YGClt+nZ3M55BfAPVh/C1J60QlbGrYjxUd9hhBxtVXM+k7yLvMR2tErP9okYvPmiPAQ4d0bqgI56K/0+wwEXG9daZwCW9L2bu/7bLuknLi1OEAMe7khIlNVM6XbYh3Iz6a8wqU45u8nT/p/Xm8VGOaOWCTgbnegKkf93XnfP6GnyMZBR7HcfJBrwjYRxC61PW0eCTSVJvOp9i2a0miLCrKVr1rq2GHEgWAdApelAEtBFVjK+uJ0SM4JPHS8GvMTB8KsFQbxbTIsvO3dgg7NH7kfr3gaAmfTza106LOZgFt0bBsuIfNyHXuYYkVxqafmr9m4Jm+
 0yvjG7c6
 +YFFwWaCRaage0tgKpzPw1NP3b0RPjXzEmOHMRKqI1/ENXzb9lTzlsij9KPPbCatWgs/pnzmPnGkxILnygva4AHwem7FAzbCOSlJRrsk4aMeE/XpapyYd5DRvdvNA+l/IZo7r5DbZQhsf9tJq09NSMEQHsHCP6qmdhHaXrl14x/hV5OeWhLF+QvDpLu5yq/apit8+k5mfPhzxchCc4fOG1aoYF0Q4Hy0C1jPMauRWPL+sc0XUsPIdmvxYCZHP37bcucx2D71r658dYKYv5ymrUYhLW563Y8cwxNqPhnuIC8b6gVk3stSokmdxVo2srD6yod2o/lH1us70nmvFO4kAuWBmPMrqKKnRdGiyXp0eH12t1ZkR7yDvPQkUh3BkF/DuMWNtAJEq4N5AEwbr0XVtFLUauO7QT3rhCo11
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 16 May 2026 at 10:09, Christian Brauner <brauner@kernel.org> wrote:
>
> I massaged the patch a bit and rewrote parts of the commit message.

I still don't really like this. I think it's disgusting to add a
pointer just for ptrace_may_access(), particularly with 99% of users
already checking the mm for other reasons _anyway_.

IOW, that user_dumpable bit was a minimal bandaid for bad behavior
without breaking old code.

And the fix is *NOT* to make the bandaid bigger, but to just fix the
things that are broken.

And Christian - right now pidfd is broken. THAT was always the real
security bug here. Let's not change exit just because pidfd did the
wrong thing and didn't check the mm like it should have.

It might make sense to change the 'mode' argument to be something more
flexible and something that forces people to *think* about the zombie
situation.

That mode thing is already a bitmap, so one bit could be "require it
to have a MM", but I think it sjhould probably be done in a way that
forces the callers to think about it a bit more.

There's only like 20 call sites: let's *not* add a pointer to 'struct
task_struct' when 15 of those call sites either already check that
there's a mm, or explicitly don't care and handle the mm vs not-mm
cases themselves.

                    Linus

