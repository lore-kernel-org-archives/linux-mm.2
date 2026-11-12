Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37CE2606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 13:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BfR8WLKm
Received: by kanga.kvack.org (Postfix)
	id 5AB826B05B2; Thu, 12 Nov 2026 08:49:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55C2E6B05B3; Thu, 12 Nov 2026 08:49:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 471BE6B05B4; Thu, 12 Nov 2026 08:49:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2554B6B05B2
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:49:03 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A13AC4055B
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 13:49:02 +0000 (UTC)
X-FDA: 85426598124.24.BD6F44C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id F2664C0006
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 13:49:00 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BfR8WLKm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794491341;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kkl+icFjzxE01q0Je1m7UUl7PHHf9qq5oQVDLnVQrE4=;
	b=wGE7OV3nCdgV9yfTJ0kXPLv0FHzqf7Bu0jfUE+t42jAFrCb1WvtwS+F4pKNDFHkPanF03m
	Hjj3lswflwYOzXCNZl1UeOmAHIzGZrKC6Iv2yjnZ59EySoMiOv4y6oJMllRCIsa7Azb1VH
	QwB2d7FrNFUpyX4CebMemp7TwBdQUQk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BfR8WLKm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794491341;
	b=ZD/Gc6DELBSQtoixTHCg8iXhbCOmAXFUsnFEdnRRwKI4Txy+KS3d5rWLoOVO4qM9VuX6C6
	hDjjdS0B9EHrTc1QHG1oBcloeLgS1wa4TMU9n5btSKUKNQkr9Dv/AIPEiYVrx5lDR3/zMO
	aDzBCLsnsHoNYKK2WyOYyf2Ie57Psp8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 25726403E3;
	Thu, 12 Nov 2026 13:49:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EE841F00A05;
	Thu, 12 Nov 2026 13:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794491340;
	bh=kkl+icFjzxE01q0Je1m7UUl7PHHf9qq5oQVDLnVQrE4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=BfR8WLKmKOsDXaKLiM1Ug8DXfW2zJBjiN9fzDTa5EwV3z/sxUhZlb7IASSQ96U421
	 Mt4TsyTelm4lALktExl12zsgk/+O+uSElGKX4+AShhNRldi1RycsYF4np8RLDt3NZp
	 8zD45kOYeEt6mwyEf0cEPy7UpQBZWN7nmcvPQqBD+YWWwG/W2vcy03aA5x0fytDeNn
	 fygblzfkCt0nOWp/i5DNrXmtHLKMLXPo2+xEYTZjGBMNgySpYJ2Btfzk6TE9FopFdb
	 FX0hHNLxoFBG1EABRvXPDQGLR6rN+Ep1ph0B9qT/pSsNowZHegrNPUMrgsc77wzFlV
	 2GfEPlkisak9w==
From: Pratyush Yadav <pratyush@kernel.org>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  Pratyush Yadav <pratyush@kernel.org>,
  Alexander Graf <graf@amazon.com>,  Andrew Morton
 <akpm@linux-foundation.org>,  Chen Pei <cp0613@linux.alibaba.com>,  George
 Guo <guodongtai@kylinos.cn>,  Kexin Liu <liukexin@kylinos.cn>,  Randy
 Dunlap <rdunlap@infradead.org>,  Shuah Khan <skhan@linuxfoundation.org>,
  Sourabh Jain <sourabhjain@linux.ibm.com>,  kexec@lists.infradead.org,
  linux-doc@vger.kernel.org,  linux-kernel@vger.kernel.org,
  linux-mm@kvack.org
Subject: Re: [PATCH v3 5/5] kho: docs: update description of bootmem regions
In-Reply-To: <20261112-kho-bootmem-sizing-v3-5-f0c8d00295d5@kernel.org> (Mike
	Rapoport's message of "Thu, 12 Nov 2026 12:38:57 +0200")
References: <20261112-kho-bootmem-sizing-v3-0-f0c8d00295d5@kernel.org>
	<20261112-kho-bootmem-sizing-v3-5-f0c8d00295d5@kernel.org>
Date: Thu, 12 Nov 2026 14:48:56 +0100
Message-ID: <2vxzcxsagnxz.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: F2664C0006
X-Stat-Signature: aq5agipcjq7drqqctokf5eyrbgbti5nd
X-Rspam-User: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794491340-820277
X-HE-Meta: U2FsdGVkX1/S+S7aBzSLiYckr3DqYdPMXd5AjHDWhQcDgBbEQNHDDOj3apQnVUyzus/5LjPS3Bpb/ee8r3v3flC6cGcyqWoOlfnlP8HrCyrMuVjHpfC4dXvQx4F237mIo2wAEIYMlWy5ufjsv4jh3cObfOcRHSdobumhdRGabmhEu+vE0ZBU+Bc2Qfz9Mp4Zs1jD2gKMI6NwsUsVgephWkOc8fCCNnZ7rMnQdSSxj0D5e9YZjFMhv5d49hnYJDIqzgcO1eaIil4oeYDbSZDBrpvSViyrAscgvCjpAa6XvNKfuQwApHFRjVrjuHDOnsTi81UePygvT7jhGcZ9Qn2UjrlrIuCF+rW8pG7rNAZO5tmEMHnfoxjWYik92mXJ+wC1agTyFL0pBUm7Jfkh53pFfxC96BU+nuy2rEytYbNgFT2yW3t77VxK4YQXox+oKqLe7jH+ZZacFRcMOtziubh/hZy9zDd8cbOBfnXwTai/zwEa89cDD/2fcn1Hl4cGSzRgX9SGaP8Cbx//xh7MlWcwSuVe73D6dVh01NNN+qUg++ohijEqceobj2PFXOzDnG9nUcDQkLlBqzabQ80aQODqRjDDmjYl5sX31k0BrOH4STra8qXpsAkmNG2DlKC2gyClLbmUv/WZxWuFWLVMC858HNqiAC3XrL3dUUxutQG0R9n/eZ1mxmt1iKy3jCdjTKvNiU/VAePD9ITPoYWnwd7wftwRLPGDHdIEpfuW49acHomTCM1OQ0Pwia9OX5PXWik0M07XdsT3goWl8uCPeBaRRGA/IIxHiW2dzZLL8vC9+w3AGoVZb1AIzM1aQKTEqU/oFMRCdI5xh2kRhp9xGMsHffiLhEDQ56vl91yBrIevMDhJUFmYtFyP0+VP92L9t6kzrhNvUcu5F4xpgwYsZ+51eupd41i/oWSUAAY72q44e/B7MqR1E/s9ozCQgG+Vfc3wHP22UfWBEKsERRLqrRc
 Gj1yFVgi
 oc50to1WnAPWTetmKO6XeAe05QkltEnwuwr5YxMJ1kmsewsiLyISyUSYDJwKKPWL/8M+335FuTDPVTHnTbqL+U/kGFmiirH8ECWDBOYFVXFlJ8b5pxBrWvQDUGmW456ubEQD3hgROCTYaCxCwfi2hScgkAeYr+6FZ60haqxdFdUT1kc7E1CzwV87WGv3hHmMFim5DN2B1asKEtLhKDvzC46w7Hgan7woj5oepKMwLkJPMLS0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12 2026, Mike Rapoport (Microsoft) wrote:

> The description of the boot memory regions does not mention the low
> memory region and claims there is always a region per node plus a global
> region, while the low memory and the global regions are not allocated
> when they would be empty.
>
> List all types of the boot memory regions and describe when they are not
> allocated.
>
> While on it, fix grammar and split the description of the regions size
> and of the CMA usage into separate paragraphs.
>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

