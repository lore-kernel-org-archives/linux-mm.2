Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C7ABC98328
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 06:48:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58C696B0088; Sat, 26 Sep 2026 02:48:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53DB56B008A; Sat, 26 Sep 2026 02:48:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 453F06B008C; Sat, 26 Sep 2026 02:48:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 202E56B0088
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 02:48:08 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 98288C0805
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 06:48:07 +0000 (UTC)
X-FDA: 85254983814.01.715D033
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id F1E2D40004
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 06:48:05 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K7hP34PK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of chleroy@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chleroy@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790405286;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/ZtlgtRXx70iH42f7yzu0ahvdG98SNDqpIESzbWq6Cs=;
	b=PsVNc54iGIq2dX5XAT5x8NnpdAKPmS5n2WBDUalQ/HuSwlL3o+ESAwfT7DoelT5fET53xd
	Shg8K0EOt6gRcOCngkNmPZicNfF/TpUH2nmti+q5p92mecZVtsXPEojN+ZXLTG8iuyy7Mv
	AGYCsCSebg4oHo/0Wzzsq1gHN8nM6nU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K7hP34PK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of chleroy@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chleroy@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790405286;
	b=WPlD5HNzdQkc9kXYrgz3GLV6ld2tLVg4mT1Y6dKg8oT+Dkf9mEvP7Xxzq9d8fKhitYX6hM
	t+jZVPbu1D8se4YZjvN/tvvYCeJU3nEfF+MdLFNJjSYg6iBKH9jxgbxZUSbNNluWOQS/AD
	8Ad+WmMnzwjyry+to8gX+wxXl07hxSI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8E8FE6020C;
	Sat, 26 Sep 2026 06:48:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D5191F000FF;
	Sat, 26 Sep 2026 06:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790405284;
	bh=/ZtlgtRXx70iH42f7yzu0ahvdG98SNDqpIESzbWq6Cs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=K7hP34PKJi6Bjcv22MS8TIn+XW0Rx8BecEVNFElkjULeWp5il9FmTmLHnrmZjURsm
	 MY4G/yFSo+VHJObjR7+6NyMJS/So7NLbCyIm5z3wbX9ZDaldB9bZxr8o2l6JTW1SP1
	 6svZup3jHwklut1SBhO1rWLTHK4uxE6WEIwRsyLDMs3Ah7CYv9BQ/tDG3rUmhoszL/
	 nh0r368reX/onFa7qh1GDmxQSQE/9gaWT8iwumST8Ty1lUAsrRwO1gPAkNXtXNGrRb
	 9A/PimWd4GasDWyRp82vXjmsfkojPF4x4FM8hU8HJRNWYavd1OdmlOr6/xw6hXpxms
	 dTurdAJ5oUfYQ==
Message-ID: <c8bd5eb2-d411-4b11-8f51-1309374bd466@kernel.org>
Date: Sat, 26 Sep 2026 08:47:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] arch, mm: promote DEBUG_WX to CHECK_WX
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Albert Ou <aou@eecs.berkeley.edu>,
 Alexander Gordeev <agordeev@linux.ibm.com>, Alexandre Ghiti <alex@ghiti.fr>,
 Borislav Petkov <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 David Hildenbrand <david@kernel.org>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Ingo Molnar <mingo@redhat.com>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Mark Rutland <mark.rutland@arm.com>, Michael Ellerman <mpe@ellerman.id.au>,
 Michal Hocko <mhocko@suse.com>, Nicholas Piggin <npiggin@gmail.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
 "H. Peter Anvin" <hpa@zytor.com>, Ritesh Harjani <ritesh.list@gmail.com>,
 Russell King <linux@armlinux.org.uk>, Shrikanth Hegde
 <sshegde@linux.ibm.com>, Suren Baghdasaryan <surenb@google.com>,
 Sven Schnelle <svens@linux.ibm.com>, Thomas Gleixner <tglx@kernel.org>,
 Vasily Gorbik <gor@linux.ibm.com>, Vlastimil Babka <vbabka@kernel.org>,
 Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
 linux-s390@vger.kernel.org
References: <20260925-direct-map-verify-wx-v1-1-7fd2f7d6d23b@kernel.org>
Content-Language: fr-FR
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
In-Reply-To: <20260925-direct-map-verify-wx-v1-1-7fd2f7d6d23b@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: F1E2D40004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: a6m9wdy8ercbdi3zw3kcnputdm5kr8cn
X-HE-Tag: 1790405285-542000
X-HE-Meta: U2FsdGVkX1/IuY/UZpBttfNQ5DrZLM5nu1RYYzOBDKcAU90E6A8/gVtumngsvcjMXH/1AiYvRYUgcFRcr3ncSXh4LDKC5/YT7PuD1Rr4XAw5GbIfI7E1F0zJG0xHN2Gz3nLtJchCqLqLsJcYKtZF/OiMokR/q29BeNgSniVMiFg/oyy5ni0T9Pq1rs52es4TxWM750Rz6n8HMxR/btk5y+FuL04LKKYH6T9rzvtv5V7gzGN2P/u3/3Q25VCb+GBGj0ATJScAhGUWCTkQCnh6zvHrSsuSwwG3oK4WcN6D6ukaOqGfMF4P4nfEXIuLZljWXBH2mIygOF6nzqw7rV6Xi2UfKG62D1IQnTTMLixEpSFgvmLsbMj5dfUuo+12CUAxkJP/CicYc7j0Q6zoUPcEtgDFpUyTF/+hHN4xsgmS4hQQaaGHK+L1pYyaOraW8BK9D52usjHKWYSoUd4pjxVPmSISp/YakbUMc+DsEUeq4z+boJ4HOZSQFydJPNlwFJNAPE6Q3b6sH1VY7gl0O3jmznYYzvrMhwqeMzed0HguoLwim+Wr55KBJhi3TkJXc0H2BVgeDWzISXlna+CX7uyQ170LmVjhNcGkkhy6XHv7miSYJyFhOjkwzWO85Gg1ujjkgiU2vu54FscYr/hhMsYmEgU48rSw8v/lcltlc3LbhV78oIaByauRJE2eLqU8/Yt1PD/9sl7YeWxSv6rxw/Quzk3Q95+MQMzaVyoidkKI5kbY5s1ll8DKAVDrfUsQcDPWQLS5wrcibEqmsNLLcD/GfLIcozqsv3AC9pXqW+iWzQBggwTOZwsZcjOhK8wGLMuocD+YRrAONFY4Npnxy4AkfEvJivoyqDnjFuB+35VfONbH+Q+0SDwKzfedeUxbYQ8V7HxKxTazWoz41rH8VsoYozy1JpMwo9ao67/Z4Kkuo2gbbPUxE1dldKf+YD+BVd7kM396fPT8vJ5MREGw8ZE
 ynx0ZzFS
 cB+y+zIXl1TWZ51asmPY5AFgE9fpVLrtIrFyAohDst9jrSnDAOhriZ847MrNpYv10u2p7K+iUu0JbA/CY5Is/oHmTD32SMksOhoK614zk93kIg1scP1xdbBGauESv/yZ57FSyNrb1Hak1emgxLYNFbys6AlymYF5reY//ZQ6dxRwT+L1Q/BJkGJOK3Aq/SPaAXB8vDnTBc+/PRuvpon7IGMSAdTIXtOtPbLgDpwTur5fl+eBbVtK7Gpn4V0UHc4igJQSBQwlieSuBAinwuuWNAqVbuagit/Ei6ZZftrqVZCbawnoNYMzRnWJUUeGc2WDMDVPgw96+So2ie3UXCdyPfJzCUU5vsxLTsJU3XKE7kVWCpm/cUv/EkmUG1RLBjBf6eu3QLqvBxHgQMfq54sOE0L6+yg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mike,

Le 25/09/2026 à 11:53, Mike Rapoport (Microsoft) a écrit :
> Verification that the kernel does not have writable + executable
> mappings is about detecting security risks rather than a pure debug
> feature.
> 
> Major distribution configurations enable it in their kernels as well as
> defconfigs of most architectures that have ARCH_HAS_DEBUG_WX.
> 
> Rename relevant generic configuration options to use CHECK_WX and move
> their definitions from mm/Kconfig.debug to mm/Kconfig.
> 
> For arm that does not widely enable it, only rename its variants of the
> config options.
> 
> Enabling CHECK_WX adds a few kilobytes to the kernel binary and while
> the added size can be slightly reduced with churny updates of
> architecture implementations of ptdump, the core functionality takes
> most of the added size. It cannot be moved to .init.text because the
> verification has to happen after init sections are freed.
> 
> With this, make generic CHECK_WX default to STRICT_KERNEL_RWX while
> still leaving users targeting small kernels the possibility to opt-out.

Looking at how it is done in powerpc I have some doubt with your reasoning.

ptdump_check_wx() will report regardless of CONFIG_DEBUG_WX:

	if (st.wx_pages) {
		pr_warn("Checked W+X mappings: FAILED, %lu W+X pages found\n",
			st.wx_pages);

		return false;
	} else {
		pr_info("Checked W+X mappings: passed, no W+X pages found\n");

		return true;
	}

The only difference is we won't get the WARN_ONCE():

	WARN_ONCE(IS_ENABLED(CONFIG_DEBUG_WX),
		  "powerpc/mm: Found insecure W+X mapping at address %p/%pS\n",
		  (void *)st->start_address, (void *)st->start_address);


And I believe a big fat warning like this is a debug option not to be 
enabled on production kernels.

So I think we should instead do:

diff --git a/include/linux/ptdump.h b/include/linux/ptdump.h
index 240bd3bff18dd..714f63fb604a0 100644
--- a/include/linux/ptdump.h
+++ b/include/linux/ptdump.h
@@ -33,7 +33,7 @@ bool ptdump_check_wx(void);

  static inline void debug_checkwx(void)
  {
-	if (IS_ENABLED(CONFIG_DEBUG_WX))
+	if (IS_ENABLED(CONFIG_PTDUMP))
  		ptdump_check_wx();
  }


That way you should get (untested) the following warning but not the big 
fat debug WARN():

   Checked W+X mappings: FAILED, %lu W+X pages found

Christophe


