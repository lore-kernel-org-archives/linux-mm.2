Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1471C61DD6
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 03:09:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C920A6B0109; Wed,  2 Sep 2026 23:09:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C69DD6B010A; Wed,  2 Sep 2026 23:09:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5ADA6B010B; Wed,  2 Sep 2026 23:09:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8A19D6B0109
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 23:09:51 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 14B65140408
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 03:09:51 +0000 (UTC)
X-FDA: 85170971382.09.19B54E2
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf20.hostedemail.com (Postfix) with ESMTP id 443511C0006
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 03:09:49 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EEnQ4d33;
	spf=pass (imf20.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788404989;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8tVEuaDvVYMx3YWb3gYXxXJkBsoqezd6deCcOB4T/m8=;
	b=wu8Sek21lxqxb1amKrMnAX5Mi47Ji6e5EZWohMhRE44bKm0E94+lacypVqXy4+ZAOt7l6r
	fFREATnoTnLbUk47IBcnnZHcwSO4h/veFRUYW7EyCqJlMkOWU/THFqeHUeh46hdTppENcq
	uURYBe6TVikiM/zM7eSe7BPogOP/t3I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788404989;
	b=GVX2qIqj/DC4IBSEeMI1bjGSbiCQyLUb/HSdKh0mnH/KDoiCR0ogLZNiopMnEmBex4X5om
	TuJeUHM2+yHs7tFiNs5CL7xO/bxK6uR17pw07xUOlGamUBcN2Ojq5Ir67qU6rdXA9U4Kfn
	l0xfhMLieD3ystMrKweAq2yajF2kMrk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EEnQ4d33;
	spf=pass (imf20.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2d715f4a587so28332145ad.2
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 20:09:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788404988; x=1789009788; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8tVEuaDvVYMx3YWb3gYXxXJkBsoqezd6deCcOB4T/m8=;
        b=EEnQ4d33ce1owDcFf7mlgt33gNg5IBUtmvu1/hjfZM+SKeISNYOwjS5rsup8LDJjTF
         0c76oiyZCVFgt7SzEn+C32G+UsU4KV/OYx56ChlYuO1ok4BdG4eWbVBY4EOPvKb3mu58
         Sh0+tsPjeH43XFc3fP9fh9V4ZS+kD+5bqXI8ygoYotnNhL3kHwVUGkYBAGko/0hQ8G6g
         pIN+isl+4jcmzbCFYC3Q+f1+S3+j0AlfH2Nw5u7M0mtkY+bDxIgYRXxcp0zxGJJQVzlA
         xUfpFYUG5J34dkjoNcIiA0iXO7KqQV4HMUCe9u5baeiseI9vCWRlMwXcAvtZTHd33OT4
         Ii3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788404988; x=1789009788;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=8tVEuaDvVYMx3YWb3gYXxXJkBsoqezd6deCcOB4T/m8=;
        b=M/zgPo8aHCrE/FIjBw97OxnJx7r5EFt73rMZtz705xZVOrmRm2vrcxBH7wwQXahxw0
         TcGW+GimiKhgBZfdC/e6FkXdXZEbYn5Kmo72lcYiNJIyr37B50hFTZ+kbdm6QqEu/te8
         rCCX48eg8ev2zioPhYd0hGVEv9tPQPLU9IU7svqJUNrjzsuOnR6LMuUwFAkVktsy78iQ
         y6rk0RDEpyfZOGs1N/Bz3I0/xBTT54sni4Jha0xpSX2FoaGpo5LTek1ZUtxgWxah5bDI
         zo9Q77Jz+dRFCXRUpVFrZX2zyQtYhZpY+ERDT0AQ0WQFZb7JdlKTtYcb+t72t3gPyJHJ
         gN4w==
X-Forwarded-Encrypted: i=1; AKwUvBzm448OQ5D8ACdpbtGZJQpz6uHieJSGU1x4puqSKo0m19VvZKI1Kxi+pasrHQkr3RNGcZ/WPYm25g==@kvack.org
X-Gm-Message-State: AFuF++lPwZA/Xs4Y49RjL+0MDqupAjowz3Rym4ObfW4j2/udDs2wdtfj
	A3GQdDBzw4LCb/t6pnMteHURINqR2rb3EuAWORS9I6hJ+jkgGh3N6LWj
X-Gm-Gg: AYBFou2EHV/iCZnmHKeLfFO0M6kBwUSNlWtl2EEDk8+o4J5jVA6Dpk3y9CBQqxFMQl1
	Whfd9M6TT+l5GGhd6pQXHMtwK1tAzgwIspgTeC5z0hZQTr5jtjFc39aJHdespcn2FmzD09nNVY9
	4xqrToW3GnA0vUA05yuh9M4uogD/WRVhYhW38yFWNN+BeXUR8XKt/DmLc4SsPg22FR4C9wf9Rke
	UPIKIdFWX2GtnZs9YxQRJ+nwDFjt8jc0GGTTyczARN/+6PZLVBhOsX1BxsEqPUuBO6QYMloDX14
	LI2aFX0FLLquM2/3Ypifu3kQFizoK58twl7YqpHJTO9rW6pmiQKldS+EAumB70OePGEec+GiF6N
	OSySM7iRT+W+QLcm9JA3qNOlmMNUMpNNpmSdOj4zHi4E0QJXJmrFZRir/SFPfp4jbCpz1pp49Uu
	PrwgV4SDOceXqynx0WZwMRP2qFu+wy6+SndZyV0c9Uwc6sgZGZ0D5rF7sscfM=
X-Received: by 2002:a17:90b:2cc8:b0:396:6344:3b63 with SMTP id 98e67ed59e1d1-39aedf8b4f9mr15154792a91.2.1788404988029;
        Wed, 02 Sep 2026 20:09:48 -0700 (PDT)
Received: from gmail.com ([185.220.238.35])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39b08bcd243sm2266519a91.5.2026.09.02.20.09.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 20:09:47 -0700 (PDT)
From: Kunwu Chan <kunwu.chan@gmail.com>
X-Google-Original-From: Kunwu Chan <kunwu.chan@linux.dev>
To: SJ Park <sj@kernel.org>
Cc: Kunwu Chan <kunwu.chan@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Kunwu Chan <kunwu.chan@gmail.com>
Subject: Re: [PATCH 12/12] Docs/ABI/damon: recommend subsystem doc instead of admin-guide
Date: Thu,  3 Sep 2026 11:09:34 +0800
Message-ID: <20260903030939.336002-1-kunwu.chan@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260902054747.99370-13-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 443511C0006
X-Stat-Signature: 5ttyhz9wagbubsrfgfhfsnpbkxexo7xp
X-HE-Tag: 1788404989-794391
X-HE-Meta: U2FsdGVkX19O1uq6mLXLw4dRXda73TO0cS2yjvTXu8x09Uh5qOOV/CuhqTX+RjA45Pr66ANwNVoIFWurAneQz+Ko52qWCNLxE/2+4XWIB/DoNgsT5OYaV+fMW42Bh2DqgPH+/y6bbvQEFneht56QC7KNrqWne+C5xhRPgPKFMbSYcZFFu6c6nKBrmDF/SSpAIjFWKQ4LC1n4dufNokEDvlSYZrAOfRCHJHESUIQqc/O9GI92j/CjwuccFTUpUcHEbG0aMqF6KhTUYxoy7uQuMp1KpI8EMwxQGs/vNYqbVzBbnjFmMMPkuj0FN745YxRo7/D2h4CqgwL6y2hxms3PVnUlSDRqkhrGImI3hRn6ofQlwlTvC0E0sywPMrX0Ddin/1fZOMhrn3XbNyWPusz1qOSnckou3o/lygJxB7E/Ln5gW/PML5FmgHvOi/LkX+s8107rVcTXC2sF7T0l7LL5JC4gpyd3DceMsoFmYNGCqFkv2qCoQJTCjUsnm9Bwvh8F2lfSwOHhEvd0NMERPhxdElLTVaNlv8UtJFnnZndmi3va3IVBzRIKfHl5/zWNB4MdzIChKp2przXuIslYbCKkIxUnYD0VTzCJK54e7h+sWvwYrT90jDFanFPgaaezaD1SuGqEcdAi3cXIlC7rg/csv1DlAER7pYHYiZTef1fABunVbp7ajwC6iywhl76PrK6KjmyEdnCy+LKnKEoVwncIiigfgJTt/hyyHOfx9ArnBKZrNwKHYpR41IPLBbU4/N1Acy+ehqeKlbcH7zpO2nuEtT9UN000r7jLSK6iMeEzaRYvxpdC8zqIjxWoIgdLTBf15x4pdPIJoCZ5peji+2PYrcqbZ+8ui45/VStqxsWFmyE2e4FKZbC82d3F9Jlf5bftzxb6FAAakOhJyZsnE486j4gSlyuosD4tmUKpUj6Vx2Ql9JlTtsvgQhlI3bsGV+wwihSNBS5rRAvtNPmpgdP
 hwlKBlvQ
 YFryu+p086CLVtiA6l0193h+JOV0pOsGuqpdCvskIc9GHoJG/QSwiL9ZNpFYQJn7dUWqM08jPnKOF7qbfi2SZ13VUCNrkYyTQmeXEaxnWRrNhjLYn9+0DDk86QZ31ka9stm2iN5Xe6GEHNjWifx/JcpeCq6rTvKJYWMIpHLEGAMJ80ZGnXDKChabUc0TDSrTZenHC58MvK9EUZ/qqlYUGeKn+ZyzvuaJ4F0iM3siz/PiijkMaMLgFktQ1H11sR6/DCIHExHZE6Y7GDjGlaEu3GJ/pkr5Z0GlR9CqKYyRS/f/0riK+MzJcVlIYQdt14eQ+i6uBd/BnWm2CCHT/cDTR324dIOK2eJY6x2sII7bJPJN4d7iFdrjI4CJVDtDifBQqGkwnVDFF4qCe8aN3PijHmynhYSnBnOiiXwEmR2WiGXH1ul9Q20hp+o6suFzbR3izvRBt3VVNXRhAwKU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue,  1 Sep 2026 22:47:45 -0700 SJ Park <sj@kernel.org> wrote:

> DAMON ABI doc is recommending DAMON admin-guide for people who are
> willing to know further about DAMON.  Nowadays the subsystem doc
> (Documentation/mm/damon) is a more recommended place for even beginners.
> Recommend the subsystem doc over admin-guide.
> 
> Signed-off-by: SJ Park <sj@kernel.org>
> ---
>  Documentation/ABI/testing/sysfs-kernel-mm-damon | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-damon b/Documentation/ABI/testing/sysfs-kernel-mm-damon
> index f8d2601e82904..ad21f58f3c912 100644
> --- a/Documentation/ABI/testing/sysfs-kernel-mm-damon
> +++ b/Documentation/ABI/testing/sysfs-kernel-mm-damon
> @@ -3,7 +3,7 @@ Date:		Mar 2022
>  Contact:	SJ Park <sj@kernel.org>
>  Description:	Interface for Data Access MONitoring (DAMON).  Contains files
>  		for controlling DAMON.  For more details on DAMON itself,
> -		please refer to Documentation/admin-guide/mm/damon/index.rst.
> +		please refer to Documentation/mm/damon/index.rst.
>  
>  What:		/sys/kernel/mm/damon/admin/
>  Date:		Mar 2022
> -- 
> 2.47.3
> 

Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>

Thanks,
Kunwu

Sent using hkml (https://github.com/sjp38/hackermail)

