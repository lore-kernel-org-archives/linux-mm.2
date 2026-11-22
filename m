Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1340606A320
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 15:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=CQ21YEoh
Received: by kanga.kvack.org (Postfix)
	id BD6E56B00EF; Sun, 22 Nov 2026 10:56:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BADF16B05B7; Sun, 22 Nov 2026 10:56:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC4876B05BD; Sun, 22 Nov 2026 10:56:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 822056B00EF
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 10:56:42 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 18492140709
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 15:56:42 +0000 (UTC)
X-FDA: 85463207844.02.B21049B
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3636614000E
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 15:56:40 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=CQ21YEoh;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.172 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795363000;
	b=20quRLTR3gCutXSIgNjy6KJ1H5Zsx0F+p29Fxc2uOE6ZUAGfltafd2t4dikJlloZQBnRKt
	DsPSfWVsSmlWbdxcc9X2Za2fpSQGg9PJ9P692jTTuofLqIH+l4YnYJA/I4K2qgQDn5hJw1
	heHS9ke+d+yxTUmL9JSeFDSx2NbOOuc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795363000;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VgqznfLD+AEq24VzpD10ISeNufFGoggr8PryRgVLhYc=;
	b=oqEY7M4QNRxWLZiUOYedV7HzEj1z1l8uMeuOtBjlP9ndVWy06VElJy7OHO1+YYg/d4GgGv
	6PtR3G2GjYjxzLZ0bqvIlz8BGsadbLh9CCnFSGZYDXI9VWyM6tnlSIFQPM1L1AwRbcEW/K
	Y+rIL0lK9/GpHy+YEBCWpFSoSxUNUpc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=CQ21YEoh;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.172 as permitted sender) smtp.mailfrom=gourry@gourry.net
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-94962d80d34so157106685a.2
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 07:56:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1795362999; x=1795967799; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=VgqznfLD+AEq24VzpD10ISeNufFGoggr8PryRgVLhYc=;
        b=CQ21YEohS6hZTjeG88eQon8AePCKAasdmRtUPKkeUZbSthIVdJCZBfMihNyIQ9I66z
         n/9vClVstBeWGMaDx5lixmC5m3UHQJ+GHavjVh0H/FNFqm69tXaicqiuKHg8Br5qRlyk
         B0FBf7vQVLqbGZZYfNK2xOq23u+iAIJUo4/6HMGl+B9ubP/PCw+XY6p3L9oxxUH8CBrQ
         u/JErnnnAjNe7OjP8qZ2LPRI0s3KZUZLeiSicOhI5q8KwV0Zasf5nlUtNxqPGazsBQPV
         xBEldURFB9ayV5gbXr2zYIlAXcPfwbmTSFFa9vpBEEl4CSFGYg9q1B3CPykJyLfFP7YA
         z9Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795362999; x=1795967799;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VgqznfLD+AEq24VzpD10ISeNufFGoggr8PryRgVLhYc=;
        b=jSk7/EbQJvgbK2BP+r9NYzHtP9U68In3i7GS6NPvCqyyeFfUoPtWY4Stwj+kiJnW6c
         Sc0tSQVSSIYHYnPp8GioVGufdPRaPGhQvcfo+wThyDkXNbxq9e6YAswxfF36SDD8320J
         KsyAtXLXVvRGWlAdaYOrqT/Sg980Qj3fRCpMW0/tlGZEjx3FnP5rynDC+i+EXlfGQxcJ
         60jFIkUDUc2m32aWwl6IN4a4MgK2hnCqrMYurZnvnmuhRk+hn9iwvDsaEzjISuxmNGJY
         acV3eKh1LS5+AaElgaXGzNR0lS2Wo+Qr/RmfAW+mik8BsxC0e9aDE2FmUJDR96uNNyTb
         T2kQ==
X-Forwarded-Encrypted: i=1; AL+hErH+29AfjGsHI/Aya+haWpOg7balNcXxbRUJeJpE4SadeZ5xDstpGOwg5etD57P3YhOs2LKsfF+SsQ==@kvack.org
X-Gm-Message-State: APuU4Z/pTRci8APet57AZI1tbMhg/x5B0Nnl1Gl7ld7qFQnJWdEADY1e
	9ib7PCP6TllSqvRGqhakRNdD2wQN3uOjWYrg3Hil/9ur17RsaxSxPEOm6xLVC6aDwWg=
X-Gm-Gg: AZFdTZeryJ66gEd6Vsi9KlaaXqLCAXgcd8cfVdG4cI3c2tkflppMcdLisOneoOmvwxU
	5LXa4l6QdAgtchZCi2lm1IhblnZ+xOFNO3V/aNcie/WpOOiCrAm2+5bALmC8tqRysqZjKNoNgoY
	H/jmPf1ucIid/ytkmzGbYPLW9SltNaLYONyfbluZM3e710jZoK4+rN8BFjuJ9Rsjcs03cgGN4VI
	wNOwuF5RVPbU8iOK/K93aO1uvITrThQqDV/r4bFk4B/17ZnrQqPi+MAZgcQPWNPOEgwInRjo6Vj
	lTn9iGjWuq42gkndf0Lc9AzdpGLtNMQ89MvMQQw2cTqe6oNRlMwVzVBEFJmYmOFSZClsxNn3aK3
	YZOFXw6uxvT/Lzt7zWLv1tSIO3S/TvpgynN9RYsD8hZe3liVqBWAHjD7F8x4tQWxUYPAs+nDXBI
	15yvEQJDdqA7FiUxyyZ1EXPUHTb2U7d34GNe8V2n7YBlx3yQuir03ZcM966VjZ6feDwiS2zIpr0
	4/T43J6fCTUa31+g2UoI200Gyv3VrkWNTE3KrIdTvaa6v4hCkU85q4L2IpBc9wO3CT/K9K7S68B
	y3E0zjYksExKTYKiMrYAfq8PYOfX1HKkFooQR5HIXOtCJ6fIBnddlbMeTdakLe5+D56tTW1MnLD
	b5xwO5Ok=
X-Received: by 2002:a05:620a:45a3:b0:949:6e15:e1d3 with SMTP id af79cd13be357-949ba8246f8mr1442513185a.3.1795362999210;
        Sun, 22 Nov 2026 07:56:39 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-949bb3f2de5sm619042185a.29.2026.11.22.07.56.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2026 07:56:38 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 3/7] mm/ksm: only interrupt unmerging on a fatal signal
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>, 
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Pedro Falcato <pfalcato@suse.de>, 
 David Hildenbrand <david@kernel.org>, Jann Horn <jannh@google.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Kees Cook <kees@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>, 
 Ollie Wild <aaw@google.com>, Adrian Bunk <bunk@stusta.de>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Hugh Dickins <hughd@google.com>, Joey Gouly <joey.gouly@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, linux-mm@kvack.org, 
 Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>, 
 stable@vger.kernel.org
In-Reply-To: <20261121-some-more-ai-fixes-v1-3-236e925d9b64@kernel.org>
References: <20261121-some-more-ai-fixes-v1-0-236e925d9b64@kernel.org>
 <20261121-some-more-ai-fixes-v1-3-236e925d9b64@kernel.org>
Date: Sun, 22 Nov 2026 10:56:38 -0500
Message-Id: <179536299808.412063.10679914509257827963.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Stat-Signature: jp9xoicj8ua5k8eg5yuoueccy4oakcyr
X-Rspam-User:
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3636614000E
X-HE-Tag: 1795363000-225233
X-HE-Meta: U2FsdGVkX18VSDmMK2XuxbttllHMnnxlp41dSMi5b4TJJDe84wiWolKvVDPcWqz9A2asiRs7xwqyPrW/TVO/Y9L3mXrCf3YJTSc4C8MxyWZrVYXAZxGe+JELGWpLybEjjp/P/Aaus9QVOC9ExQqgHfBxUUspIvz002pZz5a8hmrS3ed8fEEhpcq0sLZaA5pxHN/0wDUnJQ3WV6ilBso3/EbN+yRrvCKAMLT+a/wlRybtq1tv6LnOgTFi9wkKIlpOG4DMRnbJVSoLQI7zEzrZ4q45KZXS0eLiGQG5ZPbe0+bChiJ9PXu2P6lzBa56+21Vgv6bLuTUguUxQufINCfLZ/aR67O4a3rZxt2yiX3acvPyu68KYY41cFuLTwYfrfNHIF7iNKYi+I7wjhkWHLWXCYsQCnJIABDE1cxN4EwcBfqeSvkMrYkMNUpKPhNRbhFXOCpElfqga7GTKo6se359x0wvQOvPMBa5WY0j0r2GgeM5eLc+aeqTIsICNxuan6QqkShlLshbW+eK/C8bgB4ao+OQNoOOJO4nr+xoQLR+Hd5ofGMRZ78KeNpcJEHrdFuol9CXdHsgFzungFrZRdTNAdQ++eUpBZwjGPdc7XnxnCFAfOS6tOSa5/88zyUyyxxKbeVtgHgPdqmazOzxLbYkxdjgmQVkDOpMvxFnaA4mR3rFBtncWxqP4RchNcpPkc39GNbRFp+4/OiHpXfJAwyNMocLvekV+ZtPilh7XqrjSZ22MRaZ0DngF8xo/+2A8KgZLpd56QEMCnheiWsCDdRzD5vs+62YShJmVx/ct71ndWOXuIx257vZ3wsdKdNQd/WKUvHVXuXqLzcktKA4nHJnQwMgUo9Pyw8K4t3iUe+4Cnb14ccQ6cynl2xBMEhxl2tXQkLBQfr20glUUSfXFscaXgWOdTklyXxXr0ImvQbHG4LxBF3SlF+miUNNjXiZ/36M4uqhh/mYC2x16jFZFNS
 VYP0s625
 QpR1u8H8om4QIWsEFnsv9N5NBkATpgBuT+DpKynx5ajNJBfYDSsJpH96X6I4ElvaSiGIcNn31r/k+DXv0PLNgS65qbN4MpZ+VaVl1a/RFsJXacj9VRf/Upy4WKtuQDVCaCidZ44naeBaaxAI6DRREZyuENOw3si5tuFbjh+MeqpDy3DnBa7QM3Dw49igDFz0kvYULqjypPktVHIse8dO0nAxWwLl3Jmmi7hBLuJQXkVzPFf5aAZ72J3TmyvKj1t33s1oupbLJkUjthuslWyLUJKn6wbC0iza9IL5UkhGH6DHO1M+QPBE2YGFS66Ej+aspM44RwIJVh8ADJKVPxfI/RX818W83Ss3ft0A33+55HJbTKFYQyUijBhCvuK0OzoK72OPHAs1u3T1rLi82EMo+MKtW3YTfWf7uCwvHn3HlkHUKaHvxV11kLFm7ZUZcSccjeGlpPc/D2pmBIuRqUkipYMqZWSyeuzpRE4AxnZr9B7pTwFzZLAUvP5mqNdEhxTUOcnQ19Kn0bPE76r8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-21 16:02 +0000, Lorenzo Stoakes (ARM) wrote:
> Commit d952b79136a6 ("ksm: fix endless loop on oom") added a check for
> pending signals on KSM break, so that a lengthy unmerge could be
> interrupted, with the system call then restarted via -ERESTARTSYS.
> 
> However, it assumes that the callers can always restart whatever system
> call started it in the first place (the commit message questions whether
> this was wise).
> 
> Well, it turns out that it was not wise, as this baked in an implicit
> assumption about system call restartability, and it was and is not safe for
> mremap().
> 
> mremap() holds an mmap write lock over the operation, which an -ERESTARTSYS
> drops, meaning that the restart is not in a consistent state.
> 
> This was made considerably worse with commit d23cb648e365 ("mm/mremap:
> permit mremap() move of multiple VMAs"), which can result in data loss if
> you encounter this issue.
> 
> Consider an mremap() specifying MREMAP_FIXED | MREMAP_DONTUNMAP of two
> KSM-mergeable VMAs, where a signal becomes pending part way through:
> 
>     first pass                          restart
>     ==========                          =======
>     unmap tgt1 range
>     copy src1 to tgt1, move page tables
>     unmap tgt2 range
>     break_ksm(src2) = -ERESTARTSYS
>                                         unmap tgt1 range, which now
>                                           holds the data from src1
>                                         copy the now-empty src1 to tgt1
> 
> This results in the user observing a successful mremap() but with src1's
> data missing.
> 
> Without MREMAP_DONTUNMAP, remap_move() would find a gap at the start of the
> range on restart and fail with -EFAULT there instead.
> 
> Fix the issue by only breaking out of an unmerge if a fatal signal is
> pending, returning -EINTR when we do. This makes KSM unmerging consistent
> with many other signal checks in mm.
> 
> Target commit d23cb648e365 ("mm/mremap: permit mremap() move of multiple
> VMAs") for the fix as this made the issue significantly more impactful.
> 
> Reported-by: Chris Mason <mason@kernel.org>
> Fixes: d23cb648e365 ("mm/mremap: permit mremap() move of multiple VMAs")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>

-- 
~Gregory


