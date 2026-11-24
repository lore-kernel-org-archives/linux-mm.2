Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 072C6606A33E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 03:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=alvoVMjB
Received: by kanga.kvack.org (Postfix)
	id C275F6B05D4; Mon, 23 Nov 2026 22:32:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD8596B05D5; Mon, 23 Nov 2026 22:32:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AED856B05D6; Mon, 23 Nov 2026 22:32:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 686C26B05D4
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 22:32:05 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B73C58081A
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 03:32:04 +0000 (UTC)
X-FDA: 85468588968.25.B5DCC2E
Received: from fout-b4-smtp.messagingengine.com (fout-b4-smtp.messagingengine.com [202.12.124.147])
	by imf31.hostedemail.com (Postfix) with ESMTP id B558520002
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 03:32:02 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=alvoVMjB;
	dmarc=fail reason="No valid SPF" header.from=linux-m68k.org (policy=none);
	spf=none (imf31.hostedemail.com: domain of fthain@linux-m68k.org has no SPF policy when checking 202.12.124.147) smtp.mailfrom=fthain@linux-m68k.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795491123;
	b=hsQS1acRNIbrUQa06Qb37zj+OBoNYqXVEMa7lb+j0VSZ88TPNrOV+X2gKupt78CgOoq2Bi
	w+PmsMlp8Y+qn2FhWjLwLGllUZ6H3AuXRt8bnpqywfl/bTYVMPWFWm5DG2gz2p0dzVVr8N
	FptkKWaQKQkiiHx7KQGzJubTlkND0eE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795491123;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kLoOysGNtZOXt/ESdOdZUsUDPWGwGSckCxOKgDV/zUQ=;
	b=eYieWVw4h0nNlbZFpD0r26ce+/zjLdvX6br+lekr6OqaXA9ZxfeCqA4mTSnZR6DlscjdHU
	ICdLvDsfQz5xYZDCd+gOip7Rto1rM1guTZUbWiXcItOAsg8tiZApSieW0HyQM8lzZE1If9
	A2YACHYg2D7FtnTOne89unDGYzLlIL8=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=alvoVMjB;
	dmarc=fail reason="No valid SPF" header.from=linux-m68k.org (policy=none);
	spf=none (imf31.hostedemail.com: domain of fthain@linux-m68k.org has no SPF policy when checking 202.12.124.147) smtp.mailfrom=fthain@linux-m68k.org
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfout.stl.internal (Postfix) with ESMTP id 494051D00373;
	Mon, 23 Nov 2026 22:32:01 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-09.internal (MEProxy); Mon, 23 Nov 2026 22:32:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1795491121; x=1795577521; bh=kLoOysGNtZOXt/ESdOdZUsUDPWGwGSckCxO
	KgDV/zUQ=; b=alvoVMjBTX/NhdGQNY67fq6toV3OveCnp8MX6fU00cHvAWxPtC4
	ympw8pvh8bdxyvT5bi3/2ra7zcPOe/wmLVS8ATj/gc9iPzIr+IYO9zlXpwrGCMWI
	rgCa4KE4bg033482/hBxGda2xGIRbYb1tQq4hLirbfMid6xJkLfw0xlG4182WM4k
	oxeB2/Xm9FZv4s64e9GatzkU1zp4B+g0KjX1L15GnESJZLqS/5ILMbxdwBIkjWHe
	vl8YQHkRS30QcFuifqWpM3gguKlxzNwwbVV/w5Gify+F60Jj6rlSQ/gkhYcoJ58r
	XLrcpnZcqndBeNJUCd7RODSWTkRHl0RE2hg==
X-ME-Sender: <xms:MAUFawWGOnSUhWCK0n74bj7S1daW3O9f576fnuZBdtB2EcJdtRQvsQ>
    <xme:MAUFawdh1Oq1_8bgtEdvN2rh8_xUeMjHNPlGbeEdfIm0rLylKVuY1fhblFZavmMsi
    aKJzVjTZY_cN7_Sx-Us_5uFIHv3RgfyOANrbzf9l_jc-6Kycz5etmAF>
X-ME-Received: <xmr:MAUFaxa12B8uS99cStoGsMwr3Isi2Nli3r3p_566paxqcxu05KiF3rhPgnYA>
X-ME-Proxy-Cause: dmFkZTEHpoa40k3wkgDvOYjTRBvpK2fU0Wmubuw4eAWknCsm19yPzDmblnHSkM0C/foDkE
    /gviTWxt7HQRY5tmC9+x10NSQo0Bq5MpD9NiZJ7ttBURF38crzHj43Sf6Z/S3cnKayTquP
    PKjvAHSMdyFHCMEE1T9j7G93Kkr7I+yDMMUpn7GfRFAIRiSZXM76u5jjSNIOIHZOB6frXq
    bjJ3B1+mU+Nt3nbZLZFZBsuem5iFzQIthvogegQ9qLmKoPl5H8LfO5i760EAdLiJ2bqtSv
    KaNgOXFO8n+CVAGQ7IGAOCRFzIX4CBPqojZY7xDeh7hXhQTL1/9VYK8v/FFA7yA5iT+0pJ
    BOdUtpePdwHKmey1pZteSsBtug5yTvXdetkn5a9A3YnjCwy264sUhaM/ZHCVwgeAOC9zHK
    8QzihtUER3Bb+SX9rIKiMoGFXDhFj3TDuf/6kAI/TEN8FtYcZN+XyKtnhdYVwJC+TcNkv7
    ooSAKkydzZ88wn+MvgEaE52JcfSFkejrUSYifUubi3KlttCP8TEf33jV2U6r6P8Fe1btqH
    l+0+SB9wX+5gDeyfyRpmHlDApLZQDv4yNStzUm/FtJNM8gNP1/LecqyJT/LpT9u4wyGUUw
    ZWfoEubPJ9J01lnKs6OYSAUDoKGHjVdWjAO7AyfpItAUQIN0sGh949DE22vA
X-ME-Proxy: <xmx:MAUFa0NJcAMrK4LX3DZf9VjPaWJ1uLZaOlQ6JPNpHp8OAiHPKbTgbw>
    <xmx:MAUFa_WctsRYYHPzbviSHjYtIrgXnYfkSm3hE1g3_BgZrHJ5FnOSzA>
    <xmx:MAUFa5IvTy3YsMBjmQC5_pD-7eUo9R7wpLZ6E_AMbaeCxxPpKzoiIg>
    <xmx:MAUFa6oDlywPuE8zIwr6hpSod7L4drQyEeIbXVIYF5BbzahKgp81mA>
    <xmx:MQUFa69GKEJBYb63VNweSDGNzNTTWOWlYWyYE5O0yuX0LS1PtMSn9EPt>
Feedback-ID: i58a146ae:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 23 Nov 2026 22:31:58 -0500 (EST)
Date: Tue, 24 Nov 2026 14:31:48 +1100 (AEDT)
From: Finn Thain <fthain@linux-m68k.org>
To: Bart Van Assche <bvanassche@acm.org>
cc: Geert Uytterhoeven <geert@linux-m68k.org>, 
    kernel test robot <lkp@intel.com>, oe-kbuild-all@lists.linux.dev, 
    linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
    Linux Memory Management List <linux-mm@kvack.org>, 
    Arnd Bergmann <arnd@arndb.de>, 
    James Bottomley <James.Bottomley@hansenpartnership.com>, 
    "Martin K. Petersen" <mkp@kernel.org>, scsi <linux-scsi@vger.kernel.org>
Subject: Re: include/linux/compiler_types.h:631:45: error: call to
 '__compiletime_assert_433' declared with attribute error: BUILD_BUG_ON
 failed: offsetof(struct qla_tgt_sess_op, atio) + sizeof(u->atio) !=
 sizeof(*u)
In-Reply-To: <8a0f78e3-5483-42a2-ae27-473bbb6de915@acm.org>
Message-ID: <85e103fe-acca-0880-1be3-cb1e7f79f9a4@linux-m68k.org>
References: <20261121034304.2dPxVKzk-lkp@intel.com> <0b947a72-7a68-9bde-8b0b-adb539f09a8c@linux-m68k.org> <CAMuHMdUxYwD2t8zrqs4QBCtATOtf9xE83Djo0g7qbNFGSCWAQA@mail.gmail.com> <669b9ce8-bb33-f7ee-1087-88c1e9d3b610@linux-m68k.org>
 <8a0f78e3-5483-42a2-ae27-473bbb6de915@acm.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Rspamd-Server: rspam10
X-Rspam-User:
X-Rspamd-Queue-Id: B558520002
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: 8bjqeknx8pwybgbh7zhqgejppikyxeyw
X-HE-Tag: 1795491122-18639
X-HE-Meta: U2FsdGVkX1/ZpnoySilQprQtqqn1bNEzNdx5wSn1vZu7ZwPu8CNj/5edYwtXhA2qit7sGkMbnp8xYthlmbQCXwP9iXgf39Fe9WItycjLezjeqmD3RDdrRTI4STcUO0iRvOdWRk1Wm/q1if6ayDRQci0X2D1uXcGGFvkDPYo8Ya9eT3SWsWevkshiIsN13oTD5PNfS4ahTcLp+m8mEUH/jfifeD986zhyb6UoPBHc4HpCyWR6yAhFZMZq2HNikaZ/ml0XGHaY/5YE1eTGMzU/H3m1aAEekXvL72gGHKt12fADyQlB+C0aCe1/28NGuRyX/T9kd+wAohQiCHzoJqUCM/HidhDu765AAYN7L6HLO6mEiq9hCHZNDBl5RVpGNkvpWijNo4C3b1uM+u4d43bRDuQWyAi5pHnPl0Q9JLiSaJ3YZd4wlPv68mDC3aDl+vfJ/yMvnKCa6QLtdMXq48bySJ5/CQBD9L/p6Er8wgqCVn7AehYRySAMw3sJRt+HN5jz6XgFKo4a3o6vzv95nv2J2EbQFdXSQdh3YmeVKMD+N0WogI7YmhGgcjTSeowoZLD8gRsI796dqyQEKK+C1kf5aVdr9dh4lMxZys4U7o6xHUsjJpK2zDmgg4s8rmd2bQgb/pHCfVW3j2OfMzMUSgWJBPdKR123MCQgbNAU3W3Y6FjmFx8638dXrHX0ZXQZPCD7bdJYmFtT4/WXyBeS99G59VeyN8P7vDUxgN9Tb78ov0t/kihPVjUs7KPBDL4k6qz8Dqi+QwB5+dznQKIGMj8Jflc3uiu5jMchI2Q25Wy4Dwhf6090ADUVufAkOJz//VjkFh1bsXjee0HVBJau8evHJ9earPpj+6qm8WvvkmibtEURhnM0cb1l8YiJwsGZc7afj3u1ivQJTmSHlFH9bNRvMYJ3tl5ELbTLb4vLK41XP3MIDl5gs+LAEghu/tbJ6O54YhgMgzVq04HhqKrRgMV
 VQvn7tb5
 WJaMH8gVfT4hfUaTZwJVZV46MiBM6wTGXEPdrG71GQRYaeG4X6avbRdQOJ4I3kBGr3T+u4/kN9haSw2JuNNV2qwen+EeKDwdsLGSikkYrt4AFum+xAXVdzsot76jjyV8jg8HqpThQBhWyNhn1jvP/50OGbK647wP6M3EHYYT9b9YfMgQNw7+2DRL8aKW/j6t8244cS9Nsng98GCOd5GlsyM/0CpyeDNgS19n9D26p3BR3fqlHAlks2mYXcfIncOGthgQMUywrRjEuERAwM9XWiaAsLyfxIkjA9HO78YT/IToB/f8xtT8hy3ozPyqPF3TngvhWJ7hsBcxHHkoTgozcDnV/4P0gTy6HY1UMNt47/n0toA5EBXwEePsd26KyubJOGkTyRAcRQx/5HOjWRIv/iY6PWOgOIOjiHYp3VIuIAUGn/4x6lKsbv4tavg42p/yroYG9u2S+0YOLiVV3QXcGgzNONYBH8PsCsjC84l8zWklODfDyj4qXmRe2r9Us5ZuL4eZsiAEstNDKYNgYgPQJTvP89KxL1VeFPNkX+jFqT8+BaY4EJTj+fFzFIHaTxooHjyZicIb0JcB6hZOehrYtB8X7DGg5ZX1GIqUu+4a1X5OLOjX82PdIdZQ2LZ7wEaM5u4oT8KQb66beKAXy1zTZiUZ9M00J5/SFhhiRzxPHsFuuksG4MvuumM4BF8VdDKDYX+hs5gbf23c566hgpydhD9qginvJZcmp4Y16
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Mon, 23 Nov 2026, Bart Van Assche wrote:

> On 11/23/26 3:05 PM, Finn Thain wrote:
> > Yes, two alternative solutions were submitted in March (either remove the
> > assertion or rework it). The build bot reported the problem again in
> > September so I resubmitted the "rework" alternative. Sashiko-bot didn't
> > have much praise for that*, so now I'm leaning towards the "remove"
> > alternative. I have been advised to keep re-submitting, and I will do so
> > after a suitable back-off in retry rate i.e. 2027 or 2028.
> > 
> > *
> > https://lore.kernel.org/r/93e35f60-e465-7f76-0043-f997fe2ec8c7@linux-m68k.org
> 
> What an LLM came up with after I asked it to fix 
> https://lore.kernel.org/lkml/202603030747.VX0v4otS-lkp@intel.com/ can be 
> found below. One of the comments of the LLM is "This is essentially Finn 
> Thain's "Rework BUILD_BUG_ON() assertion" patch with your two review 
> comments from this morning applied". Sashiko reports "No issues found" 
> for the patch below. No Signed-off-by from me because I think Finn 
> should be credited for his work instead of I.
> 

Thanks, Bart. I'll take that as a vote for "rework". There is an 
associated risk though: I can't test the patch as I don't have access to 
suitable hardware. (Perhaps someone with such access will volunteer.) 

Whereas, the "remove" alternative doesn't require testing as it doesn't 
risk a regression.

I have a question for your LLM. Sashiko-bot said, in response to my patch:

    Similarly, get_datalen_for_atio() accesses the array out-of-bounds 
    when len > 0:

    drivers/scsi/qla2xxx/qla_target.h:get_datalen_for_atio() {
    ...
        return get_unaligned_be32(&atio->u.isp24.fcp_cmnd.add_cdb[len * 4]);
    ...
    }

I don't understand why the patch from your LLM did not raise the same OOB 
access concerns.

Adding a flex array to struct qla_tgt_sess_op can prevent new struct 
members being added in the wrong spot in that struct but can't prevent new 
struct members being added to struct atio7_fcp_cmnd. Neither does the 
assertion. So the "remove" alternative doesn't have all the disadvantages 
that you might expect.

