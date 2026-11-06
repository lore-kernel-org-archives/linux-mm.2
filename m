Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BB6D606A329
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 10:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SpTYkSUs
Received: by kanga.kvack.org (Postfix)
	id A96F56B05B4; Fri,  6 Nov 2026 05:33:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A41216B05B5; Fri,  6 Nov 2026 05:33:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 956616B05B6; Fri,  6 Nov 2026 05:33:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7B2246B05B4
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 05:33:35 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1D501160D26
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 10:33:35 +0000 (UTC)
X-FDA: 85404332790.27.9F141CD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7F244180003
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 10:33:33 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SpTYkSUs;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793961213;
	b=3KSGm4DxubbAqPeR0+uQYjJCwf/vo4pL02HSVuRp0q9qPV9K7/M7s/JreqxQTXf3rTDWw9
	7PZWDYBimXBmMwvZZNGtz2km7juAgPP/TvPM/ruU4olH2TzTYX7/2ABlLd3vZKf4ii9yMe
	8D2SeMV/VXeEz7JwNwnwcrYY9Xb2JLk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SpTYkSUs;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793961213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q5rL/OHFjebg1wLzCka65mzT99/hbjQbazf5QBMxzS4=;
	b=2Gzsaca2RuXMJ8NsJR014i73qzNr13dtTLctznFdm+5MRCED87bEo4EffhnF9QKZLPfTGa
	O8boNnq+3p0eDmJzQHCKBoTzYL0YB2GU+wPMlvGbe+fjS5KgaMBoCmPenE4PiWxaYMwh8i
	cSWGbiOP/K3Q/QKnqrjIuc4/b6IkjCU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 039ED605DE;
	Fri,  6 Nov 2026 10:33:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 669911F0089F;
	Fri,  6 Nov 2026 10:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793961212;
	bh=q5rL/OHFjebg1wLzCka65mzT99/hbjQbazf5QBMxzS4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SpTYkSUs/REzgKMD7aXY4IOucPQLQqZc1nsQ5ceA5XxrllnWtc8VbVxs7QW5DN/o8
	 UyUVOTUwbZkpyy886dlbraxbWlv2EsUefqGVRjOFu3EpQbt1oBS19cr/1aceYy9CAs
	 2ZYRp9W14Y/lJWsogyksODEM9xgqnx2GsZMjuHEU/gvsilnkLNwg0zzOs/RYPZzmYe
	 TFr2yN+eXxyJQckYu6sopBnz78AwKvbrmiJdlWbjTzCk2xOGT1cCJK5kzTpzycRDkE
	 9qdmt0/8uLDXaOKexk9u7us6XXwHnjdCRt3kHeQNDf0UiWHx2nghxytSRxJa7OE/j6
	 AT/P5dzOMJkBA==
Date: Fri, 6 Nov 2026 10:33:26 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] mm/khugepaged: release contended mmap read lock
 after scanning enough VMAs
Message-ID: <au2sZrlidH_f39kL@gremlin>
References: <20261105-khugepaged-latency-fix-v2-0-4384bbfe4606@kernel.org>
 <20261105-khugepaged-latency-fix-v2-3-4384bbfe4606@kernel.org>
 <551892bd-d7ca-4c79-9c7b-9d3d08c913e4@gmail.com>
 <au2lAPUNPlRtaeFY@gremlin>
 <5c084ac1-930d-40c7-b6d0-b56673da9cf5@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5c084ac1-930d-40c7-b6d0-b56673da9cf5@gmail.com>
X-Stat-Signature: cn6qtnojjsm1zdfcjxb56ainpeq5sqe3
X-Rspamd-Queue-Id: 7F244180003
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793961213-176609
X-HE-Meta: U2FsdGVkX1+vWX8LwUgUSbRmJRRHxwxxC5gdlHZ4cMM4MHlLKAaiukyuL8tuJ31w9+D6bmLfvkNuIXecF0j27QPzl7HA+rrlRVLrbBq5kKl3k4Rgo8IOhn2q7FmI8AinpQxUL2Mr7LX7EVaO4GXPBUGVNwWrJGEXTkkjkInxLe/V2BcTYBi8hCaaXUL63JPCIcDgYtaOY/KZqbo6mPnBjLT7XiF4bqvevWrhviiVOnZVit7Zmo42GnywOtPoLavLj6X7/FmjVoxRKanTPTzsiOE7YEU6NQH82vQiWy4UhK0BkIKpHapaeAghX2tMvLdf9oZpyEwMo/p1MNPiJIqSLqkuswrJT0yEedhIQb8RfyxzvzHLhd+5vYNKwqIUkFAKfSbjggR4CKVmsoVhdxes0zmH2AUQoG7HL7m24CCa36qEJJEnmKu/QVvAA4YMoJTKKIraG+EDXcbHaZy+xc7Kz1wvgXXxNTuOpQOyNYlkyx0QXoHh8NJT1aq7Ws2sapxuzglYNSYGwwV6wqdDl3RBokgzax449Mgc5FbVCODNt6UeBmEhBmVdc5TE2N4bEZozSU9MQCouLr+MTvUL4CR9YBQ12kR9s13EnZo9gF0W4UJAT8HlbBzlAEuOdXNlnaCUVXvNoYD+EJZDc4aH/NI0W37I8WoLospUONafs3AhyfnDQt1mflaJZqwo9zYaTRK92ajNqesVtmEC7c8KxnHd51UJKVqVgXGzM3nIhpPzFA5jv38WeT3QEBRAIgGPPNW/NhiLFTN3mpcsxueNsRmt34boeJDLpGBA324gTZRxrYhsnhlvoFChJMAHWFPWNzBjRJuqhS815/CLLAlj4KKlWTfhvcCprEDRXnh8tpStwlK2xdwraoQwm01TvXW0QEbCpIeoAc/zO68Z860CXBOeWncRbP1QND+dIZM6a/ro9MBrNFYh9dNP88g30pNEAWcLK45H287shbaVPshjbTd
 li/PITKi
 3GNASHinNdLX4Yl2eaRTgrMDSZahpEVGROUWSvF8SfsIsR6UNE/JszxxWt72f/6IPBXwX5/FwFlb/f1PbRiWvy8k3UPwqn1oY0tSiAqw+R3TRHoWLxZBMERLD9IU4//2A/aGFWTOmh0/eQkepjoDTpSRJvrnDHrBRORy9+Wnna1gG2ZoWV3EqjGlfJcYzwSTpkHZcfSU9gSqTFk0ptuy83oTx6DcrMFIrRli30Fuo7rbK8BBMdu7SF+QqkwKuesVv7A87
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 06, 2026 at 11:29:00AM +0100, Jose A. Perez de Azpillaga wrote:
> >> with pages_to_scan below 4 the batch is 0, so under constant contention
> >> we keep dropping the lock at the cursor and never scan anything, don't we?
> >
> > This feels like repackaged AI review...
> >
> > The mmap lock won't be eternally contended and if it is, with pages_to_scan
> > under 4, I think that's fine.
> >
> > Alternatively could make that >= an == and the post-++ a pre-++ and the 0 will
> > never be hit in this case.
> >
> > Or could have a minimum cap.
>
> with >= a minimum cap needs to be 2, since the cursor can stop at hend
> inside the VMA we just scanned and the walk lands on it again after the
> drop. with == only batch - 1 VMAs get scanned per cycle, so a batch of 1
> scans nothing, today's batch-0 loop at pages_to_scan 4..7, and a batch
> of 2 hits the hend case. it's safe from 3 up.

Please don't copy/paste LLM responses. I'm sure it's in good faith, but it's not
helpful. I will run any changes through AI myself.

--
Cheers, Lorenzo

