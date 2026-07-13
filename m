Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F6BBC44501
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 05:56:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E91606B0005; Mon, 13 Jul 2026 01:56:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E41C06B0088; Mon, 13 Jul 2026 01:56:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D30B06B008A; Mon, 13 Jul 2026 01:56:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B2BC56B0005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 01:56:17 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4781D1A0A91
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 05:56:17 +0000 (UTC)
X-FDA: 84982693194.26.655A3B7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id A112240004
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 05:56:15 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Uqccgc64;
	spf=pass (imf17.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783922175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2NP1mgJ6gW2yYD/7AR0cJfOoVZuhCYDVNcPcy+76LJI=;
	b=Z9y5jNXE8+S3wODAhDSpHTpAhovZBIRlM2c0iujY/wgd+uHGz/SiUGjxZkfU3lyVtXp9KK
	XW0B2BbAixs1b3RtkpPFDi5F5d0pkRf28CfwhOQXF/4RyY0YhDDhG0kJO2v460lYDSYiEx
	rJk3ftySXXjlkmAd3lgEmZ2/D1Lt0yI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Uqccgc64;
	spf=pass (imf17.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783922175;
	b=Xqadj6KoTzSCzVoOH1LnQJWr0UE6iejZHB0g9CL46IOMOdOJ+pkTdk+mNupGg5lo90/IbS
	o8SSA7VDW2wT6XHgneyAO1UeBWoCK2Q33GUnA5X+fB5R72lHPlPjsNINaOfpIeknDJLxmb
	9ClKGPNcR7C7NXu7NqjTdQ/MA4QSrv4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 275CF600AA;
	Mon, 13 Jul 2026 05:56:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74FFE1F00A3A;
	Mon, 13 Jul 2026 05:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783922174;
	bh=2NP1mgJ6gW2yYD/7AR0cJfOoVZuhCYDVNcPcy+76LJI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Uqccgc64fn4QLCQzJ1v9RJDMlLbuHIuIdgmWEd7HkQnkNafLMnM5fxkRFUMhwQNQU
	 pj6r+OEN9TRpDV9FwyOnMMxLEtrjNT92OkUIjXshJrTM/OQQMJ6nsLuCAmcJ8nNFWe
	 T4Yarxbq1ig9j/83aEBLOYm06qAPCPLJUw22JR16nVwOi0rN3HLsmrdFBe74Y2qLhq
	 tJV+xBHAtIPesT4zzr+4yHTjZ42UcLueh0sJ6kM4iwlfzrfK8fud+5KoSeduBdNgwO
	 jt5ienjvi0O61gEsygovqOYEiREg1QfiOX7BJCD8jBaqEVIPXNNVZvcLvvi6NUn/q5
	 1bdcclEC9A8ZA==
Message-ID: <545f4900-5239-43df-b734-a811baeab35c@kernel.org>
Date: Mon, 13 Jul 2026 14:56:09 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH slab/for-next] mm/slab: simplify freeing remote objects in
 free_to_pcs_bulk()
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Hao Li <hao.li@linux.dev>, Shengming Hu <hu.shengming@zte.com.cn>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260710-bulk_free_remote-v1-1-a878d6dc52d5@kernel.org>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260710-bulk_free_remote-v1-1-a878d6dc52d5@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------TZGeQp05ZGDyRdPslg7ngHXI"
X-Stat-Signature: r3qps3ftbi68q8a3rx66bkhuexjcrmku
X-Rspamd-Queue-Id: A112240004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783922175-312653
X-HE-Meta: U2FsdGVkX19BCaTvAI/G6KjWsTfahZvXRoaBheX0YIxkd2H6aJEUUWL1qM4/ZB6u43AXQ991XfmA/vLzvc1mLFK/Z8Zo5+lINeV9h/ffnAhtS+4tk+SFRhPFnxBZ1bgH8T0KeOu5mXqk1ClvPnF4CSFnFLMoB/DbuqejmGsroNpwM7d1vcf5ZY3viF85J4bRt6Fh+hQL3EseNQ1eqUsxOYv0b2sH7HkMI47mrX2abs/9IwncVOPH3Yf8AFFU6UVa7iL+CeOJrU+lCCkBCke8X4lgzlwqsfuKIq5CKIwGLF9PftolrZItQCeB0iYUUnqcutdv67qiO1f8wMD0ODVN+hHXMYdE+DNJSSN7El5KiobCGf4UB6krOCpR6PpMkCODo/BYypLvPm82nyL8YQYhuEUX9KozxwbLSEQylmLKlFQTcSUTa8LO2acwtwXiHOp0TG98tDLp+CIUGlsW4/RKgcaBH45XBhBr1Ulx48bfaziTb8R8FiaWLbNLstg7o+Bg/iJXU38HIc+Tjx6qrVQn4ZiEqilewd4Sr91rlqVz365ncf1ddjMCRR9JiNKSYEHEmTPl4XJzm/ZBdDfRrnan6Qq/vfRpueJM8dxdmXnMf1uEPwC212OP3MOWppesBQMwL28MZmZKx1CzyZFxLGuxzSpWWBq661eHdm9D+Gnm5kloMeps6HVLW9fvPcNV05PkEr0qEPYzLP4Y5QMxlhwnSLbQNeGn/4hF+Yypp082UyjgDEmWOcFbJfs+7n3sMjOpYrjGTVgSGnO2kI3xt0taq45U2926oIY1W8cjSk44nEXFgB1dWc8F6bOpl11zSMAgzbPPjv0GcSmnB1b5EkFf3zSexMyWHMfG/BQfsp6URoC3UK3o4ss+0YC4gCR0OVlXOll5BLgmK5nT0ao1lZMaD8y7JhflT+TR9N1MfolCA/4tbiNrT4ezUoRMleqYHJFl4eeXXfLjWCQ2UTGUEj1
 YDolymTe
 m97VAaJl6v6xBZzTx4XNy7ReVUR6XJ74V9GzfOml9fkYngpacfoqeR8tzkjVR1Bqds2jYYuRP9eZrB9CkMqyIOXaQqxwcUVqH8dCsbtRxfhlK7tWuJJAmW8nmMdQ++Q3XgfHWqldYaqXiIpnBZ1ztPYwc33nWcJK71w07w5HMI8lI30WBf59CVS0t+DaFzvA82UAyoGwWdLjm1b3eJqYoPndluURiKEG3nyP3icShHtOj1MHqXf1Jm0NDh8dYw/aA+gKAXDu60BrXhoxMRluKY0KfqqUQCHRr4aJDJRNMjOGPNnVXC6J+zzzzdZQJxz7dU8DcrLp2V3AL7zJFTsqJi0aneDwrytagJly2r476NLl7lwS1OKSxizjyNe0WuCBSkqUEK6mP9h+nKJcQhNExFxDszxbaPvI8w/jL+EZqPTFV6uf3eaUSyteAs2iT5A9jHIdTuEbanjsHAa2YTMsBUTl2sKWCm6BGKJF4N+S3m8anChdIsqY1VFRrEef8dyRBS0HVlJ+qT8NaGo8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------TZGeQp05ZGDyRdPslg7ngHXI
Content-Type: multipart/mixed; boundary="------------wEKCzCaCMHING848bVdGe6DS";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Hao Li <hao.li@linux.dev>, Shengming Hu <hu.shengming@zte.com.cn>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Message-ID: <545f4900-5239-43df-b734-a811baeab35c@kernel.org>
Subject: Re: [PATCH slab/for-next] mm/slab: simplify freeing remote objects in
 free_to_pcs_bulk()
References: <20260710-bulk_free_remote-v1-1-a878d6dc52d5@kernel.org>
In-Reply-To: <20260710-bulk_free_remote-v1-1-a878d6dc52d5@kernel.org>

--------------wEKCzCaCMHING848bVdGe6DS
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 7/10/26 9:04 PM, Vlastimil Babka (SUSE) wrote:
> We have been moving remote objects to an on-stack array and flushing it=

> when full. Instead, we can swap them towards the beginning of the
> supplied array and bulk-free it just once.

Nice!

> Also add a comment to explain the rationale of freeing remote objects
> last, because now it would appear to be simpler to free them first.
>=20
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---

Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>

--=20
Cheers,
Harry / Hyeonggon

--------------wEKCzCaCMHING848bVdGe6DS--

--------------TZGeQp05ZGDyRdPslg7ngHXI
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCalR9+QAKCRCGXBN6rc5S
1vW8APwKPB+4FIkxD+xhgGlshd+TT64FX5Ii0Jo4oJfQnO34MQEAx69a+xfY61Bq
ro7wN/f2jDyFdUD3c61TgQ2pUyTT2AI=
=1QnJ
-----END PGP SIGNATURE-----

--------------TZGeQp05ZGDyRdPslg7ngHXI--

