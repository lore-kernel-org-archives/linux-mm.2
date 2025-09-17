Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AF40CAC59A
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 16:50:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 659F68E0061; Wed, 17 Sep 2025 12:50:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6301D8E0002; Wed, 17 Sep 2025 12:50:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56C528E0061; Wed, 17 Sep 2025 12:50:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 48EA28E0002
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 12:50:13 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F07851A05F2
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 16:50:12 +0000 (UTC)
X-FDA: 83899329864.21.CF7E5DB
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1552A40006
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 16:50:10 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Os2sAtlA;
	spf=pass (imf27.hostedemail.com: domain of kaleshsingh@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=kaleshsingh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758127811;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B8PrCNixuKjn7muO0S4+O0quWRgO8+yd5D10C3h36dQ=;
	b=B1y1L1Pm2+jGWSte+LCTK4HcTXF+ipKceBvUDXpFjWCwmYiPMbaEvDs0/5rXvfxGvFknWK
	fvxSIAXnebtm3LDK2k/ZH3R2IU/sqy0YfTGOP4NSLKFnaZy4ImANwhDlJicyaeyA6MHVOa
	3EWkOTwGMa9JLxIhbZuqgcQ0xgZVyWo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Os2sAtlA;
	spf=pass (imf27.hostedemail.com: domain of kaleshsingh@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=kaleshsingh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758127811; a=rsa-sha256;
	cv=none;
	b=O7obxhoxjEZeJDfPigELEeCUZtAJeJgV4+p1k/lvyvhjODn0VSvxEBGRQ5ruc1txAu5lDV
	GadYcms0NJC1p1gKxcQGMlP+FxcvoUrur3QOECSXcuW8J5WHr/Gp+l7LXnlxDbP2klyeGX
	PsQlFQKAYIrp2QrmWEV5Hd8TWG3ObRA=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-267c90c426dso2435ad.1
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 09:50:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758127810; x=1758732610; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B8PrCNixuKjn7muO0S4+O0quWRgO8+yd5D10C3h36dQ=;
        b=Os2sAtlAk+u4ZjkVTbbSDFz0K7E64XeKWMHHTNQcaonSk9ScOpDSl+49KDV/bsQz2/
         txzd7pijDFX7h4oB6CdCTrAOL3GKvI4XKomINieLqZNbJ76OdwPefJWA4aVQ5nty3osz
         AJlfPOj58eT4/+dUhMRkKKIuo1zgCGl+bIKELjQyatSkRDrKpAA/bERSao9do8PIdnKd
         1JmsPGgEUJJmDmYYsdKkNYd8KPo3TgDaU5shgvDqjSKOsljvexpX48l1JYg6bwCP+xSI
         F6/4IRbFBCBm0FMb/0dclsPkGZIUYCoglzWdj1HLpEMmwop0qpZaQt0LOUHa+fXUBqzl
         c1qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758127810; x=1758732610;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B8PrCNixuKjn7muO0S4+O0quWRgO8+yd5D10C3h36dQ=;
        b=I+n1T6GtI6PyabUTfJCVf9YDsrm0xQv6vvJRwMHB/GSPdJTP0YBv/MCiuJ1hv1VGBi
         sn77hyIitazENBoTtjn2Lbzye0fdOxTgg8ikNHlFr4aaK+07qmcHNhcOQGkprLdvQZkE
         DDCwcElHZKIuO+biFdrOr6aqSgjczIrhkwVqFIEZgbeFWtXpYIK1W4nSisd2YtsNanJd
         hX78lwDt6l7ouvYXwSriD0gh5R6RnnnRTmUSxrzXYHFXK6Ett3ZGF9fPOkVHkrhJZXAp
         Y0bXjDI3rZaN13MO/hvDeDA59nw6htNj7DN3f04acv5dc9u08nM4KDsu2gX5mZ4J0/Uc
         IqPw==
X-Forwarded-Encrypted: i=1; AJvYcCXmKE2/iFI0gCpxGIDN2Rl8asqnQy9mjFnGoulzUC1OdwcmhE91AkMB0XMoyLrzvmcyKVtLqC/5AQ==@kvack.org
X-Gm-Message-State: AOJu0YxdL6isugKZeeQ51+b+2YGQoqr0ru9gqCLlYbcrKPgK65BW/tFQ
	HgzYW2rOHyrpwjOcQIknhgXtJk2jVJkjR7QSgVsqJu63Yb0nbaHkiIb+HWqMXO2ZQUddPTRlhrK
	EGAHfA0EvZ0Q2pt7R/pZkI2szlQgN0X+/wj4HH6bX
X-Gm-Gg: ASbGnctG/VYhYpsMdryJlqLWFdKezDHORXg4oEo7kgDkUjsTjdaOPGDoaWL8y4FMjfB
	HGp1CeZH4TuvD8CqzKWDXrkSvQ1nNODvZYALs8nU1+OSGReOOMTCNKCEXiY+83Gv+16b3t1K9eI
	nVYzWhTykMk6knWPfvz76jpBrhs6z/q9gBLCxT59Nysyl34bxDirUng6Pq8olVyE7lbgieFxbpl
	7QFXms9TImYpSVPWtaDp1lLUET2Kp0ASUa1h8EGtWxA
X-Google-Smtp-Source: AGHT+IGtMrszeVWUnHllJskrp5Iflf/E5+ZGwWZI9QGzgm0SBtqy/zo9xqbqUXTBv+hZMCoJ44EWquT3yuXDAoQpNaM=
X-Received: by 2002:a17:903:183:b0:249:1f6b:324c with SMTP id
 d9443c01a7336-26808af17c3mr5103615ad.13.1758127809488; Wed, 17 Sep 2025
 09:50:09 -0700 (PDT)
MIME-Version: 1.0
References: <20250915163838.631445-1-kaleshsingh@google.com>
 <20250915163838.631445-3-kaleshsingh@google.com> <1308de0e-bb5a-481f-a447-ee4440ffb419@redhat.com>
In-Reply-To: <1308de0e-bb5a-481f-a447-ee4440ffb419@redhat.com>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Wed, 17 Sep 2025 09:49:57 -0700
X-Gm-Features: AS18NWAaVY91WPhjDqAP7fbiSZehTHu_vaxEm9l-M13vdtmPSNl69ObH0kjNDtM
Message-ID: <CAC_TJveQks8qnqTUq-tyY6VV34mPz8ZmQ9XmsDRAz0-yW535MA@mail.gmail.com>
Subject: Re: [PATCH v2 2/7] mm/selftests: add max_vma_count tests
To: David Hildenbrand <david@redhat.com>
Cc: akpm@linux-foundation.org, minchan@kernel.org, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, rppt@kernel.org, pfalcato@suse.de, 
	kernel-team@android.com, android-mm@google.com, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Kees Cook <kees@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Ben Segall <bsegall@google.com>, 
	Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, Jann Horn <jannh@google.com>, 
	Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 1552A40006
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: y6oby4e1u4uec1bjwiwmc73eobjbyyxe
X-HE-Tag: 1758127810-947058
X-HE-Meta: U2FsdGVkX1/MYAsh9F79IwT+h7bIUNvDQ9d+OI39w3iBSH89zjuV3J/NEWPGOF9kT3eKiVEy08ohBXjdBFqG/CyliHY1j+udeDfGphFtMGl0K6ITrjtXHcJdQOs+elywAv8zAK/K6/H9kOFp3YS3BW2kl+YdkpLQAtj63/JU6jb8oEPM3/HTr8CzuZijFczS7dyiRr2WcOqSkfhrc70w0nFmx4pICIRDSSnW+N5U9Tf82794yLRzno7NUqAZzeH2nL0/i1UfPITwDcax/zxrmf/hlShTiDJrPuCk1QZv7tm63TQSm4Vs/eQLT5PuYrRyzgTdm9h1ATGsd/ADh0qd3DinqV1A1CKQ5CZL+bXcGGv88e3F/TjT8UoizrYUwh5KGSOUCQY1qy6a7cAdl2VxcOP8gz4D3w7GNWyuXtc7AQQy7zgmpyKVdgkh+J7oapVL+XwjT+pW4FYh3jH0P6tqj18klXTkSDRoF/GKNJobMZeqw7mNZTUXVEVeX165/DMaEICevAcYTyvOO5UXU+wVCVEZL1to8x8xFjghxxjsMQpNRfTr7Re7sUfrgDRiwKHpjQ9J44bCIkzVuSPEbKvIhkryHMPqwRtSXNctU4iLe5gaJhNXXlRK3bLwn2346BgXlXdU5FQyFEGAcmh3RrDyEqLkWRurXLxCtxijddW78g/j+vGOqBWBJPavkDTZYs57K/0LFheht7wVjtuf4Jpru8OXdPM4L8LNJHsirFzb+G6pYguxX54IpUVTuQZkaH/4g3/SphR62FNI797WvJBVXRTphOZQVG7+gkrCDDy4fzx42hj8LeqhKZ2zOjGfxfebGzWl8uRBlEFICFUe6ehdfJ1+1w2Rf7iwnr7wLa5A5Ln36+yiDBlzyl81Np30yklVg4j77ahsy4ePiYXBH4IaQqdisWipAWqGBGTxPzOgn5WXUtkm6QO+coFhFc/m6/lDdzbbdRmTljgbwWMeLwP
 tn0Q6pgO
 SH2nBffla7thX0LCFpYCkmjEnYSev4p9oB+g6S+qfBm6HJJ6axFk5sXF2sWrxYfqQvHFcWf80D09uGiH6ICkewvLTLs+j5OWIkF1/yD5aMkFFbmm/jGJbOmZb56TgjaoPJy1gf23LGwxBt/ugaAxHOnHuBRNBZU49vFiI9NuKSJt3kxi6QYzFREagWaG9m0czF9Im8YD+y1B9nUfR4EmDTJ64rxZ3+0+QnaebTEDrimhe13QAGHU7CdQ21yvOQ0ijdAE2WlaKexNs75w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17, 2025 at 3:58=E2=80=AFAM 'David Hildenbrand' via kernel-team
<kernel-team@android.com> wrote:
>
> > + * test_suite_setup - Set up the VMA layout for VMA count testing.
> > + *
> > + * Sets up the following VMA layout:
> > + *
> > + * +----- base_addr
> > + * |
> > + * V
> > + * +--------------+----------------------+--------------+-------------=
---+--------------+----------------+--------------+-----+----------------+-=
-------------+
> > + * |  Guard Page  |                      |  Guard Page  |  Extra Map 1=
   | Unmapped Gap |  Extra Map 2   | Unmapped Gap | ... |  Extra Map N   | =
Unmapped Gap |
> > + * |  (unmapped)  |      TEST_AREA       |  (unmapped)  | (mapped page=
)  |  (1 page)    | (mapped page)  |  (1 page)    | ... | (mapped page)  | =
 (1 page)    |
> > + * |   (1 page)   | (unmapped, 3 pages)  |   (1 page)   |    (1 page) =
   |              |    (1 page)    |              |     |    (1 page)    | =
             |
> > + * +--------------+----------------------+--------------+-------------=
---+--------------+----------------+--------------+-----+----------------+-=
-------------+
> > + * ^              ^                      ^              ^             =
                                                     ^
> > + * |              |                      |              |             =
                                                     |
> > + * +--GUARD_SIZE--+                      |              +-- EXTRA_MAPS=
 points here             Sufficient EXTRA_MAPS to ---+
> > + *    (PAGE_SIZE) |                      |                            =
                             reach MAX_VMA_COUNT
> > + *                |                      |
> > + *                +--- TEST_AREA_SIZE ---+
> > + *                |   (3 * PAGE_SIZE)    |
> > + *                ^
> > + *                |
> > + *                +-- TEST_AREA starts here
> > + *
> >
>

Hi David,

Thanks for the reviews.

> Just wondering if we could find a different name than "guard page" here,
> to not confuse stuff with guard ptes
>
> Will the current "guard page" we a valid vma or just a hole?

It's a hole to prevent coincidental merging of adjacent VMAs. I can
rename it to HOLE in the next revision.

Thanks,
Kalesh

>
> --
> Cheers
>
> David / dhildenb
>
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to kernel-team+unsubscribe@android.com.
>

