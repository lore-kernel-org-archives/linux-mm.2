Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CC7BC44501
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 21:17:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D82736B0088; Wed, 15 Jul 2026 17:17:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D330F6B008A; Wed, 15 Jul 2026 17:17:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4B846B008C; Wed, 15 Jul 2026 17:17:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 992156B0088
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 17:17:42 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F28871A0305
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 21:17:41 +0000 (UTC)
X-FDA: 84992272722.21.6E50974
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2739EC000A
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 21:17:39 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=lw1aE0Rl;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784150260;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UU+zPW9iRvCJbBM3XKZCH/KKzyu8mkExGEFSmL1gNYg=;
	b=TQAksjy5EBGcroJdaT6Frkzxt3yDbKsUM4let6GeWMlQgA3x39ZA27YezLesaspfVBj67E
	hEfFuWDJrBHoF2CqerWxVK6HtMLjrWBXF4Op94HRyxL0/QvdqrTH0XhyJzwOwQ9poi6F59
	yp5nYBMIWXc1MKK09xRmd7qOjbkk634=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=lw1aE0Rl;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784150260;
	b=7zCpnNFGLmjLmZluDUEUYwcD2NRp1digyZOMplbSXwkEdTPFlP8Jd0CS5yJW8VskD3XW77
	ZO/u4TJ+DNgkGRJSKE8hECb6JElAifGYpQw5dxhvU0l8QU1eYTcdpvgay93o9UdGA5FbbF
	3luvImbaZc3QHu433xiv+9YhVvNaTPU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 19A494028F;
	Wed, 15 Jul 2026 21:17:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C56601F000E9;
	Wed, 15 Jul 2026 21:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784150259;
	bh=UU+zPW9iRvCJbBM3XKZCH/KKzyu8mkExGEFSmL1gNYg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=lw1aE0RlWxmrVX1SBFRJgy1UyPRTg4K6nP+DEjnY9dlEAsFMk2L2RNTreb0d+vs/k
	 1gYgzd2yzaN3XobC7uyRdh1AW0rjf0Olb3qRLd+W/Q1HYfJhedn8GiXr9Nt0CNftbb
	 PL/NA8rFtyplykMr0XbJ7OZgExm1aHBfS+hm1Ecw=
Date: Wed, 15 Jul 2026 14:17:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stanislav Kinsburskii <skinsburskii@gmail.com>
Cc: airlied@gmail.com, akhilesh@ee.iitb.ac.in, corbet@lwn.net,
 dakr@kernel.org, david@kernel.org, decui@microsoft.com,
 haiyangz@microsoft.com, jgg@ziepe.ca, kees@kernel.org, kys@microsoft.com,
 leon@kernel.org, liam@infradead.org, lizhi.hou@amd.com, ljs@kernel.org,
 longli@microsoft.com, lyude@redhat.com, maarten.lankhorst@linux.intel.com,
 mamin506@gmail.com, mhocko@suse.com, mripard@kernel.org,
 nouveau@lists.freedesktop.org, ogabbay@kernel.org, oleg@redhat.com,
 rppt@kernel.org, shuah@kernel.org, simona@ffwll.ch,
 skhan@linuxfoundation.org, surenb@google.com, tzimmermann@suse.de,
 vbabka@kernel.org, wei.liu@kernel.org, dri-devel@lists.freedesktop.org,
 intel-xe@lists.freedesktop.org, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-rdma@vger.kernel.org
Subject: Re: [PATCH v9 0/8] mm/hmm: Add mmap lock-drop support for
 userfaultfd-backed mappings
Message-Id: <20260715141737.4097a5c7d74953ffd8ed66c9@linux-foundation.org>
In-Reply-To: <178413903133.1155966.3904063656020521607.stgit@skinsburskii>
References: <178413903133.1155966.3904063656020521607.stgit@skinsburskii>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2739EC000A
X-Stat-Signature: ddsitz8rj9ydc6yihpoaucngxjj1fxre
X-HE-Tag: 1784150259-611760
X-HE-Meta: U2FsdGVkX19C8DlqVJOLenfuHOAplsz3PGcSOXpjrJtfBQyUurGWkPPJaYf/Jfi+LY+nwdF1TPhWyFDgoywIh/BEy7/jis/Elf8VX50gTaujmBRIq1Jd6kJOUdCHxI0nFliLZfhTtduYZGxwmCKAEtvkeZ96TynemB/mN3btk69vjIwWCQre/No4Bo4mON9rmt3zjIg/88Z5NSjkG7FHl4K4Vp29QwGGwrBjPy4Ql2zS2U7Hcr1CKuxlvCuPJ0PIkHBczX8BBfQZN3Q+m0vPil/7deJkYwu0XEl0EMFqFTmncqjhd0rICUVLL9fr12XX9lHgt/fqe3AVbXs8mp8rGkwk9QAnbRztX+0ujUfcZQTf64Mtu42zeY8vsVLsmfJY2u2lmCnhoaOmvPv5WwebWPPXVJC4Ty7yMVbgAt1y8jeJD6VYYLVtQrto/zdEcew+GK24XZ5fmliHeiyl/3Ep41IQquec4ODwgLd8MPGVrirYvsYsa+iCMVCMTSIdv3iT/34l/AFDHh95Z7U/aDTtdrBQtuQVjEfWezOMVvVhVvr06aJWwXJWMfHoXZhExCLs5PQnMlfWcml8vjM+gLU4l8Ctw44hIh62gHtdUVXbfieauiaH3WvXnj0Nytp4iZJ0lIMOrKTrnjIy+GQW6IBf2c+TXrrMbyMdGZmSdVyWZqYPZYM8cua6wPJj99gbpCnpYi5VH9njmlVwLUbOi+D/IXpS0vWOweagFLqT8n42fyXo2zcjk1pUdhhYWNV+H79z0/vSP5vFc+LoOigerEAg8H5pff5l+ZZ+hdT9Ur2vQhO1HblvVs0JmiN567PqROvL1qwb83rnTRkh6D5wRoCdbPhCWzUpeNWUu/hZVb49nHj0HMZHTjWzymCAYxxq545lvwaNXnH5bEGhoUvQIptjE+9oUlxFJZIuEwDyDY07qxPUnAd+BtixsRxrj5+UAvMGVKyBJNxJlD8Gh33NM7K
 gI8y0O36
 MIGMvHl1P4gKRVwek9thiZtIRy3op+QZHxy6f6DP/K3SQywjCzn29jXu8PYjsdH2riCgt43FFZDq9ivB9q02SwVCpoFcyA0/D0KopdlfMGHXWPGMI/XV/6FI6afsqqYUDb1SUInzNS6ocUk/AzavRKfLpieM6IqIxuisAjHlXcvg6GDXdXwtTmWHpE5BaMuc2PxM9CObEpX6xh4pTLp+JNmmnvqioyfa1Q3USGVa35YQd2iS0Uol1ZZ45dbmmD01an7Mg1k++pdDXZHvYZMpbrqmejmPXH3niO7Ck8JTjUyRl0gk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 15 Jul 2026 11:15:50 -0700 Stanislav Kinsburskii <skinsburskii@gmail.com> wrote:

> This series extends the HMM framework to support userfaultfd-backed memory
> by allowing the mmap read lock to be dropped during hmm_range_fault().

Thanks, updated.

> Changes in v9:
> 
>   - Folded the fixups into the full 8-patch series instead of sending a
>     separate fixup series.
>   - Clarified that the HMM timeout bounds repeated HMM/mmu-notifier retry
>     attempts, with the helper refreshing range->notifier_seq internally.
>   - Kept nouveau’s explicit outer deadline because its retry loop runs in a GPU
>     fault worker and cannot rely on fatal signals from the faulting process.
>   - Converted amdxdna, and GPU SVM callers to pass the shole timeout budget to
>     hmm_range_fault_unlocked_timeout().

These are all in your fixups for v8, so the v9 series made no
alteration to mm.git.


