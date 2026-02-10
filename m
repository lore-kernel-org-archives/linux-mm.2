Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 318EBEB2703
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 19:28:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71F186B0089; Tue, 10 Feb 2026 14:28:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 700726B008A; Tue, 10 Feb 2026 14:28:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6209E6B008C; Tue, 10 Feb 2026 14:28:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 512DE6B0089
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 14:28:15 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E6677C2476
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 19:28:14 +0000 (UTC)
X-FDA: 84429532908.03.9087133
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf25.hostedemail.com (Postfix) with ESMTP id E96BCA000F
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 19:28:12 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JzoAX4C4;
	spf=pass (imf25.hostedemail.com: domain of gorcunov@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=gorcunov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770751693;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LFyGR2DyLRU+91jbuLD+/fzhLRHaNo946KYs1mYXfdg=;
	b=X9Pcs2fzcW5DUs/CmjxAxHKqYUchQ4wtl5NLMgBIIt8LNiPEV5PLK9cpBKthKN+aZStUxb
	NssG1Lqz3rheJeBelBHj/MlTHlQugi8snDApDw3PM5QchI85SvVSydzkZUuob7gd0/RAbH
	PQnLz4TLbYwlv2kaCH4f05IslH4f13Y=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JzoAX4C4;
	spf=pass (imf25.hostedemail.com: domain of gorcunov@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=gorcunov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770751693; a=rsa-sha256;
	cv=none;
	b=nDQGo67ZBgu4H8w6ysf5DJRPOge7eFGlO1uiTZaJs8875vXVpIBKwFaT6OIU85bhtribzS
	hWqwtvxBeMFunPJJ6r7DTn1PLs2Wy8J9wdq+4cfJ6kTy90zgvvLerbgHGNMxdGZ36DoZAj
	2j79pDqZg+a7X0BNY9VVXLHEuuDUqGo=
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4801d7c72a5so36574755e9.0
        for <linux-mm@kvack.org>; Tue, 10 Feb 2026 11:28:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770751691; x=1771356491; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LFyGR2DyLRU+91jbuLD+/fzhLRHaNo946KYs1mYXfdg=;
        b=JzoAX4C4XyQmXVOFo382w5cDu/6NtczkkGf8PXzMBUR4SQmz3ajA243f606nxH0+Ny
         LaFyjLeaOGdO7IzE/+RYa7VtmgDh7dYogh8sxWIowtfJBsNsVe8uw0xYPxzzEwOXZ3aX
         5qzp+8/PqgvKAaJpxuzmavoGfgLJxCm7mEvMo6A8hDmbxjPpn74AEub9Yh9o226D3uMz
         OP4Vxxd7mMx5uhuipdj/HMlVeFIe928h7a2UgWnE/Vz4z8WLE43f1SULpD4y/LrJd/Tr
         drdKAhWAEvhj1S5Y+biFXltQLiKTUad6HzWHMt4KomOEeeRQwolDDiXwXKZYu80mxSPs
         hVaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770751691; x=1771356491;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LFyGR2DyLRU+91jbuLD+/fzhLRHaNo946KYs1mYXfdg=;
        b=WjXjYWqLOK24/2Q0aewFjBnxN4pkozW/quHyAatMCxmXT38pFT8FXrIzMDxD6oEgH5
         ajfUr4FpBNysi3I0SC1Rd9op8xYtGhrLosXVU1T7S1+Dh3bwDnD3r3wqTMbCy1DzwTaw
         9NRMO/OHHsoRpjBes1Ea7g/jLjLt5rb3XYwtFph4175pMRGkVBOrslomD7yRNIBvfKYC
         6mY+53SNsn2lUImoIt8dkU/Rsoi28RGRqZqiQeGA7nLc/LSiTcjGtb3XHBdPfilAV9jA
         9bVu1YXqPYfLUmByZxx1Na7QN3TKAov7/6cpiQY5ZlYZ5e1nkRhTaOKsHEpH1fnC3siY
         o3Tw==
X-Forwarded-Encrypted: i=1; AJvYcCXsSeYIijkccLqgH3I+XkQFbo+/Jm24/mNv7ZZDqhIbCvirBwlTbK0R9Hh7XH3GYgDI9k+zN10K1g==@kvack.org
X-Gm-Message-State: AOJu0YzW08MgWvvRFLUwdRnU3KMT4sUkQ0OvGP5NSTWU8sWiA8t6l8aB
	VsdEUM7Gb8O+HScX5B7NnrRgLb6JeoNNH9gTc1EvEV7EhY+GnAASR+FP
X-Gm-Gg: AZuq6aIt24RL4z/g2RlDSdwUrD1/vkKQb+nAUpXkYtz3jCmFPOSZcV7IO1aEBOpUOWK
	bzMlCTK+sQsroJWXt1K6XjF3hER/HXxyR7bBNEMm1bCQ8YZHWpUkYdWnZyMu54SpEVnS0D0Xi6H
	s/k5fDemo2dhO5hXqkV92UvW4VVTQP6iP5mU4PdsdzLnNTDNRVFdy4TwDE5vE4/eiIPgOKIkwl6
	FsUUBrdsSS4WVPyPPZB7NJSP8Sc5tV6lLtmXXPfbyTh260hEWo1E1dv1p781FnFQdLvx6WtVsww
	IuA8VEKlMUcNvzMfapAUyUQPo+j/0KtghPe1kLptEv5emndDnstTaLb75yQv2r5iOhelwjky5eU
	Wd2LgM93/3MyhlPMa8dqGNhJdYAwDfubfiy2DazDXE4+Rs4ToOXlEG15Bb6Qu9vpFpL39uSmOwg
	pC7vugKgUYQOalmpnNFj8o29Rc/ZE=
X-Received: by 2002:a05:600c:470b:b0:477:7ae0:cd6e with SMTP id 5b1f17b1804b1-4835b8bbf77mr1193155e9.5.1770751691077;
        Tue, 10 Feb 2026 11:28:11 -0800 (PST)
Received: from grain.localdomain ([212.46.38.55])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-436297462a8sm33795335f8f.30.2026.02.10.11.28.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Feb 2026 11:28:10 -0800 (PST)
Received: by grain.localdomain (Postfix, from userid 1000)
	id 8CBD35A004A; Tue, 10 Feb 2026 22:28:06 +0300 (MSK)
Date: Tue, 10 Feb 2026 22:28:06 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andrei Vagin <avagin@google.com>
Cc: Kees Cook <kees@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>,
	Alexander Mikhalitsyn <alexander@mihalicyn.com>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, criu@lists.linux.dev,
	Chen Ridong <chenridong@huawei.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Eric Biederman <ebiederm@xmission.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Koutny <mkoutny@suse.com>
Subject: Re: [PATCH 0/4 v3] exec: inherit HWCAPs from the parent process
Message-ID: <aYuGxmLOWXhIpoMj@grain>
References: <20260209190605.1564597-1-avagin@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260209190605.1564597-1-avagin@google.com>
User-Agent: Mutt/2.2.14 (2025-02-20)
X-Stat-Signature: i5swb6xpt6owmhdxn5jremwarfhj3wwt
X-Rspamd-Queue-Id: E96BCA000F
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770751692-508967
X-HE-Meta: U2FsdGVkX1/UVBenA48o6vl+ejOX8RjUiVyTzAVtcS0S23VZ1RN7J9NGN4cYkecbn9Ssg6aZOHXO2YltUxG+qpkVRc3Qf1dmQF3fkUetnHq9Xvc/n56KKlQK/+XHSGkRWwUA8K8QZnNpwimRFrUDDWTpXhx4igYLMRxPPWsvUGOSA0/zQR2WWV2MGZoUwHvESAu+Ex1BxO72RlEIGT+VBciFUrachL1mormaqADDosu95P9Pe3eoLOUEqFTxXxjRfosJzvOWOZtIDW5QJM0aVFqGIvAg9fiq5fCqgvmup/QzwgAVi+TSwUu4ANNVi8mqYUJ31cuJt8SIpjctCUqJHH1moK6i9napitV0QPEG/blnsCR6TvqfmeU8DeVbiPmvY8khuI+70VjY6YKp3Gd0JMTF845/aAqjI8dHbyxmZ9kUbxDtiW9ySAnJnDErtXW6+G/sX9YLq9WItzatlVrTAZUZ3bI2roVKI0/GX9YGwxmjceEbD21aNKWs0xQmD8O8VnswCSFgkQM6eO8aiF3qzZjwrcO1vV3KayZTFSzK6g4MrJi+sEbyI6D7B+qOcjKqLji3RdJL6Mj/XEhIzGadvTx/lCazXgSIn/uLZqM16G3SSgLCFbKLDcefGG9l+Dpm6rlCObCl6NQfi/5fg6/B7tUkgDhTiUBmCPFaCusjd0Qfmrxns4N00JSAb/y6qILI7+2ONYVvOgu45TDo+8gVzE7DqQ7vFDYVueI9bLD4kLBSgX32e4ewanLJZjF7RFfu8PwJydIb5xHlYvPjPrnohZXKy5WSi77blrSmzHgCCg232BvnpV7rHeYFjefml1YHXJgLI0v3poWx6fXRDsAPTAtpd+WXCIZmj5Q47k6ay92Jul/xmmwb91VOIzLKZ7NooNLPWB/aUqd1pEgMAEWvsJwSuU4AntvVDAO/9z4cm6FBe0u6h9FSvkeiv403HByWQH87hsjipQwPP5hQPKO
 KEMCCB23
 07GU+ZnaaElozMNsKHPnZJ46X9+ytox3592K6QxdaWq7eP+WeW0UkvIfkMjfkRbZwLb7C1u5U63kaLwMwX/Kf2V2BzyezNxq01plTofn+ZxAoqGTwJWiluwEDaRgypLVpldRKXVXVASe/fdn+sU0/MuJH7pQXO3dVJdg36KRNpu3Lkf81lhD8gd/rwjorp2LDRBpKn1gJ7FhsOsdJnmrBIa7TqrUdISjoe2LxhCyD8kxmjIf7xWmKNJYYigDL2M+ws34k5VLnz+Yo8f2YAIhBfGbTkccEN7Ko2f8sqW25LOOQOJvMTOlxdMtLld5nHUPFnDjrrjXNhnlxOmBEUutqdHZDxPgIiBfm+N1Ws5wC/hZKhNOEOT12aUmNI28KcF63YXm9aPydWWBMhytbyCkMmW2lpRDOnuHTvV/CD66pFCL2boQx81u5/qihNUo0I7/b+TBQcqbyqcsEHuiomiVQ9RN3GGfu9qI4FFYV0Rtqo0a8ClIFOzEd1cBKpDWoIrpRuzt5dtv+cDIgwEVYZteXKU2XF0v88x5+4H1GRSUelMupgc0x8wjyziijV4zI4wwKmIvUiONsorSh4k+uxXLFyMSDoRUGySskWmZ+foTDnFwD3LAEYeFH3LFWU8rtl1CpL56ujUrHuehBjvlwS/Kw/dyj0IlN0sqGfUjEIv9mIy+f88fM6thY7yut6iGk1VEKdW1GgDo2Mv0MqsFWW7HaihrGYjdS+qzdKaN6QdSVA2aRKpU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 09, 2026 at 07:06:01PM +0000, Andrei Vagin wrote:
> This patch series introduces a mechanism to inherit hardware capabilities
> (AT_HWCAP, AT_HWCAP2, etc.) from a parent process when they have been
> modified via prctl.
> 
> To support C/R operations (snapshots, live migration) in heterogeneous
> clusters, we must ensure that processes utilize CPU features available
> on all potential target nodes. To solve this, we need to advertise a
> common feature set across the cluster.
> 
> Initially, a cgroup-based approach was considered, but it was decided
> that inheriting HWCAPs from a parent process that has set its own
> auxiliary vector via prctl is a simpler and more flexible solution.
> 
> This implementation adds a new mm flag MMF_USER_HWCAP, which is set when the
> auxiliary vector is modified via prctl(PR_SET_MM_AUXV). When execve() is
> called, if the current process has MMF_USER_HWCAP set, the HWCAP values are
> extracted from the current auxiliary vector and inherited by the new process.
> 
> The first patch fixes AUXV size calculation for ELF_HWCAP3 and ELF_HWCAP4
> in binfmt_elf_fdpic and updates AT_VECTOR_SIZE_BASE.
> 
> The second patch implements the core inheritance logic in execve().
> 
> The third patch adds a selftest to verify that HWCAPs are correctly
> inherited across execve().
> 
> v3: synchronize saved_auxv access with arg_lock
> 
> v1: https://lkml.org/lkml/2025/12/5/65
> v2: https://lkml.org/lkml/2026/1/8/219
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Chen Ridong <chenridong@huawei.com>
> Cc: Christian Brauner <brauner@kernel.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Eric Biederman <ebiederm@xmission.com>
> Cc: Kees Cook <kees@kernel.org>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Michal Koutny <mkoutny@suse.com>
> Cc: Cyrill Gorcunov <gorcunov@gmail.com>

Looks ok to me. Thanks, Andrei!

Reviewed-by: Cyrill Gorcunov <gorcunov@gmail.com>

