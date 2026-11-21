Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1267D606A320
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 21:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.a=rsa-sha256 header.s=alien8 header.b=X/vAMYqO
Received: by kanga.kvack.org (Postfix)
	id D547C6B05E0; Sat, 21 Nov 2026 16:08:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2BFC6B05E1; Sat, 21 Nov 2026 16:08:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C68DF6B05E2; Sat, 21 Nov 2026 16:08:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9AAAE6B05E0
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 16:08:38 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DD9CC1205C4
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 21:08:37 +0000 (UTC)
X-FDA: 85460365074.22.874EADB
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf18.hostedemail.com (Postfix) with ESMTP id C42971C0003
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 21:08:35 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b="X/vAMYqO";
	dmarc=pass (policy=none) header.from=alien8.de;
	spf=pass (imf18.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795295316;
	b=XJYfbBIWtDAWfA4Ha2F7xINBDMPkLozqmIu7AzHRZ+yfYbmfUCuUKXiQiJCoE63I3lsqlZ
	RnBE0wNOOYRz5lktk5F+CIpNSJAzIstJ/U2Ph+dzQPijIMLLCNoCVwflrhsniq7XHIW9Y/
	2y8rnh+DY4u3ai/XdpO4tlsJS0glaxA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795295316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1pLbQi7zza7AIs4/iHTKdLl5NrGmgjuIa2VnMpqoqqg=;
	b=gVxW2ZbMtJojCOlnIZrHWqDeRELzXBC/oKNwFvutTK17bs1RSmIztVQZO1USsfKnzaB+03
	VSWL7FWM3KeXjayAAORlXz+qGNHgHbqxEzahsQO0utsO5MpFCsyk0Xz2pGs0LbF63SR1nP
	jF5zVBamNuSyv0ezwMCizcbh0kW1xWk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b="X/vAMYqO";
	dmarc=pass (policy=none) header.from=alien8.de;
	spf=pass (imf18.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id DA9B540E0218;
	Sat, 21 Nov 2026 21:08:32 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id l4Kpp3JLw_RS; Sat, 21 Nov 2026 21:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1795295309; bh=1pLbQi7zza7AIs4/iHTKdLl5NrGmgjuIa2VnMpqoqqg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=X/vAMYqOh6mySiHk2jEHVxmT8rSRUa8Bwf39VzJ7oToVx0S5brhq/pPhAjYrJprRk
	 B1rungD4KUVnC3FPuQty6szTKA/fIoy/1LjXG6Bb6qJ44g5DMR9jn8VnftEkrSjiwv
	 /KwtlLU8iQ71/N6OusphVOpuHaumpNf9qZEcaCwRslpHlp7mHoHU3DeIySb8YiAkb9
	 vhNKUBZC4KOWMzYduUcj9OAWUQwgKfbC/cXENJHIAJyLbEEG4HgadZxrEhjdTuSrFL
	 loTRW/WJgXmjpmGK7nBVDM2pyEpF6YaJCqUspiGh6yx5dECYP5gMPUwmGndTZQFyw5
	 jG5dW2mptuc0YLgnr/addjUO81eh+8Z5W6pzPpWMVn/nCp2qQpJYLORj/OjjeLsOM5
	 N4mPYH4FsyXRJGxJwfMGqwyGGUBgl9SgQZN5hNXENMx0iyC4by5aB0WxlWRrjJXb8/
	 GX+OGm/B9HHxsZGW1Z/yfnpCMEtsWcGGHw8e2VHWwO4D1s9zkHXyZYy0yHG9AjrthN
	 8GHJp8Jqr7U8zvADh2CT1O8izIRYSV5L8/LshBkkTxtHe3FEm5SKcm1RN53niCK4H9
	 a1Id0DVzMX+udzhbSmxBA4/HmfZkd4oCF95hwb6oRlz7rS+yd+7PT/8rC1GmkdXjFQ
	 PBs5QPHeJRs17yhYrnxXbpiQ=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::2b])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id C0F1140E00DC;
	Sat, 21 Nov 2026 21:07:52 +0000 (UTC)
Date: Sat, 21 Nov 2026 13:07:49 -0800
From: Borislav Petkov <bp@alien8.de>
To: Shiju Jose <shijujose2008@gmail.com>
Cc: rafael@kernel.org, akpm@linux-foundation.org, rppt@kernel.org,
	dferguson@amperecomputing.com, linux-edac@vger.kernel.org,
	linux-acpi@vger.kernel.org, linux-mm@kvack.org,
	linux-doc@vger.kernel.org, tony.luck@intel.com, lenb@kernel.org,
	Yazen.Ghannam@amd.com, mchehab@kernel.org,
	ashok.raj@oss.qualcomm.com, jic23@kernel.org, linuxarm@huawei.com,
	rientjes@google.com, jiaqiyan@google.com, Jon.Grimm@amd.com,
	dave.hansen@linux.intel.com, naoya.horiguchi@nec.com,
	james.morse@arm.com, jthoughton@google.com, somasundaram.a@hpe.com,
	erdemaktas@google.com, pgonda@google.com, duenwen@google.com,
	gthelen@google.com, wschwartz@amperecomputing.com,
	wbs@os.amperecomputing.com, nifan.cxl@gmail.com,
	tanxiaofei@huawei.com, prime.zeng@hisilicon.com,
	roberto.sassu@huawei.com, kangkang.shen@futurewei.com,
	wanghuiqiang@huawei.com
Subject: Re: [PATCH v23 2/2] ras: mem: Add ACPI RAS2 memory driver
Message-ID: <20261121210749.GCawIIJcidCeWs3ij9@fat_crate.local>
References: <20260726212812.89266-1-shijujose2008@gmail.com>
 <20260726212812.89266-3-shijujose2008@gmail.com>
 <20261017055852.GBatMOnEl66YObvU5k@fat_crate.local>
 <CAG4KcR+NOKHNzg6FN-oLLHgUxeitZHKXg9cN7dz24+Ap=RrwSA@mail.gmail.com>
 <20261110071729.GIavLFCfLKzPx8R0i0@fat_crate.local>
 <CAG4KcR+ikfQEBjCZiNJ1CUz=u3Gtbk_XDroA_GQqYpgO4Lo5Qw@mail.gmail.com>
 <20261121194030.GBawHzrrCNCMpfr7Gx@fat_crate.local>
 <CAG4KcRKhE1UXwrhscUdSpDJS8R0t7kWp8RXZm8j_9yXYJSQ2KQ@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAG4KcRKhE1UXwrhscUdSpDJS8R0t7kWp8RXZm8j_9yXYJSQ2KQ@mail.gmail.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C42971C0003
X-Stat-Signature: 6okttoy8yrjeut5xne4c8ubjdp9kzprm
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795295315-809414
X-HE-Meta: U2FsdGVkX18fFgU1Y7zkeDTOorcWPGyUxZNsBQWo0d3oEOb07ZZNpkTXw+ElLsvGBQtwaaaFDbEre6XTAxLkTtP2L4VcEdbYbbHCD1CqAwjfuBD1BNTWKueWReTowO7f+DHkKndRdIcjFoEYajxEwMZkarv4y6BTDPsVkZ2umSdbIIdi4FfAjLNK7oUnTc3lukIfZ2YDh+iRDqAYU3cHw8O3Fh2Crp2w8hweuf4sxD33m0cuneedoboMA2cVuek/c4EQoQmiyJjtf9cQNICyvNVuh/VUtCYfBLfxoMxxcZHbGTh+y5saxfQcoXwDL7igsX5nsKMu/6xSdex7vsmQe96ws0Z24rl5vC4OmxsE9isVpsRreYAxYyyfrFkH+px+cTvIS29XZ6sqRJknUfeV40BUYwsBPRjKkm2inQSdnw1fimLmajYj+Rb8YiEF460kOgQ1k5jeX8pMxi1xiBVrfmRlNNoD5Dko4mhHlSSeSzGWsCv3estNBcUTXV/fi1+1uNnjp1VouNkf5FjeNQUkedcqzVeyVBbxG2AKxjWoFOr21r903QM6Mr8dI3DV4wXIz6YBd5mgUah3UnsLhcd7fQ3RKWRaDFPJZaMaCLc8FAqXV9oUDmRZMRghPVNHpLWH4I98VIIEUXltABZPBLfZimMaJmEI/7pjIqQ+NaABzc8eWKUb0hwJa3Gz/umC0IytFe/asZbl0Jj9YM0B3Np0882c62G9OiU9zdlPQ59abxNQBtbb7uZxhz3TdLUPons27Li59qJZAUQR1mh81TmTsFiL5tfkJAyV5LPAhsP8NV2OF4yLNNs7iOoN5TqCSHytRtVjdvt+eurtKBXhDAo3Me/nkfxohrM7SaCk8ndsjn2i1NxEkJoN1JwDrB6dWxHYHOtJw1Pfmr4a6QcuOVPl16ETpUBj2oVuAuv7u8/O7g/6qzRxwpOboEETEVqact3/YNMIdxqq3i15Uf/9Yp0
 Rs2PUC43
 GhiAhoH7wLqIJRDjp7xX06/IEoqhAGGhdmWW2Kw0ElLDCNZ19n2ur2o7e50vzit4zdCy4sQy6BSf8hzhu7l4EXaF1KXFJOqOyZyLDsyEk7bFoedpyhA+pQuiVexxaF0MFXuQYBE5lbmmSZxUOVI9dExyXBsq+VaDIhrnEI9hYMImOgOievk8zWXfx0p4L1CNCy/strDZVE2F2OtZG86DJtJS7k0r+tCAw6MyqZ5Ib7tKUUQa+tl3lS3qyn8gCdn3nrmpUoi3cdmxInigA1XU96zGSbEJmbs49/wBua0fKhyMD7c99aegLkgefSvd5RxetSk43THfM9/qXuNNdZ+39Q9YjvD7LMRwGkNDUzqEhnRQhbwG/j0IFTlIHitHorraFoESS9XsWJdx2w5dwRrb2ICxSR3BBlTSYDITgf8gB/D3+ntgtcdvuOJNCHteh/rDkUKvpl6imz62F8JqC/5yzinwyvGYn2pRF/dK1+yUzCjxh8jPlJxj/8P//r/yWJH9v+vLOtwhjhlvrMJE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 21, 2026 at 07:53:54PM +0000, Shiju Jose wrote:
> Please find the attached patch with the changes.

Thanks, you missed a spot. I fixed it up:

diff --git a/drivers/ras/ras2_mem.c b/drivers/ras/ras2_mem.c
index 70f7f0b497ed..de5555d2e1b8 100644
--- a/drivers/ras/ras2_mem.c
+++ b/drivers/ras/ras2_mem.c
@@ -117,10 +117,10 @@ static int ras2_get_demand_scrub_running(struct ras2_mem_ctx *ras2_ctx, bool *ru
 		return 0;
 	}
 
-	iowrite8(RAS2_SUPPORT_HW_PARTOL_SCRUB, &ps_sm->common.set_caps[0]);
-	iowrite16(RAS2_GET_PATROL_PARAMETERS, &ps_sm->params.command);
-	iowrite64(ras2_ctx->mem_base, &ps_sm->params.req_addr_range[0]);
-	iowrite64(ras2_ctx->mem_size, &ps_sm->params.req_addr_range[1]);
+	writeb(RAS2_SUPPORT_HW_PARTOL_SCRUB, &ps_sm->common.set_caps[0]);
+	writew(RAS2_GET_PATROL_PARAMETERS, &ps_sm->params.command);
+	writeq(ras2_ctx->mem_base, &ps_sm->params.req_addr_range[0]);
+	writeq(ras2_ctx->mem_size, &ps_sm->params.req_addr_range[1]);
 
 	ret = ras2_send_pcc_cmd(ras2_ctx, PCC_CMD_EXEC_RAS2);
 	if (ret) {

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

