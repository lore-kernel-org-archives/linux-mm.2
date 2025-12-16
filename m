Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E11F4D5B87B
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 00:19:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 515DF6B008A; Mon, 15 Dec 2025 19:19:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CC976B008C; Mon, 15 Dec 2025 19:19:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C1AA6B0092; Mon, 15 Dec 2025 19:19:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 28EDB6B008A
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 19:19:26 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C5B0F1603E2
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 00:19:25 +0000 (UTC)
X-FDA: 84223425090.11.22F71A5
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id D3313C000B
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 00:19:23 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=S1az3cSU;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765844363; a=rsa-sha256;
	cv=none;
	b=AvhjHmWOjB5+Wq57UVbJhaXM7p1Qrj+rVbfsR+mDGEOl3bQmGayuGfwOBhtcX5hNlPnZda
	RG0Ppz4L5dSJWEmbYPZkS7Zp3UnqWdPvnPK8RLf2E006stuI+zEowtxgziHz5+YDfOR1Zy
	+5AztkcZU1eD8MDvdJFym8aY3Xh2jus=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=S1az3cSU;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765844363;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sk1yhdZDsbmHyAUXRbfG+BCb5AaoOf6d28kSsthudBo=;
	b=6LM3uQ8i8yjqidIsR/PO/fzavRbEDcVRhbjNUI+aR1ksCdRZkJ6WtxRP3Qi3XoAyW8jQzh
	VUmHFryMbOIuh8OXpzV9j/8DiuxfVmas5kSv2UycwASivhsDPFXLwWB+wvZ/IQHMFAz0Kv
	3ECEDMben1wFfi3neCqwXoUYfKnFDTc=
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-b6ce6d1d3dcso3820402a12.3
        for <linux-mm@kvack.org>; Mon, 15 Dec 2025 16:19:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765844363; x=1766449163; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Sk1yhdZDsbmHyAUXRbfG+BCb5AaoOf6d28kSsthudBo=;
        b=S1az3cSUMICZ3hSetlxesZZlcxP6L3Ig/7k9KKuBEIOEOHFEKC1/Tjxl4JwC1mBmqG
         T1n0ql7LDeQ3FANCl3jMbav1bWqLksGI7z3CHfZlRWpqVqAr2ucpZqysooe4fvmSP3O0
         lPtk0ZXefMzn8LQV/op6IQs7aQB3cbSvt97vFOnUagzWkpez6MbLEyQbs88UG/9KV339
         kTg+LP+1nBr+fr4UIKz5Wj5Y8cr6oAxpoprdgeJ0ijHj9GKFX2v5yqyxlGNw4FGRikUV
         8wYF80qjbWFd8dKIylNsyk2SbjYRgBOEzz9a9H3WgT+qr/vPA18nvzcpVpvsEfMwxT7O
         NIQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765844363; x=1766449163;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Sk1yhdZDsbmHyAUXRbfG+BCb5AaoOf6d28kSsthudBo=;
        b=H7r49VI07kFj2290lPLGzhCDeROlvq6u3qyhrKje6RDAthLufD2Uz+roNhrX5IQDV3
         8t9tHDWYccBmO/KW4dYkFRyVCep1/tT0euQA6aEDPs+cyXaSLQU3mY6EMREUABnJ8H/D
         vO4XoG2YTPDCORtHr9a0QFVJ14Bv5F2lST405mUEzAFoRmxt7qq6q2enWRc3hKL2oPV4
         zdapvLRBnyM6wQlk4asOY7pMctq2TJD6NoYL5ZUW1OBYzOUS/qoD3U/00O1nJrWOm6+z
         G2TPsuUYxDvyPY9rg9uzncifnleweE57QCsUKt7xWMUaAlHZaiyQ7Hypi66M2Nb0tzjo
         8g+w==
X-Forwarded-Encrypted: i=1; AJvYcCVZLetKJC5pk587Gab53sqF440OrvlSg+tyiEYMJ8aO/cJRNvnyt684CeyarhxNBitMJxeuOsflMw==@kvack.org
X-Gm-Message-State: AOJu0Yz7ZxgiMa9qes7ESva4xvhn3ogMu48l5CjNPmIXSjZk4hi4V4vA
	fGfJzxX15SFMEBN27SPiFyfDcKR20VOe9ZaBDTI8Jqtz7CbqpBXj26Bk
X-Gm-Gg: AY/fxX4niK/vw8f8ksThH5i+TQUbDevMkFdWzItv8o/IHATs221P7w53w/5oACAyU12
	GHDaGLfRhU3/1qMFVPKOfU+prVssAxu9wSodKaU3A47ZdK2qEPGULzRZsEFuez9qaLJ5PS2ilOA
	o4TG5I4fTNg7322YDCSVZ67mEFo42UUktEkab/z3q769eAny2A1z/ZBKXZdIm5ttnTbOJB6T5u5
	L4jyl+Tj3GsIjdrsBo7rmSDQ1L3rli25FXsC7mMeOJhkT1IVuZANZ+rOuLcW1I1L7T86c8e6tEA
	vwwEE3nQovX4NL+ORnltZMMbjibTSR4IUItWVza1163Zsobir466LZm5Waru4ep7cHEDqkwiMAD
	hH4qTgk0bF08b773eaGb+uBnNiGVM98mz4boLV/7dQU9yowFG1lb4wwMwJS+hub7sNEGqDOK897
	IWQACXlJTNPD11kfLfx5qoJV24SUuRCykaVXqaz6UhOO4=
X-Google-Smtp-Source: AGHT+IHmrytMydYNAgs0qRZg7qEjrXkSVHGK3fUWY6ADeu6KzKqLiLcf4Z3v4UGHQ57LoQ8XnYjK1w==
X-Received: by 2002:a05:7301:f84:b0:2a4:3593:6466 with SMTP id 5a478bee46e88-2ac300f729dmr7381219eec.22.1765844362545;
        Mon, 15 Dec 2025 16:19:22 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11f2e30491dsm51066947c88.16.2025.12.15.16.19.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Dec 2025 16:19:21 -0800 (PST)
Date: Mon, 15 Dec 2025 16:19:16 -0800
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux AMDGPU <amd-gfx@lists.freedesktop.org>,
	Linux DRI Development <dri-devel@lists.freedesktop.org>,
	Linux Filesystems Development <linux-fsdevel@vger.kernel.org>,
	Linux Media <linux-media@vger.kernel.org>,
	linaro-mm-sig@lists.linaro.org, kasan-dev@googlegroups.com,
	Linux Virtualization <virtualization@lists.linux.dev>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Linux Network Bridge <bridge@lists.linux.dev>,
	Linux Networking <netdev@vger.kernel.org>,
	Harry Wentland <harry.wentland@amd.com>,
	Leo Li <sunpeng.li@amd.com>, Rodrigo Siqueira <siqueira@igalia.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Matthew Brost <matthew.brost@intel.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Philipp Stanner <phasta@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Taimur Hassan <Syed.Hassan@amd.com>, Wayne Lin <Wayne.Lin@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Dillon Varone <Dillon.Varone@amd.com>,
	George Shen <george.shen@amd.com>, Aric Cyr <aric.cyr@amd.com>,
	Cruise Hung <Cruise.Hung@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Sunil Khatri <sunil.khatri@amd.com>,
	Dominik Kaszewski <dominik.kaszewski@amd.com>,
	David Hildenbrand <david@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Max Kellermann <max.kellermann@ionos.com>,
	"Nysal Jan K.A." <nysal@linux.ibm.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Alexey Skidanov <alexey.skidanov@intel.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Vitaly Wool <vitaly.wool@konsulko.se>,
	Harry Yoo <harry.yoo@oracle.com>, Mateusz Guzik <mjguzik@gmail.com>,
	NeilBrown <neil@brown.name>, Amir Goldstein <amir73il@gmail.com>,
	Jeff Layton <jlayton@kernel.org>, Ivan Lipski <ivan.lipski@amd.com>,
	Tao Zhou <tao.zhou1@amd.com>, YiPeng Chai <YiPeng.Chai@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Lyude Paul <lyude@redhat.com>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Luben Tuikov <luben.tuikov@amd.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Roopa Prabhu <roopa@cumulusnetworks.com>,
	Mao Zhu <zhumao001@208suo.com>,
	Shaomin Deng <dengshaomin@cdjrlc.com>,
	Charles Han <hanchunchao@inspur.com>,
	Jilin Yuan <yuanjilin@cdjrlc.com>,
	Swaraj Gaikwad <swarajgaikwad1925@gmail.com>,
	George Anthony Vernon <contact@gvernon.com>
Subject: Re: [PATCH 04/14] mm: vmalloc: Fix up vrealloc_node_align()
 kernel-doc macro name
Message-ID: <aUClhBdwQb83vN0o@fedora>
References: <20251215113903.46555-1-bagasdotme@gmail.com>
 <20251215113903.46555-5-bagasdotme@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251215113903.46555-5-bagasdotme@gmail.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D3313C000B
X-Stat-Signature: n4qouxjfd86f445a6wo3aipc81b56tr4
X-Rspam-User: 
X-HE-Tag: 1765844363-521728
X-HE-Meta: U2FsdGVkX1+4csIKmyLRBrL2WMfi1hS5eFA3HV74E3YSaVz3q5aSTkzTLhwh7jo6feFx9VwfVSDBz/4hko2p+eJ32R7LuDnq1VhLyCCcUbu1wo6CP8ynq0bNJ1SGqVjCWSTr1ALKksjXyAEsz2LgPAi05TdO0A31BCzuokKtmHjHOd4LG6LbgBg+NnG5zCVs4JCjSTLE8EbALlIWM4VZxwwByM7axiTiRqqACBSJZysG3aheNsmGzVFEIZX6wngC0M1hv4DZ14zbHkxHiuNBlJOwKMGnWOSJCUuPLBwqV0AnqwNnbhFJ1dbTpyu/sw2ckZdXQwqgOt3rp0zKDDu7XCoeVuYoq8b1Yxb+BORKu06ZqTU6xCV2TBuKU0VWvTV01t+Fw7R4VcE+Y8um5TTsAODsS3Tk2+umMLq36PkXosevltoW5d0Eh0nrT2pzFjZj5ZX7xf9YYmwoZkIB3xEKw+1KQ4G6Iv4PcTChaSkduVl4XEjy4Hs4yqK3u5POcMSw2uSefFqvbFIOLmo7mQMNQNK6aqe+8vcONNt1cKnWwktisbjZrHiZ5zubRhJlKOXT6YRqkd8G9RZbFxl6+R2BWbi8DOKaWQROUExqmLPWKN7KTwrVtHuwtNV4E+AFexzmUwp9WnuwSAp5Y9klWDAajOjVOqt6REZdBjlNkQo07pDcFiWBXMJXFR1uJHNKVt+CdPPR6wjX07fM6mec46nyI5pwxW/ZCHMjeBYjK402gQWEObROHi+eVtYuvnDEkaAoVHpWVhOJQEFabznqGUMPANbH+hp6xY/MWP14xdkbkfGOwXYugRttreeNk3+QkLJZbUEZ5o2VfZgtpLGfAS0v+QrKLpjZFU5AleEUpHBTvihsVoqWMSYHzIn1s0sh2UKbzp/w6aTuq08rvo9tG94lQl7jGIrYYvPml8rZU5+nxgmaJ0zRufhuzussCL3TJNfmKD1YFONtZJgB6/YffSS
 YKDhSc1+
 OY5UOLeLspxhT5Mpnlv2LIW55JOkft+7ulfusRYY25DOtxn8cGMB1bxfwx2P/PF6U9V4O/bwHN8G7CbcJEO+ffpU5UYrw1IdbUCewHhNVH2gef6SUHz7bfXidW1ZxZEnBt2nmtzhGWU6c5xQbxiIDdZmgDZi8nlcyjeRkgDz6PQ6JzhHcdXflAcx/5HrxHT9ia4u9bt7AMPOgSbci51LNTrx9KU5FqI0t1T/k6+hJrLzkezcHZWhndOM7cHarl3TFSLeVNOdubfU1gMWC4QEflXioTkIR/uGOp5tv1B+7o842Jk1x6SkqEnsWj1wcyZllRziwTSWLrZwwKRPip1kHCWnxGgKQx8sOJysjRoDOkHREmU2cKEXbkwfJ5Uv5MAnzPcbTDKzwFAMJiEABCmlUCqngHYDNvnHOrrgqc0VgmtSuMYZowoz5u5a/rJ1n2TjZLHRQ/xzMAAWn9358xsEVgJdHdj4jFspR0n3Zdh7FVhdFYDvNF554rlNbhGMg+ccTGXai8aMvruckEdQudUghF1hx+A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 15, 2025 at 06:38:52PM +0700, Bagas Sanjaya wrote:
> Sphinx reports kernel-doc warning:
> 
> WARNING: ./mm/vmalloc.c:4284 expecting prototype for vrealloc_node_align_noprof(). Prototype was for vrealloc_node_align() instead
> 
> Fix the macro name in vrealloc_node_align_noprof() kernel-doc comment.
> 
> Fixes: 4c5d3365882dbb ("mm/vmalloc: allow to set node and align in vrealloc")
> Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
> ---

LGTM.
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>

