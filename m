Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CAA9606A33D
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 02:13:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01CDA6B063D; Thu, 12 Nov 2026 21:13:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F36BF6B063F; Thu, 12 Nov 2026 21:13:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E764A6B0640; Thu, 12 Nov 2026 21:13:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B04DB6B063D
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 21:13:10 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2E443A79B7
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 02:13:10 +0000 (UTC)
X-FDA: 85428473340.29.466C528
Received: from zg8tmtyylji0my4xnjeumjiw.icoremail.net (zg8tmtyylji0my4xnjeumjiw.icoremail.net [162.243.161.220])
	by imf19.hostedemail.com (Postfix) with ESMTP id EDD451A0002
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 02:13:05 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	spf=pass (imf19.hostedemail.com: domain of dzm91@hust.edu.cn designates 162.243.161.220 as permitted sender) smtp.mailfrom=dzm91@hust.edu.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794535988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2Y84LlsZe6rgvKsWJlLFsVqJRljJBA8w4SWbN4DVpek=;
	b=ivJOWxL8ewO5XIoRoYYPiq38CzW7E+893oIpWbrknDdR1hSOfSMlhdTRxkZC7oQhnAEJ3i
	+goFHgvwQYS6s+tDsmUbUZv7QhikieSXtolLSvEqX2+b/MmspGsrFWm2XYYE17ZyzVXKOV
	Jtrf/OoUwUH3yIgCqmY6T9zr6L3JPDM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794535988;
	b=tO4hVqHmfG//lieFdavb5TVG+Hh1qzzrZLF4LlcLXNbBpLjjT8IsUuUb/SiB1kfkrSRZTt
	5lqYFfijZy8Mu6PY3jIKyjDjAg2OA4hRjwjuT35B131N4vdkWPy1j6gCbJHEfQoehUgbNx
	QHdhdQ2N3ff3atdIWe7GXgSRG7Rd2u4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of dzm91@hust.edu.cn designates 162.243.161.220 as permitted sender) smtp.mailfrom=dzm91@hust.edu.cn;
	dmarc=none
Received: from hust.edu.cn (unknown [172.16.0.50])
	by app1 (Coremail) with UTF8SMTP id IAEQrMBWHWkqcvZqh8ZEAA--.1437S2;
	Fri, 13 Nov 2026 10:12:58 +0800 (CST)
Received: from [100.81.40.43] (unknown [10.12.191.55])
	by gateway (Coremail) with SMTP id _____wC3sN8gcvZqqfo_AA--.64337S2;
	Fri, 13 Nov 2026 10:12:53 +0800 (CST)
Message-ID: <f9ee662a-4da0-4204-89ce-33704044c88c@hust.edu.cn>
Date: Fri, 13 Nov 2026 10:12:47 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/zsmalloc: remove CONFIG_ZSMALLOC_STAT
To: Xueyuan Chen <xueyuan.chen21@gmail.com>, Minchan Kim
 <minchan@kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap
 <rdunlap@infradead.org>, Alex Shi <alexs@kernel.org>,
 Yanteng Si <si.yanteng@linux.dev>, Heiko Carstens <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev
 <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Helen Koike
 <helen.fornazier@gmail.com>, Vignesh Raman <vignesh.raman@collabora.com>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>
Cc: linux-mm@kvack.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
 dri-devel@lists.freedesktop.org, Nhat Pham <nphamcs@gmail.com>
References: <20261111-zsmalloc_stat-v3-1-2d85ed51570e@gmail.com>
From: Dongliang Mu <dzm91@hust.edu.cn>
In-Reply-To: <20261111-zsmalloc_stat-v3-1-2d85ed51570e@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:IAEQrMBWHWkqcvZqh8ZEAA--.1437S2
X-Coremail-Antispam: 1UD129KBjvJXoW3AF17KrWUuF48AF4DZw1DJrb_yoWfGFy3pa
	18Jr4xCryxtF15J3yUArykur9xt3ZrWFW8Gw1DW34rZFn2yw4FyFyDKryYv3yDXrWkAa1x
	GF9agFna93Wjy3JanT9S1TB71UUUUjDqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUQKb7Iv0xC_KF4lb4IE77IF4wAFc2x0x2IEx4CE42xK8VAvwI8I
	cIk0rVWrJVCq3wA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK6xIIjx
	v20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4UJVWxJr1l84ACjcxK
	6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1ln4kS14v26r
	126r1DM2vYz4IE04k24VAvwVAKI4IrM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI
	12xvs2x26I8E6xACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj64x0Y40En7xvr7AKxV
	W8Jr0_Cr1UMcIj6x8ErcxFaVAv8VW8uFyUJr1UMcIj6xkF7I0En7xvr7AKxVW8Jr0_Cr1U
	McvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwCY1x0262kKe7AKxVWUAVWUtwCY02
	Avz4vE-syl42xK82IYc2Ij64vIr41l42xK82IY6x8ErcxFaVAv8VW8uFyUJr1UMxC20s02
	6xCaFVCjc4AY6r1j6r4UMxCIbckI1I0E14v26r126r1DMI8I3I0E5I8CrVAFwI0_Jr0_Jr
	4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWrXVW8Jr1lIxkGc2Ij64vI
	r41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr
	1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvE
	x4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU0MxRDUUUUU==
X-CM-SenderInfo: asqsiiirqrkko6kx23oohg3hdfq/
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: EDD451A0002
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: tmixztw5anip7wpcznixinzcbkpyez5u
X-Rspam-User: 
X-HE-Tag: 1794535985-184244
X-HE-Meta: U2FsdGVkX19xyBm8AmEsV+gDioUCOh5VvSmyRc3RXPPLKfPwr9g/wgQtTLlK7YgFisw5dBGs5JwvWnIUjMtlMfWjnP55W4gYHjy2kzvSHg+QkmHFOivq08oIcr2au09I5rer5HGzWU+SeWmw9WwAkLOSdSnkyZ6eotZAr29yWU6oVWE3YKkaxkALTyOc16lpP4Uw+qbffOQufh5y2+eFE92TXV+EjAmlQE6KggA08TmJaR+9imJTuRSMkcf3BpS7/ra4JpbL5rrT3mxURcFwQCo1P1eN1dak+XzmN9h78fb/uPqyHYE9zqC1X6QGqXLhkUXy/zDRSeNpqSobhP3wXNQKJ8YynL5CbGH53b23Z8zozVm/pts2YFopV9jxne8ITpRCFQOgQ8VkSs51p07NlTdYY3XaFzYbdoGnSg3A6q93FZ53m7dGlLwNqG3Tnrw/Wh1z8uEp61Aviur+iSYY/bHnW+fhQPg8pmdkM6iYk3BIbnPNz3N2x9XS4nNy1Im3l1qxvxwUUIhmrzWhsRQ68iXVt2XgUKcjL90lWV5DWv7RuylD1EvRqqIaIy3E2gFMknCnoYu3yNsnIPNiXODzYvePVJ2osGWebkQU5bP7LZ45w5fcOYYkOM+a4/ilgW0CBNgCXPqrstsmTCMoxU+qrMVmkss5HuBSIbUqjjk9wnrXwObrPVwStCeG9uvmVhWjMDVpTChftTj1FAwxXa5LE/hyrDZAZQ8s4zm5yUps35HiNP11IVRHkBlWk1u42p+iF5zLqgtvp/0Y1IZKiqeYNJC/2YYD1+d/J/cQkQtQAiapbFu0BkNaIbSZBabVobkPh+wJpTyUnMt7ArZGpADrgEspiktKB2Mtq/PJhhmOWwq9WWK+eR7u97+Cish5X29f2L2PqypJU9/th/w7p4P9VIKFxj7BMgAjxnBMIjd8ei1IQHM3PVdG/0RuJzNZGPR83kEK43YmvVQ2Ra2BqSb
 jFmPksSQ
 TBRdzRh3SfZ4kcAxsVdTXZDDVYpaxDFyoA4j1YIzZcWbfSp4PuhTqFw2QMHB/Cy5hTkZlHnwMZOlA/JbVUNsxIrWFgomUtmgMydTlm76c4hgUZXNmn50Nex+3SI3y98ZqAiI4b89Y+BjWSeecpXFRrPBq7/LpO8vi9c5/ryh4Fr+8kwfnwc7mGyFD/3fn+o/lkHcNYklHp1rgTcVRjZ9NdBqieU6DbBzS4kRtJPhlcKGXmOz2LAgqaLSWpiXLh/wkDXgbCUfaAGBBZOoZuHdplwZcMe4z456r2VoUP6NQEpRjYDaLJdTIQb1+Tw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On 11/11/26 8:41 PM, Xueyuan Chen wrote:
> CONFIG_ZSMALLOC_STAT only controls the debugfs interface. The class
> counters are updated regardless of this option.
>
> Remove the CONFIG_ZSMALLOC_STAT guards and rely on the debugfs API
> stubs when CONFIG_DEBUG_FS=n. Skip statistics setup silently when
> debugfs is unavailable.
>
> Remove the Kconfig entry and replace the existing CONFIG_ZSMALLOC_STAT
> settings with CONFIG_DEBUG_FS=y. Update the English and Chinese
> documentation to match, and clarify the pool name in the debugfs path.
>
> Suggested-by: Nhat Pham <nphamcs@gmail.com>
> Reviewed-by: Nhat Pham <nphamcs@gmail.com>
> Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>

|The documentation changes look good to me. Acked-by: Dongliang Mu 
<dzm91@hust.edu.cn> # Documentation|

> ---
> Drop CONFIG_ZSMALLOC_STAT instead of making the counters conditional. The
> option only controls the debugfs interface, while the class counters are
> updated unconditionally. Removing it simplifies the code.
>
> Following Nhat's suggestion, remove CONFIG_ZSMALLOC_STAT and rely on
> the existing debugfs API stubs when CONFIG_DEBUG_FS=n.
> ---
> Changes in v3:
> - Squash the three patches into one (Nhat, Sergey).
> - Add Nhat's Reviewed-by.
> - Update the documentation wording.
> - Link to v2: https://patch.msgid.link/20261109-zsmalloc_stat-v2-0-caee41684aba@gmail.com
>
> Changes in v2:
> - Drop CONFIG_ZSMALLOC_STAT instead of making the counters conditional.
> - Update configuration files and documentation.
> - Link to v1: https://patch.msgid.link/20261106-zsmalloc_stat-v1-1-b574f4714adf@gmail.com
> ---
>   Documentation/mm/zsmalloc.rst                    |  4 +--
>   Documentation/translations/zh_CN/mm/zsmalloc.rst |  2 +-
>   arch/s390/configs/debug_defconfig                |  2 +-
>   arch/s390/configs/defconfig                      |  2 +-
>   drivers/gpu/drm/ci/arm.config                    |  2 +-
>   drivers/gpu/drm/ci/arm64.config                  |  2 +-
>   drivers/gpu/drm/ci/x86_64.config                 |  2 +-
>   mm/Kconfig                                       |  9 -------
>   mm/zsmalloc.c                                    | 33 ++----------------------
>   9 files changed, 10 insertions(+), 48 deletions(-)
>
> diff --git a/Documentation/mm/zsmalloc.rst b/Documentation/mm/zsmalloc.rst
> index d2bbecd78e14..4c0786378dc3 100644
> --- a/Documentation/mm/zsmalloc.rst
> +++ b/Documentation/mm/zsmalloc.rst
> @@ -33,8 +33,8 @@ proper handle-based APIs.
>   stat
>   ====
>   
> -With CONFIG_ZSMALLOC_STAT, we could see zsmalloc internal information via
> -``/sys/kernel/debug/zsmalloc/<user name>``. Here is a sample of stat output::
> +With CONFIG_DEBUG_FS, we could see zsmalloc internal information via
> +``/sys/kernel/debug/zsmalloc/<pool-name>``. Here is a sample of stat output::
>   
>    # cat /sys/kernel/debug/zsmalloc/zram0/classes
>   
> diff --git a/Documentation/translations/zh_CN/mm/zsmalloc.rst b/Documentation/translations/zh_CN/mm/zsmalloc.rst
> index 4c8c9b1006a9..b555a07ac871 100644
> --- a/Documentation/translations/zh_CN/mm/zsmalloc.rst
> +++ b/Documentation/translations/zh_CN/mm/zsmalloc.rst
> @@ -32,7 +32,7 @@ zs_unmap_object()解除映射。
>   stat
>   ====
>   
> -通过CONFIG_ZSMALLOC_STAT，我们可以通过 ``/sys/kernel/debug/zsmalloc/<user name>``
> +启用CONFIG_DEBUG_FS，我们可以通过 ``/sys/kernel/debug/zsmalloc/<pool-name>``
>   看到zsmalloc内部信息。下面是一个统计输出的例子。::
>   
>    # cat /sys/kernel/debug/zsmalloc/zram0/classes
> diff --git a/arch/s390/configs/debug_defconfig b/arch/s390/configs/debug_defconfig
> index d44674b63715..83193ef8efb9 100644
> --- a/arch/s390/configs/debug_defconfig
> +++ b/arch/s390/configs/debug_defconfig
> @@ -100,7 +100,7 @@ CONFIG_UNIXWARE_DISKLABEL=y
>   CONFIG_IOSCHED_BFQ=y
>   CONFIG_BINFMT_MISC=m
>   CONFIG_ZSWAP=y
> -CONFIG_ZSMALLOC_STAT=y
> +CONFIG_DEBUG_FS=y
>   CONFIG_SLAB_BUCKETS=y
>   CONFIG_SLUB_STATS=y
>   # CONFIG_COMPAT_BRK is not set
> diff --git a/arch/s390/configs/defconfig b/arch/s390/configs/defconfig
> index e00e252d4694..694a309377d5 100644
> --- a/arch/s390/configs/defconfig
> +++ b/arch/s390/configs/defconfig
> @@ -94,7 +94,7 @@ CONFIG_UNIXWARE_DISKLABEL=y
>   CONFIG_IOSCHED_BFQ=y
>   CONFIG_BINFMT_MISC=m
>   CONFIG_ZSWAP=y
> -CONFIG_ZSMALLOC_STAT=y
> +CONFIG_DEBUG_FS=y
>   CONFIG_SLAB_BUCKETS=y
>   # CONFIG_COMPAT_BRK is not set
>   CONFIG_MEMORY_HOTPLUG=y
> diff --git a/drivers/gpu/drm/ci/arm.config b/drivers/gpu/drm/ci/arm.config
> index d7c51670da2f..fc0a8a4bfb18 100644
> --- a/drivers/gpu/drm/ci/arm.config
> +++ b/drivers/gpu/drm/ci/arm.config
> @@ -5,7 +5,7 @@ CONFIG_CRYPTO_ZSTD=y
>   CONFIG_ZRAM_MEMORY_TRACKING=y
>   CONFIG_ZRAM_WRITEBACK=y
>   CONFIG_ZRAM=y
> -CONFIG_ZSMALLOC_STAT=y
> +CONFIG_DEBUG_FS=y
>   
>   # abootimg with a 'dummy' rootfs fails with root=/dev/nfs
>   CONFIG_BLK_DEV_INITRD=n
> diff --git a/drivers/gpu/drm/ci/arm64.config b/drivers/gpu/drm/ci/arm64.config
> index c46125c1f80f..10b01b55a66d 100644
> --- a/drivers/gpu/drm/ci/arm64.config
> +++ b/drivers/gpu/drm/ci/arm64.config
> @@ -5,7 +5,7 @@ CONFIG_CRYPTO_ZSTD=y
>   CONFIG_ZRAM_MEMORY_TRACKING=y
>   CONFIG_ZRAM_WRITEBACK=y
>   CONFIG_ZRAM=y
> -CONFIG_ZSMALLOC_STAT=y
> +CONFIG_DEBUG_FS=y
>   
>   # abootimg with a 'dummy' rootfs fails with root=/dev/nfs
>   CONFIG_BLK_DEV_INITRD=n
> diff --git a/drivers/gpu/drm/ci/x86_64.config b/drivers/gpu/drm/ci/x86_64.config
> index 7ac98a78691e..8225b806dad8 100644
> --- a/drivers/gpu/drm/ci/x86_64.config
> +++ b/drivers/gpu/drm/ci/x86_64.config
> @@ -5,7 +5,7 @@ CONFIG_CRYPTO_ZSTD=y
>   CONFIG_ZRAM_MEMORY_TRACKING=y
>   CONFIG_ZRAM_WRITEBACK=y
>   CONFIG_ZRAM=y
> -CONFIG_ZSMALLOC_STAT=y
> +CONFIG_DEBUG_FS=y
>   
>   CONFIG_PWM=y
>   CONFIG_PM_DEVFREQ=y
> diff --git a/mm/Kconfig b/mm/Kconfig
> index afff1b25b543..4a77cda7f1d7 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -130,15 +130,6 @@ menu "Zsmalloc allocator options"
>   
>   comment "Zsmalloc is a common backend allocator for zswap & zram"
>   
> -config ZSMALLOC_STAT
> -	bool "Export zsmalloc statistics"
> -	select DEBUG_FS
> -	help
> -	  This option enables code in the zsmalloc to collect various
> -	  statistics about what's happening in zsmalloc and exports that
> -	  information to userspace via debugfs.
> -	  If unsure, say N.
> -
>   config ZSMALLOC_CHAIN_SIZE
>   	int "Maximum number of physical pages per-zspage"
>   	default 8
> diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
> index 7ef80e0da626..104ccf3aa170 100644
> --- a/mm/zsmalloc.c
> +++ b/mm/zsmalloc.c
> @@ -222,9 +222,7 @@ struct zs_size_stat {
>   	unsigned long objs[NR_CLASS_STAT_TYPES];
>   };
>   
> -#ifdef CONFIG_ZSMALLOC_STAT
>   static struct dentry *zs_stat_root;
> -#endif
>   
>   static size_t huge_class_size;
>   
> @@ -279,9 +277,7 @@ struct zs_pool {
>   	/* Compact classes */
>   	struct shrinker *shrinker;
>   
> -#ifdef CONFIG_ZSMALLOC_STAT
>   	struct dentry *stat_dentry;
> -#endif
>   #ifdef CONFIG_COMPACTION
>   	struct work_struct free_work;
>   #endif
> @@ -565,14 +561,10 @@ static inline unsigned long class_stat_read(struct size_class *class, int type)
>   	return class->stats.objs[type];
>   }
>   
> -#ifdef CONFIG_ZSMALLOC_STAT
> -
>   static void __init zs_stat_init(void)
>   {
> -	if (!debugfs_initialized()) {
> -		pr_warn("debugfs not available, stat dir not created\n");
> +	if (!debugfs_initialized())
>   		return;
> -	}
>   
>   	zs_stat_root = debugfs_create_dir("zsmalloc", NULL);
>   }
> @@ -650,10 +642,8 @@ DEFINE_SHOW_ATTRIBUTE(zs_stats_size);
>   
>   static void zs_pool_stat_create(struct zs_pool *pool, const char *name)
>   {
> -	if (!zs_stat_root) {
> -		pr_warn("no root stat dir, not creating <%s> stat dir\n", name);
> +	if (IS_ERR_OR_NULL(zs_stat_root))
>   		return;
> -	}
>   
>   	pool->stat_dentry = debugfs_create_dir(name, zs_stat_root);
>   
> @@ -666,25 +656,6 @@ static void zs_pool_stat_destroy(struct zs_pool *pool)
>   	debugfs_remove_recursive(pool->stat_dentry);
>   }
>   
> -#else /* CONFIG_ZSMALLOC_STAT */
> -static void __init zs_stat_init(void)
> -{
> -}
> -
> -static void __exit zs_stat_exit(void)
> -{
> -}
> -
> -static inline void zs_pool_stat_create(struct zs_pool *pool, const char *name)
> -{
> -}
> -
> -static inline void zs_pool_stat_destroy(struct zs_pool *pool)
> -{
> -}
> -#endif
> -
> -
>   /*
>    * For each size class, zspages are divided into different groups
>    * depending on their usage ratio. This function returns fullness
>
> ---
> base-commit: fa4ad798f6f681031775266044ba1b0cf3c670bd
>
> --
> Best regards,
> Xueyuan


