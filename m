Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C01B606A326
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 09:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gAMQa0RH
Received: by kanga.kvack.org (Postfix)
	id 922D06B05BC; Wed, 11 Nov 2026 04:35:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D31D6B05C3; Wed, 11 Nov 2026 04:35:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 810526B05CB; Wed, 11 Nov 2026 04:35:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 603456B05BC
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 04:35:32 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0302D80243
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:35:31 +0000 (UTC)
X-FDA: 85422330504.13.83956BA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 69F3120002
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:35:30 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gAMQa0RH;
	spf=pass (imf31.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794389730;
	b=KNDIQNiFqTsENsW5fn/UetRDOWRbuTLJef669TA1zOvc5TXn6trcfPIK/1hMVEKGLV2bvX
	LMSt3ZO9aRrSqF2C3T5ma0qtF+4gBOpc3cSCsY8tHSMdnZJ4mupmbd5Xp02m5u0FYmTTqV
	vMdoZQF2BQkMm9KqAJNikWTAfZh0iYE=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gAMQa0RH;
	spf=pass (imf31.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794389730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0wPrDM3ByIgNRkd8um3+s03MrGcxAel/A496/JlTAcw=;
	b=ZLwA7IbrrTy2Wk4XNLmZm32Sw8vRHiz2UIe+HJzHYrr/mTgVpZNWPdktCfIE5WHdwyOZS+
	xwraK9nC6oDvpAnIsCjiWNiWNW2/lX9Tnkk+2ahaLybB6Ujv6v3AmXDNaMa0DJuh/agi9b
	ilU2/6Q133zYQSy/0/PfgofA2hQWrus=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E3FC2633C5;
	Wed, 11 Nov 2026 09:35:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69C1C1F00A05;
	Wed, 11 Nov 2026 09:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794389729;
	bh=0wPrDM3ByIgNRkd8um3+s03MrGcxAel/A496/JlTAcw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gAMQa0RHrVEcdCTId5GAxxrGWJDWYg7Xh9YkxitRixioy7tg5wkBQEI9uDd0st8Uh
	 YnLgub2226L347lF9jDxz6rLuPv+BzoRXwpWU0BDi3ju+jCRN2OVUks/c7NHGphhPb
	 yixhl7x1QNHf0c/Lk2q3KpoiDJj3aFjSw/RyQ1fFnXRuUmU7OERWNGYndDndIk28pZ
	 mcUdS46AqNl+Ss3lxn4EkmaINg65asBvoEa4HqvQacm+3kr4vokkQ8k0xi5Y3s3AtZ
	 xSra2BP1eQvakfogTaMApKno9neO8lkjjcSTp8d26FwgVll1KJ2zWA+h/3Hdorto4K
	 Aygw8PaUPL5yQ==
Date: Wed, 11 Nov 2026 10:35:23 +0100
From: Christian Brauner <brauner@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: Jan Kara <jack@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, 
	linux-ext4@vger.kernel.org, linux-mm@kvack.org, linux-efi@vger.kernel.org, 
	linux-mtd@lists.infradead.org, dsterba@suse.cz, tytso@mit.edu, Mark Fasheh <mark@fasheh.com>, 
	Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: Re: [PATCH v2 25/34] gfs2: wait for a pending withdraw before
 remounting read-only
Message-ID: <20261111-dackel-verfechten-eheringe-01ff8d8ee23b@brauner>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-25-2f44f64f0b66@kernel.org>
 <sashiko-outbox-191244@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <sashiko-outbox-191244@kernel.org>
X-Stat-Signature: sujbkgyxcmra3n41oc6oh31yfdi3iffk
X-Rspamd-Queue-Id: 69F3120002
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794389730-842941
X-HE-Meta: U2FsdGVkX1+Z0rc8tBHw/QmZA1Yn237x4f3m1p4kUQ9bpq3sbNz5vHqs731Q86wNGOLQ94FxWEgQ1oMRwSGXy4dajx2ZG95u6eU9O/5BerL2mcdTNGQMwwWxck/91jhZwuPbc2/SGJhILHhyHLqWdDRD+5kC/ujwzhBRJ1YuLmu0ABTZoDtTyZH1rFnrYSX5n+rZf0qnqdTkkFPb2bSQr/IB/Nphl7QI4v/KL2ujW7uJq/8uG1r0p4qRNw2FpblJ+dYufJAIuO63SLHOj2OivbUUpMxdHas6Fihtdtj05mD+kJRC7oL8igfCrPWaWe6c4lxQf4F9vlonkaYqOcpGX64PaixkKpxzKYalvt58IfL3iSGuElkBHyGowg3dy/6SW9D/K7tGEMf2CrU2OSjmiHt/rMDC3X97Xv5Vio4WTiZSVNWPiQK608xglSR4emThNiLEenauvAjzkamj3KZ2rZ5wXX80iBEh34WBAFSvYV+urQHq+c2bChKmxaHA6S/U8Pu41605hscSDhRTGLVWtqfMhk/yZBVY676QUzsvSRZB+YEK/X3ntWRdk6fOHe216Gk7XroyRT7IU4gZx4CGOn+udJogAv5vDeIQt4UVnB7rdr8Hmj+Glqo/1aQnBx0U6d2aOUOALZRy/SA7cuNToNTTTpHCSPC0SuU8sLgCW4+/lifaCtyrckpYz14ftpRT10VemK7k/Fr0Q3p2RuFusDZu5xe+gF7Par8GUEB6zV5GhwycZ7mpCbiYSZ1JnRLzYNPhu4JsXd5Dd45zt+1lvxudXVw5rmLTUyA7MuhbSK0nun4BN5lHuEi4dOCr11J6DsQPKfxBsil/ICsTfRlP4iC6MOXhcr3PzyiHv8HNz34gIAjA3cChOdX/tBOJjKStgKbzPfeoFCQ+MrVvMSdlKwVSh+egJJPUtlprDF4PQSaj0eT0MeWsnRZzNq1KqGe40S/LN5Wcy1DG1w0J3Kj
 fTsvk7PY
 D0Z1QQvddtpNjsGwYnuRN9YPS9ZnPytRD1FsgyC8WlhiNK+SmSAyfhud4MqUvfABa4So9Skh9NHbPjL2qtffSImD3iEU0+DQ6WPdz8PVh9YNH/ZWYEIOShf9CC/eoIChr0zneFb9yutwx8dMa1N9dmESQwO0hfKmE1ARNyz/1pX3l3YB9WzmDNUt8MbtoUr70sGCIgnO3Aj64ri4OOH6IHxcUtKGSZssgEQzgHQaxUlsFe9cQL0pZ+75+lYraGKDvCmYCzVdAn6I6eD0CuzbJVnPXxDA01kUu9u3YUAa5PPHO8meOzAhXu11Ir2BmSK6sTRI+0aCFor+XXv4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 30, 2026 at 04:10:09PM +0000, sashiko-bot@kernel.org wrote:
> If the filesystem is subsequently remounted read-only via
> gfs2_reconfigure() -> gfs2_make_fs_ro(), gfs2_log_flush() bails out early on
> the withdrawn filesystem without clearing SDF_JOURNAL_LIVE, leaving
> wait_on_bit() in gfs2_make_fs_ro() sleeping forever while holding
> sb->s_umount.

Pre-existing. The fix is probably to queue the withdraw from
gfs2_reconfigure() and flush it before gfs2_make_fs_ro().

