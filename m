Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A03E5FA1FC5
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 15:43:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06E0F6B008A; Wed, 22 Apr 2026 11:43:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01E586B008C; Wed, 22 Apr 2026 11:43:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4EF16B0092; Wed, 22 Apr 2026 11:43:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D704D6B008A
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 11:43:57 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2A8EB160253
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 15:43:57 +0000 (UTC)
X-FDA: 84686612514.08.38F86A8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 4AF741C0010
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 15:43:55 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pPDUbcDE;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776872635;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1TSKq7m9YTiRED0YZs64i570txDyYIEyufBV0KDLLrI=;
	b=b6qyRnXkbJAWA4q6RCFmJ4QsvByQgmursOd/EG3ebuBzG06mcUKJkxbW8kuWgCnAROmDyE
	UupaV7pAHyVuiWjD5jL8kyXRd/7XtnRebv/SNzqx/Y76Vm1jWKYgJrwmTjdLCjDP8VW9XL
	QRqMpT7Mwq4L0+T8UivmqZFK4+q8tXM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776872635; a=rsa-sha256;
	cv=none;
	b=OjMAwv7L+lGSyzQe1+8X3npAiUVS5Lkp56Ax/QZgWM5wgs99K33K9yFEI8oZth8L2zga5z
	rgx0ni+BENG6awlWTLvwaC69G9kbcrwzoR11weQWV1jl3LZvfJbHp5duQIOb/Tv845s2Mz
	CfrLNhoZhOwCtpAZDaZCfMuIJPokjec=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pPDUbcDE;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2308C43E66;
	Wed, 22 Apr 2026 15:43:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7792EC2BCB2;
	Wed, 22 Apr 2026 15:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776872634;
	bh=bSgDOG6lzfgO/ljMm4bJcNMq6rCw8HqrHHpgHsPDBAk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=pPDUbcDET9pLZNa5Bl4xwjZW0E9eclRsEE22rJTrJS4uwljiiJLt9WUyumbsE/6DC
	 dbve53F2CWb4Bnc+0fGpedvW2gVo0HDefSnSQnaKs1ilKCk0fAmBzpSbm/3bZNA2iK
	 +FPk/aXDIjCSmDgsdr28ln+jHDHPwTBSSWVPhniHLXuzzmg8RCWhJ8ADwknFwmqDuM
	 UcvwxrSsM9q/fBf0+lwLr/aPy07xawdL9MUYJAmUq/t3MzkyKk7wX3Z4YDLPF0Ra/r
	 Kfucg4bDLcbWIZHBtCXm2zpYOO+zXoTt4vpehq2JA2VBBRRjOyUA9X+S2R3mCtMK3y
	 HvbT0foEMzvmQ==
Message-ID: <3aebc7f9-478d-4c21-87b2-49bb69cd2de4@kernel.org>
Date: Wed, 22 Apr 2026 17:43:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] MAINTAINERS: fix regex pattern in CORE MM category
To: Pedro Falcato <pfalcato@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, Vlastimil Babka <vbabka@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>
References: <20260422123726.517220-1-pfalcato@suse.de>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260422123726.517220-1-pfalcato@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: pfxtunjyw4tqkp9ypwfsoxr9mamzbup7
X-Rspam-User: 
X-Rspamd-Queue-Id: 4AF741C0010
X-Rspamd-Server: rspam05
X-HE-Tag: 1776872635-108334
X-HE-Meta: U2FsdGVkX18Wpg6AyjaF/eakVFAwu3PtS0wHgiqnFpKRRPrIrgl0f7XDC0qalB3VnL8sNZ/zs24PttLLpICrC6WFCNF7mL0WJID4sYwKzlKA/gmgWoA721+hYIuv2d137/s+PCyNWKmBvnTG8YMuE2697YBhhjqPVskHhfCvT+lOGUUSk+32M42H/nQLj6GBGLO6lJfPph4x2lHqGj3O/3y+ShjyiIs77P4EkNZ7fgDulrmSqVZTn73I9cQ+u+QE7mLtKMf5r/UxN2C7E/KIFXZEqNWN8wgv2Vg0xxudeuFu7xcxmxZF9YB4MDWpjTlHu+S7M5BYZo2V2lkyRdUHYhnkH7Rk7I7kCJmWAu5PFeGgTLThYTWz/oINIxyeXkKmKJShNGSYrB0HcBfI+FykRovE68TrYff75QYbiq5q5H139i3qm4TcSfzbyYkLxTUTUcJOToMXZlSHN5f5Z0IVhizPuntAmrOJ7z4YQQcCYf+BbD8lL5pkDYaYLLFE7NqswIBjfjNSWMvSlbOEkyvnCdEuVHqEOxRNxADeKnsIoXDGflkG139bVuCiJotJO+01q2T48saNpSKhq+TwPotLXTMiutq7sEEzwoU+kr0CEsEC9+vWXvJlyiud3ZO8cKtNN4O243IE+gB+F3ZbB8LIs5ZwR0Co80wMYAaE8X4iMAIBgKQmwlNaMJTK4CWxXbO/ZiA0EbS24+TH4L9gk1e/zWMnTHjsnwIhKA+kcPcHAEev6KoOkIMzWABeW0qXry1rHHT4v5+ZzwoHOAbl0fzRXYgYNIj2aOatG072J59XErzG6PIohvLIi1VAdhrdcx+nHGudODNm4TXAy16n/BSdW0mQRe5YMPYS+Z4wVT/R1tRxD/C1kP7UEG0GF4TP/syWZjlrLDOVN6ISmvgIA2Q36L0iQfuejBNzwB4USZnf4+S7NaGIyDpHWTVUVrfdPckLvRiK10ZyWENBiH/0F2/
 La4uo8ax
 XPqveHnA2VRm+JTxR5AwpBtRi0HbS3gvxnLPMLZ34kCsFExiknkz3iXDVy9LoT+mPYwvXBsqYDYZxoGdXiy4DQ0M5128UPIaDpG8U/1GFliP2pz4wBoBtm2jpfclIwHJ676fEfSmslLpW06BtoSoT8jEQIyxAepB3Vk8pY+omQppAsfI2zgUkj2tvm8nzByVWmFwMaMX8PPHTocQneDiCEDLEMXimWXK2eO0U65RNiBXDu+3S3KYqSgMTqU1il/JGlmNMX+SsgpVU2JX250k0QoN2Eg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/22/26 14:37, Pedro Falcato wrote:
> The pattern "include/linux/page[-_]*" matches every file that starts with
> "page", because it's a regex and not a glob (so it has the meaning of
> include/linux/page + match [-_] 0+ times).
> 
> Fix it up into a more regex-correct expression. Doing so reduces CC's
> drastically in patches that touch pagemap.h (which is maintained as part of
> PAGE CACHE).

Nice

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

