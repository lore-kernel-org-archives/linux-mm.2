Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9061F606A329
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 07:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=SrUDrC1n
Received: by kanga.kvack.org (Postfix)
	id 8FE1D6B00EF; Wed,  4 Nov 2026 02:46:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AF956B05B1; Wed,  4 Nov 2026 02:46:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79EF56B05B2; Wed,  4 Nov 2026 02:46:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5A0C06B00EF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 02:46:27 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B891B160687
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 07:46:26 +0000 (UTC)
X-FDA: 85396653972.23.10CAAC6
Received: from mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf25.hostedemail.com (Postfix) with ESMTP id 53E96A0007
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 07:46:23 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SrUDrC1n;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793778383;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lsvew4WfCYakXj0qeP5Ol6UCHiG3rtzUc6TCtTcDj38=;
	b=ycIQVIgCa6I9m3ZRRnZF9ea/baLSS1t+BwOcMCmQoarnXhCX9nkDpBvwROH+ZLfeeXR/ho
	/AOcbb/YTFyhBjVSZ2RyKhfE4ukT6swiOxX2lD8UZa7GOySWpeevwmXk+X74mHSrVi1Li8
	TYmM2wt+EgwQOfNoKGm+EsSGJUwOdL4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SrUDrC1n;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793778383;
	b=UJ33kArSJ92Gk/gPKqtenLIvmVYUEH07vKdEXIIN8jWqK/gyiBP69QY4MF9ty9WKrv84w0
	yUj8RgbM6eSZsQJQCBBV94Fjs4APzfd4DB7eGL8mB9JlQ2QkHk85xft4cvR/PsMDbvW9mf
	M8YOInSvgbZBxu74PPPJ9bEF7plEfws=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=lOeRWLkwojHUr+kCvKucNzS99VgHJLzpoVD7LuCzBQU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793778380; v=1; x=1794383180;
 b=SrUDrC1nEYDfnDbcjhM6U8YikKVcoVmMepiQ6kH0khyq+37Cz41vPf1A6NfktIbZup9kWkDF
 TOQXoVJizKP5XMi9kWwwoYvJDEJ9lfVjWTc4YY4geW02Jzkqf2EcMY2RbcYoGPvpwyXhG6JPIlE
 5Jr2093XGM9q6FtQWqh9izns=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id ee7e5ef34284ef57;
	Wed, 04 Nov 2026 07:46:19 +0000
X-Mizu-Trace-ID: ee7e5ef34284ef57
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: ljs@kernel.org
Cc: david@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	kas@kernel.org,
	akpm@linux-foundation.org,
	peterz@infradead.org,
	mingo@redhat.com,
	will@kernel.org,
	boqun@kernel.org,
	longman@redhat.com,
	surenb@google.com,
	vbabka@kernel.org,
	shakeel.butt@linux.dev,
	yonghong.song@linux.dev,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	eddyz87@gmail.com,
	memxor@gmail.com,
	martin.lau@linux.dev,
	song@kernel.org,
	jolsa@kernel.org,
	emil@etsalapatis.com,
	ihor.solodrai@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org
Subject: Re: [PATCH 1/5] Revert "mm/khugepaged: remove definition of struct khugepaged_mm_slot"
Date: Wed,  4 Nov 2026 15:46:13 +0800
Message-ID: <20261104074613.30583-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261103-khugepaged-latency-fix-v1-1-a07ab16ac860@kernel.org>
References: <20261103-khugepaged-latency-fix-v1-1-a07ab16ac860@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 53E96A0007
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 3gr1hem1z3d59q5mejtko6z996waf69s
X-HE-Tag: 1793778383-885585
X-HE-Meta: U2FsdGVkX1++00OxWh9wO9NSKOdwdLIoDAo4WDamz+NJhOn06s9jJb/xJuGgWmqbEMGXYxvdUiDavZqr92CYDZWttCi2HHClS3jqTwK5cvKu6fL+MSysQrjYRAgcBBjtAW6LBJeWGmHaGFPRpn128VCBC7t1jYLtT0PDd1J3lyeuWrdabf+yCkTbzJcR+QL8zIkx3zStzU6Lbir42+LlvyIDu2YVrOVN4g66AkpvPjuyvuJat1+i54eWFkXzgkZGDXC10u9F3v4OfrYpVeiXuvrlpskBXRROQVnvkxwx3eyzNOeqgJ3n5sibnoA+KQHEQnUQ82ii8+scfbZUXB64NtKcEre5iwof2Rac1v3xKaJds8+idMpwqIfpO1CV3Im7OongjesE0q2fPuBPWkIyNG4yF4sbBC5aBaGW6mxzXx5PMNNTI44sufBjFWo+b2wjwRedF8cMeMJl0lbbPFYDf1ainpyBBnA494RdkCeRx0LY1z2Z2JeRD583ltbOQAuAuncJ/aHe/tMrN+M3+G2zR5L4iuJuZTWffq86XUVeg1BJ4LxoEEXEl5TwFhf7tGY3H9T6XboGEQAw25NVMqpsRunGj1WZVgi0duoTQ0vBpF3uaPFGGJAQpm98yIc8nL/2+/kQf9UudVMIqf8/Eq2hJAhCz3ruE3tOXRPW1X6Gj4eHpUsIZJdJjpoe5/BONTKfqepkc12jn6BEbb99wEdfqrL4FFDQyA/mFoSf0k9rlQRTt+QDUPJ4/+ZRF8KagZri8+t4mDGIPyoVtHK/s6p5koAzd5juJ+2sJDwxp4WRE2NDd+s9FHvHYknkoKUWVpP9Em+sNBXqxFp3MkV0mALGm2QLEGUFD117sl/wgWGfO6MyGkuwLiTYIlneLiWOLFRDfqdGKJvaa6T7Ji+0+/CyoYfFa1gMJ2VfNGt4uDk8AzwsMgmlQsJSJAPx5fwsE1Z5aNBEGRqS2NPfuF6yO2T
 DIaWsIHc
 6bfGAiMHsZhuAJCWOKm582ZHM3P+rM37OxLVF9yBPcVrMywfe65jlkj+tYgr+zYp6uAc6OxGexLbKzSzbw6LMNR07dIIgD/x2h+GP+ajuVkKBGjkjKKkR7M07nRWqlrMoNrDwuwQjvO3dzrbKMVKyR0fFMTIA2Aukx9Gv6K21ShAnzADKnpVw3wafs4hLlDkdR/sZdES+DbbmtxP+nGAKki7hfgo+xRp5bf6p1oLxlFoNQive0WdxLyZo7vMRMfzPUKcfnq7xzzi68pSKRvQffMcGttRCRwNeH7g/gEcw3YCOLfYfNnojnIXjzQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Tue, Nov 03, 2026 at 08:27:42AM +0000, Lorenzo Stoakes (ARM) wrote:
>This partially reverts commit b4c9ffb54b32 ("mm/khugepaged: remove
>definition of struct khugepaged_mm_slot"), as a subsequent commit needs to
>resurrect this type to store additional data alongside the mm_slot.
>
>The stated intent of the commit was to address a NULL check in
>__khugepaged_exit():
>
>	mm_slot = mm_slot_entry(slot, struct khugepaged_mm_slot, slot);
>
>slot can be NULL and mm_slot_entry() is an alias for container_of(), so
>this is container_of() a NULL value.
>
>This was benign as there was only 1 field in khugepaged_mm_slot (offsetting
>NULL at 0 results in NULL), however it was right to fix this, so retain the
>fix.
>
>It also unwrapped KMEM_CACHE() in khugepaged_init(). This was a mistake,
>and was itself reverted in commit c14bdcc9f274 ("mm/khugepaged: use
>KMEM_CACHE()"). Therefore, retain the KMEM_CACHE() form in this revert.
>
>Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>---

With patch #02 adding a per-mm scan position, bringing khugepaged_mm_slot
back looks reasonable to me ;)

Reviewed-by: Lance Yang <lance.yang@linux.dev>

