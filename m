Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7ACFDCCF9F8
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 15:46:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D813528000B; Thu, 30 Oct 2025 11:46:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D58FE280003; Thu, 30 Oct 2025 11:46:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C966C28000B; Thu, 30 Oct 2025 11:46:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B7F95280003
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 11:46:35 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 845AD563A0
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 15:46:35 +0000 (UTC)
X-FDA: 84055207950.16.45B18A9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id A468A40012
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 15:46:33 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=o1SzNsdp;
	spf=pass (imf01.hostedemail.com: domain of dakr@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761839193;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+aCqPI9l9GA4fjyj7IKv+jGG9vbmuWle66wv3J/98NA=;
	b=4ffs3w+7+eQuUxg+o9fPTGDnwlqT+VfxXXDH+Ay+4qY0POSev48peXU/yNpnAcANctLi9c
	R0R4DZYRLz/ORZUJrvyOXPgJRfxlzlCmGmwuE900nylyb0pXFEyHGE7OZs67Ax9vJtBdTP
	pS3iRzyobEdfTMsVkJ8mvTxY8hLeJdI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=o1SzNsdp;
	spf=pass (imf01.hostedemail.com: domain of dakr@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761839193; a=rsa-sha256;
	cv=none;
	b=b68hx3Wu7YLxyoygex7UFx7hgu3vziOVWDACCAP3onMxiJqsCwQ0pLVvJ0sSeHPdyP4Ggv
	SIx9RJDR3/n5o/70pb9EPMAArpGlbkY5KunQqcGXY8NHBzrRZ7Zu1ZiqIUdwhIa82W8B02
	0lp7zQ345t9vltyOBMrvCzSac49tDc8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A325B41AD1;
	Thu, 30 Oct 2025 15:46:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACFF2C4CEFF;
	Thu, 30 Oct 2025 15:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761839192;
	bh=O/MqUXCRBsW16T+2gZ3rWCpjPcBmGWYAl4TCaK+lbCg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=o1SzNsdp5hbJDctJABv9DD+krmMc+E7r+PzqKq+suUwPLPF2TnoDV97v51iZBhQQF
	 edKwc1fRvaceCyNvbBbLZdP7MIEs0B4Mz2XmTMyL1k2yIlYW7kymvud3qbDnatsq31
	 rGyz5mZOqxo94hgiBfIipp7MThtcOqLAY4AziBY1Ui61TZedHbo3buIszUfISRrUAv
	 CdxUoLHzvsg5zhcm0JeesYZSAtHIpYBkK3AwdMVDIWu72EekccXSOERPt3oyEwmiWL
	 +we2VxkBPIaV/T5/KRbYxQUsCqvk3nZFLhtYJ70Pofduob5Y8MTbffjVNLN5IdRqgS
	 a+CdDxqxwa/Qw==
Message-ID: <0fcabf65-e24e-4f7b-9217-15344c926dee@kernel.org>
Date: Thu, 30 Oct 2025 16:46:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 2/4] `AlwaysRefCounted` is renamed to `RefCounted`.
To: Oliver Mangold <oliver.mangold@pm.me>, Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>,
 Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, Andreas Hindborg <a.hindborg@kernel.org>,
 Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
 Benno Lossin <lossin@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Dave Ertman <david.m.ertman@intel.com>, Ira Weiny <ira.weiny@intel.com>,
 Leon Romanovsky <leon@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Viresh Kumar <vireshk@kernel.org>, Nishanth Menon <nm@ti.com>,
 Stephen Boyd <sboyd@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
 =?UTF-8?Q?Krzysztof_Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
 Asahi Lina <lina+kernel@asahilina.net>, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-pm@vger.kernel.org, linux-pci@vger.kernel.org
References: <20251001-unique-ref-v12-0-fa5c31f0c0c4@pm.me>
 <20251001-unique-ref-v12-2-fa5c31f0c0c4@pm.me>
From: Danilo Krummrich <dakr@kernel.org>
Content-Language: en-US
In-Reply-To: <20251001-unique-ref-v12-2-fa5c31f0c0c4@pm.me>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: jgk84q9fyxgpznqioco77qjcoduwfe5o
X-Rspamd-Queue-Id: A468A40012
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761839193-370987
X-HE-Meta: U2FsdGVkX1/HQhow80o3cnhPjNE46+PoYJzofZRXWlHhCePwxlNotiwdUgiP4Ji8btnJuTM8exdus6AhsUUG/D2oHYRtbo9aZvEiBzJkc3ZwzxV3zm2zN/gR5xcI+WA0RIGcYyxC7Ou3g/zJVLcrSVGHq4DCCJwRvTTsjojwB2uzvU/dJ3aVGbOb6v1LfocOJRPX3r1pXa6UvWgTD8bwn1uItQovzVUo2gIBwbzWNbSzbInT3QHJppIuAvGSp+pIVbGbdu6Jz3ePlw+MQzBOvq3VzlqIThMm7Q9XDW4tNrEOUOJNApz4oxGcUGvrb1k1JWCxeAIGzdgxrzJuwQc+u29eQ7VKuZU1re9luld2qgo3WiuDUlrwnkRZKKPIIT+UIo3RgFj2AqOFPLYakROxE160QavhmkJ+Okb7Mk1tGMPFn1eEqY7uraKOnZaBye44PlIzUQV2tG7Bc456hIKLKiFhv+pxgO+MRooH6KHFIXOUEYUQBxxnoByKSMKByTfBEdMIJV7MFfbz+aEml0CaF/d8zHnG7ea5wryjJkC7TYON3P/Op3EMscqZ9FumJz1pXrZ7jKu41Gw5Runh1sm9Rtx2VXeyhysORdDPzNadcwhTAXJS+KDTFU1L19ws3m23Wy4RwF3F5NsBctdKLsyNt6Fb8+y7umkumS2IxSi6nXbTzSWfN4e8ETFGsnJYPwFfHSf+7hz//17CcC1qkRKIhYo/YTGShqKv+veiHW9YctKJAx4G0YoWbU8EO9sVsAFbkLun/bAZ1HsiHTiWkS2tqA8q/BynVgxnwlkUtG8z1A2X2Ae0ddxStN5GskQwMT2o5H/gUTCLKiwYKij3snlecTei1ETZov2aVj/a7gUnFRKUFvgoWlC89TS1/5GbnWwJDkAPH+BlXueBqOoKj2bR+FaOEl+wn/tqLlECQQbpxEzaxFlHHEYSkpIWXMQNQcFE8HunRHaX3kKLKEXy4dG
 naVe3RIg
 mnCsro7DNuqZJFgF+vAsbhQ+zrtcQYMcqQa88B8ipfkWtX/VTBQvZxO3JyLtQuJtggj6aC9j7iroMUQMUnpCy1j7rYPyFdZKSCgMaSEZNigKD5L38d213iQu0Ef+X+/FtmMrf0CWm5/RTlzzK7YS8Xs38bo+N9H6Wo2AKkhlWTSfKdmZfD/Yi0l6X960qvj2nXtXtXz+GAt9iCckZdzruqQC0DyrcnaGRTMKFtxvBO+UazB9M0zeNU1uYnrIMeS4SHICKQikmuwwNmXat5vrEbNo7zlwLf3H3V2W24qN73z3sW8FPQeFbnJvpVKAs4Nap3+WxcFieXD1pi4pEq9xUd/M87CzIrzfzNnqTZwGMy14V+ZI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/1/25 11:03 AM, Oliver Mangold wrote:
>  rust/kernel/auxiliary.rs        |  7 +++++-
>  rust/kernel/device.rs           |  9 ++++++--
>  rust/kernel/device/property.rs  |  7 +++++-
>  rust/kernel/drm/device.rs       |  9 ++++++--
>  rust/kernel/drm/gem/mod.rs      |  7 +++++-
>  rust/kernel/pci.rs              |  7 +++++-
>  rust/kernel/platform.rs         |  7 +++++-

Acked-by: Danilo Krummrich <dakr@kernel.org>

@Miguel: Please expect a minor conflict with the drm-rust tree for the DRM GEM
changes.

