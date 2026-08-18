Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03A99C5DF7D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 11:50:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FEC86B0186; Tue, 18 Aug 2026 07:50:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0885D6B0187; Tue, 18 Aug 2026 07:50:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBACF6B0188; Tue, 18 Aug 2026 07:50:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C4E9F6B0186
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 07:50:42 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 22409120718
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 11:50:42 +0000 (UTC)
X-FDA: 85114223124.17.2C2490E
Received: from fout-a3-smtp.messagingengine.com (fout-a3-smtp.messagingengine.com [103.168.172.146])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3D7F01A0003
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 11:50:40 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b=HRtMPSDb;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=PTOtcQey;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.146 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787053840;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=HvALgY+C1eQVkG6C9K+dnVzA9fN8YaCd9+e5MyvHjUs=;
	b=tnpzxYgGLSzuwdOGoH2KUECTFkWbV2t5y8v4F2FRb4r+LZiyAXp3KJ38C7Rte/tE0M/zqM
	w94v0hkaw3fd1D66K5W3HifipEAP0RYI/NaxSneR33k6ouJXQOC5n/ffXEq1TlmLfM+ldB
	3rQxuyqfYnP0zfgV8PwHdv6c9ES2VVs=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b=HRtMPSDb;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=PTOtcQey;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.146 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787053840;
	b=oVXF4PBYzh+M8dAho8GjvaGIYzWhdSibydxBEUP3UbG4z9jGbTAJT/N4qJXiIUuDqkU/YQ
	//SQ0Ehf37fc+mtL8w0csZ8aIB2ayaUEr+Pl6/h39R2dVNbRVM43dBSlmTLAMzNe1lKT/N
	9Lh9+XXZKbHgx208QWveTPMMgsiSW/Y=
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfout.phl.internal (Postfix) with ESMTP id 967F0EC0210;
	Tue, 18 Aug 2026 07:50:39 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Tue, 18 Aug 2026 07:50:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to; s=fm1; t=1787053839; x=1787140239; bh=HvALgY+C1e
	QVkG6C9K+dnVzA9fN8YaCd9+e5MyvHjUs=; b=HRtMPSDbui2lxRWQkiYRushRaO
	74MP3LGfESpHZLu7wj5GgItyyM1MvnRVr9+LJ96XYRy/eecfeUYuyZCvtHpDaOx4
	68eDXW5CBkT44Eq8hRhAe4qdADD+MTloHh06wikeTj7R2Y/U89sc34DM4vvq8eAn
	/Pc5oFXNbcvNPynjYxEI7+fTs8Q6MHCGcWZh4lqV01VAya7vFBVg74l8BOR2VJkU
	5yuDXWcq4Qu8Wp2U/U27TGsnFdIGQpvKjI/DyR01vuNOAZI5obDMG/DXfKHVHS1Y
	wetcAW4c8wwtQJw194EU1TIosVgRj9wIFX3cMX0BpBcQvomb2MxaVYm1O3WA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1787053839; x=1787140239; bh=HvALgY+C1eQVkG6C9K+dnVzA9fN8YaCd9+e
	5MyvHjUs=; b=PTOtcQeyF9x5tvF1B0tKOr3CrOb/ITAVsPSOurT8uY1T2lVEK22
	uSeOohjSb9j+GelbdyigOwkY7Qoiig7r+Du/JUJqXmWOK/owMLdjpMeNALFyB1Wh
	96lWjAnIyze+YnNUAlRj7F/ywR+MtCOdO6gLtLc2gd4UzYwJ61zvMJ5wFpfxnpHa
	zWTyEFLtUyBp+HcFQCtXUJ5CErXtvXrUg8EOoQ4AkI991yHaTU/pTMv8Nw9lnm1H
	VLlCV2XmaaPKmEx46qWQNtnZDwu11l0VsPmscW6NDxJD4st090kkbBkpxEBC4q2U
	Yc1m9w32p745KmYUPaItpzj3V81biloiIUw==
X-ME-Sender: <xms:DkeEau7FZFCdgEhppQwnu1Em2yCQvlh4tKPNJOPkwwo2sXIszpkaTA>
    <xme:DkeEauSYjvJgKOdoffXwGoAVfz4xOvmNj5mhrArhZnCnJbWmSxXhC6r842kRl0dN2
    acbJ9QSaLelIlfA2i42jfgXpkbOcEtHFLOtS9IMNqWQBtmNuDEsomhS>
X-ME-Received: <xmr:DkeEapsSNIsBPYlPFIj_SOxrzJKfGZAZaMilZVg92NUe0Q8VPSVtlpgQUrs>
X-ME-Proxy-Cause: dmFkZTGsabZgZYsehve2zIUhKVtgavvsURXgt8es64sUN0FMk0GnUGY394O6bg1Hdic1L8
    kwCIsuGBUxMy6SYl7cQ0avm76YzMS9JksZlaGWWbYuuMLMx5ipCokj2WSCYs32Goibva/k
    V8ImNigIwOvBiBi6Ga+knUrq9pgsuA3C7oqKUkfveQpVJJsXur1WUGFd6eEHbmijFPn/Yk
    p+qPNyt9gtCw3MeqiLezo8cjBU+LEWGKirBh10+zenW8B3o6U0oKI7mxYdVDNGvGveNqGi
    bUnxw2DJ7C6jQk14vH4248CLV1cra3spL+XoIrk0h0n6rikyn7TKxp8APJdS/t+UBkIsc7
    izmwvwYNxUhOhwPJq43Clar5erF9KsaHRfH3fGMMUeaXBhtR6PtmnMKQWY0Xr6v9sWpk+Y
    QHdhoE8rpFD5ju8dUxM/lz2MvtuWjHO9NFI/Az9TN1Nw0Mf7XjarN9IPYY5syPKx9k4wD9
    PcakzjuKdC+fvnWEcvOIrOk5mR2KV0Ij883/8g/g+9/W0FnSeOCtJ0XARebaJZSz7/32Uu
    3dKy8mkb+kgkFOV2QSjtIKkZbt4p78WvSIrGN4KzqUx30ppcN4m5C12DRSgKL18h2lIsQx
    Wx0wg/mxnqVm2B3cU90EUzt0wnuABPTmGhvQ/KXHKF0Lv3X3on+hqDhxmRbQ
X-ME-Proxy: <xmx:DkeEao_NNAS-Otmhe34Qlt27JCA4KkW7hor1A-xvJahGtHvpqR3R3A>
    <xmx:DkeEaqwK6FXx0qeeOXAe5ndRhL0AjthThLpr6z8q59WYEAaGEeTw6g>
    <xmx:DkeEai9fnRmNxy6oKWG3hbPIiZ0uqxATE8h8zkxm4pCciv9K3O3z4Q>
    <xmx:DkeEagOkx0b-4Hu0df2sHRd1O1QzJLY65h9Byc3fd4bAu6yL2JgPiw>
    <xmx:D0eEak4XFgwevBxcFFvzzYyB43_FWd_vpdHEWnfX0IVbxN4vpywKVDgh>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 18 Aug 2026 07:50:38 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com
Cc: ljs@kernel.org,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	youngjun.park@lge.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	kernel test robot <lkp@intel.com>
Subject: [PATCH] mm: include swap.h in swapops.h
Date: Tue, 18 Aug 2026 12:50:26 +0100
Message-ID: <20260818115026.656406-1-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qd61uf8w7wohtxmxdqobi5jh4qtca97o
X-Rspamd-Queue-Id: 3D7F01A0003
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787053840-410397
X-HE-Meta: U2FsdGVkX187qlq9cnkJVT0cz3sKbWdDrCzoMrW8vq7DaxrHT3AJW99WYdZhhzqu5nr26gx4Mn2Y77PtgjHotVfYMXJYX1ywiRV062KhgpK5PDqWTY7QqdIw/FnoHiqiUSS5OcZnW7EHt0aJgxfoIEo6SDyS5Uaj8LoohU+3/MoWH/5znbnc9LvAm7jCMFXpIx1s4u8sftMp2KS4VMYsvceVgg5fPkec8g8BU2Ia9QPFqSZ7sr9ZXpOktqpQEPLVinX6zD6MmV7vd/yP1K9SamtbqmuPhwCJCeQ/LdP5FYE/qcKyWXKGrORxpukGj8/w+74SpPGy7QLiqUpD9wMf4eFNmxbMVd2zEOhvA9hpmN+QvNL91NGa5gT0wVT/DMFyt2S9wUeLz9icwN63VdnlLmIdMQZ7SwjH2iHlQnTVocagK63pXjuDEi5hTneFktgXa3tygQF4gpACnsu+2u2oWRcC9rswjbpVrjq3ZwVDTpeGP1tj1NCwln3CegpZJjKvUDSn0DiF0j4ZoAc4JtF5vSruOuYhamQdCdCckK6LzdddLOiimEY+JJ+WHjqp90di859P0LJ6GyAA0z+TPVeYTtXigWEpQ8Bfw2alkCtdqOBdMWRljLLp7HjLWZvnjl0BpijIQbmm7BvXdZ4YQldnDSF9jsHPtjnI5l1os4qE5p3wgPfVHwzcyzHF/TiAJ44YlkokDczAlAxfb0yqP9SmR6/utmjcJtpCiBnGfdYLNc4NKoes/s27PYzZ13zRL6iDQHdoipNOOtEz1I9jSykZYfVaTY7WB3vNTuYHdd42XR3KtcfM1RzUHELoOTIWxYMxnOE01UGFTWDXis8b6/VfvfuX5sv3qA+ttKbIyu1LPV4vq33twyXIY+u3SUbaOV/h4TRC6EYUboIDo5sggHJO91Zuhk3QytrAYPkg1g+5uNPUFVQPz0/61PxOeXnyrMsffIlUCez/5EFaRJ309Gk
 /p4IQu/z
 SfcskugAyrCwYBcXaj8Q/DwJo8ennagxWR+uTh+4eM+M8seYJE09DjMANWFxmIN2WAweVrt/oemXVTLkn5hI2s//nRazE9ZsS5LzH1Nk6lLJs1GqGcrlIAjcWxFlaYtftliL83oiS7S0D4KWt3Zv/3IEyAaeFU/GK/9hmAauRy3Su3tGrAbJHZdY7zoXnKteGmh0XnWFhvrHy9c8vgxczeg+86nCqKuvdB0lau6NV4YzNoWvIoNV1AfX47FwcuWXrsqFbWgOOchippLYs/IrhHvGUXgPHJ7TqMpAPkZLeFI96YNm5g0uiCEVJNeD4WMkY2DLs4DeDFwbyQNsutvqI9rXyPXP/N3zO/tMEblPqnfDxNT1mnUL2FuKDDhMVnW8uj/udiqufUD2XzUrOKdknpJ5ezT/B10e1l+clKSCNzs7fD+hSX99yVWM9CT2k/9SFG3CcYBee7TgrFcs/i8rKEkgamc1qM7Oh8VUD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

swapops.h uses MAX_SWAPFILES_SHIFT, SWP_MIGRATION_READ and SWP_PTE_MARKER,
all of which swap.h defines, but does not include swap.h.  It compiles only
where the translation unit pulled swap.h in first.  leafops.h includes
swapops.h on the line above swap.h, so a file whose include list reaches
leafops.h before swap.h gets:

    In file included from include/linux/leafops.h:11:
    include/linux/swapops.h:88:21: error: use of undeclared
    identifier 'MAX_SWAPFILES_SHIFT'

A header that uses a definition has to include the header that provides it.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202608181757.mza9RRj7-lkp@intel.com/
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 include/linux/swapops.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/swapops.h b/include/linux/swapops.h
index 1f3ff3b93e16..e7d0d529f3e0 100644
--- a/include/linux/swapops.h
+++ b/include/linux/swapops.h
@@ -5,6 +5,7 @@
 #include <linux/radix-tree.h>
 #include <linux/bug.h>
 #include <linux/mm_types.h>
+#include <linux/swap.h>
 
 #ifdef CONFIG_MMU
 

base-commit: 33f61b12d297562321533c048e034b1fb21c1cf3
-- 
2.54.0


