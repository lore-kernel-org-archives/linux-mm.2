Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1602CD37B6
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 03:51:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DB626B0005; Tue, 12 May 2026 23:51:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98DC36B008A; Tue, 12 May 2026 23:51:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87AD16B008C; Tue, 12 May 2026 23:51:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 78A6C6B0005
	for <linux-mm@kvack.org>; Tue, 12 May 2026 23:51:00 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1E563C2522
	for <linux-mm@kvack.org>; Wed, 13 May 2026 03:51:00 +0000 (UTC)
X-FDA: 84761020680.23.05050AE
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf19.hostedemail.com (Postfix) with ESMTP id 0240B1A0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 03:50:57 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=fsI8lJxO;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf19.hostedemail.com: domain of surenb@google.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778644258; a=rsa-sha256;
	cv=pass;
	b=GflLQc2u8uKONxcZsWWlbO/a5L3ArTdpdk6qcxM//eFrLcyYR1uM2mmxQNt79zSXNVoEYu
	o0/GFT0ON6bi/MkENu8gvL+eibchgu1cX6ckK2nBWzSGl4aSUxcDSfOA3GsOZ8LNBZ11ot
	yFGTNA3A0J5z9+kCPNZUrYAi+oOX040=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=fsI8lJxO;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf19.hostedemail.com: domain of surenb@google.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778644258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=55D1DN5rEuWPlm48vc4v77aNlbyIDswld47F/9dkAa8=;
	b=A8hwVjP6Gosg00xiN/AxuU9bGJcwREEtU07ZxyCrOD80REMZaxQF/e2XBnJHxGnUIk7Ztp
	12pOKcw5quFgJdY/0ISgPNblAJExQZEnPMYxQfS3VvTbz7mfGNi9wU2r9zlT3ZV4TTArnG
	2cyL+koLDSLP2banp4gJli/pcZyfhNI=
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-67bf769704eso4a12.0
        for <linux-mm@kvack.org>; Tue, 12 May 2026 20:50:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778644256; cv=none;
        d=google.com; s=arc-20240605;
        b=A0amJggJlYF9y5M4QA4j8bhg/94w+0kP3KqWQ/F7y0Cx4bpEQwygiT3zMzJltBiA2Y
         M/2O4DxC22Qv+8mXJwWfjpqwqed+gIoXef4q+p+SOXYShusQ0XqGm5fI63ExVsKqD5H4
         9IMdC7bV1ZkxqMKh82aj4moXZcMGZxrxzwAQsAhBGOjtfnCogvclfsse0TIKzZx00oM8
         Lbv4FeeqlEwTeV7Fzj2QqVa1pO1IsYoFnPXm5i6kZIh9ZgRUKRXEtTTKCzoeQwb6gs5q
         t6N/7gXffoosovSeLH6E8IQNMfibW3paSN9d1MBm9BPYvEHNRpyEdIwnG01WKlRkMuHD
         nzDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=55D1DN5rEuWPlm48vc4v77aNlbyIDswld47F/9dkAa8=;
        fh=AGLaomqx0DxfJcsy5orJojutQndHmbNVPumubuQE/7s=;
        b=Gfsi0K/xzxSqAvoOGlXeD8mI7Md7Z7jKZvN9bS9sqQ8jRRwlJnFwjQk4nGBa3qYjig
         ULAP6gdvNv5Bs7FU9kxwZ4J9nKK+6ErcaEfw7NR2ONv9TMwZ6zE66nmXgCeE8nZ0jGi/
         C4H6nrtiDAQy6wRZ96latBM0d7ZfzrgHAG80HrGbInMzpfzUbBNiqnHLUh9J5h0NNW+B
         fO8KpruOAOIPRGcao1qGSjqUT+taialKnzXRExcubcqbj3PIJORxqi7DC9NRmdgPvUtL
         gKbdZWuCDwQAGUjUb1ZayEKmhCx2W6/t9NeeTaxndulCzZNlTLKQK02+Q+QDSd7imJa+
         m8cA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778644256; x=1779249056; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=55D1DN5rEuWPlm48vc4v77aNlbyIDswld47F/9dkAa8=;
        b=fsI8lJxOGKPjpZTmxRjtaD0sPsh8Pzsi9nhMNGgwqWHMuUKAT8perwbRlrwVdTSiRI
         D/4Wdwu4amGaZ5BxjaGKu2LxDWkoDFtNbU7VVldCDxlOQozZmNE+xxrLbWXp70WXjYsm
         o3x1hLjZ/SKBWbdB//A5T9WO0FOR9HVUVebK6NSZP0BNQZpIidthly5ra/SnPYvanzIe
         uGWEOIIMJ69Vp9173yLnQSo1m5g+mapn4G+dsmU4iZvJqLFZBiS3FV4bo+yVW3ZcA1JK
         uRtiq3/FJHBW8xJMpkIccsbOqpSBu62cFvvG8Ixyc1Ig3Jg56zXlnsPCVYYdFyrIV6sP
         Dj/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778644256; x=1779249056;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=55D1DN5rEuWPlm48vc4v77aNlbyIDswld47F/9dkAa8=;
        b=jmotGwMkWjpvMYTAfUN5yO351EGJ6+n/PS3EqNg66F7H8kMezEPR3Fbr8fdtB9JeNw
         nmOLnViCaAFNruwLJaStvwvEc61T84Fnsfbg0u+OxeYJq/4CAyhLq9S5LFqMKK6tBMAN
         NcwaWOJco1vU16uTUPJb+uCjGLJOtWCCtLsxRcq4jcBVYrR5HXvNkgF6ud53OPlBhFQ9
         wLAbl2utnFfIYu4EeDu5XZFqpS6fUl6NZ0Lt1uiaTN+s05FIyfutx4trf42v96CBhxon
         b5/7B1nPzDpWTeLlhGjkmuQoZuATYU4dfR2uaSAQ1TiSHxZn8DDgKnt2/OoGNnxSrjzg
         SUew==
X-Forwarded-Encrypted: i=1; AFNElJ+0cXE66HbWU9hRu4j9g5F2qrBIsymNv7bAjo9l7MQXgQAkdWNjc92iZsVOs6qqJmptSpt3JQ7UWQ==@kvack.org
X-Gm-Message-State: AOJu0Yx4Kzp8G2y/wKzLFyLyH/sxGzr75n4J/kTmtHSCN6TZ+JL/Q681
	94D7j+0M3bJJCjAEJ1v81z10USoYeMHaJ6ZwOn/Ww8tLj31IYMX4BQXC1v48iC8bdJIhqgAE+56
	cR+Vf8Vt5Xmja+SvS/ECWJXNeLJCYJrtz7Bjw2Gi7
X-Gm-Gg: Acq92OHKqjbqueCFfU7STfLRwN5x3bIzNup8VyWDn22sXVmHqn2ZkeJe6CLsthI20Dc
	04FdgNfjwBgkyg+8SlP0DKpztyPHww82U1wEgXgo8Y9p42gQmJz9abnSYLlQ+m26Dtx9dGWROaN
	4PehnY/YpIQjesABfuZqinOV3SHH7Q++977I91sJPKdutJzWSGUA9nz/GvcVCMCdd5+9ooyu+g4
	rrQWidw9s0ybiRd96XCbaMectxpEniytWqkrp9TT+XbWp0XrjHRQH1KxurZzVPINUpihunkIANA
	B8A9XsA67wXK0rCo
X-Received: by 2002:aa7:d785:0:b0:67b:6d1c:9585 with SMTP id
 4fb4d7f45d1cf-68214ba3045mr32613a12.8.1778644255979; Tue, 12 May 2026
 20:50:55 -0700 (PDT)
MIME-Version: 1.0
References: <20260426062718.1238437-1-surenb@google.com> <20260426125941.9921d585e2c5033e68ddb9a1@linux-foundation.org>
In-Reply-To: <20260426125941.9921d585e2c5033e68ddb9a1@linux-foundation.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 12 May 2026 20:50:42 -0700
X-Gm-Features: AVHnY4KooogSc_WOOEscskwK_cvUJBgoIv2moaw-0M_9CqRzzIq_0iRE4kQW2m8
Message-ID: <CAJuCfpE6L8ZRQEBUVx7j_qYQQJB+coVPUMPhOyHc3V_mBLF6cg@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] use vma locks for proc/pid/{smaps|numa_maps} reads
To: Andrew Morton <akpm@linux-foundation.org>
Cc: liam@infradead.org, ljs@kernel.org, vbabka@kernel.org, david@redhat.com, 
	willy@infradead.org, jannh@google.com, paulmck@kernel.org, pfalcato@suse.de, 
	shuah@kernel.org, hsukrut3@gmail.com, richard.weiyang@gmail.com, 
	reddybalavignesh9979@gmail.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 4jdkwfcqkd7c13cgxrcypdcgzent8o9q
X-Rspam-User: 
X-Rspamd-Queue-Id: 0240B1A0005
X-Rspamd-Server: rspam07
X-HE-Tag: 1778644257-778491
X-HE-Meta: U2FsdGVkX1+GUANHOBzrVppUc/Po10hGUpqO4ye8CMH0SXmGrm5HGgxoiXpGgsbmrSb6U8WTsPqV6PKe0H/O6SJ33/wO2ctDra6fyLe3ST4XQfCnV7Tlfqjwtc9uMSe+1coDhgJFz3TwNgZl6fdj9/K8E9rvmMcS8zuG/D44eTI7l/55jGAFyv7T82cK62srvAhytO4Nt8BHO00pf334VLwNoTnDBqWtH4S25+Ny8NcpnfbT9Q3VvHVhBqASY2U8+FVmhGWajvmdSD+k859En/tekvpHKP81cvITDVHguerTzpEDJbywwXonk/Oum+oUIwBYyIPErXoYSSPPpa0Wn7rAK52taaDV3fEX9F6ZfUTAUFcd2uxk7R//SV+hhYIhL76JL3Vy2RvChEW8Q4J2MSiga3OrTBkMZ1Fm3Lkba9OGuzxauV9mK09Nv6i4gbZ2grtvk2c47SLHupEcVEKj7seNu/qI9zZ5DftiVysZSkZUCPgsdfekj/P0p3qbG+IjiulMam7D7RO9tfjNBXUy2mju1lJdNfcMP2bdtQer+ppWwaaJvqBS62fxBeVj5WY3vxl/8ecPv4tlRD/gT3Da3WTH6J3rNRYOZ1D3NgL5PRxfHP8CLyGimPgTwNDSxW6tQ6z458MzxryJmcGoQNq6KAvmgzRTumuIY2zrIaJRS6gdn0OxLOJYc0ncM9fu7sZ7UO0OQM8admZCS/HFmv9BK9sCyN5JrXzhI+XrsA7J/K32RCB76G4ujPhWW9vwnxqk6O5qUCHUrGl+j3a5kFgnlTgmZWQjEUYmM/rQjocmZw7w6/cyAdPy5q/KOFPIRJpTMvDVoDnCRvl4dksuffY6ivOBQPvfKUqWgF741aqkmdqZrrQ2z4wAUjgdzqis/3DkOvcUFrHLXBwhDoxFW10eaxEhTvlxzYFfHIRzHCG+VEaKLQbK1iwB/teXCeiHewsjLav2dc38cAzGTjNR/EL
 SFHbXqE4
 HlLLQyObRiJOLCHCuzBuwjnlM048c9WhQl84e5rbuCbNyMl8poUv3A9P/8J8BT/9WvTU//anr2qHXXJ9GZha9qywbjXOdYG+jZmoLaAwyq9veVDch0O8K/AKKPtyOs4IdY8PI9R1ZfZDxXMs7YYk32z7Zna6qOM84MSBfrAuX6a7rIm2gvzjpd/f+8fm5meogfVG1+yZRNvuXfyCLF7kEzSFGsrl0rN3hl1XZbAivxbQngbt1aaoidaxwLr7uDq76aVJVYygQ0I6/o3QcnflY0hQ2Nt9E9g1ABSzS0X0uNJS6Mb/JDRN7LlqGGUfzB4d0I08p8owOOskEzaqmhWA7HbqblvP+H470O1tZkvkPvRo1fbFtxedbXREfoQAlCwMGjm+AZEhwq+kSe6bd/tcJTSgKWcL65z8qJHeipnHteRoFyTxeNXhgnLazExuxhnRWP0GON7Vp+noS+dXB+LvQYlsvk1mq0qdE9uaTub2PJ2LGq9QsZLQ1RRQKGA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Apr 26, 2026 at 12:59=E2=80=AFPM Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> On Sat, 25 Apr 2026 23:27:15 -0700 Suren Baghdasaryan <surenb@google.com>=
 wrote:
>
> > Use per-vma locks when reading /proc/pid/smaps and /proc/pid/numa_maps
> > similar to /proc/pid/maps to reduce contention on central mmap_lock.
>
> Was the benefit measured/measurable?
>
> Sashiko doesn't like your strchr():
>         https://sashiko.dev/#/patchset/20260426062718.1238437-1-surenb@go=
ogle.com

Sorry, missed your comment earlier.

I think strchr() is fine here and Sashiko did notice that read_page()
always makes sure the buffer ends with a newline character, IOW
*end_pos =3D=3D '\n'. So, once we found this last newline and moved past
it, we terminate the loop. I guess Sashiko is being overprotective...

