Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 972E2C9830E
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 07:04:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3C126B0096; Fri, 25 Sep 2026 03:04:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A13616B0098; Fri, 25 Sep 2026 03:04:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 929756B0099; Fri, 25 Sep 2026 03:04:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6FD0D6B0096
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 03:04:50 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E1C5C40541
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 07:04:49 +0000 (UTC)
X-FDA: 85251397098.13.E14A905
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 13927100002
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 07:04:47 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V52F8MgQ;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790319888;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2R8jdNeSaYTQ16udVa5y7SwjDq151umXysfrxK7mNdI=;
	b=C0Ylxu+nlGIfWqj0PAzXNeaR95tMDgzTI/++AQx+wEeXatlbz90GrzQQNlVafWkzNo3E4K
	tIfMgYNFE2aAj9gFwd2cdb+I783AwJ8f1mYAep6VamET/RUEF2bBR1hoPsZNSDoN37VjjR
	Jz7eCFoOhhvbwAetPNcWlHnn54PcvPs=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V52F8MgQ;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790319888;
	b=HdvndatshinBkqQJrlKTiWH+ZK3Z4bf88509EiYW0/mbhQH8LSY3cZPEdl0KoW95NmYXyq
	ugcDgMZMPrzO9JrWyo8MmJt3ezI2IAjnPPpvnJIHKeX/5OjIPKCu2BgfGyNQKO2A0xMNqa
	TIAHDXq/yeqImvj810klyg8+FNdH6R0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5358043F63;
	Fri, 25 Sep 2026 07:04:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E7A01F00893;
	Fri, 25 Sep 2026 07:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790319887;
	bh=2R8jdNeSaYTQ16udVa5y7SwjDq151umXysfrxK7mNdI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=V52F8MgQ20KUBOmKrAhaGUJM9Z4YWg1Tl6VFjhczV6hH8DMfMdkF+KoS4ueEUUerw
	 ufNTZhjdv92yy+ALpgu0sU0ryigCRt8Og+yRwxG8CMzjl3kqHPerkN7EJDEttUEY5A
	 zPDDyqeglEIkcvX32JrWA2CBiX316hug4Efd+nVaRcRhULAgVtAq07dSjFdGD7JycT
	 gXpy91I/RtYYjSx0vWE+RIGsAisvxkTt7IAXideVvb6oC1Qry2G3zsTiRYJdwVXqvD
	 ncqlR+Pt2ptX7HYuxO/EM9smmCXxnDJ/3KarbavB3od8DfYBxV+l6/q8vy6nPzNTMU
	 89sTcP+vWNSzw==
Message-ID: <9f63d60c-913e-4e79-9d28-890dd48ef713@kernel.org>
Date: Fri, 25 Sep 2026 09:04:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [FYI] DAMON and virtio-balloon in DeepSeek's DSec paper
To: Lance Yang <lance.yang@linux.dev>, sj@kernel.org, mst@redhat.com
Cc: damon@lists.linux.dev, linux-mm@kvack.org,
 virtualization@lists.linux.dev, ryncsn@gmail.com, kunwu.chan@gmail.com,
 lianux.mm@gmail.com, baohua@kernel.org, xueyuan.chen21@gmail.com
References: <20260925054408.10431-1-lance.yang@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260925054408.10431-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: msdqppzn9psahuibgd8q6k64np1kbjzi
X-Rspamd-Queue-Id: 13927100002
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790319887-425329
X-HE-Meta: U2FsdGVkX18EkTgJ0uzJqjVCUN1jN+S5x9HhbXWu2MUD7qfXR4drOq4ZQUfT1q4kRh1/q3daw5eSp3EWS9+CDYAptr/zRanN9S8Ek4mHX8/RPpWHu1F8XW41ILKt8YYTjgZqFDVOIPAipRzib0qgg94Pnf+OqJpcwFTaeq4d6BlPiCAnCmi3DNzoNPj8oPCO6REyBLrZuHXnxcd0VookuFue96CqY/QXr72432kcFsMQQmHuJkU+CmZNB12HCc90SGs/0VQplmcg6zhzJR6HUg0oFfmTMpanhbKMRoAudD0UgcP4kyvYTGYcpg6vo98r076ymtJG2XrIrxUZqf+Iu8ALjNbmfnysjdrSVfiv/9msEW5M2O88Ij7pdcD5U3SUKlTUMZxAQX3COMhbIfUiURc/by4uAPVEg4n9xtzGMzmztWU/igF4VKYJCAyOWfht5sOurOfTqrT74H9upqsLHFzFBnFLEHR7K4dU6Ql6d+ZNLTB7tW3omlufywojx/wOs3ojT0JQE70X5Hu7lhUFYONXsx9lviVEh9QmrVN5uXqUQ8YsG93nK/obP7agYtfX6G7NDApA9Ymqd5G64/XoYoV+eTsUkxbG0s2OTWtjNWitsHEzTQgGDIikGcSjjPuTgTjUHapYix8W4fp93bVW6g+KYR/MCLOoSS8jbQ4b7Trg8jZSI5UEWmiL+i+WS+58Qkrq1/f1mDs/zPkjsluIYihLyW/F31ZXpyE222fAC01dH5aviiWc0v2JF+cG4al7wrLL3aqpmzWrL7CqYfKB7HCnCgO/rSq6U2YW2dvAHh75d5AVqTeRd6+9aHSCkXPB3pNbygT6rFNy0kXI472Rukt22frRLg++fdzh1y9HkzpFRzGAI1uurXheYMyry7PKNpxGvDIThzICSAyLK+ENuJGSmpagbacYG/KHicgQtUJuFmN8jcTWjZ7uwn8hA15N3D2vdH/O1pQHLCx0Gub
 fU0ttX2Y
 Gnxy/8fgb8Wyz2AaeQyg3xeEbEQGK48l+RGeoCPl1eFFtDSb/ztZicdM/+rnj++xTJ+MwFDf5XOEr8yx/YTesy2q1mGkXMd0z922RuWpItUxjhW9W/VijcP2z15UQEVAmwmIc9Wc1kgGkVdCCmuGlbBrJxJaKjeTzq9snXpusH17yRhS9uq+RYsiOOj5/z/DfX5EViSDOUf33G3Kf44s6kCnUEk1ye7o4jxORzUYdw7Lc5OHfYZTGjqc/XnrmymO9rSCESMgq00LGwABV0BijKB/aAZxWd78l51i1xGVA0YuNoFE4wfeHlkNH3KnM3dP/TzXuRwStQIrnxt4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/25/26 07:44, Lance Yang wrote:
> Hi all,
> 
> I was reading DeepSeek's new DSec paper[1] and found a nice use of DAMON
> and virtio-balloon:
> 
> With this kind of workload, an agent may read a file once and never touch
> it again, while those pages remain in the guest page cache. Without memory
> pressure in the guest, they can stay cached even though the host would
> like that memory back ...
> 
> The trick is DAMON + virtio-balloon free-page reporting :) DAMON reclaims

Heh, I read "virtio-balloon" and thought "balloon inflation/deflation, what year
is it?!". Free-page reporting makes much more sense.

> cold file pages from the guest page cache; buddy gets a chance to coalesce
> them into reportable blocks, and virtio-balloon passes those blocks to
> Firecracker. Firecracker can then drop the host backing with MADV_DONTNEED.

When I was at RH we were looking at this issue as well. virtio-pmem was one way
of avoiding the page cache in VM entirely. But it has its own limitations.

Thanks for sharing!

-- 
Cheers,

David

