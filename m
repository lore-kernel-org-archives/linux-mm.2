Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDB2EC4451C
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 03:17:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C65C6B00A3; Tue, 21 Jul 2026 23:17:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3790C6B00AE; Tue, 21 Jul 2026 23:17:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 267566B00C2; Tue, 21 Jul 2026 23:17:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E9D3C6B00A3
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 23:17:29 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6D272120371
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 03:17:29 +0000 (UTC)
X-FDA: 85014952218.03.2155B76
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7C338180007
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 03:17:27 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=i5vsiwTz;
	spf=pass (imf24.hostedemail.com: domain of surenb@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784690247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j4jeUlskt2tIQj8M1PMkFdsb+jXr8VGm4/YbSXLXbIs=;
	b=ewcTNme8PnHBaKwtV5obNTuW5r5+Zrzg1m6HvHa0nrUXy23YGGRKPNGdjyH4JwJvCmSpYh
	dOs+NGw+KI7XMNXu5wJh5HWkvd+V85BDsffHxO73m2OqFFLfRcKWbqjY3ObVdUvloeaZNr
	MvwbJUxMBlg3ojVjyXMqmyA6zWG8J/k=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=i5vsiwTz;
	spf=pass (imf24.hostedemail.com: domain of surenb@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784690247;
	b=V3X3XkQBIdebJyisHC2w75z64hr73zEYNrBQ469oQP2/vP9xcdDPvuhhClM0CVRbANej+U
	+tBAq1LhhsdkhZZ9tvmn7+6MdHjVJunz9LXqewG2TYlEepVZJegtHn99mwFof72ny6Wz9t
	LCCLbV7z1ErpTZEQsfoGZD0eITOXbvo=
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-51c10e86e52so1394141cf.1
        for <linux-mm@kvack.org>; Tue, 21 Jul 2026 20:17:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784690247; cv=none;
        d=google.com; s=arc-20260327;
        b=BPKYtigSf0zfyEjuUFRPizxJbiHCwR+8IINLSkUhHglry47OvwGWzoPIR1JkNAzrBI
         qEPS5YCM9bFKiraQGRh0PgoUabIstGsS6plXETxww+cGTQYPCPBfkT5pS+HKb2sKBB10
         MKB8QNtzjihaDyp2sSWj7k42A9Cs//WkBc22uJuhgF6o/nJzgH3qNZyX9TLNBe7N0zJB
         bNlOLKtx39qjW1tD3cNopXxllSaw1donuw9122nogG/0FzZi7+4Hvap7pGD9u0zBeZVQ
         t7L5OoAa5M2Ug+P650Vo85Pnyce8C5yHTeUXsFqBhUpO+owq78ybm+g/sXhYqcOeQt5n
         /KPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=j4jeUlskt2tIQj8M1PMkFdsb+jXr8VGm4/YbSXLXbIs=;
        fh=CjenU4+qvWowO2oRFBzJVQyQcb+kTHqkc95QITnlzB4=;
        b=dNPKJBF+ly8ELpEGLx2647JyyTADMOisHd94jDezPbzYCmMdrJLPIbWoA3sXpQFhqm
         +ZVzulOjTWaKCFRoDZ/xGBipUeX2p25hPX0pqUZoIaJOS9sS+nM5PHs0Ks+Cx/7thuBU
         11RZNZuaKNiec45fOzBjKBDV9os4WYBZrxzzjTjExFXLVUSgOihfcW7xtfFuaaqXiSKl
         DG3IEXeE7+8e899zL9Zjr2RXm8UOKxu2YIeXPaW7F1Z2LmgXs4o9nr2WHgAc/vaREkSj
         06QG6T/w7ocjiiH5ARDT/73vIxuPJZxYKHI6rdfAlQKNX2iYe2Grq8S03warpR4Ax8AG
         +bKQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784690247; x=1785295047; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=j4jeUlskt2tIQj8M1PMkFdsb+jXr8VGm4/YbSXLXbIs=;
        b=i5vsiwTz3pFswxTrQn77r5DCkQTn4emVa1F/DdiKV5CRlIMVrhEOLdHiW3Ja6ehZ5Z
         1rtZI6iVQJKvQHfSFgp70FCP7X8JlMjO4YzgIlrBRmaHftOQ5OHjzISQ7OQ/SX34TDGY
         JHwPQC7pn2oyrxIrVn/ZlmU325AoUaWRRTCxIcQJPreBc6fuxrGpkAEtcnZ7ebuWRgwi
         8r5VdY3IK2SAbNxK5kYcZD5jtjBNw9uuzCDrdd7CmgoIdy4ekBBvzPGszr4jZNhJAJQA
         y/iHTa9vfE72Hn28VZeKfGcR/sn9hwoWEWBNUpE8kiZc63p/sChDMYaJoGce21zMsAY/
         e+cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784690247; x=1785295047;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=j4jeUlskt2tIQj8M1PMkFdsb+jXr8VGm4/YbSXLXbIs=;
        b=sXsQh2A5Kyn+DYM19+LD6WYuHN+/0g5Q3XMsNnz9rAjhS1AtaLgIzAI/BIpXPNLpuC
         ZOkQHjIwnYFr9PmsaRZMivN/qeJ6rjAmf1NyeTyne7VjmscTfRvrCXmlzaPu+daOfvoM
         nIetzsgGSYX0bRbjFfAjWESKxmyXS5b7FYFJOuP06fJeJ8J6ruIwUtcNI/uKFVd8KCd2
         ahAeHFFvc5VE4peobRhvP5D6vTkwVNRe/1Lx6GmE/kL2p47djmrpIp6xnX6st1+YHPef
         1RFNGOT0E5tKlOnoRi1Prw5wpkzuG8tgzNd3M86yom3FuMWymqfN+6H3MhcdJ/ktnpIV
         FETg==
X-Forwarded-Encrypted: i=1; AHgh+RrqzDsgoZzYhV15JUiAOCdUhaFAu8cNjMhOZcnp4eLCgziC3DexVvAsRAdm/CpnBKskMsj6oZcbhg==@kvack.org
X-Gm-Message-State: AOJu0Yw5zI/Qxh04i4UD7j6p0LIZHh66Oh0kopdcQs11CIwaPRbdV/nE
	xsIf/tsf/g9PWQM98RBXPigJTm1Lqi3iu9eNwOjROWInc1g7ABHkPdEgpwUnlMmtDjYld+B2BqI
	g1n/FHOWIB4/PNuHeVbQXWZF6NlrLHAb9b00zNkZC
X-Gm-Gg: AR+sD10SevTA2zOjSlBlr34o+ebwMDOwAH/SXAAIP5KdnDHgzbXxfpuZavhv573cnKA
	kWqJN+O+PgyUqwU/xWSs4PYBmMI9o5PI09D5sqnCN9w1emx7tPNUvvYDQ29D4u1NpJfeYVKIojp
	3Cqrr6AIqW69hHArf+C6sUfYBs6xWBoriiMtK1mzGlik5FRzIYZm0pwgfrno9/Up2DF6U4KljnJ
	pQySRpfhgQiKT8S+tOEorW0c5p1qFIQeF8G0GNYOTD4rm/x+DNUAB7RrksL
X-Received: by 2002:a05:622a:6084:b0:51c:289:6979 with SMTP id
 d75a77b69052e-527efd1f994mr3666981cf.21.1784690246021; Tue, 21 Jul 2026
 20:17:26 -0700 (PDT)
MIME-Version: 1.0
References: <20260721051903.691848-1-kaleshsingh@google.com> <20260721173939.6bee67b6af17b54961daf4f8@linux-foundation.org>
In-Reply-To: <20260721173939.6bee67b6af17b54961daf4f8@linux-foundation.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 21 Jul 2026 20:17:15 -0700
X-Gm-Features: AUfX_mzdJ6l7ZHNA7SRCoMlMuAxO3rUAUEiO9n109Oxt3pqHFJW2MXorJHs2JRY
Message-ID: <CAJuCfpFVSrP2DGNr+tZadVzbuWvi467F879qndkQ4VTx6R1w_g@mail.gmail.com>
Subject: Re: [PATCH] mm: proc/task_mmu: Use walk_page_range_vma() for smaps
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kaleshsingh@google.com, kernel-team@android.com, android-mm@google.com, 
	"Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 7C338180007
X-Rspam-User: 
X-Stat-Signature: kaykfy1hzicc8xj7r6ojt15j8rmnq4k8
X-Rspamd-Server: rspam04
X-HE-Tag: 1784690247-264242
X-HE-Meta: U2FsdGVkX19k3H/XJJ7WMcR3n2T70tV/sJoFofU+zKllbCTv/Q6lCzzcMKrH6zQ71JOnYEqg/G8Mbzgs73/yjXIp9f988ru/1XpiWksKTV6t6KBgbjzCDtV4HO6TpAm4pSfxqCdN3JVkjNXHGOfxIcsCchoKH8yjaRoAef4O+dQhF8gKn5ujgar+To1b0iMuytJ36JyOO35BrQhDNlTyl6d/uCgX9i5XhaV4+FrYSEzQ6Mi25bLu0LHilJSid4mBKLpAvlxtEiYVA0m36i6n8joUGKUBpqEQ/fN8KsbLp5W5BbElIuDcsVbSH6aTz3xjmil7t6aHZwRURyqFjzthjHyzKln9A4dwG5tUXxUQCKFvVbZSqm5b5UiqrITngBmkFVcrFXSYkdygNH8wpiwjP4ZlhvNc66kj0h3kgmmG/8klZvZNoU8dZxcXSFHRiSO7atvsg6qWRJ0BUi1qLSEpC8LgpKD2a58tmKv3eDs7CL15Bs3s/5XYRItlfoqkYVm5obZoaB7EeR1MYiBn+hOGFPA1APM7bTfIa4nMmdRgOPRhW7S5bmAuY/lIK1cxtC2qY2ACQe9Sd5vGPmXPO9EgEVTh9pXO/DTcp50pG00I+WkBeTc9HfUS7IH57fHYpuRjdC8J2FG62sgIa3La9HdjkPTYzlEjOM63KYo+WVian+zapEd4tg5MM+gSC6e4TriGN3CUiLe4s+IWrdsXL3KAVDl7OpFjNQm2kpx0LR28+W9PCDW2gPkTSmi/l6dUs/zItxu2HYngvHti+C1Wndu6EKak2iNidTWAiwLVZO7ES0G7Tr0dGNKUGfoYtVv5YdMRVsq4aK2a2Q6QyncQmch+eNjRDj5uRo68cLpDGW3Oz4FacYmX24MZUmWvvdt1BW2Ak/H06HmDTGYS1MxWjXaGvi4esPXCp2A74Drq0d8gdYcAb9H9MZOCunjonHGRWARGiQjZeEO9aZiGVcCSH/G
 JUHap7Zn
 SO/DJH72ko4gHNULG0woLziJKYiYinWXHIeqQTl9nWDwkVoz1d70/ssJnbmoKzFQZi/NEWC8FZdNkgQNSVkUDovdN8Hrywgina3goPtkCw3jAt7OW8lB6DgKDixOVn0RgBweZVywUpJInJyYavvqJHRO1vyvporsHzR7DDLrDqO5T6XNNu6HbjaB0xHXPkRTH7P6j9ZNevEK/yXqv6zva+xwPqDO/fKZGQ7zw2/TCmw1azqX0w8CN2U8oon/pCMZmoQ34DE+GHlCD4ZlbOzDupfLSQU/A3yLRvzvSntCqpQCqgj0dszWExQ7KGs994RQNzbaHLX2SqsRY0BTaueQBz85aXwEtIAEgQGgCRvfperRHa9maiMlBUHWftCP+VBXFIqJKqkMJ5URyKtTyhPMHS2ytCyZmiDiVQuePcNOJ4dUI3Eg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 21, 2026 at 5:39=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Tue, 21 Jul 2026 05:19:02 +0000 kaleshsingh@google.com wrote:
>
> > From: Kalesh Singh <kaleshsingh@google.com>
> >
> > Modify smap_gather_stats() to use walk_page_range_vma() instead of
> > walk_page_range() when walking page tables.
> >
> > walk_page_range() internally calls find_vma(), which asserts that
> > mmap_lock is held. This assertion fails when reading /proc/pid/smaps
> > under per-VMA locks (where mmap_lock is not held).
>
> So the kernel is emitting a WARN trace under some situation?
>
> I'm surprised.  The offending patch is only six weeks old, but we'd
> normally hear about this very promptly.   Is a bug report available
> somewhere?

No, when reading smaps "start" is always false, so walk_page_range()
is never called.
Kalesh, this is not a problem that ever happens in the upstream
kernel. In Android kernel there was an out-of-tree change that caused
this warning, which I pointed out and you fixed. However, the upstream
kernel does not have this issue.

>
> > walk_page_range_vma() walks a range within a single VMA and does not
> > use find_vma(). It relies on the VMA lock instead (when configured
> > with PGWALK_VMA_RDLOCK_VERIFY), making it compatible with per-VMA
> > locks.
>
> Sashiko said a thing:
>         https://sashiko.dev/#/patchset/20260721051903.691848-1-kaleshsing=
h@google.com
>

