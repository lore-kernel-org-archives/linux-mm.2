Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33B4AC79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 14:11:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E85A6B00A4; Wed,  9 Sep 2026 10:10:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C5306B00A5; Wed,  9 Sep 2026 10:10:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 500116B00B2; Wed,  9 Sep 2026 10:10:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3193D6B00A4
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:10:57 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0A2CCC023B
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:10:55 +0000 (UTC)
X-FDA: 85194410070.18.3D98B02
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 64C7F2000B
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:10:53 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R1mlK8DV;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788963053;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B1G0RE11rFuDv8wSwFJPMwA6T59xz3vA91P/lORF3w8=;
	b=oga4wLZ97q05mVOFf8zqIL5bH0R9AFhGPaFTWx6+vLS9EuXvBFqDSDY++PN/PAc7UglWab
	t/4x3B9p7RZ1GuW0yvzS42PXPZegInHtjLGjM2I6iCxsWENBMcmzH/uzJSKCRyWgYtFilb
	IhcH77oGxwDtsDx06KY+sb6UZxKN/MY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R1mlK8DV;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788963053;
	b=MdC3jurq6RvT4/DltFtOQVBufqKnVs2UEiP6pSUNx0GYA4IdFBNkNBX3UPs/5d2XBwuSOr
	M8fDDxPmmMHXxbzc/agslR8tC9qjvTQ0HWza+u7azUcgtk4dXS0D5CwhBBrbYyoyIbpv9m
	javPl3LJZgPM0lAXR1mtiEgRmiyJEho=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 072C06020A;
	Wed,  9 Sep 2026 14:10:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78B101F00A3D;
	Wed,  9 Sep 2026 14:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788963052;
	bh=B1G0RE11rFuDv8wSwFJPMwA6T59xz3vA91P/lORF3w8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R1mlK8DVE2PwiOkw+/PXbEwPI21LrBP20p7j9w8UB8vjSkz4wNAMoCcNY3JqrVsab
	 2tsWexYVhqmjeQc3ujZWA6SYioFZC4WB+fjA0OOa/M62Ch59BRMZb9/XiGSDYxPugr
	 uDSsjGy0qnDN/EFRxKLPOk9NAV4BSbMCrDIJxvpq3NwjJKhjH6//MfgCj2i5+8oHni
	 /eNwclIaDsuUgH4qTdf4+RgartRtTRGnmtI0Iwv0ATTX1O5US6KLMcIuG1EgenBPPv
	 sLJWWSVOc0OOrw5aXPSjAnZa/WhBuM7Iir0l8BfPQ6m0hOcvC/O5QR8346dGR6OyII
	 fVyUXLgzv7utA==
From: SJ Park <sj@kernel.org>
To: Kunwu Chan <kunwu.chan@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Lian Wang <lianux.mm@gmail.com>
Subject: Re: [PATCH v2] mm/damon/tests/core-kunit: improve nr_samples_per_aggr test isolation
Date: Wed,  9 Sep 2026 07:10:44 -0700
Message-ID: <20260909141045.105514-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260909070711.2448346-1-kunwu.chan@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: brntr93bgh6w47nt4pnxfow45ggbhnbn
X-Rspamd-Queue-Id: 64C7F2000B
X-Rspamd-Server: rspam07
X-HE-Tag: 1788963053-622367
X-HE-Meta: U2FsdGVkX1+JjbymnH0L8NO47FQFx7lUB8WoY+VmnXuZNeLBd0Wjmfb9ljDhaeyOM2+Fc+Xp1kUr+JHfzJCClUqBFH2h3Y26OtB9u8+2NpijDSRmMiJtb7eM0xRR6S3MwVO2PbNHZu+CTM5zImgMjnFPOchOH7eoC6PhfqjSjUvaIucOuLiDy+cYunR0NbT1cirk78c5OBIOsQxufduWyif4KtI3cxK35BUKD5vWEoImmlcHZbHLrk0NC/C98ygjVEEtnnNG7RfbqjSaYadyD55YRqf74GMfhaPVpySG8D8uUg43C0t5qntE1SWqe0qppTtVuWQB74q7GN6ki7WRbpw9CTXy/PxC8aySn3qyexTfiBnD7Vu/Vk8IJHNLN1jsC2+9eRgAOTVt9xKsT/ojlzrhih8wIO/p4yaehSZLtN5qkVNpSZKXbw9eiq7wzMYE2sJMSVbJFBF3WSeIUQ35Pc2GCej9gbzatJQ5uvA8J1mtN+Er5DNKJRseYEK5OLOKsZfVJKyCLsWln8f3mA1osW1Tti+Ah64L5nXpHN78dREDGp6b/JVZPb/2i2lFcRNRkePY0YX9L26nVYouDp5LxWw5J4e5sNkRrA8vEydiO/QVt7NXiCq9SeSkLzAAL/PfVYxMAbdjJRNrnlTBhJHSH7y2HlU7pHsYvLPpOlzNagJeVUq+hHFjPV4iYBnU0TQuM1H5lPI5wMHHiVjMaNXGRpkEHu0/poZWiyCMLdAlQXOhqphV3ACrF156z04Id+KO4fTj1QnQu+Jb0As9E6d2H4kqJnrySfAUQ6l4XEqinKr1hzm+74PV0v7snsIagZbfZPb1klKQLhyw26oT8P6KjBcq2OZEghE2csfGdJnvCYzOh+by0lzzQ8bLRlz4VRq2LpmJBBzrUTQufBP3+SI8M5fyBUJ/vgXH5fib9xKd0I2CHm1zVp2thsr6gt/YlTIN9/6PZ3T5JKbuJvy8Hx+
 zM0IJoKa
 wbva5eLNEC0Otz6Qq8WnFZcsFSqxvLJXxR4izJMYtPYKzOg3o78FLo+4ky7RV0VUMAM5BJYng5e+O2+yRLAREPyATapD0j3z+FgJICPKTxPAVLQ3YJz1pcf/tX7LBIEAnLrhr99WtU/F3BRQsGX1hfrkA3RPL8c5zf6H3jrutFIYojNlxgij/irmJwjcBia9AAxipCU49k1FhE9wzEYYDYl7T/3bGAkr83D4H3SZcB2fQorq949NSU4WtadCDCx1RRsKXhmdfGTAdjLe/alwctopcyHtPN1myrNJf7ReEUfo0aZ2xRS52QHAAHZyznS/fbmZnr9zXruJ9E19JnV0Q0c5q84k2tD0TMBupJD6IsDsPpT8NpMsjeAnsvzuwN+kN/NZxsY6ptHx4JjFEh5l24+yPNw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  9 Sep 2026 15:07:11 +0800 Kunwu Chan <kunwu.chan@gmail.com> wrote:

> Test the zero sample interval case with a non-zero aggregation
> interval, and keep the zero/zero case to cover the zero-result
> fallback.
> 
> Also make the overflow case use an explicit sample interval so that
> it does not depend on the zero sample interval fallback.

Thank you for improving the test.  This looks good to me :)

> 
> Signed-off-by: Kunwu Chan <kunwu.chan@gmail.com>
> Reviewed-by: Lian Wang <lianux.mm@gmail.com>

Reviewed-by: SJ Park <sj@kernel.org>

This patch is applied to damon/next [1] tree.  If this patch is not added to
mm.git in short term (~1 week?), I will ask mm.git maintainer (Andrew Morton)
to pick this.  So, no action from your side is needed for now.  If it seems I
also forgot doing that or you cannot wait for my action, please feel free to
directly ask that to Andrew.

[1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees


Thanks,
SJ

[...]

