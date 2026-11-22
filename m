Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11961606A320
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 05:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=G1ibACef
Received: by kanga.kvack.org (Postfix)
	id 102906B00EF; Sun, 22 Nov 2026 00:55:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B37E6B05B0; Sun, 22 Nov 2026 00:55:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE3286B05B1; Sun, 22 Nov 2026 00:55:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BF0656B00EF
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 00:55:49 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 982F81C1F8F
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 05:55:47 +0000 (UTC)
X-FDA: 85461693534.05.1EF2462
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 1AF881C0002
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 05:55:44 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=G1ibACef;
	spf=pass (imf21.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795326945;
	b=3zbMTbrPliT762JSPwsXRKZWb3ZSeYeQ/JiMfN5VjQeEcjQd6dW9T2ykz4O9zpyjHdu0kp
	Xg7c77UqX0q7fyerjZryVV1zvrFzENlMY9TiUiC0w5kWqvhnMfh1BP81/jmxZS1Y314+28
	4D/lYMuBHVuq24ARY6Hc2R/hGwOD55U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795326945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e5Q0HhQjroZ+Rc/PnGI9kGFEaaiyFgbKCtvuSXxJJDA=;
	b=7Uj+ln2yjLrqdbg1QLFPInFD9Xu0xaS+0StjYP++MIO2UVLFFyN0UYZcuvFOAN7axck8Az
	5W9H8d3t/YU9qpBXEFEvQpwFLgvdySlGx9NwprPy7Obhfol/ulKTLUTs/MAeMUHuDfzif1
	dZBvTzAsGqa2bn4ppwF0UQMYPRObBhU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=G1ibACef;
	spf=pass (imf21.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795326944;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=e5Q0HhQjroZ+Rc/PnGI9kGFEaaiyFgbKCtvuSXxJJDA=;
	b=G1ibACefBxCc4kjEfFDUXrWqftiSac5hx7mOelGSy35l/JWjJq6vrgSMukQlHXzHtkY8yq
	2irLO1pNrQQSRpTDiRJ3yxSVQ77V0pVYUjXA8ogTgMIGrEGPgrCUdCDHWunnrNNbm7dIhr
	KkU5EcC7hrqGNgIuUpxINQtz/cmq2rc=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-500-IYZEQiWZMLeGQy7fsVjw1w-1; Sun, 22 Nov 2026 05:55:41 +0000
X-MC-Unique: IYZEQiWZMLeGQy7fsVjw1w-1
X-Mimecast-MFC-AGG-ID: IYZEQiWZMLeGQy7fsVjw1w_1795326940
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-5c1ab3fe822so873821e87.1
        for <linux-mm@kvack.org>; Sat, 21 Nov 2026 21:55:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795326940; x=1795931740;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=e5Q0HhQjroZ+Rc/PnGI9kGFEaaiyFgbKCtvuSXxJJDA=;
        b=Y4uQMAH22uSBFLN0gPGOZL/3bzEXfrTHP8NBo05Cbn1elCC5t33kAhLk6S8OsAs64h
         pUVlP3shDzQphJHDwhrWeAQs56auI6N5Z43oVYi6oMyjPWWbd4pkdixweglHcvsmbhrU
         UurjbjONHxjQmWBzgCStzo1DqtNwHlw0XyA5u3IT6zw096uEE7AqFhUlMHsZi3/xwyWv
         uhGcOnZQuVXYQ+iPPcWmr/3mu0BaMKCIo0WHEgf+iWc8bDwdRjDvqciYYpnsYtVG794t
         +mGYoibs+3V9X/O3jNxu//s9uHtSkzYkgNKXDceuybpB7e2RXPX/GLfYUoT2uQs8rzCF
         rn2Q==
X-Forwarded-Encrypted: i=1; AL+hErHpjgZHnr6rgAIWRcyWQMEXOZGknYdJR3kIZz9QNfPf+8wiEzMFk1t1m0ISFwGYEfgrDN3SvnF4SA==@kvack.org
X-Gm-Message-State: APuU4Z8JrbvqOc2sRLQMT4NquV3F2T2kCoTUBJtB8/Zg/aUJ+N+2Ftvx
	7gmhOa7PPkXD1WRAfPViNH7gNVvPOzvJPytr8DIz4jla5G4y2TvzGsIe0Pl1TgXsDt6q4+6Cajc
	YHELaEZo8xp7iPOesrcd3PhJQrZ3g0yrugzHMum3qkYeOn9349Rk=
X-Gm-Gg: AZFdTZcHNRbz+3nftx34boH+fZai71xljBPS4VFAhkhI6Gl561IdSQK87V7aUUjq4fG
	R6tIwkU95kcvK8WM6Y53+fX8AE+Ca8EIsgNhALpCveNPmCzkbjYIG25gXAttcjScC3VBWc/g3c5
	m2AixwKjq3AFTVxH+Z3Lpc7kFQfhN/JmHVTCa0hOwAtsrL26cbvEuAXYE3zN+MJl5hLg0t+t9US
	7M212YTQXkgMdO/7oUGIAuT2ST1VubQlReaJDm2t3JFD5vaxgaJYwfzR3M7r4nlcxlIJsu1Ly+P
	scw/Ve95yQ6cPSB3MXsRQldQJn8XaBUlw/pJXDnKmimEz6ydw4hbrs2fBWotgqicU9QOHwDq+BP
	OCyyiVPFLo68jxNpuIhkA/ypmdx58n2/E2f9QtAqkINWUdu+JFrXS72Dn71PvdnS4EQVsYDbwL2
	0xG2BQ
X-Received: by 2002:a05:6512:1192:b0:5c1:a96d:911e with SMTP id 2adb3069b0e04-5c1b79fccd9mr2415287e87.5.1795326939881;
        Sat, 21 Nov 2026 21:55:39 -0800 (PST)
X-Received: by 2002:a05:6512:1192:b0:5c1:a96d:911e with SMTP id 2adb3069b0e04-5c1b79fccd9mr2415274e87.5.1795326939399;
        Sat, 21 Nov 2026 21:55:39 -0800 (PST)
Received: from [192.168.1.86] (89-27-86-246.bb.dnainternet.fi. [89.27.86.246])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5c1bd03bcdcsm1951038e87.45.2026.11.21.21.55.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 21 Nov 2026 21:55:38 -0800 (PST)
Message-ID: <36be0904-168d-4813-82ff-27ecced464e3@redhat.com>
Date: Sun, 22 Nov 2026 07:55:37 +0200
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/hmm: account for subpage offsets in device-private
 PMDs
To: Andrew Morton <akpm@linux-foundation.org>,
 Aveline Noir <jm5905938@gmail.com>
Cc: jgg@nvidia.com, leonro@nvidia.com, airlied@gmail.com, apopple@nvidia.com,
 balbirs@nvidia.com, christian.koenig@amd.com,
 dri-devel@lists.freedesktop.org, Francois Dugast
 <francois.dugast@intel.com>, intel-xe@lists.freedesktop.org, jgg@ziepe.ca,
 leon@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Matthew Brost <matthew.brost@intel.com>, mm-commits@vger.kernel.org,
 Patchwork <patchwork@emeril.freedesktop.org>, SeongJae Park <sj@kernel.org>,
 thomas.hellstrom@linux.intel.com, Vlastimil Babka <vbabka@suse.cz>,
 ziy@nvidia.com
References: <179342234355.4.16705453209886955762@gmail.com>
 <20261121160037.1a479f3c8b4e860bc23c106d@linux-foundation.org>
From: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
In-Reply-To: <20261121160037.1a479f3c8b4e860bc23c106d@linux-foundation.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: DKq3SanKl08hA5WE2PXcNrWVfO6k_4CkhbJ4DYrKbiU_1795326940
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Queue-Id: 1AF881C0002
X-Stat-Signature: 8awqgbk8xmied3hqo3t5ztnz851jefu9
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795326944-345306
X-HE-Meta: U2FsdGVkX1/JRAZsqWfH7Ed8vWBBabRfLxsMrsduwjU8nrfouXdzDTg1dLh6/Ko8gD+83kQKjU80Ch2ovyF4rUS7Qq/Q+5v7Kh92WdpMxRqRbmidAVaPervWGhAY+Z6Bomex/odEcwbizX8rRPu7K/sAGlxoCEp/POIzIggyeqhZSNIn0imubCdKj9QYXK3iKP+UNgV+dx65t6aunvfbe0JfeCPYAHw0UCprkff6Hqi50dWemH3kY1d6I8lGOxfJOPV6caRqFYz1EyMF9ksSPdzgfKeCXFwtbaK4htH729S/Qo/Nfu60tnkOSDXK4ARrTszku2ps+vuAANp8W2qJNCxh4228dxpCnPylZMuvMTbN/mISte0eYW+trHbdK09a5DqPUeCSB45/4HnBmzwB8FDfmuucA9bjI9w+SbFqgL3JnYW0AEAIiYPLPdQ5lgHoBdCIAhPzeoitYpe4jMP77UvSU6UNk+VXdWFIUDQWALcAXbC8PWbKc57EZk7EZSr9SKK7c7NdMuiYx0vxRA/B51o54kDDPg3jvcgNgpcXNCyWGLuT6AJ/Ogh66j85S2vQvnCzkz/HZceQDY6iXfZV5V/DYJqmk4CdEktHyf3deTabFcm8iyzG2+sEzLdNEUqhbpFqs/N1Xe0z6R8cg0qMaZRnPIAGuInL67zQ+azd2WQeZohROkY7wFepgOIfdnJdaowENbW+FT1aN4K2SmEeXNS+e73lY3RNNqQYd03Qyb08nhKWmIfELAoFe41HPSXLC1WKF2+xGbPYZVYlh4pAqzY7s9r+Xzf+sf12OJaIwKoU6tLmNCNo/M2KEpJD6Pt2KwvHli9jvsL4Y0RSw3/QI+E93jpmILEU9/8JuchPutfyPrqTQwjYKgafoh/N10NrNBZ3LJMGNm1VggndwskIWfyKzL+k38aBjnQxBPZoxKT/CK4p8A9jhTChHfBwbTcqoB1vQ+362WovVMygHrK
 LBcrEDQv
 AvFQ+Cu3WFQPlEv5lYbJko1F0Bat0wTv/Z90ypwwJhCrabu0OoullxDMddgexFmCL3GezY/wjgBTcPWtBwDrlDd/+RU1FqIHqgaMYl4wb8kQtivXvt+9rEsrXnZQpSsyCC12vb6o017pIzfTBURhoMvDoB1s9iUoRGyyl+vsnj8wvFs+Cn74BMyrqpa4rQ4wnVrMJos34rjJ/0G6azCSsaXE9SPrtSacojo3AJdwzTvIeWHaAeQjaEP+j5rxCP6MV5fiB+GG2aI3Je5V6yKd3DCR+twuhFsIBtbtqGBpOu+IFuXY3Hf8OftQapDo5LJ5g9+1MhXyvFNkl7jy6VTP/OcbvxgdmSiU7JFc43NXt/h47Z2ur/eBJuOxwHqsM1B/qZlI3cNOB+No+rYCvjp5iZZHTqp5wimTHXuVJjMZbFfhUbYbVr/CuyqngZ4Q8rXr+19PxOYxwkIvMoXEoSkvVdl/IFQ1Xj9DcjhLwlL4rZ2pnVyaKwBOzUZ/VQwFTFurrfyV69EeeHjGas1Dymx5mHP1BFavdCrpIf8sn8DzcGoehQbyqdQnfieyjAbXLi7QXD2Ggcr0kwjzkGBKeVjASBOQQL6FfuGAlDmiiluYyydj+m3qPlpMrMDAib01bdI4JJWrscesCi0leQWrKPMScEgbniW/g2JvVJmOjU8LfbTkQjFUIDcRQT9/eFFydwvd62U/sJL56uJhKzZeV5PUOMnWt6k3A1AFCCCPhdPTPkgL4xlBao1WXkeW3ORV13EaLnlXqwqep9B4s8/2IRrPZK+Lha5xPFtlSNavxfrVpwpy3/sztFn0zcA5kCB/Fhz5jYvdLSxaZgzm3TWQ6u5i3y9WLxqKfetLvKjXzC7T4iskQayZBZpJT4yAJZOzQOQvGGE1aDrQqphkydZw2EjfYFf4BNETA5fQvPhk1+yScp5ozw4qDP/FasfuZh+SMkN+f7oq/Ex4fNy1YG0emxjt/NxEmKyo1
 6a8mF+gx
 5HFPU+cFVm7+G+/tnQjOjeS9i7bNbDqacyEFv5mxmHQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On 11/22/26 02:00, Andrew Morton wrote:
> On Sat, 31 Oct 2026 15:07:58 +1100 Aveline Noir <jm5905938@gmail.com> wrote:
>
>> When a query starts inside a device-private PMD owned by
>> range->dev_private_owner, hmm_vma_handle_absent_pmd() still fills the PFN
>> array from the folio's first page. The returned PFNs therefore refer to
>> earlier pages rather than the requested subrange.
>>
>> Add the query's PMD-relative page offset to the initial PFN, as the
>> present PMD path already does.
>>
>> Fixes: 10b9feee2d0d ("mm/hmm: populate PFNs from PMD swap entry")
>> Signed-off-by: Aveline Noir <jm5905938@gmail.com>
>>
>> ---
>> Found during a synthetic test_hmm check of device-private THP handling.
>> Tested PMD-aligned and non-aligned subranges, PMD boundaries, split
>> PTEs and fake-device data accesses with test_hmm in QEMU TCG; all
>> executed tests passed with the fix. No real GPU testing was performed.
> Thanks.  It appears that the changelog somewhat understates the
> seriousness of this so I came up with a more assertive one, below. 
> Please check that.
>
> I fed this through LLM-driven QEMU-based runtime testing and it looks
> like it pretty much replicated your testing:
>
> : I tested "mm/hmm: account for subpage offsets in device-private
> : PMDs" on matched x86-64 guest kernels. An unprivileged process
> : (UID 65534) migrated an anonymous 2 MiB THP to the test_hmm
> : device. A second open of the device read pages inside the PMD
> : while the first remained open. A snapshot confirmed a
> : device-private PMD, and temporary kernel log messages confirmed
> : that the reads reached hmm_vma_handle_absent_pmd().
> : 
> : Without the patch, requests for pages 1, 7, 255 and 511 returned
> : page 0. A request for pages 31-33 returned pages 0-2. With the
> : patch, all seven pages returned the requested contents. Page 0
> : read correctly on both kernels. Thus an unprivileged device user
> : can receive data from the wrong pages.
> :
> : The fake device needed an identical temporary backing-page
> : correction on both kernels to make this read path work. That
> : change was removed after testing. This exercises the HMM path
> : through test_hmm; I did not test GPU hardware.
>
> So it accidentally found a bug in lib/test_hmm.c on the way.  "The QEMU
> run exposed a real test_hmm bug: a second open of /dev/hmm_dmirror0 can
> put a device-private page into its page table, then dmirror_do_read()
> tries to copy from that non-CPU-accessible page and oopses".  I'll prep
> a fix for that separately.

I noticed that also and will make changes around it in my series.

>
>
>
> I'll queue the below in mm.git's mm-hotfixes queue and shall await
> maintainer input (please).
>
>
> From: Aveline Noir <jm5905938@gmail.com>
> Subject: mm/hmm: account for subpage offsets in device-private PMDs
> Date: Sat, 31 Oct 2026 15:07:58 +1100
>
> When a query starts inside a device-private PMD owned by
> range->dev_private_owner, hmm_vma_handle_absent_pmd() still fills the PFN
> array from the folio's first page.  The returned PFNs therefore refer to
> earlier pages rather than the requested subrange.
>
> Nouveau's GPU fault path can query one page of a device-private PMD at a
> time.  Xe's SVM fault, prefetch and userptr mapping paths can also query
> subranges of their own device-private PMDs.  An unprivileged process with
> access to the GPU render node can reach these paths on hardware supporting
> device-private THP migration.  Xe can read the wrong application data or
> silently overwrite earlier pages of the same process's device-private
> folio.
>
> Nouveau aligns a one-page GPU fault to the PMD head by subtracting the
> fault offset from the returned page.  The faulty HMM PFN already refers to
> the head, so this subtraction can select a page before the folio.  If the
> preceding page belongs to another allocation, GPU access can expose or
> overwrite unrelated userspace data; an invalid page can also fault the
> kernel during its address conversion.  This worst case follows from the
> source, but has not been demonstrated on a real GPU.
>
> Add the query's PMD-relative page offset to the initial PFN, as the
> present PMD path already does.
>
> The device-private PMD migration machinery first shipped in 6.19. 
> Backport this fix to the maintained 7.3.y stable series; the HMM path
> exists in 6.18.y but cannot be reached through an in-tree PMD-producing
> device-private migration path there.
>
> Link: https://patch.msgid.link/179342234355.4.16705453209886955762@gmail.com
> Fixes: 10b9feee2d0d ("mm/hmm: populate PFNs from PMD swap entry")
> Signed-off-by: Aveline Noir <jm5905938@gmail.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Leon Romanovsky <leon@kernel.org>
> Cc: Francois Dugast <francois.dugast@intel.com>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: Matthew Brost <matthew.brost@intel.com>
> Cc: Patchwork <patchwork@emeril.freedesktop.org>
> Cc: SJ Park <sj@kernel.org>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: David Airlie <airlied@gmail.com>
> Cc: Alistair Popple <apopple@nvidia.com>
> Cc: Balbir Singh <balbirs@nvidia.com>
> Cc: Christian König <christian.koenig@amd.com>
> Cc: Mika Penttilä <mpenttil@redhat.com>
> Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: <stable@vger.kernel.org>
>
>  mm/hmm.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> --- a/mm/hmm.c~mm-hmm-account-for-subpage-offsets-in-device-private-pmds
> +++ a/mm/hmm.c
> @@ -355,7 +355,8 @@ static int hmm_vma_handle_absent_pmd(str
>  	    range->dev_private_owner) {
>  		unsigned long cpu_flags = HMM_PFN_VALID |
>  			hmm_pfn_flags_order(PMD_SHIFT - PAGE_SHIFT);
> -		unsigned long pfn = softleaf_to_pfn(entry);
> +		unsigned long pfn = softleaf_to_pfn(entry) +
> +			((start & ~PMD_MASK) >> PAGE_SHIFT);
>  		unsigned long i;
>  
>  		if (softleaf_is_device_private_write(entry))
> _

For this change:

Reviewed-by: Mika Penttilä <mpenttil@redhat.com>



