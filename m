Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8705A606A321
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 09:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=arndb.de header.i=@arndb.de header.a=rsa-sha256 header.s=fm2 header.b=OOUgwSFQ;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=NVWaEgIO
Received: by kanga.kvack.org (Postfix)
	id 82C636B05B7; Thu, 12 Nov 2026 04:26:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DD5F6B05B8; Thu, 12 Nov 2026 04:26:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A5436B05B9; Thu, 12 Nov 2026 04:26:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3A8216B05B7
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 04:26:26 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B91B6802CD
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:26:25 +0000 (UTC)
X-FDA: 85425936330.08.B76C4BA
Received: from fout-b4-smtp.messagingengine.com (fout-b4-smtp.messagingengine.com [202.12.124.147])
	by imf31.hostedemail.com (Postfix) with ESMTP id 8D53E20002
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:26:23 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=OOUgwSFQ;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="N VWaEgI";
	spf=pass (imf31.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.147 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794475583;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lu9VyNMW3mU5a5OEl9u5/3DZxAvGGfoqPTt/S5UCjdA=;
	b=lX8f0xrKypR7p3Yta6Mf3oC0unwkHdrNHDUe6hk8I+qjNGGoKdq0DgZTVCJBM80Qm4qq/I
	frngElc9f98D4Q9PCR9dxOpbGDyzC3FQR0prCIWKP7Ad1KL1xA6lhRBEQ3OMkgJLCq7iyl
	UefROI+ZSBRIsSVOEo8b1ODUw9u+wpI=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=OOUgwSFQ;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="N VWaEgI";
	spf=pass (imf31.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.147 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794475583;
	b=UPENwBbE/DUJpxL3Q04ZtANnfDRE4P//gdpvUgt5JHfk7sxnxJE/ZGPzJiCShRYJkLHP6L
	9d8mMpwvsA3zFsmkHwZiQApjZpAk49419hjuyB3yygzuAcIF2dBtq6rRV/UEW9s9iQ+bmF
	94bx4K44UZZ405htct41xECb++VwJ4k=
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfout.stl.internal (Postfix) with ESMTP id AED961D0025A
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 04:26:22 -0500 (EST)
Received: from ams-imap-03 ([10.64.2.23])
  by ams-compute-02.internal (MEProxy); Thu, 12 Nov 2026 04:26:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1794475573;
	 x=1794561973; bh=Lu9VyNMW3mU5a5OEl9u5/3DZxAvGGfoqPTt/S5UCjdA=; b=
	OOUgwSFQfbLVJHu/UOI1xbxzxT29rpy6sRLNcFMwVTBXzHNs1EcuKtWWiF0p0vMV
	pwgQH1sGEyg8X9BWJj9Z/NzKcXfcrv69W+X1rEzPCKgCj0h2bl3L3ihPDe2oLjYY
	zobAf3odv5III8Y4tHRH4h7KI6Zu2YAP1UhQkG7TLYGIF7ij7jyaOKtlnwbncIBt
	YYijyIAjywbzRp3ltvL9VcQ+OgsMOskRjbN5gFQ7kHc6RKUvcDzTn9Bv2ou+3eMQ
	+moij8YDdCQz1xPUNUyDy748IUxc03Vs5IiimdOyBTWHHVLADFFEPPRw9kr247dq
	eA1g8xF4ovQHK5pm56sqRA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1794475573; x=
	1794561973; bh=Lu9VyNMW3mU5a5OEl9u5/3DZxAvGGfoqPTt/S5UCjdA=; b=N
	VWaEgIOJNaSA6tI7c9inqYnE1uxJ1vlT9Fjg51KVxZqxAtQIwJxYCc+Yxxb7rrfn
	lqi1becGt5OevebJBN8V0kD4rsO7nanl9iJhWpW39+wqAcVowfsRChKO9vZj3XwM
	7NhuZpLuKr+pKPwEUlXfEC8HTZXygCfCxcVDP5ySwWAwgTE1ocLPnQU9k3YbVcrg
	8qPDj48hZiFbBg3pVGUGyWsocTCPYj+vZnwsb7ciMOC3xtR6G8+2aCSAIkSBkIfF
	MDY35u/n4XM4lh+7S50G0rTFS8IvB0y7JNUhkRyoe1XrzafTLgNWCU6E0BQ2ICEU
	o1x08xFRSCGrwAhYDzLTQ==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=arndb.de a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1794475573; d=arndb.de;
	mf=PGFybmRAYXJuZGIuZGU+; rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm2:rsa-sha256:dgoVgyIvKbzbhyVYXe+Je5CtmtwztLNha+/UJ9/YrxJfIAu
	YIhqhxSed54sX9FGDzm3Jm5jfqbUuFKE5UtKrwS5mZzxI29J2VME51rXegY571NR
	nl3krbw1RKhyL4Q7sCdTlVLbRiheMNBCT9XLJsvguRYKBQXZVQOGfnq3cyHav/YO
	luz7q+IC+8qRDyjdcz8dShZOowIT4RIeOsWs3kySZLHH+3aCqxr0gxw15M0eKlN6
	dkBJCBWhVXW/+OjUMaFAWzctfjyGBnwBqiIL3lLqhDG9Utk0cyeMTFLEWi5fXptT
	i+yjUUFq2eM49+aX+Uxpvao/M5gisaunnzLNawg==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-transfer-encoding,content-type,date,feedback-id,
	from,in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:lHtQvLsWKEfUdBxf+XVyTOgUlpH79KXAE43pmsNxrkU=:Zt3fqEzGcC9UmMEpGQAYwZ0fmVAGINXNyxE6QV2Knis=;
X-ME-Sender: <xms:J4b1aszZnXXmJXycTKT68GToSThX6hRpgSLl_4I6u4n_9y0ijscfDA>
    <xme:J4b1arHXgXG0E3ZLvA7HJOwMoR1J3526nRnSxn39ymzynPVz3tcJjXoKQqdwOqpDJ
    AeT-pkeNEL1EAxxeIv_exqlwG8lFva3ZbqaIZ3tJwi6d46YBYeiMr6m>
X-ME-Proxy-Cause: dmFkZTFWfgeeGR8mo+0U7OOkwDrigGQ4sGgOFZOIt6DyKqatgGiIKMzD3PV2KmRP46YBiF
    NN7VF9RNbZITkPsgZWpSOFDs2Hsgp/9VR+G7lO3+PQKbSnfTnKJELeW/wMgoAW5UIhwmdD
    NSL49KegZyyd7iwPktON7yNbn9dxeoKfVhWM9t2Io9/1BIHEHKTR0WotbG6kr8eFh2z+1b
    csxbAPpRQXO2C4GVfNYOGDOiPXISwylHCy4FaZ7cR6oRi/vJtPkZHGg3mRklsb0kNGxOVd
    DNAGk5hP/cEFOfJdJHRax64lA7dWq1eHZmhIG5RrznsMXvnmtyPlQ334MKerO1ZX5NuqBV
    GKnK5TATlSIwk4cWKGycpyTUodNZKF7vM4JxgjSDyU5c3JZMA/00XtklF92iMVX2n35r1M
    D/1BnTxNkAJQYU6IHiZtnAi+F9Kc5txc7hseFdo5PA6gwuLLPcpiIgVACKdGaO06xjKt6+
    eDS6tHC5JLF0NyKlfrEblcX91WlQ2m0ahg+JEq12dOeKhFtHqe72OYrIJRxH9aVIg4H37T
    QC9Hsu2aYqgpvUxhfN9yptOYqfhbjSb7ExkyhKIO3SlLEus47FmO1j/M7VmkJjnZFvCjAd
    +wpeLaOzhd2kTOw74kwWkYpnUq7IGz2Ntd9IYIHxAihCXh+HKjeLVoMLwTQg
X-ME-Proxy: <xmx:LIb1anFpYFUFUsNVtoim2Rg7LU1Tm3N1l3d1uUOvZWcowJ5OmXznLw>
    <xmx:LIb1autSZclqgSgCMjcYXfz7f3-TG4EIJFu13rcYRYlFv3xXvuqTzA>
    <xmx:LIb1akvxIJ80Do08wt6yzER2CcaT4RkBEgb7xl8huakw9lE5eJlL1w>
    <xmx:LIb1avHZkyKCDYHXN5bL4LY8EPvrUmq0Rhqocr6RmLq2C_LNQVrCwA>
    <xmx:NYb1ag6y-0KJmsy4GI_oyZKqDIFupBSr4UE9rN5CDa5GuRRBsmAx6rWK>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 1E26232A0099; Thu, 12 Nov 2026 04:25:59 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-ThreadId: AD8wiEBgakfZ
Date: Thu, 12 Nov 2026 10:25:28 +0100
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
Message-Id: <3eb60948-8fc9-4682-87c2-c113e54e7d4e@app.fastmail.com>
In-Reply-To: <32ad880e-5946-4703-9c6f-43ff59da39af@kernel.org>
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
Subject: Re: [PATCH 1/4] virtio_console: copy pipe buffers in splice_write()
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Stat-Signature: abqyanydnt8fg1t5tb34fdfdzwimni9k
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 8D53E20002
X-HE-Tag: 1794475583-961199
X-HE-Meta: U2FsdGVkX1/hgLacgji4wTVnv6FZav430KlZSK2ieWouf9jNQyjZjOJTg2eIcDpBKFcZwh8SBY4o2ImMaBracyYGSUp16ZxZxOa/WxkDLY0iRAFGipY99j/a9KBEL+1LsUHrxdi7GtuWXs8/wuCEs/qvFvAmabNXAermCbcmogTkzOg1XRJDARGU4MBKjAibypD+F2KGWTUIUhGIUnXhCumVoJkmpsPlteHwD+6bLDyyJtLML1zkeD+lKT00TlvE/dgBy9xdYWIhOlJfQKYtcoI36nWP5q93sAg5mcinQOoFwXHi0OcwgaOoTopb42lzqQCg3FDfSWvZE/c4uEtANiiGJoTYveeavsvTWsJdOb2FVkVCRh+a6ho0zkx/b2+KogvX2vI1TiErArDq/i3NmPAJ/3bYAePDNWIExvTrEcLS7NXB+nxkDdY9MqL43gW4ChlO4n9dIUGusafBEB+1gcCFDLXMk72mw2NobpJGCuSkLmB/+MLz4g9KkCsTsKVmLO5pdQbFggXjqnLhzn9OuJKqEsfRI/GJWeBnNfyQK6/ypKfup6WYqvU8dlrr+0kJqM0nvueZ0z1lx1ku6h0roHS9R8Vj4wkOOJbl2JvBiqbM0/jjuyLB7C6MO8YpKWX4lzvc96AyLSVqOsmyFvxr1d7wXEKezB3SwNwJGPixg76Ns7mrf6Gy+x/Yv8eFX/pvE4KIL44wfI+cUUvIIJiFMtKmUU2QCge/3ZniCchVfcJo5SlaEgQ5rQhiR2YfNL6IpuVeSjfNqUnhtygfVoaqcId+s+P/L4X2P8PgZo2Txk5UQxE/eVmI+eKvZsCaz0cZbW05qb93pr+3GWwKBHkqvXG973g3lHn6gbUNgmM8dnFWbbGpNH9HV+CviAgZeeV23B27y/VUWKysrOof4W97B91aAN4GRKqRKpZi1ntm3tuQVpL5T6CSqzkXHVkxJjM2SSyEzUmiCo7CkWKwL3e
 ovNpf3a+
 eY1xZQ0csYLX/jzz+X1cKYEeq/UXQnoS6qRcY891VJZlY1VqMR9LN9COtzLv2J2pGxSQ3rLywWEV4iX/cmE8TJm5YjIdirtWgRuyt0HsjI/ssPJxx2JTZUvIzwxSb3foVMJ6oWoIGmtYi1kGWvVch3fv1Eo+fkuoH2l5QtZmhny3LFy44P+E4FSgapDf468D+6miU9LtaqEyXhTI7zl5kTDkNjPn3n2mUxEdLhELfDZcc5v5vnIZpzT8lP28xYwhsScXWy79zvtGQS4RAei0h8mgLVxBzGUI/0iUSJve5vWJwV01jKvgzPFiFKHLpZFlP9+reeTxEDvrA5YPHfPR0djg3+AcCDbt6r16KO1JFueySe13U1aNNvy0DB8c/xWPrlHZFMiARLP2itG4D59IacF0EswZiop/uh8HpW+NcqrqkjApc6Xbf3rXGj7jyUEGhTtLwBfsjRW/JmlHtec4XVhgQ91mO9Z/ptXCn1hGPOUtElLE7H1u498brmKgvAsRxGrPUpUxlV/LZbUbaCvue0uqXCRsC9sVrpOJX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026, at 10:09, David Hildenbrand (Arm) wrote:
> On 11/12/26 09:55, Arnd Bergmann wrote:
>> On Wed, Nov 11, 2026, at 20:26, Linus Torvalds wrote:
>>
>> I tried to push for what I thought was an aggressive timeline
>> last year, but that would still keep the Arm bits for a couple more
>> LTS releases and only gradually reduce the scope of highmem in the
>> meantime, removing support from architectures, file systems, and
>> drivers where possible. See https://lwn.net/Articles/1051010/
>> for a summary of my talk in Tokyo, including the slides and
>> a link to the video for anyone wanting more details.
>> 
>> I also prepared a number of patches towards this, but have so
>> far not been great at following up to get them merged, sorry
>> about that.
>
> I think we can already start at removing CONFIG_HIGHPTE now, right?

Yes, I think my patch from two years ago still applies, see

https://lore.kernel.org/all/20241210160556.2341497-4-arnd@kernel.org/
https://lore.kernel.org/all/20241210160556.2341497-5-arnd@kernel.org/

If not, I can send you an updated version.

     Arnd

