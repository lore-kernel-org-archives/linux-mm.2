Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA41EE9D416
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 16:47:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56F406B0098; Wed,  4 Feb 2026 11:47:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 546DC6B009B; Wed,  4 Feb 2026 11:47:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 470456B009F; Wed,  4 Feb 2026 11:47:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 318C86B0098
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 11:47:03 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 066191B1A93
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 16:47:03 +0000 (UTC)
X-FDA: 84407353926.20.C3DFA78
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 515DE2000F
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 16:47:01 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZHj8q1Uc;
	spf=pass (imf03.hostedemail.com: domain of dakr@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770223621;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dy73/9OQI/HuBvsd+ptSVtFrF/SFQ/zEvH4RIO0j4i4=;
	b=U9uiCWjiBySGlFqwyAm9fZvTnCy2PdnlmsQbbAxvqkltw6uyhRGCr+nA7026V7rYIwE6YC
	TVaFIi0hQKq1olEkM5QKB/X28lk1RbsfCt+BlX06cCtsf+hHp7hPgw6abTS9QqGfkuXHgZ
	YbCrus11fHKBc1qU/aUSuASn+Mj0b7c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770223621; a=rsa-sha256;
	cv=none;
	b=8qvmi0Z9YxY9nJSBUu30bAifDc1EKMsjxh6wCSUV4hRnx5lZmjtL9bSFMikjLr6sY9YmfL
	/k86whz5P4OXKP2jo/RigR4uQOfrDhYF/W+3mz8oyZWauxfP7To1na0f2geTTRVfD3GZqR
	QtwIW78P0gJbzIVDb2sUR4valajWCa8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZHj8q1Uc;
	spf=pass (imf03.hostedemail.com: domain of dakr@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2BC5240E19;
	Wed,  4 Feb 2026 16:47:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF418C4CEF7;
	Wed,  4 Feb 2026 16:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770223620;
	bh=dy73/9OQI/HuBvsd+ptSVtFrF/SFQ/zEvH4RIO0j4i4=;
	h=Date:To:From:Subject:Cc:References:In-Reply-To:From;
	b=ZHj8q1Ucvt7QcaZcn9QuPYACGDPfU/YL82+e6kQIaszjDn8/K3Lk25/ytj8Malksx
	 QTrROJpGVUsMkMWTzjQvp0wcUGKl69dlGdw+uM4ZXkcku66CUCCFf+JntNkoa9XeFK
	 UBAoEJloaJHzf8XjFtFKSgZDr+rjjdpxj021cT2FEEhwdvxmV1QnS69elAgBlCG2S1
	 5VpdKtuK+x95jkiRP0Q0olnVlaCNxNMiWvM9N5rJSdpQVInfdYkjh/kMwVzxggH0vt
	 xi4ko64jYM5R0Fh8vdICZWmXXV6iTywKSpHzFCGMppUp7E+ZJ8jy9VLrS1L5oDN6Sy
	 z8aQSzU00WK2A==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 04 Feb 2026 17:46:51 +0100
Message-Id: <DG6BWC5SOHUG.2K1ZXGYNVB69V@kernel.org>
To: "Andreas Hindborg" <a.hindborg@kernel.org>
From: "Danilo Krummrich" <dakr@kernel.org>
Subject: Re: [PATCH v14 1/9] rust: types: Add Ownable/Owned types
Cc: "Miguel Ojeda" <ojeda@kernel.org>, "Boqun Feng" <boqun.feng@gmail.com>,
 "Gary Guo" <gary@garyguo.net>, =?utf-8?q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, "Benno Lossin" <lossin@kernel.org>, "Alice
 Ryhl" <aliceryhl@google.com>, "Trevor Gross" <tmgross@umich.edu>, "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>, "Dave Ertman"
 <david.m.ertman@intel.com>, "Ira Weiny" <ira.weiny@intel.com>, "Leon
 Romanovsky" <leon@kernel.org>, "Paul Moore" <paul@paul-moore.com>, "Serge
 Hallyn" <sergeh@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>,
 "David Airlie" <airlied@gmail.com>, "Simona Vetter" <simona@ffwll.ch>,
 "Alexander Viro" <viro@zeniv.linux.org.uk>, "Christian Brauner"
 <brauner@kernel.org>, "Jan Kara" <jack@suse.cz>, "Igor Korotin"
 <igor.korotin.linux@gmail.com>, "Daniel Almeida"
 <daniel.almeida@collabora.com>, "Lorenzo Stoakes"
 <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 "Viresh Kumar" <vireshk@kernel.org>, "Nishanth Menon" <nm@ti.com>, "Stephen
 Boyd" <sboyd@kernel.org>, "Bjorn Helgaas" <bhelgaas@google.com>,
 =?utf-8?q?Krzysztof_Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
 <linux-kernel@vger.kernel.org>, <rust-for-linux@vger.kernel.org>,
 <linux-block@vger.kernel.org>, <linux-security-module@vger.kernel.org>,
 <dri-devel@lists.freedesktop.org>, <linux-fsdevel@vger.kernel.org>,
 <linux-mm@kvack.org>, <linux-pm@vger.kernel.org>,
 <linux-pci@vger.kernel.org>, "Asahi Lina" <lina+kernel@asahilina.net>
References: <20260204-unique-ref-v14-0-17cb29ebacbb@kernel.org>
 <20260204-unique-ref-v14-1-17cb29ebacbb@kernel.org>
 <7uftlTZxNVxMw7VNqETbf9dBIWLrQ1Px16pM3qnAcc6FPgQj-ERdWfAACc5aDSAdeHM5lLTdSBZYkcOIgu7mWA==@protonmail.internalid> <DG6AIA0QK77C.EKG7X4NBEJ00@kernel.org> <87fr7gpk6d.fsf@t14s.mail-host-address-is-not-set>
In-Reply-To: <87fr7gpk6d.fsf@t14s.mail-host-address-is-not-set>
X-Rspamd-Queue-Id: 515DE2000F
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: u6r1tghgznkuq55wbe5kix3c1uam6qbe
X-HE-Tag: 1770223621-891120
X-HE-Meta: U2FsdGVkX1/56UVSETFQMhCXoviSYlaH4WsT/kGILVgDTUKU37LczN1ATV0zPqY84eNxXxotIGOXS1gfg9N8o7Ua1nstLdkK0wV5m/yzrxruiPmYKmGmDLtrgzSGaoc0TTZj7bowKgRnOxqEihHwcV9MFdcFrj0L39IwxgBNosPSNDlK+5cLw7koqk6NqjL37bXLxUMWvusw5QpXorDyJn5/H2gvHIWzOfsh9k9hhRE/EOvmKBS1RgLR0I0eV+aanrTyH58ZYl1e2d6XF+nH7h3imVZ6jwkgueKxTdu6tQAekbX1pUZJVD6szu9P+k0ZfckRnIcCpuz6s2RrS+1i2aVmWi71ZuQduVkU71m1LufO46NqQj9CeWLjVaWNBZJHRmH2CHzL9uLLSOSNm/filLV+qAt4u4XmC5zANQV4lctHnByjz9fzAiiVF5MjDPOH6ERH586/XGTlHgZrHBUVTa92yEcspuToZ7D9rMOgJIdtf94C0jEn7U3m10EI8FKrZ6CGN14fhyl6GY8wVoQHzMoSsLsPyqCC1esKDLjDqHPzJKVVvaOVFwZc43oLETzw+/wQ6tHi90DKvWLCE4Ge3a5Eb3zvkplv3r+tYxQnF5sjS2xZpA1hBynH5AkwvkVzdKmhs4HZQQjFbGuxIA1HjjRdL+LhbkllbuFr+TFqvn8NhuuVgwBGq/FEK6uBSl9AJCrZIOiJn/Eu8WVOQWFDRhqCyMEsyzQEgi+Wgob/ajFEfh7BfK7FH6t+/q9Ez+IJrS10k1jfTNH1uJCkGjObkEt3oetwLTlwfCz+h8Rm+FQ9OWaLmfzTqwUDO8Zi2jjU9Xl0uatI9bbvBdGq+7ztlmcSa/9oEMWjFV6h6M9P2Wv56AEJcS3h36mhuDeftQFW1ZSo3Y4WuqGv0GacNEIIwBdaqftjwvq8Xt0Z4HZUb722Zm/Cnp4HPHewnxK8yMYbHF0SjOopb5jg0g86EkQ
 iYPBMpgr
 9dDYP+TPhe8agi3O1tOEeAP9EFDquQ5E2jz9v24Cy4hGfzsADSPmWMaIfcSy2EbuCFMCpLUtDlrQX8S8a9MbyJQ/zSWdRaXr5UiiWPnNNPNnMcrb18u1OAy9P322GXpj2L47UdWsFgGia0T4NA/Ot+SnDzL25fCySSw2fb1GLf/8PSOtQbc3P6KmzmLZx2DuK22yTc1AXzBulESQc9gh3Dthx1zqLtslDzKvZFFsLRjFXncNnWNSFCajSPshjiCbSnFggQMsu6d0ht8h7Sw63snLCGu19ofisAwdo4Uu6k9fTVesJYt0gKvWM7UJf15r1PAEYqjS319d/4FTTsBDFLeAJepgzzbErBFZcC5CA/1JCe8Cge6nYop5My/tq1xMLdjtb
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed Feb 4, 2026 at 5:06 PM CET, Andreas Hindborg wrote:
> It is my understanding that the SoB needs confirmation from the author
> if the code was changed. I changed the code and did not want to bother
> the original author, because it is my understanding they do not wish to
> be contacted. I did not want to misrepresent the original author, and so
> I did not change the "From:" line.

Frankly, I don't know what's the correct thing to do in this case; maybe th=
e
correct thing is to just keep the SoB, but list all the changes that have b=
een
made.

Technically, the same thing is common practice when maintainers (including
myself) apply (minor) changes to a patch when applying them to their tree.

> How would you prefer to account for the work by Abdiel and Boqun?

I mean, I don't have a preference and if I would have one, it wouldn't be
relevant. :) I just wanted to bring it up since the very first version was =
sent
by the two of them. So, I think we should just ask.

