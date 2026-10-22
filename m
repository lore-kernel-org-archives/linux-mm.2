Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9A1E60A2612
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 14:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=rVLy5bGW
Received: by kanga.kvack.org (Postfix)
	id D18926B0950; Thu, 22 Oct 2026 10:13:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC8B16B0952; Thu, 22 Oct 2026 10:13:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C06716B0953; Thu, 22 Oct 2026 10:13:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A2ECC6B0950
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 10:13:30 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8EF43A0141
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 14:13:28 +0000 (UTC)
X-FDA: 85350454896.04.AD3D4DC
Received: from mta1.migadu.com (out-155.mta1.migadu.com [95.215.58.155])
	by imf24.hostedemail.com (Postfix) with ESMTP id 76686180007
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 14:13:26 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rVLy5bGW;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.155 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792678406;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PdhZn7CyLLfXqOnmVKxKZBj/YTRaUhV2EDj2sHvGsgc=;
	b=qA0JFhpBsvBGev3ml82L9oV3Wm2de1aqkRFI+eguXkFZWf3LUY8yjXeFlTyf7iICN/Ro0z
	yny47DeczajFDVUAeDnGYNkSpnx3uSFvXM+RHdq89vZucX/5qKKR647/paEmfU8Oemzwzx
	8AIfB/arD6Bi0pCw+oglS90mRvNbMt4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rVLy5bGW;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.155 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792678406;
	b=z/Ss+LQCbtfKoELa6MXczkaRtlXxlFZ3T8UkaSj4i9AIHzW33bbsm0a6a/Fl3PjdRDKjKx
	FKYR8kzquYdvWLRIH2Ifd/fQTXNN2CKA2Y/AxpnCtjfzc1mtTIt6EQnCbiGqu1Zn3+wgCk
	9NNDMsPCp9+2E3Qr7MViCikeAaaJ6XM=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=8Nnmu8yc7fJqwqFKszkvhpTU7dkwk0e3GPEf/tKxENA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792678405; v=1; x=1793283205;
 b=rVLy5bGWIQnKiigfrx+5FAZm/0/HajZXg43AWqOEgOvbDkqrWdeTGy5BunxkxwKQ4sWccDdp
 0MtHchZToCdD2j8/jXzhZGt6cgwSQvwsXDqwnRL4yxGJpCxTzBYQz/W13NojaDGZnj07UACNRXl
 wfvwJ4mkR/RaBVh1o1KQjgM4=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 3ffcb66275dee17d;
	Thu, 22 Oct 2026 14:13:25 +0000
X-Mizu-Trace-ID: 3ffcb66275dee17d
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: songmuchun@bytedance.com
Cc: osalvador@suse.de,
	akpm@linux-foundation.org,
	rppt@kernel.org,
	qi.zheng@linux.dev,
	lance.yang@linux.dev,
	jthoughton@google.com,
	david@kernel.org,
	muchun.song@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/12] mm: hugetlb_vmemmap: unify writable vmemmap page preparation
Date: Thu, 22 Oct 2026 22:13:19 +0800
Message-ID: <20261022141319.91913-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261020115824.823278-4-songmuchun@bytedance.com>
References: <20261020115824.823278-4-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 76686180007
X-Stat-Signature: t67irz4u1z9ddretwe5rnibecw61cu3k
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792678406-131792
X-HE-Meta: U2FsdGVkX184XiB+2oulctKnXN2g1do3PCH0XuTUwcUKOLatbQ2CLLa7hk9Y4JHMf+WDmtUFMgbmV/eI5UqIla2KrOsc2WYc5u82OuuGikHJZ3pFVdKCm48C66oyhZfCf+vYFp/rqyQg+k9SF7H3rz7Rdk4LssOGGMNCCJmYbJt6OElKjh0Y5+lQT49NK9T3M0eVCEbHysWQ9q7w32JaVCazFT4zjWUt8PcedCVRDnTIoVYvFVBlL+E7xQhs5zYMy6LPJ/aoI5w/znUA4ayVqpaBBe3a4rJLWeWNKmHWGk+jrCXxeYiMZtRJJz522tX/x/mTXOEviyI23Xu7dfm91i8wRTq3wq9RNwKq+RFWgsx8T9NIFQ0NHqynhZvZXBWEfCzaFauQd9NDXLnkjZrnbtTERAwNZ8vwtzUdeCNT9PI6bK01gAWx+ZGTzwVhhblqQekJXBIt1xYSY5Fsw6lGoW40mAJwvcMsMviZwolxM/El84oP00oxWjg9yWSIFCSWyn2tnXTWVIUrZXoZHNJybtVPTE9IgqjR0ZfxN3wPtq8toXL9i5a4AuU3JVcOYLuoXiOewTIUQvz3r0eQBmaclfiXxXWFo/ZFxkyVumoOQBwAh+B1VIVkDXOzPFdhdkGS4XrOOayldBS3vDBlA4chmmWF2dSGAD7/dqRiOxpX18yfSp/WtHZEY0csTI2y0wnLErdCEOEKkihj8BHsGYymI1ADvE2TLSVsFU/peN5LYZHc/NmcBcjCGOW8tB1Mh0bnpsxQdYcGa1SjBv1rSLzYItCuxY0v9l0hsG5pRuQVqoopKbaCqulv3qqw+528l5Zy9aa+RykPgKEwpQ4ca4nP6kTR73d492ZYJ9mRtT/CPaW0g8+6OX8ajEC0Fp9HsXA5qGm6ylxpu5FLUcXygAeWq0/lzI92JiP5HopvFtcI7Fc+T6RdVUVwmSaPmG0gLb2IxNK+8L3A8PNbS2dkC1S
 0GO0ipHC
 qZu5Odilv/0rnLFzubP8D+hX3Qn0Tz/zFzJKkDIPQZOpIMb28Gnf+lmD6egAe5t1a9lAdogrZJnIM3s99D8TljnT7vZJJZI65DR5N+uS03JkSMnCzQos0DmpEd7NzVrwsP0W+32rz0wnqvqT0VLrV+3tsMeXeSB33uucn9viRjhIYNT+GVphhUA+uSCwMgtmSlKdBQ/1BtHuvx1uc3kv0m9IAWkuVhvrpiOIbViC6Vbi+w5CHlTOd5WD1bvHiOEqW/f9o7CRI3gpX+FsZwPva6jC8w+QSEWT6elWUJquxOuyZD4GcNaFvz3I8zg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Tue, Oct 20, 2026 at 07:58:17PM +0800, Muchun Song wrote:
>Installing a writable vmemmap page requires consuming a replacement page,
>copying the current contents into it and making the copy visible before
>publishing the new mapping.  HVO currently splits this sequence between
>the page-table walker and its caller depending on the remap path.
>
>Centralize the sequence in the walker so all writable replacements follow
>the same copy-and-publish protocol.  This keeps page preparation with the
>mapping update and removes path-specific handling from higher-level HVO
>code.
>
>No functional change intended.
>
>Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>---

Was wondering if moving the copy into the walker could lose the optimized
flag, but it's already set before the walk, so it gets copied too :D

Looks good to me1

Reviewed-by: Lance Yang <lance.yang@linux.dev>

