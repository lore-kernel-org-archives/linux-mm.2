Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3548EC01C5
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 10:34:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4943C6B0005; Mon, 23 Mar 2026 06:34:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 444566B0089; Mon, 23 Mar 2026 06:34:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35A2D6B008A; Mon, 23 Mar 2026 06:34:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 23D846B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 06:34:30 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C454E1A0AC0
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 10:34:29 +0000 (UTC)
X-FDA: 84576968658.28.8DF8EB0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id DDE0940008
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 10:34:27 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=MSY5R5Tg;
	spf=pass (imf11.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774262068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=+HPlNrd4UAudg0TOFUhhqmABgCXn1ZzMcPPkCEj7bYA=;
	b=HuDzVo4+IfYLbnuFqW8gSLKx8o+6AaGKFuGqhzQXmZVGOMSUI4VzD1IDmuqe+CKX9ym4Le
	jjyRg4BE7JhHRn8G6nsW23fJ7K2bS+JnGjMwebPwBMUeH2f71yGbTQDsQX2wq2qW22HLzg
	T9O82PGNlJXGEdww00ypnAV+F0/sR3c=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=MSY5R5Tg;
	spf=pass (imf11.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774262068; a=rsa-sha256;
	cv=none;
	b=WlJbXp2VyV4UljyrXTrDYGi9FOphA4GzpjLRAF1eYPzMMGJQfKn+8sjzbNwAs5xyu49m5D
	03M5aWOqoGGtZC57cSFgx3Fg4VgUSzPUSsxmmT93pfrdUmOZOePNHZ9Q/NiB3hZJ2KxxPw
	apijjhf58ddEDPMLvIwwX9OAcgDMlAM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D784D436AD;
	Mon, 23 Mar 2026 10:34:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63458C4CEF7;
	Mon, 23 Mar 2026 10:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774262066;
	bh=TEfPNiP0htgg1htio8O69ksuelf1fBIhKH/Q3K1J0jc=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=MSY5R5TghcKgxgiZNTA9tbITeMalOpd13pl3S4RtsD2PjgQb7FY2Rwjc/cIzqKH4q
	 uVk5WV4a+7onEDy1s6FJD7U1cUG9X9bMvsZccZsPmUfgakiNpP6xaiH58XuPrmQ6QZ
	 N4bGd2U3deDpXmQrNB1LWXWMor7LlcgjX4chAufg=
Subject: Patch "mm: shmem: avoid unpaired folio_unlock() in shmem_swapin_folio()" has been added to the 6.12-stable tree
To: akpm@linux-foundation.org,baohua@kernel.org,baolin.wang@linux.alibaba.com,bhe@redhat.com,chrisl@kernel.org,david@kernel.org,dev.jain@arm.com,gregkh@linuxfoundation.org,groeck@google.com,gthelen@google.com,hughd@google.com,kasong@tencent.com,lance.yang@linux.dev,linux-mm@kvack.org,nphamcs@gmail.com,oliver.sang@intel.com,shikemeng@huaweicloud.com,willy@infradead.org
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Mon, 23 Mar 2026 11:34:05 +0100
In-Reply-To: <49bbe4fa-b678-1023-db47-99a730e2827f@google.com>
Message-ID: <2026032305-sprang-dreamt-6083@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DDE0940008
X-Stat-Signature: bquimn3h6d43kog3zzx76nc5curpp1te
X-Rspam-User: 
X-HE-Tag: 1774262067-520899
X-HE-Meta: U2FsdGVkX1+R9tghtj/L5elfCimWK8h2xvWroEBafhch5N9oYlG13o5z5nEV2HcahF+jQNnfOrKWYHsVvv/Ow0D2Z7pDFM4W+09l3Rg7dDtgfvWmTN6zqJKS7Bcodh4QwAOO06IfOw29Dny7IawuAHXnS5atSkVKlj3kqUSbp+fHJf2gYRwgxoyjyPF5ZfKhbzXP6sGYhQ4G/R+VLpXKIuhz92TpbG74/mjQtKUvzEH4qV7x7kLWqjLQBDThruO9len7ChwFd6RwvcBEpKR37zx2opuc5wMyQQFQ3kQZ7l2S8JN05InRtYIUHZHHBpwrh845gmjqYdIdmb0Vgd14jd10AKsAlUH4oSM83IP+FVTyDr5vScArkPWyxgtlrpO38Dj01kmZkH/+O6doHgVvH4eM7FPdC/Q+mn6Dv5gUdFfixHwB65G0TSiSeMzpxJwE64gekFS2rJIpsLl1lF53FxBvpzwMS4d5qRWFxlmP49S2F/izH/WxgaAioxxzxuhcfb+eaIm9VFbUyOiTsAmgD/o+5VfYmHIse/AMIgcNYz4Sk1PkOk3XFvF0RAQTquE7u7RGTpclLBy43jTlK6IuJ+9L0a9RSnLq0hCQkqWrYXvGcd+mev/mJWeUOwPiROYM70e/VGW7jkP3tGkH4yUIlVTQsNeJalE5mcEtGk0yVmng6uwyJvQkvOuBnJxt7cjHqMQL6gv8V+MbTSAv0XAmsCniXNdI1TMW48W3/Y+Hd+pNxwQnp/k6Lz1WKhKgNwJk2PE7n5xx6YV9Ia8TZhSkC89YTVGHPfkcQjTvniVm9+TrMPbu6IcGVpBHFeW1B2DW3g1WgzLScZ/Q0xw+nWSO4Q8Gt94sDq3j5viaDlOFMvAxLD9i34f+Rt7oF8VoH0Hukzi7tjFvbuZz7ZO6vJZQ1q+SaWunNgLZp23W9q8gdF51wCOJwMfacjN93OejKs2uQb8zbyoce3fdEBCNQHO
 AeQx5eQK
 81gBdwCqWh+RY3vnj31O4/7juQdHk0LxP9t4/01RmZBQwZzeRY1Y9BvNlrgmRoY/rE+UH/ZXprOlBmDqGG208qxsla4jW/oHtqPxCQZgygI9MTclbgvRkGgeinOFVUYLs6oivLtuIbCAMOxx9jZFIZjA6Ryp95/of4Myf4NUHijNexb9/azsmk0sgEUg3Dyj5QtTEHGsmZkJVBsgPcTlDsYwT7PNFwQLWbeQN12J5jcwrOiWDbsSLbLJI4YcqKyY+hpIEf0QWwUSkN+rayjbOllUoml/tyYhpUc0rNXg+QY5M0CKcXqBUOZTw6ysnOUZMAh4JwufTlt8FA7sf7qXVvZe4ugHaBbCeC+lFuYTF6mMor3vzlt5/NJ5lviIuyxzUkJG9e3hbubqqZvzloPVg1IG/odPwR6vlrsDbu0Lm7A7EHfY+77auIzoAbLrNW4WRAFstp8wct8HBmMxOwA89K4nzjIy+BQXMyKNH9UmDEA51ixUUJ1/81/XRIi4XYlBoJWLBF1W5N1hCMSkxyykK5PPLeyLQ10yKzxBDSkqLr943LpRy0J7u7rVqfo6w/sWhXsEOm2LRMeO0sKoj3a4cvNByu3qgMqKGuskD/SM1sb3c4+15e4rEIsKnybTYuSx2/1Cwyb4l3EjMvKX+zhTEC/y4nki462S1Vxq4IC+2NUX+jmoQYP4ApJSDocwxtRktvodODiZ3z8M1D7KOEMxqIiFUPbrEDvjNFnS9qDattlxcliulpSdYe/VnTyueDA8WMsW+VR+Gjm6XLFOfi58G2y5oDQT9PRzpsm21gDTlKGm97mswgyuAhPkUqPkLsSuNPaZV95L9/j9FHUD+cjbTDtWRQkswA6D9smoX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    mm: shmem: avoid unpaired folio_unlock() in shmem_swapin_folio()

to the 6.12-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     mm-shmem-avoid-unpaired-folio_unlock-in-shmem_swapin_folio.patch
and it can be found in the queue-6.12 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From hughd@google.com Mon Mar 23 10:37:40 2026
From: Hugh Dickins <hughd@google.com>
Date: Mon, 23 Mar 2026 02:37:35 -0700 (PDT)
Subject: mm: shmem: avoid unpaired folio_unlock() in shmem_swapin_folio()
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>,  Baolin Wang <baolin.wang@linux.alibaba.com>, Baoquan He <bhe@redhat.com>,  Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>,  David Hildenbrand <david@kernel.org>, Dev Jain <dev.jain@arm.com>,  Greg Thelen <gthelen@google.com>, Guenter Roeck <groeck@google.com>,  Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,  Lance Yang <lance.yang@linux.dev>, Matthew Wilcox <willy@infradead.org>,  Nhat Pham <nphamcs@gmail.com>, linux-mm@kvack.org, stable@vger.kernel.org
Message-ID: <49bbe4fa-b678-1023-db47-99a730e2827f@google.com>

From: Kemeng Shi <shikemeng@huaweicloud.com>

commit e08d5f515613a9860bfee7312461a19f422adb5e upstream.

If we get a folio from swap_cache_get_folio() successfully but encounter a
failure before the folio is locked, we will unlock the folio which was not
previously locked.

Put the folio and set it to NULL when a failure occurs before the folio is
locked to fix the issue.

Link: https://lkml.kernel.org/r/20250516170939.965736-1-shikemeng@huaweicloud.com
Link: https://lkml.kernel.org/r/20250516170939.965736-2-shikemeng@huaweicloud.com
Fixes: 058313515d5a ("mm: shmem: fix potential data corruption during shmem swapin")
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Kairui Song <kasong@tencent.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

[ hughd: removed series cover letter comments ]
Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/shmem.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2198,6 +2198,8 @@ static int shmem_swapin_folio(struct ino
 		 */
 		split_order = shmem_split_large_entry(inode, index, swap, gfp);
 		if (split_order < 0) {
+			folio_put(folio);
+			folio = NULL;
 			error = split_order;
 			goto failed;
 		}


Patches currently in stable-queue which might be from hughd@google.com are

queue-6.12/mm-shmem-swap-improve-cached-mthp-handling-and-fix-potential-hang.patch
queue-6.12/mm-shmem-avoid-unpaired-folio_unlock-in-shmem_swapin_folio.patch
queue-6.12/mm-shmem-swap-avoid-redundant-xarray-lookup-during-swapin.patch
queue-6.12/mm-shmem-fix-potential-data-corruption-during-shmem-swapin.patch

