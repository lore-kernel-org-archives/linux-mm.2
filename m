Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7627E7DEF5
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 15:56:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBAC26B00F0; Mon,  2 Feb 2026 10:56:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3E3E6B00F1; Mon,  2 Feb 2026 10:56:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B49F36B00F2; Mon,  2 Feb 2026 10:56:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A4F786B00F0
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 10:56:38 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5FB611B0B6F
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 15:56:38 +0000 (UTC)
X-FDA: 84399969276.27.45ABED6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id C84A6140007
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 15:56:36 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qfGQ5fKA;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770047796;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9ZJLRv1pXFSMyf2cbWMlfUGwHZIbsadPUeid9JOpYl0=;
	b=16tdT3sYU/jQ4iqku+n+D3PvGewFQq1meC/22DOqLNNwnpf2ogJRxuGgYHbzXFOQsSI9WS
	Ik6rsmQ6Hkb+wb6RkA33zSQPqtdTE5DAtKSBBFQLV6hWyAGlxrXPVii97YmjYBpbFLI/3f
	9fAqvgEnBHSx6gwrg/ySUHCYw1YhTHY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qfGQ5fKA;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770047796; a=rsa-sha256;
	cv=none;
	b=qfZosfl+X+XmknWzFsF43vmJehq2u2wuXJYgIZccfrgDqgM0o6VYMJVrFmHDjBEWJP1aTd
	khAbbVZPa7SNsZfa/bkPclqiK02fl/0LUEHULpr7m9Qbdb/fVENM1EohB+yycul8Oh0KFr
	0vp7du3C56Psua0GB4VGx/z1FynZNK0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 12B5260010;
	Mon,  2 Feb 2026 15:56:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 754F6C116C6;
	Mon,  2 Feb 2026 15:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770047795;
	bh=hNDa3sPMRbQqIrx0iC5mD0U7XJ3SPWGjdDKQECVmjnw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qfGQ5fKAjtAnf8SCxBo3XoXmfOT7aJZX4lP3fmIeV4yGB0iPPvZRom052l0PlOjGw
	 6h9/TKh+nV3GDuerIpiZiI4fJhz2NI141ENt15p7eV4x2Llyn/cwiZx5VqU/RvvTsP
	 84t199KpoVpqiElR/sZvYuzCmFw2bU8sNoRtCSelR/4JFjFN14HjjpwW6eD7lupIdt
	 u/BqFijK5MqzkJ2WVMx6fLIae740lcZL6a+QEnssuO3hNVm2QIBwtzMbbWqDIxFG2x
	 ANF/q3BK/pF7f8szX/frdAWGwMkjeTsuaYgQT/7svY8elg6m/HmRjsbQSQSQw/a2ib
	 xI8krE8JJEbKA==
From: SeongJae Park <sj@kernel.org>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	maple-tree@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Suren Baghdasaryan <surenb@google.com>,
	Matthew Wilcox <willy@infradead.org>,
	Sidhartha Kumar <sidhartha.kumar@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Alice Ryhl <aliceryhl@google.com>,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Christian Kujau <lists@nerdbynature.de>
Subject: Re: [PATCH v3 21/30] maple_tree: Add cp_is_new_root() helper
Date: Mon,  2 Feb 2026 07:56:26 -0800
Message-ID: <20260202155627.16416-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <hdmikz55tn5gwbl6y2bxwo4gyt4dc6bc7u57oidwbotncfexeq@efa6s2xpgkz7>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: jopwobzjr3se4pt7dnzc9ryhhf1ujynb
X-Rspamd-Queue-Id: C84A6140007
X-Rspam-User: 
X-HE-Tag: 1770047796-91829
X-HE-Meta: U2FsdGVkX18bgwcYjgpgneT8ZAA9kH/c8bXEW1VlaenjaL6s946XT8MfA8M22Qck8VKGYxIy4ZM8PM83JVwuspmfVUiKPBvO4IVHDE5rqxpU1T+3yeyomdW2t9/t6bJz0cG2VoZunnpujH3JBqKtuqVj2CwMKy/mZtgs+0rz49LfZdt0DW47Dkalnuep6BOtLm92hIzI5SnIPKVhkBaIfXW85anjZ4VsVX+Bmqg32rj1mqJ87oESmzZK3PVK8k1rGiurHEnL5fVmoB01g8chF6atnJQ0Ms4+Gcbo/ntyhXIBikiL6Ak6ILr9YqzxwwOGvP2gpHQuhgFuE45JVZW6HbWyqkJ152G5IFVZ+pOKYt3nVFpURrFK6IA/ykVBueNq5wcpvFrzRX2+YNk60Gbvwum3vpLHTDE3jqB5ruDrbVikBIweQzqjDzf6WnACxuF2K1Jss4nNjweiYZFqd3PZmPycaShz5o0CSDCTUehe6NuqhddAGFpt59FHcI70xsXOkCkGsXX7sDWGwFgDLe7ohSwIH1eVqi35osfq4ULiOOnAatA0c/gzMjwmDciISLaJ6hTRpJg2swItwDpnCpJ51USfDt9bmwKyPLExBJy2snAvtyqFqgy7PlSasbfCN/DBcR0jRy0xAwXNL/DKkaGQZSbmJvqfqeLxIctyT1TtMxYoEA1ceyAkJhOh8vQtCOqty0McidJvVv1eMugO/tlJiF5HdgKTEFpCczdB+5cygtdOXZVhrsdjpePV0rouT3TySv+W32uzplhBZXd3zKk5y2bS9HPQUVqLrqJkBs6/6E2VqmGqYHzBS0wQITemfIalc2DqVBEqHDPwCJE9KKCZCMrjZMcRsmMHj3qewSGmUghLn6voT/KtTh1CHlHccWF335a69StFrNlfQBGLvl516fD3F7o8qVBXoV16hRDZeJbn0GzQed5LtY4/eo51z9m9zvQbCh0MyieoW2Uqqkl
 cTHBtMs2
 SCweIr7TpeABqutQ/ryv7VMdJrmmdcHvS9blf9NX4wtatfk78dMMpqpJClhGfPkrMPki1UQpVRWe3BSyITgFMaC7kHkao4YwudMDsTPuiBxhcs3kaBWI3zv8Wia0MF66iSRcNLI80v9DCxOWo/MyAgcTw7gbwOfqepCGBFGWX2AnQNzVB3GU9R/JH8efgM73OFbbs7VCb4WvFQhTZ5O1Iel9KzstmGGT3GBSumbW8wsUBMHiqSM298M67Id7Tw+os+v6uFxkPO/FIsxqihFLpAutwJuWX9QO7xEEAz4dFzxtDnGN04Vx18FDYij5jsWoP46h1G/Pj5QthSpEcwnJH6Wbc/8AP/Kezj3oC7ZReg5FA3jo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 2 Feb 2026 09:58:31 -0500 "Liam R. Howlett" <Liam.Howlett@oracle.com> wrote:

> * SeongJae Park <sj@kernel.org> [260131 19:10]:
> > Hello,
> > 
> > On Fri, 30 Jan 2026 15:59:26 -0500 "Liam R. Howlett" <Liam.Howlett@oracle.com> wrote:
> > 
> > > Add a helper to do what is needed when the maple copy node contains a
> > > new root node.  This is useful for future commits and is
> > > self-documenting code.
> > > 
> > > Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> > > ---
> > >  lib/maple_tree.c | 70 ++++++++++++++++++++++++++----------------------
> > >  1 file changed, 38 insertions(+), 32 deletions(-)
> > > 
> > > diff --git a/lib/maple_tree.c b/lib/maple_tree.c
> > > index 5280fa6d2d6ec..42038e42a4c7e 100644
> > > --- a/lib/maple_tree.c
> > > +++ b/lib/maple_tree.c
> > > @@ -3337,6 +3337,43 @@ static void mas_spanning_rebalance(struct ma_state *mas,
> > >  	mas_spanning_rebalance_loop(mas, mast, count);
> > >  }
> > >  
> > > +static inline bool cp_is_new_root(struct maple_copy *cp, struct ma_state *mas)
> > > +{
> > > +	if (cp->min || cp->max != ULONG_MAX)
> > > +		return false;
> > > +
> > > +	if (cp->d_count != 1) {
> > > +		enum maple_type mt = maple_arange_64;
> > > +
> > > +		if (!mt_is_alloc(mas->tree))
> > > +			mt = maple_range_64;
> > > +
> > > +		cp->data = cp->d_count;
> > > +		cp->s_count = 0;
> > > +		dst_setup(cp, mas, mt);
> > > +		init_cp_src(cp);
> > > +		node_copy(mas, cp->src[0].node, 0, cp->data, cp->max, maple_copy,
> > > +			  cp->dst[0].node, 0, mt);
> > > +		node_finalise(cp->dst[0].node, mt, cp->end + 1);
> > > +		/*
> > > +		 * Warning, see cp_leaf_init() comment and rcu_assign_pointer()
> > > +		 * documentation.  Since this is a new root, there are no
> > > +		 * read-side operations that can view it until it is insert into
> > > +		 * the tree after an rcu_assign_pointer() call.
> > > +		 */
> > > +		RCU_INIT_POINTER(cp->slot[0], mt_mk_node(cp->dst[0].node, mt));
> > 
> > I just found the above makes my build test using an old version compiler fails.
> > Fortunately, seems it is same to the one we discussed before [1], and same
> > mitigation like below attached patch works, at least for my test setup.
> 
> Thanks SJ.

My pleasure :)

> 
> This is still with gcc 8.1.0?

Yes.  The test code is available at GitHub [1].

Nonetheless, another test [2] that is using 9.3.0 was also failing.


[1] https://github.com/damonitor/damon-tests/blob/master/corr/tests/build_m68k.sh
[2] https://github.com/damonitor/damon-tests/blob/master/corr/tests/build_arm64.sh


Thanks,
SJ

[...]

