Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60B28D1118E
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 18:14:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAA926B009F; Wed, 26 Nov 2025 13:14:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5B1B6B00A0; Wed, 26 Nov 2025 13:14:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A70FF6B00A1; Wed, 26 Nov 2025 13:14:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 90D7B6B009F
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 13:14:57 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6CB08BAE7B
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 18:14:57 +0000 (UTC)
X-FDA: 84153559434.20.F861FD6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9B68A20006
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 18:14:55 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=p7X5qj2O;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764180895;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hpmpWmbnz8Thf8qOhc0rH9R++NsLdv8emSQl3kXPtik=;
	b=k8YeFeoVPd7BeMquN6U9xSbIz/zzXk1U9OEY/W/n/ZbpPj0jfaOntd4LnMWzpWdwMI3OVa
	FireO9aZzQcJmeYF+wCEHhYQ22QmM/Y1UHdq7DfUDyoDSZenHS/vodoCwC68Jb28JuL1Sz
	aoJMlJdMctIkkd3CIy6W3AZK+wDY8LU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764180895; a=rsa-sha256;
	cv=none;
	b=dCiGdBReLyTKg50d+fLScpJTpujQcW2Hhf6kKpSw9elosMhtgUPYe7WHAOe5tqnaaTd6/+
	3NgRBMzvm0xtrGcsDbem2ubCkRYXwvzwjNE0e3oG2Qqn9mWqhDCPMDsWHUYA0S90UwMGDk
	amverIOtUBPR9mlHb+JemmVccNp1b+c=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=p7X5qj2O;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 544A6435B9;
	Wed, 26 Nov 2025 18:14:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFBC3C4CEF8;
	Wed, 26 Nov 2025 18:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764180894;
	bh=kjHx5hFM99/6/f9ENV62ybrwwGC7N83jK71FIRHO86k=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=p7X5qj2Ogw6DhSG+Db57ZmeCGAeKCNEcijtsjxrFozJXgGhSqVSUuMUw7Hny7oktD
	 DGvCr7OzgAxHGT0C494t7VZdZ3M5DlMEOAongOWa/1BsSg+h9+f/6eJ0omjCtdMfJv
	 lB77JHtJjrQ3Cv2HxJUD6A+l7gizCooLwhU2WEFM=
Date: Wed, 26 Nov 2025 10:14:53 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Breno Leitao <leitao@debian.org>
Cc: Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] mm/kfence: add reboot notifier to disable KFENCE on
 shutdown
Message-Id: <20251126101453.3ba9b3184aa6dd3c718287e6@linux-foundation.org>
In-Reply-To: <20251126-kfence-v1-1-5a6e1d7c681c@debian.org>
References: <20251126-kfence-v1-1-5a6e1d7c681c@debian.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 9B68A20006
X-Stat-Signature: i6qrodaent64uom8haekyipsneizct5d
X-HE-Tag: 1764180895-841732
X-HE-Meta: U2FsdGVkX19oIJoWAT/7hChqALUW1PunIYKbOPwBAw30OZLTd05bupNtTjzeNM4Sho4cJ0v+hP31j+roCzRGBNZ5vqESzjYItyIaKW3kHcMTGsn36idAHsW0HEorrLBxAh6LJzZMGqX6/+GtpOd+mRHL3QoT83njinK9Ttv7f6I+mNAzDvqFOgWVak39eMvFTWk/CDzWF86pltwU4kMnkn9z5XULctC720/2t5LQIGKNqOMgmMGfqJoUrbDGcEq5emWup8sR9Y0Rl2HIxpdpCEf+Lmf0MBCz3WowB7PIEYWjx4Xow6FvFOkTdZoh3CS9CAe2Aa4gJD2+0x2jjmDsA9XHdS4ktMfoCA6IUwgmfM2bS1H7+5fgMwhtMPfGgg3xEi77sFj/HXuwaFySsD7qMaBrDHzEKKitcojoDAhMa8Qxim19JGDyfrl8e2aNLgkDwGe5JiFgGMR6QDGckX1966vtOXcles7sCKD2vX4LKAcrFMdMhlM3utL70vcV7NcO5asR363hGEiKV+vWOFgKU8Ecwny+6ib32e8E97nawufudolT4stjrd3R54PVOeyFtT3WarT/K0xqrTS094Y5Zbxm1Ap0TApe2A2OPHQq1Xz6Rq5p62SCqMJcjbpOd4ljnlak+AxM9LDFsAJwI2hhmdNablFmLZPHAK08BNcKy/nrriBt9UExeyTcimgc6l0wXwkr+BQPHFejEEzkE+atW3MqcU5ifhNIrh/83vrd2wv7jVxggpWHo9btfP7Wx7CiDUJk38C8jNDbB6whY59/RjcdZ26LKKfhRN2RZ4CdPy2SPwY02K9ftDSZgxdosr7v/5boeY+hsD06udSzZEK+dWWdhd3XL43/19WzMUN26sYtR1WrlMRyOqWWB22gl7mNLCdP6UbtUFSbWuxayH33ZvLVAbqwK6pUH5ofTZpddPtYcaxfr+4IFWjDousUF4koLCn6sK1ze/brAH11NK2
 zvNHm7iR
 eTB7zxpMtA4hNpkf0RQiLrBoir2xp5WN8nbscJfMRSXZ3njnZz10lyDmYznb8e6sjqV2SMqrJ6kH8i1e+7h+p0zJOzIhBjz5Tfce/X4vUrGiE9xn0RR0O/CJE/aQTyeLR2aTlBDONgymSD+ZgGzlZ6cLQtCgo17J9beoPBqLALiaF3zcIiBE18NSggwN29AfrCGUYw1SLl4d2KfxPhcYbDTW5MVv72RlLjr2tcEcy7SoLfsFLP9Sb+vCHOYyGsDw1AKevtccPpEQKcVwIb3ZoLYzbTPVnNraYeBGf0weRpfmTTzs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 26 Nov 2025 09:46:18 -0800 Breno Leitao <leitao@debian.org> wrote:

> During system shutdown, KFENCE can cause IPI synchronization issues if
> it remains active through the reboot process. To prevent this, register
> a reboot notifier that disables KFENCE and cancels any pending timer
> work early in the shutdown sequence.
> 
> This is only necessary when CONFIG_KFENCE_STATIC_KEYS is enabled, as
> this configuration sends IPIs that can interfere with shutdown. Without
> static keys, no IPIs are generated and KFENCE can safely remain active.
> 
> The notifier uses maximum priority (INT_MAX) to ensure KFENCE shuts
> down before other subsystems that might still depend on stable memory
> allocation behavior.
> 
> This fixes a late kexec CSD lockup[1] when kfence is trying to IPI a CPU
> that is busy in a IRQ-disabled context printing characters to the
> console.
> 
> Link: https://lore.kernel.org/all/sqwajvt7utnt463tzxgwu2yctyn5m6bjwrslsnupfexeml6hkd@v6sqmpbu3vvu/ [1]

6.13 kernels and earlier, so I assume we'll want a cc:stable on this. 
And I assume there's really no identifiable Fixes: target.


