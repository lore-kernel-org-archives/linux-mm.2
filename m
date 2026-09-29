Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96ED2CA5FA7
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 09:05:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 786526B008C; Tue, 29 Sep 2026 05:05:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 736616B0092; Tue, 29 Sep 2026 05:05:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 626776B0096; Tue, 29 Sep 2026 05:05:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 349C06B008C
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 05:05:52 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3790CC040E
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 09:05:51 +0000 (UTC)
X-FDA: 85266217302.18.A3E7590
Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	by imf09.hostedemail.com (Postfix) with ESMTP id 73504140008
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 09:05:49 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mnZeqLuQ;
	spf=pass (imf09.hostedemail.com: domain of azpijr@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790672749;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7TExyK8zIEMku3wrghEduJ+4wDucgiERD4p9sT26jE8=;
	b=ABsHDACwEWmm56Hyw4XZXi1IdbimMMtNHt+i59wrG0D3ztlCZT+TfaglpQyui3wN6jS2GC
	Q/mQOEbB2oS4/pqWFq71jFo4/lVdnq7vRkEstkCk220mfd3ELTZZpE/46EqcHEqEGpy4Bb
	82JioBjTYp/z2I3soR/puDjX1w5FFy4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mnZeqLuQ;
	spf=pass (imf09.hostedemail.com: domain of azpijr@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790672749;
	b=zGGwWC6+cE1akURLU95Nh3bJ8xVMw2rN2dytjN6d5pgRdK1bVpEQXxpJAKYK/QKzhkNfaX
	f9LeS0xyfcZStp8j5upQG9c9w32qfyelq/LqbsJbOo1kF2cTVmi26gmg1L00FcmsGXIBMn
	iv0Ad6abyspSsixjFMJgiedtiDmmJ9s=
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-4a006bb267eso9183965e9.0
        for <linux-mm@kvack.org>; Tue, 29 Sep 2026 02:05:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790672748; x=1791277548; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=7TExyK8zIEMku3wrghEduJ+4wDucgiERD4p9sT26jE8=;
        b=mnZeqLuQleaIwKRcOocZ5FMQgaYoBDhK8hu9AqKdFw0KDj2omx2i0OohAKpgJENdQg
         VhYfM2WLnFKoJn96YS2SrbOVLeam0QXbIb9hsy41Mdax8t43+JBH9UihNgw8MOEpqgEr
         QMVLaFb9N3cTBdib6+Om23fEDEt+tbY1/Ec4o2NTJ2VjvvRCJ76lHfh34D10EyJZc1rO
         c/nC7BIKcy0YlTjYjMwV5Ffkw9jt2T4lSZv4+1tWmSov1ny6GrAIFPf8zfNurq9Z97wZ
         wTKegHvrHQSsLsX5pvtOpfinD5FKGur3SIQ7YDMPgFHVtzn6pjDWuExEy/UOkULv3fNk
         axYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790672748; x=1791277548;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7TExyK8zIEMku3wrghEduJ+4wDucgiERD4p9sT26jE8=;
        b=P6MQ114ART9e6S2wBZJthxCXjcxuBaJrxBvhhCdpQznXfDeYBeIIKv+YN3acBFLBL5
         YTaNXkec++4tRju57JkSpwif9gl7a4WYRK0lfP7vfdIZYOdUb5LGHVFoIS4S/9NlZ1qS
         kB7vkhYgCKMaO4/KPtAg23XJ7U24Vb6gOYn0B9pkmMWtGEiA0kS/m2FP5Vu2kZHX/kYv
         GMlhqY7M+hef/eVY8BzzjW/VIQxDhWIFmk0M8bqy1TohXGVk7GktgHrKJVh6+v2V5pzk
         2HOZPS94NAFYZyU1reCxTeL08gLp5a5UDNztoMwxxIh9ZoRf7PYteAR/6ow8ce9zn+aV
         bCZA==
X-Forwarded-Encrypted: i=1; AKwUvByrAH3mhWbIWgfxkUQpg8GrRjq9TUNh8EOFgTo9L34CxDY8e2MMZo4DIyX0B4hHJhFbXuCxqqN1aA==@kvack.org
X-Gm-Message-State: AFuF++nwi0GXheDpjuosfGN0Ltk3SbxUka6VGBtFfyUoYSV2IMrA8ZMx
	NNjlun6jbZax8FaHebohEFCwC6L8HHncpbQdzL7UkYG4ZuNq0rYBYFQG
X-Gm-Gg: AYBFou2v1GjOoYsXfKF+jjHlATbYb9pKIVWwOAP7XgDktmnXcdCbDcUNKmPTPYvNB5y
	z/l291CDu8dunKapE5MIRMJLXqk1dPsEsqWrpcwdTwnQKFIuRVs6/yoOgyksVDDTKdq7LQOnqLt
	+hbJazJKDkjEMrR37qYdQM5XRpFycYhZDl8k+Vti7lvmz2n/4ksqA1SPniatdjiyOc2MhQ+mJDW
	8/ztQNl5Twf/n2NzABpv+wWcKa7ahhifemwq+kkXfCq7wmztoaTTSvZMqf7zOTutYEKwmINq+Zl
	SK+ZTDnnAtM7wgohgIaCR5gLvOhAMnDw84c2ZjSc6gL/L2TVaO/SA553oczxX6+y9ssB3/z523L
	+rsCCs09eMuo3BUsPT7ge5F3Jgs9Y0TuTJcg2/SpXFGrw0C9+DAa4SdK8iGQQ5QalF9Jrhznwc2
	6HZY/0YEXEWefBWSzTFZrcJdjc1pT3b0OvyyyoW+V8TSO9zo541N9rvEQuJNI=
X-Received: by 2002:a05:600c:4f45:b0:49f:fed0:fc47 with SMTP id 5b1f17b1804b1-49ffed0fe54mr144940245e9.1.1790672747833;
        Tue, 29 Sep 2026 02:05:47 -0700 (PDT)
Received: from gmail.com ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a00cf868b5sm90738705e9.1.2026.09.29.02.05.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2026 02:05:47 -0700 (PDT)
Date: Tue, 29 Sep 2026 11:05:44 +0200
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Shuah Khan <shuah@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: check MREMAP_DONTUNMAP mlock accounting
Message-ID: <art-TQZISqp3frvp@gmail.com>
References: <20260928111055.482136-1-azpijr@gmail.com>
 <ae606df5-7d14-47b4-8569-fe47321bfac7@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ae606df5-7d14-47b4-8569-fe47321bfac7@kernel.org>
X-Stat-Signature: 5btnqxudau5xz6hhn9qdb91hsazgywrr
X-Rspamd-Queue-Id: 73504140008
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790672749-617587
X-HE-Meta: U2FsdGVkX18Ivk2/XAp3kuD/znMOuJHtm+nkrk3UUNFYe8S0MCK/PsuW3NfA+OPFSNUDpmf/5hsapiQa8cO3tdxJ2QLwoeKc7NgFvwF4ts68PfFLP/Wam5nuBhKXQgRGHYQg2dj/bTDyKosrPb1an3X/aB3KbwBZZpd7OfNPGApwBH+8D4AF1S+aKN8BERtQOsFpxHEqz/RnZ5kN2Ful7vuKFJ/CEMiYgHKyZSG4T/WoMh7J662Ttof/NsZFWPPxz6ViTh6EITG1+/CgBhmNApqY6RDDACJfSHe7v+Jgzu0lb15V5j+JSq8toZhcAqtubMzpD8YovjREjWPW+E+CH4q7m5dpqcA1CUj3LcBR7aX3Nz/10WP62NRClQQGEbOrzIHEayTEf/dS3y1fLC4V8rSRODRBWHuwomvc3tMnoQxcHydTvOH4H2d67ANnMCv12QJT7tevY7qMG3Sa5oamqKqx3W5/2atOc0j4gdgxdd8ARQY2UCFC4Lf/TVrSzirj9GcGNqvBi1iWUMLCF6fzqn+w3d5unlp1Kq8cDKU7qFa54HpPvvuTM1kSxqqhVDmysIT5KMIfphp17fMXBfZiIIgPMByKleTdKYn5dgYITle29h+ozRDrtXjTxHCOr7woGxKcJodjDV5iPhyoe9nc2mTXYGSjKO+rBl1I3WbPDiA3J1Rjz1OKD8fRMQCD1752gIKMUwZBK8jLStQK+ZjkzATzwXoN0hjP2WEWZbTUW1r4V3l9DIszEs9TVtGWNV58Xzo3IIHHXqFpRbkV8HNorjn1JR/2u6VYEzagyz0exVFKL/Ecdf/u8ArRmJZ35zVWWSXmdIYY9zi9mB9SwA8cGWQzTZvZOmHDlU3H1q4BuexlZSfJ5p6NSoXMdDXyQYeVbbFN0BDH7oFlokFO7MI8lqgSW63CUfbId3WjY/jjXSByfIGdwSCQr+FlhH+N/+6yHs3ibQyrjEenkBPUqIr
 mruNitlE
 u9HJSxiZCB4Q2jGku/oKudOD735hGbfc62lMbH517JZ+HSFbl5zvfQHBJ3kaJZjNoTcv3JpEOCEnB4vpGgnc2QwNJ9nw1pVdcD0DpfXvbuNeq2fHmGbjLtYg2soqE5P1/5QvCq/Cx79UVmYrj/52qYI1dl0H9nUgDiDKn9xZqIKRxEiQW8kvSqDlxUxm6W2DCNOKEu+Qjd1gO90s9dV+CwIPR3jryJPINwLt0KtinARte9450QuL65jEP1IoGrAHB8iDzdxs/OGTw3Glp8i4mvnNN9TNk2Ceag0RmKjIK5pHDrOtrK5x3OkSJC1TxMS4xs3P0chDVf9Darr0Zmi2ZP+eHEQpWWNdlJBIC+U49W8rbFPw4dTjVt1lytN7KpdQXKHOl6oOuqAvrWV0Asat2BHZEZ4G4TZucW4hv/jHpVAoXeOOTJG9R40+1GvgS2FAF8x85qwbaVWQbNVFXMu76J0l+zQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 28, 2026 at 02:08:51PM +0200, David Hildenbrand (Arm) wrote:
> On 9/28/26 13:10, Jose A. Perez de Azpillaga wrote:
> > MREMAP_DONTUNMAP keeps the source VMA in place, but clears its mlock flags
> > for the whole VMA while setting them on the destination VMA.  Two cases
> > leak mm->locked_vm as a result:
> >
> >  - an unfaulted mlock-on-fault VMA moved behind itself self-merges, so the
> >    single resulting VMA loses the flags without the accounting being
> >    dropped;
> >
> >  - a partial mremap() moves only part of the range, leaving the pages which
> >    are not moved accounted as locked in a VMA whose flags were cleared.
> >
> > Add three cases to the MREMAP_DONTUNMAP selftest which mlock() the source
> > VMA, with and without MLOCK_ONFAULT, perform the operation and check that
> > VmLck comes back to zero once everything is unmapped.  Each case runs in
> > its own process, so it starts from a clean mm with VmLck at zero and a
> > failure cannot propagate to the cases which follow.
> >
> > Verified on x86_64: the three cases fail on v7.3-rc5 and pass on
> > mm-unstable with the fixes from the "mm/mremap: fix two issues with
> > MREMAP_DONTUNMAP" series applied.
> >
> > Signed-off-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
> > ---
> >  tools/testing/selftests/mm/mremap_dontunmap.c | 273 +++++++++++++++++-
>
> @Lorenzo, could something like this also be implemented (maybe with less churn)
> in the vma.c selftests?

if the size is the concern, most of it is the per case process and error
handling, and I could try folding that into one helper if you would
prefer a smaller patch.

--
cheers,
jose a. p-a

