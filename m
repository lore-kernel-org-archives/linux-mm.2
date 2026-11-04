Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D463D606A326
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 22:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=WJdsZjfS
Received: by kanga.kvack.org (Postfix)
	id C388E6B05B1; Wed,  4 Nov 2026 17:57:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE9356B05B2; Wed,  4 Nov 2026 17:57:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADACE6B05B3; Wed,  4 Nov 2026 17:57:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8333D6B05B1
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:57:54 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0E0C4C0848
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 22:57:54 +0000 (UTC)
X-FDA: 85398950868.24.6F29DAE
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf15.hostedemail.com (Postfix) with ESMTP id 28D1DA0009
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 22:57:52 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=WJdsZjfS;
	spf=pass (imf15.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793833072;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bZmm/fjciQHFDsHygF6gqzElYGHv0HpumcgfM0NGUjo=;
	b=OSwnr2uyEhJTxs9VqH6R+ZjKWq6jY1onRyLKzKAEx7ButVVwMVUhk923Zp3PHtVDRlisd5
	f5V3HcEPRJj+UD0XijhqTR9nCUSOK2ZutoyAn+1ipfyMhev9W4S6VdkHKR6coWyyXZa/nI
	1QxbKwrQ2ZhFox9Sumi1u4KC1H/imvM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=WJdsZjfS;
	spf=pass (imf15.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793833072;
	b=pqC+7HgPqDS4gNXlexdH02iceF7U63j6mRyaLRVLf0CkduuiJK4SH3sjUBeLGJvfUiLKem
	d6vRyPbkbJbifj9O+f4qUt1aqnQsv3/1nomdLz53HFvL4vZVV5m2GfM0ue4lDGp64Tsmv8
	aVeoOpWQQwO1AESPVqyHUXLMz2Q/mfo=
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4a214af2076so8994465e9.0
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 14:57:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793833071; x=1794437871; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bZmm/fjciQHFDsHygF6gqzElYGHv0HpumcgfM0NGUjo=;
        b=WJdsZjfSuj6zOcxF7cBGVv7rz0XD19BRl4OozmheCPObhzhtrCDkWsNwC1WhjZWWXT
         ZQjtSUz8swSCPywFO4SDkyP/SR8Af5Cz7S1/19GG9+eh2S28lkpDfJC+xfnJdAmLE8a2
         3UJVVQtkL1o06iHF/CK5iW5gXP1C17go6juOK/z/tBTXrDFTCgl0sJVUHliMnptRSC9R
         gNlcXYp0+a9kG+05L+qlK+eWsgfSblt3BWbWceqjYlUdYpKKI5lcevVRRp4BUD4hNmB4
         p2X5cN3WruOwsMSUXswQMpuXu0yf5pmUMq0MfE1caK/Ks8wrP65XrJ+gz77Vg5NM10xK
         bGhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793833071; x=1794437871;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bZmm/fjciQHFDsHygF6gqzElYGHv0HpumcgfM0NGUjo=;
        b=nFDy5jFFHQBzvvXgTI+qSLfHPGPJ3kcMhSaOiwWZJpaUmJxAdKCB/0xgwjNend+0bl
         6ToBqQqyktb+nbi0gEbBdE29kqTZH6qVeraRgFhQgcDTU4V77qB7p1yByOZkW+3Fn2Gu
         1TrdiDdAVztMb4GM5U+KprxEYfZuVclz6aciL08JUxsTbz4NcuRDMRFJmGOEW2t+LU8c
         mV+9pOb8nT2Ld93V4clMvn10KvBxxZQkxpo/XMzmt5INC3RgumPRx66gKEowCDZLzexV
         7csb8bG79OwJ0Bs6P8KSjk2XNXRkjbxJS59gdLpFZpgpL+8T07CeUUD38pBAfb3MjkPP
         Wt7Q==
X-Forwarded-Encrypted: i=1; AKwUvBzYOFgzymP6IIUNWpomIjMSuj5EW2fD7gBzst0CxZAovVxc07AOsJKwz4eNPFCQCCrBjpDMtVdacg==@kvack.org
X-Gm-Message-State: APuU4Z+YPKhEo5IKnOdVInPipgB/bjaMEbHZnzrn5qEaEMLF2BJYUiMn
	pLKlHr8M0Q09LIz+dDhR+nmj6IKPP9H37/8YUZuCmluWG1q36lxmgqWM
X-Gm-Gg: AYBFou0pcwJsqQMqUQ/tySIwO/hAjPVRqVkaY3J7qfEa0u7uw5XtUdoyoQD9eJE/Beu
	3RoqrE8PYV8twhQZM4yWUJHc9Bc4c3NHpYKrUJuupdGkJUgwWlbpT3tO/Y3Wvz4k3t1NEguxJSS
	jxO97G0wzISXAXHy4KPaiRvO97nzQwTJPDFfrm3L+3AkFAEeAKoKWtW3UJbcLGJi7pwiO8Mi3iL
	ZLQAQIQO1To5S6moEBy2ti3h5X3LxBhdjhwWCpPBc9X4u6zkmFXHTDeNgyZLkgavypZBULbhOHD
	QO6yYjm1Ivu6+V81suX6niULSLjO7FG/Clx82SBjau6w6AhYXTjqX8C9Qn+KIxY/GsUbsd2EmaH
	s4kUkNJKYT9pAEVmZoTrM0BYf1xjBgN5ed6L0O0yRqUbCAmTjWEgaBVFtABQw+mDyc3SEJfLNcn
	0hsUOJBrw/ZgljMS+ZoopXObqROgLDcmCDLTcA4sBKCya1HR048XFozSekOqvd9ItSv+VyVy5Ee
	74fLT2AuwgedmvwUjz+EJ3zZTvztPUYjgBzHO1iNGcZ2L98cJndM8N721vlL3hP8AW8Z1HWbQPp
	eXywV/Ejf/nEBMEwo5e0jE8=
X-Received: by 2002:a05:600c:6212:b0:4b0:a7aa:843 with SMTP id 5b1f17b1804b1-4b0a7aa0a54mr222825565e9.25.1793833070285;
        Wed, 04 Nov 2026 14:57:50 -0800 (PST)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b5725061e1sm17756545e9.7.2026.11.04.14.57.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Nov 2026 14:57:49 -0800 (PST)
Message-ID: <93d13781-0c37-4a3c-8fca-6f8108eff35a@gmail.com>
Date: Wed, 4 Nov 2026 23:57:47 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/4] mm/rmap: duplicate a PMD mapping as one in
 folio_dup_file_rmap_pmd()
To: Konstantin Khorenko <khorenko@virtuozzo.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 "David Hildenbrand (Arm)" <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Peter Xu <peterx@redhat.com>
Cc: Alex Williamson <alex@shazbot.org>, kvm@vger.kernel.org,
 =?UTF-8?Q?Lo=C3=AFc_Molinari?= <loic.molinari@collabora.com>,
 Lorenzo Stoakes <ljs@kernel.org>, Shuah Khan <shuah@kernel.org>,
 linux-kselftest@vger.kernel.org, dri-devel@lists.freedesktop.org,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>,
 stable@vger.kernel.org
References: <20261104-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v5-0-c56d0d26f970@virtuozzo.com>
 <20261104-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v5-1-c56d0d26f970@virtuozzo.com>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <20261104-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v5-1-c56d0d26f970@virtuozzo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 9ixap4b14dzzgx8d5ps1h741riy485dm
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 28D1DA0009
X-HE-Tag: 1793833072-44292
X-HE-Meta: U2FsdGVkX18s8bC4cvo1+Si7s9yGuyu7IJYQ006KkgfDTIqNXCjRrZi1hxUIDUkjWdBtWRxeM9NFM3wpG+ok7nUywBB1TM57mmZOhcql6uq1J/3yjrX02zuyhldanRojfoDsgSlS5dRClL7ABaG9si8kvAih5pRQrERMQGrZAFNLX6F2392V3B6vghmCLOFuyPGKDV4f8t0I/dda+MBWNp8BoLhCACsOp08U8PCYXD7LpFBYX1A1UrMmM4ttWTSrh1VxBzZfyRYx1pl6X6ZkDkEVOjhuaHJAEaZlKx9VM84KcEzgwB8QvtBAZHvQY9+D0yfbWbO31qgZJmaioOrmOf3l+slnoyF1QFocuVKUtCskDFqM/6jtevCu9joNE58CjKKq+LOlW71CwUZdHX5s/9eHr/+ZwFdzuDhQZPmTr5VpABSm/bsQ6aHg7CgU+/4FSEja04I7CDmReSJwBY2Cacm+dHaSFGO5mZz7Ct/z5xp3AcOLnczFsD6Iwcj9NONu2emCV3TYrcqlMGAoR5p7sGZfgGixdVtZ4lwd6ZhXkD65AxqJuL6FnBMHD2hgNH5RGkT1yrzDROxmbC6IzGIod43fGbJxF1t149BXoRt8X4thZZI3+EklwHrIvv/bJd1eaOOSwQDmfjYw7V/zVsamqBh69u7PMYtEKZG5DhoNSyleN4MmdjW71gcXhrHhKr995UMmy2hPDtNQtmEaBuX/whfNwxN0iJbeWoVae3Y52I3T0VrevVw82HouRVWdMs5Y5s7znUCuFeyNkKQwxVdtcijf837aj6IPlRI7Hm92tH7pETBJbmzdMx/F65j8HZThDhzAYfekl7zM3n7vBWj6ZWCC686cum5533e603YkeUD/UXzIQeFc5AqfBjZsfrHWG+hA9hXC6yBGrJHfp7zjgcmOf1NnjhmnWnyDjEFV1wMLlj8T7TyRlZfqM45j+xUAQQv2nPIIOxesCbqijOo
 JnYsYSDw
 d2nM18Z+pYvXJ+dS/6wxG1ycyvZ1pMxCOWWrSo6SW98IKNjUe6EgJgwiTWtbKCGzxi2PSH+PEsS9hMiGVdVUwrA/YIvTIWKx+vqynxIZX2aS5pkbfHHx/1iVfQmqGAEehHLm2ZIeoWJBpsQPDy4vlid+9ygyQ9tEm0vK11NKE0wdY7odvxo0rtGIPZDA4I3HFiFbNRg+DIjxhckrdFeUgIe5Uzjv50yt0Kx7BK6YKqG/+5wCV/V4GN5Tyimh/7iYaMaTckRyp0LKAtvvMF6bqTrjEqhr81CkOriT5AZ01q8Ga1sDYyxRgnsAghgxH1OHA1w/GLBAXta+nBt7+AvRxYjXYCJNF5XJK4mn4JKGqToZwq/LuP/Pg5EHMnZnjdOSdvGiek9pnVH65i/EQ+9teSMX/fTVQKuprxGpXR3iH0sWRFrN3ScAgY4bUAVZYca5KADyisJ7H5+405xO9FbWKFAU07UAW34N6STJrHXlQElU0e/NmJ2FwCFf7deXNypKuH2K+Iy5Iw1B4vbhk6iPDrMmcglxy1tIa04LsRuOUFUa7pgDxZMaoF3aJ6hkd2xlIsFedmFXamgkRA6GXQ2p4QpoOKMhQe4uDutBVyKXSulcX8WW4jFjjbO2dlxbb/NUd2h/LkrFpiPL9/VC7Vp8DvbUWiiCORg4DtNn+bVlDZ0E7iowf4RUGNTRztw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/4/26 9:40 PM, Konstantin Khorenko wrote:
> folio_dup_file_rmap_pmd() passes PGTABLE_LEVEL_PTE to
> __folio_dup_file_rmap() for HPAGE_PMD_NR pages, so it adds HPAGE_PMD_NR
> PTE mappings to the folio instead of one PMD mapping.
> 
> The helper has no caller yet, the next patch adds the first one. Pass
> PGTABLE_LEVEL_PMD, as folio_try_dup_anon_rmap_pmd() does.
> 
> Fixes: d8ef5e311d7b ("mm/rmap: convert page_dup_file_rmap() to folio_dup_file_rmap_[pte|ptes|pmd]()")
> Cc: stable@vger.kernel.org
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>

LGTM:

Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

-- 
cheers,
jose a. p-a

