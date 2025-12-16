Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39B3ED5B161
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 04:18:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A1246B0005; Mon, 15 Dec 2025 23:18:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74AB16B0089; Mon, 15 Dec 2025 23:18:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64D706B008A; Mon, 15 Dec 2025 23:18:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 53B686B0005
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 23:18:20 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1643258E7E
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 04:18:20 +0000 (UTC)
X-FDA: 84224027160.22.502A91F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id E1D74140007
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 04:18:17 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AZZrN+FP;
	spf=pass (imf23.hostedemail.com: domain of jasowang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=jasowang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765858698; a=rsa-sha256;
	cv=none;
	b=MK/poX3mxWUx/lR+YeH2Y7SseUR4R4mp/QWnhnnwus9uJFXW6cQm+OOO6Z3vbZAOgAPGGT
	8oYMzAlgpb2RTtA+s700aAzMBrq7AHYN5pfr8VC5h1WUG4mJ9zIhKI6hzySYH1C23AxgC/
	6AZMF6Xa793nCZdRPxUnUo+K4aQkbMY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AZZrN+FP;
	spf=pass (imf23.hostedemail.com: domain of jasowang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=jasowang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765858698;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8DUjCNr/nxXg5R3wmw4ZM/MLoFfePhldzOpxojnv4JY=;
	b=J4P95g3mPtFO3v2EF2opK08SLa3HGCThmJ+L7Ks1xoYzfmZMOSdhrH5jmzCyLk/fF71n4B
	D3r4ZpA6sEiHFETO1TXb392O/9kJlQetM/TmZ2Xc2qp0hoTCvGS/xHMeppbcWxsLT8jdhO
	aODP9jnBT6b6Nvy6PJtGZUMR01ipZmo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765858697;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8DUjCNr/nxXg5R3wmw4ZM/MLoFfePhldzOpxojnv4JY=;
	b=AZZrN+FPgR7YhKUpptcO6O3YIbLDuYAvXTCkCRC1VfgKzUGdpb10LItb7SKNOSTOgRnSDf
	UGQ6ciNsUrI/y3jXuzU5n4mDZjCPtHma+dhM1+zP2QtcpaCoZzwaobdoX3wtW6mL4M7X8D
	seUFSGB82pZ4fgxfiVve1tjz9aKF+yo=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-589-KdHdNqa2MreuYX7BUbIHaQ-1; Mon, 15 Dec 2025 23:18:14 -0500
X-MC-Unique: KdHdNqa2MreuYX7BUbIHaQ-1
X-Mimecast-MFC-AGG-ID: KdHdNqa2MreuYX7BUbIHaQ_1765858693
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-34c314af2d4so2681516a91.3
        for <linux-mm@kvack.org>; Mon, 15 Dec 2025 20:18:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765858693; x=1766463493;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8DUjCNr/nxXg5R3wmw4ZM/MLoFfePhldzOpxojnv4JY=;
        b=dJCSu3zdW+ty3YC6zAG5WKm3DhBTqJIKekBFutAz2L8MIGjK4y9bM5KfC4gWvg5QLV
         lK8r86TZxTWTAkDFVGM5pj9IeNZDqlWtf8J08WItMUzUgACel1wIJuaZxmL489yKFy+7
         c8c30VTQ6Iid+dsKC4SUqNJ9tp2JAXxjsfStWLQLwubiA6c8GUHDw35aaZss7hJmm1B2
         /Wsq1xChHoEuAxDUA8QIgNCsgE7ABLfwO0Wzc4lYqKlWbUw/I0ioNa9k2ZqlxappM/xg
         l8Ay4aLihew/QnDu1Zl6W5uEAJy257s4E1aoo52om7YQ1OhDoQRQnenHe6qDAXFOIwRe
         KUZA==
X-Forwarded-Encrypted: i=1; AJvYcCUcy+BcH6YF9S+VDfd3jPUw8zHvObGZ1FAvHRst3cmo/ruAlonhGxsIhBQLEtPYwJ5FT+mjrV08Wg==@kvack.org
X-Gm-Message-State: AOJu0YwYplBassawUf3Bmeh3bdgtpDKZN3MUKEXjj0aQs5AYPuQP0VLy
	/7XrLNdv3M1y6Mbljw3qg6iOyskYaWDknm6B/7E39Z6sRtriLYxFlxnXSV7ITmpMO7KeeJyCaGo
	93jlnHFR+GSmxmF2h8GqWLVvgKeRxlcucJi7d5LdPj3+FyWezAECd2RI6SymnXlUa/C+muPtHQM
	yzVpSwuyWNHAwGxPkVoezIjdHp1VQ=
X-Gm-Gg: AY/fxX4bKUWVxx1nuKM6VeZME8/Yrb70vVHEt0PoQi1nlggOAHT5WrfNz8Ur0fkpTpy
	EZ1ngZ2M/9VpveZNHKJKZNJ97fJt3YtsZvo23xMks+h61GeXc3IDxlgHv9tL7UGOpoAXK4W4BsQ
	0TMkKANH429xKlPbLi6zRzjBpnZNa1110vljlY/Z74/3z9YqrQW2vXzXdI1zSriha+Qg==
X-Received: by 2002:a17:90b:2ccf:b0:340:f05a:3ec2 with SMTP id 98e67ed59e1d1-34abd81733amr14699608a91.17.1765858692988;
        Mon, 15 Dec 2025 20:18:12 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHD77DQk18dayngXtbIw3fsOCk15EBfDyLwaFsEN4158FtjFJzrWxy8+rjy6tA50q0hvVxRQAeZswAuqcmTXkc=
X-Received: by 2002:a17:90b:2ccf:b0:340:f05a:3ec2 with SMTP id
 98e67ed59e1d1-34abd81733amr14699535a91.17.1765858692536; Mon, 15 Dec 2025
 20:18:12 -0800 (PST)
MIME-Version: 1.0
References: <20251215113903.46555-1-bagasdotme@gmail.com> <20251215113903.46555-7-bagasdotme@gmail.com>
In-Reply-To: <20251215113903.46555-7-bagasdotme@gmail.com>
From: Jason Wang <jasowang@redhat.com>
Date: Tue, 16 Dec 2025 12:17:59 +0800
X-Gm-Features: AQt7F2q1idGMqOnPlq5afbA61NEyezJumJNhfdWiFdPMuPeC3DZ1U_cOOaqg6iI
Message-ID: <CACGkMEtJt7Df5kXWex8EoKdakdB8_xLjgCXQt5pUvk0dkGzVMA@mail.gmail.com>
Subject: Re: [PATCH 06/14] virtio: Describe @map and @vmap members in
 virtio_device struct
To: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
	Linux AMDGPU <amd-gfx@lists.freedesktop.org>, 
	Linux DRI Development <dri-devel@lists.freedesktop.org>, 
	Linux Filesystems Development <linux-fsdevel@vger.kernel.org>, Linux Media <linux-media@vger.kernel.org>, 
	linaro-mm-sig@lists.linaro.org, kasan-dev@googlegroups.com, 
	Linux Virtualization <virtualization@lists.linux.dev>, 
	Linux Memory Management List <linux-mm@kvack.org>, Linux Network Bridge <bridge@lists.linux.dev>, 
	Linux Networking <netdev@vger.kernel.org>, Harry Wentland <harry.wentland@amd.com>, 
	Leo Li <sunpeng.li@amd.com>, Rodrigo Siqueira <siqueira@igalia.com>, 
	Alex Deucher <alexander.deucher@amd.com>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, Matthew Brost <matthew.brost@intel.com>, 
	Danilo Krummrich <dakr@kernel.org>, Philipp Stanner <phasta@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Sumit Semwal <sumit.semwal@linaro.org>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	=?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, 
	Nikolay Aleksandrov <razor@blackwall.org>, Ido Schimmel <idosch@nvidia.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Taimur Hassan <Syed.Hassan@amd.com>, Wayne Lin <Wayne.Lin@amd.com>, Alex Hung <alex.hung@amd.com>, 
	Aurabindo Pillai <aurabindo.pillai@amd.com>, Dillon Varone <Dillon.Varone@amd.com>, 
	George Shen <george.shen@amd.com>, Aric Cyr <aric.cyr@amd.com>, 
	Cruise Hung <Cruise.Hung@amd.com>, Mario Limonciello <mario.limonciello@amd.com>, 
	Sunil Khatri <sunil.khatri@amd.com>, Dominik Kaszewski <dominik.kaszewski@amd.com>, 
	David Hildenbrand <david@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Max Kellermann <max.kellermann@ionos.com>, 
	"Nysal Jan K.A." <nysal@linux.ibm.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Alexey Skidanov <alexey.skidanov@intel.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Kent Overstreet <kent.overstreet@linux.dev>, Vitaly Wool <vitaly.wool@konsulko.se>, 
	Harry Yoo <harry.yoo@oracle.com>, Mateusz Guzik <mjguzik@gmail.com>, NeilBrown <neil@brown.name>, 
	Amir Goldstein <amir73il@gmail.com>, Jeff Layton <jlayton@kernel.org>, 
	Ivan Lipski <ivan.lipski@amd.com>, Tao Zhou <tao.zhou1@amd.com>, 
	YiPeng Chai <YiPeng.Chai@amd.com>, Hawking Zhang <Hawking.Zhang@amd.com>, 
	Lyude Paul <lyude@redhat.com>, Daniel Almeida <daniel.almeida@collabora.com>, 
	Luben Tuikov <luben.tuikov@amd.com>, Matthew Auld <matthew.auld@intel.com>, 
	Roopa Prabhu <roopa@cumulusnetworks.com>, Mao Zhu <zhumao001@208suo.com>, 
	Shaomin Deng <dengshaomin@cdjrlc.com>, Charles Han <hanchunchao@inspur.com>, 
	Jilin Yuan <yuanjilin@cdjrlc.com>, Swaraj Gaikwad <swarajgaikwad1925@gmail.com>, 
	George Anthony Vernon <contact@gvernon.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: GRDbx7z0s0iz2dN_myRHqnMGQCxKYbhFR3tB0mAkY78_1765858693
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: E1D74140007
X-Rspamd-Server: rspam04
X-Stat-Signature: 7osuazumsx4qnbepwnoige9i9wc9auyz
X-HE-Tag: 1765858697-245504
X-HE-Meta: U2FsdGVkX19yA5ZF2QOe/ruMdc0pXjHU15LRmSE9JwQGHpwK8Jq1AyDS2E+Lw6vUjIavSnZw09So27/R4bJ6Cjg51PJHsOuaRnY9AMBz66uIXZPfL04iE4WGGSHQFozsCo9BVSb0BYzFcjCOSU2VUNOa1yXRKRvaatL/1NH1KfP8HfEC5x/d8mVkjHb2CcC5LPNiCgpfsfH53KovkH8dddCq/lz3mBEgZZEerOaaRDu0iAS4nOemRwoVncFvydiluhMD/IIR8ImLNwAyqp5TCrlvrCTHc94l6Zle6lx+z7i8zhX5F94WGWchhSUXWkK2nnfB2TJlhtCIfasVpbY/NFNIQc7a2wF8Y9nrJnYArrRa8+MqeKn8HhD/Oj7UTo96BzvNF4IUS3af9IxiZnRNFiXJ86PIM32BRKPA7CyAjSlToXmCJ3H5TV5ICKTYukEo+YXDD3iBGGdk41XRk2MK5nAcjiBAB/1NpNK0RdD8R/Zs+t9VPbaD8t6WoNnCVB4aGUzjMCDccQqvl7hZZY7Av/b3EARcJV1kOx9aFqy2B5Xr7ZGPiujdEbpc9g9BjaXEiuaX+2HCLCGX8GnlUrLvbOcQ4r6kwQYdKdtQaeNUv6W0h5eTp+44aulJ3OL3Zwcfvf3g0fM1s3GHKK2xHlW0k7ucqQ63f9rQZyp5mR9TgxbEEuFJVutSRsv7oQTUglW+7aMLu8EjSBkveGFbYft5PCoziIqLva1AYNTHUs1aToGsV1z3RR2MXBO/aPERsDuq0rVbrfm5HpEZrEts1A9wCMcL70cyRwW9MXbTdvrYdHTQdJ6KWjf4HshFPGJ21C0Fyt6MgZ/V5FSMESz5wVGcqkZvRsCSGWqgDhqmqDnkDiUY7d+II8dvRq+AsB8/ZCeC02p4xrhg2hnrwKKNPRJx7EZGBIijKmWIGDT9w/kn5wbMuE7UDkF5bLI55cFn1/RvU2Los4kW8QK+Pm5G1uY
 sTVsoWpB
 vtmbCtQ9EqaeYdJCr9cKsQwRYjTqzpTXysPG4jV8JFzZ0LmP3luf6/9lz+/bkeVvNkz2ROKmP0mw6ZiiBh6GrvpztWw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 15, 2025 at 7:39=E2=80=AFPM Bagas Sanjaya <bagasdotme@gmail.com=
> wrote:
>
> Sphinx reports kernel-doc warnings:
>
> WARNING: ./include/linux/virtio.h:181 struct member 'map' not described i=
n 'virtio_device'
> WARNING: ./include/linux/virtio.h:181 struct member 'vmap' not described =
in 'virtio_device'
>
> Describe these members.
>
> Fixes: bee8c7c24b7373 ("virtio: introduce map ops in virtio core")
> Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
> ---

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks


