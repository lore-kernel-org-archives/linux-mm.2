Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2F4BF44873
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 14:17:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB5EA6B00A4; Fri, 10 Apr 2026 10:17:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D675F6B00A5; Fri, 10 Apr 2026 10:17:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7C816B00A6; Fri, 10 Apr 2026 10:17:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B8A256B00A4
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 10:17:45 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4E31CC2079
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 14:17:44 +0000 (UTC)
X-FDA: 84642849648.30.59861E0
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf22.hostedemail.com (Postfix) with ESMTP id 95697C0008
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 14:17:42 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=g6Xv4FLB
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775830662;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=89sWGO8AlV20Ohsw4OJI0G4LNPOoHNZD3rE29wrdmss=;
	b=e2/VNlUAJ/3v2WGzXEV4XK38VQqFuSR5Zf6JNVHu95gidUHfusRaEZf7naCT2Ssr1yaktz
	jQUfIhMbdhHTV9r0SxidmIqAGvQRC+jRGqUaNSUpsWaB93XM8JOoZOTMdxp3V8TyiC+pfA
	2NH1RDg37YNRitQvkpzAfeSLNBrJ2Zo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775830662; a=rsa-sha256;
	cv=none;
	b=xeJltSa3qSmscZRDzDBpRf3coK8TP+vvGcRPmTIiWv2I9yCajDPRQjutRAn+dyvz83+Tg8
	aRqJeAlaAWJWp7M7uEPaAFvearkcXKUKregNVO26AMbGLNRNm8X7f4HlGu0S7l06jFTzYI
	BSdDDnmpWBkMwNhfEwoHViMKvQ3vFhs=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=g6Xv4FLB;
	spf=none (imf22.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=89sWGO8AlV20Ohsw4OJI0G4LNPOoHNZD3rE29wrdmss=; b=g6Xv4FLBo75hPgXI5PonFAm1Qj
	dc83hN9ROemoVz8Mh5e301Yv0LtveH0BO8ylQjQ/4kp5vnMegzwI5L5+jycI+nbyyJ74gg3ye0w0n
	NfMcPYbuihg0xGddTYlBK06M9Yzmd6bRPV8TdaRVRJm/Mzy7lvvJeiZVmwGozVUI6I+TArha+pSkH
	tUc6VEmTjcyLxgLITU87MIISC8HPx768iLoPUNCfR/SMouxsoXz4gghQnuBX1vnOS6vr01qo9n0l+
	40vavz2p2jb14SuazfTHSvaHfpQZzdNarTOQvcM+6A22Sm4gWiiQbfQRReQRLVxjHoguhe5o6IbW2
	O6OR726g==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wBCfy-00A2JE-1B;
	Fri, 10 Apr 2026 14:17:38 +0000
Date: Fri, 10 Apr 2026 07:17:33 -0700
From: Breno Leitao <leitao@debian.org>
To: Miaohe Lin <linmiaohe@huawei.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, kernel-team@meta.com, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [PATCH v2 2/3] mm/memory-failure: add
 panic_on_unrecoverable_memory_failure sysctl
Message-ID: <adkFQF7QH8Jc3p3U@gmail.com>
References: <20260331-ecc_panic-v2-0-9e40d0f64f7a@debian.org>
 <20260331-ecc_panic-v2-2-9e40d0f64f7a@debian.org>
 <59c133a7-74a7-4678-d907-add764bbd107@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <59c133a7-74a7-4678-d907-add764bbd107@huawei.com>
X-Debian-User: leitao
X-Rspamd-Queue-Id: 95697C0008
X-Stat-Signature: adoioq6199ke49b8kk48rin6hqownq33
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775830662-504377
X-HE-Meta: U2FsdGVkX191bw3D0EICIm04jCxnioFAcDDAwHHNVeMcgef5j7lR2G+J4DemN6RdLnImf7Rc8/VxVGPC72evJtSy/v+BLfocdx2fNhqWXIwGjkqdbfX9bpCy2eulRFMC1/OmhJkPCcpPzNeyyYGLCp0MyrMb2JPwVJyYCsuQJtpEVmNc0dlUW0pMWGNC0/Xc6SxF5ofRWrD2338M0saqREDBGveQp1NSa9dLf74JlWWDJVGEZ4bpaLBNQ5FhI+1LEWTEEKG7E2DtZpO6Miu7bUlrzc3TP3jxVTVaZB2cmqZUfHkjEwj1veMCZO6W0e0/913hMfNkMRUK+dYRx2did2bqGg7zQf/1nJPhlFb0rRLY9B3dNBfoFIAWQh8aXcWU2Dfq4AK7oA4WHe3LUUHBrGJwz7FankfzLKXC38QWmWcE50hBYb30yIU1/B6DYy7zkf576QgMEIhxUcbmQLBtWUlH9pj7Gs1zDz37n3rtW/BWYX2zTvBwvjm13SmPuR/ba1Foii/yxmEwvLIdjaWkXBtku3+oTmewb86TG4srz+q/uXaVvBKoQplDtCMsQy0p9d7YFK69Z0PTvKxJx+vmiGlmbKIau+cem9O/q+94X9mM6fOH6oTGhmFoj22/DKFVqoyIhlHSZBz/TwwtKB+tc7jeuX2TuDrcmlDdKx4kT+th5QerCV+XNSF91O1YN+4VCIKb2It/rzXy+qtwTRLMAnF8ly0u96vctsgaE8zeAaQs7YxJKjXaDpGytRHQXLKhibNg2gnkWbumK7WdiNhWKebfJxITC73a4CVXLCFDgCX9EvQV9ogJloez0jB2g7Fe02oaSc00adNGodXk+3iSB7YeEkQQIs2FTk9VW0TuRogUzAETBgdSJD4ZYlduHC6XCDrhD4zpLetb7esXRn7lwgAqpJuVAzMaeAaZzxsCL72OAeF9jMKIc8l2lXP+cZPx2WDgw5wyO8RU7Pizpkc
 AKa8M3aK
 dTvsSgtqcPzRyNX7bK9J5tD9XT6Y0pDUw5Ykg+ME786zNp1I/bBbzcF+RtX/vhJwlLgbuxZdEDQPt+kbNfkiUTB0/8ZRFRFDKzoj1rpoD/gZdo38CEXXQLhDgiypc3ChwvqK6BS6Gle1o0zXtRDaPASRzb1/Dl+xWfXMzP+jnrKGInGD0M06nOXmNXVHlfz0KFZHlhg+PiYoqvHtJkNUwW5aTXghWuxr9nwqrl7u71LkywRJ2hA6G6B3XPvFYOYLFLgZW0pFMiD+UjQg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 07, 2026 at 10:57:36AM +0800, Miaohe Lin wrote:
> On 2026/3/31 19:00, Breno Leitao wrote:
> > +	if (sysctl_panic_on_unrecoverable_mf && result == MF_IGNORED &&
> > +	    (type == MF_MSG_KERNEL || type == MF_MSG_KERNEL_HIGH_ORDER ||
> > +	     type == MF_MSG_UNKNOWN))
> > +		panic("Memory failure: %#lx: unrecoverable page", pfn);
> 
> Will it be better to add a helper here?

Yes, a helper would make things easier to read and digest. Thanks for
the feedback. This is what I have in mind:

commit 36d5b3cbbe6d6abfe3296b7b21135a5f01e743eb
Author: Breno Leitao <leitao@debian.org>
Date:   Mon Mar 23 08:00:29 2026 -0700

    mm/memory-failure: add panic_on_unrecoverable_memory_failure sysctl
    
    Add a sysctl that allows the system to panic when an unrecoverable
    memory failure is detected. This covers kernel pages, high-order
    kernel pages, and unknown page types that cannot be recovered.
    
    Signed-off-by: Breno Leitao <leitao@debian.org>

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 6ff80e01b91a4..a29b6688fe2d3 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -74,6 +74,8 @@ static int sysctl_memory_failure_recovery __read_mostly = 1;
 
 static int sysctl_enable_soft_offline __read_mostly = 1;
 
+static int sysctl_panic_on_unrecoverable_mf __read_mostly;
+
 atomic_long_t num_poisoned_pages __read_mostly = ATOMIC_LONG_INIT(0);
 
 static bool hw_memory_failure __read_mostly = false;
@@ -155,6 +157,15 @@ static const struct ctl_table memory_failure_table[] = {
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= SYSCTL_ONE,
+	},
+	{
+		.procname	= "panic_on_unrecoverable_memory_failure",
+		.data		= &sysctl_panic_on_unrecoverable_mf,
+		.maxlen		= sizeof(sysctl_panic_on_unrecoverable_mf),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
 	}
 };
 
@@ -1281,6 +1292,16 @@ static void update_per_node_mf_stats(unsigned long pfn,
 	++mf_stats->total;
 }
 
+static bool is_unrecoverable_memory_failure(enum mf_action_page_type type,
+					    enum mf_result result)
+{
+	return sysctl_panic_on_unrecoverable_mf &&
+	       result == MF_IGNORED &&
+	       (type == MF_MSG_KERNEL ||
+		type == MF_MSG_KERNEL_HIGH_ORDER ||
+		type == MF_MSG_UNKNOWN);
+}
+
 /*
  * "Dirty/Clean" indication is not 100% accurate due to the possibility of
  * setting PG_dirty outside page lock. See also comment above set_page_dirty().
@@ -1298,6 +1319,9 @@ static int action_result(unsigned long pfn, enum mf_action_page_type type,
 	pr_err("%#lx: recovery action for %s: %s\n",
 		pfn, action_page_types[type], action_name[result]);
 
+	if (is_unrecoverable_memory_failure(type, result))
+		panic("Memory failure: %#lx: unrecoverable page", pfn);
+
 	return (result == MF_RECOVERED || result == MF_DELAYED) ? 0 : -EBUSY;
 }
 

