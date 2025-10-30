Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59071CCF9E3
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 16:43:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3C09280018; Thu, 30 Oct 2025 12:43:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEC7A280003; Thu, 30 Oct 2025 12:43:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A022D280018; Thu, 30 Oct 2025 12:43:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8FA4C280003
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 12:43:45 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0385186524
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 16:43:44 +0000 (UTC)
X-FDA: 84055352010.04.29C8F8D
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4EECC4000E
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 16:43:43 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Q2NZ4kuC;
	spf=pass (imf04.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761842623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=m6k6XNHyblLB3jubL9kSmrYdZGI6TYgp6RIv86S60EI=;
	b=GeiazYLLxp51G4rdjPHsX38fOwUNh+tS6HjAM3EruBuKnFQ4WasgLYkGOJWq2nWp3mDg6u
	wbeIwZBFV7wPa9QLv9iRFhIcvx7e/FkBgPOIMfyAF3FoO5ybheHi73C/IBj5ZF3vHGWumP
	8ThZ3Dcb8qsgF51bsIyAEi/6vl7tKNE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Q2NZ4kuC;
	spf=pass (imf04.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761842623; a=rsa-sha256;
	cv=none;
	b=GxRnXiuH45JFFjzJctKTiUyUQoeczuDhfSY+8ErupPhSm1KuNlEUakQf6nRVAE7fOPel07
	AEAzPC2ORDG3pT4SNr2WE2Pf084fG9bs1IOk1Gll2lje0Wc8CDzDJUHzLrBMtR1GcVOIQ2
	fEz9q11AiCHZ2zebWbTq4LksnxcK/gc=
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-4298a028de6so1502090f8f.0
        for <linux-mm@kvack.org>; Thu, 30 Oct 2025 09:43:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761842622; x=1762447422; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=m6k6XNHyblLB3jubL9kSmrYdZGI6TYgp6RIv86S60EI=;
        b=Q2NZ4kuCQnTQNBJcYiTR6OXejf+JwzLeMZwPCX/dOXxZPDsTI8+jxved5sqejy+yOk
         sfUgBI1Q6gyINWiNqg5Ov9/DcsZgEYxA7OBEQ9bPuPGzLulmklwdQiQd5SmloMkeQ0lB
         CThqLbfr+17dge+SDiVRBKxXXeI9CjUuw0uf/n64gKXGAK32TQNWvRKZGxU9fp+lNNSr
         X+S3zPmwDLKzboBgCZ8Ab6ShKXHTzDLAzplttRluFOPzgk2JMYwfZAKj6hHA3w5nTXOB
         KT3KAax3jHIvAWkLPPrzL8VYTK6+lsG0cYHRdtv7IsD8mosnTgz6Y+evGLNKe1/UW2sK
         ChFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761842622; x=1762447422;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=m6k6XNHyblLB3jubL9kSmrYdZGI6TYgp6RIv86S60EI=;
        b=R9oVeMaNNBdC3LEmpiT8xHqeAQyyh6fXQoKzZNRnihGhUdSgEJHjTwuzSDpNWwUIIk
         F6JL2ZkNf71zSMDTtNK9LhGCQAQzsvnauhFD2NXo9qRa+lS+/NswtvJFcxKST32uR5xw
         V37FNha5tfmlqGj3MYXX4xh85djNZ4b8VumxWgBVUP9nP3ftf6kfM1KitwE1LySxlvsg
         /GPR6gLQZ/P11R+b61INgO0IFaINr5yFg8oawRQd5EAPpE57I6KiP73VP3uxno10veig
         0uYIIDGtpBPJSkdpZlGygx13pO235xKmy+ZHq5ejV6N7eJiHXFDi+ZUFFdDwqISqsd6S
         /HGA==
X-Forwarded-Encrypted: i=1; AJvYcCW80JuBDMC4cvPLd6IcpMRdWqYQjWjwaWJfyTA0FL7O3CncjnhbeweT/3OJsRgAju70IlPzIbHimA==@kvack.org
X-Gm-Message-State: AOJu0YxoYI5CEQS0w+i/0HnbnuiTNAdlXTPe0+af+S5+oMvYQz2f2Fg9
	+vCBIjQr4v0byHH/TF4HtUmWIjzi0NNACdBluobbNLtuoHAgBaLY3hsO
X-Gm-Gg: ASbGncsfSePpBWBa4jqwHOBOy4W3PWnNuRe8yXs9xrbetuE/3v71g8xoR/Sf2QaVQo8
	JKZJSKKXEfnVrHyNJBFkbj4qM8ew9BxhRG/KYSUTFrToBet6CWebUcFXM4LxWXFqMNw3INhW/sQ
	gPp0UVJJUoE4mwhAjzDenQofBjXFfZqn1//lcBLQ83GtNG2yub51f3q3zJ/PVK4L6ZZ+2xX4jmp
	dKHN1u+jJ2OfHxWGqp4+TkL/cu/LqOwasD2CzxfyHYhxQEg69c9eyNk9jn58cRYSj4+5UHBCnpi
	iUUscvT3hX4UTNFwoHCsfoCGtPhVyXnUjeIOoPHtz/KcTI+FGwgJf/6sFfrIeNJcszT9qxPBdiA
	M8Infq7rAr1hrzZmvuegWSgXav7x8B1IXhc8rTe8lTbgd5jZD4l3BRfSoLGugceKOcnnxajFLZm
	Igi6Vb6+Jl7yNbnoj9aWE5ZPxPzwdV6e2Nxr1rZfd4EPE3TAfWIo4=
X-Google-Smtp-Source: AGHT+IEgur31w7PpEABIuUIKSb3JLUGXc5YSFWC+gqstPuiPKTVTHH/djKSDsdIJB+2srU8GdUsZuQ==
X-Received: by 2002:a05:6000:1843:b0:425:86b1:113a with SMTP id ffacd0b85a97d-429b4c68afamr4108786f8f.16.1761842621567;
        Thu, 30 Oct 2025 09:43:41 -0700 (PDT)
Received: from fedora (cpc92878-cmbg18-2-0-cust539.5-4.cable.virginm.net. [86.16.54.28])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-429952df62dsm36796839f8f.45.2025.10.30.09.43.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Oct 2025 09:43:40 -0700 (PDT)
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: Uladzislau Rezki <urezki@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [RFC PATCH 0/4] make vmalloc gfp flags usage more apparent
Date: Thu, 30 Oct 2025 09:43:26 -0700
Message-ID: <20251030164330.44995-1-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.51.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3hzowafm5scpx4b6x56f6zdecx79r3as
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4EECC4000E
X-HE-Tag: 1761842623-574440
X-HE-Meta: U2FsdGVkX19v6jyde09oQU2XBHAh0Okh4C9FDdYRMtKaaAV8wjeXhFnTKRnCDQ8n5SFhxLZ1LRi8kBDJfJPeoYxtiFw7KC5cSnbvLcE0wQI7n78K28UQVGZ1r26H0M7SFyJC4mDNglsMj0BDXnT4Qm4G+02eeBlTudQ5basCGnnHPkYQ3WwA2A15ESxMH+AHdRHH/3ZPA5DGYLGoLu9utQgul+PzZinmscI9JzdEm7v7yz5qOMT25eMuexcE7AhleEjgHBVq2OC4GwB0HEIw2pqhv1LLpaCdd0Z54U+ozgK+wHVmxiwiA6fVFewG2skktMjiJ5Y1srLjRFhInwL5UACPJzSjlLzOz0wong7Y4vxUa8Z5D7Ztk7HYxoI5drMqN+0+5L8VwhK8gOJA2hFkoarN7Ic/V/nOKogtA2EB8sIwGc/hWX7IqK4og1rh2rfL5Rv6ranyeGKkf1QDg5B0AZBNEPh9adFKUWlKeZeo36hYa1Ms+SUYhr6BiDPa2zr66bdOQLylSKOwSLJMSttreIF7GdXFIw/qHk5NNWebqw2YqylZH7MFYK3j4dpBrD6N+N1yJkJod976hGhYqxiddEADVtgLSy7LTFgUc23dRNkTV9137yrRTHRCBGBBAFMdUlggG5J4l7eGXJizu5hXfKqE8jOGOnWvjBp438DIqPSoBzxJXwedBg54jPsz85s9otodfMsa9JLbWC8PVNHaGZzYSECYzk411vDv0uRsJXl3K1eUqfchpSRodHWiauAGN1c87GH50Owm84BhyjbnWfFJzZCQR7Q8P0rMfaQOaa8bBiiNpb4dUZA5PA8MAIXOVCq8k6vYLMq9MynzQhl3KUB3qPi3EKaJ1Ww4LkRSbmIg7fqgF3xghkHhnQ290RMTNVJhVThTrke4RvjC9j49I5RxlGNu4jvHkzWqKaUoCCf357DCgxLW84b7cOPL8qFuQ+HlIYgcMwYMbQFTnBN
 X3HrGp3z
 K10+WwltzZ/ZjFQiYVjzQLLWc0zmkZT4iTLohg3fGwPiM4cKLuWtdjUvZgW/LOORpKxblQnFOjD6rMNCz3NQTw+RcaUWsxSyHmDu9o8oiVjQIbDrYKz/E9+3sMMi6vMOZwvZMlkAguWiD4tnzlkmwI/W/VCZts3y2K4DxpJG9DYek66j3EjOcPJT/IwqpzPnrHxKO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We should do a better job at enforcing gfp flags for vmalloc. Right now, we
have a kernel-doc for __vmalloc_node_range(), and hope callers pass in
supported flags. If a caller were to pass in an unsupported flag, we may
BUG, silently clear it, or completely ignore it.

If we are more proactive about enforcing gfp flags, we can making sure
callers know when they may be asking for unsupported behavior.

This patchset lets vmalloc control the incoming gfp flags, and cleans up
some confusing gfp code.

----------------
Based on mm-new

I did some digging and am not entirely sure what flags vmalloc does NOT
support. Is a better idea is to have explicitly supported flags and drop
all others?

__GFP_COMP is an obvious one due to a BUG call in split_page().
~GFP_BITS_MASK is also obvious.

Then I started following the kernel doc and added NORETRY and
RETRY_MAYFAIL, and after forking a couple hundred times, it turns out some
per-cpu allocations pass in the NORETRY flag right now.

Does anyone have a handy-dandy list of supported/unsupported vmalloc flags
that we should reject/clear? Ulad?

Vishal Moola (Oracle) (4):
  mm/vmalloc: warn on invalid vmalloc gfp flags
  mm/vmalloc: Add a helper to optimize vmalloc allocation gfps
  mm/vmalloc: cleanup large_gfp in vm_area_alloc_pages()
  mm/vmalloc: cleanup gfp flag use in new_vmap_block()

 mm/vmalloc.c | 41 +++++++++++++++++++++++++++++++++--------
 1 file changed, 33 insertions(+), 8 deletions(-)

-- 
2.51.1


