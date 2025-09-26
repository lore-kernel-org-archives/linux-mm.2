Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10437CAC5AE
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 17:37:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64CC38E0003; Fri, 26 Sep 2025 13:37:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FD4E8E0001; Fri, 26 Sep 2025 13:37:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 512DA8E0003; Fri, 26 Sep 2025 13:37:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3C9548E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 13:37:18 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CD2C0C0701
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 17:37:17 +0000 (UTC)
X-FDA: 83932107714.22.882244C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4279C40007
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 17:37:16 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TH102F6o;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758908236;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eVASRafy5IRhgS7dpWbuydt1VpODBCiTk13uxR1IIdE=;
	b=iG2EG2gAd7xSR4ZC1bKuCb6BEeTgE3Kbl4h/Rez7WdBDLY1SzkTEJjeCP2345opWYPUq3y
	f2Y9Zxr+ElVwcqZsj1Y8MxE5y5uuLf0uIUXThVKaNd+SmtpgDuF2BN80BCozimFJOGH9jr
	g2qK6LKAGvORubAaHG0weBZM9G4OliM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758908236; a=rsa-sha256;
	cv=none;
	b=sAG7z8XS2WHRY39YnHwDZgEhr9CFvKNu8u2Ow/KqtYnODmQS/FpN5zsBpDNIczCW86WIqo
	DDEiZx9U7+27xTpqAyqG5atkB6EPpqQ2pB5qj81iK/+hzWoXzSZL51nN7VNHOzyDXEaVJU
	o5dixPgiFGPcck9kc56mAXLjyQ3ccB4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TH102F6o;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E6AAB4407A;
	Fri, 26 Sep 2025 17:37:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0A4DC4CEF4;
	Fri, 26 Sep 2025 17:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758908234;
	bh=ZIQTWbCZfR8FK3ub+elpIulA3vUSjsCf39jPCJHyQVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TH102F6oqAMPPmeCl7hONVN1DFJjSrbO+wD+LsFns14LvciCBESGX5ckHOI1bgxIs
	 0ErX1wonsGiKcr53AAQQcVN+BWxfIzcWNsc6N+161F8JPWbaE4wID26bls5hoe7Z8w
	 69R1mYo5eSck/oQoeSItuoq93FmsTdbWOU7AY/bLmMPM3DOPEF5p5zBbgFc3ddcEJF
	 H0TjCe1HzpEnmR3tE/NqvQJWYIiubHQPcL+/dZ6BoTKq8PcZCkB5fvvcdEo7dF628A
	 S9Z6ZwjgUKAT1mqB9qLg9TL6cVKMKNN00kDvyMaXKfUAepx3Cv4/nAWmJ0oc/g8eAc
	 puhVplwvfh8Jw==
From: SeongJae Park <sj@kernel.org>
To: Enze Li <lienze@kylinos.cn>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	enze.li@gmx.com
Subject: Re: [RFC PATCH 0/2] DAMON: add priority-based scheme application control
Date: Fri, 26 Sep 2025 10:37:12 -0700
Message-Id: <20250926173712.53778-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <87bjmxvqve.fsf@>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4279C40007
X-Stat-Signature: 4g6y54pof8j5dffheyxmamn9jjp7agtd
X-Rspam-User: 
X-HE-Tag: 1758908236-137897
X-HE-Meta: U2FsdGVkX18NuOyT9ph/7rgtLbV2PCq1O80WeAFgNgUeDBTLSQqkBbkMRYBSmCaOPK8/NcReJpMhAOXRQbuXZgeDXcG76x8+S8WD5Ry/fTd7R0z8UZpm2SVzL4vOqzj4441t8tcf87LC/oh6GBW9eEvTPgFhnMM+DM0Ir22iAv1TWXefTtvxsm4IYXXjTakLE2GxOu4IiWjsIXx0C+3tSBFJ8Fa1mTd6I8/ahBTgTJTzczq/sORejbzzbxyPxn299Myjo7fl7sTMWhI4qHjejT+nQhCD20BuS3yCYy2oEu2tq9Fy1PaVAS8SKEnw7BmpDfEPEdGLGgFSlT0n0sY8wRfDFxn75tujdBfapGEVTbhRC6HkLtkqAhc92r7l++HBHjaTqNuu7RkvoOS7t7Ou+qM9XY4dfbdaCWVzwzx2J4UOo/3ZMQVQ72X6CTF9Zu/OKnl2L6MP3tg0VVbwA7C0soREdQSAniFx1fRXJhLcfu7Kz4DNw4X68lISXNPZvBOWcVhcXDJKohVZ3KRktqmHkjCyUfy59POZOxL81L7RVBeHKz2TxtiryWyEU6VhhZWaSWoDPUYsi0vps28Tad0OpF5LmONlUEFVEUJq+Fa7TY0YUzmCdUdLuivHocjUvcFsw0Jn+2LNANegP52VfHmQptmMDK6hWYMtnP86UtBGs2OnLRhLZ7e1scPDtf1vbTM5+jxULaGv44JqKkO4tqki+0iknWno4lLcnF+Dax2P14AYey80AYEMhGGH99UBjWGBldcqqqKOSt9CgDpRbLvMpo/dXh8OCIo0I5DPbpF4Kd1XXfSzunrA2P0cJzw2cjpv/xBXJmhiJJAyVbZ4SlHkGzhP4L/qH956NkoSnPVwkG41blEwAt1hcqSIVu6hcQPmd/BxxrxFPJuu9o0rim20F9xwbhrdZS0rpoOJ2EAKPlROpin9JFZvAQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 26 Sep 2025 11:23:33 +0800 Enze Li <lienze@kylinos.cn> wrote:

> Hello SJ,
> 
> On Mon, Sep 22 2025 at 06:01:32 AM -0700, SeongJae Park wrote:
> 
> > Hello Enze,
> >
> > On Mon, 22 Sep 2025 18:10:20 +0800 Enze Li <lienze@kylinos.cn> wrote:
> >
> >> This patchset introduces a priority mechanism for DAMON's scheme
> >> application, allowing users to specify the relative importance of
> >> monitored processes.  The changes ensure that higher-priority targets
> >> receive more frequent memory management operations while maintaining
> >> fairness across all monitored processes.
> >
> > Thank you for this patchset.
> >
> > There are features for monitoring target-based DAMOS filtering
> > (DAMOS_FILTER_TYPE_TARGET) and per-scheme applying time interval
> > (apply_interval_us).  Couldn't those be used for your purpose?
> >
> 
> Sorry for the delay.  I've been testing it for the past few days.

No worry, take your time! :)

> 
> The combination of schemes and filters does indeed emulate a
> priority-like mechanism quite effectively.  This is a fantastic feature!
> It's exactly what I needed for managing my workload's priorities.

Thank you for letting me know it works for you!

[...]
> I've been wondering, though -- for users seeking a simpler interface,
> could we allow them to define a basic priority value and let the kernel
> handle the resource distribution automatically?  This would require the
> DAMON system to intelligently translate a user-defined priority value
> into appropriate internal operations based on current system resources.
> WDYT?

I agree the priority based interface could be better and easier to use than the
target filter + apply_interval combination, for some people.  That said, the
user interface for achieving the same goal already exists.  I think adding
another user interface here could be a duplicate that only increases maintenace
burden.  Particularly because we need to support every user interface of the
kernel for long term, the burden may be not that cheap.

And I think the kernel ABI is not necessarily the only single place that can be
modified to help users.  Users are recommended to use DAMON user-space tool
(damo) rather than directly using DAMON sysfs ABI.  So I think we could add
priority based interface as another wrapper of the target filter +
apply_interval combination, on DAMON user-space tool.


Thanks,
SJ

[...]

