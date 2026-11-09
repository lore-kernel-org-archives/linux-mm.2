Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8605606D803
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 09:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=HsbYA4dj
Received: by kanga.kvack.org (Postfix)
	id D75A76B00EF; Mon,  9 Nov 2026 04:01:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D26BC6B05B0; Mon,  9 Nov 2026 04:01:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEDD66B05B1; Mon,  9 Nov 2026 04:01:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 953446B00EF
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 04:01:03 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1F1D240612
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 09:01:03 +0000 (UTC)
X-FDA: 85414986006.12.2BDB775
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8274B1A0005
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 09:01:00 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=meta.com header.s=pps82601-s2048-2026-q3 header.b=HsbYA4dj;
	spf=pass (imf19.hostedemail.com: domain of "prvs=97730f1f84=alexghiti@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=97730f1f84=alexghiti@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com;
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794214860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aGKPnMP7yr4BMoPOEmIDmmSXGXNWsODfdfYLctRx5Ao=;
	b=1CocyUufSu/1oT6ddbTTIzY7EzX22kuCVEk76B3Tt0KhzE+1CUfMBSPDczdRk6HNaoyRu0
	/rb4K16o/OKcO4G8+mtRL02AIGTekqyjuNIC/D2MgyqFsUTpV4g9sjLDtSneV+kzz9s36U
	BEMVoIRfsNCz3p2ddQSwJ1M5uUZ0NF8=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1794214860;
	b=lmRooa8Z5W17ZX9L4ms8eUXWrXjKj0YUWboas1uFrDf7xwvcgJmggUh1IqoEnULf5svIcz
	bbdf5MVUKzUAsSyBS/eUvPkBdeDyIePotOyXg032eeA5X+RRTeX66v24dWTQI4vD4rpXr5
	s4AuiQ03ulT3em/b9zjGsvccR97hz/0=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=meta.com header.s=pps82601-s2048-2026-q3 header.b=HsbYA4dj;
	spf=pass (imf19.hostedemail.com: domain of "prvs=97730f1f84=alexghiti@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=97730f1f84=alexghiti@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com;
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}")
Received: from pps.filterd (m0528009.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A969iB61917594
	for <linux-mm@kvack.org>; Mon, 9 Nov 2026 01:00:59 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=aGKPnMP7yr4BMoPOEmIDmmSXGXNWsODfdfYLc
	tRx5Ao=; b=HsbYA4djDQfVaQls/x0VgtOBrgMu7I0Hc1iZI5ylUZHer7XCof170
	B8lvJvAkOy65ES31k5GEiaMUoNRmz0Y1tvSBgPTqxXSPK15KlpG5u67DTDttmFXp
	Hz4vgwnVyBlcwDxrA2qTCXlm1MIevHw09ufTTCiRb796oaX1QyxrepgfvwBJJfmd
	RtmzSoL0ASBQnG9s/kjTaS+llLhwh4hl2n1HvGjREF/q/aWRvBx4EvPYcmrItMNi
	ZKnrq4G0pxs3WSrgmDca4fU2lIzYfq0myQIyltlhBq69pcK1wVSVPZNlNJ3WfoNy
	rWplG9A31LMsm/Yi/0c6jM8gXYzL6poZA==
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4htpmam3dt-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 09 Nov 2026 01:00:59 -0800 (PST)
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-6b56221d367so634412a12.1
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 01:00:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794214858; cv=none;
        d=google.com; s=arc-20260327;
        b=Li/hcVRWHPVy/N8dDQPc62UACQXHMv6Wr4S2yIBM6WI4/ByZOvl4eohJgPRP/xzhcw
         jYS0FkhpNeW6tRBZI7c6wfC669DSFKTbNCS+LADU69q3a4EkA3jDbLyL01HveNnXLHgO
         DifS/W0knc0wbgk4bKOmaha2WA/oFdQsQM0lpDwPL1MEswOwWbtPWuW9hWKU4ZWcQJGx
         e9aV4EHNDGP2UwKhm68eatiJ1uLcjDAtKkz+bNtfsdJ/g4VE9BvAi92WjUXrgHnZHIFL
         uvFcO5BbrJ+5QpfGO52Yx4sIznVEyRyS9r93cebXFKMUBIN9Os5Qo6oY5aDI7yoDePgS
         /jCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version;
        bh=L+Abc+o3UsjAvdE8ThoMmoPSZoSa5JS86C+NXnhGLvc=;
        fh=fSCfVDMpQ4zE/gOkuGnvXGuGq2RQMUqMeZx0L8wIrLE=;
        b=lNDYy2QV1+OW/viFOv45fEsWHVb8AjIEL/u5VihqEPVRX0aynMC2wOz5S8eziIB3Ay
         4Y4RSV4aCGUWu1FGWQQuJiFL6G8GoHmAQnc24INKflqrz0yzfbRp66veDQ7zi7LvG2tY
         fRgHI8oV+FNbF5CIzjXhJ+a4LEywzoW0z97yukoNEnjFbXNPXSTPG2Hwmur4D1DZETae
         1D2aXx4PSrofkzKTq8lTYvumH4NhvNBw+Zjfn7FedPlbuV+tKN8uIsFeZO39jUPxe8s1
         MnIWQAnbDZP9fRothBkIKX36h0GK9RzbxXHh0TbpSy8F2TQVuBbyJaHBAKVu5YIqdQdz
         iOGQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794214858; x=1794819658;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=L+Abc+o3UsjAvdE8ThoMmoPSZoSa5JS86C+NXnhGLvc=;
        b=y7TBridSMTpL3/e+DDU78nkGFqNpc0VKaqMSaaLbN2YEsyXM5aMaGA9IjUUGQtxHDX
         Iss04AIO3lBZlRUD8OTJAvtbn9YxwrtyCE40dj7CKBjHXZF9cp0jra0a6BsM0kr7FXVV
         f+l+ENqRhLVj0dxG6ZICwW+nE1q9mdH2L9ijrcSK2sML++wJDI+7Hn9iNqwkFUFqbVkj
         eBWiQM5v4UsvihcDTsc4cxQw9/pBnPFV1sEggybf3uMlIK5gk379mDGhHcVm0xtaNkv/
         ZQsBfV60kRYOANEB+YMfp71kMsb7+7A9dISd7Movyl2L3ouZqT1JME03YwJi2oU5cqqb
         gaPg==
X-Forwarded-Encrypted: i=1; AL+hErGrFNl7rA4I/w5hsA/LqIkhGBHKkaoRbD2sPCvvtw/IGtB+AwIPaK5r1KVh7GW4Kj8Tg7yajRmZ/w==@kvack.org
X-Gm-Message-State: APuU4Z9Z1EXLVvMYThg8VaPjwEf/ApUmxTIa/36xV0RIyFBsSpN5BG2I
	MS1MCSCs2yzlvAVbwpLKet9jQ0k5NrZdrKj9mAQD792GX4PxqB+Upk3EWa07ulIbpGm/hZcTyGP
	G3obvWaB8C3DidBNREIbWD3YHgA3A5/mGEfdG8wdMmIYyo38pwKbK6AC7rMQ/rYCe9lL40ZI/ms
	lgCgZLSeSP4cKxOBXSPjIGop2TYQ==
X-Gm-Gg: AYBFou0MtTTAJX3JC74uMo6mBG4R8wkA7ahNXjs9a0WQ/BxUxJ+naGIUSyuhtyneORm
	Fz8v16UNDYsRosIjoDEWHQBSyTaxb/uDDod7Q2mbLlZTocaZ1HShHUXObU3C1dBYDyT4Hp7dDkk
	0x5czWoCipYT5tA8SfFCrm4nNrgVuCIve/uMMuZHyNRIt6hTJ1EPboRMcbB4b4o5w3VG+1MFkP7
	/aOyVg5pEKw1Ijl+g==
X-Received: by 2002:a05:6402:320e:b0:6b5:709e:2196 with SMTP id 4fb4d7f45d1cf-6b722486914mr2174264a12.40.1794214857410;
        Mon, 09 Nov 2026 01:00:57 -0800 (PST)
X-Received: by 2002:a05:6402:320e:b0:6b5:709e:2196 with SMTP id
 4fb4d7f45d1cf-6b722486914mr2174199a12.40.1794214856391; Mon, 09 Nov 2026
 01:00:56 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261105155032.240457-1-alex@ghiti.fr> <20261105155032.240457-2-alex@ghiti.fr>
 <CAMgjq7DpCCiEK00Es7yU_i_wyf7NU4fFN7QFO_RptF9tGvPZWA@mail.gmail.com>
In-Reply-To: <CAMgjq7DpCCiEK00Es7yU_i_wyf7NU4fFN7QFO_RptF9tGvPZWA@mail.gmail.com>
From: Alexandre Ghiti <alexghiti@meta.com>
Date: Mon, 9 Nov 2026 10:00:45 +0100
X-Gm-Features: AclHuK_jQ5Xq2E9pu5IVX9Cm3rlVC84GARMy3jy9SYO_JH8gL8OAfLfsG_Qj0G0
Message-ID: <CAEmasaWMKsBSQ_LrewZc3f6a2u15WARAk25AKWjS4oFy8yciCA@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] mm, swap: only prefer nonfull clusters on
 synchronous devices
To: Kairui Song <ryncsn@gmail.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>, Andrew Morton <akpm@linux-foundation.org>,
        Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>,
        Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
        Baoquan He <baoquan.he@linux.dev>,
        Youngjun Park <youngjun.park@lge.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>,
        Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
        Lorenzo Stoakes <ljs@kernel.org>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA5MDAzNSBTYWx0ZWRfX94gQtCMEYH1o
 bKL1pkasYr3XJBjt2OKMD8jaOYcW93gLeYQaLy9UAXdta0MYS7xg2sNeU/Epgqi8A/Tjqe0nz2j
 YjaHUGYs5idHhqwq5OaQae9aZw1BEx0=
X-Proofpoint-GUID: GMNoCdiUZO4Q9k_FeLqfsggc7g_oVYlb
X-Proofpoint-ORIG-GUID: GMNoCdiUZO4Q9k_FeLqfsggc7g_oVYlb
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA5MDAzNSBTYWx0ZWRfXxAjQkf9jXtzq
 OdSCpbhmxjJTFH+K37egyHV3IF27wkAW0lxiGx04TwfnmV40TkoBx3FQ26mgtMCERusvMEbHFjY
 cOpiH/+CzVNlkD3hWIjF1bMYXVL9hlyyLJKZ0C8boqw0zdMWuVYszwSRfKaLsJghZsDO61IYmVY
 D7WwVJF7BTX6gtq+jXmEyaWWyDqwNxfpdWM2RjMk5nFEBTybhDVPsWri43UOfeMzFT0bYsVl3kV
 TnoCy489cWwgQb9qB2CUt9kIu+eZ90T3HKGZHM2PAxKHe2vsW7uRoZmYpZ9i5XKMVAyc24jL6hH
 99CRR3beMN2AiL+dTd9PoyGSRXWk8KLVidS6qBwfXFYmU4qHdZBZlylJ8KrnMIDbb6FuMnz863y
 gq4/EqqvdTmt/dD2kErKPwjuwcb2VT0oGid0nQd5aYY6gAOHy/gQrDJzWOIt+IgzSS+YWyuU9Wr
 1SYdxCTrw3NaljSaphg==
X-Authority-Analysis: v=2.4 cv=bpbZl0ai c=1 sm=1 tr=0 ts=6af18bcb cx=c_pps
 a=DTy5UCxgudPLKrSn28m7Kw==:117 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=U_y8lYiYyhHBU5rMqhb2:22
 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=GvQkQWPkAAAA:8 a=odIapWaoRman3Og44HQA:9
 a=QEXdDO2ut3YA:10 a=VzYV69SsQLkmnS9OQLw-:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-09_03,2026-11-06_01,2025-10-01_01
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8274B1A0005
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: w4dsmftumenp316gwcy9e4ibyp1obk3t
X-Rspam-User: 
X-HE-Tag: 1794214860-443816
X-HE-Meta: U2FsdGVkX1/RejP0EzfZa+AckuyUFCZjfFBQ8ARvRZ1EBRjSdFvHRETXAptx048nd0spNBPn+sp2hKZMXqzZbSPg89Zv9dztF601xGBZGvpaoALuwUMdNLCbvy3urySpHvChL7T5SFGqsaMEl1FuQZ+4gMxYGn87lsUPKFQzWnFV1Y6oDTxtSYL8K5kZ1pBtL94Ymc67mycsaE0GJzSEaZNyU9C5tKrxSF86XZu9AoLxkuFdEHDM/buZ04mxLiSr2klmbBcKVQmXlXEmxfIUay/Jbrj79enbogPJX0x7y7Fla+zYtKm8q/lU5JnuT+2tN3dz/Iu8uW8MMQR4wkGJBgRyrlf8wF+xkjDq68uIIp3DlKpfl2H53eHABi7h3ilMZdGekNeFMY1HOe9jYGAG+dA+q5x49FJVyciCpl8y57gOqAN3ZW036OsVMQE5z62EJ9EHQze8PGSenjAJl7XNzY8mWEiGRsno3l8MOhFpDE1e1xXe5FCkOCUmH1f919Dw3NteDXWzpABn+LtvqrKy2zZh7yobcpB6+q1tjr/wHm4Whblr9NzEpWGL4g3LALWgjnNXSxbyn5Rnwr0McCg56XBVOziJ9jvt0iuwx1hgQ87Z8kwMczS4QRkTiBklL3bqiwRCwHDjzkC8pN0Ia+GZRhfWzFYjNuHP+FgZ6qV6nlPVCZPbKlhq3rthhueFhjfAFMLqN9zZDefWW1AkdH0G6laSX5iBJstc6RIaCX97WuJniF8GYSQNf+iGaIjupzNY0YV+mQT8DyaF/kUyrwzVPq8DO9njwJom9MnNbyicnl3ty4a7XkC6Em+5OxY+2PE8lueaHtXBuBm144b+ayN0HjTz/RXAwOkVBFCKmQ7qooOdDVZhK0xY1hJQcMZAtgeNbUNOrj5sTotNHsV9HZ85knAW2sTK/YyZcoRRkg2DTgIIssZwkwJLKuMMcAZWPVEHx4qb3y4ElJ1Iw4Ekz+V
 bPQea5xt
 H0/BH/3LZteNbfYZA1OEObnrPyRzNgzX5kbn4Kj8ofOQ4BPfBiPmDcZ/1BcMFQHTyeqALI1SCw1DqKWAkGzY9s6ob3+XBusdlkDAE24EIHUJiupyafUGvEBbj4PsO762mHSxkh5aeEW5UXDdqgEFgDyJRKlrwxKtFmOGY46RM7r2qNFzRTcDJ9HRSfrEue4h22L+enwh0HfBrFqmNIZvZ4hQ0Qu+jmVEpdwhln90TEWw/p9lRHFX9QwCsxjLTslpNRj7uJdJYfrqsPPrxgzzeyDL6wN5z5s9NfaBrvqa//Xa6ZsWW29YEOTfw1yQDXcdDvRlomJuSuWnKyKYDwVUxpf3cTxhhPL55/gR37vZqiwSr1fhyAJYcUyCIm/g+f/+Chlp/Xf5e47m90thZx6p7SxaAQtJv7njaAPflguAkhs3kIKfqLBK3uzK3CGWSsJs/0PZfEjaIsWu7JulKmb6QCqO+lPRHO7ZdjxZuBLGEanqRo753yhdBHNrIQplBbFsIEEWyNbZmlpsVDqg0ZufP2x2eefLqnYU6dX6RQI388OQdBqbmdP68eVIr/qiB6FUO6TAY8+LC47co7Z6FFBKsdUFo29TP5kCopowHHoFPsxBVyG+NBl3nLYnccxenbCPvdxgh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Kairui,

On Sat, Nov 7, 2026 at 11:59=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> >
> On Fri, Nov 6, 2026 at 12:05=E2=80=AFAM Alexandre Ghiti <alex@ghiti.fr> w=
rote:
> >
> > Commit 9a42aed48421 ("mm, swap: prefer nonfull over free clusters") made
> > allocations fill the nonfull clusters of their order before taking a
> > free one, on every device without discard. Since commit 3cedb745d354
> > ("mm: clarify the folio_free_swap() for do_swap_page()"), an exclusive
> > write fault frees the swap slot, so a workload that rewrites swapped out
> > memory leaves holes in full clusters, which then go back on the nonfull
> > list. Reclaim allocates slots one folio at a time, so a batch of folios
> > gets scattered over those holes, its writes can't be merged and it is
> > written with many small requests.
> >
> > So partially revert commit 9a42aed48421 ("mm, swap: prefer nonfull over
> > free clusters") and prefer free clusters again, except on synchronous
> > devices like zram: they don't merge I/O, so the contiguity of the slots
> > doesn't matter to them, and filling the holes first keeps the free
> > clusters for large folios.
> >
> > Fixes: 9a42aed48421 ("mm, swap: prefer nonfull over free clusters")
>
> Do we need Cc stable? I guess no because 3cedb745d354 is new?

I think it should go to stable since it was merged in 7.3, I'm adding
the tag below (if it works that way in mm):

Cc: stable@vger.kernel.org

>
> > Suggested-by: Kairui Song <kasong@tencent.com>
> > Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
> > ---
> >  mm/swapfile.c | 19 +++++++++++++------
> >  1 file changed, 13 insertions(+), 6 deletions(-)
> >
> > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > index 189f04d8838f..1c1b5d0b724a 100644
> > --- a/mm/swapfile.c
> > +++ b/mm/swapfile.c
> > @@ -973,6 +973,17 @@ static bool __swap_cluster_alloc_entries(struct sw=
ap_info_struct *si,
> >         return true;
> >  }
> >
> > +/*
> > + * Prefer a new cluster over a nonfull one if the device needs discard=
, to
> > + * spread out the writes, or if it is not synchronous, to keep the slo=
ts
> > + * of a swapout batch contiguous so that its writes can be merged.
> > + */
> > +static bool swap_prefer_free_cluster(struct swap_info_struct *si)
> > +{
> > +       return (si->flags & SWP_PAGE_DISCARD) ||
> > +              !(si->flags & SWP_SYNCHRONOUS_IO);
> > +}
>
> I actually wonder if we just want !si->flags & SWP_SYNCHRONOUS_IO
> here, but still reasonable to keep the two checks here.
>
> > +
> >  /* Try use a new cluster for current CPU and allocate from it. */
> >  static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *s=
i,
> >                                             struct swap_cluster_info *c=
i,
> > @@ -1143,11 +1154,7 @@ static unsigned long cluster_alloc_swap_entry(st=
ruct swap_info_struct *si,
> >         }
> >
> >  new_cluster:
> > -       /*
> > -        * If the device need discard, prefer new cluster over nonfull
> > -        * to spread out the writes.
> > -        */
> > -       if (si->flags & SWP_PAGE_DISCARD) {
> > +       if (swap_prefer_free_cluster(si)) {
>
> That's a pretty nice helper, thanks!
>
> The patch itself looks good to me.
>
> Acked-by: Kairui Song <kasong@tencent.com>

Thanks,

Alex

>

