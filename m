Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC978CA100C
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 03:32:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D80058E0003; Tue,  2 Sep 2025 23:32:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D30EA8E0001; Tue,  2 Sep 2025 23:32:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C46768E0003; Tue,  2 Sep 2025 23:32:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AF7978E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 23:32:23 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2C263B9B80
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 03:32:23 +0000 (UTC)
X-FDA: 83846516166.11.246D5A4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8A04EC0007
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 03:32:21 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="c6/aA16+";
	spf=pass (imf10.hostedemail.com: domain of superm1@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=superm1@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756870341;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rWhJThhT6wJhyT9aykv2T89JLmY/pZ9Lzvy+TuJsbAE=;
	b=Cy8irtoxKayexvK9fnQyGeOL5TrIOY9fs9tHDBtMuwfudgi8HcRNqUTYRPvRzu2dagkGIX
	W/HOXRIPEdCDzTRn7sZUhd8p7gCaI5ZWAl9iQgtRMJtzPfwZTYdgpzim00hAAcQRgLNAJ0
	6L+AQdjC3KmI9W/Z9NoBEi/mO1hy33c=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="c6/aA16+";
	spf=pass (imf10.hostedemail.com: domain of superm1@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=superm1@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756870341; a=rsa-sha256;
	cv=none;
	b=QBeKhbNJoZSWgDhg/xBzN3hr+Pw9DirY+VFO/9z1AkcbG1BoHvePYVopmowYKEyegjxz9e
	YWKF5Yft2f7DWt4lJFAGOK2iz4qb9727Z4j0AUNLZQ2rmu1+/NSzEIuIeRF6L0g5hsQOcF
	8QWCuKFpwQ4BG5L0XDHzYdlgXRb3Tf8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 73A156013B;
	Wed,  3 Sep 2025 03:32:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C22F8C4CEF0;
	Wed,  3 Sep 2025 03:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756870340;
	bh=1armfrQSPhghEXbEgCR40kMT3Mz1KUNVgAlY6GjrTLM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=c6/aA16+bBkQH51tR2bcv5SM6tXtTwJMULf4022Tate2FmzdfUbzGvPiP2fkcVpWI
	 RriSmrsN2ZlJj0IloB/qX3FQ3Nx9cN4lqbucrjYT4KLxt2DgUbVBqvIKo2olMXLgfB
	 9N5kKv4v3IBmC1YJev3/3rxoXwXwhR46dCAt8jPxByNLb/XkehQ3Po6KdKfM7VpmMm
	 1Q1BM8WVxFsEMqVtGOxGMqeKmeEKRty2lb7WMxAWqJ6tmtHvJWE+KovB1IE7Kw9o50
	 ge8OGusvBxfm+9So2e0mbnLX+HsjFa6ZxAt4PFAo/YR4SAEcoNc0h0IuibbyWbTQJn
	 FVh2NdAaEjS2A==
Message-ID: <3242f4a2-9a5f-4165-8d24-5c2387967277@kernel.org>
Date: Tue, 2 Sep 2025 22:32:05 -0500
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/14] Documentation: amd-pstate: Use internal link to
 kselftest
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
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 Nathan Chancellor <nathan@kernel.org>,
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
 <20250829075524.45635-5-bagasdotme@gmail.com>
Content-Language: en-US
From: Mario Limonciello <superm1@kernel.org>
In-Reply-To: <20250829075524.45635-5-bagasdotme@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8A04EC0007
X-Stat-Signature: jbnn57xdqucsws1cb4zed3c94zo67n76
X-Rspam-User: 
X-HE-Tag: 1756870341-52458
X-HE-Meta: U2FsdGVkX1/zkpoj2NXsVnLV1tYysAoEgEVjYleW3YsR3Chr0lFwn4gXyS+8N8o8vAuayfaaxzyxNJ9wx1bv5bb4WK5uRLLkLZx71+uSoIN1bR/1F74Ot4MwzRKjftU2lNbeDM5ITG55lgqX4yUg5x1ZBX1SREbqcQ5VLr0L3esOpqt2etp9/v7Cg/gwYvOWb1VKiewYUadAzUXYlG7MN6/gPCvQFfGjYESZKSmB4IE1MyA32R89XTMfjkWozs33h/VOYE12hk0zncLJeVglNrQBJRF/m6J+yVY03Pd+8nc0ya/sDWTWCvA/73iYtxF9PNWTuYFf6wtuAmiD9AKcP9EkDc7vJLRuylwm85u9+ujEQi/cEMAmpUCUQECaUycIl/hj6c1vmcE2sdIrLWkt2yYHIr0r1AQMJ34i9dVVU3ZiIU7YXy33/HiUWa4Omk4UddTvRX7EfYEnapKrwm6PHi1S9wxn1QwJEkvBjKmwjoUwtb+n81Mmu6mHS/B1wsHb6034RHEmgLZofDOjBhFmQ7x40ReUY9SFYL+hHSigORD1Bppa93OqJhcskIUZ+KJsswvrmWCmyvdGJ2oxkC5TJb9VI94cx38dlaVTtLSrQIpQ9lmR/GSEqVn1kYDcz6kMmqA1JUzp79DBc7JVMPav72X6dzbtPmUiPYujXpdAvJ3wyVG1DVGegPyqUxwfDPunM3EwcOg1aNu248/4GbmLiO0ZKWjfI6VYzDVKMjTAQGrJGvz4LDlq6dHHmM0ibjFWbr5pUaq8iH79ccdK6D11vs7Kp8Hx2HmEeuyAlYH8qqpzVG6KFwhZpfOT8QZKlu2tCl0XmQqN90+jlyaY2biMRWW7Yf7qQEr9toi3iuZ4Cvye3bU+HIAO25m3cWAeB0DfgLDJLC6xGOgccfcetKXRHizX5INWQor6GafMmqwexfLj7tzFHDH6t+MabN29wuRFRQTz8UUrXJ+EzAE3XLr
 mv0OejBU
 HKuT35qOJxwygbHhAPIiD4PGr1w+SRe4x2Obg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/29/2025 2:55 AM, Bagas Sanjaya wrote:
> Convert kselftest docs link to internal cross-reference.
> 
> Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
> ---
>   Documentation/admin-guide/pm/amd-pstate.rst | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/Documentation/admin-guide/pm/amd-pstate.rst b/Documentation/admin-guide/pm/amd-pstate.rst
> index e1771f2225d5f0..37082f2493a7c1 100644
> --- a/Documentation/admin-guide/pm/amd-pstate.rst
> +++ b/Documentation/admin-guide/pm/amd-pstate.rst
> @@ -798,5 +798,4 @@ Reference
>   .. [3] Processor Programming Reference (PPR) for AMD Family 19h Model 51h, Revision A1 Processors
>          https://www.amd.com/system/files/TechDocs/56569-A1-PUB.zip
>   
> -.. [4] Linux Kernel Selftests,
> -       https://www.kernel.org/doc/html/latest/dev-tools/kselftest.html
> +.. [4] Documentation/dev-tools/kselftest.rst

Acked-by: Mario Limonciello (AMD) <superm1@kernel.org>


