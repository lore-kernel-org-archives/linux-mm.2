Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65286CA0FED
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 10:56:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BDA18E0015; Fri,  5 Sep 2025 06:56:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96D328E0006; Fri,  5 Sep 2025 06:56:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85D168E0015; Fri,  5 Sep 2025 06:56:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6FD288E0006
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 06:56:30 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 223AC1392C3
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 10:56:30 +0000 (UTC)
X-FDA: 83854892940.14.CFFBFA6
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf24.hostedemail.com (Postfix) with ESMTP id 332AC180010
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 10:56:26 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=MijrOyM3;
	spf=pass (imf24.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757069787;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QjsU1N0XRrRnM8naRkACSYSwdOlKjw+PQpIIkp+9bj8=;
	b=WvZVD6W2+Y5A7O0RTKigMQaChBNm+Dh0rIexyygBVWYEyJl+DPrOULLWF+MjDbGliK3T2W
	E6YBV8A4zL1MmufXlY+m68QGmq+/xzqxn6rJT8gvUSOFVQjDVnfnqqmjds6c48JeUeatSB
	078qrEBezBJu6Ad5IB7TyWVPYPBeLJk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=MijrOyM3;
	spf=pass (imf24.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757069787; a=rsa-sha256;
	cv=none;
	b=nY92uUbdKmWlrX8MaRdsCkoA7yU0N22+OJg90J6sfrBua/G6jCitTUiDHEgNMAJ+oksu8q
	wBk5jUnJPsI8ZxwaMedMHj9dSJ23fNm1Z4VeCts8NaLPrGYzDj66zwNxze4HdYuxLthSUD
	LVPC+juao43jVOs5sMVrtT6r+XK4qo4=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-45b8b2712d8so18286875e9.3
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 03:56:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1757069786; x=1757674586; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QjsU1N0XRrRnM8naRkACSYSwdOlKjw+PQpIIkp+9bj8=;
        b=MijrOyM3iiB3qJc8cvWEI4VrvIS0HrGWSyIK75nLWnbNMa/1KPLKZZ518VJzr7+iCF
         4DYxsDlURYwWy5ahDWzGNwQRfyM25kSO7vcNcX5ZuXwlMIeTHUtxZJSlQZCPnBtxPLU/
         CCZ0GylS2EG2dvort1oXRftqtX6dGqee+6Uj04d1pzM+QCWUpdd+K6FjiLqyc9sJLF/G
         KVpzom0xAfwKD4aDE85L7t5eLSDuK08kJrug4qOanOQYJoe5/MRS2dy4aB48/+byANEL
         TFC1iIEcrtnnbLcIMNUaafLSxAfCLWBMbueEmmzWuGOxRCRiOm5QcFINBonHU2NqUKAK
         qgng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757069786; x=1757674586;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QjsU1N0XRrRnM8naRkACSYSwdOlKjw+PQpIIkp+9bj8=;
        b=fnlI75ngUYtDfRxwUk+g/5kGzebkOnOat8AmHxi1bp5W1a/NzeKebH+2OxB07Pr+/P
         O5cSZcpzVqWXRQ25iuX9rxjR1RiwzRiR7DLJWxBEy3PUX3jOqoYRO+NwQmHCimrkgEuT
         W0eEFmVe8OQCFTn1Wvk2folMrQxSuupuBTfkwwvf/ZNf4ymwfklzjVU+GRWAwkKuXiR4
         Iqtr/b7XvyLps+740+fJUPgiyrIFpiP7q1PGEWNhPTTJo7InCN6hThQwRKz/8mqqNs4X
         mpN0W3K07NIwWUw6jCKCg80N/+7SzrjkK5Sco20CNF8PQz08T347l8LbdT56L5yO0dpR
         kBQQ==
X-Forwarded-Encrypted: i=1; AJvYcCU58vgwSPLj/4MyjoLqDKHnpGpV5oTo7Ud7zfAJkMkisxy4uSEHzNekz18UFrAX4FpBkVSZlkcqqg==@kvack.org
X-Gm-Message-State: AOJu0YyenjSLFjZMd96jPncs30HZ2j7ylrQuo/jxwWpF8VCqnCieq+jz
	uB/uz5n7fjBtBwF19AY6uNUkL4+ba8ug4yQu/POe+T4YAkaIW5s4MWdhCrev3szmPJg=
X-Gm-Gg: ASbGncsHWTJd2MB5Z3IcwHn0iG8byLviPmbwyvA5GM58/P9FwJooknsEi+t1uDn+UBd
	4PtD5mWed9LaVkgv3skIy9UP0kzM0oNcAV6OC0suvk7WPMpX7Jwgb10L4qoQJzPSPhv81zBz2ZK
	ni3G205ciyqRpaT+t6qQMOZa5heFWvTwiN45A2tbOqyvToVzwmb5Qf60TzBmDSrVLk/uZ/hjpvf
	Voo5ep2IattB+A5eKp7TOS1iS4cIxlAWaoy0ebcJ8PBNSM/zgQDCzqbn35dlS+o6z06gAxbEhrn
	rjUPE1DVhgO56SATTaafTDUFd70S9c22Iv95afT5oPweB9TbYDFtXi3M/iZyIchRPTc5WucCGzB
	PQ/7ilu47zg0MyTfkLwTijZjRKaE+tvlvZvDNRs977hE=
X-Google-Smtp-Source: AGHT+IHKcjOQAGCFSDmIiTPjPBAoOQfqrO/QLL132oFQqrU7VwFwL2dQqD8N3XwGwHZoV/q1HPgKEg==
X-Received: by 2002:a05:600c:19d4:b0:45d:d6fc:24f7 with SMTP id 5b1f17b1804b1-45ddc18fbf3mr4339665e9.32.1757069785704;
        Fri, 05 Sep 2025 03:56:25 -0700 (PDT)
Received: from localhost (109-81-31-43.rct.o2.cz. [109.81.31.43])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45b6f306c22sm411797985e9.13.2025.09.05.03.56.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Sep 2025 03:56:25 -0700 (PDT)
Date: Fri, 5 Sep 2025 12:56:24 +0200
From: Michal Hocko <mhocko@suse.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: kirill@shutemov.name, Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
	Usama Arif <usamaarif642@gmail.com>,
	Kiryl Shutsemau <kas@kernel.org>
Subject: Re: [PATCH] tools/mm: Add madvise tool
Message-ID: <aLrB2D-DjK8pFLHa@tiehlicka>
References: <20250904175729.1029735-1-kirill@shutemov.name>
 <aLqqlkTpEM1SkvaE@tiehlicka>
 <0b22e23d-f00b-47da-8e62-c8b0ced05e4e@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0b22e23d-f00b-47da-8e62-c8b0ced05e4e@lucifer.local>
X-Stat-Signature: ktakc5bmdomj8y1r1z7ihk86gsnuazif
X-Rspam-User: 
X-Rspamd-Queue-Id: 332AC180010
X-Rspamd-Server: rspam05
X-HE-Tag: 1757069786-530365
X-HE-Meta: U2FsdGVkX1/czdOw0ypgPNwtDuWbPlk53EiAmJ6mvxVn1ciUeujg03W5C9AO0G4IoRH9QGhq6fGiDT0N2oJtH1Fs+rYObFKMB/ITL7Nd5NEnz0pbIzLZc94+mdj0jYPNa8a+IoPRmq80x1oFmJEvLJMtFRS6tNL48XQKj1impfTicFy68V5ogvvcJkKTMYCSBscHrSiXpOxhYlzSiAczBNCtzq07yDgS2RoaXFfQ0ZFrrN0Ti6TClp1bJ/N+Sh6VkdGPOe4aip1V+yu2zjVXmFM3d7cvWY5SSsAOM763qIFYqtTNmpFqnmch0k9KBvUzLrFcRMVMgdd1lNMTR7K/lFbwsODPJl2cvuPOxKdJCsCLTW2BnVQu3puPsCmI42i7G2t/NbEbllOMRdec0+7SDg9pwr2QOB3khdQPBJFnyhTFECgkZ0bsDD064Qt1j6o2ImN6X0KPdMZYTpaLnx6O1fk5W6afdJbHGUN0c6Gu5HVm2lJiJhyiIjbv7QMgXscbpd620XlADbKWw6SHVsxOpcWzldgEUQqg/QlzXdhCPlVygWmN5h6QQJeWZYEp5zZEeglfVv/QiVu9127n0bNsh7Jb852SDt93uA00ZpqlEUKUyAJtZT4ciOSdYyoiI/SNeEyRCU2z0o0f3MeH0J1moAciUe9jcDWKgVOsj5zJlz+AeLPJ39ijRM/ahZNdyvFwf8YiU0Hd+1hrRH+5fDmV6Qk9YsVTPymclKTUPNle6Zllf7QxmBhtaCNEFKHpw8S1wZPLEMKUhoDf/sVGyKZO5VJWxOUFQRJJK99Kw8DT6uGelVyS44EcPPMk2mjVal0W7oqcdNViku6DNlWtoo5HIFyq+F7DNXxUEHT7Wo7yeMnKsUzECyGvDylNvfnDYMD5XioyBhaWxqIPNDCvXVsFRWem9++k5cPI7vuw6/k6WXVzYvjzCjcj5N13qFGDy6vQ2H3XRkEJDJU5t0IdLHN
 Jfq64pU9
 R8EOR/i/XBn6dZuOb3+MK56g8bgguUK7jwxUIJYkBPRE9VVw8/LG0CWPlZ3bhUrjfAUdqrxyiOtV9LafsTnUUHJMA0LWcaQ1Gx1fAhFYVc0tJuEoF1M2Eao+BONqUiwSbGtOjl6LddPSxqMnHe6XqmzEGBlcqImHC8ey43X9RyeeGubY5+Nr35x0zpBHcGlYaiC7zqZJtYaFZcoPRPVvD32MV/CB6++GHEfwjUEQKDfgVpX/nyB+33VNL93nbk2JR0IBocSxdiecBfVIQusqElJQ9LtI8Ld/nDoMbtmNjZAEOtUM9AgP6coBp+/WrdyAIrEzC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 05-09-25 11:16:38, Lorenzo Stoakes wrote:
> On Fri, Sep 05, 2025 at 11:17:10AM +0200, Michal Hocko wrote:
> >
> > Is there any reason to have this in the tree? This seems like a very
> > trivial tools that doesn't really need to be in a lockstep with the
> > kernel source.
> 
> To give my own 2 pence on this :>)
> 
> I think this is actually quite useful because it invokes process_madvise() and
> so can be used for experiments against other processes in a way that'd you'd
> have to write code for otherwise.

I am not questioning usefulness of the tool itself.

> I think it's useful to keep in sync with kernel as if we add more remote process
> madvise functionality this can be updated with it.

I just do not see any value in having it in the tree. It doesn't use (or
rely on) any kernel infrastructure and it can happily live outside of
the tree. New madvise functionality requires a runtime support rather
than a support in the current source tree.

We are certainly not pulling in other potentially useful tools
into the kernel tree in for some it was even really hard/impossible to
be merged yet they would benefit from a close lockstep with kernel
sources.


-- 
Michal Hocko
SUSE Labs

