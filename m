Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49ED4FF60D5
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 06:58:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E2DA6B008C; Tue, 31 Mar 2026 02:58:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66CBC6B0095; Tue, 31 Mar 2026 02:58:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 534836B0096; Tue, 31 Mar 2026 02:58:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3B9676B008C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 02:58:40 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D4B5E13C0A4
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 06:58:39 +0000 (UTC)
X-FDA: 84605455158.23.881B610
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf11.hostedemail.com (Postfix) with ESMTP id E0E6B40008
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 06:58:37 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Q+pKYHlV;
	spf=pass (imf11.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774940317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2ctn/dnY47VpD6BEY4z1LNAsyn2RLaR5EVemw/F8Cws=;
	b=mcLq4FWVq8p7gZ98M3SdltBie40ddTyHJKkSCCiASPUnh+e+RfeyGvvRaxbiDaayffmjN1
	kdrTXrefQL9Jr+DJvbbZ+PIhLSpgblcycxnwOX8unZE+ce1tGAlXbWrZB7y/Qw1p6WGzwd
	4mf0N+smA+3Sl6AcKMiIT51bWGPOLA0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Q+pKYHlV;
	spf=pass (imf11.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774940318; a=rsa-sha256;
	cv=none;
	b=IGaL9wdOMxMaEdSureXwtyqy+h4eNuHXjLTUxgprtxOZpgPxfirlvdcZaTrl3T/PV4bzYl
	UbDWg6fkbJX3MBME7e1RKXxkE2DxiWR3FoUPwKEt17bJBY64AoooQKEG8Q0eeJcbXwqZc/
	v2MELJUKK5Dzh5yk8SK1xYBoA+KH05w=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2ad21f437eeso35494115ad.0
        for <linux-mm@kvack.org>; Mon, 30 Mar 2026 23:58:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774940317; x=1775545117; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2ctn/dnY47VpD6BEY4z1LNAsyn2RLaR5EVemw/F8Cws=;
        b=Q+pKYHlVooRaoAFaUvmZQdG2TG1+i5y7XwzuoK2Jk7BGWHmWtnO5O1XNIFjZxPSIzz
         AsEy1Q6JrMPQH1uBwHPrLu9FBTT3S0P/QzUioIxLg6BE8O5E+niNtUAvkEP5s3ImQQMg
         ZC8c9ruu8H9YMDawjj7gqa0mFprBeh1mwmDua35fB5XfPytaWk9D+Z5UJRDay9Xh98BA
         YQ/pShxfo9jTsya42zqawttL0OYfwPKpe+WSz2pMcPLeBIeY3uIUXDyNc9CHjsK8Z2+K
         5HsX4bMfbD7jMdbNjlxrv/fy4Np1fyYsAAGLC/MrqjQSUhyptGyB/1wba5aMCIIQCrie
         LQ+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774940317; x=1775545117;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2ctn/dnY47VpD6BEY4z1LNAsyn2RLaR5EVemw/F8Cws=;
        b=Wpu5fs+oV444Ht19eM9OHU626m0WJLJ/K37gtDf/hEBRzeAV0cw3a1/hQHSkm/kN90
         wxDGRv8D/I6YkZKXoJzPtMwJ+ezJTATjEi408fZJ6X/sr/7S22sHqNirIdQrpB1yiBvT
         q7LFQdVsGNMzz7zQ8RRuNyICoOeeYqz1lD25tfsn1xaxRVUFf98vyXTsVJ/HRR2J5I20
         r6p1Y67XgmAfLnnN+TZFRzRTk9zuZ+j1I6sToP3K89HkapDBf5sTojQEQwYAa2Fp0yp0
         43T5u/lRPWUiGToKr2Gyai4RT0plfmxfeK9K7CcaeLLGU+1hxbcU9KOmAljVsOsRI7y5
         2stg==
X-Forwarded-Encrypted: i=1; AJvYcCUMgHVXb0uCjSKUO3WOZHRF3tLxvKDzg7Ac/jCLSJ+Cqc1Koxl8+v0WgMTgInjKbMXIWM++bfzszA==@kvack.org
X-Gm-Message-State: AOJu0YzMpvdrvom3GDe9cLdyVPMIb383h9dhRG9sRKmzYv8INtpKs9Jm
	hN5O3W1Oc2BCuwdu56dwHgJ5pUswMg4klsSAkOHcW9/uA9RMrCIHXccGZ44j6A==
X-Gm-Gg: ATEYQzyfl4HgLz1mk4+PRyXDhLz8v68ypmqxv6bvb+bbqhDgBlZ5yLyAtvgVslwQQxJ
	ASTtVqYlyyeLeWelIrGHsOuAIqidXjOHw5BkGxqA8mTM43XofTuXquOuOyz4ouqLYbydjIg8k4D
	ChXbVhBU/1QOCenhX6bRM1pFZGn4rdQXHZ6bLneDtwQGtIpa3oYlbh9LlFg7wKxxyu7ixdS/Hji
	BzlxEBlWa839jeqpt+oNS6KuXx7EMmieE2i5irmTbB/GkZJjhyG5eGKUTPfcY2eGjNRLBVM2T6S
	qOOAy4pu2eDd+8D7kqAidbfjfbCg5nVwXkwAoYn+D6WPB0Ez+aeSngqFEcUI8iVzMxA4Y9l6Hpu
	WTWCjlb+gbpS9h5HFMcCj4Lci5sIemilERkz8SjCBnFUJE8g+fPmEOD0IaqjHF2wbho9oPBzh9D
	MckkXgHtjMJ6b7Z7DfQ+4ft6kugcuwwCs+UZwg3Xk2SjU8xXJjWUg=
X-Received: by 2002:a17:903:90b:b0:2b0:b214:3bf0 with SMTP id d9443c01a7336-2b25ef39cd7mr24743905ad.17.1774940316646;
        Mon, 30 Mar 2026 23:58:36 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:898b:301c:d085:a35:99e7:ffec])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b24b02a11esm92674675ad.65.2026.03.30.23.58.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 23:58:36 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: sj@kernel.org
Cc: aethernet65535@gmail.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH] mm/damon: reset thread status parameters upon kdamond termination
Date: Tue, 31 Mar 2026 14:58:36 +0800
Message-ID: <20260331065836.4364-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331050229.67637-1-sj@kernel.org>
References: <20260331050229.67637-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E0E6B40008
X-Stat-Signature: jgdaexr1ep18pn8ef46dasgski4ywdrq
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774940317-764688
X-HE-Meta: U2FsdGVkX19QgLJlaQAHWt/nL+9M05+QGxD/lD/GlwD3WgUX9zCWuQh0rRxsvdADPUQUNN/1IjBRMpgOezkBsmfCO2/JCDGnNVFIo+DQTZguf2vsQpSIg34YNegxJYvUj3LJDEXynYJ1CmQ7z/SUkzie93G1XL8dVa+FAjTWyq2cuu1PSlV/b6SdtmADy6+zfKGHpc1EwUQCzTt+FQ/JxhRVbbW2VPxbVsQClv6k7+vYxsbaJb9ny765tnlj7C9q31ZRXbYYnhtfjaEbyPhRKI2wG0+uS/fz90ExwVvfcKl3XTyy9P4PLlpdfNB5T8CM/aDR/pNcwPwAgB03KRZvGgBc9TXyqjzdQsvGwVpBE0eBVFAaTvghAxbB0LVM+IbvFC3IACFateXErlM/obrR7nx/saTof8pbEZhGIk64iNWoZILldjJGXmI49g7sdI8Bqe1xmwhz6QJLYOcaeHlwu2BuOYzZd4jSy5JvbkpG7zLGFU//miJTlimxYCRgtgv0jyo2lapt+KciGwDeNgAx/lVxmKblTB1iu3RCMWovjthVDYU+OWlPew8YtptBeCa2cDtlPxN+8acp4nLE7N5ROZJM2PYgJco80D5U1EsdQUbivH6BshVfSgroOdgT2ptE3L1BIkCnmMIU6uQ1a/GXa5FpDfexS05zM1jqibDqtNMQ7DhguOOgDjuSxzlsEQmNu2ffho2p2ChY+53wSD4oK6ftOfBEtZ/7LGdTD/SAgWTvmWRxjabOvgPr+1PhAHfndNPsyBxolBadY6y6AdyEdQ95V0mM8BU5tgvTt5LHkB4y4WJGQwl0cNBySIvlzimUc8bsY0t+/goL0YtDdYb3G4PWYVJAV/Rmm6CTKuPmE98BDf9iqgup8fbec7f6l5JqjW22SO4icqivdoFa+h117IvWGvaTlaz0lel4kQoVCbBlAoqj34tPItNvPf9z2UEzgs5AjIaUg1i7Eyr3qS3
 LWGSY2kx
 VneLUZvjjeGPS65krYGWThQ+fALeW0skj9iRw6RR5pTSvIVbwJnATHXYt7n6/jI88QZFjaxNRbl3EQBWKEAa1aONkSYl4DMWnKyUZJq/3TiGzwci/rVX2T/AW1oqsrzZB48tve+Z/vrWhjbG1ru7MfWDtSxGRkYGBAp9ZFYVoY0hcFDOOtrXvcUt89/dIrcRneUGnFKKrP0VCzKVcGgeVLol5dMoMyM58H3Tb0+GbCgvN7wLTc3wEDfBQ+OHzXeR0mWA85Skt2gHxNEyfHrH+Icm+fLeyB3dI55B7nN0aQ/67Tpry+A7iqh+dHJhDdC2ZVpRov4oRnX2X8avnutosPRhu6KlBUTGhLgnIXVvo8TPqvu3HbcFVSqLd8CsQWmVyRIekFZTvsaV25vTF0B+9qZhzggapY9jHsDK7a3anTxzMPAIx5GDovBJBhsFPj/PMKU/zla5coLWtjXk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SeongJae,

On Mon, 30 Mar 2026 22:02:28 -0700 SeongJae Park <sj@kernel.org> wrote:

> Nice catch!
> 
> I guess this can easily reproducible?  Sharing detailed reproduction steps
> would be nice.

I will include the reproduction steps in the next version.

> > Solution
> > ========
> > Introduce a 'thread_status' structure to link the internal kdamond
> > state with module parameters ('enabled' and 'kdamond_pid').
> > 
> > Specifically:
> > 1. Extend 'struct damon_ctx' to include pointers to the module's
> >    parameters.
> > 2. Initialize these pointers in damon_lru_sort_apply_parameters()
> >    and damon_reclaim_apply_parameters() to point the respective
> >    module variables.
> > 3. Implement damon_update_thread_status() to reset 'enabled' to
> >    false and 'kdamond_pid' to -1 when the kdamond thread finishes.
> 
> This feels too much extension of core API for a problem that can more simply be
> fixed.  Can't we detect the unexpected termination of kdamond from the modules
> and update the paramter values accordingly?
> 
> If we cannot due to a limitation of the DAMON core API, I'd like to extend the
> API for letting the caller detects the unexpected termination.
> 
> Because this is an RFC and I already have question for the high level
> direction, I will skip code level review.
> I agree that the current approach was too heavy as it forced the DAMON
> Core to directly manipulate module-specific parameters, leading to tight
> coupling between layers.

To address this, I've brainstormed two alternative directions and would
love to hear your thoughts:

Option 1: Introduce a generic termination callback
==================================================
Add 'void *after_terminate_fn(void*)' and 'void *after_terminate_data'
to 'struct damon_ctx' or 'struct damon_operations'. While this extends
the Core API, it provides a clean notification mechanism. When kdamond
exits for any reason, the module can perform its own cleanup (e.g.,
resetting 'enabled' and 'kdamond_pid') within its own callback. This
keeps the core logic decoupled from module parameters.

Option 2: On-demand state correction in the module
==================================================
In damon_{lru_sort, reclaim}_enabled_store(), if damon_stop() fails, we
check is_kdamond_running(). If the kdamond is found to be terminated, we
forcibly reset 'enabled' and 'kdamond_pid'.

My perspective
--------------
I personally prefer OPTION-1 because it ensures the sysfs state in
synchronized actively.

OPTION-2 is simpler and avoids API changes, but it's a "passive" fix
that only triggers when user atttempts a write operation. User might
still see inconsistent value until they try to interact with the module.

I value your judgment on which path better aligns with DAMON's long-term
design philosophy, as your experience with real-world kernel maintenance
is far beyond mine. :>

Best regards,
Rui Yan

[...]

