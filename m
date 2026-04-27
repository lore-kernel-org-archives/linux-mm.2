Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95B91FF8861
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 07:40:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B626D6B0005; Mon, 27 Apr 2026 03:40:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B13776B0088; Mon, 27 Apr 2026 03:40:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A020C6B008A; Mon, 27 Apr 2026 03:40:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8CBF46B0005
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 03:40:22 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 399621B8C9B
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 07:40:22 +0000 (UTC)
X-FDA: 84703537884.24.4018C03
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8184F40007
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 07:40:20 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TSv0yBPo;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777275620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gktj9loe3KgxKgGPLil3kzSoOF42pjvZii5/keHbvFs=;
	b=u32HVDq3jHPINA2jCCThKx4BFO9SExO42ufXNYC04LKK0fcJtQAC7PJXqHGjvfsO36TSg9
	UmN9xzP5NZzIJ7yNsmA22JgSF5U8voa2xm1uZvyLKub0o14GAFF3F+J3tWsrYhCV/MCu3x
	0SBNZtxlpvmg+0K6qebLPIcpcNKxsps=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TSv0yBPo;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777275620; a=rsa-sha256;
	cv=none;
	b=dXmQpSVqkfIWZkDaLspmcA6lv62N5pehuM9XU+z8JeZg/CBa5bKRtIZikMczPMq+eHlE3i
	LrX9S7wxyZi1kFGdHewnSW/ZlmsoZ71ezqonWc/7cza3xYr7GgGrByMgdhnz6CIbKw9w3c
	WC44i3X58ahCIH0r/h/ecvcKgwtf/TA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C135860138;
	Mon, 27 Apr 2026 07:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5AB9C2BCB4;
	Mon, 27 Apr 2026 07:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777275619;
	bh=pG3a1wD6QbXZb19qgYGezMebt+EVac5librIV2OsXv8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=TSv0yBPo83UGutbDwPJla0iJORrQ7S7eLiMpGjMX+Jw/Jj99RdLVdVdrrV/rT2H9I
	 HYCC/UyQq2dyQPC1nlNfnZ8HczlxlyC/d8ARIYSdQq0V0vqrMxaOflEnLz+PCB1DIy
	 lzg+op2c3jzHt8GM3ft6822PNG6XKYop8sTwdKkPjeTR8OJUEipIaVn9O6zMIK9qr4
	 GZ4IuFzx5ORdBk8yGQ+rsVZMX6LuTnwNWAJrjGKj04Xfii+lf5fbGvU0WY/2e4+dRW
	 3iU6YXFU/yvgda1/RYHznY8/nvOfMFVE3gqHIbztzGN3YZtGG2XsDqqFSzJ3LFAMJo
	 8+avALql1xBJw==
Message-ID: <f67ac6ed-850e-4665-b777-8f91da604808@kernel.org>
Date: Mon, 27 Apr 2026 09:40:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/migrate_device: fix pgtable leak in
 migrate_vma_insert_huge_pmd_page
To: Sunny Patel <nueralspacetech@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260427063729.17294-1-nueralspacetech@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260427063729.17294-1-nueralspacetech@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8184F40007
X-Stat-Signature: nwxaikqoak4i5ednt34powugd36oiteu
X-HE-Tag: 1777275620-682686
X-HE-Meta: U2FsdGVkX19MnenDK/G463JZHKhU/R6jEC1NxNRmQjCOmHmbKNMv3pJGRTYlj4XYzT8MiJ/E16ya7vXM/9EikpYyW0sEYzGmUBlTH/mKchBx6VIFUG/ClJ0Ge9PVUTMXuUAeRACUTgDJPq/Ly+SnsHu4w31inWumHElcJ0q8+RPmFqrTzXZEcGqSHLYQnejlsQgt2T9GdfcLxQP5GdNOauv1FcVXtd+ZyHWqQiT4LwQzA+dqfHUjGeJ+Ris/imfWm2Vdjx+E0sDiduiUv5iE9bQGZXbQDDPR7V1syQw0szaxVYqyGxi3qsvjxFWg3RoM4/wcU89HpYAqOiKMgqr44f4GuixnFqQkMFl+k2UJivF6D2ShQLmVA8yoKJxIV+hgLPMwI2f7wfDR0cziTT+hoizuW/qcIFMsqXj13cvSweDK9w/t5d8XYv3Ki7WfOJh4+hNrM1ncYbULWsWSVxaBQbE0PEl3R64H7lmD5i5uUfk+TwfPEXiRv7jaLURhy20huCRVQpIwWFO75+66CKE6n066epR8Nv67qrVX4+uGzbil95yB0d/DQUf/P5dmaeJqeZRoXX6iiWCUly4tYEIm6bWDDXAyYu1ZbOJEq7wKTyIZnW+Yt2wpdnvZe5NAdk8cmUH5CD4jTHCYCD2kexICQE/1OGeq6uZU5TkEiENvAcffQ9bMAuwIKGQX+7RbHOI3CxARj5NJ5B5r0wz4tDZaPY7m9a2hqgyU8gMYvlw8TyXTEkSTY9tvo/NFyHIoYzjNnFISnJIpeY03dnS1B0C6YXZ2l/SfxtgYJnk5w05zXvEeBnZDBlxmm5fWYUe2ZLBOtN61t1YBcsdTfFrLHRaoS7A2NYSGV+ccjnC0pdpeQ1+qtouBfxA6z4DfL+n3DubHAGtRbZtiZ9qmPDSBFGnEFLQiMCI3njAljNVrsTgAdmtS1oPNgMoADjqXiaGtRqNz6xGkt6qWJsW5vy6Wcsg
 yMH4Exlc
 jLP0G+VXWftXs/5K5oY4+8Ts1ZhoVGJlfqinDdUgbqcWO1nBr0NLqm/j5ISoW/P392Ygo8+PA3KGRLkBYfzU+xeOdvND6aUlFV9HosxAcL8GNcSytuxZyVqS8LdA4kIQefunDa3qegOLhj4KFR3hIfCCqHLyZl8J0nfuolv0DdNI2pM3+vvhfuaC2s73NsiXU6MFX/mrS6W8LLLyFXBdfutLLk7MzB56cvPQEFGtet3ywnA1XtghJjHzyL2WmqWC+5sZcoIi2Ct/0qGRwatraApv4s4OVQirAeP63hNUO6r9hQlTiXVtI88Aw2gI7gEsIhYuIf+KYuetzWs3sogCDF2XAhnC8U/3Sd5M2byG0oTIQ2UfjPmdNK+cTsjWPaFMiOercED3faBPEULnHG9SgYbA/j5rGN4YLQnVM/5P7vDVYkkc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/27/26 08:37, Sunny Patel wrote:
> When migrate_vma_insert_huge_pmd_page() jumps to unlock_abort due
> to a PMD check failure, the pgtable allocated earlier via
> pte_alloc_one() is never freed, causing a memory leak.
> 
> Add a pte_free() call in the unlock_abort error path to release
> the pgtable before returning.Also included before goto abort in the
> folio check path.
> 
> Signed-off-by: Sunny Patel <nueralspacetech@gmail.com>
> ---

Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone device
pages")
Cc: <stable@vger.kernel.org>

Sashiko moans about a lot of unrelated stuff, one of them fixed by your other
fix, and one of them to be cleaned up by your other patch.

There is another thing about migrate_vma_split_folio() and temporary
split_folio() failures which I think we can ignore.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

