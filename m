Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D92CC606DA81
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 09:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HaiW9F+N
Received: by kanga.kvack.org (Postfix)
	id EAB8B6B0664; Tue, 24 Nov 2026 04:49:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5CA86B0665; Tue, 24 Nov 2026 04:49:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D721B6B0666; Tue, 24 Nov 2026 04:49:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A7DF56B0664
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 04:49:59 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3915B1A057A
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 09:49:59 +0000 (UTC)
X-FDA: 85469541318.05.4D0C540
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 6A74520002
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 09:49:57 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HaiW9F+N;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795513797;
	b=QWQfumZSgaDIqW5S+OAKqbFXJWXIT/s4MUD/wbTvki8iZfKxSgr3TaFYsEJQQsPcuEYlQb
	0ruBylxrMmaExkUtbKwWZBRN/Fcj5phh8H2rqlx5wHOSuxjLjKx60qiWNhoc2+ZouiyZbN
	hLGfWG3RdU6uUEnCQRg6eHrgZRfZDvM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795513797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=reUGuo+ujbiHH1pvSPihUh3BtOf2xLUPR5B8ZOYkGlg=;
	b=Ccn35xlYS3w9yz8lksjyeGCqnSCKvu5BJ+q1AhljR5dh67L5ju3PEvgIgjxebjwY7k+i+7
	PA3EmAP/R1jxWnJ/9Vm6qtmouMpD8LKMcnfH0b2+iVHcod4o9a+YYxvA5JTGHhsBy97R5r
	JLxjMIrsSWVlqc2H8+rlRYFpfcvGhAo=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HaiW9F+N;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AD9E640C1B;
	Tue, 24 Nov 2026 09:49:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 032691F000CF;
	Tue, 24 Nov 2026 09:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795513796;
	bh=reUGuo+ujbiHH1pvSPihUh3BtOf2xLUPR5B8ZOYkGlg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=HaiW9F+NKVAhJxL8XzVEL6EUKwRPiErG5y/LbDmuadChRjjUpgsqr0l2tdHOEXL0x
	 NH/6oc2yeA0YtY5tmm9URMt9NtDi7VN0GKPcAc0/xnZ19C7MHqjoBjpqMRhmLgBbcc
	 fJ4dDI84JdGgpj4LKzIQaeQsLbLe48wMtcpj/2v+KprL9q9Zwho2Gn/Rlra7xbi7g+
	 JYcX2IP4n2UcrVoFO5nnFYvDOLQWQZhfeEOYFiG5dZ3tejzzvqzaYxaBg+1ke6QhDl
	 7NrsQM7t/0xmJ73H2hsyIVIv+tk+HcqxZXlVImc8g4BA/R8T3NGkTVioa4bqZWZwQ6
	 aeSw1rPSn0Wog==
Message-ID: <7ebcd1fe-8a98-4c12-9508-0399570e6a6d@kernel.org>
Date: Tue, 24 Nov 2026 10:49:53 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Using In-reply-to: <patch posting> in mm-commits mails?
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>, mm-commits@vger.kernel.org
References: <9ba54069-3dc4-422f-8cf6-f81cb806e999@kernel.org>
 <20261118212538.7e6f11f0553d548a03c9c456@linux-foundation.org>
 <b7474fd4-eb88-4472-9e8f-26ef6c646694@kernel.org>
 <8691815d-1c62-4519-907a-110b2d12b9b5@kernel.org>
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
In-Reply-To: <8691815d-1c62-4519-907a-110b2d12b9b5@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User:
X-Stat-Signature: yb7phzh9gnoydane77bsc316tk67wakb
X-Rspamd-Queue-Id: 6A74520002
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795513797-502539
X-HE-Meta: U2FsdGVkX1/lz8Z5hGfpD2UH8FDLlFEpcP60nf2XLgAhePoSlHbymIOItp//f8fKwPBHn0H1jUjRWnUquJ+UrLpBoelOpJsnLSPUQfNxRTAmxCtxWlp13GoxuJgKpSSecgbh99acbWpmE9ZzpOTO3n1dq85RV/NyVLEE+GGc3hBDDeix2FW3evBMNqFbq+ftx2Gklua8IfzNr0+nj6MHouTRs4Uvl6o/YkHsNDCrH4SMxYocIFB4gFygNKYqxuDpe1ykIjoVi2RkbjiUgQJ0hrXvqyBiJTKNawHbZkdFSz/eSUKME3qLsIRyC8i3hzzW+eB1i2CZSO8t2P1xrlHXzllD8TZFnIov14aFEz4KVTkHXnXqka4hfYcXzkVB5zIB8aJPyWxs7F5JvnFIut59N3FrUsnE7lmIhwT8z2l/yz16BktxCmKUuo5fi5iDXjt+OzLKX/AqNBBU+BaWkh4cPyTy0sG9iOfwfMwBqHD4ZFCcD2BMjE4caRcEOnIu56szymWkrLynoTq/ll/3Ddp+lbJg8VEADrZW60vACOS+Zwzqo5gSRrO3RPfdvsNbJiEsqkfhn0jafpjfDVvJDwFI8q5GOu+Nmu0+naa37/ECMwxS1DiDFQPMd1oH1cJ6LZIi5nGb2QcFAHq9iOUjyX/c6sy/lj9RwtgSCQEgt9vKjhMlI34TDWTq+qZa/MppCUACTnyVUUHeBA8EsuIsoQrKeBkXO7aTctPAXp/iVne62GXutQFe6FMSIXEB5HEosnYUpBvwbm3kZQet0mHnvroLS4fEkYiJkjzNmX9NXgk+JsnTAEYqli1/Bfx7A7ANsl15Pinbl+uZwJEGvH6T3ABIoj735vFPTc7gkqFt7nTCrTOjy+AeuWN5eApBiLB882InpbpfBAEadIW3bq/cbGyIVof1TLbRLHPryc8iX83eLT+IxHFc8B2VEYmj+W8ewUZo8ENbR6sCUsbzHiXkoUz
 B2lfkAvH
 Sb2+q4SAhZh6zgehpreqryQTIYlLzpP8ooqmEFSKAqEUgFxBbKzkeYV5l07vpDZIP5qt5MuR8P5Zf9tAvxVhuxlHFDZKRyOkhZe9IndW+6nsCMDyXwiBos/7RT57Oowr7ECX2Z4isTPGpPj03L9G8uQGV76n+JUeF82/5TFPwtKsO219dsF1SONGfb91Z95dLud8W1P2saVogiYDqV0Z5LzjzUs/BipNV7xku4nP5+Ly6znIiuambJcEaPaCW9+ZYFU8M48Z0QrXe+w/M4AeWFq6eXdXmTK4d3KkFw/0wf/UCYnR9dxB65C596eLPt2xNZDAG5dKizs/TYq2+CugRAHK48ETXAkb0xP4CUHXJmRXCexrCKGd4wM3ZHw+pfOoxtafuXHT0nNWS+Fh8/a6my36wzwxnSJ9Rmbbh4fMa9MescTfptkWGzKy15DdTuLwojOHJL303D+cCqL+eRXy2Fzw4aocI6qWMbCukI3fhJmmn1zanf6aZEvWo7BYoHncodsgjNgEcZEfUu8nu3BknjbKWd1to1JD9DtyorJBcpjUvYlG2Q+MVc1gt39EJw+5zKL7dCcsFGogqzVAPb0vQ5qaJOCkB1rg6ippND3BdNAqjiufEA/OVlD4xhDA/+0PmmeXk1q7w8O+MmBJVgBMGfQ9yCJqo6AWW7fuz6PKrYk6KGm4JYhm1JP54/sPmc4oDCqczF3MlNdM1wyFMDBEoR9S/uuZP/H3o/1nKjE5lxrQIVTS07SiENQ3Ucq14ko2YXLzUS/cbqvTc5ISYrPFiPM7tST0+R1Bps2GaBYhOfO+1makSFZq7BglLOR/ilr6yjQ2mOOFxv6ZrNoj3+3Mw2LIzJ0kaDqtRrixwu17+wzN4/IwJd9s3EqhEkg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/24/26 09:22, David Hildenbrand (Arm) wrote:
> On 11/19/26 11:07, Vlastimil Babka (SUSE) wrote:
>> On 11/19/26 06:25, Andrew Morton wrote:
>>> On Wed, 18 Nov 2026 11:21:47 +0100 "Vlastimil Babka (SUSE)" <vbabka@kernel.org> wrote:
>>>
>>>> Hi Andrew,
>>>>
>>>> during some chat with Lorenzo, it occured me that it could be useful if your
>>>> mm-commit mails (addition, merging to mm-stable, drop etc.) were replies to
>>>> the respective patch postings, which would put them next to the patches in
>>>> everyone's inboxes. I think Lorenzo started to doing that on his receive
>>>> side with postprocessing.
>>>>
>>>> While I haven't checked your scripts, I naively imagine it shouldn't be hard
>>>> to add that In-reply-to: <msgid> header. You already have the msgid for the
>>>>
>>>> Link: https://lore.kernel.org/<msgid>
>>>>
>>>> part. Maybe it's tricky when there are more Link:'s than the patch posting
>>>> itself. But actually after Linus initially hated these automatic Link:
>>>> additions, he later settled on the Link: https://patch.msgid.link/ template
>>>> as acceptable to him. It's sort of documented in
>>>> Documentation/process/maintainer-tip.rst too. So changing to use that
>>>> template should allow to easily grab the right msgid to reply to even for
>>>> later actions on the patch, than the initial addition.
>>>
>>> np, that should be working now.
>> 
>> Seems it is, thanks a lot!
>> 
>>> I switched it to patch.msgid.link for just the Link: to the original.
>> 
>> Yes "just to the original" is what I meant.
>> 
>>> Konstantin's
>>> https://lore.kernel.org/all/20240619-docs-patch-msgid-link-v2-2-72dd272bfe37@linuxfoundation.org/
>>> was helpful.
>>>
>>> I hope patch.msgid.link is durable.  It's owned/operated by the LF so I
>>> guess it'll be there for a while!
>> 
>> Yeah. After all, the same is true for lore.kernel.org :)
> 
> I works but it makes b4 go nuts when I try to pick something that Andrew picked (too ;) ) early.

Hmm wonder if there's a way to make b4 filter those out, or we ask
Konstantin to add that way.

> 
>  b4 shazam -sl -S https://lore.kernel.org/r/6E11B4A6A6E0DCF9+20261123030904.57369-1-zhaozhengzhuo@uniontech.com
> Looking up 6E11B4A6A6E0DCF9+20261123030904.57369-1-zhaozhengzhuo@uniontech.com
> Checking for newer revisions
> Grabbing search results from lore.kernel.org
> Analyzing 3 messages in the thread
> WARNING: duplicate messages found at index 1
>    Subject 1: + docs-mm-fix-stale-split-page-table-lock-references.patch added to mm-unstable branch
>    Subject 2: Docs/mm: fix stale split page table lock references
>   2 is not a reply... assume additional patch
> Looking for additional code-review trailers on lore.kernel.org
> Analyzing 0 code-review messages
> Checking attestation on all messages, may take a moment...
> ---
>   ✓ [PATCH] + docs-mm-fix-stale-split-page-table-lock-references.patch added to mm-unstable branch
>     ✓ Signed: DKIM/linux-foundation.org
>     + Link: https://patch.msgid.link/20261123053858.BC7241F000CF@smtp.kernel.org
>     + Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>   ✓ [PATCH v2] Docs/mm: fix stale split page table lock references
>     ✓ Signed: DKIM/uniontech.com
>     + Reviewed-by: David Hildenbrand (Arm) <david@kernel.org> (✓ DKIM/kernel.org)
>     + Link: https://patch.msgid.link/6E11B4A6A6E0DCF9+20261123030904.57369-1-zhaozhengzhuo@uniontech.com
>     + Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
> Total patches: 2
> ---
> Applying: + docs-mm-fix-stale-split-page-table-lock-references.patch added to mm-unstable branch
> Applying: Docs/mm: fix stale split page table lock references
> Using index info to reconstruct a base tree...
> M	Documentation/mm/process_addrs.rst
> M	Documentation/mm/split_page_table_lock.rst
> Falling back to patching base and 3-way merge...
> No changes -- Patch already applied.
> 


