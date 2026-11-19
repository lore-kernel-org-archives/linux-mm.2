Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 433F3606A334
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 01:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=J+p7dwYq
Received: by kanga.kvack.org (Postfix)
	id 57C716B060F; Wed, 18 Nov 2026 20:48:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 553B46B065F; Wed, 18 Nov 2026 20:48:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 490A66B0616; Wed, 18 Nov 2026 20:48:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 24F006B065F
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 20:48:15 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 53212A05DC
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 01:48:14 +0000 (UTC)
X-FDA: 85450183308.22.A494D54
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9EFB0A001A
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 01:48:12 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J+p7dwYq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795052892;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EUrkXU3ytmku/9Gi8LQ4STzg3Y2OdkeFJfEpM5AGNUY=;
	b=aiIXk+2MR2metL1TErxV6OV/ntTt5caN8wKaEhZAVRi8lZ3wZ23lG33Pa9ngof7s9cbDaB
	zzbbByimb/mPEen3tvj0cWJIzXfTgpTW4o82bAC9wzoSQYulhF1dzBiSnasarwztHr08J3
	+52SvG9xCeR+nBwRtIat3YXXVrcFzMI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J+p7dwYq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795052892;
	b=p7ZMh4SnogLYsLqOsVNBMHSlhWLlKKlq9qm56+NVe8+GfVGXZngnXWZ8JeC5M+dNlyfARn
	OjjAv8S+Bu4nP+uFlCzeIa7A354E+B5lsESeOthteG5FcztiPlJlQAHLh718i6iIf10qlz
	RVorBbEqRDp1py5lYvmnWuKQHRu6eDQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 22CF6622B8;
	Thu, 19 Nov 2026 01:48:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FF051F000C4;
	Thu, 19 Nov 2026 01:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795052891;
	bh=EUrkXU3ytmku/9Gi8LQ4STzg3Y2OdkeFJfEpM5AGNUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J+p7dwYq2fqkBr6VZkAK+bNXuoQ4GhZRi/2VJ4zoGvcH3iBWa8sdK5xvAR9xWx0hb
	 b5CYiDazSMkhFBgQmhI/yPOwKWi51qEQV8JuGxKMh+IsMb7jT3Gqlj+a2viQ/kYgyU
	 wCToyXytCwp5E6f2pRQtuMuk1bCE6lnA+6TFqsLvcVlm1j7CeQxSuqZhdIsMH1QSYU
	 m9JsOiQneS1RLsN/EJNMtdhnOOqPfxFZ9KcB3CL0aH72LHMdECH1/gcVxDGnqJ5B6I
	 5chM4cA5umR/x65XsR0/nFnGncWaRqdl1CKma2TbJt7mMiS9momT4AZFsn0T5qg5G9
	 GOyJYom5MDR0A==
From: SJ Park <sj@kernel.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: SJ Park <sj@kernel.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Pedro Falcato <pfalcato@suse.de>,
	Jann Horn <jannh@google.com>,
	Mike Rapoport <rppt@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: consolidate the memory mapping entries into a VMA entry
Date: Wed, 18 Nov 2026 17:48:03 -0800
Message-ID: <20261119014804.120123-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261118-maintainers-consolidate-vma-entry-v1-1-8019b0e9928f@kernel.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9EFB0A001A
X-Stat-Signature: 8qbmi6a3izgt7nkhc4s7p4suzfy3qsf8
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1795052892-814188
X-HE-Meta: U2FsdGVkX1//T6ksdRxp1CwfwDfJbrEHHVBER+U/hNit7Fp+0tljXn9tHVXu6zF86CqrVgK+OgR6YfSFv8Fg2F0FzDpSh5GflhP6gfBpT3scD+zY3lh907/raRrJeTzJbhLO0YYOCyqvmGSGyqvL1cA/S38Oq823aa1G0Hi9WQgAMlt33uya7bqQiIlNqvaAtx0O3hjz4SeblH5CjSlt+SLBsOD/Com3eDY+R0STeKNFpQ1Wg2kBTOdm5Uq0AfLlq4ECVd6uDw5ekLd9I1+S0V5eCLCRFhPSo0MUe/RD8CUaMORANq1TgU0XH+d4xr7WFOjTQLaG2M93c5Czd6UXakcZKWV1+c46M+POKT5B7A35sZoudkp/Y27pR0oYpbyHmwCJUUP/6ufX8wUpILe9onHelxd67SI9EXxAcKcL0qvPCVkEeaKp795dXhkHSnrbnLRXs1CDMFPuYhC4gIZmfoPczjnm1pPu0PbmObT4NoG3y03vAHtjmMo2eer1AVysGvfnTWutJ1fktLLU6On+tEjsHMubehnVMi4MLv2e3li2qUU/s3VvFK/5kJUWpprY4kGm07lViPpJG+5dcFsT7XNZ5CQ7uMLRLEUlhE2vs/zChqVfX5VFFvP9FYUk6/UUA+Em0PMuIfC8wB9nUStX6bXQPveCJhmr0EjM0UfRwOklRUe9i/5GK87qwWfOYLhIWy2ksb106KGA3Fh/VTy5qu1+AmaI1BV8iio5Wb4OyuSmf0b4SfVC25KvY1sp2KSNxq7Vk5j6UzwfcSIY4AdEl/TKcd2o9iL60k3+nKKGeIKwIAuLcjikvhcaxxrAi0wrIFBjEw6JLmeBKNdYlqPNsIKBF45Bk8g4h3AFenKvXZ8sZsE05X4UfLKnh5l438+Bd3o7QD5jz+V61VbG5UO1m0cATAFr46GwIUvecXIfAQKRkbSz7FO43PylOrukc7x+WF34ee6tU019fpJiNKQ
 BNp+Up5y
 tsdbsynV/FPJw6l4tDb7PFpj/vzshDV5w6Ed3dcnTl0+u8ZegTQnnhxqqv8CRJgprTCAYUYhAlNhs8IAF5SMjAqiC2Vjxs5jFleUZbrBFM4cQwpbHMz5qDPW+xsEeEHmfsCMQd3qiDN3QqgXBWZZ8/LDM52xv+pZs8B+cloOejWE6zyjurxtDXJINhqYVGS0kaEwqUHFWpIQT2A36mQgDsHAJ+Idrh1ByiOySjzE3hHEGDbhZvTLXymFC8cRnGQDaDBpU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 18 Nov 2026 18:22:10 +0000 "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:

> Memory mapping entries were kept in three different sections in order that
> those maintaining/reviewing each distinct part would be made responsible
> for/cc'd on only those parts.
> 
> However this creates confusion as to what files belong to which component,
> so simplify things by consolidating them into one.
> 
> Expand Suren's maintainership to the entire component, as he is a trusted
> and valued member of the VMA kernel team and very much deserving of the
> position.
> 
> Additionally, drop Suren's core and misc reviewerships in order to focus
> upon VMA.
> 
> As David is receiving pull requests directly, make him a reviewer, purely
> as an administrative change.
> 
> Also specify the new tree location in preparation for the tree being
> established for next cycle, and remove the link to the not so regularly
> updated linux-mm website.
> 
> Given that, from next cycle, the tree will sit outside of Andrew's current
> process, remove his entry, also purely as an administrative change.
> 
> With that said, I'd like to take the opportunity to express gratitude for
> Andrew's huge contribution to mm, and for his being both generous and
> gracious throughout this period of change in the subsystem.
> 
> Co-developed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Acked-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

