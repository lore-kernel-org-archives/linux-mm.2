Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 502BAC982C1
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 05:51:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5851A6B0093; Thu, 17 Sep 2026 01:51:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55C8F6B0096; Thu, 17 Sep 2026 01:51:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4714F6B0099; Thu, 17 Sep 2026 01:51:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 272FE6B0093
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 01:51:17 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9DDF7A4929
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 05:51:16 +0000 (UTC)
X-FDA: 85222181352.06.CE89A4A
Received: from fout-a2-smtp.messagingengine.com (fout-a2-smtp.messagingengine.com [103.168.172.145])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9E86F180004
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 05:51:14 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm3 header.b=Z370RMWP;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=EL2R8GIp;
	spf=pass (imf24.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.145 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789624274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UGRPAzauanR7qsQwc3Ona1gpjahHlNY9Rv4SC2D+Z5A=;
	b=ReR/jazAcv6kJF9603yeikemw971K1MwCS0NAEgr3kCoWD1qxOomUauGNPFTOjUBYOCtm+
	vL1s/6gYyMdWpZR1Es1qCozM5B9k4YzF+l95QmvbGskQ0mFz11Wb6smpDD7hGTR73i3AbR
	IN8l470zr5KqnJTfFtF2qaZsaI3eMsM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789624274;
	b=M2KeTVeKqPiRZEZmMzknZNHFbyoOQYj2/QxboNH5rAVGt3enDYvOksqJ2gxO3fgpvjdCcT
	Woizd28715LhqiMZbZmGzYHELmCcqe8wn6UjV2XwOESi1zDtYIKwcC8l2NN3f/IbgHOWb0
	1dJ2PoxkPe2HKJwohWcTkcwlpEBdi7M=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm3 header.b=Z370RMWP;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=EL2R8GIp;
	spf=pass (imf24.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.145 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfout.phl.internal (Postfix) with ESMTP id 76BE3EC0118;
	Thu, 17 Sep 2026 01:51:12 -0400 (EDT)
Received: from ams-imap-03 ([10.64.2.23])
  by ams-compute-02.internal (MEProxy); Thu, 17 Sep 2026 01:51:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:content-transfer-encoding:content-type:content-type:date:date
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1789624271;
	 x=1789710671; bh=UGRPAzauanR7qsQwc3Ona1gpjahHlNY9Rv4SC2D+Z5A=; b=
	Z370RMWP2XHjGgZj3zFx2563dDWdU9Sdv0ctyAWJ+jJ37hE1HMUDARwJqWpMesrM
	hHfgXF9LVQ7KzQ/+5Dclss+kt/NqnZDjy58NdrvkB4wZyKm5shHpidK8QYCzEiRR
	wpEvrK1zUIurzGRxaS82+1fa/Lg9Qq6bVgeDJESLvmCqKNu5Hl+yLwH+v61NPdA9
	PP+b4XEw93qyBKvpoBNo3iWueWl89koWrslfv8aj+zJViJ30xnZn4cv9AqwGCv23
	rdOJ3Xaci9tmB2VnE9jcymj9WqLer8LHocCUmFxytooQAc8ZNxsWGm3WaiKKAOEO
	bAzmIAqDmAuJ9dUYVk+5RQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1789624271; x=1789710671; bh=U
	GRPAzauanR7qsQwc3Ona1gpjahHlNY9Rv4SC2D+Z5A=; b=EL2R8GIpbrRqeb8tC
	A0g82IX7qfBCrZsj0NsKlBxjmrxzAwfIGdFVq/yA1hYsnk/FXE4s+rj/LSkEm74Y
	vsB1xngJ2xPs4YeIEKr02rN9CbJ/waN43eM2I9sWxyj1cFidGDyT1o6esOUlVPOM
	eGq1UhmA04TMaLZ0Q2PEAwDfJygeXdGihE2rObc3342KdG/vDbt5w5Ah4432XG/G
	ykLG3B91PAP+P5wZhT/gDfM5UdDEscfKYLsFHzW+kmnDRcKpZFQjAx+YLt6awXKq
	p4SPVMry8brHgmCUpga+Z+Yvfk8sXrbbCHb9Pz9RWltB8KorgtBniqYDn2d1jiAh
	PVSaA==
X-ME-Sender: <xms:yH-ravJrZY-wRL74XnX1nCIQPbfFOmg9PPuKB4xBj7LUpOCKRTW_YQ>
    <xme:yH-rat810WfX6mq3u1b62-RsLWpMlL6W74u_vVjsUjNmCTFCBTVbNz9P_NiTH6Jbt
    utlhEXZNkZRJZ2Kb64Y8D-786pCMMDUdcAO4_3fbvOqY_iad9-pCwoE>
X-ME-Proxy-Cause: dmFkZTGnn8Sme9kb57l5bgN4UhEjU/bFY+Pd3evnw0NFIJSJ66av+xqVHMQlqpWCoweKBS
    3mAdt9AVz7wO7v41yIJ4dUlg9Mr3ZMOpWs8zcL4+Vbye7v//d6hDjaznL1d7/bCBwc3aCj
    Qh2t29H8cd189WZuf6E23LpGcznBhCX9raxZX1EXNGNK0nncYC7+9tA+4ojFAUY6zc1E+g
    Cj198DIh3EWhh5QtRlP60N7/L5wS2t74/d+6hekyk2t8Li/pI+fXLETkm2Y/WwbZ6mv3Nf
    tzfGiog2yGQZK8W8slXat/Kz0op6UHYM37phv4nCJIZuFPWTcGtBVEWkjlggZdw62RpVtt
    iD2f+/NRq5yTw+a3PSEZQhPUO/vE+/eeJ0rBORbkMWemKdrJEvTwJa0upFIr2/CfaT2DRo
    yM+/zrIGBdvxVMA8b6oRWyDnfUviiYeYBtRT/42TEPjG4lXe51p4H54xwbQYQt25BoQF6a
    QJRRtE75HBq3zpTRZYN0vgYO+1qKWPDh1cZ2QHizfBEPAOQcHrSFM0MkD2XlrRSx08IX0R
    8uEiHr3c46yHkvhA6xPmltQKEIge8WKPJg7x2bTAmheAMJqYidUR7TdZL5LvCH0hrW54j3
    88zWwJ/XJ1hTFctNTQ2zFSpwL2LQ/NJ4dHj0ZlRPQ20jUC+oCrdg8av071Pg
X-ME-Proxy: <xmx:yn-ratj26I3xhV-ml1GIbFLp2_t4yH49E0GZnb67XAN4fpnvYHmAQQ>
    <xmx:yn-rassCvbswT_p4mJb5vIH0vTlBStSmTAi9Gl9tsv2nZhEoz9nyvg>
    <xmx:yn-rajtF4Gn8VvAj1D587DSRvyzr32K7z-8WGeCNcSkhTvW388QUXg>
    <xmx:yn-ratMXPSyczDEGhifbVX2qnmFcPKG00jm2sFfnsb-Z8d8uQhUDKA>
    <xmx:z3-raswEjUzGjr96MXnzCL1aQ1kHG4tn8Fay2opo5lVBrKLnMh1HqXZE>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 0571D32A0084; Thu, 17 Sep 2026 01:51:04 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: ACGBcqtoOIMw
Date: Thu, 17 Sep 2026 07:50:43 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Andrew Morton" <akpm@linux-foundation.org>,
 "Arnd Bergmann" <arnd@kernel.org>, "Johannes Weiner" <hannes@cmpxchg.org>,
 "David Hildenbrand (Red Hat)" <david@kernel.org>,
 "Michal Hocko" <mhocko@kernel.org>, "Qi Zheng" <qi.zheng@linux.dev>,
 "Shakeel Butt" <shakeel.butt@linux.dev>, "Lorenzo Stoakes" <ljs@kernel.org>,
 "Kairui Song" <kasong@tencent.com>, "Barry Song" <baohua@kernel.org>,
 "Axel Rasmussen" <axelrasmussen@google.com>,
 "Yuanchu Xie" <yuanchu@google.com>, "Wei Xu" <weixugc@google.com>,
 "Baoquan He" <baoquan.he@linux.dev>,
 "Baolin Wang" <baolin.wang@linux.alibaba.com>,
 "Ridong Chen" <chenridong@xiaomi.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Message-Id: <75939625-482c-464f-83fb-fa12d3e1d79c@app.fastmail.com>
In-Reply-To: <20260916163044.3daa3811d9b2bf7d958f1f27@linux-foundation.org>
References: <20260916083456.4136132-1-arnd@kernel.org>
 <20260916162816.39f0f33f6a48d30a71be3575@linux-foundation.org>
 <20260916163044.3daa3811d9b2bf7d958f1f27@linux-foundation.org>
Subject: Re: [PATCH] mm/vmscan: avoid false-positive -Wuninitialized warning, again
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 7x364sdehkjo6r81n54n8uubiexttynk
X-Rspam-User: 
X-Rspamd-Queue-Id: 9E86F180004
X-Rspamd-Server: rspam03
X-HE-Tag: 1789624274-525370
X-HE-Meta: U2FsdGVkX1+QLWDiNXzYQ3fCTvo52oN4gYzNNnyTxGcHVpsDYJS8I2v+uzEhnSWb8AaMidb1U/zXOxMabP4mcyiZmhJqzuROtCWAHLoFYvocl1jBkJ8LgyIIbu8a4mjCVZgeaoxjn4Q7XGpY42wSynu2DrFEG22VDXRyFyYsvDDDbyLO7MOrOWbrd44+5d+PXtmrbsJbXQQgwbdWuqKXPoODbHDVCv7zRwuDoWZmlDOvLdF3FYgGSm/Rgpc+NERuh+F0lSag8SkUN4O53DZJC57l9po/0pfqzoqyF6fq9QKyJJei/hUbZdip+Rgfc+U7Mlc5RArIzOgkFparp9XoCbZK6JaAGIdgVWxrpQRQF1njcJqWdKtfw7dvBWkMGnC5D6WJG/LSx7YA231MBE+SGmFmgaJMvPDZguXi58EzP/UuFQoyJjt36xUcpVNFpMcqgpOIy3erkBP7Gv54Ek2nJW8Ct1neR5ClUkcrDcZEiO94q09J6UwQj8Vqn0OFgbb/vaoIgT2iHLnQSfGKHywyo/OtfzhH4nBOjtFBOiLO0hwNXYYY8uJzCIEDvJbwMlMCadat+xr4/sAtnli0/AjVxWz5j3SharX04MkJXCL5fjqE6X86eWOxIp99IFyuYoXQdcF4IeMQlBgUJPXza+Cmipuv0ygZTbz6yWmEUwJI59WW0m8+fUKdySqQTFcBeVKmer7dClUkM1ymH2WcqdJwIbOqSleirEM6+OJ5EiNOTxoNgxUV4hvhgTeUhRLasVkjq2q1T9QkopzTsbn4JpVlbRE9+OdbPQWaPJHP/8Pt1wWAEWDYwk8ypLKTx4bR28mVm0QHNonmtGmLzZ2HfaM+sF6wSJFE6GQ2qTDjx+XITet+RqCZ/of4nyQ/FGfVA9HABiFmg7S8aelvJe6K6rFzi9BSb5sykrBPy7znWrAQk1iTxk/c8Mw0ebYSzVctmr4n0fNbTU9IcNJJJ6k0S6z
 KXD/3s5r
 V6S8f0lWxQlpbkhf061htB81CpazWrmca76NJe17p/dfrf75TRvUMeFuyEjNLmCSrPRyI6QBTNayRYw0bjesBRyaYk1W3h8cLzK5bP2Kl7Rv0Iv7PVqF5xYAutDfrecsnczWDpf49KKg1cnBDFrgaIgWwcr4vpEBrmlM/2J8QI5zeBI4jw2UbR67j474xQ22SGsygYW5WEyn63jpJKJeCzaXf6Xivp+MIc5HvwEWILO7HgOvsmn7COkYLucY2tFlj6QA7icvqV6YnXb4Uc5W6r1j1E2FY3u3C5bOl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 17, 2026, at 01:30, Andrew Morton wrote:
> On Wed, 16 Sep 2026 16:28:16 -0700 Andrew Morton  <akpm@linux-foundation.org> wrote:
>> >
>> > --- a/mm/vmscan.c
>> > +++ b/mm/vmscan.c
>> > @@ -3274,8 +3274,10 @@ struct ctrl_pos {
>> >  	int gain;
>> >  };
>> >  
>> > -static void read_ctrl_pos(struct lruvec *lruvec, int type, int tier_min,
>> > -			  int tier_max, int gain, struct ctrl_pos *pos)
>> > +/* __noipa works around  gcc-16 warning for uninitizled use of pos->refaulted */
>> > +static __noipa void read_ctrl_pos(struct lruvec *lruvec, int type,
>> > +				  int tier_min, int tier_max, int gain,
>> > +				  struct ctrl_pos *pos)
>> >  {
>> >  	int i;
>> >  	struct lru_gen_folio *lrugen = &lruvec->lrugen;
>> 
>> Current code has changed here somewhat, but I expect the error is still
>> there.  I fixed that "uninitizled" while in there.  Altered patch is
>> below.
>
>
> Then the build blew up in unexpected ways.  gcc-15.2.0.
>
> The failure looks like a legit min() signedness thing which has been
> there quite a while.  I'm thinking that __noipa surfaced this for some
> reason?

Right, I now saw the same thing here on the current linux-next.

What I found now is that the __noipa is only needed on top of 
"mm/mglru: use explicit tier range in read_ctrl_pos()", which was
in next-20260915 but disappeared in next-20260916. This patch
also removed the min().

I think the reason why __noipa causes the warning about min() is
that it prevents the constant propagation into read_ctrl_pos() and
in turn the hack that suppresses warning about mixed types in
minmax.h when both sides are constant.

Is the mglru series currently expected to make it into 7.4?
If not, I would withdraw my __noipa and hope that the next
round of changes to read_ctrl_pos() does not run into this
problem again.

     Arnd

