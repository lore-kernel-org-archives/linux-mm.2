Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6DF1CCD199
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 22:33:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6FA68E000A; Thu, 16 Oct 2025 18:33:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E46F68E0006; Thu, 16 Oct 2025 18:33:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D36308E000A; Thu, 16 Oct 2025 18:33:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BD7DE8E0006
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 18:33:22 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 97902140212
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 22:33:22 +0000 (UTC)
X-FDA: 84005429844.20.DF46637
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9AA311C000B
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 22:33:20 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=fromorbit-com.20230601.gappssmtp.com header.s=20230601 header.b=PfIEh2X+;
	dmarc=pass (policy=quarantine) header.from=fromorbit.com;
	spf=pass (imf18.hostedemail.com: domain of david@fromorbit.com designates 209.85.215.169 as permitted sender) smtp.mailfrom=david@fromorbit.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760654000; a=rsa-sha256;
	cv=none;
	b=rw5HjjT1CfJs4Hg8gmPZfLh2YHmBhFSWcxgpWp1xoOI/vIWmIRiHCDZ7BmQzslGwpGv7V3
	VDX3ODEW+jFZsxlQhBLgY+vXHWKSz/3GYcQDhQqERik9GAFs6c8jtPB+710gA4/Qg8GcVx
	sy6Q4Q26YXf7fc/kQMlbKdREZ7iIHh8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=fromorbit-com.20230601.gappssmtp.com header.s=20230601 header.b=PfIEh2X+;
	dmarc=pass (policy=quarantine) header.from=fromorbit.com;
	spf=pass (imf18.hostedemail.com: domain of david@fromorbit.com designates 209.85.215.169 as permitted sender) smtp.mailfrom=david@fromorbit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760654000;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cyHszjXwr011mdavyBxcCiQ2SmN5DwUbyqKyrEqEbK8=;
	b=KAC98c4x+KW/fQ+61SQTou/k3y5zacrlZVtQ+l46tS8Xviosy3oFTX+cILfPtfSE7LEyE0
	OCDizrTJI4rvAWgNZd09pNum4+wBp7p+VjvA2cZI4WWnq+esEGuRMFHQat6o00iqjw8Zqg
	tORNrzlRlB3LFxshp30IHB90hnja6eQ=
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-b62fcddfa21so814841a12.1
        for <linux-mm@kvack.org>; Thu, 16 Oct 2025 15:33:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1760653999; x=1761258799; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cyHszjXwr011mdavyBxcCiQ2SmN5DwUbyqKyrEqEbK8=;
        b=PfIEh2X+mHljDUgEneXaQNvW/wwITzb7kelS/zxkGjUSryEirWuLYYvRosPtQqP9Dl
         iuRG8nXozAt6zD7wy/Rp0unFGZn2A9weV1jX25XY3IFpgScs6CoaEvsJWnWPgcPRWIah
         AgoVCttqX4ffTyhuqdH+RpRi9HLpxvgniyrdSMH8SeYLXKpa9fie2MQDGiMVzq6GskvL
         gcRoPremNzxK6zAmWfzzk956uaqjtdy65wIS+KuAEA4ogoSnTwT8eZBIJWrdAxzyI4Un
         /pSIw5ecqBqOqpYFdVbuoGZVjm2YuELBkn9CgB55AbuxJn1Kp8MBYWLwANPSSrgIW8Xl
         4Ffw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760653999; x=1761258799;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cyHszjXwr011mdavyBxcCiQ2SmN5DwUbyqKyrEqEbK8=;
        b=CrCltvaeT6MXhL5jgqQNYOS8vzY6VoPkEM7QSm7dh5K2dXlBWTqvte7b7461NHSG9h
         Ozp1sHjY6SCK1qJ1D3ZeVg085X8dAkvX+a613l4B84zBs1J/76fCaO9HxQHkt2dbsPtf
         OsO5B0Un1Ee2v1+r1dg5s+BYX9wI8kCcDWqBLNa47oowRf9ExVAd979KcKjofwgDsTFm
         +Q8zA3fsppuPur+Y8D+yx2VeiM9h/RwiW+TH4+BqfO3nrHLUw4WCazrdlf2vUdpsLBvN
         mS2+/3JL2Ain/5DBdm9fCKAiVQ6uCB3Dru+99S+tJkiyz5QIeT0wIQ5wZNiDCHkEhkqx
         OEDQ==
X-Forwarded-Encrypted: i=1; AJvYcCXtuwxTFfD71WSB9Hgo2TXL4orqGp0CbENBbJNsAnHsX0xZa1gRjj/tfCh9yegezImLC/90frrqkQ==@kvack.org
X-Gm-Message-State: AOJu0Yz7Tt3cFgg9Iy/fTMDlOhidltBWSrwK4cwObKkSId1ajoE42yze
	Xzgzgtdy8Ofl8jadaLPnkh33F0WkFXJpUMROmpU0Ts56ZNbGxdj8r9q4+JbUzYiDrDo=
X-Gm-Gg: ASbGncuSSLyTvPRkvpMJx/+VOryrML3CztHgkYwXOVzV/g0Ln2MUm1UMzpkR4+oPGiN
	5AqncJ+JfXOK/Kh4ayLIi7qqwpN5yOok5ORiP1c717yOop8+NnHhCtKAzpNP4MAXJExXemXJqTj
	4LT4WaUAwWYkzcb2GNYSQCRxzgh5S+r3YO5VBtTYk2cpN38A+0gIfPZxvVFHBeGm8NMuOjzSD/V
	RUQaeUshWvwK+uibNsR9aqhu9apGym25QIQElI1GozHmsATkcUxTuMWBf1rNk43ykOXwQK0rgRx
	UBAfv6gFbMIoA/MYWS53or9NNi9WdsuB0lEDWbLkMD/3QMPMdQ+T6zlmo0xoTAOQTY47rX30EA/
	7atucfmbPb6xp9Skv+QdfivSxE5w2r5U3GaNf1f/O7ANGphKfGPRvNPSIPZO4sNnjbgVMzWWBE3
	NebqVY1OicHKJi6YZCWXsBfJ3k5PMPHZw2vRt8myrp+Asksp2SlreKrl/0GzVDzg==
X-Google-Smtp-Source: AGHT+IHA0ri7OHJpZ/4Fd97oTXQUCyc/5am6RLXoYkFT5WMoFCFwAYWAWovMfIuEjWrsvgSaZLmzvA==
X-Received: by 2002:a17:902:f70b:b0:267:af07:6528 with SMTP id d9443c01a7336-290caf83079mr16312385ad.35.1760653999244;
        Thu, 16 Oct 2025 15:33:19 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-91-142.pa.nsw.optusnet.com.au. [49.180.91.142])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7992b060c4esm23661111b3a.14.2025.10.16.15.33.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Oct 2025 15:33:18 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1v9WX5-0000000FmFe-2Hry;
	Fri, 17 Oct 2025 09:33:15 +1100
Date: Fri, 17 Oct 2025 09:33:15 +1100
From: Dave Chinner <david@fromorbit.com>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Pankaj Raghav <p.raghav@samsung.com>, Zorro Lang <zlang@redhat.com>,
	akpm@linux-foundation.org, linux-mm <linux-mm@kvack.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: Regression in generic/749 with 8k fsblock size on 6.18-rc1
Message-ID: <aPFyqwdv1prLXw5I@dread.disaster.area>
References: <20251014175214.GW6188@frogsfrogsfrogs>
 <rymlydtl4fo4k4okciiifsl52vnd7pqs65me6grweotgsxagln@zebgjfr3tuep>
 <20251015175726.GC6188@frogsfrogsfrogs>
 <bknltdsmeiapy37jknsdr2gat277a4ytm5dzj3xrcbjdf3quxm@ej2anj5kqspo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bknltdsmeiapy37jknsdr2gat277a4ytm5dzj3xrcbjdf3quxm@ej2anj5kqspo>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9AA311C000B
X-Stat-Signature: 8hxiatzynp78gfd3s35gyhzjmich47pk
X-HE-Tag: 1760654000-8420
X-HE-Meta: U2FsdGVkX18RObIz8Mf921T1zKglhrgovVx5Inj1fPPWR0r9a9HzBLT3lm9P3eOr8tVXFpXbfiYGmWMvBbCeXwwjlca+9xoZ5YPfOo2M22ur0KWNo1/exWaO6UaVXNJoujFgK4Ub1n47JpBgN20uHJ/lOc+2x5Ka9Z5yI970uYqmA6wLraAjcq7n08IDIU4SWOcxyiFB0yLbpilLM/Cx8A1k5h6/vhOB47yd4l1lQYRpoWMhcJ6qn6CrDpdIU0V5kwiMH58+cqDKHXA6Otg7k2RPoE8Ztu8PVpraKBXVw4B7gPPloXOF1h1IvVk1YdlvqkXkd6p6pvytMSRp8khypWWdyQEiklD0ugDQ9k+DLCMCWaZHb0VKTz1joXsCQ4zekBJu6DfTmecMHAPbbd+pu+gDfGXxiex+1LpLJ5bvn821RGLD67cgjrmpL3iVzKdRCsOux6vrqoNce9EAOw4qb1RcRK9jzKtsXSXj37ZULktC67j5OEGgxT3fzVF/bCV204IrQOFvVCkpPnJjwWUt4ZWt30DLkVOwlm9m2hcBKJJQEsdfvEhPAmEK+fLWzFjOCJQJLXx9Sl4ZewL4Tia48USYPKonKO2gTbwykXk06mQH+oCoKhNZw/FbJyMiXBTAsX6wOv2JEGJAIPDiRfMqyfhv0VozzZ2Q/edy+nRG5FNi7CBXV4ySmuS6bVHvwjnknlcBAqQ3RvawzAk9ayOsg12z8ojGJRH2wEGy6aAXZwamRBaPZVa41bqJsUrhfmh6lRCd47Fw1h/INOzu2bElaGWEb+yLtmeNan3uAGCPmfUFoeSIyTPICDi6zf2iNVJOBj1G4V9G5Lp3NlhOXGYrY0lgkq2/Fe9F8uxOmksRObcDifjL4Ni2tT3ytEDrhUOQObXLmrN74PDrn4Oun6rC32LDHyMsowcHzpjcLL2gSX2ZWyKrQl1nvjSmxrQlQfSZqiv2nsLXal07OxqXL7Q
 n5lTlrh/
 7d3N0aPSQ9dE6f3aR785vs7bMfaLM5Sako/MhfS6GiR3CcOae13GIAxHFcO0J52juJs/L1KDIUWDYizZbCecnicZMPaxe3CNyPW1BxNjPU2Ehp/F6T/Qdl9NEf5Nn7PXGSraQGGfunvOZy7M3oQeEJ5SyvO3L3Y3ZGz4tWnXc8gtsAdymbskhDmchD8QSqT+n6ixH3Dl4p5LVU5MxBGV2p9rk23eTrw8/5cJR4RGJrKPpoL3L76Vc4xIk5tOFxrSdwP24UG3goNNLOspyCWscgKrWtHOMZOmwKojcAJyRAV9r8guBxVnTA9cH5yv6nv+A31eF/xn64iW4xs417fzMY+vsu5SAKWL5z0H+g3GXoIC/GJj9VMBKtWEW/rIc4LQxAtf0tLn8EzmH3ch2WctfAu04HHoGNkRPKV6ssflXXcAotlQF2euf/UcX51yxN7pMpuwQzU3nzISh3yc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 16, 2025 at 11:22:00AM +0100, Kiryl Shutsemau wrote:
> On Wed, Oct 15, 2025 at 10:57:26AM -0700, Darrick J. Wong wrote:
> > On Wed, Oct 15, 2025 at 04:59:03PM +0100, Kiryl Shutsemau wrote:
> > > On Tue, Oct 14, 2025 at 10:52:14AM -0700, Darrick J. Wong wrote:
> > > > Hi there,
> > > > 
> > > > On 6.18-rc1, generic/749[1] running on XFS with an 8k fsblock size fails
> > > > with the following:
> > > > 
> > > > --- /run/fstests/bin/tests/generic/749.out	2025-07-15 14:45:15.170416031 -0700
> > > > +++ /var/tmp/fstests/generic/749.out.bad	2025-10-13 17:48:53.079872054 -0700
> > > > @@ -1,2 +1,10 @@
> > > >  QA output created by 749
> > > > +Expected SIGBUS when mmap() reading beyond page boundary
> > > > +Expected SIGBUS when mmap() writing beyond page boundary
> > > > +Expected SIGBUS when mmap() reading beyond page boundary
> > > > +Expected SIGBUS when mmap() writing beyond page boundary
> > > > +Expected SIGBUS when mmap() reading beyond page boundary
> > > > +Expected SIGBUS when mmap() writing beyond page boundary
> > > > +Expected SIGBUS when mmap() reading beyond page boundary
> > > > +Expected SIGBUS when mmap() writing beyond page boundary
> > > >  Silence is golden
> > > > 
> > > > This test creates small files of various sizes, maps the EOF block, and
> > > > checks that you can read and write to the mmap'd page up to (but not
> > > > beyond) the next page boundary.
> > > > 
> > > > For 8k fsblock filesystems on x86, the pagecache creates a single 8k
> > > > folio to cache the entire fsblock containing EOF.  If EOF is in the
> > > > first 4096 bytes of that 8k fsblock, then it should be possible to do a
> > > > mmap read/write of the first 4k, but not the second 4k.  Memory accesses
> > > > to the second 4096 bytes should produce a SIGBUS.
> > > 
> > > Does anybody actually relies on this behaviour (beyond xfstests)?
> > 
> > Beats me, but the mmap manpage says:
> ...
> > POSIX 2024 says:
> ...
> > From both I would surmise that it's a reasonable expectation that you
> > can't map basepages beyond EOF and have page faults on those pages
> > succeed.
> 
> <Added folks form the commit that introduced generic/749>
> 
> Modern kernel with large folios blurs the line of what is the page.
> 
> I don't want play spec lawyer. Let's look at real workloads.

Or, more importantly, consider the security-related implications of
the change....

> If there's anything that actually relies on this SIGBUS corner case,
> let's see how we can fix the kernel. But it will cost some CPU cycles.
> 
> If it only broke syntactic test case, I'm inclined to say WONTFIX.
> 
> Any opinions?

Mapping beyond EOF ranges into userspace address spaces is a
potential security risk. If there is ever a zeroing-beyond-EOF bug
related to large folios (history tells us we are *guaranteed* to
screw this up somewhere in future), then allowing mapping all the
way to the end of the large folio could expose a -lot more- stale
kernel data to userspace than just what the tail of a PAGE_SIZE
faulted region would expose.

Hence allowing applications to successfully fault a (unpredictable)
distance far beyond EOF because the page cache used a large folio
spanning EOF seems, to me, to be a very undesirable behaviour to
expose to userspace.

-Dave.
-- 
Dave Chinner
david@fromorbit.com

