Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 525E9C79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 12:53:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DE746B00BC; Tue,  8 Sep 2026 08:53:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B8566B00BD; Tue,  8 Sep 2026 08:53:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A56D6B00BE; Tue,  8 Sep 2026 08:53:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2DD446B00BC
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 08:53:45 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BEEE98062E
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 12:53:44 +0000 (UTC)
X-FDA: 85190586768.22.CB4D271
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id E9306100002
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 12:53:42 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788872023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=m900D3UB5BdCkH+JXZv7ve6e2boeFceGJjLp0ABzbU8=;
	b=PJGFQ/7x8Z/sC5SKuXZ4Fq2qiZz1acD9Pf+ZvjTne7nvE8i+u8GvdhO2fy1iKrkgluswmC
	An/d3x9F6/tshhjL1aCdy95Mjt9WEvIUQR/l8HwMYO9bepH4b6swvIEz+CPznrFyf9hwPr
	1FlXkimpsENoKcNzcs7C2EZtmPXDS0g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788872023;
	b=fzBZMY9BKN7Cu1wtzdgkY264Io43+oclLNbi9Nrh9ZzjmMlgd/uoI34Sekdz3kXAYFMp8R
	lFFJzF0unxg2IYG2aECzXaWrwhmSaf+16S8ADBi6J6XvHwX8jEIcJD+kh3/RoTwFD/AUMG
	Lm97Hycl7Shsyns2eE1SIcfdn5PQCio=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2505C43464;
	Tue,  8 Sep 2026 12:53:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 003FD1F00A3A;
	Tue,  8 Sep 2026 12:53:36 +0000 (UTC)
Message-ID: <edcd7aa2-547e-4ae1-ad70-f80b6164d783@kernel.org>
Date: Tue, 8 Sep 2026 14:53:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/6] mm/vma: make MAP_PRIVATE-mapped /dev/zero mappings
 truly anonymous
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <20260908-map-private-dev-zero-v2-0-acc7b5625305@kernel.org>
 <20260908-map-private-dev-zero-v2-4-acc7b5625305@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260908-map-private-dev-zero-v2-4-acc7b5625305@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: e8ts5r8g3p8gguca6citci1gr3i9cz8p
X-Rspamd-Queue-Id: E9306100002
X-HE-Tag: 1788872022-57271
X-HE-Meta: U2FsdGVkX1/98fbAfF75TQR77o3bUIr98LMsTWFBdTBCfRx25RngAANhFRe1h+KuN5Ts9tdtLaMxMpErPjXt2WmjeLgQEdLesew0lRTC0j9YCIheb3yOiPHglm0r0hC6nNWXPj9Hqw752y0k2SOjDrgaGXtEoXB9g0fml4As097YpAQs8yWALegDIqpu0UE/AtSQQ0kuZk55h/6kHF+6vGS4U46MQEmecoyk9b4Uj37EEKjnLhtgNbW6xfPkCkNJGmSyc2e/SOPMyey83TSUBpgGcauKSKpsJpY2zgDvru2q++a2duzQby8QLu14X841bUx+YUbKmoG8WMu/042Tdm3n+BSGTY/oiKCP+YJGkPZH9Nwy1pxbGLvV9z1O8T8+dVxhXMx1yXNdDtU6jdbiIx0zHKiCAu2Wr7qxutobQGH3xMtAtg7qEmiupTVSBzqUs30ujBiJVxqG0Iz/iNcUlZGRiipgI1UjG+Urrs993+Ry18p2x1MLE3TxPKRd16GLPy1jntkA4sf2DSZp5o7qIVsar8+pGhEqwHkIdqpPf8LHGDlav4AYcfp56Mpwlpew20J87p7Zk7Gs+ZvFRifVddjZslprhCkisrntZzPNQCHJv8anl6cqSV7Ma/BKctsEylBSMcKnA7Nejn75o0y0krBivXyWsNrzeuEJDP/+oUynW0T300R1dUPTTPWQwFFaOv0GhZ+hMEu9QGWXDrGcbs2Mh4I/rc7qOXE+jUqYCW7HR8TAxSXWy8bDUL2RVOJsZ5U6T7Hlj2rB2qTw5x/QAfINW8N86p6rOBsDX5hyMzJMpIfzWAa4/J09y3U5+Ftr+IEeU8uCtUGzpMZjBAuozunpeg82oWBZZ/TvJqRXdhVf+bakmu4FncMLdxuOR5VSD67riYW3hwZVVeBoQbJt3hK0E9xL3PKu2RuWz5gKyIErijAjjzaHswMACGG7f1A/OSgQm9+yFEij+XISXBh
 7hKBhB3e
 qo/70A0f11DYSyJxX4jhLn+1Gr7FHST8Q7U2RK4oTndpR6tu/gZ1Q6uEn0o+oaOYVxWGPLz6MtH1+jGZvDyTOrV9oH3vbhHzMagWikCxktNqdVXTQO///h7uV/szbC/n7R9TX3T/aX5qP/IML5G1uGsWbPAR0V3s48gAufrL9iMdVM+/1kMy8XFn7bZTjOEQ6vX9HwLQboCMRpNk4MPvjjEqU/Eb072VTq9z7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/8/26 13:23, Lorenzo Stoakes (ARM) wrote:
> When mapping /dev/zero with MAP_PRIVATE, one ends up with strange VMAs
> originating from Linux's distant past.
> 
> These have vma->vm_file set but NULL vma->vm_ops, meaning they satisfy
> vma_is_anonymous() but otherwise resemble a file-backed VMA.
> 
> The introduction of anonymous page offsets and their subsequent use as
> indexes for MAP_PRIVATE-file-backed mappings mean the rmap does the right
> thing with these but we are left with inconsistencies.
> 
> The vma_start_pgoff(vma) == vma_start_anon_pgoff(vma) invariant is true for
> all other anonymous VMAs, but not these.
> 
> These VMAs are also observable as files in /proc/<pid>/[maps, smaps,
> map_files] but otherwise behave like anonymous mappings.
> 
> Therefore let's make these VMAs actually anonymous at mapping time which
> will activate the anonymous code path for mappings.
> 
> This means we no longer have to account for this discrepancy anywhere and
> no longer have to think about these at all.
> 
> This is user-observable, as MAP_PRIVATE-/dev/zero will no longer appear in
> procfs as a file-backed mapping, but the impact of this change should be
> low as likely nobody is relying upon this.
> 
> However in any case, in using MAP_PRIVATE-/dev/zero they are explicitly
> asking anonymous memory, so no longer seeing these as file mappings is in
> fact correct.
> 
> A previous commit gave us file_is_dev_zero() to positively identify these
> mappings, so we expressly only do so for these alone.
> 
> Update assert_sane_pgoff(), the comment for vma_start_pgoff() and
> linear_anon_page_index() to reflect the change.
> 
> We make this change in call_mmap_prepare() alone as /dev/zero has been
> converted to an mmap_prepare hook and we do not permit nested MAP_PRIVATE
> mapping of /dev/zero.
> 
> We also remove the now defunct vma_desc_set_anonymous() and eliminate the
> temporary bisection hazard fix from the previous commit.
> 
> Also update the VMA userland tests to reflect the change.
> 
> Finally, update the procfs self tests proc-self-map-files-001 and
> proc-self-map-files-002 which both intend to map an arbitrary file
> MAP_PRIVATE then assert procfs state, but happen to choose /dev/zero.
> 
> Fix them by updating these to /proc/self/exe which is guaranteed to be
> present if procfs is mounted.
> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

