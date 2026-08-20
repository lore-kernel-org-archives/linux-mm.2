Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34E74C5DF87
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 22:30:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A6226B009D; Thu, 20 Aug 2026 18:30:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 057386B009F; Thu, 20 Aug 2026 18:30:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAF466B00A0; Thu, 20 Aug 2026 18:30:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C3B566B009D
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 18:30:23 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 39C641A0304
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 22:30:23 +0000 (UTC)
X-FDA: 85123092726.18.1F403C7
Received: from oss.cyber.gouv.fr (oss.cyber.gouv.fr [51.159.188.251])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2A7BD100003
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 22:30:20 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=oss.cyber.gouv.fr header.s=default header.b=A8IrUFqB;
	dmarc=pass (policy=none) header.from=oss.cyber.gouv.fr;
	spf=pass (imf14.hostedemail.com: domain of Jeremy.Jean@oss.cyber.gouv.fr designates 51.159.188.251 as permitted sender) smtp.mailfrom=Jeremy.Jean@oss.cyber.gouv.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787265020;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=3uM/5Ah60/1yfTM9+Zuo8PO9yKPICs0GbkA7rgYWFfs=;
	b=LjdWUNyL/ZQ0IioaXkFeqdPPQLvnf80Z4pUmDmSiCjBT9NXud5TMHEJ12X3FEt1xQsgfVU
	IzbiXjH4Itk9b+sTCPG+Pzz30ITWG6TvEieFnpAQ+saHe0JhP+yZFbRyezxuq/54WqZRAH
	ySAHogbh/XZhrNeowtMRyHYMRKZC/2I=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=oss.cyber.gouv.fr header.s=default header.b=A8IrUFqB;
	dmarc=pass (policy=none) header.from=oss.cyber.gouv.fr;
	spf=pass (imf14.hostedemail.com: domain of Jeremy.Jean@oss.cyber.gouv.fr designates 51.159.188.251 as permitted sender) smtp.mailfrom=Jeremy.Jean@oss.cyber.gouv.fr
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787265020;
	b=Cv4/lvaISzi63rscIuWbWusJ799+9/TDZu+sGq0WjTVYWyZZXeQolRu0SIiBGVMATY3S8g
	QVYSkcLZH43CU+ZWm4kvowicIod5LzNEjeiBcQX3wX0E8EV+XmeFo+XfvpCZvTOnCo64L9
	L8x/vtt0cTfyrCNA2sKnTFFm51staxg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=oss.cyber.gouv.fr; s=default; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=3uM/5Ah60/1yfTM9+Zuo8PO9yKPICs0GbkA7rgYWFfs=; b=A8IrUFqBb/LHNSAfvNi258Efpw
	k3gkshTlPpifnRaU4RVVWeOdx0+ttKHmb2QNCKgNyT1vqfzvuAQsWmv4nqiwoxMJDPtS8WsygoibJ
	LPcoHh6f+L8FV472rhqoYM5h2L8/FlMfFYMXUaQ0wK+oKruRN1nQy8Vp76kE20p8EysMg/z4xRXrm
	j5kuqtXJN7EzpKUaD2148VhRtpY9IJbWcFgKxdYlH4zdN2PXpSxVbaE9fWErWCxulxRAMqoXGA+tj
	5qVqOcg+XhuJUnLD0XDl5kfC67WvqQrbp/tZm7C5F14LkMzm6yRyimLho6FpirVzEmOy3t8vrxvDV
	B8ja3RWw==;
Received: from [151.115.150.205] (port=44086 helo=gepetto..)
	by pf-012.whm.fr-par.scw.cloud with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <Jeremy.Jean@oss.cyber.gouv.fr>)
	id 1wxBH8-0000000Ahdt-3kQp;
	Fri, 21 Aug 2026 00:30:18 +0200
From: =?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>
To: kees@kernel.org
Cc: viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	jack@suse.cz,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>
Subject: [PATCH] binfmt_elf_fdpic: reject PT_LOAD with filesz larger than memsz
Date: Thu, 20 Aug 2026 22:28:26 +0000
Message-ID: <20260820222824.3165092-3-Jeremy.Jean@oss.cyber.gouv.fr>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - pf-012.whm.fr-par.scw.cloud
X-AntiAbuse: Original Domain - kvack.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - oss.cyber.gouv.fr
X-Get-Message-Sender-Via: pf-012.whm.fr-par.scw.cloud: authenticated_id: jeremy.jean@oss.cyber.gouv.fr
X-Authenticated-Sender: pf-012.whm.fr-par.scw.cloud: jeremy.jean@oss.cyber.gouv.fr
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Rspam-User: 
X-Stat-Signature: hph4fjsripry535ui933ewie84ap3zk7
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2A7BD100003
X-HE-Tag: 1787265020-583547
X-HE-Meta: U2FsdGVkX19xU4955ED/SvkcEl6FSSVL0g849W5sGH4MibsOYGG5p9JRt/9a5/zRIuVVxdEfEEoxLcuBjzFO410c1uM2ijrjcNGUMJ1mpEpa1bB5eMxOf1b5ehPExNsTQsdGhss4DNrulqJV/ihyATORp/8fNKjWYIdu4AVoQvgGij4IFGJg4rAbrGGuRS+BufcYUWNF8u9nR0mvn1uqLFjTnGOkKv5m0+X9l3on+l/gnRSuxBdZNZjoT4mP1DuXgLsiLn4KFWTcBL8q9VIDhQO6O+a06CtjiCFA4Lc+4EgtHUduYJVQBF7kkqmvCzfQpnAsevEOimzLyX24UF/SmqO7K76qA7nsja3I6mvIa7pTemOPOrIoCsIofvfPDaxsVJGE7cgr2cz949z4tEm/8f38oqQQtkjxYG777U0a0rVzaxZWgyL9B7NnB219+WuaK5jq3gvWPvINLqD49wp0238HzNkcEqBkexTtDJVNo+t7EMEpvurthmDw/ykE9OTL8u4rpdb/vu0Q9sqmNQO3/gXEr5poFuH79KnqYCckktezvH0MvPnjC+ImgJUayH11ASXPFvGwHKZVy46qFMTWKi3+W+cALVavfunoAY1rp/rPhheOFpHS/dQ3Uwq0n65xaYIH0wFKnaH2k1S7cVoPxJvVVtz8w20VeKAFUA62puRpT4ppLdSGBa1bzJB7egoyvKG7gIsDcCGqo3MRVg82RabrwdqG0SGc/lH9lUz9pWynBSp5V6p6UaI9lYinBKyVAswB0PUckYKPjdIYJzNez5udGwyWUa6KCx2NL/sqZCY2q6Cck267yZ1OEjFygG/TTC053IixgO0Y8RqxnRTnerECnyQ7lKfgxnyRW9JBFDYhtc2ZDQea5EtNuCSoOuoWRniq0r+JAXmGJS7BP8YkioZML1gkUfbvKzcSwDc5WRrvaxgt95MatW9HdmUou34LXh4ej2GI0QnGFS48vXf
 QU0csNzP
 ikM0uUs3nM4k7FJP+705vhde0VrSD+9u9b3JV3rl+cDsVb+EvDT4gQu+bVXnPI+6gA3W8a6gzBsxDjiy3jlfJezKUtO2c/Nlt2fKG5KKRpjiTlhcUZubWcjBQVZQ4hMntwebslk7BZIRjcSG9xcu/hAytiZnNtMMhqmg0CUOFrovC6xxrfFdbWCYOchJpcx3XsNu7Ypkfw4KBaSr68/HP8CP/t8XKQRxIs7sMag1BdOUS617V/n1Ei22P8cnRxSmvN6tRxfNhTGYV7PeZ7yDPzHWloNmvXi5/lmv+8TxUN8uoyY8pCBvg3Pv/q0dcvksXUnFVBpA720pmxtMMxo49s/arWkfR6f+PTvqh8E0T0497P1bkPwuh8FWLAz+smc50bsYVTpuwIKb9M7OpHvH0fzmqq2/QsaoPLG9DB0LCWFI1VM8hpEcyCYGnBm3yzSXx18Nng7npQGuv3mov+Ue4drgjtDgf/Mn0z73osZviZN1Cv3YcvknJK+DybDCg9Z2CawusH59d9aQNi6+NcHdO1qBNi9g3XxkGPBKIDlb9qIVwu9DC01+ElGoTWU/darRGmlbFnl0IZKbXGmDDdnhwBpcWeduZx2PW0iWnzANdzn8ZxDDcrSM6rAw4eUnxjZDAewsN5rOFFEjyUKX2cIFaveE9rIauUHCPOMqqLoIofKmxX0HRwfKJlymao349aJg743Izh8x1d1ayEX7bHSW+8rKr4raXiqL+X64s
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The ELF specification requires p_filesz to be no larger than p_memsz for
PT_LOAD segments.

elf_fdpic_map_file_constdisp_on_uclinux() sizes its contiguous allocation
from p_memsz, then read_code() copies p_filesz bytes into it. A malformed
segment can therefore copy file contents past the allocation on NOMMU
systems. The direct-mmap path also subtracts p_filesz from p_memsz without
first validating the relationship.

Validate every PT_LOAD immediately after fetching the program headers.
This covers both executable and interpreter headers before
begin_new_exec() makes execution irreversible.

On RV32 NOMMU, an ET_DYN with an 8192-byte p_filesz and 4096-byte p_memsz
copied a marker from the second file page past its one-page mapping.
After this change execve() rejects it with -EINVAL, while an 8192/8192
control still executes.

The flaw dates back to the driver's introduction in the pre-git history
tree introduced in v2.6.11 by 91808d6ebe39 ("[PATCH] FRV: Add FDPIC ELF
binary format driver").

Assisted-by: Codex:gpt-5
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
---
 fs/binfmt_elf_fdpic.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index 068c46875c74..e8a6e89b76a0 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -157,6 +157,12 @@ static int elf_fdpic_fetch_phdrs(struct elf_fdpic_params *params,
 	if (unlikely(retval != size))
 		return retval < 0 ? retval : -ENOEXEC;
 
+	phdr = params->phdrs;
+	for (loop = 0; loop < params->hdr.e_phnum; loop++, phdr++) {
+		if (phdr->p_type == PT_LOAD && phdr->p_filesz > phdr->p_memsz)
+			return -EINVAL;
+	}
+
 	/* determine stack size for this binary */
 	phdr = params->phdrs;
 	for (loop = 0; loop < params->hdr.e_phnum; loop++, phdr++) {
-- 
2.47.3


