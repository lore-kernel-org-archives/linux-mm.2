Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CBD0CD6E68
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 17:08:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1C656B0093; Tue,  2 Jun 2026 13:08:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F3E96B0095; Tue,  2 Jun 2026 13:08:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 931216B0096; Tue,  2 Jun 2026 13:08:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 844F86B0093
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 13:08:06 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 560B61A09A3
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 17:08:05 +0000 (UTC)
X-FDA: 84835605330.10.5414147
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9234DC0015
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 17:08:03 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NNDMgpuF;
	spf=pass (imf22.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780420083;
	b=vPnECmHG6Uf81Df8twqzSLdTGgCiX120pzJAdCP47NFHCKeT+eE+1aoAyGkmi+2LTKABht
	Dw7OJNUF9k+qivVXnUwrJyHNVYLvNs2A7JunQAauquz8pOc3IHV/yDiNv4MB902TGvvUfd
	pSfw1GRn7ELcAHBWDCOEPGrVNqO2nKM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NNDMgpuF;
	spf=pass (imf22.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780420083;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NmTjsdtcsEWPtZ1rK4J/ssqszpbeEyMBBb9pIGb/JA8=;
	b=w6DGEYmoG9QU94ZtQ4vwiUSK85FjE4g8ybudgRmL/KooT2E4hpGNnU4t9nIigwt6/IT/DM
	EWjdloQ7ECBg29HmIYJeS8S0y0rCEP0/NpN1LsRJDL4nUF7tJdm+FyMIb+QFA7v3BseHil
	ZGY6VlG9i8a6gzBNV/PBt78v/xtS3ig=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 210E760098;
	Tue,  2 Jun 2026 17:08:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 791A11F00893;
	Tue,  2 Jun 2026 17:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780420082;
	bh=NmTjsdtcsEWPtZ1rK4J/ssqszpbeEyMBBb9pIGb/JA8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=NNDMgpuFP58qv/uVLIlfI9sarPKbDaMhNRa4+PTfF0jz2aBQ4vxq6RfKqtJMHoIhE
	 qLChX5g0Ye1ZQtg96r/5oiv/9NKx+46rj/aVYt2qb969aBXxarsT1YEgPLk61nJ4nZ
	 qEHsaiY1UnfX/5r+OJti+YOj2QJi8D/XaDg/tIL5Cq9ZCunJHgKp8wNDdl1MrEuo3y
	 P92T+5NR2DwtdKI7yMSIV/efPMaBWt0vCAFbFk+TzAplxfMEZKEvM18K3jtouq5tys
	 aoPh7teJRj4ofGeNoIeRu0iOoSAAySOpqVW7AzckZVbyPFhEIhZjFVxK3fB5XVa0Ig
	 pAIgKoE41STXQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: linux-kselftest@vger.kernel.org,  rppt@kernel.org,  shuah@kernel.org,
  akpm@linux-foundation.org,  linux-mm@kvack.org,
  skhan@linuxfoundation.org,  linux-doc@vger.kernel.org,
  linux-kernel@vger.kernel.org,  corbet@lwn.net,  dmatlack@google.com,
  kexec@lists.infradead.org,  pratyush@kernel.org,  skhawaja@google.com,
  graf@amazon.com
Subject: Re: [PATCH v5 10/13] liveupdate: Remove limit on the number of
 files per session
In-Reply-To: <20260602031717.197696-11-pasha.tatashin@soleen.com> (Pasha
	Tatashin's message of "Tue, 2 Jun 2026 03:17:14 +0000")
References: <20260602031717.197696-1-pasha.tatashin@soleen.com>
	<20260602031717.197696-11-pasha.tatashin@soleen.com>
Date: Tue, 02 Jun 2026 19:07:59 +0200
Message-ID: <2vxzo6hsdg5s.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 9234DC0015
X-Stat-Signature: 7r4zxeexay55wuboxkona5grcwd5zxxw
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780420083-829975
X-HE-Meta: U2FsdGVkX1+4lJZqzKoop4cSCJAcvPARHnMrMCIQVr7cvtsoV1y4z6bl4PJorHQvcJUWAoTdlI2VRL1wcbg7RRTsR/w1Cramj2GoQEAAS1MDeeYbFCPw72bakMVShmqoUnDawIsRkJTQ1/p8w8LxJ9fzWEYu1qA1HMoiI266WluIC6Rbhyjg2u1ruWpV/CO49PfCIdQDkYHkt7z+rZqmyXF2gl/9F64VLwi+khL2tGXW05BCbefXHxUfOPf/f+SRxNBjWKsTNWAYeCQRCUWz6X0PsKR4G1df7HLsASQ7bNeXLMJm+z6wIAHU7hrVQSVV6Wplr5lZIm7ABNWTpzGM7cUu9vTrsDr1SNutbdGpIQcBCfsajY9Do2HlAgCg68LSSs4d0JdJZTeOz+0hk58qOupgG7aPUJ+B70UwarGgKsv+YcfmkyGsbemb0hs8Iby1osGC9L3CMbpOBsc25gTKEsK0sEpCYIkyhk9WuU+eAbXEniCUVvuDhHpTQPUfyB+3lMPjTHqrCgIHRlvOGlteMlzy6Dqcu/+jd1MM9Oxi5vOw0L+TJq3Mz8Q8SmCrAPvPE51yABsb8eHmoSAEGFyF4o6jCC8ugQcauFjVDUCy9Ma6eUv3gLOKCw6k1TaNtT1/SIND8l41HvCU5NRaqgXXA4TtsTckUeT6Xxakz4Pzjwc02uxgY+09fQ7B4FEkEeQY0E9B+kS1c7HwRH0mRE9sNoouDtYTBbmFRYuAprXx9ASAoGjjRyPA61oypPJD6/JqlJSkSQcODmwzwMY1mvXzYzYZva+wu3B4uLEIvqomC6uc0YfhhzEcWN7gMlFznJ2lO5cnvFQn1MHbG7UMoRHnvhe6v0vBvg/0VDQVYq/ay8k5cORVJu2eta4lR7gSoXvgiimpPkTnDlHrnEVVmQ12zOvHU0M94aOg5gVw7K08aSEIMmPcdjPexSU33pPr8HJWCydJL4rVXE5kolpu/Tb
 Ir7HPTRd
 1m+Gs+CpIkKVvkBZJfne+y3eoKgkaf//vqvLxg2F9llFNRyyFah8FffzNS7eQUe3kR9dWjplysVzWo9DGN6hbXSnD85m1+1dtKXZj5oP5z34/CKSa5Z7jP7XkzNyrFB/KnBinlqWgDcICdZSYQiQ9zyO54JrV8UgvywRLgE58eYDq1R5335hM/CfiNBIpHRhU1Gmn9K503weMohTlGSWqv0DsFMHRxhwEImuzghOdWGVdVVuY4OMLC4n/xCWni14OclgTUji2rba1n0f8YoQRuY2BwrCtwtyRR/oz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 02 2026, Pasha Tatashin wrote:

> To remove the fixed limit on the number of preserved files per session,
> transition the file metadata serialization from a single contiguous
> memory block to a chain of linked blocks.
>
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>

Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

