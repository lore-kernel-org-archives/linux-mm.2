Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B97CC43602
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 21:36:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B6616B009D; Mon,  6 Jul 2026 17:36:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 067FD6B009E; Mon,  6 Jul 2026 17:36:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBF776B009F; Mon,  6 Jul 2026 17:36:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BFF246B009D
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 17:36:47 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 21C62A021B
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 21:36:47 +0000 (UTC)
X-FDA: 84959661654.24.8AFBAA5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 701D540002
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 21:36:45 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hXIg0GCe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783373805;
	b=RzAFqU9f6bOGEVf/4dsnX82G4v2EmdzOLMXWzsfYHJLItyRlPaHeUhPgWiAKXZLp8bd/Kp
	DJAxqYLu6e1TWOAP24Tld1fSmJnf5h6dGidhmrS4XdHQn9AKVoVWDJDsLQjHM+k84Der9S
	zHn52NHe6y+mZo9AiKmlKf20KxpUXio=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hXIg0GCe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783373805;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ac21k4ticVS4yv0U1IuUM4EIwyqtnzpMkDPbmZhqQtI=;
	b=fDgAzBWXbPpOyJUGy7GaES3Cflzf5pPiqwLsZSPTnOmJSd9uZva+9aoR2CLqumiEgzcr6n
	qFcUaL2/bg9vE2aCYWov0sl9jieNjzkDIFPphqwyiF/TQF/Kyn5WXh29XLUZgDfNhltwFe
	sD75tRdnF/mPnweiXXLWYvajX2vBi7I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A535561834;
	Mon,  6 Jul 2026 21:36:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33F981F00A3A;
	Mon,  6 Jul 2026 21:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783373804;
	bh=ac21k4ticVS4yv0U1IuUM4EIwyqtnzpMkDPbmZhqQtI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hXIg0GCeF+aqjI6UETlLd3mu7zOduBcSAE5HI9lzAy3xTH6wZElghJqEyQdaD2chz
	 /obo0A559dX7I6iYdNTjJ/bh+JRcRcJFICRaoizHtW4xtw2RHeY9AmBsvKwp52Y1TX
	 QLyLNEcIrM3NUMhIzi+ELQjo9UFTMLQzzaNizmhiUlg43K9WVOL21NNDaAqA62CxMp
	 aGbHQOLU1HNN6gvrJLcTPlHB6/tB9r4mE9H5dDdoJPdrCSasn7PFryQLbCmIxhnvxo
	 YE9JJL+VKSIxixBi4tWZ1Nn4shVu8w8sSAIWJfYHrIQAAWDoKi+WOMwfWSe+EAzG49
	 93jzKL582OdHA==
Date: Mon, 6 Jul 2026 21:36:41 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org, 
	chrisl@kernel.org, kasong@tencent.com, ljs@kernel.org, ziy@nvidia.com, 
	linux-mm@kvack.org, ying.huang@linux.alibaba.com, Baoquan He <baoquan.he@linux.dev>, 
	willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org, riel@surriel.com, 
	shakeel.butt@linux.dev, alex@ghiti.fr, kas@kernel.org, baohua@kernel.org, 
	dev.jain@arm.com, baolin.wang@linux.alibaba.com, npache@redhat.com, 
	"Liam R. Howlett" <liam@infradead.org>, ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>, 
	lance.yang@linux.dev, linux-kernel@vger.kernel.org, nphamcs@gmail.com, 
	shikemeng@huaweicloud.com, kernel-team@meta.com, Alexandre Ghiti <alexghiti@fb.com>
Subject: Re: [PATCH v3 04/11] mm: zswap: add range lookup for large-folio
 swapin
Message-ID: <akwfJekWILGd6cPS@google.com>
References: <20260703173903.3789516-1-usama.arif@linux.dev>
 <20260703173903.3789516-5-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260703173903.3789516-5-usama.arif@linux.dev>
X-Rspamd-Queue-Id: 701D540002
X-Rspam-User: 
X-Stat-Signature: ifh5pieojqwckxosmpqnnjs6x1kfu94c
X-Rspamd-Server: rspam03
X-HE-Tag: 1783373805-885934
X-HE-Meta: U2FsdGVkX18HnAyKdGcr8RAIBT6YlKLoH+z576M5ea953Cf9QlT9M055dO1+2lkOxZLIb3YsnoDcrWKAAM/ZKRASVVNp5cSvE7glFjnYctcriTSj7GNLX8hvHWvWxWzfrtjfeE/WmSeacHILZyCTdj/eMYu+Nd2KgWa12hN9lBo+q3oQxVQZss9S2O26jGryGb7aODcm55ASUprXEUUuKA+2ULhjT5Z5v+RGOrUtCwJ6Ixk7cGnrTJ7NktIk/4syGTvH0UHMdPPssyfOY6piPOAZXjGtrNtv32ywCC6dN9hX2uEXWJ6VPNJINPc8aDIbrRAK1w3YTFxGz+igrgXhs4u1h/eS/obqT74N7G6Doa2cBTYcEQG5BUvo9sobnz+qkePyllXEhkGciuqqBF7igXFAU92YdCaA0Q0MaFa/vNmKAyInG4Y6DSa4UF46kQblewgdRJ/yt5IiW/awijwl4U/i7rNLNSoBmkUe5bO9WhXtuNMPt6qEnDWS6oti+JQFZS7h/s+mAKV29ucZLsyomPS+3YwGEqtHemS1UdAXo04I3TV1cptViX8jcUvNWqmJi8Inw6VXgDHXYbRy4XOpl85RFLxiyDCviETvZpxgQKfgdt/wlFbaeDHV49fBJ3KNIgasUDxl4RbvWK8wnvP7/IOxTpv4jF1hB0R2pqtp1LMFSSX+JEWeleFrPY4Q+bjl6NjBJ/okVxxSWQx8kLyzn6ju3xqrPRYn55z4cwaUoTJxefl4ovDaDFJ5M8+ZKGVmRDv9YDHnzQIilS78r9UA2dcaFXhgBDPF2xBibuTf2IYx29QIdUy0MazoF4Ka7od8Gf7O7IdxwzvVTD39c9BzsFZZIJySo5+Be+3ATTiVyLwPQ/YKoP03xNA66p3Neam4YWWDOYarzDs+T1KKwiFmrqC+dY2O+eyKO4yZcrCnh7QXwgpLFFxprnGJNo0YU47SRLSVRX8uG5FCouzhDZv
 rDzhAxv6
 f0D/gtC6K757qe3gft9aDfGYhuU8yjxEgL6LGTWW8v1Vg1UDLv/DT91gyNzARnqzwFx7F7QbWd8oMIZHzFeFa5T2KpPoAZY+miCuEsaXH2fWbmkYXybE1QqBu91rzgwxDu+PD+0PFEsdIu9kvbNP+IR8zuAoHCPxfwBF1uiGIrd0ki6lnOeXujWZXwVdjN3dZ+YBUJLa2gY3Jt7XKkn/vvR9YY+nOBCD2fGOFq/J4k8toNfkmnOcUd2B0wGQjBjL+kf4G2KPVqV3tLeHPYpPbHgevDILHRvNJx0/s7jy1DsJBtIIwvhJNhVk666Aa8kvNfRAX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 03, 2026 at 10:38:21AM -0700, Usama Arif wrote:
> From: Alexandre Ghiti <alexghiti@fb.com>
> 
> A large folio reaches zswap_load() only when the caller expects the
> whole range to be on disk. Zswap still stores large folios as
> independent order-0 entries, so reconstructing a large folio from
> zswap entries would risk returning partially initialized data.
> 
> Teach zswap_load() to scan the covered range. If no slot is in zswap,
> return -ENOENT so swap_read_folio() reads the backing device. If any
> slot is still in zswap, fail the large-folio read so the caller can
> fall back to per-page swapin.
> 
> Add zswap_range_has_entry() so PMD swap-entry consumers can make the
> same range decision before attempting PMD-order swapin.
> 
> Signed-off-by: Alexandre Ghiti <alexghiti@fb.com>
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

I found this by accident, please CC me on zswap changes :)

> ---
>  include/linux/zswap.h |  7 +++++++
>  mm/zswap.c            | 46 +++++++++++++++++++++++++++++++++----------
>  2 files changed, 43 insertions(+), 10 deletions(-)
> 
> diff --git a/include/linux/zswap.h b/include/linux/zswap.h
> index 30c193a1207e..de10aa528597 100644
> --- a/include/linux/zswap.h
> +++ b/include/linux/zswap.h
> @@ -35,6 +35,7 @@ void zswap_lruvec_state_init(struct lruvec *lruvec);
>  void zswap_folio_swapin(struct folio *folio);
>  bool zswap_is_enabled(void);
>  bool zswap_never_enabled(void);
> +bool zswap_range_has_entry(swp_entry_t entry, unsigned int nr);
>  #else
>  
>  struct zswap_lruvec_state {};
> @@ -69,6 +70,12 @@ static inline bool zswap_never_enabled(void)
>  	return true;
>  }
>  
> +static inline bool zswap_range_has_entry(swp_entry_t entry,
> +					 unsigned int nr)
> +{
> +	return false;
> +}
> +
>  #endif
>  
>  #endif /* _LINUX_ZSWAP_H */
> diff --git a/mm/zswap.c b/mm/zswap.c
> index b5a17ea20237..89dd88a5223f 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -1559,6 +1559,27 @@ bool zswap_store(struct folio *folio)
>  	return ret;
>  }
>  
> +/**
> + * zswap_range_has_entry() - is any slot in [entry, entry + nr) in zswap?
> + * @entry: base swap entry of the range
> + * @nr: number of contiguous slots to check
> + */

Maybe zswap_is_present() as suggested here:
https://lore.kernel.org/linux-mm/CAO9r8zNni28A+9BiDgDTBRuvGTKnqH91kpbpjjeftfnKSeSOJg@mail.gmail.com/.

IIUC this interface can be used for the same purpose, we just need to
pass nr=1.

> +bool zswap_range_has_entry(swp_entry_t entry, unsigned int nr)
> +{
> +	pgoff_t offset = swp_offset(entry);
> +	XA_STATE(xas, swap_zswap_tree(entry), offset);
> +	bool found;
> +
> +	if (!nr || zswap_never_enabled())
> +		return false;
> +
> +	rcu_read_lock();
> +	found = !!xas_find(&xas, offset + nr - 1);
> +	rcu_read_unlock();

Why not xa_find()? It seems to handle RCU locking as well as retrying.

> +
> +	return found;
> +}
> +
>  /**
>   * zswap_load() - load a folio from zswap
>   * @folio: folio to load
> @@ -1571,10 +1592,9 @@ bool zswap_store(struct folio *folio)
>   *  NOT marked up-to-date, so that an IO error is emitted (e.g. do_swap_page()
>   *  will SIGBUS).
>   *
> - *  -EINVAL: if the swapped out content was in zswap, but the page belongs
> - *  to a large folio, which is not supported by zswap. The folio is unlocked,
> - *  but NOT marked up-to-date, so that an IO error is emitted (e.g.
> - *  do_swap_page() will SIGBUS).
> + *  -EIO: if a slot in a large-folio range is unexpectedly still in zswap.
> + *  The folio is unlocked, but NOT marked up-to-date, so that an IO
> + *  error is emitted (e.g. do_swap_page() will SIGBUS).
>   *
>   *  -ENOENT: if the swapped out content was not in zswap. The folio remains
>   *  locked on return.
> @@ -1593,13 +1613,19 @@ int zswap_load(struct folio *folio)
>  		return -ENOENT;
>  
>  	/*
> -	 * Large folios should not be swapped in while zswap is being used, as
> -	 * they are not properly handled. Zswap does not properly load large
> -	 * folios, and a large folio may only be partially in zswap.
> +	 * A large folio reaches zswap_load() only when its whole range is
> +	 * expected to be on disk: PMD swap-entry consumers split before
> +	 * calling into PMD-order swapin whenever any slot is still in zswap.
> +	 * Confirm the range is entirely absent from zswap and return -ENOENT
> +	 * so the caller reads it from disk; if a slot is unexpectedly still in
> +	 * zswap, fail the read rather than return partially-initialized data.
>  	 */
> -	if (WARN_ON_ONCE(folio_test_large(folio))) {
> -		folio_unlock(folio);
> -		return -EINVAL;
> +	if (folio_test_large(folio)) {
> +		if (zswap_range_has_entry(swp, folio_nr_pages(folio))) {
> +			folio_unlock(folio);
> +			return -EIO;
> +		}
> +		return -ENOENT;
>  	}
>  
>  	entry = xa_load(tree, offset);
> -- 
> 2.53.0-Meta
> 
> 

