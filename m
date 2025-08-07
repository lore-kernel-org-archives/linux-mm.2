Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41236C87FCF
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 16:03:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D28B16B00BB; Thu,  7 Aug 2025 12:02:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB2466B00BC; Thu,  7 Aug 2025 12:02:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA02A6B00BD; Thu,  7 Aug 2025 12:02:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9F02E6B00BB
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 12:02:59 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2FCC458A8B
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 16:02:59 +0000 (UTC)
X-FDA: 83750430078.10.689D7BA
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf04.hostedemail.com (Postfix) with ESMTP id 57E5E40012
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 16:02:56 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=wmQN++gP;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of jannh@google.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=jannh@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754582576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z//UwayiWOvWJqkaPBg7axs/e+SZ904ur7krzuuGowc=;
	b=AemDoMdgqH7OTQLcrr6By+luejy/9cKNrcsv8zPXuJAiP/JF483hsSdYwJzscJRz/mdOY4
	USsE2iIYIXyezeK2bZTQA8CNxIpVdKLaGv+tIl9EvK64HaPQtRikopE09JcaTF0MPHiyYK
	PZ3ibUrGK8auF6jHEY15JzhngUDqAhQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754582576; a=rsa-sha256;
	cv=none;
	b=LSMidMQIDmkPvBelOxjgRdOrqJ121RCMGDGFlf2rAy8sbBIzPTdMbsv8N02CqSFTnO00Li
	1AUFz0cBhLbAOwuG1jEbWpjZTnL7B7wlFtu6uG4f/975GaFizRfz8h2NXmjwTM35L/Yg4B
	BDsaNIE5hfBKy+atgrxXDQJZnkhTncg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=wmQN++gP;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of jannh@google.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=jannh@google.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-5f438523d6fso10826a12.1
        for <linux-mm@kvack.org>; Thu, 07 Aug 2025 09:02:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754582575; x=1755187375; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z//UwayiWOvWJqkaPBg7axs/e+SZ904ur7krzuuGowc=;
        b=wmQN++gPhGP6FNlfevKIFtRgEQBegcRzizZdIz4LxbpI4DwpRIkE21JOAoN6+M/L3w
         dlsTuZ0aCeAi7vsmnh564ArUKtswJuwhiRQ0V+5/nNTWY0kuJu6gHbTJj39d3dFyyd6f
         wJ/EzUWf+rTlyKEBHaG7hhCTNQjF2K22gRjVgV2HY5BAGNzdr4voCresWiS5jlv94tJN
         WVSSyxqDG89Oyam+4c8hVGGcV+Qgt5Rn9uz3VCoIQx+8nqsJNBSNUceMeGbuARBulUJ/
         yLBcw3/QrVAice/LjV9UaO+9mya0yYm6HqK4C6YPTH4i0z+qkNF5rxkzQqYEs37yEiN/
         IWhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754582575; x=1755187375;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z//UwayiWOvWJqkaPBg7axs/e+SZ904ur7krzuuGowc=;
        b=ImHGUR2PWJ6wd1d5/8H1x9uPYABqG76WD6RsbVNF821AHeQX9qPn56UjtGX0Fo6Scn
         ziUqzdY5K6Ue63OFTgl9/PgXYsfE6zBC9/Z594BlgQXpHdQINQ0swgxIBVIQ/EeX9iz/
         qkDpsEetEWvBga/hHO2VJrA9tNNzxOCrAIVoXwGd93qgimaOUyjSLoUOlVnXLLkjdWkt
         cgNANOA2pGgRnBKs9GnY+zYuiqdU+y7at5Nenpz5xncHY8Vj3wTKRK9bUXFvlY3uRaCb
         ThdYMPBo7XRNk6TniLizjb/S8Zkhma5cZumkQozUhO7f3cyEbE7tDtwUfGmLTDfmNF4O
         Zfpg==
X-Gm-Message-State: AOJu0YydUTQ7mOvBqa/ahAMgVA1zc/Qxhqw/ELOf2UdarQFQ8DxoM4fO
	Zf+TUy4/cCL3OiZ3+y4BzSNFKNLOjSRvDVJrVTLqgbiyT30UWanm4VjiVPZvlYUBiEyAP40Cxbw
	CQmSXnFVq8Hoy3tLLL+bPezLmDheT6FBcCGEhRypZ
X-Gm-Gg: ASbGnct2AVvD5AQbFxn09vKw5cC0Jvf1OwUhUxH3zZ3rEFUC2V9YZKY1YTsJREtbQP5
	iJmBILTLbYdCZphw1cf2Gp0WToWy3J+U8H9cwjRyBXxF/jppwTr3/frE04llGqERW8ezz/0Xy28
	RRkm6q8xgc9VXPl8iFxpLz5CvGCdYz32rWCq3fvCtocukpTsx8rAg4grqIcaJ0mNNSx1k7CvVE5
	zy6VeA8Wpqiy1vZbAtbye5WUOtWbAQYkI4=
X-Google-Smtp-Source: AGHT+IFASsYOqS+cSKa8zVP9xve2ND/LPdSpr3uJx8kIFFr/IcyZmEblAexSI0+MnJwWTh7EYp5HiNO85CLzvvRh9pI=
X-Received: by 2002:a05:6402:3059:b0:612:ce4f:3c5 with SMTP id
 4fb4d7f45d1cf-617c38addddmr77974a12.0.1754582574434; Thu, 07 Aug 2025
 09:02:54 -0700 (PDT)
MIME-Version: 1.0
References: <20250807152720.62032-1-ryncsn@gmail.com> <20250807152720.62032-4-ryncsn@gmail.com>
In-Reply-To: <20250807152720.62032-4-ryncsn@gmail.com>
From: Jann Horn <jannh@google.com>
Date: Thu, 7 Aug 2025 18:02:17 +0200
X-Gm-Features: Ac12FXw-L14MzSZIbdhDuuuaGoNtnHc6MgG8djKeHfkzC15_DWV0euBIlOkenb4
Message-ID: <CAG48ez114_bmuca2UL-g0ZY76-VqhL-4rQtJM_k0N2NJXE4vdg@mail.gmail.com>
Subject: Re: [RFC PATCH 3/3] mm/mincore: avoid touching the PTL
To: Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Pedro Falcato <pfalcato@suse.de>, Matthew Wilcox <willy@infradead.org>, 
	Hugh Dickins <hughd@google.com>, David Hildenbrand <david@redhat.com>, Chris Li <chrisl@kernel.org>, 
	Barry Song <baohua@kernel.org>, Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: wobj8egz3m7mgckwzok6eubkmpyxswap
X-Rspamd-Queue-Id: 57E5E40012
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754582576-650766
X-HE-Meta: U2FsdGVkX19vGz/nHIrPRGpYXDK2RU2TQSeOjDSDodu65Qkghq3mtkCCEnHG85x0N5DuAtUN2JoUl/DHZy+067Aek3luRSYPhz+P0eSPNVDYBisN05+5g87upsUZ5bHUSxKeYN/5d1cgB78UPow1TZ3EkvWiyFfKvSzIaoz81eAsyEVsHgOZKdy80Up3BPJLlb2Hp8bdr3MSc4iCy9XnA5EhidST2WYJbV9Mp7Q8cLf7fD3MoSEbE8wbHaYdpY5jZnc+6eK16742DRO/+lOQh6jlD1nB9NFArajb8M6x2rlnihooYTxrBuNvou1FIY/IjJKFdGMhhcEzWrnFYcEFtBOZMylqcsuiTJfedN3oVb6It9YOspTMoTOTFd39grKqaIujgIQtXwDthYoCiGa5oDl1SpcJ9LcaTyAHRUcb8vxYEhnVEa6SXQ4pQih/toqkecoCQdoeY2tBF0UO0GnWOTo95EOSLzSztTFhhzKgkE7JRFfiA8Q3EfwTJAhQAsO1bjNARsP7q/xKg1PvbzmFL75kR17gzkJfWBrg5q1YHL5f7tTPoSDQunFsw7qTS4j644fWiL6zoffmFjOMAPu9wCR1c9mZrXo/ZjUfvI12Xc36pheyicryPMmr2gGCY98tN6ap5LKG3eYluW6XHWn6qtYEpmODfCXS4bwvZWfYJNV0TYOaS8/D6JVmKheackeIf90nFXnW++omdhJVNdzda/CImPmD+E5/Yl3RZlRZ1Dnq3WM1QWCm+K3gPwhkLYpw4JXpmMeiTjQhNffYCHOEpXOp7nkNWjERT3RLBgxddzU2/N4174oknFepu4lR5vtj5BCJoWpw3k1YAIsPLdhEMKouH6nWoZASAy07kEjo7gB5mGTaDZOh1ZiC8YQkyDaIAnfb0d5EGsA3AXVjCny7+LO1ITLru5Nad3kejGPU26k1rjz9f8x9a/h1n8OK00BfZL0/7Se4nhZa2gPndev
 FV0Bv66X
 FsV10Rj/2yz+y1w3xCkAY8zS3KZaIy6D5LvwFk7+BPP0vJaYjfyrYtWmSI0yhytNWhppAgd0ebxvp4qJx9W56OeQaA59eol7+Qfs3Fq5tnCTZOBal91a8rNERljYftWZsASqlFx36JlNvj2VqNuFHKv3jBOdI9auK10SmcAcKg3pOrKFR6vkhRPi8VmJNAk0urL4NK+Y9NbK2urLi+gXvUmtvMVi9bX1Hfowv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 7, 2025 at 5:27=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrote=
:
> mincore only interested in the existence of a page, which is a
> changing state by nature, locking and making it stable is not needed.
> And now neither mincore_page or mincore_swap requires PTL, this PTL
> locking can be dropped.

This means you can race such that you end up looking at an unrelated
page of another process, right? And your patch intentionally allows
that to happen in order to make mincore() faster?

