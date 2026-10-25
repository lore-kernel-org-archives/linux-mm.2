Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18997606A31B
	for <linux-mm@archiver.kernel.org>; Sun, 25 Oct 2026 17:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Orn4yYUx
Received: by kanga.kvack.org (Postfix)
	id 1D1DF6B05B0; Sun, 25 Oct 2026 13:46:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 182C06B05C7; Sun, 25 Oct 2026 13:46:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 099776B05C8; Sun, 25 Oct 2026 13:46:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D2AEE6B05B0
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 13:46:57 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6498CA0483
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 17:46:57 +0000 (UTC)
X-FDA: 85361879274.21.41DAA8E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id C5CEA20008
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 17:46:55 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Orn4yYUx;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792950415;
	b=A0w6baqJ4PdgnEPIsXDI1Ajqx61fw0LVqx/R07yebHJt7gJ2QADuuN7SlQClu5o0Up1io6
	/kDf/pFOFkAy6iu9zf5GWio+L3frjr7geGYeZlZWqNfbvsH6vUoeMfEBXQIZYPymSuxi+t
	XBq569Yl3Rjj3VI8t7+Jo3ojnSg609s=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Orn4yYUx;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792950415;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bAufoNrYjBpv8soDMVz4gw6z9qVyFbxX6lvDmVDSc8U=;
	b=QZ+JPu3QR0flgRnVqQutCY1eLaoXN5wI27w/+e9WX6IQR9g8d/3VPSVG7X12iIe+0/ssas
	vljKADCfPFjgswWAoydiZIpj+h2n58G91Lmv0FzC3IzbRiICY2yme9Z9GNVfbFpnyxWgA7
	ZPEqK9ql8GnseMbWzdhf87v1wgXkWzM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 586F5600AA;
	Sun, 25 Oct 2026 17:46:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF4A51F01825;
	Sun, 25 Oct 2026 17:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792950415;
	bh=bAufoNrYjBpv8soDMVz4gw6z9qVyFbxX6lvDmVDSc8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Orn4yYUxVQAf+rb3mcBcf9FcX+InyQ9gvp6Wym8xXBBOuurayefwVEqnLgDHb7liz
	 4nnLLaOv9GgQDJ9+XSn9N8DQAtCrYMSF7uTC8uhu7hPvTihAavVIhULWn1grlUZuvG
	 dyqg2ZfvVCH0bwVD5qg6zb7wDQPlOvuqixyZ62z85o84JNJrzvVcPwdFB+KQX6pzDH
	 mwkdqcL6OHbkefO1yO0NmzN79/tm7pGW7B/UBwcsPquQavTMH3CBWotUDDyd8DwXo2
	 MaYP95jK7Cg9uAoWnJpKbG6syPVtTHXx4d54IKh6PA6IHhkERtzk8lLAtUw5zAH7kD
	 exfgHHU/1Flnw==
From: SJ Park <sj@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: Re: [RFC PATCH 7.2.y] mm/damon/core: error damos_commit_quota_goal() for zero target_value
Date: Sun, 25 Oct 2026 10:46:46 -0700
Message-ID: <20261025174647.165255-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261025172434.161597-1-sj@kernel.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: C5CEA20008
X-Stat-Signature: n53nx3shjcibdwpor3gxkbqyd47t11w4
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792950415-307059
X-HE-Meta: U2FsdGVkX18TwaNyP2z5+fqZzZ5+l3GWmxERjqff625KXs4bjrkq63pG3TPzLg1zOz6A+KIZiLeFd3F9aHuCX62k6reSpe0WwDQAN8AEMKCFZ5jJf9UVkz3S6ZvmFK9hccNNmWEoHsip7/u3MqI5jKsrK//hoqr8Ue88bKmnOsVplllBwKqZIwEIAgMZxQdJTUHUh0N4awGwNLBr+hRqSqgVL1Bfwys6P19bq/0xqapDaAE20Ngp2iSgUqtewblWvEoPkyu6yFt0Fbc59rCGN0kYOHIehflRrz0cOe4jl5o7FaGW1c2TO0dVw6E/kX1DKTyiHfrv2VHKtlM+0v/+u093/3vXsrFCmzG5YHqkBb/2+2EAVq7gAZu4gUmjRbitzojcsJFnEOz84rflu0FilcEfokhkRC+6it0Y0ZuVZWd1gKc168s4ZU8grOBR50G2reWRzrcSFCmB1dQmju2mxd1ge7HX90FVzZiY/8Zgq/MZHY6Lj8VwggINyTPSkG8zhRLIpGX1184JepwGnjCn/t+ohUysV+6gay0dBJO0ByawB4R4BRGAARoV+Ynkt9iQiKtDgn3H0Z9CKVifKZdNW0qc+AEQK5kwRTF8YLz8PFS/z0ER0IPZtCzEgw2XbmHHFYqCPSNkkKxSZgZrRMMAdiT0Q0RwU3UHr3BjkR3aM121ynKpdLwhHfhAw/eqvmqBdGfdswvffXsEMZcvIUf4pQIax3D6/H+veBix/K1SVUAitquKKUAQT2tR/V3px/hpBX+roGHL1r1whJ6cppwR6PXM6Gh26pfWTuHCEE6XYs7P0ILFRxFDo8d4rED5eKQ3OsNkVjNEOzLlQImjvO1NDWIjWP0hySwR/PbUqMqfRhBzJxvP8UivJFaI34SoyeyRJ8hFP3xipQDi4yrb0Fpz+1mRkCaoyoJTX9b6zCO9dwYI3IWifG3HDfV7on7q5xivHsgevqmGRrd4R2Jy2Bk
 nkEDhQfR
 aZaGz8FVVes5QjebApVm/tbYI2+1aaUguR6XEeq7q2EzrUvPTANa+SpEnGWMkCIB/sflFz1bffYQsrm/KYHp59pbaCiAdppm757TEsNFN2D5NLYQIyAHf4ERZCkFoq5Yd0sXmqVW2XXrlY6wd8+T/qzl8FXPUlcMF2CZs8D+rVVS+7jJo3WfAyaBPb2O6MiyLms5j+ktZZf1NNRq34LNnTOEiviHO5MJX0ghDfVHXdYebdev3dHqb5JeCyyQpulX6RZqxSWG58usNnK5FJKRRZKPZ2yZSJ/hnWPowjWpHXgCsDdXvbAOpN/tBv3QC+PL7jy7gP29ZWr2vlFpsKhTNOzjK2g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, 25 Oct 2026 10:24:33 -0700 SJ Park <sj@kernel.org> wrote:

> Patch series "mm/damon: move zero damos quota target_value handling to the
> core layer".
> 
> Having zero DAMOS quota target value can cause division by zero.  DAMON
> API callers are checking the target value parameters to avoid that.  It is
> easy to make mistakes in some of the multiple API callers.  Move that to
> the core layer.
> 
> Patch 1 adds the corner case handling into the core layer DAMON parameters
> validation logic.  Patches 2 and 3 remove no more needed DAMON API callers
> side handling of the corner case in DAMON_LRU_SORT and DMON_SAMPLIE_MTIER,
> respectively.
> 
> This patch (of 3):
> 
> If a DAMOS scheme has a damos_quota_goal of zero target_value,
> damos_quota_goal() could trigger division-by-zero error.  Hence each DAMON
> API callers should do the zero target_value validation.  It is easy to
> make mistakes.  Actually such bugs in DAMON_LRU_SORT and
> DAMON_SAMPLE_MTIER were found and fixed [1].
> 
> It is better to handle the corner case only once in the core layer,
> instead of multiple places in all DAMON API callers.  One straightforward
> option is using an alternative denominator for the corner case in the
> damos_quota_goal().  However, the zero target_value is meaningless.  In
> this case, the quota goal is always evaluated as achieved or
> over-achieved.  The quota will only keep being reduced.
> 
> Simply avoid using zero target_value by adding a check in the core layer
> DAMOS quota goal parameters validation/commit path,
> damos_commit_quota_goal().  Update it to return an error in the case.
> Also update its caller to propagate the error.
> 
> Notes for stable kernel porting.  The upstream commit doesn't have
> Fixes: and therefore not ported to stable kernels.  It turned out it
> fixes commit 8b549a4fd3c5 ("mm/damon/sysfs-schemes: commit damos quota
> goals user input to DAMOS") which was merged into v6.8.  The user impact
> is a race condition that can result in divide-by-zero.  Hence backport.
> Reproducing the issue requires sysfs write permission, certain DAMON ABI
> usages that are supposed to be uncommon, and a rare race timing, though.
> The issue was discovered [2] by Sashiko as a part [3] of its bug report.
> 
> [2] https://sashiko.dev/#/bug/linux-7f814c9a-986f-4103-a55a-ef9537dcf62b
> [3] https://lore.kernel.org/20261021005234.94107-1-sj@kernel.org

On v7.2, DAMON sysfs interface calls damon_commit_ctx() for validation purpose,
for parameters commit but initial DAMON start.  Hence this patch fixes the
issue in parmeters commit but initial DAMON start.  I will post a new version
to cover the start case.


Thanks,
SJ

[...]

