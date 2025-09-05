Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FB29CA1013
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 11:02:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EADE38E0016; Fri,  5 Sep 2025 07:02:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5E038E0006; Fri,  5 Sep 2025 07:02:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D25CA8E0016; Fri,  5 Sep 2025 07:02:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B9D168E0006
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 07:02:54 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 89E7D138EEC
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 11:02:54 +0000 (UTC)
X-FDA: 83854909068.01.B8EF2E6
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf18.hostedemail.com (Postfix) with ESMTP id 906CB1C0021
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 11:02:52 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=ZZA90LzW;
	spf=pass (imf18.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757070172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lx8ZucCastRPZbjhfUxJdZGMaQhs/3NO0OJs3/5X/DA=;
	b=XcKgiz0rT02L0CfUczPnSqpYKPez+RRcQy0tXpYacqUye0ljUw6WCwtWjnN5K5a2NW0FDu
	Bdx7s/yvHrrKDuSUCTvTlgq3Y6p1G6rMQxCzrWNdTfeSNgLn13Guu3ZptaXg1HfSCQsuck
	gpaASu1+tRsyxf6P9dJWuk4xqhUTnCQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757070172; a=rsa-sha256;
	cv=none;
	b=WID6fg+KnWgjZPDWp5zzJhJNMZCZG+PyeDxaZDRNky8gXhQNhqNtRWHmNLaYO1dL7gHzYA
	N1kBF4qWa7s48iaNeQsICUfObowVvVO6K5EXKjw4zwTdxGjs+z4U9xG4U/iqrT5Q+bTagA
	jqYj6XK8TJ0xnbSgTXB3LJ7AYygQDIc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=ZZA90LzW;
	spf=pass (imf18.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-45cb6428c46so16527475e9.1
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 04:02:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1757070171; x=1757674971; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Lx8ZucCastRPZbjhfUxJdZGMaQhs/3NO0OJs3/5X/DA=;
        b=ZZA90LzWl1OyQ1WpUqHPu8ep0Mfa4hPKw/dOAvPVHOEos89mjekrYrlhnVtjyhCc+H
         9Cg1XOL0rkg70TrIWYEKR4eu5odHz7Gfnx+6Fnx20b1MLutwS25fQxnvnZ9JLXFm7u5n
         XhVhM/uE/e0FH5Uijte3dGNIZ3AvlCLdyHtSmhBqoKwXR9UxfdVhKeDl7qNqpCnZK0jX
         gd2VhfU6IPK/RY9+sdIq991m8gd/tAPyU+7wcVeMjcjGy6tUIDWVFZr7bXmTasr0BF3r
         aUcPx8ndLWM5XcXj8s7U8LcEDAcYgl6JIlucvZjZSsP8XbmHGXDA6vTV31lfJx7jBGVP
         WZhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757070171; x=1757674971;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Lx8ZucCastRPZbjhfUxJdZGMaQhs/3NO0OJs3/5X/DA=;
        b=CSEpj6qKXp6j+HY+VHnKB+XxbWx10/3CYrxELaGgaexX08QchViXlYFd7g5YfEZCxl
         DpD4agpFpt5vma6Ue0nWs4oG97206bNrJED7dNSqaElezK318ZsamxLX61pTuYVNfQCt
         +UaXYLUuMMAlthx7CGU+W1oaPRl1+CQ+3QIBrvX8QlSm2hJOs0LQhsR2+T/yd4+00G2d
         L/CtxcghZ5i9LXiHfvcsGpXe3gX5oJTCv4F+sDREy1ErBz1AVhu72LlujjgyWdZ5FNZ8
         fCThMDa43NmuNebLGH4jTkNh7B0gA7WP2z6YmBLPADIeVxWhfTXw5JIkLF8OC5M/x3uR
         HqRg==
X-Forwarded-Encrypted: i=1; AJvYcCW1a8cr5Du/tgp7595vAcE0lIkr6W0A/fu7L4LgKoqdGRVA7ivBTA1Z2FckqATlqs5azRd761AY6A==@kvack.org
X-Gm-Message-State: AOJu0YxYwsvmFCRd++qviEjXhF5dAsYmIcRtSDErDjO57qQd5AH6yP/r
	rYgNFUm7HQIb57gB3795jHGcqRisxewpobFIfZFnwCm2HArdwdrIaAqhfjGMGfS7O0o=
X-Gm-Gg: ASbGnctdb5S62ioXyMFUOpSlrF4sjHURBlcIFOpzvNZWt23ux4QsGZPG+Kn4paAqQEu
	FmNnjM1ND3zuXw2aHGPJ/6vsk7q2ujR6zMN2XWAKrsjj4wCQY7SJrx8+Yenyikh2vdp95GSKlsp
	VgSqN8xxGuGKd/9i9ebdoPuGizm95Ih5ljnHO043mfVFKRIihVpuqVci5eIQgHog8vLea3pFuUt
	tHv1rKFroh6UM7MoGui5QvLez3VEgO2Ftrlml3I+F6V8Kq3Xz/ZkFX9UZNopkS+v9cV3NbiP2Lz
	4/sZtVvOu5yMLdJ+rDncmWyXOduQAG1zi5sI0yxWSvhk4tGDad2+ycHT4QSoJrpdXZOWwtt4e5a
	llPvAQDV60N/bYtxgdtexaBSWwHjHvwHozmsIQD+MlCc=
X-Google-Smtp-Source: AGHT+IGCibdchD10pk28QOL4OPHUe28LTtT1NXXD3q8S4kHaV9mwf8QTdBlWdRFbJyNkNPfzFlnCKw==
X-Received: by 2002:a05:600c:4694:b0:45b:72a9:28ba with SMTP id 5b1f17b1804b1-45b8557b75bmr172607785e9.28.1757070171036;
        Fri, 05 Sep 2025 04:02:51 -0700 (PDT)
Received: from localhost (109-81-31-43.rct.o2.cz. [109.81.31.43])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45ddb779eb6sm9198025e9.8.2025.09.05.04.02.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Sep 2025 04:02:50 -0700 (PDT)
Date: Fri, 5 Sep 2025 13:02:49 +0200
From: Michal Hocko <mhocko@suse.com>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
	Usama Arif <usamaarif642@gmail.com>
Subject: Re: [PATCH] tools/mm: Add madvise tool
Message-ID: <aLrDWXgyvWXNj1f3@tiehlicka>
References: <20250904175729.1029735-1-kirill@shutemov.name>
 <aLqqlkTpEM1SkvaE@tiehlicka>
 <v3rbjkvckce5jck5mugtqmevtrpckr7mqxzkdel4uawuvibikr@zeqfnti5p6zf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <v3rbjkvckce5jck5mugtqmevtrpckr7mqxzkdel4uawuvibikr@zeqfnti5p6zf>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 906CB1C0021
X-Stat-Signature: umw8ags5ufe7cgyuz47yxrrk45fwbxyz
X-Rspam-User: 
X-HE-Tag: 1757070172-270245
X-HE-Meta: U2FsdGVkX18IRvTtT7Q1XFr0cmanHUs6oW9erBuNGY4TPfuvYVnBC2OnqWD+DaL/4Y+Hck6j4AJ+ii8BDrycan12gSUoEk9m3LaGpNpeKplN4Ylta/FhG6XyjLkHqAz8QEkPEIb8jAzbMATVpBRIQG1bMFqT10HBvrFIGVTvstdlD+ng4kBZLrOahrHvP78yrs80iSrRr7vF63pb9J8Pqfhqw1OEuZrHFXDZYesJeReK9ampRM1lVXfJ+J9aB45AEem33m7kExxt+VUzAeHeR0KilbL8Pt6OhrEyIjdx5vEVk8MqHTsdWJyA+BBqr3wAnoR/15oLkOESCc26fQhCCgy2Tn+5EvbMNTT8s0pmmUh2yGv9er0f3ZWKsA7z+rhlsRV+TtPzhN56VC6rBVs8IBqnPoHLJ/hii53UtxiOx4eyevAtDtbEdWeui97K3GsQMAh4vQASQPMPKVRewrR3PTQvW3QmI3gmp1ap/nWpMK4CRFrJSxgnN4d5h294NpvlYPvCrM4DSX8i0GRXHYf9r7190yi4rAw3dgy+t1Oicn4j75MW13T8jjOa9JOtCPNknwqVggKBNmgA+tnq/G10LpU6tdq8h64qrCqrjjrCYgw06f0PnwUydY7eCfMYItrn9NO9qSpfxKKbzZWxmSwTDTwL6KnvdZGFM/VxhZ2IxgjOCeTw78I/TnLDZ79qRYEgXv2cqxn6NmzIZXUwvg6zJSqpfantCS4VlxIZB2a/I9SrBKba/L83XE+T3BU0krVD2vgAFM0pjzVqgtWCt/furdkRSo1B5lo4AvtBdnjb7aief66EUKjMod2k1UX4jDMHlot2P0nRAlSzjRqWRK5o/d17/MVd6BCCM7GSmyKPiCJwk+0wvDvEY6aCtHJYQuX8V/ml/XzPggWi9afPwHpihUCDpgx2hJcuvGxC2zN6YBpb2ZcJHAUUc34qDzTlZL8VuuB3Ak1JJ6ETEGj0qze
 nIRZa6oG
 KYoFJ7FjA4CDG8+6QlygK2r3OSOULnuyAZWukcdtublQIHz+RniJxisVUyl1e7SaJCDbQPOm27xXOycuzzjPgKBEvZqA5GABq+Dv1Bebz7Rc/NBPibqlgcU8Pu1zQAu+yXRsj7IB7Yf9OlmmE8m663pNpBR5X7bktOMnN0nzO8azBxH2RMHL7Bm2TOK1/qDSqylfdVUnzCcsz0YzzHUcoSdPF/CUtHAcB3v2Ze2+u/s8qOQbsQU7IdwM3OyJmj/yL3E9At6FbRv9G3yC+K8Ch4MMZS4rf/U5/ry8d9KweegzS2Vu7MIhfHBAyc3lwmtSpMRFC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 05-09-25 11:21:30, Kirill A. Shutemov wrote:
> On Fri, Sep 05, 2025 at 11:17:10AM +0200, Michal Hocko wrote:
[...]
> > Also would it make more sense to send the pidfd fd to the tool directly
> > so that it can benefit from a racefree pid->fd translation?
> 
> Hm. Do we have an easy way to open pidfd from shell?

Not that I am aware of. 

> I am not sure we care that much about the race for this tool.

Fair enough.
-- 
Michal Hocko
SUSE Labs

