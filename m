Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDDD5606EEBD
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 08:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=AAfP9Y7e
Received: by kanga.kvack.org (Postfix)
	id 01AEA6B05B0; Fri,  6 Nov 2026 03:00:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0D736B05B1; Fri,  6 Nov 2026 03:00:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4A296B05B3; Fri,  6 Nov 2026 03:00:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C40936B05B0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 03:00:01 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D244EA0C6D
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 08:00:00 +0000 (UTC)
X-FDA: 85403945760.03.30A64BA
Received: from mta1.migadu.com (out-28.mta1.migadu.com [95.215.58.28])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8E0A620004
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 07:59:58 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AAfP9Y7e;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.28 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793951999;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qdnMAlZZHT0XekQPrSCiPCqqcTykoSAZA6qRfBxzlM4=;
	b=UQXUGmUqccrV8dshSznftZWgOk156HGDW3QEkJatlvErQ5fRENesiMKJhNpMlHXYm70/nw
	mKcQNhuzrFEUR+MkoZOjmPeG0K0QIuHLFySCAYmcyVU+Zf0dsNWk3MHAil8XuaHU6OVKwW
	FNrEnS2/xN0ADZV+WIy6b0dlFLWsRVE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AAfP9Y7e;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.28 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793951999;
	b=f/2gQcdRWR5JQfc6gTG+vbPMCt5eqzxiAgncuCctOTQ95R61DhoMXbeRBiz8nU60zHcUeV
	SYfi5GQ+skQQzxd9xE0PcY7ZchXfh3L0zs7Kzjnwlu8PtItCgDdk2tTLQy3PV35FbvG8l/
	f1R6Yq8vhOzrTWTAr6ODaDqQhEuoC3Y=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=kjWEZaRnpbQPyxgJ4wJyDqlnc6ape3Q8i+3y7DTnhuw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793951997; v=1; x=1794556797;
 b=AAfP9Y7ezAT+sAnUC32UUWcy5UZR/XKOXWl8ExQBF25yRlP0fkljM3aoDoehs461HTMf36Wn
 bIVUEki97elFAjMFyOFqQKdIzB58V36IgSuzy243HkUt9mAqr3hGiV3LUyFyi0jfxSokBPbhQUV
 MuveaTZ+xfdAkasVW7xqg1wg=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 8a365bbfc61020ef;
	Fri, 06 Nov 2026 07:59:56 +0000
X-Mizu-Trace-ID: 8a365bbfc61020ef
X-Migadu-Flow: FLOW_OUT
Date: Fri, 6 Nov 2026 15:59:45 +0800
From: Hao Li <hao.li@linux.dev>
To: Harry Yoo <harry@kernel.org>
Cc: Zhan Xusheng <zhanxusheng1024@gmail.com>, vbabka@kernel.org, 
	urezki@gmail.com, paulmck@kernel.org, qiang.zhang@linux.dev, 
	akpm@linux-foundation.org, cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev, 
	linux-mm@kvack.org, rcu@vger.kernel.org, linux-kernel@vger.kernel.org, 
	zhanxusheng@xiaomi.com
Subject: Re: [PATCH 1/2] mm/slab: restore the rcutree. prefix of the
 kvfree_rcu parameters
Message-ID: <au2IvrBEimc68XVl@fedora>
References: <20261028134647.3176080-1-zhanxusheng1024@gmail.com>
 <auIRU802S4Z4yAmo@thinkstation>
 <auiedkWD41Ok95TT@thinkstation>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <auiedkWD41Ok95TT@thinkstation>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8E0A620004
X-Stat-Signature: uemax6himzdw6zparebegybmktyccx6a
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793951998-611422
X-HE-Meta: U2FsdGVkX1/aq+QkV1R2h6h0ky/qAUDakTFRmmIiBXDzLsaKU71SV7WRqVNHrqRYGjfXuaJMshZxBQ4zBJRwqeMN7REgySPbRRQBolNIyIPtkEW3DZYrIfRCCr56o7cEZKVaqPc+f4CYyz9LQP3i4ATnNAABhRk9RjdccVYxKfdkohFtIghQQS6VjDAQN/CZozYWczXFOI0C+bbpvMCLxJ815Vpev0scRVkGVHH4s9rOp/V98/KmAvuWoz9jtFdypji5CQ0ASeESCAcODGr6O9fjajU0MZQxuFc6JBngR+8mRBxMOWD7icv7aj/1G4vp3fU1DXVTXHFvzsuNJ2ZkJLDlKknw/YYeFPrguUtteV9FVv2PQrLq9EAtUGJSHNWP9mvN5kbv/akLsr9catTOfzxJ0bq1WqsZEaxd8CKNuWijtnz7VWYrMwoQfOF2RpNZNAU5a5cNHQk3ztsfIzibpTRaLE96Cdlj+UjnLfhN3gSEYbRxRVkAch7yn0uSPbZuwmQzdivM0ntjLQ/cTH2/fx0OFhHrj78b9vImsfysz+HOfzyYKYcYTSq4SSfFNIW9A+QldFaj3DVyH4uV5fUH6j57rxYmNGmhxxOeGBNfkLK0jUrt/E4F/MuassDx45vgPxMe8DArFrnT/IQy0GDhk3rTzIbMW+ppdt8QBgiS0Pw3ugXnc3RKIxxhImVsDRI2/ol/Mw/WHGryEMsBjqY6y50uEwsF7yXTkFAxm0TnryCvLDlu4MSUKGAxhQLjwxTVRAtXLWJmGJ/C3RY8H3Xn1NHacO7/LF4tMAKCe0TqhXfGQSmomJtVYchD1dlZWlYfoNO5/4tdPEAgcHUNyITL2rUSoXevRyZYJr/9AbP7eMJajl1ipFbV4N20AObkg3qDX5mbp+s49ezbb+NywiGGiWnf+yNXfEIH6OaamNp2CaJH0r4cSv9cyrKuB9+BO1EtpQssaPB8DNmnhyawpmJ
 h4VoWEF7
 /NOmFQCqxmkcJ5n6wUxMFmlTfPd6iloZUSLXehwKMOQNYEOF0GHwl4w0qKNBbalc/DTMAXPBP0R2RwUrLQkwIG0o+r+4R/2jq+JUTkR3we2GiIzPI0aacJUG/DYroJr7SnQhnQt682al5SvzRC37IHF/OyDA+5gPBdXmeUp17oybucJASXCwHO4x4CjZ96sVAHvHL9IndfUi5G1KxTQHj4cqsjmdZ2vVOk7BClhOJt66MVS8n9WF+wW2uSGE7ng67MVZZ89calxcAAeiXvjw/RBuadDpJvBBo8Ehz/55Im/Pb8DKLLGrWxJI+befRgJXfq2mrwinHVLEiyEe/bHp49DEAAIpGsHBOnE+MHB5MSwB25IlMxvvc5+SAEHAtt3s5NHIvIctMGzwXxcrUE8kaSToGEa2vRSB5mDopptZX9d87kthYtIUzrJhYQi/uXgml+RoFqZXNrRzcPwbnM2l3mM3h1g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 02, 2026 at 02:33:43PM +0000, Harry Yoo wrote:
> I adjusted my feedback. End result:
> 
> mm/slab: restore the rcutree. prefix of the kvfree_rcu parameters
> 
> The move of kvfree_rcu() to mm/slab_common.c dropped the "rcutree."
> MODULE_PARAM_PREFIX, so rcu_min_cached_objs and
> rcu_delay_page_cache_fill_msec became slab_common.* and the documented
> rcutree.* names are silently ignored.  Restore the prefix; the
> slab_common.* names, never documented, stop working.
> 
> Fixes: bbe658d65802 ("mm/slab: Move kvfree_rcu() into SLAB")
> Cc: stable@vger.kernel.org
> Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
> Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>
> Link: https://patch.msgid.link/20261028134647.3176080-1-zhanxusheng1024@gmail.com
> Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>

Reviewed-by: Hao Li <hao.li@linux.dev>

-- 
Thanks,
Hao

