Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0819ECD6E57
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 22:54:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20AB06B0088; Tue,  2 Jun 2026 18:54:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BB806B008A; Tue,  2 Jun 2026 18:54:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AAF96B008C; Tue,  2 Jun 2026 18:54:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ED1E66B0088
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 18:54:36 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A25F0892F7
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 22:54:36 +0000 (UTC)
X-FDA: 84836478552.01.36D6120
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf22.hostedemail.com (Postfix) with ESMTP id CAEE8C0006
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 22:54:34 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Qgqh+2+e;
	spf=pass (imf22.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=safinaskar@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780440874;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0Jl73xD6zIPi47mu1jowzc4phm5baQXMI7icQsNN3pI=;
	b=Cq8KjMak0Rqf03la3GXvp8qSGje31hM+k6tYbw+rRDzP7rkMeWSx9m2I43ys2riwT3ROgj
	UwzXkDGY22WiuWdKaOUehEhB/Mo5bmYwaQTPqCLvf0peglQ2Z7P8USHPuTsjivGL+20noF
	AgjsjEqQPXZOZ2z2KNgyXG1pjvccVXw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Qgqh+2+e;
	spf=pass (imf22.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=safinaskar@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780440874;
	b=qkbS8HCPzaT4k17EGDCTWmVt6FoDQTu9jQGTUfvN94SeAuuKuoH1YLbnG4sfxrt8U3JVb1
	dyXP4/otF1x/4NkZ17LGQV3ugYsCa69SqbOZG9Z+hNyfc+UjQ4mPTwJG1Tb1mRmaHlN5fq
	x0Y6VV+tnxEpaz6H4sp7Xn1tOppCRng=
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-45ef1629ff4so3690278f8f.0
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 15:54:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780440873; x=1781045673; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0Jl73xD6zIPi47mu1jowzc4phm5baQXMI7icQsNN3pI=;
        b=Qgqh+2+e45U9Uzcb10RQAnh6m/V4J4q4+HNw5Pi3B6KYLf2UnNIZphUeCFOt0RxI5V
         7jY49xJOrYvwtNBBS7m+/SyY1Yz5bjiHHHa+xWmQ2MFEv29KVssYHBW3cJ8jTFOAFlVJ
         iij3c2dn01SOFy0clcntBsrcr7Eol6xhDjvhTxQ/KLKUdOni+ZocnET1tLarqg80dDQn
         p6xlC8CYYPExiURzJnxlD9EMKgAsYXqwMV0JAEu6Bo5TvU0GjZvFEJVfCPUDjWLXr7di
         dVaQhMc9UJuY4CN8GOAyIPkGR1kcvD5qAlB4EAr86EuZDb9c9/feaO9Ocg7Epf/JLEBK
         xwuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780440873; x=1781045673;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0Jl73xD6zIPi47mu1jowzc4phm5baQXMI7icQsNN3pI=;
        b=BAJbTYUwT2kGhOhLzUJQvSziuPazXZgoKeT4ddEZLtkc/4Hd7hW4qeN+77cemGW2Hm
         NujZ5CJax1muzIXHfOzYrYTq6ijs20bCChUSE2ZiCmOQoEb9lI059lf6IHwkKroEFkdI
         xP3Id/dEZsVBrmR0hq839FD20tVqnbdvgvWZIEy68591KakXEhtMQ4laVYCfGXAjSqDA
         Vrk2Ebs5FuhXWFjkz6KwNa2mNW9skiYE+Vs15A5AXh4rAio4jAM9+xyUktiF+jnMw9tY
         kaQUv9mr223Tzz1Bz6O21tS1UWBZIfztUh6mEkYtvCyrjO15kpssQJTgp89pxjzbMSMo
         nT7w==
X-Forwarded-Encrypted: i=1; AFNElJ9pB/DZgCbFf9e+2o1v8XaA0qcZ/a0oG13BC87f49Lm9Kjs24nZuxK+HemH2DEKHcqXNy7EXceGig==@kvack.org
X-Gm-Message-State: AOJu0Yz0Cr7q9PHDvy//+tvFPwpVMWHlq0qVai8jzRmv0drs2OZEI70F
	dDUSwm/ueQFzHzg0BnpOYHl762E1q46QK1isMb4H9Q0Dspj1bLuTqGtX2IpqZA==
X-Gm-Gg: Acq92OEeUqve+LubcbmlQFwy30i6pRHdNsJCLNMk3V+JBMhZyg1sGs8GjHPyGNgnOSu
	vVDkZuANljq9DY/dWCMPA0eqHbvM3TziWF/Vr02W/XhZYz/ByetkyqI4QC1Lg3Vk2i8igO3Vh+y
	JBip19109I6fnbtVZ64eKZWc4GvUVlOqgSxppilJPzvcsYr6bMUWwyHFWk4B8GI0xGUMQeMdpRa
	njZKn7iCDMmRf8L6/5yRs8JzWDb/B62plAOa/Bv38VoIZIvxumQtnyUIQDr3k6kQWraAOjianY5
	uhl4ygyzJE+ml+iHJikJEDe2ufK8y9ogQ9sXpDkqcQtJlNSyzkoTdNbHljT9GNHczcPprpsYT+L
	DDaYBfpmv5TOJGRVsUDH5wxMboj38ESRtZClsMjy5/KNxF4vKso2hJCbk0Y9iboB4fPHwpWUCpu
	euZvIPEbqk45lqsl+gQHUZqWv82KXVcAnYh/pbTcJz
X-Received: by 2002:adf:f58f:0:b0:45d:3cb0:5ab1 with SMTP id ffacd0b85a97d-46021873b26mr407422f8f.38.1780440873290;
        Tue, 02 Jun 2026 15:54:33 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-4601f2dc577sm2550100f8f.3.2026.06.02.15.54.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Jun 2026 15:54:32 -0700 (PDT)
From: Askar Safin <safinaskar@gmail.com>
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org,
	axboe@kernel.dk,
	brauner@kernel.org,
	david@kernel.org,
	dhowells@redhat.com,
	hch@infradead.org,
	jack@suse.cz,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	miklos@szeredi.hu,
	netdev@vger.kernel.org,
	patches@lists.linux.dev,
	pfalcato@suse.de,
	safinaskar@gmail.com,
	viro@zeniv.linux.org.uk,
	willy@infradead.org
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
Date: Wed,  3 Jun 2026 01:54:26 +0300
Message-ID: <20260602225426.122258-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CAHk-=wiAqf0PdZ4AKj_4riUnnEb=g_ZNPkLnXrByA9BBHYiFRg@mail.gmail.com>
References: <CAHk-=wiAqf0PdZ4AKj_4riUnnEb=g_ZNPkLnXrByA9BBHYiFRg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CAEE8C0006
X-Stat-Signature: iji5euae1fkfqwjs5c7jk5kz7yro6ct9
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780440874-746397
X-HE-Meta: U2FsdGVkX1/UdY1OYJdEJqSKqbOZpdSjmAcpR+beMCXTJNEmeFAY/J25X7opO4gYW1i8h2ZYZtkH2PABbNOj9X60iNrHAoTLHFplMincH4MjdXOWMJ+3RoX92HN/OxwmD57R+0XdsM1vlE/jK1WIRW8z6jJRnZBxQS4pqRCOpUyCrQDxQQPKFihtQE5Uv0fSiJfzf7UnDz1AIHumxVyDRA1PIFNpnzSCveslz/ZQ786cGjWbbwFU35gmmgvJ5yRSAArAPAnFn8cKxjIk1oNw9fciBpNdr9xJfYYmto3Cc1YGns+j0XeJiE4N3aW1fSUUtuW5IRSWugefku/lYj6UJNwtflUoW01CHopNWNDH9iMqEfRxa3pa1DyE88HdiBaoSSo5lNA+Ek9UbobjB3qZfR3YtvW5S6+DCxb6b5kKTixnKifAfUPxWWUjLXDg6CBw3o6EYEvKG7J4z+bBuT03ONKml61yzVEaZythXLNQ4bKWdakcC3cs5yWnvcXjZ7Z9ip2PJ7VerM3dPq5n4NvThE0ERliumTfzK7Jlb1h3knpG9hZ7WZQ+IJQdliPkrODYrsHaA1BylgbEGzE2KKy8lau0hzLEPzRcfL0gnlc+NH1Fb9Q4opKUfPgw4/Pq8+IyHmBh9o8TJOKUDg/czlVIPTA+9Kfi9dUFpd7gu/SjJ1jgepLcF4EVokc5Wcvw7RQGNXVDqxvHEj0+FEp5v3AQ/UCpDpXwllwsXI3gQAeQHO47cNxDUDfwM9NkGbLeUNd8KvIU/B1WgkgdrUuksfmua/IQCY4KPKe+8NkrLn02T5X3wax2+bLaFDXVU2uvhzhsTD4MuTcL9tb5jT+RTrWjebl4Hv7DRjP8Tu3QmOwD80vkPqzMDZy5FGfd+nj9C49pN9lZm0lpvNOlypm2RZ0MfyTqmwklqDBsWoA7WLF8W7v50dvIkoQaYAjCLpJ0sGECKPIhsybuCkmnNw23vJn
 bEB+xCFK
 p0TOjJBp9QIxoTPjNUyBln5OmhA9FNcqADttB/Eva4cNUc8rfeEVOipkXIg6AHhqAJSkp9YYV04TWkErZoINAAWeX4900D7U1EAhd5y1zIZ8/XP5b+trN4trXSFvpQ4r5YcOhEZsgLDW4IWvwcmrJboyNe/pLeJZ8QcHE8JnbIgqhGAVkk3Z7vv/seDva0saIazxwrEdE+ap9pyaX/V0h9MUywrHNXPdeD3RJCO4U3xlilL1sZE29nCdOt7GmQEEew68wZm/FKAZK8CmGt2U+GnyK9qPo9kh6agqWXdYKZdU75+e15gf1u4MLAI4PhU3+ODv2839fo4hhhnxfNHSreGavr34rwrTSVh2Fbid3ZSO7CcMkoqd9M1Kjch/XgRUlxgUESVtc+hjUVSSX1AsCmZV27DTRjFXRNqnIPTtBKlzjkzTPEFPAuAEQCZJan8XwEWppm1ebegRQXt8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Linus Torvalds <torvalds@linux-foundation.org>:
> That isn't what Askar's patch ever did.
> 
> You apparently didn't even read it.
> 
> Honestly, I think you are the one out of line here.
> 
> Askar did something I suggested years ago, and didn't remove any functionality.
> 
> It just changes vmsplice to be a copying model (one of the directions
> already was). It doesn't change regular splice at all.

Pedro is talking here not about this vmsplice patch, but about
my future hypothetical patch, which will remove splice-pagecache-to-pipe.

Let me clarify, what I want to send: I will make splice-pagecache-to-pipe
be a copy. I. e. this splice direction will continue to work, but will be
possibly slower. I. e. I will do something like this (see end of this email)
(absolutely not tested), and the same thing for other filesystems,
and also I will remove resulting dead code and remove
pipe_buf_operations::confirm (it will likely become unneeded).

If Pedro sends this instead, this will be okay.

diff --git i/fs/ext2/file.c w/fs/ext2/file.c
index d9b1eb34694a..8edcc3769793 100644
--- i/fs/ext2/file.c
+++ w/fs/ext2/file.c
@@ -326,7 +326,7 @@ const struct file_operations ext2_file_operations = {
        .release        = ext2_release_file,
        .fsync          = ext2_fsync,
        .get_unmapped_area = thp_get_unmapped_area,
-       .splice_read    = filemap_splice_read,
+       .splice_read    = copy_splice_read,
        .splice_write   = iter_file_splice_write,
        .setlease       = generic_setlease,
 };

-- 
Askar Safin

