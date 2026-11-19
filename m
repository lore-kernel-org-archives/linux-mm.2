Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A81460A2601
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 08:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=TLtOz3/V
Received: by kanga.kvack.org (Postfix)
	id 901E96B05C1; Thu, 19 Nov 2026 03:23:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88BC06B05C2; Thu, 19 Nov 2026 03:23:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A2226B05C3; Thu, 19 Nov 2026 03:23:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 565356B05C1
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 03:23:02 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C21EA140977
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 08:23:01 +0000 (UTC)
X-FDA: 85451178162.06.24A7D50
Received: from mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf29.hostedemail.com (Postfix) with ESMTP id B60FC120009
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 08:22:59 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="TLtOz3/V";
	spf=pass (imf29.hostedemail.com: domain of dongtai.guo@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795076580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9xtLTQESNoyZANIpHgUGyLeoukqSPARphk8aXo+VHwE=;
	b=bNhBt/vmagar1HXjgp1t4vMApXfXSBKix1KFcLgbfrM3biiVaTXOS1lyRc1zVbp3kWU9mv
	BThWKSkmyZIRkc+LOJOW7mvSJzEmLZSF2aB8DcY1YkPw7tpB1VzNWh1L6ps2853ioaEnSe
	t5sIa1ryfTnIVzfD65JmOs25SxtcbbE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="TLtOz3/V";
	spf=pass (imf29.hostedemail.com: domain of dongtai.guo@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795076580;
	b=E/yIQoUNpid/66QqmvxHQr1ZIu2zsmTNvOm4twVrEi4MjGaHl8/Jr+tsL7j9KjaRr1dNOe
	u+SNidqe0SdjVpQbkl6ns0UsBCXxFnHtrLERVo+zyn2g1CB1Tqxh44Jwf/5xs7rtz/2kID
	+SO0ngWiRxv56d8+x9as6NgrJ0FAbb8=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=v7j+so0A9nPKyNFG/7i7Z4Ia8f3AlnUzgV4OZVQCLNk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795076577; v=1; x=1795681377;
 b=TLtOz3/Vwuj2oRnKgQShgwM2JXmHAm/33S/i82MEq1IycE+UakLvzLvRpgvUdIVIZ0BHoC8l
 Akr2G97MGgshl1tAB1+QvcUIremLvLiFkC4ETGpEHGZ+DwWlMmW7F3ywhbnde1jS4mbSipLh4lc
 vXrUVH6O539xox5E6fdKLvsI=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 09da8324dc43e42a;
	Thu, 19 Nov 2026 08:22:57 +0000
X-Mizu-Trace-ID: 09da8324dc43e42a
X-Migadu-Flow: FLOW_OUT
From: George Guo <dongtai.guo@linux.dev>
To: chenhuacai@kernel.org,
	ardb@kernel.org,
	pratyush@kernel.org
Cc: rppt@kernel.org,
	pasha.tatashin@soleen.com,
	shuah@kernel.org,
	ilias.apalodimas@linaro.org,
	akpm@linux-foundation.org,
	baoquan.he@linux.dev,
	ruirui.yang@linux.dev,
	guodongtai@kylinos.cn,
	kernel@xen0n.name,
	graf@amazon.com,
	liukexin@kylinos.cn,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-efi@vger.kernel.org
Subject: Re: [PATCH v6 1/8] efi: Pass KHO state to the next kernel in a configuration table
Date: Thu, 19 Nov 2026 17:22:52 +0900
Message-ID: <20261119082252.9120-1-dongtai.guo@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <CAAhV-H5Vse=pKC3Beqhqxa7fqadiGVNqkSy_06HZ3Luw2Pmj5Q@mail.gmail.com>
References: <CAAhV-H5Vse=pKC3Beqhqxa7fqadiGVNqkSy_06HZ3Luw2Pmj5Q@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: cdh9nax9nyhynzscnteaxkqz4i1rbmab
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B60FC120009
X-HE-Tag: 1795076579-474079
X-HE-Meta: U2FsdGVkX1+1eN02BuSuaX0Wu4Nm7LtgiE8oLkOfnS96cYwQdJWD4W7Wpg6S8M9FP6AFv4XK3i5jaqSUl4p4Ltiru9A6yd0KNR/GyU651/wVSgPj/Y0fvhVpzfTwWQP9Rl8V2rY4GUkwBSdAtfWbq3d3O10QfDG6C0IsTFA399qiR2x19l/L0T5f0ObQns5UttqXbJYYbV3MeTr9r7PmBONa9e/jKWQtTAWbRZ3o9P6SoPOjnvaUKgvK5bvZYLkdAs+1yv56w962EyNnbpeQXmTiKNhfGbpR3aQE0ZGkpqRyA21aFvXJvHtoJ3DBWl68m7JJrNugmvOgya3gJUtoaQ48PpBKi6HXhv6r08lgSDR41wup7qpEXOFa/QozmtToTVYmYUdy4PJ1sreR5Pj07fg48JO/8s/FVM9pFFo2pMqjB26hdV0Nctkj4VS6/GDEUuC3NQGhBqGwiBL9NOZw+IJhMz5GypoP4AxIUgkmdgtXOKrWUqtkgnMLQSPGolJEnufhS9gS25ygJB/XjtHHtpuzTDn0oZLjyvyiAzP9gIfs3iE65wKy946rPOU5uARsivx94y9SA/jucbZH6XWQ0tObzKViT1vSV5vb+3Ituxfk5HQsh0CZOVIir06yvacaO/tyG+BSOZXHT4bxdKmyL69XdVZHkoN4wLIyGC2Qqgai5XgHFc47KF3zorlODB+Lh0yxEqsro9Q6WhWTwZLy96xYHF5pZMVSeEOaIDU16z7BxNexL0ZdfFqGO5Y29guGUGGjgmNQeAa5QZ3HF9tjqfVch2fJdqwWb+zN9VDP/fsYCIvZAKxzA/HurtchNznKiScVd884XdzrfB63BOyGPrwkX3ZVGGE8EzpS+E0yerz+wD7/GQKldcEK7ralMQeVtOK8Dh4t3c2p2thSmuGBWqGgV/O1wYJEop/muLIe/tL1KAMsMzqkXhChKyLnVrEv3LmEcQUlk2o3cXt0cEG
 yBoMTUO7
 hMYBosd1dHpJfSAkFBECv3d9WIaiyQqyc3zRuPAO+/pHiFBbzQwq6SchqPiA88Khip6PQ36czW3fP4wkMbgXFob5U283D0+vcJbvkAuW2KG/ZIEOQSYbIAIWJF0aMPZoWDklpAJh7TBrIgvxiRm4GUUonJLLtxrW7ZkhJygkd5efDebPvGu5eTlXB2cmZ7Px42uiWHSpODY3iRwOeZNHccDg3+RlLsg0+Dkic2Kxc8X3P4koVV50F8Uu92Ud1Ku8hilFT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Huacai, Ard, Pratyush,

On Wed, Nov 04 2026, Huacai Chen wrote:
> I prefer to keep it in LoongArch until a second architecture, and I
> think Ard is the same. But this is not a strong objection to Pratyush.

Kexin Liu and I have tried x86 as the second user, to see whether the
common table holds up. It needed only small changes:

- The x86 EFI stub installs the table, as the LoongArch stub does.
  install_kho_table() moves from efi-stub.c to efi-stub-helper.c so
  that the x86 stub can call it.

- kexec_file_load() skips the SETUP_KEXEC_KHO record when the table
  exists and the next kernel will get efi_info. Otherwise, for example
  on a legacy BIOS boot or with noefi, it falls back to setup_data.

- When there is no SETUP_KEXEC_KHO record, the decompressor's KASLR
  code looks up the KHO bootmem areas in the table, so the kernel is
  not decompressed onto preserved memory.

The table layout did not change. The only change to the common code is
that efi_kho_table_found() is no longer __init, since x86 calls it at
kexec load time.

Tested in QEMU on x86_64. With OVMF, the KHO vmtest and
luo_kexec_simple pass, and the second kernel finds the KHO state
through the table. With SeaBIOS, the KHO vmtest passes through
setup_data.

So I would like to keep the table common in v7. Would you prefer the
x86 patches in the same series, so that the generic code comes with a
second user, or as a separate series on top?

Pratyush, does this match what you had in mind for x86?

Thanks,
George

