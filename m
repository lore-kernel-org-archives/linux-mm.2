Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E269CCF9FF
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 14:51:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA8558E01D6; Thu, 30 Oct 2025 10:51:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E80238E007D; Thu, 30 Oct 2025 10:51:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBD518E01D6; Thu, 30 Oct 2025 10:51:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CAD398E007D
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 10:51:55 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 698CA568AA
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 14:51:55 +0000 (UTC)
X-FDA: 84055070190.09.E7FBABD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id DD70E4001B
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 14:51:53 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eQk1KEPL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761835913;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WKwjBQEqXFPKO+WzYJAtU397ptDKk7qO+md5aDf4qeI=;
	b=pVtMM5ZJeRLL+qGrDueZNnl8koGE41MYAfomJ4/HZuaheVVkNcvjDQTOqZ2eUzfANNZKUd
	L+4GKB8SvTTNPx6117hICcMVhOnrMbCUr2CH6SykDtURI4zlIBhNgnHlAGpoC/loWgQ6BJ
	btA06K7/Vsb3VY6oBfGWicoKcLTl4XM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eQk1KEPL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761835913; a=rsa-sha256;
	cv=none;
	b=Wv03+dgMAy03QmgYRbQ/1WfSofwywXRMK+FsPrWtsny4VzWdvL1DLVo9s9GKI9U4PA7F64
	waRFez6q/HybQP/K0B/JgmrRGJXmZSkjNZ3KSn2rvh6KuOCetVqwgqwiSMLc42nDQtkU47
	ao2+L/XyW15o/RqZG7aQuoOyhtahYFM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 209D5611A5;
	Thu, 30 Oct 2025 14:51:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A797C4CEF1;
	Thu, 30 Oct 2025 14:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761835912;
	bh=WKwjBQEqXFPKO+WzYJAtU397ptDKk7qO+md5aDf4qeI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=eQk1KEPLZSr8AEWd/EU8u+Rrrky9aVBOpC7OJb24MtNAy8lk0RV3tvhMD4m4ACHgr
	 fMlATft9Er2BS36a8xMX9gPc8K4bBTSuSpOK5p3EBHonicaJ4mGIeI7f3kztqcEmTe
	 SRD8UsdgXC55zByvBL2GPf9BGZR+5Z6bCWvWJ48Guof+RmgX8uZh/na2+7gRavwx5/
	 5rqNlDqOvtDtHZ7DFY/4iS63rM4nUKvfa0DBlZL9xCA/LxOOXy0Wuh1dST1pH8CTe/
	 Ds9vTfVN/js3WH8pZd2wSp+qSUJy5qicslENSC1jFjvj8vnfDDjb5Z40aSUNg9UkYL
	 AfUfkjCtX7Bqg==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Oliver Mangold <oliver.mangold@pm.me>, Miguel Ojeda <ojeda@kernel.org>,
 Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>,
 Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn?= Roy Baron
 <bjorn3_gh@protonmail.com>,
 Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, Benno
 Lossin <lossin@kernel.org>, Danilo Krummrich <dakr@kernel.org>, Greg
 Kroah-Hartman <gregkh@linuxfoundation.org>, Dave Ertman
 <david.m.ertman@intel.com>, Ira Weiny <ira.weiny@intel.com>, Leon
 Romanovsky <leon@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard
 <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, David
 Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, Alexander
 Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>,
 Jan Kara <jack@suse.cz>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Viresh Kumar
 <vireshk@kernel.org>, Nishanth Menon <nm@ti.com>, Stephen Boyd
 <sboyd@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, Krzysztof
 =?utf-8?Q?Wilczy=C5=84ski?= <kwilczynski@kernel.org>, Asahi Lina
 <lina+kernel@asahilina.net>
Cc: rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-pm@vger.kernel.org, linux-pci@vger.kernel.org, Oliver Mangold
 <oliver.mangold@pm.me>
Subject: Re: [PATCH v12 0/4] New trait OwnableRefCounted for ARef<->Owned
 conversion.
In-Reply-To: <20251001-unique-ref-v12-0-fa5c31f0c0c4@pm.me>
References: <20251001-unique-ref-v12-0-fa5c31f0c0c4@pm.me>
Date: Thu, 30 Oct 2025 15:51:38 +0100
Message-ID: <87v7jw8mth.fsf@t14s.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Queue-Id: DD70E4001B
X-Rspamd-Server: rspam03
X-Stat-Signature: cigocnezoe7axrxq13rkkw3ryb8bq5rp
X-HE-Tag: 1761835913-89397
X-HE-Meta: U2FsdGVkX19UpW89lHQrxaECJQpbk7DEV43nYIDW8byiNgviQIznI/MWsoOxZX3foElsNjrbms1I78DgHvjtLJ72l2for5Bpakj7xtWpAMA+2RNFKSRNYwA7WleJRn0WlF0+DAPRnpZQMmLkGcExGgzrP+1RAxdw4wi5fTBjlvd8B6DuoI2emS68rq9iyCjGnWHhh0BsUZUi6I0OKe+nfekKZPEONxpwixJ1/h+WGCL7Tes1AnGmV+2iDjiiFrnnkS9d59qykN8nWRVXoFPpc4pu3QBdLxfIfbRE1Sn7wJmlUKns4XvDvYAuFNceIwROfgHllJD2AP3E4jGIVFOS3hhx9CX6swIXieo+Bcbo1KRbUfOG8ftJLLn1uvLzc0tvnj8AE9Dm6ouAlm0zKzfF5xIs03SvmatO2mh8TP1xVLV8BQexoFSnHbL10b7JHOstO8Eiqa9k0lzZMPlA3RdEA8l28yJkEWy5qSfGwSP2d+2/IPRmF9XZXhCT/NnfljFDvV93XMbk8Cq3c62OmPzKkelW4Y4kc5PAmd16FYG7kOisYLzeyzhf6KLRzHSi51GS5gvvEPXYAqyiYigVVtPul7ty6MDryYoAdQFg1ONEdqQ9INGqsDlH+6bP0WuQKb8SYpJ+fdOLIexaX9yK8cUv6hbaNUwq9aKWiOPVXPlV53YBvKftrtEBfSWhsNk2rN4pii5DZ72A/cRCB8iu12BOT3lbwFUqgRY/s6W2uJVTLWgfT44PiPvSKtZwRw67KvHXIQD0YzC8ZUXOzOUe3k4i5FtNV4uiUiBd9Ycj8LD0P0UuKCNa61dMptv2RwCftv+Pmv+hKvmiVOVVnxwqBNnGdGqK3y+xEIqAhEcn7yNS/6n4nnpB3il6r29zClz/x7GuSft2S+khL3qw+mo7yHKXyybqiub2Ft5fz9PRheAEaT3JHtjYGXFYPpBqGrn5fr8ZAMiyZ5kYTzKn3hT7OXH
 zjfl65vi
 zw7Mbc8A7nLF4UpKp5Gk6ji0W4CltmVrjzChkpRfhehXzAkFe9aoLUu+w3Tp5X7+an/uHsIi8YgzMBeDw5afY4O7HkiQqtmD20QBGv9Tk3Nee/R0qEegR59mscViXtEfY9nnVIJw3/o06rQBxZ3hrm2gGPEEru2ttD41ytJDVrby3HSsIIyGunDyXSJCfOxbgoGeuWzzAwRcKtybIPsZeNhsgowM+etQECc/U0n7PpXEwhU7FQIbejMa7pYekBl8rPaLHenmNff5QL9o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Oliver,
Oliver Mangold <oliver.mangold@pm.me> writes:

> This allows to convert between ARef<T> and Owned<T> by
> implementing the new trait OwnedRefCounted.
>
> This way we will have a shared/unique reference counting scheme
> for types with built-in refcounts in analogy to Arc/UniqueArc.
>
> Signed-off-by: Oliver Mangold <oliver.mangold@pm.me>

I rebased your series on top of v6.18-rc3 and pushed it here [1]. I also
added some commits with review feedback.

Best regards,
Andreas Hindborg

[1] https://github.com/metaspace/linux/tree/ownable-v12


