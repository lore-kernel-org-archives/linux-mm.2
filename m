Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD6811061B37
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 12:21:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 433B86B0092; Tue, 31 Mar 2026 08:21:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40B8D6B0095; Tue, 31 Mar 2026 08:21:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 348F16B0096; Tue, 31 Mar 2026 08:21:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2320D6B0092
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 08:21:06 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DD54B8784F
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 12:21:05 +0000 (UTC)
X-FDA: 84606267690.19.3D2B588
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	by imf02.hostedemail.com (Postfix) with ESMTP id 05BFC80012
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 12:21:03 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=mit.edu header.s=outgoing header.b=OTalYU3c;
	spf=pass (imf02.hostedemail.com: domain of tytso@mit.edu designates 18.9.28.11 as permitted sender) smtp.mailfrom=tytso@mit.edu;
	dmarc=pass (policy=none) header.from=mit.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774959664;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NgNcg+u1NBRoAeJ0X2EC7mko2ww9hZ9u4YDqZn07NJA=;
	b=BlAmaYlRvv6+VnUCerUbnfmws1SoE4kue/fUtebrHDh3QBkJosV/rt4jiCoI05abQGCIEq
	2GWOzSuGAwiCV5H6lPc7wOswRJ7Y4NvyzVZk6o0sKqtv8GDxKv7bVb7qVEfPefV6G3bTtl
	BqZS51Phr7kcm3xIvrwejpvjzAs+3XM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=mit.edu header.s=outgoing header.b=OTalYU3c;
	spf=pass (imf02.hostedemail.com: domain of tytso@mit.edu designates 18.9.28.11 as permitted sender) smtp.mailfrom=tytso@mit.edu;
	dmarc=pass (policy=none) header.from=mit.edu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774959664; a=rsa-sha256;
	cv=none;
	b=2hsf5O0Wa32qN/JuP4/bIpiUML/ckIAn+RfoKYTnCfeUDwF7RoDNoEyS42QhgIEzs8Q+9D
	5YiYO1iY+st6ZZL3iYxFAvemAd+U8dPiZQu0oDsH6nUI+kbtpXmXoyfluVW/ZwevKnPzyn
	AY59XUbmupJGYGTDCdYg0z7ENyYWWYA=
Received: from macsyma.thunk.org (pool-173-48-112-174.bstnma.fios.verizon.net [173.48.112.174])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 62VCKh5d020429
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 31 Mar 2026 08:20:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1774959647; bh=NgNcg+u1NBRoAeJ0X2EC7mko2ww9hZ9u4YDqZn07NJA=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=OTalYU3cH/zbxpYh+VufB1Rr+bdCrgFKwM738zGplWvymBF6OUgZu9hWPAzjeHaDM
	 GeZHgEIvEybyWZGOtv+Aj2qOgDjEcpW4xk60ILOXsKPV6t6YOZRK2Ruyd+JkqnjKG1
	 SXqRJNxi99vuNRrTlgUSuvgv1l9iWZCPTiAVLx11jTT5RULo2j7D6OL13XUPICc3nC
	 sgfCVF3MVZY/aXuhKkqvrlneGO/4nOIuz5QboAJzrPh8Z6yH/qn4SVuRTaknr/1id+
	 n29o5SXu06wFfiEmG1v8oFk44lf+PNZw/X+Eh5H4zMYZW+CIB2KQ1ms2pTM5ngFLOi
	 bVHabiPWhVKfQ==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 5D6D560291BE; Tue, 31 Mar 2026 08:19:43 -0400 (EDT)
Date: Tue, 31 Mar 2026 08:19:43 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>, Greg KH <gregkh@linuxfoundation.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        "# 5 . 19 . x" <stable@vger.kernel.org>,
        David Hildenbrand <david@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
        Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>,
        Mike Rapoport <rppt@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Vlastimil Babka <vbabka@kernel.org>, damon@lists.linux.dev,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: (sashiko status) [PATCH 0/2] Docs/admin-guide/mm/damon: warn
 commit_inputs vs other params race
Message-ID: <20260331121943.GA74409@macsyma-wired.lan>
References: <2026032915-library-embolism-b48c@gregkh>
 <20260329193226.59025-1-sj@kernel.org>
 <20260330142205.e7c7d7b47ec15a634f6eebf4@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260330142205.e7c7d7b47ec15a634f6eebf4@linux-foundation.org>
X-Rspamd-Queue-Id: 05BFC80012
X-Stat-Signature: apupiaz4pi43p1xr6p6ghpo31wecss4z
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774959663-160028
X-HE-Meta: U2FsdGVkX1+C3wZHk/2reyThcMrlmWT0KI2phEUm48Igt3Kpw4j+RKeHKQn9C/uTI6KEsVvoUFVM4Asq10t4JfJmkHCy7QrJ/esS8IygpUvedVumgk7mzr8l3cbikL1IsijW7fM/yZItMOFQ/rSec1tw0xT9dN9uTVTV5CZdYSYG69Z3sG1v8ME0zsnnNsJDRzfX6qeoQL6aADlydn+HsLRg5lAlCoBbyvmYSkZxb9hd6hwBtfdslfFJ9c6PAGUGj3obxbOdRRRhLhNimsfxbthVymMi/nlPQ1DFNX5D6fO/h28cY8IoyHHoVnVM1PNSkpOY1rionKdF7I5H6T+cK6mLpuTSTNMWL2RW4gdnmsPhYAPedNmDWdfCVS+KbZSoPHm16OqxaX5y25ofmrJ09v8SqyOdTYHWOIcqqqvMEUfLZk4itm1XVkC4AxebPfQThj2z+PwD0Ta58/IqHZ9aYNm3lqTBwCvS3CYQz2quzve9dhrR0FhS0kf3OXFXIfKGm4yqerXPhrXbkClx9GX0QzW5VePbKWTAMjmGbmVK9mvUNatIFWDaloVw24V24yRYsI77kEnFKztWCs4JBkb6ReSkT5pNN7HGhSIujXXcWZGSis7HMcC1vkERM+km4u5wOIalK9Go7hyXFX6+WTeKpd9iAQX0mJJPV/Bb3q5eOrLk8qlMuG9j4r9SR59x/h4EP4xviU+uW0lze5pOieosEJeqdIPXL/jBhLgGKMjasPmbOT7dszdkMomKvtFTQjrbeQN6+feD2Y7GMKWNFqHc1IqHB4jxkNZgcLN8elzxPl3PgqNay4gupvPBIn6ax86oy+gVXtkniISSYPPerfHgkB83kTJWnFImoQCP8oMFm7DoDH5USkWDt/at3q+NfVO+f+hgpI+QZ4U0V6MswhijrwxAlGLB/YK/oLYtiG8Y7ORgOx84jJuIQ8yxzzU/5ErgRd0pedbfmIjLl+wOC7o
 Ps3dbiGC
 tOOCfOvewveDVzBMMxBLDHSi15GOZbrZicd5Skvmolubr35t5e+ptbGeKlfWIrTH7G22gDr5BmHsiL9qjcjuu2Mh16DVrWBWuPUci6g1zS02QzjWyKdu7aLQtfyx8Otx50b90QSodFFoxf1hCedFDhmDr1UKJoMHuJu1Mtihnv9piPyKaQvV0Ck1sHkfOG7MoBORBL5WsMjYN11JmpNX8qgEKUJLTMvu46j4UMa0bXOaCU2yhuu2UbfdqrbZ40fVJ8arw0BD/lxBnOyLM4DN/HHvx4Lhe3ZUbePIaOSipicnNN/YwLeZCFHUNDgbHbWFQLXUXfwWN7C7U2kQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 30, 2026 at 02:22:05PM -0700, Andrew Morton wrote:
> 
> I view Sashiko as primarily an author tool.  Sometimes I call it
> checkpatch++.  In a better world, author would be able to sort out
> Sashiko issues before ever sending out the patchset.  But in this
> world, a public send is needed to obtain that review.

Note that Sashiko is fully open source and the prompts are available
in third_party/prompts in the git repo:

	https://github.com/sashiko-dev/sashiko

So people can run it privately, although they will need to provide
their own LLM credits.  This also means that you can use some other
LLM besides Gemini 3.1 Pro.

Cheers,

						- Ted

