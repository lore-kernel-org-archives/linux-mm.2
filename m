Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 369C1606A31D
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 14:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=pE7M49Qy;
	dkim=pass (2048-bit key, unprotected) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=HJsIgPkF
Received: by kanga.kvack.org (Postfix)
	id 41BD96B00EF; Sat, 31 Oct 2026 10:59:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CC7F6B05B1; Sat, 31 Oct 2026 10:59:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BC6C6B05B2; Sat, 31 Oct 2026 10:59:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F19B36B00EF
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 10:59:25 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 676D28096F
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 14:59:25 +0000 (UTC)
X-FDA: 85383229890.24.91F2FF6
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf20.hostedemail.com (Postfix) with ESMTP id 858461C0004
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 14:59:22 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=pE7M49Qy;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=HJsIgPkF;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf20.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793458763;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=if99jRjTkbW+bMdt3bQMbXM0UCEb2EHx3ismkh4nY6Y=;
	b=p4zaIkYRR4Hb9/l4rsH9Sfp+FQaQH99SvZwtb0T27c0Err5AoipgdgQyECd7ObCltGJYj8
	lLWscALjwqhXFo0PFuedshQsuDdmaAFK8dpWdI+GRbPJ3KcGtE6vvs7nzKWA204KVuE/4X
	3w4C1Hv0WkL0mew3LzVISyfmiDaRiAo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=pE7M49Qy;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=HJsIgPkF;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf20.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793458763;
	b=lejiz+cKLfRHTl1rLqkiiCEDgFXRDuSc8RWHJkhwY3tNQmYYpwv7EQ8108fFDxEjwYZWDm
	RwME4BH+qMZa3pxjHEw1VaVWCLZqTq9c5asgir7Z3UzxpJpGjR5OjoY61mJsmpBbqxU1Mr
	TvXD/rDMB0KGHA93VaUrMtJDnmgCCHc=
Received: from pps.filterd (m0167069.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69VDmiSQ2738984
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 10:59:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pps01; bh=if99jRjTkbW+bMd
	t3bQMbXM0UCEb2EHx3ismkh4nY6Y=; b=pE7M49QyW11myLfjJkWPCHnqT/G+Zue
	gmLqfmwv/eRzR2PZVYBFSw+DF576xCwH7mbdMqUkHLWVHv62oRjMLK/5DnCIvnFD
	W4Se6NbfQF17OUYB3cGLsRvdRidwozUY98Y9c05+ISE5eVBOSgcT1KHsS1kLQhJ2
	Yr6k226bVBNcwz9c4f7ITnKUQ69VflwAQdr+8VIiMsQyIuyI6ynWAZxXUwnHn1e2
	aODTz08RzMamb3M2YYUPhOMlX3Rq7gMrJeQMdfa+VOWPfJiMdXgezI1+nJL0ZRPA
	4S10e4jRffxKeKDFxwn1Xt9pSVPHrG9T5zltfAy9+x1Wf6BmuVc2E9g==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4hn9bet0j3-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 10:59:20 -0400 (EDT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-93f5844cb60so339900785a.0
        for <linux-mm@kvack.org>; Sat, 31 Oct 2026 07:59:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1793458760; x=1794063560; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=if99jRjTkbW+bMdt3bQMbXM0UCEb2EHx3ismkh4nY6Y=;
        b=HJsIgPkFxkMdvufxeC9cKydJ6Fo4+behUsXWl8rajagkooYFxWMEEuQFfWG/JWU3d8
         /QnugTxqTISWNkQF8e+7NtTp58bt9x0BFSOjPyHZ3ljB2RaV9HLXnY1MgtsEIylQuFDS
         0vYY20s688zl/EQ2Of4eMElmcmrXvUDKeK/YwnHEX7YB/fEKioHHxwI5VEh6EwYZpEt8
         bKtgn/Wp2hh2AOiUcE0II9PFRZOZITK611Yf0STs8I+OgsaJ9B7WPrvVYwuMG3fFF7A5
         wIg13dNB/P3U2mAVtpJbJh91oMaNCWtT1Tv75YT1/J0ZTkkmyzNj4zLL8Pko3rHaf5co
         p8kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793458760; x=1794063560;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=if99jRjTkbW+bMdt3bQMbXM0UCEb2EHx3ismkh4nY6Y=;
        b=vYkmyJG0xUApzEvqhbU7/DS8UCcMoWkhAt1MN8G+GFlq9PxKC/1khCh1t+vD78p3oh
         HBcxPVdsvNYYB0ybR6FOLth3fzO5qELawKBcKyge5gQulTjpw4igVYEjUjLm1664Ef4o
         TbZdnMe/J1sK5bH0483ps+4Jdu3jZZHnK4TWf7Yw+H3xb6dYRp9LWxc94dGz/Ua3TLF0
         SW76dMN6pE5JC7IhJqZheh1XxvAZiHQrCvEZ7IT3+kGOlpifX99FxXb0Q7hamaQEEy+H
         ZsWj+itn8t0Qwk8Qt76DEred9589ccjjrWznosvsI+dYqdz166hrWO7gkVbfJAC+zwwR
         lc0Q==
X-Forwarded-Encrypted: i=1; AKwUvBwy8VQpX36kH/bkIo51Q63I3mLEcUtPkYNGD/uLRYaP7O3y0YevTm5pbiLo2rptDuQadok6qQ7/0g==@kvack.org
X-Gm-Message-State: AFq9FYLzZbPqcMih5/0AUF4tyYn8KpI1HH5C6P+z9f4FKi+56yyjM6Pm
	JiDBOk+23S74ghPPTI8rybyPsi286ISu0oZYehoiP0jV6vxQ3QDcNGP90hW0egRD77v3G74Ce1s
	Ns7Y4+q+TKA/5CW9Mvj5RVAUjwFsRUIW0ZCFa9I/PmfSg2J4c
X-Gm-Gg: AYBFou1iq2FXYbH2fm8MzmaAlhd7bcwbTpWkDGlaC0ecqPTtcDm/BPWX7ZemEjcCj++
	8uQlXmw0oRNd8w6z2uL9a+xnaqLrctUmZgLKRexZ5iarXbv84bKnP5ahpNA1ZbOBLlUwa5quI4v
	fUHIncGN2gjWTNQbIGux058eUA0+b6WPOBOwd4M67rWgY9kE/uRsgOt6AdhsX/Gwd7NmBMKyH9P
	O9KIOKhWwI+AWbLWjGC4yen+qIQn3B2kT/Jy3MvNLrk+4o3D5bLqKdmUWNh7neSFVUfqDDl/Vmo
	2Q7TDX+jkgRorbAFDRERpbZtufgSeDQ8k9LPFNEdt+Fi5RrDu8nGtPiJLuvp7kLIeup45CH0nuU
	Jl//93lCxXmfWpAcY1AJNGw79O0frY4p9rve3AMY4jDnq23/pchN23kwEkVvOOKBCQRQphnE=
X-Received: by 2002:a05:620a:4d94:b0:944:1e9b:e674 with SMTP id af79cd13be357-9441e9beab0mr653736285a.17.1793458759738;
        Sat, 31 Oct 2026 07:59:19 -0700 (PDT)
X-Received: by 2002:a05:620a:4d94:b0:944:1e9b:e674 with SMTP id af79cd13be357-9441e9beab0mr653734385a.17.1793458759237;
        Sat, 31 Oct 2026 07:59:19 -0700 (PDT)
Received: from localhost.localdomain ([37.142.159.89])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4ac09cc3e9asm57890975e9.3.2026.10.31.07.59.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2026 07:59:18 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
To: Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Xu <peterx@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        tz2294@columbia.edu
Subject: Re: [PATCH] userfaultfd: clear uffd state in child PTEs if uffd is released during fork
Date: Sat, 31 Oct 2026 10:58:35 -0400
Message-Id: <20261031145835.960656-1-tz2294@columbia.edu>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261031-uffd-prot-bits-fork-event-v1-1-3572921c2111@kernel.org>
References: <20261031-uffd-prot-bits-fork-event-v1-1-3572921c2111@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=d5dgWhjE c=1 sm=1 tr=0 ts=6ae60248 cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=P+xgYyhW+KadpqoI50EQPQ==:17
 a=660iZSQnnn4A:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=JR4YdQiviy7OQf72WyZ1:22
 a=VwQbUJbxAAAA:8 a=d7BrdpvQtwasfi09MFoA:9 a=IoWCM6iH3mJn3m4BftBB:22
X-Proofpoint-GUID: UIq8HPrD_YykvkiLDtQLRZg8clK2EKDX
X-Proofpoint-ORIG-GUID: UIq8HPrD_YykvkiLDtQLRZg8clK2EKDX
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDMxMDA1OSBTYWx0ZWRfX9/s0Ttn4W3me
 xPGrDymFeZ2tBr+CLs8uW5K0KCj0/53wHXuoF0E1lAiAE3aLuk+j46GlnemVnKuz3pTpAZ5EEmZ
 ROg3vjdw9b5flsV58IuT91aB6/e/7hIi9t/XNO325DbXQmmBxoYc
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDMxMDA1OSBTYWx0ZWRfX08DhJXqDjAEM
 1sNfAroXMz9dF5M8FHuyol5tds8Pov2ABaH3aelpLZ6Gu4NnJRyRsBMgqMYwLawKMxmizjLWEvb
 HgRa7JNza57uUrQlzWCfBLMHRRw0ja7vPnGTPoNX0JcD3xYxJpIEs8NruuGwCCanqRadmo5isJw
 is3yNguZhZnRZefE1ihTfY9k9B7RRXPbh2BF4GHmfeHa7YptUULmdqNquZIxNtYOlceiO9eoaJK
 30CUzDAmPAUrZPHXO9YqYm89//9D5Tjd+7Reja0St3so//x7EcfAz9NUfPKdaNwqhiQljbSv90Z
 1eoQjKA3jUJSIz6Oxyh/2GCTlgQJW4BDLbRE6bZs/Pp+c4in4zQ79msctoQzluUEc5qWSgiTwUo
 18e2p32enil1D5qIJ05lzkYwQysiF5Lt4ISzpCMVryNRC4DEDECyTc1Ikx8a29z+ayhpyCkzup7
 0o2O2T7zAsDqoouSCiA==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11952
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=10 lowpriorityscore=10 clxscore=1011 priorityscore=1501
 adultscore=0 suspectscore=0 spamscore=0 malwarescore=0 impostorscore=10
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610300000
 definitions=main-2610310059
X-Rspamd-Queue-Id: 858461C0004
X-Rspam-User: 
X-Stat-Signature: 6kjd3g1swnusiysahkocqm345wbfqmhf
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793458762-232631
X-HE-Meta: U2FsdGVkX18UgoTMDPqTVm5CnLCVXCeBTz7cY67aa5/3AgTwbpnoRrXH4rcyghbkdMNKqcZgbgSe9IdYELbyf/SVDskWodLKVfmYKZxz3+IX7mJBs33PByWDP/Pqbf2R92mfBT1i+ZzNQzdHimUrXRC5UrBcttem4Vi/X0I62sksXHGe804xtJFGc2MJTtRcX2hqcMPukXJ/Wk2Q1KSM+HTtiFkKSmnwkLl09bDC8TN55Wh3gwmct0jB7cRjvcuEuNNVsKAbyRHUekayVDZ+IM/eCsh4bpP6nXdkyho+ArX1oEZLNAjb8Dox/OOzFcIqnfBKSyU+Vi8F4ttxuwrGqDUqH98QkNdZWMdLo36AnQmbjI3agkUtOjx20FpcN+J/QV7GU/Sw/8sKToVC+WODFCXs87FlFLgmOYyHvfSkYKL8ccDHozd8k+gbyiyRRO7nECPXl1my8NeYbdDPYycQN46ZSsOu1prVNYpIOL9kt+GwlhpghFDM35z8MnoGIKDCJbULlIHtcsNTw9SzZPWPZA3Z8+u67Iz3uqHM2Od3j+oN5LH46lImiXceDslmCZR5kOHuIyvH7fYQcMa/rDO62CAM0K7v9Qrq8XKPjzgSP9MiQw8lQrJoJLZxgVHmzLKrHXrnUHej5/PsaCJs2IslEBbZ8W2aKOZ8hUPYRxksVTEm4QHLv0Jl9pLqToxLSJH2zlPVXHALPjtb6P+4ZECt7NVz2tR1EjJGm+U+XWZ8E9PJJXUQsAuc/Ixa6uoK13Ngb/vEgignL9Srd6vXqz6al2zV65KaIdD4XBuNwp2ntJdhKkigPR10WeocbWKjPlpB7/qeZGRYc0CsT1wXx5z1s3mOu5Cq0849UGH7C9bgIBYcokZOWxt1CVXtQsbqvJF5TC1m+BgoaDk96AIh4O+gPJelCuYAiNgEACIIS1EqznZnuqZ9i6XTzvWh2wy6Htpz59MNZ4+rKeI5+8Sa48k
 0bMOFACK
 GfPN7yYfH0+0IDU02kMbHc6NIqdTKYYf2R0P6tWCIAWy4qYi43MI5vU4+Db3KSyayZNl1CqrSxGCb6zCoFzN7nsZf5zTnmxKVjf4gbUhd5pYFxt7Wgn9NunhyJjMjPY4JavDO333MAvJL/wyOYy0CHgWcKu0XkMqUF9EvsbwQNSax8c7++0erzdMNyL4/4hYeSUdigJVP+59E1pjxuP2bsXPSf4E/PhurW76xuzQATOEw5Mmi08l4NVyVg9hEn4r2Y9WDLt4yDhfmOfpDj25oBsfI64sDhftciOmRAacaEZ1MQBN23nzxL7u8bCbLUHz2N02xuAaukwiJwyVABlyuh11IPlNB51yFidsjPXeO/DbyglHKmDUYo9/Gkd4FIvZDQqCjqd7cU1RXcKQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Oct 31, 2026 at 02:35:05PM +0200, Mike Rapoport (Microsoft) wrote:
> With UFFD_FEATURE_EVENT_FORK the userfaultfd context is duplicated for the
> child process, the child VMAs are registered with the new context, and uffd
> protection state from the parent PTEs is copied into the child.
>
> If the parent's userfaultfd is released before the fork event is read,
> userfaultfd_release_new() resets the VMA flags but keeps uffd state in the
> child PTEs.
>
> This leaves the child's VMAs in an inconsistent state: they are not
> registered with userfaultfd but their mappings carry uffd protection state.
>
> If the child registers the range with userfaultfd again, the stale state
> turns into protection the child never asked for.
>
> When a write fault makes such a PTE writable without copying the page, the
> uffd bit remains set and page_table_check_pte_flags() warns about it.
>
> Split resolving of the uffd PTE state out of userfaultfd_clear_vma() and
> call it from userfaultfd_release_new() before resetting the VMA.
>
> Fixes: f369b07c8614 ("mm/uffd: reset write protection when unregister with wp-mode")
> Cc: stable@vger.kernel.org
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Hi Mike,

I managed to trigger a warning without this patch too by using an
mprotect(PROT_READ | PROT_WRITE) in the child with CONFIG_PAGE_TABLE_CHECK:

  WARNING: mm/page_table_check.c:202 at __page_table_check_ptes_set+0x181/0x2f0
  Call Trace:
   change_pte_range+0x1ef7/0x29b0
   change_protection+0xd2b/0x1560
   mprotect_fixup+0x4cb/0x1040
   do_mprotect_pkey+0x7c2/0xac0
   __x64_sys_mprotect+0x78/0xc0

No warning with the patch, so:

Reviewed-by: Tal Zussman <tz2294@columbia.edu>
Tested-by: Tal Zussman <tz2294@columbia.edu>

With a couple comments about comments below.

> ---
>  mm/userfaultfd.c | 43 ++++++++++++++++++++++++++-----------------
>  1 file changed, 26 insertions(+), 17 deletions(-)
>
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index 3b71712edab4c..2c11ac5dad3d5 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -2220,6 +2220,28 @@ static void userfaultfd_reset_ctx(struct vm_area_struct *vma)
>  	userfaultfd_set_ctx(vma, NULL, 0);
>  }
>  

I think uffd is woefully under-commented considering how many edge cases and
races are associated with it... so how about the following instead:

/*
 * Clear uffd state from a WP or RWP range: the uffd bit, WP markers and
 * RWP PAGE_NONE entries. Call this before dropping the registration, as it
 * needs the VMA flags to know what to resolve.
 */

> +/* Clear the uffd bit and/or restore protnone PTEs */
> +static void userfaultfd_clear_ptes(struct vm_area_struct *vma,
> +		unsigned long start, unsigned long end)
> +{
> +	unsigned int mm_cp_flags = 0;
> +	struct mmu_gather tlb;
> +
> +	if (!userfaultfd_protected(vma))
> +		return;
> +
> +	if (userfaultfd_wp(vma))
> +		mm_cp_flags |= MM_CP_UFFD_WP_RESOLVE;
> +	if (userfaultfd_rwp(vma))
> +		mm_cp_flags |= MM_CP_UFFD_RWP_RESOLVE;
> +	if (vma_wants_manual_pte_write_upgrade(vma))
> +		mm_cp_flags |= MM_CP_TRY_CHANGE_WRITABLE;
> +
> +	tlb_gather_mmu(&tlb, vma->vm_mm);
> +	change_protection(&tlb, vma, start, end, mm_cp_flags);
> +	tlb_finish_mmu(&tlb);
> +}

I think it may also be helpful to comment the fork release path that
triggers this bug for clarity, so how about the below on top? Happy to send
it separately.

That ewq->msg.arg.reserved.reserved1 at the end is horrific too... I'll send
a patch to clean that up.

---8<---
From: Tal Zussman <tz2294@columbia.edu>
Subject: [PATCH] mm/userfaultfd: comment the fork event release path

Document what userfaultfd_reset_ctx() expects from its callers, and why
the fork event release path has to unregister the child.

Link: https://lore.kernel.org/lkml/20261031-uffd-prot-bits-fork-event-v1-1-3572921c2111@kernel.org/
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 mm/userfaultfd.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 3b71712edab4..249f3b4444ab 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -2215,6 +2215,13 @@ static void userfaultfd_set_ctx(struct vm_area_struct *vma,
 				 (vma->vm_flags & ~__VM_UFFD_FLAGS) | vm_flags);
 }
 
+/*
+ * Drops the registration from the VMA.
+ *
+ * Page tables are left alone. Callers must make sure no uffd state is
+ * left behind in them, either by calling userfaultfd_clear_ptes() first
+ * or because none was ever installed in the range.
+ */
 static void userfaultfd_reset_ctx(struct vm_area_struct *vma)
 {
 	userfaultfd_set_ctx(vma, NULL, 0);
@@ -2997,6 +3004,10 @@ static void userfaultfd_event_wait_completion(struct userfaultfd_ctx *ctx,
 		set_current_state(TASK_KILLABLE);
 		if (ewq->msg.event == 0)
 			break;
+		/*
+		 * The fd is gone or we are being killed, so the event
+		 * will never be read.
+		 */
 		if (READ_ONCE(ctx->released) ||
 		    fatal_signal_pending(current)) {
 			/*
@@ -3009,6 +3020,10 @@ static void userfaultfd_event_wait_completion(struct userfaultfd_ctx *ctx,
 			if (ewq->msg.event == UFFD_EVENT_FORK) {
 				struct userfaultfd_ctx *new;
 
+				/*
+				 * Nobody will get an fd for the new context,
+				 * so unregister the child.
+				 */
 				new = (struct userfaultfd_ctx *)
 					(unsigned long)
 					ewq->msg.arg.reserved.reserved1;
-- 
2.39.5


