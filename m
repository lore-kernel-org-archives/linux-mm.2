Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1E03CCA490
	for <linux-mm@archiver.kernel.org>; Sun, 18 Oct 2026 18:27:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A3096B0088; Sun, 18 Oct 2026 14:27:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 353C76B008C; Sun, 18 Oct 2026 14:27:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 246DA6B0092; Sun, 18 Oct 2026 14:27:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EA8AE6B0088
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 14:27:03 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 65B844005F
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 18:27:03 +0000 (UTC)
X-FDA: 85336578726.08.39C6065
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf15.hostedemail.com (Postfix) with ESMTP id 91826A0008
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 18:27:01 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WW8jGoly;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of aa9736195201@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=aa9736195201@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792348021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8nNlgkcX4wMrSryMAB7DXxwINAkHdxw6jSwpiwjtPcY=;
	b=javsesfSuWR48wUb94a/0CwenATlIj+ZEf4G+pg05TkSw7HTZ7gnPvWgRF0gf75xZypTSc
	a7shly3qR/NM3uiCbpe092FSWQWdziCeKMao6Psbhlu16f6dTaNBpGLLk3C+EOG4BVNh8X
	sxqa6KqM8Fc+Fhgr0vjp2WyAM2+lLBw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792348021;
	b=isO7rjZKdNswTyj2CSVS9BlIe2cFT4tWvpwlZuXDc1FjbSkR9oNQqM/Io/TcCvaUJVoEB+
	SgOa6QBBielnL5m2lUdTtkJ09SYbTbFO2eRu9ah3QKjvkp/QXjhRXtiQWGS4qnqGFKWez/
	UpWRvi5nyIrqL1yCHZ3lC9T8gF1xgJw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WW8jGoly;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of aa9736195201@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=aa9736195201@gmail.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2e8246b13cbso10910195ad.2
        for <linux-mm@kvack.org>; Sun, 18 Oct 2026 11:27:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792348020; x=1792952820; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8nNlgkcX4wMrSryMAB7DXxwINAkHdxw6jSwpiwjtPcY=;
        b=WW8jGolyyFwO2zBScFd20giHmo+VTRg6uXfG3sirCkldyDVy8RFfGJR/h/2xovWj4d
         sm6ozF9Ox6aKXXvH/AOvjXPDQwfBS7TWwiGEuDXv8N+iu4lzW0sXFE6BW9n6ok8NEjgv
         KR9RTR+SjgjA3Yn3wkGmlYlSKhdv/0mazaomfx+IzXT3b0g38lF2LFSgo9atmyMjuwTk
         +7zSYwvBV91x5QB99Xstic/LHVLeMa4kawyZ5HmnIDhqBns3qT4L5/q2uFkP1VrHfelD
         mOB8P+HrgMqfdcNKEFGCPCNgU0xxPaKga7qcW9k8zbTi/aGq0pDgbQv/M2lEjpKK2e4s
         3Iiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792348020; x=1792952820;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=8nNlgkcX4wMrSryMAB7DXxwINAkHdxw6jSwpiwjtPcY=;
        b=WfE1N4KYJo6Xn+RWfTFweEPD87Em4gOHUd3WfwnjvfDNhFcvnR4yJAHsce7rz2cFt8
         rwttcsAW1Q+jHFy+PrFDgg0ry7vKhSH5hplotsTC4NcS7Zct4GPy6fNKJEW6GmSZ3Dpp
         moxaHfjNMOLdMtVw2uMq0XQT15GqcTFQvwNxyLwDLrWaWbzGSdLjtgJqdpH58+zzRfqu
         zVe5G0fJgNWeT2i5uQKkp2Q5o5egpbXnxTZUt3qGlsmIO9ksdB80Uvk4BGLxz+jYnvjS
         zJUJEqE7heJciLsSNiH7iOkOruHO3zc91xdWb2tsqFz6UYUq6586t9jB7UQDrlVZbBr5
         X1dQ==
X-Forwarded-Encrypted: i=1; AKwUvBwrrgoHNOivnCG3Vyc88OKxKS8BlPXwR2BBGHkr9FabsKfHThAhipI+rl4T1pyaJQvW6YKuhA8pXQ==@kvack.org
X-Gm-Message-State: AFq9FYL6v/vFwI0liVT08lq6WlFYhmjGcf0bCzNq/4CaBNcsv1xGcOZa
	Gj3WqF1qE+xgsDglUCayPgeD8LcTq46rHdEhkdwXabiAMakQ0dWXqPSF
X-Gm-Gg: AYBFou2cbV2TEGIW1tCpAg1GJZaQE17g1pyZP2ckEXiJhOls7rLstvN/IoHFKo4Miql
	7dV9jQ5ZgfVQkSnqbDHxb1Urf/PlNMQ18xR4++IW4ISvAG3GmStREQ6DrpnHNOWkpZ1T8rKNyyN
	nrg5eVr7yK8mfW+lFDDtjPNHdIhvBqgvY3IXbQ4oNOHmPocnz3beds9AAoxjdJO8vZDhm6CpDot
	S6arwArfjGwFSj3nnt4EJvT0IMIFO0xQJYqZo/mBdLZ+oe/XbMEItgsVpANrT1MTBq+5OsyG/u1
	ta+hrRdLRLuwzmgZvlFEp+z1InvjQ6bxwj0QEES11wdqA23JANVsbkFWwmi0JagI/8201W9Ru+M
	TjC/e/NSSeOXtbelmhWkqkMiJwuiUmaMQh5LtMgQmnasSnSXnWSXqmE0HeOZTDP7GtDro0sRE31
	BLHSrOUomgArWZ2VQ6ZnGKj1kTqT+cMoRdkEX5pti5heweX/l2JzQvngyKjsWrecBBYVg0aOLWa
	WaZnsOWex2QTnnPDUSmvZ5Ha7G/Qoy1ACRlWBPtEI/COr8tMHSG0EZG0KlQLLrJDqILlZmRDwYy
	7j/Qcv7tsQ/hXQzZflZpkb+gYYDTrabpoMR2ug/uq4UG6k3yCeOAyTTg0q9HDL053P+D4Diz0Og
	BX4T6Rjo=
X-Received: by 2002:a17:903:fad:b0:2e2:c602:2072 with SMTP id d9443c01a7336-2e9a6c0275emr48223185ad.36.1792348020411;
        Sun, 18 Oct 2026 11:27:00 -0700 (PDT)
Received: from DESKTOP-TJS95SS.tail460ce2.ts.net (114-38-149-183.dynamic-ip.hinet.net. [114.38.149.183])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e97e83498csm30202765ad.35.2026.10.18.11.26.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2026 11:26:58 -0700 (PDT)
From: Yuan-Hao Hsu <aa9736195201@gmail.com>
To: Rik van Riel <riel@surriel.com>
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	Suren Baghdasaryan <surenb@google.com>,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH v3 8/8] mm/gup: batch contiguous same-folio PTEs into one refcount grab
Date: Mon, 19 Oct 2026 02:26:52 +0800
Message-ID: <20261018182652.691-1-aa9736195201@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260811025157.1632867-9-riel@surriel.com>
References: <20260811025157.1632867-1-riel@surriel.com> <20260811025157.1632867-9-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 91826A0008
X-Stat-Signature: c8dz8trfs9czqr89mtq8ucbmyjmghggb
X-Rspam-User: 
X-HE-Tag: 1792348021-540947
X-HE-Meta: U2FsdGVkX19EcnCsU2ElB0HGmQeMz3LpxjVq9/uxBq95/tmiFbJ1ShEVq7Bov+LPPc4jskvzBrcEqIqDifA9vqn4FlHdHKjBSn6qAnUaLYFoZUZGnW18yKRRa7ehyI8/MnEdNky6hq1GZjyQYy+Sm3nqnV1O0kDzfGeSsL3M2yYGaSklzg5ZoxgY2jgllKka48wQiJ7YSnoVIOvykaZgRm3DhVmceM40wWirsZURjtFy2AND3YfF5Dv9j90vWNqCx+U9hee7JjbqBeNDeTXrqjLdjToVEGM1yuFVN5pPPeo6yZ/lfd+3dZeL+pEkqu7NqkDU1yNigaoAijOxLnKAH1x31oahWerudoVwer0yavPc/iHT6iuqrw44AvVPRCR4cHMEMvzqjm5Fr3AyEVVBGa8D1/oliRvXmgOadDIOUTt0+GZNLpv//HTkoyQtc/+WYuhJHkjcbaVdwPm43PB9R3keDjz5XA2Th0jwYwnz6Na2YLdkgSwu509sL/p67R4U75JtnOYYC8uF+Tm/Nz30/cm7S3ZXxF99GBcRqWDDbEzKunBrOFV+nM+18YdNSe/CL2nkl4+uXD87WF2lic9l7/Z5XD85QRjEMkCGVwnEWlHmJLQzptq+GaDjSvkNawb0XBvdlKjGSpdTUNzhafo3k6QZTNg2uhQP7VunKpv6bFxIdH/iywOxyCaFHXXtGfc7zzgIa3J/OMuAB7uo3dB1JeGV2iGTAJFAKIKxqkU8mSrXyZpQpipaCrnUsY2cD/gVbPpbAC51Rdt/TAmCLTMDv7IfMwh1Nt6y3T+2coKjypYL9ehLxCzpA8Oz4W4Thog25M1T/r0f7O7kjXNyfMxYs98GtCdeltDJLlX5bCRJ0N5rD6Ah/viz7Q+wjDtqG3rukCWG/cnSEOoGChehyfqa0Jgiwfc8kV2FcqEIAJoQN9zSZU/ETxhw7/Irtqfr9eBg6n8MAAoSNzrz5JcYCn8
 p6OLd/Rz
 XRcuowJyZrnrbeSWnmEnlniE+8AlvytYQ/e0TAc5Z1Zl9bGvlQft7Y1xFWf0nyISmPcf/DR78TC/Ubu0nAl0UGz8247vF8/1QUK1iWTtEjSc/WqsUjTxyW0Ka2AaChXOc0kCFylPljVub1kCptJp7fjHKGeRiC07pwa/HbL2i1jICH5ilmnjg7XfpqvxzmdGYq11MnCIB5//YHltWEJyyz7r5HGD8/NC1Ca1FmVXlMrP3lfqzVlGNPPS32r4z0uJdCNHQGrXRFDsBNsooYt4FqRBI5JxRbfRJr34wOELQsicluTxEu6oOQN9BXGryc0UvBCr66cZXE5+QcSvrY+iiZhcpzdbdXvlHKi11Ma5GQ8eRmEsNFqmI8OGB/1Cs5K8IQ/T+zDlTyY8Jwyo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 10 Aug 2026 22:51:57 -0400, Rik van Riel wrote:
> Add follow_pte_batch() and give follow_page_pte_commit() a run length.
> Each run starts with a full per-PTE resolve, then follow_pte_batch()
> finds how many more PTEs extend it with a pte_same() scan rather than a
> re-derivation of each page, and the run is committed with one refcount
> grab. Runs stop at folio boundaries, so plain base pages are unaffected.

One side effect worth a sentence in the changelog: with FOLL_TOUCH,
folio_mark_accessed() now runs once per run instead of once per page.
On the classic LRU the first call only sets PG_referenced and the
second one activates the folio, so the old per-page loop activated a
PTE-mapped large folio from its second page on, and a run now leaves
it referenced but inactive.

Measured with one get_user_pages() call over 2 MB of freshly faulted
64 kB folios (kprobe on folio_mark_accessed(), flags from
/proc/kpageflags):

                       before            after
  folio_mark_accessed  512 per call      32 per call
  after 1st call       32 folios active  32 referenced, 0 active
  after 2nd call       32 active         32 active

That matches what the other two paths already do (follow_huge_pmd()
only calls touch_pmd(), GUP-fast only calls folio_set_referenced()),
so it looks like the right outcome.  It is still a visible change in
aging for anything that reaches these folios through get_user_pages()
rather than the fast path.

Yuan-Hao Hsu

