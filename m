Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A55C3606A328
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 00:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=xamMX0f6
Received: by kanga.kvack.org (Postfix)
	id B87736B080B; Wed, 21 Oct 2026 20:51:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B38826B080C; Wed, 21 Oct 2026 20:51:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A75E16B080D; Wed, 21 Oct 2026 20:51:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7F51B6B080B
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 20:51:17 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0D01D160660
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 00:51:17 +0000 (UTC)
X-FDA: 85348433394.18.8D36B52
Received: from mta1.migadu.com (out-112.mta1.migadu.com [95.215.58.112])
	by imf22.hostedemail.com (Postfix) with ESMTP id 85D3DC0003
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 00:51:14 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xamMX0f6;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.112 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792630275;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YnSPPvpmQOUJ4waeQ3xaQjMx8WMQI2DxpZDvU9ftVls=;
	b=P5lPcbYjQXscKAf2BGokzl20cEVjmGztrYbKcbKgsDdf3jnUUVNpRsQfJFxBerC+oDgpTf
	lvve07foi+4bmgly0nZkJ+rugV1DZZ9Pai8+h3vJkrAWva/5/H/nVr3P7fUyTzewm5+Ohi
	1MP47X7t1clcJtCeIwZfCqqf5pDLJfc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xamMX0f6;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.112 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792630275;
	b=5dnXFNzF3wq/bCk2NidGOSdmzOQlIf0eR47TT5nqxjWVo0DFWqcGhnEjxdhysW2ULRwfeV
	pBUg1WmmjN/h5TI9yrV/iOuq4OfoCP3IPe68WkKEQbHG8HdDif3kocyviCpDeC7ezKsh3l
	CotOyYkz49SnEMj9iba3XPMvhOA//Rs=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=YnSPPvpmQOUJ4waeQ3xaQjMx8WMQI2DxpZDvU9ftVls=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792630272; v=1; x=1793235072;
 b=xamMX0f6ZQj1tvTfxXMnc0w8Rx8uQHBBVHJg3ITje8SNSY/cKSWjjn/RC0DHWaFpw4XbyUFD
 Zp9eT0ZhFypfDN9ICNGIklCZSBVU0EGruN6Nk5fzk7UoyKdAPKWULJOSJ4RL2f8bBYX6eL8lpVl
 iAeN0ENRLoAjyb72wUic1PAk=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 3fa99ff370979236;
	Thu, 22 Oct 2026 00:51:12 +0000
X-Mizu-Trace-ID: 3fa99ff370979236
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: samarth.colleges@gmail.com
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	xu.xin@linux.dev,
	chengming.zhou@linux.dev,
	peterx@redhat.com,
	kas@kernel.org,
	rppt@kernel.org,
	lance.yang@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v3] mm/ksm: keep soft-dirty when merging a page
Date: Thu, 22 Oct 2026 08:51:02 +0800
Message-ID: <20261022005102.29011-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261021182157.1873726-1-samarth.colleges@gmail.com>
References: <20261021182157.1873726-1-samarth.colleges@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 85D3DC0003
X-Stat-Signature: si5fhs7j83w9ic5tmh7sgip99j35mfcw
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792630274-25541
X-HE-Meta: U2FsdGVkX1/qfGnA5zGID5MA1FhzQZ3kW3GTVc3RwpOmcgS24u89Q9sbV38sfl2nF1NPC6JlnDOxpCToy1XILOMNx/uA+AB1xrZg7gu2/gvdykmYeUzIlqUxqXdRTQdCbp+npRuX30ZXpQsCbvG5LN9c8SlTdbAzgN7njkyFK4nhHJO+e95WY6QCeTwoZPC+W9JB++6K/UDWvgrkiSHyA6ARegTqLo18XPJ71KoX1T53EC/2bkBcg9Xep+FW4x6Sm0oQVxeEZFB9JNUZzC6iKN1+tEXAG281N52xOTLzARcVRo9E/4IpqXxa3fYvNGQMBeCQazjea0dL/qBKQdbJxO0Tb5/bvoYka56xYtWV2vHQ6/25JfAmSIecqo0qn5B9qqsGUjngor48x7rtJIZkH2jeXakzAzAyef0/CR918tvNWOgLAkXrR7LKbXS3cqRUkwbiIBzLTXRcIMK3cr+x9xBxFXz8qq0XAfSaiZdHlSvz6CrBVjUS+7YgPfrI7i+KsMY0jvfu+JE0mGCzstyWSe54578xSeM1phusWKzeNF9G1E9dY7pvKIEs7PNdrCOXTogl92li+spL7A0fJI5wrn2ydKHlDYMGsDkF1d/m02E6e68kiEbPgTTddpdmXyU8KDpbw1F28i0On16aUBh6FYNyTCvlYpCZ+1aOIw6SlnD/RapaXmhmUww7fcbkjG8AhMViwyBMUr3unM8XGBrBU2tFGFL8iykFD+/jMM/r5XKFiVLsf9yPL4Ftx1wgDOzsRNkhznGAY478iJQjME56rPj2tjvE7mhqSe9qOeUCddPFMp4PTVeyhT6P4iTLC5rP2/J7kLrXQcaF7gFrhzRI8jfu3ztudkkMgYiBveFrE/vaAXEsXQ1HarVD20oXbawYEKete8WETPD6RLNM2CVkjSep7wGLfMuprqb4vcWb9H5zqCsD1O87lA30b+ghkVTxvmHpM5n2h1HvXX+Z7o1
 /nt6tFpy
 SINmY9A/9U022mEGPWjDC5vLT6A68Dyt/AP2lXBIytgE+s/m9a9B3MxDtVC1268hvsnqsjsgMSxFPzUX+/9c2IXsSCkSkJwiVH95ZBV1V3JvAvimZUIrLKlkjeuIADo7lMyafhEyMH9Zt2y7WbBphOOHUKPTBAW6M1Bp3UpO8nJSdzFZHg7bDtuVAJHqD/79wSUPGHw6OVLHLvzxYlo0tCjW5iMKoaUiIM0+0fvbcUcxFpvhb7R0Va9JNPERteCqCB9umtLQq8Nj8frnb6M6gEiZsvOMc/PpQdCfAXcqZwtAcos6XYJBGM2NMWZSTFj0XPpvFJyKYXuXWz/JFte6/38LbBMCRZPgHOWRovUkuLKr7r0E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Wed, Oct 21, 2026 at 11:21:57AM -0700, Samarth Narang wrote:
>replace_page() maps the KSM page with a PTE built from scratch, so the
>soft-dirty bit of the PTE it replaces is lost. A page written since
>"clear_refs 4" then no longer shows as soft-dirty once it is merged, and
>a soft-dirty based dumper treats it as unchanged.
>
>Copy the soft-dirty bit from the original PTE to the new PTE.
>
>Fixes: 0f8975ec4db2 ("mm: soft-dirty bits for user memory changes tracking")
>Cc: stable@vger.kernel.org
>Assisted-by: LLM
>Signed-off-by: Samarth Narang <samarth.colleges@gmail.com>
>---

LGTM!

Reviewed-by: Lance Yang <lance.yang@linux.dev>

