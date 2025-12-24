Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B390BE75446
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 09:40:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0C316B0005; Wed, 24 Dec 2025 04:40:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E90EC6B0088; Wed, 24 Dec 2025 04:40:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D71ED6B008A; Wed, 24 Dec 2025 04:40:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C331F6B0005
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 04:40:43 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 762AE13B5C8
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 09:40:43 +0000 (UTC)
X-FDA: 84253869966.26.97DEEE5
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9FCD140006
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 09:40:41 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XITMCm2A;
	spf=pass (imf11.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766569241;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=rtje64B8REUkBwAnUKiU5bZPGFWW+pcKFR0S+7/ei6s=;
	b=E48ODmvDDSy1K8WyPh6sWsiVN+ExpQ/AbAEOsXB+A5ac4nv8TTaO5qw/Vak5M027u03por
	jf2x6AtdxBTAFwLc24AFvszyiYOtJ2l6V/i/4Vzbvpm/aFnej+FTx57DpdwTHHHswMcirf
	E5CIDKeLG76UQ9h+fQGi1b3KTgJSzBs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766569241; a=rsa-sha256;
	cv=none;
	b=hU11B3aAMDJfCC3siaobsavxqYofMVyyJdP5tM3dWgkgu4Tl1JcbHdaZz/5HvwgOKqnP7y
	NGa86gnyl/YfPtbNPaP+tMbR1eVtkhxoD2GOIxDbKttDBdbnuWr0ANOTkVf0RfpFllzscM
	djX8gTI6pFbbYm0zRJshKVuwbgF4+TM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XITMCm2A;
	spf=pass (imf11.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-7bc248dc16aso4754133b3a.0
        for <linux-mm@kvack.org>; Wed, 24 Dec 2025 01:40:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766569240; x=1767174040; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=rtje64B8REUkBwAnUKiU5bZPGFWW+pcKFR0S+7/ei6s=;
        b=XITMCm2AIjfyJICE3NO0W+t0Wg8H/vyDyBWNwTKeKuW/HQCssySY2Q1gIWAEusFVqm
         Z0PgjLkBKtuw7ndM2XV53BOg/QGGWrSPnIrMEkdQwxL3Eua7jQWhhQcJVDWwEM8y/mpo
         DfeX5hKRvvN9B2F4dzYOgwGEJ48iSUstO0ic/YcYuFj+sPpQ4BAhW0YKJmOtWz9P8UoI
         vtB0cQqESs0087bzEYc22Y9ZiqQxM04u7T7ZBcoR+yRzLb0LIflbYzuhoUibFlfrnNgj
         V8WJdq6WPJCqKpAjGtW/s47Fb/zutShfCoxl162KZn1rZLxJkXnBBFNo0Bcst9bS3NBm
         QQbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766569240; x=1767174040;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rtje64B8REUkBwAnUKiU5bZPGFWW+pcKFR0S+7/ei6s=;
        b=tHO+aVSxOw7hA7g+pkM4iEZ3Fb5tuWPGkPuOBtyilJAhjG28+4cs3mpgCU7xjEHP6q
         cXm02rPMoyRKWXImhqUSYA0GrOW7A8PCcYfSVPJhN1K4JWE1ijTeFH01uklgh2fUBpM0
         YYfz5b6dZqnPmFcNYgH9ko6u/K8kxP1phjurBhsZS7LvhqZpuR2wY55wkXnAsBBCA4hX
         gchd7uuCUNwE0QE/QluFGr4hrLqiYFJDWSqQn+A4ivHhkNyWE78h/V6DC/cOzXPwAM6v
         L9SoFWCUg25KqLl+T4B4/QBJNcq48Q7418rh4pYvWW/fAzDjq2nEp/OPZGPPv7gyNDSl
         0duA==
X-Forwarded-Encrypted: i=1; AJvYcCXCmHLGOZDYQvI9g7/QKiFZ746Zm2Z6D1d3Pl9xPqAyLKZA+/We4qCnnN7+PagbP0Jbljr5RJfR2g==@kvack.org
X-Gm-Message-State: AOJu0YyfkQET6+V+Tmatmg39AAHynT6M5T8f/xKMfALXCqzTWS3GPEJ/
	yO0/l/ZatM2LbQ2NfMXwjUALABMJwtUs6jj9f5Sct7XXeApHNyL6Ht7f
X-Gm-Gg: AY/fxX4tCujLwdNizmeY9gH9jKBCJExC2+EuoAG0nR9OMHyRdO/1nz7bltjIJMHKbz+
	wDFO1GrWowX99UR9oXnpBol4u3CFAehhjMC2LaX8LadfO+VbXRAIqBfTme/wIZLmJK7KDpbdaV6
	S5IOH2E7KgB0T61qK7gUwfqoOApLraUMaXrHxlnnBdNfBYRwH6VBdX1GzgzyHBt1YKOjHRg78Gv
	j0deYTqE6p4NZRYBwszKnq/smVFeLpQnLCzil1v4CAF5akn/YKLuCdqbQXtUUsfAmK3/CapSe3x
	idhcp9moGEWg9x6V7Jp0FnF6fb2bLoBq9xb0iUfzFv1zzYZoSOlelmVZlyxmNCOHabmotcWmKov
	F8/9DhO12cZYQ4fF2JXV2ZdbjetXWOg1yhdC5O5hiiOL4Dg9Z2afHQ8WlFA2DMpIPJW836elifQ
	UDTc1ZrhPyjIwW
X-Google-Smtp-Source: AGHT+IGTL5C/TlFNw5zmbZzif2bezBrpTzak8omc06WNGTfpuquPZmLQA9UJMGr+cM/rWITHDxVmTw==
X-Received: by 2002:a05:6a00:3004:b0:781:17ee:602 with SMTP id d2e1a72fcca58-7ff64dcdf56mr15326546b3a.28.1766569240270;
        Wed, 24 Dec 2025 01:40:40 -0800 (PST)
Received: from barry-desktop.hub ([47.72.129.29])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7ff7dfab841sm16228959b3a.35.2025.12.24.01.40.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Dec 2025 01:40:39 -0800 (PST)
From: Barry Song <21cnbao@gmail.com>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Barry Song <baohua@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	syzbot+178fff6149127421c2cc@syzkaller.appspotmail.com
Subject: [PATCH] mm/shmem: fix uninitialized folio in shmem_symlink
Date: Wed, 24 Dec 2025 22:40:27 +1300
Message-ID: <20251224094027.65842-1-21cnbao@gmail.com>
X-Mailer: git-send-email 2.48.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8feaafw5yu3a87w93m1gsbqmgy34q4fb
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9FCD140006
X-Rspam-User: 
X-HE-Tag: 1766569241-73969
X-HE-Meta: U2FsdGVkX1/SKVVvA5h97z4V0NQaAxo31WQUJcI/CBMyXLk6vlZoln3B6GGKWjjU3WDrs5thG97Dj8+93U4lVgjcKIcBsxUO1mDiauuCbm2UxsROjcbQhQ8oC0D0l4SVzVfW8B3LNNUSKdUo9IkDwp2KA0ffYseD/NlR+M0omB01fumbK3KxpgLwL3xsttr8gJmo7bTltUllBqLxVbEltcZhJGevM1LRqhfifFAGUHfmaMyRaHyWoyzphDEU/7kpi+KwFBxuCPXHXkIm1aFhW44VlzcoE8gBXNBWZviiMt3G5j4hgKPVKD7hOf9tRncYovaDOtOUC7YExPMzAkJpm7/Z50AJc+2tRnHLEUsVM3I9iuJI3OYiO6VmvKwQ0fARtWOF1jAONiZnnaKe6CBzlLj0X+OOM2r/XjVLAVVbQ666H8V2jJnz/ENP1Fh/MhivlHWMrOdKdIi6Qh8M70FltoUc4feelwWX+nZw3tWEDvda+gCHlw7lZL5YGyOwE/CPDciiloYbcM9o0kzGAyPYb4pnTn5rfd24E5PuZEr4O0gEWozqsiP6gp2nFu/eCxUfdEPAso/w9q2x3BTSpKMF0bQW88vRUWsU/jCV13exn97P4bustKAuwzQTFQhLeW3vamTXqT8kvqnPBQYOmmMc90Ysc6htw/Xnh8A+EL/OKxZ7GaGuhiVpZS5wLrUxMJaUxYuxWZMHrWA2OB23HJX26T9at9DbQfHY/TN8CVxgTIk3rFlnoSldn/IpH9hFZU3X1/9MUu9ZAmKmZyh9beItX9JV9jr965HVS/GLTPZDCLnwubXeCBKoQzR31Y8cU9fDVsj1DNAyO3HKMoA+lGRvKknDBBXUOGU1bC1I31lXuRjwbF16G+MT53mcZ4h/iUmfD5HmdqCAwSV3O3jdu7n6PpIrKpJ8W5v8u5rGAy7fazmCSXs6T+MKl3/4Ql/omaPArBuZtqDtf1ZJQszCBRy
 t8+Mw1az
 M46MoxE7lMqHhmOR8uGkCtnrZPMazwgLEDJP4GYDyQYY6YTd7pTyB8JoyaGdGwf1cLJ5tZtNMTlEq2vqfcIqE4i3bsw+Ls6HGt124AABTAEAll4WQdJU0ksg6ySoqYsYKyFNRTS57kxih/ZY9S9Y6ZDKKeboVLLEnGdQdYKuhM/lsHTIVLPtIMeuWR9HhM9PRppSiSkQn49VRY2ydHWYiceW/Gxj3E2lG+eyHLKpMV7i3sUJcCYiR7dDxUHK4p/ix/tbt7vVSGQC+eQ6bMCteKgVQldbQZI9Udo/vZ608KbPJolrmSISYqd6zPKov7SrW7cH27GR5S/JFNLWv8LjicptocG9CfXKSAqYhbImcIN1AogwIDZLbBbQ8n+my71P5mhAIAqkHuRlAkNztVc1eO9aPQVRDR8Zkj/KayRtYpiNjdvOj1xTRnIU8rG0wbTggIfbVCYJpJsYNS4qR7JYJT4BhPKV03HDqrdDN3Oil+KCflx/9y4igOM7mzxcHYVxe7OKqp+YG4Qn5KCLAVeBvYXyFcLwC6oh5BUqhKxt3IFlDHHeVyG3cJHPWRpYl401qv2iYEjWlyc+xMRVUbNoN0Va2ocIGcI13G1CQEVPdWVRJMJGKcvn6nN2hcVgxyZNf8W28AJf8oSjqaf+RZUsr3S7Rtw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Barry Song <baohua@kernel.org>

Uninitialized folio allocated in shmem_symlink() may be accessed
during swap-out, causing KMSAN BUG:

BUG: KMSAN: uninit-value in is_folio_zero_filled mm/page_io.c:188 [inline]
BUG: KMSAN: uninit-value in swap_writeout+0x468/0x1390 mm/page_io.c:263
 is_folio_zero_filled mm/page_io.c:188 [inline]
 swap_writeout+0x468/0x1390 mm/page_io.c:263
 shmem_writeout+0x1abb/0x1f60 mm/shmem.c:1662
 writeout mm/vmscan.c:649 [inline]
 pageout mm/vmscan.c:698 [inline]
 shrink_folio_list+0x5920/0x7fc0 mm/vmscan.c:1418
 evict_folios+0x999d/0xbf30 mm/vmscan.c:4711
 try_to_shrink_lruvec+0x12b6/0x17e0 mm/vmscan.c:4874
 lru_gen_shrink_lruvec mm/vmscan.c:5023 [inline]
 shrink_lruvec+0x46f/0x4f10 mm/vmscan.c:5784
 shrink_node_memcgs mm/vmscan.c:6020 [inline]

This patch clears the remaining part to zero for the portion not
covered by memcpy from symname.

Cc: Hugh Dickins <hughd@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Reported-by: syzbot+178fff6149127421c2cc@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/lkml/6949370f.050a0220.1b4e0c.0038.GAE@google.com/
Signed-off-by: Barry Song <baohua@kernel.org>
---
 mm/shmem.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/shmem.c b/mm/shmem.c
index ec6c01378e9d..835900a08f51 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -4131,6 +4131,7 @@ static int shmem_symlink(struct mnt_idmap *idmap, struct inode *dir,
 			goto out_remove_offset;
 		inode->i_op = &shmem_symlink_inode_operations;
 		memcpy(folio_address(folio), symname, len);
+		folio_zero_range(folio, len, folio_size(folio) - len);
 		folio_mark_uptodate(folio);
 		folio_mark_dirty(folio);
 		folio_unlock(folio);
-- 
2.43.0


