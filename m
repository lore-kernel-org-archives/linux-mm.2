Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05CD6606A32C
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 13:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=daY6EDy4
Received: by kanga.kvack.org (Postfix)
	id 2B5B86B00EF; Fri, 20 Nov 2026 08:22:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 266B26B05B0; Fri, 20 Nov 2026 08:22:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17D576B05B8; Fri, 20 Nov 2026 08:22:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EA1B96B00EF
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 08:22:29 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 72A7EC0F2C
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:22:29 +0000 (UTC)
X-FDA: 85455561618.06.DE36A05
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id D432D40010
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:22:27 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=daY6EDy4;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795180948;
	b=KJ7EPjDKhgNbVfuZAOGFS/xzymUi07d0qmz5vRo4ZwJvmTYfSQpjVdc9pL9Wy5AUnQoFzF
	sOR0nRDk9yKQZ1xdJoD0beQg8iB5Zr1Jgchyj9jjzKOinRQSCezdAuCIU9a8AKEBmPsXqO
	3RXztTWnEQUBpNZjb8pe4CF3JcWi0lU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795180948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CYKzK+afm1UAXOdWN88x2NYVRVihApLSg0ZCPnBXpAE=;
	b=DbN+ks7IkJ5EY7pxb2979RGqjYvSIMaSgqA1oiGRXHkw/6IcWy+8qnEZ/Ps8IF77PQb+sa
	S1QlD4B6Sh7Qwb+pGEDWKJVurxUHgIx7iE9BZyAUpL7W++EdusExAbemeStU477La9Sgab
	JG0LSxfMl8fdv+fD4PmAYThAHpFmVU8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=daY6EDy4;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6973361284;
	Fri, 20 Nov 2026 13:22:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 417B01F000CA;
	Fri, 20 Nov 2026 13:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795180946;
	bh=CYKzK+afm1UAXOdWN88x2NYVRVihApLSg0ZCPnBXpAE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=daY6EDy4/MYgaj691rc13nwsS7BVt58ckPRvsKOl2i2Hnu4t/DTGBXgBKLWv75LqQ
	 LyocvI3dr8BHsyaTYk6KWZ+lo8NPMzYhMO4mK05rpvqFVb4ZMKY+Yv+imvPzytoM0p
	 mJ3OD0foxm16lLw/nD3rzKJr58Gc27/GczEOn2lEEdMQAFagiy38PrrIRl0M0tg7MN
	 w/UcBT8RLduLhw9YlLeSyxtcYKLXnxIwGf2Yff9jH+iQ6mbq1d5YJxhKbbXDdOJQCB
	 LqLGvy+B/ya4W91XSznxOTE8c3OZX6TDJD1v01gXWyjzrsGITdeX8h9VoN7bY1RDqk
	 D51Qrr7L8WkIA==
Date: Fri, 20 Nov 2026 13:22:21 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Nico Pache <nico.pache@linux.dev>, Jerrin Shaji George <jerrin.shaji-george@broadcom.com>, 
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-mm@kvack.org, virtualization@lists.linux.dev, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 2/2] vmw_balloon: account 2 MiB pages in NR_BALLOON_PAGES
Message-ID: <awBJbbFwE7hlEs03@gremlin>
References: <20261120-b4-balloon_nr_pages-v1-0-d8944b587819@kernel.org>
 <20261120-b4-balloon_nr_pages-v1-2-d8944b587819@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261120-b4-balloon_nr_pages-v1-2-d8944b587819@kernel.org>
X-Rspam-User:
X-Stat-Signature: byniahxx9sk7peixn8h5i8z8j93ym3sy
X-Rspamd-Queue-Id: D432D40010
X-Rspamd-Server: rspam02
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795180947-86832
X-HE-Meta: U2FsdGVkX18EImCmTRY6FuXvvkQMHwrkJNtH6KMZkegiFWpzUleku9qfFQAXloj0N2fCM7Fy3J5tn7+vLTGgpewbLovKBd1QzPWOhgH/oONyJaOoz8SRUxOmi9Ee9WrjaQc7yIlrzbsrTLWDcAUMyk5gKm6pk2Z1jXLO2XiBsvOBL9UJ45JNkTvQsGJy0w8kwRzUeq9ODPNZr+k7A3m4C98jkv0X+OZPgiTX1PMkOLFg3h2i7aHx8nJBhcN0l88NyO876tZHZ4VTnCtmTAoYCqCy+Vuu8xwUSrFrcqfROPbSqWbcS18CMtvHjxXk3ummJ9Ey4IVDzMHpwNGgFE+axhECKyOOZPYRf1uA6Mb8qIW3ClU/Am4orbDkvWJR/7t4pp5ednGOdR0BwOZmeVZeZfbRfCL2K++Od25RKh4Tl0ix/MRlLfmyAbAmhcyHpoklDt5tcmfZGb6H0xRnjWqN+XD2k4OZxXZWv965dWm5hy6Bbl4rooSbwON0VIgbSVzQpsetPNTLmhEg9mpHkDvIJX8ps8phbocBFoRu/B5DRU6LVM7rj/eZgIwO8JwUH6fzfrmB+SBWiF6lNRnMVg681esfWg1V3hW+V+wHfqxsHuS1oZ5Lxa69lPJUMkKbcKSOL2CTBK9hNAEgCZ7j/atakqNWy1po4G/Ogo/u3rYLKrb174C38bSngTLMD0eOGgcNkdRwxcGTW15yXG8mvCj1mO7nn7wcCyyFPWpQW0+yiCPReb0vh2yOEgVpgKgAzwOlzQa2J/fD8Q1x7LirPmJmCudkLu8ULfaU30/NRzLsyo61626EHY0r7kHs5TLh+4ab8SlSCYyaJ2ils3wm/h9rnTboboI7zgaJI8vYn8r46lDPsZ/33v5zd0u73Ov1aVYImsDYYHlUMRrDWq8IZc4s+JI1STvjjej5FH7RafZMyBiEsitzdNlTZr28NKp1m44Ym1EcxEunAglreAwKuEz
 gP+BUXpA
 eaWNNc5mMHDLTMRTlp31nUakkJ6lvaVtOzN5TrdfdHDUzwOjIuPMHOeReCed5t9ggkl8UbD3wjjkT3k+0wc9woqZyrubKudSlDj5crI831OAHPYAJdqdN+2TKwvES4EQuow/7vrFG7sIHdXh6wRE1r6/XuzgGn1V5FaTCXVlj3Gw7caDwYgysWwCE/5kGtuQJti1bKxX4ei+4WQJCSInKMbBhJtiX23M3AsKZdIMNwpNs/S7pUYdFj+kfZJ28fPFPFkBhicQHbBX3qpgd8MKA4VuA4yvJUCyFaqixA3vyRLYEcWtXBzd2o24qcK4rEMAkewv1vbGlwLxp9DJZGllDbJUPgWrV+XxeoiMn2yQVi/iPLpgzFRcCUOuG/y7NUDHyrOTx8TtpKNfBzevMH6kBaL8mZMiVf0Q03bRthuldpVSGRpLN5Gzmw/imeh5mHOl2ONnFrIsK21/UGCciVOBJ2JHVfe7qpVU364TT1pPm7No8g8rICceJu2Ct47lyKj1LSdEGiJwr/lJGQi8bDMg8wzVo0+DM1z0cKDyse89qfchUSbg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 20, 2026 at 11:34:43AM +0100, David Hildenbrand (Arm) wrote:
> vmw_balloon keeps 2 MiB balloon-inflated pages on its own list, not
> using balloon core that takes otherwise care of updating NR_BALLOON_PAGES
> for base pages.
>
> So far we didn't account 2 MiB pages under the "Balloon" counters, so
> /proc/meminfo etc. would not reflect them.
>
> Fix it by updating NR_BALLOON_PAGES when enqueuing and dequeuing for
> these pages manually.
>
> This has low urgency.
>
> Fixes: 4d689474e1b2 ("balloon_compaction: update the NR_BALLOON_PAGES state")
> Cc: stable@vger.kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  drivers/misc/vmw_balloon.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/drivers/misc/vmw_balloon.c b/drivers/misc/vmw_balloon.c
> index 3edb934dd7fd5..47dbcb3be6ed6 100644
> --- a/drivers/misc/vmw_balloon.c
> +++ b/drivers/misc/vmw_balloon.c
> @@ -1005,6 +1005,8 @@ static void vmballoon_enqueue_page_list(struct vmballoon *b,
>
>  		list_for_each_entry(page, pages, lru) {
>  			vmballoon_mark_page_offline(page, VMW_BALLOON_2M_PAGE);
> +			mod_node_page_state(page_pgdat(page), NR_BALLOON_PAGES,
> +					    1 << VMW_BALLOON_2M_ORDER);
>  		}
>
>  		list_splice_init(pages, &b->huge_pages);
> @@ -1049,6 +1051,8 @@ static void vmballoon_dequeue_page_list(struct vmballoon *b,
>  	spin_lock(&b->huge_pages_lock);
>  	list_for_each_entry_safe(page, tmp, &b->huge_pages, lru) {
>  		vmballoon_mark_page_online(page, VMW_BALLOON_2M_PAGE);
> +		mod_node_page_state(page_pgdat(page), NR_BALLOON_PAGES,
> +				    -(1 << VMW_BALLOON_2M_ORDER));
>
>  		list_move(&page->lru, pages);
>  		if (++i == n_req_pages)
>
> --
> 2.56.1
>

--
Cheers, Lorenzo

