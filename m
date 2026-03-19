Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6AC0109192F
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 23:31:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BCC66B04BE; Thu, 19 Mar 2026 19:31:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5701D6B04C2; Thu, 19 Mar 2026 19:31:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 498516B04C4; Thu, 19 Mar 2026 19:31:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3702B6B04BE
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 19:31:15 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DF6FC1B88D9
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 23:31:14 +0000 (UTC)
X-FDA: 84564410868.27.75EB957
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 64CEC1A0002
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 23:31:13 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nLw1gwv9;
	spf=pass (imf19.hostedemail.com: domain of kuba@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kuba@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773963073;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xg7Gj/nZvAEVKv01J9IES6ff2Gi4XAOpiJz8fQL4rjU=;
	b=RhEDHe0RaqTObo7CkZRMSF7fceOPRYzkKCBuOf4BYaLMSWV38ecumj6doJbXDH/5YElKib
	OAmNnJG1mX7NhT7B1AlfoyHulAVqTYhd6o0SweBDduZlmbRBaDFcFA96oLxfyQNW6WvvsP
	uTW3Bnb+haek83AHPQgGAljg7ckyiuI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nLw1gwv9;
	spf=pass (imf19.hostedemail.com: domain of kuba@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kuba@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773963073; a=rsa-sha256;
	cv=none;
	b=MN9Tp+h1uTEMnaqXqKRW4hzQOrv/rQGeDdHu5c5djz/eGflTlfOyyVYJ2DhF8qvonC89Po
	LLpQgsSYhRYvgcqpk0FOxkJ9gS8UX3It7wpI9UBLPUN5+28Dl9EtrzgN0r3/2UNzchJ5gP
	7tZVONVdQJWmFhbmD31CuL8Bm6N014E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4FA9C40200;
	Thu, 19 Mar 2026 23:31:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E51CC2BC9E;
	Thu, 19 Mar 2026 23:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773963072;
	bh=rdU75h+RxugSStenO8TGm97kuv724uVI0/nLR8CJmR0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=nLw1gwv9tBT290w5jk0KbmKXTtHS+wFK5PEuLPVIIeE5M5dBEG03kGQsoiL87QBpH
	 ot2ATfWWmGjXFe0NHztg+vofWw82idx6nD6xKKtqJzi1Xvn84+dPnoOWLd3zJPiABm
	 A5YYxSl1Ph7QBu11zsoDNeHOs2f0i83XWfLYBQxFdbBor8b0yj7DGD7Z5Sjo5szxul
	 blGBHBSyeM5GyC2VI/b8RoA4AIT3Eer4DPLX8MRKtgNeVS5AOJ5Y/l08W1Veko7ByH
	 j/kZjzEkdu8Wy+vw1hkk/1rzqYHTjzf5AwWZbWvJ1MFf9JJyenyylMCD9HEV5rquuo
	 yHos+ltsfNzNQ==
Date: Thu, 19 Mar 2026 16:31:09 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Dragos Tatulea <dtatulea@nvidia.com>
Cc: Jesper Dangaard Brouer <hawk@kernel.org>, Byungchul Park
 <byungchul@sk.com>, linux-mm@kvack.org, akpm@linux-foundation.org,
 netdev@vger.kernel.org, Mina Almasry <almasrymina@google.com>, Toke Hoiland
 Jorgensen <toke@redhat.com>, linux-kernel@vger.kernel.org,
 kernel_team@skhynix.com, harry.yoo@oracle.com, ast@kernel.org,
 daniel@iogearbox.net, davem@davemloft.net, john.fastabend@gmail.com,
 sdf@fomichev.me, saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com,
 mbloch@nvidia.com, andrew+netdev@lunn.ch, edumazet@google.com,
 pabeni@redhat.com, david@redhat.com, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, horms@kernel.org, jackmanb@google.com,
 hannes@cmpxchg.org, ziy@nvidia.com, ilias.apalodimas@linaro.org,
 willy@infradead.org, brauner@kernel.org, kas@kernel.org, yuzhao@google.com,
 usamaarif642@gmail.com, baolin.wang@linux.alibaba.com,
 asml.silence@gmail.com, bpf@vger.kernel.org, linux-rdma@vger.kernel.org,
 sfr@canb.auug.org.au, dw@davidwei.uk, ap420073@gmail.com
Subject: Re: [PATCH v5] mm: introduce a new page type for page pool in page
 type
Message-ID: <20260319163109.58511b70@kernel.org>
In-Reply-To: <05c0db9b-c92f-4758-a356-e035a174b5dd@nvidia.com>
References: <20260316222901.GA59948@system.software.com>
	<20260316223113.20097-1-byungchul@sk.com>
	<ebd00055-d4aa-4612-8bf3-ef0a308512f8@kernel.org>
	<05c0db9b-c92f-4758-a356-e035a174b5dd@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 64CEC1A0002
X-Stat-Signature: sbyk5uqfdy14gcjfdayw8u13cpiy6fst
X-Rspam-User: 
X-HE-Tag: 1773963073-608500
X-HE-Meta: U2FsdGVkX1+hGs7J4VP85+EWcN8NCevyiRyqWYvuquxnorjxo7H9zEgSyKbOpc9ijXazJHl8mLGJ6Dqw2cgc/RMEdYlgViQmIKNbcrLtBVPAP7Z1OdWFH4lvz63yUzxc9iIweRzpcRnZlu5H4mZfCeWi9FiRlzHlcu063MZlqLpUfCsiii1PDXVPCSXDNGL4/0N5H9l1bUASQCNFDUajasebDj91wkUR3bXY9AoaOoG2C60SoQbsNZ86SPyJF8GtjmaBj15lZHQ7wXlj0FCSxw/TdINM5T5v067nv2O9VbluKA54qXh3YCz9yETmReIwK8r6QunXweKqUqcJvKjxIo0h9zAVL54K+SkvMwcvTNMjvOaPVo3pFwaKb3/wF9dMapu92Lbsbprv8ieluH+FBc2DUrOgQVT7oTU049iu0cUZpqzv+L+ObudLSMC8nIFjPibIzIkyH6WllVDx0o1pb0hts+eeAgqo8wYgBfeFrmePHWg7Sbr43Qv+Sv0WrlM29ltY1GofhuGYjLaPPQ7vpaSQraj4dOq6ffAb6D4Tk4sBBVPL+DqGcD8L26SjC6tpQ2cYsMiPoCIa6TLBdbN7i49e8NkrLO/1w67xAs6181kIacQPnsk3cLnSxXk4DLlr4DzKuphdMs0xL3yYa9o+KXpBWzee4A0q0nRPS4qfVuNEQP2dDPKbowoq2cwuoh5sdUeXUzAFFngCvlG7XU2Jx+n/bjjzMwvmmhnXhi+MzkVtqs2CffpiBloDbHO6F26A6ro61M4u81dte0rqVPMy02+k+Pd2eUClvk0welTz4q75Jzx1S/jD5QbyAb4Fp21hN58xpVbUdObEGVNoW05CQ9fzdfpct0o5RmBfYbMTP72x3rWd/x53+suXZ11j06db99JfhWN5NLH6WZvlFQpvxiIb1iARnzrEWJrdlpYbwog6hCV17F8r/h22AnD211kLjb3JnGj1x6JYSTZ7YkF
 qHjt1SYb
 srD7g2PLe0SZwg49qqDkd5wTohpApte8GTllh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 17 Mar 2026 12:06:51 +0100 Dragos Tatulea wrote:
> > Should we handle this more gracefully here? (release pp resources)
> >   
> Releasing of a leaked page_pool page could lead to many harder to track
> side-effects further down the line. Isn't it better to simply let the
> page in a leaked state?

+1 that'd also be my intuition.

