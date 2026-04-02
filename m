Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92E56D3940D
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 11:02:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE7C26B0088; Thu,  2 Apr 2026 07:02:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D97ED6B0089; Thu,  2 Apr 2026 07:02:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CADE16B008A; Thu,  2 Apr 2026 07:02:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B73C26B0088
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 07:02:11 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2956B1B8188
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 11:02:11 +0000 (UTC)
X-FDA: 84613326462.22.CE6E1FA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6A7AD1C0005
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 11:02:09 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DBl+zCyn;
	spf=pass (imf21.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775127729;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UhAxGc8opYkF8LsIl1IdjaD9cWJSg+aqUnBCB6N5ywM=;
	b=xZj30gugJ5ZtMrp5BV4L/LM88xptja8s3H0kiCwchNrfR54afMYWwOZ0ledTGMiGBldWsH
	WP4uq4FEwrSA3CcveP9yP7NpBRqtfsHtm1EksrTwIqkQcvOwhXjbvf1AkiXelQEU96nP03
	0HkqdQ2P6phKCDIw2MUg5M3vixo7gb4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DBl+zCyn;
	spf=pass (imf21.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775127729; a=rsa-sha256;
	cv=none;
	b=2TJ7Anh+NpgaznKBVT+ZlSxxmLZAbI+cKtNHu7m51jHmm8r/nuxesHW8+e8dpq/H61xM9t
	fd1wUSgnSJ+7y5e83aGD8lDEaRwDDMwpqa9rFWPc3LBHhLp30u0rkyVgwnayFYC+42yH+H
	3TxDeJ7ab6hyhVRaRk/XCwCKVxdffLc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4B297402F5;
	Thu,  2 Apr 2026 11:02:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73C25C116C6;
	Thu,  2 Apr 2026 11:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775127728;
	bh=rXue7LcpJipoMUYMCozk6lH3bTkan5P3GwZfTIZoVyM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=DBl+zCynIDOCPxCFBPH2j5QCCLz92m8P47ni7FQrNcjKOJKqo6dROQgdRZk+EuN2p
	 UwDVMYE1cOjZCBSATbTQ04ui7nu4IeNkvy67j8IVPsDtyPE1/aLkj+DHSX3l+xsKMu
	 ++O7kSk8Dl7WHIsRtaz7A2XvnLRzzrZ0TBL2A4tp2KmsXobTbUFPBddgxo0hTEjD4W
	 1ylVixlDYQd5pbbrlOKmHs6eQd6QWrQctQf4661K7trH5IH+oNdk5E+6FHC4sHnJRV
	 hctguEZ8TabUExxUHClRrYPMMV9bsH30KEbPEYcgg+yNtbPaP11wnwb/DADJ/UQkQX
	 hA0CcXhDRnUcw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Chenghao Duan <duanchenghao@kylinos.cn>
Cc: pasha.tatashin@soleen.com,  rppt@kernel.org,  pratyush@kernel.org,
  akpm@linux-foundation.org,  linux-kernel@vger.kernel.org,
  linux-mm@kvack.org,  jianghaoran@kylinos.cn
Subject: Re: [PATCH v3 2/7] mm/memfd_luo: optimize shmem_recalc_inode calls
 in retrieve path
In-Reply-To: <20260326084727.118437-3-duanchenghao@kylinos.cn> (Chenghao
	Duan's message of "Thu, 26 Mar 2026 16:47:22 +0800")
References: <20260326084727.118437-1-duanchenghao@kylinos.cn>
	<20260326084727.118437-3-duanchenghao@kylinos.cn>
Date: Thu, 02 Apr 2026 11:02:04 +0000
Message-ID: <2vxz8qb5hbgz.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6A7AD1C0005
X-Stat-Signature: ztazqtqh6d4yoh8p31htcahi5dg86kbm
X-Rspam-User: 
X-HE-Tag: 1775127729-36301
X-HE-Meta: U2FsdGVkX19hBeWBMW19SOzNsHDOvah2UK1EYasrrdvxTHqk2ogJAGy9GMCXSwOIcRfz0VA8wb4KOBKh1irTKqgs3c5ePGSEL1GEcJOhYRlVQMRVvn1hLOD4hqO9zkRcr9AzFpaVRSOnpkcitCZTLNuNWBn+QM8fn8D2AOjRQM3ytr+2oR0spU57fF2TK4uzbYcE1FOlZorEFSNJziOBIzTiWHRgjcGSvJwVfV3Ex4gMS5uUXK6LKqtY8nZiHa8YC3jbrK2UHO+HATAEQNM86/2NWoskSG/O1xnH58muV2UI8KxU6PV4IbjUbDlfsxffhC9r6pbs+FFfvsjoflYi+P91lSmjqqyhaKYaXX1a2RwvkrSnypCjKiqV3mm9sU0vdPaOSteuTgdKyhwU3MgTcwSI/sUjCfoGRenJeebZhXEf3avsHTxsvj0B6m3ezLqDVOUNX7+KX9IbTVOxeBeXOsm+sM7yuW3bqKgybZ/akUx5xw+zs/eqToob5/zDWBglSTMiRhSzL3BGVzYtvgGYv0ModGJjEtNmBe+YYFDuZUf6hvQ1xGf1Q95ie5IiSCEzpsr2AeQneKISMLKoiK+cPo3WdJ8WhRbuQDs7qpqwFJhALyqDPoqLObbGputPspnri72h7mTIxUf2Qp7fl3S0yXPgJYTh5dkd5Vn0TTUywd+WLgVYdsFBK8bLJwUjU+jLa2njtts2afAUpTwb2mxFA7KcCagsr9IlbrnOzzaK5TpdSBLTPqgbQZeYICnq9QlX3j7YBYuL5gfNDL1nFKbWripL+eE+FdOWLufU6y6Q0b9cKjhTN6tafhQEDJ1RiNmmY933k2mmJ2nSIkTKh5citRtsoDyKdn+feLJrrD9mdXP4LqNj5rO9+BX63yqP3dCHtDpb/IhaBgxiD8qF3Nyg1ZkGuhu9wlR4sqdk7NM795Gb17HSL9sTdpgC9yF9RAmsg/0eqSE/iIqxEygmAHz
 zQcCj5v8
 T2vE65CkI8hn5hrM8ipSdg4G1A22Tzb8chKFjpSAJINXiG2AcXCI8bydoK5zJhL9GjdBGX0ZVahy1jQxVkTDArNsU+CCpheRpzg469qQLnpKhBNFYpWGmRCU8F1Qrt9JCGIOLNbSe+DtUSUyaBxmx4TVIE+EmIuBzuAQXIMprcdOuPC4GszUtAjGPGfvK2mfueMP4u/SsIuNbpK+JcjtnvX6Fy22a2xuKEui13mVu6dNGnrE9Yqpeeb7bjvnGB0LSHEC9XTVf3KnL1zR7cC+CQM5KLpIXdh6LGVLUiq/xzhpUl0g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26 2026, Chenghao Duan wrote:

> Move shmem_recalc_inode() out of the loop in memfd_luo_retrieve_folios()
> to improve performance when restoring large memfds.
>
> Currently, shmem_recalc_inode() is called for each folio during restore,
> which is O(n) expensive operations. This patch collects the number of
> successfully added folios and calls shmem_recalc_inode() once after the
> loop completes, reducing complexity to O(1).
>
> Additionally, fix the error path to also call shmem_recalc_inode() for
> the folios that were successfully added before the error occurred.
>
> Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Signed-off-by: Chenghao Duan <duanchenghao@kylinos.cn>

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

BTW, can we also do the same for shmem_inode_acct_blocks() it the call
to it can also be aggregated in the same way? You don't have to do it in
this series, but possibly as a follow up.

[...]

-- 
Regards,
Pratyush Yadav

