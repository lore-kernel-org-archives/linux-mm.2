Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1520F0182F
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 12:27:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65B7E6B0005; Fri,  6 Mar 2026 07:27:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 605A66B008A; Fri,  6 Mar 2026 07:27:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 532C26B008C; Fri,  6 Mar 2026 07:27:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 432C56B0005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 07:27:05 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E7EDBC1DE4
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 12:27:04 +0000 (UTC)
X-FDA: 84515562768.20.225F8F3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 429AD40003
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 12:27:03 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UqhzYvMQ;
	spf=pass (imf27.hostedemail.com: domain of will@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772800023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9V8eHScoIgr4hb4P9Tjc+JbZuDDA9jaPNPd2FXC+bNQ=;
	b=yQK1tVdl9nI9P6StLoiVZFwhvt91xyVu0vt9yEYl69QRi0rOHqiFK6FwsxtGT1GQP+Cmkf
	JxOoYOBO8vKPqhuYJZ+H6OGpt6YJTfFcGuAzdBw0nMy9InmPqawVFNdzcTEsXfz8YFOJsM
	WrcAjdxt6zefZQnxEn6XpttgZiW89ys=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UqhzYvMQ;
	spf=pass (imf27.hostedemail.com: domain of will@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772800023; a=rsa-sha256;
	cv=none;
	b=T3rV/L/m6jr4ukEHU9fPbtzRAM0NCyQizM/ru9CfaewrtFkscWKpL27sIS4ZMR7ofP2WmD
	JOtaBWDEvyJSDAizPK79hzsljJH7zpwEwPbPwmhUtiWS5lHZE3cdazYpspXprBhbPoI9o7
	YqKoMvnc5N63A/7QaRr1ejarnazI4hY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6981040A85;
	Fri,  6 Mar 2026 12:27:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAF5EC4CEF7;
	Fri,  6 Mar 2026 12:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772800022;
	bh=7Hk7fAZvQF0ye88ruxvV6p3f98XYs2WUnmaeYiPvIvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UqhzYvMQwShy+yX4ebcbqbL3BTg7VeWu+fXcy9+1csqA9F/dXEuQrIdJpJZu+7/L0
	 5TgSSRj+V3KcV7JHs2tslveU3OM/HEYLlNmh+4YUzsoBAh4S6ubp5FHWLY5EUcu9EQ
	 OkVIHTdTid6voTnxnBvJKAlGOAF3Ripzjnz7eDX//RBm/16v4Hna2W4f4iFMguIVUB
	 +9hIYILu+nbENLitc+lrZibMpnr/KTamNWDgb9h8+w/LtfkCWWYWjCazcILWVhZQlq
	 BXBIEmeXIrmRql3AlTl5ui/O85GYlhV2RXy+Jqajab5bro4mwmJz5963mPzfM8Nggo
	 OZZrrPC3nNl1w==
From: Will Deacon <will@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Piotr Jaroszynski <pjaroszynski@nvidia.com>
Cc: kernel-team@android.com,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	John Hubbard <jhubbard@nvidia.com>,
	Zi Yan <ziy@nvidia.com>,
	Breno Leitao <leitao@debian.org>,
	stable@vger.kernel.org,
	Alistair Popple <apopple@nvidia.com>,
	James Houghton <jthoughton@google.com>,
	Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH v2] arm64: contpte: fix set_access_flags() no-op check for SMMU/ATS faults
Date: Fri,  6 Mar 2026 12:26:52 +0000
Message-ID: <177279636044.453548.11482786576662988237.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260305-contpte-fault-loop-v2-1-0216f0026d7f@nvidia.com>
References: <20260305-contpte-fault-loop-v2-1-0216f0026d7f@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 429AD40003
X-Stat-Signature: hkexbaxgixxbnb8d9ycq9wbfqiug74nm
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772800023-204238
X-HE-Meta: U2FsdGVkX1/QLizOTLQpW6h/XysEX1vpX0oXPAOGn2UG0qfPRbHZthZk28tOVNwuG/cN1cvQLO0Upp7G5QFtrl9WEs9QtLywVtqMRxdpQNwJAvmnAOKkXj2NWRSgYrsXOZO0Z4NHEz2yf9kzekMRujnwen2qYbcoPkFWekpU2F5CZuzofXLipNvGXh3EgLF1U/YqT+BilkB39xNA5LsBuQucwxjMaJXt/vtKGdk/UUBfZgDDM9TPaSrIJesG85P7GsNODp8sc+81u8vdq0eJEqK26Pilt1nXY2KfzXKk5ooDuXdA7rRr9LwVFikH0anrTLBOlUSCdc+DcO1YKwP/5tCBNFRx8r30x/YpcuXT+WymJgpmBDvnQQ+wpiOBaBL6t/jdo6E6wnuSPJbNqf5fn29z9ypkF39fPfjrFfS4mLasT2kTG0p1iAahSvQUXce4uEabHYUEueHYdDp+6Wws2BkHAt40EH3djYc3WSqA1++ERcSGbLfajtxb6j9oQuOCzEoaL+Q04WCmxUGOycBbvjKzQt6I7q4WvNN7wZkwOjGPg2/HoWwPehw3+JyqIfpZViLZTUF+H8YIGlLNnt0ped/GULqWIoJ0iiWW6wFMDmdcU98B2Gc6FRF+LVi4X2ePhs/AZCgtqDeZi/SOc5kjvkQOmfC18vMBMolMuBLlkPw/2TNpjMnN1VTcQMMtO3g0FhPUe6Xl1MdGCIEYSwR9hO6yp8OOD7sAzoUVb/4YIqt3AGJoPSFPcXKDvVmsNfdRiKj2u0WQauodcV9w2fx/8yufFLWjGs/C5sXihYQXYJ2oIQGMVRoeU38ayuw3cPdDVDt0SKcy+26ykkaWHPrK0PsKHgRx+5D/cwOnnv71/1RQ/quMdwwdWJ7WPwkMMGIt6+suJNHfFGykgAoJqCgH5WQUei7GKO+WlJ8W3LifEct3m5RdaHMWkLcKp2jOm9xdKiuTzzuysXgJft/5BJB
 pMiMK9w0
 PqJQdA8Zl8ZoWabmiCo9Hdiuz/BR6izwLEXgsFzEvVqbQ49K7ce+YxL+zRPWWb2KjiJNIZboZEWs3mym68trCPZZAnEdKA5cIVbXTCgrpD/QMS27a9ZJvPAOSSd5XuCxw45EEQLRCpnZURdLMNNpGgAuqcuyOP/P8FmEEbom6ONJUXbsGEEG4Vyk+WcMly2PBr91tRAyPu6a6c2mAmmxo957KV7EWt2motpDzJqhVT23I20sNclmgOuqPQWXChrzz13NqH3kpQujvfK3OLqSUAGThoQVrL4OFZc9HbbPa++Etp4po4H/ma+mwkWNkjQLoyojTIO4ab5ivuaI1w9T5CZEM1XUBPHYOsjB4dChCr2uQ0fRoP9cfej9uBQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 05 Mar 2026 15:26:29 -0800, Piotr Jaroszynski wrote:
> contpte_ptep_set_access_flags() compared the gathered ptep_get() value
> against the requested entry to detect no-ops. ptep_get() ORs AF/dirty
> from all sub-PTEs in the CONT block, so a dirty sibling can make the
> target appear already-dirty. When the gathered value matches entry, the
> function returns 0 even though the target sub-PTE still has PTE_RDONLY
> set in hardware.
> 
> [...]

Applied to arm64 (for-next/fixes), thanks!

[1/1] arm64: contpte: fix set_access_flags() no-op check for SMMU/ATS faults
      https://git.kernel.org/arm64/c/97c5550b7631

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev

