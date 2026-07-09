Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DB30C44501
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 18:41:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6B136B009D; Thu,  9 Jul 2026 14:41:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1C696B009F; Thu,  9 Jul 2026 14:41:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBD4D6B00A0; Thu,  9 Jul 2026 14:41:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A995A6B009D
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 14:41:02 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2CC03A0253
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 18:41:02 +0000 (UTC)
X-FDA: 84970105164.10.AEBBCCF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 6C68D160014
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 18:41:00 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=fLM6MjaP;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783622460;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rYrqKyJcarkPc3ot8aQvhf0e9iwthKczmlyiuvPt6L4=;
	b=E/gXgOROuANy4gxkWJFPuGWApueR+3NNGGtvbW3XJb2ceySnu5GjOWbc6t8cW25f25mPg4
	Zi4z+FavQX209Bz2RCQA3WyaNu/RCeVtmsHRu7MpmZ6GVIc07q8NVNWjSKc7lRcqTCzibc
	pKW0/gNtBICR+26/6D1+DcFnEF+BrBc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=fLM6MjaP;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783622460;
	b=CzVYKO5oevfICKBpb/SYBrik1/gdyloCHbT9s9RC/BIsrDDeNvN/Iq79apha1ooXSjJHkd
	ghPmdb7ljvgl/wMDuMnzhOlU5n4/7+K+qrLG12H/xUOGEJfwY9jXFpfx4JL0I46QenKa64
	MsuJzj5SvKjouMBeucc7izklWT/u//I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B61636137F;
	Thu,  9 Jul 2026 18:40:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0C871F00A3F;
	Thu,  9 Jul 2026 18:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783622459;
	bh=rYrqKyJcarkPc3ot8aQvhf0e9iwthKczmlyiuvPt6L4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=fLM6MjaPetUInIuGrh5P5aAaYIHFgG/X7H+VK0G+FB2uoe0TC1exsmP1HRqUA5g7B
	 VWxhAqVi3XKOJZn0P7koDAQSrKcfmv5GpiGHQr6OczkJLUwd4uM3rBLEDuKDUWw+kc
	 Q7QbWwC8csiqlxarxL6YAI8nc/JPz8BmmXulTs+Q=
Date: Thu, 9 Jul 2026 11:40:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Brendan Jackman
 <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, David
 Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Baolin
 Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett"
 <liam@infradead.org>, Nico Pache <npache@redhat.com>, Ryan Roberts
 <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
 <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Mike Rapoport
 <rppt@kernel.org>, Dennis Zhou <dennis@kernel.org>, Tejun Heo
 <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, Alistair Popple
 <apopple@nvidia.com>, Usama Arif <usama.arif@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/5] Keep tail page private zero at free and folio
 split time
Message-Id: <20260709114058.52eb184d1529a247993ebdf8@linux-foundation.org>
In-Reply-To: <20260709-keep-subpage-private-zero-at-free-v3-0-7e4fe155f5b9@nvidia.com>
References: <20260709-keep-subpage-private-zero-at-free-v3-0-7e4fe155f5b9@nvidia.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ocs5naqtgdjzicutomudtmbteq45fknq
X-Rspamd-Queue-Id: 6C68D160014
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783622460-609072
X-HE-Meta: U2FsdGVkX19ukmpcgclN8/rsA6idGg4irkUAOUTjakRRZEUP2wgQKxug9V3PpDlE4aW1pcVeqJHvq6n+wf/TKDw8/nZZ+UwwI0BBZ/qsWktAYHUAi+Fpr4dUdkQmv383Iq89ZyN91IFpA2UcjW5T1q8g0qUPYuAsFWMIi8GvZeA6hHp3MqKQS0pKuJYKNLoix5v5bAOxBESzbab4DpioaXdnoYgbLwpRHa0njjGlt4e/lvc6VdncfgCx0Yz6E5TTJ36iFsmjkDEVrBowb26Z7svgI9PSGO6yB6q587FGQ69f067N9zx1LynvBeyk5Nwmw710CZw/FjOmsFcK4y/FRqDn24jSO6b9UiheF7rdhXLGcEIy0FNeeuJ1X+7hz6nk0WBwsvSOCGExJoTXkcemMNgrtNMqnbxnLj7nVQ+LwZVjTtlE+dOYGbdJN0ZmM8e+UOwaVcPnMJgyrKHrwoXbCytanO4RyfNuByTwTi6kPTWep7BPkaRQQgRDdX2+Y18vRi2AsOt6KKEHhenwile6t/fq3pg0AO2BUuUSLFH52GWXe2RSBs3XbACFgI7YqyhNxYnc1NHTWsvJFL40Ek5tQQzrmfW+ar19/lK96kb1zVDIF6+xJqDcD5CgF0l0iE0IzgyQkTXxGGDaz+54971Kie1OGN563H8T0tp1rRATQ4SMO7io+N0+nhXJ4WJHQ4qFduIRBiVoAFj4coW6SoyG+A5Dxyp1/I9fE8YWWOkpMHHMmKBG0EiWa1RRFoWU9NYZQCA5g4/b5dgowbWsIJXyTxD6u6wmVM2WJnlTla/DzdwmCk5uuipjCq6i5U0Ft/N+xI2Aw1o8cG77tuXoNyoo9IVA+zLuT68/xlV5Wnj0j5UY6UPE61lOycIC3E/cPKFPEncd9UkC4PtlvTkfYGIyoYWSkkWEXvemCJxeuSMKcXgapkJH8sD2zSZ1GaY8MiL3CZFiD+GnVFXR/HvtfbV
 UI1BoP9W
 n0nmvCPq9vpDXbENRG+emgzGUewcf4kBmV2ZpgBnoGJotqn6G/BFuLmNwpKaPJzWFgwf1txauSLgUTROsDhGTgmRbIgVKl3Ej7oftel5RCzoe1uRxZuZx5Nnp6L0swnnZPIdxXAoTvRqbcpv8TT44OUiRbv7gIcXMqLk0woNaJkTH5hkCfz8QwSx6La1mI3MAXxh4lZrokFBK1hDXm+PoiZJeR03aLjwsEtvOyyv6LUZyrWW8VVRiY7mbZSCrAAeMIq2Umb9iEMOxkW+ukaR98uxUwJyOGQEjL7PBhn+Gl9d+K6g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 09 Jul 2026 14:06:00 -0400 Zi Yan <ziy@nvidia.com> wrote:

> Hi all,
> 
> This patchset makes sure tail_page->private is zero before compound or
> high-order pages are returned to the allocator. It also checks tail pages
> that become new folio heads during large folio split, before their private
> fields are used by new folios.

Updated, thanks.

> Changes in v3:
> 1. replaced "it" with "a DEBUG_VM check" in Patch 3 commit message
> 2. moved tail_page->private bad_page() code up to the existing
>    is_check_pages_enabled() block in Patch 4.
> - Link to v2: https://lore.kernel.org/r/20260703-keep-subpage-private-zero-at-free-v2-0-2970fe777dd6@nvidia.com

Here's how v3 altered mm.git:


 mm/page_alloc.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/mm/page_alloc.c~b
+++ a/mm/page_alloc.c
@@ -1386,13 +1386,14 @@ static __always_inline bool __free_pages
 					bad++;
 					continue;
 				}
+
+				if (tail_page->private) {
+					bad_page(tail_page, "nonzero private");
+					bad++;
+					continue;
+				}
 			}
 			tail_page->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;
-			if (is_check_pages_enabled() && tail_page->private) {
-				bad_page(tail_page, "nonzero private");
-				bad++;
-				continue;
-			}
 		}
 	}
 	if (folio_test_anon(folio)) {
_


