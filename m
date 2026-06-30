Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9F0BC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 00:06:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1B526B00A2; Mon, 29 Jun 2026 20:06:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF34B6B00A3; Mon, 29 Jun 2026 20:06:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E30396B00A4; Mon, 29 Jun 2026 20:06:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B33086B00A2
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 20:06:32 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 15E6E1A02DE
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 00:06:32 +0000 (UTC)
X-FDA: 84934637424.02.9CAA54A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8EF35100007
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 00:06:30 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=op2Qz5sb;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782777990;
	b=F088prifbXLYAQ0YwRcgGkMCZjW7qcDuzBVG2CgPiFAcwgp1zPB+I6gwLsk9hpWZKBi/Qu
	dQvDCYDFWrU3g0Ace8alizQhfnw+B17W3j+CcbcFukSGx9EUk99LCauV2PKarZwvtH5Wl6
	yWphzoDZaoe7Z7lMyqFwFIUovnx8eAk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782777990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wr0WhPYUR8JNxrzJzf7gHN9+IIk9NqnlvxkjdbY2WYo=;
	b=U06CeLR00K3UVTCxiQqgBYZxDv6Rg5Z6Ex//Q5yUN3TSUhA4EPVlSGt9LzIeKDxOpS8Xju
	tx3KAjCWNtzqx2Wnhc9EEpG8Pu9jv8mLQjGdmi49PmcJs3P3Re4gqw5gijJWl3M19b7MU+
	YK4GKibzCI/ztMaQrfSCzhlF/citq34=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=op2Qz5sb;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0A94E600BB;
	Tue, 30 Jun 2026 00:06:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8C9B1F000E9;
	Tue, 30 Jun 2026 00:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782777989;
	bh=wr0WhPYUR8JNxrzJzf7gHN9+IIk9NqnlvxkjdbY2WYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=op2Qz5sbAMoEgRjtESmf7VxN/alp731dgehGyYqOvxX+SYlu1zrmDu2m/ooESPLri
	 COenaZehUI35c1792BoWfzxnx+LUfL6xhUwhOVcysVA/mUB8lKUpU1cAvNI3p+To+o
	 VhO7dgNpFBGNfZ//6nYSXVqIPT9hRxSUUr8jPbc4gSnix35irf08d8ABfrEv9m83CM
	 qYv76/ZbvUb2FUqINLXl1RKUlnGeqeCkQUBTYcBIRNT7R0umdybdRfZl1VxAp7Q5PP
	 lYf/uoR0R0EMGcWFFQi7qg7AZFsB07Q+eElv7l5wnaiIzLqQE//rYuZmmX5nkQa7b2
	 MrakI1V26OeMQ==
From: SJ Park <sj@kernel.org>
To: Manuel Ebner <manuelebner@mailbox.org>
Cc: SJ Park <sj@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Randy Dunlap <rdunlap@infradead.org>,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] docs/mm: Fix braces
Date: Mon, 29 Jun 2026 17:06:19 -0700
Message-ID: <20260630000620.138992-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260629161156.90213-2-manuelebner@mailbox.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: hd8bc3mqnr8cx131smx5tq953qheewtf
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8EF35100007
X-HE-Tag: 1782777990-947687
X-HE-Meta: U2FsdGVkX1+Kzv+amZ5Ins80nWclex6GrdHKLTNnP0HE1QuLAulaMnmGJ/Jt9GMNOsW3phdBChw2vwPBrtdp1u2nh7DNXmQwVKMMBTf5wsjfqt4tUTVqYbD9rIWQgETYsLtcQnb1x0Af5WPE0Emh+XDC9Mfu2NV/3C27oVU8B4QbRXI1LWXPgA6vz0C2A1pejInTGl8B3NXYWgSivsefZKmuphPOsHfrsniFKqxc8EjwTkeMq6zZu565K8MvgpBnsSGH87izxO2yKYmDi8y4jaY8/ujxbVkcW1lmKC/Dts9DpVIsWe0ELdOLIzoeB/GqlZEhdn87LdNfXhUf7m3nioFudaWqfQqbvBttVIySFEW3+N/twc2C015ws0UzlbDdXdt/zL6wPqcZSNNyLCmpNkUzV9ASQcBldWBTl47MPGFqYYKioArahCBSEujhJpqtFxPJ7PYQFndjV69GSAu/DrbsEkT4eEyf2KeEhTzPBZtSaslmCzjW+xj3EjiA87C4KHYLirgLaApl/9lZFa4pN8Mn3PnmDOzsrEbx6maezfeKejk/5yt1lKpNuHPjvC6lHswqfkiRtSxCqiLxB80R/q1yDuyb2c69xbWcJ9Uuzqy16BSNMF2KzJpjD1oSOamDKSCONagcdDDVxSoC1e+kOGZqxVZX/UIguGfE1+ijSHiYt5JNrR4SyRajODJ0C/ePOH4gYNzFibLnpYWXTjQNNCN7MzA4aA//I2+/s4tbbOPN7utQEThz8UKP5DiwdkG0SlHP0wdR8ZIAgsFiSDfj/VcUPpeQj/7WQQ5HRNGCMk1euEjCNQBCZflWULttD3rMGxEY/PlTSh3UfmG7/pwrnORjVQdYDANjUOSC7CeUZ56nFCVQFpTM01HpdYzlvrrXLNr5b6+5rGOCmAUe7JGeQZfV4KzsBmW9LImvyBuAMLhUbNkCXks2mB4F0TxAg0BmMQDH43W2LDoMSbl0Ks/
 q7QUYunW
 coefthamEAUvfjL1HUxR/oVIDGPEdmUEQb+EldFeIy8KCcmcw72YiPpJPK/2mDL6DzvsnxFxD+drhqDhaMZbh3I742js9NiEHtohsZvuwZyEamDzaI35BM9oDcdU/YlGQ7IuPrtUmi11Gnilh3wIxCcFRtg7S+biPQ5nkO0XnYrNQoOZG5XZFOogpfIgaGNI15pl4uHu7xnC1pef/uquuw+RxSspzv7J2Xxmj2ci16O+moC74m+gCtq+PocomeNuKLw6EUojzVc5e+MiHOBpQHe8sXotZ1Gc+37Pf0W/mgfxz/2eUvX5fRXBamxGgO1SC2lAICBADwPN6vh91blDFtRV3XfT3fTo74Haj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 29 Jun 2026 18:11:56 +0200 Manuel Ebner <manuelebner@mailbox.org> wrote:

> Correct typos in mm documentation by balancing parentheses.

Good eyes!

> 
> Signed-off-by: Manuel Ebner <manuelebner@mailbox.org>
> Acked-by: Randy Dunlap <rdunlap@infradead.org>
> Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

