Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CA17EF8FE7
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 13:40:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F6536B009D; Wed,  4 Mar 2026 08:40:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08C366B009E; Wed,  4 Mar 2026 08:40:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA5E96B009D; Wed,  4 Mar 2026 08:40:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CAD806B009D
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 08:40:42 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 90CC4160544
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 13:40:42 +0000 (UTC)
X-FDA: 84508490724.15.83688B5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 491E440011;
	Wed,  4 Mar 2026 13:40:40 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Pz9Q10ce;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772631640;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AZ2kYLU6stWxYcU2tY+T7f2JcufY9N7kfOI0OosaoNo=;
	b=C5hspDY+ofetR2hvKOfmZwwfoUyUez69YzP+ouhfufHmkFkKK957+vJAsKCARQrh5tRx6r
	dF4iPeg8W73HIhEG4dM106tiDAZSsTTWp5tadJ1TbOT72n7Xprs+eWlYxEi/Ly3U0K1Ler
	AhGSUWbw4IYOgJkazJ8+UkI/jgI5zJE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Pz9Q10ce;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772631640; a=rsa-sha256;
	cv=none;
	b=kRNPBkeylD3nV65QDX1d7+5Gw51TSsIVaA/1se3zGr3pFvCs0Ddphpn+J4r69R9pYIqv3S
	K3EgZALkZ6RpWQk5rGV5bZxNzsCR1aMsGylORAm6hxmz3rRYJ93lI5gNcd9WIpG02MZ7I5
	VPHAdC3KyD8Nip2hVXrzeOnq+fVFI+o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 72E8543AC9;
	Wed,  4 Mar 2026 13:40:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17945C19423;
	Wed,  4 Mar 2026 13:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772631639;
	bh=saBpvESaGj5QiqSpFfWOGnf8j0MOslSLXlBi7/U5dHg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Pz9Q10cesxvicAfZAxJWsJipenbgc+L+GNBCNpgox/ApeDmUPPNe8bReiHFtdKJCo
	 YDJrcx41hrcP49safkalWHRbQyMbDCsHrAYtLJLIZsdZrE0bJ6Utugirq3RpNrvbZO
	 FHWGLQu8SALp+v14qeuSUvgpocfy3rK1dggz0b3mdpAENAGW19TwVxKlHXFttwaBBN
	 9doonxpzjRixTTqINhTaW9bdDXsZKwniR6coFVIkE9yZoYJn9u4qPvJs7mZhBc07jy
	 mvSFumdnatCpc4H+iN0pw8E1ysCu1zZ7LDRKoVLOgExDFMBxxcINf3rkkQfAzvtlq7
	 VguxGnHd/toJA==
Date: Wed, 4 Mar 2026 14:40:33 +0100
From: Christian Brauner <brauner@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, 
	linux-ext4@vger.kernel.org, Ted Tso <tytso@mit.edu>, 
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>, David Sterba <dsterba@suse.com>, 
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, linux-mm@kvack.org, 
	linux-aio@kvack.org, Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 31/32] kvm: Use private inode list instead of
 i_private_list
Message-ID: <20260304-mahnung-ableisten-50d5c4e71013@brauner>
References: <20260303101717.27224-1-jack@suse.cz>
 <20260303103406.4355-63-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260303103406.4355-63-jack@suse.cz>
X-Rspamd-Queue-Id: 491E440011
X-Stat-Signature: 3t53iwsuhggkcc8359ujp8cr1cj967w1
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772631640-785201
X-HE-Meta: U2FsdGVkX18sQF1d1mVBho5yP6QW/2EFSk9QikPL78sVqlhbG0kAkRwYr/YLK0bQqIa/f0Gq1ZJhAfUiR/JlT4CdIVZrkeT6gnBekHkhPr7j+bPW0YAIlRewoADMJNLRbtIJw0je4kFtRQX3+WZBRvKzVoQrWeXmSXz47YkwsWQElD5Cqi8bM5fu+SYcSFP91RlMT79tE+ySUfeOqNE/4muyCBcMr8pgqC+UXM/LjOwWshPr8doW3Hr48dyUP1fpjBqPQ/8G1sReXtGAQJlH8tPRd0nUAvGLAuP3BuMVo03+n117TS6589zCvZ8TbaDcRK9rH5D8G7malKXk+OlyEcCBP8nhFPlejM6qFhFOhd7X402pKSSySA/5RXn3PiMkYfsNOJt2ErmTMPMx3d9mfoC239iGWJAHHzsWdIfObEAd8HjRy/4LODKSkQC72JCUEbLrdB9KRr9Sq/jYYKmBsHI5wqQXZOUiip6RhYk6/DRcPy1983UIGy6l/Xnu371i+mmq4sMgzcc36+OUnCoUfnay+sig70K0TPiG6ul+biN62quwYoEJNYZhADc0RKna7frHrmDvZvS8zh7YL5GmPlEZSzpwQZWJNwizi8/CD6MNmEBuVTf69LNZ+3KEIgPbUSPwYLjAbfEORtxB2uUvV8IAhbR5TZMpXju9b5wqmDE+RUEnaPrxbyxuzZPp6RgsDyXKv6QPvv9U1zeF9IFJKxY9J3VUpiq8kvUVrRyfJFIUyJoH4ifwfM109Gv4dkT5n0i0VB3ZYIb4ARFwN8OSUZ3zJSd8nNrwCD49tsrEoWxHxdD8L7gAhTVDltfbL/opjlNP2HIFJGS3ugc9kf1vzn7XOnD/aqGfVA1Bz6n1hublZprpB3pfR2zvuLses0WRBdRhF3yC72SI+N94SxZ1DALi5sfGkVotiM7FxwWbr9YINl+zAGhSpsKlRbhcmWNV0DwUqGaLjP9xKTwZ7ee
 GlDLheJq
 q9olUVKoKh12CKlmDAN1JcIe0AgWYk5akLSC8fVw7MYsQbNYMYDdDNOl1jR/C99GE+v1yQWtQZFyKGfdR3nz9wAeWi1HzV2cjDXO3Ekmx9ZB4EcXMQw5h0IEQXGKTPrNiO/PeFd4m9oPYhFj64udAgQ/PchybbWbGt8I9o2Z82oGCyIBSpQg+DwfH5WLPPvwZEDDZxPb+a0f8At3J5gmIvNdsoK4vHSo/AF7nWfKi1ks2dZwoiqvEX55K8vCzNMzQJoMFHb0vXLeQDdO6aIHX6e3ogiooGE8FcHc2RyAGy4dDeA1996tsAQf3N4cbeMdKXRxvR55W9uqp9rq8viGjLKtlX1sBlgvvP0arlSeyAfOIcn+vDKMYwr16cdNDIIzfoOPbvC4+jOYo2SRdcgDfjJN5nVUizrdMIK7Go23Nm/1Jf3k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 03, 2026 at 11:34:20AM +0100, Jan Kara wrote:
> Instead of using mapping->i_private_list use a list in private part of
> the inode.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  virt/kvm/guest_memfd.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 017d84a7adf3..6d36a7827870 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -30,6 +30,7 @@ struct gmem_file {
>  struct gmem_inode {
>  	struct shared_policy policy;
>  	struct inode vfs_inode;
> +	struct list_head gem_file_list;

I think that needs to be gMem_file_list not, gem_file_list.

