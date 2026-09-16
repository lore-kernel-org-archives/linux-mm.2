Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45D9FC88E7D
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 04:42:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42F626B0088; Wed, 16 Sep 2026 00:42:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BAF06B008C; Wed, 16 Sep 2026 00:42:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A8B26B0092; Wed, 16 Sep 2026 00:42:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0616B6B0088
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 00:42:02 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9EE0FA5BE7
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 04:42:02 +0000 (UTC)
X-FDA: 85218378084.24.6478219
Received: from mta0.migadu.com (out-155.mta0.migadu.com [91.218.175.155])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7AB0F80005
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 04:42:00 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XFl9vTiM;
	spf=pass (imf02.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.155 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789533720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jMPrE7snG0MLaQ8uHTyTD8lbZcpyzSnhFQ73TGfwWEo=;
	b=vIlzKnv94W2kQ4Q8mCsHpoS1J/NvPlX6aD/FYyRyfkL1cSylaGDLCnkWjDBHD/foCr5sTL
	5E6hhEyd5rg6oMHE0yGxQZHWfI9zIs+Q/jAHnMZM9T8592xiXyznDYzXSpIRpTBCOMrJuI
	WkOE/OXq/7Vol9464V8KFAkbmS6RKVM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XFl9vTiM;
	spf=pass (imf02.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.155 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789533720;
	b=KVDAc8NHABotX4czXUEu0ZWIXS+WMkpBBkW5+1PotYQzX1tGEmWQ26QNNDR9kVzAHOPj7/
	4eLYBz7Ek7eds7qdZgHDsE4/IfNXXS5tdos5q/57+6gSmrwOsyVrQHv15lW4acK9ARL5ZB
	rtBEGLqaM6rrLtZeqIIHibY1eNIDbOo=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=csk+huPoq9Uf1TQgms2r3QUbeMYTjSPHnReXbJBHu7k=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789533718; v=1; x=1790138518;
 b=XFl9vTiM8k380r/49IwlQRxFiBRp+w7Y+TEJpXNnNS9YvYfG9x23rK6m3T19S2etFDj6/xrj
 S3iMeyndPYEiHlMR2un3s4ewiLfrwPGhQhaEsMNRzF0Hipy39MoDqkzaXxlX+Ho4U9kVbF5MI8Q
 +kiLM85QvyTXiwTuZIje8xng=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 52e16c50c9bcfb05;
	Wed, 16 Sep 2026 04:41:48 +0000
X-Mizu-Trace-ID: 52e16c50c9bcfb05
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: david@kernel.org
Cc: lance.yang@linux.dev,
	akpm@linux-foundation.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	usama.arif@linux.dev,
	kas@kernel.org,
	ljs@kernel.org,
	surenb@google.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH 1/1] mm/huge_memory: fix pgtable withdrawal for huge zero PMDs
Date: Wed, 16 Sep 2026 12:41:42 +0800
Message-Id: <20260916044142.95044-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <83a1287b-8589-4408-96f4-4f78dfca1bc9@kernel.org>
References: <83a1287b-8589-4408-96f4-4f78dfca1bc9@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7AB0F80005
X-Stat-Signature: 9n1cruw6tu868tekz8n8c6juuwzt9r6s
X-Rspam-User: 
X-HE-Tag: 1789533720-503685
X-HE-Meta: U2FsdGVkX1/KrYCRAcKGKasI/TvzTT/eRwfQjvdMZqr4NdYiZmZBcvcXwjmXGcJXAE3zoqDNKLH34bAZyeB300AOvFhnhHtnGFmMOA+6eXqs0b9Eq+WU0SFrJ+vnlpMqIAPnNmEBPUZDFU06U9E4OC0En+MfCEhocc0bdaKwUcZlWuvcKUBGXhwfLUHbFDDJs85XPfLDZDU4Zs3Tsvcl1Cjb+GMczWuJ/VgNYXFL5xjtmJyevxB3FPdwkzrHWw1hL2lny8+vXfdrjj0X4P86UDlUqt7FfmxmRl8uc9qYX81cZlV+lzWY/ZcEhu8Sc5b23RYb1NZoAlwCaqRiBWnW0llht2VxrECVVF8CD75SKvPS1anNEganoHNghwUya5GNafm8+ry4GvkJ5eXyHkAe//ByFk4lSi+fy0Zn3xPbbuMizZRE2f0M5O2NNIf0jadkLxuX2g7DJOH2T2ixcKNM10MgkNHQyTN6mtJuNqdIpzbP3NZc7RgmdwI4ijWH57TI7Owi82SQihxzVC1ekJQAdan18nM8EaowsaFd2m2zRJm+CDFF0GIJZxFOVxfWOSHzr1WEsMuGUcEg8X5Pm4ik1AfRB52Xos8dyxuAbv3WHffw+/pkKcr8gTcreLHL4JGfr2XkmI7Ufu4KQJcXdHMTi8qx6JD02lK0fQCPyJJQ43Dh4oxknQ8W3pVmQL9jkGAJ5aDd/9dEacCXKzGF7FSBQD3A07K3lWLf5v4bwSk6OPInDRJKJecUSlZZeS2Hob9mbJrZh6udG46+0h7LkK1RW1+2yYcIuMH9Lt4JxzKqJQ1jtNiGKtYAPQBQ+p5f7sov2ppdgnQASLMFbOQ090HaEEfT5uONe5cj6xrbkz7qQxnxVAaGQT5I96nHhxG5z8fk19fJbD8CFiSMzl4eGd6btoOeJ2+AWQ0nLCpO8v56MeDUFHSAdn7DOQz8ns/tq5Le27o6UORTw4fT1StqHYl
 zE8iAJWG
 E/oW1geEOq6tYsCMk5igtP+TTR4+//Q/9Gs735AY/5MsX0gbmz0F+Z5IXPrgjWfNvC80pFsX7opXhSml2g6r9OjYgGjaPew2rDeBuJGsw1MUuoORtTtUxAdVAT6LuOv18mcj2utZT1MXvesVrf6i8UMwWIac8e1Bn8xfcO9lbI/nHEeiPm37dYAlOD6xPN6B/teO8DIMx8intpownxdhEc90sy+NmQLCpmLhCdg1Yd0Beso/JoauCKp3E/uky3wemYLXz8vH+qzgMF/Us4DbXGm3+uRN229u8JjzD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Tue, Sep 15, 2026 at 05:13:17PM +0200, David Hildenbrand (Arm) wrote:
[...]
>
>Ok, it's really only DAX and anonymous VMAs that use the huge zero folio. Other
>(module) code would have a hard time using it, as mm_get_huge_zero_folio() is
>not exported to modules.
>
>DAX uses dax_pmd_load_hole()->vmf_insert_folio_pmd()->insert_pmd() where we
>deposit a page table only if arch_needs_pgtable_deposit().
>
>
>So I think the rule is simply:
>
>arch_needs_pgtable_deposit() -> always deposited
>vma_is_anonymous() -> always deposited
>
>?

YES!

>
>The trick is that we don't have anon THPs in non-anon VMAs.
>
>So could this be simplified further or am I missing something?

Ah, cool! I hadn't thought of that :) You're right, anon THPs cannot live
in non-anon VMAs, so pmdval and folio aren't needed here. Will simplify
it as suggested :) and add a comment explaining the rule.

static bool has_deposited_pgtable(struct vm_area_struct *vma)
{
	return arch_needs_pgtable_deposit() || vma_is_anonymous(vma);
}

Cheers, Lance

