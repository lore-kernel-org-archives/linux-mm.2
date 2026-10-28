Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1124D60A260B
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 15:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=geYSyUoQ
Received: by kanga.kvack.org (Postfix)
	id 217A96B05B4; Wed, 28 Oct 2026 11:37:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EECB6B05B5; Wed, 28 Oct 2026 11:37:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DEA76B05B6; Wed, 28 Oct 2026 11:37:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DB4F46B05B4
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 11:37:36 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4B4CF16013D
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 15:37:36 +0000 (UTC)
X-FDA: 85372439712.09.6A1A3E9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id B8A2D4000D
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 15:37:34 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=geYSyUoQ;
	spf=pass (imf04.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793201854;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iEstB2Yqj/OV4/iylOODgI3e0ZEYrocagDRh/bGqrzU=;
	b=XTukraOh3lwnZeaKsUNuH3uKC3OsE+rvYxpGW2TOm3w6CDGAoK35Gz3TY9All2FJKzsnlV
	bmawdoODD2C2D+NjCQPU7DSqqWN9PbHK9APjbfiWSPIQNmEot3rL7dhjAXrnJDZ+CLfHBW
	F0/S+/wEpxRAXch7XBe/SrtznJSXIXg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793201854;
	b=dkrATxxrIy9S1PZCP12dMqnx1orpt82Nvei0DmxDrujd/eu7WJGJmNmwXrsqM++vVL8L4o
	jOy5LqcUywEHPa3mg2dAYX0FjGIMb+n5/oMSXMXCq4kPWBLW/wUQFSQVCaY8L46hKnpB1q
	nB1KMhcUfJOoO1oMHU4RPY434aGMjSg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=geYSyUoQ;
	spf=pass (imf04.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AC9EA40DD7;
	Wed, 28 Oct 2026 15:37:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B7081F031E2;
	Wed, 28 Oct 2026 15:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793201853;
	bh=iEstB2Yqj/OV4/iylOODgI3e0ZEYrocagDRh/bGqrzU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=geYSyUoQgrGtwDbkkBwlXHTFNbhkeqzSW52AV3xgPmMnYLfnuh7bWTDf/yXqU3F0/
	 Uwp1PErTxxkS8aF8yIsAFIQ1nhA00DgrpkkCC7FiIsrXMH53H1wB36EDCWCPl02axG
	 28tMyiaQfMjN4uVROLQPgjZg0X5RcvRFC6U0tFe9mplLI5iAzo3pSuq09urihZoG+s
	 NJw+Uih0fQ4fiBUQjBo9hNO6n41sCFUDB0nkmyrg9XfpgJxgSuXj5uT4keq74WaL8W
	 xjG6EiPDB4+X8HzbnjU3aigdSmQzXkr3BZpA2vajjR8JZDNm0nzmY1+LNovKF3Zw4F
	 DGM3/VWtbmnHg==
Date: Wed, 28 Oct 2026 15:37:31 +0000
From: Harry Yoo <harry@kernel.org>
To: Chris Down <chris@chrisdown.name>
Cc: Vlastimil Babka <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Kees Cook <kees@kernel.org>, Marco Elver <elver@google.com>, 
	GONG Ruiqi <gongruiqi@huaweicloud.com>, Jan Kiszka <jan.kiszka@siemens.com>, 
	Kieran Bingham <kbingham@kernel.org>, Jonathan Corbet <corbet@lwn.net>, linux-mm@kvack.org, 
	linux-hardening@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH 0/8] mm/slab: Support selecting slab hardening features
 at boot
Message-ID: <auIVIKxjrdXIaUIY@thinkstation>
References: <cover.1793086056.git.chris@chrisdown.name>
 <auIN44CnAyzvR_Ll@thinkstation>
 <auIUaT6LyEI2cXpj@chrisdown.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <auIUaT6LyEI2cXpj@chrisdown.name>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B8A2D4000D
X-Stat-Signature: nz5ip39fzxw5hcdzqn3ftwjhb1xwue7e
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793201854-798138
X-HE-Meta: U2FsdGVkX1/MLa1m2udMQFD1E2bkuhFTrCPDoNvfLgDDjFcNpBABsHZcTEg6UGZR/f56HpKxl/UGhyBUPv/xDvnXtr/FigbdG0mDYMP5DyytjRdD5r8IfkfM0/xQlB7UqaMe8KEmfRxDml25YAtbfECH44AdEDy6QOLmuU+Mvu5vtMgnrpbcVhbP3IX48Nb2J99yWc6sHXEHNdBBfejAcrDS1LbpCXB/MEVorK84KgE2DOLfpE7pcYiDWldB0mFh65m9tOTF6SL2crKPsygZ/bcKXBTKdzJrCFYgPMRrtKwuIpP+r8KZSRIAgToxBj10gKgTmqaufx3BWMnEnePMGG2GYIGunez/r9X8rwEBronPRzw4hXvYqxZux3qsxOwxD5AmPmyUXzS1H6EPpSXyjb2RLBHQhw5zCL9RFS2MpzNCUmGuY2a0Ks0d2JKgOFAo3Z48ti5dWd7sFOytzNGGv+trXKztwsj+1Zn5+EQUjVGRfA9oLEnVzlhMQLxkh8JM+YoBJ5u2qJppw7lUoP/ncwaaY0DthY/BFPWcmuQoVeD60+3SIhaRma3n91NkihSgUIhDGSIhANTFxWt/HnPKfRdIx9xIB77XHYQjAs/Gd2DW89lYH20f6IrIPhijv+7a+cBpSjiR/H9oDv4iOWfWj9zKauJOtZKNUvzDVon4gI50Wsw510YSEOMRySRFIHdSQ4i1mbd4SNmaEyf811fQCJzRjaDBjQy3zXP1P3Ht47YI55TrDKBsCobKluxJOREE+0npw/6bpJjclZUnnGFYtW2R0zGN1/gx0nSjc9l+CGRo0PvpT48+LDnj96ZO8XGGcKoEMlJMgfP9xaN2rQi3HTVk7b5rR5XzQ+x7iyWEChkHdZC31rVyJfVXMdGEN1WDojuDDPNHh90Yavsi6ml2OHzdN4q5M2ZNC8KuajcM6Pz2oI87ray/zbUK1stvUUreR6eS8eZRhqXDzXaUCOD
 MwRL23ek
 7hW1lMbFYdCY3HetAsBTQo8YQaCfMaCYnj4DlrGAvm3VUkMRfwmiST4nPdmf79RCw2kCZN4AYvt4e/xRsB5mmwu5gXGofYJ2AG/Cj0b0hkdSkOXuq8iClYJWKTHF8RcdQ0ejzFInYpmlIRGc/2ulfncG2LsSO9Xl/hTMkQBFIIplxAQYUBYVPjYls4wZzyZvx74lXlkJUhS4gTXfIXQ7tCAYrsgl6o1qxV5QgcGGDaZY/ajYcXqiAFAO1FCJ9BHKLL/6A
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 28, 2026 at 11:27:37PM +0800, Chris Down wrote:
> Hi Harry,
> 
> Harry Yoo writes:
> > If we end up supporting boot-time parameters for hardening,
> > I think it should be all enabled (or disabled) by:
> > 
> >  slab_hardening=none|light|full
> >  # please feel free to suggest bertter names
> > 
> > none: "Turn of all of them to maximize performance"
> > 
> > light: "I'm willying to sacrifice _some_ memory and CPU for security"
> > 
> > full: "I'm willying to sacrifice more overhead for security
> > 
> > IMHO more fine-grained knob for each feature doesn't make much sense.
> 
> I think if we did the 4 knobs that is a good idea. Given now it's two, I
> think it seems reasonable to keep it as two separate knobs unless you
> object? Otherwise I think given it will only cover the latter two, it
> should be something like kmalloc_isolation= instead. Let me know what you
> think.

There has been constant, steady efforts to add more and more hardening
features over the last decade. So I'd say slab_hardening= is more
future proof :-)

Kees or Marco might have more insights on this.

-- 
Cheers,
Harry / Hyeonggon

