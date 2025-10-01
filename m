Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4F84CCA471
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 19:27:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DF808E0011; Wed,  1 Oct 2025 15:27:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 292278E0003; Wed,  1 Oct 2025 15:27:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3B7D8E0011; Wed,  1 Oct 2025 15:26:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D4FCA8E0003
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 15:26:59 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 79069C01E4
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 19:26:59 +0000 (UTC)
X-FDA: 83950528158.04.54D9AE3
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9592940002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 19:26:57 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="h/xzDSiY";
	spf=pass (imf11.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.50 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759346817;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xkBi4jfGKtCYgzp1QyKIde+SrLm3hIwzDlMhFP9SOB4=;
	b=Hx13SQY2yu8wzji9GI4CX92JXKniI1HQREaOh7qwP8QBYRXX8l4du2Wy9lM4KbteJib3tF
	5WRrNrBwbegF1TvJfzRjgorqaCufOpm8i04oM6kcvjmm8gLWqWRDujl6LKYdKs7+gP7kn3
	YSa3+IrkAVaI6P/3JHlI2BrP/ItNlvE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="h/xzDSiY";
	spf=pass (imf11.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.50 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759346817; a=rsa-sha256;
	cv=none;
	b=1+g4zvQU1b+5UOh45HY2oW7hsd7b3ngZk43WI/EtYMiyZ4ZtEtV9+kAZ1AxvmSA5uT16ac
	7Zpn8GHBlKhfN0Gh4E4bGeMG3tl83Wl9/I2pUnmvrPpNPV6QyorHrkzjmxVKUAtbnXgIcb
	lzJPYUcvLrXAJc39UI9b4wcFxCf7ZPs=
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-57992ba129eso301083e87.3
        for <linux-mm@kvack.org>; Wed, 01 Oct 2025 12:26:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759346816; x=1759951616; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xkBi4jfGKtCYgzp1QyKIde+SrLm3hIwzDlMhFP9SOB4=;
        b=h/xzDSiY4hlH4LKUqKmxHcrxpVbROofMd2Wijb26k5yZmqv/GJ3adCbirvx/Foi67t
         hxhTUQ/rpxih7xNh6lesP9NMec0PVOTkgHhpdr22yu9H+parcrSEKv68VuV6B/e9nlml
         GkjYZQ3/dIk7R1ckahRgofGkAA0Oqut+6x/OId+dBLXWwXhYVlnMt1D4HJmaDhMzR2zf
         GrI/NXvPn2QpIOw6nfup/bD1Qj7l3J4bXFlHVIE23Ha/96bRH6ASzfXwSIQz/QOdB44A
         VCZpqkXHAXTSSfK1yGfx+7XjtCnV1cpDJ4gplyafWjzr7bIlvbUMrwgEgD1a9kUjwqfX
         4ngA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759346816; x=1759951616;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xkBi4jfGKtCYgzp1QyKIde+SrLm3hIwzDlMhFP9SOB4=;
        b=GUtwikNfVxh2wk66Vt+5IXktspVfYkn74KyprJish9bv/zZUlPxqwaoxDSWTW2uUso
         0olum7BPLkRCbodDzeLl1SOvm5n2zZBRr+SO+a7w9gLwZFQMn7rtt0wDwAt2f9+ecas2
         Z9kVJN4CW1q+5lm7++QhN3cPnxahcwsUNX8BQdfMIM82PVlaiaJrtSjsadaC/OhOkzdk
         31AYwFiUvTNZSbu1MFeNA8NwcK0mkiXfZQh6iMoPn2AL9ireYnC36tljYpEH95oMEDc8
         Ccn/u0qmgQ8B+DnsfZ2KjBcpVGt5ydbjLMZiw3aOjVtvB68dDVBEkOt+1Fw1QhKqgMRx
         HZpg==
X-Gm-Message-State: AOJu0YzNpb6uykpVYRmUsTI9QkCa2dCxDK2xOok+bI803msV0Gkc1oDE
	FrCpBq+9W4/yYPclC2ed+fY4YEe9D++eoVvbduAfvxTdX/kA+AL3hzNtjhfM3fF71pM=
X-Gm-Gg: ASbGnct7Ahp+Bm0y7ranve42nwmB40vGYjTS9+CmAsK2sPKtJYUiz3x8zPulbw0hXGR
	VscGZXTlofDDsIQ8hTCcuoiLkLOGKbcR3b+4lpXvZAaHd9Bl1Rul/e50wua/MBmzohDhVdkspXD
	B0kbeMibwHW4dJZp+rnImYU1k9BB4c7WqJ7q0wbGVCiwSV9/G/pQmvqdcMtWa22Jd62cbZDZaeT
	dypQSytzGmP2nIEUEPSiJSdlZUq4nuxQP5Wn+lTx3HO0Bhe1k+SIXr/zevJD3eu7rbyD91T/evT
	liyRuaZyiG5uNuiAaxTsKF3Bznmu29FB2HJz3ceqPAXr7OiZtd4ZmU1zw+drkb/bh618fiXwNSX
	pSXlC0zd8mRnNZ5CuYmOYF1kIAipMkRdMCGCUsb2G
X-Google-Smtp-Source: AGHT+IEkQiFaaGHGhvMaMWZ16i+DpN9GfXJ09NHbrvk7y7MEplCQ54CMiAjG/D4d/KqWTkIk76Mo9A==
X-Received: by 2002:a05:6512:308b:b0:585:b05f:9459 with SMTP id 2adb3069b0e04-58af9f38cccmr1321362e87.27.1759346815828;
        Wed, 01 Oct 2025 12:26:55 -0700 (PDT)
Received: from localhost.localdomain ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-58b0112414fsm136627e87.28.2025.10.01.12.26.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Oct 2025 12:26:55 -0700 (PDT)
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
To: linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@kernel.org>,
	Baoquan He <bhe@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Michal Hocko <mhocko@suse.com>
Subject: [PATCH v3 08/10] mm: Skip might_alloc() warnings when PF_MEMALLOC is set
Date: Wed,  1 Oct 2025 21:26:44 +0200
Message-ID: <20251001192647.195204-9-urezki@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251001192647.195204-1-urezki@gmail.com>
References: <20251001192647.195204-1-urezki@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 9592940002
X-Stat-Signature: cqn7ktpeyqrxawmca9to4up1eobsscgb
X-HE-Tag: 1759346817-123167
X-HE-Meta: U2FsdGVkX18t/RSRt4mGw0i0cBwFQmhH73ZGIcAK/0jYGtDAeUl/F96yjAk+5caXrf2GVnAKRO9b1Zd/jh2SdoaeXdspc84dHsGvVThK93LEGkxX1skUpeQso7qH6NM+4FGGRujYVKuF+U6l9OOtqndu+S9UKGldpVLD6SNp1bYA+t78DVQOW/FHQzRJNrb4jKy18jJOfgi4bdQUXW5AdzKFLl7K6fPqslcMhF4ndmh4wU45OAKle0SpbQuFleLVKKWoKnPEoODNmdbXm5v26agzQpRtbB+ZV8d2UeQ4QOzcxRMqIMlFQiiPbQFbvENHvwDIV60O9Y/oVdSUQLbKjyCvYsb8Uc77r77ByGDkqCjMuXn6xnWzsae7YP9VAgVJEWGK6qvbpOjir3x85uJ95lpRspjh2RCYyMVlVyDwpYTI0FLZUJwplMMR35y3dWYsVin27IsYmBq5JqIU+gmE3YrvcJ/cLWDcXVP105jLeIAnSg3KqS4VvnQ9lEWvFvbhxxUPY/QPJPRbAiBHaIFNVJvwdQs10mMzjg4T0mKyr6bcKNh09siu698v85VeJtw9Y4ZAbBFTGeiKnb7siyGmsWrFc5wmGZflW7tF5u8V6VlB4PA4IRyhkBRixZb/7elqlXH14GAepRSCCyMMc+HF7xwBvlD5HJCit7PpzjoQWil6jSM6R5+Y4llVs+L55RptsOz3UHkIFaeocaHGhR1D7A7S2IfRnE6E1RVzf+iMz8BnXQynozYrre7oTSP4KbdKVoE18zWekHN2vjVFJUC7jJFkc/Ookcd0nsBTNjLQa+vIpl5wYoDLuUgkFCijbV0dFVgLHdAQ+1y800Bl/DbdqY2rA5Q/gIELXyaDHS6TbrBTtXikhx+I+/garCcSbBmDSz5JUSqlQAvvSwTWIInopW1qyPc5KbpPNqfa9UcM5gGuzQ+4JKNTUIRmKmMEfBlhb920NDjGuapVLYjjcVa
 xce46lJy
 aVWZYmzRHOrpmpoOacZ396msb/6/pCG0K03Q78P5NlfD/EH1zkIK+wTpCkqEb4Va/TTrJhljKj04pXb0ENhwtQLZeno3wq7mPsozRAO5biZrZ6CXHqJvOXRms5NrBgfPxDbwh4aiWwvKIl+uHx7L6W1eXXw/KruRSKlaeT/xwNC5jShUHT4PdJ2ZEGntGzpuLGEXpVCXK7LrHZjgFllkaPGi4PTUVOJhQn1D7j4aV0XeZVCgSc1+V/E5/FwTzQOlLibDXsAsKqXHs9UVXxqFjRtNsELeJ5tO1kLf4ACoqXW7gM4fwwoK8bDZyHMfDABK8kaJFUBaQEJ5OYTaOtGObdxfJkwUx961jy+7/Yjy6ds7cnfR/Z12sD4N/drnf6cWNrSjfO2rviPQ0PUP+xv3ruEjNMxUkTVgYIYBEZMCiFzqnSmQSe+WjAs2fkzg4qB6HhQy4SsqeNKN2ksnBZJ8wCpJd8lrlH1Ke1ON7M9dUgJd0wU+BBIsR/1mDu+fwE8ij3SdcXM5D9EmEfvUxJukm4Ce0Pxlp84We0uBVV09dK1qSv99ciRyY+Xw6fQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

might_alloc() catches invalid blocking allocations in contexts
where sleeping is not allowed.

However when PF_MEMALLOC is set, the page allocator already skips
reclaim and other blocking paths. In such cases, a blocking gfp_mask
does not actually lead to blocking, so triggering might_alloc() splats
is misleading.

Adjust might_alloc() to skip warnings when the current task has
PF_MEMALLOC set, matching the allocator's actual blocking behaviour.

Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
---
 include/linux/sched/mm.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/sched/mm.h b/include/linux/sched/mm.h
index 0232d983b715..a74582aed747 100644
--- a/include/linux/sched/mm.h
+++ b/include/linux/sched/mm.h
@@ -318,6 +318,9 @@ static inline void might_alloc(gfp_t gfp_mask)
 	fs_reclaim_acquire(gfp_mask);
 	fs_reclaim_release(gfp_mask);
 
+	if (current->flags & PF_MEMALLOC)
+		return;
+
 	might_sleep_if(gfpflags_allow_blocking(gfp_mask));
 }
 
-- 
2.47.3


