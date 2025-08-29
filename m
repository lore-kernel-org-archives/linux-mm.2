Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07BA3CA0FF0
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 12:01:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 504996B0027; Fri, 29 Aug 2025 08:00:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DB4A6B002A; Fri, 29 Aug 2025 08:00:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CA2D6B002C; Fri, 29 Aug 2025 08:00:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2ACD86B0027
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 08:00:59 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id ED32E119948
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 12:00:58 +0000 (UTC)
X-FDA: 83829653796.18.3899471
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6812A100017
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 12:00:56 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=EZXX5o4h;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=0MSpGSb+;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="OPBU/lqB";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=8HmyejID;
	spf=pass (imf05.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=tzimmermann@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756468856;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iaUzxmwBsmTBCo2WBOyDflFvUI/88ipptA2vlawnwBU=;
	b=wbzeq7An+p+KvsrDbGgh/g0SKQvP1348egMMGwvcjLsXetRLk+kYszNrRB8THF0SscVIWZ
	5+ZsAz8MsFseyEoSCqSdyqLp/iMGHdddS55b0otVg8VKPWPsQLEsiTloegwkSA/6jF1EXL
	mrUKbvTkLenxBnrNCRQ4G8KDal7tKus=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=EZXX5o4h;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=0MSpGSb+;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="OPBU/lqB";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=8HmyejID;
	spf=pass (imf05.hostedemail.com: domain of tzimmermann@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=tzimmermann@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756468856; a=rsa-sha256;
	cv=none;
	b=zc7mf1Sm0tKOYMHuKsHDxYP1Dx2jKUWZLOESKCir4fJPTjzQA1U7vN1Se0fRXDT0JTMNo4
	lWSC7PUbkJa2Xngx7rFfWIfGSVWD0U4tUhz6d2c1f3wfx/qLMp2YzvJoUsMNKHUsZlz4FY
	BboiTY8qeUYdYl2Zs3rpqEn57YjPxSE=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E240333DB6;
	Fri, 29 Aug 2025 12:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1756468854; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=iaUzxmwBsmTBCo2WBOyDflFvUI/88ipptA2vlawnwBU=;
	b=EZXX5o4hQ2Oh7plQuT98v6ah+GhxmYAgzg1F3DN+VoOuk1+I60IqOg+wim4HVwfvZSqk5f
	VXhIIfKRC6+rFIM6IT4VfU7O/rhiTSdo68En/5dfo/OrDfx5ZZaGA58OL+/ZOcRTIyPN6d
	fz6jO2qzGW350Q0Z5O4Dg9aDj5vGPg0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1756468854;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=iaUzxmwBsmTBCo2WBOyDflFvUI/88ipptA2vlawnwBU=;
	b=0MSpGSb+up5ugfLC8+w6PJ5di9IfOZ04Xx+/9bdOmpxI5u8p68jh9c2UpOBzM3HrOSt/uV
	+5Y/F/pI2PXZwTDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1756468853; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=iaUzxmwBsmTBCo2WBOyDflFvUI/88ipptA2vlawnwBU=;
	b=OPBU/lqBuATLoeCcBKBuuQItTtcidsKi3kFoZdqDZ0Nl+eK/z0By3HAYaUQ02mzaBeaA3n
	AxJWmJoWqSxQnOwqThQTyxhYEXHtRdMThJ3gi3fNxVUxFZHqSIPSSoAYM7B5Uonj0JldUt
	pgzVsobFIRWaxfBiWpLS/8FdPrQ6liE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1756468853;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=iaUzxmwBsmTBCo2WBOyDflFvUI/88ipptA2vlawnwBU=;
	b=8HmyejIDx04CqR36zeLP1yk+JJaYK1w8XikVj/s27iMRpTGBB5nX44hU8iQRmaYyaeDrU8
	9JTMYu3gqgAvlVDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9D2EC13A72;
	Fri, 29 Aug 2025 12:00:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id l3olJXOWsWgSYwAAD6G6ig
	(envelope-from <tzimmermann@suse.de>); Fri, 29 Aug 2025 12:00:51 +0000
Message-ID: <871b2113-5482-4f3c-b58b-573d6cbeebe0@suse.de>
Date: Fri, 29 Aug 2025 14:00:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/14] Documentation: gpu: Use internal link to kunit
To: Bagas Sanjaya <bagasdotme@gmail.com>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Linux Documentation <linux-doc@vger.kernel.org>,
 Linux DAMON <damon@lists.linux.dev>,
 Linux Memory Management List <linux-mm@kvack.org>,
 Linux Power Management <linux-pm@vger.kernel.org>,
 Linux Block Devices <linux-block@vger.kernel.org>,
 Linux BPF <bpf@vger.kernel.org>,
 Linux Kernel Workflows <workflows@vger.kernel.org>,
 Linux KASAN <kasan-dev@googlegroups.com>,
 Linux Devicetree <devicetree@vger.kernel.org>,
 Linux fsverity <fsverity@lists.linux.dev>,
 Linux MTD <linux-mtd@lists.infradead.org>,
 Linux DRI Development <dri-devel@lists.freedesktop.org>,
 Linux Kernel Build System <linux-lbuild@vger.kernel.org>,
 Linux Networking <netdev@vger.kernel.org>,
 Linux Sound <linux-sound@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>,
 Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@kernel.org>,
 Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
 Jonathan Corbet <corbet@lwn.net>, SeongJae Park <sj@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Huang Rui <ray.huang@amd.com>, "Gautham R. Shenoy" <gautham.shenoy@amd.com>,
 Mario Limonciello <mario.limonciello@amd.com>,
 Perry Yuan <perry.yuan@amd.com>, Jens Axboe <axboe@kernel.dk>,
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau
 <martin.lau@linux.dev>, Eduard Zingerman <eddyz87@gmail.com>,
 Song Liu <song@kernel.org>, Yonghong Song <yonghong.song@linux.dev>,
 John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>,
 Stanislav Fomichev <sdf@fomichev.me>, Hao Luo <haoluo@google.com>,
 Jiri Olsa <jolsa@kernel.org>, Dwaipayan Ray <dwaipayanray1@gmail.com>,
 Lukas Bulwahn <lukas.bulwahn@gmail.com>, Joe Perches <joe@perches.com>,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Alexander Potapenko <glider@google.com>,
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>, Rob Herring
 <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>,
 Conor Dooley <conor+dt@kernel.org>, Eric Biggers <ebiggers@kernel.org>,
 tytso@mit.edu, Richard Weinberger <richard@nod.at>,
 Zhihao Cheng <chengzhihao1@huawei.com>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Nathan Chancellor <nathan@kernel.org>,
 Nicolas Schier <nicolas.schier@linux.dev>, Ingo Molnar <mingo@redhat.com>,
 Will Deacon <will@kernel.org>, Boqun Feng <boqun.feng@gmail.com>,
 Waiman Long <longman@redhat.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 Shay Agroskin <shayagr@amazon.com>, Arthur Kiyanovski <akiyano@amazon.com>,
 David Arinzon <darinzon@amazon.com>, Saeed Bishara <saeedb@amazon.com>,
 Andrew Lunn <andrew@lunn.ch>, Liam Girdwood <lgirdwood@gmail.com>,
 Mark Brown <broonie@kernel.org>, Jaroslav Kysela <perex@perex.cz>,
 Takashi Iwai <tiwai@suse.com>, Alexandru Ciobotaru <alcioa@amazon.com>,
 The AWS Nitro Enclaves Team <aws-nitro-enclaves-devel@amazon.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>,
 Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
 Steve French <stfrench@microsoft.com>,
 Meetakshi Setiya <msetiya@microsoft.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Bart Van Assche <bvanassche@acm.org>, =?UTF-8?Q?Thomas_Wei=C3=9Fschuh?=
 <linux@weissschuh.net>, Masahiro Yamada <masahiroy@kernel.org>
References: <20250829075524.45635-1-bagasdotme@gmail.com>
 <20250829075524.45635-9-bagasdotme@gmail.com>
Content-Language: en-US
From: Thomas Zimmermann <tzimmermann@suse.de>
Autocrypt: addr=tzimmermann@suse.de; keydata=
 xsBNBFs50uABCADEHPidWt974CaxBVbrIBwqcq/WURinJ3+2WlIrKWspiP83vfZKaXhFYsdg
 XH47fDVbPPj+d6tQrw5lPQCyqjwrCPYnq3WlIBnGPJ4/jreTL6V+qfKRDlGLWFjZcsrPJGE0
 BeB5BbqP5erN1qylK9i3gPoQjXGhpBpQYwRrEyQyjuvk+Ev0K1Jc5tVDeJAuau3TGNgah4Yc
 hdHm3bkPjz9EErV85RwvImQ1dptvx6s7xzwXTgGAsaYZsL8WCwDaTuqFa1d1jjlaxg6+tZsB
 9GluwvIhSezPgnEmimZDkGnZRRSFiGP8yjqTjjWuf0bSj5rUnTGiyLyRZRNGcXmu6hjlABEB
 AAHNJ1Rob21hcyBaaW1tZXJtYW5uIDx0emltbWVybWFubkBzdXNlLmRlPsLAjgQTAQgAOAIb
 AwULCQgHAgYVCgkICwIEFgIDAQIeAQIXgBYhBHIX+6yM6c9jRKFo5WgNwR1TC3ojBQJftODH
 AAoJEGgNwR1TC3ojx1wH/0hKGWugiqDgLNXLRD/4TfHBEKmxIrmfu9Z5t7vwUKfwhFL6hqvo
 lXPJJKQpQ2z8+X2vZm/slsLn7J1yjrOsoJhKABDi+3QWWSGkaGwRJAdPVVyJMfJRNNNIKwVb
 U6B1BkX2XDKDGffF4TxlOpSQzdtNI/9gleOoUA8+jy8knnDYzjBNOZqLG2FuTdicBXblz0Mf
 vg41gd9kCwYXDnD91rJU8tzylXv03E75NCaTxTM+FBXPmsAVYQ4GYhhgFt8S2UWMoaaABLDe
 7l5FdnLdDEcbmd8uLU2CaG4W2cLrUaI4jz2XbkcPQkqTQ3EB67hYkjiEE6Zy3ggOitiQGcqp
 j//OwE0EWznS4AEIAMYmP4M/V+T5RY5at/g7rUdNsLhWv1APYrh9RQefODYHrNRHUE9eosYb
 T6XMryR9hT8XlGOYRwKWwiQBoWSDiTMo/Xi29jUnn4BXfI2px2DTXwc22LKtLAgTRjP+qbU6
 3Y0xnQN29UGDbYgyyK51DW3H0If2a3JNsheAAK+Xc9baj0LGIc8T9uiEWHBnCH+RdhgATnWW
 GKdDegUR5BkDfDg5O/FISymJBHx2Dyoklv5g4BzkgqTqwmaYzsl8UxZKvbaxq0zbehDda8lv
 hFXodNFMAgTLJlLuDYOGLK2AwbrS3Sp0AEbkpdJBb44qVlGm5bApZouHeJ/+n+7r12+lqdsA
 EQEAAcLAdgQYAQgAIAIbDBYhBHIX+6yM6c9jRKFo5WgNwR1TC3ojBQJftOH6AAoJEGgNwR1T
 C3ojVSkIALpAPkIJPQoURPb1VWjh34l0HlglmYHvZszJWTXYwavHR8+k6Baa6H7ufXNQtThR
 yIxJrQLW6rV5lm7TjhffEhxVCn37+cg0zZ3j7zIsSS0rx/aMwi6VhFJA5hfn3T0TtrijKP4A
 SAQO9xD1Zk9/61JWk8OysuIh7MXkl0fxbRKWE93XeQBhIJHQfnc+YBLprdnxR446Sh8Wn/2D
 Ya8cavuWf2zrB6cZurs048xe0UbSW5AOSo4V9M0jzYI4nZqTmPxYyXbm30Kvmz0rYVRaitYJ
 4kyYYMhuULvrJDMjZRvaNe52tkKAvMevcGdt38H4KSVXAylqyQOW5zvPc4/sq9c=
In-Reply-To: <20250829075524.45635-9-bagasdotme@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6812A100017
X-Stat-Signature: izszyogfkiw69wtfw7hk4fdfs5x7f8hu
X-Rspam-User: 
X-HE-Tag: 1756468856-29060
X-HE-Meta: U2FsdGVkX1+dlqhvIhddOa2TG6Bu4TOOTQX367bxdYJdllAAtziO/0oFW4jC1DWleXMT2nvdW7wwxdBaseUNy1daG/sM/BfXZp5/PcWiOsVw07Cdlu0FuqyqM+UWhOMMIkgIJ/XWyUrG97Mi3BY1326SkbO5TEFd/G0+WODSKAi7ALySLSSt2mER5uugN7rylufM+5PUZjtQkQ6Np4jsAdIcBq7P5mED+NGw8yvi1LsEb4UACt0XZDNWyzzF1uupfXtyfOW/kNpQ8Rn2kK2o2xxJ6z540QCQp1vxOC9GMtL9h9JS6IUJ37pYEeeInFYstfeGoEG60IZcHIAitpaEkEJoTx3eP18bAFUE9Hy0mc2ceOBzwbPaKt3+fRdmDLDBs1dygLb0weAhn3aDrsbNJ+DSEMH6j0Kd/YA6y9xabvkMFV/LGIwww7SJeY2cwp2QT44vxFNwsVLwNCPRE3JqzI7Ze0B6hLX2kY0MQof+oD9oVtgVnnB5EUPk2Jizoxn8SI66Ziwf8/APLvBSFTng9sp6xh6Pdq3cDQ3acIkE4UQLeqbBXc8g7hXSmRflpIW97AV4FXrsLr24FtaHvbwbxPUgdqaG7aTPfgBKIcKioGx3K3mnnAEqetHSV1RZSpXTtw0uGFpn536ZHwPPPRNuYozjz1nO3nZln0sAU/17JGRsIxSd9ss3d251EZucCZ1cffx6Yg/4kKNVDuRZxSxGgkxklVXbdlUPmLYI5mEV6cDJCMVUJCJmYgGgWMjw/kYvCgnbP10eujV8moeja7Lz4pNqsdYBlJrUJCKX0e1UWAdiTKxCiKAXoq9wVvTJZA4B/FjdcxA+2nyRi6h+Rc5UOfjNNHH5emtjv6H9CHaB1vsZtURuCLcN4u3TQPTGA4szUtNiAZzQwT9wG4o2nNdUfaXfczUQwDYUhrstQnPgM25UXICG5qkaKC0eduwtohaHjzRKxASEzM3p2jx4qOa
 lucPXHjt
 c27btbqUTOZNcnlluADTMcW0zssM7FLU1IAN4LmuBCORmUzVqn03EWqmqHl+Usobl7FoyMpyeYXUHRX/XvXAyzI154SH/laX6z1SdkBfMyJJUfYOU0yo8l0yY9J77/KRS8/ur2UGgRVwMQ3bycHGSjvisIm9RZFHHlzbHXBy1up4XwvhYlxY9Gf06ikuHP4j7CJ29uWIhg7mVMY+4A8NmnU3+bKaMhKHt35XeTUDDBpW/3+/n7UeXDHVBcMBqSLWR4jUZZc2H9oKClyTzfd5BUqjAkcPhOm4H2m/RMJxEfugvyckdJ+9kqlEAQwqvFzyeof3zEaRrJlfDxRHpR8b4ed470D9T1ieii5mMf5xcD5gXhRDEhO5rY4PJeUhNTTbdoC3pNLkGyn7GjVka3D1UlUrCNbZcVe3lmuoTkXmYibFYHFBQwcXWCni1yQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Am 29.08.25 um 09:55 schrieb Bagas Sanjaya:
> Use internal linking to kunit documentation.
>
> Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>

Acked-by: Thomas Zimmermann <tzimmermann@suse.de>

Fell free to merge it through a tree of your choice.

Best regards
Thomas

> ---
>   Documentation/gpu/todo.rst | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/Documentation/gpu/todo.rst b/Documentation/gpu/todo.rst
> index be8637da3fe950..efe9393f260ae2 100644
> --- a/Documentation/gpu/todo.rst
> +++ b/Documentation/gpu/todo.rst
> @@ -655,9 +655,9 @@ Better Testing
>   Add unit tests using the Kernel Unit Testing (KUnit) framework
>   --------------------------------------------------------------
>   
> -The `KUnit <https://www.kernel.org/doc/html/latest/dev-tools/kunit/index.html>`_
> -provides a common framework for unit tests within the Linux kernel. Having a
> -test suite would allow to identify regressions earlier.
> +The :doc:`KUnit </dev-tools/kunit/index>` provides a common framework for unit
> +tests within the Linux kernel. Having a test suite would allow to identify
> +regressions earlier.
>   
>   A good candidate for the first unit tests are the format-conversion helpers in
>   ``drm_format_helper.c``.

-- 
--
Thomas Zimmermann
Graphics Driver Developer
SUSE Software Solutions Germany GmbH
Frankenstrasse 146, 90461 Nuernberg, Germany
GF: Ivo Totev, Andrew Myers, Andrew McDonald, Boudien Moerman
HRB 36809 (AG Nuernberg)



