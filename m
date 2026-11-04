Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 728F2606D803
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 18:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=gBsDJEVd
Received: by kanga.kvack.org (Postfix)
	id B1C7C6B05B4; Wed,  4 Nov 2026 13:38:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACDAE6B05B6; Wed,  4 Nov 2026 13:38:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 920136B05B7; Wed,  4 Nov 2026 13:38:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5CD576B05B4
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:38:05 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E8720A080F
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 18:38:04 +0000 (UTC)
X-FDA: 85398296088.20.9EB70AE
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf25.hostedemail.com (Postfix) with ESMTP id 1F725A0006
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 18:38:02 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=gBsDJEVd;
	spf=pass (imf25.hostedemail.com: domain of 2dgodoy01227@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=2dgodoy01227@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793817483;
	b=qGFEK/saDJMFCe0cZxBKhFyPTQ0p8yd6Bp4cEhzIvjodyIkoef7+x4FiEnetUoMCjErmKw
	r2qvVbVJ5o1kl3DuH8HBQ71wCNM1omg7rsZiY23OyGVmMardcX2XlF1gdfAmGdyE5H/rrU
	BQOswwC7AcZ8UorSc/+NdQMKulpRsKA=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=gBsDJEVd;
	spf=pass (imf25.hostedemail.com: domain of 2dgodoy01227@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=2dgodoy01227@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793817483;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Q1wmxsLQSePodY82bbHdJMUI05Q4Tw1S2f4IXJ0gTlo=;
	b=KSv7TLwlrRnLRigmttizTBfqV2SjT7KwW+yTqKCdhByjzWwa+xDe0ft2C2uU/ai0RNYByY
	4D4PGDCSQOjv5SwCiPucT6nCSACgt8Jow0owCerXAR5IFcegvBiBk+giCXIvxnjM9wHYcn
	DwA6RXCbshcq3Dc64ljc/TUqrUrt2Z8=
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-89f85edd210so522322b3a.2
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 10:38:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793817482; cv=none;
        d=google.com; s=arc-20260327;
        b=VMB5h3Dq9Bd5oKd3JxzHWP/YwxzXZt2vFs014sGu06UJHEY2uG5hAADqNwmJAq3RUW
         q3WmnQ9qqR1fgnRgu5SVPEa2RSZN4hKc9XnLj5eLDU/MVZk47XaoOYGLFLeM67KmwMlk
         9Y5zaHOeUCv1wBgN2469F3km8PGCi18LURzhObVTOgeRcIo63iA4Z9agw7LyKa08Ju8v
         E+b1gHw+Q/kzcuzai9hrv9Xl/gwDRho0J5EXAm/C3iYLneRyuo6E0O81reaGSTtKQHXL
         /urP/OWUNjmHbUa0wbAKnR+t5l+5jPZh8DdOfpi4VM9xZV3V68LG8y7DA+Wkk72lyKFE
         hEvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:from:dkim-signature;
        bh=Q1wmxsLQSePodY82bbHdJMUI05Q4Tw1S2f4IXJ0gTlo=;
        fh=YxaQX7GTjfBsN7A2Jl+A9yP6mmGOQanoqU6QROKhVaA=;
        b=PYmXgljBDj7ZAJXuPGq1m92nGBvIT3+4nPq/6Gze9HnWxybNsi0WQWGpMHZV7+p52B
         jgSw2POHT9AdjCHUg9RI4mQZPzmC07GrCVyRUs8gBCxVkDJeYWzBHizSvi633m3B1zxI
         Pf6XbkdrBQrRjgGs9DS9U0MSS2uzS+uwjfPKIKm2sWJUADeGxYxeB8tjHbJBHc+f0xZE
         Qpc4FEv2AOFvfhJNq3yg0YIEfwgQdpQ5cmF04F8ghrtTZPjw0LBVEN7njjKdVfaxvU89
         xeEsk8w9WSNa/WRBE396F9w1OqLJQnwj3iKpbflAGe5QBJQTugjwPIaTA8z449Ct5KGY
         TyVw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793817482; x=1794422282; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:from:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Q1wmxsLQSePodY82bbHdJMUI05Q4Tw1S2f4IXJ0gTlo=;
        b=gBsDJEVdNoviQMGLOcfgSnZTl7EBgRl6IavfdkIRuQkd7GeCihEHLA8/X6ZROKECU3
         NfA01cG8sgn5YmetN7QSE3hfjfihhHOevLqNfW7AVkTvObFZ4QOssWiKl33cb1A4lbqE
         W9H8XfWjUHmwmShq706JkmViZDJ2W+lttr90BgSPcwsGl/gUBDGfE5ik2ACGx+8hDxVx
         66Dmk+O+1oTIK+VCaYT0c92naiJi1yfrH8uN+Wyt6OuMZ2BTbjfJxMyQWDNDqd8Hsj2p
         KiAQOj4tyiDO32cW9/qXAz/d41vW+ewF7rQob9jkfb1XJRwZUCmR2QqefRqO9Do2gLhU
         U/LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793817482; x=1794422282;
        h=content-type:cc:to:subject:message-id:date:mime-version:from
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Q1wmxsLQSePodY82bbHdJMUI05Q4Tw1S2f4IXJ0gTlo=;
        b=UwzUlE4wb5EhoHTtJSzcjMckrYT84bgdhXk5JhuvHYJfu8JojXJEByKjH22W4F9S+0
         /LE+ZHwB86t1TIPuYbfHx8vkS8Wa2wmVDfLt75tohGKp4+oGkwEq8oCvaiIw0je6CV4t
         EThj0T7NAoRjNs667BHvMLI/G2ef3arapp3DwGCgZALl2Yg7Lv0GJi81A0KpQLtY9Chf
         fInqHYOUeKUUYPxvaXvN253l7NdEALoIO9ekcDaGAeSooy+UQGojKYwp0/Z9wx1q0X7A
         ufWqXd1VkfvbMagxmm/nDZR99OoyNMSrKReARO4n1GHIbbFZDq4dAAcyijzWZJ/yMX6b
         Xf7Q==
X-Gm-Message-State: APuU4Z/xteMoQEWv4sTEui2A9fAM71emzxN1F9fLTlx3GnjBVIFxjvuS
	GkyLX4tHt41mQbSevXQh4UhZtg2eR8ShBgOGCdYGfIauYPAH9jVR2MSaG6kOULWw1Hc9MPJ46Q9
	XR8ETAhuZyp/VnNy+64A67aDiEdbmplnyho2n
X-Gm-Gg: AYBFou1Z50HX5CSDm4Uk1RqIH6GN5/HeWn4KjWVdaASk9/fsncHGG3N1INuMJS/fuI5
	cXbbv4shMBrC0GLOsPPMHqrhsexb16JHINteelJsPu8o5tPJbg8jJ5b5px+qeF3OXge+AsRTZP8
	A+1nDf6PodaJmnWnD1KzU8dR34iRKySDU/4feae0W8kZbNMoFcN0v79+x6d8LR1Pr3cb2Yufn4G
	+c66UEcHARECMnSEANE2zZ7J5hpWg5UYIPTLaUp04pFLDFlxKwizB8jeS6Q/utHkHy9xHGaa5xp
	au59By1BF0d+5I9c1WdCC/hOrb5tkWgW21BwBA/D5U0xlVtcA4l78xVFOIadypOVXQfZ3S/E7+u
	A5da862sgtEuAEd+j+Llvb9axoKS9URw1uUI0SxXJXIag3Iq/cmIE0b1UCKylS6wcXSS6
X-Received: by 2002:a05:6a21:7807:b0:3e2:b243:5b9a with SMTP id
 adf61e73a8af0-3e928aac507mr11185730637.3.1793817482005; Wed, 04 Nov 2026
 10:38:02 -0800 (PST)
Received: from 511566560828 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 4 Nov 2026 18:38:00 +0000
Received: from 511566560828 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 4 Nov 2026 18:38:00 +0000
From: 2-D Godoy <2dgodoy01227@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Date: Wed, 4 Nov 2026 18:38:00 +0000
X-Gm-Features: AclHuK_xsWZrwV1QnJwJkdmZ_xJFomNPCSOpg18Qt1PwOwVMPI3VcgIGPeu4N3c
Message-ID: <CAL1HEBAGgM3uu8V1DGDFB5RcFikgqhJtvv3BwLRbAZuQoY9Q8w@mail.gmail.com>
Subject: [PATCH 0/3] tools/mm: fix three out-of-bounds accesses in page_owner_sort
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1F725A0006
X-Stat-Signature: 37om5s845qp7pg3k3zb6fazf39g5fqec
X-Rspam-User: 
X-HE-Tag: 1793817482-522646
X-HE-Meta: U2FsdGVkX1+83mWFtPTzaLFC9Cb+REUWKMhF3Srq/f9LtmagEjUQzNUI5zQv1fXSJdeAz2QUUXEDR4k2LJ0xrdNzJZtU9p8TVqOtvDYgYCbx5n0wegFYKutZ9XAKrL7iT/BXqkvezGiASRoK18jfYvoNdhDFHoOV7Jhy6eKheQaWRoWkjP081Rgvz6CqdLy6U9lSPqTvXJ6oy4GN0WXXpSlp46gvPvrDiUmMLZpAUcWgNJAMT7Wk5W5LbKzS8bsDew52tdxU+i3FcwdOZvh/YC53fIL+WTCNOQiJ5LiOCRf3xZ2X/hosMkFSmpcTdTGz/2EUIRp08Vnee6rddNA5ebIRMPpBMrL3XaPZu9d1H636w7SpUVrVc/cLXDizLZ+TLCN7n4O4Q1np2yQWzAeeyZu95log/Y26zEO6vTdS66dlI85MAQLVDgBlOQnSRW89gfZwzygA4bLPGUrkd0NubAT6nOibWQ50q/VXO3DOBO9mc3K+7xRSi8QaVC8unwrvTfhkcCHm9bhAzAFVp3DyxtoOYSIEdopqvpXVjkrp3uz1wxIvBPkmPC+UdHSrp0Bnsjm6zUs9vW7S7ZcKN+sngBSzuzk1B2ucNfNNTZemE9PxIjcdsqHarUEQAkAAwceBehSQDo+cAXTARE5Qkiv5W8ltVKri1SNevU6KU6fojXT03yHjVjiFFcqyJkM9JU0UmjoX962+IVvjfROQvl0DehaVJiXNJEjx+MRUOyjGjsRoMM49sX5hNs0ngF4Qjr8twZLW0plYU9J7jcWws2ecMhUElpLgdS9b8fcz42H3nHxYDKBZTnAEWejVibF2SvgBI/gow5igmQMM3/PNSswsc9ZUN0m/dnJu4ijGKH7LmYv3f0YEgBpHMUFdXF7VipcSHu4Yu78xrrtnn+o9HEHeuXl2qKs1PyVq+eTL2ypOB7dp2b9fNEnHCEJvYBatoF+XVCNzsxRsmi20V4h3XjU
 gfzEOkMh
 OiFV4ht48zTVnbz3912YGRVkK5G05xX/2/cW/HUZWKp8xechUAtvQ7u0Am0hwppZr+fFU4G3khVtw/l2qDXIupT/bHus6uJhkiO+CihD1E44io3fbIidTmZYCxZxCpWwJH7RcQfx3SKmHgclzU3SWSyMyMZ/OAkW/FoEpcQU4sATGD/URbiIwHYLl+BXnJ3W+SuAs0JwTxMryIgyACLPFs17sLnPaQA1VVHkbqVRarcWNC5anfOhDgh53T5TC1i6iZzLtvM2qhqlPEJf+fzNatuiEJttxo/0w4x/ZHi1oF7FM58VnRsDoqHXGkJfBQVGlJgNBVIV6jgRzXzOo6LlBPAsQGZHyTD+C8ei0ZFgLeF8xxxQEuGS6teEpWSY4rhiGy8n16Hxsuajv9nQ1h5rQuyxpsizFItwWX8/uOTJkWHV97lLqaS9pe1wYClapjkNBSa4QHHqLeXuv5Shabal5aOmYrHRXrL6Jmw36nKb3QZedwSg13QIvzBnc91lKYX3vs4Hhe9GJYV2T0nPWoV79ah5hCA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

page_owner_sort walks the records it copies out of a page_owner dump and, in
three places, reads outside of the buffers it allocated: the copy of the
record is handed to regexec() before it is terminated, the removal of the
timestamp moves overlapping memory with memcpy(), and the allocator
classification walks back before the beginning of the record.

All three are reachable by sorting a regular dump and are reported by
AddressSanitizer.  The tool is a user-space helper, so what is at stake is
the dump file being read and the memory of whoever runs the tool, not the
kernel.

The series fixes one bug per patch.  The behaviour of the tool does not
change: the allocator classification of a dump carrying a
__vmalloc_node_range frame is byte-identical before and after, and the
three patches pass checkpatch.pl --strict with 0 errors, 0 warnings and 0
checks.

Henrique Godoy (3):
  tools/mm: terminate the record buffer before matching the timestamp
  tools/mm: use memmove() to drop the timestamp from a record
  tools/mm: keep the allocator scan inside the record

 tools/mm/page_owner_sort.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

-- 
2.39.5

