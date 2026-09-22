Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70DDCC982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 12:51:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 762816B00AF; Tue, 22 Sep 2026 08:51:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 739E36B00B0; Tue, 22 Sep 2026 08:51:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 676E66B00B1; Tue, 22 Sep 2026 08:51:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 451C66B00AF
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:51:50 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CC0EE4034B
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 12:51:49 +0000 (UTC)
X-FDA: 85241385138.03.7E30CD6
Received: from mail-ed2-f35.google.com (mail-ed2-f35.google.com [74.125.228.99])
	by imf23.hostedemail.com (Postfix) with ESMTP id E57B7140004
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 12:51:47 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jznpxOnR;
	spf=pass (imf23.hostedemail.com: domain of richard.weiyang@gmail.com designates 74.125.228.99 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790081507;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G0pT1Bz/Ukk2yKj9z6fcgefhEfOADcNNQjef2vknbn4=;
	b=OI5dwT/oV9JhojkdCryXPe3q0zD7S2WDSBMuJxxynm2n58PpW1yPoFnr5007JXyXZxyIAJ
	YRuMaPs0rXG8dLXQe302+F0Tv3rYzv4ED5bNPAfYJxjZe0zSoyty/4U55Vl5dI6s7tuxeP
	HvChTAF+MlYs883hOEYizXzMvsA26sg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jznpxOnR;
	spf=pass (imf23.hostedemail.com: domain of richard.weiyang@gmail.com designates 74.125.228.99 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790081507;
	b=TrgfcDf1GihWjmKS5ZOxdC6klSlnePLQmnlyyPLhXitamUYKfeaxBSRklkix47u5ZdXZiU
	DOZqJh6jN2uMFfo306RJNaHFdzBurt44Gvp25jkMP9cuH7cKj6mYsjO17O/SqdQOdQkcEN
	+WgGhROPk85L3BstjDJzuw+pukZ0VH0=
Received: by mail-ed2-f35.google.com with SMTP id 4fb4d7f45d1cf-6aa1d00daaaso7104846a12.1
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 05:51:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790081506; x=1790686306; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:reply-to:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=G0pT1Bz/Ukk2yKj9z6fcgefhEfOADcNNQjef2vknbn4=;
        b=jznpxOnRqtX1zP4w916A93xuXJuGa1LnKXRnhNp9GeC3E6IHmhVkPCREiQ3NACVb8V
         hrCShUwQigKpeVhaNP1iJBcSc8sM+IzWklvknwWc9B/kqBafwx3W+NP35Vg3wC8CMy9J
         eSEX9hF0Laka1bzRAebikfH9FrTyrzyMHSOJYYxbJzqSLjFWTSxWA9HS7AjqhvmfI4Vh
         NBLIfGXUeT6t+4Q220vN1zBQ/elMmM2ctsLalhYmiiAfUjWS+5w91mkwsFJ1XpoAd/Ru
         eBWW6ZxoORBvcsbJiVRZTd8NJjK+yIScnuXHoTJ/LWfSkgMqrlzk5zp0RpPPp7mlhRPf
         kqXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790081506; x=1790686306;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:reply-to:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=G0pT1Bz/Ukk2yKj9z6fcgefhEfOADcNNQjef2vknbn4=;
        b=gIMtKK0wp/wXYOMoCZGK6ItWAjOfAMy0CegANEeAPZBGDeLhDGbBLnMlEQAwul6AqP
         xOgJQCEIR43Xpl+EOVhBm0UDZRfnejrzTiMD6XJLaVdfO37JbmnV/J2l/8j8JkXGxOl4
         WiB64qCPu/GRufu1xRXHd58a8nFZXKKcKtsx/EnG8ArG7+igoL6uIhb18GFDQwN1MnR9
         7rB5jYbrCjJh7/AmVltKXDhI/9Ybf+wm8U20i0JmaUrwdHUkCFIFpEwMbhz23oXVsd/I
         k+VKVFFLZmd50XiU2+ELRZYhJZbpC71dZ2RbFm+qbdZVxgGl/GaQzKKOtyazGd7hk71M
         q2mQ==
X-Forwarded-Encrypted: i=1; AKwUvBzNwez7ISY0gmkQ8JNTQjUcFpdaE0nRYTmg8nOijlUrFY9YRgRPDtq49Rdn/PXj0wTFM8uplEo1DQ==@kvack.org
X-Gm-Message-State: AFuF++kGBWnXOCvmaDGYC+pIWhf+0t+RiZMw3c3zhCtp+mfOmS8Y8sf8
	w2euq84LaLhSSjONCfsAIhNCfguOw5WSNxB/lqqvSn0PmDrWcyyNYMvD
X-Gm-Gg: AYBFou1zP94qq7iW4H/1ubG6410LqGl2RfOst3WyaFO2hC4m9DnnT7ROnarTWdlOOYa
	MTAfdLus6cw0DFFLz/Z8m5nsvTamvUWKGbE6V/hlEtqOIpy+bQ+6NHGzSRgKyNfI2hO5OOhsndB
	AdO5ih9SgrmtOxV3AwfIO5m6Q2rFL9cibtFwUpJX2NdyfAKP+lOIlsy0vGye1O9BnEr0A1ZA6sC
	LavcGaqeyqsZe6yNty2qt1Lez8AHMvraK9mn7OykiQEtbLRJPRBQSaFhkY0SSr95GgIy4zzh6pU
	Sn/ijGhV6MJFkkcnmpg2NMvQJM3MlvBs6tOaugOA31VsYYf+saAZyWqR8XeywHbKtbKTDAawgRT
	F3SyWUUXqbsLs4QSLRhcvQ7K0+zgTjnHkRy+tBwLSnHjPbXUSdeUu3kOOeRhAAK4g1CxVFLjknI
	Yw545kxZrQt2yclbumWSRW7ubgOz/WCge8pSP2Nc5PHJgz6UbnoNgjMePH/dPluMR+J5Og
X-Received: by 2002:a05:6402:1d4f:b0:6aa:9823:218a with SMTP id 4fb4d7f45d1cf-6aa982324cfmr3582241a12.31.1790081506095;
        Tue, 22 Sep 2026 05:51:46 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6aaa4537b5dsm1073668a12.30.2026.09.22.05.51.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 22 Sep 2026 05:51:45 -0700 (PDT)
Date: Tue, 22 Sep 2026 12:51:45 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Yuan Liu <yuan1.liu@intel.com>
Cc: David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>, linux-mm@kvack.org,
	Nanhai Zou <nanhai.zou@intel.com>,
	Chen Zhang <zhangchen.kidd@jd.com>,
	Jason Zeng <jason.zeng@intel.com>, Chen Yu <yu.c.chen@intel.com>,
	Pan Deng <pan.deng@intel.com>, Tianyou Li <tianyou.li@intel.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 2/2] mm/memory_hotplug: optimize zone contiguous
 check when changing pfn range
Message-ID: <20260922125145.3fygpy7gxoztsa3n@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260920084946.3266279-1-yuan1.liu@intel.com>
 <20260920084946.3266279-3-yuan1.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260920084946.3266279-3-yuan1.liu@intel.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E57B7140004
X-Stat-Signature: 5jtmdi6bcrt6a17biwknxx5frwwyguok
X-Rspam-User: 
X-HE-Tag: 1790081507-987937
X-HE-Meta: U2FsdGVkX19cOucVTKtQQkGswFW3EX5RWF6IJmAiFL5bQzqexZGvhwmwUBYFmNs+7sQpBiC8v6Wa48OgjZqITt7Ab0e7WeN1mGm8FixUm5XnUr+3a5tS9AoF9HfIZp1jPkQJj5KWulLEI3yGiE43+31GPDYaIdEkmC+O+ecPCVVOKKkzIpud7ThgKrsVV7dqqajLSC9J7lxaeH7U0+1TDJxNqnhMk7k9SdUuSWghaeSpSDniqHY1hQTRjrvPje5GERRDpJl8vvm481dtgjU6yR0wOuF9RY9vuU44AazYFJkpZH+TB5YyMVnjQONQzobZgkuzoORK6lY0mRmcQxa+dpy6+b1XM4+652v7b85puiXscs3vkHFISNbU+GdMuH92vwe7ZdTUIe0JmLnuOEaxLGItBJEgLBdgQpQtWdoGuQE2888UZo0CdVWIIHtrhBcxNHUlhdx3vntQsdVOGUty1hd9Zo3NqvywQygsoPIb4wNmuk6KAKZHjuRcy2WCdFZBOB0D5DawAo5b8voFIymWihaLtXMPqOVGkJQ3dGn4L2dUSc6e00Q194p40SAZ+8Jey4Uvi0mNlD3QJ5bMTVeq6lSmnGIr887YXJScN+kbEGPkJp8U+6IwXpFbTgszDzSe2tkVJHEqZNrdC4IFOxJFCywzx0OxQnGV+tjswSLdoJW1Tb2Ul/up7b+EN0SytW6NsZBZSvaJIPEiFH+7TxrvfUu+Sni5Kjh0a3AsuOK+RKr7v/wcBntW2QtvmEGanyHcXcpafRBSil0P4JgyUsClmSb+nNZ+VPeihCZJM8MBaLNJGSjZx/6fb+wmtMKIl5Q2UaVbLdEDa1Cosa2G6Xb4rMoEGiLbphYo3TW4hSXbc93DJGLjb2kgjFFmglmR3siZkvwtt4haJ2hHAbT14BUImwdfoeUp8CxDI9s6ORB5JmFlWCg4/JmJNiKxQPWGZa9CrlG+zq1z2Q9VE6Bu3aE
 jOZmdJLt
 5CSDkWXoLu6scrxUciXd6TZBh/bJXGtU736YOJGsal8CTCHxRIh+SgBJC++zENkJs93rtk0D52CdVCCNB09UPcVqluYnsl32VmonNJObTDP603GbzlWkyKF9oteDcsaKYLaicnSMoB4Y75FW/voubSsgjG9TcBjoTN/xHR4JTmqV7WasERzdEthgGx5BrFZ4MrZt05BD99fCfvm3PSRvQVDXeiMSvw1kWlPnAuK568/4bWu/WElhPmtj3kkZgZJzjEko1I+X/ts0aS6c2QTNev7G4WTcWfl/1hyRJB/V/hneIeJgmzFb31TSj1b5RuDLjKee2PSlDBGI7JWBBSdMWopnLkx3Esa28YTycsXXeFwxf0KiGedHkR6j5qUvJ9WcptOHBG++37R9jrkqb4p/joFFpLcyYW4NgEOFs9VGnpYhdat353y72krVIMxfDaWaZ/Tk9Eor7J/zD9aub/xC7oETySjAgmyGqqvzLaRJWRxA0HVUyc/YBj53mbZmXUHCGB1K1bCQScs/hxZQz1XgTx7HJieV6Pc9Gf9GVI/R++dywatEZIGB8DrNFsB2h0qxB1pLUkOxa8mLieBigxd8h9T4kGDNkrd836huwycICJA2F5cRL7v8CncnsXRZSy0bmqYtnWw9JHZwPMOX4jcsMoM//sZFJ+v8Aq6qcVOstkmxmD3HaIo2MyPNRzxqo3xVWXbhK4z0dL0W9NDNEgJ2iKpTDR88lAO12dorWtT7Wcg1nKLkvYmNdQNckZDrMACpXGRVSj2XjqFAYX6X2tHrrCBChQs4GC1245C4fw6Ubb5p9a2oxKI0Tk1OzhABOYIryAuEb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Sep 20, 2026 at 04:49:46AM -0400, Yuan Liu wrote:
>When move_pfn_range_to_zone() or remove_pfn_range_from_zone() updates a
>zone, set_zone_contiguous() rescans the entire zone pageblock-by-pageblock
>to rebuild zone->contiguous. For large zones this is a significant cost
>during memory hotplug and hot-unplug.
>
>Add a new zone member, pages_with_online_memmap, that tracks the
>number of pages within the zone span that have an online memory map,
>including present pages and memory holes whose memory map has been
>initialized and for which pfn_to_online_page() succeeds.
>
>For early boot memory, pages_with_online_memmap is calculated in
>memmap_init_zone_range(). PFNs initialized by memmap_init_range() are
>included in pages_with_online_memmap, and hole PFNs for which
>pfn_to_online_page() succeeds are also counted in
>init_unavailable_range(). For hotplugged memory,
>pages_with_online_memmap is updated through adjust_present_page_count(),
>which is called during memory online and offline operations. When
>spanned_pages == pages_with_online_memmap, every PFN in the zone span
>has a valid memmap entry, so pfn_to_page() can be called for any PFN
>within the zone span without an additional pfn_valid() check.
>
>Note: this counter may temporarily undercount when pages with an
>online memory map exist outside the current zone span. Such pages
>are only created during boot, when initializing the memory map of
>pages that do not fall into any zone span. The undercount itself
>can only happen after boot, during memory hotplug, when growing
>the zone to cover such pages and later shrinking it back, which
>may result in a "too small" value. This is safe: it merely
>prevents detecting a contiguous zone.
>
>Here is an example (page numbers are just for illustration purposes):
>  after boot:
>      [  zone span  ]
>      [   zone pages   ]
>      spanned=10, initialized=15, online=10
>      online == spanned  ->  contiguous
>
>  growing after hotplug (hotplug 5):
>      [  zone span                          ]
>      [   zone pages   ]   [   zone pages   ]
>      spanned=30, initialized=20, online=15
>      online != spanned  ->  not contiguous
>
>  shrinking after hotunplug (hotunplug 5 again):
>      [  zone span     ]
>      [   zone pages   ]
>      spanned=15, initialized=15, online=10
>      online != spanned  ->  not contiguous although contiguous
>
>The contiguity check using pages_with_online_memmap is stricter than
>the old pageblock-by-pageblock scan. The old set_zone_contiguous()
>iterated at pageblock granularity via pageblock_pfn_to_page(), so a
>zone could be marked contiguous even if a subsection-sized hole
>existed within a pageblock. The new check requires
>spanned_pages == pages_with_online_memmap, meaning every PFN in the
>zone span must satisfy pfn_to_online_page().
>
>The following test cases of memory hotplug for a VM [1], tested in the
>environment [2], show that this optimization can significantly reduce the
>memory hotplug time [3].
>
>+----------------+------+---------------+--------------+----------------+
>|                | Size | Time (before) | Time (after) | Time Reduction |
>|                +------+---------------+--------------+----------------+
>| Plug Memory    | 256G |      10s      |      3s      |       70%      |
>|                +------+---------------+--------------+----------------+
>|                | 512G |      36s      |      7s      |       81%      |
>+----------------+------+---------------+--------------+----------------+
>
>+----------------+------+---------------+--------------+----------------+
>|                | Size | Time (before) | Time (after) | Time Reduction |
>|                +------+---------------+--------------+----------------+
>| Unplug Memory  | 256G |      11s      |      4s      |       64%      |
>|                +------+---------------+--------------+----------------+
>|                | 512G |      36s      |      9s      |       75%      |
>+----------------+------+---------------+--------------+----------------+
>
>[1] Qemu commands to hotplug 256G/512G memory for a VM:
>    object_add memory-backend-ram,id=hotmem0,size=256G/512G,share=on
>    device_add virtio-mem-pci,id=vmem1,memdev=hotmem0,bus=port1
>    qom-set vmem1 requested-size 256G/512G (Plug Memory)
>    qom-set vmem1 requested-size 0G (Unplug Memory)
>
>[2] Hardware     : Intel Icelake server
>    Guest Kernel : v7.3-rc3
>    Qemu         : v9.0.0
>
>    Launch VM    :
>    qemu-system-x86_64 -accel kvm -cpu host \
>    -drive file=./Centos10_cloud.qcow2,format=qcow2,if=virtio \
>    -drive file=./seed.img,format=raw,if=virtio \
>    -smp 3,cores=3,threads=1,sockets=1,maxcpus=3 \
>    -m 2G,slots=10,maxmem=2052472M \
>    -device pcie-root-port,id=port1,bus=pcie.0,slot=1,multifunction=on \
>    -device pcie-root-port,id=port2,bus=pcie.0,slot=2 \
>    -nographic -machine q35 \
>    -nic user,hostfwd=tcp::3000-:22
>
>    Guest kernel auto-onlines newly added memory blocks:
>    echo online > /sys/devices/system/memory/auto_online_blocks
>
>[3] The time from typing the QEMU commands in [1] to when the output of
>    'grep MemTotal /proc/meminfo' on Guest reflects that all hotplugged
>    memory is recognized.
>
>Reported-by: Nanhai Zou <nanhai.zou@intel.com>
>Reported-by: Chen Zhang <zhangchen.kidd@jd.com>
>Tested-by: Yuan Liu <yuan1.liu@intel.com>
>Reviewed-by: Jason Zeng <jason.zeng@intel.com>
>Reviewed-by: Chen Yu <yu.c.chen@intel.com>
>Reviewed-by: Pan Deng <pan.deng@intel.com>
>Co-developed-by: Tianyou Li <tianyou.li@intel.com>
>Signed-off-by: Tianyou Li <tianyou.li@intel.com>
>Signed-off-by: Yuan Liu <yuan1.liu@intel.com>
>Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

LGTM, thanks for the effort.

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

-- 
Wei Yang
Help you, Help me

