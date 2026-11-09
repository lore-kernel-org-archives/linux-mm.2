Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0401606A321
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 00:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Fon+GDf3
Received: by kanga.kvack.org (Postfix)
	id AB28F6B05B1; Sun,  8 Nov 2026 19:59:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5C626B05B2; Sun,  8 Nov 2026 19:59:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 971FA6B05B3; Sun,  8 Nov 2026 19:59:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 775436B05B1
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 19:59:09 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 02BC6140568
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 00:59:08 +0000 (UTC)
X-FDA: 85413771618.02.379E72B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 65C0340004
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 00:59:07 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Fon+GDf3;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794185947;
	b=DmJcuUzuvZGhlwhZ1+4CpYOEIVfHJccMj86jJgqOjpQbzU27VeR+/89/iXyuIRvIdupiyD
	ZYXSaejWxl74zP9IVS5hqpP5S+xM2ygVCHdevDGjOo0jZXDW6QhBVpaU9f8JNP0vNqqe7a
	kCOkKDTQf0WBkakG5pToxmI0sYGcRzw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Fon+GDf3;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794185947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wRZ+9weq0Le6c9wBo/j3BdKIziIm6KkYIs1dhkLyUZo=;
	b=A0vdwL+AeEh7zskk9Czj4PeG3//yi9pY1INQB9qNSA/h1oXdK+zEyWlRhWFEZl7oBYuyiC
	DLJvRbedXfHwrN9dGbuo7ylDTdycieObEoe3XmT+fNVUg036xrwOeaWnachNuEzkhPeFzE
	fbX/n+q3PFjEMkAKNtaxMFIj1ffGuuQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CEF0742445;
	Mon,  9 Nov 2026 00:59:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CE461F0089F;
	Mon,  9 Nov 2026 00:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794185945;
	bh=wRZ+9weq0Le6c9wBo/j3BdKIziIm6KkYIs1dhkLyUZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fon+GDf3Ax2qr81devlq5g96iZoFlEWWROb1X6024cru6iLVLU9ExtJ0oE+/x4k1o
	 wRQ70J2DCoK2qDRKKW+2ZgCOf/Qw8IMO7V6XVNV16QvWMfVpsKHy/YPIUPO7ceh+hq
	 n11rSR4ThvGFL0b33BOanFcw2vpJ/TLxxcHVmi+mCGRGtjJYxMV/NM1jIia2YvVBz2
	 qbql4+xcbT9FeFeM5GqWLhI0kxSNtGnWDU+ggU9mQI9dfBlSpMBctTDctBHUOUoHuT
	 TNok8DbfWDASNeECp/4pf+eJWW8/7agvKP3OYINQPHeVbsJXPtTiwEUaApF7RpeJBX
	 wdr+fLrRkwwKw==
From: SJ Park <sj@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	Usama Arif <usamaarif642@gmail.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 6.18.y 3/5] mm/damon/sysfs-schemes: read sysfs_filter->sz_range only once
Date: Sun,  8 Nov 2026 16:58:57 -0800
Message-ID: <20261109005858.87582-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261109005106.77748-1-sj@kernel.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: eybiqk847yth9royitn54q5z8red6ae4
X-Rspamd-Queue-Id: 65C0340004
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794185947-710255
X-HE-Meta: U2FsdGVkX1/6JodhX08hckqh/dyrIeJbXNJv3m0uxBULg9rhyiC6ZWuNTsZKHhF/K/0dRkwkGtg3HLa9QidHFT+40vUTKnybL3eXeQw2lzhgDMj72iua2LYPvF9k1OjkZUWC9OUvaNDF8wkpqKX8SLVUov34iPucucc14ETff5SkpxvtU9+dJL6A2LRq9KrwBpuM4/Gq1D/4Zp72IXM1KFFEGl5d+ei3vDbhxmmKqQsmpGa06XGALj537tYZLXkAfS6vmLCsKDrqHhZ2eXyuHrdw65q8A6+WHFCd/7yECXYHA6cTVWBmMwT/R9mueKPyJ77jYNibpzhyqLu7DzthmsboXJnf/OEZCS7vxH1ku0UiLUI2qJT3krQNSU7cqu/ROPMqEadDfxhSBCyh6VBLBuO2PoI2wBV3M9VILdeKyC6CVcZT6wquaH3hDtUpnTkFxIlEfyKdtxO5R9CT/EXa6HpVN/cB12YnhLpo1dgxMmaC9xnAnoEDEanZ3FUFMWOVZGVufRngLf80aeRTGpckvhYYyMnAver3NR9HGDpm2UJjIRIPo4qczdJcir/c+hlGtWUOYak4VOKZw8gv0C8PgLjTpIRRiD2NIcPybmjVS7WIK0EptsHhREMHgZOccWa/vIOcaaPtGRHkD/xns/ZJuTXP3GSD1J+TnMMcAFOMoJdu/jTo3brZCmu0lScx976mDCjkpesnPjTakmQoMhwFvH3KmPsRgQQGmHaj+dSjxHG1F/Ip4wdlbHdVkRqHaV88Uy9QDXivviVGL8HZ5hiHRx+G5jGbPimnQ3ahSdHycfAF/7NXyoUYgy4fdLLOCQt+BxH0MmEuARPbky94Eb+zemvSArC8EcKVRl69gZgqTgN1qvaTvDk3E4dPsjANxXGRMeVxce0+z4p6XaT3PN/LVXdbGRZsmYChcPnvb1go1+yaCyFiL38sXOaHdzSpzhFGSpjCDK6jqGTf4g0NwLw
 +pcFXc6/
 JbWcN/4+7BGS18l54iwDzR8CSTMaTWncZu+Qz7b7SZYhu9dofd7dXigaapCJ2vbY5HvxGg7/X6n/mgVWIwsEnXYb5Z4ybeB+F4ekeBfrIbdhajxHMYYE4GoYjsAGUeAL9VWYR8B86IskDAl6gwiCtfrtPKQ5VO71F2/AnYiq9PDjMCukPW/lNS0zYGYY6KCKUL8nNPRpq70JhUt/g8XiMuPlBlYgdx6865zmODyxKpAkThavraDwhfIf6T52sN/YglLilUYjvOhSlKCqcCKu9Dilciw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, 08 Nov 2026 16:51:14 -0800 SJ Park <sj@kernel.org> wrote:

> On Sun,  8 Nov 2026 19:34:34 -0500 Sasha Levin <sashal@kernel.org> wrote:
> 
> > > DAMON sysfs interface reads the user-provided size range arguments for
> > > hugepage_size type DAMOS filter twice.
> > 
> > Patches 1, 2, 4 and 5 are queued for 6.18.
> > 
> > For this one, af19aff38d6f ("mm/damon/sysfs-schemes: read
> > sysfs_filter->sz_range only once") is also missing from 7.3 and doesn't
> > cherry-pick there. Could you send the 7.3.y port first? I'll take it for 6.18
> > once 7.3 has it.
> 
> Thank you, I will do.

I just posted it: https://lore.kernel.org/20261109005724.87550-1-sj@kernel.org


Thanks,
SJ

[...]

