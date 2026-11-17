Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91E36606A8A3
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 08:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=PJmFodkO
Received: by kanga.kvack.org (Postfix)
	id 7D7AD6B05BA; Tue, 17 Nov 2026 03:31:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 787DC6B05BB; Tue, 17 Nov 2026 03:31:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 650686B05BC; Tue, 17 Nov 2026 03:31:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 30B886B05BA
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 03:31:48 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9B6DF80374
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 08:31:47 +0000 (UTC)
X-FDA: 85443942654.24.AE84503
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	by imf11.hostedemail.com (Postfix) with ESMTP id B013340006
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 08:31:45 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=PJmFodkO;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.48 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794904305;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TmH6s81HME+/ARGnJwgL9bVR9VW6JoGP/0HNw1M8o+8=;
	b=V9V5wbpHGDQXrzDQX8GI2gpWpiLS/vi9AT+fT/facJecq8OAE54UI1fTiwLtwGRSexy8kf
	powKiE4HQTz0akXlO/0hpO/nic4UV/9e+CQr1yZ+f0bH835AAg88DC5uTJub7qCbpCDwAs
	XhxrOQCE4UM/B9OV0p8uzzyIOCTakl8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=PJmFodkO;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.48 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794904305;
	b=NWPsmo5dyp4k7zFZDtRUXu9yAMM6xvzlPAq+qUctnhpnD+QF3DYlA+RbHNm3PTHA+JDXrP
	ujXu15mcEwvCBjxfY1uPLuJ6xOntY5I5eQKcWgnceXempHmlHJ/TJ3EJuKIV9/vaM+yOob
	aDDo8ZjqPNdAJCtC9Y+D+Fb3ZvVyTk8=
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-91ec396c93dso76192986d6.1
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 00:31:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794904305; x=1795509105; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=TmH6s81HME+/ARGnJwgL9bVR9VW6JoGP/0HNw1M8o+8=;
        b=PJmFodkO4u4+QwFYMqOSkRtJgLX7ssmCeAIdPTlpyz/zwm59buwd2eFU4ld4UfpaY+
         5PFUbee0ciHyDt5Bx+8jRA29VTyRjIVvJJfjbXFTsHsRW6pxpqZ2i0zlQxvedaAFh/4/
         O2Q0BO6Vp92SUTWS8w4Pc3ilJdM6CeB4RsuLz48MDWrOdl9mzrYAAmbyRH0ci1oJXYLD
         JJ8VJJnmh2h8lzV19oU+mz45UerTokyJNnsNk3f8jTo+VK/+uDeWAThfXLVZ5Unqbi9B
         Gn3wYtByWdO5JMQgSvF/sSbdyiJqHd16rkH1R30rNBrnuLXB+i4P1f2iAR3n3gWvO/n0
         vFkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794904305; x=1795509105;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TmH6s81HME+/ARGnJwgL9bVR9VW6JoGP/0HNw1M8o+8=;
        b=X/vymnfaRFWItK2B6+3QV1RH4rmcOmVA07cwUb+AehEWoLVX72ByrPUFUFc2Rw1dEn
         toIAx7uqOrXyGb+wH2Oz/BHx/VBdUucEPiMIdiU+/+fbXGwXxLqp9CHY9fgQN4oFD4AD
         WlyQuf3KBBslL+aPvx9cKBaF3Dz1plvxFBcqmQu5z6sk3W8fm0c508Q9O8wopeB9l8NY
         MxEtYZ1n3XJeYxwUcL14pVYiFU7sYmmQPZKLkSy3PgKefB1DmCg80YfmQL2MwNOFujtV
         /JUP5VIGftMfKPULveFRqCiY/IRF0WcaBUbB4xpeXgYmDHwjBU+bLlxiB3qrad7riSxc
         RtSA==
X-Forwarded-Encrypted: i=1; AL+hErHRUu+0HhKGzHmsButHX7+tsD3FVxihXy9MiWmsuQ13n38qNIfhk1BxYhCECjrPNqtopJ58y3gU1w==@kvack.org
X-Gm-Message-State: APuU4Z8ceAnxQIJd0Pa4QkkRdV0EE1/mLwGnoOkHCJHO9Gp2nxF2bVQ5
	/VgLwJlcwt5jLBY6lQZXoYXQ8MV8T4+ipTLmDoRc24qv17Tsra7s/m2jJxYX7Fj6YII=
X-Gm-Gg: AYBFou1mgW4KCn+6Y6c6lsPR/ii/FIDMYJuJB8/2V9b8ZQ53ZgyeSalrjs0nqLsxAVS
	Ad9MX6/Cs/d+4IzK3Aof7k+0FA69A/eLl3xHuk1EDBtVycDrfCjw6Pzw4t/Yq5K3XBjSu7Ubj96
	vhcyA8RNrRw0GUHGSBStWIT/xFk6lziv5V3NdMEUO4VOuMFxxJYfYqgK/O3FjzvrbXlYU8j9UKR
	IsxNGcxjAUQP2Tz0CSNXIDdnauiyEGWGRKWLuuOl/csBkgEdlpSC830rvkq2G/KsLQVRWR74vzp
	wGnzuzSJyWAUkPx2SKlpBMLFgHPfzm1NjUFZ6cI4Txojq0Q9mF7po4QIi8vMUaKRBE3l6DWfBVw
	YGrwrVVFewgqkLUVeZWRnfW8ZEZetdEze3xIHecCMcaCzGqOh4PWaqgRtBkP7UIjMd8AzFc5DHq
	+jBDEcUV/reNZ5uIECb3u//lZkZMtFmYnPBLyCCUaL86iK1zenDpelQjLJoHPSoTx7lKJv8Qofe
	YY8g45KoJ6yBJWkFFEKJ9+0bYQpI/WDJ9+LvjVvQnVCp7i9mzdl65S0gsDjpA/si7a3+Xk3/TWH
	u3+bMVoP3pL9UEyqbo5OnIflEc7fNwE7rsn/kuupFPxrx9Nz4yP94Gcw2T9farNoVk77DF46tNH
	IjonMAzKFnDGpvwbt7L2HTzZUr5LNpA==
X-Received: by 2002:a05:622a:258a:b0:55d:30e6:8d8f with SMTP id d75a77b69052e-55d30e6a736mr108004181cf.59.1794904304803;
        Tue, 17 Nov 2026 00:31:44 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-55ad0a2006csm99694361cf.10.2026.11.17.00.31.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 00:31:44 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 07/15] hugetlbfs: fix unmapping folios from private
 VMAs
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>, 
 Andy Whitcroft <apw@canonical.com>, Miaohe Lin <linmiaohe@huawei.com>, 
 Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, 
 Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Vivek Kasireddy <vivek.kasireddy@intel.com>, 
 Dave Airlie <airlied@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, Peter Xu <peterx@redhat.com>, 
 Breno Leitao <leitao@debian.org>, Will Deacon <will@kernel.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, Arnd Bergmann <arnd@arndb.de>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Gerd Hoffmann <kraxel@redhat.com>, linux-doc@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-s390@vger.kernel.org, 
 Josef Bacik <josef@toxicpanda.com>, stable@kernel.org, 
 Daehyeon Ko <4ncienth@gmail.com>
In-Reply-To: <20261116-fixes_hugetlb-v2-7-4dd9e94ea9ac@kernel.org>
References: <20261116-fixes_hugetlb-v2-0-4dd9e94ea9ac@kernel.org>
 <20261116-fixes_hugetlb-v2-7-4dd9e94ea9ac@kernel.org>
Date: Tue, 17 Nov 2026 03:31:43 -0500
Message-Id: <179490430300.482102.17633361840450824485.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Stat-Signature: 3ghdaj7apzd3z9gjs5ggzz9st1deutk5
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B013340006
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794904305-581329
X-HE-Meta: U2FsdGVkX18O3yiunG/nTrfyTjWhqGVcfckS87fdT8zlfLYNPhJHU7Smi9GIDqh5dtsrZQjN47gQ0pb8uWbUOTch/nm703bsVAiQXOXpXn55EIBSij/eZHm2sTQcRGbdCU2BOAaxM6jUSh5fdviLYbo0GUkZvMxeYI++x1bjNMekLcnQMNtcLnxmUJFBQk8Gcd81Qi0KPyBxldX3v8yQEqTPBxMYJDoJvc6uG4a9Bv6M0yiXeZTXYETJNNMK0SqLgBOsEhL98zdB6EUErJymEeZpJreoUkjPDteb2N3JvR8c+4qx/jktGaHiOjceKQ+nFonreeWHiLwckBvDbi404tMS8JvnleUvFY7nQoU+ib4e9HqVwVRnfxUf9tfHiPxqfzRGKf1YlkiskaUwFs5ruyMYxOiA5PGt7qQkc12q4m+Kzqi2NbdTFwoujFUHKGj3QWk64iFgZGnyzj6y9wmFlCrLLzUi4fkiF2PPOxM5LXLc7lECZR5GIBw9rD7geT3EKdVgkr2UnADhvQmf0531GYCLUldGeVLdzT8/01WEMmOCiiSCcb5GRkLGIt01ASeVy+N9BDYF3n63exQf0QxVT9hZ2xq4JtKrrab7aa6eUIEkb0iBcBNcUiDCr7iNUOYpSFEQA4L1vmiU9MmjEERjHvx/MALmYaVxvPuNm7d7lSJJfJBmBOXs7a645753RjQBRF6ZMHTOqZKg7HSGOy0YP9yufTrjadguzhvBUv/jdl1+owjPCvxpBktof4CaCgrs/szuu6k3pmj9pK5xhx4fL+FhrRtMDoQb6KXzteozP1nMVwZJh4jYRpkJJbBCyBwiNTuWuTtYvz0GWSXobp9vPnNvUsW8tdlEcrhW4ATzQEOi3XLIBnPqnn+Ivr74kvhZ21CiyqWl0PB0XpmlcFAaKd4/4rt7Ddf7LWw4ZFv9PW3ZnYzar9lQNpq4QR42QdMjczmfJVZSxT0CqiGhTOg
 yvDnAVEz
 UcU6W6zPUL4LCShkQnUHyvlTBSIV6Q7c5SDTrOH1xZMI2FV05xwl2uR3RqWrcjAqxzS5GaWRQJw8EPMua0iu3lkRDrO1pTsxwRKhWivhR23q6tJfBMjKVwQJj3/ZXdW/u1RBLq2+fN31wNuKCQQhS61WKFesMvrAh8YLyyqGZ+vZH0vIiVjOlug7G3bXLnyOni5EhgFAXNhI0t8TsyWwSarLTftZ7GjEBpOrjyTlYZZdGn2HpxyFPayqTw+nkogYgqTiMQ0KU0TdmzOFGfsJPoMEl/OtITMRQBPdHzF1kA+X9R61zTHThhnIhXDTyq3ljLHvNQZZbn5hH/0ifLS0jLDGrUQQGDVUNk0EWZa2bFN2We6cvP1njVt0WpPzJjtaAMqC/ruHiVCOQppr78DzvrBPDAuIFwwU5bi8RlF3StnI2GYnENKeI/iGjj1R7G+MPMSXd6uiDhEJvm9UWPx8quifiT3HF1OZ4T66aj4HkR4dYxBA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-16 19:29 +0100, David Hildenbrand (Arm) wrote:
> From: Josef Bacik <josef@toxicpanda.com>
> 
> hugetlb_unmap_file_folio() assumes vm_private_data points to a struct
> hugetlb_vma_lock when hugetlb_vma_trylock_write() fails. Since hugetlb VMA
> locking was extended to private VMAs, this can also happen when
> vm_private_data contains a resv_map pointer; treating it as a
> hugetlb_vma_lock corrupts memory and can cause crashes or hangs.
> 
> Only take the VMA lock when a shareable lock exists, as additional locking
> is only needed for PMD table sharing. The fault mutex and i_mmap_rwsem
> already provide the required protection for private VMAs.
> 
> Fix generated by an LLM and sent by Josef Bacik in private.
> 
> Fixes: bf4916922c60 ("hugetlbfs: extend hugetlb_vma_lock to private VMAs")
> Cc: stable@kernel.org
> Tested-by: Daehyeon Ko <4ncienth@gmail.com>
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> [ david: simplify description and comment ]
> Acked-by: Muchun Song <muchun.song@linux.dev>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Was able to reproduce a hang / RCU lockup pretty handily and verified
this resolves it.  Have not seen the relevant crash.

Regardless:

Tested-by: Gregory Price (Meta) <gourry@gourry.net>

-- 
~Gregory


