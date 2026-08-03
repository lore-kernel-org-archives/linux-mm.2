Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A20A3C55822
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 18:12:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B2DC6B007B; Mon,  3 Aug 2026 14:12:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73C606B0088; Mon,  3 Aug 2026 14:12:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 605306B008A; Mon,  3 Aug 2026 14:12:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3378E6B007B
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 14:12:53 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C4837407C2
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 18:12:52 +0000 (UTC)
X-FDA: 85060754184.21.83E2E68
Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [80.241.56.171])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2B62C1C000A
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 18:12:51 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=Rm+q3L38;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=LTcjog2d;
	spf=pass (imf20.hostedemail.com: domain of manuelebnerli@mailbox.org designates 80.241.56.171 as permitted sender) smtp.mailfrom=manuelebnerli@mailbox.org;
	dmarc=pass (policy=reject) header.from=mailbox.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785780771;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=0pg5vdKdmfDtSFhDDoMxYAKscw1ee4hFMSsX7J0wZec=;
	b=G8MmYdaKimso+4yd4vqrJUkvVMacDWbV04BImQwKL8wKlK1fiyC2auljEDKj47Tg8hCYzQ
	gtb/iiePv8zcvPmbVfZX77aDuaiJr8XGiKq6aa2NESuL6WPWIZOFfViF0Xavjpnb3/DspJ
	c/OJYn70+reNUt0Hlr7UhvwO9/wdOUs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785780771;
	b=iB+CmZ83KxsrXXNe+X0g0B3cmJmdKtHxcvYFOK6YW06EqNUegRmU9JIVjqpPzn7rRSk/vG
	xki0hagUqOmvXwy75Xye6aSpLc9fkaRKB3UFtG08OEwDmOtBNk0q3ZS+yrr0NaJK9Tdb3i
	qRY4CwbvkQv4UXrPa/5vU/gA77p1DYg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=Rm+q3L38;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=LTcjog2d;
	spf=pass (imf20.hostedemail.com: domain of manuelebnerli@mailbox.org designates 80.241.56.171 as permitted sender) smtp.mailfrom=manuelebnerli@mailbox.org;
	dmarc=pass (policy=reject) header.from=mailbox.org
Received: from smtp102.mailbox.org (smtp102.mailbox.org [IPv6:2001:67c:2050:b231:465::102])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4hDPss6bHyzMlDs;
	Mon, 03 Aug 2026 20:12:49 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1785780769;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=0pg5vdKdmfDtSFhDDoMxYAKscw1ee4hFMSsX7J0wZec=;
	b=Rm+q3L383W1g9P2AOgzUSwSzxKXWPKfqCXxqEjEr/y2YYkjEk0S0s1IqOBjZ/4R+MEe8w0
	7zYsU1k9+VtxeohRmKuIhldJ9MhrzntTY5IboEDpK1UX6hQRgv7PkIQxGqK3k5rsnZFDHz
	K/47sSwQzu9uAPNgOnbJIwv0cHJG1/ltY7AULrUb3LqwxikU8vekL57/1W0y/1cf6ju0ya
	Dja0iEuVuK+0npJXRU5KjukuZBYrQ0DqWAvetSqkGsc2Kh7r/a5y+DAj8RvQaGPdczyLfU
	SKQxXkhJ6qoKKz3V9b7gOrn7qmT+4RKRkPWV7U9Acukr/+4u4J7skXp2RUVfMw==
Message-ID: <27a9ca7bf4d354e97b0865af8222490cf44f27e7.camel@mailbox.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1785780768;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=0pg5vdKdmfDtSFhDDoMxYAKscw1ee4hFMSsX7J0wZec=;
	b=LTcjog2dRCGv8Y6ISOAzFiEmNkpkIT+r51TILfDvsQB8SAxf/k680PC/I3WrmlsvZNK+nl
	CyesWmw1sNpDrGCB7SAaU5H0oTP6LK7SO2XXoRjxMPqjzGtKy1mHK89nYcTLy5Y5qCCVy1
	nQEpWImDlr8N5a1wd/RTilUghs/qBCNX20j6Lk7m8/Zkpf3ILhT57mNtTbWVGV3TtSa8DY
	n4OsNWW6EhAhDjLM49CYYz1WBFfsf3EpbdhofhfUo5+G9DsvwuXvR5o7C7XU75o/sEDjC3
	po6qjalBsiJh8pqh5HJd4OehK1curlnE9HUC0Aexu6svc6FFowwE95JsM8XIXQ==
Subject: [Build Errors] kho:
 =?UTF-8?Q?'=E2=80=98HPAGE=5FPMD=5FORDER=E2=80=99?= undeclared'
From: Manuel Ebner <manuelebnerli@mailbox.org>
To: linux-next@vger.kernel.org, Pratyush Yadav <pratyush@kernel.org>, Mike
 Rapoport <rppt@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pratyush Yadav	 <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>,
 Muchun Song	 <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand	 <david@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, Jason Miu	 <jasonmiu@google.com>, Jork Loeser
 <jloeser@linux.microsoft.com>
Cc: kexec@lists.infradead.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,  Manuel Ebner <manuelebner@mailbox.org>
Date: Mon, 03 Aug 2026 20:12:40 +0200
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MBO-RS-META: ay6khkkde3zkcycuyhmytefcoxfast4h
X-MBO-RS-ID: 427c8c8f1f2cc33b5c1
X-Stat-Signature: pbmtnoqnggcmu9fsghko199ytcb13st9
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2B62C1C000A
X-HE-Tag: 1785780771-988126
X-HE-Meta: U2FsdGVkX18UAyKjSinWIegQWuMZ5K8q2pqH3e/vWEA/JEQcA8HYZPeFpzaO0F9DERPmZGYmrD7V7051QBK7uDd3JhDM6tZcrRv1ovUWLs/rOOOuoCqnrYRvYqdq41DRSAlekZeXaHLs7l+bNBEPF8lLLM2Z3MoOiEB4wohslFT2d7bpPgFzBFWZtmsax7MtpowW+JDMIpiB2wB3s7HmYV1MhFeXnxEMiT9hAe4lc6qU1vQAenS9dHhRB71TdzOya5DghaxZhb2GALQ0vOEBCtQ69e1Eh2nPc3xXR2okJut7VnsaCApY9a/pSoD7HE/Xt69ujFcvDMmM6j7uQgzScG1os0z/FRVGS7EheEXGUpm4AfxRLAIeAWrVHFthFkusxfRSOMuN40MlObHaXj9ffsUuEDErUO+dI+8ta+wdZyYsSJHu52khA1A0fI1sE6/bvE870zCVyXpF4LOIZwxu79wb66KCiK/SNjFhvQJ2/0r9WTUpAfAidZfiwBxlMfmwGFieEPxh38vTC76eNN+uFxH4kZytU+uKqQd8SqN3ny9yGWXCX9TdyXaWvh5Z6n+iE8w6Z5HbKsbT2fDTkVczP6N/9ze7dDd51FkXQOzXO6EIUfenient+JnwQMkVS9W6HhnjiBLjhwC5GryzLjmUR5H2Ux57bX8VqAcSEbubyvi7t7E6jT1m14x02AfSHmaSpmMX1Z84msrafmcVBfVM7kD1o/r6IoeRGRVwjJIri0a7Srlqb0qCM1qR751NBGfgXfWnM2NWna/lZpMxQb9sH8PKmcOH/OmHZ3kxvXiAFLq3aQxyI//1AYvI34uu15vaMOEtE31jj/BFAzp8zsnW/lYu0Su3AQQkGNFUHE1lJs4B2AUeXf8OqhWpD6Z8Rb22xEiRNXxZ9gMVfcyOWCYPIAeKbuB1wOhsZqVh69KUk5e5VOpiHK1UQki+174fA+Ok04RQnsnMeGzFl+M65zD
 Rr9uM1yl
 HULHMKnGEqamJ7v6l4EgPZBz2BdViqskdLr9VJ/RbCnwLSNcmmsGash3pCVtGZXKFbzQPxrVUgirvyKiFhl58kEubVaizYNPuU2VTMaQZ84IDPej7vez0NdCQzl8u9swhFWZ/2vVzu8dxrt+vywqsYCn224ZMGx+iLbpi83PAtpn6LSOsfG1bCj9W3eNyplpv0q1mkkivmiUVKDnLx+CySofeVoPp3PvK2KPpANWemDjm46nWyJCWg0FOV8MnOZqBToR78jqWVkpCF4M5EBphsZbZosQ/phkBh62uuOe14t8AW/K5WHq0HDVcFcIj8+VdEK1itVGY1cFI5O2eE2IkIirFm56jJQCTJg9y9qYw96FIbkg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

when building next-20260803 I get build errors, see below.
I assume it's one of the last 3 commits by Pratyush. Let me know
if you need more info.

Thanks
 Manuel


$make KCFLAGS=3D-Werror -j8 > make_output.txt
In file included from ./include/linux/nodemask.h:92,
                 from ./include/linux/numa.h:6,
                 from ./include/linux/cpumask.h:15,
                 from ./arch/x86/include/asm/paravirt.h:19,
                 from ./arch/x86/include/asm/irqflags.h:100,
                 from ./include/linux/irqflags.h:18,
                 from ./arch/x86/include/asm/special_insns.h:10,
                 from ./arch/x86/include/asm/io.h:45,
                 from ./include/linux/io.h:12,
                 from kernel/liveupdate/kho_block.c:23:
./include/linux/kexec_handover.h: In function =E2=80=98kho_scratch_migratet=
ype=E2=80=99:
./include/linux/pageblock-flags.h:66:53: error: =E2=80=98HPAGE_PMD_ORDER=E2=
=80=99 undeclared (first use in this function)
   66 | #define pageblock_order         MIN_T(unsigned int, HPAGE_PMD_ORDER=
, PAGE_BLOCK_MAX_ORDER)
      |                                                     ^~~~~~~~~~~~~~~
./include/linux/minmax.h:83:27: note: in definition of macro =E2=80=98__cmp=
=E2=80=99
   83 | #define __cmp(op, x, y) ((x) __cmp_op_##op (y) ? (x) : (y))
      |                           ^
./include/linux/pageblock-flags.h:66:33: note: in expansion of macro =E2=80=
=98MIN_T=E2=80=99
   66 | #define pageblock_order         MIN_T(unsigned int, HPAGE_PMD_ORDER=
, PAGE_BLOCK_MAX_ORDER)
      |                                 ^~~~~

And a couple more notes.

