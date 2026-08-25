Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F105C61DB9
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 13:11:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B87B6B008C; Tue, 25 Aug 2026 09:11:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 490B86B0092; Tue, 25 Aug 2026 09:11:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3587D6B0099; Tue, 25 Aug 2026 09:11:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 01FFF6B008C
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 09:11:19 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E1829C0407
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 13:11:18 +0000 (UTC)
X-FDA: 85139827836.09.44084FD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 1D1611C000C
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 13:11:17 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Vib8ZSXL;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787663477;
	b=zFrT856pclUXe4xSKPwgjWq1YFlO4BymtGcx/sZfRc9NfgoF23GVe7G9tECXBGfrVyEGi+
	Q0YL8du90PSrYcJZmbv6eHhJCZCNF90XIQSbrxOh5DZK7SJTe4Rhsyf1hPg9UprQPOKBJ3
	8ZEXT00xXIE6SDqEYTGwQjysVH6yN1A=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Vib8ZSXL;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787663477;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Iv9Rm6pjjqT/nsawEUFZYe9h9cDCxcBSarkn+EjrOcY=;
	b=fA5nruxFyRvHr53pVX/ebrUV16RmAg2tVfK++6SbEinux7M6krbuTvCK/klUHVGEJuTAUk
	hN6g0WBahCpsbLrjCHAfOdHLcqyY5L0Syhjc0Qf4sfhrlqOGNCTutUHqPpEfbSYz+Hdj16
	eVtoZKMCiSy/Uts9tymoEt/HK8ZYYio=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1D2BE43DBC;
	Tue, 25 Aug 2026 13:11:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A20261F00A3A;
	Tue, 25 Aug 2026 13:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787663476;
	bh=Iv9Rm6pjjqT/nsawEUFZYe9h9cDCxcBSarkn+EjrOcY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Vib8ZSXLUG/qKlTYQpkSyzCHH1MEAK5baFzVT0Ow2rxbFilAyMa/ZDrf0y24+2TTF
	 w+Kysuuxe+Uo9U/eeq3vBNDXQNlSLBqPcHJ9iW+V6QB3m+jPm1fE+4/tQwxoWu81M8
	 Gv94ljlMefMW2tq7c5+1z2x6WPnAGZFpczYUrCB+WPf9l2rsnh6z5EXCC0Dp65aQy0
	 9HkULbflOYSVwlnjZ1l5svfwi7pdRoBHi5ByFXjLiIcjJASXhDiiYhbnfvjjtL+cEM
	 RuRR2AePEUgbOZ5+pxs4Mj+zpPSJgGVY65BXSzFfaHErj7jkh26pneuZoq973gVCyj
	 gx+zzCo/ivnCQ==
Message-ID: <e0c589d0-d17b-48c2-8e1b-d41b69ecaadc@kernel.org>
Date: Tue, 25 Aug 2026 15:10:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 00/40] DEPT(DEPendency Tracker)
To: Byungchul Park <byungchul@sk.com>
Cc: linux-kernel@vger.kernel.org, max.byungchul.park@gmail.com,
 kernel_team@skhynix.com, torvalds@linux-foundation.org,
 damien.lemoal@opensource.wdc.com, linux-ide@vger.kernel.org,
 adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org, mingo@redhat.com,
 peterz@infradead.org, will@kernel.org, tglx@linutronix.de,
 rostedt@goodmis.org, joel@joelfernandes.org, sashal@kernel.org,
 daniel.vetter@ffwll.ch, duyuyang@gmail.com, johannes.berg@intel.com,
 tj@kernel.org, tytso@mit.edu, willy@infradead.org, david@fromorbit.com,
 amir73il@gmail.com, gregkh@linuxfoundation.org, kernel-team@lge.com,
 linux-mm@kvack.org, akpm@linux-foundation.org, mhocko@kernel.org,
 minchan@kernel.org, hannes@cmpxchg.org, vdavydov.dev@gmail.com,
 sj@kernel.org, jglisse@redhat.com, dennis@kernel.org, cl@linux.com,
 penberg@kernel.org, rientjes@google.com, vbabka@suse.cz, ngupta@vflare.org,
 linux-block@vger.kernel.org, josef@toxicpanda.com,
 linux-fsdevel@vger.kernel.org, jack@suse.cz, jlayton@kernel.org,
 dan.j.williams@intel.com, hch@infradead.org, djwong@kernel.org,
 dri-devel@lists.freedesktop.org, rodrigosiqueiramelo@gmail.com,
 melissa.srw@gmail.com, hamohammed.sa@gmail.com, harry.yoo@oracle.com,
 chris.p.wilson@intel.com, gwan-gyeong.mun@intel.com, boqun.feng@gmail.com,
 longman@redhat.com, yunseong.kim@ericsson.com, ysk@kzalloc.com,
 yeoreum.yun@arm.com, netdev@vger.kernel.org, matthew.brost@intel.com,
 her0gyugyu@gmail.com, corbet@lwn.net, catalin.marinas@arm.com, bp@alien8.de,
 x86@kernel.org, hpa@zytor.com, luto@kernel.org, sumit.semwal@linaro.org,
 gustavo@padovan.org, christian.koenig@amd.com, andi.shyti@kernel.org,
 arnd@arndb.de, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 rppt@kernel.org, surenb@google.com, mcgrof@kernel.org, petr.pavlu@suse.com,
 da.gomez@kernel.org, samitolvanen@google.com, paulmck@kernel.org,
 frederic@kernel.org, neeraj.upadhyay@kernel.org, joelagnelf@nvidia.com,
 josh@joshtriplett.org, urezki@gmail.com, mathieu.desnoyers@efficios.com,
 jiangshanlai@gmail.com, qiang.zhang@linux.dev, juri.lelli@redhat.com,
 vincent.guittot@linaro.org, dietmar.eggemann@arm.com, bsegall@google.com,
 mgorman@suse.de, vschneid@redhat.com, chuck.lever@oracle.com,
 neil@brown.name, okorniev@redhat.com, Dai.Ngo@oracle.com, tom@talpey.com,
 trondmy@kernel.org, anna@kernel.org, kees@kernel.org, bigeasy@linutronix.de,
 clrkwllms@kernel.org, mark.rutland@arm.com, ada.coupriediaz@arm.com,
 kristina.martsenko@arm.com, wangkefeng.wang@huawei.com, broonie@kernel.org,
 kevin.brodsky@arm.com, dwmw@amazon.co.uk, shakeel.butt@linux.dev,
 ast@kernel.org, ziy@nvidia.com, yuzhao@google.com,
 baolin.wang@linux.alibaba.com, usamaarif642@gmail.com,
 joel.granados@kernel.org, richard.weiyang@gmail.com,
 geert+renesas@glider.be, tim.c.chen@linux.intel.com, linux@treblig.org,
 alexander.shishkin@linux.intel.com, lillian@star-ark.net,
 chenhuacai@kernel.org, francesco@valla.it, guoweikang.kernel@gmail.com,
 link@vivo.com, jpoimboe@kernel.org, masahiroy@kernel.org,
 brauner@kernel.org, thomas.weissschuh@linutronix.de, oleg@redhat.com,
 mjguzik@gmail.com, andrii@kernel.org, wangfushuai@baidu.com,
 linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
 linux-i2c@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-modules@vger.kernel.org, rcu@vger.kernel.org,
 linux-nfs@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 2407018371@qq.com, dakr@kernel.org, miguel.ojeda.sandonis@gmail.com,
 neilb@ownmail.net, bagasdotme@gmail.com, wsa+renesas@sang-engineering.com,
 dave.hansen@intel.com, geert@linux-m68k.org, ojeda@kernel.org,
 alex.gaynor@gmail.com, gary@garyguo.net, bjorn3_gh@protonmail.com,
 lossin@kernel.org, a.hindborg@kernel.org, aliceryhl@google.com,
 tmgross@umich.edu, rust-for-linux@vger.kernel.org
References: <20260706061928.66713-1-byungchul@sk.com>
 <359ea967-9b97-4584-88e6-bddb4044de2e@kernel.org>
 <20260821042143.GA40890@system.software.com>
 <825134a8-ceae-430c-b2fc-d1d0c7240f39@kernel.org>
 <20260825121322.GA23086@system.software.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260825121322.GA23086@system.software.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 1D1611C000C
X-Rspam-User: 
X-Stat-Signature: 15t5fhd9ajzkapam6yi8t81gjxgrags4
X-Rspamd-Server: rspam06
X-HE-Tag: 1787663477-642624
X-HE-Meta: U2FsdGVkX19d6uHEpR+2rX9xKo331USCOeyIpGTe2AuF6xBPeT2E7MMts93TgSBjm1LJ3gDHnxOARgZ7w0H3zj9tNRAtIna0ZeegLxfkon1XTeToa26bRZzYNyzzIuibxHJAxbL7HE9i3MMPAMYOlwd+Dw0hnXF0ZtkrYJrwg++7WkLs1RN+MLYkw+v0Pg2ZjxVNDVbFb7yZ6UtI2hhdroviRewoX2yO9LimTaH5L0eysnd7R8bxIJFl1jLrhH3uqKVODfcz3GHMmwGZOIA7EwN4KLeftaiQBYoNOEt/WTEFp6QuNRqVKYeywUzcDczPytUKp48rJjMp77lvioqIlUx8odL8nVvb3iSn2qSXFfa8JnWCDhPGvXpeUkN7rX3srawctyZyqunCRKScFFPH07cCcEgg+FDhqSK8KU9EX2AR3nKBWBnh/Cv/Ecs3GzzUtPuKysZw1Ge4CV6hcAJQWMpS8elt8fkk5RtScCNss/bBkJAfu/MKywDsOkvqCE4A7Tdb6+h3ND4Up4bvrmEE4ji/kO/B8exRO1SDsRgf4bXRZYs15BZ7kdBGSplDyNl3vj1F/swhniWvyPOSfOYKIG07vYhT76nK6cK/r3ZSWHCL0K5Nokbq5kMzhMNPHg6T1PrRmNp5VOsSTfe2cuUVkpQwXZm8WC+kSyTCGTZa3y0v760658SK9xHY8Lt0Nb/xIZqNxqIKVRa1Q29KUUHI+64eR7klPzDlnFRIU/2oMixiDj1ba93rVWAziAt7Kc3t8h+W6c/AKwdNi0iXn/xT+TZbt0o1hWMLTRX33ddR/jxiS1SvkjQz7FqUxzTCv7KB4svGu4BwwLQw1mswNw1xxHCpfjgQq5jOEWx+DjNPEx0h8JAuBiOBU5+sUyRNiTgoy1uDsXEQdg7rWBkAGbZzxn5AtdaRjav5LFxtz+qmZySYvy+VRyVvqXf21L9459wup0W6Nba9nMUIPZF63WS
 E0pFddeK
 zIi5XFcSN9wamQMBtfkKDWHYAIQkDMj0rpY/B/3K/Rcdp3Bpe3SOt4zQ+g2cJiE5wWQCIWpifdEzIHJh2MoHxpmVN1Tks4KmvYyjvkegoWYev5V/44eQ+8r0T7oAX1rAG3CORS7SVtm3Lv+7SF4WUMH+3XvVXvZoH2mjRtloBl95aZSXWSuO7mAwH6m0sd0G7Cr/JcRrcjxa88HfYGr+QfGK2lCfJQUo+VJ+70cOtZu2LXfWjP7QMPRaOrluJPGHI38145ODGuwxuyDfhFv2ZL5B8gWixSZiMfgyeUVp+Pw7Svxzx10/SzEOYjQii+9Ajnh+NDENN6mIIL95716eQKWDDOw44TVWSbQAV3InT/JHnoJe+Oo5BJg3Acg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>
>> As the saying goes, it's hard to teach old dogs new tricks, but in the end
>> taking care of two dogs is likely harder than only a single dog? :)
> 
> Or it's better to train a unmatured hunting dog than to teach a pet dog,
> how to hunt, for better hunting, even though the pet dog might
> eventually become able to.

I'm not sure whether "pet dog" is the right analogy to lockdep in that scenario,
though ;)

-- 
Cheers,

David

