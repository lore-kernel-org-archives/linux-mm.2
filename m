Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EF25606A321
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 14:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Bvu4++Ow
Received: by kanga.kvack.org (Postfix)
	id 1FCBA6B05B5; Mon, 26 Oct 2026 10:31:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D4B56B05B7; Mon, 26 Oct 2026 10:31:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EB416B05B8; Mon, 26 Oct 2026 10:31:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E061B6B05B5
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 10:31:19 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1D7171A0778
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 14:31:19 +0000 (UTC)
X-FDA: 85365015078.20.A9FB248
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 63B14C0009
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 14:31:17 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Bvu4++Ow;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793025077;
	b=OMb/18ozhzM3CbwtZcASTdX+hkbC0ExNxIVpo/duBGg4I7W5jTHXMnDmT+Gw1+prox3t1Y
	eEBNzOydmj5Re+gD/4Q9E7TgDwKU6Nk2LX5k1S0G50IyU2ZizwGQP+pKgGgAarQREhFCXj
	WQKs25XTSRRqt3Z8bZzVUQAexa3n5YM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Bvu4++Ow;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793025077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HHYZN7CUNSVC86iKOqMGjhaR96VGj0GsKVxO2ePAdxU=;
	b=QcaKdY+VJxAktGyyzG2HntkKmvV0GCymGnFSNQgeQqZCeuV4hn2XsgSOjQHvsTAOGOLlaj
	A/ACPwQz8lWJVMH00LiEFaUs17ErQMqjYmDj/H89qzriTPUmdLkOtXn8poWEPk52tje2Yj
	yaiXTTL5rjKlsoKFpxp7Hh4cud3t5rk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7AC3B4024E;
	Mon, 26 Oct 2026 14:31:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 077A91F01825;
	Mon, 26 Oct 2026 14:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793025076;
	bh=HHYZN7CUNSVC86iKOqMGjhaR96VGj0GsKVxO2ePAdxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bvu4++OwAGVMLQ16yY85QEzvab4FU9r/RLkombk+8WziaGpwdrl9QXwIpuZv+5NP7
	 6AHYU2waZPDWZ/I5v63v65bImurDsoUN/G7fEHIqUieNkxz3ZXNNau5vcc/CDDmbDa
	 mmSCreJn18/wb41wKRbfo6OaMjF05WYkfPrAfQKqaSbuYpbkNABoUam2Goe7Xk3Zbz
	 wEKYIedkH2rLNDFkW5rftn+aRFc+bYkwhLBs28Yn76Kbwaf2Y2nc+03EFe6kXfnRuP
	 Yi9NXbujFsfSFP80yAkcP8eR2bSkKhCqyrNwtGwJjuba8tO+Vc77pSqbY+E6rohhYc
	 vzlNhN7SKEvzA==
From: SJ Park <sj@kernel.org>
To: Manuel Ebner <manuelebnerli@mailbox.org>
Cc: SJ Park <sj@kernel.org>,
	Aveline Noir <jm5905938@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] Docs/admin-guide/mm/damon/stat: fix pronoun agreement
Date: Mon, 26 Oct 2026 07:31:07 -0700
Message-ID: <20261026143109.150059-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <203ef50d11ae600ab06546d73a2290f291381551.camel@mailbox.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hyz7iyay7gwb14uhh9gcc65fo9mksase
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 63B14C0009
X-Rspam-User: 
X-HE-Tag: 1793025077-255230
X-HE-Meta: U2FsdGVkX18h8IsAEQqHRClgSWv0rsC1zsEUDTPsI0BviSMGALknvYEr3GxCRsTyMoRqsw4wSwJUuit7BBmHcKgpXxisphTJ9hBs5TfhoB52QvfRBhwza6KcTqzPOcSJAPJvIIo3BQtw5nW9Lo71epO02z2lTUInT/YI4o2ekb+CXSHM0EhhfvNMPFE6znAfQC/K4FfuWS7CYje+g3tI16KB2YGWNW+ibgRegC09bUedeFNzCwt8oMrT/Dwk6gUKngsggtQogbR2dKIleFN7GsgzIrBVM1D74GFJC/x+lDHVdUm5gm1Af28RPckkM/XUrAPyGa4L4GvwVMMkGHKpoMTbARroSyh2OligyLheaXnibM0RhF9aSZolN4i1Gxmj3BV0FL6hFVEGaQdXXhcgodVGmAlQCarIk7AnzUc9gdslZXLIuINTHUqiqiEcWuYD7zDrJ+rDSaK0opNg0tjIKJMWnzk6tVd8H+WIbFhppULrLYjLvp3SVf5HwSLFCfgmyBJzNhF67erMKM+wlEvy7SYtlrXrZ7rnJm0fKwnYTk/gu7126mqAFlVLRdK9amVYULHp5swAGJvSO7osVaHQHGWZbbiL2X8UP1GF/HHs4XQfIhJr6DTrUllp7YDgWLe1UrcpSTopf8b5TUOUIg8KmjnhL/2EwxFRspUHfFBkrET7C12jfnqIJnQwtAlRbrOd2ujEqvyXuZNJVxWTp/dQXJ1bvPmFzCL1/lViqwlHLOZh0IXxAlQhkIQk3+l7BPGoxnx//LyofXN6sJqIGf9raqaVfuwi9TcNDl5iS852zQTBBRpdQLEYR4IlAtPygfukhDmg+woO+WjtZFZzO+Od/i2I6hLN1mCq+af5ErJrNrOHyJjBO/Zkg0GQ0cozG3IhyblPSZ6HaM1TqlFO+IFym4S9tIZ1dVidQO8lgVUcgvjcuoeyGMQk8NhDyUvTnHXu3pP5J1gYIkNbyReOMSl
 daU1uQOM
 bNGMwWMGoCRVxd8SvqCf6ALfsrcPNWWp0sFZJSNVGexYhFhh32cTzXRacANPtUdp6XbyKgNO7wXBrFh1/tUSCT1P+Bv6kuOOtp98WbqZ5tK96kUlZzbynrbPq/pntBaNBZypHGbVNwLFRFrzr5vzUYb9xzqeRM6ukpzx+aShQSYrfLiiIYDft8VnWnndRmgiV+dtOBNa51Wb0jW71LWlzYRFO6C+OMJhC4YK1IJQM599+Nir3u+TavhNHRdt/ATMYHCx8cGms34dz9VvG5jBdHaqBJkmaGEjA/8PhgZ2pLZ3MHkrp6Z34UXDGQXKwM7uoc4QNxl6JTEmKCuo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 26 Oct 2026 13:44:55 +0100 Manuel Ebner <manuelebnerli@mailbox.org> wrote:

> Hi Aveline,
> 
> On Mon, 2026-10-26 at 22:14 +1100, Aveline Noir wrote:
> > "converts it" refers to the access events, so I think it should be
> > "them".  Rewrap the paragraph while at it.
> > 
> > Signed-off-by: Aveline Noir <jm5905938@gmail.com>
> > ---
> >  Documentation/admin-guide/mm/damon/stat.rst | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/Documentation/admin-guide/mm/damon/stat.rst b/Documentation/admin-guide/mm/damon/stat.rst
> > index 4a9db755a526..a93609649a5f 100644
> > --- a/Documentation/admin-guide/mm/damon/stat.rst
> > +++ b/Documentation/admin-guide/mm/damon/stat.rst
> 
> Here I found this one:
> @@ -41,8 +41,8 @@ enabled
>  
>  Enable or disable DAMON_STAT.
>  
> -You can enable DAMON_STAT by setting the value of this parameter as ``Y``.
> -Setting it as ``N`` disables DAMON_STAT.  The default value is set by
> +You can enable DAMON_STAT by setting the value of this parameter to ``Y``.
> +Setting it to ``N`` disables DAMON_STAT.  The default value is set by
>  ``CONFIG_DAMON_STAT_ENABLED_DEFAULT`` build config option.

Thanks.  Unless Aveline objects or add this part to the next revision of this
patch, I will add this  when I apply this patch to damon/next.

>  
> > @@ -68,10 +68,10 @@ estimated_memory_bandwidth
> >  Estimated memory bandwidth consumption (bytes per second) of the system.
> >  
> >  DAMON_STAT reads observed access events on the current DAMON results snapshot
> > -and converts it to memory bandwidth consumption estimation in bytes per second.
> > -The resulting metric is exposed to user via this read-only parameter.  Because
> > -DAMON uses sampling, this is only an estimation of the access intensity rather
> > -than accurate memory bandwidth.
> > +and converts them to memory bandwidth consumption estimation in bytes per
> > +second.  The resulting metric is exposed to user via this read-only parameter.
> > +Because DAMON uses sampling, this is only an estimation of the access intensity
> > +rather than accurate memory bandwidth.
> >  
> >  memory_idle_ms_percentiles
> >  --------------------------
> 
> 
> Thanks,
> Reviewed-by: Manuel Ebner <manuelebnerli@mailbox.org>

Thank you for your review.


Thanks,
SJ

