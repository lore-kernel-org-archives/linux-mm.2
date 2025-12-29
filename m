Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 800C2E8FDBE
	for <linux-mm@archiver.kernel.org>; Mon, 29 Dec 2025 15:23:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2CE16B0088; Mon, 29 Dec 2025 10:23:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDAF56B0089; Mon, 29 Dec 2025 10:23:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE6906B008A; Mon, 29 Dec 2025 10:23:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BA7896B0088
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 10:23:05 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5CD401414E3
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 15:23:05 +0000 (UTC)
X-FDA: 84272876730.07.33A7CD1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id C93B1C0011
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 15:23:03 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gasBn2fW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767021783; a=rsa-sha256;
	cv=none;
	b=NH2mRa0cj0gFswjO80ZMG+U+SZlHaAjnrRJNMq9UQlk2z4xlkJkPrvr+F/LhHOiHIhSf7f
	Vw76FpZ6vqMcFoFvqkATRk7ArbV2D3u5aRjPXYNwvQ2ERLwGy+f3MhjIVIrH6ZBHbrO5P8
	jVscl7vUlJnISFB8UMWgw3y4tE/Tzyo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gasBn2fW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767021783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q/9spkLa1neyXuVGt9odCPKJe2oeoUVnuY/oPfFqFrY=;
	b=nAt/BGvbgZCJuqzUNjygDlP1+HstAyVB9E1NLpng6JQRfDrADoRlN3Exm3R9DJcEjQsdiQ
	9PC7iM2PM03ubQnOv7iJNqlIwL1eyjXDNg72PAIDG2JEMzzrPczPHZbcQQ2Yq11XerZOWe
	XSNeBpPdc2lhvsb64P1Xd8k4KL6u26Q=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 420B76000A;
	Mon, 29 Dec 2025 15:23:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB7EEC4CEF7;
	Mon, 29 Dec 2025 15:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767021782;
	bh=hjLy/PceNw58V9dV1arMQA3XkITKYMDJEG7qcaYiXd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gasBn2fWJ//NUxKL9tbdOzF2iOSzTNPiq5/m0pGiDe93U97Scwv8eD+9RETnfvY0O
	 iuBi3UjXjvaEtfc63eKCkUcmLedLEFvXR5LG9JqmtusXEVqSiqbiKljn4YEjktnb6t
	 5gFWJ0txmmGVWitITkJJcCtmyqMDf56SELo8VTG8U0qqOVk39cnPO+MzCTb51nFEQD
	 HikzV64qn7+vpXjI9Oj2oQAgiQj9mrA9+qa9MDmHNpTUdaZQo7JcfizQP0ov3cC7cP
	 FKFM4sXj8GwVPFb7bKU/JpBr2Uju+jdPO2Mik+ceDzAhnUw84MhboGKReIV5liJ+x0
	 dH7xIrExMdh+w==
From: SeongJae Park <sj@kernel.org>
To: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	wangkefeng.wang@huawei.com,
	artem.kuzin@huawei.com,
	stepanov.anatoly@huawei.com
Subject: Re: [RFC PATCH v1] mm: improve call_controls_lock
Date: Mon, 29 Dec 2025 07:22:49 -0800
Message-ID: <20251229152250.78975-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251229145533.2437293-1-gutierrez.asier@huawei-partners.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C93B1C0011
X-Stat-Signature: j31fjqepsah1o3jh9j31fhdy93a6dyr8
X-Rspam-User: 
X-HE-Tag: 1767021783-568731
X-HE-Meta: U2FsdGVkX1+drGYNsCkPKN3liZGRffT9q3ePEHEyWdWrGatehQMQMyvzh68sXgBGy2p9IszWtRQEON5Tn8dLrUJ5xNfxTHJqsOiXdqHCrv/leuKZQ0f3O7kWVC2/Yg0fMed9TciZLELOseopMONfn5QwVxSE0vkrAZNqO5ryWmrYuRdPwHuWQzkRMndZf3ZbOkiBfAu23xruUR209O98WI4f0REDZIi/iDDXUNaXAiFvh/wO7DkW+9HPTyP4lb6ASnh6Hvw40MZVoTPX2M20NgHkPGsaTJ94PlNq+gtzEkKuM8Ubshydg58HwkwPOG793xB1lucUOGt58hNX9TP3beEs5jwamP219MidzfvNFX9zzBs861D2aNzICQBmqKS+F8FikrFs4Qi3HTUBSTCeBAd24y1JogPpN82BzIBpd3Ws09Q6YxuvmDaU+PMbG9B34Lvix6HvJD+79S2m+M0M6TW7xlFBuC7pKFgJQV5lZ8cQQq9EpXaSJccWWGMfD5ja78EZWEmQplIeBOi/H1NM94HA4qu98j/tmIFFCdICO0tOeLZCXIm5zbdTLSrr4AsCXLtGhEw/eElp7Lr+qeyvUwQ+KtyD49J1Ip2UVGX9YJ6/3K3Stn94BQrBOFTS19xu0ZueABAEklKTYY/bS6fG2ctlGHYYZhTqjOnwzmqFTDaR4T1JvAArI6VKmqHWn3i7rszqCNTpBw3tbBIKomMdbq5e+7PuLu7TVLs/F5Rd4ckD6JxKlKWkMpLcQPQYF57z8++dyr00IHYcz5qL74f3KCeboNi4nwo/HrUvU1HFULd4XX1R3USkSJIbJ6ZQjGOYl+iYxZGp2Jz3PzTEpaqF9kw1tUZR83WTnPMX0SOEMvQyqrE4XfuLBUMVRT37muca2ka+m+1++piIhrBXhBsoOTUoS19Vt8swkggj4kbF1UzY+esk8K+hv8PlI1mDbHexHo5VjtlIW4OVL/QpAVh
 Z48ZBpgp
 NsLj2MRG7uLfp1373HrptSJqG/qzfgU7VksxQ4kA9tSsKN5VKEtGAXxdYKmX6j8vFIe+HS0s8RUFCR0h7oYnLBfJ4uhCjT1OfibNrPqYom4EOenWm5Vrez6FYDNapxlXcdAmICaIgqZvUnN0PJ05jsNEIxpG/0d6oHxWCBi+yFrUfZYNLzkzfFt4V+0kSpsRzp1qtA43jJAe0f+t2p0J0LgH9vIXbf8NdlJRieJbKm8Yv2n6MWk/OJWYOovAI47b9OQKKj9nrqjQIlj+4QNsvkPz5aw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Asier,


Thank you for sending this patch!

On Mon, 29 Dec 2025 14:55:32 +0000 Asier Gutierrez <gutierrez.asier@huawei-partners.com> wrote:

> This is a minor patch set for a call_controls_lock synchronization improvement.

Please break description lines to not exceed 75 characters per line.

> 
> Spinlocks are faster than mutexes, even when the mutex takes the fast
> path. Hence, this patch replaces the mutex call_controls_lock with a spinlock.

But call_controls_lock is not being used on performance critical part.
Actually, most of DAMON code is not performance critical.  I really appreciate
your patch, but I have to say I don't think this change is really needed now.
Please let me know if I'm missing something.

> 
> Initial benchmarking shows the following results
> 
> 
> # bpftrace -e 'kprobe:kdamond_call { @start[tid] = nsecs; }

Commit log shouldn't start with '#'.  Please consider indenting the above
command and below outputs of it.


Thanks,
SJ

[...]

