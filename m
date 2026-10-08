Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5331CCA6007
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 03:07:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 224336B008A; Wed,  7 Oct 2026 23:07:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D6286B008C; Wed,  7 Oct 2026 23:07:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C3436B0092; Wed,  7 Oct 2026 23:07:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DBB996B008A
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 23:07:02 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7240740458
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 03:07:01 +0000 (UTC)
X-FDA: 85297972242.11.AFD7AD4
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf04.hostedemail.com (Postfix) with ESMTP id 40D3640004
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 03:06:59 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=MTvM4QRE;
	dmarc=pass (policy=none) header.from=alien8.de;
	spf=pass (imf04.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791428819;
	b=iim3S/ISYVsCqhLvjPRuXbi6zlwLzWOWwUZWKsWLZ9RRso4zlomwCC7NQT8VD7uW35iZTz
	kGrleyKgKxPSDvAmh85kEanZZDHNlcOQbJ0r7TJqIBGtNEnKQ/nvc0vWDiuXwZfgzNXVTi
	LrXcR4rdSOYbr+OY+u4u2mgoY6m2l+Q=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=MTvM4QRE;
	dmarc=pass (policy=none) header.from=alien8.de;
	spf=pass (imf04.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791428819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cyhM1nUNozz0bBiV0uhM/z9n5mfCAa1GSAZkjkT7ZwA=;
	b=C1z71uIm3nRUwYrFIwynnbReXW1QDk0MIicsidDbF4MyF9yfGGUnQ8tq+vpvpx1Gc38Khe
	SbNHrN3BEryJL3GEA6u+JCvq2VH2k0mREQ9Cqf0jMIju5UOXzDMDoZ/xK90i7AIn7fLLsT
	PzB3rFYWPiHUPAWnQb84G8hIWC/TSx0=
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id BE0B840E00E5;
	Thu,  8 Oct 2026 03:06:54 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id mgqvtUb_NHYt; Thu,  8 Oct 2026 03:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1791428804; bh=cyhM1nUNozz0bBiV0uhM/z9n5mfCAa1GSAZkjkT7ZwA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MTvM4QRENWPPyXa1ccOMqG0xWEftwSJsaexQPCdfxBkXP7aZz3Em5whU2pQk5U3et
	 G+uyGfmeEELkGkv+0ctFdA81yHntZDUoz4GPNiRNbGWn5VIaI7rw28qh8cX08XPtY0
	 m3V+1VmUS2w/Ua3WMxQzU38Kc6eCVUT1YCfM7qq+Uq2x45slABOTqqLuA+FNRdHTMg
	 gOfTMGMnSd+YlKNdxUoyIdYWOWwKGJOBMLiVSZAzhO3EZTFBHKOFduhuvZhHzIywWv
	 aK3/lZ3bo5qaaeSkaegusJbhR+Ij2ZdbsRvOEB5Exrbwlnt1WhZgmrWgGAgVDQg7Rh
	 p8LBRs2ECOzNSXNfJGtnTqEmy2XqWiUglM1iHXsNTo/T7LcVABevxKWAXggygRJUN8
	 WndUwCBiS7EvIW77HYvqxGuTi1tPhLBGCuBkVCDzEskMRaviNtXGckj9unOsth17KZ
	 DsjhwknwklTzWaCtfOR9k1uvCQgcJ/QuBCfEsSDJGuycQ2GeLCPG+31za9DrnM3r9Y
	 9OI5AdS0SYsRO1sUZnE6vX3sk2Q/a9iu2TtHC/326UTNyOvlUSoHNclJf0WEkMcfYp
	 uQtJUSOhCCCJIlpg8tKX4tYXYfBgAxG8kVbecegnZmJI+es8vUz6myXMDT3AgzcbqQ
	 JVbpZWFtomeYaCZJInqDT6xs=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::3a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id C1C9940E021A;
	Thu,  8 Oct 2026 03:06:06 +0000 (UTC)
Date: Wed, 7 Oct 2026 20:06:03 -0700
From: Borislav Petkov <bp@alien8.de>
To: Ashok Raj <ashok.raj@oss.qualcomm.com>
Cc: shijujose2008@gmail.com, rafael@kernel.org, akpm@linux-foundation.org,
	rppt@kernel.org, dferguson@amperecomputing.com,
	linux-edac@vger.kernel.org, linux-acpi@vger.kernel.org,
	linux-mm@kvack.org, linux-doc@vger.kernel.org, tony.luck@intel.com,
	lenb@kernel.org, Yazen.Ghannam@amd.com, mchehab@kernel.org,
	jic23@kernel.org, linuxarm@huawei.com, rientjes@google.com,
	jiaqiyan@google.com, Jon.Grimm@amd.com, dave.hansen@linux.intel.com,
	naoya.horiguchi@nec.com, james.morse@arm.com, jthoughton@google.com,
	somasundaram.a@hpe.com, erdemaktas@google.com, pgonda@google.com,
	duenwen@google.com, gthelen@google.com,
	wschwartz@amperecomputing.com, wbs@os.amperecomputing.com,
	nifan.cxl@gmail.com, tanxiaofei@huawei.com,
	prime.zeng@hisilicon.com, roberto.sassu@huawei.com,
	kangkang.shen@futurewei.com, wanghuiqiang@huawei.com,
	ashoraj@qti.qualcomm.com
Subject: Re: [PATCH v23 1/2] ACPI:RAS2: Add driver for the ACPI RAS2 feature
 table
Message-ID: <20261008030603.GAascImzt4cv8Gz49p@fat_crate.local>
References: <20260726212812.89266-1-shijujose2008@gmail.com>
 <20260726212812.89266-2-shijujose2008@gmail.com>
 <20261005235021.GBasQ3vXTivT3NLbBq@fat_crate.local>
 <asU7svV8g2Hb5DZl@hu-ashoraj-lv.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <asU7svV8g2Hb5DZl@hu-ashoraj-lv.qualcomm.com>
X-Stat-Signature: ade5tmooh3h1f7e67zyg3bky8dhxxyny
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 40D3640004
X-HE-Tag: 1791428819-234511
X-HE-Meta: U2FsdGVkX1/4AgEZQLcK9PrizaW0KBxoZwHrxjm8lQmFxpdOTxyNI7L4khywpwIqfwo/FJeep6j1cASU3PFB8r5lA9GG2nYGN1Mw8DVIo9xHLL7DEFShmQ+BmZM2Zaah53yog+Vm2JVL1d/0Lw2FqocDjAdWwfSNRmgxbXaiXMkWrDJtnsqsXu/Pl9BsNLjNo2q4c0K22qm3fss+X8nDVUms28vmxFmmC1CxITb3U1/Bg9zOCnN2lozBPqnwWUbzpYrjPWbwCvz+NuNZmNATFKu2s77gtpGfHm9PHPzlEVowwX08Ajjzi1Cu8brcdV/BrU04QsEtez5FGQms1MXphuza9RN4so5H0dlaMmcgfCuFwfP80Mh2PwXPIYEKQ7u9Ftj6maPl6TZCN6+W6SxIBrAGf3PrZFfqso0s703E0QL/Z3REHWIZrUAWnC27CW8R2W/Qwb07YNUBSwUlC+6VRUjiY+uxxTJib3pJAT6IafRXRoSH7iSQFf9r6ZmXYvbbjmhILrjXeHds96aYGD3yEy+ubwYgbZ2V82N2a7Nm/YsKD0NIxO+jkwwOvoswwYy1L8O6OlZ6gkY+2XlpYaqqJafipSP+/Cn9kLHdELxEIoCwwizj7YBNRIfRnz0vAqeELfVbA+eUyrfezm/PVTI+sVhIcHPmUQ+qUErBhoWpYWX+9kKPlTprkMqToJt8GmPtBvgFPWlhRtnaJLGGGNaVigNSMwwJr+sVk/E1Wf27PtO6FNDa7Ou6qNwRHE/89MFMfP8AVpB8ms0FqbnozhixaxAIr5FZ6V66bG+BgRKoD/RJgc3FV7VbETFsxlEJvZKsBSBnir1PKiwFbBe171uyBy1ualzt6nuKXCH+pnaoFu489/guH7GWZI6LJY1Wx+DKFSm4kZIJalXHFMvneq77UK+uzlrx0fjKHMVE+m7yOxKoMJAnkaFvGBhvyQ521YTC+ti3rA4NYuPelpgSfTw
 Y/yWPEwe
 nsn80BB3JNVtr1ZbxbiuKJIF5IftenkfOTh/rBR1O249kp8+JPc5f9MzL1u5DMw6lrZGfEBnZS7ffWvCb1HtbbMi9LxgEuhghkEKfIw8pQu8xzOAiKRyScGz17mWQh8i/PXtPjskMl1MB8qkjXojmjCKS/6qgBNQoRc9Z7bg37/9RMhOg+pbnjFSxiTQ6LRiQAl3+VJTtYGAOo3HrXONbDJVU3eneS4Pqt025tdmL6XbE7vJA5Rlx3ras5Wx6M07t1TEwLV5feBpS3bogdN+qvLcjhEm5EemoRBhjxs9or0zRuTGRU29FlDKoSbo0rJ9O0UiaHkeEW2/+Ie1w1mD45VdDGF+VUlxEQu1KjYQ50rT+JU/dmX/xSlNYvg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 06, 2026 at 11:19:30AM -0700, Ashok Raj wrote:
> > +static int register_pcc_channel(struct ras2_mem_ctx *ras2_ctx, int pcc_id)
> > +{
> > +	struct pcc_mbox_chan *pcc_chan;
> > +	struct ras2_sspcc *sspcc;
> > +	int ret;
> > +
> > +	if (pcc_id < 0)
> > +		return -EINVAL;
> > +
> > +	sspcc = sspcc_get(pcc_id);
> > +	if (sspcc) {
> > +		ras2_ctx->sspcc	    = sspcc;
> > +		ras2_ctx->comm_addr = sspcc->comm_addr;
> > +		ras2_ctx->dev	    = sspcc->pcc_chan->mchan->mbox->dev;
> > +		ras2_ctx->pcc_lock  = &sspcc->pcc_lock;
> > +
> > +		return 0;
> > +	}
> > +
> > +	sspcc = kzalloc(sizeof(*sspcc), GFP_KERNEL);
> > +	if (!sspcc)
> > +		return -ENOMEM;
> > +
> 	__mbox_bind_client() reads knows_txdone at bind time to promote the
> 	channel off MBOX_TXDONE_BY_POLL. It must be set before requesting the
> 	channel, otherwise the channel stays on polling and mbox_client_txdone()
> 	later hits the mailbox core's "Client can't run the TX ticker" guard.
> 
> 	sspcc->mbox_client.knows_txdone = true;

Yah, I can see that happening but I don't have the hw to even poke at this.

Shiju, what's up?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

