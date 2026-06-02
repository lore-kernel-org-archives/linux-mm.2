Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CB36CD6E57
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 13:27:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD5EF6B03B2; Tue,  2 Jun 2026 09:27:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DADA76B03B3; Tue,  2 Jun 2026 09:27:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEA2A6B03B4; Tue,  2 Jun 2026 09:27:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B8E356B03B2
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 09:27:04 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5B24412094F
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 13:27:04 +0000 (UTC)
X-FDA: 84835048368.17.943C27E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id B1464100012
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 13:27:02 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aQpTY9VH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780406822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jDYuIiMp6Chnq4RBMMD2AUtJq7UZmNqeyupdNNiSu2A=;
	b=3+Of1OmoqG/CKP+hF6NjERl1sa2aLKuhFS/BoIATF+bujgIKNeEoiOebKzJxsytPPww4Lp
	yBtXGi7xkmBCB+rNhU34wLwV/OjuZ8kKEAdfJx5kIEQYvnlkQv6Y59oiZNwtwzOac92HcV
	YvHyi8POmD/gKIEp+y7IXmZSBeFwonw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aQpTY9VH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780406822;
	b=yqjrbbLNSPejwWPkJ0gNyEClSfrv9Byost7ecfoEcajgK9f3i3Cf2ym+99wAmD//x3WMDh
	Og9JgB+sqrCNT3QIVxaP93wcxDKYxzviJ8IQSbBpulDpm4dqsSXF9vjKKtlx+KL1iaCDW9
	XPMNa5NkJmRwEQD/hT8GbHrLAEordvA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9BCFA40773;
	Tue,  2 Jun 2026 13:27:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0343D1F00893;
	Tue,  2 Jun 2026 13:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780406821;
	bh=jDYuIiMp6Chnq4RBMMD2AUtJq7UZmNqeyupdNNiSu2A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aQpTY9VHX4T4J7jVj7tgMLyJNTiV8DZu/GZ4MW2frn6pCBV+G01IPCePo63Fwba3n
	 96KGNF8n72ZZp+hRY73dn7NOmUfyk+S7tvqnl+hzFff+nF5gBWvTWnZ98J3+B/0kA2
	 vVUBxkJWY0eQ9gGZsAino0QwS0UAumjbmtm7p6XBxZaMFRiNYrYQ9SLgSr8GClatpJ
	 KAR1L7bH7eueZYFJUtpJxPSVPe1oL+CL6hcBqheNvCBly/hgWHzidArMAPmyzEDKO5
	 rYzBlx0FnEEEH0BES5JOkPoTFvOkon+hW8r2XRaQ47JHgLxKyUC+L6jry+iygkiLLI
	 Yc7N8h6Vys84w==
Date: Tue, 2 Jun 2026 15:26:55 +0200
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Borislav Petkov <bp@alien8.de>, Karsten Desler <kdesler@soohrt.org>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] arch,x86: Skip setting align_offset for hugetlb mappings
Message-ID: <ah7aHzpPnGewsb5L@localhost.localdomain>
References: <20260601125015.216110-1-osalvador@suse.de>
 <53b599ef-0f16-44d9-bfda-a5a751649193@intel.com>
 <ah5j3hYpBN4Esl8h@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ah5j3hYpBN4Esl8h@localhost.localdomain>
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: 9gnj6w7c1yd5sjr4azn54x73xp6grsrm
X-Rspamd-Queue-Id: B1464100012
X-HE-Tag: 1780406822-283701
X-HE-Meta: U2FsdGVkX1/V5hqcU5pb8+P3ufYhfR+zGrUljkHL6fTZrgDXvNqvVSDJUOS33GoXHJWEP8C1fYISQbbPstZ6KT3haL+T0pLsogZPNVvANAT3433PYilXZAlOL927pl4KrOFyEBkbmM1xe7H7EupFKtDq351cJaukbjHV10UkzmPWKh3X1wserBq4tBPo3hxmcRDydBGwJ6OVi63YmZuCdXuJBs1zfwvN0y5mTaRuo1kXodLxwzDTRdmFvCMHQ8Bb45eQloqcNm5jaYxtrQnhCaC1c2Zmj+le82BnvZL/FFLGZ+gbc2qNAWs0cf6AQFVvhkP8IJEdc6LuCY/dtbn+BLg63PZ2ySIyRDg1zipDNWorHhqBT3KEi+LmRT9FnluH4EreTLyU8ENT7rvfT3/98v6kydxx6vIhg9bfGipryo+aB6Bq5ls2rm+pqbD/pRYhQWwaX+riiTEtMNwG+eoYPQ/Eu1v9TEo+gY4H8cHEcmFTCnD8SNOiwjwxrbGlC2PfaQU11ApYHGjBDKOGqpk5+PrVbEDzfgQao263itcSUKO9cCvAocKY/bP1YwzEyx0cyztwJpkmpJsSECewgwSr2eXcCIfe+Hay3VLNw0jcZjvqFGCYF/L0pJgy8sN6qrXE/J5JFTXj07li8oANSLhtCXiVGSe/xbgJ8hTYBsjMGwhlAyt0N0cYAknkKdAXJDtF8u4czfOqShtG57FQjE/x7HEny8MUWYMXOWSJcjKjc+AMWor+QjJEwPnOyt50qzReGP3siSLw6s2rqoDEyHMUuwAU3hAQrZR96njitXGEOxu+IEgZ4RKkFDItUZLj17R7FRepWLZYMvgPIoAHHP/S/vzl861TBGaNfG+7c1y6xkCaKlO5rl6NWp0QtsLOeghpc/ymI/GRzIEN2qsLE6leZxvYwvy1DKYQUHQsMtawEhOW24j63eFr+n3wCsOgapl57RNSFCBrcXXQjlcatXI
 YTQL/Jso
 eHbZFuKS/D+yGeVROsrknSBaCumrpPUZ0CqCC8wJ8hNEoHF+PXFi6g75GXoGcrnwwoQdtJCGczKWt6R0FdOH7LgwwlsKPqUgboKSGqysDJDRLiYmQW70RpRIRqn9JyqKgPf0l/L3btYlt371zuGxwYY6BKXjwoCHPiro/yBO9lWrFm1evf/4u78p1BKNRvgn45PtHa8CmMXMJBuaA+imyX7Rmp3M4KxrcwEDp2SPmOfuVZzacmf1ENghWUT7nkJnoYlaFctcrzvZXa9HtNjuwQHqglMLTi+59LL9bZXB+j382FxH6xPgZE2x0xw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 02, 2026 at 07:02:22AM +0200, Oscar Salvador (SUSE) wrote:
> Sure, as I already said I was not happy with the fix either, was just an
> attempt to address the regression quicker.
> Having said that, and proven that you are not happy either, let me take
> the long(er) road and come up with a proper fix for everyone, so no more
> hacks on arch level are needed.

Alright, I do have something on the works already, just need to test
it more carefully and will post it.



-- 
Oscar Salvador
SUSE Labs

