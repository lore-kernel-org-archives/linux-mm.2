Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7372DCD8C8C
	for <linux-mm@archiver.kernel.org>; Sun,  7 Jun 2026 19:45:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FE936B0088; Sun,  7 Jun 2026 15:45:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B0186B008A; Sun,  7 Jun 2026 15:45:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59E4E6B008C; Sun,  7 Jun 2026 15:45:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 445BB6B0088
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 15:45:39 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id ABC6EA0819
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 19:45:38 +0000 (UTC)
X-FDA: 84854146356.21.891BF0E
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf19.hostedemail.com (Postfix) with ESMTP id BE9B61A0005
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 19:45:36 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=dziAG4PM;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of surenb@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780861536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WonlPgUFHgcUs9L2FpzERLFLGDIi9P0mv3+MIWNU1M4=;
	b=26/R51QEZOE2bnZwsjcZqs+iY0mQj3s0nywMfbQ9P10ryJ5R+ioBAal/IOST1QRh/izhyh
	d+enYD+vDLwWaDlpL3EEwf4ia7As4i89AcpVlvi4UUZQTjkNFWyB1TsT3yxo0dZu8/z2+w
	hg8lyZwIJJuK2UHS1C1MUvlAB6ru0aQ=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=dziAG4PM;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of surenb@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780861536;
	b=h6nqK8y+oX6UIpx/ZAA3N28eGL2y44k72eR3IJs0oqVh9x90N5V6VkPw5OUTFWKi/DnpuS
	/PwtVQStZA2m6eLbe6hXJNlwJRPGZvozQ+vhCyo5aoSu2lewMOnVI20v53ze9zeukpsbNI
	y8z+H1vcw3d15dz/TJgpM99/D/vTZeg=
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-51765331535so1314291cf.1
        for <linux-mm@kvack.org>; Sun, 07 Jun 2026 12:45:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780861536; cv=none;
        d=google.com; s=arc-20240605;
        b=KF5iFA62Exkj5KedCfofJcYovZjQ9MrdV4vdesI/z1hxRNA74vS3oWgf02xHjW9UL8
         wkrxDhZ7vjm+WCLj0oGk9smUSkQK8VgJVsknxnDUnhGifwkiazsK412Na4tnEoZgLsEX
         fE5027lWWu3FSvdbHqq7bfOO5iXPciCFa9s9w2uloEvtlG+Udefb3iA8/f+OSP2Hbzhs
         REQmPnkAUjJ9yhA7LEJiH9bA18T3vOtzl3D3MP3sdDgR6jLwb0S4+nlvZtjGnbGA724N
         9X1kEYtVCvwP9rs8gTr7OwkoPTFvSuvaw2LML0eAr3/5ScVqLaBTbrT9912UMJ4eMpxT
         TwHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WonlPgUFHgcUs9L2FpzERLFLGDIi9P0mv3+MIWNU1M4=;
        fh=XLP+xuIDhWRgzFvqlVdFvKxuWLpo1VlJ8cDXy9T4qvc=;
        b=BAyr0rPNzHIoU6htZESMH7r443YWjLiEO50RbNwOcCR/KJwb8wmgE5FXmWb+Lx3Cvi
         pp5n5uBnmrYc5EX7iiUFiTYWV9rW8imyZihE0fFl43+ZrxmEo6yV1rwYkVCr6EvDWMDy
         T80VfRw9a7iL08p8eeDEfI2eKW1/4kvxX7xNibZAfVhy4C3agRGoDAFe5dMsdlCADPHO
         6T+YvjCzNirgOn1K5mZkCy1SB3bmqk5F12cCOIutZHL8Crw79OAOHjm8EmPLKzihdnSK
         I5u3vFXq37/b7W+d6Yw+HP7Vwh51i63kN8jhDtaJ6+dHzthH538y/rEBm6fgezZF4pfe
         qdLQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780861536; x=1781466336; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WonlPgUFHgcUs9L2FpzERLFLGDIi9P0mv3+MIWNU1M4=;
        b=dziAG4PMRx9sYiqFVZDmNi8DyvyZHaDw3+j0K1zi1ufRQCdRt7O+X4RNXWusAqo/mC
         Oa+ZV0gnSO1Qldae0PwEOt3XXQpCUdQUybUs7SrLmGjHGwTOMYwNsiY9o0yan1ypaRCV
         5d3/5v/bzdB4R8Pa6/mjdERzWDr0NENhESIKah4B6yU+qwE8HENiOg42mBXFfIR7g3K8
         GJZaau9BQJD9t6CL34CJGGtduQk9Rp5jUKTpSnQZFGJMm68Ey5ue1lOjkb0w0yY018jb
         JYizGMFjKcGgwWWNbtWYWQUG22wLf0mZnVOYG5oYa1AwC02hqPeXTuY0tcwshbmG43h8
         DpRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780861536; x=1781466336;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WonlPgUFHgcUs9L2FpzERLFLGDIi9P0mv3+MIWNU1M4=;
        b=A9pAkFfMXqV95icSwGjLuZHRBW2rs8jPEj19XYzLWyrkS+SXR8oAw6U7nm41mtFGX9
         rXx8ZKjIifwa7V1p/u56n2hoq6qwroETyUMzmLWEX2W1dJpTNB7Ji6KO0EUvb5TNaJls
         RE7R5g3VkGMH/xaRGPsr8rc8JovIrllxPLUdEyVquf7Tc0wWv3uxSwDWl0Mn8PgXpLKn
         aEvJPZtpincr8+DsuW2BL6fPgy5be4qD6lZYN8bHwJsyB4lBcN1d7kYDLee8dxgBmXU4
         qmM/7BD5GNY3UnvxLN5ddi2iY4tQiWIBciB9P0XI1PcX1mStlQyZCn49H2B/Me4tN2Ox
         u3ag==
X-Forwarded-Encrypted: i=1; AFNElJ9nD/3J26ZIb8O0eCcjEvfY+JFrJMoJZ8mZbSWE2pTkQ6wkPV5rZo7G6kxxCEHb9aZlsxMljTItbg==@kvack.org
X-Gm-Message-State: AOJu0YwFxPlDRAabfiwlwU8VDm6Blc7dRwO2nrK3hA3vATVnjJwie6RO
	anr8gKKj8nx2Z3+YOUIDMz3luLZZEqAP+N05AAak+Cptgy/9+0P9AuQjMZA+pkOozB67SDGjNd/
	53dNAbwzzY92P+DIBc3h70MDyUhgQAlcs8LHyZFRB
X-Gm-Gg: Acq92OG4oTGQBVqWYxSBubax1ObE/zdyCLYxDhuR6PZQsDCym+au/bg54dUu+QNpYvx
	qFh/ksbMNNuEB3l2yuGNeTIs/mY/QDF7k3codv7YKUBsYHA4kguHdMkRX9sdwLU9OIcmGUjioaI
	vV6yMN97BjL1L03KQz1BjYNbE9/WXoA0bdZedhkNwH7WuJiSm2mshUiJX8ucAqFVeAYJLeuZGQR
	Z2xYblXzcJnHmgQq5IPJUVOiu8eCS1oqMRvP/rNvSG7+BMTn08F++iMrPVE8CoZVERyEEptbt7M
	6jEL0xVc4nfEM4MX
X-Received: by 2002:ac8:7404:0:b0:517:5f1d:9f7 with SMTP id
 d75a77b69052e-51798048095mr17306831cf.7.1780861535240; Sun, 07 Jun 2026
 12:45:35 -0700 (PDT)
MIME-Version: 1.0
References: <20260606015729.1837935-1-surenb@google.com> <20260606015729.1837935-2-surenb@google.com>
 <aiPWD6xZLg6g4DTO@lucifer>
In-Reply-To: <aiPWD6xZLg6g4DTO@lucifer>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sun, 7 Jun 2026 12:45:23 -0700
X-Gm-Features: AVVi8CfBcsay7fSf66Sk-qLT0-CR42bdtqU3m7RFkKEe4jFMaUgxiFQKjS-VLls
Message-ID: <CAJuCfpH74gRmgm2tgwB7SHzL9DrU3Yc4LyS8XLa0tR7fJqaw_A@mail.gmail.com>
Subject: Re: [PATCH 2/2] fs/proc/task_mmu: read proc/pid/smaps_rollup under
 per-vma lock
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: akpm@linux-foundation.org, liam@infradead.org, vbabka@kernel.org, 
	david@redhat.com, willy@infradead.org, jannh@google.com, paulmck@kernel.org, 
	pfalcato@suse.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BE9B61A0005
X-Stat-Signature: 3rusgojhb3xnre8p31h4ewudgzke387o
X-Rspam-User: 
X-HE-Tag: 1780861536-99403
X-HE-Meta: U2FsdGVkX19yNNu7udCHxZ48lpWpFCP1d5evy3ERDwzJ/6e66K27oEK/KnfSffX1anyKeUmjvUsjsFrnd8N/WFzoZynU8LmF8kYsbp52O1bGX9MKfF9cHlqPsnjOV9Ogvx5d0rR+/qmXe5QjEGpuTAwSecBHFY0YaHdknLxBV0kstKA9+WqpSECm9n0IckYeg/+0190tlmKE6lltG7MvwwqUt9FbIf4wjs/x+5l/wLEdvcZA+GvnSx7CGvWgf5rmYgb2965PcYX6z74yhikVDJTMTljfR7t9/JiF4SAAQEtWls9am99tE0IdPxORt6qztVT3zaFfx4ls+aV4w9k+z4/k9uP4dJTPMU3LOE3IHDTxM8pmoW0/kVEzCx4saqgYNYuXR2xQXpISR/zCadQ+QY1fb66n0jNKQHB5TWpK1nHuAmHvlG/iKfiNTQK8k3RSJuA70MAoyH9zpamt1ejwgBQO4anWL7ejWOF3hYlfqfst/MPId/KjalhtbH7iKXFMxNu8ViIvYtKt2xO6JqCnyvhKZnzPGaPdT7mK7YmGebItMg/DpOwrW52CJ3lxLGBxVwN6Tnd+OLl+hTo5ymzKAMR9Sy4+l6iajysLQtjpvimtqzT696M2mQAAFj06wRg6HU9NGA43I4/ZJa6NbxvH4JYRCj5dGEjrE8K/wp+DvCd463zat3kGbG3zmUiNYPwjRAO0BkDD7Cbwjd++OEKorZ6Am0S2h6Qu4O3m2axoxMLUdVVyJgTqvyD1C8w/QnEyQ+pehu8Xr5dkKBrlsat7OAcdXT4LudKYUaF4otaLxESFw6+dvqS1Ec0ySLBSpkCGjRCFEOYQhCrtUwby4//hH7HoT/g2il+ORnFoZ3lLZ64m15/WYM8qabJwf4yyAxbVjNckjFyjcjnFreFu5NGssqKwwBg+ur4s7ELYrmzhT0KcIBKbCO0fFtfT8951ohCie238vlsexFdt0qaizv5
 xU4slYtR
 NiE8cxAQPqYQXOKfJsR2geTdzlOOR1K1j8KDv/qHKSAnSkmrRviFrone3cgMEF01PSrEvrdJ9CnYoJk/uFyssX0tN+wVVguZxRtIwa4YFH2HpG3kTQilaa6QfCXDj1KMfhmn+OlVRaNO4ygw28Mp7d9NECwdToX0aXtWOELmWllLP1tkiVWnCFqavbderdiMmCrJwH5S0UnIWbYmV+XIYCjKIBWcRhjDrSjqrj+6jya1KHNsxGH67ODr6UJPNMJIUZxuL3xxvGA6C15NttlK7qfuos2p3CPrtZ29Pg6726RkiJrNxBXKjuiuYHQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jun 6, 2026 at 1:12=E2=80=AFAM Lorenzo Stoakes <ljs@kernel.org> wro=
te:
>
> (Will review separately)
>
> Sorry to be a pain :) and I know it's a petty thing, but even for a 2 pat=
ch
> series it's easier to handle if sent with patches in-reply-to a cover
> letter :>) also makes it easier to track overall updates in cover letter
> changelog.

Yeah but the first patch is a simple cleanup of about 10 lines, and
writing a cover-letter for a single patch seemed excessive. Andrew
would have folded it in with this patch anyway, I think.


>
> Thanks, Lorenzo

