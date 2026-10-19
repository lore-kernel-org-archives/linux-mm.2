Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F764CCF2DA
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 08:41:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E45496B00CD; Mon, 19 Oct 2026 04:41:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1D7D6B0173; Mon, 19 Oct 2026 04:41:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D32E76B0174; Mon, 19 Oct 2026 04:41:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A34E56B00CD
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 04:41:23 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 20A841606E5
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 08:41:23 +0000 (UTC)
X-FDA: 85338731646.20.810AAFD
Received: from gwu.lbox.cz (gwu.lbox.cz [62.245.111.132])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8D6A340007
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 08:41:20 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linuxbox.cz header.s=default header.b=uEIFfeil;
	spf=pass (imf11.hostedemail.com: domain of nikola.ciprich@linuxbox.cz designates 62.245.111.132 as permitted sender) smtp.mailfrom=nikola.ciprich@linuxbox.cz;
	dmarc=pass (policy=none) header.from=linuxbox.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792399281;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uX2TPHTXMC8dGzpy+XOl7entqN+gnCyUv9Ljjb8ldcM=;
	b=GngUvb6hFKyWOIovCuFByiXhwROui1LZHmhS4fZ13OjENriawUaLWq0vhgGIycdsA8vC0a
	QTYBNIKdhmhJnT65GDNsrpaOgo3oXJaKZMw3v8yz1iQRRpo1lp011/bxpJWxicFsi6VEAq
	T2fa1EYYUpxx42jLC7i2cmPzpnqxUrE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792399281;
	b=kREgxM1vhmyXq37soW9j4pW0BWpdatdyAEnLm7+t64lNNB8bGPuzvyTt3AWJrgIO+3jC6z
	ijLFbcjjwgmEQsOg1/952W21kkKkjZNL5bHRRqK1vJS2VdnoEncYxj3U0W1FaOeopm4w7V
	ykXr9jexnVruM2jQQP+Nf3dgAl+7Ens=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linuxbox.cz header.s=default header.b=uEIFfeil;
	spf=pass (imf11.hostedemail.com: domain of nikola.ciprich@linuxbox.cz designates 62.245.111.132 as permitted sender) smtp.mailfrom=nikola.ciprich@linuxbox.cz;
	dmarc=pass (policy=none) header.from=linuxbox.cz
Received: from linuxbox.linuxbox.cz (linuxbox.linuxbox.cz [10.76.66.10])
	by gwu.lbox.cz (Sendmail) with ESMTPS id 69J8f2hD1170196
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Mon, 19 Oct 2026 10:41:02 +0200
DKIM-Filter: OpenDKIM Filter v2.11.0 gwu.lbox.cz 69J8f2hD1170196
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxbox.cz;
	s=default; t=1792399263;
	bh=uX2TPHTXMC8dGzpy+XOl7entqN+gnCyUv9Ljjb8ldcM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uEIFfeil7ssJaBBmWiND1ItLKsRJcy4DAmF8CjtZoPI/WuyjzOd6Y1v3cTPpveuVv
	 UOFr7zUgvX1dpfRXWXwgxD/+oxJVmazECRLFL8MmWeZ1QAVGHX8YC9I5Ynsa3rnWvz
	 nIqJMTT1ibf/Y6p8ov3oRP2e91HaCdWzaguNav8U=
Received: from pcnci.linuxbox.cz (pcnci.linuxbox.cz [10.76.3.14])
	by linuxbox.linuxbox.cz (Sendmail) with ESMTPS id 69J8f1QH023969
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Mon, 19 Oct 2026 10:41:01 +0200
Received: from pcnci.linuxbox.cz (localhost [127.0.0.1])
	by pcnci.linuxbox.cz (8.18.1/8.15.2) with ESMTPS id 69J8evSi3176760
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 19 Oct 2026 10:40:59 +0200
Date: Mon, 19 Oct 2026 10:40:57 +0200
From: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sean Christopherson <seanjc@google.com>, Borislav Petkov <bp@alien8.de>,
        David Laight <david.laight.linux@gmail.com>,
        Rik van Riel <riel@surriel.com>, ljs@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, david@kernel.org,
        Mike Rapoport <rppt@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Pedro Falcato <pfalcato@suse.de>, Kiryl Shutsemau <kas@kernel.org>,
        luizcap@redhat.com, pbonzini@redhat.com,
        Tal Zussman <tz2294@columbia.edu>,
        Matt Fleming <matt@readmodwrite.com>,
        Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Subject: Re: hunting memory corruption bug in 6.18.x
Message-ID: <atXXma5NXxoSWJO0@pcnci.linuxbox.cz>
References: <20261009090042.39ba9c06@pumpkin>
 <aszH4vpXFAOQP1WG@pcnci.linuxbox.cz>
 <20261014235736.GCatAW8GD0GlYumL4l@fat_crate.local>
 <20261015172820.7961d2c0def74d41cc6c4b0c@linux-foundation.org>
 <20261016031242.GDatGWKo98YSOhEOOn@fat_crate.local>
 <20261015211832.45d87fab15bb3e0bbc2f47cb@linux-foundation.org>
 <20261016054954.GEatG7AgMNFRkiTo1H@fat_crate.local>
 <atI_yuCc4BiweBQP@google.com>
 <atT5TYyLapHO5ZoX@pcnci.linuxbox.cz>
 <20261018201538.d0957878f378a9821852836f@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261018201538.d0957878f378a9821852836f@linux-foundation.org>
X-Scanned-By: MIMEDefang 3.7.1 on 10.76.66.3
X-Scanned-By: MIMEDefang v3.7.1/SpamAssassin v4.000002 on lbxovapx9 (nik)
X-Scanned-By: MIMEDefang 2.86 on 10.76.66.10
X-Antivirus: on lbxovapx9 by Antivirus 
X-Milter-Copy-Status: O
X-Rspam-User: 
X-Rspamd-Queue-Id: 8D6A340007
X-Rspamd-Server: rspam08
X-Stat-Signature: 35mep7w9xnsprinia1yzohsdt3b98mz8
X-HE-Tag: 1792399280-833328
X-HE-Meta: U2FsdGVkX1/Ltvqbk6rKmFP16+vqXXOMA7GhyVj/tn6/lTtCP3cJIBASH1dDkfvqb+pnZf7f7QP3a+/NaEI0SIMPFxKZLhh/zPr8Fwitw750zbxhczMSl3OsM+LVwT+9wonQXw8MOKr+DhzACcuTyK4SCKXmvmFhyIc2yDTyvlT/zeYhZ9eKM67t5u3/3Sl/jlaiG5Lp6nM7YweJUr2zfsGPeRy6SJTy8o5taTrXqFXR76prlDxaYG42ePm8Qv+wUa4mw9StMMnDPMFxDzKapq0FKyWy3hCip89q0yLdPTGNTDsCEosqN6BjTGzqzNw2jcCWZYXstsDgTvVy62xHgyALz8rUGMZ3FnoKIeMkqRvqv6KebrdI4Pbli7Wzg7BEUTWisHDNLK1fo4SsLytVo8j7J3sx0lBs05A6UbGMdd0UipIGGBnPjwKlfksUBZspmZLjNktZEX6LtCD6Px0IPYEHIaF2+i0gaLjk8N0ox3K6oNEpduEJGnrwCbJU2Xd5CI8EDrDboCPIQAiuqc2b/M7asCEclnDPCQbOOgr/wul4JcWSVIpAInK1u/zXiyM4W+9EkwyxlHD72UZ+oEG6sikP8OFrcXbcI5pDrRhGQ0Ei0C9Rljv8DNaFAKUzbtcKDdof4YTVKI/HgEYzJh197FECYcGtGNC20pWDFaiubMDdOdMSo7kg6dQ/ydWpm1dnPs9Op+kSuY57USnndQjBDSo2SXh07Txer9HENdQZpRuOkjKuDdKlBdipmIKNSumtRubZkaxwBAstAvAxPkJP1RxFJ+7b7Lku0aTmEhpQPZsLiBgn6k4Tczpx+gXLyDwY7G8OwT7BvwfKWovcqt8A8IV23kO7UotJ2qt4zosRW1c/7hT3HeM6UBGch5pwxEUwHg0GoyQWtTvAZiZQFQmXttPaC5vLDNtaIkWfOkdY0+NrNEqT+BIfijj96GYxLNHlhgcc4WiXzjH6wX2QVPr
 vIc/DIxx
 nDFlprhaqzYea2k9Yu86j0OhDaDGncBZPBuypvzlYUMbN9W+euWrC6CM2MAS1scXLRDcRqfomkJkLHEsThv4ECHKS6vijfHKHdmSKIt/Qo7ZOOKR97Z0Vhc9/tF2yg/k8FhyveqoVxml57DkC9z4rUIdyL7KxRIVvq5lyRxdoBMyEHNT2/Q4YpDAyDMxYe4Jbm8WQcmnVVXNPqQy1iQuKC9ZN0TFwInEFdHS4ncZK+ARVQrZFdHLHDGYf96MzJs//tCWx+/kSMcfE/epeHehdpZUWfGuOrTdTYbemeY2gKQn/wc4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> Well we initially thought that nested virtualization was not involved.
> 
> It it indeed is in the picture then it might have been 55780d8a1dcc
> which unknowingly fixed this.
> 
> Are you able to test that commit on the 6.18 kernel?

Sure! And I have more good news: after applying 55780d8a1dcc
to 6.18.56, I was able to perform more than 30 migrations without
a glitch. After booting back into 6.18.56 without it, both VMs
crashed within 2-3 migrations. Furthermore, some memory apparently
got corrupted on one of the hosts, since various commands started
crashing too:

[  303.466091] traps: systemd-logind[3085] trap invalid opcode ip:7f7b5667e616 sp:7ffe1afdec38 error:0 in libsystemd-shared-252.so[7e616,7f7b5666d000+22e000]
[  303.493810] traps: systemd-coredum[11269] trap invalid opcode ip:7fc6bf67f614 sp:7ffc075da958 error:0 in libsystemd-shared-252.so[7f614,7fc6bf66d000+22e000]
[  377.528955] traps: systemd[5607] trap invalid opcode ip:7f791447e616 sp:7ffe83e61cf8 error:0 in libsystemd-shared-252.so[7e616,7f791446d000+22e000]
[  377.556993] traps: systemd-coredum[12080] trap invalid opcode ip:7f97ce07f614 sp:7ffe28b56a88 error:0 in libsystemd-shared-252.so[7f614,7f97ce06d000+22e000]
[ 3746.173043] traps: hostnamectl[45846] trap invalid opcode ip:7fe00cc7f614 sp:7fff89916e48 error:0 in libsystemd-shared-252.so[7f614,7fe00cc6d000+22e000]
[ 3746.202305] traps: systemd-coredum[45847] trap invalid opcode ip:7f7fe9e7f614 sp:7ffea227cfa8 error:0 in libsystemd-shared-252.so[7f614,7f7fe9e6d000+22e000]
[ 3750.581940] traps: systemctl[45903] trap invalid opcode ip:7fbb8967f614 sp:7fff733e5748 error:0 in libsystemd-shared-252.so[7f614,7fbb8966d000+22e000]
[ 3750.612651] traps: systemd-coredum[45904] trap invalid opcode ip:7f90d347f614 sp:7ffdc7f55148 error:0 in libsystemd-shared-252.so[7f614,7f90d346d000+22e000]

I'm not sure if this is of any use, but I collected a vmcore of
this state by intentionally crashing the host via /proc/sysrq-trigger.

Anyway, I'll give 55780d8a1dcc some more migration rounds, but it looks
promising.

I'll report soon

Cheers, nik

