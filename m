Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3F5DD609AB
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 15:21:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A3806B0089; Tue, 16 Dec 2025 10:21:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 163976B008A; Tue, 16 Dec 2025 10:21:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 025B46B008C; Tue, 16 Dec 2025 10:21:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E24486B0089
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 10:21:33 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9AFF41A05D2
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 15:21:33 +0000 (UTC)
X-FDA: 84225698466.25.EACBCDB
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf23.hostedemail.com (Postfix) with ESMTP id A6EE8140013
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 15:21:31 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jg4kU1RQ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of alexdeucher@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=alexdeucher@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765898491; a=rsa-sha256;
	cv=none;
	b=4x//1d3KKVuau9yTSd1/l3yFy/XZ/EeEJ9yhpqxt/9h64GHjuyOpl/39HuWoyWaNGogG8m
	nJ/Pp/0+PBiLZOJPKYWP2lZO0gnA0kAwm1Rue/XZJI6bJkt2zTiL3VNWEi+AlDo78KnhZY
	8MghRFmovLvNbvc8qPDRZDPnW1SKCJc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jg4kU1RQ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of alexdeucher@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=alexdeucher@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765898491;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G6A3FJy1wSkXfE42mqpxDchsxNCyuEhZg+omH3hGmm4=;
	b=6Qc6OdeWL6tFul8ppNWLzUR62uSKYptIdFimrZz5YpTJTAgMjFnNm0bkfOYi92xFS1zLQI
	EUDEPdw16G3ucbJSiqaJzfXYtRbi8ie01szJQo1YTn15LnVERKPR6uuip8ycVA/pLotMyD
	bm36GtAHvxDYXj4tfaK+I3el0JaOvuo=
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-7ba92341f07so335919b3a.1
        for <linux-mm@kvack.org>; Tue, 16 Dec 2025 07:21:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765898490; x=1766503290; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G6A3FJy1wSkXfE42mqpxDchsxNCyuEhZg+omH3hGmm4=;
        b=jg4kU1RQ63k24QlIWGgzrPoQlB+1SJbY/0pIBeAWe0mkLMbdROUJhs0Dn7GdOr/l/K
         mvXeyv3di96qdyPd7U1kkFfgaq5OdKWM9oUjKTdDhZE+l/3bff16E75UR3N6yK/ICYSm
         rSVTrad9PbjhAnTpgee51/l1mQNmaFizkCn30mhFgpFoMoDWX6ED9e608zaf+Dj4Tkbr
         c418LbLfNpNrJTkiL5Bdy6GmRik4nJmQrrGvG9qSfX6pJ+93Wi8TAoqD7Xho6WzQtZ/A
         Q3lp+3Wo4zoUObPEvbpmQngUbFv7PLfdCYhhQX1GJqVSThlQYyVxJg1K2ra8qzBirCws
         wv4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765898490; x=1766503290;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=G6A3FJy1wSkXfE42mqpxDchsxNCyuEhZg+omH3hGmm4=;
        b=YD0pHZg8MBtzOiGWXqg7rCb/59PrJ3hMRF2cpCKd9X8RSjVvKr9Rv18fHWe0feH9t0
         EUt/wpvaywkdhUxDuDQpT8sq/n0pULEwUSZHxpHmo4Lt5ACEOYitJ3b6VbIoH/aQiyhz
         90lM+LPIOg1oWznOpEbkJbqKxeaBiQ69oyeV4Y44m/IYM++ATRRRpUNbMIJ49Tf7niq/
         MlmU/Jc4Lkt0DjeiUhQ6qDvIPWTVOIoMJL3FsXyvR/XIDkLGdr1aN1IJwzrrKlUa/9iT
         Ok/dsMtHS+UxbuF49fPOXyXQlQh4zC7Z04UYrsSZ/9vMwEz5qaFk8tsuVjKitsv7qbFa
         Dwwg==
X-Forwarded-Encrypted: i=1; AJvYcCUBxNKnZEGK1t4QNjztKavK6cvz2KYrB6V4RUHmndOrKfBVIF1Qi68p8vBePUKKQ4V4tmhRUlombA==@kvack.org
X-Gm-Message-State: AOJu0YwXok9OduEaoxDMDt6j765U4SrPL4AwpksP5GTylUg0dpUwcCPL
	Rel2Ks4ro0P5/QiHRlBaWYndlYy8NTT2ISXS6tHJ2yN8hdY3bw4qT/zh4twxVZ9gaSnxmM42+QW
	g0LrvedmB06mWxpl9/nsTu7idlFKxWsU=
X-Gm-Gg: AY/fxX4suDfvwCmWH4cUjmd1HyJz9DP/1hrdHdqGSppepUPVockR7OzpRcQ3sQPY0ag
	GOuZczFZBd8OsjKm5n28fsBDzhuQeqUc39QqWuvrhHe8Bg8oZc2IIfhiE7ETMewAmQracT1z95y
	pjLxV+dle4ahTAMkxPYIbNIkbtgNEvFbv0wiYi/TZbrbX+1OqbAvs4udx2ZcDGIbZ9Dlob7f9oR
	GZXHIJTXUPQQzIMpoR0bhKZkDrDnwTyIOiILQUBnBhyU8kw3G34PumuRP1bJhHCCAEyYT8h
X-Google-Smtp-Source: AGHT+IFq0qaYbGK7y/3ERMab5mfBMJZm2RVpJeQ2PDWWvVrS9uWYHKl8nJo9NGLv/zMgaMY45LKm9slZF+vnfJuCU/o=
X-Received: by 2002:a05:7022:b98:b0:11e:3e9:3e89 with SMTP id
 a92af1059eb24-11f34c5d690mr6648024c88.7.1765898489968; Tue, 16 Dec 2025
 07:21:29 -0800 (PST)
MIME-Version: 1.0
References: <20251215113903.46555-1-bagasdotme@gmail.com> <20251215113903.46555-10-bagasdotme@gmail.com>
In-Reply-To: <20251215113903.46555-10-bagasdotme@gmail.com>
From: Alex Deucher <alexdeucher@gmail.com>
Date: Tue, 16 Dec 2025 10:21:18 -0500
X-Gm-Features: AQt7F2rE8ID9d6NCh1LRY2rQdA6w_Kl1ZhHVictIiyXPuu3Pg_xadHkkj9RiiLU
Message-ID: <CADnq5_NsELxchDeka2CX1283p9mn4+P9_V9Mi+SNiWwM_sQepw@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] [PATCH 09/14] drm/amd/display: Don't use
 kernel-doc comment in dc_register_software_state struct
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
	Simona Vetter <simona@ffwll.ch>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
	Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
	Matthew Brost <matthew.brost@intel.com>, Danilo Krummrich <dakr@kernel.org>, 
	Philipp Stanner <phasta@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
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
X-Rspam-User: 
X-Rspamd-Queue-Id: A6EE8140013
X-Rspamd-Server: rspam10
X-Stat-Signature: puc4o5gt6d1a75pi77e7rq7fmn4w3q43
X-HE-Tag: 1765898491-685814
X-HE-Meta: U2FsdGVkX19FGvYSl8vKT0GvR0rD5rPVgxVbeJsbGoXhLj+puyol1DKk7ii242ueCSi22KiA1vhNYABLnYovLJmj2blGp071r5jWATFnLFdn0JjcV5NSex9JfGHwhNvo37eL82bCxL0th4202HQVtef1SHJyeYGRWaNLcXN0FhCTNMDjDLajxcCCvRbGdT+kzO+IyDqWQcl3d+pJQa5YWyYsvAwkGZQ6bP3jaC8mAqfBbUsRuRGpVWb7yMEjKimRaIYW4pgy9haDD/GSZQc4RqTBBjUF++m6QUIlT2Q3KpnFwg6AOYM7cuu+b1fU/VSEnp4wyqXUApMEGgZ0s5/nzSGt6ufVM3HA8TkXd/N4/Cbl8cJzvf0l/Z0SD60VDkPKmVUM3L0yGdvi45k5otDAx/h5ka5WeoKXXSJsSdnKgkNMjQqR9OpM8mWenAxovrGHpsWidnq6iVLYdXMACSl5odCBxZy31f0+Dum8wF+aGSNF2D/gJ1wz41MZ1poSC8fjxG7NHeoATIk4tPkvH27Abbyo3bYh0vhp20zW0yAFyyVxb1SmHk0Sm/pgCDJgaAk33H1jFHdl8YKOqVvxIVNceA5hBYXPEbNgszX2p9RG53pX811qIBBxU8XVXkN83KPNwd9EMu2ZsVgsyjJqpEf8RrhtvvbBqFRVqrFNkx1qlIagn2CBOntKzSP+T1ZWaqBHbFSQiIe+elZLVh6K/Xj9A1qCQqVIcsruvG6NG0uVsSt2p7tfEQB1rB0WEQ8ofjIKGUsA5PsvWk9/Cggaj4p7DYryLOjOUcycAnnyWrxkcYOTaUOuqVVKUm0+rabggiVQMFLh5PburO5lYm5WZ6coUgdXYHjhNZcfV805zRPH4dWknDb7DTZGIlNKGKhf+VSN8Tb7f+CfbrwSusBEkVn1ic4+h4jsYHHpRpBXJvL9owwrhWBcP0UwqKRiGbb2JkUJ73Sr4iLPFGhgnvZK1Br
 jT4BoMNx
 gpTl1nf+JD//fIk2yAx+8dhA8+zduoiVKWoKlTyHoPWCf2Qr+PxWwJlOxgck9oW2j4A3hhHfmGdwJQxl3+xstnKtDeJZ3bawl6rdfh3hHNO6uqKyMKZg3QwEsh5x+ar+eunbqaXIG3RdYyXIaUJsFClgLB4ju41/LDjTAoPCq/y+J2MBafeh/xS22P2XJ9P5Srfd8FthKtgJjFDUj5Pqc3LBdBub1imFa7s7rwdLZYKDXBzm6PvTzBXIDduqImsVstYVaCj3aclEUJYibt0W5Kp7YiCOD8dXXbU9gslHlpfEBrmgGfn7DKYkZCy+tIa6QPZ4tl/khayusaSjKpGtlLzZl2sEE5DbgnaPdCrRe+KnYghm9ccNh1R4WcgIsZk/zcBrbmq4ICbNmrvvQe1ih+Rq+JBn0pAzIxyaGL/2BHnrPabsWfNkWtYvfWIs85fs5SjyupwiEvzz4AFnydpnJlHD8tZaUlh21ALyImIgQ0Z1wACo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Applied.  Thanks!

On Mon, Dec 15, 2025 at 6:41=E2=80=AFAM Bagas Sanjaya <bagasdotme@gmail.com=
> wrote:
>
> Sphinx reports kernel-doc warning:
>
> WARNING: ./drivers/gpu/drm/amd/display/dc/dc.h:2796 This comment starts w=
ith '/**', but isn't a kernel-doc comment. Refer to Documentation/doc-guide=
/kernel-doc.rst
>  * Software state variables used to program register fields across the di=
splay pipeline
>
> Don't use kernel-doc comment syntax to fix it.
>
> Fixes: b0ff344fe70cd2 ("drm/amd/display: Add interface to capture expecte=
d HW state from SW state")
> Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
> ---
>  drivers/gpu/drm/amd/display/dc/dc.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/amd/display/dc/dc.h b/drivers/gpu/drm/amd/di=
splay/dc/dc.h
> index 29edfa51ea2cc0..0a9758a042586f 100644
> --- a/drivers/gpu/drm/amd/display/dc/dc.h
> +++ b/drivers/gpu/drm/amd/display/dc/dc.h
> @@ -2793,7 +2793,7 @@ void dc_get_underflow_debug_data_for_otg(struct dc =
*dc, int primary_otg_inst, st
>
>  void dc_get_power_feature_status(struct dc *dc, int primary_otg_inst, st=
ruct power_features *out_data);
>
> -/**
> +/*
>   * Software state variables used to program register fields across the d=
isplay pipeline
>   */
>  struct dc_register_software_state {
> --
> An old man doll... just what I always wanted! - Clara
>
> _______________________________________________
> Linaro-mm-sig mailing list -- linaro-mm-sig@lists.linaro.org
> To unsubscribe send an email to linaro-mm-sig-leave@lists.linaro.org

