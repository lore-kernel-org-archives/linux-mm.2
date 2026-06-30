Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C777C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 07:30:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6365D6B00BA; Tue, 30 Jun 2026 03:30:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60E206B00BB; Tue, 30 Jun 2026 03:30:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FD5D6B00BC; Tue, 30 Jun 2026 03:30:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2CEAF6B00BA
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 03:30:49 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B41A51A03B8
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 07:30:48 +0000 (UTC)
X-FDA: 84935756976.21.D0AAB74
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id EB37418000A
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 07:30:46 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EE3n0kau;
	spf=pass (imf06.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782804647;
	b=wdemaJGJr8T9HgT+dZnzS0nCpRwQF7GCyCW8CDWURn6mDBgIQLbOV3awRZ1eeW/rhupsd2
	SHsZPGKEmOGGHn6aPF16TwkRX9qsTy0mWRO52W8pjx8z8TaiGbbLJisjnsqlcboseNT7lt
	3Z2NKry8Up/rZLokyT2DAThKW6MEcnE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782804647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aYfJUFaTOyFOcoxITqwdEC+0xWofxNWvq6nxR+zhb5U=;
	b=dLGfgQeLn5oHsiqCQfq7XuJaEbDMeXzBYo+uLZKO1bFm8GBz4/uF4nuu1hrO0zlOmrGtZe
	VmRx8VBtHUsj9eW8TI9e+kSSh+JVKOD8VXb5NinpRkkkyB3wibBQNI35zbFJiOy9g+0ytW
	1K33K/vWFHVSkW45LQhf98W/3PZqAZI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EE3n0kau;
	spf=pass (imf06.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 66925600C3;
	Tue, 30 Jun 2026 07:30:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0053A1F00A3A;
	Tue, 30 Jun 2026 07:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782804646;
	bh=aYfJUFaTOyFOcoxITqwdEC+0xWofxNWvq6nxR+zhb5U=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=EE3n0kauPqhVKr9TxRm30FJdfFFqyKH36tH8h9mW4eBcMoikc2cB85CBk0KQk6qW1
	 CQbHB9wnDq+Ay4JOaU0SGbQFWt9U87shatZYVeJJgXWWdYaAOdem/KGCfL9xe0xrQJ
	 XN+oMuItztoMbK/2Om/mJme2CIwUf5r4xlgtdySfx6XDB/WV6MsnQ4ZqR8YDXAtDXq
	 1oRx2XfJyBE8FtbRqApRxF35g5hYQOdOQZPEkmDhsCe1qCyyw7t2ivZtU8eSKJhJPx
	 wlHjy33kDEFmL5d/o3XhiN8AcoQnlEnZ8VedhTFc4b00z0uEQpf7Mj+IzzHhGnLLtt
	 ncm+Anzl7a9uQ==
Message-ID: <102120c6-e560-4f15-b863-375d45af0ace@kernel.org>
Date: Tue, 30 Jun 2026 09:30:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/7] mm: use enum migrate_reason instead of int for
 migration reason parameters
Content-Language: en-US
To: Ye Liu <ye.liu@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org
References: <20260630015331.147174-1-ye.liu@linux.dev>
 <20260630015331.147174-4-ye.liu@linux.dev>
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
In-Reply-To: <20260630015331.147174-4-ye.liu@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 8gatkrzcrwmsa4ngk7b6drkzhu93x4s3
X-Rspamd-Queue-Id: EB37418000A
X-Rspamd-Server: rspam06
X-HE-Tag: 1782804646-236245
X-HE-Meta: U2FsdGVkX1+FeJeVZ1v+sx/v+kSariJZIrl6J3HpQAWUDfnVu+pGgYUNbCiJxt2f0TQNFFQie/MZXS1sOKWervpC4Y1QnQvhVETJ+kYCwxJ1qrAlniKG+MD8glBhOul8OCYd1MDDiFGAegChHFjzJixOSDpZiV90VA6fgLJKPZlnVlRoLz9W4BKeaeuXMBKZjuF+zrVIUdZhwwBMzgA+gNj674lIszera8B1vJ6JtT85VQBriIKtMY3/2tAHGuvr37JZsToF+/MFfXShfzjcfyOkJ9jDvmWA8+OiG0BSeG09Hxla3uLyz0OB4cXsnRlFkPwFG1ZnD9fKqwt6Hy/iig5Hya0Xw7jOdRxItmR+riapF9OxKZU6BmGFqjZsGaZT7B8Jk9Pzg5OTOLc+Ww+NTySVP2ZQVu80AnyIi6FwvGyfIRLws+dY+/XaadtGqCbZTxNOnpISkTFNyC4yY05B78+Ey1rQai3rrWj/BSMbtaHNOKq1Bt1dV67h69FUuDG/ZXtEHzc1Q0DvVSmOJSMa3LgcGYXW3OSoxNJsCA3qr6AvuzP5NEb4NS76O3IguSx4h5hoLOAstgvvP6ApejLeERe7koxCyzy0xr3UFJqxMGtaJBs2wOL/rMSibTScQp7i1WZn111vrn9jA/HwPJ67X9KdxukWUwgRYbB0eFdsOa4G4lyjVUeFsq+l0+6AGhMW09PPsofxNUkzKKAI2ls3HUDlqVw0x/lmCJY0QI6c7pf2mzZwcT6rO7oMmLEHZOTmeNYce3EBexyyqPGvuqeQKQcggUPEBASGwD7qlSqj6Zahh8tJSIS8p3xJt0v/Fth7H5JtgM7/OeK+g81bgCPJELLWf23AFSqKv3uWjq2Qtz43nzGT96cltd0rG0YnKVNw+Qz9ZOiE1QoFobzeb6TZFaYPMlm7SOEkktuuj+QO4ZbVs8rlRjeI+azRz5L/hLnNASmO++cLRltGVYTOWno
 7pWzVhId
 c9VLixFB6Eaf9OV7r+H5KBsUodFwiYnbaz+BTY+1bvbC3OsrzeF2i2L/XjbRuBBxHbVVyi4nN2Fu67PPjQBL5p2tQOZctFOWpQwyKafnlgn3+dfNZDLnGmnj//VOPPjONaxGF0R7upCBCBswcLlWXecqz0BXSjrbd6HeUtVCySB+M6NRVP75u2Zz5d+fllGfbxgzGkbDQRqT6p6yR3twGxCAdmdyzO9PhTFyK4Tpp1fM2YDVmGf70A5SMv3O8g6HXMlwL4vd2+Wk9iaDSGXWNnK2lljej6c19r1b1Eydv7DjvnrctQHr14jl8wbHXY6pO/H+qS0d7ZnwY+9S69/dLjLNE0j9yBS8Z5FJnrF2dTY0Qt54aP5p/i5Pten+we2694WmbXtOi77azhhXpFupwUjoJp/uccZTbUjxQf1xwH2859Uk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/30/26 03:53, Ye Liu wrote:
> Replace all 'int reason' function parameters that carry migrate_reason
> values with the proper 'enum migrate_reason' type.  This makes the
> intent explicit and leverages compiler type checking.  The affected
> subsystems are:
> 
>   - page_owner: __folio_set_owner_migrate_reason(),
>                 folio_set_owner_migrate_reason()
>   - migrate: migrate_pages(), migrate_pages_sync(),
>              migrate_pages_batch(), migrate_folios_move(),
>              migrate_hugetlbs(), unmap_and_move_huge_page()
>   - hugetlb: move_hugetlb_state(), htlb_allow_alloc_fallback()
>   - trace: mm_migrate_pages and mm_migrate_pages_start events
> 
> The 'short last_migrate_reason' struct field and internal helper
> parameter in page_owner are intentionally left as 'short' since they
> store per-page metadata where size matters.
> 
> No functional change.
> 
> Signed-off-by: Ye Liu <ye.liu@linux.dev>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


