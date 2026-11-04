Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AE12606A328
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 13:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mIrbZaDl
Received: by kanga.kvack.org (Postfix)
	id 93FE06B05B6; Wed,  4 Nov 2026 08:40:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F1E16B05B7; Wed,  4 Nov 2026 08:40:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8074C6B05B8; Wed,  4 Nov 2026 08:40:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5D6066B05B6
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 08:40:51 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EF68B1206CB
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:40:50 +0000 (UTC)
X-FDA: 85397547060.06.AE92E5A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 56D49180005
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:40:49 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mIrbZaDl;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793799649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EZAUQMhN3rMe7FCapRNk/7rrtwkPUHUoi09OPENdnHg=;
	b=y6AKyagRfh4fu0E/uoi5y5aBzkjZsWFhJNbOa3K0WPrNHp98Yk5gkfELjApnLLnGeTEuSB
	knQjGe2LRF+XQxumSfp/fC7K9lLtY+5GzwUNyyMmqzjkvnhLSodT3cMoFW6g9E3nJR8nCv
	NJd7YiaPK6Y2m6ADjWoGH/uuORtEm6Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793799649;
	b=frzX0shXu+C2Rcwasb6im+5RaLAwi1xG5WirYeTdP0O6s2G5HfOgjFBkG3FyVsxwLxAaCx
	zD4ZnuNuaoqzgq2V3eMXeMNYMo0vArpJ8muKP25qTh+ssUGV724tYARUih6J1JW9n4OBgf
	dlJ3oY0X57KwQX+KjY9TC+hhHaEZt04=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mIrbZaDl;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 87C9F41A33;
	Wed,  4 Nov 2026 13:40:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 263761F000C1;
	Wed,  4 Nov 2026 13:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793799648;
	bh=EZAUQMhN3rMe7FCapRNk/7rrtwkPUHUoi09OPENdnHg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mIrbZaDlsoXr337Dd1aQvpZtyvWkUbui9aNsdGO39rnOez9/LC9vHEkL6oLEMmOjM
	 5ZS/EHVquAEEDjPxCrKhN3kshP7TS3JrO7w5Z0n0AQEv2MP6imfd5lntHJRp9EEZzU
	 AO1b/xidJ4xZJiAUB8EK5i2yqdQFoIbjV2rlSzG1AWl8xYdHcII+CrKkb2amyd2Tgn
	 siqgy24+C2iDDSdGuvES7WbPh2sAvX4J3wa6ToVDiYzL70KuyKjQ1uvZiShbArseLU
	 OZvXeGJ81KpgtvCcDjm84M+yrDFCeHPphdgMb/Wl3mb7UkVZo1aN5xTbwtXqV3KT5q
	 Uk3jtazUmpszg==
Date: Wed, 4 Nov 2026 15:40:42 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
	David Matlack <dmatlack@google.com>
Cc: kexec@lists.infradead.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-pci@vger.kernel.org
Subject: Re: [PATCH v10 00/13] PCI: liveupdate: PCI core support for Live
 Update
Message-ID: <aus12iOdLyiIiywZ@kernel.org>
References: <20261013162529.1928093-1-dmatlack@google.com>
 <179373348545.623992.16522569527665218421.b4-ty@b4>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179373348545.623992.16522569527665218421.b4-ty@b4>
X-Rspamd-Server: rspam06
X-Stat-Signature: bxab9ofuwcobqzj3u4uw16mmdu94myki
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 56D49180005
X-Rspam-User: 
X-HE-Tag: 1793799649-747721
X-HE-Meta: U2FsdGVkX1/wLej/0mlNygOHlBsVQPa87tlMS9cmk7uLlRzasNJXYW8wODw6QqHkt5uR5/KTs8pwGzuLqj73xoT2EHQm7xIHcv88NC6xHNyT2G/myHZ0/cRaBgmiv+ko0q6/C6KLkNLjesK4NpozorD4GPISyCnKGDs0O25ZqqG4Nx0wypb4Dzw/ayTCt/j3jnCHEnN/9fPkAuQzddVk4YA0zyesz5thIqYMxn9+grEnp+r2hbq7tM/FBiqSRPin09d/GaCl9wzTD+pr6EiVvQiE0OJNn0IUI/7p/3D/zMtKuYXoqvNxwOuq8o6/50cR0bRiZLLDSeq/5UzF0CNbg5eOFS0vBDXp1KAFkSzuuNZJAn2Fjcfwcg2yh/VxwxcQCOa0UKUl6o0gyUhX8ZvXvAZpGxLaZjMskv9ALFQaDE6Oq/+stN/TUs2cFIQRCd8M/eZROsqg1uVrmXI+NcmpSuSg9EzDypcTjAoSjgidyj3plfDUySxCvefmXKeb/I9YeG2mIT7E7stmhUmvgbpRVyq6krbMP1mOw83VqyuLd/xSLHuRAmktvhzH4cPE1H78QzTrSvV74w968jQ5fO4MZ6LL4Bhxq4K/iyhtBFHoG1JYwjEwXkozVOaeo3JOeHDoVuaMp366DeZulDL4qGbTor/14R8WsTK/q+LXXN1xG76P1vrzwn5XJo69JXu1BLW2/EsRP0rkPEzYkF/Ii5k3kzFSDMSo5uAPWekB6u8TldGXgkss844DDeOi1EhE31iBd590WhH3jHiiheY/xiFgkf5qzOUca2hbr7a7eYusG98K6C0O70qMPggTO13CwphEkbjkvJzRYVVyC0qgjkFnomFw1PORW1yP73rzdScUJBr2LNoG7GhCf2RIDKCPmCCZRfTshzHNDSRxyulZNIZQqyh85FoeIIoSGNQzq0vpBQ5lGzC1ojhki2YKAflP9rdkDu8u2H/WuEn6/0LqgnA
 O9yepKLi
 Xcn7Bp7PJUmZL9VwoTU90jAHdgO5KBEwpzlguLznq7vx9yr2t0PwzpoWrb1ILKxnKmXLreHNySgrj6A2a17yGBumnRpKElD5wGP2NCgh6EvuE8TgX8DAm50RPnIDeWhQTMinZCmVyk4vUn72g3pF4IAoIjlH34TIbkJcbOOmg7gJHL9pmqIR6XeuVYAPBSmYLN5waa0obHr3/dJ0CntVvYbCvg9mbPOBm/M/LG9wx1DUNpdtwCOz2gbTbkizXPQ+pgcr6/8lr08LHbPzw96sdawwQw7L/decNo4QW4lPLmvdXKxw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 03, 2026 at 02:21:10PM -0500, Pasha Tatashin wrote:
> On Tue, 13 Oct 2026 16:25:16 +0000, David Matlack wrote:
> > This series can be found on GitHub:
> > 
> >   https://github.com/dmatlack/linux/tree/liveupdate/pci/base/v10
> > 
> > This series introduces support in the PCI core for Live Update, enabling
> > drivers to preserve PCI devices across a kexec-based kernel update
> > without interrupting the device. This functionality is critical for
> > minimizing downtime in environments where PCI devices (e.g., those
> > assigned to VMs via VFIO) must continue operating or maintain state
> > across a host kernel upgrade.
> > 
> > [...]
> 
> Applied, thanks!
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git/log/?h=lu-pci-preservation
 
And luckily we have a few weeks chase Bjorn and Alex for Acks ;-)
 
> Best regards,
> -- 
> Pasha
> 

-- 
Sincerely yours,
Mike.

