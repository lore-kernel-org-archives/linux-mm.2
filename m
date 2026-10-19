Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFB47606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 20:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N89tUUBh
Received: by kanga.kvack.org (Postfix)
	id D8B146B036D; Mon, 19 Oct 2026 16:15:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D62E26B036E; Mon, 19 Oct 2026 16:15:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9FBB6B036F; Mon, 19 Oct 2026 16:15:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AC99F6B036D
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 16:15:06 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 346D7120836
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 20:15:06 +0000 (UTC)
X-FDA: 85340479812.19.2AD4470
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5DF8320009
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 20:15:04 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N89tUUBh;
	spf=pass (imf13.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792440904;
	b=7eg0o5x7qOdHmqrFpvORZvKx17x6YvtQV80fQ6589gvTjueAdSX1a7y3F+lDJhPkrYw/6Z
	aZJXWQBnveEO54quBKFcftA05kgvQADn9D12kZSCBQb+8M2UUlWW4rX7y5ySyJjecNQcBF
	xQAD28htjtKYzakJOsgietT+zFeqmdE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N89tUUBh;
	spf=pass (imf13.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792440904;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AhIlOjs985Zg+2gE7dl6XqY7gUTcdF1bgwJNykVLqps=;
	b=fqhWTskKL/kbvOAprD6RDP7W7rjjcbriPivcONaNRZ4ovIx2GHADNJhDiF7O5nEvqt1S09
	cw17fOhzwFU5S4TAy374+hjkvThxQDajcYtbWGtr10CeN3OOZf1qMd3oKUgNCa+igkfty2
	w+tnzoyxTHTaerxIUGmEozjoAoA+8vo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C6ABE40441
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 20:15:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB4E01F000CB
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 20:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792440902;
	bh=AhIlOjs985Zg+2gE7dl6XqY7gUTcdF1bgwJNykVLqps=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=N89tUUBhdnnH4cRVRReEG+7AuUKZ8bKhQos2XKMIeLuzhaIGgzFU1MEsL8El2o65z
	 Oso89jldU/IXvE8y68G21qYTfPEVAADmVl34Zn6xE3dvMU0IrHuWBcy0SuipjdFA97
	 D6ZKA3DD18ObVzYo16lGPenP9m2kxEsrMG4HIP4tWlHNBhNPQW9s/6Iy4j0KAel6Ey
	 ufbibbVvHW+G72xqzudynCFcO2sgODS04H1Gz/lmY/oFXkFSWFuVUnxeUV3QMwxR/C
	 l1n/TKQt+JjUawCkXwPzd7BjKov9GeWKlWMJltuDepkdn6RKzgblcKCEsmePoJN3xL
	 KHen8zb1olhTQ==
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-93e64d52949so249666385a.1
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 13:15:02 -0700 (PDT)
X-Gm-Message-State: AFq9FYJPM9CgRsXhmHBibF+UimXA40vBge2fH1J8GcMDZG+WTgvN3wgI
	wuMycuDL+iGXnVnziWnVfx/PUN3GwMFm1FaF/yGtgf2/VZgGIkqXy/iY+RLd9MA8ZI7bmpGwJaA
	83xu65yk4L5NMPGbCemPKZ57pLZZAnHg=
X-Received: by 2002:a05:620a:4891:b0:93e:a8c5:132f with SMTP id
 af79cd13be357-93f29c98743mr1615223985a.29.1792440902055; Mon, 19 Oct 2026
 13:15:02 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261019185002.3428594-1-gourry@gourry.net>
In-Reply-To: <20261019185002.3428594-1-gourry@gourry.net>
From: Barry Song <baohua@kernel.org>
Date: Tue, 20 Oct 2026 04:14:50 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wqoGNOmijowgWPc9qBhQCN9EhoxFKgFKuF_ruW+YK8xA@mail.gmail.com>
X-Gm-Features: AclHuK_j7CrYt7emO50ZmEB2M4Ny91OZbg0vtrIa8RG5q-BZ0RYFwDdSzdFngkI
Message-ID: <CAGsJ_4wqoGNOmijowgWPc9qBhQCN9EhoxFKgFKuF_ruW+YK8xA@mail.gmail.com>
Subject: Re: [PATCH] mm/vmscan: reclaim every zone in per-node proactive reclaim
To: "Gregory Price (Meta)" <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	akpm@linux-foundation.org, kasong@tencent.com, qi.zheng@linux.dev, 
	shakeel.butt@linux.dev, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, baoquan.he@linux.dev, baolin.wang@linux.alibaba.com, 
	hannes@cmpxchg.org, david@kernel.org, mhocko@kernel.org, ljs@kernel.org, 
	dave@stgolabs.net, roman.gushchin@linux.dev, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: bb7fmqbk5fktikyohr6u8hzon5wibdaa
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5DF8320009
X-Rspam-User: 
X-HE-Tag: 1792440904-614465
X-HE-Meta: U2FsdGVkX18j+Q17yAsb6y5YRQmy2sMdcfMRn3VXo22u0ayaHBjzTgZ6Cnkk2z3tOM4wGKSVD6NZ20muu3eFDcel+NGDW6iUqLsGRC6cJSHcQqWpKV0b0zdP3IIM2G6LdlRfFTApP75PFHMLVsWMI+q125Za/BuwAXMRdLk8dhVsjPiXGsd3bPgWQ2u7B8d6twJwKK9pzBCCTrNXznNeg4jtUSoXU3pcLckrT7klOp3gQaFR5wFMscWRwaWh/5Vu8HMomH7iR+0VoIJIVQTtZJqbEO5jY/5wESccscFfcpLN4YCsUPjmnb5PUFipFaOXKnPGDkzQ18/XOpUcBD2/eseESOxHRkWMMLk/17ML7USPrkL02OGQBqAosFNKAwSpz7Jnb1rucvRUSvs2z8zKcD9BNyL+DETFtj2DQB8PrniRFXwShCHc5spv0B05dusNRTGYzDVSHE5U/ErbFNFtTfyMBBj9qCJeqNWE5mJUiKeR8WOtn9F9jC0coT3ZO2z6bnWu0/IH2IjbDh6m63Lz3G7JsGvak8tOUZLF6RHytL8xB+j7Mgz70yZsQ6czuVJVzwVuVhMzvqY7IqAOA+BIjFoQ1zPi0FMQZT7EQGQK2Qfw5hj3t5blQzpnwuVcTszDR4GWt1NFmf6H1eSyMIX37VGRAr/UHPFh91YEPpcSNC0nb3MTW7hA1NMZ46gDnM37h/stOD1D9hhZ07y6VGvGn4ShuCtbFTxNgOtAl+UCPhPGT5gMqLra4hV65EOcqU5sX1QEVBxvaV5EoMhf7p13I5H462h/0U0IhudBuLyvtTh1GtRqfm0KUtDpGrmqnkNJqK9HaVKdK5lIyBwaoCnl3gJnxtbCA95d8i2nBQ7SYM6CC4tUyCamh/9HE2kOSnQdtsf4AGL8/ADLwJMd2AYoBGicgBOgINb0G8H51vXBmir0GaSn0Hq91EnHPvBTrAJ8xtL5Ruy6ZYSyjBe42my
 EDxvduJM
 WdRsIttyu90CkOj2OCE+VlFaNpk5rSjbGrh3H1O65uLOu9u0z6ProgBiy+0J1V81XUaiT+0UQO3XQkYyCoJ0bv2kZHSZAwMsOYkUfQmiP/TXKZkN7ziTL5oTucu7mxjQ2HM35+Z96kksAcLp2wMRECi22sHwBLFz8wHIS73yC/qQaOyeKyV5Lj/lAeS5rB5yrkWo3a2mNr/YoffTZL0SYT+lWrrvFhUtnAXEXOVFLqA/dzpzJP1aNa0+2FUzME/JVxhC/OtMHYrndz32ahnehzLsn6PRlu4lBuF032b01JERDxU9YEGfA+RLydR1ssgFJDPjDS+0C4bI/f3D2VqOpkQ+lfjIl7e/u1Lny5NWc5AJtcf76OVGx3oVekg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 20, 2026 at 2:50=E2=80=AFAM Gregory Price (Meta) <gourry@gourry=
.net> wrote:
>
> user_proactive_reclaim() limits per-node reclaim to
> gfp_zone(GFP_KERNEL), which is ZONE_NORMAL. Proactive reclaim serves no
> allocation, but that limit makes shrink_node() skip every ZONE_MOVABLE
> folio, so writing to /sys/devices/system/node/nodeN/reclaim never
> reclaims a node's movable memory. A movable-only node, such as dax/kmem
> or hotplugged memory onlined movable, reclaims nothing and fails with
> -EAGAIN.
>
> To reproduce, fill a movable-only node with clean page cache and write
> 200M to its nodeN/reclaim: the write fails with -EAGAIN and the page
> cache stays. The same write to a ZONE_NORMAL node frees 200MB.
>
> Scan every zone, as memory.reclaim does.
>
> Fixes: b980077899ea4 ("mm: introduce per-node proactive reclaim interface=
")
> Cc: stable@vger.kernel.org
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> ---

Makes a lot of sense to me.

Reviewed-by: Barry Song <baohua@kernel.org>

