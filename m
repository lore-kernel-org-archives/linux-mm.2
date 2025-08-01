Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CB53C87FCA
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 19:27:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E38466B007B; Fri,  1 Aug 2025 15:27:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE93A6B0089; Fri,  1 Aug 2025 15:27:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD7F86B008A; Fri,  1 Aug 2025 15:27:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BE02E6B007B
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 15:27:32 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 692541A015D
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 19:27:32 +0000 (UTC)
X-FDA: 83729172744.30.16F2DC7
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf06.hostedemail.com (Postfix) with ESMTP id 82C20180005
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 19:27:30 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Tg5oeKM7;
	spf=pass (imf06.hostedemail.com: domain of fvdl@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=fvdl@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754076450; a=rsa-sha256;
	cv=none;
	b=g/Zrxq5u8hh178p83G/ney+sdpIlqtg4Uv0vuMLoRB8l4vAPzUZ8w4tm8LY56aelBZJZA1
	CDPOQ2UDm+x6dVSlCNntv/YAOTQAaBWdlxIiAq7T9Q74/gqFBvUzNcM+c0ToMSpyEhwsiQ
	+a07TRoljQggjb3IZiRni8YgF3Vg5yY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Tg5oeKM7;
	spf=pass (imf06.hostedemail.com: domain of fvdl@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=fvdl@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754076450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OuqlSGEDv2/oUjW9t2xqDFH7oylxKewbkhA3My1Z5nI=;
	b=qI2AFc/AgP8MSbqfhQDQxxv13v9dMfOGcVqx5M/8ByVFWqKYJ2Q4/FyjHr9LwYSHOjo1rt
	A/l0e9yXs+f98Zgq+SLhgKzTVgOe4pmIlq4CEs1Q7eWOCVD/Luhha5R798pKe1RkFsQbZ4
	hW3tdlUO2hiZOfWy4hexXThdT46i03o=
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-4ab3ad4c61fso70981cf.0
        for <linux-mm@kvack.org>; Fri, 01 Aug 2025 12:27:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754076449; x=1754681249; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OuqlSGEDv2/oUjW9t2xqDFH7oylxKewbkhA3My1Z5nI=;
        b=Tg5oeKM785peb17IyghWG0ecYk5Nam2WQLAl8VIxujjNpZeeyMNmXQ48FhLX2P5XKs
         m0LCX8ChTwzdlIJJwN4/XPSp+BpkVSB8z7496Fv6cPmkI4MVovWTuG21Q9DsQ/CC81g0
         MCP6t8lK/ZW9LU1sE7/LBLwqpX9xdyWs+v82PDqL/3Uw9VWZXSa7N9SN2xU2n5gO1YqR
         oHJJ2csIsn6nWIA39KsokQDspLkZ8sezucJIxs5kf2I1LkISXU5wo4T2F5pMVRLSpaij
         sTReYLmgcSsiIWKjAg+pWk9nve/g1DjuD3GMHsI9Xe4x20VrLIQQs2bkR7EsoFoW7rja
         L1CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754076449; x=1754681249;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OuqlSGEDv2/oUjW9t2xqDFH7oylxKewbkhA3My1Z5nI=;
        b=pOn5ugqjwYW4Wvcs6YU2MYjgGOnO8iTmHjuSsUzaVV+KDMhgkg7awTmjlDPXbfCnny
         EX831nkTMOFRLDbQJWlJjY6fzU84JOVbrEvuea6V00z+HIlTEdTCFfB7oemWoRk/OXVR
         F/9M27thHjdpAdcDM5GgseGyCrbB8jpPuAyRJ9uresGf6rfkRoCmpb6lIqWSImhGXqLY
         0cxFieSyusNQaqoSRYvoEqO+nqQVeLSF4hNPtDiLyx94yl2b116JO6+63DZTGQGdwp+B
         9yC2INBI+I+aiB8AVMqr6UyssUBAgdu/MkEiN3lgXIBZSDEdTMmv/uM8wowdcrYQDT+l
         DqBg==
X-Forwarded-Encrypted: i=1; AJvYcCViSdxDuVfDC96UElGewJZzJiV/Jyv0kItfF/NNl+KQs3KwRdG1zLao/17iCV6Sqw39S23u3IbU/A==@kvack.org
X-Gm-Message-State: AOJu0YxrCsXOg6kDE5YIvGEw9TjOJDPeo/jx1vRagCfJh4BeTGuEHxxS
	6W6ohUfC5eM9rYv47U7CiTbWW/0Co2HQdbrrAf+u6VEw3jNT/mWbnjcvAPZmO1VhX2ZJNLkoRmU
	QIhU6IlIEVmt4JCK7rEl1tJQj8l0hRos7FncrWnwD
X-Gm-Gg: ASbGncu83abUiyise0jyOCjSewJavuNPEtZzuNGravHo3bU8WZc/2r9cI1h8Fuax6b0
	f1AC38nGUPzZR5TDsk+yEiPeOZRguw9DmqHkGoUCtePGEUoVlpx+MpYxEZqxsSiHNSPV1xhJERt
	8t162WGhui9A7RIJNOpuDeqEsfckKpMGWpGY1n+XWY2o4rJbD5nUIWax3xRgKwQVvevKWV8Yd2t
	Rgl
X-Google-Smtp-Source: AGHT+IH0VEOEQAyWFcQ0xV2ZT7OrVMuc1+AZpJfbGSvNuR66hHX5BBVvrOqBcWVb23iUeJDFLxG5aetjHtJi2Hi8vUQ=
X-Received: by 2002:a05:622a:180d:b0:4ae:d2d4:21cc with SMTP id
 d75a77b69052e-4af13172de5mr492761cf.3.1754076449265; Fri, 01 Aug 2025
 12:27:29 -0700 (PDT)
MIME-Version: 1.0
References: <DU0PR01MB10385345F7153F334100981888259A@DU0PR01MB10385.eurprd01.prod.exchangelabs.com>
 <CAPTztWYf82p6hq=Q2mVq6_9WTjRaQiH81z4idZL6MZ1PXufPwQ@mail.gmail.com>
 <71df781c-3ef3-4b26-9ba8-93fc7d4f9eec@suse.cz> <026de9fcd4f0ed17c2df95c4f7c56b878a844012.camel@gmx.de>
 <25ba0d77-eb61-4efc-b2fc-73878cbd85c1@suse.cz>
In-Reply-To: <25ba0d77-eb61-4efc-b2fc-73878cbd85c1@suse.cz>
From: Frank van der Linden <fvdl@google.com>
Date: Fri, 1 Aug 2025 12:27:18 -0700
X-Gm-Features: Ac12FXzjGpgSr_bPfFHhHKJ5h36qLMtXo5c-DKT7XqzqeuIg36gVpgqLIjB0Aq8
Message-ID: <CAPTztWZpnX1j8-7yeppVUsxE=O9hbVeqricDjZt8_pnN7a-kBQ@mail.gmail.com>
Subject: Re: Realtime threads delayed due to kcompactd0
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Mike Galbraith <efault@gmx.de>, Alexander Krabler <Alexander.Krabler@kuka.com>, 
	"linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	Dennis Schimmel <Dennis.Schimmel@kuka.com>, Daniel Braunwarth <Daniel.Braunwarth@kuka.com>, 
	Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 82C20180005
X-Stat-Signature: 7c781j4oqwh4fhidiu96oppndh58tct5
X-HE-Tag: 1754076450-211367
X-HE-Meta: U2FsdGVkX18OuCJ0umNPPfm9jLRhfS9r2AfIWc7Z2Z7hLKL7Ih1w+a7HKvdeWFJJDKlmq+LXLSgnpjaqkm3lg383FLSqSFXcY/TyroblsNzcaO6ch4koPlwQoUpv/4mYt3GY4GZld2QEb3UIy7JUaqEvB9sL2itF5crQ9iU7mjNlWpzg6W/KJ8UVO34FVPASjKx3hh7kDcITCTM1rKHdRApKn9Ymb0D9ejBzfTm8EIwXY9B1M7FQZmdyzYIRYgSxGBGiAj9Aznry1OgQtljVeQCA8dN8gTwYcEyN/cKWO7rlMrqe7wJGSG5uw4apykaFTgXNjGxQ0MN9vKamQOIeNewvWqI2Qm8RoXaqnqYcMD5jSnLFK6Io85uEL0L9JNoJ71IhbD8JsxIulO+VTl6FwEGSdF9Mpcn1OsYAs64NZSz4riuVtPZcMFkVn2ZpQ4HHC32iPcSz2SCGGiOMuBVJVGPi0MeUeRIZkzq3UJMMgmn0uWINNmf8pPxUm0sy1A5HaPIMVEA+OJrptG6ldg/Xnv+5iqnIPSpmh0t4aXT1FCJ0//h7Oti4IDl2b4qJ3jYxy6AGNANyeRhyEdrO4AeNc/Ad9cir/aJf6n4d3by62YuW01q+t30EbnugEsl4EF/Ar5de7YQsFqFufJdrd2LCMm77j+dar9gRtM0JB0QTVryP8i1q94tPXys1PNDz3hlmi3d4Jg5/0oN1EkokonZQfg08ddHOHPA8Z8PHlfXQx56QsWyMo1qAOe2SloKwOa+Bk66w0niGAs/MyHjuSIr6bRSBQS/fxOaasN697UwMozsa0ms/gFhxJt1IMhhaqytG8hKsH1GQsDtju/7ly7JllUFfDHDu+iRWT26c4flkAtXxOgO4CaiI9ESsHZU20NBTJcEMt6INFf6+961J9AGSn3a2G00k+QIQCMJm5A091+njijJKE5m458P7rNLj1V3WqtIwwESM2gkmue5lcZs
 CuWO4qup
 rO+eA8LYIVuUAzHFxO/YbdgZSeo8Fm2y9Z09BMKcJSc4vJ48NpTohHBpOMGzaLqL9nGMQ8vy5qwWs4BQoS5BH080BoKZY0cURTJKQpne3TwlHbNGAsMQ5AIgWDTy51vBFNwjWwzzFJv5yyzoVFh94XyQgB9fDBLKEQ4jpYUs/xQIOv8ckGBl3TjOgsK7kX6B1/upSy79U8zk9W8SsV/DzCIErCZ5dCtPkDKAFuShTZurSYGw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 1, 2025 at 2:58=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz> wro=
te:
>
> On 8/1/25 04:46, Mike Galbraith wrote:
> > On Thu, 2025-07-31 at 20:41 +0200, Vlastimil Babka wrote:
> >> On 7/31/25 20:34, Frank van der Linden wrote:
> >> > Not sure what the right thing to do would be. Either explicitly boos=
t
> >> > the priority of a thread temporarily during migrate_pages_batch, or
> >> > mitigate the issue by dealing with 'busy' pages more quickly in
> >> > migrate_pages_batch.
> >>
> >> There's a workaround for realtime tasks. If you mlock[all]() their mem=
ory,
> >> setting sysctl vm.compact_unevictable_allowed to 0 should exclude thes=
e
> >> pages from migration by compaction.
> >
> > Hm, per documentation that's done automatically for PREEMPT_RT...
>
> Oh I see.
>
> > On CONFIG_PREEMPT_RT the default value is 0 in order to avoid a page fa=
ult, due
> > to compaction, which would block the task from becoming active until th=
e fault
> > is resolved.
>
> So it's probably the mlock() part missing since that should otherwise app=
ly
> to kcompactd.
>
> > ...but rummaging, seems other stuff can step on it (contiguous alloc?).
>
> Yeah, there was time CMA was just something for mobile phone hardware. As
> usage increases beyond that maybe we'll have to tackle it. Ideally by not
> having mlock'd pages in CMA areas at all. And if contiguous alloc is
> attempted outside of CMA areas, respect the sysctl there too.
>
> There are also things like mbind() migrating pages for NUMA locality but =
I
> assume people just wouldn't try to do that with realtime workloads.
>

Another idea is to minimize the time that a migration PTE is in place
for an mlocked page, Hugh (cc-ed) mentioned this in an offline
discussion. E.g. skip any mlocked pages in the first pass, and just
add them to a list. Then, do that list separately, but do them one by
one. There is somewhat similar logic in migrate_pages_sync for pages
that might need extra work / locking.

Not sure if avoiding mlocked pages in CMA would work out. I mean, it's
not hard to implement, as it would be pretty much the same as for
pin_user_pages: just move them out of CMA on mlock. I'm just a bit
worried of scenarios where the kernel might run out of space for
unmovable allocations if you have a larger amount of CMA, which would
be made worse by moving more allocations out of CMA. Then again, the
amount of mlocked memory is probably generally small.

- Frank

