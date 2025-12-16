Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC98ED609A1
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 15:20:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B1106B0089; Tue, 16 Dec 2025 10:20:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 471506B008A; Tue, 16 Dec 2025 10:20:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3879B6B008C; Tue, 16 Dec 2025 10:20:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2407E6B0089
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 10:20:24 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B1064C06E1
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 15:20:23 +0000 (UTC)
X-FDA: 84225695526.14.2C2A3D2
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf21.hostedemail.com (Postfix) with ESMTP id E720A1C0003
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 15:20:21 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=H6qOfrSU;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of alexdeucher@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=alexdeucher@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765898422; a=rsa-sha256;
	cv=none;
	b=DSzc5dgtTyH/TvLc8vthmoigkalaTDaldaRdXb6UTUhZ3qUNp18IMv2inscMQMv+H2S77A
	3bYI8MGieOkT98kong5AYo2PmPCVu73EKNc3JWGGIcpVgRqpzuYa5uT7yJMfnni6BHbUAn
	tNMxt1pp0RwGxuOM/G294XcmcDViR3I=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=H6qOfrSU;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of alexdeucher@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=alexdeucher@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765898422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Um9j1NvhAvuOmXHqodLfor6UadH2pWBjGMeLJlrrYrA=;
	b=j8b6ZQ1JwE13n5x+5fH0wO/JUySdgIvqE0eZmVpMPG31sPJtf7zUtk4mPCk5d8ycs4uK7m
	hX0gEYt8zRRKEcHSusZ+qtb9hNk9iU9JyFyrRP69vcBe3yzPotmh3ERK4eZdZBu/Za+UI4
	qhJpoQ/uXVvnD29NjikuhoDfYBne8tA=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2a110548f10so4216265ad.1
        for <linux-mm@kvack.org>; Tue, 16 Dec 2025 07:20:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765898421; x=1766503221; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Um9j1NvhAvuOmXHqodLfor6UadH2pWBjGMeLJlrrYrA=;
        b=H6qOfrSUTlGgfAabwzWurHzWUaSKTN6oHys+JTFZFEAtkKnPuyijO/Tf3ObfMOM+pm
         D5R3ymqbTF/PbEcScZcyqaOxeCfcpqUn+lL2j0EiAqLWDAChnpR1Bot4sggZH2U2y6rm
         c13BmPahV0OVUGlqwMpRCN7wZQsGlLkSol2qPEsWKbs5tZ8yP4k8uahNDxyuEkB9WIxa
         oGUIx8U4VsWvEhc54TKdGhlp4XGqtbt6rRx9nBMfW92qKKk5gFc6Zi1azyLNs6kqg2ZS
         BWDZtB1rKZ+OKkyKZBVsrKI3Ef7ZpnbsOrYloXhB5xSxafA3sYISMKmOXop/8nMDO08U
         8Ujg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765898421; x=1766503221;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Um9j1NvhAvuOmXHqodLfor6UadH2pWBjGMeLJlrrYrA=;
        b=py5dD0Pqh4gHjW8KvjgYoibasoIB59EAVyxCohsrRXRxE2yHFkan4wk+1t/J3DgOjP
         dpnHl6jndboxSyN6v1IcbBnnTyASRYhf29COdJe1Et4Bhp5l+aIBRGPO38BZowEGXsJC
         vxNYIriVUCoP/kSCpRVaoG2ldNziSyOnvMsjr0AQROxKyrlWLmtU9Ujf/lF2EZBkTvKs
         PacLP6aW10rsRi5utveu5KfHi4RJc+aHPy+Y59kwSuq99h2j4aLr5xJiQERu6QJKk0mC
         tKRk9MCSCDsH5iYdAhTGb/jqNC7i1qv5sJZCLB3Zi3cXHtMZYpRlRyH9Ul+of5jpqJpn
         Ky8A==
X-Forwarded-Encrypted: i=1; AJvYcCV2hLcOzJJt/LzwKVJ2YtvrzEWvDkj+dA4US+VsK0CnvEaMc3IKI0G8L26F8kzy3EtIOsWs0kNVGw==@kvack.org
X-Gm-Message-State: AOJu0Yydft2K7y5lJ3O5aMnzTzbw1GDGovDpeSskqzpZUvQHJz/PSI2i
	Njswy2POg4iSPcXBGDqSLtf5pMWlKpSmjYfynBEeCebER3p0om3B2V6p6QGaxG4thN+bLPDfmXS
	eMo9F90r1563ZeBEZORX2AU7yn9L0r3E=
X-Gm-Gg: AY/fxX7lxiiXesDZcPPQ7pxrHbvoOl+7iCvlq2D9mEu9IyUYxt5xSRkslabulAPJ/+A
	2lB+Td7udcZDuI2lW4JiINCVfklAIr9Rp8/hPyEvaADbE2lh74kgAfua0YD7RnqpftEbegh2nY2
	FVemdKC92fw7h1WuuCqsFoLs9izFhhEisJ03MutC+wTiSqmxgbV+RmgTd9lrpZwH5W8W8EeuGeO
	riBSRNS7LYGieoQ2a0pzooDRRJOK4EA8wvO0LNdmT6tUg5L3V4l2DIaAcMnqNWsE7IyKcz7ePFC
	7mpc9kw=
X-Google-Smtp-Source: AGHT+IGYJpLwVd3WmfTCVN6vD/x/9T3gUFCIaNjQX2AnDfzywCiHaDROcEgCyN90fYOeDZvtNwbDXrs4JcvDTNG1WwM=
X-Received: by 2002:a05:7022:3a0d:b0:11e:3e9:3ea4 with SMTP id
 a92af1059eb24-11f34c52cc5mr5906109c88.6.1765898419103; Tue, 16 Dec 2025
 07:20:19 -0800 (PST)
MIME-Version: 1.0
References: <20251215113903.46555-1-bagasdotme@gmail.com> <20251215113903.46555-11-bagasdotme@gmail.com>
In-Reply-To: <20251215113903.46555-11-bagasdotme@gmail.com>
From: Alex Deucher <alexdeucher@gmail.com>
Date: Tue, 16 Dec 2025 10:20:06 -0500
X-Gm-Features: AQt7F2ra4W4DJMCA0k4t80_q2saRqZRxc2HY97wTRTVoyOkAEkAv1EtqbtLiuMo
Message-ID: <CADnq5_P04522xETHty9hn5JO=mNbKSg3Pa68=u8cZ+JgNLt1Jg@mail.gmail.com>
Subject: Re: [PATCH 10/14] drm/amdgpu: Describe @AMD_IP_BLOCK_TYPE_RAS in
 amd_ip_block_type enum
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
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
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
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E720A1C0003
X-Stat-Signature: xzwj7c3csnzmb56acqypyhb5hautt3m9
X-Rspam-User: 
X-HE-Tag: 1765898421-185601
X-HE-Meta: U2FsdGVkX198MYS+j0MBJmPQ6jMJkK4mqM+wsiFW+sGlLFBEUqR8wtdlxGYkbCWLTY4ahXPxuj6msGYXlWpgJKvJck6epEOpNvExvPyCTN1sU/+snpnNoskc04jh92LRM3mrb5PYzaLkAy6MlO1udbpnHOhQlU5iYWrU6XU0tW1ttIKK4JUkEgnbB1a1bNYOREtPSMVOwCUGCH7VWB0aqSf6T6rJK9ha4KM2+Z/J3DQMjJRyAkeQTACYGF2+k+PkCONI3d8TyaZeAPzcWBNieij8Zj7X8/WV7QnnW/nXSclB0IFdzc4bWQGh/iTjNYDzmjGsgwNEyOvNO+K3MZ0k0im+5HEvBcG+frpVLnYTKlup3kf9J9UXwXBItiqlrL9o2GKghsUfxHzUvG5YZTNwWuE8Mq+ap+Hb2n3ihbfyVsItdIroNQhHKLXG6cnj2d58N4/9WAjkTGixphRMdjMV2dW2ljkfm43ouUuLBvu8/uudYKv/ASXqNJapp7oXQ6/mxJnSwvt/+Df5KMHiQXpZEKddr07kML0HhYvFiWSztUuXhOmWakJJc13huylZJBvJDmbPa6/BgvYk6J6vLHolkM1rLttGPPEPY1szO+kX0dr0Fp3ocGoGdeVCzpAQePdC7PGqVTuJ1zkAXjAC0w6hTN4PCnynYBwtom1CDqa3TCC2DH5nCXJ032W5SkmsIDUiM2TntNEoeBYMeDRSptFLMp7QoeDJs7/kmFGaKSGJyR8PnimG101k0YVB3174H1vm/iJ0pI4BtJsUZ40jyetFWYXib6R9P3AUOim+P0tWRSVsvdliJxiVroKQtAFcdtwkxXTJxmQ12EKvgqWta2VTE+lTZEfv9CGe4wM2vIOyjb/1ebSqg/9w6Vgif568+hRabdTSCycoZnCYaE697euc9RKTOjgHLjTUkndruRpUbKnLVoqa6JvsTd8S49FxLdWctq3ZZttuugVTsOG6HyU
 M2SOndCr
 HHtpAMbuXygWeuEhLts2r1Yti+A0PKGBBHATpYdNSvtCcTXVllFdZAXmMznsmOkI07I01
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 15, 2025 at 6:48=E2=80=AFAM Bagas Sanjaya <bagasdotme@gmail.com=
> wrote:
>
> Sphinx reports kernel-doc warning:
>
> WARNING: ./drivers/gpu/drm/amd/include/amd_shared.h:113 Enum value 'AMD_I=
P_BLOCK_TYPE_RAS' not described in enum 'amd_ip_block_type'
>
> Describe the value to fix it.
>
> Fixes: 7169e706c82d7b ("drm/amdgpu: Add ras module ip block to amdgpu dis=
covery")
> Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
> ---
>  drivers/gpu/drm/amd/include/amd_shared.h | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/gpu/drm/amd/include/amd_shared.h b/drivers/gpu/drm/a=
md/include/amd_shared.h
> index 17945094a13834..d8ed3799649172 100644
> --- a/drivers/gpu/drm/amd/include/amd_shared.h
> +++ b/drivers/gpu/drm/amd/include/amd_shared.h
> @@ -89,6 +89,7 @@ enum amd_apu_flags {
>  * @AMD_IP_BLOCK_TYPE_VPE: Video Processing Engine
>  * @AMD_IP_BLOCK_TYPE_UMSCH_MM: User Mode Scheduler for Multimedia
>  * @AMD_IP_BLOCK_TYPE_ISP: Image Signal Processor
> +* @AMD_IP_BLOCK_TYPE_RAS: RAS

Reliability, Availability, Serviceability.  I've fixed this up locally
and applied the patch.

Thanks,

Alex

>  * @AMD_IP_BLOCK_TYPE_NUM: Total number of IP block types
>  */
>  enum amd_ip_block_type {
> --
> An old man doll... just what I always wanted! - Clara
>

