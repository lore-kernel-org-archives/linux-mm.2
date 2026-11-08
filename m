Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02C3C606A31C
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 11:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VqAxEVHu
Received: by kanga.kvack.org (Postfix)
	id ED3106B05B1; Sun,  8 Nov 2026 06:16:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E833C6B05B3; Sun,  8 Nov 2026 06:16:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9C686B05B4; Sun,  8 Nov 2026 06:16:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ADEB56B05B1
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 06:16:29 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3C82080453
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 11:16:29 +0000 (UTC)
X-FDA: 85411698498.01.2B04376
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id AE7F3C0002
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 11:16:27 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VqAxEVHu;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794136587;
	b=NFcsvJalU4ps/5VYZSLbUPj55nXZWI0m67z+fAgRZQR+OILxwmyBsLWBl8Mhe9pITgkoSj
	ZWlRN7TRaCKZMK76goztjmRioJ5YEGNzHW55PY5fqCOwdRba5cHhpYVg0ESG/VzY6MRs5z
	j1hYlKSyn+EeUXGg40F7VvERpK61u78=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VqAxEVHu;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794136587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pTL3W/tdk+66hSBUiF9xLt8oJSgQZMOfyjWHi+MQBy8=;
	b=zADR6sPuvX8q/M+W8l4PkdZMuMDNECzHs8SjW/xoySSLmdv+Qzu9XaELfejoVLmAiu8Afb
	816HihwzVO1eHyJ23A9kfC0SJdRUyU3zlmZtxqo80Z1I7YdiNacMF84p2OtvP4o06+Tmlk
	lcIG36NcIgze98c4P9N+uOcBe8QbSM8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1518361263;
	Sun,  8 Nov 2026 11:16:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8193A1F008A3;
	Sun,  8 Nov 2026 11:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794136586;
	bh=pTL3W/tdk+66hSBUiF9xLt8oJSgQZMOfyjWHi+MQBy8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VqAxEVHuEhhuWlEGb3a6IcRZyzsBZId1gDwYYjwHpernz6+NWTAP7jGbs/6QQjRHm
	 VfC+qplsRTxDZ/vccuWSCdOmu1rpryCd9j8oOPlmOAONo+jZ0pP7qlx51TcZJVCM3O
	 4iJMzChAwjEJhqUqmKqLx4CGsRVFnzhWHguhQIzj5oB6MCGhqckA4UW6rASoF+fTX5
	 JpdLvciQEhY8AEWfhVNGoET/Cln25UEVVxOHtpsexdZf6n15F83LJFciV71ax1+y+A
	 DKcjPsbQQfbr1Te5VsGEHvxAzx4IY2Y7yOmNtDkYNW+9j0GfjPNR2zXAXG/bxyrs6U
	 /OZh+sg//YuIQ==
Date: Sun, 8 Nov 2026 13:16:19 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Chen Pei <cp0613@linux.alibaba.com>
Cc: pjw@kernel.org, palmer@dabbelt.com, alex@ghiti.fr,
	pasha.tatashin@soleen.com, pratyush@kernel.org, graf@amazon.com,
	shuah@kernel.org, guoren@kernel.org,
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
	kexec@lists.infradead.org
Subject: Re: [PATCH v3 3/4] selftests: kho: Add riscv support
Message-ID: <avBaAz0_ZvN-3m4D@kernel.org>
References: <20261106071459.2003-1-cp0613@linux.alibaba.com>
 <20261106071459.2003-4-cp0613@linux.alibaba.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261106071459.2003-4-cp0613@linux.alibaba.com>
X-Stat-Signature: m5hcbsorgx8wonpkki6ocxp6uh9c3gxc
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AE7F3C0002
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1794136587-705608
X-HE-Meta: U2FsdGVkX19AlLaLCPg4godnoGL2iBcg0JnozcwZJ+ftnSpbJA8Kyqs780/fpICQJcGB+ZMFdS01v9eWShjCG1usUM12rhIFF2ZfeRS6x4GE+kTe6HUMhYNlEWCn39hkYJv1BA1bDwyUG9gmNHuKBZ7LIqQPV1ck+n0cjx2vThUTBCsgH91kNyXlm2Q5TUo3+9fUfrkXvkTzNFNQI+tGzAuIrffwJZSjqCrSNZDVDFSsPoypfgeNkPfpbf4WDSmorteJcZ7dZ2JdrIXdsxzphpksSBlnb+gArTL/z60ney8EHcwg04mrKwXDjRQASU4sEe4XJs8tBrDAow6BpKDAK6bVo5Az/SiPn/ht4rh/iL/FhVNafNTO22Dda4g13kPExHBfVtBx1EKReol5IzGp1mYXCgbhRj2ERDvsnd4Q2HEX7jOv/ngIE1725DDYlBBEnA4sn5X0cTJfbIUDR2/HQLhKTTOo8LsYf7nXTyzQ5ovMdUMj1b2Aj9DyMsoHn92cWOSxptCP/iwtg+92knpskVpWcHCJFLMWQ2pDaIAzSWHGsTbVo7kjE/8QImZ7KeeNaoX5iHWZL6PVd8xTcHXSM5lejhmboDhvP9Pg+oCt2lRDIiOm7A059Kz1nPNLUeKnyW9c9h/2uxMVtehDhyp5yUPOsrwuSA7oI/WdTZwwzLPN96ebsgOMmBt/ebZPC/oXLD2NiByh6ArDKR6HB67nD+oEfAV325TCg3QvLPu1Ju+3ZK0MMovQcWGVcyPLdh39ocYpqJG9oXwdGclJWWO0kvk9/8g1OR6ZGkTXRyYKPGngT8Bsqjeu7Be3zV1XFnx2bdLJTQoZ0jsTYWHmI6cecV5YK+HqY7u1pxg05rnnRjYSOnkjx2L3vylneHIsk3Nj6kRAqHXwnncT5u4SXNWIBam3pESzaFWlGwlALTiB6w8Yl5sfWoyK6m/GA3/OBLICDjCuKV0dQq5taE6c5vK
 HIkH8rmx
 uiRaVnwfynPO1kbuRvHR5xQ9dHfQmITPAKIzF3cG8/umZdJi6QSiFLHqELcj8n1ofNxncj+jEXZzcCQ8lIUlMfaCMePnDFVnQxXM46MUBCa8xhignQVpFKBKKouuZqYQFho+xHtHzOcOqQoZJQO2hsNieCp8kw6KrQtLXu1Cy2l3fmKhMCp5zoOwo2yIIbD1JLyAUlHFAQmX9yMM9tAJIogSFTIQPeRuRUb1lyO+MK4XaX0f1dvUz8RGIcTUI43TOrnXEBUzKwvvv8mvt6sNE5YxNuJIscFBbx2Lkw0OyaJtJ+6E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 06, 2026 at 03:14:58PM +0800, Chen Pei wrote:
> Describe the machine the KHO vmtest runner needs to boot riscv64, so the
> test stops being skipped on this architecture.
> 
> Signed-off-by: Chen Pei <cp0613@linux.alibaba.com>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

>  tools/testing/selftests/kho/riscv.conf | 9 +++++++++
>  tools/testing/selftests/kho/vmtest.sh  | 3 ++-
>  2 files changed, 11 insertions(+), 1 deletion(-)
>  create mode 100644 tools/testing/selftests/kho/riscv.conf

-- 
Sincerely yours,
Mike.

