Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04C33D637DC
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 22:09:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54C0A6B0088; Tue, 16 Dec 2025 17:09:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52D0A6B0089; Tue, 16 Dec 2025 17:09:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42C5B6B008A; Tue, 16 Dec 2025 17:09:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 307CA6B0088
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 17:09:05 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C0B0413BB7F
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 22:09:04 +0000 (UTC)
X-FDA: 84226725408.15.DE7F793
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id F29F4A0010
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 22:09:02 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oqiadpWD;
	spf=pass (imf25.hostedemail.com: domain of kuba@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kuba@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765922943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B0kVLZK7YMAGW4+NymplABFlILpQoztpjaegZ/yGPWg=;
	b=ZNaAkfsDbxUiZZwCq9Kj9qleOxTuYcwOsWcAObD+QjUCtmbOWoDCC8LENn3DPQGGLQgWxT
	Sqa3ZgzCnyYhiV9d8blhXdujdKeM7XEBxypG+7sPoscwDoq/SGCDMWBOZJni/gHCwfkDuo
	fplzhqLUiLS6CZtKjIcHTzcvGeeYyZI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765922943; a=rsa-sha256;
	cv=none;
	b=oxxXeatI5+r1h0wzTmv3AlGyvUDCvmt3a/XzCbbKDpktFri/QCZ5PEC8j/hMMwEqtrYnDJ
	Cc0njg3rTI1woBquHxM53vkXiG6s9r6sYdpoARI/XEDPAazD8iyoQVxxuBejuENGE/5lxf
	5RK4ylIRuwP6xswt0ba+nruiha6F3Ck=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oqiadpWD;
	spf=pass (imf25.hostedemail.com: domain of kuba@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kuba@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B934240661;
	Tue, 16 Dec 2025 22:09:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4509EC4CEF1;
	Tue, 16 Dec 2025 22:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765922941;
	bh=B0kVLZK7YMAGW4+NymplABFlILpQoztpjaegZ/yGPWg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=oqiadpWDrn1VtQBdfyFy7VbAAFT/N+0QKxoy/la9xGx5fG3NMm5680qrqPz22qZtD
	 730Nc00631mF5M860GXrud+DirVS8MK0VRJURSahC1gOVM6BuWECPyT/JBCL+vTTHR
	 ANySaFterNV+lUXLbgI+r8YXLCTsj+4BuyJNK3LGYSvphQs/L5oShSzo5DruIKbDsw
	 M2Ec01YwtnmYPJ7y2JWbxiXJ1J5ndwfCfLR9yd6hMhGqoKzsqZ/GRP5mtCOsLCzOlN
	 J4KQTLdsHQL34okSpaVlrE+jMhJ41hJeBTw53maElT/xvlUJlwMFrwPOAejsH/MToP
	 PLc1BPivYW6UA==
Date: Tue, 16 Dec 2025 14:08:57 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux AMDGPU
 <amd-gfx@lists.freedesktop.org>, Linux DRI Development
 <dri-devel@lists.freedesktop.org>, Linux Filesystems Development
 <linux-fsdevel@vger.kernel.org>, Linux Media <linux-media@vger.kernel.org>,
 linaro-mm-sig@lists.linaro.org, kasan-dev@googlegroups.com, Linux
 Virtualization <virtualization@lists.linux.dev>, Linux Memory Management
 List <linux-mm@kvack.org>, Linux Network Bridge <bridge@lists.linux.dev>,
 Linux Networking <netdev@vger.kernel.org>, Harry Wentland
 <harry.wentland@amd.com>, Leo Li <sunpeng.li@amd.com>, Rodrigo Siqueira
 <siqueira@igalia.com>, Alex Deucher <alexander.deucher@amd.com>, Christian
 =?UTF-8?B?S8O2bmln?= <christian.koenig@amd.com>, David Airlie
 <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, Maarten Lankhorst
 <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>,
 Thomas Zimmermann <tzimmermann@suse.de>, Matthew Brost
 <matthew.brost@intel.com>, Danilo Krummrich <dakr@kernel.org>, Philipp
 Stanner <phasta@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Sumit
 Semwal <sumit.semwal@linaro.org>, Alexander Potapenko <glider@google.com>,
 Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Eugenio =?UTF-8?B?UMOpcmV6?=
 <eperezma@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>, Nikolay Aleksandrov
 <razor@blackwall.org>, Ido Schimmel <idosch@nvidia.com>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Paolo Abeni
 <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, Taimur Hassan
 <Syed.Hassan@amd.com>, Wayne Lin <Wayne.Lin@amd.com>, Alex Hung
 <alex.hung@amd.com>, Aurabindo Pillai <aurabindo.pillai@amd.com>, Dillon
 Varone <Dillon.Varone@amd.com>, George Shen <george.shen@amd.com>, Aric Cyr
 <aric.cyr@amd.com>, Cruise Hung <Cruise.Hung@amd.com>, Mario Limonciello
 <mario.limonciello@amd.com>, Sunil Khatri <sunil.khatri@amd.com>, Dominik
 Kaszewski <dominik.kaszewski@amd.com>, David Hildenbrand
 <david@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, Max Kellermann <max.kellermann@ionos.com>,
 "Nysal Jan K.A." <nysal@linux.ibm.com>, Ryan Roberts
 <ryan.roberts@arm.com>, Alexey Skidanov <alexey.skidanov@intel.com>,
 Vlastimil Babka <vbabka@suse.cz>, Kent Overstreet
 <kent.overstreet@linux.dev>, Vitaly Wool <vitaly.wool@konsulko.se>, Harry
 Yoo <harry.yoo@oracle.com>, Mateusz Guzik <mjguzik@gmail.com>, NeilBrown
 <neil@brown.name>, Amir Goldstein <amir73il@gmail.com>, Jeff Layton
 <jlayton@kernel.org>, Ivan Lipski <ivan.lipski@amd.com>, Tao Zhou
 <tao.zhou1@amd.com>, YiPeng Chai <YiPeng.Chai@amd.com>, Hawking Zhang
 <Hawking.Zhang@amd.com>, Lyude Paul <lyude@redhat.com>, Daniel Almeida
 <daniel.almeida@collabora.com>, Luben Tuikov <luben.tuikov@amd.com>,
 Matthew Auld <matthew.auld@intel.com>, Roopa Prabhu
 <roopa@cumulusnetworks.com>, Mao Zhu <zhumao001@208suo.com>, Shaomin Deng
 <dengshaomin@cdjrlc.com>, Charles Han <hanchunchao@inspur.com>, Jilin Yuan
 <yuanjilin@cdjrlc.com>, Swaraj Gaikwad <swarajgaikwad1925@gmail.com>,
 George Anthony Vernon <contact@gvernon.com>
Subject: Re: [PATCH 00/14] Assorted kernel-doc fixes
Message-ID: <20251216140857.77cf0fb3@kernel.org>
In-Reply-To: <20251215113903.46555-1-bagasdotme@gmail.com>
References: <20251215113903.46555-1-bagasdotme@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: qrm9dds3gftyeuxes41aajofmnx5edq7
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: F29F4A0010
X-Rspam-User: 
X-HE-Tag: 1765922942-668072
X-HE-Meta: U2FsdGVkX18CbcheZHG3BsgUXKhz7yI8L1B00DYKLIuTvz41HV9jfSa+hpVVS0NMhwlaBS9UdfcRB6VKXAXgFlamot0Kb2Gpn5zZDFkZOOz6jouaE0RgaUpbsmfToiEEq4/o0ZhMJhgzL3NOjh6Et8UFfwDPLq+0SmKbDSL8xYBjPSezk4wUEnKTdRGM4a2ifv4QXSnQbtm3UpMJOyQMoCwR6Akd+Vk431ktzIB9yWuweR2w1CSq1ZaaSSJqbg6qB9OmhqY936bnidK6cecOeemcq0YN36Rzxm4zONmJmDKWIq3nZg0BgsSPdoWtOLnSqrYo5ZnKOekna+szbmQdkdc3cmgNLEHwpOyPkhnJhXRGvf/GcpkK82BQrjn8TkXd3hrZ2S1bN+JooCfRbOxxJ868X903ZSPc1lK7UcSOelh+ZfhcUhd6enVSRIkX8lcJB9eL860OTqqis3OyNkrK7zz+azPMtazIeweMOVosivwxZDECoSrXxxrO/oDmyVdMuUZgP+hhL1GytzTPxjXOcMbHBbnEPyVcDEaK0ahlKOJFjf3ZcQRBhTxITDAMHa/vkrsv6iNioX3VY90bXPkAauTsYZ0pxQfVKz7SnQUQhoE5Q4wUMe0Xyd1L4iP+fBeO/fu3523jmuAF5tvLELa/1OR8GfrWKgdnIe+Y0+K8zHdGG7592F9Y/+FMB7oU8ys0wVvpedTJVklpCQQX6meawEANEBJg8JzUrszWutJEJW7PE3lUQ3wuDI/7ChCWVaB7TQFSFZHFuw43mfiiz33v5qghZTpEFwfxke8/a1pZI4ycr8idSwJwUq8e8gwaO603XpqDZHkwe3IgAQ4KE7eoXVNJVKXkZ2cumY6Gg8SBcnB9dURIq0cnEv1FormehLLrSYw14AYrkbWwTpugDKPshQgpVoB6h5O8KJY0L1zkqf5Ubj1AO06e0+vjRE6KXEujy6m3qybpIVcPeswWDEn
 0CbBekJh
 dBl1F6/CQzbaR+0n0CoIqBJx9uIxt8X1qQNsoua0TkxQ+LgmCMRlh8Hfo32rDbmFijqXm8R+EIdsfG9TSllq8UvnY9gYEPN6Nf3iq2tZCV3rM6ISBglWrT+qO7Kpa0RZa7jMGP/ad2BT/84Z6enZNkGJ+0ZP8CYQTGOejAd4VzPupPBBlIuHPX1zV8IQDHFGf/GTQefYEhsuWPGSVPGtjXdSMeGxLZ9pcuYMbzRbWv05Q4F6mwMY/xM56hHP/ImBhAPVg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 15 Dec 2025 18:38:48 +0700 Bagas Sanjaya wrote:
> Here are assorted kernel-doc fixes for 6.19 cycle. As the name
> implies, for the merging strategy, the patches can be taken by
> respective maintainers to appropriate fixes branches (targetting
> 6.19 of course) (e.g. for mm it will be mm-hotfixes).

Please submit just the relevant changes directly to respective
subsystems. Maintainers don't have time to sort patches for you.
You should know better.

