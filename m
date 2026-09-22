Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBDCEC982FF
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 12:41:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E7FF6B009F; Tue, 22 Sep 2026 08:41:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BF4D6B00A1; Tue, 22 Sep 2026 08:41:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AE696B00A2; Tue, 22 Sep 2026 08:41:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6E2626B009F
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:41:25 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6F011A659E
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 12:41:24 +0000 (UTC)
X-FDA: 85241358888.25.B4C9F7E
Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	by imf09.hostedemail.com (Postfix) with ESMTP id A06F0140007
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 12:41:22 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=p8QfL3sZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of donggeunyoo.kernel@gmail.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=donggeunyoo.kernel@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790080882;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iw/dw+ccTq952L+vCfsl+Z5DyyMuf5zXMzQFZZc0Va0=;
	b=yBU5G77KZOa912k9fR/H7WUIDd+eYH0ZpG5iynUjvPEhglKQxNE3L8WmGogAqSbfvSRyJN
	ZvDlj9XY2357xpO8Qdc1wpNGFNcyNRYf/RvbTDZDh5XkyFpxOLKUXUTsS8hZJwrH6E8gx1
	H31Rkvhg8FCwbG16hXHCa8AjFaqx7U4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=p8QfL3sZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of donggeunyoo.kernel@gmail.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=donggeunyoo.kernel@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790080882;
	b=npd2JSgL/vHfe/bwi+ImosR8VI7ka2emje4txrazdrVVrNKdvB+AqCybIcrgzbqOPHs0+c
	SKsfSpdNrsGupK+Er0KdIMWlTSQWrLWWShzw84RPkQ/vSK9cjyRa4Ky9T39i0FsWUMKnJI
	oNyBtG1oJ0C5YRT+LJn9sqUxwjLJUqY=
Received: by mail-pj2-f13.google.com with SMTP id d9443c01a7336-2d747f05ffcso31616315ad.0
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 05:41:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790080881; x=1790685681; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iw/dw+ccTq952L+vCfsl+Z5DyyMuf5zXMzQFZZc0Va0=;
        b=p8QfL3sZ2UKCeA87OXMC6qqh7X322eu9ERsx6OH84Y6IHVjIyozHlp6Z5H/k0a2xZF
         jye5ltr7YgSxsaRrDyxsvfG+i0Uk3r9Q6+gxSX0X+mUaDjiww+n8NuNX57zqKQ0uJMOg
         s8cuKL3Z31nGHk4FlzcMjxLJ/MzHNjIDzAhrWsuDPXS128MhnVP5xEc/6z/VlR24d7cT
         hj8tm//OL5gGF2LTn3VY5bNjLU9wWu7fgWv6M3E7w89uTKsq2Ibbg1WKPyWxkeYffB1s
         RVe70/PHLtcDx+XP++GySGkiHvDCujrGSAtqMHXhSGi26noHdiGoohBRD4+2+Ejg1+yg
         6m9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790080881; x=1790685681;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=iw/dw+ccTq952L+vCfsl+Z5DyyMuf5zXMzQFZZc0Va0=;
        b=oouzvTaTW6AnImd4alcOEVvoAOyz1G1FLm83s8QVIi/XAovZcXQYAejFsFssyjCd2t
         AJYUnEvB4LzNR6culAJHFpAKRIoBy3/UCvO+ImwpwpakDRJ/TyvtHjFjxvPI53kLAC4O
         b3o0opwmWKvvjLBLw1qc/9YWg0HXfSP37E/i2Txo/gCb6l19fF7SxYT6rl26j5zfThK5
         xPh3VX2ZYA0NTq4vMkEmRM/XV6yX7/+hiyVgcntBxB+80H5qVXxhIUQxZQxQssW/EsfX
         j0mg5CUWg9AtGsntJL71kfXOVKAIDy8VwYfQDyvilAA+FX3SHSyfOduQx+E/CLghPl0d
         9U0Q==
X-Forwarded-Encrypted: i=1; AKwUvByZwabYjhen8v6ppgH8yV6s4sqwuiB8VaIDXePpny+pvac37JaR+3ltSw927gTBX9MHT9I1VqMRFw==@kvack.org
X-Gm-Message-State: AFuF++lYg6pb7hAKhcNl24I38FMFEZIPW4fmYJf/Xz5QCoKHa6vnU3Vu
	mLRQQe7GCkpScfvtFfGK+lcueu2GCBHQvHe4+bRS4PaI6+qPepXnQDk=
X-Gm-Gg: AYBFou2VYGrdCDyGE/Wjy9gb+MfuD0eNbyKbQ9jKH7Mfmzy8X88EHmuIuHkTEdG+R6v
	eN6/8Clk22RGXS/666GSewZ5+UzUALxjQAqTDuIOJ4zDI07ehaPN1mvQ/h/x3TnoqNwjI0Zzb7m
	W0IpBcKO7blQ60eaElGYusIw1T8Cwym7cv0HFzGgnOLZcrGTo21p0tAUgCUpVEW9LqoCRHIbSMw
	YroN5ZwKHvu2fB+S8Wmgi/g6bRfT12NBO1bYkF+nBhOD9tQEy+9Dtn0cU1ihCjcywCFYtOIYS3F
	jLx+q9adzQJSRrQCws6c/b0aQVVLoI0oeiHv3g+mJdqwdKV8i4QqnB7A99UFovWB4LqoaoDk7+a
	7QOvVFmIP+DSbh6/Vo0wK0j90FYwdm9CGW0gN0OYR2JQIW2d/idWCcZhdxuCV0wia0GgpToLfSL
	fx7/NOEygFeKd9+mjb/JKA5U4ePesyDavxb41vb3I6O/l5rlkRq7cY0E+Ot+zDvrdtmP2aKk+bU
	fUvluO6k+WqTsATReuaNI8a9Ik=
X-Received: by 2002:a17:90a:ec90:b0:39e:4c81:6c65 with SMTP id 98e67ed59e1d1-3a0731f717fmr1052233a91.32.1790080881311;
        Tue, 22 Sep 2026 05:41:21 -0700 (PDT)
Received: from ydg-Zenbook-14-UM3406GA ([2001:2d8:7f00:8c85:2466:805a:e198:cde8])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a06e5cd2e4sm3134535a91.16.2026.09.22.05.41.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 05:41:20 -0700 (PDT)
From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
To: david@kernel.org
Cc: akpm@linux-foundation.org,
	rppt@kernel.org,
	peterx@redhat.com,
	surenb@google.com,
	aarcange@redhat.com,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	mhocko@suse.com,
	shuah@kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	donggeunyoo.kernel@gmail.com
Subject: Re: [PATCH v1 1/2] userfaultfd: clear the inherited uffd bit in move_swap_pte()
Date: Tue, 22 Sep 2026 21:41:13 +0900
Message-ID: <20260922124113.1675993-1-donggeunyoo.kernel@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <49208ed6-6c20-49a9-9c0d-0e1cffe1898f@kernel.org>
References: <20260919004630.1159895-2-donggeunyoo.kernel@gmail.com> <49208ed6-6c20-49a9-9c0d-0e1cffe1898f@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5pmqqfpmewknynmd1tj9o5snqjqd5ynj
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A06F0140007
X-HE-Tag: 1790080882-329514
X-HE-Meta: U2FsdGVkX19+OlcDWSFuFTQZdcdjNw7o/ZojhxR1zDKdqJS16dNKeXmX0Z+12jCKOaSui5mvm+e7l6Zr5gkKgeSRakuP3orjRO265UMeBY1bxtpCSaMA50jIgZOxsR3UPRJpPgHBT9+eQrzh+iXH+raY/e3XCpNVCok7qn39agBa8fo7ErbT235rpd89Xd/hWr8BeUK04mgZfz5bBS1e7eNUXZKy1ho22JLmli8RhtjqYlbMyKtSoplamU9HhhwUyTWmcCs5lw+w+uMtKhAA0MqO+E9n9pMMe4syjt8DivjAIBxlIFVbqM2ukAn/hBQDdWONF3wOzCKqswJJ6qSoabpGKI0pbI6Kid4u6eAFozyMS71C33WjNwLTb/uO3aUR/m4/GoLfLAaTReI5yg3LGxTu75GmUJTUClIgPPolSMt+AeAB08vQhZBTJUkOX1dHQ4ICXyQVK1xqHtqk7E3m5ICoWItTqsV+8spbmfqE3u515fJ1VQDbA+t1h11V79ymlBGf07YBP2Nu5VGBr9vY6YkIr9DQMwhn1RueLkGqXmf2qCgQhkROlZf9dU2YvkgPySCSpbCf3jjqnVK4vNYCQ6wy6+BhZd3wxdM9Hl43S7u4p+KCHP13ErjeLOVfF2auD8F4PbtiGy10jzJ9EY2D5svBcByPhvBBjsOtmEJnXgZyVrmujAdfnr6zJ49TlBEnqC6tM2m/xRz2LkcbXXR0kZveFPt4m/YMGagR9tggfAqD479qTF0nd0N2+a4MX57uzdVzoKysGBlTwudxMkmyw5qAeOJi6S7d+8v7f2b20wvUjjZC2CTSB0eNHoB+E97M+umVEQaCrHrxiuTVazwaNzteO2TVXeTIoLuA9aQ/uHgopW/2gqk+PofORuLlzWRjHiLK6Rsduir8aVzqAgZjorddXEze61uWTnC9DxnBn80aoLYEybOvijFzy/Ov6+fOCyzgy8ToONyMJUIgHFV
 8s08XBxq
 IFCN+3lvjMC/atken7gO98uzPsnis5ZiQnJr9i/TJgD3ttVB9xp46pA1deZcF9S+gQmJISr0cqDa69c5QkOhUY4HlC1TAest5CDFgJlzlrjW3QzbDpMBUMSljG89pdtjuYPQHeZdIqmG5TfF+E3UCbJfzUEojCnwplVB/OmbLkEtPm8+7pzaDx8XZlJfBAGl1GnC97AbS/Lb+65rxzWKy07Ka620k5nmO3ECTg4WqqRMjZXBtCOlhfSeJVvIGtuZNFevKOocDD98xqL1r7xsHl4y2IZSCOhAOqYsR9rJ1MuTleZh4REaaumBcQfUOkIYItPlNK9NKfPyZhWE9JQLRoM6o0zu4xR+nX7MxF2PeRKHmt1Co+WsgLcY9KJfi9iNVYMY2EJ85Jw0dsWpgNS4VO5Qz3myMeb2pAZDzqd1xUDO0lPJ9hWa5Nl92ZuOkZOSjB3X9gegZA9zyQBZlpjv/gH+P+jfl5iKC6BOjdLovPEWEzahUuSwdThun0XXwN8sJ3o1mIRkN8VLR+puHp0oEdthhLVHvAtgULP3v9vhJvvUZpHin+Oq668pVdQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thank you for the review.

My guess is that wp protection always leaves the destination PTE
non-none, and the move path has

1566	if (!pte_none(orig_dst_pte)) {
1567		ret = -EEXIST;
1568		goto out;
1569	}

The move fails when the destination PTE is not none. So there's nothing
to preserve for wp in the first place.

