Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62B36606A31C
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 11:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=shutemov.name header.i=@shutemov.name header.a=rsa-sha256 header.s=fm1 header.b=rXGQrCv9;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=rPkAaQQj
Received: by kanga.kvack.org (Postfix)
	id 787436B05B0; Mon,  9 Nov 2026 06:32:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 737B76B05B2; Mon,  9 Nov 2026 06:32:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 626626B05B3; Mon,  9 Nov 2026 06:32:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 328596B05B0
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 06:32:52 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CA0D0A067E
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 11:32:51 +0000 (UTC)
X-FDA: 85415368542.07.566E440
Received: from flow-b6-smtp.messagingengine.com (flow-b6-smtp.messagingengine.com [202.12.124.141])
	by imf08.hostedemail.com (Postfix) with ESMTP id 94A49160002
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 11:32:49 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="r XGQrCv";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=rPkAaQQj;
	spf=pass (imf08.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.141 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794223969;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xqdjx+sIoTks/glyMlCpkSxskUk/OBQ+eUU3z0s7uZI=;
	b=cw2EUJ8ymHwqLZXY1ZOp+VfgVymuAzJgj19QC4Y5nIASqyexhigzx87x4pWlJDDwn1ZS3c
	k66DNEUbxoHS5bfqT91x0bmG5mixlFIsl0LibRwMa7F/4EErLcEV45riFKWxIp2uGWdFRd
	MMUinoMJ067CZ0s8snsB0o2bGqplgHI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794223969;
	b=2qCk5mtE62cUk+0KBjd8ucnKZR97bEdzWX2+tzbnT8dgouFNnPPFh+Os9YaLr64wnC3jp/
	LhT/ZEg/IQndKn6armYV4lT6ZnHFrmFbE+0hyinc21yXb2cxvIRQYZFDSXYCdypAYkM5FJ
	LMS3PxIHd7TnWo5h/KGHKFJl84g08J4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="r XGQrCv";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=rPkAaQQj;
	spf=pass (imf08.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.141 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailflow.stl.internal (Postfix) with ESMTP id CA24A130171F
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 06:32:48 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Mon, 09 Nov 2026 06:32:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1794223966; x=
	1794231166; bh=Xqdjx+sIoTks/glyMlCpkSxskUk/OBQ+eUU3z0s7uZI=; b=r
	XGQrCv9H1DQ1KeY0P5fWLxfWeX8av0naQqeAzEywS4e7cfuq+S3s08vT/AF9SJ8L
	GEZCYmdSXm4Dn1JSqxQ07kNOUgPcQ2sAufxrZOgwkPU0i292RhfdDsnD5a/6n0A9
	Orfq+kOpieCyhCQFfoLjcLFjzg40DqQm7Qg0h0AxQ6nW+JZ5QSzUgohtRs9GidBh
	4xEmDJtvtUTinut9/QO/gV2uxBzrp43j8ICxWYl3usJGZznvcJIUJjuYYm1h+t7d
	6IBmB4Pl/xqYgJblouLsB229SGtBZAp0p0iSFYiQcQOy2RiGY6qKZXgWtm9MZAa/
	T7VgW2P8IFhITe9x7qWwA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1794223966; x=1794231166; bh=Xqdjx+sIoTks/glyMlCpkSxskUk/OBQ+eUU
	3z0s7uZI=; b=rPkAaQQj3kfv1Es4CKUvFt36nHTZq53JmOG7vhYvZId/7PKFcWi
	cDSPnbO1BlM0eOgWCT+U4PZfXxIVcK4Ft1PxvHPj3TCHyIFmm/0+KUGQZRkjtKEC
	lJ3454PB8dh4AFURy6bMXcWcMcXTpn3zKymCmObIn6gGOx+z/HLy1NpjAEmk0qNc
	dRr9BYMVup6V/3cvUsyHqa2vjmelckeCtkOEq8QdrZz3CNmY/ZMGsH/H0fGVgcA4
	BevrM3R/ujM/GovJ3k9TCrYCfHwL7/FAfNugalQT1G8LEPHbvxn6iJzSf0vfEpL9
	nIOxkoaCUCY8xJfL52ryyPU5yT/edFRnDNw==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=shutemov.name a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1794223966; d=shutemov.name;
	mf=PGtpcmlsbEBzaHV0ZW1vdi5uYW1lPg==;
	rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm1:rsa-sha256:wLYjjXm7WzGy65YxaGr6qE96YehvN2m/UJbp5fdLCPx4m5x
	a5o86A6gzWhXC0vY8TEK+RUd+ArUCEZQghu4A1rDMyMXXlh3JHyZyshxK1GHNXLH
	O/2AsAK/PIC0KuSDQIxYSCmkw0LRGilfglL7PQC5c6Rfiex5wMOw3CgB0VRQ9QKX
	g7XmEc+gWSxRoQ6MmX5b3XVzk8oMy6Hl19BkCu2IknALY5OgnPBMq+wgMEdMP8VP
	dKhUmW99JCdltTPAtztOv61wzYRvVOfpJTaY8IkxX8iClHWnPfa2rIR5tJBGsbs0
	P/jpLj4tE4OxO0fcmrFxfJfca34No5SqyvSv+dw==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-disposition,content-type,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:dr10b/t5AE3MhAk2PKDxOtARndah5JsxsaedpnrJqhc=:QrUxDwEwfWH8+2Fn+5Ww/kuadmo18gKAm3XTyO4BCEI=;
X-ME-Sender: <xms:Xq_xak8LSPQK9_NUmtqxHsELyPAPvGk9pbX43ABxur8o4Tbf8EjO6A>
    <xme:Xq_xatcogKYCSsX_mBNL-dmhOg_Owem3pA_u3dtI_IH_bwOpGnNpZzCMtFlFPfhYY
    mkGjgTsYix0-SFDXu8xSGk2NjmMQu5wQV_r1qSG4APzZfykz4WeBip6>
X-ME-Received: <xmr:Xq_xat3Ma7USbjO2an7dj2YIaZRW15RWWnTU68NBBuj8Ma1kHl-t7raDW4c>
X-ME-Proxy-Cause: dmFkZTEh6LlDTiUv7RQryEzVLCL8YJzMnu9yzeE7W0Ve4XNsg8Veu1FEmxD3SasTEZ8x8R
    LcUsw+eRLyDC5m6FcUi7nJRPzWEBExUVIdgxGfcXD2LeT38moltTtc88L9QdZrsq60nzdy
    ANotKCF7dkMgX99ligefAG3jJHapUzbyIHHq3sarW8DfCPycRmv040jfPW0ufbjSHFq4kV
    ik6QMQnc8p1wmQbwaiEWSjMOwlIEzId1TN7cNbT5O8VtZXoxiNakqy6fZmokLISxiKsXjW
    nGOkn6Ud/YEvA3lasQxI1f7v4ihmImhBBvjIUACmEppK452dKIGlAivfCV0ehVkqZIBABJ
    68KGriS8PCKpVG8VlgWWzyDHt5UvaDNDvPVrHBYB61ZyTSu+jUfrLdIA27/lbBmPl1jfkA
    8GRLltH5UfnN/ei2Z6mI2Ggzz2/Wo42DUR3FTsikofXBSJLGyqPG1vRGffc9WAR9ZmI2MQ
    bf5+IxArlrGeSWdXw2jpTQNzpC94jjVrJQZ0lKfhC0+vuxTamLjeaVAY5dQ15cBHHRzCOw
    SM7xkCd8ueN9ek5WZinFJhoTNziXiFQoBwilbQiFbdZ3vkSR8UncskzJLd4/ftREcw9I0r
    YnoqOgYgbmY6HslKBRY0+s7MsX1ZdgNfcE6byY/4sdGIiwPBWpnE7EJy/bJw
X-ME-Proxy: <xmx:Xq_xamB2yvQv2kVJZo6gBzyzKtCAp11tlpcb1cvN8Qw4t-QCRnU8xQ>
    <xmx:Xq_xaoSalDB_1QevOHimosKvRYsQdPPACR9xBKDIdTa0BIlk9j07ow>
    <xmx:Xq_xaoKIOv9ryFNrePBVB35-GHZXN1blMPmV4RKFd-8PTWo5JOP83g>
    <xmx:Xq_xavHs-8_6jBvQTFvkkKySMaThcGUYNNCnthEm5JUWYpxR8VfUqw>
    <xmx:Xq_xajw_Mbs-V7gw5z0MNhmjdbXgaWQgdEotdKoefhY3lGFd-6Pl7pqZ>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 9 Nov 2026 06:32:45 -0500 (EST)
Date: Mon, 9 Nov 2026 11:32:44 +0000
From: Kiryl Shutsemau <kirill@shutemov.name>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: sashiko-reviews@lists.linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Hugh Dickins <hughd@google.com>, Chris Mason <mason@kernel.org>, Pedro Falcato <pfalcato@suse.de>, 
	linux-mm@kvack.org, kernel-team@meta.com
Subject: Re: [PATCH] mm/memory: refuse to map page cache folios that are not
 uptodate
Message-ID: <avGvM5kpv_z2ezoz@thinkstation>
References: <20261106144323.3634477-1-kirill@shutemov.name>
 <sashiko-outbox-202966@kernel.org>
 <8cd50b75-0845-4e82-a8ed-acfd3a261a3e@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8cd50b75-0845-4e82-a8ed-acfd3a261a3e@kernel.org>
X-Rspamd-Server: rspam06
X-Stat-Signature: nt1co77ynxstgoxtfy9gwcuazb9orfj9
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 94A49160002
X-Rspam-User: 
X-HE-Tag: 1794223969-581212
X-HE-Meta: U2FsdGVkX1+6NdvaVwdQyJBWqpav9qCWQ7xvK7MoZIlYgchBLET2ppw8BqpO9fE9NYT7jFDY65HqUW25hEwGcNBqOzb2aaFyhH0CaHsZaJ+ElUjSDkMJd+7fGSp9jMZyiBqNxt0YEk80iuNPZk8khQ94JB8l+xXObcO9yPTXNxYVbBDdhCFO3zNP7tUS7ipqQClDJQk25hgCr6u/oJfYyTQZRdHytvsAbeTnXyEkHwAqoeZdH/p9SZGWf0ocGn+B8meZFVgEk9NDZ5ol9HN/l5mILIUynGBoiV1MV6CV302PcP7U1p87IqdeqaDjoiwEzvCHbmVr3dXW7wtMBiFx1FCRvdUEFVn4Eu6WqCQVZ7tvp+g+oyN4lXyOWu5rHPnHJ3tR7u1yNN9rqmi+RM6x0Rx7B6G7lBHNZzlS8/ewByjpEj66lQIZSoqxX6Jdm2w853c6czSoNdV9j1Rc3gUS/ehNqNawFaHR5Rmf/1msV8zQW8+v6iSus2y21q9QBxecshbRZono3HhN9ga8eh9r5WiUJFofoTXh1+3E7PDEaX2Z2OXgiBDQe6V3O0BDsrt+VSAxJeufFKcmYURWjFNtSJm3GogWp4QFroeEzPkWuPrBMRu6uhNZ1RhtyBApXOyubWWcaxIBWvmu7kfI4X9x4gA1UzVMr3Oc3dLbADr1Dd0kC0g4Tl8GzV8TkblW9IPyOoAN4P9Cz5wJ1uatueT2sgNokTv3wDzULhwVaoU6fTptzRuszYNxKBcSnLuyRM8CrMES2ZAFTqOCGg0HKIR/GKu0qdA9DzVlU+N9H09hyozTYoSnAtAJm/5I6tHMBHSQR7MA6wcJAnH/7rRu0eW+5u5GJofpwe4TzX4lZWq4RcjHYXKVtD6hq7kUXMYIpFXtnaJpBU/T16ZO4bq0L5RTU732IUk4QvBDrDzr2WZ+N1fdEX2d4LJLz4qTTWXrcaE+qTCFPOGyl4jfkY746ED
 nZ9uLWew
 +wHQLZgeCDb3F2FE+BpaUdBmsivNeM7rV9C8ioHXXODN3zSCYLq2bRmC21tBgQDK72bFGdGAZU3KHQuBX+cLe4D4fJbWsZmgNsvMV7tvrueQOOP4DeBzWc/3SOxmKkVfMQy1SAkzX4DZQcknzgTNueWcugaIci/g/118gDBYilzkomiCFiQifdkv+KiwEM5BLHResuRghqAzqdI8R10jJKuyrBQI3mrZkABfAwFKksxPS9+U91PzQwAon4M6UnDt5bouShk38PPmw4OZxi7VBR8p8Pm6HAc+EZRHCXKvFjm71TVd2JLkf1BTXq0+Q33ELr41RQ4ny6+Abn2OsVE8KsLoI6UjPfn6VPM8Asmc3adlHpGCFAGkFhs58y/TL1vllRzebCIjRKYVROADSma1d3BhxDBO/X6uSRG7V39oKcmXL42PSA2NiXy48RjPPHV6nojO++oyySkbTPgaQo/jrcnYLcgA75/xUDxveES6UrYpEgbVwOvC2J6FXlqh7Yx2258rw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 07, 2026 at 07:17:52PM +0100, David Hildenbrand (Arm) wrote:
> > - [Medium] mm: missing folio_test_uptodate() recheck in
> >   do_shared_fault() mkwrite path
> 
> Kiryl, can you look into that?

Yeah, that's legit. Will fix in v2.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

