Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22237C87FCA
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 15:50:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B78386B008A; Tue, 29 Jul 2025 11:50:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B287C6B0092; Tue, 29 Jul 2025 11:50:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A65FA6B0093; Tue, 29 Jul 2025 11:50:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 93E466B008A
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 11:50:06 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 47E011D845F
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 15:50:06 +0000 (UTC)
X-FDA: 83717738412.24.E5919A2
Received: from pegase1.c-s.fr (pegase1.c-s.fr [93.17.236.30])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2173C18000F
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 15:50:03 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=csgroup.eu;
	spf=pass (imf06.hostedemail.com: domain of christophe.leroy@csgroup.eu designates 93.17.236.30 as permitted sender) smtp.mailfrom=christophe.leroy@csgroup.eu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753804204; a=rsa-sha256;
	cv=none;
	b=gxRvtkk/KF0QzCtOd+NoJ+Pcog834SdPozbRrJDe9DPkwl9/ciH1Ylo59qDQFZcm4oWZiz
	ayHJJdAbYJfeCT6SabJMuGzJoKS6n9XY8NkHtn9j4oqKT06wpm+57p1DAIAuvDhvAqcwNR
	4fOdLpqeLmSMBjspgBgRD6T/xbVISB8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=csgroup.eu;
	spf=pass (imf06.hostedemail.com: domain of christophe.leroy@csgroup.eu designates 93.17.236.30 as permitted sender) smtp.mailfrom=christophe.leroy@csgroup.eu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753804204;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lZB98Pv1CMN8WPfS51j8X+ZAXoSzMIsKah9a8PgBILg=;
	b=7BD/BABOzJ9fQnXkdfos7e7YVFg0U29tJsJamd4YigXcYs9Vn6vEHveUij3xt/3T5TQVIu
	a7YRLTD/6EvHUzANHw82GjnDUoLRXrVh/QO5ydLtP7LhSiJuMpqD892T7iPzpRBOCIlZS/
	Nlcv6HVwXDLzBPb1qfxjrMvlh6VJCa0=
Received: from localhost (mailhub3.si.c-s.fr [192.168.12.233])
	by localhost (Postfix) with ESMTP id 4bs0Cs1GQKz9tCB;
	Tue, 29 Jul 2025 17:50:01 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
	by localhost (pegase1.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QjRJn_Dc9ZzD; Tue, 29 Jul 2025 17:50:01 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
	by pegase1.c-s.fr (Postfix) with ESMTP id 4bs0Cs0JmCz9tC6;
	Tue, 29 Jul 2025 17:50:01 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id F2C4D8B76C;
	Tue, 29 Jul 2025 17:50:00 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
	by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
	with ESMTP id OVsTyMLIJHK4; Tue, 29 Jul 2025 17:50:00 +0200 (CEST)
Received: from [192.168.235.99] (unknown [192.168.235.99])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id 608B28B763;
	Tue, 29 Jul 2025 17:50:00 +0200 (CEST)
Message-ID: <9e4e4a84-d929-4317-b920-d11f4bee60df@csgroup.eu>
Date: Tue, 29 Jul 2025 17:50:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fs/Kconfig: Enable HUGETLBFS only if
 ARCH_SUPPORTS_HUGETLBFS
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
Content-Language: fr-FR
From: Christophe Leroy <christophe.leroy@csgroup.eu>
In-Reply-To: <20250714173109.265d1fbfa9884cd22c3a6975@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: tu9zmubarczfbtkcqfjfnocfkw7pgd4u
X-Rspam-User: 
X-Rspamd-Queue-Id: 2173C18000F
X-Rspamd-Server: rspam02
X-HE-Tag: 1753804203-177394
X-HE-Meta: U2FsdGVkX189IiLLReCsqO5DUILewFRS0tioxK8e23FU9jywWRwJMQml9c1HyPzL1dSMq3MWrspEHMiYYwz8dl87aqmh1dD7uSlpWX3Mog5FtlUoxrXPrv1r2K2SvM2Rm2nDNyLeY6ooa3DCOcgmaryKLXwruMpmT6DsXgG7CSTdLyN7Z1OFAQoWLwIufxYy8MOT8b7ZIPxrSJ5HEY7I9S7/4Cw3p3Ii7IKutvit5eXkIyJAwQ7xMsxL+Wo9slyiMgJNxgvH/h1eDR20GJ8nI4YnENwUJ13mTpxRaVlvDppyxo4Fr2MnPxOknUG/wKN7jXBcifJDzPcB7kd/HIPSkCx1SkY0FmUn75X+SeeIPbx6x7mAHgoougR/tm1mrtl5s7FZ+VIWfkP+nGFGRrqeslS7eoRjl38oUBfIBZZ+ZafsL5uEr84N7V+GtGK9vQohoAVP1loc6fEZq2OseKHQWxKPwz8lWVU2H5vuPTQ1Ye6KxHG3hTuGzz66OhLzCD3xB3xYipjIDMPOn0tfmYjJGjXtFUiNl9OsHE09Ej6HTcKCjkvvchaQoxMyx6hvKTHYOJZzQHXC3NV6HuTHTDqMkuManlPyUzF71njl/X6jSAA9mX/qwGxjjXM9i0+Pmx+yGU7a1WPChuvouiBthKwTL4HawmEjDP4L4GS9T42295C4KT+hqqZg0IXFxiexPb6X3jGfA9ytmvbo27LxdcR5M2BiC4m2aQ2vYZYR7RklUMgXCLi4gaOumhY6tlHb+jL6NEmrgXAouej83+G5k87knD2tuMBHlrTNrXEnfIsC9aJhyHZ+EV/z4njNmZbX0tYHWHSMqKTaT2k7NMCeSsgSyV34LMvm9tgsW5cZrWL6GV4OWG81eYSQyqbKly8lSXSQHdzCafICxsB86brZUApX9XuEdwUOw+YI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Le 15/07/2025 à 02:31, Andrew Morton a écrit :
> On Mon, 14 Jul 2025 11:49:09 +0200 Borislav Petkov <bp@alien8.de> wrote:
> 
>> On Mon, Jul 14, 2025 at 08:05:31AM +0530, Anshuman Khandual wrote:
>>> The original first commit had added 'BROKEN', although currently there
>>> are no explanations about it in the tree.
>>
>> commit c0dde7404aff064bff46ae1d5f1584d38e30c3bf
>> Author: Linus Torvalds <torvalds@home.osdl.org>
>> Date:   Sun Aug 17 21:23:57 2003 -0700
>>
>>      Add CONFIG_BROKEN (default 'n') to hide known-broken drivers.
> 
> Thanks.  That was unkind of someone.  How's this?
> 
> 
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: init/Kconfig: restore CONFIG_BROKEN help text
> Date: Mon Jul 14 05:20:02 PM PDT 2025
> 
> Linus added it in 2003, it later was removed.  Put it back.

Was removed by:

commit 3be71ba84f17f39131900f44e8ef513c696a5b11
Author: Linus Torvalds <torvalds@home.osdl.org>
Date:   Mon Sep 1 21:30:14 2003 -0700

     Instead of asking for "broken drivers", ask for a "clean compile".

     This makes "allyesconfig" do a better job.

diff --git a/init/Kconfig b/init/Kconfig
index 3b6e6d580e1d..c296f6bee03c 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -32,16 +32,19 @@ config EXPERIMENTAL
  	  you say Y here, you will be offered the choice of using features or
  	  drivers that are currently considered to be in the alpha-test phase.

-config BROKEN
-	bool "Prompt for old and known-broken drivers"
-	depends on EXPERIMENTAL
-	default n
+config CLEAN_COMPILE
+	bool "Don't select drivers known to be broken" if EXPERIMENTAL
+	default y
  	help
-	  This option allows you to choose whether you want to try to
-	  compile (and fix) old drivers that haven't been updated to
-	  new infrastructure.
+	  Select this option if you don't even want to see the option
+	  to configure known-broken drivers.

-	  If unsure, say N.
+	  If unsure, say Y
+
+config BROKEN
+	bool
+	depends on !CLEAN_COMPILE
+	default y

  config BROKEN_ON_SMP
  	bool



> 
> Cc: Anshuman Khandual <anshuman.khandual@arm.com>
> Cc: Borislav Betkov <bp@alien8.de>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Thomas Gleinxer <tglx@linutronix.de>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>   init/Kconfig |    4 ++++
>   1 file changed, 4 insertions(+)
> 
> --- a/init/Kconfig~a
> +++ a/init/Kconfig
> @@ -169,6 +169,10 @@ menu "General setup"
>   
>   config BROKEN
>   	bool
> +	help
> +	  This option allows you to choose whether you want to try to
> +	  compile (and fix) old drivers that haven't been updated to
> +	  new infrastructure.
>   
>   config BROKEN_ON_SMP
>   	bool
> _
> 
> 


