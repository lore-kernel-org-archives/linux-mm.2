Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 886FAC88E50
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 08:16:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 622E16B0088; Mon, 14 Sep 2026 04:16:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D4956B008C; Mon, 14 Sep 2026 04:16:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49CB46B0092; Mon, 14 Sep 2026 04:16:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 15E6E6B0088
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 04:16:48 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D446E1C39D4
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 08:16:46 +0000 (UTC)
X-FDA: 85211661612.29.BA953CB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 007E414000D
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 08:16:44 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g5VZa+oD;
	spf=pass (imf23.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789373805;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C2ZDgDBTBPtrsfvAlmUEPAUvKktvQtFVn2Ou8+zwXP8=;
	b=blfXDLQm64BeD/i2+deVXXaAmlpQIP+LlGOSrwyoyDdrdKG1XFZCykgQb0R4XMUt8O8Fdl
	UqjZ9SVvRf6vA8resjCxM/0bNONuAVKR5urV9isQFSrb81jAt6mH1kDo1fSkV0n84NnibQ
	irrV0nhIR1sTV1BpO3GhiaMf4IepAUE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789373805;
	b=54dfq2KupIAAxNEqRTPztNKumUWnkaSfJRV1zYcm6lbrv7m2kJhFG5TpSa/dlNWbrfAUIh
	hyZlOJrOLvLpELvxZ3W7+B1u6Z/aBjsGt07rMkrSw2NnsIjlhA8oKrsbjDJhNFK3Mq9DUJ
	HmWY9c5hJIUU3vYt1cVt62cDT4d+S3A=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g5VZa+oD;
	spf=pass (imf23.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 14EF641591;
	Mon, 14 Sep 2026 08:16:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D865F1F000FF;
	Mon, 14 Sep 2026 08:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789373804;
	bh=C2ZDgDBTBPtrsfvAlmUEPAUvKktvQtFVn2Ou8+zwXP8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=g5VZa+oD7n0qwA8dkNw1dGt1hYXlL3zXO88zEqM7vtRhR1kV5deBd4b9OCOtJUWQ5
	 +N4pTKxXSl3IIDDDtWLcdaGHzf5YRCL5WIboBhYwWdxa9PoPaVWsgfnBXEDxHkH1eS
	 xzx1SsHXbB59GXTRN3edLFEomnyLmfK6g4SSrm53cjWCgW8FYM8qzJ2gbI3L+AZzxV
	 sjJLSgZNQmwcLieaLRLf5E+z1ii1Fdan/onsPk9Ph40+wV+r+20SjHboG/rT+ju6mz
	 11hHk1V/FKSJB5okOVcsvDJ52P9SN3ow8/R+JIR55Z7MMROrj45/EqEufFgUSEyF1E
	 /Gne3r9EIYRGw==
Message-ID: <294580c0-ad46-4160-b954-360a8a4dacdb@kernel.org>
Date: Mon, 14 Sep 2026 10:16:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 09/26] mm/fbatch: restore mlock+munlock batching,
 without extra ref
Content-Language: en-US
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Ackerley Tng <ackerleytng@google.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>, Alexandre Ghiti <alex@ghiti.fr>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>,
 Binbin Wu <binbin.wu@linux.intel.com>, Christian Brauner
 <brauner@kernel.org>, Christoph Hellwig <hch@lst.de>,
 Christoph Lameter <cl@gentwo.org>, Claudio Imbrenda
 <imbrenda@linux.ibm.com>, David Hildenbrand <david@kernel.org>,
 JP Kobryn <jp.kobryn@linux.dev>, Jan Kara <jack@suse.cz>,
 Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>,
 Kairui Song <ryncsn@gmail.com>, Kiryl Shutsemau <kas@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Leonardo Bras <leobras.c@gmail.com>,
 Lorenzo Stoakes <ljs@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>,
 Matthew Wilcox <willy@infradead.org>,
 Mel Gorman <mgorman@techsingularity.net>, Miaohe Lin <linmiaohe@huawei.com>,
 Michal Hocko <mhocko@suse.com>, Minchan Kim <minchan@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Peter Zijlstra <peterz@infradead.org>, Qi Zheng <qi.zheng@linux.dev>,
 Rik van Riel <riel@surriel.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Shakeel Butt <shakeel.butt@linux.dev>, Suren Baghdasaryan
 <surenb@google.com>, Yang Shi <yang@os.amperecomputing.com>,
 Yu Zhao <yuzhao@google.com>, Zach O'Keefe <zokeefe@google.com>,
 Zi Yan <ziy@nvidia.com>, linux-block@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <e28f9a94-4339-f8ac-8301-6be3c9b5b7ce@google.com>
 <69ba633c-8fd5-1f4b-2e1e-b9b15b8946be@google.com>
 <ce1e07aa-5600-46c1-b35a-d7df09a84521@kernel.org>
 <96fa2371-8a9e-8fcb-08f0-2977320bbbe8@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 xsFNBFZdmxYBEADsw/SiUSjB0dM+vSh95UkgcHjzEVBlby/Fg+g42O7LAEkCYXi/vvq31JTB
 KxRWDHX0R2tgpFDXHnzZcQywawu8eSq0LxzxFNYMvtB7sV1pxYwej2qx9B75qW2plBs+7+YB
 87tMFA+u+L4Z5xAzIimfLD5EKC56kJ1CsXlM8S/LHcmdD9Ctkn3trYDNnat0eoAcfPIP2OZ+
 9oe9IF/R28zmh0ifLXyJQQz5ofdj4bPf8ecEW0rhcqHfTD8k4yK0xxt3xW+6Exqp9n9bydiy
 tcSAw/TahjW6yrA+6JhSBv1v2tIm+itQc073zjSX8OFL51qQVzRFr7H2UQG33lw2QrvHRXqD
 Ot7ViKam7v0Ho9wEWiQOOZlHItOOXFphWb2yq3nzrKe45oWoSgkxKb97MVsQ+q2SYjJRBBH4
 8qKhphADYxkIP6yut/eaj9ImvRUZZRi0DTc8xfnvHGTjKbJzC2xpFcY0DQbZzuwsIZ8OPJCc
 LM4S7mT25NE5kUTG/TKQCk922vRdGVMoLA7dIQrgXnRXtyT61sg8PG4wcfOnuWf8577aXP1x
 6mzw3/jh3F+oSBHb/GcLC7mvWreJifUL2gEdssGfXhGWBo6zLS3qhgtwjay0Jl+kza1lo+Cv
 BB2T79D4WGdDuVa4eOrQ02TxqGN7G0Biz5ZLRSFzQSQwLn8fbwARAQABzSNWbGFzdGltaWwg
 QmFia2EgPHZiYWJrYUBrZXJuZWwub3JnPsLBsAQTAQoAWhYhBKlA1DSZLC6OmRA9UCJPp+fM
 gqZkBQJqFFy6GxSAAAAAAAQADm1hbnUyLDIuNSsxLjEyLDIsMgIbAwUJGtCBUAULCQgHAwUV
 CgkICwUWAgMBAAIeBQIXgAAKCRAiT6fnzIKmZJIUEADFx/tREzUImHrEwVHeSvDFmA7tJysI
 UVrlvrM09E7GIuzphzv7jYmo8n3ANpCczLEVr4G0syYQdTigaZgv3+FQDIIzhKih1IHhu1Ei
 XHlywNWKnQxxQEUNi5Mwx43wQz5XVw9F1A7gtKBKNtfogO511hAbrzagrYajyQacEJ/+sfhZ
 9Da8ltHIXD8pcYaHUfQgEusCgmEd9+KrUwrTbckFKmYq5chuE6yJ4J0EmWknL096jIE6CnzF
 FRslQ3B1UKDjxVsm1ZHfir5NeWszLkTvGFsddFaWTgh8UycESG6VQzKXjjewXu2pG7YQYRpj
 QKm1W5X2TkwWkXRBZTmfmbhxIUMh3+zf5wQ463rSmDN/8v81tdqBtAW6rH/kzg1GvkaTHXn0
 507yEHFzBksk2viAuIxxr7km8+/KARYLIdGtx30EG8cKzAUZOK6WqxtNCsXUJNrVE8CWrCaD
 icoNu7Fs1c5hmPHdSTnU48ce67449DdnO4neLSNhRiGlMHJgfJUmgrxu/hcYeOZ3haWmEQ2w
 uW1Mh01OHi8QZHCEyAbABrPs9GUgccc/4eYXX9hIgxfSkYzn8f+8NuIFPWl/0uTvjgqU29FQ
 SbzOLxHq9439Ox40G5mS5eZXRGxITYR+6TXvRGI6P/264jvflnr/pDGUttaikU+0W+1uxgKH
 cmYbEc7ATQRbGTU1AQgAn0H6UrFiWcovkh6EXVcl+SeqyO6JHOPm+e9Wu0Vw+VIUvXZVUVVQ
 La1PQDUi6j00ChlcR66g9/V0sPIcSutacPKfdKYOBvzd4rlhL8rfrdEsQw5ApZxrA8kYZVMh
 FmBRKAa6wos25moTlMKpCWzTH84+WO5+ziCTsTUZASAToz3RdunTD+vQcHj0GqNTPAHK63sf
 bAB2I0BslZkXkY1RLb/YhuA6E7JyEd2pilZOrIuBGl/5q2qSakgnAVFWFBR/DO27JuAksYnq
 +aH8vI0xGvwn75KqSk4UzAkDzWSmO4ZHuahKtQgZNsMYV+PGayRBX9b9zbldzopoLBdqHc4n
 jQARAQABwsF8BBgBCgAmAhsMFiEEqUDUNJksLo6ZED1QIk+n58yCpmQFAmfIHFQFCRYU6J8A
 CgkQIk+n58yCpmS2PA//bqN1LfcotmArgElsa+0EGZSQlYgK48pm8WAeTXTngudP9IJ4SuKY
 HR5RNjHcBeqN+Me0zxRqYzRb8nGanHEkDyf4Im8DQM8d6vbyU+FcPmG4skud4kgS1zMHnlVd
 SXfSIwKC/hKgdHG8aBV7545Lz9X6Iohea+94wneD0aw/hqF+QWewGZhWJriWAZtvEkzNjQOi
 4U9F/trLten/x7bpphDSnDMKJtITbtzATT1Dq7o7VpIUK1nCTQALMuMjKCdi8OdU/+V+R3O4
 0PXWvX8qrvqYapVbZ+9KqT74FsuB0Ya9uXwgBF2Q6cRuETZk5vqaqKxzqoQZCO8AOz/58j6O
 2RHNy/mZEN+7tJ5Tsq42zVJ4jxsT8b9YplavCMsnBgDeRWhcbYhCyttoL7nYISyWg4kQYZ/P
 wIV3OuNv2f8iKYsxNsRuClOAF82+gvqOy1/1pprFjy8uo2pkoOrb63aOP3vO5VHnRKgra6dq
 NcaZ+c6J4H+nEJGi2SkHAUJz5oBzuThvPudLvPA/SK8sKoM01IRxSihev/S/5WLazXB1PGem
 OCbvzC1IjWJJraxiDJ5IygokapUa2RP7+WBR22skQ3SSl6G107QgWKSyTOGWEaRmV53vxQLV
 jXuCmzSSasTL60zq5yGrT4/DYQVSNEUiUbG4pYekxJujNeEDkUlky0Y=
In-Reply-To: <96fa2371-8a9e-8fcb-08f0-2977320bbbe8@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: ux8e7hqtshjykbwhcc6sxajiougreia9
X-Rspamd-Queue-Id: 007E414000D
X-HE-Tag: 1789373804-154043
X-HE-Meta: U2FsdGVkX1/27t1AMZtWLfj1IUPE6TUZUrpH1BMSsDThCM6A51IGOuZseaHBMg3m2Uy4X+NNRBIuwx2NbUBB1lltWNGUM8dxRApWsUbhhLiWD8UN0i6nsqPm933dtGwFiBvnyYfKqNHOGaVBZ8aAimrpmctCT7eZ1a3D13sqI39XbKbptdX7IxnWed+7wfVkPDa70OYJRT933SHTj3/QWdEoPMJyoVc1h6WC7J08DkHZQDaS6vn5IzPkgQRZsYPjPv0lVS/miu1S5IU8Y4KaEfCz9p9PM4kE1ikydGGv4iwOJ7skRc4/X60RQo1fT6FS/CeYbkd3F7v/1DF11RTqcvUdp86DZWFzDDWugdejLvvgj4t2dHqt497ARQuEybgKPqphiS+R5eCEZNXHVGjI43ZUupfyVH5/Fn5ti7jfCOnL6vrTJY/wMD2S1RN+c/pWU8s2fok/Zf6wCBSv6oo7xkRN2zCXFr2MeZT/XsBZU28h9nFDYLLeEioBUPPK44NzyVeZyvq0P9Zn/2GEsrzNXwkAu4GmtJV8BwL9EfZ633vfCJyYGBVjbpp8ffBPQPfYJKF3pQCi06AijP7Du0YdVCIdqx7O4pSeqps2YzRyFrLZ76RvfkkPseXIlCxoFssu/P1l+2CYiNR375cxUeDrn0C++mPC8Pj4mKhTv8IemmwZYgtELZlspPNjfPDPbEnEH47W5VYQkhBT2OM30zsm61ko/Iup3Rq8Ni7GrTpzKGmTrRkAfCxHVTY2RK9mDPqHbchHhEY3RuE0s4zjzcWTyqwG7+HIKmXPiC37gSYvfWNziAQ0R9NEY96Pr+2A/H1mXp0wB4XJa5myoXQVgLb15ZL3MorVE2VKOrGEa9Uf77dMgPyydwjq+K2MSasNGzvjzsjQpYF3UIHQ+nVi87KruWedEkZv2pOmS9K6l8dVpTzNPm/dB4df4inWD34nBGxbJXBYYJCApet3EOu/4Sj
 L/LIv3pO
 ZCpr/tPBad6EX+E7X7uDtmD1iPLx67KXOeaEpnkhma9zjedZir92IrACCcKO5qVMWPaEsHOEEplYSbG4A+PWIBnqCfe4TeSeCRIBu4TMwxVSKZFvvgMXT+2ePbn5WECYDAOwKHAndCCZUDuP3pvRptti8Ac9fPS+rB13xpnLPOYUNUyv619pQar3t7Lzn4Yb25y5iSCccqOFDGn+sfiDGnWqoIDlsvP5l6CwpsCXyASxoABXNM3dAJ6HQHRyZLpma08w1iuA8/8Fmoo2b2qpuz9sbyzzFH0vCzQDno7gNy0QYdGZfmMU1AeusP6w8qq1dAdqk5m5y3UVyNI6aif12BN07GWPDrZAgT7n2LoLB2Ubs4Vk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/13/26 01:46, Hugh Dickins wrote:
> On Thu, 10 Sep 2026, Vlastimil Babka (SUSE) wrote:
>> On 9/9/26 11:59, Hugh Dickins wrote:
>> > Update mlock_folio(), munlock_folio() and their fbatch callouts and
>> > helpers, to do folio_try_get()s at batch processing time, instead of
>> > holding a folio reference all the while in mlock_fbatch: as in folio.c.
>> > 
>> > But more interesting is the use of mod_mlock_count(), using try_cmpxchg()
>> > to update folio->mlock_count safely when possible (now when on lru_add
>> > fbatch as well as when unevictable). While __mlock_folio() is as hard to
>> > think about as before, __munlock_folio() simpler because munlock_folio()
>> > can adjust mlock_count itself without clear_lru() or lruvec lock, and so
>> > do the folio_test_clear_mlocked() immediately for itself (without which
>> > unevictable_pgs_cleared was likely to appear high, when it should be 0
>> > or low to indicate good mlock health).
>> > 
>> > __munlock_folio() is safe for use even when the unreferenced folio has
>> > been freed and reused. It appears that __mlock_folio() could affect a
>> > folio which has been freed and reused, but only if it is reused as an
>> > mlocked folio, in which case its mlock_count is spuriously incremented
>> > (but usually a spurious munlock decrement will follow).  How grave is
>> > this? If unevictable_pgs_cleared remains low, not so bad.
>> > 
>> > I've gone back and forth on whether to move mlock_fbatch and these
>> > functions into mm/folio.c: for now they stay here in mm/mlock.c.
>> > 
>> > Signed-off-by: Hugh Dickins <hughd@google.com>
>> > ---
>> >  mm/mlock.c | 147 +++++++++++++++++++++++++++++++----------------------
>> >  1 file changed, 86 insertions(+), 61 deletions(-)
>> > 
>> > diff --git a/mm/mlock.c b/mm/mlock.c
>> > index 2c690f18031e..1050010bbe0b 100644
>> > --- a/mm/mlock.c
>> > +++ b/mm/mlock.c
>> > @@ -58,6 +58,20 @@ EXPORT_SYMBOL(can_do_mlock);
>> >   * indicate the unevictable state.
>> >   */
>> >  
>> > +static long mod_mlock_count(struct folio *folio, long incdec)
>> > +{
>> > +	long mlock_count = READ_ONCE(folio->mlock_count);
>> > +
>> > +	while (mlock_count & MLOCK_COUNT_0) {
>> > +		if (mlock_count + incdec < MLOCK_COUNT_0)
>> > +			return MLOCK_COUNT_0;
>> > +		if (try_cmpxchg(&folio->mlock_count, &mlock_count,
>> > +				mlock_count + incdec))
>> > +			return mlock_count + incdec;
>> > +	}
>> 
>> This never rereads folio->mlock_count to mlock_count inside the loop, so it
>> can spin forever?
> 
> You give me a nasty moment, have I misunderstood? Isn't it part of the
> try_cmpxchg() contract, that it reads folio->mlock_count into mlock_count
> when it fails? Hence the "&mlock_count" rather than just "mlock_count"?

Indeed, sorry! It would have helped if the contract was spelled out
somewhere. But now I found it only for the atomic_try_cmpxchg() variant.
Guess I'm too used to the slab_update_freelist() wrappers which don't follow
this... but maybe should? Hmm.

>> 
>> (too late here for me to understand the rest today)
> 
> But that I understand very weil: thanks for all that you have managed.
> 
> Hugh


