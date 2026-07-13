Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71B2BC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:42:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 573AA6B013C; Mon, 13 Jul 2026 12:42:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 522E66B014B; Mon, 13 Jul 2026 12:42:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3ECAD6B014F; Mon, 13 Jul 2026 12:42:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0663C6B013C
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:42:28 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 733311690B7
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 16:42:28 +0000 (UTC)
X-FDA: 84984321576.21.0F2E545
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6A3974000C
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 16:42:26 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YMD95T5g;
	spf=pass (imf07.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783960946;
	b=wxFmkRFbRtgl6TIvG292cXUXAUemoyTE8PVhf5ioZMGsHsMqT7BWLEbI1y5wakfb8UFzeQ
	JjMrNHEYvzEWyO99bg7lDHSGUHxGm2DQEzpdkOfj8pfrpT3Usoyx8rwzktO3ty8x7OKMT/
	y9k8pTGKNtttHLEe4q24rFwU52hR5Dg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YMD95T5g;
	spf=pass (imf07.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783960946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zltyqt7dF1hkJN/jP/CdnhprTdfvpBe1oag9qSSox24=;
	b=E26q5KCBI2l8O9vfKQSM2IWOW/azzVdl64ukegvLZ1qAywGXq7U6bZgRo0PDZU5tYPr0Yw
	w0jjtjC3lE/YTczT3Ege9yZVWM3rWSZcGyz17rAwNIBQ7VjCp/6lAVtD7z0b95VlQMSfLn
	7ih9HbjtdSP6JvWB9Mzsx5q2xSFrH+E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9CF1040D42;
	Mon, 13 Jul 2026 16:42:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F10EE1F000E9;
	Mon, 13 Jul 2026 16:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783960945;
	bh=Zltyqt7dF1hkJN/jP/CdnhprTdfvpBe1oag9qSSox24=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YMD95T5gB5V6T1KmPKUt3jBxes75nLN+JrX7ufd6wzFcjrcdf4OPFO5O/6KEGbI4p
	 /qPsJdKgM1VcjGX+E9RJOqAdM796/JvnoQaOR0QS92oa5R1put/ZxPUddbroI2Tu71
	 FefurKURKfoiisCy/CjS7hvxUrfgD1Ex8u47gMffmBu9NPWCSru1kAE1rx7Y29oejY
	 7i1zDqIEnOgFDcMGP2JEkipfRSoxeoDToKGDEsej2BP1w2RYFvievCeyzKg1L1xlH/
	 YKrYIjUxFoY2yWG5K3uqnUsZ7F3Xt7FFGhZzEg5MwswwfwagH1A1r0Bqd8ZvZEmx63
	 Lmwi+0z29/2Zw==
Received: from phl-compute-07.internal (phl-compute-07.internal [10.202.2.47])
	by mailfauth.phl.internal (Postfix) with ESMTP id 2C724F40209;
	Mon, 13 Jul 2026 12:42:24 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-07.internal (MEProxy); Mon, 13 Jul 2026 12:42:24 -0400
X-ME-Sender: <xms:cBVVaunnabxwFOWElc-2hiBfATA0yTqjWE3aMVTIQndTuJglQjbcMA>
    <xme:cBVVaoKqoeQWkiAxePVsb5xWtY9UPuGCuRv4lu1mcCUm8WG1U-9bL-DnSuJHayltB
    kbDhU-jlolP3PSyv8edC4uYgNZkwxEWwbaV4_70CFloi6rugs7NFZC4>
X-ME-Received: <xmr:cBVVaraMibBRTCi72ti4GcRWQ5JyV8HJ7ZlaaQ-tw8zj4r8k8gVN2Tc0ga1NXA>
X-ME-Proxy-Cause: dmFkZTGMoWnWRGMKpgIRcZga9S7P7sHAGK5d+gFuMURcEOT0aJUrqozEaYj6fAMVLY196L
    c7Q9Qx95Y6WcY327qRelJqkKmKiY8PyHcdZc3JZu/hVxbAUCmEOUcUUvGZPJlzK+Zg1A7p
    E1M4Hr0gckN5dJRqg90LQ0EHm2k1fI/i+fUhPF+S0gisFoPy96WSVpdPglvA43z/98UfZS
    77zo20OTGrNknxecuDjYSkHGwSxjzQ1LYlvgazPzK8oFp3YKDb/rYy0YfHXnH6tiE3ZJF7
    ZokTq2XxIK+Yzvex9+lS2uKqt+BJb+586vgE/3bYp3UeKEBWyikgLa9l9cHHjIxzYEIHil
    oF2jNkQA3L0opoOSBPQ21b1KwnAtX+7mm1hI1VkIvCQ4Sd8xTjNlbp2bhYvHJ2okcMR4ns
    hsRCs5wvczPDK1sHUQYigsqKB7ZtUPERQqVE+pr7t0diJqU2CJ0D6rKy0JLWAbPnh0PP+w
    GMO82NWmJpzPCDTYl7tKUndgaEXCJlprGOkG6oO+jiyNiJ6ompZ9Gl/0s/kkHRKHMwro8s
    R9WYSyj47gkweDae0dm64/jnpgoYlfQRkSg8eWsf6jTGBGtei9aL7PRaOPj+mFaLXnfhGc
    FUKxgsObsfGFTX1wCE5bSoek7+u19U/q8fwZmEcgbsplA5BpMngGDPZ0RlYA
X-ME-Proxy: <xmx:cBVVaszZU1TD3CD3AsVnwyX518CY3FWJekcfZ1uGZO0tyLXOt_73IQ>
    <xmx:cBVVavY-_LVEzdVDUJGtqVbrXGgvLeKIZpGs4SCglyb0k4KXp2XSCw>
    <xmx:cBVVajXlPXaX2BcJ5bBNoWT8IgmSVzr_trhD-_ioOaq5hELW3DCn8g>
    <xmx:cBVVaqFIKNFRiu1WcDspECKkHRpK8vBhy5plkTOPM4mCrQJ8NdAXpA>
    <xmx:cBVVamEIjRt3MpSq9SGrtev-xed03Gb6y-njY6BZpA-E3wjOpAI01VIx>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 13 Jul 2026 12:42:22 -0400 (EDT)
Date: Mon, 13 Jul 2026 17:42:21 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 	Suren Baghdasaryan <surenb@google.com>,
 "Liam R. Howlett" <liam@infradead.org>,
 	Vlastimil Babka <vbabka@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Michal Hocko <mhocko@suse.com>, 	Uladzislau Rezki <urezki@gmail.com>,
 Toshi Kani <toshi.kani@hpe.com>,
 	Dave Hansen <dave.hansen@linux.intel.com>,
 Andy Lutomirski <luto@kernel.org>,
 	Peter Zijlstra <peterz@infradead.org>,
 Thomas Gleixner <tglx@kernel.org>, 	Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, x86@kernel.org,
 	"H. Peter Anvin" <hpa@zytor.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 	Will Deacon <will@kernel.org>, Dev Jain <dev.jain@arm.com>,
 Ryan Roberts <ryan.roberts@arm.com>, 	David Carlier <devnexen@gmail.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, 	bpf@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org,
 	syzbot+fd95a72470f5a44e464c@syzkaller.appspotmail.com
Subject: Re: [PATCH mm-hotfixes v2 1/4] mm/vmalloc: acquire init_mm lock on
 huge vmap to avoid ptdump UAF
Message-ID: <alUUfGnM_vbhOTVK@thinkstation>
References: <20260712-series-vmap-race-fix-v2-0-ad134cc3a12a@kernel.org>
 <20260712-series-vmap-race-fix-v2-1-ad134cc3a12a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260712-series-vmap-race-fix-v2-1-ad134cc3a12a@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6A3974000C
X-Stat-Signature: kiz8nq48rck73tqhe4uygi93zbycxwxf
X-HE-Tag: 1783960946-520727
X-HE-Meta: U2FsdGVkX1/PYiLyGJfcmNzJ9WnIfFkjWP+5wDkcgzHqNQqgSW5eQ6waJIL+tz3PE0w9QkaOHlmgirixNU3A1qAJhqHuc17D59RIqLCJ6Y/aFM44WK4FwDqZJ8A4Fku8YNjOn87ezzHJGUzDySpRekCuOlCwZTP+Ex7OacqldE3r3VM7ED4fsGc9e12rIHovmEvILDKZguazEPUk5bxrSAtJp5S+BJ52wYBV5+7QhEMIN4BZizwLWDWD1AYcUfG+uBBVg8aYhU32Nr980q9ZbMk8mlnRykn+z3EAR5Jgl2zb3PzLtDdd51Gl0WXGTuDy0SSTtonhST5yMMLXohXq2SATN64n089FxN4usipzHajjlVUtHyOWa4E4i4Fb5gY18+ZCTfPV3UcQYA0PzdYdkBcTp5q47GQautKbfeUhDtxhlyQb0AHcsdzzRuz7GLoEJb5gX2oNv+ZvgjpSr+nKd9mQPUul6bEyS6K4J4R+kuWO6Oh/cI/sA2Hq7FQox+5vuGdaNJ/RL9inKKh0RKKjaQ9nkZKPjjYeC7oGmRvgJr6NbcjBs7aLS96QqPmCl1faqvfYLZu7vyNiCUpa/3HL17aUzLdAFIALfThRnb1vMk3HpdsWxd+RywSQrFLbmTljaonPAD1yOtN4H5kgDlhKsAyM6fgu0bqhXx5e+pNIrxklv7rZ4/bQFHtIeas7I40aguwb9Fjzlt0sireesSPr2+Fm5G0aG+Mdby+ESbM0HDImn0VLEeU4+WGZlm8h30/BbLIZWUdDcJ+cpyK9kLoLxzoizsXXspSFtY8sevVcsus6yOuvghy6U3XBZwoo2pUg7FiIfqB7UYPqXbgLVgw1DwzIZZjRWYFir37fmt0TNJtxwoiMJ1ekZPi0/jXSellukQTZ5RDEy6sv+t/q97895CXNOrt1R0eZZTsAhuNgV0t1aJ7t179svJZx65yNlAVoGtiKXMJWbxd2jBZksfi
 5un4ylWh
 38prBy5CYaHa/1oEplSYWPzFD0+69na/kdh1n9YTZiNnnpuoi69dU5ld2cCi0SlyDKiK5fOpWooetjqvvP/a1SWAiMhNYpFhzkKBBAibAntqRxzwci9G48oB8zS9/VFKQ1ihlHXvI2goECfr/EvXpGvCpcwYkIxzy7J/RCvJVCtTBsbCd5kPJmVycXpqUXGjBRsYsOgcKOV0ge9kz7MwMeFRBUz7XYKj6fgEEQ91+/X6bv5T7rUzCiodBkpkOQk7KZCNlIH/5u30AyCGklxsWUSawr8yMJz402aVOgvakNFHVrmghS8N0aVRSl6eTJdS95ztDgbslF4dCd20T9RRtKUfQCx3ncU7+GDin8NzHtPTKlkMrbtIf2N99i4J2aHBofhNMLIb4TRZlNfQZnGkNCBayA5K89xRj7lxedh3tQTK96LOGemtnf0MG5V7NnqVmWuUHWElBjU7DG5k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jul 12, 2026 at 11:42:24AM +0100, Lorenzo Stoakes wrote:
> Currently there is a nasty race between ptdump and vmap when attempting to
> map a huge P4D, PMD or PUD entry.

<... skip 145 lines of commit message :P >

The code looks good to me, but I think the commit message needs some
love. It is long, and the pieces of the story are scattered: the race
itself only shows up around the middle, after several paragraphs of
ptdump background (including the arm32 and EFI notes that the text
itself says are not relevant to the bug), and the one genuinely subtle
part -- why the read lock is sufficient -- is not spelled out at all.

Something along these lines would be much easier to follow:

1. The race, up front. Diagram, if we you feel like it;
2. The fix, and why the read lock is enough;
3. Why a trylock;
4. The arm64 wrinkle and the temporary ifdeffery patch 4 removes;
5. Secondary changes (guard class, walk_page_range_debug() assert);
6. History, if you feel like it.

Point 2 is the one I care about most -- the same reasoning would also
help in the comment in vmap_try_huge_pmd(), where "Therefore, acquire
the mmap read lock" is doing a lot of unexplained work.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

