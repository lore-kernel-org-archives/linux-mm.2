Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F20121091926
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 21:48:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6832B6B00A1; Thu, 19 Mar 2026 17:48:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6355E6B00A4; Thu, 19 Mar 2026 17:48:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54A0C6B00A6; Thu, 19 Mar 2026 17:48:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 44EF66B00A1
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 17:48:48 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D99518C3B7
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 21:48:47 +0000 (UTC)
X-FDA: 84564152694.24.AAA042A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 0A4FEC000E
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 21:48:45 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=et1Zm07x;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773956926;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1ew8A/q/bKXXF+yJ+YFjV0sAJ+klIZmtTOR4y8m/Zwk=;
	b=ZHAb3PXAe2xSH0kQyjwkuGpYZPAnWe9e6p+NMwbLyW79wabrwG/0eYmmb/aiWlaDDbn0+u
	GVGF+KzwMxjQgkfGjMdbIHBQxGqcOF4SbKfEATOG3TWYWydumm0nng0nlTAdi+L10lZ4Z1
	GaSm53INrMGUpkZL/HsxFz3xRdj99u8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773956926; a=rsa-sha256;
	cv=none;
	b=Ag8hTNFpBIGDvvT3iySdm5KE6lXXygONpl8O0ijb4mDDbaneyYkJfI0VeXwSDhyBOZWElJ
	LMSLYdtNiPCVmt+OBxMm9j2xW1vVNBQ83hil+lUgSjmWxhONWLKrguNki3eCqftCrXAFnP
	CxGLBf8MgIXA1lavlf4Ma6pUBL5z94A=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=et1Zm07x;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 105F4406EF;
	Thu, 19 Mar 2026 21:48:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E56FC2BC9E;
	Thu, 19 Mar 2026 21:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773956924;
	bh=XnzQTklrSR9ouPzmgc9VsJCQGhrX2SeFT7FyxZbT7WQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=et1Zm07xdmkYSe+PmNq7hbjk919Aa4uCh0SamqVkV9EronDzdGfnmMzVdcxryKspq
	 7OsFTrapVR7Xzg0agRnyLzQpoGxGfspujLlZMTMduhJZl/rCo7YxpEFCyogBr4+UTD
	 aYC0ERlA/0daio6rjolrBXhbO2IH9e8uxfYh2Nds3FYAjyXkA1HvCPcA5Wk0kfI5bL
	 s68eqr0RIV/5SHyHiDacGW9A90wuItRLEWCT+D3TmmeLqLj7iF/cN+XoKf8bevYYIp
	 G63lKPA0ZVCFs4ZyO47QmThbB8dOG64RmDsFDIqKzLgkYv7vj3Nm16hX5j5FT+EXCl
	 D8BBgjcjzm+Cg==
Message-ID: <78352e6f-fa40-41ee-b044-62f682f3ca43@kernel.org>
Date: Thu, 19 Mar 2026 22:48:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/5] selftests/mm: move write_file helper to vm_util
To: Chunyu Hu <chuhu@redhat.com>, akpm@linux-foundation.org,
 shuah@kernel.org, linux-mm@kvack.org, ljs@kernel.org
Cc: linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev
References: <20260319160656.1480279-1-chuhu@redhat.com>
 <20260319160656.1480279-4-chuhu@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260319160656.1480279-4-chuhu@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0A4FEC000E
X-Stat-Signature: adnikjydie8e9o41fjh6nqm1zp99m1gq
X-HE-Tag: 1773956925-64537
X-HE-Meta: U2FsdGVkX193791ANqSQ6c0HJLZo+U1nZ/iz/uicCoLgBRvgi0iLYYKh5L3ojKqqtmE54u0bEiIDXfBabpY+44pIe6ia7n2BsmQVt2846PPa6K0EDABqtntriLyMnuiBVfufaHpmMphzAwuyRaCtgqRHzpxdSjIaadK/JFyQyxA6rlkgXL/EMwwgS8nL/Ci8LaHVVwp2qC03u9rXIRTa9Wm6OaVOGu+WiwaAdFh+Zs0eEtlEb9PSlzrWk9GDchkIUYpoONUPCLTKx6Q//qGfMxOXoBQZw6qnTFPf2mDbB00DZaVfbNUfovJytb88isM6ObjSBPf4PrMnKrbtSwdqeSy/eR5Kk4dkP1HG05xxMYG3c6ax4qeWRbhZ5SdFDzH8qrOPPHC01INl0sMM7HQNh328zwEJckQjkCvub4eri07iqaSTPOv3WLR8e0SkEipZzzyEcFhfCfzorPvBw4oxFGI3HrJjMZBXWkt4hyW3aFJ5SRXmG9D1LbZmNWmVmujaF6lJlhVsi9bdrLSOFfi5lV43x2yDBT5FXJis6qblaFP3QcPIHRW5cI7cJt6yeeCp6brk/v4QCICqgjDXpk4xq/D42Nyf4sSoXcGEbZ9QC1YAzV3GSNq2UT4t/9q3pd1yjbLNOH1PIvtVXmcXucr1v4YP/URBKaEjW+6hoW4mHOIZBrMKDQ6d8m6kS5eV6/A46IVKtCpYmwQ/9rAhYg2jJwbIKG+kfRoH/n0+WrLHXKrvE0YvxhmCWoiTpDNvCekc0dlHTThydB7Z2v+l5dse7iHckE+B12PbVY4pCkdCsQPbyXYjNS/dmEAvJm2wAk3EXQ58JZdwOloX5xZaqKYhEA/XJH3+uLH2aiLCkJ0gsz/uDXp/z7KDibaJNWK8UgahB+zTr88grZl/QEyn1dZQymVMRVyv41C7AIlR5nTzCMV7JkfA1Fj26sMybKy1EqWkyP2DMoPT8rn6CU3K3zz
 NVmq0c4v
 gl1xxJo63jkMQLXye0UH66ajjTv4fcStAthPgpAYDgzxU9ozKRdAYfaAaJxTSuOcIeKmiwWCNaEjTIJl24FFMp6ZNJyqe6YOJ5r954bZKm4BoTffrKjQu9tK0qX6cVCtIHiDesi4LTFUy/r04Fy8LeewrsvV02nnKR/jI5K6cGdwNTgWBs8GTUIa8HfxpZrbKp/HC1rZEcI60P1jIA13ovRx16Xg02HpC+eIt+Ym388iQNPSN6ODPkjnlJHjaX7eehH49d0Fr8LEVrStmgrgLp/by8VeS3BDw2apPZO1unWbrB48YNlFKZvozaU4B662Hg5WQWCVqVSc7CiQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> +
> +void write_file(const char *path, const char *buf, size_t buflen)
> +{
> +	int fd;
> +	ssize_t numwritten;
> +
> +	fd = open(path, O_WRONLY);
> +	if (fd == -1)
> +		ksft_exit_fail_msg("%s open failed: %s\n", path, strerror(errno));
> +
> +	numwritten = write(fd, buf, buflen - 1);
> +	close(fd);
> +	if (numwritten < 1)
> +		ksft_exit_fail_msg("Write failed\n");
I guess we could indeed test here easily for

	if (numwritten != buflen - 1)

But then, we don't really expect only partial writes to succeed here.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

