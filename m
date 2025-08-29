Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 325D6CA0FF9
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 15:37:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 738576B0025; Fri, 29 Aug 2025 11:37:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E85B6B002D; Fri, 29 Aug 2025 11:37:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B0FA6B002E; Fri, 29 Aug 2025 11:37:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 46F386B0025
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 11:37:04 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E33CDBB5D8
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 15:37:03 +0000 (UTC)
X-FDA: 83830198326.08.A3FCE58
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 31CCE40008
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 15:37:02 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hxRjy6JU;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756481822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QlEkqcjNcBy0l/GUV3Al+3r/V5OrJADrNoiJdSPBV78=;
	b=yirtlm6+8LF/EC7gwKG7D8i4sUPQSED8z3P+QmBsXXldYn9pOZc+nRo5GA7eAVzDVMJPo8
	5F150qjuQcGo1eyjEMRgMQYzMn86uWnvnjhtxg0/IYnQIJyDaISwxSl3PGLmJvuiX57MnN
	iJHKfuegebmUUnyAvUDQCAHIrQMw5V8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hxRjy6JU;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756481822; a=rsa-sha256;
	cv=none;
	b=Z/QaOnEEpTbSzPhX83hzr4wikS26C4cHwtgLvcVvvIA6bnxmsR6otCmX3Ue6RksUWPBgA2
	Gf9Ogr1rIkkU9NKldG+oEfHYfptgWPEy09TTQvRoTRbb53KgA5DptjAcK1WHugMTNVkv1S
	GaxtsRquU4xPPPRVKS5tm2vgZLMGmdM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C3D6C40BA3;
	Fri, 29 Aug 2025 15:37:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61569C4CEFC;
	Fri, 29 Aug 2025 15:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756481820;
	bh=Z0Bv7WaDdOXi4UMDM6ZgBS7CKcxMZ6kvuSO3nqYq5X8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hxRjy6JU/oDw6RINsxcmGRsTVGeDOVIb4ykJmLCqUX+QQzeylWuLrDXAGu73hmOa8
	 cXkBsFfxubx34foFYG+QHJojJeqb3QzXsHL83AkHDPdn/Qv4/IIR3e2qaYlaHVj7X8
	 /ujZy8fCtuvOl+p3ABN9mW0y/L62IEPa3LIB45zqcEIJiII+iaRRjvCxcFZVIe4UIP
	 kaEKsYFY6b00ExIR7mNyizMsT0mnem6gSXppPc1I0E+Yiwnl2Whyv7VtVp7zbfroC1
	 buwbPy49vW/4gXiHEGPpC1YTGlyYCgxjAJ+Hb56S4jwabvggJ+9rHuCjN6QDMZMzu7
	 EVcfRMiw+6syA==
From: SeongJae Park <sj@kernel.org>
To: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
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
	Linux Sound <linux-sound@vger.kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Huang Rui <ray.huang@amd.com>,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Perry Yuan <perry.yuan@amd.com>,
	Jens Axboe <axboe@kernel.dk>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	John Fastabend <john.fastabend@gmail.com>,
	KP Singh <kpsingh@kernel.org>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Hao Luo <haoluo@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Dwaipayan Ray <dwaipayanray1@gmail.com>,
	Lukas Bulwahn <lukas.bulwahn@gmail.com>,
	Joe Perches <joe@perches.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>,
	tytso@mit.edu,
	Richard Weinberger <richard@nod.at>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nicolas.schier@linux.dev>,
	Ingo Molnar <mingo@redhat.com>,
	Will Deacon <will@kernel.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Waiman Long <longman@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Shay Agroskin <shayagr@amazon.com>,
	Arthur Kiyanovski <akiyano@amazon.com>,
	David Arinzon <darinzon@amazon.com>,
	Saeed Bishara <saeedb@amazon.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Liam Girdwood <lgirdwood@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.com>,
	Alexandru Ciobotaru <alcioa@amazon.com>,
	The AWS Nitro Enclaves Team <aws-nitro-enclaves-devel@amazon.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Steve French <stfrench@microsoft.com>,
	Meetakshi Setiya <msetiya@microsoft.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Bart Van Assche <bvanassche@acm.org>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Masahiro Yamada <masahiroy@kernel.org>
Subject: Re: [PATCH 02/14] Documentation: damon: reclaim: Convert "Free Page Reporting" citation link
Date: Fri, 29 Aug 2025 08:36:58 -0700
Message-Id: <20250829153658.69466-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250829075524.45635-3-bagasdotme@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 31CCE40008
X-Stat-Signature: zi63acny6w5ntq9eth1ypx5qd5xfpyd8
X-Rspam-User: 
X-HE-Tag: 1756481822-145961
X-HE-Meta: U2FsdGVkX1/MR/8EWB6+Q6cUIU1nP2NCJL5MzRX3cECCGmW0TKAj4DNDK0Jcqc+2Fpy1MJSiy+8xLA2VMPlYhkmh1KSMSULNPYppS5PgV9EkMFTljTiU1vNUKI2gf5HFENLv7ZK9pccDQwFTODeiAc/V5wwmMkvIz7xixzF/5M+40nVkD1QbW+Qx8p3lhC+qodM9MPF0skOz+piUJdhsfPOS+AMVBiX9Vniln9501IVDQXcL2SufXtsCJbctxY4GW6m0HTKtTdX8y6sgFhgwgRnnkFGMLp1YH7r7z4gV34uP9R4zQvI97CwMx3rnmmcENK4lVRD6PpKmSeDigSt2eHx+ZewXYkKalEG2XWfXNAfn1/AcdF5ZYs9HaZ0JhHULaPslI7DVg24RYlfwIwu+D0GC+C6bZ+nDYEKZ+dlJizESej+rmoh9BwbMs/8InehscHcbDDOTVnxutziW5vsJYaoWrAwJs75JIDzowSVroeQWkjEpecRSbs6kT/XyIdjb4nJ/bTvQW3D49T073fRanaKYPOKhESSxhcfbWLmsWEm7yi9gQeRWGZM6kTW8FgpB3E2qP0v04aqc7CaGxC3g8sp2cwrGX7kM/E/9rKvkI5aQ1WSqfp+TK6d/ZbQ9hVq/QfsKOzsk8pW3uCWAqx6DhnqITGyJd0EMrxsmNvp8rJKE8/EeY9/OwSCtTpxnlQ+vEf275uuc2YpRf+WJZYhP6ntVs/YtCqssAosMDEBVuJAvis6/Eyxd53yZYLdiTLkiRwmTu4fq+nQZCVu08axuNHuKs5YrxaBy3GN9ByALycEHSAEr7bVile2K38N2NWQd3w4YFHc+bHT6xdt5IHChJr3J1eigRqUi8gxRlWNoTzdEkvwMprKfhe9MAEhkb/aJXmd354dD/+PAAcwbOUp4RWkdz9G+TmmRYQzHtnjctipmhsBWzU+dD9IuZHVsfhKm2jIZ8A2dp2dba0EGv7h
 J6wBR+dI
 g2u2EbuAE567bOntCqGSGWWSE1VDyEPET+tLlHNv2ryaOQL4PonSLjuMJYmcaGOy0eDVXvdDEcMW6go1P1EdYgyLFSCLxylBWo8CFeJhvxX0xaoKdj4omo+lN8Ohidl8lXAOT+l0xSwnCJBIVznvRVxsPot6hmkbCigf8bXK8uKbOxIyGnLq/ZX9B3vOa6DbRtr+MC0UbIFd8SDiAbVX19c+K+7MzCFqgOoXYqVToVarCg5xxMKy4t1vII34ZTXYJYfOpGKAc1YWHKYKyuxhGgRxhzUena6HpFkdKcTPi468PdUpPoAXOTegd3IizO4osBXtRluUteYMEZ8M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 29 Aug 2025 14:55:12 +0700 Bagas Sanjaya <bagasdotme@gmail.com> wrote:

> Use internal cross-reference for the citation link to Free Page
> Reporting docs.

Thank you for fixing this!

> 
> Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

