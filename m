Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7F4ACFC29A
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 18:36:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C3B26B0022; Fri, 21 Nov 2025 13:36:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09BF56B002F; Fri, 21 Nov 2025 13:36:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1AA46B0089; Fri, 21 Nov 2025 13:36:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E0E0C6B0022
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 13:36:40 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 94E064F121
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 18:36:40 +0000 (UTC)
X-FDA: 84135470160.22.E67F939
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id E9BD74000D
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 18:36:38 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=QEx6H1kx;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763750199;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OVr+23+Y4FDXkcZloV+7a0sszhj0dsWtyYoZGk6FN8E=;
	b=IL9sJpOaLHLkKEAGw0eCOhKJXDViBxHpGs8Bjog13MuVFsm2Ge/1tgQVjLmDtrUl4VR+51
	u2c+SfSFrhLFecjab4F8vAf6eOXVo8rWEcdRwRE4YddRpR2VZ+KSYY6fPCarrqxkQJgD32
	YjAmFpMtUbGPy/eNSRHRhHTjuyNwq3k=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=QEx6H1kx;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763750199; a=rsa-sha256;
	cv=none;
	b=qL2R7TGgxV/MxUGmjTlcFoqAPURz14oGTS9GdsWwr3bO7Wq5+7o0uz3ekPwmPgic53kUTR
	M5lN6LdWJj2xgbIIlsskf106kt823WvXyN4VEPTxrU94HlJpRKZmTbvanY/Kb00+CXbsad
	xyRYPIlTG3jf1NUIjhoABe9IQAsY+us=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 11AD660139;
	Fri, 21 Nov 2025 18:36:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0C2AC4CEF1;
	Fri, 21 Nov 2025 18:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763750197;
	bh=crGPPT0AtAuzG2UEVBlxUERhuPjW93cug8nah7uLwPI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=QEx6H1kx4LH2VEQuGtG4dDTBfQimoEx6dOPrEkpMfabhu8lvBwbefk1rGdOBtVACD
	 QZKA8vPhUokAEv0JJOZyDEHGcBf++sPmEabuLzPJH1etPYvKiGFWYCxM0l12ChfFsx
	 m1HWtmpBhooqID4D5faCmw1veUK4HRjgPAR6uS0U=
Date: Fri, 21 Nov 2025 10:36:36 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Chunyan Zhang <zhangchunyan@iscas.ac.cn>, Paul Walmsley
 <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, Rob
 Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>, linux-mm@kvack.org, Peter Xu
 <peterx@redhat.com>, Arnd Bergmann <arnd@arndb.de>, David Hildenbrand
 <david@redhat.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil
 Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Axel Rasmussen
 <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 linux-riscv@lists.infradead.org, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, devicetree@vger.kernel.org, Conor Dooley
 <conor@kernel.org>, Deepak Gupta <debug@rivosinc.com>, Ved Shanbhogue
 <ved@rivosinc.com>, linux-fsdevel@vger.kernel.org, Christian Brauner
 <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 linux-kernel@vger.kernel.org, Chunyan Zhang <zhang.lyra@gmail.com>
Subject: Re: [PATCH V15 1/6] mm: softdirty: Add
 pgtable_supports_soft_dirty()
Message-Id: <20251121103636.22321ceb37093370e59cb6e1@linux-foundation.org>
In-Reply-To: <dac6ddfe-773a-43d5-8f69-021b9ca4d24b@lucifer.local>
References: <20251113072806.795029-1-zhangchunyan@iscas.ac.cn>
	<20251113072806.795029-2-zhangchunyan@iscas.ac.cn>
	<dac6ddfe-773a-43d5-8f69-021b9ca4d24b@lucifer.local>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E9BD74000D
X-Stat-Signature: tye859q6fpknazibcud7656oqfhju1wp
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763750198-877571
X-HE-Meta: U2FsdGVkX18e2uWe34NfwK+NIvoDOo1mQiGsDLGcZDJGPKGuE3iqk7ML35ODn/gwE/RKjl+ZdrZ0x7wvdO4D/kZU5FWkJBzU942lV4eAOGJ9C9dgwT9eh66tYEvxrVF3LuZ7qGpk0i6mzeVmeus9scLoZHL6O2IZUQKlrDo1eldk5hHP8pXlKgl6Bas17e3GkOFxJ3Tt/x67iaGwSNt9mpvPYq8hkUzaiHFQJIASVpev0ylge3sm7msu2WEIMCTsJYh7q0OjJ0FyoMp/h3HXxsS5qZ+nNT0pft77C4+mV3lQCplFmg4vRYq29pUplRz04frXDti2TeuzKRC4JkE8tzwcxpjVesKUDq4g5AgtPreS+Y+iwr0k382hRYP770YiGf+a+KBuIG0YOeCby+rRMejIy87geLTbKAgU8C++nl5iefhfx1jlf7dThm39FXCkt/5l+Qt1xkKqyWNUiIrcxvVANPwb6E0/6cq/tmXvU9T08Owx2V6QQGoQoJ4j1vV9Nm6mA5GQlGjVOa/7t5Zmh1ZozjwZ6vE6zT8UVRButlGXAK0Qn86uol1zjzUG3k3k1QajV7R/w2Itom06so4SB1gE4WyS15+Ic4BxvMWO0cx6m8K8XvCbCzFWBAT09oHPsI1hslj5Z8fVb3s2e+00QMVWGmdjVYqTLEeX1zGMEm2NrOmVFn5mjOal+UtuqVEC/6rZvPBVRMYimCzTsXLhqUWOoLLtmVVyrjBHpAO268aiCJhRfatABA7kYHyICtdUOQoEs0d8oP7PSj11mIsSmSkUAZ/Ac8m0FZp/mITDHqcpEdfYFblSBGCdSkf383iBSxVZwOuxiaILMRTyWbiVz0rzZJUDgAbhr6L7rZU/sv/7WkoG5BS9nL3KGlt1QC5nbbYp/NkgXBFSl2PAKaEGPrkfuWMSyjH9EFwcLkzqqoZwPnD91o65V++5GHkLd2NWsFZQRI7n7VS3bPdUBRb
 mQzDgEfE
 ZTDyP8QF/DLAgZDVkO6KFTNHV1RQCmpFKuknuYor74ibzz9nSFDygCdfrvcJglzbFVE+dgOCzI4Cpx1H7fooo+6AED85hjXuJj17qPO415JSDnVRhWsbjG7XF3WdW7uyb5yfYPclefYiGl+esxKFjZX+F8qAzH5+xeDyz5FL1Zvfcr/KKSuNfyO+nopIA+SaIcrgIrAYqtNA/fSlpMVj1DsFIuQTCW7bd1pjgku/Y45VDDVV4/RdB4jwab+9lU51ipM5FTYMpKHRRz09O2S/7CoxlKQ6t+RBU3+z6QXvzTNLhjXH+BXrUeDEy3usy81mV8yENQhHRTGNUFWJgIBw+6lL8MN5E3FdVSvpvGBEM3RhenmkfL8MwytSE9KXVcJaFe9/C36IBFyFv9Rk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 21 Nov 2025 16:57:17 +0000 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:

> This breaks the VMA tests. Don't worry it's not exactly an obvious thing.
> 
> You can test this via:
> 
> $ cd tools/testing/vma
> $ make && ./vma
> 
> (Currently we also have another breakage too which I'll chase up separately.)
> 
> Andrew - Could we simply apply the attached fix-patch?
> 
> I know this is in mm-stable now so ugh maybe we'll have some commits where VMA
> tests are broken (not nice for bisection), but anyway we need to fix this even
> so even if it has to be a follow up patch.

"mm: softdirty: add pgtable_supports_soft_dirty()" is still in
mm-unstable so all is good.


