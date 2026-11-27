Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40D51606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 02:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=PrZ0fgys
Received: by kanga.kvack.org (Postfix)
	id C97B26B05B0; Thu, 26 Nov 2026 21:40:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C47C36B05B1; Thu, 26 Nov 2026 21:40:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5D6B6B05B2; Thu, 26 Nov 2026 21:40:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 811326B05B0
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 21:40:00 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BFF35A7536
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 02:39:59 +0000 (UTC)
X-FDA: 85479344118.26.D5C66D1
Received: from mta0.migadu.com (out-17.mta0.migadu.com [91.218.175.17])
	by imf28.hostedemail.com (Postfix) with ESMTP id A6098C0003
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 02:39:57 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PrZ0fgys;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of enze.li@linux.dev designates 91.218.175.17 as permitted sender) smtp.mailfrom=enze.li@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795747198;
	b=hOfsswDbtLtEGRot1EthpZXXOhYVQSIXtaPeyJeXOlceE1hNWhi3NM5b9tIhuvHcXs8cBU
	aIztoeLRApKKutTUWBAwVlL8CwBOa5uujeDry5rVzmKrWjnrIK+9EyGMA3qRE2KPPfuqkQ
	RJXCNWjE8XpScZjrAvn3eV5QW3qnXOk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795747198;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bsNI4Fukd37GtbVgvbYgtrSl9ji0CbnwHNz5uiG/joc=;
	b=xfNhfpqVGU/a5ilCJ/GvVuh4UIJ8S6UZAUQR3T6gzMZUifZ5TYpHIjvacGKVRS3PN1l2sr
	haKriAs1MIWXFCNoL4oy+aoNb5QlhirYlgzdFC+Jv3UcyMKwoFzVlqzM7WVWLPA0vGRfpN
	H4pYok8ilkKozCZ9i0f6Hs3w/VZ0/UU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PrZ0fgys;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of enze.li@linux.dev designates 91.218.175.17 as permitted sender) smtp.mailfrom=enze.li@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=TxihfaPAvNj2FoJou+qWNwzbBmmnVRhOZntcNwYjNNM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795747196; v=1; x=1796351996;
 b=PrZ0fgys4yaE0E+vS8yA8a1stTPQr8LOaKK7fK9PGWAOzGW/tmtXBy/EwaMB1WEqVrF7bse2
 Iqwp+HPAi1V5IunSUIvdZPOHkcFA3+DA9EYDlMnhQtx5cRHcaToYZP8gKqwBs+Z9BCwS/XjXDDG
 TBmBm2VKVAzjpMR1hvscV++o=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 08b58659fc6e016c;
	Fri, 27 Nov 2026 02:39:56 +0000
X-Mizu-Trace-ID: 08b58659fc6e016c
X-Migadu-Flow: FLOW_OUT
Message-ID: <25499f99-52c0-45b3-9198-53c3bd752c53@linux.dev>
Date: Fri, 27 Nov 2026 10:39:50 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 08/27] mm/damon/sysfs: implement report producer type
 and state files
To: SJ Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org,
 Aveline Noir <jm5905938@gmail.com>, Lian Wang <lianux.mm@gmail.com>
References: <20261124153636.91854-1-sj@kernel.org>
 <20261124153636.91854-9-sj@kernel.org>
Content-Language: en-US
From: Enze Li <enze.li@linux.dev>
In-Reply-To: <20261124153636.91854-9-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A6098C0003
X-Rspam-User:
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: pspgoxm7z87coipdskn3e4dytgwkc3bw
X-HE-Tag: 1795747197-547813
X-HE-Meta: U2FsdGVkX18G7UAQ0uXpuAF6+pEtB6P6iciYC500GAM33ycFnCuoxRoJsgfdiyVbh+/m8BuxdvQgaTxlZJjH8Drqp78vSW45O8dgfjBP/CW7hIzaHzQcK8blDA3QuBalvleXOJitzsJaECbjRP8Q/tCm+eWvrCyW79z0k9FNiovffh4bYcr1/dGwQu5+8ffBapggdZFxgOAn8EhAsmQc3YG4CH5IiNTCiD+JWJY/KNDu0cqPVx+MUK1CAfGELRLXOqcod/Vd9N2+nDSRdAP/VLIIaRoeOMyLb9cDXp76EADWSJ9sFqmaBRiCrtx+faAkeXMA55xEMzmdDQa3YstvHC2XxcseUJOUTllLA531c/RHcl7KP0zK1eL7cBJ1xwkRMZhmKcjyIh2ER8lzLiXFdSAz046Mm4epDoYpu9BL8Pv6DVwxKLlY1TdHMR4Kv/NW0mDggPUSAAN2eUfo3jEaqzxaMJzlDR0aFZRsbnnl/Z8Tl8NIKoF3vup0xOOpK3Wyy5cAkcSwIYTYkJIDb1q5J5MpYrP2JyltsaK7SgOz9Cv3CG4zAaxnIZ3EOJA/hVajoYVkzazzwUF/s/iQxY/XaG4G3ri57l9NQ2T+/ubNKixYHAIPJcTqVxNRLJ3nywKUHt6e+WeSVzyTTpkaST3sr0z2SAG0NGN3g8K5i/QJMZsrdwsiqzlgosgtLXt8QIwePHKRQhlN9rwXKq6U/b4Ctoxl3fHwTOvJWXYakNGKXNbKi7b+1Fg4FSuGK83pSpeoAqyStNEjXX3FdT9k7zgMTi71+HBPE3CKeoO/kQOBUy0JlSfhTLlY38zmar2P8iQf/WnyiMAK+wor2BsAeijDOKI3WD7bV/OXQa8mYpqD5f1612LkYUMpfYjw2rvCHE818F59ZP60zkwD47DSkt/1uCochdForupVorxp5K+GDdUn0OGd84jO2IAR1Sb8hVCd9qDK7BEmU/OFOaddJ0y
 9oHUhCGh
 f8TRwvE9iR9FDu02sDKF8yxs4qrVqsZ/H24oVrIKVvTt3OUlZ/UZyfz2YaBjJBqSr126qL5q/Y6vw2qlkN+6h7S+vWKMLWvuTaJg4rDfugaW9TMTsV2iF/rVDe1IZHMP6Izrbq67ApxyH4wdpOpbcVIViYgFqLVmhYynzRBLy3LwxhppO9rejjdLje8FPsITFrnn4+yb+IPgt3JhOqhnw9kDFd20aHjnWZbkYEg1X/FUlpgVXSad3YKrR4G/ngYeRtFly2qatDRwZNpImSFQ264Z24suAoDykNhsKAeVhQrALZZLw1cRLuFUu0dKFRP7eA5JLX3btAzowbpmZ26l5Y9EEpSmaWLehU7pzaXOJRyU5z4g6rmR84utjQKLmdfC1PrkT3SXb9XGqTp9s+skyH5BdWaGnCWp/7JowhEb9ux3wyJ1Qlb+f7jbizpXWDck9gRsKtxFsPSMVORhETgDEe7areNt8v0heecc+cFwlmmomIbyBHOZIcePspXAEYxb2ADMYrU6Temuv/q973yG6+JinuqT4ehEFpkradZOE16SvDLsBCaL4q085xnAI4F86HBI2H29IC8zUibCXMySJX9UGGSFZPeHeEH7Xi/tjyNScc9w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/24/26 23:36, SJ Park wrote:
> Implement report_type and producer_state files under the report producer
> directory.  The type file receives the type of the reports that the
> producer will generate and submit to DAMON.  The producer_state file
> enables and disables the producer.
> 
> Reviewed-by: Aveline Noir <jm5905938@gmail.com>
> Reviewed-by: Lian Wang <lianux.mm@gmail.com>
> Signed-off-by: SJ Park <sj@kernel.org>

LGTM, thank you.

Reviewed-by: Enze Li <lienze@kylinos.cn>

Thanks,
Enze

