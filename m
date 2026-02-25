Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DFD3F55437
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 02:20:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFE876B008A; Tue, 24 Feb 2026 21:20:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCCB36B008C; Tue, 24 Feb 2026 21:20:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF9336B0092; Tue, 24 Feb 2026 21:20:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id ACD116B008A
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 21:20:16 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 47FE558C88
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 02:20:16 +0000 (UTC)
X-FDA: 84481374432.27.09E80B8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id D444F4000A
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 02:20:14 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="jiKF/K2T";
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771986014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nzdlt0nwDF8ik5PWk2sbZJomxnr1P4f45gNPX++D5LY=;
	b=glVhyQap5KlUAB0FChhEh2FfBwIaTEDbwvSPPOfEGeV7vSLf5pFoPBrHkSTkf3tJnCPvR2
	Ck4JBuxbgER4QKo/DRZ7G9TQhiVbjpuFtlqxQAc6/mnqMJSIZ6SZJmBtcE98CywZfz12QX
	eglULBM9pWGRM0qmh10ABsq7qzlPLc4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="jiKF/K2T";
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771986014; a=rsa-sha256;
	cv=none;
	b=dfZsVxEStBwMSoAl0Gqk59A753BXepLF3lqe3t/YeR9y3al3c4kWvNh6YcE+XqhN8NfC0j
	dyF3QxWybshIh7ZMWz/MuUQvF09gp3eZ3h38O1lse7R5e4X0EyD+r8/WvTyCY3/rRWd9sm
	6dqfA4ZBRE82ghtNmrzi5dutX+93wnY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 24655600AE;
	Wed, 25 Feb 2026 02:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58A21C116D0;
	Wed, 25 Feb 2026 02:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771986013;
	bh=XyqpMwamYA5lYABslMLEGD29LgjL8i6ehyfSd50lnn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jiKF/K2TFJl1pG18BdvcxbxfLEtRm8h7SE8vqoy+x52pTd1k/el/OeUNw8yvm0M1/
	 uDIkvYXYvd8xh1KM9OS8VXM6M+jQHFR/+CVbh1hlVvt5fk+dTSX1k7RrQ6KdNs8Owb
	 goeft+JLJtTofPLdv2RYLfzIy+Vcm6C9ugkmO5g4wie5hvLFKzjWln/rjyKlZ+UHoh
	 B875aPStUNB1tSER9gCLoZtvtxvjstN6c917yHVO5kONmtqZVDRhnIENUL4+P3kPDF
	 x6Dp8pae1Pzdn/CMYRphrl1zYIihZwSdSCWjlFpmmBp82n7uxNxmLO83317B86nDQe
	 0PAmQlqKcVPVA==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Ron Economos <re@w6rz.net>
Subject: Re: [PATCH] mm/cma: move put_page_testzero() out of VM_WARN_ON in cma_release()
Date: Tue, 24 Feb 2026 18:20:11 -0800
Message-ID: <20260225022012.62985-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260225021845.62875-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D444F4000A
X-Stat-Signature: rxjjzd7a151byip4xqq8mjm6nw5wp4w7
X-HE-Tag: 1771986014-675190
X-HE-Meta: U2FsdGVkX1/qvJ9fZVcacKoJMMV9v1ga+RGM22CSBlI4knPuyZq4M+NYMGHN/umh0N2jJKIL2Cdes1E/g07IX0woSikFWyzErMUM4FBuVWBf2zMHUnC3cKd2a03KDDmM1hbxMPRR9R6/10MHKa+OeZ001l7P7Pkq6enLGi0YbG7WtcLdH2jmATQrJoCBdJ6AZsxGhVXOK0Utijc/QzX1EROSJ3EYOlqPRxjrkuxCzXFs7zjRgYxN+7iNN2iESXIptbIZvvCZFQEAan6JntJXKZxaSAxnguA75z/cKJdpBftHtteQRFqtE0TRbW9Le5s3wLp1RrPB0dJUCBZxX2cWFCaivJBgnCSZ1c+UDAKjZoDOJ05UythzMIFdJcdXYYHcv8ciMB8DiFMAUB0O9wF8sDjRpZw08wvuye4/04zzrNq+jyNWwjh2v14C4p6bwLxA3Hl94E7QjhPO3/7zSBjtcqLsr+zfDgr/C2AVSr+CQyTO3yXFPUtPRm6GRFD2ke8a3z1nUFDaWYmloPPfAqWfEknvX7OYWsPk4zhwgodRPxmFdyS/6TgF6WEAZTso4VUtx9wov4UBP2KXf6ep79qYrHB2xqtxWeO/pxHCLlWRympKBqhC3wkmTKI94RuFzC1b6m6jyoe/HKuSEFXyUzAgy3/qKyDwKGckb+zg57o7prBHLhZTEpe7JyyOb00a2skkiBrCnVSvf9zJ0Q4cKU9LnmR5VWmOfQ2iv9qlP6qkBILuLOSYv3ReEsnnvjrz6PSyUMGUl/96MM5A/G15hvB+n5iMSA4j6xNB5Vemi7b3F6PnIiB9fr0xVfe0cJTKEYKFaODy+gBqA2McHSMYwG31smNYpYL+GX/Eanz8i4eKbSnr5zXVAUaxyqp5i+VaHtbHq+JXvIPfe/XQh9Pd5i/odkiCUtAfj9K2gF7YLSTM4aTdSt8qOountd8cpK+ApgcegcYWtxtpUDU/7BpwCTA
 ZLpkc5U6
 Euv3O
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 24 Feb 2026 18:18:44 -0800 SeongJae Park <sj@kernel.org> wrote:

> On Tue, 24 Feb 2026 16:39:46 -0500 Zi Yan <ziy@nvidia.com> wrote:
> 
> > When CONFIG_DEBUG_VM is not set, VM_WARN_ON is a NOP. Putting any statement
> > with side effect inside it is incorrect. Move put_page_testzero() out and
> > check its return value in VM_WARN_ON. Add __maybe_unused to the return
> > value for when CONFIG_DEBUG_VM is not set.
> > 
> > Fixes: 9bda131c6093 ("mm: cma: add cma_alloc_frozen{_compound}()")
> > Reported-by: Ron Economos <re@w6rz.net>
> > Closes: https://lore.kernel.org/all/1b17c38f-30d3-4bb4-a7e1-e74b19ada885@w6rz.net/

I forgot asking this, sorry.

Should we Cc stable@ ?


Thanks,
SJ

[...]

