Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70169C624D6
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 16:00:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4580E6B0088; Sat,  5 Sep 2026 12:00:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 408936B008A; Sat,  5 Sep 2026 12:00:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 323626B008C; Sat,  5 Sep 2026 12:00:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0F2E96B0088
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 12:00:33 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6E7F4803CF
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 16:00:32 +0000 (UTC)
X-FDA: 85180171104.09.FB2AAC1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id C49DA14000A
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 16:00:30 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VcBrKjn9;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788624030;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=89VEH1jA+TUS7OG0ti7yWtRT4B/NWJ99XSBJju01X2o=;
	b=0zQiq5+CinBw1SCjh3dtqMPKXph87/o9NB4h7i0WRguyvv8BBigckcLPz813rpb32Gb9mX
	ads7k0i/uGTQv1+5FeCJwP+08/f9Se0c60fn9K5sOhS2dzukwL4oEkI7kN7TB9bJPfQNJ7
	cpwbFCAibmnvrsmtzXQ4ZYOe79HMpvc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788624030;
	b=ADrbYhEWllgnBI0uvW3fYuXkGWMWJuXKm9K/uWH58QfDn513m0DaoWNnHiq5IRMd+mIff0
	A3NYGPtz1xR584cFRlnn3/m/8+VcpZU2RgHadKRvt83TVLnFEH7/4ooUXUehxubrirtRGC
	Tk75PfyXWGkDSoedI25wHeSimc7JkfU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VcBrKjn9;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 03EB1601DB;
	Sat,  5 Sep 2026 16:00:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60C321F00A3A;
	Sat,  5 Sep 2026 16:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788624029;
	bh=89VEH1jA+TUS7OG0ti7yWtRT4B/NWJ99XSBJju01X2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VcBrKjn9Ej/tOL8KDYW5hSi68gWX8RoSZPMmANMQ//eh+k172FZnozySil0GP+i2A
	 CALOl8yBIJAx5L0CJEFN9rfIP/Uq1piPYQU8zo1JwFnVJpfjN2iYBhdN3y37t3CQw5
	 WQCSbpdorZlm/t0m1xS5K3JwNp2yqTrmgMEXMWvM4sMDx2bXWmYo5+0OBbN325dN5C
	 Du88q1NLUJm0vvpdBMtJXltJPeWnIn2R93VlkOepqzJYOF6qcvH+ChhDWVFVEkrRyH
	 jbmMcbC7DHUOsuPxEknLa9C0buzrISd/KJtYe8btMljPhcVzXNv8FzBycAi+t1hWKs
	 3M0OoduEInBmQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	Nathan Gao <zcgao@amazon.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v5] mm/damon/ops-common: use a page-aligned address in damon_ptep_mkold()
Date: Sat,  5 Sep 2026 09:00:21 -0700
Message-ID: <20260905160022.24598-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260904002829.116381-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: durixpqisz8xmdpgifhbeoefcptet16b
X-Rspamd-Queue-Id: C49DA14000A
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788624030-122889
X-HE-Meta: U2FsdGVkX1/wsl7wplh5nxBlL6B+KsEjqcG4TkUvFZEeQz3Omqk0HEzvZYz6RN0ECocWqNVbrskbPd7yr0+5OCJwAcVCCug+LOKbPtVNXQ8QUhMYYHj2bJGVxnkuyOBLXt2vcKD/WgpL1susWTEkvlHF9cInyBMYvQjrEildZp27ozvxFR0y8UvDNM1SZ3Ioj8C691kf56btxHX7DbeZYYaF2sXjWCIreZX0FfaluTzHmITgyvkdWf2+KxHLgE5+8TxvIhzuPNEe0F5azES811+97siH1zH6vK7VH7QoPOeWEe+MHWxLI11r2DBbiFwZ8cX+eLwnKECqnfWMKo6gkNjlyLTYXzDZvuqmu/bfGJcaIqSm9qcSN1CGges5jjn2sAqb5L5dfC25OgrgKcur1artuAd6FpM5ySAnqUo5uEcq1P4JiTU1DQ9LlLwFfiDCMAIOgXj7nFeLwnSRNhyOMIrR6h43L6BbPAN9TTZm8bOPnLoIRtcM/TqcaRxWtqtvQJlsPw+RK11B1FudyYBD33fYl6xtiYul5U3ce5g27KwSYO4daA4LMHcs4LBM/TZGU4uWj8Vr8Qw4bvxTfwV9EGo8OWAh3CKUcnKCV/ltONlRKWuh5lPeTec/57BC0OOMF8SZy9T5BmgbVqzYgq/gDmak8BF3eS8M7NMROjLkb/D4+nakCIfWyZEcMF2u93sgrfRiSxVPaoMhiEube6EAW30JMJn79x1gMy5R91A9WwY/hUY0050IQ0dzAWiPzGaEsQK8zEQDQwzix04C5Km2+iKWMpQCEvI9Gs6B+6yeKx/1NOWu73s7zpUkxHUYE0UhnxOA1HEasj1cAsLInZ76RiLLoRkQknffY6i1kNFHtzjcKygfVIbc72RdPFzA3pFnt96MQL6SHCaOtEgrfLgIN0r8BLQHsVsrT6LLDhfFucyr4+Ao3W6yLnkEmWMQmg7+mTAlSYThqfCPjaw8Vy0
 9Wj0YdCN
 jVGrP7XBTPrL2Je6yCq9iChuLtgkHXexT//0xrngyjFvAd8Dd8bthh/3DoUTNwopPVYcHcIo2ej+amahGALj8qqtmYjiVwIOdVmgeSpkweU/i7BFuE1PwcaV2ouvuEODrNgK7R/kLfZhZvDWY/E65D1HyKGWbPYtws8ZEbeauagNNTGZ4GXVtdPdkVSXnzyW57r8jeEtcenTKYglyT71zFk2lHa09i8n3RJJLN90oY68ApXT3aK2ooyaZShm/qC8RiNgk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Andrew, could you please add this to mm-hotfixes-unstable?


Thanks,
SJ

[...]

