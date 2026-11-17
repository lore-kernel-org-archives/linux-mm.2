Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D15E1606A32A
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 09:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=F1+OUVYe
Received: by kanga.kvack.org (Postfix)
	id EFD416B05B5; Tue, 17 Nov 2026 04:10:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED46C6B05B6; Tue, 17 Nov 2026 04:10:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E12B36B05B7; Tue, 17 Nov 2026 04:10:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C20B76B05B5
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 04:10:30 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 31B33C0352
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 09:10:30 +0000 (UTC)
X-FDA: 85444040220.24.AFDCDAB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 752C0A0004
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 09:10:28 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F1+OUVYe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794906628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R3xjMAAodPt6ComAZI2yr4tqLZHgVn0+opeICRnPgFQ=;
	b=HRFetib6byl12e8Y8lvAgp9e7FV/iungMtRvRwg+uPPB4XRYIFHWbiChgQtopDeClzJBB+
	mwy75qJict1HMtWs+kjCBR3Cq8+JIx7PttOGn2PCRm+1yz1Vjyk8Kg2A+X4JZ5CQeu0j7T
	jBkzkrUZLWkopTyItSC9bokarh2CHjs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F1+OUVYe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794906628;
	b=eUpzaF3TVm2n/7JjO4gi7CHYpZmq/he7cvLyboAWIuEnj77j8O9UfHQIHEKrqPfEZkCIDU
	Fo7BTFfI/LRMqNt7XLbeZrMuGL9phYXNYzxtuBIBrz23H6coY6+gTG10j4QVh/9RUzDHyT
	uBzNnKkoR9QRQ7i65/X7b/1uAG6Qv2c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EADDD62387;
	Tue, 17 Nov 2026 09:10:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 893881F000C5;
	Tue, 17 Nov 2026 09:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794906627;
	bh=R3xjMAAodPt6ComAZI2yr4tqLZHgVn0+opeICRnPgFQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=F1+OUVYeCkol6ftrcrJuGaYnKqEUJVAZwY3HVnGUBskVzs/NkRnWDCWySGL0bl+yo
	 aM7JrMvjYhdyE4vwrAx83WgtN4P4k7vHcJ5QOoM8bz9JhhdzlS6awcU2YUCMq7K9d6
	 5aXBlHC58z6N/DjHWJwckfiKhCvypu/oSZ9llqTKuHrwwsWLVAuHSLdzxQTEUSkpbT
	 7OmlIeZsSHiHVnLFhe9ozqYWzkIHbDXHSWRJJ5uw7kPOD/x+S0QpSb2YXhqcy64VkI
	 0T9PvUFb0p+yEtWQxUsEEAj8nspU1X3lrjnFU8wAuFfKleirosh1sygjWTeA98vWZ/
	 JZ54Og9bdKNfA==
From: David Hildenbrand <david@kernel.org>
To: Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, 
 Luiz Capitulino <luizcap@redhat.com>, Shivank Garg <shivankg@amd.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Shao Mingyin <shao.mingyin@zte.com.cn>
In-Reply-To: <20261116-snapshot_page_fix-v1-1-8e425984e8d1@kernel.org>
References: <20261116-snapshot_page_fix-v1-1-8e425984e8d1@kernel.org>
Subject: Re: [PATCH] mm/util: fix retry detection and handling in
 snapshot_page()
Message-Id: <179490662325.3990.242767098070074559.b4-ty@b4>
Date: Tue, 17 Nov 2026 10:10:23 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Rspamd-Queue-Id: 752C0A0004
X-Rspam-User: 
X-Stat-Signature: 789dhie454beb7jquyd1y1wrzw4xm377
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1794906628-951493
X-HE-Meta: U2FsdGVkX19pKjKkWc1c/uyJo6EUXvBU1pHcsK7hkiEq+l1OH65JBdkLAu+hpggBBir0eTlrn9oFmaWRMPf46Kl6H0pBMrjebu2/S+D/eBdhhWhx0Vt4KPGkSxurKk7EkadH5cOZAdub+MLRtb1Ig62Hokr9Z5F7G1IZOyc22ykAubnYddd/sxEIDgs1u/vrGygiUss3SwHcBvQGFOa5uEE2pUTB3SbHyiBxH6gaJ4k6BtLamEuavYUVKPDXo+RFYJQdxOyCpfLyGjeKH6dgqy5Jscnshbynb6wxrDZtNiKiqbCYw5EQlRQjXM/22YY8JfZJxUvjFaRNbl8M4/H6hZATnZr17Zmh3o0M1IwqEh1RryTfI9qad2KKFGuWEIqYxuOt9Xt1HYYGNmglxepJ499vc3AI0dE3mP0oY5sLxzJg1AHQJO8Tl/+B1Na5PohC/fKErzv/UTWQ8bveM82s5I1B4wkneePS3lg+EV4CEaBqs1rbCmQ3S93gnGxPY9dHgJhp2+dT/OHhsO7Z2ILTElh6+sbwUQjferCH15cMvGoy8bB0gs5slYqyZUeIVOlGFHhlersn6aG3mzhkoyY+okighMjvGKzDlMz0ChmhvmSjK7nfFXSSevpBaGUrOytOKE22U4U/opp5l7S3hVwc05mKmxqYfZT28NKOWQuQRpSkolqs7nOkPmJdY4vE2Ohjnxm6pP1oQa77uVOm5fLMOz9DRZN2Ox0MkkpiX977NEyk9DEL4K9H8tP17yJtWu42Cxe8wVDPWztGadd9DHzwMJs00gi+w1eUZ4aDczrKWcSiAkAntAQ/4rM4x2k1T/3dyw3kgxJlp0PBC3GtuEudcCyV6gOeaQw87LamS/AAlK4U2laGuI3g/RE+X+5Yo08eL12ojLmbxiIWce98qjqGa1uGGj6o2bSw/bxVeZ+Xv6etNFJxvYzU7fgR0Vys3xB9gbyt28dU5JV3fo3Qs8t
 /De9ERkk
 hH8rtM9x+6I4BXswstJPKrfsiPycnQmMBeTEkwI2dvBx5sSRO6pceXVcri8jY913SVl1hAaM2TfRBjdihwhc1R/NLqXT1rkuIjNNsJwaP+qOOdyKc0bUouFYEpYc3ciYyXZiDZ9pYtkvcsvdU8rFKnhYouDMdMRgl6doxok99GCaX7zos0aMakyIcbfySAht0XMI7zmV2yQbQF9gjUwyxBLQ+xOSOJoiKLUrJ//f8ZRoTcE4PFdG5OpUxkfnKFfL3W3ZH1h9a/p0dEqJcSqweWXUiYhME+SYnaxo/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 16 Nov 2026 15:12:13 +0100, David Hildenbrand (Arm) wrote:
> snapshot_page() detects races with concurrent folio split+construction by
> checking whether the given page still falls into the folio. Unfortunately,
> we have an off-by-one error in there, and we should be checking for
> "ps->idx >= nr_pages", because idx 0 is valid.
> 
> For example, we might currently report a tail page at idx 1 as faithful,
> although the snapshotted folio is now a small folio.
> 
> [...]

Applied, thanks!

tree: mm/core.git
branch: core-7.5.misc

Applied patches will appear soon in mm-next, followed by linux-next.

Please report any outstanding bugs that were missed during review, so we
can either drop the patch series or decide how to fix it up.

It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
though the patches have already been applied. If possible, patch trailers
will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. Further, this is not a guarantee that the
patches will go upstream. If in doubt, please check the listed branch.

[1/1] mm/util: fix retry detection and handling in snapshot_page()
      https://git.kernel.org/mm/core/c/d172918d

-- 
Cheers,

David


