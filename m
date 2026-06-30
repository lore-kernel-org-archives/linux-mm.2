Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DC5AC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 13:54:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC7086B00C5; Tue, 30 Jun 2026 09:54:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C78516B00C7; Tue, 30 Jun 2026 09:54:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8FD56B00C8; Tue, 30 Jun 2026 09:54:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 93BE56B00C5
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 09:54:29 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 257BE1A04C0
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 13:54:29 +0000 (UTC)
X-FDA: 84936723858.24.00E6EA4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 89074140006
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 13:54:27 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oSUAkoI7;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782827667;
	b=OhQGMVWji9YolWHNERkYpd2XucL26FSYC6bThMYmNxsUzgwoznbefrYOjbDCiAzZkuWXjH
	o6LXLMHKzYW1exCGTplLcObZ3HRYRv1MUzgYmphte7KVBQ7zjEEgaOz1rZ1z7BgdFhSteH
	LOBBVCGZ707mH2c1uv8FdiKqqmAGVtM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782827667;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CHy8fj2QP/6iAOuKSIp1H18G7/ohn39wma+CasIr1vU=;
	b=HbIPko8Bdagc6gcepa6nhC3ofXgMpVEp/qOt41lqPcSaVVFivNam+XlpeABZVakr1FnUnl
	0bX+ZL73VhvT2OXZdWJsAk5swYcskJ7u6iTQQZ/TcfIPKdS5b+XrEE5zzEI7DxI22fkWiu
	KGKbSgV43KEnkJcPi+nBrqus6uPonGA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oSUAkoI7;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EC832601DC;
	Tue, 30 Jun 2026 13:54:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 681EA1F000E9;
	Tue, 30 Jun 2026 13:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782827666;
	bh=CHy8fj2QP/6iAOuKSIp1H18G7/ohn39wma+CasIr1vU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oSUAkoI7ErGNLSg3Lck+NnYPYz/ij5rUVR+wPaG84BneHSVRRmG+V0uj7Lau2CQ5j
	 mVeGr+7iwgaof7Y+1JStM+9XcJFwrZHxUEyhLCLa9SueuZCDMk3ZIGifpvK7HTLadq
	 DauLNyIszUIu69RAQPnY+2d/VjPKeL1Vf22sf3YHrLdjxZzCqDZpu9/k5PhLsgvRzT
	 zcUXa0oNQrC3UcXvsdLmc7aLEoOrVziaS7Txxe2goq8MQRsS4bldA4l/OwDJUMaJS1
	 m/5V40IwWMHno/J35TxclI8W5j9gTdBG6EC59Z+Vi2HdwgMS08gewarYDC9trl4e/s
	 XdhW5z3nQx7JA==
From: SJ Park <sj@kernel.org>
To: Igor Putko <igorpetindev@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/damon/vaddr: remove redundant RCU lock
Date: Tue, 30 Jun 2026 06:54:15 -0700
Message-ID: <20260630135415.90926-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260630130748.3908-1-igorpetindev@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 89074140006
X-Stat-Signature: 8sakjq3d8uwnt9ux6ggrsytrb1axgser
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782827667-506944
X-HE-Meta: U2FsdGVkX1/rKPGY9Y9F/RCpWT4pAB2mL1O61Q6C+/YLEEt66mZTzUspekVdvHfUGziguoAJtJdJwwT5grJLDfjXIZ3mu0FjrZSvhj/9NfjrlDwT9ZLVwBwrURZ/kc9fGBmkxM/+a0w3gcGYao46/MBE+Ly7qlWg4YMjo/nt7ZZCB3jhXkwk5VDT06BnrRRj7FFGEkaSMgdNm4TCl5SZKK4nM0pJpnSZnOMoV4Cy1i8hvzX65caf1vvq3q+4WgmBbFgpLgbK9X5/OEIJk+Zc2TKIyTu0xIb2di3Smf7Kka3smCY7+6RZpy+ceKy56Uwm1vfQ8aQkAQswyMl3c74R4h1LrTHZtH4CW+7eAbgXu0AcIg4+pxkb2xa269gvwwnaaMzGyaSvLMw/LPF7Pw33gmH2gYC3jeTb1VXmG3DvUCYt+rtpKXUrI16IrRtyKvprWZsssz4EMu0sDzJPy8neoogtJLEfiDlv3GFK7C3FZ9beqMwcNomrlN7NwBPwr207S75j3/MZI6m/+N0SILs2etACx2oycEaWkumDg5li1ua4rcPnyQBGUhxvw9Hr5LelmTjW6qy1ODIvtM9TOFDPeZkkK3sJmi8kvYY8Ec+XNsEclmPBKRPFIdZVqZaq65safg48JBTyB5whqqi7kV69rypauAqc6vCl+bmQjOPFUC/abcwPPhgBWnaLP45Qv94V0DWKVrsA9Eoeqkb6ZLsgJCZjKCEsaScAvJzkHF6YCUxy1XLcrCVWV8duKfqZIrV8dc7ydkYlNatBAO/1RD+XanpwjLt9Jz/mZCNYzH9nP1n0j47at2R1aqxZ53ZGhFk6O6mVBEatnVRGqdTk5GnBSw8S0e1nzmwWIqPqz7P8dnejiE9Qe4n8C6Ewi/zciYHmADXGNWVCr6d9krtoy0OUwS5qSOAtQ9WDdyjeyXFPkhnuU+1TUYdNjOGlZPLUNa2lAWJqZro34UC/azwTUJ5
 II/Pgt3H
 IFEmAsMmRocwEdWYAWTEHKlDygeY5RbOwjbbN7coJZAWgQoEezD3Oc4Kri2N8rQMSg8umH+az4aH2WbAuuPn3/g5Oo8ZnE77s6F4Ru+m8ddXc11j2OWGKdST/bE87rGLV0v4vV44uumg9YSl/M2EFuNU0iNPuXvQYGC+MAUsau6WrtFUpnpBXOqus6ocZFX4OSnj+6lSQomGeAro9Cn0ZIxIkfAO+EfzKINkUS9+56g4M/Q8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 30 Jun 2026 16:07:43 +0300 Igor Putko <igorpetindev@gmail.com> wrote:

> Hi SJ,
> 
> On Mon, 29 Jun 2026, SJ Park wrote:
> > We prefer using a real name. I show you used 'Igor Putko' as your name before.
> > Any reason to change the name?
> 
> Apologies for the confusion. I recently reinstalled my OS and misconfigured
> my git setup. I will revert back to 'Igor Putko' for the v2 submission.

No worries!  I'm glad that I helped you finding a misconfiguration!

> 
> > As Sashiko also commented, this may cause lockdep warning. Actually this was
> > added to fix it. Refer to the previous discussions [1] for more details.
> > 
> > How about moving rcu_read_[un]lock() to the caller test code?
> 
> That makes total sense. I will move the rcu_read_lock() and rcu_read_unlock()
> calls directly into the KUnit test code in mm/damon/tests/vaddr-kunit.h to
> prevent the lockdep splat.
> 
> Regarding the pre-existing high-severity issue reported by Sashiko AI about
> missing check_stable_address_space(), I believe it is out of scope for this
> particular cleanup and should be addressed in a separate, dedicated patch.

I was thinking it is not a real issue.  Do you think it is a real?

> 
> I have just sent the v2 patch out.

From next time, please give enough time before sending a new revision (say, ~12
hours at least?), to ensure the discussion on the previous revision is
concluded.


Thanks,
SJ

[...]

