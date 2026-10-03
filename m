Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 184D0CA5FEC
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 16:24:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B44AC6B008A; Sat,  3 Oct 2026 12:24:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF5936B008C; Sat,  3 Oct 2026 12:24:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0B2B6B0092; Sat,  3 Oct 2026 12:24:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 871566B008A
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 12:24:02 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 06D64A0965
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 16:24:02 +0000 (UTC)
X-FDA: 85281836724.28.214D612
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 64394C0007
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 16:24:00 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Q3By/iIl";
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791044640;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fCyj+yKFZ/zNUv75m/5gM/WMYwo4kn0fmfxbz9QYRxs=;
	b=WasCseBDHTAmKkH4ZyYK/DmKfXUQJW+PUt3hTvLKLF1iKT/qPb6h3RaLizocZKfln7O2uT
	/FgrskTVtCjRlNFHBdPe4iY8uDpJ7mVPhWkBRJqvIqxTuM20rELVbbezCaM/peAoMRSWUw
	kM8dJffB4Ff7V0szHeJ5Cs5LqrLHA9k=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Q3By/iIl";
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791044640;
	b=egCAJJ2LRvG8TQs3HGIW2OitcN4rklkTnjRhepsDyrvcxPYE8Lwv7HeSaofeKCwvhQj8QW
	IMJ7Gg+J0z9vOW6Q0oSbZGimw+Ak3XgFoycpXVKZ/ve4l7UShpWGE4YUqrrxAGeqam9Kax
	ucQ+cRxxuc2j93Pa101qk/1+olUcEUs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 628F641376;
	Sat,  3 Oct 2026 16:23:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 397251F0089B;
	Sat,  3 Oct 2026 16:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791044639;
	bh=fCyj+yKFZ/zNUv75m/5gM/WMYwo4kn0fmfxbz9QYRxs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Q3By/iIl+wAWB6NlC2hxCvyxm5XSUpTLsrE928c+38kDsIt973GEHRqGftSTW6Ddr
	 e7likP9QdpMWzP3a32sP5Ys9S3pTBCLNaE+uPpPM2M/6oy1/1YHSxqMCW77Ss38jU+
	 QqcSttsQE2TakfDeLZ75mcLnKYKfftys7qdNcKRJF9dO30fcfrbED40zQsKGOcM+hY
	 SL9embAUhiKsPdhiut0AvYCKRP5c+mTIDkQ4VtrRbvps888kVvHlZMwEiDgqGEYTPR
	 w+WppNHEK6Cps6GnRukkoPzlaewW6VQXMq9QBiBmb1Hcggc7ChDnHnKXjp5XYg3zHM
	 J0gGzixokOomg==
Date: Sat, 3 Oct 2026 17:23:53 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Sasha Levin <sashal@kernel.org>
Cc: rppt@kernel.org, peterz@infradead.org, akpm@linux-foundation.org, 
	david@kernel.org, mingo@redhat.com, acme@kernel.org, namhyung@kernel.org, 
	linux-mm@kvack.org, linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org, 
	regressions@lists.linux.dev, stable@vger.kernel.org, 4ncienth@gmail.com, 
	alexander.motin@truenas.com, caleb.stjohn@truenas.com, ameer.hamza@truenas.com
Subject: Re: [REGRESSION] secretmem: SIGBUS on memfd_secret() pages while
 perf record runs
Message-ID: <asEra6tBau-hiutj@gremlin>
References: <20261002175651.811343-1-ameer.hamza@truenas.com>
 <2026-10-02-rc-reply-0003-re-secretmem-sigbus-perf@kernel.org>
 <asDF77csaLDIuHTB@gremlin>
 <asERcvLuNJatsBL7@laps>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <asERcvLuNJatsBL7@laps>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 64394C0007
X-Rspam-User: 
X-Stat-Signature: 9rdpi4gqnfy85q3h6k41biq5j3idqptw
X-HE-Tag: 1791044640-838411
X-HE-Meta: U2FsdGVkX1+93JSdtZ5MCC6GZ3GhqUoUcPj8yMlGW+XH4KOEJgfsERvZNDvJFEobrBMp3X7t8A/4bXAn/5qegrXL/ffX3LOhHkTixjLyVIODlrJ55Qw26IzyOLk7JJa/IlnVIotG3NQAw4BRnLvqnREcxJi6PgOM6qxi5dvZ89heuDcsTEkXddq+UORYJNvEFlEl49TAaSkmZ6eFC+5i86yOK2+IxPp57nKjckoMPnE/nli5Fvjh3DTkSR3mGnd9yaqH7yW7uuB4txEfBi2TnHTxyOM/xMJcGgenZVPWHOjQEi6uuiNC69hDExH1Kwfv8V99Ib+YVL2azSPJv3R401xxKeq3WVAGClQ9LMxhEGWPCDXBh/hzHJgFmp0sxQ7wGP/i1CijQVm7sUpBGaSDU8mpogINLofl9s0C5oxqwRkYjzgf80LRzq9IgGgsIEYlNzRY3ysnU1fMBAQbUKMtbHpz1/1zrNE+VEIgcOaTjYlC6cnLeUmexlTUSnayatXwFz78l3cKDPVrRV0fqf0JF6zFaq9LSCMwhGtr+1NShzm5rAv7V+oIRFXxTzGYeimWuJVrXCRdYQe00tKnP4lJWfM3OWctoW9KnZoTEtVuGQEhdiFTn04tld/hWMmn2LHTq7Ha5FeAL8rMRsab9oBaUBJOg+O3C9THq9A4JPOgojn63X9jofcWQpARIgB6ipo7hZpg8R99JIQl+ZV13KwwYVs2Pf/9AvVy5zyUcyuaZgKRfLUQNXcIQzD8ZCQQKpU8dtRc0A/TV/ghxhmi2+EBatP8BPaKMdKT/JfW3g/gA1AmV9Q9iR0K7uEMd68/7/U2yjVcQPhkxpyr/5DkS3OKmOcy9AitB/jIagAgF3r51jTI7vW3nSKIrcPZ9BZsmvpLuepFNkaEPZMMg55IfcXJG3BMAsFQQkmQYAzOwSGQvbZqjzhd3mgVuHcTmiOM0mcyKQauYH3XQwm5qkGhT0t
 ClBih+hh
 kwpZ04DII3yCw4lK4d80/IKidwQa375zDRjKeQ4NBxMseL0+UZLzS82fMcExOzkee9KRa0tHHckoQIQZuHHXCc/XNMukM+BGssXC97CzekdqpXl9IaEEkMAtgQVALyTBIOJeJDJenuXxHX840l9HlQZgeWCdhiEt2AtBeXQlUrqMEmFkkomahHlMKIHxg1477T/CWUAs//Mx1TSJTwyg6B+IXc/kRR7NviKbnZox08apnPVRoEZgaveSUmNDUMofGWlqD3CLwUPfOt6bzxzqp/vsE8YdyOCT/cQKjimraoJ12xFI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 03, 2026 at 10:30:10AM -0400, Sasha Levin wrote:
> On Sat, Oct 03, 2026 at 10:18:34AM +0100, Lorenzo Stoakes (ARM) wrote:

> > It was sent late on Friday in a week that I was ill and it's Saturday
> > pre-LPC, so that's hardly a timeframe that I could reasonably have replied.
>
> Keep in mind that our release cycles are fairly short, so this shouldn't be too
> big of a deal?

I mean the same argument could be made both ways :)

>
> We will generally go for the safe option of dropping a commit that introduces a
> regression as it's fairly easy to queue it back up very soon after a
> diagnosis/fix shows up.

I think we'll have to agree to disagree about what was safe in this situation!

Anyway, the commit is fine as-is, and fine to be queued.

I am writing a patch for what seems to be the underlying issue which appears to
be related to how perf accounts things.

I guess I'm going to have to pack for LPC really late today :)

--
Cheers, Lorenzo

