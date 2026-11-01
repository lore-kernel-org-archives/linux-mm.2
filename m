Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D18A606A324
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 17:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kQ8VzZvS
Received: by kanga.kvack.org (Postfix)
	id EA8A26B05B1; Sun,  1 Nov 2026 12:38:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E810A6B05B2; Sun,  1 Nov 2026 12:38:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D72096B05B3; Sun,  1 Nov 2026 12:38:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B81BE6B05B1
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 12:38:47 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 403DD1408F1
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 17:38:47 +0000 (UTC)
X-FDA: 85387260294.07.808E574
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 9CB9D180002
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 17:38:45 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kQ8VzZvS;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793554725;
	b=r8FBTnz+81Bm3rMTVLalTsMBQ81LjDm2Bi8edCKpv57GsPJTJvwvssmpzSiqHuHXZ5NJGt
	RFxGmOQL+7r+TVE2+1VTU0i6v8HUA9/NN8eHopV4h1Cvm0yfoYJ29xcQnLePXBxB38kf1Q
	p7msuRr2ydivhGU252jXiYofyUNPH+s=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kQ8VzZvS;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793554725;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PAth9uuBsiD2ZBusvqK9jhofezKOh4eMDf+spvC6ZS8=;
	b=q0Iw9aiXvMFrjhxtRMxT+nqdn4VhckijXoALXNjJYOjrwSKGbOvk02MA5LzQOK2xOysOt6
	LiKGTajxq9jPNauEymARd+AOiPdd5Yz9T1gJ8NQawzlYiPADBtt1MbP0U+qNvg9vJBGWSJ
	/+vjkrr0VMX8Hu4/OxAHJH8bsUth6ZU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2BB79600E2
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 17:38:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEC651F000C1;
	Sun,  1 Nov 2026 17:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793554724;
	bh=PAth9uuBsiD2ZBusvqK9jhofezKOh4eMDf+spvC6ZS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kQ8VzZvSgspbzf0SuM8xUN2hyNsa3Eg74XNmydQiskesNLCOsRNB5olap9pQpi1VB
	 CCcI8te22TpleARbiUDmhCAqU5Lx9wNMBlTeBloBVweDq8uemlzyIb+r128NtFhz1W
	 GX6WBNAWszmFdHRHb+Vhm8BEnKEKydTJ/zD1oDy4E+JEOeFNFAJjB0P1SvPUzNF//3
	 cgp1uMut585Jy5DXx6iq+N+ECqXK07GCmFuFcOO2MUbwagmcTfODhuNyUcU+DiPnhV
	 gGf6AjCETFkciKdSY5uW7YCB/q5igRf+lAKlJA6qtg+vC9W+vdNEgzkcDpfnr0ArXO
	 CUVJp7zt0NeTw==
From: SJ Park <sj@kernel.org>
To: sashiko-bot@kernel.org
Cc: SJ Park <sj@kernel.org>,
	"Shuah Khan" <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH v2 6/6] selftests/damon: remove unused imports of os and sys modules
Date: Sun,  1 Nov 2026 09:38:36 -0800
Message-ID: <20261101173837.82868-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <sashiko-outbox-192521@kernel.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 9CB9D180002
X-Stat-Signature: a3335ob4n3b1k6gsjzjkt6rcj3ifoq3e
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793554725-792217
X-HE-Meta: U2FsdGVkX1/jpXYaKrpXJrrCGNd70Ca+9EoWV8S/v+/DFSPostVM146YAjAFF/GIL1W5DHffaMEVsaS10s89PuPMgKhpxcEZO+y67UYeMFYEA1UvHDVTKSdMkkPhDCroFNLTt5zuBOqtRbDYM8v8KfyKXrrDZTIbs4/bMaxtFz5+Kb9v1Lab/MbQdAds4PwXSM+n+FGZtW1zzK4POuUWtQouC6JI4D4cc/J0ZXZbrvZOfU7GY7FqNFwEX805IxAO2wvj7ijxp80QgPQTryZGqe+V/dSzrIN4sESvuGaQuIudMN7ArtgJMaAaSru6MhboaPXt4udCN8MoZa1omjciNZpWfP1BoYu5xRVUUWR9yrqvDLWN+4Tc8DPSZ2AwQIRN5A3SevxqUzUn04luIEiq2gKApBxJdv3nWa0SdfaMfQ7Vd8ejaFVVztTqISzXPudnEavoSurFy4FeUCLv9XdbDm2uIOURvlmOkT1vdQtOAk1EaOtuG9Xf41Dac0D49xcezPZRf1PdJPsz9wu3WCCFmmPQNsaDBedYwWG2QNvdRmK15BLi8OwLzyB7B0RGDgZePzRUTnJu3QAO7moMeNSFIp5GvINfPR2mHW2AcjZdPqOZUTkpvrz4EVO8czuaiQxlw+bRA5c1Pis8213obQ2eBi02cQrYwhaeXIgIKZmeZEWRRy6LYwwp33Z6kWSfJ2mWr81qBVnWcy3R70Dpfe1W6w1Zfdc1T7WcsqAMNCTkPyZ76PgU5yPT+emX5LrmOOqYUFNEeItS6BeJGAgkJ55ew2Tw1DZZo26wZ+YcySKzAkmGLnQDHln2iPNiR3K/gw9mE4NVHOHhTYCIq3N52Ii2+AXbsiW/yh4PClYkyESFFSOGuM3LUnzOw1yaj1W+cefp/SEtOTLcqXBknXkbx3JIST0zfHx2PUuopKKWC0O3WTvpA42A7uk/Awxufd2CfMoCLCGsrW+dmtBQgmY8msM
 bnExyJD4
 RvSiczDKfhWb55dvWjXb8UzsgstxINCIHEa/rs69GVnzHSn+FXI+X27Fynmj5p018I4MBRK8vOt1TWUs9BGsEsw6dtSEYI+8/74GK0M/owJgbJ2a0UJB8tCunXiY8/UwHL1bkR0cAqDhfgQcVBHPrHzJ1OmFAnIieF7dMWHYRO+MgnfSjYH0dqOpbdQOQmVMbAykZ7EnltEGPu01lPlAMebhwM93N4Toizz1CyiqOnvOk3xho6wXMuXMVQCvfBbF9VOTuouyFFph4RcbmdLo7K1JEzarUqirRQcsrloSKGCVNnZHRfZJ//MvM0UGJmFVlpSq4E9AQo9Ltu/bwLbeyehlOrtOZpPiwW4TdtQnuufUEdnVk6Pz+dLd8M+s3bK5q+2hopR8wE5x13tU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, 01 Nov 2026 17:20:33 +0000 sashiko-bot@kernel.org wrote:

> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Low] selftests/damon: commit subject names wrong removed modules
> --
> 
> commit dfc99fb0f6f595e8bf824229e67f0b391cab2a8e
> Author: SJ Park <sj@kernel.org>
> 
> selftests/damon: remove unused imports of os and sys modules
> 
> This commit removes unused Python module imports from
> sysfs_no_op_commit_break.py and sysfs_update_schemes_tried_regions_hang.py
> in the DAMON selftests.
> 
> >     selftests/damon: remove unused imports of os and sys modules
> >     
> >     sysfs_no_op_commit_break.py imports 'sys' module but never uses it.
> >     sysfs_update_schemes_tried_regions_hang imports 'time' module but never
> >     uses it.  Remove the unnecessary imports.
> >     
> >     The issue is found using flake8.
> >     
> >     Signed-off-by: SJ Park <sj@kernel.org>
> 
> [Severity: Low]
> As reported by Sashiko on RFC [1], should the commit subject be updated to
> refer to the sys and time modules instead of os and sys?

Yes, I forgot updating the subject.  I will do in the next spin.

> 
> In tools/testing/selftests/damon/sysfs_no_op_commit_break.py, the patch
> removes import sys while import os remains and is used in
> dump_damon_status_dict():
> 
>     file_dir = os.path.dirname(os.path.abspath(__file__))
>     dump_script = os.path.join(file_dir, 'drgn_dump_damon_status.py')
> 
> In tools/testing/selftests/damon/sysfs_update_schemes_tried_regions_hang.py,
> the patch removes import time while both import os and import sys remain and
> are used at module scope:
> 
>     sys.path.append(os.path.dirname(os.path.abspath(__file__)))
> 
> [1] https://lore.kernel.org/r/sashiko-outbox-192115@kernel.org
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261101171630.81477-1-sj@kernel.org?part=6
> 


Thanks,
SJ

