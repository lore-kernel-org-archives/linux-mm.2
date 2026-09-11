Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 680C8C88E4A
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 00:03:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81C586B0092; Thu, 10 Sep 2026 20:03:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F4746B0098; Thu, 10 Sep 2026 20:03:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7334C6B009B; Thu, 10 Sep 2026 20:03:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 373E76B0092
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 20:03:05 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AFC71A54A1
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 00:03:04 +0000 (UTC)
X-FDA: 85199531088.03.4BD5231
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by imf30.hostedemail.com (Postfix) with ESMTP id CE6278000D
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 00:03:02 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=jtP7jQQC;
	spf=pass (imf30.hostedemail.com: domain of 3NUWjagoKCKgRbPWcOPbWVOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--jthoughton.bounces.google.com designates 209.85.216.72 as permitted sender) smtp.mailfrom=3NUWjagoKCKgRbPWcOPbWVOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--jthoughton.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789084982;
	b=dVz379RJ3nMPg/O19Ac76TGHiG54iHBQNMULQwugmv8rRRCfAE4VFSEy1+mlzWSQ7WiCDl
	kk/m3l7urMKWGcJji90T2I+aqVohQ+gmyeLxMgJFwlF5TiuzvJILtO0iWq5NcJNm07SL9r
	MPtru0jri4aegZmorVE/f/YRhOvLQz4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=jtP7jQQC;
	spf=pass (imf30.hostedemail.com: domain of 3NUWjagoKCKgRbPWcOPbWVOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--jthoughton.bounces.google.com designates 209.85.216.72 as permitted sender) smtp.mailfrom=3NUWjagoKCKgRbPWcOPbWVOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--jthoughton.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789084982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EITLWeZ7GjuPVw5EYfwz4r2cJ4cxz73RuGSjmckRlVk=;
	b=iJIj6k9csrC1MkOXg+zWCIbjvb8gGZzwmhidzcutFeCvp1Nv+Ixe4azCXeYveUfZH58ria
	VV2Kvy49v5ioiQJZsjah4szJxVPCAhCvtJjJ/BsHOwDY2Ay1SbHJYgMdQOH/EfPVlsfiTu
	AMqOs9htiTAkizDSnIf3CsnkiW9pTKo=
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-396b9ef3070so511575a91.3
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 17:03:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789084981; x=1789689781; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=EITLWeZ7GjuPVw5EYfwz4r2cJ4cxz73RuGSjmckRlVk=;
        b=jtP7jQQC2wKJcK9UQZN+q+vzOTg9l5OvRHH9eSZlNcabjdCc0BmyX1GlKBi34pb4yB
         ycNwKUmLbkVZ50gsTyvQiKjyu9aU3B2aPvHGJoRPDn4d73cgeKYAa+sAoVjgKqNwY4yO
         SwNTCKFZ0+seAzATEY2u5LcvTmczQ5BuptmdMrQr1gX4xIEmNdODJl4yV+asyJDDtfSx
         ZfqBTZQ/0p3zyq6jbbJB2bf+Rcd6Y2AP6jC1jp9MMMRvwQ/nbwWrCBcd+ZoOu5l+GGfq
         b6oY6v0eiDMUQMY2itsFM8/vuVVxGrZrfntI0x1jTshZdIh/VCzphZfSbeB+ZU6ZbbAv
         xCgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789084981; x=1789689781;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EITLWeZ7GjuPVw5EYfwz4r2cJ4cxz73RuGSjmckRlVk=;
        b=jaMpNeEh/guhXTF6fweH5hskrODzU1Zl4UaNlQUlKQ0Uufm34CCYwkezTtJIKLqCgl
         jbhuKtPddksGnk/fvIvkxBRhNHuDd/HfYZ/uHnMTXHYikVGFKnz6cB5g0eJokjjza2uR
         Dj7rKIiNbQ5sNHZJY5LsTotpzNzmaV8buM+G9og8bSY4GRGXfM6365dD35f8KODlJ93e
         xgt9Tj52a+oq/hlk+drca8zv8VFPShiLSApssfg9GiWO6aBXkVGQmXtwsGCsHfu7XB0u
         Axjh7uh+8iMX6emzAtvEFBrOZb3tL0KnDQWzkE5rvNZjYAr70zcw79hZy9PvepZcE6OM
         E1oQ==
X-Forwarded-Encrypted: i=1; AKwUvBzFFQRHAhu/1hLx4D70+B1rMhBfmh+2yp+yy1x4dDDfqGOG1bYY/6u3g5exnKwUcqGWh/eQtnVgQw==@kvack.org
X-Gm-Message-State: AFuF++nKUZn5t10YY5o8dteCm3FkPSHSoc4cj1+ZQVAlx3eD7ntlBTRy
	ORXNgokhgkkkmt0s9a3oRZ6D/txnNaw7zMQwTHEX+rd4aJpy6ClkCPmojLERpWcsR6MsOvcsbGb
	w2E3eM3K3DNBnr8X0U4rmKg==
X-Received: from pjot10.prod.google.com ([2002:a17:90a:950a:b0:39d:9b47:4551])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90a:ec8c:b0:396:635a:9b10 with SMTP id 98e67ed59e1d1-39d9bf0af3fmr2298476a91.11.1789084981361;
 Thu, 10 Sep 2026 17:03:01 -0700 (PDT)
Date: Fri, 11 Sep 2026 00:02:58 +0000
In-Reply-To: <20260910162411.d3bd211927c10e049c6652b8@linux-foundation.org>
Mime-Version: 1.0
References: <20260910162411.d3bd211927c10e049c6652b8@linux-foundation.org>
X-Mailer: git-send-email 2.55.0.1007.g17ff1f9808-goog
Message-ID: <20260911000300.1052582-1-jthoughton@google.com>
Subject: Re: [PATCH v3 1/2] mm/khugepaged: Never install PMDs in
 uffd-minor-registered VMAs
From: James Houghton <jthoughton@google.com>
To: akpm@linux-foundation.org
Cc: baohua@kernel.org, baolin.wang@linux.alibaba.com, david@kernel.org, 
	dev.jain@arm.com, hughd@google.com, jthoughton@google.com, kas@kernel.org, 
	lance.yang@linux.dev, liam@infradead.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, ljs@kernel.org, nico.pache@linux.dev, 
	ryan.roberts@arm.com, shy828301@gmail.com, usama.arif@linux.dev, 
	ziy@nvidia.com, zokeefe@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CE6278000D
X-Stat-Signature: hfmcwzmhawihn5aah9gy3s7eybxc69nj
X-Rspam-User: 
X-HE-Tag: 1789084982-873793
X-HE-Meta: U2FsdGVkX18SQqh1eBjWvEd/WE5aiy/b2uhkNdg8k1l6vcq6+aIzdEG8+VgavNG6uEwoKy4ZxAvGix/bXEHISyw1m2RsD5nGSvFFTkOxmJfXeraXgHKBxCqwqcxymYE5yvUwAY7JQSawuziJpOAmvREzl9PF39agp0+93/ccUxoJzoKt5wHd0oMo46wXzODL3X5B12ULFx0u1c5/gzxhHxvJiD9dEXszycDzn2fJwpch1DnIw2+Si4x0dnP3oF23T3Mgi+m4nItHwuxmrdFY6SQPxzYSXVQp6m9hhJakxh3qt8QbiMG5mZ9EPcAQUPIUWl7RNxKtGKwuzqe9hMinmjKe8vQ7hBpRRgLZCqTkPTTGHGrMTRO3fTzGpXsdAvUU9UIXBKWrI5UgIF90oHpXPmuUOu4fs35csjyoZ9Rp4IB2qinx5IgrKuLI8D/y/JmbwLJGmqd9R80ztSqPdRCfW5jKSJIMnKtLgbHKRxe0jLtg/lj6GebTs+dLcWrr5CFdUSFu1jorMkSIi4Lfeftqmr3eK9iv6JZNevGAlLghnjonfXa7uOEwuKp8dYZEpLmEyMpsXmx44m+UJOiU9Cj2vm7bpTVHbvyDvSu0i+gg5qq7kx4+x4mE3VU+TwrEKaAtb4o+D1gAaxa4n9luEOWAWAz2YMiqyx9I9fjfYeufKw+BwmSeKhTyT2W1Zh5u/ZN17lq845f2RG+c25C+2H8CjYUqU0tY3UNA1hDVk9ZWF08MVh8ht3PmGngnpwmKAK0SB5X5tUPhiLZLUPjnwNjNgLBCA4FH1qTjyjf+L0koewKpa/hJe3bRypnmgYDx8y83iL0AXdSq6ZOlAjqMYYhj0vbSxoSKjAu2eiMS4US3hT4c59oUXUH2JLBSfE5XFv7VKHgJjvBzeCL5Bi2erLUZmtrsdoxVSLXUFBHuhp1JNn0lyamiXTw/YONLIqKy0yUOuwdTYBqanbxz8Vhn6kS
 onv/hbRx
 slCedp6nMwd6M1S6/vCOQVtat1pmFMHlhnDF+HdjQmgGD8x0rbg4i0WEGHn7GIH3ISqrKjtaiJJTMBBtDPF5G+aKt6wf8ZJSaWMWCg+QL9zmy2Se0UjtUy7+lIrg/EJ+BiJP7Ji+rLWG4DvmXE2Vl01XYgcstFJ8bHt9TdIbD0DUj3eoCDYxupT187yD5S8QsDI1t4iHoe6hVl6FlOYW9nhEOpu7pxX/EC+jUalsnszYiYAx4zH5G52RwL5U0ZPlsnlQ6tjYa0WeC+7oH+7CL1ZXc+RxOizGwimi9gh5SgN4hi8pvZ4xOlZ5TTSgtqkwi6Hm2oxJG4hykrFKvfks6qfNcDorWn+oI1jPvdrfckMfG+8ox39tM5oRoQ5v5XmsSTbHeFJGvKuIgQlN2SrJb77OVB7O2e1ZbPvW67jc5IIzv/S8DrevgKM0ibo9sixiGqLzW7Pb+KmCW6P4fVNCzGxJ2uuikHiVChSww7lKDjrisI2+Ozlg3i3XXvaOyJMT9rlkv6n1kIRxUTuc8grt6hd+Wplud6VfPTukGvJwqSkcAmFzkFSCdhH55dUbvfUAb6J7elChVzmT7q2xbWivR7fbnABcWGVZjPxn8A/2cZvyy8R/CeWDQLal3uBgINIJCZWa8foRpdA7BpguhMdhtk1kYBt/8ZGuIGluCxgMUEm4doYQY8U/BmS96lcAArM1kjWuOnMI+5xhNENGQkyhvinZ0Krj4J+VVe43r
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 10, 2026 at 4:24=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
> Sashiko had a stupid niggle about the selftest change and made quite
> disturbing claims about the existing try_collapse_pte_mapped_thp() code:
>
>         https://sashiko.dev/#/patchset/20260910023411.514987-1-jthoughton=
@google.com

Thanks, it looks like the note it wrote about the selftest is genuine; it i=
s
okay for MADV_COLLAPSE to fail. So I shouldn't have changed uffd_test_skip(=
) to
uffd_test_fail().

Andrew, if you can, please add this diff as part of the patch to queue. (It=
's
a partial revert.) Or I could send the a new version of the patch as a repl=
y
to patch #2 email. Or a whole v4, whatever's easiest.

diff --git a/tools/testing/selftests/mm/uffd-unit-tests.c b/tools/testing/s=
elftests/mm/uffd-unit-tests.c
index 6f2360f9b75d..d8e40b770d88 100644
--- a/tools/testing/selftests/mm/uffd-unit-tests.c
+++ b/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -639,7 +639,8 @@ static void uffd_minor_test_common(uffd_global_test_opt=
s_t *gopts, bool test_col
 		/* MADV_COLLAPSE should succeed with userfaultfd unregistered. */
 		if (madvise(gopts->area_dst_alias, gopts->nr_pages * gopts->page_size,
 			    MADV_COLLAPSE)) {
-			uffd_test_fail("MADV_COLLAPSE failed");
+			/* It's fine to fail for this one... */
+			uffd_test_skip("MADV_COLLAPSE failed");
 			return;
 		}
=20

With respect to the note about try_collapse_pte_mapped_thp() breaking POSIX
SIGBUS semantics, it definitely seems plausible. I'll look into it.

> I'll queue the series for test-n-review.

Thanks!

