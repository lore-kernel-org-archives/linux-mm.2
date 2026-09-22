Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35316C982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 12:48:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E87026B00A0; Tue, 22 Sep 2026 08:48:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E37A96B00A2; Tue, 22 Sep 2026 08:48:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D74146B00A4; Tue, 22 Sep 2026 08:48:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7C2876B00A0
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:48:11 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0131AC0484
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 12:48:10 +0000 (UTC)
X-FDA: 85241375982.05.68376FD
Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	by imf18.hostedemail.com (Postfix) with ESMTP id 277291C0007
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 12:48:09 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Ple4IN5w;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of donggeunyoo.kernel@gmail.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=donggeunyoo.kernel@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790081289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QVFwYIiKUZVL+YjJoBnUJAKPe/wKV4GXCUpDX8JPQGA=;
	b=7uB4AxKOUP1zGrXQNw17Xrk4NHKCP9jpvHt3eON8GFsPrrEBltq/z1i8h8V9rWyPAO3V6F
	eVVsTMkke3Flj6JpWmduuYzYlXQ0f+0l7XX6LyMd7EpxiAUZFWxjtHKFhplxYjGsHYzZLu
	w4KXtd6ie2YjOrv0BQD+JgpB7VvOIdM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Ple4IN5w;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of donggeunyoo.kernel@gmail.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=donggeunyoo.kernel@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790081289;
	b=lp3afRizeQKA1ZkHJdXCN8ckJbou8N/AX8aI9V0Vxoq5qsiumcqc9SBXS+VoqthCYz8r6/
	Asrth/p+BbxNp7E72UBLH8cDRBawkZqtLfEsbHszjqIK0/fkpPchF0S5yt7kqL0A4nM6Z3
	Yu2fWbsm3MD3x3a+GEH0NYfbiELf/Q8=
Received: by mail-pj2-f12.google.com with SMTP id 98e67ed59e1d1-396ccda24afso2935519a91.3
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 05:48:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790081288; x=1790686088; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QVFwYIiKUZVL+YjJoBnUJAKPe/wKV4GXCUpDX8JPQGA=;
        b=Ple4IN5wCrmU1WZXkzlWxjEEQ6PMcFkpvJIlkagUmluM+PkLki9tUd1BQNLJbyU0qF
         Fql6CGNOQLGUqSK3vlEzt5mRBAmilhEO0PY7nD3/4jDiSK4yMwtngmv7+tleM+p41nob
         ASAs1jGkvn5JAflBi1FUq2++lp7Cabq7Sz0OOxvuAapnK/1z6ycNtfyoqJlPmViVgW9A
         SU/VKfmE3okoV08NnqMJ29xeTnUgwR+YLLY8MfPFbehsMFXm9TjQbpjXipgreiVJywOC
         EZQ1mvS/gVnIyYBLCk4pasXlWfE+086A5c4FvnXNuGVh2blkjjJ2Ape/2SmCPsmH4+Me
         BZFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790081288; x=1790686088;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=QVFwYIiKUZVL+YjJoBnUJAKPe/wKV4GXCUpDX8JPQGA=;
        b=rsdWmm535PTPyFQF4WMB+Wz3vPXj0gd8UkpSB9M7MXJkzh/YkVWD4JYuQN2xkUuNqV
         aFunoYDXiZvfn/qGEWfLxskT2AcoHbPAD6rQ/AEdsGgV/GQks+uqyYwEnDzKM5dcTu3M
         2AXZCmqp/5VlE7bageBI0IMnUd10giNKgQ0xKX5HNBrC63mevxYKy3nhwJOpn4RCLY1F
         4Hb20BWUxs/Sq+eNLeCc09TjPGixSZuqVNIuiYf3LlCgGyc+bDjm0gWr1BU8Rgtye6ZC
         10jNOymLfxv5obRksi5dsWMdk1CUp0CBedN0GeCa15GY/G3/hOU+H+QqBYYthrzFMfcX
         netQ==
X-Forwarded-Encrypted: i=1; AKwUvBxJMfrY+2lST1F3VleaokhyhmR6ZiWQpflGCQnTB9ZlxHM/K7nxIXDMlIkpkQT2CZXnhzR7KzTguw==@kvack.org
X-Gm-Message-State: AFuF++mqxXre6cHTDIHDEReGHOaa3TCAMwS3nnsQBgoti6StWufjAct3
	CjS3ok/pYrZJXraHoCo8z396NF0SvneNOtmOL8O/52z/XRlEZJqmeuE=
X-Gm-Gg: AYBFou354jsvaJDHlWwBEHM5zpXtCoR0Fu3wJe/i5UkhbG+m3tmnfqefwm3PrxX1WKh
	Ugt7qhUf6QqIxE7qjnQZCMHDEgOMS8hgTCfSnh87fxVvL7GN7HwqxAuP2ZbjI6GYOuxRkGL7gFG
	/uB1nT1jGUnVp+7NNJo/XE+5WmZBVCG40tdvGC1tKKdhGutLoIV8J6yb8tdOxofB7zE/vyzEr5S
	8QKs+mZLIjqBJQfTuhC8hbIuLjzb71t2cd+C45I+AWukuNGW1m01AIygstVO5L3m/xXiiewy3Az
	qWGS4jyghhSOAvhfUbjAsqzwQH1lFJTex16jGaRM8nlZGqgh4eAjcdbDFHPOciOy8Lp0IaTTmZA
	+2lilw4PrxCUF2P3zgfBYzDHY2pTnhasPNMElbg/WKTTX0xfVj/3f0EDMg59tLyrU2x16bLV7Pw
	Qds+d1f9wEnl3SFu412hV4s4vRcHu8+ppIdyRIIwpK0jL/SkzlYclhbbgysENW/6eKzpj5YLJqm
	e16GL3ZrOjKZiikqzm4S+YwYLRr
X-Received: by 2002:a17:90b:582e:b0:38e:bbf1:de3f with SMTP id 98e67ed59e1d1-3a0730d0610mr995564a91.12.1790081287829;
        Tue, 22 Sep 2026 05:48:07 -0700 (PDT)
Received: from ydg-Zenbook-14-UM3406GA ([2001:2d8:7f00:8c85:2466:805a:e198:cde8])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a06e574c49sm3442051a91.8.2026.09.22.05.48.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 05:48:07 -0700 (PDT)
From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
To: rppt@kernel.org
Cc: akpm@linux-foundation.org,
	peterx@redhat.com,
	surenb@google.com,
	aarcange@redhat.com,
	david@kernel.org,
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
Date: Tue, 22 Sep 2026 21:47:59 +0900
Message-ID: <20260922124759.1676901-1-donggeunyoo.kernel@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <arIj-DZ3BtxMEzLB@kernel.org>
References: <20260919004630.1159895-2-donggeunyoo.kernel@gmail.com> <arIj-DZ3BtxMEzLB@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qedb8iw49xmedkhjmwiw68g6jf38h43p
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 277291C0007
X-HE-Tag: 1790081289-956876
X-HE-Meta: U2FsdGVkX194do7d+HkQH97R0hdAVNQmLQau4jiny36+Od2HKmMjgyUT3mJjdTY79kc+Ct1JhfCWyXDUPg7byRldQykeNnHhtrAJ7mdnWURG7Ye9xWVKIO838MeP1lqiNxH+mE9sRl+da+UvGXPYPLpCG5Kjs1jb8XmLkjdRh37oaLQtW24GsC/gsF+gYKglTy2gpNEzHnsVg/jAEXjED2RFuHsyStVvJos0gx6LYori6cHWfiS+TIORD5HCmA0L5bsttu+UGcRvlVo9Ff/TobEtEua+984/Z4BLoqJQ4JEVOPHHRbTwgtTWWYFy8Yft2KrAta/EqWp9kTAB9Mos038KKAGKo7pcqbMPivCB4eyvN/o0VPPcjYpdNBxqvV8FnXgRM11+1iX6kPSFkxqighLEGv0g+lfHzVDV+jCgKxNr/QY4Z6qeVyQ0NZ4QNY3TudAk7vM86ZStUPIHfVyLcXiF2/9k5j3Te+wF/Tjtfj3uQuMg0ycsbnF5/FTBG+8zdc2jSNQuIJOSH5/Y+SY+HvBbkcC3+JoHZKdDjGHQH1bbSZWPbbq28GrOXXRHYBvInNAxLs/mWs8v7a0SPgr9j1LJBPTPjR0MRPzB6l0VmAAO9Uq4Mvf8REcfgjtNeI2O/g5aI/7uZwLd+HNLgziipe5fiLZRGjXUpW2EOup36ch8teFBTRg+phxJ9ICz5xWZXP4UprjXDR+DtJ8cFLmteHWUfEROJCyy7LWqj2RVOOmzhTAuGvCq7Kbi+0ogTK5EpilLP/F150sO7+5tw48Xxa+A966IYq82A3zGICq1m43tAJMYZIgXFx+62hZF0BwFb6lSYSqEg2497HF/GmQVEGPBmUjQrX7/CB0RclnoKoNeDdc6a0lKp0CcyzilgYdi+PqVIm+1/U33ULoTmDR34ExDba6YJmgk2Xorclm1ZZxa3/QXqixRvAuT8ZcriuM0tj362Yn3PTem00RhQ9e
 WwbC8Yx9
 JQGeLNeRTpeUen/Gi1hVvdpg7Oez4FGfQnctmL1uobfllBtAlb5JjMBprsauYtmeY1ceu4roZRQHaGIAbvODfWVfja3R6etoZwXMD51oWh1gcqrCJaem7FJK1VUZx5F77W/hkxuA50USs6TknkFLfwngxkvNn9/xBOmUUmJ19wr2r5ofLP2WcIdgXDlOFdal1dLRvkFjrVmpdaghNL3ffwWAs5g5TQNN/PG/gORytj9Zhp5Feddqnn56H1aqnKltfmZ1NaYcetRmE2VElzoNi25zb83vBqZoUOvaxITNv7qsxkPHUUKKqFwEg3s5iS8y7157fx0LyB3I6FHJlOLeVFP66WyxPRUswyo4EDX3Mu5ppu4DDmXMPIAlGstj4SBVCRxAG1J8H4sQH02ui6Yccaiby1eGi4w3mY73kDLR4yem+xsnhAutOqqquwQWvTe4mhYtRHzDhzZRUTNxrPCCZVQkDGRLgW2NQJ/rdaajt0OXG5SyqldWWct+0aEmdaemgpDTRs86i1t2GZtInv+SVUsX9xFngCFnUrqDrGqM4iGb0/a4OFD7g5grMxQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thank you for the review.

I'll rewrite the changelog for readability and add the Assisted-by tag
in v2.

