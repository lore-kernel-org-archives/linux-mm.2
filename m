Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 972B4606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 11:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=XEtZgdWt
Received: by kanga.kvack.org (Postfix)
	id B5F256B05B1; Wed, 28 Oct 2026 07:23:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0FC16B05B2; Wed, 28 Oct 2026 07:23:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FF5E6B05B3; Wed, 28 Oct 2026 07:23:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 88BFC6B05B1
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 07:23:39 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8722C1A0C1D
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 11:23:38 +0000 (UTC)
X-FDA: 85371799716.01.EB0F721
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8C87C180007
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 11:23:36 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=XEtZgdWt;
	spf=pass (imf24.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793186616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aQOxxt/Ug+nx2I1HVmPFtJN4mCXyVI4Ns2xqozt38Ig=;
	b=XW5ukBgBS+SadYxfZKxnSoKWCRhwcxUFHqQyxPbQPM/t9nSCD8zCKMwtHCjdRMzpIY66T0
	EmhuutpNQXB3jKXc3nzuJOKI0r83iKkzjEA5Xf1U2n99Wmdok0PtnL+4f2fETCsB8M5H3f
	Ts+MQqOn80CyDaPpSWIbmitFUcoLtuY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=XEtZgdWt;
	spf=pass (imf24.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793186616;
	b=4NsKCpDUJ+Np1Zsolagd0ZIYq4VQsXPHcJOScUNMBKQtt+V6EaLjPaT5lt8DlUoDVTBYcD
	YF1LkCd+BYS+ae+LEvE45RZ8uOqd67aJqvrbb/VqZiR2Jl6XdWVUg1cgBwLdif1yIu/7Cq
	/YKf/e9R8jBuH3xRHxscPzxXBkV2MmY=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A87CE16A3;
	Wed, 28 Oct 2026 04:23:32 -0700 (PDT)
Received: from [192.168.29.156] (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3EB3D3F673;
	Wed, 28 Oct 2026 04:23:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793186615; bh=QcUSdXL17rFLIa5myQZVDt9x606n6jIroh7Gpamh1uo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=XEtZgdWtSDEYOXXcJomSuJyQq5Mzz0Mdizj3Lv2dTSyiGdaaGNcVUmebO7fsHQ+fy
	 Q/LXepNn6k46F8WKDfeP/cWjenA7HDPwmfv0vugn5SprzaAl9XP+7SOT30DyY5x2OF
	 5zjREE10nhWot68zfxi612eQqRwRtGEHBfFtM5tg=
Message-ID: <0aaf89da-41a3-444f-88ec-ff8a385f38f6@arm.com>
Date: Wed, 28 Oct 2026 16:53:28 +0530
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/7] selftests/mm: check MADV_COLD and MADV_PAGEOUT
 range handling
To: "Gregory Price (Meta)" <gourry@gourry.net>,
 linux-kselftest@vger.kernel.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
 akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, shuah@kernel.org
References: <20261019171206.3331374-1-gourry@gourry.net>
 <20261019171206.3331374-3-gourry@gourry.net>
From: Sarthak Sharma <sarthak.sharma@arm.com>
Content-Language: en-US
In-Reply-To: <20261019171206.3331374-3-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8C87C180007
X-Stat-Signature: mhfkg5acyom71ak6q7ae4bafemshozpo
X-Rspam-User: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793186616-350962
X-HE-Meta: U2FsdGVkX1/o7nA+zTuhcCIQOBE97UF4lFOxLBGG7AxJoNFwImMEP9bXA19/LC83ruCILhOII1Rnr+XOMouoObGmEcaHnQy4Dc4Haps9kQS4mFtlnE0E8uIJ7h+gsgaw6LTWqbICDfoN36y1ppN4PC3IJNdZ/6NR2rAGEJQLsEzVNDE2tkpR07BBgExM/7Y4U2GLlWGljg789qYqzSyWoAHN45V0iQx/P+VvG/oVqScXofC+ReZL8HLZWAVQ9bKsXCQoKhuvePXpVAV9JeuREi6yPSBPcFnSb+RtMVjhD5usqLkTKQKIdTGsf8QNQA34KqgDKV9yvOg9nggT24VW/n0aRK0WAgvFzbXOtpZwHRBD2ng4QsOaUY7GCMc9psHocW6pNiMzSWIpkl5HsjOOVqBz16i0mtSMbrYfLUIh53WkH70lblgq0Gw+26jYJsc52knLh0msS6x1XlNC7Zwm+FSMpKc3dv58wpJE/wNDRPabt5v4a7oe7l2QAoAo9MUtf+H7DEjLkXqddZ9oYUuqMn0+J1Fkkc19mGJ59MltnOp+tcp/Mk+xQBhOhoSw16tg/dDL/fAZLrNh4ypRl1Mu3NfKie8Axe5VZbILW6VTDerPzKDE63MPHaQJSk/8mXMakXWVG1kHFXiXzvjVjxGR3O7qCAtxSqaZF7xhvx5Wgjaf1SkcKU9uwUhGnA1A+tdR2B0WmDH318Q00YpBDqcvpJS/Ioecy5R32FDmSRpjk72YQbWnqANNartLS7ptzx9ntsMi7UhuC71gt7i+P97g6LReNHh4fW5uyEQk2+181Lzsv1fP6oEnfWzj3Wxv+1ogIFOZMbIw7ZhCDP6cU422KcVA7ji8DLDwjfWZdSkH9WMYFGhY4VwJe6vOWl+hnMCQZL1AzkEee1W2OF92qvqhqPnpnmUAbQIa7vxcghJe15YX2GBXCRS+iKsSjFpc2sCl2UqAVV4hN9cqjpNo9XM
 CbCoNUQO
 jmgJjlNXCPxWs9qva2XAzvFPSi54Bnt5aO+CaGQ1pd0h7xd7l3nEjjy+T00dSVCoQ9p88f5QX8fwMRMlwlZGjk4tdWeaOwaRJFSswUxoouRRGDk/jIlrNqnApn958nSz5Ji4sGuUMZMN9msZBzoZGrvQ/yN5eGcJvL0V1+YI9FerNlQdYUxB2EovhUoPg80Wm1rap36FBI61PL2loU4SfrMcvXloAWjUpgeLXvizz/BlrEw52JWriJrBz04HKO0tjn55svv6A5hbTc1iE9TO3S/PqMoBMMoc97tRD5+EaWc/93HsXSX7wBY5vc2LNGnSMeQLq3jeuNzbixGejj2C1JNu5+KS72co72/YSwlfa1ow0Cnf+cBhwuBKNOAeXGi5upGJPic4vYrgyllCGgpRdVWQWng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/19/26 10:42 PM, Gregory Price (Meta) wrote:
> madvise(2) accepts a zero-length range, rejects an unaligned start, and
> reports an unmapped gap in the range with ENOMEM while still applying the
> advice to the mapped pages on either side.
> 
> Check each of these for both hints. Around the gap, only MADV_PAGEOUT has
> an effect the test can observe, so only MADV_PAGEOUT is checked for
> paging out both neighbors, and only if MADV_PAGEOUT can swap at all.
> Both hints' ENOMEM is checked first, so it is covered without swap.
> 
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
Looks good to me.

Reviewed-by: Sarthak Sharma <sarthak.sharma@arm.com>

