Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2082BCD6E7C
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 16:03:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 262006B0005; Fri,  5 Jun 2026 12:03:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 239B06B0088; Fri,  5 Jun 2026 12:03:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14F1F6B008C; Fri,  5 Jun 2026 12:03:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 05FE06B0005
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 12:03:18 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CBA5E161D56
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 16:03:17 +0000 (UTC)
X-FDA: 84846328434.26.1B5CE92
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7F4DDC000F
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 16:03:15 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b="W/564lmP";
	spf=pass (imf28.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.47 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780675395;
	b=zV1zUJOFiw2sd/h9D5stN/Ixxs7tpqDo4zfBkgVy+dJ0YbOsSEzGnx6mqjZhW3fteRVakJ
	Nu6K2hpO7cVHeLhOO41n2gWijMS/41Bu0yKNZcwLuxq9eN51HccKwo+6chdRtrds3CiEj+
	WH/DEmTUAUNmeGdTw3ohpJ+GlaaEgAc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b="W/564lmP";
	spf=pass (imf28.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.47 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780675395;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y6UQFMgxs4xPTWbEaYQXP4WreuO3V04h3DiBWisQT8s=;
	b=Gk4QvoeD3sbcZkYfBu5ImRl99eiQL26yJkl2I8W4SZnYKIwGYtqSLlitRn/X4fWRsdgIFE
	fl5HEqDXgP1AN1Nr3s81K+EacQ4qxfdxtQfkr9calTFB4903pkd4KIuVmDIGaBNOg0jL6T
	yC9aWfeI9vyK1ES2PU/gGy7ds3N+45w=
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-bdb3fd39045so267033566b.3
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 09:03:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1780675394; x=1781280194; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=y6UQFMgxs4xPTWbEaYQXP4WreuO3V04h3DiBWisQT8s=;
        b=W/564lmP4ph8J6t3Tbb4RIt7MoHA9bGXKz1hh3edMsloQtFAeO5JErbJxKfNJDwBVd
         mNkYqTWIHgjJq2hGiNTGnHMQVb34rqytvBYNxbCD1F5rpyF4qN3yHqjxSvHcYoK64Qqs
         m/QQ0YdzYfTdMt+v54BVe/Fx8LUAnjsLtZcgw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780675394; x=1781280194;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y6UQFMgxs4xPTWbEaYQXP4WreuO3V04h3DiBWisQT8s=;
        b=oJ0DThUPo9YoYRipLmipX7CNHj/uHbQXXxcr5RIv7WIRpZjx3zMjl4VsKvnBgTElko
         O/igsjcRkzPeKYliD+76l/2V9OubuQpAIulXGc4gnwk+i8VtL8i87Unr4GsQ2VB9s5qK
         zh6JrFaTRxmTwioMU51/Bw+Dm3ZoKe7ukCMBJwUckVX8OQSu3OsQuPOP5+CE1JRyPxXM
         ZubbBZb3GLfxWPmToJpJ1dSHiq9KG0kOnSNjUXQ7aJNAPcJBh0xM9WGP0PF+tKFu824H
         LQiL9Cp4DUiVAenYcofdAWAeXqGSTqJ72POSaQFVf3dNKWKuWwijlvMIs6+nsnNmOR+7
         bZLQ==
X-Forwarded-Encrypted: i=1; AFNElJ+4zDhZrhsvmEGlJkNXGeqq/HN5tQNnz34Yh+uUeI7N4Qp+3E6n+AMLLY+sGW/CHF4KXH+1lzDgSg==@kvack.org
X-Gm-Message-State: AOJu0YwI0NXAyFmkfUH8bDDTtCxp9aFfL9dUxTaTVMMb/CTfqd4yHubG
	yYzjUXeIuOPUsU1t29cL3uFNyAwpoaE1+FpXbr63C2PwjkUXc4iV+RrnfrvOuGMJXbt0AP++byb
	KRiao22zG+Q==
X-Gm-Gg: Acq92OFDaX3orsteHxhMf0ZVk4tlMXq56AaXcx9Sa668+WWHwhvJdDJH6heMPtUBzve
	gYlR/5MflKd65e2nvuoenisxsTk5Uwljl3vdaN4AKly2sCxrD3sZwfL97hMeBpgzvW3/9HHlP2Q
	ixDbybI7AX0K+qGimvZsOWhopBYIvQT/ydf8p2FCruHe/TT/7P5x3U6IEmjMFJRwVl6sN7fbgeQ
	o0maf3lQGExVOVp9Mw1v2f3/2AxI+YhIaIcwxT05868fYIVPR+FQsIeWV9brhJ8YSkRXQlSFlqI
	hAB/6uKGb7qjtMLUeHK7ncPT1IPz9hKPU2k/bPyKMLR5CWCBoqabdHwZ7lgr02ng44RcMiCy8Y+
	j5QazhaSjvACPRq37r+ZOnGFxr/Jm0MgRDYbetV9NkCAJW4ZOILKKCSpQh5XpTMqYHOYXcQ61kR
	hRQSyYxs+k1b9/BF89bO8SSkVr15qOzqbAvHdJStjLUFcGUpg8wOOZ/BhYTIGP6nR9tHTXcH5Cf
	EWRgYD6p2c=
X-Received: by 2002:a17:906:f59f:b0:bd4:8b66:334f with SMTP id a640c23a62f3a-bf372931c66mr238346566b.33.1780675393210;
        Fri, 05 Jun 2026 09:03:13 -0700 (PDT)
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com. [209.85.218.50])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bf054e05199sm465101166b.29.2026.06.05.09.03.10
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Jun 2026 09:03:11 -0700 (PDT)
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-bef47b1ac01so334825066b.2
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 09:03:10 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/+uxa/bRM+Z3O4T/YAOntrHg3GRMqYb4BEpEaCnHWZxyLxJiPZO3jfVCodnpjxxxKKQPOJPf4QDg==@kvack.org
X-Received: by 2002:a17:907:9686:b0:bee:323d:1239 with SMTP id
 a640c23a62f3a-bf372e1e4fdmr260752266b.38.1780675389972; Fri, 05 Jun 2026
 09:03:09 -0700 (PDT)
MIME-Version: 1.0
References: <20260531010107.1953702-1-safinaskar@gmail.com>
 <20260531010107.1953702-3-safinaskar@gmail.com> <d9806b34-fc73-4878-997a-95c5e8ae4b29@sirena.org.uk>
In-Reply-To: <d9806b34-fc73-4878-997a-95c5e8ae4b29@sirena.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 5 Jun 2026 09:02:52 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjBZAzPdZgEeHAtSiwJpomt8ZZgKbixuiHfRm09a4=PtA@mail.gmail.com>
X-Gm-Features: AVVi8CdZ5f-_r2ry70kDuq_xsye2rLgypwsymONxqFNfT92KlgrDUIUXs4-jBmo
Message-ID: <CAHk-=wjBZAzPdZgEeHAtSiwJpomt8ZZgKbixuiHfRm09a4=PtA@mail.gmail.com>
Subject: Re: [PATCH 2/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
To: Mark Brown <broonie@kernel.org>
Cc: Askar Safin <safinaskar@gmail.com>, linux-fsdevel@vger.kernel.org, 
	Christian Brauner <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org, 
	netdev@vger.kernel.org, Matthew Wilcox <willy@infradead.org>, Jens Axboe <axboe@kernel.dk>, 
	Christoph Hellwig <hch@infradead.org>, David Howells <dhowells@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Pedro Falcato <pfalcato@suse.de>, Aiswharya.TCV@arm.com, ltp@lists.linux.it, 
	Miklos Szeredi <miklos@szeredi.hu>, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7F4DDC000F
X-Rspam-User: 
X-Stat-Signature: 7zjpgpos8788osw8rywyuortmrafx737
X-HE-Tag: 1780675395-980237
X-HE-Meta: U2FsdGVkX1+OutyC3JxEVKeCncm1hcUtfvHsChIWo9pwAjPpJIHuOcOiNftyr9AeOFBk3BoPjuFQA5StELqaTTS0LsuNjmqR2eRzlINMAyYlBDCqR3AqI3QDy2F3cTS1xKm3GPj07wXNojtQ/JZ5iCPwQMe4PNznefeffNWnl6dtjwiQODttRDp0xHaRUVballIW5ceg3n2AuWG25FvWhDAlHNVfUH8sCK/1YrkbKtatJGbcjMeTbF+nMDPYJyCKl3IIIa7d2E11XnkvUo+SX/jQbK28fzJfVzJ8hvtzzG/3lBqMI6tsQkQ1n08+q5mhasw+I8IDT1kAgwdCvHHn1T1NX2iuZyWn893cXA2P0hblf2rEyaq48t+rhqCivndToK3+2zo3jbMF3KAFN2Zhn4D2KTRLTTNyKMuquSYFm8O6lUJrXpD7G2IC6dseN1fNNlbKnvQccDx7oqC4Ug5TZ+08/hNBvb/EXrFn/aT9Ao50AQnzWXRMeNLVM4UJ6bb1LRa9CdVhCBQtx+v2yMo6GJecCLQfphYemEK/auKLjT+CKLIGiUl7gMrjlUwqYLGJMp9YSEdo6PcCVYGu7DrlyW0G3POD46p/qD6IOdmwJUh9nVW4YxIZnvf7v32xGGka4V7Qa0xDimFhqOVHaVfzzA7B+GfDf6YiomZ/QoGso5UnCvuB7iw+ppwrxnE1NlEx9QfQXxWThO9/yLXecajf0lBb11SBq1Amzz2PMITH5ZkhweEicx0dUsPtUXk+sVxB6PEvjUi52cujXCD8TcZatqeMnAv85tPh4r1vFYPB6+kPbYVfBzlNuUWb6rXOB2oUeP1HEN7vhR6GtvZwISbdFdyJBvIu1eCe2W3KANDDhXCNpNlX+R9JyLGkvKxPKOlFxsRQAKwdb32tX6uPT5fMVG3U4f9zkDUnFSMD+S8M+BmUlpfKyvS0lTCdNFPExKrpBje6EA27m32I4xiq4LD
 LOA8716J
 Od0VRBVwIKKDolic5syOn+iNzThqIykjiNZ/TpEtQCZWN1R7Qb5Zp2zxVdn6sMxvsbr2A8zQuR+4BB2M9XX1252+QlKkeTTPP9N7U4L39kKoJ//fAg5HoM8mZ1O+EYZXQyGme5MZfHVP9bp9H5QyN828xHRE2Q3C2iq3NwsBFL1fwWOLU46CUu8lvdNacDiNvPResyYFYVvgXqwXM/kB4biWmI4fBsyPbyoxhIQ1XTCna+cFd59cTfYwSo6Wr7xk8NcRr1rIwVY3+sAT8apNPKx8KzVSiV/wi6tE6A2+2Hz32sHbMpV00Pga+UzlGx2t2/67Xehb9inFOosJFKCihDq6TAHSSmvRRdJofJ2paSlB4/19s070PNdhNr7T904miJqKRTM8R4Rw84VX67WgtN2U5Qf9/4dxxMg81nYkBKAp20DZchhJHshkEX3jmP9Z/YxPzsfs8OaFy8qFvNM+0+7nkrvw+q52WShFHV+UgCVWWCNI+KTzUiQdDbhuYWGT3yUKvUKXCuI1qaUbqJo1qT4akk0izqa5hfEF6wZ7t6sdYNoSP9dLzPb9LgQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 5 Jun 2026 at 04:02, Mark Brown <broonie@kernel.org> wrote:
>
> FWIW this is triggering a failure in the LTP vmsplice01 test case (which
> sends with a vmsplice() and then tries to read that with a splice()) in
> -next:
>
> | tst_tmpdir.c:316: TINFO: Using /tmp/LTP_vmsp3vEmQ as tmpdir (tmpfs filesystem)
> | L4471tst_test.c:2047: TINFO: LTP version: 20260130
> | L4472tst_test.c:2050: TINFO: Tested kernel: 7.1.0-rc6-next-20260604 #1 SMP @1780589917 armv7l
> | L4473tst_kconfig.c:71: TINFO: Couldn't locate kernel config!
> | L4474tst_test.c:1875: TINFO: Overall timeout per run is 0h 00m 30s

I htink this is the same thing that Christian already noted (he said
"reported by David", but I don't know which David ;), where the
vmsplice() writev() emulation was done as a blocking write, even
though vmsplice only blocked at the beginning (ie waiting only for
_initial_ space to write, not then blocking afterwards).

                 Linus

