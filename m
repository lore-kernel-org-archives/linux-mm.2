Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F8E2606A327
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 10:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=arndb.de header.i=@arndb.de header.a=rsa-sha256 header.s=fm2 header.b=Lx3oOVyr;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=5Tucp5Ch
Received: by kanga.kvack.org (Postfix)
	id B4B2A6B05B8; Thu, 12 Nov 2026 05:57:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B22A16B05B9; Thu, 12 Nov 2026 05:57:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EA666B05BA; Thu, 12 Nov 2026 05:57:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6D4396B05B8
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 05:57:52 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0FC7D1604F6
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 10:57:52 +0000 (UTC)
X-FDA: 85426166784.18.396FB98
Received: from fhigh-b6-smtp.messagingengine.com (fhigh-b6-smtp.messagingengine.com [202.12.124.157])
	by imf12.hostedemail.com (Postfix) with ESMTP id C5BE740005
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 10:57:49 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=Lx3oOVyr;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="5 Tucp5C";
	spf=pass (imf12.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.157 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794481070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Meslkpa8R+PBS0DyHZFPRgLYTJh3HuHkb0AOxumEFg=;
	b=WUKNp/lptIWn2S6w8qlzYhAW6IEdTldJXAos4xVd4USsOPJTwqwgRk4i6nvoXFOZFIp2N0
	FCuWyY9tqzneSP31fTMwLuQuwmAJJB03HcLtRpsFPcpso3GQFxNdsMTRZGjpITWTWWUhIl
	kmM09YlxzRwxfgR+ILFD/waS9JkdYf4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=Lx3oOVyr;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="5 Tucp5C";
	spf=pass (imf12.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.157 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794481070;
	b=377VxsnyFpnxPTxAJGoEuGTLtul3nUUIL6zb6mtn24ZQF+rMva+v8u3dvsOt4VhiIKmaQh
	L9CE4rP4uJFGxk7TBbNIPOhYAvWAqGb4ryJo9obAUIpe9tOMaA/CZXcvSOaBya+vGZDb2C
	S3KZopeS37NdvSssPp6SgYUd6/soPrs=
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfhigh.stl.internal (Postfix) with ESMTP id CE6727A012D
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 05:57:48 -0500 (EST)
Received: from ams-imap-03 ([10.64.2.23])
  by ams-compute-02.internal (MEProxy); Thu, 12 Nov 2026 05:57:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1794481059;
	 x=1794567459; bh=7Meslkpa8R+PBS0DyHZFPRgLYTJh3HuHkb0AOxumEFg=; b=
	Lx3oOVyr7xrldDhNotY/Y44ZUkWpUbS/Sw15HoBIt7zwVfFUJYzuhwJE6hHBi/f8
	72PdLUrfif3QbiaqWlxNR28c8e/kBp2q3B8JS74VmKGEIA51P5NyNwQU9UU2U8DZ
	5hOupRTbk/Bo1YRYVjiwE79692Z2HaOFkRbUqn04C0dAknhoZ/XF/BqXISN8djmK
	nzQpQlDPCzLVKROdNaK/NAazeqQ5iP1EORfBNzaq7ok9xgR2qwyEFHaDlF4Y9AlF
	XYa4+Lf5XVm+Qhxd+suZVmkwWbJXRviGrqHovHUmcPfLOq6ZV/oylQQuwfeVvML/
	U7opSxQSF50d5vGuJszB5Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1794481059; x=
	1794567459; bh=7Meslkpa8R+PBS0DyHZFPRgLYTJh3HuHkb0AOxumEFg=; b=5
	Tucp5ChVCBDjhl4dk5C7F5X3LVKTFsMP8gnn9x0MuH2+7jMPa4Nj+SIQT2DVG8uJ
	u5wupJm5rdstAzMZZInODnyvvfpTJfSSXwspucG8yFOI18XQA+xNSYU8OspFIhSc
	LO/T82B7R1uppnjALZIhacMzde9ZBYWKSQzN44nG7+0vSBMXLzlZpyo2vVWuFYH0
	fE8J7L53cCmOZj5msmFb4hnFvbEATEFuLAZdCbui2G1dPgjuzrWnaKOAF5Kwkf9e
	8FQ0yTD33WASXijjLCTz8CpmqYu/XHq6UATYTYTvybNI0UcKwDFTUQ2UkVbC+N6n
	CdlnYUUoCZMBRuGIDFwhA==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=arndb.de a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1794481059; d=arndb.de;
	mf=PGFybmRAYXJuZGIuZGU+; rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm2:rsa-sha256:fiTz6aoVXHYD+72JqyEG6MjflEVCpbhOCS9Ejq6mMuJdega
	EYkUQAvu6U51hpXVQxQvadmHCah5+5P4JVgsRBSgsvqio25vTe9mxPXNkXHaOQYQ
	JTnCwYnA25WFpcIbmYPRQty4OoT5gJWHxbSPqzylJUHXHhls8Utz0MOTZMWZjspE
	1oz4WcFG/P0iHJSlZLReEZsFDZC/y7ySKrkvW8Jd/7mau4U3N8U8+Gd8jvhHDqhp
	cUZX3VCQI7b50SS8zXo2vlsFLfSpuZ7iyh+mmi08wDHY5NMt/Fj7EvMcpZi+abBy
	P0oFsWMomHe01vFw7zOt0M9AZ6onWVO51bMToSQ==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-transfer-encoding,content-type,date,feedback-id,
	from,in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:QYGhyNrll/z2x43nzHbHMzcpokL6CuOf/GHVHHBnNG4=:9cBz8A60daXm+XxflR0ZEsASkUqul+qaMs0gX60bkz4=;
X-ME-Sender: <xms:lZv1aulnwhqAVrU2ywlIhlQkx3jcr_mjJ1oOcF-oQALIJdbh9W2MSg>
    <xme:lZv1agpofMLGq5k0IqsluYkWK-3JUTpfBoFK3L6DLiuUPYqcFGn2Enty4uF_-XQnJ
    z94b6dWlBxsjyCv4Ip2kz_9V8gd6SZusy2huFR7jeXtsherYI7qUTdq>
X-ME-Proxy-Cause: dmFkZTFPAb5ZVZzWlLcejKGx6E4VA3h8PqNfBXtLQtoFPOgpmgytfsUfOyDLCYXd2SSa4q
    2EH8IJ2PPzcvWQUIF8rzpRv4eG4RNXvx0NBusK63EGFOtvbarh8wH0CGqL2blZX5LnwxGj
    Bq7bb6BFYZpib28HfQC1ujCrw0Q8TBW7/48cz6euAfTCWQtTfGAuyvgN7GbpRZsmgRF2E4
    TCaNzGWqT+dNqpflZRaBZXkZZtt4lBXqOUPXc/rjd4+dtSMM8lEb+r/hClV3R/o7Q+s5sd
    1lcFl3GcCnNdnbplqVUVqfvmlm5/4bt3TMMk6ZNCk1/IOqRAfS2+h81eYDNbQMld/1X+lI
    8+vvCIKZ1a4bZphSYeDPjCLmrTmXj+ipxN85OGTScj/sl7+Ut3TC/P8rMkVApR+7BygKid
    SkK0hxv5G+rH+sog2zIEng3jqw0sOhQu7dCKfMZsvhYS/RJDLdeoB3JlbIKQ1Ys7dHJw2w
    E1GTp+3yFqf73WGe3gAJZsZogHWBjRGFo1jLw+xcZHLP9MN34ZbJcYdMqQYR6DX3zmMqyt
    U2s5m3k8BcCtol6aY9t+57PktWJnKsaEvlPS7qbnA2Qi397OHuVQYt2HBnl4g4gG0zdN1t
    W74OFEbJGA5QHDn0M9LErHNZjmr7Zm0RyUqswJebH+zD/PZn3cfiGvgMm5gg
X-ME-Proxy: <xmx:m5v1apYfRm6Zt7Y0f2U2u3xCBkE7OANuu7_SI_WuQKzpEBsoK_gakw>
    <xmx:m5v1aqwe9cSnJzJz-zCoa-M5X9VKgGBOT0Z-GKILMaQBtdU6hxleOg>
    <xmx:m5v1angYViALKmj2ClSkaSfBGAsOhh0oZTdF0LOqTWdiA7YmSiqtnA>
    <xmx:m5v1ahr24wqldhEb8CE5VCD_MYmhCuogL16D5SqQjqcPObg2XEt3og>
    <xmx:o5v1ag_90SnSwFh8o9nRP0b3a1tEHU8n2Te6e-_AnmGGK-27gNICHabi>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 82A8332A009E; Thu, 12 Nov 2026 05:57:25 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-ThreadId: AD8wiEBgakfZ
Date: Thu, 12 Nov 2026 11:56:55 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>,
 "Linus Torvalds" <torvalds@linux-foundation.org>,
 "Christian Brauner" <brauner@kernel.org>
Cc: "Matthew Wilcox" <willy@infradead.org>,
 "Kirill A. Shutemov" <kas@kernel.org>,
 "Alexander Viro" <viro@zeniv.linux.org.uk>,
 "Miklos Szeredi" <miklos@szeredi.hu>, "Amit Shah" <amit@kernel.org>,
 "Jan Kara" <jack@suse.cz>, "Zi Yan" <ziy@nvidia.com>,
 "Bernd Schubert" <bschubert@ddn.com>, "Hugh Dickins" <hughd@google.com>,
 "Baolin Wang" <baolin.wang@linux.alibaba.com>,
 "Andrew Morton" <akpm@linux-foundation.org>,
 "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
 "David S . Miller" <davem@davemloft.net>,
 "Eric Dumazet" <edumazet@kernel.org>, "Jakub Kicinski" <kuba@kernel.org>,
 "Paolo Abeni" <pabeni@redhat.com>, "Simon Horman" <horms@kernel.org>,
 linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev,
 virtualization@lists.linux.dev, Netdev <netdev@vger.kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
 "Malin Jonsson" <malin.jonsson@est.tech>,
 "Richard Weinberger" <richard@nod.at>,
 "Geert Uytterhoeven" <geert+renesas@glider.be>, "Nishanth Menon" <nm@ti.com>,
 "Frank Li" <frank.li@nxp.com>
Message-Id: <bf186643-780c-40e0-bde6-f2af90404a18@app.fastmail.com>
In-Reply-To: <4d6a3d68-3fc7-446e-9f59-f61d7475e22e@kernel.org>
References: <20261110145241.536019-1-kas@kernel.org>
 <20261110145241.536019-2-kas@kernel.org>
 <avNuQqLf9CG9dSsE@casper.infradead.org>
 <20261111-heimreisen-ungeziefer-empfunden-a892571f2c07@brauner>
 <20261111-thunfisch-wirbt-waldrand-822275b2d3b1@brauner>
 <CAHk-=wjPY=kfgnmtx4COEQjD5UzKx9m2-=KLGAZP4d=RKEH+pg@mail.gmail.com>
 <20261111-stumpf-montag-miterleben-c4e2feac8090@brauner>
 <CAHk-=wjGXBnme-N+HvbzHH40ftb7Suc=kZVT5cuintQWyMHJ7Q@mail.gmail.com>
 <e94bdf7c-eae6-4f64-bf93-0aeedca1a22e@app.fastmail.com>
 <32ad880e-5946-4703-9c6f-43ff59da39af@kernel.org>
 <3eb60948-8fc9-4682-87c2-c113e54e7d4e@app.fastmail.com>
 <4d6a3d68-3fc7-446e-9f59-f61d7475e22e@kernel.org>
Subject: Re: [PATCH 1/4] virtio_console: copy pipe buffers in splice_write()
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Stat-Signature: qpcpr5s5t4893ma4bc75uaoswb55kiox
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: C5BE740005
X-HE-Tag: 1794481069-128742
X-HE-Meta: U2FsdGVkX19z6GpoTUgsr/jnRrtQcEPtN9a5g/HMMcdj8U+pXCT4LQeMogeARij/ZruYRzs//D7uhQOjmdR6520npiRc2JGiH49VNXFsfetDuJp7kdLKxtcXCsytjcx6ciXidhMEnwOUSRJmNmrobcHUuzS14+ylAuJnuk5snu7FEkvPU5N/FbNpi4Auh/s54xXg9zc/TjzkdL1F3LoBPuEocCnOAjvTmUj1WGFpc6VdKdRvgOITa7hu6hn8KUbmlBBgsLpnqkeCA/fWlkDvXYQC5nDD6OXqSuvWShRw+qDZHC7fBV7pfDrrA/pIas/xQB+8mbNbgmyBZFjqdbAeS4rwX6Wpgl7uYdt7JJoC4NIm9Zh7ghnmGgNONV95gJClBsNBm7makbrei7FNWwjXeIrjmF/CgvDqoRhJhkU0RRp69u3Xbx+dXo+oa7TJK6luOgdieK3QMDpOjN1Rpi/tvyduQTqVIWgRNAYi4ZW1nh9YAZ6L5ws26o1kK2DRu0+cods3KEyjlhfgOFyxOytiMb8+8dkICb+pqtPlKv0CuEebhOHt1jGewIBoO1GJUNHePLN4z+MHcP7prGtPNFSwtWK1/5nh/HIYocmKChPfRXnc1VRy9dg5fo8qF9G6kSl3GIlRR5HXdMN1drjWvNnIhri0I5b50aUiHwkrfPbF8MERq5P0PMSwCtbMCO3haFo6Y4Bvavs4WEY/nF9A8LbZQSX0cJGRnu1IWzVYwaKUyXEcGKUSvtYl5C0NGkzIiLEDT1xMFVI8+5snNBpRrMQDWmZZez7fRzkLwBxIcVLjHnifPkHKOtrWiDKVRLUlCQTQIUkIrZP4m8dyb/b0iuib11TA9ucNvxOq5ubsQLJ487ahczGL6bLBRVsDdx/9Ut5RBjpS+A6qwB31qinsCQZzBuTKUQF4Eriw+vXisIHQAwQbTnqkiAWbo374D3ApmfURGYLl7FZf4vDRKSDhkj3
 4yDOC78U
 u6pt5txHLQmJ4a2i+KloQ9tXM4R56El52Selaw4E7rId/wqTLO2kFNqaleJJ1RkizxhySyC26xHF5FfGOKMZ6i44YntYXGrpM5qJniCAbULhH14HpNhwN+xxPPZAaaKMHlsLbg7GbTBkOQXXkZNzhpIb8k8swydIWxxzqSCort7tNe7jDXNChIWnHyypH2BVINmgJaDy4ZWKuy9aUtWhYJeMW025q1ENGeJZTH3iWuacD/WFrdPdVKH7ROU1aeXftsOuiMbI06OwDT+V2+XpU79t8Fw/KeYhVaGgvrG6rNuyMcXwYJihAg4qluCagmM+bPj297G6Cg75bUVYxGkTYHjzSqKoiFrhQzWQbVnQ1GQMnMe9jMUTobbUH9QU2W7PTVOuO5QKtlmgPzaX302NyH9SEXENoyaLE4KAY3m9RhUjQEJEl5F02RfQ6yBtKn2gEoC+5CU7+ugKi64eqAShuA5inwWKnYWnibIYl2nw/DkgoOd6viuA8qtsE47qtjxsfXsjwX/eRU3aLWaZyHQkaKwAvyMsrhX6q2DT/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026, at 10:28, David Hildenbrand (Arm) wrote:
> On 11/12/26 10:25, Arnd Bergmann wrote:
>> On Thu, Nov 12, 2026, at 10:09, David Hildenbrand (Arm) wrote:
>>> On 11/12/26 09:55, Arnd Bergmann wrote:
>>>>
>>>> I tried to push for what I thought was an aggressive timeline
>>>> last year, but that would still keep the Arm bits for a couple more
>>>> LTS releases and only gradually reduce the scope of highmem in the
>>>> meantime, removing support from architectures, file systems, and
>>>> drivers where possible. See https://lwn.net/Articles/1051010/
>>>> for a summary of my talk in Tokyo, including the slides and
>>>> a link to the video for anyone wanting more details.
>>>>
>>>> I also prepared a number of patches towards this, but have so
>>>> far not been great at following up to get them merged, sorry
>>>> about that.
>>>
>>> I think we can already start at removing CONFIG_HIGHPTE now, right?
>> 
>> Yes, I think my patch from two years ago still applies, see
>> 
>> https://lore.kernel.org/all/20241210160556.2341497-4-arnd@kernel.org/
>> https://lore.kernel.org/all/20241210160556.2341497-5-arnd@kernel.org/
>> 
>> If not, I can send you an updated version.
>
> yes, please, that also brings it up to reviewer's attention :)

Ok, I have rebased my old patches to 7.4-rc2 now and pushed them to

https://git.kernel.org/pub/scm/linux/kernel/git/arnd/playground.git/log/?h=highmem-7.4

I'll do some more build testing on this version before I post
them to the list.

    Arnd

