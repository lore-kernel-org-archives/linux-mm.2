Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 400C2C982C4
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 14:47:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24B486B008C; Wed, 16 Sep 2026 10:47:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FC096B0092; Wed, 16 Sep 2026 10:47:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1158C6B0093; Wed, 16 Sep 2026 10:47:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E8C2D6B008C
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 10:47:52 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 924E8A5E94
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 14:47:52 +0000 (UTC)
X-FDA: 85219904784.08.9001C04
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 8D59B120008
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 14:47:50 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kFx5mQD4;
	spf=pass (imf29.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789570070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gl4re9AZZCiPdVjnIeC4v7l47zff3YDvqfCdzOAEhGQ=;
	b=eV+4/sag34fTNDCIBScrh+Ij80ciapDMeKYIdnRdkSZvdPTm7dypbrHxg/ZWSUFsQhJBn+
	Ei3R9LGG5amBdxjvOsL32igaVWsR4Ys1smpI/fVLEndLPsyzMwkkmLD50CTqZlyiJ16l7V
	RMAUJy0gdVGh0L9zdBJvDN2o91Bv5bk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789570070;
	b=N1/Ay/BsO8psPQftBU21UsohDUGVJT3XnLneMZgHN/TZdrFqfZ0ls8G9JL8dhhkUEtJuLh
	Aa0KvvBNKdOA/HR5m0O4kH4MXbZxeaoVz9J1ha7s4DjiflrrZ7QfdQhl9z/soG3JSvGUCX
	rXgCC/IyvuGZxxnvrX396hzkM6oCLDY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kFx5mQD4;
	spf=pass (imf29.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3FA6D602CB;
	Wed, 16 Sep 2026 14:47:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E3291F00893;
	Wed, 16 Sep 2026 14:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789570069;
	bh=gl4re9AZZCiPdVjnIeC4v7l47zff3YDvqfCdzOAEhGQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kFx5mQD4OSRwigVj8M/0oFaSBQafvaIHGHyV0nDBPtehlEpmcLoG6cfiRyAAiTEx8
	 GLD24JKUgmNrTvkLf28kJacrKaNvcv2YUHvxEry4FMTcR4J0kCJ06JcKcJsx8+LieT
	 Qp+eXjOXikm77e8NHRIvgdeT8z73gUYnJGyfN3DkLXWlLmzmQ1bz2m+T+ec1TK30XC
	 w2fnCiE1JH/JueWRQPlcaKjx8i3M2D+R9H1fBrDHGF+EtNpq5F2JFQDXXshfcUnHla
	 c+UhVI9uXOc+bwxLHx6a0+w1427EU0XAIxjWO97se2mqKinwnJfz+4gHPVTXmwPAQu
	 BknqaJD1G/oeA==
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfauth.ams.internal (Postfix) with ESMTP id 297CC198003A;
	Wed, 16 Sep 2026 10:47:41 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Wed, 16 Sep 2026 10:47:46 -0400
X-ME-Sender: <xms:DKyqasa45ePXpRyDAq_1ciz1qNCGdo3viJpOPVtPy2XmBvmYyU-7IQ>
    <xme:DKyqapsmvCMzYv1uXxPQFfqhjixOwJk9jCSRbjghuBD67sa_PwUCmsuWO5yiMm9xC
    jM1kiTKMr84DEr3XuGTGQB5LMA6cwQRJ9EQK5Q-h_H8moIHHxofVxfy>
X-ME-Received: <xmr:DKyqalvZWm82WkmTlq3JVxBb9wzTdr6doDb7PzhnwB1l0FaQl3Vtt7Z2aRI>
X-ME-Proxy-Cause: dmFkZTFgIaX24LlpWvrRi+CAf3rAxyB4BVJLvQSzXwbm9QB7G2ul3gOgiWZ8mmfK0lkB5Y
    X9GgrARNQUZn6UZfxgckgXQKKvS83EE++7ckt0xfQeneldKbJWX1REo347pMEy8Dlwgqpk
    WjCKBgB5aQS+1KBYETF9AVPw2rKZWKfAXQP3vReZAB5OuzByXoqzNzTu7YQGVN9dPMBD8S
    c8kJDdZ5x5bD2Xyg1t5Wb1DEuc1UMDsmC9L+5+sCQaV7qp4rb9jMRP/qAv2t+TUq55rozz
    90iTbDsbvufAmS24tgqjzL2p8O3Ys1JmTWhIkTNEyvIFpHLXO3WedF8SxNl4MoX7mY6fjV
    KpfwwR1MpKWl88rhaltuf56a3susWKj60T35eqQPYJklVlAaVR13WS/gpzH2SCSqAQFIl1
    t+/lxY7yVJlcFsfEu3ENTeQ3+MO1DgudlycIAGVK5dg4krcrw3ILgC4f2ynx7QqDDbtLnV
    pPNfmLK8xMEs8IUGVJydPhbQDKK4Nd2NCe1lwftj4wZL/WZ0NSRyF/q0WTCGeZLmV538gb
    5hoeJeeEtMTrZMl7enPOyorgGCs2cflU1eQsiAOlicvdXQAlQZlWtLhzx7tzR/GdE/qIcd
    A21UdV9oXiuduAuMyHctQfRwQWVfGI3KSx4pqs9sQwPsE0nFiHtSRzSSgBAw
X-ME-Proxy: <xmx:DKyqag26aVxGLb_msG0LfsAoQmfzdG0Ko1YwIZF1VUkLu56nG86BTg>
    <xmx:DKyqaqMgs-gNx803Voks0sGKGVKdzaA4UxwB-y9zF1bTgDiE33BPEQ>
    <xmx:DKyqat5pWW4OyaoBStvVNvskyrqhiEmD3sPHVIdFfK65O3UTW1W9WA>
    <xmx:DKyqapaa2weevb5_TdY9h290L8sc9MN--_jRU0OgtiQvIvPzip1NRg>
    <xmx:DKyqarILZYWUlUZZfrkj1O_gOd3jM2MoWuDiTvppqp3QPcdZqyJhenJc>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 16 Sep 2026 10:47:39 -0400 (EDT)
Date: Wed, 16 Sep 2026 15:47:38 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org, 
	chrisl@kernel.org, kasong@tencent.com, ljs@kernel.org, ziy@nvidia.com, 
	linux-mm@kvack.org, ying.huang@linux.alibaba.com, Baoquan He <baoquan.he@linux.dev>, 
	willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org, riel@surriel.com, 
	shakeel.butt@linux.dev, alex@ghiti.fr, baohua@kernel.org, dev.jain@arm.com, 
	baolin.wang@linux.alibaba.com, Nico Pache <nico.pache@linux.dev>, 
	"Liam R. Howlett" <liam@infradead.org>, ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>, 
	lance.yang@linux.dev, linux-kernel@vger.kernel.org, nphamcs@gmail.com, 
	shikemeng@huaweicloud.com, yosry@kernel.org, qi.zheng@linux.dev, luizcap@redhat.com, 
	kernel-team@meta.com
Subject: Re: [RESEND v7 08/29] mm: recognize PMD swap entries in the softleaf
 layer
Message-ID: <aqqrH_Hf1KedPDw8@thinkstation>
References: <20260914122950.3283997-1-usama.arif@linux.dev>
 <20260914122950.3283997-9-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260914122950.3283997-9-usama.arif@linux.dev>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8D59B120008
X-Stat-Signature: 1megbq9ufa7u7q7cazt59gynbb6mjjqm
X-Rspam-User: 
X-HE-Tag: 1789570070-329071
X-HE-Meta: U2FsdGVkX19c2xp3Zuw5URvT9qHOk7wgz8WKU6CormwI6mCr7QJlLpOJukkr3J1dEk3ft2+uddPLAxQ2Tt23bxnvq0s6ZFHUmVrWQv4/sRyWdqOqxFjAbjQLhVhOwaqZMM9FWluEtkIUxRrkgk+bb6K5xHgDApmCheWiglhv+h+z0oy+Re1DkdeQUrj10uodxnX1VJlQhCSH8mbZHJvoJbUnHHS9kBEaomgn/yiesStaDPrbTxI1iconGiHwURQPVTLmU7lECEodJ+LbseZsDfoR8emQ9AGgAjx2C4uhFx68QsntWf7CiRv3qFhmzwW/7gjwFM54WQ2tWh55iVMxja+yLgKyTDi3MSsoDgydt53ArCGYtOLMgC0vtzAoc5LjpVG0vQLW+5WE4tNckDkeTEunc+OvbJxRkeBqLRvQAQHHHOMK9H1sADfQQoKSJThbHcorS3IDgDh2DK5TjkvBvFq60GBntHF4YgaGbt63GpLochaEb5HdwL284nd3Zy9rqW1ComGhVottWplMOXnspv8DYtnIZPKdZXDOpUzY71LmZW3LRwhFKbNSiMjf61Im3BYZFVrM0F6B75H4+9crDGfJ2jqh2+owHVKBJyw1i2merIvPhcZ61lheSJOJ1UEpJGnegznvWCiW92nBK+/an/u6O7c+VViHP2kpj99Eh/AeKgHn1wE0GZ6hYrIESfVUv/tO4J6Cuq3NLk2hegmLrkoutDNh73iUrSD6ijtPHW2VuW27/WqTy9mdvb/10xPN0p6vS5rUoa2mKn83y77x4iRQ4lpNCNMIu/7KK85LG85iED6Hq9epvQjTBC8csb3cHNt/TAy6kJf7XwD7JHJhCpp82ETEg+wGNKnx9YgxdJmkruhz4Gxh6hnmg3dsB0iv+GBMSb3y24XxLkFCXBwz3G63AAhsMaO3MjOkcyZe2HoPu/jqxIPQdsuTrNPpggcTqLhYeFbGvSEtW0OMH67
 Bi+urqK4
 UlJ+Hn7b7R4odKutCtylEGjUv/tlUjZR3qN7DK5YDgQaLBvY2CkmHkzkRbNbuVCYs1zp02QoY02qoJBsZ36Y/qaMWy6CswDCpDNZKBTz4wn2n6XJQbwMn8q+nhjKVrwsK2xX6qXzxhlqqWK6Qvae7yWzpVaHh1jbiZJXCDZQqwCFU8uZTKKzO2dZcknSZobncIMnr6bTM3aW9Szj/tXnt9b/lXvt91cDNASgAivgUpdUzSdnbbysdktI3PsJIVHipjgrRAw13mOLlc1WNzhgcpXFhziFsKwUKYYK1QlspLPeMkDc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 14, 2026 at 05:27:58AM -0700, Usama Arif wrote:
> Reclaim splits a PMD-mapped anonymous THP into PTE-level swap entries
> before unmapping it, so an ordinary swap entry has never had to appear in a
> PMD. Later patches install one there instead, and the softleaf layer is
> where every consumer decodes non-present PMDs.
> 
> Accept swap entries as valid PMD softleaves and add pmd_is_swap_entry().
> A swap entry carries no PFN, so make pmd_softleaf_to_folio() warn and
> return NULL rather than interpret a swap offset as a page frame number.
> 
> Unlike migration and device-private entries, a PMD swap entry can also
> carry the swap-exclusive marker, which softleaf_from_pmd() has to strip
> before decoding. Strip all three overlays unconditionally while we are
> here: each clear is a plain bit clear, so testing first only buys a branch.
> 
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

