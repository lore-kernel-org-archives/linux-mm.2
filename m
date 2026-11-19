Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EC03606A324
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 15:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dp0Jnkep
Received: by kanga.kvack.org (Postfix)
	id 537966B060B; Thu, 19 Nov 2026 10:21:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E8BE6B0640; Thu, 19 Nov 2026 10:21:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FC6A6B0641; Thu, 19 Nov 2026 10:21:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 20F0F6B060B
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 10:21:00 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BA78F1C454A
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 15:20:59 +0000 (UTC)
X-FDA: 85452231438.03.1DC0E39
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 28C2640008
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 15:20:57 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dp0Jnkep;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795101658;
	b=1BaWC0kFs7jBxvI1xP9KL1aAqbTnrAgwaxlusKKY3inf1Nqph0OcYLJevAV9//puTW87UN
	dDbrv6GW/T0iVHa+osyGsvQEAlM7LxFGYq3TWBXZ8ideEJlemwjpg9laMHTSiOQaodZl/k
	IuuOHj6cJgc4itPN1jphli0e2LJK9Hg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dp0Jnkep;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795101658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7aM18KL7g9kFBhOsujAA1/eBDc28glRs4JMmbTTTHu8=;
	b=vUU7eg6kLcoq8QJJMtAf0PaztBRZHlm0nedE0mr1+GP/ZWQzmhpsuc8Cs2r4ZEKWd+u5As
	HBJUohWHxFYt/0VoktWA1Nb0w4I8igX+wvbgnlDDbldN6jSo9d+OO/D1Qx9auCAjuyFGsb
	2NybqAhuuqwle0YmL/4mwyQchQup+tQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2C40162170;
	Thu, 19 Nov 2026 15:20:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0A711F000C6;
	Thu, 19 Nov 2026 15:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795101656;
	bh=7aM18KL7g9kFBhOsujAA1/eBDc28glRs4JMmbTTTHu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dp0JnkeptcPSMF4kD6ldncfTVFbWJ8cUqfmGML+1TU9k3gzMCIrkcI923XKR9x7VD
	 vAV6WmX8kgIW5/beBx3KLS8mbFZ0NQawgMCJrZ+t5ug7gnffZsVXqlYNdRKvkWsKb8
	 pEf6LfPxt7V9jfyMJpw+R+mjmSB1m0lAvGOFygx5nxEEe+6K+RYtnskCApUH2avDNV
	 4H1X29R7WTU46Y1M6UJSSnLd0tuV+PRQI6V8o5HkX7gm7ldwvkqyRYX0hOXcHcL5qa
	 vOk6U8HVOV55GHjsdudR/KUJMNvv9T7O91HS/T9RL3DTlNDzXddTno+idmn/5wjZum
	 gXTESz3lnelGQ==
From: SJ Park <sj@kernel.org>
To: Aveline Noir <jm5905938@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/damon/core: skip apply_probes() when no probes are installed
Date: Thu, 19 Nov 2026 07:20:43 -0800
Message-ID: <20261119152044.57386-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261119-damon-skip-empty-probes-20261119-v1-1-ec3e81c1f26b@gmail.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 28C2640008
X-Stat-Signature: c8d4kqc8n3anyzzksdh9s8undkfmhrn9
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795101657-334775
X-HE-Meta: U2FsdGVkX1/J8kObHOGrRWHoGCXzJF79HKybbutSx+5AR6Q5hAAN3tVe6IztVAdeEgxhEH4QdBD7yGEk219DEioSg4bCHeqGrGzW4PN+w6YiMrvJSJM9agtxh99IlazsE+8wCmb2nNf71Ti/tHSoitoFxHMvXd80uWpBfIIcr88Hi9XSHcPP/3PFrVc0Q+zToFGfBgjnVfN8lb5KklOGgDjgkAm0XIthUgcmS0PNDSTfe9rfsJfX7kP7H97w+VLWYKKGmGsJ0KnlaVMlJOXnAIZxfCzkKi2xcmmjpPgq0K8PuuSQ8YLqna5VQLDQqKJP8s1uN20xmduV8nKm3sC+vz6FOQDjIXHRIaYT8eUqtNFMOkcS8v96VrOjsfwILazbJ6J5EmOzEMIeNnXuOhOUw58dMaplt/Tt8DG14G4Gd4h4zqQFhbfQFVGzlo7WLEFqvsE6k9ETnHMknv0xSCCU2/0Zv/wdCE9JQK0Ocvx5nvTuRPRBV7HVzYJtn6CW3cSPi3MYdtqqjOGcx1J1bDBE7SdcJ4lIgnhu8qtqrxg3CaWZ04PsdIOy+3QFoOvogElnfyOJJ5gnL6EqrsXW2zianNG+kNJ+D9ZPXgsaowCFxlW9elPIoe0JTgdMDS7KnD1izMgmEOnmaPB1HwvThgxZDvzyzFOOpfmff8GLybv4N8GenowaOxoEXRpjnit4sHYKIgpKw3w9ukE/cUv1OR5gil0GtVGfg2cTwJ2zAJG+9jxShjinw6rPjgd0jjfee5/8nxHQ6iUZVTthszNcrZcsRMoIoHbB0EPQybYnWLMU3cPPWXFZdkG2U0ntPPYuwDoe+l+ezHjcifXcbM2rvszrbkdkP9zwuMAxuApZzJJ7M8dx3yRWTnP1i3fCwXx+LH4ZvvFOGXvi28RF2/Wm+NcC3W0w28RUszRAGYKWLr6rmJo6ia69zF7nRkI42GBdGt+V09zmbCCVOIqopVsSLCj
 hubjVZjS
 Ht0xD6VEFw+PszCzXaUA9K8Hgs1I1F77NUR3UbWiGfcIgCy1WqfEqNvncQsSoS6HfW7EkB4Y32BeSWqDQcHhIE92xHAncDryceXdV2zCMTVBprRm4n8BlqN3YKSsAfJP2nCEQrAUWSQqWVl6K6wb9TfoEDBRmHg11ELkxeVgnQ5NzqYZnnqOeD3B0DODhRGI3/4RFq6BSHC8KNcnZN4umOzMupC3SctQi5YCjCZwmAhkfCrsHOJnXkf7AdK9L6hoccU6oEzII5tHPH649nP2oE/U9skisoYYRqrnNopNjVh1W5kx/vq3A/JXROVjDuTzr8y3VpEam8PqkpeOsrpdVtccG2x2f+kwwyfrq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 19 Nov 2026 19:39:24 +1100 Aveline Noir <jm5905938@gmail.com> wrote:

> While measuring vaddr monitoring overhead, I noticed that kdamond calls
> apply_probes() every sampling interval even if no probes are installed.
> The vaddr callback walks the page tables for each region's sample, and
> paddr looks up a folio and takes a reference if it can. There are no
> probe hits to count in either case.
> 
> Skip the callback when the probe list is empty. Ordinary access checks
> still run, and installed probes with zero weight are still applied.

Looks good to me.

> 
> Signed-off-by: Aveline Noir <jm5905938@gmail.com>

Reviewed-by: SJ Park <sj@kernel.org>

This patch is applied to damon/next [1] tree.  I will repost it soon (~1 week)
as an mm.git merge request.  So, no action from your side is needed for now.

[1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees


Thanks,
SJ

[...]

