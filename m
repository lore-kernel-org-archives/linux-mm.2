Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA088FB44C1
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 07:02:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7B656B0005; Fri, 24 Apr 2026 03:02:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2C896B008A; Fri, 24 Apr 2026 03:02:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1AF26B008C; Fri, 24 Apr 2026 03:02:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AA3AD6B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 03:02:58 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 523C2A0997
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 07:02:58 +0000 (UTC)
X-FDA: 84692557236.21.9C63CA0
Received: from mail-dl1-f73.google.com (mail-dl1-f73.google.com [74.125.82.73])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9A2804000E
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 07:02:56 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=D7QLvI8S;
	spf=pass (imf12.hostedemail.com: domain of 3nhXraQYKCMs9B8v4sx55x2v.t532z4BE-331Crt1.58x@flex--surenb.bounces.google.com designates 74.125.82.73 as permitted sender) smtp.mailfrom=3nhXraQYKCMs9B8v4sx55x2v.t532z4BE-331Crt1.58x@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777014176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=zxJZiwOMWb+N8XiOQ98GcOFWZadlOkrX+lM5TYojf0g=;
	b=UZ9j0xm5PB9wZNMVlnCtb8wTi+avIw8Ixh9yBJ4v1gEzgQP6QguqjStjTaCxai/8MOWV+B
	vVzjcKOK73L0O2IB6eIG/w795mdtUfa1b3qg2mjkKNMs5srW1k4UVhsh/AsEb8na5qQUUD
	IAnct4gTf4dJtcKNX6BYpKI6egqv7m0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777014176; a=rsa-sha256;
	cv=none;
	b=k8+EO1QdgrtKdCG1AFgX985W7ZZZv1/me4zogv2vk/G6nY8B58BLQSNM3ukvSVsvEbvY1K
	qp1P2cJJduviQdnojykws2RILDBJ5PIat3MTVbPZVoLjrs7BpaXkxYOAEQ6vbk39MSn1OC
	4SC1ZgYFuWZ4HMLx8MMbUGMYfuQweVM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=D7QLvI8S;
	spf=pass (imf12.hostedemail.com: domain of 3nhXraQYKCMs9B8v4sx55x2v.t532z4BE-331Crt1.58x@flex--surenb.bounces.google.com designates 74.125.82.73 as permitted sender) smtp.mailfrom=3nhXraQYKCMs9B8v4sx55x2v.t532z4BE-331Crt1.58x@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-dl1-f73.google.com with SMTP id a92af1059eb24-12c8ccc7593so8291283c88.1
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 00:02:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777014175; x=1777618975; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=zxJZiwOMWb+N8XiOQ98GcOFWZadlOkrX+lM5TYojf0g=;
        b=D7QLvI8S54EIs2C2cKPGAPtBSkRsSLjXc78Byi9r2yxU6/VCq8G6XGRIzurH0TXUpe
         wjm738v7XrEqu7NWQldJkJY3ucm/B3XSqYCLYh17qjcoE/AFtHQTV8OjjwBJGXerqU1U
         kEKr4+rcwRucYL7goJln4gHcvCjGVh4Tjg0unT6UlmBXf4ouTFZMTXVOP1ytlJzgk0j+
         a98Jkn5c8XfUwmPxjzEoiSvL2D2a4nRDp9wTbQvpMrJOPlUxC2A70qu0+EuaJ9L9Oiu8
         +u9jXyXl7HClgj4OAGZHtpAZf+Z65EgWuQqfkHcnThvvjZ65tOdrZk/dIYMGENKsFy+Q
         wMwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777014175; x=1777618975;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zxJZiwOMWb+N8XiOQ98GcOFWZadlOkrX+lM5TYojf0g=;
        b=QIAR7DF1jveGFEpwtOODqZ3pQKHiAvoTF3WB6oYGTfxMPMtI8Mq/LqKd0nDK0+et0w
         +jJsxOW4Vno2uW+F37EyNQldMfFpyS4Y1UP8uBwUT496bzn1pILQzjvqaO7K3N8zNi04
         /aIIqwpBBA2n3dIiZq1OwJu4WrYsavLuNFYSp1su+kUk2FZD93UJ7aX0pvP1RMFLL3gQ
         b21OpRz1YdbZIbbuCz7pS9U9DJzHWU3t89Ygcrxc/i4AC/TV+VxOsRCQq1YLfrKMKtks
         dk8HV2t7hKcOmHWBMs6+ePoe/IVaWC82y6EZ/F2fzuDCG/41i16hrG4B7lWA7KnRFc7f
         pbhw==
X-Forwarded-Encrypted: i=1; AFNElJ/k1irLrDSf+6r0vPw7kKoLoe0bgyvzyIF2A2OeJ6HEyoPjnFkmLGJmS+GsOmzANR6iUz/0sKibvg==@kvack.org
X-Gm-Message-State: AOJu0YygZURImNtO/KIVKNEWjKecsoaQEdu297nTE/f4RGYMQ86N6kCv
	U9QsTDhWkve6DZ5S02XxbckdL2DEqdXfHgWteZPLA+u0gdyEbcMqMv+CasNcEGtJA4fRZhjNy9p
	ARHcRcw==
X-Received: from dlbcf6.prod.google.com ([2002:a05:7022:4586:b0:12d:b65b:1fb3])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7022:6895:b0:12c:8e7f:1b30
 with SMTP id a92af1059eb24-12c8e7f1ca8mr10233008c88.2.1777014174940; Fri, 24
 Apr 2026 00:02:54 -0700 (PDT)
Date: Fri, 24 Apr 2026 00:02:31 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260424070234.190145-1-surenb@google.com>
Subject: [PATCH 0/3] use vma locks for proc/pid/{smaps|numa_maps} reads
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: liam@infradead.org, ljs@kernel.org, vbabka@kernel.org, david@redhat.com, 
	willy@infradead.org, jannh@google.com, paulmck@kernel.org, pfalcato@suse.de, 
	shuah@kernel.org, hsukrut3@gmail.com, richard.weiyang@gmail.com, 
	reddybalavignesh9979@gmail.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, surenb@google.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: bfffdb7d91igsosqnm3i8u4j9wnopwhp
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9A2804000E
X-Rspam-User: 
X-HE-Tag: 1777014176-200495
X-HE-Meta: U2FsdGVkX1/eezh/6om7KZDqhanabsxgdWl2aSMqCBvfqAAnzH3u7sBS0IXYEqMQJCPD5x3XWvKKl/GAF19MUFTqkr79AHqomXszZtSiFswyG2WQElC4E53ZBK79gsMQCDrT94Fm675+V4um4YJFcUx4gEhsfmm3vEWiaUouq+8dl3Ori/WgDJnFiFNImbfBmJQlUhSSJE9vqEF6Rwt3/wV7B13g/XP3/JJ2WBWSBIRSqaLI9T3CHW0PJiGOXZ68JZP9gGLQ/OU27ZVDECyKStiGuIO4Jrb2gGKl71B53OCvWw4Bo3tK4qz7/eh96+KQwDFerr6Jz+jkLdihRFcamvbhOKb6nikcyktxsmsrc8AY7BP5J8+pJ2g+XHJpS/6d9f73Z/klFsWXVSeiiSaEGEyQE41cvnqDb/bwnnNAuluof+KAzz5SWduswqmmbbImZoppBCoOJkXkllqR+UvrSGv/Xdsqo+vRY564Rr/9mX2Z8q4MGHeLfvySPMxHcbz3emMYsLAIP7auYgEAkrOcwwGuTUFMPvfVz1Y28HuRNHm0UgdkDIsT16xMrjafgMDOdQOJ9cgn8W88qSb+z09aI0tjpc/5cwfcYPEmM2rFVtfWxNqz5ZuKap20xTusAaiwFWA9uWkcMKYyv+oEIhxeClsMi2yChgFavYpDXQWJ8NmAURYA3tad0xHZjz1XQ/MX4hquptokkdluYbpyyG4SzTmCshbxjTo+Le2NwJnts3jrzJxaw2lasGtZW0lk0VrD5TOL7PLvTwCq4Ihw2+xOnTB8UevfRh3XtZwr4rkvbcpNwb56ljDgoWC5vr3G4cUEBJu3qtlNxhWIvYHCC5oHSFEmFnMo69Iph+yFiQPKyewrotuQn5C2smYuW8sPPJSDxXC22a0tNhU1A+WGqltTtk4j5VAYJ3PThxZnVBH2UCwMdk1+xrh8EuSHFwasKZm81kZdDoxzsNruHq+pRwM
 b6M5OPL6
 WF4JvRiMFes6k8YEFjAh44tpD9JyOq0nVvd2KTLcYjH/qdfnskDDdLR5HNtRhwai4NGb95ddSHZqZdAnc2OCvBPRsEDyHvRySoEyfqLApFCjwVuOWrmTnhrd6cvXkOTyC0lv3sf/KHg5+jP32xmRqpxA/uk4ioI6WoQs4ZBTlX6EwoAzj+9v1+UW2e8TC59uejsoNhF6SQUlZ2o6PICD/2UxN64C2KJwK+a2JyT7iyBIsFXfXcaSBWV60afSBtiwQ3EpH8mW1EvBJj9Lgul+yLeORds4n28+OmSxhcyY0IlPkorEuQ6pJjmLcRtoYe/MD5QqeKE5EtzyWLdg8QEgZ8OEuG6QWnKjurSLhNYS7fZGXX9v7qOWtv6qGF97yDxfRxHcuqmTFR0EwuewSzwS3vEBZWU0bwXrmpQ65/Nng9iTssrQYupWe3ByAwlclx5XIjpGBaCCfAXSEN9oocx0QHl+BNTCUL2R/Q0ioqjwltVSsAx5t741eo0gPrrVXUM+hkzIM07xBcjNwf6MRBCIF7UcgDSvZ3HgW/QiG4On48jsKcg4Z3Paw9lc3+q/o5RPRuVZj0Kc8RC+JUm5nhxsgdv/fPfgn3l/u1CzQsOzOJBVNbjTbEo3a6YEuroySoiVlf0VwAIERdI/sFbjRwkoiLZvlMmpEEPvyXy14lk/M+AglqfYLADWpntLUwok50iNsGnxQqnWBk2Rf2Ai/udFIuog9kYq/CshJxcZ3PDiKcico2Ahf1Y3cS8EbX58ejbL30Aaw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use per-vma locks when reading /proc/pid/smaps and /proc/pid/numa_maps
similar to /proc/pid/maps to reduce contention on central mmap_lock. One
major difference between maps and smaps/numa_maps reading is that the
latter executes page table walk which can't be done under RCU due to a
possibility of sleeping. Therefore we drop RCU read lock before this walk
while keeping the VMA locked. After the walk we retake RCU read lock,
reset VMA iterator and proceed with the next VMA.

The last two patches extend /proc/pid/maps test to cover /proc/pid/smaps
reading during concurrent address space modification.

Applies over mm-unstable.

Suren Baghdasaryan (3):
  fs/proc/task_mmu: read proc/pid/{smaps|numa_maps} under per-vma lock
  selftests/proc: ensure the test is performed at the right page
    boundary
  selftests/proc: add /proc/pid/smaps tearing tests

 fs/proc/task_mmu.c                            | 193 ++++++++++---
 tools/testing/selftests/proc/proc-maps-race.c | 254 ++++++++++++++----
 2 files changed, 354 insertions(+), 93 deletions(-)


base-commit: a22b29c0b1a2a245ef5f782d7456de3c76eb135f
-- 
2.54.0.545.g6539524ca2-goog


