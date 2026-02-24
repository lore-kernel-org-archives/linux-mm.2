Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3728DF4BB8E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 22:13:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6ED0F6B0005; Tue, 24 Feb 2026 17:13:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 670196B0089; Tue, 24 Feb 2026 17:13:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53E816B008A; Tue, 24 Feb 2026 17:13:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3C5D76B0005
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 17:13:36 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C2C1514038C
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 22:13:35 +0000 (UTC)
X-FDA: 84480752790.01.2CDB59E
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2874140004
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 22:13:33 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=DnAV39yO;
	spf=pass (imf04.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771971214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9vdsZ7c66kxSJS77MhnvjUWXFjLQcIllMEpQahfYWsY=;
	b=eq9Mnh3OXacoSibrdrKEIqZv926pEt15kSaFv01EpiA7UfN1l89cSOZyKA6/hGQQxfNtgh
	1OtOb5Kqp3eV1Buiom3B+qMqiLP6H5lSzOH+Mm/0keufGBHm+NWRoPdFHXxCdZU5yEQo8L
	9mUbfbjYLNoiwFbKXNO1U1fH1cb8+WI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=DnAV39yO;
	spf=pass (imf04.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771971214; a=rsa-sha256;
	cv=none;
	b=iZvdyo0HvUsLUfZcUAKIliB0cKDUhWTBnlN3qKD+Ytm+rUvYWfboIyDytzrk7ToruA5v53
	R8gZ0n51IVidnYGkz5vpx9FyvUcSVSGvV6lEmhYjkyBbn8SD+YouknhR7QnBx592SvXOKh
	5WWcv//XAIqwjQdgAza0QEp+Ig5ZTDE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=9vdsZ7c66kxSJS77MhnvjUWXFjLQcIllMEpQahfYWsY=; b=DnAV39yOY7CJliBslPyEC31aYv
	+8Yzh1c9Wnm5dntWIJ4qVBPIStPn+9knYABublhPpVxSZVGs5/kQo2WcRBYapP68Bo2Unm5zvX9M4
	pWwdTQtnpoSQXGhUAiO9+kP8k8U/A/E2g2OXNzLDN6FXBXKlcMnjnbTxXYW43JwLdbCUaaZTCdfH0
	tmf9rCH0W+gnJh8o7E0vh5Nn+3SrgR04Q5dypiuRAnpdB3/e1DBHSNKsRkGxWSF1nAL+cy+lQAbi8
	uiJawMwHttmxTgdNfWfAzhVl1Tw+aT6MpOmFGdU+emXgUYvjjigMZLSAPQakNqMVccfJ5efOqI23v
	K8c88EsQ==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1vv0e7-00000000227-2GgT;
	Tue, 24 Feb 2026 17:12:48 -0500
Message-ID: <5957cdb584cad9007a58f43fb5a1c3b737fb0159.camel@surriel.com>
Subject: Re: [PATCH 4/5] mm: support batched checking of the young flag for
 MGLRU
From: Rik van Riel <riel@surriel.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org, 
	david@kernel.org
Cc: catalin.marinas@arm.com, will@kernel.org, lorenzo.stoakes@oracle.com, 
	ryan.roberts@arm.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, 	surenb@google.com, mhocko@suse.com, harry.yoo@oracle.com,
 jannh@google.com, 	willy@infradead.org, baohua@kernel.org,
 dev.jain@arm.com, axelrasmussen@google.com, 	yuanchu@google.com,
 weixugc@google.com, hannes@cmpxchg.org, 	zhengqi.arch@bytedance.com,
 shakeel.butt@linux.dev, linux-mm@kvack.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Tue, 24 Feb 2026 17:12:48 -0500
In-Reply-To: <84d2426c63c1eafeaa0cfbad7c5cc11e9c11b980.1771897150.git.baolin.wang@linux.alibaba.com>
References: <cover.1771897150.git.baolin.wang@linux.alibaba.com>
	 <84d2426c63c1eafeaa0cfbad7c5cc11e9c11b980.1771897150.git.baolin.wang@linux.alibaba.com>
Autocrypt: addr=riel@surriel.com; prefer-encrypt=mutual;
 keydata=mQENBFIt3aUBCADCK0LicyCYyMa0E1lodCDUBf6G+6C5UXKG1jEYwQu49cc/gUBTTk33A
 eo2hjn4JinVaPF3zfZprnKMEGGv4dHvEOCPWiNhlz5RtqH3SKJllq2dpeMS9RqbMvDA36rlJIIo47
 Z/nl6IA8MDhSqyqdnTY8z7LnQHqq16jAqwo7Ll9qALXz4yG1ZdSCmo80VPetBZZPw7WMjo+1hByv/
 lvdFnLfiQ52tayuuC1r9x2qZ/SYWd2M4p/f5CLmvG9UcnkbYFsKWz8bwOBWKg1PQcaYHLx06sHGdY
 dIDaeVvkIfMFwAprSo5EFU+aes2VB2ZjugOTbkkW2aPSWTRsBhPHhV6dABEBAAG0HlJpayB2YW4gU
 mllbCA8cmllbEByZWRoYXQuY29tPokBHwQwAQIACQUCW5LcVgIdIAAKCRDOed6ShMTeg05SB/986o
 gEgdq4byrtaBQKFg5LWfd8e+h+QzLOg/T8mSS3dJzFXe5JBOfvYg7Bj47xXi9I5sM+I9Lu9+1XVb/
 r2rGJrU1DwA09TnmyFtK76bgMF0sBEh1ECILYNQTEIemzNFwOWLZZlEhZFRJsZyX+mtEp/WQIygHV
 WjwuP69VJw+fPQvLOGn4j8W9QXuvhha7u1QJ7mYx4dLGHrZlHdwDsqpvWsW+3rsIqs1BBe5/Itz9o
 6y9gLNtQzwmSDioV8KhF85VmYInslhv5tUtMEppfdTLyX4SUKh8ftNIVmH9mXyRCZclSoa6IMd635
 Jq1Pj2/Lp64tOzSvN5Y9zaiCc5FucXtB9SaWsgdmFuIFJpZWwgPHJpZWxAc3VycmllbC5jb20+iQE
 +BBMBAgAoBQJSLd2lAhsjBQkSzAMABgsJCAcDAgYVCAIJCgsEFgIDAQIeAQIXgAAKCRDOed6ShMTe
 g4PpB/0ZivKYFt0LaB22ssWUrBoeNWCP1NY/lkq2QbPhR3agLB7ZXI97PF2z/5QD9Fuy/FD/jddPx
 KRTvFCtHcEzTOcFjBmf52uqgt3U40H9GM++0IM0yHusd9EzlaWsbp09vsAV2DwdqS69x9RPbvE/Ne
 fO5subhocH76okcF/aQiQ+oj2j6LJZGBJBVigOHg+4zyzdDgKM+jp0bvDI51KQ4XfxV593OhvkS3z
 3FPx0CE7l62WhWrieHyBblqvkTYgJ6dq4bsYpqxxGJOkQ47WpEUx6onH+rImWmPJbSYGhwBzTo0Mm
 G1Nb1qGPG+mTrSmJjDRxrwf1zjmYqQreWVSFEt26tBpSaWsgdmFuIFJpZWwgPHJpZWxAZmIuY29tP
 okBPgQTAQIAKAUCW5LbiAIbIwUJEswDAAYLCQgHAwIGFQgCCQoLBBYCAwECHgECF4AACgkQznneko
 TE3oOUEQgAsrGxjTC1bGtZyuvyQPcXclap11Ogib6rQywGYu6/Mnkbd6hbyY3wpdyQii/cas2S44N
 cQj8HkGv91JLVE24/Wt0gITPCH3rLVJJDGQxprHTVDs1t1RAbsbp0XTksZPCNWDGYIBo2aHDwErhI
 omYQ0Xluo1WBtH/UmHgirHvclsou1Ks9jyTxiPyUKRfae7GNOFiX99+ZlB27P3t8CjtSO831Ij0Ip
 QrfooZ21YVlUKw0Wy6Ll8EyefyrEYSh8KTm8dQj4O7xxvdg865TLeLpho5PwDRF+/mR3qi8CdGbkE
 c4pYZQO8UDXUN4S+pe0aTeTqlYw8rRHWF9TnvtpcNzZw==
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 (3.56.2-2.fc42) 
MIME-Version: 1.0
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2874140004
X-Stat-Signature: 98idca5td8u7ngr4wfw6aecwcj4jcmiq
X-HE-Tag: 1771971213-713631
X-HE-Meta: U2FsdGVkX18WQ3JAcjIDzY6leDE1zY0dE9Z086Dl8q9kOh+cLaWk4Fy5+2Ng995OqyD/zNBWsV+mpm2pf6Gw2xMa/iIJ2U3sdia3RBA3xmeVyDlkIbtq/gXF293HLba2tlr5PN5hpNaDt8cR6OS70wdjKhWrozKSAkZkNDLUC64ifZxx4LYbvJcf5yEQJxcDJ5Py3cVtzRgLrtEcP/fxlXNGsJZJtwdATBFAF/GPI6bTJHhoZqmtNA4W4M3wm7IgkPTMeeItSOM/5WA4L3Wjrn+3hO693Fc48EbtFhJDgDUSdOoJvO+pnGRrC9QHYiFkY4B14wP7UPyKq7SUmAMb5MLqhYPrA5jR4RQBG8f23CiJ3MFskWrxGyaKpGbtqzf0ncWo5bq62Yy0Tn21tLNbi7nP7ef9Hgy1DvCgu6junl6MF23roGxDcgzKGbbiQtNpGtM6VSn2DzimdXBxF1QS4o6pvBK26dmvpkGurYW8GeOK21E5YLXd+snZIq/qEZ7ACoNpPlAnZvj5/wG7f13WyHEwBXt/txMKqYeFVD1ESizTqqhtz8tF2W8nCldcDkdbCGdrgYTgDXxPTSLHTlw7yL6Bp8xd4DIk3CriWa1GOAKO1KVakFmbCRXi27X+K/zOg4tQfucuHPcnZQh/mYpSBG6/3RoUIE9IRxYuqxCC/6ghNUwXcvgzrw09QAZ7NTRz+kT+8chQ8nrigm6eSJraqv4DTOhVraLsg9envMI9opTabidwESwPc0g86eadnrZ7USu0SCnQKHFr7xw3e5xODjWT4oMMwk/q1pV99LwufCqrHlBeG4V+XomeaYqvv9Q32X4gu/gBMf1ntbZhln/OeVj4gfwowsqRQ5WE0uIioyK00N2Trbc136JbhuT43pk9goA8KySg0Eeb+faa+2AcS8dx9nvTah3FENrEz0gC0QFQyJPwbCng6lIOWiCZRtXRsnEknZVBt1+5QlF0N1e
 ZsUJoGF+
 HdffsXwYveS5HA0e/57p9lALa/DtrB4AcnF9bVOHvFUrXxWljagerBHtsszvhwNK+nUqVXTk4WH31GQoa18ORv3zs0eu8aMILVOfcQbeiovqereUIG87Wv15pc5kWIeUO5Hp1K2NsnGTYICsJnVgrkcgqf/YZtbcuOxeEoE3tDcGjHUKrNbIb3sFHpuCSaFy+PRCAD+hATXtclLrdVeqoClxb7twygw7oo+bWrBnf8VpU3JuRhojc+r9efGzgFYJZdKk/w2HCTvLoyjMKbEm9tBa2BaNmf1uS0yak2MzPXk2VLhLwfknH1220qfc5ZQzDngSrms5U5CMv9fU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 2026-02-24 at 09:56 +0800, Baolin Wang wrote:
> Use the batched helper clear_young_ptes_notify() to check and clear
> the
> young flag to improve the performance during large folio reclamation
> when
> MGLRU is enabled.
>=20
> Meanwhile, we can also support batched checking the young and dirty
> flag
> when MGLRU walks the mm's pagetable to update the folios' generation
> counter. Since MGLRU also checks the PTE dirty bit, use
> folio_pte_batch_flags()
> with FPB_MERGE_YOUNG_DIRTY set to detect batches of PTEs for a large
> folio.
>=20
> Then we can remove the ptep_clear_young_notify() since it has no
> users now.
>=20
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>=20
I'm not entirely happy with how much code is duplicated
between MGLRU and classic LRU, but merging duplicate
functionality seems like a thing for a separate patch.

This one looks good to me.

Reviewed-by: Rik van Riel <riel@surriel.com>

--=20
All Rights Reversed.

