Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56BFFCA0FE9
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 10:51:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A17008E00C7; Tue, 26 Aug 2025 06:50:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C6418E00A8; Tue, 26 Aug 2025 06:50:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88EF48E00C7; Tue, 26 Aug 2025 06:50:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 72BB98E00A8
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 06:50:59 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DCDE1C0747
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 10:50:58 +0000 (UTC)
X-FDA: 83818590996.14.D36D922
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	by imf24.hostedemail.com (Postfix) with ESMTP id 13E02180006
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 10:50:56 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=YxvsGcWa;
	spf=pass (imf24.hostedemail.com: domain of elver@google.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756205457;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LBKQHJXt7k5q/EQimxKbRfxnkhOmIaY3I8CzQ5DxlNs=;
	b=lQkR0cusIZL4bJJIg480csZXyvu5CN3ROr5x6FgQ62hrHwBiry9obDGf5hG/5CT4wzEnna
	3ej8U1Vnz5DePryquBzFJvMQdIgRdbuvzRh74vuQ3ZjLx0nA7tsVNYKaduGpCCWELieD0u
	esZtMH0ik56e8O3fOtywMLpzuiE2XB8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=YxvsGcWa;
	spf=pass (imf24.hostedemail.com: domain of elver@google.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756205457; a=rsa-sha256;
	cv=none;
	b=TcHC2oHdDxVg6VISFErfxNHnxmJ29yVSvNyfhxVyhyh5fGJ9kPiY2rLHRNvOm7btg21nLe
	B+VE1D/7d1pF5+NChAcuWRTtowdyciqwBphvDBrLxYLYlcgNhhnOt18LgeLglfnpayeJJq
	z7HfPwv6uFe3ex7kJYxcJb08WIN6QDY=
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-b49d98691faso1648661a12.1
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 03:50:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756205456; x=1756810256; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=LBKQHJXt7k5q/EQimxKbRfxnkhOmIaY3I8CzQ5DxlNs=;
        b=YxvsGcWaM6PZUoj/j8sorFaBnKM45FrLAC2XAzgotUKqqELiOvPdYArxF01GbzJbvm
         ciL0LGHFw/kWofeENi1EaQHqYeCPwAECpHSUyeJN3eZ7btb7PvwpA8jCY3WxZ7Wr6pcA
         W1ff+lSUE513ADzUBEkX1i/Y1gJkDgGBhRIjQEzhKsq3oLK5zmvF12Ri1082ZASV3TYK
         L7Xr3GjNJE8UEd199m4sBEESrIS1A495KVpINi1zlONQLMDsAEPnLc10tEJ14YMN2PJh
         xxcD4995HU4mB3cl8rNPR9zaTDtM8FOKHA0tNp4Z+hXsvo8kmH2YzuzHY9JbIVpGMtIs
         N7kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756205456; x=1756810256;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LBKQHJXt7k5q/EQimxKbRfxnkhOmIaY3I8CzQ5DxlNs=;
        b=JnRu+kKxbuF+y7dxTC33AUWu1YyuUKwsV3jT7lEVijKLT2y0/eT0k7JQFAQjjVoSsN
         qcwwmRWHGucPtaq9ZD7WzkNQ7EIsk61YRuYr1FbOgFr3l3+njSC+EGfNyAV1f6INfjcK
         Z6+450Dsh3HLrJjlsk0ysQWXLOyPWIF+ei6zx15jiWpy+N/WZBAeodtQg0H+nsUh58Eh
         z4y0Nj6H6Vf1qRIMXc4rHpI5WcL02qglEwaINdUavCndJXkyw/5j6RhEtx1r2HAUHQVo
         b9Eg9fC8nn3a4CwxUrbMmVgkyKTCW+YgaC/VrO0f7UdqRTvrJpiQY4Xwb9mdNigoFV65
         CI+w==
X-Forwarded-Encrypted: i=1; AJvYcCXEP25MRkxvD3QI3SoBE5LqZrgYcFeh4rDoG/l16VHs28eYpVHyH66qvyGCM6VR/CMMydkQAYd02A==@kvack.org
X-Gm-Message-State: AOJu0YwrxrBTZWpooG+g25uDDITiYmt0hU+5cpE/BbwXyymZwLO1Y9nO
	A2uOqPa0YxIh76W8jGMmvQmWn6eEAQH0n0vaT/ReUcVZZlphBNNG2YeLPpfxV29tvVWusz8CeEF
	kxZQt6x2TTNIYGEnbCwd7KHiXYD/gRXU8eRlRqlwT
X-Gm-Gg: ASbGncu+rb9WFtE7tlkqARP2X1lKTdsjD4VrHpFcjhCtYB6ToI3mm0N585IUnMVEFW/
	Bq7389X3v6s9PbdZH8erQCuxJ7CrRqvJ4k2rRp7o+L8CLpE68SkSIIs4JwDwMREvqkXMKHThoz/
	SOYmclrNdQTBmIjoKIq5P58WyIvesCG8VH9Y4w7Gtn9yTEp00z2OJgRHcDn5JioP9TbHjDYahUd
	SA3Z2FM5bFkwF5uT/dEDedOx9g=
X-Google-Smtp-Source: AGHT+IHf6qim9cZNDk1kCo2rmmsC3LEblFH6JZzN5wGzcAVCxtsbcMX6nHM5LML7vHzagExj5m6bdqA2j2JdFPNAzSw=
X-Received: by 2002:a17:903:40d1:b0:246:d00b:4ae3 with SMTP id
 d9443c01a7336-246d00b549dmr76053385ad.61.1756205455660; Tue, 26 Aug 2025
 03:50:55 -0700 (PDT)
MIME-Version: 1.0
References: <20250825154505.1558444-1-elver@google.com> <0DC67CE5-6006-4949-A81D-882DBDF4DAC4@kernel.org>
In-Reply-To: <0DC67CE5-6006-4949-A81D-882DBDF4DAC4@kernel.org>
From: Marco Elver <elver@google.com>
Date: Tue, 26 Aug 2025 12:50:18 +0200
X-Gm-Features: Ac12FXy7R8YoW-2EpRHczPhHZJ0RjV4YJMdaLPQVeIhDdwxbJBGrafjAEUd74Ec
Message-ID: <CANpmjNMpnyQ=PhZ4jkSiAR7gg8WJOiunoxwhRWuUD1U_EEnyrw@mail.gmail.com>
Subject: Re: [PATCH RFC] slab: support for compiler-assisted type-based slab
 cache partitioning
To: Kees Cook <kees@kernel.org>
Cc: linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, 
	"Gustavo A. R. Silva" <gustavoars@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Alexander Potapenko <glider@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Andrey Konovalov <andreyknvl@gmail.com>, David Hildenbrand <david@redhat.com>, 
	David Rientjes <rientjes@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Florent Revest <revest@google.com>, GONG Ruiqi <gongruiqi@huaweicloud.com>, 
	Harry Yoo <harry.yoo@oracle.com>, Jann Horn <jannh@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Matteo Rizzo <matteorizzo@google.com>, 
	Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, Nathan Chancellor <nathan@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Suren Baghdasaryan <surenb@google.com>, 
	Vlastimil Babka <vbabka@suse.cz>, linux-hardening@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 8rahtehnigmzyki8gfp1ye61mwewfxx5
X-Rspam-User: 
X-Rspamd-Queue-Id: 13E02180006
X-Rspamd-Server: rspam05
X-HE-Tag: 1756205456-550694
X-HE-Meta: U2FsdGVkX19nenFPToWhUfzp9hTVdEtbi/41y/AP7yHeJBcVN2h4yJ759HX0QtIVSnXvS6LjYA0+7p+TGMQSFmsOH1AsWPXvEoM/O7pwY8qH7ukvSSmEnIFpqCKeIIohaZZgM8/AxpQh5/YD+AZGXVZNqHx7dHY1hTr/ZiK3cGBx6lMyDFgveOEd2Vn/GLUYo3w0uIpTx/8ueCmtv+6qaiNdvmo2jKLSHmAOetSz4pUWmpwMPwGE3JE4jycBz//1cWcKjawAqcmal/dwjTVj/TZXPr442aB2VhAU+yEOcZlN+W7yOQs7W+LEyXqDndjD59raZJH04S0/1XYwSURv1BjaBaQ+q5LtxVF5pXdHWYRdpfia/DAzKNzH7Qbo2HCWqYLQs+w/mWSQIGR32jICV6obrsrGvVX23xLe4kx2YyKNToeeiz5gy7fRHvUC26hkUdbSIylR/UVmowTOx/kBBnF98TcRVk2uXMZQF8Bo1pMekEsENiVrf4wQ5GgpUeJ0tMLSCSi1s6ePqw57PRPITJkjqXXtH+JhKzp8KZcFtenKxSQkR2nVu9R9sSEadtiduesmx2a7980JdbZyjCopfIUu+dqcRDjP7OCvJVZWV4KWhyJx3gAyDuR7H6WLhO/47mqj18gkhUPgKtDUIMtS6/enr/GQpWXpF3vIAe4P9qrQ1TnLx/pZwFxQTtpFf21XiHSmsIbtyv1X8lP5e4qVAwZlH8F6WYp9zSj10Q2oNx+vflb00CwLGxpk+0WwqqTqsK/BVvuW2Gpp/S73KEGdNDnwNz5LcwKzJfeMXhmc40QTjLk18ouh52tbHIs/yUUEMZc7Hiy0HTyQXcQhYWUx18d8DEV1tUMW/UuhZlhm2mn8zvAZyzb+yRE9dcfbVNehmogo3h+OoAQZ+whZTkvKlq4kXgL0f6G/AmpcqLC9rCRwIYo4BwrhiGFfUnBmiSC2l7ZP28/O50dKp7EB1kZ
 ZcCXjaUM
 +E+lrgUdpLdWk9zlrLfKBQADyArrrc9ou0w42pMgfA/8QAf78BpDKiBmw0x8IHLL4qpYVsJzo5dj64gC0O4sNgl8lX+jNiOHY+hScJ2JTbQe6gZJwEF6N12vDBKqc/XdlqZ+DalU+iqM+2Vf8rdphQJAp0QayGxVs6ag5wWgvQ+TQXudP88S+7bHAbwT0E7S5E4TMmt9pUYslbn/d8vsUbCupOK9Ot3voy6O6fsePXFNynRKB8pnfu545Dw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 25 Aug 2025 at 22:18, Kees Cook <kees@kernel.org> wrote:
> On August 25, 2025 11:44:40 AM EDT, Marco Elver <elver@google.com> wrote:
> >Additionally, when I compile my kernel with -Rpass=alloc-token, which
> >provides diagnostics where (after dead-code elimination) type inference
> >failed, I see 966 allocation sites where the compiler failed to identify
> >a type. Some initial review confirms these are mostly variable sized
> >buffers, but also include structs with trailing flexible length arrays
> >(the latter could be recognized by the compiler by teaching it to look
> >more deeply into complex expressions such as those generated by
> >struct_size).
>
> Can the type be extracted from an AST analysis of the lhs?
>
> struct foo *p = kmalloc(bytes, gfp);
>
> Doesn't tell us much from "bytes", but typeof(*p) does...

Certainly possible. It currently looks for explicit casts if it can't
figure out from malloc args, but is not yet able to deal with implicit
casts like that. But it's fixable - on the TODO list, and should
improve coverage even more.

