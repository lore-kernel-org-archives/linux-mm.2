Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAE31CD8C8C
	for <linux-mm@archiver.kernel.org>; Sun,  7 Jun 2026 05:41:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AE996B0088; Sun,  7 Jun 2026 01:40:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75D256B008A; Sun,  7 Jun 2026 01:40:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64BB16B008C; Sun,  7 Jun 2026 01:40:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 558E26B0088
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 01:40:59 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 88B221C1D80
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 05:40:58 +0000 (UTC)
X-FDA: 84852017796.14.574D42D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id D646640006
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 05:40:56 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OH0fXT4a;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780810856;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b7TWqZpXo9m0twdnETZaCSpwwDJItYnjhbOEas7Kni4=;
	b=17vYE9EXlXtxWnjEhtUe9Mup7H8uEQpeiJvdQcEM/C0mcs9NngZ4Uh1F4GnZJco8BOy+za
	8YyvRGPKYiH5p9sYVr+CuXco9W1pva7B8h8bA9PDlOZpGUnQ8gDyhLYqFOWZgvyHMbDFCt
	UsCu023Mz2QotZCKiD8ZlSFhFNoH5AE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OH0fXT4a;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780810856;
	b=txwpKaNaLWCR//t9ePIkii8Y6RDzrP6E6boZ4HDUNa9mmRm+ZlyCveorIweut0Ognd9KA/
	gnR33U3m4nfzToZoUIS15Hkt3ln0Gw40fxqWqvhADtb2JvInOEuCQ0M/oTnvs1Jao0i2ZH
	saUvp4KsJkEcYW74A38M/hA+V0c411U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BABB943E78;
	Sun,  7 Jun 2026 05:40:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58F5D1F00893;
	Sun,  7 Jun 2026 05:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780810855;
	bh=b7TWqZpXo9m0twdnETZaCSpwwDJItYnjhbOEas7Kni4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=OH0fXT4aexoxL3cc0AMzNVuAHnv6cvmkPt20x0NyrjUPQLqk1L+BAVTJ+XfN+0gkP
	 OMfb8ALvfRO53XRZKW1gb2RHvwJSs4TpHDH3aD3eiIHlHyhmP/L0RpKxwUG+v4mjOa
	 jBiVUXsoYKVwZ4m8SA7wIIVPtFiXuszclruaUm+RHQGlWtS8gYsBuGws5Tn9kokFg/
	 fPbtUGHWsI83SxsbpnlKOCzhKDSzYyO8Lmat+pT96B7XebVYgAWIkDOdA18++vPBFQ
	 xvFFWZTbKT7t5rXBxz/qwQzsLim5nWZ69nDWqV7nnKpUnoTE6D6M3mhxLZJ843BEf6
	 z0ppglrgK5LeA==
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Pratyush Yadav <pratyush@kernel.org>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-doc@vger.kernel.org
In-Reply-To: <20260605160645.3650271-1-pratyush@kernel.org>
References: <20260605160645.3650271-1-pratyush@kernel.org>
Subject: Re: [PATCH] docs: memfd_preservation: fix rendering of ABI
 documentation
Message-Id: <178081082228.1643309.7441148315833852918.b4-ty@b4>
Date: Sun, 07 Jun 2026 08:40:22 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D646640006
X-Stat-Signature: 8ftgc8p5agnxhu4m4kioff3xm3h3cbox
X-HE-Tag: 1780810856-715007
X-HE-Meta: U2FsdGVkX1+orNcd8CIublXi9FoAA9/aoRNJEYUMtIxJ8trKSjITiP9xOTfnttptMaXVxA3A8spcTyuyaa3glbBk4FADS/QBKL8sJn5ptIKtfp45NRPsJCTxj7YBX3H7oTbLhFnqOeljx7AXN/yi71STH+zU0bJszVW+F9KPtpOgWIsprU3bDmiA77S0b6d4WI5giYHjZ9hDPL8SJaxD1mdl1OL9Nj3wQ86GXRCwSVDAjoBZb8X1HTqw4XrtPRuB2tLQOexw8mGLn9Y4zXuji33OjKRoVcgePCgVUhmNm2CUnzu3QlgH0Y6qvjeynlKasbhFZIN3d6R2Pcz4r2TiSEFZ0Bu8Ag0c8XKP9G6PqZZZ4gYiKxEkXgaz7agANM28ylhpC+hyVFq+1kuXxLRjVvB4CT1QCXkVS1IlDRDotMnZyUMsy2iLx6VZai7rFbQiTxfKClNLemCR/6PayI5My18VEQOxrTTpiU4TxzALh7rS+msZuHZ8oCweGY0wBwuOJbB3LaoBJKvM4/Qf4NdHzH7rJmcqDmeB10fzw7346Us4kbaZzpYYWeW/plvngWzyRrZkxuDxOnpxatbqLmbfA0PTeTHTKHUMc+rviV50RW9wcBVW7tQxYNDO0/bib57/MWLSyrilSNpIzzIzPEXsfOCYXCxRzoWVlzr1XN/rSboNy3pMKIJYHn4Y52AXx87jTMfVFWO/DDMxG9+pAOiEsJiRx2sPy9SfyjoM9XhiS03KRW9wRrG9CkFJBzd4SRpxL5ZNQDpQitGMhhv8MaHCIxLJRQWncwcE2CceqSJN4Oy15RCyNXR2hfULM41R4M3GOy/oz90tu9dVBdT/z+ZUjmZG2+Z7rC5+ZGOraTeDIIpd5CzrLIYkEoN/+T3QM+Juo2R8HWScuwvJ2Ri2ExaeZSpbqIUn6S1EkIxGcoWOB6c+KIW9+ZETwijqQRGFfBlnbsTP6KEt6nbwHdvXGJi
 Y1gt/cW4
 ARdvWw6MbdJbOLlWR7D/DyJ+Ku5ctprUhwSDL7gbYlGHgAMaBUtPa1y3QGBHDNBMuoUYMiMV/oEkIYGtSt5R12yQ+OazwDnqbSoKdG8efGbZnY6zA4R2DsvnjNrpxQKBEdps4Jxvsb5bmhkEBRZtv4ndouZ0QJTrx1toFw8WpMStsTEz9WA8KKVPedg0ya3qIXg/mCJdR6ma77/J4Ad6+w9voIY0DqHdrNgXMb+f63furnlOC0NPLZ7JbktQvDI87cvXWN2skPU0OWlIevtNsrQc/F4RrNLlRklGw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 05 Jun 2026 18:06:44 +0200, Pratyush Yadav wrote:
> docs: memfd_preservation: fix rendering of ABI documentation

Applied to next branch of liveupdate/linux.git tree, thanks!

[1/1] docs: memfd_preservation: fix rendering of ABI documentation
      commit: 3a358c78093f98a70d84c934b7054f636bc846f2

tree: https://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux
branch: next

--
Sincerely yours,
Mike.



