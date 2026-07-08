Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D231BC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 02:32:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A291C6B0093; Tue,  7 Jul 2026 22:32:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A005F6B0095; Tue,  7 Jul 2026 22:32:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93D636B0096; Tue,  7 Jul 2026 22:32:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6CE956B0093
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 22:32:28 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E936DC3DE8
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 02:32:27 +0000 (UTC)
X-FDA: 84964035534.19.FBDD321
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 57DA81C0008
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 02:32:26 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CLMYqRcf;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783477946;
	b=Ti/TBshnvV37LLXJPHUU8gZwyPXgA9YVAHVkJpJsk5rASfoBG42xXAoWCdiTxCT2+RUeWr
	7xfRHkyD7gUbPRL82P47sN0du2+QwxyaaKVtTscusqiX9gPlDWPDwWM6IeHWZEKgaoyLau
	HoFDEEIErYzJWAIMYjTthcaAPpCsXbg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CLMYqRcf;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783477946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Obq6dLfAjBdyhlhP1/6V4rwvn+/mhp94v8tQm0g5iGQ=;
	b=6D131WE1aHDhkdj8l1L/peZVZDP4S3Kg0ervMzR1Hkm0zYNhL0LUYc+bJfpTlUkY1m60gZ
	IiN7OtscvI6IVC3054G4Uah3xK+iLbc9mkEBDf1+GaHvQgDTPXL0tn9/VrsAwneEYIlJ50
	tuAmUqqPVK+zHfvLpF9tBiI7Qhi6HQg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B163D6001A;
	Wed,  8 Jul 2026 02:32:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 147601F000E9;
	Wed,  8 Jul 2026 02:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783477945;
	bh=Obq6dLfAjBdyhlhP1/6V4rwvn+/mhp94v8tQm0g5iGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CLMYqRcfS62VRbTS878OpWNcxvhNMffnof3edE+RAXBjGwiv7/nlAp3YKOc/0HXNX
	 TVcC+p72OZWvbwcVW+kD8laN0bwiAGSRjW/aP0PaWc7s70yo1tMrbKm4jrQz1noC3c
	 fJVSYl/yvJBvFnRriko1gfGrXLv+nh9uq2Q7PtSCLEg9KQwJZ0H2weONjAodd7BCC3
	 HrDc+drAkFBNTw2yRVkYhAp1ZA+qjs5JBT5YTDEwAz+tRpZsnEg9o16uiuno6+Nspb
	 jzDGKFtinJktARi1Uc95hhxmncszECpFcpRxe7vOPDHNk40K3rZdyhvqyzrdbXJ+CI
	 6lbXpH2pgHYmA==
From: SJ Park <sj@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH v1.2 0/7] mm/damon: update probe hits for runtime parameter commits
Date: Tue,  7 Jul 2026 19:32:20 -0700
Message-ID: <20260708023221.96950-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260708013252.95888-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 57DA81C0008
X-Stat-Signature: sj9daqeokz5kdauwnd7d8ofy46op7dki
X-HE-Tag: 1783477946-883657
X-HE-Meta: U2FsdGVkX190C/gJFpnJKj++ISNAUMvX+SUGHpK+rB8rN2rs2b50AaUshQ8HDdZy4+ix1SC+59MsMhia9EKbfusaaRo0vz8mrsAgo/HSnf2li7De0PLzkNgoa1dSjoRBXmMWTXRdN95zhLkkqeHEwDzGUkxmOXVWN5eJ4ZkaacpKIxTUjIDd7r9YesZPbQ4SaPbMzO8AcP9izxePWQjQQ6GaeiGctFV7/HcFM284EhLZYIP0b65pB7iT+SGRQFub02U7XcifmfnPw3okwLJLeKy2N27P6hDSgjExb13fACpEG6fYY9Qxz+eTl8N67A7wSH4qKQNQ8FcNOlYvRXaxJ1QuY+OzGeDL8bX1Yya2k8ej3GDCsCH10v3J5QXzhquOygqubhZjp9T6Y0LAi9sCIW1cLMH6eQVBKE0Wxb6p8F1bJey9at2MXNVYMIgZarMhZlly+q/dYR1lipEMHvPcnyHhXInKvqgm78smk2Rczdp5nQYGHVpOzZu5gd4pIAnolJFvIfU/xzBdgWuxIjmzqhXRDVx/PkW27aSRJ+7+WSO0Ceh9b0lSUgBP37UzSspigNKh/FZyggWFsrLJp3tIWLoByzWmJStYPiZI8epaH1E1X73YzS8EzeIjJm+hGsMPsG8O4M54mxFfw6c0fdII7iQJaF32Qn6+WzFsqloiUseMGryqo2ol6xFSeEpMtThQnk9gSCj2blVI9m25wA87RZs8t2tCoR01D9h6kmNgqMGgR2w5eRoT7pVD/6VIOORvqSt545VvyonilXwS7ustCNmPPnfI7QVPEJzopSpJhCczeKVH7vr8cTX3gIkhLxYDYvzkIwbdTBRo7zblxMbD2WDbYntDqJM/FrxlIDMU3dACyb5k3cxDvfVkStg5jNLAIfj/6T0+3qfizOkAO6mlhtbf4SOPmBZLYYC0jmEdCjmsDEahT317nxavED4LY/2vISsK1fCMfG5pghxxcrW
 b9fUsArS
 U8q8dvLbVt+yoF8EzYMjmavn7MoNq8qKNdxagDYI1hfWV+7TvOW57jK9k+1TyRNIJAa00HQHKMFr0V3y95vhasuGKWQj7g8xcXdgt2GeOJ+kVSiHUeTe7hmZibCwZPV3HamnDzzD4KP7flX95Iho5wbL4WVqc3BeXviUPcwwovLIozOc/WNZoJZTTIMDFEZs2DVzIFZytYd5DxPFNpI+vjTtwpYzslSGdCPFH94F8gS/JMAftElR2olkGrDkxkpU7KHXz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue,  7 Jul 2026 18:32:43 -0700 SJ Park <sj@kernel.org> wrote:

> DAMON users can update DAMON parameters such as sampling and aggregation
> intervals at runtime.  For such changes, monitoring results that depend
> on the intervals should be properly updated for better accuracy.  For
> example, the access frequency counter (nr_accesses) is updated.  The
> data attribute monitoring counter (probe_hits) is not being updated,
> though.  Do the updates for new parameters.

Please ignore this version.  I made silly mistakes while rebasing.  As this
version is not for a review, I will send a correct version very soon.


Thanks,
SJ

[...]

