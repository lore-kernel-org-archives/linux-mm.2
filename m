Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA0C6103E302
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 00:09:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00DCE6B0095; Thu, 12 Mar 2026 20:09:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F23B66B0096; Thu, 12 Mar 2026 20:09:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFC706B0098; Thu, 12 Mar 2026 20:09:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CD9FB6B0095
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:09:30 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7EC221A04B4
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 00:09:30 +0000 (UTC)
X-FDA: 84539105700.26.FCFECC6
Received: from flow-b3-smtp.messagingengine.com (flow-b3-smtp.messagingengine.com [202.12.124.138])
	by imf27.hostedemail.com (Postfix) with ESMTP id 68A3C4000D
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 00:09:28 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b=nmFe2jtL;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="G 5Cai4k";
	dmarc=pass (policy=none) header.from=ownmail.net;
	spf=pass (imf27.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.138 as permitted sender) smtp.mailfrom=neilb@ownmail.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773360568;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KgAiLbof0iO8cGF8i0bS3fRoWLrp1RkGsUr3z87f+QY=;
	b=nMJNidu8FYRbC1JLBJ6QeySnqPOQIYtP49tsj47bprvRul0AEa74UxSlYvH+LyoV1nzSak
	vdwGGXW6U5l164PijEXMs4QrDX/uJAmBpmYP8bDJxe3o0EjiCnxx+POJAoPk4LA7yjHh/T
	4BR1BV1kNT9KniLWE19Je71qXV3E9sk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773360568; a=rsa-sha256;
	cv=none;
	b=iTrbJW2dapQZ3F1BMbDAGLVPUNBjUVw5EU+hMz/8HmmsFmvIgIUAUMCOlmTJfoqTwlv2eU
	YgWxOt8RNf0cjun44jCJE/hYd3sMpSny6gZz+HL3+H84eu4ujn1+qeCP3SR0W6EmXgfLM2
	VkPdDpDrKrhEEHjkXVCvsaxdnCrJDn8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b=nmFe2jtL;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="G 5Cai4k";
	dmarc=pass (policy=none) header.from=ownmail.net;
	spf=pass (imf27.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.138 as permitted sender) smtp.mailfrom=neilb@ownmail.net
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailflow.stl.internal (Postfix) with ESMTP id 453521300F4D;
	Thu, 12 Mar 2026 20:09:25 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Thu, 12 Mar 2026 20:09:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to; s=fm1; t=
	1773360565; x=1773367765; bh=KgAiLbof0iO8cGF8i0bS3fRoWLrp1RkGsUr
	3z87f+QY=; b=nmFe2jtLyLr+7u8+TDKRncwnQQgfmtMxU9rW2fcZXcAX5N/O+oK
	mkTcvLt2tGqnfh0yQZ9VxfeJXHOmQK3xmRCh0WkZO8z+9EbGkHt1EK+1v9oEDQFk
	yjK2H4B7GbHLcXZXF6XJNsP5Q5oExxA0/3HptDHC4Yo7bGMxV66pr3UW7B9oRSB4
	vuiTbATRXYBbLXhvd6Op9YEKWgq8ir7OPi6JV+oRhKZvn8t8u83ENmYYrl/BoZV0
	FrCRFffyXHlTGaGOZ5VUzpnpHtLR7Cp1SV1LfUlzqP/nSXhBI3LJq0G6aafkvcXQ
	H921q+OqQ7yY81EaudsM9yPaG6U2Be50mTg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1773360565; x=
	1773367765; bh=KgAiLbof0iO8cGF8i0bS3fRoWLrp1RkGsUr3z87f+QY=; b=G
	5Cai4ktm8ZYp5XyzSdEJarMpSfeXDzWAL8MTxUvYBQ2hpUgY3TIWYBA9NiTzGeNa
	5E83ul9G/GPuOexqHFwoNmE5Bf87gj016HXSgb9HA2ajcfY5cLlR/6Scnq1+bMSy
	L/Puu8DC52gTGANh4qz45QluS+yFcFx8cBkqURrLJFH5bOAyWf/oR6Uo1r93DRwO
	ChU+IBist6Pp1G8vs9yINCx1pw7Dl8SVJBTw/u/RobXjWABJlCOcI6SzK3FmMqVv
	JWB6ykQWBhykIIJXXf4XNnPkhW+lXc0X5IwRHItIgUJymc4RMF52UynxsiryvgQn
	Ohgl8jSg52zXQ1Ht0jvEQ==
X-ME-Sender: <xms:slWzaeXV7qa1u6neLd6Q1-cVt0VMASr8cnqysAFQocSTAtEfKc0JvQ>
    <xme:slWzaeSKlwNXuQd-ytFXXY0mVc_-Zjwa4_mmoEgCEIxrE6aOdvb3p8liU_ELdbDzk
    UaaJ6Rv9sIirpntfCZ3ed2iOF6DIF4YVBR0WyA36tWvjzE7914>
X-ME-Received: <xmr:slWzadcI0WZE_K5ZNf3p0KQMTKhUmZqGQsTQWME1TwSj7PSSkE9RCFBWyBYhQ55dSIow75rJ91K6-dY7EINULxs6lGnfRrWsj3AxXRa0e5UN>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvkeekudekucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurheptgfgggfhvfevufgjfhffkfhrsehtjeertddttdejnecuhfhrohhmpefpvghilheu
    rhhofihnuceonhgvihhlsgesohifnhhmrghilhdrnhgvtheqnecuggftrfgrthhtvghrnh
    epgfeikeetueehudeigfefkeekleegheehueeifffhieefvdegueetgfekuddukeevnecu
    ffhomhgrihhnpehgihhthhhusgdrtghomhenucevlhhushhtvghrufhiiigvpedtnecurf
    grrhgrmhepmhgrihhlfhhrohhmpehnvghilhgssehofihnmhgrihhlrdhnvghtpdhnsggp
    rhgtphhtthhopeehuddpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepvhhirhhose
    iivghnihhvrdhlihhnuhigrdhorhhgrdhukhdprhgtphhtthhopehlihhnuhigqdigfhhs
    sehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidquhhnihhonh
    hfshesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdhtrhgr
    tggvqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlih
    hnuhigqdhnfhhssehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhu
    gidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinh
    hugidqfhhsuggvvhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehl
    ihhnuhigqdgvgihtgeesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlih
    hnuhigqdgvfhhisehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:slWzaSzNnugwYNYtiVWYHc4qaDBmXyQ51PSSBJ1uiNVJapnS6gluPA>
    <xmx:slWzaeEAu6gvMjez-LKBYzOhXf5W2TUuXYdFq9RYM3BZ9DviPSnwQA>
    <xmx:slWzaW4NCFWB-i4WBv0KYxfPr8CoLpfQ8pVU8lId_PRL8FTgtUuCaQ>
    <xmx:slWzaVHk7pykGSmnnTVs6z84wbljsuc816F1d1tD0LoUWms4qvgBoQ>
    <xmx:tVWzaRho-xmNtiFafDRGXsj1bH7ybmYtyFLigxgHrazcCccpxnyLB6O->
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 12 Mar 2026 20:09:09 -0400 (EDT)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
From: NeilBrown <neilb@ownmail.net>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: "Alexander Viro" <viro@zeniv.linux.org.uk>,
 "Christian Brauner" <brauner@kernel.org>, "Jan Kara" <jack@suse.cz>,
 "Jeff Layton" <jlayton@kernel.org>,
 "Trond Myklebust" <trondmy@kernel.org>,
 "Anna Schumaker" <anna@kernel.org>, "Carlos Maiolino" <cem@kernel.org>,
 "Miklos Szeredi" <miklos@szeredi.hu>,
 "Amir Goldstein" <amir73il@gmail.com>,
 "Jan Harkes" <jaharkes@cs.cmu.edu>, "Hugh Dickins" <hughd@google.com>,
 "Baolin Wang" <baolin.wang@linux.alibaba.com>,
 "David Howells" <dhowells@redhat.com>,
 "Marc Dionne" <marc.dionne@auristor.com>,
 "Steve French" <sfrench@samba.org>,
 "Namjae Jeon" <linkinjeon@kernel.org>,
 "Sungjong Seo" <sj1557.seo@samsung.com>,
 "Yuezhang Mo" <yuezhang.mo@sony.com>,
 "Andreas Hindborg" <a.hindborg@kernel.org>,
 "Breno Leitao" <leitao@debian.org>, "Theodore Ts'o" <tytso@mit.edu>,
 "Andreas Dilger" <adilger.kernel@dilger.ca>,
 "Steven Rostedt" <rostedt@goodmis.org>,
 "Masami Hiramatsu" <mhiramat@kernel.org>,
 "Ilya Dryomov" <idryomov@gmail.com>,
 "Alex Markuze" <amarkuze@redhat.com>,
 "Viacheslav Dubeyko" <slava@dubeyko.com>,
 "Tyler Hicks" <code@tyhicks.com>,
 "Andreas Gruenbacher" <agruenba@redhat.com>,
 "Richard Weinberger" <richard@nod.at>,
 "Anton Ivanov" <anton.ivanov@cambridgegreys.com>,
 "Johannes Berg" <johannes@sipsolutions.net>,
 "Jeremy Kerr" <jk@ozlabs.org>, "Ard Biesheuvel" <ardb@kernel.org>,
 linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
 linux-xfs@vger.kernel.org, linux-unionfs@vger.kernel.org,
 coda@cs.cmu.edu, linux-mm@kvack.org, linux-afs@lists.infradead.org,
 linux-cifs@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 ceph-devel@vger.kernel.org, ecryptfs@vger.kernel.org,
 gfs2@lists.linux.dev, linux-um@lists.infradead.org,
 linux-efi@vger.kernel.org
Subject: Re: [PATCH RFC 00/53] lift lookup out of exclive lock for dir ops
In-reply-to:
 <CAHk-=wh92deXvH5iXCo9mThXCBYt-jRcVu=z4kiH-f3+wZQOHA@mail.gmail.com>
References: <20260312214330.3885211-1-neilb@ownmail.net>,
 <CAHk-=wh92deXvH5iXCo9mThXCBYt-jRcVu=z4kiH-f3+wZQOHA@mail.gmail.com>
Date: Fri, 13 Mar 2026 11:09:04 +1100
Message-id: <177336054496.5556.4842794610845842132@noble.neil.brown.name>
Reply-To: NeilBrown <neil@brown.name>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 68A3C4000D
X-Stat-Signature: icxo4rnotqkgi6j1mm8pcg8jmpk43epn
X-Rspam-User: 
X-HE-Tag: 1773360568-31097
X-HE-Meta: U2FsdGVkX1+uQtoAv2tJTuK2KRgLvcu2K11dAtv0PChg237Df7F0JQTfs9+TF2G6kVnmgZqNKPJ5d9o+rSlq3MyfAb0i45R+TvJ+6k9OwqJviddmgh7nXUh0wLJGq8M7KPEjQ0X/NH9N5bnQSWmjFt9iC/sYeBwU7s4afyi6p/5AWy4mTvvymO/TIOUv3/8tZX98zc5sinK9N8H/XiN7KN2qLTKVTMJ6MtthGB/sm5bIMC20RGt21Yltb0NEW6Yrcd6jpPvor7ZLsZ/MPY7iEEFncaRwOkv7MnjzKcmZcxtiITf+N3UcplPX9LN49384dB0FRqU9HWHgVuf7m2hydwpkqWPW/iNcxwGFj/6d9yNFVqMLXCNND07LB7BRvxomBG1yIXSLPkJxmBn2FE0kK/n/QnP8ZBRV2+eaZYg0q8CCvYLhd1MvvKKnHMJGL7DvsieyY29QgdCPEET6eu5vgzkqeV3oPoY6ZETGi9dpGcTQ3QSqHy1yJuIIf3yCvRkrW0QrupFT+Adj3hJgPprdwchTPJsVLcFXuGTom9wdtkaXy6n+UbaNX7E5NNHRYNohQfO4l/J0jr8ONNNdLmwNKJUsuLbn7KdB8veGdRj1Lxw3TnpKOylr90kLJNl4TMw5Dj3SeXYc2t4glADqy9g2G2GLuIhvO0yjBojqszHY6gqG5dE+sP0+4KvPcECfUNa/9X7MH2R9HLQuYJBMxPsevDBKFjvacvqAp/+pm6rsxl7D4OM1uOBX6hHun2exO2YeqV9OK+lOfYDiNrQfncOQ6OQx3OwxWbC7c0VsFvlvytWZWf+xg2TXk6hxNtF+feIjMbmBWdy4kmOE8uHnoVrx1+jrEN01Yh4JqpmvDPTsATSydGGG1GrhhLYLPl8yh+FD/6dIn7jQ5XaESUlKjW15hQCqvWP0gGDfqjL//1dk+xIotDJvdFanBDIb9f+HfP5R+T6F/LdlN426PUyxqr2
 wKnsz8u6
 yx9pyEE0k5rx6k71KK23WKksVeNY7IpgqIU9haDghcAfmGVIkzT7vfUOmMeTaTENnl/XAOSkyaVfn3xwBswVRBobbPhCKvjksfMoI0jaZYdci6P+1x2I/D7dgczE3gSGt9aD/+kuf5MCGeESA02NXArD+1Ae6RGZ4BqxVzkvoz374a1ujf5dxB5QK2XuWLEX8emZOo5qmNrZZZDvAlMs8ky0fi+QRRnF2Vvqqyf9fLV68CuK86jf0ZHX5k3WRqc8GMeBEH/e532plOOTKQ1JXXMgKc+0/Bw+DiDanWkUmUZBLzufvUdxQlYRhWFsP7VJBu4nxrRT+cMYRnqZR717MTtgwX8qRnMwhf9Nm4QhK0nFzpr/x7DvY+SokL0Z4Bqpg6G3BKgKoTGlqT9zQnunSLSAj6UvI+aea2riNzBhrpWwvfCdGx/BH0atfzjKFpGwf6t8TR1ewuNaiOm8s+ifQ06XkwpwEH6cckkluu6bDmJFcho4hMZPPH7uPwsTjsQMXx1lLOVB9BFeOD4oHeYE8A5J518S1xyPUrgOibKcaWvAjVwfRxs8Ol2jfyDICXwBO5BQq6GQpMevcpLdYRnfi9yOZC18ZrqZcpijCsCpqzNfpiEFDTGoyDx5+TSmh1LjsOXZkQuq3GPnA1bB/E5HHCmbk9uCgjclZBL+72BCqEyaw0eoZI80VRxlcns5EfGrSny7GCFbv0Iwa148Kv+xJk1QBqWG+h+3Rs0zLuqEyYD0NXU4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 13 Mar 2026, Linus Torvalds wrote:
> On Thu, 12 Mar 2026 at 14:44, NeilBrown <neilb@ownmail.net> wrote:
> >
> > This patch set progresses my effort to improve concurrency of
> > directory operations and specifically to allow concurrent updates
> > in a given directory.
> 
> I only got about half the patches, but the ones I did get didn't raise
> my hackles.
> 
> HOWEVER.
> 
> This is very much a "absolutely requires ACKs from Al" series. Al?

Yes, I'm looking forward to Al's thoughts

> 
> Also, because I only got about half the patches, and there's 53 of
> them total, I'd really like to see a git branch for something like
> this. It makes it easier to review for me, and I suspect it makes it
> easier for some of the test robots too.

github.com/neilbrown/linux.git branch pdirops

But if you have only time for one patch, 52/53 is the one to look at.

Thanks,
NeilBrown

> 
> But again - this needs Al to look at it. Iirc he had some fundamental
> concern with the last version - hopefully now fixed, but ...
> 
>                  Linus
> 
> 


