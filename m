Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57537D59D99
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 12:08:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC48E6B0011; Mon, 15 Dec 2025 07:08:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9BE26B002C; Mon, 15 Dec 2025 07:08:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB17A6B002D; Mon, 15 Dec 2025 07:08:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9AFDE6B0011
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 07:08:25 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 64E9EB69E9
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 12:08:25 +0000 (UTC)
X-FDA: 84221582970.17.00DE367
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf15.hostedemail.com (Postfix) with ESMTP id 899D2A000F
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 12:08:22 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=A8nMhl0+;
	spf=pass (imf15.hostedemail.com: domain of elver@google.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765800502;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+DGkbwvSveRrQtSlxFukYMul6SfDciYSPOsqEu5ZQPQ=;
	b=Gy8yUT1SEzTf+KEBHIxILPemSrc5eiYVlGr2MjFlnkiol0BHNGnb3UFAm/XpHruhhV83O5
	U5G0qguhwURub92R9YKr03cemLK74jMyHY3Jd0K/0jD3B1II6tXJ3kSw5u7Cn4ix2dp7Sl
	n6en0ERHgp4VRiSoWYd4MMXAIV8drC8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=A8nMhl0+;
	spf=pass (imf15.hostedemail.com: domain of elver@google.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765800502; a=rsa-sha256;
	cv=none;
	b=d5UZtdx6dbEKuenDo2mJwMGhFMCySwsyeCpb7syucAhgi4Q1wwym/RXxb+ufZslYukacFs
	rXQ7P3H9AFpBC9jaoK6VzQH2WFu6V7Wv1Bkcy+xvTM2Kbpbi5f6hoMfMZVpKAnGbaQkrcv
	Nr/vYpTRDs4WOgyHj0gx9wYMsEfW3hQ=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2a087b2a9c0so23808635ad.0
        for <linux-mm@kvack.org>; Mon, 15 Dec 2025 04:08:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765800501; x=1766405301; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+DGkbwvSveRrQtSlxFukYMul6SfDciYSPOsqEu5ZQPQ=;
        b=A8nMhl0+yFAQnCXfm+x6awTK2pXwGbIGw38QkOmLENtqx4vGqWRaDBYRlmVyEPsF7P
         uApHeiZTMp+yi1AJdk3gLE3d/yxE3lPJKcylHy0aZey4qwyGZ4MEs5TkglpYadlOXZ8V
         m73LWTtA+wPNQjxqn4ecVEyIJwUb8lDZg+53DRIdKKTq5lRsZmTNfEWn8sk+HGY5OPLY
         /i/HqkFy7pw0uubDdjFvb8ZnWQAdei/ezPx9HDk0ilZZa6+g9iZS6toXHdV6JwNL98Sb
         z0xQNYX4AVnnDbjIIOCiAtRMhD9M5zlj45NsRvBas3IPe9NQqlXwD/mn6Cw1utnBUEpq
         SY4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765800501; x=1766405301;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+DGkbwvSveRrQtSlxFukYMul6SfDciYSPOsqEu5ZQPQ=;
        b=l20vutmnyKH+YI8lHM1BSC63NFVgRObqeONA98C/aWinl7S3fnyL5p7xD7Sin3gbG+
         P5FCigpwCuFShSQcRNtRmmc8IS5hqqCj3wCjIG/pZhHmgWxn3a+WAHRpn0arHSPRC5XT
         h+Qq0gwCBdiLVAt5zSstcL8A+g6vL3B/ow1mN+D+ZNzWNlZtKLMhX0l4IXN/SBoWl8iK
         C2myPzbyvM/N8Fru0+MV4j7m/pNGmVGscDHOr5f0+GwUb7DrFfgu+Jqq+czFeAFmStRf
         iYWeaikoEt9okCIFOdpxUvwLRO8+Ihdo/H+EwuQuirrhj8wSG16Z77iteRo9Qb/9Xxu1
         48Cw==
X-Forwarded-Encrypted: i=1; AJvYcCUEdvjSXb/Bi8nraPiSUbGddljt6uzLqDg6iLhYe8cFyOBT9gbV/GE5T5twA0V6MPfgwc1thlebVg==@kvack.org
X-Gm-Message-State: AOJu0YxL4/Gusb4DIyhWnIjYLKtecy8E2/cwjfWo+G0u1k0czPvVnouL
	J5boGlRdYrWFuNBuslLCMwbVPpqmchEaV0Bz7RznSwELhhq6AHT7x2+ow5b5HFWeti8tN6idIUn
	v80nMBw8pfnpAL+y2MGXlzr+SeKgdUeVM8cyNTKi6
X-Gm-Gg: AY/fxX616yzVPdNEg+Mq11yXqgw+bFiY5CERYjL1AtkfxWE8rDv7v3so/SKNhB3FLi0
	bdlAEBp2IllWM2mzRr60prO1UWYB6thjvU6CZKy4nxhugdyaQQ9QdoN2O4sXWrpLGmcEom2s2OQ
	IjKWSiqFDOPqGXqKDVPzfvxx0G1FxdMNNgE3SqfWDPrwzLML3GuRK6TKzaViXn7Ut39pGwwAnaO
	LQNjBN3uG10A7hF+6IyJD8hNcaAWRqLNaiKCdcpUaXoB+Avjo2vZoIP7gafP6gJZVQbJto0zzxz
	KqFXY7B4Bx9RBFr95RQ7aJH11zcEUcQSNQfo
X-Google-Smtp-Source: AGHT+IEBC+acRqtjaBBJQBmhlbonF1wwGFrMO77Zlp8D2bmspUQHM2nItV5HpI3KRFKcy27LH5o2hYak0ysa4tYnvE8=
X-Received: by 2002:a05:701a:ca0d:b0:11b:8fc9:9f5d with SMTP id
 a92af1059eb24-11f34c4d15emr7306064c88.30.1765800500924; Mon, 15 Dec 2025
 04:08:20 -0800 (PST)
MIME-Version: 1.0
References: <20251215113903.46555-1-bagasdotme@gmail.com> <20251215113903.46555-6-bagasdotme@gmail.com>
In-Reply-To: <20251215113903.46555-6-bagasdotme@gmail.com>
From: Marco Elver <elver@google.com>
Date: Mon, 15 Dec 2025 13:07:43 +0100
X-Gm-Features: AQt7F2pEt11ob6m3jn_EvmNyiM9lcI5ir1gIqaEopvbMbWpYo3dEgZbn6PIAiFk
Message-ID: <CANpmjNNrHYCPp19A_FPeFY1kSTuyS0W_zjo21AUrmjqjqcYa0A@mail.gmail.com>
Subject: Re: [PATCH 05/14] mm, kfence: Describe @slab parameter in __kfence_obj_info()
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
	Dmitry Vyukov <dvyukov@google.com>, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
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
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 899D2A000F
X-Stat-Signature: wuckssimifx9h8shm63xuzxidrmtbyf7
X-Rspam-User: 
X-HE-Tag: 1765800502-365208
X-HE-Meta: U2FsdGVkX1+rA8N0Aqy1ybvZ8OrDH3JPBswoUdaz4LleV5yxK/KuEWXximbTq7SJWJ33cBwdTERBv/6+kF/H1AskYvHjxxg3RrIWNk/rpdnYmwP5rPmNiKRUhHgjW9lyaSExrzgjFeiWjGg34TZUVCJxIQSa+sd4tQBJcTcvXtIOZU/AS6LHPsw3g/30EvkbPGviIi6bCUZ4RYvlmnFtGx8Iji75EvbcDDh9Ef6NmFhqoCl8wTtXmJhVBzUbq0c9OG7VFbH3SlgI2N+1GRYBuqsDME5YpGLxlyItkPnBdtre/N+n4+qyEHQbjYlC8HKft5eB5ELfAvBuoCKY/lRdM2aDOn2RaPFHZZRrjctIzZT/C/rqUnPt9A/BwTOw47cHYTOAkIfb1TzGUULKqTmVDg+Ql5am1zd6xoO0Gn7w3qya+cO+MClXTP+INOsizev8a5J3HgA/Ai7aUHr3wmf47dKX7nlk6miMEQN07QLmhcPIyC91SKVJ2jC4FE8aCkGAfCZ2867lfU5FFm5qYdJdifD6dxrmy173aNdoAh/5XpQJbkfhcQcUODQYjs2Bu7Zmoj5ZLB/UPzmoFI8VjsiiKaCJc0KR3tqyKI/O2dZG+s6OumDceb3/Fjgs1hkCtsQmGlksuFQj3Uv11tEru0PafrrSKZClzvpbpgNZZz+PwcrLp2nVy2yFvuYU3m+fSq1PjOVfU8x5d3qGLbu6JUzEki5ILMT0yqYCKjrfJgQEmnzdwiWYuoYd9L9JazP44R6GHOBcNo0Gos9ehqz8JDJQ5Ir1gOv70JG3/iKVUDOn57n2zps9lun4tpLjt4HrzSlNQ/vRNSbkoNOBlNfkLUWhPCsKrFDcNu+kONs35caho/ysg0WGd2jdwSNWYeRSupG1XGf4Sm/h3janr5zUo5BbfpXoGxl+9h8UQDGcxmhUzlkccDoaE2IL+CH/BaYOWJfcR7m59XIzTz9SLsE8GEP
 z4Frh1Ed
 tnGNxEM2Nktbyvfj6376QSaSHqSqNXqBwl3ZFsGbtj8a1wPL/psQTJr1IpdSIRwH8sKw0LfN51ur+xkl1SQ4GnZMqnk7EdpQUVwGkM74SJcib1ENZwd3M8/U/X0OkP+y7kdbW+a6eKLegLdAiwnnKxKTMVMcCspTzHaBdOwwslNVZzkQm4wCb5Q0esiIU/ObOpFdx+OSs6DtEMGGcw90LWgsbHE3zejJ+ls7057Vz8hL6kYvXjnfSjd1fkQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 15 Dec 2025 at 12:39, Bagas Sanjaya <bagasdotme@gmail.com> wrote:
>
> Sphinx reports kernel-doc warning:
>
> WARNING: ./include/linux/kfence.h:220 function parameter 'slab' not described in '__kfence_obj_info'
>
> Fix it by describing @slab parameter.
>
> Fixes: 2dfe63e61cc31e ("mm, kfence: support kmem_dump_obj() for KFENCE objects")
> Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>

Acked-by: Marco Elver <elver@google.com>

Thanks!

> ---
>  include/linux/kfence.h | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/include/linux/kfence.h b/include/linux/kfence.h
> index 0ad1ddbb8b996a..e5822f6e7f2794 100644
> --- a/include/linux/kfence.h
> +++ b/include/linux/kfence.h
> @@ -211,6 +211,7 @@ struct kmem_obj_info;
>   * __kfence_obj_info() - fill kmem_obj_info struct
>   * @kpp: kmem_obj_info to be filled
>   * @object: the object
> + * @slab: the slab
>   *
>   * Return:
>   * * false - not a KFENCE object
> --
> An old man doll... just what I always wanted! - Clara
>

