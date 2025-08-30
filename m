Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F8EDCA0FFD
	for <linux-mm@archiver.kernel.org>; Sat, 30 Aug 2025 20:46:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 561BE6B0005; Sat, 30 Aug 2025 16:46:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 511846B0006; Sat, 30 Aug 2025 16:46:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FF706B0008; Sat, 30 Aug 2025 16:46:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2FCD56B0005
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 16:46:48 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 99A0481F28
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 20:46:47 +0000 (UTC)
X-FDA: 83834607654.19.8B30989
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id CF50E40009
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 20:46:45 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i7heKHiF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of mchehab+huawei@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mchehab+huawei@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756586806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sERoEhOT3TgQGeAbgiCm8VB8EH4ve3pj8WEJe0BUAXc=;
	b=3XgwvnCYoImN5k8kyA/gNtd3BNvNxDFuqi5x/8pc6tfmBRQtYd5xuktkcy8vddAr+3gI48
	wNSVWemWBmTgj24OFnlQWSAJGLe/J+39ZlQKrFpN52DhMuC5fN1nM8lpiFUxW/skBHebSY
	JsljbKwbHYoRLEnksas+iZj0GZkc3Qs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i7heKHiF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of mchehab+huawei@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mchehab+huawei@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756586806; a=rsa-sha256;
	cv=none;
	b=CYEpAZyDdnL/h8VRYxpqEFpsj/ONnP2BmiIt/q2qKChNXCXnwcgUb6plFEHcr4i+WJiV0b
	ybSPex1VvATOh7r3AcFahB76cHykM+qB3dXoWKW9A6JCPfTwahXpaf8DyDFeobSYrbSk9f
	QuINRiloKYBiK6+QOteRO37LamKSm+Q=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8645643FD7;
	Sat, 30 Aug 2025 20:46:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF130C4CEEB;
	Sat, 30 Aug 2025 20:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756586804;
	bh=N1RyWuUPncwemkQz+wtBxmmLRK1pbPwPhqaSXQEgACo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=i7heKHiF1WEcWegbUMD1XKbmetMnNnCnljRU/sfGxpB5c3sZchsdHRdnTVLky717F
	 dDeCNXpev8o9LRk1S9eXnS8o8kWvMacaFziEO6OdWtswKvTxZQ5pU4eCd2WUx5BQCO
	 14bLFP5QVji02AMa5CJyqW/en6PTbHSnZ78vGj75ZZT/RVMFCiYHRoYXRol8qlqKgn
	 3lrkJ1IYbZBkwoMZse44FP62uqEzr0WjQEZOzoSJLrIrlje9NRgPYVERWMHuVkMn2k
	 2QurVWFt7IIr5AR3ahUSN1uV7FUBrHkmiXJe15aj9LzSrsbpHevBdir8lYlUv2SDdP
	 83zxdoGwMwcyQ==
Date: Sat, 30 Aug 2025 22:46:22 +0200
From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux
 Documentation <linux-doc@vger.kernel.org>, Linux DAMON
 <damon@lists.linux.dev>, Linux Memory Management List <linux-mm@kvack.org>,
 Linux Power Management <linux-pm@vger.kernel.org>, Linux Block Devices
 <linux-block@vger.kernel.org>, Linux BPF <bpf@vger.kernel.org>, Linux
 Kernel Workflows <workflows@vger.kernel.org>, Linux KASAN
 <kasan-dev@googlegroups.com>, Linux Devicetree
 <devicetree@vger.kernel.org>, Linux fsverity <fsverity@lists.linux.dev>,
 Linux MTD <linux-mtd@lists.infradead.org>, Linux DRI Development
 <dri-devel@lists.freedesktop.org>, Linux Kernel Build System
 <linux-lbuild@vger.kernel.org>, Linux Networking <netdev@vger.kernel.org>,
 Linux Sound <linux-sound@vger.kernel.org>, Thomas Gleixner
 <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, Peter Zijlstra
 <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@kernel.org>, Pawan Gupta
 <pawan.kumar.gupta@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>,
 SeongJae Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Huang Rui
 <ray.huang@amd.com>, "Gautham R. Shenoy" <gautham.shenoy@amd.com>, Mario
 Limonciello <mario.limonciello@amd.com>, Perry Yuan <perry.yuan@amd.com>,
 Jens Axboe <axboe@kernel.dk>, Alexei Starovoitov <ast@kernel.org>, Daniel
 Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>,
 Martin KaFai Lau <martin.lau@linux.dev>, Eduard Zingerman
 <eddyz87@gmail.com>, Song Liu <song@kernel.org>, Yonghong Song
 <yonghong.song@linux.dev>, John Fastabend <john.fastabend@gmail.com>, KP
 Singh <kpsingh@kernel.org>, Stanislav Fomichev <sdf@fomichev.me>, Hao Luo
 <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>, Dwaipayan Ray
 <dwaipayanray1@gmail.com>, Lukas Bulwahn <lukas.bulwahn@gmail.com>, Joe
 Perches <joe@perches.com>, Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Alexander Potapenko <glider@google.com>, Andrey Konovalov
 <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, Vincenzo
 Frascino <vincenzo.frascino@arm.com>, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley
 <conor+dt@kernel.org>, Eric Biggers <ebiggers@kernel.org>, tytso@mit.edu,
 Richard Weinberger <richard@nod.at>, Zhihao Cheng
 <chengzhihao1@huawei.com>, David Airlie <airlied@gmail.com>, Simona Vetter
 <simona@ffwll.ch>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann
 <tzimmermann@suse.de>, Nathan Chancellor <nathan@kernel.org>, Nicolas
 Schier <nicolas.schier@linux.dev>, Ingo Molnar <mingo@redhat.com>, Will
 Deacon <will@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, Waiman Long
 <longman@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
 <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, Shay Agroskin
 <shayagr@amazon.com>, Arthur Kiyanovski <akiyano@amazon.com>, David Arinzon
 <darinzon@amazon.com>, Saeed Bishara <saeedb@amazon.com>, Andrew Lunn
 <andrew@lunn.ch>, Liam Girdwood <lgirdwood@gmail.com>, Mark Brown
 <broonie@kernel.org>, Jaroslav Kysela <perex@perex.cz>, Takashi Iwai
 <tiwai@suse.com>, Alexandru Ciobotaru <alcioa@amazon.com>, The AWS Nitro
 Enclaves Team <aws-nitro-enclaves-devel@amazon.com>, Jesper Dangaard Brouer
 <hawk@kernel.org>, Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
 Steve French <stfrench@microsoft.com>, Meetakshi Setiya
 <msetiya@microsoft.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Martin K. Petersen" <martin.petersen@oracle.com>, Bart Van Assche
 <bvanassche@acm.org>, Thomas =?UTF-8?B?V2Vpw59zY2h1aA==?=
 <linux@weissschuh.net>, Masahiro Yamada <masahiroy@kernel.org>
Subject: Re: [PATCH 12/14] ASoC: doc: Internally link to Writing an ALSA
 Driver docs
Message-ID: <20250830224614.6a124f82@foz.lan>
In-Reply-To: <20250829075524.45635-13-bagasdotme@gmail.com>
References: <20250829075524.45635-1-bagasdotme@gmail.com>
	<20250829075524.45635-13-bagasdotme@gmail.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.49; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: CF50E40009
X-Stat-Signature: st9nn4p4y9yppz6gwprc984s3mzftdfp
X-Rspam-User: 
X-HE-Tag: 1756586805-683788
X-HE-Meta: U2FsdGVkX186Hz2CV5e3h/YF85NcCFc4U32jtFF4C/gd/p6d05bYEzwrBMBdgNAg0JS6eVarJ5CYdLhEDiyoQJVDpoV13mwP8iSzSZpYdWvqJdA7lpw6oQ8ZVSsyEy8g9bqtjNgG0jSqU5JZGvMFcJkUGBMwNQ2zCN/HYv4Iz4U2lnLgkTcBXqsev8MrS/Tf/nyIKYJqcahaUEQLb4hMpMyd77D1lT6OCH4rl97V4LC8eBrYbDjSqk3ikoZs7HQ0sC4BM5jzOmPnSVYilbz79OQNNpU/78Ewp4Z/wdae1iEL79sc2bBMdKmo3A/WZtsRgSucDUS3ThLrwQWNI6PuM0XZVo0gDN7Lk7oDuyI2naOntcj+3/jAiOL9VGojo2EsncGzqS6tSc4d7Hoxly6QRNQYXJdVPM0PBHu2+yZPwvUtnLqCEPWMiuTEvYNmfa3q9XjrS2Mo0hJlX5kFYi3ylfDYfDfAewumbULROTwi4vqRRULJa7yLYIgzRkkALJBD4OgWjsxb1cW7jL8YF4NQC3beKx+OUiTdb3wHMqkCYQrcO/di0m58d5AYTr0uG1ljMxlI/JWDoheop8gOQUmXVxjklZ1yc/aEsN7f3K3gnyjolvMiPj3Sev8tT17fo9En7RwJyaQQ8lkS4JQM4ppjNf4jaN7/DCsnzW9/sflPKYR45//9OAhVuf6/S0xo8d+aL4rGISKoehKYR0gAvwVtxmsi14OUvyXGDFF/eS+b6jmgka2GwKyYXpxn3EMQrPO4M9o9F1ovmWj8dKmGPGsis89b4u4nEKXjpnR2TBSrzkKZ8XsYDQwK29fgRUYzvdXVDrbTiKVInVL2J7FaVtULZaQnsps9GWaSmxT+i9L2dluiwDG06giwORCWQrB7KIaAedMPD9hRBB7ZHajAn3jD3IktF89OuIvC95TNIgYx+sTaJ2ik9/BAisoTeSie4ag76AvllmBODdYoNH5yfOr
 FUeRfP2z
 Lz/CvePk6v9GDrknp+ElTTgm/NMmrRt4ZIIW1hA714IqHpHNp8u8V1I+m4BsulW4XSYZVxuRF1rFHH9BvOdTE9z2J6tACbKcuZ6AjQy5InEzvA4ahHJRw/QyGhxiRrKJwKG0Z+PGMX1T9lPieH1/FIKRWmrn6MgzOwEYRfHuACyLFaPcbvSVaYe2mMtn9gzq7DHguJz41/f14dGm4F67O0yUSLd2xvQfqxtf5PnqbCAO3HOUe7G6CQ5D1lK6X4AXslejsGnHOjk5C8nqmWjzLq19wP+Obz/7ujIoUnbeipoquBVEDE3hDDhNT0o5BDVPtJdzz4gySK2C7K5nGn4Tc/tFlA+yZOFInEtUcEWZN82dOYInpcO21HmBcaEmaUQBISxB5cE0jjyUBHNg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Em Fri, 29 Aug 2025 14:55:22 +0700
Bagas Sanjaya <bagasdotme@gmail.com> escreveu:

> ASoC codec and platform driver docs contain reference to writing ALSA
> driver docs, as an external link. Use :doc: directive for the job
> instead.
> 
> Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
> ---
>  Documentation/sound/soc/codec.rst    | 4 ++--
>  Documentation/sound/soc/platform.rst | 4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/sound/soc/codec.rst b/Documentation/sound/soc/codec.rst
> index af973c4cac9309..b9d87a4f929b5d 100644
> --- a/Documentation/sound/soc/codec.rst
> +++ b/Documentation/sound/soc/codec.rst
> @@ -131,8 +131,8 @@ The codec driver also supports the following ALSA PCM operations:-
>  	int (*prepare)(struct snd_pcm_substream *);
>    };
>  
> -Please refer to the ALSA driver PCM documentation for details.
> -https://www.kernel.org/doc/html/latest/sound/kernel-api/writing-an-alsa-driver.html
> +Please refer to the :doc:`ALSA driver PCM documentation
> +<../kernel-api/writing-an-alsa-driver>` for details.
>  
>  
>  DAPM description
> diff --git a/Documentation/sound/soc/platform.rst b/Documentation/sound/soc/platform.rst
> index 7036630eaf016c..bd21d0a4dd9b0b 100644
> --- a/Documentation/sound/soc/platform.rst
> +++ b/Documentation/sound/soc/platform.rst
> @@ -45,8 +45,8 @@ snd_soc_component_driver:-
>  	...
>    };
>  
> -Please refer to the ALSA driver documentation for details of audio DMA.
> -https://www.kernel.org/doc/html/latest/sound/kernel-api/writing-an-alsa-driver.html
> +Please refer to the :doc:`ALSA driver documentation
> +<../kernel-api/writing-an-alsa-driver>` for details of audio DMA.

Don't use relative paths for :doc:. They don't work well, specially
when one uses SPHINXDIRS.

The best is o use Documentation/kernel-api/writing-an-alsa-driver.rst
and let automarkup figure it out. As we have a checker, broken
references generate warnings at build time.

Regards,
Mauro

