Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E70AE606A31F
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 12:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=a51umk1S
Received: by kanga.kvack.org (Postfix)
	id 05C9B6B05B3; Mon, 26 Oct 2026 08:30:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 033F36B05B5; Mon, 26 Oct 2026 08:30:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB3B36B05B6; Mon, 26 Oct 2026 08:30:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D2FD26B05B3
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 08:30:53 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 659811A05E3
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 12:30:53 +0000 (UTC)
X-FDA: 85364711586.20.BF4027B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id 5D7FD1C000A
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 12:30:51 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=a51umk1S;
	spf=pass (imf18.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793017851;
	b=E7bduqtlp3rH8HcL18d5qioupm9DoNyl9zNoECpp0j3ZdC7+q6lvp1GkpBdw9YwjcKBlVK
	DwqUEPNZ56gzARQTWF4mZWrAD/xHstwhXnx/9XizqiaVLBpGAPBsmBR6gM+EsecdB73RM+
	xt+0ywTUj3kW9x68zJz+AaoMxKwUAGQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=a51umk1S;
	spf=pass (imf18.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793017851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TRZt7x37p8LUgQOIpKaz3b3988dBzwRGltnd5ZVeEBQ=;
	b=xBgFLOF1JZ65+X5HZoxdvt1rW7XLwowGnVtQrKJGZjVY/vSDRYEF3372o0zTN+W3E0brl1
	iaO3tv6iVlv0WHYKjlNyGi2N0DlrhluRb0vsg6xFXU87iz2gNgpZI7XN0BPYlMyPy0b0Wi
	pqDgu80BhS9mzeMapRh+y2SVJJzKn8M=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2F3F025DF;
	Mon, 26 Oct 2026 05:30:47 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 16F583F7B4;
	Mon, 26 Oct 2026 05:30:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793017850; bh=X7sXgG5KeOSy1aHvYxzPYxQhid9EVso1C+EnXtpcXiA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=a51umk1SJn3Qg0uasCVQzZnOrDFKghUAEP7EkrWFXdPPNFIMzLLrV9N8cjkr3aGKF
	 z8GG4zNZ3Tm/0q6VoX6Psp3ZxfySUkB3fkJWOhbNWs22m0DRA+otCMqkcURphbPTl5
	 fFeWa3OFzRFlj5VqI9kqkZNToJ4SuBOlO68fncXY=
Date: Mon, 26 Oct 2026 12:30:45 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Zhao Gongyi <zhaogongyi@bytedance.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, will@kernel.org,
	Ryan Roberts <Ryan.Roberts@arm.com>, dev.jain@arm.com,
	baolin.wang@linux.alibaba.com, lance.yang@linux.dev,
	mark.rutland@arm.com, akpm@linux-foundation.org, ljs@kernel.org,
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] arm64/mm: restrict transparent contpte mappings to valid
 PTEs
Message-ID: <at9H9Vkx57pIcPos@arm.com>
References: <20261013093600.54995-1-zhaogongyi@bytedance.com>
 <daab2f45-56c2-48ad-a24f-aa4f889e4da2@kernel.org>
 <e0f60526-bb95-4d39-9a7a-72cdf32ca5b6@bytedance.com>
 <cc2e3af6-bb56-41b1-9cde-151797c3068d@kernel.org>
 <3b57c214-6a43-4fc7-a531-fb5eac196465@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3b57c214-6a43-4fc7-a531-fb5eac196465@bytedance.com>
X-Stat-Signature: af3agg6dan1znqucpyjnatyacowrrkh3
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5D7FD1C000A
X-Rspam-User: 
X-HE-Tag: 1793017851-311014
X-HE-Meta: U2FsdGVkX1+AOctzw2WnFI5g0UNXruN1kY233T4fxSXK1JE/tQhEzwSAhlUygoFXmdyBKEmekb6Tuj+O2gHniSEHIy4HGEq+1XRYLRJM1vQqiYBg/ITf0ODuEV3R7fx0t27WsQHny04zsw07Ouqy7tn/tXPNVuTkMzCLwuKq/L1vqurYSjFhWwlbRr/l5a6Qyc+DGhUvN5V6n2vXwutL+jUlqOEVxF4DCG7c7HLGczyQaBU9RL3OvMoVF7VmJ1UtrGkf2K9dT5T7MM4bZhQbqihOfOVcRdHuXKI6S3TFIqhOTZUxLRKI9eeeLT2LZQ3XdHKij7u8Dl9WjxA7YpJcS/RpS9YHooujubap4PaRH/geg9Y670bP0IpYiaRgGT7OZGhKIRL5LqwuwYLq9JKli4S66BlL3r0Qt7PkQ9Qy80a8IS0xtMkR2E/Xx2eErd28VDUqYy1S2pynk0QV9wn3RocpoUl5fG5CjRgFDH1sIsOuB1Cs8HSMyBDr//w00WryeY/8jURSNAonkzczM78j78TK0XErcN1+fAifMggTnosFq9wrFkAn6rtlJ9zED4vb3ZYZzC+Bt78+Z8Amnshr5qpRkK5CcEteLKAWlR9TsrHAmL/L7GdeinAO0gm4glHYfPkoKzRhV55uTqFAvD8Ag7YuAYyj4MhBs8RC+B0FgzZlZq8uhjNLiq6fna7xIziNmLBaR+6ihqvh8gu2uoTTnTm54Uo1mwbI66RVvF6hCCf9Qdaid4UWw2USCJbjJbkFaGenkYEJpPbw+5ikJJo65so+NqRaE+quJbW9KxuJxLbJ0QjU2uIG3PTn91W4Ba7AgHxBKbM3lEAYOToZ10DaOQOVsFe5U4wSVWzoOEkUA7t/FGQnaQa/EpRFDa3AQuidixI6n+AL6C9OrVhQuudTrAnXffxCsEO5weK3WcpKFk5Lx6bQ9FcSFL+wVhGbhPP1emiSdn8naOP+qF/sstQ
 RFGUW89w
 ZU9umTYZ+5RU5Tdd6nqm9rROIy7sg/I6nJXUeZc+1LQcthG+U4yA7gAvMF8xV9MdJ9gfEIPK7tturDRu8yhIVZU+hwN1/uLK+GUQvx3vU5c+SAhv5HcufA8nKBAUJMpQYMN/rqrfNafgsfQo7aBY00SQbi2c7T2T3AicHBA71mM1Lo75P2uGz1lLY8ofNvuqmxd5nfnFrtDpSNM3k53OfGYrnrr8eDsM/VGDnozOlJJBsY3ZxdyPREkSzP55GvbhCkwjvvXK/OFTSaUanNZSvIYFJeO7iFC9amYWPJlOpi5v+msVxNLjeBAhSnQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Oct 25, 2026 at 12:00:33AM +0800, Zhao Gongyi wrote:
> On 10/24/26 4:55 AM, David Hildenbrand (Arm) wrote:
> > If we have the spare PTE bit, why shouldn't we just use it?
> > 
> > It will make batching over PTEs faster. And we care about that for present PTEs.
> > 
> > So I don't quite see why the stable fix couldn't just do it right away? Do you
> > have a prototype that shows that it would require significant code changes?
> 
> I tried a small prototype that keeps PTE_CONT on present-invalid PTEs.
> It leaves contpte_set_ptes() unchanged and makes contpte_try_unfold()
> recognize pte_present(pte) && pte_cont(pte), instead of checking only
> pte_valid_cont(pte).

I think it's worth doing but currently not sure it buys us much unless
we also change pte_batch_hint() to cover such entries. However, if we do
this, we need to audit the other pte_valid_cont() callers (e.g.
ptep_get() needs updating as well).

So, if we aren't going to change pte_batch_hint() as a backport fix (I
don't think we should, it's an optimisation), I'd rather take v2 now and
continue with a proper pte_present_cont() etc. patchset on top.

-- 
Catalin

