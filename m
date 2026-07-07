Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3422FC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 09:27:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06AFE6B009D; Tue,  7 Jul 2026 05:27:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01B0A6B009E; Tue,  7 Jul 2026 05:27:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E25326B009F; Tue,  7 Jul 2026 05:27:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AD87A6B009D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 05:27:17 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 47EAD1A0370
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 09:27:17 +0000 (UTC)
X-FDA: 84961452114.30.E7F2081
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 89B091C0009
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 09:27:15 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gWOo6k3R;
	spf=pass (imf21.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783416435;
	b=Ft55VV5DsQzkCrRP1rApml8yhA1YoOT7OiVo0JE8YIshjpCXHsiaMjmaXR4GZYEFkPHW6W
	nT/CO40/+5xjhcoinGGXz+K3cMiGNtPoTE8qLCYRONfZGRprKmb0cESdDQeUhi0ROfRUIW
	/noaQkVoYr5vCAnTWt8O+cU7wa7JdJs=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gWOo6k3R;
	spf=pass (imf21.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783416435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xyxzpiw3OM9UElk+MAeq0fkOAFAIG6DAhu3VfVnuM6I=;
	b=aXGb4GMloR7Mh5IGbQ9m6ANv18bi/UwyH8ZRIY79tExjIBCRkEQLBkD5ZpJnpUCea/qiMC
	3ZKr+nVIdPeN6zBcfqVOmzPSmvNRS3g+kgHslAL47JoOm4Kltgh+QM61Az4LrlDKLiTcOQ
	dlLXbH4whaKV7kZ3Lzv/QcV/aaOz/t0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 05F2A618A6;
	Tue,  7 Jul 2026 09:27:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 996591F00A3A;
	Tue,  7 Jul 2026 09:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783416434;
	bh=Xyxzpiw3OM9UElk+MAeq0fkOAFAIG6DAhu3VfVnuM6I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=gWOo6k3R34w9fw1RtN344zs/rlFr56g9/JuFLeuvFXmkLRS3YZFcB1AToHyj0dTTW
	 PZffp/rgtQJPiJkwIVTtEjKQ1XNw9ZG9LHGTTG7MQZ5MmlS9dpCMuNiIrjVPPL5NV2
	 xN1vz7p5mcxYGbncfuT3GfQv0lJoitPFvCy45WuGJ4tTZn1jpypDERmwq+NaCc/xEx
	 XfZSlvdLziTtvDRtR5awfg+iBfirteTy6H4/0fT3qJ4dTGsVfQp032G5SX0nKNkHdQ
	 wlIOyCusSe7BGlaMFd+yTmXEtLgOuw78+k9dsyuvS/AA499nIDc9JtbRaYm9a8zO4G
	 iXzmSftTKyAZw==
Message-ID: <84c4c2bf-397e-461c-b898-482d1a49f40b@kernel.org>
Date: Tue, 7 Jul 2026 11:27:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/slub: fix lost local objects when bulk remote free
 batch fills
To: hu.shengming@zte.com.cn, harry@kernel.org, akpm@linux-foundation.org
Cc: hao.li@linux.dev, cl@gentwo.org, rientjes@google.com,
 roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 zhang.run@zte.com.cn, cai.qu@zte.com.cn
References: <202607062139095043SOsLi6TIf403tcjPf8fm@zte.com.cn>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
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
In-Reply-To: <202607062139095043SOsLi6TIf403tcjPf8fm@zte.com.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 89B091C0009
X-Stat-Signature: re767gpg16ud6tp5kbtrp15db1fie1mn
X-HE-Tag: 1783416435-850327
X-HE-Meta: U2FsdGVkX1/+TlUfZt5cOYmuXE1gcyNBbzTVgnI/IwENpQVW4sSEXFpYrgv5kVW5ShjewrlinVaV8v0Xk/WQ6was56Tdi8d1JxUbdjRhsM9dZP3x0f656zFJDRwbe6UTZuWmOpaXU5GmxRtKzSqCCy6shJuYM8xxtvaSfejx9Vmv6/4mTcIkShCje+FKJTad01VoEQ93zXyMrnzmgrqpHok2zXxdPh80fUviZK6lHtvb87J6btsaIQ/eu2hELZ1h74xfWKLIcBy+R43hHhgJIIl6+82LghU658qAAtOTKhz/ft3v0XLhPqJCSnqwOXiwuCEZyAPsD8ilHH7i/ljQGITIBSEBwY3kj6tLR9Rv6Qjif9hGIwf+uRH9jFhZUVdg997WKpVE6uErvcXxaVxmi+WtoANMlbcDMAhNvk1DGLwKbcFCG4ad85DQzWfsmzzHIf9II8plplOiGzSlwrMtVpRm/D4eeiyFTgOf2bCxRI2yw/sXJ7UJxAIKTEBBEJ5NGtSoh4MAU8rztEFGIYuHI9Vmge5vU/WNh3p+2hHhAdASuP0XP+dCeFeSzeG7ZUu13OXXpmL7YZonMCSPGWwWSb3a1MDhzmj4h1vo+ScjYQnDSeUM8t53d0ZKAHQBaUEWzD+heBUAIN1z3quIp6S6OiQXKoXqdj4z3l1NlpfthQIwuWey8IVUAhqTpifQL6aEWgtCQ6L1H8FaTB3tEU/5SzsD6QR+Uab6MoPW8OPCT+KD5rbivaB1Ys3OZcgTXDpGTzyHipyAL4B1whdKCB4/WqNpY/6ihdH9Nbfo1w14L74wW2KAXFmQ4HC/U52ygbOnUFVM3Twr0stuXtTSIsmCxhpm78aUjtw7lTDzJr6EzqxTBcQMXAqbO7xBMb4KdfSrdPBQObwqSNJIkYI520Gx5ij01skPnfB+Cs2VNfMVXm1nE23i9V4vt0qwaRGsfi6/utUKlfDJt7SzOmyIiwF
 LOLhKkx0
 Trz4TP0KRbsoxY7HjQBp0FC0uqu/bACXa2whjxwl0R18JSn9d6RLzXRsYRz3M95dWSm59Ov7qItxNujb5LiLPLB3ZM92UyUvXEKrQbBginH3zCHWen5RZMBwtegXzkMR54cYGVhY70XyneoeadkMQV0SF5C3OUqGoyBo1XOiwcIjh7L8X5ymSKx36FNeU3dUFeGJIrqNWB+AfSyQus07O69HBJohgixEINTZCzkmqgWeV/IwmClcapLoaN1v8ipwX9AShUhZica21MUiMfHytG49WMdVGrrkKbTBx5mlWRGXR4ER8OBvsmcMGggYFAr18tzinELpmegrwFFjFX5Eyn6bPrQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/6/26 15:39, hu.shengming@zte.com.cn wrote:
> From: Shengming Hu <hu.shengming@zte.com.cn>
> 
> In free_to_pcs_bulk(), when remote_objects[] fills to PCS_BATCH_MAX,
> the code jumps to flush_remote to free the batch. If all remote entries
> have already been compacted out of p[] via tail swaps while local objects
> remain, the flush_remote path returns early since `i < size` no longer
> holds. The leftover local objects are then neither cached in the sheaf 
> nor returned to the slab freelist, causing a memory leak.
> 
> For illustration:
>  size = 64, local objects at p[0..31], remote objects at p[32..63]
>  After scanning all remotes: i = 32, size = 32
>  p[0..31] local objects are dropped.
> 
> Harry pointed out that, although the logic contains a real leak, it does
> not appear to be triggerable with the current in-tree users. To hit this
> path, at least PCS_BATCH_MAX objects, currently hardcoded to 32, need to
> be collected in remote_objects[]. Looking at current kmem_cache_free_bulk()
> users:
> 
> * maple_node has sheaf_capacity = 32
> * skbuff_head_cache has sheaf_capacity = 28
> * panthor and msm drivers have sheaf_capacity = 4
> 
> The sheaf capacity is, at least for now, derived purely from the object
> size, with the user-requested capacity used as a minimum. Therefore, among
> the current users, only maple_node has a sheaf_capacity large enough to
> reach PCS_BATCH_MAX.
> 
> However, for the bug to trigger in maple_node, all objects in the sheaf
> would have to be from remote nodes. In that case, there would be no local
> objects left to leak. So this issue was found by code review rather than
> from a runtime report, and it does not seem to be triggerable by current
> users.
> 
> Still, the bug could become reachable with future users, a different sheaf
> capacity, or a change to PCS_BATCH_MAX. Fix the logic by freeing a full
> remote batch in place during the scan and then continuing to process the
> compacted array. This keeps all local objects on the normal fast path,
> while the tail path only handles any leftover partial remote batch. The
> redundant next_remote_batch jump label is removed as well.
> 
> Fixes: <989b09b73978>("slab: skip percpu sheaves for remote object freeing")

Removed the < >

> Signed-off-by: Shengming Hu <hu.shengming@zte.com.cn>

Thanks! I added cc: stable anyway so we avoid unexpected surprises in case
something else is backported there that exposes the bug. And the fix is
small enough.

Merged to slab/for-next-fixes

> ---
> Changes in v2:
> - Incorporate Harry's detailed trigger condition analysis (thanks Harry)
> - Link to v1: https://lore.kernel.org/linux-mm/20260704160450302fnznThT3hBeBiwlhE-oGv@zte.com.cn/
> 
> ---
>  mm/slub.c | 12 +++++-------
>  1 file changed, 5 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 9f754cf1c187..4d7e3067a5d6 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -6193,7 +6193,6 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
>  	void *remote_objects[PCS_BATCH_MAX];
>  	unsigned int remote_nr = 0;
> 
> -next_remote_batch:
>  	while (i < size) {
>  		struct slab *slab = virt_to_slab(p[i]);
> 
> @@ -6208,8 +6207,11 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
>  		if (unlikely(!can_free_to_pcs(slab))) {
>  			remote_objects[remote_nr] = p[i];
>  			p[i] = p[--size];
> -			if (++remote_nr >= PCS_BATCH_MAX)
> -				goto flush_remote;
> +			if (++remote_nr >= PCS_BATCH_MAX) {
> +				__kmem_cache_free_bulk(s, remote_nr, &remote_objects[0]);
> +				stat_add(s, FREE_SLOWPATH, remote_nr);
> +				remote_nr = 0;
> +			}
>  			continue;
>  		}
> 
> @@ -6293,10 +6295,6 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
>  	if (remote_nr) {
>  		__kmem_cache_free_bulk(s, remote_nr, &remote_objects[0]);
>  		stat_add(s, FREE_SLOWPATH, remote_nr);
> -		if (i < size) {
> -			remote_nr = 0;
> -			goto next_remote_batch;
> -		}
>  	}
>  }
> 


