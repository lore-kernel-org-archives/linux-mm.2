Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48BB8C87FD1
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 08:08:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2EA08E0009; Wed,  6 Aug 2025 04:08:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E06C28E0001; Wed,  6 Aug 2025 04:08:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1C958E0009; Wed,  6 Aug 2025 04:08:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C1A238E0001
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 04:08:24 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 70E37135D70
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 08:08:24 +0000 (UTC)
X-FDA: 83745605328.11.4111C0D
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3016B4000D
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 08:08:21 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=EQoR+Q5j;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=z6cLcPD0;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=EQoR+Q5j;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=z6cLcPD0;
	spf=pass (imf04.hostedemail.com: domain of jdelvare@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=jdelvare@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754467702;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Vfa8JIicem/4yRlMM9YoM8phNgRBkXiHyLqwlpPMG6M=;
	b=LkLJaQM70pgrcsx4HEtTGz0mLWfEZU/VSUy3qdg7De3LIcQY6FXHc/YFPhtJ4CJlJ5iw2K
	bVOMSVyYBnFODbL6ZqFjrJUllcxW9yveCU15+v/Y9pMOXxRbyAHfPeasQH5+Lw43jpwq1q
	PD6FeBzni1ZaIIBoXN+eugL1zPrGw3o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754467702; a=rsa-sha256;
	cv=none;
	b=UUp/7tyNw6CzJLSYjT5F5PdsYPcRahV6uFXsFOSikHENxxVvfoOTbF0vfxQeRfzmf9AR93
	x0UEtYM4xsRn+58OnNhrEfHrxwXe1rIDl/vs6WlI4f2WVoHBO+Qpgz+slauuHghe42fIRn
	iAR7Ycn5BMsjG9VjfdUmr++R1Vaine8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=EQoR+Q5j;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=z6cLcPD0;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=EQoR+Q5j;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=z6cLcPD0;
	spf=pass (imf04.hostedemail.com: domain of jdelvare@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=jdelvare@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 923B621744;
	Wed,  6 Aug 2025 08:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1754467700; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Vfa8JIicem/4yRlMM9YoM8phNgRBkXiHyLqwlpPMG6M=;
	b=EQoR+Q5joYedumVFSqyS7oIiKTHKJCtk3Wmw76w/vc6B8VPbCBnsU9FHZpfNlZmTDif8v5
	RjoHrTlxZ0NaB9awPBie7Pficxqx1r7ce2rchaJ/YiHHc50rVh16Fif8++cHHVkhE2pAve
	vquH3OmrnmnWE+oQqVTYd9LhIt3SWQc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1754467700;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Vfa8JIicem/4yRlMM9YoM8phNgRBkXiHyLqwlpPMG6M=;
	b=z6cLcPD0WuRk+ILs2Pmwsiq68CMkOAL2jR0Ydg1kYbZbwUa45bz6XDeKAMhZxXYJj/P7FL
	2ytkpHFrDwAe/vBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1754467700; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Vfa8JIicem/4yRlMM9YoM8phNgRBkXiHyLqwlpPMG6M=;
	b=EQoR+Q5joYedumVFSqyS7oIiKTHKJCtk3Wmw76w/vc6B8VPbCBnsU9FHZpfNlZmTDif8v5
	RjoHrTlxZ0NaB9awPBie7Pficxqx1r7ce2rchaJ/YiHHc50rVh16Fif8++cHHVkhE2pAve
	vquH3OmrnmnWE+oQqVTYd9LhIt3SWQc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1754467700;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Vfa8JIicem/4yRlMM9YoM8phNgRBkXiHyLqwlpPMG6M=;
	b=z6cLcPD0WuRk+ILs2Pmwsiq68CMkOAL2jR0Ydg1kYbZbwUa45bz6XDeKAMhZxXYJj/P7FL
	2ytkpHFrDwAe/vBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4892513AB5;
	Wed,  6 Aug 2025 08:08:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id CACqD3QNk2h2BQAAD6G6ig
	(envelope-from <jdelvare@suse.de>); Wed, 06 Aug 2025 08:08:20 +0000
Date: Wed, 6 Aug 2025 10:07:48 +0200
From: Jean Delvare <jdelvare@suse.de>
To: Minchan Kim <minchan@kernel.org>, Anshuman Khandual
 <anshuman.khandual@arm.com>, Frank van der Linden <fvdl@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Default value of CMA_SYSFS
Message-ID: <20250806100748.21620372@endymion>
Organization: SUSE Linux
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.43; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 3016B4000D
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: 5b1awqiygtps74sczco85ng95ftem5jq
X-HE-Tag: 1754467701-906305
X-HE-Meta: U2FsdGVkX18anFksrNJUWBg+cvguW+QUawMFS0ueC23DIHhHHE2cWx9SKCikP5AehIHIM+rJd6/9pRsB9ho7EzU9eZt0qXwdI9LmFVOm1LqOjbVNOhfi7r6m0TftgE6CwV3QH2LnJ2zyhNufeZdUW7USuN2L0/+1MckKEPzJ0zj9aAnSRcqaNLay6B04X/cC6csHYxO4+GeMHveqj98hiUqpsMMuPRMOFT3liLjDo8OvzMRnC7ZH2WJYjZI4aDYtrk7x0/HFHXxd3ByARoXU0XzNn87WBTkXa2pFGbZ9am/VK+whPS+OLrBBIAfo4s+dDilgghLi+anDXPb0emOouZfiXGH00UlRm3M+GZ8fLvYyjYwxLjeH0shy+fBZRlnuVnDKWANOeKq+p20yE968yQ8eD1VKHJvYlKPAzawCmafw26a9b7OAcI8mIiSFFfsgiScVbEHg79PvgyqMPhYwBnUKSrpbJ4zeJ4ckNCmV84UmmN3mAPej5AxwqoQlxbVb6K1Gqk4+QGgwxAI9lwhouvX3mmxfmPRiXpxiFgIOsp8SRuEy2hNopp03AiJYJN15ghIqWu+P/k22J6D9pPox+iUsw4hjxdd0YGodxJvF1FjafPCjAswCgA7BZggFPXxyYRbpFspvLWW/IdD4EFxUYxx1rY/duANGWT6/sNEQGnAyatkU8eXRynSFT0pClKDHYF5EBOTdYcLUweUTScpOL0yt6W7D7y1V+qOfWL2//0Idxa5K0KftmxWHh9ZiZpQ1zlkAH09fwx8JD/QfsPeeMzgPVY+3bKRme78QhIl7uE9LwGbWxursjq4v4l9vfYcuXZquxON7YNFYj+lwRJMpITEK6dBh57q0/mM9foa2HqWzLdLbh9zl+EOdLvrfwgW0dp/vxFK0ZSTWU5dC1cCaOE5P3AjL5WlfpSlEseqBb3827cRrsyp1RjTJ/hgvzbkQF+QmjZIH0dkBvNnl+Tc
 YifSw0MQ
 CmLcE4S5ZuIVCcoCH7Zc1pI7FjSi+AZB6JUqnuzWwHEVLhIxG5o4ZU4x2Ls+ZLFJgPnZ9EQD+5TI4pyB17B1iG91cdrSv9hexi5yZ5w7YZIdQYXdksJlVYw4qbZrIyb/Cq3a2FWKX+W24VqKo/lQltj/jqGOU9TZpmiJCBt4EOB0EDFhFEcVwmI8zo9Vqe11IVGKQ4ePOL/5iuJtAPWlwt4nHDyEfqTI4a5/BMZbb3d0LkuFITS6rJNoY3gakXx0VN5QKouKYhgqLlzF+y63G2nEFT9Sl6LwGsqThw1F4FjK91qybp6If7Vr7QIUPmYhCPGaGid3GzkozU2cuOP0tkD6wbeQ7SGUpFrxN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

CMA_SYSFS looks like a generally useful and low footprint option. Is
there any reason why it isn't enabled by default when its dependencies
are met?

I was wondering if it would make sense to add "default y" to this
option. What do you think?

Thanks,
-- 
Jean Delvare
SUSE L3 Support

