Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80ABAC98321
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 04:29:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 522946B0092; Fri, 25 Sep 2026 00:29:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F9F16B0093; Fri, 25 Sep 2026 00:29:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4380A6B0095; Fri, 25 Sep 2026 00:29:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 14A836B0092
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 00:29:21 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 78D3D1A051F
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 04:29:20 +0000 (UTC)
X-FDA: 85251005280.20.505ACC6
Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	by imf08.hostedemail.com (Postfix) with ESMTP id ADECB16000E
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 04:29:18 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Iro7wVhf;
	spf=pass (imf08.hostedemail.com: domain of donggeunyoo.kernel@gmail.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=donggeunyoo.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790310558;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IMzp+2P8aZfHlr8qYMa3jORBlQwD/QB/O+yiPFw4Ks4=;
	b=A/0QrWRnDn6WUcnwtpjd7ESfzNaSN+exFwno+d1zbKLkS1HNQd650vJnIE8fYEy/fFEMU6
	SKNkax3mzOGi3jiWR7L1R0fgrwmswyQjqITUJJ23BPnuPLdE/MhoxIuapClZlFGVCDiqiS
	G7QhIaVz9nL/ZQJnPjYDAtBWQdLjnlo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790310558;
	b=1Pytw1G6Bdhe43QQ6OnzjCWVBV0fWGMXmm82EjrQ0y7RpBQt9ybSVwgqeMhMa8Ytwaz0vE
	rGoGBVIE7V7T5mQgACYpbfg4lRMrTHQLPB/UpsDs5bsc8LbMX//XXv/C9BUG7T4PDkB3/w
	Tzh5vOH+ZnH2xRs2XwIK4EdaApihpYg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Iro7wVhf;
	spf=pass (imf08.hostedemail.com: domain of donggeunyoo.kernel@gmail.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=donggeunyoo.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj2-f12.google.com with SMTP id d9443c01a7336-2d747f01363so2524085ad.2
        for <linux-mm@kvack.org>; Thu, 24 Sep 2026 21:29:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790310557; x=1790915357; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IMzp+2P8aZfHlr8qYMa3jORBlQwD/QB/O+yiPFw4Ks4=;
        b=Iro7wVhfHU5koZ7FfyqNFbKhhpnRjnN66ZL11xpp9UsRycv+MMlQDyndrXfFkJhMOk
         57sRCIy9A/mXvWamiXliIECa8vrxURTaFE/cigWdhMaA+IZpPwLEZdaiV9kyDnABEfaV
         XxH9X3BAnmywkP5tnjc89fxVLe+H4vnMsUUppvjWKTDEGvDG2zCrr+VVAPs8f/pKhvxl
         prcs40qdu0pb5Vlt4h8UZz+2FOogqeAp1XY2k6SC2iwWWNiE47+pKpvRIMAF7+aibXvL
         dYyEQVWvP47TOCvkIqaxuxP7suxTSOIYcw/MIgMmF5/tjZrrKODeda4qLyzXv1A2zspy
         1mLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790310557; x=1790915357;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=IMzp+2P8aZfHlr8qYMa3jORBlQwD/QB/O+yiPFw4Ks4=;
        b=W4zSwJxcXk4NoWhMibpoR27ag92cTkunrIxP+Zx67eW2nmp6rbttBjo/TBJ4g34HT4
         B2e72ua/JJLU/plyNibxsTQg5aox+F9B9gJrsGlMkT1fMJcAXBhXQIz5Zp9M74D4V262
         aroFdd3uzfFfEaCPTNi0vyze1WaGQtDZEHeEM8uvKhgX/Izmiq26KWBKRf06Snhxtz/F
         vxDtDr4y2WPsMS3KfLUXVFKk4mK5RdkbVKg3GrLzjoMtXFeTphuQQzfIA4Ed96S1IUbr
         /S01HmHXToKjZ8zyZ9CnvY/REsCdNulbzXvPKb8lkTPWuRFbnPEQA/q4+hZlXPwzzoH7
         Chsg==
X-Forwarded-Encrypted: i=1; AKwUvBzIuwJ3LGbHf5IwWdoDiJenEuOre9x6gkQyfwRN3zPDLC6Ja3/kNPcbZggGCk4fGachRVPVW1hNVA==@kvack.org
X-Gm-Message-State: AFuF++mcqTMfsGV8jdKvtJzNyFq3M4ThZxM/6PtAri7TuGkFi2NnEa4N
	5is0LeVDa5071juVivJcGfFVqo1MAxAGKJNqMXAt8DUUbS90p+P0U0Q=
X-Gm-Gg: AYBFou3KphylafpMcWHVLjUEH/u5G2QTZssNAt8/jNQ5yQ2tlW0tA7yt9QOveEsahE6
	f4MugvxXAn9Ca/kSMMT7G/kkTgtjbfYBkPSkLTMQ4eaPg17HAtkXzlJBRPNHdOoTROqhuiqLl6n
	ubbDaI89tQu/7pbm2h0oyQeCjkMKxV501HfoXYq6V8/oLckunjlUwaZ7PukO+MaSduTYTN6Pshp
	viNwJsT2Am20EfUoTsMagVNebTBzpJPxExrlZumtH65BJAHrg3vg2b/4xjBe/XECVdUq9Ep9lyS
	4xBNL+lev2WkmWni7mKRB8ZWnTmni0xrekNTXe5XrrfOkRgeY/+Y3vNAt+bDv1T8+ajChY5EWJG
	ZtGPnR5nnRdtHwHzoRnvL/Rrn8qSCtjaSmgwovsT7XC/rCvXArJXU5Yzy/PS/mjFqN1+mXzZvr2
	cLq4cD07FbBazxjW7z+lQLj9y07gmNeMXSXjpVMr+QRvsU8eZg8xCgfnVKsM9bR/qKoi7TNe942
	/A3HHiHsckU9GUOVniiPvsvsg==
X-Received: by 2002:a17:902:cf03:b0:2d9:54:fc69 with SMTP id d9443c01a7336-2df9490a51amr8031815ad.7.1790310557275;
        Thu, 24 Sep 2026 21:29:17 -0700 (PDT)
Received: from ydg-Zenbook-14-UM3406GA ([211.230.25.193])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2df9525cd53sm2499125ad.38.2026.09.24.21.29.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 21:29:16 -0700 (PDT)
From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
To: akpm@linux-foundation.org,
	rppt@kernel.org
Cc: peterx@redhat.com,
	surenb@google.com,
	aarcange@redhat.com,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	mhocko@suse.com,
	shuah@kernel.org,
	kirill@shutemov.name,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	donggeunyoo.kernel@gmail.com,
	stable@vger.kernel.org
Subject: [PATCH v2 1/2] userfaultfd: clear the inherited uffd bit in move_swap_pte()
Date: Fri, 25 Sep 2026 13:29:06 +0900
Message-ID: <20260925042907.2330519-2-donggeunyoo.kernel@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260925042907.2330519-1-donggeunyoo.kernel@gmail.com>
References: <20260925042907.2330519-1-donggeunyoo.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: rw9u6ksttse3gtkr5okjkp4rdxf6h4xz
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: ADECB16000E
X-HE-Tag: 1790310558-826027
X-HE-Meta: U2FsdGVkX1/lBQg5MbuJIsZz9YOi3zr+IbLCCWtD03sZYz1E0EkQobymG7UkuSeAYwpPrvr1daPxD8HhCqYZ71J6I1HRhTng5j0VIn6Bv5f0CZDzdJ1kcvnN2mJ/2KCwFvRttKy4iYa5xEbElLuXgx/HxF2kv0cg+Hp5BkT9DkRdyd/cc1bvp70eoIDSd1QqQPmcS084JnDvwyBYfO+T6NsRcCsiFZe2jIBhqBCGwyjjT8C0N8egzlsJeGXgDAV37Jb274IMK75AEQL82KfQGGZXcf5tBUFg1O3C9pfvulMejnBGT/MKhRqvMokeo46JyIOUuDbNkC515kmlR/rXu0TThKBdOiztVlpFNVLRqPr+3Ua8/zGNUQaK4LE2MVXxDQ/kGmRRZCByu9RzmUGjrv2lN1f84YTwhqPaUE3Vv4srZh2H892CVXSV6yqy4tUUYNXlw+YpYJ6bK2+8GX9yykPL5qMGTO8aikRmjRJ616wlpw/I52cmVOeBEEcC9sBRABb8EM7xUHixH0eTF0g4+sjTjOck3FIyQzKZ7n947qfWo+4iV8pTFh/YfTy/N1QB3O5hRROEjn0zO3Tk7CPnHzz/er0DY+vbuX29kS2XqLb64EVfudbTJI4MkC42YmNoP4/0RCiNSHWDh07/jl4B1DeW8/PqO0fty8Z/qva6O/+AQFuWOsoxjKcY6dKvnQ5IjXYR26O7MM6cGuL0uauxLbqHiXzI3Z5ZKmUSJ/LT0wDhHm93/ba7PD3ro50bAhMkOhee/ie9WeaVzVHCn7TXCfSBs2Sdz3OKlG0NuER+VG1ZEQjQCQEca+OADVDBU+kAtUM0lsUkKebBdcsDBdOBa9wDH8QNkO4GgD+fQ02nO3idCKi7sJ9Wov6TF16XAtu/6ojm86PC/IlOYB2z6fGUWx5DqEIEi1WmVrVY06QmEiuKWl2Wyk2ALhgAuDqvI3+bD//netv7rNEq/1avPIi
 KalQh2uL
 iIcX/XOyNbKvMj6hLlVFcVjcl3z34mHR6PXOkOEzilrG6wDKacq8mMhV1zyVR2kRrT1eu7W7IloDhUJy2UcK2A+DakFa8twOL+ZhPLw5Hscf8Q7mi4vlkq2VY5HRhuu8LkbRAmcaj+9v+WjafHneG96/xXTV82Ssu8q4WJIblbnEIiTlYkvcr1PlFxyAfSWIfhBDk6pcB3EY0oflg6I4k9jXEyTFcR1QH1LWqJ/oMkUgde7I+unX+iTyT+YxGnaWvldQbGwn1DPHqNHwsYeX0Z0R3cQPsEzBbH+fbULY6BXKbGvcHRKRjYvPBlb1i7k4aZDy3bJ3AtEpwzEn+WKOsSa6AqHNZ6B1byFqa1au3xDRmNZj3zetNy0XyGbKhgEPQ31VFXVCufDKA2QNhw+CQY/ybzI38GJ/YsmPuLsyJdKMUIlZDGEUCR5XVDHc15nzyLXP6C4FVmCm5u9J204NhG2QICTFES+FkpgXlCh4Rto7z1mb3Yb8d1d/EUkt5qz7Mx6ub7GxarfGcXOBGf67g35JFISeMGLWTYxtpdIrYZXBt/kpZINdmTR/cwg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

UFFDIO_MOVE on a swapped-out page installs the source PTE at the
destination unchanged, so a uffd bit set on the source lands in a
destination VMA that was never registered for write protection.  It
can't be unset there, and THP collapse can't happen either, because a
swap entry with the uffd bit set makes the scan bail.

I don't think it's intentional because for an unswapped page the bit
doesn't come along, and I don't see why being swapped out should change
that.

Clear the uffd bit on the moved swap entry unless the destination is
RWP-registered.

Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
Cc: <stable@vger.kernel.org>
Assisted-by: LLM
Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
---
 mm/userfaultfd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 74f04c323c50f..f39f109f17989 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -1449,6 +1449,7 @@ static int move_swap_pte(struct mm_struct *mm, struct vm_area_struct *dst_vma,
 	orig_src_pte = ptep_get_and_clear(mm, src_addr, src_pte);
 	if (pgtable_supports_soft_dirty())
 		orig_src_pte = pte_swp_mksoft_dirty(orig_src_pte);
+	orig_src_pte = pte_swp_clear_uffd(orig_src_pte);
 	/* Re-arm RWP on the moved swap entry if dst_vma is RWP-registered. */
 	if (userfaultfd_rwp(dst_vma))
 		orig_src_pte = pte_swp_mkuffd(orig_src_pte);
-- 
2.53.0


