Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F448CD6E4A
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 12:06:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C72A86B03C6; Tue,  2 Jun 2026 08:05:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C23ED6B03C7; Tue,  2 Jun 2026 08:05:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B127A6B03C9; Tue,  2 Jun 2026 08:05:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9F9D96B03C6
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 08:05:59 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 508701C0ADE
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 12:05:59 +0000 (UTC)
X-FDA: 84834844038.22.ADBC7D4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6292880011
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 12:05:57 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Amo5lWUb;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780401957;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0rBNmQTDKcWgn1oObpixLuWnRYTldupbgDAPBU/n0Rk=;
	b=8kpF08723pb7qQgnDteQPrzhD9eo0VL3LyyB7Kb31RzQOdEwwT334QddK/+LHotuMtru6Z
	Ig381qZnWAoPi2Tbd4GTNNsMdFbWAiIKFjD4l2xND8k32okpfC0Am8xYpn8DIgErywbzDZ
	O4K83dkltMFmLHMsZmyt6+gAVrJqums=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Amo5lWUb;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780401957;
	b=LK7gS1YYcDlOGVZO7cGrKeT4gWnH6uCgeAJ/hgYZVAEjWW5joDBIUTUWk5g69RK15I0WOU
	xgI0LXX2YkZdzTt7MRyLAELjHbi9yuXISNKxHpcJOP+JLsWBIhgVd3wJqbDee6HHzOvLoU
	lilWZ7BzH+SCg6tn5GLVqvC2im0N638=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 52A6643607;
	Tue,  2 Jun 2026 12:05:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A170A1F00893;
	Tue,  2 Jun 2026 12:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780401956;
	bh=0rBNmQTDKcWgn1oObpixLuWnRYTldupbgDAPBU/n0Rk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Amo5lWUby9SawGFQ8No7VSEZsFiPxSj5m2OfYruCYVq3s/uRBYbaCkiXWkqYXCVtQ
	 G995pxnNeaB+xoogXGEKPl0Ks7hMaowdBP3Wf68WwyeRAZxPZhr/OcRjfcX6l4TX4K
	 uTTfQnL98J32ccApLKowF6+5uMAfCieS9sqPp1d+oNd+AkY+CtaxVR9zriRKhaM3d8
	 +fRUzpwzaPPTKybMbEfMfAMTBIwrLE0PlykGMFNTc/Q9GpWgBkgQSfobauimVfuY32
	 NRb2KNo4YQ93IEtqnG53cj5Vw55UnJus60mdKn7B7/CIfsuX6Q10ye6MeOqjJIpI1Z
	 0YPjgnT/UOSJQ==
Message-ID: <56c9fc17-685e-429f-832a-964f28b9dd4f@kernel.org>
Date: Tue, 2 Jun 2026 14:05:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/3] mm/vma: eliminate mmap_action->error_hook,
 introduce error_override
To: Lorenzo Stoakes <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <cover.1780397980.git.ljs@kernel.org>
 <55d13f7d016b827c459946d46a56105635be111c.1780397980.git.ljs@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <55d13f7d016b827c459946d46a56105635be111c.1780397980.git.ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 6292880011
X-Stat-Signature: q6f9nqxo4h43gaf56uwx84i6f99tqf16
X-Rspam-User: 
X-HE-Tag: 1780401957-278322
X-HE-Meta: U2FsdGVkX1+mazvrYV+JyyIGv7lmgcRXnuWdlTmBggvFIMn/6VWJ1kT9MhXgLS2kOmfGuahzQ+SBxeDTNeAJOOVpHWP3vHZ8pRuZQUIFVmKPT/TH+jbjZbz6L+TUMIcQ3iz3hFdnju9NAccIbgJhX2UhW/qQ+9ZGPheoHTiWQNAU7jsz71+3mBdzbLLYHNDPRupSC8pETs33Ipme9Bd4J1isVIduMhbRciPzlVTrbosOZbnGzdjFaZOdQTiEEjAE4fU0B8+GGRPnvzanoznval58pUojkArZOMv4sBjNdGC9ankgPzJ/aRre6wioFHPqaIHnXO0O+shunS486/HYIbAv/7/y1ZoGDjYb9lbMMxjHBrIMvLmhqEaju/kpYoCSMlc9GZf9Q1U+eTpYl0Mi5OAwnkfPUw+t+Fo1b8ZZZicrHAjX6tDQ2+VaElQw9VAQCVd9NiplfuREd0ch/LmA1ip5bfEgXSCZGesyEOJ4LyDi0oUsvusH29myDTsyJsUfzIpdgHtXHtQRtVCAn6YBNFfYunRczACJdSUz+0DWsDn65zhvDBNagurTRKDO3pDN4scMlY0/LBK33TCMJSGuS8YTaSVI/LkkiKiz82VD61kIwBdDFp3NOCD4SSt0/tItv+Yfi5Z8fRBdhTLY1AocU7ENeIXk0awblUUNhBIh8wwPkbEHa12tR4EWA9EWv0CO9x1/KYrVq0dvHIgyYn4OSxXvZjb5Qh6tBib+zVBhOlvlGoKUuja0BpCtj0vZBkp5rggxd1Acq8TQBGx9MFyHSW52WzbDfMGl+xn/uL9AeXFB5dycaRmY51j4zaeeF8AmTe2hArKFF1Fgo9DHr5mcXNB/Zv0D+lurxE8SyceDdzFAu5cj6cqC9FDxKo4kymQUvMRApYtAjE8y1T97Rxb9oSWlCsXf5xMow32HnyBtOR1bvIWeI1sAY4ikPqF7hufMf4uSxjj/Rb3a2SXV+4r
 2nhdzSiU
 bOfoIpZAieoF4+ql/6+jcE9+JtgCNAxpDqXSK9Kj1JegSF0XoAj8x3zIRSe6H0lrfKOVpkk8S3gW+i2zlT9MTp59tXXVcCndzxs9w0WuGVbITu8mgdfKSIAIRObjn8PKNtppFPMR2W904tw1e9Ekakx0G038lAeSqHFqvMfOmRaKjXSg7A9h0ozAUk4aFMydVu41sKXjQJC7LgspksEL5zV2EMstHDswaT4RSq9GuNJDkVDdGo/xIN/WfVIuo2PDsgAOSrVoZIKmOwezOTsO1sC8V1L83OizgCAR5wpWjd2uqXAuY9Bw18cCEBz+oWLXNae3yztWkcFcvkIU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/2/26 13:06, Lorenzo Stoakes wrote:
> Rather than providing a hook, simplify things by providing the ability to
> override mmap action errors.  This allows us to more carefully validate the
> value provided and thus ensure only a valid error code is specified, and
> simplifies the interface.
> 
> This way, we eliminate all hooks but mmap_prepare and allow only mmap
> actions to be specified (which core mm controls).
> 
> This significantly improves robustness and eliminates any unnecessary code
> duplication in driver mmap hooks.
> 
> We also update the /dev/mem logic (the only user) to use
> mmap_action->error_override instead.

Thanks!

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

