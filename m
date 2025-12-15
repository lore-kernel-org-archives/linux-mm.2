Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73C54D41D74
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 12:25:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD7376B0006; Mon, 15 Dec 2025 07:25:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C87F56B0007; Mon, 15 Dec 2025 07:25:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B28A56B0008; Mon, 15 Dec 2025 07:25:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A0DFA6B0006
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 07:25:21 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 648F91601A5
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 12:25:21 +0000 (UTC)
X-FDA: 84221625642.18.B1A9E05
Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [80.241.56.171])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5AE9618000E
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 12:25:19 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=MFNtC9o7;
	dmarc=pass (policy=reject) header.from=mailbox.org;
	spf=pass (imf06.hostedemail.com: domain of phasta@mailbox.org designates 80.241.56.171 as permitted sender) smtp.mailfrom=phasta@mailbox.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765801519; a=rsa-sha256;
	cv=none;
	b=e7s1e6A2kcbO00YNtL2TgVBcAMpZ1xztM2ibKU24UNh5Ujye5aHeglS7ROJYJbOB0TLeOK
	ikoBImaNnsWArZHgKVxGxNTLt59cLkPZTo3wAvLdsXGx3GJRwrZurL+m2iv6CIH0DEQkOZ
	dfX88EdWDMIbgSk+0HoS7LsNvkljDDo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=MFNtC9o7;
	dmarc=pass (policy=reject) header.from=mailbox.org;
	spf=pass (imf06.hostedemail.com: domain of phasta@mailbox.org designates 80.241.56.171 as permitted sender) smtp.mailfrom=phasta@mailbox.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765801519;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gJOFMp1/K+qQ0MSqjWn/CbbRaLJJuaP23xTo6CU3FMU=;
	b=NRO/tnDLlQ0U8r0CbAXQH8jYH7ABUxvc6NHlvGYPG5Q+ckEJleQupGf9ttd1bsQF22WTDY
	aTZumw7tlt7Wd7RsmmKWGq79qelGCw+IKL63UtKAatI+8YYACChGzV6vnhl6sRZbgq9FGA
	u8EKCz4O4BxZWxZNeb9atAAT4aXll80=
Received: from smtp2.mailbox.org (smtp2.mailbox.org [10.196.197.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4dVK5Q3lJFz9scD;
	Mon, 15 Dec 2025 13:25:14 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1765801514; h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gJOFMp1/K+qQ0MSqjWn/CbbRaLJJuaP23xTo6CU3FMU=;
	b=MFNtC9o7GDr77G4gP5pdlWOgQeeiKPzkDClg8L2DPLsenZjXbBPFNYiW+f7Yt3dIHPmQyP
	OJMvPnvOPIvbcMj8jkup2nPMtdqY9haLsfcz/IxOV2J03K4sDF356sDyQ23TsGQ07TViaD
	FhWOVrJMTFcJ9CeKh2BEanhmBKLu/puWhJkeqyz5IF7MKc0wDX6+LpZo37kPzrx07UbVHu
	/SrGIEw9Yb9k6R4DHidfnQwttDmp8t0gODXRNwKwn1DjYqW3hsQZd1gJ97ZgepaPr9lGGF
	Kb4b3/HsX4GoqvHqXz/IOEsaMsqC0j4WmS+EX3sDV8DayQFJEqKPzO/PssjTDQ==
Message-ID: <1f0fd860bf3466b9967d5a99ecd49eb93e0f7a19.camel@mailbox.org>
Subject: Re: [PATCH 12/14] drm/scheduler: Describe @result in
 drm_sched_job_done()
From: Philipp Stanner <phasta@mailbox.org>
Reply-To: phasta@kernel.org
To: Bagas Sanjaya <bagasdotme@gmail.com>, Linux Kernel Mailing List
 <linux-kernel@vger.kernel.org>, Linux AMDGPU
 <amd-gfx@lists.freedesktop.org>,  Linux DRI Development
 <dri-devel@lists.freedesktop.org>, Linux Filesystems Development
 <linux-fsdevel@vger.kernel.org>,  Linux Media
 <linux-media@vger.kernel.org>, linaro-mm-sig@lists.linaro.org,
 kasan-dev@googlegroups.com,  Linux Virtualization
 <virtualization@lists.linux.dev>, Linux Memory Management List
 <linux-mm@kvack.org>, Linux Network Bridge <bridge@lists.linux.dev>, Linux
 Networking <netdev@vger.kernel.org>
Cc: Harry Wentland <harry.wentland@amd.com>, Leo Li <sunpeng.li@amd.com>, 
 Rodrigo Siqueira <siqueira@igalia.com>, Alex Deucher
 <alexander.deucher@amd.com>, Christian =?ISO-8859-1?Q?K=F6nig?=
 <christian.koenig@amd.com>, David Airlie <airlied@gmail.com>, Simona Vetter
 <simona@ffwll.ch>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann
 <tzimmermann@suse.de>, Matthew Brost <matthew.brost@intel.com>, Danilo
 Krummrich <dakr@kernel.org>, Philipp Stanner <phasta@kernel.org>, Alexander
 Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan
 Kara <jack@suse.cz>, Sumit Semwal <sumit.semwal@linaro.org>,  Alexander
 Potapenko <glider@google.com>, Marco Elver <elver@google.com>, Dmitry
 Vyukov <dvyukov@google.com>, "Michael S. Tsirkin" <mst@redhat.com>, Jason
 Wang <jasowang@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Eugenio
 =?ISO-8859-1?Q?P=E9rez?= <eperezma@redhat.com>, Andrew Morton
 <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, Nikolay
 Aleksandrov <razor@blackwall.org>, Ido Schimmel <idosch@nvidia.com>, "David
 S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub
 Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman
 <horms@kernel.org>, Taimur Hassan <Syed.Hassan@amd.com>, Wayne Lin
 <Wayne.Lin@amd.com>, Alex Hung <alex.hung@amd.com>, Aurabindo Pillai
 <aurabindo.pillai@amd.com>, Dillon Varone <Dillon.Varone@amd.com>, George
 Shen <george.shen@amd.com>, Aric Cyr <aric.cyr@amd.com>, Cruise Hung
 <Cruise.Hung@amd.com>, Mario Limonciello <mario.limonciello@amd.com>, Sunil
 Khatri <sunil.khatri@amd.com>, Dominik Kaszewski
 <dominik.kaszewski@amd.com>, David Hildenbrand <david@kernel.org>, Peter
 Zijlstra <peterz@infradead.org>, Lorenzo Stoakes
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
Date: Mon, 15 Dec 2025 13:24:46 +0100
In-Reply-To: <20251215113903.46555-13-bagasdotme@gmail.com>
References: <20251215113903.46555-1-bagasdotme@gmail.com>
	 <20251215113903.46555-13-bagasdotme@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MBO-RS-META: q9aiurnjorghwoz79fww7b6wqkkf5zeq
X-MBO-RS-ID: ca016de3dd37ac937be
X-Rspamd-Queue-Id: 5AE9618000E
X-Rspamd-Server: rspam03
X-Stat-Signature: ss9cqs6owf6bd3ijriprq4y49d4ugsrm
X-Rspam-User: 
X-HE-Tag: 1765801519-452065
X-HE-Meta: U2FsdGVkX18o9v1TKenRH06IqU1YdclFWgVnDIO4UUJaoVusFubaKcE8jgRxeVn/V7/ovmmZsbwjDRl8Fj7YzLFy8o7YOGGjbQ9+Sm/8pVchMZuBTJ6QYh4xpjc24WyQ33HCasQ0crSrEaN/S2VsO7H27JhUGT6o6+5NUXjFziOPHRfkFsv/fHMws3k5pGo96lp5OB6SHfrcYsEHT/49/1vztzpf2lfx0NujcXe2yLsor6ur53T7tV4UrUsRfbZrEYm8ewC+2dMq+l7chfVe5yBapzZq5m15WYiy8FXd0UgvgGCQ4wIlAlFLQFb7dj3Z4QTvjjUjJVoE2qZdQmqcXAnM46dEtikfyc2CznRqk2SmgIkfTifTav2bfRj9swLVhnLLRDmATN0lZwO4s6lJNp5aabYqDIpRfgURdX+DUSD6QgEbaM7icajAlItj2zImYQ+j1mX9mDEehR3OTbM5LHl6yLSFwfANknV4hr5xtCMRwYes7XNh0+OtjIJEF0uyyVqNMN0AdFcw7vF+beX5e/vJNEqwzIWSeOCB2B6oIi4mBsV12jgajx8+4SI0xeX/yaT12A3Z2oVsClfhUDrd4Fw0fIi4Gh1ecUu/+cIY5/1yvcP32ffUoD2xZIwP2uquQmBKKpA+vaOlhPKWufHNJXjx7bBjNP4insO4ZRPyecNwPaCPVtJIoCacdauRHQXWTV2fS4tJymbyk8CFn4BXe+fEgg6L/edUQBa1+7xdBHWY7KxApWKyxDM1uFAD2i22wPeqhyPUTBgZkPm0RgNRrxYw6uJOuL1NPgvgaoL42XNke41l1pxLhroojtnhy3aFKnAkl6MrEpZWJe41S1YYhPeBE/QfsVzFPUJ+xNhqPgt9raH3C1d1PowvvHiBtCMotaW6G2rGNk+g2+pDpcbD6GmNDmQdrUvK3N9Fpa/geGMJyvChw7iBpVMhkyUqCNscqFD2um8NnEGbypekpS+
 7sh78Qkp
 pXfKLoX0rlMuylE+DSuT/BKZc9vJLjGCSJQOwSx3/don8SnWcQBauZvzxPBmFhPYX1mXdY2UMjVWN8Mh4bFhukIlsFJypbrwXGy4IQNJensvAIJNEhNabgez2x9+3zhVsWLzkmFJWJJL+o3nfghMpQcuDWlfOIgbyS7DDVaQ571M7lC2DpLJDVkbrKsnTmoXIpBRHyzKzX/9qOcCwAZNS/EuaY8u24mCQuhIoapKzCzkhQC3az2zgO6APV0ynHX4f0LXHbf6cUsOd8Ue4Rt22ImFlSIL3Oh2KKi9cbujzwTo4qz7cWh4QXm/Q4iHEGNZxi+MajhCg2RfV2EFZiEUc9M6x35PPMuiunvKgN2a8tBlNLRIF/dS3YbAxIxlPUS3gu+YDqWGcelroXqB5yY/Y9twtCKGTdLQX/0G9i80QEOdUxjjJ3z2rjbLSe1E6VsosRBqhIrqXDaZTvT30Fj6iHH4PB8yc9dI/SESAp8XzYkmMNELOZxImmmtWiw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

nit about commit title:
We use "drm/sched:" as prefix nowadays

On Mon, 2025-12-15 at 18:39 +0700, Bagas Sanjaya wrote:
> Sphinx reports kernel-doc warning:
>=20
> WARNING: ./drivers/gpu/drm/scheduler/sched_main.c:367 function parameter =
'result' not described in 'drm_sched_job_done'
>=20
> Describe @result parameter to fix it
>=20

Thx for fixing this!

> .
>=20
> Fixes: 539f9ee4b52a8b ("drm/scheduler: properly forward fence errors")
> Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
> ---
> =C2=A0drivers/gpu/drm/scheduler/sched_main.c | 1 +
> =C2=A01 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/gpu/drm/scheduler/sched_main.c b/drivers/gpu/drm/sch=
eduler/sched_main.c
> index 1d4f1b822e7b76..4f844087fd48eb 100644
> --- a/drivers/gpu/drm/scheduler/sched_main.c
> +++ b/drivers/gpu/drm/scheduler/sched_main.c
> @@ -361,6 +361,7 @@ static void drm_sched_run_free_queue(struct drm_gpu_s=
cheduler *sched)
> =C2=A0/**
> =C2=A0 * drm_sched_job_done - complete a job
> =C2=A0 * @s_job: pointer to the job which is done
> + * @result: job result

"error code for the job's finished-fence" would be a bit better and
more verbose.

With that:

Reviewed-by: Philipp Stanner <phasta@kernel.org>

> =C2=A0 *
> =C2=A0 * Finish the job's fence and resubmit the work items.
> =C2=A0 */


