Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55AD6606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 06:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=TkffKvDL
Received: by kanga.kvack.org (Postfix)
	id 2DDDE6B05BC; Tue, 27 Oct 2026 02:26:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B66C6B05BD; Tue, 27 Oct 2026 02:26:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F3B66B05BE; Tue, 27 Oct 2026 02:26:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E81646B05BC
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 02:26:47 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A19BFA0991
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 06:26:46 +0000 (UTC)
X-FDA: 85367422812.28.E07D997
Received: from mta1.migadu.com (out-98.mta1.migadu.com [95.215.58.98])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7B470120008
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 06:26:44 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TkffKvDL;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.98 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793082404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JApMT3Jk5VyCBwse/OVboAGUFYn9KvHGlgoDeJ4WPjA=;
	b=wsocFhp1Ku9DgTHGNK83Aekfnh4V97sCWc6q9FRg7NV6qWEE85yN2rm9CSYEe0D2g71S9s
	wYP635l1W/r/69iS/RuWwBqgCXfMB7xIA1tnWnvxzsd3h4+xOTNrkx96kZyu73cioKR1+t
	SZt3iI0kPsFtYGCUEKvs/j+XtDQuCxo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TkffKvDL;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.98 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793082404;
	b=mpsvOBw8Eh1rR2p1tS7mmvMJAbi+POyFEFEfvhsT9uEofnZ/wJ4zMYWffyLy9Q1BM5A2hG
	98yXWNCPpQU1T2Uw61IwLcyEqgsDgQ5i8ckeOEZhBAsIXXnhJ1kv8WxXiXpBjdiNRU46PQ
	l1JvNyMukZ1eXccUtJyTzWA7RkdX6cs=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=WdJ8q/qOZUrrSPW8eotn7OBkvk8avtiYOcl3YbK7hbQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793082402; v=1; x=1793687202;
 b=TkffKvDLxSo3OWM/QC6T4WKh7Fk32qfv4J71Yu/RTQC76zdIRxB8+CV5Ol+W0l4OGgh1NGLo
 vqwFejjcAQcZJN2gH+2kSvuwtEygV6WWnvvjxinf3+AUQWk5XLa8SMJuw5GBrhynuTjMex9/ELU
 oAXj33AmTAeEmrmuxm/NAi38=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 6a661d9b1f097f12;
	Tue, 27 Oct 2026 06:26:42 +0000
X-Mizu-Trace-ID: 6a661d9b1f097f12
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH] mm/hugetlb: use account_new_hugetlb_folio() in
 add_hugetlb_folio()
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261027060446.289404-1-lienze@kylinos.cn>
Date: Tue, 27 Oct 2026 14:26:27 +0800
Cc: osalvador@suse.de,
 david@kernel.org,
 akpm@linux-foundation.org,
 linux-mm@kvack.org
Content-Transfer-Encoding: 7bit
Message-Id: <B2F389B0-59D5-4379-A158-D608066398FF@linux.dev>
References: <20261027060446.289404-1-lienze@kylinos.cn>
To: Enze Li <lienze@kylinos.cn>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspamd-Queue-Id: 7B470120008
X-Stat-Signature: czj6fx5445ujfydj7ozxtx617qq3n8cf
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793082404-429880
X-HE-Meta: U2FsdGVkX1+dshE/45TcLPpgGHfcIabDRoiBKTkmWe/sUNiOm7KaUzFeFS4sM8x2vT+N7AFh0AjNcjvI5iQJq4WNBMLYt+TLvNi2TmyBvXLkMgmYm4+wtCqzJOVZNKlKwvSY1T3Lf/VPu3FT9DSTiLAJ4nVvYrSBRXXpnklfls6T9Cng/Zuwmuh/R6L8oeg3du2Krt1jag0cUdrdrPMWU3+TijUMYca1M/ZsL1E2SMpty4BATEqYaVHPwZlPTeMvkdW41k22+RCf+QXHk6/i9uk3C2Fyt45qe9rnm50JkeYOyh+zyfv4mMTiC9ncLS0JVnkTeOAVmIq1nF0D6Ev3EINapAzEvCmwjHCRbXJLvvD9HFPtO7WCDI0Ay3mm7OR4Dg/d8X1icEvV4WYXAPQ2iGs+yMZ+2GXgMowEZmdm+4XKn7SwCx+4VpXUznCkxslS9KNjl2LcHICj52z7TJZITt4YOPnlIKSCWIj1ESM8km+34+H1tGwpOIHGlmU8fJeg6otb5N8T+82A8ZK2fAtC0wlqNeCOOZRoaAEUf6L8+p+wCY3ej2pOC/kmBA+4vUktM4zqIPrbGDIx5+/yYl7nsHBBG9DHS6BydYTmx5uwOfJB2fx0LR3xW7KnKVStrFTS2ksnqFa4tcjkna6FOKF3gQXqhuH8GprEnFYmYDbX5NsldIhG16OKGHtzjT89Y/zEbu0uBguY7p66WtnBp0foXv1MNkcNvv6KWKrgAaMgoYflotLFhRh0OuNdxb5hUehq6NDXzVV3WKzXU9U+ttIpcaW2tkhhIU0tmYzbItX0YdgVPXlvJ/Ih6/Yji00obuiUqh2T7FhJTfinnnn7ZXH8kIa5HZcX8H0xHjFgXQx7ITJI53fi33DTABbloG4+rQPbarrV7AkAFCetGsZVHRn2ncge51ZzOWg8UOwtxU+rO4LfYV6r+znwvRNv0vQesnh0sXRVfduQjut+ws0DWh6
 u0V2TK07
 Yj7HzbraRbHkLE3NmJDBWbiWzS8+LIUYdD7z1TAC779Z5mcPhINl6FmYOdOA1J08gkqiKEcSTmYLymLhyuJEaRlN2t06WsMT8CKtdmwgqoKHrnsGUpDDUL4LLO8JAN81+dtm/W7/6j+q918HnHtO43NGncTAWnw+dUWSq0Hpd2jjWP6Y5lQhyIsNni5sLmSUXJTZxm/N7f6kgFbobsLNfySiymEr/7MlzdlaEH5CJfUjSY3i/DnZ4vml3EjP8gkxP2ACissYW23TOzJcNDrSzjAlO2ZP6BJZcJcB4eQIpb0vBufcmU3tBrJft+w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Oct 27, 2026, at 14:04, Enze Li <lienze@kylinos.cn> wrote:
> 
> Every other place that accounts a new huge page already calls
> account_new_hugetlb_folio(), and add_hugetlb_folio() was the odd one
> out, still open-coding the same two increments.  Swap it over.
> 
> The helper is defined further down the file, so add a forward
> declaration for it.
> 
> No functional change intended.
> 
> Signed-off-by: Enze Li <lienze@kylinos.cn>

Reviewed-by: Muchun Song <muchun.song@linux.dev>

Thanks.


