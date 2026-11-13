Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3D67606A32D
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 04:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=eW4/5B6W
Received: by kanga.kvack.org (Postfix)
	id CB1116B067D; Thu, 12 Nov 2026 23:25:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3A7C6B067F; Thu, 12 Nov 2026 23:25:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B038C6B0680; Thu, 12 Nov 2026 23:25:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7C0486B067D
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 23:25:34 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DEFC41A0676
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 04:25:33 +0000 (UTC)
X-FDA: 85428806946.19.B9D1937
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	by imf26.hostedemail.com (Postfix) with ESMTP id C58C2140002
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 04:25:31 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="eW4/5B6W";
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.41 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794543932;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IkIvwF8HYTYAvXNQ1Vf3vJhW/UWoUX7BTMENFsGTE9A=;
	b=VXgihHhcnF5Aj96uh2s7PQbXok36/CMQBZ0VtfVHO2bWsUAUhi071nS8CxztOXntm/dX1W
	jotzj2JmKCFSDVdPt/tUK12qy/eMjbBaCaQkTjvR5opnz4wD74MWwU9tN9lRunTfRVgJGn
	Wu7z+A1Q2dZ6ANbay2phRWH033HtfJA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794543932;
	b=Atc3/1vstiWLruMjMPkHOYB+9FDT8RKlbYAhSTTgkE3VrYo4jO3VpbvlKV5MqL178mM5KG
	r83+3tD74dwctXndM5pp93SizubYxm6uSP6IsVmJms8pNHUdDTaFx+Zy4z79a7GBGnC8XP
	jII25WIwB/EI2u3JSXaC0yJCtcl/aRg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="eW4/5B6W";
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.41 as permitted sender) smtp.mailfrom=gourry@gourry.net
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-91ccfb88e4dso12609646d6.0
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 20:25:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794543931; x=1795148731; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=IkIvwF8HYTYAvXNQ1Vf3vJhW/UWoUX7BTMENFsGTE9A=;
        b=eW4/5B6WPdCrNjV828HvMqcXZu9SDaLoZWIOlZsjYSH8EA7+FqshryRQSV30WivMih
         u73IY53a/2Xy8qMpLp9DtnWjkivLOrsadPI43E9T8KBX6eA7uhVrm/zHmmPPjfA2vdAv
         ET5WD4zEW0UlXSMKCpI5x3Frj2+qw/Zg88MGvcnZJXubMzCYQkC+isLpIVXtdhTL0jMd
         yXYEbA4AkjgwjpinCXhxRfYAdVehlx8e/fkik7JpbZWgFdif4doNveH9E9aAuRs/2X70
         I9OJ6N+D29KHfzGkG7MgIRmmVSXCaUeuj6Yp1cJ5Syd3tfWf1B/4H6Q/kklAHp+52jGX
         A1jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794543931; x=1795148731;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IkIvwF8HYTYAvXNQ1Vf3vJhW/UWoUX7BTMENFsGTE9A=;
        b=GquV2BsFwR1FwFYj2311iAaPtlPxqUeJUw/XWxURObsVgZBRSJjBj2EKU9E6QUgwkJ
         +n3FrBjgF+o0mf0DaUg+gDNMb1vgmaAJcwles1MBXBeZ9q1xK5b0hHSrUxZ78fWhswcc
         8y5SqBcp0vFcVseOo3+EGk50/jm/yqHQ6XNUlSmdlHj27eBAZ4psY5PBHYvT9kuZ5tpR
         hiPkYtU7G/woPUuTOCev/Cxt7rfe0ss348GJCRgJbc60dhH7cwoXLlVxn3v8wiJkb6/G
         630cUnBpZcdUyyELSbyED/y33+SLcgfeeDlGSbP/tOlxrTyNww1VTfUkoyPHaZenK5qx
         57YA==
X-Forwarded-Encrypted: i=1; AL+hErEQHTSrNeis+HpU+VpjV1Ea0pZ8cAzLMsR96U7cNfjMUIVWcBe3xp7DHjyIEKIyVteWUPHeMmxW+Q==@kvack.org
X-Gm-Message-State: APuU4Z8gYYqttm388f6UAnaIsRv359rDWbRfK9NJUE7cyAysBhkMYrPY
	AJQeZlpkwpRpGWcFky6tyZ7dxMss5cw/k1oEEoiG2TiUXQP2AOajTXjrxrX0SIPkLadGY3lQr/I
	oQ2EN
X-Gm-Gg: AYBFou3Zs67ofSMryUbzi8kawIqz5lAGtc/pHalDfWXd4u4Pi4eLCB3enJEUKT5q5H1
	xSggoBX7c7LnLhJNecWkQcNkCeeTaPsoRcnB7T1d0S89olNF4wUjtfBTi8wQ7DzYAGxCmTQC5oc
	8FzvOEoCS6YKbIJCj/0e4lXBgZDwIiUrycGMHqr5EHd0Bfh7d2jBel0DwO1eQZUlLZs15rI4tpv
	/7m1tJGdaoYAcGtQ182QH9uqzEoCBGUjdwOecygfvD/B6XTUPbl71z3SiWBTzbaU+CZYguPivoO
	JrQVDv0YqXNE/RuttTPwYzEGDP+74MTyDzzxLOirbJBnadC6xro+ug0dIlcdJtLLvaN+AQYOo2t
	z61AdmP4HEwa8YHoAHPIO/Nhkyla3Uz05PmtPPyYf+dhI3O5fXcoPHV6qnk5kzdyiDR9/iTqA3Z
	j9C24SwEZcfYIWidKKSv3Z0fNf7gUCp395FdVpmb9BGzJQrFiubI7epKKAmsYRtdKN9/vID7Jf4
	atEXh8+nqpxXd9nvBqyh0Nl+oqLupVuRfXiDY9M8wczzJMbCtXPMjkYLf3hkpndVfa7zePMVQew
	uh9+mQCR2sbiKyY0B4SqxjmtufijZcckLSbVL8+BohgWPOZ8Zfj5Df4Ua+yXB28oEP7HeUAYHlb
	yYa8fT50=
X-Received: by 2002:a05:6214:2f03:b0:91c:aadc:5725 with SMTP id 6a1803df08f44-91f241e0e43mr23498046d6.34.1794543930772;
        Thu, 12 Nov 2026 20:25:30 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91f23d458fdsm11668876d6.9.2026.11.12.20.25.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 20:25:30 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 02/12] userfaultfd: refuse UFFDIO_MOVE into a
 non-present huge destination PMD
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Mike Rapoport <rppt@kernel.org>, Peter Xu <peterx@redhat.com>, 
 James Houghton <jthoughton@google.com>, 
 Andrea Arcangeli <aarcange@redhat.com>, 
 Suren Baghdasaryan <surenb@google.com>, Balbir Singh <balbirs@nvidia.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, 
 =?utf-8?q?Micha=C5=82_Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>, 
 Andrei Vagin <avagin@gmail.com>, Stephen Rothwell <sfr@canb.auug.org.au>, 
 Arnd Bergmann <arnd@arndb.de>, Muhammad Usama Anjum <usama.anjum@arm.com>, 
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Chris Down <chris@chrisdown.name>, 
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 =?utf-8?q?Miko=C5=82aj_Lenczewski?= <miko.lenczewski@arm.com>, 
 Michal Hocko <mhocko@suse.com>, Mike Kravetz <mike.kravetz@oracle.com>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
In-Reply-To: <20261111-uffd-state-fixes-v1-2-00713d368976@columbia.edu>
References: <20261111-uffd-state-fixes-v1-0-00713d368976@columbia.edu>
 <20261111-uffd-state-fixes-v1-2-00713d368976@columbia.edu>
Date: Thu, 12 Nov 2026 23:25:28 -0500
Message-Id: <179454392848.482102.8479698323718468757.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Stat-Signature: b7r3n6k9gjxw7cp6ej33z7xr6zrm6rgt
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C58C2140002
X-HE-Tag: 1794543931-486659
X-HE-Meta: U2FsdGVkX18Uqen68mND6bPFbYRNzJ3IWQiFsBEkbwT2s+Fx0aAdKdnbKDRNRoyDN85z7NlCL6A0FvH5pdZ3kKL9WtXvB47EJ/Kt4GGAUzskKaCdByZIrOM39oA8waQewOl9e/cXQEiE+FbS+mrj6OScQy8HPlIlg9KGGi+hHd9fEJ6MuZjpW2drA0y0zaLQaAEYBM1MshrTb2jfpjTIUlZX3A+/eekIfC+R+z2bjgdeKxNcGhVZi79O3xtQL3vFnXsqZHf+L0LVITTnl2V02uMcNrkchlDx+5c/49pHx7Xc3HFlcnuqIn9P/L8XQ1txEPlYfwK55v9OhLzHdxcOmxCn9FYMGBFlC48gppbfbiEBTB/Epe8JCEsnpuDfDr91qDVUfTe5MmAtOLyxz2sjLD5QGiPTQ9A6k+t4kUB58bpMjJXunYOYRx/RR5SN11jix6OlniwfGcraKfQMItsKwupuOL5i96tStErwYblCevbVE6yiwjMwH8u/VDGAVKD8Sb9r8gagGcIaKeJx5d46jCer2PCQl1ocBtZTK3nhWGsRxu8uAEvvBK4BEB7GL7q8NB8rX3vx+2PoCK5Nks1+z4aMB2wWgwjsARSNcO7jsW5G22SrJ2dEtcunNXokZWlKm7jay6iesHqU5/+YsOwCoTbPnmo0lvqgx3QSmm2ov4GGpvKfm0cj2FqqWF7S5mlrUm5civZPRQiRMguFLEbmn05+5UcRCGHap6YMyf3aiILf87sGcri9keSbsUAyRNuy7PiBNp06Jfu0VfMwDeUbtaRdrc/FK00eDviOUZiCqjv/ym2ZUO5NeEoocBWYSz7tlS3PJ3UB3UiCItG+la/XVPejKYD1Rf6gqqY9pt1TMYS9xP/ho1w1j3NnsEqoAG1I+kor8z/AbuIAetKWAoFblhHuNG5Gya7jgLQXuBV5X24OrYXAJlyWC/Fu1+JXMjyBBx8NH4iB6BJNljjGuIK
 y88B4EeL
 lwSBdc1X+0/Y44Vjfe59ugCM3upphKQGtjz6rb/Qw4PV2UM1p+y+ZzVr/W4CNk28XvG3om/dlYul7TtkObDThkncxEuR1JOpAg3Ww2EDZpxvdrxoBcG0+RV3oNKLLTryFJfpTUETeajvdntaLeXLRRH0zmaiHZRYu4gk+R5mht5bVfZ232b7dtQkUQi6sd27VL2llxiep0IfhVRq/VSMZxXX/N1F9y6QX9lzuzErYG4akrNVZ0TRd8xH06cuIM1ejv0L7vInRTSjHf397p+8sNpDZyYDPRNjjHtwjho8uDF2xAb6cIz7e09eoVVTTcOcv0wQ6KQt433RkWoVnsI+K4QEGFzsUwFlmjiGFKaaMb3Ix1epTrBhNKdmc7cPPYroYT4gb5m8GkwWf/Zm+uXb6Sxl+uX4wHUc1AEc/0Wwh5hw2gZPYPCoq3kRmMcJVvz5pI51OM/plqLZdpWA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-11 12:55 -0500, Tal Zussman wrote:
> move_pages() refuses to move into a destination PMD that already maps a
> THP, but checks for that with pmd_trans_huge(), which is only true for a
> present THP. A device-private THP or a THP under migration is a
> non-present huge PMD leaf and is not refused.
> 
> The destination PMD is then treated as if it pointed to a PTE table. It
> is not empty, so pte_alloc() leaves it alone, and move_pages_ptes()
> fails to map a PTE table from it and returns -EAGAIN. move_pages()
> retries on -EAGAIN, with both VMA read locks held. If the source is a
> THP, it is split first for nothing.
> 
> For a THP under migration, the loop ends once the migration finishes.
> A device-private THP can remain in device memory indefinitely, so the
> caller of UFFDIO_MOVE hangs until it receives a fatal signal, and
> anything in the mm that needs to write-lock one of the VMAs blocks along
> with it. This requires a driver that migrates THPs to device memory.
> 
> To fix it, check the destination with pmd_is_huge(), which is true for
> any huge leaf, present or not. UFFDIO_MOVE now fails with -EEXIST in
> these cases, as it already does for a present THP.
> 
> Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
> Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone device pages")
> Cc: stable@vger.kernel.org
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>

-- 
~Gregory


