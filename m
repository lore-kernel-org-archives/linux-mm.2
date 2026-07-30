Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E61D3C54FD2
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 03:32:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93C5A6B0088; Wed, 29 Jul 2026 23:32:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EDB26B008A; Wed, 29 Jul 2026 23:32:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DC8A6B008C; Wed, 29 Jul 2026 23:32:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4EA2A6B0088
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 23:32:13 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BCAC3C0839
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 03:32:12 +0000 (UTC)
X-FDA: 85044019704.26.A1144CB
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	by imf16.hostedemail.com (Postfix) with ESMTP id D290B180003
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 03:32:10 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ARQGLKKe;
	spf=pass (imf16.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.47 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785382331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HJ2tPnxbrcFKcFZzwn864hCbrfOqlBJ/Hk+311dwGeA=;
	b=uNos783yLtJzm0pojN7JT/luDjZ0ubNnW4q9ZurWPwVW57uwHKzLMc642Cuj56VaS2lrsp
	9H75dD4P2qkdumIc8IyKTX5GANCQRKAA7+iQ2pqvQz/ehC6/WRYbFmb59TD9/35GsyB+qe
	WLigzksurn3So006kw8A7qxbki9BZsE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785382331;
	b=jwCjQTgQVSu7WewZ77fQzPSoGft0nSsZAx4zxxv9nWMj0zWloB/qvl04/AakaYoxQx+Erw
	KDIpzPIXBdXoeN1/TKxgR4bJFXDe6HhESG56TuNBcizoaqT5yT6AKmSuVpAcyDF0DfJaZC
	QaRkQWErgQ58Q8NAYNQ+/C6MJraBlDw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ARQGLKKe;
	spf=pass (imf16.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.47 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-8f29ec73064so11183166d6.1
        for <linux-mm@kvack.org>; Wed, 29 Jul 2026 20:32:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1785382330; x=1785987130; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=HJ2tPnxbrcFKcFZzwn864hCbrfOqlBJ/Hk+311dwGeA=;
        b=ARQGLKKe8qjF9JKO+qBpI6TxTuK2EXUdnEmID9veCmNWUWHTNw4DTcTXDZ0uREu5qG
         sKUsb2D6Nais5by2xc3BmVTMxZOHdvhdgV//GGVIcYy5zhN/dH61H2rFWMTqvOVOaxgM
         WYah0Bo/ONzyIj2E9/H9vbWRM4CpBE/yOOodTXL+WQGCY1dvlcT+ZFKWIOemgX63wbGe
         9M6v75jhQyJM7Y6IZh1rs7LBoAqLpuPsh6Nb+D87GSQa39IKBTnHGIZfnPuNh6twKau4
         BtEn4L/orKZBRXHjz0w8eUPqQMl2k/lAwCstdRrrzX6nXO+7C0Li4K3g1XXlGkzoqj8E
         KTlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785382330; x=1785987130;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HJ2tPnxbrcFKcFZzwn864hCbrfOqlBJ/Hk+311dwGeA=;
        b=cmzN4rTC4rWKKoWv8jZvViF+hOyjDJr/QZIxwj8FkE7TzZia6hbDfMFfWubcF3I09g
         sShr6/IVWSu4YcFwJ9k2rm973epa3eK8k6kRmmXAaC+l/T80chSgV++XMGf9fwM1Dr8P
         vj28Tpr4n3G7Apk8bNt4RhNKgAVc/EH7ZwFcsjqPXd1noQdUXJkwrrf1YXy/R8SadkTp
         ckYATprnJmVX6X77ewqLloa5C7konrKd7ieOF+ezb30I2Lf/Ne0VxL7e0++Ep+x0jB2a
         X+jiT/k31lDTOUqq+YcKMNVLE2Vz11/DoFdQqkGxA24gO+spVTGr4cucsOYgOpF7tfz6
         7pcQ==
X-Forwarded-Encrypted: i=1; AHgh+RpNOskRzeMURDXsByY6VRaIU7bBX1ASiyv84QYmgM5YDzN5pjmluXeDWF8iyQuvBIUJABkgsXEo6A==@kvack.org
X-Gm-Message-State: AOJu0Yx2/sk+UAVrvstFd53kbOqWw95RhGXljIAGAWJuVzfm/+AnaqI/
	L1FtLzhCOVAjDGxPuJ94uGBIfIghgXBCdyQ6knTTzmLFuv9LiYH98VThgWrk8hdOAKw=
X-Gm-Gg: AR+sD13eG0ZQxLPUt0cvtoBcwbwKPhkqOTa78pDPaWPGAiCsEdBHbJRXNtW6a7dbbaC
	nNEOGvHpqaJdi1Utrokuic/CO4AE4QpqI4fIQ5YEZEa0EkTWyyo6+Aakh56erhan+GqOVKwWe0H
	5RHQTDCtzV25fjzzdZjsyIE0UraoIcQOl/bzWyaT7eruNH/50x9V80T1UKiBcm7/loggPxWnOeA
	fuuRhOKXlVMHbyzCWTmK2zElszTHRBw8yuOBoXFNG8KKOxmxqyT1BYwuhzIcSTRadPado7OT4nh
	ikzfzy1TNAkvhdjtRid0+vDCIXnjvQfgcrUdkGbDuzw5pkzXwgEC3Zoguu5y3fD6ND4DMRczNqC
	T7auNF7V5XW5G2UDPwTw/nX/4i4ddjoeLVCwEeDrdBJHCQ2/BL8gN96xstCgSI1YigTMw7CcNd4
	1LFSlPvLKjx8nrh3cL51S5CPNxZ3bBSqGDCHdPqbofo4yXErYP2rbAqg7fix1YpkxBYFWInL8pE
	IDM5S9BPnGEYjQ+0MtiEbGiULK8WzuEiwuTPPezRqWv
X-Received: by 2002:a05:6214:3b88:b0:8ea:7785:f3e6 with SMTP id 6a1803df08f44-908347b2701mr8202616d6.42.1785382329952;
        Wed, 29 Jul 2026 20:32:09 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-908323eb01esm6949626d6.30.2026.07.29.20.32.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 20:32:07 -0700 (PDT)
Date: Wed, 29 Jul 2026 23:32:04 -0400
From: Gregory Price <gourry@gourry.net>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Kees Cook <kees@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Usama Arif <usama.arif@linux.dev>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Peter Xu <peterx@redhat.com>, Xu Xin <xu.xin16@zte.com.cn>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v3 01/15] mm/vma: introduce VMA anon page offset field
 and add helpers
Message-ID: <amrFcza2MxHb2cTX@gourry-fedora-PF4VCD3F>
References: <20260729-b4-scalable-cow-virt-pgoff-v3-0-e8ecfefea812@kernel.org>
 <20260729-b4-scalable-cow-virt-pgoff-v3-1-e8ecfefea812@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260729-b4-scalable-cow-virt-pgoff-v3-1-e8ecfefea812@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D290B180003
X-Stat-Signature: 9yejoxe1kxuuthyfeo4kbuontz9m74y9
X-HE-Tag: 1785382330-417765
X-HE-Meta: U2FsdGVkX1/GZpxjaxR7dNdJdTN3w7g6bPPJ1yv33s2GpOYDcvvU9nkvBXDWh+qZP2wiWhNsh7H1XWkQ0MeaDIEw5Wd1j17+5yIIfrgaJhhT84CfIy0/FDaLzfI/zaZ96PNXZuCzw6fs68F98WIJOEgwV8arjr9l5elMY116WFNrIlvSoLkqbvVlEwvsXYoRUESayaBTuTxaF0q9E8szk5EmzIClo9W+sW6WAmNMMC5T5qQ+Q2nUTVwvFERziYyusiNVwSiDOH4WwayCWvwtGXXz0usfmTUM10Qv5ZlKNQMAbtYMusaTZJgXa17+pZDCoszQ4eyRNiMOCNDix/faQreWIyV6L+eCXp65SC325CajxIvEraCRuOFDFZtYrnKUpQxCNTtJ76Wrj2nTP7nQfKvLG9OIWbri7elZ4QJ6i6CO2yq6TgVIZGG0Qf28rjD1r4e+scZkCPZwKEUj4V8tP5HsE1TBwm5T7eL4vT594xjhc5knieiLHVhJM/CS7hkX1QtuTi+pj33S/aEcLqDtCo3DB1nLUD8ZuMQCYlkw0+dsdwBNbgFzDvIi95nZ4omZ2UjQutKjlFV+VDlnttiL0KyVNAZTwEkzvzmvaI8DRD8NJYSDzFygB91JViLQKijPdfuxwH8+E81CmwcLY3eCjoJUqfPDgYdehb856U3ztThBiwPcZyusnPhtGYdRV8gK4sRqyGdAHNjrcVEPkbzzIEk0O/28iWrw9QsN3VZEzr1UajRsHKYYnhMHjZnqpoju28BpGw4UClK6XwPVTF2ODGtWeD0Yu67+RMn7tWOfyWhKKS9aKyrOLCe6+oyVVbxeCx8KeRN9b6TKbAT6jtEBVrCGleWzlF9/VA8dKMPdBd1WqBkHUXIK764rLDQ8B8OSHSZ1j9Hvk51fqrRoIWBj1dP4+K+Wha1PUUPKJXdwbPpHcSl3x2PAMJ6zKX1r6Eb2iGH8QOoh0G3NTWuXfdi
 wflKlN3x
 81WBOfa6zvBKQCBcutlsfINvqRpAODuLeEEH4ERUa9K3CTpchTstA8VfY/k/F5FLNzYVFTHQN/qQ6swuEn/OHVQAtWa0lJYhngQO0/VvQQkoVvTxzI6QqH4qivATZXkYppHk9qbX4rbdGvxBMVI3HX+46yikktatriANQFf+823Z65OKm+9jqRiG6GmZ0qHZvCa9qkWZoWVZhwxk6gNMntC/skD7QrlxK2zs/IwD9pzBZTHopUcNG14G/1kWhCprG79MHJHvZbvnSx/Ls4LuNdlQrpBu1S0FcRdj703OXmXQPt7qubShJbqNpo8Zvbv1Y3h/jTBcETZQcPm2o1YgR7Gsx0ItFwYHyUb6nVj8zdb1+tm/cnRUJuP1uDrcC498hf/sB08AygPno/J2wWfwrhte06pjBKj9G4h5Mk6KAzMV8BPIV2p70nj1WAWPyxMJ3amTvx0R0BLlkRFmvWDJYZ78KzZkvepzoCadQjCB/j2JpGJ4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 29, 2026 at 05:48:36PM +0100, Lorenzo Stoakes (ARM) wrote:
> This patch establishes fields within the vm_area_struct type to store the
> anonymous page offset of VMAs.
> 
> The anonymous page offset of a VMA is equal to vma->vm_start >> PAGE_SHIFT
> if they are unfaulted or were not remapped, otherwise it is equal to this
> value at the point of first fault.
> 
> Currently, anonymous folios belonging to CoW'd MAP_PRIVATE-mapped
> file-backed VMAs are tracked by their file offset. By adding anonymous
> offset as a property of VMAs, we can now track them by their anonymous page
> offset instead.
> 
> By tracking this, we provide the means by which to eliminate this
> inconsistency, and more importantly lay the foundations for future work for
> the scalable CoW anonymous rmap rework.
> 
> This patch simply adds the fields and some simple helpers. Subsequent
> patches will update mm code to make use of these fields correctly.
> 
> The fields chosen are packed in the VMA such that, for 64-bit kernel
> builds, no additional space is taken up.
> 
> The first field is present on cacheline 0 containing key VMA fields, and
> the second on cacheline 3, which contains file-backed reverse mapping
> fields.
> 
> Given the relative time spent accessing reverse mapping fields as well as
> updating them, there shouldn't be any performance impact here from false
> sharing.
> 
> Update the VMA userland tests to account for this change.
> 
> No callsites are updated yet, so no functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Much clearer :], appreciate the rewording.

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>


