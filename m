Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD91FCAC5AE
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 19:17:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1A978E0008; Wed, 24 Sep 2025 15:17:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF2508E0001; Wed, 24 Sep 2025 15:17:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D08AC8E0008; Wed, 24 Sep 2025 15:17:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BB5018E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:17:27 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 650DA1A015A
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 19:17:27 +0000 (UTC)
X-FDA: 83925102534.14.CA63F71
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf21.hostedemail.com (Postfix) with ESMTP id 790051C0009
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 19:17:25 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=J2u6q82c;
	spf=pass (imf21.hostedemail.com: domain of lokeshgidra@google.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=lokeshgidra@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758741445;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i/oQJGNV1ovbEYyXr+Q20w5HwOCKHZUJ7HSCX77QoG0=;
	b=NgyqApg6uEdhJmjlpgnH7+NWvght/jwjdMKPLn1y+/O5jPzrpYhHDlt5aTCjx/qDmf6BGm
	MZUsR1edFzgA867LNxgqL1Qeo4nlIPiAAz8NLSK2fxzTEh8J7SSoSYoMgZqP2/ksphuNoY
	X+2moUJkHmi5XkuNQsv6BppUuuNNBhg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=J2u6q82c;
	spf=pass (imf21.hostedemail.com: domain of lokeshgidra@google.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=lokeshgidra@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758741445; a=rsa-sha256;
	cv=none;
	b=1apxK+OVRKsoNm8C65VamoHXlZfmuU2PgMShgLelC+yuZUcaZqtxyjLwxVPqdBdQkB2n8H
	PKjTHQYtQ0iAUmmc12MpKP9aq9bAj6NOsWjpmbHktk/hDr7KS/zdhg01wVVgKFAOxhoSa6
	XAIgFg9PIUIJB5uMBdzGQXqFBXYhmRI=
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-62fa84c6916so16536a12.0
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 12:17:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758741444; x=1759346244; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i/oQJGNV1ovbEYyXr+Q20w5HwOCKHZUJ7HSCX77QoG0=;
        b=J2u6q82c4TOOgkqzNo+sQrkS9d6AJ9ShINjlIhOf9RAXBlGIfJe0/HcfhI+wzLkC3O
         CeHgXlrGZcEJg5i6TXyRWlU3z8qGDGQII5NV7uaeOQ62YYB/q8smwYNtsokHbSrCLeRB
         +62v0vZXmfViMxtDzovaMSNV2+0zhfgEJckK8Csnatmj+SD1UoHdVRAP4aEPVwADr4fc
         d3G4k9hbA87zu96lvdD5qblMMSWDQP44H4pxscqFuBxDXwJ9lE61XXEhCX8pHm7+AiaV
         yRUXOkHCIB7Dd7pGyGZMLsMZXhbdxbHBUsKc5Xw0220B8LwUK2QZ/ovlUAYXhBUguyIO
         xJvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758741444; x=1759346244;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=i/oQJGNV1ovbEYyXr+Q20w5HwOCKHZUJ7HSCX77QoG0=;
        b=a4K/JBcsNVVeuRBdpWg9dsXqyDiFgthfRhywRY8m/quPSeI71pE7WbkKMuUmpwu5kV
         +wu5slh5ecXhWHsfos0v3kLGZ0O1CEtxeQ3tZWT7sL6wYLACT64501w6UnCqf25jX7pz
         z/3GxsmrZllMG7dqK5BOpih10UD59ldL9FE1Zct+jOVTmr8QFzcVLgb362a2cjoqas7b
         4Mk/XKdhIbJq7Jsd5gavDxe4993tziEisAg/vdCF1Ud+NQPY5d/33ST1ALjKoL7GdDSD
         XTh/EoYi77qhCxnIzkOnGFmXoqKn5kTDjj0crSoUDs19SUKywVp6iMmmFZ/pGVUB0IV/
         nFMQ==
X-Forwarded-Encrypted: i=1; AJvYcCXJeP50DUJFmMYEPaMayOOBPGyXnbGcybTBbS72oSFl5GbdLBMebM/zhT1Ub29sOXWXaKCbIfiACg==@kvack.org
X-Gm-Message-State: AOJu0Yz7eZPqdXyr6fkojtgfeUDco4j1liYfFibNlta7R+qpNJ3Jmojn
	0Ul/1mzCKPHPFvbYASttVSTJq4zJC89QqdfE6g/JXXEMhG+BLHSL0fSRvQnXvQZSScvkSxSDaLe
	UE+ZHoLTIg8UQG0pEAs5Ywdbr3cTzbrQwhvumyI2d
X-Gm-Gg: ASbGncs9c7jHxT1oKSHWRlrE0TBGFCjxXv1gvF5POTvEbT3m4i88Dwd9UfaS++uCEVl
	CuaDNVYBclx/DMUBkM0IvXvw7N/tQpnhBJOZ4bGVW9GZuIeLcCC5qf0GLmfI2toPtd8UR607cEX
	5igbtTx+bTHvCE9tOAHdz0RpiQWlZkp9SnvchtXAbEev5Glf/scvNTJJHoAokIrRJgqZi8skHLU
	W+Rx2R1lD/zFfwaYBoVtgEeMTlRhPciUjrmSOdiBTZu
X-Google-Smtp-Source: AGHT+IEicMXXtlWGyN6G7V+npJLewUO9XO8YiJmcQ+jrZ8XvJO05E+8ZmlyznHeCsCR1BvtDkyC40A5meCL2FvxyVw8=
X-Received: by 2002:aa7:d4ce:0:b0:62f:c78f:d0d4 with SMTP id
 4fb4d7f45d1cf-6349bc5d2b5mr36890a12.6.1758741443542; Wed, 24 Sep 2025
 12:17:23 -0700 (PDT)
MIME-Version: 1.0
References: <20250918055135.2881413-1-lokeshgidra@google.com>
 <20250918055135.2881413-2-lokeshgidra@google.com> <2c9df5ee-6109-4fa5-b895-ad8e47d34bee@redhat.com>
 <CA+EESO4h-_U=Xo3x0G_74t_qJQ54AZ4Qd2Ji437aMV8nDZ+tkw@mail.gmail.com> <5549ac3a-20cf-4959-ac53-0a89ed0eadd2@redhat.com>
In-Reply-To: <5549ac3a-20cf-4959-ac53-0a89ed0eadd2@redhat.com>
From: Lokesh Gidra <lokeshgidra@google.com>
Date: Wed, 24 Sep 2025 12:17:11 -0700
X-Gm-Features: AS18NWA_yx_FbzE9Cq77Vt-Azas1zBBSMX6lJsRJSsjkUoBpj9SIA6zlW2o2Yik
Message-ID: <CA+EESO5e0gupVfM9NgWqx34oMRk1jGzsNfM=X3idPKaXkRL2fg@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm: always call rmap_walk() on locked folios
To: David Hildenbrand <david@redhat.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, kaleshsingh@google.com, 
	ngeoffray@google.com, jannh@google.com, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Harry Yoo <harry.yoo@oracle.com>, 
	Peter Xu <peterx@redhat.com>, Suren Baghdasaryan <surenb@google.com>, Barry Song <baohua@kernel.org>, 
	SeongJae Park <sj@kernel.org>, Dan Williams <dan.j.williams@intel.com>, 
	Alistair Popple <apopple@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 790051C0009
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: hes1morennszedkwe7qxj8t1835whddy
X-HE-Tag: 1758741445-308047
X-HE-Meta: U2FsdGVkX1+HU3bb4HS1GzF39Cvn1CLNyGpj+ABfLG3URBG7C4yP7jreeuQnURQ4LHCSmkINZDmwAA/wEARxmejj+2+bFQQLZbWqYeVAhhtjlZPY6IsKCEemhvmBXyCn+vKqDrAM2OXizGQit02rs7HQSCLiULPg2Thh7/IxRfqOFhIbUhrCg3XfVsvMwVzIve9qlLuO7ab6nwmzXStbvMzNUoB+L+JScSmvJ8wfIyb/6dKCTVVeAsXER5gZdpOJyLfuiUg9KVwU4mTRPZ3eCt0ymWh6iCXXpeJYTXBJqzvnRRjdjV9oW9EvQ6AMSQIGdDZ9QfMC8LlncIxz9g7BZcwwshfVqNPXfQzZ73VVJuFDWqEOBIJ6IqvVFxHMQKwGgxsHtAV6e4YHJsqaxPF0XSvmaKn9M+xi8MEKHkugpiV1sqlxoe/D4vrac+5FfE06Um+qZch8rHkPCgHgiNe0ib0a3xNZtEkxk8iLWA4fc1BvD8N9KQQumcJ9Z8Oa5V8ZF3GMDDUxq+O8hO+/RNO3qRIiuVndpwJMcw9EnKs3ydIlXm4mWJ89oM+i4ebKImfEkpRfPWcmjcnq9jYtDQ7gDTy9nm+6K+CIqbYli0x+WOqndoBT0GW2ZPWY1Mu2kXtzwWwl3ATUGZywyZHqLJpZLuslQ/e3SeVq3hnT6nmHy/BtBFPkQEc5wG139yJlNuk+K9cxiIq1oH/CVCLv24m+Itmjh9Z55t4swtSj+AUGqYhTZxVvtMk4S2lTe22l7/qVSpeTv9WB9uIS97rYyrBc2dV47eXGm5jLW/cR6js5z2oxBQhrvuuSteXuzrqWYrds6mbHwIjdgXGftJJBVMJNRjs0M2zKM+SGmVdSiSxDqIx3/EvImU/hsEBeVPbvNQoBHU7PTfTMzJ3E1Ag9CioJmsqb6n8cKQAs/XiUOckgL88Liebv73on9mNSTWgBarKBjgoXeLJbc0NH1yqlDP+
 kP1T9tkZ
 /7dWRnwbARCCbSB2BclzFnp3IYVO8oNaGdPRYA44KFfFntHvij/OGreg24hJcLuB3V/kbAB5Kjj5qfqb15YTO3tD/MldbIheFn1aIE+rzakegGn1rCQoTlzJ53zEeBZL/Lb68OyFjMtP7V685XC2ZdlM3O4xYKKBxqZ8WSqo/Z7yDuvvQkl3K3L+5JGcf8D5b8AwUNv81D/i0dkexEHeKkboO7OIz5e2GL8WZvT58+nYfQ2FtynB1bawY4QDKrSec8LiQoVvzQ+1B/ZY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 24, 2025 at 3:00=E2=80=AFAM David Hildenbrand <david@redhat.com=
> wrote:
>
> >>
> >> Is mf_generic_kill_procs()->collect_procs() problematic?
> >>
> >> The dax_lock_folio/dax_unlock_folio part confuses me: I think it only
> >> locks an entry in the page cache but not the actual folio ("Lock the D=
AX
> >> entry corresponding to a folio")?
> > Yeah. The name dax_lock_folio() gives an impression as if the folio is
> > locked but it isn't :)
>
> Sorry for the late reply, I saw you posted v2 in the meantime.
>
> >
> > IIUC, a dax folio can't have an anon_vma (folio->mapping is actually
> > an address_space instead of anon_vma), right?
>
> We have these weird device-private dax folios that are anonymous and
> should have the anon_vma set up.
>
> > So, I thought it wasn't
> > required to actually lock the folio in this case. Please let me know
> > if you want me to still lock the folio around collect_procs(), or add
> > a comment?
>
> I think we can end up reaching memory_failure_dev_pagemap() with an
> anonymous dax folio.
>
> Not sure if anything would prevent us into calling
>
> mf_generic_kill_procs()->collect_procs()->collect_procs_anon()->folio_loc=
k_anon_vma_read()
>
I must be missing something but dax_lock_folio() dereferences
folio->mapping (to get to host) without checking for
FOLIO_MAPPING_FLAGS presence. If it were an anon folio, wouldn't that
be a problem? And then in collect_procs() we obviously check for
folio_test_anon() on the same folio before calling
collect_procs_anon().

> CCing Dan and AAlistair
>
> --
> Cheers
>
> David / dhildenb
>

