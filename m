Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F079C87FC9
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 15:52:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B8DA6B0093; Tue, 29 Jul 2025 11:52:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 169496B0095; Tue, 29 Jul 2025 11:52:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07FAC6B0096; Tue, 29 Jul 2025 11:52:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EBDC66B0093
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 11:52:55 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9E7F5110A2B
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 15:52:55 +0000 (UTC)
X-FDA: 83717745510.26.CC8E091
Received: from pegase1.c-s.fr (pegase1.c-s.fr [93.17.236.30])
	by imf18.hostedemail.com (Postfix) with ESMTP id 99E381C0013
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 15:52:53 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of christophe.leroy@csgroup.eu designates 93.17.236.30 as permitted sender) smtp.mailfrom=christophe.leroy@csgroup.eu;
	dmarc=pass (policy=quarantine) header.from=csgroup.eu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753804373; a=rsa-sha256;
	cv=none;
	b=ewjxUUQL0U0tF3lw/BHKfJ9klUSO3T4NDZFfS/4ZyOEvcp8bUXw92RdBWTbZhE10msEUzk
	PJ63VsDVfgF+VBw+BSdcsKOB/5rf4fYmWpdozyr0/4z6hDdtyg9dh103f45vJE6Ms5qpXU
	PQDDsr+OWClI+Sql9VCpDNxNfYYNILg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of christophe.leroy@csgroup.eu designates 93.17.236.30 as permitted sender) smtp.mailfrom=christophe.leroy@csgroup.eu;
	dmarc=pass (policy=quarantine) header.from=csgroup.eu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753804373;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WKr5QxYIWZ7rCbWTiJtBWYKoVRvmvc0W4k1nyPm1K0Q=;
	b=xRGSs3/trNqaYvgy3ohs4QQS5CaoB+bRKBh8ixlJ/TLXNfEjBsMI0guvb1i2Jz23DieYBQ
	nhrM9HwHFKYiSihH9XNS7BzWo2KwMnYtUZNRvDqRN1e1yTIy7c7XKhLfDW34WtgjP3iqto
	mwjA+PyHXso/fL1t1/kBQr6zXeh8Agw=
Received: from localhost (mailhub3.si.c-s.fr [192.168.12.233])
	by localhost (Postfix) with ESMTP id 4bs0H82Rfxz9s2l;
	Tue, 29 Jul 2025 17:52:52 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
	by localhost (pegase1.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id foIBeN0qtQ-W; Tue, 29 Jul 2025 17:52:52 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
	by pegase1.c-s.fr (Postfix) with ESMTP id 4bs0H81KxLz9s28;
	Tue, 29 Jul 2025 17:52:52 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id 27C058B76C;
	Tue, 29 Jul 2025 17:52:52 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
	by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
	with ESMTP id AvByEn6-Kv3I; Tue, 29 Jul 2025 17:52:52 +0200 (CEST)
Received: from [192.168.235.99] (unknown [192.168.235.99])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id 95C748B763;
	Tue, 29 Jul 2025 17:52:51 +0200 (CEST)
Message-ID: <1c37a89e-cfc7-4d4c-89e1-1b3f1217b11e@csgroup.eu>
Date: Tue, 29 Jul 2025 17:52:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fs/Kconfig: Enable HUGETLBFS only if
 ARCH_SUPPORTS_HUGETLBFS
From: Christophe Leroy <christophe.leroy@csgroup.eu>
To: Andrew Morton <akpm@linux-foundation.org>, Borislav Petkov <bp@alien8.de>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org,
 "David S. Miller" <davem@davemloft.net>, Thomas Gleixner
 <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
 sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
References: <20250711102934.2399533-1-anshuman.khandual@arm.com>
 <20250712161549.499ec62de664904bd86ffa90@linux-foundation.org>
 <f86c9ec6-d82d-4d0c-80b2-504f7c6da22e@arm.com>
 <20250714094909.GBaHTSlW8nkuINON9p@fat_crate.local>
 <20250714173109.265d1fbfa9884cd22c3a6975@linux-foundation.org>
 <9e4e4a84-d929-4317-b920-d11f4bee60df@csgroup.eu>
Content-Language: fr-FR
In-Reply-To: <9e4e4a84-d929-4317-b920-d11f4bee60df@csgroup.eu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 99E381C0013
X-Stat-Signature: qpyr1y6xg1nc4oinohtskhqh3khwkhmz
X-Rspam-User: 
X-HE-Tag: 1753804373-120261
X-HE-Meta: U2FsdGVkX1/TOqDOvZ7fLKOYKLv4iS+aArJyMHyiV1lYaUV5GgxWuaqkztKMQPvhuiJnkT/7/HkPvnC+Glh0FwLZmOveKdCuv9OmStAPPD7Qe6PIol2k4S8qVj8KQwBsIPpbf8423oczliybqcgu2u4w79Pt00ZQuF74AOC4z2wPeeRvLftduWYWiIpGasp0F5f6/63B1EpNoejpqamzo2ZPsrc9As+npmKYwfg42k8DfvsVMAIsPsrvorgrZEzsM2kKogJuqMkieDYqwU7Lz+cI3aD1/cTpIupEoRezOG0RGkSpxZvhwdpodkVwxfH3w7pkALqaDOprAzCkf0nJjnU3Tx+5Lj9bDxWrvni+pceWeKvWj8XnB+dgm2LrL5DkK54pTHjabyvWl3vTeDLfNbQRXqxHvpHra6wr+9+ThbD0wPSZzHMMhMHlwM0XbxzdNm7u/piJJlCUT8vVXcryvZSO3fc4u7hXtsBtpEDT0CQHbOmkTLHdBxQpovaVueOlaj8mwI5hSLj5x7+Kz1LPXacjnZbfH0iHRwsurcVItwCNlFoyLTYIggr4urnXCelqysGkPs3WRrOLQqHurAjyHW88pV8gFLneYgQwwz3JcqxF9sKOvXQVkty510wDtczKuKERqqjA+fX8iXyrmBwgCXfC9liwfrZTvkXBBr5OdbWENK0zhv3o0Xueug2c00uPcFOMLkSX+0oxmNBKZAdJDo4bV3OmrClpy3I6VI25ZRy23hH/g3FUViOpRxm2PIu6/my+sTWCwxgkhs2TXyKayDDVZUZK4fiiSXiqqWnq4egU2DJXFFLaCvFQNFlnZ3jvAyzxu5tCNxi77azVbGRXzjZfoJWwX9T8IP/ttYlXGhMP9mjJrOWjBOQ7qLd/HcM430r5Urldfudmgbq8VnYcsJBSJTFzPPmy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Le 29/07/2025 à 17:50, Christophe Leroy a écrit :
> 
> 
> Le 15/07/2025 à 02:31, Andrew Morton a écrit :
>> On Mon, 14 Jul 2025 11:49:09 +0200 Borislav Petkov <bp@alien8.de> wrote:
>>
>>> On Mon, Jul 14, 2025 at 08:05:31AM +0530, Anshuman Khandual wrote:
>>>> The original first commit had added 'BROKEN', although currently there
>>>> are no explanations about it in the tree.
>>>
>>> commit c0dde7404aff064bff46ae1d5f1584d38e30c3bf
>>> Author: Linus Torvalds <torvalds@home.osdl.org>
>>> Date:   Sun Aug 17 21:23:57 2003 -0700
>>>
>>>      Add CONFIG_BROKEN (default 'n') to hide known-broken drivers.
>>
>> Thanks.  That was unkind of someone.  How's this?
>>
>>
>> From: Andrew Morton <akpm@linux-foundation.org>
>> Subject: init/Kconfig: restore CONFIG_BROKEN help text
>> Date: Mon Jul 14 05:20:02 PM PDT 2025
>>
>> Linus added it in 2003, it later was removed.  Put it back.
> 
> Was removed by:
> 
> commit 3be71ba84f17f39131900f44e8ef513c696a5b11
> Author: Linus Torvalds <torvalds@home.osdl.org>
> Date:   Mon Sep 1 21:30:14 2003 -0700
> 
>      Instead of asking for "broken drivers", ask for a "clean compile".
> 
>      This makes "allyesconfig" do a better job.

Which was then later removed by:

commit 3636641bb2c7a806c1099ca092ec8cd180063f9b
Author: Adrian Bunk <bunk@stusta.de>
Date:   Fri Feb 3 03:04:00 2006 -0800

     [PATCH] don't allow users to set CONFIG_BROKEN=y

     Do not allow people to create configurations with CONFIG_BROKEN=y.

     The sole reason for CONFIG_BROKEN=y would be if you are working on 
fixing a
     broken driver, but in this case editing the Kconfig file is trivial.

     Never ever should a user enable CONFIG_BROKEN.

     Signed-off-by: Adrian Bunk <bunk@stusta.de>
     Signed-off-by: Andrew Morton <akpm@osdl.org>
     Signed-off-by: Linus Torvalds <torvalds@osdl.org>

diff --git a/init/Kconfig b/init/Kconfig
index b9923b1434a2f..8b7abae87bf9c 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -31,19 +31,8 @@ config EXPERIMENTAL
  	  you say Y here, you will be offered the choice of using features or
  	  drivers that are currently considered to be in the alpha-test phase.

-config CLEAN_COMPILE
-	bool "Select only drivers expected to compile cleanly" if EXPERIMENTAL
-	default y
-	help
-	  Select this option if you don't even want to see the option
-	  to configure known-broken drivers.
-
-	  If unsure, say Y
-
  config BROKEN
  	bool
-	depends on !CLEAN_COMPILE
-	default y

  config BROKEN_ON_SMP
  	bool


