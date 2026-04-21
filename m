Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E4FCF94CA7
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 19:25:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4D276B0005; Tue, 21 Apr 2026 15:25:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B23F86B0088; Tue, 21 Apr 2026 15:25:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3A9E6B0089; Tue, 21 Apr 2026 15:25:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8F7196B0005
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 15:25:29 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 207C51A0FC8
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 19:25:29 +0000 (UTC)
X-FDA: 84683541978.28.13ABF23
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4AAEEA000E
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 19:25:27 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LCVFiyRO;
	spf=pass (imf25.hostedemail.com: domain of joshlaw48@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=joshlaw48@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776799527; a=rsa-sha256;
	cv=none;
	b=n4fr1lqoriIoWAf539ykivCpXk1dTFHizjc+972HWQkV97mhBqXEWmTgucXWFwr0AqwyRO
	vphleBgOl543G/IXwe8MyM3rRenerXI3KFcbDWf1szPWi0sS3XMYG08fFpj3NthzTXwaaL
	eESqbbzMV2aoHF51HlwTcLEuPuA9peo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LCVFiyRO;
	spf=pass (imf25.hostedemail.com: domain of joshlaw48@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=joshlaw48@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776799527;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=RrKPj4YkSRaUgBXIx2X7Qs/Rb1m+H12FDYiHPqA6F4Q=;
	b=aHCQ8RPtNfhCBuROQiYwsnCFO0dogV8pr0nV61r7nbZdHjhZ5q6e8Md2gDscGbAw9eWuXu
	tguQ/D6Zw/t6lYMLkDObY19Ux8fjLA5l0SQqV+QJIbeomZ7c5DVpto11A9y1sH0IKhYbrg
	dLnR7VpmATo/lUtXPU7w1Tnfq+3XiFI=
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-43d7213b6ebso3092453f8f.3
        for <linux-mm@kvack.org>; Tue, 21 Apr 2026 12:25:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776799526; x=1777404326; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:in-reply-to
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RrKPj4YkSRaUgBXIx2X7Qs/Rb1m+H12FDYiHPqA6F4Q=;
        b=LCVFiyROPAQRn/rbDLvBTkdRgi8UZkQahfW8ABw1/2UHc7c2hEV4bi4yXmaf2g9Nkx
         t4J/I2AYRji35eKddd9jzLRHIlV4jKf0he/HTtVdYS2hCCfjr16IKPjsKrdatQJGVNcn
         JI46RuAexSfHRwp+ZS0QoSrwtHqlQwqesrQ91DSTLntVbEmQwQD2Ab+zFOyYtlmEYs6E
         7bfWNmLH7LgdUP1ic4+RlqmZmFlpslSAan26NxC15c+xnZQfZrvatE9m3rbUhFzOyR3e
         rKLSkF83qgvET8BS5Wr0e0PY/TjfIVpg9l7q+dqDP5PRp6GFNPy2B8BTLA3vGn20/Bvf
         iliA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776799526; x=1777404326;
        h=content-transfer-encoding:mime-version:message-id:in-reply-to
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RrKPj4YkSRaUgBXIx2X7Qs/Rb1m+H12FDYiHPqA6F4Q=;
        b=pz58bFqZAoLDBUqeh1KwyqFWFaPJxKeip4hhqVdjjM/i5g6h89Y64V7xRrmIJZqFCN
         w16bvIrkRLIZf1GiZqaDOXX8Ka6BBRivJp/1DwZ4XoDdeFIbfZb3IPtTyprodlWpGQb2
         QkQ97aJI8wr7YPevMGSEhgmNmM/ShFw+7W+e406Z+CNJd6MMk/ZbF+dhc7T+0v6CgPe+
         JDW9hxR+G6wKclpE2Wp5siKg/9Z3SvVnlKHesB2GUoXUrR2GkADnaBTmU7qOiafnjAB/
         esbEcZ7jGTMj7DJcrAlxjm7wYpebFqFGPDZ6vgBen7c3VPRbI3X0Fo039n0czeicKayY
         crIA==
X-Forwarded-Encrypted: i=1; AFNElJ/aIo6PWYLaCFwxfQOOUQHyX0zgpZepgoIqgBx8Oqi5l8Sm66gIlCBCxfp0YIH/dkzg81eNoUQ/Lw==@kvack.org
X-Gm-Message-State: AOJu0YwdQwZ5Z0WouumA9XwgRdO5kk66um9dNOHTTIGoy1hal1g/U4rq
	C9zyqpbZq57sXgeG8ioSlE9+kamAjTzoW2U9wLNPHsRVtFIQ8i6t/NjZ
X-Gm-Gg: AeBDietkgjOQpL4vcPiIm0P2fIn1pLmSwCirIItTgDx4qU9s2WLRvfbDEfAMLTzcN6b
	huatxnJZJmUuI05F725H4ZuGFIxYyw/va5aK3iuTqNR8jGEn77yx8DK5bZRvBrzzb++gluNEKlV
	/xpc9Rgxq0p1fP+fVIKest43q0SVILXYWIdfyV3sa4ZPAbPAXwx/ocQp0+UqVH4MISYOG1mZwYx
	OeBo/nUZUAah5e8OQDcQnQ7+WsIpIe1VCbIiAfHCfxm62hiurZjP22OS5pzXK1EuJqw4s+fQsp/
	opJ7jEMhMx+zV3lDD3h/9SCh3iCm1//V599XI3lkCSZqi++MBqLG6YI5j0BRIPlcyKln8eJUQIr
	SgP0EQ/P7ZMWRtxoBmDb51btvsyaxXzJxQ/FM8HY50HwnSr0EgpiV86MhWvxWTw3lAbAyNFDi6l
	oHyZCYc1uPDUhPmC6cq1MNIUdqh1ppsninAV/GVuMX9EmEb1Q=
X-Received: by 2002:a05:6000:2f8a:b0:43d:7a08:a5e6 with SMTP id ffacd0b85a97d-43fe3e073c9mr31925834f8f.29.1776799525406;
        Tue, 21 Apr 2026 12:25:25 -0700 (PDT)
Received: from ehlo.thunderbird.net ([2a00:23ee:1cd8:1171:2646:73c1:cff8:b7c1])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4cb13a0sm39668710f8f.8.2026.04.21.12.25.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Apr 2026 12:25:25 -0700 (PDT)
Date: Tue, 21 Apr 2026 20:25:24 +0100
From: Josh Law <joshlaw48@gmail.com>
To: akpm@linux-foundation.org
CC: david@kernel.org, linux-mm@kvack.org
Subject: Re: [LSF/MM/BPF TOPIC] MM transition
In-Reply-To: <20260421094216.8dfe14a8c62f2420fa5aace1@linux-foundation.org>
Message-ID: <16B7B5A8-EEA7-4580-A565-3A0B4DBB08AB@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4AAEEA000E
X-Stat-Signature: fsf3b69jnca3qraffjmmqyug8sopnpkc
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776799527-689402
X-HE-Meta: U2FsdGVkX1/y5WzPwgAeHIKWLBBRfJx8W6In4NHecQ5fA4SEQ7qZZP11ThRagLwVjgrZosbedo68IXPbHlgQNe8Eil6zS9ovoQSy5TutX5ZNyuqwJosSqLPcl/82a2CxEafhk+nhbsh800Bsn9R/QhOZ2mORSukcIG3JsDeEnEOLzG/ZR6Qcot8h/2r4sTvvKnVP3njoEx2jKvXVaKjVWJLEHqC8nbfLi159pY9lDKB3j2f1n2raRpTgkM7cJR2LexrU+lHFprU5nTJt80AQeJX70wKrFWnPJSFtm4b/73L4/9aIA8LNUhDNn8nOiu58v3joKV3ACNDL4EvOHP5kuKFVnCoeopaWuVpaY92Y2BLQnHAiFdyM1q2V1Gf7YfoZo6fkXyHJ7SMUHP3wIowur3YX1O/7/UiL6BD18XRitveyu77P5XNPylxQnxIrhgsBvmK6o4uPvuGAzdwZEHBnkBt9i5lsOjYyHglu17mDVkQssctpAK4LbpZPXgJckgkkHO59SQ5B7ox8dpxatXngSYdOOLeggNYQb8ubbSEZdutcwqJ0SXtAVGwJfxPFyZCR5o54YgkeSYurISZPGNVRlqNAhYqtwLERoDQRC5+C/ay+D3T8omOYKjxlTbyvLBzT9ulgpq7Gl+l/ObDhhwKiNtOThaIAVqu60Os1wWJ9omfnbWS38ypPpXPIMT1K2KAnjkZDzDsEepBmR9XadAnddXQ5xg3XyyUaZ5mpQn1C6bvvCRMZAzXtaQTWLNG8zzkOurAI037aaROsMXUd42OVdPrL5iWS/fXWB7yPic2KWoMq8GPY2Z3CIny/gaG1NvQPlogRLYB4xdKeM3WVI4ijd87i5XMuS4jHn4N1A0BRIIjTkKaH1YVBG3NQFslAG3Yh7hG2MQ23X8mBtTZNPw6gCYOk4LCsc/zfXMQnHShagnFjh1F5G8zYpSIrNUqg73wez498uKJTd95j+8QZjDh
 BL+4menZ
 qytNs2YnPhZu4C/I2yYGccgpr/hbXvqvn0TUkfABNndojpUGbhHi6TailjkU8g8FLUTfefnJ+vgC4MtpKMarJuMlQBX01OX0p9QkgoflIM9tvWYnWm0ksmO0XbslKfvNK+xN6/WQphQBkJfZHHTPguzNkk7yY6/lFfF2UIo16Sp7CXG9lMooGHlf/wqUrs3h0OwGJjuBeVN4W+kyfX6ZtzgPBASIadQdFGlL7oCqv6CqFNSWSGOpw5hWO+ZRREGdPberzL0KkR13yyLFdY7EuYsnz3Hv9jNVxBPg1AGLGrVfNN8qWL4BREXmDvLSNKh+nWyJGpZZ9eN+sR3VJ5tSy8AFADvT5j5N3fGvBtU0Mh1hF23YKnLjyRJ7FIE+05xLAdizX2so5IUEYRhTZ0aIck2ZMNAPF/W2kSQ2RobLAsnJFcDYOpQlX+avqI5lt9vaKLyOX82cxvcddLOLh6DkYULM2HplBOIR9Mci5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello, since I'm not coming to LSF/BPF because of my age (aw)

(And I'm more than aware this post is more mm focused, but I'm
representing lib :))

I'm "virtually" putting my hand up


Whats going to happen to lib/?

I'm aware there are submaintainers for some files

E.G: Steven (and Petr) for vsprintf
Masami for bootconfig
Willy for idr 
Liam for maple tree
Etc

But let's say, lib/glob.c, or lib/bug.c, even lib/inflate.c! (And/or 
all files which only has you set as primary maintainer)

get_maintainers.pl says just you!

If you retire, let's say, then the files will be orphaned, idk what
you want to do with these files.

Thanks! :-)

