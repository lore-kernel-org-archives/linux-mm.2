Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAA8E606A320
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 18:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OvmSX7Hc
Received: by kanga.kvack.org (Postfix)
	id DDAE76B0643; Thu, 19 Nov 2026 13:38:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8B416B06D4; Thu, 19 Nov 2026 13:38:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C53C16B06D5; Thu, 19 Nov 2026 13:38:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A23566B0643
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 13:38:56 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2FE3640B87
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 18:38:56 +0000 (UTC)
X-FDA: 85452730272.02.FC27815
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 936AB1C0011
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 18:38:54 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OvmSX7Hc;
	spf=pass (imf21.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795113534;
	b=FcoU9ykztsZOC+sZ5QOQDlaBuBJVRB3CQum9txF5j5FUOVg//O6t9Wt7tg29UsQGuo7Yar
	+/x6I+bO7Di6URqPCRT0puFusOeVn87AucBsMb4KMf5kZ035O7/ZfUA5p/y7WTaJo5kyqW
	oD0Ui5gVyTpnhWV/LP7AY1/bpnmQhNU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OvmSX7Hc;
	spf=pass (imf21.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795113534;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2iQ0+2zXaYo8rBW1GuAj8YJKBX93rhlTN+lHKRkNO2k=;
	b=xHF0AhHTTWYH7aFX8DlRJ2NEIaktwDeSQ2ex82XLMT2nUAvNpkYVCRlCqrXgw9egK/VCDS
	mQkzhGQ54r8I7LOyUyVZQSkiHtHhzrKfvuN2ULPai6AszZC80cAW53AILdgwLzTRSJ//XV
	pXrVYjcfeANlE5EBpXuZ6laR7A7zlDA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5865A60F74;
	Thu, 19 Nov 2026 18:38:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9CDE1F000C5;
	Thu, 19 Nov 2026 18:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795113533;
	bh=2iQ0+2zXaYo8rBW1GuAj8YJKBX93rhlTN+lHKRkNO2k=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=OvmSX7HcrPPojaHOsd8NleIm2QS/jlCNMIe69IhvmdlCp3xKGXevQNai3c5PWEhxP
	 kIaL8l3fUXCeUiH0LNCQ+X6kZwm5F3Dpc2i/PMstTdqP/nukUfU0b85PvAMxwF0LI2
	 heLb7Igind9TbtSXW+JFsUQswMaxQaFrf632hY2qIp07pZS7QEa9wlDGpb/24a/qnw
	 DU9iWW/loeye7T2UAzXxuqLow/iuGATHu1vfCouJLbrzX7fVu8aT+AsQoZabwkYUxj
	 Ui24b2/nklqI0U2yGVklRIgdVEwDdoqd/PYq/9l2I2QlHTnZdVQeWcEZDXxKwbCTYW
	 5hT5R8giR7ceg==
From: Pratyush Yadav <pratyush@kernel.org>
To: David Matlack <dmatlack@google.com>
Cc: kexec@lists.infradead.org,  linux-doc@vger.kernel.org,
  linux-kernel@vger.kernel.org,  linux-kselftest@vger.kernel.org,
  linux-mm@kvack.org,  Alexander Graf <graf@amazon.com>,  Andrew Morton
 <akpm@linux-foundation.org>,  Baolin Wang <baolin.wang@linux.alibaba.com>,
  Christian Brauner <brauner@kernel.org>,  David Hildenbrand
 <david@kernel.org>,  Hugh Dickins <hughd@google.com>,  Jonathan Corbet
 <corbet@lwn.net>,  "Liam R. Howlett" <liam@infradead.org>,  Lorenzo
 Stoakes <ljs@kernel.org>,  Michal Hocko <mhocko@suse.com>,  Mike Rapoport
 <rppt@kernel.org>,  Pasha Tatashin <pasha.tatashin@soleen.com>,  Pratyush
 Yadav <pratyush@kernel.org>,  Randy Dunlap <rdunlap@infradead.org>,
  Samiullah Khawaja <skhawaja@google.com>,  Shuah Khan
 <skhan@linuxfoundation.org>,  Suren Baghdasaryan <surenb@google.com>,
  Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [PATCH v4 04/19] liveupdate: Allow file handlers to mark
 retrieve failures as retryable
In-Reply-To: <20261111002358.1842967-5-dmatlack@google.com> (David Matlack's
	message of "Wed, 11 Nov 2026 00:23:42 +0000")
References: <20261111002358.1842967-1-dmatlack@google.com>
	<20261111002358.1842967-5-dmatlack@google.com>
Date: Thu, 19 Nov 2026 18:38:47 +0000
Message-ID: <2vxzmrr43buw.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: roq5jowdcg1fbo7sqii8dcmth5pu7xr3
X-Rspamd-Queue-Id: 936AB1C0011
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795113534-427800
X-HE-Meta: U2FsdGVkX1+2MJz1FkD0a0acvwnKhj9jW4ibsh/pmQ3Jm57GsQfFKmjEv2L9T4duhe/mo2fTyk1gsRV53X6lXp/fKE/ftSj1NW34HrUgbM0SYZB+SnU5xgdZysjAfFtsDN4DCllqXMaIgUMSLbexIBeIfolf1k4rrAUNKUDBPqmP6yzzYCSI7lY2BzNMTppYogdCf8zg3bNNlus5aBHsp372ZZYVhku/87gnUJFpbTiURwv/woqE9bN3kREZMDr9oekWWHcrTPEAUSumdN9N1MIb4BzgX9Q8lg/lnxnplnNane1XYN3wyIzhLGGfnAyqIEDRibeVIOqOIP3Xl5bYI7B2W+i5sNlLNF3xhLDnu5tWU9QMMsYYiMoPM0Ra9z64CAJ0J+ACA7u7aWQT2B1ZDqL+H5Uc6GHAduPL55eemmtSTpL4x0M6gGb6fEZFWbuOyGEEcp0CFR2BXKkvFgY9GrYiG+teGd/WTnLVy8WzK2YKPt93YmhKuQEwrQ9hfhsg3LJFDlN7kIN+aSl0eyBigq8xTBqdazwHnV8tmCQ77T8mfQ/BGYAMb2Tm+e8o7wgn1fuqONbJe2a2bhMiHEDSMNpsqqUlgJMRkkziUgKpENXHN7YeysPsoiNGxmoACKqQPjPJ0kmIWHp37tp30VfPK5ybuo8vFcTXy9aUCyaQ/WzppXm7bZBRJVzkmuu8K840b5dV7LfG+KlEGusjeVUPTrixc+o4VNQfmr53EucbC/e9LiF4FbvdXOM3SMG0SXZzvs0P977uLtkB5LZbA+no+6nHbz02C0lYbKzle0Vaq8XciuQBy/EjQDTN6Yg9f5QmdnOEnuwvKwPfB69x7elNhMUGiMIC7Q/OYBLdQETMqMPnrknIOt9wOUjj/aCQbBS1SMiO0tDjLDJDyrBZeGIQ/uz32LUTSn95Sqza2xUC0tbs1/IpQrtvARvCUvyiuu33nO8aZMzMl3qcpJ83AHe
 foaEePcg
 7KJt4gAiQ6gZcplgIFiMvzPq4Se2jLM/FGWtB9FQJSgWoQKhMw+rV2zeGWYmreun2VQgUCY1WzDPhut7dCWNNr0jBC7zmJ2ORzorbkY6rDkGcmtGQ78Rkwy27oZRUoxtIQlalk1IZUjpShuogvvMfQ3hny8MGQzTklylZ/5U7feFthVubJ5HdXdjAUmE+JR7Sn4arKf5fAyuI+PpMvxiqb0/FaIjddJVnvV2TeGw6y3QxX/fNPEkQ/Y7M7SE/xfNGhAy9ekebwH6W9QPddi3RIARL1BpNPar5n7jlhpWkfE42xTjrkVahUWNzOJRMt2IuKvIP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11 2026, David Matlack wrote:

> From: Pasha Tatashin <pasha.tatashin@soleen.com>
>
> Add a retryable output flag to struct liveupdate_file_op_args, which a
> handler's .retrieve() can set on error to tell LUO that it hasn't
> consumed the preserved state. LUO then lets userspace retry the
> retrieve, and .finish() still releases the preserved state if the file
> is never retrieved.
>
> When luo_retrieve_file() invokes a handler's .retrieve() callback and it
> returns an error, LUO currently records the error in
> luo_file->retrieve_status and blocks any subsequent retrieve attempts.
> This is necessary when the handler has already partially consumed or
> freed the preserved KHO state.
>
> However, with user arguments passed to .retrieve(), a handler may fail
> early while validating caller-supplied parameters, such as a missing or
> invalid argument, before touching any preserved KHO state. In such
> cases, userspace should be able to fix the argument and retry
> LIVEUPDATE_SESSION_RETRIEVE_FD.
>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Signed-off-by: David Matlack <dmatlack@google.com>

Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

