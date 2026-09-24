Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55EF7C98311
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 09:11:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 311FB6B0088; Thu, 24 Sep 2026 05:11:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29BB36B008A; Thu, 24 Sep 2026 05:11:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13BD16B008C; Thu, 24 Sep 2026 05:11:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CFD6F6B0088
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 05:11:07 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C69CB401EF
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 09:11:05 +0000 (UTC)
X-FDA: 85248086490.17.5420AEA
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6698C40002
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 09:11:03 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=meta.com header.s=pps82601-s2048-2026-q3 header.b=fhwlflLg;
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}");
	spf=pass (imf27.hostedemail.com: domain of "prvs=7727f07d68=alexghiti@meta.com" designates 67.231.153.30 as permitted sender) smtp.mailfrom="prvs=7727f07d68=alexghiti@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790241063;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OkxRH+q+0DEgZUuWgxACk6KXAXfbkWPs9mgxMAe0PGs=;
	b=APTGpzLyq9bBqn5TIILK5qSbr9pHCOrc4fWmI60Ns4539xXRSdOHt0nS399+vptgGDaYMS
	+pq00Pg9IUqWLJ4UGJGDQglZeRvVy1LhmLiJJbb+ZypU5i5S2cOYBl4oci2F3KZG3hyeJ+
	UeAhppDNGJqRbykiDhHrCn9iN1SO/cA=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=meta.com header.s=pps82601-s2048-2026-q3 header.b=fhwlflLg;
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}");
	spf=pass (imf27.hostedemail.com: domain of "prvs=7727f07d68=alexghiti@meta.com" designates 67.231.153.30 as permitted sender) smtp.mailfrom="prvs=7727f07d68=alexghiti@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1790241063;
	b=4U4URmZf8WFgU/kU9BeFVWhSSHyuXy3IGOQcX0TRK2c96pO3uxpgJ11fmkZuY8IdnCbF5Y
	b6E/dxU1CrNaePXl+On/6wn6fflRk0YSwfjUTY4qCye1sgOtu7Bk0u2mpnU0LOyNLULdbS
	rz3HLIQe6yZSJ97A6gh7ziuYhrG209E=
Received: from pps.filterd (m0528005.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68O5eEKd3608041
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 02:11:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=OkxRH+q+0DEgZUuWgxACk6KXAXfbkWPs9mgxM
	Ae0PGs=; b=fhwlflLgduNKqEWjlZgv6ytWrRGy6UXFW6QLYOsAQwcSPTUl990qk
	DWuDAfZ8vZf3Ac+6QNkF8VZjl46oJmxGagOMv6DsAD7CPBvSv07La4IQ+oShs0v/
	UKGx0nxo/PfbnLXUP9sh06hHNyvK45ucVgMYYa+5iwoYtMxaRVtxteCwTN6fU5TR
	6r5po9MGRUKpIAOXulJ0id/EIcDjpzCrhzlxwugWOoFHum22YGXAmUUvEtszM1A5
	t+Nr8/oh+nL7Exeg0iu49MDK1j8W2ld3lMQ3JDYJ/kv7IUIQE8gPI0d3Oz01z9Rz
	CgctQxCRJJVg2C+Xco/q0cIjVOU7em/Cg==
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4gv8qqanhr-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 02:11:02 -0700 (PDT)
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-c29959eb71fso182602366b.1
        for <linux-mm@kvack.org>; Thu, 24 Sep 2026 02:11:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790241061; cv=none;
        d=google.com; s=arc-20260327;
        b=szb+F1Nq02EM7DGXuuFs135qAvwdPZOqUaQtxbMt/8I2V70x+B9y/PM6CJudqeyRLo
         uKUbuYxid4xz+SbijL/zwalSTrFnJBEVgSyjp3RiwcWDYNP92+RdQ6BuVQLA6BdX7+Nu
         vqcQ7jsAWBC+o3Tgxl7JaScxm5cnl5/R2qDZ/2b4Kyd5mq/FrWFjOddYR0oVt/al6Fg3
         irlDjaEZ3PBOKCvVTHgtoKXA7ybiAc2HWL5y4z9CFv5fIHG8nlfEldxd0ZO2BdckSJ5+
         sLnhkyHLBcBzTnG9+QOLFlmZFgFYIl5JPnvtLQNebsSC/SG0bo1dcSIKxBqwlilTTL2z
         5MUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version;
        bh=M2souLhMloQ4pmmyrj3ZcxjVddtdbXDXplB5Ku+fTnM=;
        fh=Xn5pTGZyOR6KeTGDxqwenN4FXIPcBInmznAl0vkHWGs=;
        b=sG54xbi+HKGwQ7UUwMU6L5nYjKyKfOlBYLvxWmL8/dcG/QqBY/V28x/b+6SzG/LDvO
         7lBaq85pN+A40dBztXNX9Yp16eh61sw/1TiENKWw+zm3oFtdvKUj8nT2KIEVX6di+wUN
         c7Aerw4a+hx5rqaPdj1iuZNuExnVLOaZu78FYsKELhNXF4HCLwVyj6NQPQ/4RIIQixhd
         E29qrROjrSBHeZr7pNOuLscr6xW5penLN5AiEQqAehyo0rKlz72cQVuVzB5MmIZaAKmp
         VdlD9DoxAjmn4GeyfrgwaPm+w8K1J/tcdYrUlKDYPKvIkQWwQIMC5FdMuF1Hj7coOtxG
         nfww==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790241061; x=1790845861;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=M2souLhMloQ4pmmyrj3ZcxjVddtdbXDXplB5Ku+fTnM=;
        b=lanGPSrnXpKUSbWxkxxlgMtPW9J4FN2408MEzcsG0TSa8Ic9qjcmeMpIRYajNCd++s
         62wTv22pYV6p4Dj9/QALL+ZAeYdxM74mvOG6JNWTUnyXOPpK2NxhhtRvFi6YWhMSp8Qw
         +MiqMBrJKjkAwoaTJulLpvkZIw+SPoCkx7OZRb7tv8XfAHW8rGWxQrmvVExSasPwFN5m
         I7zhRno1xD8rHLEO4sq6OCcZ9hIDMJJdfO39CYvIamarzRM+tcM/DDNfWSmrHbDLmpBG
         Yl/Ew9JANeKv98hA7qh/rQXo/vMpy7G94slg9+9LzfCBbEbUAt2zdLrSGs3NM71ZZPpj
         rR4w==
X-Forwarded-Encrypted: i=1; AKwUvBw7iSYr8Mm9Z7rQhZneNmFPKDB/0NT+HZZ4r00mTrh0HcQp2kc9vRJ+VxkN0HhEsJKqkpAcI+oc/w==@kvack.org
X-Gm-Message-State: AFuF++lfP5o1mP+17gZmSuMg9+0zcioibjiFC9llhCMre0hHYzWwQYQw
	2OZE5zyP1nY3rZ6+L4TRCorSl9uWeggXh920zCSxHCGyoP9k+zvDKZkxKOPlLsXGMSkopGojECU
	9gDSkjoZrIxdG6w6Yz/ipQUPHRXogo4g041abJd/9mcXtjdPTU6XUiau2hOgNvaFAS21iiEEfiL
	zDpeu0JM4YeYNbMvqHHE+wfF5lDw==
X-Gm-Gg: AYBFou2ZViAWz2hkXKhjznxsDV9l7i43OjtCYz5DnbY9sYGjX4b6meY8Ml0kPZMdMTb
	Cn7OaTH+wef/v+0EY7k+6IKp4Qz2G4Zt645oeUjhnKAlb1SyC2fiIkq7jQeEdv/FtuqQKALVaZp
	MzmiSrvXFAfyiQwJcCLjpbMJMbp5YWbi5IMsA7BHMz/yb+XjjDpOrSkr+ZV8vO2yhVAzSWeySqf
	rPeyq7pCQJs9AKwGQ==
X-Received: by 2002:a17:906:7947:b0:c26:1649:47ad with SMTP id a640c23a62f3a-c2ac53c3f15mr97802866b.35.1790241061079;
        Thu, 24 Sep 2026 02:11:01 -0700 (PDT)
X-Received: by 2002:a17:906:7947:b0:c26:1649:47ad with SMTP id
 a640c23a62f3a-c2ac53c3f15mr97799466b.35.1790241060652; Thu, 24 Sep 2026
 02:11:00 -0700 (PDT)
MIME-Version: 1.0
References: <20260921152449.629486-1-alex@ghiti.fr> <70cae945-3a4a-40db-96ac-5ce66a3fa186@kernel.org>
 <CAGsJ_4y8-wD0yMV8GCtCz5MfNrOKqUaTd+UgH=8MoP_nuvPnGg@mail.gmail.com>
 <108487b7-0529-4282-b5f4-355804b4c0cf@kernel.org> <CAGsJ_4zGmGh70QtRBpnhueev3qt_bgB4ZiE9fkW-hgNjAVhv+w@mail.gmail.com>
 <2e695c8a-4212-42b5-bb51-fbe1aa162e1d@kernel.org> <CAGsJ_4z2nakqBCKd_uAn4bfub99r3NJt2spOUx-K0M7bHW3_-w@mail.gmail.com>
 <4c7c6ea0-84a7-45f6-989c-d1502b90694c@kernel.org> <CAMgjq7DeYsJxG_VCf2KnViV5nd10m-PPYzXRD1fi8QcGWwD0qw@mail.gmail.com>
 <d9a77381-cf88-4726-9223-c16a5c6608c2@kernel.org>
In-Reply-To: <d9a77381-cf88-4726-9223-c16a5c6608c2@kernel.org>
From: Alexandre Ghiti <alexghiti@meta.com>
Date: Thu, 24 Sep 2026 11:10:48 +0200
X-Gm-Features: AclHuK-UOq_6vRlLv2UYnifr0HoK5SGeCN1wUDEcA3fAollzIZ7bOBDjISbGN1s
Message-ID: <CAEmasaWxkfBj91ye+kr2hwaAin1rFSTWrXCbntV5vjuqCG=54g@mail.gmail.com>
Subject: Re: [PATCH] mm: madvise: drop MADV_PAGEOUT folios at swap writeback completion
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Kairui Song <ryncsn@gmail.com>, Barry Song <baohua@kernel.org>,
        Alexandre Ghiti <alex@ghiti.fr>, akpm@linux-foundation.org,
        willy@infradead.org, jack@suse.cz, liam@infradead.org, ljs@kernel.org,
        vbabka@kernel.org, jannh@google.com, chrisl@kernel.org,
        shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev,
        youngjun.park@lge.com, qi.zheng@linux.dev, shakeel.butt@linux.dev,
        axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
        hannes@cmpxchg.org, mhocko@kernel.org, yosry@kernel.org,
        chengming.zhou@linux.dev, kunwu.chan@gmail.com, tz2294@columbia.edu,
        hch@lst.de, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Authority-Analysis: v=2.4 cv=XppvqlF9 c=1 sm=1 tr=0 ts=6ab4e926 cx=c_pps
 a=Ak8bExYEjeps3Jj0Zi+cTQ==:117 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=jCddH8ec0KUNCymVuxII:22
 a=VwQbUJbxAAAA:8 a=vvh9Qk1aVFpNxidmG9UA:9 a=QEXdDO2ut3YA:10
 a=IIT_bRn7abC_HnDGr_W6:22
X-Proofpoint-GUID: sP3JLJ6k65q1Pa6WA9SpMrqYf-od36bE
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI0MDAzOCBTYWx0ZWRfXz5P/+5V+OLe2
 UGfavqNOEFel5iS/A12ZFF4UCH5WJwSlb91tDs7RvIYxVcJ29LgA1gbLjnq9XNzFaUPLlVw2NfP
 +iPZCMPOGEoB5hdfeMDcHIbUq0zz4Qw=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI0MDAzOCBTYWx0ZWRfX6cYVxGqrRXp4
 aLs9Nw08Lg1yw6gJ4o+keD/cJj6r9O3agU6CSoAjlIdpW25KsZ0ug04NrQnQaD1AxLuNsaGCWmg
 Ve56M49OLKCpfkQ2yeTnIC/J8EKUU1R0Yak7PdhA6NnsbN5Tc5Wmpk1KiWz/onEmZ3oKp61sM/u
 4N1I6pXg7cGWXcCKyoXO/NuIPW8rgGetcmQOilw6ydEIP0ZXSsTCMOh6FvqwDCC9GKhsJUJaYZO
 06CTetyYDBa6mjbM7nOPY6pITED+EpCkgcI5fzLfWSHGcOBKmdepj9gVXx/ifAcutsMbCxgzTn3
 toeTnM1lGTffajr2iKf+vrFCyQrIS8zoFaUprsBdcuMdc930NjniAlpuPpm5EZpMjlg+ZaUoUfZ
 qvUodyCwZ23nj4N51c/dsGJQYzGQnYDG4luI8MtjzB9ORJOm0TGOh3wTpfid3C4ac0pMLg1dhcS
 9lb/sYQ2Zl9LtyXpeqQ==
X-Proofpoint-ORIG-GUID: sP3JLJ6k65q1Pa6WA9SpMrqYf-od36bE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-24_02,2026-09-21_02,2025-10-01_01
X-Stat-Signature: 53orqyq1p4pb4ubt13rn7ayxiixmo9rc
X-Rspamd-Queue-Id: 6698C40002
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790241063-771065
X-HE-Meta: U2FsdGVkX1+92K1Dsw5PCYKBvEv+oqW1PYQvqaXRc93H00Kcak3tglAx9u5mP65XCuOkan9KzF3jSzSbKyvdEimlY6+RO/vP7e6WLGKp5ZSFAYk5E6QCqsyHRf92nyCf3+eoTPeQl+ySpMxJzT8e5Fu+xxZU4QI3cy6i98JfwxNJeFVde+FDkrIKVHTlieMUpWcWCJWy5S8FFIZx4rZaTZvHY5d83ynKLzr3i2ObPeQizXej/3o/kfQeuVA8Zwkp8ZsjXLBx62ymYqZMhdLQ/lh0bXFE8WOwm6O1kBfWWrZ+ANWPONYJERwITOzqj+s7/v3pbVbVTO+PKWUYDTf9PSl4tINL3lTZhDSvHvYTb98yjnNu+VIj093r+okx0cojuFJ+IzFQZH5roZRzfKQI3t00m+c+s39MfQYwAMf9cK9facRgyeVrooLwDDi1E/dEXv4dqtMjgtM//6WnhE9p4DwmzJwhU6ffswep7uSWfAIMWbuZXhPpLBcMsIM3k2U5gD13tmjKkE5wkuxrMPDU33/wQ+HASAr1GCLgn3UXg2lHOdVFuAXaacSLJv3rZofJhMQGy5180vWkEwXQH2kyyyZEm1PwKSbG3HlNUxFSIRKhtqZEZF9+NRi1LoYPfJpsUf3ue/wE5SjGllv1LzoO+QkINapBXpQexs7CyPqFIirXb+oUTgHzs9wEsNI8Qbh9nmSfKtk2S6gqPuif5yVuiP/rzrjnKUUcjhaJOUJ0A+V+UPETQQXeC4kyBheLeLQ813S0BmVSuBM0LdWsESdZR4emovo5cOiYi3zWOP/ukUnlpD6E2NrL6YrB2Jj6ctN2vyZDrt/5QaJ70+1x9hIt0nHp7O10GjYvp3iksCnyeR/QkePMzjMN6iAHi2PvS/LZcFUrEi+xunt1BEIuUKHX+DmwHxxl0q8i+qKeK7fNxw2iCPgj6IF3/Y0F8pgs+RQQq+kzZ+RgLehNGXfiQtM
 FZEnRaYv
 M5ztrtGkpMAYdg0ZiKJN9I2XBEJ+M4NIsJZsDHNVbsJavDM9W/TD0V6QEcTgzYwQGXpTmO4npUNpTsjgAoQP+jNAb1t5hPBBh3SJpmGfTIy/8gKjkVmIf7PO9VNYy7HLensSRi8yharti5GPbGo/dyhzMKIppDniveymmTSzPfbQD8aVk+qP10xH/5mX6lRyyeq7I1y0Rkxrzx17naPR6xDebd8ijGDSiYmtX2ML+v0FrnzxgPa9t3fySkmIeSbBo2R8qpZD9QNmmftAC8TCpF5CV7GjtSL5JGmi/VGQk16tjeiHBwrDdMvCLsB2N7JVBVhxUWwMGHZln43pN2tREMuznUql+UAlAGfuIjCuQ0WfhdW9wr5iiLJTZW2cz95nmRDy/0V9Z1OxQaOzSCgJ8Bv1FOFw6lFPjW0Kg2rbDlBvUlsQGS+0h0uJNkZ+0x5Jgg9bPF3Q3fJbZ2A+cBMZxU80wpEdEWUGu3PI+zLU6XuoJ0e98lqfpy5gg86y+3pnzgic/2U0PAP+PnPRp/DBOu/D3zGjX1UrQyo0c5Z+nX3M+9kdQ888hpyJPFcWzZP4nkUa6+efCTHzOxPeOJnWuFNMohSyAoR6NM2uwvBlC/MB1YCcL3CmVJRpWZUNca/mN/ukX3yCGYjXtIg8STmr8Hr2Y7Dufmyx/hBvP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David,

On Wed, Sep 23, 2026 at 11:47=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> >
> On 9/23/26 11:35, Kairui Song wrote:
> > On Wed, Sep 23, 2026 at 10:46=E2=80=AFAM David Hildenbrand (Arm)
> > <david@kernel.org> wrote:
> >>
> >> On 9/22/26 22:55, Barry Song wrote:
> >>> On Tue, Sep 22, 2026 at 7:26=E2=80=AFPM David Hildenbrand (Arm)
> >>> <david@kernel.org> wrote:
> >>>
> >>> I guess that's because the LRU is not always accurate. There are cases
> >>> where our prediction of future access patterns may be wrong, resulting
> >>> in refaults?
> >
> > Hi All,
> >
> >>
> >> Right. But these would happen in both the SYNC and the ASYNC case. Whi=
ch seems
> >> to indicate that making the SYNC case behave like the ASYNC case (keep=
 in
> >> swapcache before evicting) could actually improve performance?
> >>
> >> Or is the SYNC case in general so fast that it is not a problem and the
> >> swapcache is just not a good use?
> >
> > I think the problem is not LRU being inaccurate, but ASYNC case could
> > overshoot the anon reclaim very easily. File folios can be simply
> > dropped, and increase nr_reclaimed, but anon writeback (swap) can't be
> > done durig the reclaim iteration so nr_reclaimed never increase during
> > the scan iteration. So the scan tries hard to scan and reclaim more
> > anon folios, more than it really needed.
> >
> > I think the real fix is some kind of different watermark, throttling,
> > or a different counter to limit the scan of async swap. I mentioned
> > this at LSFMM this year but I guess I presented too much at the same
> > time so few people remembered it :D.
>
> :D
>
> >
> >>
> >>>
> >>> Even on Android, which uses zram with very fast synchronous swap-out,
> >>> I can still hit the swapcache from time to time. So perhaps with a
> >>> slower device, such as an HDD, keeping the swapcache around for longer
> >>> could allow applications to hit it more often?
> >>
> >> Why is that specific for HDD? It's the exact same app behavior indepen=
dent of
> >> the underlying swap technology.
> >
> > If you have a shared folio, you must use swap cache, and even for
> > single used folios swap cache is the way to do synchronization,
> > regardless of the device.
> >
> >>>
> >>> I don't know. Maybe Alexandre can share more details about this
> >>> benchmark. I'm also a little surprised by the 15% regression in
> >>> Sysbench OLTP. My initial feeling was the same as yours: we should
> >>> release the memory immediately after writeback completes, for both
> >>> synchronous and asynchronous I/O.
> >>
> >> Right. And see if we can identify why we are swapping out the wrong th=
ings :)
> >
> > I think we are not? It's about over-reclaim. In the worst case we
> > might put every anon folio under writeback, while no folio is
> > reclaimed, if the device is super slow.
> Ah, that hints at the real problem then? How confident are we that that's=
 what's
> happening?

I'll set up this experiment again and return with numbers so we can
check what happens. I remember that at first sight, I was not able to
understand the cause of the regression so I'll need other pairs of
eyes :)

Thanks for your comments,

Alex

>
> --
> Cheers,
>
> David
>

