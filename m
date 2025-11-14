Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57561CE8D60
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 17:18:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3C448E001A; Fri, 14 Nov 2025 12:18:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A13978E0014; Fri, 14 Nov 2025 12:18:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 950318E001A; Fri, 14 Nov 2025 12:18:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 868BA8E0014
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 12:18:39 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 30422B98BF
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 17:18:39 +0000 (UTC)
X-FDA: 84109871958.30.6BAC45A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 789C3C0017
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 17:18:37 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="DDxLfb/K";
	spf=pass (imf28.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763140717;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HfCF8pPF5t2v7RxDZ7/y3H6IXB1Y2o+3F6StwNtACpE=;
	b=hhPIchWazxFEq6QEZ9r99F1OO3l1Mzxt3BfY1HgW6v4hsujhF9BsXao+lcDixIJTgWZeO9
	zDaXToEtdqU6NF7HXyzsGH3sqNNPRbpUoS9J5ZLRYVIrCpRDTx78p06Hdpyah24Cw89gy6
	23X44zlDeoveZWFbPe6bBMYqKf11yrc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="DDxLfb/K";
	spf=pass (imf28.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763140717; a=rsa-sha256;
	cv=none;
	b=FhDQyI8rQulxD9nwcFqLc0vIyNbyg703gHrM6XXvfjy37oo/yk+7OyfuSlKPGeMECBPURK
	uzDo87E6ZTUtkFRjXnPttv5kYbrx5yj1ELmkjfMN9UGgwPdZmXIS0rHqm71bKVifJfPXXv
	gqEoP4O4yfa7l/s48Zi4YGJaqI/t9Lg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C163360197;
	Fri, 14 Nov 2025 17:18:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10CD8C113D0;
	Fri, 14 Nov 2025 17:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763140716;
	bh=gAz8c0U9qtGAsVP9eT4MuLFLegWENzvHUrrbzi6YB7I=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=DDxLfb/KkNzBf01AdwZSzMCwl9oCPhwnWtd+w1+yjiWzwQJtCAL+vxORBRLi8xFre
	 xB+730Li3oDV3fKjjKXHPSzdB82BwnpQiZZJin3jtPS1ePiS75Zv937VzhpshGKyGR
	 QP0/XGz/Eumy45mDMOlTBAmUqYP0m4eR+ZWM1pYQZF5mRb6hLYdJVUKRW9DPwpSl0U
	 8HrAQBajQXlKt1Urh02I6HXS4EhbZ8Xpj8bRRQ8TIoNOiif5nfqUR2+PYPdsmGFF9s
	 Hf3kY8hPotr125tSFrKIepSsSmW9RDjkTofYXhIPRkhjqK7KDNdWVuC4i/opEFM7rc
	 AIhRV8xetghsg==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org,  bhe@redhat.com,  rppt@kernel.org,
  jasonmiu@google.com,  arnd@arndb.de,  coxu@redhat.com,
  dave@vasilevsky.ca,  ebiggers@google.com,  graf@amazon.com,
  kees@kernel.org,  linux-kernel@vger.kernel.org,
  kexec@lists.infradead.org,  linux-mm@kvack.org
Subject: Re: [PATCH v1 08/13] kho: Remove abort functionality and support
 state refresh
In-Reply-To: <20251114155358.2884014-9-pasha.tatashin@soleen.com> (Pasha
	Tatashin's message of "Fri, 14 Nov 2025 10:53:53 -0500")
References: <20251114155358.2884014-1-pasha.tatashin@soleen.com>
	<20251114155358.2884014-9-pasha.tatashin@soleen.com>
Date: Fri, 14 Nov 2025 18:18:32 +0100
Message-ID: <mafs0cy5k7ct3.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 789C3C0017
X-Stat-Signature: c1t3skdhbbbonsc99fancobgzauejpdq
X-Rspam-User: 
X-HE-Tag: 1763140717-227702
X-HE-Meta: U2FsdGVkX1+xXUUrCkelzGZjk/S+kqwPY+6KIODrpV60QulfGf3F2JEP+et5dwXNFABygsVFgTr6Qa5uEPHY2ZqDO1Xe75NW14OmSpkv+ts6wbFwXV+D3GkwBwKwzMbRPc7UoseFHQVEdzBPNEtaasNvVA0Tu6ZqfYd5FZNXLhqLCF170YcTmX5VYCq4iAwB0jIVuE5zYzeMN1yPcQvBTa/0gPtgxvRckYGpHH2eq6t19IdX8Wpg8VbZu63RxMFxCI/CWKV2EqumdG5Msn1TF26ys7Qu3DhD1l9HZVlkHlJkxl7kwsIaw2zRZadDeD/0aDBk57qtfb4HIEa+DrWmGtdhr/LAvXltohJl+CNxydNYJa9AtGuiiW8W46I7hQ1jRS/lItjmZkd6Nk7kZypla7+SoqSDwQLyLLZrZf+cmAJ3UAnwPTbblEa6vOnN89bIDE91WYC2K/GwYp005/Gz0yr5uj5HeDVG5lX6Z2C4jZ5719q0lkbXupkuEZ7IEcLWE3NxszTewPhv4DCAmUe7cDzuIFidsno+oF/tqkiYZw3dNE3ynv6j7SYGVmFRaqWjOV8tESZk/XwvEUqvxyR08AOEz0bDQkpuJQ97DR1dueNT+cITuDUtbzCd1zQFj6nkcSgqlgXZx3PmliXFR+zl4ueZ4BNqyZFl3+jODYEFye874N5bzdOVg4pSuSpnfwbvZIwmMNXEV6Gvp9Q899FLiN7qV/nhl9BPP8tGMBtCTrji4LZEHKf0sqC+zmIq74NUXz5IFfSMugmMc57cFcw1Bby2HelxnH7AQu5uAHXTstJv7m9w9XVUSBPIRk7x223dbDiLC8vrvlA8h6c4Fj7ndlPTV4GDTnLrgk+I5wG0n9XVWd++SCr+3pJv5VfU0+SGbIlmhC/woaVOpb0iiAiFlfLUWVeUSUVzlL2aDAyfyCUW4KIPgbryVSgocjd2mO4GFrqv3q1QnflvdAprZ/K
 p/2aGKJP
 9Yx7SRmOzrzhqNyAtPKinbaG5kU2/F+YTcXW0IV2GLGHDr4zLJmJymbeD/IvLdAvh0S3Mr3oOAPsgF7neuMDr8+2mPQeMU37j/TInle/Yej65eWTWh0pQjtvrPvgd7PDwJ1nRUgeFlDtVxlClwITLLhg6/xbTJzPrMS1otMOXvZ2T/Is8cGtekTh75pPj+DSTWXIx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 14 2025, Pasha Tatashin wrote:

> Previously, KHO required a dedicated kho_abort() function to clean up
> state before kho_finalize() could be called again. This was necessary
> to handle complex unwind paths when using notifiers.
>
> With the shift to direct memory preservation, the explicit abort step
> is no longer strictly necessary.
>
> Remove kho_abort() and refactor kho_finalize() to handle re-entry.
> If kho_finalize() is called while KHO is already finalized, it will
> now automatically clean up the previous memory map and state before
> generating a new one. This allows the KHO state to be updated/refreshed
> simply by triggering finalize again.
>
> Update debugfs to return -EINVAL if userspace attempts to write 0 to
> the finalize attribute, as explicit abort is no longer supported.

Documentation/core-api/kho/concepts.rst touches on the concept of
finalization. I suppose that should be updated as well.

Other than this,

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

