Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DDD7C5DF7D
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 10:06:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C9766B00A3; Fri, 21 Aug 2026 06:06:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A6936B00A4; Fri, 21 Aug 2026 06:06:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DDB26B00A5; Fri, 21 Aug 2026 06:06:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 26B236B00A3
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 06:06:48 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 85AB0A0431
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 10:06:47 +0000 (UTC)
X-FDA: 85124847654.23.AE0C616
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf04.hostedemail.com (Postfix) with ESMTP id CE7CD40004
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 10:06:45 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=AXjvKfsH;
	spf=pass (imf04.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787306805;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TWUgrg2oyif/z+3LRHUgpEMONMbKe31piyu+fjgyTPk=;
	b=jTuLNogHiglBIyewpwBXsIegCKqKZUFDAgzNFI5oamUWWGJWQgzCrwsaE5hDzurT/vJ5dk
	YwuL/OfnF/xpmWQ1U75W2lKILnOw+gW5ZdUgbSWrkgyO/ful3JexCXnecuqeDalCw3zBW0
	gIL8xKpsc8rjIfg1KgrV/3WdXJ4McSE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787306805;
	b=Dp7aR6vOUCgDWgzj59OSCwjh2wqt1WQZB7x5yXp4LinUvqTZyvNzQKrpeKtv2iQpYs84LZ
	QvyPsCNAzWyj7dc33cXWXrkWUmM+wF7UzrptbZXtSqZNKi6aA0wyNfkc6rA/3xJUzjRhFT
	hfzZsHrmHZu0wH6XOafqILdBAZtNjuA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=AXjvKfsH;
	spf=pass (imf04.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=TWUgrg2oyif/z+3LRHUgpEMONMbKe31piyu+fjgyTPk=; b=AXjvKfsHRrlUy/85X/g+r0/wvs
	5DG0fiowafk/zPk/acmEyRjV/KlM0elacpnox/ob9oO4uYc9hMcPv65xjjvaFX+BlCwGv4qjSHfgG
	QcKUnWafqX86nz5TtczUQiiYj23FMHpWyQULqnrjQJvyhk4ZWA71Hf4AUds80tndb9SS7qe9gyZTk
	9ItsYoDjdbWfEV4gW4oUlvYJVx5ApWYXPWULFzErttrczEy4ireCV+JE0+nzLA3keuSuw7jGV0Cth
	pMjviVHvQXA4yoh85zKSWLYNr0IFNNaCQW4+x0sc4r8ZEHyNrU4L19EHSL8UT+7Wv1tr7wENCmoaJ
	yfLn94gQ==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wxM93-00BGBj-1G;
	Fri, 21 Aug 2026 10:06:41 +0000
From: Breno Leitao <leitao@debian.org>
Date: Fri, 21 Aug 2026 03:06:04 -0700
Subject: [PATCH v2 4/6] efi/libstub: install the poisoned-memory table from
 the stub
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260821-hwpoison-kho-v2-4-5743791e48e6@debian.org>
References: <20260821-hwpoison-kho-v2-0-5743791e48e6@debian.org>
In-Reply-To: <20260821-hwpoison-kho-v2-0-5743791e48e6@debian.org>
To: Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
 Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, rmikey@meta.com, kas@kernel.org, riel@surriel.com, 
 kexec@lists.infradead.org, Breno Leitao <leitao@debian.org>, 
 kernel-team@meta.com
X-Mailer: b4 0.16-dev-f8e9d
X-Developer-Signature: v=1; a=openpgp-sha256; l=1559; i=leitao@debian.org;
 h=from:subject:message-id; bh=C5EuuwpNY5nvk98hyZjVmVyrfx8vi+SqUwzV/WPLKts=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqiCMaDftorVUDCaUHLSwpSUmd8hWjXyWY4oOXI
 ryUjhDKDbGJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaogjGgAKCRA1o5Of/Hh3
 bRrvD/9HZjdZmiXO+WacXh65YCVhn2MyGUVpEgcGoMQfmso15ErjMO93KJzMYBcz8nP2MoN3RQT
 ExgpjFq5TgjmMtn6kixUuJeMoNauEYJURdhfoxEFOmtKvceN6vGs8Gv+dMV4ioklRcWhcUBvKd+
 UkLqi1X/Cjy1Iba0aIUSsQhpx6ZH7NEB6JfksmbevOOgarNY50zL/QQr3o6AlhTJyFPeA2L0vkr
 Gr79L6/Q/sJR5gVU+95frI7uXA76JqMFzfm1nue7jylyEVig7bMPuY2i1trHbvLhFtcL4u9sWcU
 M+J6cQy/zzEFdmPZJZHT1zWLAUMOj/oy+hH1Nxbf8HHsG38KOiaTNrU3gJNWrusKEY98hGkHZoX
 0gSH62z9uJiEzmecV6xmgHINCQ2CeVuEtTxZYnKaR/j9UQeO+Rs3sXHT9lbyOgup0buRbfjMpc1
 BXH9RqFXPREaI493li88NNGxGP6LqZpxlG/NNMAWHgGItNzGd0/fPcI13VSt0gbKNIhOAH7MFdb
 d1QpHTrRQ/HS2o0RvLmD9X0unM1Pec1ZjEmctBULGlesSOrMr9eP4rU1miCgL0BjSVYgOulVuyH
 CxRmEjr4iBFnxO0er4olzAwigHnSbbkSlwyLGeUAiF4SK5lDoopcMDHxu/sfrlkQXSlErXTTMLk
 mYILtAkfNfZh8eQ==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspam-User: 
X-Stat-Signature: bzkojho7ga7mbz1iqb6bh839ypgxk45h
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CE7CD40004
X-HE-Tag: 1787306805-228985
X-HE-Meta: U2FsdGVkX1/J9jaqiAUSch6osoF9T/MeE74059Ked6uoOAuFujmSeUNyR+AF7zZU8Qz/KwntvvVp7ASlv4oNG0yk/Hu1ftEnA5i3BmVMO3toWNLG3tP6T/BkmpN6GGLbYyMZCWMBhv9m1p2fIQnSbdNv3psHbzTpuRv+7MfmXcbdH6J0GhAxMXJ7303dUEJb6GX0tI24rnQ4PoPN1hUkC3VVB6NbUh0NZWeDmoHIkznBa+fopIyc9yLh6ecprqh3Q3M3BAYg4ifVLy5bUAUWZ550benYlzoy/9H+fdoGzO1ZLT5A/1CY4ZRSN7L4TE7LU8CTnrsauOTI+pdayXOEDO4UfGv95sbN3EUQe0J917Bbgf6kHok+Ke0THxD4Eskm5e3GVNBZnDZVbGRVOWwAOUtjLck182JERFj4MNPCihj6LXIX0ArSS7EJELPNBPN2tdO1WLHUOTHjgZneMmLHzPoDqtIEXLzWrC1vAceODN2TkQNlnGXhMrFlBoseyf2BFAicYP8rTujPnRVt5DRFNzNZyGyLtisLa0onKkAKpdYu6ibdOpsb374G626HUZemzzjmLPsQyEknnZ+ib+3wSFuC1hSiDlpg32pVJprSyCJ+UlqeAL6yJhrdsA/gL7IFA54CuTour58/JfikNOWOpkLqSQaIPCjy7NR7NdUj3TfFZGrpeaOvUgtEGomh1Ex/Vyh3hEfvQPD1LHyXoSPYmqTL5Lw9Imp2CqXWePV+r0RERni/AQ4k3IKe+v8Y4txQUIRvWcNiZ+AyMXHCJ69PF7Q2zz7j5GFHjB15Ub7EjlNPHTEYeOD2LCNGgOBFUj64kOpsl0M4mJc88kNNCD2RRWXWb68KigIoUK/61TwzRP+IPRcCVqD8NAjm/QI7mcwpNTcQ9Fh/l4089XkiY4ZcJxGL5V8qlMStohLJWmtp6ROtBgp/eCfCZKDQ+Bg1tYTx2H4jST4QieKE2wuZ941
 LH/k0AGU
 8MBSN0A4RXXDZqy+ybj94I7+oTqesoOci1Fy2sZmZYK9A0iECJYLczvvUMbB2KSauJ2+zNWzxGC7iAiypp7gabl72DUNJDt/sCfhgWw7f9rEgtqkiM9zpAy5aVxcAbaYoAjD6spsNx65YZNRHfCilM2SGnCmRgE0YPBoUiD2Fbb2gO8/QeFVZiCzT1gDJR7aKxP5fU/6kKRShymPVXjhL0IXirhg3TmYnXd674waerXHqca1+zS8bUagy+FxP+sz0FRq79aWXq6aBQePLIGUcNiBN2s0kSDI6pZnZ6Jzd5omiQfNlALtYSQkiCdMbg6kmp45nGDPlTGab/wkoFfdfZA2DWVCl5PIufKWJkLXygSOjCjw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Call install_poisoned_memory_table() while boot services are still up,
so the table exists before the kernel that will flip bits in it runs.

x86 does not go through efi_stub_common(), so the generic stub and the
x86 stub each need the call; on x86 it has to come before exit_boot(),
which is the last point a configuration table can be installed.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 drivers/firmware/efi/libstub/efi-stub.c | 1 +
 drivers/firmware/efi/libstub/x86-stub.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/firmware/efi/libstub/efi-stub.c b/drivers/firmware/efi/libstub/efi-stub.c
index 42d6073bcd062..008635eb5027a 100644
--- a/drivers/firmware/efi/libstub/efi-stub.c
+++ b/drivers/firmware/efi/libstub/efi-stub.c
@@ -179,6 +179,7 @@ efi_status_t efi_stub_common(efi_handle_t handle,
 			 EFI_RT_SUPPORTED_SET_VIRTUAL_ADDRESS_MAP);
 
 	install_memreserve_table();
+	install_poisoned_memory_table();
 
 	status = efi_boot_kernel(handle, image, image_addr, cmdline_ptr);
 
diff --git a/drivers/firmware/efi/libstub/x86-stub.c b/drivers/firmware/efi/libstub/x86-stub.c
index cef32e2c82d8f..f90de11bc8855 100644
--- a/drivers/firmware/efi/libstub/x86-stub.c
+++ b/drivers/firmware/efi/libstub/x86-stub.c
@@ -1023,6 +1023,8 @@ void __noreturn efi_stub_entry(efi_handle_t handle,
 
 	setup_unaccepted_memory();
 
+	install_poisoned_memory_table();
+
 	status = exit_boot(boot_params, handle);
 	if (status != EFI_SUCCESS) {
 		efi_err("exit_boot() failed!\n");

-- 
2.53.0-Meta


