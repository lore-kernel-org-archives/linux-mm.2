Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 905B1CA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 16:08:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4BB08E0002; Tue,  2 Sep 2025 12:08:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFD0C8E0001; Tue,  2 Sep 2025 12:08:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC4288E0002; Tue,  2 Sep 2025 12:08:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A68A58E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 12:08:26 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 567D41D9ECB
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 16:08:26 +0000 (UTC)
X-FDA: 83844792612.01.2927819
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5607318000A
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 16:08:24 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ctK+17Fz;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of nadav.amit@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=nadav.amit@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756829304; a=rsa-sha256;
	cv=none;
	b=ja16vZmlQG2vEHndCPYr15+fjHgIMYHgL9ZBEmRNzzMLbyjv/d+IS8GWa6n19qIobdpD2g
	rjd2cLkjweZ8a58qa4bbA1OddNlMjGPmXgE0IoPb0S799nkczERysr/qZsKBOHjylUgTce
	g0/BW6UW/Txo58DifV0hjK7XHNvllp4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ctK+17Fz;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of nadav.amit@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=nadav.amit@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756829304;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r46homxMqyQ5zIMnJSc9KonOfrd6IbolFE+lEsE6Xbk=;
	b=xP6uAPQWkV16uy6h6X56NfwTeWUCkRMATtTYdtBxs1G33Jioh5cPuqwCL+DqHCt8irJd59
	zVsoiEynxcqh35HfmFNmN+oUPMjk67XeETiKfZQ4IEqHjlDJEBJw1IeOwYUw5rXNuS80/o
	7OACzfjWSMnTK5tq57v7Ii4O7fsP4AQ=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-45b9a856dc2so4864425e9.0
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 09:08:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756829303; x=1757434103; darn=kvack.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r46homxMqyQ5zIMnJSc9KonOfrd6IbolFE+lEsE6Xbk=;
        b=ctK+17FzlW2ZlpX62eR/4HZNOC6fpdoV+UhaVYNaC/P2+WvD/2OCs7Gv3cIeBzdFpg
         DvNN5qd7NksV10HEoEGkb7lJTzo9P3I38VIcv8Jq4t0x5dPQpa/8D3mELSNu/TIbQOkl
         Upaiu8HBl9jVrMxeE56I3McydWoMfRxUIozVdRlaQvryIvC+xsFkD1zePPYHqOFPlppk
         pZv8fQQXJcxvENmFvcDO3B/sXtDOB2YnOaYdug5PMNhvcFA3qhWZiplXu7Kg5Y1A0fYT
         rwPAs9aJy19JN4NPiw1LL028ZxWhyLLB9qQOMzJ0UUYw6XoTSDJGKE070teiXv9kHzOv
         MSxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756829303; x=1757434103;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r46homxMqyQ5zIMnJSc9KonOfrd6IbolFE+lEsE6Xbk=;
        b=j7FOkJoV/5K7+IzkXiNkZicPcOF05kw4wDZ49XtvxfcbCVjyBaIeopyT9h2tocpJkE
         Urg88bO2ytqlcUPamFnbw7E8yw5MnrH7K65Ix1QuxawyHzMy8hESHtCoxbC3RPCcrqs6
         YNvhhijU53cH0J9uhLs4VvfoECJ8lK3BZlXZStEt3cah5/HmInydOhEdBR/cAh2ltRZ1
         TpxQlCMpgV7W1/c62eJiUCwfnzi4/iiC55JeSjzS5n9VSANqQMB3zhxSSfED0fogYhh4
         NM7CKmn7q2IyFC6zeaaLLtp8brBtRpCtMcB5yoq3A51Kgg09DZJPLjEuOTsF587u7E2p
         ohNw==
X-Forwarded-Encrypted: i=1; AJvYcCUt+EDY7HRnFFHud6WZPXkeofPV5XASNnEGq7BdvVhg9wLUK5cSeyGtPoTPQZwgUb0rCgie8gMt/g==@kvack.org
X-Gm-Message-State: AOJu0YzDfz3Bq+IK6ul/Z+kLxp/uXoVua4U8ltPhSzFi607pybsH8yLv
	PJwgv4f6DwuxOXJ+/3YCVBcvwfA5mHlceLZLTC8pOVentQNEwcNsZofH
X-Gm-Gg: ASbGnctXNZYft/AARsUuBdnKntulcn/VvPxWiKoKCIceppmsnloC2g6FjeZSvU1SO7M
	+knpnyc5cJyVlxZHRWk9NHTHqPpLq5wdGDeoCgRrtY52DW2GVDQdel6vx8b89DAd7V/WKi/EYMR
	MYa4L3MHd17ozEDnE8HRa/btArwtWoB25eceGjtA5ZuM4PQIfkScecZSvFPTpMJ8itnQcJ7zDex
	WhAYEHpAwAGaIEZcj6tHbk4yRELBE9dHJhwkDltnWnNCq2L+6XbetlWha0enUlBqhzirqjqCNpM
	SchUe3204HLcibYLHq5mKGJvWO3xidvx0zEXrSo/vjln3R29CnRjgwpJKN+1cfMJmO6JoTlLKhW
	lNNeCYOGJbCN+ZAI8AbOdP4HjE/LHlWu+ISDv
X-Google-Smtp-Source: AGHT+IFoDDfuZFBxFL2nmkNRl/alJFJAAS32Y7dneDsmV1fJotev9K6MTCtxdI5juyreqyXWylIb8A==
X-Received: by 2002:a05:600c:c8f:b0:458:bc3f:6a77 with SMTP id 5b1f17b1804b1-45b855261cdmr91999625e9.2.1756829302500;
        Tue, 02 Sep 2025 09:08:22 -0700 (PDT)
Received: from smtpclient.apple ([5.29.20.116])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b7e7d2393sm202851315e9.3.2025.09.02.09.08.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Sep 2025 09:08:21 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.700.81\))
Subject: Re: [BUG] x86/mm: regression after 4a02ed8e1cc3
From: Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <913a509d-d985-4520-a879-538a1198b946@intel.com>
Date: Tue, 2 Sep 2025 19:08:08 +0300
Cc: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
 Rik van Riel <riel@surriel.com>,
 the arch/x86 maintainers <x86@kernel.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Borislav Petkov <bp@alien8.de>,
 peterz@infradead.org,
 Dave Hansen <dave.hansen@linux.intel.com>,
 zhengqi.arch@bytedance.com,
 thomas.lendacky@amd.com,
 kernel-team@meta.com,
 "open list:MEMORY MANAGEMENT" <linux-mm@kvack.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 jackmanb@google.com,
 jannh@google.com,
 mhklinux@outlook.com,
 andrew.cooper3@citrix.com,
 Manali.Shukla@amd.com,
 Ingo Molnar <mingo@kernel.org>,
 baolu.lu@intel.com,
 david.guckian@intel.com,
 damian.muszynski@intel.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <3990BE94-FB14-4D33-BEC3-07EB487A2490@gmail.com>
References: <20250226030129.530345-1-riel@surriel.com>
 <20250226030129.530345-2-riel@surriel.com>
 <aLcQ3UCXXNcByW1O@gcabiddu-mobl.ger.corp.intel.com>
 <913a509d-d985-4520-a879-538a1198b946@intel.com>
To: Dave Hansen <dave.hansen@intel.com>
X-Mailer: Apple Mail (2.3826.700.81)
X-Rspamd-Queue-Id: 5607318000A
X-Stat-Signature: wpdi1rjrp9gcnib73od48qtm8j3xudxf
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756829304-52626
X-HE-Meta: U2FsdGVkX1+eL7ddgXZ8mhBWPOsRSYMLHtCjJdWaUabVUmBb58JL6RwiGh58R4ANPm6qql+EqGZ8ha5pNM7z8/3ZtYLE4/qtzeuY2GLO/IXnMhKkNZD4zXZEaH8wlFIaWS2t7fux3rWVcfNQP9LQxRDE1M/Zyjh8dk366hMRsNydz48OE/07FRaVvqbzxMfSyjntCjCRTaIcjPxTi3sRZk/1ecemPhCpm8D+5MrD76m794eCSecxM2K8bEXU0Y+uS+OLofi29/eIr06zAhrKaZPUztJoUlwjAjCC+FrvzO/4LPRlRx2apjBNWkPiujudItoPyXd1JjDw+g6PwAlmx4PTTXLv9tE6Tb+3L904wyhs5gjOw/HOj1Mzkn+RpyJulHDnQybcnr982csWTVgrh3EOPL4ibMblrvIOb3GoWLW0iGeQ3PtCQLiqumVdtbkLsGSPQrpip0/bicg+GF/KrKPSCnRXCJIJ+UL+/f4Aq50josS0jZx8+gr/X2gRu5eJAa4a0Z7+ymr6bLD+xAqHCIz1ZQF7IVtiovF2ggn5wTEHoZGU2Ii/19z7dZlN2lFN+FaN2gBHXO3NWsG3WU7MnOfyyUxP0rhi9swmkJhCibZpI0qlUEymxQeUD13kfp6qwIEefS/GM8dVezaM3JN9STlOuZIKhFmun+dhf634tJPPn702oF0gGn6gUaHuxKpXohDM+Y6xjDpS927FbICzQBpQFMPMOS6rs4GyRIsJ9Pz/Mxp62p1OnePuXUzYQPzzle1DQb6LtKL4NYsceceTfTWrWBPUOEwRgFlTc8eUY/cAWfVy6yTb2xK/NqtmvUx4MYEG8yHwN9r97/4eduvhmwjFDyW7MGo5p7JRA1pfpF4owxtUMvHHQiFkPMygoDOcXZs3AqpRY1skvcgRwKWkCjpjnzvhGlKdh7Qord1HBj9FlLyEChJkalWVlvfzGyyUmawlysumkg8lTjh4feH
 AyO5I0DY
 jYIH+Boi296D8hicHn3HuCN101EUrKRUwk7GNpFRJddWSsAJu2V9hN/TOeGy9oAxabaAsY7J/gauveCaAHUJsWV4jAvprA+KS06ANfPiYG4LLQWYhrrkvEIhzbnGf9EDMbRVlWnoCknb2wQ59w72J2WdxXW+SYxN+OXHQWb9llbh4zO2kbQcx82POmkLxzxZohFfjp2cnlpyb7t0Kvv/80DcBeFrWmfkcTl/FdQRNkwNdZJ4VeXIYRrhbAhSKL+mkPnDMSN/rvhDc1P7QtkD4H2QtzNNmE3IobiJNm6donUZswfmj54a6RMl9NyWshsSkQ59EXs3T5/AKSIxsB5Rv3PO2Zi8SxXRCiWbX9nFGxTnnZkiPTTPRDiG23GZ22AKkde2eDK08JHqczZiBJLMXe8Gs3kJBOdARsNXPS8RhwCYFgX4PBUBrPiNkhjtu+fmFm2m9u40/oOZIh9ddsRJ6qtQmYALrj7KPRiDoP/Us9ks6fyZzM6EVxOLgHg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On 2 Sep 2025, at 18:50, Dave Hansen <dave.hansen@intel.com> wrote:
>=20
> On 9/2/25 08:44, Giovanni Cabiddu wrote:
>> diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
>> index 39f80111e6f1..e66c7662c254 100644
>> --- a/arch/x86/mm/tlb.c
>> +++ b/arch/x86/mm/tlb.c
>> @@ -1459,7 +1459,7 @@ void flush_tlb_mm_range(struct mm_struct *mm, =
unsigned long start,
>>=20
>> 	put_flush_tlb_info();
>> 	put_cpu();
>> - 	mmu_notifier_arch_invalidate_secondary_tlbs(mm, start, end);
>> + 	mmu_notifier_arch_invalidate_secondary_tlbs(mm, info->start, =
info->end);
>> }
>=20
> That does look like the right solution.
>=20
> This is the downside of wrapping everything up in that 'info' struct;
> it's not obvious that the canonical source of the start/end =
information
> moved from those variables into the structure.

Just a reminder (which I am sure that you know): the main motivation =
behind
this info struct is to allow the payload that is required for the TLB
shootdown to be in a single cache-line.

It would be nice (if possible) that callees like broadcast_tlb_flush()
would constify flush_tlb_info (I=E2=80=99m not encouraging lots of =
consification,
but maybe it=E2=80=99s appropriate here) to prevent the misuse of =
flush_tlb_info.


