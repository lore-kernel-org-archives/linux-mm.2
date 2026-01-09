Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78D94D26D93
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 18:37:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA6D56B0005; Fri,  9 Jan 2026 13:37:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A544B6B0089; Fri,  9 Jan 2026 13:37:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 960046B008A; Fri,  9 Jan 2026 13:37:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 821F56B0005
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 13:37:46 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C85F3D09B5
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 18:37:45 +0000 (UTC)
X-FDA: 84313284090.10.412A531
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2B6F218000B
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 18:37:44 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="cKq/4w7g";
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767983864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KhWmQqM56gLrKE1FuzjHhji8nQ+pitm6bhi8nQvgHiE=;
	b=V8QueTu9Bxynwn1UyovlmpW2w64AcuJH626V5eOURbIpuxhCMwY+NwJRew3eGSnSf1Vn4p
	OdLUyt0ZCm0kT8z7nvZusndtKFYKzziRdsG/WswaDfp2oIs117g0B6WFJ8hUDmxSMStEe1
	neNH7N4uQKLFME6TztW++f4Iqb5FA6w=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="cKq/4w7g";
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767983864; a=rsa-sha256;
	cv=none;
	b=0ph8mG4jde1Jck9ZRUSGZSzI9LhYzUGcnXzY0NdcFC3l8egqIcYtyuF1icbrdOWgdmR0fs
	d+kriMf/N3QpOpyBeDM7TcwvDQRUjVSUgmrwvgJYn2hV7CA+E/aFYaVb/Gn04eaJOQQ+IO
	6S9L6+77Be9FnYVyvRso72pGxLQbbZ0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3A08460160;
	Fri,  9 Jan 2026 18:37:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 602F1C4CEF7;
	Fri,  9 Jan 2026 18:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767983862;
	bh=ARzqSTrB4mFRoJEjpwqfD7XvlHCDD3ZE6XeoURLYd8g=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=cKq/4w7gGX95/qxZpKSvwIsa09ufoQFCR4/Y9FL0I8olI1SnCnQzQpwg1S3mCWVVs
	 fajeQx6jMNNGo8G7kMsAbEd0MC7fMHF/ztwPL66zbVw9ppWO5gaoYQ86zcxHeG59MP
	 FlZEs7fuDVbcUF9xgvE6Fs9QTch66UtAMgMDUxjk=
Date: Fri, 9 Jan 2026 10:37:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Francois Dugast <francois.dugast@intel.com>,
 intel-xe@lists.freedesktop.org, dri-devel@lists.freedesktop.org, Matthew
 Brost <matthew.brost@intel.com>, Balbir Singh <balbirs@nvidia.com>, Lorenzo
 Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, Ryan Roberts
 <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
 <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Alistair Popple <apopple@nvidia.com>
Subject: Re: [PATCH v3 1/7] mm: Add folio_split_unref helper
Message-Id: <20260109103741.533c1b807f3ccf9a6f0264de@linux-foundation.org>
In-Reply-To: <59fb1669-2908-4cab-b3c0-b97479da3fb9@kernel.org>
References: <20260109085605.443316-1-francois.dugast@intel.com>
	<20260109085605.443316-2-francois.dugast@intel.com>
	<59fb1669-2908-4cab-b3c0-b97479da3fb9@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: dg5xswzr57ak5fw4jd41fpqiusny83m6
X-Rspamd-Queue-Id: 2B6F218000B
X-Rspamd-Server: rspam04
X-HE-Tag: 1767983864-632594
X-HE-Meta: U2FsdGVkX1+hfj3ESwRSJjONoYWAULHot476r2izDD58Rn0UiYUzmBxPN6svJDUrSGpXhr3qWtc0WC9cGq8nGcSPzrgz/9xdjnUKyqNyd1M5oMr8Lu0AZtYM64J7zN5hhyTfGrmVsLWy1FKl7HWnDD6hC09Z+CZPQz8y9KF7I0rniVPyT7Ucpf5S6QN+t+nqE46HHC+7V6kusrBp5ZCTn99Vl17FbHFgLjZf2h/jzOPthEeL/hc3K1bU4oXYusA3tviUJISt5SJTxVdMLs6kk11SXAswdxmUyaSbRTVzBfx09iSJj99q+bdOis/QUfErslJFAvslJzZiTm4t+yhdzBM+GsjlR6CG28VnTga9xsKFJvcDe51LwsZ8LPCQL+38iSx80dMpKM89h+mjcmdLOndfYyBUX8YLlNdE6riCw9hghZsY6RPW90+VmOU/QDExJKt8X+pKteeHuNn16JYIKy9CWYwkWXhLzr2m9hYOQRYVCEDcTte+n3WnEgfHMFqT+imq4KWpH0hWBcYrXI5G+gJUM7YQQGvKkXsTTPRvhawNMm3rjuOI6M0c1g5DAroqQo8mU+zfDcVqLu7/PRnSja/k/rYF9hFGaBYMuIRwjZvdhJnut3SG2/L6eNV24BwUJtsNUgUMK5HGUJPFxLh99cDsHRMC56hn37E3HQmz37JVKfBbt6iHXhASIfj/aS8bNh4BGtrhlynYpePYFTnN1gbmvh7eqHKe6t7pdkCbw8zfL1008LBRf03ZlYoNXmMRefWeQVTaS3eLIVN6+PZ8B0ZNfThi82OKj2M2ozPJV5za8RXumGgJxDOWFQaRIc7AAzF/Vtf7mBCSU6Bm4EjhZkSK+bIUHH7y/dGdm7Tx1125cVH+eFwRP/Vd1TcbcnCuI7MGDbf9ebaJERGrCvtHj7B74mXC1mano2cLiKhye4UEdUpwOk4av/VS8Akaeq88qBRp9obfZxShTnrAJif
 PS1bzdRF
 bq/g3dQhMtL3QVppvYAvh1MfSvwtm5FgJwj/hHijJcRIyMpt68kfcDm7b1HQxi5bDD1YUkciz7fwsLBzuHBltJ+RtM2+DwbKjg+04Aru6c/HF2eeDpfHyQqELgn2hKldyQ9R7GP7MCIJ2XbFuQwKQHmvZSklaZKz76+4YOpYE4uDL5xAmxcLjjUsQP9dwI/AVRGB0SLUrOH1OP26uuwEgLNCE6R5sCj2Shr4SXA4T/Iy8AmyD4Tn79R25cuMrve1WvBgW7N2fwp4Lz6uWvj1r7zYBtRvrUv3e05Efc+vaxwb+mo/fpyxNtUeHR+mx9cMyWX39u+KSXs8CZPagL595PAxmMA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 9 Jan 2026 14:19:16 +0100 "David Hildenbrand (Red Hat)" <david@kernel.org> wrote:

> I'm not CCed on the other patches in the series or the cover letter, so 
> I don't see the context.

Both linux-mm and I received a random subset of this series.  Something
went wrong.

