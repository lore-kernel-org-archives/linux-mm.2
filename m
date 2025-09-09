Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D88D4CA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 12:14:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3EE078E000F; Tue,  9 Sep 2025 08:14:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C5BE8E0001; Tue,  9 Sep 2025 08:14:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 303038E000F; Tue,  9 Sep 2025 08:14:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 20D9A8E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 08:14:04 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B5F1B11A28B
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 12:14:03 +0000 (UTC)
X-FDA: 83869603566.08.DFA469E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3419540013
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 12:14:02 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CuzrSo2w;
	spf=pass (imf11.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757420042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tt9cZvyCH1e69uk1ra9K12GwG7NHIEkl8OmCsIymvgw=;
	b=ESqoYMJrjlgF7puq7oRCr6DC0j29+2vIYg7c8D01Nt8CLL09E3e6jNf5u+vnIEjG5cpaWl
	xKiQfol1lQRNuFCu9auG3SKyPqRXjfu1SVHDT9n9sHE88kcQ5LyGGf0Nu2ngF/o/3SzmtL
	J3gaq6EhZ0QAaM8ikoZlpIHCqsg1WQU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CuzrSo2w;
	spf=pass (imf11.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757420042; a=rsa-sha256;
	cv=none;
	b=tZS6rkT9LKDzig9cqaz7cswq8yctl4Brv7ZwHO7XegDJHR4WpaaVk2GL0kXCBp2onjw0Dr
	5gJXsgxa1SeyN3oy7DuWXjWbAvCQg68MJwg1aGwQw2n/RkNBDQbZD/tJ3wpf9Gbs5kn6Te
	wmoGZSzGFEj6MuRYfuvJ6vQnsC5Lfto=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A4A6C6021E;
	Tue,  9 Sep 2025 12:14:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F938C4CEF4;
	Tue,  9 Sep 2025 12:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757420041;
	bh=tMruF9j+G2L1N4zuR4KW/thijoi3DgRD3fEIsvtunMI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=CuzrSo2wC8/+3xPSVkuL28/fLvs9z4VJpLDFlrUXZ9QxiUGZDvez1QEhrB8XqYimj
	 fKwvYQVXCm9wRitIRSPiL/qlnuM7XUwUnU4c/0qtwyqJOfv2HKela5PjaLj6vZQ9NO
	 iAFuNP2nZ+O8FTxe3FH2XmZGMJED34JrwSPdAMQDeQ6/Lil+VBaI8Bd9U44Pkysx+A
	 Ib6wrhmrBV1nEtPBDWRL8WlJP18Z4x0QyfHsHTEvgiQgITLatG+f31/iTaMSKMOluJ
	 KF+40oysRCqEyp2iNF1E4WvSlF21xGRkW/L7Rm0ZCdf1+vBw7KShria3xnXpbaPKz+
	 ki1J91Mqyr//w==
From: Pratyush Yadav <pratyush@kernel.org>
To: Evangelos Petrongonas <epetron@amazon.de>
Cc: Ard Biesheuvel <ardb@kernel.org>,  Mike Rapoport <rppt@kernel.org>,
  Alexander Graf <graf@amazon.com>,  Changyuan Lyu <changyuanl@google.com>,
  Andrew Morton <akpm@linux-foundation.org>,  Baoquan He <bhe@redhat.com>,
  <kexec@lists.infradead.org>,  <linux-mm@kvack.org>,
  <linux-efi@vger.kernel.org>,  <linux-kernel@vger.kernel.org>,
  <nh-open-source@amazon.com>
Subject: Re: [PATCH v3 1/2] kexec: introduce is_kho_boot()
In-Reply-To: <7dc6674a76bf6e68cca0222ccff32427699cc02e.1755721529.git.epetron@amazon.de>
References: <cover.1755721529.git.epetron@amazon.de>
	<7dc6674a76bf6e68cca0222ccff32427699cc02e.1755721529.git.epetron@amazon.de>
Date: Tue, 09 Sep 2025 14:13:58 +0200
Message-ID: <mafs0wm67lt6h.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 3419540013
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: mixjmgy556r7dcfcm7s4ibzadzo4c4gk
X-HE-Tag: 1757420042-595545
X-HE-Meta: U2FsdGVkX186xHbaJ3pnxjygqkcfQODBbQA4epq+Vdkgm4hyxMqCysztOLdif/rRT69D99tDNSVwFeD6ThjEp04ffR3ms/tNim+30xTxXEp6x35eM+cNW6U22UZji2leXZwlEqAzuv9H4a6za11dNwAjjYdd8Wk/yA9ygHwCviAWGakx4rNHp3ppxE2ZxxsuGrI7tFVZ+BUrlo/zZKuBTsJAMDrSJGiKJlERJ5Ll4of813Eu6ypXsG0bEeZ6RIPlSKrUC0r3DayPlf1bq47cmBUBN95XUXdYFW3KMQGhEgM+0+MNk+x1yWMdZFs24FGlhs18kPmSoskLUr47x0QQRdQXYnny84hV6WrqkPS5A4jYfHXDPbq+P6OaW+MXkvQ4hyUzD+EC07Y5MzUd3VKTwGjP7mScYNXYNaSIz+4qaZC3HaovRDls1B7r/Nnjck1cF0x3i6QtBLJx0ShQ5+bfgNivSHGClPFCq2GudnJVlHqgpeCSd2RKZm33g5HDgY3oY+vpPtJeD71cek/d9PcUMwA3XE94Tx+JUPsyvqlBAdVpc7Pc4R+hg78YvUiwMNZUC1O/XK3ZEIG0hun32/OL8560XjLAXwXCjOydXVFX+3GOh0hTw4pBuL6d6iCAkuqLPFAXk8rXT3J3jk+SaOqaom8HGt/wEhsvsbmVCQZ6F3dyP5HMZLXM/WYrp0qlsMo47u8BfJNq+iRGVBXfMzPpmLrBPQU7nTsQHTXWY/3tfIazlSPtdwvEbbM0fXyTXTY6g4dLGYoAYjYe3FcVMLrt0v68/cyKiqoXyoyCO9D3latEHzDbCna1ob7kr9/U13oesTHm4FMcZ/hv7frR+flsZx3vEEsIbhh7+3jp6jQ4T+35c7Nl/QBAo7wEOIX4NRuX1pmwsz72td8oj6GONd2PlFNxmzYafAS3aJZzcvzgDT0/9Z0hforInn4le50v25QNeP/Ow1fy0nZX85Ynh3c
 737gnpg7
 m5+CCjZ0bs9ZlcSxJS6zfh6+Z7QDK+t+5igGDYa/Pgnn0L2BUI8s7ibY3gqjZrswvnhSd7CKa0jQCgbBVMLWRTozfOf9JnojDxgBkyh4v+jT7yO0kcro69xpZlk2Qk3tUNvHQ0bmCvdqDcQLYXO+CUwWw8nDPGgCowkBq9GoLDtn8gJnmf7Dja2NghdRktQHo3KJ0JTvR3HrKMyLj8UKY3rXbLEcMwRww4s+pbk6iSIWGQ8qTdHp9f86Uug==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 21 2025, Evangelos Petrongonas wrote:

> During early initialisation, after a kexec, other components, like EFI
> need to know if a KHO enabled kexec is performed. The `kho_is_enabled`
> function is not enough as in the early stages, it only reflects
> whether the cmdline has KHO enabled, not if an actual KHO FDT exists.
>
> Extend the KHO API with `is_kho_boot()` to provide a way for components
> to check if a KHO enabled kexec is performed.

Neat! I have always found doing if (kho_get_fdt()) a bit awkward.

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

