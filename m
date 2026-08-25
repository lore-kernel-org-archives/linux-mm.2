Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 051A0C61DB6
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 08:21:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B83FA6B008A; Tue, 25 Aug 2026 04:21:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B07876B008C; Tue, 25 Aug 2026 04:21:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CE776B0092; Tue, 25 Aug 2026 04:21:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 736CE6B008A
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 04:21:51 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D8B80A3772
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:21:50 +0000 (UTC)
X-FDA: 85139098380.09.E70A9B7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 20A20160003
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:21:48 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Aaq/eH8V";
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787646109;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NXKQgtP819ziNFmsf8nwaLs0r3JO+eL1G9NY1e5O7J0=;
	b=orX/GOOzXjOCSRW90gbnmwX2VvvKMPFOLAzvaUNmaKXKYo2tqY7SL7HvUz1cKYu38HEGD/
	qlnNfMPjV4LneQPByItijf/5ijo7RCbZc0x+Fwyv3t7yuWr4jsf6yvQnKGuqb/IQyyQZcO
	CAdEhqunu1CPKm/3RhbIQ7OotjNbX+4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Aaq/eH8V";
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787646109;
	b=Gzphka/Inyj9e5Cbi/giI5ePXdm+R1XrgwkwHfSM4OpaBctX2HtiPto0F+RtMdnOeErFDo
	pEXxo2gAWA7KVtZqKPdL8oGGlR01iwocwv/vvjc+ngpT8i/bCyrqnc9XgaDfhAPnPJApMo
	Bs2As/mXuN675hRIAAczcUq5FKe+OwU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 514FC42AB1;
	Tue, 25 Aug 2026 08:21:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4186D1F000E9;
	Tue, 25 Aug 2026 08:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787646108;
	bh=NXKQgtP819ziNFmsf8nwaLs0r3JO+eL1G9NY1e5O7J0=;
	h=Date:Subject:To:References:From:In-Reply-To;
	b=Aaq/eH8VM6twuj209DvbzZqJNNjGz8f0XSwa9/UYpv+UjZTVc0nU7Ul6zaIyoZFmc
	 enEj/Ed6V6M2B9bZ9h6ZOlpAw7eC4369iiKLmS4oYgFphyADmwwgKRjdNrLnobUlxE
	 ur6LvKtVPdlfOIgMciyjz4NikQavx+ISAD40p5tR3Yt2uwFv55KWwFb6msBVuhK4ET
	 aSp7ZsdQKByRn78/rV5QdmaSy/rjuGtC0qalQCpYnSQC/IiY1ODDxnqVcieO1EzYeG
	 em/chJWk8qa0mykuxRg4jFboHX8PEIrDOKUgO63cUqpsV74wt5Dbu1t136iOyFq75w
	 /qMpyHD4vKfVw==
Message-ID: <306a6e9f-8090-463e-8b4e-0e039a4e36da@kernel.org>
Date: Tue, 25 Aug 2026 10:21:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Removing ->dirty_folio
To: Rik van Riel <riel@surriel.com>, Matthew Wilcox <willy@infradead.org>,
 Pedro Falcato <pfalcato@suse.de>, Christoph Hellwig <hch@lst.de>,
 Jann Horn <jannh@google.com>, David Howells <dhowells@redhat.com>,
 John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>,
 Qu Wenruo <wqu@suse.com>, "Darrick J. Wong" <djwong@kernel.org>,
 linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-xfs@vger.kernel.org
References: <aoyWln-Gt-yvZQkE@casper.infradead.org>
 <b067b26d9d0bc224b5916c7e064277863e7bbc55.camel@surriel.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <b067b26d9d0bc224b5916c7e064277863e7bbc55.camel@surriel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 20A20160003
X-Stat-Signature: 3k13abpp7613t7wox8hkz1c8run4ccxz
X-Rspam-User: 
X-HE-Tag: 1787646108-983267
X-HE-Meta: U2FsdGVkX19l5DoTiXQ+DInTSkwkGlmpaCPGyHPyzODs7NTGC2XlcKUEn8MuvR21pCgSxwgFMMDZRQtcdWwbqmqDYUPQZwJ3yjaE+Vb6cMCiwMoGggQ2jXI8S9GxQGuKrqHwdoguQBTbrZkKLGl/t2ocwa2erislo2xFI2TuMK3bPX7WCrBxSXRvhD2K1DODOpGTyqE3OLmzovHjxYYhw65dvgwaoHjv736GvWWHLbSpnjZsJPq5gdpSSVD6AesNAXr69r9KOModo/iZ0onHRLI25uNZXQm74UHrgQXmBpr+R9F0LsQ0IIY+46fzjb5fl5Zx+/JQs9r3/gPBhY030Zx/6AnTw/eo3/O0k5dWFgTg143G2HiLO6ZUd5poOsoSU3ByBrKHIxsgePo73Z6J2hsQ5l/i2suJ8Ia1eoYjAyIJDfJgljlfeJmxzZwpxSOi2Ge/aSjWwfb1YjB8T7KYZ3t0OhnuEvtN3gM/jj5CbCorQaBjKNyZexc25c3jwyrCo4CGRbDO8Dwvx3L5QId+jG37OXpH7pdoOlY/m4GgGyicFrzEa077vmeZSAYx5FbfjipnfwtnOyGnM339+G63CfxKVkXFaTHTtmtPA3otRWDWDhqFHYG3PoujWjvocjD7ANPVZzBkpKMtVO5WKWfH71DGDCyHOd787CLNytKi6i+eTD+GRvN0qthP4sUxMVXEw52hqAZQHp2HtJDcuuyB6xEzdXkrkJZoHZDGsMnNweZwP2qhLfEaMJVzNHDgUG4JAm4dR1NzuoR85Z8acugQz7VGlVkUw1DhzAuVHFajWQ3DZ/1Kbe7PCB9PUnoxuXOewlv1S8vl7hUpiz2ycQAEGPrZQ1MVTOuvAfiCGqhReuEdwxxY7UN8hwSGqyu8KHkDZZROJ5lbZb/+9GiaV7ev2VeDK51RvZOQTDQkg8KQBboAp6tyzV3WSTCqL+wcxhxmiv2W/+HHVEAkt9ddz6E
 cShLvd1u
 iEK7G0z2W5vnJg3qMiqKfbIDTW5YpnFO4MlGKq9vcQHGTPCIO1RMWJtqEUrB8799yydlyd+hYVyddlnApcvyT8hgK8qvvjVZob8adKOklEy7pd9y3lIRNsZokFqbxbdI15nrKJbOHIYDX7u3oOKdwwTxvlgfLyswmLeDEfMpDLSLg+cQo3PHyxsVsbbHSpN3f2gDx4SiysS1OnUsi452z8EpZHRm5tRDPYrxNiMVMJgbPw0qAjlDNxLQha2764/c2SpLc9z6KqvxFrs4Iad5KORVRHsDtQm63a231TtcmbxNVUHm3ZDj+mW2llA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/24/26 21:33, Rik van Riel wrote:
> On Mon, 2026-08-24 at 20:08 +0100, Matthew Wilcox wrote:
>> I think it's time to remove folio_mark_dirty(), ->dirty_folio() and
>> so on.
>>
>> This is not how filesystems want to be informed of folio dirtying.
>>
> This sounds like I should leave the folio_mark_dirty()
> stuff in the get_user_pages() code alone for now, and
> leave the shaving of that yak to another day?

Absolutely. Making it consistent in GUP is a reasonable cleanup, but don't mix
in too many unrelated things into the same patch set.

> In that case, I'll prepare my next version of the
> get_user_pages() series.

I still want to go over it and provide more feedback.

But that won't happen right now (it's surprising how many people miss that we
are in the merge window) and also not next week (traveling).

But there is also no need to rush this, I'm sure we'll get something done for
the next merge window :)

-- 
Cheers,

David


