Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1136EDEBF5
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 22:15:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01C806B0088; Tue,  3 Mar 2026 17:15:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0C056B0089; Tue,  3 Mar 2026 17:15:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E35CE6B008A; Tue,  3 Mar 2026 17:15:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D0D276B0088
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 17:15:29 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 68098C0127
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 22:15:29 +0000 (UTC)
X-FDA: 84506159178.18.04C9BF3
Received: from fout-b7-smtp.messagingengine.com (fout-b7-smtp.messagingengine.com [202.12.124.150])
	by imf12.hostedemail.com (Postfix) with ESMTP id 642CA40006
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 22:15:27 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=W22hhrGe
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772576127;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=piafCis23NCwy+3hKybLRiRLSfcLpmfKa+7uPVWZ6PI=;
	b=U+pRvClbnUchhAcB8ZRKpMWJHTJmDKR8u/M/zQUQHQIa9q2gzgkzjgTWbG/chV4WFETwLA
	sJqyJ/4cmqn731owxzeo3Wwf2Sh8tDAwqtrauihvdKj9yhW5NcwkUqV7JtNHPk6tX7p2XE
	gKCwHuxIfLp0hkjXKg8KSKqPHJXIbmc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772576127; a=rsa-sha256;
	cv=none;
	b=tfUWlT8zmvT1idYTIlKheRCehPLWDJUG2o7kmOAAknU7CGBW/yhFhmnHBnQznhyxOLo4z0
	IMMlaRyXrHIvXA6vxDYBEpEuV+qu48CPkJKm2r1CEmpme1WRXrCTMK8whLCMN3MNnISOTR
	o6w7KqH23m2bwmOfyD1drhJPK9Mt+hc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=W22hhrGe;
	spf=none (imf12.hostedemail.com: domain of fthain@linux-m68k.org has no SPF policy when checking 202.12.124.150) smtp.mailfrom=fthain@linux-m68k.org;
	dmarc=none
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfout.stl.internal (Postfix) with ESMTP id 227981D0016B;
	Tue,  3 Mar 2026 17:15:26 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Tue, 03 Mar 2026 17:15:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1772576125; x=1772662525; bh=piafCis23NCwy+3hKybLRiRLSfcLpmfKa+7
	uPVWZ6PI=; b=W22hhrGedB+A1rCDhsRdkAHKpaBntaqnCvnaV42OcnZLElVbUoM
	TUXwJCVwQzpTQkCQwajcZ7KidszoJdL+37h/l+Si300aCe2MV9X3zlyq240sefyy
	H5wmj3hUdrH1PJPdCd2czsOwqB1zVgxFQWbZC7MZ62JhkBQio9NEb74HRaf950IP
	zDmS+Uy+6WvdRCsnQlfVVzj0K+0LKyC4xmzJDpcvhH8EBdTPx2VEBRBlC+GpvB26
	VuGLvehAk1hB59/JnNz2AV+cN7r9XJM/jbn2ttLgLfZtU+4DogpCOgsANpE2ZL6U
	hnxLtCUdFuYEK/ObrgfUTB6/+eocG47+LNg==
X-ME-Sender: <xms:fV2naRPDpYdtLi-R5USiC63zncx05O2u_R2r9FrYsU5OIJeP95NNrQ>
    <xme:fV2naUqPCo3dYUBD6lyTfpIJLhKPQC8ivZdTAQS2LCfKx8ALKNNzf9RrRtl5cpi8p
    HV07dUEFaCi37JsjX0neuBEmdnfqHQMuD2QiUOAVicV-QV0l_bmUJ0>
X-ME-Received: <xmr:fV2naedSKBYFcwgqRVSSAKUMQmoBAZ2ZzL3am6WZ7YRKuwCR2t8WSboVgaTbFmQFXMgkRAwsDOYy22CjalTyWjiBsbw48vYfveA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddviedujeeiucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevufgjkfhfgggtsehttdertddttddvnecuhfhrohhmpefhihhnnhcuvfhh
    rghinhcuoehfthhhrghinheslhhinhhugidqmheikehkrdhorhhgqeenucggtffrrghtth
    gvrhhnpeelueehleehkefgueevtdevteejkefhffekfeffffdtgfejveekgeefvdeuheeu
    leenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehfth
    hhrghinheslhhinhhugidqmheikehkrdhorhhgpdhnsggprhgtphhtthhopeejpdhmohgu
    vgepshhmthhpohhuthdprhgtphhtthhopehnjhgrvhgrlhhisehmrghrvhgvlhhlrdgtoh
    hmpdhrtghpthhtoheprghrnhgusegrrhhnuggsrdguvgdprhgtphhtthhopegrkhhpmhes
    lhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtoheplhhinhhugidqkh
    gvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidq
    mhhmsehkvhgrtghkrdhorhhgpdhrtghpthhtohepohgvqdhksghuihhlugdqrghllheslh
    hishhtshdrlhhinhhugidruggvvhdprhgtphhtthhopehlkhhpsehinhhtvghlrdgtohhm
X-ME-Proxy: <xmx:fV2naSQ26LraRJxxakwoUpoYm_Ssq53fdytouAACbUdjpp5Db394sA>
    <xmx:fV2nafbAjcpEURecGS4O6oMs6JSmtiBffiK2AyPf9JJnVxuuFrVmCQ>
    <xmx:fV2nadcn6V6dQVLsS4atfcPplqQEKj2eXWibPYg_K-IDMFDO1JUiZw>
    <xmx:fV2naYLe0aI-PAIvDrT0F7-XIhfm73fZwBPZFkWxgHz316fQ4wRKzg>
    <xmx:fV2naQka-MXz1YjE_ijnj0YDbJXxFO8AVAucrlvVQlOqapuYVTQT1yOl>
Feedback-ID: i58a146ae:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 3 Mar 2026 17:15:22 -0500 (EST)
Date: Wed, 4 Mar 2026 09:16:21 +1100 (AEDT)
From: Finn Thain <fthain@linux-m68k.org>
To: Nilesh Javali <njavali@marvell.com>, Arnd Bergmann <arnd@arndb.de>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, 
    linux-mm@kvack.org, oe-kbuild-all@lists.linux.dev, 
    kernel test robot <lkp@intel.com>
Subject: Re: include/linux/compiler_types.h:631:38: error: call to
 '__compiletime_assert_431' declared with attribute error: BUILD_BUG_ON
 failed: offsetof(struct qla_tgt_sess_op, atio) + sizeof(u->atio) !=
 sizeof(*u)
In-Reply-To: <81916ff0-9296-4de2-bbf9-40ef0eb4c60f@app.fastmail.com>
Message-ID: <a081b068-d14e-943c-54eb-3c263077c8bb@linux-m68k.org>
References: <202603030747.VX0v4otS-lkp@intel.com> <6bc11e2f-393d-16a2-9664-a20e2f1d3767@linux-m68k.org> <81916ff0-9296-4de2-bbf9-40ef0eb4c60f@app.fastmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 642CA40006
X-Stat-Signature: 8k8f56tn1skh8843aj6kzyq7jux6duhj
X-Rspam-User: 
X-HE-Tag: 1772576127-739721
X-HE-Meta: U2FsdGVkX19GIUWHcIwEfGGwAe58BIXfR0Bws5RgdKWuzeyi3LcBheoQgbNeCMMF/64YqDmVTDpJwaD/HmN0M3TrUL1GCn4nd+diulFYChGipORa3O8PYTiDSZOy5Hrz4V20x4v01sBi7cQafV0XKDqN8Qdi/s6P6BqQm5GG1dgSTOswaor8OsWUe9CGx6IARVWNVbckeEkPNwsOBrH0don7oCIr/wuyvs5wibqdUwFcj7GyzV8dHirqarUTOgMx6Zw+FOXnwsr0O4paA12iQZQxHtYguu0xMGYenBWxWbrQ4RsPLyO/ZKPo3+h0XFbLIvPigExgwdR0NCvXUb4pBqNCXp+Ym6b1VGQHzBnT2J/4cPVswBIFDUbWkqqi43b1bmqC5Bc+LMnt90iI7TAyD5gCJwxcZlHHxFvN9xT9smKwQ9+2+DcLoxi+XqNHtBoEIVXGsLS4uVTLuIU4mo/TtBASdofwHqZeDKucmIeyhUQE8fhKnJAJQjUSTGs4G8ddniCkctdqwM3xjAgNr6DrYjplLU2uNIGwTco99mTwIfPxaXODMrSlyUJ/al3psNLL0ywf07K8yMK35JJWwWqiZY/YgtqXdj4cMU8uZ4rZFZ5RC8Ixe0DGlIsgWJYeG0RCx9N4acJbP0HkpEfJZwGcgA/N6pgvlLM7CP1Bsfs/s+UHEqN36L2TmRTSdgVojGTJZpXQ3siFRZeKKVNmcjAUr9RWuvE8hg/P84HUv/88EsEBQHAGl8yeCGBXePLxITLtp6XzuMepXiHGwqDL5HkkckmE/wgyGgFvch71KN5AtI3czqUMNI3snazzitPbH4TjZIGLgKXf8NPOrlNCsGfPVSkBZaosg45dFu7ZTnluHUot0gP5I0UhDUsBK6m/Xegs1vJ/49BrRBjZP8iels784prp6b2OAxz4CwEbnl8JwSUM7Nss3QQnIWwSnEwM6ip0bQ69J2xLOi7rwyEwfAy
 e4KfLEF1
 LRqasRveIm8d1vCfHmGJsk22iSUi25v2zkNNm1Kcp8/fv8CjaQjViuQJ5IvERCb1sw2uKYAyC3dvPd1f4b0y4E9mwDHELd9HJUIOXw1eKSLjJsRhGpgXzDg1V2tn6t/LJFSP/RKeFYofFbfjzN3GkcLvQud2gglAyrUufnRMGp88I8iCsg1N0HigYEBh8yS46unsMoNozZ3TYK/5fHvXh+Y0ehAybV6sr2w+NkgUkpj2z0yau7rghm5iMbzDl5qISbOxN22qbzbglwhayoQ1zxsFT/B68zjJFhpxdrG8I521T2FzIHe32IvUofwTUCi62+wVKbaMKPCZjuho=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Tue, 3 Mar 2026, Arnd Bergmann wrote:

> 
> As far as I can tell, the assertion is always true on all architectures 
> other than m68k because "struct rsp_que *rsp" is word-aligned and 
> "struct atio_from_isp atio" is either 64 bytes long. The intention of 
> the assertion is to ensure that nothing got added after atio, though the 
> way it is written does not take misaligned atio into account.
> 

Hardly an m68k issue. The same thing could happen on any 32-bit 
architecture under slightly different circumstances. (Nevermind 
Linux/CRIS, would would be affected in the same way as m68k is.)

No, the real problem is the assertion itself, which is a failed attempt to 
state that no struct element follows 'atio'. It isn't about alignment or 
padding and yet the assertion is written in terms of sizeof(). Go figure.

It is about the non-existance of an non-entity. That is, something with no 
name. I don't know how to express that in C. It may require the help of a 
fancy compiler.

> > I suppose the assertion could be motivated by some code elsewhere but 
> > I haven't yet found it. So perhaps the assertion can simply be 
> > removed. An alternative solution could be to increase the 1 byte hole 
> > to 3 bytes, and prevent tail padding that way.
> 
> The simplest way would be to force atio itself to be aligned regardless 
> of the architecture, either by removing the __packed attribute on the 
> struct nack_from_isp definition, or by adding alignment on the variable:
> 
> --- a/drivers/scsi/qla2xxx/qla_target.h
> +++ b/drivers/scsi/qla2xxx/qla_target.h
> @@ -844,7 +844,7 @@ struct qla_tgt_sess_op {
>         bool aborted;
>         struct rsp_que *rsp;
>  
> -       struct atio_from_isp atio;
> +       struct atio_from_isp atio __aligned(8);
>         /* DO NOT ADD ANYTHING ELSE HERE - atio must be last member */
>  };
> 

I'm fine with that, but I'd add a comment like the one I pointed to in my 
previous message, which explains some gratuitous struct padding added to 
satisfy a BUILD_BUG_ON assertion.

> In general, the use of __packed attributes in this file seems a bit 
> inconsistent, with outer structures being packed but containing aligned 
> inner structures like atio_from_isp and nack_to_isp. It may be best to 
> review all of them and remove as much as possible, but that's not 
> necessary as a bug fix here.
> 

I'm fine with that suggestion too. Thanks for your assistance, Arnd.

Nilesh, let me know if you'd prefer a patch to change the struct padding 
or packing, or something else.

