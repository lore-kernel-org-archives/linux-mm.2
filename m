Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFBC01094481
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 00:15:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E4316B00B3; Sat, 21 Mar 2026 20:15:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 294C36B00EE; Sat, 21 Mar 2026 20:15:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AA716B0123; Sat, 21 Mar 2026 20:15:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0A61C6B00B3
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 20:15:35 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9DE411A06A0
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 00:15:34 +0000 (UTC)
X-FDA: 84571780188.27.4BB74E4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id EB5894000B
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 00:15:32 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=yZnv0qhA;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774138533;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n1zhpMex85vNx68Js3KpERa8lbiz7mb36fC/JiCuUzo=;
	b=mNadappxIOxLthVQ7QPGoFm7zDbGkoMxI54A3cHaEtuKxWlgmrNMqSjebMiIvSuBIEs98U
	gR+abPVWR0QLMcv0Z5WN6c5hFFosiQbtkXiyWeDJFVqS5I1sGdVzMNj6A+Wy3yeo0l0YQn
	7lwSdlxl1568bB5Hq93n418O8waaE70=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774138533; a=rsa-sha256;
	cv=none;
	b=Ehsld3kZtKAKxxBxY38GTRjkioyhkjjvHF2ug+XsBg5dz6pUvqSTlU6L1yPZ3Tq+PRRV4N
	UsIKFdt4hmrmJhiLBcv/rigy2K3BF29ABq6UBFq/Qnh0Y25jTpRqHHA5WBCEhfmaEv4mOW
	ESpGvIjPRQTTkKNyAnmH+aBKSTvP29s=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=yZnv0qhA;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DF5D843F15;
	Sun, 22 Mar 2026 00:15:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37C62C19421;
	Sun, 22 Mar 2026 00:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774138531;
	bh=pEdS0IQl4Uked047J598Az3GWtgB2RBLZrA7ODfWTZ0=;
	h=Date:From:To:Subject:In-Reply-To:References:From;
	b=yZnv0qhA9JWNiLycYDxxiwKLtMJtFB5oY8QQisVNFBwu5kDEB4/h81ZRyvhdndBP2
	 XQrDhVVgZO1UaQd0DigauQy4CXoCKOjRsEg8C3RgQ6aH9Gl6oZ/rEMfVuGmX3nGKU4
	 om9fQDD1HrQnAUTtb4L7eC3TzvZBpIijgmSRWzFU=
Date: Sat, 21 Mar 2026 17:15:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Roman Gushchin <roman.gushchin@linux.dev>, "Lorenzo Stoakes (Oracle)"
 <ljs@kernel.org>, David Hildenbrand <david@kernel.org>, Zi Yan
 <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain
 <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, Lance Yang
 <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/9] mm/huge_memory: refactor zap_huge_pmd()
Message-Id: <20260321171530.8b3e8207f89d5a7384b9f01f@linux-foundation.org>
In-Reply-To: <20260320203311.715ed75bcd84c18d24894324@linux-foundation.org>
References: <cover.1773924928.git.ljs@kernel.org>
	<20260319200917.ce345a369d035050b6329ac5@linux-foundation.org>
	<87tsu9kgv3.fsf@linux.dev>
	<20260320203311.715ed75bcd84c18d24894324@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EB5894000B
X-Stat-Signature: cgpmo9y4ro1zbew85pz7z83q848uipz5
X-HE-Tag: 1774138532-642847
X-HE-Meta: U2FsdGVkX1+19er6MHwOyCdAeCNEQatn0KYqs6t80SzHJ+Xz8yqBid8DTYbhtWKLGc4VPCmyLljZikEzMYFqWtiluOFf1egxF8EiQbuf6cQX192+fCMW/MDUdXTHVcyaMDGJ0vNM22tA9RvdBRJLhrluycpoGM1gOFSr1rAGo2x9tVNIaWX0ABj1Y7E4MKhajo4tHCEJ2RZJFOYi2OpLmgsfbq/TRbS4n41EFeVwsQ+JhH8ptk2nSljcpin2yO2WET+KEjEj8xYJKxYt+jHLWNGaI6QMCWLklH5n5TAqqo/dojpKQ4MSPmeCqS6pKu6dptUWPCBu2tLkgh8c0yyIyxCCPU76+hiIOWLayqSXiWkmPlyjpEll3oKbLpk3tK7fJPlU6iM7FtAXw6KpTyJWGlympMHGwyGidhe6bFz2ovLi/Jb+bp4pMfI/BWmxR6GKoLypDNEuK2YfQxUZw+8beBVNJNxZyxmXfOrJWxzkzENC1m48ZR1tFkORgszzxOvDKvyWJrpNOn3CY3l/LYtD/iwDVbg2oleS2ideAxKlWtytxgpcWfhTJYyYGXF1FG6ztA8tbBiOOXBSOCp8mrWDlSXyTgssLWS+oe++rtWvzF+51Qi2+aTNq9q0B4rgOSUjvPGmmMOwFXm089gNfZimny/A+Fs7A4o3SSanStNGKRoQQpMuqyjEbHmDOHKBEs65YbjHXEg8qG1XGiip3Tqvbz+KAadOk0GUSM/erPZkY1GcKdR07ce86XcSi8daiGEQ1dAlMy+OsvppeJLasxd5zo38z9QZyEDs/Q7F9RzEr2Rn+T4uxLkWnaYZxg3H3vdT/1iIbAiWtGQFx2/8nrBqEGKPVXVKFRgFXwGKLfzV4zR+tZDVTsmAbJFVabHR12OoqeLGL638GdsC2d5yXyxs2oL3LOQizy7NL3DpaurYFyLszJsOn6tH18egsXwpy9jauffob4eqYUtVNv5WRK3
 uEKScmpp
 N4dYLegzl1OVy5xJEvpFgfa6RRr4+pOU2YUnVokQhZg3gQP0QmBTrLk+bKlc5mKywSY0iJGgBX0yfzcC6Z/UdW2knlzYLCyzrW7O4UIq/RJPKPlvnKAU6hT69tKQ5/S7bGv4iTwlvKP5EHKnnFInHI7C63OXpTiG2xb70vs4MxntpmtDxCeG6XxsW/Q4SARkBbLqMqzwKZUWNC++it/i3OqVdiN1v2JZWf1nKd535/JIV4tWuK5a8rsQgKyDHQNjG8FoX2jdHAEpJj+FXkdAPof4aptTGkrnFgSG3+RCuzANb6ZNtVpDhtptgpXfz+BpCxpRnYlWweEzHz1BbMd4WjMjbhMqRVLMZvHCP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 20 Mar 2026 20:33:11 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> A lot of patchsets are "failed to apply".  What is Sashiko trying to
> apply MM patches to?  It would take some smarts to apply the v2
> patchset when v1 is presently in mm.git?

?

The way things are going at present, I'm just not going to apply a
series which Sashiko "failed to apply".  And that's cool, I'll just
wait for a version which Sashiko was able to apply.  And then not
apply unless all Sashiko questions are resolved or convincingly refuted.

Question please: if Sashiko finds an "issue" in v3 and then v4 comes
out with changelog words which justifies the questionable alteration, can
Sashiko parse that changelog justification and think "OK, never mind"?


